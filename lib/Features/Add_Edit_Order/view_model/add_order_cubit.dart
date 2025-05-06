import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Core/Utilts/Image_Compressor.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/FileUpload_Widget.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
part 'add_order_state.dart';

class AddNewOrderCubit extends Cubit<AddNewOrderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AddNewOrderCubit() : super(AddNewOrderInitial());
  static AddNewOrderCubit get(context) => BlocProvider.of(context);

  bool isLoading = false;
  final SupabaseClient supabase = Supabase.instance.client;

  void changeLoading() {
    isLoading = !isLoading;
    emit(ChangeLoading());
  }

  Future<File> compressImage(File file) async {
    // قراءة الملف وتحويله إلى صورة
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(Uint8List.fromList(bytes));

    // ضغط الصورة (مثلاً إلى 50% من الحجم الأصلي)
    final compressedImage = img.encodeJpg(image!, quality: 50);

    // حفظ الصورة المضغوطة إلى ملف جديد
    final compressedFile = File('${file.parent.path}/compressed_${file.path}');
    await compressedFile.writeAsBytes(compressedImage);

    return compressedFile;
  }

  /// إنشاء رقم طلب جديد تلقائيًا بالتنسيق المطلوب: السنة/الرقم التسلسلي
  Future<String> generateOrderNumber() async {
    final int currentYear = DateTime.now().year;

    try {
      // البحث عن الطلبات الموجودة في السنة الحالية
      final QuerySnapshot ordersSnapshot = await _firestore
          .collection('orders')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(currentYear, 1, 1)))
          .where('createdAt', isLessThan: Timestamp.fromDate(DateTime(currentYear + 1, 1, 1)))
          .get();

      // حساب عدد الطلبات + 1 للحصول على الرقم الجديد
      final int orderCount = ordersSnapshot.docs.length + 1;

      // تنسيق الرقم بحيث يكون دائمًا 3 أرقام (مثال: 001, 012, 123)
      final String formattedNumber = orderCount.toString().padLeft(3, '0');

      // إرجاع الرقم بالتنسيق المطلوب: السنة/الرقم
      return '$formattedNumber/$currentYear';
    } catch (e) {
      log('Error generating order number: $e');
      // في حالة حدوث خطأ، نرجع رقمًا افتراضيًا
      return '001/$currentYear';
    }
  }

  Future addOrder({
    String? orderNumber, // جعلناه اختياريًا
    required String companyName,
    required String supplyNumber,
    required String attachmentType,
    required DateTime dateLine,
    required String orderStatus,
    required List items,
    required List<FileAttachment> attachments,
  }) async {
    emit(AddOrderLoading());
    changeLoading();
    try {
      final orderRef = _firestore.collection('orders').doc();
      final itemsRef = orderRef.collection('items');

      // توليد رقم الطلب تلقائيًا إذا لم يتم تحديده
      final String autoOrderNumber = orderNumber ?? await generateOrderNumber();

      // 1. Upload files to Supabase with compression
      List uploadedUrls = [];

      for (final attachment in attachments) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${attachment.fileName}';
        final filePath = 'orders/${orderRef.id}/$fileName';

        if (kIsWeb) {
          // Web platform handling
          Uint8List bytesToUpload;

          // Get bytes from the attachment
          final bytes = await attachment.getBytes();
          bytesToUpload = bytes;

          // Upload bytes to Supabase
          await supabase.storage
              .from('storage')
              .uploadBinary(filePath, bytesToUpload);
        } else {
          // Upload the file to Supabase
          await supabase.storage
              .from('storage')
              .upload(filePath, attachment.fileObject);
        }

        // Get the public URL
        final fileUrl = supabase.storage.from('storage').getPublicUrl(filePath);
        uploadedUrls.add(fileUrl);
      }

      // 2. Prepare order data
      final orderData = {
        'id': orderRef.id,
        'orderNumber': autoOrderNumber, // استخدام الرقم المولد تلقائيًا
        'companyName': companyName,
        'supplyNumber': supplyNumber,
        'dateLine': Timestamp.fromDate(dateLine),
        'orderStatus': orderStatus,
        'itemCount': items.length,
        'attachmentLinks': uploadedUrls,
        'attachmentType': attachmentType,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      // 3. Create a batch write
      final batch = _firestore.batch();
      batch.set(orderRef, orderData);

      // 4. Add all order items
      for (final item in items) {
        final itemRef = itemsRef.doc(item.id);
        batch.set(itemRef, item.toMap());
      }

      // 5. Commit the batch
      await batch.commit();
      changeLoading();
      emit(AddOrderSuccess(orderRef.id));
    } catch (e) {
      log('Error adding order: $e');
      changeLoading();
      emit(AddOrderError(e.toString()));
    }
  }
}
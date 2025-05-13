import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Core/Serviecs/Firebase_Notification.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/FileUpload_Widget.dart';
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
      log('Error generating order_complete number: $e');
      // في حالة حدوث خطأ، نرجع رقمًا افتراضيًا
      return '001/$currentYear';
    }
  }

  Future addOrder({
    String? orderNumber,
    required String companyName,
    required String supplyNumber,
    required String attachmentType,
    required DateTime dateLine,
    required String orderStatus,
    required List items,
    required List<FileAttachment> attachments,
    required List<FileAttachment> attachmentsOrder, // ✅ إضافة هذا
  }) async {
    emit(AddOrderLoading());
    changeLoading();
    try {
      final orderRef = _firestore.collection('orders').doc();
      final itemsRef = orderRef.collection('items');

      final String autoOrderNumber = orderNumber ?? await generateOrderNumber();

      // ✅ رفع ملفات attachments
      List<String> uploadedUrls = [];
      for (final attachment in attachments) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${attachment.fileName}';
        final filePath = 'orders/${orderRef.id}/$fileName';

        if (kIsWeb) {
          final bytes = await attachment.getBytes();
          await supabase.storage.from('storage').uploadBinary(filePath, bytes);
        } else {
          await supabase.storage.from('storage').upload(filePath, attachment.fileObject);
        }

        final fileUrl = supabase.storage.from('storage').getPublicUrl(filePath);
        uploadedUrls.add(fileUrl);
      }

      // ✅ رفع ملفات attachmentsOrder
      List<String> uploadedOrderUrls = [];
      for (final attachment in attachmentsOrder) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${attachment.fileName}';
        final filePath = 'orders/${orderRef.id}/order_docs/$fileName';

        if (kIsWeb) {
          final bytes = await attachment.getBytes();
          await supabase.storage.from('storage').uploadBinary(filePath, bytes);
        } else {
          await supabase.storage.from('storage').upload(filePath, attachment.fileObject);
        }

        final fileUrl = supabase.storage.from('storage').getPublicUrl(filePath);
        uploadedOrderUrls.add(fileUrl);
      }

      // ✅ تجهيز بيانات الطلب مع روابط الملفات المرفوعة
      final orderData = {
        'id': orderRef.id,
        'orderNumber': autoOrderNumber,
        'companyName': companyName,
        'supplyNumber': supplyNumber,
        'dateLine': Timestamp.fromDate(dateLine),
        'orderStatus': orderStatus,
        'itemCount': items.length,
        'attachmentLinks': uploadedUrls,
        'attachmentOrderLinks': uploadedOrderUrls, // ✅ إضافة روابط المرفقات الأخرى
        'attachmentType': attachmentType,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      final batch = _firestore.batch();
      batch.set(orderRef, orderData);

      for (final item in items) {
        final itemRef = itemsRef.doc(item.id);
        batch.set(itemRef, item.toMap());
      }

      await batch.commit();
      changeLoading();
      await NotificationHelper.sendNotificationToAllUsers(title: 'أمر توريد جديد', body: 'هناك أمر توريد جديد,\n اضغط لمعرفه المزيد', topic: 'all_users');
      emit(AddOrderSuccess(orderRef.id));
    } catch (e) {
      log('Error adding order_complete: $e');
      changeLoading();
      emit(AddOrderError(e.toString()));
    }
  }

}
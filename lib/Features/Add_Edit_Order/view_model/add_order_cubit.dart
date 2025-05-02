import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/FileUpload_Widget.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'add_order_state.dart';

class AddNewOrderCubit extends Cubit<AddNewOrderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  AddNewOrderCubit() : super(AddNewOrderInitial());
  static AddNewOrderCubit get(context) => BlocProvider.of(context);

  bool isLoading = false;
  final SupabaseClient supabase = Supabase.instance.client;


void changeLoading()
{
  isLoading = !isLoading;
  emit(ChangeLoading());
}



  Future<void> addOrder({
    required String orderNumber,
    required String companyName,
    required String supplyNumber,
    required String attachmentType,
    required DateTime dateLine,
    required String orderStatus,
    required List<OrderItem> items,
    required List<FileAttachment> attachments,
  }) async {
    emit(AddOrderLoading());
    changeLoading();
    try {
      final orderRef = _firestore.collection('orders').doc();
      final itemsRef = orderRef.collection('items');

      // 1. Upload files to Supabase
      List<String> uploadedUrls = [];

      for (final attachment in attachments) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${attachment.fileName}';
        final filePath = 'orders/${orderRef.id}/$fileName';

        // Upload the file to Supabase
        await supabase.storage
            .from('storage')
            .upload(filePath, attachment.path);

        // Get the public URL
        final fileUrl = supabase.storage
            .from('storage')
            .getPublicUrl(filePath);

        uploadedUrls.add(fileUrl);
      }

      // 2. Prepare order data
      final orderData = {
        'id': orderRef.id,
        'orderNumber': orderNumber,
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
      log('eee$e');
      changeLoading();
      emit(AddOrderError(e.toString()));
    }
  }



}

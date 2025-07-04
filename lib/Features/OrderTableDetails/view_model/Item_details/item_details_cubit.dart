
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Core/Serviecs/Firebase_Notification.dart';
import 'package:quality_management_system/Core/Utilts/Format_Time.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/FileUpload_Widget.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'item_details_state.dart';

class ItemDetailsCubit extends Cubit<ItemDetailsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ItemDetailsCubit() : super(ItemDetailsInitial());

  static ItemDetailsCubit get(context) => BlocProvider.of(context);


  Future<List<OrderItem>> getOrderItems(String orderId) async {
    emit(OrderItemsLoading());

    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .doc(orderId)
          .collection('items')
          .get();

      final items = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return OrderItem(
          id: doc.id,
          operationDescription: data['operationDescription'] ?? '',
          status: data['status'] ?? '',
          quantity: (data['quantity'] as num).toInt(),
          materialType: data['materialType'] ?? '',
          notes: data['notes'] ?? '',
          deliveryDate: data['deliveryDate'] ?? '',
          attachments: List<String>.from(data['attachments'] ?? []),
          unitPrice: 100
        );
      }).toList();

      emit(OrderItemsLoaded(items));
      return items;
    } catch (e) {
      emit(OrderItemLoddedError('Failed to load order_complete items: ${e.toString()}'));
      throw Exception('Failed to load order_complete items');
    }
  }

  Future<void> updateItemStatus(String orderId, String itemId, String newStatus, String itemName) async {
    try {
      final updateData = {'status': newStatus};

      if (newStatus == 'Completed') {
        updateData['deliveryDate'] = DateFormatter.formatDate(DateTime.now());
        await NotificationHelper.sendNotificationToAllUsers(title: 'تم انتهاء من بند', body: 'انتهي عمل بند:  ${itemName}', topic: 'all_users');
      } else {
        updateData['deliveryDate'] = '';
        await NotificationHelper.sendNotificationToAllUsers(title: 'تم تغيير حاله بند', body: 'تم تغيير حاله بند: ${itemName} الي ${newStatus}', topic: 'all_users');

      }

      await _firestore
          .collection('orders')
          .doc(orderId)
          .collection('items')
          .doc(itemId)
          .update(updateData);
    } catch (e) {
      throw Exception('Failed to update item status');
    }
  }


  Future<void> updateOrderStatus(String orderId, String itemId, String newStatus) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'orderStatus': newStatus});
    } catch (e) {
      throw Exception('Failed to update item status');
    }
  }



  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> sendAttachment({
    required String orderId,
    required List<FileAttachment> attachments,
  }) async {
    emit(sendAttachmentLoading());
    try {
      final orderRef = _firestore.collection('orders').doc(orderId);
      final batch = _firestore.batch();

      // ✅ Upload files to Supabase storage
      List<String> uploadedUrls = [];
      for (final attachment in attachments) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${attachment.fileName}';
        final filePath = 'orders_PO/$orderId/$fileName';

        if (kIsWeb) {
          final bytes = await attachment.getBytes();
          await supabase.storage.from('storage').uploadBinary(filePath, bytes);
        } else {
          await supabase.storage.from('storage').upload(filePath, attachment.fileObject);
        }

        final fileUrl = supabase.storage.from('storage').getPublicUrl(filePath);
        uploadedUrls.add(fileUrl);
      }

      // ✅ Update attachment_po links in Firestore
      batch.update(orderRef, {
        'attachmentPO': FieldValue.arrayUnion(uploadedUrls),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      await NotificationHelper.sendNotificationToAllUsers(
          title: 'تم رفع مرفقات تحصيل',
          body: 'هناك مرفقات تحصيل جديده',
          topic: 'admin'
      );

      emit(AddAttachmentSuccess());
    } catch (e) {
      log('Error adding attachments: $e');
      emit(OrderItemLoddedError(e.toString()));
    }
  }
}

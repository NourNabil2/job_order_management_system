
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';

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
          attachments: List<String>.from(data['attachments'] ?? []),
          unitPrice: 100
        );
      }).toList();

      emit(OrderItemsLoaded(items));
      return items;
    } catch (e) {
      emit(OrderItemLoddedError('Failed to load order items: ${e.toString()}'));
      throw Exception('Failed to load order items');
    }
  }

  Future<void> updateItemStatus(String orderId, String itemId, String newStatus) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .collection('items')
          .doc(itemId)
          .update({'status': newStatus});
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
}

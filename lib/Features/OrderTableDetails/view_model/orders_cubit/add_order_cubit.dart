import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Core/Utilts/Format_Time.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';

part 'add_order_state.dart';

class OrdersCubit extends Cubit<AddOrderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<OrderModel>>? _ordersStream;

  OrdersCubit() : super(AddOrderInitial()) {
    _setupOrdersStream();
  }

  static OrdersCubit get(context) => BlocProvider.of(context);

  /// ---------------- functions -----------------///
  void sortOrders<T extends Comparable>(
      List<OrderModel> orders,
      T Function(OrderModel order) getField,
      bool ascending,
      ) {
    orders.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    emit(OrdersLoaded(List.from(orders)));
  }

  void _setupOrdersStream() {
    _ordersStream = _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => _mapDocumentToOrder(doc))
        .toList());

    // تحديث الحالة عند تغيير البيانات
    _ordersStream?.listen((orders) {
      emit(OrdersLoaded(orders));
    });
  }

  OrderModel _mapDocumentToOrder(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final createdAt = (data['createdAt'] as Timestamp).toDate();
    final dateLine = (data['dateLine'] as Timestamp).toDate();

    return OrderModel(
      id: doc.id,
      orderNumber: data['orderNumber'] ?? '',
      companyName: data['companyName'] ?? '',
      supplyNumber: data['supplyNumber'] ?? '',
      attachmentType: data['attachmentType'] ?? '',
      itemCount: (data['itemCount'] as num).toDouble(),
      date: DateFormatter.formatDate(createdAt),
      dateLine: DateFormatter.formatDate(dateLine),
      attachmentLinks: List<String>.from(data['attachmentLinks'] ?? []),
      attachmentPO: List<String>.from(data['attachmentPO'] ?? []),
      attachmentOrderLinks: List<String>.from(data['attachmentOrderLinks'] ?? []),
      orderStatus: data['orderStatus'] ?? 'Pending',
    );
  }

  /// Fetch order items for a specific order
  Future<List<OrderItem>> fetchOrderItems(String orderId) async {
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
      emit(OrderItemsError('Failed to fetch order items: $e'));
      return [];
    }
  }

  /// Fetch order items stream for real-time updates
  Stream<List<Map<String, dynamic>>> getOrderItemsStream(String orderId) {
    return _firestore
        .collection('orders')
        .doc(orderId)
        .collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        ...data,
      };
    }).toList());
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Core/Utilts/Format_Time.dart';
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
  void sortOrders<T>(
      List<OrderModel> orders,
      Comparable<T> Function(OrderModel order) getField,
      bool ascending,
      ) {
    orders.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    emit(OrdersLoaded(List<OrderModel>.from(orders)));
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
      attachmentOrderLinks: List<String>.from(data['attachmentOrderLinks'] ?? []),
      orderStatus: data['orderStatus'] ?? 'Pending',
    );
  }

}
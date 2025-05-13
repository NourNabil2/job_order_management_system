import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Core/Utilts/Format_Time.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';

part 'order_collected_state.dart';

class OrderCollectedCubit extends Cubit<OrderCollectedState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<OrderModel>>? _ordersStream;
  OrderCollectedCubit() : super(OrderCollectedInitial()){
    _setupOrdersStream();
  }

  static OrderCollectedCubit get(context) => BlocProvider.of(context);
  /// ---------------- functions -----------------///
  void sortOrders<T>(
      List<OrderModel> orders,
      Comparable<T> Function(OrderModel order) getField,
      bool ascending,
      ) {
    try {
      orders.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
      emit(OrderFilterLodded(List<OrderModel>.from(orders)));
    } catch (e) {
      emit(OrderFilterLoddedError("Sorting error: $e"));
    }
  }


  void _setupOrdersStream() {
    _ordersStream = _firestore
        .collection('orders')
        .where('orderStatus', isEqualTo: 'Collected')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => _mapDocumentToOrder(doc))
        .toList());

    _ordersStream?.listen((orders) {
      if (orders.isEmpty) {
        emit(OrderFilterEmpty());
      } else {
        emit(OrderFilterLodded(orders));
      }
    }, onError: (error) {

      emit(OrderFilterLoddedError(error.toString()));
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
      attachmentPO: List<String>.from(data['attachmentPO'] ?? []),
      orderStatus: data['orderStatus'] ?? 'Pending',
    );
  }
}

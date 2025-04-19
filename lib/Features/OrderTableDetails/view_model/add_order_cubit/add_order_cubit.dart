import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';

part 'add_order_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<OrderModel>>? _ordersStream;

  AddOrderCubit() : super(AddOrderInitial()) {
    _setupOrdersStream();
  }

  static AddOrderCubit get(context) => BlocProvider.of(context);

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
    return OrderModel(
      id: doc.id,
      orderNumber: data['orderNumber'] ?? '',
      companyName: data['companyName'] ?? '',
      supplyNumber: data['supplyNumber'] ?? '',
      itemCount: (data['itemCount'] as num).toDouble(),
      date: (data['createdAt'] as Timestamp).toDate(),
      dateLine: (data['dateLine'] as Timestamp).toDate(),
      orderStatus: data['orderStatus'] ?? 'Pending',
    );
  }

  Future<void> addOrder({
    required String orderNumber,
    required String companyName,
    required String supplyNumber,
    required double itemCount,
    required DateTime dateLine,
    required String orderStatus,
  }) async {
    emit(AddOrderLoading());

    try {
      final docRef = _firestore.collection('orders').doc();

      final newOrder = {
        'id': docRef.id,
        'orderNumber': orderNumber,
        'companyName': companyName,
        'supplyNumber': supplyNumber,
        'itemCount': itemCount,
        'dateLine': Timestamp.fromDate(dateLine),
        'orderStatus': orderStatus,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      await docRef.set(newOrder);
      emit(AddOrderSuccess(docRef.id));
    } catch (e) {
      emit(AddOrderError(e.toString()));
    }
  }
}
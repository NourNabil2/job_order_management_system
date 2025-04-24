import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Core/Utilts/Format_Time.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';

part 'add_order_state.dart';

class AddNewOrderCubit extends Cubit<AddNewOrderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  AddNewOrderCubit() : super(AddNewOrderInitial());
  static AddNewOrderCubit get(context) => BlocProvider.of(context);


  Future<void> addOrder({
    required String orderNumber,
    required String companyName,
    required String supplyNumber,
    required String attachmentType,
    required DateTime dateLine,
    required String orderStatus,
    required List<OrderItem> items,
  }) async {
    emit(AddOrderLoading());

    try {
      // إنشاء مرجع للطلب الرئيسي
      final orderRef = _firestore.collection('orders').doc();

      // إنشاء مرجع لمجموعة البنود الفرعية
      final itemsRef = orderRef.collection('items');

      // بيانات الطلب الأساسية
      final orderData = {
        'id': orderRef.id,
        'orderNumber': orderNumber,
        'companyName': companyName,
        'supplyNumber': supplyNumber,
        'dateLine': Timestamp.fromDate(dateLine),
        'orderStatus': orderStatus,
        'itemCount': items.length,
        'attachmentType': attachmentType,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      // تنفيذ العملية كمجموعة واحدة (Batch)
      final batch = _firestore.batch();

      // إضافة الطلب الرئيسي
      batch.set(orderRef, orderData);

      // إضافة جميع البنود
      for (final item in items) {
        final itemRef = itemsRef.doc(item.id);
        batch.set(itemRef, item.toMap());
      }

      // تنفيذ العملية
      await batch.commit();

      emit(AddOrderSuccess(orderRef.id));
    } catch (e) {
      emit(AddOrderError(e.toString()));
    }
  }

}

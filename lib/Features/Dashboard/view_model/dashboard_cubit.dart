import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Core/Utilts/Format_Time.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  static DashboardCubit get(context) => BlocProvider.of(context);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());

    try {
      final ordersSnapshot = await _firestore.collection('orders').get();
      final usersSnapshot = await _firestore.collection('Users').get();

      final orders = ordersSnapshot.docs;
      final totalOrders = orders.length;

      int completedOrders = 0;
      int pendingOrders = 0;
      int rejectedOrders = 0;
      int in_progress = 0;

      DateTime? nearestDeadline;
      String? nearestOrderNumber;

      for (final doc in orders) {
        final status = doc['orderStatus']?.toString().toLowerCase() ?? '';

        if (status == 'completed' || status == 'delivered') {
          completedOrders++;
        } else if (status == 'pending') {
          pendingOrders++;
        } else if (status == 'rejected') {
          rejectedOrders++;
        } else if (status == 'in_progress')
          {
            in_progress++;
          }

        final dateLineTimestamp = doc['dateLine'] as Timestamp?;
        if (dateLineTimestamp != null) {
          final deadline = dateLineTimestamp.toDate();
          if (nearestDeadline == null || deadline.isBefore(nearestDeadline)) {
            nearestDeadline = deadline;
            nearestOrderNumber = doc['orderNumber']?.toString() ?? '';
          }
        }
      }

      final userCount = usersSnapshot.size;

      final formattedDeadlineWithOrder = nearestDeadline != null
          ? '${DateFormatter.formatDate(nearestDeadline)} - رقم $nearestOrderNumber'
          : 'لا يوجد موعد متاح';

      emit(DashboardLoaded(
        userCount: userCount,
        totalOrders: totalOrders,
        completedOrders: completedOrders,
        pendingOrders: pendingOrders,
        rejectedOrders: rejectedOrders,
        inProgress: in_progress,
        nearestDeadlineWithOrder: formattedDeadlineWithOrder,
      ));
    } catch (e) {
      emit(DashboardError('فشل تحميل البيانات: ${e.toString()}'));
    }
  }
}

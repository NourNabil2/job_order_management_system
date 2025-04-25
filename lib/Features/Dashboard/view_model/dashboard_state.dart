part of 'dashboard_cubit.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int userCount;
  final int totalOrders;
  final int completedOrders;
  final int pendingOrders;
  final int rejectedOrders;
  final String nearestDeadlineWithOrder;

  DashboardLoaded({
    required this.userCount,
    required this.totalOrders,
    required this.completedOrders,
    required this.pendingOrders,
    required this.rejectedOrders,
    required this.nearestDeadlineWithOrder,
  });
}


class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}

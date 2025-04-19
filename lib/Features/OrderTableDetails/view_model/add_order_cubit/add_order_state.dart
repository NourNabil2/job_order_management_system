part of 'add_order_cubit.dart';

@immutable
sealed class AddOrderState {}

final class AddOrderInitial extends AddOrderState {}

class AddOrderLoading extends AddOrderState {}

class AddOrderSuccess extends AddOrderState {
  final String orderId;
  AddOrderSuccess(this.orderId);
}
class AddOrderError extends AddOrderState {
  final String error;
  AddOrderError(this.error);
}

class OrdersLoaded extends AddOrderState {
  final List<OrderModel> orders;
  OrdersLoaded(this.orders);
}
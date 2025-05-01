part of 'add_order_cubit.dart';

@immutable
sealed class AddOrderState {}

final class AddOrderInitial extends AddOrderState {}

class OrderLoddedError extends AddOrderState {
  final String error;
  OrderLoddedError(this.error);
}

class OrdersLoaded extends AddOrderState {
  final List<OrderModel> orders;
  OrdersLoaded(this.orders);
}




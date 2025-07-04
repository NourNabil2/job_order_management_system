part of 'add_order_cubit.dart';

@immutable
abstract class AddOrderState {}

class AddOrderInitial extends AddOrderState {}

class OrdersLoaded extends AddOrderState {
  final List<OrderModel> orders;

  OrdersLoaded(this.orders);
}

class OrderLoddedError extends AddOrderState {
  final String error;

  OrderLoddedError(this.error);
}

// New states for order items
class OrderItemsLoading extends AddOrderState {}

class OrderItemsLoaded extends AddOrderState {
  final List<OrderItem> orderItems;

  OrderItemsLoaded(this.orderItems);
}

class OrderItemsError extends AddOrderState {
  final String error;

  OrderItemsError(this.error);
}
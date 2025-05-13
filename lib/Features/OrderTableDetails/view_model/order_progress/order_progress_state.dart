part of 'order_progress_cubit.dart';

@immutable
sealed class OrderProgressState {}

final class OrderProgressInitial extends OrderProgressState {}

class OrderFilterLodded extends OrderProgressState {
  final List<OrderModel> orders;

  OrderFilterLodded(this.orders);
}

class OrderFilterNewOrder extends OrderProgressState {
  final List<OrderModel> orders;

  OrderFilterNewOrder(this.orders);
}

class OrderFilterEmpty extends OrderProgressState {}

class OrderFilterLoddedError extends OrderProgressState {
  final String error;

  OrderFilterLoddedError(this.error);
}

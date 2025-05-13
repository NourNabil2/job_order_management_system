part of 'order_filter_cubit.dart';

@immutable
abstract class OrderFilterState {}

class OrderFilterInitial extends OrderFilterState {}

class OrderFilterLodded extends OrderFilterState {
  final List<OrderModel> orders;

  OrderFilterLodded(this.orders);
}

class OrderFilterNewOrder extends OrderFilterState {
  final List<OrderModel> orders;

  OrderFilterNewOrder(this.orders);
}

class OrderFilterEmpty extends OrderFilterState {}

class OrderFilterLoddedError extends OrderFilterState {
  final String error;

  OrderFilterLoddedError(this.error);
}

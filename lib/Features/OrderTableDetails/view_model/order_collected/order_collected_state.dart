part of 'order_collected_cubit.dart';

@immutable
sealed class OrderCollectedState {}

final class OrderCollectedInitial extends OrderCollectedState {}

class OrderFilterLodded extends OrderCollectedState {
  final List<OrderModel> orders;

  OrderFilterLodded(this.orders);
}

class OrderFilterEmpty extends OrderCollectedState {}

class OrderFilterLoddedError extends OrderCollectedState {
  final String error;

  OrderFilterLoddedError(this.error);
}
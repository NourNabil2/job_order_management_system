part of 'order_complete_cubit.dart';

@immutable
sealed class OrderCompleteState {}

final class OrderCompleteInitial extends OrderCompleteState {}

class OrderFilterLodded extends OrderCompleteState {
  final List<OrderModel> orders;

  OrderFilterLodded(this.orders);
}

class OrderFilterEmpty extends OrderCompleteState {}

class OrderFilterLoddedError extends OrderCompleteState {
  final String error;

  OrderFilterLoddedError(this.error);
}

part of 'add_order_cubit.dart';

@immutable
sealed class AddNewOrderState {}

final class AddNewOrderInitial extends AddNewOrderState {}

class AddOrderLoading extends AddNewOrderState {}

class ChangeLoading extends AddNewOrderState {}

class AddOrderSuccess extends AddNewOrderState {
  final String orderId;
  AddOrderSuccess(this.orderId);
}
class AddOrderError extends AddNewOrderState {
  final String error;
  AddOrderError(this.error);
}
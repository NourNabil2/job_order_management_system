part of 'item_details_cubit.dart';

@immutable
sealed class ItemDetailsState {}

final class ItemDetailsInitial extends ItemDetailsState {}

final class sendAttachmentLoading extends ItemDetailsState {}

final class AddAttachmentSuccess extends ItemDetailsState {}



class OrderItemsLoading extends ItemDetailsState {}

class OrderItemLoddedError extends ItemDetailsState {
  final String error;
  OrderItemLoddedError(this.error);
}


class OrderItemsLoaded extends ItemDetailsState {
  final List<OrderItem> items;

  OrderItemsLoaded(this.items);

  @override
  List<Object> get props => [items];
}

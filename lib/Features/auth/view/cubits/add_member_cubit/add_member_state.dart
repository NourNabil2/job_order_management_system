part of 'add_member_cubit.dart';

@immutable
sealed class AddMemberState {}

final class AddMemberInitial extends AddMemberState {}

final class AddMemberLoading extends AddMemberState {}

final class MemberUpdatedSuccessfully extends AddMemberState {}

final class AddMemberSuccess extends AddMemberState {}
final class AddMemberFailure extends AddMemberState {
  final String message;
  AddMemberFailure({required this.message});
}

class FetchMembersLoading extends AddMemberState {}

class FetchMembersSuccess extends AddMemberState {
  final List<UserModel> members;

  FetchMembersSuccess({required this.members});
}

class FetchMembersFailure extends AddMemberState {
  final String message;

  FetchMembersFailure({required this.message});
}
class UserDeletedFailure extends AddMemberState {
  final String message;

  UserDeletedFailure({required this.message});
}

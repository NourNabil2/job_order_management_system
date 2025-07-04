part of 'signin_cubit.dart';

@immutable
sealed class SigninState {}

final class SigninInitial extends SigninState {}

class SigninSuccess extends SigninState {
  final UserModel userData;

  SigninSuccess({required this.userData});
}

final class SigninLoading extends SigninState {}

final class SigninResetPassword extends SigninState {}


final class SigninFailure extends SigninState {
  final String message;
  SigninFailure({required this.message});
}

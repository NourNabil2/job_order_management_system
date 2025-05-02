import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Core/components/failure.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_model.dart';
import 'package:quality_management_system/Features/auth/domain/repo/auth_repo.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository authRepository;
  final FirebaseFirestore firestore;

  SigninCubit(this.authRepository, this.firestore) : super(SigninInitial());


  Future<void> signin(email, password) async {
    emit(SigninLoading());

    final result = await authRepository.signin(email, password);
    result.fold(
          (failure) => emit(SigninFailure(message: failure.message)),
          (userData) => emit(SigninSuccess(userData: userData)),
    );
  }

}

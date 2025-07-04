import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Features/auth/domain/repo/auth_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository authRepository;

  SignupCubit(this.authRepository) : super(SignupInitial());

  void signup(String email, password) async {
    emit(SignupLoading());

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');

      await users.doc(email).update({
        'uid': userCredential.user!.uid,
        'activeAccount': true,
        'password': '',
        'email': email,
      });
      emit(SignupSuccess());
    } on Exception catch (e) {
      emit(SignupFailure(message: e.toString()));
    }
  }



}

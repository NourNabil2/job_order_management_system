import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Features/auth/domain/repo/auth_repo.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository authRepository;
  final FirebaseFirestore firestore;

  SigninCubit(this.authRepository, this.firestore) : super(SigninInitial());


  Future<void> signin(String email, String password) async {
    emit(SigninLoading());

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // التحقق من صلاحية المستخدم
      final userDoc = await firestore.collection('Users').doc(email).get();

      if (userDoc.exists) {
        final role = userDoc.data()?['role'] as String?;

        if (role == 'admin') {
          emit(SigninAdminSuccess()); // حالة جديدة للادمن
        } else {
          emit(SigninUserSuccess()); // حالة جديدة للمستخدم العادي
        }
      } else {
        emit(SigninFailure(message: 'User data not found'));
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        final userRef = await firestore.collection('Users').doc(email).get();

        if (userRef.exists) {
          if (userRef.data()?['activeAccount'] == false &&
              userRef.data()?['password'] == password) {
            emit(SigninResetPassword());
          } else {
            emit(SigninFailure(
                message: 'Invalid Credential, Please Try Again'));
          }
        } else {
          emit(SigninFailure(
              message: 'Account not found. Please contact admin.'));
        }
      } else {
        emit(SigninFailure(
            message: 'An unknown error occurred. Please try again later.'));
      }
    } catch (e) {
      emit(SigninFailure(message: 'An error occurred: ${e.toString()}'));
    }
  }

}

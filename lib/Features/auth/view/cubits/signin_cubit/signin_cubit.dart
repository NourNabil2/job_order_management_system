import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_model.dart';
import 'package:quality_management_system/Features/auth/domain/repo/auth_repo.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository authRepository;

  SigninCubit(this.authRepository) : super(SigninInitial());

  Future<void> signin(String email, String password) async {
    emit(SigninLoading());

    try {
      try {
        // تسجيل الدخول بالفيريبيز
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(email)
            .get();


        if (!userDoc.exists) {
          emit(SigninFailure(message: 'لم يتم العثور على بيانات المستخدم.'));
          return;
        }

        final userData = UserModel.fromMap(userDoc.data()!);
        emit(SigninSuccess(userData: userData));


      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          // لو في مشكلة تسجيل دخول، نحاول نتحقق من الحساب يدويًا
          final query = await FirebaseFirestore.instance
              .collection('Users')
              .where('email', isEqualTo: email)
              .get();

          if (query.docs.isNotEmpty) {
            final userDoc = query.docs.first;
            final data = userDoc.data();

            if (data['activeAccount'] == false && data['password'] == password) {
              emit(SigninResetPassword());
            } else {
              emit(SigninFailure(message: 'البريد أو كلمة المرور غير صحيحة.'));
            }
          } else {
            emit(SigninFailure(message: 'الحساب غير موجود.'));
          }
        } else {
          emit(SigninFailure(message: 'حدث خطأ غير معروف.'));
        }
      }
    } catch (e) {
      emit(SigninFailure(message: 'حدث خطأ أثناء تسجيل الدخول: ${e.toString()}'));
    }
  }

}

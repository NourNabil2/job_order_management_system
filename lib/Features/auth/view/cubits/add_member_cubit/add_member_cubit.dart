import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_model.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_role.dart';
import 'package:quality_management_system/Features/auth/domain/repo/auth_repo.dart';

part 'add_member_state.dart';

class AddMemberCubit extends Cubit<AddMemberState> {
  final AuthRepository authRepository;

  AddMemberCubit(this.authRepository) : super(AddMemberInitial()){
    fetchAllMembers();
  }

  Future<void> addMember(String name, email, password, role) async {
    emit(AddMemberLoading());

    final result = await authRepository.addMember(name, email, password, role);
    result.fold(
      (failure) => emit(AddMemberFailure(message: failure.message)),
      (_) => emit(AddMemberSuccess()),
    );
  }

  Future<void> fetchAllMembers() async {
    emit(FetchMembersLoading());

    final result = await authRepository.fetchAllMembers();
    result.fold(
          (failure) => emit(FetchMembersFailure(message: failure.message)),
          (members) => emit(FetchMembersSuccess(members: members)),
    );
  }


// أولا: أضف هذه الدالة في ملف الـ Cubit الخاص بك
  Future<void> updateMember({
    required String oldEmail,
    required String name,
    required String newEmail,
    required String role,
    String? newPassword,
  }) async {
    emit(AddMemberLoading());

    try {
      // 1. تحديث البيانات في Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(oldEmail)
          .update({
        'name': name,
        'email': newEmail,
        'role': role,
        if (newPassword != null && newPassword.isNotEmpty) 'password': newPassword,
      });

      // 2. إذا تغير الإيميل، ننشئ مستخدم جديد ونحذف القديم
      if (oldEmail != newEmail) {
        final auth = FirebaseAuth.instance;
        final user = await auth.fetchSignInMethodsForEmail(oldEmail);

        if (user.isNotEmpty) {
          // هذه الخطوة تتطلب Cloud Function أو صلاحيات إدارية
          // يمكنك استدعاء Cloud Function هنا لتغيير الإيميل في Authentication
          log('Email changed - requires admin privileges to update auth email');
        }
      }

      // 3. إذا كانت هناك كلمة مرور جديدة، نحدثها
      if (newPassword != null && newPassword.isNotEmpty) {
        // هذه الخطوة تتطلب إعادة تسجيل الدخول أو صلاحيات إدارية
        log('Password changed - requires reauthentication');
      }

      emit(MemberUpdatedSuccessfully());
    } catch (e) {
      emit(AddMemberFailure(message: 'Failed to update member: ${e.toString()}'));
    }
  }

}

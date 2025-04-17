import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_role.dart';
import 'package:quality_management_system/Features/auth/domain/repo/auth_repo.dart';

part 'add_member_state.dart';

class AddMemberCubit extends Cubit<AddMemberState> {
  final AuthRepository authRepository;

  AddMemberCubit(this.authRepository) : super(AddMemberInitial());

  Future<void> addMember(String name, email, password, UserRole role) async {
    emit(AddMemberLoading());

    final result = await authRepository.addMember(name, email, password, role);
    result.fold(
      (failure) => emit(AddMemberFailure(message: failure.message)),
      (_) => emit(AddMemberSuccess()),
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:quality_management_system/Core/components/failure.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_model.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_role.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> addMember(String name, email, password, role);
  Future<Either<Failure, UserModel>> signin(String email, password);
  Future<Either<Failure, Unit>> signup(String email, password);
  Future<Either<Failure, List<UserModel>>> fetchAllMembers();
}

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quality_management_system/Core/Utilts/extensions.dart';
import 'package:quality_management_system/Core/components/failure.dart';
import 'package:quality_management_system/Features/auth/data/auth_data_source/auth_remote_data_source.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_role.dart';
import 'package:quality_management_system/Features/auth/domain/repo/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Unit>> signin(String email, password) async {
    try {
      await remoteDataSource.signin(email, password);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      return left(
          Failure(message: StringExtensions(e.code).mapFirebaseError(e)));
    } catch (e) {
      return left(Failure(message: "An unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, Unit>> signup(String email, password) async {
    try {
      await remoteDataSource.signup(email, password);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      return left(
          Failure(message: StringExtensions(e.code).mapFirebaseError(e)));
    } catch (e) {
      return left(Failure(message: "An unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, Unit>> addMember(
      String name, email, password, UserRole role) async {
    try {
      await remoteDataSource.addMember(name, email, password, role);
      return right(unit);
    } catch (e) {
      return left(Failure(message: "An unexpected error occurred"));
    }
  }
}

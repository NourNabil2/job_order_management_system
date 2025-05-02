import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quality_management_system/Core/Utilts/extensions.dart';
import 'package:quality_management_system/Core/components/failure.dart';
import 'package:quality_management_system/Features/auth/data/auth_data_source/auth_remote_data_source.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_model.dart';
import 'package:quality_management_system/Features/auth/domain/repo/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserModel>> signin(String email, password) async {
    try {
      final user = await remoteDataSource.signin(email, password);

      // Fetch user data from Firestore
      final doc = await FirebaseFirestore.instance.collection('Users').doc(email).get();
      if (!doc.exists) {
        return left(Failure(message: "User data not found in Firestore"));
      }

      final userModel = UserModel.fromMap(doc.data()!);
      return right(userModel);

    } on FirebaseAuthException catch (e) {
      return left(Failure(message: e.message ?? "Authentication failed"));
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
      String name, email, password, role) async {
    try {
      await remoteDataSource.addMember(name, email, password, role);
      return right(unit);
    } catch (e) {
      return left(Failure(message: "An unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> fetchAllMembers() async {
    try {
      final members = await remoteDataSource.fetchAllMembers();
      return right(members);
    } catch (e) {
      return left(Failure(message: "An unexpected error occurred"));
    }
  }
}

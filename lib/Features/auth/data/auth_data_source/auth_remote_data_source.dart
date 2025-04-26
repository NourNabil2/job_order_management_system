import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_model.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_role.dart';

abstract class AuthRemoteDataSource {
  Future<void> addMember(String name, email, password, UserRole role);
  Future<User> signin(String email, password);
  Future<User> signup(String email, password);
  Future<List<UserModel>> fetchAllMembers();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<void> addMember(String name, email, password, UserRole role) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    final result = users.doc(email).set({
      'name': name,
      'uid': '',
      'activeAccount': false,
      'password': password,
      'email': email,
      'role': role.value,
    });

    return result;
  }

  @override
  Future<User> signin(String email, password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!;
  }

  @override
  Future<User> signup(String email, password) async {
    final userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!;
  }

  @override
  Future<List<UserModel>> fetchAllMembers() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
    return querySnapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
  }

}

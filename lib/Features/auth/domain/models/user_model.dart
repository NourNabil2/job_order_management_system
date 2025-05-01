import 'user_role.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role;

  // Removed password from model - passwords shouldn't be stored in documents
  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role, // Store enum value as string
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
    );
  }
}

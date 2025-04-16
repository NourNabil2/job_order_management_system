import 'user_role.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String password;
  final UserRole role;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'password': password,
      'role': role.value,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      password: map['password'],
      role: UserRoleExtension.fromString(map['role']),
    );
  }
}

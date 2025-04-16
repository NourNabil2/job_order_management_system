enum UserRole {
  rider,
  taxiOwner,
  driver,
}

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.rider:
        return 'rider';
      case UserRole.taxiOwner:
        return 'taxiOwner';
      case UserRole.driver:
        return 'driver';
    }
  }

  static UserRole fromString(String role) {
    switch (role) {
      case 'rider':
        return UserRole.rider;
      case 'taxiOwner':
        return UserRole.taxiOwner;
      case 'driver':
        return UserRole.driver;
      default:
        throw Exception('Invalid role');
    }
  }
}

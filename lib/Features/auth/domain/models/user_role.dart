enum UserRole {
  admin,
  purchaseDepartment,
  workShop,
  collector,
}

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.purchaseDepartment:
        return 'Purchase Department';
      case UserRole.workShop:
        return 'Work Shop';
      case UserRole.collector:
        return 'Collector';
    }
  }

  static UserRole fromString(String role) {
    switch (role) {
      case 'Admin':
        return UserRole.admin;
      case 'Purchase Department':
        return UserRole.purchaseDepartment;
      case 'Work Shop':
        return UserRole.workShop;
      case 'Collector':
        return UserRole.collector;
      default:
        return UserRole.workShop;
    }
  }
}

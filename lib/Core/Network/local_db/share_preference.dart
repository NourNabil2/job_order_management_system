import 'package:shared_preferences/shared_preferences.dart';

class CashSaver {

  static SharedPreferences? sharedPreferences;

  // Initialize SharedPreferences
  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static String? userRole;
  // Save data based on type
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await sharedPreferences?.setString(key, value) ?? Future.value(false);
    } else if (value is int) {
      return await sharedPreferences?.setInt(key, value) ?? Future.value(false);
    } else if (value is bool) {
      return await sharedPreferences?.setBool(key, value) ?? Future.value(false);
    } else if (value is List<String>) {
      return await sharedPreferences?.setStringList(key, value) ?? Future.value(false);
    } else {
      throw ArgumentError('Unsupported value type');
    }
  }

  // Save a list of strings
  static Future<bool> saveList({
    required String key,
    required List<String> value,
  }) async {
    return await sharedPreferences?.setStringList(key, value) ?? Future.value(false);
  }

  // Retrieve data of various types
  static dynamic getData({required String key}) {
    return sharedPreferences?.get(key);
  }

  // Retrieve a list of strings
  static List<String>? getStringList({required String key}) {
    return sharedPreferences?.getStringList(key);
  }

  // Clear data
  static Future<bool> clearData({required String key}) async {
    return await sharedPreferences?.remove(key) ?? Future.value(false);

  }
  // Clear all data
  static Future<bool> clearAllData() async {
    return await sharedPreferences?.clear() ?? Future.value(false);
  }
}

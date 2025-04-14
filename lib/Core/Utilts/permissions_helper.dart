import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  /// Request a single permission
  static Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  /// Check if a permission is granted
  static Future<bool> isPermissionGranted(Permission permission) async {
    return await permission.isGranted;
  }

  /// Request multiple permissions at once
  static Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
      List<Permission> permissions) async {
    return await permissions.request();
  }

  /// Request camera permission
  static Future<bool> requestCameraPermission() async {
    return await requestPermission(Permission.camera);
  }

  /// Request storage permission
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), we need to request specific permissions
      if (await _isAndroid13OrHigher()) {
        return await requestPermission(Permission.photos) &&
            await requestPermission(Permission.videos);
      } else {
        return await requestPermission(Permission.storage);
      }
    } else if (Platform.isIOS) {
      return await requestPermission(Permission.photos);
    }
    return false;
  }

  /// Request microphone permission
  static Future<bool> requestMicrophonePermission() async {
    return await requestPermission(Permission.microphone);
  }

  /// Request location permission
  static Future<bool> requestLocationPermission() async {
    return await requestPermission(Permission.location);
  }

  /// Request notification permission
  static Future<bool> requestNotificationPermission() async {
    return await requestPermission(Permission.notification);
  }

  /// Request contacts permission
  static Future<bool> requestContactsPermission() async {
    return await requestPermission(Permission.contacts);
  }

  /// Request calendar permission
  static Future<bool> requestCalendarPermission() async {
    return await requestPermission(Permission.calendar);
  }

  /// Show permission rationale dialog
  static Future<bool> showPermissionRationaleDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmButtonText = 'Settings',
    String cancelButtonText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelButtonText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmButtonText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Open app settings
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Check if the device is running Android 13 or higher
  static Future<bool> _isAndroid13OrHigher() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 33;
    }
    return false;
  }

  /// Helper method to handle permission results
  static Future<bool> handlePermissionRequest({
    required BuildContext context,
    required Permission permission,
    required String title,
    required String message,
    String confirmButtonText = 'Settings',
    String cancelButtonText = 'Cancel',
  }) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      final openSettings = await showPermissionRationaleDialog(
        context: context,
        title: title,
        message: message,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
      );

      if (openSettings) {
        return await openAppSettings();
      }
    }

    return false;
  }
}


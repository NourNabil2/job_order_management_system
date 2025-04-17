import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/theme/text_theme.dart';

showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: appTextTheme.bodyMedium),
      clipBehavior: Clip.none,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
          vertical: SizeApp.defaultPadding, horizontal: SizeApp.defaultPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeApp.borderRadius),
      ),
      backgroundColor: ColorApp.primaryColor,
      padding: EdgeInsets.symmetric(
          vertical: SizeApp.defaultPadding, horizontal: SizeApp.defaultPadding),
    ),
  );
}

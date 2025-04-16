import 'package:flutter/material.dart';




CheckboxThemeData checkboxThemeData = CheckboxThemeData(
  checkColor: MaterialStateProperty.all(Colors.white),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(16 / 2),
    ),
  ),
  side: const BorderSide(color: Colors.white10),
);

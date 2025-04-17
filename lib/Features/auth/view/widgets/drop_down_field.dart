import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/theme/text_theme.dart';

class CustomDropdownFormField extends StatelessWidget {
  const CustomDropdownFormField({
    super.key,
    required this.items,
    this.validator,
    this.onChanged,
    this.value,
    required this.hint,
    required this.icon,
  });

  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: appTextTheme.bodyMedium,
        ),
      ),
      child: DropdownButtonFormField(
        items: items,
        hint: Text(
          hint,
          style:
              appTextTheme.bodyMedium!.copyWith(color: ColorApp.blackColor90),
        ),
        style: appTextTheme.bodyMedium!.copyWith(color: ColorApp.blackColor),
        value: value,
        icon: Icon(Icons.keyboard_arrow_down_rounded,
            size: SizeApp.iconSizeMedium),
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorApp.blackColor5,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SizeApp.borderRadius),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

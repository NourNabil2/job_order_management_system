import 'dart:developer';
import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';

// ignore: must_be_immutable
class CustomFormTextField extends StatelessWidget {
 const CustomFormTextField({
    super.key,
    this.color,
    this.style,
    this.minLines,
    this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.initialValue,
    this.onSaved,
    this.icon,
    this.textEditingController,
    this.title,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.nextFocusNode,
    this.onPressedObscureText,
    this.iconObscureText,
  });

  final Function(String)? onChanged;
  final String? hintText;
  final String? title;
  final TextStyle? style;
  final Color? color;
  final int? minLines;
  final TextInputType? keyboardType;
  final String? initialValue;
  final TextEditingController? textEditingController;
  final Function(dynamic)? onSaved;
  final bool obscureText;
  final IconData? icon;
  final VoidCallback? onPressedObscureText;
  final IconData? iconObscureText;
  final TextInputAction textInputAction;
  final FocusNode? focusNode; // Current field's focus
  final FocusNode? nextFocusNode; // Next field's focus

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeApp.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (title != null)
            Text(
              title!,
              style: style,
            ),
          Container(
            decoration: BoxDecoration(
              color: color ?? Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(SizeApp.radius),
            ),
            child: TextFormField(
              focusNode: focusNode, // Assign focus node
              minLines: minLines ?? 1,
              maxLines: obscureText ? 1 : 20,
              style: Theme.of(context).textTheme.bodyMedium,
              keyboardType: keyboardType,
              controller: textEditingController,
              initialValue: initialValue,
              onSaved: onSaved,
              cursorColor: Theme.of(context).primaryColor,
              obscureText: obscureText,
              textInputAction: textInputAction,
              onFieldSubmitted: (value) {
                if (nextFocusNode != null) {
                  FocusScope.of(context).requestFocus(nextFocusNode); // Move to next field
                } else {
                  FocusScope.of(context).unfocus(); // Close keyboard if no next field
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your ${hintText!.toLowerCase()}";
                }
                // Check for password validation
                else if (hintText!.toLowerCase() == "passwords") {
                  if (value.length < 8) {
                    return "Password must be at least 8 characters long.";
                  } else if (!RegExp(r".*[A-Z].*").hasMatch(value)) {
                    return "Password must contain at least one uppercase letter.";
                  } else if (!RegExp(r".*[a-z].*").hasMatch(value)) {
                    return "Password must contain at least one lowercase letter.";
                  } else if (!RegExp(r".*\d.*").hasMatch(value)) {
                    return "Password must contain at least one number.";
                  }
                } else if (hintText!.toLowerCase() == "Email") {
                  // إزالة المسافات الزائدة والتأكد من صحة الإيميل
                  value = value.replaceAll(RegExp(r"\s+"), "");
                  if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                    return "Please enter a valid email.";
                  }
                }

                // If all validations pass
                return null;
              },
              decoration: InputDecoration(
                suffixIcon: iconObscureText != null ? IconButton(onPressed: onPressedObscureText, icon: Icon(iconObscureText)) : null,
                prefixIcon: Icon(
                  icon,
                  size: 24,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w200,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeApp.radius),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeApp.radius),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SizeApp.radius),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                fillColor: color ?? Theme.of(context).cardColor,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


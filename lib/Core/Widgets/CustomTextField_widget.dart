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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  log('asdasd ${hintText!.toLowerCase()}');
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
// ignore: must_be_immutable
class CustomTextField_form extends StatelessWidget {
  CustomTextField_form(
      {this.color,
      this.style,
      this.hintText,
      this.onChanged,
      this.obscureText = false,
      this.initialValue,
      this.onSaved,
      this.icon,
      this.textEditingController,
      this.title,
      this.keyboardType});
  Function(String)? onChanged;
  String? hintText;
  String? title;
  TextStyle? style;
  Color? color;

  TextInputType? keyboardType;
  String? initialValue;
  TextEditingController? textEditingController;
  Function(dynamic)? onSaved;
  bool? obscureText;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
              width: SizeApp.s70,
              child: Text(
                '$title  ',
                style: Theme.of(context).textTheme.titleSmall,
              )),
          Expanded(
            child: Container(
              height: SizeApp.s40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeApp.s5),
              ),
              child: TextFormField(
                maxLength: 100,
                style: Theme.of(context).textTheme.bodyMedium,
                keyboardType: keyboardType,
                controller: textEditingController,
                initialValue: initialValue,
                onSaved: onSaved,
                cursorColor: Theme.of(context).primaryColor,
                obscureText: obscureText!,
                validator: (data) {
                  if (data!.isEmpty) {
                    return '        field is required';
                  }
                  return null;
                },
                onChanged: onChanged,
                decoration: InputDecoration(
                  counterText: '', // This hides the counter ("0/250" indicator)
                  hintText: hintText,
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  // Set the border with only a top border
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey, // Color of the top border
                      width: 1.0, // Width of the top border
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeApp.s5),
                      topRight: Radius.circular(SizeApp.s5),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context)
                          .primaryColor, // Color of the top border when focused
                      width: 2.0, // Width of the top border when focused
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeApp.s5),
                      topRight: Radius.circular(SizeApp.s5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ScoialFormTextField extends StatelessWidget {
  ScoialFormTextField({
    this.color,
    this.style,
    this.minLines,
    this.hintText,
    this.onChanged,
    this.onChanged_checkBox,
    this.obscureText = false,
    this.initialValue,
    this.onSaved,
    this.icon,
    this.textEditingController,
    this.title,
    this.keyboardType,
    this.isChecked = false, // Added isChecked parameter to track checkbox state
  });

  Function(String)? onChanged;
  Function(bool?)? onChanged_checkBox;
  String? hintText;
  String? title;
  TextStyle? style;
  Color? color;
  int? minLines;
  TextInputType? keyboardType;
  String? initialValue;
  TextEditingController? textEditingController;
  Function(dynamic)? onSaved;
  bool? obscureText;
  IconData? icon;
  bool isChecked; // Checkbox state

  @override
  Widget build(BuildContext context) {
    // Clear text in TextEditingController when checkbox is unchecked
    if (!isChecked && textEditingController != null) {
      textEditingController?.clear();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != null ? Text('$title', style: style) : Container(),
          Container(
            decoration: BoxDecoration(
              color: color ?? Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(SizeApp.radius),
              boxShadow: isChecked
                  ? [
                      BoxShadow(
                        color: ColorApp.primaryColor
                            .withOpacity(0.5), // Glowing effect color
                        blurRadius: 10.0, // Light radius
                        spreadRadius: 3.0, // Glow spread
                      ),
                    ]
                  : [],
            ),
            child: TextFormField(
              minLines: minLines ?? 1,
              maxLines: obscureText == true ? 1 : 20,
              style: Theme.of(context).textTheme.bodyMedium,
              keyboardType: keyboardType,
              controller: textEditingController,
              initialValue: initialValue,
              onSaved: onSaved,
              cursorColor: Theme.of(context).primaryColor,
              obscureText: obscureText!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your ${hintText!.toLowerCase()}";
                }
                // Password validation and other checks as in original code...

                return null;
              },
              onChanged: onChanged,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  icon,
                  size: 24,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
                suffixIcon: Checkbox(
                  value: isChecked,
                  onChanged: onChanged_checkBox,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),  // Makes the checkbox circular
                  ),
                  checkColor: ColorApp.primaryColor,  // Color of the tick (checkmark) when checked
                  activeColor: ColorApp.primaryColor,  // Background color of the checkbox when checked
                  tristate: false, // Setting to false to make it a normal checkbox
                  side: BorderSide(width: 3, color: ColorApp.primaryColor), // Border color and width
                ),
                hintText: hintText,
                hintStyle: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w200),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

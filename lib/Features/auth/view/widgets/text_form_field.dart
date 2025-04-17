// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:quality_management_system/Core/Utilts/Constants.dart';
// import 'package:quality_management_system/Core/theme/text_theme.dart';
//
// class CustomTextFormField extends StatelessWidget {
//   const CustomTextFormField(
//       {super.key,
//       this.controller,
//       this.hint,
//       this.icon,
//       this.validator,
//       this.suffixIcon,
//       this.obsecure = false,
//       this.onChanged});
//
//   final IconButton? suffixIcon;
//   final TextEditingController? controller;
//   final String? hint;
//   final IconData? icon;
//   final String? Function(String?)? validator;
//   final bool? obsecure;
//   final void Function(String)? onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         inputDecorationTheme:
//             InputDecorationTheme(errorStyle: appTextTheme.bodyMedium),
//       ),
//       child: TextFormField(
//         onChanged: onChanged,
//         obscuringCharacter: "*",
//         obscureText: obsecure!,
//         style: appTextTheme.bodyMedium,
//         cursorWidth: 3,
//         cursorColor: Theme.of(context).primaryColor,
//         autovalidateMode: AutovalidateMode.onUserInteraction,
//         inputFormatters: [LengthLimitingTextInputFormatter(50)],
//         decoration: InputDecoration(
//           filled: true,
//           hintText: hint,
//           hintStyle: appTextTheme.bodyMedium,
//           suffixIcon: suffixIcon,
//           fillColor: ColorApp.blackColor5,
//           prefixIcon: icon == null ? null : Icon(icon),
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none),
//         ),
//         validator: validator,
//         controller: controller,
//       ),
//     );
//   }
// }

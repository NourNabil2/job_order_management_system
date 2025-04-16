import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/theme/text_theme.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.loading,
  });

  final void Function() onPressed;
  final String text;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.primaryColor,
              overlayColor: ColorApp.primaryColor,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            ),
            onPressed: onPressed,
            child: loading
                ? const SizedBox(
                    width: 25,
                    height: 50,
                    child:
                        CircularProgressIndicator(color: ColorApp.blackColor5),
                  )
                : SizedBox(
                    child: Baseline(
                    baseline: 16.sp,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(text,
                        style: appTextTheme.bodyLarge!
                            .copyWith(color: ColorApp.blackColor5)),
                  ))));
  }
}

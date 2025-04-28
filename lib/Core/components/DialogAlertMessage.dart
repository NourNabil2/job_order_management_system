import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';



class _CustomAlert extends StatelessWidget {
  final bool isSuccess;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const _CustomAlert({
    required this.isSuccess,
    required this.cancelText,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: Center(
        child: Lottie.asset(
          isSuccess ? AssetsManager.addedSuccess : AssetsManager.addedFail,
          width: SizeApp.logoSize,
          repeat: isSuccess ? false : true,
          fit: BoxFit.fill,
        ),
      ),
      contentTextStyle: Theme.of(context).textTheme.titleLarge,
      content: Text(
        isSuccess ? 'تم تنفيذ العملية بنجاح' : 'فشلت العملية، حاول مرة أخرى',
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: onCancel,
              child: Text(
                cancelText,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


void showCustomAlert({
  required BuildContext context,
  required bool isSuccess,
  String cancelText = 'OK',
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return _CustomAlert(
        isSuccess: isSuccess,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel ?? () {
          Navigator.pop(context);
        },
      );
    },
  );
}
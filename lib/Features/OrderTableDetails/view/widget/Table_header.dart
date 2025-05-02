import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Network/local_db/share_preference.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';


class OrderHeader extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback onPressed;

  const OrderHeader({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
        color: ColorApp.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: ColorApp.mainLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
       if (CashSaver.userRole == 'admin') ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.mainLight,
              foregroundColor: ColorApp.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 14),
            ),
          ) else const SizedBox.shrink(),
        ],
      ),
    );
  }
}

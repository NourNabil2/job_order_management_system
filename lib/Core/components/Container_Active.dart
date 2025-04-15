import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';

Widget statusContainer({required String status, required String title}) {
  return Container(
    padding:
        EdgeInsets.symmetric(horizontal: SizeApp.s15, vertical: SizeApp.s2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(SizeApp.s15),
      color: status != 'cancelled' ? Colors.green : Colors.red,
    ),
    child: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
  );
}

Widget activeContainer({required bool isActive}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: SizeApp.s15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(SizeApp.s10),
      color: isActive ? Colors.green : Colors.red,
    ),
    child: isActive
        ? const Text(
            'active',
            style: TextStyle(color: Colors.white),
          )
        : const Text('not active'),
  );
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';

class DeadlinePickerTile extends StatelessWidget {
  final DateTime? selectedDeadline;
  final VoidCallback onPickDate;

  const DeadlinePickerTile({
    super.key,
    required this.selectedDeadline,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(SizeApp.radius),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey.shade700, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedDeadline == null
                    ? 'Select Delivery Deadline'
                    : 'Deadline: ${DateFormat('yyyy-MM-dd').format(selectedDeadline!)}',
                style: TextStyle(
                  fontSize: 16,
                  color: selectedDeadline == null
                      ? Colors.grey.shade600
                      : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

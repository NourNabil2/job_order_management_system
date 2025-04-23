// basic_info_step.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BasicInfoStep extends StatelessWidget {
  final TextEditingController orderNumberController;
  final TextEditingController companyNameController;
  final TextEditingController supplyNumberController;
  final String? selectedAttachmentType;
  final String? selectedStatus;
  final DateTime? selectedDeadline;
  final List<String> attachmentTypeOptions;
  final List<String> statusOptions;
  final VoidCallback onPickDate;
  final ValueChanged<String?> onAttachmentTypeChanged;
  final ValueChanged<String?> onStatusChanged;

  const BasicInfoStep({
    super.key,
    required this.orderNumberController,
    required this.companyNameController,
    required this.supplyNumberController,
    required this.selectedAttachmentType,
    required this.selectedStatus,
    required this.selectedDeadline,
    required this.attachmentTypeOptions,
    required this.statusOptions,
    required this.onPickDate,
    required this.onAttachmentTypeChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: orderNumberController,
          decoration: const InputDecoration(labelText: 'Order Number'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: companyNameController,
          decoration: const InputDecoration(labelText: 'Company Name'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedAttachmentType,
          decoration: const InputDecoration(labelText: 'Attachment Type'),
          items: attachmentTypeOptions
              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          validator: (value) => value == null ? 'Required' : null,
          onChanged: onAttachmentTypeChanged,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: supplyNumberController,
          decoration: const InputDecoration(labelText: 'Supply Number'),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        ListTile(
          title: Text(selectedDeadline == null
              ? 'Select Delivery Deadline'
              : 'Deadline: ${DateFormat('yyyy-MM-dd').format(selectedDeadline!)}'),
          trailing: const Icon(Icons.calendar_today),
          onTap: onPickDate,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedStatus,
          decoration: const InputDecoration(labelText: 'Order Status'),
          items: statusOptions
              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: onStatusChanged,
        ),
      ],
    );
  }
}

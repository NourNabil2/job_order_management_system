import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Network/local_db/share_preference.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Widgets/Custom_dropMenu.dart';
import 'package:quality_management_system/Core/Widgets/custom_containerStatus.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItem item;
  final bool isSelected;
  final ThemeData theme;
  final ValueChanged<bool?> onSelectionChanged;
  final ValueChanged<String> onStatusChanged;
  final List<String> statusOptions;

  const OrderItemCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.theme,
    required this.onSelectionChanged,
    required this.onStatusChanged,
    this.statusOptions = const ['Pending', 'In Progress', 'Completed'],
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: theme.primaryColor, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderRow(),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              _buildDetailChips(),
              if (item.notes.isNotEmpty) _buildNotesSection(),
              if (item.attachments.isNotEmpty) _buildAttachmentsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
   if (CashSaver.userRole == 'admin' ) _buildCheckbox(),
        const SizedBox(width: 12),
        _buildDescription(),
        const Spacer(),
     if (CashSaver.userRole != 'collector' ) StatusDropdown(selectedStatus: statusOptions.contains(item.status) ? item.status : statusOptions.first, statusOptions: statusOptions, onStatusChanged: onStatusChanged) else StatusContainer(status: statusOptions.contains(item.status) ? item.status : statusOptions.first ),
      ],
    );
  }

  Widget _buildCheckbox() {
    return SizedBox(
      width: 24,
      height: 24,
      child: Checkbox(
        value: isSelected,
        onChanged: onSelectionChanged,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Expanded(
      child: Text(
        item.operationDescription,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }


  Widget _buildDetailChips() {
    return Row(
      children: [
        _buildDetailChip(Icons.format_list_numbered, 'عدد: ${item.quantity}'),
        if (item.materialType.isNotEmpty)
          _buildDetailChip(Icons.category, item.materialType),
      ],
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Notes:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.notes,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          'Attachments:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: item.attachments
              .map((attachment) => Chip(
            label: Text(
              attachment,
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: Colors.blue.shade50,
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ))
              .toList(),
        ),
      ],
    );
  }
}
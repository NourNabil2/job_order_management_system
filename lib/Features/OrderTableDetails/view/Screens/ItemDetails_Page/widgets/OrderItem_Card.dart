import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Network/local_db/share_preference.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Widgets/Custom_dropMenu.dart';
import 'package:quality_management_system/Core/Widgets/custom_containerStatus.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';

class OrderItemCard extends StatefulWidget {
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
  State<OrderItemCard> createState() => _OrderItemCardState();
}


class _OrderItemCardState extends State<OrderItemCard> {

  void _handleStatusChange(String newStatus) async {
    if (newStatus == 'Completed') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('تأكيد'),
          content: const Text('تم إنهاء هذه العملية ولا يمكن الرجوع عنها. هل أنت متأكد؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('تأكيد'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        widget.onStatusChanged(newStatus);
      }
    } else {
      widget.onStatusChanged(newStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: widget.isSelected
              ? Border.all(color: widget.theme.primaryColor, width: 2)
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
              if (widget.item.notes.isNotEmpty) _buildNotesSection(),
              if (widget.item.attachments.isNotEmpty) _buildAttachmentsSection(),
              if (widget.item.deliveryDate != '') _buildDeliveryDateBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Checkbox(
          value: widget.isSelected,
          onChanged: widget.onSelectionChanged,
        ),
        _buildDescription(),
        const Spacer(),
        if (CacheSaver.userRole != 'collector')
          widget.item.deliveryDate != '' && CacheSaver.userRole != 'admin'
              ? const StatusContainer(status: 'Completed')
              : StatusDropdown(
            selectedStatus: widget.statusOptions.contains(widget.item.status)
                ? widget.item.status
                : widget.statusOptions.first,
            statusOptions: widget.statusOptions,
            onStatusChanged: _handleStatusChange,
          )
        else
          StatusContainer(
            status: widget.statusOptions.contains(widget.item.status)
                ? widget.item.status
                : widget.statusOptions.first,
          ),
      ],
    );
  }


  Widget _buildDescription() {
    return Expanded(
      child: Text(
        widget.item.operationDescription,
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
        _buildDetailChip(Icons.format_list_numbered, 'عدد: ${widget.item.quantity}'),
        if (widget.item.materialType.isNotEmpty)
          _buildDetailChip(Icons.category, widget.item.materialType),
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
          widget.item.notes,
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
          children: widget.item.attachments
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

  Widget _buildDeliveryDateBox() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'تم الانتهاء في ${widget.item.deliveryDate}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

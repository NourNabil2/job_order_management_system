import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quality_management_system/Core/Network/local_db/share_preference.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Widgets/Custom_dropMenu.dart';
import 'package:quality_management_system/Core/Widgets/custom_containerStatus.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';


class OrderSummaryCard extends StatelessWidget {
  final OrderModel order;
  final ThemeData theme;
  final ValueChanged<String> onStatusChanged;
  final List<String> statusOptions;

  const OrderSummaryCard({
    super.key,
    required this.order,
    required this.theme,
    required this.onStatusChanged,
    this.statusOptions = const ['Pending', 'In Progress', 'Completed', 'delivered'],
  });

  @override
  Widget build(BuildContext context) {
    final deadlineText = _getFormattedDeadlineText(order.dateLine);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.8),
              theme.primaryColor,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(),
            const SizedBox(height: 16),
            _buildInfoCard(deadlineText),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildOrderInfoColumn(),
       CashSaver.userRole == 'admin' || CashSaver.userRole == 'collector' ? StatusDropdown(selectedStatus: statusOptions.contains(order.orderStatus) ? order.orderStatus : statusOptions.first, statusOptions: statusOptions, onStatusChanged: onStatusChanged) : StatusContainer(status: order.orderStatus),
      ],
    );
  }

  Widget _buildOrderInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order #${order.orderNumber}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          order.companyName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildInfoCard(String deadlineText) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildInfoRow('Attachment Type:', order.attachmentType),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Deadline:',
            deadlineText,
            textColor: deadlineText.contains("Overdue")
                ? Colors.orange[100]
                : Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _getFormattedDeadlineText(String dateLine) {
    try {
      final now = DateTime.now();
      final deadlineDate = DateFormat('yyyy-MM-dd').tryParse(dateLine);

      if (deadlineDate != null) {
        final daysRemaining = deadlineDate.difference(now).inDays;
        return '$dateLine (${daysRemaining > 0 ? "$daysRemaining days left" : "Overdue"})';
      }
      return dateLine;
    } catch (e) {
      return dateLine;
    }
  }
}
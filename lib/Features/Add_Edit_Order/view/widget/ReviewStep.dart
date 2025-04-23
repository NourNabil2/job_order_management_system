// review_step.dart
import 'package:flutter/material.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';

class ReviewStep extends StatelessWidget {
  final String orderNumber;
  final String companyName;
  final String? attachmentType;
  final String supplyNumber;
  final String? status;
  final List<OrderItem> orderItems;

  const ReviewStep({
    super.key,
    required this.orderNumber,
    required this.companyName,
    required this.attachmentType,
    required this.supplyNumber,
    required this.status,
    required this.orderItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Number: $orderNumber'),
        Text('Company: $companyName'),
        Text('Attachment Type: $attachmentType'),
        Text('Supply Number: $supplyNumber'),
        Text('Status: $status'),
        const SizedBox(height: 20),
        const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...orderItems.map((item) => Text(
            '${item.operationDescription} (Qty: ${item.quantity})'
        )),
      ],
    );
  }
}

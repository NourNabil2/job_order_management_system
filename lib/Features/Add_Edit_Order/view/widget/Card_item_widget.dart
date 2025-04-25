import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Widgets/custom_containerStatus.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';



class OperationCard extends StatelessWidget {
  final OrderItem item;
  final String status;
  final Widget widget;

  const OperationCard({
    Key? key,
    required this.item,
    required this.status,
    required this.widget,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading status
            StatusContainer(status: status),

            const SizedBox(width: 12),

            // Main content + delete button
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and delete icon in same row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          item.operationDescription,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      widget,
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Quantity and Material Type
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      Chip(
                        label: Text('الكمية: ${item.quantity}'),
                        backgroundColor: Colors.grey.shade50,
                      ),
                      Chip(
                        label: Text('الخامة: ${item.materialType}'),
                        backgroundColor: Colors.grey.shade50,
                      ),
                    ],
                  ),

                  // Notes
                  if (item.notes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'ملاحظات: ${item.notes}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

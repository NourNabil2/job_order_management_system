// add_items_step.dart
import 'package:flutter/material.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';


class AddItemsStep extends StatelessWidget {
  final List<OrderItem> orderItems;
  final VoidCallback onAddEditPressed;
  final void Function(OrderItem) onRemoveItem;

  const AddItemsStep({
    super.key,
    required this.orderItems,
    required this.onAddEditPressed,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onAddEditPressed,
          child: const Text('Add/Edit Items'),
        ),
        const SizedBox(height: 16),
        if (orderItems.isNotEmpty) ...[
          const Text('Added Items:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...orderItems.map((item) => ListTile(
            title: Text(item.operationDescription),
            subtitle: Text('Qty: ${item.quantity}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onRemoveItem(item),
            ),
          )),
        ],
      ],
    );
  }
}

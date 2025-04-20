import 'package:flutter/material.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';

import '../widget/AddItemDialog.dart';

class AddOrderItemsScreen extends StatefulWidget {
  final List<OrderItem> initialItems;

  const AddOrderItemsScreen({Key? key, required this.initialItems}) : super(key: key);

  @override
  _AddOrderItemsScreenState createState() => _AddOrderItemsScreenState();
}

class _AddOrderItemsScreenState extends State<AddOrderItemsScreen> {
  late List<OrderItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialItems);
  }

  void _addNewItem() async {
    final newItem = await showDialog<OrderItem>(
      context: context,
      builder: (context) => AddItemDialog(
        onItemAdded: (newItem) {
          setState(() {
            _items.add(newItem);
          });
        },
      ),
    );

    if (newItem != null) {
      setState(() {
        _items.add(newItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, _items);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(item.operationDescription),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Qty: ${item.quantity} | Material: ${item.materialType}'),
                  if (item.notes.isNotEmpty) Text('Notes: ${item.notes}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _items.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';

class AddItemDialog extends StatefulWidget {
  final Function(OrderItem) onItemAdded;

  const AddItemDialog({Key? key, required this.onItemAdded}) : super(key: key);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _materialTypeController = TextEditingController();
  final _notesController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _quantityController.dispose();
    _materialTypeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة بند جديد'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'بيان العملية',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يجب إدخال بيان العملية';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'العدد',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يجب إدخال العدد';
                  }
                  if (int.tryParse(value) == null) {
                    return 'يجب إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _materialTypeController,
                decoration: const InputDecoration(
                  labelText: 'نوع الخامة',
                ),
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(
                  labelText: 'الخاله',
                ),
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newItem = OrderItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                operationDescription: _descriptionController.text,
                status: _statusController.text,
                quantity: int.parse(_quantityController.text),
                materialType: _materialTypeController.text,
                notes: _notesController.text,
              );
              widget.onItemAdded(newItem);
              Navigator.pop(context);
            }
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Widgets/Custom_dropMenu.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';

class AddItemDialog extends StatefulWidget {
  final Function(OrderItem) onItemAdded;
  final OrderItem? existingItem; // new

  const AddItemDialog({
    Key? key,
    required this.onItemAdded,
    this.existingItem,
  }) : super(key: key);

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
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      _descriptionController.text = widget.existingItem!.operationDescription;
      _quantityController.text = widget.existingItem!.quantity.toString();
      _materialTypeController.text = widget.existingItem!.materialType;
      _statusController.text = widget.existingItem?.status ?? 'Pending';
      _notesController.text = widget.existingItem!.notes;
    }
  }

  final List<String> _statusOptions = ['Pending', 'In_Progress', 'Complete', 'rejected'];

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
              SizedBox(height: SizeApp.defaultPadding,),
              CustomDropMenu(
                  label: 'حاله التسليم',
                  value: _statusOptions.contains(_statusController.text) ? _statusController.text : 'Pending',
                  options: _statusOptions,
                  onChanged: (val) =>   _statusController.text = val ?? 'pending'),
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
              final editedItem = OrderItem(
                id: widget.existingItem?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                operationDescription: _descriptionController.text,
                status: _statusController.text,
                quantity: int.parse(_quantityController.text),
                materialType: _materialTypeController.text,
                notes: _notesController.text,
              );
              widget.onItemAdded(editedItem);
              Navigator.pop(context);
            }
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}
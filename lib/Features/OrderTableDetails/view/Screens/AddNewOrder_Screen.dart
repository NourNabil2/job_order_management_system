import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/addOrderItems.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view_model/add_order_cubit/add_order_cubit.dart';

import '../../model/data/Order_model.dart';

class AddOrderScreen extends StatefulWidget {
  final Function(OrderModel) onOrderAdded;

  const AddOrderScreen({Key? key, required this.onOrderAdded}) : super(key: key);

  @override
  _AddOrderScreenState createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _orderNumberController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _supplyNumberController = TextEditingController();
  final _itemCountController = TextEditingController();
  final _productionPermissionController = TextEditingController();
  DateTime? _selectedDeadline;
  String _selectedStatus = 'Pending';
  String? _selectedAttachmentType; // سيتم اختيار قيمة واحدة فقط
  List<OrderItem> _orderItems = [];

  final List<String> _statusOptions = [
    'Pending',
    'In Progress',
    'Delivered',
    'Cancelled'
  ];

  // قائمة بخيارات نوع المرفقات (يمكن اختيار واحدة فقط)
  final List<String> _attachmentTypeOptions = ['رسم', 'عينه'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _orderNumberController.dispose();
    _companyNameController.dispose();
    _supplyNumberController.dispose();
    _itemCountController.dispose();
    _productionPermissionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 3)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDeadline) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDeadline == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select delivery deadline')),
        );
        return;
      }

      if (_selectedAttachmentType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select attachment type')),
        );
        return;
      }

      // حساب إجمالي عدد البنود إذا كانت موجودة
      final totalItems = _orderItems.isNotEmpty
          ? _orderItems.fold(0, (sum, item) => sum + item.quantity)
          : int.tryParse(_itemCountController.text) ?? 0;

      // استدعاء الـ Cubit لإضافة الطلب
      context.read<AddOrderCubit>().addOrder(
        orderNumber: _orderNumberController.text,
        companyName: _companyNameController.text,
        attachmentType: _selectedAttachmentType!,
        supplyNumber: _supplyNumberController.text,
        dateLine: _selectedDeadline!,
        orderStatus: _selectedStatus,
        items: _orderItems,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // الحقول الأساسية
              TextFormField(
                controller: _orderNumberController,
                decoration: const InputDecoration(
                  labelText: 'Order Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter order number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // حقل نوع المرفقات (Dropdown)
              DropdownButtonFormField<String>(
                value: _selectedAttachmentType,
                decoration: const InputDecoration(
                  labelText: 'Attachment Type',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Select attachment type'),
                items: _attachmentTypeOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select attachment type';
                  }
                  return null;
                },
                onChanged: (newValue) {
                  setState(() {
                    _selectedAttachmentType = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _supplyNumberController,
                decoration: const InputDecoration(
                  labelText: 'Supply Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter supply number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // حقل عدد البنود (إما يدوي أو من البنود المضافة)
              _orderItems.isEmpty
                  ? TextFormField(
                controller: _itemCountController,
                decoration: const InputDecoration(
                  labelText: 'Item Count',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item count';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Total Items: ${_orderItems.length}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 8),

              // تاريخ التسليم
              ListTile(
                title: Text(
                  _selectedDeadline == null
                      ? 'Select Delivery Deadline'
                      : 'Deadline: ${DateFormat('yyyy-MM-dd').format(_selectedDeadline!)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDeadline(context),
              ),
              const SizedBox(height: 16),

              // حالة الطلب
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Order Status',
                  border: OutlineInputBorder(),
                ),
                items: _statusOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // زر إضافة البنود
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddOrderItemsScreen(
                        initialItems: _orderItems,
                      ),
                    ),
                  );

                  if (result != null && result is List<OrderItem>) {
                    setState(() {
                      _orderItems = result;
                      // تحديث العدد التلقائي إذا تمت إضافة بنود
                      if (_orderItems.isNotEmpty) {
                        _itemCountController.text =
                            _orderItems.fold(0, (sum, item) => sum + item.quantity).toString();
                      }
                    });
                  }
                },
                child: const Text('Add Order Items'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              // عرض البنود المضافة
              if (_orderItems.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Added Items:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ..._orderItems.map((item) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(item.operationDescription),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${item.quantity}'),
                        if (item.materialType.isNotEmpty)
                          Text('Material: ${item.materialType}'),
                        if (item.notes.isNotEmpty)
                          Text('Notes: ${item.notes}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _orderItems.remove(item);
                        });
                      },
                    ),
                  ),
                )).toList(),
              ],

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Order'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
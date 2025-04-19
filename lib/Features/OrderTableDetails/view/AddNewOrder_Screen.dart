import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view_model/add_order_cubit/add_order_cubit.dart';

import '../model/data/Order_model.dart';

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
  DateTime? _selectedDeadline;
  String _selectedStatus = 'Pending';

  final List<String> _statusOptions = [
    'Pending',
    'In Progress',
    'Delivered',
    'Cancelled'
  ];

  @override
  void dispose() {
    _orderNumberController.dispose();
    _companyNameController.dispose();
    _supplyNumberController.dispose();
    _itemCountController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
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
          const SnackBar(content: Text('Please select dates')),
        );
        return;
      }

      // استدعاء الـ Cubit لإضافة الطلب
      context.read<AddOrderCubit>().addOrder(
        orderNumber: _orderNumberController.text,
        companyName: _companyNameController.text,
        supplyNumber: _supplyNumberController.text,
        itemCount: double.parse(_itemCountController.text),
        dateLine: _selectedDeadline!,
        orderStatus: _selectedStatus,
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
              TextFormField(
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
              ),
              const SizedBox(height: 8),
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
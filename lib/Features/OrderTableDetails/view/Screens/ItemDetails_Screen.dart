import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view_model/add_order_cubit/add_order_cubit.dart';

class OrderItemsDetailsScreen extends StatefulWidget {
  final OrderModel order;
  final String orderId;

  const OrderItemsDetailsScreen({
    Key? key,
    required this.order,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderItemsDetailsScreen> createState() => _OrderItemsDetailsScreenState();
}

class _OrderItemsDetailsScreenState extends State<OrderItemsDetailsScreen> {
  late Future<List<OrderItem>> _itemsFuture;
  List<OrderItem> _selectedItems = [];
  final List<String> _itemStatusOptions = ['Pending', 'In Progress', 'Completed'];

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchItemsForOrder();
  }

  Future<List<OrderItem>> _fetchItemsForOrder() async {
    return context.read<AddOrderCubit>().getOrderItems(widget.orderId);
  }

  Future<void> _updateItemStatus(OrderItem item, String newStatus) async {
    try {
      await context.read<AddOrderCubit>().updateItemStatus(
        widget.orderId,
        item.id,
        newStatus,
      );
      setState(() {
        _itemsFuture = _fetchItemsForOrder();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: ${e.toString()}')),
      );
    }
  }

  void _toggleItemSelection(OrderItem item, bool? selected) {
    setState(() {
      if (selected == true) {
        _selectedItems.add(item);
      } else {
        _selectedItems.remove(item);
      }
    });
  }

  void _createInvoiceForSelectedItems() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item')),
      );
      return;
    }

    // هنا يمكنك تنفيذ منطق إنشاء الفاتورة
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceScreen(
          order: widget.order,
          items: _selectedItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Items Details'),
        actions: [
          if (_selectedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.receipt),
              onPressed: _createInvoiceForSelectedItems,
              tooltip: 'Create Invoice for Selected Items',
            ),
        ],
      ),
      body: FutureBuilder<List<OrderItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // معلومات الطلب الأساسية
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company: ${widget.order.companyName}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Attachment Type: ${widget.order.attachmentType}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Deadline: ${widget.order.dateLine}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Order Status: ${widget.order.orderStatus}',
                          style: TextStyle(
                            fontSize: 16,
                            color: _getStatusColor(widget.order.orderStatus),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // قائمة العناصر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Order Items:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_selectedItems.isNotEmpty)
                      Text(
                        '${_selectedItems.length} selected',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = _selectedItems.contains(item);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (value) => _toggleItemSelection(item, value),
                                ),
                                Expanded(
                                  child: Text(
                                    'Item ${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                _buildStatusDropdown(item),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow('Description:', item.operationDescription),
                            _buildDetailRow('Quantity:', item.quantity.toString()),
                            if (item.materialType.isNotEmpty)
                              _buildDetailRow('Material Type:', item.materialType),
                            if (item.notes.isNotEmpty)
                              _buildDetailRow('Notes:', item.notes),
                            if (item.attachments.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Attachments:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 8,
                                    children: item.attachments
                                        .map((attachment) => Chip(
                                      label: Text(attachment),
                                      backgroundColor: Colors.blue[50],
                                    ))
                                        .toList(),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  Widget _buildStatusDropdown(OrderItem item) {
    // تأكد من أن القيمة الحالية موجودة في القائمة
    final currentStatus = _itemStatusOptions.contains(item.status)
        ? item.status
        : _itemStatusOptions.first;

    return DropdownButton<String>(
      value: currentStatus,
      icon: const Icon(Icons.arrow_drop_down),
      underline: Container(),
      onChanged: (String? newValue) {
        if (newValue != null && newValue != item.status) {
          _updateItemStatus(item, newValue);
          setState(() {
            item.status = newValue; // تحديث الحالة محلياً
          });
        }
      },
      items: _itemStatusOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: _getStatusColor(value),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}

// نموذج لشاشة الفاتورة (يمكنك استبدالها بشاشتك الفعلية)
class InvoiceScreen extends StatelessWidget {
  final OrderModel order;
  final List<OrderItem> items;

  const InvoiceScreen({
    Key? key,
    required this.order,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Invoice for Order: ${order.orderNumber}'),
          const SizedBox(height: 20),
          ...items.map((item) => ListTile(
            title: Text(item.operationDescription),
            subtitle: Text('Quantity: ${item.quantity}'),
          )),
        ],
      ),
    );
  }
}
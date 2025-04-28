import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quality_management_system/Core/Utilts/Format_Time.dart';
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
  bool _isListView = true; // Toggle between list and grid view

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

  Map<String, int> _calculateStatusCounts(List<OrderItem> items) {
    final Map<String, int> counts = {
      'Pending': 0,
      'In_Progress': 0,
      'Completed': 0,
      'Total': items.length,
    };

    for (var item in items) {
      if (counts.containsKey(item.status)) {
        counts[item.status] = (counts[item.status] ?? 0) + 1;
      }
    }

    return counts;
  }

  double _calculateCompletionPercentage(Map<String, int> statusCounts) {
    if (statusCounts['Total'] == 0) return 0.0;
    return (statusCounts['Completed'] ?? 0) / statusCounts['Total']! * 100;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isListView ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                _isListView = !_isListView;
              });
            },
            tooltip: _isListView ? 'Grid View' : 'List View',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _itemsFuture = _fetchItemsForOrder();
                _selectedItems.clear();
              });
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<OrderItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];
          final statusCounts = _calculateStatusCounts(items);
          final completionPercentage = _calculateCompletionPercentage(statusCounts);

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _itemsFuture = _fetchItemsForOrder();
              });
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildOrderSummaryCard(theme),
                      const SizedBox(height: 20),
                      _buildStatisticsRow(statusCounts, completionPercentage, theme),
                      const SizedBox(height: 20),
                      _buildProgressChart(statusCounts, theme),
                      const SizedBox(height: 20),
                      _buildSectionHeader('Order Items', _selectedItems.length),
                      const SizedBox(height: 10),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: _isListView
                      ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final item = items[index];
                        final isSelected = _selectedItems.contains(item);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildOrderItemCard(item, isSelected, theme),
                        );
                      },
                      childCount: items.length,
                    ),
                  )
                      : SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final item = items[index];
                        final isSelected = _selectedItems.contains(item);
                        return _buildOrderItemGridCard(item, isSelected, theme);
                      },
                      childCount: items.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80), // Space for bottom button
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _selectedItems.isNotEmpty
          ? FloatingActionButton.extended(
        onPressed: _createInvoiceForSelectedItems,
        icon: const Icon(Icons.receipt_long),
        label: Text('Create Invoice (${_selectedItems.length})'),
        backgroundColor: theme.primaryColor,
      )
          : null,
      bottomNavigationBar: _selectedItems.isNotEmpty
          ? Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: ElevatedButton.icon(
          onPressed: _createInvoiceForSelectedItems,
          icon: const Icon(Icons.receipt_long),
          label: Text('Create Invoice for ${_selectedItems.length} Items'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildStatisticsRow(Map<String, int> statusCounts, double completionPercentage, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatsCard(
            'Pending',
            statusCounts['Pending'].toString(),
            Colors.orange,
            Icons.hourglass_empty,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatsCard(
            'In Progress',
            statusCounts['In Progress'].toString(),
            Colors.blue,
            Icons.loop,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatsCard(
            'Completed',
            statusCounts['Completed'].toString(),
            Colors.green,
            Icons.check_circle_outline,
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(String title, String value, Color color, IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart(Map<String, int> statusCounts, ThemeData theme) {
    final total = statusCounts['Total'] ?? 0;
    if (total == 0) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (statusCounts['Completed'] ?? 0) / total,
                      backgroundColor: Colors.grey[200],
                      color: Colors.green,
                      minHeight: 20,
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        "${((statusCounts['Completed'] ?? 0) / total * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLegendItem('Pending', Colors.orange),
                _buildLegendItem('In Progress', Colors.blue),
                _buildLegendItem('Completed', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

// Replace the problematic date parsing code in _buildOrderSummaryCard method
  Widget _buildOrderSummaryCard(ThemeData theme) {
    String deadlineText = '';

    try {
      // Try to parse the date if it's in yyyy-MM-dd format
      final now = DateTime.now();
      final deadlineDate = DateFormat('yyyy-MM-dd').tryParse(widget.order.dateLine);

      if (deadlineDate != null) {
        final daysRemaining = deadlineDate.difference(now).inDays;
        deadlineText = '${widget.order.dateLine} (${daysRemaining > 0 ? "$daysRemaining days left" : "Overdue"})';
      } else {
        // If parsing fails, just show the original string
        deadlineText = widget.order.dateLine;
      }
    } catch (e) {
      // In case of any error, fall back to the original string
      deadlineText = widget.order.dateLine;
    }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${widget.order.orderNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.order.companyName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.order.orderStatus).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(widget.order.orderStatus),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    widget.order.orderStatus,
                    style: TextStyle(
                      color: _getStatusColor(widget.order.orderStatus),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoRowLight('Attachment Type:', widget.order.attachmentType),
                  const SizedBox(height: 8),
                  _buildInfoRowLight(
                    'Deadline:',
                    deadlineText,
                    textColor: deadlineText.contains("Overdue") ? Colors.orange[100] : Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInfoRowLight(String title, String value, {Color? textColor}) {
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

  Widget _buildOrderItemCard(OrderItem item, bool isSelected, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: theme.primaryColor, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (value) => _toggleItemSelection(item, value),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.operationDescription,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _buildStatusChip(item),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildDetailChip(Icons.format_list_numbered, 'QTY: ${item.quantity}'),
                  if (item.materialType.isNotEmpty)
                    _buildDetailChip(Icons.category, item.materialType),
                ],
              ),
              if (item.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Notes:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.notes,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
              if (item.attachments.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Attachments:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: item.attachments
                      .map((attachment) => Chip(
                    label: Text(
                      attachment,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.blue.shade50,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                  ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItemGridCard(OrderItem item, bool isSelected, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: theme.primaryColor, width: 2)
              : null,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (value) => _toggleItemSelection(item, value),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      _buildStatusIndicator(item.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      item.operationDescription,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildDetailChip(Icons.format_list_numbered, 'QTY: ${item.quantity}'),
                    ],
                  ),
                  if (item.materialType.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.materialType,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (_itemStatusOptions.contains(value)) {
                    _updateItemStatus(item, value);
                  }
                },
                itemBuilder: (context) => [
                  ..._itemStatusOptions.map((status) => PopupMenuItem(
                    value: status,
                    child: Text(
                      status,
                      style: TextStyle(color: _getStatusColor(status)),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderItem item) {
    return DropdownButton<String>(
      value: _itemStatusOptions.contains(item.status) ? item.status : _itemStatusOptions.first,
      icon: const Icon(Icons.arrow_drop_down, size: 20),
      underline: const SizedBox(),
      isDense: true,
      onChanged: (newValue) {
        if (newValue != null && newValue != item.status) {
          _updateItemStatus(item, newValue);
        }
      },
      items: _itemStatusOptions.map((status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _getStatusColor(status).withOpacity(0.5)),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: _getStatusColor(status),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatusIndicator(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int selectedCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            if (selectedCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$selectedCount selected',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ],
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
        return Colors.grey;
    }
  }
}

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
    final theme = Theme.of(context);
    final now = DateTime.now();
    final formattedDate = DateFormat('dd MMM yyyy').format(now);
    final invoiceNumber = 'INV-${now.millisecondsSinceEpoch.toString().substring(7)}';

    // Calculate total items and total price (assuming each item has a price of 100)
    final totalItems = items.fold<int>(0, (sum, item) => sum + item.quantity);
    final totalPrice = items.length * 100.0; // Placeholder calculation

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invoice sharing feature coming soon')),
              );
            },
            tooltip: 'Share Invoice',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Print feature coming soon')),
              );
            },
            tooltip: 'Print Invoice',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INVOICE',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Invoice #: $invoiceNumber',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Date: $formattedDate',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Order #: ${order.orderNumber}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      Text(
                        'Deadline: ${order.dateLine}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Items List
            Text(
              'Items:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => ListTile(
              title: Text(item.materialType),
              subtitle: Text('Quantity: ${item.quantity}'),
              trailing: Text('\$${item.quantity * 100}'), // Placeholder price
            )),

            const Divider(thickness: 1.5),
            const SizedBox(height: 8),

            // Total Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Items:',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$totalItems',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price:',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



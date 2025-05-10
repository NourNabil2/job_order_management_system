import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Network/local_db/share_preference.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Core/Widgets/CustomAppBar_widget.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/InvoiceScreen.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/ItemDetails_Page/widgets/AttachmentListViewer.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/ItemDetails_Page/widgets/OrderSummary_Card.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/ItemDetails_Page/widgets/SectionHeaderSelected.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view_model/Item_details/item_details_cubit.dart';
import 'widgets/OrderItem_Card.dart';
import 'widgets/ProgressChart_widget.dart';
import 'widgets/StatisticsRow_widget.dart';


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

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchItemsForOrder();
  }

  Future<List<OrderItem>> _fetchItemsForOrder() async {
    return context.read<ItemDetailsCubit>().getOrderItems(widget.orderId);
  }

  Future<void> _updateItemStatus(OrderItem item, String newStatus, String itemName ) async {
    try {
      await context.read<ItemDetailsCubit>().updateItemStatus(
        widget.orderId,
        item.id,
        newStatus,
        itemName
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


  Future<void> _updateOrderStatus(OrderModel item, String newStatus) async {
    try {
      await context.read<ItemDetailsCubit>().updateOrderStatus(
        widget.orderId,
        item.id,
        newStatus,
      );
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

  // void _createInvoiceForSelectedItems() {
  //   if (_selectedItems.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please select at least one item')),
  //     );
  //     return;
  //   }
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => InvoiceScreen(
  //         order: widget.order,
  //         items: _selectedItems,
  //       ),
  //     ),
  //   );
  // }

  Map<String, int> _calculateStatusCounts(List<OrderItem> items) {
    final Map<String, int> counts = {
      'Pending': 0,
      'In Progress': 0,
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
      appBar: CustomAppBar(title: 'تفاصيل أمر التوريد', icon: AssetsManager.backtIcon,onTap: () => Navigator.pop(context),),
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
                      OrderSummaryCard(order: widget.order, theme: theme, onStatusChanged: (value) => _updateOrderStatus(widget.order,value),),
                      const SizedBox(height: 20),
                      StatisticsRow( statusCounts: statusCounts, completionPercentage: completionPercentage, theme: theme,),
                      const SizedBox(height: 20),
                      ProgressChart(statusCounts: statusCounts),
                      const SizedBox(height: 20),
                      AttachmentGridViewer(attachmentLinks: widget.order.attachmentLinks,title: 'مرفقات الورشه',),
                      const SizedBox(height: 20),
                     if (CashSaver.userRole != 'work shop') AttachmentGridViewer(attachmentLinks: widget.order.attachmentOrderLinks, title: 'مرفقات أمر التوريد',),
                      const SizedBox(height: 20),
                      buildSectionHeader('Order Items', _selectedItems.length),
                      const SizedBox(height: 10),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver:  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final item = items[index];
                        final isSelected = _selectedItems.contains(item);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: OrderItemCard(item: item, isSelected: isSelected, theme: theme,
                            onSelectionChanged: (value) => _toggleItemSelection(item,value),
                            onStatusChanged: (value) => _updateItemStatus(item,value,item.operationDescription),
                          ),
                        );
                      },
                      childCount: items.length,
                    ),
                  )
                     ,
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80), // Space for bottom button
                ),
              ],
            ),
          );
        },
      ),
      // floatingActionButton: _selectedItems.isNotEmpty
      //     ? FloatingActionButton.extended(
      //   onPressed: _createInvoiceForSelectedItems,
      //   icon: const Icon(Icons.receipt_long),
      //   label: Text('Create Invoice (${_selectedItems.length})'),
      //   backgroundColor: theme.primaryColor,
      // )
      //     : null,
    );
  }

}


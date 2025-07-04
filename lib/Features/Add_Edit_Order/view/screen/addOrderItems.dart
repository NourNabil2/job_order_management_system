import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Core/Widgets/CustomAppBar_widget.dart';
import 'package:quality_management_system/Core/Widgets/Custom_dropMenu.dart';
import 'package:quality_management_system/Core/Widgets/custom_containerStatus.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/AddItemDialog.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/Card_item_widget.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';

class AddOrderItemsScreen extends StatefulWidget {
  final List<OrderItem> initialItems;

  const AddOrderItemsScreen({Key? key, required this.initialItems}) : super(key: key);

  @override
  _AddOrderItemsScreenState createState() => _AddOrderItemsScreenState();
}

class _AddOrderItemsScreenState extends State<AddOrderItemsScreen> {
  late List<OrderItem> _items;
  String _searchQuery = '';
  String _statusFilter = 'جميع الحالات';
  final List<String> _statusFilterOptions = [
    'جميع الحالات',
    'Pending',
    'In_Progress',
    'Complete',
    'Rejected'
  ];

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialItems);
  }

  void _openItemsManager() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AddItemDialog(
            initialItems: _items,
            dialogTitle: 'إدارة بنود الطلب',
            onItemsUpdated: (updatedItems) {
              setState(() {
                _items = updatedItems;
              });
            },
          ),
    );
  }

  void _quickDeleteItem(int index) {
    final item = _items[index];
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange[700], size: 28),
                const SizedBox(width: 8),
                const Text('تأكيد الحذف'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('هل أنت متأكد من حذف هذا البند؟'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.operationDescription,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('الكمية: ${item.quantity}'),
                      Text('الحالة: ${item.status}'),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _items.removeAt(index);
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text('تم حذف البند بنجاح'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      action: SnackBarAction(
                        label: 'تراجع',
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            _items.insert(index, item);
                          });
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('حذف', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  List<OrderItem> get _filteredItems {
    return _items.where((item) {
      final matchesSearch = item.operationDescription
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesStatus = _statusFilter == 'جميع الحالات' ||
          item.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'إدارة بنود الطلب',
        icon: AssetsManager.addItemsIcon,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'manage',
            onPressed: _openItemsManager,
            backgroundColor: Colors.blue[600],
            child: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'إدارة البنود',
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'done',
            onPressed: () => Navigator.pop(context, _items),
            backgroundColor: Colors.green[600],
            icon: const Icon(Icons.done, color: Colors.white),
            label: const Text('انتهاء', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchAndFilter(),
          Expanded(
            child: _items.isEmpty
                ? _buildEmptyState()
                : _filteredItems.isEmpty
                ? _buildEmptyState()
                : ResponsiveBuilder(
              mobileBuilder: (context) => _buildMobileView(),
              desktopBuilder: (context) => _buildDesktopView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.inventory_2, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إدارة بنود الطلب',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'إجمالي البنود: ${_items.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_filteredItems.length} معروض',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'البحث في البنود...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomDropMenu(
              label: 'الحالة',
              value: _statusFilter,
              options: _statusFilterOptions,
              onChanged: (value) {
                setState(() {
                  _statusFilter = value ?? 'جميع الحالات';
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد بنود بعد',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على زر الإضافة لبدء إضافة البنود',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileView() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: OperationCard(
            item: item,
            status: item.status,
            widget: CustomPopupMenu(
              items: const [
                CustomPopupMenuItem(
                  value: 'Edit',
                  label: 'تعديل البند',
                  icon: Icons.edit,
                ),
                CustomPopupMenuItem(
                  value: 'delete',
                  label: 'مسح البند',
                  icon: Icons.delete_forever,
                ),
              ],
              onSelected: (value) {
                if (value == 'Edit') {
                  _openItemsManager();
                } else if (value == 'delete') {
                  _quickDeleteItem(index);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3,
      ),
      itemBuilder: (context, index) {
        final item = _items[index];
        return Card(
          elevation: 2,
          child: OperationCard(
            item: item,
            status: item.status,
            widget: CustomPopupMenu(
              items: const [
                CustomPopupMenuItem(
                  value: 'Edit',
                  label: 'تعديل البند',
                  icon: Icons.edit,
                ),
                CustomPopupMenuItem(
                  value: 'delete',
                  label: 'مسح البند',
                  icon: Icons.delete_forever,
                ),
              ],
              onSelected: (value) {
                if (value == 'Edit') {
                  _openItemsManager();
                } else if (value == 'delete') {
                  _quickDeleteItem(index);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
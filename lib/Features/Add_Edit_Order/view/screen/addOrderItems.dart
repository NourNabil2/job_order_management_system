import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Core/Widgets/CustomAppBar_widget.dart';
import 'package:quality_management_system/Core/Widgets/Custom_dropMenu.dart';
import 'package:quality_management_system/Core/Widgets/custom_containerStatus.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/widget/Card_item_widget.dart';
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
      appBar: const CustomAppBar(title: 'اضافه بنود', icon: AssetsManager.addItemsIcon),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'add',
            onPressed: _addNewItem,
            icon: const Icon(Icons.add),
            label: const Text('إضافة'),
          ),
          const SizedBox(width: 10),
          FloatingActionButton.extended(
            splashColor: ColorApp.primaryColor,
            heroTag: 'done',
            onPressed: () => Navigator.pop(context, _items),
            icon: const Icon(Icons.done),
            label: const Text('انتهاء'),
          ),
        ],
      ),

      body: ResponsiveBuilder(
        mobileBuilder: (context) => ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];
            return OperationCard(
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

                  } else if (value == 'delete') {
                    setState(() {
                      _items.removeAt(index);
                    });
                  }
                },
              ),
            );
          },
        ),
        desktopBuilder: (context) => GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // adjust as needed
            crossAxisSpacing: 40,
            mainAxisSpacing: 12,
            childAspectRatio: 3, // makes cards wider
          ),
          itemBuilder: (context, index) {
            final item = _items[index];
            return OperationCard(
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
                onSelected: (value) async {
                  if (value == 'Edit') {
                    await showDialog<OrderItem>(
                      context: context,
                      builder: (context) => AddItemDialog(
                        existingItem: item,
                        onItemAdded: (updatedItem) {
                          setState(() {
                            _items[index] = updatedItem;
                          });
                        },
                      ),
                    );
                  } else if (value == 'delete') {
                    setState(() {
                      _items.removeAt(index);
                    });
                  }
                },
              ),

            );
          },
        ),
      ),
    );
  }
}
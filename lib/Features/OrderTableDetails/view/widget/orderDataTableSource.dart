import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Widgets/Custom_dropMenu.dart';
import 'package:quality_management_system/Core/Widgets/custom_containerStatus.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/ItemDetails_Page/ItemDetails_Screen.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view_model/Item_details/item_details_cubit.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view_model/add_order_cubit/add_order_cubit.dart';

class OrderDataTableSource extends DataTableSource {
  final List<OrderModel> orders;
  final BuildContext context;

  OrderDataTableSource(this.orders, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= orders.length) return null;
    final order = orders[index];

    return DataRow.byIndex(
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (order.orderStatus == 'Delivered') return Colors.green[50];
        return index % 2 == 0 ? Colors.grey[100] : Colors.white;
      }),
      index: index,
      cells: [
        DataCell(Text(order.orderNumber)),
        DataCell(Text(order.companyName)),
        DataCell(Text(order.supplyNumber)),
        DataCell(Text('${order.itemCount}')),
        DataCell(Text(order.attachmentType)),
        DataCell(Text(order.date),),
        DataCell(Text(order.dateLine),),
        DataCell(StatusContainer(status: order.orderStatus,)),
        DataCell(
          CustomPopupMenu(
            items: const [
              CustomPopupMenuItem(
                value: 'view_details',
                label: 'View Item Details',
                icon: Icons.remove_red_eye,
              ),
              CustomPopupMenuItem(
                value: 'create_invoice',
                label: 'Create Invoice',
                icon: Icons.receipt,
              ),
            ],
            onSelected: (value) {
              if (value == 'view_details') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ItemDetailsCubit(),
                      child: OrderItemsDetailsScreen(
                        order: order,
                        orderId: order.id,
                      ),
                    ),
                  ),
                );
              } else if (value == 'create_invoice') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invoice created for ${order.orderNumber}'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => orders.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
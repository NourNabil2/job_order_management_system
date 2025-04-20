import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/AddNewOrder_Screen.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/ItemDetails_Screen.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/widget/Table_header.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view_model/add_order_cubit/add_order_cubit.dart';

class OrdersTableExample1 extends StatefulWidget {
  const OrdersTableExample1({super.key});

  @override
  State<OrdersTableExample1> createState() => _OrdersTableExample1State();
}

class _OrdersTableExample1State extends State<OrdersTableExample1> {
  late var _rowsPerPage = 10;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  int _currentPage = 0;
  List<OrderModel> _sortedOrders = []; // قائمة منفصلة للبيانات بعد الفرز
  final PaginatorController _paginatorController = PaginatorController();

  void _sort<T>(Comparable<T> Function(OrderModel d) getField, int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      _sortedOrders.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeApp.defaultPadding),
      child: Column(
        children: [
          OrderHeader(
            title: 'Orders',
            buttonText: 'Add Order',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => AddOrderCubit(),
                    child: AddOrderScreen(
                      onOrderAdded: (p0) {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          BlocProvider(
  create: (context) => AddOrderCubit(),
  child: BlocConsumer<AddOrderCubit, AddOrderState>(
            listener: (context, state) {
              if (state is OrdersLoaded) {
                setState(() {
                  _sortedOrders = List.from(state.orders); // تحديث القائمة المفرزة
                });
              }
            },
            builder: (context, state) {
              if (state is AddOrderInitial || state is AddOrderLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is AddOrderError) {
                return Center(child: Text('Error: ${state.error}'));
              }

              final paginatedData = _sortedOrders
                  .skip(_currentPage * _rowsPerPage)
                  .take(_rowsPerPage)
                  .toList();

              return SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: PaginatedDataTable2(
                  horizontalMargin: 20,
                  checkboxHorizontalMargin: 12,
                  columnSpacing: 0,
                  headingRowColor:
                  const WidgetStatePropertyAll(ColorApp.lightGreyColor),
                  wrapInCard: false,
                  renderEmptyRowsInTheEnd: false,
                  minWidth: 800,
                  fit: FlexFit.tight,
                  controller: _paginatorController,
                  rowsPerPage: _rowsPerPage,
                  availableRowsPerPage: const [5, 10, 20],
                  onRowsPerPageChanged: (value) {
                    setState(() {
                      _rowsPerPage = value ?? 10;
                    });
                  },
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  empty: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.grey.shade200,
                      child: const Text('No products found'),
                    ),
                  ),
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columns: [
                    DataColumn(
                      label: const Text('#'),
                      onSort: (columnIndex, ascending) => _sort<String>(
                              (d) => d.orderNumber, columnIndex, ascending),
                    ),
                    const DataColumn(
                      label: Text('أسم الشركه'),
                    ),
                    DataColumn(
                      label: const Text('أمر التوريد'),
                      onSort: (columnIndex, ascending) => _sort<String>(
                              (d) => d.supplyNumber, columnIndex, ascending),
                    ),
                    DataColumn(
                      label: const Text('عدد البنود'),
                      onSort: (columnIndex, ascending) =>
                          _sort<num>((d) => d.itemCount, columnIndex, ascending),
                    ),
                    DataColumn(
                      label: const Text('نوع المرفقات'),
                      onSort: (columnIndex, ascending) =>
                          _sort<num>((d) => d.itemCount, columnIndex, ascending),
                    ),
                    DataColumn(
                      label: const Text('التاريخ'),
                      onSort: (columnIndex, ascending) =>
                          _sort<DateTime>((d) => d.date, columnIndex, ascending),
                    ),
                    DataColumn(
                      label: const Text('موعد التسليم'),
                      onSort: (columnIndex, ascending) => _sort<DateTime>(
                              (d) => d.dateLine, columnIndex, ascending),
                    ),
                    const DataColumn(
                      label: Text('حاله التسليم'),
                    ),
                    const DataColumn(label: Text('Actions')),
                  ],
                  source: _OrderDataTableSource(paginatedData, context),
                ),
              );
            },
          ),
),
        ],
      ),
    );
  }
}

class _OrderDataTableSource extends DataTableSource {
  final List<OrderModel> orders;
  final BuildContext context;

  _OrderDataTableSource(this.orders, this.context);

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
        DataCell(
          Text('${order.date}'),
        ),
        DataCell(
          Text('${order.dateLine}'),
        ),
        DataCell(Text(order.orderStatus)),
        DataCell(
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'view_details',
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('View Item Details'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'create_invoice',
                child: Row(
                  children: [
                    Icon(Icons.receipt, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Create Invoice'),
                  ],
                ),
              ),
            ],
            onSelected: (String value) async {
              if (value == 'view_details') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => AddOrderCubit(),
                      child: OrderItemsDetailsScreen(
                        order: order,
                        orderId: order.id,
                      ),
                    ),
                  ),
                );
              } else if (value == 'create_invoice') {
                // تنفيذ إنشاء الفاتورة

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

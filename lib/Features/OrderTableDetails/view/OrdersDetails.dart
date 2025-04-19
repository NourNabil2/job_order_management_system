import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/AddNewOrder_Screen.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/widget/Table_header.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view_model/add_order_cubit/add_order_cubit.dart';

class OrdersTableExample1 extends StatefulWidget {
  const OrdersTableExample1({super.key});

  @override
  State<OrdersTableExample1> createState() => _OrdersTableExample1State();
}

class _OrdersTableExample1State extends State<OrdersTableExample1> {
  final List<OrderModel> _orders =
      generateFakeOrders(50); // زيادة عدد العناصر للتنقل بين الصفحات
  late var _rowsPerPage = 10; // عدد الصفوف لكل صفحة
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  int _currentPage = 0;
  final PaginatorController _paginatorController = PaginatorController();
  void _sort<T>(Comparable<T> Function(OrderModel d) getField, int columnIndex,
      bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      _orders.sort((a, b) {
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
    final paginatedData =
        _orders.skip(_currentPage * _rowsPerPage).take(_rowsPerPage).toList();

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
                  ));
            },
          ),
          BlocProvider(
  create: (context) => AddOrderCubit(),
  child: BlocBuilder<AddOrderCubit, AddOrderState>(
  builder: (context, state) {
    List<OrderModel> orders = [];
    if (state is OrdersLoaded) {
      orders = state.orders;
    } else if (state is AddOrderInitial || state is AddOrderLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is AddOrderError) {
      return Center(child: Text('Error: ${state.error}'));
    }

    final paginatedData = orders.skip(_currentPage * _rowsPerPage).take(_rowsPerPage).toList();

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
        DataCell(
          Text('${order.date}'),
        ),
        DataCell(
          Text('${order.dateLine}'),
        ),
        DataCell(Text(order.orderStatus)),
        DataCell(IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Action on ${order.orderNumber}')),
            );
          },
        )),
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

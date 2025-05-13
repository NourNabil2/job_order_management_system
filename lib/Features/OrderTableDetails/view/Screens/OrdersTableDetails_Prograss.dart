import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/screen/AddOrder_Screen.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view_model/add_order_cubit.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/widget/Table_header.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/widget/orderDataTableSource.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view_model/order_progress/order_progress_cubit.dart';


class OrdersTableDetailsProgress extends StatefulWidget {
  const OrdersTableDetailsProgress({super.key});

  @override
  State<OrdersTableDetailsProgress> createState() => _OrdersTableDetailsProgressState();
}

class _OrdersTableDetailsProgressState extends State<OrdersTableDetailsProgress> {
  late var _rowsPerPage = 100;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  int _currentPage = 0;
  List<OrderModel> _sortedOrders = []; // قائمة منفصلة للبيانات بعد الفرز
  final List<int> _availableRowsOptions = [5, 10, 15, 30, 50, 70, 100, 120, 200]; // اعتبر 1000000 = الكل

  final PaginatorController _paginatorController = PaginatorController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeApp.defaultPadding),
      child: Column(
        children: [
          OrderHeader(
            title: 'Orders (قيد العمل)',
            buttonText: 'Add Order',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => AddNewOrderCubit(),
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
          ResponsiveBuilder(
            mobileBuilder: (p0) => _buildOrderTable(false),
            desktopBuilder: (p0) => Expanded(child: _buildOrderTable(true)),
          )
        ],
      ),
    );
  }

  Widget _buildOrderTable(bool isDesktop) {
    return BlocProvider(
      create: (context) => OrderProgressCubit(), // استدعاء دالة تحميل الطلبات المعلقة فقط
      child: BlocConsumer<OrderProgressCubit, OrderProgressState>(
        listener: (context, state) {
          if (state is OrderFilterLodded) {
            _sortedOrders = List.from(state.orders); // تحديث القائمة المفرزة
          }
        },
        builder: (context, state) {

          if (state is OrderFilterLoddedError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          if (state is OrderFilterEmpty) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.grey.shade200,
                child: const Text('No pending orders found'),
              ),
            );
          }

          final paginatedData = _rowsPerPage >= _sortedOrders.length
              ? _sortedOrders
              : _sortedOrders.skip(_currentPage * _rowsPerPage).take(_rowsPerPage).toList();

          return SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: PaginatedDataTable2(
              horizontalMargin: 20,
              checkboxHorizontalMargin: 12,
              columnSpacing: 0,
              headingRowColor: const WidgetStatePropertyAll(ColorApp.lightGreyColor),
              wrapInCard: false,
              renderEmptyRowsInTheEnd: false,
              minWidth: 800,

              fit: FlexFit.tight,
              controller: _paginatorController,
              rowsPerPage: _rowsPerPage,
              availableRowsPerPage: _availableRowsOptions,
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
                  child: const Text('No pending orders found'),
                ),
              ),
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              columns: [
                DataColumn(
                  label: const Text('#'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      OrderProgressCubit.get(context).sortOrders<String>(
                        _sortedOrders,
                            (order) => order.orderNumber,
                        ascending,
                      );
                    });
                  },
                ),
                const DataColumn(
                  label: Text('أسم الشركه'),
                ),
                DataColumn(
                  label: const Text('أمر التوريد'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      OrderProgressCubit.get(context).sortOrders<String>(
                        _sortedOrders,
                            (order) => order.supplyNumber,
                        ascending,
                      );
                    });
                  },
                ),
                DataColumn(
                  label: const Text('عدد البنود'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      OrderProgressCubit.get(context).sortOrders<num>(
                        _sortedOrders,
                            (order) => order.itemCount,
                        ascending,
                      );
                    });
                  },
                ),
                DataColumn(
                  label: const Text('نوع المرفقات'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      OrderProgressCubit.get(context).sortOrders<String>(
                        _sortedOrders,
                            (order) => order.attachmentType,
                        ascending,
                      );
                    });
                  },
                ),
                DataColumn(
                  label: const Text('التاريخ'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      OrderProgressCubit.get(context).sortOrders<String>(
                        _sortedOrders,
                            (order) => order.date,
                        ascending,
                      );
                    });
                  },
                ),
                DataColumn(
                  label: const Text('موعد التسليم'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      OrderProgressCubit.get(context).sortOrders<String>(
                        _sortedOrders,
                            (order) => order.dateLine,
                        ascending,
                      );
                    });
                  },
                ),
                const DataColumn(
                  label: Text('حاله التسليم'),
                ),
                const DataColumn(label: Text('Actions')),
              ],
              source: OrderDataTableSource(paginatedData, context),
            ),
          );
        },
      ),
    );
  }
}
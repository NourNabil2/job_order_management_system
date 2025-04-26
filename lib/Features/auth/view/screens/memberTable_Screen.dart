import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Core/components/loading_spinner.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view/screen/AddOrder_Screen.dart';
import 'package:quality_management_system/Features/Add_Edit_Order/view_model/add_order_cubit.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/Order_model.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/widget/Table_header.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/widget/orderDataTableSource.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view_model/add_order_cubit/add_order_cubit.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_model.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_role.dart';
import 'package:quality_management_system/Features/auth/view/cubits/add_member_cubit/add_member_cubit.dart';
import 'package:quality_management_system/Features/auth/view/screens/add_member_screen.dart';
import 'package:quality_management_system/Features/auth/view/widgets/memberDataTableSource.dart';
import 'package:quality_management_system/dependency_injection.dart';

class MembertableScreen extends StatefulWidget {
  const MembertableScreen({super.key});

  @override
  State<MembertableScreen> createState() => _MembertableScreenState();
}

class _MembertableScreenState extends State<MembertableScreen> {
  late var _rowsPerPage = 100;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  List<UserModel> members = [];
  List<OrderModel> _sortedOrders = []; // قائمة منفصلة للبيانات بعد الفرز
  final List<int> _availableRowsOptions = [5, 10, 15, 30, 50, 70,100, 120,200]; // اعتبر 1000000 = الكل

  final PaginatorController _paginatorController = PaginatorController();



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeApp.defaultPadding),
      child: Column(
        children: [
          OrderHeader(
            title: 'Members',
            buttonText: 'Add Member',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const Dialog(
                  backgroundColor: Colors.transparent,
                  child: SizedBox(
                    child: AddMemberScreen(),
                  ),
                ),
              );
            },
          ),
          BlocProvider(
            create: (context) => sl<AddMemberCubit>(),
            child: BlocConsumer<AddMemberCubit, AddMemberState>(
              listener: (context, state) {
                if (state is FetchMembersSuccess) {
                  members = state.members;

                }
              },
              builder: (context, state) {
                if (state is AddMemberInitial) {
                  return const LoadingSpinner();
                } else if (state is FetchMembersFailure) {
                  return Center(child: Text(state.message));
                }
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
                    availableRowsPerPage: _availableRowsOptions,
                    onRowsPerPageChanged: (value) {

                      _rowsPerPage = value ?? 10;

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
                        onSort: (columnIndex, ascending) {

                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;

                          // AddOrderCubit.get(context).sortOrders<String>(
                          //   _sortedOrders,
                          //       (order) => order.orderNumber,
                          //   ascending,
                          // );
                        },
                      ),
                      const DataColumn(
                        label: Text('أسم الموظف'),
                      ),
                      const DataColumn(
                        label: Text('وظيفته'),
                      ),
                      const DataColumn(
                        label: Text('حالة الحساب'),
                      ),
                      const DataColumn(label: Text('Actions')),
                    ],
                    source: MemberDataTableSource(members, context),
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



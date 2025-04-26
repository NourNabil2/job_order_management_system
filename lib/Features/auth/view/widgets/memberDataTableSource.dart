import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Widgets/custom_containerStatus.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_model.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_role.dart';

class MemberDataTableSource extends DataTableSource {
  final List<UserModel> members;
  final BuildContext context;

  MemberDataTableSource(this.members, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= members.length) return null;
    final member = members[index];
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(member.name)),
        DataCell(Text(member.role.value)),
        DataCell(StatusContainer(status: member.uid == '' ? 'Inactive' : 'Active')),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Action for editing member
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Action for deleting member
              },
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => members.length;

  @override
  int get selectedRowCount => 0;
}

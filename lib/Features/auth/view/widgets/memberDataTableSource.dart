import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Widgets/custom_containerStatus.dart';
import 'package:quality_management_system/Features/auth/domain/models/user_model.dart';
import 'package:quality_management_system/Features/auth/view/screens/add_member_screen.dart';

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
        DataCell(Text(member.role ?? 'No Role')),
        DataCell(StatusContainer(status: member.uid == '' ? 'Inactive' : 'Active')),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _navigateToEditMember(context, member),
            ),
          ],
        )),
      ],
    );
  }

  void _navigateToEditMember(BuildContext context, UserModel member) {
    // Create a safe copy of the model in case properties are null
    final UserModel safeModel = UserModel(
      name: member.name,
      email: member.email,
      role: member.role ?? '',
      uid: member.uid ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          child:  AddMemberScreen(memberToEdit: safeModel),
        ),
      ),
    );

  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => members.length;

  @override
  int get selectedRowCount => 0;
}
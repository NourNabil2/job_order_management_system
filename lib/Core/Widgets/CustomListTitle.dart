
import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Widgets/alert_widget.dart';
import 'package:quality_management_system/Core/Widgets/bottomsheet_options.dart';

class CustomListTitle extends StatelessWidget {
 


  const CustomListTitle({super.key,this.message, this.iPAddress, this.id, this.createdAt,});
 final  message;
  final  iPAddress;
  final  id;
  final  createdAt;
  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: EdgeInsets.all(SizeApp.s10),
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(SizeApp.s5)),
            child: ListTile(
              minVerticalPadding: 8,
              minLeadingWidth: 4,
              title: InkWell(
                onLongPress: () => showBottomSheetOption(context, message, () {
                  showCustomAlertDialog(
                    context: context, title: 'Report this message', content: 'Our team will review the content and take appropriate action.',
                    confirmText: 'Report',
                    onCancel: () => Navigator.pop(context),
                    onConfirm: () {
                      // NotificationCubit.get(context).send_Report(iPAddress: iPAddress, message: message, reportID: id);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } ,
                  );
                },), // Copy text to clipboard,
                child: Text(
                    textDirection: TextDirection.rtl,
                    message ?? 'No message available', style: Theme.of(context).textTheme.bodyMedium ),
              ),
              subtitle: Text(
                '${createdAt}',
                style: const TextStyle(color: Colors.grey),
              ),
            )
        )
    );
  }
}

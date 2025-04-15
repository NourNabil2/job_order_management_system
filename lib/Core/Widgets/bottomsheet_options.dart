import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quality_management_system/Core/Widgets/CustomSnackBar_widget.dart';


void showBottomSheetOption(BuildContext context, String message ,VoidCallback report,) {
  showModalBottomSheet(
    backgroundColor: Theme.of(context).cardColor,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (_) {
      return ListView(
        shrinkWrap: true,
        children: [
          // Divider
          Container(
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 150),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // Copy Option
          OptionItemUsers(
            icon: Icon(
              Icons.copy,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            name: 'Copy',
            onTap: () {
              // Copy message to clipboard
              Clipboard.setData(ClipboardData(text: message));
              Navigator.pop(context);
              Dialogs.showSnackbar(context, 'Message copied to clipboard');
            },
          ),
          // Report Option
          OptionItemUsers(
            icon: Icon(
              Icons.location_on_outlined,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            name: 'Show Location',
            onTap: () {
              // NotificationCubit.get(context).launchURL(message);
            },
          ),

          OptionItemUsers(
            icon: Icon(
              Icons.report,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            name: 'Report',
            onTap: report,
          ),
        ],
      );
    },
  );
}

class OptionItemUsers extends StatelessWidget {
  final Icon icon;
  final String name;
  final Function() onTap;

  const OptionItemUsers({
    Key? key,
    required this.icon,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

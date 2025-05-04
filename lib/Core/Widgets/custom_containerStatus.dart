import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';

class StatusContainer extends StatelessWidget {
  final String status;
  final Map<String, StatusStyle> statusStyles;

  const StatusContainer({
    super.key,
    required this.status,
    this.statusStyles = defaultStatusStyles,
  });

  @override
  Widget build(BuildContext context) {
    final style = statusStyles[status.toLowerCase()] ??
        statusStyles.values.firstWhere(
              (element) => element.isDefault,
          orElse: () => const StatusStyle(
            text: 'Unknown',
            color: Colors.grey,
            isDefault: true,
          ),
        );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeApp.padding * 1.5,
        vertical: SizeApp.padding / 2,
      ),
      decoration: BoxDecoration(
        color: style.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(SizeApp.radius * 2),
        // border: Border.all(
        //   color: style.color.withOpacity(0.5),
        //   width: 1,
        // ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (style.icon != null) ...[
            // Icon(
            //   style.icon,
            //   size: SizeApp.iconSizeSmall,
            //   color: style.color,
            // ),
            // SizedBox(width: SizeApp.padding / 2),
          ],
          Text(
            style.text ?? status,
            style: TextStyle(
              color: style.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusStyle {
  final String? text;
  final Color color;
  final IconData? icon;
  final bool isDefault;

  const StatusStyle({
    this.text,
    required this.color,
    this.icon,
    this.isDefault = false,
  });
}

// الأنماط الافتراضية
const Map<String, StatusStyle> defaultStatusStyles = {
  'pending': StatusStyle(
    text: 'قيد الانتظار',
    color: Colors.orange,
    icon: Icons.access_time,
  ),
  'collected': StatusStyle(
    text: 'تم التحصيل',
    color: Colors.green,
    icon: Icons.check_circle,
  ),
  'active': StatusStyle(
    text: 'مفعل',  // "مفعل" للحالة الفعالة
    color: Colors.green,
    icon: Icons.check_circle,
  ),
  'inactive': StatusStyle(
    text: 'غير مفعل',  // "غير مفعل" للحالة غير الفعالة
    color: Colors.red,
    icon: Icons.cancel,
  ),
  'rejected': StatusStyle(
    text: 'مرفوض',
    color: Colors.red,
    icon: Icons.cancel,
  ),
  'in_progress': StatusStyle(
    text: 'قيد العمل',
    color: Colors.blue,
    icon: Icons.autorenew,
  ),
  'completed': StatusStyle(
    text: 'تم الانتهاء',
    color: Colors.green,
    icon: Icons.done_all,
  ),
  'default': StatusStyle(
    text: 'Unknown',
    color: Colors.grey,
    isDefault: true,
  ),
};

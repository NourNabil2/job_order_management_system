import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';

class CustomPopupMenu extends StatelessWidget {
  final List<CustomPopupMenuItem> items;
  final void Function(String value) onSelected;
  final IconData icon;

  const CustomPopupMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.icon = Icons.more_vert,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(icon),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeApp.radius),
      ),
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<String>(
            value: item.value,
            padding: EdgeInsets.zero, // إزالة الباددنج الداخلي
            child: _PopupMenuItemContent(item: item),
          );
        }).toList();
      },
      onSelected: onSelected,
    );
  }
}

class _PopupMenuItemContent extends StatefulWidget {
  final CustomPopupMenuItem item;

  const _PopupMenuItemContent({required this.item});

  @override
  State<_PopupMenuItemContent> createState() => _PopupMenuItemContentState();
}

class _PopupMenuItemContentState extends State<_PopupMenuItemContent> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        width: double.infinity, // يشغل المساحة كاملة
        padding: EdgeInsets.all(SizeApp.padding),
        decoration: BoxDecoration(
          color: isHovered ? ColorApp.primaryColor.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              widget.item.icon,
              color: isHovered
                  ? widget.item.iconColor ?? ColorApp.primaryColor
                  : widget.item.iconColor ?? ColorApp.mainDark,
            ),
            SizedBox(width: SizeApp.padding),
            Expanded( // يجعل النص يشغل المساحة المتبقية
              child: Text(
                widget.item.label,
                style: TextStyle(
                  color: isHovered ? ColorApp.primaryColor : ColorApp.blackColor,
                  fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPopupMenuItem {
  final String value;
  final String label;
  final IconData icon;
  final Color? iconColor;

  const CustomPopupMenuItem({
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor,
  });
}
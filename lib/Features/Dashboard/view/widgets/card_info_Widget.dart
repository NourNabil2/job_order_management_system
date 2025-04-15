import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String count;
  final Color color;

  const DashboardCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeApp.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: SizeApp.iconSizeMedium, color: color),
                  const SizedBox(width: 15.0),//todo:: don't use hard code :: replace it
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 26), //todo:: from Theme not static
                      ),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 20.0), //todo:: don't use hard code :: replace it
              Text(
                count,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),//todo:: from Theme not static
              ),
            ],
          ),
        ),
      ),
    );
  }
}

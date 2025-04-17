import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';


class InteractionItem extends StatelessWidget {
  final Color color;
  final double? radius;
  final String title;
  final int? count;

  const InteractionItem({
    super.key,
    required this.color,
    required this.title,
    this.radius,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeApp.s8,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: radius ?? SizeApp.s5,
            backgroundColor: color,
          ),
          SizedBox(width: SizeApp.s5),
          Flexible( // Allows text to wrap if needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium!,
                  softWrap: true,
                ),
                count == null ? const SizedBox() : Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: ColorApp.blackColor20,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
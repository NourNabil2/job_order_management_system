import 'package:flutter/material.dart';

class ProgressLegendItem {
  final String label;
  final Color color;

  const ProgressLegendItem(this.label, this.color);
}

class ProgressLegend extends StatelessWidget {
  final List<ProgressLegendItem> items;
  final double itemSpacing;
  final TextStyle? textStyle;
  final double indicatorSize;

  const ProgressLegend({
    super.key,
    required this.items,
    this.itemSpacing = 8,
    this.textStyle,
    this.indicatorSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) => _buildLegendItem(item)).toList(),
    );
  }

  Widget _buildLegendItem(ProgressLegendItem item) {
    return Row(
      children: [
        Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            color: item.color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: itemSpacing / 2),
        Text(
          item.label,
          style: textStyle ?? TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
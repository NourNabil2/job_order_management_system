import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatisticsRow extends StatelessWidget {
  final Map<String, int> statusCounts;
  final double completionPercentage;
  final ThemeData theme;

  const StatisticsRow({
    super.key,
    required this.statusCounts,
    required this.completionPercentage,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatsCard(
            'Pending',
            statusCounts['Pending'].toString(),
            Colors.orange,
            Icons.hourglass_empty,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatsCard(
            'In Progress',
            statusCounts['In Progress'].toString(),
            Colors.blue,
            Icons.loop,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatsCard(
            'Completed',
            statusCounts['Completed'].toString(),
            Colors.green,
            Icons.check_circle_outline,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
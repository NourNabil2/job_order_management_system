import 'package:flutter/material.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/ItemDetails_Page/widgets/ProgressLegend_Item.dart';

class ProgressChart extends StatelessWidget {
  final Map<String, int> statusCounts;
  final String title;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;

  const ProgressChart({
    super.key,
    required this.statusCounts,
    this.title = 'Order Progress',
    this.height = 40,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final total = statusCounts['Total'] ?? 0;
    if (total == 0) return const SizedBox.shrink();

    final completedCount = statusCounts['Completed'] ?? 0;
    final progressValue = completedCount / total;
    final percentageText = '${(progressValue * 100).toStringAsFixed(1)}%';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: height,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius / 2),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      backgroundColor: Colors.grey[200],
                      color: Colors.green,
                      minHeight: 20,
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        percentageText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const ProgressLegend(
              items: [
                ProgressLegendItem('Pending', Colors.orange),
                ProgressLegendItem('In Progress', Colors.blue),
                ProgressLegendItem('Completed', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


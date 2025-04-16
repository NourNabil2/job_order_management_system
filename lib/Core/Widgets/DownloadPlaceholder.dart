
import 'package:flutter/material.dart';

class DownloadPlaceholder extends StatelessWidget {
  final VoidCallback? onRetry; // Callback when retry button is pressed

  const DownloadPlaceholder({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade300, // Softer grey background
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // **Loading Indicator**
          const CircularProgressIndicator(
            color: Colors.black54, // Subtle color
            strokeWidth: 3,
          ),
          const SizedBox(height: 10),

          // **Retry Button**
          TextButton.icon(
            onPressed: onRetry ?? () {}, // Default to empty function if null
            icon: const Icon(Icons.download, color: Colors.black54),
            label: const Text("Retry Download", style: TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final double borderRadius;
  final BoxFit fit;
  final VoidCallback? onTap;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.borderRadius = 12.0,
    this.fit = BoxFit.cover,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          imageUrl,
          height: height,
          width: width,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              color: Colors.grey[300],
              child: const CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            height: height,
            width: width,
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, color: Colors.red, size: 40),
          ),
        ),
      ),
    );
  }
}

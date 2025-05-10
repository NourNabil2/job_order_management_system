import 'package:cached_network_image/cached_network_image.dart';
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
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: height,
          width: width,
          fit: fit,
          placeholder: (context, url) => Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            color: Colors.grey[300],
            child: const CircularProgressIndicator(),
          ),
          errorWidget: (context, error, stackTrace) => Container(
            height: height,
            width: width,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.red, size: 40),
          ),
        ),
      ),
    );
  }
}

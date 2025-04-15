import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcon extends StatelessWidget {
  final String assetPath; // Path to the SVG asset
  final double? size; // Size of the icon
  final Color? color; // Color of the icon
  final BoxFit? fit; // How the SVG should be fitted within the space
  final bool isImage;
  final VoidCallback? onTap;

  const CustomIcon({
    Key? key,
    required this.assetPath,
    this.size,
    this.color,
    this.fit,
    this.onTap,
    this.isImage = false ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isImage ? Image.asset(assetPath,width: size) : SvgPicture.asset(
        assetPath, // Path to the SVG file in the assets folder
        width: size, // Optional: Set the width of the icon
        height: size, // Optional: Set the height of the icon
        colorFilter: color == null ?  null : ColorFilter.mode(color!, BlendMode.srcIn), // Optional: Apply a color to the SVG
        fit: fit ?? BoxFit.contain, // Optional: Define how the SVG should be fitted
      ),
    );
  }
}
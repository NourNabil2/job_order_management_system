import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  final Color? color; // Allow nullable for custom colors
  final double size;

  const LoadingSpinner({
    Key? key,
    this.color,  // Default color is handled in the build method
    this.size = 50.0, // Default size if not specified
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color ?? Theme.of(context).primaryColor, // Use passed color or theme's primary color
      size: size,
    );
  }
}

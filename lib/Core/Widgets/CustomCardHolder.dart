import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double? height;
  final Color? backgroundColor;

  const CustomContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(8),
    this.margin = const EdgeInsets.symmetric(vertical:16),
    this.borderRadius = 16,
    this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: margin,
        child: Container(
          height: height ,
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: backgroundColor ?? Color(0xFFFFFFFF),
          ),
          child: child,
        ),
      ),
    );
  }
}
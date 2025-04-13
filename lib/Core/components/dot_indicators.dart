import 'package:flutter/material.dart';

import '../Utilts/Constants.dart';



class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
    this.inActiveColor,
    this.activeColor = ColorApp.primaryColor,
  });

  final bool isActive;

  final Color? inActiveColor, activeColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: defaultDuration,
      height: isActive ? 16 : 6,
      width: 6,
      decoration: BoxDecoration(
        color: isActive
            ? activeColor
            : inActiveColor ?? ColorApp.bg_gray,
        borderRadius: const BorderRadius.all(Radius.circular(defaultPadding)),
      ),
    );
  }
}

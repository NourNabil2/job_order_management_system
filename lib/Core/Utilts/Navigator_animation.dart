import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final AnimationType animationType;

  CustomPageRoute({
    required this.page,
    this.animationType = AnimationType.slideFromRight,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (animationType) {
        case AnimationType.fade:
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        case AnimationType.slideFromRight:
          const beginRight = Offset(1.0, 0.0);
          return _buildSlideTransition(animation, child, beginRight);
        case AnimationType.slideFromLeft:
          const beginLeft = Offset(-1.0, 0.0);
          return _buildSlideTransition(animation, child, beginLeft);
        case AnimationType.slideFromTop:
          const beginTop = Offset(0.0, -1.0);
          return _buildSlideTransition(animation, child, beginTop);
        case AnimationType.slideFromBottom:
          const beginBottom = Offset(0.0, 1.0);
          return _buildSlideTransition(animation, child, beginBottom);

      }
    },
  );

  static Widget _buildSlideTransition(
      Animation<double> animation, Widget child, Offset begin) {
    const curve = Curves.easeInOut;
    var tween = Tween(begin: begin, end: Offset.zero).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}

enum AnimationType {
  fade,
  slideFromRight,
  slideFromLeft,
  slideFromTop,
  slideFromBottom,
}
import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double _mobileMaxWidth = 600;
  static const double _tabletMaxWidth = 1200;

  /// Check if current screen size is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < _mobileMaxWidth;
  }

  /// Check if current screen size is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _mobileMaxWidth && width < _tabletMaxWidth;
  }

  /// Check if current screen size is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= _tabletMaxWidth;
  }

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get responsive value based on screen size
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context)) {
      return tablet ?? desktop;
    } else {
      return mobile;
    }
  }

  /// Get responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return getResponsiveValue(
      context: context,
      mobile: const EdgeInsets.all(16.0),
      tablet: const EdgeInsets.all(24.0),
      desktop: const EdgeInsets.all(32.0),
    );
  }

  /// Get responsive font size
  static double responsiveFontSize(
      BuildContext context, {
        required double mobile,
        double? tablet,
        required double desktop,
      }) {
    return getResponsiveValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive widget
  static Widget responsiveWidget({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    required Widget desktop,
  }) {
    return getResponsiveValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Calculate adaptive width percentage of screen
  static double adaptiveWidth(BuildContext context, double percentage) {
    return screenWidth(context) * percentage;
  }

  /// Calculate adaptive height percentage of screen
  static double adaptiveHeight(BuildContext context, double percentage) {
    return screenHeight(context) * percentage;
  }

  /// Get orientation-specific widget
  static Widget orientationWidget({
    required BuildContext context,
    required Widget portrait,
    required Widget landscape,
  }) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait ? portrait : landscape;
  }
}

/// Responsive builder widget that renders different UIs based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext) mobileBuilder;
  final Widget Function(BuildContext)? tabletBuilder;
  final Widget Function(BuildContext) desktopBuilder;

  const ResponsiveBuilder({
    super.key,
    required this.mobileBuilder,
    this.tabletBuilder,
    required this.desktopBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return desktopBuilder(context);
    } else if (ResponsiveHelper.isTablet(context)) {
      return tabletBuilder != null
          ? tabletBuilder!(context)
          : desktopBuilder(context);
    } else {
      return mobileBuilder(context);
    }
  }
}
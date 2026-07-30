import 'package:flutter/material.dart';

/// Context extension to easily query responsive state anywhere in the widget tree.
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Android phone or smaller screen (typically < 480px width)
  bool get isPhone => screenWidth < 480;

  /// Foldables or large Android phones (480px <= width < 768px)
  bool get isLargePhone => screenWidth >= 480 && screenWidth < 768;

  /// Tablets or desktop size screens (width >= 768px)
  bool get isTablet => screenWidth >= 768;

  /// Utility to return responsive value based on current device screen size.
  T responsiveValue<T>({required T phone, T? largePhone, T? tablet}) {
    if (isTablet && tablet != null) return tablet;
    if (isLargePhone && largePhone != null) return largePhone;
    return phone;
  }
}

/// A widget that builder layout adaptively based on the device width.
class ResponsiveLayout extends StatelessWidget {
  final Widget phone;
  final Widget? largePhone;
  final Widget? tablet;

  const ResponsiveLayout({
    super.key,
    required this.phone,
    this.largePhone,
    this.tablet,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isTablet && tablet != null) {
      return tablet!;
    }
    if (context.isLargePhone && largePhone != null) {
      return largePhone!;
    }
    return phone;
  }
}

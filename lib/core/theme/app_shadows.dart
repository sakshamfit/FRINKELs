import 'package:flutter/material.dart';

/// AppShadows implements layered shadows for a premium "Apple/Linear" depth.
abstract class AppShadows {
  static List<BoxShadow> get premium => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.03), // rgba(0,0,0,.03)
      offset: const Offset(0, 1),
      blurRadius: 1,
    ),
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.08), // rgba(0,0,0,.08)
      offset: const Offset(0, 12),
      blurRadius: 30,
    ),
  ];

  static List<BoxShadow> get premiumDark => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.2),
      offset: const Offset(0, 12),
      blurRadius: 30,
    ),
  ];

  // For the glass "inset" look (0 0 0 1 rgba(255,255,255,.6) inset)
  // We apply this as a 1px border with the specific color.
  static Border get glassInsetBorder => Border.all(
    color: const Color(0x99FFFFFF), // rgba(255,255,255,.6)
    width: 1,
  );

  static Border get glassInsetBorderDark => Border.all(
    color: const Color(0x1FFFFFFF), // rgba(255,255,255,.12)
    width: 1,
  );
}

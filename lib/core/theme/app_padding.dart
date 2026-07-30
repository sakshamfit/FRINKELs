import 'package:flutter/material.dart';

/// AppPadding defines the 8pt spacing system for a consistent grid.
abstract class AppPadding {
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
  static const double p40 = 40.0;
  static const double p48 = 48.0;

  static const EdgeInsets all8 = EdgeInsets.all(p8);
  static const EdgeInsets all16 = EdgeInsets.all(p16);
  static const EdgeInsets all24 = EdgeInsets.all(p24);

  static const EdgeInsets h16 = EdgeInsets.symmetric(horizontal: p16);
  static const EdgeInsets h24 = EdgeInsets.symmetric(horizontal: p24);
  
  static const EdgeInsets v16 = EdgeInsets.symmetric(vertical: p16);
  static const EdgeInsets v24 = EdgeInsets.symmetric(vertical: p24);
}

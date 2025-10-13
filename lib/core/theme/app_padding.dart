import 'package:flutter/material.dart';

class AppPadding {
  // General page padding
  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);

  // Padding for small elements or containers
  static const EdgeInsets small = EdgeInsets.all(8.0);

  // Padding for medium elements or containers
  static const EdgeInsets medium =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

  // Padding for large elements or containers
  static const EdgeInsets large = EdgeInsets.all(24.0);

  // Custom padding for specific use cases
  static const EdgeInsets customPadding1 =
      EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 25.0);

  // Vertical padding
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: 12.0);

  // Horizontal padding
  static const EdgeInsets horizontalMedium =
      EdgeInsets.symmetric(horizontal: 16.0);
}

import 'package:flutter/material.dart';

class AppColors {
  // -------------------- Core Colors -------------------- //
  static const Color primary = Color(0xFFFF914D);
  static const Color secondary = Color(0xff6f5b40);
  static const Color purple = Color(0xffabace4);
  static const Color darkPurple = Color(0xff5954A3);
  static const Color purpleLight = Color(0xffE3E3F6);
  static const Color bgColor = Color.fromARGB(255, 255, 255, 255);
  static const Color errorColor = Color(0xffb00020);
  static const Color grey = Color(0xff8b8a8a);
  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffffffff);
  static const Color red = Color(0xffEE1919);
  static const Color outline = Color(0xff817567);

  // -------------------- Text Colors -------------------- //
  static const Color textColor = Color(0xff4B4B4B);
  static const Color textLight = Color(0xff7D7D7D);
  static const Color darkText = Color(0xFF333333);
  static const Color hintText = Color(0xFF9E9E9E);

  // -------------------- Accent & Utility -------------------- //
  static const Color accent = Color(0xFFB22222);
  static const Color lightGrey = Color(0xFFF7F7F7);

  // -------------------- Themed Accent Variants -------------------- //
  static const Color pinkLight = Color(0xFFFFC1CC);
  static const Color pinkDark = Color(0xFFE91E63);
  static const Color yellowLight = Color(0xFFFFF6C5);
  static const Color redLight = Color(0xFFFFD5D5);
  static const Color greenLight = Color(0xFFD3F9D8);
  static const Color orangeLight = Color(0xFFFFE5B4);
  static const Color success = Color(0xFF4CAF50); // Green success color

  // -------------------- Shadows -------------------- //
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  // Heading TextStyle
  static final heading1 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static final heading2 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  // Subheading TextStyle
  static final subHeading = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  // Body TextStyle
  static final bodyText1 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static final bodyText2 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  // Caption TextStyle
  static final caption = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  // Button TextStyle
  static final button = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Error TextStyle
  static final error = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.red,
  );

  // Custom TextStyle for specific use cases
  static final customStyle1 = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w400,
    color: Colors.blue,
    letterSpacing: 1.2,
  );
}

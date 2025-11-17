import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nashik/core/theme/colors.dart';

class AppTheme {
  static _border({Color color = AppColors.primary, double width = 1}) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: width),
        borderRadius: BorderRadius.circular(10),
      );

  static final lightTheme = ThemeData().copyWith(
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xfffff8f4)),
    colorScheme: const ColorScheme.light(
      surface: Color(0xfffff8f4),
      error: Color(0xffba1a1a),
      errorContainer: Color(0xffffdad6),
      inversePrimary: Color(0xfff4bd6e),
      inverseSurface: Color(0xff362f27),
      onSurface: Color(0xff201b13),
      onPrimary: Colors.white,
      onError: Color(0xffffffff),
      onErrorContainer: Color(0xff410002),
      onInverseSurface: Color(0xfffbefe2),
      onPrimaryContainer: Color(0xff291800),
      onSecondary: Color(0xffffffff),
      onSecondaryContainer: Color(0xff271904),
      onSurfaceVariant: Color(0xff4f4539),
      onTertiary: Color(0xffffffff),
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      primaryContainer: Color(0xffffddb2),
      scrim: Color(0xff000000),
      shadow: Color(0xff000000),
      surfaceTint: Color(0xff7f5610),
      tertiary: Color(0xff516440),
      surfaceContainerHighest: Color(0xffede0d4),
      tertiaryContainer: Color(0xffd3eabc),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        minimumSize: const Size.fromHeight(50),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      border: _border(),
      enabledBorder: _border(),
      errorBorder: _border(color: AppColors.errorColor),
      contentPadding: EdgeInsets.all(20.r),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

      // dayColor: AppColors.purple,
      // selectedDayColor: AppColors.darkPurple,
      // todayColor: AppColors.lightPurple,
    ),
  );
}

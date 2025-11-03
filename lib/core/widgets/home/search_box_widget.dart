import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Search Box Widget
/// Displays a search input with gradient border
class SearchBoxWidget extends StatelessWidget {
  const SearchBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320.w,
        height: 60.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFA201),
              Color(0xFFEF4444),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.all(2.w), // Border width for gradient effect
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              SizedBox(width: 16.w),
              Icon(
                Icons.search,
                color: const Color(0xFF9CA3AF),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search temples, hotels, vineyards...',
                    hintStyle: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF9CA3AF),
                      height: 20 / 13, // line height / font size
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: GoogleFonts.montserrat(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    height: 20 / 13,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
            ],
          ),
        ),
      ),
    );
  }
}


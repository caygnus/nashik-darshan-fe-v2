import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Hero Image Header Widget
/// Displays the main hero image with gradient overlay and welcome text
class HeroImageHeader extends StatelessWidget {
  const HeroImageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 392.w,
      height: 300.h,
      child: Stack(
        children: [
          // Hero Image
          Image.asset(
            'assets/images/home-hero.png',
            width: 392.w,
            height: 300.h,
            fit: BoxFit.cover,
          ),
          // Shadow gradient overlay from top to bottom
          Container(
            width: 392.w,
            height: 300.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF000000).withOpacity(0.0),
                  const Color(0xFF000000).withOpacity(0.3),
                  const Color(0xFF000000).withOpacity(0.7),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Text content at bottom - centered
          Positioned(
            bottom: 70.h,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Nashik',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'City of Temples, Sacred Rivers & Vineyards',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


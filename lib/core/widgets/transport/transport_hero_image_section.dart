import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Transport Hero Image Section Widget
/// Displays hero image with dark overlay and descriptive text
class TransportHeroImageSection extends StatelessWidget {
  const TransportHeroImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250.h,
      child: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/home-hero.png',
            width: double.infinity,
            height: 250.h,
            fit: BoxFit.cover,
          ),
          // Dark Overlay
          Container(
            width: double.infinity,
            height: 250.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF000000).withOpacity(0.4),
                  const Color(0xFF000000).withOpacity(0.7),
                ],
              ),
            ),
          ),
          // Text Content at Bottom Left
          Positioned(
            bottom: 20.h,
            left: 20.w,
            right: 20.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore Nashik',
                  style: GoogleFonts.montserrat(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 28 / 18,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Your complete guide to exploring Nashik\'s spiritual and cultural beauty.',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    height: 23 / 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

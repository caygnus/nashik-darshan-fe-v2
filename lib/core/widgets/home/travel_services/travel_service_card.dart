import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Travel Service Card Widget
/// Individual card displaying a travel service offering
class TravelServiceCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final Color badgeBgColor;
  final String price;

  const TravelServiceCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.badgeBgColor,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 352.w,
      height: 116.h,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF000000),
                    height: 24 / 16,
                  ),
                ),
                // Subtitle
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF6B7280),
                    height: 1.2,
                  ),
                ),
                // Badge and Price Row
                Row(
                  children: [
                    // Badge
                    Container(
                      height: 24.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(9999.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        badge,
                        style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: badgeColor,
                          height: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Price
                    Text(
                      price,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF000000),
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Right side icon
          SvgPicture.asset(
            iconPath,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              Color(0xFFFFA201),
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}


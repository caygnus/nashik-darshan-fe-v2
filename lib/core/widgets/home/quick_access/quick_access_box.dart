import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Quick Access Box Widget
/// Individual button for quick access to services
class QuickAccessBox extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback? onTap;

  const QuickAccessBox({
    super.key,
    required this.iconPath,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 74.w,
        height: 68.h,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          // SVG Icon
          SvgPicture.asset(
            iconPath,
            width: 28.w,
            height: 28.h,
            colorFilter: const ColorFilter.mode(
              Color(0xFFFFA201),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 6.h),
          // Label
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF000000),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Spiritual Story of the Day Card Widget
/// Displays the featured spiritual story with actions
class SpiritualStoryCard extends StatelessWidget {
  const SpiritualStoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: 320.w,
        height: 215.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFBA8E), Color(0xFFFEFCE8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFFF6B35), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with icon, title, and action buttons
            Row(
              children: [
                // Book/Story Icon
                SvgPicture.asset(
                  'assets/svg/open-book.svg',
                  width: 18.w,
                  height: 18.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFFFA201),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                // Title
                Expanded(
                  child: Text(
                    'Spiritual Story of the Day',
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                      height: 24 / 16,
                    ),
                  ),
                ),
                // Action icons - aligned to right with reduced spacing
                Icon(
                  Icons.volume_up_outlined,
                  size: 20.sp,
                  color: const Color(0xFF2563EB),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.share_outlined,
                  size: 20.sp,
                  color: const Color(0xFF6B7280),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.bookmark_border,
                  size: 20.sp,
                  color: const Color(0xFF6B7280),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // Inner content card with increased height
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Story Title
                    Text(
                      'The Sacred Godavari',
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1F2937),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Story Description
                    Expanded(
                      child: Text(
                        'The holy Godavari river flows through Nashik, making it one of the four sacred Kumbh Mela sites. Legend says Lord Rama spent time here during his exile...',
                        style: GoogleFonts.montserrat(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF4B5563),
                          height: 1.4,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Read More link
                    Text(
                      'Read More →',
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFFF9933),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

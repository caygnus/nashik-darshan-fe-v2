import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'travel_tip_item.dart';

/// Quick Travel Tips Section Widget
/// Displays helpful travel tips in a bordered container
class QuickTravelTipsSection extends StatelessWidget {
  const QuickTravelTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Quick Travel Tips',
            style: GoogleFonts.montserrat(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
              height: 28 / 18,
            ),
          ),
          SizedBox(height: 16.h),
          // Tips Box
          Container(
            width: 358.w,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TravelTipItem(
                  icon: Icons.schedule_outlined,
                  title: 'Peak Hours',
                  subtitle: 'Check crowded timings before travel',
                ),
                SizedBox(height: 16.h),
                const TravelTipItem(
                  icon: Icons.smartphone_outlined,
                  title: 'Mobile Apps',
                  subtitle: 'Download real-time transport apps',
                ),
                SizedBox(height: 16.h),
                const TravelTipItem(
                  icon: Icons.payments_outlined,
                  title: 'Payment',
                  subtitle: 'Keep UPI & cash handy',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


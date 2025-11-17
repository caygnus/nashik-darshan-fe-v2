import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'travel_option_box.dart';

/// City-to-City Travel Section Widget
/// Displays inter-city transportation options
class CityToCityTravelSection extends StatelessWidget {
  const CityToCityTravelSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'City-to-City Travel',
            style: GoogleFonts.montserrat(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
              height: 28 / 18,
            ),
          ),
          SizedBox(height: 16.h),
          // Travel Option Boxes
          const TravelOptionBox(
            icon: Icons.train_outlined,
            title: 'Railway',
            subtitle: 'Schedules & booking',
          ),
          SizedBox(height: 12.h),
          const TravelOptionBox(
            icon: Icons.flight_outlined,
            title: 'Airport',
            subtitle: 'Flight info & transfers',
          ),
          SizedBox(height: 12.h),
          const TravelOptionBox(
            icon: Icons.departure_board_outlined,
            title: 'Bus Stand',
            subtitle: 'Inter-city buses',
          ),
        ],
      ),
    );
  }
}


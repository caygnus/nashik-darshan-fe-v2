import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'travel_option_box.dart';

/// Local Travel Section Widget
/// Displays local transportation options
class LocalTravelSection extends StatelessWidget {
  const LocalTravelSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Local Travel',
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
            icon: Icons.calculate_outlined,
            title: 'Fare Estimator',
            subtitle: 'Calculate travel costs',
          ),
          SizedBox(height: 12.h),
          const TravelOptionBox(
            icon: Icons.local_taxi_outlined,
            title: 'Cab & Auto',
            subtitle: 'Book instantly',
          ),
          SizedBox(height: 12.h),
          const TravelOptionBox(
            icon: Icons.directions_bus_outlined,
            title: 'Bus Info',
            subtitle: 'Routes & timings',
          ),
        ],
      ),
    );
  }
}

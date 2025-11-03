import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'travel_service_card.dart';

/// Travel Services Section Widget
/// Displays available travel service options
class TravelServicesSection extends StatelessWidget {
  const TravelServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Travel Services',
            style: GoogleFonts.montserrat(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
              height: 1.2,
            ),
          ),
          SizedBox(height: 16.h),
          // Service Cards
          const TravelServiceCard(
            iconPath: 'assets/svg/bad.svg',
            title: 'Stay & Travel',
            subtitle: 'Hotels, Flights & More',
            badge: 'Verified Partner',
            badgeColor: Color(0xFF15803D),
            badgeBgColor: Color(0xFFDCFCE7),
            price: 'From ₹999',
          ),
          SizedBox(height: 12.h),
          const TravelServiceCard(
            iconPath: 'assets/svg/map.svg',
            title: 'Tourist Packages',
            subtitle: 'Complete Nashik Experience',
            badge: 'Best Price',
            badgeColor: Color(0xFF1D4ED8),
            badgeBgColor: Color(0xFFDBEAFE),
            price: 'From ₹2,999',
          ),
        ],
      ),
    );
  }
}


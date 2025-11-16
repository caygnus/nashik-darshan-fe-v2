import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'quick_access_box.dart';

/// Quick Access Section Widget
/// Displays a grid of quick access buttons for various services
class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({
    super.key,
    this.onSpiritualTap,
    this.onDiscoverTap,
    this.onTransportTap,
    this.onRailwaysTap,
    this.onHotelsTap,
    this.onEateryTap,
    this.onFlightsTap,
    this.onVineyardsTap,
  });
  final VoidCallback? onSpiritualTap;
  final VoidCallback? onDiscoverTap;
  final VoidCallback? onTransportTap;
  final VoidCallback? onRailwaysTap;
  final VoidCallback? onHotelsTap;
  final VoidCallback? onEateryTap;
  final VoidCallback? onFlightsTap;
  final VoidCallback? onVineyardsTap;

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Quick Access',
            style: GoogleFonts.montserrat(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
              height: 28 / 18,
            ),
          ),
          SizedBox(height: 16.h),
          // First Row - 4 boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuickAccessBox(
                iconPath: 'assets/svg/om.svg',
                label: 'Spiritual',
                onTap: onSpiritualTap,
              ),
              QuickAccessBox(
                iconPath: 'assets/svg/i.svg',
                label: 'Discover ',
                onTap: onDiscoverTap,
              ),
              QuickAccessBox(
                iconPath: 'assets/svg/car.svg',
                label: 'Transport',
                onTap: onTransportTap,
              ),
              QuickAccessBox(
                iconPath: 'assets/svg/train.svg',
                label: 'Railways',
                onTap: onRailwaysTap,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Second Row - 4 boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuickAccessBox(
                iconPath: 'assets/svg/bad.svg',
                label: 'Hotels',
                onTap: onHotelsTap,
              ),
              QuickAccessBox(
                iconPath: 'assets/svg/spoun.svg',
                label: 'Eatery',
                onTap: onEateryTap,
              ),
              QuickAccessBox(
                iconPath: 'assets/svg/flite.svg',
                label: 'Flights',
                onTap: onFlightsTap,
              ),
              QuickAccessBox(
                iconPath: 'assets/svg/wine.svg',
                label: 'Vineyards',
                onTap: onVineyardsTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

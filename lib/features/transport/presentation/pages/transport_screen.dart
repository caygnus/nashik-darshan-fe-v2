import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/features/transport/presentation/widgets/city_to_city_travel_section.dart';
import 'package:nashik/features/transport/presentation/widgets/local_travel_section.dart';
import 'package:nashik/features/transport/presentation/widgets/quick_travel_tips_section.dart';
// Transport Screen Widgets
import 'package:nashik/features/transport/presentation/widgets/transport_hero_image_section.dart';

/// Transport Screen
/// Displays transport options and services in Nashik
class TransportScreen extends StatelessWidget {
  static const routeName = 'TransportScreen';
  static const routePath = '/TransportScreen';

  const TransportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Transport',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Image with Dark Effect and Text
            const TransportHeroImageSection(),
            SizedBox(height: 20.h),
            // Local Travel Section
            const LocalTravelSection(),
            SizedBox(height: 20.h),
            // City-to-City Travel Section
            const CityToCityTravelSection(),
            SizedBox(height: 20.h),
            // Quick Travel Tips Section
            const QuickTravelTipsSection(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

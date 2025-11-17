import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Home Screen Widgets
import 'package:nashik/core/widgets/home/hero_image_header.dart';
import 'package:nashik/core/widgets/home/plan_journey/plan_my_journey_section.dart';
import 'package:nashik/core/widgets/home/popular_places/popular_in_nashik_section.dart';
import 'package:nashik/core/widgets/home/quick_access/quick_access_section.dart';
import 'package:nashik/core/widgets/home/search_box_widget.dart';
import 'package:nashik/core/widgets/home/spiritual_experiences/spiritual_experiences_section.dart';
import 'package:nashik/core/widgets/home/spiritual_story/spiritual_story_card.dart';
import 'package:nashik/core/widgets/home/transparent_app_bar.dart';
import 'package:nashik/core/widgets/home/travel_services/travel_services_section.dart';
import 'package:nashik/screens/eatery_screen.dart';
import 'package:nashik/screens/hotels_screen.dart';
import 'package:nashik/screens/street_food_screen.dart';
import 'package:nashik/screens/transport_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content with hero image at top
          SingleChildScrollView(
            child: Column(
              children: [
                const HeroImageHeader(),
                // Search box overlaps the hero image
                Transform.translate(
                  offset: Offset(0, -29.h), // Half of search box height (58/2)
                  child: const SearchBoxWidget(),
                ),
                // Spiritual Experiences Section
                Transform.translate(
                  offset: Offset(0, -20.h), // Move section closer to search box
                  child: const SpiritualExperiencesSection(),
                ),
                // Spiritual Story of the Day Section
                Transform.translate(
                  offset: Offset(0, -10.h),
                  child: const SpiritualStoryCard(),
                ),
                // Quick Access Section
                QuickAccessSection(
                  onDiscoverTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StreetFoodScreen(),
                      ),
                    );
                  },
                  onTransportTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TransportScreen(),
                      ),
                    );
                  },
                  onHotelsTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HotelsScreen(),
                      ),
                    );
                  },
                  onEateryTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EateryScreen(),
                      ),
                    );
                  },
                ),
                // Plan My Journey Section
                const PlanMyJourneySection(),
                SizedBox(height: 20.h),
                // Popular in Nashik Section
                const PopularInNashikSection(),
                SizedBox(height: 20.h),
                // Travel Services Section
                const TravelServicesSection(),
                SizedBox(height: 10.h),
                // Add more content below here
              ],
            ),
          ),
          // Transparent AppBar overlay
          const TransparentAppBarWidget(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nashik/features/eatery/presentation/pages/eatery_screen.dart';
// Home Screen Widgets
import 'package:nashik/features/home/presentation/widgets/hero_image_header.dart';
import 'package:nashik/features/home/presentation/widgets/plan_journey/plan_my_journey_section.dart';
import 'package:nashik/features/home/presentation/widgets/popular_places/popular_in_nashik_section.dart';
import 'package:nashik/features/home/presentation/widgets/quick_access/quick_access_section.dart';
import 'package:nashik/features/home/presentation/widgets/search_box_widget.dart';
import 'package:nashik/features/home/presentation/widgets/spiritual_experiences/spiritual_experiences_section.dart';
import 'package:nashik/features/home/presentation/widgets/spiritual_story/spiritual_story_card.dart';
import 'package:nashik/features/home/presentation/widgets/transparent_app_bar.dart';
import 'package:nashik/features/home/presentation/widgets/travel_services/travel_services_section.dart';
import 'package:nashik/features/hotels/presentation/pages/hotels_screen.dart';
import 'package:nashik/features/street_food/presentation/pages/street_food_screen.dart';
import 'package:nashik/features/transport/presentation/pages/transport_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'HomeScreen';
  static const routePath = '/HomeScreen';

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
                  offset: Offset(0, -29.h),
                  child: const SearchBoxWidget(),
                ),
                // Spiritual Experiences Section
                Transform.translate(
                  offset: Offset(0, -20.h),
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

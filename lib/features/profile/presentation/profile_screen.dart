import 'package:flutter/material.dart';

import '../../../../core/theme/app_textstyle.dart';
import '../../../../core/theme/colors.dart';
import '../../../widgets/profile_screen/achievement_card.dart';
import '../../../widgets/profile_screen/journey_progress_tile.dart';
import '../../../widgets/profile_screen/recent_trip_tile.dart';
import '../../../widgets/profile_screen/saved_wishlist_card.dart';
import '../../../widgets/profile_screen/settings_tile.dart';
import '../../../widgets/profile_screen/travel_stat_card.dart';
import '../../../widgets/profile_screen/trip_streak_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const double horizontalPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
                splashRadius: 22,
              ),

              // Title
              Text('Profile', style: AppTextStyle.headlineMedium),

              // Heart Icon
              IconButton(
                icon: const Icon(Icons.favorite_border_rounded),
                onPressed: () {},
                splashRadius: 22,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),

            _buildSectionContainer(const TravelStatsSection()),
            const SizedBox(height: 24),

            _buildSectionContainer(const RecentTripsSection()),

            const SizedBox(height: 24),

            _buildSectionContainer(const SavedWishlistSection()),
            const SizedBox(height: 24),

            _buildSectionContainer(const NashikJourneySection()),
            const SizedBox(height: 24),

            _buildSectionContainer(const AchievementsSection()),
            const SizedBox(height: 24),

            _buildSectionContainer(const SettingsSection()),
            const SizedBox(height: 24),

            const TripStreakCard(streakDays: 7, progress: 0.75),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: AppColors.black, // 🖤 Solid black background
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ), // spacing from sides
      child: Row(
        children: [
          const CircleAvatar(radius: 36, backgroundColor: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shailesh Birajdar',
                  style: AppTextStyle.titleLarge.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
                Text(
                  'Spiritual Explorer',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.flag_rounded,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Marathi',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColors.hintText,
                      ),
                    ),
                  ],
                ),
                Text(
                  '+91 98765 43210',
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColors.hintText,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {},
            splashRadius: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

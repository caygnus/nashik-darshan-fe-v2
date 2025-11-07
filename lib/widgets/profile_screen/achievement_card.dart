import 'package:flutter/material.dart';
import '../../../../../core/theme/app_textstyle.dart';
import '../../../../../core/theme/colors.dart';
import 'section_header.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Achievements'),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AchievementCard(
                title: 'Temple Explorer',
                icon: Icons.temple_hindu_rounded,
                color: AppColors.yellowLight,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: AchievementCard(
                title: 'Foodie',
                icon: Icons.restaurant_rounded,
                color: AppColors.orangeLight,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: AchievementCard(
                title: 'Eco Traveler',
                icon: Icons.eco_rounded,
                color: AppColors.greenLight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AchievementCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const AchievementCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyle.bodySmall),
        ],
      ),
    );
  }
}

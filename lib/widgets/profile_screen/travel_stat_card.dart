import 'package:flutter/material.dart';
import '../../../../../core/theme/app_textstyle.dart';
import '../../../../../core/theme/colors.dart';
import 'section_header.dart';

class TravelStatsSection extends StatelessWidget {
  const TravelStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Travel Stats', showViewAll: true),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TravelStatCard(
              icon: Icons.temple_hindu,
              count: 12,
              label: 'Temples\nVisited',
            ),
            TravelStatCard(
              icon: Icons.landscape_rounded,
              count: 8,
              label: 'Spots\nExplored',
            ),
            TravelStatCard(
              icon: Icons.card_travel_rounded,
              count: 5,
              label: 'Trips\nCompleted',
            ),
          ],
        ),
      ],
    );
  }
}

class TravelStatCard extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;

  const TravelStatCard({
    super.key,
    required this.icon,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: AppColors.primary),
        const SizedBox(height: 6),
        Text('$count', style: AppTextStyle.titleLarge),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyle.bodySmall.copyWith(color: AppColors.textColor),
        ),
      ],
    );
  }
}

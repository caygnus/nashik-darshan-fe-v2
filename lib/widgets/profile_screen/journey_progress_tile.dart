import 'package:flutter/material.dart';
import '../../../../../core/theme/app_textstyle.dart';
import '../../../../../core/theme/colors.dart';
import 'section_header.dart';

class NashikJourneySection extends StatelessWidget {
  const NashikJourneySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Nashik Journey'),
        SizedBox(height: 12),
        JourneyProgressTile(
          title: 'Pilgrimage Tracker',
          subtitle: '3 of 12 Jyotirlingas visited',
          progress: 0.25,
          color: AppColors.white,
        ),
        JourneyProgressTile(
          title: 'Festival Badges',
          subtitle: '2 badges earned',
          progress: 0.6,
          color: AppColors.yellowLight,
        ),
        JourneyProgressTile(
          title: 'Food Journey',
          subtitle: '7 local dishes tried',
          progress: 0.7,
          color: AppColors.redLight,
        ),
        JourneyProgressTile(
          title: 'Green Points',
          subtitle: 'Eco-friendly travel score',
          progress: 0.85,
          color: AppColors.greenLight,
        ),
      ],
    );
  }
}

class JourneyProgressTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final Color color;

  const JourneyProgressTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyle.bodyMedium),
          Text(
            subtitle,
            style: AppTextStyle.bodySmall.copyWith(color: AppColors.textColor),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              color: AppColors.primary,
              backgroundColor: Colors.white24,
            ),
          ),
        ],
      ),
    );
  }
}

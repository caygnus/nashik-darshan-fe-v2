import 'package:flutter/material.dart';
import '../../../../../core/theme/app_textstyle.dart';
import '../../../../../core/theme/colors.dart';

class TripStreakCard extends StatelessWidget {
  final int streakDays;
  final double progress;

  const TripStreakCard({
    super.key,
    required this.streakDays,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Streak',
                  style: AppTextStyle.titleMedium.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep exploring Nashik!',
                  style: AppTextStyle.bodySmall.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$streakDays\nDays',
            textAlign: TextAlign.center,
            style: AppTextStyle.titleLarge.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

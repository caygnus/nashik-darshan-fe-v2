import 'package:flutter/material.dart';
import '../../../../../core/theme/app_textstyle.dart';
import '../../../../../core/theme/colors.dart';
import 'section_header.dart';

class RecentTripsSection extends StatelessWidget {
  const RecentTripsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Recent Trips', showViewAll: true),
        SizedBox(height: 12),
        RecentTripTile(title: 'Trimbakeshwar Temple', date: 'Aug 15, 2024'),
        RecentTripTile(title: 'Sula Vineyards', date: 'Jul 28, 2024'),
        RecentTripTile(title: 'Pandav Leni Caves', date: 'Jul 10, 2024'),
      ],
    );
  }
}

class RecentTripTile extends StatelessWidget {
  final String title;
  final String date;

  const RecentTripTile({super.key, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        radius: 24,
        // backgroundImage: AssetImage('assets/images/trip_placeholder.png'),
        backgroundColor: AppColors.white,
        child: Icon(Icons.landscape_rounded, color: AppColors.primary),
      ),
      title: Text(title, style: AppTextStyle.bodyMedium),
      subtitle: Text(
        date,
        style: AppTextStyle.bodySmall.copyWith(color: AppColors.textColor),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textColor,
      ),
      onTap: () {
        // TODO: Add navigation or trip details page
      },
    );
  }
}

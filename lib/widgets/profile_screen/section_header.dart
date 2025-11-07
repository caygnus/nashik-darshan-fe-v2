import 'package:flutter/material.dart';
import '../../../../../core/theme/app_textstyle.dart';
import '../../../../../core/theme/colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.showViewAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyle.titleMedium),
        if (showViewAll)
          Text(
            'View All',
            style: AppTextStyle.bodySmall.copyWith(color: AppColors.primary),
          ),
      ],
    );
  }
}

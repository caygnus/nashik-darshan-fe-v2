import 'package:flutter/material.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/app_textstyle.dart';

class SavedWishlistSection extends StatelessWidget {
  const SavedWishlistSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved & Wishlist',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SavedWishlistCard(
                icon: Icons.bookmark_rounded,
                iconColor: AppColors.darkPurple,
                count: 5,
                label: 'Saved Itineraries',
                color: AppColors.purpleLight,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SavedWishlistCard(
                icon: Icons.favorite_rounded,
                iconColor: AppColors.pinkDark,
                count: 10,
                label: 'Wishlist Places',
                color: AppColors.pinkLight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SavedWishlistCard extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final IconData icon;
  final Color iconColor;

  const SavedWishlistCard({
    super.key,
    required this.count,
    required this.label,
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: iconColor),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: AppTextStyle.titleLarge.copyWith(color: AppColors.black),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.bodySmall.copyWith(color: AppColors.hintText),
          ),
        ],
      ),
    );
  }
}

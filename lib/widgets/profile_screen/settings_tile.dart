import 'package:flutter/material.dart';
import '../../../../../core/theme/app_textstyle.dart';
import '../../../../../core/theme/colors.dart';
import 'section_header.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Settings'),
          SizedBox(height: 12),
          SettingsTile(icon: Icons.lock_rounded, title: 'Privacy Settings'),
          SettingsTile(
            icon: Icons.language_rounded,
            title: 'Language',
            trailingText: 'English',
          ),
          SettingsTile(
            icon: Icons.accessibility_new_rounded,
            title: 'Accessibility',
          ),
          SettingsTile(icon: Icons.download_rounded, title: 'Export Data'),
          SettingsTile(
            icon: Icons.delete_rounded,
            title: 'Delete Account',
            isDestructive: true,
          ),
        ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final bool isDestructive;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.errorColor : AppColors.darkText,
      ),
      title: Text(
        title,
        style: AppTextStyle.bodyMedium.copyWith(
          color: isDestructive ? AppColors.errorColor : AppColors.darkText,
        ),
      ),
      trailing: trailingText != null
          ? Text(
              trailingText!,
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColors.textColor,
              ),
            )
          : const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textColor,
            ),
      onTap: () {},
    );
  }
}

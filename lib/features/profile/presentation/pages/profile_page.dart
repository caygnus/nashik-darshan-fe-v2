import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/theme/colors.dart';
import 'package:nashik/core/utils/loading_overlay.dart';
import 'package:nashik/core/utils/snackbar.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_state.dart';
import 'package:nashik/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static const routeName = 'ProfilePage';
  static const routePath = '/ProfilePage';

  void _handleLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontSize: 14.sp, color: AppColors.darkText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthCubit>().signOut();
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          authenticated: (_) {},
          unauthenticated: () {
            context.goNamed(LoginPage.routeName);
          },
          error: (String message) {
            Snackbar.showError(message);
          },
        );
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );
          return LoadingOverlay(
            isLoading: isLoading,
            message: isLoading ? 'Logging out...' : null,
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.darkText,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    color: AppColors.darkText,
                    onPressed: () {},
                  ),
                ],
              ),
              body: SafeArea(
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      authenticated: (user) =>
                          _buildProfileContent(context, user),
                      orElse: () => const Center(
                        child: Text('Please log in to view your profile'),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    // Mock data
    const templesVisited = 12;
    const spotsExplored = 8;
    const tripsCompleted = 5;
    const savedItineraries = 5;
    const wishlistPlaces = 10;
    const jyotirlingasVisited = 3;
    const totalJyotirlingas = 12;
    const badgesEarned = 2;
    const dishesTried = 7;
    const totalDishes = 10;
    const greenPoints = 850;
    const tripStreak = 7;
    const streakProgress = 0.75;

    final recentTrips = [
      {
        'name': 'Trimbakeshwar Temple',
        'date': 'Aug 15, 2024',
        'image': Icons.temple_buddhist,
      },
      {
        'name': 'Sula Vineyards',
        'date': 'Jul 28, 2024',
        'image': Icons.wine_bar,
      },
      {
        'name': 'Pandav Leni Caves',
        'date': 'Jul 10, 2024',
        'image': Icons.landscape,
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                // Profile Avatar
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.1),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 40.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Spiritual Explorer',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flag,
                                  size: 14.sp,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Marathi',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            user.phone ?? '+91 98765 43210',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.grey,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.edit,
                            size: 16.sp,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Travel Stats Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travel Stats',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.temple_buddhist,
                      count: templesVisited,
                      label: 'Temples Visited',
                      color: AppColors.primary,
                    ),
                    _buildStatItem(
                      icon: Icons.landscape,
                      count: spotsExplored,
                      label: 'Spots Explored',
                      color: Colors.green,
                    ),
                    _buildStatItem(
                      icon: Icons.luggage,
                      count: tripsCompleted,
                      label: 'Trips Completed',
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Recent Trips Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Trips',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                ...recentTrips.map(
                  (trip) => _buildTripItem(
                    name: trip['name'] as String,
                    date: trip['date'] as String,
                    icon: trip['image'] as IconData,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Saved & Wishlist Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.bookmark, color: Colors.white),
                    label: Text(
                      '$savedItineraries Saved Itineraries',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.favorite, color: Colors.white),
                    label: Text(
                      '$wishlistPlaces Wishlist Places',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Nashik Journey Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nashik Journey',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildJourneyItem(
                  icon: Icons.temple_buddhist,
                  label: 'Pilgrimage Tracker',
                  subtitle:
                      '$jyotirlingasVisited of $totalJyotirlingas Jyotirlingas visited',
                  progress: jyotirlingasVisited / totalJyotirlingas,
                  progressText:
                      '${((jyotirlingasVisited / totalJyotirlingas) * 100).toInt()}%',
                  iconColor: AppColors.primary,
                ),
                SizedBox(height: 16.h),
                _buildJourneyItem(
                  icon: Icons.emoji_events,
                  label: 'Festival Badges',
                  subtitle: '$badgesEarned badges earned',
                  badges: List.generate(badgesEarned, (index) => Colors.amber),
                  iconColor: Colors.amber,
                ),
                SizedBox(height: 16.h),
                _buildJourneyItem(
                  icon: Icons.restaurant,
                  label: 'Food Journey',
                  subtitle: '$dishesTried local dishes tried',
                  progress: dishesTried / totalDishes,
                  progressText:
                      '${((dishesTried / totalDishes) * 100).toInt()}%',
                  iconColor: Colors.red,
                ),
                SizedBox(height: 16.h),
                _buildJourneyItem(
                  icon: Icons.eco,
                  label: 'Green Points',
                  subtitle: 'Eco-friendly travel score',
                  points: greenPoints,
                  iconColor: Colors.green,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Achievements Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAchievementBadge(
                      icon: Icons.workspace_premium,
                      label: 'Temple Explorer',
                      color: Colors.amber,
                    ),
                    _buildAchievementBadge(
                      icon: Icons.restaurant,
                      label: 'Foodie',
                      color: AppColors.primary,
                    ),
                    _buildAchievementBadge(
                      icon: Icons.eco,
                      label: 'Eco Traveler',
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Settings Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildSettingItem(Icons.privacy_tip, 'Privacy Settings'),
                _buildSettingItem(
                  Icons.language,
                  'Language',
                  subtitle: 'English',
                ),
                _buildSettingItem(Icons.accessibility, 'Accessibility'),
                _buildSettingItem(Icons.download, 'Export Data'),
                _buildSettingItem(
                  Icons.delete_outline,
                  'Delete Account',
                  textColor: AppColors.red,
                ),
                SizedBox(height: 8.h),
                _buildSettingItem(
                  Icons.logout,
                  'Logout',
                  textColor: AppColors.red,
                  onTap: () => _handleLogout(context),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Trip Streak Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trip Streak',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$tripStreak Days',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Keep exploring Nashik!',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: streakProgress,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          minHeight: 8.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      '${(streakProgress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
          ),
          child: Icon(icon, color: color, size: 30.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: AppColors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTripItem({
    required String name,
    required String date,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 30.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  date,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.grey),
        ],
      ),
    );
  }

  Widget _buildJourneyItem({
    required IconData icon,
    required String label,
    required String subtitle,
    double? progress,
    String? progressText,
    int? points,
    List<Color>? badges,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                  ),
                ],
              ),
            ),
            if (progress != null && progressText != null)
              Text(
                progressText,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              )
            else if (points != null)
              Text(
                points.toString(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              )
            else if (badges != null)
              Row(
                children: badges
                    .map(
                      (color) => Container(
                        margin: EdgeInsets.only(left: 4.w),
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
        if (progress != null) ...[
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: iconColor.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              minHeight: 6.h,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAchievementBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(icon, color: color, size: 35.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.darkText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title, {
    String? subtitle,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? AppColors.grey, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: textColor ?? AppColors.darkText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
              ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right, color: AppColors.grey, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

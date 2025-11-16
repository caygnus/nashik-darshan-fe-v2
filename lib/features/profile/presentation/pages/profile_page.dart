import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/theme/colors.dart';
import 'package:nashik/core/utils/loading_overlay.dart';
import 'package:nashik/core/utils/snackbar.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';
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
        if (state is AuthUnauthenticated) {
          // Navigate to login page after logout
          context.goNamed(LoginPage.routeName);
        } else if (state is AuthError) {
          Snackbar.showError(state.message);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return LoadingOverlay(
            isLoading: isLoading,
            message: isLoading ? 'Logging out...' : null,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      // Profile Avatar
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.1),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50.sp,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // User Email (if available)
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state is AuthAuthenticated) {
                            // You can fetch user email from Supabase if needed
                            return Text(
                              'User',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkText,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      SizedBox(height: 40.h),
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: OutlinedButton(
                          onPressed: () => _handleLogout(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.red,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: AppColors.red,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

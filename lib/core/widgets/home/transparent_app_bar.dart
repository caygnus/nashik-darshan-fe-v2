import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Transparent AppBar Widget
/// Displays a transparent app bar with notification icon overlay
class TransparentAppBarWidget extends StatelessWidget {
  const TransparentAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle bell icon press
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }
}


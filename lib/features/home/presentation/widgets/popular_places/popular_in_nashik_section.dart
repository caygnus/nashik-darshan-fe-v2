import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'popular_place_card.dart';

/// Popular in Nashik Section Widget
/// Displays horizontally scrollable popular places with dot indicators
class PopularInNashikSection extends StatefulWidget {
  const PopularInNashikSection({super.key});

  @override
  State<PopularInNashikSection> createState() => _PopularInNashikSectionState();
}

class _PopularInNashikSectionState extends State<PopularInNashikSection> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _totalCards = 4;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Calculate which card is currently most visible
    final double cardWidth = 167.w + 12.w; // card width + spacing
    final double offset = _scrollController.offset;
    final int newPage = (offset / cardWidth).round();

    if (newPage != _currentPage && newPage >= 0 && newPage < _totalCards) {
      setState(() {
        _currentPage = newPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Row with Title and View All
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular in Nashik',
                style: GoogleFonts.montserrat(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                  height: 1.2,
                ),
              ),
              Text(
                'View All',
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFEA580C),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Horizontal Scrolling Cards
        SizedBox(
          height: 190.h,
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: [
              const PopularPlaceCard(
                imagePath: 'assets/images/home-hero.png',
                title: 'Sula Vineyards',
                subtitle: 'Wine & Dine Experience',
                rating: '4.5',
              ),
              SizedBox(width: 12.w),
              const PopularPlaceCard(
                imagePath: 'assets/images/home-hero.png',
                title: 'Trimbakeshwar Temple',
                subtitle: 'Sacred Jyotirlinga',
                rating: '4.8',
              ),
              SizedBox(width: 12.w),
              const PopularPlaceCard(
                imagePath: 'assets/images/home-hero.png',
                title: 'Pandav Leni Caves',
                subtitle: 'Ancient Rock Caves',
                rating: '4.3',
              ),
              SizedBox(width: 12.w),
              const PopularPlaceCard(
                imagePath: 'assets/images/home-hero.png',
                title: 'Ramkund',
                subtitle: 'Holy Bathing Ghat',
                rating: '4.6',
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        // Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _totalCards,
            (index) => Container(
              width: 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? const Color(0xFF000000)
                    : const Color(0xFFD9D9D9),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

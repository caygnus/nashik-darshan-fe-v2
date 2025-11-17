# Widget Structure Documentation

## Overview
This document describes the reusable widget structure for the Nashik Darshan app. The widgets are organized to maximize code reusability between similar screens (Eatery, Hotels, etc.).

## Folder Structure

```
lib/
├── core/
│   └── widgets/
│       ├── shared/              # Reusable widgets across multiple screens
│       │   ├── search_bar_widget.dart
│       │   ├── category_selection_widget.dart
│       │   ├── filter_buttons_widget.dart
│       │   ├── result_count_widget.dart
│       │   ├── promotional_box_widget.dart
│       │   ├── listing_card_widget.dart
│       │   ├── user_review_card_widget.dart
│       │   ├── view_all_button_widget.dart
│       │   └── section_title_widget.dart
│       ├── home/                # Home screen specific widgets
│       │   ├── hero_image_header.dart
│       │   ├── transparent_app_bar.dart
│       │   ├── search_box_widget.dart
│       │   ├── spiritual_experiences/
│       │   ├── spiritual_story/
│       │   ├── quick_access/
│       │   ├── plan_journey/
│       │   ├── popular_places/
│       │   └── travel_services/
│       └── transport/           # Transport screen specific widgets
│           ├── transport_hero_image_section.dart
│           ├── travel_option_box.dart
│           ├── local_travel_section.dart
│           ├── city_to_city_travel_section.dart
│           ├── travel_tip_item.dart
│           └── quick_travel_tips_section.dart
└── screens/
    ├── home_screen.dart
    ├── transport_screen.dart
    ├── eatery_screen.dart
    └── hotels_screen.dart
```

## Shared Widgets

### 1. SearchBarWidget
**Purpose**: Reusable search bar with filter icon
**Used In**: Eatery Screen, Hotels Screen
**Props**:
- `hintText` (String): Placeholder text
- `onFilterTap` (VoidCallback?): Optional filter button callback

**Example**:
```dart
SearchBarWidget(
  hintText: 'Search restaurant',
  onFilterTap: () {
    // Handle filter tap
  },
)
```

---

### 2. CategorySelectionWidget
**Purpose**: Horizontal selection buttons for categories
**Used In**: Eatery Screen, Hotels Screen
**Props**:
- `categories` (List<String>): List of category names
- `selectedCategory` (String): Currently selected category
- `onCategorySelected` (Function(String)): Callback when category is selected

**Example**:
```dart
CategorySelectionWidget(
  categories: const ['Restaurants', 'Hotels', 'Street Food'],
  selectedCategory: selectedCategory,
  onCategorySelected: (category) {
    setState(() {
      selectedCategory = category;
    });
  },
)
```

---

### 3. FilterButtonsWidget
**Purpose**: Filter buttons row (All, Veg Only, Budget, etc.)
**Used In**: Eatery Screen, Hotels Screen
**Props**:
- `filters` (List<String>): List of filter options
- `selectedFilter` (String): Currently selected filter
- `onFilterSelected` (Function(String)): Callback when filter is selected

**Example**:
```dart
FilterButtonsWidget(
  filters: const ['All', 'Veg Only', 'Budget', 'Top Rated'],
  selectedFilter: selectedFilter,
  onFilterSelected: (filter) {
    setState(() {
      selectedFilter = filter;
    });
  },
)
```

---

### 4. ResultCountWidget
**Purpose**: Displays count of search results
**Used In**: Eatery Screen, Hotels Screen
**Props**:
- `count` (int): Number of results
- `itemType` (String): Type of items (e.g., "Restaurants", "Hotels")

**Example**:
```dart
ResultCountWidget(
  count: 150,
  itemType: 'Restaurants',
)
```

---

### 5. PromotionalBoxWidget
**Purpose**: Gradient promotional banner with heading and icon
**Used In**: Eatery Screen, Hotels Screen
**Props**:
- `heading` (String): Main heading text
- `subheading` (String): Subtitle text
- `iconPath` (String?): Optional SVG icon path

**Example**:
```dart
PromotionalBoxWidget(
  heading: 'Don\'t Miss Out',
  subheading: 'Traditional Misal Pav Spots',
  iconPath: 'assets/svg/spoun.svg',
)
```

---

### 6. ListingCardWidget ⭐ (Most Reusable)
**Purpose**: Generic card for restaurants, hotels, vineyards, etc.
**Used In**: Eatery Screen, Hotels Screen (can be used for any listing)
**Props**:
- `imagePath` (String): Card image path
- `category` (String): Category badge text (e.g., "Wine & Dine")
- `name` (String): Listing name
- `rating` (String): Rating value
- `ratingColor` (Color): Background color for rating badge
- `type` (String): Type/cuisine/room type
- `description` (String): Short description
- `price` (String): Price text
- `location` (String): Location text
- `feature` (String): Special feature text
- `featureIcon` (IconData): Icon for feature
- `buttonText` (String): Action button text
- `onButtonPressed` (VoidCallback?): Button tap callback
- `onFavoriteTap` (VoidCallback?): Favorite button callback
- `isFavorite` (bool): Whether item is favorited

**Example (Restaurant)**:
```dart
ListingCardWidget(
  imagePath: 'assets/images/home-hero.png',
  category: 'Wine & Dine',
  name: 'Sula Vineyard Restaurant',
  rating: '4.4',
  ratingColor: const Color(0xFF22C55E),
  type: 'Continental • Wine Tasting',
  description: 'Perfect vineyard retreat with wine tasting experience',
  price: '999',
  location: '12 km from city',
  feature: 'Wine Tours',
  featureIcon: Icons.wine_bar,
  buttonText: 'Book Tour',
  onButtonPressed: () {
    // Handle booking
  },
)
```

**Example (Hotel)**:
```dart
ListingCardWidget(
  imagePath: 'assets/images/home-hero.png',
  category: 'Luxury Stay',
  name: 'The Gateway Hotel Nashik',
  rating: '4.6',
  ratingColor: const Color(0xFF22C55E),
  type: 'Luxury • Business Hotel',
  description: 'Premium hotel with excellent amenities and vineyard views',
  price: '3,999',
  location: 'Golf Club Road',
  feature: 'Pool & Spa',
  featureIcon: Icons.pool,
  buttonText: 'Book Now',
)
```

---

### 7. UserReviewCardWidget
**Purpose**: Display user-generated travel plans and reviews
**Used In**: Eatery Screen, Hotels Screen
**Props**:
- `profileImage` (String): User profile image path
- `name` (String): User name
- `city` (String): User city
- `planTitle` (String): Travel plan title
- `planDescription` (String): Plan description
- `rating` (String): Plan rating
- `reviewCount` (String): Number of reviews
- `onUsePlanTap` (VoidCallback?): "Use Plan" button callback

**Example**:
```dart
UserReviewCardWidget(
  profileImage: 'assets/images/home-hero.png',
  name: 'Priya Sharma',
  city: 'Mumbai',
  planTitle: 'Solo Spiritual Journey',
  planDescription: 'Perfect 1-day plan for peaceful darshan and meditation',
  rating: '4.8',
  reviewCount: '124',
  onUsePlanTap: () {
    // Handle use plan
  },
)
```

---

### 8. ViewAllButtonWidget
**Purpose**: Centered "View All" button
**Used In**: Eatery Screen, Hotels Screen
**Props**:
- `onTap` (VoidCallback?): Button tap callback
- `text` (String): Button text (default: "View All")

**Example**:
```dart
ViewAllButtonWidget(
  onTap: () {
    // Handle view all
  },
)
```

---

### 9. SectionTitleWidget
**Purpose**: Consistent section heading styling
**Used In**: Multiple screens
**Props**:
- `title` (String): Section title text

**Example**:
```dart
SectionTitleWidget(title: 'Popular from Users')
```

---

## Screen Implementation Examples

### Eatery Screen
Uses all shared widgets with restaurant-specific content:
- Categories: Restaurants, Hotels, Street Food
- Filters: All, Veg Only, Budget, Top Rated
- Promotional: Traditional Misal Pav Spots
- Cards: Restaurant listings with cuisine, features

### Hotels Screen
Reuses the same widgets with hotel-specific content:
- Categories: Hotels, Resorts, Guest House
- Filters: All, Budget, Luxury, Top Rated
- Promotional: Special booking offers
- Cards: Hotel listings with room types, amenities

---

## Benefits of This Structure

1. **Code Reusability**: Shared widgets can be used across multiple screens
2. **Consistency**: UI remains consistent across the app
3. **Maintainability**: Updates to a widget automatically apply everywhere it's used
4. **Flexibility**: Widgets accept props for customization
5. **Scalability**: Easy to add new screens (Vineyards, Flights, etc.) using the same widgets

---

## Adding a New Listing Screen

To create a new listing screen (e.g., Vineyards Screen):

1. Create `lib/screens/vineyards_screen.dart`
2. Import shared widgets
3. Set up state for category and filter
4. Use the shared widgets with vineyard-specific content
5. Add navigation from home screen

**Template**:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nashik/core/widgets/shared/category_selection_widget.dart';
import 'package:nashik/core/widgets/shared/filter_buttons_widget.dart';
import 'package:nashik/core/widgets/shared/listing_card_widget.dart';
// ... import other shared widgets

class VineyardsScreen extends StatefulWidget {
  const VineyardsScreen({super.key});

  @override
  State<VineyardsScreen> createState() => _VineyardsScreenState();
}

class _VineyardsScreenState extends State<VineyardsScreen> {
  String selectedCategory = 'Vineyards';
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(/* ... */),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              SearchBarWidget(hintText: 'Search vineyards'),
              CategorySelectionWidget(/* ... */),
              FilterButtonsWidget(/* ... */),
              ResultCountWidget(/* ... */),
              PromotionalBoxWidget(/* ... */),
              // Add ListingCardWidget instances
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Design System

### Colors
- Primary Orange: `#FF914D`
- Secondary Orange: `#FFB247`
- Orange Accent: `#FF8400`
- Dark Gray: `#1F2937`
- Medium Gray: `#6B7280`
- Light Gray: `#E5E7EB`
- Success Green: `#22C55E`

### Typography (Montserrat)
- Bold 18sp: Section titles
- Semibold 18sp: Card titles
- Medium 16sp: Buttons, subtitles
- Regular 14sp: Body text
- Regular 12sp: Helper text

### Spacing
- Section gaps: 16.h - 24.h
- Card spacing: 16.h
- Horizontal padding: 20.w
- Element spacing: 8.w - 12.w

---

## Navigation Flow

```
HomeScreen
├─> TransportScreen
├─> EateryScreen
└─> HotelsScreen
```

All navigation uses `Navigator.push` with `MaterialPageRoute`.

---

## Future Enhancements

1. Add search functionality to SearchBarWidget
2. Implement filter modal for FilterButtonsWidget
3. Add favorite state management
4. Implement booking/reservation functionality
5. Add more screens: Vineyards, Flights, Railways, etc.
6. Create a base listing screen class to reduce boilerplate


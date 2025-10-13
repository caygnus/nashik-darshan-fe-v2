// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:nashik_darshan/core/get_it/get_it.dart';

// class UserPrefs {
//   static final SharedPreferences _prefs = locator();

//   static const String _onboardingShownKey = 'OnboardingShown';
//   static const String _courseSelectedKey = 'CourseSelected';

//   // Save if onboarding screens have been shown
//   static Future<void> setOnboardingShown(bool value) async {
//     await _prefs.setBool(_onboardingShownKey, value);
//   }

//   // Retrieve onboarding screen status
//   static bool isOnboardingShown() {
//     return _prefs.getBool(_onboardingShownKey) ?? false;
//   }

//   // Save course selection state
//   static Future<void> setCourseSelected(bool value) async {
//     await _prefs.setBool(_courseSelectedKey, value);
//   }

//   // Retrieve course selection status
//   static bool isCourseSelected() {
//     return _prefs.getBool(_courseSelectedKey) ?? false;
//   }

//   // Clear all preferences (used when resetting the state)
//   static Future<void> clearPreferences() async {
//     await _prefs.clear();
//   }
// }

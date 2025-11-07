// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nashik/features/profile/presentation/profile_screen.dart';
// import 'package:nashik/android_app.dart';
// import 'package:nashik/ios_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 920),
//       child: MultiBlocProvider(
//         providers: [
//           // BlocProvider(

//           //   child: Container(),
//           // ),
//         ],
//         child: Platform.isIOS ? const IosApp() : const AndroidApp(),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // base layout size (width, height)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Travel App',
          theme: ThemeData(useMaterial3: true),
          home: child,
        );
      },
      child: const ProfileScreen(), // 👈 your main screen
    );
  }
}

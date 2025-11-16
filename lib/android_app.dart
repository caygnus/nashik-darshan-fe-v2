import 'package:flutter/material.dart';
import 'package:nashik/core/keys.dart';
import 'package:nashik/core/theme/app_theme.dart';
import 'package:nashik/features/home/presentation/pages/home_screen.dart';
// import 'package:nashik_darshan/core/router/app_router.dart';

class AndroidApp extends StatelessWidget {
  const AndroidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nashik Darshan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scaffoldMessengerKey: scaffoldMessengerKey,
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
      // TODO: When router is ready, switch back to MaterialApp.router
      // routerConfig: Approuter.router,
    );
  }
}

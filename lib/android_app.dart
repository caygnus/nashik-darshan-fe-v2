import 'package:flutter/material.dart';
import 'package:nashik/core/constants/keys.dart';
import 'package:nashik/core/theme/app_theme.dart';
// import 'package:nashik_darshan/core/router/app_router.dart';

class AndroidApp extends StatelessWidget {
  const AndroidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nashik Darshan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scaffoldMessengerKey: scaffoldMessangerKey,
      themeMode: ThemeMode.light,
      // routerConfig: Approuter.router,
    );
  }
}

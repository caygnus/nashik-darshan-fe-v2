import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nashik/screens/home_screen.dart';
// import 'package:nashik_darshan/core/router/app_router.dart';

class IosApp extends StatelessWidget {
  const IosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Nashik Darshan',
      theme: const CupertinoThemeData(
        applyThemeToAll: true,
        primaryColor: Colors.purple,
      ),
      home: const HomeScreen(),
      // TODO: When router is ready, switch back to CupertinoApp.router
      // routerConfig: Approuter.router,
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nashik/core/app/android_app.dart';
import 'package:nashik/core/app/ios_app.dart';
import 'package:nashik/core/dependency_injection/get_it.dart';
import 'package:nashik/core/infrastructure/env/config.dart';
import 'package:nashik/core/infrastructure/supabase/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Config (loads .env file)
  await Config.instance;

  // Initialize Supabase with environment variables
  await SupabaseConfig.initialize();

  // Initialize service locator (encrypted secure storage)
  await serviceLocatorInit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 920),
      // TODO: Add MultiBlocProvider back when you have actual BlocProviders
      // child: MultiBlocProvider(
      //   providers: [
      //     BlocProvider(
      //       create: (context) => YourBloc(),
      //       child: Container(),
      //     ),
      //   ],
      child: Platform.isIOS ? const IosApp() : const AndroidApp(),
      // ),
    );
  }
}

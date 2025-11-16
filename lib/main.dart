import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nashik/android_app.dart';
import 'package:nashik/core/di/get_it.dart';
import 'package:nashik/core/env/config.dart';
import 'package:nashik/core/router/app_router.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nashik/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nashik/ios_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Config (loads .env file)
  await Config.instance;

  // Initialize Supabase with environment variables
  await SupabaseConfig.initialize();

  // Initialize service locator (encrypted secure storage)
  await serviceLocatorInit();

  // initialize the go router
  Approuter.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 920),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit()),
          BlocProvider(create: (context) => ProfileCubit()),
        ],
        child: Platform.isIOS ? const IosApp() : const AndroidApp(),
      ),
    );
  }
}

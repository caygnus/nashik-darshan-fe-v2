import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nashik/android_app.dart';
import 'package:nashik/ios_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          // BlocProvider(

          //   child: Container(),
          // ),
        ],
        child: Platform.isIOS ? const IosApp() : const AndroidApp(),
      ),
    );
  }
}

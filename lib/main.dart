import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quality_management_system/Core/theme/app_theme.dart';
import 'package:quality_management_system/Features/Dashboard/view/mainScreen.dart';
import 'package:quality_management_system/my_bloc_observer.dart';

import 'Core/Network/local_db/share_preference.dart';
import 'firebase_options.dart';
import 'navBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CashSaver.init();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: AppTheme.dark,
          routes: <String, WidgetBuilder>{
            Navbar.id: (context) => const Navbar(),
          },
          initialRoute: Navbar.id,
        );
      },
    );
  }
}
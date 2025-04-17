
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Core/theme/app_theme.dart';
import 'package:quality_management_system/my_bloc_observer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  await Supabase.initialize(
    url: 'https://tcusdwgvyrddurqczvlr.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjdXNkd2d2eXJkZHVycWN6dmxyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ4Mzg2MjksImV4cCI6MjA2MDQxNDYyOX0.Raw6ZVpnqV4IbXS7NOGZfIJxifWwSpp2kLU16AtHQp4',
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
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
      designSize: ResponsiveHelper.isDesktop(context)
          ? const Size(1920, 1080)
          : ResponsiveHelper.isTablet(context)
              ? const Size(768, 1024)
              : const Size(375, 667),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: AppTheme.light,
          routes: <String, WidgetBuilder>{
            Navbar.id: (context) => const Navbar(),
          },
          initialRoute: Navbar.id,
        );
      },
    );
  }
}

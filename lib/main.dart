
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Core/theme/app_theme.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/OrdersDetails.dart';
import 'package:quality_management_system/Features/auth/view/screens/signin_screen.dart';
import 'package:quality_management_system/dependency_injection.dart';
import 'package:quality_management_system/my_bloc_observer.dart';
import 'Core/Network/local_db/share_preference.dart';
import 'firebase_options.dart';
import 'navBar.dart';

void main() async {
  init();
  WidgetsFlutterBinding.ensureInitialized();
  await CashSaver.init();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  bool remembered = await CashSaver.getData(key: 'isRememberMe') ?? false ;
  // await Supabase.initialize(
  //   url: 'https://tcusdwgvyrddurqczvlr.supabase.co',
  //   anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjdXNkd2d2eXJkZHVycWN6dmxyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ4Mzg2MjksImV4cCI6MjA2MDQxNDYyOX0.Raw6ZVpnqV4IbXS7NOGZfIJxifWwSpp2kLU16AtHQp4',
  //   realtimeClientOptions: const RealtimeClientOptions(
  //     logLevel: RealtimeLogLevel.info,
  //   ),
  // );

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
          routes: {
            Navbar.id: (context) => const Navbar(),
            SigninScreen.id: (context) => const SigninScreen(),
          },
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(snapshot.data!.email)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (userSnapshot.hasData) {
                      final role = userSnapshot.data?.get('role') as String?;
                      return role == 'admin'
                          ? const Navbar()
                          : const OrdersTableDetails();
                    }
                    return const SigninScreen();
                  },
                );
              }
              return const SigninScreen();
            },
          ),
        );
  }
  );
}
}

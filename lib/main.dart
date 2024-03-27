
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/features/auth/presentation/pages/both_auth_screen.dart';
import 'package:smart_real_estate/features/client/chat/pages/rooms_screen.dart';
import 'package:smart_real_estate/features/client/root/pages/root_screen.dart';
import 'package:smart_real_estate/features/client/splash/screen/splash_screen.dart';

import 'core/helper/local_data/shared_pref.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'features/client/home/pages/home_screen.dart';
import 'features/client/onBoarding/pages/onBoarding_screen.dart';
import 'features/client/welcome/pages/welcome_select_screen.dart';
import 'firebase_options.dart';



Future<void> main() async {

  /// 1. for Localization and Languages
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init(['en', 'ar']); // get last saved language

  /// 2. initialize firebase
  _initializeFirebase();

  /// 3. for buttery icons and notifications to be fixable in colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),);

  /// 4. Initialize SharedPreferences
  await SharedPrefManager.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: light,
        darkTheme: dark,
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        home: const RootScreen(),
      ),
    );
  }
}

/// firebase initialization
_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}


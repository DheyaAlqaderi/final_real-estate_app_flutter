import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/features/client/onBoarding/pages/onBoarding_screen.dart';
import 'package:smart_real_estate/features/client/root/pages/root_screen.dart';

import '../../../../core/helper/local_data/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load data and navigate based on its presence
    loadData();
  }


  Future<void> loadData() async {
    try {
      // Retrieve data
      String? firstTime = await SharedPrefManager.getData('FirstTime');

      if (kDebugMode) {
        print(firstTime);
      }
      // Simulate a delay to mimic loading process
      await Future.delayed(const Duration(seconds: 2));

      if (firstTime == null) {
        // Navigate to OnboardingPage if token is present
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
        );
      } else {
        // Navigate to HomePage if token is not present
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RootScreen()),
        );
      }
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print('Error loading data: $e');
      }
      // Navigate to HomePage as fallback

    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                Images.splashImage,
                fit: BoxFit.cover,
              )
          ),

          Center(
            child: Image.asset(Images.logo,),
          )
        ],
      ),
    );
  }
}

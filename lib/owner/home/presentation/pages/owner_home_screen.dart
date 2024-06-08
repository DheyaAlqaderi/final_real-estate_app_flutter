import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/features/client/home/pages/home_screen.dart';

import '../widgets/home_appbar.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnerHomeAppbar(
        onTapBack: () {
          Get.to(HomeScreen()); },),
    );
  }
}

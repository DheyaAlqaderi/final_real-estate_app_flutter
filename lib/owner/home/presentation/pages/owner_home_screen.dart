

import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/home/pages/home_screen.dart';
import 'package:smart_real_estate/features/client/root/pages/root_screen.dart';

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
      appBar: OwnerHomeAppbar(),
      body: Column(
        children:[
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCounter('50', 'التعليقات'),
              _buildCounter('23', 'القوائم النشطة'),
              _buildCounter('20', 'القوائم غير النشطة'),
            ],
          ),]
      ),

    );
  }
}




Widget _buildCounter(String count, String label) {
  return Column(
    children: [
      Container(
        height: 107,
          width: 107,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color:const Color(0xFF252B5C),
              width: 3,
            )
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
            count,
            style: fontSmallBold,
            ),
             const SizedBox(height: 8),
            Text(
              label,
              style: fontSmall,
            ),
        ],)
      )
    ],
  );
}

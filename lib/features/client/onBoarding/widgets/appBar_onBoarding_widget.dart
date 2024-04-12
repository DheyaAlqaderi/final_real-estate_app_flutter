import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';

import '../../../../core/utils/styles.dart';

class AppBarOnBoardingWidget extends StatefulWidget {
  const AppBarOnBoardingWidget({super.key});

  @override
  State<AppBarOnBoardingWidget> createState() => _AppBarOnBoardingWidgetState();
}

class _AppBarOnBoardingWidgetState extends State<AppBarOnBoardingWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
              onPressed: (){
                setState(() {
                  Locales.change(context, 'ar');
                });
              },
              child: SizedBox(
                height: 38.0,
                  width: 60.0,
                  child: Center(
                      child: Text(Locales.string(context, "skip"), style: fontMedium)
                  )
              )
          ),
          SvgPicture.asset(
              Images.logo,
            height: 55.0,
            width: 55.0,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}

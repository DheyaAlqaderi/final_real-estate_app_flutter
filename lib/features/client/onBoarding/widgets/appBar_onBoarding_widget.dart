import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

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
          const Icon(Icons.search),
        ],
      ),
    );
  }
}

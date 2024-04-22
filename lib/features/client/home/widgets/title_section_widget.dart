import 'package:flutter/material.dart';

import '../../../../core/utils/styles.dart';

class TitleSectionWidget extends StatelessWidget {
  const TitleSectionWidget({super.key, required this.titleSection, required this.titleButton, required this.tap});
  final String titleSection;
  final String titleButton;
  final VoidCallback tap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titleSection, style: fontMediumBold,),
          InkWell(
              onTap: tap,
              child: Text(titleButton, style: fontSmallBold,)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';

import '../../../../core/utils/styles.dart';


class OwnerProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OwnerProfileAppBar({super.key, required this.edit, required this.setting, required this.title, });
  final VoidCallback edit;
  final VoidCallback setting;
  final String title;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AppBar(
        title: Text(Locales.string(context, title),style: fontLargeBold,),
        centerTitle: true,

        leading: IconButton(


            icon: SvgPicture.asset(Images.settingIcon),
            onPressed: setting
        ),
        actions: [
          IconButton(
              style: IconButton.styleFrom(
                backgroundColor:Theme.of(context).cardColor,
              ),
              icon: SvgPicture.asset(Images.editIcon,
                 //Ensure your SVG file is in the assets folder
                 color: Theme.of(context).primaryColor,
                width: 25.0,
                height: 25.0,
              ),
              onPressed: edit
          ),
        ],

      ),
    );
  }

@override
Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

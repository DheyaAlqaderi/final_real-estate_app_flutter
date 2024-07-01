import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';

import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';
import '../../../../features/client/home/pages/home_screen.dart';
import '../../../../features/common_widget/circle_button_widget_icon.dart';

class OwnerHomeAppbar extends StatelessWidget implements PreferredSizeWidget{
  const OwnerHomeAppbar({super.key, });




  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(Locales.string(context, "home_page"),style: fontLargeBold,),
      centerTitle: true,

      leading:Container(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: CircleButtonWidgetIcon(
            icon: Icons.notifications_none,
            onTap: () {
               Get.to(const HomeScreen());
              },)),

        //icon: SvgPicture.asset(Images.notificIcon),



      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: ClipOval(
            child: Image.asset(Images.mePicture),
          )
          ),


        // IconButton(
        //   style: ButtonStyle(),
        //   onPressed: (){},

      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

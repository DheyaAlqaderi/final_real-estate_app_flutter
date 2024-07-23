import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';

import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';
import '../../../../features/common_widget/circle_button_widget_icon.dart';
import '../../../notification/presentation/pages/notification_screen.dart';

class OwnerHomeAppbar extends StatelessWidget implements PreferredSizeWidget{
  const OwnerHomeAppbar({super.key, required this.token, required this.imagePath,});

  final String token;
  final String imagePath;



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
               Get.to(NotificationScreen(token: token,));
              },)),

      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: ClipOval(
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(imagePath)
                  )
                )),
          )
          ),


      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

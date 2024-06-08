import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';

class OwnerHomeAppbar extends StatelessWidget implements PreferredSizeWidget{
  const OwnerHomeAppbar({super.key, required this.onTapBack});


  final VoidCallback onTapBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(Locales.string(context, "home_page"),style: fontLargeBold,),
      centerTitle: true,

      leading:IconButton(
        style: ButtonStyle(

        ),
        icon: SvgPicture.asset(Images.notificIcon),
        onPressed: onTapBack,
      ) ,

      actions: [
        IconButton(
          style: ButtonStyle(),
          icon: Image.asset(Images.mePicture),
          onPressed: (){},
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

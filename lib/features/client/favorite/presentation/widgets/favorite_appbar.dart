
import 'package:flutter/material.dart';

import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/home/pages/home_screen.dart';


class FavoriteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FavoriteAppBar({super.key});

   //const FavoriteAppBar({super.key});



  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(Locales.string(context, "title_favorite",),style: fontLargeBold,),
        centerTitle: true,
        actions:[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              style: IconButton.styleFrom(fixedSize: const Size(50, 50),
                  backgroundColor:Theme.of(context).cardColor  ),
              icon: SvgPicture.asset(Images.trustIcon),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen(),)

                );
              },),
          ),
        ]



    );
  }



@override
Size get preferredSize => const Size.fromHeight(kToolbarHeight);}

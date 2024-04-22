

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../../../../../core/utils/styles.dart';
class AppBarWidget extends StatelessWidget  implements PreferredSizeWidget{
  const AppBarWidget({super.key, required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;



  @override
  Widget build(BuildContext context) {
    return  AppBar(
      title: Text(Locales.string(context, title),style: fontLargeBold,),
      centerTitle: true,

      leading: IconButton(
        style: IconButton.styleFrom(
          backgroundColor:Theme.of(context).cardColor,
        ),
        icon: const Icon(Icons.arrow_back_ios_new_outlined,size: 15,),
        onPressed: onTap
      ),//

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);}

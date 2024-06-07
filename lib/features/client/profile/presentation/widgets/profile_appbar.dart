

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/styles.dart';
class ProfileAppBarWidget extends StatelessWidget  implements PreferredSizeWidget{
  const ProfileAppBarWidget({super.key, required this.title, required this.onTapBack, required this.onTapEdit, required this.editIcon});
  final String title;
  final VoidCallback onTapBack;
  final VoidCallback onTapEdit;
  final String editIcon;



  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AppBar(
        title: Text(Locales.string(context, title),style: fontLargeBold,),
        centerTitle: true,

        leading: IconButton(
            style: IconButton.styleFrom(
              backgroundColor:Theme.of(context).cardColor,
            ),
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: onTapBack
        ),
        actions: [
          IconButton(
              style: IconButton.styleFrom(
                backgroundColor:Theme.of(context).cardColor,
              ),
              icon: SvgPicture.asset(
                editIcon, // Ensure your SVG file is in the assets folder
                color: Theme.of(context).primaryColor,
                width: 21.0,
                height: 21.0,
              ),
              onPressed: onTapEdit
          ),
        ],

      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);}

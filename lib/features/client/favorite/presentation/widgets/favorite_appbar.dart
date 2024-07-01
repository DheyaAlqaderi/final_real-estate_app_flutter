
import 'package:flutter/material.dart';

import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';



class FavoriteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FavoriteAppBar({super.key, required this.onTap});
  final VoidCallback onTap;



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
                _deleteAllFavorite(context);
              }
            )
          ),
        ]


    );

  }

  _deleteAllFavorite(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          color: Theme.of(context).cardColor,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Locales.string(context, 'delete_favorite'),style: fontLarge,),
                const SizedBox(height: 10,),
                Text(Locales.string(context, 'delete_all_favorite'),style: fontMediumBold,),
                const SizedBox(height: 20,),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 18.0),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: onTap,
                        child: Container(
                          height: 40,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color:Theme.of(context).colorScheme.onError,
                          ),
                          child: Text(Locales.string(context, 'delete')),
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          //cancelDelete();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color:Theme.of(context).focusColor,
                          ),
                          child: Text(Locales.string(context, 'cancel')),
                        ),
                      ),
                    ],
                                   ),
                 )








              ],
            ),
          ),
        );
      },
    );
  }



@override
Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // void cancelDelete() {
  //
  // }

  }

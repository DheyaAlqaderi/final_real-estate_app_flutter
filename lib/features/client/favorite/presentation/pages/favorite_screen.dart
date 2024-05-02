

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/favorite/presentation/widgets/favorite_appbar.dart';
import 'package:smart_real_estate/features/client/favorite/presentation/widgets/favorite_widget_temp.dart';
import 'package:smart_real_estate/features/client/home/widgets/featured_property_widget.dart';

import '../../data/models/favorite_model.dart';
import '../../data/repositories/network.dart';



class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});




  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final int list=6;
  late FavoriteRepository favoriteRepository;
  // late String token;

  @override
  void initState()  {
    super.initState();

    favoriteRepository = FavoriteRepository(Dio());

    // token = await SharedPrefManager.getData(AppConstants.token) as String;
  }

  bool isDesign1 = true;

  void showDesign1() {
    setState(() {
      isDesign1 = true;
    });
  }

  void showDesign2() {
    setState(() {
      isDesign1 = false;
    });
  }






  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const FavoriteAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Text("$list",style: fontMediumBold,),
                    Text(Locales.string(context, 'favorite_list'),style: fontLarge,)
                  ],
                ),
              ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                     height: 40,
                     width: 100,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(100),
                       color:Theme.of(context).cardColor
                     ),
                     child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           InkWell(
                             onTap: showDesign1,
                             child: Container(
                               height: 24,
                               width: 34,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(100),
                                 color: isDesign1?Colors.white:Colors.transparent,
                               ),

                               child:Center(child: SvgPicture.asset(Images.listIcon, color: isDesign1?null:Colors.grey,)),
                             ),
                           ),
                           InkWell(
                             onTap: showDesign2,
                             child:
                             Container(
                               height: 24,
                               width: 34,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(100),
                                 color: isDesign1?Colors.transparent:Colors.white,
                               ),
                               child:Center(child: SvgPicture.asset(Images.grideIcon,fit: BoxFit.contain, color: isDesign1?null:Theme.of(context).primaryColor,) ),
                           ))


                         ],
                       ),
                     ),
                  ),
                ),
            ],
            
          ),
          const SizedBox(height: 60,),
          Flexible(
            child:FutureBuilder<FavoriteModel?>(
                future: favoriteRepository.getFavorite("token 3cbe099b83e79ab703f50eb1a09f9ad658f9fe89"),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    var data = snapshot.data!.results;


                  return !isDesign1 ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: data!.length,

                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FavoriteWidget(
                          imagePath: data[index].prop!.image!.first.image!,
                          title: data[index].prop!.name!,
                          price: data[index].prop!.price!,
                          address: data[index].prop!.address!,
                          isFavorite: data[index].prop!.inFavorite!,
                          rate: data[index].prop!.rateReview!,
                          onTapDelete: () async {
                            await favoriteRepository.deleteFavorite("token 3cbe099b83e79ab703f50eb1a09f9ad658f9fe89", data[index].prop!.id!);

                            // reload the widget
                            setState(() {
                              // Remove the item from the data list
                              data.removeAt(index);
                            });

                          },
                        ),
                      );
                    },
                  )
                      : SizedBox();
                } else{
                  return SizedBox();
                }
              }
            ),
          )
        ],
      ),
    );
  }
}


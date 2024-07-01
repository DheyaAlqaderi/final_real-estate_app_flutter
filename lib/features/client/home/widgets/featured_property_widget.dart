import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/favorite/presentation/widgets/add_favorite.dart';
import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';

import '../../../../core/helper/local_data/shared_pref.dart';
import '../../add_favorite/repository/add_favorite_repository.dart';
import '../../favorite/data/repositories/network.dart';


class FeaturedPropertyWidget extends StatefulWidget {
  const FeaturedPropertyWidget({super.key, required this.propertyModel, required this.index, required this.onTap});
  final PropertyModel propertyModel;
  final int index;
  final VoidCallback onTap;


  @override
  State<FeaturedPropertyWidget> createState() => _FeaturedPropertyWidgetState();
}

class _FeaturedPropertyWidgetState extends State<FeaturedPropertyWidget> {
  late bool isSelected;
  String? token;
  late FavoriteRepository favoriteRepository;

  Future<void> _loadUserToken() async {
    final loadUserToken = await SharedPrefManager.getData(AppConstants.token);
    // print(loadUserToken.toString());
    setState(() {
      token = loadUserToken ?? '';
    });
  }
  @override
  void initState() {
    super.initState();
    favoriteRepository = FavoriteRepository(Dio());
    _loadUserToken();
    isSelected= widget.propertyModel.results![widget.index].inFavorite!;
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 156.0,
          width: 268.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).cardColor,
            // boxShadow: [
            //   BoxShadow(
            //     color: Theme.of(context).shadowColor.withOpacity(0.2), // Use shadowColor from the theme with opacity
            //     spreadRadius: 2, // Spread radius of the shadow
            //     blurRadius: 4, // Blur radius of the shadow
            //     offset: const Offset(0, 2), // Offset of the shadow
            //   ),
            // ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // image
              Container(
                height: double.infinity,
                width: 126,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: widget.propertyModel.results?[widget.index].image != null &&
                      widget.propertyModel.results![widget.index].image!.isNotEmpty
                      ? DecorationImage(
                      image: CachedNetworkImageProvider(
                          "${AppConstants.baseUrl3}${widget.propertyModel.results![widget.index].image![0].image}"),
                      fit: BoxFit.cover)
                      : null,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      right: Locales.isDirectionRTL(context)
                          ? 10
                          : null,
                      left: Locales.isDirectionRTL(context)
                          ? null
                          : 10,
                      child: InkWell(
                        onTap: ()async{
                          try {
                            if (isSelected) {
                              // Perform delete favorite action
                              await favoriteRepository.deleteFavorite("token ${token!}", widget.propertyModel.results![widget.index].id!);
                            } else {
                              // Perform add favorite action
                              await AddFavoriteRepository.addFavorite(widget.propertyModel.results![widget.index].id!, token!);
                            }

                            // Toggle isSelected state
                            setState(() {
                              isSelected = !isSelected;
                            });
                          } catch (e) {
                            // Handle any errors here
                            Get.snackbar(
                              'Error',
                              'Failed to perform action: $e',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: Container(
                          height: 25.0,
                          width: 25.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Center(
                              child: SvgPicture.asset(
                                  Images.heartIcon,
                                  width: 15,
                                  height: 15,
                                  color: isSelected
                                      ? Colors.red
                                      : Colors.grey
                              ),
                          ),
                        ),
                      ),
                    ),


                    Positioned(
                      bottom: 5,
                      right: 10.0,
                      child: Container(
                        height: 29.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: widget.propertyModel.results![widget.index].forSale ?? false
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                              : Theme.of(context).colorScheme.primary,
                        ),
                        child: Center(
                          child: Text(
                            widget.propertyModel.results![widget.index].forSale ?? false
                                ? Locales.string(context, "for_sale")
                                : Locales.string(context, "for_rent"),
                            style: fontSmall.copyWith(
                              color: widget.propertyModel.results![widget.index].forSale ?? false
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),



                  ],
                ),
              ),
              /// content
              SizedBox(
                height: double.infinity,
                width: 142.0,
                child: Column(
                  crossAxisAlignment: Locales.isDirectionRTL(context)?CrossAxisAlignment.start:CrossAxisAlignment.end,
                  children:  [
                    Padding(
                      padding: Locales.isDirectionRTL(context)
                          ?const EdgeInsets.only(right: 15.0,top: 5.0, bottom: 5.0)
                          :const EdgeInsets.only(right: 15.0,top: 5.0, bottom: 5.0),
                      child:  Text(
                          widget.propertyModel.results![widget.index].name.toString(),
                        style: fontSmallBold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                      child: Locales.isDirectionRTL(context)
                          ?  Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 10,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: SizedBox(
                                      width: 120,
                                      child: Text(
                                        widget.propertyModel.results![widget.index].address.toString(),
                                        style: fontSmall,
                                        textDirection: TextDirection.rtl,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                              ]
                            )
                          : Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                  child: SizedBox(
                                    width: 120,
                                    child: Text(
                                      widget.propertyModel.results![widget.index].address.toString(),
                                      style: fontSmall,
                                      maxLines: 2,
                                      textDirection: TextDirection.rtl,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.location_on_outlined, size: 10,),
                              ]
                          )
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                        child: Locales.isDirectionRTL(context)
                            ?  Row(
                            children: [
                              const Icon(Icons.star, size: 10, color: Colors.amberAccent,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: SizedBox(
                                  width: 120,
                                  child: Text(
                                    widget.propertyModel.results![widget.index].rate.toString(),
                                    style: fontSmall,
                                    textDirection: TextDirection.rtl,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ]
                        )
                            : Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: SizedBox(
                                  width: 120,
                                  child: Text(
                                    widget.propertyModel.results![widget.index].rate.toString(),
                                    style: fontSmall,
                                    maxLines: 2,
                                    textDirection: TextDirection.rtl,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const Icon(Icons.star, size: 10, color: Colors.amberAccent,),
                            ]
                        )
                    ),
                    Expanded(
                        child: Padding(
                          padding: Locales.isDirectionRTL(context)
                              ?const EdgeInsets.only(right: 15.0,top: 5.0, bottom: 5.0)
                              :const EdgeInsets.only(right: 15.0,top: 5.0, bottom: 5.0),
                          child:  Align(
                              alignment: Alignment.bottomRight,
                              child: (!widget.propertyModel.results![widget.index].forSale!)
                                  ?Text(
                                  "${widget.propertyModel.results![widget.index].price.toString()} الف /شهر",
                                style: fontSmallBold,
                                maxLines: 1,
                                textDirection: TextDirection.rtl,
                                overflow: TextOverflow.ellipsis,
                              )
                                  : Text(
                                widget.propertyModel.results![widget.index].price.toString(),
                                style: fontSmallBold,
                                maxLines: 1,
                                textDirection: TextDirection.rtl,
                                overflow: TextOverflow.ellipsis,
                              ) ,
                          ),
                        )
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
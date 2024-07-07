import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';

import '../../../../core/helper/local_data/shared_pref.dart';
import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';
import '../../../auth/presentation/pages/both_auth_screen.dart';
import '../../add_favorite/repository/add_favorite_repository.dart';
import '../../favorite/data/repositories/network.dart';
import '../data/models/property/property_model.dart';

class StandPropertyWidget extends StatefulWidget {
  const StandPropertyWidget({super.key, required this.propertyModel, required this.index, required this.onTap});
  final PropertyModel propertyModel;
  final int index;
  final VoidCallback onTap;

  @override
  State<StandPropertyWidget> createState() => _StandPropertyWidgetState();
}

class _StandPropertyWidgetState extends State<StandPropertyWidget> {
  late bool isSelected;
  String? token;
  late FavoriteRepository favoriteRepository;

  Future<void> _loadUserToken() async {
    final loadUserToken = await SharedPrefManager.getData(AppConstants.token);
    // print(loadUserToken.toString());
    setState(() {
      token = loadUserToken ?? ' ';
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
          height: 231.0,
          width: 160.0,
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
          child: Column(
            children: [
              /// image
              Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image:  DecorationImage(
                          image: CachedNetworkImageProvider(
                              // AppConstants.noImageUrl
                            widget.propertyModel.results![widget.index].image!.isEmpty
                                ? AppConstants.noImageUrl
                                : "${AppConstants.baseUrl3}${widget.propertyModel.results![widget.index].image!.first.image}"
                          ),
                          fit: BoxFit.cover
                      )
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
                          onTap: () async {
                            try {
                              if (token != " ") {
                                if (isSelected) {
                                  // Perform delete favorite action
                                  await favoriteRepository.deleteFavorite("token ${token!}", widget.propertyModel.results![widget.index].id!);
                                  Get.snackbar(
                                    'Success',
                                    'Favorite deleted successfully',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                } else {
                                  // Perform add favorite action
                                  await AddFavoriteRepository.addFavorite(widget.propertyModel.results![widget.index].id!, token!);
                                }

                                // Toggle isSelected state
                                setState(() {
                                  isSelected = !isSelected;
                                });
                              } else {
                                Get.defaultDialog(
                                  title: 'Login First',
                                  middleText: 'You have to login in order to add favorite',
                                  backgroundColor: Colors.white.withOpacity(0.9),
                                  titleStyle: const TextStyle(color: Colors.black),
                                  middleTextStyle: const TextStyle(color: Colors.black),
                                  confirm: ElevatedButton(
                                    onPressed: () {
                                      // Navigate to login page
                                      Get.to(() =>const BothAuthScreen(isOwner: false));
                                    },
                                    child: const Text('Login'),
                                  ),
                                  barrierDismissible: true,
                                );
                              }
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
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor.withOpacity(0.2), // Use shadowColor from the theme with opacity
                                  spreadRadius: 2, // Spread radius of the shadow
                                  blurRadius: 4, // Blur radius of the shadow
                                  offset: const Offset(0, 2), // Offset of the shadow
                                ),
                              ],
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.800000011920929),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                widget.propertyModel.results![widget.index].price ?? "null",
                                 style: fontSmall.copyWith(color: Theme.of(context).colorScheme.secondary)
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
              ),

              /// content
              const SizedBox(height: 8.0,),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                      child: Padding(
                        padding: Locales.isDirectionRTL(context)
                            ?const EdgeInsets.only(right: 15.0,top: 5.0, bottom: 5.0)
                            :const EdgeInsets.only(right: 15.0,top: 5.0, bottom: 5.0),
                        child: Text(
                          widget.propertyModel.results![widget.index].name!,
                          style: fontSmallBold,),
                      )),
                  const SizedBox(height: 2.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                    child: Locales.isDirectionRTL(context)
                        ? Row(
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
                              width: 130,
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
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

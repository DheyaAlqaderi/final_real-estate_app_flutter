
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/owner/edit_property/presentation/pages/edit_property_page.dart';
import 'package:smart_real_estate/owner/home/data/models/activate_model.dart';
import 'package:smart_real_estate/owner/owner_root_screen/presentation/pages/owner_root_screen.dart';

import '../../../../core/helper/local_data/shared_pref.dart';
import '../../../../features/auth/presentation/pages/both_auth_screen.dart';
import '../../../../features/client/add_favorite/repository/add_favorite_repository.dart';
import '../../../../features/client/favorite/data/repositories/network.dart';
import '../../domain/repositories/property_owner_repositories.dart';


class OwnerPropertyWidget extends StatefulWidget {
  const OwnerPropertyWidget({super.key, required this.imagePath, required this.title, required this.price, required this.address, required this.isFavorite, required this.rate, required this.id, required this.isActivate, required this.refresh, required this.onTap});
  final String imagePath;
  final String title;
  final String price;
  final String address;
  final bool isFavorite;
  final double rate;
  final bool isActivate;
  final int id;
  final Widget refresh;
  final VoidCallback onTap;



  @override
  State<OwnerPropertyWidget> createState() => _OwnerPropertyWidgetState();
}

class _OwnerPropertyWidgetState extends State<OwnerPropertyWidget> {
  late bool isSelected;
  String? token;
  late FavoriteRepository favoriteRepository;
  late OwnerPropertyRepository ownerPropertyRepository;
  bool isLoading = false;

  Future<void> _loadUserToken() async {
    final loadUserToken = await SharedPrefManager.getData(AppConstants.token);
    print("my token isssssssssss${loadUserToken}");
    token = loadUserToken ?? ' ';

  }

  @override
  void initState() {
    super.initState();
    _loadUserToken();
    favoriteRepository = FavoriteRepository(Dio());
    ownerPropertyRepository = OwnerPropertyRepository(Dio());

    setState(() {
      isSelected= widget.isFavorite;
    });
    print("issssssssss${widget.isFavorite.toString()}");

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 231.0,
        width: 165,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //image
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.imagePath.isNotEmpty||widget.imagePath!=null?"${AppConstants.baseUrl3}${widget.imagePath}":AppConstants.noImageUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),

                  //heart
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () async {
                        try {
                          if (token != " ") {
                            if (isSelected) {
                              // Perform delete favorite action
                              await favoriteRepository.deleteFavorite("token ${token!}", widget.id);
                              Get.snackbar(
                                'Success',
                                'Favorite deleted successfully',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            } else {
                              // Perform add favorite action
                              await AddFavoriteRepository.addFavorite(widget.id,token!);
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
                                  Get.to(() =>const BothAuthScreen(isOwner: true));
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
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(
                          child: SvgPicture.asset(Images.heartIcon, color: isSelected?Colors.red:Colors.grey,),
                        ),
                      ),
                    ),
                  ),

                  //edit
                  Positioned(
                    top: 15,
                    left: 15,
                    child: InkWell(
                      onTap: (){
                        print(widget.id);
                        Get.to(()=> EditPropertyPage(propertyId: widget.id));
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(
                          child: SvgPicture.asset(Images.editIcon),
                        ),
                      ),
                    ),
                  ),

                  //price
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Text(widget.price,style: fontSmallBold.copyWith(color: Colors.white),),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              //details
              const SizedBox(height: 3,),
              Text(widget.title,style: fontMediumBold,maxLines: 1,overflow: TextOverflow.ellipsis,),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    children: [
                      const Icon(Icons.location_on_sharp, size: 10,),
                      SizedBox( width: 80,child: Text(widget.address.toString(),style: fontSmall.copyWith(color: Colors.grey),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                    ],
                  ),
                  !widget.isActivate
                      ?InkWell(
                    onTap: () async {
                      try {
                        setState(() {
                          isLoading = true;
                        });

                        ActivateModel activateModel = ActivateModel();
                        activateModel.isActive = true;
                        final response = await ownerPropertyRepository.activateProperty(
                          activateModel,
                          widget.id.toString(),
                          "token $token",
                        );

                        setState(() {
                          isLoading = false;
                        });
                        if (response.isActive ?? false) {
                          Get.snackbar(
                            'Success',
                            'Property activated successfully!',
                            snackPosition: SnackPosition.BOTTOM,
                          );


                        } else {
                          Get.snackbar(
                            'Error',
                            'Failed to activate property.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } catch (error) {
                        setState(() {
                          isLoading = false;
                        });
                        Get.snackbar(
                          'Error',
                          'You can not activate this property right now, you have to wait until accepted by admin',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        print(error);
                      }
                    },
                        child: Container(
                                          height: 20,
                                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Theme.of(context).primaryColor
                                          ),
                                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: isLoading
                            ?const CircularProgressIndicator()
                            :Text("activate", style: fontSmall.copyWith(color: Colors.grey)),
                                          ),
                                        ),
                      )
                      : InkWell(
                        onTap: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            ActivateModel activateModel = ActivateModel();
                            activateModel.isActive = false;
                            final response = await ownerPropertyRepository.activateProperty(
                              activateModel,
                              widget.id.toString(),
                              "token $token",
                            );

                            setState(() {
                              isLoading = false;
                            });
                            if (response.isActive ?? false) {
                              Get.snackbar(
                                'Error',
                                'Failed to activate property.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              Get.offAll(() => widget.refresh);
                            } else {
                              Get.snackbar(
                                'Success',
                                'Property unactivated successfully!',
                                snackPosition: SnackPosition.BOTTOM,
                              );



                            }
                          } catch (error) {
                            setState(() {
                              isLoading = false;
                            });
                            Get.snackbar(
                              'Error',
                              'An error occurred: $error',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            print(error);
                          }
                        },
                        child: Container(
                                          height: 20,
                                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.transparent
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 3),
                                            child: isLoading?const CircularProgressIndicator():Text("activated", style: fontSmall.copyWith(color: Colors.green)),
                                          ),
                                        ),
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
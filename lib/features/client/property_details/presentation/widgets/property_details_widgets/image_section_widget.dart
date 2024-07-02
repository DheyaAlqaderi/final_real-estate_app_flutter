
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/property_details/data/model/image_model.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/image_details.dart';

import '../../../../../../core/helper/local_data/shared_pref.dart';
import '../../../../../../core/utils/images.dart';
import '../../../../../auth/presentation/pages/both_auth_screen.dart';
import '../../../../add_favorite/repository/add_favorite_repository.dart';
import '../../../../favorite/data/repositories/network.dart';


class ImageSectionPropertyDetailsWidget extends StatefulWidget {
  final bool isFavorite;
  final List<ImageModel2>? imagesModel;
  final double rating;
  final String categoryName;
  final String ownerName;
  final String ownerImage;
  final int propertyId;

  const ImageSectionPropertyDetailsWidget({
    super.key,
    required this.isFavorite,
    required this.imagesModel,
    required this.rating,
    required this.categoryName, required this.ownerName, required this.ownerImage, required this.propertyId
  });

  @override
  State<ImageSectionPropertyDetailsWidget>
    createState() => _ImageSectionPropertyDetailsWidgetState();
}

class _ImageSectionPropertyDetailsWidgetState
    extends State<ImageSectionPropertyDetailsWidget> {

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
    _loadUserToken();
    favoriteRepository = FavoriteRepository(Dio());
    isSelected = widget.isFavorite;
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ImageDetails(images: widget.imagesModel,ownerName: widget.ownerName,ownerImage: widget.ownerImage,)));
      },
      child: SizedBox(
        height: 514.0,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.imagesModel != null && widget.imagesModel!.isNotEmpty && widget.imagesModel![0].image!.isNotEmpty
                        ? "${AppConstants.baseUrl3}${widget.imagesModel!.first.image}"
                        : AppConstants.noImageUrl,
                  ),
                  fit: BoxFit.cover
                ),

                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(50.0),
                    bottomLeft: Radius.circular(50.0)
                ),
              ),
            ),

            /// appBar Section
            _appBarSection(),

            /// rest of the images
            _restImagesSection(),

            Positioned(
              bottom: 53.0,
              right: 15.0,
              child: Row(
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: ShapeDecoration(
                      color: const Color(0xAF1F4C6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child:  Center(
                      child: Text(
                        widget.categoryName,
                        style: fontSmallBold.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 95,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: ShapeDecoration(
                      color: const Color(0xAF1F4C6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '⭐',
                          style: fontSmallBold.copyWith(color: Colors.white)
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${widget.rating}',
                          style: fontSmallBold.copyWith(color: Colors.white)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )



          ],
        ),

      ),
    );
    
  }

  Widget _appBarSection(){
    return Positioned(
      top: 5,
      right: 15.0,
      left: 15.0,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor, // Use shadowColor from the theme with opacity
                      spreadRadius: 2, // Spread radius of the shadow
                      blurRadius: 4, // Blur radius of the shadow
                      offset: const Offset(0, 2), // Offset of the shadow
                    ),
                  ],
                ),
                child: const Center(
                    child: Icon(Icons.arrow_back)
                ),
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    try {
                      if (token != " ") {
                        if (isSelected) {
                          // Perform delete favorite action
                          await favoriteRepository.deleteFavorite("token ${token!}", widget.propertyId);
                          Get.snackbar(
                            'Success',
                            'Favorite deleted successfully',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          // Perform add favorite action
                          await AddFavoriteRepository.addFavorite(widget.propertyId, token!);
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
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor, // Use shadowColor from the theme with opacity
                          spreadRadius: 2, // Spread radius of the shadow
                          blurRadius: 4, // Blur radius of the shadow
                          offset: const Offset(0, 2), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                          Images.heartIcon,
                          width: 22,
                          height: 22,
                          color: isSelected
                              ? Colors.red
                              : Colors.grey
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0,),
                InkWell(
                  onTap: (){},
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor, // Use shadowColor from the theme with opacity
                          spreadRadius: 2, // Spread radius of the shadow
                          blurRadius: 4, // Blur radius of the shadow
                          offset: const Offset(0, 2), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: const Center(
                        child: Icon(Icons.share)
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _restImagesSection(){
    return Positioned(
      bottom: 50.0,
      left: 15,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(
            // Generate only the first 3 items or less if the list is smaller
              widget.imagesModel!.length > 3 ? 3 : widget.imagesModel!.length,
                  (index) {
                final isLastImage = index == (widget.imagesModel!.length > 3 ? 3 : widget.imagesModel!.length) - 1;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6.0),
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .cardColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.6),
                                ],
                              ),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      "${AppConstants.baseUrl3}${widget
                                          .imagesModel![index].image}"),
                                  fit: BoxFit.cover
                              )
                          ),
                          child: (isLastImage) ? InkWell(
                            onTap: () {
                              // showBottomSheet(context);
                            },
                            child: Container(
                              height: 60.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.1),
                                    Colors.black.withOpacity(0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "+${widget.imagesModel!.length}",
                                  style: fontSmallBold.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ) : Container(),
                        )
                    ),
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}

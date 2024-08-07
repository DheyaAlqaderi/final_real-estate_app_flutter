import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/auth/presentation/pages/both_auth_screen.dart';
import 'package:smart_real_estate/features/client/add_reviews/presentation/pages/add_reviews.dart';
import 'package:smart_real_estate/features/client/property_details/data/model/image_model.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/property_details/property_details_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/reviews/reviews_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/profile_owner_screen.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/widgets/feature_image_details.dart';

import '../../../../../core/helper/local_data/shared_pref.dart';
import '../../../home/widgets/high_places_widget.dart';
import '../manager/property_details/property_details_state.dart';
import '../manager/reviews/reviews_state.dart';
import '../widgets/property_details_widgets/address_details_widget.dart';
import '../widgets/property_details_widgets/feature_attribute_widget.dart';
import '../widgets/property_details_widgets/image_section_widget.dart';
import '../widgets/property_details_widgets/property_details_description_widget.dart';
import '../widgets/property_details_widgets/property_review_rating_widget.dart';


class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({super.key, required this.id,required this.token});

  final int? id;
  final String? token;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {

  String? token;

  Future<void> getToken() async {
    final myToken = await SharedPrefManager.getData(AppConstants.token);

    setState(() {
      token = myToken ?? " ";
    });

    print("my toonn $token");
  }

  @override
  void initState() {
    super.initState();

    getToken();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final propertyDetails = context.read<PropertyDetailsCubit>();
      final getReviews = context.read<ReviewsPropertyCubit>();
      await Future.wait([
        propertyDetails.getPropertyDetails(widget.id!, widget.token!),
        getReviews.getReviewsProperty(widget.id!)
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
          builder: (context, state) {
            if (state is PropertyDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PropertyDetailsSuccess) {
              final propertyDetails = state.propertyDetails;
              final List<ImageModel2> imageList = state.propertyDetails.image!.map((imageModel) => ImageModel2(
                image: imageModel.image,
                id: imageModel.id,
              )).toList();


              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Display property image and some details
                  ImageSectionPropertyDetailsWidget(
                    isFavorite: propertyDetails.inFavorite ?? false,
                    imagesModel: imageList.isNotEmpty ? imageList : [], // Ensure non-null, non-empty list
                    rating: propertyDetails.rate ?? 0,
                    categoryName: propertyDetails.category?.name ?? "",
                    ownerName: propertyDetails.user?.name ?? "Unknown",
                    ownerImage: propertyDetails.user?.image != null && propertyDetails.user!.image!.isNotEmpty
                        ? "${AppConstants.baseUrl3}${propertyDetails.user!.image!}"
                        : "",
                    propertyId: propertyDetails.id!,
                  ),



                  /// Displaying property rest details
                  PropertyDetailsDescriptionWidget(
                    name: propertyDetails.name!,
                    description: propertyDetails.description!,
                    address: propertyDetails.address?.line1 ?? "", /// it should be fixed from Api
                    isForSale: propertyDetails.forSale!,
                    price: propertyDetails.price ?? " ",
                    date: propertyDetails.timeCreated!,
                  ),

                  /// Displaying property Features and Attribute
                  const SizedBox(height: 7.0,),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Size", style: fontMediumBold,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(propertyDetails.size.toString(), style: fontMedium,),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Attributes and Features", style: fontMediumBold,),
                  ),
                  const SizedBox(height: 10.0,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        propertyDetails.propertyValue!.length,
                            (index) {
                          var attribute = propertyDetails.propertyValue![index].value!;
                          var attributeValue = attribute.value!;

                          // Check if the value is a string and is not equal to "0"
                          if (attributeValue != "0") {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 7),
                              child: FeatureAttributeWidget(
                                attributeName: attribute.attribute!.name!,
                                attributeValue: attributeValue,
                              ),
                            );
                          } else {
                            // Always show the widget for non-string values or string values that are "0"
                            return const SizedBox();
                          }
                        },
                      ).where((widget) => widget is! SizedBox).toList(), // Filter out SizedBox widgets
                    ),
                  ),


                  const SizedBox(height: 5.0,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          propertyDetails.featureProperty!.length ,
                              (index) {
                            return HighPlacesWidget(
                              name: propertyDetails.featureProperty![index].feature!.name!,
                              image:propertyDetails.featureProperty![index].image!.isNotEmpty? "${propertyDetails.featureProperty![index].image!.first.image}":AppConstants.noImageUrl,
                              onTap: (){
                                var fName= propertyDetails.featureProperty![index].feature!.name!;
                                final List<ImageModel2> fImageList = state.propertyDetails.featureProperty![index].image!.map((imageModel) => ImageModel2(
                                  image: imageModel.image,
                                  // id: imageModel.id,
                                )).toList();
                                Get.to(()=>FeatureImageDetails(
                                  featureName: fName,
                                  images:fImageList,
                                ));
                              },

                            );
                          }
                      ),
                    ),
                  ),

                  /// display property promoter details
                  const SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfileOwnerScreen(userId: propertyDetails.user!.id!,))
                        );
                      },
                      child: Container(
                        height: 85.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 7.0,),
                                Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            propertyDetails.user!.image == null
                                                ? Images.userImageIfNull
                                                :"${AppConstants.baseUrl3}${propertyDetails.user!.image}"
                                            ),
                                        fit: BoxFit.cover,
                                      )
                                  ),
                                ),
                                const SizedBox(width: 7.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(propertyDetails.user!.name.toString(), style: fontMediumBold,),
                                    Text(propertyDetails.user!.userType.toString(), style: fontSmall,)
                                  ],
                                ),
                              ],
                            ),


                            Row(
                              children: [
                                SvgPicture.asset(Images.chatIcon),
                                const SizedBox(width: 7.0,),
                              ],
                            ),
                          ],
                        ),

                      ),
                    ),
                  ),

                  /// display GoogleMap and address details
                  const SizedBox(height: 10.0,),
                  AddressDetailsWidget(
                    addressLine: propertyDetails.address!,
                    // lat: propertyDetails.address.latitude!,
                  ),

                  /// display reviews and Rating
                  const SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Locales.string(context, "review"), style: fontMediumBold,),
                        InkWell(
                          onTap: (){

                              if (widget.token == " " || widget.token == null) {
                                _showLoginDialog(context);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddReview(propertyId: widget.id!.toInt(), token: widget.token!),
                                  ),
                                );
                              }


                          },
                          child: Container(
                            height: 29.0,
                            width: 29.0,
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(50.0)
                            ),
                            child: const Center(
                              child: Icon(Icons.add, size: 16,),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  BlocBuilder<ReviewsPropertyCubit, ReviewsPropertyState>(
                    builder: (context, state) {
                      if (state is ReviewsPropertyLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is ReviewsPropertyLoaded) {
                        if (state.reviewModel.results!.isEmpty) {
                          return const Center(
                            child: Text("No Reviews"),
                          );
                        } else {
                          if (kDebugMode) {
                            print("success");
                          }
                          return PropertyReviewAndRatingWidget(
                            rating: propertyDetails.rate!,
                            reviewModel: state.reviewModel,
                            propertyId: widget.id!,
                            token: widget.token!,
                            index: 0,
                            propertyDetails: propertyDetails,
                          );
                        }
                      } else if (state is ReviewsPropertyError) {
                        return Center(
                          child: Text(state.message),
                        );
                      } else {
                        return const SizedBox(); // Return an empty widget if state is not recognized
                      }
                    },
                  ),


                ],
              );
            } else if (state is PropertyDetailsError) {
              return Center(
                child: Text('Error: ${state.error}'),
              );
            } else {
              return const SizedBox(); // Return an empty widget if state is not recognized
            }
          },
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You need to be logged in to perform this action.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to the login page (replace with your login page)
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BothAuthScreen(isOwner: false)));
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

}
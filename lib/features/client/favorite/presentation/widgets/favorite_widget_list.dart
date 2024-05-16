import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/property_details_screen.dart';

import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/styles.dart';

class FavoriteListWidget extends StatefulWidget {
  const FavoriteListWidget({super.key, required this.imagePath, required this.title, required this.price, required this.address, required this.isFavorite, required this.rate, required this.onTapDelete, required this.id});
  final String imagePath;
  final String title;
  final String price;
  final String address;
  final bool isFavorite;
  final double rate;
  final VoidCallback onTapDelete;
  final int id;




  @override
  State<FavoriteListWidget> createState() => _FavoriteListWidgetState();
}

class _FavoriteListWidgetState extends State<FavoriteListWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> PropertyDetailsScreen(id:widget.id )));
      },
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,right: 8.0,bottom: 8.0),
                  child: Container(
                    height: double.infinity,
                    width: 226,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          // "http://192.168.0.117:8000${widget.imagePath}"
                            widget.imagePath == " "
                                ? AppConstants.noImageUrl
                                : "${AppConstants.baseUrl3}${widget.imagePath}"
                        ),
                        fit: BoxFit.cover,
                      ),
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
                            onTap: widget.onTapDelete,
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
                                  color: widget.isFavorite ? Colors.red : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0XFF234F68).withOpacity(0.8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(widget.price, style: fontMediumBold.copyWith(color: Colors.white)),
                            ),
                          ),
                        )


                        // Positioned(
                        //   bottom: 5,
                        //   right: 10.0,
                        //   child: Container(
                        //     height: 29.0,
                        //     width: 50.0,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       // color: widget.propertyModel.results![widget.index].forSale ?? false
                        //       //     ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                        //       //     : Theme.of(context).colorScheme.primary,
                        //     ),
                        //     child: Center(
                        //       child: Text(
                        //         widget.propertyModel.results![widget.index].forSale ?? false
                        //             ? Locales.string(context, "for_sale")
                        //             : Locales.string(context, "for_rent"),
                        //         style: fontSmall.copyWith(
                        //           color: widget.propertyModel.results![widget.index].forSale ?? false
                        //               ? Colors.white
                        //               : Theme.of(context).colorScheme.secondary,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),



                      ],
                    ),
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
                          widget.title,
                          style: fontMedium,
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
                                      widget.address,
                                      style: fontSmall.copyWith(color: Colors.grey),
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
                                      widget.address,
                                      style: fontSmall.copyWith(color: Colors.grey),
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
                                      widget.rate.toString(),
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
                                      widget.rate.toString(),
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
                               child:
                              // (!widget.propertyModel.results![widget.index].forSale!)
                              //     ?Text(
                              //   "${widget.price.toString()} الف /شهر",
                              //   style: fontSmallBold,
                              //   maxLines: 1,
                              //   textDirection: TextDirection.rtl,
                              //   overflow: TextOverflow.ellipsis,
                              // )
                              //     :
                              Text(
                                widget.price.toString(),
                                  style: fontMediumBold.copyWith(color: Colors.indigo),
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
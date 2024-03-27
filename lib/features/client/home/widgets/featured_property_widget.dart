import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';


class FeaturedPropertyWidget extends StatefulWidget {
  const FeaturedPropertyWidget({super.key});


  @override
  State<FeaturedPropertyWidget> createState() => _FeaturedPropertyWidgetState();
}

class _FeaturedPropertyWidgetState extends State<FeaturedPropertyWidget> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 156.0,
        width: 268.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // image
            Container(
              height: double.infinity,
              width: 126,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                      image: AssetImage(Images.onBoardingOne),
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
                      onTap: (){
                        setState(() {
                          isSelected ? isSelected=false : isSelected=true;
                        });
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

                  Locales.isDirectionRTL(context)
                      ? Positioned(
                          bottom: 5,
                          right: 10.0,
                          child: Container(
                            height: 29.0,
                            width: 41.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.800000011920929),
                            ),
                            child: const Center(
                              child: Text(
                                "للبيع",
                                style: fontSmall,
                              ),
                            ),
                          ),
                        )
                      : Positioned(
                          bottom: 5,
                          left: 10.0,
                          child: Container(
                            height: 29.0,
                            width: 41.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child:  Center(
                              child: Text(
                                "للأيجار",
                                style: fontSmall.copyWith(color: Theme.of(context).colorScheme.secondary),
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
                    child: const Text(
                        "شقق أبراج الأنسي",
                      style: fontSmallBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                    child: Locales.isDirectionRTL(context)
                        ? const Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 10,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                                  child: SizedBox(
                                    width: 120,
                                    child: Text(
                                      "شارع الخمسين خل بهارات ياسين",
                                      style: fontSmall,
                                      textDirection: TextDirection.rtl,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                            ]
                          )
                        : const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.0),
                                child: SizedBox(
                                  width: 120,
                                  child: Text(
                                    "شارع الخمسين خل بهارات ياسين",
                                    style: fontSmall,
                                    maxLines: 2,
                                    textDirection: TextDirection.rtl,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Icon(Icons.location_on_outlined, size: 10,),
                            ]
                        )
                  ),
                  Expanded(
                      child: Padding(
                        padding: Locales.isDirectionRTL(context)
                            ?const EdgeInsets.only(right: 15.0,top: 5.0, bottom: 5.0)
                            :const EdgeInsets.only(right: 15.0,top: 5.0, bottom: 5.0),
                        child: const Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "29000000 الف /كل شهر",
                              style: fontSmallBold,
                              maxLines: 1,
                              textDirection: TextDirection.rtl,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                      )
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

Widget featuredProperty(
    {
      required String name,
      required String image,
      dynamic price,
      required String address,
      required BuildContext context
    }
){
  bool isSelected = false;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 156.0,
      width: 268.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // image
          Container(
            height: double.infinity,
            width: 126,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black12,
              image: const DecorationImage(
                image: AssetImage(Images.onBoardingOne),
                fit: BoxFit.cover
              )
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  right: 10,
                  child: InkWell(
                    onTap: (){
                      isSelected = true;

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
                            child: SvgPicture.asset(Images.heartIcon, width: 15, height: 15, color: isSelected ? Colors.red : Colors.black12)
                          ),
                    ),
                  ),
                )
              ],
            ),

          ),
          // content
          Text("fjh"),

        ],
      ),
    ),
  );
}
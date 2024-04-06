import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/features/client/home/data/models/property/property_model.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/property_details_screen.dart';

import '../../../../../core/utils/styles.dart';
import '../../../home/widgets/stand_property_widget.dart';

class ProfileOwnerScreen extends StatefulWidget {
  const ProfileOwnerScreen({super.key});

  @override
  State<ProfileOwnerScreen> createState() => _ProfileOwnerScreenState();
}

class _ProfileOwnerScreenState extends State<ProfileOwnerScreen> {
  var state = PropertyModel.fromJson({
        "count": 2,
        "next": null,
        "previous": null,
        "results": [
          {
            "id": 1,
            "in_favorite": true,
            "image": [
              {
                "image": "/media/property-images/%D8%A7%D9%84%D9%81%D9%86%D8%A7%D8%AF%D9%82%D8%A7%D9%84%D9%85%D9%88%D8%AA%D9%8A%D9%84%D8%A7%D8%AA_4eV1i1f.jpg",
                "id": 1
              },
              {
                "image": "/media/property-images/%D8%A7%D9%84%D9%81%D9%86%D8%A7%D8%AF%D9%82%D8%A7%D9%84%D9%85%D9%88%D8%AA%D9%8A%D9%84%D8%A7%D8%AA_4eV1i1f.jpg",
                "id": 2
              }
            ],
            "name": "Beautiful House",
            "price": "500,000",
            "for_sale": true,
            "is_featured": true,
            "address": "123 Main St"
          },
          {
            "id": 2,
            "in_favorite": false,
            "image": [
              {
                "image": "/media/property-images/%D8%A7%D9%84%D9%81%D9%86%D8%A7%D8%AF%D9%82%D8%A7%D9%84%D9%85%D9%88%D8%AA%D9%8A%D9%84%D8%A7%D8%AA_4eV1i1f.jpg",
                "id": 3
              },
              {
                "image": "https://example.com/image4.jpg",
                "id": 4
              }
            ],
            "name": "Cozy Apartment",
            "price": "300,000",
            "for_sale": true,
            "is_featured": false,
            "address": "456 Elm St"
          },
          {
            "id": 4,
            "in_favorite": true,
            "image": [
              {
                "image": "/media/property-images/%D8%A7%D9%84%D9%81%D9%86%D8%A7%D8%AF%D9%82%D8%A7%D9%84%D9%85%D9%88%D8%AA%D9%8A%D9%84%D8%A7%D8%AA_4eV1i1f.jpg",
                "id": 1
              },
              {
                "image": "https://example.com/image2.jpg",
                "id": 2
              }
            ],
            "name": "Beautiful House",
            "price": "500,000",
            "for_sale": true,
            "is_featured": true,
            "address": "123 Main St"
          },
          {
            "id": 3,
            "in_favorite": false,
            "image": [
              {
                "image": "/media/property-images/%D8%A7%D9%84%D9%81%D9%86%D8%A7%D8%AF%D9%82%D8%A7%D9%84%D9%85%D9%88%D8%AA%D9%8A%D9%84%D8%A7%D8%AA_4eV1i1f.jpg",
                "id": 3
              },
              {
                "image": "https://example.com/image4.jpg",
                "id": 4
              }
            ],
            "name": "Cozy Apartment",
            "price": "300,000",
            "for_sale": true,
            "is_featured": false,
            "address": "456 Elm St"
          }
        ]
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 85.0,
                  width: double.infinity,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Theme.of(context).cardColor,
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.arrow_back_ios_new_outlined, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 100.0),
                      Text(Locales.string(context, "personal_profile"), style: fontMediumBold),
                    ],
                  ),
                ),
              ),
              
              /// image Section and details
              Column(
                children: [
                  const Text("القادري", style: fontMediumBold,),
                  const Text("diaa.alqadrei@gmail.com", style: fontSmall,),
                  const SizedBox(height: 5.0,),
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: Stack(
                      children: [
                        Container(
                          height: 95,
                          width: 95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            image: const DecorationImage(
                              image: AssetImage(Images.onBoardingOne),
                              fit: BoxFit.cover
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 8.0,
                          child: Container(
                            height: 25.0,
                            width: 25.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Theme.of(context).primaryColor
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 70.0,
                          width: (MediaQuery.of(context).size.width/3) - 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("112", style: fontMediumBold,),
                              Text(
                                  Locales.string(context, "sold"),
                                  style: fontSmallBold
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 7.0,),
                        Container(
                          height: 70.0,
                          width: (MediaQuery.of(context).size.width/3) - 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("235", style: fontMediumBold,),
                              Text(
                                  Locales.string(context, "review"),
                                  style: fontSmallBold
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 7.0,),
                        Container(
                          height: 70.0,
                          width: (MediaQuery.of(context).size.width/3) - 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("4.0", style: fontMediumBold,),
                              Text(
                                  "⭐ ⭐ ⭐ ⭐ ⭐",
                                  style: fontSmallBold
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 50.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Row(
                    children: [
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 25.0)),
                      SvgPicture.asset(Images.phoneIcon),
                      const Spacer(flex: 1,),
                      SvgPicture.asset(Images.chatIcon),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 25.0)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20.0,),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("140 من القوائم", style: fontMediumBold,)
                  ],
                ),
              ),

              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 30.0,
                runSpacing: 10.0,
                children: List.generate(
                  state.results!.length,
                      (index) => StandPropertyWidget(
                    index: index,
                    propertyModel: state,
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PropertyDetailsScreen(id: state.results![index].id))
                      );
                    },
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

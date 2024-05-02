

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/favorite/presentation/widgets/favorite_appbar.dart';
import 'package:smart_real_estate/features/client/favorite/presentation/widgets/favorite_widget_temp.dart';
import 'package:smart_real_estate/features/client/home/widgets/featured_property_widget.dart';

import '../../../home/data/models/property/property_model.dart';
import '../../data/models/favorite_model.dart';
import '../../data/repositories/network.dart';



class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});




  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final int list=6;

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


  PropertyModel propertyModel = PropertyModel(
    count: 1,
    next: null,
    previous: null,
    results: [
      // PropertyResult(
      //   id: 1,
      //   rate: 4.5,
      //   inFavorite: true,
      //   image: [
      //     PropertyImage(image: 'image1.jpg', id: 1),
      //     PropertyImage(image: 'image2.jpg', id: 2),
      //   ],
      //   name: 'Property 1',
      //   description: 'Description 1',
      //   price: '\$500,000',
      //   size: 2000,
      //   isActive: true,
      //   isDeleted: false,
      //   timeCreated: '2024-04-01',
      //   uniqueNumber: 'ABC123',
      //   forSale: true,
      //   isFeatured: true,
      //   user: 1,
      //   category: 1,
      //   address: '123 Main St',
      // ),
      // PropertyResult(
      //   id: 1,
      //   rate: 4.5,
      //   inFavorite: true,
      //   image: [
      //     PropertyImage(image: 'image1.jpg', id: 1),
      //     PropertyImage(image: 'image2.jpg', id: 2),
      //   ],
      //   name: 'Property 1',
      //   description: 'Description 1',
      //   price: '\$500,000',
      //   size: 2000,
      //   isActive: true,
      //   isDeleted: false,
      //   timeCreated: '2024-04-01',
      //   uniqueNumber: 'ABC123',
      //   forSale: true,
      //   isFeatured: true,
      //   user: 1,
      //   category: 1,
      //   address: '123 Main St',
      // ),
      // PropertyResult(
      //   id: 1,
      //   rate: 4.5,
      //   inFavorite: true,
      //   image: [
      //     PropertyImage(image: 'image1.jpg', id: 1),
      //     PropertyImage(image: 'image2.jpg', id: 2),
      //   ],
      //   name: 'Property 1',
      //   description: 'Description 1',
      //   price: '\$500,000',
      //   size: 2000,
      //   isActive: true,
      //   isDeleted: false,
      //   timeCreated: '2024-04-01',
      //   uniqueNumber: 'ABC123',
      //   forSale: true,
      //   isFeatured: true,
      //   user: 1,
      //   category: 1,
      //   address: '123 Main St',
      // ),
      PropertyResult(
        id: 1,
        rate: 4.5,
        inFavorite: true,
        image: [
          PropertyImage(image: 'image1.jpg', id: 1),
          PropertyImage(image: 'image2.jpg', id: 2),
        ],
        name: 'Property 1',
        description: 'Description 1',
        price: '\$500,000',
        size: 2000,
        isActive: true,
        isDeleted: false,
        timeCreated: '2024-04-01',
        uniqueNumber: 'ABC123',
        forSale: true,
        isFeatured: true,
        user: 1,
        category: 1,
        address: '123 Main St',
      ),
    ],
  );






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
                future: NetworkRequest.fetchPhotos(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    var data = snapshot.data!.results;
                  // return GridView.builder(
                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2,
                  //     childAspectRatio: 1,
                  //     mainAxisSpacing: 4,
                  //     crossAxisSpacing: 4,
                  //   ),
                  //   itemCount: list,
                  //   itemBuilder: (context, index) {
                  //     return const Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 8.0),
                  //       // child: FavoriteProperty(
                  //       //   imageUrl: data[index].prop!.image!.first.image!,
                  //       // ),
                  //     );
                  //
                  //   },
                  // );


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
                        ),
                      );
                    },
                  )
                      : ListView.builder(

                      itemCount: propertyModel.results!.length,
                      itemBuilder: (context, index) {
                        return FeaturedPropertyWidget(
                            propertyModel: propertyModel,
                            index: index,
                            onTap: () {});
                      });
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


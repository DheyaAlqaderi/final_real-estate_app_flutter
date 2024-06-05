import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retrofit/retrofit.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/property_details_screen.dart';

import '../../../../../core/utils/images.dart';

class ImageDetails extends StatefulWidget {
  const ImageDetails({super.key});

  @override
  State<ImageDetails> createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> {
  final List<String> images = [
    'https://as1.ftcdn.net/v2/jpg/05/04/28/96/1000_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
    'https://as1.ftcdn.net/v2/jpg/05/04/28/96/1000_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
    'https://m.media-amazon.com/images/M/MV5BYmIxMGNmOGYtMDQ4ZS00N2M0LWFiNWMtMWVlYjVkNzkzODc4XkEyXkFqcGc@._V1_QL75_UY414_CR26,0,280,414_.jpg',
    'https://as1.ftcdn.net/v2/jpg/05/04/28/96/1000_F_504289605_zehJiK0tCuZLP2MdfFBpcJdOVxKLnXg1.jpg',
  ];
  String? lang;

@override
  void initState() {
    super.initState();
    // lang = Locales.
  }



  //final List<File> images=[];
  int _currentIndex = 0;
  final PageController _pageController = PageController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

    body: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),

                 Locales.isDirectionRTL(context)
                     ?Positioned(
                      right: 20,
                      top: 45,
                      child: IconButton(
                        style: IconButton.styleFrom(fixedSize: const Size(50, 50),
                        backgroundColor:Theme.of(context).cardColor  ),
                        icon:Icon(Icons.arrow_back_ios_new,),
                        onPressed: () {
                          //Get.to(PropertyDetailsScreen());
                        },
                  )): Positioned(
                     left: 20,
                     top: 45,
                     child: IconButton(
                       style: IconButton.styleFrom(fixedSize: const Size(50, 50),
                           backgroundColor:Theme.of(context).cardColor  ),
                       icon:Icon(Icons.arrow_forward_ios),
                       onPressed: () {
                         //Get.to(PropertyDetailsScreen());
                       },
                     )),
                  Positioned(
                     left: 0,
                    child: IconButton(
                      // style: IconButton.styleFrom(backgroundColor: Theme.of(context).cardColor),
                      icon: SvgPicture.asset(Images.leftArrow ),
                      onPressed: () {
                        if (_currentIndex > 0) {
                          _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                        }
                      },
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      // style: IconButton.styleFrom(backgroundColor: Theme.of(context).cardColor),
                      icon: SvgPicture.asset(Images.rightArrow),
                      onPressed: () {
                        if (_currentIndex < images.length - 1) {
                          _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                        }
                      },
                    ),
                  ),
                  Locales.isDirectionRTL(context)
                  ?Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      width: 200,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('حمزة محمد حمزة القطاع',style: fontMediumBold,maxLines: 1,overflow: TextOverflow.ellipsis,),
                              Row(
                                children: List.generate(5, (index) => Icon(Icons.star, color: Colors.orange, size: 16)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ):Positioned(
                    bottom: 20,
                    left: 20,
                    child:Container(
                    width: 200,
                    padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Align content to the end of the row
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end, // Align content to the end of the column
                            children: [
                              const Text(
                                'Alilkjhgffghjklhjlhjkljk Ali',
                                style: fontMediumBold,
                                overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                                maxLines: 1, // Set maximum lines for text
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(5,
                                      (index) => const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://via.placeholder.com/150',
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),

                  Locales.isDirectionRTL(context)?
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                    width: 80,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.transparent,
                    ),

                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _currentIndex == index ? Colors.blue : Colors.transparent,
                                width: 2,

                              ),
                              borderRadius: BorderRadius.circular(100)

                            ),
                            child: Image.network(
                              images[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),):Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      width: 80,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.transparent,
                      ),

                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _currentIndex == index ? Colors.blue : Colors.transparent,
                                    width: 2,

                                  ),
                                  borderRadius: BorderRadius.circular(100)

                              ),
                              child: Image.network(
                                images[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),)
                ],
              ),

    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

import '../../../../../core/utils/images.dart';
import '../../data/model/image_model.dart';

class ImageDetails extends StatefulWidget {
  const ImageDetails({super.key, required this.images, required this.ownerName, required this.ownerImage});
  final  List<ImageModel2>? images;
  final String ownerName;
  final String ownerImage;

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
                    itemCount: widget.images!.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        "${AppConstants.baseUrl3}${widget.images![index].image!}",
                        fit: BoxFit.contain,
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
                        icon:const Icon(Icons.arrow_back_ios_new,),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                  )): Positioned(
                     left: 20,
                     top: 45,
                     child: IconButton(
                       style: IconButton.styleFrom(fixedSize: const Size(50, 50),
                           backgroundColor:Theme.of(context).cardColor  ),
                       icon:const Icon(Icons.arrow_forward_ios),
                       onPressed: () {
                         Navigator.pop(context);
                       },
                     )),
                  Positioned(
                     left: 0,
                    child: IconButton(
                      // style: IconButton.styleFrom(backgroundColor: Theme.of(context).cardColor),
                      icon: SvgPicture.asset(Images.leftArrow ),
                      onPressed: () {
                        if (_currentIndex > 0) {
                          _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
                        if (_currentIndex < widget.images!.length - 1) {
                          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.ownerImage),
                          onBackgroundImageError: (exception, stackTrace) {
                            // Handle the error, for example, by using a fallback image
                            print('Failed to load image: $exception');
                          },
                          backgroundColor: Colors.transparent, // Optional: set a background color
                          child: widget.ownerImage.isEmpty
                              ? const Icon(Icons.person) // Optional: show an icon if there's no image
                              : null,
                        ),

                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.ownerName,style: fontMediumBold,maxLines: 1,overflow: TextOverflow.ellipsis,),
                              Row(
                                children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.orange, size: 16)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
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
                              Text(
                                widget.ownerName,
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
                          backgroundImage: NetworkImage(widget.ownerImage),
                          onBackgroundImageError: (exception, stackTrace) {
                            // Handle the error, for example, by using a fallback image
                            print('Failed to load image: $exception');
                          },
                          backgroundColor: Colors.transparent, // Optional: set a background color
                          child: widget.ownerImage.isEmpty
                              ? const Icon(Icons.person) // Optional: show an icon if there's no image
                              : null,
                        )

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
                      itemCount: widget.images!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _currentIndex == index ? Colors.blue : Colors.transparent,
                                width: 2,

                              ),
                              borderRadius: BorderRadius.circular(100)

                            ),
                            child: Image.network(
                              "${AppConstants.baseUrl3}${widget.images![index].image!}",
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
                        itemCount: widget.images!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _currentIndex == index ? Colors.blue : Colors.transparent,
                                    width: 2,

                                  ),
                                  borderRadius: BorderRadius.circular(100)

                              ),
                              child: Image.network(
                                "${AppConstants.baseUrl3}${widget.images![index].image!}",
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

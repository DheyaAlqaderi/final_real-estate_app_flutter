import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../data/models/banner/banner_model.dart';

class BannerSectionWidget extends StatefulWidget {
  const BannerSectionWidget({super.key, required this.bannerList, required this.onTapBanner});
  final List<BannerModel> bannerList;
  final Function(int) onTapBanner;

  @override
  State<BannerSectionWidget> createState() => _BannerSectionWidgetState();
}

class _BannerSectionWidgetState extends State<BannerSectionWidget> {
  final controller = CarouselController();

  void animateToSlide(int index) => controller.animateToPage(index);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          CarouselSlider.builder(
            carouselController: controller,
            itemCount: widget.bannerList.length,
            itemBuilder: (context, index, realIndex) {
              return promotionWidget(
                widget.bannerList[index].imageUrl,
                widget.bannerList[index].title,
                widget.bannerList[index].description,
                index,
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              enableInfiniteScroll: false,
              autoPlayAnimationDuration: const Duration(seconds: 2),
              enlargeCenterPage: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget promotionWidget(String image, String title, String description,
      int index) {
    return Container(
      width: 310.0,
      height: 180,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: InkWell(
        onTap: () {
          widget.onTapBanner(index);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                width: 93,
                height: 56,
                child: ElevatedButton(
                    onPressed: () {
                      widget.onTapBanner(index);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF234F68), // Text color
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10)
                        ), // Corner radius
                      ),
                    ),
                    child: const Icon(Icons.arrow_forward)
                ),
              ),
            ),

            Positioned(
              top: 55,
              right: 33,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: 0.54,
                ),
              ),
            ),

            Positioned(
              top: 105,
              right: 9,
              child: Text(
                description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

import '../../../../../core/utils/images.dart';
import '../../data/model/image_model.dart';

class FeatureImageDetails extends StatefulWidget {
  const FeatureImageDetails({super.key,required this.featureName, required this.images});
  final  List<ImageModel2>? images;
  final String featureName;
  @override
  State<FeatureImageDetails> createState() => _FeatureImageDetailsState();
}

class _FeatureImageDetailsState extends State<FeatureImageDetails> {

  @override
  void initState() {
    super.initState();

  }



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

          Center(

              child: Container(
                height: 40,

                // alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).cardColor
                ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.featureName,style: fontMediumBold,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                  )
              )
          )




        ],
      ),

    );
  }
}

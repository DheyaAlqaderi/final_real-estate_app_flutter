import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/welcome/pages/welcome_select_screen.dart';

import '../../../../core/utils/images.dart';
import '../domain/models/onBoarding_model.dart';
import '../widgets/appBar_onBoarding_widget.dart';


class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
   late List<OnBoardingModel> onBoardingList;
   late PageController _controller;
   int _currentPage = 0;

   @override
  void initState() {
     _controller = PageController(initialPage: 0);
    super.initState();
  }

   @override
   void dispose() {
     _controller.dispose();
     super.dispose();
   }


   @override
   void didChangeDependencies() {
     super.didChangeDependencies();
     onBoardingList = [
       OnBoardingModel(
           Images.onBoardingOne,
           Locales.string(context, "on_boarding_title_1"),
           Locales.string(context, "on_boarding_desc_1")),
       OnBoardingModel(
           Images.onBoardingTwo,
           Locales.string(context, "on_boarding_title_2"),
           Locales.string(context, "on_boarding_desc_2")),
       OnBoardingModel(
           Images.onBoardingThree,
           Locales.string(context, "on_boarding_title_3"),
           Locales.string(context, "on_boarding_desc_3")),
     ];
   }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 40,),
                const AppBarOnBoardingWidget(),

                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: onBoardingList.length,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (_, i) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              onBoardingList[i].title,
                              style: fontLargeBold
                            ),
                            const SizedBox(height: 10),
                            Text(
                              onBoardingList[i].description,
                              style: fontMedium
                            ),
                            const SizedBox(height: 40),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Image.asset(
                                  onBoardingList[i].imageUrl,
                                  fit: BoxFit.fill,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Positioned(
              top: 255, // Adjust the bottom margin as needed
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onBoardingList.length,
                          (index) => buildDot(index, context),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 20.0, // Adjust the bottom margin as needed
              left: 0,
              right: 0,
              child: Center(
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.all(40),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == onBoardingList.length - 1) {
                          // Handle the action when on the last page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WelcomeSelectScreen()),
                          );
                        } else {
                          // Move to the next page
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.bounceIn,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: const Color(0xFF1F4C6B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        _currentPage == onBoardingList.length - 1
                            ? Locales.string(context, "continue")
                            : Locales.string(context, "next"),
                        textAlign: TextAlign.center,
                        style: fontMediumBold
                      ),
                    ),
                  )
              ),
            ),
          ],
        ),
      );
    }

    Container buildDot(int index, BuildContext context) {
      return Container(
        height: 6,
        width: _currentPage == index ? 12 : 6,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF252B5C),
        ),
      );
    }
}

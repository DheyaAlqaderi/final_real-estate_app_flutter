import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/features/client/home/pages/home_screen.dart';
import 'package:smart_real_estate/features/client/search/presentation/widgets/search_appbar.dart';

import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/styles.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
   final int list=0;


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



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBarSearch(
          onPressed: (){
            const SizedBox(height: 50,);
          },
          onTapBack: (){
            Get.to(const HomeScreen());
          }),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  hintText:Locales.string(context, "search_here"),
                  contentPadding: const EdgeInsets.symmetric(vertical: 35, horizontal: 8), // Adjust the vertical padding as needed
                ),
            ),

          const SizedBox(height: 20,),
          Column(
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
                        Text(Locales.string(context, "have"),style: fontLarge,),
                        Text("$list ", style: fontMediumBold,),
                        Text(Locales.string(context, 'favorite_list'),
                          style: fontLarge,)
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
                          color: Theme
                              .of(context)
                              .cardColor
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
                                  color: isDesign1 ? Colors.white : Colors
                                      .transparent,
                                ),

                                child: Center(child: SvgPicture.asset(
                                  Images.listIcon,
                                  color: isDesign1 ? null : Colors.grey,)),
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
                                    color: isDesign1
                                        ? Colors.transparent
                                        : Colors.white,
                                  ),
                                  child: Center(child: SvgPicture.asset(
                                    Images.grideIcon, fit: BoxFit.contain,
                                    color: isDesign1 ? null : Colors.blue,)),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30,),


            Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  // onTap: (){
                  //   ////
                  //   print("ooooooo");
                  // },
                  child: SvgPicture.asset(Images.notFound,
                    width: 142,
                    height: 142,
                  ),
                ),
                const SizedBox(height: 16),
                Text(Locales.string(context,
                    "dont_found_search"),
                  style: fontLargeBold,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(Locales.string(context,
                      "dont_found_search1"),
                    style: fontMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
          )
      ]
        )),

    );
  }
}

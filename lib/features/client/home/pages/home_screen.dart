import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

import '../widgets/appBar_home_widget.dart';
import '../widgets/chip_widget_home.dart';
import '../widgets/search_filter_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? clickedChip;
  List<String> realEstateProperties = [
    'All',
    'Condominium',
    'Townhouse',
    'Apartment',
    'Duplex',
    'Triplex',
    'Fourplex',
    'Vacant Land',
    'Commercial Property',
    'Industrial Property',
    'Retail Space',
    'Office Space',
  ];

  late List<bool> chipSelected = List.generate(realEstateProperties.length, (index) => false);

  @override
  void initState() {
    super.initState();

    // Click the first chip automatically
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        chipSelected[0] = true;
      });
      clickedChip = realEstateProperties[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(Images.halfCircle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    SafeArea(
                      child: Column(
                        children: [

                          /// 1. app bar section
                          AppBarHomeWidget(
                            image: Images.mePicture,
                            onAvatarTap:(){
                              print("avatar");
                              setState(() {
                                Locales.change(context, "en");
                              });
                            },
                            onBillTap: (){
                              print("bill");
                            }
                          ),


                          /// 2. greeting Section
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Locales.string(context, "welcome_home"),
                                  style: fontLargeBold,
                                ),
                                const SizedBox(),
                              ],
                            ),
                          ),


                          /// 3. search bar and filter
                          const SizedBox(height: 20,),
                          SearchFilterWidget(
                            onFilterBarTap: (){
                              print("filter");
                              Locales.change(context, "ar");
                            },
                            onSearchBarTap: (){
                              print("search");
                              Locales.change(context, "en");
                            },
                          ),

                          /// 1. main categories Row list
                          const SizedBox(height: 20,),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                realEstateProperties.length,
                                    (index) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ChipWidgetHome(
                                    chipSelected: chipSelected,
                                    onChipClick: () {
                                      setState(() {
                                        // Deselect all chips
                                        chipSelected = List.filled(chipSelected.length, false);
                                        // Select the clicked chip
                                        chipSelected[index] = true;
                                        clickedChip = realEstateProperties[index].toString();
                                      });
                                    },
                                    realEstateProperties: realEstateProperties,
                                    index: index,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          /// 2. home page sections based on main category
                          const SizedBox(height: 20,),
                          Text(clickedChip.toString()),

                        ],
                      ),
                    ),
                  ]
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
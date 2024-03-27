
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/home/widgets/subcategory_section_widget.dart';
import '../data/models/banner/banner_model.dart';
import '../data/models/category/category_model.dart';
import '../widgets/appBar_home_widget.dart';
import '../widgets/banner_section_widget.dart';
import '../widgets/chip_widget_home.dart';
import '../widgets/featured_property_widget.dart';
import '../widgets/search_filter_widget.dart';
import '../widgets/stand_property_widget.dart';
import '../widgets/title_section_widget.dart';

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
  late List<BannerModel> bannerList;
  late List<CategoryModel> categoryList;

  @override
  void initState() {
    super.initState();
    // categoryList = [
    //   CategoryModel(
    //     categoryId: 1,
    //     imageUrl: propertyImageList[1],
    //     name: 'Category 1',
    //     parentId: 0,
    //   ),
    //   CategoryModel(
    //     categoryId: 2,
    //     imageUrl: propertyImageList[2],
    //     name: 'Category 2',
    //     parentId: 0,
    //   ),
    //   CategoryModel(
    //     categoryId: 1,
    //     imageUrl: propertyImageList[3],
    //     name: 'Category 1',
    //     parentId: 0,
    //   ),
    //   CategoryModel(
    //     categoryId: 2,
    //     imageUrl: propertyImageList[4],
    //     name: 'Category 2',
    //     parentId: 0,
    //   ),
    //   CategoryModel(
    //     categoryId: 1,
    //     imageUrl: propertyImageList[5],
    //     name: 'Category 1',
    //     parentId: 0,
    //   ),
    //   CategoryModel(
    //     categoryId: 2,
    //     imageUrl: propertyImageList[6],
    //     name: 'Category 2',
    //     parentId: 0,
    //   ),
    //   CategoryModel(
    //     categoryId: 1,
    //     imageUrl: propertyImageList[0],
    //     name: 'Category 1',
    //     parentId: 0,
    //   ),
    //   // Add more category objects as needed
    // ];

    bannerList = [
      BannerModel(
        bannerId: 1,
        imageUrl: propertyImageList[0],
        title: propertyTitleList[0],
        description: 'Description for banner 1',
      ),
      BannerModel(
        bannerId: 2,
        imageUrl: propertyImageList[1],
        title: propertyTitleList[1],
        description: 'Description for banner 2',
      ),
      BannerModel(
        bannerId: 3,
        imageUrl: propertyImageList[2],
        title: propertyTitleList[2],
        description: 'Description for banner 1',
      ),
      BannerModel(
        bannerId: 4,
        imageUrl: propertyImageList[3],
        title: propertyTitleList[3],
        description: 'Description for banner 2',
      ),
      BannerModel(
        bannerId: 5,
        imageUrl: propertyImageList[4],
        title: propertyTitleList[4],
        description: 'Description for banner 1',
      ),
      BannerModel(
        bannerId: 6,
        imageUrl: propertyImageList[5],
        title: propertyTitleList[5],
        description: 'Description for banner 2',
      ),
      BannerModel(
        bannerId: 7,
        imageUrl: propertyImageList[6],
        title: propertyTitleList[6],
        description: 'Description for banner 1',
      ),
    ];
    // Click the first chip automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 2));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    SafeArea(
                      child: Column(
                        children: [

                          /// 1. app bar section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: AppBarHomeWidget(
                              image: Images.mePicture,
                              onAvatarTap:(){
                                // print("avatar");
                                setState(() {
                                  Locales.change(context, "en");
                                });
                              },
                              onBillTap: (){
                                // print("bill");
                              }
                            ),
                          ),


                          /// 2. greeting Section
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13.0),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: SearchFilterWidget(
                              onFilterBarTap: (){
                                // print("filter");
                                Locales.change(context, "ar");
                              },
                              onSearchBarTap: (){
                                // print("search");
                                Locales.change(context, "en");
                              },
                            ),
                          ),

                          /// 1. main categories Row list
                          const SizedBox(height: 20,),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                realEstateProperties.length,
                                    (index) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
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
                          const SizedBox(height: 25,),
                          BannerSectionWidget(
                              bannerList: bannerList,
                              onTapBanner: (index) {
                                print(bannerList[index].bannerId);
                              }
                          ),

                          /// 3. subcategories section
                          const SizedBox(height: 15,),
                          TitleSectionWidget(
                              titleSection: Locales.string(context, "property_types"),
                              titleButton: Locales.string(context, "show_all"),
                              tap: (){
                                print("hello");
                              }
                          ),
                          // SubcategoryWidget(
                          //     categoryList: categoryList,
                          //     onTap:(index){
                          //       print(categoryList[index].imageUrl);
                          //     }
                          // ),

                          /// 4. featured properties
                          const SizedBox(height: 15,),
                          TitleSectionWidget(
                              titleSection: Locales.string(context, "featured_property"),
                              titleButton: Locales.string(context, "show_all"),
                              tap: (){
                                print("hello");
                              }
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                4,
                                    (index) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                    child: FeaturedPropertyWidget()
                                ),
                              ),
                            ),
                          ),

                          /// 5. top real-estate agents
                          const SizedBox(height: 15,),
                          TitleSectionWidget(
                              titleSection: Locales.string(context, "top_agent"),
                              titleButton: Locales.string(context, "show_all"),
                              tap: (){
                                print("hello");
                              }
                          ),
                          // SubcategoryWidget(
                          //     categoryList: categoryList,
                          //     onTap:(index){
                          //       print(categoryList[index].imageUrl);
                          //     }
                          // ),


                          /// 6. discover near properties
                          const SizedBox(height: 10,),
                          TitleSectionWidget(
                              titleSection: Locales.string(context, "discover_property"),
                              titleButton: Locales.string(context, "show_all"),
                              tap: (){
                                print("hello");
                              }
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 30.0,
                            runSpacing: 10.0,
                            children: List.generate(
                              16,
                                  (index) => StandPropertyWidget()
                            ),
                          )


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
  List<String> propertyTitleList = [
    "البرج المثالي",
    "two",
    "three",
    'four',
    'five',
    'six',
    'seven',
  ];
  List<String> propertyImageList = [
    Images.onBoardingOne,
    Images.onBoardingOne,
    Images.onBoardingOne,
    Images.onBoardingOne,
    Images.onBoardingOne,
    Images.onBoardingOne,
    Images.onBoardingOne,
  ];
}
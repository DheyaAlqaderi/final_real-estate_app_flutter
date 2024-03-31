
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/category_property/pages/category_property_screen.dart';
import 'package:smart_real_estate/features/client/high_places/pages/all_high_places_screen.dart';
import 'package:smart_real_estate/features/client/high_places/pages/high_state_screen.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/banners/banners_cubit.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/banners/banners_state.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/featured_property/featured_cubit.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/featured_property/featured_state.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/high_state/high_state_cubit.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/high_state/high_state_state.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/main_category/main_category_cubit.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/main_category/main_category_state.dart';
import 'package:smart_real_estate/features/client/home/widgets/subcategory_section_widget.dart';
import '../../category_property/domain/manager/property_cubit/property_cubit.dart';
import '../../category_property/domain/manager/property_cubit/property_state.dart';
import '../domain/manager/main_category/subCategory/subCategory_cubit.dart';
import '../domain/manager/main_category/subCategory/subCategory_state.dart';
import '../widgets/appBar_home_widget.dart';
import '../widgets/banner_section_widget.dart';
import '../widgets/chip_widget_home.dart';
import '../widgets/error_widget.dart';
import '../widgets/featured_property_widget.dart';
import '../widgets/high_places_widget.dart';
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
  late List<bool> chipSelected;
  late List<bool> defaultChipSelected;
  late int categoryId;

  @override
  void initState() {
    super.initState();
    chipSelected = List.generate(10, (index) => false);
    defaultChipSelected = List.generate(1, (index) => false);
    setState(() {
      categoryId = 0;
      defaultChipSelected[0] = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() async{
    final mainCategory = context.read<MainCategoryCubit>();
    final subCategory = context.read<SubCategoryCubit>();
    final banners = context.read<BannersCubit>();
    final highStateCubit = context.read<HighStateCubit>();
    final featureCubit = context.read<FeaturedCubit>();
    final getPropertyCubit = context.read<PropertyCubit>();


      await Future.wait([
        mainCategory.getMainCategory(),
        subCategory.getSubCategory(parentId: categoryId),
        banners.getBanners(),
        highStateCubit.getHighStates(),
        featureCubit.getFeatured(),
        getPropertyCubit.getPropertyByAllCategory()
      ]);


  }
  void _fetchDataRefresh() async{
    final mainCategory = context.read<MainCategoryCubit>();
    final banners = context.read<BannersCubit>();
    final subCategoryCubit = context.read<SubCategoryCubit>();
    final highStateCubit = context.read<HighStateCubit>();
    final featureCubit = context.read<FeaturedCubit>();
    final getPropertyCubit = context.read<PropertyCubit>();

    if(categoryId == 0){
      await Future.wait([
        mainCategory.getMainCategory(),
        banners.getBanners(),
        highStateCubit.getHighStates(),
        featureCubit.getFeatured(),
        getPropertyCubit.getPropertyByAllCategory()
      ]);
    }else{
      await Future.wait([
        mainCategory.getMainCategory(),
        banners.getBannersWithCategory(categoryId: categoryId),
        subCategoryCubit.getSubCategory(parentId: categoryId),
        highStateCubit.getHighStates(),
        featureCubit.getFeaturedWithCategory(categoryId: categoryId),
        getPropertyCubit.getPropertyByMainCategory(mainCategory: categoryId)

      ]);
    }


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
                _fetchDataRefresh();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildAppBarSection(),
                      const SizedBox(height: 20,),
                      _buildGreetingSection(),
                      const SizedBox(height: 20,),
                      _buildSearchBarAndFilter(),
                      const SizedBox(height: 20,),
                      _buildMainCategoriesRowList(),
                      const SizedBox(height: 25,),
                      _buildHomePageSectionsBanners(),
                      _buildHomePageSectionsSubCategories(),
                      _buildFeaturedProperties(),
                      const SizedBox(height: 15,),
                      _buildHighPlaces(),
                      const SizedBox(height: 15,),
                      _buildTopRealEstateAgents(),
                      const SizedBox(height: 15,),
                      _buildDiscoverNearProperties(),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAppBarSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: AppBarHomeWidget(
        image: Images.mePicture,
        onAvatarTap: () {
          setState(() {
            Locales.change(context, "en");
          });
        },
        onBillTap: () {
          // Handle bill tap
        },
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Padding(
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
    );
  }

  Widget _buildSearchBarAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SearchFilterWidget(
        onFilterBarTap: () {
          Locales.change(context, "ar");
        },
        onSearchBarTap: () {
          Locales.change(context, "en");
        },
      ),
    );
  }

  Widget _buildMainCategoriesRowList() {
    return BlocBuilder<MainCategoryCubit, MainCategoryState>(
      builder: (context, state) {
        if (state is LoadingMainCategoryState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3 * 2, // Number of containers and SizedBox widgets multiplied by 2 (since there will be 10 width SizedBox between each container)
                    (index) {
                  if (index.isEven) {
                    // Even indexes represent containers
                    return Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Odd indexes represent SizedBox widgets
                    return const SizedBox(width: 10);
                  }
                },
              ),
            ),
          );
        } else if (state is SuccessMainCategoryState) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Add default chip widget here
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: SizedBox(
                    height: 40,
                    child: ActionChip(
                      label: Text(
                        "الكل",
                        style: TextStyle(
                          color: defaultChipSelected[0]
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: defaultChipSelected[0]
                          ? const Color(0xFF234F68)
                          : Theme.of(context).cardColor,
                      onPressed: () {
                        setState(() {
                          categoryId = 0;
                        });

                        if(!defaultChipSelected[0]){
                          context.read<BannersCubit>().getBanners();
                          context.read<SubCategoryCubit>().getSubCategory(parentId: categoryId);
                          context.read<FeaturedCubit>().getFeatured();
                          context.read<PropertyCubit>().getPropertyByAllCategory();

                        }

                        setState(() {
                          // Deselect all chips
                          defaultChipSelected = List.filled(defaultChipSelected.length, false);
                          // Deselect all chips except the default chip
                          chipSelected = List.filled(chipSelected.length, false);
                          // Select the default chip
                          defaultChipSelected[0] = true;

                          if (kDebugMode) {
                            print(1);
                          }
                        });


                      },
                    ),
                  ),
                ),
                // Generate chip widgets from the API response
                ...List.generate(
                  state.categoryModel.results.length,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: ChipWidgetHome(
                      chipSelected: chipSelected,
                      onChipClick: ()  {
                        setState(() {
                          categoryId = state.categoryModel.results[index].id;

                        });
                        // Check if the current chip is already selected
                        if (!chipSelected[index]) {
                          // If not selected, make the request
                          context.read<BannersCubit>().getBannersWithCategory(categoryId: categoryId);
                          context.read<SubCategoryCubit>().getSubCategory(parentId: categoryId);
                          // context.read<FeaturedCubit>().getFeatured();
                          context.read<FeaturedCubit>().getFeaturedWithCategory(categoryId: categoryId);
                          context.read<PropertyCubit>().getPropertyByMainCategory(mainCategory: categoryId);

                        }

                        setState(() {
                          // Deselect all chips except the clicked chip
                          chipSelected = List.filled(chipSelected.length, false);
                          chipSelected[index] = true;
                          clickedChip = state.categoryModel.results[index].toString();
                          if (kDebugMode) {
                            print(state.categoryModel.results[index].id.toString());
                          }
                          // Deselect the default chip if any other chip is selected
                          defaultChipSelected[0] = false;
                        });


                      },
                      categoryModel: state.categoryModel,
                      index: index,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is ErrorMainCategoryState) {
          return InternetErrorWidget(description: state.error,onRetry: () async { _fetchData(); },);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildHomePageSectionsBanners() {
    return BlocBuilder<BannersCubit, BannersState>(
      builder: (context, state) {
        if (state is LoadingBannersState) {
          return Container(
            width: 310.0,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          );
        } else if (state is SuccessBannersState) {
          return BannerSectionWidget(
            bannerList: state.bannerModel,
            onTapBanner: (index) {
              if (kDebugMode) {
                print(state.bannerModel[index].id);
              }
            },
          );
        } else if (state is ErrorBannersState) {
          return const Center(child: SizedBox());
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildHomePageSectionsSubCategories() {
    return BlocBuilder<SubCategoryCubit, SubCategoryState>(
      builder: (context, state) {
        if (state is LoadingSubCategoryState) {
          return const SizedBox();
        } else if (state is SuccessSubCategoryState) {
          final categoryModel = state.categoryModel;
          final hasCategories = categoryModel.results.isNotEmpty;
          return Column(
            children: [
              if (hasCategories)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    TitleSectionWidget(
                      titleSection: Locales.string(context, "property_types"),
                      titleButton: Locales.string(context, "show_all"),
                      tap: () {
                        if (kDebugMode) {
                          print("hello");
                        }
                      },
                    ),
                  ],
                ),
              SubcategorySectionWidget(
                categoryList: categoryModel,
                onTap: (index) {
                  // Handle onTap event
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryPropertyScreen(
                              id: state.categoryModel.results[index].id,
                            haveChildren: state.categoryModel.results[index].have_children!,
                          )
                      )
                  );
                },
              ),
            ],
          );
        } else if (state is ErrorSubCategoryState) {
          return const Center(child: SizedBox());
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildFeaturedProperties() {
    return BlocBuilder<FeaturedCubit, FeaturedState>(
      builder: (context, state) {
        if (state is InitFeaturedState) {
          return const CircularProgressIndicator();
        } else if (state is SuccessFeaturedState) {
          if (state.propertyModel.results!.isEmpty) {
            // If the results list is empty, return an empty SizedBox
            return const SizedBox();
          } else {
            // If the results list is not empty, return the Column with TitleSectionWidget
            return Column(
              children: [
                const SizedBox(height: 15,),
                TitleSectionWidget(
                  titleSection: Locales.string(context, "featured_property"),
                  titleButton: Locales.string(context, "show_all"),
                  tap: () {
                    if (kDebugMode) {
                      print("hello");
                    }
                  },
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      state.propertyModel.results!.length,
                          (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.5),
                        child: FeaturedPropertyWidget(
                          index: index,
                          propertyModel: state.propertyModel,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        } else if (state is ErrorFeaturedState) {
          return const Center(child: SizedBox());
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildHighPlaces() {
    return BlocBuilder<HighStateCubit, HighStateState>(
      builder: (context, state) {
        if (state is LoadingHighStateState) {
          return const SizedBox();
        } else if (state is SuccessHighStateState) {
          return Column(
            children: [
              const SizedBox(height: 15,),
              TitleSectionWidget(
                titleSection: Locales.string(context, "high_places"),
                titleButton: Locales.string(context, "show_all"),
                tap: () {
                  if (kDebugMode) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllHighPlacesScreen(stateModel: state.stateModel,)),
                    );
                  }
                },
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    state.stateModel.length,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.5),
                      child: HighPlacesWidget(
                          image: propertyImageList[index],
                          name: state.stateModel[index].name,
                        onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HighStateScreen(
                                id: state.stateModel[index].id,
                                name: state.stateModel[index].name,
                              ))
                            );
                        },
                      )
                      ,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is ErrorHighStateState) {
          return const Center(child: SizedBox());
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildTopRealEstateAgents() {
    return Column(
      children: [
        const SizedBox(height: 15,),
        TitleSectionWidget(
          titleSection: Locales.string(context, "top_agent"),
          titleButton: Locales.string(context, "show_all"),
          tap: () {
            if (kDebugMode) {
              print("hello");
            }
          },
        ),
        // Implement top real estate agents section here
      ],
    );
  }

  Widget _buildDiscoverNearProperties() {
    return Column(
      children: [
        BlocBuilder<PropertyCubit, PropertyState>(
          builder: (context, state) {
            if (state is LoadingPropertyState) {
              // Return a SizedBox if data is loading
              return const SizedBox();
            } else if (state is SuccessPropertyState) {
              // If there is data available, show the title section and property widgets
              return Column(
                children: [
                  // Use Visibility widget to conditionally show/hide the title section
                  Visibility(
                    visible: state.propertyModel.results!.isNotEmpty,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        TitleSectionWidget(
                          titleSection: Locales.string(context, "discover_property"),
                          titleButton: Locales.string(context, "show_all"),
                          tap: () {
                            if (kDebugMode) {
                              print("hello");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  // Show property widgets using Wrap
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 30.0,
                    runSpacing: 10.0,
                    children: List.generate(
                      state.propertyModel.results!.length,
                          (index) => StandPropertyWidget(
                        index: index,
                        propertyModel: state.propertyModel,
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is ErrorPropertyState) {
              // Handle error state
              return const Center(child: SizedBox());
            } else {
              // Return a SizedBox for other states
              return const SizedBox();
            }
          },
        ),
      ],
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
    Images.onBoardingOne,
    Images.onBoardingOne,
    Images.onBoardingOne,
    Images.onBoardingOne,
  ];
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
  // void _fillBanners(){
  //   bannerList = [
  //     BannerModel(
  //       id: 1,
  //       time_created: '2024-03-28 03:50',
  //       end_time: '2024-03-28 03:47',
  //       start_time: '2024-03-30 03:48',
  //       title: 'Hi every one',
  //       description: 'Discount reach to 60 % for the Villas',
  //       image: propertyImageList[0],
  //       is_active: false,
  //       category: 11,
  //     ),
  //     BannerModel(
  //       id: 2,
  //       time_created: '2024-03-28 03:50',
  //       end_time: '2024-03-28 03:47',
  //       start_time: '2024-03-30 03:48',
  //       title: 'Title for banner 2',
  //       description: 'Description for banner 2',
  //       image: propertyImageList[1],
  //       is_active: false,
  //       category: 11,
  //     ),
  //     BannerModel(
  //       id: 3,
  //       time_created: '2024-03-28 03:50',
  //       end_time: '2024-03-28 03:47',
  //       start_time: '2024-03-30 03:48',
  //       title: 'Title for banner 3',
  //       description: 'Description for banner 3',
  //       image: propertyImageList[2],
  //       is_active: false,
  //       category: 11,
  //     ),
  //     BannerModel(
  //       id: 4,
  //       time_created: '2024-03-28 03:50',
  //       end_time: '2024-03-28 03:47',
  //       start_time: '2024-03-30 03:48',
  //       title: 'Title for banner 4',
  //       description: 'Description for banner 4',
  //       image: propertyImageList[3],
  //       is_active: false,
  //       category: 11,
  //     ),
  //     BannerModel(
  //       id: 5,
  //       time_created: '2024-03-28 03:50',
  //       end_time: '2024-03-28 03:47',
  //       start_time: '2024-03-30 03:48',
  //       title: 'Title for banner 5',
  //       description: 'Description for banner 5',
  //       image: propertyImageList[4],
  //       is_active: false,
  //       category: 11,
  //     ),
  //     BannerModel(
  //       id: 6,
  //       time_created: '2024-03-28 03:50',
  //       end_time: '2024-03-28 03:47',
  //       start_time: '2024-03-30 03:48',
  //       title: 'Title for banner 6',
  //       description: 'Description for banner 6',
  //       image: propertyImageList[5],
  //       is_active: false,
  //       category: 11,
  //     ),
  //     BannerModel(
  //       id: 7,
  //       time_created: '2024-03-28 03:50',
  //       end_time: '2024-03-28 03:47',
  //       start_time: '2024-03-30 03:48',
  //       title: 'Title for banner 7',
  //       description: 'Description for banner 7',
  //       image: propertyImageList[6],
  //       is_active: false,
  //       category: 11,
  //     ),
  //   ];
  // }
}

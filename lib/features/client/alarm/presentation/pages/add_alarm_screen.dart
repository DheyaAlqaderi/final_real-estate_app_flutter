import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/category/category_cubit.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/category/category_cubit_state.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/category/subCategory/subCategory_cubit.dart';
import '../../../../../core/utils/styles.dart';
import '../../../home/widgets/chip_widget_home.dart';
class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({super.key});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
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
    final mainCategory = context.read<CategoryAlarmCubit>();
    final subCategory = context.read<SubCategoryAlarmCubit>();



    await Future.wait([
      mainCategory.fetchMainCategory(),
      subCategory.getSubCategory(parentId: categoryId),
    ]);


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // app bar section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 85.0,
                width: double.infinity,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Locales.change(context, "ar");
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Theme.of(context).cardColor,
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.arrow_back_ios_new_outlined, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 100.0),
                    Text(Locales.string(context, "add_alarm"),
                        style: fontMediumBold),
                  ],
                ),
              ),
            ),

            // alarm page section
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text("نوع القائمة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<CategoryAlarmCubit, CategoryAlarmState>(
                        builder: (context, state) {
                          if (state is CategoryAlarmLoading) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                          } else if (state is CategoryAlarmLoaded) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Add default chip widget here
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                  //   child: SizedBox(
                                  //     height: 40,
                                  //     child: ActionChip(
                                  //       label: Text(
                                  //         "الكل",
                                  //         style: TextStyle(
                                  //           color: defaultChipSelected[0]
                                  //               ? Colors.white
                                  //               : Theme.of(context).colorScheme.onSurface,
                                  //         ),
                                  //       ),
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(20),
                                  //       ),
                                  //       backgroundColor: defaultChipSelected[0]
                                  //           ? const Color(0xFF234F68)
                                  //           : Theme.of(context).cardColor,
                                  //       onPressed: () {
                                  //         setState(() {
                                  //           categoryId = 0;
                                  //         });
                                  //
                                  //         if(!defaultChipSelected[0]){
                                  //           context.read<BannersCubit>().getBanners();
                                  //           context.read<SubCategoryCubit>().getSubCategory(parentId: categoryId);
                                  //
                                  //         }
                                  //
                                  //         setState(() {
                                  //           // Deselect all chips
                                  //           defaultChipSelected = List.filled(defaultChipSelected.length, false);
                                  //           // Deselect all chips except the default chip
                                  //           chipSelected = List.filled(chipSelected.length, false);
                                  //           // Select the default chip
                                  //           defaultChipSelected[0] = true;
                                  //
                                  //           if (kDebugMode) {
                                  //             print(1);
                                  //           }
                                  //         });
                                  //
                                  //
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),
                                  // Generate chip widgets from the API response
                                  ...List.generate(
                                    state.category.results.length,
                                        (index) => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                      child: ChipWidgetHome(
                                        chipSelected: chipSelected,
                                        onChipClick: ()  {
                                          setState(() {
                                            categoryId = state.category.results[index].id;

                                          });
                                          // Check if the current chip is already selected
                                          if (!chipSelected[index]) {
                                            // If not selected, make the request
                                            // context.read<BannersCubit>().getBannersWithCategory(categoryId: categoryId);
                                            context.read<SubCategoryAlarmCubit>().getSubCategory(parentId: categoryId);
                                            // context.read<FeaturedCubit>().getFeatured();
                                            // context.read<HighStateCubit>().getHighStates(categoryId: categoryId);
                                            // context.read<FeaturedCubit>().getFeaturedWithCategory(categoryId: categoryId);
                                            // context.read<PropertyHomeCubit>().getPropertyByMainCategory(mainCategory: categoryId);

                                          }

                                          setState(() {
                                            // Deselect all chips except the clicked chip
                                            chipSelected = List.filled(chipSelected.length, false);
                                            chipSelected[index] = true;
                                            clickedChip = state.category.results[index].toString();
                                            if (kDebugMode) {
                                              print(state.category.results[index].id.toString());
                                            }
                                            // Deselect the default chip if any other chip is selected
                                            defaultChipSelected[0] = false;
                                          });


                                        },
                                        categoryModel: state.category,
                                        index: index,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (state is CategoryAlarmFailure) {
                            return const Text("faild to fetch data");
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),

                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text("فئة العقار", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),


                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

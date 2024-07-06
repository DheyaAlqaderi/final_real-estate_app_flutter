
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/feedback/presentation/widgets/appBar.dart';
import 'package:smart_real_estate/owner/add_property/presentation/pages/second_address_add_property.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';
import '../../../../features/client/alarm/presentation/manager/category/category_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/category/category_cubit_state.dart';
import '../../../../features/client/alarm/presentation/manager/category/subCategory/subCategory_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/category/subCategory/subCategory_state.dart';
import '../../../../features/client/alarm/presentation/pages/add_alarm_screen.dart';
import '../../../../features/client/home/data/models/category/category_model.dart';
import '../../../../features/client/home/widgets/chip_widget_home.dart';

class FirstAddProperty extends StatefulWidget {
  const FirstAddProperty({super.key});

  @override
  State<FirstAddProperty> createState() => _FirstAddPropertyState();
}

class _FirstAddPropertyState extends State<FirstAddProperty> {
  String? userId;
  String? userToken;
  final TextEditingController _propertyNameController = TextEditingController();
  final TextEditingController _propertyDescriptionController = TextEditingController();


  String? clickedChip;
  late List<bool> chipSelected;
  late List<bool> chipSelected2;
  List<bool>? chipSelected3;
  bool? chipSelected3First;
  bool? chipSelected3Last;
  late List<bool> defaultChipSelected;
  int? categoryId;
  int? subCategoryId;

  String? _errorText;
  String? _errorText2;

  // Example CategoryModel instance
  var categoryModel = CategoryModel.fromJson(categoryJson);


  @override
  void initState() {
    saveDataAndNavigateToSecondPage(context);
    super.initState();
    _loadUserData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });

    chipSelected = List.generate(10, (index) => false);
    chipSelected2 = List.generate(30, (index) => false);
    chipSelected3 = List.generate(2, (index) => false);
    defaultChipSelected = List.generate(1, (index) => false);
  }


  /// fetch data from the server
  void _fetchData() async{

    final mainCategory = context.read<CategoryAlarmCubit>();

    await Future.wait([
      mainCategory.fetchMainCategory(),
    ]);
  }

  /// function to get user id and token
  Future<void> _loadUserData() async {
    final loadedUserId = await SharedPrefManager.getData(AppConstants.userId);
    final loadedUserToken = await SharedPrefManager.getData(AppConstants.token);
    
    print(loadedUserId.toString());
    setState(() {
      userId = loadedUserId ?? '';
      userToken = loadedUserToken ?? '';
    });
  }

  Future<void> _secondPage() async {
    setState(() {
      _errorText = _propertyNameController.text.isEmpty ? 'هذا الحقل مطلوب' : null;
      _errorText2 = _propertyDescriptionController.text.isEmpty ? 'هذا الحقل مطلوب' : null;
    });

    if (_errorText2 == null) {
      // Input is valid, proceed with further actions
      String enteredText2 = _propertyDescriptionController.text;
      // Handle the valid input, e.g., submit to an API or process locally
      if (kDebugMode) {
        print('Entered text: $enteredText2');

      }
    } else {
      // Input is invalid, show validation error

      if (kDebugMode) {
        print('Validation error: $_errorText2');
      }
      return;
    }
    if (_errorText == null) {
      // Input is valid, proceed with further actions
      String enteredText = _propertyNameController.text;
      // Handle the valid input, e.g., submit to an API or process locally
      if (kDebugMode) {
        print('Entered text: $enteredText');
      }
    } else {
      // Input is invalid, show validation error
      if (kDebugMode) {
        print('Validation error: $_errorText');
      }
      return;
    }
    if (chipSelected3First == null || chipSelected3Last == null) {
      Get.snackbar(
        "Validation Error",
        "Please select a list type",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (chipSelected3First == false && chipSelected3Last == false) {
      Get.snackbar(
        "Validation Error",
        "Please select at least one list type",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (categoryId == null) {
      Get.snackbar(
        "Validation Error",
        "Please select a category",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (subCategoryId == null) {
      Get.snackbar(
        "Validation Error",
        "Please select a subcategory",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }






    if (kDebugMode) {
      print("chipSelected3: $chipSelected3First, $chipSelected3Last");
    }


    try {
      // Call createAlarm method with your token and the created alarm Map
      await SharedPrefManager.saveData(AppConstants.propertyName, _propertyNameController.text.toString());
      await SharedPrefManager.saveData(AppConstants.propertyDescription, _propertyDescriptionController.text.toString());
      await SharedPrefManager.saveData(AppConstants.propertyCategoryId, subCategoryId.toString());
      await SharedPrefManager.saveData(AppConstants.forSale, chipSelected3!.last.toString());
      await SharedPrefManager.saveData(AppConstants.forRent, chipSelected3!.first.toString());

      saveDataAndNavigateToSecondPage(context);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to create alarm",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {

      });
    }
  }



  Future<void> saveDataAndNavigateToSecondPage(BuildContext context) async {

    // Retrieve data
    final propertyName = await SharedPrefManager.getData(AppConstants.propertyName);
    final propertyDescription = await SharedPrefManager.getData(AppConstants.propertyDescription);
    final propertyCategoryId = await SharedPrefManager.getData(AppConstants.propertyCategoryId);
    final isForSale = await SharedPrefManager.getData(AppConstants.forSale);
    final isForRent = await SharedPrefManager.getData(AppConstants.forRent);

    // Print data for debugging
    print("Property Name: $propertyName, Property Description: $propertyDescription, Property Category ID: $propertyCategoryId, Is For Sale: $isForSale, Is For Rent: $isForRent");

    // Validate data
    if (propertyName != null && propertyDescription != null && propertyCategoryId != null && isForSale != null && isForRent != null) {
      // Navigate to the second page if all required data is present
      _propertyDescriptionController.text = propertyDescription;
      _propertyNameController.text = propertyName;
      if(bool.parse(isForRent)){
        chipSelected3 = List.filled(chipSelected3!.length, false);
        chipSelected3![0] = true;

          chipSelected3Last = true;
          chipSelected3First = false;

      }
      if(bool.parse(isForSale)){
        chipSelected3 = List.filled(chipSelected3!.length, false);
        chipSelected3!.first = true;

          chipSelected3First = true;
          chipSelected3Last = false;

      }


      Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondAddressAddProperty()));
    } else {
      // Handle the case where some data is missing
      print('Some required data is missing.');
      // Optionally, show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all required fields before proceeding.'))
      );
    }
  }


  @override
  void dispose() {
    _propertyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        onTap: (){
          // exit the page
          Navigator.pop(context);
        },
        title: "add_property",
      ),
      body: Stack(
        children: [

          /// the page content
          SizedBox(
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100, top: 8, right: 8, left: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                     const SizedBox(height: 20,),
                     const Text("مرحبًا بك، املأ التفاصيل الخاصة بك للعقار", style: fontLarge,),

                    const SizedBox(height: 30,),
                    TextField(
                      controller: _propertyNameController,
                      decoration: InputDecoration(
                        hintText: 'اسم العقار',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),  // Adjust the radius as needed
                          borderSide: BorderSide.none,  // Optional: Removes the border outline
                        ),
                        fillColor: Theme.of(context).cardColor,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                        errorText: _errorText,
                      ),
                    ),

                    const SizedBox(height: 10,),
                    Container(
                      height: 120,
                      width: double.infinity,

                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: TextField(
                        controller: _propertyDescriptionController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'وصف العقار',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),  // Adjust the radius as needed
                            borderSide: BorderSide.none,  // Optional: Removes the border outline
                          ),
                          fillColor: Colors.transparent,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          errorText: _errorText2,
                        ),
                      ),
                    ),

                    /// type of property
                    const SizedBox(height: 10,),
                    Align(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          text:  TextSpan(
                            text: 'نوع القائمة',
                            style: fontMediumBold.copyWith(color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white // Set text color for dark mode
                                : Theme.of(context).primaryColor,),
                            children: const <TextSpan>[
                              TextSpan(
                                text: '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          ...List.generate(
                            2,
                                (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.5),
                              child: ChipWidgetHome(
                                chipSelected: chipSelected3!,
                                onChipClick: ()  {



                                  setState(() {
                                    // Deselect all chips except the clicked chip
                                    chipSelected3 = List.filled(chipSelected3!.length, false);
                                    chipSelected3![index] = true;
                                    if(index == 0){
                                      chipSelected3First = true;
                                      chipSelected3Last = false;
                                    } else if(index == 1){
                                      chipSelected3Last = true;
                                      chipSelected3First = false;
                                    }
                                  });


                                },
                                categoryModel: categoryModel,
                                index: index,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    /// list type section
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        text:  TextSpan(
                          text: 'فئة العقار ',
                          style: fontMediumBold.copyWith(color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white // Set text color for dark mode
                              : Theme.of(context).primaryColor,),
                          children: const <TextSpan>[
                            TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      )
                      ,
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
                                          context.read<SubCategoryAlarmCubit>().getSubCategory(parentId: categoryId!);

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

                    const SizedBox(height: 10),
                    BlocBuilder<SubCategoryAlarmCubit, SubCategoryAlarmCubitState>(
                      builder: (context, state) {
                        if (state is LoadingSubCategoryState) {
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
                        } else if (state is SuccessSubCategoryState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text:  TextSpan(
                                  text: 'أختر العقار ',
                                  style: fontMediumBold.copyWith(color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white // Set text color for dark mode
                                      : Theme.of(context).primaryColor,),
                                  children: const <TextSpan>[
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                runSpacing: 10,
                                spacing: 10,
                                children: [
                                  ...List.generate(
                                    state.categoryModel.results.length,
                                        (index) => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                      child: ChipWidgetHome(
                                        chipSelected: chipSelected2,
                                        onChipClick: ()  {
                                          setState(() {
                                            subCategoryId = state.categoryModel.results[index].id;

                                          });


                                          setState(() {
                                            // Deselect all chips except the clicked chip
                                            chipSelected2 = List.filled(chipSelected2.length, false);
                                            chipSelected2[index] = true;
                                            clickedChip = state.categoryModel.results[index].toString();
                                            if (kDebugMode) {
                                              print(state.categoryModel.results[index].id.toString());
                                            }
                                            // context.read<AttributeAlarmCubit>().fetchAttributesByCategory(categoryId: subCategoryId!);

                                          });


                                        },
                                        categoryModel: state.categoryModel,
                                        index: index,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else if (state is CategoryAlarmFailure) {
                          return const Text("faild to fetch data");
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),

                  ],
                ),
              ),
            ),
          ),

          /// the navigate button
          Positioned(
            bottom: 20,
            right: 20,
            left: 20,
            child: InkWell(
              onTap: _secondPage,
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor
                ),
                child: Center(
                  child: Text(
                      Locales.string(context, 'next'),
                    style: fontMediumBold.copyWith(color: Colors.white),
                  ),
                ),
              ),
            )

          )
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';

import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/helper/local_data/shared_pref.dart';
import '../../../../../core/utils/styles.dart';
import '../../../alarm/data/models/attribute_alarm_model.dart';
import '../../../alarm/data/models/city_model.dart';
import '../../../alarm/data/models/country_model.dart';
import '../../../alarm/data/models/state_model.dart';
import '../../../alarm/presentation/manager/address/address_cubit.dart';
import '../../../alarm/presentation/manager/address/city/city_cubit.dart';
import '../../../alarm/presentation/manager/address/city/city_cubit_state.dart';
import '../../../alarm/presentation/manager/address/country/country_cubit.dart';
import '../../../alarm/presentation/manager/address/country/country_cubit_state.dart';
import '../../../alarm/presentation/manager/address/state/state_cubit.dart';
import '../../../alarm/presentation/manager/address/state/state_cubit_state.dart';
import '../../../alarm/presentation/manager/attribute/attribute_alarm_cubit.dart';
import '../../../alarm/presentation/manager/attribute/attribute_alarm_cubit_state.dart';
import '../../../alarm/presentation/manager/category/category_cubit.dart';
import '../../../alarm/presentation/manager/category/category_cubit_state.dart';
import '../../../alarm/presentation/manager/category/subCategory/subCategory_cubit.dart';
import '../../../alarm/presentation/manager/category/subCategory/subCategory_state.dart';
import '../../../alarm/presentation/manager/create_alarm/create_alarm_cubit.dart';
import '../../../alarm/presentation/pages/add_alarm_screen.dart';
import '../../../alarm/presentation/widget/custom_attribute_int.dart';
import '../../../alarm/presentation/widget/custom_dropdown_field.dart';
import '../../../home/data/models/category/category_model.dart';
import '../../../home/widgets/chip_widget_home.dart';

RangeValues _currentRangeValues = const RangeValues(10000, 1000000);
class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? clickedChip;
  late List<bool> chipSelected;
  late List<bool> chipSelected2;
  List<bool>? chipSelected3;
  RangeValues? rangeValues;
  bool? chipSelected3First;
  bool? chipSelected3Last;

  late List<bool> defaultChipSelected;
  int? categoryId;
  int? subCategoryId;


  CountryModel? selectedCountry, realSelectedCountry;
  CityModel? selectedCity, realSelectedCity;
  StateModel? selectedState, realSelectedState;
  bool _isLoading = false;


  // Example CategoryModel instance
  var categoryModel = CategoryModel.fromJson(categoryJson);

  int? stateId;
  String? token;

  List<Map<String, dynamic>> realAttributes = [];
  List<String> values = ['5', '8', '2']; // Assuming these are strings based on the previous example
  List<int> ids = [3,  4, 7]; // List of attribute IDs

  @override
  void initState() {
    super.initState();
    rangeValues = _currentRangeValues;
    fetchToken();
    chipSelected = List.generate(10, (index) => false);
    chipSelected2 = List.generate(30, (index) => false);
    chipSelected3 = List.generate(2, (index) => false);
    defaultChipSelected = List.generate(1, (index) => false);

    setState(() {
      defaultChipSelected[0] = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() async{
    final address = context.read<AddressCubit>();
    final country = context.read<CountryCubit>();

    final mainCategory = context.read<CategoryAlarmCubit>();

    await Future.wait([
      address.fetchCountries(),
      country.fetchCountries(),
      mainCategory.fetchMainCategory(),
    ]);
  }

  Future<void> fetchToken() async {
    try{
      await SharedPrefManager.init();

      String? tokenFlag = await SharedPrefManager.getData(AppConstants.token);
      setState(() {
        token = tokenFlag!;
      });
    } catch(e){
      print("error load token: $e");
    }

  }

  Future<void> _createAlarm() async {
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

    if (stateId == null) {
      Get.snackbar(
        "Validation Error",
        "Please select an address",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String startPrice = _currentRangeValues.start.toStringAsFixed(2);
    String endPrice = _currentRangeValues.end.toStringAsFixed(2);

    Map<String, dynamic> alarm = {
      'alarm_values': realAttributes,
      'is_active': true,
      'max_price': endPrice,
      'min_price': startPrice,
      'for_sale': chipSelected3First,
      'for_rent': chipSelected3Last,
      'state': stateId,
      'category': subCategoryId,
    };

    print("chipSelected3: $chipSelected3First, $chipSelected3Last");
    print("stateId: $stateId");

    try {
      // Call createAlarm method with your token and the created alarm Map
      await context.read<CreateAlarmCubit>().createAlarm("token ${token!}", alarm);
      Get.snackbar(
        "Success",
        "Alarm created successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Navigator.pop(context);
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
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
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
                        Text(Locales.string(context, "add_alarm_notification"),
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
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const SizedBox(height: 20),
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
                                            if (kDebugMode) {
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
                                                    context.read<AttributeAlarmCubit>().fetchAttributesByCategory(categoryId: subCategoryId!);

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


                            const SizedBox(height: 10),
                            Align(
                                alignment: Alignment.centerRight,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'عنوان العقار ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white // Set text color for dark mode
                                          : Theme.of(context).primaryColor, // Adjust color dynamically
                                    ),
                                    children: const <TextSpan>[
                                      TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                          color: Colors.red, // Red color for the asterisk
                                        ),
                                      ),
                                    ],
                                  ),
                                )

                            ),
                            const SizedBox(height: 10),
                            BlocBuilder<CountryCubit, CountryCubitState>(
                              builder: (context, state) {
                                if (state is CountryCubitLoading) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (state is CountryCubitLoaded) {
                                  return CustomDropdownField<CountryModel>(
                                    items: state.countries,
                                    itemLabelBuilder: (CountryModel country) => country.name!,
                                    value: selectedCountry,
                                    hint: 'Select a country',
                                    onChanged: (CountryModel? newValue) {
                                      setState(() {
                                        stateId = null;
                                        selectedCountry = newValue;
                                        realSelectedCity = selectedCity;
                                        realSelectedState = selectedState;
                                        selectedState = null;
                                        selectedCity = null;
                                        context.read<CityCubit>().fetchCities(countryId: selectedCountry!.id!);
                                      });
                                    },
                                  );
                                } else if (state is CountryCubitFailure) {
                                  return Center(child: Text('Error: ${state.error}'));
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),


                            const SizedBox(height: 20),
                            BlocBuilder<CityCubit, CityCubitState>(
                              builder: (context, state) {
                                if (state is CityCubitLoading) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (state is CityCubitLoaded) {
                                  return CustomDropdownField<CityModel>(
                                    items: state.countries,
                                    itemLabelBuilder: (CityModel city) => city.name!,
                                    value: selectedCity,
                                    hint: 'Select a City',
                                    onChanged: (CityModel? newValue) {
                                      setState(() {
                                        stateId = null;
                                        selectedCity = newValue;
                                        realSelectedState = selectedState;
                                        selectedState = null;
                                        context.read<StateCubit>().fetchStates(cityId: selectedCity!.id!);
                                      });
                                    },
                                  );
                                } else if (state is CityCubitFailure) {
                                  return Center(child: Text('Error: ${state.error}'));
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),

                            const SizedBox(height: 20),
                            BlocBuilder<StateCubit, StateCubitState>(
                              builder: (context, state) {
                                if (state is StateCubitLoading) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (state is StateCubitLoaded) {
                                  return CustomDropdownField<StateModel>(
                                    items: state.countries,
                                    itemLabelBuilder: (StateModel state) => state.name!,
                                    value: selectedState,
                                    hint: 'Select a state',
                                    onChanged: (StateModel? newValue) {
                                      setState(() {
                                        selectedState = newValue;
                                        stateId = selectedState!.id;
                                      });
                                    },
                                  );
                                } else if (state is StateCubitFailure) {
                                  return Center(child: Text('Error: ${state.error}'));
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),


                            BlocBuilder<AttributeAlarmCubit, AttributeAlarmState>(
                              builder: (context, state) {
                                if (state is AttributeAlarmLoading) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (state is AttributeAlarmLoaded) {
                                  // Function to filter data based on data_type
                                  List<AttributesAlarmModel> filterDataByType(List<AttributesAlarmModel> data, String dataType) {
                                    return data.where((item) => item.dataType == dataType).toList();
                                  }

                                  // Convert state.attributes (list of AttributesAlarmModel) to List<Map<String, dynamic>>
                                  List<AttributesAlarmModel> data = state.attributes;

                                  // Initialize a list to hold dropdown lists
                                  // List<List<String>> dropdownLists = [];
                                  //
                                  // // Example: Get all unique data types
                                  // Set<String?> uniqueDataTypes = data.map((item) => item.dataType).toSet();
                                  //
                                  // // Populate dropdownLists based on unique data types
                                  // // for (var dataType in uniqueDataTypes) {
                                  // //   List<AttributesAlarmModel> filteredData = filterDataByType(data, dataType!);
                                  // //   List<String> dropdownItems = filteredData.expand((attribute) {
                                  // //     String name = attribute.name ?? '';
                                  // //     List<String> values = attribute.valueAttribute
                                  // //         ?.map<String>((valueAttr) => valueAttr.value ?? '')
                                  // //         .toList() ?? [];
                                  // //     return values.map((value) => "$name $value").toList();
                                  // //   }).toList();
                                  // //   dropdownLists.add(dropdownItems);
                                  // // }

                                  // Function to build a CustomDropdown widget
                                  // Widget buildCustomDropdown(List<String> items, String hintText) {
                                  //   return Container(
                                  //     margin: const EdgeInsets.symmetric(vertical: 10),
                                  //     child: CustomDropdown<String>(
                                  //       hintText: hintText,
                                  //       items: items,
                                  //       initialItem: items.isNotEmpty ? items[0] : '',
                                  //       onChanged: (value) {
                                  //         print('changing value to: $value');
                                  //       },
                                  //       decoration: const CustomDropdownDecoration(
                                  //         closedFillColor: Color(0xFFEEEEEE),
                                  //       ),
                                  //     ),
                                  //   );
                                  // }

                                  // values = filterDataByType(data, "int").att;
                                  return Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 9),
                                          const Text("خصائص العقار", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 6),
                                          // Example: Build CustomAttributeInt widgets for int data
                                          ...filterDataByType(data, 'int').map((attribute) {
                                            return CustomAttributeInt(
                                              initialValue: 0,
                                              label: attribute.name ?? '',
                                              onChanged: (value) {
                                                print(value);
                                                // Find if the attribute already exists in realAttributes
                                                var existingAttribute = realAttributes.firstWhere(
                                                      (element) => element['attribute_id'] == attribute.id.toString(),
                                                  orElse: () => {'attribute_id': null, 'value': null}, // Return a placeholder map
                                                );

                                                if (existingAttribute['attribute_id'] != null) {
                                                  // If the attribute exists, update its value or remove it if the value is zero
                                                  if (value == 0) {
                                                    realAttributes.removeWhere((element) => element['attribute_id'] == attribute.id.toString());
                                                  } else {
                                                    existingAttribute['value'] = value.toString();
                                                  }
                                                } else if (value != 0) {
                                                  // If the attribute does not exist and the value is not zero, add a new one
                                                  realAttributes.add({
                                                    'attribute_id': attribute.id.toString(),
                                                    'value': value.toString(),
                                                  });
                                                }

                                                // Print the updated realAttributes list
                                                print('Updated realAttributes: $realAttributes');
                                              },
                                            );
                                          }),

                                        ],
                                      ),
                                    ],
                                  );
                                } else if (state is AttributeAlarmFailure) {
                                  return Center(child: Text('Error: ${state.error}'));
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),

                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: RichText(
                                text:  TextSpan(
                                  text: 'تحديد السعر',
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
                            RangeSlider(
                              values: _currentRangeValues,
                              min: 0,
                              max: 1000000,
                              divisions: 30,
                              labels: RangeLabels(
                                _currentRangeValues.start.round().toString(),
                                _currentRangeValues.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _currentRangeValues = values;
                                  rangeValues = values;
                                });
                              },
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 10,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: InkWell(
                onTap: _createAlarm,
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: _isLoading?const CircularProgressIndicator():Text(
                      "تطبيق المنبة",
                      style: fontMediumBold.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

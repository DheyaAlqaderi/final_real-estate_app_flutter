
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';
import 'package:smart_real_estate/owner/edit_property/presentation/widgets/list_features_widget.dart';

import '../../../../core/utils/styles.dart';
import '../../../../features/client/alarm/data/models/attribute_alarm_model.dart';
import '../../../../features/client/alarm/presentation/manager/attribute/attribute_alarm_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/attribute/attribute_alarm_cubit_state.dart';
import '../../../../features/client/alarm/presentation/manager/category/category_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/category/category_cubit_state.dart';
import '../../../../features/client/alarm/presentation/manager/category/subCategory/subCategory_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/category/subCategory/subCategory_state.dart';
import '../../../../features/client/alarm/presentation/pages/add_alarm_screen.dart';
import '../../../../features/client/alarm/presentation/widget/custom_attribute_int.dart';
import '../../../../features/client/home/data/models/category/category_model.dart';
import '../../../../features/client/home/widgets/chip_widget_home.dart';
import '../../../add_property/presentation/widgets/dropDown_widget.dart';


class CategorySectionEdit extends StatefulWidget {
  CategorySectionEdit({super.key ,required this.selectedCategoryId, required this.selectedSubCategoryId, this.propertyDetails, required this.token});
  int selectedCategoryId;
  int selectedSubCategoryId;
  final propertyDetails;
  final String token;


  @override
  State<CategorySectionEdit> createState() => _CategorySectionEditState();
}

class _CategorySectionEditState extends State<CategorySectionEdit> {
  String? clickedChip;
  late List<bool> chipSelected;
  late List<bool> chipSelected2;
  List<bool>? chipSelected3;
  bool? chipSelected3First;
  bool? chipSelected3Last;
  late List<bool> defaultChipSelected;
  int? categoryId;
  int? subCategoryId;
  var categoryModelList = CategoryModel.fromJson(categoryJson);

  CategoryModel? mainCategory;
  CategoryModel? subCategory;
  int? parentId;


  /// second api attributes
  List<Map<String, dynamic>> realAttributes = [];
  Map<String, dynamic> lastAttributes = {};
  int? sizeValue;
  int? initSizeValue;
  String? isDeleted;


  @override
  void initState() {
    super.initState();
    subCategoryId = widget.selectedSubCategoryId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });


    chipSelected = List.generate(10, (index) => false);
    chipSelected2 = List.generate(30, (index) => false);
    chipSelected3 = List.generate(2, (index) => false);
    defaultChipSelected = List.generate(1, (index) => false);
  }


  void _fetchData() async{

    final mainCategory = context.read<CategoryAlarmCubit>();
    final subCategory = context.read<SubCategoryAlarmCubit>();
    final attributes = context.read<AttributeAlarmCubit>();

    await Future.wait([

    ]);
    await Future.wait([
      mainCategory.fetchMainCategory(),
      subCategory.getSubCategory(parentId: widget.selectedCategoryId),
      attributes.fetchAttributesByCategory(
          categoryId: subCategoryId!),
    ]);

    // [{attribute_id: 3, value: 2}]
    // {3: 2}
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

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
                    onChipClick: ()  async{
                      if(index == 0) {
                        await SharedPrefManager.saveData(
                            AppConstants.editForSale, "true");
                        await SharedPrefManager.saveData(
                            AppConstants.editForRent, "false");
                        print('for sale');
                      } else {
                        await SharedPrefManager.saveData(
                            AppConstants.editForRent, "true");
                        await SharedPrefManager.saveData(
                            AppConstants.editForSale, "false");
                        print('for rent');
                      }
                      setState(()  {
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
                    categoryModel: categoryModelList,
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
                          onChipClick: ()  async {
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
              return const Text("failed to fetch data");
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
                            onChipClick: ()  async {
                              setState(()  {
                                subCategoryId = state.categoryModel.results[index].id;


                              });

                              await SharedPrefManager.saveData(AppConstants.editSubCategoryId, subCategoryId.toString());
                              print("local sub $subCategoryId");
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



        /// attributes
        BlocBuilder<AttributeAlarmCubit, AttributeAlarmState>(
          builder: (context, state) {
            if (state is AttributeAlarmLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AttributeAlarmLoaded) {
              // Function to filter data based on data_type
              List<AttributesAlarmModel> filterDataByType(
                  List<AttributesAlarmModel> data, String dataType) {
                return data.where((item) => item.dataType == dataType).toList();
              }

              // Convert state.attributes (list of AttributesAlarmModel) to List<Map<String, dynamic>>
              List<AttributesAlarmModel> data = state.attributes;

              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 9),
                      const Text("خصائص العقار",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),

                      // Build CustomAttributeInt widgets for int data
                      ...filterDataByType(data, 'int').asMap().entries.map((entry) {
                        int index = entry.key;
                        var attribute = entry.value;

                        // Check if index is within range and propertyDetails is not null
                        bool inRange = index < widget.propertyDetails.propertyValue!.length;
                        String valueString = inRange
                            ? widget.propertyDetails.propertyValue![index].value!.value
                            : '0';
                        int initialValue = int.tryParse(valueString) ?? 0;

                        return CustomAttributeInt(
                          initialValue: initialValue,
                          label: attribute.name ?? '',
                          onChanged: (value) async {
                            print(value);
                            // Find if the attribute already exists in realAttributes
                            var existingAttribute = realAttributes.firstWhere(
                                  (element) => element['attribute_id'] == attribute.id.toString(),
                              orElse: () => {'attribute_id': null, 'value': null},
                            );

                            if (existingAttribute['attribute_id'] != null) {
                              // If the attribute exists, update its value or remove it if the value is zero
                              if (value == 0) {
                                // realAttributes.removeWhere(
                                //         (element) => element['attribute_id'] == attribute.id.toString());
                                existingAttribute['value'] = value.toString();
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

                            // Update lastAttributes map
                            lastAttributes.clear();
                            for (var attr in realAttributes) {
                              lastAttributes[attr['attribute_id'].toString()] =
                                  attr['value'].toString();
                            }

                            // Print the updated realAttributes list
                            print('Updated realAttributes: $realAttributes');
                            print('Updated lastAttributes: $lastAttributes');

                            await SharedPrefManager.saveMap(AppConstants.editPropertyAttributes, lastAttributes);


                            Map<String, dynamic>? l = await SharedPrefManager.getMap(AppConstants.editPropertyAttributes);

                            print("from locale $l");

                          },
                        );
                      }).toList(),
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



    /// fetch attributes string
        BlocBuilder<AttributeAlarmCubit, AttributeAlarmState>(
          builder: (context, state) {
            if (state is AttributeAlarmLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AttributeAlarmLoaded) {
              // Function to filter data based on data_type
              List<AttributesAlarmModel> filterDataByType(
                  List<AttributesAlarmModel> data, String dataType) {
                return data.where((item) => item.dataType == dataType).toList();
              }

              // Convert state.attributes (list of AttributesAlarmModel) to List<Map<String, dynamic>>
              List<AttributesAlarmModel> data = state.attributes;

              List<Map<String, dynamic>> transformToMap(
                  List<ValueAttributeModel>? attributes) {
                if (attributes == null) {
                  return [];
                }
                return attributes.map((attribute) {
                  return {
                    'id': attribute.id,
                    'value': attribute.value,
                    'attribute': attribute.attribute,
                  };
                }).toList();
              }

              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      // Build CustomDropdownButton widgets for string data
                      ...filterDataByType(data, 'string').map((attribute) {
                        return CustomDropdownButton(
                          options: transformToMap(attribute.valueAttribute),
                          lable: attribute.name ?? " ",
                          onChanged: (String id, String value) async {
                            print('Selected ID: $id, Selected Value: $value');

                            // Find if the attribute already exists in realAttributes
                            var existingAttribute = realAttributes.firstWhere(
                                  (element) => element['attribute_id'] == id,
                              orElse: () => {'attribute_id': null, 'value': null},
                            );

                            if (existingAttribute['attribute_id'] != null) {
                              // Update the existing attribute
                              existingAttribute['value'] = value;
                            } else {
                              // Add the new attribute
                              realAttributes.add({
                                'attribute_id': attribute.id,
                                'value': value,
                              });
                            }

                            // Update lastAttributes map
                            lastAttributes.clear();
                            for (var attr in realAttributes) {
                              lastAttributes[attr['attribute_id'].toString()] =
                                  attr['value'].toString();
                            }

                            // Print the updated realAttributes list
                            print('Updated realAttributes: $realAttributes');
                            print('Updated lastAttributes: $lastAttributes');

                            // Save the attribute model if needed
                            await SharedPrefManager.saveMap(AppConstants.editPropertyAttributes, lastAttributes);


                            Map<String, dynamic>? l = await SharedPrefManager.getMap(AppConstants.editPropertyAttributes);

                            print("from locale $l");
                          },
                        );
                      }).toList(),
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

        /// fetch attributes date
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

              List<Map<String, dynamic>> transformToMap(List<ValueAttributeModel>? attributes) {
                if (attributes == null) {
                  return [];
                }
                return attributes.map((attribute) {
                  return {
                    'id': attribute.id,
                    'value': attribute.value,
                    'attribute': attribute.attribute,
                  };
                }).toList();
              }

              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      ...filterDataByType(data, 'date').map((attribute) {
                        return CustomDatePicker(
                          label: attribute.name ?? " ",
                          onDateChanged: (DateTime selectedDate) async {
                            String formattedDate = selectedDate.toIso8601String();

                            // Find if the attribute already exists in realAttributes
                            var existingAttribute = realAttributes.firstWhere(
                                  (element) => element['attribute_id'] == attribute.id,
                              orElse: () => {'attribute_id': null, 'value': null}, // Return a placeholder map
                            );

                            // Add or update the attribute in realAttributes
                            if (existingAttribute['attribute_id'] != null) {
                              existingAttribute['value'] = formattedDate;
                            } else {
                              realAttributes.add({
                                'attribute_id': attribute.id,
                                'value': formattedDate,
                              });
                            }

                            // Update lastAttributes map
                            lastAttributes.clear();
                            for (var attr in realAttributes) {
                              lastAttributes[attr['attribute_id'].toString()] = attr['value'].toString();
                            }

                            // Print the updated realAttributes list
                            print('Updated realAttributes: $realAttributes');
                            print('Updated lastAttributes: $lastAttributes');

                            // Save the attribute model if needed
                            await SharedPrefManager.saveMap(AppConstants.editPropertyAttributes, lastAttributes);


                            Map<String, dynamic>? l = await SharedPrefManager.getMap(AppConstants.editPropertyAttributes);

                            print("from locale $l");
                          },
                        );
                      }).toList(),
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
        ListFeaturesWidget(propertyDetails: widget.propertyDetails, selectedSubCategoryId: subCategoryId!, token: widget.token,),

    ],
    );
  }

  _saveDate(var lastAttributes) async{
    await SharedPrefManager.saveData(AppConstants.editPropertyAttributes, lastAttributes);
  }
}


// CustomDatePicker widget
class CustomDatePicker extends StatelessWidget {
  final String label;
  final ValueChanged<DateTime> onDateChanged;

  const CustomDatePicker({
    required this.label,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              onDateChanged(pickedDate);
            }
          },
          child: const Text('Select Date'),
        ),
      ],
    );
  }
}
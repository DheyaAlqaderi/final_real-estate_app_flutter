
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/widget/custom_attribute_int.dart';
import 'package:smart_real_estate/owner/add_property/presentation/manager/create_property/create_property_cubit.dart';
import 'package:smart_real_estate/owner/add_property/presentation/pages/forth_price_add_property.dart';
import 'package:smart_real_estate/owner/add_property/presentation/widgets/dropDown_widget.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';
import '../../../../core/helper/my_model_map.dart';
import '../../../../core/utils/styles.dart';
import '../../../../features/client/alarm/data/models/attribute_alarm_model.dart';
import '../../../../features/client/alarm/presentation/manager/attribute/attribute_alarm_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/attribute/attribute_alarm_cubit_state.dart';
import 'sixth_feature_add_property.dart';

class ThirdAttributeAddProperty extends StatefulWidget {
  const ThirdAttributeAddProperty({super.key});

  @override
  State<ThirdAttributeAddProperty> createState() => _ThirdAttributeAddPropertyState();
}

class _ThirdAttributeAddPropertyState extends State<ThirdAttributeAddProperty> {
  List<Map<String, dynamic>> realAttributes = [];
  Map<String, dynamic> lastAttributes = {};
  int? sizeValue;
  int? initSizeValue;
  MyModel? _model;
  String? userToken;
  bool _loading = false;
  String? isDeleted;

  @override
  void initState() {
    _getData();
    super.initState();
    _getToken();
    _fetchData();
  }

  void _getToken() async {
    final myToken = await SharedPrefManager.getData(AppConstants.token);
    final myIsDeleted = await SharedPrefManager.getData(
        AppConstants.propertyIsDeleted);

    if (myIsDeleted != null) {
      setState(() {
        isDeleted = myIsDeleted;
        print("issssssssssssssssssssDeeeeeeeeeeeeeeleted $isDeleted");
      });
    }
    if (myToken == null) {
      Get.snackbar("you are not log in", "log in first please");
    } else {
      setState(() {
        userToken = myToken;
      });
    }
  }

  void _fetchData() async {
    final propertyCategoryId = await SharedPrefManager.getData(
        AppConstants.propertyCategoryId);
    final attributes = context.read<AttributeAlarmCubit>();

    await Future.wait([
      attributes.fetchAttributesByCategory(
          categoryId: int.parse(propertyCategoryId!)),
    ]);
  }

  Future<void> _getData() async {
    final propertyAttribute = await SharedPrefManager.getData(
        AppConstants.attributeValues);

    if (propertyAttribute != null) {
      Get.to(() => const ForthPriceAddProperty());
    }
  }


  Future<void> _NavigateToForthStep() async {
    setState(() {
      _loading = true;
    });
    _saveModel(attributes: lastAttributes);

    if (sizeValue == null) {
      setState(() {
        _loading = false;
      });
      Get.snackbar(
        "Validation Error",
        "At least add the size",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    await SharedPrefManager.saveData(
        AppConstants.propertySize, sizeValue.toString());

    /// get data from database
    final propertyName = await SharedPrefManager.getData(
        AppConstants.propertyName);
    final propertyDescription = await SharedPrefManager.getData(
        AppConstants.propertyDescription);
    final propertyCategoryId = await SharedPrefManager.getData(
        AppConstants.propertyCategoryId);
    final isForSale = await SharedPrefManager.getData(AppConstants.forSale);
    final isForRent = await SharedPrefManager.getData(AppConstants.forRent);
    Map<String, dynamic>? address = await getModel(AppConstants.addressData);
    // var address = getAddressModel();


    print("Property Name: $propertyName");
    print("Property Description: $propertyDescription");
    print("Property Category ID: $propertyCategoryId");
    print("Is For Sale: $isForSale");
    print("Is For Rent: $isForRent");
    print("Address: ${address.toString()}");
    print("Address: ${lastAttributes.toString()}");

    // Check for null values and show a message if any are null
    if (propertyName == null || propertyDescription == null ||
        propertyCategoryId == null ||
        isForSale == null || isForRent == null || address == null) {
      Get.snackbar(
        "Validation Error",
        "All fields must be filled in",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    /// got to add features
    Get.to(() => const ForthPriceAddProperty());
    setState(() {
      _loading = false;
    });
  }

  Future<void> _saveModel({required Map<String, dynamic> attributes}) async {
    MyModel model = MyModel(data: attributes);
    await saveAttributeModel(model);
    setState(() {
      _model = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: SvgPicture.asset(Images.qurterWithCurveCircle),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 100, left: 8.0, right: 8.0, top: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                        width: double.infinity,
                      ),

                      const Text("أوشكت على الانتهاء، اكتملت القائمة",
                        style: fontLargeBold,),

                      const SizedBox(
                        height: 20,
                        width: double.infinity,
                      ),

                      /// add the size
                      CustomAttributeInt(
                          initialValue: initSizeValue ?? 0,
                          onChanged: (value) {
                            setState(() {
                              sizeValue = value;
                            });

                            print(sizeValue);
                          },
                          label: "المساحة"),


                      /// the attributes comes from api
                      BlocBuilder<AttributeAlarmCubit, AttributeAlarmState>(
                        builder: (context, state) {
                          if (state is AttributeAlarmLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is AttributeAlarmLoaded) {
                            // Function to filter data based on data_type
                            List<AttributesAlarmModel> filterDataByType(
                                List<AttributesAlarmModel> data,
                                String dataType) {
                              return data.where((item) =>
                              item.dataType == dataType).toList();
                            }

                            // Convert state.attributes (list of AttributesAlarmModel) to List<Map<String, dynamic>>
                            List<AttributesAlarmModel> data = state.attributes;

                            // values = filterDataByType(data, "int").att;
                            return Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 9),
                                    const Text("خصائص العقار", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    // Example: Build CustomAttributeInt widgets for int data
                                    ...filterDataByType(data, 'int').map((
                                        attribute) {
                                      return CustomAttributeInt(
                                        initialValue: 0,
                                        label: attribute.name ?? '',
                                        onChanged: (value) {
                                          print(value);
                                          // Find if the attribute already exists in realAttributes
                                          var existingAttribute = realAttributes
                                              .firstWhere(
                                                (element) =>
                                            element['attribute_id'] ==
                                                attribute.id.toString(),
                                            orElse: () =>
                                            {
                                              'attribute_id': null,
                                              'value': null
                                            }, // Return a placeholder map
                                          );

                                          if (existingAttribute['attribute_id'] !=
                                              null) {
                                            // If the attribute exists, update its value or remove it if the value is zero
                                            if (value == 0) {
                                              realAttributes.removeWhere((
                                                  element) =>
                                              element['attribute_id'] ==
                                                  attribute.id.toString());
                                            } else {
                                              existingAttribute['value'] =
                                                  value.toString();
                                            }
                                          } else if (value != 0) {
                                            // If the attribute does not exist and the value is not zero, add a new one
                                            realAttributes.add({
                                              'attribute_id': attribute.id
                                                  .toString(),
                                              'value': value.toString(),
                                            });
                                          }

                                          // Print the updated realAttributes list
                                          print(
                                              'Updated realAttributes: $realAttributes');
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


                      /// fetch attributes string
                      BlocBuilder<AttributeAlarmCubit, AttributeAlarmState>(
                        builder: (context, state) {
                          if (state is AttributeAlarmLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is AttributeAlarmLoaded) {
                            // Function to filter data based on data_type
                            List<AttributesAlarmModel> filterDataByType(
                                List<AttributesAlarmModel> data,
                                String dataType) {
                              return data.where((item) =>
                              item.dataType == dataType).toList();
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


                            // values = filterDataByType(data, "int").att;
                            return Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6),
                                    // Example: Build CustomAttributeInt widgets for int data
                                    ...filterDataByType(data, 'string').map((
                                        attribute) {
                                      return CustomDropdownButton(
                                        options: transformToMap(
                                            attribute.valueAttribute),
                                        lable: attribute.name ?? " ",
                                        onChanged: (String id, String value) {
                                          print(
                                              'Selected ID: $id, Selected Value: $value');
                                          int intValue = int.tryParse(value) ??
                                              0;

                                          // Find if the attribute already exists in realAttributes
                                          var existingAttribute = realAttributes
                                              .firstWhere(
                                                (element) =>
                                            element['attribute_id'] == id,
                                            orElse: () =>
                                            {
                                              'attribute_id': null,
                                              'value': null
                                            }, // Return a placeholder map
                                          );


                                          realAttributes.add({
                                            'attribute_id': attribute.id,
                                            'value': value,
                                          });


                                          // Update lastAttributes map
                                          lastAttributes.clear();
                                          for (var attr in realAttributes) {
                                            lastAttributes[attr['attribute_id']
                                                .toString()] =
                                                attr['value'].toString();
                                          }

                                          // Print the updated realAttributes list
                                          print(
                                              'Updated realAttributes: $realAttributes');
                                          print(
                                              'Updated lastAttributes: $lastAttributes');
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
                                        onDateChanged: (DateTime selectedDate) {
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
                    ],
                  ),
                ),
              ),
            ),

            /// create property
            Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: InkWell(
                  onTap: _NavigateToForthStep,
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                    child: Center(
                      child: _loading
                          ? const CircularProgressIndicator()
                          : Text(
                        Locales.string(context, 'next'),
                        style: fontMediumBold.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

}
Future<void> saveAttributeModel(MyModel attribute) async {
  final prefs = await SharedPreferences.getInstance();
  String modelJson = jsonEncode(attribute.toJson());
  await prefs.setString(AppConstants.attributeValues, modelJson);
}

Future<Map<String, dynamic>?> getModel(String key) async {
  final prefs = await SharedPreferences.getInstance();
  String? modelJson = prefs.getString(key);
  if (modelJson == null) {
    return null;
  }
  Map<String, dynamic> jsonMap = jsonDecode(modelJson);
  return jsonMap;
}


Future<MyModel?> getAddressModel() async {
  final prefs = await SharedPreferences.getInstance();
  String? modelJson = prefs.getString(AppConstants.addressData);
  if (modelJson == null) {
    return null;
  }
  Map<String, dynamic> jsonMap = jsonDecode(modelJson);
  return MyModel.fromJson(jsonMap);
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
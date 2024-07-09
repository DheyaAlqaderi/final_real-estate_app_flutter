import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/owner/add_property/presentation/pages/fifth_images_add_property.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';
import '../manager/create_property/create_property_cubit.dart';


class ForthPriceAddProperty extends StatefulWidget {
  const ForthPriceAddProperty({super.key});

  @override
  State<ForthPriceAddProperty> createState() => _ForthPriceAddPropertyState();
}

class _ForthPriceAddPropertyState extends State<ForthPriceAddProperty> {
  String? propertyName;
  String? propertyDescription;
  String? propertyCategoryId;
  String? isForSale;
  String? isForRent;
  String? propertySize;
  Map<String, dynamic>? address;
  Map<String, dynamic>? attributes;
  String? pricePredict;

  String? priceValue;

  String? userToken;

  bool _loading = false;
  bool _loading1 = false;

  final TextEditingController _priceController = TextEditingController();
  String _selectedPeriod = 'شهريا'; // Default selected period

  void _selectPeriod(String period) {
    setState(() {
      _selectedPeriod = period;
    });
    if (kDebugMode) {
      print('Selected period: $period');
    }
  }


  /// create the property
  Future<void> _createPropertyAndNavigateToForthStep() async {
    setState(() {
      _loading1 = true;
    });
    if (_priceController.text.isEmpty) {
      Get.snackbar("Validation Error", "You should write a price");
      return;
    }

    setState(() {
      priceValue = _priceController.text;
    });


    await SharedPrefManager.saveData(AppConstants.propertyPrice, priceValue!);

    /// get data from database
    print("Property Name: $propertyName");
    print("Property Description: $propertyDescription");
    print("Property Category ID: $propertyCategoryId");
    print("Is For Sale: $isForSale");
    print("Is For Rent: $isForRent");
    print("Address: ${address.toString()}");
    print("Attributes: ${attributes.toString()}");

    // Check for null values and show a message if any are null
    if (propertyName == null ||
        propertyDescription == null ||
        propertyCategoryId == null ||
        isForSale == null ||
        isForRent == null ||
        address == null) {
      setState(() {
        _loading1 = false;
      });
      Get.snackbar(
        "Validation Error",
        "All fields must be filled in",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await context.read<CreatePropertyCubit>().addProperty("token $userToken", {
      "attribute_values": attributes,
      "address": address,
      "feature_data": [],
      "image_data": [],
      "name": propertyName,
      "description": propertyDescription,
      "price": priceValue,
      "size": int.parse(propertySize!),
      "is_active": false,
      "is_deleted": false,
      "for_sale": isForSale,
      "is_featured": false,
      "for_rent": isForRent,
      "category": int.parse(propertyCategoryId!)
    });

    /// go to add features
    Get.to(() => const FifthImageAddProperty());
    setState(() {
      _loading = false;
    });
  }



  Future<void> _predictBestPrice() async {
    if (_priceController.text.isEmpty) {
      Get.snackbar("Validation Error", "You should write a price");
    } else {
      setState(() {
        _loading = true;
      });

      await Future.delayed(const Duration(seconds: 2)); // Simulate a delay for the loading process

      double enteredPrice = double.parse(_priceController.text);
      Random random = Random();
      bool shouldIncrease = random.nextBool();
      double changeFactor = 0.05 + random.nextDouble() * 0.05; // Random change factor between 5% and 10%
      double predictedPrice = shouldIncrease
          ? enteredPrice * (1 + changeFactor)
          : enteredPrice * (1 - changeFactor);

      setState(() {
        pricePredict = predictedPrice.toStringAsFixed(2);
        _loading = false;
      });

      Get.snackbar("Price Prediction", "The best predicted price is \$${pricePredict}");
    }
  }

  void _getPropertyData() async {
    final myUserToken = await SharedPrefManager.getData(AppConstants.token);

    propertyName = await SharedPrefManager.getData(AppConstants.propertyName);
    propertyDescription =
    await SharedPrefManager.getData(AppConstants.propertyDescription);
    propertyCategoryId =
    await SharedPrefManager.getData(AppConstants.propertyCategoryId);
    isForSale = (await SharedPrefManager.getData(AppConstants.forSale));
    isForRent = await SharedPrefManager.getData(AppConstants.forRent);
    propertySize = await SharedPrefManager.getData(AppConstants.propertySize);
    address = await getModel(AppConstants.addressData);
    attributes = await getModel(AppConstants.attributeValues);

    if (myUserToken != null) {
      setState(() {
        userToken = myUserToken;
      });
    }

    print("Property Name: $propertyName");
    print("Property Description: $propertyDescription");
    print("Property Category ID: $propertyCategoryId");
    print("Is For Sale: $isForSale");
    print("Is For Rent: $isForRent");
    print("Size: $propertySize");
    print("Address: ${address.toString()}");
    print("Attributes: ${attributes.toString()}");
  }

  @override
  void initState() {
    super.initState();
    _getPropertyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اضافة السعر'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isForSale == "false" && isForRent == "true"?'سعر الإيجار':'سعر العقار',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.attach_money),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                        Expanded(
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '315 / ${isForSale=="false"?_selectedPeriod: " "}',
                              border: InputBorder.none,
                            ),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _predictBestPrice,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4E4C6F), // Custom color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child:  _loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            'تحسين السعر',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if(isForSale == "false")Expanded(
                        child: ElevatedButton(
                          onPressed: () => _selectPeriod('شهريا'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedPeriod == 'شهريا' ? const Color(0xFF3E6B85) : const Color(0xFFEDEDED), // Change color based on selection
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'شهريا',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _selectedPeriod == 'شهريا' ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if(isForSale == "false")Expanded(
                        child: ElevatedButton(
                          onPressed: () => _selectPeriod('سنوي'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedPeriod == 'سنوي' ? const Color(0xFF3E6B85) : const Color(0xFFEDEDED), // Change color based on selection
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'سنوي',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _selectedPeriod == 'سنوي' ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100,),
                  Text("تم تقدير السعر بموجب تحليلات دقيقه بناء على البيانات التي تم اضافتها للعقار $pricePredict" , style: fontLargeBold,),

                ],
              ),

              Positioned(
                  bottom: 20,
                  right: 20,
                  left: 20,
                  child: InkWell(
                    onTap: _createPropertyAndNavigateToForthStep,
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
                        child: _loading1
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
      ),
    );
  }


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
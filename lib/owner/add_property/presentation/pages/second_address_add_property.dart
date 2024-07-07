import 'dart:convert';
import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_real_estate/features/client/alarm/data/models/country_model.dart';
import 'package:smart_real_estate/owner/add_property/presentation/pages/third_attribute_add_property.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';
import '../../../../core/utils/styles.dart';
import '../../../../features/client/alarm/data/models/city_model.dart';
import '../../../../features/client/alarm/data/models/state_model.dart';
import '../../../../features/client/alarm/presentation/manager/address/address_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/address/city/city_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/address/city/city_cubit_state.dart';
import '../../../../features/client/alarm/presentation/manager/address/country/country_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/address/country/country_cubit_state.dart';
import '../../../../features/client/alarm/presentation/manager/address/state/state_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/address/state/state_cubit_state.dart';
import '../../../../features/client/alarm/presentation/widget/custom_dropdown_field.dart';
import '../../../../features/client/property_details/presentation/widgets/property_details_widgets/address_details_widget.dart';


class SecondAddressAddProperty extends StatefulWidget {
  const SecondAddressAddProperty({super.key});

  @override
  State<SecondAddressAddProperty> createState() => _SecondAddressAddPropertyState();
}

class _SecondAddressAddPropertyState extends State<SecondAddressAddProperty> {
  String? userId;
  String? userToken;
  CountryModel? selectedCountry, realSelectedCountry;
  CityModel? selectedCity, realSelectedCity;
  StateModel? selectedState, realSelectedState;
  int? stateId;
  late GoogleMapController _controller;
  Marker? _markers;
  LatLng _currentLatLng = LatLng(14.5678337, 43.2232772);
  MyModel? _model;


  @override
  void initState() {
    getDataAndNavigateToSecondPage(context);
    super.initState();
    _loadUserData();
    _fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      changeMapMode(_controller);
    });
  }

  /// load user data token and id
  Future<void> _loadUserData() async {
    final loadedUserId = await SharedPrefManager.getData(AppConstants.userId);
    final loadedUserToken = await SharedPrefManager.getData(AppConstants.token);

    print(loadedUserId.toString());
    setState(() {
      userId = loadedUserId ?? '';
      userToken = loadedUserToken ?? '';
    });
  }
  void _fetchData() async{
    final country = context.read<CountryCubit>();

    await Future.wait([
      country.fetchCountries(),
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            /// add address page
            SizedBox(
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100, top: 8, right: 8, left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text("أين موقع العقار", style: fontLarge,),
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

                    const SizedBox(height: 15),
                    const Text("الموقع على الخريطة", style: fontLarge,),
                    const Text("حدد موقع العقار على الخريطة من خلال النقر مرة واحدة على الموقع المطلوب", style: fontMedium,),
                    Expanded(
                      child: SizedBox(
                        height: 400,
                        width: double.infinity,
                        child:  DecoratedBox(
                          decoration: ShapeDecoration(
                            color: const Color(0xAFDCD8D8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: GoogleMap(
                            mapType: MapType.normal,
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: _currentLatLng,
                              zoom: 4,
                            ),
                            markers: _markers != null ? {_markers!} : {},
                            onCameraMove: _onCameraMove,

                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15.0,),

                    Text("${_currentLatLng.latitude} +  ${_currentLatLng.longitude}")


                  ],
                ),
              ),
            ),

            /// button to navigate
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
      )
    );
  }



  /// navigate to third page

  Future<void> _secondPage() async {
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
    try {
      // Call createAlarm method with your token and the created alarm Map
      await _saveModel(long: _currentLatLng.longitude, lat: _currentLatLng.latitude, stateId: stateId!);

      await getDataAndNavigateToSecondPage(context);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to create alarm",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _saveModel({required double long, required double lat, required int stateId}) async {
    MyModel model = MyModel(data: {
      "state": stateId,
      "longitude": long,
      "latitude": lat
    });
    await saveAddressModel(model);
    setState(() {
      _model = model;
    });
  }

  Future<void> _getModel() async {
    MyModel? model = await getAddressModel();
    setState(() {
      _model = model;
    });
  }

  Future<void> _deleteModel() async {
    await deleteAddressModel();
    setState(() {
      _model = null;
    });
  }

  /// Navigate to third page
  Future<void> getDataAndNavigateToSecondPage(BuildContext context) async {
    await _getModel();
    print(jsonEncode(_model));

    if (_model == null) {
      print("it is null");
    } else {
      stateId = _model?.data['state'];
      if(stateId == null){
        print("the state id is null");
      } else {
        print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee${stateId}");
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ThirdAttributeAddProperty()));
      }

    }
  }



  /// google map functions
  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _updateMarkerPosition(_currentLatLng);
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentLatLng = position.target;
      _updateMarkerPosition(_currentLatLng);
    });
  }

  void _updateMarkerPosition(LatLng position) {
    _markers = Marker(
      markerId: MarkerId('current_marker'),
      position: position,
      draggable: true,
      onDragEnd: (newPosition) {
        setState(() {
          _currentLatLng = newPosition;
          print('Marker moved to: Latitude: ${newPosition.latitude}, Longitude: ${newPosition.longitude}');
        });
      },
      onTap: () {
        print('Marker tapped at: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      },
    );
  }


// This is the function to load custom map style JSON
  void changeMapMode(GoogleMapController mapController) {
    getJsonFile("assets/map/map_style.json")
        .then((value) => setMapStyle(value, mapController));
  }

// Helper function
  void setMapStyle(String mapStyle, GoogleMapController mapController) {
    mapController.setMapStyle(mapStyle);
  }

// Helper function
  Future<String> getJsonFile(String path) async {
    ByteData byte = await rootBundle.load(path);
    var list = byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes);
    return utf8.decode(list);
  }
}


class MyModel {
  final Map<String, dynamic> data;

  MyModel({required this.data});

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(data: json);
  }

  Map<String, dynamic> toJson() {
    return data;
  }

  @override
  String toString() {
    return data.toString();
  }
}


Future<void> saveAddressModel(MyModel address) async {
  final prefs = await SharedPreferences.getInstance();
  String modelJson = jsonEncode(address.toJson());
  await prefs.setString(AppConstants.addressData, modelJson);
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

Future<void> deleteAddressModel() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(AppConstants.addressData);
}

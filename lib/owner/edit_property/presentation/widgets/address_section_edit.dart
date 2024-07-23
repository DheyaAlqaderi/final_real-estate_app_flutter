import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';
import '../../../../core/utils/images.dart';
import '../../../../features/client/alarm/data/models/city_model.dart';
import '../../../../features/client/alarm/data/models/country_model.dart';
import '../../../../features/client/alarm/data/models/state_model.dart';
import '../../../../features/client/alarm/presentation/manager/address/city/city_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/address/city/city_cubit_state.dart';
import '../../../../features/client/alarm/presentation/manager/address/country/country_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/address/country/country_cubit_state.dart';
import '../../../../features/client/alarm/presentation/manager/address/state/state_cubit.dart';
import '../../../../features/client/alarm/presentation/manager/address/state/state_cubit_state.dart';
import '../../../../features/client/alarm/presentation/widget/custom_dropdown_field.dart';
import 'google_map_address.dart';

class AddressSectionEdit extends StatefulWidget {
  const AddressSectionEdit({super.key, required this.propertyDetails});
  final propertyDetails;

  @override
  State<AddressSectionEdit> createState() => _AddressSectionEditState();
}

class _AddressSectionEditState extends State<AddressSectionEdit> {
  CountryModel? selectedCountry, realSelectedCountry;
  CityModel? selectedCity, realSelectedCity;
  StateModel? selectedState, realSelectedState;
  int? stateId;


  @override
  void initState() {
    super.initState();

    _fetchData();

  }

  void _fetchData() async{
    // propertyDetails.address!.state!.id;
    // propertyDetails.address!.state!.city;
    final country = context.read<CountryCubit>();
    // final city = context.read<CityCubit>();
    // final state = context.read<StateCubit>();


    await Future.wait([

    ]);
    await Future.wait([
      country.fetchCountries(),
      // city.fetchCities(countryId: widget.propertyDetails.address!.),
      // state.fetchStates(cityId: widget.propertyDetails.address!.state!.city)

    ]);
    // context.read<CityCubit>().fetchCities(countryId: selectedCountry!.id!);
    // context.read<StateCubit>().fetchStates(cityId: widget.propertyDetails.address!.state!.city);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// address
        const Text(
          'الموقع',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                onChanged: (StateModel? newValue) async {
                  setState(() {
                    selectedState = newValue;
                    stateId = selectedState!.id;

                  });
                  await SharedPrefManager.saveMap(AppConstants.editPropertyAddress, {"state": stateId});


                  Map<String, dynamic>? l = await SharedPrefManager.getMap(AppConstants.editPropertyAddress);

                  print("from locale $l");
                },
              );
            } else if (state is StateCubitFailure) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return const SizedBox();
            }
          },
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: (){
            Get.to(()=> GoogleMapAddress(addressId: widget.propertyDetails.address!.id,lat: widget.propertyDetails.address!.latitude!, lon: widget.propertyDetails.address!.longitude!,lineOnePass: widget.propertyDetails.address!.line1!, lineTwoPass: widget.propertyDetails.address!.line2!,));
          },
          child: SizedBox(
            height: 200,
            child: Column(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)
                      ),
                      image: DecorationImage(
                          image: AssetImage(Images.googleMapImage),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0)
                    ),
                    color: Colors.grey[200],
                  ),
                  child: const Center(child: Text("تعديل العلامة على الخريطة")),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

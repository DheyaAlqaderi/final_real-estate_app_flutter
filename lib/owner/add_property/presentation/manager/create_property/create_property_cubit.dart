
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';

import '../../../domain/create_property_repository.dart';
import 'create_property_cubit_state.dart';

class CreatePropertyCubit extends Cubit<CreatePropertyCubitState> {
  final CreatePropertyRepository repository;

  CreatePropertyCubit({required this.repository}) : super(CreatePropertyInitial());

  Future<void> addProperty(String token, Map<String, dynamic> request) async {
    emit(CreatePropertyLoading());
    try {
      final response = await repository.addProperty(token, request);
      emit(CreatePropertySuccess(response));
      print(jsonEncode(response));

      // Convert the response to a Map<String, dynamic>
      Map<String, dynamic> data = jsonDecode(jsonEncode(response));

      // Save the propertyId in SharedPreferences
      SharedPrefManager.saveData(AppConstants.propertyId, data['id'].toString());
    } catch (error) {
      emit(CreatePropertyFailure(error.toString()));
    }
  }
}

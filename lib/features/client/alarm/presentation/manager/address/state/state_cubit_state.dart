
import 'package:smart_real_estate/features/client/alarm/data/models/state_model.dart';



abstract class StateCubitState{}

class StateCubitInitial extends StateCubitState {}

class StateCubitLoading extends StateCubitState {}

class StateCubitLoaded extends StateCubitState {
  final List<StateModel> countries;

  StateCubitLoaded(this.countries);
}



class StateCubitFailure extends StateCubitState {
  final String error;

  StateCubitFailure(this.error);
}

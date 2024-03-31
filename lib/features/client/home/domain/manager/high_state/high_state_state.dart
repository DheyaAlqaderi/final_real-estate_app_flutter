import 'package:smart_real_estate/features/client/home/data/models/state/state_model.dart';

abstract class HighStateState {}

class InitHighStateState extends HighStateState {}

class LoadingHighStateState extends HighStateState {}

class SuccessHighStateState extends HighStateState {
  List<StateModel> stateModel;
  SuccessHighStateState(this.stateModel);
}

class ErrorHighStateState extends HighStateState {
  String error;
  ErrorHighStateState(this.error);
}
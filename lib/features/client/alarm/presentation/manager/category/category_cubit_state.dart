
import '../../../../home/data/models/category/category_model.dart';

abstract class CategoryAlarmState{}

class CategoryAlarmInitial extends CategoryAlarmState {}

class CategoryAlarmLoading extends CategoryAlarmState {}

class CategoryAlarmLoaded extends CategoryAlarmState {
  final CategoryModel category;

  CategoryAlarmLoaded(this.category);

}

class CategoryAlarmFailure extends CategoryAlarmState {
  final String error;

  CategoryAlarmFailure(this.error);

}

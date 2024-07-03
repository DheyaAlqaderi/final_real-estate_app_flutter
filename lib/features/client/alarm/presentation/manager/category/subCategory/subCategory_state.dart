
import '../../../../../home/data/models/category/category_model.dart';

abstract class SubCategoryAlarmCubitState {}

class InitSubCategoryState extends SubCategoryAlarmCubitState {}

class LoadingSubCategoryState extends SubCategoryAlarmCubitState {}

class SuccessSubCategoryState extends SubCategoryAlarmCubitState {
  CategoryModel categoryModel;
  SuccessSubCategoryState(this.categoryModel);
}

class ErrorSubCategoryState extends SubCategoryAlarmCubitState {
  String error;
  ErrorSubCategoryState(this.error);
}
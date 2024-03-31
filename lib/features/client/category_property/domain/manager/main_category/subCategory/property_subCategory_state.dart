


import '../../../../../home/data/models/category/category_model.dart';

abstract class PropertySubCategoryState {}

class InitSubCategoryState extends PropertySubCategoryState {}

class LoadingSubCategoryState extends PropertySubCategoryState {}

class SuccessSubCategoryState extends PropertySubCategoryState {
  CategoryModel categoryModel;
  SuccessSubCategoryState(this.categoryModel);
}

class ErrorSubCategoryState extends PropertySubCategoryState {
  String error;
  ErrorSubCategoryState(this.error);
}
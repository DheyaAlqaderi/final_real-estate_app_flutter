

import '../../../../data/models/category/category_model.dart';

abstract class SubCategoryState {}

class InitSubCategoryState extends SubCategoryState {}

class LoadingSubCategoryState extends SubCategoryState {}

class SuccessSubCategoryState extends SubCategoryState {
  CategoryModel categoryModel;
  SuccessSubCategoryState(this.categoryModel);
}

class ErrorSubCategoryState extends SubCategoryState {
  String error;
  ErrorSubCategoryState(this.error);
}
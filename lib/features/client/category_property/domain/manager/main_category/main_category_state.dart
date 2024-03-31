

import '../../../../home/data/models/category/category_model.dart';

abstract class MainPropertyCategoryState {}

class InitMainCategoryState extends MainPropertyCategoryState {}

class LoadingMainCategoryState extends MainPropertyCategoryState {}

class SuccessMainCategoryState extends MainPropertyCategoryState {
  CategoryModel categoryModel;
  SuccessMainCategoryState(this.categoryModel);
}

class ErrorMainCategoryState extends MainPropertyCategoryState {
  String error;
  ErrorMainCategoryState(this.error);
}
import '../../../data/models/category/category_model.dart';

abstract class MainCategoryState {}

class InitMainCategoryState extends MainCategoryState {}

class LoadingMainCategoryState extends MainCategoryState {}

class SuccessMainCategoryState extends MainCategoryState {
  CategoryModel categoryModel;
  SuccessMainCategoryState(this.categoryModel);
}

class ErrorMainCategoryState extends MainCategoryState {
  String error;
  ErrorMainCategoryState(this.error);
}
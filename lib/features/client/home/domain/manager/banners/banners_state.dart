import 'package:smart_real_estate/features/client/home/data/models/banner/banner_model.dart';

abstract class BannersState {}

class InitBannersState extends BannersState {}

class LoadingBannersState extends BannersState {}

class SuccessBannersState extends BannersState {
  List<BannerModel> bannerModel;
  SuccessBannersState(this.bannerModel);
}

class ErrorBannersState extends BannersState {
  String error;
  ErrorBannersState(this.error);
}
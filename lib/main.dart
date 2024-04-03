
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/features/client/category_property/data/remote_api/property_category_api.dart';
import 'package:smart_real_estate/features/client/category_property/domain/manager/main_category/main_property_category_cubit.dart';
import 'package:smart_real_estate/features/client/category_property/domain/manager/main_category/subCategory/property_subCategory_cubit.dart';
import 'package:smart_real_estate/features/client/category_property/domain/manager/property_cubit/property_cubit.dart';
import 'package:smart_real_estate/features/client/category_property/domain/repo_property/property_repo.dart';
import 'package:smart_real_estate/features/client/high_places/domain/high_places_repo/high_places_repo.dart';
import 'package:smart_real_estate/features/client/high_places/domain/manager/property_state_cubit/property_state_cubit.dart';
import 'package:smart_real_estate/features/client/home/data/remote_api/home_api_service.dart';
import 'package:smart_real_estate/features/client/home/domain/home_repo/home_repo.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/banners/banners_cubit.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/featured_property/featured_cubit.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/high_state/high_state_cubit.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/main_category/subCategory/subCategory_cubit.dart';
import 'package:smart_real_estate/features/client/home/domain/manager/property_home_cubit/property_home_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/data/remote_api/property_details_api.dart';
import 'package:smart_real_estate/features/client/property_details/domain/repo/property_details_repo.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/property_details/property_details_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/property_details_screen.dart';
import 'package:smart_real_estate/features/client/root/pages/root_screen.dart';

import 'core/helper/local_data/shared_pref.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'features/client/high_places/data/api/high_state_api.dart';
import 'features/client/home/domain/manager/main_category/main_category_cubit.dart';
import 'firebase_options.dart';



Future<void> main() async {

  /// 1. for Localization and Languages
  WidgetsFlutterBinding.ensureInitialized();
  await Locales.init([ 'ar']); // get last saved language

  /// 2. initialize firebase
  _initializeFirebase();

  /// 3. for buttery icons and notifications to be fixable in colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),);

  /// 4. Initialize SharedPreferences
  await SharedPrefManager.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        /// home page
        BlocProvider<MainCategoryCubit>(
          create: (_) => MainCategoryCubit(HomeRepository(HomeApiService(Dio()))),
        ),
        BlocProvider<BannersCubit>(
          create: (_) => BannersCubit(HomeRepository(HomeApiService(Dio()))),
        ),
        BlocProvider<SubCategoryCubit>(
          create: (_) => SubCategoryCubit(HomeRepository(HomeApiService(Dio()))),
        ),
        BlocProvider<HighStateCubit>(
          create: (_) => HighStateCubit(HomeRepository(HomeApiService(Dio()))),
        ),
        BlocProvider<FeaturedCubit>(
          create: (_) => FeaturedCubit(HomeRepository(HomeApiService(Dio()))),
        ),
        BlocProvider<PropertyHomeCubit>(
          create: (_) => PropertyHomeCubit(HomeRepository(HomeApiService(Dio()))),
        ),

        /// category page
        BlocProvider<MainPropertyCategoryCubit>(
          create: (_) => MainPropertyCategoryCubit(PropertyRepo(PropertyCategoryApi(Dio()))),
        ),
        BlocProvider<PropertySubCategoryCubit>(
          create: (_) => PropertySubCategoryCubit(PropertyRepo(PropertyCategoryApi(Dio()))),
        ),
        BlocProvider<PropertyCubit>(
          create: (_) => PropertyCubit(PropertyRepo(PropertyCategoryApi(Dio()))),
        ),

        /// high state page
        BlocProvider<PropertyStateCubit>(
          create: (_) => PropertyStateCubit(HighPlacesRepo(HighStateApi(Dio()))),
        ),

        /// property details page
        BlocProvider<PropertyDetailsCubit>(
          create: (_) => PropertyDetailsCubit(PropertyDetailsRepository(PropertyDetailsApi(Dio()))),
        ),
      ],
      child: LocaleBuilder(
        builder: (locale) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: light,
          darkTheme: dark,
          localizationsDelegates: Locales.delegates,
          supportedLocales: Locales.supportedLocales,
          locale: locale,
          home: const RootScreen(),
        ),
      ),
    );
  }
}

/// firebase initialization
_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

}


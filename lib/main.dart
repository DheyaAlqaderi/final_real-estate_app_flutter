
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:smart_real_estate/features/auth/presentation/cubit/signup/signup_cubit.dart';
import 'package:smart_real_estate/features/client/category_property/data/remote_api/property_category_api.dart';
import 'package:smart_real_estate/features/client/category_property/domain/manager/main_category/main_property_category_cubit.dart';
import 'package:smart_real_estate/features/client/category_property/domain/manager/main_category/subCategory/property_subCategory_cubit.dart';
import 'package:smart_real_estate/features/client/category_property/domain/manager/property_cubit/property_cubit.dart';
import 'package:smart_real_estate/features/client/category_property/domain/repo_property/property_repo.dart';
import 'package:smart_real_estate/features/client/chat/domain/repository/chat_repository.dart';
import 'package:smart_real_estate/features/client/chat/domain/repository/notification.dart';
import 'package:smart_real_estate/features/client/favorite/presentation/pages/favorite_screen.dart';
import 'package:smart_real_estate/features/client/feedback/presentation/pages/feedback_screen.dart';
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
import 'package:smart_real_estate/features/client/property_details/presentation/manager/owner_properties/property_owner_properties._cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/property_details/property_details_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/reviews/reviews_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/reviews/screen_review/review_property_rateNo_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/user_profile/property_owner_profile_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/image_details.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/property_details_screen.dart';
import 'package:smart_real_estate/features/client/root/pages/root_screen.dart';
import 'package:smart_real_estate/features/client/search/presentation/pages/search_screen.dart';
import 'package:smart_real_estate/features/notification/notification_ws_repository.dart';

import 'core/helper/local_data/shared_pref.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'features/auth/data/remote/auth_api.dart';
import 'features/auth/domain/repo/auth_repository.dart';
import 'features/client/best_seller/presentation/pages/best_seller_screen.dart';
import 'features/client/chat/domain/repository/firebase_messaging_repository.dart';
import 'features/client/high_places/data/api/high_state_api.dart';
import 'features/client/home/domain/manager/main_category/main_category_cubit.dart';
import 'firebase_options.dart';

Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
  // NotificationWsRepository.getMessage as BackgroundMessageHandler;
  if (message.notification != null) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    // Initialize notifications if not already initialized
    NotificationInitialize.initializeNotifications(flutterLocalNotificationsPlugin);

    // Show notification
    await NotificationInitialize.showNotification(
      title: message.notification!.title!,
      body: message.notification!.body!,
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    );
  }
}
Future<void> _firebaseForegroundMessage(RemoteMessage message) async {
  // NotificationWsRepository.getMessage as BackgroundMessageHandler;
  if (message.notification != null) {
    print(message.notification!.title);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    // Initialize notifications if not already initialized
    NotificationInitialize.initializeNotifications(flutterLocalNotificationsPlugin);

    // Show notification
    await NotificationInitialize.showNotification(
      title: message.notification!.title!,
      body: message.notification!.body!,
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    );
  }
}

void main() async {

  /// 1. for Localization and Languages
  WidgetsFlutterBinding.ensureInitialized();

  /// 2. initialize firebase
  await _initializeFirebase();

  await FirebaseMessagingRepository.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onMessage.listen(_firebaseForegroundMessage);
  // NotificationWsRepository.getMessage();

  /// 2.1 initialize background service
  await NotificationWsRepository.init();


  /// initialize languages
  await Locales.init([ 'ar', 'en']); // get last saved language


  /// 3. for buttery icons and notifications to be fixable in colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),);

  /// 4. Initialize SharedPreferences
  await SharedPrefManager.init();
  await SharedPrefManager.saveData(AppConstants.token, '3cbe099b83e79ab703f50eb1a09f9ad658f9fe89');
  String? token = await SharedPrefManager.getData(AppConstants.token);

  print('token is $token');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  late ChatRepository _userRepository;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userRepository = ChatRepository();
    _userId = AppConstants.userIdFake;
    WidgetsBinding.instance.addObserver(this);
    _updateUserStatus(true);
    // FlutterBackgroundService().invoke("stopService");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App is in foreground
      _updateUserStatus(true);

    } else {
      // App is in background or closed
      _updateUserStatus(false);
    }
  }

  void _updateUserStatus(bool isOnline)  {
    if (_userId.isNotEmpty) {
       _userRepository.updateUserStatus(_userId, isOnline);
    }
  }


  /// This widget is the root of your application.
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
        BlocProvider<ReviewsPropertyCubit>(
          create: (_) => ReviewsPropertyCubit(PropertyDetailsRepository(PropertyDetailsApi(Dio()))),
        ),
        BlocProvider<ReviewsPropertyByRateNoCubit>(
          create: (_) => ReviewsPropertyByRateNoCubit(PropertyDetailsRepository(PropertyDetailsApi(Dio()))),
        ),
        BlocProvider<PropertyOwnerProfileCubit>(
          create: (_) => PropertyOwnerProfileCubit(PropertyDetailsRepository(PropertyDetailsApi(Dio()))),
        ),
        BlocProvider<PropertyOwnerPropertiesCubit>(
          create: (_) => PropertyOwnerPropertiesCubit(PropertyDetailsRepository(PropertyDetailsApi(Dio()))),
        ),

        /// Auth
        BlocProvider<SignUpCubit>(
          create: (_) =>  SignUpCubit(authRepository: AuthRepository(authApi: AuthApi(Dio()))),
        ),
        BlocProvider<LoginCubit>(
          create: (_) =>  LoginCubit(authRepository: AuthRepository(authApi: AuthApi(Dio()))),
        ),
      ],
      child: LocaleBuilder(
        builder: (locale) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: light,
          darkTheme: dark,
          localizationsDelegates: Locales.delegates,
          supportedLocales: Locales.supportedLocales,
          locale: locale,
          home:   ImageDetails(),
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




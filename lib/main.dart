import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:smart_real_estate/features/auth/presentation/cubit/signup/signup_cubit.dart';
import 'package:smart_real_estate/features/auth/presentation/pages/both_auth_screen.dart';
import 'package:smart_real_estate/features/client/alarm/data/remote/alarm_api.dart';
import 'package:smart_real_estate/features/client/alarm/domain/repository/address_repo.dart';
import 'package:smart_real_estate/features/client/alarm/domain/repository/attribute_alarm_repository.dart';
import 'package:smart_real_estate/features/client/alarm/domain/repository/category_repo.dart';
import 'package:smart_real_estate/features/client/alarm/domain/repository/category_repository.dart';
import 'package:smart_real_estate/features/client/alarm/domain/repository/create_alarm_repo.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/address/address_cubit.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/address/country/country_cubit.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/address/state/state_cubit.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/attribute/attribute_alarm_cubit.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/category/category_cubit.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/category/subCategory/subCategory_cubit.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/manager/create_alarm/create_alarm_cubit.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/pages/add_alarm_screen.dart';
import 'package:smart_real_estate/features/client/category_property/data/remote_api/property_category_api.dart';
import 'package:smart_real_estate/features/client/category_property/domain/manager/main_category/main_property_category_cubit.dart';
import 'package:smart_real_estate/features/client/category_property/domain/manager/main_category/subCategory/property_subCategory_cubit.dart';
import 'package:smart_real_estate/features/client/category_property/domain/manager/property_cubit/property_cubit.dart';
import 'package:smart_real_estate/features/client/category_property/domain/repo_property/property_repo.dart';
import 'package:smart_real_estate/features/client/chat/domain/repository/chat_repository.dart';
import 'package:smart_real_estate/features/client/chat/domain/repository/notification.dart';
import 'package:smart_real_estate/features/client/high_places/domain/high_places_repo/high_places_repo.dart';
import 'package:smart_real_estate/features/client/high_places/domain/manager/property_state_cubit/property_state_cubit.dart';
import 'package:smart_real_estate/features/client/home/data/models/category/category_model.dart';
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
import 'package:smart_real_estate/features/client/root/pages/root_screen.dart';
import 'package:smart_real_estate/features/notification/notification_ws_repository.dart';
import 'package:smart_real_estate/owner/add_property/domain/create_property_repository.dart';
import 'package:smart_real_estate/owner/add_property/presentation/manager/create_property/create_property_cubit.dart';
import 'package:smart_real_estate/owner/add_property/presentation/pages/sixth_feature_add_property.dart';
import 'package:smart_real_estate/owner/edit_property/presentation/pages/edit_property_page.dart';
import 'package:smart_real_estate/owner/home/presentation/pages/owner_home_screen.dart';
import 'package:smart_real_estate/owner/owner_profile/presentation/pages/owner_profile_screen.dart';
import 'package:smart_real_estate/owner/owner_root_screen/presentation/pages/owner_root_screen.dart';

import 'core/helper/local_data/shared_pref.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'features/auth/data/remote/auth_api.dart';
import 'features/auth/domain/repo/auth_repository.dart';
import 'features/client/alarm/presentation/manager/address/city/city_cubit.dart';
import 'features/client/chat/domain/repository/firebase_messaging_repository.dart';
import 'features/client/high_places/data/api/high_state_api.dart';
import 'features/client/home/domain/manager/main_category/main_category_cubit.dart';
import 'firebase_options.dart';
import 'owner/add_property/data/models/create_property_request.dart';
import 'owner/add_property/data/remote_api/add_property_api.dart';
import 'owner/add_property/presentation/pages/forth_price_add_property.dart';
import 'owner/add_property/presentation/pages/third_attribute_add_property.dart';

Future<void> uploadProperty(BuildContext context, List<File> featureImageFiles, List<File> imageDataFiles) async {
  final dio = Dio();
  final api = AddPropertyApi(dio);

  // Create the CreatePropertyRequest object with example data
  final createPropertyRequest = CreatePropertyRequest(
    attributeValues: {"5": "ريال", "6": "Value2", "7": 3},
    address: Address(
      longitude: 2102120,
      latitude: 101210,
      line1: "102102",
      line2: "1011",
      state: 7,
    ),
    featureData: [
      FeatureData(
        id: 1,
        images: [
          ImageData(image: "feature_image_1.jpg"),
          ImageData(image: "feature_image_2.jpg"),
        ],
      ),
      FeatureData(
        id: 2,
        images: [
          ImageData(image: "feature_image_3.jpg"),
          ImageData(image: "feature_image_4.jpg"),
        ],
      ),
    ],
    imageData: [
      ImageData(image: "main_image_1.jpg"),
      ImageData(image: "main_image_2.jpg"),
    ],
    name: "خخححح",
    description: "تتتت",
    price: "100000",
    size: 10,
    isActive: false,
    isDeleted: false,
    forSale: false,
    isFeatured: false,
    forRent: false,
    category: 25,
  );

  // Prepare the list of MultipartFile for feature images
  List<MultipartFile> featureImages = [];
  for (var imageFile in featureImageFiles) {
    featureImages.add(await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last));
  }

  // Prepare the list of MultipartFile for image data
  List<MultipartFile> imageData = [];
  for (var imageFile in imageDataFiles) {
    imageData.add(await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last));
  }

  // Call the API
  try {
    final response = await api.addProperty(
      'your_auth_token_here',  // Replace with actual token
      createPropertyRequest as Map<String, dynamic>,
    );
    // Handle response
    print('Property created successfully: ${response.id}');
  } catch (e) {
    // Handle error
    print('Error creating property: $e');
  }
}

Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
  // NotificationWsRepository.getMessage as BackgroundMessageHandler;
  if (message.notification != null) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialize notifications if not already initialized
    NotificationInitialize.initializeNotifications(
        flutterLocalNotificationsPlugin);

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
    NotificationInitialize.initializeNotifications(
        flutterLocalNotificationsPlugin);

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

  /// 2 initialize background service
  await NotificationWsRepository.init();

  /// 2.1 initialize firebase
  await _initializeFirebase();
  await FirebaseMessagingRepository.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onMessage.listen(_firebaseForegroundMessage);

  /// initialize languages
  await Locales.init(['ar', 'en']); // get last saved language

  /// 3. for buttery icons and notifications to be fixable in colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  /// 4. Initialize SharedPreferences
  await SharedPrefManager.init();
  // await SharedPrefManager.deleteData(AppConstants.userId);
  // await SharedPrefManager.deleteData(AppConstants.token);
  await SharedPrefManager.saveData(
      AppConstants.token, '0a53a95704d2b4e2bf439563e02bd290c0fa0eb4');
  await SharedPrefManager.saveData(AppConstants.userId, '1');
  String? token = await SharedPrefManager.getData(AppConstants.token);
  String? id = await SharedPrefManager.getData(AppConstants.userId);

  print('token is $token');
  print('token is $id');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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

  void _updateUserStatus(bool isOnline) {
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
          create: (_) =>
              MainCategoryCubit(HomeRepository(HomeApiService(Dio()))),
        ),
        BlocProvider<BannersCubit>(
          create: (_) => BannersCubit(HomeRepository(HomeApiService(Dio()))),
        ),
        BlocProvider<SubCategoryCubit>(
          create: (_) =>
              SubCategoryCubit(HomeRepository(HomeApiService(Dio()))),
        ),
        BlocProvider<HighStateCubit>(
          create: (_) => HighStateCubit(HomeRepository(HomeApiService(Dio()))),
        ),
        BlocProvider<FeaturedCubit>(
          create: (_) => FeaturedCubit(HomeRepository(HomeApiService(Dio()))),
        ),
        BlocProvider<PropertyHomeCubit>(
          create: (_) =>
              PropertyHomeCubit(HomeRepository(HomeApiService(Dio()))),
        ),

        /// category page
        BlocProvider<MainPropertyCategoryCubit>(
          create: (_) => MainPropertyCategoryCubit(
              PropertyRepo(PropertyCategoryApi(Dio()))),
        ),
        BlocProvider<PropertySubCategoryCubit>(
          create: (_) => PropertySubCategoryCubit(
              PropertyRepo(PropertyCategoryApi(Dio()))),
        ),
        BlocProvider<PropertyCubit>(
          create: (_) =>
              PropertyCubit(PropertyRepo(PropertyCategoryApi(Dio()))),
        ),

        /// high state page
        BlocProvider<PropertyStateCubit>(
          create: (_) =>
              PropertyStateCubit(HighPlacesRepo(HighStateApi(Dio()))),
        ),

        /// property details page
        BlocProvider<PropertyDetailsCubit>(
          create: (_) => PropertyDetailsCubit(
              PropertyDetailsRepository(PropertyDetailsApi(Dio()))),
        ),
        BlocProvider<ReviewsPropertyCubit>(
          create: (_) => ReviewsPropertyCubit(
              PropertyDetailsRepository(PropertyDetailsApi(Dio()))),
        ),
        BlocProvider<ReviewsPropertyByRateNoCubit>(
          create: (_) => ReviewsPropertyByRateNoCubit(
              PropertyDetailsRepository(PropertyDetailsApi(Dio()))),
        ),
        BlocProvider<PropertyOwnerProfileCubit>(
          create: (_) => PropertyOwnerProfileCubit(
              PropertyDetailsRepository(PropertyDetailsApi(Dio()))),
        ),
        BlocProvider<PropertyOwnerPropertiesCubit>(
          create: (_) => PropertyOwnerPropertiesCubit(
              PropertyDetailsRepository(PropertyDetailsApi(Dio()))),
        ),

        /// Auth
        BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(
              authRepository: AuthRepository(authApi: AuthApi(Dio()))),
        ),
        BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(
              authRepository: AuthRepository(authApi: AuthApi(Dio()))),
        ),

        /// alarm page
        BlocProvider<CreateAlarmCubit>(
          create: (_) => CreateAlarmCubit(
              repository: CreateAlarmRepository(alarmApi: AlarmApi(Dio()))),),
        BlocProvider<AddressCubit>(
          create: (_) => AddressCubit(repository: AddressRepository(alarmApi: AlarmApi(Dio()))),),
        BlocProvider<CategoryAlarmCubit>(
          create: (_) => CategoryAlarmCubit(repository: CategoryAlarmRepository(AlarmApi(Dio()))),),
        BlocProvider<SubCategoryAlarmCubit>(
          create: (_) => SubCategoryAlarmCubit(CategoryAlarmRepository(AlarmApi(Dio()))),),
        BlocProvider<AttributeAlarmCubit>(
          create: (_) => AttributeAlarmCubit(repository: AttributeAlarmRepository(AlarmApi(Dio()))),),

        BlocProvider<CountryCubit>(
          create: (_) => CountryCubit(repository: AddressRepository(alarmApi: AlarmApi(Dio()))),),
        BlocProvider<CityCubit>(
          create: (_) => CityCubit(repository: AddressRepository(alarmApi: AlarmApi(Dio()))),),
        BlocProvider<StateCubit>(
          create: (_) => StateCubit(repository: AddressRepository(alarmApi: AlarmApi(Dio()))),),


        /// add property
        BlocProvider<CreatePropertyCubit>(
          create: (_) => CreatePropertyCubit(repository: CreatePropertyRepository(api: AddPropertyApi(Dio())))),

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
          // home: const BothAuthScreen(isOwner: false,),
          home:  RootScreen(),
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

/// Class to handle isolating any function
class IsolateRunner<T> {
  final Function function;
  final List<dynamic> params;

  IsolateRunner(this.function, this.params);

  Future<T> run() async {
    // Create a ReceivePort for communication with the isolate
    final receivePort = ReceivePort();

    // Spawn an isolate
    await Isolate.spawn(
        _isolateEntry, [receivePort.sendPort, function, params]);

    // Wait for the result from the isolate
    final result = await receivePort.first as T;

    // Return the result
    return result;
  }

  // Entry point for the isolate
  static void _isolateEntry(List<dynamic> args) {
    final sendPort = args[0] as SendPort;
    final function = args[1] as Function;
    final params = args[2] as List<dynamic>;

    // Execute the function with the provided parameters
    final result = Function.apply(function, params);

    // Send the result back to the main isolate
    sendPort.send(result);
  }
}

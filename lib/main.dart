
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_locales/flutter_locales.dart';
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
import 'package:smart_real_estate/features/client/favorite/data/models/favorite_model.dart';
import 'package:smart_real_estate/features/client/favorite/presentation/pages/favorite_screen.dart';
import 'package:smart_real_estate/features/client/favorite/presentation/widgets/favorite_widget_temp.dart';
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
import 'package:smart_real_estate/features/client/root/pages/root_screen.dart';
import 'package:smart_real_estate/features/notification/notification_ws_repository.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'core/helper/local_data/shared_pref.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'features/auth/data/remote/auth_api.dart';
import 'features/auth/domain/repo/auth_repository.dart';
import 'features/client/add_reviews/presentation/pages/add_reviews.dart';
import 'features/client/category_property/widget/subCategory_widget.dart';
import 'features/client/chat/domain/repository/firebase_messaging_repository.dart';
import 'features/client/high_places/data/api/high_state_api.dart';
import 'features/client/home/domain/manager/main_category/main_category_cubit.dart';
import 'firebase_options.dart';

Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
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

// Future<void> _connectToWebsocket() async {
//   // WebSocket server URL
//   final wsUrl = Uri.parse('ws://192.168.0.117:8000/ws/notifications/');
//
//   // Additional headers
//   final headers = {
//     'Authorization': 'cd1078633312c7a901f81ba427bf641b8f5113f2',
//     // Add any other headers if needed
//   };
//
//   try {
//     // Connect to WebSocket server with headers
//     final channel = IOWebSocketChannel.connect(wsUrl, headers: headers);
//
//     // Wait for the connection to be established
//     await channel.stream.first;
//
//     // Send a message
//     final message = jsonEncode({
//       "command": " ",
//       "page_number": 1
//     });
//     channel.sink.add(message);
//
//     // Listen for messages from the server
//     final subscription = channel.stream.listen((message) {
//       print('Received: $message');
//       // Close the connection
//       channel.sink.close();
//     });
//
//     // Set a timer for timeout
//     const timeoutDuration = Duration(seconds: 10);
//     Timer(timeoutDuration, () {
//       if (!subscription.isPaused) {
//         // If no message received within timeout, print a message
//         print('No message received within timeout.');
//         // Close the connection
//         channel.sink.close();
//       }
//     });
//
//     // Catch any errors during the process
//     channel.stream.handleError((error) {
//       print('Error: $error');
//       // Close the connection
//       channel.sink.close();
//     });
//   } catch (e) {
//     print('Error connecting to WebSocket: $e');
//   }
// }
void main() async {

  /// 1. for Localization and Languages
  WidgetsFlutterBinding.ensureInitialized();


  /// 2. initialize firebase
  await _initializeFirebase();
  await FirebaseMessagingRepository.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onMessage.listen(_firebaseForegroundMessage);

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
  await SharedPrefManager.saveData(AppConstants.token, 'cd1078633312c7a901f81ba427bf641b8f5113f2');
  String? token = await SharedPrefManager.getData(AppConstants.token);

  print('token is $token');
  runApp(MyApp(channel: IOWebSocketChannel.connect(
      'ws://192.168.0.117:8000/ws/notifications/',
      headers: {
    'Authorization': token ?? "",
      }),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.channel});
  final WebSocketChannel channel;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  late ChatRepository _userRepository;
  late String _userId;

  @override
  void initState() {//
    super.initState();
    _userRepository = ChatRepository();
    _userId = AppConstants.userIdFake;
    WidgetsBinding.instance.addObserver(this);
    _updateUserStatus(true);
    getMessage();
  }

  void getMessage(){
    // final message = jsonEncode({
    //   "command": " ",
    //   "page_number": 1
    // });
    // widget.channel.sink.add(message);
    widget.channel.stream.listen((event) async {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

      // Initialize notifications if not already initialized
      NotificationInitialize.initializeNotifications(flutterLocalNotificationsPlugin);

      // Parse the JSON string into a Map
      Map<String, dynamic> data = jsonDecode(event);

      // Access the properties
      String title1 = data['notifications']['notifications']['verb'];
      String body = data['notifications']['notifications']['verb'];

      // Initialize FlutterLocalNotificationsPlugin and show notification
      await NotificationInitialize.showNotification(
        title: title1,
        body: body,
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
      );

      print(event);
    });
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
        builder: (locale) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: light,
          darkTheme: dark,
          localizationsDelegates: Locales.delegates,
          supportedLocales: Locales.supportedLocales,
          locale: locale,
          home:  const RootScreen(),
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




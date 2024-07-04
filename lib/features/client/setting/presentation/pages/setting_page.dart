import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/features/auth/domain/repo/auth_repository.dart';
import 'package:smart_real_estate/features/auth/presentation/pages/both_auth_screen.dart';
import 'package:smart_real_estate/features/client/alarm/presentation/pages/add_alarm_screen.dart';
import 'package:smart_real_estate/features/client/chat/presentation/pages/rooms_screen.dart';
import 'package:smart_real_estate/features/client/feedback/presentation/pages/feedback_screen.dart';
import 'package:smart_real_estate/features/client/root/pages/root_screen.dart';
import 'package:smart_real_estate/features/common_widget/pop_up_massage.dart';
import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/helper/local_data/shared_pref.dart';
import '../../../feedback/presentation/widgets/appBar.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../widgets/profile.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {


  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final loadedUserId = await SharedPrefManager.getData(AppConstants.userId);
    print(loadedUserId.toString());
    setState(() {
      userId = loadedUserId ?? '';
    });
  }

  bool checkIfLogIn(){
    return userId != null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:AppBarWidget(
      //   title: 'setting_title',
      //   onTap: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context)=>const RootScreen(),));
      //   },
      // ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: userId!.isNotEmpty
              ?Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20,),

              SettingTemplete(
                hamzah:'profile_title',
                path: Images.profileIcon,
                flag: true,
                onTap: (){
                  if(checkIfLogIn()) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder:
                            (context) => const ProfileScreen())
                    );
                  } else{
                    showLoginPopup();
                  }
                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'add_alarm_notification',
                path: Images.guideLines,
                flag: false,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const AddAlarmScreen())
                  );
                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'owner_page',
                path: Images.userPage,
                flag: false,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const ProfileScreen())
                  );
                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'language',
                path: Images.language,
                flag: true,
                onTap: (){
                  _showLanguageBottomSheet(context);
                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'notification',
                path: Images.notification,
                flag: true,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const ProfileScreen())
                  );
                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'customer_service',
                path: Images.notification,
                flag: false,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const FeedbackScreen())
                  );
                },
              ),

              const SizedBox(height: 30.0,),

              Text(Locales.string(context, "information"),style:const TextStyle(color: Colors.grey)),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'version',
                path: Images.version,
                flag: true,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const ProfileScreen())
                  );
                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'terms_of_service',
                path: Images.termsOfService,
                flag: true,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const ProfileScreen())
                  );
                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'privacy_policy',
                path: Images.privacyPolicy,
                flag: true,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const ProfileScreen())
                  );
                },
              ),

              const SizedBox(height: 15.0,),

              InkWell(
                onTap: () async {
                  bool confirmLogout = await Get.defaultDialog(
                    title: 'Confirm Logout',
                    middleText: 'Are you sure you want to logout?',
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: const Text('Logout'),
                      ),
                    ],
                  );

                  if (confirmLogout ?? false) {
                    // Perform logout action
                    await AuthRepository.logout();
                    // Navigate to login screen or root screen
                    Get.offAll(() => const RootScreen());
                  }

                },
                  child: Text(Locales.string(context, "logout"),style:const TextStyle(fontSize: 19,color: Colors.blue))),




            ],




          )
              :Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20,),


              SettingTemplete(
                hamzah:'add_alarm_notification',
                path: Images.guideLines,
                flag: false,
                onTap: (){

                    showLoginPopup();

                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'owner_page',
                path: Images.userPage,
                flag: false,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const ProfileScreen())
                  );
                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'language',
                path: Images.language,
                flag: true,
                onTap: (){
                  _showLanguageBottomSheet(context);
                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'notification',
                path: Images.notification,
                flag: true,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const ProfileScreen())
                  );
                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'customer_service',
                path: Images.notification,
                flag: false,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const FeedbackScreen())
                  );
                },
              ),

              const SizedBox(height: 30.0,),

              Text(Locales.string(context, "information"),style:const TextStyle(color: Colors.grey)),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'version',
                path: Images.version,
                flag: true,
                onTap: (){

                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'terms_of_service',
                path: Images.termsOfService,
                flag: true,
                onTap: (){

                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'privacy_policy',
                path: Images.privacyPolicy,
                flag: true,
                onTap: (){

                },
              ),

              const SizedBox(height: 15.0,),

              InkWell(
                onTap: (){
                  Get.to(() => const BothAuthScreen(isOwner: false));
                },
                  child: Text(Locales.string(context, "login"),style:const TextStyle(fontSize: 19,color: Colors.blue))),

            ],
          ),
        ),
      ),
    );
  }
  void _showLanguageBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Text(
                    'Select Language',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.blue),
                    title: const Text('English'),
                    onTap: () {
                      Get.updateLocale(const Locale('en', 'US'));
                      Get.back();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.green),
                    title: const Text('Arabic'),
                    onTap: () {
                      Get.updateLocale(const Locale('ar', 'SA'));
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

}


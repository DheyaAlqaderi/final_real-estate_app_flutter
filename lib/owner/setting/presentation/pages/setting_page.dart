import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/features/client/root/pages/root_screen.dart';
import 'package:smart_real_estate/owner/owner_profile/presentation/pages/owner_profile_screen.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';
import '../../../../features/auth/domain/repo/auth_repository.dart';
import '../../../../features/auth/presentation/pages/both_auth_screen.dart';
import '../../../../features/client/feedback/presentation/widgets/appBar.dart';
import '../../../../features/client/profile/presentation/pages/profile_screen.dart';
import '../../../../features/common_widget/pop_up_massage.dart';
import '../../../notification/presentation/pages/notification_screen.dart';
import '../widgets/profile.dart';


class SettingOwnerScreen extends StatefulWidget {
  const SettingOwnerScreen({super.key});

  @override
  State<SettingOwnerScreen> createState() => _SettingOwnerScreenState();
}

class _SettingOwnerScreenState extends State<SettingOwnerScreen> {

  int? id;
  String? token;
  String?userId;

  @override
  void initState() {
    super.initState();
    fetchId();
    _loadUserId();
  }

  Future<void> fetchId() async {
    await SharedPrefManager.init();
    String? idf = await SharedPrefManager.getData(AppConstants.userId);
    String? mToken = await SharedPrefManager.getData(AppConstants.token);

    setState(() {
      id = idf != null ? int.parse(idf) : null;
      token = mToken ?? " ";
    });
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
      appBar:AppBarWidget(
        title: 'setting_title',
        onTap: () {
          navigator?.pop(context);
        },
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: userId!.isNotEmpty
           ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20,),

              SettingTemplete(
                hamzah:'profile_title',
                path: Images.profileIcon,
                flag: true,
                onTap: (){
                  Get.to(const OwnerProfileScreen());
                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'guide_lines',
                path: Images.guideLines,
                flag: true,
                onTap: (){
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context)=> const ProfileScreen())
                  // );
                },
              ),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'user_page',
                path: Images.userPage,
                flag: true,
                onTap: (){
                  Get.to(const RootScreen());
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
                  Get.to(NotificationScreen(token: token!,));
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
            hamzah:'profile_title',
            path: Images.profileIcon,
            flag: true,
            onTap: (){
              Get.to(const OwnerProfileScreen());
            },
          ),
          const SizedBox(height: 15,),


          SettingTemplete(
            hamzah:'guide_lines',
            path: Images.guideLines,
            flag: true,
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context)=> const ProfileScreen())
              // );
            },
          ),

        const SizedBox(height: 15,),

        SettingTemplete(
          hamzah:'user_page',
          path: Images.userPage,
          flag: true,
          onTap: (){
            Get.to(const RootScreen());
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
            Get.to(NotificationScreen(token: token!));
          },
        ),

        const SizedBox(height: 15,),



        // const SizedBox(height: 30.0,),

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

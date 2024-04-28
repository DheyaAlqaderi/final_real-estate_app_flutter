import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/features/client/profile/pages/profile_screen.dart';

import '../../../../features/client/feedback/presentation/widgets/appBar.dart';
import '../../../../features/client/home/pages/home_screen.dart';
import '../widgets/profile.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBarWidget(
        title: 'setting_title',
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=>const HomeScreen(),));
        },
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20,),

              SettingTemplete(
                hamzah:'profile_title',
                path: Images.profileIcon,
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
                hamzah:'guide_lines',
                path: Images.guideLines,
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
                hamzah:'user_page',
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
                hamzah:'notification',
                path: Images.notification,
                flag: false,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const ProfileScreen())
                  );
                },
              ),

              const SizedBox(height: 30.0,),

              Text(Locales.string(context, "information"),style:const TextStyle(color: Colors.grey)),

              const SizedBox(height: 15,),

              SettingTemplete(
                hamzah:'version',
                path: Images.version,
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
                hamzah:'terms_of_service',
                path: Images.termsOfService,
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
                hamzah:'privacy_policy',
                path: Images.privacyPolicy,
                flag: false,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const ProfileScreen())
                  );
                },
              ),

              const SizedBox(height: 15.0,),

              Text(Locales.string(context, "logout"),style:const TextStyle(fontSize: 19,color: Colors.blue)),




            ],




          ),
        ),
      ),









    );
  }
}

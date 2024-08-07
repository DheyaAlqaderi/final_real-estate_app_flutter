import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';
import 'package:smart_real_estate/features/client/root/pages/root_screen.dart';
import 'package:smart_real_estate/owner/add_property/presentation/pages/first_add_property.dart';
import 'package:smart_real_estate/owner/add_property/presentation/pages/navigate_add_property.dart';
import 'package:smart_real_estate/owner/owner_profile/presentation/pages/owner_profile_screen.dart';

import '../../../../core/utils/images.dart';
import '../../../../features/client/chat/presentation/pages/rooms_screen.dart';
import '../../../../features/client/favorite/presentation/pages/favorite_screen.dart';
import '../../../../features/client/profile/presentation/pages/profile_screen.dart';
import '../../../../features/common_widget/bottom_nav.dart';
import '../../../home/presentation/pages/owner_home_screen.dart';


class OwnerRootScreen extends StatefulWidget {
  const OwnerRootScreen({super.key});

  @override
  State<OwnerRootScreen> createState() => _OwnerRootScreenState();
}

class _OwnerRootScreenState extends State<OwnerRootScreen> {

  late List<String> titleList;
  int _bottomNavIndex = 0;
  String userType= "";

  List<Widget> pages = [
    const OwnerHomeScreen(),
    const RoomsScreen(),
    const NavigateToAddProperty(),
    const OwnerProfileScreen(),
  ];


  Future<void> checkIfOwner()async{
    final mUserType = await SharedPrefManager.getData(AppConstants.userType);

    if(mUserType == null || mUserType == "customer"){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RootScreen()));
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    titleList = [
      Locales.string(context, "home"),
      Locales.string(context, "chat_box"),
      Locales.string(context, "add"),
      Locales.string(context, "profile"),
    ];
  }

  final List<IconData> lineIconsList = [
    LineIcons.home,
    LineIcons.alternateMedicalChat,
    LineIcons.heart,
    LineIcons.user,
  ];

  final List<String> iconSvg = [
    Images.homeIcon,
    Images.chatIcon,
    Images.addNavIcon,
    Images.settingIcon,
  ];

  @override
  void initState() {
    super.initState();
    checkIfOwner();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: IndexedStack(
          index: _bottomNavIndex,
          children: pages,
        ),
      ),
        bottomNavigationBar: BottomNav(
          bottomNavIndex: _bottomNavIndex,
          titles: titleList,
          icons: lineIconsList,
          onTabChange: (index) {
            setState(() {
              _bottomNavIndex = index;
              if(index == 2){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstAddProperty()));
              }
            });
          },
          iconSvg: iconSvg,
        ),

    );
  }
}

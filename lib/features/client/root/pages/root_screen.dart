import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_real_estate/features/client/chat/pages/rooms_screen.dart';
import 'package:smart_real_estate/features/client/favorite/pages/favorite_screen.dart';
import 'package:smart_real_estate/features/client/home/pages/home_screen.dart';
import 'package:smart_real_estate/features/client/profile/pages/profile_screen.dart';

import '../../../common_widget/bottom_nav.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<String> titleList;
  int _bottomNavIndex = 0;

  List<Widget> pages = [
    const HomeScreen(),
    const RoomsScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    titleList = [
      Locales.string(context, "home"),
      Locales.string(context, "chat_box"),
      Locales.string(context, "favorite"),
      Locales.string(context, "profile"),
    ];
  }

  final List<IconData> lineIconsList = [
    LineIcons.home,
    LineIcons.alternateMedicalChat,
    LineIcons.heart,
    LineIcons.user,
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: _bottomNavIndex != 0
          ? buildAppBar()
          : null,
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
          });
        },
      ),
      floatingActionButton: buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }





  Widget buildFloatingActionButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 70),
      width: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
        },
        tooltip: 'Open the Map',
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: const Icon(
          Icons.map,
          color: Colors.black,
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titleList[_bottomNavIndex],
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          const Icon(Icons.notifications, color: Colors.black, size: 30.0),
        ],
      ),
      elevation: 0.0,
    );
  }


}

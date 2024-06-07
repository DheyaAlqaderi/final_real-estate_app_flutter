import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/features/client/favorite/presentation/pages/favorite_screen.dart';
import 'package:smart_real_estate/features/client/home/pages/home_screen.dart';
import 'package:smart_real_estate/features/client/setting/presentation/pages/setting_page.dart';
import '../../../../core/utils/styles.dart';
import '../../../common_widget/bottom_nav.dart';
import '../../alarm/presentation/pages/add_alarm_screen.dart';
import '../../chat/presentation/pages/rooms_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>{

  late List<String> titleList;
  int _bottomNavIndex = 0;

  List<Widget> pages = [
    const HomeScreen(),
    const RoomsScreen(),
    const FavoriteScreen(),
    const SettingScreen(),
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

  final List<String> iconSvg = [
    Images.homeIcon,
    Images.chatIcon,
    Images.heartNavIcon,
    Images.userIcon,
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: _bottomNavIndex != 0 && _bottomNavIndex != 2
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
        iconSvg: iconSvg,
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
          _addPropertyAlarm(context);
        },
        tooltip: 'Add Alarm',
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: const Icon(
          Icons.add,
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

  _addPropertyAlarm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          color: Theme.of(context).cardColor,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.add, size: 40.0),
                        SizedBox(height: 12.0),
                        Text(
                          "أضافة عقار",
                          textAlign: TextAlign.center,
                          style: fontSmallBold,
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(Icons.add_alert, size: 40.0),
                          SizedBox(height: 12.0),
                          Text(
                            "أضافة منبة عقاري",
                            textAlign: TextAlign.center,
                            style: fontSmallBold,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(const AddAlarmScreen());
                    },
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}

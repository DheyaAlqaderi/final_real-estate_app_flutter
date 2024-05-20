// import 'package:flutter/material.dart';
// import 'package:flutter_locales/flutter_locales.dart';
// import 'package:get/get.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:smart_real_estate/core/utils/images.dart';
// import 'package:smart_real_estate/features/client/favorite/presentation/pages/favorite_screen.dart';
// import 'package:smart_real_estate/features/client/home/pages/home_screen.dart';
// import 'package:smart_real_estate/features/client/profile/pages/profile_screen.dart';
//
// import '../../../../core/utils/styles.dart';
// import '../../../common_widget/bottom_nav.dart';
// import '../../alarm/presentation/pages/add_alarm_screen.dart';
// import '../../chat/presentation/pages/rooms_screen.dart';
//
// class RootScreen extends StatefulWidget {
//   const RootScreen({super.key});
//
//   @override
//   State<RootScreen> createState() => _RootScreenState();
// }
//
// class _RootScreenState extends State<RootScreen>{
//
//   late List<String> titleList;
//   int _bottomNavIndex = 0;
//
//   List<Widget> pages = [
//     const HomeScreen(),
//     const RoomsScreen(),
//     const FavoriteScreen(),
//     const ProfileScreen(),
//   ];
//
//
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     titleList = [
//       Locales.string(context, "home"),
//       Locales.string(context, "chat_box"),
//       Locales.string(context, "favorite"),
//       Locales.string(context, "profile"),
//     ];
//   }
//
//   final List<IconData> lineIconsList = [
//     LineIcons.home,
//     LineIcons.alternateMedicalChat,
//     LineIcons.heart,
//     LineIcons.user,
//   ];
//
//   final List<String> iconSvg = [
//     Images.homeIcon,
//     Images.chatIcon,
//     Images.heartNavIcon,
//     Images.userIcon,
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: _bottomNavIndex != 0 && _bottomNavIndex != 2
//           ? buildAppBar()
//           : null,
//       body: Center(
//         child: IndexedStack(
//           index: _bottomNavIndex,
//           children: pages,
//         ),
//       ),
//       bottomNavigationBar: BottomNav(
//         bottomNavIndex: _bottomNavIndex,
//         titles: titleList,
//         icons: lineIconsList,
//         onTabChange: (index) {
//           setState(() {
//             _bottomNavIndex = index;
//           });
//         },
//         iconSvg: iconSvg,
//       ),
//       floatingActionButton: buildFloatingActionButton(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//     );
//   }
//
//
//
//
//
//   Widget buildFloatingActionButton() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 70),
//       width: 60,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.grey,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: FloatingActionButton(
//         onPressed: () {
//           _addPropertyAlarm(context);
//         },
//         tooltip: 'Add Alarm',
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         child: const Icon(
//           Icons.add,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
//
//   AppBar buildAppBar() {
//     return AppBar(
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             titleList[_bottomNavIndex],
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//               fontSize: 24,
//             ),
//           ),
//           const Icon(Icons.notifications, color: Colors.black, size: 30.0),
//         ],
//       ),
//       elevation: 0.0,
//     );
//   }
//
//   _addPropertyAlarm(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (builder) {
//         return Card(
//           color: Theme.of(context).cardColor,
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height / 5.2,
//             margin: const EdgeInsets.only(top: 8.0),
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     child: const Column(
//                       children: [
//                         Icon(Icons.add, size: 40.0),
//                         SizedBox(height: 12.0),
//                         Text(
//                           "أضافة عقار",
//                           textAlign: TextAlign.center,
//                           style: fontSmallBold,
//                         )
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: InkWell(
//                     child: const SizedBox(
//                       child: Column(
//                         children: [
//                           Icon(Icons.add_alert, size: 40.0),
//                           SizedBox(height: 12.0),
//                           Text(
//                             "أضافة منبة عقاري",
//                             textAlign: TextAlign.center,
//                             style: fontSmallBold,
//                           )
//                         ],
//                       ),
//                     ),
//                     onTap: () {
//                       Navigator.pop(context);
//                       Get.to(const AddAlarmScreen());
//                     },
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/images.dart';

class RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الملف الشخصي', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.share, color: Colors.black),
          onPressed: () {
            // Handle share
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: () {
              // Handle navigation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(Images.mePicture), // Replace with your image asset
            ),
            SizedBox(height: 8),
            Text(
              'القادري',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'alqadri.trust@gmail.com',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStatCard('5.0', '⭐⭐⭐⭐⭐'),
                buildStatCard('235', 'التقييمات'),
                buildStatCard('112', 'مباع'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chat, color: Colors.grey),
                  onPressed: () {
                    // Handle chat
                  },
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.phone, color: Colors.grey),
                  onPressed: () {
                    // Handle call
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            ListTile(
              title: Text('القوائم', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text('140', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                buildPropertyCard(Images.mePicture, 'برج الحفلات', '21, 2024 أبريل'),
                buildPropertyCard(Images.mePicture, 'البيت الحديث', '21, 2024 أبريل'),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle start chat
              },
              child: Text('ابدأ الدردشة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50), // Make the button full width
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget buildPropertyCard(String imagePath, String title, String date) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            child: Image.asset(imagePath, height: 130, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

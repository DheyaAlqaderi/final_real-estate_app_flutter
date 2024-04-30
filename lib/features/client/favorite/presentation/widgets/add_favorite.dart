import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/styles.dart';

class AddFavorite extends StatefulWidget {
  const AddFavorite({super.key});

  @override
  State<AddFavorite> createState() => _AddFavoriteState();
}

class _AddFavoriteState extends State<AddFavorite> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                ////
                print("ooooooo");
              },
              child: SvgPicture.asset(
             'assets/svg/add_favorit_button.svg',
             width: 142,
             height: 142,
           ),
            ),
            const SizedBox(height: 16),
            Text(Locales.string(context,
                "text_in_empty_favorite_page"),
              style: fontLargeBold,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(Locales.string(context,
                  "text_in_empty_favorite_page2"),
                style: fontMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],        ),
      ),
    );
  }
}

//
// import 'package:flutter/material.dart';
//
// class FavoritePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Favorite Clinics'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.favorite_border,
//               size: 100,
//               color: Colors.grey,
//             ),
//             SizedBox(height: 16),
//             Text(
//               'No Favorite Clinics',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle adding a favorite clinic
//               },
//               child: Text('Add Favorite'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
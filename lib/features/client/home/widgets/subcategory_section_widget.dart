import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

import '../data/models/category/category_model.dart';

// class SubcategoryWidget extends StatefulWidget {
//   const SubcategoryWidget({super.key, required this.categoryList, required this.onTap});
//   final List<CategoryModel> categoryList;
//   final Function(int) onTap;
//   @override
//   State<SubcategoryWidget> createState() => _SubCategoryWidgetState();
// }
//
// class _SubCategoryWidgetState extends State<SubcategoryWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(
//           widget.categoryList.length,
//               (index) => Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 2.5),
//             child: ovalImageWithName(
//                 widget.categoryList[index].imageUrl,
//                 widget.categoryList[index].name,
//                 index
//             )
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget ovalImageWithName(String image, String name, int index){
//     return InkWell(
//       onTap: () {
//         widget.onTap(index);
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(top: 9.0, left: 5, right: 5),
//         child: SizedBox(
//           width: 80.0,
//           child: Column(
//             children: [
//               CircleAvatar(
//                 radius: 35, // Adjust the radius as needed
//                 backgroundColor: Colors.white,
//                 child: ClipOval(
//                   child: Image.asset(
//                     image,
//                     fit: BoxFit.cover,
//                     width: 80, // Adjust the width and height of the image
//                     height: 80,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 5), // Add some spacing between the image and text
//               Text(
//               name,
//                 style: fontSmallBold,
//                 textAlign: TextAlign.center,
//                 maxLines: 2, // Limit the number of lines for long names
//                 overflow: TextOverflow.ellipsis, // Handle long names
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

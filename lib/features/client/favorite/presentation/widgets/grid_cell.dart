import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';



class FavoriteProperty extends StatefulWidget {

  //const FavoriteProperty({super.key, required this.imageUrl});
  //final String imageUrl;

  @override
  State<FavoriteProperty> createState() => _FavoritePropertyState();
}

class _FavoritePropertyState extends State<FavoriteProperty> {
  @override
  Widget build(BuildContext context) {
    return InkWell(

     child: Container(
       height: 10,
       width: 10,
       decoration: BoxDecoration(
           color: Colors.yellow
       ),


     )
     // color: Colors.yellow,



    );



    // return Container(
    //   height: 231,
    //   width: 160.0,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(25),
    //     color: Theme.of(context).cardColor,
    //   ),
    //   child: Column(
    //     children: [
    //       Container(
    //         height: 160.0,
    //         width: double.infinity,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(25),
    //           image: DecorationImage(
    //             image: (widget.imageUrl.isEmpty)? const CachedNetworkImageProvider(AppConstants.noImageUrl): CachedNetworkImageProvider("${AppConstants.baseUrl2}${widget.imageUrl}"),
    //             fit: BoxFit.cover
    //           )
    //         ),
    //
    //       ),
    //
    //       Text("vlkcjdvods;"),
    //       Text("1500")
    //     ],
    //   ),
    // );
  }
}

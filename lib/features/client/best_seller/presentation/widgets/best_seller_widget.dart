

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/styles.dart';

class BestSellerWidget extends StatefulWidget {

  const BestSellerWidget({super.key, required this.image, required this.name, required this.propertyCount, required this.rating});
  final String image ;
  final String name ;
  final int propertyCount ;
  final double rating ;


  @override
  State<BestSellerWidget> createState() => _BestSellerWidgetState();
}

class _BestSellerWidgetState extends State<BestSellerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 206,
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(height: 25.0,),
          Container(
            height: 99,
            width: 99,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8,),
          Text(
            widget.name,
            style: fontMediumBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            "${widget.propertyCount} ",
            style: fontSmall.copyWith(color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(" ${widget.rating}⭐ ", style: fontSmall,),

          const SizedBox(height: 10.0,),
        ],
      ),
    );
  }
}

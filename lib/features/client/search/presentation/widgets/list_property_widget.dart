import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';

import '../../../../../core/utils/styles.dart';

class ListPropertyWidget extends StatefulWidget {
  const ListPropertyWidget({super.key, this.name, this.rate, this.address, this.price, this.image});
  final name;
  final rate;
  final address;
  final price;
  final image;

  @override
  State<ListPropertyWidget> createState() => _ListPropertyWidgetState();
}

class _ListPropertyWidgetState extends State<ListPropertyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: double.infinity,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  image: DecorationImage(
                      image: widget.image != null && widget.image.isNotEmpty
                          ? CachedNetworkImageProvider("${AppConstants.baseUrl3}${widget.image[0]}")
                          : const CachedNetworkImageProvider(AppConstants.noImageUrl),
                      fit: BoxFit.cover
                  )
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.name, style: fontMedium,maxLines: 1, overflow: TextOverflow.ellipsis,),
                  Text("${widget.rate.toString()}⭐", style: fontSmallBold,maxLines: 1, overflow: TextOverflow.ellipsis,),
                  Text("${widget.address!}", style: fontSmallBold,maxLines: 1, overflow: TextOverflow.ellipsis,),
                  Text("${widget.price}", style: fontSmallBold,maxLines: 1, overflow: TextOverflow.ellipsis,),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}

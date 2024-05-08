import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key, required this.imagePath, required this.title, required this.price, required this.address, required this.isFavorite, required this.rate, required this.onTapDelete});
  final String imagePath;
  final String title;
  final String price;
  final String address;
  final bool isFavorite;
  final double rate;
  final VoidCallback onTapDelete;

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      // padding: EdgeInsets.only(bottom: 6.0),
      height: 500,
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// image section
          Flexible(
            flex: 3, // Three quarters
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0,right: 8.0,left: 8.0),
              child: Container(
                height: double.infinity, // Remove fixed height
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider("http://192.168.0.117:8000${widget.imagePath}"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: widget.onTapDelete,
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              Images.heartIcon,
                              fit: BoxFit.cover,
                              color: widget.isFavorite ? Colors.red : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0XFF234F68).withOpacity(0.8)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(widget.price, style: fontMediumBold.copyWith(color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          /// title and address section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: fontMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.address,
                        style: fontSmall.copyWith(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(" ${widget.rate}⭐ ", style: fontSmall,),
                  ],
                ),
                SizedBox(height: 10.0,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}



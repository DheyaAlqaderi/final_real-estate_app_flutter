import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

class HighPlacesWidget extends StatefulWidget {
  final image;
  final name;
  final VoidCallback onTap;
  const HighPlacesWidget({super.key, this.image, this.name, required this.onTap});

  @override
  State<HighPlacesWidget> createState() => _HighPlacesWidgetState();
}

class _HighPlacesWidgetState extends State<HighPlacesWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          height: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).cardColor,
            // boxShadow: [
            //   BoxShadow(
            //     color: Theme.of(context).shadowColor.withOpacity(0.2), // Use shadowColor from the theme with opacity
            //     spreadRadius: 2, // Spread radius of the shadow
            //     blurRadius: 4, // Blur radius of the shadow
            //     offset: const Offset(0, 2), // Offset of the shadow
            //   ),
            // ],
          ),
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.all(5.0)),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    image:  DecorationImage(
                      image: CachedNetworkImageProvider("${AppConstants.baseUrl2}${widget.image}"),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(5.0)),
              Center(
                child: Text(
                  widget.name,
                  style: fontSmall,
                ),
              ),
              const Padding(padding: EdgeInsets.all(5.0)),
            ],
          ),
        ),
      ),
    );
  }
}
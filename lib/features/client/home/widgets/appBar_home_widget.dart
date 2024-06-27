import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/dimensions.dart';
import 'package:smart_real_estate/features/common_widget/circle_button_widget_icon.dart';
class AppBarHomeWidget extends StatefulWidget {
  const AppBarHomeWidget({super.key, required this.image, required this.onAvatarTap, required this.onBillTap});
  final String image;
  final VoidCallback onAvatarTap;
  final VoidCallback onBillTap;
  @override
  State<AppBarHomeWidget> createState() => _AppBarHomeWidgetState();
}

class _AppBarHomeWidgetState extends State<AppBarHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        CircleButtonWidgetIcon(icon: Icons.notifications_none, onTap: widget.onBillTap),
        InkWell(
          onTap: widget.onAvatarTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            child: CircleAvatar(
              radius: 25, // Adjust the radius as needed
              backgroundColor: Colors.white,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.image,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}

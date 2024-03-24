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
                child: Image.asset(
                  widget.image,
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

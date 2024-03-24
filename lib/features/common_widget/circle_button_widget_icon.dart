import 'package:flutter/material.dart';

class CircleButtonWidgetIcon extends StatefulWidget {
  const CircleButtonWidgetIcon({super.key,required this.icon, required this.onTap});

  final icon;
  final VoidCallback onTap;
  @override
  State<CircleButtonWidgetIcon> createState() => _CircleButtonWidgetIconState();
}

class _CircleButtonWidgetIconState extends State<CircleButtonWidgetIcon> {
  @override
  Widget build(BuildContext context) {
    return ClipOval( // Wrap with ClipOval to make it circular
      child: OutlinedButton(
        onPressed: widget.onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero, // Remove default padding
          shape: const CircleBorder(), // Use CircleBorder to make it circular
          backgroundColor: Colors.transparent, // Transparent background
        ),
        child: SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: Icon(widget.icon, size: 20),
          ),
        ),
      ),
    );
  }
}

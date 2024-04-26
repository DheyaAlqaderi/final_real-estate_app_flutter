import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
class SettingTemplete extends StatefulWidget {
  const SettingTemplete({super.key,  required this.hamzah,required this.path, required this.onTap, required this.flag});
  final String hamzah;
  final String path;
  final VoidCallback onTap;
  final bool flag;

  @override
  State<SettingTemplete> createState() => _SettingTempleteState();
}

class _SettingTempleteState extends State<SettingTemplete> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.cyanAccent,

      onTap: widget.onTap,
      child: SizedBox(
        height: 44.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text(Locales.string(context, hamzah))
            Text(Locales.string(context, widget.hamzah,),style: fontMediumBold,),
            (widget.flag)
                ?SvgPicture.asset(widget.path,height: 24.0,width: 24.0,)
                :const SizedBox()




          ],
        ),
      ),
    );
  }
}

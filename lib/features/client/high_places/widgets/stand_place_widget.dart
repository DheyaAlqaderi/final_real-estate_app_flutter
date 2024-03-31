import 'package:flutter/material.dart';
import '../../../../core/utils/styles.dart';

class StandPlaceWidget extends StatefulWidget {
  const StandPlaceWidget({
    super.key,
    required this.name,
    required this.image,
    required this.id,
    required this.onTap,
  });

  final String name;
  final String image;
  final int id;
  final Function(int) onTap;

  @override
  State<StandPlaceWidget> createState() => _StandPlaceWidgetState();
}

class _StandPlaceWidgetState extends State<StandPlaceWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          widget.onTap(widget.id);
        },
        child: Container(
          height: 239.0,
          width: 160.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// image
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: double.infinity,
                  height: 174.55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(widget.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              /// content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Text(
                  widget.name,
                  style: fontMediumBold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

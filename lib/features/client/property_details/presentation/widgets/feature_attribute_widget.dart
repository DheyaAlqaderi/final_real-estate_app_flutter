import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

class FeatureAttributeWidget extends StatefulWidget {
  const FeatureAttributeWidget({super.key, required this.attributeName, required this.attributeValue});

  final String attributeName;
  // final String featureName;
  final String attributeValue;

  @override
  State<FeatureAttributeWidget> createState() => _FeatureAttributeWidgetState();
}

class _FeatureAttributeWidgetState extends State<FeatureAttributeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.attributeName, style: fontSmallBold,),
            const SizedBox(width: 5.0,),
            Text("\"${widget.attributeValue}\"", style: fontMedium,)
          ],
        ),
      ),
    );
  }
}

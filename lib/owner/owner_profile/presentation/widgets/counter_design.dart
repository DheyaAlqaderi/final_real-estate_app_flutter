import 'package:flutter/material.dart';

import '../../../../core/utils/styles.dart';
class CounterDesign extends StatelessWidget {
  const CounterDesign({super.key, required this.count, required this.label});
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
                height: 107,
                width: 107,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFF252B5C),
                    width: 3,
                  ),
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                  Text(
                    count as String,
                    style: fontSmallBold,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: fontSmall,
                  ),
                ],
              ),

        ),
      ],
    );
  }

}

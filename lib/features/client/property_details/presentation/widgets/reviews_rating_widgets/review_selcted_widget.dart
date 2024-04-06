import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/styles.dart';


class ReviewSelectedWidget extends StatefulWidget {
  const ReviewSelectedWidget({super.key, required this.chipSelected, required this.onChipClick, required this.index, required this.numbers});
  final List<bool> chipSelected;
  final VoidCallback onChipClick;
  final int index;
  final List<int> numbers;
  @override
  State<ReviewSelectedWidget> createState() => _ReviewSelectedWidgetState();
}

class _ReviewSelectedWidgetState extends State<ReviewSelectedWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47.0,
      width: 85.0,
      child: ActionChip(
          label: Text(
            "⭐ ${widget.numbers[widget.index].toString()}",
            style: fontMediumBold.copyWith(color: widget.chipSelected[widget.index]
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: widget.chipSelected[widget.index]
              ? const Color(0xFF234F68)
              : Theme.of(context).cardColor,
          onPressed: widget.onChipClick
      ),
    );
  }
}

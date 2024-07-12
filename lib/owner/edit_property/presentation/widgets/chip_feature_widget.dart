import 'package:flutter/material.dart';

class ChipFeatureWidget extends StatefulWidget {
  const ChipFeatureWidget({
    super.key,
    required this.feature,
    required this.chipSelected,
    required this.onChipClick,
    required this.index,
  });

  final Map<String, dynamic> feature;
  final List<bool> chipSelected;
  final VoidCallback onChipClick;
  final int index;

  @override
  State<ChipFeatureWidget> createState() => _ChipFeatureWidgetState();
}

class _ChipFeatureWidgetState extends State<ChipFeatureWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ActionChip(
        label: Text(
          widget.feature['name'].toString(),
          style: TextStyle(
            color: widget.chipSelected[widget.index]
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: widget.chipSelected[widget.index]
            ? const Color(0xFF234F68)
            : Theme.of(context).cardColor,
        onPressed: widget.onChipClick,
      ),
    );
  }
}


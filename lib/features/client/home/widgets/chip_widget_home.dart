import 'package:flutter/material.dart';


class ChipWidgetHome extends StatefulWidget {
  const ChipWidgetHome({super.key, required this.realEstateProperties, required this.chipSelected, required this.onChipClick, this.index});

  final List<String> realEstateProperties;
  final List<bool> chipSelected;
  final VoidCallback onChipClick;
  final index;

  @override
  State<ChipWidgetHome> createState() => _ChipWidgetHomeState();
}

class _ChipWidgetHomeState extends State<ChipWidgetHome> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ActionChip(
        label: Text(
          widget.realEstateProperties[widget.index],
          style: TextStyle(color: widget.chipSelected[widget.index]
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
    );;
  }
}

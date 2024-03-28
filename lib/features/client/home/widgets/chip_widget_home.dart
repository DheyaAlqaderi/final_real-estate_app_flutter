import 'package:flutter/material.dart';
import 'package:smart_real_estate/features/client/home/data/models/category/category_model.dart';


class ChipWidgetHome extends StatefulWidget {
  const ChipWidgetHome({super.key, required this.categoryModel, required this.chipSelected, required this.onChipClick, this.index});

  final CategoryModel categoryModel;
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
          widget.categoryModel.results[widget.index].name.toString(),
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
    );
  }
}

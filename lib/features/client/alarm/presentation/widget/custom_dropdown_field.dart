import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final String Function(T) itemLabelBuilder;
  final void Function(T?)? onChanged;

  const CustomDropdownField({
    super.key,
    required this.items,
    required this.itemLabelBuilder,
    this.value,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(hint),
      items: items.map<DropdownMenuItem<T>>((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabelBuilder(item)),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

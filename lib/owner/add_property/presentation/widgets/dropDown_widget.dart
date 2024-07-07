import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

class CustomDropdownButton extends StatefulWidget {
  final String lable;
  final List<Map<String, dynamic>> options;
  final Function(String id, String value) onChanged;

  const CustomDropdownButton({super.key, required this.lable, required this.options, required this.onChanged});

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.lable;
    if (widget.options.isNotEmpty) {
      selectedValue = widget.options.first['value'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(widget.lable, style: fontSmall,),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F8),
            borderRadius: BorderRadius.circular(25),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              dropdownColor: const Color(0xFFF1F3F8),
              style: const TextStyle(color: Colors.black),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                  final selectedOption = widget.options.firstWhere((option) => option['value'] == newValue);
                  widget.onChanged(selectedOption['id'].toString(), newValue);
                });
              },
              items: widget.options.map<DropdownMenuItem<String>>((Map<String, dynamic> option) {
                return DropdownMenuItem<String>(
                  value: option['value'],
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        option['value'],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return widget.options.map<Widget>((Map<String, dynamic> option) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        selectedValue,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ],
    );
  }
}

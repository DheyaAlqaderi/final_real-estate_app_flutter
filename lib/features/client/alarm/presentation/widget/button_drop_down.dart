import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';


class Attrib {
  int id;
  String value;
  int attribute;

  Attrib(this.id, this.value, this.attribute);

  // Factory method to parse JSON
  factory Attrib.fromJson(Map<String, dynamic> json) {
    return Attrib(
      json['id'] as int,
      json['value'] as String,
      json['attribute'] as int,
    );
  }
}


class SimpleDropdown extends StatelessWidget {
  final List<Attrib> attrib;
  final int index;

  const SimpleDropdown({super.key, required this.attrib, required this.index});

  @override
  Widget build(BuildContext context) {
    List<String> names = attrib.map((item) => item.value).toList();

    return ListView.builder(
      itemCount: names.length,
      itemBuilder: (context, idx) {
        return CustomDropdown<String>(
          key: Key('dropdown_$idx'),
          hintText: 'Select job role',
          items: names,
          initialItem: names[index],
          onChanged: (value) {
            print('changing value to: $value');
          },
          decoration: const CustomDropdownDecoration(
            closedFillColor: Color(0xEEEEEEFF),
          ),
        );
      },
    );
  }
}



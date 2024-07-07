import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  List<String> options = ['المخطط', 'مخطط الحي', 'مخطط المنزل', 'كلاهما'];
  String selectedValue = 'المخطط';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFF1F3F8), // Light background color
              borderRadius: BorderRadius.circular(25),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                dropdownColor: Color(0xFFF1F3F8), // Dropdown background color
                style: TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                selectedItemBuilder: (BuildContext context) {
                  return options.map<Widget>((String value) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          selectedValue,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}



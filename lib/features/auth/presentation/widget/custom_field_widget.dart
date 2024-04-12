import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
   CustomTextFieldWidget({
    super.key,
    required this.isPassword,
     required this.isPhone,
    required this.name,
    required this.controller,
    required this.hintText,
     this.textInputType,
    this.validator});

  var name;
  var controller;
  var hintText;
  var textInputType;
  bool isPassword;
  bool isPhone;
  var validator;
  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: name,
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.grey), // Default label text color
        hintStyle: const TextStyle(color: Colors.grey), // Default hint text color
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1), // Set the background color here
        prefixText:isPhone? '+967': null,

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none, // No border when focused
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none, // No border by default
        ),
      ),
    );
  }
}

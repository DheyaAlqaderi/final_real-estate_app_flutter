import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/owner/add_property/presentation/pages/first_add_property.dart';

class NavigateToAddProperty extends StatefulWidget {
  const NavigateToAddProperty({super.key});

  @override
  State<NavigateToAddProperty> createState() => _NavigateToAddPropertyState();
}

class _NavigateToAddPropertyState extends State<NavigateToAddProperty> {

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Text(Locales.string(context, 'add_property')),
        ),
      ),
    );
  }
}

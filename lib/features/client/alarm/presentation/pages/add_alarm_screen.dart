import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../../../../../core/utils/styles.dart';

class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({super.key});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // app bar section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 85.0,
                width: double.infinity,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Locales.change(context, "ar");
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Theme.of(context).cardColor,
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child:
                              Icon(Icons.arrow_back_ios_new_outlined, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 100.0),
                    Text(Locales.string(context, "add_alarm"),
                        style: fontMediumBold),
                  ],
                ),
              ),
            ),

            // alarm page section
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(color: Colors.amber),
                    child: Text("hello world"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

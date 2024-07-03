
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/styles.dart';
import '../../domain/repository/category_repo.dart';
import '../manager/selection_controller.dart';
import '../widget/selection_widget.dart';

class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({super.key});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  final SelectionController controller = Get.put(SelectionController());
  List<String> options = ['للأيجار', 'للبيــع'];
  List<String> options2 = [];

  @override
  void initState() {
    super.initState();
    fetchOptions2(); // Call the function to fetch options2 data
  }

  Future<void> fetchOptions2() async {
    try {
      List<String> fetchedOptions2 = await CategoriesRepository.fetchCategories();
      setState(() {
        options2 =  fetchedOptions2;
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch options2: $e');
    }
  }

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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text("نوع القائمة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10, // horizontal spacing between items
                      runSpacing: 20, // vertical spacing between lines
                      children: options.map((option) {
                        return SelectionButton(option: option, controller: controller);
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text("فئة العقار", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 5, // horizontal spacing between items
                      runSpacing: 10, // vertical spacing between lines
                      children: options2.map((option) {
                        return SelectionButton(option: option, controller: controller);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../manager/selection_controller.dart';

class SelectionButton extends StatelessWidget {
  final String option;
  final SelectionController controller;

  const SelectionButton({
    super.key,
    required this.option,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InkWell(
          onTap: () {
            controller.selectOption(option);
            if (kDebugMode) {
              print(option);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: controller.selectedOption.value == option
                  ? const Color(0xFF234F68)
                  : const Color(0xFFF5F4F8),
            ),
            child: IntrinsicWidth(
              child: InkWell(
                onTap: () {
                  controller.selectOption(option);
                  if (kDebugMode) {
                    print(option);
                  }
                },
                child: Container(
                  height: 47,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: controller.selectedOption.value == option
                        ? const Color(0xFF234F68)
                        : const Color(0xFFF5F4F8),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: controller.selectedOption.value == option
                              ? const Color(0xFFF5F4F8)
                              : const Color(0xFF234F68),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

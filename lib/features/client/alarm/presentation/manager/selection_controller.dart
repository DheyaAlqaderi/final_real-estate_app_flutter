import 'package:get/get.dart';

class SelectionController extends GetxController {
  var selectedOption = ''.obs;

  void selectOption(String option) {
    selectedOption.value = option;
  }
}

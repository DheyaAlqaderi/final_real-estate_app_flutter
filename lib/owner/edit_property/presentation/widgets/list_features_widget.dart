import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';
import 'package:smart_real_estate/owner/edit_property/domain/create_feature_property.dart';

import '../../domain/get_features_repository.dart';
import 'chip_feature_widget.dart';
import 'image_bottom_sheet_feature_widget.dart';


class ListFeaturesWidget extends StatefulWidget {
   ListFeaturesWidget({super.key, required this.propertyDetails, required this.selectedSubCategoryId});
  int selectedSubCategoryId;
  final propertyDetails;



  @override
  State<ListFeaturesWidget> createState() => _ListFeaturesWidgetState();
}

class _ListFeaturesWidgetState extends State<ListFeaturesWidget> {

  List<Map<String, dynamic>> features = [];
  List<bool> chipSelected2 = [];
  List<int> selectedIds = [];

  @override
  void initState() {
    super.initState();
    fetchAndSetFeatures(widget.selectedSubCategoryId);
  }

  @override
  void didUpdateWidget(covariant ListFeaturesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSubCategoryId != widget.selectedSubCategoryId) {
      fetchAndSetFeatures(widget.selectedSubCategoryId);
    }
  }

  Future<void> fetchAndSetFeatures(int categoryId) async {
    var fetchedFeatures = await FeatureRepository.fetchFeatures(categoryId: categoryId);
    setState(() {
      features = fetchedFeatures;
      chipSelected2 = List.filled(features.length, false);
    });
  }

  Future<void> onChipClick(int index) async {
    setState(() {
      chipSelected2[index] = !chipSelected2[index];
      if (chipSelected2[index]) {
        selectedIds.add(features[index]['id']);
      } else {
        selectedIds.remove(features[index]['id']);
      }
      print('Selected IDs: $selectedIds');
    });

    // Show bottom sheet only if the chip is being selected
    if (chipSelected2[index]) {
      var token = await SharedPrefManager.getData(AppConstants.token);
      var response = await CreateFeaturePropertyRepository.createFeature(propertyId: widget.propertyDetails.id, featureId: features[index]['id'], token: "0a53a95704d2b4e2bf439563e02bd290c0fa0eb4");
      if(response == {}){
        Get.snackbar('Error', 'check your internet connection');
        return;
      } else {
        Get.snackbar('Selected Feature', 'ID: ${features[index]['id']}, Name: ${features[index]['name']}');
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ImageBottomSheet(
              featureId: response['id'],
              featureName: features[index]['name'],
              propertyDetails: widget.propertyDetails,
            );
          },
        );
      }
    } else {
      Get.snackbar('Confirmation', 'Are you sure to remove the selection for ${features[index]['name']}?',
          snackPosition: SnackPosition.BOTTOM,
          mainButton: TextButton(
            onPressed: () {
              // Handle removal confirmation logic here
              setState(() {
                // Deselect the chip
                chipSelected2[index] = false;
                selectedIds.remove(features[index]['id']);
              });
              Get.back(); // Close the snackbar
            },
            child: const Text('Confirm'),
          )
      );
    }
  }

  // Future<void> _postFeatureProperty() async {
  //
  //   if(images.isEmpty){
  //     Get.snackbar("validate error", "you have to add at least one image");
  //     return;
  //   }
  //
  //
  //
  //   setState(() {
  //     propertyId = myPropertyId;
  //   });
  //
  //   for (File image in _images) {
  //     await _uploadSingleImage(image);
  //     numberImages+=1;
  //   }
  //
  //
  // }
  //
  // Future<void> _uploadSingleImage(File image) async {
  //   final url = Uri.parse('${AppConstants.baseUrl}api/image/property/create/');
  //
  //   final request = http.MultipartRequest('POST', url);
  //
  //   request.fields['object_id'] = propertyId!;
  //
  //   String fileName = image.path.split('/').last;
  //   request.files.add(await http.MultipartFile.fromPath('image', image.path));
  //
  //   request.headers['Authorization'] = 'token $userToken';
  //
  //
  //
  //   try {
  //     http.StreamedResponse response = await request.send();
  //
  //     if (response.statusCode == 201) {
  //       print(await response.stream.bytesToString());
  //
  //     } else {
  //       print(response.reasonPhrase);
  //       Get.snackbar("not uploaded", "try edit the property");
  //     }
  //   } finally {
  //     client.close();
  //     setState(() {
  //       _isUploading = false;
  //       _uploadProgress = 0.0;
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'البيئة / المرافق',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: [
            ...List.generate(
              features.length,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                child: ChipFeatureWidget(
                  feature: features[index],
                  chipSelected: chipSelected2,
                  onChipClick: () => onChipClick(index),
                  index: index,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

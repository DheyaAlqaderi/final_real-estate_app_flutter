import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../../core/constant/app_constants.dart';
import '../../../../core/helper/local_data/shared_pref.dart';
class ImageBottomSheet extends StatefulWidget {
  final int featureId;
  final String featureName;
  final dynamic propertyDetails;

  const ImageBottomSheet({
    super.key,
    required this.featureId,
    required this.featureName,
    required this.propertyDetails,
  });

  @override
  _ImageBottomSheetState createState() => _ImageBottomSheetState();
}

class _ImageBottomSheetState extends State<ImageBottomSheet> {
  final List<File> _images = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  List<dynamic> savedImages = [];
  var featureProperty;

  @override
  void initState() {
    super.initState();


    if (widget.propertyDetails.featureProperty.isNotEmpty) {
      print("feature property ${jsonEncode(widget.propertyDetails)}");

      for (var feature in widget.propertyDetails.featureProperty) {
        if (widget.featureId == feature.id) {
          featureProperty = feature;
          break; // Optional: Break if you only need the first match
        }
      }

      if (featureProperty != null) {
        savedImages = featureProperty?.image?.map((img) => img.image).toList() ?? [];
      }
    }


  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
      });
    }
  }

  Future<void> _uploadSingleImage(File image, String featureId, String userToken) async {
    final url = Uri.parse('${AppConstants.baseUrl}api/image/feature/create/');

    final request = http.MultipartRequest('POST', url);
    request.fields['object_id'] = featureId;


    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    request.headers['Authorization'] = 'token 0a53a95704d2b4e2bf439563e02bd290c0fa0eb4';

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
        Get.snackbar("Upload Failed", "Try editing the property");
      }
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  Future<void> _postFeatureProperty() async {
    if (_images.isEmpty) {
      Get.snackbar("Validation Error", "You have to add at least one image");
      return;
    }

    setState(() {
      _isUploading = true;
    });

    String featureId = widget.featureId.toString();
    String? userToken = await SharedPrefManager.getData(AppConstants.token);

    // if (userToken != null) {
      for (File image in _images) {
        await _uploadSingleImage(image, widget.featureId.toString(), "userToken");
      }
      Navigator.pop(context);
    Get.snackbar("done", "the images uploaded successfully", backgroundColor: Colors.green);
    // } else {
    //   Get.snackbar("Error", "Unable to fetch user token");
    // }

    setState(() {
      _isUploading = false;
      _images.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Images for ${widget.featureName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text('أضافة صور'),
            ),
            const SizedBox(height: 10),
            if (_isUploading) ...[
              LinearProgressIndicator(value: _uploadProgress),
              const SizedBox(height: 10),
              const Text('Uploading...'),
            ],
            const SizedBox(height: 10),
            if (savedImages.isNotEmpty) ...[
              const Text(
                'الصور المحفوظة:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: savedImages.map((img) => Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: DecorationImage(
                      image: CachedNetworkImageProvider("${AppConstants.baseUrl3}$img"),
                      fit: BoxFit.cover,
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 10),
            ],
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _images.map((image) => Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _postFeatureProperty,
              child: const Text('Upload Images'),
            ),
          ],
        ),
      ),
    );
  }
}

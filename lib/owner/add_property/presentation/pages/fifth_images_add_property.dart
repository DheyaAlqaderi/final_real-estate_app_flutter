import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/owner/owner_root_screen/presentation/pages/owner_root_screen.dart';

class FifthImageAddProperty extends StatefulWidget {
  const FifthImageAddProperty({super.key});

  @override
  State<FifthImageAddProperty> createState() => _FifthImageAddPropertyState();
}

class _FifthImageAddPropertyState extends State<FifthImageAddProperty> {
  final _formKey = GlobalKey<FormState>();

  String? propertyId;
  String? featureId;
  int numberImages = 0;

  final List<File> _images = [];
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  String? userToken;
  bool isLoading = false;


  void getToken() async {
    await SharedPrefManager.deleteData(AppConstants.propertyDescription);
    await SharedPrefManager.deleteData(AppConstants.propertyName);
    await SharedPrefManager.deleteData(AppConstants.attributeValues);
    await SharedPrefManager.deleteData(AppConstants.propertySize);
    await SharedPrefManager.deleteData(AppConstants.propertySize);
    await SharedPrefManager.deleteData(AppConstants.forRent);
    await SharedPrefManager.deleteData(AppConstants.forSale);
    await SharedPrefManager.deleteData(AppConstants.addressData);
    await SharedPrefManager.deleteData(AppConstants.propertyPrice);

    final myToken = await SharedPrefManager.getData(AppConstants.token);

    if (myToken == null) {
      Get.snackbar("You have to login first", "login");
    } else {
      userToken = myToken.toString();
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

  Future<void> _postFeatureProperty() async {
    final myPropertyId = await SharedPrefManager.getData(AppConstants.propertyId);

    if(_images.isEmpty){
      Get.snackbar("validate error", "you have to add at least one image");
      return;
    }



    setState(() {
      propertyId = myPropertyId;
    });

    for (File image in _images) {
      await _uploadSingleImage(image);
      numberImages+=1;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const OwnerRootScreen()));

  }

  Future<void> _uploadSingleImage(File image) async {
    final url = Uri.parse('${AppConstants.baseUrl}api/image/property/create/');

    final request = http.MultipartRequest('POST', url);

    request.fields['object_id'] = propertyId!;

    String fileName = image.path.split('/').last;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    request.headers['Authorization'] = 'token $userToken';

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    final client = ProgressClient(http.Client(), onProgress: (bytes, totalBytes) {
      setState(() {
        _uploadProgress = bytes / totalBytes;
      });
    });

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        print(await response.stream.bytesToString());

      } else {
        print(response.reasonPhrase);
        Get.snackbar("not uploaded", "try edit the property");
      }
    } finally {
      client.close();
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  Future<void> _requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      // The permission was granted
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
    _requestStoragePermission();
  }

  Future<bool> _onWillPop() async {

      setState(() {
        isLoading = true;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const OwnerRootScreen()));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Images Property')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'إضافة الصور إلى الخاص بالعقار',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildImageDisplay(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: const Text("Add Image"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _postFeatureProperty,
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 20),
                _buildUploadProgress(),
                const SizedBox(height: 20,),
                isLoading?const CircularProgressIndicator():const SizedBox(),
                Text("uploaded images number: $numberImages", style: fontLargeBold,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildImageDisplay() {
    return _images.isNotEmpty
        ? GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return Image.file(
          _images[index],
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );
      },
    )
        : Container();
  }

  Widget _buildUploadProgress() {
    return _isUploading
        ? Column(
      children: [
        CircularProgressIndicator(value: _uploadProgress),
        const SizedBox(height: 10),
        Text('${(_uploadProgress * 100).toStringAsFixed(0)}%'),
      ],
    )
        : Container();
  }
}



class ProgressClient extends http.BaseClient {
  final http.Client _inner;
  final void Function(int bytes, int totalBytes)? onProgress;

  ProgressClient(this._inner, {this.onProgress});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final totalBytes = request.contentLength;
    var bytes = 0;

    final stream = request.finalize().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          bytes += data.length;
          onProgress?.call(bytes, totalBytes ?? 0);
          sink.add(data);
        },
        handleError: (error, stackTrace, sink) {
          sink.addError(error, stackTrace);
        },
        handleDone: (sink) {
          sink.close();
        },
      ),
    );

    final httpRequest = http.Request(request.method, request.url)
      ..followRedirects = request.followRedirects
      ..maxRedirects = request.maxRedirects
      ..persistentConnection = request.persistentConnection
      ..headers.addAll(request.headers)
      ..body = stream.toString();

    return _inner.send(httpRequest);
  }
}
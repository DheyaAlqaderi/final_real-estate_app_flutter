import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http_parser/http_parser.dart';

class FeaturePropertyForm extends StatefulWidget {
  const FeaturePropertyForm({super.key});

  @override
  _FeaturePropertyFormState createState() => _FeaturePropertyFormState();
}

class _FeaturePropertyFormState extends State<FeaturePropertyForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _propertyController = TextEditingController();
  final TextEditingController _featureController = TextEditingController();
  List<File> _images = [];
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _postFeatureProperty() async {
    final url = Uri.parse('http://192.168.1.8:8000/api/image/feature/create/');

    final request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'property': _propertyController.text.toString(),
      'feature': _featureController.text.toString()
    });

    for (File image in _images) {
      String fileName = image.path.split('/').last;
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
      ));
    }

    // Add the images as per the specified payload structure
    // List<Map<String, String>> imageList = [];
    // for (File image in _images) {
    //   imageList.add({"image": image.path});
    // }
    // request.fields['feature_property_image'] = imageList;


    request.headers['Authorization'] = 'token 0a53a95704d2b4e2bf439563e02bd290c0fa0eb4';

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

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      }
      else {
        print(response.reasonPhrase);
      }
    } finally {
      client.close();
      setState(() {
        _isUploading = false;
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
    _requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feature Property Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _propertyController,
                decoration: InputDecoration(labelText: 'Property ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Property ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _featureController,
                decoration: InputDecoration(labelText: 'Feature ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Feature ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _postFeatureProperty();
                  }
                },
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              _images.isNotEmpty
                  ? Wrap(
                spacing: 10,
                children: _images.map((image) {
                  return Image.file(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                }).toList(),
              )
                  : Container(),
              SizedBox(height: 20),
              _isUploading
                  ? Column(
                children: [
                  CircularProgressIndicator(value: _uploadProgress),
                  SizedBox(height: 10),
                  Text('${(_uploadProgress * 100).toStringAsFixed(0)}%'),
                ],
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
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

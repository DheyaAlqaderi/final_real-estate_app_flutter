import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/features/client/profile/data/models/profile_model.dart';
import 'package:smart_real_estate/features/client/profile/domain/repositories/profile_repository.dart';
import '../../../../../core/helper/local_data/shared_pref.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/styles.dart';
import '../../../feedback/presentation/widgets/appBar.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  late ProfileRepository profileRepository;
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  bool isLoading = false;
  String? token = " ";
  File? imageFile;
  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          color: Theme.of(context).cardColor,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.image, size: 60.0),
                        SizedBox(height: 12.0),
                        Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: fontMediumBold,
                        )
                      ],
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt, size: 60.0),
                          SizedBox(height: 12.0),
                          Text(
                            "Camera",
                            textAlign: TextAlign.center,
                            style: fontMediumBold,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _imgFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  Future<void> _imgFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  Future<void> _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ]
          : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Image Cropper",
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: "Image Cropper",
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchToken();
    profileRepository = ProfileRepository(Dio());
  }

  Future<void> fetchToken() async {
    await SharedPrefManager.init();
    token = await SharedPrefManager.getData(AppConstants.token);

    print('token is $token');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBarWidget(
        title: 'personal_profile',
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body:  SingleChildScrollView(
        child: FutureBuilder<ProfileModel?>(
          future: profileRepository.getProfile(31),
          builder: (context, snapshot){
            if (snapshot.hasData){
        
              username.text = snapshot.data!.username!;
              String testUesrName = snapshot.data!.username!;
              name.text = snapshot.data!.name!;
              String testName = snapshot.data!.name!;
              phoneNumber.text = snapshot.data!.phoneNumber!;
              String testPhone = snapshot.data!.phoneNumber!;
              email.text = snapshot.data!.email!;
              String testEmail = snapshot.data!.email!;
        
        
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        showImagePicker(context);
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(snapshot.data!.image ?? AppConstants.noImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Form(
                      child:Padding(
                        padding:  const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: username,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).cardColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8), // Adjust spacing as needed
                                  child: SizedBox(
                                    width: 20, // Set the width of the SVG icon
                                    height: 20, // Set the height of the SVG icon
                                    child: SvgPicture.asset(
                                      Images.smallProfile,
                                      fit: BoxFit.none, // Ensure SVG fits within the given size
                                    ),
                                  ),
                                ),
                              ),
                            ),
        
                            const SizedBox(height: 15,),
                            TextFormField(
                              controller: name,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).cardColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8), // Adjust spacing as needed
                                  child: SizedBox(
                                    width: 20, // Set the width of the SVG icon
                                    height: 20, // Set the height of the SVG icon
                                    child: SvgPicture.asset(
                                      Images.smallProfile,
                                      fit: BoxFit.none, // Ensure SVG fits within the given size
                                    ),
                                  ),
                                ),
                              ),
                            ),
        
        
                            const SizedBox(height: 15,),
                            TextFormField(
                              controller: phoneNumber,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).cardColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8), // Adjust spacing as needed
                                  child: SizedBox(
                                    width: 20, // Set the width of the SVG icon
                                    height: 20, // Set the height of the SVG icon
                                    child: SvgPicture.asset(
                                      Images.smallCallIcon,
                                      fit: BoxFit.none, // Ensure SVG fits within the given size
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            TextFormField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).cardColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8), // Adjust spacing as needed
                                  child: SizedBox(
                                    width: 20, // Set the width of the SVG icon
                                    height: 20, // Set the height of the SVG icon
                                    child: SvgPicture.asset(
                                      Images.smallEmailIcon,
                                      fit: BoxFit.none, // Ensure SVG fits within the given size
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
        
                            ElevatedButton(
                                onPressed: () async {
                                  try{
                                    if(testUesrName != username.text){
                                      updateUser(username, "username");
                                    }
                                    if(testName != name.text){
                                      updateUser(name, "name");
                                    }
                                    if(testEmail != email.text){
                                      updateUser(email, "email");
                                    }
                                    if(testPhone != phoneNumber.text){
                                      updateUser(phoneNumber, "phone_number");
                                    }
                                    if(imageFile != null){
                                      updateUserImage(imageFile!);
                                    }
        
        
        
                                  } catch(e){
                                    print("field $e");
                                  }
                                  },

                                child: isLoading?const CircularProgressIndicator(color: Colors.white,):const Text("update")
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }else if (snapshot.hasError){
              return const SizedBox();
            }
            else {
              return  const SizedBox();
            }
          }
        ),
      ),
    );
  }
  Future<void> updateUserImage(File temp) async {
    setState(() {
      isLoading = true;
    });
    await profileRepository
        .updateProfile2(
      "token $token",
      imageFile!,
    );
    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateUser(TextEditingController temp, String key) async {
    setState(() {
      isLoading = true;
    });
    await profileRepository
        .updateProfile(
        "token $token",
        {
          key: temp.text.trim()
        },
    );
    setState(() {
      isLoading = false;
    });
  }
}
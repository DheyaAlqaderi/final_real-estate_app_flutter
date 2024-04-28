

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/feedback/presentation/widgets/appBar.dart';
import 'package:smart_real_estate/features/client/setting/presentation/pages/setting_page.dart';


class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController fullName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController whatsProblem = TextEditingController();
  final _feedbackForm = GlobalKey<FormState>();
    String _selectedItem="problem_type";
   @override
  void initState() {
    super.initState();
    // _selectedItem=Locales.string(context, "problem_type");
  }



  File? imageFile;
  final picker = ImagePicker();

  Future<void> _imgFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
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
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBarWidget(
        title: "feedback",
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=>const SettingScreen(),));
        },
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //space
              const SizedBox(height: 10,
              width: double.infinity,),
              //text
              Text(Locales.string(context, "any_ques"),style: fontLargeBold,),
              //text
              Text(Locales.string(context, "any_ques_description"),style: fontMedium,),
              //space
              const SizedBox(height: 40,),
              //form
              Form(
                key: _feedbackForm,
                  child: Column(
                    children: [
                      //name
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          hintText:Locales.string(context, "full_name"),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return Locales.string(context, "please_name");
                          }
                          if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
                            return Locales.string(context, "just_letter");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          fullName = fullName;
                          // = value!;
                        },

                        controller:fullName,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 15,),
                      //phone
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          hintText:Locales.string(context, "phone"),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return Locales.string(context, "please_phone");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          phoneNumber = phoneNumber;
                          // = value!;
                        },

                        controller:phoneNumber,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 15,),
                      //email
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          hintText:Locales.string(context, "email"),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return Locales.string(context, "please_email");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          emailAddress = emailAddress;
                          // = value!;
                        },

                        controller:emailAddress,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15,),
                      InkWell(
                        onTap: _imgFromGallery,
                        child: Container(
                          height: 65,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child:Align(
                            alignment: (Locales.currentLocale(context).toString()=="ar")
                                ?Alignment.centerRight
                                :Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                Locales.string(context, "add_image"),
                                style: fontMedium.copyWith(color: Colors.grey[7]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Container(
                        height: 65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Align(
                          alignment: (Locales.currentLocale(context).toString()=="ar")
                              ?Alignment.centerRight
                              :Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: DropdownButton<String>(
                                value: _selectedItem,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedItem = newValue!;
                                  });
                                },
                                icon: null,//
                                underline: null, // Removes the underline border
                                items: <String>["problem_type",'Option 1', 'Option 2', 'Option 3', 'Option 4', 'Option 4', 'Option 4']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: fontMedium.copyWith(color: Colors.grey),),

                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,),
                      ////////////////////////////////////////////////////////////////////

                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          hintText:Locales.string(context, "whats_problem"),

                          contentPadding: const EdgeInsets.symmetric(vertical: 35, horizontal: 8), // Adjust the vertical padding as needed
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return Locales.string(context, "please_problem");
                          }
                          return null;
                        },
                        onSaved: (value){
                          whatsProblem = whatsProblem;
                        },

                        controller:whatsProblem,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 25,),
                    ],
                  )
              ),

              //button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton(onPressed: (){
                    if(imageFile == null){
                      print("no image");
                    }
                    if(_feedbackForm.currentState!.validate()){



                      _feedbackForm.currentState!.save();
                      print('Submitted name: $fullName ');

                    }
                  },
                      child: Text(Locales.string(context, "send"),style: fontLarge,)),
                ),
              )


















              // InkWell(
              //   onTap: _imgFromGallery,
              //   child: Container(
              //     height: 65,
              //     width: 250,
              //     decoration: BoxDecoration(
              //         color: Theme.of(context).,
              //         borderRadius: BorderRadius.circular(15)
              //     ),
              //     child:Align(
              //       alignment: (Locales.currentLocale(context).toString()=="ar")
              //           ?Alignment.centerRight
              //           :Alignment.centerLeft,
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(
              //           Locales.string(context, "add_image"),
              //
              //         ),
              //       ),
              //     ),
              //   ),
              // ),




            ],
          ),
        ),
      ),





    );
  }
}

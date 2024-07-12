import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';
import 'package:smart_real_estate/core/utils/images.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/property_details_screen.dart';
import 'package:smart_real_estate/owner/edit_property/domain/test.dart';
import 'package:smart_real_estate/owner/edit_property/presentation/widgets/address_section_edit.dart';
import 'package:smart_real_estate/owner/edit_property/presentation/widgets/category_section_edit.dart';
import 'package:smart_real_estate/owner/edit_property/presentation/widgets/chip_feature_widget.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../features/client/alarm/presentation/manager/category/category_cubit.dart';
import '../../../../features/client/alarm/presentation/pages/add_alarm_screen.dart';
import '../../../../features/client/home/data/models/category/category_model.dart';
import '../../../../features/client/home/widgets/chip_widget_home.dart';
import '../../../../features/client/property_details/data/model/image_model.dart';
import '../../../../features/client/property_details/presentation/manager/property_details/property_details_cubit.dart';
import '../../../../features/client/property_details/presentation/manager/property_details/property_details_state.dart';
import '../../../add_property/presentation/pages/fifth_images_add_property.dart';
import '../../domain/get_features_repository.dart';

class EditPropertyPage extends StatefulWidget {
   const EditPropertyPage({super.key, required this.propertyId, required this.token});
   final int propertyId;
   final String token;

  @override
  State<EditPropertyPage> createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {


  TextEditingController propertyName = TextEditingController();
  TextEditingController propertyDescription = TextEditingController();
  TextEditingController propertyPrice = TextEditingController();
  TextEditingController propertySize = TextEditingController();
  TextEditingController propertyAddressLineOne = TextEditingController();
  TextEditingController propertyAddressLineTwo = TextEditingController();

  /// first add property
  String? realName, realDescription, realPrice;
  double? realSize;
  int? realSubCategoryId;
  List<Map<String, dynamic>> features = [];
  List<bool> chipSelected2 = [];
  // String? clickedChip;
  // late List<bool> chipSelected;
  // List<bool>? chipSelected3;
  // bool? chipSelected3First;
  // bool? chipSelected3Last;
  late List<bool> defaultChipSelected;
  // int? categoryId;
  // int? subCategoryId;
  // String? userId;
  // String? userToken;
  // var categoryModelList = CategoryModel.fromJson(categoryJson);

  CategoryModel? mainCategory;
  CategoryModel? subCategory;
  int? parentId;

  var globalpropertyDetails;
  /// second api attributes
  // List<Map<String, dynamic>> realAttributes = [];
  // Map<String, dynamic> lastAttributes = {};
  // int? sizeValue;
  // int? initSizeValue;
  // MyModel? _model;
  bool _loading = false;
  // String? isDeleted;
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  /// image section api
  int numberImages = 0;
  File? _image;
  bool isLoading = false;
  List<ImageModel2> imageList=[];
  String? newImagePath;


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadSingleImage(File image) async {
    final url = Uri.parse('${AppConstants.baseUrl}api/image/property/create/');

    final request = http.MultipartRequest('POST', url);

    request.fields['object_id'] = widget.propertyId.toString();

    String fileName = image.path.split('/').last;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    request.headers['Authorization'] = 'token ${widget.token}';

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });
    final client = await ProgressClient(http.Client(), onProgress: (bytes, totalBytes) {
      setState(() {
        _uploadProgress = bytes / totalBytes;
      });
    });

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        // print(await response.stream.bytesToString());

        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        setState(() {
          newImagePath = jsonResponse['image'];
        });

        Get.snackbar("Upload Successful", "Image URL: $newImagePath");
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



  /// google map


  @override
  void initState() {
    super.initState();
    getToken();


    // _loadUserData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
    // fetchAndSetFeatures();
    //
    // chipSelected = List.generate(10, (index) => false);
    // chipSelected2 = List.generate(50, (index) => false);
    // chipSelected3 = List.generate(2, (index) => false);
    // defaultChipSelected = List.generate(1, (index) => false);
  }




    /// fetch data from the server
  Future<void> fetchAndSetFeatures() async {
    var fetchedFeatures = await FeatureRepository.fetchFeatures(categoryId: 25); // Example category ID
    setState(() {
      features = fetchedFeatures;
      chipSelected2 = List.filled(features.length, false);
    });
  }
  void _fetchData() async{

    final mainCategory = context.read<CategoryAlarmCubit>();
    final propertyDetails = context.read<PropertyDetailsCubit>();
    // final attributes = context.read<AttributeAlarmCubit>();
    // final country = context.read<CountryCubit>();

    await Future.wait([

    ]);
    await Future.wait([
      mainCategory.fetchMainCategory(),
      propertyDetails.getPropertyDetails(widget.propertyId, widget.token),
      // country.fetchCountries(),
      // attributes.fetchAttributesByCategory(
      //     categoryId: subCategoryId!),
    ]);


  }

  /// function to get user id and token
  // Future<void> _loadUserData() async {
  //   final loadedUserId = await SharedPrefManager.getData(AppConstants.userId);
  //   final loadedUserToken = await SharedPrefManager.getData(AppConstants.token);
  //
  //   print(loadedUserId.toString());
  //   setState(() {
  //     userId = loadedUserId ?? '';
  //     userToken = loadedUserToken ?? '';
  //   });
  // }
  String? token;
  //
  // void _selectPropertyType(String type) {
  //   setState(() {
  //     _selectedPropertyType = type;
  //   });
  // }
  //
  // void _selectCategory(String category) {
  //   setState(() {
  //     _selectedCategory = category;
  //   });
  // }
  List<int> selectedIds = [];
  Future<void> getToken() async {
    final myToken = await SharedPrefManager.getData(AppConstants.token);

    setState(() {
      token = myToken ?? " ";
    });

    print("my toooooooookennnnn $token");
  }
  void onChipClick(int index) {
    setState(() {
      chipSelected2[index] = !chipSelected2[index];
      if (chipSelected2[index]) {
        selectedIds.add(features[index]['id']);
      } else {
        selectedIds.remove(features[index]['id']);
      }
      print('Selected IDs: $selectedIds');
    });
  }




  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        _fetchData();
      },
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: SvgPicture.asset(Images.halfCircle),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
                      builder: (context, state) {
                        if (state is PropertyDetailsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is PropertyDetailsSuccess) {
                          final propertyDetails = state.propertyDetails;

                          propertyDetails.address!.line1.toString();
                          imageList = state.propertyDetails.image!.map((imageModel) => ImageModel2(
                            image: imageModel.image,
                            id: imageModel.id,
                          )).toList();


                          globalpropertyDetails = propertyDetails;


                          print(jsonEncode(propertyDetails));
                          // categoryId = propertyDetails.category!.id;


                          // propertyDetails.featureProperty.

                          // propertyDetails.propertyValue![0].value!.value;
                          /// for name and description
                          propertyName.text = propertyDetails.name! ?? "";
                          propertyDescription.text = propertyDetails.description!?? "";
                          propertyPrice.text = propertyDetails.price! ?? "";
                          propertySize.text = propertyDetails.size!.toString() ?? "";

                          /// for type list
                          // if(propertyDetails.forSale!){
                          //   chipSelected3![0] = true;
                          // } else{
                          //   chipSelected3![1] = true;
                          // }

                          propertyDetails.name;
                          propertyDetails.description;
                          propertyDetails.price;
                          propertyDetails.size;
                          propertyDetails.category!.id;
                          propertyDetails.address!.state!.id;
                          // propertyDetails.address!.state!.id;
                          // propertyDetails.address!.
                          /// get attributes
                          // subCategoryId = propertyDetails.category!.id;
                          // context.read<AttributeAlarmCubit>().fetchAttributesByCategory(categoryId: subCategoryId!);


                          // propertyDetails.featureProperty![index].image!.first.image;
                          /// image section
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// appbar
                              const Text("تعديل العقار", style: fontMediumBold,),
                              const SizedBox(height: 10.0,),
                              /// Display property image and some details
                              GestureDetector(
                                onTap: () {
                                  // Navigate to the edit page
                                  Get.to(()=> PropertyDetailsScreen(id: widget.propertyId, token: widget.token));
                                },
                                child: _buildPropertyView(context,imageList ?? [], propertyDetails),

                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: propertyName,
                                decoration: InputDecoration(
                                  labelText: 'اسم العقار',
                                  prefixIcon: const Icon(Icons.home),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: propertyDescription,
                                decoration: InputDecoration(
                                  labelText: 'وصف العقار',
                                  prefixIcon: Icon(Icons.description),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                maxLines: null, // Makes the TextField expandable
                                minLines: 1, // Initial height of the TextField
                                keyboardType: TextInputType.multiline, // Allows multiline input
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: propertyPrice,
                                decoration: InputDecoration(
                                  labelText: 'السعر',
                                  prefixIcon: Icon(Icons.attach_money),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.number, // Ensures the keyboard is numeric
                              ),
                              const SizedBox(height: 16),

                              /// category section
                              const SizedBox(height: 16),
                              CategorySectionEdit(
                                selectedCategoryId: propertyDetails.category!.parent!,
                                selectedSubCategoryId: propertyDetails.category!.id!,
                                propertyDetails: propertyDetails,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: propertySize,
                                decoration: InputDecoration(
                                  labelText: 'المساحة',
                                  prefixIcon: Icon(Icons.square_foot),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.number, // Ensures the keyboard is numeric
                              ),
                              const SizedBox(height: 16),
                              AddressSectionEdit(propertyDetails: propertyDetails,),
                              const SizedBox(height: 16),
                              const Text(
                                'صور العقار',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8.0,
                                children: [
                                  ...imageList.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    print(index);
                                    ImageModel2 imageModel = entry.value;
                                    return _buildPropertyImage(imageModel, index);
                                  }),
                                  _buildAddImageButton(),
                                ],
                              ),
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
                              Text(jsonEncode(propertyDetails)),

                              const SizedBox(height: 100),


                              /// Displaying property rest details


                              /// Displaying property Features and Attribute
                              const SizedBox(height: 5.0,),

                              const SizedBox(height: 5.0,),


                              /// display property promoter details
                              const SizedBox(height: 10.0,),


                              /// display GoogleMap and address details
                              const SizedBox(height: 10.0,),


                              /// display reviews and Rating




                            ],
                          );
                        } else if (state is PropertyDetailsError) {
                          return Center(
                            child: Text('Error: ${state.error}'),
                          );
                        } else {
                          return const SizedBox(); // Return an empty widget if state is not recognized
                        }
                      },
                    ),
                    // child: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {
                    //         // Navigate to the edit page
                    //       },
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //             child: _buildPropertyView()
                    //           ),
                    //           const SizedBox(width: 8),
                    //           const Icon(Icons.arrow_forward),
                    //         ],
                    //       ),
                    //     ),
                    //     const SizedBox(height: 16),
                    //     TextField(
                    //       decoration: InputDecoration(
                    //         labelText: 'عنوان العقار',
                    //         prefixIcon: Icon(Icons.home),
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(height: 16),
                    //     const Text(
                    //       'نوع العقار',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     const SizedBox(height: 8),
                    //     Row(
                    //       children: [
                    //         _buildChoiceChip('بيع', _selectedPropertyType, _selectPropertyType),
                    //         SizedBox(width: 8),
                    //         _buildChoiceChip('إيجار', _selectedPropertyType, _selectPropertyType),
                    //       ],
                    //     ),
                    //     SizedBox(height: 16),
                    //     Text(
                    //       'فئة العقار',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     SizedBox(height: 8),
                    //     Row(
                    //       children: [
                    //         _buildChoiceChip('منزل', _selectedCategory, _selectCategory),
                    //         SizedBox(width: 8),
                    //         _buildChoiceChip('شقة', _selectedCategory, _selectCategory),
                    //         SizedBox(width: 8),
                    //         _buildChoiceChip('فيلا', _selectedCategory, _selectCategory),
                    //         SizedBox(width: 8),
                    //         _buildChoiceChip('أخرى', _selectedCategory, _selectCategory),
                    //       ],
                    //     ),
                    //     SizedBox(height: 16),
                    //     Text(
                    //       'الموقع',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     SizedBox(height: 8),
                    //     TextField(
                    //       decoration: InputDecoration(
                    //         hintText: 'مسعد شارع رقم خمسين خلف الجامعة اللبنانية...',
                    //         prefixIcon: Icon(Icons.location_pin),
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(height: 16),
                    //     Container(
                    //       height: 150,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(12),
                    //         color: Colors.grey[200],
                    //       ),
                    //       child: Center(child: Text('Map Placeholder')),
                    //     ),
                    //     SizedBox(height: 16),
                    //     const Text(
                    //       'صور العقار',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     const SizedBox(height: 8),
                    //     Wrap(
                    //       children: [
                    //         _buildPropertyImage(Images.noImageUrl),
                    //         SizedBox(width: 8),
                    //         _buildPropertyImage(Images.noImageUrl),
                    //         SizedBox(width: 8),
                    //         _buildPropertyImage(Images.noImageUrl),
                    //         SizedBox(width: 8),
                    //         _buildAddImageButton(),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ),

              /// button to update the property
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: InkWell(
                    onTap: _updateProperty,
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: _loading?const CircularProgressIndicator():Text(
                          "update",
                          style: fontMediumBold.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildChoiceChip(String label, String selected, Function(String) onSelect) {
  //   return ChoiceChip(
  //     label: Text(label),
  //     selected: selected == label,
  //     onSelected: (bool selected) {
  //       onSelect(label);
  //     },
  //     selectedColor: const Color(0xFF3E6B85),
  //     backgroundColor: const Color(0xFFEDEDED),
  //     labelStyle: TextStyle(
  //       color: selected == label ? Colors.white : Colors.black,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //   );
  // }


  void _updateProperty() async{
    // get data
    // if(globalpropertyDetails.)
    // check if something change from name , description, price, size
    print(jsonEncode(globalpropertyDetails));
  }
  Widget _buildPropertyImage(ImageModel2 imageUrl, int index) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "${AppConstants.baseUrl3}${imageUrl.image!}",
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
         Positioned(
          right: 4,
          top: 4,
          child: InkWell(
            onTap: (){
              showDeleteConfirmationDialog(
                  context, () async {
                try{
                  setState(() {
                    _loading = true;
                  });
                  var headers = {'Authorization': 'token ${widget.token}'};
                  var request = http.Request(
                      'DELETE',
                      Uri.parse(
                          '${AppConstants.baseUrl}api/image/${imageUrl.id!}/delete/'));

                  request.headers.addAll(headers);

                  http.StreamedResponse response = await request.send();

                  if (response.statusCode == 204) {
                    Navigator.of(context).pop();
                    setState(() {
                      _loading = false;
                    });
                    Get.snackbar("successfully deleted", "cool");
                    print(await response.stream.bytesToString());

                  } else {
                    Get.snackbar("error to delete", "try again",colorText: Colors.red);
                    setState(() {
                      _loading = false;
                    });
                    print(response.reasonPhrase);
                  }
                } catch(e){
                  setState(() {
                    _loading = false;
                  });

                  Get.snackbar("error to delete", "try again $e", colorText: Colors.red);
                }
              });
            },
            child: CircleAvatar(
              backgroundColor: Theme.of(context).cardColor,
              radius: 12,
              child: const Icon(Icons.close, size: 16, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () async {
        // Add image logic
        await _pickImage();

        await _uploadSingleImage(_image!);

      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: const Icon(Icons.add, size: 30, color: Colors.grey),
      ),
    );
  }

//   Widget _categorySection(){
//     return
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           /// type of property
//           const SizedBox(height: 10,),
//           Align(
//               alignment: Alignment.centerRight,
//               child: RichText(
//                 text:  TextSpan(
//                   text: 'نوع القائمة',
//                   style: fontMediumBold.copyWith(color: Theme.of(context).brightness == Brightness.dark
//                       ? Colors.white // Set text color for dark mode
//                       : Theme.of(context).primaryColor,),
//                   children: const <TextSpan>[
//                     TextSpan(
//                       text: '*',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ],
//                 ),
//               )
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Wrap(
//               runSpacing: 10,
//               spacing: 10,
//               children: [
//                 ...List.generate(
//                   2,
//                       (index) => Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 2.5),
//                     child: ChipWidgetHome(
//                       chipSelected: chipSelected3!,
//                       onChipClick: ()  {
//
//
//
//                         setState(() {
//                           // Deselect all chips except the clicked chip
//                           chipSelected3 = List.filled(chipSelected3!.length, false);
//                           chipSelected3![index] = true;
//                           if(index == 0){
//                             chipSelected3First = true;
//                             chipSelected3Last = false;
//                           } else if(index == 1){
//                             chipSelected3Last = true;
//                             chipSelected3First = false;
//                           }
//                         });
//
//
//                       },
//                       categoryModel: categoryModelList,
//                       index: index,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           /// list type section
//           const SizedBox(height: 10),
//           Align(
//             alignment: Alignment.centerRight,
//             child: RichText(
//               text:  TextSpan(
//                 text: 'فئة العقار ',
//                 style: fontMediumBold.copyWith(color: Theme.of(context).brightness == Brightness.dark
//                     ? Colors.white // Set text color for dark mode
//                     : Theme.of(context).primaryColor,),
//                 children: const <TextSpan>[
//                   TextSpan(
//                     text: '*',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ],
//               ),
//             )
//             ,
//           ),
//           const SizedBox(height: 10),
//           BlocBuilder<CategoryAlarmCubit, CategoryAlarmState>(
//             builder: (context, state) {
//               if (state is CategoryAlarmLoading) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: List.generate(
//                       3 * 2, // Number of containers and SizedBox widgets multiplied by 2 (since there will be 10 width SizedBox between each container)
//                           (index) {
//                         if (index.isEven) {
//                           // Even indexes represent containers
//                           return Container(
//                             height: 30,
//                             width: 50,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               color: Theme.of(context).cardColor,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Theme.of(context).shadowColor.withOpacity(0.2),
//                                   spreadRadius: 2,
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                           );
//                         } else {
//                           // Odd indexes represent SizedBox widgets
//                           return const SizedBox(width: 10);
//                         }
//                       },
//                     ),
//                   ),
//                 );
//               } else if (state is CategoryAlarmLoaded) {
//                 return SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Add default chip widget here
//
//                       // Generate chip widgets from the API response
//                       ...List.generate(
//                         state.category.results.length,
//                             (index) => Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 2.5),
//                           child: ChipWidgetHome(
//                             chipSelected: chipSelected,
//                             onChipClick: ()  {
//                               setState(() {
//                                 categoryId = state.category.results[index].id;
//                               });
//                               // Check if the current chip is already selected
//                               if (!chipSelected[index]) {
//                                 context.read<SubCategoryAlarmCubit>().getSubCategory(parentId: categoryId!);
//
//                               }
//
//                               setState(() {
//                                 // Deselect all chips except the clicked chip
//                                 chipSelected = List.filled(chipSelected.length, false);
//                                 chipSelected[index] = true;
//                                 clickedChip = state.category.results[index].toString();
//                                 if (kDebugMode) {
//                                   print(state.category.results[index].id.toString());
//                                 }
//                                 // Deselect the default chip if any other chip is selected
//                                 defaultChipSelected[0] = false;
//                               });
//
//
//                             },
//                             categoryModel: state.category,
//                             index: index,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               } else if (state is CategoryAlarmFailure) {
//                 return const Text("failed to fetch data");
//               } else {
//                 return const SizedBox();
//               }
//             },
//           ),
//
//           const SizedBox(height: 10),
//           BlocBuilder<SubCategoryAlarmCubit, SubCategoryAlarmCubitState>(
//             builder: (context, state) {
//               if (state is LoadingSubCategoryState) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: List.generate(
//                       3 * 2, // Number of containers and SizedBox widgets multiplied by 2 (since there will be 10 width SizedBox between each container)
//                           (index) {
//                         if (index.isEven) {
//                           // Even indexes represent containers
//                           return Container(
//                             height: 30,
//                             width: 50,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               color: Theme.of(context).cardColor,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Theme.of(context).shadowColor.withOpacity(0.2),
//                                   spreadRadius: 2,
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                           );
//                         } else {
//                           // Odd indexes represent SizedBox widgets
//                           return const SizedBox(width: 10);
//                         }
//                       },
//                     ),
//                   ),
//                 );
//               } else if (state is SuccessSubCategoryState) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     RichText(
//                       text:  TextSpan(
//                         text: 'أختر العقار ',
//                         style: fontMediumBold.copyWith(color: Theme.of(context).brightness == Brightness.dark
//                             ? Colors.white // Set text color for dark mode
//                             : Theme.of(context).primaryColor,),
//                         children: const <TextSpan>[
//                           TextSpan(
//                             text: '*',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Wrap(
//                       runSpacing: 10,
//                       spacing: 10,
//                       children: [
//                         ...List.generate(
//                           state.categoryModel.results.length,
//                               (index) => Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 2.5),
//                             child: ChipWidgetHome(
//                               chipSelected: chipSelected2,
//                               onChipClick: ()  {
//                                 setState(() {
//                                   subCategoryId = state.categoryModel.results[index].id;
//
//                                 });
//
//
//                                 setState(() {
//                                   // Deselect all chips except the clicked chip
//                                   chipSelected2 = List.filled(chipSelected2.length, false);
//                                   chipSelected2[index] = true;
//                                   clickedChip = state.categoryModel.results[index].toString();
//                                   if (kDebugMode) {
//                                     print(state.categoryModel.results[index].id.toString());
//                                   }
//                                   context.read<AttributeAlarmCubit>().fetchAttributesByCategory(categoryId: subCategoryId!);
//
//                                 });
//
//
//                               },
//                               categoryModel: state.categoryModel,
//                               index: index,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 );
//               } else if (state is CategoryAlarmFailure) {
//                 return const Text("faild to fetch data");
//               } else {
//                 return const SizedBox();
//               }
//             },
//           ),
//
//
//
//           /// attributes
//           BlocBuilder<AttributeAlarmCubit, AttributeAlarmState>(
//             builder: (context, state) {
//               if (state is AttributeAlarmLoading) {
//                 return const Center(
//                     child: CircularProgressIndicator());
//               } else if (state is AttributeAlarmLoaded) {
//                 // Function to filter data based on data_type
//                 List<AttributesAlarmModel> filterDataByType(
//                     List<AttributesAlarmModel> data,
//                     String dataType) {
//                   return data.where((item) =>
//                   item.dataType == dataType).toList();
//                 }
//
//                 // Convert state.attributes (list of AttributesAlarmModel) to List<Map<String, dynamic>>
//                 List<AttributesAlarmModel> data = state.attributes;
//
//                 // values = filterDataByType(data, "int").att;
//                 return Column(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 9),
//                         const Text("خصائص العقار", style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold)),
//                         const SizedBox(height: 6),
//                         // Example: Build CustomAttributeInt widgets for int data
//                         ...filterDataByType(data, 'int').map((
//                             attribute) {
//                           return CustomAttributeInt(
//                             initialValue: 0,
//                             label: attribute.name ?? '',
//                             onChanged: (value) {
//                               print(value);
//                               // Find if the attribute already exists in realAttributes
//                               var existingAttribute = realAttributes
//                                   .firstWhere(
//                                     (element) =>
//                                 element['attribute_id'] ==
//                                     attribute.id.toString(),
//                                 orElse: () =>
//                                 {
//                                   'attribute_id': null,
//                                   'value': null
//                                 }, // Return a placeholder map
//                               );
//
//                               if (existingAttribute['attribute_id'] !=
//                                   null) {
//                                 // If the attribute exists, update its value or remove it if the value is zero
//                                 if (value == 0) {
//                                   realAttributes.removeWhere((
//                                       element) =>
//                                   element['attribute_id'] ==
//                                       attribute.id.toString());
//                                 } else {
//                                   existingAttribute['value'] =
//                                       value.toString();
//                                 }
//                               } else if (value != 0) {
//                                 // If the attribute does not exist and the value is not zero, add a new one
//                                 realAttributes.add({
//                                   'attribute_id': attribute.id
//                                       .toString(),
//                                   'value': value.toString(),
//                                 });
//                               }
//
//                               // Print the updated realAttributes list
//                               print(
//                                   'Updated realAttributes: $realAttributes');
//                             },
//                           );
//                         }),
//
//                       ],
//                     ),
//                   ],
//                 );
//               } else if (state is AttributeAlarmFailure) {
//                 return Center(child: Text('Error: ${state.error}'));
//               } else {
//                 return const SizedBox();
//               }
//             },
//           ),
//
//
//           /// fetch attributes string
//           BlocBuilder<AttributeAlarmCubit, AttributeAlarmState>(
//             builder: (context, state) {
//               if (state is AttributeAlarmLoading) {
//                 return const Center(
//                     child: CircularProgressIndicator());
//               } else if (state is AttributeAlarmLoaded) {
//                 // Function to filter data based on data_type
//                 List<AttributesAlarmModel> filterDataByType(
//                     List<AttributesAlarmModel> data,
//                     String dataType) {
//                   return data.where((item) =>
//                   item.dataType == dataType).toList();
//                 }
//
//                 // Convert state.attributes (list of AttributesAlarmModel) to List<Map<String, dynamic>>
//                 List<AttributesAlarmModel> data = state.attributes;
//
//
//                 List<Map<String, dynamic>> transformToMap(
//                     List<ValueAttributeModel>? attributes) {
//                   if (attributes == null) {
//                     return [];
//                   }
//                   return attributes.map((attribute) {
//                     return {
//                       'id': attribute.id,
//                       'value': attribute.value,
//                       'attribute': attribute.attribute,
//                     };
//                   }).toList();
//                 }
//
//
//                 // values = filterDataByType(data, "int").att;
//                 return Column(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 6),
//                         // Example: Build CustomAttributeInt widgets for int data
//                         ...filterDataByType(data, 'string').map((
//                             attribute) {
//                           return CustomDropdownButton(
//                             options: transformToMap(
//                                 attribute.valueAttribute),
//                             lable: attribute.name ?? " ",
//                             onChanged: (String id, String value) {
//                               print(
//                                   'Selected ID: $id, Selected Value: $value');
//                               int intValue = int.tryParse(value) ??
//                                   0;
//
//                               // Find if the attribute already exists in realAttributes
//                               var existingAttribute = realAttributes
//                                   .firstWhere(
//                                     (element) =>
//                                 element['attribute_id'] == id,
//                                 orElse: () =>
//                                 {
//                                   'attribute_id': null,
//                                   'value': null
//                                 }, // Return a placeholder map
//                               );
//
//
//                               realAttributes.add({
//                                 'attribute_id': attribute.id,
//                                 'value': value,
//                               });
//
//
//                               // Update lastAttributes map
//                               lastAttributes.clear();
//                               for (var attr in realAttributes) {
//                                 lastAttributes[attr['attribute_id']
//                                     .toString()] =
//                                     attr['value'].toString();
//                               }
//
//                               // Print the updated realAttributes list
//                               print(
//                                   'Updated realAttributes: $realAttributes');
//                               print(
//                                   'Updated lastAttributes: $lastAttributes');
//                             },
//                           );
//                         }).toList(),
//
//                       ],
//                     ),
//                   ],
//                 );
//               } else if (state is AttributeAlarmFailure) {
//                 return Center(child: Text('Error: ${state.error}'));
//               } else {
//                 return const SizedBox();
//               }
//             },
//           ),
//
//         ],
//       );
// }

  Widget _buildPropertyView(BuildContext context, List<ImageModel2> imageList, final propertyDetails) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Theme.of(context).cardColor,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: double.infinity,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(("${AppConstants.baseUrl3}${(imageList.isEmpty?"":imageList.first.image)}" == AppConstants.baseUrl3 && imageList.isEmpty
                        ?AppConstants.noImageUrl
                        :"${AppConstants.baseUrl3}${imageList[0].image}"),
                    ),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(propertyDetails.name, style: fontMedium,maxLines: 1, overflow: TextOverflow.ellipsis,),
                    Text("${propertyDetails.rate.toString()}⭐", style: fontSmallBold,maxLines: 1, overflow: TextOverflow.ellipsis,),
                    Text("${propertyDetails.address!.line1}", style: fontSmallBold,maxLines: 1, overflow: TextOverflow.ellipsis,),
                    Text("${propertyDetails.price}", style: fontSmallBold,maxLines: 1, overflow: TextOverflow.ellipsis,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void showDeleteConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure to delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: onConfirm,
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  /// google map to edit address



}


import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../features/client/property_details/data/model/image_model.dart';
import '../../../../features/client/property_details/presentation/manager/property_details/property_details_cubit.dart';
import '../../../../features/client/property_details/presentation/manager/property_details/property_details_state.dart';

class EditPropertyPage extends StatefulWidget {
   const EditPropertyPage({super.key, required this.propertyId, required this.token});
   final int propertyId;
   final String token;

  @override
  State<EditPropertyPage> createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  String _selectedPropertyType = 'بيع';
  String _selectedCategory = 'منزل';

  String? token;

  void _selectPropertyType(String type) {
    setState(() {
      _selectedPropertyType = type;
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  Future<void> getToken() async {
    final myToken = await SharedPrefManager.getData(AppConstants.token);

    setState(() {
      token = myToken ?? " ";
    });

    print("my toooooooookennnnn $token");
  }

  @override
  void initState() {
    super.initState();
    getToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() async{
    final propertyDetails = context.read<PropertyDetailsCubit>();
    await Future.wait([
      propertyDetails.getPropertyDetails(widget.propertyId, widget.token),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل عقارك'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
          builder: (context, state) {
            if (state is PropertyDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PropertyDetailsSuccess) {
              final propertyDetails = state.propertyDetails;
              final List<ImageModel2> imageList = state.propertyDetails.image!.map((imageModel) => ImageModel2(
                image: imageModel.image,
                id: imageModel.id,
              )).toList();
              print(jsonEncode(propertyDetails));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Display property image and some details
                  Text(jsonEncode(propertyDetails)),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the edit page
                    },
                    child: Row(
                      children: [
                        Expanded(
                            child: _buildPropertyView()
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),




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
    );
  }

  Widget _buildChoiceChip(String label, String selected, Function(String) onSelect) {
    return ChoiceChip(
      label: Text(label),
      selected: selected == label,
      onSelected: (bool selected) {
        onSelect(label);
      },
      selectedColor: Color(0xFF3E6B85),
      backgroundColor: Color(0xFFEDEDED),
      labelStyle: TextStyle(
        color: selected == label ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildPropertyImage(String imageUrl) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
         Positioned(
          right: 4,
          top: 4,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).cardColor,
            radius: 12,
            child: const Icon(Icons.close, size: 16, color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () {
        // Add image logic
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
}

Widget _buildPropertyView() {
  return Container(
    height: 20,

  );
}
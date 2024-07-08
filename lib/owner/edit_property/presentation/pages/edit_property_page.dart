import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_real_estate/core/helper/local_data/shared_pref.dart';
import 'package:smart_real_estate/core/utils/images.dart';

import '../../../../core/constant/app_constants.dart';
import '../../../../core/utils/styles.dart';
import '../../../../features/client/property_details/presentation/manager/property_details/property_details_cubit.dart';
import '../../../../features/client/property_details/presentation/manager/property_details/property_details_state.dart';
import '../../../../features/client/property_details/presentation/manager/reviews/reviews_cubit.dart';
class EditPropertyPage extends StatefulWidget {
   const EditPropertyPage({super.key, required this.propertyId});
   final int propertyId;

  @override
  _EditPropertyPageState createState() => _EditPropertyPageState();
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

  @override
  void initState() {
    super.initState();
    fetchToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }


  fetchToken() async {
    final mToken = await SharedPrefManager.getData(AppConstants.token);
    setState(() {
      token = mToken;
    });
  }
  void _fetchData() async {
    final getReviewsAll = context.read<ReviewsPropertyCubit>();
    final getPropertyDetails = context.read<PropertyDetailsCubit>();

    await Future.wait([
      getPropertyDetails.getPropertyDetails(
          widget.propertyId, "$token"),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  const Icon(Icons.arrow_forward),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'عنوان العقار',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'نوع العقار',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildChoiceChip('بيع', _selectedPropertyType, _selectPropertyType),
                SizedBox(width: 8),
                _buildChoiceChip('إيجار', _selectedPropertyType, _selectPropertyType),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'فئة العقار',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildChoiceChip('منزل', _selectedCategory, _selectCategory),
                SizedBox(width: 8),
                _buildChoiceChip('شقة', _selectedCategory, _selectCategory),
                SizedBox(width: 8),
                _buildChoiceChip('فيلا', _selectedCategory, _selectCategory),
                SizedBox(width: 8),
                _buildChoiceChip('أخرى', _selectedCategory, _selectCategory),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'الموقع',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'مسعد شارع رقم خمسين خلف الجامعة اللبنانية...',
                prefixIcon: Icon(Icons.location_pin),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: Center(child: Text('Map Placeholder')),
            ),
            SizedBox(height: 16),
            const Text(
              'صور العقار',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              children: [
                _buildPropertyImage(Images.noImageUrl),
                SizedBox(width: 8),
                _buildPropertyImage(Images.noImageUrl),
                SizedBox(width: 8),
                _buildPropertyImage(Images.noImageUrl),
                SizedBox(width: 8),
                _buildAddImageButton(),
              ],
            ),
          ],
        ),
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
  return BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
    builder: (context, state) {
      if (state is PropertyDetailsLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is PropertyDetailsSuccess) {
        final propertyDetails = state.propertyDetails;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            height: 130.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    height: 120.0,
                    width: 168.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    propertyDetails.image![0].image != "null" ?"${AppConstants.baseUrl3}${propertyDetails.image![0].image}" : AppConstants.noImageUrl,
                                  ),
                                  fit: BoxFit.cover)),
                        ),

                        // Heart icon
                        Positioned(
                          top: 10.0,
                          right: 10.0,
                          child: Container(
                            height: 25.0,
                            width: 25.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: Theme.of(context).cardColor),
                            child: Center(
                              child: SvgPicture.asset(
                                Images.heartIcon,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          propertyDetails.name.toString(),
                          style: fontMediumBold,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3.0),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.yellow, size: 16),
                            const SizedBox(width: 4.0),
                            Text(propertyDetails.rate.toString(),
                                style: fontSmallBold),
                          ],
                        ),
                        const SizedBox(height: 3.0),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 16),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                propertyDetails.address!.line1.toString(),
                                style: fontSmallBold,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (state is PropertyDetailsError) {
        return Center(
          child: Text('Error: ${state.error}'),
        );
      } else {
        return const SizedBox(); // Return an empty widget if state is not recognized
      }
    },
  );
}
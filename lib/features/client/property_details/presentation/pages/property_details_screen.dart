import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_real_estate/features/client/property_details/data/model/image_model.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/manager/property_details/property_details_cubit.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/widgets/image_section_widget.dart';

import '../manager/property_details/property_details_state.dart';


class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({super.key, required this.id});

  final int? id;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final propertyDetails = context.read<PropertyDetailsCubit>();
      await Future.wait([
        propertyDetails.getPropertyDetails(widget.id!, "0a53a95704d2b4e2bf439563e02bd290c0fa0eb4"),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display property image and some details
                  ImageSectionPropertyDetailsWidget(
                    isFavorite: propertyDetails.inFavorite!,
                    imagesModel: imageList,
                    rating: propertyDetails.rate!,
                    categoryName: propertyDetails.category?.name ?? "",
                  ),

                  // Displaying property rest details


                  Text('ID: ${propertyDetails.id}'),
                  Text('Name: ${propertyDetails.name}'),
                  Text('Description: ${propertyDetails.inFavorite}'),
                  Text('Price: ${propertyDetails.price}'),
                  Text('Size: ${propertyDetails.size}'),
                  Text('Rate: ${propertyDetails.rate}'),
                  Text('Active: ${propertyDetails.isActive}'),
                  Text('Deleted: ${propertyDetails.isDeleted}'),
                  Text('Time Created: ${propertyDetails.timeCreated}'),
                  Text('Unique Number: ${propertyDetails.uniqueNumber}'),
                  Text('For Sale: ${propertyDetails.forSale}'),
                  Text('Featured: ${propertyDetails.isFeatured}'),

                  // Displaying address
                  Text('Address: ${propertyDetails.address?.line1 ?? ""}'),

                  // Displaying category
                  Text('Category Name: ${propertyDetails.category?.name ?? ""}'),

                  // Displaying user
                  if (propertyDetails.user != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('User Info:'),
                        Text('   Email: ${propertyDetails.user!.email ?? ""}'),
                        Text('   Phone Number: ${propertyDetails.user!.phoneNumber ?? ""}'),
                        Text('   Username: ${propertyDetails.user!.username ?? ""}'),
                        Text('   Name: ${propertyDetails.user!.name ?? ""}'),
                      ],
                    ),

                  // Displaying feature property
                  const Text('Feature Properties:'),
                  if (propertyDetails.featureProperty != null)
                    for (var featureProperty in propertyDetails.featureProperty!)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('   Feature ID: ${featureProperty.feature?.id ?? ""}'),
                          Text('   Feature Name: ${featureProperty.feature?.name ?? ""}'),
                          Text('   Feature Image: ${featureProperty.image?.first.image ?? ""}'),
                        ],
                      ),

                  // Displaying property values
                  const Text('Property Values:'),
                  if (propertyDetails.propertyValue != null)
                    for (var propertyValue in propertyDetails.propertyValue!)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('   Value ID: ${propertyValue.value?.id ?? ""}'),
                          Text('   Attribute Name: ${propertyValue.value?.attribute?.name ?? ""}'),
                          Text('   Value: ${propertyValue.value?.value ?? ""}'),
                        ],
                      ),

                  // Additional sections if needed
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
      ),
    );
  }


}

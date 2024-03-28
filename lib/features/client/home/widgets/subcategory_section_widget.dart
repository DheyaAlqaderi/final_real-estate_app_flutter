import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

import '../data/models/category/category_model.dart';

class SubcategoryWidget extends StatefulWidget {
  const SubcategoryWidget({super.key, required this.categoryList, required this.onTap});

  final CategoryModel categoryList;
  final Function(int) onTap;

  @override
  State<SubcategoryWidget> createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubcategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.categoryList.results.length,
              (index) {
            final category = widget.categoryList.results[index];
            final imageUrl = category.image.isNotEmpty ? category.image[0].image ?? ''
                : AppConstants.noImageUrl;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: ovalImageWithName(
                imageUrl,
                category.name ?? '',
                index,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget ovalImageWithName(String image, String name, int index) {
    return InkWell(
      onTap: () {
        widget.onTap(index);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 9.0, left: 5, right: 5),
        child: SizedBox(
          width: 80.0,
          child: Column(
            children: [
              CircleAvatar(
                radius: 35, // Adjust the radius as needed
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                    placeholder: (context, url) => const CircularProgressIndicator(), // Placeholder widget while loading
                    errorWidget: (context, url, error) => const Icon(Icons.error), // Error widget in case of failure
                  ),
                ),
              ),
              const SizedBox(height: 5), // Add some spacing between the image and text
              Text(
                name,
                style: fontSmallBold, // Assuming fontSmallBold is defined or imported correctly
                textAlign: TextAlign.center,
                maxLines: 2, // Limit the number of lines for long names
                overflow: TextOverflow.ellipsis, // Handle long names
              ),
            ],
          ),
        ),
      ),
    );
  }
}

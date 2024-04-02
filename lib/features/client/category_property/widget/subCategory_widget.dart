import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/home/data/models/category/category_model.dart';


class SubCategoryCircleWidget extends StatefulWidget {
  const SubCategoryCircleWidget({super.key, required this.categoryModel, required this.index, required this.onTap});
  final CategoryModel categoryModel;
  final int index;
  final VoidCallback onTap;

  @override
  State<SubCategoryCircleWidget> createState() => _SubCategoryCircleWidgetState();
}

class _SubCategoryCircleWidgetState extends State<SubCategoryCircleWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60.0,
            width: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Theme.of(context).cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Theme.of(context).cardColor,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        "${widget.categoryModel.results[widget.index].image[0].image}",
                    ),
                    fit: BoxFit.cover
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 2,),
          SizedBox(
            width: 80,
            child: Align(
              alignment: Alignment.center,
                child: Text(
                  widget.categoryModel.results[widget.index].name.toString(),
                  style: fontSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
            ),
          ),


        ],
      ),
    );
  }
}

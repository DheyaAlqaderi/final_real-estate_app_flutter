import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';


class SearchFilterWidget extends StatefulWidget {
  const SearchFilterWidget({super.key, required this.onSearchBarTap, required this.onFilterBarTap});

  final VoidCallback onSearchBarTap;
  final VoidCallback onFilterBarTap;

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: widget.onSearchBarTap,
            child: Container(
              height: 70.0,
              width: 266.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.2), // Use shadowColor from the theme with opacity
                    spreadRadius: 2, // Spread radius of the shadow
                    blurRadius: 4, // Blur radius of the shadow
                    offset: const Offset(0, 2), // Offset of the shadow
                  ),
                ],
              ),

              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.search),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Locales.string(context, "search_hint"),
                      style: fontMedium.copyWith(color: Colors.grey),
                    ),
                  ),

                ],
              ),
            ),
          ),
          const SizedBox(width: 10,),
          InkWell(
            onTap: widget.onFilterBarTap,
            child: Container(
                height: 55.0,
                width: 55.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.2), // Use shadowColor from the theme with opacity
                      spreadRadius: 2, // Spread radius of the shadow
                      blurRadius: 4, // Blur radius of the shadow
                      offset: const Offset(0, 2), // Offset of the shadow
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(Images.filterIcon, color: Theme.of(context).colorScheme.onSurface,),
                )
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

class PropertyDetailsDescriptionWidget extends StatefulWidget {
  const PropertyDetailsDescriptionWidget({
    super.key,
    required this.name,
    required this.description,
    required this.address,
    this.price,
    required this.isForSale,
    this.date});

  final String name;
  final String description;
  final String address;
  final price;
  final bool isForSale;
  final date;

  @override
  State<PropertyDetailsDescriptionWidget> createState() => _PropertyDetailsDescriptionWidgetState();
}

class _PropertyDetailsDescriptionWidgetState extends State<PropertyDetailsDescriptionWidget> {

  int calculateDaysDifference(String dateString) {
    // Parse the input date string into a DateTime object
    DateTime inputDate = DateFormat('yyyy-MM-dd').parse(dateString);

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the difference between the current date and the input date
    Duration difference = currentDate.difference(inputDate);

    // Return the difference in terms of days
    return difference.inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          Text(widget.name, style: fontLargeBold,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.address, style: fontMedium,),
              Text("منذ ${calculateDaysDifference(widget.date)} أيام  " , style: fontMedium,),
            ],
          ),
          const SizedBox(height: 7.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(widget.price, style: fontMediumBold,),
                  const SizedBox(width: 7.0,),
                  const Text("كل شهر" , style: fontMedium,)
                ],
              ),

              ElevatedButton(
                onPressed: (){},
                child: SizedBox(
                  height: 47.0,
                  width: 60.0,
                  child: Center(
                    child: Text(
                      widget.isForSale
                          ? Locales.string(context, "for_sale")
                          : Locales.string(context, "for_rent"),
                      style: fontMediumBold,
                    ),
                  ),
                ),
                  ),
            ],
          ),
          const SizedBox(height: 7.0),
          Container(
            height: 2.0,
            width: double.infinity,
            color: Theme.of(context).cardColor,
          ),
          const SizedBox(height: 7.0),
          Text(widget.description, style: fontMedium,),

        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_real_estate/features/client/property_details/presentation/pages/property_details_screen.dart';

import '../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';

class NotificationWidget extends StatefulWidget {
  final Function onTap;
  final Map<String, dynamic> notificationList;
  final int index;

  const NotificationWidget({
    super.key,
    required this.onTap,
    required this.notificationList,
    required this.index,
  });

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  int? id;
  @override
  void initState() {
    super.initState();
     id = widget.notificationList["notifications"][widget.index]["object_id"];
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.notificationList["notifications"][widget.index]["content_type"] == 43
            ?Get.to( PropertyDetailsScreen(id: id))
            :Locales.string(context, "notification");
      },
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                height: 30,
                  width: 30,
                  child: SvgPicture.asset(Images.notification,)
              ),
              const SizedBox(width: 15,),
              GestureDetector(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5,),
                    Text(
                      ((widget.notificationList["notifications"]?[widget.index]?["content_type"] ?? 0) == 43)
                          ? Locales.string(context, "alarm_notification")
                          : Locales.string(context, "notification"),
                      style: fontMediumBold,
                    ),
                    const SizedBox(height: 5),
                    Text(widget.notificationList["notifications"]?[widget.index]?["verb"] ?? ''),
                    Text(
                      formatTimestamp(widget.notificationList["notifications"]?[widget.index]?["timestamp"] ?? ''),
                      style: fontSmallBold,
                      selectionColor: Colors.cyanAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return '';
    DateTime parsedDate = DateTime.parse(timestamp);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }
}

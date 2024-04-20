
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

import '../../data/models/message_model.dart';
import 'message_contents.dart';
class SentMessage extends StatelessWidget {
  final MessageModel message;

  const SentMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        margin: const EdgeInsets.only(left: 40.0),
        padding: const EdgeInsets.all(7.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: (Locales.isDirectionRTL(context))
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: MessageContents(
                message: message,
                isSentMessage: true,
              ),
            ),
            (Locales.isDirectionRTL(context))
                ?Wrap(
              alignment: (Locales.isDirectionRTL(context))
                  ? WrapAlignment.start
                  : WrapAlignment.end,
              children: [
                Icon(
                  message.seen ? Icons.done_all : Icons.check,
                  color: message.seen ? Colors.green : Colors.grey,
                  size: 15.0,
                ),
                const SizedBox(width: 5.0),
                Text(
                  DateFormat('HH:mm').format(message.timestamp), // Format timestamp
                  style: fontSmall.copyWith(color: Colors.grey),
                ),
              ],
            ):Wrap(
              alignment: (Locales.isDirectionRTL(context))
                  ? WrapAlignment.start
                  : WrapAlignment.end,
              children: [
                Text(
                  DateFormat('HH:mm').format(message.timestamp), // Format timestamp
                  style: fontSmall.copyWith(color: Colors.grey),
                ),
                const SizedBox(width: 5.0),
                Icon(
                  message.seen ? Icons.done_all : Icons.check,
                  color: message.seen ? Colors.green : Colors.grey,
                  size: 15.0,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

import '../../data/models/message_model.dart';
import 'message_contents.dart';

class ReceivedMessage extends StatelessWidget {
  final Message message;

  const ReceivedMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: (Locales.isDirectionRTL(context))
            ?MainAxisAlignment.end
            :MainAxisAlignment.start, // Align the container to the start of the row
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(right: 40.0),
              padding: const EdgeInsets.all(7.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MessageContents(
                    message: message,
                    isSentMessage: false, // Change to false as it's a received message
                  ),
                  const SizedBox(height: 5), // Add some space between message and timestamp
                  Text(
                    textAlign: (Locales.isDirectionRTL(context))
                        ?TextAlign.end
                        :TextAlign.start,
                    DateFormat('HH:mm').format(message.timestamp), // Format timestamp
                    style: fontSmall.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

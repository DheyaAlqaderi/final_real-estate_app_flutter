import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

import '../../data/models/message_model.dart';
import 'message_contents.dart';

class SentMessage extends ConsumerWidget {
  final Message message;

  const SentMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: (Locales.isDirectionRTL(context)) ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Flexible(
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
                crossAxisAlignment: CrossAxisAlignment.end, // Ensure the column takes minimal vertical space
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: MessageContents(
                      message: message,
                      isSentMessage: true,
                    ),
                  ),
                  // Text(message.timestamp.timeZoneName, style: fontSmall,),
                  // const SizedBox(width: 5.0,),
                  Icon(
                    message.seen ? Icons.done_all : Icons.check,
                    color: message.seen ? Colors.green : Colors.white,
                    size: 15.0,
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

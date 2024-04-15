
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_real_estate/features/client/chat/presentation/widgets/round_profile_tile.dart';

import '../../data/models/message_model.dart';
import 'message_contents.dart';


class ReceivedMessage extends ConsumerWidget {
  final Message message;

  const ReceivedMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:(Locales.isDirectionRTL(context))? MainAxisAlignment.end:MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(right: 40.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: MessageContents(message: message),
            ),
          ),
        ],
      ),
    );
  }
}

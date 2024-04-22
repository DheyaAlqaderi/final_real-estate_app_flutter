import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/styles.dart';
import 'package:smart_real_estate/features/client/chat/presentation/widgets/post_Image_video_view.dart';

import '../../data/models/message_model.dart';

class MessageContents extends StatelessWidget {
  const MessageContents({
    super.key,
    required this.message,
    this.isSentMessage = false,
  });

  final MessageModel message;
  final bool isSentMessage;

  @override
  Widget build(BuildContext context) {
    if (message.messageType == 'text') {
      return Text(
        message.message,
        style: fontSmallBold.copyWith(
          color: !isSentMessage? Colors.white:null
        )
      );
    } else {
      return PostImageVideoView(
        fileUrl: message.message,
        fileType: message.messageType,
      );
    }
  }
}

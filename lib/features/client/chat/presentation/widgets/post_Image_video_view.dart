import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'network_video_view.dart';

class PostImageVideoView extends StatelessWidget {
  const PostImageVideoView({
    super.key,
    required this.fileType,
    required this.fileUrl,
  });

  final String fileType;
  final String fileUrl;

  @override
  Widget build(BuildContext context) {
    if (fileType == 'image') {
      return CachedNetworkImage(
        imageUrl: fileUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return NetworkVideoView(
        videoUrl: fileUrl,
      );
    }
  }

}

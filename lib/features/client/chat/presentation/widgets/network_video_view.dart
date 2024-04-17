import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoView extends StatefulWidget {
  const NetworkVideoView({
    Key? key,
    required this.videoUrl,
    this.localVideoFile,
  }) : super(key: key);

  final String videoUrl;
  final File? localVideoFile;

  @override
  State<NetworkVideoView> createState() => _NetworkVideoViewState();
}

class _NetworkVideoViewState extends State<NetworkVideoView> {
  late final VideoPlayerController _videoController;
  late bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _initializeVideoController() {
    _videoController = widget.localVideoFile != null
        ? VideoPlayerController.file(widget.localVideoFile!)
        : VideoPlayerController.network(widget.videoUrl);

    _videoController.initialize().then((_) {
      if (mounted) setState(() {});
    });
  }

  void _togglePlayPause() {
    if (isPlaying) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
    setState(() => isPlaying = !isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _videoController.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(_videoController),
          Positioned.fill(
            child: IconButton(
              onPressed: _togglePlayPause,
              icon: Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

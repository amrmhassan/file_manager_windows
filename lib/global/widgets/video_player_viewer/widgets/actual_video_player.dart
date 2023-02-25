import 'package:dart_vlc/dart_vlc.dart';
import 'package:windows_app/providers/media_player_provider.dart';
import 'package:flutter/material.dart';

class ActualVideoPlayer extends StatelessWidget {
  const ActualVideoPlayer({
    Key? key,
    required this.mpProvider,
  }) : super(key: key);

  final MediaPlayerProvider mpProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black,
      width: double.infinity,
      // height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Video(
              showControls: false,
              player: mpProvider.videoPlayerController!,
            ),
          ),
        ],
      ),
    );
  }
}

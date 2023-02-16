// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/global/widgets/video_player_viewer/widgets/actual_video_player.dart';
import 'package:windows_app/global/widgets/video_player_viewer/widgets/video_controllers.dart';
import 'package:windows_app/global/widgets/video_player_viewer/widgets/video_gesture_detectors.dart';
import 'package:windows_app/global/widgets/video_player_viewer/widgets/video_paused_button.dart';
import 'package:windows_app/global/widgets/video_player_viewer/widgets/video_position_viewer.dart';
import 'package:windows_app/global/widgets/video_player_viewer/widgets/volume_viewer.dart';
import 'package:windows_app/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoPlayerViewer extends StatefulWidget {
  const VideoPlayerViewer({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoPlayerViewer> createState() => _VideoPlayerViewerState();
}

class _VideoPlayerViewerState extends State<VideoPlayerViewer> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      if (mounted) {
        Provider.of<MediaPlayerProvider>(context, listen: false)
            .updateDeviceVolume();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return mpProvider.videoPlayerController != null && (!mpProvider.videoHidden)
        ? WillPopScope(
            onWillPop: () async {
              Provider.of<MediaPlayerProvider>(context, listen: false)
                  .toggleHideVideo();

              return false;
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ActualVideoPlayer(
                  mpProvider: mpProvider,
                ),
                Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          VideoPlayGestureDetector(),
                          //? volume controller
                          VolumeGestureDetector()
                        ],
                      ),
                    ),
                    //? seeker controller
                    SeekerGestureDetector()
                  ],
                ),
                VolumeViewer(),
                VideoPositionViewer(),
                if (!mpProvider.bottomVideoControllersHidden)
                  BottomVideoControllers(),
                VideoPausedButton(),
              ],
            ),
          )
        : SizedBox();
  }
}

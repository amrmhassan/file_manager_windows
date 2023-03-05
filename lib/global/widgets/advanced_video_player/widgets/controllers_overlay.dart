// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/global/widgets/advanced_video_player/widgets/play_pause_overlay.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/video_duration_viewer.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/video_lower_background_shader.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/video_mute_fullscreen_controllers.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/video_player_slider.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/video_upper_cotroller.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/providers/media_player_provider.dart';
import 'package:windows_app/utils/futures_utils.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:provider/provider.dart';

class ControllersOverlay extends StatefulWidget {
  final VoidCallback toggleControllerOverLayViewed;
  final VoidCallback toggleLandscape;

  const ControllersOverlay({
    super.key,
    required this.toggleControllerOverLayViewed,
    required this.toggleLandscape,
  });

  @override
  State<ControllersOverlay> createState() => _ControllersOverlayState();
}

class _ControllersOverlayState extends State<ControllersOverlay> {
  late CustomFuture customFuture;
  late Duration hideMeAfterDuration;

  Duration get defaultDuration {
    var mpProvider = mpPF(context);
    return Duration(
        milliseconds: mpProvider.isVideoPlaying ? 3 * 1000 : 20 * 1000);
  }

  void cancelHidingFuture() {
    // print('cancelling hiding');
    try {
      customFuture.cancel();
    } catch (e) {
      printOnDebug('First time to open controller overlay');
    }
  }

  hideMeAfter() {
    // print('running hiding future');
    cancelHidingFuture();

    hideMeAfterDuration = defaultDuration;
    customFuture = CustomFuture()
      ..delayedAction(
        hideMeAfterDuration,
        widget.toggleControllerOverLayViewed,
      );
  }

  @override
  void initState() {
    //! activate this
    if (!kDebugMode) {
      hideMeAfter();
    }
    super.initState();
  }

  @override
  void dispose() {
    cancelHidingFuture();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return Listener(
      onPointerDown: (details) {
        cancelHidingFuture();
      },
      onPointerUp: (event) {
        hideMeAfter();
      },
      child: Stack(
        children: [
          Column(
            children: [
              VideoUpperControllers(),
              Spacer(),
              if (mpProvider.videoPlayerController != null)
                FadeInUp(
                  preferences: AnimationPreferences(
                    duration: Duration(milliseconds: 250),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoLowerBackgroundShader(),
                      Column(
                        children: [
                          VideoMuteFullScreenControllers(
                            toggleLandscape: widget.toggleLandscape,
                          ),
                          VideoPlayerSlider(),
                          VideoDurationViewer(),
                          VSpace(),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
          PlayPauseOverLay(),
        ],
      ),
    );
  }
}

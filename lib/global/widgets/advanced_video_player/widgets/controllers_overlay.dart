// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/analyzing_code/globals/files_folders_operations.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/close_video_button.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/custom_icon_button.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/play_pause_overlay.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/settings_button.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/video_player_slider.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/helpers/responsive.dart';
import 'package:windows_app/providers/media_player_provider.dart';
import 'package:windows_app/utils/duration_utils.dart';
import 'package:windows_app/utils/futures_utils.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class VideoDurationViewer extends StatelessWidget {
  const VideoDurationViewer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return PaddingWrapper(
      child: Row(
        children: [
          Text(
            '${durationToString(mpProvider.videoPosition)} / ${durationToString(mpProvider.videoDuration)}',
            style: h5TextStyle.copyWith(
              color: Colors.white.withOpacity(.8),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoLowerBackgroundShader extends StatelessWidget {
  final bool reverse;
  const VideoLowerBackgroundShader({
    super.key,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Responsive.getHeight(context) / 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: reverse
              ? [
                  Colors.transparent,
                  Colors.black.withOpacity(.4),
                ]
              : [
                  Colors.black.withOpacity(.4),
                  Colors.transparent,
                ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }
}

class VideoMuteFullScreenControllers extends StatelessWidget {
  final VoidCallback toggleLandscape;

  const VideoMuteFullScreenControllers({
    super.key,
    required this.toggleLandscape,
  });

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    var winProvider = winP(context);
    return FadeInRight(
      preferences: AnimationPreferences(
        duration: Duration(milliseconds: 350),
      ),
      child: PaddingWrapper(
        child: Row(
          children: [
            Spacer(),
            CustomIconButton(
              color: Colors.white.withOpacity(.8),
              onTap: () {
                mpProviderFalse.toggleMuteVideo();
              },
              iconData: mpProvider.videoMuted
                  ? FontAwesomeIcons.volumeXmark
                  : FontAwesomeIcons.volumeLow,
            ),
            CustomIconButton(
              onTap: toggleLandscape,
              iconData: winProvider.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
            ),
          ],
        ),
      ),
    );
  }
}

class VideoUpperControllers extends StatelessWidget {
  const VideoUpperControllers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mpProvider = mpP(context);
    return Stack(
      children: [
        VideoLowerBackgroundShader(
          reverse: true,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CloseVideoButton(),
            // Text(
            //   'data',
            //   style: h4LightTextStyle.copyWith(height: 1),
            // ),
            Expanded(
              child: SafeArea(
                child: Text(
                  getFileName(mpProvider.playingVideoPath ?? ''),
                  style: h4TextStyle.copyWith(height: 5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            Spacer(),
            FadeInRight(
              preferences: AnimationPreferences(
                duration: Duration(milliseconds: 350),
              ),
              child: SettingsButton(),
            ),
          ],
        ),
      ],
    );
  }
}

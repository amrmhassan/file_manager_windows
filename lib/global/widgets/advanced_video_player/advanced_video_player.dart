// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:window_manager/window_manager.dart';
import 'package:windows_app/constants/widget_keys.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/base_over_lay.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/controllers_overlay.dart';
import 'package:windows_app/global/widgets/video_player_viewer/widgets/actual_video_player.dart';
import 'package:windows_app/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';

class AdvancedVideoPlayer extends StatefulWidget {
  final bool isOverlay;
  final OverlayEntry? overlayEntry;

  const AdvancedVideoPlayer({
    Key? key,
    this.isOverlay = false,
    this.overlayEntry,
  }) : super(key: key);

  @override
  State<AdvancedVideoPlayer> createState() => _AdvancedVideoPlayerState();
}

class _AdvancedVideoPlayerState extends State<AdvancedVideoPlayer>
    with WidgetsBindingObserver {
  OverlayEntry? overlayEntry;
  bool controllerOverLayViewed = true;

//? to toggle between them
  void toggleLandScape() async {
    await winPF(context).toggleFullScreen();
    if (winPF(context).isFullScreen) {
      //? here i want to show an overlay for viewing the video
      overlayEntry = OverlayEntry(
        builder: (context) => Scaffold(
          body: AdvancedVideoPlayer(
            isOverlay: true,
            overlayEntry: overlayEntry,
          ),
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Overlay.of(context).insert(overlayEntry!);
      });
    } else {
      widget.overlayEntry?.remove();
      //? i here i want to hide the overlay for vieweing the video
    }
  }

//?
  void setControllersOverlayViewed(bool v) {
    setState(() {
      controllerOverLayViewed = v;
    });
  }

//?
  void toggleControllerOverLayViewed() async {
    setState(() {
      controllerOverLayViewed = !controllerOverLayViewed;
    });
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();

    var mediaProvider =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    if (mediaProvider.videoPlayerController == null) return;
  }

  @override
  void dispose() {
    Wakelock.disable();
    winPF(navigatorKey.currentContext!).setFullScreen(false, false);
    overlayEntry?.remove();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    var winProvider = winP(context);
    return winProvider.isFullScreen && !widget.isOverlay
        ? SizedBox()
        : RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (value) {
              if (value.character == null) return;
              print(value.character);
              if (value.character == ' ') {
                mpPF(context).toggleVideoPlay();
              }
            },
            autofocus: true,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ActualVideoPlayer(
                  mpProvider: mpProvider,
                ),
                BaseOverLay(
                  toggleControllerOverLayViewed: toggleControllerOverLayViewed,
                ),
                if (controllerOverLayViewed)
                  ControllersOverlay(
                    toggleControllerOverLayViewed:
                        toggleControllerOverLayViewed,
                    toggleLandscape: toggleLandScape,
                  ),
              ],
            ),
          );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_right.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/custom_icon_button.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/providers/media_player_provider.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';

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

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_right.dart';
import 'package:windows_app/analyzing_code/globals/files_folders_operations.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/close_video_button.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/controllers_overlay.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/settings_button.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/video_lower_background_shader.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';

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

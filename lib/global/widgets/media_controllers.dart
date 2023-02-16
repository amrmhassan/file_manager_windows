// ignore_for_file: prefer_const_constructors

import 'package:windows_app/global/widgets/normal_media_player.dart';
import 'package:windows_app/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaControllers extends StatelessWidget {
  const MediaControllers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return mpProvider.audioPlaying && !mpProvider.playerHidden
        ? NormalMediaPlayer()
        : SizedBox();
  }
}

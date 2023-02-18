// ignore_for_file: prefer_const_constructors

import 'package:windows_app/analyzing_code/globals/files_folders_operations.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/files_types_icons.dart';
import 'package:windows_app/constants/server_constants.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/providers/media_player_provider.dart';
import 'package:windows_app/providers/server_provider.dart';
import 'package:windows_app/providers/shared_items_explorer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:windows_app/utils/server_utils/connection_utils.dart';

class MediaPlayerButton extends StatefulWidget {
  final String mediaPath;
  final bool network;

  const MediaPlayerButton({
    Key? key,
    required this.mediaPath,
    required this.network,
  }) : super(key: key);

  @override
  State<MediaPlayerButton> createState() => _MediaPlayerButtonState();
}

class _MediaPlayerButtonState extends State<MediaPlayerButton> {
  //? this will check if the current path is the active path in the media player or not
  bool isMyPathActive(String? playingFilePath) {
    bool res = playingFilePath == widget.mediaPath;
    return res;
  }

  bool mePlaying(String? playingFilePath, bool isPlaying) {
    return isMyPathActive(playingFilePath) && isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    FileType fileType = getFileType(getFileExtension(widget.mediaPath));

    return fileType == FileType.audio
        ? ButtonWrapper(
            onTap: () async {
              //
              if (mePlaying(
                  mpProvider.playingAudioFilePath, mpProvider.audioPlaying)) {
                // here i am playing and i want to pause
                await mpProviderFalse.pausePlaying();
              } else {
                String? connLink;
                if (widget.network) {
                  connLink = getConnLink(connectPPF(context).remoteIP!,
                      connectPPF(context).remotePort!, streamAudioEndPoint);
                }

                // here i want to start over
                await mpProviderFalse.setPlayingFile(
                  widget.network ? '$connLink' : widget.mediaPath,
                  widget.network,
                  widget.mediaPath,
                );
              }
            },
            width: largeIconSize,
            height: largeIconSize,
            child: Image.asset(
              mePlaying(
                mpProvider.playingAudioFilePath,
                mpProvider.audioPlaying,
              )
                  ? 'assets/icons/pause.png'
                  : 'assets/icons/play-audio.png',
              width: largeIconSize / 2,
              color: kInactiveColor,
            ),
          )
        : fileType == FileType.video
            ? ButtonWrapper(
                onTap: () async {
                  if (widget.network) {
                    String? connLink;
                    if (widget.network) {
                      connLink = getConnLink(connectPPF(context).remoteIP!,
                          connectPPF(context).remotePort!, streamVideoEndPoint);
                    }

                    mpProviderFalse.playVideo(
                      '$connLink',
                      widget.network,
                      widget.mediaPath,
                    );
                    mpProviderFalse.setBottomVideoControllersHidden(false);
                  } else {
                    mpProviderFalse.playVideo(widget.mediaPath, widget.network);
                  }
                },
                width: largeIconSize,
                height: largeIconSize,
                child: Image.asset(
                  'assets/icons/view.png',
                  width: largeIconSize / 1.5,
                  color: kInactiveColor,
                ),
              )
            : SizedBox();
  }
}

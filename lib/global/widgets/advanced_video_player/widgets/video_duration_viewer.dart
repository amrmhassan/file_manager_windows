import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/providers/media_player_provider.dart';
import 'package:windows_app/utils/duration_utils.dart';

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

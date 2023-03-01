// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/video_fast_seeker.dart';
import 'package:windows_app/helpers/responsive.dart';
import 'package:flutter/material.dart';

class BaseOverLay extends StatelessWidget {
  // this will be clicked when no other element is being clicked
  final VoidCallback toggleControllerOverLayViewed;
  const BaseOverLay({
    super.key,
    required this.toggleControllerOverLayViewed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                toggleControllerOverLayViewed();
              },
              child: Opacity(
                opacity: 1,
                child: Container(
                  height: Responsive.getHeight(context) - largeIconSize * 1.5,
                  width: Responsive.getWidth(context),
                  color: Colors.transparent,
                ),
              ),
            )
          ],
        ),
        VideoFastSeeker(
          backward: true,
          toggleControllerOverLayViewed: toggleControllerOverLayViewed,
        ),
        VideoFastSeeker(
          backward: false,
          toggleControllerOverLayViewed: toggleControllerOverLayViewed,
        ),
      ],
    );
  }
}

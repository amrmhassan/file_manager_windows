// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:provider/provider.dart';

class BottomVideoControllers extends StatefulWidget {
  const BottomVideoControllers({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomVideoControllers> createState() => _BottomVideoControllersState();
}

class _BottomVideoControllersState extends State<BottomVideoControllers> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      if (mounted) {
        Provider.of<MediaPlayerProvider>(context, listen: false)
            .setBottomVideoControllersHidden(true);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FadeInUp(
          preferences:
              AnimationPreferences(duration: Duration(milliseconds: 500)),
          child: Container(
            color: Colors.black.withOpacity(.8),
            child: Column(
              children: [
                VSpace(),
                PaddingWrapper(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonWrapper(
                        onTap: () {
                          mpProviderFalse.closeVideo();
                        },
                        padding: EdgeInsets.all(mediumPadding),
                        child: Image.asset(
                          'assets/icons/stop-button.png',
                          color: kMainIconColor,
                          width: mediumIconSize,
                        ),
                      ),
                      ButtonWrapper(
                        onTap: () {
                          mpProviderFalse.toggleHideVideo();
                        },
                        padding: EdgeInsets.all(mediumPadding),
                        child: Image.asset(
                          'assets/icons/close-eye.png',
                          color: kMainIconColor,
                          width: mediumIconSize,
                        ),
                      ),
                    ],
                  ),
                ),
                VSpace(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/screens/download_manager_screen/download_manager_screen.dart';
import 'package:windows_app/screens/share_screen/widgets/downloading_overlay.dart';
import 'package:windows_app/screens/share_screen/widgets/share_screen_tab_button.dart';
import 'package:windows_app/screens/share_settings_screen/share_settings_screen.dart';
import 'package:flutter/material.dart';

class ShareScreenNavBar extends StatelessWidget {
  const ShareScreenNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kCardBackgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: kHPad * 1.5,
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(
            children: [
              ShareScreenTabButton(
                title: 'Recent',
                iconName: 'clock',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    DownloadManagerScreen.routeName,
                  );
                },
              ),
              DownloadingOverLay(),
            ],
          ),
          ShareScreenTabButton(
            title: 'Share',
            iconName: 'link',
            onTap: () {},
            active: true,
          ),
          ShareScreenTabButton(
            title: 'Settings',
            iconName: 'settings',
            onTap: () {
              Navigator.pushNamed(context, ShareSettingsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:flutter/material.dart';

class DownloadSpeedViewer extends StatelessWidget {
  const DownloadSpeedViewer({
    super.key,
    required this.downloadSpeed,
  });

  final double downloadSpeed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kCardBackgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: kHPad,
        vertical: kVPad / 2,
      ),
      child: Row(
        children: [
          Text(
            'Speed',
            style: h3InactiveTextStyle,
          ),
          Spacer(),
          Text(
            '${downloadSpeed.toStringAsFixed(2)} Mb/s',
            style: h4TextStyleInactive,
          ),
        ],
      ),
    );
  }
}

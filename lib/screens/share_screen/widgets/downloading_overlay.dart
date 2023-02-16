// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/providers/download_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadingOverLay extends StatelessWidget {
  const DownloadingOverLay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var downloadProvider = Provider.of<DownloadProvider>(context);
    var activeTasks = downloadProvider.activeTasks;

    return activeTasks.isEmpty
        ? SizedBox()
        : Container(
            alignment: Alignment.center,
            width: mediumIconSize / 1.4,
            height: mediumIconSize / 1.4,
            decoration: BoxDecoration(
              color: kBlueColor,
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Text(
              activeTasks.length.toString(),
              style: h4TextStyle.copyWith(height: 1),
              textAlign: TextAlign.center,
            ),
          );
  }
}

// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:windows_app/providers/util/analyzer_provider.dart';
import 'package:windows_app/providers/recent_provider.dart';
import 'package:windows_app/screens/home_screen/widgets/app_bar_icon_button.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RescanButton extends StatelessWidget {
  const RescanButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isWindows
        ? SizedBox()
        : AppBarIconButton(
            onTap: () {
              showSnackBar(context: context, message: 'Rescanning');
              var recentProvider =
                  Provider.of<RecentProvider>(context, listen: false);
              Provider.of<AnalyzerProvider>(context, listen: false)
                  .clearAllData();
              Provider.of<AnalyzerProvider>(context, listen: false)
                  .handleAnalyzeEvent(recentProvider);
            },
            iconName: 'reload',
          );
  }
}

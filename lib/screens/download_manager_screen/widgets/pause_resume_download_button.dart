// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/models/download_task_model.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class PauseResumeControllers extends StatelessWidget {
  final DownloadTaskModel downloadTaskModel;
  const PauseResumeControllers({
    super.key,
    required this.downloadTaskModel,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      padding: EdgeInsets.all(smallPadding),
      borderRadius: smallBorderRadius,
      onTap: () {
        downPF(context).togglePauseResumeTask(
          downloadTaskModel.id,
          serverPF(context),
          sharePF(context),
        );
      },
      child: Image.asset(
        'assets/icons/${downloadTaskModel.taskStatus == TaskStatus.downloading ? 'pause' : 'play'}.png',
        width: smallIconSize,
        color: kMainIconColor.withOpacity(.6),
      ),
    );
  }
}

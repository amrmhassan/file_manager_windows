import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/models/download_task_model.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskSubInfo extends StatelessWidget {
  final DownloadTaskModel downloadTaskModel;
  const TaskSubInfo({
    super.key,
    required this.downloadTaskModel,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      downloadTaskModel.taskStatus == TaskStatus.finished
          ? DateFormat('hh:mm aa').format(downloadTaskModel.finishedAt!)
          : capitalizeWord(downloadTaskModel.taskStatus.name),
      style: h4TextStyleInactive,
    );
  }
}

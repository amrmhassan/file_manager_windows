// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/modals/double_buttons_modal.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/models/download_task_model.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/screens/download_manager_screen/widgets/download_percent_bar.dart';
import 'package:windows_app/screens/download_manager_screen/widgets/failed_task_controllers.dart';
import 'package:windows_app/screens/download_manager_screen/widgets/finished_task_info.dart';
import 'package:windows_app/screens/download_manager_screen/widgets/pause_resume_download_button.dart';
import 'package:windows_app/screens/download_manager_screen/widgets/task_sub_info.dart';
import 'package:windows_app/utils/files_operations_utils/files_utils.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:windows_app/utils/screen_utils/home_screen_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;

class DownloadCard extends StatefulWidget {
  const DownloadCard({
    super.key,
    required this.downloadTaskModel,
  });

  final DownloadTaskModel downloadTaskModel;

  @override
  State<DownloadCard> createState() => _DownloadCardState();
}

class _DownloadCardState extends State<DownloadCard> {
  final ScrollController _downloadCardScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // if (widget.downloadTaskModel.size == 0 &&
    //     widget.downloadTaskModel.count == 0) {
    //   //! this is an error, for files with 0 size and 0 count
    //   return SizedBox();
    // }
    return Dismissible(
      direction: widget.downloadTaskModel.taskStatus == TaskStatus.finished
          ? DismissDirection.none
          : DismissDirection.endToStart,
      background: Container(
        padding:
            EdgeInsets.symmetric(horizontal: kHPad / 2, vertical: kVPad / 2),
        child: Container(
          padding: EdgeInsets.only(right: kHPad),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(largeBorderRadius),
          ),
          child: Image.asset(
            'assets/icons/delete.png',
            color: Colors.white,
            width: mediumIconSize,
          ),
        ),
      ),
      key: Key(widget.downloadTaskModel.id),
      confirmDismiss: (direction) async {
        var confirm = await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => DoubleButtonsModal(
            autoPop: false,
            onOk: () {
              Navigator.pop(context, true);
            },
            onCancel: () => Navigator.pop(context),
            title: 'Confirm Delete?',
            subTitle: 'Delete this task from storage?',
          ),
        );
        if (confirm == true) {
          //! here i want to delete a task, from storage and from state
          downPF(context).deleteTaskCompletely(
            widget.downloadTaskModel.id,
            serverPF(context),
            sharePF(context),
            alsoFile: true,
          );

          showSnackBar(context: context, message: 'Deleted');
        }
        return false;
      },
      child: ButtonWrapper(
        onTap: widget.downloadTaskModel.taskStatus == TaskStatus.finished
            ? () {
                openFile(widget.downloadTaskModel.localFilePath, context);
              }
            : null,
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(
            mediumBorderRadius,
          ),
        ),
        margin: EdgeInsets.all(kVPad / 2),
        padding: EdgeInsets.symmetric(
          horizontal: kHPad,
          vertical: kVPad / 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (kDebugMode) Text(widget.downloadTaskModel.taskStatus.name),
            if (kDebugMode)
              Text(
                  'Size:${widget.downloadTaskModel.size}, count ${widget.downloadTaskModel.count}'),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _downloadCardScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      path_operations
                          .basename(widget.downloadTaskModel.remoteFilePath),
                      style: h4TextStyle,
                      overflow: TextOverflow.clip,
                      softWrap: false,
                    ),
                  ),
                ),
                HSpace(factor: .7),
                widget.downloadTaskModel.taskStatus == TaskStatus.downloading ||
                        widget.downloadTaskModel.taskStatus == TaskStatus.paused
                    ? PauseResumeControllers(
                        downloadTaskModel: widget.downloadTaskModel,
                      )
                    : widget.downloadTaskModel.taskStatus == TaskStatus.failed
                        ? FailedTaskControllers(
                            downloadTaskModel: widget.downloadTaskModel,
                          )
                        : TaskSubInfo(
                            downloadTaskModel: widget.downloadTaskModel,
                          ),
              ],
            ),
            if (widget.downloadTaskModel.taskStatus == TaskStatus.downloading ||
                widget.downloadTaskModel.taskStatus == TaskStatus.paused)
              DownloadPercentBar(
                downloadTaskModel: widget.downloadTaskModel,
              )
            else if (widget.downloadTaskModel.taskStatus == TaskStatus.finished)
              FinishedTaskInfo(
                downloadTaskModel: widget.downloadTaskModel,
                navigateToFile: navigateToFile,
              )
          ],
        ),
      ),
    );
  }

  void navigateToFile() {
    if (widget.downloadTaskModel.entityType == EntityType.folder) {
      Directory directory = Directory(widget.downloadTaskModel.localFilePath);
      if (directory.existsSync()) {
        handleOpenTabFromOtherScreen(
          path_operations.dirname(widget.downloadTaskModel.localFilePath),
          context,
          widget.downloadTaskModel.localFilePath,
        );
      } else {
        showSnackBar(
          context: context,
          message: 'folder doesn\'t exist',
          snackBarType: SnackBarType.error,
        );
      }
    } else {
      File file = File(widget.downloadTaskModel.localFilePath);
      if (file.existsSync()) {
        handleOpenTabFromOtherScreen(
          path_operations.dirname(widget.downloadTaskModel.localFilePath),
          context,
          widget.downloadTaskModel.localFilePath,
        );
      } else {
        showSnackBar(
          context: context,
          message: 'file doesn\'t exist',
          snackBarType: SnackBarType.error,
        );
      }
    }
  }
}

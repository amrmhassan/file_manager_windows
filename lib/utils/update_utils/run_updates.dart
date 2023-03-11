// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/constants/widget_keys.dart';
import 'package:windows_app/global/modals/double_buttons_modal.dart';
import 'package:windows_app/utils/files_operations_utils/files_utils.dart';
import 'package:windows_app/utils/update_utils/download_update.dart';
import 'package:windows_app/utils/update_utils/update_constants.dart';
import 'package:windows_app/utils/update_utils/update_helper.dart';

void runUpdates(BuildContext context) async {
  if (!UpdateConstants.allowUpdates) return;
  // update

  logger.i('checking updates');
  var update = UpdateHelper();
  await update.init();
  if (!update.needUpdate) {
    // delete the update folder
    String downloadFolderPath = await DownloadUpdate.getUpdateFolderPath;
    Directory downloadDir = Directory(downloadFolderPath);
    if (downloadDir.existsSync()) {
      await downloadDir.delete(recursive: true);
    }
    return;
  }
  //? checking if the update is already downloaded
  String updateFilePath =
      await DownloadUpdate.getUpdateFilePath(update.latestVersion!.version);
  if (navigatorKey.currentContext == null) return;

  File downloadedUpdateFile = File(updateFilePath);

  if (downloadedUpdateFile.existsSync()) {
    _showInstallUpdateModal(downloadedUpdateFile.path);
  } else {
    logger.i('downloading update');
    String path = await DownloadUpdate().downloadUpdate(
        update.latestVersionLink!, update.latestVersion!.version);
    logger.i('update downloaded');
    _showInstallUpdateModal(path);
  }
}

void _showInstallUpdateModal(String filePath) async {
  try {
    logger.i('opening update file');
    showModalBottomSheet(
      context: navigatorKey.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (context) => DoubleButtonsModal(
        title: 'Update Available!',
        subTitle: 'Install update now?',
        onOk: () {
          openFile(filePath, navigatorKey.currentContext!);
        },
        okText: 'Install',
        okColor: kBlueColor,
      ),
    );
  } catch (e) {
    logger.e(e);
  }
}

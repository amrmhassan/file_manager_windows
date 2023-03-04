// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/global_constants.dart';
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
  if (update.needUpdate) {
    logger.i('downloading update');
    String path = await DownloadUpdate().downloadUpdate(
        update.latestVersionLink!, update.latestVersion!.version);
    logger.i('update downloaded');
    try {
      logger.i('opening update file');
      showModalBottomSheet(
        context: context,
        builder: (context) => DoubleButtonsModal(
          title: 'Update Available!',
          subTitle: 'Install update now?',
          onOk: () {
            openFile(path, context);
          },
          okText: 'Install',
          okColor: kBlueColor,
        ),
      );
    } catch (e) {
      logger.e(e);
    }
  }
}

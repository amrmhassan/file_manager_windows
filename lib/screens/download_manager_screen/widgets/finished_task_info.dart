// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/modals/show_modal_funcs.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/models/download_task_model.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class FinishedTaskInfo extends StatelessWidget {
  final VoidCallback navigateToFile;
  const FinishedTaskInfo({
    super.key,
    required this.downloadTaskModel,
    required this.navigateToFile,
  });

  final DownloadTaskModel downloadTaskModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VSpace(factor: .3),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              handleConvertSize(downloadTaskModel.size!),
              style: h4TextStyleInactive,
            ),
            Spacer(),
            ButtonWrapper(
              padding: EdgeInsets.all(smallPadding),
              borderRadius: smallBorderRadius,
              onTap: navigateToFile,
              child: Image.asset(
                'assets/icons/folder_empty.png',
                width: smallIconSize,
                color: kMainIconColor.withOpacity(.6),
              ),
            ),
            HSpace(factor: .6),
            ButtonWrapper(
              padding: EdgeInsets.all(smallPadding),
              borderRadius: smallBorderRadius,
              onTap: () {
                confirmDeleteEntityModal(
                  context: context,
                  title: 'Delete this task?',
                  subTitle: 'Do you want to delete the actual file also?',
                  cancelText: 'Task Only',
                  okText: 'Also File',
                  onOk: () async {
                    // this will delete the task and the file associated with it
                    try {} catch (e) {
                      showSnackBar(
                        context: context,
                        message: 'File does\'t exist already ',
                        snackBarType: SnackBarType.error,
                      );
                    }
                    showSnackBar(
                      context: context,
                      message: 'Task Deleted',
                    );
                    downPF(context).deleteTaskCompletely(
                      downloadTaskModel.id,
                      serverPF(context),
                      sharePF(context),
                      alsoFile: true,
                    );
                  },
                  onCancel: () async {
                    showSnackBar(
                      context: context,
                      message: 'Task Deleted',
                    );
                    downPF(context).deleteTaskCompletely(
                      downloadTaskModel.id,
                      serverPF(context),
                      sharePF(context),
                      alsoFile: false,
                    );
                  },
                );
              },
              child: Image.asset(
                'assets/icons/delete.png',
                width: smallIconSize,
                color: kDangerColor.withOpacity(.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

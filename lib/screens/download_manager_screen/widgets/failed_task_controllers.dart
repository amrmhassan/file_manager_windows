// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/models/download_task_model.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class FailedTaskControllers extends StatelessWidget {
  final DownloadTaskModel downloadTaskModel;
  const FailedTaskControllers({
    super.key,
    required this.downloadTaskModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonWrapper(
          padding: EdgeInsets.all(mediumPadding),
          onTap: () async {
            var downloadProviderF = downPF(context);
            var serverProviderF = serverPF(context);
            var shareProviderF = sharePF(context);

            try {
              var res = await downloadProviderF.continueFailedTasks(
                downloadTaskModel,
                serverProviderF,
                shareProviderF,
              );
              if (!res) {
                showSnackBar(
                  context: context,
                  message: 'Can\'t resume this failed task',
                  snackBarType: SnackBarType.error,
                );
              }
            } catch (e) {
              showSnackBar(context: context, message: e.toString());
            }
          },
          child: Image.asset(
            'assets/icons/reload.png',
            width: mediumIconSize / 1.5,
            color: kMainIconColor,
          ),
        ),
        HSpace(factor: .5),
        Text(
          'Failed',
          style: h4TextStyleInactive,
        ),
      ],
    );
  }
}

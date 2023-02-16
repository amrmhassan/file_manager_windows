// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QrResultModal extends StatelessWidget {
  final String? code;
  const QrResultModal({
    super.key,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
        color: kBackgroundColor,
        showTopLine: false,
        child: Column(
          children: [
            Text('Scan Result', style: h3InactiveTextStyle),
            VSpace(),
            SelectableText(
              code.toString(),
              style: h4TextStyle.copyWith(overflow: TextOverflow.visible),
            ),
            VSpace(),
            Row(
              children: [
                if (code?.startsWith('http://') ?? false)
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ButtonWrapper(
                            backgroundColor: kBlueColor,
                            padding: EdgeInsets.symmetric(vertical: kVPad / 2),
                            onTap: () {
                              launchUrlString(
                                code!,
                                mode: LaunchMode.externalApplication,
                              );
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Open Website',
                              style: h4TextStyle,
                            ),
                          ),
                        ),
                        HSpace(),
                      ],
                    ),
                  ),
                Expanded(
                  child: ButtonWrapper(
                    backgroundColor: kBlueColor,
                    padding: EdgeInsets.symmetric(vertical: kVPad / 2),
                    onTap: () {
                      copyToClipboard(context, code ?? '');
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Copy',
                      style: h4TextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

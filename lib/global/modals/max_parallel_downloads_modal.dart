// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:windows_app/providers/download_provider.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class MaximumParallelDownloadModal extends StatelessWidget {
  const MaximumParallelDownloadModal({
    super.key,
    required this.downloadProvider,
  });

  final DownloadProvider downloadProvider;

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
      bottomPaddingFactor: .1,
      afterLinePaddingFactor: .5,
      showTopLine: false,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: kHPad),
      color: kCardBackgroundColor,
      child: Expanded(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: List.generate(
              8,
              (index) => ListTile(
                    leading: Opacity(
                      opacity:
                          (index + 1) == downloadProvider.maxDownloadsAtAtime
                              ? 1
                              : 0,
                      child: Image.asset(
                        'assets/icons/check.png',
                        color: kMainIconColor,
                        width: smallIconSize,
                      ),
                    ),
                    onTap: () {
                      downPF(context).updateMaxParallelDownloads(
                        index + 1,
                        serverPF(context),
                        sharePF(context),
                      );
                      Navigator.pop(context);
                    },
                    title: Text(
                      (index + 1).toString(),
                      style: h3LightTextStyle,
                    ),
                  )),
        ),
      ),
    );
  }
}

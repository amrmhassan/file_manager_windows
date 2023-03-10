// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:flutter/material.dart';

class DetailItem extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final bool allowCopy;

  const DetailItem({
    Key? key,
    required this.title,
    required this.value,
    this.valueColor,
    this.allowCopy = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  h4LiteTextStyle.copyWith(color: Colors.white.withOpacity(.8)),
            ),
            HSpace(factor: .6),
            Expanded(
              child: GestureDetector(
                onTap: allowCopy
                    ? () {
                        copyToClipboard(context, value);
                        showSnackBar(
                            context: context, message: 'Copied To Clipboard');
                        Navigator.pop(context);
                      }
                    : null,
                child: Text(
                  value,
                  style:
                      h4LiteTextStyle.copyWith(color: valueColor ?? kBlueColor),
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
        VSpace(factor: .5),
      ],
    );
  }
}

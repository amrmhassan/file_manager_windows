// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:flutter/material.dart';

class DoubleButtonsModal extends StatelessWidget {
  final String title;
  final String? subTitle;
  final VoidCallback onOk;
  final VoidCallback? onCancel;
  final String? okText;
  final String? cancelText;
  final Color? okColor;
  final Color? cancelColor;
  final bool autoPop;
  final bool reverseButtonsOrder;
  final Widget? extra;
  final bool showCancelButton;

  const DoubleButtonsModal({
    Key? key,
    required this.onOk,
    required this.title,
    this.onCancel,
    this.subTitle,
    this.okText,
    this.cancelText,
    this.okColor,
    this.cancelColor,
    this.autoPop = true,
    this.reverseButtonsOrder = false,
    this.extra,
    this.showCancelButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var modalButtons = [
      if (showCancelButton)
        Expanded(
          child: ButtonWrapper(
            onTap: () {
              if (onCancel != null) onCancel!();
              if (autoPop) {
                Navigator.pop(context);
              }
            },
            padding: EdgeInsets.symmetric(
                horizontal: kHPad / 2, vertical: kVPad / 2),
            backgroundColor: cancelColor ?? kBackgroundColor,
            child: Text(
              cancelText ?? 'Cancel',
              style: h4TextStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
      if (showCancelButton) HSpace(),
      Expanded(
        child: ButtonWrapper(
          onTap: () async {
            onOk();
            if (autoPop) {
              Navigator.pop(context);
            }
          },
          padding:
              EdgeInsets.symmetric(horizontal: kHPad / 2, vertical: kVPad / 2),
          backgroundColor: okColor ?? kDangerColor,
          child: Text(
            okText ?? 'Delete',
            style: h4TextStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    ];
    return ModalWrapper(
      showTopLine: false,
      color: kCardBackgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: h3TextStyle,
              ),
            ],
          ),
          if (subTitle != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    subTitle.toString(),
                    style: h4TextStyleInactive,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                ),
              ],
            ),
          if (extra != null) extra! else VSpace(),
          Row(
            children: reverseButtonsOrder
                ? modalButtons.reversed.toList()
                : modalButtons,
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:flutter/material.dart';

class ErrorOpenFolder extends StatelessWidget {
  final String? msg;

  const ErrorOpenFolder({
    Key? key,
    this.msg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/warning.png',
          width: largeIconSize * 2,
        ),
        VSpace(factor: .5),
        Text(
          msg ?? 'Your Android System Prevent Viewing This Folder',
          style: h4TextStyleInactive.copyWith(
            color: kInactiveColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

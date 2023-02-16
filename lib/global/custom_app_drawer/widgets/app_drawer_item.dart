// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppDrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String? iconPath;
  final bool onlyDebug;

  const AppDrawerItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.iconPath,
    this.onlyDebug = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (onlyDebug && kDebugMode) || (allowDevBoxes && kReleaseMode)
        ? ButtonWrapper(
            borderRadius: 0,
            onTap: onTap,
            child: ListTile(
              leading: Image.asset(
                'assets/icons/${iconPath ?? 'menu'}.png',
                width: mediumIconSize,
                color: kInactiveColor,
              ),
              title: Text(
                title,
                style: h4TextStyle.copyWith(color: kInactiveColor),
              ),
            ),
          )
        : SizedBox();
  }
}

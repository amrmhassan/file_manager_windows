// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

class OperationButton extends StatelessWidget {
  final String iconName;
  final VoidCallback onTap;

  const OperationButton({
    Key? key,
    required this.iconName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ButtonWrapper(
        borderRadius: 500,
        padding: EdgeInsets.all(ultraLargePadding),
        onTap: onTap,
        child: Image.asset(
          'assets/icons/$iconName.png',
          width: smallIconSize,
          color: kMainIconColor,
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

class AppBarIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconName;
  final Color? color;
  final double borderRadius;

  const AppBarIconButton({
    Key? key,
    required this.onTap,
    required this.iconName,
    this.color,
    this.borderRadius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: onTap,
      borderRadius: borderRadius,
      padding: EdgeInsets.symmetric(
        horizontal: kHPad,
        vertical: kVPad,
      ),
      child: Image.asset(
        'assets/icons/$iconName.png',
        width: largeIconSize / 2,
        color: color ?? kInactiveColor,
      ),
    );
  }
}

//* this widget will keep the appbar height constant during navigating between explorer screen and analyzer screen
class EmptyAppBarIconButton extends StatelessWidget {
  const EmptyAppBarIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: largeIconSize + kVPad,
      width: largeIconSize + kVPad,
    );
  }
}

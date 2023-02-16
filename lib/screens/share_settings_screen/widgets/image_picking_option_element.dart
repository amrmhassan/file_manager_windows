// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

class ImagePickingOptionElement extends StatelessWidget {
  final String iconName;
  final VoidCallback onTap;

  const ImagePickingOptionElement({
    Key? key,
    required this.iconName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: onTap,
      padding: EdgeInsets.all(largePadding),
      backgroundColor: Colors.transparent,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(500),
        border: Border.all(width: 2, color: kMainIconColor.withOpacity(.5)),
      ),
      child: Image.asset(
        'assets/icons/$iconName.png',
        color: kMainIconColor.withOpacity(.5),
        width: largeIconSize,
      ),
    );
  }
}

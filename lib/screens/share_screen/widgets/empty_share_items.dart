// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class EmptyShareItems extends StatelessWidget {
  final String? title;
  const EmptyShareItems({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        Image.asset(
          'assets/icons/empty-inbox.png',
          width: largeIconSize * 1.5,
          color: kMainIconColor,
        ),
        VSpace(),
        Text(
          title ?? 'your-empty-share-space'.i18n(),
          textAlign: TextAlign.center,
          style: h4TextStyleInactive,
        ),
      ],
    );
  }
}

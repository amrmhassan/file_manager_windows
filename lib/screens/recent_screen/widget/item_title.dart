// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:flutter/material.dart';

class ItemTitle extends StatelessWidget {
  final String title;
  final Color color;

  const ItemTitle({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: smallIconSize / 2,
          height: smallIconSize / 2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(500),
          ),
        ),
        HSpace(factor: .2),
        Text(
          title,
          style: h4TextStyleInactive.copyWith(height: 1),
        )
      ],
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:flutter/material.dart';

class RecentItem extends StatefulWidget {
  final String title;
  final List<Widget> children;
  const RecentItem({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  State<RecentItem> createState() => _RecentItemState();
}

class _RecentItemState extends State<RecentItem> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonWrapper(
          borderRadius: 0,
          splash: false,
          padding: EdgeInsets.only(
            right: kHPad / 1,
            left: kHPad / 1,
            top: kVPad / 2,
            bottom: kVPad / 2,
          ),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            children: [
              Transform(
                origin: Offset(mediumIconSize / 2, mediumIconSize / 2),
                transform: Matrix4.rotationZ(!isExpanded ? 0 : 90 * (pi / 180)),
                child: Image.asset(
                  'assets/icons/right-arrow.png',
                  color: kInactiveColor,
                  width: mediumIconSize,
                ),
              ),
              HSpace(),
              Text(
                widget.title,
                style: h3TextStyle.copyWith(
                  color: kInactiveColor,
                ),
              )
            ],
          ),
        ),
        AnimatedContainer(
          duration: recentExpandDuration,
          height: isExpanded ? 100 : 0,
          child: ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              HSpace(),
              ...widget.children,
              ButtonWrapper(
                onTap: () {},
                margin: EdgeInsets.only(right: kHPad / 2),
                backgroundColor: kBackgroundColor,
                width: 100,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/right-arrow.png',
                      color: Colors.white,
                      width: ultraLargeIconSize,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/screens/recent_screen/widget/recents_item.dart';
import 'package:flutter/material.dart';

//! this will hold the last 100 files of each type
//! with the first 2 of them in the main screen

class RecentWidget extends StatelessWidget {
  const RecentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaddingWrapper(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(mediumBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaddingWrapper(
              padding: EdgeInsets.only(
                right: kHPad / 1,
                left: kHPad / 1,
                top: kVPad / 2,
              ),
              child: Text(
                'Recent',
                style: h3TextStyle.copyWith(color: Colors.white),
              ),
            ),
            RecentItem(
              title: 'Images',
              children: List.generate(
                5,
                (index) => ButtonWrapper(
                  onTap: () {},
                  margin: EdgeInsets.only(right: kHPad / 2),
                  backgroundColor: Colors.white,
                  width: 100,
                  height: 100,
                  child: Container(),
                ),
              ),
            ),
            RecentItem(
              title: 'Books',
              children: List.generate(
                5,
                (index) => ButtonWrapper(
                  onTap: () {},
                  margin: EdgeInsets.only(right: kHPad / 2),
                  backgroundColor: Colors.white,
                  width: 100,
                  height: 100,
                  child: Container(),
                ),
              ),
            ),
            VSpace(),
          ],
        ),
      ),
    );
  }
}

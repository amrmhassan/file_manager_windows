// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/screens/ext_report_screen/ext_report_screen.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:flutter/material.dart';

class CustomHeaderCell extends StatelessWidget {
  final MapEntry<int, HeaderItem> e;
  final SortParameter sortParameter;
  final Function(SortParameter sp) setSortParameter;

  const CustomHeaderCell({
    required this.e,
    Key? key,
    required this.sortParameter,
    required this.setSortParameter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      padding: EdgeInsets.symmetric(horizontal: kHPad / 2, vertical: kVPad / 2),
      borderRadius: 0,
      hoverColor: Colors.transparent,
      focusedColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      inactiveColor: Colors.transparent,
      onTap: () => setSortParam(e.value, sortParameter),
      child: Row(
        mainAxisAlignment: e.key == 0
            ? MainAxisAlignment.start
            : e.key == HeaderItem.values.length - 1
                ? MainAxisAlignment.end
                : MainAxisAlignment.center,
        children: [
          Text(
            capitalizeWord(e.value.name),
            style: h4TextStyleInactive.copyWith(
              color: kActiveTextColor,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          getArrow(e.value, sortParameter),
        ],
      ),
    );
  }

  Widget getArrow(HeaderItem currentItem, SortParameter sortParameter) {
    String imageName = '';
    if (currentItem == HeaderItem.size &&
        sortParameter == SortParameter.sizeDesc) {
      imageName = 'down';
    } else if (currentItem == HeaderItem.size &&
        sortParameter == SortParameter.sizeAsc) {
      imageName = 'up';
    } else if (currentItem == HeaderItem.name &&
        sortParameter == SortParameter.nameDesc) {
      imageName = 'down';
    } else if (currentItem == HeaderItem.name &&
        sortParameter == SortParameter.nameAsc) {
      imageName = 'up';
    } else if (currentItem == HeaderItem.count &&
        sortParameter == SortParameter.countDesc) {
      imageName = 'down';
    } else if (currentItem == HeaderItem.count &&
        sortParameter == SortParameter.countAsc) {
      imageName = 'up';
    } else {
      return SizedBox();
    }
    return Image.asset(
      'assets/icons/arrow-$imageName.png',
      width: smallIconSize,
      color: kMainIconColor,
    );
  }

  void setSortParam(HeaderItem currentItem, SortParameter sortParameter) {
    if (currentItem == HeaderItem.name) {
      if (sortParameter == SortParameter.nameAsc) {
        setSortParameter(SortParameter.nameDesc);
      } else {
        setSortParameter(SortParameter.nameAsc);
      }
    }
    if (currentItem == HeaderItem.count) {
      if (sortParameter == SortParameter.countAsc) {
        setSortParameter(SortParameter.countDesc);
      } else {
        setSortParameter(SortParameter.countAsc);
      }
    }
    if (currentItem == HeaderItem.size) {
      if (sortParameter == SortParameter.sizeAsc) {
        setSortParameter(SortParameter.sizeDesc);
      } else {
        setSortParameter(SortParameter.sizeAsc);
      }
    }
  }
}

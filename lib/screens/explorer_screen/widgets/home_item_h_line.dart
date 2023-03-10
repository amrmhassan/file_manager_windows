import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/global/widgets/h_line.dart';
import 'package:flutter/material.dart';

class HomeItemHLine extends StatelessWidget {
  const HomeItemHLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HLine(
      thickness: 1,
      color: kInactiveColor.withOpacity(.1),
    );
  }
}

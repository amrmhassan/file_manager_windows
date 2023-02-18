// ignore_for_file: prefer_const_constructors

import 'package:windows_app/screens/home_screen/widgets/app_bar_icon_button.dart';
import 'package:flutter/material.dart';

class RescanButton extends StatelessWidget {
  const RescanButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarIconButton(
      onTap: () {},
      iconName: 'reload',
      dummy: true,
    );
  }
}

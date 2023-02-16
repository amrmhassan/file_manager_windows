// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/screens/home_screen/widgets/custom_check_box.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/theme_utils.dart';
import 'package:flutter/material.dart';

class LightThemeCheckBox extends StatelessWidget {
  const LightThemeCheckBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      borderRadius: 0,
      onTap: () {
        toggleLightTheme();
        showSnackBar(
            context: context,
            message: 'You must restart the app to apply theme');
        Navigator.pop(context);
      },
      child: ListTile(
        leading: Image.asset(
          'assets/icons/theme.png',
          width: mediumIconSize,
          color: kInactiveColor,
        ),
        title: Text(
          'Light Theme',
          style: h4TextStyle.copyWith(color: kInactiveColor),
        ),
        trailing: CustomCheckBox(checked: isLight),
      ),
    );
  }
}

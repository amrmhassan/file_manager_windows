// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/helpers/responsive.dart';
import 'package:flutter/material.dart';
import 'package:windows_app/screens/laptop_messages_screen/laptop_messages_screen.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';

class LaptopMessagesButton extends StatelessWidget {
  const LaptopMessagesButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var connLaptopProvider = connectPP(context);
    return (connLaptopProvider.httpServer != null &&
            connLaptopProvider.notViewedLaptopMessages.isNotEmpty &&
            ModalRoute.of(context)?.settings.name !=
                LaptopMessagesScreen.routeName)
        ? Positioned(
            bottom: Responsive.getHeight(context) / 5,
            right: 0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ButtonWrapper(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      LaptopMessagesScreen.routeName,
                    );
                  },
                  padding: EdgeInsets.all(largePadding),
                  width: largeIconSize * 1.5,
                  height: largeIconSize * 1.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(largeBorderRadius),
                    border: Border.all(
                      width: 2,
                      color: kCardBackgroundColor.withOpacity(.5),
                    ),
                    color: kMainIconColor.withOpacity(.2),
                  ),
                  child: Image.asset(
                    'assets/icons/mobile-app.png',
                  ),
                ),
                Positioned(
                  top: -10,
                  left: -10,
                  child: Container(
                    alignment: Alignment.center,
                    width: mediumIconSize,
                    height: mediumIconSize,
                    decoration: BoxDecoration(
                      color: kCardBackgroundColor,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Text(
                      connLaptopProvider.notViewedLaptopMessages.length
                          .toString(),
                      style: h4LightTextStyle.copyWith(height: 1),
                    ),
                  ),
                )
              ],
            ),
          )
        : SizedBox();
  }
}

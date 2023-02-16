import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/screens/selected_items_screen/selected_items_screen.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class SelectedItemNumber extends StatelessWidget {
  const SelectedItemNumber({
    Key? key,
    this.tap = true,
  }) : super(key: key);

  final bool tap;

  @override
  Widget build(BuildContext context) {
    var foProvider = foP(context);
    return ButtonWrapper(
      onTap: tap
          ? () {
              Navigator.pushNamed(context, SelectedItemsScreen.routeName);
            }
          : null,
      alignment: Alignment.center,
      width: mediumIconSize,
      height: mediumIconSize,
      decoration: BoxDecoration(
        color: kLightCardBackgroundColor,
        borderRadius: BorderRadius.circular(mediumBorderRadius),
      ),
      child: Text(
        foProvider.selectedItems.length.toString(),
        style: h4TextStyle.copyWith(color: Colors.white),
      ),
    );
  }
}

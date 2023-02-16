// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, use_build_context_synchronously

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/global/modals/show_modal_funcs.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

class AddListyButton extends StatelessWidget {
  const AddListyButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      width: largeIconSize,
      height: largeIconSize,
      onTap: () {
        createNewFolderModal(context, true);
      },
      child: Image.asset(
        'assets/icons/plus.png',
        color: kMainIconColor,
        width: largeIconSize / 2,
      ),
    );
  }
}

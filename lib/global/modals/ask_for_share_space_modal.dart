// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/modals/double_buttons_modal.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/screens/home_screen/widgets/custom_check_box.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class AskForShareSpaceModal extends StatefulWidget {
  const AskForShareSpaceModal({
    super.key,
    required this.userName,
    required this.deviceID,
  });

  final String userName;
  final String deviceID;

  @override
  State<AskForShareSpaceModal> createState() => _AskForShareSpaceModalState();
}

class _AskForShareSpaceModalState extends State<AskForShareSpaceModal> {
  bool remember = true;
  @override
  Widget build(BuildContext context) {
    return DoubleButtonsModal(
      onOk: () async {
        await serverPF(context).blockDevice(widget.deviceID, remember);
        showSnackBar(
          context: context,
          message: 'Block considering remember $remember',
          snackBarType: SnackBarType.error,
        );
        // this will tell the parent function that it is blocked
        Navigator.pop(context, false);
      },
      onCancel: () async {
        await serverPF(context).allowDevice(widget.deviceID, remember);
        showSnackBar(
          context: context,
          message: 'Allow considering remember $remember',
        );

        // this will tell the parent function that it is allowed
        Navigator.pop(context, true);
      },
      autoPop: false,
      okText: 'Block',
      cancelColor: kBlueColor,
      cancelText: 'Allow',
      title: 'Share Space Request',
      subTitle: '${widget.userName} want\'s to access your share space',
      reverseButtonsOrder: true,
      extra: GestureDetector(
        onTap: () {
          setState(() {
            remember = !remember;
          });
        },
        child: Column(
          children: [
            VSpace(factor: .6),
            Row(
              children: [
                CustomCheckBox(
                  checked: remember,
                ),
                HSpace(factor: .4),
                Text(
                  'Remember for later',
                  style: h4TextStyleInactive,
                ),
              ],
            ),
            VSpace(),
          ],
        ),
      ),
    );
  }
}

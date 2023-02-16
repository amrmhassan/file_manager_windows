// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/modals/double_buttons_modal.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/helpers/responsive.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/screens/qr_code_viewer_screen/qr_code_viewer_screen.dart';
import 'package:windows_app/utils/errors_collection/custom_exception.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class ShareControllersButtons extends StatefulWidget {
  const ShareControllersButtons({
    Key? key,
  }) : super(key: key);

  @override
  State<ShareControllersButtons> createState() =>
      _ShareControllersButtonsState();
}

class _ShareControllersButtonsState extends State<ShareControllersButtons> {
  Future<bool> localOpenServerHandler([bool wifi = true]) async {
    await serverPF(context).openServer(
      sharePF(context),
      MemberType.host,
      shareExpPF(context),
      wifi,
    );
    return serverPF(context).httpServer != null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.getWidth(context),
      child: PaddingWrapper(
        padding: EdgeInsets.symmetric(horizontal: kHPad * 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWrapper(
              padding: EdgeInsets.symmetric(
                horizontal: kHPad * 2,
                vertical: kVPad / 2,
              ),
              onTap: () async {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => DoubleButtonsModal(
                    onOk: () async {
                      try {
                        bool res = await localOpenServerHandler(false);
                        if (res) {
                          Navigator.pushNamed(
                              context, QrCodeViewerScreen.routeName);
                        }
                      } catch (e, s) {
                        showSnackBar(
                          context: context,
                          message: CustomException(
                            e: e,
                            s: s,
                          ).toString(),
                          snackBarType: SnackBarType.error,
                        );
                      }
                    },
                    okText: 'HotSpot',
                    okColor: kBlueColor,
                    onCancel: () async {
                      //? here just open the server on the currently connected wifi
                      try {
                        await localOpenServerHandler(true);
                        Navigator.pushNamed(
                            context, QrCodeViewerScreen.routeName);
                      } catch (e, s) {
                        showSnackBar(
                          context: context,
                          message: CustomException(
                            e: e,
                            s: s,
                          ).toString(),
                          snackBarType: SnackBarType.error,
                        );
                      }
                    },
                    cancelText: 'WiFi',
                    title: 'Choose a network to connect through',
                  ),
                );
                // }
              },
              backgroundColor: Colors.white,
              child: Text(
                'Host',
                style: h3TextStyle.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

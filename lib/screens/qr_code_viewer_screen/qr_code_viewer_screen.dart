// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/providers/server_provider.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeViewerScreen extends StatelessWidget {
  static const String routeName = '/QrCodeViewerScreen';
  const QrCodeViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var serverProvider = Provider.of<ServerProvider>(context);
    var connPhoneProvider = connectPP(context);
    String? quickSendLink;
    bool? laptop;

    var receivedData = ModalRoute.of(context)?.settings.arguments;
    if (receivedData is String) {
      quickSendLink = receivedData;
    } else if (receivedData is bool) {
      laptop = receivedData;
    }

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'No Data Needed',
              style: h2TextStyle.copyWith(
                color: kActiveTextColor,
              ),
            ),
            rightIcon: Row(
              children: [
                ButtonWrapper(
                  padding: EdgeInsets.all(largePadding),
                  borderRadius: 0,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: kMainIconColor,
                    size: mediumIconSize,
                  ),
                ),
                SizedBox(width: kHPad / 2),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You can go back after scanning'),
                VSpace(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: kHPad),
                  child: Column(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 250,
                          maxHeight: 250,
                          minHeight: 100,
                          minWidth: 100,
                        ),
                        child: QrImage(
                          backgroundColor: Colors.white,
                          data: laptop == true
                              ? connPhoneProvider.myConnLink!
                              : (quickSendLink ?? serverProvider.myConnLink!),
                        ),
                      ),
                      // SelectableText(
                      //   quickSendLink ?? serverProvider.myConnLink!,
                      //   style: h3InactiveTextStyle,
                      // ),
                      VSpace(),
                      if (quickSendLink != null && laptop != true)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonWrapper(
                              padding: EdgeInsets.symmetric(
                                horizontal: kHPad,
                                vertical: kVPad / 2,
                              ),
                              onTap: () async {
                                await quickSPF(context).closeSend();
                                Navigator.pop(context);
                              },
                              backgroundColor: kDangerColor,
                              child: Text(
                                'Close Send',
                                style: h4TextStyle,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          PaddingWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: double.infinity),
                Text('Guides:'),
                PaddingWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1- Connect your devices over the same wifi',
                        style: h4TextStyleInactive,
                      ),
                      Text(
                        '2- Or through either devices hotspot',
                        style: h4TextStyleInactive,
                      ),
                      Text(
                        '3- Scan wih phone from AFM app (Connect Laptop)',
                        style: h4TextStyleInactive,
                      ),
                      Text(
                        '4- Enjoy',
                        style: h4TextStyleInactive,
                      ),
                      VSpace(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

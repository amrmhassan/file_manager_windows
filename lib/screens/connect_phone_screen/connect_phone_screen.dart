// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:windows_app/screens/connect_phone_screen/widgets/phone_storage_card.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:windows_app/utils/server_utils/connection_utils.dart';

class ConnectPhoneScreen extends StatelessWidget {
  static const String routeName = '/ConnectPhoneScreen';
  const ConnectPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var connectPhoneProvider = connectPP(context);
    if (connectPhoneProvider.remoteIP == null) {
      if (Navigator.canPop(context)) {
        Future.delayed(Duration.zero).then((value) {
          Navigator.pop(context);
        });
      }
    }

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Your Phone',
              style: h2TextStyle,
            ),
          ),
          if (kDebugMode && connectPhoneProvider.remoteIP != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    're   ${getConnLink(connectPhoneProvider.remoteIP!, connectPhoneProvider.remotePort!)}'),
                Text(
                    'my ${getConnLink(connectPhoneProvider.myIp!, connectPhoneProvider.myPort)}'),
              ],
            ),
          VSpace(),
          Expanded(
            child: PaddingWrapper(
              child: SingleChildScrollView(
                child: Column(children: [
                  PhoneStorageCard(),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {},
                    title: 'Files Explorer',
                    logoName: 'folder_empty',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {},
                    title: 'Share Space',
                    logoName: 'management',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {},
                    title: 'Copy Clipboard',
                    logoName: 'paste',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {},
                    title: 'Phone Listy',
                    logoName: 'list1',
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {},
                    title: 'Recently Opened',
                    logoName: 'clock',
                    color: kMainIconColor,
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

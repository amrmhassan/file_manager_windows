// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/modals/double_buttons_modal.dart';
import 'package:windows_app/global/modals/send_txt_to_phone_modal.dart';
import 'package:windows_app/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:windows_app/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/models/peer_model.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:windows_app/screens/connect_phone_screen/widgets/phone_storage_card.dart';
import 'package:windows_app/utils/connect_to_phone_utils/connect_to_phone_utils.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:windows_app/utils/server_utils/connection_utils.dart';
import 'package:windows_app/screens/share_space_viewer_screen/share_space_viewer_screen.dart';

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
            leftIcon: IconButton(
              onPressed: () {
                connectPPF(context).closeServer();
              },
              icon: Icon(
                Icons.close,
                color: Colors.red,
              ),
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
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ShareSpaceVScreen.routeName,
                        arguments: true,
                      );
                    },
                    title: 'Files Explorer',
                    logoName: 'folder_empty',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {
                      var phoneConnProvider = connectPPF(context);

                      Navigator.pushNamed(
                        context,
                        ShareSpaceVScreen.routeName,
                        arguments: PeerModel(
                          deviceID: 'null',
                          joinedAt: DateTime.now(),
                          name: 'Phone',
                          memberType: MemberType.client,
                          ip: phoneConnProvider.remoteIP!,
                          port: phoneConnProvider.remotePort!,
                          sessionID: 'null',
                          phone: true,
                        ),
                      );
                    },
                    title: 'Share Space',
                    logoName: 'management',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () async {
                      String? clipboard =
                          await getPhoneClipboard(connectPPF(context));
                      if (clipboard == null) {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => ModalWrapper(
                            showTopLine: false,
                            color: kCardBackgroundColor,
                            child: Text(
                              'Make sure the app is open on phone (not in background)\nThis is due to Android security',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => DoubleButtonsModal(
                            onOk: () {
                              copyToClipboard(context, clipboard);
                            },
                            title: 'Phone Clipboard',
                            subTitle: clipboard,
                            showCancelButton: false,
                            okColor: kBlueColor,
                            okText: 'Copy',
                          ),
                        );
                      }
                    },
                    title: 'Copy Clipboard',
                    logoName: 'paste',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => SendTextToPhoneModal(),
                      );
                    },
                    title: 'Send Text',
                    logoName: 'txt',
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {},
                    title: 'Send File',
                    logoName: 'link',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  // AnalyzerOptionsItem(
                  //   enablePadding: false,
                  //   onTap: () {},
                  //   title: 'Phone Listy',
                  //   logoName: 'list1',
                  // ),
                  // VSpace(),
                  // AnalyzerOptionsItem(
                  //   enablePadding: false,
                  //   onTap: () {},
                  //   title: 'Recently Opened',
                  //   logoName: 'clock',
                  //   color: kMainIconColor,
                  // ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

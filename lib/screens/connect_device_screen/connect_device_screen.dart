// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:windows_app/global/modals/show_modal_funcs.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/models/captures_entity_model.dart';
import 'package:windows_app/models/permission_result_model.dart';
import 'package:windows_app/models/share_space_v_screen_data.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/screens/connect_device_screen/modals/send_text_to_device_modal.dart';
import 'package:windows_app/screens/full_text_screen/full_text_screen.dart';
import 'package:windows_app/screens/laptop_messages_screen/laptop_messages_screen.dart';
import 'package:windows_app/screens/touchpad_screen/touchpad_screen.dart';
import 'package:windows_app/utils/client_utils.dart';
import 'package:windows_app/utils/files_operations_utils/files_utils.dart';
import 'package:flutter/material.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/modals/double_buttons_modal.dart';
import 'package:windows_app/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:windows_app/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/models/peer_model.dart';
import 'package:windows_app/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:windows_app/screens/share_space_viewer_screen/share_space_viewer_screen.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:localization/localization.dart';

class ConnectDeviceScreen extends StatelessWidget {
  static const String routeName = '/ConnectDeviceScreen';
  const ConnectDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PeerModel peerModel =
        ModalRoute.of(context)!.settings.arguments as PeerModel;
    // var connectLaptopProvider = connectLaptopP(context);
    // if (connectLaptopProvider.remoteIP == null) {
    //   if (Navigator.canPop(context)) {
    //     Future.delayed(Duration.zero).then((value) {
    //       Navigator.pop(context);
    //     });
    //   }
    // }

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              peerModel.name,
              style: h2TextStyle,
            ),
            // rightIcon: connectLaptopProvider.laptopMessages.isEmpty
            //     ? null
            //     : Row(
            //         children: [
            //           IconButton(
            //               onPressed: () {
            //                 Navigator.pushNamed(
            //                   context,
            //                   LaptopMessagesScreen.routeName,
            //                 );
            //               },
            //               icon: Icon(
            //                 Icons.message,
            //                 color: kMainIconColor,
            //               )),
            //           HSpace(factor: .3),
            //         ],
            //       ),
            // leftIcon: IconButton(
            //   onPressed: () {
            //     showModalBottomSheet(
            //       backgroundColor: Colors.transparent,
            //       context: context,
            //       builder: (context) => DoubleButtonsModal(
            //         onOk: () {
            //           connectLaptopPF(context).closeServer();
            //         },
            //         okText: 'close'.i18n(),
            //         title: 'close-connection'.i18n(),
            //         subTitle: 'close-connection-note'.i18n(),
            //       ),
            //     );
            //   },
            //   icon: Icon(
            //     Icons.close,
            //     color: Colors.red,
            //   ),
            // ),
          ),
          // if (kDebugMode && connectLaptopProvider.remoteIP != null)
          //   Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //           're   ${getConnLink(connectLaptopProvider.remoteIP!, connectLaptopProvider.remotePort!)}'),
          //       Text(
          //           'my ${getConnLink(connectLaptopProvider.myIp!, connectLaptopProvider.myPort)}'),
          //     ],
          //   ),
          VSpace(),
          Expanded(
            child: PaddingWrapper(
              child: SingleChildScrollView(
                child: Column(children: [
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ShareSpaceVScreen.routeName,
                        arguments: ShareSpaceVScreenData(
                          peerModel: peerModel,
                          dataType: ShareSpaceVScreenDataType.filesExploring,
                        ),
                      );
                    },
                    title: 'files-explorer'.i18n(),
                    logoName: 'folder_empty',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {
                      // var phoneConnProvider = connectLaptopPF(context);

                      // Navigator.pushNamed(
                      //   context,
                      //   ShareSpaceVScreen.routeName,
                      //   arguments: ShareSpaceVScreenData(
                      //     peerModel: PeerModel(
                      //       deviceID: laptopID,
                      //       joinedAt: DateTime.now(),
                      //       name: laptopName,
                      //       memberType: MemberType.client,
                      //       ip: phoneConnProvider.remoteIP!,
                      //       port: phoneConnProvider.remotePort!,
                      //       sessionID: laptopID,
                      //     ),
                      //     laptop: true,
                      //     dataType: ShareSpaceVScreenDataType.shareSpace,
                      //   ),
                      // );
                      Navigator.pushNamed(
                        context,
                        ShareSpaceVScreen.routeName,
                        arguments: ShareSpaceVScreenData(
                          peerModel: peerModel,
                          dataType: ShareSpaceVScreenDataType.shareSpace,
                        ),
                      );
                    },
                    title: 'share-space-intro'.i18n(),
                    logoName: 'management',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () async {
                      PermissionResultModel permissionRes =
                          await showWaitPermissionModal(
                        () => getPeerClipboard(peerModel),
                      );
                      if (permissionRes.error != null) return;
                      String? clipboard = permissionRes.result;
                      // String? clipboard = await getPeerClipboard(peerModel);
                      if (clipboard == null) {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => ModalWrapper(
                            showTopLine: false,
                            color: kCardBackgroundColor,
                            child: Text(
                              'empty-clipboard-note'.i18n(),
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
                              Navigator.pop(context);
                            },
                            title: 'windows-clipboard'.i18n(),
                            subTitle: clipboard,
                            showCancelButton: true,
                            cancelText: 'expand'.i18n(),
                            autoPop: false,
                            onCancel: () {
                              Navigator.pushReplacementNamed(
                                context,
                                FullTextViewerScreen.routeName,
                                arguments: clipboard,
                              );
                            },
                            okColor: kBlueColor,
                            okText: 'copy'.i18n(),
                          ),
                        );
                      }
                    },
                    title: 'copy-clipboard'.i18n(),
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
                        builder: (context) => SendTextToDeviceModal(
                          peerModel: peerModel,
                        ),
                      );
                    },
                    title: 'send-text'.i18n(),
                    logoName: 'txt',
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () async {
                      var res = await file_picker.FilePicker.platform
                          .pickFiles(allowMultiple: true);
                      if (res == null || res.files.isEmpty) return;
                      var capturedFiles =
                          pathsToEntities(res.files.map((e) => e.path));
                      handleSendCapturesFiles(
                        capturedFiles,
                        context,
                        peerModel,
                      );
                      showSnackBar(
                        context: context,
                        message: 'sending-file-to-laptop'.i18n(),
                      );
                    },
                    title: 'send-file'.i18n(),
                    logoName: 'link',
                    color: kMainIconColor,
                  ),
                  VSpace(),

                  if (peerModel.deviceType == DeviceType.windows)
                    AnalyzerOptionsItem(
                      enablePadding: false,
                      onTap: () {
                        Navigator.pushNamed(context, TouchPadScreen.routeName);
                      },
                      title: 'widows-touchpad'.i18n(),
                      logoName: 'touchpad',
                      color: kMainIconColor,
                    ),

                  // AnalyzerOptionsItem(
                  //   enablePadding: false,
                  //   onTap: () {},
                  //   title: 'Windows Listy',
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

  void handleSendCapturesFiles(
    List<CapturedEntityModel> entities,
    BuildContext context,
    PeerModel peerModel,
  ) async {
    try {
      showSnackBar(context: context, message: 'sending-to-phone'.i18n());
      await startSendEntitiesToDevice(
        entities,
        context,
        peerModel,
      );
    } on DioError catch (e) {
      String? refuseMessage = e.response?.data;
      showSnackBar(
        context: context,
        message: refuseMessage ?? e.toString(),
        snackBarType: SnackBarType.error,
      );
    }
  }
}
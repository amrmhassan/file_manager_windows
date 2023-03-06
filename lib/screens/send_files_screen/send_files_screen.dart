// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/helpers/responsive.dart';
import 'package:windows_app/models/captures_entity_model.dart';
import 'package:windows_app/utils/connect_to_phone_utils/connect_to_phone_utils.dart';
import 'package:windows_app/utils/files_operations_utils/files_utils.dart';
import 'package:desktop_drop/desktop_drop.dart' as drop;
import 'package:windows_app/utils/general_utils.dart';
import 'package:file_picker/file_picker.dart' as file_picker;

class SendFilesScreen extends StatefulWidget {
  static const String routeName = '/SendFilesScreen';
  const SendFilesScreen({super.key});

  @override
  State<SendFilesScreen> createState() => _SendFilesScreenState();
}

class _SendFilesScreenState extends State<SendFilesScreen> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Send Files',
              style: h2TextStyle,
            ),
          ),
          VSpace(),
          Expanded(
            child: Center(
              child: drop.DropTarget(
                onDragDone: (details) {
                  var capturedFiles =
                      pathsToEntities(details.files.map((e) => e.path));
                  handleSendCapturesFiles(capturedFiles);
                },
                onDragEntered: (details) {
                  setState(() {
                    active = true;
                  });
                },
                onDragExited: (details) {
                  setState(() {
                    active = false;
                  });
                },
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 400,
                    maxWidth: 400,
                  ),
                  child: ButtonWrapper(
                    onTap: () async {
                      var res = await file_picker.FilePicker.platform
                          .pickFiles(allowMultiple: true);
                      if (res == null || res.files.isEmpty) return;
                      var capturedFiles =
                          pathsToEntities(res.files.map((e) => e.path));
                      handleSendCapturesFiles(capturedFiles);
                    },
                    width: Responsive.getWidth(context) / 1.2,
                    height: Responsive.getWidth(context) / 1.2,
                    decoration: BoxDecoration(
                        color: kCardBackgroundColor,
                        borderRadius: BorderRadius.circular(
                          mediumBorderRadius,
                        ),
                        border: Border.all(
                          width: 2,
                          color: kMainIconColor.withOpacity(active ? .5 : .1),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        VSpace(),
                        Image.asset(
                          'assets/icons/folder_empty.png',
                          width: largeIconSize * 3,
                          color: kMainIconColor.withOpacity(active ? .5 : .1),
                        ),
                        VSpace(),
                        active
                            ? Text(
                                'Release to drop',
                                style: h3LightTextStyle,
                              )
                            : RichText(
                                text: TextSpan(
                                  text: 'Drop files here',
                                  style: h3InactiveTextStyle,
                                  children: [
                                    TextSpan(
                                      text: ' or',
                                      style: h3TextStyle,
                                    ),
                                    TextSpan(
                                      text: ' Browse',
                                      style: h3LiteTextStyle.copyWith(
                                        color: Colors.blue,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void handleSendCapturesFiles(List<CapturedEntityModel> entities) async {
    showSnackBar(context: context, message: 'Sending to phone');
    Navigator.pop(context);
    String? path = entities.first.path;
    int fileSize = File(path).lengthSync();
    await startSendFile(path, fileSize, context);
  }
}

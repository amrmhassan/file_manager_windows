// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart' as drop;
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/helpers/responsive.dart';
import 'package:windows_app/models/captures_entity_model.dart';
import 'package:windows_app/utils/files_operations_utils/files_utils.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<CapturedEntityModel> allFiles = [];
  bool active = false;

  @override
  void initState() {
    super.initState();
  }

// 24919807942-p4rl9vtisut00h0huat404h3aple869e.apps.googleusercontent.com
  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Center(
        child: drop.DropTarget(
          onDragDone: (details) {
            var capturedFiles = xfilesToEntities(details.files);
            setState(() {
              allFiles.addAll(capturedFiles);
            });
            print(allFiles.toString());
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
              onTap: () {},
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
    );
  }
}

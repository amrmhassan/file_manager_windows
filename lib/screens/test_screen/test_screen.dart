// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:windows_app/utils/files_operations_utils/files_utils.dart';
import 'package:windows_app/utils/update_utils/download_update.dart';
import 'package:windows_app/utils/update_utils/update_helper.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () async {
                var update = UpdateHelper();
                await update.init();
                if (update.needUpdate) {
                  print('downloading');
                  String path = await DownloadUpdate().downloadUpdate(
                      update.latestVersionLink!, update.latestVersion!.version);
                  print('downloaded');
                  openFile(path, context);
                } else {
                  print('latest version');
                }
              },
              child: Text('Get'),
            ),
          ],
        ),
      ),
    );
  }
}

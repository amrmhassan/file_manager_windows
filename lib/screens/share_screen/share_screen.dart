// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/screens/share_screen/widgets/not_sharing_view.dart';
import 'package:windows_app/screens/share_screen/widgets/share_space_screen_appbar.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class ShareScreen extends StatefulWidget {
  static const String routeName = '/ShareScreen';
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  @override
  void initState() {
    downPF(context).loadTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShareSpaceScreenAppBar(),
          VSpace(),
          NotSharingView(),
          // ShareScreenNavBar(),
        ],
      ),
    );
  }
}

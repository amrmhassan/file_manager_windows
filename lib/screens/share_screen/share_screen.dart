// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/models/peer_model.dart';
import 'package:windows_app/providers/server_provider.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/screens/share_screen/widgets/not_sharing_view.dart';
import 'package:windows_app/screens/share_screen/widgets/share_screen_navbar.dart';
import 'package:windows_app/screens/share_screen/widgets/share_space_card.dart';
import 'package:windows_app/screens/share_screen/widgets/share_space_screen_appbar.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

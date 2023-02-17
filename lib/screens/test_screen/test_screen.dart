// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:dart_vlc/dart_vlc.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Player player = Player(id: 100);
  @override
  Widget build(BuildContext context) {
    var connectPhoneProvider = connectPP(context);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                're data is ${connectPhoneProvider.remoteIP}:${connectPhoneProvider.remotePort}'),
            Text(
                'my data is ${connectPhoneProvider.myIp}:${connectPhoneProvider.myPort}'),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:dart_vlc/dart_vlc.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/styles.dart';
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
  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        top: 0.0,
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          body: GestureDetector(
            onTap: () {
              _overlayEntry.remove();
            },
            child: Container(
              color: Colors.black,
              child: Center(
                child: Text(
                  'I am an overlay',
                  style: h4LightTextStyle,
                ),
              ),
            ),
          ),
        ),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(_overlayEntry);
    });
  }

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

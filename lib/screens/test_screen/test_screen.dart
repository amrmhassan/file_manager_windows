// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:dart_vlc/dart_vlc.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:flutter/material.dart';

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
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          Expanded(
            child: Video(
              player: player,
              showControls: true,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text('Play'),
              ),
              HSpace(),
              ElevatedButton(
                onPressed: () {
                  player.stop();
                },
                child: Text('Stop'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/global/custom_app_drawer/custom_app_drawer.dart';
import 'package:windows_app/global/widgets/advanced_video_player/advanced_video_player.dart';
import 'package:windows_app/global/widgets/advanced_video_player/widgets/custom_icon_button.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/global/widgets/media_controllers.dart';
import 'package:windows_app/global/widgets/quick_send_open_button.dart';
import 'package:windows_app/global/widgets/show_controllers_button.dart';
import 'package:windows_app/global/widgets/video_player_viewer/widgets/video_player_show_button.dart';
import 'package:windows_app/screens/home_screen/home_screen.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

import 'package:windows_app/screens/home_screen/widgets/app_bar_icon_button.dart';

class ScreensWrapper extends StatefulWidget {
  final Widget child;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  // final Widget? drawer;
  // final GlobalKey<ScaffoldState>? scfKey;

  //? drop your scaffold props here
  const ScreensWrapper({
    Key? key,
    required this.child,
    this.floatingActionButton,
    this.backgroundColor,
    this.floatingActionButtonLocation,
    // this.drawer,
    // this.scfKey,
  }) : super(key: key);

  @override
  State<ScreensWrapper> createState() => _ScreensWrapperState();
}

class _ScreensWrapperState extends State<ScreensWrapper> {
  GlobalKey<ScaffoldState> scfKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var mpProvider = mpP(context);
    return Scaffold(
      key: scfKey,
      drawer: CustomAppDrawer(),
      backgroundColor: widget.backgroundColor,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButton: widget.floatingActionButton,
      resizeToAvoidBottomInset: false,
      //! i make gesture detector to be inkwell to accept clicks even if the area is blank
      body: Column(
        children: [
          if (Platform.isWindows)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppBarIconButton(
                  onTap: () {
                    scfKey.currentState?.openDrawer();
                  },
                  iconName: 'list',
                ),
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.disappearing,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        appWindow.startDragging();
                      },
                      child: Container(
                        height: largeIconSize / 1.3,
                        decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.circular(1000),
                        ),
                      ),
                    ),
                  ),
                ),
                ButtonWrapper(
                  borderRadius: 0,
                  alignment: Alignment.center,
                  width: largeIconSize * 2,
                  height: largeIconSize / 1.3,
                  onTap: () {
                    appWindow.minimize();
                  },
                  child: Icon(
                    Icons.minimize,
                    color: Colors.white,
                  ),
                ),
                ButtonWrapper(
                  width: largeIconSize * 2,
                  height: largeIconSize / 1.3,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        largeBorderRadius,
                      ),
                    ),
                  ),
                  onTap: () {
                    appWindow.close();
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: smallIconSize,
                  ),
                ),
              ],
            ),
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SafeArea(
                top: !(mpProvider.videoPlayerController != null &&
                    (!mpProvider.videoHidden)),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: widget.child,
                                ),
                              ),
                              MediaControllers(),
                            ],
                          ),
                          Positioned(
                            bottom: -1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ShowControllersButton(),
                                HSpace(),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: -1,
                            child: Row(
                              children: [
                                HSpace(),
                                VideoPlayerShowButton(),
                              ],
                            ),
                          ),
                          // VideoPlayerViewer(),
                          if (mpProvider.videoPlayerController != null &&
                              (!mpProvider.videoHidden))
                            AdvancedVideoPlayer(),

                          QuickSendOpnButton()
                        ],
                      ),
                    ),
                    if (Platform.isWindows &&
                        (ModalRoute.of(context)?.settings.name?.toString() ??
                                '') !=
                            HomeScreen.routeName)
                      Container(
                        width: double.infinity,
                        height: largeIconSize * 1.5,
                        color: kCardBackgroundColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomIconButton(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              iconData: Icons.arrow_forward_ios,
                            ),
                            HSpace(factor: 2),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

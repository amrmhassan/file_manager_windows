// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/helpers/windows_info_helper.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/providers/util/analyzer_provider.dart';
import 'package:windows_app/providers/util/explorer_provider.dart';
import 'package:windows_app/providers/listy_provider.dart';
import 'package:windows_app/providers/media_player_provider.dart';
import 'package:windows_app/providers/recent_provider.dart';
import 'package:windows_app/screens/error_viewing_screen/error_viewing_screen.dart';
import 'package:windows_app/screens/explorer_screen/explorer_screen.dart';
import 'package:windows_app/screens/home_screen/utils/permissions.dart';
import 'package:windows_app/screens/recent_screen/recent_screen.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:windows_app/utils/screen_utils/home_screen_utils.dart';

import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/providers/children_info_provider.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/screens/home_screen/widgets/home_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:windows_app/utils/update_utils/run_updates.dart';

//* this is the home page controller
PageController pageController = PageController();

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  final bool fileViewer;

  const HomeScreen({
    super.key,
    this.fileViewer = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int exitCounter = 0;
  SendPort? globalSendPort;

  @override
  void initState() {
    pageController = PageController(
      initialPage:
          Provider.of<ExplorerProvider>(context, listen: false).activeViewIndex,
    );
    Future.delayed(Duration.zero).then((value) async {
      var recentProvider = Provider.of<RecentProvider>(context, listen: false);
      await Provider.of<ExplorerProvider>(context, listen: false)
          .loadSortOptions();
      await Provider.of<AnalyzerProvider>(context, listen: false)
          .loadInitialAppData(recentProvider);
      await Provider.of<ListyProvider>(context, listen: false).loadListyLists();
      //? to load the shared space items
      await Provider.of<ShareProvider>(context, listen: false)
          .loadSharedItems();
      //? to set the device id
      await Provider.of<ShareProvider>(context, listen: false)
          .loadDeviceIdAndName();
      //?
      await downPF(context).loadDownloadSettings();
      //?
      downPF(context).loadTasks();
      //?
      try {
        runUpdates(context);
      } catch (e) {
        logger.e(e);
      }

      //* getting storage permission
      bool res = await showPermissionsModal(
        context: context,
        callback: () => handlePermissionsGrantedCallback(context),
      );
      if (!res) {
        SystemNavigator.pop();
        return;
      }

      await Provider.of<ChildrenItemsProvider>(context, listen: false)
          .getAndUpdateAllSavedFolders();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    var homeScreenContent = ScreensWrapper(
      // scfKey: expScreenKey,
      // drawer: CustomAppDrawer(),
      backgroundColor: kBackgroundColor,
      child: Stack(
        children: [
          Column(
            children: [
              HomeAppBar(
                activeScreenIndex: expProvider.activeViewIndex,
                setActiveScreen: (index) => setActiveScreen(context, index),
                sizesExplorer: false,
              ),
              Expanded(
                child: PageView(
                  onPageChanged: (value) {
                    Provider.of<ExplorerProvider>(context, listen: false)
                        .setActivePageIndex(value);
                  },
                  controller: pageController,
                  physics: BouncingScrollPhysics(),
                  children: [
                    RecentScreen(),
                    ExplorerScreen(
                      sizesExplorer: false,
                      viewFile: widget.fileViewer,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // error red widget that opens the errors logging screen
          if (kDebugMode && !Platform.isWindows)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ErrorViewScreen.routeName);
              },
              child: Container(
                width: 20,
                height: 100,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
    return !mpProvider.videoHidden && mpProvider.videoPlayerController != null
        ? homeScreenContent
        : WillPopScope(
            onWillPop: () => handlePressPhoneBackButton(
              context: context,
              exitCounter: exitCounter,
              sizesExplorer: false,
              clearExitCounter: () {
                exitCounter = 0;
              },
              incrementExitCounter: () {
                exitCounter++;
              },
            ),
            child: homeScreenContent,
          );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/providers/util/analyzer_provider.dart';
import 'package:windows_app/providers/util/explorer_provider.dart';
import 'package:windows_app/screens/explorer_screen/explorer_screen.dart';
import 'package:windows_app/screens/home_screen/widgets/home_app_bar.dart';
import 'package:windows_app/utils/screen_utils/home_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SizesExpScreen extends StatefulWidget {
  static const String routeName = '/sizes-exp-screen';
  const SizesExpScreen({super.key});

  @override
  State<SizesExpScreen> createState() => _SizesExpScreenState();
}

class _SizesExpScreenState extends State<SizesExpScreen> {
  int exitCounter = 0;
  @override
  void initState() {
    Provider.of<ExplorerProvider>(context, listen: false).updateParentSize(
        Provider.of<AnalyzerProvider>(context, listen: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => handlePressPhoneBackButton(
        context: context,
        exitCounter: exitCounter,
        sizesExplorer: true,
        clearExitCounter: () {
          exitCounter = 0;
        },
        incrementExitCounter: () {
          exitCounter++;
        },
      ),
      child: ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Column(
          children: [
            HomeAppBar(
              activeScreenIndex: 1,
              setActiveScreen: (i) {},
              sizesExplorer: true,
            ),
            Expanded(
              child: ExplorerScreen(
                sizesExplorer: true,
                viewFile: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

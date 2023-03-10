// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/global/widgets/h_line.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/providers/util/analyzer_provider.dart';
import 'package:windows_app/screens/analyzer_screen/widgets/analyzing_report.dart';
import 'package:windows_app/screens/analyzer_screen/widgets/analyzing_starter.dart';
import 'package:windows_app/screens/home_screen/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyzerScreen extends StatefulWidget {
  static const String routeName = '/analyzer-screen';
  const AnalyzerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AnalyzerScreen> createState() => _AnalyzerScreenState();
}

class _AnalyzerScreenState extends State<AnalyzerScreen> {
  @override
  Widget build(BuildContext context) {
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          HomeAppBar(
            activeScreenIndex: 0,
            setActiveScreen: (a) {},
            sizesExplorer: true,
            title: 'Storage Analyzer',
          ),
          HLine(
            width: 1,
            color: kCardBackgroundColor,
          ),
          Container(
            color: kBackgroundColor,
            child: analyzerProvider.lastAnalyzingReportDate != null
                ? AnalyzingReport()
                : AnalyzingStarter(),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously

import 'dart:io';

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/global/widgets/h_line.dart';
import 'package:windows_app/global/widgets/shimmer_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/providers/util/analyzer_provider.dart';
import 'package:windows_app/screens/analyzer_screen/analyzer_screen.dart';
import 'package:windows_app/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:windows_app/screens/connect_phone_screen/connect_phone_screen.dart';
import 'package:windows_app/screens/items_viewer_screen/items_viewer_screen.dart';
import 'package:windows_app/screens/listy_screen/listy_screen.dart';
import 'package:windows_app/screens/qr_code_viewer_screen/qr_code_viewer_screen.dart';
import 'package:windows_app/screens/recent_items_viewer_screen/recent_items_viewer_screen.dart';
import 'package:windows_app/screens/recent_screen/widget/storage_segments.dart';
import 'package:windows_app/screens/storage_cleaner_screen/storage_cleaner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';

class RecentScreen extends StatefulWidget {
  const RecentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  //? open recent screen
  void openRecentScreen(RecentType recentType) {
    Navigator.pushNamed(
      context,
      RecentsViewerScreen.routeName,
      arguments: recentType,
    );
  }

  @override
  Widget build(BuildContext context) {
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              VSpace(factor: .5),
              HLine(
                thickness: 1,
                color: kInactiveColor.withOpacity(.2),
              ),
              VSpace(),
              AnalyzerOptionsItem(
                logoName: 'management',
                onTap: () async {
                  try {
                    if (connectPPF(context).remoteIP == null) {
                      await connectPPF(context).openServer();
                      Navigator.pushNamed(
                        context,
                        QrCodeViewerScreen.routeName,
                        arguments: true,
                      );
                    } else {
                      Navigator.pushNamed(
                          context, ConnectPhoneScreen.routeName);
                    }
                  } catch (e) {
                    showSnackBar(
                      context: context,
                      message: e.toString(),
                      snackBarType: SnackBarType.error,
                    );
                  }
                },
                title: 'Connect Phone',
                color: Colors.white,
              ),
              VSpace(),
              AnalyzerOptionsItem(
                logoName: 'clock',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ItemsViewerScreen.routeName,
                    arguments: ItemsType.recentOpenedFiles,
                  );
                },
                title: 'Recently Opened',
                color: kMainIconColor,
              ),
              VSpace(),

              // //# windows
              // if (!Platform.isWindows)
              //   AnalyzerOptionsItem(
              //     logoName: 'analyzer',
              //     onTap: () {
              //       Navigator.pushNamed(context, AnalyzerScreen.routeName);
              //     },
              //     title: 'Storage Analyzer',
              //   ),
              // //# windows
              // if (!Platform.isWindows) VSpace(),
              // //# windows
              // if (!Platform.isWindows)
              //   AnalyzerOptionsItem(
              //     logoName: 'cleaner',
              //     onTap: () {
              //       Navigator.pushNamed(
              //           context, StorageCleanerScreen.routeName);
              //     },
              //     title: 'Storage Cleaner',
              //   ),
              // //# windows
              // if (!Platform.isWindows) VSpace(),
              AnalyzerOptionsItem(
                logoName: 'list1',
                onTap: () {
                  Navigator.pushNamed(context, ListyScreen.routeName);
                },
                title: 'Listy',
              ),
              VSpace(),
            ],
          ),
        ),
        //# windows
        if (!Platform.isWindows)
          (analyzerProvider.allExtensionInfo == null ||
                  (analyzerProvider.allExtensionInfo ?? []).isEmpty
              ? ShimmerWrapper(
                  baseColor: Colors.white,
                  lightColor: Color.fromARGB(255, 172, 172, 172),
                  child: StorageSegments(),
                )
              : StorageSegments()),
      ],
    );
  }
}

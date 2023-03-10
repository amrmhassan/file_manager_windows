// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/modals/show_modal_funcs.dart';
import 'package:windows_app/providers/util/analyzer_provider.dart';
import 'package:windows_app/providers/util/explorer_provider.dart';
import 'package:windows_app/providers/files_operations_provider.dart';
import 'package:windows_app/screens/home_screen/widgets/app_bar_icon_button.dart';
import 'package:windows_app/screens/home_screen/widgets/explorer_mode_switcher.dart';
import 'package:windows_app/screens/home_screen/widgets/rescan_button.dart';
import 'package:windows_app/screens/home_screen/widgets/selected_item_number.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget {
  final int activeScreenIndex;
  final Function(int index) setActiveScreen;
  final bool sizesExplorer;
  final String? title;

  const HomeAppBar({
    super.key,
    required this.activeScreenIndex,
    required this.setActiveScreen,
    required this.sizesExplorer,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);
    var expProvider = Provider.of<ExplorerProvider>(context);
    var foProvider = Provider.of<FilesOperationsProvider>(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            // if (activeScreenIndex == 1)

            //! this will hold the progress of the loading operation if i figure a way to do so
            if (foProvider.loadingOperation)
              SizedBox(
                width: smallIconSize,
                height: smallIconSize,
                child: CircularProgressIndicator(
                  color: kBlueColor,
                  strokeWidth: 2,
                ),
              )
            else if (foProvider.selectedItems.isNotEmpty)
              SelectedItemNumber(),
            Spacer(),
            if (expProvider.loadingChildren ||
                analyzerProvider.savingInfoToSqlite)
              SizedBox(
                width: smallIconSize,
                height: smallIconSize,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            activeScreenIndex == 1
                ? AppBarIconButton(
                    onTap: () {
                      showCurrentActiveDirOptions(context);
                    },
                    iconName: 'dots',
                    color: kMainIconColor,
                  )
                : RescanButton(),
          ],
        ),
        !sizesExplorer
            ? ExplorerModeSwitcher(
                activeScreenIndex: activeScreenIndex,
                setActiveScreen: setActiveScreen,
              )
            : Text(
                title ?? 'Sizes Explorer',
                style: h2TextStyle.copyWith(color: kActiveTextColor),
              ),
      ],
    );
  }
}

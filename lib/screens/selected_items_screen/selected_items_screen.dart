// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/providers/files_operations_provider.dart';
import 'package:windows_app/screens/explorer_screen/widgets/storage_item.dart';
import 'package:windows_app/screens/home_screen/widgets/selected_item_number.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectedItemsScreen extends StatelessWidget {
  static const String routeName = '/SelectedItemsScreen';
  const SelectedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var foProvider = Provider.of<FilesOperationsProvider>(context);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Selected Items',
              style: h2TextStyle,
            ),
            rightIcon: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SelectedItemNumber(tap: false)],
                ),
                HSpace(),
              ],
            ),
          ),
          VSpace(),
          ...foProvider.selectedItems.map(
            (e) => Dismissible(
              onDismissed: (direction) {
                foPF(context).toggleFromSelectedItems(e, expPF(context));
                if (foPF(context).selectedItems.isEmpty) {
                  Navigator.pop(context);
                }
              },
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(
                  right: kHPad,
                ),
                color: kDangerColor,
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
              ),
              key: Key(e.path),
              child: StorageItem(
                storageItemModel: e,
                onDirTapped: (dir) {},
                allowSelect: false,
                allowShowingFavIcon: false,
                sizesExplorer: false,
                parentSize: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/providers/files_operations_provider.dart';
import 'package:windows_app/screens/explorer_screen/widgets/entity_operations/entity_operations.dart';
import 'package:windows_app/screens/explorer_screen/widgets/storage_item.dart';
import 'package:windows_app/utils/screen_utils/items_viewer_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

enum ItemsType {
  bigFiles,
  inactiveFiles,
  oldFiles,
  recentOpenedFiles,
}

class ItemsViewerScreen extends StatefulWidget {
  static const String routeName = '/CleanerItemsScreen';
  const ItemsViewerScreen({super.key});

  @override
  State<ItemsViewerScreen> createState() => _ItemsViewerScreenState();
}

class _ItemsViewerScreenState extends State<ItemsViewerScreen> {
  bool loading = false;
  List<LocalFileInfo> allFilesInfo = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      ItemsType itemsType =
          ModalRoute.of(context)!.settings.arguments as ItemsType;
      var data = await fetchData(itemsType, context);
      setState(() {
        allFilesInfo = data;
        loading = false;
      });
    });

    super.initState();
  }

  String get title {
    ItemsType itemsType =
        ModalRoute.of(context)!.settings.arguments as ItemsType;
    switch (itemsType) {
      case ItemsType.bigFiles:
        return 'Big Files';
      case ItemsType.inactiveFiles:
        return 'Inactive Files';
      case ItemsType.oldFiles:
        return 'Old Files';
      case ItemsType.recentOpenedFiles:
        return 'Recent Opened Files';
    }
  }

  @override
  Widget build(BuildContext context) {
    var foProvider = Provider.of<FilesOperationsProvider>(context);

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              title,
              style: h2TextStyle,
            ),
          ),
          Expanded(
            child: allFilesInfo.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Files Yet",
                        style: h4TextStyleInactive,
                      ),
                    ],
                  )
                : ListView(
                    physics: BouncingScrollPhysics(),
                    children: allFilesInfo.map((e) {
                      return ButtonWrapper(
                        borderRadius: 0,
                        onTap: () async {
                          await OpenFile.open(e.path);
                        },
                        child: StorageItem(
                          onDirTapped: ((path) {}),
                          storageItemModel: e.toStorageItemModel(),
                          sizesExplorer: false,
                          parentSize: 0,
                        ),
                      );
                    }).toList(),
                  ),
          ),
          if (!foProvider.loadingOperation) EntityOperations(),
        ],
      ),
    );
  }
}

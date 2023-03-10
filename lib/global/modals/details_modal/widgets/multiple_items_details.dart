// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/modals/widgets/detail_item.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/models/storage_item_model.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/utils/files_operations_utils/folder_utils.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MultipleItemsDetails extends StatefulWidget {
  final List<StorageItemModel> selectedItems;
  const MultipleItemsDetails({
    Key? key,
    required this.selectedItems,
  }) : super(key: key);

  @override
  State<MultipleItemsDetails> createState() => _MultipleItemsDetailsState();
}

class _MultipleItemsDetailsState extends State<MultipleItemsDetails> {
  int size = 0;
  int filesCount = 0;
  int foldersCount = 0;
  bool loading = true;

//? to get multiple items info
  void getMultipleItemsDetails() {
    for (var item in widget.selectedItems) {
      if (item.entityType == EntityType.file) {
        setState(() {
          size += item.size ?? 0;
          filesCount++;
        });
      } else {
        foldersCount++;
        getFolderDetails(
          storageItemModel: item,
          callAfterAvailable: (fdm, oldSize) {
            if (mounted) {
              setState(() {
                size = size + (fdm.size ?? 0) - (oldSize ?? 0);
                foldersCount += fdm.folderCount ?? 0;
                filesCount += fdm.filesCount ?? 0;
              });
            }
          },
          onDone: () {
            setState(() {
              loading = false;
            });
          },
        );
      }
    }
  }

  @override
  void initState() {
    getMultipleItemsDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.selectedItems.length} Items',
                  style: h4TextStyle.copyWith(color: Colors.white),
                ),
              ],
            ),
            if (loading)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: smallIconSize,
                    height: smallIconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ],
              )
          ],
        ),
        VSpace(),
        DetailItem(
          title: 'Files: ',
          value: filesCount.toString(),
          valueColor: kInActiveTextColor,
        ),
        DetailItem(
          title: 'Folders: ',
          value: NumberFormat('#,###.##').format(foldersCount),
          valueColor: kInActiveTextColor,
        ),
        DetailItem(
          title: 'Size: ',
          value: handleConvertSize(size),
          valueColor: kInActiveTextColor,
        ),
      ],
    );
  }
}

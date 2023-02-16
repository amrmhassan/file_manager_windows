// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/models/storage_item_model.dart';
import 'package:windows_app/providers/util/explorer_provider.dart';
import 'package:windows_app/providers/files_operations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntityCheckBox extends StatelessWidget {
  const EntityCheckBox({
    Key? key,
    required this.storageItemModel,
    required this.isSelected,
  }) : super(key: key);

  final StorageItemModel storageItemModel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      borderRadius: 600,
      backgroundColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splash: false,
      focusedColor: Colors.transparent,
      onTap: () {
        var expProvider = Provider.of<ExplorerProvider>(context, listen: false);
        Provider.of<FilesOperationsProvider>(context, listen: false)
            .toggleFromSelectedItems(storageItemModel, expProvider);
      },
      child: Container(
        padding: EdgeInsets.all(largePadding),
        child: Container(
          padding: EdgeInsets.all(mediumPadding),
          width: largeIconSize / 2,
          height: largeIconSize / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500),
            color: isSelected ? kBlueColor : Colors.transparent,
            border: Border.all(
              color: isSelected ? kBlueColor : kInactiveColor,
              width: 1,
            ),
          ),
          child: isSelected
              ? Image.asset(
                  'assets/icons/check.png',
                  color: Colors.white,
                )
              : SizedBox(),
        ),
      ),
    );
  }
}

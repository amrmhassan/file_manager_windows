// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/modals/widgets/add_to_share_space_button.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/models/share_space_item_model.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/screens/explorer_screen/widgets/storage_item.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySharedItems extends StatelessWidget {
  const MySharedItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shareProvider = Provider.of<ShareProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddingWrapper(
          child: Text(
            'Shared Items',
            style: h4TextStyleInactive,
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: shareProvider.sharedItems.length,
            itemBuilder: (context, index) {
              ShareSpaceItemModel shareSpaceItemModel =
                  shareProvider.sharedItems[index];

              return Dismissible(
                onDismissed: (direction) async {
                  await handleAddOrRemoveFromShareSpace(
                      context, true, [shareSpaceItemModel.path]);
                  showSnackBar(
                    context: context,
                    message: 'Removed From Share Space',
                  );
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
                key: UniqueKey(),
                child: StorageItem(
                  allowSelect: false,
                  shareSpaceItemModel: shareSpaceItemModel,
                  onDirTapped: (e) {},
                  sizesExplorer: false,
                  parentSize: 0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:windows_app/models/share_space_item_model.dart';
import 'package:windows_app/models/storage_item_model.dart';
import 'package:windows_app/utils/client_utils.dart' as client_utils;
import 'package:windows_app/providers/files_operations_provider.dart';
import 'package:windows_app/providers/server_provider.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/providers/util/explorer_provider.dart';
import 'package:windows_app/screens/home_screen/widgets/modal_button_element.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> handleAddOrRemoveFromShareSpace(
  BuildContext context,
  bool? added, [
  List<String>? paths,
]) async {
  var foProviderFalse = foPF(context);
  if (added == true) {
    //? remove from share space
    var shareProviderFalse = Provider.of<ShareProvider>(context, listen: false);
    var serverProviderFalse =
        Provider.of<ServerProvider>(context, listen: false);
    await shareProviderFalse.removeMultipleItemsFromShareSpace(
        paths ?? foProviderFalse.selectedItems.map((e) => e.path));

    //? broad cast files removal from share space
    //? i removed await to prevent the user waiting for the other device to respond
    client_utils.broadCastFileRemovalFromShareSpace(
      serverProvider: serverProviderFalse,
      shareProvider: shareProviderFalse,
      paths: foProviderFalse.selectedItems.map((e) => e.path).toList(),
    );
  } else if (added == false) {
    //? add to share space
    var shareProviderFalse = Provider.of<ShareProvider>(context, listen: false);
    var serverProviderFalse =
        Provider.of<ServerProvider>(context, listen: false);
    List<ShareSpaceItemModel> addedItems = await shareProviderFalse
        .addMultipleFilesToShareSpace(foProviderFalse.selectedItems);

    //? broad cast files addition from share space
    //? i removed await to prevent the user waiting for the other device to respond
    client_utils.broadCastFileAddedToShareSpace(
      serverProvider: serverProviderFalse,
      shareProvider: shareProviderFalse,
      addedItems: addedItems,
    );
  }
  //? if paths==null that means that you are doing that from controlling share space screen
  if (paths == null) {
    foProviderFalse.clearAllSelectedItems(
        Provider.of<ExplorerProvider>(context, listen: false));
  }
}

class AddToShareSpaceButton extends StatefulWidget {
  const AddToShareSpaceButton({
    Key? key,
  }) : super(key: key);

  @override
  State<AddToShareSpaceButton> createState() => _AddToShareSpaceButtonState();
}

class _AddToShareSpaceButtonState extends State<AddToShareSpaceButton> {
  bool? added;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      List<StorageItemModel> selectedItems =
          Provider.of<FilesOperationsProvider>(context, listen: false)
              .selectedItems;
      bool res = Provider.of<ShareProvider>(context, listen: false)
          .areAllItemsAtShareSpace(selectedItems);
      setState(() {
        added = res;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalButtonElement(
      inactiveColor: Colors.transparent,
      title: added == null
          ? '...'
          : added == true
              ? 'Remove From Share Space'
              : 'Add To Share Space',
      onTap: () async {
        handleAddOrRemoveFromShareSpace(context, added);
        Navigator.pop(context);
      },
    );
  }
}

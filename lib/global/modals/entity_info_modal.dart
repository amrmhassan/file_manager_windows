// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:windows_app/analyzing_code/globals/files_folders_operations.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/constants/widget_keys.dart';
import 'package:windows_app/global/modals/show_modal_funcs.dart';
import 'package:windows_app/global/widgets/custom_text_field.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/providers/util/explorer_provider.dart';
import 'package:windows_app/providers/files_operations_provider.dart';
import 'package:windows_app/providers/listy_provider.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntityInfoEditingModal extends StatefulWidget {
  final String? oldName;
  final bool createListy;

  const EntityInfoEditingModal({
    Key? key,
    this.oldName,
    this.createListy = false,
  }) : super(key: key);

  @override
  State<EntityInfoEditingModal> createState() => _EntityInfoEditingModalState();
}

class _EntityInfoEditingModalState extends State<EntityInfoEditingModal> {
  TextEditingController nameController = TextEditingController();
  bool rename = false;
  String? orgFileExt;
  String? orgFileName;

//? handle apply modal
  Future<void> handleApplyModal(BuildContext context) async {
    if (nameController.text.isEmpty) return;
    if (widget.createListy) return createList();
    try {
      if (rename) {
        if (orgFileName == nameController.text) {
          showSnackBar(context: context, message: 'The name didn\'t change.');
        } else {
          EntityType entityType =
              Provider.of<FilesOperationsProvider>(context, listen: false)
                  .selectedItems
                  .first
                  .entityType;
          printOnDebug(entityType);
          if (entityType == EntityType.folder) {
            handleRenameFolder();
          } else if (entityType == EntityType.file) {
            await handleRenameFile(context);
          }
        }
      } else {
        handleCreateNewFolder();
      }
    } catch (e) {
      showSnackBar(
          context: context,
          message: 'Error Occurred',
          snackBarType: SnackBarType.error);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  //? create new listy
  Future createList() async {
    try {
      await Provider.of<ListyProvider>(context, listen: false)
          .addListy(title: nameController.text);
    } catch (e) {
      showSnackBar(
        context: context,
        message: e.toString(),
        snackBarType: SnackBarType.error,
      );
    }
    Navigator.pop(context);
  }

  //? create new folder
  void handleCreateNewFolder() {
    if (nameController.text.trim().isEmpty) return;
    var expProvider = Provider.of<ExplorerProvider>(context, listen: false);
    try {
      Provider.of<FilesOperationsProvider>(context, listen: false)
          .createFolder(nameController.text.trim(), expProvider);
      nameController.text = '';
    } catch (E) {
      showSnackBar(
        context: context,
        message: 'This Folder Already Exists',
        snackBarType: SnackBarType.error,
      );
    }
  }

  //? rename file
  Future<void> handleRenameFile(
    BuildContext context, [
    bool checkExt = true,
  ]) async {
    if (nameController.text.isEmpty) return;
    String newExt = '.${getFileExtension(nameController.text)}';

    if (orgFileExt != newExt && checkExt) {
      Navigator.pop(context);
      await showFileExtChangeModal(context, handleRenameFile);
    } else {
      var foProvider = Provider.of<FilesOperationsProvider>(
          expScreenKey.currentContext!,
          listen: false);
      var expProvider = Provider.of<ExplorerProvider>(
          expScreenKey.currentContext!,
          listen: false);
      String filePath = foProvider.selectedItems.first.path;
      try {
        foProvider.performRenameFile(
          newFileName: nameController.text,
          filePath: filePath,
          explorerProvider: expProvider,
        );
      } catch (e) {
        showSnackBar(
          context: context,
          message: 'Error with renaming file',
          snackBarType: SnackBarType.error,
        );
      }
    }
  }

  //? rename folder
  void handleRenameFolder() {
    if (nameController.text.isEmpty) return;
    var foProvider =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    var expProvider = Provider.of<ExplorerProvider>(context, listen: false);
    String folderPath = foProvider.selectedItems.first.path;
    foProvider.performRenameFolder(
      newFolderName: nameController.text,
      folderPath: folderPath,
      explorerProvider: expProvider,
    );
  }

  @override
  void initState() {
    nameController.text =
        widget.oldName ?? (widget.createListy ? 'New List' : 'New Folder');
    if (widget.oldName != null) {
      rename = true;
      String ext = '.${getFileExtension(widget.oldName!)}';
      orgFileExt = ext;
      orgFileName = widget.oldName;
      int extStart = widget.oldName!.indexOf(ext);
      extStart = extStart == -1 ? nameController.text.length : extStart;
      nameController.selection =
          TextSelection(baseOffset: 0, extentOffset: extStart);
    } else {
      nameController.selection = TextSelection(
          baseOffset: 0, extentOffset: nameController.text.length);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
      afterLinePaddingFactor: 0,
      bottomPaddingFactor: 0,
      padding: EdgeInsets.zero,
      color: kCardBackgroundColor,
      showTopLine: false,
      borderRadius: mediumBorderRadius,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VSpace(),
          CustomTextField(
            title: 'Enter Folder Name',
            controller: nameController,
            autoFocus: true,
            color: kInactiveColor,
            textStyle: h4TextStyleInactive.copyWith(
              color: kActiveTextColor,
            ),
          ),
          PaddingWrapper(
            child: Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {
                    nameController.text = '';

                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: h4TextStyleInactive,
                  ),
                ),
                HSpace(),
                TextButton(
                  onPressed: () => handleApplyModal(context),
                  child: Text(
                    rename ? 'Rename' : 'Create',
                    style: h4TextStyle,
                  ),
                ),
              ],
            ),
          ),
          VSpace(),
        ],
      ),
    );
  }
}

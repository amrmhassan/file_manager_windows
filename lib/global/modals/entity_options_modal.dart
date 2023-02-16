// ignore_for_file: prefer_const_constructors

import 'package:windows_app/global/modals/show_modal_funcs.dart';
import 'package:windows_app/global/modals/widgets/add_to_favorite_button.dart';
import 'package:windows_app/global/modals/widgets/add_to_other_listy_button.dart';
import 'package:windows_app/global/modals/widgets/add_to_share_space_button.dart';
import 'package:windows_app/global/modals/widgets/hide_from_share_space_button.dart';
import 'package:windows_app/global/modals/widgets/open_in_new_tab_button.dart';
import 'package:flutter/material.dart';

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/providers/files_operations_provider.dart';
import 'package:windows_app/screens/home_screen/widgets/modal_button_element.dart';
import 'package:provider/provider.dart';

class EntityOptionsModal extends StatelessWidget {
  const EntityOptionsModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var foProviderFalse =
        Provider.of<FilesOperationsProvider>(context, listen: false);
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
          AddToShareSpaceButton(),
          HideFromShareSpaceButton(),
          OpenInNewTabButton(),
          AddToFavoriteButton(foProviderFalse: foProviderFalse),
          AddToOtherListyButton(foProviderFalse: foProviderFalse),
          ModalButtonElement(
            inactiveColor: Colors.transparent,
            opacity: foProviderFalse.selectedItems.length == 1 ? 1 : .5,
            active: foProviderFalse.selectedItems.length == 1,
            title: 'Rename',
            onTap: () async {
              Navigator.pop(context);
              await showRenameModal(context);
            },
          ),
          ModalButtonElement(
            title: 'Details',
            onTap: () async {
              Navigator.pop(context);
              await showDetailsModal(
                context,
              );
            },
          ),
          VSpace(),
        ],
      ),
    );
  }
}

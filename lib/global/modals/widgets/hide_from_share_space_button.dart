// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:windows_app/screens/home_screen/widgets/modal_button_element.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class HideFromShareSpaceButton extends StatelessWidget {
  const HideFromShareSpaceButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shareProvider = shareP(context);
    var foProvider = foP(context);

    bool shown = shareProvider.showHideFromShareSpaceButton(
        foProvider.selectedItems.map((e) => e.path));
    bool hidden = shareProvider
        .isHiddenFromShareSpace(foProvider.selectedItems.map((e) => e.path));

    return shown
        ? ModalButtonElement(
            inactiveColor: Colors.transparent,
            title: hidden ? 'Un hide from share' : 'Hide from share explorer',
            onTap: () async {
              var selected = [...foPF(context).selectedItems];
              if (hidden) {
                // mass hide from share space
                sharePF(context)
                    .removeFromHiddenEntities(selected.map((e) => e.path));
              } else {
                // mass un hide from share space
                sharePF(context)
                    .addToHiddenEntities(selected.map((e) => e.path));
              }
              Navigator.pop(context);
              foPF(context).clearAllSelectedItems(expPF(context));
            },
          )
        : SizedBox();
  }
}

// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/modals/double_buttons_modal.dart';
import 'package:windows_app/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/models/white_block_list_model.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class WhiteBlockListScreen extends StatelessWidget {
  static const String routeName = '/WhiteBlockListScreen';
  const WhiteBlockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool allowed = ModalRoute.of(context)!.settings.arguments as bool;
    var serverProvider = serverP(context);
    List<WhiteBlockListModel> viewedDevices =
        allowed ? serverProvider.allowedPeers : serverProvider.blockedPeers;

    return ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Column(
          children: [
            CustomAppBar(
              title: Text(
                allowed ? 'White List' : 'Block List',
                style: h2TextStyle,
              ),
            ),
            VSpace(),
            viewedDevices.isEmpty
                ? Expanded(
                    child: Center(
                    child: Text(
                      'No Devices',
                      style: h4TextStyle,
                    ),
                  ))
                : Expanded(
                    child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: viewedDevices.length,
                    itemBuilder: (context, index) => Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        bool? res = await showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => DoubleButtonsModal(
                            autoPop: false,
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            onOk: () {
                              Navigator.pop(context, true);
                            },
                            title:
                                'Delete from ${allowed ? 'allowed' : 'blocked'} list',
                          ),
                        );
                        if (res == true) {
                          // here just delete
                          if (allowed) {
                            serverPF(context).removeFromAllowedDevices(
                                viewedDevices[index].deviceID);
                          } else {
                            serverPF(context).removeFromBlockedDevices(
                                viewedDevices[index].deviceID);
                          }
                        }
                        return res == true;
                      },
                      background: Container(
                        padding: EdgeInsets.only(right: kHPad),
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          viewedDevices[index].name,
                          style: h4TextStyle,
                        ),
                      ),
                    ),
                  ))
          ],
        ));
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/models/peer_permissions_model.dart';
import 'package:windows_app/screens/single_user_permissions_screen/widgets/permission_status_button.dart';
import 'package:flutter/material.dart';

class UserPermissionRow extends StatelessWidget {
  final PeerPermissionsModel peerPermissionModel;
  final PermissionModel permissionModel;

  const UserPermissionRow({
    super.key,
    required this.peerPermissionModel,
    required this.permissionModel,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      borderRadius: 0,
      padding: EdgeInsets.symmetric(
        horizontal: kHPad * .8,
        vertical: kVPad / 4,
      ),
      child: Row(
        children: [
          Text(
            PermissionsNamesUtils.getPermissionTitleMin(
                permissionModel.permissionName),
          ),
          Spacer(),
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                mediumBorderRadius,
              ),
              border: Border.all(
                width: 1,
                color: kLightCardBackgroundColor,
              ),
            ),
            child: Row(
              children: PermissionStatus.values
                  .map(
                    (permissionStatus) => PermissionStatusButton(
                      peerPermissionModel: peerPermissionModel,
                      permissionModel: permissionModel,
                      permissionStatus: permissionStatus,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

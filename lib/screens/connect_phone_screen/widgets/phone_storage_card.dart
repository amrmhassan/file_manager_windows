// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/server_constants.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/utils/connect_to_phone_utils/connect_to_phone_utils.dart';
import 'package:windows_app/utils/general_utils.dart';

class PhoneStorageCard extends StatefulWidget {
  const PhoneStorageCard({
    super.key,
  });

  @override
  State<PhoneStorageCard> createState() => _PhoneStorageCardState();
}

class _PhoneStorageCardState extends State<PhoneStorageCard> {
  int? freeSpace;
  int? totalSpace;
  bool error = false;
  void handleGetPhoneStorageInfo() async {
    try {
      //
      var res = await getPhoneStorageInfo(context);

      if (!mounted) return;
      setState(() {
        freeSpace = res[freeSpaceHeaderKey];
        totalSpace = res[totalSpaceHeaderKey];
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = true;
      });
    }
  }

  @override
  void initState() {
    handleGetPhoneStorageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      backgroundColor: kCardBackgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: kHPad / 2,
        vertical: kVPad / 2,
      ),
      child: Row(children: [
        Text(
          'Storage',
          style: h4TextStyle,
        ),
        Spacer(),
        error
            ? Text(
                'Error',
                style: h4TextStyleInactive.copyWith(
                  color: kDangerColor,
                ),
              )
            : freeSpace == null
                ? SizedBox(
                    width: smallIconSize,
                    height: smallIconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: kMainIconColor,
                    ),
                  )
                : Text(
                    '${handleConvertSize(freeSpace!)} free of ${handleConvertSize(totalSpace!)}',
                    style: h4TextStyleInactive,
                  ),
      ]),
    );
  }
}

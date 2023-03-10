// ignore_for_file: prefer_const_constructors

import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/screens/share_screen/widgets/empty_share_items.dart';
import 'package:windows_app/screens/share_screen/widgets/my_shared_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? this will appear when the device isn't connected to any groups, to show my share space
class NotSharingView extends StatelessWidget {
  const NotSharingView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shareProvider = Provider.of<ShareProvider>(context);
    return Expanded(
      child: Stack(
        children: [
          if (shareProvider.sharedItems.isNotEmpty)
            MySharedItems()
          else
            EmptyShareItems(),
        ],
      ),
    );
  }
}

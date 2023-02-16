// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/screens/download_manager_screen/widgets/download_card.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var downloadProvider = downP(context);
    var doneTasks = downloadProvider.doneTasks;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // ElevatedButton(
          //     onPressed: () {
          //       downPF(context).clearAllTasks();
          //     },
          //     child: Text('Clear All')),

          VSpace(),
          Expanded(
            child: doneTasks.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/accept.png',
                          width: largeIconSize,
                          color: kMainIconColor.withOpacity(.5),
                        ),
                        VSpace(factor: .5),
                        Text(
                          'No Finished Downloads',
                          style: h3InactiveTextStyle,
                        ),
                      ],
                    ),
                  )
                : PaddingWrapper(
                    padding: EdgeInsets.symmetric(horizontal: kHPad / 2),
                    child: ListView.builder(
                      itemCount: doneTasks.length,
                      itemBuilder: (context, index) => DownloadCard(
                        downloadTaskModel: doneTasks[index],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

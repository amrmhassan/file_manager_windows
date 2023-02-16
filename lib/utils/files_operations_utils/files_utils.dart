import 'dart:io';

import 'package:windows_app/models/types.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

void openFile(String path, BuildContext context) async {
  File file = File(path);
  if (!file.existsSync()) {
    showSnackBar(
      context: context,
      message: 'File doesn\'t exist',
      snackBarType: SnackBarType.error,
    );
    return;
  }
  //* here perform open the file
  await foPF(context).addToRecentlyOpened(path);
  await OpenFile.open(path);
}

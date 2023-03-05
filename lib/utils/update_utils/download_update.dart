import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:windows_app/utils/download_utils/custom_dio.dart';

class DownloadUpdate {
  Future<String> downloadUpdate(String link, String version) async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    var downloadDir = '${(await getTemporaryDirectory()).path}/afm_update';
    if (!Directory(downloadDir).existsSync()) {
      Directory(downloadDir).createSync();
    } else {
      Directory(downloadDir).deleteSync();
      Directory(downloadDir).createSync();
    }
    String fileName = '$version.exe';
    String filePath = '$downloadDir/$fileName';
    await CustomDio().download(
      link,
      filePath,
      deleteIfExist: true,
    );
    return filePath;
  }
}

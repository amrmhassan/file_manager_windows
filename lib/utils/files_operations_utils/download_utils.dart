import 'dart:io';

import 'package:windows_app/constants/files_types_icons.dart';
import 'package:windows_app/constants/global_constants.dart';

//? when downloading a file this function will return the download folder path
Future<String> getSaveFilePath(FileType fileType, String fileName) async {
  late String downloadFolder;
  switch (fileType) {
    case FileType.apk:
      downloadFolder = await _folderPathCheck(apkDownloadFolder);
      break;
    case FileType.archive:
      downloadFolder = await _folderPathCheck(archiveDownloadFolder);
      break;
    case FileType.audio:
      downloadFolder = await _folderPathCheck(audioDownloadFolder);
      break;
    case FileType.docs:
      downloadFolder = await _folderPathCheck(docDownloadFolder);
      break;
    case FileType.image:
      downloadFolder = await _folderPathCheck(imageDownloadFolder);
      break;
    case FileType.video:
      downloadFolder = await _folderPathCheck(videoDownloadFolder);
      break;
    case FileType.excel:
      downloadFolder = await _folderPathCheck(docDownloadFolder);
      break;
    case FileType.word:
      downloadFolder = await _folderPathCheck(docDownloadFolder);
      break;
    case FileType.powerPoint:
      downloadFolder = await _folderPathCheck(docDownloadFolder);
      break;
    case FileType.text:
      downloadFolder = await _folderPathCheck(docDownloadFolder);
      break;
    case FileType.batch:
      downloadFolder = await _folderPathCheck(docDownloadFolder);
      break;
    default:
      downloadFolder = await _folderPathCheck(otherDownloadFolder);
      break;
  }
  return '$downloadFolder/$fileName'.replaceAll('//', '/');
}

//? for checking each sub download folder
Future<String> _folderPathCheck(String folderName) async {
  String mainDownloadPath = await _checkMainDownloadFolder();
  Directory directory = Directory('$mainDownloadPath/$folderName');
  if (!directory.existsSync()) {
    directory.createSync();
  }
  return directory.path;
}

//? for checking the main download folder
Future<String> _checkMainDownloadFolder() async {
  String mainPath = 'sdcard/$mainDownloadFolder';
  Directory mainDir = Directory(mainPath);
  if (!mainDir.existsSync()) {
    mainDir.createSync();
  }
  return mainPath;
}

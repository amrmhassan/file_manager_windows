import 'dart:isolate';

import 'package:windows_app/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:windows_app/analyzing_code/storage_analyzer/helpers/storage_analyzer_v4.dart';
import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/utils/general_utils.dart';

String parentPath = initialDirs.skip(1).first.path;

//? to start analyzing the storage
void runAnalyzeStorageIsolate(SendPort sendPort) {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  var obj = AdvancedStorageAnalyzer(parentPath);
  DateTime beforeScanning = DateTime.now();
  obj.startAnalyzing(
    onAllDone: () {
      DateTime afterScanning = DateTime.now();
      sendPort.send(afterScanning.difference(beforeScanning).inMilliseconds);
      sendPort.send(obj);
      int parseTime = getExecutionTime(() {
        StorageAnalyzerV4 storageAnalyzerV4 = StorageAnalyzerV4(
          allFilesInfo: obj.filesInfo,
          allFoldersInfo: obj.foldersInfo,
          children: obj.allEntitiesPaths,
          parentPath: parentPath,
        );
        storageAnalyzerV4.run();

        sendPort.send(storageAnalyzerV4);
      });
      sendPort.send(parseTime);
    },
    onFolderDone: ((localFolderInfo) {
      sendPort.send(localFolderInfo);
    }),
    onError: (e, dir) {
      sendPort.send(e);
    },
  );
}

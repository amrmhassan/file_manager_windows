import 'dart:io';

import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/utils/errors_collection/custom_exception.dart';
import 'package:windows_app/utils/send_files_utils/send_file_utils.dart';
import 'package:windows_app/utils/server_utils/connection_utils.dart';
import 'package:windows_app/utils/server_utils/ip_utils.dart';
import 'package:flutter/material.dart';

class QuickSendProvider extends ChangeNotifier {
  String? myIp;
  int port = 0;
  String? fileConnLink;
  HttpServer? httpServer;

  Future<void> quickShareFile(String filePath, bool wifi) async {
    if (httpServer != null) {
      await closeSend();
    }
    try {
      myIp = await getMyIpAddress(wifi);
      if (myIp == null) {
        throw CustomException(
          e: wifi ? 'Not Connected' : 'Open Your HotSpot please',
          s: StackTrace.current,
          rethrowError: true,
        );
      }
      httpServer = await HttpServer.bind(InternetAddress.anyIPv4, port);

      if (httpServer == null) {
        throw CustomException(e: 'Error occurred during opening server');
      }
      port = httpServer!.port;
      fileConnLink = getConnLink(myIp!, port);
      logger.w(fileConnLink);

      httpServer!.listen(
        (event) => serveFileListener(event, filePath),
      );
    } catch (e) {
      await closeSend();
      rethrow;
    }
  }

  Future<void> closeSend() async {
    await httpServer?.close();
    httpServer = null;
    fileConnLink = null;
    myIp = null;
    notifyListeners();
  }
}

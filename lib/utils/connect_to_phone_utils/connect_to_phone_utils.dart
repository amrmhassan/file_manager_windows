import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:windows_app/constants/server_constants.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:windows_app/utils/server_utils/connection_utils.dart';

Future<Map<String, int>> getPhoneStorageInfo(BuildContext context) async {
  int port = connectPPF(context).remotePort!;
  String ip = connectPPF(context).remoteIP!;
  var res = await Dio().get(getConnLink(ip, port, getStorageEndPoint));
  int freeSpace = int.parse(res.headers.value(freeSpaceHeaderKey)!);
  int totalSpace = int.parse(res.headers.value(totalSpaceHeaderKey)!);

  return {
    freeSpaceHeaderKey: freeSpace,
    totalSpaceHeaderKey: totalSpace,
  };
}

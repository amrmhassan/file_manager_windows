import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:windows_app/constants/server_constants.dart';
import 'package:windows_app/models/share_space_item_model.dart';
import 'package:windows_app/providers/connect_phone_provider.dart';
import 'package:windows_app/providers/shared_items_explorer_provider.dart';
import 'package:windows_app/utils/errors_collection/custom_exception.dart';
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

Future<void> getPhoneFolderContent({
  required String folderPath,
  required ShareItemsExplorerProvider shareItemsExplorerProvider,
  required ConnectPhoneProvider connectPhoneProvider,
}) async {
  try {
    shareItemsExplorerProvider.setLoadingItems(true);
    String connLink = getConnLink(connectPhoneProvider.remoteIP!,
        connectPhoneProvider.remotePort!, getPhoneFolderContentEndPoint);
    var res = await Dio().get(
      connLink,
      options: Options(
        headers: {
          folderPathHeaderKey: Uri.encodeComponent(folderPath),
        },
      ),
    );
    var data = res.data as List;
    String folderPathRetrieved =
        Uri.decodeComponent(res.headers.value(parentFolderPathHeaderKey)!);
    var items = data.map((e) => ShareSpaceItemModel.fromJSON(e)).toList();
    shareItemsExplorerProvider.updatePath(folderPathRetrieved, items);

    shareItemsExplorerProvider.setLoadingItems(false, false);
  } catch (e, s) {
    shareItemsExplorerProvider.setLoadingItems(false);
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

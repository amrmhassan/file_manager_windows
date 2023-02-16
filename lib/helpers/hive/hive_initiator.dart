import 'package:windows_app/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:windows_app/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:windows_app/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:windows_app/models/analyzer_report_info_model.dart';
import 'package:windows_app/models/download_task_model.dart';
import 'package:windows_app/models/folder_item_info_model.dart';
import 'package:windows_app/models/listy_item_model.dart';
import 'package:windows_app/models/listy_model.dart';
import 'package:windows_app/models/recent_opened_file_model.dart';
import 'package:windows_app/models/share_space_item_model.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/models/white_block_list_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveInitiator {
  Future<void> setup() async {
    await Hive.initFlutter();
    _registerAdapters();
  }

  Future<void> _registerAdapters() async {
    Hive.registerAdapter(AnalyzerReportInfoModelAdapter()); //=>0
    Hive.registerAdapter(DownloadTaskModelAdapter()); //=>1
    Hive.registerAdapter(FolderItemInfoModelAdapter()); //=>2
    Hive.registerAdapter(ListyItemModelAdapter()); //=>3
    Hive.registerAdapter(ListyModelAdapter()); //=>4
    Hive.registerAdapter(RecentOpenedFileModelAdapter()); //=>5
    Hive.registerAdapter(ShareSpaceItemModelAdapter()); //=>6
    Hive.registerAdapter(WhiteBlockListModelAdapter()); //=>7
    Hive.registerAdapter(LocalFileInfoAdapter()); //=>8
    Hive.registerAdapter(LocalFolderInfoAdapter()); //=>9
    Hive.registerAdapter(ExtensionInfoAdapter()); //=>10
    Hive.registerAdapter(EntityTypeAdapter()); //=>11
  }
}

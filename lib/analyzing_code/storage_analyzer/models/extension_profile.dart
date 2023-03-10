import 'package:windows_app/analyzing_code/storage_analyzer/models/local_file_info.dart';

class ExtensionProfile {
  final String ext;
  final LocalFileInfo localFileInfo;

  const ExtensionProfile({
    required this.ext,
    required this.localFileInfo,
  });
}

import 'dart:io';

import 'package:windows_app/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/files_types_icons.dart';
import 'package:windows_app/providers/util/analyzer_provider.dart';
import 'package:windows_app/screens/recent_screen/widget/segment_section.dart';

//? to get sections info
Future<void> calcSections(
  List<ExtensionInfo>? extInfo,
  Function(List<SectionElement> sections) setSections,
  AnalyzerProvider analyzerProvider,
) async {
  //# windows
  if (Platform.isWindows) return;

  int imageSize = 0;
  int audioSize = 0;
  int videoSize = 0;
  int apkSize = 0;
  int docSize = 0;
  int unknownSize = 0;

  if (extInfo == null) return;
  int totalSize = await analyzerProvider.getTotalDiskSpace();
  int? totalFilesSize = analyzerProvider.reportInfo?.totalFilesSize;
  if (totalFilesSize == null) return;
  int appDataSize = await analyzerProvider.getAppsDiskSpace(totalFilesSize);

  for (var ext in extInfo) {
    FileType fileType = getFileType(ext.ext);

    if (fileType == FileType.image) {
      imageSize += ext.size;
    } else if (fileType == FileType.audio) {
      audioSize += ext.size;
    } else if (fileType == FileType.video) {
      videoSize += ext.size;
    } else if (fileType == FileType.apk) {
      apkSize += ext.size;
    } else if (fileType == FileType.docs) {
      docSize += ext.size;
    } else if (fileType == FileType.unknown) {
      unknownSize += ext.size;
    }
  }
  SectionElement imageSection = SectionElement(
    color: kImagesColor,
    title: 'Images',
    percent: imageSize / totalSize,
  );
  SectionElement audioSection = SectionElement(
    color: kAudioColor,
    percent: audioSize / totalSize,
    title: 'Music',
  );
  SectionElement videoSection = SectionElement(
    color: kVideoColor,
    percent: videoSize / totalSize,
    title: 'Videos',
  );
  SectionElement apkSection = SectionElement(
    color: kAPKsColor,
    percent: apkSize / totalSize,
    title: 'APKs',
  );
  SectionElement docSection = SectionElement(
    color: kDocsColor,
    percent: docSize / totalSize,
    title: 'Docs',
  );

  SectionElement unknownSection = SectionElement(
    color: kUnknownColor,
    percent: unknownSize / totalSize,
    title: 'Unknown',
  );
  SectionElement appsSizeSection = SectionElement(
    color: kAppsColor,
    percent: appDataSize / totalSize,
    title: 'Apps Data',
  );
  List<SectionElement> sections = [
    imageSection,
    audioSection,
    videoSection,
    apkSection,
    docSection,
    unknownSection,
    appsSizeSection,
  ];
  sections.sort(
    (a, b) => b.percent.compareTo(a.percent),
  );

//! fix the error with the app size doesn't change when the ext info loaded
//! then make a loader over the storage segments
  setSections(sections);
}

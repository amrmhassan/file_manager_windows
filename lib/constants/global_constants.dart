import 'dart:io';
import 'dart:math';

import 'package:windows_app/providers/explorer_provider_abstract.dart';
import 'package:windows_app/utils/windows_utils/disks_capturer.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

String phoneName = 'Phone';
String phoneID = 'phone_id';

// const String initialPath = '/';
final List<Directory> initialDirs = Platform.isWindows
    ? validWindowsDisks()
    : [
        Directory('/'),
        Directory('sdcard'),
      ];
final Logger logger = Logger();

const Duration homePageViewDuration = Duration(milliseconds: 180);

//? animations durations
const Duration entitySizePercentageDuration = Duration(milliseconds: 200);
const Duration bottomActionsDuration = Duration(milliseconds: 230);
const Duration recentExpandDuration = Duration(milliseconds: 150);
const Duration segmentsDuration = Duration(milliseconds: 400);
const Duration thumbnailFadeDuration = Duration(milliseconds: 100);

//? animations constants
const bool allowSizesExpAnimation = true;
const bool allowDevBoxes = true;

//? sort options default
const SortOption defaultSortOption = SortOption.nameAsc;
const bool defaultShowHiddenFiles = false;
const bool defaultPriotorizeFolders = true;

//? theme constants
bool lightTheme = true;

//? debugging constants
const bool showAnalyzerStuff = false;
const bool allowVideoThumbnail = true;
const bool allowDebuggingDrawerElements = true;

//? user prefs constants
const bool allowRecentItemsFromHiddenFiles = true;

//? downloading folders
const String mainDownloadFolder = 'AFM Downloads';

const String apkDownloadFolder = 'Apps';
const String archiveDownloadFolder = 'Archive';
const String audioDownloadFolder = 'Audio';
const String docDownloadFolder = 'Documents';
const String imageDownloadFolder = 'Images';
const String videoDownloadFolder = 'Video';
const String otherDownloadFolder = 'Other';
const String foldersDownloadFolder = 'Folders';

//? storage item
const double height = 60;
GlobalKey storageItemKey = GlobalKey();

//? device props constants
String myDefaultName = 'No Name ${Random().nextInt(99)}';

//? downloads settings
int maxParallelDownloadTasksDefault = 1;

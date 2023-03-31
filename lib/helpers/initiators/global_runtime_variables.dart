import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/models/storage_item_model.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/utils/models_transformer_utils.dart';
import 'package:flutter/material.dart';

//?
bool firstTimeRunApp = false;
//?
bool testing = false;
//?

//?
var validPaths = initialDirs
    .where(
      (element) => element.path != initialDirs.first.path,
    )
    .map((e) => {
          'path': e.path,
          'type': EntityType.folder,
        });
//?
List<StorageItemModel> explorerMainDisks =
    pathsToStorageItemsWithType(validPaths);
//?
//?
Locale? loadedCurrentLocale;
//?

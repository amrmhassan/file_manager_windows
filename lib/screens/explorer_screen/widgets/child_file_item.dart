// ignore_for_file: prefer_const_constructors, dead_code

import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:windows_app/analyzing_code/globals/files_folders_operations.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/global/widgets/padding_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/helpers/responsive.dart';
import 'package:windows_app/models/share_space_item_model.dart';
import 'package:windows_app/models/storage_item_model.dart';
import 'package:windows_app/providers/files_operations_provider.dart';
import 'package:windows_app/screens/explorer_screen/utils/sizes_utils.dart';
import 'package:windows_app/screens/explorer_screen/widgets/file_size.dart';
import 'package:windows_app/screens/explorer_screen/widgets/media_player_button.dart';
import 'package:windows_app/screens/explorer_screen/widgets/entity_check_box.dart';
import 'package:windows_app/screens/explorer_screen/widgets/file_thumbnail.dart';
import 'package:windows_app/screens/explorer_screen/widgets/home_item_h_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path/path.dart' as path_operations;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ChildFileItem extends StatefulWidget {
  final StorageItemModel? storageItemModel;
  final ShareSpaceItemModel? shareSpaceItemModel;
  final bool sizesExplorer;
  final int parentSize;
  final bool isSelected;
  final bool allowSelect;
  final bool network;

  const ChildFileItem({
    super.key,
    this.storageItemModel,
    this.shareSpaceItemModel,
    required this.sizesExplorer,
    required this.parentSize,
    required this.isSelected,
    required this.allowSelect,
    required this.network,
  });

  @override
  State<ChildFileItem> createState() => _ChildFileItemState();
}

class _ChildFileItemState extends State<ChildFileItem> {
  String get path =>
      widget.storageItemModel?.path ?? widget.shareSpaceItemModel!.path;

  int? get size =>
      widget.storageItemModel?.size ?? widget.shareSpaceItemModel?.size;
  final GlobalKey key = GlobalKey();

  Directory? tempDir;
  double? height = 100;
  late int parentSize;
  @override
  void initState() {
    parentSize = allowSizesExpAnimation ? 0 : widget.parentSize;
    Future.delayed(entitySizePercentageDuration).then((value) {
      if (mounted) {
        setState(() {
          parentSize = widget.parentSize < 0 ? 0 : widget.parentSize;
        });
      }
    });
    Future.delayed(Duration.zero).then((value) async {
      tempDir = await getTemporaryDirectory();
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.sizesExplorer) {
        setState(() {
          height = key.currentContext?.size?.height;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var foProvider = Provider.of<FilesOperationsProvider>(context);
    // this code took 200 micro second which is very small amount of time

    File file = File(path);
    bool exists = file.existsSync();

    return !exists && widget.storageItemModel != null
        ? SizedBox()
        : Stack(
            children: [
              if (widget.sizesExplorer)
                AnimatedContainer(
                  curve: true ? Curves.elasticOut : Curves.easeInSine,
                  duration: entitySizePercentageDuration,
                  width: Responsive.getWidthPercentage(
                    context,
                    getSizePercentage(
                        widget.storageItemModel!.size ?? 0, parentSize),
                  ),
                  color: kInactiveColor.withOpacity(.2),
                  height: height,
                ),
              Column(
                key: key,
                children: [
                  VSpace(factor: .5),
                  PaddingWrapper(
                    child: Row(
                      children: [
                        FileThumbnail(
                          path: path,
                          sharingFile: widget.storageItemModel == null,
                        ),
                        HSpace(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.sizesExplorer ||
                                        foProvider.exploreMode ==
                                            ExploreMode.selection
                                    ? path_operations.basename(path)
                                    : getFileName(path),
                                style: h4LightTextStyle,
                                //! fix the file name
                                maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                              ),
                              FileSize(
                                modified: widget.storageItemModel?.modified,
                                path: widget.storageItemModel?.path ??
                                    widget.shareSpaceItemModel!.path,
                                size: size,
                                sizesExplorer: widget.sizesExplorer,
                                localFile: widget.storageItemModel != null,
                              ),
                            ],
                          ),
                        ),
                        HSpace(),
                        MediaPlayerButton(
                          mediaPath: path,
                          network: widget.network,
                        ),
                        HSpace(),
                        foProvider.exploreMode == ExploreMode.selection &&
                                widget.allowSelect
                            ? EntityCheckBox(
                                isSelected: widget.isSelected,
                                storageItemModel: widget.storageItemModel!,
                              )
                            : Container(
                                constraints:
                                    BoxConstraints(maxWidth: largeIconSize),
                                child: Text(
                                  widget.sizesExplorer
                                      ? sizePercentageString(
                                          getSizePercentage(
                                            widget.storageItemModel!.size ?? 0,
                                            parentSize,
                                          ),
                                        )
                                      : getFileExtension(path),
                                  style: h4TextStyleInactive.copyWith(
                                    color: kInActiveTextColor.withOpacity(.7),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                      ],
                    ),
                  ),
                  VSpace(factor: .5),
                  HomeItemHLine(),
                ],
              ),
            ],
          );
  }
}

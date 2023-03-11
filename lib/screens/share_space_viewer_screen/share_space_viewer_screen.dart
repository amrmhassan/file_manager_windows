// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/constants/sizes.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/modals/show_modal_funcs.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:windows_app/global/widgets/h_space.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/global/widgets/v_space.dart';
import 'package:windows_app/models/peer_model.dart';
import 'package:windows_app/models/share_space_item_model.dart';
import 'package:windows_app/models/types.dart';
import 'package:windows_app/providers/files_operations_provider.dart';
import 'package:windows_app/screens/share_screen/widgets/not_sharing_view.dart';
import 'package:windows_app/utils/client_utils.dart' as client_utils;
import 'package:windows_app/providers/server_provider.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/providers/shared_items_explorer_provider.dart';
import 'package:windows_app/screens/explorer_screen/widgets/current_path_viewer.dart';
import 'package:windows_app/screens/explorer_screen/widgets/storage_item.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path_operations;
import 'package:windows_app/utils/connect_to_phone_utils/connect_to_phone_utils.dart'
    as connect_phone_utils;

class ShareSpaceVScreen extends StatefulWidget {
  static const String routeName = '/ShareSpaceViewerScreen';
  const ShareSpaceVScreen({
    super.key,
  });

  @override
  State<ShareSpaceVScreen> createState() => _ShareSpaceVScreenState();
}

class _ShareSpaceVScreenState extends State<ShareSpaceVScreen> {
  PeerModel? remotePeerModel;
  bool me = false;
  bool phone = false;

//? to load shared items
  Future loadSharedItems([String? path]) async {
    var serverProviderFalse =
        Provider.of<ServerProvider>(context, listen: false);
    var shareProviderFalse = Provider.of<ShareProvider>(context, listen: false);
    var shareItemsExplorerProvider =
        Provider.of<ShareItemsExplorerProvider>(context, listen: false);

    try {
      List<ShareSpaceItemModel> shareItems = [];
      if (remotePeerModel!.phone) {
        await localGetFolderContent('/', true);
      } else {
        shareItems = (await client_utils.getPeerShareSpace(
              remotePeerModel!.sessionID,
              serverProviderFalse,
              shareProviderFalse,
              shareItemsExplorerProvider,
              remotePeerModel!.deviceID,
            )) ??
            [];
      }

      shareItemsExplorerProvider.setCurrentSharedItems(shareItems);
    } catch (e) {
      logger.e(e);
      Navigator.pop(context);
      showSnackBar(
        context: context,
        message: e.toString(),
        snackBarType: SnackBarType.error,
      );
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      var argument = ModalRoute.of(context)!.settings.arguments;
      // bool means that it is from files explorer from windows device
      if (argument is bool) {
        setState(() {
          phone = true;
        });
        connect_phone_utils.getPhoneFolderContent(
          folderPath: '/',
          shareItemsExplorerProvider: shareExpPF(context),
          connectPhoneProvider: connectPPF(context),
        );
      } else {
        setState(() {
          remotePeerModel =
              ModalRoute.of(context)!.settings.arguments as PeerModel;
          phone = remotePeerModel?.phone ?? false;
        });
        if (remotePeerModel?.deviceID == sharePF(context).myDeviceId) {
          setState(() {
            me = true;
          });
        } else {
          loadSharedItems();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var shareExpProvider = Provider.of<ShareItemsExplorerProvider>(context);
    String? parentPath = shareExpProvider.currentSharedFolderPath == null
        ? null
        : path_operations.dirname(shareExpProvider.currentSharedFolderPath!);
    String? viewPath =
        shareExpProvider.currentPath?.replaceFirst(parentPath ?? '', '');

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              phone
                  ? 'Phone'
                  : shareExpProvider.loadingItems || (remotePeerModel == null)
                      ? '...'
                      : me
                          ? 'Your Share Space'
                          : '${remotePeerModel!.name} Share Space',
              style: h2TextStyle.copyWith(
                color: kActiveTextColor,
              ),
            ),
            rightIcon: shareExpProvider.allowSelect
                ? Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonWrapper(
                            padding: EdgeInsets.all(mediumPadding),
                            onTap: () {
                              var selectedItems =
                                  shareExpPF(context).selectedItems;
                              downPF(context).addMultipleDownloadTasks(
                                remoteEntitiesPaths:
                                    selectedItems.map((e) => e.path),
                                sizes: selectedItems.map((e) => e.size),
                                remoteDeviceID: remotePeerModel?.deviceID,
                                remoteDeviceName: remotePeerModel?.name,
                                serverProvider: serverPF(context),
                                shareProvider: sharePF(context),
                                entitiesTypes: selectedItems.map(
                                  (e) => e.entityType,
                                ),
                              );
                              shareExpPF(context).clearSelectedItems();
                            },
                            child: Image.asset(
                              'assets/icons/download.png',
                              width: mediumIconSize,
                            ),
                          ),
                        ],
                      ),
                      HSpace(),
                    ],
                  )
                : null,
          ),
          if (me) NotSharingView(),
          if (shareExpProvider.currentPath != null)
            CurrentPathViewer(
              sizesExplorer: false,
              customPath: viewPath,
              onCopy: () {
                copyToClipboard(context, viewPath!);
              },
              onHomeClicked: () {
                Navigator.pushReplacementNamed(
                  context,
                  ShareSpaceVScreen.routeName,
                  arguments: remotePeerModel ?? phone,
                );
              },
              onClickingSubPath: (path) => localGetFolderContent(path),
            ),
          if (!me)
            shareExpProvider.loadingItems
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        VSpace(),
                        Text(
                          'Waiting ...',
                          style: h4TextStyleInactive,
                        )
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: shareExpProvider.viewedItems.length,
                      itemBuilder: (context, index) => StorageItem(
                        network: true,
                        onDirTapped: localGetFolderContent,
                        sizesExplorer: false,
                        parentSize: 0,
                        exploreMode: ExploreMode.selection,
                        isSelected: shareExpProvider.isSelected(
                            shareExpProvider.viewedItems[index].path),
                        shareSpaceItemModel:
                            shareExpProvider.viewedItems[index],
                        onSelectClicked: () {
                          shareExpPF(context).toggleSelectItem(
                            shareExpProvider.viewedItems[index],
                          );
                        },
                        // to prevent clicking on the disk storages
                        onLongPressed: (path, entityType, network) {
                          // showDownloadFromShareSpaceModal(
                          //   context,
                          //   data.peerModel,
                          //   index,
                          // );
                          shareExpPF(context).toggleSelectItem(
                            shareExpProvider.viewedItems[index],
                          );
                        },
                        onFileTapped: (path) {
                          showDownloadFromShareSpaceModal(
                            context,
                            remotePeerModel,
                            index,
                          );
                        },
                        allowSelect: shareExpProvider.allowSelect,
                      ),
                    ),
                  ),
          VSpace(),
        ],
      ),
    );
  }

  Future<void> localGetFolderContent(
    String path, [
    bool shareSpace = false,
  ]) async {
    try {
      if (phone) {
        await connect_phone_utils.getPhoneFolderContent(
          folderPath: path,
          shareItemsExplorerProvider: shareExpPF(context),
          connectPhoneProvider: connectPPF(context),
          shareSpace: shareSpace,
        );
      } else {
        var shareExpProvider =
            Provider.of<ShareItemsExplorerProvider>(context, listen: false);

        var serverProvider =
            Provider.of<ServerProvider>(context, listen: false);
        String userSessionID = shareExpProvider.viewedUserSessionId!;
        var shareProvider = Provider.of<ShareProvider>(context, listen: false);
        var shareItemsExplorerProvider =
            Provider.of<ShareItemsExplorerProvider>(context, listen: false);
        await client_utils.getFolderContent(
          serverProvider: serverProvider,
          folderPath: path,
          shareProvider: shareProvider,
          userSessionID: userSessionID,
          shareItemsExplorerProvider: shareItemsExplorerProvider,
        );
      }
    } catch (e) {
      logger.e(e);
      showSnackBar(
        context: context,
        message: 'Can\'t get this folder content',
        snackBarType: SnackBarType.error,
      );
    }
  }
}

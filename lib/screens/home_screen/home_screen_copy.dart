// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

// import 'dart:io';
// import 'dart:async';
// import 'dart:isolate';
// import 'package:windows_app/models/storage_item_model.dart';
// import 'package:windows_app/models/types.dart';
// import 'package:windows_app/providers/analyzer_provider.dart';
// import 'package:windows_app/providers/dir_children_list_provider.dart';
// import 'package:windows_app/screens/analyzer_screen/analyzer_screen.dart';
// import 'package:windows_app/screens/explorer_screen/explorer_screen.dart';
// import 'package:windows_app/screens/home_screen/utils/permissions.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';

// import 'package:windows_app/constants/global_constants.dart';
// import 'package:windows_app/global/widgets/screens_wrapper.dart';
// import 'package:windows_app/providers/children_info_provider.dart';
// import 'package:windows_app/constants/colors.dart';
// import 'package:windows_app/screens/home_screen/widgets/home_app_bar.dart';
// import 'package:windows_app/utils/general_utils.dart';

// class HomeScreen extends StatefulWidget {
//   final bool sizesExplorer;
//   static const String routeName = '/home-screen';

//   const HomeScreen({
//     super.key,
//     this.sizesExplorer = false,
//   });

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int activeViewIndex = 1;
//   late PageController pageController;
//   Directory currentActiveDir = initialDir;
//   int exitCounter = 0;
//   List<StorageItemModel> viewedChildren = [];
//   String? error;
//   bool loadingDirDirectChildren = false;
//   StreamSubscription<FileSystemEntity>? streamSub;
//   SendPort? globalSendPort;

// //? set the current acitive screen
//   void setActiveScreen(int i) {
//     pageController.animateToPage(
//       i,
//       duration: homePageViewDuration,
//       curve: Curves.easeInOut,
//     );
//     setState(() {
//       activeViewIndex = i;
//     });
//   }

//   // void runTheIsolate() {
//   //   var receivePort = ReceivePort();
//   //   var sendPort = receivePort.sendPort;
//   //   Isolate.spawn(loadExplorerChildren, sendPort);
//   //   receivePort.listen((message) {
//   //     if (message is SendPort) {
//   //       globalSendPort = message;
//   //     } else if (message is LoadChildrenMessagesData) {
//   //       if (message.flag == LoadChildrenMessagesFlags.childrenChunck) {
//   //         setState(() {
//   //           viewedChildren.addAll(message.data);
//   //         });
//   //       } else if (message.flag == LoadChildrenMessagesFlags.done) {
//   //         setState(() {
//   //           viewedChildren.addAll(message.data);
//   //           loadingDirDirectChildren = false;
//   //         });
//   //       } else if (message.flag == LoadChildrenMessagesFlags.error) {
//   //         setState(() {
//   //           error = error.toString();
//   //         });
//   //       }
//   //     }
//   //   });
//   // }

// //? update viewed children
//   // void updateViewChildren(String path) async {
//   //   setState(() {
//   //     error = null;
//   //     loadingDirDirectChildren = true;
//   //     viewedChildren.clear();
//   //   });
//   //   if (globalSendPort != null) {
//   //     globalSendPort!.send(path);
//   //   }
//   // }

//   //? update viewed children
//   void updateViewChildren(String path) async {
//     Provider.of<ExplorerProvider>(context, listen: false).setActiveDir(path);

//     try {
//       if (streamSub != null) {
//         await streamSub!.cancel();
//       }
//       Stream<FileSystemEntity> chidrenStream = currentActiveDir.list();
//       setState(() {
//         error = null;
//         loadingDirDirectChildren = true;
//         viewedChildren.clear();
//       });

//       streamSub = chidrenStream.listen((entity) async {
//         FileStat fileStat = entity.statSync();
//         StorageItemModel storageItemModel = StorageItemModel(
//           parentPath: entity.parent.path,
//           path: entity.path,
//           modified: fileStat.modified,
//           accessed: fileStat.accessed,
//           changed: fileStat.changed,
//           entityType: fileStat.type == FileSystemEntityType.directory
//               ? EntityType.folder
//               : EntityType.file,
//           size: fileStat.type == FileSystemEntityType.directory
//               ? null
//               : fileStat.size,
//         );
//         setState(() {
//           viewedChildren.add(storageItemModel);
//         });
//       });
//       streamSub!.onError((e, s) {
//         setState(() {
//           error = e.toString();
//         });
//       });
//       streamSub!.onDone(() {
//         setState(() {
//           loadingDirDirectChildren = false;
//         });
//       });
//     } catch (e) {
//       setState(() {
//         viewedChildren.clear();
//         error = e.toString();
//       });
//     }
//   }

//   //? this will handle what happen when clicking a folder
//   void updateActivePath(String path) {
//     setState(() {
//       currentActiveDir = Directory(path);
//     });
//     updateViewChildren(currentActiveDir.path);
//   }

// //? handling going back in path
//   void goBack() {
//     if (currentActiveDir.parent.path == '.') return;
//     updateActivePath(currentActiveDir.parent.path);
//   }

//   //? to catch clicking the phone back button
//   Future<bool> handlePressPhoneBackButton() {
//     bool exit = false;
//     String cp = currentActiveDir.path;
//     String ip = initialDir.path;
//     if (cp == ip) {
//       if (widget.sizesExplorer) {
//         return Future.delayed(Duration.zero).then((value) => true);
//       }
//       exitCounter++;
//       if (exitCounter <= 1) {
//         showSnackBar(context: context, message: 'Back Again To Exit');
//         exit = false;
//       } else {
//         exit = true;
//       }
//     } else {
//       exit = false;
//     }
//     goBack();
//     //* to reset the exit counter after 2 seconds
//     Future.delayed(Duration(seconds: 5)).then((value) {
//       exitCounter = 0;
//     });
//     return Future.delayed(Duration.zero).then((value) => exit);
//   }

//   //? go home
//   void goHome() {
//     updateActivePath(initialDir.path);
//   }

//   @override
//   void initState() {
//     // runTheIsolate();
//     pageController = PageController(
//       initialPage: activeViewIndex,
//     );
//     Future.delayed(Duration.zero).then((value) async {
//       await Provider.of<AnalyzerProvider>(context, listen: false)
//           .loadInitialAppData();
//       //* getting storage permission
//       bool res = await handleStoragePermissions(
//         context: context,
//         currentActiveDir: currentActiveDir,
//         updateViewChildren: (String path) {
//           updateActivePath(path);
//           // runTheIsolate();
//         },
//       );
//       if (!res) return;
//       await Provider.of<ChildrenItemsProvider>(context, listen: false)
//           .getAndUpdataAllSavedFolders();
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: handlePressPhoneBackButton,
//       child: ScreensWrapper(
//         backgroundColor: kBackgroundColor,
//         child: Column(
//           children: [
//             HomeAppBar(
//               goBack: goBack,
//               loadingFolder: loadingDirDirectChildren,
//               activeScreenIndex: activeViewIndex,
//               setActiveScreen: setActiveScreen,
//             ),
//             Expanded(
//               child: PageView(
//                 onPageChanged: (value) {
//                   setState(() {
//                     activeViewIndex = value;
//                   });
//                 },
//                 controller: pageController,
//                 physics: widget.sizesExplorer
//                     ? NeverScrollableScrollPhysics()
//                     : BouncingScrollPhysics(),
//                 children: [
//                   AnalyzerScreen(),
//                   ExplorerScreen(
//                     clickFolder: updateActivePath,
//                     viewedChildren: viewedChildren,
//                     error: error,
//                     loading: loadingDirDirectChildren,
//                     activeDirectory: currentActiveDir,
//                     currentActiveDir: currentActiveDir,
//                     goHome: goHome,
//                     sizesExplorer: widget.sizesExplorer,
//                     updateActivePath: updateActivePath,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

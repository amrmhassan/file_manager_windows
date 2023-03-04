// ignore_for_file: prefer_const_constructors

import 'package:dart_vlc/dart_vlc.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/constants/widget_keys.dart';
import 'package:windows_app/helpers/hive/hive_initiator.dart';
import 'package:windows_app/helpers/shared_pref_helper.dart';
import 'package:windows_app/providers/animation_provider.dart';
import 'package:windows_app/providers/connect_phone_provider.dart';
import 'package:windows_app/providers/download_provider.dart';
import 'package:windows_app/providers/quick_send_provider.dart';
import 'package:windows_app/providers/server_provider.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/providers/shared_items_explorer_provider.dart';
import 'package:windows_app/providers/util/analyzer_provider.dart';
import 'package:windows_app/providers/children_info_provider.dart';
import 'package:windows_app/providers/util/explorer_provider.dart';
import 'package:windows_app/providers/files_operations_provider.dart';
import 'package:windows_app/providers/listy_provider.dart';
import 'package:windows_app/providers/media_player_provider.dart';
import 'package:windows_app/providers/recent_provider.dart';
import 'package:windows_app/providers/theme_provider.dart';
import 'package:windows_app/providers/thumbnail_provider.dart';
import 'package:windows_app/providers/settings_provider.dart';
import 'package:windows_app/providers/window_provider.dart';
import 'package:windows_app/screens/about_us_screen/about_us_screen.dart';
import 'package:windows_app/screens/analyzer_screen/analyzer_screen.dart';
import 'package:windows_app/screens/connect_phone_screen/connect_phone_screen.dart';
import 'package:windows_app/screens/download_manager_screen/download_manager_screen.dart';
import 'package:windows_app/screens/error_viewing_screen/error_viewing_screen.dart';
import 'package:windows_app/screens/intro_screen/intro_screen.dart';
import 'package:windows_app/screens/items_viewer_screen/items_viewer_screen.dart';
import 'package:windows_app/screens/ext_files_screen/ext_files_screen.dart';
import 'package:windows_app/screens/ext_report_screen/ext_report_screen.dart';
import 'package:windows_app/screens/home_screen/home_screen.dart';
import 'package:windows_app/screens/isolate_testing_screen/isolate_testing_screen.dart';
import 'package:windows_app/screens/laptop_messages_screen/laptop_messages_screen.dart';
import 'package:windows_app/screens/listy_items_viewer_screen/listy_items_viewer_screen.dart';
import 'package:windows_app/screens/listy_screen/listy_screen.dart';
import 'package:windows_app/screens/qr_code_viewer_screen/qr_code_viewer_screen.dart';
import 'package:windows_app/screens/recent_items_viewer_screen/recent_items_viewer_screen.dart';
import 'package:windows_app/screens/scan_qr_code_screen/scan_qr_code_screen.dart';
import 'package:windows_app/screens/selected_items_screen/selected_items_screen.dart';
import 'package:windows_app/screens/settings_screen/settings_screen.dart';
import 'package:windows_app/screens/share_screen/share_screen.dart';
import 'package:windows_app/screens/share_settings_screen/share_settings_screen.dart';
import 'package:windows_app/screens/share_space_viewer_screen/share_space_viewer_screen.dart';
import 'package:windows_app/screens/sizes_exp_screen/sizes_exp_screen.dart';
import 'package:windows_app/screens/storage_cleaner_screen/storage_cleaner_screen.dart';
import 'package:windows_app/screens/test_screen/test_screen.dart';
import 'package:windows_app/screens/whats_app_files_screen/whats_app_files_screen.dart';
import 'package:windows_app/screens/whats_app_screen/whats_app_screen.dart';
import 'package:windows_app/screens/white_block_list_screen/white_block_list_screen.dart';
import 'package:windows_app/utils/general_utils.dart';
import 'package:windows_app/utils/theme_utils.dart';
import 'package:windows_app/utils/windows_utils/window_size.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool firstTimeRunApp = false;
late String downloadFolder;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firestore.initialize('advanced-file-manager-8b7ab');

  await windowManager.ensureInitialized();

  try {
    await HiveInitiator().setup();
    firstTimeRunApp = await SharedPrefHelper.firstTimeRunApp();
    await setThemeVariables();
    await initWindowSize();
    await DartVLC.initialize();
    downloadFolder = (await getApplicationDocumentsDirectory()).path;
  } catch (e) {
    printOnDebug('Error with first time app in main() or theme variables');
  }

  runApp(const MyApp());
}

bool testing = true;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ChildrenItemsProvider()),
        ChangeNotifierProvider(create: (ctx) => AnalyzerProvider()),
        ChangeNotifierProvider(create: (ctx) => ExplorerProvider()),
        ChangeNotifierProvider(create: (ctx) => FilesOperationsProvider()),
        ChangeNotifierProvider(create: (ctx) => SettingsProvider()),
        ChangeNotifierProvider(create: (ctx) => RecentProvider()),
        ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
        ChangeNotifierProvider(create: (ctx) => MediaPlayerProvider()),
        ChangeNotifierProvider(create: (ctx) => ListyProvider()),
        ChangeNotifierProvider(create: (ctx) => ThumbnailProvider()),
        ChangeNotifierProvider(create: (ctx) => ShareProvider()),
        ChangeNotifierProvider(create: (ctx) => ServerProvider()),
        ChangeNotifierProvider(create: (ctx) => ShareItemsExplorerProvider()),
        ChangeNotifierProvider(create: (ctx) => DownloadProvider()),
        ChangeNotifierProvider(create: (ctx) => QuickSendProvider()),
        ChangeNotifierProvider(create: (ctx) => ConnectPhoneProvider()),
        ChangeNotifierProvider(create: (ctx) => WindowProvider()),
        ChangeNotifierProvider(create: (ctx) => AnimationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              fontFamily: 'Cairo',
              color: kActiveTextColor,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Cairo',
              color: kActiveTextColor,
            ),
          ),
        ),
        initialRoute: testing
            ? TestScreen.routeName
            : (firstTimeRunApp ? IntroScreen.routeName : HomeScreen.routeName),
        navigatorKey: navigatorKey,
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          TestScreen.routeName: (context) => TestScreen(),
          IsolateTestingScreen.routeName: (context) => IsolateTestingScreen(),
          SizesExpScreen.routeName: (context) => SizesExpScreen(),
          ExtReportScreen.routeName: (context) => ExtReportScreen(),
          ExtFilesScreen.routeName: (context) => ExtFilesScreen(),
          AnalyzerScreen.routeName: (context) => AnalyzerScreen(),
          WhatsAppScreen.routeName: (context) => WhatsAppScreen(),
          WhatsappFilesScreen.routeName: (context) => WhatsappFilesScreen(),
          RecentsViewerScreen.routeName: (context) => RecentsViewerScreen(),
          StorageCleanerScreen.routeName: (context) => StorageCleanerScreen(),
          ItemsViewerScreen.routeName: (context) => ItemsViewerScreen(),
          ListyScreen.routeName: (context) => ListyScreen(),
          ListyItemViewerScreen.routeName: (context) => ListyItemViewerScreen(),
          SettingsScreen.routeName: (context) => SettingsScreen(),
          SelectedItemsScreen.routeName: (context) => SelectedItemsScreen(),
          ShareScreen.routeName: (context) => ShareScreen(),
          QrCodeViewerScreen.routeName: (context) => QrCodeViewerScreen(),
          ScanQRCodeScreen.routeName: (context) => ScanQRCodeScreen(),
          ShareSpaceVScreen.routeName: (context) => ShareSpaceVScreen(),
          DownloadManagerScreen.routeName: (context) => DownloadManagerScreen(),
          ErrorViewScreen.routeName: (context) => ErrorViewScreen(),
          ShareSettingsScreen.routeName: (context) => ShareSettingsScreen(),
          WhiteBlockListScreen.routeName: (context) => WhiteBlockListScreen(),
          IntroScreen.routeName: (context) => IntroScreen(),
          AboutUsScreen.routeName: (context) => AboutUsScreen(),
          ConnectPhoneScreen.routeName: (context) => ConnectPhoneScreen(),
          LaptopMessagesScreen.routeName: (context) => LaptopMessagesScreen(),
        },
      ),
    );
  }
}

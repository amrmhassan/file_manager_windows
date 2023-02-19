// import 'package:windows_app/constants/server_constants.dart';
// import 'package:windows_app/providers/connect_phone_provider.dart';
// import 'package:windows_app/utils/connect_to_phone_utils/handlers/handlers.dart'
//     as laptop_handlers;
// import 'package:windows_app/utils/custom_router_system/custom_router_system.dart';
// import 'package:windows_app/utils/custom_router_system/helpers/server_requests_utils.dart';
// import 'package:windows_app/utils/server_utils/handlers/handlers.dart'
//     as normal_handlers;

// CustomRouterSystem connectLaptopRouter(ConnectPhoneProvider connectLaptopPF) {
//   CustomRouterSystem customRouterSystem = CustomRouterSystem();

//   //? adding handlers
//   customRouterSystem
//     ..addHandler(
//       getStorageEndPoint,
//       HttpMethod.GET,
//       laptop_handlers.getStorageInfoHandler,
//     )
//     ..addHandler(
//       getDiskNamesEndPoint,
//       HttpMethod.GET,
//       laptop_handlers.getDiskNamesHandler,
//     )
//     ..addHandler(
//       getPhoneFolderContentEndPoint,
//       HttpMethod.GET,
//       laptop_handlers.getPhoneFolderContentHandler,
//     )
//     ..addHandler(
//       streamAudioEndPoint,
//       HttpMethod.GET,
//       normal_handlers.streamAudioHandler,
//     )
//     ..addHandler(
//       streamVideoEndPoint,
//       HttpMethod.GET,
//       normal_handlers.streamVideoHandler,
//     )
//     ..addHandler(
//       getClipboardEndPoint,
//       HttpMethod.GET,
//       laptop_handlers.getClipboardHandler,
//     )
//     ..addHandler(
//       sendTextEndpoint,
//       HttpMethod.POST,
//       laptop_handlers.sendTextHandler,
//     )
//     ..addHandler(
//       getShareSpaceEndPoint,
//       HttpMethod.GET,
//       laptop_handlers.getPhoneShareSpaceHandler,
//     );
//   return customRouterSystem;
// }

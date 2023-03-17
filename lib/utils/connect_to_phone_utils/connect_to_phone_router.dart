import 'package:windows_app/constants/server_constants.dart';
import 'package:windows_app/providers/connect_phone_provider.dart';
import 'package:windows_app/utils/connect_to_phone_utils/handlers/handlers.dart'
    as laptop_handlers;
import 'package:windows_app/utils/custom_router_system/custom_router_system.dart';
import 'package:windows_app/utils/custom_router_system/helpers/server_requests_utils.dart';
import 'package:windows_app/utils/server_utils/handlers/handlers.dart'
    as normal_handlers;

//! i need to add the logic to authenticate users here
//! i mean in the main router before entering any Handler
//! the user will provide his deviceID and sessionID for each request and upon that i will authorize him or not

//! i also need to add the logic to decode or encode headers for arabic letters with Uri.decodeComponent before sending or receiving any headers
//! After adding video streaming i will implement this

//! you will also need to find a way to know when a device lost connection without waiting for the device to send that he will leave

//? this will add the server routers(end points), and it will refer to middle wares
CustomRouterSystem addConnectToPhoneServerRouters(
  ConnectPhoneProvider connectPPF,
) {
  CustomRouterSystem customRouterSystem = CustomRouterSystem();

  //? adding handlers
  customRouterSystem
    ..addHandler(
      serverCheckEndPoint,
      HttpMethod.POST,
      (request, response) => normal_handlers.serverCheckHandler(
        request,
        response,
        connectPPF,
      ),
    )
    ..addHandler(
      phoneWsServerConnLinkEndPoint,
      HttpMethod.GET,
      (request, response) {
        String wsConnLink = connectPPF.myWSConnLink;
        response.write(wsConnLink);
      },
    )
    ..addHandler(
      getDiskNamesEndPoint,
      HttpMethod.GET,
      laptop_handlers.getDiskNamesHandler,
    )
    ..addHandler(
      getPhoneFolderContentEndPoint,
      HttpMethod.GET,
      laptop_handlers.getPhoneFolderContentHandler,
    )
    ..addHandler(
      streamAudioEndPoint,
      HttpMethod.GET,
      normal_handlers.streamAudioHandler,
    )
    ..addHandler(
      streamVideoEndPoint,
      HttpMethod.GET,
      normal_handlers.streamVideoHandler,
    )
    ..addHandler(
      getClipboardEndPoint,
      HttpMethod.GET,
      laptop_handlers.getClipboardHandler,
    )
    ..addHandler(
      sendTextEndpoint,
      HttpMethod.POST,
      laptop_handlers.sendTextHandler,
    )
    ..addHandler(
      getShareSpaceEndPoint,
      HttpMethod.GET,
      laptop_handlers.getPhoneShareSpaceHandler,
    )
    ..addHandler(
      startDownloadFileEndPoint,
      HttpMethod.POST,
      laptop_handlers.startDownloadActionHandler,
    )
    ..addHandler(
      downloadFileEndPoint,
      HttpMethod.GET,
      normal_handlers.downloadFileHandler,
    )
    ..addHandler(
      getFolderContentRecursiveEndPoint,
      HttpMethod.GET,
      laptop_handlers.getFolderChildrenRecrusive,
    );
  return customRouterSystem;
}

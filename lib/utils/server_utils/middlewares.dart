// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:windows_app/constants/server_constants.dart';
import 'package:windows_app/constants/widget_keys.dart';
import 'package:windows_app/global/modals/show_modal_funcs.dart';
import 'package:windows_app/providers/server_provider.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/utils/custom_router_system/helpers/server_middleware_model.dart';

Future<MiddlewareReturn> getShareSpaceMiddleware(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
  ShareProvider shareProvider,
) async {
  var headers = request.headers;
  String? deviceID = headers.value(deviceIDHeaderKey);
  String? userName = headers.value(userNameHeaderKey);

  if (deviceID == null) {
    response
      ..statusCode = HttpStatus.badRequest
      ..headers.add(serverRefuseReasonHeaderKey, 'No device id provided')
      ..close();
    return MiddlewareReturn(
      request: request,
      response: response,
      closed: true,
      closeReason: 'No device id provided',
    );
  }
  if (userName == null) {
    response
      ..statusCode = HttpStatus.badRequest
      ..headers.add(serverRefuseReasonHeaderKey, 'No User name provided')
      ..close();
    return MiddlewareReturn(
      request: request,
      response: response,
      closed: true,
      closeReason: 'No user name provided',
    );
  }
  if (await serverProvider.isPeerAllowed(deviceID)) {
    return MiddlewareReturn(request: request, response: response);
  } else if (await serverProvider.isPeerBlocked(deviceID)) {
    response
      ..statusCode = HttpStatus.badRequest
      ..headers.add(serverRefuseReasonHeaderKey, 'You are blocked')
      ..close();
    return MiddlewareReturn(
      request: request,
      response: response,
      closed: true,
      closeReason: 'User is blocked',
    );
  }

  bool res = await showAskForShareSpaceModal(
    userName,
    deviceID,
    navigatorKey.currentContext!,
  );

  if (res) {
    return MiddlewareReturn(request: request, response: response);
  } else {
    response
      ..statusCode = HttpStatus.badRequest
      ..headers.add(serverRefuseReasonHeaderKey, 'You are blocked')
      ..close();
    return MiddlewareReturn(
      request: request,
      response: response,
      closed: true,
      closeReason: 'User is blocked',
    );
  }
}

// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/constants/widget_keys.dart';
import 'package:windows_app/providers/connect_phone_provider.dart';
import 'package:windows_app/providers/server_provider.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/utils/client_utils.dart' as client_utils;
import 'package:uuid/uuid.dart';

import 'constants.dart';
import 'socket_conn_model.dart';

class CustomServerSocket {
  final String myIp;
  late Stream<WebSocket> websocketServer;
  List<SocketConnModel> sockets = [];
  CustomServerSocket(
    this.myIp,
    ServerProvider serverProviderFalse,
    ShareProvider shareProviderFalse,
  ) {
    _transform(
      serverProviderFalse,
      shareProviderFalse,
    );
  }
  Completer<HttpServer> connLinkCompleter = Completer<HttpServer>();

  Future<void> sendCloseMsg() async {
    for (var socket in sockets) {
      try {
        _sendToClient(
          'server disconnected',
          serverDisconnected,
          socket.webSocket,
        );
      } catch (e) {
        logger.e(e.toString());
      }
    }
  }

  Future<HttpServer> getWsConnLink() async {
    return connLinkCompleter.future;
  }

  Future<void> _transform(
    ServerProvider serverProviderFalse,
    ShareProvider shareProviderFalse,
  ) async {
    var server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    websocketServer = server.transform(WebSocketTransformer());

    connLinkCompleter.complete(server);
    logger.w('ws server listening at ${server.port}');

    await for (var socket in websocketServer) {
      String si = Uuid().v4();
      print('Device Connected With si: $si');
      sockets.add(SocketConnModel(
        sessionID: si,
        webSocket: socket,
      ));
      _sendToClient(si, yourIDPath, socket);

      socket.listen(
        (event) {
          // here the server(host) will receive joining requests
          print('Message from client $si => $event');
        },
        onDone: () {
          logger.w('Device $si disconnected');
          var copiedSockets = [...sockets];
          for (var socket in copiedSockets) {
            if (socket.sessionID == si) {
              sockets.removeWhere((element) => element.sessionID == si);
              serverProviderFalse.peerLeft(si);
              client_utils.broadcastUnsubscribeClient(
                serverProviderFalse,
                shareProviderFalse,
                si,
              );
              continue;
            }

            // _sendToClient(si, disconnectedIDPath, socket.webSocket);
          }
          print('Remaining devices ${sockets.length}');
        },
      );
    }
  }

  void _sendToClient(String msg, String path, WebSocket socket) {
    socket.add('$path[||]$msg');
  }
}

//! this is for connection to a phone socket server
class ConnectPhoneServerSocket {
  final String myIp;
  late Stream<WebSocket> websocketServer;
  List<SocketConnModel> sockets = [];
  ConnectPhoneServerSocket(
    this.myIp,
    ConnectPhoneProvider connectPhoneProvider,
  ) {
    _transform(connectPhoneProvider);
  }
  Completer<HttpServer> connLinkCompleter = Completer<HttpServer>();

  Future<HttpServer> getWsConnLink() async {
    return connLinkCompleter.future;
  }

  Future<void> _transform(ConnectPhoneProvider connectPhoneProvider) async {
    var server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    websocketServer = server.transform(WebSocketTransformer());

    connLinkCompleter.complete(server);
    logger.w('phone ws server listening at ${server.port}');

    await for (var socket in websocketServer) {
      logger.i('New socket connected');

      socket.listen(
        (event) {
          // here the server(host) will receive joining requests
        },
        onDone: () {
          logger.w('phone disconnected');

          connectPhoneProvider.closeServer();
          if (navigatorKey.currentContext == null) return;
        },
      );
    }
  }
}

// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/constants/server_constants.dart';
import 'package:windows_app/constants/widget_keys.dart';
import 'package:windows_app/helpers/mouse_data/mouse_controller.dart';
import 'package:windows_app/providers/connect_phone_provider.dart';
import 'package:windows_app/providers/server_provider.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/utils/client_utils.dart' as client_utils;
import 'package:uuid/uuid.dart';
import 'package:windows_app/utils/general_utils.dart';

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
    logger.i('phone ws server listening at ${server.port}');

    await for (var socket in websocketServer) {
      MouseEventsHandler mouseEventsHandler = MouseEventsHandler();
      String id = Uuid().v4();
      logger.i('New socket connected');
      sockets.add(
        SocketConnModel(
          sessionID: id,
          webSocket: socket,
        ),
      );

      socket.listen(
        (event) {
          // here the server(host) will receive joining requests

          mouseEventsHandler.handleMouseReceiveEvents(event);
        },
        onDone: () async {
          logger.w('phone disconnected');
          fastSnackBar(msg: 'Phone disconnected');
          int index = sockets.indexWhere((element) => element.sessionID == id);
          await sockets[index].webSocket.close();
          sockets.removeAt(index);

          connectPhoneProvider.closeServer();
          if (navigatorKey.currentContext == null) return;
        },
      );
    }
  }

  Future<void> closeServer() async {
    for (var socket in sockets) {
      try {
        _sendToClient(
          'server disconnected',
          serverDisconnected,
          socket.webSocket,
        );
        await socket.webSocket.close();
      } catch (e) {
        logger.e(e.toString());
      }
    }
  }

  void _sendToClient(String msg, String path, WebSocket socket) {
    socket.add('$path[||]$msg');
  }
}

class MouseEventsHandler {
  bool sleeping = false;
  List<String> sleepingCommands = [];

  void handleMouseReceiveEvents(dynamic event) async {
    var data = event.toString().split('___');
    String path = data.first;
    String message = data.last;

    MouseController mouseController = MouseController();
    if (sleeping) {
      sleepingCommands.add(event);
      return;
    }
    if (path == moveCursorPath) {
      // move the cursor
      var positionData = message.split(',');
      int dx = double.parse(positionData.first).round();
      int dy = double.parse(positionData.last).round();
      mouseController.setCursorPositionDelta(dx, dy);
    } else if (path == mouseLeftClickedPath) {
      mouseController.leftMouseButtonDown();
      mouseController.leftMouseButtonUp();
    } else if (path == mouseRightClickedPath) {
      mouseController.rightMouseButtonDown();
      mouseController.rightMouseButtonUp();
    } else if (path == mouseLeftDownPath) {
      mouseController.leftMouseButtonDown();
    } else if (path == mouseLeftUpPath) {
      mouseController.leftMouseButtonUp();
    } else if (path == mouseEventClickDrag) {
      Future.delayed(Duration(milliseconds: 300)).then((value) {
        sleeping = false;
        for (var element in sleepingCommands) {
          handleMouseReceiveEvents(element);
        }
        sleepingCommands.clear();
      });

      logger.e('should wait here before any mouse events ');
      // i might sleep here and add a list of events that need to be done,
      // and after this sleep period i execute all events first
      // so i will add a variable bool sleeping = false
      // if android tells me to sleep i will sleep for about 200ms or less and will record all events
      // after sleeping period is done i will execute all sleeping commands
      sleeping = true;
    }
  }
}

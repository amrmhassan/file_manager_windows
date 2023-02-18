// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/utils/custom_router_system/custom_router_system.dart';
import 'package:windows_app/utils/errors_collection/custom_exception.dart';
import 'package:windows_app/utils/connect_to_phone_utils/connect_to_phone_router.dart';
import 'package:windows_app/utils/server_utils/ip_utils.dart';
import 'package:windows_app/utils/websocket_utils/custom_server_socket.dart';
import 'package:flutter/cupertino.dart';

//? when adding a new client the client can be added by any of the other clients and the adding client will send a broadcast to all other devices in the network about the new client
//? for example, adding a new client will be at /addclient and when the client is added in one of the connected devices that device will send a message to every other device in the network with /clientAdded with the new list of the clients in the network
//? including the new device which will add the clients list to his state to be used later

class ConnectPhoneProvider extends ChangeNotifier {
  String? myConnLink;
  late String myWSConnLink;
  int myPort = 0;
  String? myIp;
  String? remoteIP;
  int? remotePort;
  HttpServer? httpServer;
  late ConnectPhoneServerSocket customServerSocket;

  HttpServer? wsServer;

  void setMyWSConnLink(String s) {
    myWSConnLink = s;
    notifyListeners();
  }

  void connected(String myIp, String remoteIP, int remotePort) {
    _setMyIp(myIp);
    _setRemoteIp(remoteIP);
    _setRemotePort(remotePort);
    notifyListeners();
  }

  void _setRemotePort(int p) {
    remotePort = p;
  }

  void _setRemoteIp(String ip) {
    remoteIP = ip;
  }

  void _setMyIp(String ip) {
    myIp = ip;
  }

  void setMyServerSocket(ConnectPhoneServerSocket s) {
    customServerSocket = s;
    notifyListeners();
  }

  Future<void> closeWsServer() async {
    if (wsServer == null) return;
    logger.i('Closing phone ws Server');
    await wsServer?.close();
  }

  Future<void> openServer() async {
    try {
      await closeServer();
      var myPossibleIPs = (await getPossibleIpAddress())!;
      if (myPossibleIPs.isEmpty) {
        throw CustomException(e: 'You aren\'t connected to any network');
      }
      //? opening the server port and setting end points
      httpServer = await HttpServer.bind(InternetAddress.anyIPv4, myPort);

      //? when above code is success then set the needed stuff like port, other things
      myPort = httpServer!.port;

      myConnLink = connLinkQrFromIterable(myPossibleIPs, myPort);

      CustomRouterSystem customRouterSystem =
          addConnectToPhoneServerRouters(this);
      httpServer!.listen(customRouterSystem.pipeline);

      notifyListeners();
    } catch (e) {
      await closeServer();
      rethrow;
    }
  }

  //? to close the server
  Future closeServer() async {
    logger.i('Closing normal http server');
    await httpServer?.close();
    httpServer = null;
    myConnLink = null;
    myIp = null;
    myPort = 0;
    remotePort = null;
    remoteIP = null;
    await closeWsServer();
    notifyListeners();
  }

  //? to restart the server
  Future restartServer() async {
    await httpServer?.close();
    await openServer();
  }
}
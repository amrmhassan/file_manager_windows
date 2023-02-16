import 'package:windows_app/models/peer_model.dart';
import 'package:windows_app/providers/server_provider.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String getConnLink(String ip, int port, [bool sockets = false]) {
  return '${sockets ? 'ws' : 'http'}://$ip:$port';
}

String? getPeerConnLink(PeerModel? peerModel, String endPoint) {
  if (peerModel == null) return null;
  return '${getConnLink(peerModel.ip, peerModel.port)}$endPoint';
}

PeerModel me(BuildContext context) {
  var shareProvider = Provider.of<ShareProvider>(context, listen: false);
  var me =
      Provider.of<ServerProvider>(context, listen: false).me(shareProvider);
  return me;
}

//? this will handle the server broadcasting to every device in the room or just one device
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:windows_app/constants/server_constants.dart';
import 'package:windows_app/models/peer_model.dart';
import 'package:windows_app/providers/server_provider.dart';
import 'package:windows_app/providers/share_provider.dart';
import 'package:windows_app/utils/client_utils.dart';
import 'package:windows_app/utils/errors_collection/custom_exception.dart';

//? to broad cast that a new peer added then send all peers connected data
Future<void> peerAddedServerFeedBack(
  ServerProvider serverProviderFalse,
  ShareProvider shareProviderFalse,
) async {
  List<PeerModel> peers = [...serverProviderFalse.peers.reversed];
  for (var peer in peers) {
    try {
      //? to skip if the peer is me
      if (peer.deviceID == shareProviderFalse.myDeviceId) continue;
      String connLink = 'http://${peer.ip}:${peer.port}$clientAddedEndPoint';
      var jsonRequest = json.encode(
        serverProviderFalse.peers
            .map(
              (e) => e.toJSON(),
            )
            .toList(),
      );
      var encodedRequest = jsonRequest;
      await Dio().post(
        connLink,
        data: encodedRequest,
      );
    } catch (e, s) {
      serverProviderFalse.peerLeft(peer.sessionID);
      await broadcastUnsubscribeClient(
        serverProviderFalse,
        shareProviderFalse,
        peer.sessionID,
      );
      throw CustomException(
        e: e,
        s: s,
        rethrowError: true,
      );
    }
  }
}

import 'package:windows_app/models/peer_model.dart';

enum ShareSpaceVScreenDataType {
  filesExploring,
  shareSpace,
  listyExploring,
  recentlyViewed,
}

class ShareSpaceVScreenData {
  final PeerModel peerModel;
  final ShareSpaceVScreenDataType dataType;

  const ShareSpaceVScreenData({
    required this.peerModel,
    required this.dataType,
  });
}

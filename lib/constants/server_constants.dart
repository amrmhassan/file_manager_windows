//? end points
// other
const String dummyEndPoint = '/dummyendpointjustlikethemainone';

// files
const String getShareSpaceEndPoint = '/getShareSpace';
const String fileAddedToShareSpaceEndPoint = '/fileAddedToShareSpace';
const String fileRemovedFromShareSpaceEndPoint = '/fileRemovedFromShareSpace';
const String getFolderContentEndPointEndPoint = '/getFolderContentEndPoint';
const String streamAudioEndPoint = '/streamAudio';
const String streamVideoEndPoint = '/streamVideo';
const String downloadFileEndPoint = '/downloadFile';
const String wsServerConnLinkEndPoint = '/wsServerConnLink';
const String phoneWsServerConnLinkEndPoint = '/phoneWsServerConnLink';

// clients
const String addClientEndPoint = '/addClient';
const String clientAddedEndPoint = '/clientAdded';
const String clientLeftEndPoint = '/clientLeft';
const String getPeerImagePathEndPoint = '/getPeerImagePath';

// server checking
const String serverCheckEndPoint = '/serverCheckEndPoint';
const String getDiskNamesEndPoint = '/getDiskNamesEndPoint';

// connect laptop endpoints
const String getStorageEndPoint = '/getStorage';
const String getPhoneFolderContentEndPoint = '/getPhoneFolderContentEndPoint';
const String areYouAliveEndPoint = '/areYouAliveEndPoint';
const String getClipboardEndPoint = '/getClipboardEndPoint';
const String sendTextEndpoint = '/sendTextEndpoint';
const String getListyEndPoint = '/getListyEndPoint';
const String startDownloadFileEndPoint = '/startDownloadFileEndPoint';
const String getFolderContentRecursiveEndPoint =
    '/getFolderContentRecursiveEndPoint';
const String getLaptopDeviceIDEndPoint = '/getLaptopDeviceIDEndPoint';
const String getLaptopDeviceNameEndpoint = '/getLaptopDeviceNameEndpoint';
const String getAndroidNameEndPoint = '/getAndroidNameEndPoint';
const String getAndroidIDEndPoint = '/getAndroidIDEndPoint';

//? headers keys
const String folderPathHeaderKey = 'folderPathHeaderKey';
const String sessionIDHeaderKey = 'sessionIDHeaderKey';
const String filePathHeaderKey = 'filePathHeaderKey';
const String reqIntentPathHeaderKey = 'reqIntentPathHeaderKey';
const String deviceIDHeaderKey = 'deviceIDHeaderKey';
const String userNameHeaderKey = 'userNameHeaderKey';
const String serverRefuseReasonHeaderKey = 'serverRefuseReasonHeaderKey';
const String myConnLinkHeaderKey = 'myConnLinkHeaderKey';

// connect laptop headers
const String freeSpaceHeaderKey = 'freeSpaceHeaderKey';
const String totalSpaceHeaderKey = 'totalSpaceHeaderKey';
const String parentFolderPathHeaderKey = 'parentFolderPathHeaderKey';
const String myServerPortHeaderKey = 'myServerPortHeaderKey';
const String fileSizeHeaderKey = 'fileSizeHeaderKey';

//? socket server paths
const String moveCursorPath = 'moveCursorPath';
const String mouseRightClickedPath = 'mouseRightClickedPath';
const String mouseLeftClickedPath = 'mouseLeftClickedPath';
const String mouseLeftDownPath = 'mouseLeftDownPath';
const String mouseLeftUpPath = 'mouseLeftUpPath';
const String mouseEventClickDrag = 'mouseEventClickDrag';

//? end points

//? this is the endpoints of server 1(the share space server of phones)
class EndPoints {
// other
  static const String dummy = '/dummyendpointjustlikethemainone';

// files
  static const String getShareSpace = '/getShareSpace';
  static const String fileAddedToShareSpace = '/fileAddedToShareSpace';
  static const String fileRemovedFromShareSpace = '/fileRemovedFromShareSpace';
  static const String getFolderContentEndPoint = '/getFolderContentEndPoint';
  static const String streamAudio = '/streamAudio';
  static const String streamVideo = '/streamVideo';
  static const String downloadFile = '/downloadFile';
  static const String wsServerConnLink = '/wsServerConnLink';
  static const String phoneWsServerConnLink = '/phoneWsServerConnLink';

// clients
  static const String addClient = '/addClient';
  static const String clientAdded = '/clientAdded';
  static const String clientLeft = '/clientLeft';
  static const String getPeerImagePath = '/getPeerImagePath';

// server checking
  static const String serverCheck = '/serverCheckEndPoint';
  static const String getDiskNames = '/getDiskNamesEndPoint';

// connect laptop endpoints
  static const String getStorage = '/getStorage';
  static const String getPhoneFolderContent = '/getPhoneFolderContentEndPoint';
  static const String areYouAlive = '/areYouAliveEndPoint';
  static const String getClipboard = '/getClipboardEndPoint';
  static const String sendText = '/sendTextEndpoint';
  static const String getListy = '/getListyEndPoint';
  static const String startDownloadFile = '/startDownloadFileEndPoint';
  static const String getFullFolderContent =
      '/getFolderContentRecursiveEndPoint';
  static const String getLaptopDeviceID = '/getLaptopDeviceIDEndPoint';
  static const String getLaptopDeviceName = '/getLaptopDeviceNameEndpoint';
  static const String getAndroidName = '/getAndroidNameEndPoint';
  static const String getAndroidID = '/getAndroidIDEndPoint';

  // beacon server endpoints
  static const String getBeaconServerName = '/getBeaconServerName';
  static const String getBeaconServerConnLink = '/getBeaconServerConnLink';
  static const String getBeaconServerID = '/getBeaconServerID';
}

//? headers keys
class KHeaders {
  static const String folderPathHeaderKey = 'folderPathHeaderKey';
  static const String sessionIDHeaderKey = 'sessionIDHeaderKey';
  static const String filePathHeaderKey = 'filePathHeaderKey';
  static const String reqIntentPathHeaderKey = 'reqIntentPathHeaderKey';
  static const String deviceIDHeaderKey = 'deviceIDHeaderKey';
  static const String userNameHeaderKey = 'userNameHeaderKey';
  static const String serverRefuseReasonHeaderKey =
      'serverRefuseReasonHeaderKey';
  static const String myConnLinkHeaderKey = 'myConnLinkHeaderKey';

// connect laptop headers
  static const String freeSpaceHeaderKey = 'freeSpaceHeaderKey';
  static const String totalSpaceHeaderKey = 'totalSpaceHeaderKey';
  static const String parentFolderPathHeaderKey = 'parentFolderPathHeaderKey';
  static const String myServerPortHeaderKey = 'myServerPortHeaderKey';
  static const String fileSizeHeaderKey = 'fileSizeHeaderKey';
}

class SocketPaths {
//? socket server paths
  static const String moveCursorPath = 'moveCursorPath';
  static const String mouseRightClickedPath = 'mouseRightClickedPath';
  static const String mouseLeftClickedPath = 'mouseLeftClickedPath';
  static const String mouseLeftDownPath = 'mouseLeftDownPath';
  static const String mouseLeftUpPath = 'mouseLeftUpPath';
  static const String mouseEventClickDrag = 'mouseEventClickDrag';
}

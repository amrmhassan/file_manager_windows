import 'dart:ffi';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ffi/ffi.dart';
import 'package:windows_app/constants/global_constants.dart';

typedef GetComputerNameC = Int32 Function(
  Pointer<Utf16> lpBuffer,
  Pointer<Uint32> lpnSize,
);

typedef GetComputerNameDart = int Function(
  Pointer<Utf16> lpBuffer,
  Pointer<Uint32> lpnSize,
);

class WindowsInfoHelper {
  static Future<String> getDeviceName() async {
    var info = await DeviceInfoPlugin().windowsInfo;
    logger.e(info.computerName);
    return info.computerName;
  }
}

import 'package:firedart/firestore/firestore.dart';
import 'package:windows_app/utils/update_utils/version_mode.dart';

class UpdateHelper {
  static Future<List<VersionModel>?> getVersions() async {
    try {
      var map = await Firestore.instance.collection("laptop").get();
      var versions =
          map.map((element) => VersionModel.fromJSON(element.map)).toList();
      return versions;
    } catch (e) {
      return null;
    }
  }
}

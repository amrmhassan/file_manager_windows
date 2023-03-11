import 'package:windows_app/constants/models_constants.dart';
import 'package:windows_app/helpers/string_to_type.dart';
import 'package:windows_app/models/types.dart';

class CapturedEntityModel {
  final String path;
  final EntityType entityType;
  final int? size;

  const CapturedEntityModel(
    this.path,
    this.entityType,
    this.size,
  );

  @override
  String toString() {
    return '$entityType => $path';
  }

  static CapturedEntityModel fromJSON(Map<String, dynamic> jsonOBJ) {
    return CapturedEntityModel(
      jsonOBJ[pathString],
      stringToEnum(
        jsonOBJ[entityTypeString],
        EntityType.values,
      ),
      int.tryParse(jsonOBJ[sizeString]),
    );
  }

  Map<String, String> toJSON() {
    return {
      pathString: path,
      entityTypeString: entityType.name,
      sizeString: size.toString(),
    };
  }
}

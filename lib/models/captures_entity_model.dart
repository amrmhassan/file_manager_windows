import 'package:windows_app/models/types.dart';

class CapturedEntityModel {
  final String path;
  final EntityType entityType;

  const CapturedEntityModel(this.path, this.entityType);

  @override
  String toString() {
    return '$entityType => $path';
  }
}

import 'package:windows_app/utils/errors_collection/error_logger_model.dart';

class CustomLogger {
  static const String errorsDbName = 'errorsCollectionDbName.db';

  Future<void> addError(ErrorLoggerModel error) async {
    // await DBHelper.insert(errorsLoggerTableName, error.toJSON(), errorsDbName);
  }

  Future<List<ErrorLoggerModel>> loadAllErrors() async {
    // var data = await DBHelper.getData(errorsLoggerTableName, errorsDbName);
    return [].map((e) => ErrorLoggerModel.fromJSON(e)).toList();
  }

  Future<void> deleteAllErrors() async {
    // await DBHelper.deleteTable(errorsLoggerTableName, errorsDbName);
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/global_constants.dart';
import 'package:windows_app/utils/errors_collection/custom_logger.dart';
import 'package:windows_app/utils/errors_collection/error_logger_model.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

final CustomLogger customLogger = CustomLogger();

class CustomException implements Exception {
  StackTrace? s;
  Object e;
  bool rethrowError;

  CustomException({
    required this.e,
    this.s,
    this.rethrowError = false,
  }) {
    //? save the log
    ErrorLoggerModel error = ErrorLoggerModel(
      id: Uuid().v4(),
      error: e.toString(),
      stackTrace: s.toString(),
      date: DateTime.now(),
    );
    customLogger.addError(error).then((value) {
      //! i disabled the rethrow function temporary
      // if (rethrowError || kDebugMode) {
      //   printOnDebug(e);
      //   printOnDebug(s);
      //   throw Exception(e);
      // }
      if (kDebugMode) {
        logger.e(e);
      }
    });
  }
  @override
  String toString() {
    return e.toString().replaceAll('Exception: ', '');
  }
}

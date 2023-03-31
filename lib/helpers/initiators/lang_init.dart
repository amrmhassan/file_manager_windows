import 'package:windows_app/constants/shared_pref_constants.dart';
import 'package:windows_app/helpers/initiators/global_runtime_variables.dart';
import 'package:windows_app/helpers/shared_pref_helper.dart';
import 'package:flutter/material.dart';

Future<void> loadCurrentLang() async {
  String? loaded = await SharedPrefHelper.getString(languageKey);
  if (loaded == null) return;
  loadedCurrentLocale = Locale.fromSubtags(languageCode: loaded);
}

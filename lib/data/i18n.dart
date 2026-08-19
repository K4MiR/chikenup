import 'package:flutter/foundation.dart';
import 'storage.dart';
import 'strings.g.dart';

/// Sistema de idiomas — espelha o `STRINGS`/`t()` da versão web.
/// As strings vivem em strings.g.dart, gerado a partir do index.html.
class I18n {
  I18n._();

  static final ValueNotifier<String> lang = ValueNotifier<String>('pt');

  static String t(String key, [String? fallback]) {
    final table = kStrings[lang.value];
    final value = table?[key];
    if (value != null) return value;
    final pt = kStrings['pt']?[key];
    if (pt != null) return pt;
    return fallback ?? key;
  }

  static Future<void> setLang(String value) async {
    if (value != 'pt' && value != 'en') return;
    lang.value = value;
    if (Storage.isReady) await Storage.setLang(value);
  }

  static bool get isEn => lang.value == 'en';
}

import 'package:shared_preferences/shared_preferences.dart';

/// Persistência local (equivalente ao localStorage da versão web).
/// Um único ponto de acesso ao SharedPreferences, carregado uma vez no boot.
class Storage {
  Storage._();

  static late SharedPreferences _prefs;
  static bool _ready = false;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ready = true;
  }

  static bool get isReady => _ready;

  static int get cornBalance => _prefs.getInt('corn_balance') ?? 0;
  static Future<void> setCornBalance(int value) => _prefs.setInt('corn_balance', value);

  static int get highScore => _prefs.getInt('high_score') ?? 0;
  static Future<void> setHighScore(int value) => _prefs.setInt('high_score', value);

  static String get lang => _prefs.getString('lang') ?? 'pt';
  static Future<void> setLang(String value) => _prefs.setString('lang', value);

  static String get currentSkin => _prefs.getString('current_skin') ?? 'classic';
  static Future<void> setCurrentSkin(String value) => _prefs.setString('current_skin', value);

  static List<String> get unlockedSkins =>
      _prefs.getStringList('unlocked_skins') ?? ['classic'];
  static Future<void> setUnlockedSkins(List<String> value) =>
      _prefs.setStringList('unlocked_skins', value);
}

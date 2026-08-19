import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistência local (equivalente ao localStorage da versão web).
/// As chaves usam o mesmo nome da versão web quando possível, para facilitar
/// a comparação, mas este é um app novo — não há migração de dados do
/// Capacitor (o WebView antigo e o app Flutter não compartilham storage).
class Storage {
  Storage._();

  static late SharedPreferences _prefs;
  static bool _ready = false;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ready = true;
  }

  static bool get isReady => _ready;

  // ---- economia ----
  static int get cornBalance => _prefs.getInt('chickenup_corn') ?? 0;
  static Future<void> setCornBalance(int v) => _prefs.setInt('chickenup_corn', v);

  // ---- recordes ----
  static int get highScore => _prefs.getInt('chickenup_highscore') ?? 0;
  static Future<void> setHighScore(int v) => _prefs.setInt('chickenup_highscore', v);
  static int get highScoreFly => _prefs.getInt('chickenup_highscore_fly') ?? 0;
  static Future<void> setHighScoreFly(int v) => _prefs.setInt('chickenup_highscore_fly', v);

  // ---- idioma / preferências ----
  static String get lang => _prefs.getString('chickenup_lang') ?? 'pt';
  static Future<void> setLang(String v) => _prefs.setString('chickenup_lang', v);

  static String get difficulty => _prefs.getString('chickenup_difficulty') ?? 'normal';
  static Future<void> setDifficulty(String v) => _prefs.setString('chickenup_difficulty', v);

  static bool get musicMuted => _prefs.getBool('chickenup_musicmuted') ?? false;
  static Future<void> setMusicMuted(bool v) => _prefs.setBool('chickenup_musicmuted', v);
  static bool get sfxMuted => _prefs.getBool('chickenup_sfxmuted') ?? false;
  static Future<void> setSfxMuted(bool v) => _prefs.setBool('chickenup_sfxmuted', v);
  static bool get vibration => _prefs.getBool('chickenup_vibration') ?? true;
  static Future<void> setVibration(bool v) => _prefs.setBool('chickenup_vibration', v);

  // ---- itens equipados ----
  static String get currentSkin => _prefs.getString('chickenup_skin') ?? 'classic';
  static Future<void> setCurrentSkin(String v) => _prefs.setString('chickenup_skin', v);
  static String get currentHat => _prefs.getString('chickenup_hat') ?? 'none';
  static Future<void> setCurrentHat(String v) => _prefs.setString('chickenup_hat', v);
  static String get currentTrail => _prefs.getString('chickenup_trail') ?? 'paw';
  static Future<void> setCurrentTrail(String v) => _prefs.setString('chickenup_trail', v);

  // ---- itens desbloqueados ----
  static List<String> get unlockedSkins =>
      _prefs.getStringList('chickenup_unlocked_skins') ?? ['classic'];
  static Future<void> setUnlockedSkins(List<String> v) =>
      _prefs.setStringList('chickenup_unlocked_skins', v);

  static List<String> get unlockedHats =>
      _prefs.getStringList('chickenup_unlocked_hats') ?? ['none'];
  static Future<void> setUnlockedHats(List<String> v) =>
      _prefs.setStringList('chickenup_unlocked_hats', v);

  static List<String> get unlockedTrails =>
      _prefs.getStringList('chickenup_unlocked_trails') ?? ['paw'];
  static Future<void> setUnlockedTrails(List<String> v) =>
      _prefs.setStringList('chickenup_unlocked_trails', v);

  static List<String> get unlockedAchievements =>
      _prefs.getStringList('chickenup_achievements') ?? const [];
  static Future<void> setUnlockedAchievements(List<String> v) =>
      _prefs.setStringList('chickenup_achievements', v);

  // ---- perfil ----
  static String get nickname => _prefs.getString('chickenup_nickname') ?? '';
  static Future<void> setNickname(String v) => _prefs.setString('chickenup_nickname', v);

  // ---- estatísticas (mesmo formato da versão web, salvo como JSON) ----
  static Map<String, dynamic> get stats {
    final raw = _prefs.getString('chickenup_stats');
    if (raw == null) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static Future<void> setStats(Map<String, dynamic> v) =>
      _prefs.setString('chickenup_stats', jsonEncode(v));
}

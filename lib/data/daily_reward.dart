import 'package:shared_preferences/shared_preferences.dart';
import 'gameplay_defs.dart';

/// Recompensa diária + sorte do dia — mesma lógica da versão web
/// (sequência de 7 dias, reinicia se pular um dia).
class DailyReward {
  DailyReward._();

  static late SharedPreferences _prefs;
  static bool _ready = false;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ready = true;
  }

  static String _todayStr() {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static String _yesterdayStr() {
    final d = DateTime.now().subtract(const Duration(days: 1));
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static String get _lastClaim => _ready ? (_prefs.getString('chickenup_lastclaim') ?? '') : '';
  static int get _streakRaw => _ready ? (_prefs.getInt('chickenup_streak') ?? 0) : 0;

  static bool get claimedToday => _lastClaim == _todayStr();

  /// Sequência atual (1..7 no ciclo). Se o último resgate não foi hoje nem
  /// ontem, a sequência reinicia.
  static int syncStreak() {
    if (!_ready) return 1;
    final last = _lastClaim;
    var streak = _streakRaw;
    if (last.isEmpty) return streak > 0 ? streak : 1;
    if (last == _todayStr()) return streak > 0 ? streak : 1;
    if (last == _yesterdayStr()) return streak + 1;
    return 1; // pulou um dia — recomeça
  }

  static int get dayInCycle {
    final streak = syncStreak();
    return ((streak - 1) % kDailyRewards.length) + 1;
  }

  static int get todayReward => kDailyRewards[dayInCycle - 1];

  /// Resgata a recompensa do dia. Devolve quanto milho foi ganho
  /// (0 se já tinha resgatado hoje).
  static Future<int> claim() async {
    if (!_ready || claimedToday) return 0;
    final streak = syncStreak();
    final reward = kDailyRewards[((streak - 1) % kDailyRewards.length)];
    await _prefs.setString('chickenup_lastclaim', _todayStr());
    await _prefs.setInt('chickenup_streak', streak);
    return reward;
  }

  /// "Sorte do dia" — número estável por dia, derivado da data
  /// (na web era usado para a conquista 'lucky_day' e um texto no menu).
  static int get dailyLuck {
    final d = DateTime.now();
    final seed = d.year * 10000 + d.month * 100 + d.day;
    return 60 + (seed * 7919) % 41; // 60..100
  }
}

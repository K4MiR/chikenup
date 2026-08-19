import 'storage.dart';

/// Estatísticas do jogador — mesmo conjunto de campos da versão web,
/// serializado como JSON no SharedPreferences.
class GameStats {
  int gamesPlayed;
  int totalJumps;
  int cornLifetime;
  int eggsCollected;
  int bestScore;
  int bestSurvivalMs;
  int distanceTotal;
  int bestCombo;
  int mudDodges;
  int powerupsCollected;
  int obstaclesDestroyed;
  int totalPlayTimeMs;

  // modo Voo
  int flyGamesPlayed;
  int flyBestScore;
  int flyBestSurvivalMs;
  int flyCornLifetime;
  int flyDistanceTotal;
  int flyObstaclesAvoided;
  int flyObstaclesDestroyed;
  int flyTotalPlayTimeMs;

  GameStats({
    this.gamesPlayed = 0,
    this.totalJumps = 0,
    this.cornLifetime = 0,
    this.eggsCollected = 0,
    this.bestScore = 0,
    this.bestSurvivalMs = 0,
    this.distanceTotal = 0,
    this.bestCombo = 0,
    this.mudDodges = 0,
    this.powerupsCollected = 0,
    this.obstaclesDestroyed = 0,
    this.totalPlayTimeMs = 0,
    this.flyGamesPlayed = 0,
    this.flyBestScore = 0,
    this.flyBestSurvivalMs = 0,
    this.flyCornLifetime = 0,
    this.flyDistanceTotal = 0,
    this.flyObstaclesAvoided = 0,
    this.flyObstaclesDestroyed = 0,
    this.flyTotalPlayTimeMs = 0,
  });

  static GameStats load() {
    final m = Storage.stats;
    int g(String k) => (m[k] as num?)?.toInt() ?? 0;
    return GameStats(
      gamesPlayed: g('gamesPlayed'),
      totalJumps: g('totalJumps'),
      cornLifetime: g('cornLifetime'),
      eggsCollected: g('eggsCollected'),
      bestScore: g('bestScore'),
      bestSurvivalMs: g('bestSurvivalMs'),
      distanceTotal: g('distanceTotal'),
      bestCombo: g('bestCombo'),
      mudDodges: g('mudDodges'),
      powerupsCollected: g('powerupsCollected'),
      obstaclesDestroyed: g('obstaclesDestroyed'),
      totalPlayTimeMs: g('totalPlayTimeMs'),
      flyGamesPlayed: g('flyGamesPlayed'),
      flyBestScore: g('flyBestScore'),
      flyBestSurvivalMs: g('flyBestSurvivalMs'),
      flyCornLifetime: g('flyCornLifetime'),
      flyDistanceTotal: g('flyDistanceTotal'),
      flyObstaclesAvoided: g('flyObstaclesAvoided'),
      flyObstaclesDestroyed: g('flyObstaclesDestroyed'),
      flyTotalPlayTimeMs: g('flyTotalPlayTimeMs'),
    );
  }

  Map<String, dynamic> toMap() => {
        'gamesPlayed': gamesPlayed,
        'totalJumps': totalJumps,
        'cornLifetime': cornLifetime,
        'eggsCollected': eggsCollected,
        'bestScore': bestScore,
        'bestSurvivalMs': bestSurvivalMs,
        'distanceTotal': distanceTotal,
        'bestCombo': bestCombo,
        'mudDodges': mudDodges,
        'powerupsCollected': powerupsCollected,
        'obstaclesDestroyed': obstaclesDestroyed,
        'totalPlayTimeMs': totalPlayTimeMs,
        'flyGamesPlayed': flyGamesPlayed,
        'flyBestScore': flyBestScore,
        'flyBestSurvivalMs': flyBestSurvivalMs,
        'flyCornLifetime': flyCornLifetime,
        'flyDistanceTotal': flyDistanceTotal,
        'flyObstaclesAvoided': flyObstaclesAvoided,
        'flyObstaclesDestroyed': flyObstaclesDestroyed,
        'flyTotalPlayTimeMs': flyTotalPlayTimeMs,
      };

  Future<void> save() => Storage.setStats(toMap());
}

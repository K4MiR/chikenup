import 'achievements.dart';
import 'catalog.dart';
import 'item_defs.dart';
import 'stats.dart';
import 'storage.dart';

/// Verificação das conquistas — as mesmas condições da versão web
/// (o `check(s)` de cada item do ACHIEVEMENTS), traduzidas para Dart.
/// A chave é o id, idêntico ao da web, então a regra fica casada com o dado.
class AchievementEngine {
  AchievementEngine._();

  /// Sorte do dia (0-100) — usada pela conquista 'lucky_day'.
  static int dailyLuck = 50;

  static bool _check(String id, GameStats s) {
    final totalDist = s.distanceTotal + s.flyDistanceTotal;
    final totalPlay = s.totalPlayTimeMs + s.flyTotalPlayTimeMs;
    final bestSurvival =
        s.bestSurvivalMs > s.flyBestSurvivalMs ? s.bestSurvivalMs : s.flyBestSurvivalMs;
    final destroyed = s.obstaclesDestroyed + s.flyObstaclesDestroyed;
    final unlockedItems = Storage.unlockedSkins.length +
        Storage.unlockedHats.length +
        Storage.unlockedTrails.length;

    switch (id) {
      // ===== CORRIDA =====
      case 'first_run':
        return s.gamesPlayed >= 1;
      case 'jump_master':
        return s.totalJumps >= 100;
      case 'survivor':
        return s.bestSurvivalMs >= 180000;
      case 'five_k':
        return s.bestScore >= 5000;
      case 'farm_king':
        return s.bestScore >= 10000;
      case 'dry_foot':
        return s.mudDodges >= 20;
      case 'veteran':
        return s.gamesPlayed >= 100;
      case 'corredor':
        return s.gamesPlayed >= 10;
      case 'maratonista':
        return s.gamesPlayed >= 300;
      case 'score_1k':
        return s.bestScore >= 1000;
      case 'score_2500':
        return s.bestScore >= 2500;
      case 'score_25k':
        return s.bestScore >= 25000;
      case 'jump_1000':
        return s.totalJumps >= 1000;

      // ===== VOO =====
      case 'first_fly':
        return s.flyGamesPlayed >= 1;
      case 'fly_10':
        return s.flyGamesPlayed >= 10;
      case 'fly_50':
        return s.flyGamesPlayed >= 50;
      case 'fly_score_2000':
        return s.flyBestScore >= 2000;
      case 'fly_score_5000':
        return s.flyBestScore >= 5000;
      case 'fly_score_10000':
        return s.flyBestScore >= 10000;
      case 'fly_survival_2min':
        return s.flyBestSurvivalMs >= 120000;

      // ===== COLETA =====
      case 'corn_farmer':
        return s.cornLifetime >= 50;
      case 'first_corn':
        return s.cornLifetime >= 1;
      case 'corn_1000':
        return s.cornLifetime >= 1000;
      case 'corn_5000':
        return s.cornLifetime >= 5000;
      case 'corn_10000':
        return s.cornLifetime >= 10000;
      case 'fly_corn_500':
        return s.flyCornLifetime >= 500;

      // ===== POWER-UPS =====
      case 'first_powerup':
        return s.powerupsCollected >= 1;
      case 'powerup_50':
        return s.powerupsCollected >= 50;
      case 'powerup_200':
        return s.powerupsCollected >= 200;
      case 'first_destroy':
        return destroyed >= 1;
      case 'destroy_50':
        return destroyed >= 50;
      case 'destroy_200':
        return destroyed >= 200;

      // ===== DISTÂNCIA =====
      case 'dist_100m':
        return totalDist >= 1000;
      case 'dist_1km':
        return totalDist >= 10000;
      case 'dist_5km':
        return totalDist >= 50000;
      case 'dist_10km':
        return totalDist >= 100000;
      case 'dist_50km':
        return totalDist >= 500000;

      // ===== COMBO =====
      case 'combo_5':
        return s.bestCombo >= 5;
      case 'combo_10':
        return s.bestCombo >= 10;
      case 'combo_25':
        return s.bestCombo >= 25;
      case 'combo_50':
        return s.bestCombo >= 50;

      // ===== SOBREVIVÊNCIA =====
      case 'survival_30s':
        return bestSurvival >= 30000;
      case 'survival_1min':
        return bestSurvival >= 60000;
      case 'survival_2min':
        return bestSurvival >= 120000;
      case 'survival_5min':
        return bestSurvival >= 300000;

      // ===== LOJA =====
      case 'first_purchase':
        return unlockedItems > 3;
      case 'collector':
        return unlockedItems >= 10;
      case 'full_collection':
        return Storage.unlockedSkins.length >= Catalog.skinCount &&
            Storage.unlockedHats.length >= Catalog.hatCount &&
            Storage.unlockedTrails.length >= Catalog.trailCount;

      // ===== SEGREDOS =====
      case 'night_owl':
        final h = DateTime.now().hour;
        return h >= 0 && h < 4;
      case 'lucky_day':
        return dailyLuck >= 95;
      case 'insomniac':
        return totalPlay >= 3600000;
      case 'number_one_fan':
        return totalPlay >= 18000000;
      case 'hoarder':
        return s.powerupsCollected >= 500;
      case 'unstoppable':
        return (s.gamesPlayed + s.flyGamesPlayed) >= 1000;
      case 'duck_feet':
        return s.mudDodges >= 100;
      case 'eternal':
        return bestSurvival >= 600000;
      case 'perfectionist':
        return s.bestCombo >= 100;
    }
    return false;
  }

  /// Roda todas as verificações e devolve as conquistas recém-desbloqueadas
  /// (para o jogo mostrar o toast de cada uma).
  static Future<List<AchievementDef>> checkAll(GameStats stats) async {
    final unlocked = Storage.unlockedAchievements.toList();
    final justUnlocked = <AchievementDef>[];

    for (final a in kAchievements) {
      if (unlocked.contains(a.id)) continue;
      if (_check(a.id, stats)) {
        unlocked.add(a.id);
        justUnlocked.add(a);
      }
    }

    if (justUnlocked.isNotEmpty) {
      await Storage.setUnlockedAchievements(unlocked);
    }
    return justUnlocked;
  }
}

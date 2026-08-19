import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../data/achievement_engine.dart';
import '../data/catalog.dart';
import '../data/daily_reward.dart';
import '../data/difficulties.dart';
import '../data/gameplay_defs.dart';
import '../data/i18n.dart';
import '../data/stats.dart';
import '../data/storage.dart';
import 'components/corn_pickup.dart';
import 'components/obstacle.dart';
import 'components/player.dart';
import 'components/power_up.dart';
import 'effects/weather_layer.dart';

enum RunState { menu, modeSelect, playing, paused, gameOver }

enum GameMode { run, fly }

/// Aviso passageiro na tela (equivalente ao `queueToast()` da versão web).
class ToastMsg {
  final String text;
  final String emoji;
  ToastMsg(this.text, this.emoji);
}

/// Núcleo do jogo: modos Corrida e Voo, power-ups, clima, ciclo dia/noite,
/// cenários por pontuação, chefes e integração com conquistas/estatísticas.
class ChickenUpGame extends FlameGame with TapCallbacks {
  // ---- estado observável pela UI ----
  final ValueNotifier<RunState> runState = ValueNotifier(RunState.menu);
  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> cornThisRun = ValueNotifier(0);
  final ValueNotifier<int> cornBalance = ValueNotifier(0);
  final ValueNotifier<int> highScore = ValueNotifier(0);
  final ValueNotifier<int> highScoreFly = ValueNotifier(0);
  final ValueNotifier<ToastMsg?> toast = ValueNotifier(null);
  final ValueNotifier<List<ActiveEffect>> activeEffects = ValueNotifier(const []);

  GameMode mode = GameMode.run;

  late Player player;
  late double groundY;
  final WeatherLayer weather = WeatherLayer();

  double distance = 0;
  double gameSpeed = 260;
  double elapsedMs = 0;
  double _obstacleTimer = 0;
  double _cornTimer = 0;
  double _powerUpTimer = 0;
  double _weatherTimer = 8000;
  int _combo = 0;
  int _bestComboThisRun = 0;
  int _jumpsThisRun = 0;
  int _powerUpsThisRun = 0;
  double _toastTimer = 0;
  int _lastScenarioIndex = -1;
  int _lastDayPhase = -1;

  // efeitos temporários ativos (id -> ms restantes)
  final Map<String, double> _effects = {};

  final Random rng = Random();
  late GameStats stats;

  // ---- modificadores do laboratório ----
  bool labAlwaysNight = false;
  bool labAlwaysRain = false;
  bool labMoreItems = false;
  bool labGiantObstacles = false;
  double labSpeedMult = 1;
  double gravityMult = 1;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    stats = GameStats.load();
    cornBalance.value = Storage.cornBalance;
    highScore.value = Storage.highScore;
    highScoreFly.value = Storage.highScoreFly;
    AchievementEngine.dailyLuck = DailyReward.dailyLuck;
    groundY = size.y - 60;
    player = Player(
      groundY: groundY,
      skin: Catalog.skin(Storage.currentSkin),
      hat: Catalog.hat(Storage.currentHat),
    );
    player.position = Vector2(size.x * 0.22, groundY);
  }

  DifficultyDef get difficulty => difficultyById(Storage.difficulty);

  void _applyLabMods() {
    final mods = Storage.labMods;
    labAlwaysNight = mods.contains('alwaysNight');
    labAlwaysRain = mods.contains('alwaysRain');
    labMoreItems = mods.contains('moreItems');
    labGiantObstacles = mods.contains('giantObstacles');
    labSpeedMult = mods.contains('speed2x') ? 2.0 : 1.0;
    gravityMult = kGravityModes[Storage.gravityMode] ?? 1.0;
  }

  void startRun({GameMode? withMode}) {
    if (withMode != null) mode = withMode;
    _applyLabMods();

    children.whereType<Obstacle>().forEach((o) => o.removeFromParent());
    children.whereType<CornPickup>().forEach((c) => c.removeFromParent());
    children.whereType<PowerUpItem>().forEach((p) => p.removeFromParent());

    final d = difficulty;
    // as velocidades da web são por ms e calibradas p/ 390px de largura
    final scale = size.x / 390;
    gameSpeed = d.startSpeed * 1000 * scale * labSpeedMult;

    distance = 0;
    elapsedMs = 0;
    _obstacleTimer = 1.2;
    _cornTimer = 0.6;
    _powerUpTimer = 4.0;
    _weatherTimer = 8000;
    _combo = 0;
    _bestComboThisRun = 0;
    _jumpsThisRun = 0;
    _powerUpsThisRun = 0;
    _effects.clear();
    _lastScenarioIndex = -1;
    _lastDayPhase = -1;
    score.value = 0;
    cornThisRun.value = 0;

    weather.reset(labAlwaysRain ? WeatherType.rain : WeatherType.none, Size(size.x, size.y));

    player.mode = mode;
    player.gravityMult = gravityMult;
    player.position = Vector2(size.x * 0.22, mode == GameMode.fly ? size.y * 0.45 : groundY);
    player.velocityY = 0;
    player.onGround = mode == GameMode.run;
    player.skin = Catalog.skin(Storage.currentSkin);
    player.hat = Catalog.hat(Storage.currentHat);
    if (!contains(player)) add(player);

    if (Storage.labMods.isNotEmpty || Storage.gravityMode != 'normal') {
      showToast(I18n.t('labModsActiveToast'), '🧪');
    }

    runState.value = RunState.playing;
  }

  void showToast(String text, String emoji) {
    toast.value = ToastMsg(text, emoji);
    _toastTimer = 2200;
  }

  bool hasEffect(String id) => (_effects[id] ?? 0) > 0;

  void _collectPowerUp(PowerUpDef def) {
    _powerUpsThisRun++;
    if (def.durationMs > 0) {
      _effects[def.id] = def.durationMs.toDouble();
    }
    if (def.id == 'wing') {
      player.doubleJumpCharges += 1;
    }
    showToast(def.name, def.emoji);
    _syncEffects();
  }

  void _syncEffects() {
    activeEffects.value = _effects.entries
        .where((e) => e.value > 0)
        .map((e) {
          final def = kPowerUps.firstWhere((p) => p.id == e.key);
          return ActiveEffect(def: def, remainingMs: e.value);
        })
        .toList();
  }

  Future<void> endRun({bool quit = false}) async {
    if (runState.value == RunState.gameOver) return;
    // Ao sair pelo menu da pausa nao mostramos a tela de fim de jogo — mas o
    // milho e as estatisticas da corrida precisam ser salvos do mesmo jeito.
    if (!quit) runState.value = RunState.gameOver;

    final isFly = mode == GameMode.fly;
    final finalScore = score.value;

    // recordes
    if (isFly) {
      if (finalScore > highScoreFly.value) {
        highScoreFly.value = finalScore;
        await Storage.setHighScoreFly(finalScore);
      }
    } else {
      if (finalScore > highScore.value) {
        highScore.value = finalScore;
        await Storage.setHighScore(finalScore);
      }
    }

    // milho
    final newTotal = cornBalance.value + cornThisRun.value;
    cornBalance.value = newTotal;
    await Storage.setCornBalance(newTotal);

    // estatísticas
    if (isFly) {
      stats.flyGamesPlayed++;
      stats.flyBestScore = max(stats.flyBestScore, finalScore);
      stats.flyBestSurvivalMs = max(stats.flyBestSurvivalMs, elapsedMs.toInt());
      stats.flyCornLifetime += cornThisRun.value;
      stats.flyDistanceTotal += distance.toInt();
      stats.flyTotalPlayTimeMs += elapsedMs.toInt();
    } else {
      stats.gamesPlayed++;
      stats.bestScore = max(stats.bestScore, finalScore);
      stats.bestSurvivalMs = max(stats.bestSurvivalMs, elapsedMs.toInt());
      stats.cornLifetime += cornThisRun.value;
      stats.distanceTotal += distance.toInt();
      stats.totalPlayTimeMs += elapsedMs.toInt();
      stats.totalJumps += _jumpsThisRun;
    }
    stats.bestCombo = max(stats.bestCombo, _bestComboThisRun);
    stats.powerupsCollected += _powerUpsThisRun;
    await stats.save();

    // conquistas
    final unlocked = await AchievementEngine.checkAll(stats);
    if (unlocked.isNotEmpty) {
      final a = unlocked.first;
      showToast('${I18n.isEn ? "Achievement" : "Conquista"}: ${a.name}', a.emoji);
    }
  }

  void pause() {
    if (runState.value == RunState.playing) runState.value = RunState.paused;
  }

  void resume() {
    if (runState.value == RunState.paused) runState.value = RunState.playing;
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (runState.value != RunState.playing) return;
    if (mode == GameMode.fly) {
      player.flyHolding = true;
    } else {
      if (player.jump()) _jumpsThisRun++;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    player.releaseHold();
    player.flyHolding = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    player.releaseHold();
    player.flyHolding = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final dtMs = dt * 1000;

    // toast some sozinho
    if (_toastTimer > 0) {
      _toastTimer -= dtMs;
      if (_toastTimer <= 0) toast.value = null;
    }

    if (runState.value != RunState.playing) return;

    elapsedMs += dtMs;

    // efeitos temporários
    if (_effects.isNotEmpty) {
      var changed = false;
      for (final key in _effects.keys.toList()) {
        _effects[key] = _effects[key]! - dtMs;
        if (_effects[key]! <= 0) {
          _effects.remove(key);
          changed = true;
        }
      }
      if (changed) _syncEffects();
    }

    // velocidade e pontuação
    final d = difficulty;
    final scale = size.x / 390;
    final maxSpeed = d.maxSpeed * 1000 * scale * labSpeedMult;
    final turbo = hasEffect('turbo') ? 1.5 : 1.0;
    gameSpeed = min(maxSpeed, gameSpeed + d.ramp * 1000 * 1000 * scale * dt);
    final effSpeed = gameSpeed * turbo;
    distance += effSpeed * dt;
    final mult = hasEffect('multiplier') ? 2 : 1;
    score.value = (distance / 10).floor() * mult;

    // aviso de novo cenário
    final scenario = scenarioForScore(score.value);
    final scenarioIdx = kScenarios.indexOf(scenario);
    if (scenarioIdx != _lastScenarioIndex) {
      if (_lastScenarioIndex >= 0) {
        showToast('${I18n.t('welcomeToScenario')}${scenario.name}!', '🌄');
      }
      _lastScenarioIndex = scenarioIdx;
    }

    // aviso de fase do dia
    final phase = dayPhaseIndex(elapsedMs, forceNight: labAlwaysNight);
    if (phase != _lastDayPhase) {
      if (_lastDayPhase >= 0) showToast(kDayPhases[phase].name, '🌤️');
      _lastDayPhase = phase;
    }

    // clima
    _weatherTimer -= dtMs;
    if (_weatherTimer <= 0 && !labAlwaysRain) {
      _weatherTimer = 12000 + rng.nextDouble() * 10000;
      final picked = _pickWeather();
      weather.reset(picked, Size(size.x, size.y));
      if (picked != WeatherType.none) {
        final w = kWeathers.firstWhere((x) => x.type == picked);
        showToast(w.name, '🌧️');
      }
    }
    weather.update(dtMs, Size(size.x, size.y));

    // spawn de obstáculos
    _obstacleTimer -= dt;
    if (_obstacleTimer <= 0) {
      final gap = max(0.72, (1.6 - effSpeed / 900)) * d.spawnMult;
      _obstacleTimer = gap + rng.nextDouble() * 0.35;
      if (mode == GameMode.fly) {
        _spawnFlyObstaclePair(effSpeed);
      } else {
        add(Obstacle(
          position: Vector2(size.x + 20, groundY),
          speed: effSpeed,
          giant: labGiantObstacles,
        ));
      }
    }

    // spawn de milho
    _cornTimer -= dt;
    if (_cornTimer <= 0) {
      _cornTimer = (0.85 + rng.nextDouble() * 0.6) * (labMoreItems ? 0.5 : 1.0);
      final h = mode == GameMode.fly
          ? size.y * 0.2 + rng.nextDouble() * size.y * 0.55
          : groundY - 40 - rng.nextDouble() * 90;
      add(CornPickup(position: Vector2(size.x + 20, h), speed: effSpeed));
    }

    // spawn de power-up
    _powerUpTimer -= dt;
    if (_powerUpTimer <= 0) {
      _powerUpTimer = (6.0 + rng.nextDouble() * 5.0) * (labMoreItems ? 0.5 : 1.0);
      final def = _pickPowerUp();
      final h = mode == GameMode.fly
          ? size.y * 0.25 + rng.nextDouble() * size.y * 0.5
          : groundY - 55 - rng.nextDouble() * 70;
      add(PowerUpItem(position: Vector2(size.x + 20, h), def: def, speed: effSpeed));
    }

    _handleCollisions();
  }

  void _spawnFlyObstaclePair(double speed) {
    // par de obstáculos com um vão no meio (estilo "cano")
    final gapH = size.y * 0.30;
    final gapCenter = size.y * 0.25 + rng.nextDouble() * size.y * 0.45;
    add(Obstacle(
      position: Vector2(size.x + 20, gapCenter - gapH / 2),
      speed: speed,
      fromTop: true,
      customHeight: gapCenter - gapH / 2,
    ));
    add(Obstacle(
      position: Vector2(size.x + 20, size.y),
      speed: speed,
      customHeight: size.y - (gapCenter + gapH / 2),
    ));
  }

  WeatherType _pickWeather() {
    final total = kWeathers.fold<int>(0, (a, w) => a + w.weight);
    var r = rng.nextDouble() * total;
    for (final w in kWeathers) {
      r -= w.weight;
      if (r <= 0) return w.type;
    }
    return WeatherType.none;
  }

  PowerUpDef _pickPowerUp() {
    final total = kPowerUps.fold<int>(0, (a, p) => a + p.spawnWeight);
    var r = rng.nextDouble() * total;
    for (final p in kPowerUps) {
      r -= p.spawnWeight;
      if (r <= 0) return p;
    }
    return kPowerUps.first;
  }

  void _handleCollisions() {
    final playerRect = player.hitbox;
    final invincible = hasEffect('egg') || hasEffect('tractor');
    final demolisher = hasEffect('demolisher');

    for (final o in children.whereType<Obstacle>().toList()) {
      if (!playerRect.overlaps(o.hitbox)) continue;
      if (invincible || demolisher) {
        o.removeFromParent();
        if (demolisher) {
          if (mode == GameMode.fly) {
            stats.flyObstaclesDestroyed++;
          } else {
            stats.obstaclesDestroyed++;
          }
        }
        continue;
      }
      if (hasEffect('shield')) {
        _effects.remove('shield');
        _syncEffects();
        o.removeFromParent();
        showToast(I18n.t('shieldAbsorbedToast'), '🛡️');
        continue;
      }
      endRun();
      return;
    }

    // milho (com ímã puxando)
    final magnet = hasEffect('magnet');
    for (final c in children.whereType<CornPickup>().toList()) {
      if (magnet) {
        final dx = player.position.x - c.position.x;
        final dy = (player.position.y - player.size.y / 2) - c.position.y;
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < kMagnetRadius) {
          c.position.x += dx * 0.12;
          c.position.y += dy * 0.12;
        }
      }
      if (!c.collected && playerRect.overlaps(c.hitbox)) {
        c.collected = true;
        c.removeFromParent();
        cornThisRun.value += 1;
        _combo++;
        _bestComboThisRun = max(_bestComboThisRun, _combo);
      }
    }

    for (final p in children.whereType<PowerUpItem>().toList()) {
      if (!p.collected && playerRect.overlaps(p.hitbox)) {
        p.collected = true;
        p.removeFromParent();
        _collectPowerUp(p.def);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final scenario = scenarioForScore(score.value);
    final canvasSize = Size(size.x, size.y);

    // céu (gradiente do cenário)
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [scenario.skyTop, scenario.skyBottom],
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), skyPaint);

    // estrelas (cenário espacial)
    if (scenario.stars) {
      final starPaint = Paint()..color = Colors.white.withOpacity(0.85);
      for (var i = 0; i < 40; i++) {
        final x = (i * 97 % size.x.toInt()).toDouble();
        final y = (i * 53 % (size.y * 0.6).toInt()).toDouble();
        canvas.drawCircle(Offset(x, y), i.isEven ? 1.2 : 1.8, starPaint);
      }
    }

    // chão (só no modo corrida)
    if (mode == GameMode.run) {
      canvas.drawRect(
        Rect.fromLTWH(0, groundY, size.x, size.y - groundY),
        Paint()..color = scenario.grass,
      );
      canvas.drawRect(
        Rect.fromLTWH(0, groundY + 18, size.x, size.y - groundY - 18),
        Paint()..color = scenario.ground,
      );
    }

    super.render(canvas);

    // clima por cima dos componentes
    weather.render(canvas, canvasSize, groundY);

    // overlay da fase do dia
    final overlay = dayPhaseOverlay(elapsedMs, forceNight: labAlwaysNight);
    if (overlay.alpha > 0) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), Paint()..color = overlay);
    }
  }
}

/// Efeito ativo, exposto pra HUD desenhar a barrinha de duração.
class ActiveEffect {
  final PowerUpDef def;
  final double remainingMs;
  const ActiveEffect({required this.def, required this.remainingMs});

  double get progress => def.durationMs == 0 ? 0 : (remainingMs / def.durationMs).clamp(0.0, 1.0);
}

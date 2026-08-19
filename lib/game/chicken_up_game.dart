import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../data/skins.dart';
import '../data/storage.dart';
import 'components/corn_pickup.dart';
import 'components/obstacle.dart';
import 'components/player.dart';

enum RunState { menu, playing, gameOver }

/// Núcleo do jogo (modo Corrida). Física, spawn de obstáculos/milho,
/// pontuação e progressão de dificuldade — o equivalente Dart do loop
/// principal da versão web (`update()`/`draw()` do Canvas).
class ChickenUpGame extends FlameGame with TapCallbacks {
  final ValueNotifier<RunState> runState = ValueNotifier(RunState.menu);
  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> cornThisRun = ValueNotifier(0);
  final ValueNotifier<int> cornBalance = ValueNotifier(Storage.cornBalance);
  final ValueNotifier<int> highScore = ValueNotifier(Storage.highScore);

  late Player player;
  late double groundY;
  double distance = 0;
  double gameSpeed = 260;
  static const double maxSpeed = 620;
  static const double speedRamp = 6;

  double obstacleTimer = 0;
  double cornTimer = 0;
  final Random rng = Random();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    groundY = size.y - 60;
    player = Player(groundY: groundY, skin: skinById(Storage.currentSkin));
    player.position = Vector2(size.x * 0.22, groundY);
  }

  void startRun() {
    children.whereType<Obstacle>().forEach((o) => o.removeFromParent());
    children.whereType<CornPickup>().forEach((c) => c.removeFromParent());
    distance = 0;
    gameSpeed = 260;
    obstacleTimer = 1.2;
    cornTimer = 0.6;
    score.value = 0;
    cornThisRun.value = 0;
    player.position = Vector2(size.x * 0.22, groundY);
    player.velocityY = 0;
    player.onGround = true;
    player.skin = skinById(Storage.currentSkin);
    if (!contains(player)) add(player);
    runState.value = RunState.playing;
  }

  Future<void> endRun() async {
    runState.value = RunState.gameOver;
    if (score.value > highScore.value) {
      highScore.value = score.value;
      await Storage.setHighScore(score.value);
    }
    final newTotal = cornBalance.value + cornThisRun.value;
    cornBalance.value = newTotal;
    await Storage.setCornBalance(newTotal);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (runState.value == RunState.playing) player.jump();
  }

  @override
  void onTapUp(TapUpEvent event) {
    player.releaseHold();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    player.releaseHold();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (runState.value != RunState.playing) return;

    gameSpeed = min(maxSpeed, gameSpeed + speedRamp * dt);
    distance += gameSpeed * dt;
    score.value = (distance / 10).floor();

    obstacleTimer -= dt;
    if (obstacleTimer <= 0) {
      final gap = max(0.75, 1.6 - gameSpeed / 900);
      obstacleTimer = gap + rng.nextDouble() * 0.4;
      add(Obstacle(position: Vector2(size.x + 20, groundY), speed: gameSpeed));
    }

    cornTimer -= dt;
    if (cornTimer <= 0) {
      cornTimer = 0.9 + rng.nextDouble() * 0.6;
      final h = groundY - 40 - rng.nextDouble() * 90;
      add(CornPickup(position: Vector2(size.x + 20, h), speed: gameSpeed));
    }

    final playerRect = player.hitbox;
    for (final obstacle in children.whereType<Obstacle>().toList()) {
      if (playerRect.overlaps(obstacle.hitbox)) {
        endRun();
        return;
      }
    }
    for (final corn in children.whereType<CornPickup>().toList()) {
      if (!corn.collected && playerRect.overlaps(corn.hitbox)) {
        corn.collected = true;
        corn.removeFromParent();
        cornThisRun.value += 1;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final skyPaint = Paint()..color = const Color(0xFF8FB8F5);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), skyPaint);
    final groundPaint = Paint()..color = const Color(0xFF6FB54A);
    canvas.drawRect(Rect.fromLTWH(0, groundY, size.x, size.y - groundY), groundPaint);
    final dirtPaint = Paint()..color = const Color(0xFF8A5A34);
    canvas.drawRect(Rect.fromLTWH(0, groundY + 18, size.x, size.y - groundY - 18), dirtPaint);
    super.render(canvas);
  }
}

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../data/gameplay_defs.dart';
import '../../data/item_defs.dart';
import '../chicken_up_game.dart';

/// A galinha jogável. Física portada da versão web:
/// - Corrida: gravidade constante, impulso ao tocar, pulo mais alto se segurar,
///   e pulo duplo quando tem carga do power-up "Asas".
/// - Voo: sobe enquanto segura, cai quando solta, com resistência do ar e
///   limite de velocidade vertical (as constantes de FlyPhysics).
class Player extends PositionComponent {
  static const double gravity = 1900;
  static const double jumpImpulse = -650;
  static const double holdBoost = -900;
  static const double maxHoldTime = 0.18;

  double velocityY = 0;
  bool onGround = true;
  bool holding = false;
  bool flyHolding = false;
  double holdTime = 0;
  int doubleJumpCharges = 0;
  double gravityMult = 1;
  GameMode mode = GameMode.run;

  SkinDef skin;
  HatDef? hat;
  final double groundY;

  double _runCycle = 0;
  double _wingFlap = 0;

  Player({required this.groundY, required this.skin, this.hat})
      : super(size: Vector2(46, 46), anchor: Anchor.bottomCenter);

  /// Retorna true se realmente pulou (para contar nas estatísticas).
  bool jump() {
    if (onGround) {
      velocityY = jumpImpulse;
      onGround = false;
      holding = true;
      holdTime = 0;
      return true;
    }
    if (doubleJumpCharges > 0) {
      doubleJumpCharges--;
      velocityY = jumpImpulse * 0.9;
      holding = true;
      holdTime = 0;
      return true;
    }
    return false;
  }

  void releaseHold() => holding = false;

  @override
  void update(double dt) {
    super.update(dt);
    final dtMs = dt * 1000;

    if (mode == GameMode.fly) {
      _updateFly(dtMs);
    } else {
      _updateRun(dt);
    }
  }

  void _updateRun(double dt) {
    if (holding && holdTime < maxHoldTime && velocityY < 0) {
      velocityY += holdBoost * dt * 0.5;
      holdTime += dt;
    }
    velocityY += gravity * gravityMult * dt;
    position.y += velocityY * dt;
    if (position.y >= groundY) {
      position.y = groundY;
      velocityY = 0;
      onGround = true;
      holding = false;
    }
    if (onGround) _runCycle += dt * 12;
  }

  void _updateFly(double dtMs) {
    // as constantes da web estão em px/ms
    if (flyHolding) {
      velocityY -= FlyPhysics.lift * dtMs;
      _wingFlap += dtMs * 0.02;
    } else {
      velocityY += FlyPhysics.gravity * gravityMult * dtMs;
    }
    // resistência do ar suaviza a curva
    velocityY -= velocityY * FlyPhysics.airResistance * dtMs;
    velocityY = velocityY.clamp(-FlyPhysics.maxVSpeed, FlyPhysics.maxVSpeed);
    position.y += velocityY * dtMs;

    // limites da tela com resistência suave
    if (position.y < size.y + FlyPhysics.boundsPad) {
      position.y = size.y + FlyPhysics.boundsPad;
      if (velocityY < 0) velocityY = 0;
    }
    final maxY = groundY + 60;
    if (position.y > maxY) {
      position.y = maxY;
      if (velocityY > 0) velocityY = 0;
    }
    _wingFlap += dtMs * 0.008;
  }

  Rect get hitbox => Rect.fromLTWH(
        position.x - size.x / 2 + 6,
        position.y - size.y + 6,
        size.x - 12,
        size.y - 10,
      );

  @override
  void render(Canvas canvas) {
    final w = size.x, h = size.y;
    final legPaint = Paint()
      ..color = skin.leg
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    final bodyPaint = Paint()..color = skin.body;
    final tailAPaint = Paint()..color = skin.tailA;
    final tailBPaint = Paint()..color = skin.tailB;
    final combPaint = Paint()..color = skin.comb;
    final beakPaint = Paint()..color = skin.beak;

    // pernas
    final swing = (mode == GameMode.run && onGround)
        ? (0.18 * (0.5 - (_runCycle % 1)))
        : 0.12; // recolhidas no ar
    for (final side in [-1.0, 1.0]) {
      final lx = w * 0.42 + side * w * 0.12;
      canvas.drawLine(Offset(lx, -h * 0.18), Offset(lx + side * swing * w, 0), legPaint);
    }

    // cauda
    final tailA = Path()
      ..moveTo(w * 0.05, -h * 0.55)
      ..lineTo(-w * 0.26, -h * 0.86)
      ..lineTo(w * 0.06, -h * 0.34)
      ..close();
    canvas.drawPath(tailA, tailAPaint);
    final tailB = Path()
      ..moveTo(w * 0.05, -h * 0.5)
      ..lineTo(-w * 0.16, -h * 0.72)
      ..lineTo(w * 0.06, -h * 0.32)
      ..close();
    canvas.drawPath(tailB, tailBPaint);

    // corpo
    canvas.drawOval(Rect.fromLTWH(0, -h * 0.92, w * 0.8, h * 0.82), bodyPaint);

    // asa (bate no modo voo)
    if (mode == GameMode.fly) {
      final flap = (_wingFlap % 1) * 2 - 1;
      final wing = Path()
        ..moveTo(w * 0.25, -h * 0.62)
        ..quadraticBezierTo(w * 0.42, -h * (0.62 + 0.28 * flap.abs()), w * 0.58, -h * 0.55)
        ..quadraticBezierTo(w * 0.42, -h * 0.44, w * 0.25, -h * 0.62)
        ..close();
      canvas.drawPath(wing, Paint()..color = skin.tailA);
    }

    // crista
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(w * (0.34 + i * 0.09), -h * 0.94), 4.2, combPaint);
    }

    // bico
    final beak = Path()
      ..moveTo(w * 0.70, -h * 0.66)
      ..lineTo(w * 0.95, -h * 0.58)
      ..lineTo(w * 0.70, -h * 0.50)
      ..close();
    canvas.drawPath(beak, beakPaint);

    // olho
    canvas.drawCircle(Offset(w * 0.56, -h * 0.72), 2.4, Paint()..color = const Color(0xFF2B2B2B));

    // chapéu
    final hatDef = hat;
    if (hatDef != null && hatDef.id != 'none' && hatDef.emoji.isNotEmpty) {
      final tp = TextPainter(
        text: TextSpan(text: hatDef.emoji, style: TextStyle(fontSize: w * 0.5)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(w * 0.42 - tp.width / 2, -h * 1.28));
    }
  }
}

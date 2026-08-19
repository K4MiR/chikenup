import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../data/item_defs.dart';

/// A galinha jogável. Física de pulo portada da versão web: gravidade
/// constante, impulso ao tocar e um pulo mais alto se o toque for segurado
/// ("toque e segure para pular mais alto").
class Player extends PositionComponent {
  static const double gravity = 1900;
  static const double jumpImpulse = -650;
  static const double holdBoost = -900;
  static const double maxHoldTime = 0.18;

  double velocityY = 0;
  bool onGround = true;
  bool holding = false;
  double holdTime = 0;

  SkinDef skin;
  HatDef? hat;
  final double groundY;

  /// Ângulo de balanço das pernas, só pra dar vida quando está correndo.
  double _runCycle = 0;

  Player({required this.groundY, required this.skin, this.hat})
      : super(size: Vector2(46, 46), anchor: Anchor.bottomCenter);

  void jump() {
    if (!onGround) return;
    velocityY = jumpImpulse;
    onGround = false;
    holding = true;
    holdTime = 0;
  }

  void releaseHold() => holding = false;

  @override
  void update(double dt) {
    super.update(dt);
    if (holding && holdTime < maxHoldTime && velocityY < 0) {
      velocityY += holdBoost * dt * 0.5;
      holdTime += dt;
    }
    velocityY += gravity * dt;
    position.y += velocityY * dt;
    if (position.y >= groundY) {
      position.y = groundY;
      velocityY = 0;
      onGround = true;
      holding = false;
    }
    if (onGround) _runCycle += dt * 12;
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
    final legPaint = Paint()..color = skin.leg;
    final bodyPaint = Paint()..color = skin.body;
    final tailAPaint = Paint()..color = skin.tailA;
    final tailBPaint = Paint()..color = skin.tailB;
    final combPaint = Paint()..color = skin.comb;
    final beakPaint = Paint()..color = skin.beak;

    // pernas (balançam enquanto corre)
    final swing = onGround ? (0.18 * (0.5 - (_runCycle % 1))) : 0.0;
    canvas.save();
    for (final side in [-1.0, 1.0]) {
      final lx = w * 0.42 + side * w * 0.12;
      canvas.drawLine(
        Offset(lx, -h * 0.18),
        Offset(lx + side * swing * w, 0),
        legPaint..strokeWidth = 3.5..strokeCap = StrokeCap.round,
      );
    }
    canvas.restore();

    // cauda (duas penas sobrepostas)
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

    // chapéu (emoji desenhado por cima, igual a versão web faz no canvas)
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

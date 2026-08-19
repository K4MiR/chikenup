import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../data/skins.dart';

/// A galinha jogável. Física simples de pulo: gravidade constante, impulso
/// ao tocar, e um pulo um pouco mais alto se o toque for segurado (mesma
/// sensação do "toque e segure para pular mais alto" da versão web).
class Player extends PositionComponent {
  static const double gravity = 1900;
  static const double jumpImpulse = -650;
  static const double holdBoost = -900; // aplicado enquanto segura, com teto

  double velocityY = 0;
  bool onGround = true;
  bool holding = false;
  double holdTime = 0;
  static const double maxHoldTime = 0.18;

  SkinDef skin;
  final double groundY;

  Player({required this.groundY, required this.skin})
      : super(size: Vector2(46, 46), anchor: Anchor.bottomCenter);

  void jump() {
    if (!onGround) return;
    velocityY = jumpImpulse;
    onGround = false;
    holding = true;
    holdTime = 0;
  }

  void releaseHold() {
    holding = false;
  }

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
  }

  Rect get hitbox => Rect.fromLTWH(
        position.x - size.x / 2 + 6,
        position.y - size.y + 6,
        size.x - 12,
        size.y - 10,
      );

  @override
  void render(Canvas canvas) {
    final bodyPaint = Paint()..color = skin.body;
    final tailPaint = Paint()..color = skin.tail;
    final combPaint = Paint()..color = skin.comb;
    final beakPaint = Paint()..color = const Color(0xFFF2A13A);

    final bodyRect = Rect.fromLTWH(0, -size.y, size.x * 0.8, size.y);
    canvas.drawOval(bodyRect, bodyPaint);

    final tailPath = Path()
      ..moveTo(0, -size.y * 0.55)
      ..lineTo(-size.x * 0.3, -size.y * 0.8)
      ..lineTo(0, -size.y * 0.35)
      ..close();
    canvas.drawPath(tailPath, tailPaint);

    canvas.drawCircle(Offset(size.x * 0.42, -size.y * 0.92), 5, combPaint);

    final beakPath = Path()
      ..moveTo(size.x * 0.72, -size.y * 0.68)
      ..lineTo(size.x * 0.95, -size.y * 0.6)
      ..lineTo(size.x * 0.72, -size.y * 0.52)
      ..close();
    canvas.drawPath(beakPath, beakPaint);

    canvas.drawCircle(Offset(size.x * 0.58, -size.y * 0.75), 2.2, Paint()..color = const Color(0xFF2B2B2B));
  }
}

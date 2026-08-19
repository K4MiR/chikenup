import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Milho colecionável — cada um coletado soma 1 ao saldo de milho do jogador.
class CornPickup extends PositionComponent {
  double speed;
  bool collected = false;

  CornPickup({required Vector2 position, required this.speed})
      : super(position: position, size: Vector2(20, 20), anchor: Anchor.center);

  Rect get hitbox => Rect.fromCircle(center: const Offset(0, 0), radius: size.x / 2).shift(Offset(position.x, position.y));

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;
    if (position.x < -20) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFFFFC83D);
    canvas.drawCircle(Offset.zero, size.x / 2, paint);
    final strokePaint = Paint()
      ..color = const Color(0xFFC4890F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset.zero, size.x / 2, strokePaint);
  }
}

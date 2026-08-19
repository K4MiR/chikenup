import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Obstáculo simples (toco de madeira). Nasce fora da tela à direita e
/// anda para a esquerda na velocidade atual do jogo.
class Obstacle extends PositionComponent {
  double speed;

  Obstacle({required Vector2 position, required this.speed})
      : super(position: position, size: Vector2(30, 44), anchor: Anchor.bottomLeft);

  Rect get hitbox => Rect.fromLTWH(position.x + 4, position.y - size.y + 4, size.x - 8, size.y - 6);

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;
    if (position.x < -size.x - 10) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF7A5230);
    final rect = Rect.fromLTWH(0, -size.y, size.x, size.y);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), paint);
    final ringPaint = Paint()
      ..color = const Color(0xFF5C3D22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var i = 1; i < 3; i++) {
      canvas.drawRect(rect.deflate(i * 6.0), ringPaint);
    }
  }
}

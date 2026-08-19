import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Obstáculo. No modo Corrida é um toco no chão; no modo Voo são as colunas
/// (de cima e de baixo) que formam o vão por onde a galinha passa.
class Obstacle extends PositionComponent {
  double speed;
  final bool giant;
  final bool fromTop;
  final double? customHeight;

  Obstacle({
    required Vector2 position,
    required this.speed,
    this.giant = false,
    this.fromTop = false,
    this.customHeight,
  }) : super(
          position: position,
          size: Vector2(30, customHeight ?? (giant ? 66 : 44)),
          anchor: fromTop ? Anchor.bottomLeft : Anchor.bottomLeft,
        ) {
    if (giant && customHeight == null) size.x = 38;
  }

  Rect get hitbox => Rect.fromLTWH(
        position.x + 4,
        position.y - size.y + 4,
        size.x - 8,
        size.y - 6,
      );

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;
    if (position.x < -size.x - 20) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, -size.y, size.x, size.y);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      Paint()..color = const Color(0xFF7A5230),
    );
    // anéis da madeira
    final ringPaint = Paint()
      ..color = const Color(0xFF5C3D22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final rings = (size.y / 22).clamp(1, 5).toInt();
    for (var i = 1; i <= rings; i++) {
      final inset = i * 6.0;
      if (inset * 2 >= size.x || inset * 2 >= size.y) break;
      canvas.drawRect(rect.deflate(inset), ringPaint);
    }
  }
}

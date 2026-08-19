import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../data/gameplay_defs.dart';
import '../../data/item_defs.dart';

/// Item de power-up flutuante. Desenha o emoji do item dentro de uma
/// "bolha" com a cor da raridade, como na versão web.
class PowerUpItem extends PositionComponent {
  final PowerUpDef def;
  double speed;
  bool collected = false;
  double _bob = 0;

  PowerUpItem({required Vector2 position, required this.def, required this.speed})
      : super(position: position, size: Vector2(30, 30), anchor: Anchor.center);

  Rect get hitbox => Rect.fromCenter(
        center: Offset(position.x, position.y),
        width: size.x,
        height: size.y,
      );

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;
    _bob += dt * 3;
    if (position.x < -40) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final rarity = rarityOf(def.rarity);
    final float = (_bob.remainder(6.283)).abs();
    final dy = -3 * (0.5 - (float / 6.283));

    canvas.save();
    canvas.translate(0, dy);

    // halo da raridade
    canvas.drawCircle(Offset.zero, size.x * 0.62, Paint()..color = rarity.color.withOpacity(0.28));
    canvas.drawCircle(Offset.zero, size.x * 0.5, Paint()..color = const Color(0xFFF7EAD0));
    canvas.drawCircle(
      Offset.zero,
      size.x * 0.5,
      Paint()
        ..color = rarity.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    final tp = TextPainter(
      text: TextSpan(text: def.emoji, style: TextStyle(fontSize: size.x * 0.62)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));

    canvas.restore();
  }
}

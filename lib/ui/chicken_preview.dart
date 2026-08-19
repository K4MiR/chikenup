import 'package:flutter/material.dart';
import '../data/item_defs.dart';

/// Desenha a galinha nas telas (loja, perfil, avatar) — equivalente ao
/// `drawChickenPreview()` da versão web. Usa o mesmo traçado do Player
/// para o boneco ficar consistente entre menu e gameplay.
class ChickenPreview extends StatelessWidget {
  final SkinDef skin;
  final HatDef? hat;
  final bool compact;

  const ChickenPreview({super.key, required this.skin, this.hat, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChickenPainter(skin: skin, hat: hat, compact: compact),
      size: Size.infinite,
    );
  }
}

class _ChickenPainter extends CustomPainter {
  final SkinDef skin;
  final HatDef? hat;
  final bool compact;

  _ChickenPainter({required this.skin, this.hat, required this.compact});

  @override
  void paint(Canvas canvas, Size size) {
    // escala o desenho pra caber na área disponível
    final base = compact ? 42.0 : 74.0;
    final scale = (size.shortestSide / base).clamp(0.4, 2.2);
    final w = base * scale * 0.8;
    final h = base * scale * 0.8;

    canvas.save();
    canvas.translate(size.width / 2 - w * 0.42, size.height / 2 + h * 0.45);

    final legPaint = Paint()
      ..color = skin.leg
      ..strokeWidth = 3.2 * scale
      ..strokeCap = StrokeCap.round;
    final bodyPaint = Paint()..color = skin.body;
    final tailAPaint = Paint()..color = skin.tailA;
    final tailBPaint = Paint()..color = skin.tailB;
    final combPaint = Paint()..color = skin.comb;
    final beakPaint = Paint()..color = skin.beak;

    // pernas
    for (final side in [-1.0, 1.0]) {
      final lx = w * 0.42 + side * w * 0.12;
      canvas.drawLine(Offset(lx, -h * 0.18), Offset(lx, 0), legPaint);
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

    // crista
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(w * (0.34 + i * 0.09), -h * 0.94), 3.8 * scale, combPaint);
    }

    // bico
    final beak = Path()
      ..moveTo(w * 0.70, -h * 0.66)
      ..lineTo(w * 0.95, -h * 0.58)
      ..lineTo(w * 0.70, -h * 0.50)
      ..close();
    canvas.drawPath(beak, beakPaint);

    // olho
    canvas.drawCircle(
      Offset(w * 0.56, -h * 0.72),
      2.2 * scale,
      Paint()..color = const Color(0xFF2B2B2B),
    );

    // chapéu
    final hatDef = hat;
    if (hatDef != null && hatDef.id != 'none' && hatDef.emoji.isNotEmpty) {
      final tp = TextPainter(
        text: TextSpan(text: hatDef.emoji, style: TextStyle(fontSize: w * 0.5)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(w * 0.42 - tp.width / 2, -h * 1.3));
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ChickenPainter old) =>
      old.skin.id != skin.id || old.hat?.id != hat?.id;
}

import 'package:flutter/material.dart';
import '../game/chicken_up_game.dart';

class HudOverlay extends StatelessWidget {
  final ChickenUpGame game;
  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: game.score,
              builder: (context, value, _) => _HudChip(text: value.toString().padLeft(6, '0')),
            ),
            ValueListenableBuilder<int>(
              valueListenable: game.cornThisRun,
              builder: (context, value, _) => _HudChip(text: '🌽 $value'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HudChip extends StatelessWidget {
  final String text;
  const _HudChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

import 'package:flutter/material.dart';
import '../data/i18n.dart';
import '../game/chicken_up_game.dart';

class GameOverOverlay extends StatelessWidget {
  final ChickenUpGame game;
  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 380),
        decoration: BoxDecoration(
          color: const Color(0xFFB07A3E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF6B4423), width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(I18n.t('gameOverRun'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 6),
            Text(I18n.t('gameOverSub'), style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            ValueListenableBuilder<int>(
              valueListenable: game.score,
              builder: (context, value, _) => Text(
                '${I18n.t('score')}$value',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: game.highScore,
              builder: (context, value, _) => Text(
                '${I18n.t('record')}$value',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: game.cornThisRun,
              builder: (context, value, _) => Text(
                '🌽 +$value',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: game.startRun,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC83D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(I18n.t('playAgain'), style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => game.runState.value = RunState.menu,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('MENU'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

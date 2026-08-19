import 'package:flutter/material.dart';
import '../data/i18n.dart';
import '../data/storage.dart';
import '../game/chicken_up_game.dart';
import 'shop_screen.dart';

class MenuScreen extends StatelessWidget {
  final ChickenUpGame game;
  const MenuScreen({super.key, required this.game});

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
            Text(
              I18n.t('appTitle'),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              I18n.t('subtitle'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<int>(
              valueListenable: game.cornBalance,
              builder: (context, value, _) => Text(
                '${I18n.t('cornSaved')}$value',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            _MenuButton(
              label: I18n.t('play'),
              color: const Color(0xFFFFC83D),
              onTap: game.startRun,
            ),
            const SizedBox(height: 10),
            _MenuButton(
              label: I18n.t('shop'),
              color: const Color(0xFF3A6BFF),
              onTap: () => showDialog(
                context: context,
                builder: (_) => ShopScreen(game: game),
              ),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<String>(
              valueListenable: I18n.lang,
              builder: (context, lang, _) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LangChip(code: 'pt', label: 'PT', active: lang == 'pt'),
                  const SizedBox(width: 8),
                  _LangChip(code: 'en', label: 'EN', active: lang == 'en'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String code;
  final String label;
  final bool active;
  const _LangChip({required this.code, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        I18n.setLang(code);
        Storage.setLang(code);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white24,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, style: TextStyle(color: active ? const Color(0xFF6B4423) : Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

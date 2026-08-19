import 'package:flutter/material.dart';
import '../data/i18n.dart';
import '../game/chicken_up_game.dart';
import '../ui/theme.dart';
import '../ui/wood_widgets.dart';

/// HUD da partida: pontuação, milho, recorde, barras dos power-ups ativos,
/// botão de pausa e o toast — como na versão web.
class HudOverlay extends StatelessWidget {
  final ChickenUpGame game;
  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: game.score,
                      builder: (context, v, _) =>
                          _HudChip(text: v.toString().padLeft(6, '0'), big: true),
                    ),
                    Row(
                      children: [
                        ValueListenableBuilder<int>(
                          valueListenable: game.cornThisRun,
                          builder: (context, v, _) => _HudChip(text: '🌽 $v'),
                        ),
                        const SizedBox(width: 8),
                        WoodIconButton(
                          size: 38,
                          icon: const Icon(Icons.pause, color: Colors.white, size: 18),
                          onPressed: game.pause,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ValueListenableBuilder<int>(
                  valueListenable:
                      game.mode == GameMode.fly ? game.highScoreFly : game.highScore,
                  builder: (context, v, _) => _HudChip(
                    text: '${I18n.t('recordLabel')}${v.toString().padLeft(6, '0')}',
                    small: true,
                  ),
                ),
                const SizedBox(height: 8),
                // barras dos power-ups ativos
                ValueListenableBuilder<List<ActiveEffect>>(
                  valueListenable: game.activeEffects,
                  builder: (context, effects, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: effects
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: _EffectBar(effect: e),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          // toast centralizado embaixo
          ValueListenableBuilder<ToastMsg?>(
            valueListenable: game.toast,
            builder: (context, t, _) {
              if (t == null) return const SizedBox.shrink();
              return Align(
                alignment: const Alignment(0, 0.72),
                child: AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xE63B3025),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: AppColors.cornYellow, width: 2),
                      boxShadow: AppShadows.elevated,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(t.emoji, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(t.text,
                            style: const TextStyle(
                                color: AppColors.cream,
                                fontWeight: FontWeight.w800,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HudChip extends StatelessWidget {
  final String text;
  final bool big;
  final bool small;
  const _HudChip({required this.text, this.big = false, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: big ? 14 : 10, vertical: big ? 7 : 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: big ? 20 : (small ? 12 : 15),
          letterSpacing: big ? 1 : 0,
        ),
      ),
    );
  }
}

class _EffectBar extends StatelessWidget {
  final ActiveEffect effect;
  const _EffectBar({required this.effect});

  @override
  Widget build(BuildContext context) {
    final blinking = effect.progress < 0.25;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(effect.def.emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 5),
        Container(
          width: 68,
          height: 7,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: effect.progress,
            child: Container(
              decoration: BoxDecoration(
                color: blinking ? AppColors.accentRed : AppColors.cornYellow,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

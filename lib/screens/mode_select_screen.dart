import 'package:flutter/material.dart';
import '../data/i18n.dart';
import '../game/chicken_up_game.dart';
import '../ui/theme.dart';
import '../ui/wood_widgets.dart';

/// Escolha do modo (Corrida / Voo) — mesmos cards da versão web.
class ModeSelectScreen extends StatelessWidget {
  final ChickenUpGame game;
  const ModeSelectScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: I18n.lang,
      builder: (context, _, __) => Container(
        color: const Color(0xC70A0F19),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                WoodPanel(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(I18n.t('modeSelectTitle'), style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.s16),
                      _ModeCard(
                        title: I18n.t('modeCardRunText'),
                        desc: I18n.t('modeCardRunDesc'),
                        tags: I18n.t('modeCardRunTags'),
                        emoji: '🏃',
                        borderColor: AppColors.cornYellow,
                        buttonColor: WoodBtnColor.yellow,
                        onPlay: () => game.startRun(withMode: GameMode.run),
                      ),
                      _ModeCard(
                        title: I18n.t('modeCardFlyText'),
                        desc: I18n.t('modeCardFlyDesc'),
                        tags: I18n.t('modeCardFlyTags'),
                        emoji: '🪽',
                        borderColor: AppColors.accentBlue,
                        buttonColor: WoodBtnColor.blue,
                        onPlay: () => game.startRun(withMode: GameMode.fly),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      WoodButton(
                        label: I18n.t('closeModeSelectBtn'),
                        color: WoodBtnColor.red,
                        onPressed: () => game.runState.value = RunState.menu,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GameCloseButton(
                    onPressed: () => game.runState.value = RunState.menu,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String desc;
  final String tags;
  final String emoji;
  final Color borderColor;
  final WoodBtnColor buttonColor;
  final VoidCallback onPlay;

  const _ModeCard({
    required this.title,
    required this.desc,
    required this.tags,
    required this.emoji,
    required this.borderColor,
    required this.buttonColor,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s20, horizontal: AppSpacing.s16),
      decoration: BoxDecoration(
        color: const Color(0xF0FFF7E6),
        border: Border.all(color: borderColor, width: 3),
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.s8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.darkBrown)),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(desc,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.darkBrown.withOpacity(0.85))),
          const SizedBox(height: AppSpacing.s8),
          Text(tags,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: AppColors.wood)),
          const SizedBox(height: AppSpacing.s16),
          WoodButton(label: I18n.t('playRunBtn'), color: buttonColor, onPressed: onPlay),
        ],
      ),
    );
  }
}

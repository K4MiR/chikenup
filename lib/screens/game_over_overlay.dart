import 'package:flutter/material.dart';
import '../data/i18n.dart';
import '../game/chicken_up_game.dart';
import '../ui/theme.dart';
import '../ui/wood_widgets.dart';

class GameOverOverlay extends StatelessWidget {
  final ChickenUpGame game;
  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: I18n.lang,
      builder: (context, _, __) => Container(
        color: const Color(0xC70A0F19),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s20),
            child: WoodPanel(
              showRivets: true,
              padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.s32, horizontal: AppSpacing.s24),
              maxWidth: 380,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(I18n.t('gameOverTitle_run'), style: AppTypography.h1.copyWith(fontSize: 28)),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    I18n.t('gameOverSub_run'),
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(color: AppColors.cream.withOpacity(0.9)),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  ValueListenableBuilder<int>(
                    valueListenable: game.score,
                    builder: (context, v, _) => Text(
                      '${I18n.t('finalScoreLabel')}${v.toString().padLeft(6, '0')}',
                      style: AppTypography.h2.copyWith(fontSize: 20),
                    ),
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: game.highScore,
                    builder: (context, v, _) => Text(
                      '${I18n.t('finalHighLabel_run')}${v.toString().padLeft(6, '0')}',
                      style: AppTypography.hint,
                    ),
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: game.cornThisRun,
                    builder: (context, v, _) => Text(
                      '🌽 ${I18n.t('finalCornLabel_collected')}$v',
                      style: AppTypography.hint,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  WoodButton(
                    label: I18n.t('startBtnPlayAgain'),
                    color: WoodBtnColor.yellow,
                    primary: true,
                    onPressed: game.startRun,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  WoodButton(
                    label: I18n.t('backToMenuBtn'),
                    color: WoodBtnColor.red,
                    onPressed: () => game.runState.value = RunState.menu,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../data/i18n.dart';
import '../game/chicken_up_game.dart';
import '../ui/theme.dart';
import '../ui/wood_widgets.dart';

/// Tela de pausa. O X do canto retoma o jogo (mesmo comportamento da web,
/// onde fechar a pausa não podia deixar o estado travado em "paused").
class PauseOverlay extends StatelessWidget {
  final ChickenUpGame game;
  const PauseOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: I18n.lang,
      builder: (context, _, __) => Container(
        color: const Color(0xC70A0F19),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                WoodPanel(
                  maxWidth: 340,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(I18n.t('pauseTitle'), style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.s20),
                      WoodButton(
                        label: I18n.t('resumeBtn'),
                        color: WoodBtnColor.green,
                        onPressed: game.resume,
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      WoodButton(
                        label: I18n.t('restartBtn'),
                        color: WoodBtnColor.blue,
                        onPressed: () => game.startRun(),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      WoodButton(
                        label: I18n.t('quitToMenuBtn'),
                        color: WoodBtnColor.red,
                        onPressed: () async {
                          // banca o milho da corrida antes de sair, senão o
                          // jogador perderia o que coletou (bug que corrigimos
                          // na versão web).
                          await game.endRun(quit: true);
                          game.runState.value = RunState.menu;
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GameCloseButton(onPressed: game.resume),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

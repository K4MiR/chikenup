import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../data/i18n.dart';
import '../data/stats.dart';
import '../data/storage.dart';
import '../ui/theme.dart';
import '../ui/wood_widgets.dart';

/// Estatísticas — abas Corrida/Voo no cabeçalho fixo, cards rolando embaixo.
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool flyTab = false;

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.82;
    final s = GameStats.load();

    return ValueListenableBuilder<String>(
      valueListenable: I18n.lang,
      builder: (context, _, __) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxH, maxWidth: 420),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                WoodPanel(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(I18n.t('statsTitle'), style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.s12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _tab(I18n.t('statsTabRunText'), !flyTab, () => setState(() => flyTab = false)),
                          const SizedBox(width: 6),
                          _tab(I18n.t('statsTabFlyText'), flyTab, () => setState(() => flyTab = true)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.9,
                                children: (flyTab ? _flyCards(s) : _runCards(s))
                                    .map((c) => _StatCard(label: c.$1, value: c.$2))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      WoodButton(
                        label: I18n.t('closeStatsBtn'),
                        color: WoodBtnColor.red,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GameCloseButton(onPressed: () => Navigator.of(context).pop()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<(String, String)> _runCards(GameStats s) {
    final en = I18n.isEn;
    final bestMin = s.bestSurvivalMs ~/ 60000;
    final bestSec = (s.bestSurvivalMs % 60000) ~/ 1000;
    return [
      (en ? 'Runs played' : 'Corridas realizadas', '${s.gamesPlayed}'),
      (en ? 'Run record' : 'Recorde de corrida', '${Storage.highScore}'),
      (en ? 'Best survival' : 'Melhor sobrevivência', '${bestMin}m ${bestSec}s'),
      (en ? 'Longest distance' : 'Maior distância', '${s.distanceTotal ~/ 10} m'),
      (en ? 'Corn collected' : 'Milhos coletados', '${s.cornLifetime}'),
      (en ? 'Total jumps' : 'Pulos totais', '${s.totalJumps}'),
      (en ? 'Best combo' : 'Maior combo', '${s.bestCombo}'),
      (
        en ? 'Chickens unlocked' : 'Galinhas desbloqueadas',
        '${Storage.unlockedSkins.length}/${Catalog.skinCount}'
      ),
      (
        en ? 'Achievements' : 'Conquistas',
        '${Storage.unlockedAchievements.length}/${Catalog.achievementCount}'
      ),
    ];
  }

  List<(String, String)> _flyCards(GameStats s) {
    final en = I18n.isEn;
    final bestMin = s.flyBestSurvivalMs ~/ 60000;
    final bestSec = (s.flyBestSurvivalMs % 60000) ~/ 1000;
    return [
      (en ? 'Flights played' : 'Voos realizados', '${s.flyGamesPlayed}'),
      (en ? 'Flight record' : 'Recorde de voo', '${Storage.highScoreFly}'),
      (en ? 'Best survival' : 'Melhor sobrevivência', '${bestMin}m ${bestSec}s'),
      (en ? 'Corn collected' : 'Milhos coletados', '${s.flyCornLifetime}'),
    ];
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.cornYellow : AppColors.cream,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.woodDark, width: 2),
        ),
        child: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: active ? Colors.white : AppColors.darkBrown)),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8D9B5), width: 2),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.darkBrown)),
          Text(label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: AppColors.darkBrown.withOpacity(0.75))),
        ],
      ),
    );
  }
}

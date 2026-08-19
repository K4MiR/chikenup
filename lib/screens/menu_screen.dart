import 'package:flutter/material.dart';
import '../data/i18n.dart';
import '../data/storage.dart';
import '../game/chicken_up_game.dart';
import '../ui/theme.dart';
import '../ui/wood_widgets.dart';
import 'achievements_screen.dart';
import 'settings_screen.dart';
import 'shop_screen.dart';
import 'stats_screen.dart';

class MenuScreen extends StatefulWidget {
  final ChickenUpGame game;
  const MenuScreen({super.key, required this.game});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: I18n.lang,
      builder: (context, _, __) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: WoodPanel(
            showRivets: true,
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.s32,
              horizontal: AppSpacing.s24,
            ),
            maxWidth: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(I18n.t('appTitle', 'Chicken Up'), style: AppTypography.h1),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  I18n.t('overlaySub'),
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(color: AppColors.cream.withOpacity(0.92)),
                ),
                const SizedBox(height: AppSpacing.s12),
                ValueListenableBuilder<int>(
                  valueListenable: widget.game.cornBalance,
                  builder: (context, value, _) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🌽', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text('${I18n.t('cornBalanceLabel')}$value', style: AppTypography.hint),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
                WoodButton(
                  label: I18n.t('startBtn'),
                  color: WoodBtnColor.yellow,
                  primary: true,
                  onPressed: widget.game.startRun,
                ),
                const SizedBox(height: AppSpacing.s12),
                WoodButton(
                  label: I18n.t('shopBtnText'),
                  color: WoodBtnColor.blue,
                  onPressed: () => _open(const _ShopRoute()),
                ),
                const SizedBox(height: AppSpacing.s16),
                Wrap(
                  spacing: AppSpacing.s12,
                  runSpacing: AppSpacing.s12,
                  alignment: WrapAlignment.center,
                  children: [
                    WoodIconButton(
                      tooltip: I18n.t('profileBtn'),
                      icon: const Icon(Icons.person, color: Colors.white),
                      onPressed: () {},
                    ),
                    WoodIconButton(
                      tooltip: I18n.t('rankingBtn'),
                      highlighted: true,
                      icon: const Icon(Icons.emoji_events, color: AppColors.cornYellow),
                      onPressed: () {},
                    ),
                    WoodIconButton(
                      tooltip: I18n.t('achBtn'),
                      icon: const Icon(Icons.star, color: Colors.white),
                      onPressed: () => _open(const _AchRoute()),
                    ),
                    WoodIconButton(
                      tooltip: I18n.t('statsBtn'),
                      icon: const Icon(Icons.bar_chart, color: Colors.white),
                      onPressed: () => _open(const _StatsRoute()),
                    ),
                    WoodIconButton(
                      tooltip: I18n.t('labBtn'),
                      icon: const Icon(Icons.science, color: Colors.white),
                      onPressed: () {},
                    ),
                    WoodIconButton(
                      tooltip: I18n.t('configBtn'),
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () => _open(const _SettingsRoute()),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(
                  I18n.t('overlayHint'),
                  textAlign: TextAlign.center,
                  style: AppTypography.hint.copyWith(color: AppColors.cream.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _open(_Route route) {
    showDialog(
      context: context,
      barrierColor: const Color(0xC70A0F19),
      builder: (_) => switch (route) {
        _ShopRoute() => ShopScreen(game: widget.game),
        _AchRoute() => const AchievementsScreen(),
        _StatsRoute() => const StatsScreen(),
        _SettingsRoute() => const SettingsScreen(),
      },
    ).then((_) {
      if (mounted) setState(() {});
    });
  }
}

sealed class _Route {
  const _Route();
}

class _ShopRoute extends _Route {
  const _ShopRoute();
}

class _AchRoute extends _Route {
  const _AchRoute();
}

class _StatsRoute extends _Route {
  const _StatsRoute();
}

class _SettingsRoute extends _Route {
  const _SettingsRoute();
}

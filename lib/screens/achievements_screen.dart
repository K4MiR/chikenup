import 'package:flutter/material.dart';
import '../data/achievements.dart';
import '../data/i18n.dart';
import '../data/item_defs.dart';
import '../data/storage.dart';
import '../ui/theme.dart';
import '../ui/wood_widgets.dart';

/// Conquistas — cabeçalho fixo (título + contador) e só a lista rolando,
/// exatamente como ficou na versão web.
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final unlocked = Storage.unlockedAchievements.toSet();
    final maxH = MediaQuery.of(context).size.height * 0.82;

    return ValueListenableBuilder<String>(
      valueListenable: I18n.lang,
      builder: (context, _, __) {
        final summary = I18n.isEn
            ? '${unlocked.length} / ${kAchievements.length} achievements unlocked'
            : '${unlocked.length} / ${kAchievements.length} conquistas desbloqueadas';

        String? lastCat;
        final rows = <Widget>[];
        for (final a in kAchievements) {
          final isUnlocked = unlocked.contains(a.id);
          final hiddenLocked = a.hidden && !isUnlocked;
          if (a.cat != lastCat) {
            lastCat = a.cat;
            rows.add(Padding(
              padding: const EdgeInsets.fromLTRB(2, AppSpacing.s16, 0, AppSpacing.s8),
              child: Text(
                a.cat.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: AppColors.woodDark.withOpacity(0.85),
                ),
              ),
            ));
          }
          rows.add(_AchRow(def: a, unlocked: isUnlocked, hiddenLocked: hiddenLocked));
        }

        return Center(
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
                        Text(I18n.t('achTitle'), style: AppTypography.h2),
                        const SizedBox(height: AppSpacing.s8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(AppRadius.button),
                            border: Border.all(color: AppColors.woodDark, width: 2),
                          ),
                          child: Text(summary,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.darkBrown)),
                        ),
                        const SizedBox(height: AppSpacing.s8),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        WoodButton(
                          label: I18n.t('closeAchBtn'),
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
        );
      },
    );
  }
}

class _AchRow extends StatelessWidget {
  final AchievementDef def;
  final bool unlocked;
  final bool hiddenLocked;

  const _AchRow({required this.def, required this.unlocked, required this.hiddenLocked});

  @override
  Widget build(BuildContext context) {
    final r = rarityOf(def.rarity);
    return Opacity(
      opacity: unlocked ? 1 : 0.55,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(unlocked ? 0.92 : 0.65),
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border(
            left: BorderSide(color: r.color, width: 5),
            top: const BorderSide(color: Color(0xFFE8D9B5), width: 2),
            right: const BorderSide(color: Color(0xFFE8D9B5), width: 2),
            bottom: const BorderSide(color: Color(0xFFE8D9B5), width: 2),
          ),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                hiddenLocked ? '❓' : (unlocked ? def.emoji : '🔒'),
                style: const TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hiddenLocked ? '???' : def.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkBrown),
                  ),
                  Text(
                    hiddenLocked ? I18n.t('achSecretDesc') : def.desc,
                    style: TextStyle(
                        fontSize: 12, color: AppColors.darkBrown.withOpacity(0.75)),
                  ),
                ],
              ),
            ),
            if (!hiddenLocked)
              Text(
                r.name.toUpperCase(),
                style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w800, color: r.color, letterSpacing: 0.4),
              ),
          ],
        ),
      ),
    );
  }
}

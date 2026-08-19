import 'package:flutter/material.dart';
import '../data/daily_reward.dart';
import '../data/gameplay_defs.dart';
import '../data/i18n.dart';
import '../ui/theme.dart';
import '../ui/wood_widgets.dart';

/// Caixa da recompensa diária do menu — baú, dia do ciclo, botão de resgate
/// e a trilha dos 7 dias, como na versão web.
class DailyRewardBox extends StatefulWidget {
  final ValueChanged<int> onClaimed;
  const DailyRewardBox({super.key, required this.onClaimed});

  @override
  State<DailyRewardBox> createState() => _DailyRewardBoxState();
}

class _DailyRewardBoxState extends State<DailyRewardBox> {
  Future<void> _claim() async {
    final reward = await DailyReward.claim();
    if (reward > 0) {
      widget.onClaimed(reward);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final claimed = DailyReward.claimedToday;
    final day = DailyReward.dayInCycle;
    final reward = DailyReward.todayReward;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.16),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.woodDark.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          Text(
            I18n.t('dailyRewardTitle'),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: AppColors.cornYellow,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          // baú
          Container(
            width: 74,
            height: 52,
            decoration: BoxDecoration(
              color: claimed ? AppColors.wood : AppColors.woodLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.woodDark, width: 3),
              boxShadow: claimed
                  ? null
                  : [BoxShadow(color: AppColors.cornYellow.withOpacity(0.55), blurRadius: 14)],
            ),
            child: Center(
              child: Text(claimed ? '📭' : '🎁', style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            '${I18n.t('dailyDayLabel')}$day',
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.cream),
          ),
          const SizedBox(height: 4),
          if (claimed)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check, size: 16, color: AppColors.cornYellow),
                const SizedBox(width: 4),
                Text(I18n.t('dailyClaimedText'),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.cornYellow)),
              ],
            )
          else
            Text('🌽 +$reward',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.cornYellow)),
          const SizedBox(height: AppSpacing.s8),
          WoodButton(
            label: claimed ? I18n.t('dailyClaimBtnWait') : I18n.t('dailyClaimBtnOpen'),
            color: WoodBtnColor.yellow,
            onPressed: claimed ? null : _claim,
            fontSize: 14,
          ),
          const SizedBox(height: AppSpacing.s8),
          // trilha dos 7 dias
          Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: List.generate(kDailyRewards.length, (i) {
              final done = i < day - 1 || (i == day - 1 && claimed);
              final current = i == day - 1 && !claimed;
              return Container(
                width: 38,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: done
                      ? AppColors.accentGreen.withOpacity(0.85)
                      : current
                          ? AppColors.cornYellow.withOpacity(0.9)
                          : Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: current ? AppColors.cornYellow : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text('${I18n.t('dailyDayLabel')}${i + 1}',
                        style: const TextStyle(
                            fontSize: 7, fontWeight: FontWeight.w800, color: Colors.white)),
                    Text(
                      done ? '✓' : (current ? '🌽' : '🔒'),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

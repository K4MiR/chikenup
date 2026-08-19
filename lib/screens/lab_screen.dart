import 'package:flutter/material.dart';
import '../data/gameplay_defs.dart';
import '../data/i18n.dart';
import '../data/storage.dart';
import '../ui/theme.dart';
import '../ui/wood_widgets.dart';

/// Laboratório — modificadores divertidos + gravidade, iguais aos da web.
class LabScreen extends StatefulWidget {
  const LabScreen({super.key});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen> {
  late List<String> active;
  late String gravity;

  @override
  void initState() {
    super.initState();
    active = List.of(Storage.labMods);
    gravity = Storage.gravityMode;
  }

  Future<void> _toggleMod(String id) async {
    setState(() {
      if (active.contains(id)) {
        active.remove(id);
      } else {
        active.add(id);
      }
    });
    await Storage.setLabMods(active);
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.82;

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
                      Text(I18n.t('labTitle'), style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        I18n.t('labSubtitle'),
                        textAlign: TextAlign.center,
                        style: AppTypography.hint
                            .copyWith(color: AppColors.cream.withOpacity(0.85)),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...kLabMods.map((m) {
                                final on = active.contains(m.id);
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.cream,
                                    borderRadius: BorderRadius.circular(AppRadius.button),
                                    border: Border.all(
                                        color: const Color(0xFFE8D9B5), width: 2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(m.icon,
                                                size: 18, color: AppColors.wood),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(m.name,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors.darkBrown)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      _MiniToggle(
                                        value: on,
                                        onChanged: (_) => _toggleMod(m.id),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: AppSpacing.s8),
                              Row(
                                children: [
                                  const Icon(Icons.fitness_center,
                                      size: 15, color: AppColors.cream),
                                  const SizedBox(width: 6),
                                  Text(I18n.t('labGravityTitleLabel').toUpperCase(),
                                      style: AppTypography.h3),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.s8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: kGravityOrder.map((g) {
                                  final on = gravity == g;
                                  final label = I18n.isEn
                                      ? kGravityNamesEn[g]!
                                      : kGravityNamesPt[g]!;
                                  return GestureDetector(
                                    onTap: () async {
                                      setState(() => gravity = g);
                                      await Storage.setGravityMode(g);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color:
                                            on ? AppColors.cornYellow : AppColors.cream,
                                        borderRadius:
                                            BorderRadius.circular(AppRadius.button),
                                        border: Border.all(
                                            color: AppColors.woodDark, width: 2),
                                      ),
                                      child: Text(label,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 13,
                                              color: on
                                                  ? Colors.white
                                                  : AppColors.darkBrown)),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      WoodButton(
                        label: I18n.t('closeLabBtn'),
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
}

class _MiniToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _MiniToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? AppColors.cornYellow : AppColors.accentGray,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.woodDark, width: 2),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 140),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

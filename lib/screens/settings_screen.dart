import 'package:flutter/material.dart';
import '../data/difficulties.dart';
import '../data/i18n.dart';
import '../data/storage.dart';
import '../ui/theme.dart';
import '../ui/wood_widgets.dart';

/// Configurações — áudio, jogabilidade, idioma, privacidade, dados e sobre.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                      Text(I18n.t('configTitle'), style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.s12),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _section(I18n.t('cfgAudioTitleLabel'), Icons.volume_up, [
                                _toggle(I18n.t('cfgMusicLabel'), !Storage.musicMuted,
                                    (v) async {
                                  await Storage.setMusicMuted(!v);
                                  setState(() {});
                                }),
                                _toggle(I18n.t('cfgSfxLabel'), !Storage.sfxMuted, (v) async {
                                  await Storage.setSfxMuted(!v);
                                  setState(() {});
                                }),
                                _toggle(I18n.t('cfgVibrationLabel'), Storage.vibration,
                                    (v) async {
                                  await Storage.setVibration(v);
                                  setState(() {});
                                }),
                              ]),
                              _section(I18n.t('cfgGameplayTitleLabel'), Icons.videogame_asset, [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: kDifficulties.map((d) {
                                    final active = Storage.difficulty == d.id;
                                    return GestureDetector(
                                      onTap: () async {
                                        await Storage.setDifficulty(d.id);
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: active ? AppColors.cornYellow : AppColors.cream,
                                          borderRadius: BorderRadius.circular(AppRadius.button),
                                          border:
                                              Border.all(color: AppColors.woodDark, width: 2),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.circle, size: 8, color: d.color),
                                            const SizedBox(width: 6),
                                            Text(d.name,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 13,
                                                    color: active
                                                        ? Colors.white
                                                        : AppColors.darkBrown)),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ]),
                              _section(I18n.t('cfgLangTitleLabel'), Icons.language, [
                                Row(
                                  children: [
                                    _langChip('pt', '🇧🇷 PT'),
                                    const SizedBox(width: 8),
                                    _langChip('en', '🇺🇸 EN'),
                                  ],
                                ),
                              ]),
                              _section(I18n.t('cfgAboutTitleLabel'), Icons.info_outline, [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.cream,
                                    borderRadius: BorderRadius.circular(AppRadius.card),
                                    border:
                                        Border.all(color: const Color(0xFFE8D9B5), width: 2),
                                  ),
                                  child: Text(
                                    I18n.isEn
                                        ? 'Chicken Up — version 1.0.0\nAn independent game, made with care by Cleber Robson.'
                                        : 'Chicken Up — versão 1.0.0\nUm jogo independente, feito com carinho por Cleber Robson.',
                                    style: const TextStyle(
                                        fontSize: 12, height: 1.6, color: AppColors.darkBrown),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      WoodButton(
                        label: I18n.t('closeConfigBtn'),
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

  Widget _section(String title, IconData icon, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: AppColors.cream),
              const SizedBox(width: 6),
              Text(title.toUpperCase(), style: AppTypography.h3),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          ...children,
        ],
      ),
    );
  }

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: const Color(0xFFE8D9B5), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 14, color: AppColors.darkBrown)),
          _CfgToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _langChip(String code, String label) {
    final active = I18n.lang.value == code;
    return GestureDetector(
      onTap: () async {
        await I18n.setLang(code);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.cornYellow : AppColors.cream,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(color: AppColors.woodDark, width: 2),
        ),
        child: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: active ? Colors.white : AppColors.darkBrown)),
      ),
    );
  }
}

/// Toggle no estilo do jogo (`.cfgToggle` da versão web) — evita depender
/// da API do Switch do Material, que mudou de nome entre versões do Flutter.
class _CfgToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _CfgToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: 52,
        height: 30,
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
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 3)],
            ),
          ),
        ),
      ),
    );
  }
}

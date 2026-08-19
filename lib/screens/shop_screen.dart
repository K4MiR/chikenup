import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../data/hats.dart';
import '../data/i18n.dart';
import '../data/item_defs.dart';
import '../data/skins.dart';
import '../data/storage.dart';
import '../data/trails.dart';
import '../game/chicken_up_game.dart';
import '../ui/chicken_preview.dart';
import '../ui/theme.dart';
import '../ui/wood_widgets.dart';

enum ShopTab { skins, hats, trails }

/// Loja — mesma estrutura da versão web: cabeçalho fixo (título, saldo,
/// abas e vitrine) e só a grade de itens rolando embaixo.
class ShopScreen extends StatefulWidget {
  final ChickenUpGame game;
  const ShopScreen({super.key, required this.game});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  ShopTab tab = ShopTab.skins;
  String? focusedSkinId;

  List<String> get _unlocked => switch (tab) {
        ShopTab.skins => Storage.unlockedSkins,
        ShopTab.hats => Storage.unlockedHats,
        ShopTab.trails => Storage.unlockedTrails,
      };

  String get _equippedId => switch (tab) {
        ShopTab.skins => Storage.currentSkin,
        ShopTab.hats => Storage.currentHat,
        ShopTab.trails => Storage.currentTrail,
      };

  Future<void> _equip(String id) async {
    switch (tab) {
      case ShopTab.skins:
        await Storage.setCurrentSkin(id);
        widget.game.player.skin = Catalog.skin(id);
      case ShopTab.hats:
        await Storage.setCurrentHat(id);
        widget.game.player.hat = Catalog.hat(id);
      case ShopTab.trails:
        await Storage.setCurrentTrail(id);
    }
    setState(() {});
  }

  Future<void> _buy(String id, int cost) async {
    if (widget.game.cornBalance.value < cost) return;
    final newBalance = widget.game.cornBalance.value - cost;
    widget.game.cornBalance.value = newBalance;
    await Storage.setCornBalance(newBalance);
    switch (tab) {
      case ShopTab.skins:
        await Storage.setUnlockedSkins([...Storage.unlockedSkins, id]);
      case ShopTab.hats:
        await Storage.setUnlockedHats([...Storage.unlockedHats, id]);
      case ShopTab.trails:
        await Storage.setUnlockedTrails([...Storage.unlockedTrails, id]);
    }
    await _equip(id);
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
                      // ---- cabeçalho fixo ----
                      Text(I18n.t('shopTitle'), style: AppTypography.h2),
                      const SizedBox(height: AppSpacing.s4),
                      ValueListenableBuilder<int>(
                        valueListenable: widget.game.cornBalance,
                        builder: (context, v, _) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🌽'),
                            const SizedBox(width: 4),
                            Text('$v',
                                style: AppTypography.body
                                    .copyWith(fontWeight: FontWeight.bold, color: AppColors.cream)),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      _tabs(),
                      const SizedBox(height: AppSpacing.s12),
                      if (tab == ShopTab.skins) _showcase(),
                      const SizedBox(height: AppSpacing.s12),
                      // ---- só a grade rola ----
                      Flexible(child: SingleChildScrollView(child: _grid())),
                      const SizedBox(height: AppSpacing.s12),
                      WoodButton(
                        label: I18n.t('closeShopBtn'),
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

  Widget _tabs() {
    Widget btn(ShopTab t, String label) {
      final active = tab == t;
      return GestureDetector(
        onTap: () => setState(() => tab = t),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: active ? AppColors.cornYellow : AppColors.cream,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.woodDark, width: 2),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: active ? Colors.white : AppColors.darkBrown,
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 6,
      alignment: WrapAlignment.center,
      children: [
        btn(ShopTab.skins, I18n.t('shopTabSkins')),
        btn(ShopTab.hats, I18n.t('shopTabHats')),
        btn(ShopTab.trails, I18n.t('shopTabTrails')),
      ],
    );
  }

  /// Vitrine da galinha em destaque (só na aba de galinhas), igual à web.
  Widget _showcase() {
    final id = focusedSkinId ?? Storage.currentSkin;
    final skin = Catalog.skin(id);
    final rarity = rarityOf(skin.rarity);
    final unlocked = Storage.unlockedSkins.contains(id);
    final equipped = Storage.currentSkin == id;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8D9B5), width: 3),
        boxShadow: AppShadows.elevated,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 105,
            child: ChickenPreview(skin: skin, hat: Catalog.hat(Storage.currentHat)),
          ),
          const SizedBox(height: 6),
          Text(rarity.name,
              style: TextStyle(fontSize: 12, color: rarity.color, fontWeight: FontWeight.w800)),
          Text(skin.name,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
          const SizedBox(height: 2),
          Text(
            skin.cost == 0
                ? I18n.t('shopFree')
                : '🌽 ${skin.cost}${I18n.isEn ? I18n.t('shopCornSuffix') : ' de milho'}',
            style: TextStyle(fontSize: 14, color: AppColors.darkBrown.withOpacity(0.75)),
          ),
          const SizedBox(height: AppSpacing.s12),
          WoodButton(
            label: equipped
                ? I18n.t('shopEquipped')
                : unlocked
                    ? I18n.t('shopEquip')
                    : (I18n.isEn
                        ? '${I18n.t('shopBuyFor')}${skin.cost}'
                        : 'Comprar por ${skin.cost}'),
            color: WoodBtnColor.yellow,
            onPressed: equipped
                ? null
                : unlocked
                    ? () => _equip(id)
                    : (widget.game.cornBalance.value >= skin.cost ? () => _buy(id, skin.cost) : null),
          ),
        ],
      ),
    );
  }

  Widget _grid() {
    switch (tab) {
      case ShopTab.skins:
        return GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: kSkins.map((s) {
            final focused = (focusedSkinId ?? Storage.currentSkin) == s.id;
            final equipped = Storage.currentSkin == s.id;
            return _ItemCell(
              rarity: s.rarity,
              equipped: equipped,
              focused: focused,
              onTap: () => setState(() => focusedSkinId = s.id),
              child: ChickenPreview(skin: s, compact: true),
            );
          }).toList(),
        );
      case ShopTab.hats:
        return _twoColumnGrid(
          kHats,
          (h) => h.id,
          (h) => h.name,
          (h) => h.cost,
          (h) => h.rarity,
          (h) => Text(h.emoji, style: const TextStyle(fontSize: 26)),
        );
      case ShopTab.trails:
        return _twoColumnGrid(
          kTrails,
          (t) => t.id,
          (t) => t.name,
          (t) => t.cost,
          (t) => t.rarity,
          (t) => Text(t.emoji, style: const TextStyle(fontSize: 26)),
        );
    }
  }

  Widget _twoColumnGrid<T>(
    List<T> items,
    String Function(T) id,
    String Function(T) name,
    int Function(T) cost,
    String Function(T) rarity,
    Widget Function(T) preview,
  ) {
    final unlocked = _unlocked;
    final equippedId = _equippedId;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 0.95,
      children: items.map((item) {
        final itemId = id(item);
        final isUnlocked = unlocked.contains(itemId);
        final isEquipped = equippedId == itemId;
        final r = rarityOf(rarity(item));
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isEquipped ? AppColors.cornYellow : r.color.withOpacity(0.65),
              width: isEquipped ? 3 : 2,
            ),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Center(child: preview(item))),
              Text(r.name,
                  style: TextStyle(fontSize: 9, color: r.color, fontWeight: FontWeight.w800)),
              Text(
                name(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkBrown),
              ),
              Text(
                cost(item) == 0 ? I18n.t('shopFree') : '🌽 ${cost(item)}',
                style: const TextStyle(fontSize: 11, color: AppColors.darkBrown),
              ),
              const SizedBox(height: 2),
              SizedBox(
                width: double.infinity,
                height: 26,
                child: ElevatedButton(
                  onPressed: isEquipped
                      ? null
                      : isUnlocked
                          ? () => _equip(itemId)
                          : (widget.game.cornBalance.value >= cost(item)
                              ? () => _buy(itemId, cost(item))
                              : null),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: isEquipped ? AppColors.accentGray : AppColors.cornYellow,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    isEquipped
                        ? I18n.t('shopEquipped')
                        : isUnlocked
                            ? I18n.t('shopEquip')
                            : I18n.t('shopBuy'),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ItemCell extends StatelessWidget {
  final String rarity;
  final bool equipped;
  final bool focused;
  final VoidCallback onTap;
  final Widget child;

  const _ItemCell({
    required this.rarity,
    required this.equipped,
    required this.focused,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final r = rarityOf(rarity);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: equipped
                ? AppColors.cornYellow
                : focused
                    ? AppColors.accentBlue
                    : r.color.withOpacity(0.6),
            width: (equipped || focused) ? 3 : 2,
          ),
          boxShadow: AppShadows.card,
        ),
        child: child,
      ),
    );
  }
}

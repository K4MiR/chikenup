import 'package:flutter/material.dart';
import '../data/i18n.dart';
import '../data/skins.dart';
import '../data/storage.dart';
import '../game/chicken_up_game.dart';

class ShopScreen extends StatefulWidget {
  final ChickenUpGame game;
  const ShopScreen({super.key, required this.game});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late List<String> unlocked;

  @override
  void initState() {
    super.initState();
    unlocked = List.of(Storage.unlockedSkins);
  }

  void _buyOrEquip(SkinDef skin) async {
    final lang = I18n.lang.value;
    if (unlocked.contains(skin.id)) {
      await Storage.setCurrentSkin(skin.id);
      widget.game.player.skin = skin;
      setState(() {});
      return;
    }
    if (widget.game.cornBalance.value < skin.cost) return;
    final newBalance = widget.game.cornBalance.value - skin.cost;
    widget.game.cornBalance.value = newBalance;
    await Storage.setCornBalance(newBalance);
    unlocked = [...unlocked, skin.id];
    await Storage.setUnlockedSkins(unlocked);
    await Storage.setCurrentSkin(skin.id);
    widget.game.player.skin = skin;
    setState(() {});
    if (mounted) I18n.setLang(lang);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF5E6C8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(I18n.t('chickens'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            ValueListenableBuilder<int>(
              valueListenable: widget.game.cornBalance,
              builder: (context, value, _) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('🌽 $value', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 320,
              width: 320,
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: kSkins.map((skin) {
                  final isUnlocked = unlocked.contains(skin.id);
                  final isEquipped = Storage.currentSkin == skin.id;
                  return GestureDetector(
                    onTap: () => _buyOrEquip(skin),
                    child: Container(
                      decoration: BoxDecoration(
                        color: skin.body,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isEquipped ? const Color(0xFFFFC83D) : (kRarityColor[skin.rarity] ?? Colors.grey),
                          width: isEquipped ? 3 : 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(child: Center(child: Icon(Icons.egg, color: skin.comb))),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              isEquipped ? I18n.t('equipped') : (isUnlocked ? I18n.t('equip') : (skin.cost == 0 ? I18n.t('free') : '${skin.cost}')),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

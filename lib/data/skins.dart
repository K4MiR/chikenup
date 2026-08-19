import 'package:flutter/material.dart';

/// Galinhas (skins) jogáveis. Começa com um subconjunto das 163 skins da
/// versão web — dá pra ir portando o resto do JS aos poucos, seguindo este
/// mesmo formato (id, nome PT/EN, custo, raridade e cores do corpo).
class SkinDef {
  final String id;
  final String namePt;
  final String nameEn;
  final int cost;
  final String rarity; // common | rare | epic | legendary | mythic
  final Color body;
  final Color tail;
  final Color comb;

  const SkinDef({
    required this.id,
    required this.namePt,
    required this.nameEn,
    required this.cost,
    required this.rarity,
    required this.body,
    required this.tail,
    required this.comb,
  });

  String name(String lang) => lang == 'en' ? nameEn : namePt;
}

const List<SkinDef> kSkins = [
  SkinDef(id: 'classic', namePt: 'Clássica', nameEn: 'Classic', cost: 0, rarity: 'common', body: Color(0xFFFFF6E0), tail: Color(0xFF4FB0C6), comb: Color(0xFFE6473F)),
  SkinDef(id: 'ninja', namePt: 'Ninja', nameEn: 'Ninja', cost: 40, rarity: 'rare', body: Color(0xFF3A3A3A), tail: Color(0xFF555555), comb: Color(0xFFC0392B)),
  SkinDef(id: 'cowboy', namePt: 'Cowboy', nameEn: 'Cowboy', cost: 40, rarity: 'rare', body: Color(0xFFE8C98A), tail: Color(0xFF8A5A34), comb: Color(0xFFE6473F)),
  SkinDef(id: 'pirata', namePt: 'Pirata', nameEn: 'Pirate', cost: 55, rarity: 'epic', body: Color(0xFFFFF6E0), tail: Color(0xFF2B2B2B), comb: Color(0xFFE6473F)),
  SkinDef(id: 'gamer', namePt: 'Gamer', nameEn: 'Gamer', cost: 55, rarity: 'epic', body: Color(0xFFF3E8FF), tail: Color(0xFF7C3AED), comb: Color(0xFF7C3AED)),
  SkinDef(id: 'robo', namePt: 'Robô', nameEn: 'Robot', cost: 70, rarity: 'legendary', body: Color(0xFFB7C4CC), tail: Color(0xFF6D8EA3), comb: Color(0xFFE63946)),
  SkinDef(id: 'rainbow', namePt: 'Arco-íris', nameEn: 'Rainbow', cost: 150, rarity: 'mythic', body: Color(0xFFFFFFFF), tail: Color(0xFFFF6B6B), comb: Color(0xFFFFD166)),
  SkinDef(id: 'samurai', namePt: 'Samurai', nameEn: 'Samurai', cost: 50, rarity: 'rare', body: Color(0xFFE8E2D0), tail: Color(0xFF8B1A1A), comb: Color(0xFFC0392B)),
  SkinDef(id: 'viking', namePt: 'Viking', nameEn: 'Viking', cost: 50, rarity: 'rare', body: Color(0xFFC9A876), tail: Color(0xFF5B5B5B), comb: Color(0xFFE6473F)),
  SkinDef(id: 'princesa', namePt: 'Princesa', nameEn: 'Princess', cost: 50, rarity: 'rare', body: Color(0xFFFFE6F0), tail: Color(0xFFFF8FB3), comb: Color(0xFFFF5C8A)),
  SkinDef(id: 'fenix', namePt: 'Fênix', nameEn: 'Phoenix', cost: 110, rarity: 'legendary', body: Color(0xFFFFF0E0), tail: Color(0xFFFF6A00), comb: Color(0xFFFF3300)),
  SkinDef(id: 'dragao', namePt: 'Dragão', nameEn: 'Dragon', cost: 180, rarity: 'mythic', body: Color(0xFFDFF5DF), tail: Color(0xFF2E7D32), comb: Color(0xFF2E7D32)),
];

const Map<String, Color> kRarityColor = {
  'common': Color(0xFF9AA0A6),
  'rare': Color(0xFF2ECC71),
  'epic': Color(0xFF3B82F6),
  'legendary': Color(0xFFA855F7),
  'mythic': Color(0xFFF5C518),
};

SkinDef skinById(String id) => kSkins.firstWhere((s) => s.id == id, orElse: () => kSkins.first);

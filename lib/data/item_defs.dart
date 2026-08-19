import 'package:flutter/material.dart';
import '../ui/theme.dart';
import 'i18n.dart';

/// Tipos base dos itens do jogo. Os arquivos skins.dart / hats.dart /
/// trails.dart / achievements.dart são GERADOS a partir do index.html da
/// versão web (ver scripts em /tmp durante o port) — se precisar mudar
/// conteúdo, mude lá e regenere, para as duas versões não divergirem.

mixin LocalizedName {
  String get namePt;
  String get nameEn;
  String get name => I18n.lang.value == 'en' ? nameEn : namePt;
}

class SkinDef with LocalizedName {
  @override
  final String namePt;
  @override
  final String nameEn;
  final String id;
  final int cost;
  final String rarity;
  final Color body;
  final Color tailA;
  final Color tailB;
  final Color comb;
  final Color beak;
  final Color leg;
  final String emoji;

  const SkinDef({
    required this.id,
    required this.namePt,
    required this.nameEn,
    required this.cost,
    required this.rarity,
    required this.body,
    required this.tailA,
    required this.tailB,
    required this.comb,
    required this.beak,
    required this.leg,
    required this.emoji,
  });
}

class HatDef with LocalizedName {
  @override
  final String namePt;
  @override
  final String nameEn;
  final String id;
  final int cost;
  final String rarity;
  final Color swatch;
  final String emoji;

  const HatDef({
    required this.id,
    required this.namePt,
    required this.nameEn,
    required this.cost,
    required this.rarity,
    required this.swatch,
    required this.emoji,
  });
}

class TrailDef with LocalizedName {
  @override
  final String namePt;
  @override
  final String nameEn;
  final String id;
  final int cost;
  final String rarity;
  final Color swatch;
  final String emoji;

  const TrailDef({
    required this.id,
    required this.namePt,
    required this.nameEn,
    required this.cost,
    required this.rarity,
    required this.swatch,
    required this.emoji,
  });
}

class AchievementDef with LocalizedName {
  @override
  final String namePt;
  @override
  final String nameEn;
  final String id;
  final String descPt;
  final String descEn;
  final String catPt;
  final String catEn;
  final String rarity;
  final String emoji;
  final bool hidden;

  const AchievementDef({
    required this.id,
    required this.namePt,
    required this.nameEn,
    required this.descPt,
    required this.descEn,
    required this.catPt,
    required this.catEn,
    required this.rarity,
    required this.emoji,
    this.hidden = false,
  });

  String get desc => I18n.lang.value == 'en' ? descEn : descPt;
  String get cat => I18n.lang.value == 'en' ? catEn : catPt;
}

/// Nome e cor de cada raridade (RARITY_INFO da versão web).
class RarityInfo {
  final String namePt;
  final String nameEn;
  final Color color;
  const RarityInfo(this.namePt, this.nameEn, this.color);

  String get name => I18n.lang.value == 'en' ? nameEn : namePt;
}

const Map<String, RarityInfo> kRarities = {
  'common': RarityInfo('Comum', 'Common', AppColors.rarityCommon),
  'rare': RarityInfo('Rara', 'Rare', AppColors.rarityRare),
  'epic': RarityInfo('Épica', 'Epic', AppColors.rarityEpic),
  'legendary': RarityInfo('Lendária', 'Legendary', AppColors.rarityLegendary),
  'mythic': RarityInfo('Mítica', 'Mythic', AppColors.rarityMythic),
};

RarityInfo rarityOf(String key) => kRarities[key] ?? kRarities['common']!;

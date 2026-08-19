import 'package:flutter/material.dart';
import 'i18n.dart';

/// Definições de gameplay portadas 1:1 da versão web — cenários, clima,
/// fases do dia, chefes, power-ups e modificadores do laboratório.
/// Os números (durações, pesos de spawn, velocidades) são os mesmos do
/// index.html para o jogo ter exatamente o mesmo "feel".

// ======================= CENÁRIOS =======================
class ScenarioDef {
  final String namePt;
  final String nameEn;
  final int minScore;
  final Color skyTop;
  final Color skyBottom;
  final Color ground;
  final Color grass;
  final Color grassDark;
  final bool stars;

  const ScenarioDef({
    required this.namePt,
    required this.nameEn,
    required this.minScore,
    required this.skyTop,
    required this.skyBottom,
    required this.ground,
    required this.grass,
    required this.grassDark,
    required this.stars,
  });

  String get name => I18n.isEn ? nameEn : namePt;
}

const List<ScenarioDef> kScenarios = [
  ScenarioDef(
    namePt: 'Fazenda', nameEn: 'Farm', minScore: 0,
    skyTop: Color(0xFF8FB8F5), skyBottom: Color(0xFFCFE8FF),
    ground: Color(0xFF8A5A34), grass: Color(0xFF6FB54A), grassDark: Color(0xFF4C8A34), stars: false,
  ),
  ScenarioDef(
    namePt: 'Floresta', nameEn: 'Forest', minScore: 300,
    skyTop: Color(0xFF5B8F6B), skyBottom: Color(0xFFBFE8C9),
    ground: Color(0xFF4A3323), grass: Color(0xFF2F6B3A), grassDark: Color(0xFF1F4A26), stars: false,
  ),
  ScenarioDef(
    namePt: 'Cidade', nameEn: 'City', minScore: 700,
    skyTop: Color(0xFF6B7A99), skyBottom: Color(0xFFC7D3E8),
    ground: Color(0xFF555555), grass: Color(0xFF777777), grassDark: Color(0xFF444444), stars: false,
  ),
  ScenarioDef(
    namePt: 'Deserto', nameEn: 'Desert', minScore: 1200,
    skyTop: Color(0xFFE8A355), skyBottom: Color(0xFFFFE2B0),
    ground: Color(0xFFC8944F), grass: Color(0xFFD9AD6A), grassDark: Color(0xFFA97B3E), stars: false,
  ),
  ScenarioDef(
    namePt: 'Espaço', nameEn: 'Space', minScore: 1800,
    skyTop: Color(0xFF0B0B2B), skyBottom: Color(0xFF241B4A),
    ground: Color(0xFF2A2A3D), grass: Color(0xFF4A4A6A), grassDark: Color(0xFF33334A), stars: true,
  ),
];

ScenarioDef scenarioForScore(int score) {
  var chosen = kScenarios.first;
  for (final s in kScenarios) {
    if (score >= s.minScore) chosen = s;
  }
  return chosen;
}

// ======================= FASES DO DIA =======================
class DayPhaseDef {
  final String namePt;
  final String nameEn;
  final int durMs;
  final Color overlay;

  const DayPhaseDef({
    required this.namePt,
    required this.nameEn,
    required this.durMs,
    required this.overlay,
  });

  String get name => I18n.isEn ? nameEn : namePt;
}

const List<DayPhaseDef> kDayPhases = [
  DayPhaseDef(namePt: 'Dia', nameEn: 'Day', durMs: 30000, overlay: Color(0x00000000)),
  DayPhaseDef(namePt: 'Tarde', nameEn: 'Afternoon', durMs: 18000, overlay: Color(0x29FF8C3C)),
  DayPhaseDef(namePt: 'Noite', nameEn: 'Night', durMs: 22000, overlay: Color(0x6B0A0A37)),
  DayPhaseDef(namePt: 'Amanhecer', nameEn: 'Dawn', durMs: 14000, overlay: Color(0x33FFAAC8)),
];

// ======================= CLIMA =======================
enum WeatherType { none, rain, storm, wind, fog }

class WeatherDef {
  final WeatherType type;
  final String namePt;
  final String nameEn;
  final int weight;

  const WeatherDef({
    required this.type,
    required this.namePt,
    required this.nameEn,
    required this.weight,
  });

  String get name => I18n.isEn ? nameEn : namePt;
}

const List<WeatherDef> kWeathers = [
  WeatherDef(type: WeatherType.none, namePt: '', nameEn: '', weight: 50),
  WeatherDef(type: WeatherType.rain, namePt: 'Chuva', nameEn: 'Rain', weight: 15),
  WeatherDef(type: WeatherType.storm, namePt: 'Tempestade', nameEn: 'Storm', weight: 10),
  WeatherDef(type: WeatherType.wind, namePt: 'Vento forte', nameEn: 'Strong wind', weight: 15),
  WeatherDef(type: WeatherType.fog, namePt: 'Nevoeiro', nameEn: 'Fog', weight: 10),
];

// ======================= CHEFES =======================
class BossDef {
  final String id;
  final String namePt;
  final String nameEn;
  final String emoji;
  final double w;
  final double h;

  const BossDef({
    required this.id,
    required this.namePt,
    required this.nameEn,
    required this.emoji,
    required this.w,
    required this.h,
  });

  String get name => I18n.isEn ? nameEn : namePt;
}

const List<BossDef> kBosses = [
  BossDef(id: 'fox', namePt: 'Raposa Gigante', nameEn: 'Giant Fox', emoji: '🦊', w: 84, h: 78),
  BossDef(id: 'farmer', namePt: 'Fazendeiro Furioso', nameEn: 'Furious Farmer', emoji: '🧑‍🌾', w: 66, h: 92),
  BossDef(id: 'eagle', namePt: 'Águia Caçadora', nameEn: 'Hunting Eagle', emoji: '🦅', w: 92, h: 66),
];

const int kBossScoreStep = 1000;
const int kChaosScore = 3000;

// ======================= POWER-UPS (itens temporários) =======================
class PowerUpDef {
  final String id;
  final String namePt;
  final String nameEn;
  final String emoji;
  final int durationMs;
  final String rarity;
  final int spawnWeight;

  const PowerUpDef({
    required this.id,
    required this.namePt,
    required this.nameEn,
    required this.emoji,
    required this.durationMs,
    required this.rarity,
    required this.spawnWeight,
  });

  String get name => I18n.isEn ? nameEn : namePt;
}

const List<PowerUpDef> kPowerUps = [
  PowerUpDef(id: 'egg', namePt: 'Ovo Blindado', nameEn: 'Armored Egg', emoji: '🥚', durationMs: 5000, rarity: 'rare', spawnWeight: 16),
  PowerUpDef(id: 'turbo', namePt: 'Turbo', nameEn: 'Turbo', emoji: '🚀', durationMs: 4000, rarity: 'rare', spawnWeight: 16),
  PowerUpDef(id: 'wing', namePt: 'Asas', nameEn: 'Wings', emoji: '🪽', durationMs: 0, rarity: 'common', spawnWeight: 18),
  PowerUpDef(id: 'magnet', namePt: 'Ímã', nameEn: 'Magnet', emoji: '🧲', durationMs: 6000, rarity: 'common', spawnWeight: 20),
  PowerUpDef(id: 'shield', namePt: 'Escudo', nameEn: 'Shield', emoji: '🛡️', durationMs: 8000, rarity: 'rare', spawnWeight: 14),
  PowerUpDef(id: 'multiplier', namePt: 'Multiplicador', nameEn: 'Multiplier', emoji: '✨', durationMs: 10000, rarity: 'epic', spawnWeight: 9),
  PowerUpDef(id: 'shooter', namePt: 'Galinha Atiradora', nameEn: 'Shooter Chicken', emoji: '🔫', durationMs: 10000, rarity: 'legendary', spawnWeight: 5),
  PowerUpDef(id: 'demolisher', namePt: 'Galinha Demolidora', nameEn: 'Demolition Chicken', emoji: '💥', durationMs: 7000, rarity: 'epic', spawnWeight: 8),
  PowerUpDef(id: 'tractor', namePt: 'Trator', nameEn: 'Tractor', emoji: '🚜', durationMs: 9000, rarity: 'legendary', spawnWeight: 4),
];

const double kMagnetRadius = 130;

// ======================= LABORATÓRIO =======================
class LabModDef {
  final String id;
  final String namePt;
  final String nameEn;
  final IconData icon;

  const LabModDef({
    required this.id,
    required this.namePt,
    required this.nameEn,
    required this.icon,
  });

  String get name => I18n.isEn ? nameEn : namePt;
}

const List<LabModDef> kLabMods = [
  LabModDef(id: 'alwaysNight', namePt: 'Sempre noite', nameEn: 'Always night', icon: Icons.nightlight_round),
  LabModDef(id: 'alwaysRain', namePt: 'Sempre chovendo', nameEn: 'Always raining', icon: Icons.water_drop),
  LabModDef(id: 'speed2x', namePt: 'Velocidade x2', nameEn: 'Speed x2', icon: Icons.bolt),
  LabModDef(id: 'moreItems', namePt: 'Mais itens', nameEn: 'More items', icon: Icons.card_giftcard),
  LabModDef(id: 'giantObstacles', namePt: 'Obstáculos gigantes', nameEn: 'Giant obstacles', icon: Icons.park),
  LabModDef(id: 'partyMode', namePt: 'Modo festa', nameEn: 'Party mode', icon: Icons.celebration),
];

const Map<String, double> kGravityModes = {'baixa': 0.55, 'normal': 1.0, 'alta': 1.7};
const List<String> kGravityOrder = ['baixa', 'normal', 'alta'];
const Map<String, String> kGravityNamesPt = {'baixa': '🍃 Baixa', 'normal': '⚙️ Normal', 'alta': '🗿 Alta'};
const Map<String, String> kGravityNamesEn = {'baixa': '🍃 Low', 'normal': '⚙️ Normal', 'alta': '🗿 High'};

// ======================= RECOMPENSA DIÁRIA =======================
const List<int> kDailyRewards = [10, 15, 20, 25, 35, 45, 60];

// ======================= FÍSICA DO MODO VOO =======================
/// Valores por milissegundo, como na versão web (que usa dt em ms).
class FlyPhysics {
  FlyPhysics._();
  static const double gravity = 0.00105;
  static const double lift = 0.00245;
  static const double maxVSpeed = 0.46;
  static const double airResistance = 0.0018;
  static const double boundsPad = 6;
}

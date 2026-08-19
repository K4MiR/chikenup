import 'achievements.dart';
import 'hats.dart';
import 'item_defs.dart';
import 'skins.dart';
import 'trails.dart';

/// Acesso por id aos catálogos gerados. Sempre devolve algo válido
/// (cai no item padrão) para nunca quebrar por um id salvo inválido.
class Catalog {
  Catalog._();

  static final Map<String, SkinDef> _skinsById = {for (final s in kSkins) s.id: s};
  static final Map<String, HatDef> _hatsById = {for (final h in kHats) h.id: h};
  static final Map<String, TrailDef> _trailsById = {for (final t in kTrails) t.id: t};
  static final Map<String, AchievementDef> _achById = {for (final a in kAchievements) a.id: a};

  static SkinDef skin(String id) => _skinsById[id] ?? kSkins.first;
  static HatDef hat(String id) => _hatsById[id] ?? kHats.first;
  static TrailDef trail(String id) => _trailsById[id] ?? kTrails.first;
  static AchievementDef? achievement(String id) => _achById[id];

  static int get skinCount => kSkins.length;
  static int get hatCount => kHats.length;
  static int get trailCount => kTrails.length;
  static int get achievementCount => kAchievements.length;
}

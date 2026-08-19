import 'package:flutter/material.dart';
import 'i18n.dart';

/// Dificuldades — mesmos valores de velocidade/spawn da versão web
/// (DIFFICULTIES do index.html), para o jogo ter o mesmo "feel".
class DifficultyDef {
  final String id;
  final String namePt;
  final String nameEn;
  final Color color;
  final double startSpeed;
  final double maxSpeed;
  final double ramp;
  final double spawnMult;

  const DifficultyDef({
    required this.id,
    required this.namePt,
    required this.nameEn,
    required this.color,
    required this.startSpeed,
    required this.maxSpeed,
    required this.ramp,
    required this.spawnMult,
  });

  String get name => I18n.isEn ? nameEn : namePt;
}

const List<DifficultyDef> kDifficulties = [
  DifficultyDef(
    id: 'facil', namePt: 'Fácil', nameEn: 'Easy', color: Color(0xFF2ECC71),
    startSpeed: 0.13, maxSpeed: 0.34, ramp: 0.0000014, spawnMult: 2.45,
  ),
  DifficultyDef(
    id: 'normal', namePt: 'Normal', nameEn: 'Normal', color: Color(0xFFFFC83D),
    startSpeed: 0.20, maxSpeed: 0.56, ramp: 0.0000024, spawnMult: 1.0,
  ),
  DifficultyDef(
    id: 'dificil', namePt: 'Difícil', nameEn: 'Hard', color: Color(0xFFF2994A),
    startSpeed: 0.25, maxSpeed: 0.66, ramp: 0.0000027, spawnMult: 0.59,
  ),
  DifficultyDef(
    id: 'insano', namePt: 'Insano', nameEn: 'Insane', color: Color(0xFFF05A4F),
    startSpeed: 0.31, maxSpeed: 0.78, ramp: 0.0000038, spawnMult: 0.30,
  ),
];

DifficultyDef difficultyById(String id) =>
    kDifficulties.firstWhere((d) => d.id == id, orElse: () => kDifficulties[1]);

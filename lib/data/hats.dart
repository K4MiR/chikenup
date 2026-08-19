import 'package:flutter/material.dart';
import 'item_defs.dart';

/// 26 chapéus portados da versão web (HATS do index.html).
const List<HatDef> kHats = [
  HatDef(id: 'none', namePt: "Nenhum", nameEn: "None", cost: 0, rarity: 'common', swatch: Color(0xFFEEEEEE), emoji: "🚫"),
  HatDef(id: 'cap', namePt: "Boné", nameEn: "Cap", cost: 25, rarity: 'rare', swatch: Color(0xFFDBEAFE), emoji: "🧢"),
  HatDef(id: 'party', namePt: "Chapéu de festa", nameEn: "Party Hat", cost: 35, rarity: 'rare', swatch: Color(0xFFFDE68A), emoji: "🥳"),
  HatDef(id: 'flower', namePt: "Florzinha", nameEn: "Little Flower", cost: 20, rarity: 'common', swatch: Color(0xFFFBCFE8), emoji: "🌸"),
  HatDef(id: 'crown', namePt: "Coroa", nameEn: "Crown", cost: 60, rarity: 'epic', swatch: Color(0xFFFEF3C7), emoji: "👑"),
  HatDef(id: 'farmer', namePt: "Chapéu de Fazendeiro", nameEn: "Farmer Hat", cost: 20, rarity: 'common', swatch: Color(0xFFE8D5A8), emoji: "👒"),
  HatDef(id: 'cowboyhat', namePt: "Chapéu Cowboy", nameEn: "Cowboy Hat", cost: 30, rarity: 'rare', swatch: Color(0xFFD2A679), emoji: "🤠"),
  HatDef(id: 'straw', namePt: "Chapéu de Palha", nameEn: "Straw Hat", cost: 20, rarity: 'common', swatch: Color(0xFFF3E0A8), emoji: "👒"),
  HatDef(id: 'chef', namePt: "Chapéu de Chef", nameEn: "Chef Hat", cost: 35, rarity: 'rare', swatch: Color(0xFFFFFFFF), emoji: "👨‍🍳"),
  HatDef(id: 'pirate', namePt: "Chapéu Pirata", nameEn: "Pirate Hat", cost: 45, rarity: 'epic', swatch: Color(0xFF2B2B2B), emoji: "🏴‍☠️"),
  HatDef(id: 'tophat', namePt: "Cartola", nameEn: "Top Hat", cost: 55, rarity: 'epic', swatch: Color(0xFF1A1A1A), emoji: "🎩"),
  HatDef(id: 'helmet', namePt: "Capacete", nameEn: "Helmet", cost: 45, rarity: 'epic', swatch: Color(0xFFFFCD3C), emoji: "⛑️"),
  HatDef(id: 'detective', namePt: "Chapéu Detetive", nameEn: "Detective Hat", cost: 50, rarity: 'epic', swatch: Color(0xFF7A5C3E), emoji: "🕵️"),
  HatDef(id: 'magic', namePt: "Chapéu Mágico", nameEn: "Magic Hat", cost: 65, rarity: 'legendary', swatch: Color(0xFF6D28D9), emoji: "🪄"),
  HatDef(id: 'king', namePt: "Chapéu Real", nameEn: "Royal Hat", cost: 70, rarity: 'legendary', swatch: Color(0xFF7C2D12), emoji: "🤴"),
  HatDef(id: 'crown2', namePt: "Coroa Dourada", nameEn: "Golden Crown", cost: 90, rarity: 'legendary', swatch: Color(0xFFF5C518), emoji: "👑"),
  HatDef(id: 'winter', namePt: "Gorro de Inverno", nameEn: "Winter Beanie", cost: 35, rarity: 'rare', swatch: Color(0xFF93C5FD), emoji: "🧣"),
  HatDef(id: 'explorer', namePt: "Chapéu de Explorador", nameEn: "Explorer Hat", cost: 40, rarity: 'rare', swatch: Color(0xFFA3E635), emoji: "🎒"),
  HatDef(id: 'astronaut', namePt: "Capacete Espacial", nameEn: "Space Helmet", cost: 80, rarity: 'legendary', swatch: Color(0xFFD1D5DB), emoji: "👨‍🚀"),
  HatDef(id: 'ninjaHat', namePt: "Bandana Ninja", nameEn: "Ninja Bandana", cost: 45, rarity: 'epic', swatch: Color(0xFF1F2937), emoji: "🥷"),
  HatDef(id: 'diamond', namePt: "Coroa de Diamante", nameEn: "Diamond Crown", cost: 160, rarity: 'mythic', swatch: Color(0xFFA5F3FC), emoji: "💎"),
  HatDef(id: 'gamer', namePt: "Headset Gamer", nameEn: "Gamer Headset", cost: 40, rarity: 'rare', swatch: Color(0xFF2D2D3D), emoji: "🎧"),
  HatDef(id: 'robotHat', namePt: "Antena Robô", nameEn: "Robot Antenna", cost: 85, rarity: 'legendary', swatch: Color(0xFFC7CCD1), emoji: "🤖"),
  HatDef(id: 'viking', namePt: "Elmo Viking", nameEn: "Viking Helmet", cost: 60, rarity: 'epic', swatch: Color(0xFF8A6D4B), emoji: "🪖"),
  HatDef(id: 'mechanic', namePt: "Boné Mecânico", nameEn: "Mechanic Cap", cost: 30, rarity: 'rare', swatch: Color(0xFF4A5A6A), emoji: "🔧"),
  HatDef(id: 'scarecrow', namePt: "Chapéu Espantalho", nameEn: "Scarecrow Hat", cost: 25, rarity: 'common', swatch: Color(0xFFC9A44C), emoji: "🎃"),
];

import 'package:flutter/material.dart';

/// Design tokens portados 1:1 do `:root` da versão web (www/index.html).
/// Manter estes valores em sincronia com o CSS original — é o que garante
/// que a versão Flutter fique visualmente idêntica à versão web.
class AppColors {
  AppColors._();

  static const skyBlue = Color(0xFF8EC5F5);
  static const grassGreen = Color(0xFF73C94A);
  static const cornYellow = Color(0xFFFFC83D);
  static const soilBrown = Color(0xFF8B5A35);
  static const cream = Color(0xFFF7EAD0);
  static const creamDark = Color(0xFFEAD6A8);
  static const darkBrown = Color(0xFF3B3025);
  static const wood = Color(0xFF9A5B28);
  static const woodDark = Color(0xFF653817);
  static const woodLight = Color(0xFFB87A3E);
  static const accentRed = Color(0xFFF05A4F);
  static const accentPurple = Color(0xFF8D55E8);
  static const accentBlue = Color(0xFF4285E5);
  static const accentGreen = Color(0xFF70C94A);
  static const accentMagenta = Color(0xFFC052D9);
  static const accentGray = Color(0xFFA0A0A0);

  // Sombras "3D" de cada cor de botão (o --btn-shadow do CSS).
  static const shadowYellow = Color(0xFFB58900);
  static const shadowBlue = Color(0xFF2A5DB0);
  static const shadowGreen = Color(0xFF3F8A1F);
  static const shadowRed = Color(0xFFA5322A);
  static const shadowPurple = Color(0xFF5A2E9E);
  static const shadowWhite = Color(0xFFC9C9C9);

  // Cores de raridade (RARITY_INFO da versão web).
  static const rarityCommon = Color(0xFF9AA0A6);
  static const rarityRare = Color(0xFF2ECC71);
  static const rarityEpic = Color(0xFF3B82F6);
  static const rarityLegendary = Color(0xFFA855F7);
  static const rarityMythic = Color(0xFFF5C518);
}

class AppSpacing {
  AppSpacing._();
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
}

class AppRadius {
  AppRadius._();
  static const double button = 16;
  static const double card = 20;
  static const double modal = 24;
  static const double pill = 999;
}

class AppShadows {
  AppShadows._();

  static const card = [
    BoxShadow(color: Color(0x14000000), offset: Offset(0, 2), blurRadius: 5),
  ];
  static const modal = [
    BoxShadow(color: Color(0x47000000), offset: Offset(0, 10), blurRadius: 24),
  ];
  static const elevated = [
    BoxShadow(color: Color(0x29000000), offset: Offset(0, 6), blurRadius: 16),
  ];
}

class AppTypography {
  AppTypography._();

  /// A web usa 'Baloo 2'. Enquanto a fonte não é empacotada como asset,
  /// caímos no fallback do sistema mantendo os mesmos pesos/tamanhos.
  static const String fontFamily = 'Baloo2';

  static const h1 = TextStyle(
    fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.cream,
    shadows: [Shadow(color: Color(0x59000000), offset: Offset(0, 2))],
  );
  static const h2 = TextStyle(
    fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.cream,
    shadows: [Shadow(color: Color(0x59000000), offset: Offset(0, 2))],
  );
  static const h3 = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.cream,
    letterSpacing: 0.6,
  );
  static const body = TextStyle(fontSize: 15, color: AppColors.cream);
  static const hint = TextStyle(fontSize: 13, color: AppColors.cream);
  static const buttonLabel = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white,
    shadows: [Shadow(color: Color(0x59000000), offset: Offset(0, 2), blurRadius: 2)],
  );
  static const buttonLabelPrimary = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white,
    shadows: [Shadow(color: Color(0x59000000), offset: Offset(0, 2), blurRadius: 2)],
  );
}

import 'package:flutter/foundation.dart';

/// Sistema de idiomas do jogo — espelha o par PT-BR/EN já usado na versão web.
/// Mantido simples de propósito: um ValueNotifier com o idioma atual e um
/// mapa de strings por chave, igual ao `STRINGS`/`t()` da versão HTML.
class I18n {
  I18n._();

  static final ValueNotifier<String> lang = ValueNotifier<String>('pt');

  static const Map<String, Map<String, String>> _strings = {
    'pt': {
      'appTitle': 'Chicken Up',
      'subtitle': 'Uma galinha destemida fugindo pela fazenda!',
      'play': 'JOGAR',
      'playAgain': 'JOGAR DE NOVO',
      'shop': 'LOJA',
      'settings': 'CONFIGURAÇÕES',
      'close': 'FECHAR',
      'cornSaved': 'Milho guardado: ',
      'gameOverRun': 'Fim de jogo',
      'gameOverSub': 'A galinha bateu em algo!',
      'score': 'Pontos: ',
      'record': 'Recorde: ',
      'buy': 'Comprar',
      'equip': 'Equipar',
      'equipped': 'Equipado',
      'free': 'Grátis',
      'language': 'Idioma',
      'chickens': 'Galinhas',
    },
    'en': {
      'appTitle': 'Chicken Up',
      'subtitle': 'A fearless chicken on the run through the farm!',
      'play': 'PLAY',
      'playAgain': 'PLAY AGAIN',
      'shop': 'SHOP',
      'settings': 'SETTINGS',
      'close': 'CLOSE',
      'cornSaved': 'Corn saved: ',
      'gameOverRun': 'Game over',
      'gameOverSub': 'The chicken hit something!',
      'score': 'Score: ',
      'record': 'Record: ',
      'buy': 'Buy',
      'equip': 'Equip',
      'equipped': 'Equipped',
      'free': 'Free',
      'language': 'Language',
      'chickens': 'Chickens',
    },
  };

  static String t(String key) {
    return _strings[lang.value]?[key] ?? _strings['pt']![key] ?? key;
  }

  static void setLang(String value) {
    if (value == 'pt' || value == 'en') lang.value = value;
  }
}

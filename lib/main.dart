import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/i18n.dart';
import 'data/storage.dart';
import 'game/chicken_up_game.dart';
import 'screens/game_over_overlay.dart';
import 'screens/hud_overlay.dart';
import 'screens/menu_screen.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.init();
  I18n.lang.value = Storage.lang;
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ChickenUpApp());
}

class ChickenUpApp extends StatelessWidget {
  const ChickenUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chicken Up',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.skyBlue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.cornYellow,
          primary: AppColors.cornYellow,
        ),
      ),
      home: const GameScaffold(),
    );
  }
}

class GameScaffold extends StatefulWidget {
  const GameScaffold({super.key});

  @override
  State<GameScaffold> createState() => _GameScaffoldState();
}

class _GameScaffoldState extends State<GameScaffold> {
  late final ChickenUpGame game;

  @override
  void initState() {
    super.initState();
    game = ChickenUpGame();
    game.runState.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    final overlays = game.overlays;
    overlays.remove('menu');
    overlays.remove('hud');
    overlays.remove('gameOver');
    switch (game.runState.value) {
      case RunState.menu:
        overlays.add('menu');
      case RunState.playing:
        overlays.add('hud');
      case RunState.gameOver:
        overlays.add('gameOver');
    }
  }

  @override
  void dispose() {
    game.runState.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<ChickenUpGame>(
        game: game,
        initialActiveOverlays: const ['menu'],
        overlayBuilderMap: {
          'menu': (context, game) => Container(
                color: const Color(0xC70A0F19),
                child: MenuScreen(game: game),
              ),
          'hud': (context, game) => HudOverlay(game: game),
          'gameOver': (context, game) => GameOverOverlay(game: game),
        },
      ),
    );
  }
}

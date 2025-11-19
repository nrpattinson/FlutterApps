import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:kaiserkrieg/create_game_page.dart';
import 'package:kaiserkrieg/db.dart';
import 'package:kaiserkrieg/game.dart';
import 'package:kaiserkrieg/game_page.dart';
import 'package:kaiserkrieg/in_progress_games_page.dart';

void main() async {
  GameDatabase.instance.initialize();
  await initializeDateFormatting(Platform.localeName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Kaiserkrieg',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFB4AC8C),
            brightness: Brightness.light),
          useMaterial3: true,
        ),
      home: MyHomePage(),
      )
    );
  }
}

class MyAppState extends ChangeNotifier {
  int selectedHomePageIndex = 0;
  final logScrollController = ScrollController();
  GameState? gameState;
  Game? game;
  PlayerChoiceInfo? playerChoices;

  MyAppState();

  void pageSelected(int pageIndex) {
    selectedHomePageIndex = pageIndex;
    notifyListeners();
  }

  void newGame(GameOptions options) async {
    const scenario = Scenario.campaign;
    final random = Random();
    gameState = GameState.campaign(options, random);
    int gameId = await GameDatabase.instance.createGame(scenario.index, jsonEncode(options.toJson()), jsonEncode(gameState!.toJson()));
    game = Game(gameId, scenario, options, gameState!);
    playerChoices = await game!.play(PlayerChoice());
    selectedHomePageIndex = 2;
    notifyListeners();
  }

  void resumeGame(int gameId) async {
    final gameRecord = await GameDatabase.instance.fetchGameInProgress(gameId);
    final scenario = Scenario.values[gameRecord['scenario'] as int];
    final options = GameOptions.fromJson(jsonDecode(gameRecord['optionsJson'] as String));
    gameState = GameState.fromJson(jsonDecode(gameRecord['stateJson'] as String));
    final step = gameRecord['step'] as int;
    final subStep = gameRecord['subStep'] as int;
    final log = gameRecord['log'] as String;
    final gameJson = jsonDecode(gameRecord['gameJson'] as String);
    game = Game.saved(gameId, scenario, options, gameState!, step, subStep, log, gameJson);
    playerChoices = await game!.play(PlayerChoice());
    selectedHomePageIndex = 2;
    notifyListeners();
  }

  void duplicateGame(int gameId) async {
    await GameDatabase.instance.duplicateGame(gameId);
    notifyListeners();
  }

  void deleteGame(int gameId) async {
    await GameDatabase.instance.deleteGame(gameId);
    notifyListeners();
  }

  void madeChoice(Choice choiceId) async {
    var playerChoice = PlayerChoice();
    playerChoice.choice = choiceId;
    playerChoices = await game!.play(playerChoice);
    notifyListeners();
  }

  void choseLocation(Location locationId) async {
    var playerChoice = PlayerChoice();
    playerChoice.location = locationId;
    playerChoices = await game!.play(playerChoice);
    notifyListeners();
  }

  void chosePiece(Piece pieceId) async {
    var playerChoice = PlayerChoice();
    playerChoice.piece = pieceId;
    playerChoices = await game!.play(playerChoice);
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final selectedIndex = appState.selectedHomePageIndex;

    Widget page;
    switch (selectedIndex) {
    case 0:
      page = const CreateGamePage();
    case 1:
      page = const InProgressGamesPage();
    case 2:
      page = GamePage();
    default:
      throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: false,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.add),
                      label: Text('Create Game'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.view_list),
                      label: Text('Current Games'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.start),
                      label: Text('Play Game'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    appState.pageSelected(value);
                  },
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

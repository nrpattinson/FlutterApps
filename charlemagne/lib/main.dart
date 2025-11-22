import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:charlemagne/completed_games_page.dart';
import 'package:charlemagne/create_game_page.dart';
import 'package:charlemagne/db.dart';
import 'package:charlemagne/game.dart';
import 'package:charlemagne/game_page.dart';
import 'package:charlemagne/in_progress_games_page.dart';
import 'package:charlemagne/random.dart';

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
        title: 'Charlemagne, Master of Europe',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD2D2D2)),
          useMaterial3: true,
        ),
      home: MyHomePage(),
      )
    );
  }
}

class MyAppState extends ChangeNotifier {
  int _selectedHomePageIndex = 0;
  int? _gameId;
  Scenario? _scenario;
  GameOptions? _options;
  GameState? _gameState;
  Game? _game;
  bool _completed = false;
  String _log = '';
  int _sequence = -1;
  int _maxSequence = -1;
  PlayerChoiceInfo? _playerChoices;

  MyAppState();

  void pageSelected(int pageIndex) {
    _selectedHomePageIndex = pageIndex;
    notifyListeners();
  }

  void newGame(Scenario scenario, GameOptions options) async {
    _scenario = scenario;
    _options = options;
    final random = XorshiftRPlus();
    _gameState = GameState.setupStandard(random);
    _gameId = await GameDatabase.instance.createGame(scenario.index, jsonEncode(options.toJson()), jsonEncode(_gameState!.toJson()), jsonEncode(randomToJson(random)));
    _game = Game(_gameId!, scenario, options, _gameState!, random);
    _completed = false;
    _playerChoices = await _game!.play(PlayerChoice());
    _updateGame();
    _selectedHomePageIndex = 3;
    notifyListeners();
  }

  void resumeGame(int gameId) async {
    _gameId = gameId;
    final gameRecord = await GameDatabase.instance.fetchGameInProgress(gameId);
    _scenario = Scenario.values[gameRecord['scenario'] as int];
    _options = GameOptions.fromJson(jsonDecode(gameRecord['optionsJson'] as String));
    _gameState = GameState.fromJson(jsonDecode(gameRecord['stateJson'] as String));
    final random = randomFromJson(jsonDecode(gameRecord['randomStateJson'] as String));
    final step = gameRecord['step'] as int;
    final subStep = gameRecord['subStep'] as int;
    _log = gameRecord['log'] as String;
    _maxSequence = gameRecord['currentSequence'] as int;
    _sequence = _maxSequence;
    final gameJsonString = gameRecord['gameJson'] as String;
    if (gameJsonString != '') {
      final gameJson = jsonDecode(gameJsonString);
      _game = Game.inProgress(gameId, _scenario!, _options!, _gameState!, random, step, subStep, _log, gameJson);
    } else {
      _game = Game.snapshot(gameId, _scenario!, _options!, _gameState!, random, step, subStep, _log);
    }
    _completed = false;
    _playerChoices = await _game!.play(PlayerChoice());
    _updateGame();
    _selectedHomePageIndex = 3;
    notifyListeners();
  }

  void replayCompletedGame(int gameId) async {
    _gameId = gameId;
    final gameRecord = await GameDatabase.instance.fetchGameCompleted(gameId);
    _scenario = Scenario.values[gameRecord['scenario'] as int];
    _options = GameOptions.fromJson(jsonDecode(gameRecord['optionsJson'] as String));
    _gameState = GameState.fromJson(jsonDecode(gameRecord['stateJson'] as String));
    final random = randomFromJson(jsonDecode(gameRecord['randomStateJson'] as String));
    final step = gameRecord['step'] as int;
    final subStep = gameRecord['subStep'] as int;
    _log = gameRecord['log'] as String;
    _maxSequence = gameRecord['maximumSequence'] as int;
    _sequence = _maxSequence;
    final outcomeJson = jsonDecode(gameRecord['outcomeJson'] as String);
    _game = Game.completed(gameId, _scenario!, _options!, _gameState!, random, step, subStep, _log, outcomeJson);
    _completed = true;
    _selectedHomePageIndex = 3;
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

  void duplicateCurrentGame() async {
    if (_sequence == -1) {
      await GameDatabase.instance.duplicateGame(_gameId!);
    } else {
      await GameDatabase.instance.duplicatePartialGame(_gameId!, _sequence, _game!.log);
    }
    notifyListeners();
  }

  void firstSnapshot() async {
    _loadGameSnapshot(0);
  }

  void previousTurn() async {
    int turn = _gameState!.currentTurn;
    int targetTurn = turn;
    int sequence = _sequence;
    int snapshotTurn = turn;
    bool first = true;
    while (sequence > 0 && snapshotTurn == targetTurn) {
      sequence = sequence == -1 ? _maxSequence : sequence - 1;
      var snapshotRecord = await GameDatabase.instance.fetchGameSnapshot(_gameId!, sequence);
      snapshotTurn = snapshotRecord['turn'] as int;
      if (first) {
        if (snapshotTurn != turn) {
          targetTurn = snapshotTurn;
        }
        first = false;
      }
    }
    if (snapshotTurn != targetTurn) {
      sequence = sequence == _maxSequence ? -1 : sequence + 1;
    }
    _loadGameSnapshot(sequence);
  }

  void previousSnapshot() async {
    _loadGameSnapshot(_sequence == -1 ? _maxSequence : _sequence - 1);
  }

  void nextSnapshot() async {
    _loadGameSnapshot(_sequence == _maxSequence ? -1 : _sequence + 1);
  }

  void nextTurn() async {
    int turn = _gameState!.currentTurn;
    int sequence = _sequence;
    int snapshotTurn = turn;
    while (sequence != -1 && snapshotTurn == turn) {
      sequence = sequence == _maxSequence ? -1 : sequence + 1;
      final snapshotRecord = await GameDatabase.instance.fetchGameSnapshot(_gameId!, sequence);
      snapshotTurn = snapshotRecord['turn'] as int;
    }
    _loadGameSnapshot(sequence);
  }

  void lastSnapshot() async {
    _loadGameSnapshot(_completed ? _maxSequence : -1);
  }

  void _loadGameSnapshot(int sequence) async {
    _sequence = sequence;
    if (_sequence == -1) {
      resumeGame(_gameId!);
    } else {
      final snapshotRecord = await GameDatabase.instance.fetchGameSnapshot(_gameId!, sequence);
      final random = randomFromJson(jsonDecode(snapshotRecord['randomStateJson'] as String));
      final step = snapshotRecord['step'] as int;
      final subStep = snapshotRecord['subStep'] as int;
      final logLength = snapshotRecord['logLength'] as int;
      String log = _log.substring(0, logLength);
      _gameState = GameState.fromJson(jsonDecode(snapshotRecord['stateJson'] as String));
      _game = Game.snapshot(_gameId!, _scenario!, _options!, _gameState!, random, step, subStep, log);
      _playerChoices = null;
      notifyListeners();
    }
  }

  void madeChoice(Choice choice) async {
    var playerChoice = PlayerChoice();
    playerChoice.choice = choice;
    _playerChoices = await _game!.play(playerChoice);
    _updateGame();
    notifyListeners();
  }

  void choseLocation(Location location) async {
    var playerChoice = PlayerChoice();
    playerChoice.location = location;
    _playerChoices = await _game!.play(playerChoice);
    notifyListeners();
  }

  void chosePiece(Piece piece) async {
    var playerChoice = PlayerChoice();
    playerChoice.piece = piece;
    _playerChoices = await _game!.play(playerChoice);
    notifyListeners();
  }

  bool get previousSnapshotAvailable {
    return _sequence != 0;
  }

  bool get nextSnapshotAvailable {
    if (_sequence == -1) {
      return false;
    }
    if (_sequence + 1 < _maxSequence) {
      return true;
    }
    return !_completed;
  }

  GameState? get gameState {
    return _gameState;
  }

  Game? get game {
    return _game;
  }

  PlayerChoiceInfo? get playerChoices {
    return _playerChoices;
  }

  void _updateGame() async {
    if (_playerChoices != null) {
      final gameRecord = await GameDatabase.instance.fetchGameInProgress(_gameId!);
      _log = gameRecord['log'];
      _maxSequence = gameRecord['currentSequence'] as int;
      _sequence = -1;
    } else {
      final gameRecord = await GameDatabase.instance.fetchGameCompleted(_gameId!);
      _completed = true;
      _log = gameRecord['log'];
      _maxSequence = gameRecord['maximumSequence'] as int;
      _sequence = _maxSequence;
    }
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final selectedIndex = appState._selectedHomePageIndex;

    Widget page;
    switch (selectedIndex) {
    case 0:
      page = const CreateGamePage();
    case 1:
      page = const InProgressGamesPage();
    case 2:
      page = const CompletedGamesPage();
    case 3:
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
                      icon: Icon(Icons.list),
                      label: Text('Current Games'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.view_list),
                      label: Text('Completed Games'),
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

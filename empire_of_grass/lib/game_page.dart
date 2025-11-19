import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:empire_of_grass/game.dart';
import 'package:empire_of_grass/main.dart';
import 'package:provider/provider.dart';

enum BoardArea {
  map,
  track,
}

class GamePage extends StatelessWidget {
  static const _cardWidth = 360.0;
  static const _cardHeight = 264.0;
  static const _mapWidth = 9.0 * _cardWidth;
  static const _mapHeight = 6.0 * _cardHeight;
  static const _trackWidth = 816.0;
  static const _trackHeight = 528.0;
  final _cards = <Piece,Image>{};
  final _counters = <Piece,Image>{};
  final _backgroundImage = Image.asset('assets/images/background.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _trackImage = Image.asset('assets/images/track.png', key: UniqueKey(), width: _trackWidth, height: _trackHeight);
  final _mapStackChildren = <Widget>[];
  final _trackStackChildren = <Widget>[];

  GamePage({super.key}) {

    for (final card in PieceType.card.pieces) {
      int index = card.index - PieceType.card.firstIndex;
      String number;
      if (index == 0) {
        number = '00';
      } else {
        int value = index - 1;
        int firstDigit = (value ~/ 6) + 1;
        int secondDigit = (value % 6) + 1;
        number = '${firstDigit * 10 + secondDigit}';
      }
      final imagePath = 'assets/images/card_$number.png';
      _cards[card] = Image.asset(imagePath,
        key: UniqueKey(),
        width: 360.0,
        height: 264.0,
      );
    }

    final Map<Piece,String> counterNames = {
      Piece.mongolLightCavalry0: 'cavalry_light_mongol',
      Piece.mongolLightCavalry1: 'cavalry_light_mongol',
      Piece.mongolLightCavalry2: 'cavalry_light_mongol',
      Piece.mongolHeavyCavalry0: 'cavalry_heavy_mongol',
      Piece.mongolHeavyCavalry1: 'cavalry_heavy_mongol',
      Piece.mongolHeavyCavalry2: 'cavalry_heavy_mongol',
      Piece.khan: 'khan_mongol',
      Piece.siegeEngine0: 'siege_engine_mongol',
      Piece.siegeEngine1: 'siege_engine_mongol',
      Piece.siegeEngine2: 'siege_engine_mongol',
      Piece.goldenHordeLightCavalry0: 'cavalry_light_golden_horde',
      Piece.goldenHordeLightCavalry1: 'cavalry_light_golden_horde',
      Piece.goldenHordeHeavyCavalry0: 'cavalry_heavy_golden_horde',
      Piece.alliedRedLightCavalry0: 'cavalry_light_allied_red',
      Piece.alliedRedLightCavalry1: 'cavalry_light_allied_red',
      Piece.alliedRedLightCavalry2: 'cavalry_light_allied_red',
      Piece.alliedRedHeavyCavalry0: 'cavalry_heavy_allied_red',
      Piece.alliedRedHeavyCavalry1: 'cavalry_heavy_allied_red',
      Piece.alliedYellowLightCavalry0: 'cavalry_light_allied_yellow',
      Piece.alliedYellowLightCavalry1: 'cavalry_light_allied_yellow',
      Piece.alliedYellowLightCavalry2: 'cavalry_light_allied_yellow',
      Piece.alliedYellowHeavyCavalry0: 'cavalry_heavy_allied_yellow',
      Piece.alliedYellowHeavyCavalry1: 'cavalry_heavy_allied_yellow',
      Piece.alliedBlueLightCavalry0: 'cavalry_light_allied_blue',
      Piece.alliedBlueLightCavalry1: 'cavalry_light_allied_blue',
      Piece.alliedBlueLightCavalry2: 'cavalry_light_allied_blue',
      Piece.alliedBlueHeavyCavalry0: 'cavalry_heavy_allied_blue',
      Piece.alliedBlueHeavyCavalry1: 'cavalry_heavy_allied_blue',
      Piece.enemyLightCavalry1_0: 'cavalry_light_enemy_1',
      Piece.enemyLightCavalry1_1: 'cavalry_light_enemy_1',
      Piece.enemyLightCavalry1_2: 'cavalry_light_enemy_1',
      Piece.enemyLightCavalry1_3: 'cavalry_light_enemy_1',
      Piece.enemyHeavyCavalry1_0: 'cavalry_heavy_enemy_1',
      Piece.enemyHeavyCavalry1_1: 'cavalry_heavy_enemy_1',
      Piece.enemyHeavyCavalry1_2: 'cavalry_heavy_enemy_1',
      Piece.enemyLightCavalry2_0: 'cavalry_light_enemy_2',
      Piece.enemyLightCavalry2_1: 'cavalry_light_enemy_2',
      Piece.enemyLightCavalry2_2: 'cavalry_light_enemy_2',
      Piece.enemyLightCavalry2_3: 'cavalry_light_enemy_2',
      Piece.enemyHeavyCavalry2_0: 'cavalry_heavy_enemy_2',
      Piece.enemyHeavyCavalry2_1: 'cavalry_heavy_enemy_2',
      Piece.enemyHeavyCavalry2_2: 'cavalry_heavy_enemy_2',
      Piece.enemyRedLightCavalry0: 'cavalry_enemy_light_red',
      Piece.enemyRedLightCavalry1: 'cavalry_enemy_light_red',
      Piece.enemyRedLightCavalry2: 'cavalry_enemy_light_red',
      Piece.enemyRedHeavyCavalry0: 'cavalry_enemy_heavy_red',
      Piece.enemyRedHeavyCavalry1: 'cavalry_enemy_heavy_red',
      Piece.enemyYellowLightCavalry0: 'cavalry_enemy_light_yellow',
      Piece.enemyYellowLightCavalry1: 'cavalry_enemy_light_yellow',
      Piece.enemyYellowLightCavalry2: 'cavalry_enemy_light_yellow',
      Piece.enemyYellowHeavyCavalry0: 'cavalry_enemy_heavy_yellow',
      Piece.enemyYellowHeavyCavalry1: 'cavalry_enemy_heavy_yellow',
      Piece.enemyBlueLightCavalry0: 'cavalry_enemy_light_blue',
      Piece.enemyBlueLightCavalry1: 'cavalry_enemy_light_blue',
      Piece.enemyBlueLightCavalry2: 'cavalry_enemy_light_blue',
      Piece.enemyBlueHeavyCavalry0: 'cavalry_enemy_heavy_blue',
      Piece.enemyBlueHeavyCavalry1: 'cavalry_enemy_heavy_blue',
      Piece.enemyInfantry1_0: 'infantry_enemy_1',
      Piece.enemyInfantry1_1: 'infantry_enemy_1',
      Piece.enemyInfantry1_2: 'infantry_enemy_1',
      Piece.enemyInfantry1_3: 'infantry_enemy_1',
      Piece.enemyInfantry1_4: 'infantry_enemy_1',
      Piece.enemyInfantry1_5: 'infantry_enemy_1',
      Piece.enemyInfantry1_6: 'infantry_enemy_1',
      Piece.enemyInfantry1_7: 'infantry_enemy_1',
      Piece.enemyInfantry1_8: 'infantry_enemy_1',
      Piece.enemyInfantry1_9: 'infantry_enemy_1',
      Piece.enemyInfantry1_10: 'infantry_enemy_1',
      Piece.enemyInfantry1_11: 'infantry_enemy_1',
      Piece.enemyInfantry1_12: 'infantry_enemy_1',
      Piece.enemyInfantry2_0: 'infantry_enemy_2',
      Piece.enemyInfantry2_1: 'infantry_enemy_2',
      Piece.enemyInfantry2_2: 'infantry_enemy_2',
      Piece.enemyInfantry2_3: 'infantry_enemy_2',
      Piece.enemyInfantry2_4: 'infantry_enemy_2',
      Piece.enemyInfantry2_5: 'infantry_enemy_2',
      Piece.enemyInfantry2_6: 'infantry_enemy_2',
      Piece.enemyInfantry2_7: 'infantry_enemy_2',
      Piece.enemyInfantry2_8: 'infantry_enemy_2',
      Piece.enemyInfantry2_9: 'infantry_enemy_2',
      Piece.enemyInfantry2_10: 'infantry_enemy_2',
      Piece.enemyInfantry2_11: 'infantry_enemy_2',
      Piece.enemyInfantry2_12: 'infantry_enemy_2',
      Piece.city0: 'city',
      Piece.city1: 'city',
      Piece.city2: 'city',
      Piece.city3: 'city',
      Piece.city4: 'city',
      Piece.city5: 'city',
      Piece.city6: 'city',
      Piece.city7: 'city',
      Piece.city8: 'city',
      Piece.city9: 'city',
      Piece.city10: 'city',
      Piece.city11: 'city',
      Piece.city12: 'city',
      Piece.city13: 'city',
      Piece.city14: 'city',
      Piece.city15: 'city',
      Piece.city16: 'city',
      Piece.city17: 'city',
      Piece.city18: 'city',
      Piece.city19: 'city',
      Piece.city20: 'city',
      Piece.city21: 'city',
      Piece.city22: 'city',
      Piece.city23: 'city',
      Piece.city24: 'city',
      Piece.city25: 'city',
      Piece.city26: 'city',
      Piece.city27: 'city',
      Piece.razed0: 'city_razed',
      Piece.razed1: 'city_razed',
      Piece.razed2: 'city_razed',
      Piece.razed3: 'city_razed',
      Piece.razed4: 'city_razed',
      Piece.razed5: 'city_razed',
      Piece.razed6: 'city_razed',
      Piece.razed7: 'city_razed',
      Piece.razed8: 'city_razed',
      Piece.razed9: 'city_razed',
      Piece.razed10: 'city_razed',
      Piece.razed11: 'city_razed',
      Piece.razed12: 'city_razed',
      Piece.razed13: 'city_razed',
      Piece.razed14: 'city_razed',
      Piece.razed15: 'city_razed',
      Piece.razed16: 'city_razed',
      Piece.razed17: 'city_razed',
      Piece.razed18: 'city_razed',
      Piece.razed19: 'city_razed',
      Piece.razed20: 'city_razed',
      Piece.razed21: 'city_razed',
      Piece.razed22: 'city_razed',
      Piece.razed23: 'city_razed',
      Piece.siege0: 'siege',
      Piece.siege1: 'siege',
      Piece.siege2: 'siege',
      Piece.siege3: 'siege',
      Piece.gold1_0: 'gold_1',
      Piece.gold1_1: 'gold_1',
      Piece.gold1_2: 'gold_1',
      Piece.gold1_3: 'gold_1',
      Piece.gold1_4: 'gold_1',
      Piece.gold5_0: 'gold_5',
      Piece.gold5_1: 'gold_5',
      Piece.gold5_2: 'gold_5',
      Piece.gold2_0: 'gold_2',
      Piece.gold2_1: 'gold_2',
      Piece.gold2_2: 'gold_2',
      Piece.gold2_3: 'gold_2',
      Piece.gold2_4: 'gold_2',
      Piece.gold10_0: 'gold_10',
      Piece.gold10_1: 'gold_10',
      Piece.gold10_2: 'gold_10',
      Piece.badTerrainP1_0: 'bad_terrain_1',
      Piece.badTerrainP1_1: 'bad_terrain_1',
      Piece.badTerrainP1_2: 'bad_terrain_1',
      Piece.badTerrainP2_0: 'bad_terrain_2',
      Piece.badTerrainP2_1: 'bad_terrain_2',
      Piece.badTerrainP2_2: 'bad_terrain_2',
      Piece.markerTurn: 'marker_turn',
    };

    for (final counterName in counterNames.entries) {
      final imagePath = 'assets/images/${counterName.value}.png';
      _counters[counterName.key] = Image.asset(imagePath,
        key: UniqueKey(),
        width: 60.0,
        height: 60.0,
      );
    }
  }

  void addCardToMap(MyAppState appState, Piece card, double x, double y) {
    final playerChoices = appState.playerChoices;

    bool choosable = playerChoices != null && playerChoices.pieces.contains(card);
    bool selected = playerChoices != null && playerChoices.selectedPieces.contains(card);

    Widget widget = _cards[card]!;
    
    double borderWidth = 0.0;

    if (choosable) {
      widget = Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.yellow, width: 5.0),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: widget,
      );
      borderWidth += 5.0;
    } else if (selected) {
      widget = Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.red, width: 5.0),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: widget,
      );
      borderWidth += 5.0;
    }

    if (choosable) {
      widget = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            appState.chosePiece(card);
          },
          child: widget,
        ),
      );
    }

    widget = Positioned(
      left: x - borderWidth,
      top: y - borderWidth,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addPieceToBoard(MyAppState appState, Piece piece, BoardArea boardArea, double x, double y) {
    final playerChoices = appState.playerChoices;

    bool choosable = playerChoices != null && playerChoices.pieces.contains(piece);
    bool selected = playerChoices != null && playerChoices.selectedPieces.contains(piece);

    Widget widget = _counters[piece]!;
    
    double borderWidth = 0.0;

    if (choosable) {
      widget = Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.yellow, width: 5.0),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: widget,
      );
      borderWidth += 5.0;
    } else if (selected) {
      widget = Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.red, width: 5.0),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: widget,
      );
      borderWidth += 5.0;
    } else {
      widget = Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.black,
            width: 1.0),
        ),
        child: widget,
      );
      borderWidth += 1.0;
    }

    if (choosable) {
      widget = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            appState.chosePiece(piece);
          },
          child: widget,
        ),
      );
    }

    widget = Positioned(
      left: x - borderWidth,
      top: y - borderWidth,
      child: widget,
    );

    switch (boardArea) {
    case BoardArea.map:
      _mapStackChildren.add(widget);
    case BoardArea.track:
      _trackStackChildren.add(widget);
    }
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.turn1: (BoardArea.track, 339.0, 20.0),
    };
    return coordinates[location]!;
  }

  void layoutMapLocation(MyAppState appState, Location location) {
    final state = appState.gameState!;
    int col = state.mapColumn(location);
    int row = state.mapRow(location);
    double xCard = col * _cardWidth;
    double yCard = row * _cardHeight;
    double xCounters = xCard + 54.0;
    double yCounters = yCard + 55.0;
    final pieces = state.piecesInLocation(PieceType.counter, location);
    for (int i = 0; i < pieces.length; ++i) {
      final piece = pieces[i];
      int col = i % 4;
      int row = i ~/ 4;
      double x = xCounters + col * 65.0;
      double y = yCounters + row * 65.0;
      addPieceToBoard(appState, piece, BoardArea.map, x, y);
    }
  }

  void layoutMap(MyAppState appState) {
    final state = appState.gameState!;
    for (final card in PieceType.card.pieces) {
      final location = state.pieceLocation(card);
      if (location.isType(LocationType.map)) {
        int col = state.mapColumn(location);
        int row = state.mapRow(location);
        double x = col * _cardWidth;
        double y = row * _cardHeight;
        addCardToMap(appState, card, x, y);
        layoutMapLocation(appState, location);
      }
    }
  }

  void layoutTurn(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.turn1);
    double xFirst = firstCoordinates.$2;
    double yFirst = firstCoordinates.$3;
    final box = state.pieceLocation(Piece.markerTurn);
    final index = box.index - Location.turn1.index;
    int col = index % 7;
    int row = index ~/ 7;
    double x = xFirst + col * 65.0;
    double y = yFirst + row * 65.0;
    addPieceToBoard(appState, Piece.markerTurn, BoardArea.track, x, y);
  }
  
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final gameState = appState.gameState;
    final playerChoices = appState.playerChoices;

    final choiceWidgets = <Widget>[];

    String log = '';

    if (appState.game != null) {
      log = appState.game!.log;
    }

    _mapStackChildren.clear();
    _mapStackChildren.add(_backgroundImage);
    _trackStackChildren.clear();
    _trackStackChildren.add(_trackImage);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutMap(appState);
      layoutTurn(appState);

      const choiceTexts = {
        Choice.mongolLightCavalry: 'Mongol Light Cavalry',
        Choice.mongolHeavyCavalry: 'Mongol Heavy Cavalry',
        Choice.alliedRedLightCavalry: 'Red Allied Light Cavalry',
        Choice.alliedRedHeavyCavalry: 'Red Allied Heavy Cavalry',
        Choice.alliedYellowLightCavalry: 'Yellow Allied Light Cavalry',
        Choice.alliedYellowHeavyCavalry: 'Yellow Allied Heavy Cavalry',
        Choice.alliedBlueLightCavalry: 'Blue Allied Light Cavalry',
        Choice.alliedBlueHeavyCavalry: 'Blue Allied Heavy Cavalry',
        Choice.siegeEngine: 'Siege Engine ',
        Choice.yes: 'Yes',
        Choice.no: 'No',
        Choice.cancel: 'Cancel',
        Choice.next: 'Next',
      };

      if (playerChoices != null) {

        choiceWidgets.add(
          Text(
            style: textTheme.titleMedium,
            playerChoices.prompt));

        choiceWidgets.add(
          Divider(
            color: colorScheme.outlineVariant,
          )
        );

        for (final choice in playerChoices.choices) {
          choiceWidgets.add(
            ElevatedButton(
              onPressed: playerChoices.disabledChoices.contains(choice) ? null : () {
                appState.madeChoice(choice);
              },
              child: Text(
                style: textTheme.labelLarge,
                choiceTexts[choice]!),
            )
          );
        }
      }
    }

    final rootWidget = MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10.0,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: choiceWidgets,
            ),
          ),
          Expanded(
            child: InteractiveViewer(
              constrained: false,
              minScale: 0.1,
              maxScale: 1.5,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _mapWidth + _trackWidth,
                  height: _mapHeight,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0.0,
                        top: 0.0,
                        child: Stack(children: _mapStackChildren),
                      ),
                      Positioned(
                        left: _mapWidth,
                        top: 0.0,
                        child: Stack(children: _trackStackChildren),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 400.0,
            child: DecoratedBox(
              decoration: BoxDecoration(color: colorScheme.surface),
              child: Markdown(
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  h1: textTheme.headlineMedium,
                  h1Align: WrapAlignment.center,
                  h1Padding: const EdgeInsets.all(5.0),
                  h2: textTheme.titleLarge,
                  h2Align: WrapAlignment.center,
                  h2Padding: const EdgeInsets.all(3.0),
                  h3: textTheme.bodyLarge,
                  blockquote: textTheme.bodyMedium,
                  blockquoteDecoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                  ),
                  strong: textTheme.headlineMedium,
                ),
                controller: appState.logScrollController,
                data: log,
              ),
            ),
          ),
        ],
      ),
    );

    if (appState.logScrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appState.logScrollController.jumpTo(appState.logScrollController.position.maxScrollExtent);
      });
    }

    return rootWidget;
  }
}

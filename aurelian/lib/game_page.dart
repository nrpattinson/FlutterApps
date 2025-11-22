import 'dart:math';
import 'package:flutter/material.dart';
import 'package:aurelian/game.dart';
import 'package:aurelian/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

enum BoardArea {
  map,
}

class GamePage extends StatefulWidget {

  const GamePage({super.key});

  @override
  GamePageState createState() {
    return GamePageState();
  }
}

class GamePageState extends State<GamePage> {
  static const _mapWidth = 2112.0;
  static const _mapHeight = 1632.0;
  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _mapStackChildren = <Widget>[];

  final _logScrollController = ScrollController();

  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.germania0: 'enemy_resistance_germania_2',
      Piece.germania1: 'enemy_resistance_germania_3',
      Piece.noricum0: 'enemy_resistance_noricum_2',
      Piece.noricum1: 'enemy_resistance_noricum_3',
      Piece.ravenna0: 'enemy_resistance_ravenna_2',
      Piece.ravenna1: 'enemy_resistance_ravenna_3',
      Piece.roma0: 'enemy_resistance_roma_2',
      Piece.roma1: 'enemy_resistance_roma_2',
      Piece.roma2: 'enemy_resistance_roma_3',
      Piece.aquitania0: 'enemy_resistance_aquitania_2',
      Piece.aquitania1: 'enemy_resistance_aquitania_3',
      Piece.belgica0: 'enemy_resistance_belgica_4',
      Piece.belgica1: 'enemy_resistance_belgica_4',
      Piece.belgica2: 'enemy_resistance_belgica_5',
      Piece.britannia0: 'enemy_resistance_brittania_4',
      Piece.britannia1: 'enemy_resistance_brittania_4',
      Piece.britannia2: 'enemy_resistance_brittania_5',
      Piece.gallia0: 'enemy_resistance_gallia_3',
      Piece.gallia1: 'enemy_resistance_gallia_4',
      Piece.byzantium0: 'enemy_resistance_byzantium_4',
      Piece.byzantium1: 'enemy_resistance_byzantium_4',
      Piece.byzantium2: 'enemy_resistance_byzantium_5',
      Piece.dalmatia0: 'enemy_resistance_dalmatia_3',
      Piece.dalmatia1: 'enemy_resistance_dalmatia_4',
      Piece.moesia0: 'enemy_resistance_moesia_3',
      Piece.moesia1: 'enemy_resistance_moesia_4',
      Piece.pannonia0: 'enemy_resistance_pannonia_3',
      Piece.pannonia1: 'enemy_resistance_pannonia_4',
      Piece.aegyptus0: 'enemy_resistance_aegyptus_3',
      Piece.aegyptus1: 'enemy_resistance_aegyptus_4',
      Piece.antiochia0: 'enemy_resistance_antiochia_4',
      Piece.antiochia1: 'enemy_resistance_antiochia_5',
      Piece.judaea0: 'enemy_resistance_judaea_5',
      Piece.judaea1: 'enemy_resistance_judaea_5',
      Piece.judaea2: 'enemy_resistance_judaea_6',
      Piece.nicomedia0: 'enemy_resistance_nicomedia_3',
      Piece.nicomedia1: 'enemy_resistance_nicomedia_4',
      Piece.palmyra0: 'enemy_resistance_palmyra_5',
      Piece.palmyra1: 'enemy_resistance_palmyra_5',
      Piece.palmyra2: 'enemy_resistance_palmyra_6',
      Piece.tyana0: 'enemy_resistance_tyana_3',
      Piece.tyana1: 'enemy_resistance_tyana_4',
      Piece.barbarian0: 'barbarian_4',
      Piece.barbarian1: 'barbarian_4',
      Piece.barbarian2: 'barbarian_4',
      Piece.barbarian3: 'barbarian_5',
      Piece.barbarian4: 'barbarian_5',
      Piece.barbarian5: 'barbarian_6',
      Piece.barbarian6: 'barbarian_6',
      Piece.barbarian7: 'barbarian_7',
      Piece.barbarian8: 'barbarian_7',
      Piece.red0: 'enemy_combat_red_1',
      Piece.red1: 'enemy_combat_red_2',
      Piece.red2: 'enemy_combat_red_1',
      Piece.red3: 'enemy_combat_red_2',
      Piece.red4: 'enemy_combat_red_1',
      Piece.red5: 'enemy_combat_red_2',
      Piece.red6: 'enemy_combat_red_1',
      Piece.red7: 'enemy_combat_red_1',
      Piece.red8: 'enemy_combat_red_2',
      Piece.blue0: 'enemy_combat_blue_1',
      Piece.blue1: 'enemy_combat_blue_2',
      Piece.blue2: 'enemy_combat_blue_2',
      Piece.blue3: 'enemy_combat_blue_2',
      Piece.blue4: 'enemy_combat_blue_3',
      Piece.blue5: 'enemy_combat_blue_2',
      Piece.blue6: 'enemy_combat_blue_2',
      Piece.blue7: 'enemy_combat_blue_3',
      Piece.blue8: 'enemy_combat_blue_1',
      Piece.blue9: 'enemy_combat_blue_2',
      Piece.green0: 'enemy_combat_green_2',
      Piece.green1: 'enemy_combat_green_2',
      Piece.green2: 'enemy_combat_green_3',
      Piece.green3: 'enemy_combat_green_1',
      Piece.green4: 'enemy_combat_green_2',
      Piece.green5: 'enemy_combat_green_1',
      Piece.green6: 'enemy_combat_green_1',
      Piece.green7: 'enemy_combat_green_1',
      Piece.green8: 'enemy_combat_green_2',
      Piece.yellow0: 'enemy_combat_yellow_1',
      Piece.yellow1: 'enemy_combat_yellow_2',
      Piece.yellow2: 'enemy_combat_yellow_2',
      Piece.yellow3: 'enemy_combat_yellow_2',
      Piece.yellow4: 'enemy_combat_yellow_2',
      Piece.yellow5: 'enemy_combat_yellow_2',
      Piece.yellow6: 'enemy_combat_yellow_3',
      Piece.yellow7: 'enemy_combat_yellow_1',
      Piece.yellow8: 'enemy_combat_yellow_2',
      Piece.yellow9: 'enemy_combat_yellow_2',
      Piece.yellow10: 'enemy_combat_yellow_2',
      Piece.yellow11: 'enemy_combat_yellow_3',
      Piece.yellow12: 'enemy_combat_yellow_1',
      Piece.yellow13: 'enemy_combat_yellow_2',
      Piece.usurperRed: 'usurper_red',
      Piece.usurperBlue: 'usurper_blue',
      Piece.usurperBluePostumus: 'usurper_blue_postumus',
      Piece.usurperGreen: 'usurper_green',
      Piece.usurperYellow: 'usurper_yellow',
      Piece.usurperYellowZenobia: 'usurper_yellow_zenobia',
      Piece.barbarianConfederation: 'barbarian_confederation',
      Piece.sassanid: 'sassanid',
      Piece.legion0: 'legion_2',
      Piece.legion1: 'legion_2',
      Piece.legion2: 'legion_2',
      Piece.legion3: 'legion_2',
      Piece.legion4: 'legion_2',
      Piece.legion5: 'legion_2',
      Piece.legion6: 'legion_2',
      Piece.legion7: 'legion_2',
      Piece.legion8: 'legion_3',
      Piece.legion9: 'legion_3',
      Piece.legion10: 'legion_3',
      Piece.legion11: 'legion_3',
      Piece.legion12: 'legion_3',
      Piece.legion13: 'legion_3',
      Piece.legion14: 'legion_3',
      Piece.legion15: 'legion_3',
      Piece.leaderAurelianP1: 'aurelian_1',
      Piece.leaderAurelianP2: 'aurelian_2',
      Piece.leaderOfficer0: 'officer',
      Piece.leaderOfficer1: 'officer',
      Piece.walls0: 'walls_1',
      Piece.walls1: 'walls_1',
      Piece.walls2: 'walls_1',
      Piece.walls3: 'walls_3',
      Piece.walls4: 'walls_3',
      Piece.walls5: 'walls_3',
      Piece.templeStart0: 'temple_start',
      Piece.templeStart1: 'temple_start',
      Piece.templeStart2: 'temple_start',
      Piece.templeStart3: 'temple_start',
      Piece.templeFinished0: 'temple_finished',
      Piece.templeFinished1: 'temple_finished',
      Piece.templeFinished2: 'temple_finished',
      Piece.templeFinished3: 'temple_finished',
      Piece.turnEnd0: 'turn_end',
      Piece.turnEnd1: 'turn_end',
      Piece.turnEnd2: 'turn_end',
      Piece.markerGameTurn: 'marker_game_turn',
      Piece.markerIncome: 'marker_income',
      Piece.markerTreasury: 'marker_treasury',
      Piece.markerArmyStrength: 'marker_army_strength',
      Piece.markerVictoryPoints1: 'marker_victory',
      Piece.markerVictoryPoints10: 'marker_victory',
      Piece.markerAurelianWalls: 'marker_aurelian_walls',
    };

    for (final counterName in counterNames.entries) {
      final imagePath = 'assets/images/${counterName.value}.png';
      _counters[counterName.key] = Image.asset(imagePath,
        key: UniqueKey(),
        width: 60.0, height:60.0,
      );
    }
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
    }
  }

  void addBoxToMap(MyAppState appState, Location box, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(box);
    bool selected = playerChoices.selectedLocations.contains(box);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = const SizedBox(
      height: 130.0,
      width: 130.0,
    );

    final boxDecoration = BoxDecoration(
      shape: BoxShape.rectangle,
      color: Colors.transparent,
      border: Border.all(color: choosable ? Colors.red : Colors.green, width: 5.0),
      borderRadius: BorderRadius.circular(10.0),
    );

    widget = Container(
      decoration: boxDecoration,
      child: widget,
    );

    if (choosable) {
      widget = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            appState.choseLocation(box);
          },
          child: widget,
        ),
      );
    }

    widget = Positioned(
      left: x - 72.0,
      top: y - 72.0,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.germania: (BoardArea.map, 581.0, 438.0),
      Location.noricum: (BoardArea.map, 790.0, 445.0),
      Location.ravenna: (BoardArea.map, 675.0, 629.0),
      Location.roma: (BoardArea.map, 665.0, 804.0),
      Location.aquitania: (BoardArea.map, 140.0, 454.0),
      Location.belgica: (BoardArea.map, 310.0, 156.0),
      Location.britannia: (BoardArea.map, 180.0, 57.0),
      Location.gallia: (BoardArea.map, 428.0, 425.0),
      Location.byzantium: (BoardArea.map, 0.0, 0.0),
      Location.dalmatia: (BoardArea.map, 0.0, 0.0),
      Location.moesia: (BoardArea.map, 1158.0, 752.0),
      Location.pannonia: (BoardArea.map, 0.0, 0.0),
      Location.aegyptus: (BoardArea.map, 1429.0, 1488.0),
      Location.antiochia: (BoardArea.map, 1882.0, 1095.0),
      Location.judaea: (BoardArea.map, 1812.0, 1366.0),
      Location.nicomedia: (BoardArea.map, 1678.0, 828.0),
      Location.palmyra: (BoardArea.map, 1962.0, 1230.0),
      Location.tyana: (BoardArea.map, 1750.0, 975.0),
      Location.front1: (BoardArea.map, 0.0, 0.0),
      Location.front2: (BoardArea.map, 0.0, 0.0),
      Location.front3: (BoardArea.map, 772.0, 274.0),
      Location.front4: (BoardArea.map, 954.0, 333.0),
      Location.front5: (BoardArea.map, 1092.0, 365.0),
      Location.front6: (BoardArea.map, 1115.0, 538.0),
      Location.front7: (BoardArea.map, 1357.0, 643.0),
      Location.front8: (BoardArea.map, 1599.0, 620.0),
      Location.aurelianWallsN2: (BoardArea.map, 566.0, 761.0),
      Location.aurelianWallsN1: (BoardArea.map, 0.0, 0.0),
      Location.aurelianWallsZ: (BoardArea.map, 0.0, 0.0),
      Location.aurelianWallsP1: (BoardArea.map, 0.0, 0.0),
      Location.aurelianWallsP2: (BoardArea.map, 0.0, 0.0),
      Location.aurelianWallsP3: (BoardArea.map, 0.0, 0.0),
      Location.aurelianWallsP4: (BoardArea.map, 0.0, 0.0),
      Location.usurperRed: (BoardArea.map, 0.0, 0.0),
      Location.usurperBlue: (BoardArea.map, 143.5, 216.0),
      Location.usurperGreen: (BoardArea.map, 0.0, 0.0),
      Location.usurperYellow: (BoardArea.map, 1705.0, 1159.0),
      Location.boxArmyStrength0: (BoardArea.map, 710.0, 1166.0),
      Location.boxIncome0: (BoardArea.map, 47.0, 805.0),
      Location.boxVictory0: (BoardArea.map, 551.0, 1298.5),
      Location.boxVictory00: (BoardArea.map, 551.0, 1377.5),
      Location.boxTurn1: (BoardArea.map, 698.0, 1504.0),
    };
    return coordinates[location]!;
  }

  void layoutSpace(MyAppState appState, Location box) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(box);
    final xBox = coordinates.$2;
    final yBox = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(box)) {
      addBoxToMap(appState, box, xBox, yBox);
    }

    final enemyUnits = state.piecesInLocation(PieceType.mapEnemyUnit, box);
    int pieceCount = 0;
    for (int depth = 0; depth < enemyUnits.length; ++depth) {
      for (int i = 0; i < enemyUnits.length; ++i) {
        final enemyUnit = enemyUnits[i];
        if (enemyUnit.isType(PieceType.mapResistance) && state.resistanceStackDepth(enemyUnit) == depth) {
          addPieceToBoard(appState, enemyUnit, BoardArea.map, xBox + 4.0 * pieceCount, yBox + 4.0 * pieceCount);
          pieceCount += 1;
          break;
        }
      }
    }
    for (int i = 0; i < enemyUnits.length; ++i) {
      final enemyUnit = enemyUnits[i];
      if (!enemyUnit.isType(PieceType.mapResistance)) {
        addPieceToBoard(appState, enemyUnit, BoardArea.map, xBox + 4.0 * pieceCount, yBox + 4.0 * pieceCount);
        pieceCount += 1;
      }
    }
 
    final leader = state.pieceInLocation(PieceType.mapLeader, box);
    if (leader != null) {
      addPieceToBoard(appState, leader, BoardArea.map, xBox + 4.0 * pieceCount, yBox + 4.0 * pieceCount);
    }

    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(box)) {
      addBoxToMap(appState, box, xBox, yBox);
    }
  }

  void layoutSpaces(MyAppState appState) {
    for (final box in LocationType.space.locations) {
      layoutSpace(appState, box);
    }
  }

  void layoutBoxes(MyAppState appState) {
    const boxesInfo = {
      Location.front1: (1, 1, 0.0, 0.0),
      Location.front2: (1, 1, 0.0, 0.0),
      Location.front3: (1, 1, 0.0, 0.0),
      Location.front4: (1, 1, 0.0, 0.0),
      Location.front5: (1, 1, 0.0, 0.0),
      Location.front6: (1, 1, 0.0, 0.0),
      Location.front7: (1, 1, 0.0, 0.0),
      Location.front8: (1, 1, 0.0, 0.0),
      Location.aurelianWallsN2: (1, 1, 0.0, 0.0),
      Location.aurelianWallsN1: (1, 1, 0.0, 0.0),
      Location.aurelianWallsZ: (1, 1, 0.0, 0.0),
      Location.aurelianWallsP1: (1, 1, 0.0, 0.0),
      Location.aurelianWallsP2: (1, 1, 0.0, 0.0),
      Location.aurelianWallsP3: (1, 1, 0.0, 0.0),
      Location.aurelianWallsP4: (1, 1, 0.0, 0.0),
      Location.usurperRed: (1, 1, 0.0, 0.0),
      Location.usurperBlue: (1, 1, 0.0, 0.0),
      Location.usurperGreen: (1, 1, 0.0, 0.0),
      Location.usurperYellow: (1, 1, 0.0, 0.0),
    };

    final state = appState.gameState!;
    for (final box in boxesInfo.keys) {
      final coordinates = locationCoordinates(box);
      final boardArea  = coordinates.$1;
      double xBox = coordinates.$2;
      double yBox = coordinates.$3;
      final info = boxesInfo[box]!;
      int cols = info.$1;
      int rows = info.$2;
      double xGap = info.$3;
      double yGap = info.$4;
      final pieces = state.piecesInLocation(PieceType.all, box);
      int cells = cols * rows;
      int layers = (pieces.length + cells - 1) ~/ cells;
      for (int i = 0; i < pieces.length; ++i) {
        int col = i % cols;
        int row = (i % cells) ~/ cols;
        int depth = i ~/ cells;
        double x = xBox + col * (60.0 + xGap) - (layers - 1) * 2.0 + depth * 4.0;
        double y = yBox + row * (60.0 + yGap) - (layers - 1) * 2.0 + depth * 4.0;
        addPieceToBoard(appState, pieces[i], boardArea, x, y);
      }
    }
  }

  void layoutIncomeTrack(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.boxIncome0);
    final xFirst = firstCoordinates.$2;
    final yFirst = firstCoordinates.$3;
    for (final box in LocationType.income.locations) {
      int index = box.index - LocationType.income.firstIndex;
      int col = index % 5;
      int row = index ~/ 5;
      final xBox = xFirst + col * 79.0;
      final yBox = yFirst + row * 78.0;
      final pieces = state.piecesInLocation(PieceType.all, box);
      for (int i = 0; i < pieces.length; ++i) {
        addPieceToBoard(appState, pieces[i], BoardArea.map, xBox + i * 4.0, yBox + i * 4.0);
      }
    }
  }

  void layoutArmyStrengthTrack(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.boxArmyStrength0);
    final xFirst = firstCoordinates.$2;
    final yBox = firstCoordinates.$3;
    final box = state.pieceLocation(Piece.markerArmyStrength);
    int index = box.index - LocationType.armyStrength.firstIndex;
    final xBox = xFirst + index * 78.5;
    addPieceToBoard(appState, Piece.markerArmyStrength, BoardArea.map, xBox, yBox);
  }

  void layoutVictoryTrack(MyAppState appState) {
    final state = appState.gameState!;
    final onesFirstCoordinates = locationCoordinates(Location.boxVictory0);
    final xOnesFirst = onesFirstCoordinates.$2;
    final yOnes = onesFirstCoordinates.$3;
    final onesBox = state.pieceLocation(Piece.markerVictoryPoints1);
    int onesIndex = onesBox.index - Location.boxVictory0.index;
    final xOnes = xOnesFirst + onesIndex * 78.5;
    addPieceToBoard(appState, Piece.markerVictoryPoints1, BoardArea.map, xOnes, yOnes);
    final tensFirstCoordinates = locationCoordinates(Location.boxVictory00);
    final xTensFirst = tensFirstCoordinates.$2;
    final yTens = tensFirstCoordinates.$3;
    final tensBox = state.pieceLocation(Piece.markerVictoryPoints10);
    int tensIndex = tensBox.index - Location.boxVictory00.index;
    final xTens = xTensFirst + tensIndex * 78.5;
    addPieceToBoard(appState, Piece.markerVictoryPoints10, BoardArea.map, xTens, yTens);
  }

  void layoutTurnTrack(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.boxTurn1);
    final xFirst = firstCoordinates.$2;
    final yBox = firstCoordinates.$3;
    for (final box in LocationType.turn.locations) {
      int index = box.index - LocationType.turn.firstIndex;
      final xBox = xFirst + index * 79.0;
      final pieces = state.piecesInLocation(PieceType.all, box);
      for (int i = 0; i < pieces.length; ++i) {
        addPieceToBoard(appState, pieces[i], BoardArea.map, xBox + i * 4.0, yBox + i * 4.0);
      }
    }
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
    _mapStackChildren.add(_mapImage);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutSpaces(appState);
      layoutBoxes(appState);
      layoutIncomeTrack(appState);
      layoutArmyStrengthTrack(appState);
      layoutVictoryTrack(appState);
      layoutTurnTrack(appState);

      const choiceTexts = {
        Choice.actionSuppress: 'Suppress',
        Choice.actionPlacate: 'Placate',
        Choice.actionAssign: 'Assign',
        Choice.actionRedeploy: 'Redeploy',
        Choice.actionCampaign: 'Campaign',
        Choice.actionBattle: 'Battle',
        Choice.actionSiege: 'Siege',
        Choice.actionMarch: 'March',
        Choice.loseVP: 'Lose VP',
        Choice.loseCoin: 'Lose Coin',
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
        children: [
          SizedBox(
            width: 400.0,
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
                  width: _mapWidth,
                  height: _mapHeight,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0.0,
                        top: 0.0,
                        child: Stack(children: _mapStackChildren),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 500.0,
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
                controller: _logScrollController,
                data: log,
              ),
            ),
          ),
        ],
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        if (!_hadPlayerChoices || playerChoices == null) {
          _logScrollController.jumpTo(_logScrollController.position.maxScrollExtent + 1000000.0);
        } else {
          final position = _logScrollController.position;
          final distance = position.maxScrollExtent - position.pixels;
          if (distance > 0.0) {
            final newPosition = position.maxScrollExtent + 10000.0;
            if (distance == 0) {
              position.jumpTo(newPosition);
            } else {
              final animateTimeMs = min(100.0 * sqrt(distance), 2.5);
              position.animateTo(
                newPosition,
                duration: Duration(milliseconds: animateTimeMs.toInt()),
                curve: Curves.ease);
            }
          }
        }
      }
      _hadPlayerChoices = playerChoices != null;
    });

    return rootWidget;
  }
}

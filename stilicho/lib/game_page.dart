import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import 'package:stilicho/game.dart';
import 'package:stilicho/main.dart';

enum BoardArea {
  map,
  display,
}

typedef StackKey = (Location, int);

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
  static const _displayWidth = 1056.0;
  static const _displayHeight = 816.0;

  final _displayOptionsFormKey = GlobalKey<FormState>();
 
  bool _emptyMap = false;

  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _displayImage = Image.asset('assets/images/display.png', key: UniqueKey(), width: _displayWidth, height: _displayHeight);
  final _mapStackChildren = <Widget>[];
  final _displayStackChildren = <Widget>[];

  final _pieceStackKeys = <Piece,StackKey>{};
  final _expandedStacks = <StackKey>[];

  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.enemyConstantineBold: 'enemy_constantine_6_bold',
      Piece.enemyVandals0Bold: 'enemy_vandals_4_bold',
      Piece.enemyVandals1Bold: 'enemy_vandals_5_bold',
      Piece.enemyGoths0Bold: 'enemy_goths_5_bold',
      Piece.enemyGoths1Bold: 'enemy_goths_6_bold',
      Piece.enemyConstantineDemoralized: 'enemy_constantine_5_demoralized',
      Piece.enemyVandals0Demoralized: 'enemy_vandals_3_demoralized',
      Piece.enemyVandals1Demoralized: 'enemy_vandals_4_demoralized',
      Piece.enemyGoths0Demoralized: 'enemy_goths_4_demoralized',
      Piece.enemyGoths1Demoralized: 'enemy_goths_5_demoralized',
      Piece.leaderStilicho: 'leader_stilicho',
      Piece.leaderSymmachus: 'leader_symmachus',
      Piece.leaderSarus: 'leader_sarus',
      Piece.leaderConstantius: 'leader_constantius',
      Piece.comitatenses0: 'comitatenses',
      Piece.comitatenses1: 'comitatenses',
      Piece.comitatenses2: 'comitatenses',
      Piece.comitatenses3: 'comitatenses',
      Piece.comitatenses4: 'comitatenses',
      Piece.comitatenses5: 'comitatenses',
      Piece.comitatenses6: 'comitatenses',
      Piece.comitatenses7: 'comitatenses',
      Piece.comitatenses8: 'comitatenses',
      Piece.comitatenses9: 'comitatenses',
      Piece.comitatenses10: 'comitatenses',
      Piece.comitatenses11: 'comitatenses',
      Piece.comitatenses12: 'comitatenses',
      Piece.comitatenses13: 'comitatenses',
      Piece.garrison0: 'garrison',
      Piece.garrison1: 'garrison',
      Piece.garrison2: 'garrison',
      Piece.garrison3: 'garrison',
      Piece.garrison4: 'garrison',
      Piece.garrison5: 'garrison',
      Piece.garrison6: 'garrison',
      Piece.garrison7: 'garrison',
      Piece.garrison8: 'garrison',
      Piece.garrison9: 'garrison',
      Piece.garrison10: 'garrison',
      Piece.garrison11: 'garrison',
      Piece.garrison12: 'garrison',
      Piece.garrison13: 'garrison',
      Piece.olympius1: 'olympius_1',
      Piece.olympius2: 'olympius_2',
      Piece.unrest0: 'unrest',
      Piece.unrest1: 'unrest',
      Piece.unrest2: 'unrest',
      Piece.unrest3: 'unrest',
      Piece.unrest4: 'unrest',
      Piece.revolt0: 'revolt',
      Piece.revolt1: 'revolt',
      Piece.revolt2: 'revolt',
      Piece.revolt3: 'revolt',
      Piece.revolt4: 'revolt',
      Piece.truceBeginsConstantine: 'truce_begins_constantine',
      Piece.truceBeginsVandals: 'truce_begins_vandals',
      Piece.truceBeginsGoths: 'truce_begins_goths',
      Piece.truceEndsConstantine: 'truce_ends_constantine',
      Piece.truceEndsVandals: 'truce_ends_vandals',
      Piece.truceEndsGoths: 'truce_ends_goths',
      Piece.mutinyConstantine: 'mutiny_constantine',
      Piece.mutinyVandals: 'mutiny_vandals',
      Piece.mutinyGoths: 'mutiny_goths',
      Piece.constantineAttacksVandalsBegins: 'constantine_attacks_vandals_begins',
      Piece.constantineAttacksVandalsEnds: 'constantine_attacks_vandals_ends',
      Piece.deathOfAlaric: 'death_of_alaric_goths',
      Piece.cannotAttack: 'cannot_attack_constantine',
      Piece.purpleCloak: 'purple_cloak_constantine',
      Piece.imperialWedding: 'imperial_wedding',
      Piece.markerTurn: 'marker_turn',
      Piece.markerRound: 'marker_round',
    };

    for (final counterName in counterNames.entries) {
      final imagePath = 'assets/images/${counterName.value}.png';
      _counters[counterName.key] = Image.asset(imagePath,
        key: UniqueKey(),
        width: 72.0,
        height: 72.0,
      );
    }
  }

  void addPieceToBoard(MyAppState appState, Piece piece, BoardArea boardArea, double x, double y) {
    if (_emptyMap && boardArea == BoardArea.map) {
      return;
    }

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

    GestureTapCallback? onTap;
    if (choosable) {
      onTap = () {
        appState.chosePiece(piece);
      };
    }

    void onSecondaryTap() {
      setState(() {
        final pieceStackKey = _pieceStackKeys[piece];
        if (pieceStackKey != null) {
          if (_expandedStacks.contains(pieceStackKey)) {
            _expandedStacks.remove(pieceStackKey);
          } else {
            _expandedStacks.add(pieceStackKey);
          }
        }
      });
    }

    widget = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        onSecondaryTap: onSecondaryTap,
        child: widget,
      ),
    );

    widget = Positioned(
      left: x - borderWidth,
      top: y - borderWidth,
      child: widget,
    );

    switch (boardArea) {
    case BoardArea.map:
      _mapStackChildren.add(widget);
    case BoardArea.display:
      _displayStackChildren.add(widget);
    }
  }

  void addSpaceToMap(MyAppState appState, Location space, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(space);
    bool selected = playerChoices.selectedLocations.contains(space);

    if (!choosable && !selected) {
      return;
    }

    const outerBorderWidth = 10.0;
    const innerBorderWidth = 12.0;

    Widget widget = const SizedBox(
      height: 72.0 + innerBorderWidth,
      width: 72.0 + innerBorderWidth,
    );

    BoxDecoration? boxDecoration;

    if (space.isType(LocationType.region)) {
      boxDecoration = BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: choosable ? Colors.red : Colors.green, width: outerBorderWidth),
      );
    } else {
      boxDecoration = BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.transparent,
        border: Border.all(color: choosable ? Colors.red : Colors.green, width: outerBorderWidth),
        borderRadius: BorderRadius.circular(10.0),
      );
    }

    widget = Container(
      decoration: boxDecoration,
      child: widget,
    );

    if (choosable) {
      widget = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            appState.choseLocation(space);
          },
          child: widget,
        ),
      );
    }

    widget = Positioned(
      left: x - 0.5 * innerBorderWidth - outerBorderWidth,
      top: y - 0.5 * innerBorderWidth - outerBorderWidth,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addBoxToMap(MyAppState appState, Location box, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(box);
    bool selected = playerChoices.selectedLocations.contains(box);

    if (!choosable && !selected) {
      return;
    }

    const outerBorderWidth = 10.0;
    const innerBorderWidth = 12.0;

    double boxWidth  = 72.0 + innerBorderWidth;
    double boxHeight = 72.0 + innerBorderWidth;

    if (box.isType(LocationType.army)) {
      boxHeight = 280.0 + innerBorderWidth;
    } else if (box == Location.recovery) {
      boxWidth = 360.0 + innerBorderWidth;
    }

    Widget widget = SizedBox(
      height: boxHeight,
      width: boxWidth,
    );

    final boxDecoration = BoxDecoration(
      shape: BoxShape.rectangle,
      color: Colors.transparent,
      border: Border.all(color: choosable ? Colors.red : Colors.green, width: outerBorderWidth),
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
      left: x - 0.5 * innerBorderWidth - outerBorderWidth,
      top: y - 0.5 * innerBorderWidth - outerBorderWidth,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.homeConstantine: (BoardArea.map, 0.0, 0.0),
      Location.homeVandals: (BoardArea.map, 0.0, 0.0),
      Location.homeGoths: (BoardArea.map, 0.0, 0.0),
      Location.regionBononia: (BoardArea.map, 725.0, 253.0),
      Location.regionDurocortorum: (BoardArea.map, 889.5, 421.0),
      Location.regionMediolanum: (BoardArea.map, 1195.0, 758.0),
      Location.regionVerona: (BoardArea.map, 0.0, 0.0),
      Location.regionLocoritum: (BoardArea.map, 0.0, 0.0),
      Location.regionMogontiacum: (BoardArea.map, 0.0, 0.0),
      Location.regionAquitania: (BoardArea.map, 471.0, 831.0),
      Location.regionPyrenaeiMontes: (BoardArea.map, 359.5, 1067.0),
      Location.regionGallaecia: (BoardArea.map, 108.0, 1076.5),
      Location.regionDalmatia: (BoardArea.map, 0.0, 0.0),
      Location.regionTarsatica: (BoardArea.map, 0.0, 0.0),
      Location.regionAquileia: (BoardArea.map, 0.0, 0.0),
      Location.regionPollentia: (BoardArea.map, 1139.0, 903.0),
      Location.regionFiesole: (BoardArea.map, 1344.75, 1079.5),
      Location.siegeArelate: (BoardArea.map, 0.0, 0.0),
      Location.siegeRavenna: (BoardArea.map, 0.0, 0.0),
      Location.siegeRoma: (BoardArea.map, 0.0, 0.0),
      Location.cityArelate: (BoardArea.map, 766.5, 1008.5),
      Location.cityRavenna: (BoardArea.map, 1458.0, 1004.5),
      Location.cityRoma: (BoardArea.map, 1494.5, 1235.0),
      Location.leaderConstantine: (BoardArea.map, 1062.0, 1152.0),
      Location.leaderVandals: (BoardArea.map, 1147.0, 1152.0),
      Location.leaderGoths: (BoardArea.map, 1232.0, 1152.0),
      Location.armyConstantine: (BoardArea.map, 1062.0, 1251.0),
      Location.armyVandals: (BoardArea.map, 1147.0, 1251.0),
      Location.armyGoths: (BoardArea.map, 1232.0, 1251.0),
      Location.unactivated: (BoardArea.map, 946.0, 1355.0),
      Location.surrendered: (BoardArea.map, 0.0, 0.0),
      Location.recovery: (BoardArea.map, 1320.0, 1464.75),
      Location.olympius0: (BoardArea.map, 105.25, 692.0),
      Location.olympiusAdvocate: (BoardArea.map, 213.25, 690.5),
      Location.turn1: (BoardArea.map, 1181.25, 97.25),
      Location.round1: (BoardArea.map, 1691.75, 194.25),
    };
    return coordinates[location]!;
  }

  void layoutStack(MyAppState appState, StackKey stackKey, List<Piece> pieces, BoardArea boardArea, double x, double y, double dx, double dy) {
    if (_expandedStacks.contains(stackKey)) {
      dx = 0.0;
      dy = 60.0;
      double bottom = y + (pieces.length + 1) * dy + 10.0;
      if (bottom >= _mapHeight) {
        dy = -60.0;
      }
    }
    for (int i = 0; i < pieces.length; ++i) {
      addPieceToBoard(appState, pieces[i], boardArea, x + i * dx, y + i * dy);
      _pieceStackKeys[pieces[i]] = stackKey;
    }
  }

  void layoutBoxStacks(MyAppState appState, Location box, int pass, List<Piece> pieces, BoardArea boardArea, int colCount, int rowCount, double x, double y, double dxStack, double dyStack, double dxPiece, double dyPiece) {
    int stackCount = rowCount * colCount;
    for (int row = 0; row < rowCount; ++row) {
      for (int col = 0; col < colCount; ++col) {
        final stackPieces = <Piece>[];
        int stackIndex = row * colCount + col;
        final sk = (box, stackIndex);
        if (_expandedStacks.contains(sk) == (pass == 1)) {
          for (int pieceIndex = stackIndex; pieceIndex < pieces.length; pieceIndex += stackCount) {
            stackPieces.add(pieces[pieceIndex]);
          }
          if (stackPieces.isNotEmpty) {
            double xStack = x + col * dxStack;
            double yStack = y + row * dyStack;
            layoutStack(appState, sk, stackPieces, boardArea, xStack, yStack, dxPiece, dyPiece);
          }
        }
      }
    }
  }

  void layoutSpace(MyAppState appState, Location space, int pass) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(space);
    final xSpace = coordinates.$2;
    final ySpace = coordinates.$3;

    if (pass == 0 && appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(space)) {
      addSpaceToMap(appState, space, xSpace, ySpace);
    }

    final sk = (space, 0);
    if (_expandedStacks.contains(sk) == (pass == 1)) {
      layoutStack(appState, sk, state.piecesInLocation(PieceType.all, space), BoardArea.map, xSpace, ySpace, 10.0, 10.0);
    }
 
    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(space)) {
      addSpaceToMap(appState, space, xSpace, ySpace);
    }
  }

  void layoutSpaces(MyAppState appState, int pass) {
    for (final space in LocationType.space.locations) {
      layoutSpace(appState, space, pass);
    }
  }

  void layoutBoxes(MyAppState appState, int pass) {
    const boxesInfo = {
      Location.leaderConstantine: (1, 1, 0.0, 0.0),
      Location.leaderVandals: (1, 1, 0.0, 0.0),
      Location.leaderGoths: (1, 1, 0.0, 0.0),
      Location.armyConstantine: (1, 1, 0.0, 0.0),
      Location.armyVandals: (1, 1, 0.0, 0.0),
      Location.armyGoths: (1, 1, 0.0, 0.0),
      Location.unactivated: (1, 2, 25.0, 25.0),
      Location.surrendered: (1, 1, 0.0, 0.0),
      Location.recovery: (5, 1, 5.0, 0.0),
      Location.olympiusAdvocate: (1, 1, 0.0, 0.0),
    };

    final state = appState.gameState!;
    for (final box in boxesInfo.keys) {
      final coordinates = locationCoordinates(box);
      final boardArea  = coordinates.$1;
      double xBox = coordinates.$2;
      double yBox = coordinates.$3;

      if (pass == 0 && appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(box)) {
        addBoxToMap(appState, box, xBox, yBox);
      }

      final info = boxesInfo[box]!;
      int cols = info.$1;
      int rows = info.$2;
      double xGap = info.$3;
      double yGap = info.$4;
      layoutBoxStacks(appState, box, pass, state.piecesInLocation(PieceType.all, box), boardArea, cols, rows, xBox, yBox, 72.0 + xGap, 72.0 + yGap, 10.0, 10.0);

      if (pass == 1 && appState.playerChoices != null && appState.playerChoices!.locations.contains(box)) {
        addBoxToMap(appState, box, xBox, yBox);
      }
    }
  }

  void layoutOlympiusTrack(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.olympius0);
    double xBox = firstCoordinates.$2;
    double yFirst = firstCoordinates.$3;
    for (final box in LocationType.olympius.locations) {
      double yBox = yFirst - (box.index - LocationType.olympius.firstIndex) * 75.0;
      for (final piece in state.piecesInLocation(PieceType.all, box)) {
        addPieceToBoard(appState, piece, BoardArea.map, xBox, yBox);
      }
    }
  }

  void layoutTurnTrack(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.turn1);
    double xFirst = firstCoordinates.$2;
    double yBox = firstCoordinates.$3;
    for (final box in LocationType.turn.locations) {
      double xBox = xFirst + (box.index - LocationType.turn.firstIndex) * 75.0;
      for (final piece in state.piecesInLocation(PieceType.all, box)) {
        addPieceToBoard(appState, piece, BoardArea.map, xBox, yBox);
      }
    }
  }

  void layoutRoundTrack(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.round1);
    double xFirst = firstCoordinates.$2;
    double yBox = firstCoordinates.$3;
    for (final box in LocationType.round.locations) {
      double xBox = xFirst + (box.index - LocationType.round.firstIndex) * 75.0;
      for (final piece in state.piecesInLocation(PieceType.all, box)) {
        addPieceToBoard(appState, piece, BoardArea.map, xBox, yBox);
      }
    }
  }

  void layoutDrawDeck(MyAppState appState) {

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
    _displayStackChildren.clear();
    _displayStackChildren.add(_displayImage);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutOlympiusTrack(appState);
      layoutTurnTrack(appState);
      layoutRoundTrack(appState);
      layoutDrawDeck(appState);
      layoutBoxes(appState, 0);
      layoutSpaces(appState, 0);
      layoutBoxes(appState, 1);
      layoutSpaces(appState, 1);

      const choiceTexts = {
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

    VoidCallback? onFirstSnapshot;
    VoidCallback? onPrevTurn;
    VoidCallback? onPrevSnapshot;
    VoidCallback? onNextSnapshot;
    VoidCallback? onNextTurn;
    VoidCallback? onLastSnapshot;

    if (appState.previousSnapshotAvailable) {
      onFirstSnapshot = () {
        appState.firstSnapshot();
      };
      onPrevTurn = () {
        appState.previousTurn();
      };
      onPrevSnapshot = () {
        appState.previousSnapshot();
      };
    }
    if (appState.nextSnapshotAvailable) {
      onNextSnapshot = () {
        appState.nextSnapshot();
      };
      onNextTurn = () {
        appState.nextTurn();
      };
      onLastSnapshot = () {
        appState.lastSnapshot();
      };
    }

    final rootWidget = MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 400.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10.0,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: choiceWidgets,
                ),
                Form(
                  key: _displayOptionsFormKey,
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(color: colorScheme.tertiaryContainer),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                title: Text(
                                  'Empty Map',
                                  style: textTheme.labelMedium
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: _emptyMap,
                                onChanged: (bool? emptyMap) {
                                  setState(() {
                                    if (emptyMap != null) {
                                      _emptyMap = emptyMap;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(color: colorScheme.secondaryContainer),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  appState.duplicateCurrentGame();
                                },
                                icon: const Icon(Icons.copy),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              IconButton(
                                onPressed: onFirstSnapshot,
                                icon: const Icon(Icons.skip_previous),
                              ),
                              IconButton(
                                onPressed: onPrevTurn,
                                icon: const Icon(Icons.fast_rewind),
                              ),
                              IconButton(
                                onPressed: onPrevSnapshot,
                                icon: const Icon(Icons.arrow_left),
                              ),
                              IconButton(
                                onPressed: onNextSnapshot,
                                icon: const Icon(Icons.arrow_right),
                              ),
                              IconButton(
                                onPressed: onNextTurn,
                                icon: const Icon(Icons.fast_forward),
                              ),
                              IconButton(
                                onPressed: onLastSnapshot,
                                icon: const Icon(Icons.skip_next),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                  width: _mapWidth + _displayWidth,
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
                        child: Stack(children: _displayStackChildren),
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

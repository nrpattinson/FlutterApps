import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import 'package:the_wars_of_marcus_aurelius/game.dart';
import 'package:the_wars_of_marcus_aurelius/main.dart';

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

  final _displayOptionsFormKey = GlobalKey<FormState>();
 
  bool _emptyMap = false;

  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _mapStackChildren = <Widget>[];
  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.barbarianMarcomanniBold: 'army_marcomanni_bold',
      Piece.barbarianMarcomanniDemoralized: 'army_marcomanni_demoralized',
      Piece.barbarianQuadiBold: 'army_quadi_bold',
      Piece.barbarianQuadiDemoralized: 'army_quadi_demoralized',
      Piece.barbarianIazygesBold: 'army_iazyges_bold',
      Piece.barbarianIazygesDemoralized: 'army_iazyges_demoralized',
      Piece.legionAdiutrix1: 'legio_adiutrix_1',
      Piece.legionAdiutrix2: 'legio_adiutrix_2',
      Piece.legionItalica1: 'legio_italica_1',
      Piece.legionItalica2: 'legio_italica_2',
      Piece.legionItalica3: 'legio_italica_3',
      Piece.legionFlaviaFelix4: 'legio_flavia_felix_4',
      Piece.legionMacedonia5: 'legio_macedonia_5',
      Piece.legionClaudia7: 'legio_claudia_7',
      Piece.legionClaudia11: 'legio_claudia_11',
      Piece.legionGemina10: 'legio_gemina_10',
      Piece.legionGemina13: 'legio_gemina_13',
      Piece.legionGemina14: 'legio_gemina_14',
      Piece.legionPrimigenia22: 'legio_primigenia_22',
      Piece.legionSlaves: 'legio_slaves',
      Piece.leaderMarcusAureliusBold: 'leader_marcus_aurelius_bold',
      Piece.leaderMarcusAureliusDemoralized: 'leader_marcus_aurelius_demoralized',
      Piece.leaderPompeianus: 'leader_pompeianus',
      Piece.leaderPertinax: 'leader_pertinax',
      Piece.leaderMaximianus: 'leader_maximianus',
      Piece.fort0Level1: 'fort_1',
      Piece.fort1Level1: 'fort_1',
      Piece.fort2Level1: 'fort_1',
      Piece.fort3Level1: 'fort_1',
      Piece.fort4Level1: 'fort_1',
      Piece.fort5Level1: 'fort_1',
      Piece.fort6Level1: 'fort_1',
      Piece.fort7Level1: 'fort_1',
      Piece.fort8Level1: 'fort_1',
      Piece.fort9Level1: 'fort_1',
      Piece.fort10Level1: 'fort_1',
      Piece.fort11Level1: 'fort_1',
      Piece.fort12Level1: 'fort_1',
      Piece.fort0Level2: 'fort_2',
      Piece.fort1Level2: 'fort_2',
      Piece.fort2Level2: 'fort_2',
      Piece.fort3Level2: 'fort_2',
      Piece.fort4Level2: 'fort_2',
      Piece.fort5Level2: 'fort_2',
      Piece.fort6Level2: 'fort_2',
      Piece.fort7Level2: 'fort_2',
      Piece.fort8Level2: 'fort_2',
      Piece.fort9Level2: 'fort_2',
      Piece.fort10Level2: 'fort_2',
      Piece.fort11Level2: 'fort_2',
      Piece.fort12Level2: 'fort_2',
      Piece.truceMarcomanni: 'truce_marcomanni',
      Piece.truceQuadi: 'truce_quadi',
      Piece.truceIazyges: 'truce_iazyges',
      Piece.mutiny0: 'mutiny',
      Piece.mutiny1: 'mutiny',
      Piece.mutiny2: 'mutiny',
      Piece.auxiliaP1: 'auxilia_1',
      Piece.auxiliaP2: 'auxilia_2',
      Piece.fleet0: 'fleet',
      Piece.fleet1: 'fleet',
      Piece.cannotAttackQuadi: 'no_attack_quadi',
      Piece.eleusinianMysteries: 'eleusinian_mysteries',
      Piece.markerYear: 'marker_year',
      Piece.markerRound: 'marker_round',
      Piece.markerImperium: 'marker_imperium',
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

  void addSpaceToMap(MyAppState appState, Location space, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(space);
    bool selected = playerChoices.selectedLocations.contains(space);

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
            appState.choseLocation(space);
          },
          child: widget,
        ),
      );
    }

    widget = Positioned(
      left: x - 60.0,
      top: y - 60.0,
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

    double boxWidth  = 60.0 + innerBorderWidth;
    double boxHeight = 60.0 + innerBorderWidth;

    if (box.isType(LocationType.army)) {
      boxWidth = 150.0 + innerBorderWidth;
      boxHeight = 88 + innerBorderWidth;
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
      Location.homeMarcomanni: (BoardArea.map, 0.0, 0.0),
      Location.spaceMarcomanni1: (BoardArea.map, 0.0, 0.0),
      Location.spaceMarcomanni2: (BoardArea.map, 0.0, 0.0),
      Location.spaceMarcomanni3: (BoardArea.map, 475.0, 585.0),
      Location.spacePannoniaSuperior0: (BoardArea.map, 0.0, 0.0),
      Location.spacePannoniaSuperior1: (BoardArea.map, 0.0, 0.0),
      Location.homeQuadi: (BoardArea.map, 830.0, 342.0),
      Location.spaceQuadi1: (BoardArea.map, 0.0, 0.0),
      Location.spaceQuadi2: (BoardArea.map, 0.0, 0.0),
      Location.spaceQuadi3: (BoardArea.map, 0.0, 0.0),
      Location.spacePannoniaInferior: (BoardArea.map, 0.0, 0.0),
      Location.homeIazyges: (BoardArea.map, 0.0, 0.0),
      Location.spaceIazyges1: (BoardArea.map, 0.0, 0.0),
      Location.spaceIazyges2: (BoardArea.map, 993.0, 766.0),
      Location.spaceIazyges3: (BoardArea.map, 0.0, 0.0),
      Location.spaceIazyges4: (BoardArea.map, 0.0, 0.0),
      Location.leaderMarcomanni: (BoardArea.map, 0.0, 0.0),
      Location.leaderQuadi: (BoardArea.map, 0.0, 0.0),
      Location.leaderIazyges: (BoardArea.map, 0.0, 0.0),
      Location.armyMarcomanni: (BoardArea.map, 280.0, 1451.0),
      Location.armyQuadi: (BoardArea.map, 683.0, 1451.0),
      Location.armyIazyges: (BoardArea.map, 1089.0, 1451.0),
      Location.surrenderedTribes: (BoardArea.map, 31.0, 1100.0),
      Location.recovery: (BoardArea.map, 31.0, 1187.0),
      Location.unactivated: (BoardArea.map, 31.0, 1305.0),
      Location.imperiumUsurped: (BoardArea.map, 66.0, 922.5),
      Location.turn0: (BoardArea.map, 365.0, 36.0),
      Location.round1: (BoardArea.map, 365.0, 114.0),
      Location.round2: (BoardArea.map, 0.0, 0.0),
      Location.round3: (BoardArea.map, 0.0, 0.0),
      Location.roundHousekeeping: (BoardArea.map, 0.0, 0.0),
   };
    return coordinates[location]!;
  }

  void layoutSpace(MyAppState appState, Location space) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(space);
    final xSpace = coordinates.$2;
    final ySpace = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(space)) {
      addSpaceToMap(appState, space, xSpace, ySpace);
    }

    if (!_emptyMap) {
      for (final piece in state.piecesInLocation(PieceType.all, space)) {
        addPieceToBoard(appState, piece, BoardArea.map, xSpace, ySpace);
      }
    }
 
    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(space)) {
      addSpaceToMap(appState, space, xSpace, ySpace);
    }
  }

  void layoutSpaces(MyAppState appState) {
    for (final space in LocationType.space.locations) {
      layoutSpace(appState, space);
    }
  }

  void layoutBoxes(MyAppState appState) {
    const boxesInfo = {
      Location.leaderMarcomanni: (1, 1, 0.0, 0.0),
      Location.leaderQuadi: (1, 1, 0.0, 0.0),
      Location.leaderIazyges: (1, 1, 0.0, 0.0),
      Location.armyMarcomanni: (2, 1, 20.0, 0.0),
      Location.armyQuadi: (2, 1, 20.0, 0.0),
      Location.armyIazyges: (2, 1, 20.0, 0.0),
      Location.surrenderedTribes: (2, 1, 10.0, 0.0),
      Location.recovery: (2, 1, 10.0, 0.0),
      Location.unactivated: (2, 1, 10.0, 0.0),
      Location.round1: (1, 1, 0.0, 0.0),
      Location.round2: (1, 1, 0.0, 0.0),
      Location.round3: (1, 1, 0.0, 0.0),
      Location.roundHousekeeping: (1, 1, 0.0, 0.0),
    };

    final state = appState.gameState!;
    for (final box in boxesInfo.keys) {
      final coordinates = locationCoordinates(box);
      final boardArea  = coordinates.$1;
      double xBox = coordinates.$2;
      double yBox = coordinates.$3;

      if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(box)) {
        addBoxToMap(appState, box, xBox, yBox);
      }

      final info = boxesInfo[box]!;
      int cols = info.$1;
      int rows = info.$2;
      double xGap = info.$3;
      double yGap = info.$4;
      final pieces = state.piecesInLocation(PieceType.all, box);
      int cells = cols * rows;
      for (int i = 0; i < pieces.length; ++i) {
        int col = i % cols;
        int row = (i ~/ cols) % rows;
        int depth = i ~/ cells;
        double x = xBox + col * (60.0 + xGap) + depth * 5.0;
        double y = yBox + row * (60.0 + yGap) + depth * 5.0;
        addPieceToBoard(appState, pieces[i], boardArea, x, y);
      }

      if (appState.playerChoices != null && appState.playerChoices!.locations.contains(box)) {
        addBoxToMap(appState, box, xBox, yBox);
      }
    }
  }

  void layoutYears(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.turn0);
    double xFirst = firstCoordinates.$2;
    double y = firstCoordinates.$3;
    for (final box in LocationType.turn.locations) {
      final index = box.index - LocationType.turn.firstIndex;
      double x = xFirst + index * 80.0;
      for (final piece in state.piecesInLocation(PieceType.all, box)) {
        addPieceToBoard(appState, piece, BoardArea.map, x, y);
      }
    }
  }

  void layoutImperium(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.imperiumUsurped);
    double x = firstCoordinates.$2;
    double yFirst = firstCoordinates.$3;
    for (final box in LocationType.imperium.locations) {
      final index = box.index - LocationType.imperium.firstIndex;
      double y = yFirst - index * 80.0;
      for (final piece in state.piecesInLocation(PieceType.all, box)) {
        addPieceToBoard(appState, piece, BoardArea.map, x, y);
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
      layoutYears(appState);
      layoutImperium(appState);

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

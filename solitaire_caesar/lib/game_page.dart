import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:solitaire_caesar/game.dart';
import 'package:solitaire_caesar/main.dart';

enum BoardArea {
  map,
  reference,
}

class GamePage extends StatefulWidget {

  const GamePage({super.key});

  @override
  GamePageState createState() {
    return GamePageState();
  }
}

class GamePageState extends State<GamePage> {
  static const _mapWidth = 1632.0;
  static const _mapHeight = 1056.0;
  static const _referenceWidth = 1632.0;
  static const _referenceHeight = 1056.0;

  final _displayOptionsFormKey = GlobalKey<FormState>();
 
  bool _emptyMap = false;

  final _pieceTypeCounters = <PieceType,Image>{};
  final _pieceCounters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _referenceImage = Image.asset('assets/images/reference.png', key: UniqueKey(), width: _referenceWidth, height: _referenceHeight);
  final _mapStackChildren = <Widget>[];
  final _referenceStackChildren = <Widget>[];
  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<PieceType,String> pieceTypeCounterNames = {
      PieceType.legion: 'legion',
      PieceType.barbarianCivilized: 'barbarian_civilized',
      PieceType.barbarianUncivilized: 'barbarian_uncivilized',
      PieceType.city: 'city',
      PieceType.romanControl: 'control',
    };

    for (final counterName in pieceTypeCounterNames.entries) {
      final imagePath = 'assets/images/${counterName.value}.png';
      _pieceTypeCounters[counterName.key] = Image.asset(imagePath,
        key: UniqueKey(),
        width: 60.0, height:60.0,
      );
    }

    final Map<Piece,String> pieceCounterNames = {
      Piece.talents1: 'talents_1',
      Piece.talents10: 'talents_10',
      Piece.victoryPoints1: 'vp_1',
      Piece.victoryPoints10: 'vp_10',
      Piece.victoryPoints100: 'vp_100',
      Piece.turn: 'turn',
      Piece.emperor: 'emperor',
      Piece.skilledGeneral: 'skilled_general',
      Piece.capital: 'capital',
    };

    for (final counterName in pieceCounterNames.entries) {
      final imagePath = 'assets/images/${counterName.value}.png';
      _pieceCounters[counterName.key] = Image.asset(imagePath,
        key: UniqueKey(),
        width: 60.0, height:60.0,
      );
    }
  }

  Image pieceImage(Piece piece) {
    for (final counter in _pieceTypeCounters.entries) {
      if (piece.isType(counter.key)) {
        return counter.value;
      }
    }
    for (final counter in _pieceCounters.entries) {
      if (piece == counter.key) {
        return counter.value;
      }
    }
    return _referenceImage;
  }

  void addPieceToBoard(MyAppState appState, Piece piece, BoardArea boardArea, double x, double y) {
    final playerChoices = appState.playerChoices;

    bool choosable = playerChoices != null && playerChoices.pieces.contains(piece);
    bool selected = playerChoices != null && playerChoices.selectedPieces.contains(piece);

    Widget widget = pieceImage(piece);
    
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
    case BoardArea.reference:
      _referenceStackChildren.add(widget);
    }
  }

  void addProvinceToMap(MyAppState appState, Location province, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(province);
    bool selected = playerChoices.selectedLocations.contains(province);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = const SizedBox(
      height: 65.0,
      width: 65.0,
    );

    final boxDecoration = BoxDecoration(
      shape: BoxShape.rectangle,
      color: Colors.transparent,
      border: Border.all(color: choosable ? Colors.yellow : Colors.green, width: 5.0),
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
            appState.choseLocation(province);
          },
          child: widget,
        ),
      );
    }

    widget = Positioned(
      left: x - 7.0,
      top: y - 7.0,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.asia: (BoardArea.map, 1080.0, 650.0),
      Location.carthage: (BoardArea.map, 622.0, 890.0),
      Location.cilicia: (BoardArea.map, 1210.0, 693.0),
      Location.cisalpine: (BoardArea.map, 508.0, 475.0),
      Location.cyrene: (BoardArea.map, 930.0, 913.0),
      Location.egypt: (BoardArea.map, 1110.0, 920.0),
      Location.gaul: (BoardArea.map, 342.0, 448.0),
      Location.greece: (BoardArea.map, 895.0, 655.0),
      Location.hispania: (BoardArea.map, 153.0, 655.0),
      Location.illyria: (BoardArea.map, 730.0, 463.0),
      Location.macedonia: (BoardArea.map, 875.0, 525.0),
      Location.mesopotamia: (BoardArea.map, 1435.0, 770.0),
      Location.palestine: (BoardArea.map, 1297.0, 870.0),
      Location.pontus: (BoardArea.map, 1193.0, 570.0),
      Location.rhodes: (BoardArea.map, 1080.0, 798.0),
      Location.rome: (BoardArea.map, 700.0, 600.0),
      Location.sicily: (BoardArea.map, 660.0, 775.0),
      Location.syria: (BoardArea.map, 1310.0, 770.0),
      Location.thrace: (BoardArea.map, 1000.0, 548.0),
      Location.albania: (BoardArea.map, 1413.0, 533.0),
      Location.armenia: (BoardArea.map, 1310.0, 592.0),
      Location.babylon: (BoardArea.map, 1508.0, 710.0),
      Location.belgica: (BoardArea.map, 388.0, 269.0),
      Location.britain: (BoardArea.map, 281.0, 192.0),
      Location.dacia: (BoardArea.map, 867.0, 403.0),
      Location.mauretania: (BoardArea.map, 226.0, 881.0),
      Location.moesia: (BoardArea.map, 1008.0, 427.0),
      Location.rhaetia: (BoardArea.map, 679.0, 330.0),
      Location.germania: (BoardArea.map, 591.0, 184.0),
      Location.theiss: (BoardArea.map, 792.0, 233.0),
      Location.arabia: (BoardArea.map, 0.0, 0.0),
      Location.berber: (BoardArea.map, 0.0, 0.0),
      Location.nord: (BoardArea.map, 0.0, 0.0),
      Location.parthia: (BoardArea.map, 0.0, 0.0),
      Location.steppe: (BoardArea.map, 0.0, 0.0),
      Location.track0: (BoardArea.map, 876.0, 198.0),
      Location.turn1: (BoardArea.reference, 415.0, 133.0),
    };
    return coordinates[location]!;
  }

  void layoutProvince(MyAppState appState, Location province) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(province);
    final xProvince = coordinates.$2;
    final yProvince = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(province)) {
      addProvinceToMap(appState, province, xProvince, yProvince);
    }

    if (!_emptyMap) {
      final pieces = state.piecesInLocation(PieceType.all, province);
      for (int i = 0; i < pieces.length; ++i) {
        addPieceToBoard(appState, pieces[i], BoardArea.map, xProvince + 4.0 * i, yProvince + 4.0 * i);
      }
    }
 
    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(province)) {
      addProvinceToMap(appState, province, xProvince, yProvince);
    }
  }

  void layoutProvinces(MyAppState appState) {
    for (final province in LocationType.province.locations) {
      layoutProvince(appState, province);
    }
  }

  void layoutTrack(MyAppState appState) {
    final state = appState.gameState!;

    final firstBoxCoordinates = locationCoordinates(Location.track0);
    final xFirst = firstBoxCoordinates.$2;
    final yBox = firstBoxCoordinates.$3;
    for (final box in LocationType.track.locations) {
      int index = box.index - LocationType.track.firstIndex;
      final xBox = xFirst + 73.2 * index;
      final pieces = state.piecesInLocation(PieceType.marker, box);
      for (int i = 0; i < pieces.length; ++i) {
        addPieceToBoard(appState, pieces[i], BoardArea.map, xBox + 4.0 * i, yBox + 4.0 * i);
      }
    }
  }

  void layoutTurn(MyAppState appState) {
    final state = appState.gameState!;

    final firstBoxCoordinates = locationCoordinates(Location.turn1);
    final xFirst = firstBoxCoordinates.$2;
    final yFirst = firstBoxCoordinates.$3;
    const turnPieces = [Piece.turn, Piece.skilledGeneral];
    for (int i = 0; i < turnPieces.length; ++i) {
      final piece = turnPieces[i];
      final box = state.pieceLocation(Piece.turn);
      if (box.isType(LocationType.turn)) {
        int index = box.index - LocationType.turn.firstIndex;
        int xIndex = index % 9;
        int yIndex = index ~/ 9;
        final xBox = xFirst + 108.0 * xIndex + i * 5.0;
        final yBox = yFirst + 95.0 * yIndex + i * 5.0;
        addPieceToBoard(appState, piece, BoardArea.reference, xBox, yBox);
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
    _referenceStackChildren.clear();
    _referenceStackChildren.add(_referenceImage);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutProvinces(appState);
      layoutTrack(appState);
      layoutTurn(appState);

      const choiceTexts = {
        Choice.raiseEmperor: 'Raise Emperor',
        Choice.promoteToEmperor: 'Promote Legion to Emperor',
        Choice.raiseLegion: 'Raise Legion',
        Choice.buildCity: 'Build City',
        Choice.die1: '1',
        Choice.die2: '2',
        Choice.die3: '3',
        Choice.die4: '4',
        Choice.die5: '5',
        Choice.die6: '6',
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
            width: 300.0,
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
                  width: _mapWidth + _referenceWidth,
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
                        child: Stack(children: _referenceStackChildren),
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

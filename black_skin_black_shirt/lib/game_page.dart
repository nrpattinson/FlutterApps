import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:black_skin_black_shirt/game.dart';
import 'package:black_skin_black_shirt/main.dart';
import 'package:provider/provider.dart';

enum BoardArea {
  map,
  tray,
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
  static const _trayWidth = 1261.0;
  static const _trayHeight = 1632.0;
  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _trayImage = Image.asset('assets/images/tray.png', key: UniqueKey(), width: _trayWidth, height: _trayHeight);
  final _mapStackChildren = <Widget>[];
  final _trayStackChildren = <Widget>[];

  final _logScrollController = ScrollController();

  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
     Piece.armyA: 'army_italian_a',
     Piece.armyB: 'army_italian_b',
     Piece.armyC: 'army_italian_c',
     Piece.armyD: 'army_italian_d',
     Piece.armyAoiA: 'army_aoi_a',
     Piece.armyAoiB: 'army_aoi_b',
     Piece.armyAoiC: 'army_aoi_c',
     Piece.armyAoiD: 'army_aoi_d',
     Piece.planeBlueA: 'plane_blue_a',
     Piece.planeBlueB: 'plane_blue_b',
     Piece.planeBlueC: 'plane_blue_c',
     Piece.planeBlueD: 'plane_blue_d',
     Piece.planeYellowA: 'plane_yellow_a',
     Piece.planeYellowB: 'plane_yellow_b',
     Piece.planeYellowC: 'plane_yellow_c',
     Piece.planeYellowD: 'plane_yellow_d',
     Piece.fascistRuleA: 'fascist_rule',
     Piece.fascistRuleB: 'fascist_rule',
     Piece.fascistRuleC: 'fascist_rule',
     Piece.fascistRuleD: 'fascist_rule',
     Piece.rasA: 'ras_a',
     Piece.rasB: 'ras_b',
     Piece.rasC: 'ras_c',
     Piece.rasD: 'ras_d',
     Piece.partisansA: 'partisans_a',
     Piece.partisansB: 'partisans_b',
     Piece.partisansC: 'partisans_c',
     Piece.partisansD: 'partisans_d',
     Piece.minefield: 'minefield',
     Piece.blackshirts: 'blackshirts',
     Piece.carroArmato: 'carro_armato',
     Piece.negus: 'negus',
     Piece.planeIea: 'iea',
     Piece.diplomatBritain: 'diplomat_britain',
     Piece.diplomatFrance: 'diplomat_france',
     Piece.diplomatItaly: 'diplomat_italy',
     Piece.diplomatMexico: 'diplomat_mexico',
     Piece.diplomatUssr: 'diplomat_ussr',
     Piece.diplomatChina: 'diplomat_china',
     Piece.mehalSefari: 'attack',
     Piece.keburZabanya: 'kebur_zabanya',
     Piece.markerSequenceOfPlay: 'sequence_of_play',
     Piece.markerDollars: 'dollars',
     Piece.markerOerlikon: 'oerlikon',
     Piece.markerMilitaryEvent: 'military_events',
     Piece.markerDrmP1: 'drm_p1',
     Piece.markerDrmN1: 'drm_n1',
     Piece.markerDuce: 'duce',
     Piece.markerHospital: 'red_cross_hospital',
     Piece.markerEmpireOfEthiopia: 'empire_ethiopia',
     Piece.markerItalianEastAfrica: 'italian_east_africa',
     Piece.markerBlackLions: 'black_lions',
      Piece.turnChit1: 'chit_1',
      Piece.turnChit2: 'chit_2',
      Piece.turnChit3: 'chit_3',
      Piece.turnChit4: 'chit_4',
      Piece.turnChit5: 'chit_5',
      Piece.turnChit6: 'chit_6',
      Piece.turnChit7: 'chit_7',
      Piece.turnChit8: 'chit_8',
      Piece.turnChit9: 'chit_9',
      Piece.turnChit10: 'chit_10',
      Piece.turnChit11: 'chit_11',
      Piece.turnChit12: 'chit_12',
      Piece.turnChit13: 'chit_13',
      Piece.turnChit14: 'chit_14',
      Piece.turnChit15: 'chit_15',
      Piece.turnChit16: 'chit_16',
      Piece.turnChit17: 'chit_17',
      Piece.turnChit18: 'chit_18',
      Piece.turnChit19: 'chit_19',
      Piece.turnChit20: 'chit_20',
      Piece.turnChit21: 'chit_21',
      Piece.turnChit22: 'chit_22',
      Piece.turnChit23: 'chit_23',
      Piece.turnChit24: 'chit_24',
      Piece.turnChit25: 'chit_25',
      Piece.turnChit26: 'chit_26',
      Piece.turnChit27: 'chit_27',
      Piece.turnChit28: 'chit_28',
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
    case BoardArea.tray:
      _trayStackChildren.add(widget);
    }
  }

  void addRegionToMap(MyAppState appState, Location region, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(region);
    bool selected = playerChoices.selectedLocations.contains(region);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = const SizedBox(
      height: 77.0,
      width: 77.0,
    );

    final boxDecoration = BoxDecoration(
      shape: BoxShape.rectangle,
      color: Colors.transparent,
      border: Border.all(color: choosable ? Colors.yellow : Colors.green, width: 9.0),
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
            appState.choseLocation(region);
          },
          child: widget,
        ),
      );
    }

    widget = Positioned(
      left: x - 8.0,
      top: y - 8.0,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.spaceAddisAbaba: (BoardArea.map, 0.0, 0.0),
      Location.spaceDebreMarkos: (BoardArea.map, 0.0, 0.0),
      Location.spaceBlueNile: (BoardArea.map, 0.0, 0.0),
      Location.spaceGondar: (BoardArea.map, 0.0, 0.0),
      Location.spaceAxum: (BoardArea.map, 0.0, 0.0),
      Location.spaceAdiQuala: (BoardArea.map, 1282.0, 88.0),
      Location.spaceDessie: (BoardArea.map, 0.0, 0.0),
      Location.spaceAmbaAlagi: (BoardArea.map, 0.0, 0.0),
      Location.spaceMakalle: (BoardArea.map, 0.0, 0.0),
      Location.spaceAdigrat: (BoardArea.map, 0.0, 0.0),
      Location.spaceCoatit: (BoardArea.map, 1469.0, 232.0),
      Location.spaceDireDawa: (BoardArea.map, 0.0, 0.0),
      Location.spaceHarar: (BoardArea.map, 0.0, 0.0),
      Location.spaceDaggabur: (BoardArea.map, 0.0, 0.0),
      Location.spaceGerlogubi: (BoardArea.map, 0.0, 0.0),
      Location.spaceWerder: (BoardArea.map, 1845.0, 1207.0),
      Location.spaceArssi: (BoardArea.map, 0.0, 0.0),
      Location.spaceYirgaAlem: (BoardArea.map, 0.0, 0.0),
      Location.spaceNegeleBorana: (BoardArea.map, 0.0, 0.0),
      Location.spaceGorrahei: (BoardArea.map, 0.0, 0.0),
      Location.spaceBaidoa: (BoardArea.map, 1661.0, 1411.0),
      Location.spaceShewa: (BoardArea.map, 0.0, 0.0),
      Location.boxSkiesAbove: (BoardArea.map, 116.0, 842.0),
      Location.boxGeneva: (BoardArea.map, 116.0, 1044.0),
      Location.boxImperialTent: (BoardArea.map, 90.0, 1247.0),
      Location.boxInternationalRecognition: (BoardArea.map, 616.0, 1335.0),
      Location.boxUnusedDiplomats: (BoardArea.map, 737.0, 1327.0),
      Location.boxMilitaryEvent: (BoardArea.map, 647.0, 345.0),
      Location.turn1: (BoardArea.map, 0.0, 0.0),
      Location.omnibus0: (BoardArea.map, 187.0, 1470.0),
      Location.sequenceOfPlayChitDraw: (BoardArea.tray, 15.0, 0.0),
      Location.sequenceOfPlayTurnStart: (BoardArea.tray, 15.0, 835.0),
      Location.sequenceOfPlayBerhanenaSelam: (BoardArea.tray, 15.0, 0.0),
      Location.sequenceOfPlayItalianAvanti: (BoardArea.tray, 15.0, 0.0),
      Location.sequenceOfPlayChitet: (BoardArea.tray, 15.0, 0.0),
      Location.sequenceOfPlayEthiopianTekawemu: (BoardArea.tray, 15.0, 0.0),
      Location.sequenceOfPlayerTurnEnd: (BoardArea.tray, 0.0, 0.0),
      Location.trayTurnChits: (BoardArea.tray, 65.0, 163.0),
      Location.trayFascistRule: (BoardArea.tray, 560.0, 163.0),
      Location.trayDiplomats: (BoardArea.tray, 756.0, 163.0),
      Location.trayEthiopian: (BoardArea.tray, 1015.0, 230.0),
      Location.trayRas: (BoardArea.tray, 135.0, 355.0),
      Location.trayItalianArmies: (BoardArea.tray, 560.0, 347.0),
      Location.trayAoiArmies: (BoardArea.tray, 790.0, 535.0),
      Location.trayEthiopianUnits: (BoardArea.tray, 783.0, 347.0),
      Location.trayPartisans: (BoardArea.tray, 95.0, 510.0),
      Location.trayPlanesBlue: (BoardArea.tray, 90.0, 654.0),
      Location.trayPlanesYellow: (BoardArea.tray, 418.0, 654.0),
      Location.trayVarious: (BoardArea.tray, 985.0, 500.0),
    };
    return coordinates[location]!;
  }

  void layoutSpace(MyAppState appState, Location space) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(space);
    final xSpace = coordinates.$2;
    final ySpace = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(space)) {
      addRegionToMap(appState, space, xSpace, ySpace);
    }

    Piece? fascistRule;
    Piece? army;
    Piece? plane;
    final otherPieces = <Piece>[];
    for (final piece in state.piecesInLocation(PieceType.all, space)) {
      if (piece.isType(PieceType.fascistRule)) {
        fascistRule = piece;
      } else if (piece.isType(PieceType.army)) {
        army = piece;
      } else if (piece.isType(PieceType.plane)) {
        plane = piece;
      } else {
        otherPieces.add(piece);
      }
    }
    if (army != null) {
      addPieceToBoard(appState, army, BoardArea.map, xSpace, ySpace + 70.0);
    }
    if (plane != null) {
      addPieceToBoard(appState, plane, BoardArea.map, xSpace + 70.0, ySpace + 70.0);
    }
    if (fascistRule != null) {
      addPieceToBoard(appState, fascistRule, BoardArea.map, xSpace + 70.0, ySpace);
    }
    for (int i = 0; i < otherPieces.length; ++i) {
      addPieceToBoard(appState, otherPieces[i], BoardArea.map, xSpace + 4.0 * i, ySpace + 4.0 * i);
    }
 
    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(space)) {
      addRegionToMap(appState, space, xSpace, ySpace);
    }
  }

  void layoutSpaces(MyAppState appState) {
    for (final region in LocationType.space.locations) {
      layoutSpace(appState, region);
    }
  }

  void layoutBoxes(MyAppState appState) {
    const boxesInfo = {
      Location.boxSkiesAbove: (3, 2, 10.0, 10.0),
      Location.boxGeneva: (3, 2, 10.0, 10.0),
      Location.boxImperialTent: (3, 2, 10.0, 10.0),
      Location.boxInternationalRecognition: (1, 1, 0.0, 0.0),
      Location.boxUnusedDiplomats: (1, 1, 0.0, 0.0),
      Location.boxMilitaryEvent: (1, 1, 0.0, 0.0),
      Location.sequenceOfPlayChitDraw: (1, 1, 0.0, 0.0),
      Location.sequenceOfPlayTurnStart: (1, 1, 0.0, 0.0),
      Location.sequenceOfPlayBerhanenaSelam: (1, 1, 0.0, 0.0),
      Location.sequenceOfPlayItalianAvanti: (1, 1, 0.0, 0.0),
      Location.sequenceOfPlayChitet: (1, 1, 0.0, 0.0),
      Location.sequenceOfPlayEthiopianTekawemu: (1, 1, 0.0, 0.0),
      Location.sequenceOfPlayerTurnEnd: (1, 1, 0.0, 0.0),
      Location.trayTurnChits: (7, 2, 4.0, 5.0),
      Location.trayFascistRule: (2, 2, 20.0, 5.0),
      Location.trayDiplomats: (3, 2, 15.0, 5.0),
      Location.trayEthiopian: (2, 1, 20.0, 0.0),
      Location.trayRas: (4, 1, 20.0, 0.0),
      Location.trayItalianArmies: (2, 3, 20.0, 20.0),
      Location.trayAoiArmies: (2, 2, 20.0, 20.0),
      Location.trayEthiopianUnits: (5, 1, 20.0, 0.0),
      Location.trayPartisans: (5, 1, 20.0, 0.0),
      Location.trayPlanesBlue: (4, 1, 10.0, 0.0),
      Location.trayPlanesYellow: (4, 1, 20.0, 0.0),
      Location.trayVarious: (3, 3, 12.0, 12.0),
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
      for (int i = 0; i < pieces.length; ++i) {
        int col = i % cols;
        int row = (i % cells) ~/ cols;
        int depth = i ~/ cells;
        double x = xBox + col * (60.0 + xGap) + depth * 4.0;
        double y = yBox + row * (60.0 + yGap) + depth * 4.0;
        addPieceToBoard(appState, pieces[i], boardArea, x, y);
      }
    }
  }

  void layoutCalendar(MyAppState appState) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(Location.turn1);
    double xFirst = coordinates.$2;
    double yFirst = coordinates.$3;
    for (final box in LocationType.calendar.locations) {
      int index = box.index - LocationType.calendar.firstIndex;
      int col = index % 7;
      int row = index ~/ 7;
      double xBox = xFirst + col * 102.7;
      double yBox = yFirst + row * 66.4;
      final others = <Piece>[];
      Piece? turnChit;
      for (final piece in state.piecesInLocation(PieceType.all, box)) {
        if (piece.isType(PieceType.turnChit)) {
          turnChit = piece;
        } else {
          others.add(piece);
        }
      }
      for (int i = 0; i < others.length; ++i) {
        double x = xBox + 34.0 - i * 10.0;
        double y = yBox;
        addPieceToBoard(appState, others[i], BoardArea.map, x, y);
      }
      if (turnChit != null) {
        double x = xBox;
        double y = yBox;
        addPieceToBoard(appState, turnChit, BoardArea.map, x, y);
      }
    }
  }

  void layoutOmnibus(MyAppState appState) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(Location.omnibus0);
    double xFirst = coordinates.$2;
    double yBox = coordinates.$3;
    for (final box in LocationType.omnibus.locations) {
      int index = box.index - LocationType.omnibus.firstIndex;
      int col = index % 7;
      double xBox = xFirst + col * 87.0;
      final pieces = state.piecesInLocation(PieceType.all, box);
      for (int i = 0; i < pieces.length; ++i) {
        double x = xBox + 34.0 - i * 10.0;
        double y = yBox;
        addPieceToBoard(appState, pieces[i], BoardArea.map, x, y);
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
    _trayStackChildren.clear();
    _trayStackChildren.add(_trayImage);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutSpaces(appState);
      layoutBoxes(appState);
      layoutCalendar(appState);
      layoutOmnibus(appState);

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
                  width: _mapWidth + _trayWidth,
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
                        child: Stack(children: _trayStackChildren),
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

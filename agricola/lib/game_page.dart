import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:agricola/game.dart';
import 'package:agricola/main.dart';

enum BoardArea {
  map,
  display,
}

class GamePage extends StatefulWidget {

  const GamePage({super.key});

  @override
  GamePageState createState() {
    return GamePageState();
  }
}

class GamePageState extends State<GamePage> {
  static const _mapWidth = 816.0;
  static const _mapHeight = 1056.0;
  static const _displayWidth = 1056.0;
  static const _displayHeight = 816.0;

  final _displayOptionsFormKey = GlobalKey<FormState>();
 
  bool _emptyMap = false;

  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _displayImage = Image.asset('assets/images/display.png', key: UniqueKey(), width: _displayWidth, height: _displayHeight);
  final _mapStackChildren = <Widget>[];
  final _displayStackChildren = <Widget>[];
  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.dubbini0: 'map_tribe_dubbini_2',
      Piece.dubbini1: 'map_tribe_dubbini_2',
      Piece.corieltavvi0: 'map_tribe_corieltavvi_2',
      Piece.corieltavvi1: 'map_tribe_corieltavvi_2',
      Piece.catuvellani0: 'map_tribe_catuvellani_2',
      Piece.catuvellani1: 'map_tribe_catuvellani_2',
      Piece.iceni0: 'map_tribe_iceni_3',
      Piece.iceni1: 'map_tribe_iceni_3',
      Piece.silures0: 'map_tribe_silures_4',
      Piece.silures1: 'map_tribe_silures_4',
      Piece.silures2: 'map_tribe_silures_5',
      Piece.silures3: 'map_tribe_silures_5',
      Piece.deceangli0: 'map_tribe_deceangli_5',
      Piece.decenagli1: 'map_tribe_deceangli_6',
      Piece.ordovices0: 'map_tribe_ordovices_4',
      Piece.ordovices1: 'map_tribe_ordovices_5',
      Piece.ordovices2: 'map_tribe_ordovices_6',
      Piece.demetae0: 'map_tribe_demetae_3',
      Piece.demetae1: 'map_tribe_demetae_4',
      Piece.brigantes0: 'map_tribe_brigantes_5',
      Piece.brigantes1: 'map_tribe_brigantes_5',
      Piece.brigantes2: 'map_tribe_brigantes_6',
      Piece.brigantes3: 'map_tribe_brigantes_6',
      Piece.cornovvi0: 'map_tribe_cornovvi_4',
      Piece.cornovvi1: 'map_tribe_cornovvi_5',
      Piece.votadini0: 'map_tribe_votadini_4',
      Piece.votadini1: 'map_tribe_votadini_5',
      Piece.votadini2: 'map_tribe_votadini_6',
      Piece.parisi0: 'map_tribe_parisi_4',
      Piece.parisi1: 'map_tribe_parisi_5',
      Piece.damnonii0: 'map_tribe_damnonii_6',
      Piece.damnonii1: 'map_tribe_damnonii_6',
      Piece.damnonii2: 'map_tribe_damnonii_6',
      Piece.venicones0: 'map_tribe_venicones_6',
      Piece.venicones1: 'map_tribe_venicones_6',
      Piece.venicones2: 'map_tribe_venicones_6',
      Piece.taexali0: 'map_tribe_taexali_6',
      Piece.taexali1: 'map_tribe_taexali_6',
      Piece.taexali2: 'map_tribe_taexali_6',
      Piece.caledonii0: 'map_tribe_caledonii_7',
      Piece.caledonii1: 'map_tribe_caledonii_7',
      Piece.caledonii2: 'map_tribe_caledonii_7',
      Piece.caledonii3: 'map_tribe_caledonii_7',
      Piece.legionAugustaII: 'map_legion_augusta_II',
      Piece.legionHispanaIX: 'map_legion_hispana_IX',
      Piece.legionValeriaVictrixXX: 'map_legion_valeria_victrix_XX',
      Piece.leaderTan: 'map_leader_tan',
      Piece.leaderGreen: 'map_leader_green',
      Piece.leaderRedCalgacus: 'map_leader_red_calgacus',
      Piece.leaderAgricola: 'map_leader_agricola',
      Piece.garrison0: 'map_garrison',
      Piece.garrison1: 'map_garrison',
      Piece.garrison2: 'map_garrison',
      Piece.garrison3: 'map_garrison',
      Piece.garrison4: 'map_garrison',
      Piece.garrison5: 'map_garrison',
      Piece.garrison6: 'map_garrison',
      Piece.settlement0: 'map_settlement_2',
      Piece.settlement1: 'map_settlement_2',
      Piece.settlement2: 'map_settlement_2',
      Piece.settlement3: 'map_settlement_2',
      Piece.settlement4: 'map_settlement_3',
      Piece.settlement5: 'map_settlement_3',
      Piece.settlement6: 'map_settlement_3',
      Piece.settlement7: 'map_settlement_3',
      Piece.tribe0: 'battle_tribe_4_4',
      Piece.tribe1: 'battle_tribe_4_4',
      Piece.tribe2: 'battle_tribe_4_5',
      Piece.tribe3: 'battle_tribe_4_5',
      Piece.tribe4: 'battle_tribe_4_5',
      Piece.tribe5: 'battle_tribe_5_5',
      Piece.tribe6: 'battle_tribe_5_5',
      Piece.tribe7: 'battle_tribe_5_5',
      Piece.tribe8: 'battle_tribe_6_6',
      Piece.tribe9: 'battle_tribe_5_6',
      Piece.tribe10: 'battle_tribe_5_6',
      Piece.tribe11: 'battle_tribe_5_6',
      Piece.tribe12: 'battle_tribe_5_5',
      Piece.tribeGraupius0: 'battle_tribe_graupius_4_4',
      Piece.tribeGraupius1: 'battle_tribe_graupius_4_4',
      Piece.tribeGraupius2: 'battle_tribe_graupius_4_5',
      Piece.tribeGraupius3: 'battle_tribe_graupius_4_5',
      Piece.tribeGraupius4: 'battle_tribe_graupius_4_5',
      Piece.tribeGraupius5: 'battle_tribe_graupius_5_5',
      Piece.tribeGraupius6: 'battle_tribe_graupius_5_5',
      Piece.tribeGraupius7: 'battle_tribe_graupius_5_5',
      Piece.tribeGraupius8: 'battle_tribe_graupius_6_6',
      Piece.tribeGraupius9: 'battle_tribe_graupius_5_6',
      Piece.tribeGraupius10: 'battle_tribe_graupius_5_6',
      Piece.tribeGraupius11: 'battle_tribe_graupius_5_6',
      Piece.tribeGraupius12: 'battle_tribe_graupius5_6',
      Piece.auxiliaryBlue0: 'battle_auxiliary_blue_1_3',
      Piece.auxiliaryBlue1: 'battle_auxiliary_blue_1_3',
      Piece.auxiliaryBlue2: 'battle_auxiliary_blue_1_3',
      Piece.auxiliaryBlue3: 'battle_auxiliary_blue_1_3',
      Piece.auxiliaryBlue4: 'battle_auxiliary_blue_1_3',
      Piece.auxiliaryBlue5: 'battle_auxiliary_blue_1_3',
      Piece.auxiliaryBlue6: 'battle_auxiliary_blue_2_3',
      Piece.auxiliaryBlue7: 'battle_auxiliary_blue_2_3',
      Piece.auxiliaryTan0: 'battle_auxiliary_tan_2_4',
      Piece.auxiliaryTan1: 'battle_auxiliary_tan_2_4',
      Piece.auxiliaryTan2: 'battle_auxiliary_tan_2_4',
      Piece.auxiliaryTan3: 'battle_auxiliary_tan_3_4',
      Piece.auxiliaryTan4: 'battle_auxiliary_tan_2_4',
      Piece.auxiliaryTan5: 'battle_auxiliary_tan_2_4',
      Piece.auxiliaryTan6: 'battle_auxiliary_tan_2_4',
      Piece.auxiliaryTan7: 'battle_auxiliary_tan_2_4',
      Piece.auxiliaryTan8: 'battle_auxiliary_tan_3_4',
      Piece.auxiliaryTan9: 'battle_auxiliary_tan_2_4',
      Piece.auxiliaryTan10: 'battle_auxiliary_tan_2_4',
      Piece.auxiliaryGreen0: 'battle_auxiliary_green_2_4',
      Piece.auxiliaryGreen1: 'battle_auxiliary_green_2_4',
      Piece.auxiliaryGreen2: 'battle_auxiliary_green_3_4',
      Piece.auxiliaryGreen3: 'battle_auxiliary_green_3_4',
      Piece.auxiliaryGreen4: 'battle_auxiliary_green_2_4',
      Piece.auxiliaryGreen5: 'battle_auxiliary_green_3_4',
      Piece.auxiliaryGreen6: 'battle_auxiliary_green_2_4',
      Piece.auxiliaryGreen7: 'battle_auxiliary_green_2_4',
      Piece.auxiliaryGreen8: 'battle_auxiliary_green_3_4',
      Piece.auxiliaryGreen9: 'battle_auxiliary_green_2_3',
      Piece.auxiliaryGreen10: 'battle_auxiliary_green_2_3',
      Piece.legionary0: 'battle_legionary_2_4_1',
      Piece.legionary1: 'battle_legionary_2_4_1',
      Piece.legionary2: 'battle_legionary_2_4_1',
      Piece.legionary3: 'battle_legionary_2_4_1',
      Piece.legionary4: 'battle_legionary_2_4_1',
      Piece.legionary5: 'battle_legionary_2_4_1',
      Piece.legionary6: 'battle_legionary_2_4_1',
      Piece.legionary7: 'battle_legionary_3_5_2',
      Piece.legionary8: 'battle_legionary_3_5_2',
      Piece.legionary9: 'battle_legionary_3_5_2',
      Piece.legionary10: 'battle_legionary_3_5_2',
      Piece.legionary11: 'battle_legionary_3_5_2',
      Piece.legionary12: 'battle_legionary_3_5_2',
      Piece.legionary13: 'battle_legionary_3_5_2',
      Piece.legionary14: 'battle_legionary_3_5_2',
      Piece.legionary15: 'battle_legionary_3_6_3',
      Piece.legionary16: 'battle_legionary_3_6_3',
      Piece.legionary17: 'battle_legionary_3_6_3',
      Piece.legionary18: 'battle_legionary_3_6_3',
      Piece.legionary19: 'battle_legionary_3_6_3',
      Piece.legionary20: 'battle_legionary_3_6_3',
      Piece.legionary21: 'battle_legionary_3_6_3',
      Piece.legionary22: 'battle_legionary_3_6_3',
      Piece.markerGameTurn: 'marker_game_turn',
      Piece.markerIncome: 'marker_income',
      Piece.markerTreasury: 'marker_treasury',
      Piece.markerLegionActions: 'marker_legion_actions',
      Piece.markerVictoryPoints1: 'marker_1',
      Piece.markerVictoryPoints10: 'marker_10',
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
    case BoardArea.display:
      _displayStackChildren.add(widget);
    }
  }

  void addBoxToBoard(MyAppState appState, Location box, BoardArea boardArea, double x, double y, double boxHeight, double boxWidth) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(box);
    bool selected = playerChoices.selectedLocations.contains(box);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = SizedBox(
      height: boxHeight,
      width: boxWidth,
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
      left: x,
      top: y,
      child: widget,
    );

    switch (boardArea) {
    case BoardArea.map:
      _mapStackChildren.add(widget);
    case BoardArea.display:
      _displayStackChildren.add(widget);
    }
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.iceni: (BoardArea.map, 0.0, 0.0),
      Location.corieltavvi: (BoardArea.map, 0.0, 0.0),
      Location.dubunni: (BoardArea.map, 0.0, 0.0),
      Location.catuvellani: (BoardArea.map, 0.0, 0.0),
      Location.demetae: (BoardArea.map, 231.5, 779.0),
      Location.ordovices: (BoardArea.map, 421.5, 711.0),
      Location.silures: (BoardArea.map, 331.5, 861.0),
      Location.deceangli: (BoardArea.map, 313.0, 642.0),
      Location.parisi: (BoardArea.map, 674.5, 607.5),
      Location.cornovvi: (BoardArea.map, 526.5, 609.5),
      Location.votadini: (BoardArea.map, 487.5, 382.0),
      Location.brigantes: (BoardArea.map, 615.5, 464.5),
      Location.damnoni: (BoardArea.map, 0.0, 0.0),
      Location.taexali: (BoardArea.map, 0.0, 0.0),
      Location.venicones: (BoardArea.map, 0.0, 0.0),
      Location.caledonii: (BoardArea.map, 0.0, 0.0),
      Location.legionaryCampII: (BoardArea.map, 428.0, 901.0),
      Location.legionaryCampIX: (BoardArea.map, 671.0, 740.0),
      Location.legionaryCampXX: (BoardArea.map, 523.0, 747.0),
      Location.boxLegionHoldingII: (BoardArea.display, 66.0, 570.0),
      Location.boxLegionHoldingIX: (BoardArea.display, 396.0, 570.0),
      Location.boxLegionHoldingXX: (BoardArea.display, 726.0, 570.0),
      Location.poolForce: (BoardArea.display, 51.0, 90.0),
      Location.poolDead: (BoardArea.display, 0.0, 0.0),
      Location.boxLegionActions0: (BoardArea.map, 49.5, 55.0),
      Location.boxIncome1: (BoardArea.map, 49.5, 189.5),
      Location.boxVictory0: (BoardArea.map, 49.5, 468.0),
      Location.boxTurn1: (BoardArea.map, 49.5, 674.0),
    };
    return coordinates[location]!;
  }

  void addTribeToMap(MyAppState appState, Location box, double xBox, double yBox) {
    addBoxToBoard(appState, box, BoardArea.map, xBox - 72.0, yBox - 72.0, 130.0, 130.0);
  }

  void layoutTribe(MyAppState appState, Location box) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(box);
    final xBox = coordinates.$2;
    final yBox = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(box)) {
      addTribeToMap(appState, box, xBox, yBox);
    }

    if (!_emptyMap) {
      final tribes = state.piecesInLocation(PieceType.mapTribe, box);
      for (int depth = 0; depth < tribes.length; ++depth) {
        for (int i = 0; i < tribes.length; ++i) {
          final tribe = tribes[i];
          if (state.tribeStackDepth(tribe) == depth) {
            addPieceToBoard(appState, tribe, BoardArea.map, xBox + 4.0 * depth, yBox + 4.0 * depth);
          }
        }
      }
      final leader = state.pieceInLocation(PieceType.mapLeader, box);
      if (leader != null) {
        addPieceToBoard(appState, leader, BoardArea.map, xBox + 4.0 * tribes.length, yBox + 4.0 * tribes.length);
      }
    }
 
    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(box)) {
      addTribeToMap(appState, box, xBox, yBox);
    }
  }

  void layoutTribes(MyAppState appState) {
    for (final box in LocationType.tribe.locations) {
      layoutTribe(appState, box);
    }
  }

  void addLegionaryCampToMap(MyAppState appState, Location box, double xBox, double yBox) {
    addBoxToBoard(appState, box, BoardArea.map, xBox - 72.0, yBox - 72.0, 130.0, 130.0);
  }

  void layoutLegionaryCamp(MyAppState appState, Location box) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(box);
    final xBox = coordinates.$2;
    final yBox = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(box)) {
      addLegionaryCampToMap(appState, box, xBox, yBox);
    }

    if (!_emptyMap) {
      for (final piece in state.piecesInLocation(PieceType.map, box)) {
        addPieceToBoard(appState, piece, BoardArea.map, xBox, yBox);
      }
    }
 
    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(box)) {
      addLegionaryCampToMap(appState, box, xBox, yBox);
    }
  }

  void layoutLegionaryCamps(MyAppState appState) {
    for (final box in LocationType.legionaryCamp.locations) {
      layoutLegionaryCamp(appState, box);
    }
  }

  void addLegionHoldingBoxToMap(MyAppState appState, Location box, double xBox, double yBox) {
    addBoxToBoard(appState, box, BoardArea.display, xBox - 24.0, yBox - 92.0, 282.0, 296.0);
  }

  void layoutLegionHoldingBox(MyAppState appState, Location box) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(box);
    final boardArea  = coordinates.$1;
    double xBox = coordinates.$2;
    double yBox = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(box)) {
      addLegionHoldingBoxToMap(appState, box, xBox, yBox);
    }

    final legionaries = state.piecesInLocation(PieceType.battleLegionary, box);
    final auxiliaries = state.piecesInLocation(PieceType.auxiliaryBlue, box);
    final pieces = legionaries + auxiliaries;
    int cells = 4 * 3;
    for (int i = 0; i < pieces.length; ++i) {
      int col = i % 4;
      int row = (i % cells) ~/ 4;
      int depth = i ~/ cells;
      double x = xBox + col * (60.0 + 7.0) + depth * 4.0;
      double y = yBox + row * (60.0 + 7.0) + depth * 4.0;
      addPieceToBoard(appState, pieces[i], boardArea, x, y);
    }

    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(box)) {
      addLegionHoldingBoxToMap(appState, box, xBox, yBox);
    }
  }

  void layoutLegionHoldingBoxes(MyAppState appState) {
    for (final box in LocationType.legionHolding.locations) {
      layoutLegionHoldingBox(appState, box);
    }
  }

  void layoutBoxes(MyAppState appState) {
    const boxesInfo = {
      Location.poolForce: (3, 5, 3.0, 3.0),
      Location.poolDead: (1, 1, 0.0, 0.0),
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

  void layoutLegionActionsTrack(MyAppState appState) {
    final state = appState.gameState!;
    final coordinatesFirst = locationCoordinates(Location.boxLegionActions0);
    double xFirst = coordinatesFirst.$2;
    double yBox = coordinatesFirst.$3;
    final box = state.pieceLocation(Piece.markerLegionActions);
    final index = box.index - LocationType.legionActions.firstIndex;
    double xBox = xFirst + 72.0 * index;
    addPieceToBoard(appState, Piece.markerLegionActions, BoardArea.map, xBox, yBox);
  }
  
  void layoutIncomeTrack(MyAppState appState) {
    final state = appState.gameState!;
    final coordinatesFirst = locationCoordinates(Location.boxIncome1);
    double xFirst = coordinatesFirst.$2;
    double yFirst = coordinatesFirst.$3;
    for (final box in LocationType.income.locations) {
      final index = box.index - LocationType.income.firstIndex;
      int col = index % 5;
      int row = index ~/ 5;
      double xBox = xFirst + 72.0 * col;
      double yBox = yFirst + 72.0 * row;
      final pieces = state.piecesInLocation(PieceType.incomeTrack, box);
      for (int i = 0; i < pieces.length; ++i)
      {
        double x = xBox + 5.0 * i;
        double y = yBox + 5.0 * i;
        addPieceToBoard(appState, pieces[i], BoardArea.map, x, y);
      }
    }
  }

  void layoutVictoryTrack(MyAppState appState) {
    final state = appState.gameState!;
    final coordinatesFirst = locationCoordinates(Location.boxVictory0);
    double xFirst = coordinatesFirst.$2;
    double yFirst = coordinatesFirst.$3;
    for (final box in LocationType.victory.locations) {
      final index = box.index - LocationType.victory.firstIndex;
      int col = index % 5;
      int row = index ~/ 5;
      double xBox = xFirst + 72.0 * col;
      double yBox = yFirst + 72.0 * row;
      final pieces = state.piecesInLocation(PieceType.victoryTrack, box);
      for (int i = 0; i < pieces.length; ++i)
      {
        double x = xBox + 5.0 * i;
        double y = yBox + 5.0 * i;
        addPieceToBoard(appState, pieces[i], BoardArea.map, x, y);
      }
    }
  }

  void layoutGameTurnTrack(MyAppState appState) {
    final state = appState.gameState!;
    final coordinatesFirst = locationCoordinates(Location.boxTurn1);
    double xFirst = coordinatesFirst.$2;
    double yFirst = coordinatesFirst.$3;
    final box = state.pieceLocation(Piece.markerGameTurn);
    final index = box.index - LocationType.turn.firstIndex;
    int col = index % 2;
    int row = index ~/ 2;
    double xBox = xFirst + 72.0 * col;
    double yBox = yFirst + 72.0 * row;
    addPieceToBoard(appState, Piece.markerGameTurn, BoardArea.map, xBox, yBox);
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

      layoutTribes(appState);
      layoutLegionaryCamps(appState);
      layoutBoxes(appState);
      layoutLegionHoldingBoxes(appState);
      layoutLegionActionsTrack(appState);
      layoutIncomeTrack(appState);
      layoutVictoryTrack(appState);
      layoutGameTurnTrack(appState);

      const choiceTexts = {
        Choice.actionLeaderAttachLeader: 'Attach Leader',
        Choice.actionLeaderReorganizeLegion: 'Reorganize Legion',
        Choice.actionLeaderNegotiation: 'Negotiation',
        Choice.actionLegionSuppress: 'Suppress',
        Choice.actionLegionGarrison: 'Garrison',
        Choice.actionLegionPeacekeeping: 'Peacekeeping',
        Choice.actionLegionBattle: 'Battle',
        Choice.actionPass: 'Pass',
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

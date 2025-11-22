import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:kaiserkrieg/game.dart';
import 'package:kaiserkrieg/main.dart';

enum BoardArea {
  map,
  counterTray,
}

class GamePage extends StatefulWidget {

  const GamePage({super.key});

  @override
  GamePageState createState() {
    return GamePageState();
  }
}

class GamePageState extends State<GamePage> {
  static const _mapWidth = 1728.0;
  static const _mapHeight = 1728.0;
  static const _counterTrayWidth = 1335.0;
  static const _counterTrayHeight = 1728.0;
  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _counterTrayImage = Image.asset('assets/images/tray.png', key: UniqueKey(), width: _counterTrayWidth, height: _counterTrayHeight);
  final _mapStackChildren = <Widget>[];
  final _counterTrayChildren = <Widget>[];
  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.armyAao1: 'army_aao_1st',
      Piece.armyAao2: 'army_aao_2nd',
      Piece.armyAaoNdac: 'army_aao_ndac',
      Piece.armyAaoOrient: 'army_aao_orient',
      Piece.armyAaoSalonika: 'army_aao_salonika',
      Piece.armyArab: 'army_arab',
      Piece.armyArmenia1: 'army_armenia_1',
      Piece.armyArmenia2: 'army_armenia_2',
      Piece.armyAssyria: 'army_assyria',
      Piece.armyBelgium: 'army_belgium',
      Piece.armyBritain1: 'army_britain_1st',
      Piece.armyBritain2: 'army_britain_2nd',
      Piece.armyBritain3: 'army_britain_3rd',
      Piece.armyBritain4: 'army_britain_4th',
      Piece.armyBritainBef: 'army_britain_bef',
      Piece.armyBritainDunster: 'army_britain_dunster',
      Piece.armyBritainLawrence: 'army_britain_lawrence',
      Piece.armyBritainMef: 'army_britain_mef',
      Piece.armyBritain20: 'army_britain_xx',
      Piece.armyFrance1: 'army_france_1st',
      Piece.armyFrance2: 'army_france_2nd',
      Piece.armyFrance3: 'army_france_3rd',
      Piece.armyFrance4: 'army_france_4th',
      Piece.armyFrance5: 'army_france_5th',
      Piece.armyIndiaA: 'army_india_a',
      Piece.armyIndiaB: 'army_india_b',
      Piece.armyIndiaC: 'army_india_c',
      Piece.armyIndiaD: 'army_india_d',
      Piece.armyItaly1: 'army_italy_1st',
      Piece.armyItaly2: 'army_italy_2nd',
      Piece.armyItaly3: 'army_italy_3rd',
      Piece.armyItaly4: 'army_italy_4th',
      Piece.armyItalyCarnia: 'army_italy_carnia',
      Piece.armyRoumania1: 'army_roumania_1st',
      Piece.armyRoumania2: 'army_roumania_2nd',
      Piece.armyRoumaniaNorth: 'army_roumania_north',
      Piece.armyRussia1: 'army_russia_1st',
      Piece.armyRussia2: 'army_russia_2nd',
      Piece.armyRussia3: 'army_russia_3rd',
      Piece.armyRussia4: 'army_russia_4th',
      Piece.armyRussia5: 'army_russia_5th',
      Piece.armyRussia6: 'army_russia_6th',
      Piece.armyRussia7: 'army_russia_7th',
      Piece.armyRussia8: 'army_russia_8th',
      Piece.armyRussia9: 'army_russia_9th',
      Piece.armyRussia10: 'army_russia_10th',
      Piece.armyRussiaCaucasus: 'army_russia_caucasus',
      Piece.armyRussiaCossack: 'army_russia_cossack',
      Piece.armyRussiaKars: 'army_russia_kars',
      Piece.armyRussiaTurkestan: 'army_russia_turkestan',
      Piece.armySerbia1: 'army_serbia_1st',
      Piece.armySerbia2: 'army_serbia_2nd',
      Piece.armySerbia3: 'army_serbia_3rd',
      Piece.armySerbiaMontenegro: 'army_serbia_montenegro',
      Piece.armySerbiaUzice: 'army_serbia_uzice',
      Piece.armySouthAfrica: 'army_south_africa',
      Piece.armyUsa1: 'army_usa_i',
      Piece.armyUsa4: 'army_usa_iv',
      Piece.armyUsa5: 'army_usa_v',
      Piece.armyUsa6: 'army_usa_vi',
      Piece.tank: 'tank',
      Piece.forts_0: 'forts',
      Piece.forts_1: 'forts',
      Piece.siegfriedLine: 'siegfried_line',
      Piece.trenches_0: 'trenches',
      Piece.trenches_1: 'trenches',
      Piece.overTheTopAao: 'over_the_top_aao',
      Piece.overTheTopBritain: 'over_the_top_britain',
      Piece.overTheTopFrance: 'over_the_top_france',
      Piece.overTheTopItaly: 'over_the_top_italy',
      Piece.overTheTopRussia_0: 'over_the_top_russia',
      Piece.overTheTopRussia_1: 'over_the_top_russia',
      Piece.overTheTopSerbia: 'over_the_top_serbia',
      Piece.pinkFrance: 'pink_france',
      Piece.pinkItaly: 'pink_italy',
      Piece.pinkRussia_0: 'pink_russia',
      Piece.pinkRussia_1: 'pink_russia',
      Piece.pinkSerbia: 'pink_serbia',
      Piece.armenians: 'armenians',
      Piece.askari_0: 'askari',
      Piece.askari_1: 'askari',
      Piece.siegeKut: 'siege_kut',
      Piece.cruiser_0: 'cruiser',
      Piece.cruiser_1: 'cruiser',
      Piece.cruiser_2: 'cruiser',
      Piece.cruiser_3: 'cruiser',
      Piece.blockadeRunnerDenmark: 'runner_denmark',
      Piece.blockadeRunnerNetherlands: 'runner_netherlands',
      Piece.blockadeRunnerNorway: 'runner_norway',
      Piece.blockadeRunnerSweden: 'runner_sweden',
      Piece.uboats_0: 'uboats',
      Piece.uboats_1: 'uboats',
      Piece.highSeasFleet: 'high_seas_fleet',
      Piece.cityBerlin: 'city_berlin',
      Piece.cityBreslau: 'city_breslau',
      Piece.cityCologne: 'city_cologne',
      Piece.cityDresden: 'city_dresden',
      Piece.cityFrankfurt: 'city_frankfurt',
      Piece.cityHamburg: 'city_hamburg',
      Piece.cityLeipzig: 'city_leipzig',
      Piece.cityMunich: 'city_munich',
      Piece.cityPrague: 'city_prague',
      Piece.cityVienna: 'city_vienna',
      Piece.cityBudapest: 'city_budapest',
      Piece.airSuperiority: 'air_superiority',
      Piece.bombersBritish: 'bombers_british',
      Piece.bombersGerman: 'bombers_german',
      Piece.zeppelin: 'zeppelin',
      Piece.redBaron: 'red_baron',
      Piece.hindenLuden: 'hinden_luden',
      Piece.civilConstitution: 'civil_constitution',
      Piece.civilFreePress: 'civil_free_press',
      Piece.civilRuleOfLaw: 'civil_rule_of_law',
      Piece.krupp: 'krupp',
      Piece.kaisertreu: 'kaisertreu',
      Piece.railway: 'railway',
      Piece.kemal: 'kemal',
      Piece.neutralBulgaria: 'neutral_bulgaria',
      Piece.neutralItaly: 'neutral_italy',
      Piece.neutralOttoman: 'neutral_ottoman',
      Piece.neutralRoumania: 'neutral_roumania',
      Piece.surrenderFrance: 'surrender_france',
      Piece.surrenderItaly: 'surrender_italy',
      Piece.surrenderOttoman: 'surrender_ottoman',
      Piece.surrenderRoumania: 'surrender_roumania',
      Piece.frenchMutiny: 'french_mutiny',
      Piece.roumaniaHypothesis: 'roumania_hypothesis',
      Piece.specialEvent: 'special_event',
      Piece.reichsmark: 'reichsmark',
      Piece.lira: 'lira',
      Piece.lira0_0: 'lira_0',
      Piece.lira0_1: 'lira_0',
      Piece.lira0_2: 'lira_0',
      Piece.lira1_0: 'lira_1',
      Piece.lira1_1: 'lira_1',
      Piece.lira1_2: 'lira_1',
      Piece.lira2_0: 'lira_2',
      Piece.lira2_1: 'lira_2',
      Piece.lira2_2: 'lira_2',
      Piece.lira2_3: 'lira_2',
      Piece.lira2_4: 'lira_2',
      Piece.lira3_0: 'lira_3',
      Piece.lira3_1: 'lira_3',
      Piece.lira3_2: 'lira_3',
      Piece.lira4_0: 'lira_4',
      Piece.lira4_1: 'lira_4',
      Piece.lira5_0: 'lira_5',
      Piece.lira5_1: 'lira_5',
      Piece.turn01: 'turn_01',
      Piece.turn02: 'turn_02',
      Piece.turn03: 'turn_03',
      Piece.turn04: 'turn_04',
      Piece.turn05: 'turn_05',
      Piece.turn06: 'turn_06',
      Piece.turn07: 'turn_07',
      Piece.turn08: 'turn_08',
      Piece.turn09: 'turn_09',
      Piece.turn10: 'turn_10',
      Piece.turn11: 'turn_11',
      Piece.turn12: 'turn_12',
      Piece.turn13: 'turn_13',
      Piece.turn14: 'turn_14',
      Piece.turn15: 'turn_15',
      Piece.turn16: 'turn_16',
      Piece.turn17: 'turn_17',
      Piece.turn18: 'turn_18',
      Piece.turn19: 'turn_19',
      Piece.turn20: 'turn_20',
      Piece.turn21: 'turn_21',
      Piece.turn22: 'turn_22',
      Piece.turn23: 'turn_23',
      Piece.turn24: 'turn_24',
      Piece.turn25: 'turn_25',
      Piece.turn26: 'turn_26',
      Piece.turn27: 'turn_27',
      Piece.turn28: 'turn_28',
      Piece.armyArabInactive: 'army_arab',
    };

    for (final counterName in counterNames.entries) {
      final imagePath = 'assets/images/${counterName.value}.png';
      final opacity = counterName.key == Piece.armyArabInactive ? 0.5 : 1.0;
      _counters[counterName.key] = Image.asset(imagePath,
        key: UniqueKey(),
        width: 60.0, height:60.0,
        opacity: opacity == 1.0 ? null : AlwaysStoppedAnimation<double>(opacity),
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
      widget = IconButton(
        padding: const EdgeInsets.all(0.0),
        iconSize: 60.0,
        onPressed: () {
          appState.chosePiece(piece);
        },
        icon: widget,
      );
    }

    if (piece != Piece.armyArabInactive) {
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
    }

    widget = Positioned(
      left: x - borderWidth,
      top: y - borderWidth,
      child: widget,
    );

    switch (boardArea) {
    case BoardArea.map:
      _mapStackChildren.add(widget);
    case BoardArea.counterTray:
      _counterTrayChildren.add(widget);
    }
  }

  void addSeaToMap(MyAppState appState, Location sea, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(sea);
    bool selected = playerChoices.selectedLocations.contains(sea);

    if (!choosable /* && !selected */) {
      return;
    }

    Widget? widget;

    double halfSize = 0.0;

    if (choosable) {
      widget = IconButton(
          padding: const EdgeInsets.all(0.0),
          iconSize: 60.0,
          onPressed: () {
            appState.choseLocation(sea);
          },
          icon: const Icon(null, size: 60.0),
        );
      halfSize = 30.0;
    }

    if (choosable) {
      widget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: Colors.yellow, width: 5.0),
        ),
        child: widget,
      );
      halfSize += 5.0;
    } else if (selected) {
      widget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: Colors.red, width: 5.0),
        ),
        child: widget,
      );
      halfSize += 5.0;
    }

    widget = Positioned(
      left: x - halfSize,
      top: y - halfSize,
      child: widget!,
    );

    _mapStackChildren.add(widget);
  }

  void addBoxToMap(MyAppState appState, Location sea, double x, double y) {
    var widget =
     Positioned(
      left: x - 10,
      top: y - 10,
      child: PhysicalModel(
        shape: BoxShape.circle,
        color: Colors.yellow,
        child: IconButton(
          onPressed: () {
            appState.choseLocation(sea);
          },
          icon: const Icon(null, size: 20.0),
        ),
      ),
    );

    _mapStackChildren.add(widget);
  }

  final fronts = [
    (Location.belgium, 406.0, 923.0, [
      Piece.armyBelgium, Piece.armyBritainBef, Piece.armyBritain1, Piece.armyBritain2, Piece.armyBritain3, Piece.armyBritain4, Piece.armyUsa5, Piece.armyUsa6,
      Piece.overTheTopBritain,
      Piece.forts_0, Piece.trenches_0, Piece.uboats_0, Piece.uboats_1, Piece.siegfriedLine]),
    (Location.france, 501.0, 1148.0, [
      Piece.armyFrance1, Piece.armyFrance2, Piece.armyFrance3, Piece.armyFrance4, Piece.armyFrance5, Piece.armyUsa1, Piece.armyUsa4,
      Piece.overTheTopFrance, Piece.pinkFrance, Piece.surrenderFrance,
      Piece.forts_1, Piece.trenches_1, Piece.tank, Piece.frenchMutiny, Piece.uboats_0, Piece.uboats_1]),
    (Location.italy, 773.0, 1256.0, [
      Piece.armyItaly1, Piece.armyItaly2, Piece.armyItaly3, Piece.armyItaly4, Piece.armyItalyCarnia, Piece.armyBritain3, Piece.armyFrance4, Piece.armyUsa1,
      Piece.overTheTopItaly, Piece.pinkItaly, Piece.surrenderItaly,
      Piece.neutralItaly]),
    (Location.serbia, 1046.0, 1311.0, [
      Piece.armySerbia1, Piece.armySerbia2, Piece.armySerbia3, Piece.armySerbiaMontenegro, Piece.armySerbiaUzice,
      Piece.armyAao1, Piece.armyAao2, Piece.armyAaoNdac, Piece.armyAaoOrient, Piece.armyAaoSalonika,
      Piece.overTheTopSerbia, Piece.overTheTopAao, Piece.pinkSerbia]),
    (Location.ukraine, 1184.0, 922.0, [
      Piece.armyRussia3, Piece.armyRussia5, Piece.armyRussia7, Piece.armyRussia8, Piece.armyRussia9,
      Piece.overTheTopRussia_1, Piece.pinkRussia_0]),
    (Location.lithuania, 1057.0, 702.0, [
      Piece.armyRussia1, Piece.armyRussia2, Piece.armyRussia4, Piece.armyRussia6, Piece.armyRussia10,
      Piece.overTheTopRussia_0, Piece.pinkRussia_1]),
  ];

  void layoutFront(MyAppState appState, Location location, double x, double y, List<Piece> pieces) {
    GameState state = appState.gameState!;
    var defenders = <Piece>[];
    var others = <Piece>[];
    for (final piece in pieces) {
      if (state.pieceLocation(piece) == location) {
        if (piece.isType(PieceType.army) || piece.isType(PieceType.overTheTop) || piece.isType(PieceType.forts) || piece.isType(PieceType.trenches)) {
          defenders.add(piece);
        } else {
          others.add(piece);
        }
      }
    }
    for (int i = 0; i < defenders.length; ++i) {
      int col = i % 3;
      int row = i ~/ 3;
      double xC = x + col * 62.0;
      double yC = y + row * 62.0;
      addPieceToBoard(appState, defenders[i], BoardArea.map, xC, yC);
    }
    for (int i = 0; i < others.length; ++i) {
      int col = others.length == 1 && defenders.length <= 6 ? 1 : 2 - (i % 3);
      int row = others.length == 1 && defenders.length <= 3 ? 1 : 2 + i ~/ 3;
      double xC = x + col * 62.0;
      double yC = y + row * 62.0;
      addPieceToBoard(appState, others[i], BoardArea.map, xC, yC);
    }
  }

  void layoutFronts(MyAppState appState) {
    for (final front in fronts) {
      layoutFront(appState, front.$1, front.$2, front.$3, front.$4);
    }
  }

  final ottomanBoxes = [
    (Location.yerevan, 1566.0, 601.0, [
      Piece.armyRussiaCaucasus, Piece.armyRussiaCossack, Piece.armyRussiaKars, Piece.armyRussiaTurkestan,
      Piece.armyArmenia1, Piece.armyArmenia2, Piece.armyAssyria, Piece.armyBritainDunster]),
    (Location.armenia, 1566.0, 751.0, [
      Piece.armyRussiaCaucasus, Piece.armyRussiaCossack, Piece.armyRussiaKars, Piece.armyRussiaTurkestan,
      Piece.armyArmenia1, Piece.armyArmenia2, Piece.armyAssyria, Piece.armyBritainDunster,
      Piece.armenians, Piece.kemal]),
    (Location.india, 1566.0, 971.0, [
      Piece.armyIndiaA, Piece.armyIndiaB, Piece.armyIndiaC, Piece.armyIndiaD]),
    (Location.mespotamia, 1566.0, 1101.0, [
      Piece.armyIndiaA, Piece.armyIndiaB, Piece.armyIndiaC, Piece.armyIndiaD,
      Piece.siegeKut]),
     (Location.egypt, 1566.0, 1341.0, [
      Piece.armyArab, Piece.armyBritain20, Piece.armyBritainLawrence, Piece.armySouthAfrica]),
     (Location.palestine, 1566.0, 1481.0, [
      Piece.armyArab, Piece.armyBritain20, Piece.armyBritainLawrence, Piece.armySouthAfrica,
      Piece.armyArabInactive]),
     (Location.eastAfrica, 43.0, 1113.0, [
      Piece.armyIndiaA, Piece.armyIndiaB, Piece.armyIndiaC, Piece.armyIndiaD,
      Piece.askari_0, Piece.askari_1]),
 ];

  void layoutOttomanBox(MyAppState appState, Location location, double x, double y, List<Piece> pieces) {
    final state = appState.gameState!;
    var armies = <Piece>[];
    var nonArmies = <Piece>[];
    for (final piece in pieces) {
      if (state.pieceLocation(piece) == location) {
        if (piece == Piece.armyArabInactive) {
          addPieceToBoard(appState, piece, BoardArea.map, x + 30.0, y + 75.0);
        } else if (piece.isType(PieceType.army) || piece.isType(PieceType.askari)) {
          armies.add(piece);
        } else {
          nonArmies.add(piece);
        }
      }
    }
    for (int i = 0; i < armies.length; ++i) {
      int col = i % 2;
      int row = i ~/ 2;
      double xC = x + col * 62.0;
      double yC = y + row * 62.0;
      addPieceToBoard(appState, armies[i], BoardArea.map, xC, yC);
    }
    for (int i = 0; i < nonArmies.length; ++i) {
      int col = i % 2;
      int row = 2 + i ~/ 2;
      double xC = x + col * 62.0;
      double yC = y + row * 62.0;
      addPieceToBoard(appState, nonArmies[i], BoardArea.map, xC, yC);
    }
  }

  void layoutOttomanBoxes(MyAppState appState) {
    for (final box in ottomanBoxes) {
      layoutOttomanBox(appState, box.$1, box.$2, box.$3, box.$4);
    }
  }

  final germanyPieces = [
    (Piece.siegfriedLine, 640.0, 1010.0),
    (Piece.redBaron, 670.0, 1080.0),
    (Piece.zeppelin, 660.0, 940.0),
    (Piece.bombersGerman, 710.0, 1010.0),
    (Piece.bombersBritish, 730.0, 940.0),
    (Piece.highSeasFleet, 710.0, 870.0),
    (Piece.civilConstitution, 860.0, 990.0),
    (Piece.civilFreePress, 770.0, 1160.0),
    (Piece.civilRuleOfLaw, 780.0, 1010.0),
    (Piece.hindenLuden, 890.0, 920.0),
  ];

  void layoutGermany(MyAppState appState) {
    final state = appState.gameState!;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(Location.germany)) {
      addSeaToMap(appState, Location.germany, 710.0, 870.0);
    }

    for (final piece in germanyPieces) {
      if (state.pieceLocation(piece.$1) == Location.germany) {
        addPieceToBoard(appState, piece.$1, BoardArea.map, piece.$2, piece.$3);
      }
    }

    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(Location.germany)) {
      addSeaToMap(appState, Location.germany, 740.0, 900.0);
    }
  }

  final austriaHungaryPieces = [
    (Piece.roumaniaHypothesis, 1150.0, 1150.0),
  ];

  void layoutAustriaHungary(MyAppState appState) {
    final state = appState.gameState!;
    for (final piece in austriaHungaryPieces) {
      if (state.pieceLocation(piece.$1) == Location.austriaHungary) {
        addPieceToBoard(appState, piece.$1, BoardArea.map, piece.$2, piece.$3);
      }
    }
  }

  final turkeyPieces = [
    (Piece.neutralOttoman, 1415.0, 1560.0),
    (Piece.surrenderOttoman, 1415.0, 1560.0),
  ];

  void layoutTurkey(MyAppState appState) {
    final state = appState.gameState!;
    for (final piece in turkeyPieces) {
      if (state.pieceLocation(piece.$1) == Location.turkey) {
        addPieceToBoard(appState, piece.$1, BoardArea.map, piece.$2, piece.$3);
      }
    }
  }

  void layoutRoumania(MyAppState appState) {
    final state = appState.gameState!;
    const x = 1314.0;
    const y = 1116.0;
    const pieces = [
      Piece.armyRoumania1, Piece.armyRoumania2, Piece.armyRoumaniaNorth,
      Piece.neutralRoumania, Piece.surrenderRoumania
    ];

    int armyCount = 0;
    for (final piece in pieces) {
      if (state.pieceLocation(piece) == Location.roumania) {
        if (piece.isType(PieceType.army)) {
          int col = armyCount % 2;
          int row = armyCount ~/ 2;
          final xC = x + col * 64.0;
          final yC = y + row * 64.0;
          addPieceToBoard(appState, piece, BoardArea.map, xC, yC);
          armyCount += 1;
        } else {
          addPieceToBoard(appState, piece, BoardArea.map, x + 32.0, y + 42.0);
        }
      }
    }
  }

  final singleCounterBoxes = [
    (Location.bulgaria, 1301.0, 1330.0, [Piece.neutralBulgaria, Piece.railway]),
    (Location.gallipoli, 1276.0, 1470.0, [Piece.armyBritainMef]),
    (Location.ireland, 244.0, 882.0, [Piece.armyBritain1, Piece.armyBritain2, Piece.armyBritain3, Piece.armyBritain4, Piece.armyBritainBef,
                                        Piece.armyUsa5, Piece.armyUsa6]),
    (Location.senussiRevolt, 1000.0, 1614.0, [Piece.armyBritain20, Piece.armyBritainLawrence, Piece.armySouthAfrica, Piece.armyBritain3,
                                                Piece.armyItaly1, Piece.armyItaly2, Piece.armyItaly3, Piece.armyItaly4, Piece.armyItalyCarnia])
  ];

  void layoutSingleCounterBox(MyAppState appState, Location location, double x, double y, List<Piece> candidatePieces) {
    final state = appState.gameState!;
    final pieces = <Piece>[];
    for (final piece in candidatePieces) {
      if (state.pieceLocation(piece) == location) {
        pieces.add(piece);
      }
    }
    for (int i = 0; i < pieces.length; ++i) {
      final piece = pieces[i];
      double d = pieces.length == 1 ? 0.0 : i == 0 ? 10.0 : -10.0;
      addPieceToBoard(appState, piece, BoardArea.map, x + d, y + d);
    }
  }

  void layoutSingleCounterBoxes(MyAppState appState) {
    for (final box in singleCounterBoxes) {
      layoutSingleCounterBox(appState, box.$1, box.$2, box.$3, box.$4);
    }
  }

  final seas = [
    (Location.sea1a, 175.0, 703.0),
    (Location.sea1b, 1330.0, 1612.0),
    (Location.sea2a, 1017.0, 1477.0),
    (Location.sea2b, 471.0, 767.0),
    (Location.sea2c, 661.0, 769.0),
    (Location.sea3, 560.0, 838.0),
    (Location.sea4, 660.0, 890.0),
  ];

  void layoutSea(MyAppState appState, Location location, double x, double y) {
    final state = appState.gameState!;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(location)) {
      addSeaToMap(appState, location, x, y);
    }

    Piece? blockadeRunner;
    Piece? highSeasFleet;
    final cruisers = <Piece>[];

    for (int pieceIndex = PieceType.blockadeRunner.firstIndex; pieceIndex < PieceType.blockadeRunner.lastIndex; ++pieceIndex) {
      final piece = Piece.values[pieceIndex];
      if (state.pieceLocation(piece) == location) {
        blockadeRunner = piece;
      }
    }
    if (state.pieceLocation(Piece.highSeasFleet) == location) {
      highSeasFleet = Piece.highSeasFleet;
    }
    for (int pieceIndex = PieceType.cruiser.firstIndex; pieceIndex < PieceType.cruiser.lastIndex; ++pieceIndex) {
      final piece = Piece.values[pieceIndex];
      if (state.pieceLocation(piece) == location) {
        cruisers.add(piece);
      }
    }

    double xCentralPowers = x - 30.0;
    double yCentralPowers = y - 30.0;
    double xEntente = xCentralPowers;
    double yEntente = yCentralPowers;

    if (cruisers.isNotEmpty) {
      xCentralPowers += 33.0;
    }

    if (blockadeRunner != null) {
      double d = highSeasFleet != null ? 5.0 : 0.0;
      addPieceToBoard(appState, blockadeRunner, BoardArea.map, xCentralPowers + d, yCentralPowers + d);
    }
    if (highSeasFleet != null) {
      addPieceToBoard(appState, highSeasFleet, BoardArea.map, xCentralPowers - 5.0, yCentralPowers - 5.0);
    }

    if (blockadeRunner != null) {
      xEntente -= 33.0;
    }

    for (int i = 0; i < cruisers.length; ++i) {
      double d = 0;
      if (cruisers.length > 1) {
        d = -2.0 + i * 4.0;
      }
      addPieceToBoard(appState, cruisers[i], BoardArea.map, xEntente + d, yEntente + d);
    }

    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(location)) {
      addSeaToMap(appState, location, x, y);
    }
  }

  void layoutSeas(MyAppState appState) {
    for (final sea in seas) {
      layoutSea(appState, sea.$1, sea.$2, sea.$3);
    }
  }

  final shipBoxes = [
    (Location.britishCruisers, 164.0, 451.0, [
      Piece.cruiser_0, Piece.cruiser_1, Piece.cruiser_2, Piece.cruiser_3]),
    (Location.blockadeRunners, 41.0, 921.0, [
      Piece.blockadeRunnerDenmark, Piece.blockadeRunnerNetherlands, Piece.blockadeRunnerNorway, Piece.blockadeRunnerSweden]),
  ];

  void layoutShipBox(MyAppState appState, location, x, y, pieces) {
    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(location)) {
      addBoxToMap(appState, location, x, y);
    }

    final state = appState.gameState!;
    int count = 0;
    for (final piece in pieces) {
      if (state.pieceLocation(piece) == location) {
        int col = count % 2;
        int row = count ~/ 2;
        final xC = x + col * 65.0;
        final yC = y + row * 65.0;
        addPieceToBoard(appState, piece, BoardArea.map, xC, yC);
        count += 1;
      }
    }
  }

  void layoutShipBoxes(MyAppState appState) {
    for (final box in shipBoxes) {
      layoutShipBox(appState, box.$1, box.$2, box.$3, box.$4);
    }
  }

  void layoutNeutralPorts(MyAppState appState) {
    final state = appState.gameState!;
    const x = 789.0;
    const y = 645.0;
    int count = 0;
    for (final blockadeRunner in PieceType.blockadeRunner.pieces) {
      if (state.pieceLocation(blockadeRunner) == Location.neutralPorts) {
        int col = count % 2;
        int row = count ~/ 2;
        final xC = x + col * 65.0;
        final yC = y + row * 65.0;
        addPieceToBoard(appState, blockadeRunner, BoardArea.map, xC, yC);
        count += 1;
      }
    }
  }

  void layoutAirSuperiority(MyAppState appState) {
    final state = appState.gameState!;
    const piece = Piece.airSuperiority;
    final location = state.pieceLocation(piece);
    int col = location.index - LocationType.airSuperiority.firstIndex;
    addPieceToBoard(appState, piece, BoardArea.map, 80.0 + col * 137.0, 1385.0);
  }

  final cityBoxes = [
    (Location.ruhe, 48.0, 1531.0),
    (Location.unruhe, 448.0, 1531.0),
  ];

  void layoutCityBox(MyAppState appState, Location location, double x, double y) {
    final state = appState.gameState!;
    int count = 0;
    for (final city in PieceType.city.pieces) {
      if (state.pieceLocation(city) == location) {
        int col = count % 6;
        int row = count ~/ 6;
        double xC = x + col * 64.0;
        double yC = y + row * 75.0;
        addPieceToBoard(appState, city, BoardArea.map, xC, yC);
        count += 1;
      }
    }
  }

  void layoutCityBoxes(MyAppState appState) {
    for (final box in cityBoxes) {
      layoutCityBox(appState, box.$1, box.$2, box.$3);
    }
  }

  void layoutSpecialEvent(MyAppState appState) {
    final state = appState.gameState!;
    const x = 520.0;
    const y = 49.0;
    final location = state.pieceLocation(Piece.specialEvent);
    if (location.isType(LocationType.event)) {
      int index = location.index - LocationType.event.firstIndex;
      int col = index % 4;
      int row = index ~/ 4;
      final xB = x + col * 164.0;
      final yB = y + row * 84.0;
      addPieceToBoard(appState, Piece.specialEvent, BoardArea.map, xB, yB);
    }
  }

  static const calendarPieces = [
    Piece.armyUsa1, Piece.armyUsa4, Piece.armyUsa5, Piece.armyUsa6,
    Piece.redBaron, Piece.zeppelin, Piece.highSeasFleet,
    Piece.cruiser_1, Piece.cruiser_2, Piece.cruiser_3,
    Piece.turn01, Piece.turn02, Piece.turn03, Piece.turn04, Piece.turn05, Piece.turn06,
    Piece.turn07, Piece.turn08, Piece.turn09, Piece.turn10, Piece.turn11, Piece.turn12,
    Piece.turn13, Piece.turn14, Piece.turn15, Piece.turn16, Piece.turn17, Piece.turn18,
    Piece.turn19, Piece.turn20, Piece.turn21, Piece.turn22, Piece.turn23, Piece.turn24,
    Piece.turn25, Piece.turn26, Piece.turn27, Piece.turn28,
  ];

  void layoutCalendar(MyAppState appState) {
    final state = appState.gameState!;
    const x = 1119.0;
    const y = 44.0;
    for (final box in LocationType.calendarWithHundredDays.locations) {
      int turn = box.index - LocationType.calendarWithHundredDays.firstIndex;
      int col = turn % 6;
      int row = turn ~/ 6;
      final xB = x + col * 97.0;
      final yB = y + row * 70.0;
      Piece? turnChit;
      var otherPieces = <Piece>[];
      for (final piece in calendarPieces) {
        if (state.pieceLocation(piece) == box) {
          if (piece.isType(PieceType.turn)) {
            turnChit = piece;
          } else {
            otherPieces.add(piece);
          }
        }
      }
      int adj = otherPieces.length - 1;
      for (int i = 0; i < otherPieces.length; ++i) {
        final piece = otherPieces[i];
        int d = otherPieces.length - 1 - i;
        addPieceToBoard(appState, piece, BoardArea.map, xB + 20.0 - adj * 4.0 + d * 8.0, yB);
      }
      if (turnChit != null) {
        addPieceToBoard(appState, turnChit, BoardArea.map, xB, yB);
      }
    }
  }

  final omnibusPieces = [
    Piece.pinkRussia_0, Piece.armyBritainMef, Piece.kaisertreu, Piece.krupp, Piece.lira, Piece.reichsmark,
  ];

  void layoutOmnibus(MyAppState appState) {
    final state = appState.gameState!;
    const x = 500.0;
    const y = 455.0;
    for (final box in LocationType.omnibus.locations) {
      int col = box.index - LocationType.omnibus.firstIndex;
      final xB = x + col * 86.8;
      var pieces = <Piece>[];
      for (final piece in omnibusPieces) {
        if (state.pieceLocation(piece) == box) {
          pieces.add(piece);
        }
      }
     int adj = pieces.length - 1;
      for (int i = 0; i < pieces.length; ++i) {
        final piece = pieces[i];
        int d = pieces.length - 1 - i;
        addPieceToBoard(appState, piece, BoardArea.map, xB - adj * 2.0 + d * 4.0, y - adj * 2.0 + d * 4.0);
      }
    }
  }

  static const trayBoxInfo = {
    Location.belgiumReserves: (141.0, 200.0, 0.0, 10.0, 1, 6),
    Location.franceReserves: (340.0, 200.0, 0.0, 10.0, 1, 6),
    Location.italyReserves: (539.0, 200.0, 0.0, 10.0, 1, 6),
    Location.serbiaReserves: (738.0, 200.0, 0.0, 10.0, 1, 6),
    Location.ukraineReserves: (937.0, 200.0, 0.0, 10.0, 1, 6),
    Location.lithuaniaReserves: (1136.0, 200.0, 0.0, 10.0, 1, 6),
    Location.trayTurn: (90.0, 660.0, 5.0, 0.0, 18, 1),
    Location.trayEconomic: (82.0, 771.0, 5.0, 0.0, 9, 1),
    Location.trayCentralPowersSociety: (685.0, 771.0, 5.0, 0.0, 9, 1),
    Location.trayFrench: (79.0, 841.0, 15.0, 0.0, 4, 2),
    Location.trayItalian: (380.0, 841.0, 15.0, 0.0, 4, 2),
    Location.traySerbian: (705.0, 841.0, 25.0, 0.0, 3, 2),
    Location.trayArmenian: (1010.0, 841.0, 25.0, 0.0, 3, 2),
    Location.trayRoumanian: (102.0, 976.0, 25.0, 10.0, 3, 2),
    Location.trayAao: (405.0, 976.0, 25.0, 10.0, 3, 2),
    Location.trayAmerican: (690.0, 1045.0, 10.0, 0.0, 4, 1),
    Location.trayCentralPowersSpecialty: (1010.0, 1050.0, 25.0, 15.0, 3, 3),
    Location.trayRussian: (95.0, 1134.0, 10.0, 5.0, 6, 2),
    Location.trayBritish: (545.0, 1134.0, 10.0, 5.0, 6, 2),
    Location.trayNaval: (95.0, 1284.0, 10.0, 5.0, 6, 2),
    Location.trayMarkers: (350.0, 1470.0, 25.0, 0.0, 2, 1),
    Location.trayEntenteSpecialty: (545.0, 1340.0, 10.0, 10.0, 6, 3),
    Location.trayPink: (1010.0, 1281.0, 25.0, 5.0, 3, 2),
    Location.trayOttoman: (990.0, 1475.0, 10.0, 0.0, 4, 1),
  };

  void layoutTrayBox(MyAppState appState, Location box) {
    final state = appState.gameState!;
    final info = trayBoxInfo[box]!;
    double xTray = info.$1;
    double yTray = info.$2;
    double xGap = info.$3;
    double yGap = info.$4;
    int cols = info.$5;
    int rows = info.$6;
    final pieces = <Piece>[];
    for (final piece in PieceType.all.pieces) {
      if (state.pieceLocation(piece) == box) {
        pieces.add(piece);
      }
    }
    int cells = cols * rows;
    int layers = (pieces.length + cells - 1) ~/ cells;
    for (int i = pieces.length - 1; i >= 0; --i) {
      int col = i % cols;
      int row = (i % cells) ~/ cols;
      int depth = i ~/ cells;
      double x = xTray + col * (60.0 + xGap) - (layers - 1) * 2.0 + depth * 4.0;
      double y = yTray + row * (60.0 + yGap) - (layers - 1) * 2.0 + depth * 4.0;
      addPieceToBoard(appState, pieces[i], BoardArea.counterTray, x, y);
    }
  }

  void layoutTrayBoxes(MyAppState appState) {
    for (final box in trayBoxInfo.keys) {
      layoutTrayBox(appState, box);
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
    _counterTrayChildren.clear();
    _counterTrayChildren.add(_counterTrayImage);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {
      layoutFronts(appState);
      layoutOttomanBoxes(appState);
      layoutGermany(appState);
      layoutAustriaHungary(appState);
      layoutTurkey(appState);
      layoutRoumania(appState);
      layoutSingleCounterBoxes(appState);
      layoutSeas(appState);
      layoutNeutralPorts(appState);
      layoutShipBoxes(appState);
      layoutAirSuperiority(appState);
      layoutCityBoxes(appState);
      layoutSpecialEvent(appState);
      layoutCalendar(appState);
      layoutOmnibus(appState);
      layoutTrayBoxes(appState);

      const choiceTexts = {
        Choice.reichsmarks4: '4 RM',
        Choice.reichsmarks3krupp1: '3 RM / 1 Krupp',
        Choice.reichsmarks3kaisertreu1: '3 RM / 1 Kaisertreu',
        Choice.reichsmarks2krupp2: '2 RM / 2 Krupp',
        Choice.reichsmarks2kaisertreu2: '2 RM / 2 Kaisertreu',
        Choice.reichsmarks1krupp3: '1 RM / 3 Krupp',
        Choice.reichsmarks1kaisertreu3: '1 RM / 3 Kaisertreu',
        Choice.krupp4: '4 Krupp',
        Choice.reichsmarks3: '3 RM',
        Choice.reichsmarks2krupp1: '2 RM / 1 Krupp',
        Choice.reichsmarks2kaisertreu1: '2 RM / 1 Kaisertreu',
        Choice.reichsmarks1krupp2: '1 RM / 2 Krupp',
        Choice.reichsmarks1kaisertreu2: '1 RM / 2 Kaisertreu',
        Choice.krupp3: '3 Krupp',
        Choice.kaisertreu3: '3 Kaisertreu',
        Choice.reichsmarks2: '2 RM',
        Choice.reichsmarks1krupp1: '1 RM / 1 Krupp',
        Choice.reichsmarks1kaisertreu1: '1 RM / 1 Kaisertreu',
        Choice.krupp2: '2 Krupp',
        Choice.kaisertreu2: '2 Kaisertreu',
        Choice.reichsmarks1: '1 RM',
        Choice.krupp1: '1 Krupp',
        Choice.kaisertreu1: '1 Kaisertreu',
        Choice.minusOne: '-1',
        Choice.zero: '0',
        Choice.plusOne: '1',
        Choice.buildUboats: 'Build U-Boats',
        Choice.buildBlockadeRunners: 'Build Blockade Runners',
        Choice.buildSiegfriedLine: 'Build Siegfried Line',
        Choice.yes: 'Yes',
        Choice.no: 'No',
        Choice.cancel: 'Cancel',
        Choice.next: 'Next',
      };

      if (playerChoices != null) {
        choiceWidgets.add(
          Text(
            style: textTheme.titleMedium,
            playerChoices.prompt,
          )
        );

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
                choiceTexts[choice]!,
              ),
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
            width: 350.0,
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
                  width: _mapWidth + _counterTrayWidth,
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
                        child: Stack(children: _counterTrayChildren),
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

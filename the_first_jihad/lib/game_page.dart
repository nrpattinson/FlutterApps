import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:the_first_jihad/game.dart';
import 'package:the_first_jihad/main.dart';

enum BoardArea {
  map,
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
  static const _mapWidth = 1632.0;
  static const _mapHeight = 1064.0;

  static const _baseCounterNames = {
    Piece.armyByzantineGreek: 'army_byzantine',
    Piece.armyByzantineMediterranean: 'army_byzantine',
    Piece.armyExarchate: 'army_exarchate',
    Piece.armyBerber: 'army_berber',
    Piece.armyVisigoth: 'army_visigoth',
    Piece.armyFrankish: 'army_frankish',
    Piece.armyByzantineAfrican: 'army_byzantine_garrison',
    Piece.armyNubian: 'army_nubian',
    Piece.armyAxum: 'army_axum',
    Piece.armyPersianIndian: 'army_persian',
    Piece.armyPratihara: 'army_pratihara',
    Piece.armyPersianParthian: 'army_persian',
    Piece.armySogdian: 'army_sogdian',
    Piece.armyTurgesh: 'army_turgesh',
    Piece.armyChinese: 'army_chinese',
    Piece.armyByzantineCaucasian: 'army_byzantine_garrison',
    Piece.armyArmenian: 'army_armenian',
    Piece.armyKhazar: 'army_khazar',
    Piece.castleByzantineMajor0: 'castle_byzantine_strong',
    Piece.castleByzantineMajor1: 'castle_byzantine_strong',
    Piece.castleByzantineMinor0: 'castle_byzantine_weak',
    Piece.castleByzantineMinor1: 'castle_byzantine_weak',
    Piece.castleByzantineMinor2: 'castle_byzantine_weak',
    Piece.castleByzantineMinor3: 'castle_byzantine_weak',
    Piece.castlePersianMinor0: 'castle_persian_weak',
    Piece.castlePersianMinor1: 'castle_persian_weak',
    Piece.capitalByzantineStrong: 'capital_byzantine_strong',
    Piece.capitalByzantineWeak: 'capital_byzantine_weak',
    Piece.capitalPersianStrong: 'capital_persian_strong',
    Piece.capitalPersianWeak: 'capital_persian_weak',
    Piece.blessingFleetP1: 'blessing_fleet_weak',
    Piece.blessingFleetP3: 'blessing_fleet_strong',
    Piece.blessingImmortalsP2: 'blessing_immortals_strong',
    Piece.blessingImmortalsP1: 'blessing_immortals_weak',
    Piece.blessingIcons: 'blessing_icons',
    Piece.blessingThemes: 'blessing_themes',
    Piece.islamGreek: 'islam_strong',
    Piece.islamMediterranean: 'islam_strong',
    Piece.islamAfrican: 'islam_strong',
    Piece.islamIndian: 'islam_strong',
    Piece.islamParthian: 'islam_strong',
    Piece.islamCaucasian: 'islam_strong',
    Piece.islamGreekDisrupted: 'islam_weak',
    Piece.islamMediterraneanDisrupted: 'islam_weak',
    Piece.islamAfricanDisrupted: 'islam_weak',
    Piece.islamIndianDisrupted: 'islam_weak',
    Piece.islamParthianDisrupted: 'islam_weak',
    Piece.islamCaucasianDisrupted: 'islam_weak',
    Piece.mujahideenSyrians: 'mujahideen_strong',
    Piece.mujahideenTribal: 'mujahideen_weak',
    Piece.meccaStrong: 'mecca_strong',
    Piece.meccaWeak: 'mecca_weak',
    Piece.baqtAfricanFull: 'baqt_strong',
    Piece.baqtCaucasianFull: 'baqt_strong',
    Piece.baqtAfricanPartial: 'baqt_weak',
    Piece.baqtCaucasianPartial: 'baqt_weak',
    Piece.jewsP1: 'jews_strong',
    Piece.jewsN1: 'jews_weak',
    Piece.excubitors2: 'excubitors_strong',
    Piece.excubitors1: 'excubitors_weak',
    Piece.refugeesManichees: 'refugees_manichees',
    Piece.refugeesParsees: 'refugees_parsees',
    Piece.refugeesMardaites: 'refugees_mardaites',
    Piece.christianDamascus: 'christian_damascus',
    Piece.capitalIslamic: 'capital_islamic',
    Piece.arabStop: 'arab_stop',
    Piece.musmlimNavyActive: 'marker_muslim_navy_active',
    Piece.muslimNavyNone: 'marker_muslim_navy_no',
    Piece.bulgarsDocile: 'marker_bulgars_docile',
    Piece.bulgarsWild: 'marker_bulgars_wild',
    Piece.cyprusGreek: 'marker_cyprus_greek',
    Piece.cyprusMediterranean: 'marker_cyprus_med',
    Piece.socotraAfrican: 'marker_socotra_african',
    Piece.socotraIndian: 'marker_socotra_indian',
    Piece.tibetBuddhist: 'marker_tibet_buddhist',
    Piece.tibetBadass: 'marker_tibet_badass',
    Piece.zabulistanDefiant: 'marker_zabulistan_defiant',
    Piece.zabulistanSubdued: 'marker_zabulistan_subdued',
    Piece.tradeRouteClosedNile: 'marker_trade_closed',
    Piece.tradeRouteClosedSocotra: 'marker_trade_closed',
    Piece.tradeRouteClosedSilk: 'marker_trade_closed',
    Piece.noShariaLaw: 'marker_no_sharia_law',
    Piece.byzantineReligion: 'marker_religion_byzantine',
    Piece.byzantineReligionSchism: 'marker_religion_byzantine_schism',
    Piece.rulerByzantine: 'marker_ruler_byzantine',
    Piece.rulerByzantineTruce: 'marker_ruler_byzantine_truce',
    Piece.rulerPersian: 'marker_ruler_persian',
    Piece.rulerPersianTruce: 'marker_ruler_persian_truce',
    Piece.westAP: 'marker_ap_west',
    Piece.westAPDivided: 'marker_ap_west_divided',
    Piece.eastAP: 'marker_ap_east',
    Piece.eastAPDivided: 'marker_ap_east_divided',
    Piece.africaAP: 'marker_ap_africa',
    Piece.caucasusAP: 'marker_ap_caucasus',
    Piece.westAPToken: 'marker_bonus_ap_blue',
    Piece.eastAPToken: 'marker_bonus_ap_red',
    Piece.sharedAPToken: 'marker_bonus_ap_purple',
    Piece.byzantineLastStandSkill: 'marker_last_stand_byzantine_skill',
    Piece.byzantineLastStandAP: 'marker_last_stand_byzantine_ap',
    Piece.persianLastStandSkill: 'marker_last_stand_persian_skill',
    Piece.persianLastStandAP: 'marker_last_stand_persian_ap',
    Piece.greatKingAfrican: 'marker_great_king_africa',
    Piece.greatKingCaucasian: 'marker_great_king_caucasus',
    Piece.jihadAlternating: 'jihad_alternating',
    Piece.jihadOnePath: 'jihad_one_front',
    Piece.kaaba3: 'marker_kaaba_3',
    Piece.kaaba4: 'marker_kaaba_4',
    Piece.kaaba5: 'marker_kaaba_5',
    Piece.kaaba6: 'marker_kaaba_6',
    Piece.kaaba7: 'marker_kaaba_7',
    Piece.kaaba8: 'marker_kaaba_8',
  };

  static const _byzantineReligionPieces = [
    Piece.armyByzantineGreek,
    Piece.armyByzantineMediterranean,
    Piece.armyByzantineAfrican,
    Piece.armyByzantineCaucasian,
    Piece.castleByzantineMajor0,
    Piece.castleByzantineMajor1,
    Piece.castleByzantineMinor0,
    Piece.castleByzantineMinor1,
    Piece.castleByzantineMinor2,
    Piece.castleByzantineMinor3,
    Piece.capitalByzantineStrong,
    Piece.capitalByzantineWeak,
    Piece.blessingFleetP1,
    Piece.blessingFleetP3,
    Piece.blessingThemes,
    Piece.excubitors1,
    Piece.excubitors2,
    Piece.byzantineReligion,
    Piece.byzantineReligionSchism,
    Piece.rulerByzantine,
    Piece.rulerByzantineTruce,
    Piece.byzantineLastStandSkill,
    Piece.byzantineLastStandAP,
  ];

  final _counters = <String,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _mapStackChildren = <Widget>[];
  final _pieceStackKeys = <Piece,StackKey>{};
  final _expandedStacks = <StackKey>[];
  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    for (final piece in Piece.values) {
      for (final counterName in possibleCounterNames(piece)) {
        if (!_counters.containsKey(counterName)) {
          final imagePath = 'assets/images/$counterName.png';
          _counters[counterName] = Image.asset(
            imagePath,
            key: UniqueKey(),
            width: 60.0,
            height: 60.0,
          );
        }
      }
    }
  }

  List<String> possibleCounterNames(Piece piece) {
    final baseName = _baseCounterNames[piece]!;
    final statuses = <String>[];
    final curseds = <String>[''];
    if (piece.isType(PieceType.army)) {
      if (![Piece.armyByzantineAfrican, Piece.armyByzantineCaucasian].contains(piece)) {
        statuses.add('_strong');
      }
      statuses.add('_weak');
      statuses.add('_shattered');
      curseds.add('_cursed');
    } else {
      statuses.add('');
    }
    final religions = <String>[];
    if (_byzantineReligionPieces.contains(piece)) {
      religions.add('_catholic');
      religions.add('_monophysite');
      religions.add('_orthodox');
      religions.add('_generic');
    } else {
      religions.add('');
    }
    final counterNames = <String>[];
    for (final status in statuses) {
      for (final cursed in curseds) {
        for (final religion in religions) {
          counterNames.add(baseName + status + cursed + religion);
        }
      }
    }
    return counterNames;
  }

  Image getPieceImage(GameState state, Piece piece) {
    String name = _baseCounterNames[piece]!;
    if (piece.isType(PieceType.army)) {
      final status = state.armyStatus(piece);
      switch (status) {
      case ArmyStatus.strong:
        name += '_strong';
      case ArmyStatus.weak:
        name += '_weak';
      case ArmyStatus.shattered:
        name += '_shattered';
      }
      if (state.armyCursed(piece)) {
        name += '_cursed';
      }
    }
    if (_byzantineReligionPieces.contains(piece)) {
      switch (state.byzantineReligion) {
      case Religion.christianCatholic:
        name += '_catholic';
      case Religion.christianMonophysite:
        name += '_monophysite';
      case Religion.christianOrthodox:
        name += '_orthodox';
      default:
        name += '_generic';
      }
    }
    return _counters[name]!;
  }

  void addPieceToBoard(MyAppState appState, Piece piece, BoardArea boardArea, double x, double y) {
    final state = appState.gameState!;
    final playerChoices = appState.playerChoices;

    bool choosable = playerChoices != null && playerChoices.pieces.contains(piece);
    bool selected = playerChoices != null && playerChoices.selectedPieces.contains(piece);

    Widget widget = getPieceImage(state, piece);
    
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
    }
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.landMecca: (BoardArea.map, 725.0, 691.0),
      Location.landDamascus: (BoardArea.map, 724.0, 531.0),
      Location.landJerusalem: (BoardArea.map, 624.5, 499.0),
      Location.landCilicia: (BoardArea.map, 0.0, 0.0),
      Location.landAnatolia: (BoardArea.map, 0.0, 0.0),
      Location.landConstantinople: (BoardArea.map, 568.0, 235.5),
      Location.landGreece: (BoardArea.map, 0.0, 0.0),
      Location.landRome: (BoardArea.map, 0.0, 0.0),
      Location.landAlexandria: (BoardArea.map, 504.5, 546.0),
      Location.landLibya: (BoardArea.map, 0.0, 0.0),
      Location.landSufetula: (BoardArea.map, 0.0, 0.0),
      Location.landCarthage: (BoardArea.map, 219.25, 266.0),
      Location.landTingitana: (BoardArea.map, 40.5, 231.0),
      Location.landHispania: (BoardArea.map, 152.5, 89.0),
      Location.landAquitaine: (BoardArea.map, 274.0, 56.0),
      Location.landParis: (BoardArea.map, 0.0, 0.0),
      Location.landUpperEgypt: (BoardArea.map, 514.0, 650.0),
      Location.landNobatia: (BoardArea.map, 553.0, 747.0),
      Location.landMakouria: (BoardArea.map, 0.0, 0.0),
      Location.landAlodia: (BoardArea.map, 0.0, 0.0),
      Location.landAdulis: (BoardArea.map, 630.5, 855.0),
      Location.landAxum: (BoardArea.map, 0.0, 0.0),
      Location.landKhuzestan: (BoardArea.map, 955.5, 634.0),
      Location.landYezd: (BoardArea.map, 1074.0, 663.0),
      Location.landSeistan: (BoardArea.map, 0.0, 0.0),
      Location.landSindh: (BoardArea.map, 1297.0, 759.0),
      Location.landMulasthana: (BoardArea.map, 0.0, 0.0),
      Location.landRajasthan: (BoardArea.map, 0.0, 0.0),
      Location.landKannauj: (BoardArea.map, 0.0, 0.0),
      Location.landCtesiphon: (BoardArea.map, 918.5, 531.0),
      Location.landNehavend: (BoardArea.map, 0.0, 0.0),
      Location.landEsfahan: (BoardArea.map, 0.0, 0.0),
      Location.landKhorasan: (BoardArea.map, 0.0, 0.0),
      Location.landTransoxiana: (BoardArea.map, 1355.0, 340.0),
      Location.landFerganaValley: (BoardArea.map, 0.0, 0.0),
      Location.landKushinne: (BoardArea.map, 1525.0, 410.0),
      Location.landNsibis: (BoardArea.map, 825.0, 551.0),
      Location.landVaspurakan: (BoardArea.map, 824.0, 453.0),
      Location.landArmenia: (BoardArea.map, 0.0, 0.0),
      Location.landAghvank: (BoardArea.map, 0.0, 0.0),
      Location.landBalanjar: (BoardArea.map, 938.0, 260.0),
      Location.landKhazaria: (BoardArea.map, 0.0, 0.0),
      Location.boxBerberRevolt: (BoardArea.map, 44.0, 54.0),
      Location.boxMuslimNavy: (BoardArea.map, 243.0, 163.0),
      Location.boxCasbah: (BoardArea.map, 0.0, 0.0),
      Location.boxOutOfPlay: (BoardArea.map, 0.0, 0.0),
      Location.boxBlessingsAvailable: (BoardArea.map, 752.0, 87.0),
      Location.boxBlessingsUsed: (BoardArea.map, 0.0, 0.0),
      Location.boxJihad: (BoardArea.map, 0.0, 0.0),
      Location.boxBulgarsN1: (BoardArea.map, 0.0, 0.0),
      Location.boxBulgarsZ: (BoardArea.map, 567.0, 130.0),
      Location.boxBulgarsP1: (BoardArea.map, 0.0, 0.0),
      Location.boxCyprusN1: (BoardArea.map, 514.5, 412.0),
      Location.boxCyprusZ: (BoardArea.map, 446.0, 412.0),
      Location.boxCyprusP1: (BoardArea.map, 377.5, 412.0),
      Location.boxSocotraN1: (BoardArea.map, 0.0, 0.0),
      Location.boxSocotraZ: (BoardArea.map, 1055.5, 831.0),
      Location.boxSocotraP1: (BoardArea.map, 0.0, 0.0),
      Location.boxTibetN1: (BoardArea.map, 0.0, 0.0),
      Location.boxTibetZ: (BoardArea.map, 1464.5, 550.0),
      Location.boxTibetP1: (BoardArea.map, 0.0, 0.0),
      Location.boxZabulistan: (BoardArea.map, 0.0, 0.0),
      Location.boxTradeRouteNile: (BoardArea.map, 0.0, 0.0),
      Location.boxTradeRouteSocotra: (BoardArea.map, 0.0, 0.0),
      Location.boxTradeRouteSilk: (BoardArea.map, 0.0, 0.0),
      Location.boxShariaLaw: (BoardArea.map, 212.0, 580.0),
      Location.boxByzantineReligionCatholic: (BoardArea.map, 0.0, 0.0),
      Location.boxByzantineReligionOrthodox: (BoardArea.map, 785.0, 205.0),
      Location.boxByzantineReligionMonophysite: (BoardArea.map, 0.0, 0.0),
    };
    return coordinates[location]!;
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

  void layoutBoxStacks(MyAppState appState, Location box, List<Piece> pieces, BoardArea boardArea, int colCount, int rowCount, double x, double y, double dxStack, double dyStack, double dxPiece, double dyPiece) {
    int stackCount = rowCount * colCount;
    for (int row = 0; row < rowCount; ++row) {
      for (int col = 0; col < colCount; ++col) {
        final stackPieces = <Piece>[];
        int stackIndex = row * colCount + col;
        for (int pieceIndex = stackIndex; pieceIndex < pieces.length; pieceIndex += stackCount) {
          stackPieces.add(pieces[pieceIndex]);
        }
        if (stackPieces.isNotEmpty) {
          double xStack = x + col * dxStack;
          double yStack = y + row * dyStack;
          layoutStack(appState, (box, stackIndex), stackPieces, boardArea, xStack, yStack, dxPiece, dyPiece);
        }
      }
    }
  }

  int mapPieceZ(GameState state, Piece piece) {
    int z = 100;
    if (piece == Piece.capitalIslamic) {
      z = 0;
    } else if (piece.isType(PieceType.islam)) {
      z = 1;
    } else if (piece.isType(PieceType.mujahideen)) {
      z = 2;
    } else if (piece == Piece.arabStop) {
      z = 3;
    } else if (piece.isType(PieceType.baqt)) {
      z = 4;
    } else if (piece.isType(PieceType.capital)) {
      z = 5;
    } else if (piece == Piece.christianDamascus) {
      z = 6;
    } else if (piece.isType(PieceType.castle)) {
      if (!state.castleBesieged(piece)) {
        z = 7;
      } else {
        z = 12;
      }
    } else if (piece.isType(PieceType.refugees)) {
      z = 8;
    } else if (piece.isType(PieceType.jews)) {
      z = 9;
    } else if (piece.isType(PieceType.blessing)) {
      z = 10;
    } else if (piece.isType(PieceType.army)) {
      z = 11;
    }
    return z;
  }

  int mapPieceZOrder(GameState state, Piece a, Piece b) {
    int aZ = mapPieceZ(state, a);
    int bZ = mapPieceZ(state, b);
    if (aZ != bZ) {
      return aZ.compareTo(bZ);
    }
    return -a.index.compareTo(b.index);
  }

  void layoutLand(MyAppState appState, Location land) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(land);
    final xLand = coordinates.$2;
    final yLand = coordinates.$3;

    final pieces = state.piecesInLocation(PieceType.mapPiece, land);
    pieces.sort((a, b) => mapPieceZOrder(state, a, b));
    layoutStack(appState, (land, 0), pieces, BoardArea.map, xLand, yLand, 4.0, 4.0);
  }

  void layoutMecca(MyAppState appState)
  {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(Location.landMecca);
    final xLand = coordinates.$2;
    final yLand = coordinates.$3;
    
    for (final piece in state.piecesInLocation(PieceType.mapPiece, Location.landMecca)) {
      double xOffset = 0.0;
      double yOffset = 0.0;
      if (piece.isType(PieceType.kaaba)) {
      } else if (piece.isType(PieceType.islam)) {
        switch (piece) {
        case Piece.islamGreek:
          xOffset = -5.0;
          yOffset = -88.0;
        case Piece.islamMediterranean:
          xOffset = -110.0;
          yOffset = -88.0;
        case Piece.islamAfrican:
          xOffset = -100.0;
          yOffset = -20.0;
        case Piece.islamIndian:
          xOffset = 110.0;
          yOffset = -10.0;
        case Piece.islamParthian:
          xOffset = 140.0;
          yOffset = -74.0;
        case Piece.islamCaucasian:
          xOffset = 70.0;
          yOffset = -74.0;
        default:
        }
      } else if (piece.isType(PieceType.mecca)) {
        yOffset = 65.0;
      } else if (piece.isType(PieceType.mujahideen)) {
      } else if (piece == Piece.arabStop) {
      }
      addPieceToBoard(appState, piece, BoardArea.map, xLand + xOffset, yLand + yOffset);
    }
  }

  void layoutLands(MyAppState appState) {
    for (final land in LocationType.land.locations) {
      if (land == Location.landMecca) {
        layoutMecca(appState);
      } else {
        layoutLand(appState, land);
      }
    }
  }

  static const boxInfos = {
    Location.boxBerberRevolt: (0.0, 0.0, 1, 1),
    Location.boxMuslimNavy: (0.0, 0.0, 1, 1),
    Location.boxCasbah: (0.0, 0.0, 1, 1),
    Location.boxOutOfPlay: (0.0, 0.0, 1, 1),
    Location.boxBlessingsAvailable: (0.0, 0.0, 1, 1),
    Location.boxBlessingsUsed: (0.0, 0.0, 1, 1),
    Location.boxJihad: (0.0, 0.0, 1, 1),
    Location.boxBulgarsN1: (0.0, 0.0, 1, 1),
    Location.boxBulgarsZ: (0.0, 0.0, 1, 1),
    Location.boxBulgarsP1: (0.0, 0.0, 1, 1),
    Location.boxCyprusN1: (0.0, 0.0, 1, 1),
    Location.boxCyprusZ: (0.0, 0.0, 1, 1),
    Location.boxCyprusP1: (0.0, 0.0, 1, 1),
    Location.boxSocotraN1: (0.0, 0.0, 1, 1),
    Location.boxSocotraZ: (0.0, 0.0, 1, 1),
    Location.boxSocotraP1: (0.0, 0.0, 1, 1),
    Location.boxTibetN1: (0.0, 0.0, 1, 1),
    Location.boxTibetZ: (0.0, 0.0, 1, 1),
    Location.boxTibetP1: (0.0, 0.0, 1, 1),
    Location.boxZabulistan: (0.0, 0.0, 1, 1),
    Location.boxTradeRouteNile: (0.0, 0.0, 1, 1),
    Location.boxTradeRouteSocotra: (0.0, 0.0, 1, 1),
    Location.boxTradeRouteSilk: (0.0, 0.0, 1, 1),
    Location.boxShariaLaw: (0.0, 0.0, 1, 1),
    Location.boxByzantineReligionCatholic: (0.0, 0.0, 1, 1),
    Location.boxByzantineReligionOrthodox: (0.0, 0.0, 1, 1),
    Location.boxByzantineReligionMonophysite: (0.0, 0.0, 1, 1),
  };

  (double, double, int, int) boxInfo(Location box) {
    return boxInfos[box]!;
  }

  void layoutBox(MyAppState appState, Location box) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(box);
    final boardArea = coordinates.$1;
    final xBox = coordinates.$2;
    final yBox = coordinates.$3;
    final info = boxInfo(box);
    double xGap = info.$1;
    double yGap = info.$2;
    int cols = info.$3;
    int rows = info.$4;
    layoutBoxStacks(appState, box, state.piecesInLocation(PieceType.all, box), boardArea, cols, rows, xBox, yBox, 60.0 + xGap, 60.0 + yGap, 3.0, 3.0);
  }

  void layoutBoxes(MyAppState appState) {
    for (final box in boxInfos.keys) {
      layoutBox(appState, box);
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

    _pieceStackKeys.clear();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutLands(appState);
      layoutBoxes(appState);

      const choiceTexts = {
        Choice.reduceEmperorSkill: 'Reduce Emperor’s Skill',
        Choice.shiftBulgarsLeft: 'Shift Bulgars Left',
        Choice.lastStandActionPoints: '2 AP',
        Choice.lastStandSkill: '+1 Skill',
        Choice.lossDamageArmy: 'Damage Army',
        Choice.lossDamageCastle: 'Damage Castle',
        Choice.lossDamageCapital: 'Damage Capital',
        Choice.lossDestroyCapital: 'Destroy Capital',
        Choice.lossRetreat: 'Retreat',
        Choice.lossSiege: 'Siege',
        Choice.lossCursed: 'Cursed',
        Choice.actionAttack: 'Attack',
        Choice.actionRally: 'Rally',
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
                  width: _mapWidth,
                  height: _mapHeight,
                  child: SizedBox(
                    width: _mapWidth,
                    height: _mapHeight,
                    child: Stack(children: _mapStackChildren),
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

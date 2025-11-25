import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:gift_of_the_nile/game.dart';
import 'package:gift_of_the_nile/main.dart';

enum BoardArea {
  map,
  bookOfTheDead,
  counterTray,
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
  static const _mapWidth = 1056.0;
  static const _mapHeight = 1632.0;
  static const _bookOfTheDeadWidth = 1261.0;
  static const _bookOfTheDeadHeight = 1632.0;
  static const _counterTrayWidth = 1261.0;
  static const _counterTrayHeight = 1632.0;

  final _displayOptionsFormKey = GlobalKey<FormState>();
 
  bool _emptyMap = false;

  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _actsTrackImage = Image.asset('assets/images/book.png', key: UniqueKey(), width: _bookOfTheDeadWidth, height: _bookOfTheDeadHeight);
  final _counterTrayImage = Image.asset('assets/images/tray.png', key: UniqueKey(), width: _counterTrayWidth, height: _counterTrayHeight);
  final _mapStackChildren = <Widget>[];
  final _bookOfTheDeadStackChildren = <Widget>[];
  final _counterTrayStackChildren = <Widget>[];

  final _pieceStackKeys = <Piece,StackKey>{};
  final _expandedStacks = <StackKey>[];

  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    const pieceCounterNames = {
      Piece.sepatUntempled0: 'sepat_01',
      Piece.sepatUntempled1: 'sepat_02',
      Piece.sepatUntempled2: 'sepat_03',
      Piece.sepatUntempled3: 'sepat_04',
      Piece.sepatUntempled4: 'sepat_05',
      Piece.sepatUntempled5: 'sepat_06',
      Piece.sepatUntempled6: 'sepat_07',
      Piece.sepatUntempled7: 'sepat_08',
      Piece.sepatUntempled8: 'sepat_09',
      Piece.sepatUntempled9: 'sepat_10',
      Piece.sepatUntempled10: 'sepat_11',
      Piece.sepatUntempled11: 'sepat_12',
      Piece.sepatUntempled12: 'sepat_13',
      Piece.sepatUntempled13: 'sepat_14',
      Piece.sepatUntempled14: 'sepat_15',
      Piece.sepatUntempled15: 'sepat_16',
      Piece.sepatUntempled16: 'sepat_17',
      Piece.sepatUntempled17: 'sepat_18',
      Piece.sepatUntempled18: 'sepat_19',
      Piece.sepatUntempled19: 'sepat_20',
      Piece.sepatUntempled20: 'sepat_21',
      Piece.sepatUntempled21: 'sepat_22',
      Piece.sepatUntempled22: 'sepat_23',
      Piece.sepatUntempled23: 'sepat_24',
      Piece.sepatUntempled24: 'sepat_25',
      Piece.sepatTempled0: 'sepat_01_templed',
      Piece.sepatTempled1: 'sepat_02_templed',
      Piece.sepatTempled2: 'sepat_03_templed',
      Piece.sepatTempled3: 'sepat_04_templed',
      Piece.sepatTempled4: 'sepat_05_templed',
      Piece.sepatTempled5: 'sepat_06_templed',
      Piece.sepatTempled6: 'sepat_07_templed',
      Piece.sepatTempled7: 'sepat_08_templed',
      Piece.sepatTempled8: 'sepat_09_templed',
      Piece.sepatTempled9: 'sepat_10_templed',
      Piece.sepatTempled10: 'sepat_11_templed',
      Piece.sepatTempled11: 'sepat_12_templed',
      Piece.sepatTempled12: 'sepat_13_templed',
      Piece.sepatTempled13: 'sepat_14_templed',
      Piece.sepatTempled14: 'sepat_15_templed',
      Piece.sepatTempled15: 'sepat_16_templed',
      Piece.sepatTempled16: 'sepat_17_templed',
      Piece.sepatTempled17: 'sepat_18_templed',
      Piece.sepatTempled18: 'sepat_19_templed',
      Piece.sepatTempled19: 'sepat_20_templed',
      Piece.sepatTempled20: 'sepat_21_templed',
      Piece.sepatTempled21: 'sepat_22_templed',
      Piece.sepatTempled22: 'sepat_23_templed',
      Piece.sepatTempled23: 'sepat_24_templed',
      Piece.sepatTempled24: 'sepat_25_templed',
      Piece.khastiMeshwesh: 'khasti_meshwesh',
      Piece.khastiCyrene: 'khasti_cyrene',
      Piece.khastiCanaan: 'khasti_canaan',
      Piece.khastiHyksos: 'khasti_hyksos',
      Piece.khastiMitanni: 'khasti_mitanni',
      Piece.khastiHittites: 'khasti_hittites',
      Piece.khastiSeaPeoples: 'khasti_sea_peoples',
      Piece.khastiAssyria: 'khasti_assyria',
      Piece.khastiBabylon: 'khasti_babylon',
      Piece.khastiPersia: 'khasti_persia',
      Piece.khastiSeleucids: 'khasti_seleucids',
      Piece.khastiRomans: 'khasti_romans',
      Piece.khastiShasu: 'khasti_shasu',
      Piece.khastiNabatu: 'khasti_nabatu',
      Piece.khastiKerma: 'khasti_kerma',
      Piece.khastiKush: 'khasti_kush',
      Piece.khastiMeroe: 'khasti_meroe',
      Piece.khastiLibu: 'khasti_libu',
      Piece.medjaiTroopsTjehenu: 'medjai_troops',
      Piece.medjaiTroopsRetjenu: 'medjai_troops',
      Piece.medjaiTroopsTaNetjer: 'medjai_troops',
      Piece.medjaiTroopsTaSeti: 'medjai_troops',
      Piece.medjaiTroopsLibu: 'medjai_troops',
      Piece.rivalDynasty0: 'rival_dynasty_2',
      Piece.rivalDynasty1: 'rival_dynasty_3',
      Piece.rivalDynasty2: 'rival_dynasty_3',
      Piece.rivalDynasty3: 'rival_dynasty_4',
      Piece.rivalDynasty4: 'rival_dynasty_4',
      Piece.heroesChariotsP1: 'heroes_chariots_p1',
      Piece.heroesChariotsP2: 'heroes_chariots_p2',
      Piece.heroesNubianArchers: 'heroes_nubian_archers',
      Piece.heroesNubianArchersBack: 'heroes_nubian_archers_back',
      Piece.heroesMeraFleet: 'heroes_mera_fleet',
      Piece.heroesMeraFleetBack: 'heroes_mera_fleet_back',
      Piece.medjaiPolice: 'medjai_police',
      Piece.highPriests: 'high_priests',
      Piece.wallsOfTheRuler0: 'walls_of_the_ruler',
      Piece.wallsOfTheRuler1: 'walls_of_the_ruler',
      Piece.megaprojectGreatPyramids: 'megaproject_great_pyramids',
      Piece.megaprojectTempleOfIpetIsut: 'megaproject_temple_of_ipet_isut',
      Piece.megaprojectValleyOfTheKings: 'megaproject_valley_of_the_kings',
      Piece.megaprojectGreatPyramidsLooted: 'megaproject_great_pyramids_looted',
      Piece.megaprojectTempleOfIpetIsutLooted: 'megaproject_temple_of_ipet_isut_looted',
      Piece.megaprojectValleyOfTheKingsLooted: 'megaproject_valley_of_the_kings_looted',
      Piece.pharaoh: 'pharaoh',
      Piece.greeks: 'greeks',
      Piece.greeksDepleted: 'greeks_depleted',
      Piece.jews: 'jews',
      Piece.jewsDepleted: 'jews_depleted',
      Piece.hebrewPeople: 'hebrew_people',
      Piece.israel0: 'israel_p0',
      Piece.israeln1: 'israel_n1',
      Piece.libyanMigrants: 'libyan_migrants',
      Piece.egyptianRule0: 'egyptian_rule',
      Piece.egyptianRule1: 'egyptian_rule',
      Piece.okToLoot0: 'ok_to_loot',
      Piece.okToLoot1: 'ok_to_loot',
      Piece.marriage: 'marriage',
      Piece.alexandria: 'alexandria',
      Piece.rise: 'rd_rise',
      Piece.decline: 'rd_decline',
      Piece.godThoth: 'god_thoth',
      Piece.godRa: 'god_ra',
      Piece.godHorus: 'god_horus',
      Piece.godOsiris: 'god_osiris',
      Piece.godAnubis: 'god_anubis',
      Piece.godBastet: 'god_bastet',
      Piece.godPtah: 'god_ptah',
      Piece.godIsis: 'god_isis',
      Piece.eraOldKingdom: 'era_old_kingdom',
      Piece.eraMiddleKingdom: 'era_middle_kingdom',
      Piece.eraNewKingdom: 'era_new_kingdom',
      Piece.eraLatePeriod: 'era_late_period',
      Piece.maat0: 'maat',
      Piece.maat1: 'maat',
      Piece.maat0Used: 'maat_used',
      Piece.maat1Used: 'maat_used',
      Piece.senet: 'senet',
      Piece.revival0: 'revival',
      Piece.revival1: 'revival',
      Piece.revival2: 'revival',
      Piece.revival3: 'revival',
      Piece.revival4: 'revival',
      Piece.revival5: 'revival',
      Piece.romanDebt: 'roman_debt',
      Piece.dynastyA: 'dynasty_a',
      Piece.dynastyB: 'dynasty_b',
      Piece.dynastyC: 'dynasty_c',
      Piece.dynastyD: 'dynasty_d',
      Piece.dynastyE: 'dynasty_e',
      Piece.dynastyF: 'dynasty_f',
      Piece.dynastyG: 'dynasty_g',
      Piece.dynastyH: 'dynasty_h',
      Piece.dynastyABack: 'dynasty_back',
      Piece.dynastyBBack: 'dynasty_back',
      Piece.dynastyCBack: 'dynasty_back',
      Piece.dynastyDBack: 'dynasty_back',
      Piece.dynastyEBack: 'dynasty_back',
      Piece.dynastyFBack: 'dynasty_back',
      Piece.dynastyGBack: 'dynasty_back',
      Piece.actionPoints: 'action_points',
      Piece.gold: 'gold',
      Piece.inbreeding: 'inbreeding',
      Piece.actionPointsLimit: 'action_points_limit',
      Piece.literacy: 'literacy',
    };

    for (final counterName in pieceCounterNames.entries) {
      final imagePath = 'assets/images/${counterName.value}.png';
      _counters[counterName.key] = Image.asset(imagePath,
        key: UniqueKey(),
        width: 60.0, height:60.0,
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
    case BoardArea.bookOfTheDead:
      _bookOfTheDeadStackChildren.add(widget);
    case BoardArea.counterTray:
      _counterTrayStackChildren.add(widget);
    }
  }

  void addLandToMap(MyAppState appState, Location land, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(land);
    bool selected = playerChoices.selectedLocations.contains(land);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = const SizedBox(
      height: 89.0,
      width: 89.0,
    );

    widget = Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.transparent,
        border: Border.all(color: choosable ? Colors.red : Colors.green, width: 5.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: widget,
    );

    if (choosable) {
      widget = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            appState.choseLocation(land);
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

  void addCountryToMap(MyAppState appState, Location country, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(country);
    bool selected = playerChoices.selectedLocations.contains(country);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = const SizedBox(
      height: 91.0,
      width: 170.0,
    );

    widget = Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.transparent,
        border: Border.all(color: choosable ? Colors.red : Colors.green, width: 5.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: widget,
    );

    if (choosable) {
      widget = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            appState.choseLocation(country);
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

  void addBoxToBoard(MyAppState appState, Location box, BoardArea boardArea, double x, double y, double boxWidth, double boxHeight) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(box);
    bool selected = playerChoices.selectedLocations.contains(box);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = SizedBox(
      height: boxHeight,
      width: boxWidth
    );

    const borderWidth = 5.0;

    widget = Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.transparent,
        border: Border.all(color: choosable ? Colors.yellow : Colors.green, width: borderWidth),
        borderRadius: BorderRadius.circular(10.0),
      ),
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
      left: x - borderWidth,
      top: y - borderWidth,
      child: widget,
    );

    switch (boardArea) {
    case BoardArea.map:
      _mapStackChildren.add(widget);
    case BoardArea.bookOfTheDead:
      _bookOfTheDeadStackChildren.add(widget);
    case BoardArea.counterTray:
      _counterTrayStackChildren.add(widget);
    }
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.landMenNefer: (BoardArea.map, 410.0, 468.0),
      Location.landKhem: (BoardArea.map, 277.0, 341.0),
      Location.landZau: (BoardArea.map, 236.0, 242.0),
      Location.landPerWadjet: (BoardArea.map, 207.0, 131.0),
      Location.landUsermaatreSetepenre: (BoardArea.map, 135.0, 240.0),
      Location.landSekhetAm: (BoardArea.map, 23.0, 283.0),
      Location.countryTjehenu: (BoardArea.map, 28.0, 136.0),
      Location.landPerBastet: (BoardArea.map, 383.0, 316.0),
      Location.landHutwaret: (BoardArea.map, 347.0, 209.0),
      Location.landDjanet: (BoardArea.map, 427.0, 99.0),
      Location.landWaysOfHorus: (BoardArea.map, 549.0, 152.0),
      Location.landSharuhen: (BoardArea.map, 678.0, 135.0),
      Location.countryRetjenu: (BoardArea.map, 790.0, 80.0),
      Location.landIunu: (BoardArea.map, 485.0, 404.0),
      Location.landPerAtum: (BoardArea.map, 495.0, 302.0),
      Location.landBekhnu: (BoardArea.map, 615.0, 286.0),
      Location.landBiau: (BoardArea.map, 645.0, 412.0),
      Location.landKhetyuMefkat: (BoardArea.map, 750.0, 493.0),
      Location.countryTaNetjer: (BoardArea.map, 871.0, 477.0),
      Location.landAbdju: (BoardArea.map, 344.0, 585.0),
      Location.landShabt: (BoardArea.map, 437.0, 729.0),
      Location.landWast: (BoardArea.map, 587.0, 829.0),
      Location.landWetjesetHor: (BoardArea.map, 583.0, 974.0),
      Location.landSwenet: (BoardArea.map, 589.0, 1123.0),
      Location.landIrtjet: (BoardArea.map, 566.0, 1221.0),
      Location.landWawat: (BoardArea.map, 429.0, 1237.0),
      Location.countryTaSeti: (BoardArea.map, 210.0, 1234.0),
      Location.landPayomLakes: (BoardArea.map, 253.0, 447.0),
      Location.landDjesdjes: (BoardArea.map, 132.0, 504.0),
      Location.landAnaAkhet: (BoardArea.map, 32.0, 674.0),
      Location.landMut: (BoardArea.map, 108.0, 796.0),
      Location.landKenemet: (BoardArea.map, 174.0, 909.0),
      Location.countryLibu: (BoardArea.map, 26.0, 1041.0),
      Location.boxPromisedLand: (BoardArea.map, 868.0, 205.0),
      Location.boxWilderness: (BoardArea.map, 755.0, 348.0),
      Location.boxAlexandria: (BoardArea.map, 330.0, 125.0),
      Location.boxRiseDeclineNone: (BoardArea.map, 415.0, 1055.0),
      Location.boxRiseDeclineTjehenu: (BoardArea.map, 57.0, 70.0),
      Location.boxRiseDeclineRetjenu: (BoardArea.map, 963.0, 109.0),
      Location.boxRiseDeclineTaNetjer: (BoardArea.map, 948.0, 568.0),
      Location.boxRiseDeclineTaSeti: (BoardArea.map, 323.0, 1169.0),
      Location.boxRiseDeclineLibu: (BoardArea.map, 55.0, 974.0),
      Location.boxRiseDeclineAllPaths: (BoardArea.map, 944.0, 830.0),
      Location.boxGreatPyramids: (BoardArea.map, 250.0, 565.0),
      Location.boxTempleOfIpetIsut: (BoardArea.map, 0.0, 0.0),
      Location.boxValleyOfTheKings: (BoardArea.map, 0.0, 0.0),
      Location.boxPharaohUnavailable: (BoardArea.map, 940.0, 1020.0),
      Location.boxHeroes: (BoardArea.map, 817.0, 1185.0),
      Location.boxHouseOfLife: (BoardArea.map, 231.0, 1050.0),
      Location.boxEra: (BoardArea.map, 972.0, 386.5),
      Location.boxGod: (BoardArea.map, 267.0, 730.0),
      Location.boxRevival: (BoardArea.map, 30.0, 1142.0),
      Location.boxWastSepat0: (BoardArea.map, 700.0, 765.0),
      Location.boxWastSepat1: (BoardArea.map, 700.0, 840.0),
      Location.boxWastSepat2: (BoardArea.map, 700.0, 915.0),
      Location.granary0: (BoardArea.map, 154.0, 1416.0),
      Location.dynasty3: (BoardArea.bookOfTheDead, 100.0, 420.0),
      Location.literacyHieroglyphic: (BoardArea.bookOfTheDead, 700.0, 170.0),
      Location.traySepat: (BoardArea.counterTray, 83.0, 195.0),
      Location.trayMilitary: (BoardArea.counterTray, 375.0, 200.0),
      Location.trayDynasty: (BoardArea.counterTray, 639.0, 195.0),
      Location.trayRetjenu: (BoardArea.counterTray, 933.0, 210.0),
      Location.trayRevival: (BoardArea.counterTray, 655.0, 393.0),
      Location.trayLibu: (BoardArea.counterTray, 933.0, 460.0),
      Location.trayPolitical: (BoardArea.counterTray, 140.0, 600.0),
      Location.trayEconomic: (BoardArea.counterTray, 400.0, 630.0),
      Location.trayPeople: (BoardArea.counterTray, 698.0, 608.0),
      Location.trayKerma: (BoardArea.counterTray, 976.0, 658.0),
      Location.trayGods: (BoardArea.counterTray, 698.0, 843.0),
      Location.trayEra: (BoardArea.counterTray, 976.0, 843.0),
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
        for (int pieceIndex = stackIndex; pieceIndex < pieces.length; pieceIndex += stackCount) {
          stackPieces.add(pieces[pieceIndex]);
        }
        if (stackPieces.isNotEmpty) {
          final sk = (box, stackIndex);
          if (_expandedStacks.contains(sk) == (pass == 1)) {
            double xStack = x + col * dxStack;
            double yStack = y + row * dyStack;
            layoutStack(appState, (box, stackIndex), stackPieces, boardArea, xStack, yStack, dxPiece, dyPiece);
          }
        }
      }
    }
  }

  void layoutBoxes(MyAppState appState, int pass) {
    const boxesInfo = {
      Location.boxPromisedLand: (1, 1, 0.0, 0.0),
      Location.boxWilderness: (1, 1, 0.0, 0.0),
      Location.boxAlexandria: (1, 1, 0.0, 0.0),
      Location.boxRiseDeclineNone: (1, 1, 0.0, 0.0),
      Location.boxRiseDeclineTjehenu: (1, 1, 0.0, 0.0),
      Location.boxRiseDeclineRetjenu: (1, 1, 0.0, 0.0),
      Location.boxRiseDeclineTaNetjer: (1, 1, 0.0, 0.0),
      Location.boxRiseDeclineTaSeti: (1, 1, 0.0, 0.0),
      Location.boxRiseDeclineLibu: (1, 1, 0.0, 0.0),
      Location.boxRiseDeclineAllPaths: (1, 1, 0.0, 0.0),
      Location.boxGreatPyramids: (1, 1, 0.0, 0.0),
      Location.boxTempleOfIpetIsut: (1, 1, 0.0, 0.0),
      Location.boxValleyOfTheKings: (1, 1, 0.0, 0.0),
      Location.boxPharaohUnavailable: (1, 1, 0.0, 0.0),
      Location.boxHeroes: (3, 2, 10.0, 5.0),
      Location.boxHouseOfLife: (1, 2, 0.0, 15.0),
      Location.boxEra: (1, 1, 0.0, 0.0),
      Location.boxGod: (1, 1, 0.0, 0.0),
      Location.boxRevival: (2, 3, 0.0, 0.0),
      Location.boxWastSepat0: (1, 1, 0.0, 0.0),
      Location.boxWastSepat1: (1, 1, 0.0, 0.0),
      Location.boxWastSepat2: (1, 1, 0.0, 0.0),
      Location.traySepat: (4, 5, 8.0, 8.0),
      Location.trayMilitary: (3, 4, 25.0, 25.0),
      Location.trayDynasty: (4, 2, 8.0, 15.0),
      Location.trayRetjenu: (3, 2, 25.0, 8.0),
      Location.trayRevival: (3, 2, 25.0, 25.0),
      Location.trayLibu: (3, 1, 25.0, 0.0),
      Location.trayPolitical: (2, 5, 25.0, 25.0),
      Location.trayEconomic: (2, 4, 25.0, 25.0),
      Location.trayPeople: (2, 2, 25.0, 25.0),
      Location.trayKerma: (2, 1, 25.0, 0.0),
      Location.trayGods: (2, 2, 25.0, 25.0),
      Location.trayEra: (2, 2, 25.0, 25.0),
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
      layoutBoxStacks(appState, box, pass, state.piecesInLocation(PieceType.all, box), boardArea, cols, rows, xBox, yBox, 60.0 + xGap, 60 + yGap, 4.0, 4.0);
    }
  }

  void layoutMenNefer(MyAppState appState) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(Location.landMenNefer);
    final xLand = coordinates.$2;
    final yLand = coordinates.$3;

    final pieces = state.piecesInLocation(PieceType.all, Location.landMenNefer);
    Piece? pharaoh;
    final others = <Piece>[];
    for (final piece in pieces) {
      if (piece == Piece.pharaoh) {
        pharaoh = piece;
      } else {
        others.add(piece);
      }
    }

    double xStack = xLand;
    if (pharaoh == null) {
      xStack -= 30.0;
    }
    layoutStack(appState, (Location.landMenNefer, 0), others, BoardArea.map, xStack, yLand, 4.0, 4.0);

    if (pharaoh != null) {
      double x = others.isEmpty ? xLand - 30.0 : xLand - 60.0;
      addPieceToBoard(appState, pharaoh, BoardArea.map, x, yLand);
    }
  }

  void layoutLand(MyAppState appState, Location land, int pass) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(land);
    final xLand = coordinates.$2;
    final yLand = coordinates.$3;

    if (pass == 0 && appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(land)) {
      addLandToMap(appState, land, xLand, yLand);
    }

    final pieces = state.piecesInLocation(PieceType.all, land);

    Piece? sepat;
    Piece? troops;
    Piece? army;
    final others = <Piece>[];
    for (int i = pieces.length - 1; i >= 0; --i) {
      final piece = pieces[i];
      if (piece.isType(PieceType.sepat)) {
        sepat = piece;
      } else if (piece.isType(PieceType.medjaiTroops)) {
        troops = piece;
      } else if (piece.isType(PieceType.khasti)) {
        army = piece;
      } else if (piece.isType(PieceType.rivalDynasty)) {
        army = piece;
      } else {
        others.add(piece);
      }
    }

    var sk = (land, 0);
    if (_expandedStacks.contains(sk) == (pass == 1)) {
      layoutStack(appState, sk, others, BoardArea.map, xLand + 24.0, yLand + 2.0, 4.0, 4.0);
    }
    if (troops != null) {
      addPieceToBoard(appState, troops, BoardArea.map, xLand + 24.0, yLand + 2.0);
    }
    if (sepat != null) {
      addPieceToBoard(appState, sepat, BoardArea.map, xLand + 2.0, yLand + 24.0);
    }
    if (army != null) {
      addPieceToBoard(appState, army, BoardArea.map, xLand + 24.0, yLand + 2.0);
    }

    if (pass == 1 && appState.playerChoices != null && appState.playerChoices!.locations.contains(land)) {
      addLandToMap(appState, land, xLand, yLand);
    }
  }

  void layoutCountry(MyAppState appState, Location country, int pass) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(country);
    final xLand = coordinates.$2;
    final yLand = coordinates.$3;

    if (pass == 0 && appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(country)) {
      addCountryToMap(appState, country, xLand, yLand);
    }

    final pieces = state.piecesInLocation(PieceType.all, country);

    Piece? khasti;
    final others = <Piece>[];
    for (int i = pieces.length - 1; i >= 0; --i) {
      final piece = pieces[i];
      if (piece.isType(PieceType.khasti)) {
        khasti = piece;
      } else {
        others.add(piece);
      }
    }

    var sk = (country, 0);
    if (_expandedStacks.contains(sk) == (pass == 1)) {
      layoutStack(appState, sk, others, BoardArea.map, xLand + 75.0, yLand + 25.0, 4.0, 4.0);
    }

    if (khasti != null) {
      addPieceToBoard(appState, khasti, BoardArea.map, xLand + 2.0, yLand + 25.0);
    }

    if (pass == 1 && appState.playerChoices != null && appState.playerChoices!.locations.contains(country)) {
      addCountryToMap(appState, country, xLand, yLand);
    }
  }

  void layoutLands(MyAppState appState, int pass) {
    final state = appState.gameState!;
    for (final land in LocationType.pathLand.locations) {
      if (state.landIsCountry(land)) {
        layoutCountry(appState, land, pass);
      } else {
        layoutLand(appState, land, pass);
      }
    }
  }

  void layoutGranary(MyAppState appState) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(Location.granary0);
    double xFirst = coordinates.$2;
    double yBox = coordinates.$3;
    for (final box in LocationType.granary.locations) {
      int index = box.index - LocationType.granary.firstIndex;
      double xBox = xFirst + index * 90.5;

      if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(box)) {
        addBoxToBoard(appState, box, BoardArea.map, xBox, yBox, 60.0, 60.0);
      }

      final pieces = state.piecesInLocation(PieceType.all, box);
      if (pieces.isNotEmpty) {
        for (int i = pieces.length - 1; i >= 0; --i) {
          double x = xBox - (pieces.length - 1) * 2.0 + i * 4.0;
          double y = yBox - (pieces.length - 1) * 2.0 + i * 4.0;
          addPieceToBoard(appState, pieces[i], BoardArea.map, x, y);
        }
      }

      if (appState.playerChoices != null && appState.playerChoices!.locations.contains(box)) {
        addBoxToBoard(appState, box, BoardArea.map, xBox - 14.0, yBox - 55.0, 88.0, 125.0);
      }
    }
  }

  void layoutLiteracy(MyAppState appState) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(Location.literacyHieroglyphic);
    double xFirst = coordinates.$2;
    double yFirst = coordinates.$3;
    final index = state.pieceLocation(Piece.literacy).index - LocationType.literacy.firstIndex;
    double x = xFirst + 140.0 * index;
    double y = yFirst;
    addPieceToBoard(appState, Piece.literacy, BoardArea.bookOfTheDead, x, y);
  }

  void layoutDynastyTrack(MyAppState appState) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(Location.dynasty3);
    double xFirst = coordinates.$2;
    double yFirst = coordinates.$3;
    for (final box in LocationType.dynasty.locations) {
      final pieces = state.piecesInLocation(PieceType.all, box);
      if (pieces.isNotEmpty) {
        int index = box.index - LocationType.dynasty.firstIndex;
        int col = index % 6;
        int row = index ~/ 6;
        double xBox = xFirst + col * 194.0;
        double yBox = yFirst + row * 118.0;
        for (int i = pieces.length - 1; i >= 0; --i) {
          double x = xBox - (pieces.length - 1) * 2.0 + i * 4.0;
          double y = yBox - (pieces.length - 1) * 2.0 + i * 4.0;
          addPieceToBoard(appState, pieces[i], BoardArea.bookOfTheDead, x, y);
        }
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
    _bookOfTheDeadStackChildren.clear();
    _bookOfTheDeadStackChildren.add(_actsTrackImage);
    _counterTrayStackChildren.clear();
    _counterTrayStackChildren.add(_counterTrayImage);

    _pieceStackKeys.clear();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutGranary(appState);
      layoutLiteracy(appState);
      layoutDynastyTrack(appState);
      layoutMenNefer(appState);
      layoutBoxes(appState, 0);
      layoutBoxes(appState, 1);
      layoutLands(appState, 0);
      layoutLands(appState, 1);

      const choiceTexts = {
        Choice.dynastyE: 'e: Military',
        Choice.dynastyF: 'f: Religious',
        Choice.dynastyG: 'g: Social',
        Choice.blockAdvanceRevival: 'Revival Chit',
        Choice.blockAdvanceMarriage: 'Marriage',
        Choice.blockAdvanceGreekMercenaries: 'Greek Mercenaries',
        Choice.blockAdvanceEgyptianRule: 'Egyptian Rule',
        Choice.blockAdvancePharaoh: 'Pharaoh',
        Choice.blockAdvanceWalls: 'Walls of the Ruler',
        Choice.blockAdvanceNubianArchers: 'Nubian Archers',
        Choice.blockAdvanceMeraFleet: 'Mera Fleet',
        Choice.blockAdvanceRivalCapital: 'Rival Dynasty Capital',
        Choice.blockAdvanceRivalMilitia: 'Rival Dynasty Militia Defense',
        Choice.blockAdvanceMilitia: 'Militia Defense',
        Choice.blockAdvanceCede: 'Cede Land',
        Choice.buildTroops: 'Recruit Medjai Troops',
        Choice.templeSepat: 'Temple Sepat',
        Choice.templeSepatReligiousSkill: 'Temple Sepat using Religious Skill',
        Choice.templeSepatPtah: 'Temple Sepat using Ptah Bonus',
        Choice.templeSepatPharaoh: 'Temple Sepat using Pharaoh',
        Choice.templeSepatMaat: 'Temple Sepat using Maʽat',
        Choice.colonize: 'Colonize Land',
        Choice.buildMegaproject: 'Build Megaproject',
        Choice.hireMedjaiPolice: 'Hire Medjai Police',
        Choice.buildWallsOfTheRuler: 'Build Walls of the Ruler',
        Choice.buildNubianArchers: 'Recruit Nubian Archers',
        Choice.buildMeraFleet: 'Build Mera Fleet',
        Choice.moveNubianArchers: 'Move Nubian Archers',
        Choice.moveMeraFleet: 'Move Mera Fleet',
        Choice.buyMaat: 'Buy Maʽat Tile',
        Choice.undermineRivalDynasty: 'Undermine Rival Dynasty',
        Choice.boostMorale: 'Boost Morale',
        Choice.marriage: 'Dynastic Marriage',
        Choice.reorientIsrael: 'Reorient Israel',
        Choice.suppressHighPriests: 'Suppress High Priests',
        Choice.advanceLiteracy: 'Advance Literacy',
        Choice.withdrawFromCountry: 'Withdraw from Country',
        Choice.hebrewIncome: 'Hebrew Income',
        Choice.alexandriaIncome: 'Alexandria Income',
        Choice.socialSkillIncome: 'Social Skill Income',
        Choice.lootMegaproject: 'Loot Megaproject',
        Choice.plunderGreeks: 'Plunder Greeks',
        Choice.plunderJews: 'Plunder Jews',
        Choice.borrowFromRome: 'Borrow from Rome',
        Choice.attack: 'Attack',
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
            width: 350.0,
            height: _mapHeight,
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
                  width: _mapWidth + _bookOfTheDeadWidth + _counterTrayWidth,
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
                        child: Stack(children: _bookOfTheDeadStackChildren),
                      ),
                      Positioned(
                        left: _mapWidth + _bookOfTheDeadWidth,
                        top: 0.0,
                        child: Stack(children: _counterTrayStackChildren),
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

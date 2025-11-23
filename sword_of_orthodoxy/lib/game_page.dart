import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import 'package:sword_of_orthodoxy/game.dart';
import 'package:sword_of_orthodoxy/main.dart';

enum BoardArea {
  map,
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
  static const _mapWidth = 1728.0;
  static const _mapHeight = 1728.0;
  static const _counterTrayWidth = 1327.0;
  static const _counterTrayHeight = 1728.0;

  final _displayOptionsFormKey = GlobalKey<FormState>();
 
  bool _emptyMap = false;

  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _counterTrayImage = Image.asset('assets/images/tray.png', key: UniqueKey(), width: _counterTrayWidth, height: _counterTrayHeight);
  final _mapStackChildren = <Widget>[];
  final _counterTrayStackChildren = <Widget>[];
  final _pieceStackKeys = <Piece,StackKey>{};
  final _expandedStacks = <StackKey>[];
  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.armySouthWeak0: 'army_south_infantry_3',
      Piece.armySouthWeak1: 'army_south_infantry_2',
      Piece.armySouthWeak2: 'army_south_infantry_2',
      Piece.armySouthWeak3: 'army_south_infantry_1',
      Piece.armySouthWeak4: 'army_south_infantry_1',
      Piece.armySouthStrong0: 'army_south_cavalry_4',
      Piece.armySouthStrong1: 'army_south_cavalry_3',
      Piece.armySouthStrong2: 'army_south_cavalry_3',
      Piece.armySouthStrong3: 'army_south_cavalry_2',
      Piece.armySouthStrong4: 'army_south_cavalry_1',
      Piece.armyWestWeak0: 'army_west_infantry_3',
      Piece.armyWestWeak1: 'army_west_infantry_2',
      Piece.armyWestWeak2: 'army_west_infantry_2',
      Piece.armyWestWeak3: 'army_west_infantry_1',
      Piece.armyWestWeak4: 'army_west_infantry_1',
      Piece.armyWestStrong0: 'army_west_cavalry_4',
      Piece.armyWestStrong1: 'army_west_cavalry_3',
      Piece.armyWestStrong2: 'army_west_cavalry_3',
      Piece.armyWestStrong3: 'army_west_cavalry_2',
      Piece.armyWestStrong4: 'army_west_cavalry_1',
      Piece.armyNorthWeak0: 'army_north_infantry_3',
      Piece.armyNorthWeak1: 'army_north_infantry_2',
      Piece.armyNorthWeak2: 'army_north_infantry_2',
      Piece.armyNorthWeak3: 'army_north_infantry_1',
      Piece.armyNorthWeak4: 'army_north_infantry_1',
      Piece.armyNorthStrong0: 'army_north_cavalry_4',
      Piece.armyNorthStrong1: 'army_north_cavalry_3',
      Piece.armyNorthStrong2: 'army_north_cavalry_3',
      Piece.armyNorthStrong3: 'army_north_cavalry_2',
      Piece.armyNorthStrong4: 'army_north_cavalry_1',
      Piece.armyIberiaArmenia: 'army_iberia_armenia',
      Piece.armyIberiaOttoman: 'army_iberia_ottoman',
      Piece.armyIberiaPersia: 'army_iberia_persia',
      Piece.armyIberiaSaracen: 'army_iberia_saracen',
      Piece.armyIberiaSeljuk: 'army_iberia_seljuk',
      Piece.armyPersiaBuyid: 'army_persia_buyid',
      Piece.armyPersiaIlKhanid: 'army_persia_il_khan',
      Piece.armyPersiaOttoman: 'army_persia_ottoman',
      Piece.armyPersiaPersia: 'army_persia_persia',
      Piece.armyPersiaSaracen: 'army_persia_saracen',
      Piece.armyPersiaSeljuk: 'army_persia_seljuk',
      Piece.armyPersiaMongol: 'army_mongol',
      Piece.armySyriaEgypt: 'army_syria_egypt',
      Piece.armySyriaIlKhanid: 'army_syria_il_khan',
      Piece.armySyriaNomads: 'army_syria_nomads',
      Piece.armySyriaOttoman: 'army_syria_ottoman',
      Piece.armySyriaPersia: 'army_syria_persia',
      Piece.armySyriaSaracen: 'army_syria_saracen',
      Piece.armySyriaSeljuk: 'army_syria_seljuk',
      Piece.armySyriaMongol: 'army_mongol',
      Piece.armyMagyar: 'army_magyar',
      Piece.armySkanderbeg: 'army_skanderbeg',
      Piece.siegeSouth: 'siege_english',
      Piece.siegeWest: 'siege_english',
      Piece.siegeNorth: 'siege_english',
      Piece.siegeIberia: 'siege_english',
      Piece.siegePersia: 'siege_english',
      Piece.siegeSyria: 'siege_english',
      Piece.riots0: 'riots',
      Piece.riots1: 'riots',
      Piece.riots2: 'riots',
      Piece.riots3: 'riots',
      Piece.riots4: 'riots',
      Piece.riots5: 'riots',
      Piece.latins0: 'latins',
      Piece.latins1: 'latins',
      Piece.latins2: 'latins',
      Piece.latins3: 'latins',
      Piece.latins4: 'latins',
      Piece.latins5: 'latins',
      Piece.socialChristians0: 'social_christians',
      Piece.socialChristians1: 'social_christians',
      Piece.socialChristians2: 'social_christians',
      Piece.socialChristians3: 'social_christians',
      Piece.socialChristians4: 'social_christians',
      Piece.socialChristians5: 'social_christians',
      Piece.socialDynatoi0: 'social_magnates',
      Piece.socialDynatoi1: 'social_magnates',
      Piece.socialDynatoi2: 'social_magnates',
      Piece.socialDynatoi3: 'social_magnates',
      Piece.socialDynatoi4: 'social_magnates',
      Piece.socialDynatoi5: 'social_magnates',
      Piece.colonistsPersia: 'colonists',
      Piece.colonistsSyria: 'colonists',
      Piece.paganPersia: 'pagan',
      Piece.paganSyria: 'pagan',
      Piece.infrastructureHospital0: 'infrastructure_hospital',
      Piece.infrastructureHospital1: 'infrastructure_hospital',
      Piece.infrastructureAkritai0: 'infrastructure_akritai',
      Piece.infrastructureAkritai1: 'infrastructure_akritai',
      Piece.infrastructureMonastery0: 'infrastructure_monastery',
      Piece.infrastructureMonastery1: 'infrastructure_monastery',
      Piece.infrastructureHospitalUsed0: 'infrastructure_used',
      Piece.infrastructureHospitalUsed1: 'infrastructure_used',
      Piece.infrastructureAkritaiUsed0: 'infrastructure_used',
      Piece.infrastructureAkritaiUsed1: 'infrastructure_used',
      Piece.infrastructureMonasteryIsolated0: 'infrastructure_monastery_isolated',
      Piece.infrastructureMonasteryIsolated1: 'infrastructure_monastery_isolated',
      Piece.bulgarianTheme: 'bulgarian_theme',
      Piece.factionBlueTeam: 'faction_blue_team',
      Piece.factionGreenTeam: 'faction_green_team',
      Piece.factionRomanSenate: 'faction_roman_senate',
      Piece.factionEunuchs: 'faction_eunuchs',
      Piece.factionPatricians: 'faction_patricians',
      Piece.factionArmenian: 'faction_armenian',
      Piece.factionSalonika: 'faction_salonika',
      Piece.factionPostalService: 'faction_postal_service',
      Piece.factionSomateiaGuilds: 'faction_somateia_guilds',
      Piece.factionTheodosianWalls: 'faction_theodosian_walls',
      Piece.factionHagiaSophia: 'faction_hagia_sophia',
      Piece.university: 'university',
      Piece.kastron: 'kastron',
      Piece.tribeSouthEgypt: 'tribe_south_egypt',
      Piece.tribeSouthMoors: 'tribe_south_moors',
      Piece.tribeSouthSaracen: 'tribe_south_saracen',
      Piece.tribeSouthVandal: 'tribe_south_vandal',
      Piece.tribeSouthVenice: 'tribe_south_venice',
      Piece.tribeWestGoth: 'tribe_west_goth',
      Piece.tribeWestLombards: 'tribe_west_lombards',
      Piece.tribeWestNorman: 'tribe_west_norman',
      Piece.tribeWestOttoman: 'tribe_west_ottoman',
      Piece.tribeWestSerbs: 'tribe_west_serbs',
      Piece.tribeNorthBulgar: 'tribe_north_bulgar',
      Piece.tribeNorthBulgarians: 'tribe_north_bulgarians',
      Piece.tribeNorthHun: 'tribe_north_hun',
      Piece.tribeNorthOstrogoths: 'tribe_north_ostrogoths',
      Piece.tribeNorthOttoman: 'tribe_north_ottoman',
      Piece.tribeNorthSlav: 'tribe_north_slav',
      Piece.outpostEgypt: 'outpost_egypt',
      Piece.outpostHolyLand: 'outpost_holy_land',
      Piece.outpostLazica: 'outpost_lazica',
      Piece.outpostRome: 'outpost_rome',
      Piece.outpostSicily: 'outpost_sicily',
      Piece.outpostSpain: 'outpost_spain',
      Piece.geographyAfrica: 'geography_africa',
      Piece.geographyCrete: 'geography_crete',
      Piece.geographyItaly: 'geography_italy',
      Piece.geographyBalkans: 'geography_balkans',
      Piece.ravenna: 'ravenna',
      Piece.holyRomanEmpire: 'holy_roman_empire',
      Piece.rulerKhan: 'ruler_khan',
      Piece.rulerRex: 'ruler_rex',
      Piece.stolos: 'stolos_english',
      Piece.tribute: 'tribute',
      Piece.basileusJustinian: 'basileus_justinian',
      Piece.basileusTheodosius: 'basileus_theodosius',
      Piece.basileusJohn: 'basileus_john',
      Piece.basileusBasil: 'basileus_basil',
      Piece.basileusAlexios: 'basileus_alexios',
      Piece.basileusZoe: 'basileus_zoe',
      Piece.basileusConstantine0: 'basileus_constantine_1',
      Piece.basileusNikephoros: 'basileus_nikephoros',
      Piece.basileusAndronikos: 'basileus_andronikos',
      Piece.basileusConstantine1: 'basileus_constantine_2',
      Piece.basileusLeo: 'basileus_leo',
      Piece.basileusTheodora: 'basileus_theodora',
      Piece.basileusRomanos: 'basileus_romanos',
      Piece.basileusMichael: 'basileus_michael',
      Piece.basileusAlternateJohn: 'basileus_john',
      Piece.basileusAlternateBasil: 'basileus_basil',
      Piece.basileusAlternateAlexios: 'basileus_alexios',
      Piece.basileusAlternateZoe: 'basileus_zoe',
      Piece.basileusAlternateConstantine0: 'basileus_constantine_1',
      Piece.basileusAlternateNikephoros: 'basileus_nikephoros',
      Piece.basileusAlternateAndronikos: 'basileus_andronikos',
      Piece.basileusAlternateConstantine1: 'basileus_constantine_2',
      Piece.basileusAlternateLeo: 'basileus_leo',
      Piece.basileusAlternateTheodora: 'basileus_theodora',
      Piece.basileusAlternateRomanos: 'basileus_romanos',
      Piece.basileusAlternateMichael: 'basileus_michael',
      Piece.dynastyPurpleTheodosian: 'dynasty_purple_theodosian',
      Piece.dynastyPurpleLeonid: 'dynasty_purple_leonid',
      Piece.dynastyPurpleJustinian: 'dynasty_purple_justinian',
      Piece.dynastyPurpleHeraclian: 'dynasty_purple_heraclian',
      Piece.dynastyPurpleIsaurian: 'dynasty_purple_isaurian',
      Piece.dynastyPurpleAnarchy0: 'dynasty_purple_anarchy',
      Piece.dynastyPurpleAngelid: 'dynasty_purple_angelid',
      Piece.dynastyPurpleAmorian: 'dynasty_purple_amorian',
      Piece.dynastyPurpleMacedonian: 'dynasty_purple_macedonian',
      Piece.dynastyPurpleKomnenid: 'dynasty_purple_komnenid',
      Piece.dynastyPurpleLaskarid: 'dynasty_purple_laskarid',
      Piece.dynastyPurplePalaiologian: 'dynasty_purple_palaiologian',
      Piece.dynastyPurpleAnarchy1: 'dynasty_purple_anarchy',
      Piece.dynastyPurpleDoukid: 'dynasty_purple_doukid',
      Piece.dynastyBlackDyonisid: 'dynasty_black_dyonisid',
      Piece.dynastyBlackSkylosophid: 'dynasty_black_skylosophid',
      Piece.dynastyBlackLazarid: 'dynasty_black_lazarid',
      Piece.dynastyBlackStemniote: 'dynasty_black_stemniote',
      Piece.dynastyBlackSphikid: 'dynasty_black_sphikid',
      Piece.dynastyBlackAnarchy0: 'dynasty_black_anarchy',
      Piece.dynastyBlackDimidid: 'dynasty_black_dimidid',
      Piece.dynastyBlackSouliote: 'dynasty_black_souliote',
      Piece.dynastyBlackLantzid: 'dynasty_black_lantzid',
      Piece.dynastyBlackManiote: 'dynasty_black_maniote',
      Piece.dynastyBlackKladiote: 'dynasty_black_kladiote',
      Piece.dynastyBlackYpsilantid: 'dynasty_black_ypsilantid',
      Piece.dynastyBlackAnarchy1: 'dynasty_black_anarchy',
      Piece.dynastyBlackVlachid: 'dynasty_black_vlachid',
      Piece.patriarchNestorius: 'patriarch_nestorius',
      Piece.patriarchSergius: 'patriarch_sergius',
      Piece.patriarchAnthimus: 'patriarch_anthimus',
      Piece.patriarchPeter: 'patriarch_peter',
      Piece.patriarchJohn: 'patriarch_john',
      Piece.patriarchAntony: 'patriarch_antony',
      Piece.patriarchPaul: 'patriarch_paul',
      Piece.patriarchConstantine: 'patriarch_constantine',
      Piece.patriarchNicholas: 'patriarch_nicholas',
      Piece.patriarchMichael: 'patriarch_michael',
      Piece.popeNice: 'pope_nice',
      Piece.popeMean: 'pope_mean',
      Piece.magisterMilitum: 'magister_militum',
      Piece.bulgarianChurchOrthodox: 'bulgarian_church_orthodox',
      Piece.bulgarianChurchCatholic: 'bulgarian_church_catholic',
      Piece.kievPagan: 'kiev_pagan',
      Piece.kievOrthodox: 'kiev_orthodox',
      Piece.egyptFallen: 'egypt_fallen',
      Piece.egyptMuslim: 'egypt_muslim',
      Piece.empiresInRubble: 'empires_in_rubble',
      Piece.basileus: 'basileus',
      Piece.caliph: 'caliph',
      Piece.fitna: 'fitna',
      Piece.plague: 'plague',
      Piece.crusade: 'crusade',
      Piece.militaryEvent: 'military_event',
      Piece.nike: 'nike',
      Piece.reforms: 'reforms',
      Piece.schism: 'schism',
      Piece.solidus: 'solidus',
      Piece.turnChit1: 'turn_chit_01',
      Piece.turnChit2: 'turn_chit_02',
      Piece.turnChit3: 'turn_chit_03',
      Piece.turnChit4: 'turn_chit_04',
      Piece.turnChit5: 'turn_chit_05',
      Piece.turnChit6: 'turn_chit_06',
      Piece.turnChit7: 'turn_chit_07',
      Piece.turnChit8: 'turn_chit_08',
      Piece.turnChit9: 'turn_chit_09',
      Piece.turnChit10: 'turn_chit_10',
      Piece.turnChit11: 'turn_chit_11',
      Piece.turnChit12: 'turn_chit_12',
      Piece.turnChit13: 'turn_chit_13',
      Piece.turnChit14: 'turn_chit_14',
      Piece.turnChit15: 'turn_chit_15',
      Piece.turnChit16: 'turn_chit_16',
      Piece.turnChit17: 'turn_chit_17',
      Piece.turnChit18: 'turn_chit_18',
      Piece.turnChit19: 'turn_chit_19',
      Piece.turnChit20: 'turn_chit_20',
      Piece.turnChit21: 'turn_chit_21',
      Piece.turnChit22: 'turn_chit_22',
      Piece.turnChit23: 'turn_chit_23',
      Piece.turnChit24: 'turn_chit_24',
      Piece.turnChit25: 'turn_chit_25',
      Piece.turnChit26: 'turn_chit_26',
      Piece.turnChit27: 'turn_chit_27',
      Piece.turnChit28: 'turn_chit_28',
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
          border: Border.all(color: Colors.red, width: 5.0),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: widget,
      );
      borderWidth += 5.0;
    } else if (selected) {
      widget = Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.green, width: 5.0),
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
    case BoardArea.counterTray:
      _counterTrayStackChildren.add(widget);
    }
  }

  void addZoneToMap(MyAppState appState, Location zone, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(zone);
    bool selected = playerChoices.selectedLocations.contains(zone);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = const SizedBox(
      height: 197.0,
      width: 215.0,
    );

    if (choosable) {
      widget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          border: Border.all(color: Colors.red, width: 5.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: widget,
      );
    } else if (selected) {
      widget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          border: Border.all(color: Colors.green, width: 5.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: widget,
      );
    }

    if (choosable) {
      widget = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            appState.choseLocation(zone);
          },
          child: widget,
        ),
      );
    }

    widget = Positioned(
      left: x - 17.0,
      top: y - 10.0,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addThemeToMap(MyAppState appState, Location theme, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(theme);
    bool selected = playerChoices.selectedLocations.contains(theme);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = const SizedBox(
      height: 65.0,
      width: 65.0,
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
            appState.choseLocation(theme);
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

  void addHomelandToMap(MyAppState appState, Location homeland, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(homeland);
    bool selected = playerChoices.selectedLocations.contains(homeland);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = const SizedBox(
      height: 100.0,
      width: 215.0,
    );

    if (choosable) {
      widget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          border: Border.all(color: Colors.red, width: 5.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: widget,
      );
    } else if (selected) {
      widget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          border: Border.all(color: Colors.green, width: 5.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: widget,
      );
    }

    if (choosable) {
      widget = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            appState.choseLocation(homeland);
          },
          child: widget,
        ),
      );
    }

    widget = Positioned(
      left: x - 10.0,
      top: y - 17.0,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addOmnibusBoxToMap(MyAppState appState, Location box, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(box);
    bool selected = playerChoices.selectedLocations.contains(box);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = const SizedBox(
      height: 80.0,
      width: 70.0,
    );

    if (choosable) {
      widget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          border: Border.all(color: Colors.red, width: 5.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: widget,
      );
    } else if (selected) {
      widget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          border: Border.all(color: Colors.green, width: 5.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: widget,
      );
    }

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
      left: x - 10.0,
      top: y - 16.0,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.constantinople: (BoardArea.map, 673.0, 857.0),
      Location.zoneSouth: (BoardArea.map, 508.0, 1282.0),
      Location.zoneWest: (BoardArea.map, 156.0, 816.0),
      Location.zoneNorth: (BoardArea.map, 485.0, 622.0),
      Location.themeNicaea: (BoardArea.map, 1041.0, 867.0),
      Location.themePaphlagonia: (BoardArea.map, 1204.5, 889.0),
      Location.themeLesserArmenia: (BoardArea.map, 1366.0, 891.0),
      Location.themeGreaterArmenia: (BoardArea.map, 1503.0, 909.0),
      Location.homelandIberia: (BoardArea.map, 1488.0, 773.0),
      Location.themeAmorion: (BoardArea.map, 1069.0, 1019.0),
      Location.themeCappadocia: (BoardArea.map, 1231.0, 1062.0),
      Location.themeMelitene: (BoardArea.map, 1386.0, 1070.0),
      Location.themeNisibis: (BoardArea.map, 1513.5, 1142.0),
      Location.homelandPersia: (BoardArea.map, 1488.0, 1010.0),
      Location.themeEphesus: (BoardArea.map, 867.0, 1154.5),
      Location.themeCilicia: (BoardArea.map, 1317.0, 1183.0),
      Location.themeJerusalem: (BoardArea.map, 1398.0, 1430.0),
      Location.themeDamascus: (BoardArea.map, 1500.0, 1369.0),
      Location.homelandSyria: (BoardArea.map, 1488.0, 1245.0),
      Location.southTribeBox: (BoardArea.map, 413.0, 1310.0),
      Location.westTribeBox: (BoardArea.map, 60.0, 845.0),
      Location.northTribeBox: (BoardArea.map, 391.0, 650.0),
      Location.outpostRomeBox: (BoardArea.map, 51.0, 1080.0),
      Location.popeBox: (BoardArea.map, 136.0, 1080.0),
      Location.outpostSicilyBox: (BoardArea.map, 72.0, 1306.0),
      Location.outpostSpainBox: (BoardArea.map, 51.0, 1434.0),
      Location.outpostLazicaBox: (BoardArea.map, 1482.0, 625.0),
      Location.outpostLazicaGreekFireBox: (BoardArea.map, 1585.0, 626.0),
      Location.outpostHolyLandBox: (BoardArea.map, 1183.5, 1454.0),
      Location.outpostEgyptBox: (BoardArea.map, 1070.0, 1620.0),
      Location.egyptianReligionBox: (BoardArea.map, 968.0, 1620.0),
      Location.bulgarianChurchBox: (BoardArea.map, 441.0, 867.0),
      Location.hippodromeBox: (BoardArea.map, 583.0, 1015.0),
      Location.kyivBox: (BoardArea.map, 1254.5, 599.0),
      Location.stolosLurkingBox: (BoardArea.map, 1173.0, 1282.0),
      Location.arabiaBox: (BoardArea.map, 1605.0, 1605.0),
      Location.dynastyBox: (BoardArea.map, 933.5, 696.0),
      Location.dynastyBoxCivilWar0: (BoardArea.map, 844.0, 696.0),
      Location.dynastyBoxCivilWar1: (BoardArea.map, 754.0, 696.0),
      Location.basileusBox: (BoardArea.map, 1022.0, 696.0),
      Location.basileusHusbandBox: (BoardArea.map, 1022.0, 601.0),
      Location.basileusAlternateBox: (BoardArea.map, 1022.0, 786.0),
      Location.patriarchBox: (BoardArea.map, 1110.0, 696.0),
      Location.availableOutpostsBox: (BoardArea.map, 887.0, 1331.0),
      Location.reformsBox: (BoardArea.map, 379.0, 1621.0),
      Location.crusadesABox: (BoardArea.map, 1218.5, 1599.0),
      Location.crusadesBBox: (BoardArea.map, 1297.0, 1599.0),
      Location.crusadesCBox: (BoardArea.map, 1376.0, 1600.0),
      Location.crusadesDBox: (BoardArea.map, 1455.0, 1600.0),
      Location.militaryEventBox: (BoardArea.map, 1013.0, 307.0),
      Location.strategikonDonatists: (BoardArea.map, 531.0, 59.0),
      Location.chronographia1: (BoardArea.map, 1150.0, 41.0),
      Location.chronographiaOverflow: (BoardArea.map, 0.0, 0.0),  // TODO
      Location.omnibus0: (BoardArea.map, 450.0, 457.0),
      Location.reservesSouth: (BoardArea.counterTray, 245.0, 270.0),
      Location.reservesWest: (BoardArea.counterTray, 640.0, 270.0),
      Location.reservesNorth: (BoardArea.counterTray, 1035.0, 270.0),
      Location.trayTurnChits: (BoardArea.counterTray, 80.0, 659.0),
      Location.trayPatriarchs: (BoardArea.counterTray, 82.0, 765.0),
      Location.trayFactions: (BoardArea.counterTray, 678.0, 765.0),
      Location.trayPathSouth: (BoardArea.counterTray, 80.0, 888.0),
      Location.trayPathWest: (BoardArea.counterTray, 379.0, 888.0),
      Location.trayPathNorth: (BoardArea.counterTray, 678.0, 888.0),
      Location.trayBasileus: (BoardArea.counterTray, 975.0, 888.0),
      Location.trayPathIberia: (BoardArea.counterTray, 80.0, 1008.0),
      Location.trayPathPersia: (BoardArea.counterTray, 379.0, 1008.0),
      Location.trayPathSyria: (BoardArea.counterTray, 678.0, 1008.0),
      Location.trayMilitary: (BoardArea.counterTray, 94.0, 1163.0),
      Location.trayDynasties: (BoardArea.counterTray, 523.0, 1149.0),
      Location.trayPolitical: (BoardArea.counterTray, 1000.0, 1032.0),
      Location.trayMarkers: (BoardArea.counterTray, 130.0, 1320.0),
      Location.trayGeography: (BoardArea.counterTray, 86.0, 1490.0),
      Location.trayUnits: (BoardArea.counterTray, 544.0, 1320.0),
      Location.trayOutposts: (BoardArea.counterTray, 985.0, 1330.0),
      Location.traySieges: (BoardArea.counterTray, 985.0, 1490.0),
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

  void layoutBoxes(MyAppState appState) {
    const boxesInfo = {
      Location.southTribeBox: (1, 1, 0.0, 0.0),
      Location.westTribeBox: (1, 1, 0.0, 0.0),
      Location.northTribeBox: (1, 1, 0.0, 0.0),
      Location.outpostRomeBox: (1, 1, 0.0, 0.0),
      Location.popeBox: (1, 1, 0.0, 0.0),
      Location.outpostSicilyBox: (1, 1, 0.0, 0.0),
      Location.outpostSpainBox: (1, 1, 0.0, 0.0),
      Location.outpostLazicaBox: (1, 1, 0.0, 0.0),
      Location.outpostLazicaGreekFireBox: (1, 1, 0.0, 0.0),
      Location.outpostHolyLandBox: (1, 1, 0.0, 0.0),
      Location.outpostEgyptBox: (1, 1, 0.0, 0.0),
      Location.egyptianReligionBox: (1, 1, 0.0, 0.0),
      Location.bulgarianChurchBox: (1, 1, 0.0, 0.0),
      Location.hippodromeBox: (1, 1, 0.0, 0.0),
      Location.kyivBox: (1, 1, 0.0, 0.0),
      Location.stolosLurkingBox: (1, 1, 0.0, 0.0),
      Location.arabiaBox: (1, 1, 4.0, 4.0),
      Location.dynastyBox: (1, 1, 0.0, 0.0),
      Location.dynastyBoxCivilWar0: (1, 1, 0.0, 0.0),
      Location.dynastyBoxCivilWar1: (1, 1, 0.0, 0.0),
      Location.basileusBox: (1, 1, 0.0, 0.0),
      Location.basileusHusbandBox: (1, 1, 0.0, 0.0),
      Location.basileusAlternateBox: (1, 1, 0.0, 0.0),
      Location.patriarchBox: (1, 1, 0.0, 0.0),
      Location.availableOutpostsBox: (3, 2, 10.0, 10.0),
      Location.reformsBox: (1, 1, 0.0, 0.0),
      Location.crusadesABox: (1, 1, 0.0, 0.0),
      Location.crusadesBBox: (1, 1, 0.0, 0.0),
      Location.crusadesCBox: (1, 1, 0.0, 0.0),
      Location.crusadesDBox: (1, 1, 0.0, 0.0),
      Location.militaryEventBox: (1, 1, 0.0, 0.0),
      Location.chronographiaOverflow: (1, 1, 0.0, 0.0),
      Location.reservesSouth: (1, 6, 0.0, 10.0),
      Location.reservesWest: (1, 6, 0.0, 10.0),
      Location.reservesNorth: (1, 6, 0.0, 10.0),
      Location.trayTurnChits: (17, 1, 10.0, 0.0),
      Location.trayPatriarchs: (9, 1, 5.0, 0.0),
      Location.trayFactions: (9, 1, 5.0, 0.0),
      Location.trayPathSouth: (4, 1, 15.0, 0.0),
      Location.trayPathWest: (4, 1, 15.0, 0.0),
      Location.trayPathNorth: (4, 1, 15.0, 0.0),
      Location.trayBasileus: (4, 1, 15.0, 0.0),
      Location.trayPathIberia: (4, 1, 15.0, 0.0),
      Location.trayPathPersia: (4, 1, 15.0, 0.0),
      Location.trayPathSyria: (4, 1, 15.0, 0.0),
      Location.trayMilitary: (5, 1, 25.0, 0.0),
      Location.trayDynasties: (7, 2, 4.0, 4.0),
      Location.trayPolitical: (3, 3, 25.0, 25.0),
      Location.trayMarkers: (4, 1, 25.0, 0.0),
      Location.trayGeography: (6, 1, 13.0, 0.0),
      Location.trayUnits: (5, 3, 25.0, 25.0),
      Location.trayOutposts: (4, 1, 10.0, 0.0),
      Location.traySieges: (4, 1, 10.0, 0.0),
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
      layoutBoxStacks(appState, box, state.piecesInLocation(PieceType.all, box), boardArea, cols, rows, xBox, yBox, 60.0 + xGap, 60 + yGap, 4.0, 4.0);
    }
  }

  void layoutConstantinople(MyAppState appState) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(Location.constantinople);
    final xLand = coordinates.$2;
    final yLand = coordinates.$3;

    if (!_emptyMap) {
      final factions = <Piece>[];
      final riots = <Piece>[];
      Piece? theodosianWalls;
      Piece? basileus;
      Piece? magisterMilitum;
      Piece? university;
      for (final piece in state.piecesInLocation(PieceType.all, Location.constantinople)) {
        if (piece.isType(PieceType.faction)) {
          if (piece == Piece.factionTheodosianWalls) {
            theodosianWalls = piece;
          } else {
            factions.add(piece);
          }
        } else if (piece.isType(PieceType.riots) || piece.isType(PieceType.latins)) {
          riots.add(piece);
        } else if (piece == Piece.basileus || piece == Piece.plague) {
          basileus = piece;
        } else if (piece == Piece.magisterMilitum) {
          magisterMilitum = piece;
        } else if (piece == Piece.university) {
          university = piece;
        }
      }
      for (int i = factions.length - 1; i >= 0; --i) {
        int col = i % 5;
        int row = i ~/ 5;
        double x = xLand + col * 65.0;
        double y = yLand + row * 65.0;
        addPieceToBoard(appState, factions[i], BoardArea.map, x, y);
      }
      for (int i = riots.length - 1; i >= 0; --i) {
        int col = i % 5;
        int row = 3 + i ~/ 5;
        if (i == 5) {
          col = 4;
          row = 2;
        }
        double x = xLand + col * 65.0;
        double y = yLand + row * 65.0;
        addPieceToBoard(appState, riots[i], BoardArea.map, x, y);
      }
      if (theodosianWalls != null) {
        int col = 3;
        int row = 2;
        double x = xLand + col * 65.0;
        double y = yLand + row * 65.0;
        addPieceToBoard(appState, theodosianWalls, BoardArea.map, x, y);
      }
      if (university != null) {
        int col = 2;
        int row = 2;
        double x = xLand + col * 65.0;
        double y = yLand + row * 65.0;
        addPieceToBoard(appState, university, BoardArea.map, x, y);
      }
      if (magisterMilitum != null) {
        int col = 1;
        int row = 2;
        double x = xLand + col * 65.0;
        double y = yLand + row * 65.0;
        addPieceToBoard(appState, magisterMilitum, BoardArea.map, x, y);
      }
      if (basileus != null) {
        int col = 0;
        int row = 2;
        double x = xLand + col * 65.0;
        double y = yLand + row * 65.0;
        addPieceToBoard(appState, basileus, BoardArea.map, x, y);
      }
    }
  }

  void layoutZone(MyAppState appState, Location zone) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(zone);
    final xLand = coordinates.$2;
    final yLand = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(zone)) {
      addZoneToMap(appState, zone, xLand, yLand);
    }

    if (!_emptyMap) {
      final pieces = state.piecesInLocation(PieceType.all, zone);
      Piece? modifier;
      Piece? geography;
      Piece? monastery;
      Piece? social;
      Piece? ruler;
      final others = <Piece>[];
      for (final piece in pieces) {
        if (piece.isType(PieceType.geography)) {
          geography = piece;
        } else if (piece.isType(PieceType.monastery)) {
          monastery = piece;
        } else if (piece.isType(PieceType.social)) {
          social = piece;
        } else if (piece.isType(PieceType.ruler)) {
          ruler = piece;
        } else if ([Piece.ravenna, Piece.holyRomanEmpire, Piece.bulgarianTheme].contains(piece)) {
          modifier = piece;
        } else if (piece != Piece.stolos) {
          others.add(piece);
        }
      }
      for (int i = others.length - 1; i >= 0; --i) {
        int col = i % 3;
        int row = i ~/ 3;
        double x = xLand + col * 65.0;
        double y = yLand + row * 65.0;
        if (others[i] == state.stolosArmy) {
          addPieceToBoard(appState, Piece.stolos, BoardArea.map, x, y + 20.0);        
        }
        addPieceToBoard(appState, others[i], BoardArea.map, x, y);
      }
      if (monastery != null) {
        int col = 2;
        int row = 2;
        double x = xLand + col * 65.0;
        double y = yLand + row * 65.0;
        addPieceToBoard(appState, monastery, BoardArea.map, x, y);
      }
      if (social != null) {
        int col = 0;
        int row = 2;
        double x = xLand + col * 65.0;
        double y = yLand + row * 65.0;
        addPieceToBoard(appState, social, BoardArea.map, x, y);
      }
      if (modifier != null) {
        int col = 1;
        int row = 2;
        double x = xLand + col * 65.0;
        double y = yLand + row * 65.0;
        addPieceToBoard(appState, modifier, BoardArea.map, x, y);
      }
      if (geography != null) {
        int col = 1;
        int row = -1;
        double x = xLand + col * 65.0;
        double y = yLand + row * 65.0;
        addPieceToBoard(appState, geography, BoardArea.map, x, y);
      }
      if (ruler != null) {
        int col = 2;
        int row = 1;
        double x = xLand + col * 65.0;
        double y = yLand + row * 65.0;
        addPieceToBoard(appState, ruler, BoardArea.map, x, y);
      }
    }

    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(zone)) {
      addZoneToMap(appState, zone, xLand, yLand);
    }
  }

  void layoutTheme(MyAppState appState, Location theme) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(theme);
    final xLand = coordinates.$2;
    final yLand = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(theme)) {
      addThemeToMap(appState, theme, xLand, yLand);
    }

    if (_emptyMap) {
      final pieces = state.piecesInLocation(PieceType.all, theme);
      for (int i = pieces.length - 1; i >= 0; --i) {
        if (pieces[i] == Piece.stolos) {
          continue;
        }
        double x = xLand + i * 4.0;
        double y = yLand + i * 4.0;
        if (pieces[i] == state.stolosArmy) {
          addPieceToBoard(appState, Piece.stolos, BoardArea.map, x, y + 20.0);        
        }
        addPieceToBoard(appState, pieces[i], BoardArea.map, x, y);
      }
    }

    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(theme)) {
      addThemeToMap(appState, theme, xLand, yLand);
    }
  }

  void layoutHomeland(MyAppState appState, Location homeland) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(homeland);
    final xLand = coordinates.$2;
    final yLand = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(homeland)) {
      addHomelandToMap(appState, homeland, xLand, yLand);
    }

    if (!_emptyMap) {
      final pieces = <Piece>[];
      for (final piece in state.piecesInLocation(PieceType.all, homeland)) {
        if (piece != Piece.stolos) {
          pieces.add(piece);
        }
      }
      for (int i = pieces.length - 1; i >= 0; --i) {
        int col = 2 - i % 3;
        int depth = i ~/ 3;
        double x = xLand + col * 72.0 + depth * 4.0;
        double y = yLand + depth * 4.0;
        if (pieces[i] == state.stolosArmy) {
          addPieceToBoard(appState, Piece.stolos, BoardArea.map, x, y + 20.0);        
        }
        addPieceToBoard(appState, pieces[i], BoardArea.map, x, y);
      }
    }

    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(homeland)) {
      addHomelandToMap(appState, homeland, xLand, yLand);
    }
  }

  void layoutLands(MyAppState appState) {
    for (final land in LocationType.land.locations) {
      if (land == Location.constantinople) {
        layoutConstantinople(appState);
      } else if (land.isType(LocationType.zone)) {
        layoutZone(appState, land);
      } else if ([Location.homelandIberia, Location.homelandPersia, Location.homelandSyria].contains(land)) {
        layoutHomeland(appState, land);
      } else {
        layoutTheme(appState, land);
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
        double xBox = xFirst + index * 90.8;

      if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(box)) {
        addOmnibusBoxToMap(appState, box, xBox, yBox);
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
        addOmnibusBoxToMap(appState, box, xBox, yBox);
      }
    }
  }

  void layoutStrategikon(MyAppState appState) {
    final state = appState.gameState!;
    final location = state.pieceLocation(Piece.militaryEvent);
    if (location.isType(LocationType.strategikon)) {
      int index = location.index - LocationType.strategikon.firstIndex;
      int col = index % 4;
      int row = index ~/ 4;
      final coordinates = locationCoordinates(Location.strategikonDonatists);
      double xFirst = coordinates.$2;
      double yFirst = coordinates.$3;
      double xBox = xFirst + col * 164.0;
      double yBox = yFirst + row * 83.5;
      addPieceToBoard(appState, Piece.militaryEvent, BoardArea.map, xBox, yBox);
    }
  }

  void layoutChronographia(MyAppState appState) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(Location.chronographia1);
    double xFirst = coordinates.$2;
    double yFirst = coordinates.$3;
    for (final box in LocationType.chronographia.locations) {
      int index = box.index - LocationType.chronographia.firstIndex;
      int col = index % 6;
      int row = index ~/ 6;
      double xBox = xFirst + col * 96.7;
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
      for (int i = others.length - 1; i >= 0; --i) {
        double x = xBox - others.length * 2.0 + (i + 1) * 4.0;
        double y = yBox - others.length * 2.0 + (i + 1) * 4.0;
        addPieceToBoard(appState, others[i], BoardArea.map, x, y);
      }
      if (turnChit != null) {
        double x = xBox - others.length * 2.0;
        double y = yBox - others.length * 2.0;
        addPieceToBoard(appState, turnChit, BoardArea.map, x, y);
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
    _counterTrayStackChildren.clear();
    _counterTrayStackChildren.add(_counterTrayImage);

    _pieceStackKeys.clear();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutLands(appState);
      layoutBoxes(appState);
      layoutOmnibus(appState);
      layoutStrategikon(appState);
      layoutChronographia(appState);

      const choiceTexts = {
        Choice.blockMagyarSacrifice: 'Sacrifice Magyar Army',
        Choice.blockMagyarProp: 'Prop Magyar Army',
        Choice.blockSkanderbegSacrifice: 'Sacrifice Skanderbeg Army',
        Choice.blockSkanderbegProp: 'Prop Skanderbeg Army',
        Choice.shiftForces: 'Shift Forces',
        Choice.attackWithSolidus: 'Regular Attack',
        Choice.attackWithMagisterMilitum: 'Free Attack by Magister Militum',
        Choice.attackWithSoldierEmperor: 'Free Attack by Soldier Emperor',
        Choice.attackWithBasileusIntoBattle: 'Attack with Basileus Into Battle',
        Choice.seizeOutpost: 'Seize Outpost',
        Choice.abandonOutpost: 'Abandon Outpost',
        Choice.buildMonastery: 'Build Monastery',
        Choice.buildMonasterySlavery: 'Build Monastery using slave labor',
        Choice.reopenMonasteries: 'Reopen Monasteries',
        Choice.buildHospital: 'Build Hospital',
        Choice.abandonHospital: 'Abandon Hospital',
        Choice.buildHospitalSlavery: 'Build Hospital using slave labor',
        Choice.combatPlague: 'Combat Plague',
        Choice.buildAkritai: 'Build Akritai',
        Choice.abandonAkritai: 'Abandon Akritai',
        Choice.exploitSocialDifferences: 'Exploit Social Differences',
        Choice.calmRiot: 'Calm Riot',
        Choice.enforceOrthodoxy: 'Enforce Orthodoxy',
        Choice.buildFaction: 'Build Faction',
        Choice.cleanRubble: 'Reduce Rubble',
        Choice.activateGreekFire: 'Activate Greek Fire',
        Choice.faceRuler: 'Face Ruler',
        Choice.faceCaliph: 'Face the Caliph',
        Choice.legendaryOrator: 'Legendary Orator',
        Choice.navalReforms: 'Naval Reforms',
        Choice.ruinousTaxation: 'Ruinous Taxation',
        Choice.churchPolitics: 'Church Politics',
        Choice.legislate: 'Legislate',
        Choice.visionaryReformer: 'Visionary Reformer',
        Choice.expelColonists: 'Expel Colonists',
        Choice.pandidakterion: 'Pandidakterion',
        Choice.enforceOrthodoxyIgnoreDrms: 'Ignore Enforce Orthodoxy -1 DRMs',
        Choice.enforceOrthodoxyFree: 'Free Enforce Orthodoxy roll',
        Choice.increaseSchism: 'Increase Schism',
        Choice.incurRiot: 'Suffer Riots',
        Choice.reduceSchism: 'Reduce Schism',
        Choice.earnSolidus: 'Earn \$olidus',
        Choice.adjustDieUp: 'Increase die roll by 1',
        Choice.adjustDieDown: 'Reduce die roll by 1',
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
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.3)),
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
                        child: Stack(children: _counterTrayStackChildren),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 680.0,
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

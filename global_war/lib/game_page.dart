import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:global_war/game.dart';
import 'package:global_war/main.dart';

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
  static const _mapWidth = 2112.0;
  static const _mapHeight = 1632.0;
  static const _counterTrayWidth = 1261.0;
  static const _counterTrayHeight = 1632.0;
  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _counterTrayImage = Image.asset('assets/images/tray.png', key: UniqueKey(), width: _counterTrayWidth, height: _counterTrayHeight);
  final _mapStackChildren = <Widget>[];
  final _counterTrayChildren = <Widget>[];
  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.capitalBerlin: 'capital_berlin',
      Piece.capitalCcnn: 'capital_ccnn',
      Piece.capitalGoring: 'capital_goring',
      Piece.capitalHitler: 'capital_hitler',
      Piece.capitalManchukuo: 'capital_manchukuo',
      Piece.capitalMussolini: 'capital_mussolini',
      Piece.capitalThailand: 'capital_thailand',
      Piece.capitalTokyo: 'capital_tokyo',
      Piece.capitalWestwall: 'capital_westwall',
      Piece.armyChineseCommunist: 'army_ccp',
      Piece.armyCongo: 'army_congo',
      Piece.armyFinnish: 'army_finnish',
      Piece.armyGerman10: 'army_german_10',
      Piece.armyGerman14: 'army_german_14',
      Piece.armyGermanA: 'army_german_a',
      Piece.armyGermanAfrikaKorps: 'army_afrika_korps',
      Piece.armyGermanArnim: 'army_arnim',
      Piece.armyGermanB: 'army_german_b',
      Piece.armyGermanBf109: 'army_bf109',
      Piece.armyGermanC: 'army_german_c',
      Piece.armyGermanCenter: 'army_center',
      Piece.armyGermanDo17: 'army_do17',
      Piece.armyGermanG: 'army_german_g',
      Piece.armyGermanHe111: 'army_he111',
      Piece.armyGermanIraq: 'army_german_iraq',
      Piece.armyGermanJu88: 'army_ju88',
      Piece.armyGermanNorth: 'army_north',
      Piece.armyGermanSouth: 'army_south',
      Piece.armyGermanSyria: 'army_german_syria',
      Piece.armyHungarian: 'army_hungarian',
      Piece.armyIranianShah: 'army_iranian_shah',
      Piece.armyIranianVatan: 'army_iranian_vatan',
      Piece.armyIraqi: 'army_iraqi',
      Piece.armyItalian5: 'army_italian_5',
      Piece.armyItalian10: 'army_italian_10',
      Piece.armyItalianBers: 'army_italian_bers',
      Piece.armyItalianCol: 'army_italian_col',
      Piece.armyItalianLig: 'army_italian_lig',
      Piece.armyItalianEastAfrica: 'army_aoi',
      Piece.armyJapanese14: 'army_japanese_14',
      Piece.armyJapanese15: 'army_japanese_15',
      Piece.armyJapanese18: 'army_japanese_18',
      Piece.armyJapanese28: 'army_japanese_28',
      Piece.armyJapanese31: 'army_japanese_31',
      Piece.armyJapanese32: 'army_japanese_32',
      Piece.armyJapaneseBurmese: 'army_burmese',
      Piece.armyJapaneseCcaa: 'army_japanese_cc_aa',
      Piece.armyJapaneseIndian: 'army_indian',
      Piece.armyJapaneseMadag: 'army_japanese_madag',
      Piece.armyJapaneseNcaa: 'army_japanese_nc_aa',
      Piece.armyJapaneseWang: 'army_wang',
      Piece.armyRomanian: 'army_romanian',
      Piece.armySinkiang: 'army_sinkiang',
      Piece.armyTurkish: 'army_turkey',
      Piece.armyVichyAlger: 'army_vichy_alger',
      Piece.armyVichyMalg: 'army_vichy_malg',
      Piece.armyVichySyria: 'army_vichy_syria',
      Piece.panzerPza: 'panzer_pza',
      Piece.panzerTiger: 'panzer_tiger',
      Piece.armyBataan: 'army_bataan',
      Piece.armyBelgian: 'army_belgium',
      Piece.armyDanish: 'army_denmark',
      Piece.armyDutch: 'army_netherlands',
      Piece.armyFrench1: 'army_france_1',
      Piece.armyFrench2: 'army_france_2',
      Piece.armyGreek: 'army_greece',
      Piece.armyKnil: 'army_knil',
      Piece.armyNorwegian: 'army_norway',
      Piece.armyPolish1: 'army_poland_1',
      Piece.armyPolish2: 'army_poland_2',
      Piece.armySingapore: 'army_singapore',
      Piece.armyTito: 'army_tito',
      Piece.armyWarsaw: 'army_warsaw',
      Piece.armyYugoslavian: 'army_yugoslavia',
      Piece.shipTanakaDestroyers: 'ship_tanaka',
      Piece.shipYamato: 'ship_yamato',
      Piece.shipAkagi: 'ship_akagi',
      Piece.shipZuikaku: 'ship_zuikaku',
      Piece.shipHiryu: 'ship_hiryu',
      Piece.shipChokai: 'ship_chokai',
      Piece.shipKongo: 'ship_kongo',
      Piece.shipZeroRed: 'ship_zero_red',
      Piece.shipIboatsRed: 'ship_iboats_red',
      Piece.shipRyujo: 'ship_ryujo',
      Piece.shipZuiho: 'ship_zuiho',
      Piece.shipAoba: 'ship_aoba',
      Piece.shipTaiho: 'ship_taiho',
      Piece.shipAkizukiDestroyers: 'ship_akizuki',
      Piece.shipNagato: 'ship_nagato',
      Piece.shipHiyo: 'ship_hiyo',
      Piece.shipShinano: 'ship_shinano',
      Piece.shipChitose: 'ship_chitose',
      Piece.shipTone: 'ship_tone',
      Piece.shipHaruna: 'ship_haruna',
      Piece.shipZeroWhite: 'ship_zero_white',
      Piece.shipIboatsWhite: 'ship_iboats_white',
      Piece.shipUnryu: 'ship_unryu',
      Piece.shipIse: 'ship_ise',
      Piece.shipYahagi: 'ship_yahagi',
      Piece.shipKamikaze: 'ship_kamikaze',
      Piece.shipYamamoto: 'ship_yamamoto',
      Piece.carrierBunkerHill: 'carrier_bunker_hill',
      Piece.carrierEnterprise: 'carrier_enterprise',
      Piece.carrierEssex: 'carrier_essex',
      Piece.carrierFdr: 'carrier_fdr',
      Piece.carrierHornet: 'carrier_hornet',
      Piece.carrierIntrepid: 'carrier_intrepid',
      Piece.carrierLangley: 'carrier_langley',
      Piece.carrierLexington: 'carrier_lexington',
      Piece.carrierMidawy: 'carrier_midway',
      Piece.carrierPrinceton: 'carrier_princeton',
      Piece.carrierRanger: 'carrier_ranger',
      Piece.carrierSaratoga: 'carrier_saratoga',
      Piece.carrierTiconderoga: 'carrier_ticonderoga',
      Piece.carrierWasp: 'carrier_wasp',
      Piece.carrierYorktown: 'carrier_yorktown',
      Piece.blitzWestern: 'blitz',
      Piece.blitzEastern: 'blitz',
      Piece.blitzMed: 'blitz',
      Piece.blitzChina: 'blitz',
      Piece.blitzSoutheastAsia: 'blitz',
      Piece.blitzSouthPacific: 'blitz',
      Piece.strategyWestern: 'strategy_a',
      Piece.strategyEastern: 'strategy_b',
      Piece.strategyMed: 'strategy_c',
      Piece.strategyChina: 'strategy_d',
      Piece.strategySoutheastAsia: 'strategy_e',
      Piece.strategySouthPacific: 'strategy_f',
      Piece.occupiedWestern: 'occupied_american',
      Piece.occupiedEastern: 'occupied_soviet',
      Piece.occupiedMed: 'occupied_british',
      Piece.occupiedChina: 'occupied_soviet',
      Piece.occupiedSoutheastAsia: 'occupied_british',
      Piece.occupiedSouthPacific: 'occupied_american',
      Piece.abombWestern: 'mushroom',
      Piece.abombEastern: 'mushroom',
      Piece.abombMed: 'mushroom',
      Piece.abombChina: 'mushroom',
      Piece.abombSoutheastAsia: 'mushroom',
      Piece.abombSouthPacific: 'mushroom',
      Piece.siegeNormandy: 'siege_normandy',
      Piece.siegeStalingrad: 'siege_stalingrad',
      Piece.siegeTunis: 'siege_tunis',
      Piece.siegeImphal: 'siege_imphal',
      Piece.siegeGuadalcanal: 'siege_guadalcanal',
      Piece.siegeTightensNormandy: 'siege_tightens',
      Piece.siegeTightensStalingrad: 'siege_tightens',
      Piece.siegeTightensTunis: 'siege_tightens',
      Piece.siegeTightensImphal: 'siege_tightens',
      Piece.siegeTightensGuadalcanal: 'siege_tightens',
      Piece.policyItaly: 'policy_italy',
      Piece.policyJapanSoutheastAsia: 'policy_japan_e',
      Piece.policyJapanSouthPacific: 'policy_japan_f',
      Piece.policyRussia: 'policy_russia',
      Piece.policySpainAxis: 'policy_spain_axis',
      Piece.policySpainUN: 'policy_spain_un',
      Piece.partisans0: 'partisans',
      Piece.partisans1: 'partisans',
      Piece.partisansCommunist0: 'partisans_communist',
      Piece.partisansCommunist1: 'partisans_communist',
      Piece.partisansSoviet: 'partisans_soviet',
      Piece.partisansItalian: 'partisans_italian',
      Piece.malta: 'malta',
      Piece.maltaBesieged: 'malta_besieged',
      Piece.ricksPlace: 'ricks_place',
      Piece.vichyFleetPeace: 'fleet_vichy_peace',
      Piece.vichyFleetWar: 'fleet_vichy_war',
      Piece.congoUN: 'congo_un',
      Piece.southAfricaUN: 'south_africa_un',
      Piece.southAfricaNeutral: 'south_africa_neutral',
      Piece.occupiedDutchEastIndies: 'dutch_east_indies',
      Piece.greekSurrender: 'greek_surrender',
      Piece.burmaRoadOpen: 'burma_road_open',
      Piece.burmaRoadClosed: 'burma_road_closed',
      Piece.burmaRoadHump: 'burma_road_hump',
      Piece.finlandUN: 'finland_un',
      Piece.indiaGandhi: 'india_gandhi',
      Piece.indiaRevolt: 'india_revolt',
      Piece.sinkiangUssr: 'sinkiang_ussr',
      Piece.escortSaoPaulo: 'escort_sao_paulo',
      Piece.asw: 'asw',
      Piece.aswEnigma: 'asw_enigma',
      Piece.convoyAmerican0: 'convoy_american',
      Piece.convoyAmerican1: 'convoy_american',
      Piece.convoyBritish: 'convoy_british',
      Piece.convoyFrench: 'convoy_french',
      Piece.convoyNorwegian: 'convoy_norwegian',
      Piece.convoyEscorted0: 'convoy_escorted',
      Piece.convoyEscorted1: 'convoy_escorted',
      Piece.convoyEscorted2: 'convoy_escorted',
      Piece.convoyEscorted3: 'convoy_escorted',
      Piece.raiderGrafSpee: 'raider_graf_spee',
      Piece.raiderKormoran: 'raider_kormoran',
      Piece.raiderBismarck: 'raider_bismarck',
      Piece.raiderPrinzEugen: 'raider_prinz_eugen',
      Piece.raiderScharnhorst: 'raider_scharnhorst',
      Piece.raiderRivadavia: 'raider_rivadavia',
      Piece.uboats0: 'uboats',
      Piece.uboats1: 'uboats',
      Piece.uboats2: 'uboats',
      Piece.uboats3: 'uboats',
      Piece.airBaseBritish: 'air_base_british',
      Piece.airBaseUsaaf: 'air_base_usaaf',
      Piece.airBaseUsstaf: 'air_base_usstaf',
      Piece.airBaseTinian: 'air_base_tinian',
      Piece.operationAL: 'operation_al',
      Piece.commandoSkorzeny: 'commando_skorzeny',
      Piece.commandoTeishinShudan: 'commando_teishin_shudan',
      Piece.spruanceP1: 'spruance_p1',
      Piece.spruanceP2: 'spruance_p2',
      Piece.usMarines: 'us_marines',
      Piece.submarineCampaign: 'submarine_campaign',
      Piece.lendLeaseLibertyShips: 'lend_lease_liberty_ships',
      Piece.lendLeaseJeepsTrucks: 'lend_lease_jeeps_trucks',
      Piece.lendLeaseDestroyerDeal: 'lend_lease_destroyer_deal',
      Piece.lendLeaseAidToRussia: 'lend_lease_air_russia',
      Piece.economyGerman: 'economy_german',
      Piece.economyJapanese: 'economy_japanese',
      Piece.noAxisAttackGermany: 'no_axis_attack',
      Piece.noAxisAttackJapanese: 'no_axis_attack',
      Piece.leaderChamberlain: 'leader_chamberlain',
      Piece.leaderChurchill: 'leader_churchill',
      Piece.leaderRoosevelt: 'leader_roosevelt',
      Piece.leaderWilkie: 'leader_wilkie',
      Piece.leaderStalin: 'leader_stalin',
      Piece.leaderStalinUsed: 'leader_stalin_used',
      Piece.cityChicago: 'city_chicago',
      Piece.cityNewYork: 'city_new_york',
      Piece.citySanFrancisco: 'city_san_francisco',
      Piece.citySydney: 'city_sydney',
      Piece.cityGlasgow: 'city_glasgow',
      Piece.cityLondon: 'city_london',
      Piece.cityChungking: 'city_chungking',
      Piece.cityDelhi: 'city_delhi',
      Piece.citySingapore: 'city_singapore',
      Piece.cityMontreal: 'city_montreal',
      Piece.cityAlgiers: 'city_algiers',
      Piece.cityBaku: 'city_baku',
      Piece.cityLeningrad: 'city_leningrad',
      Piece.cityMoscow: 'city_moscow',
      Piece.cityGorky: 'city_gorky',
      Piece.cityTashkent: 'city_tashkent',
      Piece.cityTbilisi: 'city_tbilisi',
      Piece.abombResearch: 'a_bomb_research',
      Piece.abombAvailable: 'a_bomb_available',
      Piece.dollars: 'dollars',
      Piece.dollarsEscort: 'dollars_escort',
      Piece.navalActions1: 'naval_actions_1',
      Piece.navalActions2: 'naval_actions_2',
      Piece.cannonMeat: 'cannon_meat',
      Piece.aidChina: 'aid_china',
      Piece.turnChit1: 'turn_01',
      Piece.turnChit2: 'turn_02',
      Piece.turnChit3: 'turn_03',
      Piece.turnChit4: 'turn_04',
      Piece.turnChit5: 'turn_05',
      Piece.turnChit6: 'turn_06',
      Piece.turnChit7: 'turn_07',
      Piece.turnChit8: 'turn_08',
      Piece.turnChit9: 'turn_09',
      Piece.turnChit10: 'turn_10',
      Piece.turnChit11: 'turn_11',
      Piece.turnChit12: 'turn_12',
      Piece.turnChit13: 'turn_13',
      Piece.turnChit14: 'turn_14',
      Piece.turnChit15: 'turn_15',
      Piece.turnChit16: 'turn_16',
      Piece.turnChit17: 'turn_17',
      Piece.turnChit18: 'turn_18',
      Piece.turnChit19: 'turn_19',
      Piece.turnChit20: 'turn_20',
      Piece.turnChit21: 'turn_21',
      Piece.turnChit22: 'turn_22',
      Piece.turnChit23: 'turn_23',
      Piece.turnChit24: 'turn_24',
      Piece.turnChit25: 'turn_25',
      Piece.turnChit26: 'turn_26',
      Piece.turnChit27: 'turn_27',
      Piece.turnChit28: 'turn_28',
      Piece.turnChitBarbarossa: 'turn_barbarossa',
      Piece.turnChitPearlHarbor: 'turn_pearl_harbor',
      Piece.militaryEvent: 'military_event',
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

  (double, double) locationCoordinates(Location location) {
    const coordinates = {
	    Location.frontWestern: (405.0, 724.0),
	    Location.frontEastern: (798.0, 656.0),
	    Location.frontMed: (578.0, 996.0),
	    Location.frontChina: (1204.5, 799.0),
	    Location.frontSoutheastAsia: (1286.0, 1068.0),
	    Location.frontSouthPacific: (1679.0, 1103.0),
      Location.seaZone1A: (100.0, 100.0),
      Location.seaZone1B: (100.0, 100.0),
      Location.seaZone2A: (100.0, 100.0),
      Location.seaZone2B: (100.0, 100.0),
      Location.seaZone2C: (100.0, 100.0),
      Location.seaZone3: (100.0, 100.0),
      Location.seaZone4: (100.0, 100.0),
      Location.boxCitiesHighMorale: (6.0, 398.0),
      Location.boxCitiesLowMorale: (369.0, 398.0),
      Location.omnibus0: (884.0, 431.0),
      Location.calendar1: (1151.0, 35.0),
      Location.calendar2: (1230.0, 35.0),
      Location.calendar3: (1672.0, 35.0),
      Location.calendar4: (1390.0, 35.0),
      Location.calendar5: (1469.0, 35.0),
      Location.calendar6: (1981.0, 35.0),
      Location.eventWavell: (884.0, 35.0),
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

  void layoutFront(MyAppState appState, Location front) {
    final state = appState.gameState!;
    final partisansBox = state.frontPartisansBox(front);
    final pieces = state.piecesInLocation(PieceType.all, front);
    Piece? partisans = state.pieceInLocation(PieceType.all, partisansBox);
    final coordinates = locationCoordinates(front);
    double xFront = coordinates.$1;
    double yFront = coordinates.$2;
    for (int i = pieces.length - 1; i >= 0; --i) {
      final piece = pieces[i];
      int col = i % 3;
      int row = i ~/ 3;
      if (piece.isType(PieceType.propArmy)) {
        col = 1;
        row = 2;
      }
      double x = xFront + col * 64.0;
      double y = yFront + row * 64.0;
      addPieceToBoard(appState, piece, BoardArea.map, x, y);
    }

    if (partisans != null) {
      double x = xFront - 11.0;
      double y = yFront + 130.0;
      addPieceToBoard(appState, partisans, BoardArea.map, x, y);
    }
  }

  void layoutFronts(MyAppState appState) {
    for (final front in LocationType.front.locations) {
      layoutFront(appState, front);
    }
  }

  void layoutSeaZone(MyAppState appState, Location seaZone) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(seaZone);
    double xZone = coordinates.$1;
    double yZone = coordinates.$2;
    final convoy = state.pieceInLocation(PieceType.convoy, seaZone);
    final asw = state.pieceInLocation(PieceType.asw, seaZone);
    final escort = state.pieceLocation(Piece.escortSaoPaulo) == seaZone ? Piece.escortSaoPaulo : null;
    final axis = state.piecesInLocation(PieceType.raiderOrUboat, seaZone);
    int alliedCount = 0;
    if (convoy != null) {
      alliedCount += 1;
    }
    if (asw != null) {
      alliedCount += 1;
    }
    if (escort != null) {
      alliedCount += 1;
    }
    if (escort != null) {
      double x = convoy != null ? (asw != null ? xZone + 6.0 : xZone + 3.0) : xZone - 30.0;
      double y = axis.isNotEmpty ? yZone - 63.0 : yZone - 30.0;
      addPieceToBoard(appState, escort, BoardArea.map, x, y);
    }
    if (asw != null) {
      double x = xZone + 3.0;
      double y = axis.isNotEmpty ? yZone - 63.0 : yZone - 30.0;
      addPieceToBoard(appState, asw, BoardArea.map, x, y);
    }
    if (convoy != null) {
      double x = asw != null || escort != null ? xZone - 63.0 : xZone - 30.0;
      double y = axis.isNotEmpty ? yZone - 63.0 : yZone - 30.0;
      addPieceToBoard(appState, convoy, BoardArea.map, x, y);
    }
    for (int i = axis.length - 1; i >= 0; --i) {
      double x = i == 1 ? xZone + 3.0 : (axis.length == 2 ? xZone - 63.0 : xZone - 30.0);
      double y = alliedCount > 0 ? yZone + 3.0 : yZone - 30.0;
      addPieceToBoard(appState, axis[i], BoardArea.map, x, y);
    }
  }

  void layoutSeaZones(MyAppState appState) {
    for (final seaZone in LocationType.seaZone.locations) {
      layoutSeaZone(appState, seaZone);
    }
  }

  static const boxInfos = {
    Location.seaMidway: (BoardArea.map, 1784.0, 892.0, 2, 2, false, 4.0, 4.0),
    Location.seaPhilippine: (BoardArea.map, 1515.0, 1100.0, 2, 2, false, 4.0, 4.0),
    Location.seaCoral: (BoardArea.map, 1665.0, 1342.0, 2, 2, false, 4.0, 4.0),
    Location.regionFrenchNorthAfrica: (BoardArea.map, 402.0, 991.0, 2, 2, false, 0.0, 0.0),
    Location.regionBelgianCongo: (BoardArea.map, 615.0, 1243.0, 1, 1, false, 0.0, 0.0),
    Location.regionSouthAfrica: (BoardArea.map, 692.0, 1421.0, 1, 1, false, 0.0, 0.0),
    Location.regionDutchEastIndies: (BoardArea.map, 1278.0, 1301.0, 1, 1, false, 0.0, 0.0),
    Location.regionBalkans: (BoardArea.map, 698.0, 827.0, 1, 2, false, 0.0, 0.0),
    Location.regionBurmaRoad: (BoardArea.map, 1204.0, 1008.0, 1, 1, false, 0.0, 0.0),
    Location.regionCaucasus: (BoardArea.map, 879.0, 859.0, 1, 2, false, 0.0, 0.0),
    Location.regionFinland: (BoardArea.map, 714.0, 597.0, 1, 1, false, 0.0, 0.0),
    Location.regionFrenchMadagascar: (BoardArea.map, 915.0, 1404.0, 1, 1, false, 0.0, 0.0),
    Location.regionIndia: (BoardArea.map, 1068.0, 1039.0, 1, 1, false, 0.0, 0.0),
    Location.regionItalianEastAfrica: (BoardArea.map, 906.0, 1184.0, 1, 1, false, 0.0, 0.0),
    Location.regionNearEast: (BoardArea.map, 850.0, 1002.0, 1, 2, false, 0.0, 0.0),
    Location.regionSinkiang: (BoardArea.map, 1104.0, 857.0, 1, 1, false, 0.0, 0.0),
    Location.boxAlliedAirBases: (BoardArea.map, 186.0, 619.0, 1, 2, false, 0.0, 0.0),
    Location.boxAttuAndKiska: (BoardArea.map, 1799.5, 728.0, 1, 1, false, 0.0, 0.0),
    Location.boxAvailableConvoys: (BoardArea.map, 394.0, 1542.0, 2, 1, false, 0.0, 0.0),
    Location.boxAxisCommandos: (BoardArea.map, 1074.0, 1496.0, 1, 1, false, 0.0, 0.0),
    Location.boxGermanUboats: (BoardArea.map, 234.0, 1542.0, 2, 1, false, 0.0, 0.0),
    Location.boxHawaii: (BoardArea.map, 2001.0, 947.0, 1, 2, false, 0.0, 3.0),
    Location.boxKureNavalBase: (BoardArea.map, 1511.0, 799.0, 3, 2, false, 4.0, 4.0),
    Location.boxNorway: (BoardArea.map, 590.0, 550.0, 1, 1, false, 0.0, 0.0),
    Location.boxPartisansPool: (BoardArea.map, 1054.0, 620.0, 1, 1, false, 0.0, 0.0),
    Location.boxTito: (BoardArea.map, 1054.0, 705.0, 1, 1, false, 0.0, 0.0),
    Location.boxUSEastCoast: (BoardArea.map, 25.0, 925.0, 2, 2, true, 3.0, 3.0),
    Location.boxGermany: (BoardArea.map, 635.0, 738.0, 1, 1, false, 0.0, 0.0),
    Location.boxJapan: (BoardArea.map, 1490.0, 948.0, 1, 1, false, 0.0, 0.0),
    Location.boxAlliedLeadershipAmerican: (BoardArea.map, 100.0, 1435.0, 1, 1, false, 0.0, 0.0),
    Location.boxAlliedLeadershipBritish: (BoardArea.map, 100.0, 1349.0, 1, 1, false, 0.0, 0.0),
    Location.boxAlliedLeadershipRussian: (BoardArea.map, 100.0, 1521.0, 1, 1, false, 0.0, 0.0),
    Location.boxSovietPolicyNeutral: (BoardArea.map, 1186.0, 629.0, 1, 1, false, 0.0, 0.0),
    Location.boxSovietPolicyWarVsGermany: (BoardArea.map, 1276.0, 629.0, 1, 1, false, 0.0, 0.0),
    Location.boxSovietPolicyWarVJapan: (BoardArea.map, 1366.0, 629.0, 1, 1, false, 0.0, 0.0),
    Location.reservesWestern: (BoardArea.counterTray, 135.0, 185.0, 1, 6, false, 0.0, 10.0),
    Location.reservesEastern: (BoardArea.counterTray, 322.0, 185.0, 1, 6, false, 0.0, 10.0),
    Location.reservesMed: (BoardArea.counterTray, 506.0, 185.0, 1, 6, false, 0.0, 10.0),
    Location.reservesChina: (BoardArea.counterTray, 697.0, 185.0, 1, 6, false, 0.0, 10.0),
    Location.reservesSoutheastAsia: (BoardArea.counterTray, 883.0, 185.0, 1, 5, false, 0.0, 10.0),
    Location.reservesSouthPacific: (BoardArea.counterTray, 1070.0, 185.0, 1, 6, false, 0.0, 10.0),
    Location.trayUnNaval: (BoardArea.counterTray, 77.0, 725.0, 8, 1, false, 10.0, 0.0),
    Location.trayUnCities: (BoardArea.counterTray, 644.0, 725.0, 8, 1, false, 10.0, 0.0),
    Location.trayFrench: (BoardArea.counterTray, 75.0, 840.0, 4, 1, false, 10.0, 0.0),
    Location.trayBlitz: (BoardArea.counterTray, 366.0, 840.0, 4, 1, false, 5.0, 0.0),
    Location.traySiege: (BoardArea.counterTray, 644.0, 840.0, 4, 1, false, 10.0, 0.0),
    Location.trayGermanNavy: (BoardArea.counterTray, 927.0, 840.0, 4, 1, false, 10.0, 0.0),
    Location.trayPartisans: (BoardArea.counterTray, 95.0, 965.0, 3, 1, false, 20.0, 0.0),
    Location.trayItalian: (BoardArea.counterTray, 359.0, 965.0, 4, 1, false, 10.0, 0.0),
    Location.trayPolitical: (BoardArea.counterTray, 646.0, 965.0, 4, 1, false, 10.0, 0.0),
    Location.trayProUnMinors: (BoardArea.counterTray, 929.0, 965.0, 4, 3, false, 8.0, 10.0),
    Location.trayJapaneseGround: (BoardArea.counterTray, 76.0, 1120.0, 6, 1, false, 10.0, 0.0),
    Location.trayGermanGround: (BoardArea.counterTray, 502.0, 1120.0, 6, 1, false, 10.0, 0.0),
    Location.trayJapaneseNavy: (BoardArea.counterTray, 76.0, 1260.0, 6, 1, false, 10.0, 0.0),
    Location.trayMarkers: (BoardArea.counterTray, 90.0, 1380.0, 5, 1, false, 20.0, 0.0),
    Location.trayEconomic: (BoardArea.counterTray, 502.0, 1280.0, 6, 2, false, 10.0, 10.0),
    Location.trayStrategy: (BoardArea.counterTray, 929.0, 1253.0, 4, 1, false, 10.0, 0.0),
    Location.trayProAxisMinors: (BoardArea.counterTray, 927.0, 1380.0, 4, 1, false, 10.0, 0.0),
    Location.trayTurn: (BoardArea.counterTray, 80.0, 620.0, 16, 1, false, 10.0, 0.0),
  };

  void layoutBox(MyAppState appState, Location box) {
    final state = appState.gameState!;
    final info = boxInfos[box]!;
    final boardArea = info.$1;
    double xBox = info.$2;
    double yBox = info.$3;
    int cols = info.$4;
    int rows = info.$5;
    bool rowFirst = info.$6;
    double xGap = info.$7;
    double yGap = info.$8;
    int cells = cols * rows;
    final pieces = state.piecesInLocation(PieceType.all, box);
    int layers = (pieces.length + cells - 1) ~/ cells;
    for (int i = pieces.length - 1; i >= 0; --i) {
      int cell = i % cells;
      int col = cell % cols;
      int row = cell ~/ cols;
      if (rowFirst) {
        int tmp = col;
        col = row;
        row = tmp;
      }
      int depth = i ~/ cells;
      double x = xBox + col * (60.0  + xGap) - (layers - 1) + depth * 2.0;
      double y = yBox + row * (60.0 + yGap) - (layers - 1) + depth * 2.0;
      addPieceToBoard(appState, pieces[i], boardArea, x, y);
    }
  }

  void layoutBoxes(MyAppState appState) {
    for (final location in boxInfos.keys) {
      layoutBox(appState, location);
    }
  }

  void layoutCityBox(MyAppState appState, Location box) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(box);
    double xBox = coordinates.$1;
    double yBox = coordinates.$2;
    int count = 0;
    for (final city in state.piecesInLocation(PieceType.city, box)) {
      int col = count % 6;
      int row = count ~/ 6;
      double x = xBox + col * 60.0;
      double y = yBox + row * 66.0;
      addPieceToBoard(appState, city, BoardArea.map, x, y);
      count += 1;
		}
	}

  void layoutCityBoxes(MyAppState appState) {
    for (final box in LocationType.boxCities.locations) {
      layoutCityBox(appState, box);
    }
  }

  void layoutMilitaryEvent(MyAppState appState) {
    final state = appState.gameState!;
    final location = state.pieceLocation(Piece.militaryEvent);
    if (location.isType(LocationType.event)) {
      final coordinates = locationCoordinates(Location.eventWavell);
      double xFirstEvent = coordinates.$1;
      double yFirstEvent = coordinates.$2;
      int index = location.index - LocationType.event.firstIndex;
      int col = index % 4;
      int row = index ~/ 4;
      final xBox = xFirstEvent + col * 164.0;
      final yBox = yFirstEvent + row * 84.0;
      addPieceToBoard(appState, Piece.militaryEvent, BoardArea.map, xBox, yBox);
    }
  }

  void layoutCalendarBox(MyAppState appState, Location box) {
    final state = appState.gameState!;
    final index = box.index - LocationType.calendar.firstIndex;
    int col = index % 6;
    int row = index ~/ 6;
    final firstRowBox = Location.values[LocationType.calendar.firstIndex + col];
    final coordinates = locationCoordinates(firstRowBox);
    final xBox = coordinates.$1;
    final yBox = coordinates.$2 + row * 65.0;
    final pieces = state.piecesInLocation(PieceType.all, box);
    Piece? turnChit;
    final others = <Piece>[];
    for (final piece in pieces) {
      if (piece.isType(PieceType.turnChit)) {
        turnChit = piece;
      } else {
        others.add(piece);
      }
    }
    if (turnChit != null) {
      addPieceToBoard(appState, turnChit, BoardArea.map, xBox, yBox);
    }
    for (int i = others.length - 1; i >= 0; --i) {
      double x = xBox + 37.0 - (others.length - 1) * 3.0 + i * 6.0;
      addPieceToBoard(appState, others[i], BoardArea.map, x, yBox);
    }
  }

  void layoutCalendar(MyAppState appState) {
    for (final box in LocationType.calendar.locations) {
      layoutCalendarBox(appState, box);
    }
  }

  void layoutOmnibusBox(MyAppState appState, Location box) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(Location.omnibus0);
    double xFirst = coordinates.$1;
    double yFirst = coordinates.$2;
    int col = box.index - LocationType.omnibus.firstIndex;
    double xBox = xFirst + col * 86.8;
    double yBox = yFirst;
    final pieces = state.piecesInLocation(PieceType.all, box);
    for (int i = pieces.length - 1; i >= 0; --i) {
      double x = xBox - (pieces.length - 1) * 3.0 + i * 6.0;
      double y = yBox - (pieces.length - 1) * 3.0 + i * 6.0;
      addPieceToBoard(appState, pieces[i], BoardArea.map, x, y);
    }
  }

  void layoutOmnibus(MyAppState appState) {
    for (final box in LocationType.omnibus.locations) {
      layoutOmnibusBox(appState, box);
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
      layoutSeaZones(appState);
      layoutBoxes(appState);
      layoutCityBoxes(appState);
      layoutMilitaryEvent(appState);
      layoutCalendar(appState);
      layoutOmnibus(appState);
      layoutCalendar(appState);

      const choiceTexts = {
        Choice.axisFailureMaltaSafe: 'Axis Attack fails, Malta safe',
        Choice.axisFailureMaltaBesieged: 'Axis Attack fails, Malta Besieged',
        Choice.axisSuccessMaltaSafe: 'Axis Attack succeeds, Malta safe',
        Choice.axisSuccessMaltaBesieged: 'Axis Attack succeeds, Malta Besieged',
        Choice.scatter: 'Scatter',
        Choice.fight: 'Fight',
        Choice.raiseCannonMeat: 'Raise Soviet Cannon Meat',
        Choice.dollars2: '\$2',
        Choice.dollars1: '\$1',
        Choice.chinaAid: 'US Aid to China',
        Choice.cannonMeat: 'Soviet Cannon Meat',
        Choice.shock: 'Shock Armies',
        Choice.marines: 'Send the Marines',
        Choice.partisanUprising: 'Partisan Uprising',
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

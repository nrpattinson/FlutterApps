import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import 'package:the_white_tribe/game.dart';
import 'package:the_white_tribe/main.dart';

enum BoardArea {
  map,
  track,
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
  static const _trackWidth = 816.0;
  static const _trackHeight = 1056.0;
  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _trackImage = Image.asset('assets/images/track.png', key: UniqueKey(), width: _trackWidth, height: _trackHeight);
  final _mapStackChildren = <Widget>[];
  final _trackStackChildren = <Widget>[];
  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.terrZanu0: 'terr_zanu',
      Piece.terrZanu1: 'terr_zanu',
      Piece.terrZanu2: 'terr_zanu',
      Piece.terrZanu3: 'terr_zanu',
      Piece.terrZanu4: 'terr_zanu',
      Piece.terrZanu5: 'terr_zanu',
      Piece.terrZanu6: 'terr_zanu',
      Piece.terrZanu7: 'terr_zanu',
      Piece.terrZanu8: 'terr_zanu',
      Piece.terrZanu9: 'terr_zanu',
      Piece.terrZanu10: 'terr_zanu',
      Piece.terrZanu11: 'terr_zanu',
      Piece.terrZanu12: 'terr_zanu',
      Piece.terrZanu13: 'terr_zanu',
      Piece.terrZanu14: 'terr_zanu',
      Piece.terrZanu15: 'terr_zanu',
      Piece.terrZapu0: 'terr_zapu',
      Piece.terrZapu1: 'terr_zapu',
      Piece.terrZapu2: 'terr_zapu',
      Piece.terrZapu3: 'terr_zapu',
      Piece.terrZapu4: 'terr_zapu',
      Piece.terrZapu5: 'terr_zapu',
      Piece.terrZapu6: 'terr_zapu',
      Piece.troopieRhodesiaRAR1: 'troopie_rhodesia_rar_1',
      Piece.troopieRhodesiaRAR2: 'troopie_rhodesia_rar_2',
      Piece.troopieRhodesiaRAR3: 'troopie_rhodesia_rar_3',
      Piece.troopieRhodesiaRLI: 'troopie_rhodesia_rli',
      Piece.troopieRhodesiaSelousScouts1: 'troopie_rhodesia_selous_scouts_1',
      Piece.troopieRhodesiaSelousScouts2: 'troopie_rhodesia_selous_scouts_2',
      Piece.troopieRhodesiaSAS: 'troopie_rhodesia_sas',
      Piece.troopieRhodesiaGreysScouts: 'troopie_rhodesia_greys_scouts',
      Piece.troopieRhodesiaBSAP: 'troopie_rhodesia_bsap',
      Piece.troopieRhodesiaGuardForce: 'troopie_rhodesia_guard_force',
      Piece.troopieRhodesiaPfumoReVanhu1: 'troopie_rhodesia_pfumo_re_vanhu_1',
      Piece.troopieRhodesiaPfumoReVanhu2: 'troopie_rhodesia_pfumo_re_vanhi_2',
      Piece.troopieSouthAfricaSAP1: 'troopie_south_africa_sap_1',
      Piece.troopieSouthAfricaSAP2: 'troopie_south_africa_sap_2',
      Piece.troopiePortugalFlechas: 'troopie_portuguese_flechas',
      Piece.troopiePortugalGruposEspecials: 'troopie_portuguese_grupos_especials',
      Piece.troopieRenamo1: 'troopie_renamo_1',
      Piece.troopieRenamo2: 'troopie_renamo_2',
      Piece.terrZanu0Used: 'terr_used',
      Piece.terrZanu1Used: 'terr_used',
      Piece.terrZanu2Used: 'terr_used',
      Piece.terrZanu3Used: 'terr_used',
      Piece.terrZanu4Used: 'terr_used',
      Piece.terrZanu5Used: 'terr_used',
      Piece.terrZanu6Used: 'terr_used',
      Piece.terrZanu7Used: 'terr_used',
      Piece.terrZanu8Used: 'terr_used',
      Piece.terrZanu9Used: 'terr_used',
      Piece.terrZanu10Used: 'terr_used',
      Piece.terrZanu11Used: 'terr_used',
      Piece.terrZanu12Used: 'terr_used',
      Piece.terrZanu13Used: 'terr_used',
      Piece.terrZanu14Used: 'terr_used',
      Piece.terrZanu15Used: 'terr_used',
      Piece.terrZapu0Used: 'terr_used',
      Piece.terrZapu1Used: 'terr_used',
      Piece.terrZapu2Used: 'terr_used',
      Piece.terrZapu3Used: 'terr_used',
      Piece.terrZapu4Used: 'terr_used',
      Piece.terrZapu5Used: 'terr_used',
      Piece.terrZapu6Used: 'terr_used',
      Piece.troopieRhodesiaRAR1Used: 'troopie_rhodesia_used',
      Piece.troopieRhodesiaRAR2Used: 'troopie_rhodesia_used',
      Piece.troopieRhodesiaRAR3Used: 'troopie_rhodesia_used',
      Piece.troopieRhodesiaRLIUsed: 'troopie_rhodesia_used',
      Piece.troopieRhodesiaSelousScouts1Used: 'troopie_rhodesia_used',
      Piece.troopieRhodesiaSelousScouts2Used: 'troopie_rhodesia_used',
      Piece.troopieRhodesiaSASUsed: 'troopie_rhodesia_used',
      Piece.troopieRhodesiaGreysScoutsUsed: 'troopie_rhodesia_used',
      Piece.troopieRhodesiaBSAPUsed: 'troopie_rhodesia_used',
      Piece.troopieRhodesiaGuardForceUsed: 'troopie_rhodesia_used',
      Piece.troopieRhodesiaPfumoReVanhu1Used: 'troopie_rhodesia_used',
      Piece.troopieRhodesiaPfumoReVanhu2Used: 'troopie_rhodesia_used',
      Piece.troopieSouthAfricaSAP1Used: 'troopie_south_africa_used',
      Piece.troopieSouthAfricaSAP2Used: 'troopie_south_africa_used',
      Piece.troopiePortugalFlechasUsed: 'troopie_portuguese_used',
      Piece.troopiePortugalGruposEspecialsUsed: 'troopie_portuguese_used',
      Piece.airForceRhodesia2: 'air_force_rhodesia_2',
      Piece.airForceRhodesia1: 'air_force_rhodesia_1',
      Piece.fortification0: 'fortification',
      Piece.fortification1: 'fortification',
      Piece.fortification2: 'fortification',
      Piece.fortification0UnderConstruction: 'fortification_under_construction',
      Piece.fortification1UnderConstruction: 'fortification_under_construction',
      Piece.fortification2UnderConstruction: 'fortification_under_construction',
      Piece.politicianBlackChitepo: 'politician_black_chitepo',
      Piece.politicianBlackMugabe: 'politician_black_mugabe',
      Piece.politicianBlackSithole: 'politician_black_sithole',
      Piece.politicianBlackMuzorewa: 'politician_black_muzorewa',
      Piece.politicianBlackNkomo: 'politician_black_nkomo',
      Piece.politicianBlackChitepoZanu: 'politician_black_chitepo_zanu',
      Piece.politicianBlackMugabeZanu: 'politician_black_mugabe_zanu',
      Piece.politicianBlackSitholeZanu: 'politician_black_sithole_zanu',
      Piece.politicianBlackMuzorewaUanc: 'politician_black_muzorewa_uanc',
      Piece.politicianBlackNkomoZapu: 'politician_black_nkomo_zapu',
      Piece.politicianZambiaKaunda: 'politician_zambia_kaunda',
      Piece.politicianZambiaCoup: 'politician_zambia_coup',
      Piece.politicianTanzaniaNyerere: 'politician_tanzania_nyerere',
      Piece.politicianTanzaniaCoup: 'politician_tanzania_coup',
      Piece.politicianUsReagan: 'politician_us_reagan',
      Piece.politicianUsCarter: 'politican_us_carter',
      Piece.politicianUsKissinger: 'politician_us_kissinger',
      Piece.policyProvincialCouncils: 'policy_provincial_councils',
      Piece.policyExerciseAlcora: 'policy_exercise_alcora',
      Piece.policyLandTenureAct: 'policy_land_tenure_act',
      Piece.policyProclaimRepublic: 'policy_proclaim_republic',
      Piece.policySpiritMediums: 'policy_spirit_mediums',
      Piece.policyPearceCommission: 'policy_pearce_commission',
      Piece.policyLawAndOrder: 'policy_law_and_order',
      Piece.policyDetente: 'policy_detente',
      Piece.policyCorsan: 'policy_corsan',
      Piece.policyLandTenureAmendment: 'policy_land_tenure_amendment',
      Piece.policyQuenetCommission: 'policy_quenet_commission',
      Piece.policyIntegration: 'policy_integration',
      Piece.policyPfumoReVanhu: 'policy_pfumo_re_vanhu',
      Piece.policyAfricanAdvancement: 'policy_african_advancement',
      Piece.policyExerciseAlcoraEnacted: 'policy_exercise_alcora_enacted',
      Piece.policyProclaimRepublicEnacted: 'policy_proclaim_republic_enacted',
      Piece.policyLawAndOrderEnacted: 'policy_law_and_order_enacted',
      Piece.policyLandTenureAmendmentEnacted: 'policy_land_tenure_amendment_enacted',
      Piece.policyQuenetCommissionEnacted: 'policy_quenet_commission_enacted',
      Piece.policyIntegrationEnacted: 'policy_integration_enacted',
      Piece.policyAfricanAdvancementEnacted: 'policy_african_advancement_enacted',
      Piece.foreignBritainAnti: 'foreign_britain_labour_anti',
      Piece.foreignBritainPro: 'foreign_britain_tories_pro',
      Piece.foreignSouthAfricaAnti: 'foreign_south_africa_verligte_anti',
      Piece.foreignSouthAfricaPro: 'foreign_south_africa_verkrampte_pro',
      Piece.foreignUSAAnti: 'foreign_usa_democrats_anti',
      Piece.foreignUSAPro: 'foreign_use_republican_pro',
      Piece.foreignPortugalTete: 'foreign_portugal',
      Piece.foreignPortugalMocambique: 'foreign_portugal',
      Piece.blackAttitudeFistMidlands: 'black_attitude_fist',
      Piece.blackAttitudeFistMatabeleland: 'black_attitude_fist',
      Piece.blackAttitudeFistMashonaLand: 'black_attitude_fist',
      Piece.blackAttitudeFistManicaLand: 'black_attitude_fist',
      Piece.blackAttitudeFistVictoria: 'black_attitude_fist',
      Piece.blackAttitudeHandshakeMidlands: 'black_attitude_handshake',
      Piece.blackAttitudeHandshakeMatabeleland: 'black_attitude_handshake',
      Piece.blackAttitudeHandshakeMashonaland: 'black_attitude_handshake',
      Piece.blackAttitudeHandshakeManicaland: 'black_attitude_handshake',
      Piece.blackAttitudeHandshakeVictoria: 'black_attitude_handshake',
      Piece.markerSanctions: 'marker_sanctions',
      Piece.markerPortBeira: 'marker_port_beira',
      Piece.markerTanZamRailway: 'marker_tan_zam_railway',
      Piece.markerFico: 'marker_fico',
      Piece.markerTreasury: 'marker_treasury',
      Piece.markerTerrorLevel: 'marker_terror',
      Piece.markerGameTurn: 'marker_turn',
      Piece.markerHouseOfAssembly: 'marker_assembly',
      Piece.markerRhodesianFrontPopularity: 'marker_rhodesian_front_popularity',
      Piece.markerPopulationUp: 'marker_population_up',
      Piece.markerPopulationDown: 'marker_population_down',
      Piece.markerRhodesianElection: 'marker_rhodesian_election',
      Piece.markerBritishRule: 'marker_botswana_british_rule',
      Piece.markerBritishElection: 'marker_british_election',
      Piece.markerRepublicOfRhodesia: 'marker_rhodesia_republic',
      Piece.markerZimbabweRhodesia: 'marker_rhodesia_zimbabwe',
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
    case BoardArea.track:
      _trackStackChildren.add(widget);
    }
  }

/*
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
*/

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.provinceMidlands: (BoardArea.map, 570.0, 490.0),
      Location.provinceMatabeleland: (BoardArea.map, 210.0, 470.0),
      Location.provinceMashonaland: (BoardArea.map, 660.0, 150.0),
      Location.provinceManicaland: (BoardArea.map, 900.0, 400.0),
      Location.provinceVictoria: (BoardArea.map, 770.0, 650.0),
      Location.salisbury: (BoardArea.map, 713.0, 356.0),
      Location.boxAirForceBase: (BoardArea.map, 897.0, 305.0),
      Location.boxWhaWhaPrison: (BoardArea.map, 647.0, 660.0),
      Location.regionZambia: (BoardArea.map, 230.0, 170.0),
      Location.regionTete: (BoardArea.map, 0.0, 0.0),
      Location.regionMocambique: (BoardArea.map, 1195.0, 400.0),
      Location.regionSouthAfrica: (BoardArea.map, 0.0, 0.0),
      Location.regionBotswana: (BoardArea.map, 0.0, 0.0),
      Location.frontLineZambia: (BoardArea.map, 123.0, 168.5),
      Location.frontLineTete: (BoardArea.map, 1268.0, 34.0),
      Location.frontLineMocambique: (BoardArea.map, 1167.0, 808.0),
      Location.frontLineBotswana: (BoardArea.map, 85.0, 552.0),
      Location.frontLineTanzania: (BoardArea.map, 1350.0, 285.0),
      Location.boxZambianTrade: (BoardArea.map, 440.0, 60.0),
      Location.boxGlobalTrade: (BoardArea.map, 0.0, 0.0),
      Location.boxUKGovernment: (BoardArea.map, 1350.0, 400.0),
      Location.boxUSAGovernment: (BoardArea.map, 1350.0, 505.0),
      Location.boxSouthAfricaGovernment: (BoardArea.map, 1350.0, 610.0),
      Location.terror1: (BoardArea.map, 1472.0, 844.0),
      Location.turn0: (BoardArea.track, 112.0, 130.0),
      Location.popularityN4: (BoardArea.track, 336.0, 925.0),
      Location.houseOfAssembly2: (BoardArea.track, 676.0, 693.0),
      Location.poolForce: (BoardArea.map, 49.0, 810.0),
    };
    return coordinates[location]!;
  }

  void layoutBoxes(MyAppState appState) {
    const boxesInfo = {
      Location.provinceMidlands: (2, 1, 15.0, 0.0),
      Location.provinceMatabeleland: (2, 1, 15.0, 0.0),
      Location.provinceMashonaland: (2, 1, 15.0, 0.0),
      Location.provinceManicaland: (2, 1, 15.0, 0.0),
      Location.provinceVictoria: (2, 1, 15.0, 0.0),
      Location.salisbury: (1, 1, 0.0, 0.0),
      Location.boxAirForceBase: (1, 1, 0.0, 0.0),
      Location.boxWhaWhaPrison: (1, 1, 0.0, 0.0),
      Location.regionZambia: (1, 1, 0.0, 0.0),
      Location.regionTete: (1, 1, 0.0, 0.0),
      Location.regionMocambique: (1, 1, 0.0, 0.0),
      Location.regionSouthAfrica: (1, 1, 0.0, 0.0),
      Location.regionBotswana: (1, 1, 0.0, 0.0),
      Location.frontLineZambia: (1, 1, 0.0, 0.0),
      Location.frontLineTete: (1, 1, 0.0, 0.0),
      Location.frontLineMocambique: (1, 1, 0.0, 0.0),
      Location.frontLineBotswana: (1, 1, 0.0, 0.0),
      Location.frontLineTanzania: (1, 1, 0.0, 0.0),
      Location.boxZambianTrade: (1, 1, 0.0, 0.0),
      Location.boxGlobalTrade: (1, 1, 0.0, 0.0),
      Location.boxUKGovernment: (1, 1, 0.0, 0.0),
      Location.boxUSAGovernment: (1, 1, 0.0, 0.0),
      Location.boxSouthAfricaGovernment: (1, 1, 0.0, 0.0),
      Location.poolForce: (4, 3, 4.0, 10.0),
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

  void layoutTerrorTrack(MyAppState appState) {
    final state = appState.gameState!;

    final firstBoxCoordinates = locationCoordinates(Location.terror1);
    final xBox = firstBoxCoordinates.$2;
    final yFirst = firstBoxCoordinates.$3;
    final box = state.pieceLocation(Piece.markerTerrorLevel);
    int index = box.index - Location.terror1.index;
    final yBox = yFirst - index * 100.0;
    addPieceToBoard(appState, Piece.markerTerrorLevel, BoardArea.map, xBox, yBox);
  }

  void layoutTurnTrack(MyAppState appState) {
    final state = appState.gameState!;

    final firstBoxCoordinates = locationCoordinates(Location.turn0);
    final xFirst = firstBoxCoordinates.$2;
    final yFirst = firstBoxCoordinates.$3;
    for (final box in LocationType.turn.locations) {
      int index = box.index - LocationType.turn.firstIndex;
      int row = index ~/ 4;
      int col = index % 4;
      final xBox = xFirst + 167.0 * col;
      final yBox = yFirst + 79.5 * row;
      final pieces = state.piecesInLocation(PieceType.all, box);
      for (int i = 0; i < pieces.length; ++i) {
        int slot = i % 2;
        int depth = i ~/ 2;
        final xSlot = xBox + 65.0 * slot;
        addPieceToBoard(appState, pieces[i], BoardArea.track, xSlot + 4.0 * depth, yBox + 4.0 * depth);
      }
    }
  }

  void layoutHouseOfAssembly(MyAppState appState) {
    final state = appState.gameState!;

    final firstBoxCoordinates = locationCoordinates(Location.houseOfAssembly2);
    final xFirst = firstBoxCoordinates.$2;
    final yFirst = firstBoxCoordinates.$3;
    final box = state.pieceLocation(Piece.markerHouseOfAssembly);
    int index = box.index - Location.houseOfAssembly2.index;
    int col = index % 4;
    int row = index ~/ 4;
    final xBox = xFirst - col * 103.0;
    final yBox = yFirst - row * 124.0;
    addPieceToBoard(appState, Piece.markerHouseOfAssembly, BoardArea.track, xBox, yBox);
  }

  void layoutPopularity(MyAppState appState) {
    final state = appState.gameState!;

    final firstBoxCoordinates = locationCoordinates(Location.popularityN4);
    final xFirst = firstBoxCoordinates.$2;
    final yFirst = firstBoxCoordinates.$3;
    final box = state.pieceLocation(Piece.markerRhodesianFrontPopularity);
    int index = box.index - Location.popularityN4.index;
    int col = index < 5 ? index : 9 - index;
    int row = index ~/ 5;
    final xBox = xFirst + col * 83.6;
    final yBox = yFirst - row * 92.0;
    addPieceToBoard(appState, Piece.markerRhodesianFrontPopularity, BoardArea.track, xBox, yBox);
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
    _trackStackChildren.clear();
    _trackStackChildren.add(_trackImage);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutBoxes(appState);
      layoutTerrorTrack(appState);
      layoutTurnTrack(appState);
      layoutHouseOfAssembly(appState);
      layoutPopularity(appState);

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
                  width: _mapWidth + _trackWidth,
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
                        child: Stack(children: _trackStackChildren),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 400.0,
            height: _mapWidth,
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

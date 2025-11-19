import 'package:flutter/material.dart';
import 'package:mrs_thatchers_war/game.dart';
import 'package:mrs_thatchers_war/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

enum BoardArea {
  strategicMap,
  tacticalMap,
}

class GamePage extends StatelessWidget {
  static const _strategicMapWidth = 816.0;
  static const _strategicMapHeight = 1056.0;
  static const _tacticalMapWidth = 1632.0;
  static const _tacticalMapHeight = 1056.0;
  final _counters = <Piece,Image>{};
  final _strategicMapImage = Image.asset('assets/images/strategic_map.png', key: UniqueKey(), width: _strategicMapWidth, height: _strategicMapHeight);
  final _tacticalMapImage = Image.asset('assets/images/tactical_map.png', key: UniqueKey(), width: _tacticalMapWidth, height: _tacticalMapHeight);
  final _strategicMapStackChildren = <Widget>[];
  final _tacticalMapStackChildren = <Widget>[];

  GamePage({super.key}) {

    final Map<Piece,String> counterNames = {
      Piece.airArgA4_0: 'air_arg_a4_elite',
      Piece.airArgA4_1: 'air_arg_a4',
      Piece.airArgA4_2: 'air_arg_a4',
      Piece.airArgA4_3: 'air_arg_a4',
      Piece.airArgA4_4: 'air_arg_a4',
      Piece.airArgAM_0: 'air_arg_am',
      Piece.airArgCB_0: 'air_arg_cb',
      Piece.airArgDG_0: 'air_arg_dg_donadille',
      Piece.airArgDG_1: 'air_arg_dg_elite',
      Piece.airArgDG_2: 'air_arg_dg_elite',
      Piece.airArgDG_3: 'air_arg_dg',
      Piece.airArgDG_4: 'air_arg_dg',
      Piece.airArgDM_0: 'air_arg_dm_elite',
      Piece.airArgDM_1: 'air_arg_dm_elite',
      Piece.airArgDM_2: 'air_arg_dm',
      Piece.airArgSE_0: 'air_arg_se',
      Piece.airGbrHH_0: 'air_gbr_hh_morgan',
      Piece.airGbrHH_1: 'air_gbr_hh',
      Piece.airGbrHH_2: 'air_gbr_hh',
      Piece.airGbrHH_3: 'air_gbr_hh',
      Piece.airGbrHH_4: 'air_gbr_hh',
      Piece.airGbrHH_5: 'air_gbr_hh',
      Piece.airGbrHH_6: 'air_gbr_hh',
      Piece.airGbrHH_7: 'air_gbr_hh',
      Piece.airGbrHH_8: 'air_gbr_hh',
      Piece.airGbrHI_0: 'air_gbr_hi_ward',
      Piece.airGbrHI_1: 'air_gbr_hi',
      Piece.airGbrHI_2: 'air_gbr_hi',
      Piece.airGbrHI_3: 'air_gbr_hi',
      Piece.airGbrHI_4: 'air_gbr_hi',
      Piece.airGbrHI_5: 'air_gbr_hi',
      Piece.airGbrHI_6: 'air_gbr_hi',
      Piece.airGbrHI_7: 'air_gbr_hi',
      Piece.navalArgGrupo1: 'naval_arg_grupo_1',
      Piece.navalArgGrupo2: 'naval_arg_grupo_2',
      Piece.navalArgGrupo3: 'naval_arg_grupo_3',
      Piece.navalArgGrupo4: 'naval_arg_grupo_4',
      Piece.navalArgGrupo5: 'naval_arg_grupo_5',
      Piece.navalArgGrupo6: 'naval_arg_grupo_6',
      Piece.navalArgGrupo7: 'naval_arg_grupo_7',
      Piece.navalArgGrupo8: 'naval_arg_grupo_8',
      Piece.navalArgGrupo9: 'naval_arg_grupo_9',
      Piece.navalArgGrupo10: 'naval_arg_grupo_10',
      Piece.navalArgBelgrano: 'naval_arg_belgrano',
      Piece.navalArg25DeMayo: 'naval_arg_25_de_mayo',
      Piece.navalGbrHermes: 'naval_gbr_hermes',
      Piece.navalGbrInvincible: 'naval_gbr_invincible',
      Piece.navalGbrIwoJima: 'naval_gbr_iwo_jima',
      Piece.navalGbrEscorts0: 'naval_gbr_escorts',
      Piece.navalGbrEscorts1: 'naval_gbr_escorts',
      Piece.navalGbrStuft: 'naval_gbr_stuft',
      Piece.groundArgFTMerc: 'ground_arg_ft_merc',
      Piece.groundArgRI7: 'ground_arg_ri_7',
      Piece.groundArgECSolari: 'ground_arg_ec_solari',
      Piece.groundArgRI4: 'ground_arg_ri_4',
      Piece.groundArgBIM5: 'ground_arg_bim_5',
      Piece.groundArgCdo602: 'ground_arg_cdo_602',
      Piece.groundArgPU0: 'ground_arg_pu',
      Piece.groundArgPU1: 'ground_arg_pu',
      Piece.groundArgMineField: 'ground_arg_mine_field',
      Piece.groundArgPatrol0: 'ground_arg_patrol',
      Piece.groundArgPatrol1: 'ground_arg_patrol',
      Piece.groundArgPatrol2: 'ground_arg_patrol',
      Piece.groundArgECSolariBack: 'ground_arg_white_star',
      Piece.groundArgCdo602Back: 'ground_arg_white_star',
      Piece.groundArgMineFieldBack: 'ground_arg_white_star',
      Piece.groundArgPatrol0Back: 'ground_arg_white_star',
      Piece.groundArgPatrol1Back: 'ground_arg_white_star',
      Piece.groundArgPatrol2Back: 'ground_arg_white_star',
      Piece.groundGbr45Cdo: 'ground_gbr_45_cdo',
      Piece.groundGbrGurkhas: 'ground_gbr_gurkhas',
      Piece.groundGbrScotsGds: 'ground_gbr_scots_gds',
      Piece.groundGbrWelshGds: 'ground_gbr_welsh_gds',
      Piece.groundGbr2Para: 'ground_gbr_2_para',
      Piece.groundGbr3Para: 'ground_gbr_3_para',
      Piece.groundGbr40Cdo: 'ground_gbr_40_cdo',
      Piece.groundGbr42Cdo: 'ground_gbr_42_cdo',
      Piece.groundGbrSAS: 'ground_gbr_sas',
      Piece.groundGbrBR: 'ground_gbr_br',
      Piece.groundGbrRA: 'ground_gbr_ra',
      Piece.groundGbrKLF: 'ground_gbr_klf',
      Piece.groundGbrHeli0: 'ground_gbr_heli',
      Piece.groundGbrHeli1: 'ground_gbr_heli',
      Piece.groundGbrHeli2: 'ground_gbr_heli',
      Piece.groundGbr45CdoOutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbrGurkhasOutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbrScotsGdsOutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbrWelshGdsOutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbr2ParaOutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbr3ParaOutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbr40CdoOutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbr42CdoOutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbrSASOutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbrBROutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbrRAOutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbrKLFOutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbrHeli0OutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbrHeli1OutOfSupply: 'ground_gbr_out_of_supply',
      Piece.groundGbrHeli2OutOfSupply: 'ground_gbr_out_of_supply',
      Piece.markerTurn: 'marker_turn',
      Piece.markerBBCNews: 'marker_bbc_news',
      Piece.markerExocet: 'marker_exocet',
      Piece.markerPope: 'marker_pope',
      Piece.markerChileanRadar: 'marker_chilean_radar',
      Piece.markerDiplomacy: 'marker_diplomacy',
      Piece.markerTargetAirSector: 'marker_target_air_sector',
      Piece.markerWeather: 'marker_weather',
      Piece.markerWeatherNoAir: 'marker_no_air',
      Piece.markerGroundSupportArg: 'marker_ground_support_arg',
      Piece.markerGroundSupportGbr: 'marker_ground_support_gbr',
    };

    for (final counterName in counterNames.entries) {
      final imagePath = 'assets/images/${counterName.value}.png';
      _counters[counterName.key] = Image.asset(imagePath,
        key: UniqueKey(),
        width: 60.0, height:60.0,
      );
    }
  }

  Image pieceImage(Piece piece) {
    return _counters[piece]!;
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
    case BoardArea.strategicMap:
      _strategicMapStackChildren.add(widget);
    case BoardArea.tacticalMap:
      _tacticalMapStackChildren.add(widget);
    }
  }

  void addCampToMap(MyAppState appState, Location camp, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(camp);
    bool selected = playerChoices.selectedLocations.contains(camp);

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
            appState.choseLocation(camp);
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

    _tacticalMapStackChildren.add(widget);
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.campCerroMontevideo: (BoardArea.tacticalMap, 234.0, 133.0),
      Location.campNewHouse: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campLetterboxHill: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campDouglasStation: (BoardArea.tacticalMap, 538.0, 29.0),
      Location.campChataRincon: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campTealInlet: (BoardArea.tacticalMap, 746.0, 156.0),
      Location.campEstanciaHouse: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campMountEstancia: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campMurrellBridge: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campMountLongdon: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campWirelessRidge: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campVerdeHills: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campThirdCorralEast: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campBambillaHill: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campOutsideChata: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campMountSimon: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campTopMaloHouse: (BoardArea.tacticalMap, 798.0, 270.0),
      Location.campCentreBrook: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campLowerMalo: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campMountKent: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campTwoSisters: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campTumbledown: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campSussexMountains: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campPortSussex: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campCamillaCreekHouse: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campDarwin: (BoardArea.tacticalMap, 383.0, 732.0),
      Location.campGooseGreen: (BoardArea.tacticalMap, 372.0, 849.0),
      Location.campTealCreek: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campBluffCreek: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campMidRancho: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campSwanInletHouse: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campMountPleasant: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campFitzroy: (BoardArea.tacticalMap, 1018.0, 486.0),
      Location.campBluffCove: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campMountHarriet: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.campMountWilliam: (BoardArea.tacticalMap, 0.0, 0.0),
      Location.stanley: (BoardArea.tacticalMap, 1413.0, 122.0),
      Location.airstripPebbleIsland: (BoardArea.tacticalMap, 44.0, 37.0),
      Location.airstripGooseGreen: (BoardArea.tacticalMap, 486.0, 860.0),
      Location.groundSupportArg0: (BoardArea.strategicMap, 633.0, 696.0),
      Location.groundSupportGbr0: (BoardArea.strategicMap, 709.0, 696.0),
      Location.argentineMainland: (BoardArea.strategicMap, 28.0, 151.0),
      Location.seaZoneCommodoroRivadavia: (BoardArea.strategicMap, 0.0, 0.0),
      Location.seaZonePuertoDeseado: (BoardArea.strategicMap, 0.0, 0.0),
      Location.seaZoneSanJulian: (BoardArea.strategicMap, 50.0, 565.0),
      Location.seaZoneSantaCruz: (BoardArea.strategicMap, 20.0, 638.0),
      Location.seaZoneRioGallegos: (BoardArea.strategicMap, 15.0, 740.0),
      Location.seaZoneRioGrande: (BoardArea.strategicMap, 80.0, 885.0),
      Location.ascensionIsland: (BoardArea.strategicMap, 559.0, 165.0),
      Location.falklandIslandsTotalExclusionZone: (BoardArea.strategicMap, 287.0, 649.0),
      Location.weatherFog: (BoardArea.strategicMap, 0.0, 0.0),
      Location.weatherFair: (BoardArea.strategicMap, 368.0, 178.0),
      Location.weatherRainSnow: (BoardArea.strategicMap, 0.0, 0.0),
      Location.weatherSqualls: (BoardArea.strategicMap, 0.0, 0.0),
      Location.weatherGales: (BoardArea.strategicMap, 0.0, 0.0),
      Location.turn0: (BoardArea.tacticalMap, 36.0, 882.0),
    };
    return coordinates[location]!;
  }

  void layoutCamp(MyAppState appState, Location camp) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(camp);
    final xCamp = coordinates.$2;
    final yCamp = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(camp)) {
      addCampToMap(appState, camp, xCamp, yCamp);
    }

    final pieces = state.piecesInLocation(PieceType.ground, camp);
    for (int i = 0; i < pieces.length; ++i) {
      addPieceToBoard(appState, pieces[i], BoardArea.tacticalMap, xCamp + 4.0 * i, yCamp + 4.0 * i);
    }
 
    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(camp)) {
      addCampToMap(appState, camp, xCamp, yCamp);
    }
  }

  void layoutCamps(MyAppState appState) {
    for (final camp in LocationType.camp.locations) {
      layoutCamp(appState, camp);
    }
  }

  void layoutBoxes(MyAppState appState) {
    const boxesInfo = {
      Location.stanley: (3, 1, 3.0, 0.0),
      Location.airstripPebbleIsland: (1, 1, 0.0, 0.0),
      Location.airstripGooseGreen: (1, 1, 0.0, 0.0),
      Location.argentineMainland: (3, 2, 10.0, 10.0),
      Location.seaZoneCommodoroRivadavia: (1, 1, 0.0, 0.0),
      Location.seaZonePuertoDeseado: (1, 1, 0.0, 0.0),
      Location.seaZoneSanJulian: (1, 1, 0.0, 0.0),
      Location.seaZoneSantaCruz: (1, 1, 0.0, 0.0),
      Location.seaZoneRioGallegos: (1, 1, 0.0, 0.0),
      Location.seaZoneRioGrande: (1, 1, 0.0, 0.0),
      Location.ascensionIsland: (3, 3, 5.0, 5.0),
      Location.falklandIslandsTotalExclusionZone: (4, 4, 5.0, 5.0),
      Location.weatherFog: (1, 1, 0.0, 0.0),
      Location.weatherFair: (1, 1, 0.0, 0.0),
      Location.weatherRainSnow: (1, 1, 0.0, 0.0),
      Location.weatherSqualls: (1, 1, 0.0, 0.0),
      Location.weatherGales: (1, 1, 0.0, 0.0),
    };

    final state = appState.gameState!;
    for (final box in boxesInfo.keys) {
      final coordinates = locationCoordinates(box);
      final boardArea  = coordinates.$1;
      double xBox = coordinates.$2;
      double yBox = coordinates.$3;

      //if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(box)) {
      //  addBoxToMap(appState, box, xBox, yBox);
      //}

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
        double x = xBox + col * (60.0 + xGap);
        double y = yBox + row * (60.0 + yGap);
        x += depth * 10.0;
        y += depth * 10.0;
        addPieceToBoard(appState, pieces[i], boardArea, x, y);
      }

      //if (appState.playerChoices != null && appState.playerChoices!.locations.contains(box)) {
      //  addBoxToMap(appState, box, xBox, yBox);
      //}
    }
  }

  void layoutGroundSupportTrack(MyAppState appState, Piece marker, Location firstBox) {
    final state = appState.gameState!;

    final firstBoxCoordinates = locationCoordinates(firstBox);
    final xBox = firstBoxCoordinates.$2;
    final yFirst = firstBoxCoordinates.$3;
    final location = state.pieceLocation(marker);
    int index = location.index - firstBox.index;
    final yBox = yFirst - index * 76.0;
    addPieceToBoard(appState, marker, BoardArea.strategicMap, xBox, yBox);
  }

  void layoutTurnTrack(MyAppState appState) {
    final state = appState.gameState!;

    final firstBoxCoordinates = locationCoordinates(Location.turn0);
    final xFirst = firstBoxCoordinates.$2;
    final yFirst = firstBoxCoordinates.$3;
    for (final box in LocationType.turn.locations) {
      int index = box.index - LocationType.turn.firstIndex;
      int col = index == 0 ? 0 : index - 1;
      int row = index == 0 ? 0 : 1;
      final xBox = xFirst + 83.7 * col;
      final yBox = yFirst + 83.7* row;
      final pieces = state.piecesInLocation(PieceType.all, box);
      for (int i = 0; i < pieces.length; ++i) {
        addPieceToBoard(appState, pieces[i], BoardArea.tacticalMap, xBox + 4.0 * i, yBox + 4.0 * i);
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

    _strategicMapStackChildren.clear();
    _strategicMapStackChildren.add(_strategicMapImage);
    _tacticalMapStackChildren.clear();
    _tacticalMapStackChildren.add(_tacticalMapImage);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutCamps(appState);
      layoutBoxes(appState);
      layoutGroundSupportTrack(appState, Piece.markerGroundSupportArg, Location.groundSupportArg0);
      layoutGroundSupportTrack(appState, Piece.markerGroundSupportGbr, Location.groundSupportGbr0);
      layoutTurnTrack(appState);

      const choiceTexts = {
        Choice.sasRaidOperationMikado: 'Operation Mikado',
        Choice.sasRaidSpoofing: 'Spoofing',
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
                  width: _strategicMapWidth + _tacticalMapWidth,
                  height: _strategicMapHeight,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0.0,
                        top: 0.0,
                        child: Stack(children: _strategicMapStackChildren),
                      ),
                      Positioned(
                        left: _strategicMapWidth,
                        top: 0.0,
                        child: Stack(children: _tacticalMapStackChildren),
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
                controller: appState.logScrollController,
                data: log,
              ),
            ),
          ),
        ],
      ),
    );

    if (appState.logScrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appState.logScrollController.jumpTo(appState.logScrollController.position.maxScrollExtent);
      });
    }

    return rootWidget;
  }
}

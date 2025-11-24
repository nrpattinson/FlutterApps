import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charlemagne/game.dart';
import 'package:charlemagne/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
  static const _mapWidth = 2112.0;
  static const _mapHeight = 1632.0;

  final _displayOptionsFormKey = GlobalKey<FormState>();
 
  bool _emptyMap = false;

  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _mapStackChildren = <Widget>[];

  final _pieceStackKeys = <Piece,StackKey>{};
  final _expandedStacks = <StackKey>[];

  final _logScrollController = ScrollController();

  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.poitiers0: 'map_unit_poitiers_3',
      Piece.poitiers1: 'map_unit_poitiers_3',
      Piece.poitiers2: 'map_unit_poitiers_3',
      Piece.poitiers3: 'map_unit_poitiers_4',
      Piece.poitiers4: 'map_unit_poitiers_4',
      Piece.bordeaux0: 'map_unit_bordeaux_4',
      Piece.bordeaux1: 'map_unit_bordeaux_4',
      Piece.bordeaux2: 'map_unit_bordeaux_4',
      Piece.bordeaux3: 'map_unit_bordeaux_5',
      Piece.bordeaux4: 'map_unit_bordeaux_5',
      Piece.gascony0: 'map_unit_gascony_5',
      Piece.gascony1: 'map_unit_gascony_5',
      Piece.gascony2: 'map_unit_gascony_5',
      Piece.gascony3: 'map_unit_gascony_5',
      Piece.gascony4: 'map_unit_gascony_5',
      Piece.gascony5: 'map_unit_gascony_5',
      Piece.lombardy0: 'map_unit_lombardy_4',
      Piece.lombardy1: 'map_unit_lombardy_4',
      Piece.lombardy2: 'map_unit_lombardy_5',
      Piece.lombardy3: 'map_unit_lombardy_5',
      Piece.lombardy4: 'map_unit_lombardy_5',
      Piece.friuli0: 'map_unit_friuli_4',
      Piece.friuli1: 'map_unit_friuli_4',
      Piece.friuli2: 'map_unit_friuli_5',
      Piece.friuli3: 'map_unit_friuli_5',
      Piece.bavaria0: 'map_unit_bavaria_4',
      Piece.bavaria1: 'map_unit_bavaria_4',
      Piece.bavaria2: 'map_unit_bavaria_5',
      Piece.bavaria3: 'map_unit_bavaria_6',
      Piece.fulda0: 'map_unit_fulda_3',
      Piece.fulda1: 'map_unit_fulda_3',
      Piece.swabia0: 'map_unit_swabia_3',
      Piece.swabia1: 'map_unit_swabia_3',
      Piece.swabia2: 'map_unit_swabia_4',
      Piece.provence0: 'map_unit_province_3',
      Piece.provence1: 'map_unit_province_4',
      Piece.provence2: 'map_unit_province_4',
      Piece.burgundy0: 'map_unit_burgundy_3',
      Piece.burgundy1: 'map_unit_burgundy_3',
      Piece.burgundy2: 'map_unit_burgundy_4',
      Piece.burgundy3: 'map_unit_burgundy_4',
      Piece.carinthia0: 'map_unit_carinthia_3',
      Piece.carinthia1: 'map_unit_carinthia_4',
      Piece.carinthia2: 'map_unit_carinthia_5',
      Piece.carinthia3: 'map_unit_carinthia_5',
      Piece.croats0: 'map_unit_croats_4',
      Piece.croats1: 'map_unit_croats_4',
      Piece.croats2: 'map_unit_croats_5',
      Piece.croats3: 'map_unit_croats_5',
      Piece.moravia0: 'map_unit_moravia_5',
      Piece.moravia1: 'map_unit_moravia_5',
      Piece.moravia2: 'map_unit_moravia_6',
      Piece.moravia3: 'map_unit_moravia_6',
      Piece.avars0: 'map_unit_avars_5',
      Piece.avars1: 'map_unit_avars_6',
      Piece.avars2: 'map_unit_avars_6',
      Piece.avars3: 'map_unit_avars_6',
      Piece.saxonsI0: 'map_unit_saxons1_6',
      Piece.saxonsI1: 'map_unit_saxons1_6',
      Piece.saxonsI2: 'map_unit_saxons1_6',
      Piece.saxonsI3: 'map_unit_saxons1_6',
      Piece.saxonsI4: 'map_unit_saxons1_7',
      Piece.saxonsI5: 'map_unit_saxons1_7',
      Piece.saxonsII0: 'map_unit_saxons2_6',
      Piece.saxonsII1: 'map_unit_saxons2_6',
      Piece.saxonsII2: 'map_unit_saxons2_6',
      Piece.saxonsII3: 'map_unit_saxons2_7',
      Piece.saxonsII4: 'map_unit_saxons2_7',
      Piece.saxonsII5: 'map_unit_saxons2_7',
      Piece.veleti0: 'map_unit_veleti_5',
      Piece.veleti1: 'map_unit_veleti_5',
      Piece.veleti2: 'map_unit_veleti_6',
      Piece.veleti3: 'map_unit_veleti_6',
      Piece.paris0: 'map_unit_paris_4',
      Piece.paris1: 'map_unit_paris_5',
      Piece.reims0: 'map_unit_reims_3',
      Piece.reims1: 'map_unit_reims_4',
      Piece.breton0: 'map_unit_breton_4',
      Piece.breton1: 'map_unit_breton_4',
      Piece.breton2: 'map_unit_breton_5',
      Piece.breton3: 'map_unit_breton_5',
      Piece.leaderPoitiers0: 'leader_poitiers_1',
      Piece.leaderPoitiers1: 'leader_poitiers_1',
      Piece.leaderPoitiers2: 'leader_poitiers_1',
      Piece.leaderPoitiers3: 'leader_poitiers_2',
      Piece.leaderPoitiers4: 'leader_poitiers_2',
      Piece.leaderBordeaux0: 'leader_bordeaux_1',
      Piece.leaderBordeaux1: 'leader_bordeaux_1',
      Piece.leaderBordeaux2: 'leader_bordeaux_1',
      Piece.leaderBordeaux3: 'leader_bordeaux_2',
      Piece.leaderBordeaux4: 'leader_bordeaux_2',
      Piece.leaderGascony0: 'leader_gascony_1',
      Piece.leaderGascony1: 'leader_gascony_1',
      Piece.leaderGascony2: 'leader_gascony_1',
      Piece.leaderGascony3: 'leader_gascony_2',
      Piece.leaderGascony4: 'leader_gascony_2',
      Piece.leaderGascony5: 'leader_gascony_2',
      Piece.leaderLombardy0: 'leader_lombardy_1',
      Piece.leaderLombardy1: 'leader_lombardy_1',
      Piece.leaderLombardy2: 'leader_lombardy_1',
      Piece.leaderLombardy3: 'leader_lombardy_1',
      Piece.leaderLombardy4: 'leader_lombardy_1',
      Piece.leaderLombardy5: 'leader_lombardy_3',
      Piece.leaderFriuli0: 'leader_friuli_1',
      Piece.leaderFriuli1: 'leader_friuli_1',
      Piece.leaderFriuli2: 'leader_friuli_2',
      Piece.leaderFriuli3: 'leader_friuli_2',
      Piece.leaderBavaria0: 'leader_bavaria_1',
      Piece.leaderBavaria1: 'leader_bavaria_1',
      Piece.leaderBavaria2: 'leader_bavaria_2',
      Piece.leaderBavaria3: 'leader_bavaria_2',
      Piece.leaderBurgundy0: 'leader_burgundy_1',
      Piece.leaderBurgundy1: 'leader_burgundy_1',
      Piece.leaderBurgundy2: 'leader_burgundy_2',
      Piece.leaderBurgundy3: 'leader_burgundy_2',
      Piece.leaderCarinthia0: 'leader_carinthia_1',
      Piece.leaderCarinthia1: 'leader_carinthia_1',
      Piece.leaderCarinthia2: 'leader_carinthia_1',
      Piece.leaderCarinthia3: 'leader_carinthia_1',
      Piece.leaderCroats0: 'leader_croats_1',
      Piece.leaderCroats1: 'leader_croats_1',
      Piece.leaderCroats2: 'leader_croats_1',
      Piece.leaderCroats3: 'leader_croats_1',
      Piece.leaderMoravia0: 'leader_moravia_1',
      Piece.leaderMoravia1: 'leader_moravia_1',
      Piece.leaderMoravia2: 'leader_moravia_2',
      Piece.leaderMoravia3: 'leader_moravia_2',
      Piece.leaderAvars0: 'leader_avars_1',
      Piece.leaderAvars1: 'leader_avars_2',
      Piece.leaderAvars2: 'leader_avars_2',
      Piece.leaderAvars3: 'leader_avars_2',
      Piece.leaderSaxonsI0: 'leader_saxons1_2',
      Piece.leaderSaxonsI1: 'leader_saxons1_2',
      Piece.leaderSaxonsI2: 'leader_saxons1_2',
      Piece.leaderSaxonsI3: 'leader_saxons1_2',
      Piece.leaderSaxonsI4: 'leader_saxons1_3',
      Piece.leaderSaxonsI5: 'leader_saxons1_3',
      Piece.leaderSaxonsII0: 'leader_saxons2_2',
      Piece.leaderSaxonsII1: 'leader_saxons2_2',
      Piece.leaderSaxonsII2: 'leader_saxons2_2',
      Piece.leaderSaxonsII3: 'leader_saxons2_2',
      Piece.leaderSaxonsII4: 'leader_saxons2_3',
      Piece.leaderSaxonsII5: 'leader_saxons2_3',
      Piece.leaderVeleti0: 'leader_veleti_1',
      Piece.leaderVeleti1: 'leader_veleti_1',
      Piece.leaderVeleti2: 'leader_veleti_2',
      Piece.leaderVeleti3: 'leader_veleti_2',
      Piece.leaderBreton0: 'leader_breton_1',
      Piece.leaderBreton1: 'leader_breton_1',
      Piece.leaderBreton2: 'leader_breton_2',
      Piece.leaderBreton3: 'leader_breton_2',
      Piece.viking0: 'map_unit_viking',
      Piece.viking1: 'map_unit_viking',
      Piece.viking2: 'map_unit_viking',
      Piece.viking3: 'map_unit_viking',
      Piece.viking4: 'map_unit_viking',
      Piece.viking5: 'map_unit_viking',
      Piece.moor0: 'map_unit_moor',
      Piece.moor1: 'map_unit_moor',
      Piece.moor2: 'map_unit_moor',
      Piece.moor3: 'map_unit_moor',
      Piece.moor4: 'map_unit_moor',
      Piece.moor5: 'map_unit_moor',
      Piece.charlemagneYounger: 'map_unit_charlemagne_younger',
      Piece.charlemagneOlder: 'map_unit_charlemagne_older',
      Piece.marquisNoCrown0: 'map_unit_marquis',
      Piece.marquisNoCrown1: 'map_unit_marquis',
      Piece.marquisNoCrown2: 'map_unit_marquis',
      Piece.marquisNoCrown3: 'map_unit_marquis',
      Piece.marquisCrown0: 'map_unit_marquis_crown',
      Piece.marquisCrown1: 'map_unit_marquis_crown',
      Piece.marquisCrown2: 'map_unit_marquis_crown',
      Piece.marquisCrown3: 'map_unit_marquis_crown',
      Piece.enemyBattleFull0: 'battle_unit_enemy_4_4',
      Piece.enemyBattleFull1: 'battle_unit_enemy_4_4',
      Piece.enemyBattleFull2: 'battle_unit_enemy_4_5',
      Piece.enemyBattleFull3: 'battle_unit_enemy_4_5',
      Piece.enemyBattleFull4: 'battle_unit_enemy_5_5',
      Piece.enemyBattleFull5: 'battle_unit_enemy_5_5',
      Piece.enemyBattleFull6: 'battle_unit_enemy_5_5',
      Piece.enemyBattleFull7: 'battle_unit_enemy_5_5',
      Piece.enemyBattleFull8: 'battle_unit_enemy_5_6',
      Piece.enemyBattleFull9: 'battle_unit_enemy_5_6',
      Piece.enemyBattleFull10: 'battle_unit_enemy_5_6',
      Piece.enemyBattleFull11: 'battle_unit_enemy_5_6',
      Piece.enemyBattleFull12: 'battle_unit_enemy_5_6',
      Piece.enemyBattleFull13: 'battle_unit_enemy_5_6',
      Piece.enemyBattleFull14: 'battle_unit_enemy_6_6',
      Piece.enemyBattleFull15: 'battle_unit_enemy_6_6',
      Piece.enemyBattleFlipped0: 'battle_unit_enemy_reduced_4_4',
      Piece.enemyBattleFlipped1: 'battle_unit_enemy_reduced_4_4',
      Piece.enemyBattleFlipped2: 'battle_unit_enemy_reduced_4_5',
      Piece.enemyBattleFlipped3: 'battle_unit_enemy_reduced_4_5',
      Piece.enemyBattleFlipped4: 'battle_unit_enemy_reduced_5_5',
      Piece.enemyBattleFlipped5: 'battle_unit_enemy_reduced_5_5',
      Piece.enemyBattleFlipped6: 'battle_unit_enemy_reduced_5_5',
      Piece.enemyBattleFlipped7: 'battle_unit_enemy_reduced_5_5',
      Piece.enemyBattleFlipped8: 'battle_unit_enemy_reduced_5_6',
      Piece.enemyBattleFlipped9: 'battle_unit_enemy_reduced_5_6',
      Piece.enemyBattleFlipped10: 'battle_unit_enemy_reduced_5_6',
      Piece.enemyBattleFlipped11: 'battle_unit_enemy_reduced_5_6',
      Piece.enemyBattleFlipped12: 'battle_unit_enemy_reduced_5_6',
      Piece.enemyBattleFlipped13: 'battle_unit_enemy_reduced_5_6',
      Piece.enemyBattleFlipped14: 'battle_unit_enemy_reduced_6_6',
      Piece.enemyBattleFlipped15: 'battle_unit_enemy_reduced_6_6',
      Piece.infantry1_0: 'battle_unit_infantry_1',
      Piece.infantry1_1: 'battle_unit_infantry_1',
      Piece.infantry1_2: 'battle_unit_infantry_1',
      Piece.infantry1_3: 'battle_unit_infantry_1',
      Piece.infantry1_4: 'battle_unit_infantry_1',
      Piece.infantry1_5: 'battle_unit_infantry_1',
      Piece.infantry1_6: 'battle_unit_infantry_1',
      Piece.infantry1_7: 'battle_unit_infantry_1',
      Piece.infantry2_0: 'battle_unit_infantry_2',
      Piece.infantry2_1: 'battle_unit_infantry_2',
      Piece.infantry2_2: 'battle_unit_infantry_2',
      Piece.infantry2_3: 'battle_unit_infantry_2',
      Piece.infantry2_4: 'battle_unit_infantry_2',
      Piece.infantry2_5: 'battle_unit_infantry_2',
      Piece.infantry2_6: 'battle_unit_infantry_2',
      Piece.infantry2_7: 'battle_unit_infantry_2',
      Piece.infantry3_0: 'battle_unit_infantry_3',
      Piece.infantry3_1: 'battle_unit_infantry_3',
      Piece.infantry3_2: 'battle_unit_infantry_3',
      Piece.infantry3_3: 'battle_unit_infantry_3',
      Piece.infantry3_4: 'battle_unit_infantry_3',
      Piece.infantry3_5: 'battle_unit_infantry_3',
      Piece.infantry3_6: 'battle_unit_infantry_3',
      Piece.infantry3_7: 'battle_unit_infantry_3',
      Piece.infantry4_0: 'battle_unit_infantry_4',
      Piece.infantry4_1: 'battle_unit_infantry_4',
      Piece.infantry4_2: 'battle_unit_infantry_4',
      Piece.infantry4_3: 'battle_unit_infantry_4',
      Piece.infantry4_4: 'battle_unit_infantry_4',
      Piece.infantry4_5: 'battle_unit_infantry_4',
      Piece.infantry4_6: 'battle_unit_infantry_4',
      Piece.infantry4_7: 'battle_unit_infantry_4',
      Piece.cavalry2_0: 'battle_unit_scara_2',
      Piece.cavalry2_1: 'battle_unit_scara_2',
      Piece.cavalry2_2: 'battle_unit_scara_2',
      Piece.cavalry2_3: 'battle_unit_scara_2',
      Piece.cavalry2_4: 'battle_unit_scara_2',
      Piece.cavalry2_5: 'battle_unit_scara_2',
      Piece.cavalry2_6: 'battle_unit_scara_2',
      Piece.cavalry2_7: 'battle_unit_scara_2',
      Piece.cavalry3_0: 'battle_unit_scara_3',
      Piece.cavalry3_1: 'battle_unit_scara_3',
      Piece.cavalry3_2: 'battle_unit_scara_3',
      Piece.cavalry3_3: 'battle_unit_scara_3',
      Piece.cavalry3_4: 'battle_unit_scara_3',
      Piece.cavalry3_5: 'battle_unit_scara_3',
      Piece.cavalry3_6: 'battle_unit_scara_3',
      Piece.cavalry3_7: 'battle_unit_scara_3',
      Piece.cavalry4_0: 'battle_unit_scara_4',
      Piece.cavalry4_1: 'battle_unit_scara_4',
      Piece.cavalry4_2: 'battle_unit_scara_4',
      Piece.cavalry4_3: 'battle_unit_scara_4',
      Piece.cavalry4_4: 'battle_unit_scara_4',
      Piece.cavalry4_5: 'battle_unit_scara_4',
      Piece.cavalry4_6: 'battle_unit_scara_4',
      Piece.cavalry4_7: 'battle_unit_scara_4',
      Piece.churchStarted0: 'church_started',
      Piece.churchStarted1: 'church_started',
      Piece.churchStarted2: 'church_started',
      Piece.churchStarted3: 'church_started',
      Piece.churchFinished0: 'church_completed',
      Piece.churchFinished1: 'church_completed',
      Piece.churchFinished2: 'church_completed',
      Piece.churchFinished3: 'church_completed',
      Piece.papalApprovalN1: 'marker_papal_approval_n1',
      Piece.papalApprovalZ: 'marker_papal_approval_0',
      Piece.papalApprovalP1: 'marker_papal_approval_p1',
      Piece.papalApprovalP2: 'marker_papal_approval_p2',
      Piece.byzantium0: 'byzantium',
      Piece.byzantium1: 'byzantium',
      Piece.byzantium2: 'byzantium',
      Piece.byzantium3: 'byzantium',
      Piece.intrigue0: 'intrigue',
      Piece.intrigue1: 'intrigue',
      Piece.intrigue2: 'intrigue',
      Piece.byzantinePeace: 'marker_byzantine_peace',
      Piece.byzantineTension: 'marker_byzantine_tension',
      Piece.alAndalusPeace: 'marker_al_andalus_peace',
      Piece.alAndalusTension: 'marker_al_andalus_tension',
      Piece.turnEnd0: 'turn_end',
      Piece.turnEnd1: 'turn_end',
      Piece.turnEnd2: 'turn_end',
      Piece.turnEnd3: 'turn_end',
      Piece.ironCrown: 'iron_crown',
      Piece.drmP1: 'marker_drm_p1',
      Piece.drmP1P2: 'marker_drm_p1_p2',
      Piece.markerEvp: 'marker_emergency_vp',
      Piece.markerGameTurn: 'marker_game_turn',
      Piece.markerTaxes: 'marker_taxes',
      Piece.markerTreasury: 'marker_treasury',
      Piece.markerVictoryPoints1: 'marker_vp_1',
      Piece.markerVictoryPoints10: 'marker_vp_10',
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

  void addBoxToMap(MyAppState appState, Location box, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(box);
    bool selected = playerChoices.selectedLocations.contains(box);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = const SizedBox(
      height: 130.0,
      width: 130.0,
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
      left: x - 72.0,
      top: y - 72.0,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.aachen: (BoardArea.map, 1286.0, 338.0),
      Location.burgundy: (BoardArea.map, 0.0, 0.0),
      Location.fulda: (BoardArea.map, 0.0, 0.0),
      Location.provence: (BoardArea.map, 0.0, 0.0),
      Location.swabia: (BoardArea.map, 0.0, 0.0),
      Location.paris: (BoardArea.map, 1016.0, 521.0),
      Location.reims: (BoardArea.map, 1132.0, 437.0),
      Location.bretonMarch: (BoardArea.map, 697.0, 468.0),
      Location.bordeaux: (BoardArea.map, 842.0, 857.0),
      Location.gascony: (BoardArea.map, 921.0, 987.0),
      Location.poitiers: (BoardArea.map, 960.0, 710.0),
      Location.spanishMarch: (BoardArea.map, 0.0, 0.0),
      Location.bavaria: (BoardArea.map, 1659.0, 579.0),
      Location.friuli: (BoardArea.map, 1658.0, 796.0),
      Location.lombardy: (BoardArea.map, 1496.0, 878.0),
      Location.rome: (BoardArea.map, 0.0, 0.0),
      Location.avars: (BoardArea.map, 1993.0, 631.0),
      Location.carinthia: (BoardArea.map, 1808.0, 677.0),
      Location.croats: (BoardArea.map, 1957.0, 890.0),
      Location.moravians: (BoardArea.map, 1935.0, 435.0),
      Location.saxons1: (BoardArea.map, 1392.0, 149.0),
      Location.saxons2: (BoardArea.map, 1537.0, 146.0),
      Location.veleti: (BoardArea.map, 1673.0, 176.0),
      Location.victory0: (BoardArea.map, 66.0, 220.0),
      Location.turn1: (BoardArea.map, 78.0, 92.0),
      Location.treasury0: (BoardArea.map, 64.0, 465.0),
      Location.evp0: (BoardArea.map, 65.0, 337.0),
      Location.boxAlAndalus: (BoardArea.map, 579.0, 688.0),
      Location.boxByzantine: (BoardArea.map, 579.0, 760.0),
      Location.boxTacticalYourReserve: (BoardArea.map, 97.0, 1450.0),
    };
    return coordinates[location]!;
  }

  void layoutStack(MyAppState appState, StackKey stackKey, List<Piece> pieces, BoardArea boardArea, double x, double y, double dx, double dy) {
    if (_expandedStacks.contains(stackKey)) {
      dx = 0.0;
      dy = 62.0;
      double bottom = y + (pieces.length + 1) * dy + 10.0;
      if (bottom >= _mapHeight) {
        dy = -62.0;
      }
    }
    for (int i = 0; i < pieces.length; ++i) {
      addPieceToBoard(appState, pieces[i], boardArea, x + i * dx, y + i * dy);
      _pieceStackKeys[pieces[i]] = stackKey;
    }
  }

  void layoutSpace(MyAppState appState, Location box) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(box);
    final xBox = coordinates.$2;
    final yBox = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(box)) {
      addBoxToMap(appState, box, xBox, yBox);
    }

    final pieces = <Piece>[];

    final enemies = state.piecesInLocation(PieceType.mapEnemyUnit, box);
    for (int depth = 0; depth < enemies.length; ++depth) {
      for (int i = 0; i < enemies.length; ++i) {
        final tribe = enemies[i];
        if (state.enemyStackDepth(tribe) == depth) {
          pieces.add(tribe);
        }
      }
    }
    final leader = state.pieceInLocation(PieceType.mapEnemyLeader, box);
    if (leader != null) {
      pieces.add(leader);
    }
    final charlemagne = state.pieceInLocation(PieceType.charlemagne, box);
    if (charlemagne != null) {
      pieces.add(charlemagne);
    }

    if (pieces.isNotEmpty) {
      layoutStack(appState, (box, 0), pieces, BoardArea.map, xBox, yBox, 4.0, 4.0);
    }

    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(box)) {
      addBoxToMap(appState, box, xBox, yBox);
    }
  }

  void layoutSpaces(MyAppState appState) {
    for (final box in LocationType.space.locations) {
      layoutSpace(appState, box);
    }
  }

  void layoutBoxes(MyAppState appState) {
    const boxesInfo = {
      Location.boxAlAndalus: (1, 1, 0.0, 0.0),
      Location.boxByzantine: (1, 1, 0.0, 0.0),
      Location.boxTacticalYourReserve: (12, 2, 4.0, 6.0),
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
      int layers = (pieces.length + cells - 1) ~/ cells;
      for (int i = pieces.length - 1; i >= 0; --i) {
        int col = i % cols;
        int row = (i % cells) ~/ cols;
        int depth = i ~/ cells;
        double x = xBox + col * (60.0 + xGap) - (layers - 1) * 2.0 + depth * 4.0;
        double y = yBox + row * (60.0 + yGap) - (layers - 1) * 2.0 + depth * 4.0;
        addPieceToBoard(appState, pieces[i], boardArea, x, y);
      }
    }
  }

  void layoutTurnTrack(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.turn1);
    double xFirst = firstCoordinates.$2;
    double yBox = firstCoordinates.$3;
    for (final box in LocationType.turn.locations) {
      final index = box.index - LocationType.turn.firstIndex;
      double xBox = xFirst + index * 101.0;
      final pieces = state.piecesInLocation(PieceType.all, box);
      for (int i = 0; i < pieces.length; ++i) {
        addPieceToBoard(appState, pieces[i], BoardArea.map, xBox + i * 4.0, yBox + i * 4.0);
      }
    }
  }

  void layoutVictoryPointTrack(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.victory0);
    double xFirst = firstCoordinates.$2;
    double yBox = firstCoordinates.$3;
    for (final box in LocationType.victory.locations) {
      final index = box.index - LocationType.victory.firstIndex;
      double xBox = xFirst + index * 101.0;
      final pieces = state.piecesInLocation(PieceType.all, box);
      for (int i = 0; i < pieces.length; ++i) {
        addPieceToBoard(appState, pieces[i], BoardArea.map, xBox + i * 4.0, yBox + i * 4.0);
      }
    }
  }

  void layoutEvpTrack(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.evp0);
    double xFirst = firstCoordinates.$2;
    double yBox = firstCoordinates.$3;
    for (final box in LocationType.evp.locations) {
      final index = box.index - LocationType.evp.firstIndex;
      double xBox = xFirst + index * 101.0;
      final pieces = state.piecesInLocation(PieceType.all, box);
      for (int i = 0; i < pieces.length; ++i) {
        addPieceToBoard(appState, pieces[i], BoardArea.map, xBox + i * 4.0, yBox + i * 4.0);
      }
    }
  }

  void layoutTreasuryTrack(MyAppState appState) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(Location.treasury0);
    double xFirst = firstCoordinates.$2;
    double yFirst = firstCoordinates.$3;
    for (final box in LocationType.treasury.locations) {
      final index = box.index - LocationType.treasury.firstIndex;
      int column = index % 5;
      int row = index ~/ 5;
      if (index == 30) {
        column = 5;
        row = 5;
      }
      double xBox = xFirst + column * 81.6;
      double yBox = yFirst + row * 77.0;
      final pieces = state.piecesInLocation(PieceType.all, box);
      for (int i = 0; i < pieces.length; ++i) {
        addPieceToBoard(appState, pieces[i], BoardArea.map, xBox + i * 4.0, yBox + i * 4.0);
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      if (!_emptyMap) {
        layoutSpaces(appState);
        layoutBoxes(appState);
        layoutTurnTrack(appState);
        layoutVictoryPointTrack(appState);
        layoutEvpTrack(appState);
        layoutTreasuryTrack(appState);
      }

      const choiceTexts = {
        Choice.purchaseInfantry: 'Infantry',
        Choice.purchaseCavalry: 'Scara',
        Choice.promoteInfantry1: 'Infantry 1→2',
        Choice.promoteInfantry2: 'Infantry 2→3',
        Choice.actionSuppress: 'Suppress',
        Choice.actionBattle: 'Battle',
        Choice.actionForcedMarch: 'Forced March',
        Choice.actionSiege: 'Siege',
        Choice.actionGift: 'Gift',
        Choice.actionMarquis: 'Marquis',
        Choice.actionForcedConversion: 'Forced Conversion',
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
                  width: _mapWidth,
                  height: _mapHeight,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0.0,
                        top: 0.0,
                        child: Stack(children: _mapStackChildren),
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

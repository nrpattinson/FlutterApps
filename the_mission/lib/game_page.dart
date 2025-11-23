import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import 'package:the_mission/game.dart';
import 'package:the_mission/main.dart';

enum BoardArea {
  map,
  actsTrack,
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
  static const _mapWidth = 2112.0;
  static const _mapHeight = 1632.0;
  static const _actsTrackWidth = 1261.0;
  static const _actsTrackHeight = 1632.0;
  static const _counterTrayWidth = 1261.0;
  static const _counterTrayHeight = 1632.0;

  final _displayOptionsFormKey = GlobalKey<FormState>();
 
  bool _emptyMap = false;

  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _actsTrackImage = Image.asset('assets/images/acts.png', key: UniqueKey(), width: _actsTrackWidth, height: _actsTrackHeight);
  final _counterTrayImage = Image.asset('assets/images/tray.png', key: UniqueKey(), width: _counterTrayWidth, height: _counterTrayHeight);
  final _mapStackChildren = <Widget>[];
  final _actsTrackStackChildren = <Widget>[];
  final _counterTrayStackChildren = <Widget>[];
  final _pieceStackKeys = <Piece,StackKey>{};
  final _expandedStacks = <StackKey>[];
  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.fieldPagan0Ascetics2: 'field_pagan_ascetics2',
      Piece.fieldPagan1Ascetics3: 'field_pagan_ascetics3',
      Piece.fieldPagan2Ascetics3: 'field_pagan_ascetics3',
      Piece.fieldPagan3Ascetics3: 'field_pagan_ascetics3',
      Piece.fieldPagan4Ascetics4: 'field_pagan_ascetics4',
      Piece.fieldPagan5Jews3: 'field_pagan_jews3',
      Piece.fieldPagan6Jews3: 'field_pagan_jews3',
      Piece.fieldPagan7Jews3: 'field_pagan_jews3',
      Piece.fieldPagan8Jews4: 'field_pagan_jews4',
      Piece.fieldPagan9Jews4: 'field_pagan_jews4',
      Piece.fieldPagan10Martyrs3: 'field_pagan_martyrs3',
      Piece.fieldPagan11Martyrs3: 'field_pagan_martyrs3',
      Piece.fieldPagan12Martyrs4: 'field_pagan_martyrs4',
      Piece.fieldPagan13Martyrs4: 'field_pagan_martyrs4',
      Piece.fieldPagan14Physicians2: 'field_pagan_physicians2',
      Piece.fieldPagan15Poor1: 'field_pagan_poor1',
      Piece.fieldPagan16Poor1: 'field_pagan_poor1',
      Piece.fieldPagan17Poor1: 'field_pagan_poor1',
      Piece.fieldPagan18Poor1: 'field_pagan_poor1',
      Piece.fieldPagan19Poor2: 'field_pagan_poor2',
      Piece.fieldPagan20Poor2: 'field_pagan_poor2',
      Piece.fieldPagan21Scholars3: 'field_pagan_scholars3',
      Piece.fieldPagan22Scholars4: 'field_pagan_scholars4',
      Piece.fieldPagan23Scholars4: 'field_pagan_scholars4',
      Piece.fieldPagan24Slaves1: 'field_pagan_slaves1',
      Piece.fieldPagan25Slaves2: 'field_pagan_slaves2',
      Piece.fieldPagan26Slaves2: 'field_pagan_slaves2',
      Piece.fieldPagan27Slaves3: 'field_pagan_slaves3',
      Piece.fieldPagan28Slaves3: 'field_pagan_slaves3',
      Piece.fieldPagan29Slaves4: 'field_pagan_slaves4',
      Piece.fieldPagan30Wealthy4: 'field_pagan_wealthy4',
      Piece.fieldPagan31Women1: 'field_pagan_women1',
      Piece.fieldPagan32Women1: 'field_pagan_women1',
      Piece.fieldPagan33Women2: 'field_pagan_women2',
      Piece.fieldPagan34Women2: 'field_pagan_women2',
      Piece.fieldPagan35Women2: 'field_pagan_women2',
      Piece.fieldPagan36Women3: 'field_pagan_women3',
      Piece.fieldPagan37Women3: 'field_pagan_women3',
      Piece.fieldChristian0Ascetics1: 'field_christian_ascetics1',
      Piece.fieldChristian1Ascetics2: 'field_christian_ascetics2',
      Piece.fieldChristian2Ascetics2: 'field_christian_ascetics2',
      Piece.fieldChristian3Ascetics2: 'field_christian_ascetics2',
      Piece.fieldChristian4Ascetics3: 'field_christian_ascetics3',
      Piece.fieldChristian5Jews2: 'field_christian_jews2',
      Piece.fieldChristian6Jews2: 'field_christian_jews2',
      Piece.fieldChristian7Jews2: 'field_christian_jews2',
      Piece.fieldChristian8Jews3: 'field_christian_jews3',
      Piece.fieldChristian9Jews3: 'field_christian_jews3',
      Piece.fieldChristian10Martyrs3: 'field_christian_martyrs3',
      Piece.fieldChristian11Martyrs3: 'field_christian_martyrs3',
      Piece.fieldChristian12Martyrs4: 'field_christian_martyrs4',
      Piece.fieldChristian13Martyrs4: 'field_christian_martyrs4',
      Piece.fieldChristian14Physicians2: 'field_christian_physicians2',
      Piece.fieldChristian15Poor1: 'field_christian_poor1',
      Piece.fieldChristian16Poor1: 'field_christian_poor1',
      Piece.fieldChristian17Poor1: 'field_christian_poor1',
      Piece.fieldChristian18Poor1: 'field_christian_poor1',
      Piece.fieldChristian19Poor2: 'field_christian_poor2',
      Piece.fieldChristian20Poor2: 'field_christian_poor2',
      Piece.fieldChristian21Scholars2: 'field_christian_scholars2',
      Piece.fieldChristian22Scholars3: 'field_christian_scholars3',
      Piece.fieldChristian23Scholars3: 'field_christian_scholars3',
      Piece.fieldChristian24Slaves1: 'field_christian_slaves1',
      Piece.fieldChristian25Slaves2: 'field_christian_slaves2',
      Piece.fieldChristian26Slaves2: 'field_christian_slaves2',
      Piece.fieldChristian27Slaves3: 'field_christian_slaves3',
      Piece.fieldChristian28Slaves3: 'field_christian_slaves3',
      Piece.fieldChristian29Slaves4: 'field_christian_slaves4',
      Piece.fieldChristian30Wealthy3: 'field_christian_wealthy3',
      Piece.fieldChristian31Women1: 'field_christian_women1',
      Piece.fieldChristian32Women1: 'field_christian_women1',
      Piece.fieldChristian33Women2: 'field_christian_women2',
      Piece.fieldChristian34Women2: 'field_christian_women2',
      Piece.fieldChristian35Women2: 'field_christian_women2',
      Piece.fieldChristian36Women3: 'field_christian_women3',
      Piece.fieldChristian37Women3: 'field_christian_women3',
      Piece.romanControlPaganWestEurope: 'roman_control_pagan',
      Piece.romanControlPaganEastEurope: 'roman_control_pagan',
      Piece.romanControlPaganCaucasus: 'roman_control_pagan',
      Piece.romanControlPaganEastAfrica: 'roman_control_pagan',
      Piece.romanControlPaganNorthAfrica: 'roman_control_pagan',
      Piece.romanControlChristianWestEurope: 'roman_control_christian',
      Piece.romanControlChristianEastEurope: 'roman_control_christian',
      Piece.romanControlChristianCaucasus: 'roman_control_christian',
      Piece.romanControlChristianEastAfrica: 'roman_control_christian',
      Piece.romanControlChristianNorthAfrica: 'roman_control_christian',
      Piece.romanArmy: 'roman_army',
      Piece.romanCapitalPagan: 'roman_capital_pagan',
      Piece.romanCapitalChristian: 'roman_capital_christian',
      Piece.hordeSeljuksMuslim: 'horde_seljuks_muslim',
      Piece.hordeSaxonsArian: 'horde_saxons_arian',
      Piece.hordeSaxonsChristian: 'horde_saxons_christian',
      Piece.hordeTurksPagan: 'horde_turks_pagan',
      Piece.hordeTurksManichee: 'horde_turks_manichee',
      Piece.hordeTurksChristian: 'horde_turks_christian',
      Piece.hordeTurksMuslim: 'horde_turks_muslim',
      Piece.hordeBulgarsPagan: 'horde_bulgars_pagan',
      Piece.hordeBulgarsChristian: 'horde_bulgars_christian',
      Piece.hordeKhazarsPagan: 'horde_khazars_pagan',
      Piece.hordeKhazarsJewish: 'horde_khazars_jewish',
      Piece.hordeVandalsArian: 'horde_vandals_arian',
      Piece.hordeBerbersMuslim: 'horde_berbers_muslim',
      Piece.hordeHimyarClans: 'horde_himyar',
      Piece.hordeShewaMuslim: 'horde_shewa_muslim',
      Piece.persianEmpire0: 'persian_empire_c0',
      Piece.persianEmpireN1: 'persian_empire_n1',
      Piece.persianEmpireP1: 'persian_empire_p1',
      Piece.jihadWestEurope: 'jihad_pa',
      Piece.jihadEastEurope: 'jihad_pb',
      Piece.jihadCaucasus: 'jihad_pc',
      Piece.jihadCentralAsia: 'jihad_pd',
      Piece.jihadEastAfrica: 'jihad_pe',
      Piece.jihadNorthAfrica: 'jihad_pf',
      Piece.abbasidWestEurope: 'abbasid_pa',
      Piece.abbasidEastEurope: 'abbasid_pb',
      Piece.abbasidCaucasus: 'abbasid_pc',
      Piece.abbasidCentralAsia: 'abbasid_pd',
      Piece.abbasidEastAfrica: 'abbasid_pe',
      Piece.abbasidNorthAfrica: 'abbasid_pf',
      Piece.holyRomanEmpire: 'holy_roman_empire',
      Piece.unholyArianEmpire: 'unholy_arian_empire',
      Piece.papalStates: 'papal_states',
      Piece.knight0: 'knight',
      Piece.knight1: 'knight',
      Piece.knight2: 'knight',
      Piece.prayForPeace0: 'pray_for_peace',
      Piece.prayForPeace1: 'pray_for_peace',
      Piece.prayForPeace2: 'pray_for_peace',
      Piece.cultIsis0: 'cult_isis',
      Piece.cultIsis1: 'cult_isis',
      Piece.nubia: 'nubia',
      Piece.baqt: 'baqt',
      Piece.heresyMithra0: 'heresy_mithra',
      Piece.heresyMithra1: 'heresy_mithra',
      Piece.heresyEbionite0: 'heresy_ebionite',
      Piece.heresyEbionite1: 'heresy_ebionite',
      Piece.heresyEbionite2: 'heresy_ebionite',
      Piece.heresyGnostics0: 'heresy_gnostics',
      Piece.heresyGnostics1: 'heresy_gnostics',
      Piece.heresyGnostics2: 'heresy_gnostics',
      Piece.heresyMarcionite: 'heresy_marcionite',
      Piece.heresyMontanist: 'heresy_montanist',
      Piece.heresySabellian: 'heresy_sabellian',
      Piece.heresyAdoptionist: 'heresy_adoptionist',
      Piece.heresyManichees0: 'heresy_manichees',
      Piece.heresyManichees1: 'heresy_manichees',
      Piece.heresyManichees2: 'heresy_manichees',
      Piece.heresyPelagian: 'heresy_pelagian',
      Piece.heresyMonothelete: 'heresy_monothelete',
      Piece.heresyPaulician: 'heresy_paulician',
      Piece.heresyIconoclast: 'heresy_iconoclast',
      Piece.heresyBogomil: 'heresy_bogomil',
      Piece.heresyCathar: 'heresy_cathar',
      Piece.melkite0: 'melkite',
      Piece.melkite1: 'melkite',
      Piece.melkite2: 'melkite',
      Piece.melkite3: 'melkite',
      Piece.melkite4: 'melkite',
      Piece.melkite5: 'melkite',
      Piece.melkite6: 'melkite',
      Piece.melkite7: 'melkite',
      Piece.melkite8: 'melkite',
      Piece.melkite9: 'melkite',
      Piece.melkite10: 'melkite',
      Piece.melkite11: 'melkite',
      Piece.melkite12: 'melkite',
      Piece.melkite13: 'melkite',
      Piece.melkite14: 'melkite',
      Piece.melkite15: 'melkite',
      Piece.melkite16: 'melkite',
      Piece.melkite17: 'melkite',
      Piece.apostleWestEurope: 'apostle_pa',
      Piece.apostleEastEurope: 'apostle_pb',
      Piece.apostleCaucasus: 'apostle_pc',
      Piece.apostleCentralAsia: 'apostle_pd',
      Piece.apostleEastAfrica: 'apostle_pe',
      Piece.apostleNorthAfrica: 'apostle_pf',
      Piece.apostleJerusalem: 'apostle_jerusalem',
      Piece.relicsWestEurope: 'relics',
      Piece.relicsEastEurope: 'relics',
      Piece.relicsCaucasus: 'relics',
      Piece.relicsCentralAsia: 'relics',
      Piece.relicsEastAfrica: 'relics',
      Piece.relicsNorthAfrica: 'relics',
      Piece.relicsJerusalem: 'relics',
      Piece.bishopWestEurope: 'bishop_pa',
      Piece.bishopEastEurope: 'bishop_pb',
      Piece.bishopCaucasus: 'bishop_pc',
      Piece.bishopCentralAsia: 'bishop_pd',
      Piece.bishopEastAfrica: 'bishop_pe',
      Piece.bishopNorthAfrica: 'bishop_pf',
      Piece.archbishopWestEurope: 'archbishop_pa',
      Piece.archbishopEastEurope: 'archbishop_pb',
      Piece.archbishopCaucasus: 'archbishop_pc',
      Piece.archbishopCentralAsia: 'archbishop_pd',
      Piece.archbishopEastAfrica: 'archbishop_pe',
      Piece.archbishopNorthAfrica: 'archbishop_pf',
      Piece.popeWestEurope: 'pope_pa',
      Piece.popeEastEurope: 'pope_pb',
      Piece.popeCaucasus: 'pope_pc',
      Piece.popeCentralAsia: 'pope_pd',
      Piece.popeEastAfrica: 'pope_pe',
      Piece.popeNorthAfrica: 'pope_pf',
      Piece.schismEastEurope: 'schism_pb',
      Piece.schismCaucasus: 'schism_pc',
      Piece.schismCentralAsia: 'schism_pd',
      Piece.schismEastAfrica: 'schism_pe',
      Piece.schismNorthAfrica: 'schism_pf',
      Piece.kingWestEurope: 'king_pa',
      Piece.kingEastEurope: 'king_pb',
      Piece.kingCaucasus: 'king_pc',
      Piece.kingCentralAsia: 'king_pd',
      Piece.kingEastAfrica: 'king_pe',
      Piece.kingNorthAfrica: 'king_pf',
      Piece.tyrantWestEurope: 'tyrant_pa',
      Piece.tyrantEastEurope: 'tyrant_pb',
      Piece.tyrantCaucasus: 'tyrant_pc',
      Piece.tyrantCentralAsia: 'tyrant_pd',
      Piece.tyrantEastAfrica: 'tyrant_pe',
      Piece.tyrantNorthAfrica: 'tyrant_pf',
      Piece.infrastructureMonastery0: 'infrastructure_monastery',
      Piece.infrastructureMonastery1: 'infrastructure_monastery',
      Piece.infrastructureHospital0: 'infrastructure_hospital',
      Piece.infrastructureHospital1: 'infrastructure_hospital',
      Piece.infrastructureUniversity0: 'infrastructure_university',
      Piece.infrastructureUniversity1: 'infrastructure_university',
      Piece.faithCatholic: 'faith_catholic',
      Piece.faithOrthodoxEagle: 'faith_orthodox_eagle',
      Piece.faithOrthodox: 'faith_orthodox',
      Piece.faithNestorian: 'faith_nestorian',
      Piece.faithOneNature0: 'faith_one_nature',
      Piece.faithOneNature1: 'faith_one_nature',
      Piece.faithDonatist: 'faith_donatist',
      Piece.faithApollinarian: 'faith_apollinarian',
      Piece.faithArian: 'faith_arian',
      Piece.faithSubmit0: 'faith_submit',
      Piece.faithSubmit1: 'faith_submit',
      Piece.faithSubmit2: 'faith_submit',
      Piece.faithSubmit3: 'faith_submit',
      Piece.faithSubmit4: 'faith_submit',
      Piece.faithSubmit5: 'faith_submit',
      Piece.faithSubmit6: 'faith_submit',
      Piece.occupiedJerusalem: 'occupied_jerusalem',
      Piece.occupiedSpain: 'occupied_spain',
      Piece.reconquista: 'reconquista',
      Piece.emperorChristian: 'emperor_christian',
      Piece.emperorHeretical: 'emperor_heretical',
      Piece.romanaPax: 'romana_pax',
      Piece.romanaLex: 'romana_lex',
      Piece.persiaZoroastrian: 'persia_zoroastrian',
      Piece.persiaMuslim: 'persia_muslim',
      Piece.bibleGreek: 'bible_greek',
      Piece.bibleLatin: 'bible_latin',
      Piece.bibleSyriac: 'bible_syriac',
      Piece.bibleCoptic: 'bible_coptic',
      Piece.bibleArmenian: 'bible_armenian',
      Piece.bibleUsedGreek: 'bible_greek_used',
      Piece.bibleUsedLatin: 'bible_latin_used',
      Piece.bibleUsedSyriac: 'bible_syriac_used',
      Piece.bibleUsedCoptic: 'bible_coptic_used',
      Piece.bibleUsedArmenian: 'bible_armenian_used',
      Piece.greatTheologian: 'great_theologian',
      Piece.solidus: 'solidus',
      Piece.darkAges: 'dark_ages',
      Piece.gameTurn: 'game_turn',
      Piece.waferCoin1: 'wafer_c01',
      Piece.waferCoin2: 'wafer_c02',
      Piece.waferCoin3: 'wafer_c03',
      Piece.waferCoin4: 'wafer_c04',
      Piece.waferCoin5: 'wafer_c05',
      Piece.waferCoin6: 'wafer_c06',
      Piece.waferCoin7: 'wafer_c07',
      Piece.waferCoin8: 'wafer_c08',
      Piece.waferCoin9: 'wafer_c09',
      Piece.waferCoin10: 'wafer_c10',
      Piece.waferCoin11: 'wafer_c11',
      Piece.waferCoin12: 'wafer_c12',
      Piece.waferCoin13: 'wafer_c13',
      Piece.waferCoin14: 'wafer_c14',
      Piece.waferCoin15: 'wafer_c15',
      Piece.waferCoin16: 'wafer_c16',
      Piece.waferCoin17: 'wafer_c17',
      Piece.waferCoin18: 'wafer_c18',
      Piece.waferCoin19: 'wafer_c19',
      Piece.waferCoin20: 'wafer_c20',
      Piece.waferCoin21: 'wafer_c21',
      Piece.waferCoin22: 'wafer_c22',
      Piece.waferCoin23: 'wafer_c23',
      Piece.waferCoin24: 'wafer_c24',
      Piece.waferCoin25: 'wafer_c25',
      Piece.waferCoin26: 'wafer_c26',
      Piece.waferCoin27: 'wafer_c27',
      Piece.waferCoin28: 'wafer_c28',
      Piece.waferCoin29: 'wafer_c29',
      Piece.waferCoin30: 'wafer_c30',
      Piece.waferCoin31: 'wafer_c31',
      Piece.waferCoin32: 'wafer_c32',
      Piece.waferAction1: 'wafer_heresy',
      Piece.waferAction2: 'wafer_heresy',
      Piece.waferAction3: 'wafer_heresy',
      Piece.waferAction4: 'wafer_heresy',
      Piece.waferAction5: 'wafer_epidemic',
      Piece.waferAction6: 'wafer_heresy',
      Piece.waferAction7: 'wafer_heresy',
      Piece.waferAction8: 'wafer_epidemic',
      Piece.waferAction9: 'wafer_heresy',
      Piece.waferAction10: 'wafer_heresy',
      Piece.waferAction11: 'wafer_heresy',
      Piece.waferAction12: 'wafer_plain',
      Piece.waferAction13: 'wafer_heresy',
      Piece.waferAction14: 'wafer_heresy',
      Piece.waferAction15: 'wafer_plain',
      Piece.waferAction16: 'wafer_heresy',
      Piece.waferAction17: 'wafer_islam_a2d2f2',
      Piece.waferAction18: 'wafer_ruler_b2e2f2',
      Piece.waferAction19: 'wafer_islam_b1d2f1',
      Piece.waferAction20: 'wafer_ruler_a2d2e2',
      Piece.waferAction21: 'wafer_heresy_b2d1e1',
      Piece.waferAction22: 'wafer_ruler_a1c2d2',
      Piece.waferAction23: 'wafer_ruler_c1d2f2',
      Piece.waferAction24: 'wafer_heresy_a1b1f2',
      Piece.waferAction25: 'wafer_ruler_c1d2e2',
      Piece.waferAction26: 'wafer_islam_a1c1d3',
      Piece.waferAction27: 'wafer_ruler_b2e1f3',
      Piece.waferAction28: 'wafer_islam_a2d1f2',
      Piece.waferAction29: 'wafer_ruler_a2b1e1',
      Piece.waferAction30: 'wafer_heresy_b2d1f1',
      Piece.waferAction31: 'wafer_ruler_a2c2f2',
      Piece.waferAction32: 'wafer_islam_b2c2f1',
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
    case BoardArea.actsTrack:
      _actsTrackStackChildren.add(widget);
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

    final state = appState.gameState!;

    Widget widget = const SizedBox(
      height: 130.0,
      width: 130.0,
    );

    BoxDecoration? boxDecoration;
    if (state.landIsHomeland(land)) {
      boxDecoration = BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: choosable ? Colors.red : Colors.green, width: 5.0),
      );
    } else {
      boxDecoration = BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.transparent,
        border: Border.all(color: choosable ? Colors.red : Colors.green, width: 5.0),
        borderRadius: BorderRadius.circular(10.0),
      );
    }

    widget = Container(
      decoration: boxDecoration,
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
      left: x - 72.0,
      top: y - 72.0,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.landJerusalem: (BoardArea.map, 1198.0, 791.0),
      Location.landRome: (BoardArea.map, 669.0, 569.0),
      Location.landMilan: (BoardArea.map, 512.0, 503.0),
      Location.landSpain: (BoardArea.map, 253.0, 628.0),
      Location.landGaul: (BoardArea.map, 325.0, 472.0),
      Location.landBelgium: (BoardArea.map, 481.0, 321.0),
      Location.landBritain: (BoardArea.map, 286.0, 300.0),
      Location.landIreland: (BoardArea.map, 132.0, 256.0),
      Location.homelandSaxons: (BoardArea.map, 289.0, 138.0),
      Location.landCilicia: (BoardArea.map, 1246.0, 592.0),
      Location.landAnatolia: (BoardArea.map, 1068.0, 622.0),
      Location.landGreece: (BoardArea.map, 882.0, 638.0),
      Location.landConstantinople: (BoardArea.map, 993.0, 464.0),
      Location.landDanube: (BoardArea.map, 816.0, 414.0),
      Location.landKiev: (BoardArea.map, 1038.0, 257.0),
      Location.homelandBulgars: (BoardArea.map, 1217.0, 164.0),
      Location.landAntioch: (BoardArea.map, 1387.0, 773.0),
      Location.landArmenia: (BoardArea.map, 1436.0, 609.0),
      Location.landAlbania: (BoardArea.map, 1602.0, 582.0),
      Location.landSarir: (BoardArea.map, 1542.0, 421.0),
      Location.landGeorgia: (BoardArea.map, 1359.0, 434.0),
      Location.landAlania: (BoardArea.map, 1444.0, 255.0),
      Location.homelandKhazars: (BoardArea.map, 1609.0, 211.0),
      Location.landCtesiphon: (BoardArea.map, 1426.0, 929.0),
      Location.landPersia: (BoardArea.map, 1590.0, 813.0),
      Location.landMerv: (BoardArea.map, 1776.0, 782.0),
      Location.landIndia: (BoardArea.map, 1961.0, 910.0),
      Location.landKashgar: (BoardArea.map, 1977.0, 593.0),
      Location.landMongolia: (BoardArea.map, 1961.0, 286.0),
      Location.homelandTurks: (BoardArea.map, 1811.0, 147.0),
      Location.landAlexandria: (BoardArea.map, 1014.0, 890.0),
      Location.landThebes: (BoardArea.map, 904.0, 1056.0),
      Location.landNobadia: (BoardArea.map, 1128.0, 1043.0),
      Location.landMakouria: (BoardArea.map, 1078.0, 1199.0),
      Location.landAlodia: (BoardArea.map, 1129.0, 1362.0),
      Location.landEthiopia: (BoardArea.map, 1296.0, 1298.0),
      Location.homelandHimyar: (BoardArea.map, 1483.0, 1327.0),
      Location.landCyrene: (BoardArea.map, 849.0, 829.0),
      Location.landTripoli: (BoardArea.map, 686.0, 865.0),
      Location.landSufetula: (BoardArea.map, 518.0, 878.0),
      Location.landCarthage: (BoardArea.map, 450.0, 693.0),
      Location.landNumidia: (BoardArea.map, 349.0, 856.0),
      Location.landTingitana: (BoardArea.map, 180.0, 799.0),
      Location.homelandVandals: (BoardArea.map, 134.0, 981.0),
      Location.boxFaithWestEurope: (BoardArea.map, 101.0, 377.0),
      Location.boxFaithEastEurope: (BoardArea.map, 882.0, 87.0),
      Location.boxFaithCaucasus: (BoardArea.map, 1415.0, 78.0),
      Location.boxFaithCentralAsia: (BoardArea.map, 1939.0, 91.0),
      Location.boxFaithEastAfrica: (BoardArea.map, 896.0, 1274.0),
      Location.boxFaithNorthAfrica: (BoardArea.map, 112.0, 1080.0),
      Location.boxRomanPolicy: (BoardArea.map, 113.0, 1262.0),
      Location.boxPersianReligion: (BoardArea.map, 1802.0, 1047.0),
      Location.boxWafer: (BoardArea.map, 257.0, 1308.0),
      Location.boxDamagedArmies: (BoardArea.map, 1683.0, 1436.0),
      Location.boxBibleTranslations: (BoardArea.map, 174.0, 1470.0),
      Location.boxArabAttackRolls1: (BoardArea.map, 1780.0, 1265.0),
      Location.boxBigCityField0: (BoardArea.map, 500.0, 1280.0),
      Location.boxBigCityField1: (BoardArea.map, 600.0, 1280.0),
      Location.boxBigCityField2: (BoardArea.map, 700.0, 1280.0),
      Location.boxTrack0: (BoardArea.map, 561.0, 1519.0),
      Location.boxActs1: (BoardArea.actsTrack, 87.0, 213.0),
      Location.boxActs2: (BoardArea.actsTrack, 364.0, 213.0),
      Location.boxActs3: (BoardArea.actsTrack, 644.0, 213.0),
      Location.boxActs4: (BoardArea.actsTrack, 921.0, 213.0),
      Location.boxActs5: (BoardArea.actsTrack, 87.0, 351.0),
      Location.boxActs9: (BoardArea.actsTrack, 87.0, 521.0),
      Location.boxActs13: (BoardArea.actsTrack, 87.0, 661.0),
      Location.boxActs17: (BoardArea.actsTrack, 87.0, 802.0),
      Location.boxActs21: (BoardArea.actsTrack, 87.0, 942.0),
      Location.boxActs25: (BoardArea.actsTrack, 87.0, 1082.0),
      Location.boxActs27: (BoardArea.actsTrack, 87.0, 1220.0),
      Location.trayField: (BoardArea.counterTray, 93.0, 180.0),
      Location.trayWafer: (BoardArea.counterTray, 755.0, 180.0),
      Location.trayHeresy: (BoardArea.counterTray, 92.0, 345.0),
      Location.trayPope: (BoardArea.counterTray, 755.0, 345.0),
      Location.trayFaith: (BoardArea.counterTray, 90.0, 510.0),
      Location.trayJihad: (BoardArea.counterTray, 530.0, 510.0),
      Location.trayMisc: (BoardArea.counterTray, 755.0, 510.0),
      Location.trayRoman: (BoardArea.counterTray, 85.0, 675.0),
      Location.trayHorde: (BoardArea.counterTray, 308.0, 675.0),
      Location.trayBible: (BoardArea.counterTray, 530.0, 675.0),
      Location.trayKnight: (BoardArea.counterTray, 753.0, 700.0),
      Location.trayInfrastructure: (BoardArea.counterTray, 974.0, 674.0),
      Location.greatTheologianIgnatius: (BoardArea.counterTray, 288.0, 939.0),
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

  void layoutLand(MyAppState appState, Location land) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(land);
    final xLand = coordinates.$2;
    final yLand = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(land)) {
      addLandToMap(appState, land, xLand, yLand);
    }

    if (!_emptyMap) {
      final pieces = <Piece>[];
      final positions = <int>[];  // UL, UR, LL, LR, C
      final positionCounts = <int>[0, 0, 0, 0, 0];
      final zs = <int>[];
      for (final piece in state.piecesInLocation(PieceType.all, land)) {
        int pos = 0;
        int z = 0;
        if (piece.isType(PieceType.horde) || piece == Piece.unholyArianEmpire) {
          if (state.landIsHomeland(land)) {
            pos = 4;
          } else {
            pos = 1;
          }
          z = 1;
        } else if (piece.isType(PieceType.romanControl) || piece == Piece.holyRomanEmpire || piece == Piece.nubia) {
          pos = 1;
          z = 1;
        } else if (piece.isType(PieceType.jihad) || piece.isType(PieceType.abbasid)) {
          pos = 1;
          z = 1;
        } else if (piece.isType(PieceType.king) || piece.isType(PieceType.tyrant)) {
          pos = 1;
          z = 1;
        } else if (piece.isType(PieceType.persianEmpire)) {
          pos = 1;
          z = 1;
        } else  if (piece.isType(PieceType.field)) {
          pos = 0;
          z = 2;
        } else if (piece.isType(PieceType.pope)) {
          pos = 2;
          z = 1;
        } else if (piece.isType(PieceType.archbishop)) {
          pos = 2;
          z = 2;
        } else if (piece.isType(PieceType.bishop)) {
          pos = 2;
          z = 3;
        } else if (piece.isType(PieceType.apostle)) {
          pos = 2;
          z = 4;
        } else if (piece == Piece.greatTheologian) {
          pos = 2;
          z = 5;
        } else if (piece.isType(PieceType.relics)) {
          pos = 3;
          z = 1;
        } else if (piece == Piece.occupiedJerusalem || piece == Piece.occupiedSpain || piece == Piece.reconquista) {
          pos = 3;
          z = 2;
        } else if (piece.isType(PieceType.melkite)) {
          pos = 3;
          z = 3;
        } else if (piece.isType(PieceType.romanCapital)) {
          pos = 3;
          z = 4;
        } else if (piece == Piece.papalStates) {
          pos = 3;
          z = 5;
        } else if (piece == Piece.baqt) {
          pos = 3;
          z = 6;
        } else if (piece.isType(PieceType.infrastructure)) {
          pos = 3;
          z = 7;
        } else if (piece.isType(PieceType.prayForPeace)) {
          pos = 3;
          z = 8;
        } else if (piece.isType(PieceType.knight)) {
          pos = 3;
          z = 9;
        } else if (piece == Piece.romanArmy) {
          pos = 3;
          z = 10;
        } else if (piece.isType(PieceType.cultIsis)) {
          pos = 3;
          z = 11;
        } else if (piece.isType(PieceType.heresy)) {
          pos = 3;
          z = 12;
        }
        pieces.add(piece);
        positions.add(pos);
        positionCounts[pos] += 1;
        zs.add(z);
      }

      if (land == Location.landJerusalem) {
        for (int i = 0; i < pieces.length; ++i) {
          final piece = pieces[i];
          int col = 0;
          int row = 0;
          if ([Piece.apostleWestEurope, Piece.jihadWestEurope, Piece.abbasidWestEurope].contains(piece)) {
            col = 0;
            row = 0;
          } else if ([Piece.apostleEastEurope, Piece.jihadEastEurope, Piece.abbasidEastEurope].contains(piece)) {
            col = 2;
            row = 0;
          } else if ([Piece.apostleCaucasus, Piece.jihadCaucasus, Piece.abbasidCaucasus].contains(piece)) {
            col = 2;
            row = 1;
          } else if ([Piece.apostleCentralAsia, Piece.jihadCentralAsia, Piece.abbasidCentralAsia].contains(piece)) {
            col = 2;
            row = 2;
          } else if ([Piece.apostleEastAfrica, Piece.jihadEastAfrica, Piece.abbasidEastAfrica].contains(piece)) {
            col = 0;
            row = 2;
          } else if ([Piece.apostleNorthAfrica, Piece.jihadNorthAfrica, Piece.abbasidNorthAfrica].contains(piece)) {
            col = 0;
            row = 1;
          } else if (piece == Piece.apostleJerusalem || piece == Piece.occupiedJerusalem) {
            col = 1;
            row = 1;
          } else if (piece.isType(PieceType.relics)) {
            col = 1;
            row = 2;
          }
          double x = xLand - 90.0 + 64.0 * col;
          double y = yLand - 90.0 + 64.0 * row; 
          addPieceToBoard(appState, piece, BoardArea.map, x, y);
        }
      } else {
        for (int position = 0; position < positionCounts.length; ++position) {
          double xPos = xLand;
          double yPos = yLand;
          int col = 1;
          int row = 1;
          if (position < 4) {
            col = position % 2;
            row = position ~/ 2;
            xPos = xLand - 62.0 + col * 64.0;
            yPos = yLand - 62.0 + row * 64.0;
          } else {
            xPos -= 55.0;
            yPos += 0.0;
          }
          int count = positionCounts[position];
          int order = 1;
          for (int z = 0; z <= 12; ++z) {
            for (int i = 0; i < pieces.length; ++i) {
              if (positions[i] == position && zs[i] == z) {
                double xDelta = col == 0 ? -4.0 : 4.0;
                double yDelta = row == 0 ? -4.0 : 4.0;
                double x = xPos + (count - order) * xDelta;
                double y = yPos + (count - order) * yDelta;
                addPieceToBoard(appState, pieces[i], BoardArea.map, x, y);
                order += 1;
              }
            }
          }
        }
      }
    }

    if (appState.playerChoices != null && appState.playerChoices!.locations.contains(land)) {
      addLandToMap(appState, land, xLand, yLand);
    }
  }

  void layoutLands(MyAppState appState) {
    for (final land in LocationType.land.locations) {
      layoutLand(appState, land);
    }
  }

  void layoutBoxes(MyAppState appState) {
    const boxesInfo = {
      Location.boxRomanPolicy: (1, 1, 2.0, 2.0),
      Location.boxPersianReligion: (1, 1, 2.0, 2.0),
      Location.boxWafer: (1, 1, 2.0, 2.0),
      Location.boxDamagedArmies: (4, 1, 15.0, 15.0),
      Location.boxBibleTranslations: (5, 1, 2.0, 2.0),
      Location.boxFaithWestEurope: (1, 1, 2.0, 2.0),
      Location.boxFaithEastEurope: (1, 1, 2.0, 2.0),
      Location.boxFaithCaucasus: (1, 1, 2.0, 2.0),
      Location.boxFaithCentralAsia: (1, 1, 2.0, 2.0),
      Location.boxFaithEastAfrica: (1, 1, 2.0, 2.0),
      Location.boxFaithNorthAfrica: (1, 1, 2.0, 2.0),
      Location.boxBigCityField0: (1, 1, 0.0, 0.0),
      Location.boxBigCityField1: (1, 1, 0.0, 0.0),
      Location.boxBigCityField2: (1, 1, 0.0, 0.0),
      Location.trayField: (9, 2, 12.0, 5.0),
      Location.trayWafer: (6, 2, 12.0, 5.0),
      Location.trayHeresy: (9, 2, 12.0, 5.0),
      Location.trayPope: (6, 2, 12.0, 5.0),
      Location.trayFaith: (6, 2, 12.0, 5.0),
      Location.trayJihad: (3, 2, 12.0, 5.0),
      Location.trayMisc: (6, 2, 12.0, 5.0),
      Location.trayRoman: (3, 2, 12.0, 5.0),
      Location.trayHorde: (3, 2, 12.0, 5.0),
      Location.trayBible: (3, 2, 12.0, 5.0),
      Location.trayKnight: (3, 1, 12.0, 0.0),
      Location.trayInfrastructure: (3, 2, 12.0, 5.0),
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

  void layoutTrack(MyAppState appState) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(Location.boxTrack0);
    final xFirst = coordinates.$2;
    final yFirst = coordinates.$3;
    for (final box in LocationType.boxTrack.locations) {
      int col = box.index - LocationType.boxTrack.firstIndex;
      double xBox = xFirst + col * 101.0;
      double yBox = yFirst;
      final pieces = state.piecesInLocation(PieceType.all, box);
      for (int i = pieces.length - 1; i >= 0; --i) {
        final piece = pieces[i];
        double x = xBox - 30.0;
        double y = yBox - 30.0;
        x += i * 4.0;
        y += i * 4.0;
        addPieceToBoard(appState, piece, BoardArea.map, x, y);
      }
    }
  }

  void layoutActsTrackBox(MyAppState appState, Location box) {
    final state = appState.gameState!;
    final pieces = state.piecesInLocation(PieceType.all, box);
    if (pieces.isEmpty) {
      return;
    }
    int index = box.index - LocationType.boxActs.firstIndex;
		int col = index % 4;
		int row = index ~/ 4;
    Location rowBox = Location.values[LocationType.boxActs.firstIndex + row * 4];
		if (index >= 24) {
			col = 2 * ((index - 24) % 2);
			row = 6 + (index - 24) ~/ 2;
      rowBox = Location.values[LocationType.boxActs.firstIndex + 24 + (row - 6) * 2];
		}
    final colBox = Location.values[LocationType.boxActs.firstIndex + col];
    double xBox = locationCoordinates(colBox).$2;
    double yBox = locationCoordinates(rowBox).$3;
    Piece? turnChit;
    final others = <Piece>[];
    for (int i = 0; i < pieces.length; ++i) {
      final piece = pieces[i];
      if (piece == Piece.gameTurn) {
        turnChit = piece;
      } else {
        others.add(piece);
      }
    }
		for (int i = others.length - 1; i >= 0; --i) {
      double x = xBox + 190.0 + i * 4.0;
      if (index >= 24) {
        x += 270.0;
      }
      double y = yBox;
      addPieceToBoard(appState, others[i], BoardArea.actsTrack, x, y);
    }
    if (turnChit != null) {
      addPieceToBoard(appState, turnChit, BoardArea.actsTrack, xBox, yBox);
    }
	}

  void layoutActsTrack(MyAppState appState) {
    for (final box in LocationType.boxActs.locations) {
      layoutActsTrackBox(appState, box);
    }
  }

  void layoutGreatTheologians(MyAppState appState) {
    final state = appState.gameState!;
    final location = state.pieceLocation(Piece.greatTheologian);
    if (location.isType(LocationType.greatTheologian)) {
      int index = location.index - LocationType.greatTheologian.firstIndex;
      int col = index % 4;
      int row = index ~/ 4;
      final coordinates = locationCoordinates(Location.greatTheologianIgnatius);
      double xFirst = coordinates.$2;
      double yFirst = coordinates.$3;
      double x = xFirst + col * 200.0;
      double y = yFirst + row * 100.0;
      addPieceToBoard(appState, Piece.greatTheologian, BoardArea.counterTray, x, y);
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
    _actsTrackStackChildren.clear();
    _actsTrackStackChildren.add(_actsTrackImage);
    _counterTrayStackChildren.clear();
    _counterTrayStackChildren.add(_counterTrayImage);

    _pieceStackKeys.clear();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutLands(appState);
      layoutBoxes(appState);
      layoutTrack(appState);
      layoutActsTrack(appState);
      layoutGreatTheologians(appState);

      const choiceTexts = {
        Choice.moveMissionary: 'Move Missionary',
        Choice.moveApostleFree: 'Move Apostle for free',
        Choice.buildHospital: 'Build Hospital',
        Choice.buildMonastery: 'Build Monastery',
        Choice.buildUniversity: 'Build University',
        Choice.buildMelkite: 'Build Melkite',
        Choice.moveCapital: 'Move Roman Capital',
        Choice.moveKnightPrayForPeace: 'Move Knights or Pray for Peace',
        Choice.translateBible: 'Translate Bible',
        Choice.endHeresy: 'End Heresy',
        Choice.convertHorde: 'Convert Horde',
        Choice.convertTyrant: 'Convert Tyrant',
        Choice.evangelism: 'Great Theologian Evangelism',
        Choice.evangelismComplete: 'Evangelism Complete',
        Choice.revivalism: 'Great Theologian Revivalism',
        Choice.reconciliation: 'Great Theologian Reconciliation',
        Choice.persecute: 'Persecute',
        Choice.offensive: 'Offensive',
        Choice.sellRelics: 'Sell Relics',
        Choice.reconquista: 'Reconquista',
        Choice.paySolidi: '\$1',
        Choice.payBible: 'Bible',
        Choice.payIsis: 'Cult of Isis',
        Choice.payJames: 'James the Just',
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
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.5)),
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
                  width: _mapWidth + _actsTrackWidth + _counterTrayWidth,
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
                        child: Stack(children: _actsTrackStackChildren),
                      ),
                      Positioned(
                        left: _mapWidth + _actsTrackWidth,
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

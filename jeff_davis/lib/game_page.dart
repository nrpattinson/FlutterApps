import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:jeff_davis/game.dart';
import 'package:jeff_davis/main.dart';

enum BoardArea {
  map,
  display,
  tray,
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
  static const _mapHeight = 1056.0;
  static const _displayWidth = 816.0;
  static const _displayHeight = 1056.0;
  static const _trayWidth = 816.0;
  static const _trayHeight = 1056.0;

  final _displayOptionsFormKey = GlobalKey<FormState>();
 
  bool _emptyMap = false;

  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _displayImage = Image.asset('assets/images/display.png', key: UniqueKey(), width: _displayWidth, height: _displayHeight);
  final _trayImage = Image.asset('assets/images/tray.png', key: UniqueKey(), width: _trayWidth, height: _trayHeight);
  final _mapStackChildren = <Widget>[];
  final _displayStackChildren = <Widget>[];
  final _trayStackChildren = <Widget>[];

  final _pieceStackKeys = <Piece,StackKey>{};
  final _expandedStacks = <StackKey>[];

  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.general2Lee0: 'general_lee_2',
      Piece.general2Lee1: 'general_lee_2',
      Piece.general2Lee2: 'general_lee_2',
      Piece.general2Jackson0: 'general_jackson_2',
      Piece.general2Jackson1: 'general_jackson_2',
      Piece.general2Longstreet: 'general_longstreet_2',
      Piece.general2Pemberton: 'general_pemberton_2',
      Piece.general2Beauregard: 'general_beauregard_2',
      Piece.general2Early: 'general_early_2',
      Piece.general2Hardee: 'general_hardee_2',
      Piece.general2Hood: 'general_hood_2',
      Piece.general2ASJohnston: 'general_as_johnston_2',
      Piece.general2JJohnston: 'general_j_johnston_2',
      Piece.general2Ewell: 'general_ewell_2',
      Piece.general2Bragg: 'general_bragg_2',
      Piece.general2APHill: 'general_ap_hill_2',
      Piece.general2Stuart0: 'general_stuart_2',
      Piece.general2Stuart1: 'general_stuart_2',
      Piece.general2VanDorn: 'general_van_dorn_2',
      Piece.generalBritish2: 'general_napier_2',
      Piece.generalFrench2: 'general_bazaine_2',
      Piece.general1Lee0: 'general_lee_1',
      Piece.general1Lee1: 'general_lee_1',
      Piece.general1Lee2: 'general_lee_1',
      Piece.general1Jackson0: 'general_jackson_1',
      Piece.general1Jackson1: 'general_jackson_1',
      Piece.general1Longstreet: 'general_longstreet_1',
      Piece.general1Pemberton: 'general_pemberton_1',
      Piece.general1Beauregard: 'general_beauregard_1',
      Piece.general1Early: 'general_early_1',
      Piece.general1Hardee: 'general_hardee_1',
      Piece.general1Hood: 'general_hood_1',
      Piece.general1ASJohnston: 'general_as_johnston_1',
      Piece.general1JJohnston: 'general_j_johnston_1',
      Piece.general1Ewell: 'general_ewell_1',
      Piece.general1Bragg: 'general_bragg_1',
      Piece.general1APHill: 'general_ap_hill_1',
      Piece.general1Stuart0: 'general_stuart_1',
      Piece.general1Stuart1: 'general_stuart_1',
      Piece.general1VanDorn: 'general_van_dorn_1',
      Piece.generalBritish1: 'general_napier_1',
      Piece.generalFrench1: 'general_bazaine_1',
      Piece.cavalry2Stuart: 'cavalry_stuart_2',
      Piece.cavalry2Wheeler: 'cavalry_wheeler_2',
      Piece.cavalry1Hampton: 'cavalry_hampton_1',
      Piece.cavalry1Forrest: 'cavalry_forrest_1',
      Piece.campaignModifierShelbyP1: 'shelby',
      Piece.cssHunley: 'css_hunley',
      Piece.armyMcClellan0: 'union_mcclellan',
      Piece.armyMcClellan1: 'union_mcclellan',
      Piece.armyMiddleDepartment: 'union_middle_department',
      Piece.armyCumberland: 'union_army_cumberland',
      Piece.armyGulf: 'union_army_gulf',
      Piece.armyButler: 'union_butler',
      Piece.armyGrant4: 'union_grant_4',
      Piece.armyPotomac: 'union_army_potomac',
      Piece.armyJames: 'union_army_james',
      Piece.armySheridan: 'union_sheridan',
      Piece.armySherman: 'union_sherman',
      Piece.armyBanks: 'union_banks',
      Piece.armyGrant5: 'union_grant_5',
      Piece.freedmen2_0: 'freedmen_2',
      Piece.freedmen2_1: 'freedmen_2',
      Piece.freedmen2_2: 'freedmen_2',
      Piece.freedmen2_3: 'freedmen_2',
      Piece.freedmen1_0: 'freedmen_1',
      Piece.freedmen1_1: 'freedmen_1',
      Piece.freedmen1_2: 'freedmen_1',
      Piece.freedmen1_3: 'freedmen_1',
      Piece.lincoln: 'union_lincoln',
      Piece.washingtonInPanic: 'washington_panic',
      Piece.sustainedOffensive: 'sustained_offensive',
      Piece.surpriseOffensive: 'surprise_offensive',
      Piece.grantPromoted: 'grant_promoted_east',
      Piece.agricultureLevel: 'level_agriculture',
      Piece.manufactureLevel: 'level_manufacture',
      Piece.infrastructureLevel: 'level_infrastructure',
      Piece.plantation0: 'plantation',
      Piece.plantation1: 'plantation',
      Piece.plantation2: 'plantation',
      Piece.plantation3: 'plantation',
      Piece.plantationDepleted0: 'plantation_depleted',
      Piece.plantationDepleted1: 'plantation_depleted',
      Piece.plantationDepleted2: 'plantation_depleted',
      Piece.plantationDepleted3: 'plantation_depleted',
      Piece.rrCompany0: 'rr_company',
      Piece.rrCompany1: 'rr_company',
      Piece.rrCompany2: 'rr_company',
      Piece.rrCompany3: 'rr_company',
      Piece.factory0: 'factory',
      Piece.factory1: 'factory',
      Piece.factory2: 'factory',
      Piece.factory3: 'factory',
      Piece.usBase0: 'us_base',
      Piece.usBase1: 'us_base',
      Piece.usBase2: 'us_base',
      Piece.usBase3: 'us_base',
      Piece.usBase4: 'us_base',
      Piece.usBase5: 'us_base',
      Piece.usBase6: 'us_base',
      Piece.usBase7: 'us_base',
      Piece.slaves2_0: 'slaves_2',
      Piece.slaves2_1: 'slaves_2',
      Piece.slaves2_2: 'slaves_2',
      Piece.slaves2_3: 'slaves_2',
      Piece.slaves2_4: 'slaves_2',
      Piece.slaves2_5: 'slaves_2',
      Piece.slaves2_6: 'slaves_2',
      Piece.slaves2_7: 'slaves_2',
      Piece.slaves1_0: 'slaves_1',
      Piece.slaves1_1: 'slaves_1',
      Piece.slaves1_2: 'slaves_1',
      Piece.slaves1_3: 'slaves_1',
      Piece.slaves1_4: 'slaves_1',
      Piece.slaves1_5: 'slaves_1',
      Piece.slaves1_6: 'slaves_1',
      Piece.slaves1_7: 'slaves_1',
      Piece.anaconda0: 'anaconda_plan_landing',
      Piece.anaconda1: 'anaconda_plan_landing',
      Piece.anaconda2: 'anaconda_plan_landing',
      Piece.anaconda3: 'anaconda_plan_landing',
      Piece.frigate0: 'frigate_brooklyn',
      Piece.frigate1: 'frigate_iroquois',
      Piece.frigate2: 'frigate_james_adger',
      Piece.frigate3: 'frigate_kansas',
      Piece.blockadeRunner0: 'blockade_runner_advance',
      Piece.blockadeRunner1: 'blockade_runner_re_lee',
      Piece.blockadeRunner2: 'blockade_runner_sumter',
      Piece.blockadeRunner3: 'blockade_runner_syren',
      Piece.campaignModifierIndianWatieP1: 'indian_watie',
      Piece.campaignModifierIndianChoctawP1: 'indian_choctaw',
      Piece.campaignResultMormonRebels: 'mormon_rebels',
      Piece.politicianDavis: 'politician_davis',
      Piece.politicianStephens: 'politician_stephens',
      Piece.politicianToombs: 'politician_toombs',
      Piece.politicianHunter: 'politician_hunter',
      Piece.politicianBenjamin: 'politician_benjamin',
      Piece.politicianReagan: 'politician_reagan',
      Piece.politicianRandolph: 'politician_randolph',
      Piece.politicianSeddon: 'politician_seddon',
      Piece.politicianMallory: 'politician_mallory',
      Piece.politicianWatts: 'politician_watts',
      Piece.politicianMemminger: 'politician_memminger',
      Piece.politicianTrenholm: 'politician_trenholm',
      Piece.politicianXDavis: 'politician_davis_x',
      Piece.politicianXStephens: 'politician_stephens_x',
      Piece.politicianXToombs: 'politician_toombs_x',
      Piece.politicianXHunter: 'politician_hunter_x',
      Piece.politicianXBenjamin: 'politician_benjamin_x',
      Piece.politicianXReagan: 'politician_reagan_x',
      Piece.politicianXRandolph: 'politician_randolph_x',
      Piece.politicianXSeddon: 'politician_seddon_x',
      Piece.politicianXMallory: 'politician_mallory_x',
      Piece.politicianXWatts: 'politician_watts_x',
      Piece.politicianXMemminger: 'politician_memminger_x',
      Piece.politicianXTrenholm: 'politician_trenholm_x',
      Piece.kentuckyNeutral0: 'kentucky_neutral',
      Piece.kentuckyNeutral1: 'kentucky_neutral',
      Piece.kentuckyNeutral2: 'kentucky_neutral',
      Piece.campaignModifierKentuckyUnionN1: 'kentucky_union',
      Piece.campaignModifierKentuckyRebelP1: 'kentucky_rebel',
      Piece.missouriRebel2_0: 'missouri_rebel_2',
      Piece.missouriRebel2_1: 'missouri_rebel_2',
      Piece.missouriRebel2_2: 'missouri_rebel_2',
      Piece.missouriRebel1_0: 'missouri_rebel_1',
      Piece.missouriRebel1_1: 'missouri_rebel_1',
      Piece.missouriRebel1_2: 'missouri_rebel_1',
      Piece.linesCutP1_0: 'lines_cut_p1',
      Piece.linesCutP1_1: 'lines_cut_p1',
      Piece.linesCutP1_2: 'lines_cut_p1',
      Piece.linesCutP1_3: 'lines_cut_p1',
      Piece.linesCutP1_4: 'lines_cut_p1',
      Piece.linesCutN1_0: 'lines_cut_n1',
      Piece.linesCutN1_1: 'lines_cut_n1',
      Piece.linesCutN1_2: 'lines_cut_n1',
      Piece.linesCutN1_3: 'lines_cut_n1',
      Piece.linesCutN1_4: 'lines_cut_n1',
      Piece.campaignSuccess0: 'campaign_success',
      Piece.campaignSuccess1: 'campaign_success',
      Piece.campaignSuccess2: 'campaign_success',
      Piece.campaignSuccess3: 'campaign_success',
      Piece.campaignSuccess4: 'campaign_success',
      Piece.campaignSuccess5: 'campaign_success',
      Piece.campaignSuccess6: 'campaign_success',
      Piece.campaignFailure0: 'campaign_failure',
      Piece.campaignFailure1: 'campaign_failure',
      Piece.campaignFailure2: 'campaign_failure',
      Piece.campaignFailure3: 'campaign_failure',
      Piece.campaignFailure4: 'campaign_failure',
      Piece.campaignFailure5: 'campaign_failure',
      Piece.campaignFailure6: 'campaign_failure',
      Piece.nextCampaign: 'next_campaign',
      Piece.defensiveWorks0: 'defensive_works',
      Piece.defensiveWorks1: 'defensive_works',
      Piece.defensiveWorks2: 'defensive_works',
      Piece.defensiveWorks3: 'defensive_works',
      Piece.artillery0: 'artillery',
      Piece.artillery1: 'artillery',
      Piece.artillery2: 'artillery',
      Piece.artillery3: 'artillery',
      Piece.ironclad0: 'ironclad',
      Piece.ironclad1: 'ironclad',
      Piece.ironclad2: 'ironclad',
      Piece.ironclad3: 'ironclad',
      Piece.train0: 'trains',
      Piece.train1: 'trains',
      Piece.train2: 'trains',
      Piece.train3: 'trains',
      Piece.trenches: 'trenches',
      Piece.bushwhacker0: 'bushwhacker_2',
      Piece.bushwhacker1: 'bushwhacker_3',
      Piece.bushwhacker2: 'bushwhacker_3',
      Piece.bushwhacker3: 'bushwhacker_4',
      Piece.crisis: 'crisis',
      Piece.csaTreasury: 'treasury',
      Piece.specialBudget: 'special_campaign_budget',
      Piece.statesRights: 'states_rights',
      Piece.lostCause: 'lost_cause',
      Piece.objective: 'objective',
      Piece.closedPath5: 'path_closed',
      Piece.closedPath6: 'path_closed',
      Piece.turnChit1: 'chit_info_1',
      Piece.turnChit2: 'chit_info_2',
      Piece.turnChit3: 'chit_info_3',
      Piece.turnChit4: 'chit_info_4',
      Piece.turnChit5: 'chit_info_5',
      Piece.turnChit6: 'chit_info_6',
      Piece.turnChit7: 'chit_info_7',
      Piece.turnChit8: 'chit_info_8',
      Piece.turnChit9: 'chit_info_9',
      Piece.turnChit10: 'chit_info_10',
      Piece.turnChit11: 'chit_info_11',
      Piece.turnChit12: 'chit_info_12',
      Piece.turnChit13: 'chit_info_13',
      Piece.turnChit14: 'chit_info_14',
      Piece.turnChit15: 'chit_info_15',
      Piece.turnChit16: 'chit_info_16',
      Piece.turnChit17: 'chit_info_17',
      Piece.turnChit18: 'chit_info_18',
      Piece.turnChit19: 'chit_info_19',
      Piece.turnChit20: 'chit_info_20',
      Piece.turnChit21: 'chit_info_21',
      Piece.turnChit22: 'chit_info_22',
      Piece.turnChit23: 'chit_info_23',
      Piece.turnChit24: 'chit_info_24',
      Piece.turnChit25: 'chit_info_25',
      Piece.turnChit26: 'chit_info_26',
      Piece.turnChit27: 'chit_info_27',
      Piece.turnChit28: 'chit_info_28',
      Piece.turnChit29: 'chit_info_29',
      Piece.turnChit30: 'chit_info_30',
      Piece.turnChit31: 'chit_info_31',
      Piece.turnChit32: 'chit_info_32',
      Piece.turnChit33: 'chit_info_33',
      Piece.turnChit34: 'chit_info_34',
      Piece.turnChit35: 'chit_info_35',
      Piece.turnChit36: 'chit_info_36',
      Piece.turnChit37: 'chit_info_37',
      Piece.turnChit38: 'chit_info_38',
      Piece.turnChit39: 'chit_info_39',
      Piece.turnChit40: 'chit_info_40',
      Piece.turnChit41: 'chit_info_41',
      Piece.turnChit42: 'chit_info_42',
      Piece.turnChit43: 'chit_info_43',
      Piece.turnChit44: 'chit_info_44',
      Piece.turnChitCoatOfArms1: 'chit_back_1',
      Piece.turnChitCoatOfArms2: 'chit_back_2',
      Piece.turnChitCoatOfArms3: 'chit_back_3',
      Piece.turnChitCoatOfArms4: 'chit_back_4',
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
    case BoardArea.display:
      _displayStackChildren.add(widget);
    case BoardArea.tray:
      _trayStackChildren.add(widget);
    }
  }

  void addRegionToMap(MyAppState appState, Location region, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(region);
    bool selected = playerChoices.selectedLocations.contains(region);

    if (!choosable && !selected) {
      return;
    }

    Widget widget = const SizedBox(
      height: 77.0,
      width: 77.0,
    );

    final boxDecoration = BoxDecoration(
      shape: BoxShape.rectangle,
      color: Colors.transparent,
      border: Border.all(color: choosable ? Colors.yellow : Colors.green, width: 9.0),
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
            appState.choseLocation(region);
          },
          child: widget,
        ),
      );
    }

    widget = Positioned(
      left: x - 8.0,
      top: y - 8.0,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.regionRichmond: (BoardArea.map, 923.0, 227.0),
      Location.regionHanoverCounty: (BoardArea.map, 0.0, 0.0),
      Location.regionTheRappahannock: (BoardArea.map, 0.0, 0.0),
      Location.regionManassas: (BoardArea.map, 1064.5, 15.25),
      Location.regionWashingtonDC: (BoardArea.map, 1187.0, 19.0),
      Location.regionLynchburg: (BoardArea.map, 0.0, 0.0),
      Location.regionShenandoahValley: (BoardArea.map, 782.0, 116.0),
      Location.regionHarpersFerry: (BoardArea.map, 821.0, 13.5),
      Location.regionMarylandAndPennsylvania: (BoardArea.map, 941.0, 15.0),
      Location.regionBermudaHundred: (BoardArea.map, 0.0, 0.0),
      Location.regionWilliamsburg: (BoardArea.map, 0.0, 0.0),
      Location.regionYorktown: (BoardArea.map, 1269.0, 234.5),
      Location.regionFortMonroe: (BoardArea.map, 1264.0, 348.0),
      Location.regionFayetteville: (BoardArea.map, 1004.0, 336.0),
      Location.regionColumbia: (BoardArea.map, 864.0, 431.0),
      Location.regionSavannah: (BoardArea.map, 857.0, 618.0),
      Location.regionAtlanta: (BoardArea.map, 679.0, 528.0),
      Location.regionChattanooga: (BoardArea.map, 658.0, 401.0),
      Location.regionNashville: (BoardArea.map, 546.0, 377.0),
      Location.regionBowlingGreen: (BoardArea.map, 532.0, 245.0),
      Location.regionLouisville: (BoardArea.map, 515.0, 118.0),
      Location.regionCincinnati: (BoardArea.map, 660.0, 124.0),
      Location.regionVicksburg: (BoardArea.map, 0.0, 0.0),
      Location.regionJackson: (BoardArea.map, 345.0, 635.0),
      Location.regionTheDelta: (BoardArea.map, 345.0, 513.0),
      Location.regionMemphis: (BoardArea.map, 0.0, 0.0),
      Location.regionCorinth: (BoardArea.map, 405.0, 396.0),
      Location.regionPaducah: (BoardArea.map, 405.0, 256.0),
      Location.regionCairo: (BoardArea.map, 290.0, 190.0),
      Location.regionEastTexas: (BoardArea.map, 0.0, 0.0),
      Location.regionRedRiver: (BoardArea.map, 100.0, 599.0),
      Location.regionPortHudson: (BoardArea.map, 0.0, 0.0),
      Location.regionNewOrleans: (BoardArea.map, 296.0, 780.0),
      Location.regionShipIsland: (BoardArea.map, 0.0, 0.0),
      Location.portNewBern: (BoardArea.map, 0.0, 0.0),
      Location.portWilmington: (BoardArea.map, 0.0, 0.0),
      Location.portCharleston: (BoardArea.map, 0.0, 0.0),
      Location.portFernandina: (BoardArea.map, 0.0, 0.0),
      Location.portMobile: (BoardArea.map, 0.0, 0.0),
      Location.campaignNewMexico: (BoardArea.map, 0.0, 0.0),
      Location.campaignHeartlandOffensive: (BoardArea.map, 0.0, 0.0),
      Location.campaignMorgansRaid: (BoardArea.map, 0.0, 0.0),
      Location.campaignIndianTerritory: (BoardArea.map, 0.0, 0.0),
      Location.campaignArkansas: (BoardArea.map, 0.0, 0.0),
      Location.campaignKirksRaiders: (BoardArea.map, 0.0, 0.0),
      Location.campaignPriceInMissouri: (BoardArea.map, 0.0, 0.0),
      Location.boxCampaignRedStar: (BoardArea.map, 67.0, 962.5),
      Location.boxDavisRevolution: (BoardArea.map, 1166.0, 528.0),
      Location.boxAgriculture0: (BoardArea.map, 968.0, 777.0),
      Location.boxManufacture0: (BoardArea.map, 968.0, 864.0),
      Location.boxInfrastructure0: (BoardArea.map, 968.0, 951.0),
      Location.boxSlaveQuarters: (BoardArea.map, 458.0, 486.0),
      Location.boxFreedmen: (BoardArea.map, 0.0, 0.0),
      Location.boxConfederateGovernment: (BoardArea.map, 1391.0, 235.0),
      Location.boxDisgruntledConfederates: (BoardArea.map, 0.0, 0.0),
      Location.poolCsaGenerals: (BoardArea.map, 1263.0, 544.0),
      Location.boxBlockade1a: (BoardArea.display, 0.0, 0.0),
      Location.boxBlockade1b: (BoardArea.display, 0.0, 0.0),
      Location.boxBlockade2a: (BoardArea.display, 0.0, 0.0),
      Location.boxBlockade2b: (BoardArea.display, 0.0, 0.0),
      Location.boxBlockade2c: (BoardArea.display, 0.0, 0.0),
      Location.boxBlockade3: (BoardArea.display, 0.0, 0.0),
      Location.boxBlockade4: (BoardArea.display, 0.0, 0.0),
      Location.boxUnionFrigates: (BoardArea.display, 357.0, 175.0),
      Location.boxEnglishShipyards: (BoardArea.display, 517.0, 175.0),
      Location.boxBlockadeRunners: (BoardArea.display, 603.0, 175.0),
      Location.treasury0: (BoardArea.display, 55.0, 318.5),
      Location.turn0: (BoardArea.display, 54.0, 498.0),
      Location.trayTurn: (BoardArea.tray, 0.0, 0.0),
      Location.trayConfederateForces: (BoardArea.tray, 54.0, 265.0),
      Location.trayUnionForces: (BoardArea.tray, 417.0, 265.0),
      Location.trayEconomic: (BoardArea.tray, 0.0, 0.0),
      Location.trayOtherForces: (BoardArea.tray, 417.0, 369.0),
      Location.trayPolitical: (BoardArea.tray, 54.0, 448.0),
      Location.trayStrategic: (BoardArea.tray, 417.0, 446.0),
      Location.trayMilitary: (BoardArea.tray, 54.0, 545.0),
      Location.trayVarious: (BoardArea.tray, 417.0, 550.0),
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
        final sk = (box, stackIndex);
        if (_expandedStacks.contains(sk) == (pass == 1)) {
          for (int pieceIndex = stackIndex; pieceIndex < pieces.length; pieceIndex += stackCount) {
            stackPieces.add(pieces[pieceIndex]);
          }
          if (stackPieces.isNotEmpty) {
            double xStack = x + col * dxStack;
            double yStack = y + row * dyStack;
            layoutStack(appState, sk, stackPieces, boardArea, xStack, yStack, dxPiece, dyPiece);
          }
        }
      }
    }
  }

  int mapPieceZ(GameState state, Piece piece) {
    int z = 100;
    if (piece.isType(PieceType.asset)) {
      z = 0;
    } else if (piece == Piece.lincoln) {
      z = 1;
    } else if (piece.isType(PieceType.general)) {
      z = 2;
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

  void layoutRegion(MyAppState appState, Location region, int pass) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(region);
    final xRegion = coordinates.$2;
    final yRegion = coordinates.$3;

    if (pass == 0 && appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(region)) {
      addRegionToMap(appState, region, xRegion, yRegion);
    }

    final sk = (region, 0);
    if (_expandedStacks.contains(sk) == (pass == 1)) {
      final pieces = state.piecesInLocation(PieceType.all, region);
      pieces.sort((a, b) => mapPieceZOrder(state, a, b));
      layoutStack(appState, sk, pieces, BoardArea.map, xRegion, yRegion, 4.0, 4.0);
    }
 
    if (pass == 1 &&appState.playerChoices != null && appState.playerChoices!.locations.contains(region)) {
      addRegionToMap(appState, region, xRegion, yRegion);
    }
  }

  void layoutRegions(MyAppState appState, int pass) {
    for (final region in LocationType.region.locations) {
      layoutRegion(appState, region, pass);
    }
  }

  void layoutBoxes(MyAppState appState, int pass) {
    const boxesInfo = {
      Location.boxDavisRevolution: (1, 1, 0.0, 0.0),
      Location.boxSlaveQuarters: (3, 2, 10.0, 10.0),
      Location.boxFreedmen: (1, 1, 0.0, 0.0),
      Location.boxConfederateGovernment: (3, 4, 10.0, 3.0),
      Location.boxDisgruntledConfederates: (1, 1, 0.0, 0.0),
      Location.poolCsaGenerals: (5, 3, 10.0, 5.0),
      Location.boxUnionFrigates: (2, 1, 15.0, 0.0),
      Location.boxEnglishShipyards: (1, 1, 0.0, 0.0),
      Location.boxBlockadeRunners: (2, 1, 15.0, 0.0),
      Location.trayTurn: (10, 1, 10.0, 0.0),
      Location.trayConfederateForces: (5, 1, 10.0, 0.0),
      Location.trayUnionForces: (5, 1, 10.0, 0.0),
      Location.trayEconomic: (5, 1, 10.0, 0.0),
      Location.trayOtherForces: (5, 1, 10.0, 0.0),
      Location.trayPolitical: (5, 1, 10.0, 0.0),
      Location.trayStrategic: (5, 1, 10.0, 0.0),
      Location.trayMilitary: (5, 1, 10.0, 0.0),
      Location.trayVarious: (5, 1, 10.0, 0.0),
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
      layoutBoxStacks(appState, box, pass, state.piecesInLocation(PieceType.all, box), boardArea, cols, rows, xBox, yBox, 60.0 + xGap, 60.0 + yGap, 4.0, 4.0);
    }
  }

  void layoutCampaignTrack(MyAppState appState) {
    final state = appState.gameState!;
    final coordinatesFirst = locationCoordinates(LocationType.campaignTrack.locations[0]);
    final xFirst = coordinatesFirst.$2;
    final yBox = coordinatesFirst.$3;
    for (final box in LocationType.campaignTrack.locations) {
      final xBox = xFirst + (box.index - LocationType.campaignTrack.firstIndex) * 88.0;
      if (state.pieceLocation(Piece.nextCampaign) == box) {
        addPieceToBoard(appState, Piece.nextCampaign, BoardArea.map, xBox, yBox);
      }
    }
  }

  void layoutEconomicTrack(MyAppState appState, LocationType locationType, Piece piece) {
    final state = appState.gameState!;
    final coordinatesFirst = locationCoordinates(locationType.locations[0]);
    final xFirst = coordinatesFirst.$2;
    final yBox = coordinatesFirst.$3;
    for (final box in locationType.locations) {
      final xBox = xFirst + (box.index - locationType.firstIndex) * 88.0;
      if (state.pieceLocation(piece) == box) {
        addPieceToBoard(appState, piece, BoardArea.map, xBox, yBox);
      }
    }
  }

  void layoutEconomicTracks(MyAppState appState) {
    const trackInfos = [
      (LocationType.agriculture, Piece.agricultureLevel),
      (LocationType.manufacture, Piece.manufactureLevel),
      (LocationType.infrastructure, Piece.infrastructureLevel),
    ];
    for (final trackInfo in trackInfos) {
      layoutEconomicTrack(appState, trackInfo.$1, trackInfo.$2);
    }
  }

  void layoutTreasury(MyAppState appState) {
    final state = appState.gameState!;
    final coordinatesFirst = locationCoordinates(LocationType.treasury.locations[0]);
    final xFirst = coordinatesFirst.$2;
    final yBox = coordinatesFirst.$3;
    for (final box in LocationType.treasury.locations) {
      final xBox = xFirst + (box.index - LocationType.treasury.firstIndex) * 88.0;
      final pieces = state.piecesInLocation(PieceType.treasury, box);
      for (int i = 0; i < pieces.length; ++i) {
        final x = xBox + i * 70.0;
        final y = yBox;
        addPieceToBoard(appState, pieces[i], BoardArea.display, x, y);
      }
    }
  }

  void layoutCalendar(MyAppState appState) {
      final state = appState.gameState!;
    final coordinates = locationCoordinates(Location.turn0);
    double xFirst = coordinates.$2;
    double yFirst = coordinates.$3;
    for (final box in LocationType.calendar.locations) {
      int index = box.index - LocationType.calendar.firstIndex;
      int col = index % 7;
      int row = index ~/ 7;
      double xBox = xFirst + col * 102.7;
      double yBox = yFirst + row * 66.4;
      final others = <Piece>[];
      Piece? turnChit;
      for (final piece in state.piecesInLocation(PieceType.all, box)) {
        if (piece.isType(PieceType.turnChit) || piece.isType(PieceType.turnChitGreenCoatOfArms)) {
          turnChit = piece;
        } else {
          others.add(piece);
        }
      }
      for (int i = 0; i < others.length; ++i) {
        double x = xBox + 34.0 - i * 10.0;
        double y = yBox;
        addPieceToBoard(appState, others[i], BoardArea.display, x, y);
      }
      if (turnChit != null) {
        double x = xBox;
        double y = yBox;
        addPieceToBoard(appState, turnChit, BoardArea.display, x, y);
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
    _displayStackChildren.clear();
    _displayStackChildren.add(_displayImage);
    _trayStackChildren.clear();
    _trayStackChildren.add(_trayImage);

    _pieceStackKeys.clear();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutCampaignTrack(appState);
      layoutEconomicTracks(appState);
      layoutTreasury(appState);
      layoutCalendar(appState);
      layoutBoxes(appState, 0);
      layoutRegions(appState, 0);
      layoutBoxes(appState, 1);
      layoutRegions(appState, 1);

      const choiceTexts = {
        Choice.concedeCampaign: 'Concede Campaign',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300.0,
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
                  width: _mapWidth + _displayWidth + _trayWidth,
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
                      Positioned(
                        left: _mapWidth + _displayWidth,
                        top: 0.0,
                        child: Stack(children: _trayStackChildren),
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

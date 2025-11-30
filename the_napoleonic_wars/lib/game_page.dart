import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import 'package:the_napoleonic_wars/game.dart';
import 'package:the_napoleonic_wars/main.dart';

enum BoardArea {
  map,
  turnTrack,
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
  static const _mapWidth = 1632.0;
  static const _mapHeight = 1056.0;
  static const _turnTrackWidth = 816.0;
  static const _turnTrackHeight = 1056.0;
  static const _counterTrayWidth = 816.0;
  static const _counterTrayHeight = 1056.0;

  final _displayOptionsFormKey = GlobalKey<FormState>();
 
  bool _emptyMap = false;

  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _turnTrackImage = Image.asset('assets/images/turn.png', key: UniqueKey(), width: _turnTrackWidth, height: _turnTrackHeight);
  final _counterTrayImage = Image.asset('assets/images/tray.png', key: UniqueKey(), width: _counterTrayWidth, height: _counterTrayHeight);
  final _mapStackChildren = <Widget>[];
  final _turnTrackStackChildren = <Widget>[];
  final _counterTrayStackChildren = <Widget>[];

  final _pieceStackKeys = <Piece,StackKey>{};
  final _expandedStacks = <StackKey>[];

  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.corpsFranceImperialGuard: 'corps_france_imperial_guard',
      Piece.corpsFranceBernadotte: 'corps_france_bernadotte',
      Piece.corpsFranceBerthier: 'corps_france_berthier',
      Piece.corpsFranceBessieres: 'corps_france_bessieres',
      Piece.corpsFranceDavoust: 'corps_france_davoust',
      Piece.corpsFranceDupont: 'corps_france_dupont',
      Piece.corpsFranceEugene: 'corps_france_eugene',
      Piece.corpsFranceGrouchy: 'corps_france_grouchy',
      Piece.corpsFranceJunot: 'corps_france_junot',
      Piece.corpsFranceKellermann: 'corps_france_kellermann',
      Piece.corpsFranceKleber: 'corps_france_kleber',
      Piece.corpsFranceLannes: 'corps_france_lannes',
      Piece.corpsFranceMacDonald: 'corps_france_macdonald',
      Piece.corpsFranceMarmont: 'corps_france_marmont',
      Piece.corpsFranceMassena: 'corps_france_massena',
      Piece.corpsFranceMoreau: 'corps_france_moreau',
      Piece.corpsFranceMortier: 'corps_france_mortier',
      Piece.corpsFranceMurat: 'corps_france_murat',
      Piece.corpsFranceNey: 'corps_france_ney',
      Piece.corpsFranceOudinot: 'corps_france_oudinot',
      Piece.corpsFranceSaintCyr: 'corps_france_saintcyr',
      Piece.corpsFranceSoult: 'corps_france_soult',
      Piece.corpsFranceSuchet: 'corps_france_suchet',
      Piece.corpsFranceVictor: 'corps_france_victor',
      Piece.corpsWarsaw: 'corps_warsaw',
      Piece.corpsNaples: 'corps_naples',
      Piece.corpsBavariaFrench: 'corps_bavaria',
      Piece.corpsAustriaBellegarde: 'corps_austria_bellegarde',
      Piece.corpsAustriaKarl: 'corps_austria_karl',
      Piece.corpsAustriaRadetzky: 'corps_austria_radetzky',
      Piece.corpsAustriaSchwarzenberg: 'corps_austria_schwarzenberg',
      Piece.corpsBavariaAustrian: 'corps_bavaria',
      Piece.corpsBritainBeresford: 'corps_britain_beresford',
      Piece.corpsBritainUxbridge: 'corps_britain_uxbridge',
      Piece.corpsBritainWellington: 'corps_britain_wellington',
      Piece.corpsPrussiaBlucher: 'corps_prussia_blucher',
      Piece.corpsPrussiaBraunschweig: 'corps_prussia_braunschweig',
      Piece.corpsPrussiaKleist: 'corps_prussia_kleist',
      Piece.corpsPrussiaYorck: 'corps_prussia_yorck',
      Piece.corpsRussiaBagration: 'corps_russia_bagration',
      Piece.corpsRussiaBarclay: 'corps_russia_barclay',
      Piece.corpsRussiaBennigsen: 'corps_russia_bennigsen',
      Piece.corpsRussiaKutuzov: 'corps_russia_kutuzov',
      Piece.corpsRussiaPlatov: 'corps_russia_platov',
      Piece.corpsSpainBlake: 'corps_spain_blake',
      Piece.corpsSpainPalafox: 'corps_spain_palafox',
      Piece.corpsSweden: 'corps_sweden',
      Piece.corpsDuchyFusiliers0: 'corps_duchy_fusiliers',
      Piece.corpsDuchyFusiliers1: 'corps_duchy_fusiliers',
      Piece.corpsDuchyGrenadiers: 'corps_duchy_grenadiers',
      Piece.corpsDuchyGrenzer: 'corps_duchy_grenzer',
      Piece.corpsDuchyGuards0: 'corps_duchy_guards',
      Piece.corpsDuchyGuards1: 'corps_duchy_guards',
      Piece.corpsDuchyJager0: 'corps_duchy_jager',
      Piece.corpsDuchyJager1: 'corps_duchy_jager',
      Piece.corpsDuchyLandwehr: 'corps_duchy_landwehr',
      Piece.corpsDuchyMarines0: 'corps_duchy_marines',
      Piece.corpsDuchyMarines1: 'corps_duchy_marines',
      Piece.corpsDuchyMusketeers: 'corps_duchy_musketeers',
      Piece.corpsDuchyReserve: 'corps_duchy_reserve',
      Piece.corpsEmigreBourbon: 'corps_emigre_bourbon',
      Piece.corpsEmigreConde: 'corps_emigre_conde',
      Piece.corpsRoyalist: 'corps_royalist',
      Piece.napoleonB: 'napoleon_b',
      Piece.napoleonN: 'napoleon_n',
      Piece.napoleonV: 'napoleon_v',
      Piece.wifeJosephine: 'wife_josephine',
      Piece.wifeMarriage: 'wife_marriage',
      Piece.iconBeethoven: 'icon_beethoven',
      Piece.iconGoethe: 'icon_goethe',
      Piece.iconGoya: 'icon_goya',
      Piece.iconVolta: 'icon_volta',
      Piece.warBalkans: 'war_balkans',
      Piece.warCape: 'war_cape',
      Piece.warCaucasus: 'war_caucasus',
      Piece.warCorfu: 'war_corfu',
      Piece.warDenmark: 'war_denmark',
      Piece.warEgypt: 'war_egypt',
      Piece.warFinland: 'war_finland',
      Piece.warHaiti: 'war_haiti',
      Piece.warIreland: 'war_ireland',
      Piece.warMalta: 'war_malta',
      Piece.warMysore: 'war_mysore',
      Piece.warSenegal: 'war_senegal',
      Piece.warSerbia: 'war_serbia',
      Piece.warSwitzerland: 'war_switzerland',
      Piece.warUsa: 'war_usa',
      Piece.noWarRed0: 'no_war_red',
      Piece.noWarRed1: 'no_war_red',
      Piece.noWarRed2: 'no_war_red',
      Piece.noWarRed3: 'no_war_red',
      Piece.noWarRed4: 'no_war_red',
      Piece.noWarRed5: 'no_war_red',
      Piece.noWarGreen0: 'no_war_green',
      Piece.noWarGreen1: 'no_war_green',
      Piece.trafalgar: 'trafalgar',
      Piece.coronation: 'coronation',
      Piece.treatySanIldefonso: 'treaty_san_ildefonso',
      Piece.spanishUlcer: 'spanish_ulcer',
      Piece.russianWarFinland: 'russian_war',
      Piece.russianWarCaucasus: 'russian_war',
      Piece.russianWarBalkans: 'russian_war',
      Piece.russianWarCorfu: 'russian_war',
      Piece.fundAdmiralty: 'fund_admiralty',
      Piece.fundMinorWar: 'fund_minor_war',
      Piece.fundTreasury: 'fund_treasury',
      Piece.etat0: 'etat_0',
      Piece.etat1: 'etat_1',
      Piece.etat2: 'etat_2',
      Piece.etat3: 'etat_3',
      Piece.etat4: 'etat_4',
      Piece.etat5: 'etat_5',
      Piece.etat6: 'etat_6',
      Piece.etat7: 'etat_7',
      Piece.etat8: 'etat_8',
      Piece.etatWarsaw: 'etat_warsaw',
      Piece.austriaCoalition: 'status_austria_coalition',
      Piece.austriaNeutral: 'status_austria_neutral',
      Piece.prussiaCoalition: 'status_prussia_coalition',
      Piece.prussiaNeutral: 'status_prussia_neutral',
      Piece.russiaCoalition: 'status_russia_coalition',
      Piece.russiaNeutral: 'status_russia_neutral',
      Piece.spainCoalition: 'status_spain_coalition',
      Piece.spainFrench: 'status_spain_french',
      Piece.swedenCoalition: 'status_sweden_coalition',
      Piece.swedenNeutral: 'status_sweden_neutral',
      Piece.austriaSurrender: 'surrender_austria',
      Piece.prussiaSurrender: 'surrender_prussia',
      Piece.russiaSurrender: 'surrender_russia',
      Piece.scrollBasel: 'scroll_basel',
      Piece.scrollRussianNobility: 'scroll_russian_nobility',
      Piece.scrollTilsitPrussia: 'scroll_tilsit',
      Piece.scrollTilsitRussia: 'scroll_tilsit',
      Piece.diplomatFrench0: 'diplomat_french',
      Piece.diplomatFrench1: 'diplomat_french',
      Piece.diplomatFrench2: 'diplomat_french',
      Piece.diplomatFrench3: 'diplomat_french',
      Piece.diplomatFrench4: 'diplomat_french',
      Piece.diplomatFrench5: 'diplomat_french',
      Piece.diplomatFrench6: 'diplomat_french',
      Piece.diplomatFrench7: 'diplomat_french',
      Piece.diplomatFrenchReinhard: 'diplomat_french_reinhard',
      Piece.diplomatFrenchTalleyrand: 'diplomat_french_talleyrand',
      Piece.diplomatCoalitionCastlereagh: 'diplomat_coalition_castlereagh',
      Piece.diplomatCoalitionHardenberg: 'diplomat_coalition_hardenberg',
      Piece.diplomatCoalitionMetternich: 'diplomat_coalition_metternich',
      Piece.diplomatCoalitionRazumovsky: 'diplomat_coalition_razumovsky',
      Piece.religionDeist: 'religion_deist',
      Piece.religionAtheist: 'religion_atheist',
      Piece.religionUsurper: 'religion_usurper',
      Piece.religionCatholic: 'religion_catholic',
      Piece.religionSecular: 'religion_usurper',
      Piece.pounds4: 'pounds_4',
      Piece.tradeIreland: 'trade_1',
      Piece.tradeHaiti: 'trade_1',
      Piece.tradeCape: 'trade_1',
      Piece.tradeEgypt: 'trade_1',
      Piece.tradeMysore: 'trade_1',
      Piece.fervorFrance: 'fervor_france',
      Piece.fervorGermany: 'fervor_germany',
      Piece.fervorAustria: 'fervor_austria',
      Piece.fervorItaly: 'fervor_italy',
      Piece.fervorSpain: 'fervor_spain',
      Piece.jewsEmancipation: 'jews_emancipation',
      Piece.jewsGhetto: 'jews_ghetto',
      Piece.fleetCoalition: 'fleet_coalition',
      Piece.fleetFrench: 'fleet_french',
      Piece.butNation: 'but',
      Piece.continentalSystem: 'continental_system',
      Piece.fraDiavolo: 'fra_diavolo',
      Piece.nelson: 'nelson',
      Piece.ottomanArmy: 'ottoman_army',
      Piece.paris: 'paris',
      Piece.terror: 'terror',
      Piece.pope: 'pope',
      Piece.napoleonAbdicates: 'napoleon_abdicates',
      Piece.lightInfantry: 'light_infantry',
      Piece.gameTurn: 'game_turn',
      Piece.iconUnknownBeethoven: 'icon_unknown',
      Piece.iconUnknownGoethe: 'icon_unknown',
      Piece.iconUnknownGoya: 'icon_unknown',
      Piece.iconUnknownVolta: 'icon_unknown',
      Piece.warLostBalkans: 'war_lost',
      Piece.warLostCape: 'war_lost',
      Piece.warLostCaucasus: 'war_lost',
      Piece.warLostCorfu: 'war_lost',
      Piece.warLostDenmark: 'war_lost',
      Piece.warLostEgypt: 'war_lost',
      Piece.warLostFinland: 'war_lost',
      Piece.warLostHaiti: 'war_lost',
      Piece.warLostIreland: 'war_lost',
      Piece.warLostMalta: 'war_lost',
      Piece.warLostMysore: 'war_lost',
      Piece.warLostSenegal: 'war_lost',
      Piece.warLostSerbia: 'war_lost',
      Piece.warLostSwitzerland: 'war_lost',
      Piece.warLostUsa: 'war_lost',
      Piece.russianWarLostFinland: 'russian_war_lost',
      Piece.russianWarLostCaucasus: 'russian_war_lost',
      Piece.russianWarLostBalkans: 'russian_war_lost',
      Piece.russianWarLostCorfu: 'russian_war_lost',
      Piece.etatUnknown0: 'etat_unknown',
      Piece.etatUnknown1: 'etat_unknown',
      Piece.etatUnknown2: 'etat_unknown',
      Piece.etatUnknown3: 'etat_unknown',
      Piece.etatUnknown4: 'etat_unknown',
      Piece.etatUnknown5: 'etat_unknown',
      Piece.etatUnknown6: 'etat_unknown',
      Piece.etatUnknown7: 'etat_unknown',
      Piece.etatUnknown8: 'etat_unknown',
      Piece.diplomatCoalitionBusyCastlereagh: 'diplomat_coalition_busy',
      Piece.diplomatCoalitionBusyHardenberg: 'diplomat_coalition_busy',
      Piece.diplomatCoalitionBusyMetternich: 'diplomat_coalition_busy',
      Piece.diplomatCoalitionBusyRazumovsky: 'diplomat_coalition_busy',
      Piece.fleetBusyCoalition: 'fleet_busy',
      Piece.fleetBusyFrench: 'fleet_busy',
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
    if (_emptyMap && boardArea == BoardArea.map) {
      return;
    }

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
    case BoardArea.turnTrack:
      _turnTrackStackChildren.add(widget);
    case BoardArea.counterTray:
      _counterTrayStackChildren.add(widget);
    }
  }

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.nationFrance: (BoardArea.map, 323.0, 378.0),
      Location.nationGermany: (BoardArea.map, 673.0, 200.0),
      Location.nationAustria: (BoardArea.map, 1005.0, 427.0),
      Location.nationItaly: (BoardArea.map, 698.0, 726.0),
      Location.nationSpain: (BoardArea.map, 216.0, 676.0),
      Location.greenFrance: (BoardArea.map, 321.0, 546.0),
      Location.greenGermany: (BoardArea.map, 673.0, 374.0),
      Location.greenAustria: (BoardArea.map, 1005.0, 601.0),
      Location.greenItaly: (BoardArea.map, 698.0, 895.0),
      Location.greenSpain: (BoardArea.map, 216.0, 848.0),
      Location.minorBalkans: (BoardArea.map, 1318.0, 570.0),
      Location.minorCape: (BoardArea.map, 93.0, 941.0),
      Location.minorCaucasus: (BoardArea.map, 1486.0, 528.0),
      Location.minorCorfu: (BoardArea.map, 1083.0, 824.0),
      Location.minorDenmark: (BoardArea.map, 693.0, 66.0),
      Location.minorEgypt: (BoardArea.map, 1243.0, 951.0),
      Location.minorFinland: (BoardArea.map, 1105.0, 76.0),
      Location.minorHaiti: (BoardArea.map, 71.0, 551.0),
      Location.minorIreland: (BoardArea.map, 244.0, 114.0),
      Location.minorMalta: (BoardArea.map, 1010.0, 950.0),
      Location.minorMysore: (BoardArea.map, 1282.0, 821.0),
      Location.minorRussia: (BoardArea.map, 1158.0, 195.0),
      Location.minorSenegal: (BoardArea.map, 269.0, 950.0),
      Location.minorSerbia: (BoardArea.map, 1185.0, 699.0),
      Location.minorSwitzerland: (BoardArea.map, 695.0, 567.0),
      Location.minorUsa: (BoardArea.map, 131.0, 429.0),
      Location.russianWarFinland: (BoardArea.map, 1332.0, 182.0),
      Location.russianWarCaucasus: (BoardArea.map, 1332.0, 262.0),
      Location.russianWarBalkans: (BoardArea.map, 1332.0, 343.0),
      Location.russianWarCorfu: (BoardArea.map, 1331.0, 425.0),
      Location.statusAustria: (BoardArea.map, 1046.0, 310.0),
      Location.statusPrussia: (BoardArea.map, 1005.0, 191.0),
      Location.statusRussia: (BoardArea.map, 1208.0, 311.0),
      Location.statusSpain: (BoardArea.map, 483.0, 940.0),
      Location.statusSweden: (BoardArea.map, 957.0, 71.0),
      Location.lightInfantryBernadotte: (BoardArea.map, 1472.0, 720.0),
      Location.lightInfantryFrenchDomination: (BoardArea.map, 1472.0, 794.0),
      Location.lightInfantryFrenchAdvantage: (BoardArea.map, 1472.0, 882.0),
      Location.lightInfantryNoAdvantage: (BoardArea.map, 1472.0, 971.0),
      Location.boxLondon: (BoardArea.map, 429.0, 263.0),
      Location.boxHighSeas: (BoardArea.map, 107.0, 286.0),
      Location.boxFranceReligion: (BoardArea.map, 655.0, 486.0),
      Location.boxHotel: (BoardArea.map, 578.0, 780.0),
      Location.boxJews: (BoardArea.map, 887.0, 518.0),
      Location.boxNapoleonsBed: (BoardArea.map, 545.0, 670.0),
      Location.boxCasualties: (BoardArea.map, 40.0, 40.0),
      Location.boxPortugal: (BoardArea.map, 40.0, 750.0),
      Location.poolPlayerForces: (BoardArea.turnTrack, 393.0, 847.0),
      Location.poolNeutralForces: (BoardArea.map, 431.0, 96.0),
      Location.turn0: (BoardArea.turnTrack, 80.0, 143.0),
      Location.trayImperialGuard: (BoardArea.counterTray, 557.0, 318.0),
      Location.trayNapoleon: (BoardArea.counterTray, 79.0, 165.0),
      Location.trayWives: (BoardArea.counterTray, 99.0, 254.0),
      Location.trayIcons: (BoardArea.counterTray, 79.0, 342.0),
      Location.trayPolitics: (BoardArea.counterTray, 268.0, 165.0),
      Location.trayFrenchCorps: (BoardArea.counterTray, 535.0, 165.0),
      Location.trayDuchy: (BoardArea.counterTray, 79.0, 407.0),
      Location.trayRussianWar: (BoardArea.counterTray, 280.0, 440.0),
      Location.trayAllies: (BoardArea.counterTray, 438.0, 435.0),
      Location.trayBudget: (BoardArea.counterTray, 438.0, 525.0),
      Location.trayEtats: (BoardArea.counterTray, 617.0, 407.0),
      Location.trayAlignment: (BoardArea.counterTray, 79.0, 632.0),
      Location.trayFrenchDiplomats: (BoardArea.counterTray, 260.0, 632.0),
      Location.trayCoalitionDiplomats: (BoardArea.counterTray, 438.0, 613.0),
      Location.trayReligion: (BoardArea.counterTray, 438.0, 702.0),
      Location.trayEmigres: (BoardArea.counterTray, 617.0, 613.0),
      Location.trayPrussians: (BoardArea.counterTray, 617.0, 702.0),
      Location.trayRussians: (BoardArea.counterTray, 79.0, 792.0),
      Location.trayAustrians: (BoardArea.counterTray, 79.0, 882.0),
      Location.traySpanish: (BoardArea.counterTray, 99.0, 972.0),
      Location.trayBritish: (BoardArea.counterTray, 260.0, 792.0),
      Location.trayGold: (BoardArea.counterTray, 260.0, 882.0),
      Location.trayFervor: (BoardArea.counterTray, 260.0, 972.0),
      Location.trayMisc: (BoardArea.counterTray, 448.0, 790.0),
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

  void layoutNation(MyAppState appState, Location nation, int pass) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(nation);
    final boardArea = coordinates.$1;
    final xNation = coordinates.$2;
    final yNation = coordinates.$3;

    if (pass == 0) {
      final frenchCorps = <Piece>[];
      final coalitionCorps = <Piece>[];
      Piece? etat;
      final misc = <Piece>[];
      for (final piece in state.piecesInLocation(PieceType.all, nation)) {
        if (piece.isType(PieceType.frenchAndAlliedCorps)) {
          frenchCorps.add(piece);
        } else if (piece.isType(PieceType.coalitionCorps)) {
          coalitionCorps.add(piece);
        } else if (piece.isType(PieceType.etat)) {
          etat = piece;
        } else {
          misc.add(piece);
        }
      }

      for (int i = 0; i < frenchCorps.length; ++i) {
        int col = i % 5;
        double x = xNation + col * 62.0 - 31.0;
        double y = yNation - 31.0;
        addPieceToBoard(appState, frenchCorps[i], boardArea, x, y);
      }
      for (int i = 0; i < coalitionCorps.length; ++i) {
        int col = i % 5;
        double x = xNation + col * 62.0 - 31.0;
        double y = yNation + 65.0;
        addPieceToBoard(appState, coalitionCorps[i], boardArea, x, y);
      }
      if (etat != null) {
        double x = xNation + 210.0 - 31.0;
        double y = yNation - 31.0;
        addPieceToBoard(appState, etat, boardArea, x, y);
      }
      for (int i = 0; i < misc.length; ++i) {
        int col = i;
        double x = xNation + 140.0 - col * 65.0 - 31.0;
        double y = yNation - 31.0;
        addPieceToBoard(appState, misc[i], boardArea, x, y);
      }
    }
  }

  void layoutNations(MyAppState appState, int pass) {
    for (final nation in LocationType.nation.locations) {
      layoutNation(appState, nation, pass);
    }
  }

  void layoutGreenBox(MyAppState appState, Location greenBox, int pass) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(greenBox);
    final boardArea = coordinates.$1;
    final xBox = coordinates.$2;
    final yBox = coordinates.$3;

    if (pass == 0) {
      Piece? butNation;
      Piece? napoleon;
      final frenchDiplomats = <Piece>[];
      final coalitionDiplomats = <Piece>[];
      for (final piece in state.piecesInLocation(PieceType.all, greenBox)) {
        if (piece.isType(PieceType.frenchDiplomat)) {
          frenchDiplomats.add(piece);
        } else if (piece.isType(PieceType.coalitionDiplomat)) {
          coalitionDiplomats.add(piece);
        } else if (piece.isType(PieceType.napoleon)) {
          napoleon = piece;
        } else if (piece == Piece.butNation) {
          butNation = piece;
        }
      }

      if (butNation != null) {
        double x = xBox - 18.0 - 30.0;
        double y = yBox - 1.0 - 30.0;
        addPieceToBoard(appState, butNation, boardArea, x, y);
      }
      if (napoleon != null) {
        double x = xBox + 80.0 - 30.0;
        double y = yBox - 30.0;
        addPieceToBoard(appState, napoleon, boardArea, x, y);
      }
      for (int i = frenchDiplomats.length - 1; i >= 0; --i) {
        double x = xBox + 145.0 - 30.0;
        double y = yBox + i * 3.0 - 30.0;
        addPieceToBoard(appState, frenchDiplomats[i], boardArea, x, y);
      }
      for (int i = coalitionDiplomats.length - 1; i >= 0; --i) {
        double x = xBox + 210.0 - 30.0;
        double y = yBox + i * 3.0 - 30.0;
        addPieceToBoard(appState, coalitionDiplomats[i], boardArea, x, y);
      }
    }
  }

  void layoutGreenBoxes(MyAppState appState, int pass) {
    for (final greenBox in LocationType.greenBox.locations) {
      layoutGreenBox(appState, greenBox, pass);
    }
  }

  void layoutLondon(MyAppState appState, int pass) {
    final state = appState.gameState!;
    const box = Location.boxLondon;
    final coordinates = locationCoordinates(box);
    final boardArea = coordinates.$1;
    double xBox = coordinates.$2;
    double yBox = coordinates.$3;

    final diplomats = <Piece>[];
    final icons = <Piece>[];
    Piece? pounds4;
    for (final piece in state.piecesInLocation(PieceType.all, box)) {
      if (piece.isType(PieceType.diplomat)) {
        diplomats.add(piece);
      } else if (piece.isType(PieceType.icon)) {
        icons.add(piece);
      } else if (piece == Piece.pounds4) {
        pounds4 = piece;
      }
    }

    var sk = (box, 0);
    if (_expandedStacks.contains(sk) == (pass == 1)) {
      double xStack = xBox - 30.0;
      double yStack = yBox - 30.0;
      layoutStack(appState, sk, diplomats, BoardArea.map, xStack, yStack, 0.0, 2.0);
    }

    sk = (box, 1);
    if (_expandedStacks.contains(sk) == (pass == 1)) {
      double xStack = xBox + 62.0 - 30.0;
      double yStack = yBox - 30.0;
      layoutStack(appState, sk, icons, BoardArea.map, xStack, yStack, 0.0, 2.0);
    }

    if (pass == 0 && pounds4 != null) {
      double x = xBox + 124.0 - 30.0;
      double y = yBox - 30.0;
      addPieceToBoard(appState, pounds4, boardArea, x, y);
    }
  }

  void layoutMinor(MyAppState appState, Location minor, int pass) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(minor);
    final boardArea = coordinates.$1;
    final xMinor = coordinates.$2;
    final yMinor = coordinates.$3;

    if (pass == 0) {
      Piece? war;
      Piece? russianWarOrTrade;
      Piece? ottomanArmy;
      for (final piece in state.piecesInLocation(PieceType.all, minor)) {
        if (piece.isType(PieceType.war)) {
          war = piece;
        } else if (piece.isType(PieceType.warLost)) {
          war = piece;
        } else if (piece.isType(PieceType.russianWar)) {
          russianWarOrTrade = piece;
        } else if (piece.isType(PieceType.trade)) {
          russianWarOrTrade = piece;
        } else if (piece == Piece.ottomanArmy) {
          ottomanArmy = piece;
        }
      }

      if (ottomanArmy != null) {
        addPieceToBoard(appState, ottomanArmy, boardArea, xMinor + 3.0 - 30.0, yMinor + 32.0 - 30.0);
      }
      if (war != null) {
        addPieceToBoard(appState, war, boardArea, xMinor + 3.0 - 30.0, yMinor + 3.0 - 30.0);
      }
      if (russianWarOrTrade != null) {
        addPieceToBoard(appState, russianWarOrTrade, boardArea, xMinor + 70.0 - 30.0, yMinor + 32.0 - 30.0);
      }
    }
  }

  void layoutMinors(MyAppState appState, int pass) {
    for (final minor in LocationType.minor.locations) {
      layoutMinor(appState, minor, pass);
    }
  }

  static const boxInfos = {
    Location.russianWarFinland: (0.0, 0.0, 1, 1),
    Location.russianWarCaucasus: (0.0, 0.0, 1, 1),
    Location.russianWarBalkans: (0.0, 0.0, 1, 1),
    Location.russianWarCorfu: (0.0, 0.0, 1, 1),
    Location.statusAustria: (0.0, 0.0, 1, 1),
    Location.statusPrussia: (0.0, 0.0, 1, 1),
    Location.statusRussia: (0.0, 0.0, 1, 1),
    Location.statusSpain: (0.0, 0.0, 1, 1),
    Location.statusSweden: (0.0, 0.0, 1, 1),
    Location.boxHighSeas: (7.0, 2.0, 2, 2),
    Location.boxFranceReligion: (0.0, 0.0, 1, 1),
    Location.boxHotel: (0.0, 0.0, 1, 1),
    Location.boxJews: (0.0, 0.0, 1, 1),
    Location.boxNapoleonsBed: (0.0, 0.0, 1, 1),
    Location.boxCasualties: (0.0, 0.0, 2, 3),
    Location.boxPortugal: (0.0, 0.0, 1, 1),
    Location.lightInfantryBernadotte: (0.0, 0.0, 1, 1),
    Location.lightInfantryFrenchDomination: (0.0, 0.0, 1, 1),
    Location.lightInfantryFrenchAdvantage: (0.0, 0.0, 1, 1),
    Location.lightInfantryNoAdvantage: (0.0, 0.0, 1, 1),
    Location.poolPlayerForces: (10.0, 2.0, 5, 3),
    Location.poolNeutralForces: (2.0, 8.0, 3, 2),
    Location.trayNapoleon: (0.0, 0.0, 3, 1),
    Location.trayWives: (20.0, 0.0, 2, 1),
    Location.trayIcons: (0.0, 0.0, 3, 1),
    Location.trayPolitics: (5.0, 0.0, 4, 4),
    Location.trayFrenchCorps: (5.0, 0.0, 4, 4),
    Location.trayDuchy: (0.0, 0.0, 3, 3),
    Location.trayRussianWar: (15.0, 15.0, 2, 2),
    Location.trayAllies: (0.0, 0.0, 3, 1),
    Location.trayBudget: (0.0, 0.0, 3, 1),
    Location.trayEtats: (0.0, 0.0, 3, 3),
    Location.trayAlignment: (0.0, 8.0, 3, 2),
    Location.trayFrenchDiplomats: (0.0, 8.0, 3, 2),
    Location.trayCoalitionDiplomats: (0.0, 0.0, 3, 1),
    Location.trayReligion: (0.0, 0.0, 3, 1),
    Location.trayEmigres: (0.0, 0.0, 3, 1),
    Location.trayPrussians: (0.0, 0.0, 3, 1),
    Location.trayRussians: (0.0, 0.0, 3, 1),
    Location.trayAustrians: (0.0, 0.0, 3, 1),
    Location.traySpanish: (20.0, 0.0, 2, 1),
    Location.trayBritish: (0.0, 0.0, 3, 1),
    Location.trayGold: (0.0, 0.0, 3, 1),
    Location.trayFervor: (0.0, 0.0, 3, 1),
    Location.trayMisc: (10.0, 1.0, 5, 4),
    Location.trayImperialGuard: (0.0, 0.0, 1, 1),
  };

  (double, double, int, int) boxInfo(Location box) {
    return boxInfos[box]!;
  }

  void layoutBox(MyAppState appState, Location box, int pass) {
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
    layoutBoxStacks(appState, box, pass, state.piecesInLocation(PieceType.all, box), boardArea, cols, rows, xBox, yBox, 60.0 + xGap, 60.0 + yGap, 2.0, 2.0);
  }

  void layoutBoxes(MyAppState appState, int pass) {
    for (final box in boxInfos.keys) {
      layoutBox(appState, box, pass);
    }
  }

  void layoutTurn(MyAppState appState, Location turn) {
    final state = appState.gameState!;
    final coordinates = locationCoordinates(Location.turn0);
    final boardArea = coordinates.$1;
    double xFirstTurn = coordinates.$2;
    double yFirstTurn = coordinates.$3;
    int turnIndex = turn.index - LocationType.turn.firstIndex;
    int col = turnIndex % 4;
    int row = turnIndex ~/ 4;
    double xTurn = xFirstTurn + col * 166.7;
    double yTurn = yFirstTurn + row * 79.5;

    final pieces = state.piecesInLocation(PieceType.all, turn);
    int layers = (pieces.length + 2) ~/ 2;
    for (int i = pieces.length - 1; i >= 0; --i) {
      int colP = i % 2;
      int depth = i ~/ 2;
      double x = xTurn + colP * 70.0 - layers * 2.0 + depth * 4.0;
      double y = yTurn;
      addPieceToBoard(appState, pieces[i], boardArea, x, y);
    }
  }

  void layoutTurnTrack(MyAppState appState) {
    for (final turn in LocationType.turn.locations) {
      layoutTurn(appState, turn);
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
    _turnTrackStackChildren.clear();
    _turnTrackStackChildren.add(_turnTrackImage);
    _counterTrayStackChildren.clear();
    _counterTrayStackChildren.add(_counterTrayImage);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutTurnTrack(appState);
      layoutBoxes(appState, 0);
      layoutMinors(appState, 0);
      layoutLondon(appState, 0);
      layoutGreenBoxes(appState, 0);
      layoutNations(appState, 0);
      layoutBoxes(appState, 1);
      layoutMinors(appState, 1);
      layoutLondon(appState, 1);
      layoutGreenBoxes(appState, 1);
      layoutNations(appState, 1);

      const choiceTexts = {
        Choice.transferToMinorWarFund: 'Increase Minor War Fund',
        Choice.transferToAdmiralty: 'Increase Admiralty Budget',
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
                  width: _mapWidth + _turnTrackWidth + _counterTrayWidth,
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
                        child: Stack(children: _turnTrackStackChildren),
                      ),
                      Positioned(
                        left: _mapWidth + _turnTrackWidth,
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

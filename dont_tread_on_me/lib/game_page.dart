import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:dont_tread_on_me/game.dart';
import 'package:dont_tread_on_me/main.dart';

enum BoardArea {
  map,
  turnTrack,
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
  static const _mapHeight = 2112.0;
  static const _turnTrackWidth = 1632.0;
  static const _turnTrackHeight = 2112.0;

  final _displayOptionsFormKey = GlobalKey<FormState>();
 
  bool _emptyMap = false;

  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _turnTrackImage = Image.asset('assets/images/turn_track.png', key: UniqueKey(), width: _turnTrackWidth, height: _turnTrackHeight);
  final _mapStackChildren = <Widget>[];
  final _turnTrackStackChildren = <Widget>[];

  final _pieceStackKeys = <Piece,StackKey>{};
  final _expandedStacks = <StackKey>[];

  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> counterNames = {
      Piece.groundBritishCam: 'unit_british_cam',
      Piece.groundBritishMar: 'unit_british_mar',
      Piece.groundBritish4KO: 'unit_british_4ko',
      Piece.groundBritishBW: 'unit_british_bw',
      Piece.groundBritishFH: 'unit_british_fh',
      Piece.groundBritishGds: 'unit_british_gds',
      Piece.groundBritishGnd: 'unit_british_gnd',
      Piece.groundBritish18RI: 'unit_british_18ri',
      Piece.groundBritishRWF: 'unit_british_rwf',
      Piece.groundBritish22: 'unit_british_22',
      Piece.groundBritish43: 'unit_british_43',
      Piece.groundBritish7RF: 'unit_british_7rf',
      Piece.groundBritish33: 'unit_british_33',
      Piece.groundBritishQLD: 'unit_british_qld',
      Piece.groundBritish17LD: 'unit_british_17ld',
      Piece.groundLoyalistRNC: 'unit_loyalist_rnc',
      Piece.groundLoyalistQAR: 'unit_loyalist_qar',
      Piece.groundLoyalistPWL: 'unit_loyalist_pwl',
      Piece.groundLoyalistBGP: 'unit_loyalist_bgp',
      Piece.groundLoyalistAL: 'unit_loyalist_al',
      Piece.groundLoyalistNJV: 'unit_loyalist_njv',
      Piece.groundLoyalistRHE: 'unit_loyalist_rhe',
      Piece.groundLoyalistTBL: 'unit_loyalist_tbl',
      Piece.groundHessiansHH: 'unit_hessians_hh',
      Piece.groundHessiansWal: 'unit_hessians_wal',
      Piece.groundHessiansHCM: 'unit_hessians_hcm',
      Piece.groundHessiansAB: 'unit_hessians_ab',
      Piece.groundHessiansAZF: 'unit_hessians_azf',
      Piece.groundHessiansHCJ: 'unit_hessians_hcj',
      Piece.groundHessiansBrw: 'unit_hessians_brw',
      Piece.groundIndianMohawk: 'unit_indian_mohawk',
      Piece.groundIndianCherokee: 'unit_indian_cherokee',
      Piece.groundContinentalArnold: 'unit_continental_arnold',
      Piece.groundContinentalGreene: 'unit_continental_greene',
      Piece.groundContinentalMorgan: 'unit_continental_morgan',
      Piece.groundContinentalHoward: 'unit_continental_howard',
      Piece.groundContinentalKosc: 'unit_continental_kosc',
      Piece.groundContinentalLafay: 'unit_continental_lafay',
      Piece.groundContinentalGlover: 'unit_continental_glover',
      Piece.groundContinentalLincoln: 'unit_continental_lincoln',
      Piece.groundContinentalMoult: 'unit_continental_moult',
      Piece.groundContinentalStark: 'unit_continental_stark',
      Piece.groundContinentalStirling: 'unit_continental_stirling',
      Piece.groundContinentalHuger: 'unit_continental_huger',
      Piece.groundContinentalMuhl: 'unit_continental_muhl',
      Piece.groundContinentalKnox: 'unit_continental_knox',
      Piece.groundContinentalWayne: 'unit_continental_wayne',
      Piece.groundContinentalHLee: 'unit_continental_h_lee',
      Piece.groundCOS0: 'unit_cos',
      Piece.groundCOS1: 'unit_cos',
      Piece.groundCOS2: 'unit_cos',
      Piece.groundCOS3: 'unit_cos',
      Piece.groundCOS4: 'unit_cos',
      Piece.groundCOS5: 'unit_cos',
      Piece.groundCOS6: 'unit_cos',
      Piece.groundCOS7: 'unit_cos',
      Piece.groundCOSFM: 'unit_cos_fm',
      Piece.groundFrenchRoch: 'unit_french_roch',
      Piece.navalBritishHowe: 'naval_british_howe',
      Piece.navalBritishParker: 'naval_british_parker',
      Piece.navalBritishArbuthnot: 'naval_british_arbuthnot',
      Piece.navalBritishGraves: 'naval_british_graves',
      Piece.navalRebelSmugglers0: 'naval_smugglers',
      Piece.navalRebelSmugglers1: 'naval_smugglers',
      Piece.navalRebelSmugglers2: 'naval_smugglers',
      Piece.navalRebelSmugglers3: 'naval_smugglers',
      Piece.navalRebelSmugglers4: 'naval_smugglers',
      Piece.navalRebelSmugglers5: 'naval_smugglers',
      Piece.navalRebelSmugglers6: 'naval_smugglers',
      Piece.navalRebelSmugglers7: 'naval_smugglers',
      Piece.navalRebelPrivateers0: 'naval_privateers',
      Piece.navalRebelPrivateers1: 'naval_privateers',
      Piece.navalFrenchFleet: 'french_fleet',
      Piece.congress: 'congress',
      Piece.washington: 'washington',
      Piece.jefferson: 'jefferson',
      Piece.militiaPresentBritish: 'militia_british',
      Piece.militiaPresentRebel: 'militia_rebel',
      Piece.markerLoyaltyNewEngland: 'loyalty_new_england',
      Piece.markerLoyaltyNewYork: 'loyalty_new_york',
      Piece.markerLoyaltyPennsylvania: 'loyalty_pennsylvania',
      Piece.markerLoyaltyVirgina: 'loyalty_virginia',
      Piece.markerLoyaltyCarolina: 'loyalty_carolina',
      Piece.markerVermontStatus: 'vermont',
      Piece.markerTurn: 'game_turn',
      Piece.markerPounds: 'pounds',
      Piece.markerLiberty: 'liberty',
      Piece.markerBattle: 'battle',
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
    case BoardArea.turnTrack:
      _turnTrackStackChildren.add(widget);
    }
  }

  void addCountyToMap(MyAppState appState, Location county, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(county);
    bool selected = playerChoices.selectedLocations.contains(county);

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
            appState.choseLocation(county);
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

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.countyNewEnglandConnecticutCoast: (BoardArea.map, 0.0, 0.0),
      Location.countyNewEnglandRhodeIsland: (BoardArea.map, 1020.0, 140.0),
      Location.countyNewEnglandMassachusettsShore: (BoardArea.map, 890.0, 245.0),
      Location.countyNewEnglandMaineAndNovaScotia: (BoardArea.map, 1020.0, 245.0),
      Location.countyNewYorkTheFrontier: (BoardArea.map, 602.0, 570.0),
      Location.countyNewYorkRiverForts: (BoardArea.map, 0.0, 0.0),
      Location.countyNewYorkHudsonHighlands: (BoardArea.map, 620.0, 680.0),
      Location.countyNewYorkHudsonValley: (BoardArea.map, 740.0, 680.0),
      Location.countyPennsylvaniaSchuylkillValley: (BoardArea.map, 0.0, 0.0),
      Location.countyPennsylvaniaAroundPhiladelphia: (BoardArea.map, 602.0, 905.0),
      Location.countyPennsylvaniaQuakerCountry: (BoardArea.map, 0.0, 0.0),
      Location.countyPennsylvaniaNewJersey: (BoardArea.map, 602.0, 1012.0),
      Location.countyVirginaPiedmont: (BoardArea.map, 430.0, 1290.0),
      Location.countyVirginiaTidewater: (BoardArea.map, 0.0, 0.0),
      Location.countyVirginiaSouthside: (BoardArea.map, 0.0, 0.0),
      Location.countyVirginiaHamptonRoads: (BoardArea.map, 560.0, 1407.0),
      Location.countyCarolinaOverTheMountains: (BoardArea.map, 250.0, 1705.0),
      Location.countyCarolinaPiedmont: (BoardArea.map, 370.0, 1705.0),
      Location.countyCarolinaTidewater: (BoardArea.map, 250.0, 1814.0),
      Location.countyCarolinaCharlesTown: (BoardArea.map, 370.0, 1814.0),
      Location.seaZoneNorthAtlantic: (BoardArea.map, 1387.0, 175.0),
      Location.seaZoneMassachusettsBay: (BoardArea.map, 1196.0, 448.0),
      Location.seaZoneLongIslandSound: (BoardArea.map, 1045.0, 797.0),
      Location.seaZoneDelawareBay: (BoardArea.map, 900.0, 1080.0),
      Location.seaZoneChesapeakeBay: (BoardArea.map, 0.0, 0.0),
      Location.seaZoneCapeFear: (BoardArea.map, 0.0, 0.0),
      Location.boxQuebec: (BoardArea.map, 332.0, 190.0),
      Location.boxBoston: (BoardArea.map, 950.0, 515.0),
      Location.boxCaribbean: (BoardArea.map, 577.0, 1920.0),
      Location.boxBritishShipsAtSea: (BoardArea.map, 1024.0, 1880.0),
      Location.boxAvailableIndians: (BoardArea.map, 215.0, 523.0),
      Location.boxAmericanLeadershipNewYork: (BoardArea.map, 0.0, 0.0),
      Location.boxAmericanLeadershipPennsylvania: (BoardArea.map, 344.0, 966.0),
      Location.boxAmericanLeadershipVirginia: (BoardArea.map, 0.0, 0.0),
      Location.boxCongressInFlight: (BoardArea.map, 0.0, 0.0),
      Location.boxBattle: (BoardArea.map, 1290.0, 1405.0),
      Location.boxVermontProBritish: (BoardArea.map, 732.0, 168.0),
      Location.boxVermontNeutral: (BoardArea.map, 732.0, 278.0),
      Location.boxVermontProRebel: (BoardArea.map, 732.0, 388.0),
      Location.militiaPresentLoyalist0: (BoardArea.map, 1142.0, 1622.0),
      Location.militiaPresentRebel0: (BoardArea.map, 1142.0, 1716.0),
      Location.poolBritishForce: (BoardArea.map, 1230.0, 949.0),
      Location.poolRebelForce: (BoardArea.map, 37.0, 718.0),
      Location.turn0: (BoardArea.turnTrack, 124.0, 124.0),
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

  void layoutCounty(MyAppState appState, Location county, int pass) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(county);
    final xCounty = coordinates.$2;
    final yCounty = coordinates.$3;

    if (pass == 0 && appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(county)) {
      addCountyToMap(appState, county, xCounty, yCounty);
    }

    final sk = (county, 0);
    if (_expandedStacks.contains(sk) == (pass == 1)) {
      layoutStack(appState, sk, state.piecesInLocation(PieceType.all, county), BoardArea.map, xCounty, yCounty, 4.0, 4.0);
    }
  
    if (pass == 1 && appState.playerChoices != null && appState.playerChoices!.locations.contains(county)) {
      addCountyToMap(appState, county, xCounty, yCounty);
    }
  }

  void layoutCounties(MyAppState appState, int pass) {
    for (final county in LocationType.county.locations) {
      layoutCounty(appState, county, pass);
    }
    layoutCounty(appState, Location.boxQuebec, pass);
    layoutCounty(appState, Location.boxBoston, pass);
  }

  void layoutBoxes(MyAppState appState, int pass) {
    const boxesInfo = {
      Location.seaZoneNorthAtlantic: (2, 1, 20.0, 0.0),
      Location.seaZoneMassachusettsBay: (2, 1, 20.0, 0.0),
      Location.seaZoneLongIslandSound: (2, 1, 20.0, 0.0),
      Location.seaZoneDelawareBay: (2, 1, 20.0, 0.0),
      Location.seaZoneChesapeakeBay: (2, 1, 20.0, 0.0),
      Location.seaZoneCapeFear: (2, 1, 20.0, 0.0),
      Location.boxCaribbean: (2, 2, 20.0, 5.0),
      Location.boxBritishShipsAtSea: (2, 2, 20.0, 5.0),
      Location.boxAvailableIndians: (2, 1, 15.0, 0.0),
      Location.boxAmericanLeadershipNewYork: (1, 1, 0.0, 0.0),
      Location.boxAmericanLeadershipPennsylvania: (1, 1, 0.0, 0.0),
      Location.boxAmericanLeadershipVirginia: (1, 1, 0.0, 0.0),
      Location.boxCongressInFlight: (1, 1, 0.0, 0.0),
      Location.poolBritishForce: (4, 4, 6.0, 6.0),
      Location.poolRebelForce: (4, 4, 6.0, 6.0),
      Location.boxBattle: (1, 1, 0.0, 0.0),
      Location.boxVermontProBritish: (1, 1, 0.0, 0.0),
      Location.boxVermontNeutral: (1, 1, 0.0, 0.0),
      Location.boxVermontProRebel: (1, 1, 0.0, 0.0),
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

  /*
  void layoutTrack(MyAppState appState) {
    final state = appState.gameState!;

    final firstBoxCoordinates = locationCoordinates(Location.track0);
    final xFirst = firstBoxCoordinates.$2;
    final yBox = firstBoxCoordinates.$3;
    for (final box in LocationType.track.locations) {
      int index = box.index - LocationType.track.firstIndex;
      final xBox = xFirst + 73.2 * index;
      final pieces = state.piecesInLocation(PieceType.marker, box);
      for (int i = 0; i < pieces.length; ++i) {
        addPieceToBoard(appState, pieces[i], BoardArea.map, xBox + 4.0 * i, yBox + 4.0 * i);
      }
    }
  }
  */

  void layoutMilitiaPresentTrack(MyAppState appState, Location firstBox, Piece piece) {
    final state = appState.gameState!;
    final firstCoordinates = locationCoordinates(firstBox);
    double xFirst = firstCoordinates.$2;
    double yBox = firstCoordinates.$3;
    final box = state.pieceLocation(piece);
    int index = box.index - firstBox.index;
    double xBox = xFirst + 100.0 * index;
    addPieceToBoard(appState, piece, BoardArea.map, xBox, yBox);
  }

  void layoutTurnTrack(MyAppState appState) {
    final state = appState.gameState!;

    final firstBoxCoordinates = locationCoordinates(Location.turn0);
    final xFirst = firstBoxCoordinates.$2;
    final yFirst = firstBoxCoordinates.$3;
    for (final box in LocationType.turn.locations) {
      int index = box.index - LocationType.turn.firstIndex - 1;
      int xIndex = index < 0 ? 0 : index % 4;
      int yIndex = index < 0 ? 0 : (index ~/ 4) + 1;
      final xBox = xFirst + 350.0 * xIndex;
      final yBox = yFirst + 180.0 * yIndex;
      final pieces = state.piecesInLocation(PieceType.all, box);
      int nonGameTurnCount = 0;
      for (int i = 0; i < pieces.length; ++i) {
        final piece = pieces[i];
        double xOffset = 0.0;
        double yOffset = 0.0;
        if (piece != Piece.markerTurn) {
          yOffset = 65.0;
          xOffset = 275.0 - nonGameTurnCount * 65.0;
          nonGameTurnCount += 1;
        }
        addPieceToBoard(appState, piece, BoardArea.turnTrack, xBox + xOffset, yBox + yOffset);
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
    _turnTrackStackChildren.clear();
    _turnTrackStackChildren.add(_turnTrackImage);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutMilitiaPresentTrack(appState, Location.militiaPresentLoyalist0, Piece.militiaPresentBritish);
      layoutMilitiaPresentTrack(appState, Location.militiaPresentRebel0, Piece.militiaPresentRebel);
      layoutTurnTrack(appState);
      layoutBoxes(appState, 0);
      layoutCounties(appState, 0);
      layoutBoxes(appState, 1);
      layoutCounties(appState, 1);

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
                  width: _mapWidth + _turnTrackWidth,
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

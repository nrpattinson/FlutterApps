import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:nubia/game.dart';
import 'package:nubia/main.dart';

enum BoardArea {
  map,
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
  static const _mapWidth = 1043.0;
  static const _mapHeight = 1632.0;
  static const _trayWidth = 1261.0;
  static const _trayHeight = 1632.0;
  final _pieceTypeCounters = <PieceType,Image>{};
  final _pieceCounters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _referenceImage = Image.asset('assets/images/tray.png', key: UniqueKey(), width: _trayWidth, height: _trayHeight);
  final _mapStackChildren = <Widget>[];
  final _trayStackChildren = <Widget>[];
  final _pieceStackKeys = <Piece,StackKey>{};
  final _expandedStacks = <StackKey>[];
  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> pieceCounterNames = {
      Piece.mekAyyubid: 'mek_ayyubid',
      Piece.mekMamluk: 'mek_mamluk',
      Piece.mekJuhayna: 'mek_juhayna',
      Piece.mekJad: 'mek_jad',
      Piece.mekBeja: 'mek_beja',
      Piece.mekKanz: 'mek_kanz',
      Piece.mekShilluk: 'mek_shilluk',
      Piece.mekFunj: 'mek_funj',
      Piece.mekKawahla: 'mek_kawahla',
      Piece.crusades0: 'crusades_0',
      Piece.crusades1: 'crusades_1',
      Piece.crusades2: 'crusades_2',
      Piece.portugal0: 'portugal',
      Piece.portugal1: 'portugal',
      Piece.portugal2: 'portugal',
      Piece.portugal3: 'portugal',
      Piece.uruAbraham: 'uru_abraham',
      Piece.uruMark: 'uru_mark',
      Piece.uruSolomon: 'uru_solomon',
      Piece.uruKerenbes: 'uru_kerenbes',
      Piece.uruRafael: 'uru_rafael',
      Piece.uruDavid: 'uru_david',
      Piece.uruMosesGeorge: 'uru_moses_george',
      Piece.uruGeorge: 'uru_george',
      Piece.uruMercury: 'uru_mercury',
      Piece.uruJoel: 'uru_joel',
      Piece.uruZachary: 'uru_zachary',
      Piece.uruCyriac: 'uru_cyriac',
      Piece.metropolitanPeter: 'metropolitan_peter',
      Piece.metropolitanJesus: 'metropolitan_jesus',
      Piece.metropolitanJohn: 'metroplitan_john',
      Piece.metropolitanShenoute: 'metropolitan_shenoute',
      Piece.princessMariam: 'princess_mariam',
      Piece.princessMartha: 'princess_martha',
      Piece.princessAgatha: 'princess_agatha',
      Piece.princessAnthelia: 'princess_anthelia',
      Piece.princessPetronia: 'princess_petronia',
      Piece.princessKristina: 'princess_kristina',
      Piece.bishop5: 'bishop_5',
      Piece.bishopF: 'bishop_f',
      Piece.bishopI: 'bishop_i',
      Piece.eparch0: 'eparch',
      Piece.eparch1: 'eparch',
      Piece.eparch2: 'eparch',
      Piece.eparch3: 'eparch',
      Piece.feudal0N1: 'feudal_n1',
      Piece.feudal1N1: 'feudal_n1',
      Piece.feudal2N1: 'feudal_n1',
      Piece.feudal3N1: 'feudal_n1',
      Piece.feudal4N1: 'feudal_n1',
      Piece.feudal0P1: 'feudal_p1',
      Piece.feudal1P1: 'feudal_p1',
      Piece.feudal2P1: 'feudal_p1',
      Piece.feudal3P1: 'feudal_p1',
      Piece.feudal4P1: 'feudal_p1',
      Piece.migrationA0: 'migration_a',
      Piece.migrationA1: 'migration_a',
      Piece.migrationB0: 'migration_b',
      Piece.migrationC0: 'migration_c',
      Piece.migrationC1: 'migration_c',
      Piece.migrationD0: 'migration_d',
      Piece.migrationD1: 'migration_d',
      Piece.migrationE0: 'migration_e',
      Piece.famine0: 'famine',
      Piece.famine1: 'famine',
      Piece.famine2: 'famine',
      Piece.famine3: 'famine',
      Piece.monastery0: 'monastery_4',
      Piece.monastery1: 'monastery_5',
      Piece.monastery2: 'monastery_5',
      Piece.monastery3: 'monastery_6',
      Piece.mosque0: 'mosque',
      Piece.mosque1: 'mosque',
      Piece.landSale0: 'land_sale_2',
      Piece.landSale1: 'land_sale_3',
      Piece.landSale2: 'land_sale_3',
      Piece.landSale3: 'land_sale_4',
      Piece.nubianArchers0: 'nubian_archers',
      Piece.nubianArchers1: 'nubian_archers',
      Piece.nubianArchers2: 'nubian_archers',
      Piece.nubianArchers3: 'nubian_archers',
      Piece.marriage0: 'dynastic_marriage',
      Piece.marriage1: 'dynastic_marriage',
      Piece.slaves: 'slaves',
      Piece.ethiopians: 'ethiopians',
      Piece.assetNobility: 'asset_nobility',
      Piece.assetKingship: 'asset_kingship',
      Piece.assetArmy: 'asset_army',
    };

    for (final counterName in pieceCounterNames.entries) {
      final imagePath = 'assets/images/${counterName.value}.png';
      _pieceCounters[counterName.key] = Image.asset(imagePath,
        key: UniqueKey(),
        width: 60.0, height:60.0,
      );
    }
  }

  Image pieceImage(Piece piece) {
    for (final counter in _pieceTypeCounters.entries) {
      if (piece.isType(counter.key)) {
        return counter.value;
      }
    }
    for (final counter in _pieceCounters.entries) {
      if (piece == counter.key) {
        return counter.value;
      }
    }
    return _referenceImage;
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
    case BoardArea.tray:
      _trayStackChildren.add(widget);
    }
  }

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

  (BoardArea, double, double) locationCoordinates(Location location) {
    const coordinates = {
      Location.soba: (BoardArea.map, 0.0, 0.0),
      Location.sururab: (BoardArea.map, 0.0, 0.0),
      Location.furaWells: (BoardArea.map, 0.0, 0.0),
      Location.dongola: (BoardArea.map, 0.0, 0.0),
      Location.daw: (BoardArea.map, 0.0, 0.0),
      Location.selimaOasis: (BoardArea.map, 92.0, 152.0),
      Location.theGates: (BoardArea.map, 0.0, 0.0),
      Location.kedru: (BoardArea.map, 0.0, 0.0),
      Location.mogranarti: (BoardArea.map, 0.0, 0.0),
      Location.koroskoRoad: (BoardArea.map, 0.0, 0.0),
      Location.faras: (BoardArea.map, 0.0, 0.0),
      Location.phrim: (BoardArea.map, 0.0, 0.0),
      Location.aswan: (BoardArea.map, 451.0, 28.0),
      Location.shendi: (BoardArea.map, 0.0, 0.0),
      Location.atbaraRiver: (BoardArea.map, 0.0, 0.0),
      Location.taflien: (BoardArea.map, 0.0, 0.0),
      Location.bazin: (BoardArea.map, 0.0, 0.0),
      Location.aydhab: (BoardArea.map, 896.0, 228.0),
      Location.qerri: (BoardArea.map, 0.0, 0.0),
      Location.arbaji: (BoardArea.map, 0.0, 0.0),
      Location.sennar: (BoardArea.map, 0.0, 0.0),
      Location.blueNile: (BoardArea.map, 0.0, 0.0),
      Location.sobatRiver: (BoardArea.map, 510.0, 1335.0),
      Location.kusha: (BoardArea.map, 0.0, 0.0),
      Location.whiteNile: (BoardArea.map, 0.0, 0.0),
      Location.nubaMountains: (BoardArea.map, 0.0, 0.0),
      Location.fortyDaysRoad: (BoardArea.map, 0.0, 0.0),
      Location.kordofan: (BoardArea.map, 50.0, 1097.0),
      Location.boxDowntownSoba: (BoardArea.map, 84.0, 646.0),
      Location.boxEthiopia: (BoardArea.map, 883.0, 1237.0),
      Location.boxUru: (BoardArea.map, 0.0, 0.0),
      Location.boxMetrolpolitan: (BoardArea.map, 0.0, 0.0),
      Location.boxBishops: (BoardArea.map, 35.0, 820.0),
      Location.crusadeLevel: (BoardArea.map, 701.5, 319.0),
      Location.nobility0: (BoardArea.map, 7.0, 1421.0),
      Location.kingship0: (BoardArea.map, 7.0, 1490.0),
      Location.army0: (BoardArea.map, 7.0, 1562.0),
      Location.poolSlavery: (BoardArea.map, 687.0, 1163.0),
      Location.traySlaves: (BoardArea.tray, 0.0, 0.0),
      Location.trayFeudalism: (BoardArea.tray, 310.0, 361.0),
      Location.trayEparchs: (BoardArea.tray, 700.0, 361.0),
      Location.trayCrusades: (BoardArea.tray, 867.0, 361.0),
      Location.trayMigration: (BoardArea.tray, 0.0, 0.0),
      Location.trayUrus: (BoardArea.tray, 0.0, 0.0),
      Location.trayPrincesses: (BoardArea.tray, 0.0, 0.0),
      Location.trayMeks: (BoardArea.tray, 531.0, 577.0),
      Location.trayLandSales: (BoardArea.tray, 0.0, 0.0),
      Location.trayNubianArchers: (BoardArea.tray, 308.0, 691.0),
      Location.trayAssets: (BoardArea.tray, 0.0, 0.0),
      Location.trayMonasteries: (BoardArea.tray, 867.0, 693.0),
      Location.trayBishops: (BoardArea.tray, 0.0, 0.0),
      Location.trayPortuguese: (BoardArea.tray, 332.0, 800.0),
      Location.trayMosques: (BoardArea.tray, 701.0, 800.0),
      Location.trayMarriage: (BoardArea.tray, 0.0, 0.0),
      Location.trayMetropolitans: (BoardArea.tray, 0.0, 0.0),
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

  void layoutLand(MyAppState appState, Location land, int pass) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(land);
    final xLand = coordinates.$2;
    final yLand = coordinates.$3;

    if (pass == 0 && appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(land)) {
      addProvinceToMap(appState, land, xLand, yLand);
    }

    final sk = (land, 0);
    if (_expandedStacks.contains(sk) == (pass == 1)) {
      layoutStack(appState, (land, 0), state.piecesInLocation(PieceType.all, land), BoardArea.map, xLand, yLand, 4.0, 4.0);
    }
 
    if (pass == 1 && appState.playerChoices != null && appState.playerChoices!.locations.contains(land)) {
      addProvinceToMap(appState, land, xLand, yLand);
    }
  }

  void layoutLands(MyAppState appState, int pass) {
    for (final land in LocationType.land.locations) {
      layoutLand(appState, land, pass);
    }
  }

  void layoutBoxes(MyAppState appState) {
    const boxesInfo = {
      Location.boxDowntownSoba: (4, 2, 6.0, 5.0),
      Location.boxEthiopia: (1, 1, 0.0, 0.0),
      Location.boxBishops: (1, 1, 0.0, 0.0),
      Location.crusadeLevel: (1, 1, 0.0, 0.0),
      Location.poolSlavery: (1, 1, 0.0, 0.0),
      Location.traySlaves: (1, 1, 0.0, 0.0),
      Location.trayFeudalism: (5, 1, 15.0, 0.0),
      Location.trayEparchs: (2, 1, 15.0, 0.0),
      Location.trayCrusades: (3, 1, 20.0, 0.0),
      Location.trayMigration: (1, 1, 0.0, 0.0),
      Location.trayUrus: (1, 1, 0.0, 0.0),
      Location.trayPrincesses: (1, 1, 0.0, 0.0),
      Location.trayMeks: (9, 1, 20.0, 0.0),
      Location.trayLandSales: (1, 1, 0.0, 0.0),
      Location.trayNubianArchers: (3, 1, 10.0, 0.0),
      Location.trayAssets: (1, 1, 0.0, 0.0),
      Location.trayMonasteries: (4, 1, 20.0, 0.0),
      Location.trayBishops: (1, 1, 0.0, 0.0),
      Location.trayPortuguese: (4, 1, 25.0, 0.0),
      Location.trayMosques: (2, 1, 18.0, 0.0),
      Location.trayMarriage: (1, 1, 0.0, 0.0),
      Location.trayMetropolitans: (1, 1, 0.0, 0.0),
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

  void layoutRoyalAssetTrack(MyAppState appState, LocationType locationType, Piece piece) {
    final state = appState.gameState!;
    final coordinatesFirst = locationCoordinates(locationType.locations[0]);
    final xFirst = coordinatesFirst.$2;
    final yBox = coordinatesFirst.$3;
    for (final box in locationType.locations) {
      final xBox = xFirst + (box.index - locationType.firstIndex) * 96.0;
      if (state.pieceLocation(piece) == box) {
        addPieceToBoard(appState, piece, BoardArea.map, xBox, yBox);
      }
    }
  }

  void layoutRoyalAssetTracks(MyAppState appState) {
    const trackInfos = [
      (LocationType.nobility, Piece.assetNobility),
      (LocationType.kingship, Piece.assetKingship),
      (LocationType.army, Piece.assetArmy),
    ];
    for (final trackInfo in trackInfos) {
      layoutRoyalAssetTrack(appState, trackInfo.$1, trackInfo.$2);
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
    _trayStackChildren.clear();
    _trayStackChildren.add(_referenceImage);

    _pieceStackKeys.clear();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutBoxes(appState);
      layoutRoyalAssetTracks(appState);
      layoutLands(appState, 0);
      layoutLands(appState, 1);

      const choiceTexts = {
        Choice.blockAdvanceNubianArchers: 'Nubian Archers',
        Choice.blockAdvanceMonastery: 'Monastery',
        Choice.blockAdvanceSlaves: 'Slaves',
        Choice.blockAdvanceCede: 'Cede Land',
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
                  width: _mapWidth + _trayWidth,
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

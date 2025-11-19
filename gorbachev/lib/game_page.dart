import 'package:flutter/material.dart';
import 'package:gorbachev/game.dart';
import 'package:gorbachev/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

enum BoardArea {
  map,
  tray,
}

class GamePage extends StatelessWidget {
  static const _mapWidth = 1629.0;
  static const _mapHeight = 1056.0;
  static const _trayWidth = 816.0;
  static const _trayHeight = 1056.0;
  final _counters = <Piece,Image>{};
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _trayImage = Image.asset('assets/images/tray.png', key: UniqueKey(), width: _trayWidth, height: _trayHeight);
  final _mapStackChildren = <Widget>[];
  final _trayStackChildren = <Widget>[];

  GamePage({super.key}) {

    final Map<Piece,String> counterNames = {
      Piece.peopleRussiaWeak: 'people_russia_weak',
      Piece.peopleRussiaStrong: 'people_russia_strong',
      Piece.peopleBalticsWeak: 'people_baltics_weak',
      Piece.peopleBalticsStrong: 'people_baltics_strong',
      Piece.peopleCaucasusWeak: 'people_caucasus_weak',
      Piece.peopleCaucasusStrong: 'people_caucasus_strong',
      Piece.peopleCentralAsia: 'people_central_asia_weak',
      Piece.peopleCommunistPartyWeak: 'people_cpsu_weak',
      Piece.peopleCommunistPartyStrong: 'people_cpsu_strong',
      Piece.vremya0: 'vremya',
      Piece.vremya1: 'vremya',
      Piece.vremya2: 'vremya',
      Piece.vremya3: 'vremya',
      Piece.usPresidentReagan: 'president_reagan',
      Piece.usPresidentBush: 'president_bush',
      Piece.usPresidentDukakis: 'president_dukakis',
      Piece.massacreVilnius: 'massacre_vilnius',
      Piece.massacreBaku: 'massacre_baku',
      Piece.massacreSukhumi: 'massacre_sukhumi',
      Piece.massacreSumgait: 'massacre_sumgait',
      Piece.massacreTbilisi: 'massacre_tbilisi',
      Piece.massacreAlmaAta: 'massacre_almaata',
      Piece.massacreFergana: 'massacre_fergana',
      Piece.disasterAdmiralNakhimov: 'disaster_admiral_nakhimov',
      Piece.disasterArmenianEarthquake: 'disaster_armenian_earthquake',
      Piece.disasterChernobyl: 'disaster_chernobyl',
      Piece.disasterMathiasRust: 'disaster_mathias_rust',
      Piece.disasterMinersStrike0: 'disaster_miners_strike',
      Piece.disasterMinersStrike1: 'disaster_miners_strike',
      Piece.disasterBigotsInPower: 'disaster_bigots_in_power',
      Piece.disasterRandomRevolution0: 'disaster_random_revolution',
      Piece.disasterRandomRevolution1: 'disaster_random_revolution',
      Piece.disasterRandomRevolution2: 'disaster_random_revolution',
      Piece.disasterFallOfBerlinWall: 'disaster_berlin_wall_fall',
      Piece.warsawPactBulgaria: 'country_bulgaria',
      Piece.warsawPactCzechoslovakia: 'country_czechoslovakia',
      Piece.warsawPactDdr: 'country_ddr',
      Piece.warsawPactHungary: 'country_hungary',
      Piece.warsawPactPoland: 'country_poland',
      Piece.warsawPactRomania: 'country_romania',
      Piece.politburoGorbachev: 'politician_gorbachev',
      Piece.politburoLigachev: 'politician_ligachev',
      Piece.politburoYeltsin: 'politician_yeltsin',
      Piece.politburoAliyev: 'politician_aliyev',
      Piece.politburoPopova: 'politician_popova',
      Piece.politburoPugo: 'politician_pugo',
      Piece.politburoRyzhkov: 'politician_ryzhkov',
      Piece.politburoShcherbytsky: 'politician_shcherbytsky',
      Piece.politburoSchevardnadze: 'politician_shevardnadze',
      Piece.politburoVorotnikov: 'politician_vorotnikov',
      Piece.politburoYakovlev: 'politician_yakovlev',
      Piece.politburoYaneyev: 'politician_yanayev',
      Piece.pravda0: 'pravda_2',
      Piece.pravda1: 'pravda_3',
      Piece.pravda2: 'pravda_3',
      Piece.pravda3: 'pravda_4',
      Piece.demonstrationN0: 'demonstration_n1',
      Piece.demonstrationN1: 'demonstration_n1',
      Piece.demonstrationN2: 'demonstration_n1',
      Piece.demonstrationN3: 'demonstration_n1',
      Piece.demonstrationP0: 'demonstration_p1',
      Piece.demonstrationP1: 'demonstration_p1',
      Piece.demonstrationP2: 'demonstration_p1',
      Piece.demonstrationP3: 'demonstration_p1',
      Piece.kgbD: 'kgb_d',
      Piece.kgbI: 'kgb_i',
      Piece.kgb5: 'kgb_5',
      Piece.berlinWall: 'berlin_wall',
      Piece.nukeInf: 'nuclear_inf',
      Piece.nukeIcbm: 'nuclear_icbm',
      Piece.forces40Army: 'army_40',
      Piece.forces1GtkArmy: 'army_1gtk',
      Piece.forces2GtkArmy: 'army_2gtk',
      Piece.forces28Corps: 'army_28',
      Piece.mvd0: 'mvd_security',
      Piece.mvd1: 'mvd_security',
      Piece.mvd2: 'mvd_security',
      Piece.mvd3: 'mvd_security',
      Piece.uzbekMafia: 'people_uzbek_mafia',
      Piece.doctrineBrezhnev: 'doctrine_brezhnev',
      Piece.doctrineSinatra: 'doctrine_sinatra',
      Piece.assetFiveYearPlan: 'asset_five_year_plan',
      Piece.assetMediaCulture: 'asset_media_culture',
      Piece.assetMilitaryMight: 'asset_military_might',
      Piece.markerYear: 'marker_year',
      Piece.markerSeason: 'marker_season',
      Piece.markerPopularVote: 'popular_vote',
      Piece.markerLoyalCommunists: 'loyal_communists',
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
    case BoardArea.tray:
      _trayStackChildren.add(widget);
    }
  }

  void addLandToMap(MyAppState appState, Location land, double x, double y) {
    final playerChoices = appState.playerChoices!;

    bool choosable = playerChoices.locations.contains(land);
    bool selected = playerChoices.selectedLocations.contains(land);

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
            appState.choseLocation(land);
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
      Location.moscow: (BoardArea.map, 0.0, 0.0),
      Location.russiaSedition: (BoardArea.map, 0.0, 0.0),
      Location.russiaViolence: (BoardArea.map, 0.0, 0.0),
      Location.russiaGlasnost: (BoardArea.map, 0.0, 0.0),
      Location.russiaPerestroika: (BoardArea.map, 0.0, 0.0),
      Location.russiaWorkersParadise: (BoardArea.map, 592.0, 148.0),
      Location.balticsSedition: (BoardArea.map, 0.0, 0.0),
      Location.balticsViolence: (BoardArea.map, 0.0, 0.0),
      Location.balticsGlasnost: (BoardArea.map, 0.0, 0.0),
      Location.balticsPerestroika: (BoardArea.map, 0.0, 0.0),
      Location.balticsWorkersParadise: (BoardArea.map, 84.0, 617.0),
      Location.caucasusSedition: (BoardArea.map, 0.0, 0.0),
      Location.caucasusViolence: (BoardArea.map, 0.0, 0.0),
      Location.caucasusGlasnost: (BoardArea.map, 0.0, 0.0),
      Location.caucasusPerestroika: (BoardArea.map, 0.0, 0.0),
      Location.caucasusWorkersParadise: (BoardArea.map, 890.0, 770.0),
      Location.centralAsiaSedition: (BoardArea.map, 0.0, 0.0),
      Location.centralAsiaViolence: (BoardArea.map, 0.0, 0.0),
      Location.centralAsiaGlasnost: (BoardArea.map, 0.0, 0.0),
      Location.centralAsiaPerestroika: (BoardArea.map, 0.0, 0.0),
      Location.centralAsiaWorkersParadise: (BoardArea.map, 1176.0, 355.0),
      Location.communistParty4: (BoardArea.map, 0.0, 0.0),
      Location.communistParty6: (BoardArea.map, 0.0, 0.0),
      Location.communistParty8: (BoardArea.map, 0.0, 0.0),
      Location.communistParty10: (BoardArea.map, 0.0, 0.0),
      Location.communistParty12: (BoardArea.map, 891.0, 346.0),
      Location.ddr: (BoardArea.map, 40.0, 817.0),
      Location.easternEurope: (BoardArea.map, 147.0, 938.0),
      Location.afghanistanMustStay: (BoardArea.map, 1108.0, 720.0),
      Location.afghanistanMayLeave: (BoardArea.map, 1250.0, 720.0),
      Location.boxWarsawPact: (BoardArea.map, 42.0, 155.0),
      Location.boxKgb: (BoardArea.map, 674.0, 136.0),
      Location.boxPolitburoSupport: (BoardArea.map, 1348.0, 613.0),
      Location.boxPolitburoOpposition: (BoardArea.map, 1348.0, 0.0),
      Location.boxDoctrine: (BoardArea.map, 60.0, 375.0),
      Location.boxUsPresident: (BoardArea.map, 520.5, 944.0),
      Location.fiveYearPlan0: (BoardArea.map, 965.0, 827.5),
      Location.mediaCulture0: (BoardArea.map, 965.0, 895.5),
      Location.militaryMight0: (BoardArea.map, 965.0, 966.5),
      Location.year1985: (BoardArea.map, 329.0, 24.0),
      Location.year1986: (BoardArea.map, 0.0, 0.0),
      Location.year1987: (BoardArea.map, 0.0, 0.0),
      Location.year1988: (BoardArea.map, 0.0, 0.0),
      Location.year1989: (BoardArea.map, 0.0, 0.0),
      Location.year1990: (BoardArea.map, 0.0, 0.0),
      Location.year1991: (BoardArea.map, 0.0, 0.0),
      Location.seasonWinter: (BoardArea.map, 871.0, 144.0),
      Location.seasonSpring: (BoardArea.map, 0.0, 0.0),
      Location.seasonSummer: (BoardArea.map, 0.0, 0.0),
      Location.seasonAutumn: (BoardArea.map, 0.0, 0.0),
      Location.trayYearSeason: (BoardArea.tray, 57.0, 181.0),
      Location.trayPeople: (BoardArea.tray, 194.0, 181.0),
      Location.trayVremya: (BoardArea.tray, 468.0, 181.0),
      Location.trayUsPresidents: (BoardArea.tray, 559.0, 181.0),
      Location.trayMassacre: (BoardArea.tray, 57.0, 258.0),
      Location.trayDisaster: (BoardArea.tray, 350.0, 258.0),
      Location.trayWarsawPact: (BoardArea.tray, 57.0, 333.0),
      Location.trayPolitburo: (BoardArea.tray, 345.0, 333.0),
      Location.trayPravda: (BoardArea.tray, 57.0, 408.0),
      Location.trayDemonstration: (BoardArea.tray, 202.0, 408.0),
      Location.trayKgb: (BoardArea.tray, 559.0, 408.0),
      Location.trayBerlinWall: (BoardArea.tray, 90.0, 481.0),
      Location.trayNukes: (BoardArea.tray, 200.0, 481.0),
      Location.trayForces: (BoardArea.tray, 345.0, 481.0),
      Location.trayMvd: (BoardArea.tray, 559.0, 481.0),
      Location.trayDoctrine: (BoardArea.tray, 57.0, 553.0),
      Location.trayAsset: (BoardArea.tray, 208.0, 553.0),
      Location.trayPopularVote: (BoardArea.tray, 468.0, 553.0),
      Location.trayLoyalCommunists: (BoardArea.tray, 578.0, 553.0),
      Location.trayUzbekMafia: (BoardArea.tray, 682.0, 553.0),
    };
    return coordinates[location]!;
  }

  void layoutLand(MyAppState appState, Location land) {
    final state = appState.gameState!;

    final coordinates = locationCoordinates(land);
    final xLand = coordinates.$2;
    final yLand = coordinates.$3;

    if (appState.playerChoices != null && appState.playerChoices!.selectedLocations.contains(land)) {
      addLandToMap(appState, land, xLand, yLand);
    }

    final pieces = state.piecesInLocation(PieceType.all, land);
    for (int i = 0; i < pieces.length; ++i) {
      addPieceToBoard(appState, pieces[i], BoardArea.map, xLand + 4.0 * i, yLand + 4.0 * i);
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
      Location.ddr: (1, 3, 0.0, 8.0),
      Location.easternEurope: (1, 1, 0.0, 0.0),
      Location.afghanistanMustStay: (1, 1, 0.0, 0.0),
      Location.afghanistanMayLeave: (1, 1, 0.0, 0.0),
      Location.boxWarsawPact: (3, 2, 15.0, 20.0),
      Location.boxKgb: (2, 1, 3.0, 0.0),
      Location.boxPolitburoSupport: (4, 3, 6.0, 4.0),
      Location.boxPolitburoOpposition: (4, 3, 6.0, 4.0),
      Location.boxDoctrine: (1, 1, 0.0, 0.0),
      Location.boxUsPresident: (1, 1, 0.0, 0.0),
      Location.year1985: (1, 1, 0.0, 0.0),
      Location.year1986: (1, 1, 0.0, 0.0),
      Location.year1987: (1, 1, 0.0, 0.0),
      Location.year1988: (1, 1, 0.0, 0.0),
      Location.year1989: (1, 1, 0.0, 0.0),
      Location.year1990: (1, 1, 0.0, 0.0),
      Location.year1991: (1, 1, 0.0, 0.0),
      Location.seasonWinter: (1, 1, 0.0, 0.0),
      Location.seasonSpring: (1, 1, 0.0, 0.0),
      Location.seasonSummer: (1, 1, 0.0, 0.0),
      Location.seasonAutumn: (1, 1, 0.0, 0.0),
      Location.trayYearSeason: (2, 1, 10.0, 0.0),
      Location.trayPeople: (4, 1, 3.0, 0.0),
      Location.trayVremya: (1, 1, 0.0, 0.0),
      Location.trayUsPresidents: (3, 1, 10.0, 0.0),
      Location.trayMassacre: (4, 1, 10.0, 0.0),
      Location.trayDisaster: (6, 1, 10.0, 0.0),
      Location.trayWarsawPact: (4, 1, 10.0, 0.0),
      Location.trayPolitburo: (6, 1, 10.0, 0.0),
      Location.trayPravda: (2, 1, 10.0, 0.0),
      Location.trayDemonstration: (5, 1, 10.0, 0.0),
      Location.trayKgb: (3, 1, 10.0, 0.0),
      Location.trayBerlinWall: (1, 1, 0.0, 0.0),
      Location.trayNukes: (2, 1, 10.0, 0.0),
      Location.trayForces: (3, 1, 10.0, 0.0),
      Location.trayMvd: (3, 1, 10.0, 0.0),
      Location.trayDoctrine: (2, 1, 10.0, 0.0),
      Location.trayAsset: (3, 1, 20.0, 0.0),
      Location.trayPopularVote: (1, 1, 0.0, 0.0),
      Location.trayLoyalCommunists: (1, 1, 0.0, 0.0),
      Location.trayUzbekMafia: (1, 1, 0.0, 0.0),
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
        x += depth * 5.0;
        y += depth * 5.0;
        addPieceToBoard(appState, pieces[i], boardArea, x, y);
      }

      //if (appState.playerChoices != null && appState.playerChoices!.locations.contains(box)) {
      //  addBoxToMap(appState, box, xBox, yBox);
      //}
    }
  }

  void layoutAssetTrack(MyAppState appState, LocationType locationType, Piece piece) {
    final state = appState.gameState!;
    final coordinatesFirst = locationCoordinates(locationType.locations[0]);
    final xFirst = coordinatesFirst.$2;
    final yBox = coordinatesFirst.$3;
    for (final box in locationType.locations) {
      final xBox = xFirst + (box.index - locationType.firstIndex) * 93.7;
      if (state.pieceLocation(piece) == box) {
        addPieceToBoard(appState, piece, BoardArea.map, xBox, yBox);
      }
    }
  }

  void layoutAssetTracks(MyAppState appState) {
    const trackInfos = [
      (LocationType.fiveYearPlan, Piece.assetFiveYearPlan),
      (LocationType.mediaCulture, Piece.assetMediaCulture),
      (LocationType.militaryMight, Piece.assetMilitaryMight),
    ];
    for (final trackInfo in trackInfos) {
      layoutAssetTrack(appState, trackInfo.$1, trackInfo.$2);
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

  void layoutTurn(MyAppState appState) {
    final state = appState.gameState!;

    final firstBoxCoordinates = locationCoordinates(Location.turn1);
    final xFirst = firstBoxCoordinates.$2;
    final yFirst = firstBoxCoordinates.$3;
    final box = state.pieceLocation(Piece.turn);
    int index = box.index - LocationType.turn.firstIndex;
    int xIndex = index % 9;
    int yIndex = index ~/ 9;
    final xBox = xFirst + 108.0 * xIndex;
    final yBox = yFirst + 95.0 * yIndex;
    addPieceToBoard(appState, Piece.turn, BoardArea.reference, xBox, yBox);
  }
  */

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
    _trayStackChildren.add(_trayImage);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (gameState != null) {

      layoutLands(appState);
      layoutBoxes(appState);
      layoutAssetTracks(appState);
      /*
      layoutTrack(appState);
      layoutTurn(appState);
      */

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
                shrinkWrap: true,
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

import 'dart:convert';
import 'dart:math';
import 'package:mrs_thatchers_war/db.dart';
import 'package:mrs_thatchers_war/random.dart';

enum Location {
  argentineMainland,
  seaZoneCommodoroRivadavia,
  seaZonePuertoDeseado,
  seaZoneSanJulian,
  seaZoneSantaCruz,
  seaZoneRioGallegos,
  seaZoneRioGrande,
  ascensionIsland,
  falklandIslandsTotalExclusionZone,
  tralaAndSouthGeorgia,
  sanCarlosLandingZone,
  campCerroMontevideo,
  campNewHouse,
  campLetterboxHill,
  campDouglasStation,
  campChataRincon,
  campTealInlet,
  campEstanciaHouse,
  campMountEstancia,
  campMurrellBridge,
  campMountLongdon,
  campWirelessRidge,
  campVerdeHills,
  campThirdCorralEast,
  campBambillaHill,
  campOutsideChata,
  campMountSimon,
  campTopMaloHouse,
  campCentreBrook,
  campLowerMalo,
  campMountKent,
  campTwoSisters,
  campTumbledown,
  campSussexMountains,
  campPortSussex,
  campCamillaCreekHouse,
  campDarwin,
  campGooseGreen,
  campTealCreek,
  campBluffCreek,
  campMidRancho,
  campSwanInletHouse,
  campMountPleasant,
  campFitzroy,
  campBluffCove,
  campMountHarriet,
  campMountWilliam,
  stanley,
  airstripPebbleIsland,
  airstripGooseGreen,
  groundSupportArg0,
  groundSupportArg1,
  groundSupportArg2,
  groundSupportGbr0,
  groundSupportGbr1,
  groundSupportGbr2,
  groundSupportGbr3,
  weatherFog,
  weatherFair,
  weatherRainSnow,
  weatherSqualls,
  weatherGales,
  turn0,
  turn1,
  turn2,
  turn3,
  turn4,
  turn5,
  turn6,
  turn7,
  turn8,
  turn9,
  turn10,
  turn11,
  turn12,
  turn13,
  turn14,
  turn15,
  turn16,
  turn17,
  turn18,
  turn19,
  cupAirArg,
  flipped,
  offmap,
}

Location? locationFromIndex(int? index) {
  if (index != null) {
    return Location.values[index];
  } else {
    return null;
  }
}

int? locationToIndex(Location? location) {
  return location?.index;
}

List<Location> locationListFromIndices(List<int> indices) {
  final locations = <Location>[];
  for (final index in indices) {
    locations.add(Location.values[index]);
  }
  return locations;
}

List<int> locationListToIndices(List<Location> locations) {
  final indices = <int>[];
  for (final location in locations) {
    indices.add(location.index);
  }
  return indices;
}

enum LocationType {
  seaZone,
  camp,
  pathYellow,
  pathBrown,
  pathGreen,
  airstrip,
  turn,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.seaZone: [Location.seaZoneCommodoroRivadavia, Location.seaZoneRioGrande],
    LocationType.camp: [Location.campCerroMontevideo, Location.campMountWilliam],
    LocationType.pathYellow: [Location.campCerroMontevideo, Location.campWirelessRidge],
    LocationType.pathBrown: [Location.campVerdeHills, Location.campTumbledown],
    LocationType.pathGreen: [Location.campSussexMountains, Location.campMountWilliam],
    LocationType.airstrip: [Location.airstripPebbleIsland, Location.airstripGooseGreen],
    LocationType.turn: [Location.turn0, Location.turn19],
  };

  int get firstIndex {
    return _bounds[this]![0].index;
  }

  int get lastIndex {
    return _bounds[this]![1].index + 1;
  }

  int get count {
    return lastIndex - firstIndex;
  }

  List<Location> get locations {
    final ls = <Location>[];
    for (int index = firstIndex; index < lastIndex; ++index) {
      ls.add(Location.values[index]);
    }
    return ls;
  }
}

extension LocationExtension on Location {
  String get desc {
    const locationDescs = {
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Path {
  yellow,
  brown,
  green,
}

extension PathExtension on Path {
  LocationType get locationType {
    const pathLocationTypes = {
      Path.yellow: LocationType.pathYellow,
      Path.brown: LocationType.pathBrown,
      Path.green: LocationType.pathGreen,
    };
    return pathLocationTypes[this]!;
  }
}

enum Piece {
  airArgA4_0,
  airArgA4_1,
  airArgA4_2,
  airArgA4_3,
  airArgA4_4,
  airArgAM_0,
  airArgCB_0,
  airArgDG_0,
  airArgDG_1,
  airArgDG_2,
  airArgDG_3,
  airArgDG_4,
  airArgDM_0,
  airArgDM_1,
  airArgDM_2,
  airArgSE_0,
  airGbrHH_0,
  airGbrHH_1,
  airGbrHH_2,
  airGbrHH_3,
  airGbrHH_4,
  airGbrHH_5,
  airGbrHH_6,
  airGbrHH_7,
  airGbrHH_8,
  airGbrHI_0,
  airGbrHI_1,
  airGbrHI_2,
  airGbrHI_3,
  airGbrHI_4,
  airGbrHI_5,
  airGbrHI_6,
  airGbrHI_7,
  navalArgGrupo1,
  navalArgGrupo2,
  navalArgGrupo3,
  navalArgGrupo4,
  navalArgGrupo5,
  navalArgGrupo6,
  navalArgGrupo7,
  navalArgGrupo8,
  navalArgGrupo9,
  navalArgGrupo10,
  navalArgGrupo1Back,
  navalArgGrupo2Back,
  navalArgGrupo3Back,
  navalArgGrupo4Back,
  navalArgGrupo5Back,
  navalArgGrupo6Back,
  navalArgGrupo7Back,
  navalArgGrupo8Back,
  navalArgGrupo9Back,
  navalArgGrupo10Back,
  navalArgBelgrano,
  navalArg25DeMayo,
  navalGbrHermes,
  navalGbrInvincible,
  navalGbrIwoJima,
  navalGbrEscorts0,
  navalGbrEscorts1,
  navalGbrStuft,
  groundArgFTMerc,
  groundArgRI7,
  groundArgECSolari,
  groundArgRI4,
  groundArgBIM5,
  groundArgCdo602,
  groundArgPU0,
  groundArgPU1,
  groundArgMineField,
  groundArgPatrol0,
  groundArgPatrol1,
  groundArgPatrol2,
  groundArgECSolariBack,
  groundArgCdo602Back,
  groundArgMineFieldBack,
  groundArgPatrol0Back,
  groundArgPatrol1Back,
  groundArgPatrol2Back,
  groundGbr45Cdo,
  groundGbrGurkhas,
  groundGbrScotsGds,
  groundGbrWelshGds,
  groundGbr2Para,
  groundGbr3Para,
  groundGbr40Cdo,
  groundGbr42Cdo,
  groundGbrSAS,
  groundGbrBR,
  groundGbrRA,
  groundGbrKLF,
  groundGbrHeli0,
  groundGbrHeli1,
  groundGbrHeli2,
  groundGbr45CdoOutOfSupply,
  groundGbrGurkhasOutOfSupply,
  groundGbrScotsGdsOutOfSupply,
  groundGbrWelshGdsOutOfSupply,
  groundGbr2ParaOutOfSupply,
  groundGbr3ParaOutOfSupply,
  groundGbr40CdoOutOfSupply,
  groundGbr42CdoOutOfSupply,
  groundGbrSASOutOfSupply,
  groundGbrBROutOfSupply,
  groundGbrRAOutOfSupply,
  groundGbrKLFOutOfSupply,
  groundGbrHeli0OutOfSupply,
  groundGbrHeli1OutOfSupply,
  groundGbrHeli2OutOfSupply,
  markerTurn,
  markerBBCNews,
  markerExocet,
  markerPope,
  markerChileanRadar,
  markerDiplomacy,
  markerTargetAirSector,
  markerWeather,
  markerWeatherNoAir,
  markerGroundSupportArg,
  markerGroundSupportGbr,
}

Piece? pieceFromIndex(int? index) {
  if (index != null) {
    return Piece.values[index];
  } else {
    return null;
  }
}

int? pieceToIndex(Piece? location) {
  return location?.index;
}

List<Piece> pieceListFromIndices(List<int> indices) {
  final pieces = <Piece>[];
  for (final index in indices) {
    pieces.add(Piece.values[index]);
  }
  return pieces;
}

List<int> pieceListToIndices(List<Piece> pieces) {
  final indices = <int>[];
  for (final piece in pieces) {
    indices.add(piece.index);
  }
  return indices;
}

enum PieceType {
  all,
  airArg,
  navalArgGrupo,
  ground,
  groundArgPucara,
  groundArgBack,
  groundGbr,
  groundGbrHeli,
  groundGbrOutOfSupply,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.airArgA4_0, Piece.markerGroundSupportGbr],
    PieceType.airArg: [Piece.airArgA4_0, Piece.airArgSE_0],
    PieceType.navalArgGrupo: [Piece.navalArgGrupo1, Piece.navalArgGrupo10],
    PieceType.ground: [Piece.groundArgFTMerc, Piece.groundGbrHeli2OutOfSupply],
    PieceType.groundArgPucara: [Piece.groundArgPU0, Piece.groundArgPU1],
    PieceType.groundArgBack: [Piece.groundArgECSolariBack, Piece.groundArgPatrol2Back],
    PieceType.groundGbr: [Piece.groundGbr45Cdo, Piece.groundGbrHeli2OutOfSupply],
    PieceType.groundGbrHeli: [Piece.groundGbrHeli0, Piece.groundGbrHeli2],
    PieceType.groundGbrOutOfSupply: [Piece.groundGbr45CdoOutOfSupply, Piece.groundGbrHeli2OutOfSupply],
  };

  int get firstIndex {
    return _bounds[this]![0].index;
  }

  int get lastIndex {
    return _bounds[this]![1].index + 1;
  }

  int get count {
    return lastIndex - firstIndex;
  }

  List<Piece> get pieces {
    final ps = <Piece>[];
    for (int index = firstIndex; index < lastIndex; ++index) {
      ps.add(Piece.values[index]);
    }
    return ps;
  }
}

extension PieceExtension on Piece {
  String get desc {
    return '';
  }

  bool isType(PieceType pieceType) {
    return index >= pieceType.firstIndex && index < pieceType.lastIndex;
  }
}

enum LimitedEvent {
  operationMikado,
}

enum Scenario {
  standard,
}

extension ScenarioExtension on Scenario {
  String get desc {
    const scenarioDescs = {
      Scenario.standard: 'Standard',
    };
    return scenarioDescs[this]!;
  }

  String get longDesc {
    const scenarioDescs = {
      Scenario.standard: 'Standard (19 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<int> _limitedEventCounts = List<int>.filled(LimitedEvent.values.length, 0);

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
   : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
   , _limitedEventCounts = List<int>.from(json['limitedEventCounts'])
   ;

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'limitedEventCounts': _limitedEventCounts,
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.navalArgGrupo1: Piece.navalArgGrupo1Back,
      Piece.navalArgGrupo2: Piece.navalArgGrupo2Back,
      Piece.navalArgGrupo3: Piece.navalArgGrupo3Back,
      Piece.navalArgGrupo4: Piece.navalArgGrupo4Back,
      Piece.navalArgGrupo5: Piece.navalArgGrupo5Back,
      Piece.navalArgGrupo6: Piece.navalArgGrupo6Back,
      Piece.navalArgGrupo7: Piece.navalArgGrupo7Back,
      Piece.navalArgGrupo8: Piece.navalArgGrupo8Back,
      Piece.navalArgGrupo9: Piece.navalArgGrupo9Back,
      Piece.navalArgGrupo10: Piece.navalArgGrupo10Back,
      Piece.navalArgGrupo1Back: Piece.navalArgGrupo1,
      Piece.navalArgGrupo2Back: Piece.navalArgGrupo2,
      Piece.navalArgGrupo3Back: Piece.navalArgGrupo3,
      Piece.navalArgGrupo4Back: Piece.navalArgGrupo4,
      Piece.navalArgGrupo5Back: Piece.navalArgGrupo5,
      Piece.navalArgGrupo6Back: Piece.navalArgGrupo6,
      Piece.navalArgGrupo7Back: Piece.navalArgGrupo7,
      Piece.navalArgGrupo8Back: Piece.navalArgGrupo8,
      Piece.navalArgGrupo9Back: Piece.navalArgGrupo9,
      Piece.navalArgGrupo10Back: Piece.navalArgGrupo10,
      Piece.groundArgECSolari: Piece.groundArgECSolariBack,
      Piece.groundArgCdo602: Piece.groundArgCdo602Back,
      Piece.groundArgMineField: Piece.groundArgMineFieldBack,
      Piece.groundArgPatrol0: Piece.groundArgPatrol0Back,
      Piece.groundArgPatrol1: Piece.groundArgPatrol1Back,
      Piece.groundArgPatrol2: Piece.groundArgPatrol2Back,
      Piece.groundArgECSolariBack: Piece.groundArgECSolari,
      Piece.groundArgCdo602Back: Piece.groundArgCdo602,
      Piece.groundArgMineFieldBack: Piece.groundArgMineField,
      Piece.groundArgPatrol0Back: Piece.groundArgPatrol0,
      Piece.groundArgPatrol1Back: Piece.groundArgPatrol1,
      Piece.groundArgPatrol2Back: Piece.groundArgPatrol2,
      Piece.groundGbr45Cdo: Piece.groundGbr45CdoOutOfSupply,
      Piece.groundGbrGurkhas: Piece.groundGbrGurkhasOutOfSupply,
      Piece.groundGbrScotsGds: Piece.groundGbrScotsGdsOutOfSupply,
      Piece.groundGbrWelshGds: Piece.groundGbrWelshGdsOutOfSupply,
      Piece.groundGbr2Para: Piece.groundGbr2ParaOutOfSupply,
      Piece.groundGbr3Para: Piece.groundGbr3ParaOutOfSupply,
      Piece.groundGbr40Cdo: Piece.groundGbr40CdoOutOfSupply,
      Piece.groundGbr42Cdo: Piece.groundGbr42CdoOutOfSupply,
      Piece.groundGbrSAS: Piece.groundGbrSASOutOfSupply,
      Piece.groundGbrBR: Piece.groundGbrBROutOfSupply,
      Piece.groundGbrRA: Piece.groundGbrRAOutOfSupply,
      Piece.groundGbrKLF: Piece.groundGbrKLFOutOfSupply,
      Piece.groundGbrHeli0: Piece.groundGbrHeli0OutOfSupply,
      Piece.groundGbrHeli1: Piece.groundGbrHeli1OutOfSupply,
      Piece.groundGbrHeli2: Piece.groundGbrHeli2OutOfSupply,
      Piece.groundGbr45CdoOutOfSupply: Piece.groundGbr45Cdo,
      Piece.groundGbrGurkhasOutOfSupply: Piece.groundGbrGurkhas,
      Piece.groundGbrScotsGdsOutOfSupply: Piece.groundGbrScotsGds,
      Piece.groundGbrWelshGdsOutOfSupply: Piece.groundGbrWelshGds,
      Piece.groundGbr2ParaOutOfSupply: Piece.groundGbr2Para,
      Piece.groundGbr3ParaOutOfSupply: Piece.groundGbr3Para,
      Piece.groundGbr40CdoOutOfSupply: Piece.groundGbr40Cdo,
      Piece.groundGbr42CdoOutOfSupply: Piece.groundGbr42Cdo,
      Piece.groundGbrSASOutOfSupply: Piece.groundGbrSAS,
      Piece.groundGbrBROutOfSupply: Piece.groundGbrBR,
      Piece.groundGbrRAOutOfSupply: Piece.groundGbrRA,
      Piece.groundGbrKLFOutOfSupply: Piece.groundGbrKLF,
      Piece.groundGbrHeli0OutOfSupply: Piece.groundGbrHeli0,
      Piece.groundGbrHeli1OutOfSupply: Piece.groundGbrHeli1,
      Piece.groundGbrHeli2OutOfSupply: Piece.groundGbrHeli2,
      Piece.markerWeather: Piece.markerWeatherNoAir,
      Piece.markerWeatherNoAir: Piece.markerWeather,
    };
    return pieceFlipSides[piece];
  }

  Location pieceLocation(Piece piece) {
    return _pieceLocations[piece.index];
  }

  void setPieceLocation(Piece piece, Location location) {
    _pieceLocations[piece.index] = location;
    final obverse = pieceFlipSide(piece);
    if (obverse != null) {
        _pieceLocations[obverse.index] = Location.flipped;
    }
  }

  void flipPiece(Piece piece) {
    final location = _pieceLocations[piece.index];
    final obverse = pieceFlipSide(piece)!;
    _pieceLocations[obverse.index] = location;
    _pieceLocations[piece.index] = Location.flipped;
  }

  List<Piece> piecesInLocation(PieceType pieceType, Location location) {
    final pieces = <Piece>[];
    for (final piece in pieceType.pieces) {
      if (pieceLocation(piece) == location) {
        pieces.add(piece);
      }
    }
    return pieces;
  }

  Piece? pieceInLocation(PieceType pieceType, Location location) {
    for (final piece in pieceType.pieces) {
      if (pieceLocation(piece) == location) {
        return piece;
      }
    }
    return null;
  }

  int piecesInLocationCount(PieceType pieceType, Location location) {
    int count = 0;
    for (final piece in pieceType.pieces) {
      if (pieceLocation(piece) == location) {
        count += 1;
      }
    }
    return count;
  }

  // Camps

  Path campPath(Location camp) {
    for (final path in Path.values) {
      final locationType = path.locationType;
      if (camp.isType(locationType)) {
        return path;
      }
    }
    return Path.brown;
  }

  // Ground

  List<Path> get heliPaths {
    final paths = <Path>[];
    for (final heli in PieceType.groundGbrHeli.pieces) {
      final location = pieceLocation(heli);
      if (location.isType(LocationType.camp)) {
        paths.add(campPath(location));
      }
    }
    return paths;
  }

  // Turns

  Location turnBox(int turn) {
    if (turn >= LocationType.turn.count) {
      return Location.offmap;
    }
    return Location.values[LocationType.turn.firstIndex + turn];
  }

  int get currentTurn {
    final turnLocation = pieceLocation(Piece.markerTurn);
    return turnLocation.index - LocationType.turn.firstIndex;
  }

  String turnName(int turn) {
    const turnNames = [
      'Turn 0',
      '25th–30th April',
      '1st–3rd May',
      '4th–6th May',
      '7th–9th May',
      '10th–12th May',
      '13th–15th May',
      '16th–18th May',
      '19th–21st May',
      '22nd–24th May',
      '25th–27th May',
      '28th–30th May',
      '31st May–2nd June',
      '3rd–5th June',
      '6th–8th June',
      '9th–11th June',
      '12th–14th June',
      '15th–17th June',
      '18th–20th June',
      '21st–23rd June',
    ];
    return turnNames[turn];
  }

  void advanceTurn() {
    setPieceLocation(Piece.markerTurn, Location.values[pieceLocation(Piece.markerTurn).index + 1]);
  }

  // Exocets

  int get exocetCount {
    final location = pieceLocation(Piece.markerExocet);
    if (!location.isType(LocationType.turn)) {
      return 0;
    }
    return location.index - LocationType.turn.firstIndex;
  }

  void adjustExocetCount(int delta) {
    int newValue = exocetCount + delta;
    if (newValue <= 0) {
      setPieceLocation(Piece.markerExocet, Location.offmap);
    } else {
      setPieceLocation(Piece.markerExocet, turnBox(newValue));
    }
  }

  // Limited Events

  int limitedEventCount(LimitedEvent event) {
    return _limitedEventCounts[event.index];
  }

  void setLimitedEventOccurred(LimitedEvent event) {
    _limitedEventCounts[event.index] += 1;
  }

  // Setup

  void setupPieces(List<(Piece, Location)> pieces) {
    for (final record in pieces) {
      final piece = record.$1;
      final location = record.$2;
      setPieceLocation(piece, location);
    }
  }

  void setupPieceType(PieceType pieceType, Location location) {
    for (final piece in pieceType.pieces) {
      setPieceLocation(piece, location);
    }
  }

  void setupPieceTypes(List<(PieceType, Location)> pieceTypes) {
    for (final record in pieceTypes) {
      final pieceType = record.$1;
      final location = record.$2;
      setupPieceType(pieceType, location);
    }
  }

  factory GameState.setupStandard(Random random) {

    var state = GameState();

    final groundArgBacks = PieceType.groundArgBack.pieces;
    groundArgBacks.shuffle(random);

    int exocetRoll = random.nextInt(6) + 1;
    Location? exocetTurnBox;
    if (exocetRoll == 1) {
      exocetTurnBox = Location.turn4;
    } else if (exocetRoll == 2) {
      exocetTurnBox = Location.turn6;
    } else {
      exocetTurnBox = Location.turn5;
    }

    final grupos = PieceType.navalArgGrupo.pieces;
    grupos.shuffle(random);

    state.setupPieceTypes([
      (PieceType.navalArgGrupo, Location.argentineMainland),
      (PieceType.airArg, Location.cupAirArg),
    ]);
  
    state.setupPieces([
      (Piece.groundArgBIM5, Location.stanley),
      (Piece.groundArgRI4, Location.stanley),
      (Piece.groundArgRI7, Location.stanley),
      (Piece.groundArgFTMerc, Location.campDarwin),
      (groundArgBacks[0], Location.campCerroMontevideo),
      (groundArgBacks[1], Location.campDouglasStation),
      (groundArgBacks[2], Location.campTealInlet),
      (groundArgBacks[3], Location.campTopMaloHouse),
      (groundArgBacks[4], Location.campGooseGreen),
      (groundArgBacks[5], Location.campFitzroy),
      (Piece.markerTurn, Location.turn1),
      (Piece.groundGbrSAS, Location.turn1),
      (Piece.markerBBCNews, Location.turn15),
      (Piece.markerExocet, exocetTurnBox),
      (grupos[0], Location.seaZoneRioGrande),
      (grupos[1], Location.seaZoneRioGallegos),
      (grupos[2], Location.seaZoneSantaCruz),
      (grupos[3], Location.seaZoneSanJulian),
      (Piece.navalArgBelgrano, Location.argentineMainland),
      (Piece.navalArg25DeMayo, Location.argentineMainland),
      (Piece.groundArgPU0, Location.airstripPebbleIsland),
      (Piece.groundArgPU1, Location.airstripGooseGreen),
      (Piece.groundGbrHeli0, Location.offmap),
      (Piece.groundGbrHeli1, Location.offmap),
      (Piece.groundGbrHeli2, Location.offmap),
      (Piece.groundGbrKLF, Location.offmap),
      (Piece.markerPope, Location.offmap),
      (Piece.markerChileanRadar, Location.offmap),
      (Piece.markerDiplomacy, Location.offmap),
      (Piece.navalGbrStuft, Location.offmap),
      (Piece.groundGbrGurkhas, Location.offmap),
      (Piece.navalGbrIwoJima, Location.offmap),
      (Piece.groundGbrWelshGds, Location.offmap),
      (Piece.groundGbrScotsGds, Location.offmap),
      (Piece.markerTargetAirSector, Location.offmap),
      (Piece.markerGroundSupportGbr, Location.groundSupportGbr0),
      (Piece.markerGroundSupportArg, Location.groundSupportArg0),
      (Piece.markerWeather, Location.weatherFair),
      (Piece.groundGbr40Cdo, Location.ascensionIsland),
      (Piece.groundGbr42Cdo, Location.ascensionIsland),
      (Piece.groundGbr45Cdo, Location.ascensionIsland),
      (Piece.groundGbr2Para, Location.ascensionIsland),
      (Piece.groundGbr3Para, Location.ascensionIsland),
      (Piece.groundGbrRA, Location.ascensionIsland),
      (Piece.airGbrHH_0, Location.falklandIslandsTotalExclusionZone),
      (Piece.airGbrHH_1, Location.falklandIslandsTotalExclusionZone),
      (Piece.airGbrHH_2, Location.falklandIslandsTotalExclusionZone),
      (Piece.airGbrHH_3, Location.falklandIslandsTotalExclusionZone),
      (Piece.airGbrHH_4, Location.falklandIslandsTotalExclusionZone),
      (Piece.airGbrHH_5, Location.falklandIslandsTotalExclusionZone),
      (Piece.airGbrHI_0, Location.falklandIslandsTotalExclusionZone),
      (Piece.airGbrHI_1, Location.falklandIslandsTotalExclusionZone),
      (Piece.airGbrHI_2, Location.falklandIslandsTotalExclusionZone),
      (Piece.airGbrHI_3, Location.falklandIslandsTotalExclusionZone),
      (Piece.airGbrHH_6, Location.ascensionIsland),
      (Piece.airGbrHH_7, Location.ascensionIsland),
      (Piece.airGbrHH_8, Location.ascensionIsland),
      (Piece.airGbrHI_4, Location.ascensionIsland),
      (Piece.airGbrHI_5, Location.ascensionIsland),
      (Piece.airGbrHI_6, Location.ascensionIsland),
      (Piece.airGbrHI_7, Location.ascensionIsland),
      (Piece.navalGbrInvincible, Location.falklandIslandsTotalExclusionZone),
      (Piece.navalGbrHermes, Location.falklandIslandsTotalExclusionZone),
      (Piece.navalGbrEscorts0, Location.falklandIslandsTotalExclusionZone),
      (Piece.navalGbrEscorts1, Location.falklandIslandsTotalExclusionZone),
    ]);

    return state;
  }
}

enum Choice {
  sasRaidOperationMikado,
  sasRaidSpoofing,
  yes,
  no,
  cancel,
  next,
}

List<Choice> choiceListFromIndices(List<int> indices) {
  final choices = <Choice>[];
  for (final index in indices) {
    choices.add(Choice.values[index]);
  }
  return choices;
}

List<int> choiceListToIndices(List<Choice> choices) {
  final indices = <int>[];
  for (final choice in choices) {
    indices.add(choice.index);
  }
  return indices;
}

class PlayerChoice {
  Location? location;
  Piece? piece;
  Choice? choice;

  PlayerChoice();
}

class PlayerChoiceInfo {
  String prompt = '';
  List<Location> locations = <Location>[];
  List<Piece> pieces = <Piece>[];
  List<Choice> choices = <Choice>[];
  List<Choice> disabledChoices = <Choice>[];
  List<Location> selectedLocations = <Location>[];
  List<Piece> selectedPieces = <Piece>[];
  List<Choice> selectedChoices = <Choice>[];

  PlayerChoiceInfo();

  PlayerChoiceInfo.fromJson(Map<String, dynamic> json) {
    prompt = json['prompt'] as String;
    locations = locationListFromIndices(List<int>.from(json['locations']));
    pieces = pieceListFromIndices(List<int>.from(json['pieces']));
    choices = choiceListFromIndices(List<int>.from(json['choices']));
    disabledChoices = choiceListFromIndices(List<int>.from(json['disabledChoices']));
    selectedLocations = locationListFromIndices(List<int>.from(json['selectedLocations']));
    selectedPieces = pieceListFromIndices(List<int>.from(json['selectedPieces']));
    selectedChoices = choiceListFromIndices(List<int>.from(json['selectedChoices']));
  }

  Map<String, dynamic> toJson() => {
    'prompt': prompt,
    'locations': locationListToIndices(locations),
    'pieces': pieceListToIndices(pieces),
    'choices': choiceListToIndices(choices),
    'disabledChoices': choiceListToIndices(disabledChoices),
    'selectedLocations': locationListToIndices(selectedLocations),
    'selectedPieces': pieceListToIndices(selectedPieces),
    'selectedChoices': choiceListToIndices(selectedChoices),
  };

  void update(PlayerChoice choice) {
    if (choice.location != null) {
      selectedLocations.add(choice.location!);
    }
    if (choice.piece != null) {
      selectedPieces.add(choice.piece!);
    }
    if (choice.choice != null) {
      selectedChoices.add(choice.choice!);
    }
    locations.clear();
    pieces.clear();
    choices.clear();
    disabledChoices.clear();
  }

  void clear() {
    prompt = '';
    locations.clear();
    pieces.clear();
    choices.clear();
    disabledChoices.clear();
    selectedLocations.clear();
    selectedPieces.clear();
    selectedChoices.clear();
  }
}

class PlayerChoiceException implements Exception {
  bool saveSnapshot = false;

  PlayerChoiceException();
  PlayerChoiceException.withSnapshot() : saveSnapshot = true;
}

enum GameResult {
  defeatBattle,
  defeatLegion,
  defeatTreasury,
  defeatVictoryThreshold,
  defeatCalgacus,
  victory,
}

class GameOutcome {
  GameResult result;
  int score = 0;

  GameOutcome(this.result, this.score);

  GameOutcome.fromJson(Map<String, dynamic> json) :
    result = GameResult.values[json['result'] as int],
    score = json['score'] as int;

  Map<String, dynamic> toJson() => {
    'result': result.index,
    'score': score,
  };
}

class GameOverException implements Exception {
  GameOutcome outcome;

  GameOverException(GameResult result, int score) : outcome = GameOutcome(result, score);
}

class GameOptions {
  GameOptions();

  GameOptions.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() => {
  };

  String get desc {
    String optionsList = '';
    return optionsList;
  }
}

/*

enum Phase {
  barbarian,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateBarbarian extends PhaseState {
  List<Location> groupInitialProvinces = [];
  List<int> groupInitialCounts = [];
  List<bool> groupCivilizeds = [];
  int? currentGroupIndex;
  Location? currentGroupProvince;
  List<Location> currentGroupTrail = [];

  PhaseStateBarbarian();

  PhaseStateBarbarian.fromJson(Map<String, dynamic> json) :
    groupInitialProvinces = locationListFromIndices(json['groupInitialProvinces']),
    groupInitialCounts = List<int>.from(json['groupInitialCounts']),
    groupCivilizeds = List<bool>.from(json['groupCivilizeds']),
    currentGroupIndex = json['currentGroupIndex'] as int?,
    currentGroupProvince = locationFromIndex(json['currentGroupProvince']),
    currentGroupTrail = locationListFromIndices(json['currentGroupTrail']);

  @override
  Map<String, dynamic> toJson() => {
    'groupInitialProvinces': locationListToIndices(groupInitialProvinces),
    'groupInitialCounts': groupInitialCounts,
    'groupCivilizeds': groupCivilizeds,
    'currentGroupIndex': currentGroupIndex,
    'currentGroupProvince': locationToIndex(currentGroupProvince),
    'currentGroupTrail': locationListToIndices(currentGroupTrail),
  };

  @override
  Phase get phase {
    return Phase.barbarian;
  }
}
*/

class Game {
  final Scenario _scenario;
  final GameState _state;
  int _step = 0;
  int _subStep = 0;
  GameOutcome? _outcome;
  final GameOptions _options;
  String _log = '';
  PlayerChoiceInfo _choiceInfo = PlayerChoiceInfo();
  //PhaseState? _phaseState;
  final Random _random;
  final int _gameId;

  Game(this._gameId, this._scenario, this._options, this._state, this._random)
    : _choiceInfo = PlayerChoiceInfo();

  Game.inProgress(this._gameId, this._scenario, this._options, this._state, this._random, this._step, this._subStep, this._log, Map<String, dynamic> gameStateJson) {
    _gameStateFromJson(gameStateJson);
  }

  Game.completed(this._gameId, this._scenario, this._options, this._state, this._random, this._step, this._subStep, this._log, Map<String, dynamic> gameOutcomeJson) {
    _outcome = GameOutcome.fromJson(gameOutcomeJson);
  }

  Game.snapshot(this._gameId, this._scenario, this._options, this._state, this._random, this._step, this._subStep, this._log);

  void _gameStateFromJson(Map<String, dynamic> json) {
    /*
    _phaseState = null;
    final phaseIndex = json['phase'] as int?;
    if (phaseIndex != null) {
      final phaseStateJson = json['phaseState'];
      switch (Phase.values[phaseIndex]) {
      case Phase.barbarian:
        _phaseState = PhaseStateBarbarian.fromJson(phaseStateJson);
      }
    }
    */

    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
    /*
    if (_phaseState != null) {
      map['phase'] = _phaseState!.phase.index;
      map['phaseState'] = _phaseState!.toJson();
    }
    */
    map['choiceInfo'] = _choiceInfo.toJson();
    return map;
  }

  Future<void> saveSnapshot() async {
    await GameDatabase.instance.appendGameSnapshot(
      _gameId,
      jsonEncode(_state.toJson()),
      jsonEncode(randomToJson(_random)),
      _step, _subStep,
      _state.currentTurn,
      _state.turnName(_state.currentTurn),
      _log);
  }

  Future<void> saveCurrentState() async {
    await GameDatabase.instance.setGameState(
      _gameId,
      jsonEncode(_state.toJson()),
      jsonEncode(randomToJson(_random)),
      _step, _subStep,
      _state.currentTurn,
      _state.turnName(_state.currentTurn),
      jsonEncode(gameStateToJson()),
      _log);
  }

  Future<void> saveCompletedGame(GameOutcome outcome) async {
    await GameDatabase.instance.completeGame(_gameId, jsonEncode(outcome.toJson()));
  }

  // Logging

  String get log {
    return _log;
  }

  void logLine(String line) {
    _log += '$line\n';
  }

  void logTableHeader() {
    logLine('>|Effect|Value|');
    logLine('>|:---|:---:|');
  }

  // Randomness

  String dieFace(int die) {
    return '![](resource:assets/images/d6_$die.png)';
  }

  int rollD6() {
    int die = _random.nextInt(6) + 1;
    return die;
  }

  void logD6(int die) {
    logLine('>');
    logLine('>${dieFace(die)}');
    logLine('>');
  }

  void logD6InTable(int die) {
    logLine('>|${dieFace(die)}|$die|');
  }

  (int,int,int) roll2D6() {
    int value = _random.nextInt(36);
    int d0 = value % 6 + 1;
    int d1 = value ~/ 6 + 1;
    return (d0, d1, d0 + d1);
  }

  void log2D6((int,int,int) results) {
    int d0 = results.$1;
    int d1 = results.$2;
    logLine('>');
    logLine('>${dieFace(d0)} ${dieFace(d1)}');
    logLine('>');
  }

  void log2D6InTable((int,int,int) rolls) {
    int d0 = rolls.$1;
    int d1 = rolls.$2;
    logLine('>|${dieFace(d0)} ${dieFace(d1)}|${d0 + d1}|');
  }

  (int,int,int,int) roll3D6() {
    int value = _random.nextInt(216);
    int d0 = value ~/ 36;
    value -= d0 * 36;
    int d1 = value ~/ 6;
    value -= d1 * 6;
    int d2 = value;
    d0 += 1;
    d1 += 1;
    d2 += 1;
    return (d0, d1, d2, d0 + d1 + d2);
  }

  void log3D6((int,int,int,int) results) {
    int d0 = results.$1;
    int d1 = results.$2;
    int d2 = results.$3;
    logLine('>');
    logLine('>${dieFace(d0)} ${dieFace(d1)} ${dieFace(d2)}');
    logLine('>');
  }

  void lod3D6InTable((int,int,int,int) rolls) {
    int d0 = rolls.$1;
    int d1 = rolls.$2;
    int d2 = rolls.$3;
    logLine('>|${dieFace(d0)} ${dieFace(d1)} ${dieFace(d2)}|${d0 + d1 + d2}');
  }

  int randInt(int max) {
    return _random.nextInt(max);
  }

  Location? randLocation(List<Location> locations) {
    if (locations.isEmpty) {
      return null;
    }
    if (locations.length == 1) {
      return locations[0];
    }
    int choice = randInt(locations.length);
    return locations[choice];
  }

  // Player Actions

  void setPrompt(String value) {
    _choiceInfo.prompt = value;
  }

  void locationChoosable(Location location) {
    _choiceInfo.locations.add(location);
  }

  int get choosableLocationCount {
    return _choiceInfo.locations.length;
  }

  void pieceChoosable(Piece piece) {
    _choiceInfo.pieces.add(piece);
  }

  int get choosablePieceCount {
    return _choiceInfo.pieces.length;
  }

  void choiceChoosable(Choice choice, bool enabled) {
    _choiceInfo.choices.add(choice);
    if (!enabled) {
      _choiceInfo.disabledChoices.add(choice);
    }
  }

  int get choosableChoiceCount {
    return _choiceInfo.choices.length;
  }

  int get enabledChoiceCount {
    return _choiceInfo.choices.length - _choiceInfo.disabledChoices.length;
  }

  List<Location> selectedLocations() {
    return _choiceInfo.selectedLocations;
  }

  List<Piece> selectedPieces() {
    return _choiceInfo.selectedPieces;
  }

  Location? selectedLocation() {
    if (_choiceInfo.selectedLocations.length != 1) {
      return null;
    }
    return _choiceInfo.selectedLocations[0];
  }

  Piece? selectedPiece() {
    if (_choiceInfo.selectedPieces.length != 1) {
      return null;
    }
    return _choiceInfo.selectedPieces[0];
  }

  Piece? selectedPieceAndClear() {
    if (_choiceInfo.selectedPieces.length != 1) {
      return null;
    }
    Piece piece = _choiceInfo.selectedPieces[0];
    _choiceInfo.clear();
    return piece;
  }

  Location? selectedLocationAndClear() {
    if (_choiceInfo.selectedLocations.length != 1) {
      return null;
    }
    Location location = _choiceInfo.selectedLocations[0];
    _choiceInfo.clear();
    return location;
  }

  bool checkChoice(Choice choice) {
    return _choiceInfo.selectedChoices.contains(choice);
  }

  bool checkChoiceAndClear(Choice choice) {
    if (!_choiceInfo.selectedChoices.contains(choice)) {
      return false;
    }
    _choiceInfo.clear();
    return true;
  }

  void clearChoices() {
    _choiceInfo.clear();
  }

  void simulateChoice(Choice choice) {
    _choiceInfo.selectedChoices.add(choice);
  }

  bool choicesEmpty() {
    return _choiceInfo.selectedChoices.isEmpty && _choiceInfo.selectedLocations.isEmpty && _choiceInfo.selectedPieces.isEmpty;
  }

  // Logging

  void adjustExocetCount(int delta) {
    _state.adjustExocetCount(delta);
    if (delta > 0) {
      logLine('> Exocets: +$delta => ${_state.exocetCount}');
    } else if (delta < 0) {
      logLine('> Exocets: $delta => ${_state.exocetCount}');
    }
  }

  // High-Level Functions

  List<Location> get candidateHeliCamps {
    final heliPaths = _state.heliPaths;
    final candidates = <Location>[];
    for (final gbrGround in PieceType.groundGbr.pieces) {
      final location = _state.pieceLocation(gbrGround);
      if (!candidates.contains(location)) {
        if (location.isType(LocationType.camp)) {
          final path = _state.campPath(location);
          if (!heliPaths.contains(path)) {
            candidates.add(location);
          }
        }
      }
    }
    return candidates;
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
  }

  // Sequence Helpers

  // Sequence of Play

  void turnBegin() {
    logLine('# ${_state.turnName(_state.currentTurn)}');
  }

  void appreciateTheSituationPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Appreciate the Situation Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Appreciate the Situation Phase');
  }

  void appreciateTheSituationPhaseDetermineWeather() {
    const weatherTable = [
      [
        Location.weatherFog,
        Location.weatherFog,
        Location.weatherFair,
        Location.weatherFair,
        Location.weatherFair,
        Location.weatherRainSnow,
        Location.weatherRainSnow,
        Location.weatherSqualls,
        Location.weatherSqualls,
        Location.weatherGales,
        Location.weatherGales,
      ],
      [
        Location.weatherFog,
        Location.weatherFog,
        Location.weatherFog,
        Location.weatherFair,
        Location.weatherFair,
        Location.weatherRainSnow,
        Location.weatherRainSnow,
        Location.weatherSqualls,
        Location.weatherSqualls,
        Location.weatherGales,
        Location.weatherGales,
      ],
      [
        Location.weatherFog,
        Location.weatherFog,
        Location.weatherFog,
        Location.weatherFair,
        Location.weatherRainSnow,
        Location.weatherRainSnow,
        Location.weatherSqualls,
        Location.weatherSqualls,
        Location.weatherGales,
        Location.weatherGales,
        Location.weatherGales,
      ],
    ];
    logLine('### Weather');
    int tableIndex = _state.currentTurn ~/ 8;
    int dice = roll2D6().$3;
    int rowIndex = dice - 2;
    final weatherLocation = weatherTable[tableIndex][rowIndex];
    logLine('>Weather is ${weatherLocation.desc}.');
    if ([Location.weatherFog, Location.weatherSqualls].contains(weatherLocation)) {
      _state.setPieceLocation(Piece.markerWeatherNoAir, weatherLocation);
    } else {
      _state.setPieceLocation(Piece.markerWeather, weatherLocation);
    }
    if (weatherLocation == Location.weatherGales) {
      for (final piece in _state.piecesInLocation(PieceType.all, _state.turnBox(_state.currentTurn))) {
        if ([Piece.navalGbrStuft, Piece.groundGbrSAS].contains(piece)) {
          _state.setPieceLocation(piece, _state.turnBox(_state.currentTurn + 1));
        }
        if ([Piece.markerDiplomacy, Piece.markerPope].contains(piece)) {
          _state.setPieceLocation(piece, Location.offmap);
        }
      }
      _state.advanceTurn();
      _step = 0;
    }
  }

  void appreciateTheSituationPhaseConductSASRaid() {
    if (_subStep == 0) {
      final location = _state.pieceLocation(Piece.groundGbrSAS);
      if (location == _state.turnBox(_state.currentTurn)) {
        _state.setPieceLocation(Piece.groundGbrSAS, Location.falklandIslandsTotalExclusionZone);
      } else if (location != Location.falklandIslandsTotalExclusionZone && !location.isType(LocationType.camp)) {
        return;
      }
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select SAS Raid/Target, or Next to proceed');
        for (final pucara in PieceType.groundArgPucara.pieces) {
          if (_state.pieceLocation(pucara).isType(LocationType.airstrip)) {
            pieceChoosable(pucara);
          }
        }
        if (_state.limitedEventCount(LimitedEvent.operationMikado) == 0) {
          final location = _state.pieceLocation(Piece.markerExocet);
          if (location.isType(LocationType.turn)) {
            choiceChoosable(Choice.sasRaidOperationMikado, true);
          }
        }
        for (final groundUnit in PieceType.groundArgBack.pieces) {
          if (_state.pieceLocation(groundUnit).isType(LocationType.camp)) {
            pieceChoosable(groundUnit);
          }
        }
        for (final camp in LocationType.camp.locations) {
          if (_state.piecesInLocationCount(PieceType.groundGbr, camp) > 0) {
            locationChoosable(camp);
          }
        }
        choiceChoosable(Choice.sasRaidSpoofing, true);
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      int savingThrowDieCount = 1;
      if (checkChoiceAndClear(Choice.sasRaidOperationMikado)) {
        logLine('>Operation Mikado: SAS raid Argentina’s mainland stock of Exocets');
        int die = rollD6();
        logD6(die);
        if (die == 1) {
          logLine('>Mission is successful.');
          int lossDie = rollD6();
          adjustExocetCount(-lossDie);
        } else {
          logLine('>Mission is unsuccessful.');
        }
        _state.setLimitedEventOccurred(LimitedEvent.operationMikado);
        savingThrowDieCount = 2;
      } else if (checkChoiceAndClear(Choice.sasRaidSpoofing)) {
        logLine('>SAS raid attempts to misdirect the Argentine Air Force.');
        int die = rollD6();
        final seaZone = Location.values[LocationType.seaZone.firstIndex + die - 1];
        if (_state.piecesInLocationCount(PieceType.navalArgGrupo, seaZone) > 0) {
          logLine('>Argentine Air Force units in ${seaZone.desc} are diverted.');
          for (final grupo in _state.piecesInLocation(PieceType.navalArgGrupo, seaZone)) {
            _state.flipPiece(grupo);
          }
        } else {
          logLine('>Argentine Air Force units remain focused on British naval activity.');
        }
      } else {
        final piece = selectedPiece();
        final location = selectedLocation();
        if (piece != null) {
          if (piece.isType(PieceType.groundArgPucara)) {
            final airstrip = _state.pieceLocation(piece);
            logLine('>SAS raid ${airstrip.desc}.');
            final pucara = _state.pieceInLocation(PieceType.groundArgPucara, airstrip)!;
            int die = rollD6();
            logD6(die);
            if (die <= 4) {
              logLine('>Raid destroys ${pucara.desc}.');
              _state.setPieceLocation(pucara, Location.offmap);
            } else {
              logLine('>Raid fails, ${pucara.desc} is unscathed.');
            }
          } else {
            final camp = _state.pieceLocation(piece);
            logLine('>SAS recce in ${camp.desc}.');
            int die = rollD6();
            logD6(die);
            if (die <= 4) {
              final pieceFront = _state.pieceFlipSide(piece)!;
              logLine('>Recce detects ${pieceFront.desc} in ${camp.desc}.');
              _state.flipPiece(piece);
            } else {
              logLine('>Recce produces no results.');
            }
          }
        } else {
          logLine('>SAS is committed to combat role in ${location!.desc}.');
          _state.setPieceLocation(Piece.groundGbrSAS, location);
          savingThrowDieCount = 0;
        }
        clearChoices();
      }
      int dice = 0;
      if (savingThrowDieCount == 1) {
        logLine('>Saving Throw');
        dice = rollD6();
        logD6(dice);
      } else if (savingThrowDieCount == 2) {
        logLine('>Saving Throw');
        final rolls = roll2D6();
        log2D6(rolls);
        dice = rolls.$3;
      }
      if (savingThrowDieCount > 0) {
        final turnBox = _state.turnBox(_state.currentTurn + dice);
        if (turnBox.isType(LocationType.turn)) {
          logLine('>${Piece.groundGbrSAS.desc} is out of action until ${_state.turnName(turnBox.index - LocationType.turn.firstIndex)}.');
        } else {
          logLine('>${Piece.groundGbrSAS.desc} is out of action for the duration.');
        }
        _state.setPieceLocation(Piece.groundGbrSAS, turnBox);
      }
    }
  }

  void appreciateTheSituationPhaseStuft() {
    if (_state.pieceLocation(Piece.navalGbrStuft) != _state.turnBox(_state.currentTurn)) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Ships Taken Up From Trade');
      logTableHeader();
      int die = rollD6();
      logD6InTable(die);
      int modifiers = 0;
      if (_state.exocetCount >= 2) {
        logLine('>|Exocet missile|+2|');
        modifiers += 2;
      }
      int total = die + modifiers;
      logLine('>Total|$total|');
      int heliCount = 0;
      switch (total) {
      case 1:
      case 2:
      case 3:
        heliCount = 3;
        logLine('>No damage at all');
      case 4:
        heliCount = 2;
        logLine('>Significant hit');
      case 5:
        heliCount = 1;
        logLine('>Disastrous hit');
      case 6:
      case 7:
      case 8:
        heliCount = 0;
        logLine('>Catastrophic hit');
      }
      if (_state.exocetCount >= 2) {
        adjustExocetCount(-1);
      }
      _state.setPieceLocation(Piece.navalGbrStuft, Location.offmap);
      if (heliCount == 0) {
        return;
      }
      for (int i = 0; i < heliCount; ++i) {
        _state.setPieceLocation(Piece.values[PieceType.groundGbrHeli.firstIndex + i], _state.turnBox(_state.currentTurn));
      }
      _subStep = 1;
    }
    while (_subStep == 1) {
      final helis = _state.piecesInLocation(PieceType.groundGbrHeli, _state.turnBox(_state.currentTurn));
      if (helis.isEmpty) {
        return;
      }
      if (choicesEmpty()) {
        setPrompt('Select Camp for Helicopter');
        for (final camp in candidateHeliCamps) {
          locationChoosable(camp);
        }
        throw PlayerChoiceException();
      }
      final camp = selectedLocation()!;
      _state.setPieceLocation(helis[0], camp);
    }
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      appreciateTheSituationPhaseBegin,
      appreciateTheSituationPhaseDetermineWeather,
      appreciateTheSituationPhaseConductSASRaid,
      appreciateTheSituationPhaseStuft,
    ];

    while (true) {
      stepHandlers[_step]();
      clearChoices();
      _step += 1;
      if (_step == stepHandlers.length) {
        _step = 0;
      }
      _subStep = 0;
    }
  }

  Future<PlayerChoiceInfo?> play(PlayerChoice choice) async {
    if (_outcome != null) {
        return null;
    }
    _choiceInfo.update(choice);
    try {
      playInSequence();
      return null;
    }
    on PlayerChoiceException catch (e) {
      if (e.saveSnapshot) {
        await saveSnapshot();
      }
      await saveCurrentState();
      return _choiceInfo;
    }
    on GameOverException catch (e) {
      gameOver(e.outcome);
      await saveSnapshot();
      await saveCompletedGame(e.outcome);
      return null;
    }
  }
}

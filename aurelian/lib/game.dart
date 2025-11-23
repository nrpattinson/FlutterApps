import 'dart:convert';
import 'dart:math';
import 'package:aurelian/db.dart';
import 'package:aurelian/random.dart';

enum Location {
  germania,
  noricum,
  ravenna,
  roma,
  aquitania,
  belgica,
  britannia,
  gallia,
  byzantium,
  dalmatia,
  moesia,
  pannonia,
  aegyptus,
  antiochia,
  judaea,
  nicomedia,
  palmyra,
  tyana,
  front1,
  front2,
  front3,
  front4,
  front5,
  front6,
  front7,
  front8,
  aurelianWallsN2,
  aurelianWallsN1,
  aurelianWallsZ,
  aurelianWallsP1,
  aurelianWallsP2,
  aurelianWallsP3,
  aurelianWallsP4,
  barbarianPoolBlue,
  barbarianPoolRed,
  barbarianPoolGreen,
  usurperRed,
  usurperBlue,
  usurperGreen,
  usurperYellow,
  wallsRed,
  wallsBlue,
  wallsGreen,
  wallsYellow,
  templeRed,
  templeBlue,
  templeGreen,
  templeYellow,
  poolDead,
  boxArmyStrength0,
  boxArmyStrength1,
  boxArmyStrength2,
  boxArmyStrength3,
  boxArmyStrength4,
  boxArmyStrength5,
  boxIncome0,
  boxIncome1,
  boxIncome2,
  boxIncome3,
  boxIncome4,
  boxIncome5,
  boxIncome6,
  boxIncome7,
  boxIncome8,
  boxIncome9,
  boxIncome10,
  boxIncome11,
  boxIncome12,
  boxIncome13,
  boxIncome14,
  boxIncome15,
  boxIncome16,
  boxIncome17,
  boxIncome18,
  boxIncome19,
  boxIncome20,
  boxIncome21,
  boxIncome22,
  boxIncome23,
  boxIncome24,
  boxIncome25,
  boxIncome26,
  boxIncome27,
  boxIncome28,
  boxIncome29,
  boxIncome30,
  boxIncome31,
  boxIncome32,
  boxIncome33,
  boxIncome34,
  boxIncome35,
  boxIncome36,
  boxIncome37,
  boxIncome38,
  boxIncome39,
  boxIncome40,
  boxIncome41,
  boxIncome42,
  boxIncome43,
  boxIncome44,
  boxIncome45,
  boxIncome46,
  boxIncome47,
  boxIncome48,
  boxIncome49,
  boxVictory0,
  boxVictory1,
  boxVictory2,
  boxVictory3,
  boxVictory4,
  boxVictory5,
  boxVictory6,
  boxVictory7,
  boxVictory8,
  boxVictory9,
  boxVictory00,
  boxVictory10,
  boxVictory20,
  boxVictory30,
  boxVictory40,
  boxVictory50,
  boxVictory60,
  boxVictory70,
  boxVictory80,
  boxVictory90,
  boxTurn1,
  boxTurn2,
  boxTurn3,
  boxTurn4,
  boxTurn5,
  boxTurn6,
  cupFriendly,
  cupUnfriendly,
  cupHostile,
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
  space,
  redSpace,
  blueSpace,
  greenSpace,
  yellowSpace,
  usurperBox,
  armyStrength,
  income,
  victory0,
  victory10,
  turn,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.space: [Location.germania, Location.tyana],
    LocationType.redSpace: [Location.germania, Location.roma],
    LocationType.blueSpace: [Location.aquitania, Location.gallia],
    LocationType.greenSpace: [Location.byzantium, Location.pannonia],
    LocationType.yellowSpace: [Location.aegyptus, Location.tyana],
    LocationType.usurperBox: [Location.usurperRed, Location.usurperYellow],
    LocationType.armyStrength: [Location.boxArmyStrength0, Location.boxArmyStrength5],
    LocationType.income: [Location.boxIncome0, Location.boxIncome49],
    LocationType.victory0: [Location.boxVictory0, Location.boxVictory9],
    LocationType.victory10: [Location.boxVictory00, Location.boxVictory90],
    LocationType.turn: [Location.boxTurn1, Location.boxTurn6],
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
      Location.germania: 'Germania',
      Location.noricum: 'Noricum',
      Location.ravenna: 'Ravenna',
      Location.roma: 'Roma',
      Location.aquitania: 'Aquitania',
      Location.belgica: 'Belgica',
      Location.britannia: 'Britannia',
      Location.gallia: 'Gallia',
      Location.byzantium: 'Byzantium',
      Location.dalmatia: 'Dalmatia',
      Location.moesia: 'Moesia',
      Location.pannonia: 'Pannonia',
      Location.aegyptus: 'Aegyptus',
      Location.antiochia: 'Antiochia',
      Location.judaea: 'Judaea',
      Location.nicomedia: 'Nicomedia',
      Location.palmyra: 'Palmyra',
      Location.tyana: 'Tyana',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Region {
  red,
  blue,
  green,
  yellow,
}

enum Piece {
  germania0,
  germania1,
  noricum0,
  noricum1,
  ravenna0,
  ravenna1,
  roma0,
  roma1,
  roma2,
  aquitania0,
  aquitania1,
  belgica0,
  belgica1,
  belgica2,
  britannia0,
  britannia1,
  britannia2,
  gallia0,
  gallia1,
  byzantium0,
  byzantium1,
  byzantium2,
  dalmatia0,
  dalmatia1,
  moesia0,
  moesia1,
  pannonia0,
  pannonia1,
  aegyptus0,
  aegyptus1,
  antiochia0,
  antiochia1,
  judaea0,
  judaea1,
  judaea2,
  nicomedia0,
  nicomedia1,
  palmyra0,
  palmyra1,
  palmyra2,
  tyana0,
  tyana1,
  red0,
  red1,
  red2,
  red3,
  red4,
  red5,
  red6,
  red7,
  red8,
  blue0,
  blue1,
  blue2,
  blue3,
  blue4,
  blue5,
  blue6,
  blue7,
  blue8,
  blue9,
  green0,
  green1,
  green2,
  green3,
  green4,
  green5,
  green6,
  green7,
  green8,
  yellow0,
  yellow1,
  yellow2,
  yellow3,
  yellow4,
  yellow5,
  yellow6,
  yellow7,
  yellow8,
  yellow9,
  yellow10,
  yellow11,
  yellow12,
  yellow13,
  barbarian0,
  barbarian1,
  barbarian2,
  barbarian3,
  barbarian4,
  barbarian5,
  barbarian6,
  barbarian7,
  barbarian8,
  usurperRed,
  usurperBlue,
  usurperBluePostumus,
  usurperGreen,
  usurperYellow,
  usurperYellowZenobia,
  barbarianConfederation,
  sassanid,
  legion0,
  legion1,
  legion2,
  legion3,
  legion4,
  legion5,
  legion6,
  legion7,
  legion8,
  legion9,
  legion10,
  legion11,
  legion12,
  legion13,
  legion14,
  legion15,
  leaderAurelianP1,
  leaderAurelianP2,
  leaderOfficer0,
  leaderOfficer1,
  walls0,
  walls1,
  walls2,
  walls3,
  walls4,
  walls5,
  templeStart0,
  templeStart1,
  templeStart2,
  templeStart3,
  templeFinished0,
  templeFinished1,
  templeFinished2,
  templeFinished3,
  turnEnd0,
  turnEnd1,
  turnEnd2,
  markerGameTurn,
  markerIncome,
  markerTreasury,
  markerArmyStrength,
  markerVictoryPoints1,
  markerVictoryPoints10,
  markerAurelianWalls,
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
  mapEnemyUnit,
  mapResistance,
  mapResistanceRed,
  mapResistanceBlue,
  mapResistanceGreen,
  mapResistanceYellow,
  mapBarbarian,
  mapCV,
  mapUsurper,
  mapLeader,
  mapAurelian,
  mapOfficer,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.germania0, Piece.markerAurelianWalls],
    PieceType.mapEnemyUnit: [Piece.germania0, Piece.yellow13],
    PieceType.mapResistance: [Piece.germania0, Piece.tyana1],
    PieceType.mapResistanceRed: [Piece.germania0, Piece.roma2],
    PieceType.mapResistanceBlue: [Piece.aquitania0, Piece.gallia1],
    PieceType.mapResistanceGreen: [Piece.byzantium0, Piece.pannonia0],
    PieceType.mapResistanceYellow: [Piece.aegyptus0, Piece.tyana1],
    PieceType.mapCV: [Piece.red0, Piece.barbarian8],
    PieceType.mapBarbarian: [Piece.barbarian0, Piece.barbarian8],
    PieceType.mapUsurper: [Piece.usurperRed, Piece.usurperYellowZenobia],
    PieceType.mapLeader: [Piece.leaderAurelianP1, Piece.leaderOfficer1],
    PieceType.mapAurelian: [Piece.leaderAurelianP1, Piece.leaderAurelianP2],
    PieceType.mapOfficer: [Piece.leaderOfficer0, Piece.leaderOfficer1],
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
    const pieceDescs = {
    };
    return pieceDescs[this]!;
  }

  bool isType(PieceType pieceType) {
    return index >= pieceType.firstIndex && index < pieceType.lastIndex;
  }
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
      Scenario.standard: 'Standard (6 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<int> _resistanceStackDepths = List<int>.filled(PieceType.mapResistance.count, -1);

  GameState();

  GameState.fromJson(Map<String, dynamic> json) :
   _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations'])),
   _resistanceStackDepths = List<int>.from(json['resistanceStackDepths']);

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'resistanceStackDepths': _resistanceStackDepths,
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.germania0: Piece.red0,
      Piece.germania1: Piece.red1,
      Piece.noricum0: Piece.red2,
      Piece.noricum1: Piece.red3,
      Piece.ravenna0: Piece.red4,
      Piece.ravenna1: Piece.red5,
      Piece.roma0: Piece.red6,
      Piece.roma1: Piece.red7,
      Piece.roma2: Piece.red8,
      Piece.aquitania0: Piece.blue0,
      Piece.aquitania1: Piece.blue1,
      Piece.belgica0: Piece.blue2,
      Piece.belgica1: Piece.blue3,
      Piece.belgica2: Piece.blue4,
      Piece.britannia0: Piece.blue5,
      Piece.britannia1: Piece.blue6,
      Piece.britannia2: Piece.blue7,
      Piece.gallia0: Piece.blue8,
      Piece.gallia1: Piece.blue9,
      Piece.byzantium0: Piece.green0,
      Piece.byzantium1: Piece.green1,
      Piece.byzantium2: Piece.green2,
      Piece.dalmatia0: Piece.green3,
      Piece.dalmatia1: Piece.green4,
      Piece.moesia0: Piece.green5,
      Piece.moesia1: Piece.green6,
      Piece.pannonia0: Piece.green7,
      Piece.pannonia1: Piece.green8,
      Piece.aegyptus0: Piece.yellow0,
      Piece.aegyptus1: Piece.yellow1,
      Piece.antiochia0: Piece.yellow2,
      Piece.antiochia1: Piece.yellow3,
      Piece.judaea0: Piece.yellow4,
      Piece.judaea1: Piece.yellow5,
      Piece.judaea2: Piece.yellow6,
      Piece.nicomedia0: Piece.yellow7,
      Piece.nicomedia1: Piece.yellow8,
      Piece.palmyra0: Piece.yellow9,
      Piece.palmyra1: Piece.yellow10,
      Piece.palmyra2: Piece.yellow11,
      Piece.tyana0: Piece.yellow12,
      Piece.tyana1: Piece.yellow13,
      Piece.red0: Piece.germania0,
      Piece.red1: Piece.germania1,
      Piece.red2: Piece.noricum0,
      Piece.red3: Piece.noricum1,
      Piece.red4: Piece.ravenna0,
      Piece.red5: Piece.ravenna1,
      Piece.red6: Piece.roma0,
      Piece.red7: Piece.roma1,
      Piece.red8: Piece.roma2,
      Piece.blue0: Piece.aquitania0,
      Piece.blue1: Piece.aquitania1,
      Piece.blue2: Piece.belgica0,
      Piece.blue3: Piece.belgica1,
      Piece.blue4: Piece.belgica2,
      Piece.blue5: Piece.britannia0,
      Piece.blue6: Piece.britannia1,
      Piece.blue7: Piece.britannia2,
      Piece.blue8: Piece.gallia0,
      Piece.blue9: Piece.gallia1,
      Piece.green0: Piece.byzantium0,
      Piece.green1: Piece.byzantium1,
      Piece.green2: Piece.byzantium2,
      Piece.green3: Piece.dalmatia0,
      Piece.green4: Piece.dalmatia1,
      Piece.green5: Piece.moesia0,
      Piece.green6: Piece.moesia1,
      Piece.green7: Piece.pannonia0,
      Piece.green8: Piece.pannonia1,
      Piece.yellow0: Piece.aegyptus0,
      Piece.yellow1: Piece.aegyptus1,
      Piece.yellow2: Piece.antiochia0,
      Piece.yellow3: Piece.antiochia1,
      Piece.yellow4: Piece.judaea0,
      Piece.yellow5: Piece.judaea1,
      Piece.yellow6: Piece.judaea2,
      Piece.yellow7: Piece.nicomedia0,
      Piece.yellow8: Piece.nicomedia1,
      Piece.yellow9: Piece.palmyra0,
      Piece.yellow10: Piece.palmyra1,
      Piece.yellow11: Piece.palmyra2,
      Piece.yellow12: Piece.tyana0,
      Piece.yellow13: Piece.tyana1,
      Piece.legion0: Piece.legion8,
      Piece.legion1: Piece.legion9,
      Piece.legion2: Piece.legion10,
      Piece.legion3: Piece.legion11,
      Piece.legion4: Piece.legion12,
      Piece.legion5: Piece.legion13,
      Piece.legion6: Piece.legion14,
      Piece.legion7: Piece.legion15,
      Piece.legion8: Piece.legion0,
      Piece.legion9: Piece.legion1,
      Piece.legion10: Piece.legion2,
      Piece.legion11: Piece.legion3,
      Piece.legion12: Piece.legion4,
      Piece.legion13: Piece.legion5,
      Piece.legion14: Piece.legion6,
      Piece.legion15: Piece.legion7,
      Piece.leaderAurelianP1: Piece.leaderAurelianP2,
      Piece.leaderAurelianP2: Piece.leaderAurelianP1,
      Piece.walls0: Piece.walls3,
      Piece.walls1: Piece.walls4,
      Piece.walls2: Piece.walls5,
      Piece.walls3: Piece.walls0,
      Piece.walls4: Piece.walls1,
      Piece.walls5: Piece.walls2,
      Piece.templeStart0: Piece.templeFinished0,
      Piece.templeStart1: Piece.templeFinished1,
      Piece.templeStart2: Piece.templeFinished2,
      Piece.templeStart3: Piece.templeFinished3,
      Piece.templeFinished0: Piece.templeStart0,
      Piece.templeFinished1: Piece.templeStart1,
      Piece.templeFinished2: Piece.templeStart2,
      Piece.templeFinished3: Piece.templeStart3,
    };
    return pieceFlipSides[piece];
  }

  Location pieceLocation(Piece piece) {
    return _pieceLocations[piece.index];
  }

  int resistanceStackDepth(Piece resistance) {
    return _resistanceStackDepths[resistance.index - PieceType.mapResistance.firstIndex];
  }

  void redoStackDepths(Location location) {
    final resistanceStackDepths = <(Piece, int)>[];
    Piece? newResistance;
    for (final resistance in piecesInLocation(PieceType.mapResistance, location)) {
      int depth = _resistanceStackDepths[resistance.index - PieceType.mapResistance.firstIndex];
      if (depth == -1) {
        newResistance = resistance;
      } else {
        resistanceStackDepths.add((resistance, depth));
      }
    }
    resistanceStackDepths.sort((a, b) => a.$2.compareTo(b.$2));
    int depth = 0;
    for (depth = 0; depth < resistanceStackDepths.length; ++depth) {
      _resistanceStackDepths[resistanceStackDepths[depth].$1.index - PieceType.mapResistance.firstIndex] = depth;
    }
    if (newResistance != null) {
      _resistanceStackDepths[newResistance.index - PieceType.mapResistance.firstIndex] = depth;
      depth += 1;
    }
  }

  void setPieceLocation(Piece piece, Location location) {
    final oldLocation = _pieceLocations[piece.index];
    _pieceLocations[piece.index] = location;
    if (piece.isType(PieceType.mapResistance)) {
      _resistanceStackDepths[piece.index - PieceType.mapResistance.firstIndex] = -1;
    }
    final obverse = pieceFlipSide(piece);
    if (obverse != null) {
      final oldFlippedLocation = _pieceLocations[obverse.index];
      _pieceLocations[obverse.index] = Location.flipped;
      if (obverse.isType(PieceType.mapResistance)) {
        _resistanceStackDepths[obverse.index - PieceType.mapResistance.firstIndex] = -1;
        if (oldFlippedLocation.isType(LocationType.space)) {
          redoStackDepths(oldFlippedLocation);
        }
      }
    }
    if (piece.isType(PieceType.mapResistance)) {
      if (oldLocation.isType(LocationType.space)) {
        redoStackDepths(oldLocation);
      }
      if (location.isType(LocationType.space)) {
        redoStackDepths(location);
      }
    }
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

  // Spaces

  List<Location> spaceAdjacentSpaces(Location space) {
    const adjacentSpaces = {
      Location.germania: [Location.noricum, Location.ravenna, Location.gallia],
      Location.noricum: [Location.dalmatia, Location.pannonia],
      Location.ravenna: [Location.germania, Location.roma],
      Location.roma: [Location.ravenna],
      Location.aquitania: [Location.belgica, Location.gallia],
      Location.belgica: [Location.aquitania, Location.britannia, Location.gallia],
      Location.britannia: [Location.belgica],
      Location.gallia: [Location.germania, Location.aquitania, Location.belgica],
      Location.byzantium: [Location.moesia, Location.nicomedia],
      Location.dalmatia: [Location.moesia, Location.pannonia],
      Location.moesia: [Location.byzantium, Location.dalmatia],
      Location.pannonia: [Location.noricum, Location.dalmatia],
      Location.aegyptus: [Location.judaea],
      Location.antiochia: [Location.judaea, Location.palmyra, Location.tyana],
      Location.judaea: [Location.aegyptus, Location.antiochia],
      Location.nicomedia: [Location.byzantium, Location.tyana],
      Location.palmyra: [Location.antiochia],
      Location.tyana: [Location.antiochia, Location.nicomedia],
    };
    return adjacentSpaces[space]!;
  }

  List<Location> spaceAndAdjacentSpaces(Location space) {
    final spaces = spaceAdjacentSpaces(space);
    spaces.add(space);
    return spaces;
  }

  Region spaceRegion(Location space) {
    for (final region in Region.values) {
      final locationType = regionLocationType(region);
      if (space.isType(locationType)) {
        return region;
      }
    }
    return Region.blue;
  }

  // Regions

  LocationType regionLocationType(Region region) {
    const regionLocationTypes = {
      Region.red: LocationType.redSpace,
      Region.blue: LocationType.blueSpace,
      Region.green: LocationType.greenSpace,
      Region.yellow: LocationType.yellowSpace,
    };
    return regionLocationTypes[region]!;
  }

  bool regionOnDanube(Region region) {
    const danubeRegions = [Region.red, Region.blue, Region.green];
    return danubeRegions.contains(region);
  }

  Location? regionBarbarianPool(Region region) {
    const barbarianPools = {
      Region.red: Location.barbarianPoolRed,
      Region.blue: Location.barbarianPoolBlue,
      Region.green: Location.barbarianPoolGreen,
    };
    return barbarianPools[region];
  }

  Location regionUsurperBox(Region region) {
    return Location.values[LocationType.usurperBox.firstIndex + region.index];
  }

  Piece? regionUsurper(Region region) {
    return pieceInLocation(PieceType.mapUsurper, regionUsurperBox(region));
  }

  // Resistance

  Location resistanceHome(Piece resistance) {
    const resistanceHomes = {
      Piece.germania0: Location.germania,
      Piece.germania1: Location.germania,
      Piece.noricum0: Location.noricum,
      Piece.noricum1: Location.noricum,
      Piece.ravenna0: Location.ravenna,
      Piece.ravenna1: Location.ravenna,
      Piece.roma0: Location.roma,
      Piece.roma1: Location.roma,
      Piece.roma2: Location.roma,
      Piece.aquitania0: Location.aquitania,
      Piece.aquitania1: Location.aquitania,
      Piece.belgica0: Location.belgica,
      Piece.belgica1: Location.belgica,
      Piece.belgica2: Location.belgica,
      Piece.britannia0: Location.britannia,
      Piece.britannia1: Location.britannia,
      Piece.britannia2: Location.britannia,
      Piece.gallia0: Location.gallia,
      Piece.gallia1: Location.gallia,
      Piece.byzantium0: Location.byzantium,
      Piece.byzantium1: Location.byzantium,
      Piece.byzantium2: Location.byzantium,
      Piece.dalmatia0: Location.dalmatia,
      Piece.dalmatia1: Location.dalmatia,
      Piece.moesia0: Location.moesia,
      Piece.moesia1: Location.moesia,
      Piece.pannonia0: Location.pannonia,
      Piece.pannonia1: Location.pannonia,
      Piece.aegyptus0: Location.aegyptus,
      Piece.aegyptus1: Location.aegyptus,
      Piece.antiochia0: Location.antiochia,
      Piece.antiochia1: Location.antiochia,
      Piece.judaea0: Location.judaea,
      Piece.judaea1: Location.judaea,
      Piece.judaea2: Location.judaea,
      Piece.nicomedia0: Location.nicomedia,
      Piece.nicomedia1: Location.nicomedia,
      Piece.palmyra0: Location.palmyra,
      Piece.palmyra1: Location.palmyra,
      Piece.palmyra2: Location.palmyra,
      Piece.tyana0: Location.tyana,
      Piece.tyana1: Location.tyana,
    };
    return resistanceHomes[resistance]!;
  }

  int resistanceRating(Piece resistance) {
    const resistanceRatings = {
      Piece.germania0: 2,
      Piece.germania1: 3,
      Piece.noricum0: 2,
      Piece.noricum1: 3,
      Piece.ravenna0: 2,
      Piece.ravenna1: 3,
      Piece.roma0: 2,
      Piece.roma1: 2,
      Piece.roma2: 3,
      Piece.aquitania0: 2,
      Piece.aquitania1: 3,
      Piece.belgica0: 4,
      Piece.belgica1: 4,
      Piece.belgica2: 5,
      Piece.britannia0: 4,
      Piece.britannia1: 4,
      Piece.britannia2: 5,
      Piece.gallia0: 3,
      Piece.gallia1: 4,
      Piece.byzantium0: 4,
      Piece.byzantium1: 4,
      Piece.byzantium2: 5,
      Piece.dalmatia0: 3,
      Piece.dalmatia1: 4,
      Piece.moesia0: 3,
      Piece.moesia1: 4,
      Piece.pannonia0: 3,
      Piece.pannonia1: 4,
      Piece.aegyptus0: 3,
      Piece.aegyptus1: 4,
      Piece.antiochia0: 4,
      Piece.antiochia1: 5,
      Piece.judaea0: 5,
      Piece.judaea1: 5,
      Piece.judaea2: 6,
      Piece.nicomedia0: 3,
      Piece.nicomedia1: 4,
      Piece.palmyra0: 5,
      Piece.palmyra1: 5,
      Piece.palmyra2: 6,
      Piece.tyana0: 3,
      Piece.tyana1: 4,
    };
    return resistanceRatings[resistance]!;
  }

  Piece? spaceTopmostResistancePiece(Location space) {
    int depth = -1;
    Piece? resistance;

    for (final piece in piecesInLocation(PieceType.mapResistance, space)) {
      int stackDepth = resistanceStackDepth(piece);
      if (stackDepth > depth) {
        resistance = piece;
      }
    }
    return resistance;
  }

  int? spaceTopmostResistanceRating(Location space) {
    int depth = -1;
    int? rating;
    for (final resistance in piecesInLocation(PieceType.mapResistance, space)) {
      int stackDepth = resistanceStackDepth(resistance);
      if (stackDepth > depth) {
        rating = resistanceRating(resistance);
      }
    }
    return rating;
  }

  int spacePlacateCost(Location space) {
    final resistance = spaceTopmostResistanceRating(space);
    if (resistance == null) {
      return 0;
    }
    return (resistance + 1) ~/ 2;
  }

  // Treasury

  int get treasury {
    return pieceLocation(Piece.markerTreasury).index - LocationType.income.firstIndex;
  }

  // Turns

  int get currentTurn {
    return pieceLocation(Piece.markerGameTurn).index - LocationType.turn.firstIndex;
  }

  String turnName(int turn) {
    return '${turn + 1}';
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

    state.setupPieceType(PieceType.mapResistanceYellow, Location.cupHostile);
    final yellowResistances = PieceType.mapResistanceYellow.pieces;
    yellowResistances.shuffle(random);
    for (int i = 0; i < 6; ++i) {
      final resistance = yellowResistances[i];
      final cv = state.pieceFlipSide(resistance)!;
      final home = state.resistanceHome(resistance);
      state.setPieceLocation(cv, home);
    }

    state.setupPieceType(PieceType.mapResistanceBlue, Location.cupUnfriendly);
    final blueResistances = PieceType.mapResistanceBlue.pieces;
    blueResistances.shuffle(random);
    for (int i = 0; i < 6; ++i) {
      final resistance = blueResistances[i];
      final cv = state.pieceFlipSide(resistance)!;
      final home = state.resistanceHome(resistance);
      state.setPieceLocation(cv, home);
    }

    state.setupPieceType(PieceType.mapResistanceGreen, Location.cupUnfriendly);

    final barbarians = PieceType.mapBarbarian.pieces;
    barbarians.shuffle(random);
    for (int i = 0; i < barbarians.length; ++i) {
      if (i < 2) {
        state.setPieceLocation(barbarians[i], Location.barbarianPoolGreen);
      } else if (i < 3) {
        state.setPieceLocation(barbarians[i], Location.barbarianPoolRed);
      } else {
        state.setPieceLocation(barbarians[i], Location.cupHostile);
      }
    }

    state.setupPieceType(PieceType.mapResistanceRed, Location.cupFriendly);
    final redResistances = PieceType.mapResistanceRed.pieces;
    redResistances.shuffle(random);
    for (int i = 0; i < 4; ++i) {
      final resistance = redResistances[i];
      final home = state.resistanceHome(resistance);
      state.setPieceLocation(resistance, home);
    }

    state.setupPieceTypes([
      (PieceType.mapOfficer, Location.offmap),
    ]);


    state.setupPieces([
      (Piece.usurperBluePostumus, Location.usurperBlue),
      (Piece.usurperYellowZenobia, Location.usurperYellow),
      (Piece.barbarianConfederation, Location.cupFriendly),
      (Piece.sassanid, Location.cupFriendly),
      (Piece.turnEnd0, Location.cupHostile),
      (Piece.turnEnd1, Location.cupHostile),
      (Piece.legion0, Location.front3),
      (Piece.legion1, Location.front4),
      (Piece.legion2, Location.front5),
      (Piece.legion3, Location.front6),
      (Piece.legion4, Location.front7),
      (Piece.legion5, Location.front8),
      (Piece.leaderAurelianP1, Location.moesia),
      (Piece.markerArmyStrength, Location.boxArmyStrength2),
      (Piece.markerGameTurn, Location.boxTurn1),
      (Piece.turnEnd2, Location.boxTurn4),
      (Piece.markerIncome, Location.boxIncome13),
      (Piece.markerTreasury, Location.boxIncome5),
      (Piece.markerAurelianWalls, Location.aurelianWallsN2),
      (Piece.markerVictoryPoints1, Location.boxVictory0),
      (Piece.markerVictoryPoints10, Location.boxVictory00),
    ]);

    return state;
  }
}

enum Choice {
  actionSuppress,
  actionPlacate,
  actionAssign,
  actionRedeploy,
  actionCampaign,
  actionBattle,
  actionSiege,
  actionMarch,
  loseVP,
  loseCoin,
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

enum Phase {
  actions,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateActions extends PhaseState {
  Piece? leader;

  PhaseStateActions();

  PhaseStateActions.fromJson(Map<String, dynamic> json)
    : leader = pieceFromIndex(json['leader'] as int?)
    ;
  
  @override
  Map<String, dynamic> toJson() => {
    'leader': pieceToIndex(leader),
  };

  @override
  Phase get phase {
    return Phase.actions;
  }
}

class ReactionState {
  int subStep = 0;

  ReactionState();

  ReactionState.fromJson(Map<String, dynamic> json)
    : subStep = json['subStep'] as int
    ;
  
  Map<String, dynamic> toJson() => {
    'subStep': subStep,
  };
}

class Game {
  final Scenario _scenario;
  final GameState _state;
  int _step = 0;
  int _subStep = 0;
  GameOutcome? _outcome;
  final GameOptions _options;
  String _log = '';
  PhaseState? _phaseState;
  ReactionState? _reactionState;
  PlayerChoiceInfo _choiceInfo = PlayerChoiceInfo();
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
    _phaseState = null;
    final phaseIndex = json['phase'] as int?;
    if (phaseIndex != null) {
      final phaseStateJson = json['phaseState'];
      switch (Phase.values[phaseIndex]) {
      case Phase.actions:
        _phaseState = PhaseStateActions.fromJson(phaseStateJson);
      }
    }

    final reactionStateJson = json['reaction'];
    if (reactionStateJson != null) {
      _reactionState = ReactionState.fromJson(reactionStateJson);
    }

    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
    if (_phaseState != null) {
      map['phase'] = _phaseState!.phase.index;
      map['phaseState'] = _phaseState!.toJson();
    }
    if (_reactionState != null) {
      map['reaction'] = _reactionState!.toJson();
    }
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
    _log += '$line  \n';
  }

  // Randomness

  int rollD8() {
    int die = _random.nextInt(8) + 1;
    logLine('> Roll: $die');
    return die;
  }

  int randInt(int max) {
    return _random.nextInt(max);
  }

  Piece? randPiece(List<Piece> pieces) {
    if (pieces.isEmpty) {
      return null;
    }
    if (pieces.length == 1) {
      return pieces[0];
    }
    int choice = randInt(pieces.length);
    return pieces[choice];
  }

  Piece? drawFromCup(Location cup) {
    return randPiece(_state.piecesInLocation(PieceType.all, cup));
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

  // High-Level Functions

  bool spaceIsSuppressCandidate(Location space) {
    if (_state.piecesInLocationCount(PieceType.mapResistance, space) == 0) {
      return false;
    }
    if (_state.piecesInLocationCount(PieceType.mapCV, space) > 0) {
      return false;
    }
    return true;
  }

  bool spaceIsPlacateCandidate(Location space) {
    if (_state.piecesInLocationCount(PieceType.mapResistance, space) == 0) {
      return false;
    }
    if (_state.piecesInLocationCount(PieceType.mapCV, space) > 0) {
      return false;
    }
    return true;
  }

  bool spaceIsAssignCandidate(Location space) {
    if (_state.piecesInLocationCount(PieceType.mapEnemyUnit, space) > 0) {
      return false;
    }
    final region = _state.spaceRegion(space);
    if (_state.regionUsurper(region) != null) {
      return false;
    }
    return true;
  }

  bool spaceIsRedeployCandidate(Location space) {
    if (_state.piecesInLocationCount(PieceType.mapEnemyUnit, space) > 0) {
      return false;
    }
    final region = _state.spaceRegion(space);
    if (!_state.regionOnDanube(region)) {
      return false;
    }
    if (_state.regionUsurper(region) != null) {
      return false;
    }
    return true;
  }

  bool spaceIsCampaignCandidate(Location space) {
    if (_state.piecesInLocationCount(PieceType.mapEnemyUnit, space) > 0) {
      return false;
    }
    final region = _state.spaceRegion(space);
    if (_state.regionUsurper(region) != null) {
      return false;
    }
    final barbarianPool = _state.regionBarbarianPool(region);
    if (barbarianPool == null) {
      return false;
    }
    if (_state.piecesInLocationCount(PieceType.mapBarbarian, barbarianPool) == 0) {
      return false;
    }
    return true;
  }

  bool spaceIsBattleCandidate(Location space) {
    if (_state.piecesInLocationCount(PieceType.mapCV, space) == 0) {
      return false;
    }
    return true;
  }

  bool spaceIsSiegeCandidate(Location space) {
    if (_state.piecesInLocationCount(PieceType.mapCV, space) == 0) {
      return false;
    }
    return true;
  }

  bool spaceIsMarchCandidate(Location space) {
    if (_state.piecesInLocationCount(PieceType.mapEnemyUnit, space) > 0) {
      return false;
    }
    return true;
  }

  List<Piece> get candidateLeaders {
    final candidates = <Piece>[];
    for (final leader in PieceType.mapLeader.pieces) {
      final location = _state.pieceLocation(leader);
      if (location.isType(LocationType.space)) {
        candidates.add(leader);
      }
    }
    return candidates;
  }

  Piece? get candidateAurelian {
    for (final aurelian in PieceType.mapAurelian.pieces) {
      final location = _state.pieceLocation(aurelian);
      if (location.isType(LocationType.space)) {
        return aurelian;
      }
    }
    return null;
  }

  List<Location> candidateLeaderSuppressSpaces(Piece leader) {
    final candidates = <Location>[];
    final leaderLocation = _state.pieceLocation(leader);
    for (final space in _state.spaceAndAdjacentSpaces(leaderLocation)) {
      if (spaceIsSuppressCandidate(space)) {
        candidates.add(space);
      }
    }
    return candidates;
  }

  List<Location> candidateLeaderPlacateSpaces(Piece leader) {
    final candidates = <Location>[];
    final leaderLocation = _state.pieceLocation(leader);
    for (final space in _state.spaceAndAdjacentSpaces(leaderLocation)) {
      if (spaceIsPlacateCandidate(space) && _state.treasury >= _state.spacePlacateCost(space)) {
        candidates.add(space);
      }
    }
    return candidates;
  }

  List<Location> candidateLeaderAssignSpaces(Piece leader) {
    final candidates = <Location>[];
    if (leader.isType(PieceType.mapAurelian)) {
      final leaderLocation = _state.pieceLocation(leader);
      for (final space in _state.spaceAndAdjacentSpaces(leaderLocation)) {
        if (spaceIsAssignCandidate(space)) {
          candidates.add(space);
        }
      }
    }
    return candidates;
  }

  List<Location> candidateLeaderRedeploySpaces(Piece leader) {
    final candidates = <Location>[];
    if (leader.isType(PieceType.mapAurelian)) {
      final leaderLocation = _state.pieceLocation(leader);
      for (final space in _state.spaceAndAdjacentSpaces(leaderLocation)) {
        if (spaceIsRedeployCandidate(space)) {
          candidates.add(space);
        }
      }
    }
    return candidates;
  }

  List<Location> candidateLeaderCampaignSpaces(Piece leader) {
    final candidates = <Location>[];
    if (leader.isType(PieceType.mapAurelian)) {
      final leaderLocation = _state.pieceLocation(leader);
      for (final space in _state.spaceAndAdjacentSpaces(leaderLocation)) {
        if (spaceIsCampaignCandidate(space)) {
          candidates.add(space);
        }
      }
    }
    return candidates;
  }

  List<Location> candidateLeaderBattleSpaces(Piece leader) {
    final candidates = <Location>[];
    if (leader.isType(PieceType.mapAurelian)) {
      final leaderLocation = _state.pieceLocation(leader);
      for (final space in _state.spaceAndAdjacentSpaces(leaderLocation)) {
        if (spaceIsBattleCandidate(space)) {
          candidates.add(space);
        }
      }
    }
    return candidates;
  }

  List<Location> candidateLeaderSiegeSpaces(Piece leader) {
    final candidates = <Location>[];
    final leaderLocation = _state.pieceLocation(leader);
    for (final space in _state.spaceAndAdjacentSpaces(leaderLocation)) {
      if (spaceIsSiegeCandidate(space)) {
        candidates.add(space);
      }
    }
    return candidates;
  }

  List<Location> candidateLeaderMarchLocations(Piece leader) {
    final candidates = <Location>[];
    final originalLocation = _state.pieceLocation(leader);
    for (final space in _state.spaceAndAdjacentSpaces(originalLocation)) {
      if (space != originalLocation) {
        if (spaceIsMarchCandidate(space)) {
          if (!candidates.contains(space)) {
            candidates.add(space);
            for (final otherSpace in _state.spaceAdjacentSpaces(space)) {
              if (spaceIsMarchCandidate(space)) {
                if (!candidates.contains(otherSpace)) {
                  candidates.add(otherSpace);
                }
              }
            }
          }
       }
      }
    }
    return candidates;
  }

  void cupAdjustment(Location from, Location to) {
    final piece = randPiece(_state.piecesInLocation(PieceType.all, from));
    if (piece != null) {
      logLine('> A chit moves from ${from.desc} to ${to.desc}.');
      return;
    }
    if (from == Location.cupFriendly) {
      cupAdjustment(Location.cupUnfriendly, Location.cupHostile);
    }
  }

  void reactionResistance(Piece resistance) {
    final space = _state.resistanceHome(resistance);
    logLine('### Resistance in ${space.desc}');
    final region = _state.spaceRegion(space);
    _state.setPieceLocation(resistance, space);
    int resistanceCount = _state.piecesInLocationCount(PieceType.mapResistance, space);
    int cvCount = _state.piecesInLocationCount(PieceType.mapCV, space);
    if (resistanceCount == 1 && cvCount == 0) {
      logLine('> Resistance breaks out in ${space.desc}.');
    } else {
      logLine('> Resistance increases in ${space.desc}.');
    }
    final leader = _state.pieceInLocation(PieceType.mapLeader, space);
    if (leader != null) {
      if (resistanceCount == 1 && cvCount == 0) {
        logLine('> Resistance in ${space.desc} is put down by ${leader.desc}.');
      } else {
        logLine('> ${leader.desc} puts down the new outbreak.');
      }
      _state.setPieceLocation(resistance, Location.poolDead);
      resistanceCount -= 1;
    }
    final usurper = _state.regionUsurper(region);
    if (resistanceCount + cvCount >= 3 || usurper != null) {
      if (resistanceCount > 0) {
        if (cvCount > 0) {
          logLine('> Revolt in ${space.desc} grows.');
        } else {
          logLine('> Revolt breaks out in ${space.desc}.');
        }
        for (final resistance in _state.piecesInLocation(PieceType.mapResistance, space)) {
          final cv = _state.pieceFlipSide(resistance)!;
          _state.setPieceLocation(cv, space);
        }
      }
    } else if (resistanceCount + cvCount <= 2 && usurper == null) {
      if (cvCount > 0) {
        logLine('> Open revolt in ${space.desc} ceases.');
        for (final cv in _state.piecesInLocation(PieceType.mapCV, space)) {
          final resistance = _state.pieceFlipSide(cv)!;
          _state.setPieceLocation(resistance, space);
        }
      }
    }
  }

  void reactionBarbarian(Piece barbarian) {
    final localState = _reactionState!;
    if (localState.subStep == 0) {
      logLine('### Barbarian');
      int die = rollD8();
      if (die <= 2 && _state.regionUsurper(Region.blue) != null) {
        logLine('> Usurper handles the Barbarian incursion.');
        localState.subStep = 1;
      } else {
        

      }
    }
    if (localState.subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Lose VP or Coin?');
        choiceChoosable(Choice.loseVP, true);
        choiceChoosable(Choice.loseCoin, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.loseVP)) {
        adjustVP(-1);
      } else {
        adjustCoin(-1);
      }
    }
  }

  void reaction() {
    _reactionState ??= ReactionState();
    final piece = randPiece(_state.piecesInLocation(PieceType.all, Location.cupHostile))!;
    if (piece.isType(PieceType.mapResistance)) {
      reactionResistance(piece);
    } else if (piece.isType(PieceType.mapBarbarian)) {
      reactionBarbarian(piece);
    }
    _reactionState = null;
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
  }

  // Sequence Helpers

  // Sequence of Play

  void turnBegin() {
    logLine('# Turn ${_state.turnName(_state.currentTurn)}');
  }

  void actionsPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Actions Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Actions Phase');
    _phaseState = PhaseStateActions();
  }

  void actionSuppress(Piece leader, Location space) {
    if (_subStep == 0) {
      logLine('### ${leader.desc} attempts to Suppress ${space.desc}');
      final resistance = _state.spaceTopmostResistancePiece(space)!;
      int rating = _state.resistanceRating(resistance);    
      int die = rollD8();
      logLine('> ${resistance.desc}: $rating');
      if (die > rating) {
        final pieces = _state.piecesInLocation(PieceType.mapEnemyUnit, space);
        if (leader.isType(PieceType.mapAurelian) || pieces.length == 1) {
          logLine('> Resistance in ${space.desc} is suppressed.');
          for (final piece in _state.piecesInLocation(PieceType.mapEnemyUnit, space)) {
            _state.setPieceLocation(piece, Location.poolDead);
          }
        } else {
          logLine('> Resistance in ${space.desc} is reduced.');
          _state.setPieceLocation(resistance, Location.poolDead);
        }
      } else {
        logLine('> Resistance continues despite attempts to suppress it.');
      }
      cupAdjustment(Location.cupFriendly, Location.cupUnfriendly);
      _subStep = 1;
    }
    while (_subStep >= 1 && _subStep <= 2) {
      reaction();
      _subStep += 1;
    }
  }

  void actionPlacate(Piece leader, Location space) {

  }

  void actionAssign(Piece leader, Location space) {

  }

  void actionRedeploy(Piece leader, Location space) {

  }

  void actionCampaign(Piece leader, Location space) {

  }

  void actionBattle(Piece leader, Location space) {

  }

  void actionSiege(Piece leader, Location space) {

  }

  void actionsPhaseDoActions() {
    final phaseState = _phaseState as PhaseStateActions;
    while (true) {
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      if (choicesEmpty()) {
        setPrompt('Select Leader to perform Action, or Next to proceed');
        for (final leader in PieceType.mapLeader.pieces) {
          if (_state.pieceLocation(leader).isType(LocationType.space)) {
            pieceChoosable(leader);
          }
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      final leader = selectedPiece()!;
      phaseState.leader = leader;
      if (_choiceInfo.selectedChoices.isEmpty) {
        if (choicesEmpty()) {
          setPrompt('Select Action');
          if (candidateLeaderSuppressSpaces(leader).isNotEmpty) {
            choiceChoosable(Choice.actionSuppress, true);
          }
          if (candidateLeaderPlacateSpaces(leader).isNotEmpty) {
            choiceChoosable(Choice.actionPlacate, true);
          }
          if (_state.piecesInLocationCount(PieceType.mapOfficer, Location.offmap) > 0 && candidateLeaderAssignSpaces(leader).isNotEmpty) {
            choiceChoosable(Choice.actionAssign, true);
          }
          if (candidateLeaderRedeploySpaces(leader).isNotEmpty) {
            choiceChoosable(Choice.actionRedeploy, true);
          }
          if (candidateLeaderCampaignSpaces(leader).isNotEmpty) {
            choiceChoosable(Choice.actionCampaign, true);
          }
          if (candidateLeaderBattleSpaces(leader).isNotEmpty) {
            choiceChoosable(Choice.actionBattle, true);
          }
          if (candidateLeaderSiegeSpaces(leader).isNotEmpty) {
            choiceChoosable(Choice.actionSiege, true);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
      }
      final location = selectedLocation();
      if (location == null) {
        if (checkChoice(Choice.actionSuppress)) {
          setPrompt('Select Box to Suppress');
          for (final space in candidateLeaderSuppressSpaces(leader)) {
            locationChoosable(space);
          }
        } else if (checkChoice(Choice.actionPlacate)) {
          setPrompt('Select Box to Placate');
          for (final space in candidateLeaderPlacateSpaces(leader)) {
            locationChoosable(space);
          }
        } else if (checkChoice(Choice.actionAssign)) {
          setPrompt('Select Box to Assign Officer to');
          for (final space in candidateLeaderAssignSpaces(leader)) {
            locationChoosable(space);
          }
        } else if (checkChoice(Choice.actionRedeploy)) {
          setPrompt('Select Box for Redeploy');
          for (final space in candidateLeaderRedeploySpaces(leader)) {
            locationChoosable(space);
          }
        } else if (checkChoice(Choice.actionCampaign)) {
          setPrompt('Select Box to Campaign in');
          for (final space in candidateLeaderCampaignSpaces(leader)) {
            locationChoosable(space);
          }
        } else if (checkChoice(Choice.actionBattle)) {
          setPrompt('Select Box for Battle');
          for (final space in candidateLeaderBattleSpaces(leader)) {
            locationChoosable(space);
          }
        } else if (checkChoice(Choice.actionSiege)) {
          setPrompt('Select Box to Siege');
          for (final space in candidateLeaderSiegeSpaces(leader)) {
            locationChoosable(space);
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.actionSuppress)) {
        actionSuppress(leader, location);
      } else if (checkChoice(Choice.actionPlacate)) {
        actionPlacate(leader, location);
      } else if (checkChoice(Choice.actionAssign)) {
        actionAssign(leader, location);
      } else if (checkChoice(Choice.actionRedeploy)) {
        actionRedeploy(leader, location);
      } else if (checkChoice(Choice.actionCampaign)) {
        actionCampaign(leader, location);
      } else if (checkChoice(Choice.actionBattle)) {
        actionBattle(leader, location);
      } else if (checkChoice(Choice.actionSiege)) {
        actionSiege(leader, location);
      }
    }
  }

  void actionsPhaseEnd() {
    _phaseState = null;
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      actionsPhaseBegin,
      actionsPhaseDoActions,
      actionsPhaseEnd,
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

import 'dart:convert';
import 'dart:math';
import 'package:agricola/db.dart';
import 'package:agricola/random.dart';

enum Location {
  iceni,
  corieltavvi,
  dubunni,
  catuvellani,
  demetae,
  ordovices,
  silures,
  deceangli,
  parisi,
  cornovvi,
  votadini,
  brigantes,
  damnoni,
  taexali,
  venicones,
  caledonii,
  legionaryCampII,
  legionaryCampIX,
  legionaryCampXX,
  boxLegionHoldingII,
  boxLegionHoldingIX,
  boxLegionHoldingXX,
  poolForce,
  poolDead,
  boxTacticalTribe1,
  boxTacticalTribe2,
  boxTacticalTribe3,
  boxTacticalTribe4,
  boxTacticalTribe5,
  boxTacticalTribe6,
  boxTacticalTribe7,
  boxTacticalTribe8,
  boxTacticalTribe9,
  boxTacticalTribe10,
  boxTacticalTribe11,
  boxTacticalTribe12,
  boxTacticalTribe13,
  boxTacticalRomanFront1,
  boxTacticalRomanFront2,
  boxTacticalRomanFront3,
  boxTacticalRomanFront4,
  boxTacticalRomanFront5,
  boxTacticalRomanFront6,
  boxTacticalRomanReserve7,
  boxTacticalRomanReserve8,
  boxTacticalRomanReserve9,
  boxTacticalRomanReserve10,
  boxTacticalRomanReserve11,
  boxTacticalRomanReserve12,
  boxTacticalRomanReserve13,
  boxLegionActions0,
  boxLegionActions1,
  boxLegionActions2,
  boxLegionActions3,
  boxLegionActions4,
  boxLegionActions5,
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
  boxTurn1,
  boxTurn2,
  boxTurn3,
  boxTurn4,
  boxTurn5,
  boxTurn6,
  boxTurn7,
  boxTurn8,
  cupFriendly,
  cupUnfriendly,
  cupHostile,
  cupBattle,
  flipped,
  discarded,
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
  map,
  tribe,
  blueRegion,
  tanRegion,
  greenRegion,
  redRegion,
  legionaryCamp,
  legionHolding,
  tactical,
  tacticalTribe,
  tacticalRoman,
  legionActions,
  income,
  victory,
  turn,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.map: [Location.iceni, Location.legionaryCampXX],
    LocationType.tribe: [Location.iceni, Location.caledonii],
    LocationType.blueRegion: [Location.iceni, Location.catuvellani],
    LocationType.tanRegion: [Location.demetae, Location.deceangli],
    LocationType.greenRegion: [Location.parisi, Location.brigantes],
    LocationType.redRegion: [Location.damnoni, Location.caledonii],
    LocationType.legionaryCamp: [Location.legionaryCampII, Location.legionaryCampXX],
    LocationType.legionHolding: [Location.boxLegionHoldingII, Location.boxLegionHoldingXX],
    LocationType.tactical: [Location.boxTacticalTribe1, Location.boxTacticalRomanReserve13],
    LocationType.tacticalTribe: [Location.boxTacticalTribe1, Location.boxTacticalTribe13],
    LocationType.tacticalRoman: [Location.boxTacticalRomanFront1, Location.boxTacticalRomanReserve13],
    LocationType.legionActions: [Location.boxLegionActions0, Location.boxLegionActions5],
    LocationType.income: [Location.boxIncome1, Location.boxIncome13],
    LocationType.victory: [Location.boxVictory0, Location.boxVictory9],
    LocationType.turn: [Location.boxTurn1, Location.boxTurn8],
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
      Location.iceni: 'Iceni',
      Location.corieltavvi: 'Corieltavvi',
      Location.dubunni: 'Dubunni',
      Location.catuvellani: 'Catuvellani',
      Location.demetae: 'Demetae',
      Location.ordovices: 'Ordovices',
      Location.silures: 'Silures',
      Location.deceangli: 'Deceangli',
      Location.parisi: 'Parisi',
      Location.cornovvi: 'Cornovvi',
      Location.votadini: 'Votadini',
      Location.brigantes: 'Brigantes',
      Location.damnoni: 'Damnoni',
      Location.taexali: 'Taexali',
      Location.venicones: 'Venicones',
      Location.caledonii: 'Caledonii',
      Location.legionaryCampII: 'Isca Augustus',
      Location.legionaryCampIX: 'Eboracum',
      Location.legionaryCampXX: 'Deva Victrix',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Piece {
  dubbini0,
  dubbini1,
  corieltavvi0,
  corieltavvi1,
  catuvellani0,
  catuvellani1,
  iceni0,
  iceni1,
  silures0,
  silures1,
  silures2,
  silures3,
  deceangli0,
  decenagli1,
  ordovices0,
  ordovices1,
  ordovices2,
  demetae0,
  demetae1,
  brigantes0,
  brigantes1,
  brigantes2,
  brigantes3,
  cornovvi0,
  cornovvi1,
  votadini0,
  votadini1,
  votadini2,
  parisi0,
  parisi1,
  damnonii0,
  damnonii1,
  damnonii2,
  venicones0,
  venicones1,
  venicones2,
  taexali0,
  taexali1,
  taexali2,
  caledonii0,
  caledonii1,
  caledonii2,
  caledonii3,
  legionAugustaII,
  legionHispanaIX,
  legionValeriaVictrixXX,
  leaderTan,
  leaderGreen,
  leaderRedCalgacus,
  leaderAgricola,
  garrison0,
  garrison1,
  garrison2,
  garrison3,
  garrison4,
  garrison5,
  garrison6,
  settlement0,
  settlement1,
  settlement2,
  settlement3,
  settlement4,
  settlement5,
  settlement6,
  settlement7,
  tribe0,
  tribe1,
  tribe2,
  tribe3,
  tribe4,
  tribe5,
  tribe6,
  tribe7,
  tribe8,
  tribe9,
  tribe10,
  tribe11,
  tribe12,
  tribeGraupius0,
  tribeGraupius1,
  tribeGraupius2,
  tribeGraupius3,
  tribeGraupius4,
  tribeGraupius5,
  tribeGraupius6,
  tribeGraupius7,
  tribeGraupius8,
  tribeGraupius9,
  tribeGraupius10,
  tribeGraupius11,
  tribeGraupius12,
  auxiliaryBlue0,
  auxiliaryBlue1,
  auxiliaryBlue2,
  auxiliaryBlue3,
  auxiliaryBlue4,
  auxiliaryBlue5,
  auxiliaryBlue6,
  auxiliaryBlue7,
  auxiliaryTan0,
  auxiliaryTan1,
  auxiliaryTan2,
  auxiliaryTan3,
  auxiliaryTan4,
  auxiliaryTan5,
  auxiliaryTan6,
  auxiliaryTan7,
  auxiliaryTan8,
  auxiliaryTan9,
  auxiliaryTan10,
  auxiliaryGreen0,
  auxiliaryGreen1,
  auxiliaryGreen2,
  auxiliaryGreen3,
  auxiliaryGreen4,
  auxiliaryGreen5,
  auxiliaryGreen6,
  auxiliaryGreen7,
  auxiliaryGreen8,
  auxiliaryGreen9,
  auxiliaryGreen10,
  legionary0,
  legionary1,
  legionary2,
  legionary3,
  legionary4,
  legionary5,
  legionary6,
  legionary7,
  legionary8,
  legionary9,
  legionary10,
  legionary11,
  legionary12,
  legionary13,
  legionary14,
  legionary15,
  legionary16,
  legionary17,
  legionary18,
  legionary19,
  legionary20,
  legionary21,
  legionary22,
  markerGameTurn,
  markerIncome,
  markerTreasury,
  markerLegionActions,
  markerVictoryPoints10,
  markerVictoryPoints1,
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
  map,
  mapTribe,
  mapTribeBlue,
  mapTribeTan,
  mapTribeGreen,
  mapTribeRed,
  mapLegion,
  mapLeader,
  mapSettlement,
  mapSettlement2,
  mapSettlement3,
  battleTribe,
  battleTribeNormal,
  battleTribeGraupius,
  auxiliaryBlue,
  battleLegionary,
  battleLegionary1Ensign,
  battleLegionary2Ensign,
  battleLegionary3Ensign,
  incomeTrack,
  victoryTrack,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.dubbini0, Piece.markerVictoryPoints10],
    PieceType.map: [Piece.dubbini0, Piece.settlement7],
    PieceType.mapTribe: [Piece.dubbini0, Piece.caledonii3],
    PieceType.mapTribeBlue: [Piece.dubbini0, Piece.iceni1],
    PieceType.mapTribeTan: [Piece.silures0, Piece.demetae1],
    PieceType.mapTribeGreen: [Piece.brigantes0, Piece.parisi1],
    PieceType.mapTribeRed: [Piece.damnonii0, Piece.caledonii3],
    PieceType.mapLegion: [Piece.legionAugustaII, Piece.legionValeriaVictrixXX],
    PieceType.mapLeader: [Piece.leaderTan, Piece.leaderRedCalgacus],
    PieceType.battleTribe: [Piece.tribe0, Piece.tribeGraupius12],
    PieceType.battleTribeNormal: [Piece.tribe0, Piece.tribe12],
    PieceType.battleTribeGraupius: [Piece.tribeGraupius0, Piece.tribeGraupius12],
    PieceType.auxiliaryBlue: [Piece.auxiliaryBlue0, Piece.auxiliaryBlue7],
    PieceType.battleLegionary: [Piece.legionary0, Piece.legionary22],
    PieceType.battleLegionary1Ensign: [Piece.legionary0, Piece.legionary6],
    PieceType.battleLegionary2Ensign: [Piece.legionary7, Piece.legionary14],
    PieceType.battleLegionary3Ensign: [Piece.legionary15, Piece.legionary22],
    PieceType.mapSettlement: [Piece.settlement0, Piece.settlement7],
    PieceType.mapSettlement2: [Piece.settlement0, Piece.settlement3],
    PieceType.mapSettlement3: [Piece.settlement4, Piece.settlement7],
    PieceType.incomeTrack: [Piece.markerIncome, Piece.markerTreasury],
    PieceType.victoryTrack: [Piece.markerVictoryPoints10, Piece.markerVictoryPoints1],
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

enum Region {
  blue,
  tan,
  green,
  red,
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
      Scenario.standard: 'Standard (8 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<int> _tribeStackDepths = List<int>.filled(PieceType.mapTribe.count, -1);
  Piece? agricolaLegion;

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
   : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
   , _tribeStackDepths = List<int>.from(json['tribeStackDepths'])
   , agricolaLegion = pieceFromIndex(json['agricolaLegion'] as int?)
   ;

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'tribeStackDepths': _tribeStackDepths,
    'agricolaLegion': pieceToIndex(agricolaLegion),
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.dubbini0: Piece.auxiliaryBlue0,
      Piece.dubbini1: Piece.auxiliaryBlue1,
      Piece.corieltavvi0: Piece.auxiliaryBlue2,
      Piece.corieltavvi1: Piece.auxiliaryBlue3,
      Piece.catuvellani0: Piece.auxiliaryBlue4,
      Piece.catuvellani1: Piece.auxiliaryBlue5,
      Piece.iceni0: Piece.auxiliaryBlue6,
      Piece.iceni1: Piece.auxiliaryBlue7,
      Piece.silures0: Piece.auxiliaryTan0,
      Piece.silures1: Piece.auxiliaryTan1,
      Piece.silures2: Piece.auxiliaryTan2,
      Piece.silures3: Piece.auxiliaryTan3,
      Piece.deceangli0: Piece.auxiliaryTan4,
      Piece.decenagli1: Piece.auxiliaryTan5,
      Piece.ordovices0: Piece.auxiliaryTan6,
      Piece.ordovices1: Piece.auxiliaryTan7,
      Piece.ordovices2: Piece.auxiliaryTan8,
      Piece.demetae0: Piece.auxiliaryTan9,
      Piece.demetae1: Piece.auxiliaryTan10,
      Piece.brigantes0: Piece.auxiliaryGreen0,
      Piece.brigantes1: Piece.auxiliaryGreen1,
      Piece.brigantes2: Piece.auxiliaryGreen2,
      Piece.brigantes3: Piece.auxiliaryGreen3,
      Piece.cornovvi0: Piece.auxiliaryGreen4,
      Piece.cornovvi1: Piece.auxiliaryGreen5,
      Piece.votadini0: Piece.auxiliaryGreen6,
      Piece.votadini1: Piece.auxiliaryGreen7,
      Piece.votadini2: Piece.auxiliaryGreen8,
      Piece.parisi0: Piece.auxiliaryGreen9,
      Piece.parisi1: Piece.auxiliaryGreen10,
      Piece.garrison0: Piece.legionary0,
      Piece.garrison1: Piece.legionary1,
      Piece.garrison2: Piece.legionary2,
      Piece.garrison3: Piece.legionary3,
      Piece.garrison4: Piece.legionary4,
      Piece.garrison5: Piece.legionary5,
      Piece.garrison6: Piece.legionary6,
      Piece.settlement0: Piece.settlement4,
      Piece.settlement1: Piece.settlement5,
      Piece.settlement2: Piece.settlement6,
      Piece.settlement3: Piece.settlement7,
      Piece.settlement4: Piece.settlement0,
      Piece.settlement5: Piece.settlement1,
      Piece.settlement6: Piece.settlement2,
      Piece.settlement7: Piece.settlement3,
      Piece.tribe0: Piece.tribeGraupius0,
      Piece.tribe1: Piece.tribeGraupius1,
      Piece.tribe2: Piece.tribeGraupius2,
      Piece.tribe3: Piece.tribeGraupius3,
      Piece.tribe4: Piece.tribeGraupius4,
      Piece.tribe5: Piece.tribeGraupius5,
      Piece.tribe6: Piece.tribeGraupius6,
      Piece.tribe7: Piece.tribeGraupius7,
      Piece.tribe8: Piece.tribeGraupius8,
      Piece.tribe9: Piece.tribeGraupius9,
      Piece.tribe10: Piece.tribeGraupius10,
      Piece.tribe11: Piece.tribeGraupius11,
      Piece.tribe12: Piece.tribeGraupius12,
      Piece.tribeGraupius0: Piece.tribe0,
      Piece.tribeGraupius1: Piece.tribe1,
      Piece.tribeGraupius2: Piece.tribe2,
      Piece.tribeGraupius3: Piece.tribe3,
      Piece.tribeGraupius4: Piece.tribe4,
      Piece.tribeGraupius5: Piece.tribe5,
      Piece.tribeGraupius6: Piece.tribe6,
      Piece.tribeGraupius7: Piece.tribe7,
      Piece.tribeGraupius8: Piece.tribe8,
      Piece.tribeGraupius9: Piece.tribe9,
      Piece.tribeGraupius10: Piece.tribe10,
      Piece.tribeGraupius11: Piece.tribe11,
      Piece.tribeGraupius12: Piece.tribe12,
      Piece.auxiliaryBlue0: Piece.dubbini0,
      Piece.auxiliaryBlue1: Piece.dubbini1,
      Piece.auxiliaryBlue2: Piece.corieltavvi0,
      Piece.auxiliaryBlue3: Piece.corieltavvi1,
      Piece.auxiliaryBlue4: Piece.catuvellani0,
      Piece.auxiliaryBlue5: Piece.catuvellani1,
      Piece.auxiliaryBlue6: Piece.iceni0,
      Piece.auxiliaryBlue7: Piece.iceni1,
      Piece.auxiliaryTan0: Piece.silures0,
      Piece.auxiliaryTan1: Piece.silures1,
      Piece.auxiliaryTan2: Piece.silures2,
      Piece.auxiliaryTan3: Piece.silures3,
      Piece.auxiliaryTan4: Piece.deceangli0,
      Piece.auxiliaryTan5: Piece.decenagli1,
      Piece.auxiliaryTan6: Piece.ordovices0,
      Piece.auxiliaryTan7: Piece.ordovices1,
      Piece.auxiliaryTan8: Piece.ordovices2,
      Piece.auxiliaryTan9: Piece.demetae0,
      Piece.auxiliaryTan10: Piece.demetae1,
      Piece.auxiliaryGreen0: Piece.brigantes0,
      Piece.auxiliaryGreen1: Piece.brigantes1,
      Piece.auxiliaryGreen2: Piece.brigantes2,
      Piece.auxiliaryGreen3: Piece.brigantes3,
      Piece.auxiliaryGreen4: Piece.cornovvi0,
      Piece.auxiliaryGreen5: Piece.cornovvi1,
      Piece.auxiliaryGreen6: Piece.votadini0,
      Piece.auxiliaryGreen7: Piece.votadini1,
      Piece.auxiliaryGreen8: Piece.votadini2,
      Piece.auxiliaryGreen9: Piece.parisi0,
      Piece.auxiliaryGreen10: Piece.parisi1,
      Piece.legionary0: Piece.garrison0,
      Piece.legionary1: Piece.garrison1,
      Piece.legionary2: Piece.garrison2,
      Piece.legionary3: Piece.garrison3,
      Piece.legionary4: Piece.garrison4,
      Piece.legionary5: Piece.garrison5,
      Piece.legionary6: Piece.garrison6,
      Piece.legionary7: Piece.legionary15,
      Piece.legionary8: Piece.legionary16,
      Piece.legionary9: Piece.legionary17,
      Piece.legionary10: Piece.legionary18,
      Piece.legionary11: Piece.legionary19,
      Piece.legionary12: Piece.legionary20,
      Piece.legionary13: Piece.legionary21,
      Piece.legionary14: Piece.legionary22,
      Piece.legionary15: Piece.legionary7,
      Piece.legionary16: Piece.legionary8,
      Piece.legionary17: Piece.legionary9,
      Piece.legionary18: Piece.legionary10,
      Piece.legionary19: Piece.legionary11,
      Piece.legionary20: Piece.legionary12,
      Piece.legionary21: Piece.legionary13,
      Piece.legionary22: Piece.legionary14,
    };
    return pieceFlipSides[piece];
  }

  Location pieceLocation(Piece piece) {
    return _pieceLocations[piece.index];
  }

  int tribeStackDepth(Piece tribe) {
    return _tribeStackDepths[tribe.index - PieceType.mapTribe.firstIndex];
  }

  void redoStackDepths(Location location) {
    final tribeStackDepths = <(Piece, int)>[];
    Piece? newTribe;
    for (final tribe in piecesInLocation(PieceType.mapTribe, location)) {
      int depth = _tribeStackDepths[tribe.index - PieceType.mapTribe.firstIndex];
      if (depth == -1) {
        newTribe = tribe;
      } else {
        tribeStackDepths.add((tribe, depth));
      }
    }
    tribeStackDepths.sort((a, b) => a.$2.compareTo(b.$2));
    int depth = 0;
    for (depth = 0; depth < tribeStackDepths.length; ++depth) {
      _tribeStackDepths[tribeStackDepths[depth].$1.index - PieceType.mapTribe.firstIndex] = depth;
    }
    if (newTribe != null) {
      _tribeStackDepths[newTribe.index - PieceType.mapTribe.firstIndex] = depth;
      depth += 1;
    }
  }

  void setPieceLocation(Piece piece, Location location) {
    final oldLocation = _pieceLocations[piece.index];
    _pieceLocations[piece.index] = location;
    if (piece.isType(PieceType.mapTribe)) {
      _tribeStackDepths[piece.index - PieceType.mapTribe.firstIndex] = -1;
    }
    final obverse = pieceFlipSide(piece);
    if (obverse != null) {
      final oldFlippedLocation = _pieceLocations[obverse.index];
      _pieceLocations[obverse.index] = Location.flipped;
      if (obverse.isType(PieceType.mapTribe)) {
        _tribeStackDepths[obverse.index - PieceType.mapTribe.firstIndex] = -1;
        if (oldFlippedLocation.isType(LocationType.map)) {
          redoStackDepths(oldFlippedLocation);
        }
      }
    }
    if (piece.isType(PieceType.mapTribe)) {
      if (oldLocation.isType(LocationType.map)) {
        redoStackDepths(oldLocation);
      }
      if (location.isType(LocationType.map)) {
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
      Location.iceni: [Location.corieltavvi],
      Location.corieltavvi: [Location.iceni, Location.dubunni],
      Location.dubunni: [Location.corieltavvi, Location.legionaryCampII],
      Location.catuvellani: [Location.legionaryCampIX],
      Location.demetae: [Location.silures],
      Location.ordovices: [Location.silures, Location.deceangli, Location.legionaryCampXX],
      Location.silures: [Location.demetae, Location.ordovices, Location.legionaryCampII],
      Location.deceangli: [Location.ordovices],
      Location.parisi: [Location.cornovvi, Location.brigantes, Location.legionaryCampIX],
      Location.cornovvi: [Location.parisi, Location.brigantes, Location.legionaryCampXX],
      Location.votadini: [Location.brigantes, Location.damnoni],
      Location.brigantes: [Location.parisi, Location.cornovvi, Location.votadini],
      Location.damnoni: [Location.votadini, Location.venicones, Location.caledonii],
      Location.taexali: [Location.venicones, Location.caledonii],
      Location.venicones: [Location.damnoni, Location.taexali],
      Location.caledonii: [Location.damnoni, Location.taexali],
      Location.legionaryCampII: [Location.dubunni, Location.silures, Location.legionaryCampXX],
      Location.legionaryCampIX: [Location.catuvellani, Location.parisi, Location.legionaryCampXX],
      Location.legionaryCampXX: [Location.ordovices, Location.cornovvi, Location.legionaryCampII, Location.legionaryCampIX],
    };
    return adjacentSpaces[space]!;
  }

  List<Location> spaceAndAdjacentSpaces(Location space) {
    final spaces = spaceAdjacentSpaces(space);
    spaces.add(space);
    return spaces;
  }

  List<Location> spaceRoadSpaces(Location space) {
    const roadSpaces = {
      Location.iceni: [Location.corieltavvi],
      Location.corieltavvi: [Location.iceni, Location.dubunni],
      Location.dubunni: [Location.corieltavvi, Location.legionaryCampII],
      Location.catuvellani: [Location.legionaryCampIX],
      Location.legionaryCampII: [Location.dubunni, Location.legionaryCampXX],
      Location.legionaryCampIX: [Location.catuvellani, Location.legionaryCampXX],
      Location.legionaryCampXX: [Location.legionaryCampII, Location.legionaryCampIX],
    };
    return roadSpaces[space] ?? [];
  }

  List<Location> spaceConnectedSpaces(Location space) {
    final connectedSpaces = <Location>[];
    final connectedRoadSpaces = [space];
    var checkSpaces = [space];
    while (checkSpaces.isNotEmpty) {
      final newCheckSpaces = <Location>[];
      for (final checkSpace in checkSpaces) {
        final checkAdjacentSpaces = spaceAdjacentSpaces(checkSpace);
        final checkRoadSpaces = spaceRoadSpaces(checkSpace);
        for (final adjacentSpace in checkAdjacentSpaces) {
          if (adjacentSpace != space && !connectedSpaces.contains(adjacentSpace)) {
            connectedSpaces.add(adjacentSpace);
          }
          if (checkRoadSpaces.contains(adjacentSpace)) {
            if (!connectedRoadSpaces.contains(adjacentSpace)) {
              connectedRoadSpaces.add(adjacentSpace);
              newCheckSpaces.add(adjacentSpace);
            }
          }
        }
      }
      checkSpaces = newCheckSpaces;
    }
    return connectedSpaces;
  }

  List<Location> spaceAndConnectedSpaces(Location space) {
    final spaces = spaceConnectedSpaces(space);
    spaces.add(space);
    return spaces;
  }

  Region? spaceRegion(Location space) {
    const spaceRegions = {
      Location.iceni: Region.blue,
      Location.corieltavvi: Region.blue,
      Location.dubunni: Region.blue,
      Location.catuvellani: Region.blue,
      Location.demetae: Region.tan,
      Location.ordovices: Region.tan,
      Location.silures: Region.tan,
      Location.deceangli: Region.tan,
      Location.parisi: Region.green,
      Location.cornovvi: Region.green,
      Location.votadini: Region.green,
      Location.brigantes: Region.green,
      Location.damnoni: Region.red,
      Location.taexali: Region.red,
      Location.venicones: Region.red,
      Location.caledonii: Region.red,
    };
    return spaceRegions[space];
  }

  // Regions

  Piece? regionLeader(Region region) {
    const regionLeaderPieces = {
      Region.tan: Piece.leaderTan,
      Region.green: Piece.leaderGreen,
      Region.red: Piece.leaderRedCalgacus,
    };
    return regionLeaderPieces[region];
  }

  Piece? regionActiveLeader(Region region) {
    final leader = regionLeader(region);
    if (leader == null) {
      return null;
    }
    final location = pieceLocation(leader);
    if (!location.isType(LocationType.map)) {
      return null;
    }
    return leader;
  }

  // Tribes

  Location tribeHome(Piece tribe) {
    const tribeHomes = {
      Piece.dubbini0: Location.dubunni,
      Piece.dubbini1: Location.dubunni,
      Piece.corieltavvi0: Location.corieltavvi,
      Piece.corieltavvi1: Location.corieltavvi,
      Piece.catuvellani0: Location.catuvellani,
      Piece.catuvellani1: Location.catuvellani,
      Piece.iceni0: Location.iceni,
      Piece.iceni1: Location.iceni,
      Piece.silures0: Location.silures,
      Piece.silures1: Location.silures,
      Piece.silures2: Location.silures,
      Piece.silures3: Location.silures,
      Piece.deceangli0: Location.deceangli,
      Piece.decenagli1: Location.deceangli,
      Piece.ordovices0: Location.ordovices,
      Piece.ordovices1: Location.ordovices,
      Piece.ordovices2: Location.ordovices,
      Piece.demetae0: Location.demetae,
      Piece.demetae1: Location.demetae,
      Piece.brigantes0: Location.brigantes,
      Piece.brigantes1: Location.brigantes,
      Piece.brigantes2: Location.brigantes,
      Piece.brigantes3: Location.brigantes,
      Piece.cornovvi0: Location.cornovvi,
      Piece.cornovvi1: Location.cornovvi,
      Piece.votadini0: Location.votadini,
      Piece.votadini1: Location.votadini,
      Piece.votadini2: Location.votadini,
      Piece.parisi0: Location.parisi,
      Piece.parisi1: Location.parisi,
      Piece.damnonii0: Location.damnoni,
      Piece.damnonii1: Location.damnoni,
      Piece.damnonii2: Location.damnoni,
      Piece.venicones0: Location.venicones,
      Piece.venicones1: Location.venicones,
      Piece.venicones2: Location.venicones,
      Piece.taexali0: Location.taexali,
      Piece.taexali1: Location.taexali,
      Piece.taexali2: Location.taexali,
      Piece.caledonii0: Location.caledonii,
      Piece.caledonii1: Location.caledonii,
      Piece.caledonii2: Location.caledonii,
      Piece.caledonii3: Location.caledonii,
    };
    return tribeHomes[tribe]!;
  }

  // Leaders

  Location leaderRandomTribe(Piece leader, int die) {
    switch (leader) {
    case Piece.leaderTan:
      switch (die) {
      case 1:
        return Location.demetae;
      case 2:
        return Location.ordovices;
      case 3:
        return Location.silures;
      default:
        return Location.deceangli;
      }
    case Piece.leaderGreen:
      switch (die) {
      case 1:
        return Location.parisi;
      case 2:
        return Location.cornovvi;
      case 3:
      case 4:
        return Location.votadini;
      default:
        return Location.brigantes;
      }
    case Piece.leaderRedCalgacus:
      switch (die) {
        case 1:
          return Location.damnoni;
        case 2:
          return Location.taexali;
        case 3:
          return Location.venicones;
        default:
          return Location.caledonii;
      }
    default:
      return Location.discarded;
    }
  }

  // Legion Actions

  int get legionActions {
    return pieceLocation(Piece.markerLegionActions).index - LocationType.legionActions.firstIndex;
  }

  // Turns

  int get currentTurn {
    return pieceLocation(Piece.markerGameTurn).index - LocationType.turn.firstIndex;
  }

  String turnName(int turn) {
    switch (turn) {
    case 0:
      return 'Ⅰ';
    case 1:
      return 'Ⅱ';
    case 2:
      return 'Ⅲ';
    case 3:
      return 'Ⅳ';
    case 4:
      return 'Ⅴ';
    case 5:
      return 'Ⅵ';
    case 6:
      return 'Ⅶ';
    case 7:
      return 'Ⅷ';
    default:
      return '';
    }
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

    final tanTribes = PieceType.mapTribeTan.pieces;
    tanTribes.shuffle(random);
    int ordovicesCount = 0;
    int siluresCount = 0;
    int demetaeCount = 0;
    int deceangliCount = 0;
    for (final tribe in tanTribes) {
      if (ordovicesCount < 2 || siluresCount < 1 || demetaeCount < 1 || deceangliCount < 1) {
        final home = state.tribeHome(tribe);
        state.setPieceLocation(tribe, home);
        if (home == Location.ordovices) {
          ordovicesCount += 1;
        } else if (home == Location.silures) {
          siluresCount += 1;
        } else if (home == Location.demetae) {
          demetaeCount += 1;
        } else if (home == Location.deceangli) {
          deceangliCount += 1;
        }
      } else {
        state.setPieceLocation(tribe, Location.cupHostile);
      }
    }

    state.setPieceLocation(Piece.leaderTan, Location.cupHostile);
    state.setupPieceType(PieceType.mapTribeGreen, Location.cupHostile);

    int greenCount = 0;
    while (greenCount < 4) {
      final hostilePieces = state.piecesInLocation(PieceType.map, Location.cupHostile);
      int pieceIndex = random.nextInt(hostilePieces.length);
      final piece = hostilePieces[pieceIndex];
      if (piece.isType(PieceType.mapTribe)) {
        final home = state.tribeHome(piece);
        state.setPieceLocation(piece, home);
        if (piece.isType(PieceType.mapTribeGreen)) {
          greenCount += 1;
        }
      } else {
        // tan leader
        int die = random.nextInt(8) + 1;
        final leaderLocation = state.leaderRandomTribe(piece, die);
        if (state.piecesInLocationCount(PieceType.mapTribeTan, leaderLocation) > 0) {
          state.setPieceLocation(piece, leaderLocation);
        }
      }
    }

    state.setupPieceTypes([
      (PieceType.mapTribeRed, Location.cupUnfriendly),
      (PieceType.mapTribeBlue, Location.cupFriendly),
      (PieceType.battleTribeNormal, Location.cupBattle),
      (PieceType.battleLegionary1Ensign, Location.poolForce),
      (PieceType.battleLegionary2Ensign, Location.poolForce),
      (PieceType.mapSettlement2, Location.poolForce),
    ]);

    state.setupPieces([
      (Piece.leaderGreen, Location.cupHostile),
      (Piece.leaderRedCalgacus, Location.cupUnfriendly),
      (Piece.legionAugustaII, Location.legionaryCampII),
      (Piece.legionHispanaIX, Location.legionaryCampIX),
      (Piece.legionValeriaVictrixXX, Location.legionaryCampXX),
      (Piece.legionary0, Location.boxLegionHoldingII),
      (Piece.legionary1, Location.boxLegionHoldingII),
      (Piece.legionary2, Location.boxLegionHoldingII),
      (Piece.legionary3, Location.boxLegionHoldingIX),
      (Piece.legionary7, Location.boxLegionHoldingIX),
      (Piece.legionary8, Location.boxLegionHoldingIX),
      (Piece.legionary9, Location.boxLegionHoldingXX),
      (Piece.legionary10, Location.boxLegionHoldingXX),
      (Piece.legionary15, Location.boxLegionHoldingXX),
      (Piece.markerGameTurn, Location.boxTurn1),
      (Piece.markerLegionActions, Location.boxLegionActions3),
      (Piece.markerIncome, Location.boxIncome3),
      (Piece.markerTreasury, Location.boxIncome4),
      (Piece.markerVictoryPoints1, Location.boxVictory0),
      (Piece.markerVictoryPoints10, Location.boxVictory0),
    ]);

    return state;
  }
}

enum Choice {
  actionLeaderAttachLeader,
  actionLeaderReorganizeLegion,
  actionLeaderNegotiation,
  actionLegionSuppress,
  actionLegionGarrison,
  actionLegionPeacekeeping,
  actionLegionBattle,
  actionPass,
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

class Game {
  final Scenario _scenario;
  final GameState _state;
  int _step = 0;
  int _subStep = 0;
  GameOutcome? _outcome;
  final GameOptions _options;
  String _log = '';
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
    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
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
    return randPiece(_state.piecesInLocation(PieceType.map, cup));
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

  List<Location> get candidateAttachLeaderSpaces {
    final candidates = <Location>[];
    final agricolaSpace = _state.pieceLocation(Piece.leaderAgricola);
    final connectedSpaces = _state.spaceAndConnectedSpaces(agricolaSpace);
    for (final legion in PieceType.mapLegion.pieces) {
      if (legion != _state.agricolaLegion) {
        final legionLocation = _state.pieceLocation(legion);
        if (!candidates.contains(legionLocation)) {
          if (connectedSpaces.contains(legionLocation)) {
            candidates.add(legionLocation);
          }
        }
      }
    }
    return candidates;
  }

  List<Location> get candidateReorganizeLegionSpaces {
    final candidates = <Location>[];
    final agricolaSpace = _state.pieceLocation(Piece.leaderAgricola);
    final connectedSpaces = _state.spaceAndConnectedSpaces(agricolaSpace);
    int legionCount = 0;
    for (final legion in PieceType.mapLegion.pieces) {
      final legionLocation = _state.pieceLocation(legion);
      if (connectedSpaces.contains(legionLocation)) {
        legionCount += 1;
        if (!candidates.contains(legionLocation)) {
          candidates.add(legionLocation);
        }
      }
    }
    if (legionCount <= 1) {
      return [];
    }
    return candidates;
  }

  List<Location> get candidateNegotiationSpaces {
    final candidates = <Location>[];
    final agricolaSpace = _state.pieceLocation(Piece.leaderAgricola);
    final agricolaRegion = _state.spaceRegion(agricolaSpace);
    if (agricolaRegion != null) {
      if (_state.regionActiveLeader(agricolaRegion) == null) {
        final spaces = _state.spaceAndAdjacentSpaces(agricolaSpace);
        for (final space in spaces) {
          if (space.isType(LocationType.tribe)) {
            final spaceRegion = _state.spaceRegion(space);
            if (spaceRegion == agricolaRegion) {
              if (_state.piecesInLocationCount(PieceType.mapTribe, space) >= 1) {
                candidates.add(space);
              }
            }
          }
        }
      }
    }
    return candidates;
  }

  List<Location> candidateLegionSuppressSpaces(Piece legion) {
    final candidates = <Location>[];
    final legionSpace = _state.pieceLocation(legion);
    final connectedSpaces = _state.spaceAndConnectedSpaces(legionSpace);
    for (final space in connectedSpaces) {
      if (space.isType(LocationType.tribe)) {
        final tribalCount = _state.piecesInLocationCount(PieceType.mapTribe, space);
        final leaderCount = _state.piecesInLocationCount(PieceType.mapLeader, space);
        if (leaderCount == 0 && tribalCount >= 1 && tribalCount <= 2) {
          candidates.add(space);
        }
      }
    }
    return candidates;
  }

  List<Location> candidateLegionGarrisonSpaces(Piece legion) {
    final candidates = <Location>[];
    final legionSpace = _state.pieceLocation(legion);
    final connectedSpaces = _state.spaceConnectedSpaces(legionSpace);
    for (final space in connectedSpaces) {
      if (space.isType(LocationType.tribe)) {
        if (_state.piecesInLocationCount(PieceType.mapTribe, space) == 0) {
          final region = _state.spaceRegion(space)!;
          if (_state.regionActiveLeader(region) == null) {
            candidates.add(space);
          }
        }
      }
    }
    return candidates;
  }

  List<Location> candidateLegionPeacekeepingSpaces(Piece legion) {
    final candidates = <Location>[];
    final legionSpace = _state.pieceLocation(legion);
    final connectedSpaces = _state.spaceAndConnectedSpaces(legionSpace);
    for (final space in connectedSpaces) {
      if (_state.piecesInLocationCount(PieceType.mapTribe, space) == 0) {
        final region = space.isType(LocationType.legionaryCamp) ? Region.blue : _state.spaceRegion(space)!;
        if (_state.regionActiveLeader(region) == null) {
          candidates.add(space);
        }
      }
    }
    if (_state.agricolaLegion == legion) {
      final firstConnectedSpaces = candidates.toList();
      for (final firstConnectedSpace in firstConnectedSpaces) {
        final secondConnectedSpaces = _state.spaceConnectedSpaces(firstConnectedSpace);
        for (final secondConnectedSpace in secondConnectedSpaces) {
          if (!candidates.contains(secondConnectedSpace)) {
            if (_state.piecesInLocationCount(PieceType.mapTribe, secondConnectedSpace) == 0) {
              final region = secondConnectedSpace.isType(LocationType.legionaryCamp) ? Region.blue : _state.spaceRegion(secondConnectedSpace)!;
              if (_state.regionActiveLeader(region) == null) {
                candidates.add(secondConnectedSpace);
              }
            }
          }
        }
      }
    }
    return candidates;
  }

  List<Location> candidateLegionBattleSpaces(Piece legion) {
    final candidates = <Location>[];
    final legionSpace = _state.pieceLocation(legion);
    final connectedSpaces = _state.spaceConnectedSpaces(legionSpace);
    for (final space in connectedSpaces) {
      if (space.isType(LocationType.tribe)) {
        if (_state.piecesInLocationCount(PieceType.mapTribe, space) >= 2) {
          candidates.add(space);
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

  void setupAgricola() {
    if (_state.currentTurn != 0) {
      return;
    }
    if (choicesEmpty()) {
      setPrompt('Select Legion to place Agricola with');
      for (final legion in PieceType.mapLegion.pieces) {
        pieceChoosable(legion);
      }
      throw PlayerChoiceException();
    }
    final legion = selectedPiece()!;
    final camp = _state.pieceLocation(legion);
    _state.setPieceLocation(Piece.leaderAgricola, camp);
    _state.agricolaLegion = legion;
    clearChoices();
  }

  void setupFriendlies() {
    if (_state.currentTurn != 0) {
      return;
    }
    if (_subStep == 0) {
      for (int i = 0; i < 4; ++i) {
        final piece = drawFromCup(Location.cupFriendly)!;
        _state.setPieceLocation(_state.pieceFlipSide(piece)!, Location.poolForce);
      }
      _subStep = 1;
    }
    while (_subStep == 1) {
      if (_state.piecesInLocationCount(PieceType.auxiliaryBlue, Location.poolForce) == 0) {
        return;
      }
      if (checkChoice(Choice.cancel)) {
        for (final box in LocationType.legionHolding.locations) {
          for (final auxiliary in _state.piecesInLocation(PieceType.auxiliaryBlue, box)) {
            _state.setPieceLocation(auxiliary, Location.poolForce);
          }
        }
        clearChoices();
        continue;
      }
      if (choicesEmpty()) {
        setPrompt('Select Blue Auxiliary to place');
        for (final auxiliary in _state.piecesInLocation(PieceType.auxiliaryBlue, Location.poolForce)) {
          pieceChoosable(auxiliary);
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      final auxiliary = selectedPiece()!;
      final box = selectedLocation();
      if (box == null) {
        setPrompt('Select Legion Holding Box for Auxiliary');
        for (final box in LocationType.legionHolding.locations) {
          locationChoosable(box);
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      _state.setPieceLocation(auxiliary, box);
      clearChoices();
    }
  }

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
  }

  void actionsPhaseActions() {
    while (true) {
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        _subStep = 0;
        continue;
      }
      if (_subStep == 0) {
        if (choicesEmpty()) {
          setPrompt('Select Action to perform');
          if (_state.legionActions > 0) {
            if (candidateAttachLeaderSpaces.isNotEmpty) {
              choiceChoosable(Choice.actionLeaderAttachLeader, true);
            }
            if (candidateReorganizeLegionSpaces.isNotEmpty) {
              choiceChoosable(Choice.actionLeaderReorganizeLegion, true);
            }
            if (candidateNegotiationSpaces.isNotEmpty) {
              choiceChoosable(Choice.actionLeaderNegotiation, true);
            }
            for (final legion in PieceType.mapLegion.pieces) {
              if (candidateLegionSuppressSpaces(legion).isNotEmpty) {
                choiceChoosable(Choice.actionLegionSuppress, true);
                break;
              }
            }
            for (final legion in PieceType.mapLegion.pieces) {
              if (candidateLegionGarrisonSpaces(legion).isNotEmpty) {
                choiceChoosable(Choice.actionLegionGarrison, true);
                break;
              }
            }
            for (final legion in PieceType.mapLegion.pieces) {
              if (candidateLegionPeacekeepingSpaces(legion).isNotEmpty) {
                choiceChoosable(Choice.actionLegionPeacekeeping, true);
                break;
              }
            }
            for (final legion in PieceType.mapLegion.pieces) {
              if (candidateLegionBattleSpaces(legion).isNotEmpty) {
                choiceChoosable(Choice.actionLegionBattle, true);
                break;
              }
            }
          }
          choiceChoosable(Choice.actionPass, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.actionPass)) {
          return;
        }
        if (checkChoiceAndClear(Choice.actionLeaderAttachLeader)) {
          _subStep = 1;
        } else if (checkChoiceAndClear(Choice.actionLeaderReorganizeLegion)) {
          _subStep = 2;
        }
      }

      if (_subStep == 1) { // Attach Leader
        if (choicesEmpty()) {
          setPrompt('Select Legion to Attach Agricola to');
          for (final space in candidateAttachLeaderSpaces) {
            for (final legion in _state.piecesInLocation(PieceType.mapLegion, space)) {
              if (legion != _state.agricolaLegion) {
                pieceChoosable(legion);
              }
            }
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        final legion = selectedPiece()!;
        logLine('### Attach Leader');
        logLine('> Agricola is Attached to ${legion.desc}.');
        _state.agricolaLegion = legion;
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 2) { // Reorganize Legion
        final legions = <Piece>[];
        for (final space in candidateReorganizeLegionSpaces) {
          for (final legion in _state.piecesInLocation(PieceType.mapLegion, space)) {
            legions.add(legion);
          }
        }
        if (choicesEmpty()) {
          
          
        }

      }
    }
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      setupAgricola,
      setupFriendlies,
      turnBegin,
      actionsPhaseBegin,
      actionsPhaseActions,
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

import 'dart:convert';
import 'dart:math';
import 'package:solitaire_caesar/db.dart';
import 'package:solitaire_caesar/random.dart';

enum Location {
  asia,
  carthage,
  cilicia,
  cisalpine,
  cyrene,
  egypt,
  gaul,
  greece,
  hispania,
  illyria,
  macedonia,
  mesopotamia,
  palestine,
  pontus,
  rhodes,
  rome,
  sicily,
  syria,
  thrace,
  albania,
  armenia,
  babylon,
  belgica,
  britain,
  dacia,
  mauretania,
  moesia,
  rhaetia,
  germania,
  theiss,
  arabia,
  berber,
  nord,
  parthia,
  steppe,
  track0,
  track1,
  track2,
  track3,
  track4,
  track5,
  track6,
  track7,
  track8,
  track9,
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
  offmap,
  notInPlay,
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
  province,
  provinceWildernessOrBetter,
  provinceRemoteOrBetter,
  provinceCivilized,
  provinceRemote,
  provinceWilderness,
  provinceWild,
  track,
  turn,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.province: [Location.asia, Location.steppe],
    LocationType.provinceWildernessOrBetter: [Location.asia, Location.theiss],
    LocationType.provinceRemoteOrBetter: [Location.asia, Location.rhaetia],
    LocationType.provinceCivilized: [Location.asia, Location.thrace],
    LocationType.provinceRemote: [Location.albania, Location.rhaetia],
    LocationType.provinceWilderness: [Location.germania, Location.theiss],
    LocationType.provinceWild: [Location.arabia, Location.steppe],
    LocationType.track: [Location.track0, Location.track9],
    LocationType.turn: [Location.turn1, Location.turn18],
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
      Location.asia: 'Asia',
      Location.carthage: 'Carthage',
      Location.cilicia: 'Cilica',
      Location.cisalpine: 'Cisalpine',
      Location.cyrene: 'Cyrene',
      Location.egypt: 'Egypt',
      Location.gaul: 'Gaul',
      Location.greece: 'Greece',
      Location.hispania: 'Hispania',
      Location.illyria: 'Illyria',
      Location.macedonia: 'Macedonia',
      Location.mesopotamia: 'Mesopotamia',
      Location.palestine: 'Palestine',
      Location.pontus: 'Pontus',
      Location.rhodes: 'Rhodes',
      Location.rome: 'Rome',
      Location.sicily: 'Sicily',
      Location.syria: 'Syria',
      Location.thrace: 'Thrace',
      Location.albania: 'Albania',
      Location.armenia: 'Armenia',
      Location.babylon: 'Babylon',
      Location.belgica: 'Belgica',
      Location.britain: 'Britain',
      Location.dacia: 'Dacia',
      Location.mauretania: 'Mauretania',
      Location.moesia: 'Moesia',
      Location.rhaetia: 'Rhaetia',
      Location.germania: 'Germania',
      Location.theiss: 'Theiss',
      Location.arabia: 'Arabia',
      Location.berber: 'Berber',
      Location.nord: 'Nord',
      Location.parthia: 'Parthia',
      Location.steppe: 'Steppe',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Piece {
  city0,
  city1,
  city2,
  city3,
  city4,
  city5,
  city6,
  city7,
  city8,
  city9,
  city10,
  city11,
  city12,
  city13,
  city14,
  city15,
  city16,
  city17,
  city18,
  city19,
  city20,
  city21,
  city22,
  city23,
  city24,
  city25,
  city26,
  city27,
  romanControl0,
  romanControl1,
  romanControl2,
  romanControl3,
  romanControl4,
  romanControl5,
  romanControl6,
  romanControl7,
  romanControl8,
  romanControl9,
  romanControl10,
  romanControl11,
  romanControl12,
  romanControl13,
  romanControl14,
  romanControl15,
  romanControl16,
  romanControl17,
  romanControl18,
  romanControl19,
  romanControl20,
  romanControl21,
  romanControl22,
  romanControl23,
  romanControl24,
  romanControl25,
  romanControl26,
  romanControl27,
  romanControl28,
  romanControl29,
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
  legion16,
  legion17,
  legion18,
  legion19,
  legion20,
  legion21,
  legion22,
  legion23,
  legion24,
  legion25,
  legion26,
  legion27,
  legion28,
  legion29,
  emperor,
  civilized0,
  civilized1,
  civilized2,
  civilized3,
  civilized4,
  civilized5,
  civilized6,
  civilized7,
  civilized8,
  civilized9,
  civilized10,
  civilized11,
  civilized12,
  civilized13,
  civilized14,
  civilized15,
  civilized16,
  civilized17,
  civilized18,
  civilized19,
  civilized20,
  civilized21,
  civilized22,
  civilized23,
  civilized24,
  civilized25,
  civilized26,
  civilized27,
  civilized28,
  civilized29,
  civilized30,
  civilized31,
  civilized32,
  civilized33,
  civilized34,
  civilized35,
  civilized36,
  civilized37,
  uncivilized0,
  uncivilized1,
  uncivilized2,
  uncivilized3,
  uncivilized4,
  uncivilized5,
  uncivilized6,
  uncivilized7,
  uncivilized8,
  uncivilized9,
  uncivilized10,
  uncivilized11,
  uncivilized12,
  uncivilized13,
  uncivilized14,
  uncivilized15,
  uncivilized16,
  uncivilized17,
  uncivilized18,
  uncivilized19,
  uncivilized20,
  uncivilized21,
  uncivilized22,
  uncivilized23,
  uncivilized24,
  uncivilized25,
  uncivilized26,
  uncivilized27,
  uncivilized28,
  uncivilized29,
  uncivilized30,
  uncivilized31,
  uncivilized32,
  uncivilized33,
  uncivilized34,
  uncivilized35,
  uncivilized36,
  uncivilized37,
  victoryPoints100,
  victoryPoints10,
  victoryPoints1,
  talents10,
  talents1,
  turn,
  skilledGeneral,
  capital,
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
  city,
  romanControl,
  legion,
  legionOrEmperor,
  barbarian,
  barbarianCivilized,
  barbarianUncivilized,
  marker,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.city0, Piece.capital],
    PieceType.city: [Piece.city0, Piece.city27],
    PieceType.romanControl: [Piece.romanControl0, Piece.romanControl29],
    PieceType.legion: [Piece.legion0, Piece.legion29],
    PieceType.legionOrEmperor: [Piece.legion0, Piece.emperor],
    PieceType.barbarian: [Piece.civilized0, Piece.uncivilized37],
    PieceType.barbarianCivilized: [Piece.civilized0, Piece.civilized37],
    PieceType.barbarianUncivilized: [Piece.uncivilized0, Piece.uncivilized37],
    PieceType.marker: [Piece.victoryPoints100, Piece.turn],
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
    if (isType(PieceType.legion)) {
      return 'Legion';
    }
    if (index == Piece.emperor.index) {
      return 'Emperor';
    }
    if (isType(PieceType.barbarianCivilized)) {
      return 'Civilized Barbarian';
    }
    if (isType(PieceType.barbarianUncivilized)) {
      return 'Uncivilized Barbarian';
    }
    if (isType(PieceType.city)) {
      return 'City';
    }
    return '';
  }

  bool isType(PieceType pieceType) {
    return index >= pieceType.firstIndex && index < pieceType.lastIndex;
  }
}

enum ProvinceType {
  civilized,
  remote,
  wilderness,
  wild,
}

enum ConnectionType {
  land,
  sea,
}

enum Scenario {
  campaign,
  riseAndFallOfTheWest,
  justiniansReconquest,
}

extension ScenarioExtension on Scenario {
  String get desc {
    const scenarioDescs = {
      Scenario.campaign: 'Campaign',
      Scenario.riseAndFallOfTheWest: 'Rise and Fall of the West',
      Scenario.justiniansReconquest: 'Justinian’s Reconquest',
    };
    return scenarioDescs[this]!;
  }

  String get longDesc {
    const scenarioDescs = {
      Scenario.campaign: 'Campaign (18 Turns)',
      Scenario.riseAndFallOfTheWest: 'Rise and Fall of the West (11 Turns)',
      Scenario.justiniansReconquest: 'Justinian’s Reconquest (1 Turn)'
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.offmap);

  GameState();

  GameState.fromJson(Map<String, dynamic> json) :
   _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']));

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
  };

  Location pieceLocation(Piece piece) {
    return _pieceLocations[piece.index];
  }

  void setPieceLocation(Piece piece, Location location) {
    _pieceLocations[piece.index] = location;
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

  // Provinces

  ProvinceType provinceType(Location province) {
    if (province.isType(LocationType.provinceCivilized)) {
      return ProvinceType.civilized;
    }
    if (province.isType(LocationType.provinceRemote)) {
      return ProvinceType.remote;
    }
    if (province.isType(LocationType.provinceWilderness)) {
      return ProvinceType.wilderness;
    }
    if (province.isType(LocationType.provinceWild)) {
      return ProvinceType.wild;
    }
    return ProvinceType.wild;
  }

  bool provinceFriendly(Location province) {
    if (piecesInLocationCount(PieceType.legionOrEmperor, province) > 0) {
      return true;
    }
    if (pieceInLocation(PieceType.romanControl, province) != null) {
      return true;
    }
    if (pieceLocation(Piece.capital) == province) {
      return true;
    }
    return false;
  }

  List<(Location, ConnectionType)> provinceConnections(Location province) {
    const connections = {
      Location.asia: [
        (Location.cilicia,ConnectionType.land),
        (Location.pontus,ConnectionType.land),
        (Location.rhodes,ConnectionType.sea),
        (Location.thrace,ConnectionType.sea),
      ],
      Location.carthage: [
        (Location.cyrene,ConnectionType.sea),
        (Location.sicily,ConnectionType.sea),
        (Location.mauretania,ConnectionType.land),
      ],
      Location.cilicia: [
        (Location.asia,ConnectionType.land),
        (Location.syria,ConnectionType.land),
      ],
      Location.cisalpine: [
        (Location.gaul,ConnectionType.land),
        (Location.hispania,ConnectionType.land),
        (Location.illyria,ConnectionType.land),
        (Location.rome,ConnectionType.land),
      ],
      Location.cyrene: [
        (Location.carthage,ConnectionType.sea),
        (Location.egypt,ConnectionType.land),
        (Location.rhodes,ConnectionType.sea),
      ],
      Location.egypt: [
        (Location.cyrene,ConnectionType.land),
        (Location.palestine,ConnectionType.land),
        (Location.arabia,ConnectionType.land),
      ],
      Location.gaul: [
        (Location.cisalpine,ConnectionType.land),
        (Location.hispania,ConnectionType.land),
        (Location.belgica,ConnectionType.land),
        (Location.britain,ConnectionType.sea),
      ],
      Location.greece: [
        (Location.macedonia,ConnectionType.land),
        (Location.rhodes,ConnectionType.sea),
        (Location.thrace,ConnectionType.land),
      ],
      Location.hispania: [
        (Location.cisalpine,ConnectionType.land),
        (Location.gaul,ConnectionType.land),
        (Location.mauretania,ConnectionType.sea),
      ],
      Location.illyria: [
        (Location.cisalpine,ConnectionType.land),
        (Location.macedonia,ConnectionType.land),
        (Location.dacia,ConnectionType.land),
        (Location.rhaetia,ConnectionType.land),
      ],
      Location.macedonia: [
        (Location.greece,ConnectionType.land),
        (Location.illyria,ConnectionType.land),
        (Location.moesia,ConnectionType.land),
      ],
      Location.mesopotamia: [
        (Location.syria,ConnectionType.land),
        (Location.albania,ConnectionType.land),
        (Location.babylon,ConnectionType.land),
      ],
      Location.palestine: [
        (Location.egypt,ConnectionType.land),
        (Location.syria,ConnectionType.land),
        (Location.arabia,ConnectionType.land),
      ],
      Location.pontus: [
        (Location.asia,ConnectionType.land),
        (Location.armenia,ConnectionType.land),
      ],
      Location.rhodes: [
        (Location.asia,ConnectionType.sea),
        (Location.cyrene,ConnectionType.sea),
        (Location.greece,ConnectionType.sea),
      ],
      Location.rome: [
        (Location.cisalpine,ConnectionType.land),
        (Location.sicily,ConnectionType.sea),
      ],
      Location.sicily: [
        (Location.carthage,ConnectionType.sea),
        (Location.rome,ConnectionType.sea),
      ],
      Location.syria: [
        (Location.cilicia,ConnectionType.land),
        (Location.mesopotamia,ConnectionType.land),
        (Location.palestine,ConnectionType.land),
        (Location.armenia,ConnectionType.land),
      ],
      Location.thrace: [
        (Location.asia,ConnectionType.sea),
        (Location.greece,ConnectionType.land),
      ],
      Location.albania: [
        (Location.mesopotamia,ConnectionType.land),
        (Location.armenia,ConnectionType.land),
        (Location.babylon,ConnectionType.land),
        (Location.parthia,ConnectionType.land),
      ],
      Location.armenia: [
        (Location.pontus,ConnectionType.land),
        (Location.syria,ConnectionType.land),
        (Location.albania,ConnectionType.land),
      ],
      Location.babylon: [
        (Location.mesopotamia,ConnectionType.land),
        (Location.albania,ConnectionType.land),
        (Location.parthia,ConnectionType.land),
      ],
      Location.belgica: [
        (Location.gaul,ConnectionType.land),
        (Location.britain,ConnectionType.sea),
        (Location.rhaetia,ConnectionType.land),
        (Location.germania,ConnectionType.land),
      ],
      Location.britain: [
        (Location.gaul,ConnectionType.sea),
        (Location.belgica,ConnectionType.sea),
      ],
      Location.dacia: [
        (Location.illyria,ConnectionType.land),
        (Location.moesia,ConnectionType.land),
        (Location.rhaetia,ConnectionType.land),
        (Location.theiss,ConnectionType.land),
      ],
      Location.mauretania: [
        (Location.carthage,ConnectionType.land),
        (Location.hispania,ConnectionType.sea),
        (Location.berber,ConnectionType.land),
      ],
      Location.moesia: [
        (Location.macedonia,ConnectionType.land),
        (Location.dacia,ConnectionType.land),
        (Location.steppe,ConnectionType.land),
      ],
      Location.rhaetia: [
        (Location.illyria,ConnectionType.land),
        (Location.belgica,ConnectionType.land),
        (Location.dacia,ConnectionType.land),
        (Location.germania,ConnectionType.land),
        (Location.theiss,ConnectionType.land),
      ],
      Location.germania: [
        (Location.belgica,ConnectionType.land),
        (Location.rhaetia,ConnectionType.land),
        (Location.nord,ConnectionType.land),
      ],
      Location.theiss: [
        (Location.dacia,ConnectionType.land),
        (Location.rhaetia,ConnectionType.land),
        (Location.steppe,ConnectionType.land),
      ],
      Location.arabia: [
        (Location.egypt,ConnectionType.land),
        (Location.palestine,ConnectionType.land),
      ],
      Location.berber: [
        (Location.mauretania,ConnectionType.land),
      ],
      Location.nord: [
        (Location.germania,ConnectionType.land),
      ],
      Location.parthia: [
        (Location.albania,ConnectionType.land),
        (Location.babylon,ConnectionType.land),
      ],
      Location.steppe: [
        (Location.moesia,ConnectionType.land),
        (Location.theiss,ConnectionType.land),
      ],
    };
    return connections[province]!;
  }

  ConnectionType provincesConnectionType(Location province0, Location province1) {
    final connections = provinceConnections(province0);
    for (final connection in connections) {
      if (connection.$1 == province1) {
        return connection.$2;
      }
    }
    return ConnectionType.sea;
  }

  List<Location> provinceConnectedProvinces(Location province) {
    final provinces = <Location>[];
    for (final connection in provinceConnections(province)) {
      provinces.add(connection.$1);
    }
    return provinces;
  }

  // Track

  Location trackBox(int value) {
    return Location.values[LocationType.track.firstIndex + value];
  }

  // Talents

  int get talents {
    return
     10 * (pieceLocation(Piece.talents10).index - LocationType.track.firstIndex) +
      1 * (pieceLocation(Piece.talents1).index - LocationType.track.firstIndex);
  }

  void adjustTalents(int amount) {
    int total = talents;
    total += amount;
    if (total < 0) {
      total = 0;
    } else if (total > 99) {
      total = 99;
    }
    setPieceLocation(Piece.talents10, trackBox(total ~/ 10));
    setPieceLocation(Piece.talents1, trackBox(total % 10));
  }

  int get victoryPoints {
    return
      100 * (pieceLocation(Piece.victoryPoints100).index - LocationType.track.firstIndex) +
       10 * (pieceLocation(Piece.victoryPoints10).index - LocationType.track.firstIndex) +
        1 * (pieceLocation(Piece.victoryPoints1).index - LocationType.track.firstIndex);
  }

  void adjustVictoryPoints(int amount) {
    int total = victoryPoints;
    total += amount;
    if (total < 0) {
      total = 0;
    } else if (total > 999) {
      total = 999;
    }
    setPieceLocation(Piece.victoryPoints100, trackBox(total ~/ 100));
    setPieceLocation(Piece.victoryPoints10, trackBox((total % 100) ~/ 10));
    setPieceLocation(Piece.victoryPoints1, trackBox(total % 10));
  }

  // Turns

  int get currentTurn {
    return pieceLocation(Piece.turn).index - LocationType.turn.firstIndex + 1;
  }

  Location get currentTurnBox {
    return pieceLocation(Piece.turn);
  }

  void advanceTurn() {
    setPieceLocation(Piece.turn, Location.values[pieceLocation(Piece.turn).index + 1]);
  }

  String turnName(int turn) {
    switch (turn) {
    case 1:
      return '300-201 BC (1)';
    case 2:
      return '200-101 BC (2)';
    case 3:
      return '100-1 BC (3)';
    case 4:
      return '1-100 AD (4)';
    case 5:
      return '101-200 AD (5)';
    case 6:
      return '201-300 AD (6)';
    case 7:
      return '301-400 AD (7)';
    case 8:
      return '401-500 AD (8)';
    case 9:
      return '501-600 AD (9)';
    case 10:
      return '601-700 AD (10)';
    case 11:
      return '701-800 AD (11)';
    case 12:
      return '801-900 AD (12)';
    case 13:
      return '901-1000 AD (13)';
    case 14:
      return '1001-1100 AD (14)';
    case 15:
      return '1101-1200 AD (15)';
    case 16:
      return '1201-1300 AD (16)';
    case 17:
      return '1301-1400 AD (17)';
    case 18:
      return '1401-1500 AD (18)';
    default:
      return '';
    }
  }

  Location turnWildProvince(int turn) {
    const wildProvinces = [
      Location.berber,
      Location.nord,
      Location.nord,
      Location.steppe,
      Location.nord,
      Location.steppe,
      Location.steppe,
      Location.nord,
      Location.steppe,
      Location.arabia,
      Location.berber,
      Location.arabia,
      Location.nord,
      Location.parthia,
      Location.arabia,
      Location.parthia,
      Location.parthia,
      Location.parthia,
    ];
    return wildProvinces[turn - 1];
  }

  bool newBarbariansCivilized(int turn, Location wildProvince) {
    const civilizedProvinces = [
      [Location.arabia, Location.berber, Location.parthia],
      [Location.arabia, Location.parthia],
      [Location.arabia, Location.parthia],
      [Location.arabia, Location.parthia],
      [Location.parthia],
      [Location.parthia],
      [Location.parthia],
      [Location.parthia],
      [Location.parthia],
      [Location.parthia],
      [Location.parthia],
      [Location.parthia],
      [Location.arabia, Location.berber, Location.parthia],
      [Location.arabia, Location.berber, Location.nord],
      [Location.arabia, Location.berber, Location.nord],
      [Location.arabia, Location.berber, Location.nord],
      [Location.arabia, Location.berber, Location.nord, Location.parthia],
      [Location.arabia, Location.berber, Location.nord, Location.parthia],
    ];
    return civilizedProvinces[turn - 1].contains(wildProvince);
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

  factory GameState.setupCampaign(GameOptions options) {

    var state = GameState();

    state.setupPieces([
      (Piece.city0, Location.rome),
      (Piece.romanControl0, Location.rome),
      (Piece.city1, Location.hispania),
      (Piece.city2, Location.cisalpine),
      (Piece.city3, Location.sicily),
      (Piece.city4, Location.carthage),
      (Piece.city5, Location.greece),
      (Piece.city6, Location.rhodes),
      (Piece.city7, Location.asia),
      (Piece.city8, Location.cilicia),
      (Piece.city9, Location.egypt),
      (Piece.city10, Location.syria),
      (Piece.city11, Location.palestine),
      (Piece.city12, Location.mesopotamia),
      (Piece.victoryPoints1, Location.track0),
      (Piece.victoryPoints10, Location.track0),
      (Piece.victoryPoints100, Location.track0),
      (Piece.talents1, Location.track0),
      (Piece.talents10, Location.track0),
      (Piece.turn, Location.turn1),
      (Piece.emperor, Location.notInPlay),
      (Piece.skilledGeneral, Location.notInPlay),
    ]);

    if (options.emperor) {
      state.setPieceLocation(Piece.emperor, Location.offmap);
    }
    if (options.skilledGeneral) {
      state.setPieceLocation(Piece.skilledGeneral, Location.offmap);
    }

    return state;
  }

  factory GameState.setupRiseAndFallOfTheWest(GameOptions options) {

    var state = GameState.setupCampaign(options);

    return state;
  }

  factory GameState.setupJustiniansReconquest(GameOptions options, Random random) {
    var state = GameState();

    final barbarians = <Piece>[];
    for (int i = 0; i < 9; ++i) {
      barbarians.add(Piece.values[PieceType.barbarianCivilized.firstIndex + i]);
      barbarians.add(Piece.values[PieceType.barbarianUncivilized.firstIndex + i]);
    }
    barbarians.shuffle(random);

    state.setupPieces([
      (Piece.legion0, Location.macedonia),
      (Piece.legion1, Location.macedonia),
      (Piece.legion2, Location.macedonia),
      (Piece.legion3, Location.macedonia),
      (Piece.legion4, Location.thrace),
      (Piece.legion5, Location.greece),
      (Piece.legion6, Location.rhodes),
      (Piece.legion7, Location.cyrene),
      (Piece.legion8, Location.egypt),
      (Piece.legion9, Location.palestine),
      (Piece.legion10, Location.syria),
      (Piece.legion11, Location.pontus),
      (Piece.legion12, Location.mesopotamia),
      (Piece.romanControl0, Location.cilicia),
      (Piece.romanControl1, Location.asia),
      (barbarians[0], Location.carthage),
      (barbarians[1], Location.cisalpine),
      (barbarians[2], Location.gaul),
      (barbarians[3], Location.hispania),
      (barbarians[4], Location.illyria),
      (barbarians[5], Location.rome),
      (barbarians[6], Location.sicily),
      (barbarians[7], Location.albania),
      (barbarians[8], Location.armenia),
      (barbarians[9], Location.babylon),
      (barbarians[10], Location.belgica),
      (barbarians[11], Location.britain),
      (barbarians[12], Location.dacia),
      (barbarians[13], Location.mauretania),
      (barbarians[14], Location.moesia),
      (barbarians[15], Location.rhaetia),
      (barbarians[16], Location.germania),
      (barbarians[17], Location.theiss),
      (Piece.city0, Location.rome),
      (Piece.city1, Location.sicily),
      (Piece.city2, Location.carthage),
      (Piece.city3, Location.cisalpine),
      (Piece.city4, Location.thrace),
      (Piece.city5, Location.greece),
      (Piece.city6, Location.rhodes),
      (Piece.city7, Location.cyrene),
      (Piece.city8, Location.egypt),
      (Piece.city0, Location.palestine),
      (Piece.city10, Location.syria),
      (Piece.city11, Location.cilicia),
      (Piece.city12, Location.asia),
      (Piece.city13, Location.pontus),
      (Piece.city14, Location.mesopotamia),
      (Piece.victoryPoints1, Location.track0),
      (Piece.victoryPoints10, Location.track0),
      (Piece.victoryPoints100, Location.track0),
      (Piece.talents1, Location.track0),
      (Piece.talents10, Location.track0),
      (Piece.turn, Location.turn9),
      (Piece.emperor, Location.notInPlay),
      (Piece.skilledGeneral, Location.notInPlay),
    ]);

    if (options.emperor) {
      state.setPieceLocation(Piece.emperor, Location.offmap);
    }
    if (options.skilledGeneral) {
      state.setPieceLocation(Piece.skilledGeneral, Location.offmap);
    }

    return state;
  }
}

enum Choice {
  raiseEmperor,
  promoteToEmperor,
  raiseLegion,
  buildCity,
  die1,
  die2,
  die3,
  die4,
  die5,
  die6,
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
  eliminated,
  endured,
}

class GameOutcome {
  GameResult result;
  int turn = 0;
  int score = 0;

  GameOutcome(this.result, this.turn, this.score);

  GameOutcome.fromJson(Map<String, dynamic> json) :
    result = GameResult.values[json['result'] as int],
    turn = json['turn'] as int,
    score = json['score'] as int;

  Map<String, dynamic> toJson() => {
    'result': result.index,
    'turn': turn,
    'score': score,
  };
}

class GameOverException implements Exception {
  GameOutcome outcome;

  GameOverException(GameResult result, int turn, int score) : outcome = GameOutcome(result, turn, score);
}

class GameOptions {
  bool smootherBarbarianNumbers = false;
  bool emperor = false;
  bool skilledGeneral = false;

  GameOptions();

  GameOptions.fromJson(Map<String, dynamic> json)
    : smootherBarbarianNumbers = json['smootherBarbarianNumbers'] as bool
    , emperor = json['emperor'] as bool
    , skilledGeneral = json['skilledGeneral'] as bool
    ;

  Map<String, dynamic> toJson() => {
    'smootherBarbarianNumbers': smootherBarbarianNumbers,
    'emperor': emperor,
    'skilledGeneral': skilledGeneral,
  };

  String get desc {
    String optionsList = '';
    if (smootherBarbarianNumbers) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Smoother Barbarian Numbers';
    }
    if (emperor) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'The Emperor';
    }
    if (skilledGeneral) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Skilled General';
    }
    return optionsList;
  }
}

enum Phase {
  roman,
  barbarian,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateRoman extends PhaseState {
  Piece? movingLegionOrEmperor;
  Location? toProvince;

  PhaseStateRoman();

  PhaseStateRoman.fromJson(Map<String, dynamic> json)
    : movingLegionOrEmperor = pieceFromIndex(json['movingLegionOrEmperor'])
    , toProvince = locationFromIndex(json['toProvince'])
    ;
  
  @override
  Map<String, dynamic> toJson() => {
    'movingLegionOrEmperor': pieceToIndex(movingLegionOrEmperor),
    'toProvince': locationToIndex(toProvince),
  };

  @override
  Phase get phase {
    return Phase.roman;
  }
}

class PhaseStateBarbarian extends PhaseState {
  List<Location> groupInitialProvinces = [];
  List<int> groupInitialCounts = [];
  List<bool> groupCivilizeds = [];
  int? currentGroupIndex;
  Location? currentGroupProvince;
  Location? currentGroupNextProvince;
  int? currentGroupCount;
  int? barbarianLossCount;
  int? legionLossCount;
  int? emperorLossCount;
  int? emperorRetreatCount;
  int? cityLossCount;
  List<Location> currentGroupTrailRaw = [];
  List<Location> currentGroupTrail = [];

  PhaseStateBarbarian();

  PhaseStateBarbarian.fromJson(Map<String, dynamic> json)
    : groupInitialProvinces = locationListFromIndices(List<int>.from(json['groupInitialProvinces']))
    , groupInitialCounts = List<int>.from(json['groupInitialCounts'])
    , groupCivilizeds = List<bool>.from(json['groupCivilizeds'])
    , currentGroupIndex = json['currentGroupIndex'] as int?
    , currentGroupProvince = locationFromIndex(json['currentGroupProvince'] as int?)
    , currentGroupNextProvince = locationFromIndex(json['currentGroupNextProvince'] as int?)
    , currentGroupCount = json['currentGroupCount'] as int?
    , barbarianLossCount = json['barbarianLossCount'] as int ?
    , legionLossCount = json['legionLossCount'] as int ?
    , emperorLossCount = json['emperorLossCount'] as int ?
    , emperorRetreatCount = json['emperorRetreatCount'] as int ?
    , cityLossCount = json['cityLossCount'] as int ?
    , currentGroupTrailRaw = locationListFromIndices(List<int>.from(json['currentGroupTrailRaw']))
    , currentGroupTrail = locationListFromIndices(List<int>.from(json['currentGroupTrail']))
    ;

  @override
  Map<String, dynamic> toJson() => {
    'groupInitialProvinces': locationListToIndices(groupInitialProvinces),
    'groupInitialCounts': groupInitialCounts,
    'groupCivilizeds': groupCivilizeds,
    'currentGroupIndex': currentGroupIndex,
    'currentGroupProvince': locationToIndex(currentGroupProvince),
    'currentGroupNextProvince': locationToIndex(currentGroupNextProvince),
    'currentGroupCount': currentGroupCount,
    'barbarianLossCount': barbarianLossCount,
    'legionLossCount': legionLossCount,
    'emperorLossCount': emperorLossCount,
    'emperorRetreatCount': emperorRetreatCount,
    'cityLossCount': cityLossCount,
    'currentGroupTrailRaw': locationListToIndices(currentGroupTrailRaw),
    'currentGroupTrail': locationListToIndices(currentGroupTrail),
  };

  @override
  Phase get phase {
    return Phase.barbarian;
  }

  void nextGroup() {
    if (currentGroupIndex != null) {
      currentGroupIndex = currentGroupIndex! + 1;
    } else {
      currentGroupIndex = 0;
    }
    if (currentGroupIndex! < groupInitialProvinces.length) {
      currentGroupProvince = groupInitialProvinces[currentGroupIndex!];
      currentGroupCount = groupInitialCounts[currentGroupIndex!];
      currentGroupTrailRaw = [currentGroupProvince!];
      currentGroupTrail = [currentGroupProvince!];
    }
  }
}

class SkilledGeneralRerollState {
  int? d6;

  SkilledGeneralRerollState();

  SkilledGeneralRerollState.fromJson(Map<String, dynamic> json)
    : d6 = json['d6'] as int?
    ;

  Map<String, dynamic> toJson() => {
    'd6': d6,
  };
}

class SkilledGeneralRelocateState {
  Location? location;

  SkilledGeneralRelocateState();

  SkilledGeneralRelocateState.fromJson(Map<String, dynamic> json)
    : location = locationFromIndex(json['location'] as int?)
    ;

  Map<String, dynamic> toJson() => {
    'location': locationToIndex(location),
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
  PlayerChoiceInfo _choiceInfo = PlayerChoiceInfo();
  PhaseState? _phaseState;
  SkilledGeneralRerollState? _skilledGeneralRerollState;
  SkilledGeneralRelocateState? _skilledGeneralRelocateState;
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
      case Phase.roman:
        _phaseState = PhaseStateRoman.fromJson(phaseStateJson);
      case Phase.barbarian:
        _phaseState = PhaseStateBarbarian.fromJson(phaseStateJson);
      }
    }

    final skilledGeneralRerollStateJson = json['skilledGeneralReroll'];
    if (skilledGeneralRerollStateJson != null) {
      _skilledGeneralRerollState = SkilledGeneralRerollState.fromJson(skilledGeneralRerollStateJson);
    }

    final skilledGeneralRelocateStateJson = json['skilledGeneralRelocate'];
    if (skilledGeneralRelocateStateJson != null) {
      _skilledGeneralRelocateState = SkilledGeneralRelocateState.fromJson(skilledGeneralRelocateStateJson);
    }

    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
    if (_phaseState != null) {
      map['phase'] = _phaseState!.phase.index;
      map['phaseState'] = _phaseState!.toJson();
    }
    if (_skilledGeneralRerollState != null) {
      map['skilledGeneralReroll'] = _skilledGeneralRerollState!.toJson();
    }
    if (_skilledGeneralRelocateState != null) {
      map['skilledGeneralRelocate'] = _skilledGeneralRelocateState!.toJson();
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

  String dieFaceCharacter(int die) {
    switch (die) {
    case 1:
      return '\u2680';
    case 2:
      return '\u2681';
    case 3:
      return '\u2682';
    case 4:
      return '\u2683';
    case 5:
      return '\u2684';
    case 6:
      return '\u2685';
    }
    return '';
  }

  int rollD6() {
    int die = _random.nextInt(6) + 1;
    logLine('> Roll: **${dieFaceCharacter(die)}**');
    return die;
  }

  (int,int,int) roll2D6() {
    int value = _random.nextInt(36);
    int d0 = value ~/ 6;
    value -= d0 * 6;
    int d1 = value;
    d0 += 1;
    d1 += 1;
    logLine('> Roll: **${dieFaceCharacter(d0)}${dieFaceCharacter(d1)}**');
    return (d0, d1, d0 + d1);
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

  Location randWildProvince() {
    int die = rollD6();
    switch (die) {
    case 1:
      return Location.nord;
    case 2:
    case 3:
      return Location.steppe;
    case 4:
      return Location.parthia;
    case 5:
      return Location.arabia;
    case 6:
      return Location.berber;
    default:
      return Location.rome;
    }
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

  void adjustTalents(int amount) {
    _state.adjustTalents(amount);
    if (amount > 0) {
      logLine('> Talents: +$amount => ${_state.talents}');
    } else {
      logLine('> Talents: $amount => ${_state.talents}');
    }
  }

  void adjustVictoryPoints(int amount) {
    _state.adjustVictoryPoints(amount);
    if (amount > 0) {
      logLine('> Victory Points: +$amount => ${_state.victoryPoints}');
    } else {
      logLine('> Victory Points: $amount => ${_state.victoryPoints}');
    }
  }

  // High-Level Functions

  List<Location> raiseEmperorProvinceCandidates(int budget) {
    final candidates = <Location>[];
    if (budget >= 1) {
      for (final province in [Location.rome, Location.thrace]) {
        if (_state.provinceFriendly(province)) {
          candidates.add(province);
        }
      }
    }
    return candidates;
  }

  List<Piece> promoteToEmperorLegionCandidates(int budget) {
    final candidates = <Piece>[];
    if (budget >= 1) {
      for (final legion in PieceType.legion.pieces) {
        if (_state.pieceLocation(legion) != Location.offmap) {
          candidates.add(legion);
        }
      }
    }
    return candidates;
  }

  List<Location> raiseLegionProvinceCandidates(int budget) {
    final candidates = <Location>[];
    if (budget >= 1) {
      for (final province in LocationType.provinceWildernessOrBetter.locations) {
        if (_state.provinceFriendly(province)) {
          candidates.add(province);
        }
      }
    }
    return candidates;
  }

  List<Piece> moveLegionCandidates() {
    final candidates = <Piece>[];
    for (final province in LocationType.provinceWildernessOrBetter.locations) {
      final legions = _state.piecesInLocation(PieceType.legion, province);
      if (legions.isNotEmpty) {
        candidates.add(legions[legions.length - 1]);
      }
    }
    if (_state.pieceLocation(Piece.emperor) != Location.offmap) {
      candidates.add(Piece.emperor);
    }
    return candidates;
  }

  List<Location> moveLegionDestinationCandidates(Piece legion) {
    final origin = _state.pieceLocation(legion);
    final candidates = <Location>[];
    var currentCandidates = [origin];
    var newCandidates = <Location>[];
    while (currentCandidates.isNotEmpty) {
      for (final currentProvince in currentCandidates) {
        for (final connectedProvince in _state.provinceConnectedProvinces(currentProvince)) {
          if (connectedProvince != origin && !connectedProvince.isType(LocationType.provinceWild)) {
            if (!candidates.contains(connectedProvince)) {
              bool friendly = _state.provinceFriendly(connectedProvince);
              if (legion != Piece.emperor || friendly) {
                candidates.add(connectedProvince);
              }
              if (friendly) {
                newCandidates.add(connectedProvince);
              }
            }
          }
        }
      }
      currentCandidates = newCandidates;
      newCandidates = <Location>[];
    }
    return candidates;
  }

  List<Location> buildCityProvinceCandidates(int budget) {
    final candidates = <Location>[];
    if (budget >= 2) {
      final locationType = budget >= 3 ? LocationType.provinceRemoteOrBetter : LocationType.provinceCivilized;
      for (final province in locationType.locations) {
        if (_state.provinceFriendly(province) && _state.pieceInLocation(PieceType.city, province) == null) {
          candidates.add(province);
        }
      }
    }
    return candidates;
  }

  List<Location> get emperorRetreatProvinceCandidates {
    final candidates = <Location>[];
    for (final connectedProvince in _state.provinceConnectedProvinces(_state.pieceLocation(Piece.emperor))) {
      if (_state.provinceFriendly(connectedProvince)) {
        candidates.add(connectedProvince);
      }
    }
    return candidates;
  }

  int barbarianMoveProvincePriority(Location province) {
    if (_state.provinceType(province) == ProvinceType.wild) {
      return 0;
    }
    final phaseState = _phaseState as PhaseStateBarbarian;
    int priority = 1;
    priority *= 2;
    // Prioritize non-barbarian or connected to non-barbarian
    if (_state.piecesInLocationCount(PieceType.barbarian, province) == 0) {
      priority += 1;
    } else {
      for (final connectedProvince in _state.provinceConnectedProvinces(province)) {
        if (_state.piecesInLocationCount(PieceType.barbarian, connectedProvince) == 0) {
          priority += 1;
          break;
        }
      }
    }
    priority *= 2;
    // Deprioritize visited or only connected to visited
    int newPriority = 0;
    if (!phaseState.currentGroupTrailRaw.contains(province)) {
      for (final connectedProvince in _state.provinceConnectedProvinces(province)) {
        if (!phaseState.currentGroupTrailRaw.contains(connectedProvince)) {
          newPriority = 1;
          break;
        }
      }
    }
    priority += newPriority;
    priority *= 2;
    // Retrace - prioritize visited
    priority += phaseState.currentGroupTrail.contains(province) ? 1 : 0;
    priority *= 8;
    // Prioritize least-visited.
    int revisitCount = max(7 - phaseState.currentGroupTrail.where((space) => space == province).length - 1, 0);
    priority += revisitCount;
    return priority;
  }

  void logBarbarianMove(int count, bool civilized, List<Location> path) {
    if (path.isEmpty) {
      return;
    }
    String pathDesc = '';
    if (path.length > 1) {
      pathDesc = 'through ';
      for (int i = 0; i + 1 < path.length; ++i) {
        if (i > 0) {
          if (i + 2 == path.length) {
            pathDesc += ' and ';
          } else {
            pathDesc += ',';
          }
        }
        pathDesc += path[i].desc;
      }
      pathDesc += ' ';
    }
    String civilizedDesc = civilized ? 'Civilized' : 'Uncivilized';
    String barbariansDesc = count > 1 ? 'Barbarians' : 'Barbarian';
    String moveDesc = count > 1 ? 'move' : 'moves';
    logLine('> $count $civilizedDesc $barbariansDesc $moveDesc ${pathDesc}to ${path[path.length - 1].desc}.');
  }

  void emperorLost() {
    for (final province in LocationType.province.locations) {
      final legions = _state.piecesInLocation(PieceType.legion, province);
      int lossCount = legions.length ~/ 2;
      if (lossCount > 0) {
        logLine('> $lossCount Legions are lost from ${province.desc}.');
        for (int i = 0; i < lossCount; ++i) {
          _state.setPieceLocation(legions[i], Location.offmap);
        }
      }
    }
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
    logLine('### Game Ends');
    if (outcome.result == GameResult.eliminated) {
      logLine('> Roman Empire is eliminated in ${_state.turnName(outcome.turn)}.');
    } else if (_scenario == Scenario.campaign) {
      logLine('> Roman Empire still exists in 1500 AD.');
    }
    if (_scenario == Scenario.justiniansReconquest) {
      logLine('> Province Score: ${outcome.score}');
    } else {
      logLine('> Victory Score: ${outcome.score}');
    }
    int level = 0;
    switch (_scenario) {
    case Scenario.campaign:
      if (outcome.score < 75) {
        level = 0;
      } else if (outcome.score < 125) {
        level = 1;
      } else if (outcome.score < 175) {
        level = 2;
      } else if (outcome.score <= 225) {
        level = 3;
      } else {
        level = 4;
      }
    case Scenario.riseAndFallOfTheWest:
      if (outcome.score < 50) {
        level = 0;
      } else if (outcome.score <= 79) {
        level = 1;
      } else if (outcome.score <= 120) {
        level = 2;
      } else if (outcome.score <= 140) {
        level = 3;
      } else {
        level = 4;
      }
    case Scenario.justiniansReconquest:
      if (outcome.score < 10) {
        level = 0;
      } else if (outcome.score <= 13) {
        level = 1;
      } else if (outcome.score <= 17) {
        level = 2;
      } else if (outcome.score <= 20) {
        level = 3;
      } else {
        level = 4;
      }
    }
    switch (level) {
    case 0:
      logLine('> Et tu Brute');
    case 1:
      logLine('> Bad');
    case 2:
      logLine('> Historical');
    case 3:
      logLine('> Good');
    case 4:
      logLine('> Veni Vidi Vinci');
    }
  }

  // Sequence Helpers

  int skilledGeneralRollD6() {
    if (!_options.skilledGeneral || _state.pieceLocation(Piece.skilledGeneral) == Location.offmap) {
      return rollD6();
    }
    if (_skilledGeneralRerollState == null) {
      _skilledGeneralRerollState = SkilledGeneralRerollState();
      _skilledGeneralRerollState!.d6 = rollD6();
    }
    final localState = _skilledGeneralRerollState!;
    if (choicesEmpty()) {
      final die = localState.d6!;
      setPrompt('Use Skilled General to Change die roll?');
      choiceChoosable(Choice.die1, die != 1);
      choiceChoosable(Choice.die2, die != 2);
      choiceChoosable(Choice.die3, die != 3);
      choiceChoosable(Choice.die4, die != 4);
      choiceChoosable(Choice.die5, die != 5);
      choiceChoosable(Choice.die6, die != 6);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    if (checkChoiceAndClear(Choice.no)) {
      final die = localState.d6!;
      _skilledGeneralRerollState = null;
      return die;
    }
    int die = localState.d6!;
    if (checkChoice(Choice.die1)) {
      die = 1;
    } else if (checkChoice(Choice.die2)) {
      die = 2;
    } else if (checkChoice(Choice.die3)) {
      die = 3;
    } else if (checkChoice(Choice.die4)) {
      die = 4;
    } else if (checkChoice(Choice.die5)) {
      die = 5;
    } else if (checkChoice(Choice.die6)) {
      die = 6;
    }
    clearChoices();
    logLine('> Skilled General changes roll from ${localState.d6!} to $die.');
    _state.setPieceLocation(Piece.skilledGeneral, Location.offmap);
    _skilledGeneralRerollState = null;
    return die;
  }

  Location? skilledGeneralRandLocation(List<Location> locations) {
    if (locations.isEmpty) {
      return null;
    }
    if (locations.length == 1) {
      return locations[0];
    }
    _skilledGeneralRelocateState ??= SkilledGeneralRelocateState();
    final localState = _skilledGeneralRelocateState!;
    Location? location = localState.location;
    if (location == null) {
      int choice = randInt(locations.length);
      location = locations[choice];
      localState.location = location;
    }
    if (!_options.skilledGeneral || _state.pieceLocation(Piece.skilledGeneral) == Location.offmap) {
      _skilledGeneralRelocateState = null;
      return location;
    }
    if (choicesEmpty()) {
      setPrompt('Use Skilled General to change Barbarian destination from ${location.desc}?');
      for (final otherLocation in locations) {
        if (otherLocation != location) {
          locationChoosable(otherLocation);
        }
      }
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    if (checkChoiceAndClear(Choice.no)) {
      _skilledGeneralRelocateState = null;
      return location;
    }
    final oldLocation = location;
    location = selectedLocation()!;
    clearChoices();
    logLine('> Skilled General defends ${oldLocation.desc}, forcing Barbarians into ${location.desc}.');
    _state.setPieceLocation(Piece.skilledGeneral, Location.offmap);
    _skilledGeneralRelocateState = null;
    return location;
  }

  Location determineBarbarianNextProvince() {
    final phaseState = _phaseState as PhaseStateBarbarian;
    final province = phaseState.currentGroupProvince!;
    final connectedProvinces = _state.provinceConnectedProvinces(province);
    int bestPriority = 0;
    var bestConnectedProvinces = <Location>[];
    for (final connectedProvince in  connectedProvinces) {
      int priority = barbarianMoveProvincePriority(connectedProvince);
      if (priority > bestPriority) {
        bestPriority = priority;
        bestConnectedProvinces = [connectedProvince];
      } else if (priority == bestPriority) {
        bestConnectedProvinces.add(connectedProvince);
      }
    }
    return skilledGeneralRandLocation(bestConnectedProvinces)!;
  }

  // Sequence of Play

  void turnBegin() {
    logLine('# ${_state.turnName(_state.currentTurn)}');
  }

  void romanPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Roman Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Roman Phase');
    _phaseState = PhaseStateRoman();
  }

  void romanPhaseRandomCity() {
    logLine('### Random City');
    final rolls = roll2D6();
    int d1 = rolls.$1;
    int d2 = rolls.$2;
    const randomCities = [
      Location.armenia,
      Location.gaul,
      Location.greece,
      Location.egypt,
      Location.asia,
      Location.egypt,
      Location.babylon,
      Location.hispania,
      Location.thrace,
      Location.palestine,
      Location.syria,
      Location.syria,
      Location.cyrene,
      Location.cisalpine,
      Location.rhodes,
      Location.syria,
      Location.mesopotamia,
      Location.asia,
      Location.mauretania,
      Location.rome,
      Location.asia,
      Location.mesopotamia,
      Location.cilicia,
      Location.greece,
      Location.illyria,
      Location.sicily,
      Location.pontus,
      Location.egypt,
      Location.cisalpine,
      Location.cisalpine,
      Location.macedonia,
      Location.carthage,
      Location.cilicia,
      Location.greece,
      Location.rome,
      Location.palestine,
    ];
    int index = (d2 - 1) * 6 + d1 - 1;
    final province = randomCities[index];
    if (_state.pieceInLocation(PieceType.city, province) != null) {
      logLine('> A City already exists in ${province.desc}.');
    } else {
      logLine('> A new City is founded in ${province.desc}.');
      final cities = _state.piecesInLocation(PieceType.city, Location.offmap);
      _state.setPieceLocation(cities[0], province);
    }
  }

  void romanPhaseSkilledGeneral() {
    if (!_options.skilledGeneral) {
      return;
    }
    logLine('### Skilled General');
    int die = rollD6();
    if (die >= 5) {
      logLine('> Rome has a Skilled General this turn.');
      _state.setPieceLocation(Piece.skilledGeneral, _state.currentTurnBox);
    } else {
      logLine('> No Skilled General is available this turn.');
    }
  }

  void romanPhaseIncome() {
    logLine('### Roman Income');
    const turnTalents = [
      5, 9, 12, 12, 8, 6, 6, 2, 8,
      2, 4, 6, 8, 6, 4, 2, 2, 1,
    ];
    int talents = turnTalents[_state.currentTurn - 1];
    if (_options.emperor && _state.currentTurn == 1) {
      talents -= 1;
      _state.setPieceLocation(Piece.emperor, Location.rome);
      final romanControl = _state.pieceInLocation(PieceType.romanControl, Location.rome)!;
      _state.setPieceLocation(romanControl, Location.offmap);
    }
    logLine('> Income: $talents Talents');
    _state.adjustTalents(talents);
  }

  void romanPhaseActions() {
    final phaseState = _phaseState as PhaseStateRoman;
    while (true) {
      if (_subStep == 0) {
        if (choicesEmpty()) {
          setPrompt('Select Legion to Move or Action to perform');
          for (final legion in moveLegionCandidates()) {
            pieceChoosable(legion);
          }
          if (_options.emperor && _state.pieceLocation(Piece.emperor) == Location.offmap) {
            if (raiseEmperorProvinceCandidates(1).isNotEmpty) {
              choiceChoosable(Choice.raiseEmperor, raiseEmperorProvinceCandidates(_state.talents).isNotEmpty);
            } else {
              choiceChoosable(Choice.promoteToEmperor, promoteToEmperorLegionCandidates(_state.talents).isNotEmpty);
            }
          } else if (_state.piecesInLocationCount(PieceType.legion, Location.offmap) > 0 && raiseLegionProvinceCandidates(1).isNotEmpty) {
            choiceChoosable(Choice.raiseLegion, raiseLegionProvinceCandidates(_state.talents).isNotEmpty);
          }
          if (_state.piecesInLocationCount(PieceType.city, Location.offmap) > 0 && buildCityProvinceCandidates(3).isNotEmpty) {
            choiceChoosable(Choice.buildCity, buildCityProvinceCandidates(_state.talents).isNotEmpty);
          }
          choiceChoosable(Choice.next, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.next)) {
          return;
        }
        if (checkChoiceAndClear(Choice.raiseEmperor)) {
          _subStep = 1;
        } else if (checkChoiceAndClear(Choice.promoteToEmperor)) {
          _subStep = 2;
        } else if (checkChoiceAndClear(Choice.raiseLegion)) {
          _subStep = 3;
        } else if (checkChoiceAndClear(Choice.buildCity)) {
          _subStep = 4;
        } else {
          _subStep = 5;
        }
      }

      if (_subStep == 1) {  // Raise Emperor
        if (choicesEmpty()) {
          setPrompt('Select Province to Raise Emperor Legion in');
          for (final province in raiseEmperorProvinceCandidates(_state.talents)) {
            locationChoosable(province);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final province = selectedLocation()!;
        logLine('### Raise Emperor in ${province.desc}.');
        adjustTalents(-1);
        _state.setPieceLocation(Piece.emperor, province);
        final control = _state.pieceInLocation(PieceType.romanControl, province);
        if (control != null) {
          _state.setPieceLocation(control, Location.offmap);
        }
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 2) { // Promote Legion to Emperor
        if (choicesEmpty()) {
          setPrompt('Select Legion to convert to Emperor');
          for (final legion in promoteToEmperorLegionCandidates(_state.talents)) {
            pieceChoosable(legion);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final legion = selectedPiece()!;
        final province = _state.pieceLocation(legion);
        logLine('### Convert Legion in ${province.desc} to Emperor.');
        _state.setPieceLocation(legion, Location.offmap);
        _state.setPieceLocation(Piece.emperor, province);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 3) {  // Raise Legion
        if (choicesEmpty()) {
          setPrompt('Select Province to Raise Legion in');
          for (final province in raiseLegionProvinceCandidates(_state.talents)) {
            locationChoosable(province);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final province = selectedLocation()!;
        logLine('### Raise Legion in ${province.desc}.');
        adjustTalents(-1);
        final legions = _state.piecesInLocation(PieceType.legion, Location.offmap);
        _state.setPieceLocation(legions[0], province);
        final control = _state.pieceInLocation(PieceType.romanControl, province);
        if (control != null) {
          _state.setPieceLocation(control, Location.offmap);
        }
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 4) { // Build City
        if (choicesEmpty()) {
          setPrompt('Select Province to Build City in');
          for (final province in buildCityProvinceCandidates(_state.talents)) {
            locationChoosable(province);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final province = selectedLocation()!;
        logLine('### Build City in ${province.desc}.');
        int cost = province.isType(LocationType.provinceCivilized) ? 2 : 3;
        adjustTalents(-cost);
        final cities = _state.piecesInLocation(PieceType.city, Location.offmap);
        _state.setPieceLocation(cities[0], province);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 5) { // Move Legion
        final legion = selectedPiece()!;
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          _subStep = 0;
          continue;
        }
        if (selectedLocation() == null) {
          setPrompt('Select destination Province for ${legion.desc}');
          for (final province in moveLegionDestinationCandidates(legion)) {
            locationChoosable(province);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        final fromProvince = _state.pieceLocation(legion);
        final toProvince = selectedLocation()!;
        phaseState.movingLegionOrEmperor = legion;
        phaseState.toProvince = toProvince;
        bool invade = !_state.provinceFriendly(toProvince);
        if (invade) {
          logLine('### ${legion.desc} moves from ${fromProvince.desc} to invade ${toProvince.desc}');
          final barbarian = _state.pieceInLocation(PieceType.barbarian, toProvince);
          final city = _state.pieceInLocation(PieceType.city, toProvince);
          if (barbarian == null) {
            if (city == null) {
              logLine('> Unoccupied');
            } else {
              logLine('> City');
            }
          } else {
            if (city == null) {
              logLine('> Barbarian');
            } else {
              logLine('> Barbarian and City');
            }
          }
        } else {
          logLine('### ${legion.desc} moves from ${fromProvince.desc} to ${toProvince.desc}');
        }
        _state.setPieceLocation(legion, toProvince);
        if (_state.piecesInLocationCount(PieceType.legionOrEmperor, fromProvince) == 0) {
          final controls = _state.piecesInLocation(PieceType.romanControl, Location.offmap);
          _state.setPieceLocation(controls[0], fromProvince);
        }
        clearChoices();
        if (invade) {
          _subStep = 6;
        } else {
          _subStep = 10;
        }
      }

      if (_subStep == 6) { // invade 1st combat
        final toProvince = phaseState.toProvince!;
        final barbarian = _state.pieceInLocation(PieceType.barbarian, toProvince);
        final city = _state.pieceInLocation(PieceType.city, toProvince);
        bool failed = true;
        if (barbarian == null) {
          if (city == null) {
            int die = skilledGeneralRollD6();
            failed = die >= 6;
          } else {
            int die = skilledGeneralRollD6();
            failed = die >= 5;
            if (!failed) {
              logLine('> City is captured.');
            }
          }
        } else {
          if (city == null) {
            int die = skilledGeneralRollD6();
            failed = die >= 4;
            if (!failed) {
              logLine('> Barbarian is eliminated.');
              _state.setPieceLocation(barbarian, Location.offmap);
            }
          } else {
            int die = skilledGeneralRollD6();
            failed = die >= 4;
            if (!failed) {
              logLine('> Barbarian is eliminated.');
              _state.setPieceLocation(barbarian, Location.offmap);
              _subStep = 7;
            }
          }
        }
        if (failed) {
          _subStep = 8;
        } else {
          _subStep = 9;
        }
      }
      if (_subStep == 7) { // invade 2nd combat
        int die = skilledGeneralRollD6();
        bool failed = die >= 5;
        if (!failed) {
          logLine('> City is captured.');
        }
        if (failed) {
          _subStep = 8;
        } else {
          _subStep = 9;
        }
      }
      if (_subStep == 8) { // invasion failed
        final legion = phaseState.movingLegionOrEmperor!;
        final toProvince = phaseState.toProvince!;
        logLine('> Legion is eliminated.');
        _state.setPieceLocation(legion, Location.offmap);
        logLine('> ${toProvince.desc} remains Hostile.');
        _subStep = 10;
      }
      if (_subStep == 9) { // invasion successful
        final toProvince = phaseState.toProvince!;
        logLine('> ${toProvince.desc} becomes Friendly.');
        final control = _state.pieceInLocation(PieceType.romanControl, toProvince);
        if (control != null) {
          _state.setPieceLocation(control, Location.offmap);
        }
        _subStep = 10;
      }
      if (_subStep == 10) { // Move complete
        phaseState.movingLegionOrEmperor = null;
        phaseState.toProvince = null;
        _subStep = 0;
      }
    }
  }

  void romanPhaseEnd() {
    _phaseState = null;
  }

  void barbarianPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Barbarian Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Barbarian Phase');
    _phaseState = PhaseStateBarbarian();
  }

  void barbarianPhaseGenerateNewBarbarianArmyGroups() {
    final phaseState = _phaseState as PhaseStateBarbarian;
    logLine('### New Barbarian Army Groups');
    if (_scenario != Scenario.justiniansReconquest) {
      int g1;
      int g2;
      if (_options.smootherBarbarianNumbers) {
        const groupNumbers = [
          [6, 4],
          [5, 3],
          [5, 3],
          [4, 2],
          [4, 2],
          [3, 1],
        ];
        int die = rollD6();
        g1 = groupNumbers[die - 1][0];
        g2 = groupNumbers[die - 1][1];
      } else {
        final rolls = roll2D6();
        int d1 = rolls.$1;
        int d2 = rolls.$2;
        g1 = max(d1, d2);
        g2 = min(d1, d2);
      }
      phaseState.groupInitialCounts.add(g1);
      phaseState.groupInitialProvinces.add(_state.turnWildProvince(_state.currentTurn));
      phaseState.groupCivilizeds.add(_state.newBarbariansCivilized(_state.currentTurn, phaseState.groupInitialProvinces[0]));
      phaseState.groupInitialCounts.add(g2);
      phaseState.groupInitialProvinces.add(randWildProvince());
      phaseState.groupCivilizeds.add(_state.newBarbariansCivilized(_state.currentTurn, phaseState.groupInitialProvinces[1]));
    } else {
      phaseState.groupInitialCounts.addAll([4,3,2,1]);
      phaseState.groupInitialProvinces.addAll([Location.nord,Location.steppe,Location.berber,Location.parthia]);
      phaseState.groupCivilizeds.addAll([true,false,true,true]);
    }
    for (int i = 0; i < phaseState.groupInitialCounts.length; ++i) {
      String civilizedDesc = phaseState.groupCivilizeds[i] ? 'Civilized' : 'Uncivilized';
      logLine('> ${phaseState.groupInitialCounts[i]} $civilizedDesc Barbarians issue forth from ${phaseState.groupInitialProvinces[i].desc}.');
    }
  }

  void barbarianPhaseMoveBarbarianArmyGroup() {
    final phaseState = _phaseState as PhaseStateBarbarian;
    if (_subStep == 0) {
      if (phaseState.currentGroupIndex == phaseState.groupInitialCounts.length) {
        return;
      }
      phaseState.nextGroup();
      if (phaseState.currentGroupIndex == phaseState.groupInitialCounts.length) {
        return;
      }
    }
    int groupIndex = phaseState.currentGroupIndex!;
    final barbarianPieceType = phaseState.groupCivilizeds[groupIndex] ? PieceType.barbarianCivilized : PieceType.barbarianUncivilized;
    if (_subStep == 0) {
      String civilizedDesc = barbarianPieceType == PieceType.barbarianCivilized ? 'Civilized' : 'Uncivilized';
      logLine('### Move ${phaseState.groupInitialCounts[groupIndex]} $civilizedDesc Barbarians in ${phaseState.currentGroupProvince!.desc}.');
      _subStep = 1;
    }
    final barbarians = <Piece>[];
    if (phaseState.currentGroupProvince!.isType(LocationType.provinceWild)) {
      final offmapBarbarians = _state.piecesInLocation(barbarianPieceType, Location.offmap);
      for (int i = 0; i < phaseState.currentGroupCount!; ++i) {
        barbarians.add(offmapBarbarians[i]);
      }
      for (final barbarian in barbarians) {
        _state.setPieceLocation(barbarian, phaseState.currentGroupProvince!);
      }
    } else {
      final provinceBarbarians = _state.piecesInLocation(barbarianPieceType, phaseState.currentGroupProvince!);
      for (int i = 0; i < phaseState.currentGroupCount!; ++i) {
        barbarians.add(provinceBarbarians[i]);
      }
    }
    var logPath = <Location>[];
    while (_subStep < 12) {
      if (_subStep == 1) {  // Potentially leave 1 Barbarian in current province
        final fromProvince = phaseState.currentGroupProvince!;
        if (_state.provinceType(fromProvince) != ProvinceType.wild && _state.pieceInLocation(PieceType.barbarian, fromProvince) == null) {
          barbarians.removeLast();
          logLine('> Barbarians occupy ${fromProvince.desc}');
          phaseState.currentGroupCount = barbarians.length;
        }
        if (barbarians.isEmpty) {
          _subStep = 12;
          break;
        }
        _subStep = 2;
      }
      if (_subStep == 2) {
        final nextProvince = determineBarbarianNextProvince();
        phaseState.currentGroupNextProvince = nextProvince;
        phaseState.currentGroupTrailRaw.add(nextProvince);
        if (phaseState.currentGroupTrail.length >= 2 && phaseState.currentGroupTrail[phaseState.currentGroupTrail.length - 2] == nextProvince) {
          phaseState.currentGroupTrail.removeLast();
        } else {
          phaseState.currentGroupTrail.add(nextProvince);
        }
        logPath.add(nextProvince);
        final otherBarbarian = _state.pieceInLocation(PieceType.barbarian, nextProvince);
        if (otherBarbarian == null) {
          _subStep = 3;
        } else {
          _subStep = 11;
        }
      }
      if (_subStep == 3) { // Advance into non-Barbarian province
        final nextProvince = phaseState.currentGroupNextProvince!;
        logBarbarianMove(barbarians.length, barbarianPieceType == PieceType.barbarianCivilized, logPath);
        logPath.clear();
        final legions = _state.piecesInLocation(PieceType.legion, nextProvince);
        int emperorCount = _state.pieceLocation(Piece.emperor) == nextProvince ? 1 : 0;
        final city = _state.pieceInLocation(PieceType.city, nextProvince);
        if (legions.isNotEmpty || emperorCount > 0 || city != null) {
          phaseState.barbarianLossCount = 0;
          phaseState.legionLossCount = 0;
          phaseState.emperorLossCount = 0;
          phaseState.emperorRetreatCount = 0;
          phaseState.cityLossCount = 0;
          if (legions.isNotEmpty || emperorCount > 0) {
            _subStep = 4;
          } else {
            _subStep = 7;
          }
        } else {
          for (final barbarian in barbarians) {
            _state.setPieceLocation(barbarian, nextProvince);
          }
          barbarians.removeLast();
          logLine('> Barbarians occupy ${nextProvince.desc}');
          phaseState.currentGroupCount = barbarians.length;
          _subStep = 10;
        }
      }
      if (_subStep == 4) { // Legion / Emperor defense
        final nextProvince = phaseState.currentGroupNextProvince!;
        final legions = _state.piecesInLocation(PieceType.legion, nextProvince);
        if (legions.isNotEmpty) {
          logLine('> Legion defense.');
        } else {
          logLine('> Emperor defense.');
        }
        _subStep = 5;
      }
      if (_subStep == 5) { // Legion / Emperor defense roll
        final fromProvince = phaseState.currentGroupProvince!;
        final nextProvince = phaseState.currentGroupNextProvince!;
        bool seaConnection = _state.provincesConnectionType(fromProvince, nextProvince) == ConnectionType.sea;
        final legions = _state.piecesInLocation(PieceType.legion, nextProvince);
        int emperorCount = _state.pieceLocation(Piece.emperor) == nextProvince ? 1 : 0;
        int barbarianLossCount = phaseState.barbarianLossCount!;
        int legionLossCount = phaseState.legionLossCount!;
        int emperorLossCount = phaseState.emperorLossCount!;
        int emperorRetreatCount = phaseState.emperorRetreatCount!;
        while (barbarians.length > barbarianLossCount && (legions.length > legionLossCount || emperorCount > emperorLossCount + emperorRetreatCount)) {
          int die = skilledGeneralRollD6();
          if (seaConnection) {
            die -= 1;
          }
          if (die <= 3) {
            barbarianLossCount += 1;
          } else if (legionLossCount < legions.length) {
            legionLossCount += 1;
          } else if (die == 6) {
            emperorLossCount += 1;
          } else if (die == 5) {
            emperorRetreatCount += 1;
          } else {
            // No effect, see designer's responses on BGG
          }
          phaseState.barbarianLossCount = barbarianLossCount;
          phaseState.legionLossCount = legionLossCount;
          phaseState.emperorLossCount = emperorLossCount;
          phaseState.emperorRetreatCount = emperorRetreatCount;
        }
        if (legionLossCount > 0) {
          logLine('> $legionLossCount Legions are lost defending ${nextProvince.desc}.');
          for (int i = 0; i < legionLossCount; ++i) {
            _state.setPieceLocation(legions.removeLast(), Location.offmap);
          }
        }
        if (emperorRetreatCount > 0) {
          final candidateProvinces = emperorRetreatProvinceCandidates;
          if (candidateProvinces.isEmpty) {
            emperorRetreatCount = 0;
            emperorLossCount = 1;
          }
        }
        if (emperorLossCount > 0) {
          logLine('> Emperor is lost defending ${nextProvince.desc}.');
          _state.setPieceLocation(Piece.emperor, Location.offmap);
          emperorLost();
        }
        if (legions.isEmpty && emperorLossCount + emperorRetreatCount >= emperorCount) {
          final controls = _state.piecesInLocation(PieceType.romanControl, Location.offmap);
          _state.setPieceLocation(controls[0], nextProvince);
        }
        phaseState.barbarianLossCount = barbarianLossCount;
        phaseState.legionLossCount = legionLossCount;
        phaseState.emperorLossCount = emperorLossCount;
        phaseState.emperorRetreatCount = emperorRetreatCount;
        if (emperorRetreatCount > 0) {
          _subStep = 6;
        } else {
          _subStep = 7;
        }
      }
      if (_subStep == 6) { // Emperor retreat
        if (choicesEmpty()) {
          setPrompt('Select province to retreat Emperor to');
          for (final province in emperorRetreatProvinceCandidates) {
            locationChoosable(province);
          }
          throw PlayerChoiceException();
        }
        final retreatProvince = selectedLocation()!;
        logLine('> Emperor retreats to ${retreatProvince.desc}.');
        _state.setPieceLocation(Piece.emperor, retreatProvince);
        _subStep = 7;
      }
      if (_subStep == 7) { // City defense
        final nextProvince = phaseState.currentGroupNextProvince!;
        int barbarianLossCount = phaseState.barbarianLossCount!;
        final city = _state.pieceInLocation(PieceType.city, nextProvince);
        if (barbarians.length > barbarianLossCount && city != null) {
          logLine('> City defense.');
        }
        _subStep = 8;
      }
      if (_subStep == 8) { // City defense roll
        final fromProvince = phaseState.currentGroupProvince!;
        final nextProvince = phaseState.currentGroupNextProvince!;
        bool seaConnection = _state.provincesConnectionType(fromProvince, nextProvince) == ConnectionType.sea;
        int barbarianLossCount = phaseState.barbarianLossCount!;
        int cityLossCount = phaseState.cityLossCount!;
        final city = _state.pieceInLocation(PieceType.city, nextProvince);
        if (barbarians.length > barbarianLossCount && city != null) {
          while (barbarians.length > barbarianLossCount && cityLossCount == 0) {
            int die = skilledGeneralRollD6();
            if (seaConnection) {
              die -= 1;
            }
            if (die == 1) {
              barbarianLossCount += 1;
            } else {
              cityLossCount += 1;
              logLine('> City in ${nextProvince.desc} falls to the Barbarians.');
            }
            phaseState.barbarianLossCount = barbarianLossCount;
            phaseState.cityLossCount = cityLossCount;
          }
          phaseState.barbarianLossCount = barbarianLossCount;
          phaseState.cityLossCount = cityLossCount;
        }
        _subStep = 9;
      }
      if (_subStep == 9) { // Complete combat
        final nextProvince = phaseState.currentGroupNextProvince!;
        final city = _state.pieceInLocation(PieceType.city, nextProvince);
        int barbarianLossCount = phaseState.barbarianLossCount!;
        if (barbarianLossCount > 0) {
          logLine('> $barbarianLossCount Barbarians are lost attacking ${nextProvince.desc}.');
          for (int i = 0; i < barbarianLossCount; ++i) {
            _state.setPieceLocation(barbarians.removeLast(), Location.offmap);
          }
        }
        if (barbarians.isEmpty) {
          logLine('> ${nextProvince.desc} withstands the Barbarian attack.');
        } else {
          logLine('> ${nextProvince.desc} falls to the Barbarians.');
          final control = _state.pieceInLocation(PieceType.romanControl, nextProvince);
          if (control != null) {
            _state.setPieceLocation(control, Location.offmap);
          }
          if (city != null && barbarianPieceType == PieceType.barbarianUncivilized) {
            logLine('> City in ${nextProvince.desc} is abandoned.');
            _state.setPieceLocation(city, Location.offmap);
          }
          for (final barbarian in barbarians) {
            _state.setPieceLocation(barbarian, nextProvince);
          }
          barbarians.removeLast();
          logLine('> Barbarians occupy ${nextProvince.desc}');
        }
        _subStep = 10;
        logLine('>');
        phaseState.barbarianLossCount = null;
        phaseState.legionLossCount = null;
        phaseState.emperorLossCount = null;
        phaseState.emperorRetreatCount = null;
        phaseState.cityLossCount = null;
        phaseState.currentGroupCount = barbarians.length;
      }
      if (_subStep == 10) { // Prompt
        if (choicesEmpty()) {
          setPrompt('Proceed');
          choiceChoosable(Choice.next, true);
          throw PlayerChoiceException();
        }
        clearChoices();
        if (barbarians.isEmpty) {
          return;
        }
        _subStep = 11;
      }
      if (_subStep == 11) { // Province move complete
        phaseState.currentGroupProvince = phaseState.currentGroupNextProvince;
        phaseState.currentGroupNextProvince = null;
        _subStep = 1;
      }
    }
    if (_subStep == 12) {
      if (choicesEmpty()) {
        setPrompt('Proceed');
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
    }
    clearChoices();
  }

  void barbarianPhaseEnd() {
    _phaseState = null;
  }

  void tallyScorePhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Tally Score Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Tally Score Phase');
  }

  void tallyScorePhaseTallyScore() {
    logLine('### Turn Score');
    int count = 0;
    if (_scenario != Scenario.justiniansReconquest) {
      for (final city in PieceType.city.pieces) {
        final location = _state.pieceLocation(city);
        if (location.isType(LocationType.province) && _state.provinceFriendly(location)) {
          logLine('> ${location.desc}');
          count += 1;
        }
      }
    } else {
      const scoringProvinces = [
        Location.macedonia,
        Location.thrace,
        Location.greece,
        Location.rhodes,
        Location.cyrene,
        Location.egypt,
        Location.palestine,
        Location.syria,
        Location.pontus,
        Location.mesopotamia,
        Location.cilicia,
        Location.asia,
        Location.carthage,
        Location.sicily,
        Location.rome,
        Location.cisalpine,
        Location.hispania,
        Location.gaul,
        Location.illyria,
        Location.belgica,
        Location.rhaetia,
        Location.britain,
      ];
      for (final province in scoringProvinces) {
        if (_state.provinceFriendly(province)) {
          logLine('> ${province.desc}');
          count += 1;
        }
      }
    }
    logLine('> Score: $count');
    adjustVictoryPoints(count);
  }

  void tallyScorePhaseGameEnd() {
    for (final province in LocationType.province.locations) {
      if (_state.provinceFriendly(province)) {
        int finalTurn = 0;
        switch (_scenario) {
        case Scenario.campaign:
          finalTurn = LocationType.turn.count;
        case Scenario.riseAndFallOfTheWest:
          finalTurn = 8;
        case Scenario.justiniansReconquest:
          finalTurn = 9;
        }
        if (_state.currentTurn == finalTurn) {
          throw GameOverException(GameResult.endured, _state.currentTurn, _state.victoryPoints);
        }
        return;
      }
    }
    throw GameOverException(GameResult.eliminated, _state.currentTurn, _state.victoryPoints);
  }

  void tallyScorePhaseAdvanceTurn() {
    if (_options.skilledGeneral) {
      _state.setPieceLocation(Piece.skilledGeneral, Location.offmap);
    }
    _state.advanceTurn();
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      romanPhaseBegin,
      romanPhaseRandomCity,
      romanPhaseSkilledGeneral,
      romanPhaseIncome,
      romanPhaseActions,
      romanPhaseEnd,
      barbarianPhaseBegin,
      barbarianPhaseGenerateNewBarbarianArmyGroups,
      barbarianPhaseMoveBarbarianArmyGroup,
      barbarianPhaseMoveBarbarianArmyGroup,
      barbarianPhaseMoveBarbarianArmyGroup,
      barbarianPhaseMoveBarbarianArmyGroup,
      barbarianPhaseEnd,
      tallyScorePhaseBegin,
      tallyScorePhaseTallyScore,
      tallyScorePhaseGameEnd,
      tallyScorePhaseAdvanceTurn,
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

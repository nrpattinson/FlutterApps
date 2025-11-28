import 'dart:convert';
import 'dart:math';
import 'package:empire_of_grass/db.dart';
import 'package:empire_of_grass/random.dart';

enum Location {
  map00,
  map01PolishTeuton,
  map02Novgorod,
  map03,
  map04,
  map05,
  map06,
  map07,
  map08,
  map10Europe,
  map11PonticSteppe,
  map12Rus,
  map13VolgaBulgar,
  map14Bashkir,
  map15,
  map16KhoriTumet,
  map17,
  map18,
  map20Anatolia,
  map21Caucasus,
  map22CaspianSteppe,
  map23Kirghiz,
  map24Kipchak,
  map25Naiman,
  map26Mongolia,
  map27Tatar,
  map28,
  map30HolyLand,
  map31Azerbaijan,
  map32Merv,
  map33Bukhara,
  map34Dzungaria,
  map35Uyghur,
  map36Gobi,
  map37Jurchen,
  map38Korea,
  map40,
  map41Tigris,
  map42Persia,
  map43Afghanistan,
  map44Karakhitai,
  map45Taklaman,
  map46WesternXia,
  map47JinChina,
  map48Japan,
  map50,
  map51,
  map52,
  map53Indus,
  map54,
  map55Tibet,
  map56Dali,
  map57SongChina,
  map58,
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
  turn20,
  turn21,
  poolGold,
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
  map,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.map: [Location.map00, Location.map58],
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

enum Piece {
  cardMongolia,
  cardKhoriTumet,
  cardTatar,
  cardJurchen,
  cardGobi,
  cardNaiman,
  cardUyghur,
  cardKipchak,
  cardDzungaria,
  cardTaklamakan,
  cardWesternXia,
  cardBashkir,
  cardKirghiz,
  cardVolgaBulgar,
  cardCaspianSteppe,
  cardTibet,
  cardJinChina,
  cardBukhara,
  cardKarakhitai,
  cardMerv,
  cardRus,
  cardPonticSteppe,
  cardCaucasus,
  cardDali,
  cardNovgorod,
  cardPolishTeuton,
  cardAzerbaijan,
  cardPersia,
  cardIndus,
  cardSongChina,
  cardKorea,
  cardJapan,
  cardAfghanistan,
  cardTigris,
  cardEurope,
  cardAnatolia,
  cardHolyLand,
  mongolLightCavalry0,
  mongolLightCavalry1,
  mongolLightCavalry2,
  mongolHeavyCavalry0,
  mongolHeavyCavalry1,
  mongolHeavyCavalry2,
  khan,
  siegeEngine0,
  siegeEngine1,
  siegeEngine2,
  goldenHordeLightCavalry0,
  goldenHordeLightCavalry1,
  goldenHordeHeavyCavalry0,
  alliedRedLightCavalry0,
  alliedRedLightCavalry1,
  alliedRedLightCavalry2,
  alliedRedHeavyCavalry0,
  alliedRedHeavyCavalry1,
  alliedYellowLightCavalry0,
  alliedYellowLightCavalry1,
  alliedYellowLightCavalry2,
  alliedYellowHeavyCavalry0,
  alliedYellowHeavyCavalry1,
  alliedBlueLightCavalry0,
  alliedBlueLightCavalry1,
  alliedBlueLightCavalry2,
  alliedBlueHeavyCavalry0,
  alliedBlueHeavyCavalry1,
  enemyLightCavalry1_0,
  enemyLightCavalry1_1,
  enemyLightCavalry1_2,
  enemyLightCavalry1_3,
  enemyLightCavalry2_0,
  enemyLightCavalry2_1,
  enemyLightCavalry2_2,
  enemyLightCavalry2_3,
  enemyHeavyCavalry1_0,
  enemyHeavyCavalry1_1,
  enemyHeavyCavalry1_2,
  enemyHeavyCavalry2_0,
  enemyHeavyCavalry2_1,
  enemyHeavyCavalry2_2,
  enemyRedLightCavalry0,
  enemyRedLightCavalry1,
  enemyRedLightCavalry2,
  enemyRedHeavyCavalry0,
  enemyRedHeavyCavalry1,
  enemyYellowLightCavalry0,
  enemyYellowLightCavalry1,
  enemyYellowLightCavalry2,
  enemyYellowHeavyCavalry0,
  enemyYellowHeavyCavalry1,
  enemyBlueLightCavalry0,
  enemyBlueLightCavalry1,
  enemyBlueLightCavalry2,
  enemyBlueHeavyCavalry0,
  enemyBlueHeavyCavalry1,
  enemyInfantry1_0,
  enemyInfantry1_1,
  enemyInfantry1_2,
  enemyInfantry1_3,
  enemyInfantry1_4,
  enemyInfantry1_5,
  enemyInfantry1_6,
  enemyInfantry1_7,
  enemyInfantry1_8,
  enemyInfantry1_9,
  enemyInfantry1_10,
  enemyInfantry1_11,
  enemyInfantry1_12,
  enemyInfantry2_0,
  enemyInfantry2_1,
  enemyInfantry2_2,
  enemyInfantry2_3,
  enemyInfantry2_4,
  enemyInfantry2_5,
  enemyInfantry2_6,
  enemyInfantry2_7,
  enemyInfantry2_8,
  enemyInfantry2_9,
  enemyInfantry2_10,
  enemyInfantry2_11,
  enemyInfantry2_12,
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
  razed0,
  razed1,
  razed2,
  razed3,
  razed4,
  razed5,
  razed6,
  razed7,
  razed8,
  razed9,
  razed10,
  razed11,
  razed12,
  razed13,
  razed14,
  razed15,
  razed16,
  razed17,
  razed18,
  razed19,
  razed20,
  razed21,
  razed22,
  razed23,
  siege0,
  siege1,
  siege2,
  siege3,
  gold1_0,
  gold1_1,
  gold1_2,
  gold1_3,
  gold1_4,
  gold2_0,
  gold2_1,
  gold2_2,
  gold2_3,
  gold2_4,
  gold5_0,
  gold5_1,
  gold5_2,
  gold10_0,
  gold10_1,
  gold10_2,
  badTerrainP1_0,
  badTerrainP1_1,
  badTerrainP1_2,
  badTerrainP2_0,
  badTerrainP2_1,
  badTerrainP2_2,
  markerTurn,
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
  card,
  counter,
  combatFront,
  mongolAndAllied,
  mongolLightCavalry,
  mongolHeavyCavalry,
  khan,
  siegeEngine,
  goldenHordeLightCavalry,
  goldenHordeHeavyCavalry,
  alliedRed,
  alliedRedLightCavalry,
  alliedRedHeavyCavalry,
  alliedYellow,
  alliedYellowLightCavalry,
  alliedYellowHeavyCavalry,
  alliedBlue,
  alliedBlueLightCavalry,
  alliedBlueHeavyCavalry,
  enemy,
  enemyInfantry,
  city,
  cityFront,
  siege,
  gold,
  gold1,
  gold2,
  gold5,
  gold10,
  badTerrainP1,
}

const List<PieceType> mongolPieceTypes = [
  PieceType.mongolLightCavalry,
  PieceType.mongolHeavyCavalry,
  PieceType.khan,
  PieceType.siegeEngine,
];

const List<PieceType> friendlyLightCavalryPieceTypes = [
  PieceType.mongolLightCavalry,
  PieceType.goldenHordeLightCavalry,
  PieceType.alliedRedLightCavalry,
  PieceType.alliedYellowLightCavalry,
  PieceType.alliedBlueLightCavalry,
];

const List<PieceType> friendlyHeavyCavalryPieceTypes = [
  PieceType.mongolHeavyCavalry,
  PieceType.goldenHordeHeavyCavalry,
  PieceType.alliedRedHeavyCavalry,
  PieceType.alliedYellowHeavyCavalry,
  PieceType.alliedBlueHeavyCavalry,
];

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.card: [Piece.cardMongolia, Piece.cardHolyLand],
    PieceType.counter: [Piece.mongolLightCavalry0, Piece.markerTurn],
    PieceType.combatFront: [Piece.mongolLightCavalry0, Piece.enemyHeavyCavalry1_2],
    PieceType.mongolAndAllied: [Piece.mongolLightCavalry0, Piece.alliedBlueHeavyCavalry1],
    PieceType.mongolLightCavalry: [Piece.mongolLightCavalry0, Piece.mongolLightCavalry2],
    PieceType.mongolHeavyCavalry: [Piece.mongolHeavyCavalry0, Piece.mongolHeavyCavalry2],
    PieceType.khan: [Piece.khan, Piece.khan],
    PieceType.siegeEngine: [Piece.siegeEngine0, Piece.siegeEngine2],
    PieceType.goldenHordeLightCavalry: [Piece.goldenHordeLightCavalry0, Piece.goldenHordeLightCavalry1],
    PieceType.goldenHordeHeavyCavalry: [Piece.goldenHordeHeavyCavalry0, Piece.goldenHordeHeavyCavalry0],
    PieceType.alliedRed: [Piece.alliedRedLightCavalry0, Piece.alliedRedHeavyCavalry1],
    PieceType.alliedRedLightCavalry: [Piece.alliedRedLightCavalry0, Piece.alliedRedLightCavalry2],
    PieceType.alliedRedHeavyCavalry: [Piece.alliedRedHeavyCavalry0, Piece.alliedRedHeavyCavalry1],
    PieceType.alliedYellow: [Piece.alliedYellowLightCavalry0, Piece.alliedYellowHeavyCavalry1],
    PieceType.alliedYellowLightCavalry: [Piece.alliedYellowLightCavalry0, Piece.alliedYellowLightCavalry2],
    PieceType.alliedYellowHeavyCavalry: [Piece.alliedYellowHeavyCavalry0, Piece.alliedYellowHeavyCavalry1],
    PieceType.alliedBlue: [Piece.alliedBlueLightCavalry0, Piece.alliedBlueHeavyCavalry1],
    PieceType.alliedBlueLightCavalry: [Piece.alliedBlueLightCavalry0, Piece.alliedBlueLightCavalry2],
    PieceType.alliedBlueHeavyCavalry: [Piece.alliedBlueHeavyCavalry0, Piece.alliedBlueHeavyCavalry1],
    PieceType.enemy: [Piece.enemyLightCavalry1_0, Piece.enemyInfantry2_12],
    PieceType.enemyInfantry: [Piece.enemyInfantry1_0, Piece.enemyInfantry2_12],
    PieceType.city: [Piece.city0, Piece.city27],
    PieceType.cityFront: [Piece.city0, Piece.city23],
    PieceType.siege: [Piece.siege0, Piece.siege3],
    PieceType.gold: [Piece.gold1_0, Piece.gold10_2],
    PieceType.gold1: [Piece.gold1_0, Piece.gold1_4],
    PieceType.gold2: [Piece.gold2_0, Piece.gold2_4],
    PieceType.gold5: [Piece.gold5_0, Piece.gold5_2],
    PieceType.gold10: [Piece.gold10_0, Piece.gold10_2],
    PieceType.badTerrainP1: [Piece.badTerrainP1_0, Piece.badTerrainP1_2],
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

  bool get isMongol {
    return mongolPieceTypes.contains(this);
  }

  AlliedColor? get alliedColor {
    const pieceTypeAlliedColors = {
      PieceType.alliedRed: AlliedColor.red,
      PieceType.alliedRedLightCavalry: AlliedColor.red,
      PieceType.alliedRedHeavyCavalry: AlliedColor.red,
      PieceType.alliedYellow: AlliedColor.yellow,
      PieceType.alliedYellowLightCavalry: AlliedColor.yellow,
      PieceType.alliedYellowHeavyCavalry: AlliedColor.yellow,
      PieceType.alliedBlue: AlliedColor.blue,
      PieceType.alliedBlueLightCavalry: AlliedColor.blue,
      PieceType.alliedBlueHeavyCavalry: AlliedColor.blue,
    };
    return pieceTypeAlliedColors[this];
  }

  bool get isFriendlyLightCavalry {
    return friendlyLightCavalryPieceTypes.contains(this);
  }

  bool get isFriendlyHeavyCavalry {
    return friendlyHeavyCavalryPieceTypes.contains(this);
  }

  int get raiseCost {
    const pieceTypeRaiseCosts = {
      PieceType.mongolLightCavalry: 1,
      PieceType.alliedRedLightCavalry: 1,
      PieceType.alliedYellowLightCavalry: 1,
      PieceType.alliedBlueLightCavalry: 1,
      PieceType.mongolHeavyCavalry: 2,
      PieceType.alliedRedHeavyCavalry: 2,
      PieceType.alliedYellowHeavyCavalry: 2,
      PieceType.alliedBlueHeavyCavalry: 2,
      PieceType.siegeEngine: 2,
    };
    final cost = pieceTypeRaiseCosts[this];
    if (cost == null) {
      return 0;
    }
    return cost;
  }
}

enum AlliedColor {
  red,
  yellow,
  blue,
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

  bool get isFriendlyLightCavalry {
    for (final pieceType in friendlyLightCavalryPieceTypes) {
      if (isType(pieceType)) {
        return true;
      }
    }
    return false;
  }

  bool get isFriendlyHeavyCavalry {
    for (final pieceType in friendlyHeavyCavalryPieceTypes) {
      if (isType(pieceType)) {
        return true;
      }
    }
    return false;
  }

  AlliedColor? get alliedColor {
    if (isType(PieceType.alliedRed)) {
      return AlliedColor.red;
    }
    if (isType(PieceType.alliedYellow)) {
      return AlliedColor.yellow;
    }
    if (isType(PieceType.alliedBlue)) {
      return AlliedColor.blue;
    }
    return null;
  }
}

enum Terrain {
  grass,
  desert,
  crops,
  forest,
  mountains,
  swamp,
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
      Scenario.standard: 'Standard (44 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<Piece> _piecesInSecondCity = <Piece>[];

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
   : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
  , _piecesInSecondCity = pieceListFromIndices(List<int>.from(json['piecesInSecondCity']))
   ;

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'piecesInSecondCity': pieceListToIndices(_piecesInSecondCity),
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.alliedRedLightCavalry0: Piece.enemyRedLightCavalry0,
      Piece.alliedRedLightCavalry1: Piece.enemyRedLightCavalry1,
      Piece.alliedRedLightCavalry2: Piece.enemyRedLightCavalry2,
      Piece.alliedRedHeavyCavalry0: Piece.enemyRedHeavyCavalry0,
      Piece.alliedRedHeavyCavalry1: Piece.enemyRedHeavyCavalry1,
      Piece.alliedYellowLightCavalry0: Piece.enemyYellowLightCavalry0,
      Piece.alliedYellowLightCavalry1: Piece.enemyYellowLightCavalry1,
      Piece.alliedYellowLightCavalry2: Piece.enemyYellowLightCavalry2,
      Piece.alliedYellowHeavyCavalry0: Piece.enemyYellowHeavyCavalry0,
      Piece.alliedYellowHeavyCavalry1: Piece.enemyYellowHeavyCavalry1,
      Piece.alliedBlueLightCavalry0: Piece.enemyBlueLightCavalry0,
      Piece.alliedBlueLightCavalry1: Piece.enemyBlueLightCavalry1,
      Piece.alliedBlueLightCavalry2: Piece.enemyBlueLightCavalry2,
      Piece.alliedBlueHeavyCavalry0: Piece.enemyBlueHeavyCavalry0,
      Piece.alliedBlueHeavyCavalry1: Piece.enemyBlueHeavyCavalry1,
      Piece.enemyInfantry1_0: Piece.enemyInfantry2_0,
      Piece.enemyInfantry1_1: Piece.enemyInfantry2_1,
      Piece.enemyInfantry1_2: Piece.enemyInfantry2_2,
      Piece.enemyInfantry1_3: Piece.enemyInfantry2_3,
      Piece.enemyInfantry1_4: Piece.enemyInfantry2_4,
      Piece.enemyInfantry1_5: Piece.enemyInfantry2_5,
      Piece.enemyInfantry1_6: Piece.enemyInfantry2_6,
      Piece.enemyInfantry1_7: Piece.enemyInfantry2_7,
      Piece.enemyInfantry1_8: Piece.enemyInfantry2_8,
      Piece.enemyInfantry1_9: Piece.enemyInfantry2_9,
      Piece.enemyInfantry1_10: Piece.enemyInfantry2_10,
      Piece.enemyInfantry1_11: Piece.enemyInfantry2_11,
      Piece.enemyInfantry1_12: Piece.enemyInfantry2_12,
      Piece.enemyInfantry2_0: Piece.enemyInfantry1_0,
      Piece.enemyInfantry2_1: Piece.enemyInfantry1_1,
      Piece.enemyInfantry2_2: Piece.enemyInfantry1_2,
      Piece.enemyInfantry2_3: Piece.enemyInfantry1_3,
      Piece.enemyInfantry2_4: Piece.enemyInfantry1_4,
      Piece.enemyInfantry2_5: Piece.enemyInfantry1_5,
      Piece.enemyInfantry2_6: Piece.enemyInfantry1_6,
      Piece.enemyInfantry2_7: Piece.enemyInfantry1_7,
      Piece.enemyInfantry2_8: Piece.enemyInfantry1_8,
      Piece.enemyInfantry2_9: Piece.enemyInfantry1_9,
      Piece.enemyInfantry2_10: Piece.enemyInfantry1_10,
      Piece.enemyInfantry2_11: Piece.enemyInfantry1_11,
      Piece.enemyInfantry2_12: Piece.enemyInfantry1_12,
      Piece.enemyLightCavalry1_0: Piece.enemyHeavyCavalry2_0,
      Piece.enemyLightCavalry1_1: Piece.enemyHeavyCavalry2_1,
      Piece.enemyLightCavalry1_2: Piece.enemyHeavyCavalry2_2,
      Piece.enemyLightCavalry1_3: Piece.enemyLightCavalry2_3,
      Piece.enemyLightCavalry2_0: Piece.enemyHeavyCavalry1_0,
      Piece.enemyLightCavalry2_1: Piece.enemyHeavyCavalry1_1,
      Piece.enemyLightCavalry2_2: Piece.enemyHeavyCavalry1_2,
      Piece.enemyLightCavalry2_3: Piece.enemyLightCavalry1_3,
      Piece.enemyHeavyCavalry1_0: Piece.enemyLightCavalry2_0,
      Piece.enemyHeavyCavalry1_1: Piece.enemyLightCavalry2_1,
      Piece.enemyHeavyCavalry1_2: Piece.enemyLightCavalry2_2,
      Piece.enemyHeavyCavalry2_0: Piece.enemyLightCavalry1_0,
      Piece.enemyHeavyCavalry2_1: Piece.enemyLightCavalry1_1,
      Piece.enemyHeavyCavalry2_2: Piece.enemyLightCavalry1_2,
      Piece.enemyRedLightCavalry0: Piece.alliedRedLightCavalry0,
      Piece.enemyRedLightCavalry1: Piece.alliedRedLightCavalry1,
      Piece.enemyRedLightCavalry2: Piece.alliedRedLightCavalry2,
      Piece.enemyRedHeavyCavalry0: Piece.alliedRedHeavyCavalry0,
      Piece.enemyRedHeavyCavalry1: Piece.alliedRedHeavyCavalry1,
      Piece.enemyYellowLightCavalry0: Piece.alliedYellowLightCavalry0,
      Piece.enemyYellowLightCavalry1: Piece.alliedYellowLightCavalry1,
      Piece.enemyYellowLightCavalry2: Piece.alliedYellowLightCavalry2,
      Piece.enemyYellowHeavyCavalry0: Piece.alliedYellowHeavyCavalry0,
      Piece.enemyYellowHeavyCavalry1: Piece.alliedYellowHeavyCavalry1,
      Piece.enemyBlueLightCavalry0: Piece.alliedBlueLightCavalry0,
      Piece.enemyBlueLightCavalry1: Piece.alliedBlueLightCavalry1,
      Piece.enemyBlueLightCavalry2: Piece.alliedBlueLightCavalry2,
      Piece.enemyBlueHeavyCavalry0: Piece.alliedBlueHeavyCavalry0,
      Piece.enemyBlueHeavyCavalry1: Piece.alliedBlueHeavyCavalry1,
      Piece.city0: Piece.razed0,
      Piece.city1: Piece.razed1,
      Piece.city2: Piece.razed2,
      Piece.city3: Piece.razed3,
      Piece.city4: Piece.razed4,
      Piece.city5: Piece.razed5,
      Piece.city6: Piece.razed6,
      Piece.city7: Piece.razed7,
      Piece.city8: Piece.razed8,
      Piece.city9: Piece.razed9,
      Piece.city10: Piece.razed10,
      Piece.city11: Piece.razed11,
      Piece.city12: Piece.razed12,
      Piece.city13: Piece.razed13,
      Piece.city14: Piece.razed14,
      Piece.city15: Piece.razed15,
      Piece.city16: Piece.razed16,
      Piece.city17: Piece.razed17,
      Piece.city18: Piece.razed18,
      Piece.city19: Piece.razed19,
      Piece.city20: Piece.razed20,
      Piece.city21: Piece.razed21,
      Piece.city22: Piece.razed22,
      Piece.city23: Piece.razed23,
      Piece.city24: Piece.siege0,
      Piece.city25: Piece.siege1,
      Piece.city26: Piece.siege2,
      Piece.city27: Piece.siege3,
      Piece.razed0: Piece.city0,
      Piece.razed1: Piece.city1,
      Piece.razed2: Piece.city2,
      Piece.razed3: Piece.city3,
      Piece.razed4: Piece.city4,
      Piece.razed5: Piece.city5,
      Piece.razed6: Piece.city6,
      Piece.razed7: Piece.city7,
      Piece.razed8: Piece.city8,
      Piece.razed9: Piece.city9,
      Piece.razed10: Piece.city10,
      Piece.razed11: Piece.city11,
      Piece.razed12: Piece.city12,
      Piece.razed13: Piece.city13,
      Piece.razed14: Piece.city14,
      Piece.razed15: Piece.city15,
      Piece.razed16: Piece.city16,
      Piece.razed17: Piece.city17,
      Piece.razed18: Piece.city18,
      Piece.razed19: Piece.city19,
      Piece.razed20: Piece.city20,
      Piece.razed21: Piece.city21,
      Piece.razed22: Piece.city22,
      Piece.razed23: Piece.city23,
      Piece.siege0: Piece.city24,
      Piece.siege1: Piece.city25,
      Piece.siege2: Piece.city26,
      Piece.siege3: Piece.city27,
      Piece.badTerrainP1_0: Piece.badTerrainP2_0,
      Piece.badTerrainP1_1: Piece.badTerrainP2_1,
      Piece.badTerrainP1_2: Piece.badTerrainP2_2,
      Piece.badTerrainP2_0: Piece.badTerrainP1_0,
      Piece.badTerrainP2_1: Piece.badTerrainP1_0,
      Piece.badTerrainP2_2: Piece.badTerrainP1_0,
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

  // Map Locations

  int mapColumn(Location mapLocation) {
    int index = mapLocation.index - LocationType.map.firstIndex;
    return index % 9;
  }

  int mapRow(Location mapLocation) {
    int index = mapLocation.index - LocationType.map.firstIndex;
    return index ~/ 9;
  }

  List<Location> get currentMapLocations {
    final mapLocations = <Location>[];
    for (final card in PieceType.card.pieces) {
      final cardLocation = pieceLocation(card);
      if (cardLocation.isType(LocationType.map)) {
        mapLocations.add(cardLocation);
      }
    }
    return mapLocations;
  }

  int mapLocationPieceTypeStrength(Location mapLocation, PieceType pieceType) {
    int strength = 0;
    for (final piece in piecesInLocation(pieceType, mapLocation)) {
      strength += pieceStrength(piece);
    }
  }

  void mapLocationIncreaseInfantry(Location location, int count) 
  // Cards

  int cardTerrainCount(Piece card, Terrain terrain) {
    const cardTerrains = {
      Piece.cardMongolia: [Terrain.grass, Terrain.grass, Terrain.grass, Terrain.grass],
      Piece.cardKhoriTumet: [Terrain.swamp, Terrain.swamp, Terrain.grass, Terrain.forest],
      Piece.cardTatar: [Terrain.grass, Terrain.forest, Terrain.grass, Terrain.mountains],
      Piece.cardJurchen: [Terrain.grass, Terrain.grass, Terrain.crops, Terrain.crops],
      Piece.cardGobi: [Terrain.grass, Terrain.grass, Terrain.desert, Terrain.desert],
      Piece.cardNaiman: [Terrain.mountains, Terrain.forest, Terrain.grass, Terrain.grass],
      Piece.cardUyghur: [Terrain.grass, Terrain.grass, Terrain.desert, Terrain.desert],
      Piece.cardKipchak: [Terrain.grass, Terrain.mountains, Terrain.grass, Terrain.grass],
      Piece.cardDzungaria: [Terrain.grass, Terrain.desert, Terrain.desert, Terrain.mountains],
      Piece.cardTaklamakan: [Terrain.grass, Terrain.desert, Terrain.mountains, Terrain.desert],
      Piece.cardWesternXia: [Terrain.desert, Terrain.desert, Terrain.mountains, Terrain.crops],
      Piece.cardBashkir: [Terrain.forest, Terrain.swamp, Terrain.grass, Terrain.grass],
      Piece.cardKirghiz: [Terrain.grass, Terrain.grass, Terrain.desert, Terrain.desert],
      Piece.cardVolgaBulgar: [Terrain.forest, Terrain.forest, Terrain.grass, Terrain.grass],
      Piece.cardCaspianSteppe: [Terrain.grass, Terrain.grass, Terrain.desert, Terrain.desert],
      Piece.cardTibet: [Terrain.swamp, Terrain.mountains, Terrain.mountains, Terrain.mountains],
      Piece.cardJinChina: [Terrain.forest, Terrain.crops, Terrain.crops, Terrain.crops],
      Piece.cardBukhara: [Terrain.desert, Terrain.desert, Terrain.desert, Terrain.crops],
      Piece.cardKarakhitai: [Terrain.desert, Terrain.desert, Terrain.crops, Terrain.mountains],
      Piece.cardMerv: [Terrain.desert, Terrain.desert, Terrain.desert, Terrain.crops],
      Piece.cardRus: [Terrain.forest, Terrain.forest, Terrain.grass, Terrain.grass],
      Piece.cardPonticSteppe: [Terrain.mountains, Terrain.crops, Terrain.grass, Terrain.grass],
      Piece.cardCaucasus: [Terrain.grass, Terrain.grass, Terrain.mountains, Terrain.grass],
      Piece.cardDali: [Terrain.forest, Terrain.crops, Terrain.mountains, Terrain.forest],
      Piece.cardNovgorod: [Terrain.forest, Terrain.swamp, Terrain.crops, Terrain.forest],
      Piece.cardPolishTeuton: [Terrain.forest, Terrain.forest, Terrain.mountains, Terrain.crops],
      Piece.cardAzerbaijan: [Terrain.forest, Terrain.mountains, Terrain.crops, Terrain.mountains],
      Piece.cardPersia: [Terrain.mountains, Terrain.mountains, Terrain.crops, Terrain.desert],
      Piece.cardIndus: [Terrain.desert, Terrain.mountains, Terrain.crops, Terrain.crops],
      Piece.cardSongChina: [Terrain.forest, Terrain.crops, Terrain.forest, Terrain.crops],
      Piece.cardKorea: [Terrain.mountains, Terrain.mountains, Terrain.crops, Terrain.forest],
      Piece.cardJapan: [Terrain.mountains, Terrain.forest, Terrain.crops, Terrain.crops],
      Piece.cardAfghanistan: [Terrain.mountains, Terrain.mountains, Terrain.crops, Terrain.mountains],
      Piece.cardTigris: [Terrain.crops, Terrain.mountains, Terrain.desert, Terrain.crops],
      Piece.cardEurope: [Terrain.crops, Terrain.crops, Terrain.mountains, Terrain.grass],
      Piece.cardAnatolia: [Terrain.crops, Terrain.mountains, Terrain.crops, Terrain.grass],
      Piece.cardHolyLand: [Terrain.crops, Terrain.mountains, Terrain.crops, Terrain.desert],
    };
    final terrains = cardTerrains[card]!;
    int count = 0;
    for (final cardTerrain in terrains) {
      if (cardTerrain == terrain) {
        count += 1;
      }
    }
    return count;
  }

  // Pieces

  int pieceStrength(Piece piece) {
    const doublePieceTypes = [

    ];
    for (final pieceType in doublePieceTypes) {
      if (piece.isType(pieceType)) {
        return 2;
      }
    }
    return 1;
  }

  bool pieceCanGarrison(Piece piece) {
    if (piece == Piece.khan) {
      return true;
    }
    if (piece.isFriendlyHeavyCavalry) {
      return true;
    }
    return false;
  }

  // Locations

  int locationGarrisonCount(Location mapLocation) {
    int cityCount = piecesInLocationCount(PieceType.city, mapLocation);
    int siegeCount = piecesInLocationCount(PieceType.siege, mapLocation);
    int garrisonCount = 0;
    for (final piece in piecesInLocation(PieceType.mongolAndAllied, mapLocation)) {
      if (pieceCanGarrison(piece)) {
        garrisonCount += 1;
      }
    }
    return min(cityCount - siegeCount, garrisonCount);
  }

  // Sieges

  List<Piece> get activeSieges {
    final sieges = <Piece>[];
    for (final siege in PieceType.siege.pieces) {
      if (pieceLocation(siege) != Location.offmap) {
        sieges.add(siege);
      }
    }
    return sieges;
  }

  // Gold

  int goldValue(Piece gold) {
    if (gold.isType(PieceType.gold1)) {
      return 1;
    }
    if (gold.isType(PieceType.gold2)) {
      return 2;
    }
    if (gold.isType(PieceType.gold5)) {
      return 5;
    }
    if (gold.isType(PieceType.gold10)) {
      return 10;
    }
    return 0;
  }

  int get gold {
    int total = 0;
    for (final piece in piecesInLocation(PieceType.gold, Location.poolGold)) {
      total += goldValue(piece);
    }
    return total;
  }

  void adjustGold(int delta) {
    int newGold = gold + delta;
    if (newGold < 0) {
      newGold = 0;
    }
    int remaining = newGold;
    for (final piece in PieceType.gold10.pieces) {
      if (remaining >= 10) {
        setPieceLocation(piece, Location.poolGold);
        remaining -= 10;
      } else {
        setPieceLocation(piece, Location.offmap);
      }
    }
    for (final piece in PieceType.gold5.pieces) {
      if (remaining >= 5) {
        setPieceLocation(piece, Location.poolGold);
        remaining -= 5;
      } else {
        setPieceLocation(piece, Location.offmap);
      }
    }
    for (final piece in PieceType.gold2.pieces) {
      if (remaining >= 2) {
        setPieceLocation(piece, Location.poolGold);
        remaining -= 2;
      } else {
        setPieceLocation(piece, Location.offmap);
      }
    }
    for (final piece in PieceType.gold1.pieces) {
      if (remaining >= 1) {
        setPieceLocation(piece, Location.poolGold);
        remaining -= 1;
      } else {
        setPieceLocation(piece, Location.offmap);
      }
    }
  }

  // Turns

  int get currentTurn {
    return pieceLocation(Piece.markerTurn).index - Location.turn1.index + 1;
  }

  String turnName(int turn) {
    return 'Turn $turn';
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

  factory GameState.setupStandard() {

    var state = GameState();

    state.setupPieceTypes([
      (PieceType.card, Location.offmap),
      (PieceType.combatFront, Location.offmap),
      (PieceType.cityFront, Location.offmap),
      (PieceType.siege, Location.offmap),
      (PieceType.gold, Location.offmap),
      (PieceType.badTerrainP1, Location.offmap),
    ]);

    state.setupPieces([
      (Piece.cardMongolia, Location.map26Mongolia),
      (Piece.khan, Location.map26Mongolia),
      (Piece.mongolHeavyCavalry0, Location.map26Mongolia),
      (Piece.mongolLightCavalry0, Location.map26Mongolia),
      (Piece.markerTurn, Location.turn1),
    ]);

    return state;
  }
}

enum Choice {
  mongolLightCavalry,
  mongolHeavyCavalry,
  alliedRedLightCavalry,
  alliedRedHeavyCavalry,
  alliedYellowLightCavalry,
  alliedYellowHeavyCavalry,
  alliedBlueLightCavalry,
  alliedBlueHeavyCavalry,
  siegeEngine,
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
  defeat,
  presidentLincoln,
  presidentMcClellan,
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
  income,
  enemyIncreases,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateIncome extends PhaseState {
  List<Piece> raisedPieces = <Piece>[];
  List<Location> raisedPieceLocations = <Location>[];

  PhaseStateIncome();

  PhaseStateIncome.fromJson(Map<String, dynamic> json)
    : raisedPieces = pieceListFromIndices(List<int>.from(json['raisedPieces']))
    , raisedPieceLocations = locationListFromIndices(List<int>.from(json['raisedPieceLocations']))
    ;

  @override
  Map<String, dynamic> toJson() => {
    'raisedPieces': pieceListToIndices(raisedPieces),
    'raisedPieceLocations': locationListToIndices(raisedPieceLocations),
  };

  @override
  Phase get phase {
    return Phase.income;
  }

  void raisePieceInLocation(Piece piece, Location location) {
    raisedPieces.add(piece);
    raisedPieceLocations.add(location);
  }
}

class PhaseStateEnemyIncreases extends PhaseState {
  List<Location> increaseLocations = <Location>[];
  int index = 0;
  int lightCavalryCount = 0;
  int heavyCavalryCount = 0;

  PhaseStateEnemyIncreases();

  PhaseStateEnemyIncreases.fromJson(Map<String, dynamic> json)
    : increaseLocations = locationListFromIndices(List<int>.from(json['increaseLocations']))
    , index = json['index'] as int
    , lightCavalryCount = json['lightCavalryCount'] as int
    , heavyCavalryCount = json['heavyCavalryCount'] as int
    ;
  
  @override
  Map<String, dynamic> toJson() => {
    'increaseLocations': locationListToIndices(increaseLocations),
    'index': index,
    'lightCavalryCount': lightCavalryCount,
    'heavyCavalryCount': heavyCavalryCount,
  };

  @override
  Phase get phase {
    return Phase.enemyIncreases;
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
  PhaseState? _phaseState;
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
      case Phase.income:
        _phaseState = PhaseStateIncome.fromJson(phaseStateJson);
      case Phase.enemyIncreases:
        _phaseState = PhaseStateEnemyIncreases.fromJson(phaseStateJson);
      }
    }
    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
    if (_phaseState != null) {
      map['phase'] = _phaseState!.phase.index;
      map['phaseState'] = _phaseState!.toJson();
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

  void logTableHeader() {
    logLine('>|Effect|Value|');
    logLine('>|:---|:---:|');
  }

  void logTableFooter() {
    logLine('>');
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

  void log2D6InTable((int,int,int,int) rolls) {
    int d0 = rolls.$1;
    int d1 = rolls.$2;
    logLine('>|${dieFace(d0)} ${dieFace(d1)}|${d0 + d1}|');
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

  // Logging Functions

  void adjustGold(int delta) {
    _state.adjustGold(delta);
    if (delta > 0) {
      logLine('>Gold: +$delta → ${_state.gold}');
    } else {
      logLine('>Gold: $delta → ${_state.gold}');
    }
  }

  void locationIncreaseInfantry(Location location, int count) {
    final card = _state.pieceInLocation(PieceType.card, location)!;
    logLine('>$count Infantry are added in ${card.desc}.');
    _state.locationIncreaseInfantry(location, count);
  }

  // High-Level Functions

  bool canRaisePieceInMapLocation(PieceType pieceType, Location mapLocation) {
    if (_state.piecesInLocationCount(PieceType.enemy, mapLocation) > 0) {
      return false;
    }
    final phaseState = _phaseState as PhaseStateIncome;
    final card = _state.pieceInLocation(PieceType.card, mapLocation)!;
    final locallyRaisedPieces = <Piece>[];
    for (int i = 0; i < phaseState.raisedPieces.length; ++i) {
      if (phaseState.raisedPieceLocations[i] == mapLocation) {
        locallyRaisedPieces.add(phaseState.raisedPieces[i]);
      }
    }
    if (pieceType == PieceType.siegeEngine) {
      if (_state.locationGarrisonCount(mapLocation) == 0) {
        return false;
      }
      return true;
    }
    if (pieceType.isMongol != (mapLocation == Location.map26Mongolia)) {
      return false;
    }
    int grassNeeded = 0;
    if (pieceType.isFriendlyLightCavalry) {
      grassNeeded = 1;
    } else {
      grassNeeded = 2;
    }
    int grassUsed = 0;
    for (final piece in locallyRaisedPieces) {
      if (piece.alliedColor != pieceType.alliedColor) {
        return false;
      }
      if (piece.isFriendlyLightCavalry) {
        grassUsed += 1;
      } else if (piece.isFriendlyHeavyCavalry) {
        grassUsed += 2;
      }
    }
    if (_state.cardTerrainCount(card, Terrain.grass) < grassNeeded + grassUsed) {
      return false;
    }
    return true;
  }

  List<Location> candidateRaisePieceTypeMapLocations(PieceType pieceType) {
    final candidates = <Location>[];
    for (final mapLocation in _state.currentMapLocations) {
      if (canRaisePieceInMapLocation(pieceType, mapLocation)) {
        candidates.add(mapLocation);
      }
    }
    return candidates;
  }

  List<Location> get enemyIncreaseLocations {
    final locations = <Location>[];
    for (final card in PieceType.card.pieces) {
      final location = _state.pieceLocation(card);
      if (location.isType(LocationType.map)) {
        final enemyCount = _state.piecesInLocationCount(PieceType.enemy, location);
        final siegeCount = _state.piecesInLocationCount(PieceType.siege, location);
        if (enemyCount > 0 && siegeCount == 0) {
          locations.add(location);
        }
      }
    }
    return locations;
  }

  int infantryTableResult(int total) {
    const tableResults = {
      1: 0,
      2: 1,
      3: 2,
      4: 3,
      5: 3,
      6: 4,
      7: 5,
      8: 6,
    };
    return tableResults[total]!;
  }

  (int,int) steppeTableResult(int total) {
    const tableResults = {
      1: (0, 0),
      2: (1, 0),
      3: (2, 0),
      4: (1, 1),
      5: (3, 0),
      6: (2, 1),
      7: (1, 2),
      8: (0, 3),
      9: (1, 3),
    };
    return tableResults[total]!;
  }

  (int,int) barrenTableResult(int total) {
    const tableResults = {
      1: (1, 0),
      2: (1, 0),
      3: (2, 0),
      4: (0, 1),
      5: (0, 1),
      6: (0, 2),
    };
    return tableResults[total]!;
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;

    // TODO logging
  }

  // Sequence Helpers

  // Sequence of Play

  void turnBegin() {
    logLine('# ${_state.turnName(_state.currentTurn)}');
  }

  void resolveSiegesPhaseBegin() {
    if (_state.activeSieges.isEmpty) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Resolve Sieges Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Resolve Sieges Phase');
  }

  void resolveSiegesPhaseResolve() {
    if (_state.activeSieges.isEmpty) {
      return;
    }
    // TODO
  }

  void incomePhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Income Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Income Phase');
    _phaseState = PhaseStateIncome();
  }

  void incomePhaseIncome() {
    logLine('### Income');
    int income = 0;
    for (final mapLocation in LocationType.map.locations) {
      income += _state.locationGarrisonCount(mapLocation);
    }
    adjustGold(income);
  }

  void incomePhaseRaiseTroops() {
    const raiseTypes = [
      (PieceType.mongolLightCavalry, Choice.mongolLightCavalry),
      (PieceType.mongolHeavyCavalry, Choice.mongolHeavyCavalry),
      (PieceType.alliedRedLightCavalry, Choice.alliedRedLightCavalry),
      (PieceType.alliedRedHeavyCavalry, Choice.alliedRedHeavyCavalry),
      (PieceType.alliedYellowLightCavalry, Choice.alliedYellowLightCavalry),
      (PieceType.alliedYellowHeavyCavalry, Choice.alliedYellowHeavyCavalry),
      (PieceType.alliedBlueLightCavalry, Choice.alliedBlueLightCavalry),
      (PieceType.alliedBlueHeavyCavalry, Choice.alliedBlueHeavyCavalry),
      (PieceType.siegeEngine, Choice.siegeEngine),
    ];
    final phaseState = _phaseState as PhaseStateIncome;
    while (true) {
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      if (choicesEmpty()) {
        setPrompt('Select Unit to Raise, or Next to proceed');
        for (int i = 0; i < raiseTypes.length; ++i) {
          final pieceType = raiseTypes[i].$1;
          final choice = raiseTypes[i].$2;
          if (_state.piecesInLocationCount(pieceType, Location.offmap) > 0 && candidateRaisePieceTypeMapLocations(pieceType).isNotEmpty) {
            choiceChoosable(choice, _state.gold >= pieceType.raiseCost);
          }
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      PieceType? pieceType;
      for (int i = 0; i < raiseTypes.length; ++i) {
        if (checkChoice(raiseTypes[i].$2)) {
          pieceType = raiseTypes[i].$1;
          break;
        }
      }
      final mapLocation = selectedLocation();
      if (mapLocation == null) {
        setPrompt('Select Card to Raise ${Piece.values[pieceType!.firstIndex].desc} in.');
        for (final location in candidateRaisePieceTypeMapLocations(pieceType)) {
          locationChoosable(location);
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      final card = _state.pieceInLocation(PieceType.card, mapLocation)!;
      logLine('### Raise ${Piece.values[pieceType!.firstIndex].desc} in ${card.desc}.');
      adjustGold(-pieceType.raiseCost);
      final piece = _state.piecesInLocation(pieceType, Location.offmap)[0];
      _state.setPieceLocation(piece, mapLocation);
      phaseState.raisePieceInLocation(piece, mapLocation);
      clearChoices();
    }
  }

  void incomePhaseEnd() {
    _phaseState = null;
  }

  void enemyIncreasesPhaseBegin() {
    if (enemyIncreaseLocations.isEmpty) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Enemy Increases Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Enemy Increases Phase');
    _phaseState = PhaseStateEnemyIncreases();
  }

  void enemyIncreasesPhaseSetLocations() {
    if (_phaseState == null) {
      return;
    }
    final phaseState = _phaseState as PhaseStateEnemyIncreases;
    phaseState.increaseLocations = enemyIncreaseLocations;
  }

  void enemyIncreasesPhaseIncreases() {
    if (_phaseState == null) {
      return;
    }
    final phaseState = _phaseState as PhaseStateEnemyIncreases;
    while (phaseState.index < phaseState.increaseLocations.length) {
      final location = phaseState.increaseLocations[phaseState.index];
      final card = _state.pieceInLocation(PieceType.card, location)!;
      if (_subStep == 0) {
        logLine('### ${card.desc}');
        bool hasInfantry = _state.piecesInLocationCount(PieceType.enemyInfantry, location) > 0;
        int infantryCount = 0;
        int lightCavalryCount = 0;
        int heavyCavalryCount = 0;
        if (phaseState.index == 0) {
          int die = rollD6();
          logD6(die);
          if (hasInfantry) {
            infantryCount = infantryTableResult(die);
          } else {
            final results = steppeTableResult(die);
            lightCavalryCount = results.$1;
            heavyCavalryCount = results.$2;
          }
        } else {
          if (hasInfantry) {
            infantryCount = 1;
          } else {
            lightCavalryCount = 1;
          }
        }
        if (infantryCount == 0 && lightCavalryCount == 0 && heavyCavalryCount == 0) {
          logLine('>No increase.');
        } else if (infantryCount > 0) {
          locationIncreaseInfantry(location, infantryCount);
        } else {
          phaseState.lightCavalryCount = lightCavalryCount;
          phaseState.heavyCavalryCount = heavyCavalryCount;
          _subStep = 1;
        }
      }
      if (_subStep == 1) {
        if (choicesEmpty()) {
          setPrompt('Choose enemy cavalry type');
          choiceChoosable(Choice.hostile);
          throw PlayerChoiceException();
        }
        AlliedColor? alliedColor;

      }
    }
  }
  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      resolveSiegesPhaseBegin,
      resolveSiegesPhaseResolve,
      incomePhaseBegin,
      incomePhaseIncome,
      incomePhaseRaiseTroops,
      incomePhaseEnd,
      enemyIncreasesPhaseBegin,
      enemyIncreasesPhaseSetLocations,
      enemyIncreasesPhaseIncreases,
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

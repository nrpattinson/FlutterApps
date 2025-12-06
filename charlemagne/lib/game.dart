import 'dart:convert';
import 'dart:math';
import 'package:charlemagne/db.dart';
import 'package:charlemagne/random.dart';

enum Location {
  aachen,
  burgundy,
  fulda,
  provence,
  swabia,
  paris,
  reims,
  bretonMarch,
  bordeaux,
  gascony,
  poitiers,
  spanishMarch,
  bavaria,
  friuli,
  lombardy,
  rome,
  avars,
  carinthia,
  croats,
  moravians,
  saxons1,
  saxons2,
  veleti,
  boxRegionBlue,
  boxRegionPurple,
  boxRegionYellow,
  boxRegionGreen,
  boxRegionOrange,
  boxRegionBrown,
  boxChurchBlue,
  boxChurchPurple,
  boxChurchYellow,
  boxChurchGreen,
  boxChurchOrange,
  boxChurchBrown,
  victory0,
  victory1,
  victory2,
  victory3,
  victory4,
  victory5,
  victory6,
  victory7,
  victory8,
  victory9,
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
  treasury0,
  treasury1,
  treasury2,
  treasury3,
  treasury4,
  treasury5,
  treasury6,
  treasury7,
  treasury8,
  treasury9,
  treasury10,
  treasury11,
  treasury12,
  treasury13,
  treasury14,
  treasury15,
  treasury16,
  treasury17,
  treasury18,
  treasury19,
  treasury20,
  treasury21,
  treasury22,
  treasury23,
  treasury24,
  treasury25,
  treasury26,
  treasury27,
  treasury28,
  treasury29,
  treasury30,
  evp0,
  evp1,
  evp2,
  evp3,
  evp4,
  evp5,
  evp6,
  evp7,
  evp8,
  evp9,
  boxAlAndalus,
  boxByzantine,
  poolForce,
  poolDead,
  poolDeadPermanent,
  boxTacticalEnemyRight1,
  boxTacticalEnemyRight2,
  boxTacticalEnemyRight3,
  boxTacticalEnemyRight4,
  boxTacticalEnemyRight5,
  boxTacticalEnemyRight6,
  boxTacticalEnemyLeft1,
  boxTacticalEnemyLeft2,
  boxTacticalEnemyLeft3,
  boxTacticalEnemyLeft4,
  boxTacticalEnemyLeft5,
  boxTacticalEnemyLeft6,
  boxTacticalYourLeft1,
  boxTacticalYourLeft2,
  boxTacticalYourLeft3,
  boxTacticalYourLeft4,
  boxTacticalYourLeft5,
  boxTacticalYourRight1,
  boxTacticalYourRight2,
  boxTacticalYourRight3,
  boxTacticalYourRight4,
  boxTacticalYourRight5,
  boxTacticalYourReserve,
  cupFriendly,
  cupUnfriendly,
  cupHostile,
  cupBattle,
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
  space,
  blueSpace,
  purpleSpace,
  yellowSpace,
  greenSpace,
  orangeSpace,
  brownSpace,
  boxRegion,
  boxChurch,
  victory,
  turn,
  treasury,
  evp,
  boxTacticalEnemyRight,
  boxTacticalEnemyLeft,
  boxTacticalYour,
  boxTacticalYourLeftRight,
  boxTacticalYourLeft,
  boxTacticalYourRight,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.map: [Location.aachen, Location.boxByzantine],
    LocationType.space: [Location.aachen, Location.veleti],
    LocationType.blueSpace: [Location.aachen, Location.swabia],
    LocationType.purpleSpace: [Location.paris, Location.bretonMarch],
    LocationType.yellowSpace: [Location.bordeaux, Location.spanishMarch],
    LocationType.greenSpace: [Location.bavaria, Location.rome],
    LocationType.orangeSpace: [Location.avars, Location.moravians],
    LocationType.brownSpace: [Location.saxons1, Location.veleti],
    LocationType.boxRegion: [Location.boxRegionBlue, Location.boxRegionBrown],
    LocationType.boxChurch: [Location.boxChurchBlue, Location.boxChurchBrown],
    LocationType.victory: [Location.victory0, Location.victory9],
    LocationType.turn: [Location.turn1, Location.turn12],
    LocationType.treasury: [Location.treasury0, Location.treasury30],
    LocationType.evp: [Location.evp0, Location.evp9],
    LocationType.boxTacticalEnemyRight: [Location.boxTacticalEnemyRight1, Location.boxTacticalEnemyRight6],
    LocationType.boxTacticalEnemyLeft: [Location.boxTacticalEnemyLeft1, Location.boxTacticalEnemyLeft6],
    LocationType.boxTacticalYour: [Location.boxTacticalYourLeft1, Location.boxTacticalYourReserve],
    LocationType.boxTacticalYourLeftRight: [Location.boxTacticalYourLeft1, Location.boxTacticalYourRight5],
    LocationType.boxTacticalYourLeft: [Location.boxTacticalYourLeft1, Location.boxTacticalYourLeft5],
    LocationType.boxTacticalYourRight: [Location.boxTacticalYourRight1, Location.boxTacticalYourRight5],
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
      Location.aachen: 'Aachen',
      Location.burgundy: 'Burgundy',
      Location.fulda: 'Fulda',
      Location.provence: 'Provence',
      Location.swabia: 'Swabia',
      Location.paris: 'Paris',
      Location.reims: 'Reims',
      Location.bretonMarch: 'The Breton March',
      Location.bordeaux: 'Bordeaux',
      Location.gascony: 'Gascony',
      Location.poitiers: 'Poitiers',
      Location.spanishMarch: 'The Spanish March',
      Location.bavaria: 'Bavaria',
      Location.friuli: 'Friuli',
      Location.lombardy: 'Lombardy',
      Location.rome: 'Rome',
      Location.avars: 'Avars',
      Location.carinthia: 'Carinthia',
      Location.croats: 'Croats',
      Location.moravians: 'Moravians',
      Location.saxons1: 'Saxons Ⅰ',
      Location.saxons2: 'Saxons Ⅱ',
      Location.veleti: 'Veleti',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Region {
  blue,
  purple,
  yellow,
  green,
  orange,
  brown,
}

enum Piece {
  poitiers0,
  poitiers1,
  poitiers2,
  poitiers3,
  poitiers4,
  bordeaux0,
  bordeaux1,
  bordeaux2,
  bordeaux3,
  bordeaux4,
  gascony0,
  gascony1,
  gascony2,
  gascony3,
  gascony4,
  gascony5,
  lombardy0,
  lombardy1,
  lombardy2,
  lombardy3,
  lombardy4,
  friuli0,
  friuli1,
  friuli2,
  friuli3,
  bavaria0,
  bavaria1,
  bavaria2,
  bavaria3,
  fulda0,
  fulda1,
  swabia0,
  swabia1,
  swabia2,
  provence0,
  provence1,
  provence2,
  burgundy0,
  burgundy1,
  burgundy2,
  burgundy3,
  carinthia0,
  carinthia1,
  carinthia2,
  carinthia3,
  croats0,
  croats1,
  croats2,
  croats3,
  moravia0,
  moravia1,
  moravia2,
  moravia3,
  avars0,
  avars1,
  avars2,
  avars3,
  saxonsI0,
  saxonsI1,
  saxonsI2,
  saxonsI3,
  saxonsI4,
  saxonsI5,
  saxonsII0,
  saxonsII1,
  saxonsII2,
  saxonsII3,
  saxonsII4,
  saxonsII5,
  veleti0,
  veleti1,
  veleti2,
  veleti3,
  paris0,
  paris1,
  reims0,
  reims1,
  breton0,
  breton1,
  breton2,
  breton3,
  leaderPoitiers0,
  leaderPoitiers1,
  leaderPoitiers2,
  leaderPoitiers3,
  leaderPoitiers4,
  leaderBordeaux0,
  leaderBordeaux1,
  leaderBordeaux2,
  leaderBordeaux3,
  leaderBordeaux4,
  leaderGascony0,
  leaderGascony1,
  leaderGascony2,
  leaderGascony3,
  leaderGascony4,
  leaderGascony5,
  leaderLombardy0,
  leaderLombardy1,
  leaderLombardy2,
  leaderLombardy3,
  leaderLombardy4,
  leaderLombardy5,
  leaderFriuli0,
  leaderFriuli1,
  leaderFriuli2,
  leaderFriuli3,
  leaderBavaria0,
  leaderBavaria1,
  leaderBavaria2,
  leaderBavaria3,
  leaderBurgundy0,
  leaderBurgundy1,
  leaderBurgundy2,
  leaderBurgundy3,
  leaderCarinthia0,
  leaderCarinthia1,
  leaderCarinthia2,
  leaderCarinthia3,
  leaderCroats0,
  leaderCroats1,
  leaderCroats2,
  leaderCroats3,
  leaderMoravia0,
  leaderMoravia1,
  leaderMoravia2,
  leaderMoravia3,
  leaderAvars0,
  leaderAvars1,
  leaderAvars2,
  leaderAvars3,
  leaderSaxonsI0,
  leaderSaxonsI1,
  leaderSaxonsI2,
  leaderSaxonsI3,
  leaderSaxonsI4,
  leaderSaxonsI5,
  leaderSaxonsII0,
  leaderSaxonsII1,
  leaderSaxonsII2,
  leaderSaxonsII3,
  leaderSaxonsII4,
  leaderSaxonsII5,
  leaderVeleti0,
  leaderVeleti1,
  leaderVeleti2,
  leaderVeleti3,
  leaderBreton0,
  leaderBreton1,
  leaderBreton2,
  leaderBreton3,
  viking0,
  viking1,
  viking2,
  viking3,
  viking4,
  viking5,
  moor0,
  moor1,
  moor2,
  moor3,
  moor4,
  moor5,
  charlemagneYounger,
  charlemagneOlder,
  marquisNoCrown0,
  marquisNoCrown1,
  marquisNoCrown2,
  marquisNoCrown3,
  marquisCrown0,
  marquisCrown1,
  marquisCrown2,
  marquisCrown3,
  enemyBattleFull0,
  enemyBattleFull1,
  enemyBattleFull2,
  enemyBattleFull3,
  enemyBattleFull4,
  enemyBattleFull5,
  enemyBattleFull6,
  enemyBattleFull7,
  enemyBattleFull8,
  enemyBattleFull9,
  enemyBattleFull10,
  enemyBattleFull11,
  enemyBattleFull12,
  enemyBattleFull13,
  enemyBattleFull14,
  enemyBattleFull15,
  enemyBattleFlipped0,
  enemyBattleFlipped1,
  enemyBattleFlipped2,
  enemyBattleFlipped3,
  enemyBattleFlipped4,
  enemyBattleFlipped5,
  enemyBattleFlipped6,
  enemyBattleFlipped7,
  enemyBattleFlipped8,
  enemyBattleFlipped9,
  enemyBattleFlipped10,
  enemyBattleFlipped11,
  enemyBattleFlipped12,
  enemyBattleFlipped13,
  enemyBattleFlipped14,
  enemyBattleFlipped15,
  infantry1_0,
  infantry1_1,
  infantry1_2,
  infantry1_3,
  infantry1_4,
  infantry1_5,
  infantry1_6,
  infantry1_7,
  infantry2_0,
  infantry2_1,
  infantry2_2,
  infantry2_3,
  infantry2_4,
  infantry2_5,
  infantry2_6,
  infantry2_7,
  infantry3_0,
  infantry3_1,
  infantry3_2,
  infantry3_3,
  infantry3_4,
  infantry3_5,
  infantry3_6,
  infantry3_7,
  infantry4_0,
  infantry4_1,
  infantry4_2,
  infantry4_3,
  infantry4_4,
  infantry4_5,
  infantry4_6,
  infantry4_7,
  cavalry2_0,
  cavalry2_1,
  cavalry2_2,
  cavalry2_3,
  cavalry2_4,
  cavalry2_5,
  cavalry2_6,
  cavalry2_7,
  cavalry3_0,
  cavalry3_1,
  cavalry3_2,
  cavalry3_3,
  cavalry3_4,
  cavalry3_5,
  cavalry3_6,
  cavalry3_7,
  cavalry4_0,
  cavalry4_1,
  cavalry4_2,
  cavalry4_3,
  cavalry4_4,
  cavalry4_5,
  cavalry4_6,
  cavalry4_7,
  churchStarted0,
  churchStarted1,
  churchStarted2,
  churchStarted3,
  churchFinished0,
  churchFinished1,
  churchFinished2,
  churchFinished3,
  papalApprovalN1,
  papalApprovalZ,
  papalApprovalP1,
  papalApprovalP2,
  byzantium0,
  byzantium1,
  byzantium2,
  byzantium3,
  intrigue0,
  intrigue1,
  intrigue2,
  byzantinePeace,
  byzantineTension,
  alAndalusPeace,
  alAndalusTension,
  turnEnd0,
  turnEnd1,
  turnEnd2,
  turnEnd3,
  ironCrown,
  drmP1,
  drmP1P2,
  markerEvp,
  markerGameTurn,
  markerTaxes,
  markerTreasury,
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
  mapEnemyUnit,
  mapEnemyUnitYellow,
  mapEnemyUnitGreen,
  mapEnemyUnitBlue,
  mapEnemyUnitOrange,
  mapEnemyUnitBrown,
  mapEnemyUnitPurple,
  mapEnemyLeader,
  mapViking,
  mapMoor,
  mapCarolingianLeader,
  mapCharlemagne,
  mapMarquis,
  mapMarquisNoCrown,
  mapMarquisCrown,
  enemyBattle,
  enemyBattleFull,
  friendlyBattle,
  infantry,
  infantry1,
  infantry2,
  infantry3,
  infantry4,
  cavalry,
  cavalry2,
  cavalry3,
  cavalry4,
  churchFinished,
  byzantium,
  intrigue,
  turnEnd,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.poitiers0, Piece.markerVictoryPoints1],
    PieceType.map: [Piece.poitiers0, Piece.marquisCrown3],
    PieceType.mapEnemyUnit: [Piece.poitiers0, Piece.breton3],
    PieceType.mapEnemyUnitYellow: [Piece.poitiers0, Piece.gascony5],
    PieceType.mapEnemyUnitGreen: [Piece.lombardy0, Piece.bavaria3],
    PieceType.mapEnemyUnitBlue: [Piece.fulda0, Piece.burgundy3],
    PieceType.mapEnemyUnitOrange: [Piece.carinthia0, Piece.avars3],
    PieceType.mapEnemyUnitBrown: [Piece.saxonsI0, Piece.veleti3],
    PieceType.mapEnemyUnitPurple: [Piece.paris0, Piece.breton3],
    PieceType.mapEnemyLeader: [Piece.leaderPoitiers0, Piece.leaderBreton3],
    PieceType.mapViking: [Piece.viking0, Piece.viking5],
    PieceType.mapMoor: [Piece.moor0, Piece.moor5],
    PieceType.mapCarolingianLeader: [Piece.charlemagneOlder, Piece.marquisCrown3],
    PieceType.mapCharlemagne: [Piece.charlemagneYounger, Piece.charlemagneOlder],
    PieceType.mapMarquis: [Piece.marquisNoCrown0, Piece.marquisCrown3],
    PieceType.mapMarquisNoCrown: [Piece.marquisNoCrown0, Piece.marquisNoCrown3],
    PieceType.mapMarquisCrown: [Piece.marquisCrown0, Piece.marquisCrown3],
    PieceType.enemyBattleFull: [Piece.enemyBattleFull0, Piece.enemyBattleFull15],
    PieceType.friendlyBattle: [Piece.infantry1_0, Piece.cavalry4_7],
    PieceType.infantry: [Piece.infantry1_0, Piece.infantry4_7],
    PieceType.infantry1: [Piece.infantry1_0, Piece.infantry1_7],
    PieceType.infantry2: [Piece.infantry2_0, Piece.infantry2_7],
    PieceType.infantry3: [Piece.infantry3_0, Piece.infantry3_7],
    PieceType.infantry4: [Piece.infantry4_0, Piece.infantry4_7],
    PieceType.cavalry: [Piece.cavalry2_0, Piece.cavalry4_7],
    PieceType.cavalry2: [Piece.cavalry2_0, Piece.cavalry2_7],
    PieceType.cavalry3: [Piece.cavalry3_0, Piece.cavalry3_7],
    PieceType.cavalry4: [Piece.cavalry4_0, Piece.cavalry4_7],
    PieceType.churchFinished: [Piece.churchFinished0, Piece.churchFinished3],
    PieceType.byzantium: [Piece.byzantium0, Piece.byzantium3],
    PieceType.intrigue: [Piece.intrigue0, Piece.intrigue2],
    PieceType.turnEnd: [Piece.turnEnd0, Piece.turnEnd3],
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
      Scenario.standard: 'Standard (8 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<int> _enemyStackDepths = List<int>.filled(PieceType.mapEnemyUnit.count, -1);

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
   : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
   , _enemyStackDepths = List<int>.from(json['enemyStackDepths'])
   ;

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'enemyStackDepths': _enemyStackDepths,
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.poitiers0: Piece.leaderPoitiers0,
      Piece.poitiers1: Piece.leaderPoitiers1,
      Piece.poitiers2: Piece.leaderPoitiers2,
      Piece.poitiers3: Piece.leaderPoitiers3,
      Piece.poitiers4: Piece.leaderPoitiers4,
      Piece.bordeaux0: Piece.leaderBordeaux0,
      Piece.bordeaux1: Piece.leaderBordeaux1,
      Piece.bordeaux2: Piece.leaderBordeaux2,
      Piece.bordeaux3: Piece.leaderBordeaux3,
      Piece.bordeaux4: Piece.leaderBordeaux4,
      Piece.gascony0: Piece.leaderGascony0,
      Piece.gascony1: Piece.leaderGascony1,
      Piece.gascony2: Piece.leaderGascony2,
      Piece.gascony3: Piece.leaderGascony3,
      Piece.gascony4: Piece.leaderGascony4,
      Piece.gascony5: Piece.leaderGascony5,
      Piece.lombardy0: Piece.leaderLombardy0,
      Piece.lombardy1: Piece.leaderLombardy1,
      Piece.lombardy2: Piece.leaderLombardy2,
      Piece.lombardy3: Piece.leaderLombardy3,
      Piece.lombardy4: Piece.leaderLombardy4,
      Piece.friuli0: Piece.leaderFriuli0,
      Piece.friuli1: Piece.leaderFriuli1,
      Piece.friuli2: Piece.leaderFriuli2,
      Piece.friuli3: Piece.leaderFriuli3,
      Piece.bavaria0: Piece.leaderBavaria0,
      Piece.bavaria1: Piece.leaderBavaria1,
      Piece.bavaria2: Piece.leaderBavaria2,
      Piece.bavaria3: Piece.leaderBavaria3,
      Piece.fulda0: Piece.leaderBavaria3,
      Piece.burgundy0: Piece.leaderBurgundy0,
      Piece.burgundy1: Piece.leaderBurgundy1,
      Piece.burgundy2: Piece.leaderBurgundy2,
      Piece.burgundy3: Piece.leaderBurgundy3,
      Piece.carinthia0: Piece.leaderCarinthia0,
      Piece.carinthia1: Piece.leaderCarinthia1,
      Piece.carinthia2: Piece.leaderCarinthia2,
      Piece.carinthia3: Piece.leaderCarinthia3,
      Piece.croats0: Piece.leaderCroats0,
      Piece.croats1: Piece.leaderCroats1,
      Piece.croats2: Piece.leaderCroats2,
      Piece.croats3: Piece.leaderCroats3,
      Piece.moravia0: Piece.leaderMoravia0,
      Piece.moravia1: Piece.leaderMoravia1,
      Piece.moravia2: Piece.leaderMoravia2,
      Piece.moravia3: Piece.leaderMoravia3,
      Piece.avars0: Piece.leaderAvars0,
      Piece.avars1: Piece.leaderAvars1,
      Piece.avars2: Piece.leaderAvars2,
      Piece.avars3: Piece.leaderAvars3,
      Piece.saxonsI0: Piece.leaderSaxonsI0,
      Piece.saxonsI1: Piece.leaderSaxonsI1,
      Piece.saxonsI2: Piece.leaderSaxonsI2,
      Piece.saxonsI3: Piece.leaderSaxonsI3,
      Piece.saxonsI4: Piece.leaderSaxonsI4,
      Piece.saxonsI5: Piece.leaderSaxonsI5,
      Piece.saxonsII0: Piece.leaderSaxonsII0,
      Piece.saxonsII1: Piece.leaderSaxonsII1,
      Piece.saxonsII2: Piece.leaderSaxonsII2,
      Piece.saxonsII3: Piece.leaderSaxonsII3,
      Piece.saxonsII4: Piece.leaderSaxonsII4,
      Piece.saxonsII5: Piece.leaderSaxonsII5,
      Piece.veleti0: Piece.leaderVeleti0,
      Piece.veleti1: Piece.leaderVeleti1,
      Piece.veleti2: Piece.leaderVeleti2,
      Piece.veleti3: Piece.leaderVeleti3,
      Piece.breton0: Piece.leaderBreton0,
      Piece.breton1: Piece.leaderBreton1,
      Piece.breton2: Piece.leaderBreton2,
      Piece.breton3: Piece.leaderBreton3,
      Piece.leaderPoitiers0: Piece.poitiers0,
      Piece.leaderPoitiers1: Piece.poitiers1,
      Piece.leaderPoitiers2: Piece.poitiers2,
      Piece.leaderPoitiers3: Piece.poitiers3,
      Piece.leaderPoitiers4: Piece.poitiers4,
      Piece.leaderBordeaux0: Piece.bordeaux0,
      Piece.leaderBordeaux1: Piece.bordeaux1,
      Piece.leaderBordeaux2: Piece.bordeaux2,
      Piece.leaderBordeaux3: Piece.bordeaux3,
      Piece.leaderBordeaux4: Piece.bordeaux4,
      Piece.leaderGascony0: Piece.gascony0,
      Piece.leaderGascony1: Piece.gascony1,
      Piece.leaderGascony2: Piece.gascony2,
      Piece.leaderGascony3: Piece.gascony3,
      Piece.leaderGascony4: Piece.gascony4,
      Piece.leaderGascony5: Piece.gascony5,
      Piece.leaderLombardy0: Piece.lombardy0,
      Piece.leaderLombardy1: Piece.lombardy1,
      Piece.leaderLombardy2: Piece.lombardy2,
      Piece.leaderLombardy3: Piece.lombardy3,
      Piece.leaderLombardy4: Piece.lombardy4,
      Piece.leaderLombardy5: Piece.ironCrown,
      Piece.leaderFriuli0: Piece.friuli0,
      Piece.leaderFriuli1: Piece.friuli1,
      Piece.leaderFriuli2: Piece.friuli2,
      Piece.leaderFriuli3: Piece.friuli3,
      Piece.leaderBavaria0: Piece.bavaria0,
      Piece.leaderBavaria1: Piece.bavaria1,
      Piece.leaderBavaria2: Piece.bavaria2,
      Piece.leaderBavaria3: Piece.bavaria3,
      Piece.leaderBurgundy0: Piece.burgundy0,
      Piece.leaderBurgundy1: Piece.burgundy1,
      Piece.leaderBurgundy2: Piece.burgundy2,
      Piece.leaderBurgundy3: Piece.burgundy3,
      Piece.leaderCarinthia0: Piece.carinthia0,
      Piece.leaderCarinthia1: Piece.carinthia1,
      Piece.leaderCarinthia2: Piece.carinthia2,
      Piece.leaderCarinthia3: Piece.carinthia3,
      Piece.leaderCroats0: Piece.croats0,
      Piece.leaderCroats1: Piece.croats1,
      Piece.leaderCroats2: Piece.croats2,
      Piece.leaderCroats3: Piece.croats3,
      Piece.leaderMoravia0: Piece.moravia0,
      Piece.leaderMoravia1: Piece.moravia1,
      Piece.leaderMoravia2: Piece.moravia2,
      Piece.leaderMoravia3: Piece.moravia3,
      Piece.leaderAvars0: Piece.avars0,
      Piece.leaderAvars1: Piece.avars1,
      Piece.leaderAvars2: Piece.avars2,
      Piece.leaderAvars3: Piece.avars3,
      Piece.leaderSaxonsI0: Piece.saxonsI0,
      Piece.leaderSaxonsI1: Piece.saxonsI1,
      Piece.leaderSaxonsI2: Piece.saxonsI2,
      Piece.leaderSaxonsI3: Piece.saxonsI3,
      Piece.leaderSaxonsI4: Piece.saxonsI4,
      Piece.leaderSaxonsI5: Piece.saxonsI5,
      Piece.leaderSaxonsII0: Piece.saxonsII0,
      Piece.leaderSaxonsII1: Piece.saxonsII1,
      Piece.leaderSaxonsII2: Piece.saxonsII2,
      Piece.leaderSaxonsII3: Piece.saxonsII3,
      Piece.leaderSaxonsII4: Piece.saxonsII4,
      Piece.leaderSaxonsII5: Piece.saxonsII5,
      Piece.leaderVeleti0: Piece.veleti0,
      Piece.leaderVeleti1: Piece.veleti1,
      Piece.leaderVeleti2: Piece.veleti2,
      Piece.leaderVeleti3: Piece.veleti3,
      Piece.leaderBreton0: Piece.breton0,
      Piece.leaderBreton1: Piece.breton1,
      Piece.leaderBreton2: Piece.breton2,
      Piece.leaderBreton3: Piece.breton3,
      Piece.charlemagneYounger: Piece.charlemagneOlder,
      Piece.charlemagneOlder: Piece.charlemagneYounger,
      Piece.marquisNoCrown0: Piece.marquisCrown0,
      Piece.marquisNoCrown1: Piece.marquisCrown1,
      Piece.marquisNoCrown2: Piece.marquisCrown2,
      Piece.marquisNoCrown3: Piece.marquisCrown3,
      Piece.marquisCrown0: Piece.marquisNoCrown0,
      Piece.marquisCrown1: Piece.marquisNoCrown1,
      Piece.marquisCrown2: Piece.marquisNoCrown2,
      Piece.marquisCrown3: Piece.marquisNoCrown3,
      Piece.enemyBattleFull0: Piece.enemyBattleFlipped0,
      Piece.enemyBattleFull1: Piece.enemyBattleFlipped1,
      Piece.enemyBattleFull2: Piece.enemyBattleFlipped2,
      Piece.enemyBattleFull3: Piece.enemyBattleFlipped3,
      Piece.enemyBattleFull4: Piece.enemyBattleFlipped4,
      Piece.enemyBattleFull5: Piece.enemyBattleFlipped5,
      Piece.enemyBattleFull6: Piece.enemyBattleFlipped6,
      Piece.enemyBattleFull7: Piece.enemyBattleFlipped7,
      Piece.enemyBattleFull8: Piece.enemyBattleFlipped8,
      Piece.enemyBattleFull9: Piece.enemyBattleFlipped9,
      Piece.enemyBattleFull10: Piece.enemyBattleFlipped10,
      Piece.enemyBattleFull11: Piece.enemyBattleFlipped11,
      Piece.enemyBattleFull12: Piece.enemyBattleFlipped12,
      Piece.enemyBattleFull13: Piece.enemyBattleFlipped13,
      Piece.enemyBattleFull14: Piece.enemyBattleFlipped14,
      Piece.enemyBattleFull15: Piece.enemyBattleFlipped15,
      Piece.enemyBattleFlipped0: Piece.enemyBattleFull0,
      Piece.enemyBattleFlipped1: Piece.enemyBattleFull1,
      Piece.enemyBattleFlipped2: Piece.enemyBattleFull2,
      Piece.enemyBattleFlipped3: Piece.enemyBattleFull3,
      Piece.enemyBattleFlipped4: Piece.enemyBattleFull4,
      Piece.enemyBattleFlipped5: Piece.enemyBattleFull5,
      Piece.enemyBattleFlipped6: Piece.enemyBattleFull6,
      Piece.enemyBattleFlipped7: Piece.enemyBattleFull7,
      Piece.enemyBattleFlipped8: Piece.enemyBattleFull8,
      Piece.enemyBattleFlipped9: Piece.enemyBattleFull9,
      Piece.enemyBattleFlipped10: Piece.enemyBattleFull10,
      Piece.enemyBattleFlipped11: Piece.enemyBattleFull11,
      Piece.enemyBattleFlipped12: Piece.enemyBattleFull12,
      Piece.enemyBattleFlipped13: Piece.enemyBattleFull13,
      Piece.enemyBattleFlipped14: Piece.enemyBattleFull14,
      Piece.enemyBattleFlipped15: Piece.enemyBattleFull15,
      Piece.infantry1_0: Piece.infantry2_0,
      Piece.infantry1_1: Piece.infantry2_1,
      Piece.infantry1_2: Piece.infantry2_2,
      Piece.infantry1_3: Piece.infantry2_3,
      Piece.infantry1_4: Piece.infantry2_4,
      Piece.infantry1_5: Piece.infantry2_5,
      Piece.infantry1_6: Piece.infantry2_6,
      Piece.infantry1_7: Piece.infantry2_7,
      Piece.infantry2_0: Piece.infantry1_0,
      Piece.infantry2_1: Piece.infantry1_1,
      Piece.infantry2_2: Piece.infantry1_2,
      Piece.infantry2_3: Piece.infantry1_3,
      Piece.infantry2_4: Piece.infantry1_4,
      Piece.infantry2_5: Piece.infantry1_5,
      Piece.infantry2_6: Piece.infantry1_6,
      Piece.infantry2_7: Piece.infantry1_7,
      Piece.infantry3_0: Piece.infantry4_0,
      Piece.infantry3_1: Piece.infantry4_1,
      Piece.infantry3_2: Piece.infantry4_2,
      Piece.infantry3_3: Piece.infantry4_3,
      Piece.infantry3_4: Piece.infantry4_4,
      Piece.infantry3_5: Piece.infantry4_5,
      Piece.infantry3_6: Piece.infantry4_6,
      Piece.infantry3_7: Piece.infantry4_7,
      Piece.infantry4_0: Piece.infantry3_0,
      Piece.infantry4_1: Piece.infantry3_1,
      Piece.infantry4_2: Piece.infantry3_2,
      Piece.infantry4_3: Piece.infantry3_3,
      Piece.infantry4_4: Piece.infantry3_4,
      Piece.infantry4_5: Piece.infantry3_5,
      Piece.infantry4_6: Piece.infantry3_6,
      Piece.infantry4_7: Piece.infantry3_7,
      Piece.cavalry3_0: Piece.cavalry4_0,
      Piece.cavalry3_1: Piece.cavalry4_1,
      Piece.cavalry3_2: Piece.cavalry4_2,
      Piece.cavalry3_3: Piece.cavalry4_3,
      Piece.cavalry3_4: Piece.cavalry4_4,
      Piece.cavalry3_5: Piece.cavalry4_5,
      Piece.cavalry3_6: Piece.cavalry4_6,
      Piece.cavalry3_7: Piece.cavalry4_7,
      Piece.cavalry4_0: Piece.cavalry3_0,
      Piece.cavalry4_1: Piece.cavalry3_1,
      Piece.cavalry4_2: Piece.cavalry3_2,
      Piece.cavalry4_3: Piece.cavalry3_3,
      Piece.cavalry4_4: Piece.cavalry3_4,
      Piece.cavalry4_5: Piece.cavalry3_5,
      Piece.cavalry4_6: Piece.cavalry3_6,
      Piece.cavalry4_7: Piece.cavalry3_7,
      Piece.churchStarted0: Piece.churchFinished0,
      Piece.churchStarted1: Piece.churchFinished1,
      Piece.churchStarted2: Piece.churchFinished2,
      Piece.churchStarted3: Piece.churchFinished3,
      Piece.churchFinished0: Piece.churchStarted0,
      Piece.churchFinished1: Piece.churchStarted1,
      Piece.churchFinished2: Piece.churchStarted2,
      Piece.churchFinished3: Piece.churchStarted3,
      Piece.byzantinePeace: Piece.byzantineTension,
      Piece.byzantineTension: Piece.byzantinePeace,
      Piece.alAndalusPeace: Piece.alAndalusTension,
      Piece.alAndalusTension: Piece.alAndalusPeace,
      Piece.ironCrown: Piece.leaderLombardy5,
      Piece.drmP1: Piece.drmP1P2,
      Piece.drmP1P2: Piece.drmP1,
    };
    return pieceFlipSides[piece];
  }

  Location pieceLocation(Piece piece) {
    return _pieceLocations[piece.index];
  }

  int enemyStackDepth(Piece tribe) {
    return _enemyStackDepths[tribe.index - PieceType.mapEnemyUnit.firstIndex];
  }

  void redoStackDepths(Location location) {
    final enemyStackDepths = <(Piece, int)>[];
    Piece? newEnemy;
    for (final enemy in piecesInLocation(PieceType.mapEnemyUnit, location)) {
      int depth = _enemyStackDepths[enemy.index - PieceType.mapEnemyUnit.firstIndex];
      if (depth == -1) {
        newEnemy = enemy;
      } else {
        enemyStackDepths.add((enemy, depth));
      }
    }
    enemyStackDepths.sort((a, b) => a.$2.compareTo(b.$2));
    int depth = 0;
    for (depth = 0; depth < enemyStackDepths.length; ++depth) {
      _enemyStackDepths[enemyStackDepths[depth].$1.index - PieceType.mapEnemyUnit.firstIndex] = depth;
    }
    if (newEnemy != null) {
      _enemyStackDepths[newEnemy.index - PieceType.mapEnemyUnit.firstIndex] = depth;
      depth += 1;
    }
  }

  void setPieceLocation(Piece piece, Location location) {
    final oldLocation = _pieceLocations[piece.index];
    _pieceLocations[piece.index] = location;
    if (piece.isType(PieceType.mapEnemyUnit)) {
      _enemyStackDepths[piece.index - PieceType.mapEnemyUnit.firstIndex] = -1;
    }
    final obverse = pieceFlipSide(piece);
    if (obverse != null) {
      final oldFlippedLocation = _pieceLocations[obverse.index];
      _pieceLocations[obverse.index] = Location.flipped;
      if (obverse.isType(PieceType.mapEnemyUnit)) {
        _enemyStackDepths[obverse.index - PieceType.mapEnemyUnit.firstIndex] = -1;
        if (oldFlippedLocation.isType(LocationType.map)) {
          redoStackDepths(oldFlippedLocation);
        }
      }
    }
    if (piece.isType(PieceType.mapEnemyUnit)) {
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
      Location.aachen: [Location.fulda, Location.swabia, Location.reims, Location.saxons1],
      Location.burgundy: [Location.provence, Location.swabia, Location.poitiers, Location.lombardy],
      Location.fulda: [Location.aachen, Location.swabia, Location.veleti],
      Location.provence: [Location.burgundy],
      Location.swabia: [Location.aachen, Location.burgundy, Location.fulda, Location.bavaria],
      Location.paris: [Location.reims, Location.bretonMarch],
      Location.reims: [Location.aachen, Location.paris],
      Location.bretonMarch: [Location.paris],
      Location.bordeaux: [Location.gascony, Location.poitiers],
      Location.gascony: [Location.bordeaux, Location.bretonMarch],
      Location.poitiers: [Location.burgundy, Location.paris, Location.bordeaux],
      Location.spanishMarch: [Location.gascony],
      Location.bavaria: [Location.swabia, Location.friuli, Location.carinthia],
      Location.friuli: [Location.bavaria, Location.lombardy, Location.carinthia],
      Location.lombardy: [Location.friuli, Location.rome],
      Location.rome: [Location.lombardy],
      Location.avars: [Location.carinthia, Location.croats, Location.moravians],
      Location.carinthia: [Location.bavaria, Location.friuli, Location.avars, Location.croats],
      Location.croats: [Location.avars, Location.carinthia],
      Location.moravians: [Location.avars, Location.carinthia],
      Location.saxons1: [Location.aachen, Location.saxons2],
      Location.saxons2: [Location.saxons1, Location.veleti],
      Location.veleti: [Location.fulda, Location.veleti],
    };
    return adjacentSpaces[space]!.toList();
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
  
  Piece? spaceTopmostEnemyUnit(Location space) {
    Piece? topmost;
    int depth = -1;    
    for (final enemyUnit in piecesInLocation(PieceType.mapEnemyUnit, space)) {
      int pieceDepth = enemyStackDepth(enemyUnit);
      if (enemyStackDepth(enemyUnit) > depth) {
        topmost = enemyUnit;
        depth = pieceDepth;
      }
    }
    return topmost;
  }

  // Regions

  Location regionBox(Region region) {
    return Location.values[LocationType.boxRegion.firstIndex + region.index];
  }

  LocationType regionLocationType(Region region) {
    const regionLocationTypes = {
      Region.blue: LocationType.blueSpace,
      Region.purple: LocationType.purpleSpace,
      Region.yellow: LocationType.yellowSpace,
      Region.green: LocationType.greenSpace,
      Region.orange: LocationType.orangeSpace,
      Region.brown: LocationType.brownSpace,
    };
    return regionLocationTypes[region]!;
  }

  PieceType regionEnemyUnitPieceType(Region region) {
    const regionEnemyUnitPieceTypes = {
      Region.blue: PieceType.mapEnemyUnitBlue,
      Region.purple: PieceType.mapEnemyUnitPurple,
      Region.yellow: PieceType.mapEnemyUnitYellow,
      Region.green: PieceType.mapEnemyUnitGreen,
      Region.orange: PieceType.mapEnemyUnitOrange,
      Region.brown: PieceType.mapEnemyUnitBrown,
    };
    return regionEnemyUnitPieceTypes[region]!;
  }

  bool regionHasRoadsAndBridges(Region region) {
    for (final marquis in PieceType.mapMarquisCrown.pieces) {
      final location = pieceLocation(marquis);
      if (location.isType(LocationType.space)) {
        if (spaceRegion(location) == region) {
          return true;
        }
      }
    }
    return false;
  }

  int regionLeaderBonus(Region region) {
    int bonus = 0;
    final locationType = regionLocationType(region);
    for (final space in locationType.locations) {
      final leader = pieceInLocation(PieceType.mapEnemyLeader, space);
      if (leader != null) {
        int leaderBonus = enemyLeaderBonus(leader);
        if (leaderBonus > bonus) {
          bonus = leaderBonus;
        }
      }
    }
    return bonus;
  }

  // Enemies

  Location enemyHome(Piece enemy) {
    const enemyHomes = {
      Piece.poitiers0: Location.poitiers,
      Piece.poitiers1: Location.poitiers,
      Piece.poitiers2: Location.poitiers,
      Piece.poitiers3: Location.poitiers,
      Piece.poitiers4: Location.poitiers,
      Piece.bordeaux0: Location.bordeaux,
      Piece.bordeaux1: Location.bordeaux,
      Piece.bordeaux2: Location.bordeaux,
      Piece.bordeaux3: Location.bordeaux,
      Piece.bordeaux4: Location.bordeaux,
      Piece.gascony0: Location.gascony,
      Piece.gascony1: Location.gascony,
      Piece.gascony2: Location.gascony,
      Piece.gascony3: Location.gascony,
      Piece.gascony4: Location.gascony,
      Piece.gascony5: Location.gascony,
      Piece.lombardy0: Location.lombardy,
      Piece.lombardy1: Location.lombardy,
      Piece.lombardy2: Location.lombardy,
      Piece.lombardy3: Location.lombardy,
      Piece.lombardy4: Location.lombardy,
      Piece.friuli0: Location.friuli,
      Piece.friuli1: Location.friuli,
      Piece.friuli2: Location.friuli,
      Piece.friuli3: Location.friuli,
      Piece.bavaria0: Location.bavaria,
      Piece.bavaria1: Location.bavaria,
      Piece.bavaria2: Location.bavaria,
      Piece.bavaria3: Location.bavaria,
      Piece.fulda0: Location.fulda,
      Piece.fulda1: Location.fulda,
      Piece.swabia0: Location.swabia,
      Piece.swabia1: Location.swabia,
      Piece.swabia2: Location.swabia,
      Piece.provence0: Location.provence,
      Piece.provence1: Location.provence,
      Piece.provence2: Location.provence,
      Piece.burgundy0: Location.burgundy,
      Piece.burgundy1: Location.burgundy,
      Piece.burgundy2: Location.burgundy,
      Piece.burgundy3: Location.burgundy,
      Piece.carinthia0: Location.carinthia,
      Piece.carinthia1: Location.carinthia,
      Piece.carinthia2: Location.carinthia,
      Piece.carinthia3: Location.carinthia,
      Piece.croats0: Location.croats,
      Piece.croats1: Location.croats,
      Piece.croats2: Location.croats,
      Piece.croats3: Location.croats,
      Piece.moravia0: Location.moravians,
      Piece.moravia1: Location.moravians,
      Piece.moravia2: Location.moravians,
      Piece.moravia3: Location.moravians,
      Piece.avars0: Location.avars,
      Piece.avars1: Location.avars,
      Piece.avars2: Location.avars,
      Piece.avars3: Location.avars,
      Piece.saxonsI0: Location.saxons1,
      Piece.saxonsI1: Location.saxons1,
      Piece.saxonsI2: Location.saxons1,
      Piece.saxonsI3: Location.saxons1,
      Piece.saxonsI4: Location.saxons1,
      Piece.saxonsI5: Location.saxons1,
      Piece.saxonsII0: Location.saxons2,
      Piece.saxonsII1: Location.saxons2,
      Piece.saxonsII2: Location.saxons2,
      Piece.saxonsII3: Location.saxons2,
      Piece.saxonsII4: Location.saxons2,
      Piece.saxonsII5: Location.saxons2,
      Piece.veleti0: Location.veleti,
      Piece.veleti1: Location.veleti,
      Piece.veleti2: Location.veleti,
      Piece.veleti3: Location.veleti,
      Piece.paris0: Location.paris,
      Piece.paris1: Location.paris,
      Piece.reims0: Location.reims,
      Piece.reims1: Location.reims,
      Piece.breton0: Location.bretonMarch,
      Piece.breton1: Location.bretonMarch,
      Piece.breton2: Location.bretonMarch,
      Piece.breton3: Location.bretonMarch,
    };
    return enemyHomes[enemy]!;
  }

  int enemyUnitResistanceRating(Piece enemyUnit) {
    const enemyUnitResistanceRatings = {
      Piece.poitiers0: 3,
      Piece.poitiers1: 3,
      Piece.poitiers2: 3,
      Piece.poitiers3: 4,
      Piece.poitiers4: 4,
      Piece.bordeaux0: 4,
      Piece.bordeaux1: 4,
      Piece.bordeaux2: 4,
      Piece.bordeaux3: 5,
      Piece.bordeaux4: 5,
      Piece.gascony0: 5,
      Piece.gascony1: 5,
      Piece.gascony2: 5,
      Piece.gascony3: 5,
      Piece.gascony4: 5,
      Piece.gascony5: 5,
      Piece.lombardy0: 4,
      Piece.lombardy1: 4,
      Piece.lombardy2: 5,
      Piece.lombardy3: 5,
      Piece.lombardy4: 6,
      Piece.friuli0: 4,
      Piece.friuli1: 4,
      Piece.friuli2: 5,
      Piece.friuli3: 5,
      Piece.bavaria0: 4,
      Piece.bavaria1: 4,
      Piece.bavaria2: 5,
      Piece.bavaria3: 6,
      Piece.fulda0: 3,
      Piece.fulda1: 3,
      Piece.swabia0: 3,
      Piece.swabia1: 3,
      Piece.swabia2: 4,
      Piece.provence0: 3,
      Piece.provence1: 4,
      Piece.provence2: 4,
      Piece.burgundy0: 3,
      Piece.burgundy1: 3,
      Piece.burgundy2: 4,
      Piece.burgundy3: 4,
      Piece.carinthia0: 3,
      Piece.carinthia1: 4,
      Piece.carinthia2: 5,
      Piece.carinthia3: 5,
      Piece.croats0: 4,
      Piece.croats1: 4,
      Piece.croats2: 5,
      Piece.croats3: 5,
      Piece.moravia0: 5,
      Piece.moravia1: 5,
      Piece.moravia2: 6,
      Piece.moravia3: 6,
      Piece.avars0: 5,
      Piece.avars1: 6,
      Piece.avars2: 6,
      Piece.avars3: 6,
      Piece.saxonsI0: 6,
      Piece.saxonsI1: 6,
      Piece.saxonsI2: 6,
      Piece.saxonsI3: 6,
      Piece.saxonsI4: 7,
      Piece.saxonsI5: 7,
      Piece.saxonsII0: 6,
      Piece.saxonsII1: 6,
      Piece.saxonsII2: 6,
      Piece.saxonsII3: 7,
      Piece.saxonsII4: 7,
      Piece.saxonsII5: 7,
      Piece.veleti0: 5,
      Piece.veleti1: 5,
      Piece.veleti2: 6,
      Piece.veleti3: 6,
      Piece.paris0: 4,
      Piece.paris1: 5,
      Piece.reims0: 3,
      Piece.reims1: 4,
      Piece.breton0: 4,
      Piece.breton1: 4,
      Piece.breton2: 5,
      Piece.breton3: 5,
    };
    return enemyUnitResistanceRatings[enemyUnit]!;
  }

  // Enemy Leaders

  int enemyLeaderBonus(Piece enemyLeader) {
    const enemyLeaderBonuses = {
      Piece.leaderPoitiers0: 1,
      Piece.leaderPoitiers1: 1,
      Piece.leaderPoitiers2: 1,
      Piece.leaderPoitiers3: 2,
      Piece.leaderPoitiers4: 2,
      Piece.leaderBordeaux0: 1,
      Piece.leaderBordeaux1: 1,
      Piece.leaderBordeaux2: 1,
      Piece.leaderBordeaux3: 2,
      Piece.leaderBordeaux4: 2,
      Piece.leaderGascony0: 1,
      Piece.leaderGascony1: 1,
      Piece.leaderGascony2: 1,
      Piece.leaderGascony3: 2,
      Piece.leaderGascony4: 2,
      Piece.leaderGascony5: 2,
      Piece.leaderLombardy0: 1,
      Piece.leaderLombardy1: 1,
      Piece.leaderLombardy2: 1,
      Piece.leaderLombardy3: 1,
      Piece.leaderLombardy4: 1,
      Piece.leaderLombardy5: 3,
      Piece.leaderFriuli0: 1,
      Piece.leaderFriuli1: 1,
      Piece.leaderFriuli2: 2,
      Piece.leaderFriuli3: 2,
      Piece.leaderBavaria0: 1,
      Piece.leaderBavaria1: 1,
      Piece.leaderBavaria2: 2,
      Piece.leaderBavaria3: 2,
      Piece.leaderBurgundy0: 1,
      Piece.leaderBurgundy1: 1,
      Piece.leaderBurgundy2: 2,
      Piece.leaderBurgundy3: 2,
      Piece.leaderCarinthia0: 1,
      Piece.leaderCarinthia1: 1,
      Piece.leaderCarinthia2: 1,
      Piece.leaderCarinthia3: 1,
      Piece.leaderCroats0: 1,
      Piece.leaderCroats1: 1,
      Piece.leaderCroats2: 1,
      Piece.leaderCroats3: 1,
      Piece.leaderMoravia0: 1,
      Piece.leaderMoravia1: 1,
      Piece.leaderMoravia2: 2,
      Piece.leaderMoravia3: 2,
      Piece.leaderAvars0: 1,
      Piece.leaderAvars1: 2,
      Piece.leaderAvars2: 2,
      Piece.leaderAvars3: 2,
      Piece.leaderSaxonsI0: 2,
      Piece.leaderSaxonsI1: 2,
      Piece.leaderSaxonsI2: 2,
      Piece.leaderSaxonsI3: 2,
      Piece.leaderSaxonsI4: 3,
      Piece.leaderSaxonsI5: 3,
      Piece.leaderSaxonsII0: 2,
      Piece.leaderSaxonsII1: 2,
      Piece.leaderSaxonsII2: 2,
      Piece.leaderSaxonsII3: 2,
      Piece.leaderSaxonsII4: 3,
      Piece.leaderSaxonsII5: 3,
      Piece.leaderVeleti0: 1,
      Piece.leaderVeleti1: 1,
      Piece.leaderVeleti2: 2,
      Piece.leaderVeleti3: 2,
      Piece.leaderBreton0: 1,
      Piece.leaderBreton1: 1,
      Piece.leaderBreton2: 2,
      Piece.leaderBreton3: 2,
    };
    return enemyLeaderBonuses[enemyLeader]!;
  }

  // Charlemagne

  Piece get charlemagne {
    return pieceLocation(Piece.charlemagneYounger) != Location.flipped ? Piece.charlemagneYounger : Piece.charlemagneOlder;
  }

  // Carolingian Leaders

  List<Location> actionAdjacentLocations(Piece leader, Location leaderLocation) {
    List<Location> range = <Location>[];
    if (!leaderLocation.isType(LocationType.space)) {
      return range;
    }
    final leaderRegion = spaceRegion(leaderLocation);
    if (regionHasRoadsAndBridges(leaderRegion)) {
      final locationType = regionLocationType(leaderRegion);
      range = locationType.locations;
    }
    for (final space in spaceAndAdjacentSpaces(leaderLocation)) {
      if (!range.contains(space)) {
        final otherRegion = spaceRegion(space);
        if (leader.isType(PieceType.mapCharlemagne) || otherRegion == leaderRegion) {
          range.add(space);
          if (otherRegion != leaderRegion && regionHasRoadsAndBridges(otherRegion)) {
            final otherLocationType = regionLocationType(otherRegion);
            for (final otherRegionSpace in otherLocationType.locations) {
              if (!range.contains(otherRegionSpace)) {
                range.add(otherRegionSpace);
              }
            }
          }
        }
      }
    }
    return range;
  }

  List<Location> carolingianLeaderRange(Piece leader) {
    return actionAdjacentLocations(leader, pieceLocation(leader));
  }

  // Church

  int get churchFinishedCount {
    int count = 0;
    for (final church in PieceType.churchFinished.pieces) {
      final location = pieceLocation(church);
      if (location.isType(LocationType.boxChurch)) {
        count += 1;
      }
    }
    return count;
  }

  // Treasury

  Location treasuryBox(int value) {
    return Location.values[Location.treasury0.index + value];
  }

  int get treasury {
    return pieceLocation(Piece.markerTreasury).index - LocationType.treasury.firstIndex;
  }

  void adjustTreasury(int delta) {
    int newValue = treasury + delta;
    if (newValue < 0) {
      newValue = 0;
    }
    if (newValue > 30) {
      newValue = 30;
    }
    setPieceLocation(Piece.markerTreasury, treasuryBox(newValue));
  }

  // Taxation

  int get taxation {
    return pieceLocation(Piece.markerTaxes).index - LocationType.treasury.firstIndex;
  }

  // Victory Points

  Location victoryPointsBox(int value) {
    return Location.values[Location.victory0.index + value];
  }

  int victoryPointsBoxValue(Location box) {
    return box.index - Location.victory0.index;
  }

  int get victoryPoints {
    return victoryPointsBoxValue(pieceLocation(Piece.markerVictoryPoints10)) * 10 + victoryPointsBoxValue(pieceLocation(Piece.markerVictoryPoints1));
  }

  void adjustVictoryPoints(int delta) {
    int newValue = victoryPoints + delta;
    if (newValue > 99) {
      newValue = 99;
    }
    if (newValue < 0) {
      newValue = 0;
    }
    setPieceLocation(Piece.markerVictoryPoints10, victoryPointsBox(newValue ~/ 10));
    setPieceLocation(Piece.markerVictoryPoints1, victoryPointsBox(newValue % 10));
  }

  Location emergencyVictoryPointBox(int value) {
    return Location.values[Location.evp0.index + value];
  }

  int get emergencyVictoryPoints {
    return pieceLocation(Piece.markerEvp).index - Location.evp0.index;
  }

  void adjustEmergencyVictoryPoints(int delta) {
    int newValue = emergencyVictoryPoints + delta;
    if (newValue > 9) {
      newValue = 9;
    }
    if (newValue < 0) {
      newValue = 0;
    }
    setPieceLocation(Piece.markerEvp, emergencyVictoryPointBox(newValue));
  }

  // Turns

  int get currentTurn {
    return pieceLocation(Piece.markerGameTurn).index - LocationType.turn.firstIndex + 1;
  }

  String turnName(int turn) {
    return '$turn';
  }

  int turnVictoryThreshold(int turn) {
    const victoryThresholds = {
      1: 3,
      2: 8,
      3: 13,
      4: 19,
      5: 25,
      6: 35,
      7: 45,
      8: 60,
      9: 75,
      10: 90,
      11: 110,
      12: 135,
    };
    return victoryThresholds[turn]!;
  }

  // Tactical

  Location enemyRightBox(int index) {
    return Location.values[LocationType.boxTacticalEnemyRight.firstIndex + index];
  }

  Location enemyLeftBox(int index) {
    return Location.values[LocationType.boxTacticalEnemyLeft.firstIndex + index];
  }

  Location yourLeftBox(int index) {
    return Location.values[LocationType.boxTacticalYourLeft.firstIndex + index];
  }

  Location yourRightBox(int index) {
    return Location.values[LocationType.boxTacticalYourRight.firstIndex + index];
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

    final greenEnemies = PieceType.mapEnemyUnitGreen.pieces;
    greenEnemies.shuffle(random);
    int lombardyCount = 0;
    for (final enemy in greenEnemies) {
      if (lombardyCount < 3) {
        final home = state.enemyHome(enemy);
        state.setPieceLocation(enemy, home);
        if (home == Location.lombardy) {
          lombardyCount += 1;
        }
      } else {
        state.setPieceLocation(enemy, Location.cupHostile);
      }
    }

    state.setPieceLocation(Piece.leaderLombardy5, Location.lombardy);
    state.setPieceLocation(Piece.papalApprovalN1, Location.rome);

    final yellowEnemies = PieceType.mapEnemyUnitYellow.pieces;
    yellowEnemies.shuffle(random);
    int yellowCount = 0;
    for (final enemy in yellowEnemies) {
      if (yellowCount < 4) {
        final home = state.enemyHome(enemy);
        state.setPieceLocation(enemy, home);
        yellowCount += 1;
      } else {
        state.setPieceLocation(enemy, Location.cupUnfriendly);
      }
    }

    final purpleEnemies = PieceType.mapEnemyUnitPurple.pieces;
    purpleEnemies.shuffle(random);
    int purpleCount = 0;
    for (final enemy in purpleEnemies) {
      if (purpleCount < 4) {
        final home = state.enemyHome(enemy);
        state.setPieceLocation(enemy, home);
        purpleCount += 1;
      } else {
        state.setPieceLocation(enemy, Location.cupUnfriendly);
      }
    }

    state.setupPieceTypes([
      (PieceType.mapEnemyUnitBlue, Location.cupFriendly),
      (PieceType.intrigue, Location.cupFriendly),
      (PieceType.mapViking, Location.cupFriendly),
      (PieceType.mapMoor, Location.cupFriendly),
      (PieceType.byzantium, Location.cupFriendly),
      (PieceType.enemyBattleFull, Location.cupBattle),
      (PieceType.infantry1, Location.poolForce),
      (PieceType.infantry3, Location.poolForce),
      (PieceType.cavalry2, Location.poolForce),
      (PieceType.cavalry3, Location.poolForce),
    ]);

    state.setupPieces([
      (Piece.charlemagneYounger, Location.aachen),
      (Piece.turnEnd0, Location.cupHostile),
      (Piece.turnEnd1, Location.cupHostile),
      (Piece.markerEvp, Location.evp0),
      (Piece.alAndalusPeace, Location.boxAlAndalus),
      (Piece.byzantinePeace, Location.boxByzantine),
      (Piece.infantry1_0, Location.boxTacticalYourReserve),
      (Piece.infantry1_1, Location.boxTacticalYourReserve),
      (Piece.infantry1_2, Location.boxTacticalYourReserve),
      (Piece.infantry1_3, Location.boxTacticalYourReserve),
      (Piece.infantry2_4, Location.boxTacticalYourReserve),
      (Piece.infantry2_5, Location.boxTacticalYourReserve),
      (Piece.infantry2_6, Location.boxTacticalYourReserve),
      (Piece.infantry2_7, Location.boxTacticalYourReserve),
      (Piece.infantry3_0, Location.boxTacticalYourReserve),
      (Piece.infantry3_1, Location.boxTacticalYourReserve),
      (Piece.infantry3_2, Location.boxTacticalYourReserve),
      (Piece.infantry3_3, Location.boxTacticalYourReserve),
      (Piece.cavalry2_0, Location.boxTacticalYourReserve),
      (Piece.cavalry2_1, Location.boxTacticalYourReserve),
      (Piece.cavalry2_2, Location.boxTacticalYourReserve),
      (Piece.cavalry2_3, Location.boxTacticalYourReserve),
      (Piece.cavalry3_0, Location.boxTacticalYourReserve),
      (Piece.cavalry3_1, Location.boxTacticalYourReserve),
      (Piece.cavalry3_2, Location.boxTacticalYourReserve),
      (Piece.cavalry3_3, Location.boxTacticalYourReserve),
      (Piece.markerGameTurn, Location.turn1),
      (Piece.markerTreasury, Location.treasury5),
      (Piece.markerTaxes, Location.treasury4),
      (Piece.markerVictoryPoints1, Location.victory0),
      (Piece.markerVictoryPoints10, Location.victory0),
      (Piece.turnEnd2, Location.turn4),
      (Piece.turnEnd3, Location.turn8),
    ]);

    return state;
  }
}

enum Choice {
  purchaseInfantry,
  purchaseCavalry,
  promoteInfantry1,
  promoteInfantry2,
  actionSuppress,
  actionBattle,
  actionForcedMarch,
  actionSiege,
  actionGift,
  actionMarquis,
  actionForcedConversion,
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
  defeatIntrigue,
  defeatMoors,
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
  levy,
  campaign,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateLevy extends PhaseState {
  int purchaseInfantryCount = 0;
  int purchaseCavalryCount = 0;

  PhaseStateLevy();

  PhaseStateLevy.fromJson(Map<String, dynamic> json)
    : purchaseInfantryCount = json['purchaseInfantryCount'] as int
    , purchaseCavalryCount = json['purchaseCavalryCount'] as int
    ;

  @override
  Map<String, dynamic> toJson() => {
    'purchaseInfantryCount': purchaseInfantryCount,
    'purchaseCavalryCount': purchaseCavalryCount,
  };

  @override
  Phase get phase {
    return Phase.levy;
  }
}

class PhaseStateCampaign extends PhaseState {
  Piece? leader;

  PhaseStateCampaign();

  PhaseStateCampaign.fromJson(Map<String, dynamic> json)
    : leader = pieceFromIndex(json['leader'] as int?)
    ;
  
  @override
  Map<String, dynamic> toJson() => {
    'leader': pieceToIndex(leader),
  };

  @override
  Phase get phase {
    return Phase.campaign;
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

class BattleState {
  Location space;
  bool ambush;
  int subStep = 0;
  int rightCount = 0;
  int leftCount = 0;
  int cupAdjustmentCount = 0;

  BattleState(this.space, this.ambush);

  BattleState.fromJson(Map<String, dynamic> json)
    : space = locationFromIndex(json['space'] as int)!
    , ambush = json['ambush'] as bool
    , subStep = json['subStep'] as int
    , rightCount = json['rightCount'] as int
    , leftCount = json['leftCount'] as int
    , cupAdjustmentCount = json['cupAdjustmentCount'] as int
    ;

  Map<String, dynamic> toJson() => {
    'space': locationToIndex(space),
    'ambush': ambush,
    'subStep': subStep,
    'rightCount': rightCount,
    'leftCount': leftCount,
    'cupAdjustmentCount': cupAdjustmentCount,
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
  BattleState? _battleState;
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
      case Phase.levy:
        _phaseState = PhaseStateLevy.fromJson(phaseStateJson);
      case Phase.campaign:
        _phaseState = PhaseStateCampaign.fromJson(phaseStateJson);
      }
    }

    final reactionStateJson = json['reaction'];
    if (reactionStateJson != null) {
      _reactionState = ReactionState.fromJson(reactionStateJson);
    }
    final battleStateJson = json['battle'];
    if (battleStateJson != null) {
      _battleState = BattleState.fromJson(battleStateJson);
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
    if (_battleState != null) {
      map['battle'] = _battleState!.toJson();
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
    return '![](resource:assets/images/d8_$die.png)';
  }

  int rollD8() {
    int die = _random.nextInt(8) + 1;
    return die;
  }

  void logD8(int die) {
    logLine('>');
    logLine('>${dieFace(die)}');
    logLine('>');
  }

  void logD8InTable(int die) {
    logLine('>|${dieFace(die)}|$die|');
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

  void adjustTreasury(int delta) {
    _state.adjustTreasury(delta);
    if (delta > 0) {
      logLine('>Treasury: +$delta → ${_state.treasury}');
    } else if (delta < 0) {
      logLine('>Treasury: $delta → ${_state.treasury}');
    }
  }

  void adjustVictoryPoints(int delta) {
    _state.adjustVictoryPoints(delta);
    if (delta > 0) {
      logLine('>Victory Points: +$delta → ${_state.victoryPoints}');
    } else if (delta < 0) {
      logLine('>Victory Points: $delta → ${_state.victoryPoints}');
    }
  }

  void adjustEmergencyVictoryPoints(int delta) {
    _state.adjustEmergencyVictoryPoints(delta);
    if (delta > 0) {
      logLine('>Emergency Victory Points: +$delta → ${_state.emergencyVictoryPoints}');
    } else if (delta < 0) {
      logLine('>Emergency Victory Points: $delta → ${_state.emergencyVictoryPoints}');
    }
  }

  // High-Level Functions

  int get levyLimitCount {
    int limit = 1;
    for (final marquis in PieceType.mapMarquis.pieces) {
      final location = _state.pieceLocation(marquis);
      if (location != Location.flipped && location != Location.offmap) {
        limit += 1;
      }
    }
    if (_state.pieceLocation(Piece.ironCrown) != Location.flipped) {
      limit += 1;
    }
    if (_state.pieceLocation(Piece.charlemagneOlder) != Location.flipped) {
      limit += 1;
    }
    return limit;
  }

  List<Location> candidateLeaderSuppressLocations(Piece leader) {
    final candidates = <Location>[];
    for (final space in _state.carolingianLeaderRange(leader)) {
      if (_state.piecesInLocationCount(PieceType.mapEnemyLeader, space) == 0) {
        final enemyUnitCount = _state.piecesInLocationCount(PieceType.mapEnemyUnit, space);
        if (enemyUnitCount >= 1 && enemyUnitCount <= 2) {
          candidates.add(space);
        }
      }
    }
    return candidates;
  }

  List<Location> candidateLeaderBattleLocations(Piece leader) {
    final candidates = <Location>[];
    if (leader.isType(PieceType.mapCharlemagne)) {
      for (final space in _state.carolingianLeaderRange(leader)) {
        final enemyUnitCount = _state.piecesInLocationCount(PieceType.mapEnemyUnit, space);
        if (enemyUnitCount >= 2) {
          candidates.add(space);
        }
      }
    }
    return candidates;
  }

  List<Location> candidateLeaderForcedMarchLocations(Piece leader) {
    final candidates = <Location>[];
    final originalLocation = _state.pieceLocation(leader);
    for (final space in _state.carolingianLeaderRange(leader)) {
      if (space != originalLocation) {
        final enemyUnitCount = _state.piecesInLocationCount(PieceType.mapEnemyUnit, space);
        final moorsCount = _state.piecesInLocationCount(PieceType.mapMoor, space);
        if (enemyUnitCount == 0 && moorsCount == 0) {
          if (!candidates.contains(space)) {
            candidates.add(space);
            for (final otherSpace in _state.actionAdjacentLocations(leader, space)) {
              final enemyUnitCount = _state.piecesInLocationCount(PieceType.mapEnemyUnit, otherSpace);
              final moorsCount = _state.piecesInLocationCount(PieceType.mapMoor, otherSpace);
              if (enemyUnitCount == 0 && moorsCount == 0) {
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

  List<Location> candidateLeaderSiegeLocations(Piece leader) {
    final candidates = <Location>[];
    for (final space in _state.carolingianLeaderRange(leader)) {
      final enemyLeaderCount = _state.piecesInLocationCount(PieceType.mapEnemyLeader, space);
      if (enemyLeaderCount >= 1) {
        candidates.add(space);
      }
    }
    return candidates;
  }

  List<Location> candidateLeaderGiftLocations(Piece leader) {
    final candidates = <Location>[];
    for (final space in _state.carolingianLeaderRange(leader)) {
      final enemyCount = _state.piecesInLocationCount(PieceType.mapEnemyUnit, space);
      final leaderCount = _state.piecesInLocationCount(PieceType.mapEnemyLeader, space);
      if (enemyCount > 0 && leaderCount == 0) {
        candidates.add(space);
      }
    }
    return candidates;
  }

  List<Location> candidateLeaderMarquisLocations(Piece leader) {
    final candidates = <Location>[];
    if (leader.isType(PieceType.mapCharlemagne)) {
      final marquisOffMapCount = _state.piecesInLocationCount(PieceType.mapMarquisNoCrown, Location.offmap);
      final marquisOnMapCount = PieceType.mapMarquisNoCrown.count - marquisOffMapCount;
      if (marquisOffMapCount > 0 && marquisOnMapCount < _state.churchFinishedCount + 2) {
        for (final space in _state.carolingianLeaderRange(leader)) {
          final enemyCount = _state.piecesInLocationCount(PieceType.mapEnemyUnit, space);
          if (enemyCount == 0) {
            final region = _state.spaceRegion(space);
            if (_state.regionLeaderBonus(region) == 0) {
              candidates.add(space);
            }
          }
        }
      }
    }
    return candidates;
  }

  List<Location> candidateLeaderForcedConversionLocations(Piece leader) {
    final candidates = <Location>[];
    for (final space in _state.carolingianLeaderRange(leader)) {
      final region = _state.spaceRegion(space);
      if ([Region.orange, Region.brown].contains(region)) {
        final enemyCount = _state.piecesInLocationCount(PieceType.mapEnemyUnit, space);
        if (enemyCount > 0) {
          candidates.add(space);
        }
      }
    }
    return candidates;
  }

  void cupAdjustment(Location from, Location to) {
    final piece = randPiece(_state.piecesInLocation(PieceType.all, from));
    if (piece != null) {
      logLine('>A chit moves from ${from.desc} to ${to.desc}.');
      return;
    }
    if (from == Location.cupFriendly) {
      cupAdjustment(Location.cupUnfriendly, Location.cupHostile);
    }
  }

  void reactionEnemyUnit(Piece enemyUnit) {
    logLine('### ${enemyUnit.desc} becomes Hostile.');
    final space = _state.enemyHome(enemyUnit);
    if (_state.piecesInLocationCount(PieceType.mapMoor, space) > 0) {
      logLine('>Uprising in ${space.desc} is suppressed by the Moors.');
      _state.setPieceLocation(enemyUnit, Location.poolDead);
      return;
    }
    if (_state.pieceLocation(_state.charlemagne) == space) {
      logLine('>Uprising in ${space.desc} is suppressed by Charlemagne.');
      _state.setPieceLocation(enemyUnit, Location.poolDead);
      return;
    }
    if (_state.piecesInLocationCount(PieceType.mapMarquis, space) > 0) {
      int die = rollD8();

      logTableHeader();
      logD8InTable(die);
      int rating = _state.enemyUnitResistanceRating(enemyUnit);
      logLine('>|${enemyUnit.desc}|$rating|');
      logTableFooter();

      if (die > rating) {
        logLine('>Uprising in ${space.desc} is suppressed by Marquis.');
        _state.setPieceLocation(enemyUnit, Location.poolDead);
      } else {
        logLine('>Uprising continues in defiance of the Marquis.');
        _state.setPieceLocation(enemyUnit, space);
      }
      return;
    }
    final enemyUnitCount = _state.piecesInLocationCount(PieceType.mapEnemyUnit, space);
    final enemyLeaderCount = _state.piecesInLocationCount(PieceType.mapEnemyLeader, space);
    if (enemyUnitCount >= 3 && enemyLeaderCount == 0) {
      final enemyLeader = _state.pieceFlipSide(enemyUnit)!;
      logLine('> ${enemyLeader.desc} leads the uprising in ${space.desc}.');
      _state.setPieceLocation(enemyLeader, space);
      return;
    }
    if (enemyUnitCount >= 1) {
      logLine('>${enemyUnit.desc} joins the uprising in ${space.desc}.');
    } else {
      logLine('>${enemyUnit.desc} starts an uprising in ${space.desc}.');
    }
    _state.setPieceLocation(enemyUnit, space);
  }

  void reactionMoors(Piece moors) {
    logLine('### Moors');
    if (_state.pieceLocation(Piece.alAndalusTension) == Location.flipped) {
      logLine('>Relationship with the Moors in al Andalus becomes tense.');
      _state.setPieceLocation(Piece.alAndalusTension, Location.boxAlAndalus);
    }
    for (final space in [Location.spanishMarch, Location.gascony, Location.bordeaux, Location.poitiers]) {
      final charlemagne = _state.pieceInLocation(PieceType.mapCharlemagne, space);
      if (charlemagne != null) {
        battle(space, true);
        return;
      }
      final marquis = _state.pieceInLocation(PieceType.mapMarquis, space);
      int moorsCount = _state.piecesInLocationCount(PieceType.mapMoor, space);
      if (moorsCount == 1 && space == Location.poitiers) {
        throw GameOverException(GameResult.defeatMoors, 0);
      }
      if (moorsCount == 0 || (marquis != null && moorsCount == 1)) {
        logLine('>Moors move to ${space.desc}');
        _state.setPieceLocation(moors, space);
        return;
      }
    }
  }

  void reactionViking(Piece viking) {
    logLine('### Vikings');
    final region = _state.piecesInLocationCount(PieceType.mapViking, Location.boxRegionPurple) < 2 ? Region.purple : Region.blue;
    final regionBox = _state.regionBox(region);
    logLine('>Vikings terrorize ${regionBox.desc}.');
    _state.setPieceLocation(viking, regionBox);
    final pieceType = _state.regionEnemyUnitPieceType(region);
    for (final enemyUnit in pieceType.pieces) {
      if (_state.pieceLocation(enemyUnit) == Location.poolDead) {
        _state.setPieceLocation(enemyUnit, Location.cupHostile);
      }
    }
  }

  void reactionByzantium(Piece byzantium) {
    logLine('### Byzantium');
    if (_state.pieceLocation(Piece.byzantinePeace) == Location.boxByzantine) {
      logLine('>Relationships with Byzantium become tense.');
      _state.setPieceLocation(Piece.byzantineTension, Location.boxByzantine);
      _state.setPieceLocation(byzantium, Location.poolDead);
      return;
    }
    logLine('>Tensions with Byzantium worsen.');
    _state.setPieceLocation(byzantium, Location.poolDead);
    int moorsCount = 0;
    for (final space in [Location.spanishMarch, Location.gascony, Location.bordeaux, Location.poitiers]) {
      if (_state.piecesInLocationCount(PieceType.mapMoor, space) > 0) {
        moorsCount += 1;
      }
    }
    if (moorsCount > 0) {
      logLine('>Moors: -$moorsCount');
    }
    int leaderCount = 0;
    for (final region in Region.values) {
      if (_state.regionLeaderBonus(region) > 0) {
        leaderCount += 1;
      }
    }
    if (leaderCount > 0) {
      logLine('>Regions with Enemy Leaders: -$leaderCount');
    }
    int byzantiumCount = _state.piecesInLocationCount(PieceType.byzantium, Location.poolDead);
    logLine('>Byzantium Tension: -$byzantiumCount');
    int total = moorsCount + leaderCount + byzantiumCount;
    adjustVictoryPoints(-total);
  }

  void reactionIntrigue(Piece intrigue) {
    logLine('### Intrigue');
    int threshold = _state.turnVictoryThreshold(_state.currentTurn);
    int shortfall = threshold - _state.victoryPoints;
    if (shortfall > 0) {
      shortfall -= _state.taxation;
    }
    if (shortfall > 0) {
      int amount = min(shortfall, _state.treasury);
      adjustTreasury(-amount);
      shortfall -= amount;
    }
    if (shortfall > 0) {
      int amount = min(shortfall, _state.emergencyVictoryPoints);
      adjustEmergencyVictoryPoints(-amount);
      shortfall -= amount;
    }
    if (shortfall > 0) {
      throw GameOverException(GameResult.defeatIntrigue, 0);
    }
    logLine('>Plot to overthrow Charlemagne is overcome.');
    _state.setPieceLocation(intrigue, Location.poolDead);
  }

  void reactionTurnEnd(Piece turnEnd) {
    logLine('### Turn End');
    _state.setPieceLocation(turnEnd, Location.poolDead);
    int count = _state.piecesInLocationCount(PieceType.turnEnd, Location.poolDead);
    if (count == 1) {
      logLine('>1 Turn End marker is in the Dead Pool.');
    } else {
      logLine('>$count Turn End markers are in the Dead Pool.');
    }
  }

  void reaction() {
    _reactionState ??= ReactionState();
    final piece = randPiece(_state.piecesInLocation(PieceType.all, Location.cupHostile))!;
    if (piece.isType(PieceType.mapEnemyUnit)) {
      reactionEnemyUnit(piece);
    } else if (piece.isType(PieceType.mapMoor)) {
      reactionMoors(piece);
    } else if (piece.isType(PieceType.mapViking)) {
      reactionViking(piece);
    } else if (piece.isType(PieceType.byzantium)) {
      reactionByzantium(piece);
    } else if (piece.isType(PieceType.intrigue)) {
      reactionIntrigue(piece);
    } else if (piece.isType(PieceType.turnEnd)) {
      reactionTurnEnd(piece);
    }
    _reactionState = null;
  }

  (int,int,int) enemyFormationTable(Piece? enemyUnit, int modifiedDie) {
    if (enemyUnit == null) {
      const moorsTable = {
        1: (4,3,1),
        2: (4,4,1),
        3: (5,4,1),
        4: (5,5,1),
        5: (6,5,2),
        6: (6,5,2),
        7: (6,6,2),
        8: (6,6,2),
      };
      return moorsTable[modifiedDie]!;
    } else if (enemyUnit.isType(PieceType.mapEnemyUnitBlue)) {
      const blueTable = {
        4: (3,3,0),
        5: (3,3,0),
        6: (3,3,0),
        7: (3,3,1),
        8: (3,3,1),
        9: (4,3,1),
        10: (4,3,1),
        11: (4,4,1),
        12: (4,4,1),
        13: (5,4,2),
        14: (5,4,2),
      };
      return blueTable[modifiedDie]!;
    } else if (enemyUnit.isType(PieceType.mapEnemyUnitYellow)) {
      const yellowTable = {
        4: (3,3,1),
        5: (3,3,1),
        6: (4,3,1),
        7: (4,3,1),
        8: (4,4,1),
        9: (4,4,1),
        10: (5,4,2),
        11: (5,4,2),
        12: (5,5,2),
        13: (5,5,2),
        14: (6,5,3),
        15: (6,5,3),
      };
      return yellowTable[modifiedDie]!;
    } else if (enemyUnit.isType(PieceType.mapEnemyUnitPurple)) {
      const purpleTable = {
        4: (3,3,1),
        5: (4,3,1),
        6: (4,3,1),
        7: (4,4,1),
        8: (4,4,1),
        9: (5,4,2),
        10: (5,4,2),
        11: (5,5,2),
        12: (5,5,2),
        13: (6,5,3),
        14: (6,5,3),
        15: (6,6,3),
      };
      return purpleTable[modifiedDie]!;
    } else if (enemyUnit.isType(PieceType.mapEnemyUnitGreen)) {
      const greenTable = {
        5: (4,3,1),
        6: (4,4,1),
        7: (4,4,1),
        8: (5,4,2),
        9: (5,4,2),
        10: (5,5,2),
        11: (5,5,2),
        12: (6,5,3),
        13: (6,5,3),
        14: (6,6,3),
        15: (6,6,3),
        16: (6,6,3),
        17: (6,6,3),
      };
      return greenTable[modifiedDie]!;
    } else if (enemyUnit.isType(PieceType.mapEnemyUnitOrange)) {
      const orangeTable = {
        4: (3,3,2),
        5: (4,3,2),
        6: (4,3,2),
        7: (4,4,2),
        8: (4,4,2),
        9: (5,4,3),
        10: (5,4,3),
        11: (5,5,3),
        12: (5,5,3),
        13: (6,5,4),
        14: (6,5,4),
        15: (6,5,4),
        16: (6,5,4),
      };
      return orangeTable[modifiedDie]!;
    } else if (enemyUnit.isType(PieceType.mapEnemyUnitBrown)) {
      const brownTable = {
        7: (4,4,2),
        8: (5,4,3),
        9: (5,4,3),
        10: (5,5,3),
        11: (5,5,3),
        12: (6,5,4),
        13: (6,5,4),
        14: (6,6,4),
        15: (6,6,4),
        16: (6,6,4),
        17: (6,6,4),
        18: (6,6,4),
      };
      return brownTable[modifiedDie]!;
    }
    return (0,0,0);
  }

  List<Location> get candidateBattleInitialDeployBoxes {
    final localState = _battleState!;
    final candidates = <Location>[];
    for (int i = 0; i < 5 && i < localState.rightCount; ++i) {
      final box = _state.yourLeftBox(i);
      if (_state.piecesInLocationCount(PieceType.friendlyBattle, box) == 0) {
        candidates.add(box);
      }
    }
    for (int i = 0; i < 5 && i < localState.leftCount; ++i) {
      final box = _state.yourRightBox(i);
      if (_state.piecesInLocationCount(PieceType.friendlyBattle, box) == 0) {
        candidates.add(box);
      }
    }
    return candidates;
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
  }

  // Sequence Helpers

  void battle(Location space, bool ambush) {
    _battleState ??= BattleState(space, ambush);
    final localState = _battleState!;

    final region = _state.spaceRegion(space);
    final enemyUnit = _state.spaceTopmostEnemyUnit(space);
    final enemyLeader = _state.pieceInLocation(PieceType.mapEnemyLeader, space);

    if (localState.subStep == 0) {
      if (localState.ambush) {
        logLine('### Ambush by Moors in ${space.desc}');
      } else {
        logLine('### Battle in ${space.desc}');
      }
      int die = rollD8();
      int modifiers = 0;
      int modifier = 0;

      logTableHeader();
      logD8InTable(die);
      if (enemyUnit != null) {
        modifier = _state.enemyUnitResistanceRating(enemyUnit);
        logLine('>|${enemyUnit.desc}|$modifier|');
        modifiers += modifier;
        if (enemyLeader != null) {
          modifier = _state.enemyLeaderBonus(enemyLeader);
          logLine('>|Leader|$modifier|');
          modifiers += modifier;
        } else {
          modifier = _state.regionLeaderBonus(region);
          if (modifier != 0) {
            logLine('>|Leader|$modifier|');
            modifiers += modifier;
          }
        }
      }
      int total = die + modifiers;
      logLine('>|Total|$total');
      logTableFooter();

      final tableResults = enemyFormationTable(enemyUnit, total);
      int rightCount = tableResults.$1;
      int leftCount = tableResults.$2;
      int adjustmentCount = tableResults.$3;
      logLine('>Right: $rightCount Left: $leftCount Cup Adjustments: $adjustmentCount');

      localState.rightCount = rightCount;
      localState.leftCount = leftCount;
      localState.cupAdjustmentCount = adjustmentCount;

      localState.subStep = ambush ? 2 : 1;
    }

    while (localState.subStep >= 1 && localState.subStep <= 2) {
      if (localState.subStep == 1) { // Enemy Deploy
        for (int i = 0; i < localState.rightCount; ++i) {
          final piece = randPiece(_state.piecesInLocation(PieceType.enemyBattleFull, Location.cupBattle))!;
          _state.setPieceLocation(piece, _state.enemyRightBox(i));
        }
        for (int i = 0; i < localState.leftCount; ++i) {
          final piece = randPiece(_state.piecesInLocation(PieceType.enemyBattleFull, Location.cupBattle))!;
          _state.setPieceLocation(piece, _state.enemyLeftBox(i));
        }
        if (ambush) {
          localState.subStep = 3;
        } else {
          localState.subStep = 2;
        }
      }
      if (localState.subStep == 2) { // We Deploy
        if (checkChoice(Choice.cancel)) {
          clearChoices();
        }
        if (choicesEmpty()) {
          setPrompt('Select unit to deploy');
          bool complete = candidateBattleInitialDeployBoxes.isEmpty;
          final locationType = complete ? LocationType.boxTacticalYourLeftRight : LocationType.boxTacticalYour;
          for (final box in locationType.locations) {
            for (final piece in _state.piecesInLocation(PieceType.friendlyBattle, box)) {
              pieceChoosable(piece);
            }
          }
          choiceChoosable(Choice.next, complete);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.next)) {
          if (ambush) {
            localState.subStep = 1;
          } else {
            localState.subStep = 3;
          }
          continue;
        }
        final piece = selectedPiece()!;
        if (_state.pieceLocation(piece).isType(LocationType.boxTacticalYourLeftRight)) {
          _state.setPieceLocation(piece, Location.boxTacticalYourReserve);
        } else {
          final location = selectedLocation();
          if (location == null) {
            setPrompt('Select square to deploy ${piece.desc} to');
            for (final box in candidateBattleInitialDeployBoxes) {
              locationChoosable(box);
            }
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
          _state.setPieceLocation(piece, location);
          clearChoices();
        }
      }
    }
    if (localState.subStep == 3) {
      // TODO
    }
  }

  // Sequence of Play

  void setupMarquis() {
    if (_state.currentTurn != 1) {
      return;
    }
    if (choicesEmpty()) {
      setPrompt('Select March for Marquis');
      locationChoosable(Location.bretonMarch);
      locationChoosable(Location.spanishMarch);
      throw PlayerChoiceException();
    }
    final location = selectedLocation()!;
    _state.setPieceLocation(Piece.marquisNoCrown0, location);
    clearChoices();
  }

  void completeSetup() {
    if (_state.currentTurn != 1) {
      return;
    }

    final orangeEnemies = PieceType.mapEnemyUnitOrange.pieces;
    orangeEnemies.shuffle(_random);
    int orangeCount = 0;
    for (final enemy in orangeEnemies) {
      if (orangeCount < 4) {
        final home = _state.enemyHome(enemy);
        _state.setPieceLocation(enemy, home);
        orangeCount += 1;
      } else {
        _state.setPieceLocation(enemy, Location.cupFriendly);
      }
    }

    _state.setupPieceType(PieceType.mapEnemyUnitBrown, Location.cupFriendly);

    final friendlyEnemies = _state.piecesInLocation(PieceType.mapEnemyUnit, Location.cupFriendly);
    friendlyEnemies.shuffle(_random);
    int brownCount = 0;
    for (final enemy in friendlyEnemies) {
      if (brownCount < 4) {
        final home = _state.enemyHome(enemy);
        _state.setPieceLocation(enemy, home);
        if (enemy.isType(PieceType.mapEnemyUnitBrown)) {
          brownCount += 1;
        }
      } else {
        _state.setPieceLocation(enemy, Location.cupHostile);
      }
    }
  }

  void turnBegin() {
    logLine('# Turn ${_state.turnName(_state.currentTurn)}');
  }

  void levyPhaseBegin() {
    if (_state.currentTurn != 0) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Levy Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Levy Phase');
    _phaseState = PhaseStateLevy();
  }

  void levyPhaseBuyNewUnits() {
    if (_state.currentTurn != 0) {
      return;
    }
    final phaseState = _phaseState as PhaseStateLevy;
    while (true) {
      if (choicesEmpty()) {
        setPrompt('Choose Battle Unit to purchase or Next to proceed');
        if (phaseState.purchaseInfantryCount + phaseState.purchaseCavalryCount < levyLimitCount) {
          if (_state.piecesInLocationCount(PieceType.infantry1, Location.offmap) > 0) {
            choiceChoosable(Choice.purchaseInfantry, _state.treasury >= 1);
          }
          if (_state.piecesInLocationCount(PieceType.cavalry2, Location.offmap) > 0) {
            choiceChoosable(Choice.purchaseCavalry, _state.treasury >= 2);
          }
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      final pieceType = checkChoice(Choice.purchaseInfantry) ? PieceType.infantry1 : PieceType.cavalry2;
      final piece = _state.piecesInLocation(pieceType, Location.offmap)[0];
      logLine('>${piece.desc} is added to the Reserve.');
      if (pieceType == PieceType.infantry1) {
        adjustTreasury(-1);
        phaseState.purchaseInfantryCount += 1;
      } else {
        adjustTreasury(-2);
        phaseState.purchaseCavalryCount += 1;
      }
      _state.setPieceLocation(piece, Location.boxTacticalYourReserve);
      clearChoices();
    }
  }

  void levyPhasePromoteUnit() {
    if (_state.currentTurn != 0) {
      return;
    }
    final phaseState = _phaseState as PhaseStateLevy;
    if (choicesEmpty()) {
      bool infantry1 = _state.piecesInLocationCount(PieceType.infantry1, Location.boxTacticalYourReserve) > phaseState.purchaseInfantryCount;
      bool infantry2 = _state.piecesInLocationCount(PieceType.infantry2, Location.boxTacticalYourReserve) > 0 && _state.piecesInLocationCount(PieceType.infantry3, Location.offmap) > 0;
      if (!infantry1 && !infantry2) {
        return;
      }
      setPrompt('Select Infantry to Promote');
      choiceChoosable(Choice.promoteInfantry1, infantry1);
      choiceChoosable(Choice.promoteInfantry2, infantry2);
      throw PlayerChoiceException();
    }
    if (checkChoiceAndClear(Choice.promoteInfantry1)) {
      final infantry1 = _state.piecesInLocation(PieceType.infantry1, Location.boxTacticalYourReserve)[0];
      logLine('>Promote one Infantry from Level 1 to Level 2.');
      final infantry2 = _state.pieceFlipSide(infantry1)!;
      _state.setPieceLocation(infantry2, Location.boxTacticalYourReserve);
    } else if (checkChoiceAndClear(Choice.promoteInfantry2)) {
      final infantry2 = _state.piecesInLocation(PieceType.infantry2, Location.boxTacticalYourReserve)[0];
      logLine('>Promote one Infantry from Level 2 to Level 3.');
      _state.setPieceLocation(infantry2, Location.offmap);
      final infantry3 = _state.piecesInLocation(PieceType.infantry3, Location.boxTacticalYourReserve)[0];
      _state.setPieceLocation(infantry3, Location.boxTacticalYourReserve);
    }
  }

  void levyPhaseEnd() {
    _phaseState = null;
  }

  void campaignPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Campaign Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Campaign Phase');
    _phaseState = PhaseStateCampaign();
  }

  void actionSuppress(Piece leader, Location space) {
    if (_subStep == 0) {
      logLine('### ${leader.desc} attempts to Suppress ${space.desc}');
      final enemyUnit = _state.spaceTopmostEnemyUnit(space)!;
      int die = rollD8();

      logTableHeader();
      logD8InTable(die);
      int rating = _state.enemyUnitResistanceRating(enemyUnit);
      logLine('>|${enemyUnit.desc}|$rating|');
      int modifiers = 0;
      final region = _state.spaceRegion(space);
      final leaderBonus = _state.regionLeaderBonus(region);
      if (leaderBonus > 0) {
        logLine('>|Leader|+$leaderBonus|');
        modifiers += leaderBonus;
      }
      int total = rating + modifiers;
      logLine('>|Total|$total|');
      logTableFooter();

      if (die > total) {
        final pieces = _state.piecesInLocation(PieceType.mapEnemyUnit, space);
        if (leader.isType(PieceType.mapCharlemagne) || pieces.length == 1) {
          logLine('>Resistance in ${space.desc} is suppressed.');
          for (final piece in _state.piecesInLocation(PieceType.mapEnemyUnit, space)) {
            _state.setPieceLocation(piece, Location.poolDead);
          }
        } else {
          logLine('>Resistance in ${space.desc} is reduced.');
          _state.setPieceLocation(enemyUnit, Location.poolDead);
        }
      } else {
        logLine('>Resistance continues despite attempts to suppress it.');
      }
      cupAdjustment(Location.cupFriendly, Location.cupUnfriendly);
      _subStep = 1;
    }
    while (_subStep >= 1 && _subStep <= 2) {
      reaction();
      _subStep += 1;
    }
  }

  void actionBattle(Piece leader, Location space) {
    if (_subStep == 0) {
      logLine('### Charlemagne fights Battle in ${space.desc}.');
      _subStep = 1;
    }
    if (_subStep == 1) {
      battle(space, false);
      cupAdjustment(Location.cupFriendly, Location.cupUnfriendly);
      // TODO unfriendly->hostile
      _subStep == 2;
    }
    while (_subStep >= 2 && _subStep <= 3) {
      reaction();
      _subStep += 1;
    }
  }

  void actionForcedMarch(Piece leader, Location space) {
    if (_subStep == 0) {
      logLine('### ${leader.desc} Forced Marches to ${space.desc}.');
      _state.setPieceLocation(leader, space);
      _subStep = 1;
    }
    if (_subStep == 1) {
      reaction();
    }
  }

  void actionSiege(Piece leader, Location location) {

  }

  void actionGift(Piece leader, Location location) {

  }

  void actionMarquis(Piece leader, Location location) {

  }

  void actionForcedConversion(Piece leader, Location location) {

  }

  void campaignPhaseActions() {
    final phaseState = _phaseState as PhaseStateCampaign;
    while (_state.piecesInLocationCount(PieceType.turnEnd, Location.poolDead) < 2) {
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      if (choicesEmpty()) {
        setPrompt('Select Leader to perform Action');
        for (final leader in PieceType.mapCarolingianLeader.pieces) {
          if (_state.pieceLocation(leader).isType(LocationType.map)) {
            pieceChoosable(leader);
          }
        }
        throw PlayerChoiceException();
      }
      final leader = selectedPiece()!;
      phaseState.leader = leader;
      if (_choiceInfo.selectedChoices.isEmpty) {
        setPrompt('Select Action to perform');
        if (candidateLeaderSuppressLocations(leader).isNotEmpty) {
          choiceChoosable(Choice.actionSuppress, true);
        }
        if (candidateLeaderBattleLocations(leader).isNotEmpty) {
          choiceChoosable(Choice.actionBattle, true);
        }
        if (candidateLeaderForcedMarchLocations(leader).isNotEmpty) {
          choiceChoosable(Choice.actionForcedMarch, true);
        }
        if (candidateLeaderSiegeLocations(leader).isNotEmpty) {
          choiceChoosable(Choice.actionSiege, true);
        }
        if (candidateLeaderGiftLocations(leader).isNotEmpty) {
          choiceChoosable(Choice.actionGift, true);
        }
        if (candidateLeaderMarquisLocations(leader).isNotEmpty) {
          choiceChoosable(Choice.actionMarquis, true);
        }
        if (candidateLeaderForcedConversionLocations(leader).isNotEmpty) {
          choiceChoosable(Choice.actionForcedConversion, true);
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      final location = selectedLocation();
      if (location == null) {
        if (checkChoice(Choice.actionSuppress)) {
          setPrompt('Select Box to Suppress');
          for (final location in candidateLeaderSuppressLocations(leader)) {
            locationChoosable(location);
          }
        } else if (checkChoice(Choice.actionBattle)) {
          setPrompt('Select Box for Battle');
          for (final location in candidateLeaderBattleLocations(leader)) {
            locationChoosable(location);
          }
        } else if (checkChoice(Choice.actionForcedMarch)) {
          setPrompt('Select Box to Forced March to');
          for (final location in candidateLeaderForcedMarchLocations(leader)) {
            locationChoosable(location);
          }
        } else if (checkChoice(Choice.actionSiege)) {
          setPrompt('Select Box to Siege');
          for (final location in candidateLeaderSiegeLocations(leader)) {
            locationChoosable(location);
          }
        } else if (checkChoice(Choice.actionGift)) {
          setPrompt('Select Box for Gift');
          for (final location in candidateLeaderGiftLocations(leader)) {
            locationChoosable(location);
          }
        } else if (checkChoice(Choice.actionMarquis)) {
          setPrompt('Select Box to assign Marquis to');
          for (final location in candidateLeaderMarquisLocations(leader)) {
            locationChoosable(location);
          }
        } else if (checkChoice(Choice.actionForcedConversion)) {
          setPrompt('Select Box for Forced Conversion');
          for (final location in candidateLeaderForcedConversionLocations(leader)) {
            locationChoosable(location);
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.actionSuppress)) {
        actionSuppress(leader, location);
      } else if (checkChoice(Choice.actionBattle)) {
        actionBattle(leader, location);
      } else if (checkChoice(Choice.actionForcedMarch)) {
        actionForcedMarch(leader, location);
      } else if (checkChoice(Choice.actionSiege)) {
        actionSiege(leader, location);
      } else if (checkChoice(Choice.actionGift)) {
        actionGift(leader, location);
      } else if (checkChoice(Choice.actionMarquis)) {
        actionMarquis(leader, location);
      } else if (checkChoice(Choice.actionForcedConversion)) {
        actionForcedConversion(leader, location);
      }
    }
  }

  void campaignPhaseEnd() {
    _phaseState = null;
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      setupMarquis,
      completeSetup,
      turnBegin,
      levyPhaseBegin,
      levyPhaseBuyNewUnits,
      levyPhasePromoteUnit,
      levyPhaseEnd,
      campaignPhaseBegin,
      campaignPhaseActions,
      campaignPhaseEnd,
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

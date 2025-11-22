import 'dart:convert';
import 'dart:math';
import 'package:nubia/db.dart';
import 'package:nubia/random.dart';

enum Location {
  soba,
  sururab,
  furaWells,
  dongola,
  daw,
  selimaOasis,
  theGates,
  kedru,
  mogranarti,
  koroskoRoad,
  faras,
  phrim,
  aswan,
  shendi,
  atbaraRiver,
  taflien,
  bazin,
  aydhab,
  qerri,
  arbaji,
  sennar,
  blueNile,
  sobatRiver,
  kusha,
  whiteNile,
  nubaMountains,
  fortyDaysRoad,
  kordofan,
  boxPathA,
  boxPathB,
  boxPathC,
  boxPathD,
  boxPathE,
  boxDowntownSoba,
  boxEthiopia,
  boxUru,
  boxCrownPrince,
  boxMetrolpolitan,
  boxBishops,
  boxTheMosque,
  crusadeLevel,
  nobility0,
  nobility1,
  nobility2,
  nobility3,
  nobility4,
  nobility5,
  nobility6,
  kingship0,
  kingship1,
  kingship2,
  kingship3,
  kingship4,
  kingship5,
  kingship6,
  army0,
  army1,
  army2,
  army3,
  army4,
  army5,
  army6,
  poolSlavery,
  cupDisaster,
  cupUru,
  cupMetropolitan,
  traySlaves,
  trayFeudalism,
  trayEparchs,
  trayCrusades,
  trayMigration,
  trayUrus,
  trayPrincesses,
  trayMeks,
  trayLandSales,
  trayNubianArchers,
  trayAssets,
  trayMonasteries,
  trayBishops,
  trayPortuguese,
  trayMosques,
  trayMarriage,
  trayMetropolitans,
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
  land,
  pathA,
  pathB,
  pathC,
  pathD,
  pathE,
  pathBox,
  nobility,
  kingship,
  army,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.land: [Location.soba, Location.kordofan],
    LocationType.pathA: [Location.sururab, Location.selimaOasis],
    LocationType.pathB: [Location.theGates, Location.aswan],
    LocationType.pathC: [Location.shendi, Location.aydhab],
    LocationType.pathD: [Location.qerri, Location.sobatRiver],
    LocationType.pathE: [Location.kusha, Location.kordofan],
    LocationType.pathBox: [Location.boxPathA, Location.boxPathE],
    LocationType.nobility: [Location.nobility0, Location.nobility6],
    LocationType.kingship: [Location.kingship0, Location.kingship6],
    LocationType.army: [Location.army0, Location.army6],
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
      Location.soba: 'Soba',
      Location.sururab: 'Sururab',
      Location.furaWells: 'Fura Wells',
      Location.dongola: 'Dongola',
      Location.daw: 'Daw',
      Location.selimaOasis: 'Selima Oasis',
      Location.theGates: 'The Gates',
      Location.kedru: 'Kedru',
      Location.mogranarti: 'Mogranarti',
      Location.koroskoRoad: 'Korosko Road',
      Location.faras: 'Faras',
      Location.phrim: 'Phrim',
      Location.aswan: 'Aswan',
      Location.shendi: 'Shendi',
      Location.atbaraRiver: 'Atbara River',
      Location.taflien: 'Taflien',
      Location.bazin: 'Bazin',
      Location.aydhab: 'Aydhab',
      Location.qerri: 'Qerri',
      Location.arbaji: 'Arbaji',
      Location.sennar: 'Sennar',
      Location.blueNile: 'Blue Nile',
      Location.sobatRiver: 'Sobat River',
      Location.kusha: 'Kusha',
      Location.whiteNile: 'White Nile',
      Location.nubaMountains: 'Nuba Mountains',
      Location.fortyDaysRoad: '40 Days Road',
      Location.kordofan: 'Kordofan',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Path {
  a,
  b,
  c,
  d,
  e,
}

extension PathExtension on Path {
  String get desc {
    const pathDescs = {
      Path.a: 'Path A',
      Path.b: 'Path B',
      Path.c: 'Path C',
      Path.d: 'Path D',
      Path.e: 'Path E',
    };
    return pathDescs[this]!;
  }
}

enum Piece {
  mekAyyubid,
  mekMamluk,
  mekJuhayna,
  mekJad,
  mekBeja,
  mekKanz,
  mekShilluk,
  mekFunj,
  mekKawahla,
  crusades0,
  crusades1,
  crusades2,
  portugal0,
  portugal1,
  portugal2,
  portugal3,
  uruAbraham,
  uruMark,
  uruSolomon,
  uruKerenbes,
  uruRafael,
  uruDavid,
  uruMosesGeorge,
  uruGeorge,
  uruMercury,
  uruJoel,
  uruZachary,
  uruCyriac,
  metropolitanPeter,
  metropolitanJesus,
  metropolitanJohn,
  metropolitanShenoute,
  princessMariam,
  princessMartha,
  princessAgatha,
  princessAnthelia,
  princessPetronia,
  princessKristina,
  bishop5,
  bishopF,
  bishopI,
  eparch0,
  eparch1,
  eparch2,
  eparch3,
  feudal0N1,
  feudal1N1,
  feudal2N1,
  feudal3N1,
  feudal4N1,
  feudal0P1,
  feudal1P1,
  feudal2P1,
  feudal3P1,
  feudal4P1,
  migrationA0,
  migrationA1,
  migrationB0,
  migrationC0,
  migrationC1,
  migrationD0,
  migrationD1,
  migrationE0,
  famine0,
  famine1,
  famine2,
  famine3,
  monastery0,
  monastery1,
  monastery2,
  monastery3,
  mosque0,
  mosque1,
  landSale0,
  landSale1,
  landSale2,
  landSale3,
  nubianArchers0,
  nubianArchers1,
  nubianArchers2,
  nubianArchers3,
  marriage0,
  marriage1,
  slaves,
  ethiopians,
  assetNobility,
  assetKingship,
  assetArmy,
}

Piece? pieceFromIndex(int? index) {
  if (index != null) {
    return Piece.values[index];
  } else {
    return null;
  }
}

int? pieceToIndex(Piece? piece) {
  return piece?.index;
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
  mek,
  mekPathA,
  mekPathB,
  mekPathC,
  mekPathD,
  mekPathE,
  crusades,
  portugal,
  uru,
  metropolitan,
  princess,
  bishop,
  eparch,
  feudal,
  feudalN1,
  feudalP1,
  disaster,
  migration,
  famine,
  monastery,
  mosque,
  landSale,
  nubianArchers,
  marriage,
  asset,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.mekAyyubid, Piece.assetArmy],
    PieceType.mek: [Piece.mekAyyubid, Piece.mekKawahla],
    PieceType.mekPathA: [Piece.mekAyyubid, Piece.mekMamluk],
    PieceType.mekPathB: [Piece.mekJuhayna, Piece.mekJad],
    PieceType.mekPathC: [Piece.mekBeja, Piece.mekKanz],
    PieceType.mekPathD: [Piece.mekShilluk, Piece.mekFunj],
    PieceType.mekPathE: [Piece.mekKawahla, Piece.mekKawahla],
    PieceType.crusades: [Piece.crusades0, Piece.crusades2],
    PieceType.portugal: [Piece.portugal0, Piece.portugal3],
    PieceType.uru: [Piece.uruAbraham, Piece.uruCyriac],
    PieceType.metropolitan: [Piece.metropolitanPeter, Piece.metropolitanShenoute],
    PieceType.princess: [Piece.princessMariam, Piece.princessKristina],
    PieceType.bishop: [Piece.bishop5, Piece.bishopI],
    PieceType.eparch: [Piece.eparch0, Piece.eparch3],
    PieceType.feudal: [Piece.feudal0N1, Piece.feudal4P1],
    PieceType.feudalN1: [Piece.feudal0N1, Piece.feudal4N1],
    PieceType.feudalP1: [Piece.feudal0P1, Piece.feudal4P1],
    PieceType.disaster: [Piece.migrationA0, Piece.famine3],
    PieceType.migration: [Piece.migrationA0, Piece.migrationE0],
    PieceType.famine: [Piece.famine0, Piece.famine3],
    PieceType.monastery: [Piece.monastery0, Piece.monastery3],
    PieceType.mosque: [Piece.mosque0, Piece.mosque1],
    PieceType.landSale: [Piece.landSale0, Piece.landSale3],
    PieceType.nubianArchers: [Piece.nubianArchers0, Piece.nubianArchers3],
    PieceType.marriage: [Piece.marriage0, Piece.marriage1],
    PieceType.asset: [Piece.assetNobility, Piece.assetArmy],
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

enum Card {
  kush,
  piye,
  meroe,
  niloSaharanLanguages,
  beja,
  nubianMurals,
  arabOccupiedEgypt,
  shekandaWar,
  conversionOfNubia,
  copticInfluence,
  nobadia,
  makuria,
  alodia,
  farasCathedral,
  nubianMigrations,
  silko,
  baqt,
  funj,
  arabColonization,
  soba,
  axum,
  kokka,
  islamization,
  culturalSurvivals,
  oldNubianLanguage,
  portuguese,
  nubiaToday,
}

Card? cardFromIndex(int? index) {
  if (index != null) {
    return Card.values[index];
  } else {
    return null;
  }
}

int? cardToIndex(Card? card) {
  return card?.index;
}

List<Card> cardListFromIndices(List<int> indices) {
  final cards = <Card>[];
  for (final index in indices) {
    cards.add(Card.values[index]);
  }
  return cards;
}

List<int> cardListToIndices(List<Card> cards) {
  final indices = <int>[];
  for (final card in cards) {
    indices.add(card.index);
  }
  return indices;
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
      Scenario.standard: 'Standard (27 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.discarded);
  List<Card> _deck = <Card>[];
  Card? _currentCard;

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
   : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
   , _deck = cardListFromIndices(List<int>.from(json['deck']))
   , _currentCard = cardFromIndex(json['deck'] as int?)
   ;

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'deck': cardListToIndices(_deck),
    'currentCard': cardToIndex(_currentCard),
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

  // Paths

  LocationType pathLocationType(Path path) {
    const pathLocationTypes = {
      Path.a: LocationType.pathA,
      Path.b: LocationType.pathB,
      Path.c: LocationType.pathC,
      Path.d: LocationType.pathD,
      Path.e: LocationType.pathE,
    };
    return pathLocationTypes[path]!;
  }

  Location? pathSequenceLand(Path path, int sequence) {
    final locationType = pathLocationType(path);
    final lands = locationType.locations;
    if (sequence > lands.length) {
      return null;
    }
    return lands[sequence];
  }

  Location pathPrevLand(Path path, Location land) {
    final locationType = pathLocationType(path);
    if (land.index == locationType.firstIndex) {
      return Location.soba;
    }
    return Location.values[land.index - 1];
  }

  Location? pathNextLand(Path path, Location land) {
    final locationType = pathLocationType(path);
    if (land.index == locationType.lastIndex) {
      return null;
    }
    return Location.values[land.index + 1];
  }

  Location pathBox(Path path) {
    return Location.values[LocationType.pathBox.firstIndex + path.index];
  }

  PieceType pathMekPieceType(Path path) {
    const pathMekPieceTypes = {
      Path.a: PieceType.mekPathA,
      Path.b: PieceType.mekPathB,
      Path.c: PieceType.mekPathC,
      Path.d: PieceType.mekPathD,
      Path.e: PieceType.mekPathE,
    };
    return pathMekPieceTypes[path]!;
  }

  Piece pathMek(Path path) {
    final pieceType = pathMekPieceType(path);
    final locationType = pathLocationType(path);
    for (final mek in pieceType.pieces) {
      final location = pieceLocation(mek);
      if (location.isType(locationType)) {
        return mek;
      }
    }
    return Piece.ethiopians;
  }

  Piece? pathFeudal(Path path) {
    final box = pathBox(path);
    return pieceInLocation(PieceType.feudal, box);
  }

  int pathMosqueCount(Path path) {
    final locationType = pathLocationType(path);
    int count = 0;
    for (final mosque in PieceType.mosque.pieces) {
      final location = pieceLocation(mosque);
      if (location.isType(locationType)) {
        count += 1;
      }
    }
    return count;
  }

  // Lands

  Path landPath(Location land) {
    for (final path in Path.values) {
      final locationType = pathLocationType(path);
      if (land.isType(locationType)) {
        return path;
      }
    }
    return Path.e;
  }

  bool landIsPlayerControlled(Location land) {
    if (land == Location.soba) {
      return true;
    }
    final path = landPath(land);
    final mek = pathMek(path);
    final mekLand = pieceLocation(mek);
    return land.index < mekLand.index;
  }

  // Meks

  int mekStrength(Piece mek) {
    const mekStrengths = {
      Piece.mekAyyubid: 5,
      Piece.mekMamluk: 4,
      Piece.mekJuhayna: 4,
      Piece.mekJad: 5,
      Piece.mekBeja: 4,
      Piece.mekKanz: 5,
      Piece.mekShilluk: 3,
      Piece.mekFunj: 5,
      Piece.mekKawahla: 3,
    };
    return mekStrengths[mek]!;
  }

  bool mekArab(Piece mek) {
    const arabMeks = [
      Piece.mekAyyubid,
      Piece.mekMamluk,
      Piece.mekJuhayna,
      Piece.mekJad,
      Piece.mekKanz,
      Piece.mekKawahla,
    ];
    return arabMeks.contains(mek);
  }

  // Monasteries

  int monasteryValue(Piece monastery) {
    const monasteryValues = {
      Piece.monastery0: 4,
      Piece.monastery1: 5,
      Piece.monastery2: 5,
      Piece.monastery3: 6,
    };
    return monasteryValues[monastery]!;
  }

  // Urus

  bool uruCunning(Piece uru) {
    const cunningUrus = [
      Piece.uruRafael,
      Piece.uruGeorge,
    ];
    return cunningUrus.contains(uru);
  }

  bool uruImpulsive(Piece uru) {
    const impulsiveUrus = [
      Piece.uruMark,
      Piece.uruJoel,
    ];
    return impulsiveUrus.contains(uru);
  }

  // Crusades

  int crusadeLevel(Piece crusades) {
    return crusades.index - PieceType.crusades.firstIndex;
  }

  Piece crusadeLevelPiece(int level) {
    return Piece.values[PieceType.crusades.firstIndex + level];
  }

  // Turns

  int get currentTurn {
    return 27 - _deck.length;
  }

  String turnName(int turn) {
    return 'Turn ${max(turn, 1)}';
  }

  // Cards

  Card? get currentCard {
    if (_currentCard == null) {
      return null;
    }
    return _currentCard;
  }

  void advanceDeck() {
    _currentCard = _deck.removeAt(0);
  }

  String cardTitle(Card card) {
    const cardTitles = {
      Card.kush: 'Kush',
      Card.piye: 'Piye and the 25th Dynasty',
      Card.meroe: 'Meroë',
      Card.niloSaharanLanguages: 'Nilo-Saharan Languages',
      Card.beja: 'The Beja and Banu Kanz',
      Card.nubianMurals: 'Nubian Murals',
      Card.arabOccupiedEgypt: 'Arab-Occupied Egypt',
      Card.shekandaWar: 'The Shekanda War',
      Card.conversionOfNubia: 'The Conversion of Nubia',
      Card.copticInfluence: 'Coptic Inflluence',
      Card.nobadia: 'Nobadia',
      Card.makuria: 'Makuria',
      Card.alodia: 'Alodia',
      Card.farasCathedral: 'Faras Cathedral',
      Card.nubianMigrations: 'Nubian Migrations',
      Card.silko: 'Silko and the Fall of Meroë',
      Card.baqt: 'The Baqt',
      Card.funj: 'The Funj',
      Card.arabColonization: 'Arab Colonization',
      Card.soba: 'Soba',
      Card.axum: 'Axum and Ethiopia',
      Card.kokka: 'Kokka and Fazughli',
      Card.islamization: 'Islamization',
      Card.culturalSurvivals: 'Cultural Survivals',
      Card.oldNubianLanguage: 'Old Nubian Language',
      Card.portuguese: 'The Portuguese',
      Card.nubiaToday: 'Nubia Today',
    };
    return cardTitles[card]!;
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

  void setupDeck(Random random) {
    final green = <Card>[];
    final yellow = <Card>[];
    final red = <Card>[];
    for (int i = 0; i < 27; ++i) {
      final card = Card.values[i];
      if (i < 6) {
        green.add(card);
      } else if (i < 18) {
        yellow.add(card);
      } else {
        red.add(card);
      }
    }
    green.shuffle(random);
    yellow.shuffle(random);
    red.shuffle(random);
    _deck = green + yellow + red;
  }

  factory GameState.setupTray() {
    var state = GameState();

    state.setupPieceTypes([
      (PieceType.feudal, Location.trayFeudalism),
      (PieceType.eparch, Location.trayEparchs),
      (PieceType.crusades, Location.trayCrusades),
      (PieceType.migration, Location.trayMigration),
      (PieceType.famine, Location.trayMigration),
      (PieceType.uru, Location.trayUrus),
      (PieceType.princess, Location.trayPrincesses),
      (PieceType.mek, Location.trayMeks),
      (PieceType.landSale, Location.trayLandSales),
      (PieceType.nubianArchers, Location.trayNubianArchers),
      (PieceType.asset, Location.trayAssets),
      (PieceType.monastery, Location.trayMonasteries),
      (PieceType.bishop, Location.trayBishops),
      (PieceType.portugal, Location.trayPortuguese),
      (PieceType.mosque, Location.trayMosques),
      (PieceType.marriage, Location.trayMarriage),
      (PieceType.metropolitan, Location.trayMetropolitans),
    ]);

    state.setupPieces([
      (Piece.slaves, Location.traySlaves),
      (Piece.ethiopians, Location.traySlaves),
    ]);

    return state;
  }
  factory GameState.setupStandard(Random random) {

    var state = GameState.setupTray();

    state.setupPieceTypes([
      (PieceType.landSale, Location.boxDowntownSoba),
      (PieceType.marriage, Location.boxDowntownSoba),
      (PieceType.princess, Location.boxDowntownSoba),
      (PieceType.bishop, Location.boxBishops),
      (PieceType.migration, Location.cupDisaster),
      (PieceType.famine, Location.cupDisaster),
      (PieceType.uru, Location.cupUru),
      (PieceType.metropolitan, Location.cupMetropolitan),
    ]);

    state.setupPieces([
      (Piece.mekJuhayna, Location.selimaOasis),
      (Piece.mekAyyubid, Location.aswan),
      (Piece.mekBeja, Location.aydhab),
      (Piece.mekShilluk, Location.sobatRiver),
      (Piece.mekKawahla, Location.kordofan),
      (Piece.assetNobility, Location.nobility5),
      (Piece.assetKingship, Location.kingship5),
      (Piece.assetArmy, Location.army5),
      (Piece.crusades2, Location.crusadeLevel),
      (Piece.slaves, Location.poolSlavery),
      (Piece.ethiopians, Location.boxEthiopia),
    ]);

    final urus = state.piecesInLocation(PieceType.uru, Location.cupUru);
    urus.shuffle(random);

    final metropolitans = state.piecesInLocation(PieceType.metropolitan, Location.cupMetropolitan);
    metropolitans.shuffle(random);

    state.setPieceLocation(urus[0], Location.boxUru);
    state.setPieceLocation(metropolitans[0], Location.boxMetrolpolitan);

    state.setupDeck(random);

    return state;
  }
}

enum Choice {
  blockAdvanceNubianArchers,
  blockAdvanceMonastery,
  blockAdvanceSlaves,
  blockAdvanceCede,
  yes,
  no,
  cancel,
  next,
}

Choice? choiceFromIndex(int? index) {
  if (index != null) {
    return Choice.values[index];
  } else {
    return null;
  }
}

int? choiceToIndex(Choice? location) {
  return location?.index;
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

class MekAdvanceState {
  int subStep = 0;

  MekAdvanceState();

  MekAdvanceState.fromJson(Map<String, dynamic> json)
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
  PlayerChoiceInfo _choiceInfo = PlayerChoiceInfo();
  //PhaseState? _phaseState;
  MekAdvanceState? _mekAdvanceState;
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

    final mekAdvanceStateJson = json['mekAdvance'];
    if (mekAdvanceStateJson != null) {
      _mekAdvanceState = MekAdvanceState.fromJson(mekAdvanceStateJson);
    }

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
    if (_mekAdvanceState != null) {
      map['mekAdvance'] = _mekAdvanceState!.toJson();
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

  // Logging

  // High-Level Functions

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
  }

  // Sequence Helpers

  void pathAdvance(Path path) {
    _mekAdvanceState ??= MekAdvanceState();
    final localState = _mekAdvanceState!;
  
    final mek = _state.pathMek(path);

    while (true) {
      final fromLand = _state.pieceLocation(mek);
      final toLand = _state.pathPrevLand(path, fromLand);

      if (localState.subStep == 0) {
        logLine('### ${mek.desc} Advances on ${toLand.desc}.');
        localState.subStep = 1;
      }

      while (localState.subStep == 1) {
        if (choicesEmpty()) {
          setPrompt('Respond to Mek Advance');
          bool stopped = false;
          if (_state.piecesInLocationCount(PieceType.nubianArchers, toLand) > 0) {
            choiceChoosable(Choice.blockAdvanceNubianArchers, true);
            stopped = true;
          }
          if (!stopped && _state.piecesInLocationCount(PieceType.monastery, toLand) > 0) {
            choiceChoosable(Choice.blockAdvanceMonastery, true);
          }
          if (!stopped && _state.mekArab(mek) && _state.pieceLocation(Piece.slaves) == Location.boxDowntownSoba) {
            choiceChoosable(Choice.blockAdvanceSlaves, true);
          }
          if (!stopped) {
            choiceChoosable(Choice.blockAdvanceCede, true);
          }
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.blockAdvanceNubianArchers)) {
          logLine('> Nubian Archers');
          logLine('> Nubian Archers are lost defending ${toLand.desc} against ${mek.desc}.');
          final nubianArchers = _state.pieceInLocation(PieceType.nubianArchers, toLand)!;
          _state.setPieceLocation(nubianArchers, Location.trayNubianArchers);
          logLine('> ${mek.desc} ceases its Advance.');
          _mekAdvanceState = null;
          return;
        } else if (checkChoiceAndClear(Choice.blockAdvanceMonastery)) {
          logLine('> Monastery');
          final monastery = _state.pieceInLocation(PieceType.monastery, toLand)!;
          int die = rollD6();
          int value = _state.monasteryValue(monastery);
          if (die >= value) {
            logLine('> Monastery in ${toLand.desc} withstands advance of ${mek.desc}.');
            _mekAdvanceState = null;
            return;
          } else {
            logLine('> ${mek.desc} destroys Monastery in ${toLand.desc}.');
            _state.setPieceLocation(monastery, Location.trayMonasteries);
            final uru = randPiece(_state.piecesInLocation(PieceType.uru, Location.cupUru))!;
            logLine('> ${uru.desc} enters the Mosque.');
            _state.setPieceLocation(uru, Location.boxTheMosque);
          }
        } else if (checkChoiceAndClear(Choice.blockAdvanceSlaves)) {
          logLine('> ${mek.desc} are bought off with Slaves.');
          _state.setPieceLocation(Piece.slaves, Location.poolSlavery);
          _mekAdvanceState = null;
          return;
        } else if (checkChoiceAndClear(Choice.blockAdvanceCede)) {
          if (toLand != Location.soba) {
            logLine('> ${mek.desc} captures ${toLand.desc}.');
            _state.setPieceLocation(mek, toLand);
            _mekAdvanceState = null;
            return;
          }
          checkCollapse();
        }
      }
    }
  }

  void pathRetreat(Path path) {
    // TODO
  }

  void assetDown(Piece asset) {
    // TODO
  }

  void assetUp(Piece asset) {
    // TODO
  }

  // Sequence of Play

  void turnBegin() {
	  logLine('# Turn ${_state.currentTurn + 1}');
  }

  void eventsPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Events Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Events Phase');
  }

  void eventsPhaseDrawNewCard() {
    _state.advanceDeck();
    logLine('### ${_state.cardTitle(_state.currentCard!)}');
  }

  void specialEventCopticPope() {
    logLine('### Coptic Pope');
    final oldMetropolitan = _state.pieceInLocation(PieceType.metropolitan, Location.boxMetrolpolitan)!;
    _state.setPieceLocation(oldMetropolitan, Location.cupMetropolitan);
    final newMetropolitan = randPiece(_state.piecesInLocation(PieceType.metropolitan, Location.cupMetropolitan))!;
    logLine('> ${oldMetropolitan.desc} dies and is replaced by ${newMetropolitan.desc}.');
    _state.setPieceLocation(newMetropolitan, Location.boxMetrolpolitan);
  }

  void specialEventCrusadeRoll() {
    logLine('### Crusades');
    int die = rollD6();
    Piece oldCrusadePiece = _state.pieceInLocation(PieceType.crusades, Location.crusadeLevel)!;
    int oldCrusadeLevel = _state.crusadeLevel(oldCrusadePiece);
    int newCrusadeLevel = 0;
    switch (die) {
    case 1:
    case 2:
    case 3:
    case 4:
      newCrusadeLevel = 2;
    case 5:
      newCrusadeLevel = 1;
    case 6:
      newCrusadeLevel = 0;
    }
    if (newCrusadeLevel == oldCrusadeLevel) {
      logLine('> Crusade Level remains at $oldCrusadeLevel.');
    } else {
      if (newCrusadeLevel > oldCrusadeLevel) {
        logLine('> Crusade Level rises to $newCrusadeLevel.');
      } else {
        logLine('> Crusade Level falls to $newCrusadeLevel.');
      }
      final newCrusadePiece = _state.crusadeLevelPiece(newCrusadeLevel);
      _state.setPieceLocation(oldCrusadePiece, Location.trayCrusades);
      _state.setPieceLocation(newCrusadePiece, Location.crusadeLevel);
    }
  }

  void specialEventEthiopians() {
    final feudal = _state.pathFeudal(Path.d);
    if (feudal == null || !feudal.isType(PieceType.feudalP1)) {
      return;
    }
    logLine('### Ethiopians');
    logLine('> Ethiopian allies come to your aid.');
    _state.setPieceLocation(Piece.ethiopians, Location.boxPathD);
  }

  void specialEventFlipAyyubids() {
    logLine('### Mamluk Sultanate');
    logLine('> Mamluk regiments overthrow their Ayyubid rulers.');
    final location = _state.pieceLocation(Piece.mekAyyubid);
    _state.setPieceLocation(Piece.mekAyyubid, Location.discarded);
    _state.setPieceLocation(Piece.mekMamluk, location);
  }

  void specialEventFlipJuhayna() {
    logLine('### Banu Jaʾd succeeds Banu Juhayna for primacy among Arab Nomad tribes');
    final location = _state.pieceLocation(Piece.mekJuhayna);
    _state.setPieceLocation(Piece.mekJuhayna, Location.discarded);
    _state.setPieceLocation(Piece.mekJad, location);
  }

  void specialEventFlipShilluk() {
    logLine('### Funj Sultanate');
    logLine('> The Funj Sultanate is established.');
    final location = _state.pieceLocation(Piece.mekShilluk);
    _state.setPieceLocation(Piece.mekShilluk, Location.discarded);
    _state.setPieceLocation(Piece.mekFunj, location);
  }

  void specialEventMosque() {
    logLine('### Mosque');
    int availableCount = _state.piecesInLocationCount(PieceType.mosque, Location.trayMosques);
    if (availableCount == 2) {
      final mekA = _state.pathMek(Path.a);
      final mekB = _state.pathMek(Path.b);
      final locationA = _state.pieceLocation(mekA);
      final locationB = _state.pieceLocation(mekB);
      final locationTypeA = _state.pathLocationType(Path.a);
      final locationTypeB = _state.pathLocationType(Path.b);
      int positionA = locationA.index - locationTypeA.firstIndex;
      int positionB = locationB.index - locationTypeB.firstIndex;
      final mosqueLocation = positionB <= positionA ? locationB : locationA;
      logLine('> A Mosque is built in ${mosqueLocation.desc}.');
      _state.setPieceLocation(Piece.mosque0, mosqueLocation);
    } else {
      final path = _state.pathMosqueCount(Path.b) > 0 ? Path.a : Path.b;
      final mek = _state.pathMek(path);
      final mosqueLocation = _state.pieceLocation(mek);
      logLine('> A Mosque is built in ${mosqueLocation.desc}.');
      _state.setPieceLocation(Piece.mosque1, mosqueLocation);
    }
  }

  void specialEventPortuguese() {
    logLine('### Portuguese');
    logLine('> Portugal signs an alliance with Nubia.');
    _state.setupPieceType(PieceType.portugal, Location.boxDowntownSoba);
  }

  void specialEventShekandaWar() {
    // TODO
  }

  void eventDisaster() {
    final disaster = randPiece(_state.piecesInLocation(PieceType.disaster, Location.cupDisaster))!;
    _state.setPieceLocation(disaster, Location.discarded);
    if (disaster.isType(PieceType.famine)) {
      logLine('### Famine');
      int die = rollD6();
      Piece? asset;
      switch (die) {
      case 1:
      case 2:
        asset = Piece.assetNobility;
      case 3:
      case 4:
        asset = Piece.assetKingship;
      case 5:
      case 6:
        asset = Piece.assetArmy;
      }
      assetDown(asset!);
    } else {
      Path? path;
      switch (disaster) {
      case Piece.migrationA0:
      case Piece.migrationA1:
        path = Path.a;
      case Piece.migrationB0:
        path = Path.b;
      case Piece.migrationC0:
      case Piece.migrationC1:
        path = Path.c;
      case Piece.migrationD0:
      case Piece.migrationD1:
        path = Path.d;
      case Piece.migrationE0:
        path = Path.e;
      default:
      }
      final mek = _state.pathMek(path!);
      logLine('### ${mek.desc} Migration');
      pathAdvance(path);
    }
  }

  void eventFeudalism() {
    logLine('### Feudalism');
    final results = roll2D6();
    int d1 = results.$1;
    int d2 = results.$2;
    Path? path;
    Location? location;
    Piece? oldFeudal;
    PieceType? newFeudalType;
    Piece? mek;
    if (d1 == 6) {
      path = Path.b;
      oldFeudal = _state.pathFeudal(Path.b);
      newFeudalType = _state.landIsPlayerControlled(Location.faras) ? PieceType.feudalN1 : PieceType.feudalP1;
      location = Location.boxPathB;
      mek = _state.pathMek(Path.b);
    } else if (d2 == 1) {
      location = Location.soba;
      oldFeudal = _state.pieceInLocation(PieceType.feudalN1, Location.soba);
      newFeudalType = PieceType.feudalN1;
    } else {
      path = Path.values[d1 - 1];
      final space = _state.pathSequenceLand(path, d2 - 2)!;
      oldFeudal = _state.pathFeudal(path);
      newFeudalType = _state.landIsPlayerControlled(space) ? PieceType.feudalN1 : PieceType.feudalP1;
      location = _state.pathBox(path);
      mek = _state.pathMek(path);
    }
    PieceType? oldFeudalType;
    if (oldFeudal != null) {
      oldFeudalType = oldFeudal.isType(PieceType.feudalN1) ? PieceType.feudalN1 : PieceType.feudalP1;
    }
    if (location == Location.soba && oldFeudal != null) {
      logLine('> Feudalism continues in Soba.');
      return;
    }
    if (oldFeudal == null) {
      if (_state.piecesInLocationCount(newFeudalType, Location.trayFeudalism) == 0) {
        logLine('> Feudalism remains unchanged.');
        return;
      }
      if (newFeudalType == PieceType.feudalN1) {
        if (path != null) {
          logLine('> Feudalism increases on ${path.desc}.');
        } else {
          logLine('> Feudalism increases.');
        }
      } else {
        logLine('> Feudalism weakens ${mek!.desc}.');
      }
      _state.setPieceLocation(_state.piecesInLocation(newFeudalType, Location.trayFeudalism)[0], location);
    } else if (oldFeudalType == newFeudalType) {
      if (newFeudalType == PieceType.feudalP1) {
        logLine('> Feudalism weakens ${mek!.desc}.');
        pathRetreat(path!);
      } else {
        logLine('> Feudalism increases on ${path!.desc}.');
        pathAdvance(path);
      }
    } else {
      if (newFeudalType == PieceType.feudalP1) {
        logLine('> Feudalism reduces on ${path!.desc}.');
      } else {
        logLine('> Feudalism reduces amongst ${mek!.desc}');
      }
      _state.setPieceLocation(oldFeudal, Location.trayFeudalism);
    }
  }

  void eventsPhaseEvent(int index) {
    final cardEventHandlers = {
      Card.kush: [specialEventCopticPope, eventFeudalism],
      Card.piye: [eventDisaster],
      Card.meroe: [specialEventCopticPope],
      Card.niloSaharanLanguages: [specialEventCrusadeRoll],
      Card.beja: [specialEventCopticPope],
      Card.nubianMurals: [eventDisaster],
      Card.arabOccupiedEgypt: [specialEventFlipAyyubids, eventFeudalism],
      Card.shekandaWar: [specialEventShekandaWar, specialEventCopticPope],
      Card.conversionOfNubia: [specialEventCrusadeRoll, eventFeudalism],
      Card.copticInfluence: [specialEventMosque, specialEventCopticPope, eventFeudalism],
      Card.nobadia: [eventDisaster, eventFeudalism],
      Card.makuria: [specialEventCopticPope, eventDisaster, eventDisaster],
      Card.alodia: [specialEventFlipJuhayna, eventFeudalism],
      Card.farasCathedral: [specialEventCopticPope, eventDisaster, eventFeudalism],
      Card.nubianMigrations: [specialEventMosque, specialEventCopticPope],
      Card.silko: [specialEventCopticPope, eventDisaster, eventFeudalism],
      Card.baqt: [eventDisaster, eventFeudalism],
      Card.funj: [specialEventFlipShilluk, eventFeudalism],
      Card.arabColonization: [specialEventCopticPope, eventDisaster],
      Card.soba: [eventDisaster, eventFeudalism],
      Card.axum: [specialEventEthiopians, specialEventCopticPope, eventFeudalism],
      Card.kokka: [specialEventCopticPope, specialEventCrusadeRoll, eventDisaster, eventFeudalism],
      Card.islamization: [specialEventCopticPope],
      Card.culturalSurvivals: [eventDisaster, eventFeudalism],
      Card.oldNubianLanguage: [specialEventCopticPope, eventFeudalism],
      Card.portuguese: [specialEventPortuguese, eventDisaster],
      Card.nubiaToday: [specialEventCopticPope, eventFeudalism],
    };
    final eventHandlers = cardEventHandlers[_state.currentCard!];
    if (eventHandlers == null) {
      return;
    }
    if (index >= eventHandlers.length) {
      return;
    }
    eventHandlers[index]();
  }

  void eventsPhaseEvent0() {
    eventsPhaseEvent(0);
  }

  void eventsPhaseEvent1() {
    eventsPhaseEvent(1);
  }

  void eventsPhaseEvent2() {
    eventsPhaseEvent(2);
  }

  void eventsPhaseEvent3() {
    eventsPhaseEvent(3);
  }

  void uruPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Uru Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Uru Phase');
  }

  void uruPhaseNewUru() {
    logLine('### New Uru');
    final oldUru = _state.pieceInLocation(PieceType.uru, Location.boxUru)!;
    _state.setPieceLocation(oldUru, Location.cupUru);
    final crownPrince = _state.pieceInLocation(PieceType.uru, Location.boxCrownPrince);
    if (crownPrince != null) {
      logLine('> Crown Prince ${crownPrince.desc} becomes Uru.');
      _state.setPieceLocation(crownPrince, Location.boxUru);
    } else {
      final newUru = randPiece(_state.piecesInLocation(PieceType.uru, Location.cupUru))!;
      logLine('> ${newUru.desc} becomes Uru.');
      _state.setPieceLocation(newUru, Location.boxUru);
    }
  }

  void uruPhaseFeudal() {
    bool haveFeudalTiles = false;
    for (final feudal in PieceType.feudal.pieces) {
      final location = _state.pieceLocation(feudal);
      if (location != Location.trayFeudalism) {
        haveFeudalTiles = true;
      }
    }
    if (!haveFeudalTiles) {
      return;
    }
    final uru = _state.pieceInLocation(PieceType.uru, Location.boxUru)!;
    bool cunning = _state.uruCunning(uru);
    bool impulsive = _state.uruImpulsive(uru);
    if (!cunning && !impulsive) {
      return;
    }
    if (cunning) {
      if (choicesEmpty()) {
        setPrompt('Remove all Feudal Tiles?');
        choiceChoosable(Choice.yes, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.no)) {
        return;
      }
      clearChoices();
    }
    logLine('> Uru ${uru.desc} removes all Feudal Tiles.');
    for (final feudal in PieceType.feudal.pieces) {
      final location = _state.pieceLocation(feudal);
      if (location != Location.trayFeudalism) {
        _state.setPieceLocation(feudal, Location.trayFeudalism);
      }
    }
  }

  void mekPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Mek Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Mek Phase');
  }

  void pathAdvanceA() {
    pathAdvance(Path.a);
  }

  void pathAdvanceB() {
    pathAdvance(Path.b);
  }

  void pathAdvanceC() {
    pathAdvance(Path.c);
  }

  void pathAdvanceD() {
    pathAdvance(Path.d);
  }

  void pathAdvanceE() {
    pathAdvance(Path.e);
  }

  void pathRetreatB() {
    pathRetreat(Path.b);
  }

  void pathRetreatC() {
    pathRetreat(Path.c);
  }

  void pathRetreatE() {
    pathRetreat(Path.e);
  }

  void assetDownNobility() {
    assetDown(Piece.assetNobility);
  }

  void assetDownKingship() {
    assetDown(Piece.assetKingship);
  }

  void assetDownArmy() {
    assetDown(Piece.assetArmy);
  }

  void assetUpNobility() {
    assetUp(Piece.assetNobility);
  }

  void assetUpKingship() {
    assetUp(Piece.assetKingship);
  }

  void assetUpArmy() {
    assetUp(Piece.assetArmy);
  }

  void mekPhaseMove(int index) {
    final cardMoves = {
      Card.kush: [pathAdvanceB, assetDownNobility],
      Card.piye: [pathAdvanceD, assetDownNobility],
      Card.meroe: [pathAdvanceB, pathAdvanceE],
      Card.niloSaharanLanguages: [pathAdvanceA, pathAdvanceC],
      Card.beja: [pathAdvanceB, pathAdvanceC, assetDownArmy],
      Card.nubianMurals: [pathAdvanceA, pathAdvanceB],
      Card.arabOccupiedEgypt: [pathAdvanceC, assetDownKingship, assetDownArmy],
      Card.shekandaWar: [],
      Card.conversionOfNubia: [pathAdvanceA, pathAdvanceB, pathAdvanceC, pathAdvanceD, assetDownKingship],
      Card.copticInfluence: [pathAdvanceE, assetDownKingship, assetDownNobility],
      Card.nobadia: [pathAdvanceB, pathAdvanceC, assetDownKingship],
      Card.makuria: [pathAdvanceB, pathAdvanceC, pathAdvanceE, assetDownNobility, assetDownArmy],
      Card.alodia: [pathAdvanceA, pathAdvanceD, assetDownNobility, assetDownArmy],
      Card.farasCathedral: [pathAdvanceB, pathAdvanceC, assetDownArmy],
      Card.nubianMigrations: [pathAdvanceB, pathAdvanceE, assetDownKingship],
      Card.silko: [pathAdvanceE, assetDownNobility],
      Card.baqt: [pathAdvanceA, pathAdvanceC, assetDownKingship],
      Card.funj: [pathAdvanceC, pathAdvanceD, assetDownArmy],
      Card.arabColonization: [pathAdvanceC, pathAdvanceD, assetUpNobility, assetUpKingship],
      Card.soba: [pathAdvanceA, pathAdvanceC, pathAdvanceD, pathAdvanceE, assetDownKingship],
      Card.axum: [pathAdvanceA, pathAdvanceB, pathAdvanceD, pathAdvanceE, assetDownNobility],
      Card.kokka: [pathAdvanceA, pathAdvanceC, assetDownArmy],
      Card.islamization: [pathAdvanceB, pathAdvanceC, pathAdvanceD],
      Card.culturalSurvivals: [pathRetreatB, pathRetreatC, pathRetreatE, assetDownNobility],
      Card.oldNubianLanguage: [pathAdvanceA, pathAdvanceB, pathAdvanceC, assetDownNobility, assetDownKingship],
      Card.portuguese: [pathAdvanceC, assetUpArmy],
      Card.nubiaToday: [pathAdvanceC, pathAdvanceE, assetDownKingship, assetDownArmy],
    };
    final moves = cardMoves[_state.currentCard!]!;
    if (index < moves.length) {
      moves[index]();
    }
  }
  
  void mekPhaseMove0() {
    mekPhaseMove(0);
  }

  void mekPhaseMove1() {
    mekPhaseMove(1);
  }

  void mekPhaseMove2() {
    mekPhaseMove(2);
  }

  void mekPhaseMove3() {
    mekPhaseMove(3);
  }

  void mekPhaseMove4() {
    mekPhaseMove(4);
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      eventsPhaseBegin,
      eventsPhaseDrawNewCard,
      eventsPhaseEvent0,
      eventsPhaseEvent1,
      eventsPhaseEvent2,
      eventsPhaseEvent3,
      uruPhaseBegin,
      uruPhaseNewUru,
      uruPhaseFeudal,
      mekPhaseBegin,
      mekPhaseMove0,
      mekPhaseMove1,
      mekPhaseMove2,
      mekPhaseMove3,
      mekPhaseMove4,
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

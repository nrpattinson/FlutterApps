import 'dart:math';

enum Location {
  brittany,
  flanders,
  gascony,
  ileDeFrance,
  liguria,
  lorraine,
  palatinate,
  picardy,
  provence,
  savoy,
  vendee,
  england,
  ireland,
  scotland,
  caucasia,
  don,
  georgia,
  kaluga,
  kharkov,
  kherson,
  kiev,
  lithuania,
  livland,
  minsk,
  moscow,
  oryol,
  poltava,
  pskov,
  smolensk,
  stPetersburg,
  vitebsk,
  volhynia,
  austria,
  bohemia,
  galicia,
  hungary,
  illyria,
  transylvania,
  tyrol,
  venice,
  westGalicia,
  brandenburg,
  greatPoland,
  prussia,
  silesia,
  westphalia,
  andalucia,
  catalonia,
  leon,
  newCastile,
  oldCastile,
  baden,
  bavaria,
  hanover,
  hesse,
  mecklenburg,
  saxony,
  etruria,
  milan,
  papalStates,
  finland,
  sweden,
  denmark,
  norway,
  holland,
  switzerland,
  naples,
  portugal,
  anatolia,
  bosnia,
  edirne,
  egypt,
  greece,
  hatay,
  mesopotamia,
  moldavia,
  serbia,
  syria,
  trabzon,
  wallachia,
  balticSea,
  kattegat,
  germanOcean,
  englishChannel,
  atlanticOcean,
  westernMediterranean,
  centralMediterranean,
  easternMediterranean,
  blackSea,
  powerStatusCoalition,
  powerStatusNeutral,
  powerStatusEmpire,
  powerStatusBonapartist,
  offmap,
}

enum LocationType {
  region,
  navalZone,
  powerStatus,
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

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.region: [Location.brittany, Location.wallachia],
    LocationType.navalZone: [Location.balticSea, Location.blackSea],
    LocationType.powerStatus: [Location.powerStatusCoalition, Location.powerStatusBonapartist],
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
  String get name {
    const locationNames = {
      Location.brittany: 'Brittany',
      Location.flanders: 'Flanders',
      Location.gascony: 'Gascony',
      Location.ileDeFrance: 'Île-de-France',
      Location.liguria: 'Liguria',
      Location.lorraine: 'Lorraine',
      Location.palatinate: 'Palatinate',
      Location.picardy: 'Picardy',
      Location.provence: 'Provence',
      Location.savoy: 'Savoy',
      Location.vendee: 'Vendée',
      Location.england: 'England',
      Location.ireland: 'Ireland',
      Location.scotland: 'Scotland',
      Location.caucasia: 'Caucasia',
      Location.don: 'Don',
      Location.georgia: 'Georgia',
      Location.kaluga: 'Kaluga',
      Location.kharkov: 'Kharkov',
      Location.kherson: 'Kherson',
      Location.kiev: 'Kiev',
      Location.lithuania: 'Lithuania',
      Location.livland: 'Livland',
      Location.minsk: 'Minsk',
      Location.moscow: 'Moscow',
      Location.oryol: 'Oryol',
      Location.poltava: 'Poltava',
      Location.pskov: 'Pskov',
      Location.smolensk: 'Smolensk',
      Location.stPetersburg: 'St. Petersburg',
      Location.vitebsk: 'Vitebsk',
      Location.volhynia: 'Volhynia',
      Location.austria: 'Austria',
      Location.bohemia: 'Bohemia',
      Location.galicia: 'Galicia',
      Location.hungary: 'Hungary',
      Location.illyria: 'Illyria',
      Location.transylvania: 'Transylvania',
      Location.tyrol: 'Tyrol',
      Location.venice: 'Venice',
      Location.westGalicia: 'West Galicia',
      Location.brandenburg: 'Brandenburg',
      Location.greatPoland: 'Great Poland',
      Location.prussia: 'Prussia',
      Location.silesia: 'Silesia',
      Location.westphalia: 'Westphalia',
      Location.andalucia: 'Andalucia',
      Location.catalonia: 'Catalonia',
      Location.leon: 'Leon',
      Location.newCastile: 'New Castile',
      Location.oldCastile: 'Old Castile',
      Location.baden: 'Baden',
      Location.bavaria: 'Bavaria',
      Location.hanover: 'Hanover',
      Location.hesse: 'Hesse',
      Location.mecklenburg: 'Mecklenburg',
      Location.saxony: 'Saxony',
      Location.etruria: 'Etruria',
      Location.milan: 'Milan',
      Location.papalStates: 'Papal States',
      Location.finland: 'Finland',
      Location.sweden: 'Sweden',
      Location.denmark: 'Denmark',
      Location.norway: 'Norway',
      Location.holland: 'Holland',
      Location.switzerland: 'Switzerland',
      Location.naples: 'Naples',
      Location.portugal: 'Portugal',
      Location.anatolia: 'Anatolia',
      Location.bosnia: 'Bosnia',
      Location.edirne: 'Edirne',
      Location.egypt: 'Egypt',
      Location.greece: 'Greece',
      Location.hatay: 'Hatay',
      Location.mesopotamia: 'Mesopotamia',
      Location.moldavia: 'Moldavia',
      Location.serbia: 'Serbia',
      Location.syria: 'Syria',
      Location.trabzon: 'Trabzon',
      Location.wallachia: 'Wallachia',
    };
    return locationNames[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Piece {
  armyFrance0,
  armyFrance1,
  armyFrance2,
  armyFrance3,
  armyFrance4,
  armyFrance5,
  armyFrance6,
  armyFrance7,
  armyFrance8,
  armyFrance9,
  armyFrance10,
  armyFranceImperialGuard,
  armyBritainEngland,
  armyRussiaDon,
  armyRussiaKharkov,
  arnyRussyaKherson,
  armyRussiaKiev,
  armyRussiaLithuania,
  armyRussiaMoscow,
  armyRussiaStPetersburg,
  armyRussiaVitebsk,
  armyRussiaGreatPoland,
  armyAustriaAustria,
  armyAustriaBohemia,
  armyAustriaGalicia,
  armyAustriaHungary,
  armyAustriaTyrol,
  armyAustriaVenice,
  armyAustriaIllyria,
  armyPrussiaBrandenburg,
  armyPrussiaGreatPoland,
  armyPrussiaPrussia,
  armyPrussiaSilesia,
  armyPrussiaWestphalia,
  armySpainCatalonia,
  armySpainNewCastile,
  armyGermanyBaden,
  armyGermanyBavaria,
  armyGermanyHanover,
  armyGermanySaxony,
  armyGermanyWestphalia,
  armyItalyMilan,
  armyItalyPapalStates,
  armyItalyVenice,
  armySwedenSweden,
  armyDenmarkDenmark,
  armyWarsawKiev,
  armyWarsawLithuania,
  armyWarsawWestGalicia,
  armyWarsawGreatPoland,
  armyHollandHolland,
  armySwitzerlandSwitzerland,
  armyNaplesNaples,
  armyNaplesPapalStates,
  armyPortugalPortugal,
  armyTurkeyAnatolia,
  armyTurkeyBosnia,
  armyTurkeyEdirne,
  armyTurkeyEgypt,
  armyTurkeySerbia,
  armyTurkeyTrabzon,
  garrisonFranceBrittany,
  garrisonFranceFlanders,
  garrisonFranceGascony,
  garrisonFranceIleDeFrance,
  garrisonFranceLiguria,
  garrisonFranceLorraine,
  garrisonFrancePalatinate,
  garrisonFrancePicardy,
  garrisonFranceProvence,
  garrisonFranceSavoy,
  garrisonFranceVendee,
  garrisonFranceIllyria,
  garrisonFranceHanover,
  garrisonFranceEtruria,
  garrisonFrancePapalStates,
  garrisonFranceEgypt,
  garrisonBritainEngland,
  garrisonBritainIreland,
  garrisonBritainScotland,
  garrisonRussiaCaucasia,
  garrisonRussiaDon,
  garrisonRussiaGeorgia,
  garrisonRussiaKaluga,
  garrisonRussiaKharkov,
  garrisonRussiaKherson,
  garrisonRussiaKiev,
  garrisonRussiaLithuania,
  garrisonRussiaLivland,
  garrisonRussiaMinsk,
  garrisonRussiaMoscow,
  garrisonRussiaOryol,
  garrisonRussiaPoltava,
  garrisonRussiaPskov,
  garrisonRussiaSmolensk,
  garrisonRussiaStPetersburg,
  garrisonRussiaVitebsk,
  garrisonRussiaVolhynia,
  garrisonRussiaGalicia,
  garrisonRussiaWestGalicia,
  garrisonRussiaGreatPoland,
  garrisonRussiaFinland,
  garrisonAustriaAustria,
  garrisonAustriaBohemia,
  garrisonAustriaGalicia,
  garrisonAustriaHungary,
  garrisonAustriaIllyria,
  garrisonAustriaTransylvania,
  garrisonAustriaTyrol,
  garrisonAustriaVenice,
  garrisonAustriaWestGalicia,
  garrisonAustriaBavaria,
  garrisonAustriaBosnia,
  garrisonPrussiaBrandenburg,
  garrisonPrussiaGreatPoland,
  garrisonPrussiaPrussia,
  garrisonPrussiaSilesia,
  garrisonPrussiaWestphalia,
  garrisonPrussiaWestGalicia,
  garrisonSpainAndalucia,
  garrisonSpainCatalonia,
  garrisonSpainLeon,
  garrisonSpainNewCastile,
  garrisonSpainOldCastile,
  garrisonGermanyBaden,
  garrisonGermanyBavaria,
  garrisonGermanyHanover,
  garrisonGermanyHesse,
  garrisonGermanyMecklenburg,
  garrisonGermanySaxony,
  garrisonGermanyTyrol,
  garrisonGermanyWestphalia,
  garrisonItalyEtruria,
  garrisonItalyMilan,
  garrisonItalyPapalStates,
  garrisonItalyVenice,
  garrisonSwedenFinland,
  garrisonSwedenSweden,
  garrisonSwedenMecklenburg,
  garrisonSwedenNorway,
  garrisonDenmarkDenmark,
  garrisonDenmarkNorway,
  garrisonWarsawKiev,
  garrisonWarsawMinsk,
  garrisonWarsawVitebsk,
  garrisonWarsawVolhynia,
  garrisonWarsawWestGalicia,
  garrisonWarsawGalicia,
  garrisonWarsawGreatPoland,
  garrisonHollandHolland,
  garrisonSwitzerlandSwitzerland,
  garrisonNaplesNaples,
  garrisonNaplesEtruria,
  garrisonNaplesPapalStates,
  garrisonPortugalPortugal,
  garrisonTurkeyAnatolia,
  garrisonTurkeyBosnia,
  garrisonTurkeyCaucasia,
  garrisonTurkeyEdirne,
  garrisonTurkeyEgypt,
  garrisonTurkeyGeorgia,
  garrisonTurkeyTransylvania,
  fleetFranceAtlantic,
  fleetFranceWesternMediterranean,
  fleetBritainChannel,
  fleetBritainWesternMediterranean,
  fleetRussiaBaltic,
  fleetSwedenBaltic,
  fleetDenmarkKattegat,
  rebelFrance10,
  rebelFrance11,
  rebelFrance12,
  rebelFrance13,
  rebelFrance20,
  rebelFrance21,
  rebelFrance30,
  rebelFrance31,
  rebelFrance40,
  rebelFrance41,
  rebelCoalition10,
  rebelCoalition11,
  rebelCoalition12,
  rebelCoalition13,
  rebelCoalition20,
  rebelCoalition21,
  rebelCoalition30,
  rebelCoalition31,
  rebelCoalition40,
  rebelCoalition41,
  reform0,
  reform1,
  reform2,
  reform3,
  reform4,
  reform5,
  reform6,
  reform7,
  reform8,
  reform9,
  reform10,
  reform11,
  powerStatusFrance,
  powerStatusBritain,
  powerStatusRussia,
  powerStatusAustria,
  powerStatusPrussia,
  powerStatusSpain,
  powerStatusGermany,
  powerStatusRhine,
  powerStatusItaly,
  powerStatusSweden,
  powerStatusDenmark,
  powerStatusWarsaw,
  powerStatusHolland,
  powerStatusSwitzerland,
  powerStatusNaples,
  powerStatusPortugal,
  powerStatusTurkey,
  chitPowerRussia,
  chitPowerAustria,
  chitPowerPrussia,
  chitPowerSpain,
  chitPowerGermanyRhine,
  chitPowerItaly,
  chitPowerSweden,
  chitPowerDenmark,
  chitPowerWarsaw,
  chitPowerHolland,
  chitPowerSwitzerland,
  chitPowerNaples,
  chitOowerPortugal,
  chitPowerTurkey,
  chitLeaderFranceNapoleon,
  chitLeaderFranceMarshall,
  chitLeaderBritainWellington,
  chitLeaderBritainNelson,
  chitLeaderRussiaBarclay,
  chitLeaderRussiaKutusov,
  chitLeaderAustriaCharles,
  chitLeaderPrussiaBlucher,
  chitEventClimate,
  chitEventEuropeanCrisis,
  chitEventFinance,
  chitEventOffMapWar,
  chitEventRebels0,
  chitEventRebels1,
  chitFowBrilliantDefense,
  chitFowBrillianManoeuver,
  chitFowLackOfCoordination,
  chitFowLanguageBarrier,
  chitFowMasterlyWithdrawal,
  chitFowOffDay,
  chitFowTakeTheInitiative,
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
  army,
  garrison,
  fleet,
  powerStatus,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.armyFrance0, Piece.],
    PieceType.army: [Piece.armyFrance0, Piece.armyTurkeyTrabzon],
    PieceType.garrison: [Piece.garrisonFranceBrittany, Piece.garrisonTurkeyTransylvania],
    PieceType.fleet: [Piece.fleetFranceAtlantic, Piece.fleetDenmarkKattegat],
    PieceType.powerStatus: [Piece.powerStatusFrance, Piece.powerStatusTurkey],
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
  String get name {
    const pieceNames = {
    };
    return pieceNames[this]!;
  }

  bool isType(PieceType pieceType) {
    return index >= pieceType.firstIndex && index < pieceType.lastIndex;
  }
}

enum Scenario {
  thirdCoalition,
  fourthCoalition,
  fifthCoalition,
  sixthCoalition,
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.offmap);

  GameState();

  GameState.fromJson(Map<String, dynamic> json) {
    _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']));
  }

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

  factory GameState.setupThirdCoalition() {

    var state = GameState();

    state.setupPieceTypes([
    ]);

    state.setupPieces([
    ]);

    return state;
  }

  factory GameState.setupFourthCoalition() {

    var state = GameState();

    state.setupPieceTypes([
    ]);

    state.setupPieces([
    ]);

    return state;
  }
}

enum Choice {
  yes,
  no,
  cancel,
  next,
}

class PlayerChoice {
  Location? location;
  Piece? piece;
  Choice? choice;

  PlayerChoice();
}

class PlayerChoiceInfo {
  String prompt = '';
  final locations = <Location>[];
  final pieces = <Piece>[];
  final choices = <Choice>[];
  final disabledChoices = <Choice>[];
  final selectedLocations = <Location>[];
  final selectedPieces = <Piece>[];
  final selectedChoices = <Choice>[];

  PlayerChoiceInfo();

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
}

enum GameResult {
  defeatConstantinople,
  defeatSchism,
  victory,
}

class GameOverException implements Exception {
  GameResult  result;
  int         victoryPoints;

  GameOverException(this.result, this.victoryPoints);
}

class PhaseState {
}

class PhaseStateTurnStart extends PhaseState {
  Path? randomBarbarianPath;
}

class PhaseStateLeadership extends PhaseState {
  Path? socialEventPath;
}

class PhaseStateSynopsisOfHistories extends PhaseState {
  int militaryTotal;
  int politicalTotal;
  int? warInTheEast1Dice;
  int? warInTheEast1PersianAdvanceCount;
  int? warInTheEast1PersianRetreatCount;
  int? rotrudeDieRoll;
  bool seljuksTriggerCrusades = false;

  PhaseStateSynopsisOfHistories(this.militaryTotal, this.politicalTotal);
}

class PhaseStateBarbarians extends PhaseState {
  List<int> pathAdvanceCounts = List<int>.filled(Path.values.length, 0);
}

class PhaseStateByzantineAction extends PhaseState {
  int shiftForcesRetreatCount = 0;
  int soldierEmperorFreeAttackCount = 0;
  bool magisterMilitumFreeAttack = false;
  bool basileusIntoBattle = false;
  Piece? attackTarget;
  Path? advancePath;
  int? postAdvanceSchismAdjustment;
  int? magisterMilitumDefeatStrength;
  bool enforceOrthodoxyIgnoreDrms = false;
  bool enforceOthodoxyFree = false;
  bool useBasileus = false;
}

class RollD6ForEasternPathState {
  int? d60;
  int? d61;
}

class BarbariansAdvanceState {
  int subStep = 0;
  bool kastronUsed = false;
  int fizzleFactionCount = 0;
}

class FreeAttackState {
  int subStep = 0;
  Piece? target;
}

enum AdvanceType {
  regular,
  automatic,
}

enum AttackType {
  regular,
  free,
  magisterMilitum,
  intoBattleSword,
  intoBattleNoSword,
  shiftForces,
}

class Game {
  int _step = 0;
  int _subStep = 0;
  (GameResult, int)? _outcome;
  final GameState _state;
  PhaseState? _phaseState;
  RollD6ForEasternPathState? _rollD6ForEasternPathState;
  BarbariansAdvanceState? _barbariansAdvanceState;
  FreeAttackState? _freeAttackState;
  String _log = '';
  final _choiceInfo = PlayerChoiceInfo();
  final _random = Random();

  Game(this._state);

  String get log {
    return _log;
  }

  void logLine(String line) {
    _log += '$line  \n';
  }

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
    //logLine('Roll: ![](resource:assets/images/fitna.png)');
    return die;
  }

  int dieWithDrm(int die, int drm) {
    if (die == 1 || die == 6) {
      return die;
    }
    return die + drm;
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

  Path? randPath(List<Path> paths) {
    if (paths.isEmpty) {
      return null;
    }
    if (paths.length == 1) {
      return paths[0];
    }
    int choice = randInt(paths.length);
    return paths[choice];
  }

  Piece drawDynasty() {
    final dynasties = _state.piecesInLocation(PieceType.dynasty, Location.cupDynasty);
    if (dynasties.isEmpty) {
      for (final blackDynasty in PieceType.dynastyBlack.pieces) {
        final purpleDynasty = _state.pieceFlipSide(blackDynasty)!;
        if (_state.pieceLocation(purpleDynasty) == Location.discarded) {
          dynasties.add(blackDynasty);
        }
      }
    }
    return randPiece(dynasties)!;
  }

  Piece drawBasileus() {
    var basileus = randPiece(_state.piecesInLocation(PieceType.basileus, Location.cupBasileus))!;
    final side = randInt(2);
    if (side == 1) {
      basileus = _state.pieceFlipSide(basileus)!;
    }
    return basileus;
  }

  void removeOldBasileus() {
    for (var basileus in _state.currentBasileis) {
      if (basileus == Piece.basileusTheodosius) {
        _state.setPieceLocation(Piece.basileusJustinian, Location.chronographia3);
      } else if (basileus == Piece.basileusJustinian) {
        _state.setPieceLocation(Piece.basileusJustinian, Location.discarded);
      } else {
        if (basileus.isType(PieceType.basileusBackRandom)) {
          basileus = _state.pieceFlipSide(basileus)!;
        }
        _state.setPieceLocation(basileus, Location.cupBasileus);
      }
    }
  }

  void removeRandomFaction(int replaceCost) {
    final factions = _state.piecesInLocation(PieceType.factionRegular, Location.constantinople);
    if (factions.isEmpty) {
      if (_state.pieceLocation(Piece.factionHagiaSophia) == Location.constantinople) {
        factions.add(Piece.factionHagiaSophia);
      }
    }
    if (factions.isEmpty) {
      if (_state.pieceLocation(Piece.factionTheodosianWalls) == Location.constantinople) {
        factions.add(Piece.factionTheodosianWalls);
      }
    }
    if (factions.isEmpty) {
      return;
    }
    final faction = randPiece(factions)!;
    logLine('> ${_state.factionName(faction)} is eliminated from ${_state.landName(Location.constantinople)}.');
    _state.setPieceLocation(faction, _state.omnibusBox(replaceCost));
  }

  // Choices

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

  bool choicesEmptyApartFromPieces() {
    return _choiceInfo.selectedChoices.isEmpty && _choiceInfo.selectedLocations.isEmpty;
  }

  // Logging Functions

  void adjustSolidus(int delta) {
    _state.adjustSolidus(delta);
    if (delta > 0) {
      logLine('> \$olidus: +$delta => ${_state.solidus}');
    } else if (delta < 0) {
      logLine('> \$olidus: $delta => ${_state.solidus}');
    }
  }

  void adjustNike(int delta) {
    _state.adjustNike(delta);
    if (delta > 0) {
      logLine('> Nike: +$delta => ${_state.nike}');
    } else if (delta < 0) {
      logLine('> Nike: $delta => ${_state.nike}');
    }
  }

  void spendSolidus(int amount) {
    int nikeAmount = min(amount, max(_state.nike - 3, 0));
    if (nikeAmount > 0) {
      adjustNike(-nikeAmount);
    }
    int solidusAmount = amount - nikeAmount;
    if (solidusAmount > 0) {
      adjustSolidus(-solidusAmount);
    }
  }

  void adjustSchism(int delta) {
    final oldValue = _state.schism;
    _state.adjustSchism(delta);
    final newValue = _state.schism;
    if (oldValue == 0 && newValue == 0) {
      return;
    }
    if (delta > 0) {
      logLine('> Schism: +$delta => ${_state.schism}');
      if (_state.schism > 12) {
        logLine('# Defeat: Schism exceeds 12');
        throw GameOverException(GameResult.defeatSchism, 0);
      }
    } else if (delta < 0) {
      logLine('> Schism: $delta => ${_state.schism}');
    }
  }

  void adjustReforms(int delta) {
    _state.adjustReforms(delta);
    if (delta > 0) {
      logLine('> Reforms: +$delta => ${_state.reforms}');
      if (_state.reformed) {
        logLine('> Reforms achieved.');
      }
    }
  }

  // High-Level Functions

  void armyEntersZone(Piece army, Location zone) {
    final path = _state.landPath(zone)!;
    logLine('> ${_state.armyName(army)} deploys to ${_state.pathGeographicName(path)}.');
    _state.setPieceLocation(army, zone);
    final armyType = _state.pathArmyType(path);
    int armyCount = _state.piecesInLocationCount(armyType, zone);
    if (armyCount >= 4) {
      if (_state.pieceLocation(Piece.ravenna) == zone) {
        logLine('> Ravenna falls under the control of the Holy Roman Empire.');
        _state.setPieceLocation(Piece.holyRomanEmpire, zone);
      }
    }
    if (armyCount >= 5) {
      final monastery = _state.pieceInLocation(PieceType.connectedMonastery, zone);
      if (monastery != null) {
        logLine('> Monastery in ${_state.pathGeographicName(path)} is isolated.');
        _state.setPieceLocation(_state.pieceFlipSide(monastery)!, zone);
      }
    }
  }

  void armyLeavesZone(Piece army, Location zone) {
    logLine('> ${_state.armyName(army)} returns to the Reserves.');
    final path = _state.landPath(zone)!;
    final reserves = _state.pathReserves(path);
    _state.setPieceLocation(army, reserves);
  }

  void italyFalls() {
    _state.setPieceLocation(Piece.geographyBalkans, Location.zoneWest);
    if (_state.pieceLocation(Piece.ravenna) == Location.zoneWest) {
      logLine('> Ravenna is taken.');
      _state.setPieceLocation(Piece.ravenna, Location.discarded);
    }
    if (_state.pieceLocation(Piece.holyRomanEmpire) == Location.zoneWest) {
      _state.setPieceLocation(Piece.holyRomanEmpire, Location.discarded);
    }
  }

  int get seizeOutpostCost {
    int cost = 2;
    if (_state.basileisAreSoldier) {
      cost -= 1;
    }
    return cost;
  }

  List<Piece> get abandonOutpostCandidates {
    final candidates = <Piece>[];
    for (final outpost in PieceType.outpost.pieces) {
      if (_state.pieceLocation(outpost).isType(LocationType.outpostBox)) {
        candidates.add(outpost);
      }
    }
    return candidates;
  }

  int get buildMonasteryCost {
    int cost = 3;
    if (_state.basileisAreSaint) {
      cost -= 1;
    }
    return cost;
  }

  List<Location> get buildMonasteryCandidateLocations {
    final candidates = <Location>[];
    for (final zone in [Location.zoneWest, Location.zoneNorth]) {
      if (_state.piecesInLocationCount(PieceType.monastery, zone) == 0) {
        final path = _state.landPath(zone)!;
        final armyType = _state.pathArmyType(path);
        if (_state.piecesInLocationCount(armyType, zone) <= 4) {
          candidates.add(zone);
        }
      }
    }
    return candidates;
  }

  List<Location> get buildHospitalCandidateLocations {
    final candidates = <Location>[];
    for (final path in Path.values) {
      final armyType = _state.pathArmyType(path);
      if (_state.pathIsZone(path)) {
        final zone = _state.pathZone(path);
        if (_state.piecesInLocationCount(PieceType.hospital, zone) == 0) {
          if (_state.piecesInLocationCount(armyType, zone) <= 4) {
            candidates.add(zone);
          }
        }
      } else {
        final locationType = _state.pathLocationType(path);
        Location? prevLand;
        Location? pathCandidate;
        for (final land in locationType.locations) {
          if (_state.piecesInLocationCount(PieceType.hospital, land) > 0) {
            pathCandidate = null;
            break;
          }
          if (_state.piecesInLocationCount(armyType, land) > 0) {
            if (prevLand != null) {
              pathCandidate = prevLand;
            }
          }
          prevLand = land;
        }
        if (pathCandidate != null) {
          candidates.add(pathCandidate);
        }
      }
    }
    return candidates;
  }

  List<Piece> get abandonHospitalCandidates {
    final candidates = <Piece>[];
    for (final path in Path.values) {
      final armyType = _state.pathArmyType(path);
      if (_state.pathIsZone(path)) {
        final zone = _state.pathZone(path);
        final hospital = _state.pieceInLocation(PieceType.hospital, zone);
        if (hospital != null) {
          if (_state.piecesInLocationCount(armyType, zone) >= 5) {
            candidates.add(hospital);
          }
        }
      } else {
        final locationType = _state.pathLocationType(path);
        bool behindLines = false;
        for (final land in locationType.locations) {
          if (_state.piecesInLocationCount(armyType, land) > 0) {
            behindLines = true;
          }
          final hospital = _state.pieceInLocation(PieceType.hospital, land);
          if (hospital != null) {
            if (behindLines) {
              candidates.add(hospital);
            }
            break;
          }
        }
      }
    }
    return candidates;
  }

  List<Location> get buildAkritaiCandidateLocations {
    final candidates = <Location>[];
    for (final path in _state.easternPaths) {
      final armyType = _state.pathArmyType(path);
      final locationType = _state.pathLocationType(path);
      Location? prevLand;
      Location? pathCandidate;
      for (final land in locationType.locations) {
        if (_state.piecesInLocationCount(PieceType.akritai, land) > 0) {
          pathCandidate = null;
          break;
        }
        if (_state.piecesInLocationCount(armyType, land) > 0) {
          if (prevLand != null) {
            pathCandidate = prevLand;
          }
        }
        prevLand = land;
      }
      if (pathCandidate != null) {
        candidates.add(pathCandidate);
      }
    }
    return candidates;
  }

  List<Piece> get abandonAkritaiCandidates {
    final candidates = <Piece>[];
    for (final path in Path.values) {
      final armyType = _state.pathArmyType(path);
      if (_state.pathIsZone(path)) {
        final zone = _state.pathZone(path);
        final akritai = _state.pieceInLocation(PieceType.akritai, zone);
        if (akritai != null) {
          if (_state.piecesInLocationCount(armyType, zone) >= 5) {
            candidates.add(akritai);
          }
        }
      } else {
        final locationType = _state.pathLocationType(path);
        bool behindLines = false;
        for (final land in locationType.locations) {
          if (_state.piecesInLocationCount(armyType, land) > 0) {
            behindLines = true;
          }
          final akritai = _state.pieceInLocation(PieceType.akritai, land);
          if (akritai != null) {
            if (behindLines) {
              candidates.add(akritai);
            }
            break;
          }
        }
      }
    }
    return candidates;
  }

  List<Piece> get expelColonistsCandidates {
    final candidates = <Piece>[];
    for (final colonists in PieceType.colonists.pieces) {
      final location = _state.pieceLocation(colonists);
      if (location.isType(LocationType.land)) {
        final path = _state.landPath(location)!;
        final prevLand = _state.pathPrevLocation(path, location);
        if (prevLand == Location.constantinople) {
          candidates.add(colonists);
        }
      }
    }
    return candidates;
  }

  List<Piece> get reopenMonasteryCandidates {
    final candidates = <Piece>[];
    for (final path in [Path.west, Path.north]) {
      final zone = _state.pathZone(path);
      final monastery = _state.pieceInLocation(PieceType.isolatedMonastery, zone);
      if (monastery != null) {
        final armyType = _state.pathArmyType(path);
        if (_state.piecesInLocationCount(armyType, zone) < 5) {
          candidates.add(monastery);
        }
      }
    }
    return candidates;
  }

  List<Piece> attackCandidates(int budget) {
    var candidates = <Piece>[];
    for (final path in Path.values) {
      candidates += _state.pathAttackCandidates(path, budget);
    }
    if (budget >= 1) {
      for (final latins in _state.piecesInLocation(PieceType.latins, Location.constantinople)) {
        candidates.add(latins);
      }
      for (final riots in _state.piecesInLocation(PieceType.riots, Location.constantinople)) {
        candidates.add(riots);
      }
    }
    return candidates;
  }

  // Sequence Helpers

  int rollD6ForEasternPath(Path path) {
    if (_rollD6ForEasternPathState == null) {
      int die = rollD6();
      if (!_state.pathHasUnusedAkritai(path)) {
        return die;
      }
      _rollD6ForEasternPathState = RollD6ForEasternPathState();
      _rollD6ForEasternPathState!.d60 = die;
      setPrompt('Use Akritai to modify die?');
      choiceChoosable(Choice.adjustDieUp, die < 6);
      choiceChoosable(Choice.adjustDieDown, die > 1);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    int die = _rollD6ForEasternPathState!.d60!;
    _rollD6ForEasternPathState = null;
    if (checkChoice(Choice.adjustDieUp)) {
      logLine('> Akritai is used to increase die roll.');
      _state.pathUseAkritai(path);
      die += 1;
    }
    if (checkChoice(Choice.adjustDieDown)) {
      logLine('> Akritai is used to reduce die roll.');
      _state.pathUseAkritai(path);
      die -= 1;
    }
    clearChoices();
    return die;
  }

  int rollD6ForPath(Path path) {
    return rollD6ForEasternPath(path);
  }

  (int, int) rollBasileus2D6ForPath(Path path) {
    if (_rollD6ForEasternPathState == null) {
      final results = roll2D6();
      if (!_state.pathHasUnusedAkritai(path)) {
        return (max(results.$1, results.$2), min(results.$1, results.$2));
      }
      _rollD6ForEasternPathState = RollD6ForEasternPathState();
      _rollD6ForEasternPathState!.d60 = max(results.$1, results.$2);
      _rollD6ForEasternPathState!.d61 = min(results.$1, results.$2);
      setPrompt('Use Akritai to reroll die?');
      choiceChoosable(Choice.yes, true);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    int die0 = _rollD6ForEasternPathState!.d60!;
    int die1 = _rollD6ForEasternPathState!.d61!;
    _rollD6ForEasternPathState = null;
    if (checkChoice(Choice.yes)) {
      logLine('> Akritai is used to reroll die.');
      _state.pathUseAkritai(path);
      die0 = rollD6();
    }
    clearChoices();
    return (die0, die1);
  }

  (int, int) rollBasileus2D6() {
    final results = roll2D6();
    return (max(results.$1, results.$2), min(results.$1, results.$2));
  }

  (bool, int) attackArmy(Piece army, AttackType attackType) {
    final land = _state.pieceLocation(army);
    final path = _state.landPath(land)!;
    final finalLand = _state.pathFinalLand(path);
    final armyType = _state.pathArmyType(path);
    int strength = _state.armyValue(army);
    int die = 0;
    int basileusDelay = 0;
    if (attackType == AttackType.intoBattleSword) {
      final results = rollBasileus2D6ForPath(path);
      die = results.$1;
      basileusDelay = results.$2;
    } else if (attackType == AttackType.intoBattleNoSword) {
      die = rollD6(); // Roll not strictly just for Path
      basileusDelay = die;
    } else {
      die = rollD6ForPath(path);
    }
    bool victory = false;
    if (attackType != AttackType.intoBattleNoSword) {
      int drm = 0;
      final strategikon = _state.pieceLocation(Piece.militaryEvent);
      switch (strategikon) {
      case Location.strategikonExcubitors:
        if (path == Path.south) {
          logLine('> Excubitors: +1');
          drm += 1;
        }
      case Location.strategikonDonatists:
        if (path == Path.south) {
          logLine('> Donatists: -1');
          drm -= 1;
        }
      case Location.strategikonCannons:
        if (path == Path.west) {
          logLine('> Cannons: +1');
          drm += 1;
        }
      case Location.strategikonTheBlackDeath:
        if (path == Path.west) {
          logLine('> The Black Death: -1');
          drm -= 1;
        }
      case Location.strategikonLatinikon:
        if (path == Path.north) {
          logLine('> Latinikon: +1');
          drm += 1;
        }
      case Location.strategikonIconoclasm:
        if (path == Path.north) {
          logLine('> Iconoclasm: -1');
          drm -= 1;
        }
      case Location.strategikonCataphracts:
        if (path == Path.iberia) {
          logLine('> Cataphracts: +1');
          drm += 1;
        }
      case Location.strategikonBagratids:
        if (path == Path.iberia) {
          logLine('> Bagratids: -1');
          drm -= 1;
        }
      case Location.strategikonVarangianGuards:
        if (path == Path.persia) {
          logLine('> Varangian Guards: +1');
          drm += 1;
        }
      case Location.strategikonDisloyalMercenaries:
        if (path == Path.persia) {
          logLine('> Disloyal Mercenaries: -1');
          drm -= 1;
        }
      case Location.strategikonTagmataTroops:
        if (path == Path.syria) {
          logLine('> Tagmata Troops: +1');
          drm += 1;
        }
      case Location.strategikonMightyEgypt:
        if (path == Path.syria) {
          logLine('> Mighty Egypt: -1');
          drm -= 1;
        }
      default:
      }
      if (_state.piecesInLocationCount(PieceType.christians, finalLand) > 0) {
        logLine('> Christians: +1');
        drm += 1;
      }
      if (_state.piecesInLocationCount(PieceType.dynatoi, finalLand) > 0) {
        logLine('> Dynatoi: -1');
        drm -= 1;
      }
      if (army == _state.stolosArmy && _state.pieceLocation(Piece.outpostLazica) == Location.outpostLazicaGreekFireBox) {
        logLine('> Greek Fire: +2');
        drm += 2;
      }
      if (_state.pieceLocation(Piece.bulgarianTheme) == land) {
        logLine('> Bulgarian Theme: +1');
        drm += 1;
      }
      if (_state.pieceLocation(Piece.ravenna) == land) {
        logLine('> Ravenna: +1');
        drm += 1;
      }
      if (_state.pieceLocation(Piece.holyRomanEmpire) == land) {
        logLine('> Holy Roman Empire: -1');
        drm -= 1;
      }
      if (land == Location.zoneNorth) {
        if (_state.pieceLocation(Piece.bulgarianChurchOrthodox) == Location.bulgarianChurchBox) {
          logLine('> Bulgarian Eastern Orthodox Church: +1');
          drm += 1;
        }
        if (_state.pieceLocation(Piece.bulgarianChurchCatholic) == Location.bulgarianChurchBox) {
          logLine('> Bulgarian Roman Catholic Church: -1');
          drm -= 1;
        }
      }
      if (_state.reformed && land == _state.pathFirstLand(path)) {
        if (_state.easternPaths.contains(path) || _state.piecesInLocationCount(armyType, land) >= 5) {
          logLine('> Greek Patriôtes: +1');
          drm += 1;
        }
      }
      if (_state.piecesInLocationCount(PieceType.latins, Location.constantinople) > 0) {
        logLine('> Latins: -1');
        drm -= 1;
      } else if (_state.piecesInLocationCount(PieceType.riots, Location.constantinople) > 0) {
        logLine('> Riots: -1');
        drm -= 1;
      }
      if (attackType == AttackType.magisterMilitum) {
        logLine('> Magister Militum: +1');
        drm += 1;
      }
      int modifiedDie = dieWithDrm(die, drm);
      logLine('> Modified roll: $modifiedDie');
      victory = modifiedDie > strength;
    } else {
      victory = die >= 2 && die <= 5;
    }
    if (victory) {
      logLine('> ${_state.armyName(army)} is defeated.');
      if (_state.stolosArmy == army) {
        logLine('> Stolos is destroyed.');
        _state.setPieceLocation(Piece.stolos, Location.stolosLurkingBox);
        _state.stolosArmy = null;
      }
      if (_state.westernPaths.contains(path)) {
        int armyCount = _state.piecesInLocationCount(armyType, land);
        if (armyCount == 1) {
          if (_state.eventCount(LimitedEvent.tricameron) < 0 && _state.pathBarbarianPiece(path) == Piece.tribeSouthVandal) {
            logLine('> Vandals are defeated at the Battle of Tricameron.');
            logLine('> Moors resist further Byzantine expansion in Africa.');
            _state.pathSetTribe(path, Piece.tribeSouthMoors);
            _state.eventOccurred(LimitedEvent.tricameron);
          }
          if (_state.eventCount(LimitedEvent.kleidion) < 0 && _state.pathBarbarianPiece(path) == Piece.tribeNorthBulgar) {
            logLine('> Bulgars are defeated at the Battle of Kleidίon and reduced to vassalship.');
            _state.setPieceLocation(Piece.bulgarianTheme, Location.zoneNorth);
            _state.eventOccurred(LimitedEvent.kleidion);
          }
        }
        if (armyCount >= 2) {
          armyLeavesZone(army, land);
        }
      } else {
        if (land != finalLand && !_state.landIsMuslim(land)) {
          final nextLand = _state.pathNextLocation(path, land)!;
          logLine('> ${_state.armyName(army)} retreats to ${_state.landName(nextLand)}.');
          _state.setPieceLocation(army, nextLand);
        }
      }
      if (attackType != AttackType.free && attackType != AttackType.shiftForces) {
        adjustNike(1);
      }
    } else {
      logLine('> Attack on ${_state.armyName(army)} is repulsed.');
    }
    if (basileusDelay > 0) {
      _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(basileusDelay));
    }
    return (victory, strength);
  }

  (bool, int) attackLatinsOrRiots(Piece army, AttackType attackType) {
    int strength = 2;
    int die = 0;
    int basileusDelay = 0;
    if (attackType == AttackType.intoBattleSword) {
      final results = rollBasileus2D6();
      die = results.$1;
      basileusDelay = results.$2;
    } else if (attackType == AttackType.intoBattleNoSword) {
      die = rollD6();
      basileusDelay = die;
    } else {
      die = rollD6();
    }
    bool victory = false;
    if (attackType != AttackType.intoBattleNoSword) {
      int drm = 0;
      if (attackType == AttackType.magisterMilitum) {
        logLine('> Magister Militum: +1');
        drm += 1;
      }
      int modifiedDie = dieWithDrm(die, drm);
      logLine('> Modified roll: $modifiedDie');
      victory = modifiedDie > strength;
    } else {
      victory = die >= 2 && die <= 5;
    }
    if (victory) {
      logLine('> ${_state.armyName(army)} are defeated.');
      if (army.isType(PieceType.latins)) {
        if (attackType != AttackType.free && attackType != AttackType.shiftForces) {
          adjustNike(1);
        }
        _state.setPieceLocation(army, Location.trayUnits);
      } else {
        _state.setPieceLocation(_state.pieceFlipSide(army)!, Location.trayUnits);
        removeRandomFaction(2);
      }
    } else {
      logLine('> Attack on ${_state.armyName(army)} is repulsed.');
    }
    if (basileusDelay > 0) {
      _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(basileusDelay));
    }
    return (victory, strength);
  }

  (bool, int) attackPiece(Piece piece, AttackType attackType) {
    if (piece.isType(PieceType.latins) || piece.isType(PieceType.riots)) {
      return attackLatinsOrRiots(piece, attackType);

    } else {
      return attackArmy(piece, attackType);
    }
  }

  void freeAttack(List<Piece> candidateArmies) {
    if (candidateArmies.isEmpty) {
      return;
    }
    _freeAttackState ??= FreeAttackState();
    final localState = _freeAttackState!;
    if (localState.subStep == 0) {
      if (choicesEmpty()) {
        setPrompt('Select Army to Attack');
        for (final army in candidateArmies) {
          pieceChoosable(army);
        }
        throw PlayerChoiceException();
      }
      final army = selectedPiece()!;
      final land = _state.pieceLocation(army);
      logLine('> Attack ${_state.armyName(army)} in ${_state.landName(land)}');
      int cost = _state.armyAttackCost(army) - 1;
      if (cost > 0) {
        spendSolidus(cost);
      }
      localState.target = army;
      clearChoices();
      localState.subStep = 1;
    }
    if (localState.subStep == 1) {
      final army = localState.target!;
      attackArmy(army, AttackType.free);
    }
    _freeAttackState = null;
  }

  void freeAttackOnPath(Path path) {
    freeAttack(_state.pathAttackCandidates(path, _state.solidusAndNike + 1));
  }

  void freeAttackOnAnyPath() {
    var candidates = <Piece>[];
    for (final path in Path.values) {
      candidates += _state.pathAttackCandidates(path, _state.solidusAndNike + 1);
    }
    freeAttack(candidates);
  }

  void freeAttackCrusade() {
    var candidates = <Piece>[];
    for (final path in Path.values) {
      final army = _state.pathBarbarianPiece(path);
      if (_state.barbarianIsMuslim(army)) {
        candidates += _state.pathAttackCandidates(path, _state.solidusAndNike + 1);
      }
    }
    if (candidates.isEmpty) {
      for (final army in [Piece.armyIberiaPersia, Piece.armyPersiaPersia, Piece.armySyriaPersia]) {
        final location = _state.pieceLocation(army);
        if (location.isType(LocationType.land)) {
          final path = _state.landPath(location)!;
          candidates += _state.pathAttackCandidates(path, 1);
        }
      }
    }
    freeAttack(candidates);
  }

  void barbariansAdvanceInTheWest(Path path, AdvanceType advanceType) {
    _barbariansAdvanceState ??= BarbariansAdvanceState();
    final localState = _barbariansAdvanceState!;

    final tribe = _state.pathBarbarianPiece(path);
    final zone = _state.pathZone(path);
    final reserves = _state.pathReserves(path);
    final armyType = _state.pathArmyType(path);
    final army = _state.strongestArmyInLocation(armyType, reserves);
    String? armyName;
    if (army != null) {
      armyName = _state.armyName(army);
    }

    if (localState.subStep == 0) {
      logLine('### ${tribe.name} advance in ${_state.pathGeographicName(path)}');
      localState.subStep = 1;
    }

    if (localState.subStep == 1) {
      if (army == null || advanceType == AdvanceType.automatic) { // Can't be blocked
        localState.subStep = 3;
      }
    }

    while (localState.subStep == 1) { // Prop Units
      if (choicesEmpty()) {
        if (tribe == Piece.tribeWestOttoman) {
          if (_state.pieceLocation(Piece.armyMagyar) == zone) {
            choiceChoosable(Choice.blockMagyarSacrifice, true);
            choiceChoosable(Choice.blockMagyarProp, _state.solidusAndNike >= 1);
          }
          if (_state.pieceLocation(Piece.armySkanderbeg) == zone) {
            choiceChoosable(Choice.blockSkanderbegSacrifice, true);
            choiceChoosable(Choice.blockSkanderbegProp, _state.solidusAndNike >= 1);
          }
        }
        if (choosableChoiceCount == 0) {
          localState.subStep = 2;
          break;
        }
        setPrompt('Choose how to defend.');
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.blockMagyarSacrifice) || checkChoice(Choice.blockSkanderbegSacrifice)) {
        final propUnit = checkChoice(Choice.blockMagyarSacrifice) ? Piece.armyMagyar : Piece.armySkanderbeg;
        logLine('> ${propUnit.name} is Sacrificed.');
        logLine('> Advance of $armyName is halted.');
        _state.setPieceLocation(propUnit, Location.trayUnits);
        clearChoices();
        _barbariansAdvanceState = null;
        return;
      }
      final propUnit = checkChoice(Choice.blockMagyarProp) ? Piece.armyMagyar : Piece.armySkanderbeg;
      logLine('> The Empire supports ${propUnit.name}.');
      spendSolidus(1);
      int die = rollD6();
      if (die <= _state.armyValue(propUnit)) {
        logLine('> ${propUnit.name} repulses the Ottoman advance.');
        _barbariansAdvanceState = null;
        return;
      }
      logLine('> Ottomans defeat ${propUnit.name}.');
      _state.setPieceLocation(propUnit, Location.trayUnits);
      clearChoices();
    }

    while (localState.subStep == 2) { // Tribute / Kastron
      if (choicesEmpty()) {
        if (_state.pieceLocation(Piece.tribute) == zone) {
          pieceChoosable(Piece.tribute);
        }
        if (_state.pieceLocation(Piece.kastron) == zone && !localState.kastronUsed) {
          pieceChoosable(Piece.kastron);
        }
        if (choosablePieceCount == 2) {
          setPrompt('Choose either Tribute or Kastron to Block with first');
          throw PlayerChoiceException();
        }
      }
      var piece = selectedPiece();
      if (piece == null) {
        if (_state.pieceLocation(Piece.tribute) == zone) {
          piece = Piece.tribute;
        } else if (_state.pieceLocation(Piece.kastron) == zone && !localState.kastronUsed) {
          piece = Piece.kastron;
        }
      }
      if (piece == null) {
        clearChoices();
        localState.subStep = 3;
        break;
      }
      if (piece == Piece.tribute) {
        logLine('> Tribute');
        int die = rollD6();
        if (die < 6) {
          logLine('> Advance of $armyName is halted.');
          _barbariansAdvanceState = null;
          return;
        }
        logLine('> Tribute is ineffective.');
        logLine('> $armyName continues its Advance');
        _state.setPieceLocation(Piece.tribute, Location.trayMilitary);
      } else if (piece == Piece.kastron) {
        logLine('> Kastron');
        localState.kastronUsed = true;
        int die = rollD6();
        if (die <= 4) {
          logLine('> Advance of $armyName is halted.');
          _barbariansAdvanceState = null;
          return;
        }
        if (die == 5) {
          logLine('> Kastron is destroyed.');
          _state.setPieceLocation(Piece.kastron, Location.trayMilitary);
        }
        logLine('> $armyName continues its Advance.');
      }
    }

    if (localState.subStep == 3) { // Advance
      if (army != null) {
        armyEntersZone(army, zone);
        _barbariansAdvanceState = null;
        return;
      }
      final siege = _state.pathSiege(path);
      _state.setPieceLocation(siege, zone);
      localState.subStep = 4;
    }

    if (localState.subStep == 4) { // Siege
      final siege = _state.pathSiege(path);
      if (zone == Location.zoneSouth && _state.pieceLocation(Piece.geographyAfrica) == zone) {
        logLine('> Byzantines are forced to abandon Africa.');
        _state.setPieceLocation(Piece.geographyCrete, zone);
        for (int i = 0; i < 4; ++i) {
          final strongestArmy = _state.strongestArmyInLocation(armyType, zone)!;
          armyLeavesZone(strongestArmy, zone);
        }
        _state.setPieceLocation(siege, reserves);
        _barbariansAdvanceState = null;
        return;
      }
      if (zone == Location.zoneWest && _state.pieceLocation(Piece.geographyItaly) == zone) {
        logLine('> Normans wrest control of Italy from the Byzantines.');
        italyFalls();
        for (int i = 0; i < 4; ++i) {
          final strongestArmy = _state.strongestArmyInLocation( armyType, zone)!;
          armyLeavesZone(strongestArmy, zone);
        }
        _state.pathSetTribe(path, Piece.tribeWestNorman);
        _state.setPieceLocation(siege, reserves);
        _barbariansAdvanceState = null;
        return;
      }

      logLine('> ${tribe.name} lays Siege to Constantinople.');
      final rolls = roll2D6();
      int modifiers = 0;
      if (_state.pieceLocation(Piece.factionTheodosianWalls) != Location.constantinople) {
        logLine('> Unfortified: +3');
        modifiers += 3;
      }
      final total = rolls.$3 + modifiers;
      logLine('> Total: $total');
      final factionCount = _state.piecesInLocationCount(PieceType.faction, Location.constantinople);
      if (total > factionCount) {
        logLine('# Constantinople falls!.');
        throw GameOverException(GameResult.defeatConstantinople, 0);
      }
      logLine('> Defeat fizzles.');
      _state.setPieceLocation(siege, reserves);
      localState.subStep = 5;
    }

    while (localState.subStep >= 5 && localState.subStep <= 6) {
      if (localState.subStep == 5) {
        if (choicesEmpty()) {
          setPrompt('Sacrifice Faction for a free Attack');
          bool factionsAvailable = _state.piecesInLocationCount(PieceType.faction, Location.constantinople) > 0;
          choiceChoosable(Choice.yes, factionsAvailable);
          choiceChoosable(Choice.no, localState.fizzleFactionCount > 0 || !factionsAvailable);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.no)) {
          _barbariansAdvanceState = null;
          return;
        }
        removeRandomFaction(4);
        localState.fizzleFactionCount += 1;
        clearChoices();
        localState.subStep = 6;
      }

      if (localState.subStep == 6) {
        freeAttackOnAnyPath();
        localState.subStep = 5;
      }
    }
    _barbariansAdvanceState = null;
  }

  void barbariansAdvanceInTheEast(Path path, AdvanceType advanceType) {
    _barbariansAdvanceState ??= BarbariansAdvanceState();
    final localState = _barbariansAdvanceState!;

    final army = _state.pathBarbarianPiece(path);
    final armyName = _state.armyName(army);
    final armyStrength = _state.armyValue(army);
    final fromLand = _state.pieceLocation(army);
    final toLand = _state.pathPrevLocation(path, fromLand);
    final homeland = _state.pathFinalLand(path);

    if (localState.subStep == 0) {
      logLine('### $armyName advances on ${_state.landName(toLand)}');
      localState.subStep = 1;
    }

    if (localState.subStep == 1) {
      if (toLand == Location.constantinople || advanceType == AdvanceType.automatic) { // Can't be blocked
        localState.subStep = 8;
      }
    }

    if (localState.subStep >= 1 && localState.subStep <= 2) { // Mountains
      if (_state.landIsMountain(toLand)) {
        if (localState.subStep == 1) {
          logLine('> Mountains');
          localState.subStep = 2;
        }
        if (localState.subStep == 2) {
          int die = rollD6ForEasternPath(path);
          if (die > armyStrength) {
            logLine('> Advance of $armyName is halted by Mountains.');
            _barbariansAdvanceState = null;
            return;
          }
          logLine('> $armyName continues its Advance.');
        }
      }
      localState.subStep = 3;
    }

    if (localState.subStep >= 3 && localState.subStep <= 4) { // Hospital
      final hospital = _state.pieceInLocation(PieceType.unusedHospital, toLand);
      if (hospital != null) {
        if (localState.subStep == 3) {
          logLine('> Hospital');
          localState.subStep = 4;
        }
        if (localState.subStep == 4) {
          int die = rollD6ForEasternPath(path);
          _state.setPieceLocation(_state.pieceFlipSide(hospital)!, toLand);
          if (die > armyStrength) {
            logLine('> Advance of $armyName is halted by Hospital.');
            _barbariansAdvanceState = null;
            return;
          }
          logLine('> $armyName continues its Advance.');
        }
      }
      localState.subStep = 5;
    }

    while (localState.subStep >= 5 && localState.subStep <= 7) {
      if (localState.subStep == 5) { // Kastron / Tribute
        if (choicesEmpty()) {
          if (_state.pieceLocation(Piece.tribute) == homeland) {
            pieceChoosable(Piece.tribute);
          }
          if (_state.pieceLocation(Piece.kastron) == toLand && !localState.kastronUsed) {
            pieceChoosable(Piece.kastron);
          }
          if (choosablePieceCount == 2) {
            setPrompt('Choose either Tribute or Kastron to Block with first');
            throw PlayerChoiceException();
          }
        }
        var piece = selectedPiece();
        if (piece == null) {
          if (_state.pieceLocation(Piece.tribute) == homeland) {
            piece = Piece.tribute;
          } else if (_state.pieceLocation(Piece.kastron) == toLand && !localState.kastronUsed) {
            piece = Piece.kastron;
          }
        }
        if (piece == Piece.tribute) {
          logLine('> Tribute');
          localState.subStep = 6;
        } else if (piece == Piece.kastron) {
          logLine('> Kastron');
          localState.subStep = 7;
        } else {
          localState.subStep = 8;
        }
      }

      if (localState.subStep == 6) { // Tribute roll
        int die = rollD6ForEasternPath(path);
        if (die < 6) {
          logLine('> Advance of $armyName is halted.');
          _barbariansAdvanceState = null;
          return;
        }
        logLine('> Tribute is ineffective.');
        logLine('> $armyName continues its Advance');
        _state.setPieceLocation(Piece.tribute, Location.trayMilitary);
        localState.subStep = 5;
      }

      if (localState.subStep == 7) { // Kastron roll
        localState.kastronUsed = true;
        int die = rollD6ForEasternPath(path);
        if (die <= 4) {
          logLine('> Advance of $armyName is halted.');
          _barbariansAdvanceState = null;
          return;
        }
        if (die == 5) {
          logLine('> Kastron is destroyed.');
          _state.setPieceLocation(Piece.kastron, Location.trayMilitary);
        }
        logLine('> $armyName continues its Advance.');
        localState.subStep = 5;
      }
    }

    if (localState.subStep == 8) { // Advance
      if (toLand != Location.constantinople) {
        logLine('> $armyName captures ${_state.landName(toLand)}.');
        _state.setPieceLocation(army, toLand);
        _barbariansAdvanceState = null;
        return;
      }
      final siege = _state.pathSiege(path);
      _state.setPieceLocation(siege, fromLand);
      localState.subStep = 9;
    }

    if (localState.subStep == 9) { // Siege
      final siege = _state.pathSiege(path);
      logLine('> $armyName lays Siege to Constantinople.');
      final rolls = roll2D6();
      int modifiers = 0;
      if (_state.pieceLocation(Piece.factionTheodosianWalls) != Location.constantinople) {
        logLine('> Unfortified: +3');
        modifiers += 3;
      }
      final total = rolls.$3 + modifiers;
      logLine('> Total: $total');
      final factionCount = _state.piecesInLocationCount(PieceType.faction, Location.constantinople);
      if (total > factionCount) {
        logLine('# Constantinople falls!.');
        throw GameOverException(GameResult.defeatConstantinople, 0);
      }
      logLine('> Defeat fizzles.');
      _state.setPieceLocation(siege, Location.traySieges);
      localState.subStep = 10;
    }

    while (localState.subStep >= 10 && localState.subStep <= 11) {
      if (localState.subStep == 10) {
        if (choicesEmpty()) {
          setPrompt('Sacrifice Faction for a free Attack');
          bool factionsAvailable = _state.piecesInLocationCount(PieceType.faction, Location.constantinople) > 0;
          choiceChoosable(Choice.yes, factionsAvailable);
          choiceChoosable(Choice.no, localState.fizzleFactionCount > 0 || !factionsAvailable);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.no)) {
          _barbariansAdvanceState = null;
          return;
        }
        removeRandomFaction(4);
        localState.fizzleFactionCount += 1;
        clearChoices();
        localState.subStep = 11;
      }

      if (localState.subStep == 11) {
        freeAttackOnAnyPath();
        localState.subStep = 10;
      }
    }
    _barbariansAdvanceState = null;
  }

  void barbariansAdvanceOnPath(Path path, AdvanceType advanceType) {
    if (_state.pathIsZone(path)) {
      barbariansAdvanceInTheWest(path, advanceType);
    } else {
      barbariansAdvanceInTheEast(path, advanceType);
    }
  }

  void barbariansRetreatInTheWest(Path path) {
    final zone = _state.pathZone(path);
    final armyType = _state.pathArmyType(path);
    if (_state.piecesInLocationCount(armyType, zone) <= 1) {
      return;
    }
    final army = _state.weakestArmyInLocation(armyType, zone)!;
    armyLeavesZone(army, zone);
  }

  void barbariansRetreatInTheEast(Path path) {
    final army = _state.pathBarbarianPiece(path);
    final fromLand = _state.pieceLocation(army);
    if (fromLand == _state.pathFinalLand(path)) {
      return;
    }
    final toLand = _state.pathNextLocation(path, fromLand)!;
    logLine('> ${_state.armyName(army)} Retreats to ${_state.landName(toLand)}.');
    _state.setPieceLocation(army, toLand);
  }

  void barbariansRetreatOnPath(Path path) {
    if (_state.pathIsZone(path)) {
      barbariansRetreatInTheWest(path);
    } else {
      barbariansRetreatInTheEast(path);
    }
  }

  void riseOfIslam() {
    if (_state.pieceLocation(Piece.caliph) != Location.trayPolitical) {
      return;
    }
    logLine('### Rise of Islam');
    logLine('> The first Caliphate is established.');
    _state.setPieceLocation(Piece.caliph, Location.arabiaBox);
    if (_state.pieceLocation(Piece.colonistsPersia) != Location.flipped) {
      logLine('> ${_state.armyName(Piece.armyIberiaSaracen)} seizes control of ${_state.landName(Location.homelandIberia)}.');
      _state.pathSetArmy(Path.iberia, Piece.armyIberiaSaracen);
      logLine('> ${_state.armyName(Piece.armyPersiaSaracen)} seizes control of ${_state.landName(Location.homelandPersia)}.');
      _state.pathSetArmy(Path.persia, Piece.armyPersiaSaracen);
    }
    if (_state.pieceLocation(Piece.colonistsSyria) != Location.flipped) {
      logLine('> ${_state.armyName(Piece.armySyriaSaracen)} seizes control of ${_state.landName(Location.homelandSyria)}.');
      _state.pathSetArmy(Path.syria, Piece.armySyriaSaracen);
    } else if (_state.pathBarbarianPiece(Path.syria) == Piece.armySyriaPersia) {
      logLine('> ${_state.armyName(Piece.armySyriaNomads)} seizes control of ${_state.landName(Location.homelandSyria)}.');
      _state.pathSetArmy(Path.syria, Piece.armySyriaNomads);
    }
  }

  void crusadesBegin() {
    logLine('### Crusades Begin');
    logLine('> First Crusade takes control of the Holy Land.');
    _state.setPieceLocation(Piece.outpostHolyLand, Location.outpostHolyLandBox);
  }

  // Migration Events

  void migrationEventIslam() {
    // Optional
    if (_state.eventCount(LimitedEvent.warInTheEast) == 2) {
      // riseOfIslam();
      // _state.eventOccurred(LimitedEvent.warInTheEast);
    }
  }

  void migrationEventCarthage() {
    if (_state.pieceLocation(Piece.outpostEgypt) == Location.outpostEgyptBox) {
      return;
    }
    if (!_state.pathBarbarianIsMuslim(Path.syria)) {
      return;
    }
    final tribe = _state.pathBarbarianPiece(Path.south);
    if (tribe == Piece.tribeSouthSaracen) {
      return;
    }
    logLine('### Migration');
    logLine('> Battle for Carthage');
    int die = rollD6();
    int drm = 0;
    int modifier = _state.pathBarbarianControlledLandCount(Path.syria);
    logLine('> Muslim lands on Syrian Path: +$modifier');
    drm += modifier;
    if (_state.pieceLocation(Piece.egyptMuslim) == Location.egyptianReligionBox) {
      logLine('> Egypt Muslim: +2');
      drm += 2;
    }
    int modifiedDie = dieWithDrm(die, drm);
    logLine('> Modified roll: $modifiedDie');
    if (modifiedDie >= 6) {
      logLine('> Saracens conquer North Africa.');
      _state.pathSetTribe(Path.south, Piece.tribeSouthSaracen);
      if (_state.pieceLocation(Piece.outpostSpain) == Location.outpostSpainBox) {
        logLine('> Outpost in Spain is conquered.');
        _state.setPieceLocation(Piece.outpostSpain, Location.discarded);
      }
    } else {
      logLine('> North Africa holds out.');
    }
  }

  void migrationEventEgypt() {
    if (_state.piecesInLocationCount(PieceType.pagan, Location.homelandSyria) == 0) {
      return;
    }
    logLine('### Migration');
    logLine('> Christian empire is established in Egypt.');
    _state.pathSetTribe(Path.south, Piece.tribeSouthEgypt);
    _state.pathSetArmy(Path.syria, Piece.armySyriaEgypt);
    if (_state.pieceLocation(Piece.outpostEgypt) == Location.outpostEgyptBox) {
      logLine('> Outpost in Egypt is conquered.');
      _state.setPieceLocation(Piece.outpostEgypt, Location.discarded);
    }
  }

  void migrationEventBuyids() {
    if (_state.pathBarbarianPiece(Path.persia) == Piece.armyPersiaSaracen) {
      logLine('### Migration');
      logLine('> Buyid Dynasty succeeds the Saracens on the Persian Path.');
      _state.pathSetArmy(Path.persia, Piece.armyPersiaBuyid);
    }
  }

  void migrationEventNormans() {
    if (_state.pieceLocation(Piece.geographyItaly) != Location.zoneWest) {
      return;
    }
    logLine('### Migration');
    logLine('> Normans expand into Italy.');
    int die = rollD6();
    int armyCount = _state.piecesInLocationCount(PieceType.armyWest, Location.zoneWest);
    if (die <= armyCount) {
      logLine('> Italy is lost to the Normans.');
      _state.pathSetTribe(Path.west, Piece.tribeWestNorman);
      while (armyCount > 1) {
        final army = _state.strongestArmyInLocation(PieceType.armyWest, Location.zoneWest)!;
        armyLeavesZone(army, Location.zoneWest);
        armyCount -= 1;
      }
      italyFalls();
    } else {
      logLine('> The Empire resists their advances.');
    }
  }

  void migrationEventMongols() {
    logLine('### Migration');
    logLine('> Mongol Horders invade the Middle East and Europe.');
    _state.pathSetArmy(Path.persia, Piece.armyPersiaMongol);
    _state.pathSetArmy(Path.syria, Piece.armySyriaMongol);
    final kiev = _state.pieceInLocation(PieceType.kiev, Location.kyivBox);
    if (kiev != null) {
      logLine('> Kiev is conquered.');
      _state.setPieceLocation(kiev, Location.discarded);
    }
  }

  // Optional Events

  void optionalEventA() {
  }
  
  void optionalEventB() {
  }

  void optionalEventC() {
  }

  void optionalEventD() {
  }

  void optionalEventE() {
  }

  void optionalEventF() {
  }

  void optionalEventG() {
  }

  void optionalEventH() {
  }

  void optionalEventI() {
  }

  void optionalEventJ() {
  }

  void optionalEventK() {
  }

  void optionalEventL() {
  }

  void optionalEventM() {
  }

  void optionalEventN() {
  }

  void optionalEventO() {
  }

  void optionalEventP() {
  }

  void optionalEventQ() {
  }

  void optionalEventR() {
  }

  void optionalEventS() {
  }

  void optionalEventT() {
  }

  void optionalEventU() {
  }

  void optionalEvent1() {
  }

  void optionalEvent2() {
  }

  void optionalEvent3() {
  }

  void optionalEvent4() {
  }

  void optionalEvent5() {
  }

  void optionalEvent6() {
  }

  void optionalEvent7() {
  }

  void optionalEvent8() {
  }

  void optionalEvent9() {
  }

  // Political Events

  void politicalEventAlexandria() {
    if (_state.pieceLocation(Piece.outpostEgypt) != Location.outpostEgyptBox) {
      return;
    }
    logLine('### Alexandria');
    adjustSolidus(1);
  }

  void politicalEventArmenianRevolt() {
    if (_state.pathBarbarianPiece(Path.iberia) != Piece.armyIberiaSaracen) {
      return;
    }
    logLine('### Armenian Revolt');
    logLine('> ${_state.armyName(Piece.armyIberiaArmenia)} takes control of ${_state.landName(Location.homelandIberia)}.');
    _state.pathSetArmy(Path.iberia, Piece.armyIberiaArmenia);
  }

  void politicalEventBaptismOfRus() {
    if (_state.pieceLocation(Piece.kievPagan) != Location.kyivBox) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Baptism of Rus’');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Spend \$olidus to support Orthodox missionaries');
        for (int i = 0; i <= _state.solidusAndNike; ++i) {
          locationChoosable(_state.omnibusBox(i));
        }
        throw PlayerChoiceException();
      }
      final location = selectedLocation()!;
      final amount = location.index - Location.omnibus0.index;
      int die = rollD6();
      int drm = 0;
      if (_state.basileisAreSaint) {
        logLine('> ${_state.basileisSaintName}: -1');
        drm = -1;
      }
      int modifiedDie = dieWithDrm(die, drm);
      logLine('> Modified Roll: $modifiedDie');
      spendSolidus(amount);
      if (modifiedDie < amount) {
        logLine('> Kyiv converts to Orthodoxy.');
        _state.setPieceLocation(Piece.kievOrthodox, Location.kyivBox);
      } else {
        logLine('> Conversion efforts fail.');
      }
      clearChoices();
    }
  }

  void politicalEventBulgars() {
    if (_subStep == 0) {
      final barbarianPiece = _state.pathBarbarianPiece(Path.north);
      if (![Piece.tribeNorthSlav, Piece.tribeNorthOstrogoths, Piece.tribeNorthHun].contains(barbarianPiece)) {
        return;
      }
      logLine('### Bulgars');
      logLine('> ${Piece.tribeNorthBulgar.name} takes control of ${_state.pathGeographicName(Path.north)}.');
      _state.pathSetTribe(Path.north, Piece.tribeNorthBulgar);
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Spend \$solidus to support Orthodox missionaries');
        for (int i = 0; i <= _state.solidusAndNike; ++i) {
          locationChoosable(_state.omnibusBox(i));
        }
        throw PlayerChoiceException();
      }
      final location = selectedLocation()!;
      final amount = location.index - Location.omnibus0.index;
      int die = rollD6();
      spendSolidus(amount);
      if (die <= amount) {
        logLine('> Bulgars convert to Orthodoxy.');
        _state.setPieceLocation(Piece.bulgarianChurchOrthodox, Location.bulgarianChurchBox);
      } else {
        logLine('> Bulgars convert to Catholicism.');
        _state.setPieceLocation(Piece.bulgarianChurchCatholic, Location.bulgarianChurchBox);
      }
    }
  }

  void politicalEventCarthage() {
    migrationEventCarthage();
  }

  void politicalEventCatholicCharity() {
    if (_state.eventCount(LimitedEvent.eastWestSchism) > 0 && _state.schism > 0) {
      return;
    }
    if (!_state.popeNice) {
      return;
    }
    logLine('### Catholic Charity');
    int die = rollD6();
    adjustSolidus(die);
  }

  void politicalEventCopticRevolt() {
    if (_state.pieceLocation(Piece.egyptFallen) != Location.outpostEgyptBox) {
      return;
    }
    if (_state.pathBarbarianPiece(Path.south) == Piece.tribeSouthEgypt) {
      return;
    }
    if (_state.pathBarbarianPiece(Path.syria) == Piece.armySyriaEgypt) {
      return;
    }
    if (_state.pieceLocation(Piece.armySyriaEgypt) != Location.egyptianReligionBox) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Coptic Revolt');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Spend \$olidus to support Coptic Revolt');
        for (int i = 0; i <= _state.solidusAndNike; ++i) {
          locationChoosable(_state.omnibusBox(i));
        }
        throw PlayerChoiceException();
      }
      final location = selectedLocation()!;
      final amount = location.index - Location.omnibus0.index;
      int die = rollD6();
      spendSolidus(amount);
      if (die <= amount) {
        logLine('> Coptic Revolt succeeds.');
        _state.setPieceLocation(Piece.outpostEgypt, Location.outpostEgyptBox);
      } else {
        logLine('> Coptic Revolt fails.');
      }
    }
  }

  void politicalEventDavid() {
    if (_state.eventCount(LimitedEvent.david) > 0) {
      return;
    }
    logLine('### David');
    logLine('> David the Builder unites the Georgian tribes and grabs Lazica.');
    _state.setPieceLocation(Piece.outpostLazica, Location.discarded);
    _state.eventOccurred(LimitedEvent.david);
  }

  void politicalEventFallOfRome() {
    if (_state.eventCount(LimitedEvent.fallOfRome) > 0) {
      return;
    }
    logLine('### Fall of Rome');
    logLine('> Rome, Spain, and Sicily are susceptible to Byzantine conquest.');
    _state.setPieceLocation(Piece.outpostRome, Location.availableOutpostsBox);
    _state.setPieceLocation(Piece.outpostSpain, Location.availableOutpostsBox);
    _state.setPieceLocation(Piece.outpostSicily, Location.availableOutpostsBox);
    _state.eventOccurred(LimitedEvent.fallOfRome);
  }

  void politicalEventGokturks() {
    logLine('### Göktürks');
    logLine('> Turkish marauders strike from the northeast.');
  }

  void politicalEventGokturksIberia() {
    freeAttackOnPath(Path.iberia);
  }

  void politicalEventGokturksPersia() {
    freeAttackOnPath(Path.persia);
  }

  void politicalEventGreeks() {
    if (!_state.reformed) {
      return;
    }
    logLine('### Greeks');
    int count = 0;
    for (final land in _state.greekLands) {
      if (_state.landIsPlayerControlled(land)) {
        logLine('> ${_state.landName(land)}');
        count += 1;
      }
    }
    if (count == 3) {
      count = 4;
    }
    adjustSolidus(count);
  }

  void politicalEventHenotikon() {
    if (!_state.popeNice) {
      return;
    }
    logLine('### Henotikon');
    final rolls = roll2D6();
    if (rolls.$3 == 12) {
      logLine('> Feuding Church factions are reconciled.');
      _state.setPieceLocation(Piece.schism, Location.cupTurnChit);
    } else {
      logLine('> Church factions continue feuding.');
    }
  }

  void politicalEventKleidion() {
    if (_state.eventCount(LimitedEvent.kleidion) > 0) {
      return;
    }
    logLine('### Kleidíon');
    logLine('> Possibility of establishing Bulgarian Theme.');
    _state.eventPossible(LimitedEvent.kleidion);
  }

  void politicalEventKyiv() {
    final piece = _state.pieceInLocation(PieceType.kiev, Location.kyivBox);
    if (piece == null) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Kyiv');
      if (piece != Piece.kievPagan) {
        logLine('> Trade with the Kyivan Rus’ empire');
        adjustSolidus(1);
        return;
      }
      logLine('> Slavic pirates raid Byzantine territory.');
      _subStep = 1;
    }

    if (_subStep == 1) {
      if (_state.currentTurn % 2 == 1) {
        barbariansAdvanceInTheEast(Path.iberia, AdvanceType.regular);
      } else {
        barbariansAdvanceInTheWest(Path.north, AdvanceType.regular);
      }
    }
  }

  void politicalEventLombards() {
    final piece = _state.pathBarbarianPiece(Path.west);
    if (piece != Piece.tribeWestGoth) {
      return;
    }
    logLine('### Lombards');
    logLine('> Lombards conquer the Goths');
    _state.pathSetTribe(Path.west, Piece.tribeWestLombards);
  }

  void politicalEventMagyarPrincess() {
    if (_subStep == 0) {
      logLine('### Magyar Princess');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Reduce Schism or earn \$olidus');
        choiceChoosable(Choice.reduceSchism, true);
        choiceChoosable(Choice.earnSolidus, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.reduceSchism)) {
        adjustSchism(-1);
      } else {
        adjustSolidus(1);
      }
      clearChoices();
    }
  }

  void politicalEventMagyars() {
    if (_state.pathBarbarianPiece(Path.west) != Piece.tribeWestOttoman) {
      return;
    }
    if (_state.pieceLocation(Piece.armyMagyar) == Location.zoneWest) {
      return;
    }
    logLine('### Magyars');
    logLine('> Hungarian Crusaders wage war on the Ottomans.');
    _state.setPieceLocation(Piece.armyMagyar, Location.zoneWest);
  }

  void politicalEventOstrogoths() {
    if (_state.pathBarbarianPiece(Path.north) != Piece.tribeNorthHun) {
      return;
    }
    logLine('### Ostrogoths');
    logLine('> Ostrogoths take control of ${_state.pathGeographicName(Path.north)}.');
    _state.pathSetTribe(Path.north, Piece.tribeNorthOstrogoths);
  }

  void politicalEventOttomans() {
    if (_state.eventCount(LimitedEvent.ottomans) > 0) {
      return;
    }
    if (!_state.barbarianIsMuslim(_state.pathBarbarianPiece(Path.iberia))) {
      return;
    }
    if (_state.pathBarbarianPiece(Path.persia) != Piece.armyPersiaIlKhanid) {
      return;
    }
    if (_state.pathBarbarianPiece(Path.syria) != Piece.armySyriaIlKhanid) {
      return;
    }
    logLine('### Ottomans');
    int die = rollD6();
    int drm = 0;
    for (final land in _state.mountainLands) {
      if (_state.landIsPlayerControlled(land)) {
        logLine('> ${_state.landName(land)}: -1');
        drm -= 1;
      }
    }
    for (final land in _state.greekLands) {
      final path = _state.landPath(land)!;
      final locationType = _state.pathLocationType(path)      ;
      final playerControlCount = _state.pathPlayerControlledLandCount(path);
      if (land.index - locationType.firstIndex >= playerControlCount) {
        logLine('> ${_state.landName(land)}: +1');
        drm += 1;
      }
    }
    for (final path in _state.westernPaths) {
      final zone = _state.pathZone(path);
      final armyType = _state.pathArmyType(path);
      final count = _state.piecesInLocationCount(armyType, zone);
      if (count <= 1) {
        logLine('> ${_state.pathGeographicName(path)}: -1');
        drm -= 1;
      } else if (count >= 3) {
        logLine('> ${_state.pathGeographicName(path)}: +1');
        drm += 1;
      }
      final modifiedDie = dieWithDrm(die, drm);
      logLine('> Modified Roll: $modifiedDie');
      if (modifiedDie <= 0) {
        logLine('> Ottoman attempt at Empire fails.');
      } else {
        logLine('> Ottoman Empire is established.');
      }
      if (modifiedDie >= 1) {
        logLine('> Ottoman Empire seizes control of ${Path.iberia}.');
        _state.pathSetArmy(Path.iberia, Piece.armyIberiaOttoman);
      }
      if (modifiedDie >= 2) {
        logLine('> Ottoman Empire seizes control of ${Path.persia}.');
        _state.pathSetArmy(Path.persia, Piece.armyPersiaOttoman);
      }
      if (modifiedDie == 3 || modifiedDie >= 5) {
        if (_state.pieceLocation(Piece.geographyBalkans) == Location.zoneWest) {
          logLine('> Ottoman Empire seizes control the Balkans.');
          _state.pathSetTribe(Path.west, Piece.tribeWestOttoman);
        }
      }
      if (modifiedDie >= 4) {
        logLine('> Ottoman Empire seizes control of ${Path.north}.');
        _state.pathSetTribe(Path.north, Piece.tribeNorthOttoman);
        logLine('> Ottoman Empire seizes control of ${Path.syria}.');
        _state.pathSetArmy(Path.syria, Piece.armySyriaOttoman);
      }
    }
    _state.eventOccurred(LimitedEvent.ottomans);
  }

  void politicalOttomansWest() {
    if (_state.pathBarbarianPiece(Path.west) != Piece.tribeWestOttoman) {
      return;
    }
    barbariansAdvanceInTheWest(Path.west, AdvanceType.regular);
  }

  void politicalOttomansNorth() {
    if (_state.pathBarbarianPiece(Path.north) != Piece.tribeNorthOttoman) {
      return;
    }
    barbariansAdvanceInTheWest(Path.north, AdvanceType.regular);
  }

  void politicalOttomansIberia() {
    if (_state.pathBarbarianPiece(Path.iberia) != Piece.armyIberiaOttoman) {
      return;
    }
    barbariansAdvanceInTheEast(Path.iberia, AdvanceType.regular);
  }

  void politicalOttomansPersia() {
    if (_state.pathBarbarianPiece(Path.persia) != Piece.armyPersiaOttoman) {
      return;
    }
    barbariansAdvanceInTheEast(Path.persia, AdvanceType.regular);
  }

  void politicalOttomansSyria() {
    if (_state.pathBarbarianPiece(Path.syria) != Piece.armySyriaOttoman) {
      return;
    }
    barbariansAdvanceInTheEast(Path.syria, AdvanceType.regular);
  }

  void politicalEventPechenegs() {
    logLine('### Pechenegs');
    logLine('> Pagan Turks invade from the North.');
    final church = _state.pieceInLocation(PieceType.bulgarianChurch, Location.bulgarianChurchBox);
    if (church != null) {
      logLine('> Bulgarian Church is suppressed.');
      _state.setPieceLocation(Piece.bulgarianChurchOrthodox, Location.discarded);
    }
  }

  void politicalEventPechenegsAdvance() {
    barbariansAdvanceInTheWest(Path.north, AdvanceType.regular);
  }

  void politicalEventPechenegsAttack() {
    freeAttackOnPath(Path.north);
  }

  void politicalEventPlague() {
    if (_state.pieceLocation(Piece.basileus) != Location.constantinople) {
      return;
    }
    logLine('### Plague');
    logLine('> Basileus deals with the effects of the Plague.');
    _state.setPieceLocation(Piece.plague, Location.constantinople);
  }

  void politicalEventPornocracy() {
    if (!_state.popeNice) {
      return;
    }
    logLine('### Pornocracy');
    logLine('> Pope is Mean.');
    _state.setPieceLocation(Piece.popeMean, Location.popeBox);
  }

  void politicalEventRavenna() {
    if (_state.eventCount(LimitedEvent.ravenna) > 0) {
      return;
    }
    logLine('### Ravenna');
    logLine('> Ravenna is made the capital of Byzantine Italy.');
    _state.setPieceLocation(Piece.ravenna, Location.zoneWest);
    _state.eventOccurred(LimitedEvent.ravenna);
  }
  
  void politicalEventRiots() {
    final latins = _state.piecesInLocation(PieceType.latins, Location.trayUnits);
    if (latins.isEmpty) {
      return;
    }
    logLine('### Riots');
    logLine('> Riots break out in Constantinople.');
    _state.setPieceLocation(_state.pieceFlipSide(latins[0])!, Location.constantinople);
  }

  void politicalEventRotrude() {
    if (_state.eventCount(LimitedEvent.rotrude) > 0) {
      return;
    }
    if (_state.eventCount(LimitedEvent.eastWestSchism) > 0) {
      return;
    }
    final phaseState = _phaseState as PhaseStateSynopsisOfHistories;
    if (_subStep == 0) {
      logLine('### Rotrude');
      int die = rollD6();
      if (die != 6) {
        logLine('> Marriage negotiations unsuccessful.');
        _state.eventOccurred(LimitedEvent.rotrude);
        return;
      }
      logLine('> Basileus marries a Catholic Frankish princess.');
      die = rollD6();
      phaseState.rotrudeDieRoll = die;
      _subStep = 1;
    }

    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Reduce Schism or earn \$olidus');
        choiceChoosable(Choice.reduceSchism, _state.popeNice);
        choiceChoosable(Choice.earnSolidus, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.reduceSchism)) {
        adjustSchism(-phaseState.rotrudeDieRoll!);
      } else {
        adjustSolidus(phaseState.rotrudeDieRoll!);
      }
      phaseState.rotrudeDieRoll = null;
      clearChoices();
    }
  }

  void politicalEventScholarEmperor() {
    if (_state.pieceLocation(Piece.university) != Location.constantinople) {
      return;
    }
    final outposts = <Piece>[];
    for (final outpost in PieceType.outpost.pieces) {
      if (_state.pieceLocation(outpost).isType(LocationType.outpostBox)) {
        outposts.add(outpost);
      }
    }
    if (outposts.isEmpty) {
      return;
    }
    logLine('### Scholar Emperor');
    for (final outpost in outposts) {
      logLine('> ${outpost.name}');
    }
    adjustSolidus(outposts.length);
  }

  void politicalEventSeljuks() {
    if (_state.pathBarbarianPiece(Path.persia) != Piece.armyPersiaBuyid) {
      return;
    }
    logLine('### Seljuks');
    if (_state.barbarianIsMuslim(_state.pathBarbarianPiece(Path.iberia))) {
      logLine('> Seljuks seize control of ${Path.iberia.name}.');
      _state.pathSetArmy(Path.iberia, Piece.armyIberiaSeljuk);
    }
    logLine('> Seljuks seize control of ${Path.persia.name}.');
    _state.pathSetArmy(Path.persia, Piece.armyPersiaSeljuk);
    if (_state.barbarianIsMuslim(_state.pathBarbarianPiece(Path.syria))) {
      logLine('> Seljuks seize control of ${Path.syria.name}.');
      _state.pathSetArmy(Path.syria, Piece.armySyriaSeljuk);
      final syrianColonistsLocation = _state.pieceLocation(Piece.colonistsSyria);
      if (syrianColonistsLocation.isType(LocationType.land)) {
        final armyLand = _state.pieceLocation(Piece.armySyriaSeljuk);
        if (syrianColonistsLocation.index > armyLand.index) {
          logLine('> Muslim Turks settle in ${_state.landName(armyLand)}.');
          _state.setPieceLocation(Piece.colonistsSyria, armyLand);
        }
      }
    }
  }

  void politicalEventSeljuksIberia() {
    if (_state.pathBarbarianPiece(Path.iberia) != Piece.armyIberiaSeljuk) {
      return;
    }
    barbariansAdvanceInTheEast(Path.iberia, AdvanceType.regular);
  }

  void politicalEventSeljuksPersia() {
    if (_state.pathBarbarianPiece(Path.persia) != Piece.armyPersiaSeljuk) {
      return;
    }
    barbariansAdvanceInTheEast(Path.persia, AdvanceType.regular);
  }

  void politicalEventSeljuksSyria() {
    if (_state.pathBarbarianPiece(Path.syria) != Piece.armySyriaSeljuk) {
      return;
    }
    barbariansAdvanceInTheEast(Path.syria, AdvanceType.regular);
  }

  void politicalEventSeljuksColonists() {
    final phaseState = _phaseState as PhaseStateSynopsisOfHistories;
    if (_state.pathBarbarianPiece(Path.persia) != Piece.armyPersiaSeljuk) {
      return;
    }
    {
      final persianColonistsLocation = _state.pieceLocation(Piece.colonistsPersia);
      if (persianColonistsLocation.isType(LocationType.land)) {
        final armyLand = _state.pieceLocation(Piece.armyPersiaSeljuk);
        if (persianColonistsLocation.index > armyLand.index) {
          logLine('> Muslim Turks settle in ${_state.landName(armyLand)}.');
          _state.setPieceLocation(Piece.colonistsPersia, armyLand);
        }
      }
    }
    if (_state.pathBarbarianPiece(Path.syria) == Piece.armySyriaSeljuk) {
      final syrianColonistsLocation = _state.pieceLocation(Piece.colonistsSyria);
      if (syrianColonistsLocation.isType(LocationType.land)) {
        final armyLand = _state.pieceLocation(Piece.armySyriaSeljuk);
        if (syrianColonistsLocation.index > armyLand.index) {
          logLine('> Muslim Turks settle in ${_state.landName(armyLand)}.');
          _state.setPieceLocation(Piece.colonistsSyria, armyLand);
        }
      }
    }
    if (_state.pieceLocation(Piece.crusade) == Location.trayPolitical) {
      phaseState.seljuksTriggerCrusades = true;
      crusadesBegin();
      _state.setPieceLocation(Piece.crusade, Location.crusadesABox);
    }
  }

  void politicalEventSeljuksCrusadesAttack() {
    final phaseState = _phaseState as PhaseStateSynopsisOfHistories;
    if (!phaseState.seljuksTriggerCrusades) {
      return;
    }
    freeAttackCrusade();
  }

  void politicalEventSerbs() {
    if (_state.pieceLocation(Piece.tribeWestSerbs) == Location.westTribeBox) {
      return;
    }
    logLine('### Serbs');
    logLine('> Serbs invade the Balkans.');
    _state.pathSetTribe(Path.west, Piece.tribeWestSerbs);
    int armyCount = _state.piecesInLocationCount(PieceType.armyWest, Location.zoneWest);
    while (armyCount > 1) {
      final army = _state.weakestArmyInLocation(PieceType.armyWestStrong, Location.zoneWest)!;
      armyLeavesZone(army, Location.zoneWest);
      armyCount -= 1;
    }
    if (_state.pieceLocation(Piece.geographyBalkans) != Location.zoneWest) {
      italyFalls();
    }
  }

  void politicalEventSicily() {
    if (_state.pieceLocation(Piece.outpostSicily) == Location.discarded) {
      return;
    }
    logLine('### Sicily');
    logLine('> Sicily falls to the Barbarians.');
    _state.setPieceLocation(Piece.outpostSicily, Location.discarded);
  }

  void politicalEventSilkwormHeist() {
    if (_state.eventCount(LimitedEvent.silkwormHeist) != 0) {
      return;
    }
    logLine('### Silkworm Heist');
    int die = rollD6();
    adjustSolidus(die);
    _state.eventOccurred(LimitedEvent.silkwormHeist);
  }

  void politicalEventSkanderbeg() {
    if (_state.eventCount(LimitedEvent.skanderbeg) != 0) {
      return;
    }
    if (_state.pathBarbarianPiece(Path.west) != Piece.tribeWestOttoman) {
      return;
    }
    logLine('### Skanderbeg');
    logLine('> Revolting Albanians ambush the Ottomans.');
    _state.setPieceLocation(Piece.armySkanderbeg, Location.zoneWest);
    _state.eventOccurred(LimitedEvent.skanderbeg);
  }

  void politicalEventSlavs() {
    final piece = _state.pathBarbarianPiece(Path.north);
    if (![Piece.tribeNorthHun, Piece.tribeNorthOstrogoths].contains(piece)) {
      return;
    }
    logLine('### Slavs');
    logLine('> Slavic tribes begin to settle in the Balkans.');
    _state.pathSetTribe(Path.north, Piece.tribeNorthSlav);
  }

  void politicalEventStolos() {
    if (_subStep == 0) {
      if (_state.pieceLocation(Piece.stolos) != Location.stolosLurkingBox) {
        return;
      }
      logLine('### Stolos');
      final path = randPath(Path.values)!;
      logLine('> Stolos appears on ${path.name}.');
      if (_state.easternPaths.contains(path)) {
        final army = _state.pathBarbarianPiece(path);
        _state.stolosArmy = army;
        return;
      }
      final zone = _state.pathZone(path);
      _state.setPieceLocation(Piece.stolos, zone);
      _subStep = 1;
    }
    if (_subStep == 1) {
      final zone = _state.pieceLocation(Piece.stolos);
      final path = _state.landPath(zone)!;
      final armyType = _state.pathArmyType(path);
      if (choicesEmpty()) {
        setPrompt('Select Army for Stolos to accompany');
        for (final army in _state.piecesInLocation(armyType, zone)) {
          pieceChoosable(army);
        }
        throw PlayerChoiceException();
      }
      final army = selectedPiece()!;
      _state.stolosArmy = army;
      clearChoices();
    }
  }

  void politicalEventTricameron() {
    if (_state.pathBarbarianPiece(Path.south) != Piece.tribeSouthVandal) {
      return;
    }
    logLine('### Tricameron');
    logLine('> Possibility of defeating the Vandals.');
    _state.eventPossible(LimitedEvent.tricameron);
  }

  void politicalEventUprisingOfAsenAndPeter() {
    if (_state.pathBarbarianPiece(Path.north) == Piece.tribeNorthBulgarians) {
      return;
    }
    logLine('### Uprising of Asen & Peter');
    logLine('> Christian Empire of Bulgaria reasserts its independence.');
    if (_state.pieceLocation(Piece.bulgarianTheme) == Location.zoneNorth) {
      _state.setPieceLocation(Piece.bulgarianTheme, Location.discarded);
    }
    _state.pathSetTribe(Path.north, Piece.tribeNorthBulgarians);
  }

  void politicalEventVenice() {
    if (_state.pathBarbarianPiece(Path.south) == Piece.tribeSouthVenice) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Venice');
      if (_state.pieceLocation(Piece.geographyCrete) == Location.zoneSouth) {
        logLine('> Venice takes control of Crete.');
        _state.pathSetTribe(Path.south, Piece.tribeSouthVenice);
        return;
      }
      int die = rollD6();
      if (die > _state.piecesInLocationCount(PieceType.armySouth, Location.zoneSouth)) {
        logLine('> Venice takes control of Africa.');
        _state.pathSetTribe(Path.south, Piece.tribeSouthVenice);
      } else {
        logLine('> Venetian attempt to control of Africa is repulsed.');
      }
    }
  }

  void politicalEventWhiteHuns() {
    logLine('### White Huns');
    logLine('> White Huns invade your enemies from the northeast.');
  }

  void politicalEventWhiteHunsIberia() {
    freeAttackOnPath(Path.iberia);
  }

  void politicalEventWhiteHunsPersia() {
    freeAttackOnPath(Path.persia);
  }

  // Sequence of Play

  void turnBegin() {
	  logLine('# ${_state.turnName(_state.currentTurn)}');
  }

  void chitDrawPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Chit Draw Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    logLine('## Chit Draw Phase');
  }

  void chitDrawPhaseChitDraw() {
    logLine('### Chit Draw');
    var turnChit = randPiece(_state.piecesInLocation(PieceType.all, Location.cupTurnChit))!;
    if (turnChit == Piece.schism) {
      logLine('> Religious factions reappear.');
      _state.setPieceLocation(Piece.schism, Location.omnibus0);
      turnChit = randPiece(_state.piecesInLocation(PieceType.all, Location.cupTurnChit))!;
    }
    logLine('> Turn Chit ${turnChit.index - PieceType.turnChit.firstIndex + 1}');
    _state.setPieceLocation(turnChit, _state.currentTurnChronographiaBox);
  }

  void turnStartPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Turn Start Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    logLine('## Turn Start Phase');
    _phaseState = PhaseStateTurnStart();
  }

  void turnStartPhaseChronographiaDeployments() {
    final pieces = _state.piecesInLocation(PieceType.all, _state.currentTurnChronographiaBox);
    if (pieces.length <= 1) {
      return;
    }
    logLine('### Deployments');
    for (final piece in pieces) {
      if (piece == Piece.basileusJustinian) {
        logLine('> ${piece.name} succeeds as Basileus.');
        removeOldBasileus();
        _state.setPieceLocation(Piece.basileusJustinian, Location.basileusBox);
      }
      if (piece == Piece.dynastyPurpleJustinian) {
        logLine('> ${piece.name} is founded.');
        final oldDynasty = _state.pieceInLocation(PieceType.dynastyPurple, Location.dynastyBox)!;
        _state.setPieceLocation(_state.pieceFlipSide(oldDynasty)!, Location.trayDynasties);
        _state.setPieceLocation(piece, Location.dynastyBox);
      }
      if (piece == Piece.basileus) {
        logLine('> Basileus is available for missions.');
        _state.setPieceLocation(piece, Location.constantinople);
      }
      if (piece == Piece.stolos) {
        _state.setPieceLocation(piece, Location.stolosLurkingBox);
      }
      if (piece.isType(PieceType.dynatoi)) {
        _state.setPieceLocation(_state.pieceFlipSide(piece)!, Location.trayUnits);
      }
    }
  }

  void turnStartPhaseEphesusAndChalcedon() {
    if (_state.currentTurn != 0) {
      return;
    }
    logLine('### Ecumenical Councils of Ephesus and Chalcedon');
    int die = rollD6();
    adjustSchism(die);
    die = rollD6();
    adjustSchism(-die);
  }

  void turnStartPhaseMagisterMilitum() {
    final magisterMilitumName = _state.turnMagisterMilitumName(_state.currentTurn);
    if (magisterMilitumName == null) {
      return;
    }
    logLine('### Magister Militum');
    logLine('> $magisterMilitumName takes command of the armed forces.');
    _state.setPieceLocation(Piece.magisterMilitum, Location.constantinople);
  }

  void turnStartPhaseMigrationEvent() {
    final migrationEventHandlers = {
      5: migrationEventIslam,
      7: migrationEventCarthage,
      13: migrationEventEgypt,
      14: migrationEventBuyids,
      16: migrationEventNormans,
      20: migrationEventMongols,
    };
    final handler = migrationEventHandlers[_state.currentTurn];
    if (handler == null) {
      return;
    }
    handler();
  }

  void turnStartRiseOfIslamAdvanceArmy(Piece army, Path path) {
    if (_state.currentTurn != 5) {
      return;
    }
    if (_state.eventCount(LimitedEvent.warInTheEast) != 3) {
      return;
    }
    // Optional
    return;
  }

  void turnStartPhaseRiseOfIslamAdvancePersia() {
    turnStartRiseOfIslamAdvanceArmy(Piece.armyPersiaSaracen, Path.persia);
  }

  void turnStartPhaseRiseOfIslamAdvanceSyria() {
    turnStartRiseOfIslamAdvanceArmy(Piece.armySyriaSaracen, Path.syria);
  }

  void turnStartPhaseRiseOfIslamAdvanceIberia() {
    turnStartRiseOfIslamAdvanceArmy(Piece.armyIberiaSaracen, Path.iberia);
  }

  void turnStartPhaseRiseOfIslamComplete() {
    if (_state.currentTurn != 5) {
      return;
    }
    if (_state.eventCount(LimitedEvent.warInTheEast) != 3) {
      return;
    }
    _state.eventOccurred(LimitedEvent.warInTheEast);
  }

  void turnStartPhaseEcumenicalCouncilEvent() {
    if (!_state.currentTurnHasEcumenicalCouncil) {
      return;
    }
    logLine('### Ecumenical Council');
    int die = rollD6();
    int drm = 0;
    if (_state.popeMean) {
      logLine('> Mean Pope: +1');
      drm += 1;
    }
    int modifiedDie = dieWithDrm(die, drm);
    logLine('> Modified roll: $modifiedDie');
    adjustSchism(modifiedDie);
  }

  void turnStartPhaseEastWestSchismEvent() {
    if (_state.currentTurnChit != Piece.turnChit16) {
      return;
    }
    logLine('### East‐West Schism');
    logLine('> Catholic and Orthodox Churches split permanently.');
    _state.setPieceLocation(Piece.popeNice, Location.discarded);
    _state.eventOccurred(LimitedEvent.eastWestSchism);
  }

  void turnStartPhaseReformsEvent() {
    const reformsTurnChits = [
      Piece.turnChit1,
      Piece.turnChit4,
      Piece.turnChit7,
      Piece.turnChit10,
      Piece.turnChit13,
      Piece.turnChit16,
      Piece.turnChit19,
      Piece.turnChit22,
      Piece.turnChit25,
      Piece.turnChit28,
    ];
    if (!reformsTurnChits.contains(_state.currentTurnChit)) {
      return;
    }
    if (_state.reformed) {
      return;
    }

    if (_subStep == 0) {
      logLine('### Reforms');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Support Reforms?');
        choiceChoosable(Choice.yes, _state.solidusAndNike >= 1);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        logLine('> Reforms enacted.');
        spendSolidus(1);
        int die = rollD6();
        adjustReforms(die);
      } else {
        logLine('> Reforms not enacted.');
      }
      clearChoices();
    }
  }

  void turnStartBarbariansAdvanceOnRandomPath() {
    final phaseState = _phaseState as PhaseStateTurnStart;
    if (_subStep == 0) {
       phaseState.randomBarbarianPath = randPath(Path.values)!;
       _subStep = 1;
    }
    if (_subStep == 1) {
      barbariansAdvanceOnPath(phaseState.randomBarbarianPath!, AdvanceType.regular);
      phaseState.randomBarbarianPath = null;
    }
  }

  void turnStartPhaseRandomBarbariansEvent() {
    if (_state.currentTurnChit != Piece.turnChit28) {
      return;
    }
    turnStartBarbariansAdvanceOnRandomPath();
  }

  void optionalRandomBarbariansEvent() {

  }

  void turnStartPhaseOptionalRandomBarbariansEvent0() {
    const optionalRandomBarbariansEventTurns = [
      Piece.turnChit2,
      Piece.turnChit12,
      Piece.turnChit13,
      Piece.turnChit14,
      Piece.turnChit21,
      Piece.turnChit25,
    ];
    if (!optionalRandomBarbariansEventTurns.contains(_state.currentTurnChit)) {
      return;
    }
    optionalRandomBarbariansEvent();
  }

  void turnStartPhaseOptionalRandomBarbariansEvent1() {
    const optionalRandomBarbariansEventTurns = [
      Piece.turnChit13,
      Piece.turnChit21,
    ];
    if (!optionalRandomBarbariansEventTurns.contains(_state.currentTurnChit)) {
      return;
    }
    optionalRandomBarbariansEvent();
  }

  void turnStartPhaseOptionalEvent() {
    final optionalEventHandlers = {
      Piece.turnChit1: optionalEventA,
      Piece.turnChit3: optionalEventC,
      Piece.turnChit6: optionalEventD,
      Piece.turnChit7: optionalEventE,
      Piece.turnChit8: optionalEventF,
      Piece.turnChit9: optionalEventG,
      Piece.turnChit10: optionalEventH,
      Piece.turnChit11: optionalEventI,
      Piece.turnChit13: optionalEventK,
      Piece.turnChit14: optionalEventL,
      Piece.turnChit18: optionalEventM,
      Piece.turnChit20: optionalEventN,
      Piece.turnChit22: optionalEventP,
      Piece.turnChit26: optionalEventQ,
    };
    final handler = optionalEventHandlers[_state.currentTurnChit];
    if (handler == null) {
      return;
    }
    handler();
  }

  void turnStartPhaseCrusadesBegin() {
    const crusadeTurnChits = [
      Piece.turnChit2,
      Piece.turnChit6,
      Piece.turnChit8,
      Piece.turnChit9,
      Piece.turnChit12,
      Piece.turnChit14,
      Piece.turnChit19,
      Piece.turnChit22,
      Piece.turnChit25,
      Piece.turnChit27,
    ];
    if (_state.pieceLocation(Piece.crusade) != Location.trayPolitical) {
      return;
    }
    int count = 0;
    for (final turnChit in crusadeTurnChits) {
      if (_state.pieceLocation(turnChit).isType(LocationType.chronographia)) {
        count += 1;
      }
    }
    if (_state.firstTurn == 14) {
      count += 5;
    }
    if (count < 6) {
      return;
    }
    crusadesBegin();
  }

  void turnStartPhaseCrusadesContinue() {
    final location = _state.pieceLocation(Piece.crusade);
    if (location == Location.trayPolitical && _state.pieceLocation(Piece.outpostHolyLand) == Location.outpostHolyLandBox) {
      _state.setPieceLocation(Piece.crusade, Location.crusadesABox);
      return;
    }
    if (!location.isType(LocationType.crusadesBox)) {
      return;
    }
    if (location == Location.crusadesDBox) {
      logLine('### End of The Crusades');
      _state.setPieceLocation(Piece.crusade, Location.discarded);
      return;
    }
    final newLocation = Location.values[location.index + 1];
    _state.setPieceLocation(Piece.crusade, newLocation);
    logLine('### ${newLocation.name}');
    int die = rollD6();
    if (die >= 5 && _state.pieceLocation(Piece.outpostEgypt) != Location.outpostEgyptBox) {
      logLine('> Landing in Egypt!');
      logLine('> Crusade takes control of Egypt.');
      _state.setPieceLocation(Piece.outpostEgypt, Location.outpostEgyptBox);
      return;
    }
    if (die >= 3 && die < 6 && _state.eventCount(LimitedEvent.constantinopleBetrayed) == 0) {
      logLine('> Constantinople Betrayed!');
      int latinsCount = min(_state.schism, 6);
      if (latinsCount > 0) {
        logLine('> $latinsCount Latins occupy ${_state.landName(Location.constantinople)}.');
        final availableLatins = _state.piecesInLocation(PieceType.latins, Location.trayUnits);
        for (int i = 0; i < latinsCount && i < availableLatins.length; ++i) {
          _state.setPieceLocation(availableLatins[i], Location.constantinople);
        }
      }
      final riots = _state.piecesInLocation(PieceType.riots, Location.constantinople);
      if (riots.isNotEmpty) {
        logLine('> ${riots.length - latinsCount} Riots transform into Latins.');
      }
      for (final riot in riots) {
        _state.setPieceLocation(_state.pieceFlipSide(riot)!, Location.constantinople);
      }
      if (_state.pieceLocation(Piece.university) == Location.constantinople) {
        logLine('> ${Piece.university.name} closes.');
        _state.setPieceLocation(Piece.university, Location.trayPatriarchs);
      }
      _state.eventOccurred(LimitedEvent.constantinopleBetrayed);
      return;
    }
    logLine('> Desultory warfare.');
  }

  void turnStartPhaseFirstCrusadeAttack() {
    if (_state.pieceLocation(Piece.crusade) != Location.crusadesABox) {
      return;
    }
    freeAttackCrusade();
  }

  void turnStartPhaseEnd() {
    _phaseState = null;
  }

  void leadershipPhaseBegin() {
    if (_state.currentTurn == _state.firstTurn) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Leadership Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    logLine('## Leadership Phase');
    _phaseState = PhaseStateLeadership();
  }

  void leadershipPhaseNewDynasty() {
    if (_state.currentTurn == _state.firstTurn || _state.currentTurn == 2) {
      return;
    }

    if (_subStep == 0) {
      logLine('### Dynasty');

      Piece? oldDynasty = _state.pieceInLocation(PieceType.dynasty, Location.dynastyBox)!;

      if (_state.dynastyIsAnarchy(oldDynasty) || _state.piecesInLocationCount(PieceType.riots, Location.constantinople) > 0) {
        if (!_state.dynastyIsAnarchy(oldDynasty)) {
          logLine('> ${oldDynasty.name} is overthrown.');
        }
        _state.setPieceLocation(oldDynasty, Location.discarded);
        oldDynasty = null;
      }

      const civilWarTurnChits = [
        Piece.turnChit5,
        Piece.turnChit23,
        Piece.turnChit24,
      ];
      bool civilWar = civilWarTurnChits.contains(_state.currentTurnChit);
      if (_state.currentTurn == 0 || _state.currentTurn == 2) {
        civilWar = false;
      }

      if (!civilWar) {
        if (oldDynasty == null) {
          final newDynasty = drawDynasty();
          if (_state.dynastyIsAnarchy(newDynasty)) {
            logLine('> Byzantine Empire descends into Anarchy.');
          } else {
            logLine('> ${newDynasty.name} seizes power.');
          }
          _state.setPieceLocation(newDynasty, Location.dynastyBox);
        } else {
          int die = rollD6();
          int drm = 0;
          if (_state.nike >= 3) {
            logLine('> Nike: +1');
            drm += 1;
          }
          int modifiedDie = dieWithDrm(die, drm);
          logLine('> Modified roll: $modifiedDie');
          if (modifiedDie >= _state.dynastyDie(oldDynasty)) {
            logLine('> ${oldDynasty.name} remains in power.');
          } else {
            logLine('> ${oldDynasty.name} is overthrown.');
            _state.setPieceLocation(oldDynasty, Location.discarded);
            final newDynasty = drawDynasty();
            if (_state.dynastyIsAnarchy(newDynasty)) {
              logLine('> Byzantine Empire descends into Anarchy.');
            } else {
              logLine('> ${newDynasty.name} seizes power.');
            }
            _state.setPieceLocation(newDynasty, Location.dynastyBox);
          }
        }
        _subStep = 3;
      } else {
        _subStep = 1;
      }
    }

    if (_subStep >= 1 && _subStep <= 2) { // civil war
      var candidate1 = _state.pieceInLocation(PieceType.dynasty, Location.dynastyBox);
      bool incumbent = true;
      if (candidate1 == null) {
        incumbent = false;
        candidate1 = _state.pieceInLocation(PieceType.dynasty, Location.dynastyBoxCivilWar1);
        if (candidate1 == null) {
          candidate1 = drawDynasty();
          _state.setPieceLocation(candidate1, Location.dynastyBoxCivilWar1);
        }
      }
      var candidate0 = _state.pieceInLocation(PieceType.dynasty, Location.dynastyBoxCivilWar0);
      if (candidate0 == null) {
        candidate0 = drawDynasty();
        _state.setPieceLocation(candidate0, Location.dynastyBoxCivilWar0);
      }
      if (_subStep == 1) { // civil war prologue
        logLine('> Civil War breaks out.');
        _subStep = 2;
      }

      while (_subStep == 2) {
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          continue;
        }
        if (selectedLocation() == null) {
          setPrompt('Choose amount to spend in support of Dynasty in Civil War');
          for (int i = 0; i <= _state.solidusAndNike; ++i) {
            locationChoosable(_state.omnibusBox(i));
          }
          throw PlayerChoiceException();
        }
        final solidi = selectedLocation()!.index - Location.omnibus0.index;
        Piece? supportedCandidate;
        if (solidi > 0) {
          if (selectedPiece() == null) {
            setPrompt('Select Dynasty to support in Civil War');
            pieceChoosable(candidate0);
            pieceChoosable(candidate1);
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
          supportedCandidate = selectedPiece();
        }
        if (solidi > 0) {
          logLine('> Back ${supportedCandidate!.name}');
          spendSolidus(solidi);
        }

        logLine('> ${candidate1.name}');
        int die1 = rollD6();
        int drm1 = 0;
        if (_state.pieceLocation(candidate1) == Location.dynastyBox && _state.nike >= 3) {
          logLine('> Nike: +1');
          drm1 += 1;
        }
        if (supportedCandidate == candidate1) {
          logLine('> Support: +$solidi');
          drm1 += solidi;
        }
        int modifiedDie1 = dieWithDrm(die1, drm1);
        logLine('> Modified roll: $modifiedDie1');

        logLine('> ${candidate0.name}');
        int die0 = rollD6();
        int drm0 = 0;
        if (supportedCandidate == candidate0) {
          logLine('> Support: +$solidi');
          drm0 += solidi;
        }
        int modifiedDie0 = dieWithDrm(die0, drm0);
        logLine('> Modified roll: $modifiedDie0');

        String tieBreakString = '';

        if (modifiedDie0 == modifiedDie1) {
          if (incumbent) {
            modifiedDie1 += 1;
          } else {
            tieBreakString = 'narrowly ';
            int flip = randInt(2);
            if (flip == 0) {
              modifiedDie0 += 1;
            } else {
              modifiedDie1 += 1;
            }
          }
        }

        if (modifiedDie1 > modifiedDie0) {
          logLine('> ${candidate1.name} ${tieBreakString}wins the Civil War.');
          _state.setPieceLocation(candidate0, Location.cupDynasty);
          if (!incumbent) {
            _state.setPieceLocation(candidate1, Location.dynastyBox);
          }
        } else {
          logLine('> ${candidate0.name} ${tieBreakString}wins the Civil War.');
          if (incumbent) {
            _state.setPieceLocation(candidate1, Location.discarded);
          } else {
            _state.setPieceLocation(candidate1, Location.cupDynasty);
          }
          _state.setPieceLocation(candidate0, Location.dynastyBox);
        }
        clearChoices();
        _subStep = 3;
      }
    }

    if (_subStep == 3) { // riots
      final riots = _state.piecesInLocation(PieceType.riots, Location.constantinople);
      if (riots.isNotEmpty) {
        logLine('> Riots are quelled.');
        for (final riot in riots) {
          _state.setPieceLocation(_state.pieceFlipSide(riot)!, Location.trayUnits);
        }
        removeRandomFaction(4);
      }
    }
  }

  void leadershipPhaseNewBasileus() {
    if (_state.currentTurn == _state.firstTurn || _state.currentTurn == 2) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Basileus');
      if (_state.currentTurn != 2) {
        removeOldBasileus();
      }
      final newBasileus = drawBasileus();
      _state.setPieceLocation(newBasileus, Location.basileusBox);
      if (!_state.basileusIsFemale(newBasileus)) {
        logLine('> ${newBasileus.name} becomes Basileus.');
        return;
      }
      logLine('> ${newBasileus.name} becomes Empress.');
      final husband = drawBasileus();
      _state.setPieceLocation(husband, Location.basileusHusbandBox);
      final alternateHusband = _state.basileusAlternate(husband);
      _state.setPieceLocation(alternateHusband, Location.basileusAlternateBox);
      _subStep = 1;
    }
    if (_subStep == 1) {
      final wife = _state.pieceInLocation(PieceType.basileus, Location.basileusBox)!;
      var husband = _state.pieceInLocation(PieceType.basileus, Location.basileusHusbandBox)!;
      final alternateHusband = _state.pieceInLocation(PieceType.basileusAlternate, Location.basileusAlternateBox)!;
      if (choicesEmpty()) {
        setPrompt('Spend 1 \$olidus for ${wife.name} to marry ${alternateHusband.name} rather than ${husband.name}?');
        choiceChoosable(Choice.yes, _state.solidusAndNike >= 1);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        spendSolidus(1);
        logLine('> ${wife.name} schemes to block marriage to ${husband.name}.');
        husband = _state.basileusPrimary(alternateHusband);
        _state.setPieceLocation(husband, Location.basileusHusbandBox);
      }
      logLine('> ${husband.name} marries ${wife.name} and becomes Basileus.');
      _state.setPieceLocation(alternateHusband, Location.discarded);
      clearChoices();
    }
  }

  void leadershipPhaseMutilateBasileus() {
    if (_state.currentTurn == _state.firstTurn) {
      return;
    }
    var basileus = _state.pieceInLocation(PieceType.basileus, Location.basileusBox)!;
    if (_state.basileusIsFemale(basileus)) {
      return;
    }
    if (_subStep == 0) {
      if (choicesEmpty()) {
        setPrompt('Mutilate ${basileus.name}?');
        choiceChoosable(Choice.yes, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.no)) {
        clearChoices();
        return;
      }
      logLine('> ${basileus.name} is mutilated.');
      int amount = _state.popeMean ? 4 : 3;
      adjustSchism(amount);
      removeOldBasileus();
      basileus = drawBasileus();
      _state.setPieceLocation(basileus, Location.basileusBox);
      final alternate = _state.basileusAlternate(basileus);
      _state.setPieceLocation(alternate, Location.basileusAlternateBox);
      clearChoices();
      _subStep = 1;
    }
    if (_subStep == 1) {
      var alternate = _state.pieceInLocation(PieceType.basileusAlternate, Location.basileusAlternateBox)!;
      if (choicesEmpty()) {
        setPrompt('Choose ${alternate.name} as Basileus instead of ${basileus.name}?');
        choiceChoosable(Choice.yes, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        alternate = basileus;
        basileus = _state.basileusPrimary(alternate);
        _state.setPieceLocation(basileus, Location.basileusBox);
      }
      _state.setPieceLocation(alternate, Location.discarded);
      logLine('> ${basileus.name} becomes Basileus');

      if (!_state.basileusIsFemale(basileus)) {
        final location = _state.pieceLocation(Piece.basileus);
        if (location.isType(LocationType.chronographia)) {
          logLine('> Basileus returns to Constantinople.');
          _state.setPieceLocation(Piece.basileus, Location.constantinople);
        }
      }
      clearChoices();
    }
  }

  void leadershipPhaseNewPatriarch() {
    if (_state.currentTurn == _state.firstTurn) {
      return;
    }
    logLine('### Patriarch');
    final oldPatriarch = _state.pieceInLocation(PieceType.patriarch, Location.patriarchBox)!;
    if (_state.currentTurn == 1) {
      _state.setPieceLocation(Piece.university, Location.trayPatriarchs);
    } else if (_state.currentTurn < 11) {
      _state.setPieceLocation(oldPatriarch, Location.discarded);
    } else {
      _state.setPieceLocation(oldPatriarch, Location.cupPatriarch);
    }
    if (_state.currentTurn == 10) {
      _state.setupPieceType(PieceType.patriarchNonSchism, Location.cupPatriarch);
    }
    final newPatriarch = randPiece(_state.piecesInLocation(PieceType.patriarch, Location.cupPatriarch))!;
    logLine('> ${newPatriarch.name} becomes Patriarch.');
    _state.setPieceLocation(newPatriarch, Location.patriarchBox);
    if (newPatriarch.isType(PieceType.patriarchSchism)) {
      adjustSchism(1);
    }
  }

  void leadershipPhaseNewPope() {
    if (_state.currentTurn == _state.firstTurn) {
      return;
    }
    if (_state.piecesInLocationCount(PieceType.pope, Location.popeBox) == 0) {
      return;
    }
    logLine('### Pope');
    int die = rollD6();
    Piece? pope;
    if (die <= 4) {
      logLine('> New Pope is Nice.');
      pope = Piece.popeNice;
    } else {
      logLine('> New Pope is Mean.');
      pope = Piece.popeMean;
    }
    _state.setPieceLocation(pope, Location.popeBox);
  }

  void leadershipPhasePayTribute() {
    if (_state.currentTurn == _state.firstTurn) {
      return;
    }
    if (_state.solidusAndNike < 2) {
      return;
    }
    if (choicesEmpty()) {
      setPrompt('Select Path to Pay Tribute to');
      for (final path in Path.values) {
        locationChoosable(_state.pathFinalLand(path));
      }
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.next)) {
      clearChoices();
      return;
    }
    final land = selectedLocation()!;
    final path = _state.landPath(land)!;
    logLine('### Tribute');
    final barbarian = _state.pathBarbarianPiece(path);
    logLine('> Tribute is paid to ${barbarian.name}.');
    spendSolidus(2);
    _state.setPieceLocation(Piece.tribute, land);
    clearChoices();
  }

  void leadershipPhaseBuildKastron() {
    if (_state.currentTurn == _state.firstTurn) {
      return;
    }
    if (!_state.reformed) {
      return;
    }
    if (_state.pieceLocation(Piece.kastron) != Location.trayMilitary) {
      return;
    }
    if (_state.solidusAndNike < 1) {
      return;
    }
    if (choicesEmpty()) {
      setPrompt('Select Zone or Theme to build Kastron in.');
      choiceChoosable(Choice.next, true);
      for (final zone in LocationType.zone.locations) {
        locationChoosable(zone);
      }
      for (final path in _state.easternPaths) {
        int controlledLandCount = _state.pathPlayerControlledLandCount(path);
        for (int sequence = 0; sequence < controlledLandCount; ++sequence) {
          final theme = _state.pathSequenceLocation(path, sequence);
          locationChoosable(theme);
        }
      }
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.next)) {
      clearChoices();
      return;
    }
    logLine('### Build Kastron');
    final land = selectedLocation()!;
    spendSolidus(1);
    logLine('> Kastron is built in ${_state.landName(land)}.');
    _state.setPieceLocation(Piece.kastron, land);
  }

  void leadershipSocialEvent() {
    final phaseState = _phaseState as PhaseStateLeadership;
    if (_subStep == 0) {
      if (_state.piecesInLocationCount(PieceType.christians, Location.trayUnits) == 0) {
        return;
      }
      logLine('### Social Event');
      final path = randPath(Path.values)!;
      phaseState.socialEventPath = path;
      logLine('> Social Event affects the ${path.name}.');
      _subStep = 1;
    }
    final path = phaseState.socialEventPath!;
    final land = _state.pathFinalLand(path);
    if (_subStep == 1) {
      int winningMargin = _state.pathWinningMargin(path);
      int winningAdjustment = 0;
      if (winningMargin == 0) {
        int die = rollD6ForPath(path);
        winningAdjustment = die <= 3 ? -1 : 1;
      }
      final trayChristians = _state.piecesInLocation(PieceType.christians, Location.trayUnits);
      var social = trayChristians[0];
      var otherSocial = _state.pieceInLocation(PieceType.social, land);
      if (winningMargin + winningAdjustment > 0) {
        social = _state.pieceFlipSide(social)!;
      }
      if (otherSocial == null) {
        logLine('> ${social.name} is placed on the ${path.name}.');
        _state.setPieceLocation(social, land);
        phaseState.socialEventPath = null;
        return;
      }
      if (social.isType(PieceType.christians) != otherSocial.isType(PieceType.christians)) {
        logLine('> ${otherSocial.name} is removed from the ${path.name}');
        if (otherSocial.isType(PieceType.dynatoi)) {
          otherSocial = _state.pieceFlipSide(otherSocial)!;
        }
        _state.setPieceLocation(otherSocial, Location.trayUnits);
        phaseState.socialEventPath = null;
        return;
      }
      final barbarianPiece = _state.pathBarbarianPiece(path);
      if (social.isType(PieceType.christians)) {
        logLine('> ${barbarianPiece.name} Retreats.');
        _subStep = 2;
      } else {
        logLine('> ${barbarianPiece.name} Advances.');
        _subStep = 3;
      }
    }
    if (_subStep == 2) {
      barbariansRetreatOnPath(path);
    }
    if (_subStep == 3) {
      barbariansAdvanceOnPath(path, AdvanceType.regular);
    }
    phaseState.socialEventPath = null;
  }

  void leadershipPhaseTurnChitSocialEvent() {
    if (_state.currentTurn == _state.firstTurn) {
      return;
    }
    const socialTurnChits = [
      Piece.turnChit2,
      Piece.turnChit3,
      Piece.turnChit5,
      Piece.turnChit8,
      Piece.turnChit9,
      Piece.turnChit12,
      Piece.turnChit17,
      Piece.turnChit18,
      Piece.turnChit20,
      Piece.turnChit27,
      Piece.turnChit28,
    ];
    final turnChit = _state.currentTurnChit;
    if (socialTurnChits.contains(turnChit)) {
      leadershipSocialEvent();
    }
  }

  void leadershipPhaseDynastySocialEvent() {
    if (_state.currentTurn == _state.firstTurn) {
      return;
    }
    final dynasty = _state.pieceInLocation(PieceType.dynasty, Location.dynastyBox)!;
    if (_state.dynastyHasSocialEvent(dynasty)) {
      leadershipSocialEvent();
    }
  }

  void leadershipPhaseBasileusSocialEvent() {
    if (_state.currentTurn == _state.firstTurn) {
      return;
    }
    final basileis = _state.currentBasileis;
    for (final basileus in basileis) {
      if (_state.basileusHasSocialEvent(basileus)) {
        leadershipSocialEvent();
      }
    }
  }

  void leadershipPhaseResetNike() {
    if (_state.currentTurn == _state.firstTurn) {
      return;
    }
    _state.resetNike();
    _phaseState = null;
  }

  void taxationPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Taxation Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    logLine('## Taxation Phase');
  }

  void taxationPhaseIncome() {
    logLine('### Taxation');
    final dynasty = _state.pieceInLocation(PieceType.dynasty, Location.dynastyBox)!;
    int dynastyIncome = _state.dynastySolidus(dynasty);
    if (dynastyIncome > 0) {
      logLine('> ${dynasty.name}: $dynastyIncome');
    }
    int basileisIncome = 0;
    final basileis = _state.currentBasileis;
    for (final basileus in basileis) {
      final basileusIncome = _state.basileusSolidus(basileus);
      if (basileusIncome > 0) {
        logLine('> ${_state.basileusName(basileus)}: $basileusIncome');
        basileisIncome += basileusIncome;
      }
    }
    final patriarch = _state.pieceInLocation(PieceType.patriarch, Location.patriarchBox)!;
    int patriarchIncome = _state.patriarchSolidus(patriarch);
    if (patriarchIncome > 0) {
      logLine('> ${_state.patriarchName(patriarch)}: $patriarchIncome');
    }
    int totalIncome = dynastyIncome + basileisIncome + patriarchIncome;
    logLine('> Total: $totalIncome');
    adjustSolidus(totalIncome);
  }

  void taxationPhaseKhan() {
    var location = _state.rulerLocation;
    if (!location.isType(LocationType.land) && location != _state.currentTurnChronographiaBox) {
      return;
    }
    logLine('### Khan');
    final path = randPath(Path.values)!;
    final barbarian = _state.pathBarbarianPiece(path);
    final ruler = _state.barbarianUsesRex(barbarian) ? Piece.rulerRex : Piece.rulerKhan;
    final land = _state.pathFinalLand(path);
    logLine('> ${ruler.name} is placed on the ${path.name}.');
    _state.setPieceLocation(ruler, land);
  }

  void taxationPhaseCaliph() {
    var location = _state.pieceLocation(Piece.caliph);
    if (location == Location.flipped) {
      location = _state.pieceLocation(Piece.fitna);
    }
    if (!location.isType(LocationType.land) && location != _state.currentTurnChronographiaBox && location != Location.arabiaBox) {
      return;
    }
    logLine('### Caliph');
    final path = randPath(Path.values)!;
    final barbarian = _state.pathBarbarianPiece(path);
    if (_state.barbarianIsMuslim(barbarian)) {
      final land = _state.pathFinalLand(path);
      logLine('> ${Piece.caliph.name} is placed on the ${path.name}.');
      _state.setPieceLocation(Piece.caliph, land);
    } else {
      logLine('> Fitna disrupts Islam.');
      _state.setPieceLocation(Piece.fitna, Location.arabiaBox);
      logLine('> Struggling Caliph pays Tribute.');
      adjustSolidus(1);
    }
  }

  void synopsisOfHistoriesPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Synopsis of Histories Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    logLine('## Synopsis of Histories Phase');
  }

  void synopsisOfHistoriesPhaseRoll() {
    logLine('### Random Events Roll');
    int die = rollD6();
    int total = die + _state.currentTurn + 1;
    logLine('> Result: $total');
    _phaseState = PhaseStateSynopsisOfHistories(total, total);
  }

  void synopsisOfHistoriesPhaseMilitaryEvent() {
    const militaryEvents = [
      Location.strategikonDonatists,
      Location.strategikonExcubitors,
      Location.strategikonWarInTheEast,
      Location.strategikonIconoclasm,
      Location.strategikonTagmataTroops,
      Location.strategikonBagratids,
      Location.strategikonCataphracts,
      Location.strategikonVarangianGuards,
      Location.strategikonDisloyalMercenaries,
      Location.strategikonMightyEgypt,
      Location.strategikonLatinikon,
      Location.strategikonTheBlackDeath,
      Location.strategikonJihad,
      Location.strategikonCannons,
      Location.strategikonCannons,
    ];
    final phaseState = _phaseState! as PhaseStateSynopsisOfHistories;
    int total = phaseState.militaryTotal;
    if (total < 5) {
      return;
    }
    int index = (total - 5) ~/ 2;
    final location = militaryEvents[index];
    logLine('### Military Event');
    logLine('> ${location.name}');
    _state.setPieceLocation(Piece.militaryEvent, location);
  }

  void synopsisOfHistoriesPhaseWarInTheEast2() {
    if (_state.pieceLocation(Piece.militaryEvent) != Location.strategikonWarInTheEast) {
      return;
    }
    if (_state.eventCount(LimitedEvent.warInTheEast) != 2) {
      return;
    }
    riseOfIslam();
    _state.eventOccurred(LimitedEvent.warInTheEast);
  }

  void synopsisOfHistoriesRiseOfIslamAdvanceArmy(Piece army, Path path) {
    if (_state.pieceLocation(Piece.militaryEvent) != Location.strategikonWarInTheEast) {
      return;
    }
    if (_state.eventCount(LimitedEvent.warInTheEast) != 3) {
      return;
    }
    final rubbleLocation = _state.pieceLocation(Piece.empiresInRubble);
    if (rubbleLocation == Location.discarded) {
      return;
    }
    if (_state.pathBarbarianPiece(path) == army) {
      barbariansAdvanceInTheEast(path, AdvanceType.regular);
    }
    if (rubbleLocation != Location.omnibus1) {
      _state.setPieceLocation(Piece.empiresInRubble, Location.values[rubbleLocation.index - 1]);
    } else {
      _state.setPieceLocation(Piece.empiresInRubble, Location.discarded);
    }
  }

  void synopsisOfHistoriesPhaseRiseOfIslamAdvancePersia() {
    synopsisOfHistoriesRiseOfIslamAdvanceArmy(Piece.armyPersiaSaracen, Path.persia);
  }

  void synopsisOfHistoriesPhaseRiseOfIslamAdvanceSyria() {
    synopsisOfHistoriesRiseOfIslamAdvanceArmy(Piece.armySyriaSaracen, Path.syria);
  }

  void synopsisOfHistoriesPhaseRiseOfIslamAdvanceIberia() {
    synopsisOfHistoriesRiseOfIslamAdvanceArmy(Piece.armyIberiaSaracen, Path.iberia);
  }

  void synopsisOfHistoriesPhaseRiseOfIslamComplete() {
    if (_state.pieceLocation(Piece.militaryEvent) != Location.strategikonWarInTheEast) {
      return;
    }
    if (_state.eventCount(LimitedEvent.warInTheEast) != 3) {
      return;
    }
    _state.eventOccurred(LimitedEvent.warInTheEast);
  }

  void synopsisOfHistoriesPhaseWarInTheEast1() {
    final phaseState = _phaseState as PhaseStateSynopsisOfHistories;
    if (_state.pieceLocation(Piece.militaryEvent) != Location.strategikonWarInTheEast) {
      return;
    }
    if (_state.eventCount(LimitedEvent.warInTheEast) != 0) {
      return;
    }

    if (_subStep == 0) {
      logLine('### Persia attacks Byzantium');
      logLine('> Persia takes control of the Syrian Front');
      final oldArmy = _state.pathBarbarianPiece(Path.syria);
      if (oldArmy == Piece.armySyriaNomads) {
        _state.pathSetArmy(Path.syria, Piece.armySyriaPersia);
      }
      _subStep = 1;
    }

    if (_subStep == 1) {
      if (choicesEmpty()) {
        final rolls = roll2D6();
        phaseState.warInTheEast1Dice = rolls.$3;
        setPrompt('Spend 4 \$olidus to Counterattack?');
        choiceChoosable(Choice.yes, _state.solidusAndNike >= 4);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        logLine('> Byzantium counterattacks the Persians.');
        spendSolidus(4);
        final rolls = roll2D6();
        phaseState.warInTheEast1Dice = rolls.$3;
      }
      clearChoices();
      _subStep = 2;
    }

    if (_subStep == 2) {
      int modifiers = 0;
      for (final land in _state.mountainLands) {
        final path = _state.landPath(land)!;
        final controlledCount = _state.pathPlayerControlledLandCount(path);
        final locationType = _state.pathLocationType(path);
        if (controlledCount > land.index - locationType.firstIndex) {
          logLine('> ${_state.landName(land)}: +1');
          modifiers += 1;
        }
      }
      final total = phaseState.warInTheEast1Dice! + modifiers;
      logLine('> Total: $total');
      int rubble = 0;
      int persianAdvance = 0;
      int persianRetreat = 0;
      switch (total) {
      case 2:
      case 3:
      case 4:
        rubble = 1;
        persianAdvance = 3;
      case 5:
        rubble = 3;
        persianAdvance = 3;
      case 6:
        rubble = 5;
        persianAdvance = 2;
      case 7:
        rubble = 7;
        persianAdvance = 2;
      case 8:
        rubble = 8;
        persianAdvance = 1;
      case 9:
        rubble = 9;
      case 10:
        rubble = 8;
        persianRetreat = 1;
      case 11:
        rubble = 7;
        persianRetreat = 2;
      case 12:
        rubble = 5;
        persianRetreat = 2;
      case 13:
        rubble = 3;
        persianRetreat = 3;
      case 14:
      case 15:
        rubble = 1;
        persianRetreat = 3;
      }
      phaseState.warInTheEast1PersianAdvanceCount = persianAdvance;
      phaseState.warInTheEast1PersianRetreatCount = persianRetreat;
      if (persianAdvance == 3) {
        logLine('> Persian Victory');
      } else if (persianRetreat == 3) {
        logLine('> Byzantine Victory');
      } else {
        logLine('> No Victory');
      }
      logLine('> Rubble Level: $rubble');
      _state.setPieceLocation(Piece.empiresInRubble, _state.omnibusBox(rubble));
      _state.eventOccurred(LimitedEvent.warInTheEast);
    }
  }

  void synopsisOfHistoriesPhaseWarInTheEast1Path(Path path, int i) {
    if (_state.eventCount(LimitedEvent.warInTheEast) != 1) {
      return;
    }
    final phaseState = _phaseState as PhaseStateSynopsisOfHistories;
    if (phaseState.warInTheEast1PersianAdvanceCount == null) {
      return;
    }
    final army = _state.pathBarbarianPiece(path);
    if (![Piece.armyIberiaPersia, Piece.armyPersiaPersia, Piece.armySyriaPersia].contains(army)) {
      return;
    }
    if (phaseState.warInTheEast1PersianAdvanceCount! > i) {
      barbariansAdvanceInTheEast(path, AdvanceType.regular);
    } else if (phaseState.warInTheEast1PersianRetreatCount! > i) {
      barbariansRetreatInTheEast(path);
    }
  }

  void synopsisOfHistoriesPhaseWarInTheEast1Iberia0() {
    synopsisOfHistoriesPhaseWarInTheEast1Path(Path.iberia, 0);
  }

  void synopsisOfHistoriesPhaseWarInTheEast1Iberia1() {
    synopsisOfHistoriesPhaseWarInTheEast1Path(Path.iberia, 1);
  }

  void synopsisOfHistoriesPhaseWarInTheEast1Iberia2() {
    synopsisOfHistoriesPhaseWarInTheEast1Path(Path.iberia, 2);
  }

  void synopsisOfHistoriesPhaseWarInTheEast1Persia0() {
    synopsisOfHistoriesPhaseWarInTheEast1Path(Path.persia, 0);
  }

  void synopsisOfHistoriesPhaseWarInTheEast1Persia1() {
    synopsisOfHistoriesPhaseWarInTheEast1Path(Path.persia, 1);
  }

  void synopsisOfHistoriesPhaseWarInTheEast1Persia2() {
    synopsisOfHistoriesPhaseWarInTheEast1Path(Path.persia, 2);
  }

  void synopsisOfHistoriesPhaseWarInTheEast1Syria0() {
    synopsisOfHistoriesPhaseWarInTheEast1Path(Path.syria, 0);
  }

  void synopsisOfHistoriesPhaseWarInTheEast1Syria1() {
    synopsisOfHistoriesPhaseWarInTheEast1Path(Path.syria, 1);
  }

  void synopsisOfHistoriesPhaseWarInTheEast1Syria2() {
    synopsisOfHistoriesPhaseWarInTheEast1Path(Path.syria, 2);
  }

  void synopsisOfHistoriesPhaseWarInTheEast1Colonists() {
    final phaseState = _phaseState as PhaseStateSynopsisOfHistories;
    if (phaseState.warInTheEast1PersianAdvanceCount == null) {
      return;
    }
    if (phaseState.warInTheEast1PersianAdvanceCount == 3) {
      _state.setPieceLocation(Piece.paganPersia, Location.homelandPersia);
    } else {
      logLine('> Muslims colonize ${_state.landName(Location.homelandPersia)}.');
      _state.setPieceLocation(Piece.colonistsPersia, Location.homelandPersia);
    }
    if (phaseState.warInTheEast1PersianRetreatCount == 3) {
      _state.setPieceLocation(Piece.paganSyria, Location.homelandSyria);
    } else {
      _state.setPieceLocation(Piece.colonistsSyria, Location.homelandSyria);
      logLine('> Muslims colonize ${_state.landName(Location.homelandSyria)}.');
    }
    _state.eventOccurred(LimitedEvent.warInTheEast);
  }

  void synopsisOfHistoriesPhaseJihadPath(Path path) {
    if (_state.pieceLocation(Piece.militaryEvent) != Location.strategikonJihad) {
      return;
    }
    final barbarianPiece = _state.pathBarbarianPiece(path);
    if (!_state.barbarianIsMuslim(barbarianPiece)) {
      return;
    }
    barbariansAdvanceOnPath(path, AdvanceType.regular);
  }

  void synopsisOfHistoriesPhaseJihadSouth() {
    synopsisOfHistoriesPhaseJihadPath(Path.south);
  }

  void synopsisOfHistoriesPhaseJihadWest() {
    synopsisOfHistoriesPhaseJihadPath(Path.west);
  }

  void synopsisOfHistoriesPhaseJihadNorth() {
    synopsisOfHistoriesPhaseJihadPath(Path.north);
  }

  void synopsisOfHistoriesPhaseJihadIberia() {
    synopsisOfHistoriesPhaseJihadPath(Path.iberia);
  }

  void synopsisOfHistoriesPhaseJihadPersia() {
    synopsisOfHistoriesPhaseJihadPath(Path.persia);
  }

  void synopsisOfHistoriesPhaseJihadSyria() {
    synopsisOfHistoriesPhaseJihadPath(Path.syria);
  }

  void synopsisOfHistoriesPhasePoliticalEvent(int index) {
    final politicalEventHandlers = [
      [politicalEventAlexandria, politicalEventStolos, optionalEventB],
      [politicalEventFallOfRome, politicalEventGreeks, politicalEventOstrogoths,
       politicalEventWhiteHuns, politicalEventWhiteHunsIberia, politicalEventWhiteHunsPersia,
       optionalEventJ],
      [politicalEventAlexandria, politicalEventFallOfRome, politicalEventHenotikon, politicalEventOstrogoths, politicalEventPlague, politicalEventRavenna, politicalEventTricameron, optionalEventS],
      [politicalEventFallOfRome, politicalEventLombards, politicalEventRavenna, politicalEventRiots, politicalEventSilkwormHeist, politicalEventSlavs, politicalEventStolos, optionalEventT],
      [politicalEventGreeks,
       politicalEventGokturks, politicalEventGokturksIberia, politicalEventGokturksPersia,
       politicalEventLombards, politicalEventPlague, politicalEventRavenna, politicalEventTricameron, politicalEventSlavs, politicalEventStolos, optionalEventU],
      [politicalEventArmenianRevolt, politicalEventCopticRevolt, politicalEventLombards, politicalEventPlague, politicalEventRiots, politicalEventSlavs, optionalEvent1],
      [politicalEventAlexandria, politicalEventArmenianRevolt, politicalEventBulgars, politicalEventKyiv, politicalEventPlague, politicalEventRotrude, politicalEventStolos, optionalEvent2],
      [politicalEventBaptismOfRus, politicalEventBulgars, politicalEventCarthage, politicalEventCopticRevolt, politicalEventScholarEmperor, politicalEventStolos, optionalEvent3],
      [politicalEventAlexandria, politicalEventBaptismOfRus, politicalEventBulgars, politicalEventGreeks, politicalEventKleidion, politicalEventKyiv, politicalEventPornocracy,
       politicalEventSeljuks, politicalEventSeljuksIberia, politicalEventSeljuksPersia, politicalEventSeljuksSyria, politicalEventSeljuksColonists, politicalEventSeljuksCrusadesAttack, politicalEventSeljuksCrusadesAttack,
       politicalEventSicily],
      [politicalEventCarthage, politicalEventKleidion, politicalEventRiots, politicalEventScholarEmperor,
       politicalEventSeljuks, politicalEventSeljuksIberia, politicalEventSeljuksPersia, politicalEventSeljuksSyria, politicalEventSeljuksColonists, politicalEventSeljuksCrusadesAttack, politicalEventSeljuksCrusadesAttack,
       politicalEventStolos, optionalEvent4],
      [politicalEventDavid, politicalEventMagyarPrincess,
       politicalEventPechenegs, politicalEventPechenegsAdvance, politicalEventPechenegsAttack,
       politicalEventUprisingOfAsenAndPeter, politicalEventVenice, optionalEvent5],
      [politicalEventGreeks, politicalEventKyiv, politicalEventRiots, politicalEventScholarEmperor, politicalEventSerbs, politicalEventStolos, politicalEventUprisingOfAsenAndPeter, politicalEventVenice],
      [politicalEventAlexandria, politicalEventCarthage, politicalEventDavid, politicalEventMagyarPrincess, politicalEventStolos, optionalEvent6],
      [politicalEventCatholicCharity, politicalEventKyiv,
       politicalEventOttomans, politicalOttomansWest, politicalOttomansNorth, politicalOttomansIberia, politicalOttomansPersia, politicalOttomansSyria,
       politicalEventScholarEmperor, politicalEventSerbs, politicalEventSicily, optionalEvent7],
      [politicalEventCarthage,
       politicalEventOttomans, politicalOttomansWest, politicalOttomansNorth, politicalOttomansIberia, politicalOttomansPersia, politicalOttomansSyria,
        politicalEventMagyars, politicalEventRiots, politicalEventSkanderbeg, politicalEventStolos, optionalEvent8],
      [politicalEventAlexandria, politicalEventCatholicCharity, politicalEventGreeks, politicalEventKyiv, politicalEventMagyars, politicalEventScholarEmperor, politicalEventSerbs, optionalEvent9],
      [politicalEventAlexandria, politicalEventCatholicCharity, politicalEventGreeks, politicalEventKyiv, politicalEventMagyars, politicalEventScholarEmperor, politicalEventSerbs, optionalEvent9],
    ];
    final phaseState = _phaseState as PhaseStateSynopsisOfHistories;
    final row = (phaseState.politicalTotal - 1) ~/ 2;
    final eventHandlers = politicalEventHandlers[row];
    if (index < eventHandlers.length) {
      eventHandlers[index]();
    }
  }

  void synopsisOfHistoriesPhasePoliticalEvent0() {
    synopsisOfHistoriesPhasePoliticalEvent(0);
  }

  void synopsisOfHistoriesPhasePoliticalEvent1() {
    synopsisOfHistoriesPhasePoliticalEvent(1);
  }

  void synopsisOfHistoriesPhasePoliticalEvent2() {
    synopsisOfHistoriesPhasePoliticalEvent(2);
  }

  void synopsisOfHistoriesPhasePoliticalEvent3() {
    synopsisOfHistoriesPhasePoliticalEvent(3);
  }

  void synopsisOfHistoriesPhasePoliticalEvent4() {
    synopsisOfHistoriesPhasePoliticalEvent(4);
  }

  void synopsisOfHistoriesPhasePoliticalEvent5() {
    synopsisOfHistoriesPhasePoliticalEvent(5);
  }

  void synopsisOfHistoriesPhasePoliticalEvent6() {
    synopsisOfHistoriesPhasePoliticalEvent(6);
  }

  void synopsisOfHistoriesPhasePoliticalEvent7() {
    synopsisOfHistoriesPhasePoliticalEvent(7);
  }

  void synopsisOfHistoriesPhasePoliticalEvent8() {
    synopsisOfHistoriesPhasePoliticalEvent(8);
  }

  void synopsisOfHistoriesPhasePoliticalEvent9() {
    synopsisOfHistoriesPhasePoliticalEvent(9);
  }

  void synopsisOfHistoriesPhasePoliticalEvent10() {
    synopsisOfHistoriesPhasePoliticalEvent(10);
  }

  void synopsisOfHistoriesPhasePoliticalEvent11() {
    synopsisOfHistoriesPhasePoliticalEvent(11);
  }

  void synopsisOfHistoriesPhasePoliticalEvent12() {
    synopsisOfHistoriesPhasePoliticalEvent(12);
  }

  void synopsisOfHistoriesPhasePoliticalEvent13() {
    synopsisOfHistoriesPhasePoliticalEvent(13);
  }

  void synopsisOfHistoriesPhasePoliticalEvent14() {
    synopsisOfHistoriesPhasePoliticalEvent(14);
  }

  void synopsisOfHistoriesPhaseEnd() {
    _phaseState = null;
  }

  void barbariansPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Barbarians Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    logLine('## Barbarians Phase');
    _phaseState = PhaseStateBarbarians();
  }

  void barbariansPhaseDetermineAdvanceCounts() {
    const turnChitAdvancePaths = {
      Piece.turnChit1: [Path.south, Path.west, Path.north, Path.iberia, Path.persia, Path.syria],
      Piece.turnChit2: [Path.south, Path.west],
      Piece.turnChit3: [Path.iberia, Path.syria],
      Piece.turnChit4: [Path.south, Path.west, Path.iberia, Path.persia],
      Piece.turnChit5: [Path.north, Path.iberia, Path.persia, Path.syria],
      Piece.turnChit6: [Path.north, Path.iberia, Path.persia, Path.syria],
      Piece.turnChit7: [Path.south, Path.north, Path.iberia],
      Piece.turnChit8: [Path.persia, Path.syria],
      Piece.turnChit9: [Path.south, Path.west],
      Piece.turnChit10: [Path.north, Path.persia, Path.syria],
      Piece.turnChit11: [Path.north, Path.iberia, Path.persia, Path.syria],
      Piece.turnChit12: [Path.north],
      Piece.turnChit13: [Path.north],
      Piece.turnChit14: [Path.persia, Path.syria],
      Piece.turnChit15: [Path.south, Path.north, Path.syria],
      Piece.turnChit16: [Path.south, Path.west, Path.north, Path.iberia, Path.syria],
      Piece.turnChit17: [Path.south, Path.west, Path.north, Path.persia],
      Piece.turnChit18: [Path.south, Path.persia, Path.syria],
      Piece.turnChit19: [Path.south, Path.west, Path.north, Path.persia],
      Piece.turnChit20: [Path.south, Path.west, Path.north],
      Piece.turnChit21: [Path.north, Path.iberia],
      Piece.turnChit22: [Path.iberia],
      Piece.turnChit23: [Path.west, Path.north, Path.persia],
      Piece.turnChit24: [Path.west, Path.north, Path.persia, Path.syria],
      Piece.turnChit25: [Path.persia, Path.syria],
      Piece.turnChit26: [Path.north, Path.iberia, Path.persia, Path.syria],
      Piece.turnChit27: [Path.south, Path.persia, Path.syria],
      Piece.turnChit28: [],
    };
    final phaseState = _phaseState as PhaseStateBarbarians;
    for (final path in turnChitAdvancePaths[_state.currentTurnChit!]!) {
      phaseState.pathAdvanceCounts[path.index] = 1;
    }
    final rulerLocation = _state.rulerLocation;
    if (rulerLocation.isType(LocationType.land)) {
      final rulerPath = _state.landPath(rulerLocation)!;
      if (phaseState.pathAdvanceCounts[rulerPath.index] >= 1) {
        phaseState.pathAdvanceCounts[rulerPath.index] += 1;
      }
    }
    final caliphLocation = _state.pieceLocation(Piece.caliph);
    if (caliphLocation.isType(LocationType.land)) {
      final caliphPath = _state.landPath(caliphLocation)!;
      final barbarian = _state.pathBarbarianPiece(caliphPath);
      if (_state.barbarianIsMuslim(barbarian)) {
        if (phaseState.pathAdvanceCounts[caliphPath.index] >= 1) {
          phaseState.pathAdvanceCounts[caliphPath.index] += 1;

        }
      }
    }
  }

  void barbariansPhaseAdvancePath(Path path, int i) {
    final phaseState = _phaseState as PhaseStateBarbarians;
    if (i >= phaseState.pathAdvanceCounts[path.index]) {
      return;
    }
    barbariansAdvanceOnPath(path, AdvanceType.regular);
  }

  void barbariansPhaseAdvanceSouth0() {
    barbariansPhaseAdvancePath(Path.south, 0);
  }

  void barbariansPhaseAdvanceSouth1() {
    barbariansPhaseAdvancePath(Path.south, 1);
  }

  void barbariansPhaseAdvanceSouth2() {
    barbariansPhaseAdvancePath(Path.south, 2);
  }

  void barbariansPhaseAdvanceWest0() {
    barbariansPhaseAdvancePath(Path.west, 0);
  }

  void barbariansPhaseAdvanceWest1() {
    barbariansPhaseAdvancePath(Path.west, 1);
  }

  void barbariansPhaseAdvanceWest2() {
    barbariansPhaseAdvancePath(Path.west, 2);
  }

  void barbariansPhaseAdvanceNorth0() {
    barbariansPhaseAdvancePath(Path.north, 0);
  }

  void barbariansPhaseAdvanceNorth1() {
    barbariansPhaseAdvancePath(Path.north, 1);
  }

  void barbariansPhaseAdvanceNorth2() {
    barbariansPhaseAdvancePath(Path.north, 2);
  }

  void barbariansPhaseAdvanceIberia0() {
    barbariansPhaseAdvancePath(Path.iberia, 0);
  }

  void barbariansPhaseAdvanceIberia1() {
    barbariansPhaseAdvancePath(Path.iberia, 1);
  }

  void barbariansPhaseAdvanceIberia2() {
    barbariansPhaseAdvancePath(Path.iberia, 2);
  }

  void barbariansPhaseAdvancePersia0() {
    barbariansPhaseAdvancePath(Path.persia, 0);
  }

  void barbariansPhaseAdvancePersia1() {
    barbariansPhaseAdvancePath(Path.persia, 1);
  }

  void barbariansPhaseAdvancePersia2() {
    barbariansPhaseAdvancePath(Path.persia, 2);
  }

  void barbariansPhaseAdvanceSyria0() {
    barbariansPhaseAdvancePath(Path.syria, 0);
  }

  void barbariansPhaseAdvanceSyria1() {
    barbariansPhaseAdvancePath(Path.syria, 1);
  }

  void barbariansPhaseAdvanceSyria2() {
    barbariansPhaseAdvancePath(Path.syria, 2);
  }

  void barbariansPhaseEnd() {
    _phaseState = null;
  }

  void byzantineActionPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Byzantine Action Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    logLine('## Byzantine Action Phase');
    _phaseState = PhaseStateByzantineAction();
  }

  void byzantineActionPhaseActions() {
    final phaseState = _phaseState as PhaseStateByzantineAction;

    while (true) {
      if (_subStep == 0) {
        if (choicesEmpty()) {
          setPrompt('Select Tile to Attack or Action to perform');
          int attackBudget = _state.solidusAndNike;
          if (phaseState.shiftForcesRetreatCount > 0) {
            attackBudget += phaseState.shiftForcesRetreatCount;
          } else {
            if ((_state.basileisAreSoldier && phaseState.soldierEmperorFreeAttackCount == 0) ||
                _state.pieceLocation(Piece.magisterMilitum) == Location.constantinople) {
              attackBudget += 1;
            }
          }
          bool basileusAvailable = _state.pieceLocation(Piece.basileus) == Location.constantinople;
          bool shiftForcesPossible = false;
          for (final candidate in attackCandidates(attackBudget)) {
            int cost = _state.armyAttackCost(candidate);
            if (cost >= phaseState.shiftForcesRetreatCount) {
              pieceChoosable(candidate);
            }
            if (cost > phaseState.shiftForcesRetreatCount) {
              shiftForcesPossible = true;
            }
          }
          if (shiftForcesPossible) {
            choiceChoosable(Choice.shiftForces, true);
          }
          if (phaseState.shiftForcesRetreatCount == 0) {
            if (_state.piecesInLocationCount(PieceType.outpost, Location.availableOutpostsBox) > 0) {
              choiceChoosable(Choice.seizeOutpost, _state.solidusAndNike >= seizeOutpostCost);
            }
            if (abandonOutpostCandidates.isNotEmpty) {
              choiceChoosable(Choice.abandonOutpost, true);
            }
            if (_state.piecesInLocationCount(PieceType.connectedMonastery, Location.trayGeography) > 0) {
              if (buildMonasteryCandidateLocations.isNotEmpty) {
                choiceChoosable(Choice.buildMonastery, _state.solidusAndNike >= buildMonasteryCost);
                if (basileusAvailable && _state.currentTurn < 11) {
                  choiceChoosable(Choice.buildMonasterySlavery, true);
                }
              }
            }
            if (_state.piecesInLocationCount(PieceType.unusedHospital, Location.trayGeography) > 0) {
              if (buildHospitalCandidateLocations.isNotEmpty) {
                choiceChoosable(Choice.buildHospital, _state.solidusAndNike >= 2);
                if (basileusAvailable && _state.currentTurn < 11) {
                  choiceChoosable(Choice.buildHospitalSlavery, true);
                }
              }
            }
            if (abandonHospitalCandidates.isNotEmpty) {
              choiceChoosable(Choice.abandonHospital, true);
            }
            if (_state.piecesInLocationCount(PieceType.unusedAkritai, Location.trayGeography) > 0) {
              if (buildAkritaiCandidateLocations.isNotEmpty) {
                choiceChoosable(Choice.buildAkritai, _state.solidusAndNike >= 2);
              }
            }
            if (abandonAkritaiCandidates.isNotEmpty) {
              choiceChoosable(Choice.abandonAkritai, true);
            }
            if (_state.schism > 0) {
              choiceChoosable(Choice.enforceOrthodoxy, _state.solidusAndNike >= 1 || (_state.haveSaint && !phaseState.enforceOrthodoxyIgnoreDrms && !phaseState.enforceOthodoxyFree));
            }
            for (final faction in PieceType.faction.pieces) {
              if (_state.pieceLocation(faction).isType(LocationType.omnibus)) {
                choiceChoosable(Choice.buildFaction, _state.solidusAndNike >= 1);
                break;
              }
            }
            if (_state.pieceLocation(Piece.empiresInRubble).isType(LocationType.omnibus)) {
              choiceChoosable(Choice.cleanRubble, _state.solidusAndNike >= 2);
            }
            if (_state.reformed && _state.pieceLocation(Piece.outpostLazica) == Location.outpostLazicaBox) {
              choiceChoosable(Choice.activateGreekFire, true);
            }
            if (_state.basileisAreCunning || _state.basileisAreImpulsive) {
              for (final social in PieceType.social.pieces) {
                if (_state.pieceLocation(social).isType(LocationType.land)) {
                  choiceChoosable(Choice.exploitSocialDifferences, _state.solidusAndNike >= 2);
                  break;
                }
              }
            }
            if (_state.pieceLocation(Piece.plague) == Location.constantinople) {
              int hospitalCount = 0;
              for (final hospital in PieceType.unusedHospital.pieces) {
                final location = _state.pieceLocation(hospital);
                if (location.isType(LocationType.land) && _state.landIsPlayerControlled(location)) {
                  hospitalCount += 1;
                }
              }
              if (hospitalCount >= 2) {
                choiceChoosable(Choice.combatPlague, true);
              }
            }
            if (reopenMonasteryCandidates.isNotEmpty) {
              choiceChoosable(Choice.reopenMonasteries, true);
            }
            if (basileusAvailable) {
              if (_state.piecesInLocationCount(PieceType.riots, Location.constantinople) > 0) {
                choiceChoosable(Choice.calmRiot, true);
              }
              final rulerLocation = _state.rulerLocation;
              if (rulerLocation.isType(LocationType.land)) {
                choiceChoosable(Choice.faceRuler, true);
              }
              final caliphLocation = _state.pieceLocation(Piece.caliph);
              if (caliphLocation.isType(LocationType.land)) {
                choiceChoosable(Choice.faceCaliph, true);
              }
              for (final faction in PieceType.faction.pieces) {
                if (faction != Piece.factionTheodosianWalls && _state.pieceLocation(faction).isType(LocationType.omnibus)) {
                  choiceChoosable(Choice.legendaryOrator, true);
                  break;
                }
              }
              if (!_state.pieceLocation(Piece.stolos).isType(LocationType.chronographia)) {
                choiceChoosable(Choice.navalReforms, true);
              }
              if (_state.solidus < 12) {
                choiceChoosable(Choice.ruinousTaxation, true);
              }
              if (_state.basileisAreSaint && _state.schism > 0) {
                choiceChoosable(Choice.churchPolitics, true);
              }
              for (final dynatoi in PieceType.dynatoi.pieces) {
                if (_state.pieceLocation(dynatoi).isType(LocationType.land)) {
                  choiceChoosable(Choice.legislate, true);
                  break;
                }
              }
              if (!_state.reformed) {
                choiceChoosable(Choice.visionaryReformer, true);
              }
              if (expelColonistsCandidates.isNotEmpty) {
                choiceChoosable(Choice.expelColonists, true);
              }
              if (_state.pieceLocation(Piece.university) == Location.trayPatriarchs) {
                choiceChoosable(Choice.pandidakterion, true);
              }
            }
            choiceChoosable(Choice.next, true);
          } else {

          }
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.next)) {
          return;
        }
        if (checkChoiceAndClear(Choice.seizeOutpost)) {
          _subStep = 4;
        } else if (checkChoiceAndClear(Choice.abandonOutpost)) {
          _subStep = 5;
        } else if (checkChoiceAndClear(Choice.buildMonastery)) {
          _subStep = 6;
        } else if (checkChoiceAndClear(Choice.buildMonasterySlavery)) {
          phaseState.useBasileus = true;
          _subStep = 6;
        } else if (checkChoiceAndClear(Choice.buildHospital)) {
          _subStep = 7;
        } else if (checkChoiceAndClear(Choice.buildHospitalSlavery)) {
          phaseState.useBasileus = true;
          _subStep = 7;
        } else if (checkChoiceAndClear(Choice.abandonHospital)) {
          _subStep = 8;
        } else if (checkChoiceAndClear(Choice.buildAkritai)) {
          _subStep = 9;
        } else if (checkChoiceAndClear(Choice.abandonAkritai)) {
          _subStep = 10;
        } else if (checkChoiceAndClear(Choice.buildFaction)) {
          _subStep = 11;
        } else if (checkChoiceAndClear(Choice.legendaryOrator)) {
          phaseState.useBasileus = true;
          _subStep = 11;
        } else if (checkChoiceAndClear(Choice.enforceOrthodoxy)) {
          _subStep = 12;
        } else if (checkChoiceAndClear(Choice.legislate)) {
          _subStep = 13;
        } else if (checkChoiceAndClear(Choice.expelColonists)) {
          _subStep = 14;
        } else if (checkChoiceAndClear(Choice.shiftForces)) {
          _subStep = 15;
        } else if (checkChoiceAndClear(Choice.cleanRubble)) {
          logLine('### Clean Rubble');
          spendSolidus(2);
          final box = _state.pieceLocation(Piece.empiresInRubble);
          if (box == Location.omnibus1) {
            logLine('> Byzantine Empire recovers fully from the war with Sassanid Persia.');
            _state.setPieceLocation(Piece.empiresInRubble, Location.discarded);
          } else {
            logLine('> Byzantine Empire rebuilds after the war with Sassanid Persia.');
            _state.setPieceLocation(Piece.empiresInRubble, Location.values[box.index - 1]);
          }
        } else if (checkChoiceAndClear(Choice.calmRiot)) {
          logLine('### Calm Riot');
          int die = rollD6();
          if (die > 2) {
            logLine('> Riot is quelled.');
            final riots = _state.piecesInLocation(PieceType.riots, Location.constantinople);
            _state.setPieceLocation(_state.pieceFlipSide(riots[0])!, Location.trayUnits);
          } else {
            logLine('> Riot continues.');
          }
          _state.setPieceLocation(Piece.basileus, Location.hippodromeBox);
        } else if (checkChoiceAndClear(Choice.activateGreekFire)) {
          logLine('### Greek Fire');
          logLine('> Greek Fire is perfected.');
          _state.setPieceLocation(Piece.outpostLazica, Location.outpostLazicaGreekFireBox);
          for (final outpost in _state.piecesInLocation(PieceType.outpost, Location.availableOutpostsBox)) {
            _state.setPieceLocation(outpost, Location.discarded);
          }
        } else if (checkChoiceAndClear(Choice.faceRuler)) {
          final ruler = _state.ruler!;
          logLine('### Face the $ruler.name');
          int die = rollD6();
          if (die >= 2 && die <= 5) {
            logLine('> ${ruler.name} is defeated.');
            _state.setPieceLocation(Piece.rulerKhan, _state.futureChronographiaBox(die));
          } else {
            logLine('> ${ruler.name} remains in power.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die));
        } else if (checkChoiceAndClear(Choice.faceCaliph)) {
          logLine('### Face the Caliph');
          int die = rollD6();
          if (die >= 2 && die <= 5) {
            logLine('> Caliph is defeated.');
            _state.setPieceLocation(Piece.caliph, _state.futureChronographiaBox(die));
          } else {
            logLine('> Caliph remains in power.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die));
        } else if (checkChoiceAndClear(Choice.navalReforms)) {
          logLine('### Naval Reforms');
          int die = rollD6();
          if (die >= 2 && die <= 5) {
            logLine('> Naval Reforms deter Stolos.');
            _state.setPieceLocation(Piece.stolos, _state.futureChronographiaBox(die));
          } else {
            logLine('> Naval Reforms are unsuccessful.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die));
        } else if (checkChoiceAndClear(Choice.ruinousTaxation)) {
          logLine('### Ruinous Taxation');
          int die = rollD6();
          if (die >= 2 && die <= 5) {
            logLine('> Taxation fills coffers.');
            adjustSolidus(die);
          } else {
            logLine('> Tax increases fail to increase revenue.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die));
        } else if (checkChoiceAndClear(Choice.churchPolitics)) {
          logLine('### Church Politics');
          int die = rollD6();
          if (die >= 2 && die <= 5) {
            logLine('> Religious differences are eased.');
            adjustSchism(-die);
          } else {
            logLine('> Religious differences continue unabated.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die));
        } else if (checkChoiceAndClear(Choice.visionaryReformer)) {
          logLine('### Visionary Reformer');
          int die = rollD6();
          if (die >= 2 && die <= 5) {
            adjustReforms(die);
          } else {
            logLine('> Reforms are unsuccessful.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die));
        } else if (checkChoiceAndClear(Choice.pandidakterion)) {
          logLine('### Pandidakterion');
          int die = rollD6();
          if (die >= 2 && die <= 5) {
            logLine('> University is established.');
            _state.setPieceLocation(Piece.university, Location.constantinople);
          } else {
            logLine('> Attempt to establish University fails.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die));
        } else if (checkChoiceAndClear(Choice.exploitSocialDifferences)) {
          logLine('### Exploit Social Differences');
          spendSolidus(2);
          for (final path in Path.values) {
            final land = _state.pathFinalLand(path);
            var social = _state.pieceInLocation(PieceType.social, land);
            if (social != null) {
              logLine('> ${social.name} is removed from ${_state.landName(land)}.');
              if (social.isType(PieceType.dynatoi)) {
                social = _state.pieceFlipSide(social)!;
              }
              _state.setPieceLocation(social, Location.trayUnits);
            }
          }
        } else if (checkChoiceAndClear(Choice.combatPlague)) {
          logLine('### Combat Plague');
          for (final hospital in PieceType.hospital.pieces) {
            final location = _state.pieceLocation(hospital);
            _state.setPieceLocation(_state.pieceFlipSide(hospital)!, location);
          }
          int die = rollD6();
          if (die >= 4) {
            logLine('> Plague is contained.');
            _state.setPieceLocation(Piece.basileus, Location.constantinople);
          } else {
            logLine('> Plague still rages.');
          }
        } else if (checkChoiceAndClear(Choice.reopenMonasteries)) {
          logLine('### Reopen Monasteries');
          for (final monastery in reopenMonasteryCandidates) {
            final zone = _state.pieceLocation(monastery);
            logLine('> Reopen Monastery in ${_state.landName(zone)}.');
            _state.setPieceLocation(_state.pieceFlipSide(monastery)!, zone);
          }
        } else {
          phaseState.attackTarget = selectedPiece()!;
          clearChoices();
          _subStep = 1;
        }
      }

      if (_subStep == 1) { // Attack
        final army = phaseState.attackTarget!;
        int cost = _state.armyAttackCost(army) - phaseState.shiftForcesRetreatCount;
        bool useSolidus = _state.solidusAndNike >= cost;
        bool useSoldierEmperor = _state.basileisAreSoldier && phaseState.soldierEmperorFreeAttackCount == 0;
        bool useMagisterMilitum = _state.pieceLocation(Piece.magisterMilitum) == Location.constantinople;
        bool useBasileus = _state.pieceLocation(Piece.basileus) == Location.constantinople && _state.solidusAndNike >= cost;
        if (phaseState.shiftForcesRetreatCount == 0 && choicesEmptyApartFromPieces()) {
          if (_state.pieceLocation(Piece.magisterMilitum) == Location.constantinople) {
            choiceChoosable(Choice.attackWithMagisterMilitum, true);
          }
          if (_state.basileisAreSoldier) {
            choiceChoosable(Choice.attackWithSoldierEmperor, phaseState.soldierEmperorFreeAttackCount == 0);
          }
          if (_state.pieceLocation(Piece.basileus) == Location.constantinople) {
            choiceChoosable(Choice.attackWithBasileusIntoBattle, _state.solidusAndNike >= cost);
          }
          choiceChoosable(Choice.attackWithSolidus, useSolidus);
          if (enabledChoiceCount > 1) {
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
        }
        if (checkChoice(Choice.cancel)) {
          phaseState.attackTarget = null;
          clearChoices();
          _subStep = 0;
          continue;
        }
        if (checkChoice(Choice.attackWithSolidus)) {
          useSoldierEmperor = false;
          useMagisterMilitum = false;
          useBasileus = false;
        } else if (checkChoice(Choice.attackWithSoldierEmperor)) {
          useSolidus = false;
          useMagisterMilitum = false;
          useBasileus = false;
        } else if (checkChoice(Choice.attackWithMagisterMilitum)) {
          useSolidus = false;
          useSoldierEmperor = false;
          useBasileus = false;
        } else if (checkChoice(Choice.attackWithBasileusIntoBattle)) {
          useSolidus = false;
          useSoldierEmperor = false;
          useMagisterMilitum = false;
        }
        final land = _state.pieceLocation(army);
        if (useSoldierEmperor) {
          logLine('### Soldier Emperor ${_state.basileisSoldierName} Attacks ${_state.armyName(army)} in ${_state.landName(land)}');
          cost -= 1;
          phaseState.soldierEmperorFreeAttackCount += 1;
        } else if (useMagisterMilitum) {
          logLine('### Magister Militum ${_state.magisterMilitumName} Attacks ${_state.armyName(army)} in ${_state.landName(land)}');
          cost -= 1;
          phaseState.magisterMilitumFreeAttack = true;
        } else if (useBasileus) {
          phaseState.basileusIntoBattle = true;
          logLine('### ${_state.basileusName(_state.currentBasileus)} Attacks ${_state.armyName(army)} in ${_state.landName(land)}');
        } else {
          logLine('### Attack ${_state.armyName(army)} in ${_state.landName(land)}');
        }
        if (cost > 0) {
          spendSolidus(cost);
        }
        clearChoices();
        _subStep = 2;
      }

      if (_subStep == 2) { // Resolve Attack
        AttackType attackType = AttackType.regular;
        if (phaseState.magisterMilitumFreeAttack) {
          attackType = AttackType.magisterMilitum;
        } else if (phaseState.basileusIntoBattle) {
          if (_state.basileisAreSoldier) {
            attackType = AttackType.intoBattleSword;
          } else {
            attackType = AttackType.intoBattleNoSword;
          }
        } else if (phaseState.shiftForcesRetreatCount > 0) {
          attackType = AttackType.shiftForces;
        }
        final results = attackPiece(phaseState.attackTarget!, attackType);
        bool victory = results.$1;
        int armyStrength = results.$2;
        bool magisterMilitumDefeated = !victory && phaseState.magisterMilitumFreeAttack;
        phaseState.attackTarget = null;
        phaseState.magisterMilitumFreeAttack = false;
        phaseState.basileusIntoBattle = false;
        phaseState.shiftForcesRetreatCount = 0;
        if (magisterMilitumDefeated) {
          logLine('> Magister Militum ${_state.magisterMilitumName} suffers defeat.');
          _state.setPieceLocation(Piece.magisterMilitum, Location.traySieges);
          phaseState.magisterMilitumDefeatStrength = armyStrength;
          _subStep = 3;
        } else {
          _subStep = 0;
        }
      }

      if (_subStep == 3) { // Magister Militum Defeated
        if (choicesEmpty()) {
          setPrompt('Raise Schism or suffer Riots?');
          choiceChoosable(Choice.increaseSchism, true);
          choiceChoosable(Choice.incurRiot, _state.piecesInLocationCount(PieceType.latins, Location.trayUnits) > 0);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.increaseSchism)) {
          adjustSchism(phaseState.magisterMilitumDefeatStrength!);
        } else if (checkChoiceAndClear(Choice.incurRiot)) {
          final latins = _state.piecesInLocation(PieceType.latins, Location.trayUnits);
          logLine('> Riots in Constantinople.');
          _state.setPieceLocation(_state.pieceFlipSide(latins[0])!, Location.constantinople);
        }
        phaseState.magisterMilitumDefeatStrength = null;
        _subStep = 0;
      }

      if (_subStep == 4) { // Seize Outpost
        if (choicesEmpty()) {
          setPrompt('Select Outpost to Seize');
          for (final outpost in _state.piecesInLocation(PieceType.outpost, Location.availableOutpostsBox)) {
            pieceChoosable(outpost);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final outpost = selectedPiece()!;
        logLine('### Seize ${outpost.name}');
        spendSolidus(seizeOutpostCost);
        Location? outpostBox;
        switch (outpost) {
        case Piece.outpostLazica:
          outpostBox = Location.outpostLazicaBox;
        case Piece.outpostRome:
          outpostBox = Location.outpostRomeBox;
        case Piece.outpostSicily:
          outpostBox = Location.outpostSicilyBox;
        case Piece.outpostSpain:
          outpostBox = Location.outpostSpainBox;
        default:
        }
        _state.setPieceLocation(outpost, outpostBox!);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 5) { // Abandon Outpost
        if (choicesEmpty()) {
          setPrompt('Selet Outpost to Abandon');
          for (final outpost in abandonOutpostCandidates) {
            pieceChoosable(outpost);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final outpost = selectedPiece()!;
        logLine('### Abandon ${outpost.name}');
        _state.setPieceLocation(outpost, Location.discarded);
        adjustSolidus(_state.outpostAbandonIncome(outpost));
        int schismAdjustment = _state.outpostAbandonSchism(outpost);
        final outpostAdvancePath = _state.outpostAbandonAdvancePath(outpost);
        if (outpostAdvancePath != null) {
          phaseState.advancePath = outpostAdvancePath;
          phaseState.postAdvanceSchismAdjustment = schismAdjustment;
          _subStep = 20;
        } else {
          adjustSchism(schismAdjustment);
          _subStep = 0;
        }
        clearChoices();
      }

      if (_subStep == 6) { // Build Monastery
        if (choicesEmpty()) {
          setPrompt('Select Zone to Build Monastery in.');
          for (final candidate in buildMonasteryCandidateLocations) {
            locationChoosable(candidate);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final zone = selectedLocation()!;
        final path = _state.landPath(zone)!;
        int die = 2;
        if (phaseState.useBasileus) {
          logLine('### Build Monastery using slave labor');
          die = rollD6();
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die));
        } else {
          logLine('### Build Monastery');
          spendSolidus(buildMonasteryCost);
        }
        if (die >= 2 && die <= 5) {
          logLine('> Monastery is built in ${_state.pathGeographicName(path)}.');
          final monasteries = _state.piecesInLocation(PieceType.connectedMonastery, Location.trayGeography);
          _state.setPieceLocation(monasteries[0], zone);
        } else {
          logLine('> Monastery is never completed.');
        }
        clearChoices();
        phaseState.useBasileus = false;
        _subStep = 0;
      }

      if (_subStep == 7) { // Build Hospital
        if (choicesEmpty()) {
          setPrompt('Select Zone or Theme to Build Hospital in.');
          for (final candidate in buildHospitalCandidateLocations) {
            locationChoosable(candidate);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final land = selectedLocation()!;
        int die = 2;
        if (phaseState.useBasileus) {
          logLine('### Build Hospital using slave labor');
          die = rollD6();
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die));
        } else {
          logLine('### Build Hospital');
          spendSolidus(2);
        }
        if (die >= 2 && die <= 5) {
          logLine('> Hospital is built in ${_state.landName(land)}.');
          final hospitals = _state.piecesInLocation(PieceType.unusedHospital, Location.trayGeography);
          _state.setPieceLocation(hospitals[0], land);
        } else {
          logLine('> Hospital is never completed.');
        }
        clearChoices();
        phaseState.useBasileus = false;
        _subStep = 0;
      }

      if (_subStep == 8) { // Abandon Hospital
        if (choicesEmpty()) {
          setPrompt('Select Hospital to remove from map.');
          for (final candidate in abandonHospitalCandidates) {
            pieceChoosable(candidate);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        logLine('### Build Hospital');
        var hospital = selectedPiece()!;
        final land = _state.pieceLocation(hospital);
        logLine('> Hospital in ${_state.landName(land)} is abandoned.');
        if (!hospital.isType(PieceType.unusedHospital)) {
          hospital = _state.pieceFlipSide(hospital)!;
        }
        _state.setPieceLocation(hospital, Location.trayGeography);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 9) { // Build Akritai
        if (choicesEmpty()) {
          setPrompt('Select Theme to Build Akritai in.');
          for (final candidate in buildAkritaiCandidateLocations) {
            locationChoosable(candidate);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        logLine('### Build Akritai');
        final land = selectedLocation()!;
        logLine('> Akritai is built in ${_state.landName(land)}.');
        spendSolidus(2);
        final akritais = _state.piecesInLocation(PieceType.unusedAkritai, Location.trayGeography);
        _state.setPieceLocation(akritais[0], land);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 10) { // Abandon Akritai
        if (choicesEmpty()) {
          setPrompt('Select Akritai to remove from map.');
          for (final candidate in abandonAkritaiCandidates) {
            pieceChoosable(candidate);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        var akritai = selectedPiece()!;
        final land = _state.pieceLocation(akritai);
        logLine('> Akritai in ${_state.landName(land)} is abandoned.');
        if (!akritai.isType(PieceType.unusedAkritai)) {
          akritai = _state.pieceFlipSide(akritai)!;
        }
        _state.setPieceLocation(akritai, Location.trayGeography);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 11) { // Build Faction
        if (choicesEmpty()) {
          setPrompt('Select Faction to build.');
          for (final faction in PieceType.faction.pieces) {
            if (_state.pieceLocation(faction).isType(LocationType.omnibus)) {
              if (!phaseState.useBasileus || faction != Piece.factionTheodosianWalls) {
                pieceChoosable(faction);
              }
            }
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final faction = selectedPiece()!;
        final location = _state.pieceLocation(faction);
        int value = location.index - Location.omnibus0.index;
        bool moved = false;
        if (phaseState.useBasileus) {
          logLine('### Legendary Orator');
          int die = rollD6();
          if (die >= 2 && die <= 5) {
            value -= die;
            moved = true;
          } else {
            logLine('> Crowd is unmoved.');
          }
        } else {
          logLine('### Rebuild Faction');
          spendSolidus(1);
          value -= 1;
          moved = true;
        }
        if (moved) {
          if (value <= 0) {
            logLine('> ${faction.name} is placed in Constantinople.');
            _state.setPieceLocation(faction, Location.constantinople);
          } else {
            logLine('> ${faction.name} something.');
            _state.setPieceLocation(faction, _state.omnibusBox(value));
          }
        }
        clearChoices();
        phaseState.useBasileus = false;
        _subStep = 0;
      }

      if (_subStep == 12) { // Enforce Orthodoxy
        bool ignoreDrms = phaseState.enforceOrthodoxyIgnoreDrms;
        bool freeRoll = false;
        if (_state.solidusAndNike == 0) {
          phaseState.enforceOthodoxyFree = true;
          freeRoll = true;
        }
        if (_state.haveSaint && !phaseState.enforceOrthodoxyIgnoreDrms && !phaseState.enforceOthodoxyFree) {
          if (choicesEmpty()) {
            setPrompt('Choose how to use Saint');
            choiceChoosable(Choice.enforceOrthodoxyIgnoreDrms, true);
            choiceChoosable(Choice.enforceOrthodoxyFree, true);
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
          if (checkChoiceAndClear(Choice.cancel)) {
            _subStep = 0;
            continue;
          }
          if (checkChoiceAndClear(Choice.enforceOrthodoxyIgnoreDrms)) {
            phaseState.enforceOrthodoxyIgnoreDrms = true;
            ignoreDrms = true;
          } else if (checkChoiceAndClear(Choice.enforceOrthodoxyFree)) {
            phaseState.enforceOthodoxyFree = true;
            freeRoll = true;
          }
        }
        logLine('### Enforce Orthodoxy');
        int rollCount = 2;
        if (_state.currentTurnHasEcumenicalCouncil) {
          rollCount += 1;
        }
        if (freeRoll) {
          rollCount = 1;
        } else {
          spendSolidus(1);
        }
        for (int i = 0; i < rollCount && _state.schism > 0; ++i) {
          int die = rollD6();
          int drm = 0;
          if (!ignoreDrms) {
            if (_state.popeMean) {
              logLine('> Mean Pope: -1');
              drm -= 1;
            }
            for (final land in [Location.themeCilicia, Location.themeNisibis]) {
              if (_state.landIsPlayerControlled(land)) {
                logLine('> ${_state.landName(land)}: -1');
                drm -= 1;
              }
            }
          }
          int modifiedDie = dieWithDrm(die, drm);
          logLine('> Modified roll: $modifiedDie');
          if (modifiedDie > 1) {
            logLine('> Schism is reduced.');
            adjustSchism(-1);
          } else {
            logLine('> Schism is unchanged.');
          }
        }
        _subStep = 0;
      }

      if (_subStep == 13) {
        if (choicesEmpty()) {
          setPrompt('Select Dynatoi to legislate against.');
          for (final dynatoi in PieceType.dynatoi.pieces) {
            if (_state.pieceLocation(dynatoi).isType(LocationType.land)) {
              pieceChoosable(dynatoi);
            }
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        logLine('### Legislate');
        final dynatoi = selectedPiece()!;
        int die = rollD6();
        if (die >= 2 && die <= 5) {
          logLine('> Legislation brings Dynatoi to heel.');
          _state.setPieceLocation(dynatoi, _state.futureChronographiaBox(die));
        } else {
          logLine('> Legislation fails to control Dynatoi.');
        }
        _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die));
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 14) { // Expel Colonists
        if (choicesEmpty()) {
          setPrompt('Select Muslim Colonists to Expel');
          for (final colonists in expelColonistsCandidates) {
            pieceChoosable(colonists);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        logLine('### Expel Colonists');
        final colonists = selectedPiece()!;
        final land = _state.pieceLocation(colonists);
        int die = rollD6();
        if (die >= 2 && die <= 5) {
          logLine('> Muslim Colonists are expelled from ${_state.landName(land)}.');
          final path = _state.landPath(land)!;
          _state.setPieceLocation(colonists, _state.pathNextLocation(path, land)!);
        } else {
          logLine('> Efforts to expel Muslim Colonists from ${_state.landName(land)} fail.');
        }
        _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die));
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 15) { // Shift Forces
        if (choicesEmpty()) {
          setPrompt('Select Path to withdraw forces from');
          for (final path in Path.values) {
            final land = _state.pathFinalLand(path);
            locationChoosable(land);
          }
          choiceChoosable(Choice.cancel, phaseState.shiftForcesRetreatCount == 0);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final land = selectedLocation()!;
        final path = _state.landPath(land);
        logLine('### Shift Forces');
        clearChoices();
        phaseState.advancePath = path;
        phaseState.shiftForcesRetreatCount += 1;
        _subStep = 20;
      }

      if (_subStep == 20) { // Advance after Abandon Outpost or Shift Forces
        AdvanceType advanceType = phaseState.shiftForcesRetreatCount > 0 ? AdvanceType.automatic : AdvanceType.regular;
        barbariansAdvanceOnPath(phaseState.advancePath!, advanceType);
        phaseState.advancePath = null;
        if (phaseState.postAdvanceSchismAdjustment != null) {
          adjustSchism(phaseState.postAdvanceSchismAdjustment!);
          phaseState.postAdvanceSchismAdjustment = null;
        }
        _subStep = 0;
      }
    }
  }

  void byzantineActionPhaseEnd() {
    _phaseState = null;
  }

  void turnEndPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Turn End Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    logLine('## Turn End Phase');
  }

  void turnEndPhaseBanking() {
    int monasteryCount = 0;
    for (final monastery in PieceType.connectedMonastery.pieces) {
      if (_state.pieceLocation(monastery).isType(LocationType.land)) {
        monasteryCount += 1;
      }
    }
    int bankingLimit = 1;
    if (monasteryCount == 1) {
      bankingLimit = 3;
    } else if (monasteryCount == 2) {
      bankingLimit = 12;
    }
    if (_state.solidus > bankingLimit) {
      logLine('### Banking');
      adjustSolidus(bankingLimit - _state.solidus);
    }
  }

  void turnEndPhaseCancelMilitary() {
    _state.setPieceLocation(Piece.militaryEvent, Location.militaryEventBox);
  }

  void turnEndPhaseMuslimColonists() {
    for (final colonists in PieceType.colonists.pieces) {
      final location = _state.pieceLocation(colonists);
      if (location.isType(LocationType.land)) {
        final path = _state.landPath(location)!;
        final army = _state.pathBarbarianPiece(path);
        if (_state.barbarianIsMuslim(army)) {
          final armyLocation = _state.pieceLocation(army);
          if (armyLocation.index < location.index) {
            logLine('### Muslim Colonists');
            break;
          }
        }
      }
    }
  }

  void turnEndPhaseMuslimColonistsPath(Path path, Piece colonists, Piece seljukArmy) {
    final colonistsLocation = _state.pieceLocation(colonists);
    if (!colonistsLocation.isType(LocationType.land)) {
      return;
    }
    final army = _state.pathBarbarianPiece(path);
    if (!_state.barbarianIsMuslim(army)) {
      return;
    }
    final armyLocation = _state.pieceLocation(army);
    if (armyLocation.index >= colonistsLocation.index) {
      return;
    }
    if (_subStep == 0) {
      logLine('> Muslim Colonization on the ${path.name}.');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (army != seljukArmy) {
        int die = rollD6ForEasternPath(path);
        if (die < 6) {
          logLine('> Islam does not advance on the ${path.name}.');
          return;
        }
      }
      final prevLand = _state.pathPrevLocation(path, colonistsLocation);
      logLine('> Muslims colonize ${_state.landName(prevLand)}.');
      _state.setPieceLocation(colonists, prevLand);
    }
  }

  void turnEndPhaseMuslimColonistsPersia() {
    turnEndPhaseMuslimColonistsPath(Path.persia, Piece.colonistsPersia, Piece.armyPersiaSeljuk);
  }

  void turnEndPhaseMuslimColonistsSyria() {
    turnEndPhaseMuslimColonistsPath(Path.syria, Piece.colonistsSyria, Piece.armySyriaSeljuk);
  }

  void turnEndPhaseEgyptianApostasy() {
    if (_state.pieceLocation(Piece.egyptMuslim) == Location.egyptianReligionBox) {
      return;
    }
    if (_state.pieceLocation(Piece.outpostEgypt) == Location.outpostEgyptBox) {
      return;
    }
    final army = _state.pathBarbarianPiece(Path.syria);
    if (!_state.barbarianIsMuslim(army)) {
      return;
    }
    logLine('### Egyptian Apostasy');
    int die = rollD6();
    if (die < 6) {
      logLine('> Egypt remains Christian.');
      return;
    }
    logLine('> Egypt adopts Islam.');
    _state.setPieceLocation(Piece.egyptMuslim, Location.egyptianReligionBox);
  }

  void turnEndPhaseThreatToEgypt() {
    bool jerusalemBarbarian = _state.pathBarbarianControlledLandCount(Path.syria) >= 3;
    if (_state.pieceLocation(Piece.outpostEgypt) == Location.outpostEgyptBox) {
      if (!jerusalemBarbarian) {
        return;
      }
      logLine('### Threat to Egypt');
      int die = rollD6();
      if (die < 6) {
        logLine('> Egypt holds out.');
        return;
      }
      logLine('> Egypt falls.');
      _state.setPieceLocation(Piece.egyptFallen, Location.outpostEgyptBox);
      return;
    } 
    if (_state.pieceLocation(Piece.egyptFallen) != Location.outpostEgyptBox || jerusalemBarbarian) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Threat to Egypt');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Spend 1 \$solidus to attempt to reconquer Egypt?');
        choiceChoosable(Choice.yes, _state.solidusAndNike >= 1);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.no)) {
        logLine('> No attempt is made to reconquer Egypt.');
        return;
      }
      clearChoices();
      logLine('> Byzantine Empire attempts to reconquer Egypt.');
      spendSolidus(1);
      int die = rollD6();
      if (die < 6) {
        logLine('> Attempt to reconquer Egypt fails.');
        return;
      }
      logLine('> Egypt is reconquered.');
      _state.setPieceLocation(Piece.outpostEgypt, Location.outpostEgyptBox);
    }
  }

  void turnEndPhaseUndefeatedStolos() {
    if (!_state.pieceLocation(Piece.stolos).isType(LocationType.land)) {
      return;
    }
    logLine('### Undefeated Stolos');
    logLine('> Undefeated Stolos lowers morale in Constantinople.');
    removeRandomFaction(4);
    _state.stolosArmy = null;
  }

  void turnEndPhaseMongolRetreat() {
    final persianLocation = _state.pieceLocation(Piece.armyPersiaMongol);
    final syrianLocation = _state.pieceLocation(Piece.armySyriaMongol);
    if (!persianLocation.isType(LocationType.land) && !syrianLocation.isType(LocationType.land)) {
      return;
    }
    logLine('### Mongol Retreat');
    if (persianLocation.isType(LocationType.land)) {
      _state.setPieceLocation(Piece.armyPersiaMongol, Location.discarded);
      final colonistLocation = _state.pieceLocation(Piece.colonistsPersia);
      if (!colonistLocation.isType(LocationType.land) || colonistLocation == Location.homelandPersia) {
        logLine('> Persian rule revives in ${_state.pathGeographicName(Path.persia)}.');
        _state.setPieceLocation(Piece.armyPersiaPersia, persianLocation);
      } else {
        logLine('> Ilkhanid rule is established in ${_state.pathGeographicName(Path.persia)}.');
        _state.setPieceLocation(Piece.armyPersiaIlKhanid, persianLocation);
      }
    }
    if (syrianLocation.isType(LocationType.land)) {
      _state.setPieceLocation(Piece.armySyriaMongol, Location.discarded);
      final colonistLocation = _state.pieceLocation(Piece.colonistsSyria);
      if (!colonistLocation.isType(LocationType.land) || colonistLocation == Location.homelandSyria) {
        logLine('> Persian rule revives in ${_state.pathGeographicName(Path.syria)}.');
        _state.setPieceLocation(Piece.armySyriaPersia, syrianLocation);
      } else {
        logLine('> Ilkhanid rule is established in ${_state.pathGeographicName(Path.syria)}.');
        _state.setPieceLocation(Piece.armySyriaIlKhanid, syrianLocation);
      }
    }
  }

  void turnEndPhaseTreatiesExpire() {
    _state.setPieceLocation(Piece.tribute, Location.trayMilitary);
  }

  void turnEndPhaseBasileusSocialSkills() {
    final socialTiles = <Piece>[];
    for (final social in PieceType.social.pieces) {
      if (_state.pieceLocation(social).isType(LocationType.land)) {
        socialTiles.add(social);
      }
    }
    if (socialTiles.isEmpty) {
      return;
    }
    if (!_state.basileisAreCunning && !_state.basileisAreImpulsive) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Basileus Social Skills');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (_state.basileisAreCunning) {
        if (choicesEmpty()) {
          setPrompt('Remove all Social Tiles?');
          choiceChoosable(Choice.yes, true);
          choiceChoosable(Choice.no, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.no)) {
          logLine('> Basileus chooses to leave Social Tiles in place.');
          return;
        }
        clearChoices();
      }
      for (var social in socialTiles) {
        final location = _state.pieceLocation(social);
        final path = _state.landPath(location)!;
        logLine('> ${social.name} is removed from the ${path.name}.');
        if (social.isType(PieceType.dynatoi)) {
          social = _state.pieceFlipSide(social)!;
        }
        _state.setPieceLocation(social, Location.trayUnits);
      }
    }
  }

  void turnEndPhaseUnflip() {
    for (final hospital in PieceType.usedHospital.pieces) {
      final location = _state.pieceLocation(hospital);
      if (location != Location.flipped) {
        _state.setPieceLocation(_state.pieceFlipSide(hospital)!, location);
      }
    }
    for (final akritai in PieceType.usedAkritai.pieces) {
      final location = _state.pieceLocation(akritai);
      if (location != Location.flipped) {
        _state.setPieceLocation(_state.pieceFlipSide(akritai)!, location);
      }
    }
    if (_state.pieceLocation(Piece.plague) == Location.constantinople || _state.pieceLocation(Piece.basileus) == Location.hippodromeBox) {
      _state.setPieceLocation(Piece.basileus, Location.constantinople);
    }
    _state.setPieceLocation(Piece.magisterMilitum, Location.traySieges);
    _state.clearPossibleEvents();
  }

  void turnEndPhaseVictory() {
    if (_state.currentTurn < 26) {
      return;
    }
    logLine('# Deus ex Machina');
    int total = 30;
    logLine('> Baseline: 30');
    for (final path in _state.westernPaths) {
      final armyType = _state.pathArmyType(path);
      final zone = _state.pathZone(path);
      final armyCount = _state.piecesInLocationCount(armyType, zone);
      total -= armyCount;
      logLine('> ${path.name}: -$armyCount');
    }
    for (final path in _state.easternPaths) {
      int controlledLandCount = _state.pathBarbarianControlledLandCount(path);
      total -= controlledLandCount;
      logLine('> ${path.name}: -$controlledLandCount');
    }
    for (final outpost in PieceType.outpost.pieces) {
      if (_state.pieceLocation(outpost).isType(LocationType.outpostBox)) {
        logLine('> ${outpost.name}: +2');
        total += 2;
      }
    }
    int factionCount = _state.piecesInLocationCount(PieceType.faction, Location.constantinople);
    if (factionCount > 0) {
      logLine('> Factions: +$factionCount');
      total += factionCount;
    }
    if (_state.solidus > 0) {
      logLine('> \$olidus: +${_state.solidus}');
      total += _state.solidus;
    }
    for (final monastery in PieceType.monastery.pieces) {
      final location = _state.pieceLocation(monastery);
      if (location.isType(LocationType.land)) {
        logLine('> Monastery in ${_state.landName(location)}: +3');
        total += 3;
      }
    }
    if (_state.pieceLocation(Piece.university).isType(LocationType.land)) {
      logLine('> University: +3');
      total += 3;
    }
    for (final hospital in PieceType.unusedHospital.pieces) {
      final location = _state.pieceLocation(hospital);
      if (location.isType(LocationType.land)) {
        logLine('> Hospital in ${_state.landName(location)}: +3');
        total += 3;
      }
    }
    if (_state.pieceLocation(Piece.geographyItaly) == Location.zoneWest) {
      logLine('> Italy: +5');
      total += 5;
    }
    if (_state.pieceLocation(Piece.geographyAfrica) == Location.zoneSouth) {
      logLine('> Africa: +5');
      total += 5;
    }
    if (_state.pieceLocation(Piece.empiresInRubble).isType(LocationType.omnibus)) {
      logLine('> Empire in Rubble: -10');
      total -= 10;
    }
    logLine('> Victory Points: $total');
    throw GameOverException(GameResult.victory, total);
  }

  void turnEndPhaseEndTurn() {
    _state.advanceTurn();
  }

  void playInSequence() {

    final stepHandlers = [
      turnBegin,
      chitDrawPhaseBegin,
      chitDrawPhaseChitDraw,
      turnStartPhaseBegin,
      turnStartPhaseChronographiaDeployments,
      turnStartPhaseEphesusAndChalcedon,
      turnStartPhaseMagisterMilitum,
      turnStartPhaseMigrationEvent,
      turnStartPhaseRiseOfIslamAdvancePersia,
      turnStartPhaseRiseOfIslamAdvanceSyria,
      turnStartPhaseRiseOfIslamAdvanceIberia,
      turnStartPhaseRiseOfIslamAdvancePersia,
      turnStartPhaseRiseOfIslamAdvanceSyria,
      turnStartPhaseRiseOfIslamAdvanceIberia,
      turnStartPhaseRiseOfIslamAdvancePersia,
      turnStartPhaseRiseOfIslamAdvanceSyria,
      turnStartPhaseRiseOfIslamAdvanceIberia,
      turnStartPhaseRiseOfIslamComplete,
      turnStartPhaseEcumenicalCouncilEvent,
      turnStartPhaseEastWestSchismEvent,
      turnStartPhaseReformsEvent,
      turnStartPhaseRandomBarbariansEvent,
      turnStartPhaseRandomBarbariansEvent,
      turnStartPhaseRandomBarbariansEvent,
      turnStartPhaseOptionalRandomBarbariansEvent0,
      turnStartPhaseOptionalRandomBarbariansEvent1,
      turnStartPhaseOptionalEvent,
      turnStartPhaseCrusadesBegin,
      turnStartPhaseCrusadesContinue,
      turnStartPhaseFirstCrusadeAttack,
      turnStartPhaseFirstCrusadeAttack,
      turnStartPhaseEnd,
      leadershipPhaseBegin,
      leadershipPhaseNewDynasty,
      leadershipPhaseNewBasileus,
      leadershipPhaseMutilateBasileus,
      leadershipPhaseNewPatriarch,
      leadershipPhaseNewPope,
      leadershipPhasePayTribute,
      leadershipPhaseBuildKastron,
      leadershipPhaseTurnChitSocialEvent,
      leadershipPhaseDynastySocialEvent,
      leadershipPhaseBasileusSocialEvent,
      leadershipPhaseResetNike,
      taxationPhaseBegin,
      taxationPhaseIncome,
      taxationPhaseKhan,
      taxationPhaseCaliph,
      synopsisOfHistoriesPhaseBegin,
      synopsisOfHistoriesPhaseRoll,
      synopsisOfHistoriesPhaseMilitaryEvent,
      synopsisOfHistoriesPhaseWarInTheEast2,
      synopsisOfHistoriesPhaseRiseOfIslamAdvancePersia,
      synopsisOfHistoriesPhaseRiseOfIslamAdvanceSyria,
      synopsisOfHistoriesPhaseRiseOfIslamAdvanceIberia,
      synopsisOfHistoriesPhaseRiseOfIslamAdvancePersia,
      synopsisOfHistoriesPhaseRiseOfIslamAdvanceSyria,
      synopsisOfHistoriesPhaseRiseOfIslamAdvanceIberia,
      synopsisOfHistoriesPhaseRiseOfIslamAdvancePersia,
      synopsisOfHistoriesPhaseRiseOfIslamAdvanceSyria,
      synopsisOfHistoriesPhaseRiseOfIslamAdvanceIberia,
      synopsisOfHistoriesPhaseRiseOfIslamComplete,
      synopsisOfHistoriesPhaseWarInTheEast1,
      synopsisOfHistoriesPhaseWarInTheEast1Iberia0,
      synopsisOfHistoriesPhaseWarInTheEast1Iberia1,
      synopsisOfHistoriesPhaseWarInTheEast1Iberia2,
      synopsisOfHistoriesPhaseWarInTheEast1Persia0,
      synopsisOfHistoriesPhaseWarInTheEast1Persia1,
      synopsisOfHistoriesPhaseWarInTheEast1Persia2,
      synopsisOfHistoriesPhaseWarInTheEast1Syria0,
      synopsisOfHistoriesPhaseWarInTheEast1Syria1,
      synopsisOfHistoriesPhaseWarInTheEast1Syria2,
      synopsisOfHistoriesPhaseWarInTheEast1Colonists,
      synopsisOfHistoriesPhaseJihadSouth,
      synopsisOfHistoriesPhaseJihadWest,
      synopsisOfHistoriesPhaseJihadNorth,
      synopsisOfHistoriesPhaseJihadIberia,
      synopsisOfHistoriesPhaseJihadPersia,
      synopsisOfHistoriesPhaseJihadSyria,
      synopsisOfHistoriesPhasePoliticalEvent0,
      synopsisOfHistoriesPhasePoliticalEvent1,
      synopsisOfHistoriesPhasePoliticalEvent2,
      synopsisOfHistoriesPhasePoliticalEvent3,
      synopsisOfHistoriesPhasePoliticalEvent4,
      synopsisOfHistoriesPhasePoliticalEvent5,
      synopsisOfHistoriesPhasePoliticalEvent6,
      synopsisOfHistoriesPhasePoliticalEvent7,
      synopsisOfHistoriesPhasePoliticalEvent8,
      synopsisOfHistoriesPhasePoliticalEvent9,
      synopsisOfHistoriesPhasePoliticalEvent10,
      synopsisOfHistoriesPhasePoliticalEvent11,
      synopsisOfHistoriesPhasePoliticalEvent12,
      synopsisOfHistoriesPhasePoliticalEvent13,
      synopsisOfHistoriesPhasePoliticalEvent14,
      synopsisOfHistoriesPhaseEnd,
      barbariansPhaseBegin,
      barbariansPhaseDetermineAdvanceCounts,
      barbariansPhaseAdvanceSouth0,
      barbariansPhaseAdvanceSouth1,
      barbariansPhaseAdvanceSouth2,
      barbariansPhaseAdvanceWest0,
      barbariansPhaseAdvanceWest1,
      barbariansPhaseAdvanceWest2,
      barbariansPhaseAdvanceNorth0,
      barbariansPhaseAdvanceNorth1,
      barbariansPhaseAdvanceNorth2,
      barbariansPhaseAdvanceIberia0,
      barbariansPhaseAdvanceIberia1,
      barbariansPhaseAdvanceIberia2,
      barbariansPhaseAdvancePersia0,
      barbariansPhaseAdvancePersia1,
      barbariansPhaseAdvancePersia2,
      barbariansPhaseAdvanceSyria0,
      barbariansPhaseAdvanceSyria1,
      barbariansPhaseAdvanceSyria2,
      barbariansPhaseEnd,
      byzantineActionPhaseBegin,
      byzantineActionPhaseActions,
      byzantineActionPhaseEnd,
      turnEndPhaseBegin,
      turnEndPhaseBanking,
      turnEndPhaseCancelMilitary,
      turnEndPhaseMuslimColonists,
      turnEndPhaseMuslimColonistsPersia,
      turnEndPhaseMuslimColonistsSyria,
      turnEndPhaseEgyptianApostasy,
      turnEndPhaseThreatToEgypt,
      turnEndPhaseUndefeatedStolos,
      turnEndPhaseMongolRetreat,
      turnEndPhaseTreatiesExpire,
      turnEndPhaseBasileusSocialSkills,
      turnEndPhaseUnflip,
      turnEndPhaseVictory,
      turnEndPhaseEndTurn,
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

  PlayerChoiceInfo? play(PlayerChoice choice) {
    if (_outcome != null) {
        return null;
    }
    _choiceInfo.update(choice);
    try {
      playInSequence();
      return null;
    }
    on PlayerChoiceException {
      return _choiceInfo;
    }
    on GameOverException catch (e) {
      _outcome = (e.result, e.victoryPoints);
      return null;
    }
  }
}

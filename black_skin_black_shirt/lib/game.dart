import 'dart:convert';
import 'dart:math';
import 'package:black_skin_black_shirt/db.dart';

enum Location {
  spaceAddisAbaba,
  spaceDebreMarkos,
  spaceBlueNile,
  spaceGondar,
  spaceAxum,
  spaceAdiQuala,
  spaceDessie,
  spaceAmbaAlagi,
  spaceMakalle,
  spaceAdigrat,
  spaceCoatit,
  spaceDireDawa,
  spaceHarar,
  spaceDaggabur,
  spaceGerlogubi,
  spaceWerder,
  spaceArssi,
  spaceYirgaAlem,
  spaceNegeleBorana,
  spaceGorrahei,
  spaceBaidoa,
  spaceShewa,
  boxSkiesAbove,
  boxGeneva,
  boxImperialTent,
  boxBerlin,
  boxExile,
  boxMussolinisBalcony,
  boxInternationalRecognition,
  boxUnusedDiplomats,
  boxMilitaryEvent,
  boxMilitaryEventDeBono,
  boxMilitaryEventSultanOlolDinle,
  boxMilitaryEventHoareLavalScandal,
  boxMilitaryEventEagleAndCondor,
  boxMilitaryEventRhinelandCrisis,
  boxMilitaryEventBadoglio,
  boxMilitaryEventUnrestInGojjam,
  boxMilitaryEventDubats,
  boxMilitaryEventDejazmatchBalcha,
  boxMilitaryEventSM81Bombers,
  boxMilitaryEventWehibPasha,
  boxMilitaryEventAbebeAregai,
  boxMilitaryEventAntoninBesse,
  boxMilitaryEventProtectorOfIslam,
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
  turn22,
  turn23,
  turn24,
  turn25,
  turn26,
  turn27,
  omnibus0,
  omnibus1,
  omnibus2,
  omnibus3,
  omnibus4,
  omnibus5,
  omnibus6,
  omnibus7,
  omnibus8,
  omnibus9,
  omnibus10,
  omnibus11,
  omnibus12,
  sequenceOfPlayChitDraw,
  sequenceOfPlayTurnStart,
  sequenceOfPlayBerhanenaSelam,
  sequenceOfPlayItalianAvanti,
  sequenceOfPlayChitet,
  sequenceOfPlayEthiopianTekawemu,
  sequenceOfPlayerTurnEnd,
  trayTurnChits,
  trayFascistRule,
  trayDiplomats,
  trayEthiopian,
  trayRas,
  trayItalianArmies,
  trayAoiArmies,
  trayEthiopianUnits,
  trayPartisans,
  trayPlanesBlue,
  trayPlanesYellow,
  trayVarious,
  cupTurnChit,
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
  space,
  pathA,
  pathB,
  pathC,
  pathD,
  calendar,
  omnibus,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.space: [Location.spaceAddisAbaba, Location.spaceShewa],
    LocationType.pathA: [Location.spaceDebreMarkos, Location.spaceAdiQuala],
    LocationType.pathB: [Location.spaceDessie, Location.spaceCoatit],
    LocationType.pathC: [Location.spaceDireDawa, Location.spaceWerder],
    LocationType.pathD: [Location.spaceArssi, Location.spaceBaidoa],
    LocationType.calendar: [Location.turn1, Location.turn27],
    LocationType.omnibus: [Location.omnibus0, Location.omnibus12],
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
      Location.spaceAddisAbaba: 'Addis Ababa',
      Location.spaceDebreMarkos: 'Debre Markos',
      Location.spaceBlueNile: 'Blue Nile',
      Location.spaceGondar: 'Gondar',
      Location.spaceAxum: 'Axum',
      Location.spaceAdiQuala: 'Adi Quala',
      Location.spaceDessie: 'Dessie',
      Location.spaceAmbaAlagi: 'Amba Alagi',
      Location.spaceMakalle: 'Makalle',
      Location.spaceAdigrat: 'Adigrat',
      Location.spaceCoatit: 'Coatit',
      Location.spaceDireDawa: 'Dire Dawa',
      Location.spaceHarar: 'Harar',
      Location.spaceDaggabur: 'Daggabur',
      Location.spaceGerlogubi: 'Gerlogubi',
      Location.spaceWerder: 'Werder',
      Location.spaceArssi: 'Arssi',
      Location.spaceYirgaAlem: 'Yirga Alem',
      Location.spaceNegeleBorana: 'Negele Borana',
      Location.spaceGorrahei: 'Gorrahei',
      Location.spaceBaidoa: 'Baidoa',
      Location.spaceShewa: 'Shewa',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Path {
  pathA,
  pathB,
  pathC,
  pathD,
}

extension PathExtension on Path {
  String get desc {
    const pathDescs = {
      Path.pathA: 'Path A',
      Path.pathB: 'Path B',
      Path.pathC: 'Path C',
      Path.pathD: 'Path D',
    };
    return pathDescs[this]!;
  }
}

enum Piece {
  armyA,
  armyB,
  armyC,
  armyD,
  armyAoiA,
  armyAoiB,
  armyAoiC,
  armyAoiD,
  armyAFlipped,
  armyBFlipped,
  armyCFlipped,
  armyDFlipped,
  armyAoiAFlipped,
  armyAoiBFlipped,
  armyAoiCFlipped,
  armyAoiDFlipped,
  planeBlueA,
  planeBlueB,
  planeBlueC,
  planeBlueD,
  planeYellowA,
  planeYellowB,
  planeYellowC,
  planeYellowD,
  fascistRuleA,
  fascistRuleB,
  fascistRuleC,
  fascistRuleD,
  rasA,
  rasB,
  rasC,
  rasD,
  partisansA,
  partisansB,
  partisansC,
  partisansD,
  minefield,
  blackshirts,
  carroArmato,
  negus,
  planeIea,
  diplomatBritain,
  diplomatFrance,
  diplomatItaly,
  diplomatMexico,
  diplomatUssr,
  diplomatChina,
  diplomatBritainFlipped,
  diplomatFranceFlipped,
  diplomatItalyFlipped,
  diplomatMexicoFlipped,
  diplomatUssrFlipped,
  diplomatChinaFlipped,
  mehalSefari,
  keburZabanya,
  markerSequenceOfPlay,
  markerDollars,
  markerOerlikon,
  markerMilitaryEvent,
  markerDrmP1,
  markerDrmN1,
  markerDuce,
  markerHospital,
  markerEmpireOfEthiopia,
  markerItalianEastAfrica,
  markerBlackLions,
  turnChit1,
  turnChit2,
  turnChit3,
  turnChit4,
  turnChit5,
  turnChit6,
  turnChit7,
  turnChit8,
  turnChit9,
  turnChit10,
  turnChit11,
  turnChit12,
  turnChit13,
  turnChit14,
  turnChit15,
  turnChit16,
  turnChit17,
  turnChit18,
  turnChit19,
  turnChit20,
  turnChit21,
  turnChit22,
  turnChit23,
  turnChit24,
  turnChit25,
  turnChit26,
  turnChit27,
  turnChit28,
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
  army,
  armyFront,
  italianArmyFront,
  aoiArmyFront,
  armyFlipped,
  italianArmyFlipped,
  aoiArmyFlipped,
  plane,
  planeBlue,
  planeYellow,
  fascistRule,
  ras,
  partisans,
  diplomat,
  diplomatFront,
  diplomatFlipped,
  turnChit,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.armyA, Piece.turnChit28],
    PieceType.army: [Piece.armyA, Piece.armyAoiDFlipped],
    PieceType.armyFront: [Piece.armyA, Piece.armyAoiD],
    PieceType.italianArmyFront: [Piece.armyA, Piece.armyD],
    PieceType.aoiArmyFront: [Piece.armyAoiA, Piece.armyAoiD],
    PieceType.armyFlipped: [Piece.armyAFlipped, Piece.armyAoiDFlipped],
    PieceType.italianArmyFlipped: [Piece.armyAFlipped, Piece.armyDFlipped],
    PieceType.aoiArmyFlipped: [Piece.armyAoiAFlipped, Piece.armyAoiDFlipped],
    PieceType.plane: [Piece.planeBlueA, Piece.planeYellowD],
    PieceType.planeBlue: [Piece.planeBlueA, Piece.planeBlueD],
    PieceType.planeYellow: [Piece.planeYellowA, Piece.planeYellowD],
    PieceType.fascistRule: [Piece.fascistRuleA, Piece.fascistRuleD],
    PieceType.ras: [Piece.rasA, Piece.rasD],
    PieceType.partisans: [Piece.partisansA, Piece.partisansD],
    PieceType.diplomat: [Piece.diplomatBritain, Piece.diplomatChinaFlipped],
    PieceType.diplomatFront: [Piece.diplomatBritain, Piece.diplomatChina],
    PieceType.diplomatFlipped: [Piece.diplomatBritainFlipped, Piece.diplomatChinaFlipped],
    PieceType.turnChit: [Piece.turnChit1, Piece.turnChit28],
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

enum CurrentEvent {
  antoninBesseA,
  antoninBesseB,
  antoninBesseC,
  antoninBesseD,
  italianArtillery,
  protectorOfIslamA,
  protectorOfIslamB,
  protectorOfIslamC,
  protectorOfIslamD,
}

enum LimitedEvent {
  fastColumnA,
  fastColumnB,
  fastColumnC,
  fastColumnD,
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
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<bool> _currentEvents = List<bool>.filled(CurrentEvent.values.length, false);
  List<int> _limitedEvents = List<int>.filled(LimitedEvent.values.length, 0);

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
   : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
   , _currentEvents = List<bool>.from(json['currentEvents'])
   , _limitedEvents = List<int>.from(json['limitedEvents'])
   ;

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'currentEvents': _currentEvents,
    'limitedEvents': _limitedEvents,
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.armyA: Piece.armyAFlipped,
      Piece.armyB: Piece.armyBFlipped,
      Piece.armyC: Piece.armyCFlipped,
      Piece.armyD: Piece.armyDFlipped,
      Piece.armyAoiA: Piece.armyAoiAFlipped,
      Piece.armyAoiB: Piece.armyAoiBFlipped,
      Piece.armyAoiC: Piece.armyAoiCFlipped,
      Piece.armyAoiD: Piece.armyAoiDFlipped,
      Piece.armyAFlipped: Piece.armyA,
      Piece.armyBFlipped: Piece.armyB,
      Piece.armyCFlipped: Piece.armyC,
      Piece.armyDFlipped: Piece.armyD,
      Piece.armyAoiAFlipped: Piece.armyAoiA,
      Piece.armyAoiBFlipped: Piece.armyAoiB,
      Piece.armyAoiCFlipped: Piece.armyAoiC,
      Piece.armyAoiDFlipped: Piece.armyAoiD,
      Piece.diplomatBritain: Piece.diplomatBritainFlipped,
      Piece.diplomatFrance: Piece.diplomatFranceFlipped,
      Piece.diplomatItaly: Piece.diplomatItalyFlipped,
      Piece.diplomatMexico: Piece.diplomatMexicoFlipped,
      Piece.diplomatUssr: Piece.diplomatUssrFlipped,
      Piece.diplomatChina: Piece.diplomatChinaFlipped,
      Piece.diplomatBritainFlipped: Piece.diplomatBritain,
      Piece.diplomatFranceFlipped: Piece.diplomatFrance,
      Piece.diplomatItalyFlipped: Piece.diplomatItaly,
      Piece.diplomatMexicoFlipped: Piece.diplomatMexico,
      Piece.diplomatUssrFlipped: Piece.diplomatUssr,
      Piece.diplomatChinaFlipped: Piece.diplomatChina,
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

  // Spaces

  Path spacePath(Location space) {
    for (final path in Path.values) {
      final locationType = pathLocationType(path);
      if (space.isType(locationType)) {
        return path;
      }
    }
    return Path.pathA;
  }

  bool spaceIsBase(Location space) {
    const bases = [
      Location.spaceAdiQuala,
      Location.spaceCoatit,
      Location.spaceWerder,
      Location.spaceBaidoa,
    ];
    return bases.contains(space);
  }

  bool spaceIsPlayerControlled(Location space) {
    final path = spacePath(space);
    final army = pathArmy(path);
    final armySpace = pieceLocation(army);
    return space.index < armySpace.index;
  }

  // Paths

  LocationType pathLocationType(Path path) {
    const pathLocationTypes = {
      Path.pathA: LocationType.pathA,
      Path.pathB: LocationType.pathB,
      Path.pathC: LocationType.pathC,
      Path.pathD: LocationType.pathD,
    };
    return pathLocationTypes[path]!;
  }

  Location pathPrevSpace(Path path, Location space) {
    final locationType = pathLocationType(path);
    if (space.index == locationType.firstIndex) {
      return Location.spaceAddisAbaba;
    }
    return Location.values[space.index - 1];
  }

  Location? pathNextSpace(Path path, Location space) {
    final locationType = pathLocationType(path);
    if (space.index ==locationType.lastIndex) {
      return null;
    }
    return Location.values[space.index + 1];
  }

  Location pathMilitaryBase(Path path) {
    final locationType = pathLocationType(path);
    return Location.values[locationType.lastIndex - 1];
  }

  Piece pathItalianArmy(Path path) {
    return Piece.values[PieceType.italianArmyFront.firstIndex + path.index];
  }

  Piece pathAoiArmy(Path path) {
    return Piece.values[PieceType.aoiArmyFront.firstIndex + path.index];
  }

  Piece pathFlippedItalianArmy(Path path) {
    return Piece.values[PieceType.italianArmyFlipped.firstIndex + path.index];
  }

  Piece pathFlippedAoiArmy(Path path) {
    return Piece.values[PieceType.aoiArmyFlipped.firstIndex + path.index];
  }

  Piece pathArmy(Path path) {
    for (final army in [pathItalianArmy(path), pathAoiArmy(path), pathFlippedItalianArmy(path), pathFlippedAoiArmy(path)]) {
      final location = pieceLocation(army);
      if (location.isType(LocationType.space)) {
        return army;
      }
    }
    return Piece.markerDollars;
  }

  Piece pathFascistRule(Path path) {
    return Piece.values[PieceType.fascistRule.firstIndex + path.index];
  }

  // Turns

  int get currentTurn {
    int maxTurn = 1;
    for (final turnChit in PieceType.turnChit.pieces) {
      final location = pieceLocation(turnChit);
      if (location.isType(LocationType.calendar)) {
        final turn = location.index - LocationType.calendar.firstIndex;
        if (turn > maxTurn) {
          maxTurn = turn;
        }
      }
    }
    return maxTurn;
  }

  String turnName(int turn) {
    const turnNames = [
      'Early October 1935',
      'Late October 1935',
      'November 1935',
      'December 1935',
      'January 1936',
      'February 1936',
      'Early March 1936',
      'Late March 1936',
      'Early April 1936',
      'Late April 1936',
      'Early May 1936',
      'Late May 1936',
      'Early June 1936',
      'Late June 1936',
      'July 1936',
      'August 1936',
      'September 1936',
      'Early October 1936',
      'Late October 1936',
      'Early November 1936',
      'Late November 1936',
      'December 1936',
      'January 1937',
      'February 1937',
      'March 1937',
      'April 1937',
      'May 1937',
    ];
    return turnNames[turn - 1];
  }

  Location calendarBox(int turn) {
    return Location.values[LocationType.calendar.firstIndex + turn - 1];
  }

  Location get currentTurnCalendarBox {
    return calendarBox(currentTurn);
  }

  Piece get currentTurnChit {
    return pieceInLocation(PieceType.turnChit, currentTurnCalendarBox)!;
  }

  // Diplomats

  int diplomatStrength(Piece diplomat) {
    const diplomatStrengths = {
      Piece.diplomatBritain: 2,
      Piece.diplomatFrance: 3,
      Piece.diplomatItaly: 4,
      Piece.diplomatMexico: 1,
      Piece.diplomatUssr: 0,
      Piece.diplomatChina: 0,
    };
    return diplomatStrengths[diplomat]!;
  }

  List<Piece> strongestDiplomats(List<Piece> diplomats) {
    var strongest = <Piece>[];
    int strongestStrength = -1;
    for (final diplomat in diplomats) {
      int strength = diplomatStrength(diplomat);
      if (strength > strongestStrength) {
        strongest = [diplomat];
        strongestStrength = strength;
      } else if (strength == strongestStrength) {
        strongest.add(diplomat);
      }
    }
    return strongest;
  }

  List<Piece> weakestDiplomats(List<Piece> diplomats) {
    var weakest = <Piece>[];
    int weakestStrength = 100;
    for (final diplomat in diplomats) {
      int strength = diplomatStrength(diplomat);
      if (strength < weakestStrength) {
        weakest = [diplomat];
        weakestStrength = strength;
      } else if (strength == weakestStrength) {
        weakest.add(diplomat);
      }
    }
    return weakest;
  }

  // Omnibus

  Location omnibusBox(int value) {
    return Location.values[Location.omnibus0.index + value];
  }

  // Dollars

  int get dollars {
    final location = pieceLocation(Piece.markerDollars);
    return location.index - Location.omnibus0.index;
  }

  void adjustDollars(int delta) {
    int newValue = dollars + delta;
    if (newValue > 12) {
      newValue = 12;
    } else if (newValue < 0) {
      newValue = 0;
    }
    setPieceLocation(Piece.markerDollars, omnibusBox(newValue));
  }

  // Oerlikon

  int get oerlikon {
    final location = pieceLocation(Piece.markerOerlikon);
    return location.index - Location.omnibus0.index;
  }

  void adjustOerlikon(int delta) {
    int newValue = oerlikon + delta;
    if (newValue > 12) {
      newValue = 12;
    } else if (newValue < 0) {
      newValue = 0;
    }
    setPieceLocation(Piece.markerOerlikon, omnibusBox(newValue));
  }

  // Events

  bool currentEventIsCurrent(CurrentEvent event) {
    return _currentEvents[event.index];
  }

  void currentEventOccurred(CurrentEvent event) {
    _currentEvents[event.index] = true;
  }

  void clearCurrentEvents() {
    _currentEvents.fillRange(0, CurrentEvent.values.length, false);
  }

  int limitedEventCount(LimitedEvent event) {
    return _limitedEvents[event.index];
  }

  void limitedEventOccurred(LimitedEvent event) {
    _limitedEvents[event.index] += 1;
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

  factory GameState.setupTray() {

    var state = GameState();

    state.setupPieceTypes([
      (PieceType.turnChit, Location.trayTurnChits),
      (PieceType.fascistRule, Location.trayFascistRule),
      (PieceType.diplomat, Location.trayDiplomats),
      (PieceType.ras, Location.trayRas),
      (PieceType.partisans, Location.trayPartisans),
      (PieceType.italianArmyFront, Location.trayItalianArmies),
      (PieceType.planeBlue, Location.trayPlanesBlue),
      (PieceType.planeYellow, Location.trayPlanesYellow),
      (PieceType.aoiArmyFront, Location.trayAoiArmies),
    ]);

    state.setupPieces([
      (Piece.markerSequenceOfPlay, Location.trayTurnChits),
      (Piece.mehalSefari, Location.trayEthiopian),
      (Piece.keburZabanya, Location.trayEthiopian),
      (Piece.minefield, Location.trayPartisans),
      (Piece.blackshirts, Location.trayItalianArmies),
      (Piece.carroArmato, Location.trayItalianArmies),
      (Piece.negus, Location.trayEthiopianUnits),
      (Piece.planeIea, Location.trayEthiopianUnits),
      (Piece.markerEmpireOfEthiopia, Location.trayEthiopianUnits),
      (Piece.markerDollars, Location.trayEthiopianUnits),
      (Piece.markerOerlikon, Location.trayEthiopianUnits),
      (Piece.markerMilitaryEvent, Location.trayVarious),
      (Piece.markerDrmP1, Location.trayVarious),
      (Piece.markerDrmN1, Location.trayVarious),
      (Piece.markerDuce, Location.trayVarious),
      (Piece.markerHospital, Location.trayVarious),
      (Piece.markerItalianEastAfrica, Location.trayVarious),
      (Piece.markerBlackLions, Location.trayVarious),
    ]);

    return state;
  }

  factory GameState.setupStandard() {

    var state = GameState.setupTray();

    state.setupPieceTypes([
      (PieceType.turnChit, Location.cupTurnChit),
      (PieceType.ras, Location.boxImperialTent),
      (PieceType.diplomat, Location.boxUnusedDiplomats),
    ]);

    state.setupPieces([
      (Piece.negus, Location.boxImperialTent),
      (Piece.planeIea, Location.boxImperialTent),
      (Piece.planeBlueC, Location.boxSkiesAbove),
      (Piece.planeBlueD, Location.boxSkiesAbove),
      (Piece.fascistRuleA, Location.spaceAdiQuala),
      (Piece.planeBlueA, Location.spaceAdiQuala),
      (Piece.armyA, Location.spaceAdiQuala),
      (Piece.fascistRuleB, Location.spaceCoatit),
      (Piece.planeBlueB, Location.spaceCoatit),
      (Piece.armyB, Location.spaceCoatit),
      (Piece.fascistRuleC, Location.spaceWerder),
      (Piece.armyC, Location.spaceWerder),
      (Piece.fascistRuleD, Location.spaceBaidoa),
      (Piece.armyD, Location.spaceBaidoa),
      (Piece.diplomatItaly, Location.boxGeneva),
      (Piece.markerEmpireOfEthiopia, Location.boxInternationalRecognition),
      (Piece.markerDollars, Location.omnibus1),
      (Piece.markerOerlikon, Location.omnibus3),
      (Piece.keburZabanya, Location.omnibus2),
      (Piece.mehalSefari, Location.omnibus4),
      (Piece.markerMilitaryEvent, Location.boxMilitaryEvent),
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
  berhanenaSelam,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateBerhanenaSelam extends PhaseState {
  int? total;

  PhaseStateBerhanenaSelam();

  PhaseStateBerhanenaSelam.fromJson(Map<String, dynamic> json)
    : total = json['total'] as int?
    ;

  @override
  Map<String, dynamic> toJson() => {
    'total': total,
  };

  @override
  Phase get phase {
    return Phase.berhanenaSelam;
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
  Random _random = Random();
  final int _gameId;

  Game(this._gameId, this._scenario, this._options, this._state, this._random)
    : _choiceInfo = PlayerChoiceInfo();

  Game.saved(this._gameId, this._scenario, this._options, this._state, this._step, this._subStep, this._log, Map<String, dynamic> gameStateJson) {
    _gameStateFromJson(gameStateJson);
  }

  void _gameStateFromJson(Map<String, dynamic> json) {
    _phaseState = null;
    final phaseIndex = json['phase'] as int?;
    if (phaseIndex != null) {
      final phaseStateJson = json['phaseState'];
      switch (Phase.values[phaseIndex]) {
      case Phase.berhanenaSelam:
        _phaseState = PhaseStateBerhanenaSelam.fromJson(phaseStateJson);
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
      _step, _subStep,
      _state.turnName(_state.currentTurn),
      _log);
  }

  Future<void> saveCurrentState() async {
    await GameDatabase.instance.setGameState(
      _gameId,
      jsonEncode(_state.toJson()),
      _step, _subStep,
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

  // Logging Functions

  void adjustDollars(int delta) {
    _state.adjustDollars(delta);
    if (delta > 0) {
      logLine('> MT +$delta → ${_state.dollars}');
    } else if (delta < 0) {
      logLine('> MT $delta → ${_state.dollars}');
    }
  }

  void adjustOerlikon(int delta) {
    _state.adjustOerlikon(delta);
    if (delta > 0) {
      logLine('> Oerlikon +$delta → ${_state.oerlikon}');
    } else if (delta < 0) {
      logLine('> Oerlikon $delta → ${_state.oerlikon}');
    }
  }

  // High-Level Functions

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;

    // TODO logging
  }

  // High Level Functions

  void influenceDiplomat(Piece diplomat) {
    int die = rollD6();
    int modifiers = 0;
    final militaryEventLocation = _state.pieceLocation(Piece.markerMilitaryEvent);
    if (militaryEventLocation == Location.boxMilitaryEventHoareLavalScandal) {
      logLine('> Hoare–Laval Scandal: +1');
      modifiers += 1;
    } else if (militaryEventLocation == Location.boxMilitaryEventRhinelandCrisis) {
      logLine('> Rhineland Crisis: -1');
      modifiers -= 1;
    }
    int strength = _state.diplomatStrength(diplomat);
    int total = die + modifiers;
    if (total > strength) {
      logLine('> ${diplomat.desc} is persuaded to abandon a pro‐Italy stance.');
      _state.setPieceLocation(diplomat, Location.boxUnusedDiplomats);
    } else {
      logLine('> ${diplomat.desc} continues to side with Italy.');
    }
  }

  // Sequence Helpers

  // Sequence of Play

  void turnBegin() {
    logLine('# ${_state.turnName(_state.currentTurn)}');
    _state.setPieceLocation(Piece.markerSequenceOfPlay, Location.sequenceOfPlayTurnStart);
  }

  void drawChitPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Draw Chit Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Draw Chit Phase');
  }

  void drawChitPhaseDrawChit() {
    logLine('### Draw Chit');
    final chit = randPiece(_state.piecesInLocation(PieceType.turnChit, Location.cupTurnChit))!;
    logLine('> ${chit.desc}');
    _state.setPieceLocation(chit, _state.currentTurnCalendarBox);
  }
 
  void turnStartPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Turn Start Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Turn Start Phase');
  }

  void turnStartPhaseDeployUnits() {
    final pieces = <Piece>[];
    for (final piece in _state.piecesInLocation(PieceType.all, _state.currentTurnCalendarBox)) {
      if (!piece.isType(PieceType.turnChit)) {
        pieces.add(piece);
      }
    }
    if (pieces.isEmpty) {
      return;
    }
    logLine('> Deploy Units');
    for (final piece in pieces) {
      if (piece == Piece.negus || piece.isType(PieceType.ras)) {
        logLine('> ${piece.desc} deploys to ${Location.boxImperialTent}.');
        _state.setPieceLocation(piece, Location.boxImperialTent);
      }
    }
  }

  void event75thCongress() {
    logLine('### 75th Congress');
    int die = rollD6();
    if (die == 6) {
      logLine('> US Congress decides to help Ethiopia.');
      adjustDollars(_state.piecesInLocationCount(PieceType.diplomat, Location.boxUnusedDiplomats));
    } else {
      logLine('> US Congress decides against helping Ethiopia.');
    }
  }

  void eventAidVote() {
    if (_state.pieceLocation(Piece.markerEmpireOfEthiopia) != Location.boxInternationalRecognition) {
      return;
    }
    logLine('### Aid Vote');
    logLine('> League of Nations defies Italy and helps Ethiopia.');
    adjustDollars(_state.piecesInLocationCount(PieceType.diplomat, Location.boxUnusedDiplomats));
  }

  void eventBritishElection() {
    logLine('### British Election');
    int die = rollD6();
    int count = 0;
    switch (die) {
    case 1:
      logLine('> Labour triumph.');
      count = -2;
    case 2:
      logLine('> Narrow Labour victory.');
      count = -1;
    case 3:
      logLine('> Liberal resurgence.');
      count = 0;
    case 4:
      logLine('> Baldwin’s National Coalition survives.');
      count = 1;
    case 5:
      logLine('> National Coalition victory.');
      count = 2;
    case 6:
      logLine('> Tory landslide.');
      count = 3;
    }
    if (count < 0) {
      for (int i = 0; i > count; --i) {
        final diplomats = _state.weakestDiplomats(_state.piecesInLocation(PieceType.diplomatFront, Location.boxGeneva));
        if (diplomats.isEmpty) {
          return;
        }
        final diplomat = randPiece(diplomats)!;
        logLine('> ${diplomat.desc} returns from Geneva.');
        final flippedDiplomat = _state.pieceFlipSide(diplomat)!;
        _state.setPieceLocation(flippedDiplomat, Location.boxUnusedDiplomats);
      }
    } else if (count > 0) {
      for (int i = 0; i < count; ++i) {
        final diplomats = _state.strongestDiplomats(_state.piecesInLocation(PieceType.diplomatFront, Location.boxUnusedDiplomats));
        if (diplomats.isEmpty) {
          return;
        }
        final diplomat = randPiece(diplomats)!;
        logLine('> ${diplomat.desc} heads to Geneva.');
        _state.setPieceLocation(diplomat, Location.boxGeneva);
      }
    }
  }

  void eventFrenchElection() {
    logLine('### French Election');
    int die = rollD6();
    int count = 0;
    switch (die) {
    case 1:
      logLine('> Communists in government.');
      count = -2;
    case 2:
      logLine('> Popular Front landslide.');
      count = -1;
    case 3:
      logLine('> Popular Front victory.');
      count = 0;
    case 4:
      logLine('> Divided National Assembly.');
      count = 1;
    case 5:
      logLine('> Republican Federation victory.');
      count = 2;
    case 6:
      logLine('> Croix‐de‐Feu in government.');
      count = 3;
    }
    if (count < 0) {
      for (int i = 0; i > count; --i) {
        final diplomats = _state.weakestDiplomats(_state.piecesInLocation(PieceType.diplomatFront, Location.boxGeneva));
        if (diplomats.isEmpty) {
          return;
        }
        final diplomat = randPiece(diplomats)!;
        logLine('> ${diplomat.desc} returns from Geneva.');
        final flippedDiplomat = _state.pieceFlipSide(diplomat)!;
        _state.setPieceLocation(flippedDiplomat, Location.boxUnusedDiplomats);
      }
    } else if (count > 0) {
      for (int i = 0; i < count; ++i) {
        final diplomats = _state.strongestDiplomats(_state.piecesInLocation(PieceType.diplomatFront, Location.boxUnusedDiplomats));
        if (diplomats.isEmpty) {
          return;
        }
        final diplomat = randPiece(diplomats)!;
        logLine('> ${diplomat.desc} heads to Geneva.');
        _state.setPieceLocation(diplomat, Location.boxGeneva);
      }
    }
  }

  void eventGuadalajara() {
    logLine('### Guadalajara');
    logLine('> Italy diverts air force units to fight the war in Spain.');
    for (final yellowPlane in PieceType.planeYellow.pieces) {
      final bluePlane = Piece.values[PieceType.planeBlue.firstIndex + yellowPlane.index - PieceType.planeYellow.index];
      final location = _state.pieceLocation(yellowPlane);
      _state.setPieceLocation(bluePlane, location);
      _state.setPieceLocation(yellowPlane, Location.discarded);
    }
  }

  void eventRomeBerlinAxis() {
    if (_state.pieceLocation(Piece.markerEmpireOfEthiopia) != Location.boxInternationalRecognition) {
      return;
    }
    logLine('### Rome–Berlin Axis');
    logLine('> Mussolini and Hitler sign an anti‐Communist Pact.');
    _state.setPieceLocation(Piece.diplomatItaly, Location.boxBerlin);
  }

  void eventSanctionsVote() {
    if (_state.pieceLocation(Piece.markerEmpireOfEthiopia) != Location.boxInternationalRecognition) {
      return;
    }
    logLine('### Sanctions Vote');
    int die = rollD6();
    if (die == 6) {
      logLine('> League of Nations imposes serious sanctions on Italy.');
      adjustOerlikon(3);
      _state.setPieceLocation(Piece.carroArmato, Location.discarded);
    }
  }

  void eventYekatit12() {
    if (_state.pieceLocation(Piece.markerItalianEastAfrica) != Location.boxInternationalRecognition) {
      return;
    }
    logLine('### Yekatit 12');
    logLine('> Resistance in Addis begins in earnest.');
    for (final path in Path.values) {
      final fascistRule = _state.pathFascistRule(path);
      final space = _state.pieceLocation(fascistRule);
      final nextSpace = _state.pathNextSpace(path, space);
      if (nextSpace != null) {
        logLine('> Fascist Rule is pushed back to ${nextSpace.desc}.');
        _state.setPieceLocation(fascistRule, nextSpace);
      }
    }
  }

  void turnStartPhaseEvent() {
    final eventHandlers = {
      3: eventBritishElection,
      4: eventSanctionsVote,
      7: eventSanctionsVote,
      11: eventFrenchElection,
      15: eventAidVote,
      19: eventRomeBerlinAxis,
      23: event75thCongress,
      24: eventYekatit12,
      25: eventGuadalajara,
    };
    final eventHandler = eventHandlers[_state.currentTurn];
    if (eventHandler != null) {
      eventHandler();
    }
  }

  void berhanenaSelamPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Berhanena Selam Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Berhanena Selam Phase');
    _phaseState = PhaseStateBerhanenaSelam();
  }

  void berhanenaSelamPhaseRoll() {
    logLine('### Roll');
    final phaseState = _phaseState as PhaseStateBerhanenaSelam;
    int die = rollD6();
    int total = _state.currentTurn + die;
    phaseState.total = total;
  }

  void berhanenaSelamPhaseExileEmperor() {
    if (_state.pieceLocation(Piece.negus) != Location.boxImperialTent) {
      return;
    }
    if (!_state.spaceIsPlayerControlled(Location.spaceDireDawa)) {
      return;
    }
    if (choicesEmpty()) {
      setPrompt('Exile the Emperor?');
      choiceChoosable(Choice.yes, true);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    if (checkChoiceAndClear(Choice.no)) {
      return;
    }
    logLine('### Emperor Haile Selassie enters exile in England');
    for (final diplomat in _state.piecesInLocation(PieceType.diplomatFront, Location.boxGeneva)) {
      logLine('> Influence ${diplomat.desc}.');
      influenceDiplomat(diplomat);
    }
    _state.setPieceLocation(Piece.negus, Location.boxExile);
    clearChoices();
  }

  // Military Events

  void militaryEventAbebeAregai() {
    logLine('### Police Chief Abebe Aregai joins the Ärbenyoch');
    logLine('> +1 DRM to all attacks on A.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventAbebeAregai);
  }

  void militaryEventAntoninBesse() {
    logLine('### French businessman Antonin Besse smuggles arms and money to the resistance');
    int die = rollD6();
    String letter = '';
    CurrentEvent? event;
    switch (die) {
    case 1:
      event = CurrentEvent.antoninBesseA;
      letter = 'A';
    case 2:
    case 6:
      event = CurrentEvent.antoninBesseB;
      letter = 'B';
    case 3:
    case 5:
      event = CurrentEvent.antoninBesseC;
      letter = 'C';
    case 4:
      event = CurrentEvent.antoninBesseD;
      letter = 'D';
    }
    logLine('> +1 DRM to all attacks on $letter.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventAntoninBesse);
    _state.currentEventOccurred(event!);
  }

  void militaryEventBadoglio() {
    logLine('### Pietro Badoglio made C‐in‐C of Italian forces');
    logLine('> -1 DRM from all attacks on B.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventBadoglio);
  }

  void militaryEventDeBono() {
    logLine('### Emilio de Bono leads Italian forces');
    logLine('> +1 DRM to all attacks on B.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventDeBono);
  }

  void militaryEventDejazBalcha() {
    logLine('### War hero dejazmatch Balcha Safo supports the Ethiopian cause');
    logLine('> +1 DRM to all attacks on D.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventDejazmatchBalcha);
  }

  void militaryEventDubats() {
    logLine('### Somali troops assist Italy');
    logLine('> -1 DRM from all attacks on D.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventDubats);
  }

  void militaryEventEagleAndCondor() {
    logLine('### Ethiopian air force');
    logLine('> +1 DRM to all attacks on E.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventEagleAndCondor);
  }

  void militaryEventHoareLaval() {
    logLine('### Hoare–Laval Scandal');
    logLine('> +1 DRM to all attacks on F.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventHoareLavalScandal);
  }

  void militaryEventProtectorOfIslam() {
    logLine('### Mussolini declares himself “Protector of Islam”');
    int die = rollD6();
    String letter = '';
    CurrentEvent? event;
    switch (die) {
    case 1:
      event = CurrentEvent.protectorOfIslamA;
      letter = 'A';
    case 2:
      event = CurrentEvent.protectorOfIslamB;
      letter = 'B';
    case 3:
    case 5:
      event = CurrentEvent.protectorOfIslamC;
      letter = 'C';
    case 4:
    case 6:
      event = CurrentEvent.protectorOfIslamD;
      letter = 'D';
    }
    logLine('> -1 DRM from all attacks on $letter.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventProtectorOfIslam);
    _state.currentEventOccurred(event!);
  }

  void militaryEventRhinelandCrisis() {
    logLine('### Rhineland Crisis');
    logLine('> -1 DRM from all attacks on F.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventRhinelandCrisis);
  }

  void militaryEventSM81() {
    logLine('### SM‐81 Bombers');
    logLine('> -1 DRM from all attacks on E.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventSM81Bombers);
  }

  void militaryEventSultanOlolDinle() {
    logLine('### Somali leader Sultan sides with Italy');
    logLine('> -1 DRM from all attacks on C.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventSultanOlolDinle);
  }

  void militaryEventUnrestInGojjam() {
    logLine('### Local peasants refuse to feed the Ehtiopian Army');
    logLine('> -1 DRM from all attacks on A.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventUnrestInGojjam);
  }

  void militaryEventWehibPasha() {
    logLine('### Ex‐Ottoman general Wehib Pasha builds defensive works');
    logLine('> +1 DRM to all attacks on C.');
    _state.setPieceLocation(Piece.markerMilitaryEvent, Location.boxMilitaryEventWehibPasha);
  }

  void berhanenaSelamPhaseMilitaryEvent() {
    final militaryEvents = {
      2: militaryEventDeBono,
      3: militaryEventDeBono,
      4: militaryEventDeBono,
      5: militaryEventSultanOlolDinle,
      6: militaryEventSultanOlolDinle,
      7: militaryEventHoareLaval,
      8: militaryEventHoareLaval,
      9: militaryEventDubats,
      10: militaryEventDubats,
      11: militaryEventEagleAndCondor,
      12: militaryEventEagleAndCondor,
      13: militaryEventUnrestInGojjam,
      14: militaryEventUnrestInGojjam,
      15: militaryEventRhinelandCrisis,
      16: militaryEventRhinelandCrisis,
      17: militaryEventBadoglio,
      18: militaryEventBadoglio,
      19: militaryEventDejazBalcha,
      20: militaryEventDejazBalcha,
      21: militaryEventSM81,
      22: militaryEventSM81,
      23: militaryEventWehibPasha,
      24: militaryEventWehibPasha,
      25: militaryEventAbebeAregai,
      26: militaryEventAbebeAregai,
      27: militaryEventAntoninBesse,
      28: militaryEventAntoninBesse,
      29: militaryEventProtectorOfIslam,
      30: militaryEventProtectorOfIslam,
    };

    final phaseState = _phaseState as PhaseStateBerhanenaSelam;
    final militaryEventHandler = militaryEvents[phaseState.total!];
    if (militaryEventHandler != null) {
      militaryEventHandler();
    }
  }

  // Political Events

  void politicalEventAbunaFasting() {
    int count = 0;
    for (final path in Path.values) {
      final army = _state.pathArmy(path);
      final space = _state.pieceLocation(army);
      if (_state.spaceIsBase(space)) {
        count += 1;
      }
    }
    if (count == 0) {
      return;
    }
    logLine('### Abuna Fasting');
    logLine('> The Abuna calls for a nationwide fast.');
    adjustDollars(count);
  }

  void politicalEventArbenyoch() {
    final partisans = _state.piecesInLocation(PieceType.partisans, Location.trayPartisans);
    if (partisans.isEmpty) {
      return;
    }
    logLine('### Ärbenyoch');
    logLine('> Partisans support the Ethiopian cause.');
    for (final partisan in partisans) {
      _state.setPieceLocation(partisan, Location.boxImperialTent);
    }
  }

  void politicalEventAsosaGold() {
    int count = 0;
    for (final army in PieceType.italianArmyFront.pieces) {
      final location = _state.pieceLocation(army);
      if (location.isType(LocationType.space)) {
        count += 1;
      }
    }
    if (count == 0) {
      return;
    }
    logLine('### Asosa Gold');
    logLine('> Streams of Asosa still under Ethiopian control.');
    adjustDollars(count);
  }

  void politicalEventBlackChurches() {
    logLine('### Black Churches');
    logLine('> Black churches in America raise cash for Ethiopia.');
    adjustDollars(1);
  }

  void politicalEventBlackLions() {
    if (_state.piecesInLocationCount(PieceType.ras, Location.boxImperialTent) == 0) {
      return;
    }
    logLine('### Black Lions');
    logLine('> Black Lions cadets available.');
    _state.setPieceLocation(Piece.markerBlackLions, Location.spaceAddisAbaba);
  }

  void politicalEventBlackshirts() {
    if (_subStep == 0) {
      logLine('### Blackshirts');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select Army for Blackshirts to accompany');
        for (final path in Path.values) {
          final army = _state.pathArmy(path);
          pieceChoosable(army);
        }
        throw PlayerChoiceException();
      }
      final army = selectedPiece()!;
      final space = _state.pieceLocation(army);
      logLine('> Blackshirts accompany ${army.desc}.');
      _state.setPieceLocation(Piece.blackshirts, space);
      clearChoices();
    }
  }

  void politicalEventDaggaburMinefield() {
    if (_state.pieceLocation(Piece.minefield) == Location.spaceDaggabur) {
      return;
    }
    if (!_state.spaceIsPlayerControlled(Location.spaceDaggabur)) {
      return;
    }
    logLine('### Daggabur Minefield');
    logLine('> +1 DRM to all attacks on Daggabur');
    _state.setPieceLocation(Piece.minefield, Location.spaceDaggabur);
  }

  void politicalEventDuce() {
    if (_state.pieceLocation(Piece.markerDuce) == Location.boxMussolinisBalcony) {
      return;
    }
    logLine('### Duce!');
    logLine('> Mussolini takes command.');
    for (final bluePlane in PieceType.planeBlue.pieces) {
      final yellowPlane = Piece.values[PieceType.planeYellow.firstIndex + bluePlane.index - PieceType.planeBlue.index];
      final location = _state.pieceLocation(bluePlane);
      _state.setPieceLocation(yellowPlane, location);
      _state.setPieceLocation(bluePlane, Location.discarded);
    }
  }

  void politicalEventEritreanMutiny() {
    if (_subStep == 0) {
      bool noArmies = true;
      for (final path in Path.values) {
        final army = _state.pathItalianArmy(path);
        final location = _state.pieceLocation(army);
        if (location.isType(LocationType.space)) {
          noArmies = false;
          break;
        }
      }
      if (noArmies) {
        return;
      }
      logLine('### Eritrean Mutiny');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select Italian Army to suffer mutiny.');
        for (final path in Path.values) {
          final army = _state.pathItalianArmy(path);
          final location = _state.pieceLocation(army);
          if (location.isType(LocationType.space)) {
            pieceChoosable(army);
          }
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      final army = selectedPiece()!;
      logLine('> Eritrean Mutiny affects ${army.desc}.');
      _state.flipPiece(army);
      clearChoices();
    }
  }

  void fastColumn(Path path) {
    // TODO
  }

  void politicalEventFastColumnA() {
    if (_state.limitedEventCount(LimitedEvent.fastColumnA) > 0) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Fast Column on Path A');
      _state.limitedEventOccurred(LimitedEvent.fastColumnA);
      _subStep = 1;
    }
    if (_subStep == 1) {
      fastColumn(Path.pathA);
    }
  }

  void politicalEventFastColumnB() {
    if (_state.limitedEventCount(LimitedEvent.fastColumnB) > 0) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Fast Column on Path B');
      _state.limitedEventOccurred(LimitedEvent.fastColumnB);
      _subStep = 1;
    }
    if (_subStep == 1) {
      fastColumn(Path.pathB);
    }
  }

  void politicalEventFastColumnC() {
    if (_state.limitedEventCount(LimitedEvent.fastColumnC) > 0) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Fast Column on Path C');
      _state.limitedEventOccurred(LimitedEvent.fastColumnC);
      _subStep = 1;
    }
    if (_subStep == 1) {
      fastColumn(Path.pathC);
    }
  }

  void politicalEventFastColumnD() {
    if (_state.limitedEventCount(LimitedEvent.fastColumnD) > 0) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Fast Column on Path D');
      _state.limitedEventOccurred(LimitedEvent.fastColumnD);
      _subStep = 1;
    }
    if (_subStep == 1) {
      fastColumn(Path.pathD);
    }
  }

  void politicalEventGentlemensAgreement() {
    logLine('### Gentlemen’s Agreement');
    if (_state.pieceLocation(Piece.markerEmpireOfEthiopia) == Location.boxInternationalRecognition) {
      logLine('> Allies send aid to Ethiopia.');
      int die = rollD6();
      adjustDollars(die);
    } else {
      logLine('> Britain and France provide logistical support to Italy.');
      for (final diplomat in _state.piecesInLocation(PieceType.diplomat, Location.boxUnusedDiplomats)) {
        _state.setPieceLocation(diplomat, Location.boxGeneva);
      }
    }
  }

  void politicalEventItalianArtillery() {
    logLine('### Italian Artillery');
    logLine('> ???');
    _state.currentEventOccurred(CurrentEvent.italianArtillery);
  }

  void politicalEventMassacre() {
    Path? path;
    if (_subStep == 0) {
      logLine('### Massacre');
      int die = rollD6();
      if (die <= 4) {
        path = Path.values[die - 1];
        _subStep = 2;
      } else {
        _subStep = 1;
      }
    }
    if (_subStep == 2) {
      final fascistRule = _state.pathFascistRule(path!);
      final space = _state.pieceLocation(fascistRule);
      final nextSpace = _state.pathNextSpace(path, space);
      if (nextSpace == null) {
        logLine('> Fascist Rule is already restricted to ${space.desc}.');
      } else {
        logLine('> Fascist Rule becomes ineffective in ${space.desc}.');
        _state.setPieceLocation(fascistRule, nextSpace);
      }
    }
  }

  void politicalEventNevilleChamberlain() {

  }

  void politicalEventRadioSpoofing() {

  }

  void politicalEventRasGugsaDefects() {

  }

  void politicalEventRedCross() {

  }

  void politicalEventRumours() {

  }

  void politicalEventSlaveryAbolished() {

  }

  void politicalEventSpanishCivilWar() {

  }

  void politicalEventTanks() {

  }

  void politicalEventWesternGallaConfederation() {

  }

  void politicalEventYayoOfSardo() {

  }

  void politicalEventYugoslavia() {

  }

  void berhanenaSelamPhasePoliticalEvent(int index) {
    final politicalEvents = {
      2: [politicalEventTanks],
      3: [politicalEventRasGugsaDefects],
      4: [politicalEventRasGugsaDefects],
      5: [politicalEventFastColumnD, politicalEventDaggaburMinefield, politicalEventRedCross],
      6: [politicalEventFastColumnD, politicalEventDaggaburMinefield, politicalEventRedCross],
      7: [politicalEventBlackChurches, politicalEventItalianArtillery, politicalEventRedCross],
      8: [politicalEventBlackChurches, politicalEventItalianArtillery, politicalEventRedCross],
      9: [politicalEventFastColumnC, politicalEventArbenyoch, politicalEventEritreanMutiny, politicalEventRadioSpoofing, politicalEventRedCross, politicalEventDuce],
      10: [politicalEventFastColumnC, politicalEventArbenyoch, politicalEventEritreanMutiny, politicalEventRadioSpoofing, politicalEventRedCross, politicalEventDuce],
      11: [politicalEventArbenyoch, politicalEventRumours, politicalEventTanks, politicalEventYayoOfSardo, politicalEventDuce],
      12: [politicalEventArbenyoch, politicalEventRumours, politicalEventTanks, politicalEventYayoOfSardo, politicalEventDuce],
      13: [politicalEventFastColumnB, politicalEventArbenyoch, politicalEventAbunaFasting, politicalEventDuce],
      14: [politicalEventFastColumnB, politicalEventArbenyoch, politicalEventAbunaFasting, politicalEventDuce],
      15: [politicalEventBlackChurches, politicalEventBlackshirts, politicalEventTanks],
      16: [politicalEventBlackChurches, politicalEventBlackshirts, politicalEventTanks],
      17: [politicalEventFastColumnA, politicalEventBlackLions, politicalEventWesternGallaConfederation, politicalEventYugoslavia],
      18: [politicalEventFastColumnA, politicalEventBlackLions, politicalEventWesternGallaConfederation, politicalEventYugoslavia],
      19: [politicalEventAsosaGold, politicalEventBlackLions, politicalEventYayoOfSardo],
      20: [politicalEventAsosaGold, politicalEventBlackLions, politicalEventYayoOfSardo],
      21: [politicalEventBlackshirts, politicalEventRadioSpoofing, politicalEventRumours, politicalEventSlaveryAbolished, politicalEventTanks],
      22: [politicalEventBlackshirts, politicalEventRadioSpoofing, politicalEventRumours, politicalEventSlaveryAbolished, politicalEventTanks],
      23: [politicalEventBlackChurches, politicalEventMassacre, politicalEventWesternGallaConfederation],
      24: [politicalEventBlackChurches, politicalEventMassacre, politicalEventWesternGallaConfederation],
      25: [politicalEventSpanishCivilWar],
      26: [politicalEventSpanishCivilWar],
      27: [politicalEventGentlemensAgreement, politicalEventRadioSpoofing, politicalEventBlackLions],
      28: [politicalEventGentlemensAgreement, politicalEventRadioSpoofing, politicalEventBlackLions],
      29: [politicalEventWesternGallaConfederation, politicalEventYayoOfSardo],
      30: [politicalEventWesternGallaConfederation, politicalEventYayoOfSardo],
      31: [politicalEventMassacre, politicalEventNevilleChamberlain, politicalEventTanks, politicalEventBlackLions],
      32: [politicalEventMassacre, politicalEventNevilleChamberlain, politicalEventTanks, politicalEventBlackLions],
      33: [politicalEventMassacre, politicalEventNevilleChamberlain, politicalEventTanks, politicalEventBlackLions],
    };

    final phaseState = _phaseState as PhaseStateBerhanenaSelam;
    final politicalEventHandlers = politicalEvents[phaseState.total!];
    if (politicalEventHandlers == null) {
      return;
    }
    if (index >= politicalEventHandlers.length) {
      return;
    }
    politicalEventHandlers[index]();
  }

  void berhanenaSelamPhasePoliticalEvent0() {
    berhanenaSelamPhasePoliticalEvent(0);
  }

  void berhanenaSelamPhasePoliticalEvent1() {
    berhanenaSelamPhasePoliticalEvent(1);
  }

  void berhanenaSelamPhasePoliticalEvent2() {
    berhanenaSelamPhasePoliticalEvent(2);
  }

  void berhanenaSelamPhasePoliticalEvent3() {
    berhanenaSelamPhasePoliticalEvent(3);
  }

  void berhanenaSelamPhasePoliticalEvent4() {
    berhanenaSelamPhasePoliticalEvent(4);
  }

  void berhanenaSelamPhasePoliticalEvent5() {
    berhanenaSelamPhasePoliticalEvent(5);
  }

  void turnEnd() {
    _state.clearCurrentEvents();
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      drawChitPhaseBegin,
      drawChitPhaseDrawChit,
      turnStartPhaseBegin,
      turnStartPhaseDeployUnits,
      turnStartPhaseEvent,
      berhanenaSelamPhaseBegin,
      berhanenaSelamPhaseRoll,
      berhanenaSelamPhaseExileEmperor,
      berhanenaSelamPhaseMilitaryEvent,
      berhanenaSelamPhasePoliticalEvent0,
      berhanenaSelamPhasePoliticalEvent1,
      berhanenaSelamPhasePoliticalEvent2,
      berhanenaSelamPhasePoliticalEvent3,
      berhanenaSelamPhasePoliticalEvent4,
      berhanenaSelamPhasePoliticalEvent5,
      turnEnd,
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

import 'dart:convert';
import 'dart:math';
import 'package:dont_tread_on_me/db.dart';
import 'package:dont_tread_on_me/random.dart';

enum Location {
  stateNewEngland,
  stateNewYork,
  statePennsylvania,
  stateVirginia,
  stateCarolina,
  countyNewEnglandConnecticutCoast,
  countyNewEnglandRhodeIsland,
  countyNewEnglandMassachusettsShore,
  countyNewEnglandMaineAndNovaScotia,
  countyNewYorkTheFrontier,
  countyNewYorkRiverForts,
  countyNewYorkHudsonHighlands,
  countyNewYorkHudsonValley,
  countyPennsylvaniaSchuylkillValley,
  countyPennsylvaniaAroundPhiladelphia,
  countyPennsylvaniaQuakerCountry,
  countyPennsylvaniaNewJersey,
  countyVirginaPiedmont,
  countyVirginiaTidewater,
  countyVirginiaSouthside,
  countyVirginiaHamptonRoads,
  countyCarolinaOverTheMountains,
  countyCarolinaPiedmont,
  countyCarolinaTidewater,
  countyCarolinaCharlesTown,
  boxQuebec,
  boxBoston,
  seaZoneNorthAtlantic,
  seaZoneMassachusettsBay,
  seaZoneLongIslandSound,
  seaZoneDelawareBay,
  seaZoneChesapeakeBay,
  seaZoneCapeFear,
  boxAmericanLeadershipNewYork,
  boxAmericanLeadershipPennsylvania,
  boxAmericanLeadershipVirginia,
  boxCongressInFlight,
  boxPrisonersOfWar,
  boxCaribbean,
  boxBritishShipsInHarbor,
  boxBritishShipsAtSea,
  boxAvailableIndians,
  boxBattle,
  boxVermontProBritish,
  boxVermontNeutral,
  boxVermontProRebel,
  militiaPresentLoyalist0,
  militiaPresentLoyalist1,
  militiaPresentLoyalist2,
  militiaPresentRebel0,
  militiaPresentRebel1,
  militiaPresentRebel2,
  militiaPresentRebel3,
  poolBritishForce,
  poolRebelForce,
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
  outOfPlay,
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
  stateCountyOrQuebec,
  state,
  countyOrQuebec,
  county,
  countyNewEngland,
  countyNewYork,
  countyPennsylvania,
  countyVirgina,
  countyCarolina,
  seaZone,
  turn,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.stateCountyOrQuebec: [Location.stateNewEngland, Location.boxQuebec],
    LocationType.state: [Location.stateNewEngland, Location.stateCarolina],
    LocationType.countyOrQuebec: [Location.countyNewEnglandConnecticutCoast, Location.boxQuebec],
    LocationType.county: [Location.countyNewEnglandConnecticutCoast, Location.countyCarolinaCharlesTown],
    LocationType.countyNewEngland: [Location.countyNewEnglandConnecticutCoast, Location.countyNewEnglandMaineAndNovaScotia],
    LocationType.countyNewYork: [Location.countyNewYorkTheFrontier, Location.countyNewYorkHudsonValley],
    LocationType.countyPennsylvania: [Location.countyPennsylvaniaSchuylkillValley, Location.countyPennsylvaniaNewJersey],
    LocationType.countyVirgina: [Location.countyVirginaPiedmont, Location.countyVirginiaHamptonRoads],
    LocationType.countyCarolina: [Location.countyCarolinaOverTheMountains, Location.countyCarolinaCharlesTown],
    LocationType.seaZone: [Location.seaZoneNorthAtlantic, Location.seaZoneCapeFear],
    LocationType.turn: [Location.turn0, Location.turn16],
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
  groundBritish7RF,
  groundBritish22,
  groundBritish33,
  groundBritish43,
  groundBritishFH,
  groundBritishRWF,
  groundBritish4KO,
  groundBritish18RI,
  groundBritishBW,
  groundBritishGds,
  groundBritishGnd,
  groundBritishCam,
  groundBritishMar,
  groundBritish17LD,
  groundBritishQLD,
  groundLoyalistBGP,
  groundLoyalistRHE,
  groundLoyalistRNC,
  groundLoyalistNJV,
  groundLoyalistPWL,
  groundLoyalistQAR,
  groundLoyalistAL,
  groundLoyalistTBL,
  groundHessiansAB,
  groundHessiansBrw,
  groundHessiansHCJ,
  groundHessiansHCM,
  groundHessiansAZF,
  groundHessiansHH,
  groundHessiansWal,
  groundIndianMohawk,
  groundIndianCherokee,
  groundContinentalArnold,
  groundContinentalGreene,
  groundContinentalMorgan,
  groundContinentalHoward,
  groundContinentalKosc,
  groundContinentalLafay,
  groundContinentalGlover,
  groundContinentalLincoln,
  groundContinentalMoult,
  groundContinentalStark,
  groundContinentalStirling,
  groundContinentalHuger,
  groundContinentalMuhl,
  groundContinentalKnox,
  groundContinentalWayne,
  groundContinentalHLee,
  groundCOS0,
  groundCOS1,
  groundCOS2,
  groundCOS3,
  groundCOS4,
  groundCOS5,
  groundCOS6,
  groundCOS7,
  groundCOSFM,
  groundFrenchRoch,
  navalBritishHowe,
  navalBritishParker,
  navalBritishArbuthnot,
  navalBritishGraves,
  navalRebelSmugglers0,
  navalRebelSmugglers1,
  navalRebelSmugglers2,
  navalRebelSmugglers3,
  navalRebelSmugglers4,
  navalRebelSmugglers5,
  navalRebelSmugglers6,
  navalRebelSmugglers7,
  navalRebelPrivateers0,
  navalRebelPrivateers1,
  navalFrenchFleet,
  congress,
  washington,
  jefferson,
  militiaPresentBritish,
  militiaPresentRebel,
  markerLoyaltyNewEngland,
  markerLoyaltyNewYork,
  markerLoyaltyPennsylvania,
  markerLoyaltyVirgina,
  markerLoyaltyCarolina,
  markerVermontStatus,
  markerTurn,
  markerPounds,
  markerLiberty,
  markerBattle,
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
  groundBritishPlayer,
  groundBritish,
  groundBritishWhiteFoot,
  groundBritishBlue,
  groundBritishBlueFoot,
  groundBritishBlueHorse,
  groundLoyalistGoldFoot,
  groundLoyalistGoldHorse,
  groundHessianFoot,
  groundHessianGoldFoot,
  indian,
  groundRebel,
  continental,
  navalBritish,
  navalBritish4,
  navalBritish3,
  smugglersAndPrivateers,
  smugglers,
  privateers,
  stateLoyalty,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.groundBritish7RF, Piece.markerBattle],
    PieceType.groundBritishPlayer: [Piece.groundBritish7RF, Piece.groundIndianCherokee],
    PieceType.groundBritish: [Piece.groundBritish7RF, Piece.groundBritishQLD],
    PieceType.groundBritishWhiteFoot: [Piece.groundBritish4KO, Piece.groundBritishGnd],
    PieceType.groundBritishBlue: [Piece.groundBritishCam, Piece.groundBritishQLD],
    PieceType.groundBritishBlueFoot: [Piece.groundBritishCam, Piece.groundBritishMar],
    PieceType.groundBritishBlueHorse: [Piece.groundBritish17LD, Piece.groundBritishQLD],
    PieceType.groundLoyalistGoldFoot: [Piece.groundLoyalistNJV, Piece.groundLoyalistQAR],
    PieceType.groundLoyalistGoldHorse: [Piece.groundLoyalistTBL, Piece.groundLoyalistTBL],
    PieceType.groundHessianFoot: [Piece.groundHessiansAB, Piece.groundHessiansWal],
    PieceType.groundHessianGoldFoot: [Piece.groundHessiansAZF, Piece.groundHessiansWal],
    PieceType.indian: [Piece.groundIndianMohawk, Piece.groundIndianCherokee],
    PieceType.groundRebel: [Piece.groundContinentalArnold, Piece.groundFrenchRoch],
    PieceType.continental: [Piece.groundContinentalArnold, Piece.groundContinentalHLee],
    PieceType.navalBritish: [Piece.navalBritishHowe, Piece.navalBritishGraves],
    PieceType.navalBritish4: [Piece.navalBritishHowe, Piece.navalBritishParker],
    PieceType.navalBritish3: [Piece.navalBritishArbuthnot, Piece.navalBritishGraves],
    PieceType.smugglersAndPrivateers: [Piece.navalRebelSmugglers0, Piece.navalRebelPrivateers1],
    PieceType.smugglers: [Piece.navalRebelSmugglers0, Piece.navalRebelSmugglers7],
    PieceType.privateers: [Piece.navalRebelPrivateers0, Piece.navalRebelPrivateers1],
    PieceType.stateLoyalty: [Piece.markerLoyaltyNewEngland, Piece.markerLoyaltyCarolina],
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

enum Terrain {
  wilderness,
  town,
  farm,
  fort,
}

enum CurrentEvent {
  continentalDollarCollapses,
  enlistmentsExpire,
  lordNorthResigns,
  newYorkCitySiege,
  shotHeardRoundTheWorld,
}

enum LimitedEvent {
  benedictArnoldWedsPeggy,
  franceDeclaresWar,
  inoculation,
}

enum Scenario {
  wholeWar,
  lateWar,
}

extension ScenarioExtension on Scenario {
  String get desc {
    const scenarioDescs = {
      Scenario.wholeWar: 'Campaign 1775–1782',
      Scenario.lateWar: 'Late War 1779–1782',
    };
    return scenarioDescs[this]!;
  }

  String get longDesc {
    const scenarioDescs = {
      Scenario.wholeWar: 'Campaign 1775–1782 (16 Turns)',
      Scenario.lateWar: 'Late War 1779–1782 (8 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.outOfPlay);
  List<bool> _currentEventCurrents = List<bool>.filled(CurrentEvent.values.length, false);
  List<int> _limitedEventCounts = List<int>.filled(LimitedEvent.values.length, 0);

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
    : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
    , _currentEventCurrents = List<bool>.from(json['currentEventCurrents'])
    , _limitedEventCounts = List<int>.from(json['limitedEventCounts'])
    ;

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'currentEventCurrents': _currentEventCurrents,
    'limitedEventCounts': _limitedEventCounts,
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

  // Locations

  Location? locationState(Location location) {
    if (location.isType(LocationType.state)) {
      return location;
    }
    if (location.isType(LocationType.county)) {
      for (final state in LocationType.state.locations) {
        final locationType = stateCountyLocationType(state);
        if (location.isType(locationType)) {
          return state;
        }
      }
    }
    return null;
  }

  // Counties

  Terrain countyTerrain(Location county) {
    const countyTerrains = {
      Location.countyNewEnglandConnecticutCoast: Terrain.farm,
      Location.countyNewEnglandRhodeIsland: Terrain.town,
      Location.countyNewEnglandMassachusettsShore: Terrain.farm,
      Location.countyNewEnglandMaineAndNovaScotia: Terrain.wilderness,
      Location.countyNewYorkTheFrontier: Terrain.wilderness,
      Location.countyNewYorkRiverForts: Terrain.fort,
      Location.countyNewYorkHudsonHighlands: Terrain.wilderness,
      Location.countyNewYorkHudsonValley: Terrain.farm,
      Location.countyPennsylvaniaSchuylkillValley: Terrain.wilderness,
      Location.countyPennsylvaniaAroundPhiladelphia: Terrain.town,
      Location.countyPennsylvaniaQuakerCountry: Terrain.farm,
      Location.countyPennsylvaniaNewJersey: Terrain.farm,
      Location.countyVirginaPiedmont: Terrain.town,
      Location.countyVirginiaTidewater: Terrain.wilderness,
      Location.countyVirginiaSouthside: Terrain.farm,
      Location.countyVirginiaHamptonRoads: Terrain.fort,
      Location.countyCarolinaOverTheMountains: Terrain.wilderness,
      Location.countyCarolinaPiedmont: Terrain.wilderness,
      Location.countyCarolinaTidewater: Terrain.farm,
      Location.countyCarolinaCharlesTown: Terrain.town,
      Location.boxQuebec: Terrain.farm,
    };
    return countyTerrains[county]!;
  }

  Location countyState(Location county) {
    for (final state in LocationType.state.locations) {
      final countyLocationType = stateCountyLocationType(state);
      if (county.isType(countyLocationType)) {
        return state;
      }
    }
    return Location.poolBritishForce;
  }

  // States

  LocationType stateCountyLocationType(Location state) {
    const stateCountyLocationTypes = [
      LocationType.countyNewEngland,
      LocationType.countyNewYork,
      LocationType.countyPennsylvania,
      LocationType.countyVirgina,
      LocationType.countyCarolina,
    ];
    return stateCountyLocationTypes[state.index - LocationType.state.firstIndex];
  }

  List<Location> stateInterveningStates(Location from, Location to) {
    const interveningStates = <(Location, Location), List<Location>> {
      (Location.stateNewEngland, Location.stateNewYork): [],
      (Location.stateNewEngland, Location.statePennsylvania): [Location.stateNewYork],
      (Location.stateNewEngland, Location.stateVirginia): [Location.stateNewYork, Location.statePennsylvania],
      (Location.stateNewEngland, Location.stateCarolina): [Location.stateNewYork, Location.statePennsylvania, Location.stateVirginia],
      (Location.stateNewEngland, Location.boxQuebec): [Location.stateNewYork],
      (Location.stateNewYork, Location.stateNewEngland): [],
      (Location.stateNewYork, Location.statePennsylvania): [],
      (Location.stateNewYork, Location.stateVirginia): [Location.statePennsylvania],
      (Location.stateNewYork, Location.stateCarolina): [Location.statePennsylvania, Location.stateVirginia],
      (Location.stateNewYork, Location.boxQuebec): [],
      (Location.statePennsylvania, Location.stateNewEngland): [Location.stateNewYork],
      (Location.statePennsylvania, Location.stateNewYork): [],
      (Location.statePennsylvania, Location.stateVirginia): [],
      (Location.statePennsylvania, Location.stateCarolina): [Location.stateVirginia],
      (Location.statePennsylvania, Location.boxQuebec): [Location.stateNewYork],
      (Location.stateVirginia, Location.stateNewEngland): [Location.statePennsylvania, Location.stateNewYork],
      (Location.stateVirginia, Location.stateNewYork): [Location.statePennsylvania],
      (Location.stateVirginia, Location.statePennsylvania): [],
      (Location.stateVirginia, Location.stateCarolina): [],
      (Location.stateVirginia, Location.boxQuebec): [Location.statePennsylvania, Location.stateNewYork],
      (Location.stateCarolina, Location.stateNewEngland): [Location.stateVirginia, Location.statePennsylvania, Location.stateNewYork],
      (Location.stateCarolina, Location.stateNewYork): [Location.stateVirginia, Location.statePennsylvania],
      (Location.stateCarolina, Location.statePennsylvania): [Location.stateVirginia],
      (Location.stateCarolina, Location.stateVirginia): [],
      (Location.stateCarolina, Location.boxQuebec): [Location.stateVirginia, Location.statePennsylvania, Location.stateNewYork],
      (Location.boxQuebec, Location.stateNewEngland): [Location.stateNewYork],
      (Location.boxQuebec, Location.stateNewYork): [],
      (Location.boxQuebec, Location.statePennsylvania): [Location.stateNewYork],
      (Location.boxQuebec, Location.stateVirginia): [Location.stateNewYork, Location.statePennsylvania],
      (Location.boxQuebec, Location.stateCarolina): [Location.stateNewYork, Location.statePennsylvania, Location.stateVirginia],
    };
    return interveningStates[(from, to)]!;
  }

  Piece stateLoyaltyMarker(Location state) {
    return Piece.values[PieceType.stateLoyalty.firstIndex + state.index - LocationType.state.firstIndex];
  }

  int stateLoyaltyCeiling(Location state) {
    const ceilings = [
      9,
      16,
      13,
      11,
      12,
    ];
    return ceilings[state.index - LocationType.state.firstIndex];
  }

  int stateLoyalty(Location state) {
    final marker = stateLoyaltyMarker(state);
    final box = pieceLocation(marker);
    return turnBoxValue(box);
  }

  void adjustStateLoyalty(Location state, int delta) {
    final marker = stateLoyaltyMarker(state);
    int newValue = stateLoyalty(state) + delta;
    if (newValue < 0) {
      newValue = 0;
    }
    int ceiling = stateLoyaltyCeiling(state);
    if (newValue > ceiling) {
      newValue = ceiling;
    }
    setPieceLocation(marker, turnBox(newValue));
  }

  int piecesInStateCount(PieceType pieceType, Location state) {
    final countyLocationType = stateCountyLocationType(state);
    int count = 0;
    for (final county in countyLocationType.locations) {
      count += piecesInLocationCount(pieceType, county);
    }
    return count;
  }

  // Ground Units

  bool groundUnitIsHorse(Piece groundUnit) {
    const horseUnits = [
      Piece.groundBritish17LD,
      Piece.groundBritishQLD,
      Piece.groundLoyalistTBL,
      Piece.groundContinentalHLee,
    ];
    return horseUnits.contains(groundUnit);
  }

  int britishGroundUnitCost(Piece unit) {
    if (unit.isType(PieceType.groundBritishBlueHorse)) {
      return 3;
    }
    if (unit.isType(PieceType.groundBritishBlueFoot)) {
      return 2;
    }
    if (unit.isType(PieceType.groundBritishWhiteFoot)) {
      return 2;
    }
    if (unit.isType(PieceType.groundLoyalistGoldHorse)) {
      return 2;
    }
    return 1;
  }

  // Naval Units

  int navyUnitStrength(Piece unit) {
    return unit.isType(PieceType.navalBritish4) ? 4 : 3;
  }

  int navyUnitCost(Piece unit) {
    return unit.isType(PieceType.navalBritish4) ? 2 : 1;
  }

  // Turns

  Location turnBox(int value) {
    return Location.values[LocationType.turn.firstIndex + value];
  }

  int turnBoxValue(Location turnBox) {
    return turnBox.index - LocationType.turn.firstIndex;
  }

  int get currentTurn {
    return pieceLocation(Piece.markerTurn).index - LocationType.turn.firstIndex;
  }

  String turnName(int turn) {
    const turnNames = [
      'Early 1775',
      'Late 1775',
      'Early 1776',
      'Late 1776',
      'Early 1777',
      'Late 1777',
      'Early 1778',
      'Late 1778',
      'Early 1779',
      'Late 1779',
      'Early 1780',
      'Late 1780',
      'Early 1781',
      'Late 1781',
      'Early 1782',
      'Late 1782',
    ];
    return turnNames[turn - 1];
  }

  int turnBudget(int turn) {
    const turnBudgets = [
      5, 10, 12, 12,
      14, 14, 10, 10,
      10, 10, 12, 12,
      12, 10, 8, 8,
    ];
    return turnBudgets[turn - 1];
  }

  Location turnTargetState(int turn) {
    const turnTargets = [
      Location.stateNewEngland,
      Location.stateNewEngland,
      Location.stateNewYork,
      Location.stateNewYork,
      Location.stateNewYork,
      Location.statePennsylvania,
      Location.statePennsylvania,
      Location.statePennsylvania,
      Location.stateNewYork,
      Location.stateNewYork,
      Location.stateCarolina,
      Location.stateCarolina,
      Location.stateCarolina,
      Location.stateVirginia,
      Location.stateVirginia,
      Location.stateVirginia,
    ];
    return turnTargets[turn - 1];
  }

  bool turnHasHurricanWarning(int turn) {
    const hurricaneTurns = [8, 10, 12, 14, 16];
    return hurricaneTurns.contains(turn);
  }

  bool turnIsWinter(int turn) {
    const winterTurns = [5, 7, 9, 11, 13, 15];
    return winterTurns.contains(turn);
  }

  int? turnWinterSurvivalNumber(int turn) {
    const winterSurvivalNumbers = {
      5: 5,
      7: 4,
      9: 4,
      11: 4,
      13: 3,
      15: 3,
    };
    return winterSurvivalNumbers[turn];
  }

  // Sea Zones

  Location seaZoneState(Location seaZone) {
    if (seaZone != Location.seaZoneNorthAtlantic) {
      return Location.values[LocationType.state.firstIndex + seaZone.index - 1 - LocationType.seaZone.firstIndex];
    }
    return turnTargetState(currentTurn);
  }

  // Pounds

  int get pounds {
    return pieceLocation(Piece.markerPounds).index - LocationType.turn.firstIndex;
  }

  void adjustPounds(int delta) {
    int newValue = pounds + delta;
    if (newValue < 0) {
      newValue = 0;
    }
    if (newValue > 16) {
      newValue = 16;
    }
    setPieceLocation(Piece.markerPounds, turnBox(newValue));
  }

  // Current Events

  bool currentEventCurrent(CurrentEvent event) {
    return _currentEventCurrents[event.index];
  }

  void setCurrentEventOccurred(CurrentEvent event, bool occurred) {
    _currentEventCurrents[event.index] = occurred;
  }

  void clearCurrentEvents() {
    _currentEventCurrents.fillRange(0, _currentEventCurrents.length, false);
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

  factory GameState.setupCampaign() {

    var state = GameState();

    state.setupPieceTypes([
      (PieceType.indian, Location.boxAvailableIndians),
      (PieceType.continental, Location.poolRebelForce),
    ]);

    state.setupPieces([
      (Piece.markerTurn, Location.turn1),
      (Piece.markerPounds, Location.turn0),
      (Piece.markerLiberty, Location.turn0),
      (Piece.markerBattle, Location.boxBattle),
      (Piece.markerLoyaltyNewEngland, Location.turn3),
      (Piece.markerLoyaltyNewYork, Location.turn10),
      (Piece.markerLoyaltyPennsylvania, Location.turn7),
      (Piece.markerLoyaltyVirgina, Location.turn5),
      (Piece.markerLoyaltyCarolina, Location.turn8),
      (Piece.navalRebelSmugglers0, Location.seaZoneNorthAtlantic),
      (Piece.navalRebelSmugglers1, Location.seaZoneNorthAtlantic),
      (Piece.navalRebelSmugglers2, Location.seaZoneMassachusettsBay),
      (Piece.navalRebelSmugglers3, Location.seaZoneMassachusettsBay),
      (Piece.navalRebelSmugglers4, Location.boxCaribbean),
      (Piece.groundLoyalistRHE, Location.boxQuebec),
      (Piece.groundBritishCam, Location.boxQuebec),
      (Piece.groundBritish4KO, Location.boxBoston),
      (Piece.groundBritishGnd, Location.boxBoston),
      (Piece.groundBritish18RI, Location.boxBoston),
      (Piece.groundCOS0, Location.countyNewEnglandMassachusettsShore),
      (Piece.groundCOS1, Location.countyNewEnglandMassachusettsShore),
      (Piece.groundCOS2, Location.countyNewEnglandMassachusettsShore),
      (Piece.groundCOS3, Location.countyNewEnglandMassachusettsShore),
      (Piece.groundCOS4, Location.countyNewEnglandMassachusettsShore),
      (Piece.groundBritishMar, Location.countyNewEnglandMassachusettsShore),
      (Piece.groundBritish43, Location.countyNewEnglandMassachusettsShore),
      (Piece.congress, Location.boxAmericanLeadershipPennsylvania),
      (Piece.groundLoyalistBGP, Location.countyVirginiaHamptonRoads),
      (Piece.groundLoyalistRNC, Location.countyCarolinaPiedmont),
      (Piece.navalBritishHowe, Location.boxBritishShipsAtSea),
      (Piece.militiaPresentBritish, Location.militiaPresentLoyalist0),
      (Piece.militiaPresentRebel, Location.militiaPresentRebel0),
      (Piece.markerVermontStatus, Location.boxVermontNeutral),
      (Piece.groundHessiansHCM, Location.poolBritishForce),
      (Piece.groundHessiansAB, Location.poolBritishForce),
      (Piece.groundHessiansHCJ, Location.poolBritishForce),
      (Piece.groundHessiansBrw, Location.poolBritishForce),
      (Piece.groundBritishQLD, Location.poolBritishForce),
      (Piece.groundBritish17LD, Location.poolBritishForce),
      (Piece.groundBritishFH, Location.poolBritishForce),
      (Piece.groundBritishRWF, Location.poolBritishForce),
      (Piece.groundBritish22, Location.poolBritishForce),
      (Piece.groundBritish7RF, Location.poolBritishForce),
      (Piece.groundBritish33, Location.poolBritishForce),
      (Piece.groundCOS5, Location.poolRebelForce),
      (Piece.groundCOS6, Location.poolRebelForce),
      (Piece.groundCOS7, Location.poolRebelForce),
    ]);

    return state;
  }

  factory GameState.setupLateWar() {
    var state = GameState();

    state.setupPieceTypes([
    ]);

    state.setupPieces([
      (Piece.markerTurn, Location.turn9),
      (Piece.markerPounds, Location.turn0),
      (Piece.markerLiberty, Location.turn5),
      (Piece.markerBattle, Location.boxBattle),
      (Piece.markerLoyaltyNewEngland, Location.turn2),
      (Piece.markerLoyaltyNewYork, Location.turn12),
      (Piece.markerLoyaltyPennsylvania, Location.turn7),
      (Piece.markerLoyaltyVirgina, Location.turn6),
      (Piece.markerLoyaltyCarolina, Location.turn9),
      (Piece.navalRebelSmugglers0, Location.boxCaribbean),
      (Piece.navalRebelSmugglers1, Location.boxCaribbean),
      (Piece.navalRebelSmugglers2, Location.boxCaribbean),
      (Piece.navalRebelSmugglers3, Location.boxCaribbean),
      (Piece.navalRebelSmugglers4, Location.seaZoneNorthAtlantic),
      (Piece.navalRebelPrivateers0, Location.seaZoneNorthAtlantic),
      (Piece.navalRebelSmugglers5, Location.seaZoneMassachusettsBay),
      (Piece.navalRebelSmugglers6, Location.seaZoneLongIslandSound),
      (Piece.navalRebelSmugglers7, Location.seaZoneDelawareBay),
      (Piece.groundFrenchRoch, Location.boxBoston),
      (Piece.navalFrenchFleet, Location.boxBoston),
      (Piece.congress, Location.boxAmericanLeadershipPennsylvania),
      (Piece.washington, Location.boxAmericanLeadershipPennsylvania),
      (Piece.groundBritishGds, Location.discarded),
      (Piece.groundBritishGnd, Location.discarded),
      (Piece.groundBritish18RI, Location.discarded),
      (Piece.groundContinentalKosc, Location.boxPrisonersOfWar),
      (Piece.groundContinentalGlover, Location.boxPrisonersOfWar),
      (Piece.groundContinentalMoult, Location.boxPrisonersOfWar),
      (Piece.groundContinentalStirling, Location.boxPrisonersOfWar),
      (Piece.groundContinentalWayne, Location.boxPrisonersOfWar),
      (Piece.groundBritishBW, Location.boxPrisonersOfWar),
      (Piece.groundBritishQLD, Location.boxPrisonersOfWar),
      (Piece.groundBritishRWF, Location.boxPrisonersOfWar),
      (Piece.groundBritish33, Location.boxPrisonersOfWar),
      (Piece.groundLoyalistQAR, Location.boxPrisonersOfWar),
      (Piece.groundHessiansAB, Location.poolBritishForce),
      (Piece.groundHessiansHCJ, Location.poolBritishForce),
      (Piece.groundHessiansBrw, Location.poolBritishForce),
      (Piece.groundLoyalistNJV, Location.poolBritishForce),
      (Piece.groundLoyalistRHE, Location.poolBritishForce),
      (Piece.groundContinentalGreene, Location.poolRebelForce),
      (Piece.groundContinentalLafay, Location.poolRebelForce),
      (Piece.groundCOS0, Location.poolRebelForce),
      (Piece.groundCOS1, Location.poolRebelForce),
      (Piece.groundCOS2, Location.poolRebelForce),
      (Piece.groundCOS3, Location.poolRebelForce),
      (Piece.groundCOS4, Location.poolRebelForce),
      (Piece.groundCOS5, Location.poolRebelForce),
      (Piece.groundBritishCam, Location.countyNewEnglandMaineAndNovaScotia),
      (Piece.groundBritish4KO, Location.countyNewEnglandMaineAndNovaScotia),
      (Piece.groundHessiansAZF, Location.countyNewEnglandMaineAndNovaScotia),
      (Piece.groundContinentalKnox, Location.countyNewEnglandMaineAndNovaScotia),
      (Piece.groundContinentalMuhl, Location.countyNewEnglandMaineAndNovaScotia),
      (Piece.groundContinentalStark, Location.countyNewEnglandRhodeIsland),
      (Piece.groundBritish17LD, Location.countyNewYorkHudsonValley),
      (Piece.groundHessiansHCM, Location.countyNewYorkHudsonValley),
      (Piece.groundBritish43, Location.countyNewYorkHudsonValley),
      (Piece.groundContinentalArnold, Location.countyNewYorkHudsonHighlands),
      (Piece.groundContinentalHLee, Location.countyNewYorkHudsonHighlands),
      (Piece.groundIndianMohawk, Location.countyNewYorkTheFrontier),
      (Piece.groundContinentalMorgan, Location.countyPennsylvaniaAroundPhiladelphia),
      (Piece.groundContinentalHoward, Location.countyPennsylvaniaAroundPhiladelphia),
      (Piece.groundBritishFH, Location.countyPennsylvaniaNewJersey),
      (Piece.groundBritish22, Location.countyPennsylvaniaNewJersey),
      (Piece.groundContinentalHuger, Location.countyVirginaPiedmont),
      (Piece.groundCOS6, Location.countyVirginaPiedmont),
      (Piece.groundContinentalLincoln, Location.countyCarolinaCharlesTown),
      (Piece.groundCOS7, Location.countyCarolinaPiedmont),
      (Piece.groundBritishMar, Location.countyCarolinaTidewater),
      (Piece.groundBritish7RF, Location.countyCarolinaTidewater),
      (Piece.groundLoyalistRNC, Location.countyCarolinaTidewater),
      (Piece.groundLoyalistPWL, Location.countyCarolinaTidewater),
      (Piece.groundLoyalistBGP, Location.countyCarolinaTidewater),
      (Piece.groundLoyalistTBL, Location.countyCarolinaTidewater),
      (Piece.groundIndianCherokee, Location.countyCarolinaOverTheMountains),
      (Piece.groundLoyalistAL, Location.outOfPlay),
      (Piece.groundHessiansHH, Location.outOfPlay),
      (Piece.groundHessiansWal, Location.outOfPlay),
      (Piece.navalRebelPrivateers1, Location.outOfPlay),
      (Piece.jefferson, Location.outOfPlay),
      (Piece.groundCOSFM, Location.outOfPlay),
      (Piece.navalBritishArbuthnot, Location.boxBritishShipsAtSea),
      (Piece.navalBritishGraves, Location.boxBritishShipsAtSea),
      (Piece.navalBritishHowe, Location.boxBritishShipsAtSea),
      (Piece.navalBritishParker, Location.boxBritishShipsAtSea),
      (Piece.militiaPresentBritish, Location.militiaPresentLoyalist0),
      (Piece.militiaPresentRebel, Location.militiaPresentRebel0),
      (Piece.markerVermontStatus, Location.boxVermontNeutral),
    ]);

    return state;
  }
}

enum Choice {
  raiseLegion,
  buildCity,
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
  naval,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateNaval extends PhaseState {
  List<Piece> attackers = <Piece>[];
  List<Piece> defenders = <Piece>[];

  PhaseStateNaval();

  PhaseStateNaval.fromJson(Map<String, dynamic> json)
    : attackers = pieceListFromIndices(List<int>.from(json['attackers']))
    , defenders = pieceListFromIndices(List<int>.from(json['defenders']))
    ;

  @override
  Map<String, dynamic> toJson() => {
    'attackers': pieceListToIndices(attackers),
    'defenders': pieceListToIndices(defenders),
  };

  @override
  Phase get phase {
    return Phase.naval;
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
      case Phase.naval:
        _phaseState = PhaseStateNaval.fromJson(phaseStateJson);
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

  void adjustStateLoyalty(Location state, int delta) {
    _state.adjustStateLoyalty(state, delta);
    if (delta > 0) {
      logLine('>${state.desc} Loyalty: +$delta → ${_state.stateLoyalty(state)}');
    } else if (delta < 0) {
      logLine('>${state.desc} Loyalty: $delta → ${_state.stateLoyalty(state)}');
    }
  }

  void adjustPounds(int delta) {
    _state.adjustPounds(delta);
    if (delta > 0) {
      logLine('>Pounds: +$delta → ${_state.pounds}');
    } else if (delta < 0) {
      logLine('>Pounds: $delta → ${_state.pounds}');
    }
  }

  // High-Level Functions

  List<Piece> get candidateSullivansExpeditionContinentals {
    const orderedStates = [
      Location.stateNewYork,
      Location.stateNewEngland,
      Location.statePennsylvania,
      Location.stateVirginia,
      Location.stateCarolina,
    ];
    final candidates = <Piece>[];
    for (final state in orderedStates) {
      for (final continental in PieceType.continental.pieces) {
        final location = _state.pieceLocation(continental);
        if (_state.locationState(location) == state) {
          candidates.add(continental);
        }
      }
      if (candidates.isNotEmpty) {
        return candidates;
      }
    }
    return candidates;
  }

  List<Piece> get candidateRebelPrisonerReleaseUnits {
    List<Piece> candidates = <Piece>[];
    int priority = 0;
    for (final unit in _state.piecesInLocation(PieceType.groundRebel, Location.boxPrisonersOfWar)) {
      int unitPriority = 1;
      if (unit == Piece.groundContinentalHLee) {
        unitPriority = 2;
      } else if (unit == Piece.groundContinentalArnold) {
        unitPriority = 3;
      } else if (unit == Piece.groundFrenchRoch) {
        unitPriority = 4;
      }
      if (unitPriority > priority) {
        candidates = [unit];
        priority = unitPriority;
      } else if (unitPriority == priority) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> get candidateBritishPurchaseUnits {
    List<Piece> candidates = <Piece>[];
    int priority = 0;
    for (final unit in _state.piecesInLocation(PieceType.groundBritish, Location.poolBritishForce)) {
      int unitPriority = 1;
      if (unit.isType(PieceType.groundHessianFoot)) {
        unitPriority = 2;
      }
      if (unitPriority > priority) {
        candidates = [unit];
        priority = unitPriority;
      } else if (unitPriority == priority) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Location> candidateForcedMarchDestinations(Location originCounty) {
    final originState = originCounty == Location.boxQuebec ? originCounty : _state.countyState(originCounty);
    final cavalryLocation = _state.pieceLocation(Piece.groundContinentalHLee);
    Location? cavalryState;
    if (cavalryLocation.isType(LocationType.countyOrQuebec)) {
      cavalryState = cavalryLocation == Location.boxQuebec ? cavalryLocation : _state.countyState(cavalryLocation);
    }
    final candidates = <Location>[];
    if (originState != cavalryState) {
      for (final county in LocationType.countyOrQuebec.locations) {
        final destinationState = county == Location.boxQuebec ? county : _state.countyState(county);
        if (destinationState != originState && destinationState != cavalryState) {
          final interveningStates = _state.stateInterveningStates(originState, destinationState);
          if (!interveningStates.contains(cavalryState)) {
            candidates.add(county);
          }
        }
      }
    }
    return candidates;
  }

  void unitLeavesState(Piece unit, Location state) {
    if (!state.isType(LocationType.state)) {
      return;
    }
    if (_state.piecesInStateCount(PieceType.groundBritish, state) == 0) {
      logLine('>{unit.desc} abandons ${state.desc}.');
      adjustStateLoyalty(state, -1);
    }
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
  }

  // Sequence Helpers

  // Sequence of Play

  void turnBegin() {
    logLine('# ${_state.turnName(_state.currentTurn)}');
  }

  void forceAdjustmentPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Force Adjustment Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Force Adjustment Phase');
  }

  void forceAdjustmentPhaseBudget() {
    logLine('### Budget');
    int budget = _state.turnBudget(_state.currentTurn);
    adjustPounds(budget);
  }

  void newsAdmiralRodney() {
    if (_subStep == 0) {
      logLine('### Admiral Rodney!');
      logLine('>Admiral Rodney engages the French Fleet.');
      int die = rollD6();
      logD6(die);
      if (die <= 4) {
        logLine('>British victory knocks France out of the war.');
        _state.setPieceLocation(Piece.navalFrenchFleet, Location.discarded);
        _state.setPieceLocation(Piece.groundFrenchRoch, Location.discarded);
        return;
      }
      logLine('>The French Fleet is victorious.');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select 4-strength British naval unit to remove');
        for (final piece in PieceType.navalBritish4.pieces) {
          pieceChoosable(piece);
        }
        throw PlayerChoiceException();
      }
      final piece = selectedPiece()!;
      logLine('>${piece.desc} is lost.');
      _state.setPieceLocation(piece, Location.discarded);
      clearChoices();
      _subStep = 2;
    }
    if (_subStep == 2) {
      if (choicesEmpty()) {
        setPrompt('Select 3-strength British naval unit to remove');
        for (final piece in PieceType.navalBritish3.pieces) {
          pieceChoosable(piece);
        }
        throw PlayerChoiceException();
      }
      final piece = selectedPiece()!;
      logLine('>${piece.desc} is lost.');
      _state.setPieceLocation(piece, Location.discarded);
      clearChoices();
    }
  }

  void newsBenedictWedsPeggy() {
    logLine('### Benedict Weds Peggy!');
    logLine('>Disgruntled U.S. General Benedict Arnold marries prominent Tory Peggy Shippen.');
    _state.setLimitedEventOccurred(LimitedEvent.benedictArnoldWedsPeggy);
  }

  void newsBostonEvacuated() {
    logLine('### Boston Evacuated!');
    logLine('>Britain withdraws its beseiged garrison and widens the war.');
    for (final piece in _state.piecesInLocation(PieceType.groundBritish, Location.boxBoston)) {
      _state.setPieceLocation(piece, Location.poolBritishForce);
    }
    _state.setPieceLocation(Piece.navalBritishArbuthnot, Location.boxBritishShipsAtSea);
    _state.setPieceLocation(Piece.navalBritishGraves, Location.boxBritishShipsAtSea);
    final smugglers = _state.piecesInLocation(PieceType.smugglers, Location.outOfPlay);
    _state.setPieceLocation(smugglers[0], Location.boxCaribbean);
    _state.setPieceLocation(Piece.washington, Location.poolRebelForce);
  }

  void newsCharlottesvilleRaid() {
    logLine('### Charlottesvill Raid!');
    logLine('>Redcoats try to kidnnap Thomas Jefferson.');
    int die = rollD6();
    int modifiers = 0;

    logTableHeader();
    logD6InTable(die);
    for (final groundUnit in PieceType.groundBritishPlayer.pieces) {
      if (_state.groundUnitIsHorse(groundUnit)) {
        final location = _state.pieceLocation(groundUnit);
        if (_state.locationState(location) == Location.stateVirginia) {
          logLine('>|British Horse in Virginia|+1|');
          modifiers += 1;
          break;
        }
      }
    }
    int total = die + modifiers;
    logLine('>Total|$total|');
    logTableFooter();

    if (total >= 6) {
      logLine('>Raid seizes Jefferson.');
      for (final state in LocationType.state.locations) {
        int adjustment = state == Location.stateVirginia ? 3 : 1;
         adjustStateLoyalty(state, adjustment);
      }
    } else {
      logLine('>Jefferson flees in disgrace.');
    }
    _state.setPieceLocation(Piece.jefferson, Location.discarded);
  }

  void newsContinentalDollarCollapses() {
    logLine('### Continental \$ Collapses!');
    logLine('>Unrestrained deficit spending leads to the near collapse of the U.S. economy.');
    _state.currentEventCurrent(CurrentEvent.continentalDollarCollapses);

  }

  void newsEnlistmentsExpire() {
    _state.setCurrentEventOccurred(CurrentEvent.enlistmentsExpire, true);
  }

  void newsFranceDeclaresWar() {
    if (_subStep == 0) {
      logLine('### France Declares War!');
      _state.setLimitedEventOccurred(LimitedEvent.franceDeclaresWar);
      _state.setPieceLocation(Piece.groundFrenchRoch, Location.boxBoston);
      _state.setPieceLocation(Piece.navalFrenchFleet, Location.boxCaribbean);
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select British Foot to enter the Force Pool');
        for (final british in _state.piecesInLocation(PieceType.groundBritishWhiteFoot, Location.outOfPlay)) {
          pieceChoosable(british);
        }
        throw PlayerChoiceException();
      }
      final british = selectedPiece()!;
      logLine('>${british.desc} enters the British Force Pool.');
      _state.setPieceLocation(british, Location.poolBritishForce);
      clearChoices();
      _subStep = 2;
    }
    if (_subStep == 2) {
      if (choicesEmpty()) {
        setPrompt('Select Loyalist Foot to enter the Force Pool');
        for (final loyalist in _state.piecesInLocation(PieceType.groundLoyalistGoldFoot, Location.outOfPlay)) {
          pieceChoosable(loyalist);
        }
        throw PlayerChoiceException();
      }
      final loyalist = selectedPiece()!;
      logLine('>${loyalist.desc} enters the British Force Pool.');
      _state.setPieceLocation(loyalist, Location.poolBritishForce);
      clearChoices();
    }
  }

  void newsHortalezEtCie() {
    logLine('### Hortalez et Cie.!');
    logLine('>The wily French set up a fake corporation to funnel aid to the revolutionaries.');
    final smugglers = _state.piecesInLocation(PieceType.smugglers, Location.outOfPlay);
    _state.setPieceLocation(smugglers[0], Location.boxCaribbean);
    _state.setPieceLocation(smugglers[1], Location.boxCaribbean);
  }

  void newsIndependenceDeclared() {
    if (_subStep == 0) {
      logLine('### Independence Declared!');
      logLine('>On 4 July 1776 Congress ratified the Declaration of Indenpendence.');
      _state.setPieceLocation(Piece.navalBritishParker, Location.boxBritishShipsAtSea);
      _state.setPieceLocation(Piece.navalRebelPrivateers0, Location.boxCaribbean);
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select Loyalist Foot to enter the Force Pool');
        for (final loyalist in _state.piecesInLocation(PieceType.groundLoyalistGoldFoot, Location.outOfPlay)) {
          pieceChoosable(loyalist);
        }
        throw PlayerChoiceException();
      }
      final loyalist = selectedPiece()!;
      logLine('>${loyalist.desc} enters the British Force Pool.');
      _state.setPieceLocation(loyalist, Location.poolBritishForce);
      clearChoices();
    }
  }

  void newsInoculation() {
    logLine('### Inoculation');
    logLine('>George Washington orders the inoculation of Continental soldiers against smallpox.');
    _state.setLimitedEventOccurred(LimitedEvent.inoculation);
  }

  void newsInvasionScare() {
    if (_subStep == 0) {
      logLine('### Invasion Scare!');
      logLine('>French and Spanish fleets set sail for the English Channel.');
      for (final piece in PieceType.groundBritishBlue.pieces) {
        logLine('>${piece.desc} is withdrawn to Britain.');
        _state.setPieceLocation(piece, Location.discarded);
      }
      logLine('>${Piece.groundCOSFM.desc} enters the Rebel Force Pool.');
      _state.setPieceLocation(Piece.groundCOSFM, Location.poolRebelForce);
      _subStep = 1;
    }
    if (_subStep >= 1 && _subStep <= 2) {
      if (choicesEmpty()) {
        setPrompt('Select Hessian Foot to enter the Force Pool');
        for (final hessian in _state.piecesInLocation(PieceType.groundHessianGoldFoot, Location.outOfPlay)) {
          pieceChoosable(hessian);
        }
        throw PlayerChoiceException();
      }
      final hessian = selectedPiece()!;
      logLine('>${hessian.desc} enters the Force Pool.');
      _state.setPieceLocation(hessian, Location.poolBritishForce);
      clearChoices();
      _subStep += 1;
    }
  }

  void newsJeffersonElected() {
    logLine('### Jefferson Elected!');
    logLine('>Thomas Jefferson becomes Governor of Virgina.');
    _state.setPieceLocation(Piece.jefferson, Location.boxAmericanLeadershipVirginia);
  }

  void newsJohnPaulJones() {
    logLine('### John Paul Jones!');
    logLine('>Dashing Rebel humiliates the Brits in their home waters');
    _state.setPieceLocation(Piece.navalRebelPrivateers1, Location.boxCaribbean);
  }

  void newsLordGermainsNewPlan() {
    if (_subStep == 0) {
      logLine('### Lord Germain’s New Plan!');
      logLine('>Raise Loyalist units under their own officers.');
      logLine('>${Piece.groundLoyalistTBL.desc} enters the British Force Pool.');
      _state.setPieceLocation(Piece.groundLoyalistTBL, Location.poolBritishForce);
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select Loyalist Foot to enter the Force Pool');
        for (final loyalist in _state.piecesInLocation(PieceType.groundLoyalistGoldFoot, Location.outOfPlay)) {
          pieceChoosable(loyalist);
        }
        throw PlayerChoiceException();
      }
      final loyalist = selectedPiece()!;
      logLine('>${loyalist.desc} enters the British Force Pool.');
      _state.setPieceLocation(loyalist, Location.poolBritishForce);
      clearChoices();
      _subStep = 2;
    }
    if (_subStep == 2) {
      if (choicesEmpty()) {
        setPrompt('Select British Foot to enter the Force Pool');
        for (final british in _state.piecesInLocation(PieceType.groundBritishWhiteFoot, Location.outOfPlay)) {
          pieceChoosable(british);
        }
        throw PlayerChoiceException();
      }
      final british = selectedPiece()!;
      logLine('>${british.desc} enters the British Force Pool.');
      _state.setPieceLocation(british, Location.poolBritishForce);
      clearChoices();
      _subStep = 3;
    }
    if (_subStep == 3) {
      if (choicesEmpty()) {
        setPrompt('Select Hessian Foot to enter the Force Pool');
        for (final hessian in _state.piecesInLocation(PieceType.groundHessianGoldFoot, Location.outOfPlay)) {
          pieceChoosable(hessian);
        }
        throw PlayerChoiceException();
      }
      final hessian = selectedPiece()!;
      logLine('>${hessian.desc} enters the British Force Pool.');
      _state.setPieceLocation(hessian, Location.poolBritishForce);
      clearChoices();
    }
  }

  void newsLordNorthResigns() {
    _state.currentEventCurrent(CurrentEvent.lordNorthResigns);
  }

  void newsNewYorkCitySiege() {
    logLine('### New York City Siege');
    if (_state.currentTurn == 11) {
      logLine('>Washington begins campaign to besiege New York City');
    } else {
      logLine('>Washington continues his attempt to besiege New York City');
    }
    _state.currentEventCurrent(CurrentEvent.newYorkCitySiege);

  }

  void newsShotHeardRoundTheWorld() {
    logLine('### Shot Heard Round the World');
    logLine('>The Revolution starts with an ambush on British troops at Lexington, Massachusetts.');
    _state.setCurrentEventOccurred(CurrentEvent.shotHeardRoundTheWorld, true);
  }

  void newsSullivansExpedition() {
    if (_subStep == 0) {
      logLine('### Sullivan’s Expedition!');
      logLine('>Washington orders the total destruction and devastation of Iriquois lands.');
      _subStep = 1;
    }
    if (_subStep >= 1 && _subStep <= 2) {
      if (candidateSullivansExpeditionContinentals.isNotEmpty) {
        if (choicesEmpty()) {
          setPrompt('Select Continental to remove to the Force Pool');
          for (final continental in candidateSullivansExpeditionContinentals) {
            pieceChoosable(continental);
          }
          throw PlayerChoiceException();
        }
        final continental = selectedPiece()!;
        final location = _state.pieceLocation(continental);
        logLine('>${continental.desc} is removed from ${location.desc} to the Force Pool.');
        _state.setPieceLocation(continental, Location.poolRebelForce);
        clearChoices();
      }
      _subStep += 1;
    }
    if (_subStep == 3) {
      final location = _state.pieceLocation(Piece.groundIndianMohawk);
      if (location.isType(LocationType.county)) {
        logLine('>${Piece.groundIndianMohawk.desc} is removed from ${location.desc} to Available.');
        _state.setPieceLocation(Piece.groundIndianMohawk, Location.boxAvailableIndians);
      }
    }
  }

  void forceAdjustmentPhaseNews(int index) {
    final turnNewsHandlers = [
      [],
      [newsShotHeardRoundTheWorld],
      [newsEnlistmentsExpire],
      [newsBostonEvacuated],
      [newsIndependenceDeclared, newsEnlistmentsExpire],
      [newsHortalezEtCie],
      [newsInoculation],
      [newsFranceDeclaresWar],
      [newsLordGermainsNewPlan],
      [newsBenedictWedsPeggy, newsJohnPaulJones],
      [newsSullivansExpedition, newsJeffersonElected],
      [newsInvasionScare, newsNewYorkCitySiege],
      [newsNewYorkCitySiege],
      [newsContinentalDollarCollapses, newsNewYorkCitySiege],
      [newsCharlottesvilleRaid, newsLordNorthResigns],
      [newsAdmiralRodney, newsLordNorthResigns],
      [],
    ];
    final newsHandlers = turnNewsHandlers[_state.currentTurn];
    if (index >= newsHandlers.length) {
      return;
    }
    newsHandlers[index]();
  }

  void forceAdjustmentPhaseNews0() {
    forceAdjustmentPhaseNews(0);
  }

  void forceAdjustmentPhaseNews1() {
    forceAdjustmentPhaseNews(1);
  }

  void smugglersPhaseBegin() {
    if (_state.piecesInLocationCount(PieceType.smugglersAndPrivateers, Location.boxCaribbean) == 0) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Smugglers Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Smugglers Phase');
  }

  void smugglersPhasePlaceSmugglers() {
    int totalCount = _state.piecesInLocationCount(PieceType.smugglersAndPrivateers, Location.boxCaribbean);
    if (totalCount == 0) {
      return;
    }
    logLine('### Smugglers');
    var dice = <int>[];
    if (totalCount == 1) {
      dice = [rollD6()];
      logD6(dice[0]);
    } else {
      final results = roll2D6();
      dice = [min(results.$1, results.$2), max(results.$1, results.$2)];
      log2D6(results);
    }
    for (final die in dice) {
      final seaZone = Location.values[LocationType.seaZone.firstIndex + die - 1];
      if (_state.piecesInLocationCount(PieceType.smugglersAndPrivateers, seaZone) >= 2) {
        logLine('>${seaZone.desc} is already brimming with Smugglers.');
      } else {
        final privateers = _state.piecesInLocation(PieceType.privateers, Location.boxCaribbean);
        final smugglers = _state.piecesInLocation(PieceType.smugglers, Location.boxCaribbean);
        final piece = privateers.isNotEmpty ? privateers[0] : smugglers[0];
        logLine('>${piece.desc} operates in ${seaZone.desc}.');
        _state.setPieceLocation(piece, seaZone);
      }
    }    
  }

  void navalPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Naval Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Naval Phase');
    _phaseState = PhaseStateNaval();
  }

  void navalPhaseRebaseFrenchFleet() {
    final currentLocation = _state.pieceLocation(Piece.navalFrenchFleet);
    bool hurricaneWarning = _state.turnHasHurricanWarning(_state.currentTurn);
    final newLocation = hurricaneWarning ? Location.boxBoston : Location.boxCaribbean;
    if (newLocation == currentLocation) {
      return;
    }
    logLine('### French Fleet');
    if (hurricaneWarning) {
      logLine('>French Fleet moves its base to Boston in anticipation of the hurricane season.');
    } else {
      logLine('>French Fleet moves its base to the Caribbean following the hurricane season.');
    }
    _state.setPieceLocation(Piece.navalFrenchFleet, newLocation);
  }

  void navalPhaseAttackSmugglers() {
    final phaseState = _phaseState as PhaseStateNaval;
    while (_subStep <= 1) {
      int totalCost = 0;
      for (final unit in phaseState.attackers) {
        totalCost += _state.navyUnitCost(unit);
      }
      if (_subStep == 0) { // Select smuggler
        bool affordable = false;
        for (final unit in _state.piecesInLocation(PieceType.navalBritish, Location.boxBritishShipsAtSea)) {
          if (_state.pounds - totalCost >= _state.navyUnitCost(unit)) {
            affordable = true;
            break;
          }
        }
        if (choicesEmpty()) {
          setPrompt('Select Smuggler/Privateer to Attack, or Next to proceed with Attacks');
          if (affordable) {
            for (final smuggler in PieceType.smugglersAndPrivateers.pieces) {
              final location = _state.pieceLocation(smuggler);
              if (location.isType(LocationType.seaZone)) {
                if (smuggler.isType(PieceType.privateers)) {
                  pieceChoosable(smuggler);
                } else {
                  if (_state.piecesInLocationCount(PieceType.privateers, location) == 0) {
                    pieceChoosable(smuggler);
                  }
                }
              }
            }
          }
          choiceChoosable(Choice.next, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.next)) {
          _subStep = 2;
          break;
        }
        _subStep = 1;
      }
      if (_subStep == 1) {
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          _subStep = 0;
          continue;
        }
        if (selectedPieces().length < 2) {
          setPrompt('Select Royal Navy Unit to Attack with');
          for (final unit in _state.piecesInLocation(PieceType.navalBritish, Location.boxBritishShipsAtSea)) {
            if (_state.pounds - totalCost >= _state.navyUnitCost(unit)) {
              pieceChoosable(unit);
            }
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        final smuggler = selectedPieces()[0];
        final unit = selectedPieces()[1];
        _state.setPieceLocation(unit, _state.pieceLocation(smuggler));
        phaseState.attackers.add(unit);
        phaseState.defenders.add(smuggler);
        _subStep = 0;
      }
    }
    if (_subStep == 2) {
      for (int i = 0; i < phaseState.attackers.length; ++i) {
        final defender = phaseState.defenders[i];
        final location = _state.pieceLocation(defender);
        final attacker = phaseState.attackers[i];
        if (location != Location.boxCaribbean) {
          logLine('### ${attacker.desc} attacks ${defender.desc} in ${location.desc}.');
          adjustPounds(-_state.navyUnitCost(attacker));
          if (defender.isType(PieceType.privateers)) {
            int die = rollD6();
            logD6(die);
            if (die <= 2) {
              logLine('>${attacker.desc} withdraws to harbor.');
              _state.setPieceLocation(attacker, Location.boxBritishShipsInHarbor);
              continue;
            } else {
              logLine('>${attacker.desc} presses its attack.');
            }
          }
          int die = rollD6();

          logTableHeader();
          logD6InTable(die);
          int strength = _state.navyUnitStrength(attacker);
          logLine('>|${attacker.desc}|$strength|');
          logTableFooter();

          if (die <= strength) {
            logLine('>${defender.desc} is sunk.');
            _state.setPieceLocation(defender, Location.boxCaribbean);
          } else {
            logLine('>${defender.desc} evades ${attacker.desc}.');
          }
        }
        _state.setPieceLocation(attacker, Location.boxBritishShipsInHarbor);
      }
    }
  }

  void navalPhaseShadowTheFrench() {
    if (_state.piecesInLocationCount(PieceType.navalBritish, Location.boxBritishShipsAtSea) == 0) {
      return;
    }
    if (choicesEmpty()) {
      setPrompt('Select Royal Navy unit to shadow the French Fleet');
      for (final unit in _state.piecesInLocation(PieceType.navalBritish, Location.boxBritishShipsAtSea)) {
        pieceChoosable(unit);
      }
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    if (checkChoiceAndClear(Choice.next)) {
      return;
    }
    final unit = selectedPiece()!;
    logLine('### Shadow the French');
    final location = _state.pieceLocation(Piece.navalFrenchFleet);
    logLine('>${unit.desc} shadows the French Fleet in ${location.desc}.');
    _state.setPieceLocation(unit, location);
  }

  void navalPhaseEnd() {
    _phaseState = null;
  }

  void britishGroundPhaseBegin() {
    if (_state.currentTurn == 1) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to British Ground Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## British Ground Phase');
  }

  void britishGroundPhaseWinterAttrition() {
    if (!_state.turnIsWinter(_state.currentTurn)) {
      return;
    }
    logLine('### Winter Attrition');
    int survivalNumber = _state.turnWinterSurvivalNumber(_state.currentTurn)!;
    final washingtonLocation = _state.pieceLocation(Piece.washington);
    final washingtonState = _state.locationState(washingtonLocation);
    List<Location> indianStates = [];
    for (final indian in PieceType.indian.pieces) {
      final indianLocation = _state.pieceLocation(indian);
      if (indianLocation.isType(LocationType.stateCountyOrQuebec)) {
        final indianState = _state.locationState(indianLocation);
        if (indianState != null && !indianStates.contains(indianState)) {
          indianStates.add(indianState);
        }
      }
    }
    for (final continental in PieceType.continental.pieces) {
      final location = _state.pieceLocation(continental);
      if (location.isType(LocationType.countyOrQuebec)) {
        logLine('> ${continental.desc}');
        int die = rollD6();
        int modifiers = 0;

        logTableHeader();
        logD6InTable(die);
        final continentalState = _state.locationState(location);
        if (washingtonState != null && continentalState == washingtonState) {
          logLine('>|George Washington|+2|');
          modifiers += 2;
        }
        switch (_state.countyTerrain(location)) {
        case Terrain.town:
          logLine('>|Town|+2|');
          modifiers += 2;
        case Terrain.fort:
          logLine('>|Fort|+2|');
          modifiers += 2;
        case Terrain.farm:
          logLine('>|Farm|+1|');
          modifiers += 1;
        case Terrain.wilderness:
        }
        if (continentalState == Location.stateVirginia) {
          logLine('>Virginia|+1|');
          modifiers += 1;
        } else if (continentalState == Location.stateCarolina) {
          logLine('>Carolina|+2|');
          modifiers += 1;
        }
        if (indianStates.contains(continentalState)) {
          logLine('>|Indians|-1|');
          modifiers -= 1;
        }
        int total = die + modifiers;
        logLine('>|Total|$total|');
        logTableFooter();

        if (total <= survivalNumber) {
          logLine('>${continental.desc} disperses.');
          _state.setPieceLocation(continental, Location.poolRebelForce);
        } else {
          logLine('>${continental.desc} endures the winter.');
        }
      }
    }
  }

  void britishGroundPhaseAmnesty() {
    final britishUnits = _state.piecesInLocation(PieceType.groundBritish, Location.boxPrisonersOfWar);
    final rebelUnits = _state.piecesInLocation(PieceType.groundRebel, Location.boxPrisonersOfWar);
    if (britishUnits.length <= 5 && rebelUnits.length <= 5) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Amnesty');
      _subStep = 1;
    }
    if (_subStep == 1) {
      while (britishUnits.length > 5) {
        if (choicesEmpty()) {
          setPrompt('Select British unit');
          for (final unit in britishUnits) {
            pieceChoosable(unit);
          }
          throw PlayerChoiceException();
        }
        final unit = selectedPiece()!;
        logLine('>${unit.desc} is released.');
        _state.setPieceLocation(unit, Location.poolBritishForce);
        britishUnits.remove(unit);
        clearChoices();
      }
      while (rebelUnits.length > 5) {
        if (choicesEmpty()) {
          setPrompt('Select Rebel unit');
          for (final unit in candidateRebelPrisonerReleaseUnits) {
            pieceChoosable(unit);
          }
          throw PlayerChoiceException();
        }
        final unit = selectedPiece()!;
        logLine('>${unit.desc} is released.');
        if (unit == Piece.groundFrenchRoch) {
          _state.setPieceLocation(unit, Location.boxBoston);
        } else {
          _state.setPieceLocation(unit, Location.poolRebelForce);
        }
        rebelUnits.remove(unit);
        clearChoices();
      }
    }
  }

  void britishGroundPhaseParoles() {
    final britishUnits = _state.piecesInLocation(PieceType.groundBritish, Location.boxPrisonersOfWar);
    final rebelUnits = _state.piecesInLocation(PieceType.groundRebel, Location.boxPrisonersOfWar);
    if (britishUnits.isEmpty || rebelUnits.isEmpty) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Paroles');
      _subStep = 1;
    }
    if (_subStep == 1) {
      while (britishUnits.isNotEmpty && rebelUnits.isNotEmpty) {
        if (checkChoiceAndClear(Choice.cancel)) {
          clearChoices();
          continue;
        }
        if (choicesEmpty()) {
          setPrompt('Select British unit, or Next to proceed');
          for (final unit in britishUnits) {
            pieceChoosable(unit);
          }
          choiceChoosable(Choice.next, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.next)) {
          break;
        }
      }
      if (selectedPieces().length == 1) {
        setPrompt('Select Rebel unit, or Next to proceed');
        for (final unit in candidateRebelPrisonerReleaseUnits) {
          pieceChoosable(unit);
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      final britishUnit = selectedPieces()[0];
      final rebelUnit = selectedPieces()[1];
      logLine('>${britishUnit.desc} is exchanged for ${rebelUnit.desc}.');
      _state.setPieceLocation(britishUnit, Location.poolBritishForce);
      if (rebelUnit == Piece.groundFrenchRoch) {
        _state.setPieceLocation(rebelUnit, Location.boxBoston);
      } else {
        _state.setPieceLocation(rebelUnit, Location.poolRebelForce);
      }
      britishUnits.remove(britishUnit);
      rebelUnits.remove(rebelUnit);
      clearChoices();
    }
  }

  void britishGroundPhasePurchaseUnits() {
    if (_state.currentTurn == 1) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Unit Purchases');
      _subStep = 1;
    }
    while (_subStep == 1) {
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      if (choicesEmpty()) {
        setPrompt('Select unit to Purchase or Deploy, or Next to proceed');
        for (final unit in candidateBritishPurchaseUnits) {
          if (_state.pounds >= _state.britishGroundUnitCost(unit)) {
            pieceChoosable(unit);
          }
        }
        for (final unit in PieceType.groundBritish.pieces) {
          final location = _state.pieceLocation(unit);
          if (location.isType(LocationType.seaZone)) {
            pieceChoosable(unit);
          }
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      final unit = selectedPiece()!;
      final currentLocation = _state.pieceLocation(unit);
      final county = selectedLocation();
      if (county == null) {
        setPrompt('Select County or Québec to deploy ${unit.desc} to');
        if (currentLocation == Location.poolBritishForce) {
          for (final candidateCounty in LocationType.countyOrQuebec.locations) {
            locationChoosable(candidateCounty);
          }
        } else {
          final state = _state.seaZoneState(currentLocation);
          final countyLocationType = _state.stateCountyLocationType(state);
          for (final candidateCounty in countyLocationType.locations) {
            locationChoosable(candidateCounty);
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      if (currentLocation == Location.poolBritishForce) {
        logLine('>${unit.desc} deploys in ${county.desc}.');
        int cost = _state.britishGroundUnitCost(unit);
        adjustPounds(-cost);
      } else {
        logLine('>${unit.desc} lands in ${county.desc}.');
      }
      _state.setPieceLocation(unit, county);
    }
  }

  void britishGroundPhaseMoveUnits() {
    if (_state.currentTurn == 1) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Unit Movements');
      _subStep = 1;
    }
    while (_subStep == 1) {
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      if (choicesEmpty()) {
        setPrompt('Select unit to Move, or Next to proceed');
        for (final unit in PieceType.groundBritish.pieces) {
          final location = _state.pieceLocation(unit);
          if (location.isType(LocationType.county)) {
            pieceChoosable(unit);
          }
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      final unit = selectedPiece()!;
      final currentCounty = _state.pieceLocation(unit);
      final destinationCounty = selectedLocation();
      if (destinationCounty == null) {
        setPrompt('Select County to move ${unit.desc} to');
        final state = _state.countyState(currentCounty);
        final countyLocationType = _state.stateCountyLocationType(state);
        for (final candidateCounty in countyLocationType.locations) {
          if (candidateCounty != currentCounty) {
            locationChoosable(candidateCounty);
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      logLine('>${unit.desc} moves from ${currentCounty.desc} to ${destinationCounty.desc}.');
      _state.setPieceLocation(unit, destinationCounty);
    }
  }

  void britishGroundPhaseForcedMarch() {
    if (_state.currentTurn == 1) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Forced Marches');
      _subStep = 1;
    }
    while (_subStep == 1) {
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      if (choicesEmpty()) {
        setPrompt('Select unit to Forced March, or Next to proceed');
        for (final unit in PieceType.groundBritish.pieces) {
          final location = _state.pieceLocation(unit);
          if (location.isType(LocationType.countyOrQuebec)) {
            pieceChoosable(unit);
          }
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      final unit = selectedPiece()!;
      final currentCounty = _state.pieceLocation(unit);
      final currentState = currentCounty == Location.boxQuebec ? currentCounty : _state.countyState(currentCounty);
      final destinationCounty = selectedLocation();
      if (destinationCounty == null) {
        setPrompt('Select County to move ${unit.desc} to');
        for (final county in candidateForcedMarchDestinations(currentCounty)) {
          locationChoosable(county);
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      logLine('>${unit.desc} marches from ${currentCounty.desc} to ${destinationCounty.desc}.');
      int die = rollD6();
      int modifiers = 0;

      logTableHeader();
      logD6InTable(die);
      if (_state.piecesInLocationCount(PieceType.groundRebel, destinationCounty) > 0) {
        logLine('>|Enemy-occupied County|+1|');
        modifiers += 1;
      }
      final destinationState = destinationCounty == Location.boxQuebec ? destinationCounty : _state.countyState(destinationCounty);
      final interveningStates = _state.stateInterveningStates(currentState, destinationState);
      if (interveningStates.isNotEmpty) {
        logLine('>|Non-adjacent|+1|');
        modifiers += 1;
      }
      int total = die + modifiers;
      logLine('>|Total|$total|');
      logTableFooter();

      if (total >= 6) {
        logLine('>${unit.desc} evaporates.');
        _state.setPieceLocation(unit, Location.poolBritishForce);
        return;
      }

      logLine('>${unit.desc} arrives intact in ${destinationCounty.desc}.');
      _state.setPieceLocation(unit, destinationCounty);

      unitLeavesState(unit, currentState);
    }
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      forceAdjustmentPhaseBegin,
      forceAdjustmentPhaseBudget,
      forceAdjustmentPhaseNews0,
      forceAdjustmentPhaseNews1,
      smugglersPhaseBegin,
      smugglersPhasePlaceSmugglers,
      navalPhaseBegin,
      navalPhaseRebaseFrenchFleet,
      navalPhaseAttackSmugglers,
      navalPhaseShadowTheFrench,
      navalPhaseEnd,
      britishGroundPhaseBegin,
      britishGroundPhaseWinterAttrition,
      britishGroundPhaseAmnesty,
      britishGroundPhaseParoles,
      britishGroundPhasePurchaseUnits,
      britishGroundPhaseMoveUnits,
      britishGroundPhaseForcedMarch,
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

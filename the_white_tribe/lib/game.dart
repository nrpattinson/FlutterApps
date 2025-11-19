import 'dart:convert';
import 'dart:math';
import 'package:the_white_tribe/db.dart';

enum Location {
  provinceMidlands,
  provinceMatabeleland,
  provinceMashonaland,
  provinceManicaland,
  provinceVictoria,
  salisbury,
  regionZambia,
  regionTete,
  regionMocambique,
  regionSouthAfrica,
  regionBotswana,
  boxAirForceBase,
  boxWhaWhaPrison,
  boxCollaborators,
  frontLineZambia,
  frontLineTete,
  frontLineMocambique,
  frontLineBotswana,
  frontLineTanzania,
  boxZambianTrade,
  boxZanuLeadership,
  boxGlobalTrade,
  boxUKGovernment,
  boxUSAGovernment,
  boxSouthAfricaGovernment,
  boxRhodesia,
  boxUSPresident,
  boxAlcora,
  terror1,
  terror2,
  terror3,
  terror4,
  terror5,
  terror6,
  terror7,
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
  popularityN4,
  popularityN3,
  popularityN2,
  popularityN1,
  popularityZ,
  popularityP1,
  popularityP2,
  popularityP3,
  popularityP4,
  popularityP5,
  houseOfAssembly2,
  houseOfAssembly3,
  houseOfAssembly4,
  houseOfAssembly5,
  houseOfAssembly6,
  houseOfAssembly7,
  houseOfAssembly8,
  houseOfAssembly9,
  poolForce,
  unavailable,
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
  provinceOrRegion,
  province,
  region,
  turn,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.provinceOrRegion: [Location.provinceMidlands, Location.regionBotswana],
    LocationType.province: [Location.provinceMidlands, Location.provinceVictoria],
    LocationType.region: [Location.regionZambia, Location.regionBotswana],
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
      Location.provinceMidlands: 'midlands',
      Location.provinceMatabeleland: 'matabeleland',
      Location.provinceMashonaland: 'mashonaland',
      Location.provinceManicaland: 'manicaland',
      Location.provinceVictoria: 'victoria',
      Location.regionZambia: 'Zambia',
      Location.regionTete: 'Tete',
      Location.regionMocambique: 'Moçambique',
      Location.regionSouthAfrica: 'South Aftica',
      Location.regionBotswana: 'Botswana',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Piece {
  terrZanu0,
  terrZanu1,
  terrZanu2,
  terrZanu3,
  terrZanu4,
  terrZanu5,
  terrZanu6,
  terrZanu7,
  terrZanu8,
  terrZanu9,
  terrZanu10,
  terrZanu11,
  terrZanu12,
  terrZanu13,
  terrZanu14,
  terrZanu15,
  terrZapu0,
  terrZapu1,
  terrZapu2,
  terrZapu3,
  terrZapu4,
  terrZapu5,
  terrZapu6,
  terrZanu0Used,
  terrZanu1Used,
  terrZanu2Used,
  terrZanu3Used,
  terrZanu4Used,
  terrZanu5Used,
  terrZanu6Used,
  terrZanu7Used,
  terrZanu8Used,
  terrZanu9Used,
  terrZanu10Used,
  terrZanu11Used,
  terrZanu12Used,
  terrZanu13Used,
  terrZanu14Used,
  terrZanu15Used,
  terrZapu0Used,
  terrZapu1Used,
  terrZapu2Used,
  terrZapu3Used,
  terrZapu4Used,
  terrZapu5Used,
  terrZapu6Used,
  troopieRhodesiaRAR1,
  troopieRhodesiaRAR2,
  troopieRhodesiaRAR3,
  troopieRhodesiaRLI,
  troopieRhodesiaSelousScouts1,
  troopieRhodesiaSelousScouts2,
  troopieRhodesiaSAS,
  troopieRhodesiaGreysScouts,
  troopieRhodesiaBSAP,
  troopieRhodesiaGuardForce,
  troopieRhodesiaPfumoReVanhu1,
  troopieRhodesiaPfumoReVanhu2,
  troopieSouthAfricaSAP1,
  troopieSouthAfricaSAP2,
  troopiePortugalFlechas,
  troopiePortugalGruposEspecials,
  troopieRenamo1,
  troopieRenamo2,
  troopieRhodesiaRAR1Used,
  troopieRhodesiaRAR2Used,
  troopieRhodesiaRAR3Used,
  troopieRhodesiaRLIUsed,
  troopieRhodesiaSelousScouts1Used,
  troopieRhodesiaSelousScouts2Used,
  troopieRhodesiaSASUsed,
  troopieRhodesiaGreysScoutsUsed,
  troopieRhodesiaBSAPUsed,
  troopieRhodesiaGuardForceUsed,
  troopieRhodesiaPfumoReVanhu1Used,
  troopieRhodesiaPfumoReVanhu2Used,
  troopieSouthAfricaSAP1Used,
  troopieSouthAfricaSAP2Used,
  troopiePortugalFlechasUsed,
  troopiePortugalGruposEspecialsUsed,
  airForceRhodesia2,
  airForceRhodesia1,
  fortification0,
  fortification1,
  fortification2,
  fortification0UnderConstruction,
  fortification1UnderConstruction,
  fortification2UnderConstruction,
  politicianBlackChitepo,
  politicianBlackMugabe,
  politicianBlackSithole,
  politicianBlackMuzorewa,
  politicianBlackNkomo,
  politicianBlackChitepoZanu,
  politicianBlackMugabeZanu,
  politicianBlackSitholeZanu,
  politicianBlackMuzorewaUanc,
  politicianBlackNkomoZapu,
  politicianZambiaKaunda,
  politicianZambiaCoup,
  politicianTanzaniaNyerere,
  politicianTanzaniaCoup,
  politicianUsReagan,
  politicianUsCarter,
  politicianUsKissinger,
  policyProvincialCouncils,
  policyExerciseAlcora,
  policyLandTenureAct,
  policyProclaimRepublic,
  policySpiritMediums,
  policyPearceCommission,
  policyLawAndOrder,
  policyDetente,
  policyCorsan,
  policyLandTenureAmendment,
  policyQuenetCommission,
  policyIntegration,
  policyPfumoReVanhu,
  policyAfricanAdvancement,
  policyExerciseAlcoraEnacted,
  policyProclaimRepublicEnacted,
  policyLawAndOrderEnacted,
  policyLandTenureAmendmentEnacted,
  policyQuenetCommissionEnacted,
  policyIntegrationEnacted,
  policyAfricanAdvancementEnacted,
  foreignBritainAnti,
  foreignBritainPro,
  foreignSouthAfricaAnti,
  foreignSouthAfricaPro,
  foreignUSAAnti,
  foreignUSAPro,
  foreignPortugalTete,
  foreignPortugalMocambique,
  blackAttitudeFistMidlands,
  blackAttitudeFistMatabeleland,
  blackAttitudeFistMashonaLand,
  blackAttitudeFistManicaLand,
  blackAttitudeFistVictoria,
  blackAttitudeHandshakeMidlands,
  blackAttitudeHandshakeMatabeleland,
  blackAttitudeHandshakeMashonaland,
  blackAttitudeHandshakeManicaland,
  blackAttitudeHandshakeVictoria,
  markerSanctions,
  markerPortBeira,
  markerTanZamRailway,
  markerFico,
  markerTreasury,
  markerTerrorLevel,
  markerGameTurn,
  markerHouseOfAssembly,
  markerRhodesianFrontPopularity,
  markerPopulationUp,
  markerPopulationDown,
  markerRhodesianElection,
  markerBritishRule,
  markerBritishElection,
  markerRepublicOfRhodesia,
  markerZimbabweRhodesia,
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
  terr,
  terrUnused,
  terrZanuUnused,
  terrZapuUnused,
  troopieRhodesiaUnused,
  troopieRhodesiaSouthAfricaUnused,
  troopieRhodesiaSouthAfricaUsed,
  fortification,
  politicianTananzia,
  policyFront,
  foreignBritain,
  foreignSouthAfrica,
  foreignUSA,
  blackAttitudeFist,
  blackAttitudeHandshake,
  markerPopulation,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.terrZanu0, Piece.markerZimbabweRhodesia],
    PieceType.terr: [Piece.terrZanu0, Piece.terrZapu6Used],
    PieceType.terrUnused: [Piece.terrZanu0, Piece.terrZapu6],
    PieceType.terrZanuUnused: [Piece.terrZanu0, Piece.terrZanu15],
    PieceType.terrZapuUnused: [Piece.terrZapu0, Piece.terrZapu6],
    PieceType.troopieRhodesiaUnused: [Piece.troopieRhodesiaRAR1, Piece.troopieRhodesiaPfumoReVanhu2],
    PieceType.troopieRhodesiaSouthAfricaUnused: [Piece.troopieRhodesiaRAR1, Piece.troopieSouthAfricaSAP2],
    PieceType.troopieRhodesiaSouthAfricaUsed: [Piece.troopieRhodesiaRAR1Used, Piece.troopieSouthAfricaSAP2Used],
    PieceType.fortification: [Piece.fortification0, Piece.fortification2],
    PieceType.politicianTananzia: [Piece.politicianTanzaniaNyerere, Piece.politicianTanzaniaCoup],
    PieceType.policyFront: [Piece.policyProvincialCouncils, Piece.policyAfricanAdvancement],
    PieceType.foreignBritain: [Piece.foreignBritainAnti, Piece.foreignBritainPro],
    PieceType.foreignSouthAfrica: [Piece.foreignSouthAfricaAnti, Piece.foreignSouthAfricaPro],
    PieceType.foreignUSA: [Piece.foreignUSAAnti, Piece.foreignUSAPro],
    PieceType.blackAttitudeFist: [Piece.blackAttitudeFistMidlands, Piece.blackAttitudeFistVictoria],
    PieceType.blackAttitudeHandshake: [Piece.blackAttitudeHandshakeMidlands, Piece.blackAttitudeHandshakeVictoria],
    PieceType.markerPopulation: [Piece.markerPopulationUp, Piece.markerPopulationDown],
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
      Scenario.standard: 'Standard (16 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);

  GameState();

  GameState.fromJson(Map<String, dynamic> json) :
   _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']));

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.terrZanu0: Piece.terrZanu0Used,
      Piece.terrZanu1: Piece.terrZanu1Used,
      Piece.terrZanu2: Piece.terrZanu2Used,
      Piece.terrZanu3: Piece.terrZanu3Used,
      Piece.terrZanu4: Piece.terrZanu4Used,
      Piece.terrZanu5: Piece.terrZanu5Used,
      Piece.terrZanu6: Piece.terrZanu6Used,
      Piece.terrZanu7: Piece.terrZanu7Used,
      Piece.terrZanu8: Piece.terrZanu8Used,
      Piece.terrZanu9: Piece.terrZanu9Used,
      Piece.terrZanu10: Piece.terrZanu10Used,
      Piece.terrZanu11: Piece.terrZanu11Used,
      Piece.terrZanu12: Piece.terrZanu12Used,
      Piece.terrZanu13: Piece.terrZanu13Used,
      Piece.terrZanu14: Piece.terrZanu14Used,
      Piece.terrZanu15: Piece.terrZanu15Used,
      Piece.terrZapu0: Piece.terrZapu0Used,
      Piece.terrZapu1: Piece.terrZapu1Used,
      Piece.terrZapu2: Piece.terrZapu2Used,
      Piece.terrZapu3: Piece.terrZapu3Used,
      Piece.terrZapu4: Piece.terrZapu4Used,
      Piece.terrZapu5: Piece.terrZapu5Used,
      Piece.terrZapu6: Piece.terrZapu6Used,
      Piece.troopieRhodesiaRAR1: Piece.troopieRhodesiaRAR1Used,
      Piece.troopieRhodesiaRAR2: Piece.troopieRhodesiaRAR2Used,
      Piece.troopieRhodesiaRAR3: Piece.troopieRhodesiaRAR3Used,
      Piece.troopieRhodesiaRLI: Piece.troopieRhodesiaRLIUsed,
      Piece.troopieRhodesiaSelousScouts1: Piece.troopieRhodesiaSelousScouts1Used,
      Piece.troopieRhodesiaSelousScouts2: Piece.troopieRhodesiaSelousScouts2Used,
      Piece.troopieRhodesiaSAS: Piece.troopieRhodesiaSASUsed,
      Piece.troopieRhodesiaGreysScouts: Piece.troopieRhodesiaGreysScoutsUsed,
      Piece.troopieRhodesiaBSAP: Piece.troopieRhodesiaBSAPUsed,
      Piece.troopieRhodesiaGuardForce: Piece.troopieRhodesiaGuardForceUsed,
      Piece.troopieRhodesiaPfumoReVanhu1: Piece.troopieRhodesiaPfumoReVanhu1Used,
      Piece.troopieRhodesiaPfumoReVanhu2: Piece.troopieRhodesiaPfumoReVanhu2Used,
      Piece.troopieSouthAfricaSAP1: Piece.troopieSouthAfricaSAP1Used,
      Piece.troopieSouthAfricaSAP2: Piece.troopieSouthAfricaSAP2Used,
      Piece.troopiePortugalFlechas: Piece.troopiePortugalFlechasUsed,
      Piece.troopiePortugalGruposEspecials: Piece.troopiePortugalGruposEspecialsUsed,
      Piece.troopieRenamo1: Piece.foreignPortugalTete,
      Piece.troopieRenamo2: Piece.foreignPortugalMocambique,
      Piece.terrZanu0Used: Piece.terrZanu0,
      Piece.terrZanu1Used: Piece.terrZanu1,
      Piece.terrZanu2Used: Piece.terrZanu2,
      Piece.terrZanu3Used: Piece.terrZanu3,
      Piece.terrZanu4Used: Piece.terrZanu4,
      Piece.terrZanu5Used: Piece.terrZanu5,
      Piece.terrZanu6Used: Piece.terrZanu6,
      Piece.terrZanu7Used: Piece.terrZanu7,
      Piece.terrZanu8Used: Piece.terrZanu8,
      Piece.terrZanu9Used: Piece.terrZanu9,
      Piece.terrZanu10Used: Piece.terrZanu10,
      Piece.terrZanu11Used: Piece.terrZanu11,
      Piece.terrZanu12Used: Piece.terrZanu12,
      Piece.terrZanu13Used: Piece.terrZanu13,
      Piece.terrZanu14Used: Piece.terrZanu14,
      Piece.terrZanu15Used: Piece.terrZanu15,
      Piece.terrZapu0Used: Piece.terrZapu0,
      Piece.terrZapu1Used: Piece.terrZapu1,
      Piece.terrZapu2Used: Piece.terrZapu2,
      Piece.terrZapu3Used: Piece.terrZapu3,
      Piece.terrZapu4Used: Piece.terrZapu4,
      Piece.terrZapu5Used: Piece.terrZapu5,
      Piece.terrZapu6Used: Piece.terrZapu6,
      Piece.troopieRhodesiaRAR1Used: Piece.troopieRhodesiaRAR1,
      Piece.troopieRhodesiaRAR2Used: Piece.troopieRhodesiaRAR2,
      Piece.troopieRhodesiaRAR3Used: Piece.troopieRhodesiaRAR3,
      Piece.troopieRhodesiaRLIUsed: Piece.troopieRhodesiaRLI,
      Piece.troopieRhodesiaSelousScouts1Used: Piece.troopieRhodesiaSelousScouts1,
      Piece.troopieRhodesiaSelousScouts2Used: Piece.troopieRhodesiaSelousScouts2,
      Piece.troopieRhodesiaSASUsed: Piece.troopieRhodesiaSAS,
      Piece.troopieRhodesiaGreysScoutsUsed: Piece.troopieRhodesiaGreysScouts,
      Piece.troopieRhodesiaBSAPUsed: Piece.troopieRhodesiaBSAP,
      Piece.troopieRhodesiaGuardForceUsed: Piece.troopieRhodesiaGuardForce,
      Piece.troopieRhodesiaPfumoReVanhu1Used: Piece.troopieRhodesiaPfumoReVanhu1,
      Piece.troopieRhodesiaPfumoReVanhu2Used: Piece.troopieRhodesiaPfumoReVanhu2,
      Piece.troopieSouthAfricaSAP1Used: Piece.troopieSouthAfricaSAP1,
      Piece.troopieSouthAfricaSAP2Used: Piece.troopieSouthAfricaSAP2,
      Piece.troopiePortugalFlechasUsed: Piece.troopiePortugalFlechas,
      Piece.troopiePortugalGruposEspecialsUsed: Piece.troopiePortugalGruposEspecials,
      Piece.airForceRhodesia2: Piece.airForceRhodesia1,
      Piece.airForceRhodesia1: Piece.airForceRhodesia2,
      Piece.fortification0: Piece.fortification0UnderConstruction,
      Piece.fortification1: Piece.fortification1UnderConstruction,
      Piece.fortification2: Piece.fortification2UnderConstruction,
      Piece.fortification0UnderConstruction: Piece.fortification0,
      Piece.fortification1UnderConstruction: Piece.fortification1,
      Piece.fortification2UnderConstruction: Piece.fortification2,
      Piece.politicianBlackChitepo: Piece.politicianBlackChitepoZanu,
      Piece.politicianBlackMugabe: Piece.politicianBlackMugabeZanu,
      Piece.politicianBlackSithole: Piece.politicianBlackSitholeZanu,
      Piece.politicianBlackMuzorewa: Piece.politicianBlackMuzorewaUanc,
      Piece.politicianBlackNkomo: Piece.politicianBlackNkomoZapu,
      Piece.politicianBlackChitepoZanu: Piece.politicianBlackChitepo,
      Piece.politicianBlackMugabeZanu: Piece.politicianBlackMugabe,
      Piece.politicianBlackSitholeZanu: Piece.politicianBlackSithole,
      Piece.politicianBlackMuzorewaUanc: Piece.politicianBlackMuzorewa,
      Piece.politicianBlackNkomoZapu: Piece.politicianBlackNkomo,
      Piece.politicianZambiaKaunda: Piece.politicianZambiaCoup,
      Piece.politicianZambiaCoup: Piece.politicianZambiaKaunda,
      Piece.politicianTanzaniaNyerere: Piece.politicianTanzaniaCoup,
      Piece.politicianTanzaniaCoup: Piece.politicianTanzaniaNyerere,
      Piece.politicianUsReagan: Piece.politicianUsKissinger,
      Piece.politicianUsCarter: Piece.markerSanctions,
      Piece.politicianUsKissinger: Piece.politicianUsReagan,
      Piece.policyExerciseAlcora: Piece.policyExerciseAlcoraEnacted,
      Piece.policyProclaimRepublic: Piece.policyProclaimRepublicEnacted,
      Piece.policyLawAndOrder: Piece.policyLawAndOrderEnacted,
      Piece.policyLandTenureAmendment: Piece.policyLandTenureAmendmentEnacted,
      Piece.policyQuenetCommission: Piece.policyQuenetCommissionEnacted,
      Piece.policyIntegration: Piece.policyIntegrationEnacted,
      Piece.policyAfricanAdvancement: Piece.policyAfricanAdvancementEnacted,
      Piece.policyExerciseAlcoraEnacted: Piece.policyExerciseAlcora,
      Piece.policyProclaimRepublicEnacted: Piece.policyProclaimRepublic,
      Piece.policyLawAndOrderEnacted: Piece.policyLawAndOrder,
      Piece.policyLandTenureAmendmentEnacted: Piece.policyLandTenureAmendment,
      Piece.policyQuenetCommissionEnacted: Piece.policyQuenetCommission,
      Piece.policyIntegrationEnacted: Piece.policyIntegration,
      Piece.policyAfricanAdvancementEnacted: Piece.policyAfricanAdvancement,
      Piece.foreignBritainAnti: Piece.foreignBritainPro,
      Piece.foreignBritainPro: Piece.foreignBritainAnti,
      Piece.foreignSouthAfricaAnti: Piece.foreignSouthAfricaPro,
      Piece.foreignSouthAfricaPro: Piece.foreignSouthAfricaAnti,
      Piece.foreignUSAAnti: Piece.foreignUSAPro,
      Piece.foreignUSAPro: Piece.foreignUSAAnti,
      Piece.foreignPortugalTete: Piece.troopieRenamo1,
      Piece.foreignPortugalMocambique: Piece.troopieRenamo2,
      Piece.blackAttitudeFistMidlands: Piece.blackAttitudeHandshakeMidlands,
      Piece.blackAttitudeFistMatabeleland: Piece.blackAttitudeHandshakeMatabeleland,
      Piece.blackAttitudeFistMashonaLand: Piece.blackAttitudeHandshakeMashonaland,
      Piece.blackAttitudeFistManicaLand: Piece.blackAttitudeHandshakeManicaland,
      Piece.blackAttitudeFistVictoria: Piece.blackAttitudeHandshakeVictoria,
      Piece.blackAttitudeHandshakeMidlands: Piece.blackAttitudeFistMidlands,
      Piece.blackAttitudeHandshakeMatabeleland: Piece.blackAttitudeFistMatabeleland,
      Piece.blackAttitudeHandshakeMashonaland: Piece.blackAttitudeFistMashonaLand,
      Piece.blackAttitudeHandshakeManicaland: Piece.blackAttitudeFistManicaLand,
      Piece.blackAttitudeHandshakeVictoria: Piece.blackAttitudeFistVictoria,
      Piece.markerSanctions: Piece.politicianUsCarter,
      Piece.markerPortBeira: Piece.markerTanZamRailway,
      Piece.markerTanZamRailway: Piece.markerPortBeira,
      Piece.markerPopulationUp: Piece.markerPopulationDown,
      Piece.markerPopulationDown: Piece.markerPopulationUp,
      Piece.markerRepublicOfRhodesia: Piece.markerZimbabweRhodesia,
      Piece.markerZimbabweRhodesia: Piece.markerRepublicOfRhodesia,
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

  // Troopies

  int troopieStrength(Piece troopie) {
    const troopieStrengths = {
      Piece.troopieRhodesiaRAR1: 2,
      Piece.troopieRhodesiaRAR2: 2,
      Piece.troopieRhodesiaRAR3: 2,
      Piece.troopieRhodesiaRLI: 3,
      Piece.troopieRhodesiaSelousScouts1: 4,
      Piece.troopieRhodesiaSelousScouts2: 4,
      Piece.troopieRhodesiaSAS: 3,
      Piece.troopieRhodesiaGreysScouts: 2,
      Piece.troopieRhodesiaBSAP: 2,
      Piece.troopieRhodesiaGuardForce: 1,
      Piece.troopieRhodesiaPfumoReVanhu1: 1,
      Piece.troopieRhodesiaPfumoReVanhu2: 1,
      Piece.troopieSouthAfricaSAP1: 2,
      Piece.troopieSouthAfricaSAP2: 2,
      Piece.troopiePortugalFlechas: 2,
      Piece.troopiePortugalGruposEspecials: 2,
      Piece.troopieRenamo1: 0,
      Piece.troopieRenamo2: 0,
    };
    return troopieStrengths[troopie]!;
  }

  // Black Politicians

  Piece politician(Piece politicianFront) {
    return pieceLocation(politicianFront) != Location.flipped ? politicianFront : pieceFlipSide(politicianFront)!;
  }

  // Terror

  int get terror {
    return pieceLocation(Piece.markerTerrorLevel).index - Location.terror1.index + 1;
  }

  bool adjustTerror(int delta) {
    bool overflow = false;
    int newValue = terror + delta;
    if (newValue < 1) {
      newValue = 1;
    } else if (newValue > 7) {
      newValue = 7;
      overflow = true;
    }
    setPieceLocation(Piece.markerTerrorLevel, Location.values[Location.terror1.index + newValue - 1]);
    return overflow;
  }

  // RF Popularity
  
  int get rfPopularity {
    return pieceLocation(Piece.markerRhodesianFrontPopularity).index - Location.popularityN4.index - 4;
  }

  void adjustRFPopularity(int delta) {
    int newValue = rfPopularity + delta;
    if (newValue < -4) {
      newValue = -4;
    } else if (newValue > 5) {
      newValue = 5;
    }
    setPieceLocation(Piece.markerRhodesianFrontPopularity, Location.values[Location.popularityN4.index + newValue + 4]);
  }

  // Turns

  int get currentTurn {
    return pieceLocation(Piece.markerGameTurn).index - Location.turn0.index;
  }

  String turnName(int turn) {
    return '${1965 + turn}';
  }

  Location turnBox(int turn) {
    return Location.values[Location.turn0.index + turn];
  }

  Location futureTurnBox(int futureTurnCount) {
    int turn = currentTurn + futureTurnCount;
    if (turn <= 16) {
      return turnBox(turn);
    } else {
      return Location.discarded;
    }
  }

  int turnBoxValue(Location box) {
    return box.index - Location.turn0.index;
  }

  // Attitude

  int get fistCount {
    int count = 0;
    for (final fist in PieceType.blackAttitudeFist.pieces) {
      if (pieceLocation(fist) != Location.flipped) {
        count += 1;
      }
    }
    return count;
  }

  // Population

  bool get populationUp {
    return pieceLocation(Piece.markerPopulationUp) != Location.flipped;
  }

  Piece get populationMarker {
    return populationUp ? Piece.markerPopulationUp : Piece.markerPopulationDown;
  }

  int get population {
    return turnBoxValue(pieceLocation(populationMarker));
  }

  void adjustPopulation(int delta) {
    int newValue = population + delta;
    if (newValue < 0) {
      newValue = 0;
    } else if (newValue > 16) {
      newValue = 16;
    }
    setPieceLocation(populationMarker, turnBox(newValue));
  }

  // Dollars

  int get treasury {
    return turnBoxValue(pieceLocation(Piece.markerTreasury));
  }

  void adjustTreasury(int delta) {
    int newValue = treasury + delta;
    if (newValue > 16) {
      newValue = 16;
    }
    if (newValue < 0) {
      newValue = 0;
    }
    setPieceLocation(Piece.markerTreasury, turnBox(newValue));
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

    state.setupPieceTypes([
      (PieceType.fortification, Location.unavailable),
      (PieceType.terrZanuUnused, Location.poolForce),
      (PieceType.terrZapuUnused, Location.poolForce),
    ]);

    state.setupPieces([
      (Piece.markerFico, Location.unavailable),
      (Piece.markerRepublicOfRhodesia, Location.unavailable),
      (Piece.markerSanctions, Location.unavailable),
      (Piece.politicianUsReagan, Location.unavailable),
      (Piece.troopiePortugalFlechas, Location.unavailable),
      (Piece.troopieSouthAfricaSAP1, Location.unavailable),
      (Piece.troopieSouthAfricaSAP2, Location.unavailable),
      (Piece.troopieRhodesiaSelousScouts1, Location.unavailable),
      (Piece.troopieRhodesiaSelousScouts2, Location.unavailable),
      (Piece.troopieRhodesiaGuardForce, Location.unavailable),
      (Piece.troopieRhodesiaPfumoReVanhu1, Location.unavailable),
      (Piece.troopieRhodesiaPfumoReVanhu2, Location.unavailable),
      (Piece.troopieRhodesiaRAR2, Location.poolForce),
      (Piece.troopieRhodesiaRAR3, Location.poolForce),
      (Piece.troopieRhodesiaGreysScouts, Location.poolForce),
      (Piece.markerTreasury, Location.turn0),
      (Piece.markerGameTurn, Location.turn1),
      (Piece.markerBritishElection, Location.turn1),
      (Piece.markerRhodesianElection, Location.turn5),
      (Piece.markerPopulationUp, Location.turn5),
      (Piece.markerRhodesianFrontPopularity, Location.popularityP1),
      (Piece.markerHouseOfAssembly, Location.houseOfAssembly9),
      (Piece.troopiePortugalGruposEspecials, Location.regionMocambique),
      (Piece.airForceRhodesia2, Location.boxAirForceBase),
      (Piece.markerPortBeira, Location.boxZambianTrade),
      (Piece.foreignPortugalTete, Location.frontLineTete),
      (Piece.foreignPortugalMocambique, Location.frontLineMocambique),
      (Piece.blackAttitudeHandshakeMidlands, Location.provinceMidlands),
      (Piece.blackAttitudeHandshakeMatabeleland, Location.provinceMatabeleland),
      (Piece.blackAttitudeHandshakeMashonaland, Location.provinceMashonaland),
      (Piece.blackAttitudeHandshakeManicaland, Location.provinceManicaland),
      (Piece.blackAttitudeHandshakeVictoria, Location.provinceVictoria),
      (Piece.markerBritishRule, Location.frontLineBotswana),
      (Piece.markerTerrorLevel, Location.terror1),
      (Piece.foreignBritainAnti, Location.boxUKGovernment),
      (Piece.foreignUSAAnti, Location.boxUSAGovernment),
      (Piece.foreignSouthAfricaPro, Location.boxSouthAfricaGovernment),
      (Piece.politicianZambiaKaunda, Location.frontLineZambia),
      (Piece.politicianTanzaniaNyerere, Location.frontLineTanzania),
      (Piece.politicianBlackMugabe, Location.boxWhaWhaPrison),
      (Piece.politicianBlackSithole, Location.boxWhaWhaPrison),
      (Piece.politicianBlackNkomo, Location.boxWhaWhaPrison),
      // Should be under player control, but makes no difference ?
      (Piece.troopieRhodesiaRAR1, Location.salisbury),
      (Piece.troopieRhodesiaRLI, Location.salisbury),
      (Piece.troopieRhodesiaSAS, Location.salisbury),
      (Piece.troopieRhodesiaBSAP, Location.salisbury),
      (Piece.politicianBlackMuzorewa, Location.provinceManicaland),
      (Piece.politicianBlackChitepo, Location.regionZambia),
    ]);

    final policies = [Piece.policyProvincialCouncils, Piece.policyExerciseAlcora, Piece.policyLandTenureAct];
    policies.shuffle(random);
    state.setPieceLocation(policies[0], Location.turn2);
    policies.removeAt(0);
    for (int index = 3; index < PieceType.policyFront.count; ++index) {
      policies.add(Piece.values[PieceType.policyFront.firstIndex + index]);
      policies.shuffle(random);
      state.setPieceLocation(policies[0], Location.values[Location.turn0.index + index]);
      policies.removeAt(0);
    }
    state.setPieceLocation(policies[0], Location.turn14);
    state.setPieceLocation(policies[1], Location.turn15);
    if (state.pieceLocation(Piece.policyLandTenureAct).index > state.pieceLocation(Piece.policyLandTenureAmendment).index) {
      final location = state.pieceLocation(Piece.policyLandTenureAct);
      state.setPieceLocation(Piece.policyLandTenureAct, state.pieceLocation(Piece.policyLandTenureAmendment));
      state.setPieceLocation(Piece.policyLandTenureAmendment, location);
    }

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
  rhodesiaHerald,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateRhodesiaHerald extends PhaseState {
  int result = 0;
  int? remainingCount;

  PhaseStateRhodesiaHerald();

  PhaseStateRhodesiaHerald.fromJson(Map<String, dynamic> json)
    : result = json['result'] as int
    , remainingCount = json['remainingCount'] as int?
    ;

  @override
  Map<String, dynamic> toJson() => {
    'result': result,
    'remainingCount': remainingCount,
  };

  @override
  Phase get phase {
    return Phase.rhodesiaHerald;
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
      case Phase.rhodesiaHerald:
        _phaseState = PhaseStateRhodesiaHerald.fromJson(phaseStateJson);
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
      logLine('> Treasury: +$delta → ${_state.treasury}');
    } else if (delta < 0) {
      logLine('> Treasury: $delta → ${_state.treasury}');
    }
  }

  void adjustPopulation(int delta) {
    _state.adjustPopulation(delta);
    if (delta > 0) {
      logLine('> Population: +$delta → ${_state.population}');
    } else if (delta < 0) {
      logLine('> Population: $delta → ${_state.population}');
    }
  }

  void populationUp() {
    if (!_state.populationUp) {
      logLine('> Population starts to increase.');
      _state.flipPiece(_state.populationMarker);
    }
  }

  void populationDown() {
    if (_state.populationUp) {
      logLine('> Population starts to decline.');
      _state.flipPiece(_state.populationMarker);
    }
  }

  void adjustTerror(int delta) {
    bool overflow = _state.adjustTerror(delta);
    if (delta > 0) {
      logLine('> Terror Level: +$delta => ${_state.terror}');
    } else {
      logLine('> Terror Level: $delta => ${_state.terror}');
    }
    if (overflow) {
      deployTerrorists(1);
    }
  }

  void adjustRFPopularity(int delta) {
    _state.adjustRFPopularity(delta);
    if (delta > 0) {
      logLine('> RF Popularity: +$delta => ${_state.rfPopularity}');
    } else {
      logLine('> RF Popularity: $delta => ${_state.rfPopularity}');
    }
  }

  // High-Level Functions

  List<Piece> get candidateRadioTVTroopies {
    int lowestStrength = 5;
    List<Piece> candidates = <Piece>[];
    for (final troopie in PieceType.troopieRhodesiaUnused.pieces) {
      if (_state.pieceLocation(troopie) == Location.poolForce) {
        int strength = _state.troopieStrength(troopie);
        if (strength < lowestStrength) {
          candidates = [troopie];
          lowestStrength = strength;
        } else if (strength == lowestStrength) {
          candidates.add(troopie);
        }
      }
    }
    return candidates;
  }

  void deployTerrorists(int count) {
    for (int i = 0; i < count; ++i) {
      if (_state.piecesInLocationCount(PieceType.terrUnused, Location.poolForce) == 0) {
        return;
      }
      int die = rollD6();
      Location? region;
      PieceType pieceType = PieceType.terrZanuUnused;
      switch (die) {
      case 1:
        region = Location.regionZambia;
        pieceType = PieceType.terrZapuUnused;
      case 2:
        region = Location.regionBotswana;
        pieceType = PieceType.terrZapuUnused;
      case 3:
      case 4:
        region = Location.regionMocambique;
      case 5:
      case 6:
        region = Location.regionTete;
      }
      if (_state.piecesInLocationCount(pieceType, Location.poolForce) == 0) {
        if (pieceType == PieceType.terrZapuUnused) {
          region = Location.regionTete;
          pieceType = PieceType.terrZanuUnused;
        } else {
          region = Location.regionZambia;
          pieceType = PieceType.terrZapuUnused;
        }
      }
      final terr = _state.piecesInLocation(pieceType, region!)[0];
      logLine('> ${terr.desc} deploys in ${region.desc}.');
      _state.setPieceLocation(terr, region);
    }
  }

  void britishElection() {
    _state.setPieceLocation(Piece.markerBritishElection, _state.futureTurnBox(5));
    int die = rollD6();
    final oldGovernment = _state.pieceInLocation(PieceType.foreignBritain, Location.boxUKGovernment);
    if (die <= 3) {
      if (oldGovernment == Piece.foreignBritainAnti) {
        logLine('> Labour remains in power.');
      } else {
        logLine('> Conservative party wins the election.');
        adjustTerror(-1);
      }
    } else {
      if (oldGovernment == Piece.foreignBritainPro) {
        logLine('> Tories remain in power.');
      } else {
        logLine('> Labour party wins the election.');
        adjustTerror(1);
      }
    }
  }

  void lancasterHouse() {
    logLine('> Peace conferences is held in Lancaster House in London.');
    int total = 0;
    int handshakeCount = 5 - _state.fistCount;
    logLine('> Handshake markers: +$handshakeCount');
    total += handshakeCount;
    if (_state.rfPopularity > 0) {
      logLine('> RF popularity: +${_state.rfPopularity}');
    } else {
      logLine('> RF popularity: ${_state.rfPopularity}');
    }
    total += _state.rfPopularity;
    if (_state.populationUp) {
      logLine('> Population rising: +2');
      total += 2;
    } else {
      logLine('> Population falling: -2');
      total -= 2;
    }
    if (_state.pieceLocation(Piece.politicianZambiaKaunda) == Location.frontLineZambia) {
      logLine('> Kaunda in Zambia: +1');
      total += 1;
    }
    if (_state.pieceLocation(Piece.foreignPortugalMocambique) == Location.frontLineMocambique) {
      logLine('> Portual in Moçambique: +1');
      total += 1;
    }
    if (_state.pieceLocation(Piece.foreignPortugalTete) == Location.frontLineTete) {
      logLine('> Portugal in Tete: +1');
      total += 1;
    }
    if (_state.pieceLocation(Piece.politicianUsReagan) == Location.boxUSPresident) {
      logLine('> President Reagan: +1');
      total += 1;
    }
    if (_state.pieceLocation(Piece.foreignSouthAfricaPro) == Location.boxSouthAfricaGovernment) {
      logLine('> Friendly South African government: +1');
      total += 1;
    }
    if (_state.pieceLocation(Piece.politicianTanzaniaCoup) == Location.frontLineTanzania) {
      logLine('> Nyerere ousted from Tanzania: +1');
      total += 1;
    }
    if (_state.pieceLocation(Piece.foreignBritainPro) == Location.boxUKGovernment) {
      logLine('> Conservative UK government: +1');
      total += 1;
    }
    if (_state.pieceLocation(Piece.foreignUSAPro) == Location.boxUSAGovernment) {
      logLine('> Republican US government: +1');
      total += 1;
    }
    

  }
  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
  }

  // Sequence Helpers

  // Events

  void event4DollarGift() {
    logLine('### \$4 Gift');
    logLine('> Foreign anti‐communists pour cash into Rhodesia’s treasury.');
    adjustTreasury(4);
  }

  void eventAirRhodesia() {
    logLine('### Air Rhodesia');
    logLine('> Smugglers buy jumbo jets on the black market.');
    adjustRFPopularity(3);
  }

  void eventAtrocity() {
    logLine('### Atrocity');
    final results = roll2D6();
    int dh = max(results.$1, results.$2);
    int dl = min(results.$1, results.$2);
    if (dh == dl) {
      Piece? politicianFront;
      switch (dh) {
      case 1:
        politicianFront = Piece.politicianBlackMugabe;
      case 2:
        politicianFront = Piece.politicianBlackNkomo;
      case 3:
      case 4:
        politicianFront = Piece.politicianBlackChitepo;
      case 5:
        politicianFront = Piece.politicianBlackSithole;
      case 6:
        politicianFront = Piece.politicianBlackMuzorewa;
      }
      final location = _state.pieceLocation(_state.politician(politicianFront!));
      if ([Location.boxWhaWhaPrison, Location.discarded].contains(location)) {
        logLine('> Assassination plot is abandoned.');
      } else {
        logLine('> ${politicianFront.desc} is assassinated.');
        _state.setPieceLocation(politicianFront, Location.discarded);
      }
    } else {
      switch (dh) {
      case 2:
        logLine('> Terrorists massacre Church Group.');
      case 3:
        logLine('> Urban bombing in Salisbury.');
      case 4:
        logLine('> Civilian plane shot down.');
        adjustPopulation(-_state.fistCount);
      case 5:
        logLine('> Black schoolchildren kidnapped.');
        adjustTerror(1);
      case 6:
        logLine('> White farmers targeted.');
        adjustPopulation(-1);
      }
      Piece? politicianFront;
      switch (dl) {
      case 1:
        politicianFront = Piece.politicianBlackMugabe;
      case 2:
      case 5:
        politicianFront = Piece.politicianBlackNkomo;
      case 3:
        politicianFront = Piece.politicianBlackChitepo;
      case 4:
        politicianFront = Piece.politicianBlackSithole;
      }
      final location = _state.pieceLocation(_state.politician(politicianFront!));
      if ([Location.boxWhaWhaPrison, Location.discarded].contains(location)) {
        politicianFront = null;
      }
      if (politicianFront != null) {
        logLine('> ${politicianFront.desc} is held responsible.');
        if (politicianFront == Piece.politicianBlackMugabe) {
          adjustTerror(1);
        } else if (location == Location.boxCollaborators) {
          _state.setPieceLocation(_state.politician(politicianFront!), Location.regionZambia);
        }
      }
    }
 }

  void eventBeiraAirstrike() {
    if (_state.pieceLocation(Piece.foreignBritainAnti) == Location.flipped) {
      return;
    }
    if (_state.pieceLocation(Piece.foreignPortugalMocambique) != Location.regionMocambique) {
      return;
    }
    logLine('### Beira Airstrike?');
    int die = rollD6();
    if (die == 6) {
      logLine('> British Labour Government bombs the Portuguese harbor at Beira, resulting in a diplomatic débâcle');
      _state.flipPiece(Piece.foreignBritainAnti);
      adjustTerror(-1);
    } else {
      logLine('> British Labour Government takes no action.');
    }
  }

  void eventBrazilianTroopsToAngola() {
    if (_state.pieceLocation(Piece.foreignPortugalMocambique) != Location.frontLineMocambique) {
      return;
    }
    logLine('### Brazilian Troops to Angola?');
    int die = rollD6();
    if (die == 6) {
      logLine('> Brazil sends troops to Angola to fight communism.');
      adjustTerror(-1);
    } else {
      logLine('> Brazil decides not to send troops.');
    }
  }

  void eventBritishElection() {
    logLine('### British Election');
    logLine('> A snap election is called.');
    britishElection();
  }

  void eventCaboraBassaDam() {
    logLine('### Cabora Bassa Dam');
    if (_state.pieceLocation(Piece.foreignPortugalTete) == Location.regionTete) {
      logLine('> Guerillas take control of strategic dam.');
      _state.setPieceLocation(Piece.foreignPortugalTete, Location.discarded);
    } else {
      logLine('> Portuguese wrest control of strategic dam from guerrillas.');
      _state.setPieceLocation(Piece.foreignPortugalTete, Location.regionTete);
    }
  }

  void eventChurchStateFriction() {
    logLine('### Church–State Friction');
    logLine('> GOvernment cracks down on liberal Christian activists.');
    adjustRFPopularity(-1);
  }

  void eventCommonwealthConference() {
    if (_state.pieceLocation(Piece.foreignBritainAnti) == Location.boxUKGovernment) {
      return;
    }
    logLine('### Commonwealth Conference');
    int die = rollD6();
    if (die >= 5) {
      logLine('> Tories are blackmailed by Third World countries in the British Commonwealth.');
      _state.setPieceLocation(Piece.foreignBritainAnti, Location.boxUKGovernment);
      adjustTerror(1);
    } else {
      logLine('> Lobbying by Third World countries in the British Commonwealth is ignored.');
    }
  }

  void eventCommunistSubversion() {
    logLine('### Communist Subversion');
    logLine('> Arms and advisors flow in from Russia and China.');
    adjustTerror(1);
  }

  void eventCoupFico() {
    if (_state.pieceLocation(Piece.foreignPortugalMocambique) != Location.frontLineMocambique) {
      return;
    }
    logLine('### Coup/Fico!');
    logLine('> Right‐wing White settlers seize power in Moçambique.');
    _state.setPieceLocation(Piece.troopieRenamo1, Location.poolForce);
    _state.setPieceLocation(Piece.troopieRenamo2, Location.poolForce);
    adjustTerror(1);
    _state.setPieceLocation(Piece.troopiePortugalFlechas, Location.discarded);
    _state.setPieceLocation(Piece.troopiePortugalGruposEspecials, Location.discarded);
    _state.setPieceLocation(Piece.policyExerciseAlcoraEnacted, Location.discarded);
    _state.setPieceLocation(Piece.markerFico, Location.frontLineMocambique);
  }

  void eventCoupInPortugal() {
    if (_state.pieceLocation(Piece.foreignPortugalMocambique) != Location.frontLineMocambique) {
      return;
    }
    logLine('### Coup in Portugal!');
    logLine('> Portuguese leave Africa after a 500‐year occupatin.');
    _state.setPieceLocation(Piece.troopieRenamo1, Location.poolForce);
    _state.setPieceLocation(Piece.troopieRenamo2, Location.poolForce);
    adjustTerror(1);
    _state.setPieceLocation(Piece.troopiePortugalFlechas, Location.discarded);
    _state.setPieceLocation(Piece.troopiePortugalGruposEspecials, Location.discarded);
    _state.setPieceLocation(Piece.policyExerciseAlcoraEnacted, Location.discarded);
  }

  void eventCoupRumoursInTanzania() {
    logLine('### Coup Rumors in Tanzania');
    final results = roll2D6();
    if (results.$3 == 12) {
      final piece = _state.pieceInLocation(PieceType.politicianTananzia, Location.frontLineTanzania)!;
      if (piece == Piece.politicianTanzaniaNyerere) {
        logLine('> Coup ousts Nyerere in Tanzania.');
        adjustTerror(-1);
      } else {
        logLine('> Coup restores Nyerere in Tanzania.');
        adjustTerror(1);
      }
      _state.flipPiece(piece);
    } else {
      logLine('> Rumors unfounded.');
    }
  }

  void eventDrought() {
    if (!_state.populationUp && _state.fistCount == 0) {
      return;
    }
    logLine('### Drought');
    logLine('> Farmers flee.');
    populationDown();
    adjustPopulation(-_state.fistCount);
  }

  void eventFactionsFeudInZambia() {
    final phaseState = _phaseState as PhaseStateRhodesiaHerald;
    final candidates = <Piece>[];
    for (final terr in PieceType.terrZanuUnused.pieces) {
      final location = _state.pieceLocation(terr);
      if (location.isType(LocationType.province) || [Location.salisbury, Location.regionZambia].contains(location)) {
        candidates.add(terr);
      }
    }
    if (candidates.isEmpty) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Factions Feud in Zambia');
      phaseState.remainingCount = 2;
      _subStep = 1;
    }
    if (_subStep == 1) {
      while (phaseState.remainingCount! > 0) {
        final candidates = <Piece>[];
        for (final unit in candidates) {
          candidates.add(unit);
        }
        if (candidates.isEmpty) {
          break;
        }
        if (choicesEmpty()) {
          setPrompt('Select ZAPU unit to eliminate');
          for (final unit in candidates) {
            pieceChoosable(unit);
          }
          throw PlayerChoiceException();
        }
        final unit = selectedPiece()!;
        final location = _state.pieceLocation(unit);
        logLine('> ZAPU unit in ${location.desc} is eliminated.');
        _state.setPieceLocation(unit, Location.poolForce);
        phaseState.remainingCount = phaseState.remainingCount! - 1;
      }
      phaseState.remainingCount = null;
    }
  }

  void eventFloodsInMocambique() {
    if (_subStep == 0) {
      logLine('### Floods in Moçambique');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Send aid?');
        choiceChoosable(Choice.yes, _state.treasury >= 2);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        logLine('> Rhodesia sends aid.');
        adjustTreasury(-2);
        adjustTerror(-1);
      } else {
        logLine('> Rhodesia does not send aid.');
      }
      clearChoices();
    }
  }

  void eventJesseHelms() {
    if (_state.pieceLocation(Piece.foreignUSAPro) != Location.boxUSAGovernment) {
      return;
    }
    if (_state.pieceLocation(Piece.markerSanctions) != Location.boxGlobalTrade) {
      return;
    }
    logLine('### Jesse Helms');
    int die = rollD6();
    if (die == 6) {
      logLine('> Hard‐line Southern senators end US sanctions.');
      _state.setPieceLocation(Piece.markerSanctions, Location.discarded);
    }
  }

  void eventLancasterHouse() {
    if (_state.pieceLocation(Piece.markerZimbabweRhodesia) != Location.boxRhodesia) {
      return;
    }
    logLine('### Lancaster House');
    lancasterHouse();
  }

  void eventOperationSenekal() {

  }

  void eventOutrage() {
    int troopiesOnForeignSoilCount = 0;
    for (final pieceType in [PieceType.troopieRhodesiaSouthAfricaUnused, PieceType.troopieRhodesiaSouthAfricaUsed]) {
      for (final troopie in pieceType.pieces) {
        if (_state.pieceLocation(troopie).isType(LocationType.region)) {
          troopiesOnForeignSoilCount += 1;
        }
      }
    }
    if (troopiesOnForeignSoilCount == 0) {
      return;
    }
    logLine('### Outrage');
    logLine('> Rhodesian ground troops are caught conducting cross-border raids.');
    int count = 0;
    for (final piece in [Piece.foreignBritainPro, Piece.foreignSouthAfricaPro, Piece.foreignUSAPro]) {
      if (_state.pieceLocation(piece) != Location.flipped) {
        switch (piece) {
        case Piece.foreignBritainPro:
          logLine('> British Government turns against the Rhodesian regime.');
        case Piece.foreignSouthAfricaPro:
          logLine('> South African Government turns against the Rhodesian regime.');
        case Piece.foreignUSAPro:
          logLine('> US Government turns against the Rhodesian regime.');
        default:
        }
        _state.flipPiece(piece);
        count += 1;
      }
    }
    if (count > 0) {
      adjustTerror(count);
    }
  }

  void eventRadioTV() {
    if (_subStep == 0) {
      logLine('### Radio/TV');
      adjustRFPopularity(1);
      if (_state.pieceLocation(Piece.foreignPortugalMocambique) != Location.regionMocambique && _state.pieceLocation(Piece.markerFico) != Location.regionMocambique) {
        return;
      }
      if (candidateRadioTVTroopies.isEmpty) {
        return;
      }
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select Troopie to deploy to Salisbury');
        for (final troopie in candidateRadioTVTroopies) {
          pieceChoosable(troopie);
        }
        throw PlayerChoiceException();
      }
      final troopie = selectedPiece()!;
      logLine('> ${troopie.desc} deploys to Salisbury.');
      clearChoices();
    }
  }

  void eventRampages() {

  }

  void eventSanctions() {
    if (_state.pieceLocation(Piece.markerSanctions) == Location.boxGlobalTrade) {
      return;
    }
    logLine('### Sanctions');
    _state.setPieceLocation(Piece.markerSanctions, Location.boxGlobalTrade);
  }

  void eventSinoSovietSplit() {
    logLine('### Sino–Soviet Split');
    logLine('> IDeological feuds draw resources away from Africa.');
    adjustTerror(-1);
  }

  void eventSoldierOfFortune() {
    logLine('### Soldier of Fortune');
    logLine('> Vietnam vets flock to Rhodesia.');
    final handshakeCount = _state.piecesInLocationCount(PieceType.blackAttitudeFist, Location.flipped);
    adjustPopulation(handshakeCount + 3);
    if (_state.pieceLocation(Piece.markerPopulationUp) == Location.flipped) {
      _state.flipPiece(Piece.markerPopulationDown);
    }
  }

  void eventSouthAfricaShakeUp() {
    logLine('### South Africa Shake‐Up');
    final piece = _state.pieceInLocation(PieceType.foreignSouthAfrica, Location.boxSouthAfricaGovernment)!;
    int die = rollD6();
    if (die <= 3) {
      if (piece == Piece.foreignSouthAfricaAnti) {
        logLine('> New South African government is pro‐Rhodesia.');
        adjustTerror(-1);
      } else {
        logLine('> New South African government is anti‐Rhodesia.');
        adjustTerror(1);
      }
      _state.flipPiece(piece);
    } else {
      if (piece == Piece.foreignSouthAfricaAnti) {
        logLine('> New South African government remains anti‐Rhodesia.');
      } else {
        logLine('> New South African government remains pro‐Rhodesia.');
      }
    }
  }

  void eventSpecialBranch() {
    if (_state.treasury == 0) {
      return;
    }
    final candidates = <Piece>[];
    for (final terr in PieceType.terrUnused.pieces) {
      final location = _state.pieceLocation(terr);
      if (location.isType(LocationType.provinceOrRegion)) {
        candidates.add(terr);
      }
    }
    if (candidates.isEmpty) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Special Branch');
      logLine('> Rhodesian spies plant evidence to make Terr leaders look like informants.');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select Terr unit to remove');
        for (final terr in candidates) {
          pieceChoosable(terr);
        }
        throw PlayerChoiceException();
      }
      final terr = selectedPiece()!;
      final location = _state.pieceLocation(terr);
      adjustTreasury(-1);
      logLine('> ${terr.desc} in ${location.desc} is eliminated.');
      _state.setPieceLocation(terr, Location.poolForce);
    }
  }

  void eventTanZamRailway() {

  }

  void eventToryConference() {

  }

  void eventTribalism() {

  }

  void eventWarInAngola() {

  }

  void eventWatergateScandal() {

  }

  void eventZanuFactionalism() {
    final phaseState = _phaseState as PhaseStateRhodesiaHerald;
    if (_subStep == 0) {
      logLine('### ZANU Factionalism');
      int count = 2;
      if (_state.pieceLocation(Piece.politicianBlackMugabeZanu) != Location.boxZanuLeadership) {
        count = rollD6();
      }
      phaseState.remainingCount = count;
      _subStep = 1;
    }
    if (_subStep == 1) {
      while (phaseState.remainingCount! > 0) {
        final candidates = <Piece>[];
        for (final unit in PieceType.terrZanuUnused.pieces) {
          final location = _state.pieceLocation(unit);
          if (location.isType(LocationType.provinceOrRegion)) {
            candidates.add(unit);
          }
        }
        if (candidates.isEmpty) {
          break;
        }
        if (choicesEmpty()) {
          setPrompt('Select ZANU unit to eliminate');
          for (final unit in candidates) {
            pieceChoosable(unit);
          }
          throw PlayerChoiceException();
        }
        final unit = selectedPiece()!;
        final location = _state.pieceLocation(unit);
        logLine('> ZANU unit in ${location.desc} is eliminated.');
        _state.setPieceLocation(unit, Location.poolForce);
        phaseState.remainingCount = phaseState.remainingCount! - 1;
      }
      phaseState.remainingCount = null;
    }
  }

  // Sequence of Play

  void turnBegin() {
    logLine('# ${_state.turnName(_state.currentTurn)}');
  }

  void rhodesiaHeraldPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Rhodesia Herald Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Rhodesia Herald Phase');
    _phaseState = PhaseStateRhodesiaHerald();
  }

  void rhodesiaHeraldPhaseRoll() {
    final phaseState = _phaseState as PhaseStateRhodesiaHerald;
    logLine('> Rhodesia Herald');
    int die = rollD6();
    int total = _state.currentTurn + die;
    logLine('> Result: $total');
    phaseState.result = total;
  }

  void rhodesiaHeraldPhaseEvent(int index) {
    final phaseState = _phaseState as PhaseStateRhodesiaHerald;
    final events = {
      2: [eventSouthAfricaShakeUp, eventSoldierOfFortune, eventBeiraAirstrike, eventCaboraBassaDam, eventOutrage],
      3: [eventSouthAfricaShakeUp, eventSoldierOfFortune, eventBeiraAirstrike, eventCaboraBassaDam, eventOutrage],
      4: [eventCommunistSubversion, eventBrazilianTroopsToAngola, eventSanctions, eventRadioTV, eventSpecialBranch],
      5: [eventSouthAfricaShakeUp, eventDrought, eventSinoSovietSplit, eventSanctions, eventCaboraBassaDam, eventOutrage, eventBritishElection],
      6: [eventZanuFactionalism, event4DollarGift, eventSoldierOfFortune, eventCommunistSubversion, eventCaboraBassaDam],
      7: [eventZanuFactionalism, eventCoupRumoursInTanzania, eventCaboraBassaDam, eventRampages, eventSanctions, eventRadioTV],
      8: [eventCommonwealthConference, eventFactionsFeudInZambia, eventSinoSovietSplit, eventCaboraBassaDam, eventOutrage],
      9: [eventDrought, eventAtrocity, eventAirRhodesia, eventZanuFactionalism, eventCaboraBassaDam, eventTribalism, eventRadioTV],
      10: [eventSoldierOfFortune, eventWatergateScandal, eventCommunistSubversion, eventSpecialBranch, eventSanctions, eventRadioTV],
      11: [eventToryConference, eventSinoSovietSplit, eventBritishElection, eventSoldierOfFortune, eventOperationSenekal, eventOutrage],
      12: [eventCoupInPortugal, eventCoupRumoursInTanzania, eventTanZamRailway, eventCommunistSubversion, event4DollarGift],
      13: [eventSoldierOfFortune, eventFactionsFeudInZambia, eventSinoSovietSplit, eventFloodsInMocambique, eventWarInAngola],
      14: [eventDrought, eventAtrocity, eventFactionsFeudInZambia, eventChurchStateFriction, eventZanuFactionalism, eventOutrage],
      15: [eventCoupFico, eventSouthAfricaShakeUp, eventCommonwealthConference, eventCommunistSubversion, eventTribalism, eventRadioTV],
      16: [eventCoupInPortugal, eventCommunistSubversion, eventAtrocity, eventJesseHelms, eventRampages, eventSpecialBranch],
      17: [eventCoupInPortugal, eventDrought, eventZanuFactionalism, eventRampages, eventBritishElection, eventRadioTV, eventOutrage],
      18: [eventLancasterHouse, eventAtrocity, eventCommunistSubversion, eventTribalism, eventOutrage, eventTanZamRailway],
      19: [eventLancasterHouse, eventAtrocity, eventCommunistSubversion, eventTribalism, eventOutrage, eventTanZamRailway],
      20: [eventLancasterHouse, eventAtrocity, eventCommunistSubversion, eventTribalism, eventOutrage, eventTanZamRailway],
      21: [eventLancasterHouse, eventAtrocity, eventCommunistSubversion, eventTribalism, eventOutrage, eventTanZamRailway],
      22: [eventLancasterHouse, eventAtrocity, eventCommunistSubversion, eventTribalism, eventOutrage, eventTanZamRailway],
    };
    final eventHandlers = events[phaseState.result]!;
    if (index >= eventHandlers.length) {
      return;
    }
    eventHandlers[index]();
  }

  void rhodesiaHeraldPhaseEvent0() {
    rhodesiaHeraldPhaseEvent(0);
  }

  void rhodesiaHeraldPhaseEvent1() {
    rhodesiaHeraldPhaseEvent(1);
  }

  void rhodesiaHeraldPhaseEvent2() {
    rhodesiaHeraldPhaseEvent(2);
  }

  void rhodesiaHeraldPhaseEvent3() {
    rhodesiaHeraldPhaseEvent(3);
  }

  void rhodesiaHeraldPhaseEvent4() {
    rhodesiaHeraldPhaseEvent(4);
  }

  void rhodesiaHeraldPhaseEvent5() {
    rhodesiaHeraldPhaseEvent(5);
  }

  void rhodesiaHeraldPhaseEvent6() {
    rhodesiaHeraldPhaseEvent(6);
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      rhodesiaHeraldPhaseBegin,
      rhodesiaHeraldPhaseRoll,
      rhodesiaHeraldPhaseEvent0,
      rhodesiaHeraldPhaseEvent1,
      rhodesiaHeraldPhaseEvent2,
      rhodesiaHeraldPhaseEvent3,
      rhodesiaHeraldPhaseEvent4,
      rhodesiaHeraldPhaseEvent5,
      rhodesiaHeraldPhaseEvent6,
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

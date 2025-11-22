import 'dart:convert';
import 'dart:math';
import 'package:jeff_davis/db.dart';
import 'package:jeff_davis/random.dart';

enum Location {
  regionRichmond,
  regionHanoverCounty,
  regionTheRappahannock,
  regionManassas,
  regionWashingtonDC,
  regionLynchburg,
  regionShenandoahValley,
  regionHarpersFerry,
  regionMarylandAndPennsylvania,
  regionBermudaHundred,
  regionWilliamsburg,
  regionYorktown,
  regionFortMonroe,
  regionFayetteville,
  regionColumbia,
  regionSavannah,
  regionAtlanta,
  regionChattanooga,
  regionNashville,
  regionBowlingGreen,
  regionLouisville,
  regionCincinnati,
  regionVicksburg,
  regionJackson,
  regionTheDelta,
  regionMemphis,
  regionCorinth,
  regionPaducah,
  regionCairo,
  regionEastTexas,
  regionRedRiver,
  regionPortHudson,
  regionNewOrleans,
  regionShipIsland,
  portNewBern,
  portWilmington,
  portCharleston,
  portFernandina,
  portMobile,
  campaignNewMexico,
  campaignHeartlandOffensive,
  campaignMorgansRaid,
  campaignIndianTerritory,
  campaignArkansas,
  campaignKirksRaiders,
  campaignPriceInMissouri,
  boxCampaignRedStar,
  boxCampaignNewMexico,
  boxCampaignPeninsula,
  boxCampaignHeartlandOffensive,
  boxCampaignMorgansRaid,
  boxCampaignIndianTerritory,
  boxCampaignArkansas,
  boxCampaignKirksRaiders,
  boxCampaignPriceInMissouri,
  boxCampaignEconomicDisaster,
  boxDavisRevolution,
  boxAgriculture0,
  boxAgriculture1,
  boxAgriculture2,
  boxAgriculture3,
  boxAgriculture4,
  boxAgriculture5,
  boxAgriculture6,
  boxManufacture0,
  boxManufacture1,
  boxManufacture2,
  boxManufacture3,
  boxManufacture4,
  boxManufacture5,
  boxManufacture6,
  boxInfrastructure0,
  boxInfrastructure1,
  boxInfrastructure2,
  boxInfrastructure3,
  boxInfrastructure4,
  boxInfrastructure5,
  boxInfrastructure6,
  boxSlaveQuarters,
  boxFreedmen,
  boxConfederateGovernment,
  boxDisgruntledConfederates,
  poolCsaGenerals,
  boxBlockade1a,
  boxBlockade1b,
  boxBlockade2a,
  boxBlockade2b,
  boxBlockade2c,
  boxBlockade3,
  boxBlockade4,
  boxUnionFrigates,
  boxEnglishShipyards,
  boxBlockadeRunners,
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
  turn28,
  turn29,
  turn30,
  turn31,
  turn32,
  turn33,
  turn34,
  turn35,
  turn36,
  turn37,
  turn38,
  turn39,
  turn40,
  turn41,
  turn42,
  turn43,
  turn44,
  sack,
  trayTurn,
  trayConfederateForces,
  trayUnionForces,
  trayEconomic,
  trayOtherForces,
  trayPolitical,
  trayStrategic,
  trayMilitary,
  trayVarious,
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
  region,
  path1,
  path2,
  path3,
  path4,
  path5,
  path6,
  port,
  campaign,
  campaignTrack,
  agriculture,
  manufacture,
  infrastructure,
  blockadeBox,
  treasury,
  calendar,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.region: [Location.regionRichmond, Location.regionShipIsland],
    LocationType.path1: [Location.regionHanoverCounty, Location.regionWashingtonDC],
    LocationType.path2: [Location.regionLynchburg, Location.regionMarylandAndPennsylvania],
    LocationType.path3: [Location.regionBermudaHundred, Location.regionFortMonroe],
    LocationType.path4: [Location.regionFayetteville, Location.regionCincinnati],
    LocationType.path5: [Location.regionVicksburg, Location.regionCairo],
    LocationType.path6: [Location.regionEastTexas, Location.regionShipIsland],
    LocationType.port: [Location.portNewBern, Location.portMobile],
    LocationType.campaign: [Location.campaignNewMexico, Location.campaignPriceInMissouri],
    LocationType.campaignTrack: [Location.boxCampaignRedStar, Location.boxCampaignEconomicDisaster],
    LocationType.agriculture: [Location.boxAgriculture0, Location.boxAgriculture6],
    LocationType.manufacture: [Location.boxManufacture0, Location.boxManufacture6],
    LocationType.infrastructure: [Location.boxInfrastructure0, Location.boxInfrastructure6],
    LocationType.blockadeBox: [Location.boxBlockade1a, Location.boxBlockade4],
    LocationType.treasury: [Location.treasury0, Location.treasury9],
    LocationType.calendar: [Location.turn0, Location.turn44],
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
      Location.regionRichmond: 'Richmond',
      Location.regionHanoverCounty: 'Hanover County',
      Location.regionTheRappahannock: 'The Rappahannock',
      Location.regionManassas: 'Manassas',
      Location.regionWashingtonDC: 'Washington D.C.',
      Location.regionLynchburg: 'Lynchburg',
      Location.regionShenandoahValley: 'Shenandoah Valley',
      Location.regionHarpersFerry: 'Harper’s Ferry',
      Location.regionMarylandAndPennsylvania: 'Maryland & Pennsylvania',
      Location.regionBermudaHundred: 'Bermuda Hundred',
      Location.regionWilliamsburg: 'Williamsburg',
      Location.regionYorktown: 'Yorktown',
      Location.regionFortMonroe: 'Fort Monroe',
      Location.regionFayetteville: 'Fayetteville',
      Location.regionColumbia: 'Columbia',
      Location.regionSavannah: 'Savannah',
      Location.regionAtlanta: 'Atlanta',
      Location.regionChattanooga: 'Chattanooga',
      Location.regionNashville: 'Nashville',
      Location.regionBowlingGreen: 'Bowling Green',
      Location.regionLouisville: 'Louisville',
      Location.regionCincinnati: 'Cincinnati',
      Location.regionVicksburg: 'Vicksburg',
      Location.regionJackson: 'Jackson',
      Location.regionTheDelta: 'The Delta',
      Location.regionMemphis: 'Memphis',
      Location.regionCorinth: 'Corinth',
      Location.regionPaducah: 'Paducah',
      Location.regionCairo: 'Cairo',
      Location.regionEastTexas: 'East Texas',
      Location.regionRedRiver: 'Red River',
      Location.regionPortHudson: 'Port Hudson',
      Location.regionNewOrleans: 'New Orleans',
      Location.regionShipIsland: 'Ship Island',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Path {
  path1,
  path2,
  path3,
  path4,
  path5,
  path6,
}

extension PathExtension on Path {
  String get desc {
    const pathDescs = {
      Path.path1: 'Path 1',
      Path.path2: 'Path 2',
      Path.path3: 'Path 3',
      Path.path4: 'Path 4',
      Path.path5: 'Path 5',
      Path.path6: 'Path 6',
    };
    return pathDescs[this]!;
  }
}

enum Piece {
  general2Lee0,
  general2Lee1,
  general2Lee2,
  general2Jackson0,
  general2Jackson1,
  general2Longstreet,
  general2Pemberton,
  general2Beauregard,
  general2Early,
  general2Hardee,
  general2Hood,
  general2ASJohnston,
  general2JJohnston,
  general2Ewell,
  general2Bragg,
  general2APHill,
  general2Stuart0,
  general2Stuart1,
  general2VanDorn,
  generalBritish2,
  generalFrench2,
  general1Lee0,
  general1Lee1,
  general1Lee2,
  general1Jackson0,
  general1Jackson1,
  general1Longstreet,
  general1Pemberton,
  general1Beauregard,
  general1Early,
  general1Hardee,
  general1Hood,
  general1ASJohnston,
  general1JJohnston,
  general1Ewell,
  general1Bragg,
  general1APHill,
  general1Stuart0,
  general1Stuart1,
  general1VanDorn,
  generalBritish1,
  generalFrench1,
  artillery0,
  artillery1,
  artillery2,
  artillery3,
  ironclad0,
  ironclad1,
  ironclad2,
  ironclad3,
  defensiveWorks0,
  defensiveWorks1,
  defensiveWorks2,
  defensiveWorks3,
  train0,
  train1,
  train2,
  train3,
  trenches,
  bushwhacker0,
  bushwhacker1,
  bushwhacker2,
  bushwhacker3,
  cavalry2Stuart,
  cavalry2Wheeler,
  cavalry1Hampton,
  cavalry1Forrest,
  cssHunley,
  armyMcClellan0,
  armyMcClellan1,
  armyMiddleDepartment,
  armyCumberland,
  armyGulf,
  armyButler,
  armyGrant4,
  armyPotomac,
  armyJames,
  armySheridan,
  armySherman,
  armyBanks,
  armyGrant5,
  freedmen2_0,
  freedmen2_1,
  freedmen2_2,
  freedmen2_3,
  freedmen1_0,
  freedmen1_1,
  freedmen1_2,
  freedmen1_3,
  lincoln,
  washingtonInPanic,
  sustainedOffensive,
  surpriseOffensive,
  grantPromoted,
  agricultureLevel,
  manufactureLevel,
  infrastructureLevel,
  plantation0,
  plantation1,
  plantation2,
  plantation3,
  plantationDepleted0,
  plantationDepleted1,
  plantationDepleted2,
  plantationDepleted3,
  rrCompany0,
  rrCompany1,
  rrCompany2,
  rrCompany3,
  factory0,
  factory1,
  factory2,
  factory3,
  usBase0,
  usBase1,
  usBase2,
  usBase3,
  usBase4,
  usBase5,
  usBase6,
  usBase7,
  slaves2_0,
  slaves2_1,
  slaves2_2,
  slaves2_3,
  slaves2_4,
  slaves2_5,
  slaves2_6,
  slaves2_7,
  slaves1_0,
  slaves1_1,
  slaves1_2,
  slaves1_3,
  slaves1_4,
  slaves1_5,
  slaves1_6,
  slaves1_7,
  anaconda0,
  anaconda1,
  anaconda2,
  anaconda3,
  frigate0,
  frigate1,
  frigate2,
  frigate3,
  blockadeRunner0,
  blockadeRunner1,
  blockadeRunner2,
  blockadeRunner3,
  politicianDavis,
  politicianXDavis,
  politicianStephens,
  politicianToombs,
  politicianHunter,
  politicianBenjamin,
  politicianReagan,
  politicianRandolph,
  politicianSeddon,
  politicianMallory,
  politicianWatts,
  politicianMemminger,
  politicianTrenholm,
  politicianXStephens,
  politicianXToombs,
  politicianXHunter,
  politicianXBenjamin,
  politicianXReagan,
  politicianXRandolph,
  politicianXSeddon,
  politicianXMallory,
  politicianXWatts,
  politicianXMemminger,
  politicianXTrenholm,
  kentuckyNeutral0,
  kentuckyNeutral1,
  kentuckyNeutral2,
  missouriRebel2_0,
  missouriRebel2_1,
  missouriRebel2_2,
  missouriRebel1_0,
  missouriRebel1_1,
  missouriRebel1_2,
  linesCutP1_0,
  linesCutP1_1,
  linesCutP1_2,
  linesCutP1_3,
  linesCutP1_4,
  linesCutN1_0,
  linesCutN1_1,
  linesCutN1_2,
  linesCutN1_3,
  linesCutN1_4,
  campaignModifierShelbyP1,
  campaignModifierIndianWatieP1,
  campaignModifierIndianChoctawP1,
  campaignModifierKentuckyRebelP1,
  campaignModifierKentuckyUnionN1,
  campaignSuccess0,
  campaignSuccess1,
  campaignSuccess2,
  campaignSuccess3,
  campaignSuccess4,
  campaignSuccess5,
  campaignSuccess6,
  campaignFailure0,
  campaignFailure1,
  campaignFailure2,
  campaignFailure3,
  campaignFailure4,
  campaignFailure5,
  campaignFailure6,
  campaignResultMormonRebels,
  nextCampaign,
  crisis,
  csaTreasury,
  specialBudget,
  statesRights,
  lostCause,
  objective,
  closed0,
  closed1,
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
  turnChit29,
  turnChit30,
  turnChit31,
  turnChit32,
  turnChit33,
  turnChit34,
  turnChit35,
  turnChit36,
  turnChit37,
  turnChit38,
  turnChit39,
  turnChit40,
  turnChit41,
  turnChit42,
  turnChit43,
  turnChit44,
  turnChitCoatOfArms1,
  turnChitCoatOfArms2,
  turnChitCoatOfArms3,
  turnChitCoatOfArms4,
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
  rebelUnit,
  general,
  general2,
  general1,
  artillery,
  ironclad,
  defensiveWorks,
  train,
  bushwhacker,
  cavalry,
  cavalry2,
  cavalry1,
  army,
  armyFront,
  freedmen2,
  freedmen1,
  asset,
  plantation,
  plantationUndepleted,
  rrCompany,
  factory,
  usBase,
  slaves,
  slaves2,
  slaves1,
  anaconda,
  frigate,
  blockadeRunner,
  regularPolitician,
  regularPoliticianUnused,
  kentuckyNeutral,
  missouriRebel2,
  missouriRebel1,
  linesCut,
  linesCutP1,
  campaignModifier,
  campaignModifierP1,
  campaignModifierP1Indian,
  campaignSuccess,
  closed,
  treasury,
  turnChit,
  turnChitGreenCoatOfArms,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.general2Lee0, Piece.turnChitCoatOfArms4],
    PieceType.rebelUnit: [Piece.general2Lee0, Piece.artillery3],
    PieceType.general: [Piece.general2Lee0, Piece.generalFrench1],
    PieceType.general2: [Piece.general2Lee0, Piece.generalFrench2],
    PieceType.general1: [Piece.general1Lee0, Piece.generalFrench1],
    PieceType.artillery: [Piece.artillery0, Piece.artillery3],
    PieceType.ironclad: [Piece.ironclad0, Piece.ironclad3],
    PieceType.defensiveWorks: [Piece.defensiveWorks0, Piece.defensiveWorks3],
    PieceType.train: [Piece.train0, Piece.train3],
    PieceType.bushwhacker: [Piece.bushwhacker0, Piece.bushwhacker3],
    PieceType.cavalry: [Piece.cavalry2Stuart, Piece.cavalry1Forrest],
    PieceType.cavalry2: [Piece.cavalry2Stuart, Piece.cavalry2Wheeler],
    PieceType.cavalry1: [Piece.cavalry1Hampton, Piece.cavalry1Forrest],
    PieceType.army: [Piece.armyMcClellan0, Piece.armyGrant5],
    PieceType.armyFront: [Piece.armyMcClellan0, Piece.armyGrant4],
    PieceType.freedmen2: [Piece.freedmen2_0, Piece.freedmen2_3],
    PieceType.freedmen1: [Piece.freedmen1_0, Piece.freedmen1_3],
    PieceType.asset: [Piece.plantation0, Piece.factory3],
    PieceType.plantation: [Piece.plantation0, Piece.plantationDepleted3],
    PieceType.plantationUndepleted: [Piece.plantation0, Piece.plantation3],
    PieceType.rrCompany: [Piece.rrCompany0, Piece.rrCompany3],
    PieceType.factory: [Piece.factory0, Piece.factory3],
    PieceType.usBase: [Piece.usBase0, Piece.usBase7],
    PieceType.slaves: [Piece.slaves2_0, Piece.slaves1_7],
    PieceType.slaves2: [Piece.slaves2_0, Piece.slaves2_7],
    PieceType.slaves1: [Piece.slaves1_0, Piece.slaves1_7],
    PieceType.anaconda: [Piece.anaconda0, Piece.anaconda3],
    PieceType.frigate: [Piece.frigate0, Piece.frigate3],
    PieceType.blockadeRunner: [Piece.blockadeRunner0, Piece.blockadeRunner3],
    PieceType.regularPolitician: [Piece.politicianStephens, Piece.politicianXTrenholm],
    PieceType.regularPoliticianUnused: [Piece.politicianStephens, Piece.politicianTrenholm],
    PieceType.kentuckyNeutral: [Piece.kentuckyNeutral0, Piece.kentuckyNeutral2],
    PieceType.missouriRebel2: [Piece.missouriRebel2_0, Piece.missouriRebel2_2],
    PieceType.missouriRebel1: [Piece.missouriRebel1_0, Piece.missouriRebel1_2],
    PieceType.linesCut: [Piece.linesCutP1_0, Piece.linesCutN1_4],
    PieceType.linesCutP1: [Piece.linesCutP1_0, Piece.linesCutP1_4],
    PieceType.campaignModifierP1: [Piece.campaignModifierShelbyP1, Piece.campaignModifierKentuckyRebelP1],
    PieceType.campaignModifierP1Indian: [Piece.campaignModifierIndianWatieP1, Piece.campaignModifierIndianChoctawP1],
    PieceType.campaignSuccess: [Piece.campaignSuccess0, Piece.campaignSuccess6],
    PieceType.closed: [Piece.closed0, Piece.closed1],
    PieceType.treasury: [Piece.csaTreasury, Piece.specialBudget],
    PieceType.turnChit: [Piece.turnChit1, Piece.turnChit44],
    PieceType.turnChitGreenCoatOfArms: [Piece.turnChitCoatOfArms1, Piece.turnChitCoatOfArms4],
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

enum TurnChitPathColor {
  white,
  yellow,
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
      Scenario.standard: 'Standard (44 Turns)',
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
      Piece.general2Lee0: Piece.general1Lee0,
      Piece.general2Lee1: Piece.general1Lee1,
      Piece.general2Lee2: Piece.general1Lee2,
      Piece.general2Jackson0: Piece.general1Jackson0,
      Piece.general2Jackson1: Piece.general1Jackson1,
      Piece.general2Longstreet: Piece.general1Longstreet,
      Piece.general2Pemberton: Piece.general1Pemberton,
      Piece.general2Beauregard: Piece.general1Beauregard,
      Piece.general2Early: Piece.general1Early,
      Piece.general2Hardee: Piece.general1Hardee,
      Piece.general2Hood: Piece.general1Hood,
      Piece.general2ASJohnston: Piece.general1ASJohnston,
      Piece.general2JJohnston: Piece.general1JJohnston,
      Piece.general2Ewell: Piece.general1Ewell,
      Piece.general2Bragg: Piece.general1Bragg,
      Piece.general2APHill: Piece.general1APHill,
      Piece.general2Stuart0: Piece.general1Stuart0,
      Piece.general2Stuart1: Piece.general1Stuart1,
      Piece.general2VanDorn: Piece.general1VanDorn,
      Piece.generalBritish2: Piece.generalBritish1,
      Piece.generalFrench2: Piece.generalFrench1,
      Piece.general1Lee0: Piece.general2Lee0,
      Piece.general1Lee1: Piece.general2Lee1,
      Piece.general1Lee2: Piece.general2Lee2,
      Piece.general1Jackson0: Piece.general2Jackson0,
      Piece.general1Jackson1: Piece.general2Jackson1,
      Piece.general1Longstreet: Piece.general2Longstreet,
      Piece.general1Pemberton: Piece.general2Pemberton,
      Piece.general1Beauregard: Piece.general2Beauregard,
      Piece.general1Early: Piece.general2Early,
      Piece.general1Hardee: Piece.general2Hardee,
      Piece.general1Hood: Piece.general2Hood,
      Piece.general1ASJohnston: Piece.general2ASJohnston,
      Piece.general1JJohnston: Piece.general2JJohnston,
      Piece.general1Ewell: Piece.general2Ewell,
      Piece.general1Bragg: Piece.general2Bragg,
      Piece.general1APHill: Piece.general2APHill,
      Piece.general1Stuart0: Piece.general2Stuart0,
      Piece.general1Stuart1: Piece.general2Stuart1,
      Piece.general1VanDorn: Piece.general2VanDorn,
      Piece.generalBritish1: Piece.generalBritish2,
      Piece.generalFrench1: Piece.generalFrench2,
      Piece.cavalry2Stuart: Piece.cavalry1Hampton,
      Piece.cavalry2Wheeler: Piece.cavalry1Forrest,
      Piece.cavalry1Hampton: Piece.cavalry2Stuart,
      Piece.cavalry1Forrest: Piece.cavalry2Wheeler,
      Piece.armyMcClellan0: Piece.armyPotomac,
      Piece.armyMcClellan1: Piece.armyJames,
      Piece.armyMiddleDepartment: Piece.armySheridan,
      Piece.armyCumberland: Piece.armySherman,
      Piece.armyGulf: Piece.armyBanks,
      Piece.armyGrant4: Piece.armyGrant5,
      Piece.armyPotomac: Piece.armyMcClellan0,
      Piece.armyJames: Piece.armyMcClellan1,
      Piece.armySheridan: Piece.armyMiddleDepartment,
      Piece.armySherman: Piece.armyCumberland,
      Piece.armyBanks: Piece.armyGulf,
      Piece.armyGrant5: Piece.armyGrant4,
      Piece.freedmen2_0: Piece.freedmen1_0,
      Piece.freedmen2_1: Piece.freedmen1_1,
      Piece.freedmen2_2: Piece.freedmen1_2,
      Piece.freedmen2_3: Piece.freedmen1_3,
      Piece.freedmen1_0: Piece.freedmen2_0,
      Piece.freedmen1_1: Piece.freedmen2_1,
      Piece.freedmen1_2: Piece.freedmen2_2,
      Piece.freedmen1_3: Piece.freedmen2_3,
      Piece.lincoln: Piece.washingtonInPanic,
      Piece.washingtonInPanic: Piece.lincoln,
      Piece.sustainedOffensive: Piece.surpriseOffensive,
      Piece.surpriseOffensive: Piece.sustainedOffensive,
      Piece.plantation0: Piece.plantationDepleted0,
      Piece.plantation1: Piece.plantationDepleted1,
      Piece.plantation2: Piece.plantationDepleted2,
      Piece.plantation3: Piece.plantationDepleted3,
      Piece.plantationDepleted0: Piece.plantation0,
      Piece.plantationDepleted1: Piece.plantation1,
      Piece.plantationDepleted2: Piece.plantation2,
      Piece.plantationDepleted3: Piece.plantation3,
      Piece.rrCompany0: Piece.usBase0,
      Piece.rrCompany1: Piece.usBase1,
      Piece.rrCompany2: Piece.usBase2,
      Piece.rrCompany3: Piece.usBase3,
      Piece.usBase0: Piece.rrCompany0,
      Piece.usBase1: Piece.rrCompany1,
      Piece.usBase2: Piece.rrCompany2,
      Piece.usBase3: Piece.rrCompany3,
      Piece.factory0: Piece.usBase4,
      Piece.factory1: Piece.usBase5,
      Piece.factory2: Piece.usBase6,
      Piece.factory3: Piece.usBase7,
      Piece.usBase4: Piece.factory0,
      Piece.usBase5: Piece.factory1,
      Piece.usBase6: Piece.factory2,
      Piece.usBase7: Piece.factory3,
      Piece.slaves2_0: Piece.slaves1_0,
      Piece.slaves2_1: Piece.slaves1_1,
      Piece.slaves2_2: Piece.slaves1_2,
      Piece.slaves2_3: Piece.slaves1_3,
      Piece.slaves2_4: Piece.slaves1_4,
      Piece.slaves2_5: Piece.slaves1_5,
      Piece.slaves2_6: Piece.slaves1_6,
      Piece.slaves2_7: Piece.slaves1_7,
      Piece.slaves1_0: Piece.slaves2_0,
      Piece.slaves1_1: Piece.slaves2_1,
      Piece.slaves1_2: Piece.slaves2_2,
      Piece.slaves1_3: Piece.slaves2_3,
      Piece.slaves1_4: Piece.slaves2_4,
      Piece.slaves1_5: Piece.slaves2_5,
      Piece.slaves1_6: Piece.slaves2_6,
      Piece.slaves1_7: Piece.slaves2_7,
      Piece.politicianDavis: Piece.politicianXDavis,
      Piece.politicianStephens: Piece.politicianXStephens,
      Piece.politicianToombs: Piece.politicianXToombs,
      Piece.politicianHunter: Piece.politicianXHunter,
      Piece.politicianBenjamin: Piece.politicianXBenjamin,
      Piece.politicianReagan: Piece.politicianXReagan,
      Piece.politicianRandolph: Piece.politicianXRandolph,
      Piece.politicianSeddon: Piece.politicianXSeddon,
      Piece.politicianMallory: Piece.politicianXMallory,
      Piece.politicianWatts: Piece.politicianXWatts,
      Piece.politicianMemminger: Piece.politicianXMemminger,
      Piece.politicianTrenholm: Piece.politicianXTrenholm,
      Piece.politicianXDavis: Piece.politicianDavis,
      Piece.politicianXStephens: Piece.politicianStephens,
      Piece.politicianXToombs: Piece.politicianToombs,
      Piece.politicianXHunter: Piece.politicianHunter,
      Piece.politicianXBenjamin: Piece.politicianBenjamin,
      Piece.politicianXReagan: Piece.politicianReagan,
      Piece.politicianXRandolph: Piece.politicianRandolph,
      Piece.politicianXSeddon: Piece.politicianSeddon,
      Piece.politicianXMallory: Piece.politicianMallory,
      Piece.politicianXWatts: Piece.politicianWatts,
      Piece.politicianXMemminger: Piece.politicianMemminger,
      Piece.politicianXTrenholm: Piece.politicianTrenholm,
      Piece.kentuckyNeutral0: Piece.campaignModifierKentuckyUnionN1,
      Piece.kentuckyNeutral1: Piece.campaignModifierKentuckyRebelP1,
      Piece.campaignModifierKentuckyUnionN1: Piece.kentuckyNeutral0,
      Piece.campaignModifierKentuckyRebelP1: Piece.kentuckyNeutral1,
      Piece.missouriRebel2_0: Piece.missouriRebel1_0,
      Piece.missouriRebel2_1: Piece.missouriRebel1_1,
      Piece.missouriRebel2_2: Piece.missouriRebel1_2,
      Piece.missouriRebel1_0: Piece.missouriRebel2_0,
      Piece.missouriRebel1_1: Piece.missouriRebel2_1,
      Piece.missouriRebel1_2: Piece.missouriRebel2_2,
      Piece.linesCutP1_0: Piece.linesCutN1_0,
      Piece.linesCutP1_1: Piece.linesCutN1_1,
      Piece.linesCutP1_2: Piece.linesCutN1_2,
      Piece.linesCutP1_3: Piece.linesCutN1_3,
      Piece.linesCutP1_4: Piece.linesCutN1_4,
      Piece.linesCutN1_0: Piece.linesCutP1_0,
      Piece.linesCutN1_1: Piece.linesCutP1_1,
      Piece.linesCutN1_2: Piece.linesCutP1_2,
      Piece.linesCutN1_3: Piece.linesCutP1_3,
      Piece.linesCutN1_4: Piece.linesCutP1_4,
      Piece.campaignSuccess0: Piece.campaignFailure0,
      Piece.campaignSuccess1: Piece.campaignFailure1,
      Piece.campaignSuccess2: Piece.campaignFailure2,
      Piece.campaignSuccess3: Piece.campaignFailure3,
      Piece.campaignSuccess4: Piece.campaignFailure4,
      Piece.campaignSuccess5: Piece.campaignFailure5,
      Piece.campaignSuccess6: Piece.campaignFailure6,
      Piece.campaignFailure0: Piece.campaignSuccess0,
      Piece.campaignFailure1: Piece.campaignSuccess1,
      Piece.campaignFailure2: Piece.campaignSuccess2,
      Piece.campaignFailure3: Piece.campaignSuccess3,
      Piece.campaignFailure4: Piece.campaignSuccess4,
      Piece.campaignFailure5: Piece.campaignSuccess5,
      Piece.campaignFailure6: Piece.campaignSuccess6,
      Piece.artillery0: Piece.ironclad0,
      Piece.artillery1: Piece.ironclad1,
      Piece.artillery2: Piece.ironclad2,
      Piece.artillery3: Piece.ironclad3,
      Piece.ironclad0: Piece.artillery0,
      Piece.ironclad1: Piece.artillery1,
      Piece.ironclad2: Piece.artillery2,
      Piece.ironclad3: Piece.artillery3,
      Piece.statesRights: Piece.lostCause,
      Piece.lostCause: Piece.statesRights,
      Piece.turnChit1: Piece.turnChitCoatOfArms1,
      Piece.turnChit2: Piece.turnChitCoatOfArms2,
      Piece.turnChit3: Piece.turnChitCoatOfArms3,
      Piece.turnChit4: Piece.turnChitCoatOfArms4,
      Piece.turnChitCoatOfArms1: Piece.turnChit1,
      Piece.turnChitCoatOfArms2: Piece.turnChit2,
      Piece.turnChitCoatOfArms3: Piece.turnChit3,
      Piece.turnChitCoatOfArms4: Piece.turnChit4,
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

  // Regions

  bool regionIsInVirginia(Location region) {
    const virginiaRegions = [
      Location.regionRichmond,
      Location.regionHanoverCounty,
      Location.regionTheRappahannock,
      Location.regionManassas,
      Location.regionLynchburg,
      Location.regionShenandoahValley,
      Location.regionHarpersFerry,
      Location.regionBermudaHundred,
      Location.regionWilliamsburg,
      Location.regionYorktown,
    ];
    return virginiaRegions.contains(region);
  }

  Path? regionPath(Location region) {
    for (final path in Path.values) {
      final locationType = pathLocationType(path);
      if (region.isType(locationType)) {
        return path;
      }
    }
    return null;
  }

  bool regionIsUnionControlled(Location region) {
    if (region == Location.regionRichmond) {
      return false;
    }
    final path = regionPath(region)!;
    final unionArmy = pathUnionArmy(path);
    if (unionArmy == null) {
      return false;
    }
    final unionArmyRegion = pieceLocation(unionArmy);
    return region.index >= unionArmyRegion.index;
  }

  // Paths

  LocationType pathLocationType(Path path) {
    const pathLocationTypes = {
      Path.path1: LocationType.path1,
      Path.path2: LocationType.path2,
      Path.path3: LocationType.path3,
      Path.path4: LocationType.path4,
      Path.path5: LocationType.path5,
      Path.path6: LocationType.path6,
    };
    return pathLocationTypes[path]!;
  }

  Location pathFinalRegion(Path path) {
    final locationType = pathLocationType(path);
    return Location.values[locationType.lastIndex - 1];
  }

  Piece? pathUnionArmy(Path path) {
    final locationType = pathLocationType(path);
    for (final region in locationType.locations) {
      final army = pieceInLocation(PieceType.army, region);
      if (army != null) {
        return army;
      }
    }
    return null;
  }

  Piece? pathLinesCut(Path path) {
    final locationType = pathLocationType(path);
    for (final region in locationType.locations) {
      final linesCut = pieceInLocation(PieceType.linesCut, region);
      if (linesCut != null) {
        return linesCut;
      }
    }
    return null;

  }

  List<Location> get richmondAndAdjacentRegions {
    const locations = [
      Location.regionRichmond,
      Location.regionHanoverCounty,
      Location.regionLynchburg,
      Location.regionBermudaHundred,
      Location.regionFayetteville,
    ];
    return locations;
  }

  // Blockade Boxes

  int blockadeBoxValue(Location blockadeBox) {
    const blockadeBoxValues = {
      Location.boxBlockade1a: 1,
      Location.boxBlockade1b: 1,
      Location.boxBlockade2a: 2,
      Location.boxBlockade2b: 2,
      Location.boxBlockade2c: 2,
      Location.boxBlockade3: 3,
      Location.boxBlockade4: 4,
    };
    return blockadeBoxValues[blockadeBox]!;
  }

  // Generals

  Location? generalFixedLocation(Piece general) {
    const generalLists = [
      [Piece.general2Lee0, Piece.general2Lee1, Piece.general2Lee2, Piece.general1Lee0, Piece.general1Lee1, Piece.general1Lee2],
      [Piece.general2Jackson0, Piece.general2Jackson1, Piece.general1Jackson0, Piece.general1Jackson1],
    ];
    for (final generalList in generalLists) {
      if (generalList.contains(general)) {
        for (final otherGeneral in generalList) {
          final location = pieceLocation(otherGeneral);
          if (![Location.sack, Location.flipped, Location.discarded].contains(location)) {
            return location;
          }
        }
      }
    }
    return null;
  }

  bool rebelIsForVirginia(Piece rebel) {
    const virginiaRebels = [
      Piece.general2Lee0,
      Piece.general2Lee1,
      Piece.general2Lee2,
      Piece.general2Jackson0,
      Piece.general2Jackson1,
      Piece.general2Stuart0,
      Piece.general2Stuart1,
      Piece.general1Lee0,
      Piece.general1Lee1,
      Piece.general1Lee2,
      Piece.general1Jackson0,
      Piece.general1Jackson1,
      Piece.general1Stuart0,
      Piece.general1Stuart1,
      Piece.cavalry2Stuart,
    ];
    return virginiaRebels.contains(rebel);
  }

  // Kentucky

  bool get kentuckyNeutral {
    return pieceLocation(Piece.kentuckyNeutral0) == Location.regionPaducah;
  }

  // Missouri

  int get missouriRebelCount {
    return 2 * piecesInLocationCount(PieceType.missouriRebel2, Location.regionCairo) + piecesInLocationCount(PieceType.missouriRebel1, Location.regionCairo);
  }

  // Turn Chits

  List<(Path, TurnChitPathColor)> turnChitPaths(Piece turnChit) {
    const turnChitPaths = {
      Piece.turnChit3: [(Path.path2, TurnChitPathColor.white), (Path.path3, TurnChitPathColor.white)],
      Piece.turnChit4: [(Path.path1, TurnChitPathColor.yellow), (Path.path2, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.white)],
      Piece.turnChit5: [(Path.path1, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.yellow)],
      Piece.turnChit6: [(Path.path1, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.yellow), (Path.path6, TurnChitPathColor.white)],
      Piece.turnChit7: [(Path.path1, TurnChitPathColor.white), (Path.path4, TurnChitPathColor.yellow)],
      Piece.turnChit9: [(Path.path1, TurnChitPathColor.white), (Path.path3, TurnChitPathColor.yellow)],
      Piece.turnChit10: [(Path.path4, TurnChitPathColor.yellow)],
      Piece.turnChit11: [(Path.path4, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.yellow)],
      Piece.turnChit12: [(Path.path1, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.yellow), (Path.path6, TurnChitPathColor.white)],
      Piece.turnChit13: [(Path.path2, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.yellow), (Path.path6, TurnChitPathColor.white)],
      Piece.turnChit14: [(Path.path1, TurnChitPathColor.yellow), (Path.path5, TurnChitPathColor.white)],
      Piece.turnChit15: [(Path.path1, TurnChitPathColor.white), (Path.path2, TurnChitPathColor.yellow), (Path.path4, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.white)],
      Piece.turnChit16: [(Path.path2, TurnChitPathColor.yellow)],
      Piece.turnChit17: [(Path.path1, TurnChitPathColor.yellow)],
      Piece.turnChit19: [(Path.path3, TurnChitPathColor.yellow)],
      Piece.turnChit21: [(Path.path1, TurnChitPathColor.yellow), (Path.path2, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.white), (Path.path6, TurnChitPathColor.white)],
      Piece.turnChit22: [(Path.path4, TurnChitPathColor.yellow)],
      Piece.turnChit24: [(Path.path1, TurnChitPathColor.white), (Path.path4, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.yellow)],
      Piece.turnChit25: [(Path.path1, TurnChitPathColor.yellow), (Path.path2, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.white), (Path.path6, TurnChitPathColor.white)],
      Piece.turnChit26: [(Path.path1, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.white), (Path.path6, TurnChitPathColor.red)],
      Piece.turnChit27: [(Path.path1, TurnChitPathColor.white), (Path.path2, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.yellow), (Path.path6, TurnChitPathColor.white)],
      Piece.turnChit28: [(Path.path1, TurnChitPathColor.white), (Path.path2, TurnChitPathColor.white), (Path.path4, TurnChitPathColor.yellow), (Path.path5, TurnChitPathColor.white)],
      Piece.turnChit29: [(Path.path1, TurnChitPathColor.white), (Path.path4, TurnChitPathColor.yellow), (Path.path5, TurnChitPathColor.white)],
      Piece.turnChit30: [(Path.path4, TurnChitPathColor.yellow)],
      Piece.turnChit31: [(Path.path4, TurnChitPathColor.yellow), (Path.path5, TurnChitPathColor.white)],
      Piece.turnChit32: [(Path.path1, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.yellow)],
      Piece.turnChit33: [(Path.path5, TurnChitPathColor.yellow)],
      Piece.turnChit34: [(Path.path2, TurnChitPathColor.yellow)],
      Piece.turnChit35: [(Path.path1, TurnChitPathColor.yellow), (Path.path2, TurnChitPathColor.white), (Path.path4, TurnChitPathColor.white), (Path.path5, TurnChitPathColor.white)],
      Piece.turnChit36: [(Path.path5, TurnChitPathColor.white), (Path.path6, TurnChitPathColor.red)],
      Piece.turnChit37: [(Path.path5, TurnChitPathColor.white), (Path.path6, TurnChitPathColor.red)],
      Piece.turnChit38: [(Path.path1, TurnChitPathColor.white), (Path.path2, TurnChitPathColor.white), (Path.path3, TurnChitPathColor.white), (Path.path4, TurnChitPathColor.yellow)],
      Piece.turnChit39: [(Path.path1, TurnChitPathColor.yellow), (Path.path2, TurnChitPathColor.white), (Path.path3, TurnChitPathColor.white), (Path.path4, TurnChitPathColor.white)],
      Piece.turnChit40: [(Path.path1, TurnChitPathColor.white), (Path.path3, TurnChitPathColor.white), (Path.path4, TurnChitPathColor.yellow)],
      Piece.turnChit41: [(Path.path1, TurnChitPathColor.white), (Path.path2, TurnChitPathColor.white), (Path.path3, TurnChitPathColor.white), (Path.path4, TurnChitPathColor.yellow)],
      Piece.turnChit42: [(Path.path1, TurnChitPathColor.white), (Path.path2, TurnChitPathColor.yellow), (Path.path5, TurnChitPathColor.white)],
      Piece.turnChit43: [(Path.path1, TurnChitPathColor.white), (Path.path4, TurnChitPathColor.yellow), (Path.path5, TurnChitPathColor.white)],
      Piece.turnChit44: [(Path.path4, TurnChitPathColor.yellow), (Path.path5, TurnChitPathColor.white)],
    };
    final paths = turnChitPaths[turnChit];
    if (paths == null) {
      return <(Path, TurnChitPathColor)>[];
    }
    return paths;
  }

  Path? turnChitColoredPath(Piece turnChit) {
    final paths = turnChitPaths(turnChit);
    for (final tuple in paths) {
      if (tuple.$2 != TurnChitPathColor.white) {
        return tuple.$1;
      }
    }
    return null;
  }

  int turnChitForeignInterventionCount(Piece turnChit) {
    const turnChitForeignInterventionCounts = {
      Piece.turnChit1: 1,
      Piece.turnChit2: 1,
      Piece.turnChit5: 1,
      Piece.turnChit7: 1,
      Piece.turnChit8: 1,
      Piece.turnChit9: 1,
      Piece.turnChit10: 2,
      Piece.turnChit18: 1,
      Piece.turnChit19: 1,
      Piece.turnChit20: 1,
      Piece.turnChit22: 1,
      Piece.turnChit32: 1,
      Piece.turnChit33: 1,
      Piece.turnChit34: 1,
    };
    return turnChitForeignInterventionCounts[turnChit] ?? 0;
  }

  List<Piece?> turnChitEconomicLosses(Piece turnChit) {
    const turnChitEconomicLossLists = {
      Piece.turnChit2: [Piece.agricultureLevel],
      Piece.turnChit5: [Piece.manufactureLevel],
      Piece.turnChit7: [null],
      Piece.turnChit8: [Piece.agricultureLevel],
      Piece.turnChit11: [Piece.manufactureLevel],
      Piece.turnChit16: [Piece.agricultureLevel],
      Piece.turnChit17: [Piece.manufactureLevel, Piece.agricultureLevel],
      Piece.turnChit18: [Piece.infrastructureLevel],
      Piece.turnChit19: [Piece.infrastructureLevel],
      Piece.turnChit20: [Piece.infrastructureLevel],
      Piece.turnChit23: [Piece.agricultureLevel, null],
      Piece.turnChit24: [Piece.manufactureLevel],
      Piece.turnChit30: [Piece.infrastructureLevel],
      Piece.turnChit31: [Piece.manufactureLevel, Piece.infrastructureLevel],
      Piece.turnChit33: [Piece.agricultureLevel],
      Piece.turnChit34: [Piece.infrastructureLevel],
      Piece.turnChit36: [Piece.manufactureLevel, Piece.infrastructureLevel],
      Piece.turnChit43: [Piece.manufactureLevel],
      Piece.turnChit44: [Piece.agricultureLevel],
    };
    return turnChitEconomicLossLists[turnChit] ?? <Piece?>[];
  }

  // Turns

  int get currentTurn {
    int maxTurn = 0;
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
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    int month = (turn + 3) % 12;
    int year = (turn + 3) ~/ 12 + 1861;
    return '${monthNames[month]} $year';
  }

  Location calendarBox(int turn) {
    return Location.values[LocationType.calendar.firstIndex + turn];
  }

  Location get currentTurnCalendarBox {
    return calendarBox(currentTurn);
  }

  Piece get currentTurnChit {
    return pieceInLocation(PieceType.turnChit, currentTurnCalendarBox)!;
  }

  bool turnHasUnionOffensive(int turn) {
    const unionOffensiveTurns = [
      3, 11, 12, 13, 14, 15, 16, 17, 18, 20, 22, 24, 26, 27, 29, 30, 37, 37, 38, 39, 40, 41, 42,
    ];
    return unionOffensiveTurns.contains(turn);
  }

  // Assets

  int get agricultureLevel {
    return pieceLocation(Piece.agricultureLevel).index - LocationType.agriculture.firstIndex;
  }

  void adjustAgricultureLevel(int delta) {
    int level = agricultureLevel + delta;
    if (level < 0) {
      level = 0;
    } else if (level > 6) {
      level = 6;
    }
    setPieceLocation(Piece.agricultureLevel, Location.values[Location.boxAgriculture0.index + level]);
  }

  int get manufactureLevel {
    return pieceLocation(Piece.manufactureLevel).index - LocationType.manufacture.firstIndex;
  }

  void adjustManufactureLevel(int delta) {
    int level = manufactureLevel + delta;
    if (level < 0) {
      level = 0;
    } else if (level > 6) {
      level = 6;
    }
    setPieceLocation(Piece.manufactureLevel, Location.values[Location.boxManufacture0.index + level]);
  }

  int get infrastructureLevel {
    return pieceLocation(Piece.infrastructureLevel).index - LocationType.infrastructure.firstIndex;
  }

  void adjustInfrastructureLevel(int delta) {
    int level = infrastructureLevel + delta;
    if (level < 0) {
      level = 0;
    } else if (level > 6) {
      level = 6;
    }
    setPieceLocation(Piece.infrastructureLevel, Location.values[Location.boxInfrastructure0.index + level]);
  }

  // Treasury

  Location treasuryBox(int value) {
    return Location.values[LocationType.treasury.firstIndex + value];
  }

  int treasuryBoxValue(Location treasuryBox) {
    return treasuryBox.index - LocationType.treasury.firstIndex;
  }

  int get treasury {
    return pieceLocation(Piece.csaTreasury).index - LocationType.treasury.firstIndex;
  }

  void adjustTreasury(int delta) {
    int newValue = treasury + delta;
    if (newValue < 0) {
      newValue = 0;
    }
    if (newValue > 9) {
      newValue = 9;
    }
    setPieceLocation(Piece.csaTreasury, treasuryBox(newValue));
  }

  // Special Campaign Budget

  int get specialCampaignBudget {
    return pieceLocation(Piece.specialBudget).index - LocationType.treasury.firstIndex;
  }

  void adjustSpecialCampaignBudget(int delta) {
    int newValue = specialCampaignBudget + delta;
    if (newValue < 0) {
      newValue = 0;
    }
    if (newValue > 9) {
      newValue = 9;
    }
    setPieceLocation(Piece.specialBudget, treasuryBox(newValue));
  }

  // Intervention

  int get britishIntervention {
    final location = pieceLocation(Piece.generalBritish2);
    if (!location.isType(LocationType.calendar)) {
      return -1;
    }
    return location.index - LocationType.calendar.firstIndex;
  }

  bool adjustBritishIntervention(int delta) {
    if (britishIntervention < 0) {
      return false;
    }
    int newValue = britishIntervention + delta;
    if (newValue < 0) {
      setPieceLocation(Piece.generalBritish2, Location.discarded);
      return false;
    }
    if (newValue > 44) {
      newValue = 44;
    }
    setPieceLocation(Piece.generalBritish2, calendarBox(newValue));
    return newValue == 44;
  }

  int get frenchIntervention {
    final location = pieceLocation(Piece.generalFrench2);
    if (!location.isType(LocationType.calendar)) {
      return -1;
    }
    return location.index - LocationType.calendar.firstIndex;
  }

  bool adjustFrenchIntervention(int delta) {
    if (frenchIntervention < 0) {
      return false;
    }
    int newValue = frenchIntervention + delta;
    if (newValue < 0) {
      setPieceLocation(Piece.generalFrench2, Location.discarded);
      return false;
    }
    if (newValue > 44) {
      newValue = 44;
    }
    setPieceLocation(Piece.generalFrench2, calendarBox(newValue));
    return newValue == 44;
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
      (PieceType.turnChit, Location.trayTurn),
      (PieceType.general2, Location.trayConfederateForces),
      (PieceType.cavalry2, Location.trayConfederateForces),
      (PieceType.armyFront, Location.trayUnionForces),
      (PieceType.freedmen2, Location.trayUnionForces),
      (PieceType.plantationUndepleted, Location.trayEconomic),
      (PieceType.rrCompany, Location.trayEconomic),
      (PieceType.factory, Location.trayEconomic),
      (PieceType.slaves2, Location.trayEconomic),
      (PieceType.anaconda, Location.trayOtherForces),
      (PieceType.frigate, Location.trayOtherForces),
      (PieceType.blockadeRunner, Location.trayOtherForces),
      (PieceType.campaignModifierP1Indian, Location.trayOtherForces),
      (PieceType.regularPoliticianUnused, Location.trayPolitical),
      (PieceType.kentuckyNeutral, Location.trayPolitical),
      (PieceType.missouriRebel2, Location.trayPolitical),
      (PieceType.linesCutP1, Location.trayStrategic),
      (PieceType.campaignSuccess, Location.trayStrategic),
      (PieceType.defensiveWorks, Location.trayMilitary),
      (PieceType.artillery, Location.trayMilitary),
      (PieceType.train, Location.trayMilitary),
      (PieceType.bushwhacker, Location.trayMilitary),
      (PieceType.closed, Location.trayVarious),
    ]);

    state.setupPieces([
      (Piece.campaignModifierShelbyP1, Location.trayConfederateForces),
      (Piece.cssHunley, Location.trayConfederateForces),
      (Piece.lincoln, Location.trayUnionForces),
      (Piece.sustainedOffensive, Location.trayUnionForces),
      (Piece.grantPromoted, Location.trayUnionForces),
      (Piece.agricultureLevel, Location.trayEconomic),
      (Piece.manufactureLevel, Location.trayEconomic),
      (Piece.infrastructureLevel, Location.trayEconomic),
      (Piece.campaignResultMormonRebels, Location.trayOtherForces),
      (Piece.generalBritish2, Location.trayOtherForces),
      (Piece.generalFrench2, Location.trayOtherForces),
      (Piece.politicianDavis, Location.trayPolitical),
      (Piece.nextCampaign, Location.trayStrategic),
      (Piece.trenches, Location.trayMilitary),
      (Piece.crisis, Location.trayVarious),
      (Piece.csaTreasury, Location.trayVarious),
      (Piece.specialBudget, Location.trayVarious),
      (Piece.statesRights, Location.trayVarious),
      (Piece.objective, Location.trayVarious),
    ]);

    return state;
  }

  factory GameState.setupStandard() {

    var state = GameState.setupTray();

    state.setupPieceTypes([
      (PieceType.turnChit, Location.sack),
      (PieceType.slaves2, Location.boxSlaveQuarters),
      (PieceType.blockadeRunner, Location.boxEnglishShipyards),
      (PieceType.frigate, Location.sack),
      (PieceType.anaconda, Location.sack),
      (PieceType.regularPoliticianUnused, Location.boxConfederateGovernment),
    ]);

    state.setupPieces([
      (Piece.turnChitCoatOfArms1, Location.turn0),
      (Piece.turnChitCoatOfArms2, Location.turn1),
      (Piece.turnChitCoatOfArms3, Location.turn2),
      (Piece.turnChitCoatOfArms4, Location.turn3),
      (Piece.general2Lee0, Location.sack),
      (Piece.general2Lee1, Location.sack),
      (Piece.general2Lee2, Location.sack),
      (Piece.general2Early, Location.sack),
      (Piece.general2Ewell, Location.sack),
      (Piece.general2Hardee, Location.sack),
      (Piece.general2Hood, Location.sack),
      (Piece.general2Longstreet, Location.sack),
      (Piece.general2Pemberton, Location.sack),
      (Piece.cssHunley, Location.sack),
      (Piece.general2Beauregard, Location.poolCsaGenerals),
      (Piece.general2Bragg, Location.poolCsaGenerals),
      (Piece.general2ASJohnston, Location.poolCsaGenerals),
      (Piece.general2JJohnston, Location.poolCsaGenerals),
      (Piece.general2APHill, Location.poolCsaGenerals),
      (Piece.general2VanDorn, Location.poolCsaGenerals),
      (Piece.general2Jackson0, Location.poolCsaGenerals),
      (Piece.general2Jackson1, Location.poolCsaGenerals),
      (Piece.cavalry2Stuart, Location.poolCsaGenerals),
      (Piece.cavalry2Wheeler, Location.poolCsaGenerals),
      (Piece.lincoln, Location.regionWashingtonDC),
      (Piece.armyMcClellan0, Location.regionWashingtonDC),
      (Piece.armyMcClellan1, Location.regionFortMonroe),
      (Piece.armyMiddleDepartment, Location.regionMarylandAndPennsylvania),
      (Piece.armyCumberland, Location.regionCincinnati),
      (Piece.armyGrant4, Location.regionCairo),
      (Piece.agricultureLevel, Location.boxAgriculture5),
      (Piece.manufactureLevel, Location.boxManufacture5),
      (Piece.infrastructureLevel, Location.boxInfrastructure5),
      (Piece.plantation0, Location.regionRedRiver),
      (Piece.plantation1, Location.regionTheDelta),
      (Piece.plantation2, Location.regionShenandoahValley),
      (Piece.plantation3, Location.regionSavannah),
      (Piece.factory0, Location.regionNewOrleans),
      (Piece.factory1, Location.regionNashville),
      (Piece.factory2, Location.regionAtlanta),
      (Piece.factory3, Location.regionFayetteville),
      (Piece.rrCompany0, Location.regionJackson),
      (Piece.rrCompany1, Location.regionCorinth),
      (Piece.rrCompany2, Location.regionChattanooga),
      (Piece.rrCompany3, Location.regionColumbia),
      (Piece.frigate0, Location.boxUnionFrigates),
      (Piece.blockadeRunner0, Location.boxBlockadeRunners),
      (Piece.train0, Location.regionRichmond),
      (Piece.generalBritish2, Location.turn0),
      (Piece.generalFrench2, Location.turn0),
      (Piece.kentuckyNeutral0, Location.regionPaducah),
      (Piece.kentuckyNeutral1, Location.regionLouisville),
      (Piece.kentuckyNeutral2, Location.regionBowlingGreen),
      (Piece.nextCampaign, Location.boxCampaignRedStar),
      (Piece.csaTreasury, Location.treasury0),
      (Piece.specialBudget, Location.treasury0),
      (Piece.statesRights, Location.boxDavisRevolution),
      (Piece.politicianDavis, Location.boxConfederateGovernment),
    ]);

    return state;
  }
}

enum Choice {
  concedeCampaign,
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
  turnChit,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateTurnChit extends PhaseState {
  int csaElectionLossesRemaining = 0;
  bool defeatFizzled = false;
  bool bushwhacker = false;
  bool campaigned = false;

  PhaseStateTurnChit();

  PhaseStateTurnChit.fromJson(Map<String, dynamic> json)
    : csaElectionLossesRemaining = json['csaElectionLossesRemaining'] as int
    , defeatFizzled = json['defeatFizzled'] as bool
    , bushwhacker = json['bushwhacker'] as bool
    , campaigned = json['campaigned'] as bool
    ;

  @override
  Map<String, dynamic> toJson() => {
    'csaElectionLossesRemaining': csaElectionLossesRemaining,
    'defeatFizzled': defeatFizzled,
    'bushwhacker': bushwhacker,
    'campaigned': campaigned,
  };

  @override
  Phase get phase {
    return Phase.turnChit;
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
      case Phase.turnChit:
        _phaseState = PhaseStateTurnChit.fromJson(phaseStateJson);
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

  Location randRegion() {
    const randRegions = [
      Location.regionHanoverCounty,
      Location.regionHanoverCounty,
      Location.regionTheRappahannock,
      Location.regionTheRappahannock,
      Location.regionManassas,
      Location.regionManassas,
      Location.regionLynchburg,
      Location.regionLynchburg,
      Location.regionShenandoahValley,
      Location.regionShenandoahValley,
      Location.regionHarpersFerry,
      Location.regionHarpersFerry,
      Location.regionBermudaHundred,
      Location.regionBermudaHundred,
      Location.regionWilliamsburg,
      Location.regionWilliamsburg,
      Location.regionYorktown,
      Location.regionYorktown,
      Location.regionColumbia,
      Location.regionSavannah,
      Location.regionAtlanta,
      Location.regionNashville,
      Location.regionBowlingGreen,
      Location.regionLouisville,
      Location.regionJackson,
      Location.regionTheDelta,
      Location.regionMemphis,
      Location.regionCorinth,
      Location.regionCorinth,
      Location.regionPaducah,
      Location.regionRedRiver,
      Location.regionRedRiver,
      Location.regionPortHudson,
      Location.regionPortHudson,
      Location.regionNewOrleans,
      Location.regionNewOrleans,
    ];
    int choice = randInt(36);
    return randRegions[choice];
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

  void adjustTreasury(int delta) {
    _state.adjustTreasury(delta);
    if (delta > 0) {
      logLine('> Treasury: +$delta → ${_state.treasury}');
    } else if (delta < 0) {
      logLine('> Treasury: $delta → ${_state.treasury}');
    }
  }

  void spendTreasury(int amount) {
    adjustTreasury(-amount);
  }

  void adjustSpecialCampaignBudget(int delta) {
    _state.adjustSpecialCampaignBudget(delta);
    if (delta > 0) {
      logLine('> Special Campaign Fund: +$delta → ${_state.specialCampaignBudget}');
    } else if (delta < 0) {
      logLine('> Special Campaign Fund: $delta → ${_state.specialCampaignBudget}');
    }
  }

  void spendSpecialCampaignBudget(int amount) {
    adjustSpecialCampaignBudget(-amount);
  }

  bool adjustAgricultureLevel(int delta) {
    _state.adjustAgricultureLevel(delta);
    int level = _state.agricultureLevel;
    if (delta > 0) {
      logLine('> Agriculture Level: +$delta → $level');
    } else {
      logLine('> Agriculture Level: $delta → $level');
    }
    return level > 0;
  }

  bool adjustManufactureLevel(int delta) {
    _state.adjustManufactureLevel(delta);
    int level = _state.manufactureLevel;
    if (delta > 0) {
      logLine('> Manufacture Level: +$delta → $level');
    } else {
      logLine('> Manufacture Level: $delta → $level');
    }
    return level > 0;
  }

  bool adjustInfrastructureLevel(int delta) {
    _state.adjustInfrastructureLevel(delta);
    int level = _state.agricultureLevel;
    if (delta > 0) {
      logLine('> Infrastructure Level: +$delta → $level');
    } else {
      logLine('> Infrastructure Level: $delta → $level');
    }
    return level > 0;
  }

  // High-Level Functions

  void adjustBritishIntervention(int delta) {
    final britainIntervenes = _state.adjustBritishIntervention(delta);
    if (delta > 0) {
      logLine('> British Intervention: +$delta → ${_state.britishIntervention}');
    } else if (delta < 0) {
      logLine('> British Intervention: $delta → ${_state.britishIntervention}');
    }
    if (britainIntervenes) {
      logLine('> Britain recognizes the Confederacy.');
      _state.setPieceLocation(Piece.generalBritish2, Location.poolCsaGenerals);
      for (final frigate in _state.piecesInLocation(PieceType.frigate, Location.sack)) {
        _state.setPieceLocation(frigate, Location.discarded);
      }
    }
  }

  void adjustFrenchIntervention(int delta) {
    final franceIntervenes = _state.adjustFrenchIntervention(delta);
    if (delta > 0) {
      logLine('> French Intervention: +$delta → ${_state.frenchIntervention}');
    } else if (delta < 0) {
      logLine('> French Intervention: $delta → ${_state.frenchIntervention}');
    }
    if (franceIntervenes) {
      logLine('> France recognizes the Confederacy.');
      _state.setPieceLocation(Piece.generalFrench2, Location.poolCsaGenerals);
    }
  }

  void kentuckyJoinsTheConfederacy() {
    for (final piece in PieceType.kentuckyNeutral.pieces) {
      _state.setPieceLocation(piece, Location.discarded);
    }
    _state.setPieceLocation(Piece.campaignModifierKentuckyRebelP1, Location.campaignHeartlandOffensive);
    logLine('> Confederate forces advance to ${Location.regionPaducah.desc} and ${Location.regionBowlingGreen.desc}.');
    for (final rebel in PieceType.rebelUnit.pieces) {
      final location = _state.pieceLocation(rebel);
      if (location.isType(LocationType.path4)) {
        _state.setPieceLocation(rebel, Location.regionBowlingGreen);
      } else if (location.isType(LocationType.path5)) {
        _state.setPieceLocation(rebel, Location.regionPaducah);
      }
    }
    logLine('> ${Piece.armyCumberland.desc} advances to ${Location.regionLouisville.desc}.');
    _state.setPieceLocation(Piece.armyCumberland, Location.regionLouisville);
  }

  void kentuckyJoinsTheUnion() {
    for (final piece in PieceType.kentuckyNeutral.pieces) {
      _state.setPieceLocation(piece, Location.discarded);
    }
    _state.setPieceLocation(Piece.campaignModifierKentuckyUnionN1, Location.campaignHeartlandOffensive);
    if (_state.missouriRebelCount == 0) {
      logLine('> ${Piece.armyGrant4.desc} advances to ${Location.regionPaducah.desc}.');
      _state.setPieceLocation(Piece.armyGrant4, Location.regionPaducah);
    }
    logLine('> ${Piece.armyCumberland.desc} advances to ${Location.regionLouisville.desc}.');
    _state.setPieceLocation(Piece.armyCumberland, Location.regionLouisville);
    bool grantInPaducah = _state.pieceLocation(Piece.armyGrant4) == Location.regionPaducah;
    if (grantInPaducah) {
      logLine('> Confederate forces advance to ${Location.regionBowlingGreen.desc}.');
    } else {
      logLine('> Confederate forces advance to ${Location.regionPaducah.desc} and ${Location.regionBowlingGreen.desc}.');
    }
    for (final rebel in PieceType.rebelUnit.pieces) {
      final location = _state.pieceLocation(rebel);
      if (location.isType(LocationType.path4)) {
        _state.setPieceLocation(rebel, Location.regionBowlingGreen);
      } else if (location.isType(LocationType.path5)) {
        if (!grantInPaducah) {
          _state.setPieceLocation(rebel, Location.regionPaducah);
        }
      }
    }
  }

  void potentialDefeat() {
    bool defeatFizzles = false;
    if (_state.piecesInLocationCount(PieceType.regularPolitician, Location.boxConfederateGovernment) >= 1) {
      defeatFizzles = true;
    } else {
      for (final region in _state.richmondAndAdjacentRegions) {
        if (_state.piecesInLocationCount(PieceType.general, region) >= 1) {
          defeatFizzles = true;
          break;
        }
      }
    }
    if (defeatFizzles) {
      final results = roll2D6();
      int total = results.$3;
      int disgruntledConfederateCount = _state.piecesInLocationCount(PieceType.regularPolitician, Location.boxDisgruntledConfederates);
      logLine('> Disgruntled Confederate politicians: $disgruntledConfederateCount');
      if (total <= disgruntledConfederateCount) {
        defeatFizzles = false;
      }
    }
    if (!defeatFizzles) {
      logLine('> The Confederacy surrenders to the Union.');
      throw GameOverException(GameResult.defeat, -1);
    }
    logLine('> The Confederacy remains defiant.');
  }

  (bool,bool) economicLoss(Piece asset) {
    bool defeat = false;
    bool bushwhacker = false;
    switch (asset) {
    case Piece.agricultureLevel:
      defeat = !adjustAgricultureLevel(-1);
      if (_state.agricultureLevel == 3 && _state.piecesInLocationCount(PieceType.bushwhacker, Location.trayMilitary) > 0 && bushwhackerRegionCandidates.isNotEmpty) {
        bushwhacker = true;
      }
    case Piece.manufactureLevel:
      defeat = !adjustManufactureLevel(-1);
    case Piece.infrastructureLevel:
      defeat = !adjustInfrastructureLevel(-1);
    default:
    }

    bool defeatFizzled = false;
    if (defeat) {
      potentialDefeat();

      switch (asset) {
      case Piece.agricultureLevel:
        adjustAgricultureLevel(1);
      case Piece.manufactureLevel:
        adjustManufactureLevel(1);
      case Piece.infrastructureLevel:
        adjustInfrastructureLevel(1);
      default:
      }
      defeatFizzled = true;
    }

    return (defeatFizzled, bushwhacker);
  }

  void economicDisaster(Piece asset) {
    switch (asset) {
    case Piece.agricultureLevel:
      adjustAgricultureLevel(-_state.agricultureLevel);
    case Piece.manufactureLevel:
      adjustManufactureLevel(-_state.manufactureLevel);
    case Piece.infrastructureLevel:
      adjustInfrastructureLevel(-_state.infrastructureLevel);
    default:
    }

    potentialDefeat();

    switch (asset) {
    case Piece.agricultureLevel:
      adjustAgricultureLevel(1);
    case Piece.manufactureLevel:
      adjustManufactureLevel(1);
    case Piece.infrastructureLevel:
      adjustInfrastructureLevel(1);
    default:
    }
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;

    // TODO logging
  }

  // High Level Functions

  List<Location> get bushwhackerRegionCandidates {
    final candidates = <Location>[];
    for (final path in Path.values) {
      final army = _state.pathUnionArmy(path);
      if (army != null) {
        final region = _state.pieceLocation(army);
        if (_state.piecesInLocationCount(PieceType.usBase, region) == 0) {
          candidates.add(region);
        }
      }
    }
    return candidates;
  }

  // Sequence Helpers

  void defeatFizzledPlayerActions() {
    // TODO
    // Must take at least one action
  }

  // Sequence of Play

  void setUpGenerals() {
    if (_state.currentTurn != 0) {
      return;
    }
    const startingPositions = [
      Location.regionManassas,
      Location.regionYorktown,
      Location.regionHarpersFerry,
      Location.regionNashville,
      Location.regionCorinth,
      Location.regionNewOrleans,
    ];
    const jacksons = [
      Piece.general2Jackson0,
      Piece.general2Jackson1,
    ];
    while (true) {
      if (choicesEmpty()) {
        setPrompt('Select CSA General to assign');
        for (final general in PieceType.general2.pieces) {
          final location = _state.pieceLocation(general);
          if (location != Location.sack && location != Location.trayConfederateForces) {
            pieceChoosable(general);
          }
        }
        bool acceptable = true;
        for (final region in startingPositions) {
          if (_state.piecesInLocationCount(PieceType.general2, region) == 0) {
            acceptable = false;
            break;
          }
        }
        choiceChoosable(Choice.next, acceptable);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      final general = selectedPiece()!;
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      final oldLocation = _state.pieceLocation(general);
      final newLocation = oldLocation == Location.poolCsaGenerals ? selectedLocation() : Location.poolCsaGenerals;
      if (newLocation == null) {
        setPrompt('Select Region to assign CSA General to');
        for (final region in startingPositions) {
          if (region != oldLocation) {
            if (!jacksons.contains(general) || _state.regionIsInVirginia(region)) {
              locationChoosable(region);
            }
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      if (jacksons.contains(general)) {
        for (final jackson in jacksons) {
          _state.setPieceLocation(jackson, newLocation);
        }
      } else {
        _state.setPieceLocation(general, newLocation);
      }
      clearChoices();
    }
  }

  void turnBegin() {
    logLine('# ${_state.turnName(_state.currentTurn)}');
  }

  void drawChitPhaseBegin() {
    if (_state.currentTurn < 4) {
      _state.flipPiece(_state.pieceInLocation(PieceType.turnChitGreenCoatOfArms, _state.calendarBox(_state.currentTurn))!);
      return;
    }

    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Draw Chit Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Draw Chit Phase');
  }

  void drawChitDrawChit() {
    if (_state.currentTurn < 4) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Draw Chit');
      _subStep = 1;
    }
    while (_subStep >= 1 && _subStep <= 2) {
      if (_subStep == 1) {
        final chit = randPiece(_state.piecesInLocation(PieceType.all, Location.sack))!;
        if (chit.isType(PieceType.general)) {
          final location = _state.generalFixedLocation(chit) ?? Location.poolCsaGenerals;
          logLine('> ${chit.desc} is added to ${location.desc}.');
          _state.setPieceLocation(chit, location);
        } else if (chit.isType(PieceType.frigate)) {
          logLine('> ${chit.desc} is added to ${Location.boxUnionFrigates.desc}.');
          _state.setPieceLocation(chit, Location.boxUnionFrigates);
        } else if (chit.isType(PieceType.anaconda)) {
          final hunleyLocation = _state.pieceLocation(Piece.cssHunley);
          if (hunleyLocation.isType(LocationType.port)) {
            logLine('> ${Piece.cssHunley.desc} thwarts Union landing at ${hunleyLocation.desc}.');
            _state.setPieceLocation(Piece.cssHunley, Location.discarded);
          } else {
            final vacantPorts = <Location>[];
            for (final port in LocationType.port.locations) {
              if (_state.pieceInLocation(PieceType.anaconda, port) == null) {
                vacantPorts.add(port);
              }
            }
            final port = randLocation(vacantPorts)!;
            logLine('> Union forces occupy ${port.desc}.');
            _state.setPieceLocation(chit, port);
            adjustBritishIntervention(1);
            adjustFrenchIntervention(1);
          }
        } else if (chit == Piece.cssHunley) {
          if (_state.treasury >= 2) {
            _subStep = 2;
          }
        } else if (chit.isType(PieceType.turnChit)) {
          logLine('> ${chit.desc}');
          _state.setPieceLocation(chit, _state.currentTurnCalendarBox);
          return;
        }
      }
      if (_subStep == 2) {
        if (choicesEmpty()) {
          setPrompt('> Activate ${Piece.cssHunley.desc}?');
          choiceChoosable(Choice.yes, true);
          choiceChoosable(Choice.no, true);
          throw PlayerChoiceException();
        }
        if (checkChoice(Choice.yes)) {
          final vacantPorts = <Location>[];
          for (final port in LocationType.port.locations) {
            if (_state.pieceInLocation(PieceType.anaconda, port) == null) {
              vacantPorts.add(port);
            }
          }
          final port = randLocation(vacantPorts)!;
          logLine('> ${Piece.cssHunley} deploys to ${port.desc}.');
          spendTreasury(2);
          _state.setPieceLocation(Piece.cssHunley, port);
        }
        clearChoices();
        _subStep = 1;
      }
    }
  }
 
  void turnChitPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Turn Chit Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Turn Chit Phase');
    _phaseState = PhaseStateTurnChit();
  }

  void turnChitPhaseDeployBlockadeRunners() {
    if (_subStep == 0) {
      logLine('### Blockade Runners');
      _subStep = 1;
    }
    if (checkChoice(Choice.cancel)) {
      clearChoices();
    }
    while (true)
    {
      if (choicesEmpty()) {
        setPrompt('Select Blockade Runner to place');
        int inPortCount = 0;
        for (final blockadeRunner in PieceType.blockadeRunner.pieces) {
          if (_state.pieceLocation(blockadeRunner) == Location.boxBlockadeRunners) {
            pieceChoosable(blockadeRunner);
            inPortCount += 1;
          } else if (_state.pieceLocation(blockadeRunner).isType(LocationType.blockadeBox)) {
            pieceChoosable(blockadeRunner);
          }
        }
        choiceChoosable(Choice.next, inPortCount == 0);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.next)) {
        clearChoices();
        return;
      }
      final blockadeRunner = selectedPiece()!;
      final destination = selectedLocation();
      if (destination == null) {
        setPrompt('Select destination');
        final location = _state.pieceLocation(blockadeRunner);
        if (location != Location.boxBlockadeRunners) {
          locationChoosable(Location.boxBlockadeRunners);
        }
        for (final blockade in LocationType.blockadeBox.locations) {
          if (_state.piecesInLocationCount(PieceType.blockadeRunner, blockade) == 0) {
            locationChoosable(blockade);
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      logLine('> ${blockadeRunner.desc} moves to ${destination.desc}.');
      _state.setPieceLocation(blockadeRunner, destination);
      clearChoices();
    }
  }

  void turnChitPhaseDeployFrigates() {
    final frigates = _state.piecesInLocation(PieceType.frigate, Location.boxUnionFrigates);
    if (frigates.isNotEmpty) {
      final frigateTable = [
        [[Location.boxBlockade2a], [Location.boxBlockade2b, Location.boxBlockade2b], [Location.boxBlockade2c, Location.boxBlockade2c, Location.boxBlockade2b], [Location.boxBlockade1a, Location.boxBlockade1a, Location.boxBlockade2a, Location.boxBlockade4]],
        [[Location.boxBlockade2b], [Location.boxBlockade2a, Location.boxBlockade2a], [Location.boxBlockade2b, Location.boxBlockade2b, Location.boxBlockade2c], [Location.boxBlockade2c, Location.boxBlockade2c, Location.boxBlockade1a, Location.boxBlockade1b]],
        [[Location.boxBlockade3], [Location.boxBlockade3, Location.boxBlockade3], [Location.boxBlockade2a, Location.boxBlockade2a, Location.boxBlockade2c], [Location.boxBlockade2b, Location.boxBlockade2b, Location.boxBlockade2a, Location.boxBlockade2c]],
        [[Location.boxBlockade3], [Location.boxBlockade4, Location.boxBlockade4], [Location.boxBlockade3, Location.boxBlockade3, Location.boxBlockade2b], [Location.boxBlockade2a, Location.boxBlockade2a, Location.boxBlockade1b, Location.boxBlockade2c]],
        [[Location.boxBlockade3], [Location.boxBlockade2a, Location.boxBlockade3], [Location.boxBlockade4, Location.boxBlockade4, Location.boxBlockade2a], [Location.boxBlockade4, Location.boxBlockade4, Location.boxBlockade2b, Location.boxBlockade3]],
        [[Location.boxBlockade4], [Location.boxBlockade2b, Location.boxBlockade4], [Location.boxBlockade2c, Location.boxBlockade3, Location.boxBlockade4], [Location.boxBlockade3, Location.boxBlockade3, Location.boxBlockade2c, Location.boxBlockade4]],
        [[Location.boxBlockade4], [Location.boxBlockade2c, Location.boxBlockade4], [Location.boxBlockade2b, Location.boxBlockade3, Location.boxBlockade4], [Location.boxBlockade2b, Location.boxBlockade2c, Location.boxBlockade3, Location.boxBlockade4]],
        [[Location.boxBlockade4], [Location.boxBlockade2c, Location.boxBlockade3], [Location.boxBlockade2a, Location.boxBlockade3, Location.boxBlockade4], [Location.boxBlockade2a, Location.boxBlockade2b, Location.boxBlockade3, Location.boxBlockade4]],
        [[Location.boxBlockade4], [Location.boxBlockade3, Location.boxBlockade4], [Location.boxBlockade2b, Location.boxBlockade2c, Location.boxBlockade4], [Location.boxBlockade4, Location.boxBlockade4, Location.boxBlockade1a, Location.boxBlockade2a]],
        [[Location.boxBlockade2c], [Location.boxBlockade3, Location.boxBlockade4], [Location.boxBlockade2a, Location.boxBlockade2c, Location.boxBlockade3], [Location.boxBlockade1b, Location.boxBlockade2a, Location.boxBlockade2b, Location.boxBlockade3]],
        [[Location.boxBlockade2a], [Location.boxBlockade2b, Location.boxBlockade4], [Location.boxBlockade2a, Location.boxBlockade2b, Location.boxBlockade4], [Location.boxBlockade1a, Location.boxBlockade2a, Location.boxBlockade3, Location.boxBlockade4]],
      ];
      logLine('### British Cruiser deployment.');
      final results = roll2D6();
      int dice = results.$3;
      final locations = frigateTable[dice - 2][frigates.length - 1];
      for (int i = 0; i < frigates.length; ++i) {
        logLine('> ${frigates[i].desc} patrols ${locations[i].desc}.');
        _state.setPieceLocation(frigates[i], locations[i]);
      }
    }
  }

  void turnChitPhaseSinkBlockadeRunners() {
    for (final blockade in LocationType.blockadeBox.locations) {
      final blockadeRunner = _state.pieceInLocation(PieceType.blockadeRunner, blockade);
      if (blockadeRunner != null) {
        int frigateCount = _state.piecesInLocationCount(PieceType.frigate, blockade);
        if (frigateCount == 2) {
          logLine('> ${blockadeRunner.desc} in ${blockade.desc} is sunk.');
          _state.setPieceLocation(blockadeRunner, Location.boxEnglishShipyards);
        }
      }
    }
  }

  void turnChitPhaseEconomicHaul() {
    int haul = 0;
    for (final blockade in LocationType.blockadeBox.locations) {
      int blockadeRunnerCount = _state.piecesInLocationCount(PieceType.blockadeRunner, blockade);
      int frigateCount = _state.piecesInLocationCount(PieceType.frigate, blockade);
      if (blockadeRunnerCount > 0 && frigateCount == 0) {
        haul += _state.blockadeBoxValue(blockade);
      }
    }
    int anaconda = 0;
    for (final port in LocationType.port.locations) {
      if (_state.pieceInLocation(PieceType.anaconda, port) != null) {
        anaconda += 1;
      }
    }
    logLine('### Economic Haul');
    logLine('> Blockade Runners: +$haul');
    if (anaconda > 0) {
      logLine('> Anaconda Plan: -$anaconda');
    }
    int total = max(haul - anaconda, 0);
    adjustTreasury(total);
  }

  void turnChitPhaseSpecialCampaignBudget() {
    if (_subStep == 0) {
      logLine('### Special Campaign Budget');
      _subStep = 1;
    }
    if (_subStep == 1) {
      while (true) {
        if (choicesEmpty()) {
          setPrompt('Transfer Funds to the Special Campaign Budget?');
          choiceChoosable(Choice.yes, _state.treasury > 0 && _state.specialCampaignBudget < 9);
          choiceChoosable(Choice.no, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.no)) {
          return;
        }
        clearChoices();
        adjustTreasury(-1);
        adjustSpecialCampaignBudget(1);
      }
    }
  }

  void kentuckyVote() {
    logLine('### Kentucky Vote');
    int die = rollD6();
    if (die == 6) {
      logLine('> Kentucky joins the Confederacy.');
      kentuckyJoinsTheConfederacy();
    } else {
      logLine('> Kentucky stays neutral.');
    }
  }

  void kentuckyRaid() {
    if (!_state.kentuckyNeutral) {
      return;
    }
    logLine('### Kentucky Raid');
    int die = rollD6();
    if (die <= 4) {
      logLine('> CSA General Leonidas Polk violates Kentucky neutrality.');
      logLine('> Kentucky joins the Union.');
      kentuckyJoinsTheUnion();
    } else {
      logLine('> Kentucky stays neutral.');
    }
  }

  void csaElection1861() {
    final phaseState = _phaseState as PhaseStateTurnChit;
    if (_subStep == 0) {
      int count = 0;
      for (final asset in PieceType.asset.pieces) {
        final location = _state.pieceLocation(asset);
        if (location.isType(LocationType.region)) {
          count += 1;
        }
      }
      phaseState.csaElectionLossesRemaining = 12 - count;
      logLine('### CSA Election of 1861');
      logLine('> Economic Assets under CSA control: $count');
      _subStep = 1;
    }
    while (phaseState.csaElectionLossesRemaining > 0) {
      if (choicesEmpty()) {
        setPrompt('Select Loss');
        for (final general in PieceType.general.pieces) {
          final location = _state.pieceLocation(general);
          if (location.isType(LocationType.region) || location == Location.poolCsaGenerals) {
            pieceChoosable(general);
          }
        }
        for (final slaves in PieceType.slaves.pieces) {
          if (_state.pieceLocation(slaves) == Location.boxSlaveQuarters) {
            pieceChoosable(slaves);
          }
        }
        if (_state.treasury > 0) {
          pieceChoosable(Piece.csaTreasury);
        }
        throw PlayerChoiceException();
      }
      final piece = selectedPiece()!;
      if (piece.isType(PieceType.general2)) {
        logLine('> ${piece.desc} is flipped.');
        _state.flipPiece(piece);
      } else if (piece.isType(PieceType.general1)) {
        logLine('> ${piece.desc} is removed.');
        _state.setPieceLocation(piece, Location.trayConfederateForces);
      } else if (piece.isType(PieceType.slaves2)) {
        logLine('> Slaves lost.');
        _state.flipPiece(piece);
        adjustBritishIntervention(-1);
        adjustFrenchIntervention(-1);
      } else if (piece.isType(PieceType.slaves1)) {
        logLine('> Slaves lost.');
        _state.setPieceLocation(_state.pieceFlipSide(piece)!, Location.discarded);
        adjustBritishIntervention(-1);
        adjustFrenchIntervention(-1);
      } else if (piece == Piece.csaTreasury) {
        adjustTreasury(-1);
      }
      phaseState.csaElectionLossesRemaining -= 1;
      clearChoices();
    }
  }

  void usElection1862() {
    logLine('### US Election of 1862');
    logLine('> McClellan is sacked by Lincoln after successful election outcome.');
    _state.flipPiece(Piece.armyMcClellan0);
    _state.flipPiece(Piece.armyMcClellan1);
  }

  void emancipation() {
    logLine('### The Emancipation Proclomation');
    int baseCount = 0;
    for (final base in PieceType.usBase.pieces) {
      if (_state.pieceLocation(base).isType(LocationType.region)) {
        baseCount += 1;
      }
    }
    logLine('> US Bases: $baseCount');
    int plantationCount = 0;
    for (final plantation in PieceType.plantationUndepleted.pieces) {
      if (_state.pieceLocation(plantation) == Location.discarded) {
        plantationCount = 0;
      }
    }
    logLine('> Despoiled Plantations: $plantationCount');
    int totalCount = baseCount + plantationCount;
    int dice = 0;
    for (int i = 0; i < totalCount; ++i) {
      dice += rollD6();
    }
    adjustBritishIntervention(-dice);
    adjustFrenchIntervention(-dice);
  }

  void twoBullets() {
    return; // Optional
  }

  void csaElection1863() {
    final phaseState = _phaseState as PhaseStateTurnChit;
    if (_subStep == 0) {
      int count = 0;
      for (final asset in PieceType.asset.pieces) {
        final location = _state.pieceLocation(asset);
        if (location.isType(LocationType.region)) {
          count += 1;
        }
      }
      phaseState.csaElectionLossesRemaining = 6 - count;
      logLine('### CSA Election of 1863');
      logLine('> Economic Assets under CSA control: $count');
      _subStep = 1;
    }
    while (phaseState.csaElectionLossesRemaining != 0) {
      if (choicesEmpty()) {
        if (phaseState.csaElectionLossesRemaining > 0) {
          setPrompt('Select Loss');
          for (final general in PieceType.general.pieces) {
            final location = _state.pieceLocation(general);
            if (location.isType(LocationType.region) || location == Location.poolCsaGenerals) {
              pieceChoosable(general);
            }
          }
          for (final slaves in PieceType.slaves.pieces) {
            if (_state.pieceLocation(slaves) == Location.boxSlaveQuarters) {
              pieceChoosable(slaves);
            }
          }
          if (_state.treasury > 0) {
            pieceChoosable(Piece.csaTreasury);
          }
        } else {
          setPrompt('Select Gain');
          for (final general in PieceType.general1.pieces) {
            if (!_state.rebelIsForVirginia(general)) {
              final location = _state.pieceLocation(general);
              if (location.isType(LocationType.region) || location == Location.poolCsaGenerals || location == Location.trayConfederateForces) {
                pieceChoosable(general);
              }
            }
          }
          if (choosablePieceCount == 0) {
            for (final general in PieceType.general1.pieces) {
              if (_state.rebelIsForVirginia(general)) {
                final location = _state.pieceLocation(general);
                if (location.isType(LocationType.region) || location == Location.poolCsaGenerals || location == Location.trayConfederateForces) {
                  pieceChoosable(general);
                }
              }
            }
          }
          if (_state.treasury < 9) {
            pieceChoosable(Piece.csaTreasury);
          }
        }
        throw PlayerChoiceException();
      }
      final piece = selectedPiece()!;
      if (phaseState.csaElectionLossesRemaining > 0) {
        if (piece.isType(PieceType.general2)) {
          logLine('> ${piece.desc} is flipped.');
          _state.flipPiece(piece);
        } else if (piece.isType(PieceType.general1)) {
          logLine('> ${piece.desc} is removed.');
          _state.setPieceLocation(piece, Location.trayConfederateForces);
        } else if (piece.isType(PieceType.slaves2)) {
          logLine('> Slaves lost.');
          _state.flipPiece(piece);
          adjustBritishIntervention(-1);
          adjustFrenchIntervention(-1);
        } else if (piece.isType(PieceType.slaves1)) {
          logLine('> Slaves lost.');
          _state.setPieceLocation(_state.pieceFlipSide(piece)!, Location.discarded);
          adjustBritishIntervention(-1);
          adjustFrenchIntervention(-1);
        } else if (piece == Piece.csaTreasury) {
          adjustTreasury(-1);
        }
        phaseState.csaElectionLossesRemaining -= 1;
      } else {
        if (piece.isType(PieceType.general1)) {
          final location = _state.pieceLocation(piece);
          if (location == Location.trayConfederateForces) {
            logLine('> ${piece.desc} is returned to ${Location.poolCsaGenerals.desc}.');
            _state.setPieceLocation(piece, Location.poolCsaGenerals);
          } else {
            logLine('> ${piece.desc} is flipped.');
            _state.flipPiece(piece);
          }
        } else if (piece == Piece.csaTreasury) {
          adjustTreasury(1);
        }
        phaseState.csaElectionLossesRemaining += 1;
      }
      clearChoices();
    }
  }

  void usElection1864() {
    logLine('### 1864 Presidential Election');
    int score = 0;

    int assetCount = 0;
    for (final asset in PieceType.asset.pieces) {
      if (_state.pieceLocation(asset).isType(LocationType.region)) {
        assetCount += 1;
      }
    }
    logLine('> Economic Assets: $assetCount');
    score += assetCount;

    logLine('> Agriculture: ${_state.agricultureLevel}');
    score += _state.agricultureLevel;

    logLine('> Manufacture: ${_state.manufactureLevel}');
    score += _state.manufactureLevel;

    logLine('> Infrastructure: ${_state.infrastructureLevel}');
    score += _state.infrastructureLevel;

    int campaignCount = 0;
    for (final campaign in PieceType.campaignSuccess.pieces) {
      if (_state.pieceLocation(campaign).isType(LocationType.campaign)) {
        campaignCount += 1;
      }
    }
    logLine('> Campaign Victories: $campaignCount');
    score += campaignCount;

    int politicianCount = _state.piecesInLocationCount(PieceType.regularPolitician, Location.boxConfederateGovernment);
    logLine('> CSA Politicians: $politicianCount');
    score += politicianCount;

    int generalCount = 0;
    for (final general in PieceType.general.pieces) {
      final location = _state.pieceLocation(general);
      if (location.isType(LocationType.region) || location == Location.poolCsaGenerals) {
        generalCount += 1;
      }
    }
    for (final cavalry in PieceType.cavalry.pieces) {
      final location = _state.pieceLocation(cavalry);
      if (location.isType(LocationType.region) || location == Location.poolCsaGenerals) {
        generalCount += 1;
      }
    }
    logLine('> CSA Generals: $generalCount');
    score += generalCount;

    int slaveCount = 2 * _state.piecesInLocationCount(PieceType.slaves2, Location.boxSlaveQuarters) + _state.piecesInLocationCount(PieceType.slaves1, Location.boxSlaveQuarters);
    logLine('> Slaves: $slaveCount');
    score += slaveCount;

    if (_state.pieceLocation(Piece.campaignResultMormonRebels) == Location.campaignNewMexico) {
      logLine('> Mormon Rebels: 1');
      score += 1;
    }

    if (_state.pieceLocation(Piece.washingtonInPanic) == Location.regionWashingtonDC) {
      logLine('> Washington in Panic: 1');
      score += 1;
    }

    int die = rollD6();
    score += die;

    logLine('> Victory Points: $score');

    final result = score >= 30 ? GameResult.presidentMcClellan : GameResult.presidentLincoln; 

    if (score >= 30) {
      logLine('> General McClellan is elected President of the United States.');
      logLine('> A peace agreement is negotiated with the Confederate States of America.');
    } else {
      logLine('> Lincoln is reelected President of the United States.');
      logLine('> The war ends in total defeat for the Confederacy.');
    }

    throw GameOverException(result, score);
  }

  void turnChitPhaseCalendarEvent() {
    final calendarEventHandlers = {
      3: kentuckyVote,
      5: kentuckyRaid,
      7: csaElection1861,
      19: usElection1862,
      21: emancipation,
      25: twoBullets,
      31: csaElection1863,
      43: usElection1864,
    };
    final eventHandler = calendarEventHandlers[_state.currentTurn];
    if (eventHandler != null) {
      eventHandler();
    }
  }
 
  void turnChitPhaseUnionOffensive() {
    if (!_state.turnHasUnionOffensive(_state.currentTurn)) {
      return;
    }
    logLine('### Union Offensive');
    final path = _state.turnChitColoredPath(_state.currentTurnChit);
    if (path != null) {
      logLine('> Union conducts a Sustained Offensive on ${path.desc}.');
      _state.setPieceLocation(Piece.sustainedOffensive, _state.currentTurnCalendarBox);
    } else {
      int die = rollD6();
      final surprisePath = Path.values[die - 1];
      logLine('> Union conducts a Surprise Offensive on ${surprisePath.desc}.');
      _state.setPieceLocation(Piece.surpriseOffensive, _state.pathFinalRegion(surprisePath));
    }
  }

  void turnChitPhaseForeignIntervention() {
    if (_state.britishIntervention < 0 && _state.frenchIntervention < 0) {
      return;
    }
    int count = _state.turnChitForeignInterventionCount(_state.currentTurnChit);
    if (count == 0) {
      return;
    }
    logLine('### Foreign Intervention');
    if (_state.britishIntervention >= 0) {
      if (_state.adjustBritishIntervention(rollD6())) {
        logLine('> Britain recognizes the Confederacy.');
        _state.setPieceLocation(Piece.generalBritish2, Location.poolCsaGenerals);
        final frigates = _state.piecesInLocation(PieceType.frigate, Location.sack);
        for (final frigate in frigates) {
          _state.setPieceLocation(frigate, Location.discarded);
        }
      }
    }
    if (_state.frenchIntervention >= 0) {
      if (_state.adjustFrenchIntervention(rollD6())) {
        logLine('> France recognizes the Confederacy.');
        _state.setPieceLocation(Piece.generalFrench2, Location.poolCsaGenerals);
      }
    }
  }

  void turnChitPhaseMissouri() {
    if (_state.currentTurnChit != Piece.turnChit3) {
      return;
    }
    logLine('### Missouri');
    logLine('> Missouri Governor attempts to join the CSA.');
    int die = rollD6();
    for (int i = 1; 2 * i <= die; ++i) {
      _state.setPieceLocation(PieceType.missouriRebel2.pieces[i - 1], Location.regionCairo);
    }
    if (die % 2 == 1) {
      _state.setPieceLocation(Piece.missouriRebel1_2, Location.regionCairo);
    }
  }

  void turnChitPhaseEconomicLossesLogHeading() {
    final lossPieces = _state.turnChitEconomicLosses(_state.currentTurnChit);
    if (lossPieces.isNotEmpty) {
      logLine('### Economic Losses');
    }
  }

  void turnChitPhaseEconomicLosses(int index) {
    final phaseState = _phaseState as PhaseStateTurnChit;
    phaseState.defeatFizzled = false;
    phaseState.bushwhacker = false;

    final lossPieces = _state.turnChitEconomicLosses(_state.currentTurnChit);
    if (index >= lossPieces.length) {
      return;
    }
    var piece = lossPieces[index];
    if (piece == null) {
      int die = rollD6();
      switch (die) {
      case 1:
      case 2:
        piece = Piece.agricultureLevel;
      case 3:
      case 4:
        piece = Piece.manufactureLevel;
      case 5:
      case 6:
        piece = Piece.infrastructureLevel;
      }
    }
    bool defeatFizzled;
    bool bushwhacker;
    (defeatFizzled, bushwhacker) = economicLoss(piece!);
    phaseState.defeatFizzled = defeatFizzled;
    phaseState.bushwhacker = bushwhacker;
  }

  void turnChitPhaseEconomicLosses0() {
    turnChitPhaseEconomicLosses(0);
  }

  void turnChitPhaseEconomicLosses1() {
    turnChitPhaseEconomicLosses(1);
  }

  void turnChitPhaseDefeatFizzledPlayerActions() {
    final phaseState = _phaseState as PhaseStateTurnChit;
    if (!phaseState.defeatFizzled) {
      return;
    }
    defeatFizzledPlayerActions();
  }

  void turnChitPhaseBushwacker() {
    final phaseState = _phaseState as PhaseStateTurnChit;
    if (!phaseState.bushwhacker) {
      return;
    }
    while (true) {
      if (checkChoiceAndClear(Choice.cancel)) {
        clearChoices();
      }
      if (choicesEmpty()) {
        setPrompt('Select Bushwhacker');
        for (final bushwhacker in _state.piecesInLocation(PieceType.bushwhacker, Location.trayMilitary)) {
          pieceChoosable(bushwhacker);
        }
        throw PlayerChoiceException();
      }
      final bushwhacker = selectedPiece()!;
      final region = selectedLocation();
      if (region == null) {
        setPrompt('Select Union Army to place Bushwhacker with.');
        for (final region in bushwhackerRegionCandidates) {
          locationChoosable(region);
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      logLine('> ${bushwhacker.desc} is placed in ${region.desc}.');
      _state.setPieceLocation(bushwhacker, region);
      return;
    }
  }

  void turnChitPhaseMoneyFromMexico() {
    if (![Piece.turnChit14, Piece.turnChit22].contains(_state.currentTurnChit)) {
      return;
    }
    if (_state.piecesInLocationCount(PieceType.closed, Location.regionEastTexas) > 0) {
      return;
    }
    logLine('### Money from Mexico');
    int die = rollD6();
    adjustTreasury(die);
  }

  void turnChitPhaseSupplyLinesCut() {
    if (_state.piecesInLocationCount(PieceType.linesCutP1, Location.trayStrategic) == 0) {
      return;
    }
    logLine('### Lines Cut');
    final newRegion = randRegion();
    bool newPositive = _state.regionIsUnionControlled(newRegion);
    final path = _state.regionPath(newRegion)!;
    Piece? oldLineCut = _state.pathLinesCut(path);
    bool oldPositive = false;
    if (oldLineCut != null) {
      oldPositive = oldLineCut.isType(PieceType.linesCutP1);
    }
    if (oldLineCut == null || oldPositive == newPositive) {
      Piece? newLineCut;
      if (oldLineCut != null) {
        newLineCut = oldLineCut;
      } else {
        newLineCut = _state.piecesInLocation(PieceType.linesCutP1, Location.trayStrategic)[0];
        if (!newPositive) {
          newLineCut = _state.pieceFlipSide(newLineCut);
        }
      }
      if (newPositive) {
        logLine('> Union supply lines are cut in ${newRegion.desc}.');
      } else {
        logLine('> Confederate supply lines are cut in ${newRegion.desc}.');
      }
      _state.setPieceLocation(newLineCut!, newRegion);
    } else {
      final oldRegion = _state.pieceLocation(oldLineCut);
      if (oldPositive) {
        logLine('> Union supply lines are restored in ${oldRegion.desc}.');
      } else {
        logLine('> Confederate supply lines are restored in ${oldRegion.desc}.');
      }
      _state.setPieceLocation(oldLineCut, Location.trayStrategic);
    }
  }

  void turnChitPhaseSupplyLinesCut0() {
    const turnChits = [
      Piece.turnChit4,
      Piece.turnChit6,
      Piece.turnChit8,
      Piece.turnChit9,
      Piece.turnChit10,
      Piece.turnChit13,
      Piece.turnChit14,
      Piece.turnChit17,
      Piece.turnChit18,
      Piece.turnChit19,
      Piece.turnChit20,
      Piece.turnChit22,
      Piece.turnChit23,
      Piece.turnChit30,
      Piece.turnChit32,
      Piece.turnChit33,
      Piece.turnChit34,
      Piece.turnChit37,
    ];
    if (!turnChits.contains(_state.currentTurnChit)) {
      return;
    }
    turnChitPhaseSupplyLinesCut();
  }

  void turnChitPhaseSupplyLinesCut1() {
    const turnChits = [
      Piece.turnChit8,
      Piece.turnChit37,
    ];
    if (!turnChits.contains(_state.currentTurnChit)) {
      return;
    }
    turnChitPhaseSupplyLinesCut();
  }

  (bool, int, int) campaign(Location campaignBox, int victoryThreshold) {
    final success = _state.piecesInLocation(PieceType.campaignSuccess, Location.trayStrategic)[0];
    final failure = _state.pieceFlipSide(success)!;
    if (choicesEmpty()) {
      setPrompt('Select amount to spend on Campaign');
      for (int i = 0; i < _state.specialCampaignBudget; ++i) {
        locationChoosable(_state.treasuryBox(i));
      }
      choiceChoosable(Choice.concedeCampaign, true);
      throw PlayerChoiceException();
    }
    _state.setPieceLocation(Piece.nextCampaign, Location.values[_state.pieceLocation(Piece.nextCampaign).index + 1]);
    if (checkChoiceAndClear(Choice.concedeCampaign)) {
      logLine('> The Confederacy concedes ${campaignBox.desc}.');
      _state.setPieceLocation(failure, campaignBox);
      return (false, 0, 0);
    }
    final treasuryBox = selectedLocation()!;
    int amount = _state.treasuryBoxValue(treasuryBox);
    if (amount > 0) {
      adjustSpecialCampaignBudget(-amount);
    }
    final dice = roll2D6();
    int modifiers = 0;
    for (final campaignModifier in _state.piecesInLocation(PieceType.campaignModifier, campaignBox)) {
      if (campaignModifier.isType(PieceType.campaignModifierP1)) {
        logLine('> ${campaignModifier.desc}: +1');
        modifiers += 1;
      } else {
        logLine('> ${campaignModifier.desc}: -1');
        modifiers -= 1;
      }
    }
    int total = dice.$3 + amount + modifiers;
    logLine('> Total: $total');
    if (total >= victoryThreshold) {
      logLine('> The Confederacy wins ${campaignBox.desc}.');
      _state.setPieceLocation(success, campaignBox);
      return (true, dice.$3, amount);
    } else {
      logLine('> The Confederacy loses ${campaignBox.desc}.');
      _state.setPieceLocation(failure, campaignBox);
      return (false, dice.$3, amount);
    }
  }

  void campaignNewMexico() {
    if (_subStep == 0) {
      logLine('### New Mexico');
      _subStep = 1;
    }
    if (_subStep == 1) {
      final results = campaign(Location.campaignNewMexico, 12);
      if (results.$1 && results.$2 >= 11) {
        logLine('> Success in New Mexico encourages Mormons to revolt.');
        _state.setPieceLocation(Piece.campaignResultMormonRebels, Location.campaignNewMexico);
      }
    }
  }

  void campaignPeninsula() {
    if (_subStep == 0) {
      logLine('### Peninsula Campaign');
      _subStep = 1;
    }
    if (_subStep == 1) {
      // TODO
    }
  }

  void campaignHeartlandOffensive() {
    if (_subStep == 0) {
      logLine('### Heartland Offensive');
      if (_state.kentuckyNeutral) {
        int die = rollD6();
        if (die <= 4) {
          logLine('> Kentucky joins the Union.');
          kentuckyJoinsTheUnion();
        } else {
          logLine('> Kentucky joins the Confederacy.');
          kentuckyJoinsTheConfederacy();
        }
      }
      _subStep = 1;
    }
    if (_subStep == 1) {
      campaign(Location.campaignHeartlandOffensive, 13);
    }
  }

  void campaignMorgansRaid() {
    if (_subStep == 0) {
      logLine('### Morgan’s Raid');
      _subStep = 1;
    }
    if (_subStep == 1) {
      final results = campaign(Location.campaignMorgansRaid, 13);
      if (results.$1) {
        logLine('> Successful raid by Morgan reaps rewards.');
        final amount = results.$3;
        int die = rollD6();
        adjustTreasury(amount + die);
      }
      _state.setPieceLocation(Piece.objective, Location.regionMarylandAndPennsylvania);
    }
  }

  void campaignIndianTerritory() {
    if (_subStep == 0) {
      logLine('### Indian Territory');
      _subStep = 1;
    }
    if (_subStep == 1) {
      final results = campaign(Location.campaignIndianTerritory, 13);
      if (results.$1) {
        logLine('> Indian units provide assistance in Missouri and Arkansas.');
        final indians = PieceType.campaignModifierP1Indian.pieces;
        indians.shuffle(_random);
        _state.setPieceLocation(indians[0], Location.campaignPriceInMissouri);
        _state.setPieceLocation(indians[1], Location.campaignArkansas);
      }
    }
  }

  void campaignArkansas() {
    if (_subStep == 0) {
      logLine('### Arkansas Campaign');
      _subStep = 1;
    }
    if (_subStep == 1) {
      final results = campaign(Location.campaignArkansas, 11);
      if (results.$1) {
        logLine('> Shelby begins operations in Missouri.');
        _state.setPieceLocation(Piece.campaignModifierShelbyP1, Location.campaignPriceInMissouri);
      }
      _state.setPieceLocation(Piece.objective, Location.regionWashingtonDC);
    }
  }

  void campaignKirksRaiders() {
    if (_subStep == 0) {
      logLine('### Kirk’s Raiders');
      _subStep = 1;
    }
    if (_subStep == 1) {
      campaign(Location.campaignKirksRaiders, 10);
      logLine('> Sheridan transfers to the Eastern Theater.');
      _state.flipPiece(Piece.armyMiddleDepartment);
      if (_state.pieceLocation(Piece.armyGulf).isType(LocationType.region)) {
        logLine('> Banks takes command of the Army of the Gulf.');
        _state.flipPiece(Piece.armyGulf);
      }
    }
  }

  void campaignPriceInMissouri() {
    if (_subStep == 0) {
      logLine('### Price in Missouri');
      _subStep = 1;
    }
    if (_subStep == 1) {
      campaign(Location.campaignPriceInMissouri, 12);
    }
  }

  void campaignEconomicDisaster() {
    final phaseState = _phaseState as PhaseStateTurnChit;
    phaseState.defeatFizzled = false;
    phaseState.bushwhacker = false;
    logLine('### Economic Disaster');
    Piece? piece;
    int die = rollD6();
    switch (die) {
    case 1:
    case 2:
      piece = Piece.agricultureLevel;
    case 3:
    case 4:
      piece = Piece.manufactureLevel;
    case 5:
    case 6:
      piece = Piece.infrastructureLevel;
    }
    economicDisaster(piece!);
    phaseState.defeatFizzled = true;
  }

  void turnChitPhaseCampaign() {
    final phaseState = _phaseState as PhaseStateTurnChit;
    const turnChits = [
      Piece.turnChit12,
      Piece.turnChit16,
      Piece.turnChit18,
      Piece.turnChit26,
      Piece.turnChit29,
      Piece.turnChit30,
      Piece.turnChit40,
      Piece.turnChit42,
      Piece.turnChit44,
    ];
    if (!turnChits.contains(_state.currentTurnChit)) {
      return;
    }
    final campaignHandlers = {
      Location.boxCampaignRedStar: campaignNewMexico,
      Location.boxCampaignNewMexico: campaignPeninsula,
      Location.boxCampaignPeninsula: campaignHeartlandOffensive,
      Location.boxCampaignHeartlandOffensive: campaignMorgansRaid,
      Location.boxCampaignMorgansRaid: campaignIndianTerritory,
      Location.boxCampaignIndianTerritory: campaignArkansas,
      Location.boxCampaignArkansas: campaignKirksRaiders,
      Location.boxCampaignKirksRaiders: campaignPriceInMissouri,
      Location.boxCampaignPriceInMissouri: campaignEconomicDisaster,
    };
    campaignHandlers[_state.pieceLocation(Piece.nextCampaign)]!();
    phaseState.campaigned = true;
  }

  void turnChitPhaseNextCampaign() {
    final phaseState = _phaseState as PhaseStateTurnChit;
    if (!phaseState.campaigned) {
      return;
    }
    final location = _state.pieceLocation(Piece.nextCampaign);
    _state.setPieceLocation(Piece.nextCampaign, Location.values[location.index + 1]);
  }

  void turnChitPhaseArmyOfTheGulf() {
    final location = _state.pieceLocation(Piece.armyGulf);
    if (location != Location.trayUnionForces) {
      return;
    }


  }

  void turnChitPhaseEnd() {
    _phaseState = null;
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      setUpGenerals,
      turnBegin,
      drawChitPhaseBegin,
      drawChitDrawChit,
      turnChitPhaseBegin,
      turnChitPhaseDeployBlockadeRunners,
      turnChitPhaseDeployFrigates,
      turnChitPhaseSinkBlockadeRunners,
      turnChitPhaseEconomicHaul,
      turnChitPhaseSpecialCampaignBudget,
      turnChitPhaseCalendarEvent,
      turnChitPhaseUnionOffensive,
      turnChitPhaseForeignIntervention,
      turnChitPhaseMissouri,
      turnChitPhaseEconomicLossesLogHeading,
      turnChitPhaseEconomicLosses0,
      turnChitPhaseDefeatFizzledPlayerActions,
      turnChitPhaseBushwacker,
      turnChitPhaseEconomicLosses1,
      turnChitPhaseDefeatFizzledPlayerActions,
      turnChitPhaseBushwacker,
      turnChitPhaseMoneyFromMexico,
      turnChitPhaseSupplyLinesCut0,
      turnChitPhaseSupplyLinesCut1,
      turnChitPhaseCampaign,
      turnChitPhaseDefeatFizzledPlayerActions,
      turnChitPhaseNextCampaign,
      turnChitPhaseArmyOfTheGulf,
      turnChitPhaseEnd,
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

import 'dart:convert';
import 'dart:math';
import 'package:global_war/db.dart';

enum Location {
  frontWestern,
  frontEastern,
  frontMed,
  frontChina,
  frontSoutheastAsia,
  frontSouthPacific,
  partisansWestern,
  partisansEastern,
  partisansMed,
  partisansChina,
  partisansSoutheastAsia,
  partisansSouthPacific,
  seaMidway,
  seaPhilippine,
  seaCoral,
  regionBalkans,
  regionBelgianCongo,
  regionBurmaRoad,
  regionCaucasus,
  regionDutchEastIndies,
  regionFinland,
  regionFrenchMadagascar,
  regionFrenchNorthAfrica,
  regionIndia,
  regionItalianEastAfrica,
  regionNearEast,
  regionSinkiang,
  regionSouthAfrica,
  seaZone1A,
  seaZone1B,
  seaZone2A,
  seaZone2B,
  seaZone2C,
  seaZone3,
  seaZone4,
  boxAlliedAirBases,
  boxAttuAndKiska,
  boxAvailableConvoys,
  boxAxisCommandos,
  boxGermanUboats,
  boxGermany,
  boxHawaii,
  boxJapan,
  boxKureNavalBase,
  boxNorway,
  boxPartisansPool,
  boxTito,
  boxUSEastCoast,
  boxAlliedLeadershipAmerican,
  boxAlliedLeadershipBritish,
  boxAlliedLeadershipRussian,
  boxSovietPolicyNeutral,
  boxSovietPolicyWarVsGermany,
  boxSovietPolicyWarVJapan,
  boxCitiesHighMorale,
  boxCitiesLowMorale,
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
  omnibus13,
  calendar1,
  calendar2,
  calendar3,
  calendar4,
  calendar5,
  calendar6,
  calendar7,
  calendar8,
  calendar9,
  calendar10,
  calendar11,
  calendar12,
  calendar13,
  calendar14,
  calendar15,
  calendar16,
  calendar17,
  calendar18,
  calendar19,
  calendar20,
  calendar21,
  calendar22,
  calendar23,
  calendar24,
  calendar25,
  calendar26,
  calendar27,
  eventWavell,
  eventGalland,
  eventYamashita,
  eventRommel,
  eventZhukov,
  eventManstein,
  eventOperationKutuzov,
  eventMacArthur,
  eventOperationIchiGo,
  eventPatton,
  eventWachtAmRhein,
  eventSlim,
  event4thWarArea,
  eventBanzaiAttacks,
  cupTurn,
  cupCarrier,
  reservesWestern,
  reservesEastern,
  reservesMed,
  reservesChina,
  reservesSoutheastAsia,
  reservesSouthPacific,
  trayBlitz,
  trayEconomic,
  trayFrench,
  trayGermanGround,
  trayGermanNavy,
  trayItalian,
  trayJapaneseGround,
  trayJapaneseNavy,
  trayMarkers,
  trayPartisans,
  trayPolitical,
  trayProAxisMinors,
  trayProUnMinors,
  traySiege,
  trayStrategy,
  trayTurn,
  trayUnCities,
  trayUnNaval,
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
  front,
  germanFront,
  japaneseFront,
  partisans,
  region,
  sea,
  seaZone,
  boxSovietPolicy,
  boxCities,
  omnibus,
  calendar,
  event,
  reserves,
  tray,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.front: [Location.frontWestern, Location.frontSouthPacific],
    LocationType.germanFront: [Location.frontWestern, Location.frontMed],
    LocationType.japaneseFront: [Location.frontChina, Location.frontSouthPacific],
    LocationType.partisans: [Location.partisansWestern, Location.partisansSouthPacific],
    LocationType.region: [Location.regionBalkans, Location.regionSouthAfrica],
    LocationType.sea: [Location.seaMidway, Location.seaCoral],
    LocationType.seaZone: [Location.seaZone1A, Location.seaZone4],
    LocationType.boxSovietPolicy: [Location.boxSovietPolicyNeutral, Location.boxSovietPolicyWarVJapan],
    LocationType.boxCities: [Location.boxCitiesHighMorale, Location.boxCitiesLowMorale],
    LocationType.omnibus: [Location.omnibus0, Location.omnibus13],
    LocationType.calendar: [Location.calendar1, Location.calendar27],
    LocationType.event: [Location.eventWavell, Location.eventBanzaiAttacks],
    LocationType.reserves: [Location.reservesWestern, Location.reservesSouthPacific],
    LocationType.tray: [Location.trayBlitz, Location.trayUnNaval],
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
  capitalBerlin,
  capitalHitler,
  capitalGoring,
  capitalWestwall,
  capitalCcnn,
  capitalMussolini,
  capitalTokyo,
  capitalManchukuo,
  capitalThailand,
  armyChineseCommunist,
  armyCongo,
  armyFinnish,
  armyGerman10,
  armyGerman14,
  armyGermanA,
  armyGermanAfrikaKorps,
  armyGermanArnim,
  armyGermanB,
  armyGermanBf109,
  armyGermanC,
  armyGermanCenter,
  armyGermanDo17,
  armyGermanG,
  armyGermanHe111,
  armyGermanIraq,
  armyGermanJu88,
  armyGermanNorth,
  armyGermanSouth,
  armyGermanSyria,
  armyHungarian,
  armyIranianShah,
  armyIranianVatan,
  armyIraqi,
  armyItalian5,
  armyItalian10,
  armyItalianBers,
  armyItalianCol,
  armyItalianLig,
  armyItalianEastAfrica,
  armyJapanese14,
  armyJapanese15,
  armyJapanese18,
  armyJapanese28,
  armyJapanese31,
  armyJapanese32,
  armyJapaneseBurmese,
  armyJapaneseCcaa,
  armyJapaneseIndian,
  armyJapaneseMadag,
  armyJapaneseNcaa,
  armyJapaneseWang,
  armyRomanian,
  armySinkiang,
  armyTurkish,
  armyVichyAlger,
  armyVichyMalg,
  armyVichySyria,
  blitzWestern,
  blitzEastern,
  blitzMed,
  blitzChina,
  blitzSoutheastAsia,
  blitzSouthPacific,
  panzerPza,
  panzerTiger,
  armyPolish1,
  armyPolish2,
  armyDanish,
  armyNorwegian,
  armyDutch,
  armyBelgian,
  armyFrench1,
  armyFrench2,
  armyYugoslavian,
  armyGreek,
  armyWarsaw,
  armyTito,
  armySingapore,
  armyKnil,
  armyBataan,
  shipTanakaDestroyers,
  shipYamato,
  shipAkagi,
  shipZuikaku,
  shipHiryu,
  shipChokai,
  shipKongo,
  shipZeroRed,
  shipIboatsRed,
  shipRyujo,
  shipZuiho,
  shipAoba,
  shipTaiho,
  shipAkizukiDestroyers,
  shipNagato,
  shipHiyo,
  shipShinano,
  shipChitose,
  shipTone,
  shipHaruna,
  shipZeroWhite,
  shipIboatsWhite,
  shipUnryu,
  shipIse,
  shipYahagi,
  shipKamikaze,
  shipYamamoto,
  carrierBunkerHill,
  carrierEnterprise,
  carrierEssex,
  carrierFdr,
  carrierHornet,
  carrierIntrepid,
  carrierLangley,
  carrierLexington,
  carrierMidawy,
  carrierPrinceton,
  carrierRanger,
  carrierSaratoga,
  carrierTiconderoga,
  carrierWasp,
  carrierYorktown,
  strategyWestern,
  strategyEastern,
  strategyMed,
  strategyChina,
  strategySoutheastAsia,
  strategySouthPacific,
  occupiedWestern,
  occupiedEastern,
  occupiedMed,
  occupiedChina,
  occupiedSoutheastAsia,
  occupiedSouthPacific,
  abombWestern,
  abombEastern,
  abombMed,
  abombChina,
  abombSoutheastAsia,
  abombSouthPacific,
  siegeNormandy,
  siegeStalingrad,
  siegeTunis,
  siegeImphal,
  siegeGuadalcanal,
  siegeTightensNormandy,
  siegeTightensStalingrad,
  siegeTightensTunis,
  siegeTightensImphal,
  siegeTightensGuadalcanal,
  policyItaly,
  policyJapanSoutheastAsia,
  policyJapanSouthPacific,
  policyRussia,
  policySpainAxis,
  policySpainUN,
  partisans0,
  partisans1,
  partisansCommunist0,
  partisansCommunist1,
  partisansSoviet,
  partisansItalian,
  malta,
  maltaBesieged,
  ricksPlace,
  vichyFleetPeace,
  vichyFleetWar,
  congoUN,
  southAfricaUN,
  southAfricaNeutral,
  occupiedDutchEastIndies,
  greekSurrender,
  burmaRoadOpen,
  burmaRoadClosed,
  burmaRoadHump,
  finlandUN,
  indiaGandhi,
  indiaRevolt,
  sinkiangUssr,
  escortSaoPaulo,
  asw,
  aswEnigma,
  convoyAmerican0,
  convoyAmerican1,
  convoyBritish,
  convoyFrench,
  convoyNorwegian,
  convoyEscorted0,
  convoyEscorted1,
  convoyEscorted2,
  convoyEscorted3,
  raiderGrafSpee,
  raiderKormoran,
  raiderBismarck,
  raiderPrinzEugen,
  raiderScharnhorst,
  raiderRivadavia,
  uboats0,
  uboats1,
  uboats2,
  uboats3,
  airBaseBritish,
  airBaseUsaaf,
  airBaseUsstaf,
  airBaseTinian,
  operationAL,
  commandoSkorzeny,
  commandoTeishinShudan,
  spruanceP1,
  spruanceP2,
  usMarines,
  submarineCampaign,
  lendLeaseLibertyShips,
  lendLeaseJeepsTrucks,
  lendLeaseDestroyerDeal,
  lendLeaseAidToRussia,
  economyGerman,
  economyJapanese,
  noAxisAttackGermany,
  noAxisAttackJapanese,
  leaderChamberlain,
  leaderChurchill,
  leaderRoosevelt,
  leaderWilkie,
  leaderStalin,
  leaderStalinUsed,
  cityChicago,
  cityNewYork,
  citySanFrancisco,
  citySydney,
  cityGlasgow,
  cityLondon,
  cityChungking,
  cityDelhi,
  citySingapore,
  cityMontreal,
  cityAlgiers,
  cityBaku,
  cityLeningrad,
  cityMoscow,
  cityGorky,
  cityTashkent,
  cityTbilisi,
  abombResearch,
  abombAvailable,
  dollars,
  dollarsEscort,
  navalActions1,
  navalActions2,
  cannonMeat,
  aidChina,
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
  turnChitBarbarossa,
  turnChitPearlHarbor,
  militaryEvent,
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
  proAxisOrVichyArmy,
  proAxisArmy,
  capital,
  italianCapital,
  japaneseCapital,
  proAxisOrVichyNonCapitalArmy,
  proAxisNonCapitalArmy,
  iranianArmy,
  italianArmy,
  japaneseArmy,
  blitz,
  panzer,
  propArmy,
  frenchArmy,
  ship,
  shipFront,
  carrier,
  strategy,
  occupied,
  siege,
  siegeInitial,
  siegeTightens,
  partisansAndMalta,
  partisans,
  asw,
  convoy,
  escortedConvoy,
  raider,
  uboats,
  raiderOrUboat,
  spruance,
  lendLease,
  leader,
  leaderAmerican,
  city,
  alliedUsaCity,
  alliedNonUsaCity,
  alliedCity,
  sovietFaceUpCity,
  sovietFaceDownCity,
  sovietCity,
  dollars,
  navalActions,
  turnChit,
  randomTurnChit,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.capitalBerlin, Piece.militaryEvent],
    PieceType.proAxisOrVichyArmy: [Piece.capitalBerlin, Piece.armyVichySyria],
    PieceType.proAxisArmy: [Piece.capitalBerlin, Piece.armyTurkish],
    PieceType.capital: [Piece.capitalBerlin, Piece.capitalTokyo],
    PieceType.italianCapital: [Piece.capitalCcnn, Piece.capitalMussolini],
    PieceType.japaneseCapital: [Piece.capitalTokyo, Piece.capitalManchukuo],
    PieceType.proAxisOrVichyNonCapitalArmy: [Piece.armyChineseCommunist, Piece.armyVichySyria],
    PieceType.proAxisNonCapitalArmy: [Piece.armyChineseCommunist, Piece.armyTurkish],
    PieceType.iranianArmy: [Piece.armyIranianShah, Piece.armyIranianVatan],
    PieceType.italianArmy: [Piece.armyItalian5, Piece.armyItalianEastAfrica],
    PieceType.japaneseArmy: [Piece.armyJapanese14, Piece.armyJapaneseWang],
    PieceType.blitz: [Piece.blitzWestern, Piece.blitzSouthPacific],
    PieceType.panzer: [Piece.panzerPza, Piece.panzerTiger],
    PieceType.propArmy: [Piece.armyPolish1, Piece.armyBataan],
    PieceType.frenchArmy: [Piece.armyFrench1, Piece.armyFrench2],
    PieceType.ship: [Piece.shipTanakaDestroyers, Piece.shipYamamoto],
    PieceType.shipFront: [Piece.shipTanakaDestroyers, Piece.shipTaiho],
    PieceType.carrier: [Piece.carrierBunkerHill, Piece.carrierYorktown],
    PieceType.strategy: [Piece.strategyWestern, Piece.strategySouthPacific],
    PieceType.occupied: [Piece.occupiedWestern, Piece.occupiedSouthPacific],
    PieceType.siege: [Piece.siegeNormandy, Piece.siegeTightensGuadalcanal],
    PieceType.siegeInitial: [Piece.siegeNormandy, Piece.siegeGuadalcanal],
    PieceType.siegeTightens: [Piece.siegeTightensNormandy, Piece.siegeTightensGuadalcanal],
    PieceType.partisans: [Piece.partisans0, Piece.partisansItalian],
    PieceType.partisansAndMalta: [Piece.partisans0, Piece.maltaBesieged],
    PieceType.asw: [Piece.asw, Piece.aswEnigma],
    PieceType.convoy: [Piece.convoyAmerican0, Piece.convoyEscorted3],
    PieceType.escortedConvoy: [Piece.convoyEscorted0, Piece.convoyEscorted3],
    PieceType.raider: [Piece.raiderGrafSpee, Piece.raiderRivadavia],
    PieceType.uboats: [Piece.uboats0, Piece.uboats3],
    PieceType.raiderOrUboat: [Piece.raiderGrafSpee, Piece.uboats3],
    PieceType.spruance: [Piece.spruanceP1, Piece.spruanceP2],
    PieceType.lendLease: [Piece.lendLeaseLibertyShips, Piece.lendLeaseAidToRussia],
    PieceType.leader: [Piece.leaderChamberlain, Piece.leaderStalinUsed],
    PieceType.leaderAmerican: [Piece.leaderRoosevelt, Piece.leaderWilkie],
    PieceType.city: [Piece.cityChicago, Piece.cityTbilisi],
    PieceType.alliedUsaCity: [Piece.cityChicago, Piece.citySanFrancisco],
    PieceType.alliedNonUsaCity: [Piece.citySydney, Piece.cityAlgiers],
    PieceType.alliedCity: [Piece.cityChicago, Piece.cityAlgiers],
    PieceType.sovietFaceUpCity: [Piece.cityBaku, Piece.cityMoscow],
    PieceType.sovietFaceDownCity: [Piece.cityGorky, Piece.cityTbilisi],
    PieceType.sovietCity: [Piece.cityBaku, Piece.cityTbilisi],
    PieceType.dollars: [Piece.dollars, Piece.dollarsEscort],
    PieceType.navalActions: [Piece.navalActions1, Piece.navalActions2],
    PieceType.turnChit: [Piece.turnChit1, Piece.turnChitPearlHarbor],
    PieceType.randomTurnChit: [Piece.turnChit6, Piece.turnChit28],
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
      Piece.capitalBerlin: 'German Berlin Capital',
      Piece.capitalCcnn: 'Italian CCNN Capital',
      Piece.capitalGoring: 'German Göring Capital',
      Piece.capitalHitler: 'German Hitler Capital',
      Piece.capitalManchukuo: 'Japanese Manchukuo Capital',
      Piece.capitalMussolini: 'Italian Mussolini Capital',
      Piece.capitalThailand: 'Thai Thailand Capital',
      Piece.capitalTokyo: 'Japanese Tokyo Capital',
      Piece.capitalWestwall: 'German Westwall Capital',
      Piece.armyChineseCommunist: 'CCP Red Army',
      Piece.armyCongo: 'Belgian Congo Rexists Army',
      Piece.armyFinnish: 'Finnish Mannerheim Army',
      Piece.armyGerman10: 'German 10th Army',
      Piece.armyGerman14: 'German 14th Army',
      Piece.armyGermanA: 'German A Army',
      Piece.armyGermanAfrikaKorps: 'German Afrika Korps',
      Piece.armyGermanArnim: 'German Arnim Army',
      Piece.armyGermanB: 'German B Army',
      Piece.armyGermanBf109: 'German Bf 109 Aircraft',
      Piece.armyGermanC: 'German C Army',
      Piece.armyGermanCenter: 'German Center Army',
      Piece.armyGermanDo17: 'German Do17 Aircraft',
      Piece.armyGermanG: 'German G Army',
      Piece.armyGermanHe111: 'German He111 Aircraft',
      Piece.armyGermanIraq: 'German Iraq Army',
      Piece.armyGermanJu88: 'German Ju88 Aircraft',
      Piece.armyGermanNorth: 'German North Army',
      Piece.armyGermanSouth: 'German South Army',
      Piece.armyGermanSyria: 'German Syria Army',
      Piece.armyHungarian: 'Hungarian Szálasi Army',
      Piece.armyIranianShah: 'Iranian Shah Army',
      Piece.armyIranianVatan: 'Iranian Vatan Army',
      Piece.armyIraqi: 'Iraqi Gailani Army',
      Piece.armyItalian5: 'Italian 5th Army',
      Piece.armyItalian10: 'Italian 10th Army',
      Piece.armyItalianBers: 'Italian Bersaglieri Army',
      Piece.armyItalianCol: 'Italian Colonial Army',
      Piece.armyItalianLig: 'Italian Ligurian Army',
      Piece.armyItalianEastAfrica: 'AOI d’Aosta Army',
      Piece.armyJapanese14: 'Japanese 14th Army',
      Piece.armyJapanese15: 'Japanese 15th Army',
      Piece.armyJapanese18: 'Japanese 18th Army',
      Piece.armyJapanese28: 'Japanese 28th Army',
      Piece.armyJapanese31: 'Japanese 31st Army',
      Piece.armyJapanese32: 'Japanese 32nd Army',
      Piece.armyJapaneseBurmese: 'Japanese Burmese Army',
      Piece.armyJapaneseCcaa: 'Japanese CC AA Army',
      Piece.armyJapaneseIndian: 'Japanese Indian Army',
      Piece.armyJapaneseMadag: 'Japanese Madagascar Army',
      Piece.armyJapaneseNcaa: 'Japanese NC AA Army',
      Piece.armyJapaneseWang: 'Japanese Wang Jingwei Army',
      Piece.armyRomanian: 'Romanian Antonescu Army',
      Piece.armySinkiang: 'Sinkiang Pro-Japan Army',
      Piece.armyTurkish: 'Turkish İnönü Army',
      Piece.armyVichyAlger: 'Vichy Algerian Army',
      Piece.armyVichyMalg: 'Vichy Malagasy Army',
      Piece.armyVichySyria: 'Vichy Syrian Army',
      Piece.carrierBunkerHill: 'Bunker Hill',
      Piece.carrierEnterprise: 'Enterprise',
      Piece.carrierEssex: 'Essex',
      Piece.carrierFdr: 'FDR',
      Piece.carrierHornet: 'Hornet',
      Piece.carrierIntrepid: 'Intrepid',
      Piece.carrierLangley: 'Langley',
      Piece.carrierLexington: 'Lexington',
      Piece.carrierMidawy: 'Midway',
      Piece.carrierPrinceton: 'Princeton',
      Piece.carrierRanger: 'Ranger',
      Piece.carrierSaratoga: 'Saratoga',
      Piece.carrierTiconderoga: 'Ticonderoga',
      Piece.carrierWasp: 'Wasp',
      Piece.carrierYorktown: 'Yorktown',
      Piece.asw: 'ASW',
      Piece.aswEnigma: 'ASW (Enigma)',
      Piece.convoyAmerican0: 'American Convoy',
      Piece.convoyAmerican1: 'American Convoy',
      Piece.convoyBritish: 'British Convoy',
      Piece.convoyFrench: 'French Convoy',
      Piece.convoyNorwegian: 'Norwegian Convoy',
      Piece.convoyEscorted0: 'Escorted Convoy',
      Piece.convoyEscorted1: 'Escorted Convoy',
      Piece.convoyEscorted2: 'Escorted Convoy',
      Piece.convoyEscorted3: 'Escorted Convoy',
      Piece.uboats0: 'U-Boats',
      Piece.uboats1: 'U-Boats',
      Piece.uboats2: 'U-Boats',
      Piece.uboats3: 'U-Boats',
      Piece.commandoSkorzeny: 'Otto Skorzeny',
      Piece.commandoTeishinShudan: 'Teishin Shudan',
      Piece.spruanceP1: 'Admiral Spruance (+1)',
      Piece.spruanceP2: 'Admiral Spruance (+2)',
      Piece.usMarines: 'US Marines',
      Piece.leaderChamberlain: 'Chamberlain',
      Piece.leaderChurchill: 'Churchill',
      Piece.leaderRoosevelt: 'Roosevelt',
      Piece.leaderWilkie: 'Wilkie',
      Piece.leaderStalin: 'Stalin',
      Piece.leaderStalinUsed: 'Stalin (Used)',
      Piece.cityChicago: 'Chicago',
      Piece.cityNewYork: 'New York',
      Piece.citySanFrancisco: 'San Francisco',
      Piece.citySydney: 'Sydney',
      Piece.cityGlasgow: 'Glasgow',
      Piece.cityLondon: 'London',
      Piece.cityChungking: 'Chungking',
      Piece.cityDelhi: 'Delhi',
      Piece.citySingapore: 'Singapore',
      Piece.cityMontreal: 'Montréal',
      Piece.cityAlgiers: 'Algiers',
      Piece.cityBaku: 'Baku',
      Piece.cityLeningrad: 'Leningrad',
      Piece.cityMoscow: 'Moscow',
      Piece.cityGorky: 'Gorky',
      Piece.cityTashkent: 'Tashkent',
      Piece.cityTbilisi: 'Tbilisi',
      Piece.turnChit1: 'Chit 1',
      Piece.turnChit2: 'Chit 2',
      Piece.turnChit3: 'Chit 3',
      Piece.turnChit4: 'Chit 4',
      Piece.turnChit5: 'Chit 5',
      Piece.turnChit6: 'Chit 6',
      Piece.turnChit7: 'Chit 7',
      Piece.turnChit8: 'Chit 8',
      Piece.turnChit9: 'Chit 9',
      Piece.turnChit10: 'Chit 10',
      Piece.turnChit11: 'Chit 11',
      Piece.turnChit12: 'Chit 12',
      Piece.turnChit13: 'Chit 13',
      Piece.turnChit14: 'Chit 14',
      Piece.turnChit15: 'Chit 15',
      Piece.turnChit16: 'Chit 16',
      Piece.turnChit17: 'Chit 17',
      Piece.turnChit18: 'Chit 18',
      Piece.turnChit19: 'Chit 19',
      Piece.turnChit20: 'Chit 20',
      Piece.turnChit21: 'Chit 21',
      Piece.turnChit22: 'Chit 22',
      Piece.turnChit23: 'Chit 23',
      Piece.turnChit24: 'Chit 24',
      Piece.turnChit25: 'Chit 25',
      Piece.turnChit26: 'Chit 26',
      Piece.turnChit27: 'Chit 27',
      Piece.turnChit28: 'Chit 28',
      Piece.turnChitBarbarossa: 'Operation Barbarossa!',
      Piece.turnChitPearlHarbor: 'Pearl Harbor Attacked!',
    };
    return pieceDescs[this]!;
  }

  bool isType(PieceType pieceType) {
    return index >= pieceType.firstIndex && index < pieceType.lastIndex;
  }
}

enum TurnChitDisk {
  white,
  red,
  yellow,
}

const turnChitData = {
  Piece.turnChit1: ([3, 0, 0, 0, 0, 0], 0, TurnChitDisk.white),
  Piece.turnChit2: ([7, 0, 0, 1, 0, 0], 0, TurnChitDisk.red),
  Piece.turnChit3: ([7, 0, 1, 0, 0, 0], 0, TurnChitDisk.red),
  Piece.turnChit4: ([1, 7, 2, 0, 0, 0], 0, TurnChitDisk.white),
  Piece.turnChit5: ([0, 3, 0, 0, 5, 0], 0, TurnChitDisk.red),
  Piece.turnChit6: ([0, 1, 1, 0, 2, 1], 0, TurnChitDisk.red),
  Piece.turnChit7: ([1, 0, 0, 0, 1, 2], 0, TurnChitDisk.white),
  Piece.turnChit8: ([1, 1, 2, 0, 1, 1], 0, TurnChitDisk.red),
  Piece.turnChit9: ([1, 2, 1, 1, 0, 1], 0, TurnChitDisk.red),
  Piece.turnChit10: ([0, 2, 0, 0, 0, 1], 0, TurnChitDisk.red),
  Piece.turnChit11: ([0, 1, 1, 1, 0, 0], 0, TurnChitDisk.red),
  Piece.turnChit12: ([0, 1, 1, 0, 0, 1], 0, TurnChitDisk.red),
  Piece.turnChit13: ([1, 1, 1, 0, 1, 0], 0, TurnChitDisk.white),
  Piece.turnChit14: ([1, 0, 0, 1, 1, 0], 0, TurnChitDisk.red),
  Piece.turnChit15: ([0, 2, 1, 0, 0, 1], 0, TurnChitDisk.yellow),
  Piece.turnChit16: ([0, 0, 1, 0, 1, 0], 0, TurnChitDisk.yellow),
  Piece.turnChit17: ([0, 0, 1, 0, 0, 1], 0, TurnChitDisk.white),
  Piece.turnChit18: ([1, 1, 1, 0, 1, 1], 0, TurnChitDisk.red),
  Piece.turnChit19: ([0, 1, 0, 1, 2, 0], 0, TurnChitDisk.red),
  Piece.turnChit20: ([1, 0, 2, 1, 1, 0], 0, TurnChitDisk.yellow),
  Piece.turnChit21: ([1, 1, 1, 2, 0, 1], 0, TurnChitDisk.red),
  Piece.turnChit22: ([0, 1, 0, 0, 0, 1], 1, TurnChitDisk.red),
  Piece.turnChit23: ([2, 0, 0, 1, 0, 1], 0, TurnChitDisk.white),
  Piece.turnChit24: ([1, 1, 0, 0, 1, 0], 1, TurnChitDisk.red),
  Piece.turnChit25: ([1, 1, 0, 1, 0, 0], 0, TurnChitDisk.yellow),
  Piece.turnChit26: ([0, 0, 0, 1, 1, 0], 1, TurnChitDisk.red),
  Piece.turnChit27: ([0, 1, 0, 1, 0, 1], 0, TurnChitDisk.red),
  Piece.turnChit28: ([0, 0, 0, 1, 0, 0], 2, TurnChitDisk.white),
};

enum PoliticalEvent {
  areaBombing,
  argentina,
  aungSan,
  congo,
  finland,
  gandhi,
  guadalcanal,
  imphal,
  iraq,
  italy,
  madagascar,
  quislings,
  romanianCoup,
  sarinGas,
  sinkiang,
  stalingrad,
  syria,
  tito,
  torch,
  typeXxiUboats,
  v1BuzzBombs,
  v2Rockets,
  vlasov,
  warsawUprising,
  aleutiansCampaign,
}

enum Scenario {
  campaign,
  turningPoint,
}

extension ScenarioExtension on Scenario {
  String get desc {
    const scenarioDescs = {
      Scenario.campaign: '1939 Campaign',
      Scenario.turningPoint: '1943 Turning Point',
    };
    return scenarioDescs[this]!;
  }

  String get longDesc {
    const scenarioDescs = {
      Scenario.campaign: '1939 Campaign (27 Turns)',
      Scenario.turningPoint: '1943 Turning Point  (15 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<bool> _politicalEventCurrents = List<bool>.filled(PoliticalEvent.values.length, false);
  List<int> _politicalEventCounts = List<int>.filled(PoliticalEvent.values.length, 0);
  Piece? _commandoAssistedArmy;

  GameState();

  GameState.fromJson(Map<String, dynamic> json) {
    _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']));
    _politicalEventCurrents = List<bool>.from(json['politicalEventCurrents']);
    _politicalEventCounts = List<int>.from(json['politicalEventCounts']);
    final pieceIndex = json['commandoAssistedArmy'] as int?;
    if (pieceIndex != null) {
      _commandoAssistedArmy = Piece.values[pieceIndex];
    } else {
      _commandoAssistedArmy = null;
    }
  }

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'politicalEventCurrents': _politicalEventCurrents,
    'politicalEventCounts': _politicalEventCounts,
    'commandoAssistedArmy': _commandoAssistedArmy?.index,
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.capitalBerlin: Piece.capitalHitler,
      Piece.capitalHitler: Piece.capitalBerlin,
      Piece.armyGermanSouth: Piece.armyHungarian,
      Piece.armyHungarian: Piece.armyGermanSouth,
      Piece.armyRomanian: Piece.airBaseUsstaf,
      Piece.airBaseUsstaf: Piece.armyRomanian,
      Piece.armyGermanA: Piece.armyGermanBf109,
      Piece.armyGermanBf109: Piece.armyGermanA,
      Piece.armyGermanB: Piece.armyGermanDo17,
      Piece.armyGermanDo17: Piece.armyGermanB,
      Piece.armyGermanArnim: Piece.armyVichyAlger,
      Piece.armyVichyAlger: Piece.armyGermanArnim,
      Piece.uboats3: Piece.convoyFrench,
      Piece.convoyFrench: Piece.uboats3,
      Piece.economyGerman: Piece.noAxisAttackGermany,
      Piece.noAxisAttackGermany: Piece.economyGerman,
      Piece.armyGermanG: Piece.armyGermanJu88,
      Piece.armyGermanJu88: Piece.armyGermanG,
      Piece.armyGermanC: Piece.armyGermanHe111,
      Piece.armyGermanHe111: Piece.armyGermanC,
      Piece.capitalWestwall: Piece.capitalGoring,
      Piece.capitalGoring: Piece.capitalWestwall,
      Piece.dollars: Piece.dollarsEscort,
      Piece.dollarsEscort: Piece.dollars,
      Piece.armyItalian5: Piece.armyGerman14,
      Piece.armyGerman14: Piece.armyItalian5,
      Piece.armyItalian10: Piece.armyGerman10,
      Piece.armyGerman10: Piece.armyItalian10,
      Piece.armyPolish1: Piece.armyPolish2,
      Piece.armyPolish2: Piece.armyPolish1,
      Piece.leaderChurchill: Piece.leaderChamberlain,
      Piece.leaderChamberlain: Piece.leaderChurchill,
      Piece.leaderRoosevelt: Piece.leaderWilkie,
      Piece.leaderWilkie: Piece.leaderRoosevelt,
      Piece.armyItalianCol: Piece.armyItalianBers,
      Piece.armyItalianBers: Piece.armyItalianCol,
      Piece.capitalCcnn: Piece.capitalMussolini,
      Piece.capitalMussolini: Piece.capitalCcnn,
      Piece.armyGermanAfrikaKorps: Piece.armyItalianLig,
      Piece.armyItalianLig: Piece.armyGermanAfrikaKorps,
      Piece.armyDanish: Piece.armyNorwegian,
      Piece.armyNorwegian: Piece.armyDanish,
      Piece.leaderStalin: Piece.leaderStalinUsed,
      Piece.leaderStalinUsed: Piece.leaderStalin,
      Piece.blitzWestern: Piece.abombWestern,
      Piece.blitzEastern: Piece.abombEastern,
      Piece.blitzMed: Piece.abombMed,
      Piece.blitzChina: Piece.abombChina,
      Piece.blitzSoutheastAsia: Piece.abombSoutheastAsia,
      Piece.blitzSouthPacific: Piece.abombSouthPacific,
      Piece.abombWestern: Piece.blitzWestern,
      Piece.abombEastern: Piece.blitzEastern,
      Piece.abombMed: Piece.blitzMed,
      Piece.abombChina: Piece.blitzChina,
      Piece.abombSoutheastAsia: Piece.blitzSoutheastAsia,
      Piece.abombSouthPacific: Piece.blitzSouthPacific,
      Piece.shipTanakaDestroyers: Piece.shipAkizukiDestroyers,
      Piece.shipAkizukiDestroyers: Piece.shipTanakaDestroyers,
      Piece.shipYamato: Piece.shipNagato,
      Piece.shipNagato: Piece.shipYamato,
      Piece.lendLeaseLibertyShips: Piece.burmaRoadHump,
      Piece.burmaRoadHump: Piece.lendLeaseLibertyShips,
      Piece.lendLeaseJeepsTrucks: Piece.lendLeaseAidToRussia,
      Piece.lendLeaseAidToRussia: Piece.lendLeaseJeepsTrucks,
      Piece.armyJapanese31: Piece.airBaseTinian,
      Piece.airBaseTinian: Piece.armyJapanese31,
      Piece.shipAkagi: Piece.shipHiyo,
      Piece.shipHiyo: Piece.shipAkagi,
      Piece.shipZuikaku: Piece.shipShinano,
      Piece.shipShinano: Piece.shipZuikaku,
      Piece.shipHiryu: Piece.shipChitose,
      Piece.shipChitose: Piece.shipHiryu,
      Piece.shipChokai: Piece.shipTone,
      Piece.shipTone: Piece.shipChokai,
      Piece.shipKongo: Piece.shipHaruna,
      Piece.shipHaruna: Piece.shipKongo,
      Piece.armyJapanese32: Piece.operationAL,
      Piece.operationAL: Piece.armyJapanese32,
      Piece.shipZeroRed: Piece.shipZeroWhite,
      Piece.shipZeroWhite: Piece.shipZeroRed,
      Piece.shipIboatsRed: Piece.shipIboatsWhite,
      Piece.shipIboatsWhite: Piece.shipIboatsRed,
      Piece.shipRyujo: Piece.shipUnryu,
      Piece.shipUnryu: Piece.shipRyujo,
      Piece.shipZuiho: Piece.shipIse,
      Piece.shipIse: Piece.shipZuiho,
      Piece.shipAoba: Piece.shipYahagi,
      Piece.shipYahagi: Piece.shipAoba,
      Piece.armySinkiang: Piece.sinkiangUssr,
      Piece.sinkiangUssr: Piece.armySinkiang,
      Piece.shipTaiho: Piece.shipKamikaze,
      Piece.shipKamikaze: Piece.shipTaiho,
      Piece.commandoSkorzeny: Piece.commandoTeishinShudan,
      Piece.commandoTeishinShudan: Piece.commandoSkorzeny,
      Piece.submarineCampaign: Piece.shipYamamoto,
      Piece.shipYamamoto: Piece.submarineCampaign,
      Piece.navalActions1: Piece.navalActions2,
      Piece.navalActions2: Piece.navalActions1,
      Piece.asw: Piece.aswEnigma,
      Piece.aswEnigma: Piece.asw,
      Piece.spruanceP2: Piece.spruanceP1,
      Piece.spruanceP1: Piece.spruanceP2,
      Piece.panzerPza: Piece.panzerTiger,
      Piece.panzerTiger: Piece.panzerPza,
      Piece.economyJapanese: Piece.noAxisAttackJapanese,
      Piece.noAxisAttackJapanese: Piece.economyJapanese,
      Piece.siegeNormandy: Piece.siegeTightensNormandy,
      Piece.siegeTightensNormandy: Piece.siegeNormandy,
      Piece.turnChit1: Piece.partisansSoviet,
      Piece.partisansSoviet: Piece.turnChit1,
      Piece.turnChit2: Piece.partisansCommunist0,
      Piece.partisansCommunist0: Piece.turnChit2,
      Piece.turnChit3: Piece.partisansCommunist1,
      Piece.partisansCommunist1: Piece.turnChit3,
      Piece.turnChit4: Piece.turnChitBarbarossa,
      Piece.turnChitBarbarossa: Piece.turnChit4,
      Piece.turnChit5: Piece.turnChitPearlHarbor,
      Piece.turnChitPearlHarbor: Piece.turnChit5,
      Piece.convoyAmerican0: Piece.convoyEscorted0,
      Piece.convoyAmerican1: Piece.convoyEscorted1,
      Piece.convoyBritish: Piece.convoyEscorted2,
      Piece.convoyNorwegian: Piece.convoyEscorted3,
      Piece.convoyEscorted0: Piece.convoyAmerican0,
      Piece.convoyEscorted1: Piece.convoyAmerican1,
      Piece.convoyEscorted2: Piece.convoyBritish,
      Piece.convoyEscorted3: Piece.convoyNorwegian,
      Piece.cityChicago: Piece.citySingapore,
      Piece.citySingapore: Piece.cityChicago,
      Piece.cityMoscow: Piece.cityTbilisi,
      Piece.cityTbilisi: Piece.cityMoscow,
      Piece.cityLeningrad: Piece.cityGorky,
      Piece.cityGorky: Piece.cityLeningrad,
      Piece.siegeTunis: Piece.siegeTightensTunis,
      Piece.siegeTightensTunis: Piece.siegeTunis,
      Piece.armyVichyMalg: Piece.armyJapaneseMadag,
      Piece.armyJapaneseMadag: Piece.armyVichyMalg,
      Piece.cityNewYork: Piece.cityMontreal,
      Piece.cityMontreal: Piece.cityNewYork,
      Piece.citySanFrancisco: Piece.cityAlgiers,
      Piece.cityAlgiers: Piece.citySanFrancisco,
      Piece.cityBaku: Piece.cityTashkent,
      Piece.cityTashkent: Piece.cityBaku,
      Piece.armyFrench1: Piece.armyFrench2,
      Piece.armyFrench2: Piece.armyFrench1,
      Piece.airBaseBritish: Piece.airBaseUsaaf,
      Piece.airBaseUsaaf: Piece.airBaseBritish,
      Piece.armyVichySyria: Piece.armyGermanSyria,
      Piece.armyGermanSyria: Piece.armyVichySyria,
      Piece.armyKnil: Piece.armySingapore,
      Piece.armySingapore: Piece.armyKnil,
      Piece.indiaGandhi: Piece.indiaRevolt,
      Piece.indiaRevolt: Piece.indiaGandhi,
      Piece.armyDutch: Piece.armyBelgian,
      Piece.armyBelgian: Piece.armyDutch,
      Piece.siegeStalingrad: Piece.siegeTightensStalingrad,
      Piece.siegeTightensStalingrad: Piece.siegeStalingrad,
      Piece.siegeImphal: Piece.siegeTightensImphal,
      Piece.siegeTightensImphal: Piece.siegeImphal,
      Piece.policySpainAxis: Piece.policySpainUN,
      Piece.policySpainUN: Piece.policySpainAxis,
      Piece.vichyFleetPeace: Piece.vichyFleetWar,
      Piece.vichyFleetWar: Piece.vichyFleetPeace,
      Piece.armyGreek: Piece.armyYugoslavian,
      Piece.armyYugoslavian: Piece.armyGreek,
      Piece.raiderScharnhorst: Piece.raiderGrafSpee,
      Piece.raiderGrafSpee: Piece.raiderScharnhorst,
      Piece.raiderPrinzEugen: Piece.raiderBismarck,
      Piece.raiderBismarck: Piece.raiderPrinzEugen,
      Piece.siegeGuadalcanal: Piece.siegeTightensGuadalcanal,
      Piece.siegeTightensGuadalcanal: Piece.siegeGuadalcanal,
      Piece.malta: Piece.maltaBesieged,
      Piece.maltaBesieged: Piece.malta,
      Piece.raiderKormoran: Piece.raiderRivadavia,
      Piece.raiderRivadavia: Piece.raiderKormoran,
      Piece.armyItalianEastAfrica: Piece.partisansItalian,
      Piece.partisansItalian: Piece.armyItalianEastAfrica,
      Piece.armyCongo: Piece.congoUN,
      Piece.congoUN: Piece.armyCongo,
      Piece.armyIranianShah: Piece.armyIranianVatan,
      Piece.armyIranianVatan: Piece.armyIranianShah,
      Piece.southAfricaUN: Piece.southAfricaNeutral,
      Piece.southAfricaNeutral: Piece.southAfricaUN,
      Piece.armyFinnish: Piece.finlandUN,
      Piece.finlandUN: Piece.armyFinnish,
      Piece.greekSurrender: Piece.armyTito,
      Piece.armyTito: Piece.greekSurrender,
      Piece.abombResearch: Piece.abombAvailable,
      Piece.abombAvailable: Piece.abombResearch,
      Piece.policyItaly: Piece.occupiedDutchEastIndies,
      Piece.occupiedDutchEastIndies: Piece.policyItaly,
      Piece.armyIraqi: Piece.armyGermanIraq,
      Piece.armyGermanIraq: Piece.armyIraqi,
      Piece.burmaRoadOpen: Piece.burmaRoadClosed,
      Piece.burmaRoadClosed: Piece.burmaRoadOpen,
      Piece.cannonMeat: Piece.armyWarsaw,
      Piece.armyWarsaw: Piece.cannonMeat,
      Piece.strategyWestern: Piece.occupiedWestern,
      Piece.strategyEastern: Piece.occupiedEastern,
      Piece.strategyMed: Piece.occupiedMed,
      Piece.strategyChina: Piece.occupiedChina,
      Piece.strategySoutheastAsia: Piece.occupiedSoutheastAsia,
      Piece.strategySouthPacific: Piece.occupiedSouthPacific,
      Piece.occupiedWestern: Piece.strategyWestern,
      Piece.occupiedEastern: Piece.strategyEastern,
      Piece.occupiedMed: Piece.strategyMed,
      Piece.occupiedChina: Piece.strategyChina,
      Piece.occupiedSoutheastAsia: Piece.strategySoutheastAsia,
      Piece.occupiedSouthPacific: Piece.strategySouthPacific,
      Piece.policyJapanSoutheastAsia: Piece.capitalThailand,
      Piece.capitalThailand:  Piece.policyJapanSoutheastAsia,
      Piece.policyJapanSouthPacific: Piece.armyBataan,
      Piece.armyBataan: Piece.policyJapanSouthPacific,
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

  bool politicalEventCurrent(PoliticalEvent event) {
    return _politicalEventCurrents[event.index];
  }

  int politicalEventCount(PoliticalEvent event) {
    return _politicalEventCounts[event.index];
  }

  void setPoliticalEventOccurred(PoliticalEvent event) {
    _politicalEventCurrents[event.index] = true;
    _politicalEventCounts[event.index] += 1;
  }

  void clearCurrentPoliticalEvents() {
    _politicalEventCurrents.fillRange(0, _politicalEventCounts.length, false);
  }

  // Fronts

  Location frontReservesBox(Location front) {
    return Location.values[LocationType.reserves.firstIndex + front.index - LocationType.front.firstIndex];
  }

  Location frontPartisansBox(Location front) {
    return Location.values[LocationType.partisans.firstIndex + front.index - LocationType.front.firstIndex];
  }

  Piece frontStrategy(Location front) {
    return Piece.values[PieceType.strategy.firstIndex + front.index - LocationType.front.firstIndex];
  }

  bool frontNeutral(Location front) {
    switch (front) {
    case Location.frontWestern:
      return false;
    case Location.frontEastern:
      return pieceLocation(Piece.policyRussia) == Location.boxSovietPolicyNeutral;
    case Location.frontMed:
      return pieceLocation(Piece.policyItaly) == front;
    case Location.frontChina:
      return false;
    case Location.frontSoutheastAsia:
      return pieceLocation(Piece.policyJapanSoutheastAsia) == front;
    case Location.frontSouthPacific:
      return pieceLocation(Piece.policyJapanSouthPacific) == front;
    default:
      return false;
    }
  }

  bool frontDefeated(Location front) {
    return piecesInLocationCount(PieceType.occupied, front) > 0;
  }

  bool frontActive(Location front) {
    return !frontNeutral(front) && !frontDefeated(front);
  }

  bool frontHasStrategy(Location front) {
    return pieceLocation(frontStrategy(front)) == front;
  }

  Piece? frontPropArmy(Location front) {
    switch (front) {
    case Location.frontWestern:
      const candidates = [
        Piece.armyPolish1,
        Piece.armyPolish2,
        Piece.armyDanish,
        Piece.armyNorwegian,
        Piece.armyDutch,
        Piece.armyBelgian,
        Piece.armyFrench1,
        Piece.armyFrench2,
      ];
      for (final army in candidates) {
        if (pieceLocation(army) == front) {
          return army;
        }
      }
      return null;
    case Location.frontEastern:
      const candidates = [
        Piece.armyYugoslavian,
        Piece.armyGreek,
        Piece.armyWarsaw,
        Piece.armyTito,
      ];
      for (final army in candidates) {
        final location = pieceLocation(army);
        if (location == front || location == Location.regionBalkans) {
          return army;
        }
      }
      return null;
    case Location.frontMed:
      return null;
    case Location.frontChina:
      return null;
    case Location.frontSoutheastAsia:
      const candidates = [
        Piece.armySingapore,
        Piece.armyKnil,
      ];
      for (final army in candidates) {
        final location = pieceLocation(army);
        if (location == front || location == Location.regionDutchEastIndies) {
          return army;
        }
      }
      return null;
    case Location.frontSouthPacific:
      if (pieceLocation(Piece.armyBataan) == front) {
        return Piece.armyBataan;
      }
      return null;
    default:
      return null;
    }
  }

  Piece? frontBomber(Location front) {
    switch (front) {
    case Location.frontWestern:
    case Location.frontEastern:
    case Location.frontMed:
      return europeBomber;
    case Location.frontChina:
    case Location.frontSoutheastAsia:
    case Location.frontSouthPacific:
      return pacificBomber;
    default:
      return null;
    }
  }

  // Sea Zones

  bool seaZoneAsw(Location seaZone) {
    if ([
      Location.seaZone1A,
      Location.seaZone2A,
      Location.seaZone3,
      Location.seaZone4
    ].contains(seaZone)) {
      return true;
    }
    if (pieceLocation(Piece.escortSaoPaulo) == seaZone) {
      return true;
    }
    return false;
  }

  int seaZoneValue(Location seaZone) {
    switch (seaZone) {
    case Location.seaZone1A:
    case Location.seaZone1B:
      return 1;
    case Location.seaZone2A:
    case Location.seaZone2B:
    case Location.seaZone2C:
      return 2;
    case Location.seaZone3:
      return 3;
    case Location.seaZone4:
      return 4;
    default:
      return 0;
    }
  }

  // Armies

  int armyStrength(Piece army) {
    const armyStrengths = {
      Piece.capitalBerlin: 4,
      Piece.capitalCcnn: 0,
      Piece.capitalGoring: 0,
      Piece.capitalHitler: 4,
      Piece.capitalManchukuo: 4,
      Piece.capitalMussolini: 5,
      Piece.capitalThailand: 5,
      Piece.capitalTokyo: 5,
      Piece.capitalWestwall: 4,
      Piece.armyChineseCommunist: 2,
      Piece.armyCongo: 4,
      Piece.armyFinnish: 4,
      Piece.armyGerman10: 4,
      Piece.armyGerman14: 3,
      Piece.armyGermanA: 4,
      Piece.armyGermanAfrikaKorps: 4,
      Piece.armyGermanArnim: 5,
      Piece.armyGermanB: 3,
      Piece.armyGermanBf109: 5,
      Piece.armyGermanC: 3,
      Piece.armyGermanCenter: 4,
      Piece.armyGermanDo17: 2,
      Piece.armyGermanG: 3,
      Piece.armyGermanHe111: 3,
      Piece.armyGermanIraq: 4,
      Piece.armyGermanJu88: 4,
      Piece.armyGermanNorth: 3,
      Piece.armyGermanSouth: 4,
      Piece.armyGermanSyria: 3,
      Piece.armyHungarian: 2,
      Piece.armyIranianShah: 1,
      Piece.armyIranianVatan: 3,
      Piece.armyIraqi: 2,
      Piece.armyItalian5: 3,
      Piece.armyItalian10: 3,
      Piece.armyItalianBers: 2,
      Piece.armyItalianCol: 2,
      Piece.armyItalianLig: 2,
      Piece.armyItalianEastAfrica: 5,
      Piece.armyJapanese14: 6,
      Piece.armyJapanese15: 3,
      Piece.armyJapanese18: 5,
      Piece.armyJapanese28: 3,
      Piece.armyJapanese31: 4,
      Piece.armyJapanese32: 4,
      Piece.armyJapaneseBurmese: 2,
      Piece.armyJapaneseCcaa: 3,
      Piece.armyJapaneseIndian: 2,
      Piece.armyJapaneseMadag: 3,
      Piece.armyJapaneseNcaa: 3,
      Piece.armyJapaneseWang: 2,
      Piece.armyRomanian: 2,
      Piece.armySinkiang: 2,
      Piece.armyTurkish: 5,
      Piece.armyVichyAlger: 3,
      Piece.armyVichyMalg: 2,
      Piece.armyVichySyria: 2,
      Piece.panzerPza: 4,
      Piece.panzerTiger: 5,
      Piece.siegeNormandy: 3,
      Piece.siegeStalingrad: 3,
      Piece.siegeTunis: 3,
      Piece.siegeImphal: 3,
      Piece.siegeGuadalcanal: 3,
    };
    return armyStrengths[army]!;
  }

  List<Piece> strongestArmies(List<Piece> armies) {
    var strongest = <Piece>[];
    int strongestStrength = 0;
    for (final army in armies) {
      int strength = armyStrength(army);
      if (strongest.isEmpty || strength > strongestStrength) {
        strongest = [army];
        strongestStrength = strength;
      } else if (strength == strongestStrength) {
        strongest.add(army);
      }
    }
    return strongest;
  }

  List<Piece> weakestArmies(List<Piece> armies) {
    var weakest = <Piece>[];
    int weakestStrength = 7;
    for (final army in armies) {
      int strength = armyStrength(army);
      if (weakest.isEmpty || strength < weakestStrength) {
        weakest = [army];
        weakestStrength = strength;
      } else if (strength == weakestStrength) {
        weakest.add(army);
      }
    }
    return weakest;
  }

  // Prop Armies

  static const propArmyData = {
    Piece.armyBataan: (3, 1),
    Piece.armyBelgian: (3, 1),
    Piece.armyDanish: (1, 1),
    Piece.armyDutch: (2, 1),
    Piece.armyFrench1: (4, 1),
    Piece.armyFrench2: (5, 2),
    Piece.armyGreek: (3, 1),
    Piece.armyKnil: (3, 1),
    Piece.armyNorwegian: (3, 1),
    Piece.armyPolish1: (3, 1),
    Piece.armyPolish2: (2, 1),
    Piece.armySingapore: (5, 2),
    Piece.armyTito: (4, 1),
    Piece.armyWarsaw: (3, 1),
    Piece.armyYugoslavian: (3, 1),
  };

  int propArmyStrength(Piece propArmy) {
    return propArmyData[propArmy]!.$1;
  }

  int propArmyCost(Piece propArmy) {
    return propArmyData[propArmy]!.$2;
  }

  // Carriers

  int carrierStrength(Piece carrier) {
    const carrierStrengths = {
      Piece.carrierBunkerHill: 4,
      Piece.carrierEnterprise: 2,
      Piece.carrierEssex: 4,
      Piece.carrierFdr: 5,
      Piece.carrierHornet: 2,
      Piece.carrierIntrepid: 4,
      Piece.carrierLangley: 0,
      Piece.carrierLexington: 3,
      Piece.carrierMidawy: 5,
      Piece.carrierPrinceton: 5,
      Piece.carrierRanger: 1,
      Piece.carrierSaratoga: 3,
      Piece.carrierTiconderoga: 4,
      Piece.carrierWasp: 1,
      Piece.carrierYorktown: 2,
    };
    return carrierStrengths[carrier]!;
  }

  // Ships

  int shipStrength(Piece ship) {
    const shipStrengths = {
      Piece.shipTanakaDestroyers: 5,
      Piece.shipYamato: 5,
      Piece.shipAkagi: 6,
      Piece.shipZuikaku: 5,
      Piece.shipHiryu: 5,
      Piece.shipChokai: 4,
      Piece.shipKongo: 4,
      Piece.shipZeroRed: 4,
      Piece.shipIboatsRed: 3,
      Piece.shipRyujo: 3,
      Piece.shipZuiho: 3,
      Piece.shipAoba: 2,
      Piece.shipTaiho: 2,
      Piece.shipAkizukiDestroyers: 3,
      Piece.shipNagato: 4,
      Piece.shipHiyo: 2,
      Piece.shipShinano: 2,
      Piece.shipChitose: 1,
      Piece.shipTone: 3,
      Piece.shipHaruna: 2,
      Piece.shipZeroWhite: 1,
      Piece.shipIboatsWhite: 3,
      Piece.shipUnryu: 2,
      Piece.shipIse: 1,
      Piece.shipYahagi: 2,
      Piece.shipKamikaze: 5,
      Piece.shipYamamoto: 6,
    };
    return shipStrengths[ship]!;
  }

  List<Piece> strongestShips(List<Piece> ships) {
    var strongest = <Piece>[];
    int strongestCombinedStrength = 0;
    for (final ship in ships) {
      int strength = shipStrength(ship);
      int flipStrength = 0;
      if (ship.isType(PieceType.shipFront)) {
        final flippedShip = pieceFlipSide(ship)!;
        flipStrength = shipStrength(flippedShip);
      }
      int combinedStrength = 10 * strength + flipStrength;
      if (strongest.isEmpty || combinedStrength > strongestCombinedStrength) {
        strongest = [ship];
        strongestCombinedStrength = combinedStrength;
      } else if (combinedStrength == strongestCombinedStrength) {
        strongest.add(ship);
      }
    }
    return strongest;
  }

  List<Piece> weakestShips(List<Piece> ships) {
    var weakest = <Piece>[];
    int weakestCombinedStrength = 0;
    for (final ship in ships) {
      int strength = shipStrength(ship);
      int redVsWhite = 0;
      if (!ship.isType(PieceType.shipFront)) {
        redVsWhite = 10;
      }
      int combinedStrength = redVsWhite + strength;
      if (weakest.isEmpty || combinedStrength < weakestCombinedStrength) {
        weakest = [ship];
        weakestCombinedStrength = combinedStrength;
      } else if (combinedStrength == weakestCombinedStrength) {
        weakest.add(ship);
      }
    }
    return weakest;
  }

  // Commandos

  void setCommandoAssistedArmy(Piece army) {
    _commandoAssistedArmy = army;
  }

  void clearCommandoAssistedArmy() {
    _commandoAssistedArmy = null;
  }

  // Raiders

  int raiderStrength(Piece raider) {
    const raiderStrengths = {
      Piece.raiderGrafSpee: 3,
      Piece.raiderKormoran: 1,
      Piece.raiderBismarck: 5,
      Piece.raiderPrinzEugen: 2,
      Piece.raiderScharnhorst: 4,
      Piece.raiderRivadavia: 1,
    };
    final strength = raiderStrengths[raider];
    if (strength != null) {
      return strength;
    }
    return 0;
  }

  Piece? strongestRaider(List<Piece> raiders) {
    Piece? strongest;
    int strength = -1;
    for (final raider in raiders) {
      if (raiderStrength(raider) > strength) {
        strongest = raider;
        strength = raiderStrength(raider);
      }
    }
    return strongest;
  }

  // Misc Locations

  bool get southAfricaNeutral {
    return pieceLocation(Piece.southAfricaNeutral) == Location.regionSouthAfrica;
  }

  bool get burmaRoadClosed {
    return pieceLocation(Piece.burmaRoadClosed) == Location.regionBurmaRoad;
  }

  // Leaders

  Location leadershipBox(Piece leader) {
    const leadershipBoxes = {
      Piece.leaderChamberlain: Location.boxAlliedLeadershipBritish,
      Piece.leaderChurchill: Location.boxAlliedLeadershipBritish,
      Piece.leaderRoosevelt: Location.boxAlliedLeadershipAmerican,
      Piece.leaderWilkie: Location.boxAlliedLeadershipAmerican,
      Piece.leaderStalin: Location.boxAlliedLeadershipRussian,
      Piece.leaderStalinUsed: Location.boxAlliedLeadershipRussian,
    };
    return leadershipBoxes[leader]!;
  }

  bool get churchillAvailable {
    return pieceLocation(Piece.leaderChurchill) == Location.boxAlliedLeadershipBritish;
  }

  void churchillInUse(int turnCount) {
    final location = pieceLocation(Piece.leaderChurchill);
    int delay = 0;
    if (location.isType(LocationType.calendar)) {
      delay = location.index - futureCalendarBox(0).index;
    }
    setPieceLocation(Piece.leaderChurchill, futureCalendarBox(delay + turnCount));
  }

  bool get stalinAvailable {
    return pieceLocation(Piece.leaderStalin) == Location.boxAlliedLeadershipRussian;
  }

  void stalinUsed() {
    setPieceLocation(Piece.leaderStalinUsed, pieceLocation(Piece.leaderStalin));
  }

  Piece get usPresident {
    if (pieceLocation(Piece.leaderWilkie) != Location.flipped) {
      return Piece.leaderWilkie;
    }
    return Piece.leaderRoosevelt;
  }

  Piece get spruance {
    if (pieceLocation(Piece.spruanceP2) != Location.flipped) {
      return Piece.spruanceP2;
    }
    return Piece.spruanceP1;
  }

  // Allied Bombers

  Piece? get europeBomber {
    if (pieceLocation(Piece.airBaseUsstaf) == Location.boxAlliedAirBases) {
      return Piece.airBaseUsstaf;
    }
    if (pieceLocation(Piece.airBaseUsaaf) == Location.boxAlliedAirBases) {
      return Piece.airBaseUsaaf;
    }
    if (pieceLocation(Piece.airBaseBritish) == Location.boxAlliedAirBases) {
      return Piece.airBaseBritish;
    }
    return null;
  }

  Piece? get pacificBomber {
    if (pieceLocation(Piece.airBaseUsstaf) == Location.boxAlliedAirBases && pieceLocation(Piece.airBaseUsaaf) == Location.boxAlliedAirBases) {
      return Piece.airBaseUsaaf;
    }
    return null;
  }

  int bomberMinDie(Piece bomber) {
    const bomberMinDies = {
      Piece.airBaseBritish: 6,
      Piece.airBaseUsaaf: 5,
      Piece.airBaseUsstaf: 4,
    };
    return bomberMinDies[bomber]!;
  }

  // Dollars

  int get dollars {
    for (final piece in PieceType.dollars.pieces) {
      final location = pieceLocation(piece);
      if (location.isType(LocationType.omnibus)) {
        return location.index - LocationType.omnibus.firstIndex;
      }
    }
    return 0;
  }

  void adjustDollars(int delta) {
    for (final piece in PieceType.dollars.pieces) {
      final location = pieceLocation(piece);
      if (location.isType(LocationType.omnibus)) {
        int total = location.index - LocationType.omnibus.firstIndex;
        total += delta;
        if (total > 12) {
          total = 12;
        } else if (delta < 0) {
          total = 0;
        }
        setPieceLocation(piece, Location.values[LocationType.omnibus.firstIndex + total]);
      }
    }
  }

  // Cannon Meat

  int get cannonMeat {
    final location = pieceLocation(Piece.cannonMeat);
    if (location.isType(LocationType.omnibus)) {
      return location.index - LocationType.omnibus.firstIndex;
    }
    return 0;
  }

  void adjustCannonMeat(int delta) {
    final location = pieceLocation(Piece.cannonMeat);
    if (location.isType(LocationType.omnibus)) {
      int total = location.index - LocationType.omnibus.firstIndex;
      total += delta;
      if (total > 12) {
        total = 12;
      } else if (delta < 0) {
        total = 0;
      }
      setPieceLocation(Piece.cannonMeat, Location.values[LocationType.omnibus.firstIndex + total]);
    }
  }

  // Aid to China

  int get aidToChina {
    final location = pieceLocation(Piece.aidChina);
    if (location.isType(LocationType.omnibus)) {
      return location.index - LocationType.omnibus.firstIndex;
    }
    return 0;
  }

  void adjustAidToChina(int delta) {
    final location = pieceLocation(Piece.aidChina);
    if (location.isType(LocationType.omnibus)) {
      int total = location.index - LocationType.omnibus.firstIndex;
      total += delta;
      if (total > 12) {
        total = 12;
      } else if (delta < 0) {
        total = 0;
      }
      setPieceLocation(Piece.aidChina, Location.values[LocationType.omnibus.firstIndex + total]);
    }
  }

  // Naval Actions

  int get navalActions {
    for (final piece in PieceType.navalActions.pieces) {
      final location = pieceLocation(piece);
      if (location.isType(LocationType.omnibus)) {
        return location.index - LocationType.omnibus.firstIndex;
      }
    }
    return 0;
  }

  void adjustNavalActions(int delta) {
    for (final piece in PieceType.navalActions.pieces) {
      final location = pieceLocation(piece);
      if (location.isType(LocationType.omnibus)) {
        int total = location.index - LocationType.omnibus.firstIndex;
        total += delta;
        if (total > 12) {
          total = 12;
        } else if (delta < 0) {
          total = 0;
        }
        setPieceLocation(piece, Location.values[LocationType.omnibus.firstIndex + total]);
      }
    }
  }

  // Manhattan Project

  int get manhattanProject {
    final location = pieceLocation(Piece.abombResearch);
    if (!location.isType(LocationType.omnibus)) {
      return -1;
    }
    return location.index - LocationType.omnibus.firstIndex;
  }

  void adjustManhattanProject(int delta) {
    final location = pieceLocation(Piece.abombResearch);
    int progress = location.index - LocationType.omnibus.firstIndex;
    progress += delta;
    if (progress > 13) {
      progress = 13;
    } else if (progress < 0) {
      progress = 0;
    }
    setPieceLocation(Piece.abombResearch, Location.values[LocationType.omnibus.firstIndex + progress]);
  }

  bool get abombAvailable {
    if (currentTurn < 25) {
      return false;
    }
    final location = pieceLocation(Piece.abombAvailable);
    if (location.isType(LocationType.omnibus) && location != Location.omnibus0) {
      return true;
    }
    return false;
  }

  // Turns

  int get currentTurn {
    int maxTurn = 0;
    for (final turnChit in PieceType.turnChit.pieces) {
      final location = pieceLocation(turnChit);
      if (location.isType(LocationType.calendar)) {
        final turn = location.index - LocationType.calendar.firstIndex + 1;
        if (turn > maxTurn) {
          maxTurn = turn;
        }
      }
    }
    return maxTurn;
  }

  bool get currentTurnRussianWinter {
    return [6, 12, 18].contains(currentTurn);
  }

  int? get currentTurnUboatDelay {
    const uboatDelays = [
      2, 2, 2, 2, 2, 2,
      2, 2, 2, 2, 2, 2,
      2, 5, 5, 3, 2, 3,
      4, 4, 4, 2, 2, null,
      null, null, null,
    ];
    return uboatDelays[currentTurn - 1];
  }

  Location calendarBox(int turn) {
    return Location.values[LocationType.calendar.firstIndex + turn - 1];
  }

  Location futureCalendarBox(int turnCount) {
    int futureTurn = currentTurn + turnCount;
    if (futureTurn > 27) {
      return Location.discarded;
    }
    return calendarBox(futureTurn);
  }

  int turnYear(int turn) {
    const turnYears = [
      1939, 1940, 1940, 1941, 1941, 1942,
      1942, 1942, 1942, 1942, 1942, 1943,
      1943, 1943, 1943, 1943, 1943, 1944,
      1944, 1944, 1944, 1944, 1944, 1945,
      1945, 1945, 1945,
    ];
    return turnYears[turn - 1];
  }

  Piece get currentTurnChit {
    int maxTurn = 0;
    Piece? chit;
    for (final turnChit in PieceType.turnChit.pieces) {
      final location = pieceLocation(turnChit);
      if (location.isType(LocationType.calendar)) {
        final turn = location.index - LocationType.calendar.firstIndex + 1;
        if (turn > maxTurn) {
          maxTurn = turn;
          chit = turnChit;
        }
      }
    }
    return chit!;
  }

  int turnChitFrontAttackCount(Piece turnChit, Location front) {
    return turnChitData[turnChit]!.$1[front.index - LocationType.front.firstIndex];
  }

  int turnChitRandomAttackCount(Piece turnChit) {
    return turnChitData[turnChit]!.$2;
  }

  TurnChitDisk turnChitDiskColor(Piece turnChit) {
    return turnChitData[turnChit]!.$3;
  }

  String turnName(int turn) {
    const turnNames = [
      'Fall 1939',
      'Early 1940',
      'Late 1940',
      'Early 1941',
      'Late 1941',
      'January/February 1942',
      'March/April 1942',
      'May/June 1942',
      'July/August 1942',
      'September/October 1942',
      'November/December 1942',
      'January/February 1943',
      'March/April 1943',
      'May/June 1943',
      'July/August 1943',
      'September/October 1943',
      'November/December 1943',
      'January/February 1944',
      'March/April 1944',
      'May/June 1944',
      'July/August 1944',
      'September/October 1944',
      'November/December 1944',
      'Winter 1945',
      'Spring 1945',
      'Summer 1945',
      'Fall 1945',
    ];
    return turnNames[turn - 1];
  }

  bool get franceHasFallen {
    return piecesInLocationCount(PieceType.frenchArmy, Location.frontWestern) == 0;
  }

  bool get airSuperiority {
    return pieceLocation(Piece.capitalWestwall) == Location.frontWestern || frontDefeated(Location.frontWestern);
  }

  bool get germanEconomyCollapsed {
    return pieceLocation(Piece.noAxisAttackGermany) == Location.boxGermany;
  }

  bool get japaneseEcomomyCollapsed {
    return pieceLocation(Piece.noAxisAttackJapanese) == Location.boxJapan;
  }

  void setupPieces(List<(Piece, Location)> pieces) {
    for (final record in pieces) {
      final piece = record.$1;
      final location = record.$2;
      setPieceLocation(piece, location);
    }
  }

  factory GameState.setupCounterTray() {
    var state = GameState();

    for (final piece in PieceType.carrier.pieces) {
      state.setPieceLocation(piece, Location.trayUnNaval);
    }

    state.setupPieces([
        (Piece.navalActions1, Location.trayUnNaval),
        (Piece.asw, Location.trayUnNaval),
        (Piece.spruanceP2, Location.trayUnNaval),
        (Piece.cityBaku, Location.trayUnCities),
        (Piece.cityChicago, Location.trayUnCities),
        (Piece.cityChungking, Location.trayUnCities),
        (Piece.cityDelhi, Location.trayUnCities),
        (Piece.cityGlasgow, Location.trayUnCities),
        (Piece.cityLeningrad, Location.trayUnCities),
        (Piece.cityLondon, Location.trayUnCities),
        (Piece.cityMoscow, Location.trayUnCities),
        (Piece.cityNewYork, Location.trayUnCities),
        (Piece.citySanFrancisco, Location.trayUnCities),
        (Piece.citySydney, Location.trayUnCities),
        (Piece.armyFrench1, Location.trayFrench),
        (Piece.vichyFleetPeace, Location.trayFrench),
        (Piece.armyVichyAlger, Location.trayFrench),
        (Piece.armyVichyMalg, Location.trayFrench),
        (Piece.armyVichySyria, Location.trayFrench),
        (Piece.blitzWestern, Location.trayBlitz),
        (Piece.blitzEastern, Location.trayBlitz),
        (Piece.blitzMed, Location.trayBlitz),
        (Piece.blitzChina, Location.trayBlitz),
        (Piece.blitzSoutheastAsia, Location.trayBlitz),
        (Piece.blitzSouthPacific, Location.trayBlitz),
        (Piece.siegeNormandy, Location.traySiege),
        (Piece.siegeStalingrad, Location.traySiege),
        (Piece.siegeTunis, Location.traySiege),
        (Piece.siegeImphal, Location.traySiege),
        (Piece.siegeGuadalcanal, Location.traySiege),
        (Piece.uboats0, Location.trayGermanNavy),
        (Piece.uboats1, Location.trayGermanNavy),
        (Piece.uboats2, Location.trayGermanNavy),
        (Piece.uboats3, Location.trayGermanNavy),
        (Piece.raiderGrafSpee, Location.trayGermanNavy),
        (Piece.raiderKormoran, Location.trayGermanNavy),
        (Piece.raiderBismarck, Location.trayGermanNavy),
        (Piece.partisans0, Location.trayPartisans),
        (Piece.partisans1, Location.trayPartisans),
        (Piece.malta, Location.trayPartisans),
        (Piece.armyItalian5, Location.trayItalian),
        (Piece.armyItalian10, Location.trayItalian),
        (Piece.armyItalianCol, Location.trayItalian),
        (Piece.capitalCcnn, Location.trayItalian),
        (Piece.armyItalianEastAfrica, Location.trayItalian),
        (Piece.policyItaly, Location.trayItalian),
        (Piece.leaderChurchill, Location.trayPolitical),
        (Piece.leaderRoosevelt, Location.trayPolitical),
        (Piece.leaderStalin, Location.trayPolitical),
        (Piece.indiaGandhi, Location.trayPolitical),
        (Piece.policyRussia, Location.trayPolitical),
        (Piece.ricksPlace, Location.trayPolitical),
        (Piece.armyYugoslavian, Location.trayProUnMinors),
        (Piece.armyPolish1, Location.trayProUnMinors),
        (Piece.armyDanish, Location.trayProUnMinors),
        (Piece.armyDutch, Location.trayProUnMinors),
        (Piece.congoUN, Location.trayProUnMinors),
        (Piece.armySingapore, Location.trayProUnMinors),
        (Piece.greekSurrender, Location.trayProUnMinors),
        (Piece.sinkiangUssr, Location.trayProUnMinors),
        (Piece.southAfricaUN, Location.trayProUnMinors),
        (Piece.escortSaoPaulo, Location.trayProUnMinors),
        (Piece.armyJapanese14, Location.trayJapaneseGround),
        (Piece.armyJapanese15, Location.trayJapaneseGround),
        (Piece.armyJapanese18, Location.trayJapaneseGround),
        (Piece.armyJapanese28, Location.trayJapaneseGround),
        (Piece.armyJapanese31, Location.trayJapaneseGround),
        (Piece.armyJapanese32, Location.trayJapaneseGround),
        (Piece.armyJapaneseBurmese, Location.trayJapaneseGround),
        (Piece.armyJapaneseCcaa, Location.trayJapaneseGround),
        (Piece.armyJapaneseIndian, Location.trayJapaneseGround),
        (Piece.armyJapaneseNcaa, Location.trayJapaneseGround),
        (Piece.armyJapaneseWang, Location.trayJapaneseGround),
        (Piece.capitalManchukuo, Location.trayJapaneseGround),
        (Piece.capitalTokyo, Location.trayJapaneseGround),
        (Piece.armyChineseCommunist, Location.trayJapaneseGround),
        (Piece.policyJapanSoutheastAsia, Location.trayJapaneseGround),
        (Piece.policyJapanSouthPacific, Location.trayJapaneseGround),
        (Piece.armyGermanAfrikaKorps, Location.trayGermanGround),
        (Piece.armyGermanA, Location.trayGermanGround),
        (Piece.armyGermanB, Location.trayGermanGround),
        (Piece.armyGermanC, Location.trayGermanGround),
        (Piece.armyGermanG, Location.trayGermanGround),
        (Piece.armyGermanNorth, Location.trayGermanGround),
        (Piece.armyGermanCenter, Location.trayGermanGround),
        (Piece.armyGermanSouth, Location.trayGermanGround),
        (Piece.capitalBerlin, Location.trayGermanGround),
        (Piece.capitalWestwall, Location.trayGermanGround),
        (Piece.panzerPza, Location.trayGermanGround),
        (Piece.commandoSkorzeny, Location.trayGermanGround),
        (Piece.shipTanakaDestroyers, Location.trayJapaneseNavy),
        (Piece.shipYamato, Location.trayJapaneseNavy),
        (Piece.shipAkagi, Location.trayJapaneseNavy),
        (Piece.shipZuikaku, Location.trayJapaneseNavy),
        (Piece.shipHiryu, Location.trayJapaneseNavy),
        (Piece.shipChokai, Location.trayJapaneseNavy),
        (Piece.shipKongo, Location.trayJapaneseNavy),
        (Piece.shipZeroRed, Location.trayJapaneseNavy),
        (Piece.shipIboatsRed, Location.trayJapaneseNavy),
        (Piece.shipRyujo, Location.trayJapaneseNavy),
        (Piece.shipZuiho, Location.trayJapaneseNavy),
        (Piece.shipAoba, Location.trayJapaneseNavy),
        (Piece.shipTaiho, Location.trayJapaneseNavy),
        (Piece.shipYamamoto, Location.trayJapaneseNavy),
        (Piece.convoyAmerican0, Location.trayEconomic),
        (Piece.convoyAmerican1, Location.trayEconomic),
        (Piece.convoyBritish, Location.trayEconomic),
        (Piece.convoyNorwegian, Location.trayEconomic),
        (Piece.lendLeaseDestroyerDeal, Location.trayEconomic),
        (Piece.lendLeaseJeepsTrucks, Location.trayEconomic),
        (Piece.lendLeaseLibertyShips, Location.trayEconomic),
        (Piece.dollars, Location.trayEconomic),
        (Piece.aidChina, Location.trayEconomic),
        (Piece.cannonMeat, Location.trayEconomic),
        (Piece.economyGerman, Location.trayEconomic),
        (Piece.economyJapanese, Location.trayEconomic),
        (Piece.strategyWestern, Location.trayStrategy),
        (Piece.strategyEastern, Location.trayStrategy),
        (Piece.strategyMed, Location.trayStrategy),
        (Piece.strategyChina, Location.trayStrategy),
        (Piece.strategySoutheastAsia, Location.trayStrategy),
        (Piece.strategySouthPacific, Location.trayStrategy),
        (Piece.militaryEvent, Location.trayMarkers),
        (Piece.usMarines, Location.trayMarkers),
        (Piece.airBaseBritish, Location.trayMarkers),
        (Piece.burmaRoadOpen, Location.trayMarkers),
        (Piece.abombResearch, Location.trayMarkers),
        (Piece.armyRomanian, Location.trayProAxisMinors),
        (Piece.armyFinnish, Location.trayProAxisMinors),
        (Piece.armyIranianShah, Location.trayProAxisMinors),
        (Piece.armyIraqi, Location.trayProAxisMinors),
        (Piece.armyTurkish, Location.trayProAxisMinors),
        (Piece.policySpainAxis, Location.trayProAxisMinors),
        (Piece.turnChit1, Location.trayTurn),
        (Piece.turnChit2, Location.trayTurn),
        (Piece.turnChit3, Location.trayTurn),
        (Piece.turnChitBarbarossa, Location.trayTurn),
        (Piece.turnChitPearlHarbor, Location.trayTurn),
        (Piece.turnChit6, Location.trayTurn),
        (Piece.turnChit7, Location.trayTurn),
        (Piece.turnChit8, Location.trayTurn),
        (Piece.turnChit9, Location.trayTurn),
        (Piece.turnChit10, Location.trayTurn),
        (Piece.turnChit11, Location.trayTurn),
        (Piece.turnChit12, Location.trayTurn),
        (Piece.turnChit13, Location.trayTurn),
        (Piece.turnChit14, Location.trayTurn),
        (Piece.turnChit15, Location.trayTurn),
        (Piece.turnChit16, Location.trayTurn),
        (Piece.turnChit17, Location.trayTurn),
        (Piece.turnChit18, Location.trayTurn),
        (Piece.turnChit19, Location.trayTurn),
        (Piece.turnChit20, Location.trayTurn),
        (Piece.turnChit21, Location.trayTurn),
        (Piece.turnChit22, Location.trayTurn),
        (Piece.turnChit23, Location.trayTurn),
        (Piece.turnChit24, Location.trayTurn),
        (Piece.turnChit25, Location.trayTurn),
        (Piece.turnChit26, Location.trayTurn),
        (Piece.turnChit27, Location.trayTurn),
        (Piece.turnChit28, Location.trayTurn),
    ]);     

    return state;
  }

  factory GameState.setupCampaign() {

    var state = GameState.setupCounterTray();

    for (final piece in PieceType.carrier.pieces) {
      state.setPieceLocation(piece, Location.cupCarrier);
    }

    state.setupPieces([
        (Piece.turnChit1, Location.cupTurn),
        (Piece.turnChit2, Location.cupTurn),
        (Piece.turnChit3, Location.cupTurn),
        (Piece.armyGermanBf109, Location.reservesWestern),
        (Piece.armyGermanJu88, Location.reservesWestern),
        (Piece.armyGermanHe111, Location.reservesWestern),
        (Piece.armyGermanDo17, Location.reservesWestern),
        (Piece.capitalBerlin, Location.reservesWestern),
        (Piece.blitzWestern, Location.reservesWestern),
        (Piece.armyGermanNorth, Location.reservesEastern),
        (Piece.armyGermanCenter, Location.reservesEastern),
        (Piece.armyGermanSouth, Location.reservesEastern),
        (Piece.armyRomanian, Location.reservesEastern),
        (Piece.blitzEastern, Location.reservesEastern),
        (Piece.armyGermanAfrikaKorps, Location.reservesMed),
        (Piece.armyItalian5, Location.reservesMed),
        (Piece.blitzMed, Location.reservesMed),
        (Piece.armyJapaneseWang, Location.reservesChina),
        (Piece.armyChineseCommunist, Location.reservesChina),
        (Piece.blitzChina, Location.reservesChina),
        (Piece.armyJapanese15, Location.reservesSoutheastAsia),
        (Piece.armyJapanese28, Location.reservesSoutheastAsia),
        (Piece.armyJapaneseBurmese, Location.reservesSoutheastAsia),
        (Piece.armyJapaneseIndian, Location.reservesSoutheastAsia),
        (Piece.blitzSoutheastAsia, Location.reservesSoutheastAsia),
        (Piece.armyJapanese14, Location.reservesSouthPacific),
        (Piece.armyJapanese18, Location.reservesSouthPacific),
        (Piece.armyJapanese31, Location.reservesSouthPacific),
        (Piece.armyJapanese32, Location.reservesSouthPacific),
        (Piece.blitzSouthPacific, Location.reservesSouthPacific),
        (Piece.armyPolish1, Location.frontWestern),
        (Piece.armyDanish, Location.frontWestern),
        (Piece.armyDutch, Location.frontWestern),
        (Piece.armyFrench1, Location.frontWestern),
        (Piece.capitalBerlin, Location.frontEastern),
        (Piece.policyItaly, Location.frontMed),
        (Piece.capitalCcnn, Location.frontMed),
        (Piece.armyItalianCol, Location.frontMed),
        (Piece.armyItalian10, Location.frontMed),
        (Piece.armyJapaneseNcaa, Location.frontChina),
        (Piece.armyJapaneseCcaa, Location.frontChina),
        (Piece.capitalManchukuo, Location.frontChina),
        (Piece.policyJapanSoutheastAsia, Location.frontSoutheastAsia),
        (Piece.policyJapanSouthPacific, Location.frontSouthPacific),
        (Piece.capitalTokyo, Location.frontSouthPacific),
        (Piece.cityChicago, Location.boxCitiesHighMorale),
        (Piece.cityNewYork, Location.boxCitiesHighMorale),
        (Piece.citySanFrancisco, Location.boxCitiesHighMorale),
        (Piece.citySydney, Location.boxCitiesHighMorale),
        (Piece.cityGlasgow, Location.boxCitiesHighMorale),
        (Piece.cityLondon, Location.boxCitiesHighMorale),
        (Piece.cityChungking, Location.boxCitiesHighMorale),
        (Piece.cityDelhi, Location.boxCitiesHighMorale),
        (Piece.cityBaku, Location.boxCitiesHighMorale),
        (Piece.cityLeningrad, Location.boxCitiesHighMorale),
        (Piece.cityMoscow, Location.boxCitiesHighMorale),
        (Piece.partisans0, Location.boxPartisansPool),
        (Piece.partisans1, Location.boxPartisansPool),
        (Piece.maltaBesieged, Location.partisansMed),
        (Piece.dollars, Location.omnibus8),
        (Piece.cannonMeat, Location.omnibus8),
        (Piece.aidChina, Location.omnibus5),
        (Piece.abombResearch, Location.omnibus0),
        (Piece.navalActions1, Location.omnibus0),
        (Piece.shipAkagi, Location.seaMidway),
        (Piece.shipZuikaku, Location.seaMidway),
        (Piece.shipHiryu, Location.seaMidway),
        (Piece.shipKongo, Location.seaPhilippine),
        (Piece.shipZuiho, Location.seaPhilippine),
        (Piece.shipZeroRed, Location.seaPhilippine),
        (Piece.shipTanakaDestroyers, Location.seaCoral),
        (Piece.shipAoba, Location.seaCoral),
        (Piece.shipChokai, Location.boxKureNavalBase),
        (Piece.shipIboatsRed, Location.boxKureNavalBase),
        (Piece.shipRyujo, Location.boxKureNavalBase),
        (Piece.shipTaiho, Location.boxKureNavalBase),
        (Piece.shipYamato, Location.boxKureNavalBase),
        (Piece.convoyBritish, Location.boxAvailableConvoys),
        (Piece.convoyFrench, Location.boxAvailableConvoys),
        (Piece.convoyNorwegian, Location.boxNorway),
        (Piece.raiderGrafSpee, Location.boxGermanUboats),
        (Piece.uboats0, Location.boxGermanUboats),
        (Piece.leaderStalin, Location.boxAlliedLeadershipRussian),
        (Piece.leaderChamberlain, Location.boxAlliedLeadershipBritish),
        (Piece.leaderRoosevelt, Location.omnibus5),
        (Piece.economyGerman, Location.boxGermany),
        (Piece.economyJapanese, Location.boxJapan),
        (Piece.lendLeaseLibertyShips, Location.boxUSEastCoast),
        (Piece.lendLeaseJeepsTrucks, Location.boxUSEastCoast),
        (Piece.lendLeaseDestroyerDeal, Location.boxUSEastCoast),
        (Piece.policyRussia, Location.boxSovietPolicyNeutral),
        (Piece.burmaRoadOpen, Location.regionBurmaRoad),
        (Piece.sinkiangUssr, Location.regionSinkiang),
        (Piece.finlandUN, Location.regionFinland),
        (Piece.usMarines, Location.boxHawaii),
        (Piece.spruanceP2, Location.boxHawaii),
        (Piece.congoUN, Location.regionBelgianCongo),
        (Piece.southAfricaUN, Location.regionSouthAfrica),
    ]);

    return state;
  }

  factory GameState.setupTurningPoint(Random random) {

    var state = GameState.setupCounterTray();

    final eventsOccurred = [
      PoliticalEvent.areaBombing,
      PoliticalEvent.iraq,
      PoliticalEvent.italy,
      PoliticalEvent.syria,
      PoliticalEvent.torch,
    ];

    for (final event in eventsOccurred) {
      state.setPoliticalEventOccurred(event);
    }

    final randomShips = [
        Piece.shipYamato,
        Piece.shipZuikaku,
        Piece.shipChokai,
        Piece.shipZeroRed,
        Piece.shipIboatsRed,
        Piece.shipZuiho,
        Piece.shipTaiho,
    ];

    final randomCarriers = PieceType.carrier.pieces;

    randomShips.shuffle(random);
    randomCarriers.shuffle(random);

    state.setupPieces([
        (Piece.turnChit1, Location.discarded),
        (Piece.turnChit2, Location.discarded),
        (Piece.turnChit3, Location.discarded),
        (Piece.turnChit4, Location.discarded),
        (Piece.turnChit5, Location.discarded),
        (Piece.turnChit6, Location.discarded),
        (Piece.turnChit7, Location.discarded),
        (Piece.turnChit8, Location.discarded),
        (Piece.turnChit9, Location.discarded),
        (Piece.turnChit10, Location.discarded),
        (Piece.turnChit11, Location.discarded),
        (Piece.turnChit12, Location.calendar12),
        (Piece.turnChit13, Location.cupTurn),
        (Piece.turnChit14, Location.cupTurn),
        (Piece.turnChit15, Location.cupTurn),
        (Piece.turnChit16, Location.cupTurn),
        (Piece.turnChit17, Location.cupTurn),
        (Piece.turnChit18, Location.cupTurn),
        (Piece.turnChit19, Location.cupTurn),
        (Piece.turnChit20, Location.cupTurn),
        (Piece.turnChit21, Location.cupTurn),
        (Piece.turnChit22, Location.cupTurn),
        (Piece.turnChit23, Location.cupTurn),
        (Piece.turnChit24, Location.cupTurn),
        (Piece.turnChit25, Location.cupTurn),
        (Piece.turnChit26, Location.cupTurn),
        (Piece.turnChit27, Location.cupTurn),
        (Piece.turnChit28, Location.cupTurn),
        (Piece.armyGermanJu88, Location.reservesWestern),
        (Piece.armyGermanDo17, Location.reservesWestern),
        (Piece.blitzWestern, Location.reservesWestern),
        (Piece.armyGermanSouth, Location.reservesEastern),
        (Piece.armyRomanian, Location.reservesEastern),
        (Piece.blitzEastern, Location.reservesEastern),
        (Piece.armyGermanAfrikaKorps, Location.reservesMed),
        (Piece.armyItalianCol, Location.reservesMed),
        (Piece.armyItalian5, Location.reservesMed),
        (Piece.blitzMed, Location.reservesMed),
        (Piece.armyJapaneseWang, Location.reservesChina),
        (Piece.armyChineseCommunist, Location.reservesChina),
        (Piece.blitzChina, Location.reservesChina),
        (Piece.armyJapaneseBurmese, Location.reservesSoutheastAsia),
        (Piece.armyJapaneseIndian, Location.reservesSoutheastAsia),
        (Piece.blitzSoutheastAsia, Location.reservesSoutheastAsia),
        (Piece.armyJapanese31, Location.reservesSouthPacific),
        (Piece.blitzSouthPacific, Location.reservesSouthPacific),
        (Piece.capitalGoring, Location.frontWestern),
        (Piece.armyGermanBf109, Location.frontWestern),
        (Piece.armyGermanHe111, Location.frontWestern),
        (Piece.capitalBerlin, Location.frontEastern),
        (Piece.armyGermanCenter, Location.frontEastern),
        (Piece.armyGermanNorth, Location.frontEastern),
        (Piece.strategyEastern, Location.frontEastern),
        (Piece.capitalCcnn, Location.frontMed),
        (Piece.armyItalian10, Location.frontMed),
        (Piece.capitalManchukuo, Location.frontChina),
        (Piece.armyJapaneseCcaa, Location.frontChina),
        (Piece.armyJapaneseNcaa, Location.frontChina),
        (Piece.armyJapanese15, Location.frontSoutheastAsia),
        (Piece.armyJapanese28, Location.frontSoutheastAsia),
        (Piece.capitalThailand, Location.frontSoutheastAsia),
        (Piece.capitalTokyo, Location.frontSouthPacific),
        (Piece.armyJapanese14, Location.frontSouthPacific),
        (Piece.armyJapanese18, Location.frontSouthPacific),
        (Piece.strategySouthPacific, Location.frontSouthPacific),
        (Piece.cityChicago, Location.boxCitiesHighMorale),
        (Piece.cityNewYork, Location.boxCitiesHighMorale),
        (Piece.citySanFrancisco, Location.boxCitiesHighMorale),
        (Piece.citySydney, Location.boxCitiesHighMorale),
        (Piece.cityGlasgow, Location.boxCitiesLowMorale),
        (Piece.cityLondon, Location.boxCitiesLowMorale),
        (Piece.cityChungking, Location.boxCitiesHighMorale),
        (Piece.cityDelhi, Location.boxCitiesHighMorale),
        (Piece.cityBaku, Location.boxCitiesHighMorale),
        (Piece.cityGorky, Location.boxCitiesHighMorale),
        (Piece.cityTbilisi, Location.boxCitiesHighMorale),
        (Piece.economyGerman, Location.boxGermany),
        (Piece.economyJapanese, Location.boxJapan),
        (Piece.finlandUN, Location.regionFinland),
        (Piece.operationAL, Location.boxAttuAndKiska),
        (Piece.burmaRoadClosed, Location.regionBurmaRoad),
        (Piece.siegeTunis, Location.frontMed),
        (Piece.spruanceP1, Location.calendar15),
        (Piece.usMarines, Location.calendar15),
        (Piece.dollars, Location.omnibus1),
        (Piece.navalActions1, Location.omnibus1),
        (Piece.abombResearch, Location.omnibus6),
        (Piece.shipYamamoto, Location.seaCoral),
        (Piece.shipHiyo, Location.boxKureNavalBase),
        (Piece.shipChitose, Location.boxKureNavalBase),
        (Piece.shipUnryu, Location.boxKureNavalBase),
        (Piece.shipHaruna, Location.boxKureNavalBase),
        (Piece.shipYahagi, Location.boxKureNavalBase),
        (Piece.shipAkizukiDestroyers, Location.boxKureNavalBase),
        (randomShips[0], Location.seaMidway),
        (randomShips[1], Location.seaMidway),
        (randomShips[2], Location.seaCoral),
        (randomShips[3], Location.seaCoral),
        (randomShips[4], Location.seaPhilippine),
        (randomShips[5], Location.seaPhilippine),
        (randomShips[6], Location.seaPhilippine),
        (Piece.convoyAmerican0, Location.boxAvailableConvoys),
        (Piece.convoyAmerican1, Location.boxAvailableConvoys),
        (Piece.convoyEscorted2, Location.boxAvailableConvoys),
        (Piece.convoyEscorted3, Location.boxAvailableConvoys),
        (Piece.asw, Location.boxAvailableConvoys),
        (Piece.uboats0, Location.boxGermanUboats),
        (Piece.uboats1, Location.boxGermanUboats),
        (Piece.uboats2, Location.boxGermanUboats),
        (Piece.uboats3, Location.boxGermanUboats),
        (Piece.escortSaoPaulo, Location.seaZone1B),
        (Piece.raiderPrinzEugen, Location.discarded),
        (Piece.leaderChurchill, Location.boxAlliedLeadershipBritish),
        (Piece.leaderRoosevelt, Location.boxAlliedLeadershipAmerican),
        (Piece.leaderStalin, Location.boxAlliedLeadershipRussian),
        (Piece.partisansSoviet, Location.partisansEastern),
        (Piece.partisans0, Location.partisansChina),
        (Piece.partisans1, Location.boxPartisansPool),
        (Piece.partisansCommunist0, Location.boxPartisansPool),
        (Piece.partisansCommunist1, Location.boxPartisansPool),
        (Piece.partisansItalian, Location.boxPartisansPool),
        (Piece.armyTito, Location.boxTito),
        (Piece.policyRussia, Location.boxSovietPolicyWarVsGermany),
        (Piece.commandoSkorzeny, Location.boxAxisCommandos),
        (randomCarriers[0], Location.cupCarrier),
        (randomCarriers[1], Location.cupCarrier),
        (randomCarriers[2], Location.cupCarrier),
        (randomCarriers[3], Location.cupCarrier),
        (randomCarriers[4], Location.cupCarrier),
        (randomCarriers[5], Location.cupCarrier),
        (randomCarriers[6], Location.cupCarrier),
        (randomCarriers[7], Location.cupCarrier),
        (randomCarriers[8], Location.cupCarrier),
        (randomCarriers[9], Location.cupCarrier),
        (Piece.airBaseBritish, Location.boxAlliedAirBases),
        (Piece.armySinkiang, Location.regionSinkiang),
        (Piece.occupiedDutchEastIndies, Location.regionDutchEastIndies),
        (Piece.congoUN, Location.regionBelgianCongo),
        (Piece.southAfricaUN, Location.regionSouthAfrica),
        (Piece.armyPolish2, Location.discarded),
        (Piece.armyNorwegian, Location.discarded),
        (Piece.armyBelgian, Location.discarded),
        (Piece.armyFrench2, Location.discarded),
    ]);

    return state;
  }
}

enum Choice {
  axisFailureMaltaSafe,
  axisFailureMaltaBesieged,
  axisSuccessMaltaSafe,
  axisSuccessMaltaBesieged,
  scatter,
  fight,
  raiseCannonMeat,
  dollars2,
  dollars1,
  chinaAid,
  cannonMeat,
  shock,
  marines,
  partisanUprising,
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

  void update(PlayerChoice playerChoice) {
    if (playerChoice.location != null) {
      selectedLocations.add(playerChoice.location!);
    }
    if (playerChoice.piece != null) {
      selectedPieces.add(playerChoice.piece!);
    }
    if (playerChoice.choice != null) {
      selectedChoices.add(playerChoice.choice!);
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
  lostUsaMoraleCollapse,
  lostAlliedMoraleCollapse,
  lostSovietMoraleCollapse,
  wonGameNotWar,
  historicalUnVictory,
  unVictory,
}

class GameOutcome {
  GameResult result;

  GameOutcome(this.result);

  GameOutcome.fromJson(Map<String, dynamic> json) :
    result = GameResult.values[json['result'] as int];

  Map<String, dynamic> toJson() => {
    'result': result.index,
  };
}

class GameOverException implements Exception {
  GameOutcome outcome;

  GameOverException(GameResult result) :
    outcome = GameOutcome(result);
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
  turnStart,
  eveningTelegraph,
  axisPowersAttack,
  economicWarfare,
  unitedNationsAttack,
  pacificNaval,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateTurnStart extends PhaseState {
  int die = 0;

  PhaseStateTurnStart();

  PhaseStateTurnStart.fromJson(Map<String, dynamic> json) :
    die = json['die'] as int;
  
  @override
  Map<String, dynamic> toJson() => {
    'die': die,
  };

  @override
  Phase get phase {
    return Phase.turnStart;
  }
}

class PhaseStateEveningTelegraph extends PhaseState {
  int result = 0;

  PhaseStateEveningTelegraph();

  PhaseStateEveningTelegraph.fromJson(Map<String, dynamic> json) :
    result = json['result'] as int;
  
  @override
  Map<String, dynamic> toJson() => {
    'result': result,
  };

  @override
  Phase get phase {
    return Phase.eveningTelegraph;
  }
}

class PhaseStateAxisPowersAttack extends PhaseState {
  List<int> frontAttacksRemaining = List<int>.filled(LocationType.front.lastIndex - LocationType.front.firstIndex, 0);

  PhaseStateAxisPowersAttack();

  PhaseStateAxisPowersAttack.fromJson(Map<String, dynamic> json) :
    frontAttacksRemaining = List<int>.from(json['frontAttacksRemaining']);

  @override
  Map<String, dynamic> toJson() => {
    'frontAttacksRemaining': frontAttacksRemaining,
  };

  @override
  Phase get phase {
    return Phase.axisPowersAttack;
  }
}

class PhaseStateEconomicWarfare extends PhaseState {
  List<Location> outstandingConflictSeaZones = <Location>[];
  bool outstandingEuropeBombing = false;
  bool outstandingPacificBombing = false;
  int destroyerDealDelay = 0;

  PhaseStateEconomicWarfare();

  PhaseStateEconomicWarfare.fromJson(Map<String, dynamic> json) :
    outstandingConflictSeaZones = locationListFromIndices(List<int>.from(json['outstandingConflictSeaZones'])),
    outstandingEuropeBombing = json['outstandingEuropeBombing'] as bool,
    outstandingPacificBombing = json['outstandingPacificBombing'] as bool,
    destroyerDealDelay = json['destroyerDealDelay'] as int;

  @override
  Map<String, dynamic> toJson() => {
    'outstandingConflictSeaZones': locationListToIndices(outstandingConflictSeaZones),
    'outstandingEuropeBombing': outstandingEuropeBombing,
    'outstandingPacificBombing': outstandingPacificBombing,
    'destroyerDealDelay': destroyerDealDelay,
  };

  @override
  Phase get phase {
    return Phase.economicWarfare;
  }
}

class PhaseStateUnitedNationsAttack extends PhaseState {
  int partisanUprisingCount = 0;
  bool normandyLandings = false;
  Piece? attackedPiece;

  PhaseStateUnitedNationsAttack();

  PhaseStateUnitedNationsAttack.fromJson(Map<String, dynamic> json) :
    partisanUprisingCount = json['partisanUprisingCount'] as int,
    normandyLandings = json['normandyLandings'] as bool,
    attackedPiece = pieceFromIndex(json['attackedPiece'] as int?);
  
  @override
  Map<String, dynamic> toJson() => {
    'partisanUprisingCount': partisanUprisingCount,
    'normandyLandings': normandyLandings,
    'attackedPiece': pieceToIndex(attackedPiece),
  };

  @override
  Phase get phase {
    return Phase.unitedNationsAttack;
  }
}

class PhaseStatePacificNaval extends PhaseState {
  int? japaneseNavalMissionRoll;
  Location? yamamotoSea;

  PhaseStatePacificNaval();

  PhaseStatePacificNaval.fromJson(Map<String, dynamic> json)
    : japaneseNavalMissionRoll = json['japaneseNavalMissionRoll'] as int?
    , yamamotoSea = locationFromIndex(json['yamamotoSea'] as int?)
    ;
  
  @override
  Map<String, dynamic> toJson() => {
    'japaneseNavalMissionRoll': japaneseNavalMissionRoll,
    'yamamotoSea': locationToIndex(yamamotoSea),
  };

  @override
  Phase get phase {
    return Phase.pacificNaval;
  }
}

class AttackGroundPieceState {
  int subStep = 0;
  bool dollars = false;
  bool chinaAid = false;
  bool cannonMeat = false;
  bool shock = false;
  bool marines = false;
  bool partisanUprising = false;

  AttackGroundPieceState();
  
  AttackGroundPieceState.fromJson(Map<String, dynamic> json) :
    subStep = json['subStep'] as int,
    dollars = json['dollars'] as bool,
    chinaAid = json['chinaAid'] as bool,
    cannonMeat = json['cannonMeat'] as bool,
    shock = json['shock'] as bool,
    marines = json['marines'] as bool,
    partisanUprising = json['partisanUprising'] as bool;

  Map<String, dynamic> toJson() => {
    'subStep': subStep,
    'dollars': dollars,
    'chinaAid': chinaAid,
    'cannonMeat': cannonMeat,
    'shock': shock,
    'marines': marines,
    'partisanUprising': partisanUprising,
  };
}

class AttackCapitalState {
  int subStep = 0;
  bool dollars = false;
  bool chinaAid = false;
  bool cannonMeat = false;
  bool marines = false;
  bool partisanUprising = false;

  AttackCapitalState();
  
  AttackCapitalState.fromJson(Map<String, dynamic> json) :
    subStep = json['subStep'] as int,
    dollars = json['dollars'] as bool,
    chinaAid = json['chinaAid'] as bool,
    cannonMeat = json['cannonMeat'] as bool,
    marines = json['marines'] as bool,
    partisanUprising = json['partisanUprising'] as bool;

  Map<String, dynamic> toJson() => {
    'subStep': subStep,
    'dollars': dollars,
    'chinaAid': chinaAid,
    'cannonMeat': cannonMeat,
    'marines': marines,
    'partisanUprising': partisanUprising,
  };
}

class JapaneseNavalMissionState {
  int subStep = 0;

  JapaneseNavalMissionState();

  JapaneseNavalMissionState.fromJson(Map<String, dynamic> json)
    : subStep = json['subStep'] as int
    ;
  
  Map<String, dynamic> toJson() => {
    'subStep': subStep,
  };
}

class Game {
  final Scenario _scenario;
  final GameOptions _options;
  final GameState _state;
  int _step = 0;
  int _subStep = 0;
  GameOutcome? _outcome;
  String _log = '';
  PlayerChoiceInfo _choiceInfo = PlayerChoiceInfo();
  PhaseState? _phaseState;
  AttackGroundPieceState? _attackGroundPieceState;
  AttackCapitalState? _attackCapitalState;
  JapaneseNavalMissionState? _japaneseNavalMissionState;
  Random _random = Random();
  final int _gameId;

  Game(this._gameId, this._scenario, this._options, this._state, this._random);

  Game.saved(this._gameId, this._scenario, this._options, this._state, this._step, this._subStep, this._log, Map<String, dynamic> gameStateJson) {
    _gameStateFromJson(gameStateJson);
  }

  void _gameStateFromJson(Map<String, dynamic> json) {
    _phaseState = null;
    final phaseIndex = json['phase'] as int?;
    if (phaseIndex != null) {
      final phaseStateJson = json['phaseState'];
      switch (Phase.values[phaseIndex]) {
      case Phase.turnStart:
        _phaseState = PhaseStateTurnStart.fromJson(phaseStateJson);
      case Phase.eveningTelegraph:
        _phaseState = PhaseStateEveningTelegraph.fromJson(phaseStateJson);
      case Phase.axisPowersAttack:
        _phaseState = PhaseStateAxisPowersAttack.fromJson(phaseStateJson);
      case Phase.economicWarfare:
        _phaseState = PhaseStateEconomicWarfare.fromJson(phaseStateJson);
      case Phase.unitedNationsAttack:
        _phaseState = PhaseStateUnitedNationsAttack.fromJson(phaseStateJson);
      case Phase.pacificNaval:
        _phaseState = PhaseStatePacificNaval.fromJson(phaseStateJson);
      }
    }

    final attackGroundPieceStateJson = json['attackGroundPiece'];
    if (attackGroundPieceStateJson != null) {
      _attackGroundPieceState = AttackGroundPieceState.fromJson(attackGroundPieceStateJson);
    }
    final attackCapitalStateJson = json['attackCapital'];
    if (attackCapitalStateJson != null) {
      _attackCapitalState = AttackCapitalState.fromJson(attackCapitalStateJson);
    }
    final japaneseNavalMissionStateJson = json['japaneseNavalMission'];
    if (japaneseNavalMissionStateJson != null) {
      _japaneseNavalMissionState = JapaneseNavalMissionState.fromJson(japaneseNavalMissionStateJson);
    }

    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
    if (_phaseState != null) {
      map['phase'] = _phaseState!.phase.index;
      map['phaseState'] = _phaseState!.toJson();
    }
    if (_attackGroundPieceState != null) {
      map['attackGroundPiece'] = _attackGroundPieceState!.toJson();
    }
    if (_attackCapitalState != null) {
      map['attackCapital'] = _attackCapitalState!.toJson();
    }
    if (_japaneseNavalMissionState != null) {
      map['japaneseNavalMission'] = _japaneseNavalMissionState!.toJson();
    }
    map['choiceInfo'] = _choiceInfo.toJson();
    return map;
  }

  Future<void> saveSnapshot() async {
    await GameDatabase.instance.appendGameSnapshot(
      _gameId,
      jsonEncode(_state.toJson()),
      _step, _subStep,
      _state.turnName(_state.currentTurn + 1),
      _log);
  }

  Future<void> saveCurrentState() async {
    await GameDatabase.instance.setGameState(
      _gameId,
      jsonEncode(_state.toJson()),
      _step, _subStep,
      _state.turnName(_state.currentTurn + 1),
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
    logLine('> Roll: **${dieFaceCharacter(d0)}${dieFaceCharacter(d1)}${dieFaceCharacter(d2)}**');
    return (d0, d1, d2, d0 + d1 + d2);
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

  void churchillInUse(int turnCount) {
    int futureTurn = _state.currentTurn + turnCount;
    _state.churchillInUse(turnCount);
    if (futureTurn <= 27) {
      logLine('> Churchill preoccupied until ${_state.turnName(futureTurn)}.');
    } else {
      logLine('> Churchill preoccupied for the duration.');
    }
  }

  void adjustDollars(int delta) {
    _state.adjustDollars(delta);
    if (delta > 0) {
      logLine('> Dollars: +$delta => ${_state.dollars}');
    } else {
      logLine('> Dollars: $delta => ${_state.dollars}');
    }
  }

  void adjustAidToChina(int delta) {
    _state.adjustAidToChina(delta);
    if (delta > 0) {
      logLine('> Cannon Meat: +$delta => ${_state.aidToChina}');
    } else {
      logLine('> Cannon Meat: $delta => ${_state.aidToChina}');
    }
  }

  void adjustCannonMeat(int delta) {
    _state.adjustCannonMeat(delta);
    if (delta > 0) {
      logLine('> Cannon Meat: +$delta => ${_state.cannonMeat}');
    } else {
      logLine('> Cannon Meat: $delta => ${_state.cannonMeat}');
    }
  }

  void adjustNavalActions(int delta) {
    _state.adjustNavalActions(delta);
    if (delta > 0) {
      logLine('> Naval Actions: +$delta => ${_state.navalActions}');
    } else {
      logLine('> Naval Actions: $delta => ${_state.navalActions}');
    }
  }

  void adjustManhattanProject(int delta) {
    _state.adjustManhattanProject(delta);
    if (delta > 0) {
      logLine('> Manhattan Project: +$delta => ${_state.manhattanProject}');
    } else {
      logLine('> Manhattan Project: $delta => ${_state.manhattanProject}');
    }
  }

  void cityToLowMorale(Piece city) {
    logLine('> Morale in ${city.desc} falls.');
    _state.setPieceLocation(city, Location.boxCitiesLowMorale);
    if (_state.piecesInLocationCount(PieceType.alliedCity, Location.boxCitiesHighMorale) == 0) {
      logLine('> Allied morale collapses.');
      throw GameOverException(GameResult.lostAlliedMoraleCollapse);
    }
    if (_state.piecesInLocationCount(PieceType.sovietCity, Location.boxCitiesHighMorale) == 0) {
      logLine('> Soviet morale collapses.');
      throw GameOverException(GameResult.lostSovietMoraleCollapse);
    }
  }

  // High-Level functions
  
  void operationBarbarossa() {
    logLine('> Germany launches Operation Barbarossa.');
    _state.setPieceLocation(Piece.policyRussia, Location.boxSovietPolicyWarVsGermany);
    logLine('> Soviet Russia is at war with Germany.');
  }

  void pearlHarbor() {
    logLine('> Japan attacks Pearl Harbor.');
    logLine('> America is at war with the Axis Powers.');
    _state.setPieceLocation(Piece.capitalThailand, Location.frontSoutheastAsia);
    _state.setPieceLocation(Piece.armySingapore, Location.frontSoutheastAsia);
    _state.setPieceLocation(Piece.armyBataan, Location.frontSouthPacific);
    _state.setPieceLocation(Piece.armyJapanese14, Location.frontSouthPacific);
    _state.setPieceLocation(Piece.armyJapanese31, Location.frontSouthPacific);
    _state.setPieceLocation(_state.usPresident, Location.boxAlliedLeadershipAmerican);
    int die = rollD6();
    if (die == 6) {
      logLine('> Brazil remains neutral.');
    } else {
      logLine('> Brazil joins the allies.');
      logLine('> Its Navy begins patrolling the Brazilian coast.');
      _state.setPieceLocation(Piece.escortSaoPaulo, Location.seaZone1B);
    }
    final carriers = _state.piecesInLocation(PieceType.carrier, Location.cupCarrier);
    final carrier = randPiece(carriers)!;
    logLine('> ${carrier.desc} is damaged in the attack on Pearl Harbor.');
    _state.setPieceLocation(carrier, Location.trayUnNaval);
  }

  void italyJoinsTheAxis() {
    logLine('> Italy');
    _state.setPieceLocation(Piece.policyItaly, Location.trayItalian);
    _state.setPieceLocation(Piece.armyItalianEastAfrica, Location.regionItalianEastAfrica);
    _state.setPieceLocation(Piece.armyYugoslavian, Location.regionBalkans);
  }

  void franceFalls() {
    _state.setPieceLocation(Piece.capitalGoring, Location.frontWestern);
    if (_state.frontNeutral(Location.frontMed)) {
      italyJoinsTheAxis();
    }
    _state.setPieceLocation(Piece.armyVichySyria, Location.regionNearEast);
    _state.setPieceLocation(Piece.armyVichyMalg, Location.regionFrenchMadagascar);
    _state.setPieceLocation(_state.pieceFlipSide(Piece.convoyFrench)!, _state.futureCalendarBox(1));
    _state.setPieceLocation(Piece.leaderChurchill, _state.pieceLocation(Piece.leaderChamberlain));
  }

  void greeceSurrenders() {
    _state.setPieceLocation(Piece.greekSurrender, Location.regionBalkans);
  }

  void propArmyEliminated(Piece propArmy) {
    switch (propArmy) {
    case Piece.armyPolish1:
      _state.setPieceLocation(Piece.armyPolish2, Location.frontWestern);
    case Piece.armyPolish2:
      _state.setPieceLocation(propArmy, Location.discarded);
      logLine('> Germany conquers Poland.');
    case Piece.armyDanish:
      _state.setPieceLocation(Piece.armyNorwegian, Location.frontWestern);
      logLine('> Germany conquers Denmark.');
    case Piece.armyNorwegian:
      _state.setPieceLocation(propArmy, Location.discarded);
      logLine('> Germany conquers Norway.');
    case Piece.armyDutch:
      _state.setPieceLocation(Piece.armyBelgian, Location.frontWestern);
      logLine('> Germany conquers the Netherlands.');
    case Piece.armyBelgian:
      _state.setPieceLocation(propArmy, Location.discarded);
      logLine('> Germany conquers Belgium.');
    case Piece.armyFrench1:
      _state.setPieceLocation(Piece.armyFrench2, Location.frontWestern);
    case Piece.armyFrench2:
      _state.setPieceLocation(propArmy, Location.discarded);
      logLine('> France surrenders to Germany.');
      franceFalls();
    case Piece.armyYugoslavian:
      _state.setPieceLocation(Piece.armyGreek, Location.regionBalkans);
      logLine('> Germany conquers Yugoslavia.');
     case Piece.armyGreek:
      _state.setPieceLocation(propArmy, Location.discarded);
      logLine('> German conquers Greece.');
      greeceSurrenders();
    case Piece.armyWarsaw:
      _state.setPieceLocation(propArmy, Location.discarded);
    case Piece.armyTito:
      _state.setPieceLocation(propArmy, Location.discarded);
    case Piece.armySingapore:
      logLine('> Japan captures Singapore.');
      _state.setPieceLocation(Piece.armyKnil, Location.regionDutchEastIndies);
    case Piece.armyKnil:
      logLine('> Japan captures the Dutch East Indies.');
      _state.setPieceLocation(propArmy, Location.discarded);
      _state.setPieceLocation(Piece.occupiedDutchEastIndies, Location.regionDutchEastIndies);
    case Piece.armyBataan:
      logLine('> Bataan surrenders.');
      _state.setPieceLocation(propArmy, Location.discarded);
    default:
    }
  }

  void regionalArmyEliminated(Piece army) {
    switch (army) {
    case Piece.armyCongo:
      logLine('> Rexist separatists defeated.');
      logLine('> Uranium supply restored.');
      _state.setPieceLocation(Piece.congoUN, Location.regionBelgianCongo);
    case Piece.armyFinnish:
      logLine('> Finnish Army surrenders.');
      logLine('> Finland returns to neutrality.');
      _state.setPieceLocation(Piece.finlandUN, Location.regionFinland);
    case Piece.armySinkiang:
      logLine('> Pro-Japan forces in Sinkiang eliminated.');
      _state.setPieceLocation(Piece.sinkiangUssr, Location.regionSinkiang);
    case Piece.armyGermanArnim:
    case Piece.armyGermanIraq:
    case Piece.armyGermanSyria:
    case Piece.armyIranianShah:
    case Piece.armyIranianVatan:
    case Piece.armyIraqi:
    case Piece.armyItalianEastAfrica:
    case Piece.armyJapaneseMadag:
    case Piece.armyTurkish:
    case Piece.armyVichyAlger:
    case Piece.armyVichyMalg:
    case Piece.armyVichySyria:
      logLine('> ${army.desc} eliminated.');
      _state.setPieceLocation(army, Location.discarded);
    default:
    }
  }

  void resolveUNAttackOnPiece(Piece piece, bool shock, bool marines, bool partisanUprising, int operationKutuzovModifier) {
    final location = _state.pieceLocation(piece);
    logLine('> UN Attacks ${piece.desc} in ${location.desc}.');
    int die = 0;
    int lowDie = 0;
    if (shock || marines) {
      if (shock) {
        logLine('> Shock Attack');
      } else {
        logLine('> Marines Attack');
      }
      final rolls = roll2D6();
      die = max(rolls.$1, rolls.$2);
      lowDie = min(rolls.$1, rolls.$2);
    } else {
      die = rollD6();
      lowDie = die;
    }
    int modifiers = 0;
    Location militaryEvent = _state.pieceLocation(Piece.militaryEvent);
    switch (location) {
    case Location.frontWestern:
      if (militaryEvent == Location.eventGalland) {
        if (piece.isType(PieceType.proAxisArmy) && _state.pieceLocation(Piece.capitalGoring) == location) {
          logLine('> Galland: -1');
          modifiers -= 1;
        } else if (militaryEvent == Location.eventPatton) {
          logLine('> Patton: +1');
          modifiers += 1;
        }
      }
    case Location.frontEastern:
    if (operationKutuzovModifier > 0) {
      logLine('> Operation Kutuzov: +$operationKutuzovModifier');
      modifiers += operationKutuzovModifier;
    } else if (militaryEvent == Location.eventZhukov) {
      logLine('> Zhukov: +1');
      modifiers += 1;
    } else if (militaryEvent == Location.eventManstein) {
      logLine('> Manstein: -1');
      modifiers -= 1;
    }
    if (_state.piecesInLocationCount(PieceType.proAxisArmy, Location.regionFinland) > 0) {
      logLine('> Finland: -1');
      modifiers -= 1;
    }
    if (_state.piecesInLocationCount(PieceType.proAxisArmy, Location.regionCaucasus) > 0) {
      logLine('> The Caucasus: -1');
      modifiers -= 1;
    }
    if (_state.piecesInLocationCount(PieceType.proAxisArmy, Location.regionNearEast) > 0) {
      logLine('> The Near East: -1');
      modifiers -= 1;
    }
    case Location.frontMed:
      if (militaryEvent == Location.eventRommel) {
        logLine('> Rommel: -1');
        modifiers -= 1;
      }
      if (_state.piecesInLocationCount(PieceType.proAxisArmy, Location.regionNearEast) > 0) {
        logLine('> The Near East: -1');
        modifiers -= 1;
      }
      if (_state.piecesInLocationCount(PieceType.proAxisArmy, Location.regionItalianEastAfrica) > 0) {
        logLine('> Italian East Africa: -1');
        modifiers -= 1;
      }
      if (_state.piecesInLocationCount(PieceType.proAxisArmy, Location.regionFrenchMadagascar) > 0) {
        logLine('> French Madagascar: -1');
        modifiers -= 1;
      }
    case Location.frontChina:
      if (militaryEvent == Location.eventOperationIchiGo) {
        logLine('> Operation Ichi-Go: -1');
        modifiers -= 1;
      } else if (militaryEvent == Location.event4thWarArea) {
        logLine('> 4th War Area: +1');
        modifiers += 1;
      }
      if (_state.piecesInLocationCount(PieceType.proAxisArmy, Location.regionSinkiang) > 0) {
        logLine('> Sinkiang: -1');
        modifiers -= 1;
      }
      if (_state.burmaRoadClosed) {
        logLine('> Burma Road Closed: -1');
        modifiers -= 1;
      }
      if (_state.pieceLocation(Piece.policyRussia) == Location.boxSovietPolicyWarVJapan) {
        logLine('> Soviet attack on Manchuria: +1');
        modifiers += 1;
      }
    case Location.frontSoutheastAsia:
      if (militaryEvent == Location.eventYamashita) {
        logLine('> Yamashita: -1');
        modifiers -= 1;
      } else if (militaryEvent == Location.eventSlim) {
        logLine('> Slim: +1');
        modifiers += 1;
      }
      if (_state.piecesInLocationCount(PieceType.proAxisArmy, Location.regionItalianEastAfrica) > 0) {
        logLine('> Italian East Africa: -1');
        modifiers -= 1;
      }
      if (_state.piecesInLocationCount(PieceType.proAxisArmy, Location.regionIndia) > 0) {
        logLine('> India: -1');
        modifiers -= 1;
      }
      if (_state.piecesInLocationCount(PieceType.proAxisArmy, Location.regionFrenchMadagascar) > 0) {
        logLine('> French Madagascar: -1');
        modifiers -= 1;
      }
    case Location.frontSouthPacific:
      final armyCount = _state.piecesInLocationCount(PieceType.proAxisArmy, location);
      logLine('> Armies: +$armyCount');
      modifiers += armyCount;
      int shipCount = 0;
      for (final sea in LocationType.sea.locations) {
        final seaShipCount = _state.piecesInLocationCount(PieceType.ship, sea);
        if (seaShipCount > shipCount) {
          shipCount = seaShipCount;
        }
      }
      if (shipCount > 0) {
        logLine('> Ships: -$shipCount');
        modifiers -= shipCount;
      }
      if (militaryEvent == Location.eventMacArthur) {
        logLine('> MacArthur: +1');
        modifiers += 1;
      }
    case Location.regionFrenchNorthAfrica:
      if (_state.pieceLocation(Piece.ricksPlace) == location) {
        logLine('> Rick’s Place: +1');
        modifiers += 1;
      }
    default:
    }
    if (militaryEvent == Location.eventWavell) {
      if (piece.isType(PieceType.italianArmy) || piece.isType(PieceType.italianCapital)) {
        logLine('> Wavell: +1');
        modifiers += 1;
      }
    }
    if (piece.isType(PieceType.japaneseArmy) || piece.isType(PieceType.japaneseCapital)) {
      logLine('> Banzai Attacks: -1');
      modifiers -= 1;
    }
    if (partisanUprising) {
      final armyCount = _state.piecesInLocationCount(PieceType.proAxisArmy, location);
      logLine('> Partisan Uprising: +$armyCount');
      modifiers += armyCount;
    }
    int total = die + modifiers;
    logLine('> Total: total');
    int strength = _state.armyStrength(piece);
    if (die == 1 || (die != 6 && total <= strength)) {
      logLine('> Attack fails.');
    } else {
      logLine('> Attack succeeds.');
      if (piece.isType(PieceType.proAxisOrVichyArmy)) {
        if (location.isType(LocationType.front)) {
          final reservesBox = _state.frontReservesBox(location);
          logLine('> ${piece.desc} is withdrawn to ${location.desc}.');
          _state.setPieceLocation(piece, reservesBox);
        } else {
          regionalArmyEliminated(piece);
        }
      } else if (piece == Piece.panzerPza) {
        logLine('> ${piece.desc} is withdrawn.');
        _state.setPieceLocation(piece, Location.discarded); // Should be tray, but use this to indicate removed this turn.
      } else if (piece == Piece.panzerTiger) {
        logLine('> ${piece.desc} is eliminated.');
        _state.setPieceLocation(piece, Location.discarded);
      } else if (piece.isType(PieceType.siegeInitial)) {
        logLine('> ${piece.desc} Tightens.');
        _state.setPieceLocation(_state.pieceFlipSide(piece)!, location);
      }
    }
    if (marines) {
      _state.setPieceLocation(Piece.usMarines, _state.futureCalendarBox(_state.frontHasStrategy(location) ? lowDie : die));
    }
    if (partisanUprising) {
      final partisans = _state.pieceInLocation(PieceType.partisans, _state.frontPartisansBox(location))!;
      _state.setPieceLocation(partisans, Location.discarded);
    }
  }

  Location? mostValuableSeaZone(List<Location> seaZones) {
    var mostValuables = <Location>[];
    int highestValue = 0;
    for (final seaZone in seaZones) {
      int value = _state.seaZoneValue(seaZone);
      if (value > highestValue) {
        mostValuables = [seaZone];
        highestValue = value;
      } else if (value == highestValue) {
        mostValuables.add(seaZone);
      }
    }
    return randLocation(mostValuables);
  }

  void sinkUboat(Piece piece) {
    if (piece.isType(PieceType.raider)) {
      logLine('> ${piece.desc} is sunk.');
      if (piece == Piece.raiderBismarck) {
        logLine('> ${Piece.raiderPrinzEugen.desc} remains at sea.');
        _state.setPieceLocation(Piece.raiderPrinzEugen, _state.pieceLocation(piece));
      } else {
        _state.setPieceLocation(piece, Location.discarded);
      }
    } else {
      logLine('> U-Boats are sunk.');
      final delay = _state.currentTurnUboatDelay;
      if (delay != null && !_state.germanEconomyCollapsed) {
        final calendarBox = _state.futureCalendarBox(delay);
        _state.setPieceLocation(piece, calendarBox);
      } else {
        _state.setPieceLocation(piece, Location.discarded);
      }
    }
  }

  bool attackOnLocationAffordable(Location location) {
    if (_state.dollars >= 1) {
      return true;
    }
    if (_state.aidToChina >= 1) {
      if ([Location.frontChina, Location.frontSoutheastAsia, Location.regionSinkiang].contains(location)) {
        return true;
      }
    }
    if (_state.cannonMeat >= 1) {
      if ([Location.frontEastern, Location.regionFinland, Location.regionSinkiang, Location.regionCaucasus].contains(location)) {
        return true;
      }
    }
    if (_state.stalinAvailable) {
      if ([Location.frontEastern, Location.frontChina, Location.regionFinland, Location.regionSinkiang, Location.regionCaucasus].contains(location)) {
        return true;
      }
    }
    return false;
  }

  int downfallOnFrontCost(Location front) {
    final frontType = [Location.frontWestern, Location.frontEastern, Location.frontMed].contains(front) ? LocationType.germanFront : LocationType.japaneseFront;
    int activeFrontCount = 0;
    for (final otherFront in frontType.locations) {
      if (_state.frontActive(otherFront)) {
        activeFrontCount += 1;
      }
    }
    return activeFrontCount;
  }

  bool downfallOnFrontAffordable(Location front) {
    if (_state.dollars >= downfallOnFrontCost(front)) {
      return true;
    }
    if (_state.abombAvailable) {
      if (front.isType(LocationType.germanFront) || _state.pieceLocation(Piece.airBaseTinian) == Location.frontSouthPacific) {
        return true;
      }
    }
    return false;
  }

  void sinkShip(Piece ship) {
    if (ship == Piece.shipYamamoto) {
      logLine('> Admiral Yamamoto is killed.');
      logLine('> US submarines become increasingly effective.');
      _state.setPieceLocation(Piece.submarineCampaign, Location.boxHawaii);
      return;
    }
    Piece? replacementShip;
    if (ship.isType(PieceType.shipFront)) {
      replacementShip = _state.pieceFlipSide(ship)!;
      logLine('> ${ship.desc} is sunk and replaced by ${replacementShip.desc}.');
    } else {
      logLine('> ${ship.desc} is sunk and replaced.');
      replacementShip = ship;
    }
    _state.setPieceLocation(replacementShip, Location.boxKureNavalBase);
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;

    logLine('# Game Over');

    switch (outcome.result) {
    case GameResult.lostUsaMoraleCollapse:
      logLine('### USA Morale Collapses');
    case GameResult.lostAlliedMoraleCollapse:
      logLine('### Allied Morale Collapses');
    case GameResult.lostSovietMoraleCollapse:
      logLine('### Soviet Morale Collapses');
    case GameResult.wonGameNotWar:
      logLine('### Won the game, but not the war');
    case GameResult.historicalUnVictory:
      logLine('### Axis Powers defeated');
    case GameResult.unVictory:
      logLine('### Germany surrenders');
    }
  }

  // Sequence Helpers

  void attackGroundPiece(Piece piece) {
    _attackGroundPieceState ??= AttackGroundPieceState();
    final localState = _attackGroundPieceState!;
    final phaseState = _phaseState as PhaseStateUnitedNationsAttack;
    final location = _state.pieceLocation(piece);
    if (localState.subStep == 0) { // Determine payment
      if (choicesEmpty()) {
        setPrompt('Select payment');
        choiceChoosable(Choice.dollars1, _state.dollars >= 1);
        if ([Location.frontChina, Location.frontSoutheastAsia, Location.regionSinkiang].contains(location)) {
          choiceChoosable(Choice.chinaAid, _state.aidToChina >= 1);
        }
        if ([Location.frontEastern, Location.regionFinland, Location.regionSinkiang, Location.regionCaucasus].contains(location)) {
          choiceChoosable(Choice.cannonMeat, _state.cannonMeat >= 1);
        }
        if ([Location.frontEastern, Location.frontChina, Location.regionFinland, Location.regionSinkiang, Location.regionCaucasus].contains(location)) {
          choiceChoosable(Choice.shock, _state.stalinAvailable);
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.cancel)) {
        _attackGroundPieceState = null;
        return;
      }
      if (checkChoice(Choice.dollars1)) {
        localState.dollars = true;
      } else if (checkChoice(Choice.chinaAid)) {
        localState.chinaAid = true;
      } else if (checkChoice(Choice.cannonMeat)) {
        localState.cannonMeat = true;
      } else if (checkChoice(Choice.shock)) {
        localState.shock = true;
      }
      clearChoices();
      localState.subStep = 1;
    }
    if (localState.subStep == 1) { // Determine other options
      if (!localState.shock) {
        if (choicesEmpty()) {
          if ([Location.frontSoutheastAsia, Location.frontSouthPacific].contains(location)) {
            choiceChoosable(Choice.marines, _state.pieceLocation(Piece.usMarines) == Location.boxHawaii);
          }
          if (location.isType(LocationType.front)) {
            final partisansBox = _state.frontPartisansBox(location);
            final partisans = _state.pieceInLocation(PieceType.partisans, partisansBox);
            if (partisans != null) {
              choiceChoosable(Choice.partisanUprising, phaseState.partisanUprisingCount == 0);
            }
          }
          if (choosableChoiceCount > 0) {
            choiceChoosable(Choice.next, true);
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _attackGroundPieceState = null;
          return;
        }
        if (checkChoice(Choice.marines)) {
          localState.marines = true;
        }
        if (checkChoice(Choice.partisanUprising)) {
          localState.partisanUprising = true;
        }
        clearChoices();
        localState.subStep = 2;
      }
    }
    if (localState.subStep == 2) {
      logLine('> UN Attacks ${piece.desc} in ${location.desc}.');
      if (localState.dollars) {
        adjustDollars(-1);
      }
      if (localState.chinaAid) {
        adjustAidToChina(-1);
      }
      if (localState.cannonMeat) {
        adjustCannonMeat(-1);
      }
      if (localState.partisanUprising) {
        phaseState.partisanUprisingCount += 1;
      }
      resolveUNAttackOnPiece(
        piece,
        localState.shock,
        localState.marines,
        localState.partisanUprising,
        0);
    }
    _attackGroundPieceState = null;
  }

  void attackCapital(Piece piece) {
    _attackCapitalState ??= AttackCapitalState();
    final localState = _attackCapitalState!;
    final phaseState = _phaseState as PhaseStateUnitedNationsAttack;
    final location = _state.pieceLocation(piece);
    if (localState.subStep == 0) { // Determine payment
      if (choicesEmpty()) {
        setPrompt('Select payment');
        choiceChoosable(Choice.dollars1, _state.dollars >= 1);
        if ([Location.frontChina, Location.frontSoutheastAsia, Location.regionSinkiang].contains(location)) {
          choiceChoosable(Choice.chinaAid, _state.aidToChina >= 1);
        }
        if ([Location.frontEastern, Location.regionFinland, Location.regionSinkiang, Location.regionCaucasus].contains(location)) {
          choiceChoosable(Choice.cannonMeat, _state.cannonMeat >= 1);
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.cancel)) {
        _attackGroundPieceState = null;
        return;
      }
      if (checkChoice(Choice.dollars1)) {
        localState.dollars = true;
      } else if (checkChoice(Choice.chinaAid)) {
        localState.chinaAid = true;
      } else if (checkChoice(Choice.cannonMeat)) {
        localState.cannonMeat = true;
      }
      clearChoices();
      localState.subStep = 1;
    }
    if (localState.subStep == 1) { // Determine other options
      if (choicesEmpty()) {
        if ([Location.frontSoutheastAsia, Location.frontSouthPacific].contains(location)) {
          choiceChoosable(Choice.marines, _state.pieceLocation(Piece.usMarines) == Location.boxHawaii);
        }
        if (location.isType(LocationType.front)) {
          final partisansBox = _state.frontPartisansBox(location);
          final partisans = _state.pieceInLocation(PieceType.partisans, partisansBox);
          if (partisans != null) {
            choiceChoosable(Choice.partisanUprising, phaseState.partisanUprisingCount == 0);
          }
        }
        if (choosableChoiceCount > 0) {
          choiceChoosable(Choice.next, true);
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
      }
      if (checkChoiceAndClear(Choice.cancel)) {
        _attackGroundPieceState = null;
        return;
      }
      if (checkChoice(Choice.marines)) {
        localState.marines = true;
      }
      if (checkChoice(Choice.partisanUprising)) {
        localState.partisanUprising = true;
      }
      clearChoices();
      localState.subStep = 2;
    }
    if (localState.subStep == 2) {
      logLine('> UN Attacks ${piece.desc} in ${location.desc}.');
      if (localState.dollars) {
        adjustDollars(-1);
      }
      if (localState.chinaAid) {
        adjustAidToChina(-1);
      }
      if (localState.cannonMeat) {
        adjustCannonMeat(-1);
      }
      if (localState.partisanUprising) {
        phaseState.partisanUprisingCount += 1;
      }
      resolveUNAttackOnPiece(
        piece,
        false,
        localState.marines,
        localState.partisanUprising,
        0);
    }
    _attackCapitalState = null;
  }

  void japaneseNavalMission(Location sea, bool yamamoto) {
    _japaneseNavalMissionState ??= JapaneseNavalMissionState();
    final localState = _japaneseNavalMissionState!;
    if (localState.subStep == 0) {
      Piece? ship;
      if (!yamamoto) {
        final candidateShips = _state.strongestShips(_state.piecesInLocation(PieceType.ship, Location.boxKureNavalBase));
        if (candidateShips.isEmpty) {
          logLine('> No Japanese ships available for mission in ${sea.desc}.');
          _japaneseNavalMissionState = null;
          return;
        }
        ship = randPiece(candidateShips)!;
      } else {
        ship = Piece.shipYamamoto;
      }
      logLine('> ${ship.desc} deploys to ${sea.desc}.');
      _state.setPieceLocation(ship, sea);
      if (_state.piecesInLocationCount(PieceType.ship, sea) < 5) {
        _japaneseNavalMissionState = null;
        return;
      }
      // Kishu    
      logLine('> Japanese Navy conducts a surprise attack in ${sea.desc}.');
      final carrier = randPiece(_state.piecesInLocation(PieceType.carrier, Location.cupCarrier));
      if (carrier != null) {
        logLine('> ${carrier.desc} is damaged.');
        _state.setPieceLocation(carrier, Location.trayUnNaval);
      }
      localState.subStep = 1;
    }
    if (localState.subStep == 1) { // Lower morale
      if (choicesEmpty()) {
        setPrompt('Select High Morale Allied City');
        for (final city in _state.piecesInLocation(PieceType.alliedCity, Location.boxCitiesHighMorale)) {
          pieceChoosable(city);
        }
        throw PlayerChoiceException();
      }
      final city = selectedPiece()!;
      cityToLowMorale(city);
      clearChoices();
      localState.subStep = 2;
    }
    if (localState.subStep == 2) {
      final weakestShips = _state.weakestShips(_state.piecesInLocation(PieceType.ship, sea));
      final ship = randPiece(weakestShips)!;
      sinkShip(ship);
    }
    _japaneseNavalMissionState = null;
  }

  // Calendar Events

  void calendarEventVictoryAtSea2() {
    logLine('### Victory at Sea');
    logLine('> ${Piece.convoyNorwegian} supports the Allies.');
    _state.setPieceLocation(Piece.convoyNorwegian, Location.boxAvailableConvoys);
  }

  void calendarEventVictoryAtSea3() {
    logLine('### Victory at Sea');
    logLine('> New ${Piece.uboats1} are built.');
    _state.setPieceLocation(Piece.uboats1, Location.boxGermanUboats);
  }

  void calendarEventVictoryAtSea4() {
    logLine('### Victory at Sea');
    logLine('> ${Piece.raiderBismarck} is operational.');
    _state.setPieceLocation(Piece.raiderBismarck, Location.boxGermanUboats);
  }

  void calendarEventVictoryAtSea5() {
    logLine('### Victory at Sea');
    logLine('> ${Piece.raiderKormoran} is operational.');
    _state.setPieceLocation(Piece.raiderKormoran, Location.boxGermanUboats);
  }

  void calendarEventVictoryAtSea8() {
    logLine('### Victory at Sea');
    logLine('> New ${Piece.uboats2} are built.');
    _state.setPieceLocation(Piece.uboats2, Location.boxGermanUboats);
  }

  void calendarEventVictoryAtSea12() {
    logLine('### Victory at Sea');
    logLine('> ${Piece.asw} becomes effective.');
    _state.setPieceLocation(Piece.asw, Location.boxAvailableConvoys);
  }

  void calendarEventVictoryAtSea16() {
    logLine('### Victory at Sea');
    logLine('> Craking the Enigma code helps the Allies.');
    _state.setPieceLocation(Piece.aswEnigma, _state.pieceLocation(Piece.asw));
  }

  void calendarEventVictoryAtSea17() {
    logLine('### Victory at Sea');
    logLine('> ${Piece.raiderScharnhorst} joins the Battle for the Atlantic.');
    final location = _state.pieceLocation(Piece.raiderGrafSpee);
     _state.setPieceLocation(Piece.raiderScharnhorst, location != Location.discarded ? location : Location.boxGermanUboats);
  }

  void calendarEventUsElection() {
    logLine('### 1940 US Election');
    int die = rollD6();
    final location = _state.pieceLocation(Piece.leaderRoosevelt);
    int value = location.index - LocationType.calendar.firstIndex + 1;
    Piece president = die > value ? Piece.leaderWilkie : Piece.leaderRoosevelt;
    if (president == Piece.leaderWilkie) {
      logLine('> ${president.desc} becomes President.');
      _state.setPieceLocation(president, location);
    } else { 
      logLine('> ${president.desc} remains President.');
    }
  }

  void calendarEventBritishElection() {
    logLine('### 1945 British Election');
    int die = rollD6();
    if (die <= 3) {
      logLine('> Labour Party victory, ${Piece.leaderChurchill.desc} steps down.');
      _state.setPieceLocation(Piece.leaderChurchill, Location.discarded);
    } else {
      logLine('> Conservative Party victory, ${Piece.leaderChurchill.desc} remains Prime Minister.');
    }
  }

  // Chit Events

  void chitEventManhattanProject() {
    if (_state.manhattanProject < 0) {
      return;
    }
    final phaseState = _phaseState as PhaseStateTurnStart;
    if (_subStep == 0) {
      logLine('### Manhattan Project');
      if (_state.pieceLocation(Piece.armyCongo) == Location.regionBelgianCongo) {
        logLine('> Uranium supply stopped by Rexist separatists.');
        return;
      }
      if (choicesEmpty()) {
        setPrompt('Fund Manhattan Project?');
        choiceChoosable(Choice.yes, _state.dollars >= 1);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.no)) {
        logLine('> Manhattan Project has insufficient funding.');
        return;
      }
      clearChoices();
      _subStep = 1;
    }
    if (choicesEmpty()) {
      logLine('> US funds Manhattan Project.');
      adjustDollars(-1);
      phaseState.die = rollD6();
      setPrompt('Accelerate Manahattan Project with more funding?');
      choiceChoosable(Choice.yes, _state.dollars >= 1);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.no)) {
      adjustManhattanProject(phaseState.die);
    } else {
      logLine('> US tries to accelerate Manhattan Project with additional funding');
      adjustDollars(-1);
      int secondDie = rollD6();
      adjustManhattanProject(secondDie);
    }
    clearChoices();
    if (_state.pieceLocation(Piece.abombResearch) == Location.omnibus13) {
      logLine('> Manhattan Project successfully develops an A-Bomb.');
      _state.setPieceLocation(Piece.abombAvailable, Location.omnibus0);
    }
  }

  void chitEventSouthAfrica() {
    logLine('### South Africa');
    int die = rollD6();
    if (die == 6) {
      logLine('> South Africa pulls out of the war against Hitler.');
      _state.setPieceLocation(Piece.southAfricaNeutral, Location.regionSouthAfrica);
    } else {
      logLine('> South Africa preserves its alliance with Britain.');
    }
  }

  void chitEventCaucasusCrisis() {
    if (_state.pieceLocation(Piece.greekSurrender) != Location.regionBalkans) {
      return;
    }
    logLine('### Caucasus Crisis');
    if (_state.pieceLocation(Piece.armyTurkish) != Location.trayProAxisMinors) {
      return;
    }
    if (_subStep == 0) {
      if (_state.churchillAvailable) {
        if (choicesEmpty()) {
          setPrompt('Use Churchill’s Diplomacy?');
          choiceChoosable(Choice.yes, true);
          choiceChoosable(Choice.no, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.yes)) {
          int die = rollD6();
          churchillInUse(die);
          if (die == 1 || die == 6) {
            logLine('> Diplomatic efforts are in vain');
          } else {
            logLine('> Diplomatic efforts maintain Turkey’s neutrality.');
            return;
          }
        }
        clearChoices();
      }
      _subStep = 1;
    }
    final rolls = roll2D6();
    int dice = rolls.$3;
    int modifiers = 0;
    int modifier = 0;
    modifier = _state.piecesInLocationCount(PieceType.proAxisArmy, Location.frontEastern);
    logLine('> Axis Armies on the Eastern Front: +$modifier');
    modifiers += modifier;
    modifier = _state.piecesInLocationCount(PieceType.proAxisArmy, Location.regionCaucasus);
    if (modifier != 0) {
      logLine('> Axis Armies in the Caucasus: +$modifier');
      modifiers += modifier;
    }
    modifier = _state.piecesInLocationCount(PieceType.proAxisArmy, Location.regionNearEast);
    if (modifier != 0) {
      logLine('> Axis Armies in the Near East: +$modifier');
      modifiers += modifier;
    }
    int total = dice + modifiers;
    logLine('> Total: $total');
    if (total >= 16) {
      logLine('> Turkey joins the Axis.');
      logLine('> Turkish Army deploys in the Caucasus.');
      _state.setPieceLocation(Piece.armyTurkish, Location.regionCaucasus);
      if (_state.pieceLocation(Piece.armyIranianVatan) != Location.regionCaucasus && _state.piecesInLocationCount(PieceType.iranianArmy, Location.discarded) == 0) {
        logLine('> Iranian Vatan Army deploys in the Caucasus.');
        _state.setPieceLocation(Piece.armyIranianVatan, Location.regionCaucasus);
      }
      if (_state.pieceLocation(Piece.armyGermanIraq) != Location.regionNearEast && _state.pieceLocation(Piece.armyIraqi) != Location.discarded && _state.pieceLocation(Piece.armyGermanIraq) != Location.discarded) {
        logLine('> German Iraqi Army deploys in the Near East.');
        _state.setPieceLocation(Piece.armyGermanIraq, Location.regionNearEast);
      }
      if (_state.pieceLocation(Piece.armyGermanSyria) != Location.regionNearEast && _state.pieceLocation(Piece.armyVichySyria) != Location.discarded && _state.pieceLocation(Piece.armyGermanSyria) != Location.discarded) {
        logLine('> German Syria Army deploys in the Near East.');
        _state.setPieceLocation(Piece.armyGermanSyria, Location.regionNearEast);
      }
    } else {
      logLine('> Turkey remains neutral.');
      if (_state.pieceLocation(Piece.armyIranianShah) == Location.trayProAxisMinors) {
        logLine('> Iran joins the Axis.');
        logLine('> Iranian Shah Army deploys in the Caucasus.');
        _state.setPieceLocation(Piece.armyIranianShah, Location.regionCaucasus);
      } else if (_state.pieceLocation(Piece.armyIranianShah) == Location.regionCaucasus) {
        logLine('> Iranian Vatan Army deploys in the Caucasus.');
        _state.setPieceLocation(Piece.armyIranianVatan, Location.regionCaucasus);
      }
    }
  }

  // Evening Telegraph Political Events

  void politicalEventAreaBombing() {
    if (_state.politicalEventCount(PoliticalEvent.areaBombing) == 0) {
      logLine('### Area Bombing');
      logLine('> British Bombers commence strategic bombing.');
      _state.setPieceLocation(Piece.airBaseBritish, Location.boxAlliedAirBases);
      _state.setPoliticalEventOccurred(PoliticalEvent.areaBombing);
    }
  }

  void politicalEventArgentina() {
    if (_state.politicalEventCount(PoliticalEvent.argentina) == 0) {
      logLine('### Argentina');
      int die = rollD6();
      if (die == 6) {
        logLine('> Fascist colonels seize power in Argentina.');
        logLine('> Argentine battleships joint the Battle for the Atlantic.');
        var location = _state.pieceLocation(Piece.raiderKormoran);
        if (location == Location.trayGermanNavy || location == Location.discarded) {
          location = Location.boxGermanUboats;
        }
        _state.setPieceLocation(Piece.raiderRivadavia, location);
      } else {
        logLine('> Argentina remains neutral.');
      }
      _state.setPoliticalEventOccurred(PoliticalEvent.argentina);
    }
  }

  void politicalEventAungSan() {
    if (_state.pieceLocation(Piece.armyJapaneseBurmese) != Location.discarded && _state.pieceLocation(Piece.armyJapaneseBurmese) != Location.frontSoutheastAsia) {
      logLine('### Aung San');
      logLine('> Burmese patriots ditch their Japanese allies.');
      _state.setPieceLocation(Piece.armyJapaneseBurmese, Location.discarded);
      _state.setPoliticalEventOccurred(PoliticalEvent.aungSan);
    }
  }

  void politicalEventCongo() {
    if (_state.politicalEventCount(PoliticalEvent.congo) == 0) {
      logLine('### Congo');
      int die = rollD6();
      if (die == 6) {
        logLine('> Pro-Axis settlers take over the Congo and cut off uranium shipments.');
        _state.setPieceLocation(Piece.armyCongo, Location.regionBelgianCongo);
      } else {
        logLine('> Belgian Administration in Congo remains pro-UN.');
      }
      _state.setPoliticalEventOccurred(PoliticalEvent.congo);
    }
  }

  void politicalEventFinland() {
    if (_state.pieceLocation(Piece.finlandUN) == Location.regionFinland) {
      logLine('### Finland');
      logLine('> Finland becomes actively pro-Axis.');
      _state.setPieceLocation(Piece.armyFinnish, Location.regionFinland);
      _state.setPoliticalEventOccurred(PoliticalEvent.finland);
    }
  }

  void politicalEventGandhi() {
    if (_state.politicalEventCount(PoliticalEvent.gandhi) == 0) {
      logLine('### Gandhi');
      logLine('> Gandhi leads Indian resistance.');
      _state.setPieceLocation(Piece.indiaGandhi, Location.regionIndia);
      _state.setPoliticalEventOccurred(PoliticalEvent.gandhi);
    }
  }

  void politicalEventGuadalcanal() {
    if (_state.politicalEventCount(PoliticalEvent.guadalcanal) == 0) {
      logLine('### Guadalcanal');
      logLine('> Siege of Guadalcanal commences.');
      _state.setPieceLocation(Piece.siegeGuadalcanal, Location.frontSouthPacific);
      _state.setPoliticalEventOccurred(PoliticalEvent.guadalcanal);
    }
  }

  void politicalEventImphal() {
    if (_state.politicalEventCount(PoliticalEvent.imphal) == 0) {
      logLine('### Imphal');
      logLine('> Siege of Imphal commences.');
      _state.setPieceLocation(Piece.siegeImphal, Location.frontSoutheastAsia);
      _state.setPoliticalEventOccurred(PoliticalEvent.imphal);
    }
  }

  void politicalEventIraq() {
    int count = _state.politicalEventCount(PoliticalEvent.iraq);
    if (count == 0) {
      if (_state.pieceLocation(Piece.armyIraqi) == Location.trayProAxisMinors) {
        logLine('### Iraq');
        logLine('> Iraq joins the Axis.');
        _state.setPieceLocation(Piece.armyIraqi, Location.regionNearEast);
      }
      _state.setPoliticalEventOccurred(PoliticalEvent.iraq);
    } else if (count == 1) {
      if (_state.pieceLocation(Piece.armyIraqi) == Location.regionNearEast) {
        logLine('### Iraq');
        logLine('> Iraqi army strengthened by German advisors.');
        _state.setPieceLocation(Piece.armyGermanIraq, Location.regionNearEast);
        _state.setPoliticalEventOccurred(PoliticalEvent.iraq);
      }
    }
  }

  void politicalEventItaly() {
    if (_state.politicalEventCount(PoliticalEvent.italy) == 0) {
      if (_state.frontNeutral(Location.frontMed)) {
        logLine('### Italy');
        italyJoinsTheAxis();
      }
      _state.setPoliticalEventOccurred(PoliticalEvent.italy);
    }
  }

  void politicalEventMadagascar() {
    if (_state.politicalEventCount(PoliticalEvent.madagascar) == 0) {
      logLine('### Madagascar');
      logLine('> Japan establishes bases in Vichy Madagascar.');
      _state.setPieceLocation(Piece.armyJapaneseMadag, Location.regionFrenchMadagascar);
      _state.setPoliticalEventOccurred(PoliticalEvent.madagascar);
    }
  }

  void politicalEventQuislings() {
    _state.setPoliticalEventOccurred(PoliticalEvent.quislings);
  }

  void politicalEventRomanianCoup() {
    final location = _state.pieceLocation(Piece.armyRomanian);
    if (location != Location.flipped && location != Location.frontEastern) {
      if (_state.airSuperiority && _state.piecesInLocationCount(PieceType.proAxisArmy, Location.frontEastern) <= 2) {
        logLine('### Romanian Coup');
        logLine('> Ani-fascist coup knocks Romania out of the war.');
        logLine('> USSTAF is formed.');
        _state.setPieceLocation(Piece.airBaseUsstaf, Location.boxAlliedAirBases);
        _state.setPieceLocation(Piece.armyHungarian, _state.pieceLocation(Piece.armyGermanSouth));
        _state.setPoliticalEventOccurred(PoliticalEvent.romanianCoup);
      }
    }
  }

  void politicalEventSarinGas() {
    if (!_state.frontActive(Location.frontWestern) && !_state.frontActive(Location.frontEastern)) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Sarin Gas');
      _state.setPoliticalEventOccurred(PoliticalEvent.sarinGas);
      _subStep = 1;
    }
    while (true) {
      if (checkChoice(Choice.cancel)) {
        clearChoices();
      }
      final selectedCities = selectedPieces();
      if (selectedCities.length < 2 && _state.piecesInLocationCount(PieceType.alliedCity, Location.boxCitiesHighMorale) > selectedCities.length) {
        setPrompt('Select two High Morale Allied Cities');
        for (final city in _state.piecesInLocation(PieceType.alliedCity, Location.boxCitiesHighMorale)) {
          if (!selectedCities.contains(city)) {
            pieceChoosable(city);
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      clearChoices();
      for (final city in selectedCities) {
        cityToLowMorale(city);
      }
    }
  }

  void politicalEventSinkiang() {
    if (_state.pieceLocation(Piece.sinkiangUssr) == Location.regionSinkiang) {
      logLine('### Sinkiang');
      logLine('> Pro-Japan factions take power in Sinkiang');
      _state.setPieceLocation(Piece.armySinkiang, Location.regionSinkiang);
      _state.setPoliticalEventOccurred(PoliticalEvent.sinkiang);
    }
  }

  void politicalEventStalingrad() {
    if (_state.politicalEventCount(PoliticalEvent.stalingrad) == 0) {
      logLine('### Stalingrad');
      logLine('> Siege of Stalingrad commences.');
      _state.setPieceLocation(Piece.siegeStalingrad, Location.frontEastern);
      _state.setPoliticalEventOccurred(PoliticalEvent.stalingrad);
    }
  }

  void politicalEventSyria() {
    if (_state.politicalEventCount(PoliticalEvent.syria) == 0) {
      if (_state.pieceLocation(Piece.armyVichySyria) == Location.regionNearEast) {
        logLine('### Syria');
        logLine('> Vichy Syria joins the Axis.');
        _state.setPieceLocation(Piece.armyGermanSyria, Location.regionNearEast);
      }
      _state.setPoliticalEventOccurred(PoliticalEvent.syria);
    }
  }

  void politicalEventTito() {
    if (_state.pieceLocation(Piece.armyTito) == Location.boxTito) {
      logLine('### Tito');
      logLine('> Tito’s partisans activate in the Balkans.');
      _state.setPieceLocation(Piece.armyTito, Location.regionBalkans);
      _state.setPoliticalEventOccurred(PoliticalEvent.tito);
    }
  }

  void politicalEventTorch() {
    if (_state.politicalEventCount(PoliticalEvent.torch) == 0) {
      if (_state.pieceLocation(Piece.armyGermanAfrikaKorps) == Location.reservesMed) {
        logLine('### Torch');
        if (!_state.franceHasFallen) {
          logLine('> France has not fallen, UN Victory!');
          throw GameOverException(GameResult.unVictory);
        }
        final army = _state.pieceLocation(Piece.armyVichyAlger) == Location.flipped ? Piece.armyGermanArnim : Piece.armyVichyAlger;
        logLine('> ${army.desc} deploys to French North Africa.');
        _state.setPieceLocation(army, Location.regionFrenchNorthAfrica);
        _state.setPoliticalEventOccurred(PoliticalEvent.torch);
      }
    }
  }

  void politicalEventTypeXxiUboats() {
    if (_state.politicalEventCount(PoliticalEvent.typeXxiUboats) == 0) {
      if (_state.frontActive(Location.frontWestern)) {
        logLine('### Type XXI U-Boats');
        logLine('> Existing ASW technology is ineffective.');
        if (_state.pieceLocation(Piece.asw) != Location.flipped) {
          _state.setPieceLocation(Piece.asw, Location.discarded);
        } else {
          _state.setPieceLocation(Piece.aswEnigma, Location.discarded);
        }
      }
      _state.setPoliticalEventOccurred(PoliticalEvent.typeXxiUboats);
    }
  }

  void politicalEventV1BuzzBombs() {
    if (_state.piecesInLocationCount(PieceType.proAxisArmy, Location.frontWestern) >= 2) {
      logLine('### V-1 Buzz Bombs');
      logLine('> Threat preoccupies British Prime Minister.');
      _state.churchillInUse(2);
      _state.setPoliticalEventOccurred(PoliticalEvent.v1BuzzBombs);
    }
  }

  void politicalEventV2Rockets() {
    if (!_state.frontActive(Location.frontWestern)) {
      return;
    }
    if (_subStep == 0) {
      logLine('### V-2 Rockets');
      _state.setPoliticalEventOccurred(PoliticalEvent.v2Rockets);
      _subStep = 1;
    }
    if (choicesEmpty()) {
      setPrompt('Select a High Morale Allied City');
      for (final city in _state.piecesInLocation(PieceType.alliedCity, Location.boxCitiesHighMorale)) {
        pieceChoosable(city);
      }
      throw PlayerChoiceException();
    }
    final city = selectedPiece()!;
    clearChoices();
    cityToLowMorale(city);
    if (_state.piecesInLocationCount(PieceType.alliedCity, Location.boxCitiesHighMorale) == 0) {
      logLine('> Allied morale collapses');
      throw GameOverException(GameResult.lostAlliedMoraleCollapse);
    }
  }

  void politicalEventVlasov() {
    if (_state.politicalEventCount(PoliticalEvent.vlasov) == 0) {
      logLine('### Vlasov');
      logLine('> Stalin preoccupied with defection.');
      var location = _state.pieceLocation(Piece.leaderStalin);
      if (location == Location.flipped) {
        location = _state.pieceLocation(Piece.leaderStalinUsed);
      }
      if (location == Location.boxAlliedLeadershipRussian) {
        _state.setPieceLocation(Piece.leaderStalin, _state.futureCalendarBox(2));
      } else if (location.isType(LocationType.calendar)) {
        int delay = location.index - _state.futureCalendarBox(0).index;
        _state.setPieceLocation(Piece.leaderStalin, _state.futureCalendarBox(delay + 2));
      }
      final armies = _state.piecesInLocation(PieceType.proAxisArmy, Location.reservesWestern);
      final weakestArmies = _state.weakestArmies(armies);
      if (weakestArmies.isNotEmpty) {
        final army = weakestArmies[0];
        logLine('> ${army.desc} removed from Western Front Reserves.');
        _state.setPieceLocation(weakestArmies[0], Location.traySiege);
      }
      _state.setPoliticalEventOccurred(PoliticalEvent.vlasov);
    }
  }

  void politicalEventWarsawUprising() {
    if (_state.politicalEventCount(PoliticalEvent.warsawUprising) == 0) {
      logLine('### Warsaw Uprising');
      if (_state.cannonMeat > 0) {
        adjustCannonMeat(-_state.cannonMeat);
        logLine('> Warsaw Uprising Army forms on the Eastern Front.');
        _state.setPieceLocation(Piece.armyWarsaw, Location.frontEastern);
      }
      _state.setPoliticalEventOccurred(PoliticalEvent.warsawUprising);
    }
  }

  void freeUnAttackOnFront(Location front, int  operationKutuzovModifier) {
    if (_state.pieceInLocation(PieceType.siegeTightens, front) != null) {
      return;
    }
    if (choicesEmpty()) {
      final siege = _state.pieceInLocation(PieceType.siegeInitial, front);
      final panzer = _state.pieceInLocation(PieceType.panzer, front);
      final armies = _state.piecesInLocation(PieceType.proAxisNonCapitalArmy, front);
      if (siege != null) {
        pieceChoosable(siege);
      } else if (panzer != null) {
        pieceChoosable(panzer);
      } else {
        for (final army in armies) {
          pieceChoosable(army);
        }
      }
      if (choosablePieceCount == 0) {
        return;
      }
      throw PlayerChoiceException();
    }
    final piece = selectedPiece()!;
    resolveUNAttackOnPiece(piece, false, false, false, operationKutuzovModifier);
  }

  void axisPowersAttackFront(Location front) {
    final phaseState = _phaseState as PhaseStateAxisPowersAttack;
    int  frontIndex = front.index - LocationType.front.firstIndex;
    if (_subStep == 0) {
      if (phaseState.frontAttacksRemaining[frontIndex] == 0) {
        if (_state.frontActive(front)) {
          logLine('### No Axis Attacks on ${front.desc}');
          final siegeTightens = _state.pieceInLocation(PieceType.siegeTightens, front);
          if (siegeTightens != null) {
            logLine('> UN win the ${siegeTightens.desc}');
            _state.setPieceLocation(siegeTightens, Location.discarded);
            if (siegeTightens == Piece.siegeTightensNormandy) {
              _state.setPieceLocation(Piece.strategyWestern, Location.frontWestern);
            } else if (siegeTightens == Piece.siegeStalingrad) {
              _state.setPieceLocation(Piece.strategyEastern, Location.frontEastern);
            } else if (siegeTightens == Piece.siegeTightensTunis) {
              _state.setPieceLocation(Piece.strategyMed, Location.frontMed);
              for (final army in _state.piecesInLocation(PieceType.proAxisArmy, Location.frontMed)) {
                _state.setPieceLocation(_state.pieceFlipSide(army)!, Location.frontMed);
              }
              for (final army in _state.piecesInLocation(PieceType.proAxisArmy, Location.reservesMed)) {
                _state.setPieceLocation(_state.pieceFlipSide(army)!, Location.reservesMed);
              }
              if (_state.pieceLocation(Piece.southAfricaNeutral) == Location.regionSouthAfrica) {
                _state.setPieceLocation(Piece.southAfricaUN, Location.regionSouthAfrica);
              }
            } else if (siegeTightens == Piece.siegeImphal) {
              _state.setPieceLocation(Piece.strategySoutheastAsia, Location.frontSoutheastAsia);
            } else if (siegeTightens == Piece.siegeGuadalcanal) {
              _state.setPieceLocation(Piece.strategySouthPacific, Location.frontSouthPacific);
            }
          }
        }
      } else if (phaseState.frontAttacksRemaining[frontIndex] == 1) {
        logLine('### 1 Axis Attack on ${front.desc}');
      } else {
        logLine('### ${phaseState.frontAttacksRemaining[frontIndex]} Axis Attacks on ${front.desc}');
      }
      _subStep = 1;
    }
    if (phaseState.frontAttacksRemaining[frontIndex] == 0) {
      return;
    }
    if (!_state.frontActive(front)) {
      return;
    }
    final reservesBox = _state.frontReservesBox(front);
    if (selectedPieces().length == 1) {
      final piece = selectedPiece()!;
      if (piece.isType(PieceType.city)) {
        cityToLowMorale(piece);
        if (_state.piecesInLocationCount(PieceType.alliedCity, Location.boxCitiesHighMorale) == 0) {
          logLine('> Allied morale collapses');
          throw GameOverException(GameResult.lostAlliedMoraleCollapse);
        }
        if (_state.piecesInLocationCount(PieceType.sovietCity, Location.boxCitiesHighMorale) == 0) {
          logLine('> Soviet morale collapses');
          throw GameOverException(GameResult.lostSovietMoraleCollapse);
        }
        final blitz = _state.pieceInLocation(PieceType.blitz, front);
        if (blitz != null) {
          _state.setPieceLocation(blitz, reservesBox);
        }
        clearChoices();
      }
    }
    while (true) {
      final armyCount = _state.piecesInLocationCount(PieceType.proAxisArmy, front);
      final reserveArmyCount = _state.piecesInLocationCount(PieceType.proAxisArmy, reservesBox);
      final propArmy = _state.frontPropArmy(front);
      final siege = _state.pieceInLocation(PieceType.siegeInitial, front);
      final siegeTightens = _state.pieceInLocation(PieceType.siegeTightens, front);
      final partisansBox = _state.frontPartisansBox(front);
      final partisans = _state.pieceInLocation(PieceType.partisansAndMalta, partisansBox);
      if (_subStep == 1) {
        if (phaseState.frontAttacksRemaining[frontIndex] == 0) {
          return;
        }
        // Prop armies
        if (propArmy != null) {
          int cost = _state.propArmyCost(propArmy);
          if (choicesEmpty()) {
            logLine('> Axis Attack ${propArmy.desc}.');
            setPrompt('Support ${propArmy.desc}?');
            choiceChoosable(Choice.yes, _state.dollars >= cost);
            choiceChoosable(Choice.no, true);
            throw PlayerChoiceException();
          }
          PieceType? cityType;
          if (checkChoice(Choice.yes)) {
            logLine('> ${propArmy.desc} is Supported.');
            if (propArmy == Piece.armyWarsaw) {
              cityType = PieceType.sovietCity;
            }
            adjustDollars(-cost);
            int strength = _state.propArmyStrength(propArmy);
            int die = rollD6();
            if (die > strength) {
              logLine('> Axis Attack successful, ${propArmy.desc} eliminated.');
              propArmyEliminated(propArmy);
            } else {
              logLine('> Axis Attack unsuccessful.');
            }
          } else {
            logLine('> ${propArmy.desc} receives no Support.');
            if (propArmy == Piece.armyWarsaw) {
              cityType = PieceType.alliedCity;
            }
            logLine('> Axis Attack successful, ${propArmy.desc} eliminated.');
            propArmyEliminated(propArmy);
          }
          phaseState.frontAttacksRemaining[frontIndex] -= 1;
          clearChoices();
          if (cityType != null) {
            setPrompt('Select High Morale City');
            for (final city in _state.piecesInLocation(cityType, Location.boxCitiesHighMorale)) {
              pieceChoosable(city);
            }
            throw PlayerChoiceException();
          }
        } else if (siegeTightens != null) {
          if (phaseState.frontAttacksRemaining[frontIndex] == 1) {
            logLine('> The ${siegeTightens.desc} continues.');
            phaseState.frontAttacksRemaining[frontIndex] -= 1;
            return;
          }
          logLine('> Axis regain the upper hand in the ${siegeTightens.desc}.');
          _state.setPieceLocation(_state.pieceFlipSide(siegeTightens)!, front);
          phaseState.frontAttacksRemaining[frontIndex] -= 2;
        } else if (siege == null && partisans == Piece.maltaBesieged) {
          logLine('> Malta falls to an Italo-Germain air-naval assault!');
          _state.setPieceLocation(Piece.maltaBesieged, Location.discarded);
          final location = _state.pieceLocation(Piece.armyVichyAlger);
          if (location != Location.trayFrench && location != Location.discarded) {
            logLine('> ${Piece.armyGermanArnim.desc} deploys to ${location.desc}.');
          }
          _state.setPieceLocation(Piece.armyGermanArnim, location);
          phaseState.frontAttacksRemaining[frontIndex] -= 1;
        } else {
          if (siege == null && partisans != null) {
            if (partisans == Piece.malta) {
              final outcomes = [(false, false), (false, false)];
              if (choicesEmpty()) {
                logLine('> Malta');
                final rolls = roll2D6();
                final dice = [rolls.$1, rolls.$2];
                for (int i = 0; i < 2; ++i) {
                  int die = dice[i];
                  bool attack = die < 5;
                  bool malta = die > armyCount;
                  outcomes[i] = (attack, malta);
                }
                if (outcomes[1] != outcomes[0]) {
                  for (final outcome in outcomes) {
                    if (!outcome.$1) {
                      if (!outcome.$2) {
                        choiceChoosable(Choice.axisFailureMaltaSafe, true);
                      } else {
                        choiceChoosable(Choice.axisFailureMaltaBesieged, true);
                      }
                    } else {
                      if (!outcome.$2) {
                        choiceChoosable(Choice.axisSuccessMaltaSafe, true);
                      } else {
                        choiceChoosable(Choice.axisSuccessMaltaBesieged, true);
                      }
                    }
                  }
                  throw PlayerChoiceException();
                }
              }
              var outcome = outcomes[0];
              if (checkChoice(Choice.axisFailureMaltaSafe)) {
                outcome = (false, false);
              } else if (checkChoice(Choice.axisFailureMaltaBesieged)) {
                outcome = (false, true);
              } else if (checkChoice(Choice.axisSuccessMaltaSafe)) {
                outcome = (true, false);
              } else if (checkChoice(Choice.axisSuccessMaltaBesieged)) {
                outcome = (true, true);
              }
              clearChoices();
              bool attackSucceeds = outcome.$1;
              bool maltaBesieged = outcome.$2;
              if (!attackSucceeds) {
                logLine('> Malta prevents deployment.');
              }
              if (maltaBesieged) {
                logLine('> Malta Besieged.');
                _state.setPieceLocation(Piece.maltaBesieged, partisansBox);
              }
              if (!attackSucceeds) {
                phaseState.frontAttacksRemaining[frontIndex] -= 1;
                continue;
              }
            } else {
              logLine('> Partisans');
              int die = rollD6();
              if (die >= 5) {
                logLine('> Partisans prevent deployment.');
              }
              if (die > armyCount) {
                logLine('> Partisans eliminated.');
                _state.setPieceLocation(partisans, Location.boxPartisansPool);
              }
              if (die >= 5) {
                phaseState.frontAttacksRemaining[frontIndex] -= 1;
                continue;
              }
            }
          }
          if (armyCount < 5) {
            if (reserveArmyCount == 0) {
              logLine('> No Axis Army in Reserve.');
              return;
            }
            if (choicesEmpty()) {
              setPrompt('Select Army to deploy.');
              final armies = _state.piecesInLocation(PieceType.proAxisArmy, reservesBox);
              final strongest = _state.strongestArmies(armies);
              for (final army in strongest) {
                pieceChoosable(army);
              }
              throw PlayerChoiceException();
            }
            final army = selectedPiece()!;
            clearChoices();
            logLine('> ${army.desc} Attacks on ${front.desc}');
            _state.setPieceLocation(army, front);
            phaseState.frontAttacksRemaining[frontIndex] -= 1;
          } else {
            logLine('> Blitz!');
            final blitz = _state.pieceInLocation(PieceType.blitz, reservesBox)!;
            _state.setPieceLocation(blitz, front);
            final rolls = roll2D6();
            int dice = rolls.$3;
            if (dice > _state.piecesInLocationCount(PieceType.city, Location.boxCitiesHighMorale)) {
              logLine('> Defeat succeeds.');
              setPrompt('Select High Morale City');
              for (final city in _state.piecesInLocation(PieceType.alliedUsaCity, Location.boxCitiesHighMorale)) {
                pieceChoosable(city);
              }
              if (choosableLocationCount == 0) {
                throw GameOverException(GameResult.lostUsaMoraleCollapse);
              }
              _subStep = 2;
              throw PlayerChoiceException();
            } else {
              logLine('> Defeat fizzles.');
              _subStep = 2;
            }
          }
        }
      }
      if (_subStep == 2) {
        final blitz = _state.pieceInLocation(PieceType.blitz, front)!;
        _state.setPieceLocation(blitz, reservesBox);
        final panzer = _state.pieceInLocation(PieceType.panzer, front);
        if (panzer != null) {
          logLine('> ${panzer.desc} is withdrawn to ${reservesBox.desc}.');
          _state.setPieceLocation(panzer, reservesBox);
        }
        setPrompt('Select High Morale City');
        final cityType = front == Location.frontEastern ? PieceType.sovietCity : PieceType.alliedCity;
        for (final city in _state.piecesInLocation(cityType, Location.boxCitiesHighMorale)) {
          pieceChoosable(city);
        }
        _subStep = 3;
        throw PlayerChoiceException();
      }
      if (_subStep == 3) {
        if (siegeTightens == null) {
         freeUnAttackOnFront(front, 0);
        }
        _subStep = 1;
      }
    }
  }

  void operationKutuzovAttack(int modifier) {
    if (!_state.frontActive(Location.frontEastern)) {
      return;
    }
    if (_state.pieceLocation(Piece.militaryEvent) != Location.eventOperationKutuzov) {
      return;
    }
    if (_state.pieceLocation(Piece.siegeTightensStalingrad) == Location.frontEastern) {
      return;
    }
    final siege = _state.pieceInLocation(PieceType.siegeInitial, Location.frontEastern);
    final panzer = _state.pieceInLocation(PieceType.panzer, Location.frontEastern);
    int armyCount = _state.piecesInLocationCount(PieceType.proAxisArmy, Location.frontEastern);
    if (siege == null && panzer == null && armyCount < 2) {
      return;
    }
    if (modifier == 2) {
      logLine('### Operation Kutuzov');
    }
    freeUnAttackOnFront(Location.frontEastern, modifier);
  }

  void attackRaider(Piece raider) {
    logLine('### Hunt ${raider.desc}');
    adjustDollars(-1);
    int die = rollD6();
    if (die > _state.raiderStrength(raider)) {
      sinkUboat(raider);
    } else {
      logLine('> ${raider.desc} survives.');
    }
  }

  void arrestGandhi() {
    logLine('### Gandhi');
    adjustDollars(-1);
    int die = rollD6();
    if (die >= 4) {
      logLine('> Gandhi is arrested.');
      _state.setPieceLocation(Piece.indiaGandhi, Location.discarded);
    } else {
      logLine('> Gandhi remains at large.');
    }
  }

  void achieveAirSuperiority() {
    final phaseState = _phaseState as PhaseStateUnitedNationsAttack;
    logLine('### Air Superiority');
    final armyCount = _state.piecesInLocationCount(PieceType.proAxisArmy, Location.frontWestern);
    adjustDollars(-armyCount);
    logLine('> Air Superiority is achieved.');
    _state.setPieceLocation(Piece.airBaseUsaaf, Location.boxAlliedAirBases);
    logLine('> Operation Overlord commences.');
    _state.setPieceLocation(Piece.siegeNormandy, Location.frontWestern);
    final vlasovArmy = _state.pieceInLocation(PieceType.proAxisArmy, Location.traySiege);
    if (vlasovArmy != null) {
      _state.setPieceLocation(vlasovArmy, Location.frontWestern);
    }
    for (final army in _state.piecesInLocation(PieceType.proAxisArmy, Location.frontWestern)) {
      _state.setPieceLocation(_state.pieceFlipSide(army)!, Location.frontWestern);
    }
    for (final army in _state.piecesInLocation(PieceType.proAxisArmy, Location.reservesWestern)) {
      _state.setPieceLocation(_state.pieceFlipSide(army)!, Location.reservesWestern);
    }
    phaseState.normandyLandings = true;
  }

  // Sequence of Play

  void turnBegin() {
    logLine('# ${_state.turnName(_state.currentTurn + 1)}');
    _state.clearCurrentPoliticalEvents();
  }

  void chitDrawPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Chit Draw Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Chit Draw Phase');
  }

  void chitDrawPhaseDraw() {
    logLine('### Chit Draw');
    int currentTurn = _state.currentTurn + 1;
    Piece? turnChit;
    final box = _state.calendarBox(currentTurn);
    if (currentTurn >= 4 && _state.franceHasFallen && _state.pieceLocation(Piece.turnChitBarbarossa) == Location.trayTurn) {
      turnChit = Piece.turnChit4;
      operationBarbarossa();
    } else if (_state.pieceLocation(Piece.turnChit4).isType(LocationType.calendar) && _state.pieceLocation(Piece.turnChitPearlHarbor) == Location.trayTurn) {
      turnChit = Piece.turnChit5;
      pearlHarbor();
    } else {
      final turnChits = _state.piecesInLocation(PieceType.turnChit, Location.cupTurn);
      turnChit = randPiece(turnChits)!;
      logLine('> ${turnChit.desc} is drawn.');
    }
    _state.setPieceLocation(turnChit, box);
    if (currentTurn == 3) {
      for (final turnChit in _state.piecesInLocation(PieceType.randomTurnChit, Location.trayTurn)) {
        _state.setPieceLocation(turnChit, Location.cupTurn);
      }
    }
  }

  void turnStartPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Turn Start Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Turn Start Phase');
    _phaseState = PhaseStateTurnStart();
  }

  void turnStartPhaseDeployUnits() {
    final pieces = _state.piecesInLocation(PieceType.all, _state.calendarBox(_state.currentTurn));
    if (pieces.length == 1) { // Just turn marker
      return;
    }
    logLine('### Calendar Deployments');
    for (final piece in pieces) {
      if (piece.isType(PieceType.uboats)) {
        logLine('> ${piece.desc} deploys.');
        _state.setPieceLocation(piece, Location.boxGermanUboats);
      }
      if (piece.isType(PieceType.leader)) {
        logLine('> ${piece.desc} is available.');
        _state.setPieceLocation(piece, _state.leadershipBox(piece));
      }
      if (piece.isType(PieceType.spruance) || piece == Piece.usMarines) {
        logLine('> ${piece.desc} deploys.');
        _state.setPieceLocation(piece, Location.boxHawaii);
      }
      if (piece.isType(PieceType.carrier)) {
        logLine('> ${piece.desc} deploys.');
        _state.setPieceLocation(piece, Location.cupCarrier);
      }
      if (piece.isType(PieceType.convoy) || piece.isType(PieceType.asw)) {
        logLine('> ${piece.desc} deploys.');
        _state.setPieceLocation(piece, Location.boxAvailableConvoys);
      }
    }
  }

  void turnStartPhaseCalendarEvent0() {
    final eventHandlers = {
      2: calendarEventVictoryAtSea2,
      3: calendarEventUsElection,
      4: calendarEventVictoryAtSea4,
      5: calendarEventVictoryAtSea5,
      8: calendarEventVictoryAtSea8,
      12: calendarEventVictoryAtSea12,
      16: calendarEventVictoryAtSea16,
      17: calendarEventVictoryAtSea17,
      26: calendarEventBritishElection,
    };
    final eventHandler = eventHandlers[_state.currentTurn];
    if (eventHandler != null) {
      eventHandler();
    }
  }

  void turnStartPhaseCalendarEvent1() {
    final eventHandlers = {
      3: calendarEventVictoryAtSea3,
    };
    final eventHandler = eventHandlers[_state.currentTurn];
    if (eventHandler != null) {
      eventHandler();
    }
  }

  void turnStartPhaseManhattanProjectEvent() {
    final turnChit = _state.currentTurnChit;
    if (![Piece.turnChit10, Piece.turnChit12, Piece.turnChit17, Piece.turnChit22].contains(turnChit)) {
      return;
    }
    chitEventManhattanProject();
  }

  void turnStartPhaseSouthAfricaEvent() {
    if (_state.currentTurnChit != Piece.turnChit1) {
      return;
    }
    chitEventSouthAfrica();
  }

  void turnStartPhaseCaucasusCrisisEvent() {
    final turnChit = _state.currentTurnChit;
    if (![Piece.turnChit5, Piece.turnChit11, Piece.turnChit14, Piece.turnChit15, Piece.turnChit16].contains(turnChit)) {
      return;
    }
    chitEventCaucasusCrisis();
  }

  void turnStartPhaseStalinsReturn() {
    final turnChit = _state.currentTurnChit;
    if (_state.turnChitDiskColor(turnChit) == TurnChitDisk.yellow) {
      return;
    }
    final location = _state.pieceLocation(Piece.leaderStalinUsed);
    if (location != Location.flipped) {
      logLine('> Stalin returns to work.');
      _state.setPieceLocation(Piece.leaderStalin, location);
    }
  }

  void turnStartPhaseEnd() {
    _phaseState = null;
  }

  void eveningTelegraphPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Evening Telegraph Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Evening Telegraph Phase');
    _phaseState = PhaseStateEveningTelegraph();
  }

  void eveningTelegraphPhaseRoll() {
    final phaseState = _phaseState as PhaseStateEveningTelegraph;
    logLine('> Evening Telegraph');
    int die = rollD6();
    int total = _state.currentTurn + die;
    logLine('> Result: $total');
    phaseState.result = total;
  }

  void eveningTelegraphPhaseMilitaryEvent() {
    final phaseState = _phaseState as PhaseStateEveningTelegraph;
    if (phaseState.result < 7) {
      return;
    }
    int index = (phaseState.result - 7) ~/ 2;
    final militaryEventBox = Location.values[LocationType.event.firstIndex + index];
    _state.setPieceLocation(Piece.militaryEvent, militaryEventBox);
    const eventNames = [
      'Wavell',
      'Galland',
      'Yamashita',
      'Rommel',
      'Zhukov',
      'Manstein',
      'Operation Kutuzov',
      'MacArthur',
      'Operation Ichi-Go',
      'Patton',
      'Wacht am Rhein',
      'Slim',
      '4th War Area',
      'Banzai Attacks!',
    ];
    logLine('> ${eventNames[index]} in effect.');
  }

  void eveningTelegraphPhasePoliticalEvent0() {
    final phaseState = _phaseState as PhaseStateEveningTelegraph;
    final eventHandlers = [
      politicalEventFinland,
      politicalEventFinland,
      politicalEventQuislings,
      politicalEventSinkiang,
      politicalEventItaly,
      politicalEventAreaBombing,
      politicalEventFinland,
      politicalEventStalingrad,
      politicalEventStalingrad,
      politicalEventStalingrad,
      politicalEventTorch,
      politicalEventImphal,
      politicalEventImphal,
      politicalEventImphal,
      politicalEventTypeXxiUboats,
      politicalEventSarinGas,
      politicalEventSinkiang,
    ];
    int index = (phaseState.result - 1) ~/ 2;
    final eventHandler = eventHandlers[index];
    eventHandler();
  }

  void eveningTelegraphPhasePoliticalEvent1() {
    final phaseState = _phaseState as PhaseStateEveningTelegraph;
    final eventHandlers = [
      null,
      null,
      null,
      null,
      politicalEventIraq,
      null,
      politicalEventAreaBombing,
      politicalEventGuadalcanal,
      politicalEventGuadalcanal,
      politicalEventGuadalcanal,
      politicalEventVlasov,
      politicalEventTorch,
      politicalEventWarsawUprising,
      politicalEventWarsawUprising,
      politicalEventAungSan,
      politicalEventTito,
      null,
    ];
    int index = (phaseState.result - 1) ~/ 2;
    final eventHandler = eventHandlers[index];
    if (eventHandler == null) {
      return;
    }
    eventHandler();
  }

  void eveningTelegraphPhasePoliticalEvent2() {
    final phaseState = _phaseState as PhaseStateEveningTelegraph;
    final eventHandlers = [
      null,
      null,
      null,
      null,
      politicalEventSyria,
      null,
      politicalEventCongo,
      politicalEventAreaBombing,
      politicalEventGandhi,
      politicalEventTorch,
      null,
      politicalEventTito,
      politicalEventRomanianCoup,
      politicalEventRomanianCoup,
      politicalEventSinkiang,
      null,
      null,
    ];
    int index = (phaseState.result - 1) ~/ 2;
    final eventHandler = eventHandlers[index];
    if (eventHandler == null) {
      return;
    }
    eventHandler();
  }

  void eveningTelegraphPhasePoliticalEvent3() {
    final phaseState = _phaseState as PhaseStateEveningTelegraph;
    final eventHandlers = [
      null,
      null,
      null,
      null,
      null,
      null,
      politicalEventGandhi,
      politicalEventGandhi,
      null,
      politicalEventArgentina,
      null,
      null,
      politicalEventV1BuzzBombs,
      politicalEventV2Rockets,
      null,
      null,
      null,
    ];
    int index = (phaseState.result - 1) ~/ 2;
    final eventHandler = eventHandlers[index];
    if (eventHandler == null) {
      return;
    }
    eventHandler();
  }

  void eveningTelegraphPhasePoliticalEvent4() {
    final phaseState = _phaseState as PhaseStateEveningTelegraph;
    final eventHandlers = [
      null,
      null,
      null,
      null,
      null,
      null,
      politicalEventMadagascar,
      politicalEventTorch,
      null,
      politicalEventSinkiang,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    ];
    int index = (phaseState.result - 1) ~/ 2;
    final eventHandler = eventHandlers[index];
    if (eventHandler == null) {
      return;
    }
    eventHandler();
  }

  void eveningTelegraphPhaseAxisCommandos() {
    Piece? commando;
    Location? front;
    if (_subStep == 0) {
      final phaseState = _phaseState as PhaseStateEveningTelegraph;
      const commandoInfo = {
        4: (Piece.commandoSkorzeny, Location.frontEastern),
        5: (Piece.commandoTeishinShudan, Location.frontSoutheastAsia),
        8: (Piece.commandoTeishinShudan, Location.frontSouthPacific),
        9: (Piece.commandoSkorzeny, Location.frontMed),
        11: (Piece.commandoTeishinShudan, Location.frontChina),
        13: (Piece.commandoSkorzeny, Location.frontWestern),
      };
      int index = (phaseState.result - 1) ~/ 2;
      final info = commandoInfo[index];
      if (info == null) {
        return;
      }
      commando = info.$1;
      front = info.$2;
      if (_state.pieceLocation(Piece.commandoSkorzeny) != Location.trayBlitz && _state.pieceLocation(commando) != Location.boxAxisCommandos) {
        return;
      }
      logLine('### ${commando.desc}');
      final armyCount = _state.piecesInLocationCount(PieceType.proAxisArmy, front);
      if (!_state.frontActive(front) || armyCount == 1) {
        logLine('> No armies on ${front.desc}');
        final otherCommando = _state.pieceFlipSide(commando)!;
        _state.setPieceLocation(otherCommando, Location.boxAxisCommandos);
        logLine('> ${otherCommando.desc} ready for action.');
        return;
      }
      _subStep = 1;
    }
    if (choicesEmpty()) {
      setPrompt('Select Army for Commandos to assist.');
      final armies = _state.piecesInLocation(PieceType.proAxisNonCapitalArmy, front!);
      for (final army in armies) {
        pieceChoosable(army);
      }
      throw PlayerChoiceException();
    }
    final army = selectedPiece()!;
    logLine('> ${commando!.desc} assists ${army.desc}');
    _state.setCommandoAssistedArmy(army);
    _state.setPieceLocation(commando, front!);
    clearChoices();
  }

  void eveningTelegraphPhaseEnd() {
    _phaseState = null;
  }

  void axisPowersAttackPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Axis Powers Attack Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Axis Powers Attack Phase');
    _phaseState = PhaseStateAxisPowersAttack();
  }

  void axisPowersAttackPhaseDetermineCounts() {
    final phaseState = _phaseState as PhaseStateAxisPowersAttack;
    int siegeCount = 0;
    final frontSieges = [false, false, false, false, false, false];
    final frontTurnChitAttackCounts = [0, 0, 0, 0, 0, 0];
    final frontRandomAttackCounts = [0, 0, 0, 0, 0, 0];
    final frontQuislingAttackCounts = [0, 0, 0, 0, 0, 0];
    for (final front in LocationType.front.locations) {
      int index = front.index - LocationType.front.firstIndex;
      frontTurnChitAttackCounts[index] = _state.turnChitFrontAttackCount(_state.currentTurnChit, front);
      if (_state.piecesInLocationCount(PieceType.siege, front) > 0) {
        frontSieges[index] = true;
        siegeCount += 1;
      }
    }
    if (_state.politicalEventCurrent(PoliticalEvent.quislings)) {
      bool western = !_state.franceHasFallen;
      bool eastern = _state.currentTurnChit == _state.pieceFlipSide(Piece.turnChitBarbarossa)!;
      if (western || eastern) {
        logLine('### Quislings');
        if (western) {
          logLine('> Collaborators assist Axis Attacks on the Western Front.');
          frontQuislingAttackCounts[0] += 1;
        }
        if (eastern) {
          logLine('> Collaborators assist Axis Attacks on the Eastern Front.');
          frontQuislingAttackCounts[1] += 1;
        }
      }
    }
    final randomAttackCount = _state.turnChitRandomAttackCount(_state.currentTurnChit);
    if (randomAttackCount > 0) {
      logLine('### Random Axis Attacks');
      for (int i = 0; i < randomAttackCount; ++i) {
        if (siegeCount > 0) {
          for (final front in LocationType.front.locations) {
            int index = front.index - LocationType.front.firstIndex;
            if (frontSieges[index]) {
              logLine('> Random Axis Attack targets ${front.desc}.');
              frontRandomAttackCounts[index] += 1;
            }
          }
        } else {
          int die = rollD6();
          int index = die - 1;
          final front = Location.values[LocationType.front.firstIndex + index];
          if (_state.frontActive(front)) {
            logLine('> Random Axis Attack targets ${front.desc}.');
            frontRandomAttackCounts[index] += 1;
          } else {
            logLine('> ${front.desc} Inactive, no Axis Attack takes place.');
          }
        }
      }
    }
    for (final front in LocationType.front.locations) {
      int index = front.index - LocationType.front.firstIndex;
      phaseState.frontAttacksRemaining[index] = frontTurnChitAttackCounts[index] + frontRandomAttackCounts[index] + frontQuislingAttackCounts[index];
    }
    if (_state.frontNeutral(Location.frontEastern)) {
      phaseState.frontAttacksRemaining[0] += phaseState.frontAttacksRemaining[1];
      phaseState.frontAttacksRemaining[1] = 0;
    }
    for (final front in LocationType.front.locations) {
      int index = front.index - LocationType.front.firstIndex;
      if (!_state.frontActive(front)) {
        phaseState.frontAttacksRemaining[index] = 0;
      }
    }
    if (_state.germanEconomyCollapsed) {
      phaseState.frontAttacksRemaining[0] = 0;
      phaseState.frontAttacksRemaining[1] = 0;
      phaseState.frontAttacksRemaining[2] = 0;
    }
    if (_state.japaneseEcomomyCollapsed) {
      phaseState.frontAttacksRemaining[3] = 0;
      phaseState.frontAttacksRemaining[4] = 0;
      phaseState.frontAttacksRemaining[5] = 0;
    }
  }

  void axisPowersAttackPhaseWestern() {
    axisPowersAttackFront(Location.frontWestern);
  }

  void axisPowersAttackPhaseEastern() {
    axisPowersAttackFront(Location.frontEastern);
  }

  void axisPowersAttackPhaseMed() {
    axisPowersAttackFront(Location.frontMed);
  }

  void axisPowersAttackPhaseChina() {
    return axisPowersAttackFront(Location.frontChina);
  }

  void axisPowersAttackPhaseSoutheastAsia() {
    axisPowersAttackFront(Location.frontSoutheastAsia);
  }

  void axisPowersAttackPhaseSouthPacific() {
    axisPowersAttackFront(Location.frontSouthPacific);
  }

  void axisPowersAttackPhaseDeployPanzers() {
    if (_state.frontActive(Location.frontEastern)) {
      if (_state.currentTurnRussianWinter) {
        final panzer = _state.pieceInLocation(PieceType.panzer, Location.frontEastern);
        if (panzer != null) {
          logLine('> ${panzer.desc} is withdrawn due to the Russian Winter.');
          _state.setPieceLocation(panzer, Location.reservesEastern);
        }
      } else {
        for (final panzer in PieceType.panzer.pieces) {
          final location = _state.pieceLocation(panzer);
          if (location == Location.trayGermanGround || location == Location.reservesEastern) {
            logLine('> ${panzer.desc} deploys to ${Location.frontEastern.desc}.');
            _state.setPieceLocation(panzer, Location.frontEastern);
            break;
          }
        }
      }
    }
    if (_state.pieceLocation(Piece.panzerPza) == Location.discarded) {
      // Removed this turn
      _state.setPieceLocation(Piece.panzerPza, Location.reservesEastern);
    }
  }

  void axisPowersAttackPhaseCheckBurmaRoadStatus() {
    if (_state.pieceLocation(Piece.burmaRoadOpen) == Location.regionBurmaRoad) {
      if (_state.piecesInLocationCount(PieceType.proAxisArmy, Location.frontSoutheastAsia) >= 3) {
        logLine('> Burma Road is Closed.');
        _state.setPieceLocation(Piece.burmaRoadClosed, Location.regionBurmaRoad);
      }
    }
  }

  void axisPowersAttackPhaseEnd() {
    _phaseState = null;
  }

  void economicWarfarePhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Economic Warfare Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Economic Warfare Phase');
    _phaseState = PhaseStateEconomicWarfare();
  }

  void economicWarfarePhasePlaceConvoys() {
    if (_subStep == 0) {
      logLine('### Place Convoys and ASW');
      _subStep = 1;
    }
    while (true) {
      if (choicesEmpty()) {
        setPrompt('Select Convoy or ASW to place.');
        Piece? aswPiece;
        Location? aswLocation;
        {
          final location = _state.pieceLocation(Piece.asw);
          if (location == Location.boxAvailableConvoys || location.isType(LocationType.seaZone)) {
            aswPiece = Piece.asw;
            aswLocation = location;
          }
        }
        int convoyAvailableCount = 0;
        int aswSeaZoneCount = 0;
        for (final convoy in PieceType.convoy.pieces) {
          final location = _state.pieceLocation(convoy);
          if (location == Location.boxAvailableConvoys) {
            pieceChoosable(convoy);
            convoyAvailableCount += 1;
          } else if (location.isType(LocationType.seaZone)) {
            if (location != aswLocation) {
              pieceChoosable(convoy);
              if (_state.seaZoneAsw(location)) {
                aswSeaZoneCount += 1;
              }
            }
          }
        }
        if (aswPiece != null) {
          if (aswSeaZoneCount > 0 || aswLocation != Location.boxAvailableConvoys) {
            pieceChoosable(aswPiece);
          }
        }
        choiceChoosable(Choice.next, convoyAvailableCount == 0 && (aswLocation != Location.boxAvailableConvoys || aswSeaZoneCount == 0));
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.next)) {
        clearChoices();
        return;
      }
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      final piece = selectedPiece()!;
      final location = selectedLocation();
      if (location == null) {
        if (piece.isType(PieceType.convoy)) {
          setPrompt('Select Convoy Sea Zone');
        } else {
          setPrompt('Select ASW Sea Zone');
        }
        final pieceLocation = _state.pieceLocation(piece);
        if (pieceLocation != Location.boxAvailableConvoys) {
          locationChoosable(Location.boxAvailableConvoys);
        }
        for (final seaZone in LocationType.seaZone.locations) {
          if (seaZone != pieceLocation) {
            bool ok = false;
            int convoyCount = _state.piecesInLocationCount(PieceType.convoy, seaZone);
            if (piece.isType(PieceType.convoy)) {
              ok = convoyCount == 0;
              if (_state.southAfricaNeutral && [Location.seaZone2B, Location.seaZone2C].contains(seaZone)) {
                if (piece != Piece.convoyFrench) {
                  ok = false;
                }
              }
            } else {
              ok = _state.seaZoneAsw(seaZone) && convoyCount > 0;
            }
            if (ok) {
              locationChoosable(seaZone);
            }
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      logLine('> ${piece.desc} placed in ${location.desc}.');
      _state.setPieceLocation(piece, location);
      clearChoices();
    }
  }

  void economicWarfarePhasePlaceUboats() {
    logLine('### Place U-Boats and Raiders');
    final pieces = _state.piecesInLocation(PieceType.raiderOrUboat, Location.boxGermanUboats);
    final strongest = <Piece>[];
    while (pieces.isNotEmpty && strongest.length <= 4) {
      final raider = _state.strongestRaider(pieces)!;
      strongest.add(raider);
      pieces.remove(raider);
    }
    const tables = [
      [
        [Location.seaZone2B],
        [Location.seaZone3],
        [Location.seaZone3],
        [Location.seaZone3],
        [Location.seaZone4],
        [Location.seaZone4],
        [Location.seaZone4],
        [Location.seaZone3],
        [Location.seaZone4],
        [Location.seaZone2A],
        [Location.seaZone2C],
      ],
      [
        [Location.seaZone2A, Location.seaZone2B],
        [Location.seaZone4, Location.seaZone2B],
        [Location.seaZone3, Location.seaZone2B],
        [Location.seaZone4, Location.seaZone3],
        [Location.seaZone4, Location.seaZone2A],
        [Location.seaZone4, Location.seaZone4],
        [Location.seaZone3, Location.seaZone3],
        [Location.seaZone4, Location.seaZone2C],
        [Location.seaZone3, Location.seaZone2C],
        [Location.seaZone2A, Location.seaZone2A],
        [Location.seaZone3, Location.seaZone2B],
      ],
      [
        [Location.seaZone3, Location.seaZone2A, Location.seaZone2B],
        [Location.seaZone4, Location.seaZone2A, Location.seaZone2B],
        [Location.seaZone3, Location.seaZone2A, Location.seaZone2B],
        [Location.seaZone3, Location.seaZone2A, Location.seaZone2C],
        [Location.seaZone3, Location.seaZone2B, Location.seaZone2C],
        [Location.seaZone4, Location.seaZone4, Location.seaZone2C],
        [Location.seaZone3, Location.seaZone3, Location.seaZone4],
        [Location.seaZone4, Location.seaZone4, Location.seaZone2B],
        [Location.seaZone2A, Location.seaZone2A, Location.seaZone4],
        [Location.seaZone3, Location.seaZone3, Location.seaZone4],
        [Location.seaZone2A, Location.seaZone2A, Location.seaZone4],
      ],
      [
        [Location.seaZone3, Location.seaZone2B, Location.seaZone1A, Location.seaZone1B],
        [Location.seaZone3, Location.seaZone2A, Location.seaZone2B, Location.seaZone1A],
        [Location.seaZone3, Location.seaZone2A, Location.seaZone2B, Location.seaZone1B],
        [Location.seaZone3, Location.seaZone2B, Location.seaZone2C, Location.seaZone1A],
        [Location.seaZone2A, Location.seaZone2A, Location.seaZone4, Location.seaZone2C],
        [Location.seaZone4, Location.seaZone4, Location.seaZone2A, Location.seaZone2C],
        [Location.seaZone3, Location.seaZone3, Location.seaZone4, Location.seaZone2C],
        [Location.seaZone3, Location.seaZone3, Location.seaZone4, Location.seaZone2B],
        [Location.seaZone4, Location.seaZone4, Location.seaZone3, Location.seaZone2B],
        [Location.seaZone4, Location.seaZone4, Location.seaZone2B, Location.seaZone1B],
        [Location.seaZone2A, Location.seaZone2A, Location.seaZone2B, Location.seaZone1B],
      ],
    ];
    final rolls = roll2D6();
    int dice = rolls.$3;
    final seaZones = tables[strongest.length - 1][dice - 2];
    for (int i = 0; i < strongest.length; ++i) {
      final piece = strongest[i];
      final seaZone = mostValuableSeaZone(seaZones)!;
      logLine('> ${piece.desc} patrols ${seaZone.desc}.');
      _state.setPieceLocation(piece, seaZone);
      seaZones.remove(seaZone);
    }
  }

  void economicWarfarePhaseMoveAswEnigma() {
    if (_state.pieceLocation(Piece.aswEnigma) != Location.boxAvailableConvoys) {
      return;
    }
    final seaZones = <Location>[];
    for (final seaZone in LocationType.seaZone.locations) {
      if (_state.seaZoneAsw(seaZone) && _state.piecesInLocationCount(PieceType.convoy, seaZone) >= 1) {
        if (_state.piecesInLocationCount(PieceType.raiderOrUboat, seaZone) >= 1) {
          seaZones.add(seaZone);
        }
      }
    }
    if (seaZones.isEmpty) {
      return;
    }
    if (_subStep == 0) {
      logLine('### ASW Attacks');
      _subStep = 1;
    }
    if (choicesEmpty()) {
      setPrompt('Select ASW Sea Zone');
      for (final seaZone in seaZones) {
        locationChoosable(seaZone);
      }
      throw PlayerChoiceException();
    }
    final seaZone = selectedLocation()!;
    logLine('> ${Piece.aswEnigma.desc} placed in ${seaZone.desc}.');
    _state.setPieceLocation(Piece.aswEnigma, seaZone);
    clearChoices();
  }

  void economicWarfarePhaseAswAttacks() {
    Piece? asw;
    var uboats = <Piece>[];
    for (final piece in PieceType.asw.pieces) {
      final location = _state.pieceLocation(piece);
      if (location.isType(LocationType.seaZone)) {
        asw = piece;
        uboats = _state.piecesInLocation(PieceType.raiderOrUboat, location);
        break;
      }
    }
    if (uboats.isEmpty) {
      return;
    }
    if (_subStep == 0) {
      if (asw == Piece.asw) {
        logLine('### ASW Attacks');
      }
      _subStep = 1;
    }
    if (choicesEmpty()) {
      setPrompt('Select U-Boat or Raider to Attack with ASW');
      for (final piece in uboats) {
        pieceChoosable(piece);
      }
      throw PlayerChoiceException();
    }
    final piece = selectedPiece()!;
    int die = rollD6();
    if (die >= 4) {
      sinkUboat(piece);
    } else {
      logLine('> {Attack fails.}');
    }
    clearChoices();
  }

  void economicWarfarePhaseEconomicHaul() {
    if (_subStep == 0) {
      logLine('### Economic Haul');
      _subStep = 1;
    }
    int haul = 0;
    bool britishNavalAssistancePossible = false;
    for (final seaZone in LocationType.seaZone.locations) {
      if (_state.piecesInLocationCount(PieceType.convoy, seaZone) >= 1 && _state.piecesInLocationCount(PieceType.raiderOrUboat, seaZone) == 0) {
        haul += _state.seaZoneValue(seaZone);
        if (seaZone == Location.seaZone2B && !_state.frontNeutral(Location.frontSouthPacific)) {
          britishNavalAssistancePossible = true;
        }
      }
    }
    logLine('> Haul: \$$haul');
    if (haul == 0) {
      return;
    }
    if (britishNavalAssistancePossible) {
      if (choicesEmpty()) {
        setPrompt('Provide British Naval Assistance to the US Navy?');
        choiceChoosable(Choice.dollars2, true);
        choiceChoosable(Choice.dollars1, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.dollars2)) {
        adjustNavalActions(2);
        haul -= 2;
      } else if (checkChoice(Choice.dollars1)) {
        adjustNavalActions(1);
        haul -= 1;
      }
      clearChoices();
    }
    if (haul > 0) {
      adjustDollars(haul);
    }
  }

  void economicWarfarePhaseDetermineConvoyUboatConflicts() {
    final phaseState = _phaseState as PhaseStateEconomicWarfare;
    for (final seaZone in LocationType.seaZone.locations) {
      if (_state.piecesInLocationCount(PieceType.convoy, seaZone) == 1) {
        int escortedConvoyCount = _state.piecesInLocationCount(PieceType.escortedConvoy, seaZone);
        int uboatCount = _state.piecesInLocationCount(PieceType.raiderOrUboat, seaZone);
        if (uboatCount == 2 || (uboatCount == 1 && escortedConvoyCount == 1)) {
          phaseState.outstandingConflictSeaZones.add(seaZone);
        }
      }
    }
  }

  void economicWarfarePhaseResolveConvoyUboatConflict() {
    final phaseState = _phaseState as PhaseStateEconomicWarfare;
    if (_subStep == 0) {
      if (phaseState.outstandingConflictSeaZones.isEmpty) {
        return;
      }
      logLine('### U-Boats/Raider vs. Convoy Conflicts');
    }
    while (phaseState.outstandingConflictSeaZones.isNotEmpty) {
      if (choicesEmpty()) {
        setPrompt('Select U-Boats/Raider to resolve conflict for.');
        for (final seaZone in phaseState.outstandingConflictSeaZones) {
          for (final piece in _state.piecesInLocation(PieceType.raiderOrUboat, seaZone)) {
            pieceChoosable(piece);
          }
        }
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      final piece = selectedPiece()!;
      final seaZone = _state.pieceLocation(piece);
      logLine('> ${seaZone.desc}');
      final convoy = _state.pieceInLocation(PieceType.convoy, seaZone)!;
      final uboats = _state.piecesInLocation(PieceType.raiderOrUboat, seaZone);
      final aswZone = _state.seaZoneAsw(seaZone);
      if (convoy.isType(PieceType.escortedConvoy) && uboats.length == 1) {
        if (aswZone) {
          int die = rollD6();
          if (die >= 5) {
            sinkUboat(piece);
          } else {
            logLine('> ${piece.desc} survives.');
          }
        }
      } else if (uboats.length == 2 && !convoy.isType(PieceType.escortedConvoy)) {
        logLine('> ${convoy.desc} is sunk.');
        _state.setPieceLocation(convoy, Location.boxUSEastCoast);
      } else {
        if (checkChoice(Choice.scatter)) {
          logLine('> ${convoy.desc} Scatters.');
          _state.setPieceLocation(convoy, Location.boxUSEastCoast);
        } else if (checkChoice(Choice.fight)) {
          int die = rollD6();
          if (die >= 5) {
            sinkUboat(piece);
          } else {
            logLine('> ${piece.desc} survives.');
          }
          logLine('> ${convoy.desc} is sunk.');
          _state.setPieceLocation(_state.pieceFlipSide(convoy)!, Location.boxUSEastCoast);
        } else {
          setPrompt('Scatter or Fight?');
          choiceChoosable(Choice.scatter, true);
          choiceChoosable(Choice.fight, aswZone);
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
      }
      clearChoices();
      phaseState.outstandingConflictSeaZones.remove(seaZone);
    }
  }

  void economicWarfarePhasePresidentialBonus() {
    if (!_state.frontNeutral(Location.frontSouthPacific)) {
      logLine('### Presidential Bonus');
      adjustDollars(_state.usPresident == Piece.leaderRoosevelt ? 2 : 1);
    }
  }

  void economicWarfarePhaseAlliedStrategicBombing() {
    final phaseState = _phaseState as PhaseStateEconomicWarfare;
    if (_subStep == 0) {
      phaseState.outstandingEuropeBombing = _state.europeBomber != null;
      phaseState.outstandingPacificBombing = _state.pacificBomber != null;
      if (!phaseState.outstandingEuropeBombing && !phaseState.outstandingPacificBombing) {
        return;
      }
      logLine('### Allied Strategic Bombing');
      _subStep = 1;
    }
    while (phaseState.outstandingEuropeBombing || phaseState.outstandingPacificBombing) {
      if (choicesEmpty()) {
        setPrompt('Select Army/Panzer to Bomb.');
        final fronts = <Location>[];
        if (phaseState.outstandingEuropeBombing) {
          fronts.add(Location.frontWestern);
          fronts.add(Location.frontEastern);
          fronts.add(Location.frontMed);
        }
        if (phaseState.outstandingPacificBombing) {
          fronts.add(Location.frontChina);
          fronts.add(Location.frontSoutheastAsia);
          if (_state.pieceLocation(Piece.airBaseTinian) == Location.frontSouthPacific) {
            fronts.add(Location.frontSouthPacific);
          }
        }
        for (final front in fronts) {
          final armies = _state.piecesInLocation(PieceType.proAxisNonCapitalArmy, front);
          for (final army in armies) {
            pieceChoosable(army);
          }
          final panzer = _state.pieceInLocation(PieceType.panzer, front);
          if (panzer != null) {
            pieceChoosable(panzer);
          }
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.next)) {
        clearChoices();
        return;
      }
      final piece = selectedPiece()!;
      final front = _state.pieceLocation(piece);
      final bomber = _state.frontBomber(front)!;
      logLine('> Bomb ${piece.desc}.');
      int die = rollD6();
      int minDie = _state.bomberMinDie(bomber);
      if (die >= minDie) {
        if (piece == Piece.panzerTiger) {
          logLine('> Bombing is successful, ${piece.desc} is eliminated.');
          _state.setPieceLocation(piece, Location.discarded);
        } else {
          logLine('> Bombing is successful, ${piece.desc} is withdrawn to reserves.');
          _state.setPieceLocation(piece, _state.frontReservesBox(front));
        }
      } else {
        logLine('> Bombing is unsuccessful.');
      }
      if ([Location.frontWestern, Location.frontEastern, Location.frontMed].contains(front)) {
        phaseState.outstandingEuropeBombing = false;
      } else {
        phaseState.outstandingPacificBombing = false;
      }
      clearChoices();
    }
  }

  void economicWarfarePhaseUseChurchill() {
    if (!_state.churchillAvailable) {
      return;
    }
    if (choicesEmpty()) {
      setPrompt('Select target of Churchill Raid.');
      for (final army in PieceType.proAxisOrVichyNonCapitalArmy.pieces) {
        final location = _state.pieceLocation(army);
        if (location.isType(LocationType.front) || location.isType(LocationType.region)) {
          pieceChoosable(army);

        }
      }
      for (final panzer in PieceType.panzer.pieces) {
        if (_state.pieceLocation(panzer).isType(LocationType.front)) {
          pieceChoosable(panzer);
        }
      }
      for (final siege in PieceType.siegeInitial.pieces) {
        if (_state.pieceLocation(siege).isType(LocationType.front)) {
          pieceChoosable(siege);
        }
      }
      for (final uboat in PieceType.uboats.pieces) {
        final location = _state.pieceLocation(uboat);
        if (location.isType(LocationType.seaZone) || location == Location.boxGermanUboats) {
          pieceChoosable(uboat);
        }
      }
      for (final raider in PieceType.raider.pieces) {
        if (_state.pieceLocation(raider).isType(LocationType.seaZone)) {
          pieceChoosable(raider);
        }
      }
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.next)) {
      clearChoices();
      return;
    }
    final piece = selectedPiece()!;
    if (piece.isType(PieceType.proAxisOrVichyNonCapitalArmy) || piece.isType(PieceType.panzer) || piece.isType(PieceType.siegeInitial)) {
      logLine('### British Commando Raid');
      logLine('> British Commandos conduct Raid on ${piece.desc}.');
    } else if (piece.isType(PieceType.uboats)) {
      logLine('### Raid on St. Nazaire');
    } else if (piece.isType(PieceType.raider)) {
      logLine('### Sink the ${piece.desc}!');
    }
    int die = rollD6();
    if (die >= 2 && die <= 5) {
      if (piece.isType(PieceType.raider)) {
        sinkUboat(piece);
      } else if (piece.isType(PieceType.uboats)) {
        logLine('> Raid is successful, U-Boat operations are hindered.');
        _state.setPieceLocation(piece, _state.futureCalendarBox(die));
      } else {
        logLine('> Raid on ${piece.desc} is successful.');
        final location = _state.pieceLocation(piece);
        if (location.isType(LocationType.front)) {
          if (piece.isType(PieceType.siegeInitial)) {
            logLine('> ${piece.desc} Tightens.');
            _state.setPieceLocation(_state.pieceFlipSide(piece)!, location);
          } else if (piece == Piece.panzerTiger) {
            logLine('> ${piece.desc} is eliminated.');
            _state.setPieceLocation(piece, Location.discarded);
          } else {
            final reservesBox = _state.frontReservesBox(location);
            logLine('> ${piece.desc} is withdrawn to ${reservesBox.desc}.');
            _state.setPieceLocation(piece, reservesBox);
          }
        } else {
          regionalArmyEliminated(piece);
        }
      }
    } else if (die == 1) {
      if (piece.isType(PieceType.raider)) {
        logLine('> Attempt to sink the ${piece.desc} is unsuccessful.');
      } else {
        logLine('> Raid is unsuccessful.');
      }
    } else if (die == 6) {
      if (piece.isType(PieceType.raider)) {
        logLine('> Attempt to sink the ${piece.desc} is a fiasco.');
      } else {
        logLine('> Raid is a fiasco.');
      }
    }
    _state.churchillInUse(die);
    clearChoices();
  }

  void economicWarfarePhaseUseStalin() {
    if (!_state.stalinAvailable) {
      return;
    }
    if (choicesEmpty()) {
      setPrompt('Select target of Stalin Mission.');
      final cannonMeatLocation = _state.pieceLocation(Piece.cannonMeat);
      if (cannonMeatLocation.isType(LocationType.omnibus) && _state.cannonMeat < 12) {
        choiceChoosable(Choice.raiseCannonMeat, true);
      }
      for (final city in _state.piecesInLocation(PieceType.sovietFaceUpCity, Location.boxCitiesLowMorale)) {
        pieceChoosable(city);
      }
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.next)) {
      clearChoices();
      return;
    }
    logLine('### Using Stalin');
    if (checkChoice(Choice.raiseCannonMeat)) {
      logLine('> Military Comissariats');
      adjustCannonMeat(1);
    } else {
      logLine('> Great Patriotic War');
      final city = selectedPiece()!;
      final flippedCity = _state.pieceFlipSide(city)!;
      logLine('> ${flippedCity.desc} replaces ${city.desc}.');
      _state.setPieceLocation(flippedCity, Location.boxCitiesHighMorale);
    }
    _state.stalinUsed();
    clearChoices();
  }

  void economicWarfarePhaseLendLease() {
    final phaseState = _phaseState as PhaseStateEconomicWarfare;
    if (_state.piecesInLocationCount(PieceType.lendLease, Location.boxUSEastCoast) == 0) {
      return;
    }
    if (_subStep == 0) {
      if (choicesEmpty()) {
        setPrompt('Select Lend Lease to Enact.');
        final pieces = _state.piecesInLocation(PieceType.lendLease, Location.boxUSEastCoast);
        for (final piece in pieces) {
          bool ok = true;
          if (piece == Piece.lendLeaseAidToRussia && (_state.frontNeutral(Location.frontSouthPacific) || _state.currentTurnChit == _state.pieceFlipSide(Piece.turnChitPearlHarbor))) {
            ok = false;
          }
          if (piece == Piece.lendLeaseDestroyerDeal) {
            if (_state.piecesInLocationCount(PieceType.carrier, Location.cupCarrier) == 0) {
              ok = false;
            }
          }
          if (ok) {
            pieceChoosable(piece);
          }
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.next)) {
        clearChoices();
        return;
      }
      logLine('### Lend Lease');
      final lendLease = selectedPiece()!;
      switch (lendLease) {
      case Piece.lendLeaseJeepsTrucks:
        logLine('> Enact Jeeps & Trucks');
        adjustDollars(3);
        _state.setPieceLocation(Piece.lendLeaseAidToRussia, Location.boxUSEastCoast);
      case Piece.lendLeaseAidToRussia:
        logLine('> Enact Aid to Russia');
        adjustCannonMeat(4);
        _state.setPieceLocation(lendLease, Location.discarded);
      case Piece.lendLeaseLibertyShips:
        logLine('> Enact Liberty Ships');
        _state.setPieceLocation(Piece.convoyAmerican0, Location.boxUSEastCoast);
        _state.setPieceLocation(Piece.convoyAmerican1, Location.boxUSEastCoast);
        _state.setPieceLocation(lendLease, Location.discarded);
      case Piece.lendLeaseDestroyerDeal:
        logLine('> Enact Destroyer Deal');
        final carriers = _state.piecesInLocation(PieceType.carrier, Location.cupCarrier);
        final carrier = randPiece(carriers)!;
        logLine('> ${carrier.desc} redeployed away from the Pacific.');
        phaseState.destroyerDealDelay = max(_state.carrierStrength(carrier), 1);
        _state.setPieceLocation(carrier, Location.trayUnNaval);
        _state.setPieceLocation(lendLease, Location.discarded);
      default:
      }
      if (_state.currentTurn < 3) {
        logLine('> Lend-Lease deal is reduces Roosevelt’s chances of re-election.');
        _state.setPieceLocation(Piece.leaderRoosevelt, Location.values[_state.pieceLocation(Piece.leaderRoosevelt).index - 1]);
      }
      clearChoices();
      if (lendLease != Piece.lendLeaseDestroyerDeal) {
        return;
      }
      _subStep = 1;
    }
    if (choicesEmpty()) {
      setPrompt('Select U-Boat to sink.');
      for (final piece in PieceType.uboats.pieces) {
        if (_state.pieceLocation(piece).isType(LocationType.seaZone)) {
          pieceChoosable(piece);
        }
      }
      if (choosablePieceCount == 0) {
        return;
      }
      throw PlayerChoiceException();
    }
    final piece = selectedPiece()!;
    logLine('> ${piece.desc} sunk.');
    _state.setPieceLocation(piece, _state.futureCalendarBox(phaseState.destroyerDealDelay));
  }

  void economicWarfarePhaseEnd() {
    _phaseState = null;
  }

  void unitedNationsAttackPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to UN Attack Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## UN Attack Phase');
    _phaseState = PhaseStateUnitedNationsAttack();
  }

  void unitedNationsAttackPhaseMilitaryEvent() {
    final militaryEventBox = _state.pieceLocation(Piece.militaryEvent);
    if (militaryEventBox == Location.eventOperationKutuzov) {
      if (_state.pieceLocation(Piece.panzerTiger) == Location.flipped) {
        logLine('### Operation Kutuzov');
        logLine('> ${Piece.panzerTiger.desc} available on ${Location.frontEastern.desc}.');
        var location = _state.pieceLocation(Piece.panzerPza);
        if (location == Location.discarded) {
          location = Location.reservesEastern;
        }
        _state.setPieceLocation(Piece.panzerTiger, location);
      }
    } else if (militaryEventBox == Location.eventWachtAmRhein) {
      final tigerLocation = _state.pieceLocation(Piece.panzerTiger);
      if (_state.frontHasStrategy(Location.frontWestern) && tigerLocation != Location.discarded && tigerLocation != Location.frontWestern) {
        logLine('### Wacht am Rhein');
        logLine('> ${Piece.panzerTiger.desc} deploys to ${Location.frontWestern.desc}.');
        _state.setPieceLocation(Piece.panzerTiger, Location.frontWestern);
      }
    }
  }

  void unitedNationsAttackPhaseOperationKutuzov0() {
    operationKutuzovAttack(2);
  }

  void unitedNationsAttackPhaseOperationKutuzov1() {
    operationKutuzovAttack(1);
  }

  void unitedNationsAttackPhaseActions() {
    final phaseState = _phaseState as PhaseStateUnitedNationsAttack;
    while (true) {
      if (_subStep == 0) {
        if (_state.burmaRoadClosed && _state.piecesInLocationCount(PieceType.proAxisArmy, Location.frontSoutheastAsia) <= 2) {
          logLine('> Burma Road Open');
          _state.setPieceLocation(Piece.burmaRoadOpen, Location.regionBurmaRoad);
        }
        if (_state.frontHasStrategy(Location.frontSouthPacific) && _state.airSuperiority) {
          final location = _state.pieceLocation(Piece.armyJapanese31);
          if (location != Location.frontSouthPacific && location != Location.flipped) {
            logLine('### Marianas Campaign');
            logLine('> Tinian Air Base opens.');
            _state.setPieceLocation(Piece.airBaseTinian, Location.frontSouthPacific);
          }
        }
        if (choicesEmpty()) {
          setPrompt('Select Tile to Attack');
          for (final front in LocationType.front.locations) {
            if (_state.frontActive(front) && _state.piecesInLocationCount(PieceType.siegeTightens, front) == 0) {
              if (attackOnLocationAffordable(front) && (front != Location.frontWestern || !phaseState.normandyLandings)) {
                final siege = _state.pieceInLocation(PieceType.siegeInitial, front);
                final panzer = _state.pieceInLocation(PieceType.panzer, front);
                final armies = _state.piecesInLocation(PieceType.proAxisNonCapitalArmy, front);
                final capital = _state.pieceInLocation(PieceType.capital, front)!;
                if (siege != null) {
                  pieceChoosable(siege);
                } else if (panzer != null) {
                  pieceChoosable(panzer);
                } else if (armies.isNotEmpty) {
                  for (final army in armies) {
                    pieceChoosable(army);
                  }
                } else {
                  if (downfallOnFrontAffordable(front)) {
                    pieceChoosable(capital);
                  }
                }
              }
            }
          }
          for (final region in LocationType.region.locations) {
            if (attackOnLocationAffordable(region)) {
              final armies = _state.piecesInLocation(PieceType.proAxisOrVichyNonCapitalArmy, region);
              for (final army in armies) {
                pieceChoosable(army);
              }
            }
          }
          if (_state.pieceLocation(Piece.airBaseBritish) == Location.boxAlliedAirBases && _state.currentTurn >= 19) {
            final airplaneCount = _state.piecesInLocationCount(PieceType.proAxisArmy, Location.frontWestern);
            if (_state.dollars >= airplaneCount) {
              pieceChoosable(Piece.airBaseBritish);
            }
          }
          if (_state.dollars >= 1) {
            for (final raider in PieceType.raider.pieces) {
              if (_state.pieceLocation(raider).isType(LocationType.seaZone)) {
                pieceChoosable(raider);
              }
            }
            if (_state.pieceLocation(Piece.indiaGandhi) == Location.regionIndia) {
              pieceChoosable(Piece.indiaGandhi);
            }
          }
          choiceChoosable(Choice.next, true);
          throw PlayerChoiceException();
        }
        if (checkChoice(Choice.next)) {
          clearChoices();
          return;
        }
        final piece = selectedPiece()!;
        if (piece == Piece.indiaGandhi) {
          arrestGandhi();
          clearChoices();
        } else if (piece == Piece.airBaseBritish) {
          achieveAirSuperiority();
          clearChoices();
        } else if (piece.isType(PieceType.raider)) {
          attackRaider(piece);
          clearChoices();
        } else {
          phaseState.attackedPiece = piece;
          clearChoices();
          _subStep = 1;
        }
      }
      if (_subStep == 1) {
        final piece = phaseState.attackedPiece!;
        if (piece.isType(PieceType.capital)) {
          attackCapital(piece);
        } else {
          attackGroundPiece(piece);
        }
        phaseState.attackedPiece = null;
        _subStep = 0;
      }
    }
  }

  void unitedNationsAttackPhaseEnd() {
    _phaseState = null;
  }

  void pacificNavalPhaseBegin() {
    if (_state.frontNeutral(Location.frontSouthPacific)) {
      return;
    }
    if (_state.pieceLocation(Piece.armyDutch) == Location.regionDutchEastIndies) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Pacific Naval Phase.');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Pacific Naval Phase');
    _phaseState = PhaseStatePacificNaval();
  }

  void pacificNavalPhaseJapaneseNavalMissionRoll() {
    if (_phaseState == null) {
      return;
    }
    final phaseState = _phaseState as PhaseStatePacificNaval;
    logLine('### Japanese Naval Missions');
    int die = rollD6();
    if (_state.pieceLocation(Piece.submarineCampaign) == Location.boxHawaii) {
      if (die < _state.turnYear(_state.currentTurn) % 10) {
        logLine('> Submarine Campaign thwarts Japanese naval activity.');
        phaseState.japaneseNavalMissionRoll = 0;
        return;
      }
    }
    phaseState.japaneseNavalMissionRoll = die;
  }

  void pacificNavalPhaseJapaneseNavyMissionMidway() {
    if (_phaseState == null) {
      return;
    }
    final phaseState = _phaseState as PhaseStatePacificNaval;
    if ([2, 3, 5].contains(phaseState.japaneseNavalMissionRoll)) {
      japaneseNavalMission(Location.seaMidway, false);
    }
  }

  void pacificNavalPhaseJapaneseNavyMissionPhilippine() {
    if (_phaseState == null) {
      return;
    }
    final phaseState = _phaseState as PhaseStatePacificNaval;
    if ([4, 5, 6].contains(phaseState.japaneseNavalMissionRoll)) {
      japaneseNavalMission(Location.seaPhilippine, false);
    }
  }

  void pacificNavalPhaseJapaneseNavyMissionCoral() {
    if (_phaseState == null) {
      return;
    }
    final phaseState = _phaseState as PhaseStatePacificNaval;
    if ([1, 3, 4].contains(phaseState.japaneseNavalMissionRoll)) {
      japaneseNavalMission(Location.seaCoral, false);
    }
  }

  void pacificNavalPhaseJapaneseEventYamamoto() {
    if (_phaseState == null) {
      return;
    }
    if (_state.pieceLocation(Piece.shipYamamoto) != Location.trayJapaneseNavy) {
      return;
    }
    final phaseState = _phaseState as PhaseStatePacificNaval;
    if (_subStep == 0) {
      int midwayCount = _state.piecesInLocationCount(PieceType.ship, Location.seaMidway);
      int phillipineCount = _state.piecesInLocationCount(PieceType.ship, Location.seaPhilippine);
      int coralCount = _state.piecesInLocationCount(PieceType.ship, Location.seaCoral);
      Location? sea;
      if (midwayCount >= phillipineCount && midwayCount >= coralCount) {
        sea = Location.seaMidway;
      } else if (phillipineCount >= coralCount) {
        sea = Location.seaPhilippine;
      } else {
        sea = Location.seaCoral;
      }
      phaseState.yamamotoSea = sea;
      _subStep = 1;
    }
    if (_subStep == 1) {
      japaneseNavalMission(phaseState.yamamotoSea!, true);
    }
  }

  void pacificNavalPhaseJapaneseEventAleutians() {
    if (_phaseState == null) {
      return;
    }
    if (_state.pieceLocation(Piece.armyJapanese32) == Location.reservesSouthPacific) {
      if (_state.politicalEventCount(PoliticalEvent.aleutiansCampaign) == 0) {
        logLine('> Japan launches the Aleutians Campaign.');
        _state.setPieceLocation(Piece.operationAL, Location.boxAttuAndKiska);
        _state.politicalEventCurrent(PoliticalEvent.aleutiansCampaign);
      }
    } else if (_state.pieceLocation(Piece.operationAL) == Location.boxAttuAndKiska) {
      logLine('> Japan withdraws from the Aleutians.');
      _state.setPieceLocation(Piece.armyJapanese32, Location.reservesSouthPacific);
      final carrier1 = randPiece(_state.piecesInLocation(PieceType.carrier, Location.cupCarrier))!;
      _state.setPieceLocation(carrier1, Location.trayUnNaval);
      final carrier2 = randPiece(_state.piecesInLocation(PieceType.carrier, Location.cupCarrier))!;
      _state.setPieceLocation(carrier2, Location.trayUnNaval);
      if (_state.carrierStrength(carrier1) >= _state.carrierStrength(carrier2)) {
        _state.setPieceLocation(carrier1, Location.cupCarrier);
        logLine('> ${carrier2.desc} is damaged.');
      } else {
        _state.setPieceLocation(carrier2, Location.cupCarrier);
        logLine('> ${carrier1.desc} is damaged.');
      }
    }
  }

  void pacificNavalPhaseUSCarriers() {
    if (choicesEmpty()) {
      setPrompt('Draw Carrier?');
      choiceChoosable(Choice.yes, true);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.yes)) {
      logLine('### US Carriers');
      final carrier = randPiece(_state.piecesInLocation(PieceType.carrier, Location.cupCarrier))!;
      int strength = _state.carrierStrength(carrier);
      logLine('> ${carrier.desc} leads a Task Force.');
      adjustNavalActions(strength);
      _state.setPieceLocation(carrier, Location.trayUnNaval);
    }
    clearChoices();
  }

  void pacificNavalPhaseAmericanNavalCombat() {
    while (_state.navalActions > 0 && _state.dollars > 0) {
      final spruance = _state.spruance;
      final spruanceLocation = _state.pieceLocation(spruance);
      if (choicesEmpty()) {
        bool haveSeas = false;
        for (final sea in LocationType.sea.locations) {
          bool hasShips = false;
          for (final ship in _state.piecesInLocation(PieceType.ship, sea)) {
            pieceChoosable(ship);
            hasShips = true;
          }
          if (hasShips) {
            haveSeas = true;
            if (spruanceLocation == Location.boxHawaii) {
              locationChoosable(sea);
            }
          }
        }
        if (spruanceLocation == Location.boxHawaii && haveSeas) {
          setPrompt('Select Japanese Ship to attack, or Sea for Admiral Spruance');
        } else {
          setPrompt('Select Japanese Ship to attack');
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      if (selectedLocation() != null) {
        final sea = selectedLocation()!;
        logLine('> Admiral Spruance takes command of US fleet in ${sea.desc}.');
        _state.setPieceLocation(spruance, sea);
        continue;
      }
      final ship = selectedPiece()!;
      final sea = _state.pieceLocation(ship);
      logLine('> ${ship.desc} is attacked.');
      adjustNavalActions(-1);
      int die = rollD6();
      int modifiers = 0;
      if (spruanceLocation == sea) {
        if (spruance == Piece.spruanceP2) {
          logLine('> Admiral Spruance: +2');
          modifiers += 2;
        } else {
          logLine('> Admiral Spruance: +1');
          modifiers += 1;
        }
      }
      int total = die + modifiers;
      int strength = _state.shipStrength(ship);
      if (total > strength) {
        sinkShip(ship);
      }
      // TODO spruance
    }
  }

  void pacificNavalPhaseEnd() {
    _phaseState = null;
  }

  void turnEndPhaseMilitaryEvent() {
    _state.setPieceLocation(Piece.militaryEvent, Location.trayMarkers);
    // Possibly do or log something for Kutuzov / Tiger ?
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      chitDrawPhaseBegin,
      chitDrawPhaseDraw,
      turnStartPhaseBegin,
      turnStartPhaseDeployUnits,
      turnStartPhaseCalendarEvent0,
      turnStartPhaseCalendarEvent1,
      turnStartPhaseManhattanProjectEvent,
      turnStartPhaseSouthAfricaEvent,
      turnStartPhaseCaucasusCrisisEvent,
      turnStartPhaseStalinsReturn,
      turnStartPhaseEnd,
      eveningTelegraphPhaseBegin,
      eveningTelegraphPhaseRoll,
      eveningTelegraphPhaseMilitaryEvent,
      eveningTelegraphPhasePoliticalEvent0,
      eveningTelegraphPhasePoliticalEvent1,
      eveningTelegraphPhasePoliticalEvent2,
      eveningTelegraphPhasePoliticalEvent3,
      eveningTelegraphPhasePoliticalEvent4,
      eveningTelegraphPhaseAxisCommandos,
      eveningTelegraphPhaseEnd,
      axisPowersAttackPhaseBegin,
      axisPowersAttackPhaseDetermineCounts,
      axisPowersAttackPhaseWestern,
      axisPowersAttackPhaseEastern,
      axisPowersAttackPhaseMed,
      axisPowersAttackPhaseChina,
      axisPowersAttackPhaseSoutheastAsia,
      axisPowersAttackPhaseSouthPacific,
      axisPowersAttackPhaseDeployPanzers,
      axisPowersAttackPhaseCheckBurmaRoadStatus,
      axisPowersAttackPhaseEnd,
      economicWarfarePhaseBegin,
      economicWarfarePhasePlaceConvoys,
      economicWarfarePhasePlaceUboats,
      economicWarfarePhaseMoveAswEnigma,
      economicWarfarePhaseAswAttacks,
      economicWarfarePhaseEconomicHaul,
      economicWarfarePhaseDetermineConvoyUboatConflicts,
      economicWarfarePhaseResolveConvoyUboatConflict,
      economicWarfarePhasePresidentialBonus,
      economicWarfarePhaseAlliedStrategicBombing,
      economicWarfarePhaseUseChurchill,
      economicWarfarePhaseUseStalin,
      economicWarfarePhaseLendLease,
      economicWarfarePhaseEnd,
      unitedNationsAttackPhaseBegin,
      unitedNationsAttackPhaseMilitaryEvent,
      unitedNationsAttackPhaseOperationKutuzov0,
      unitedNationsAttackPhaseOperationKutuzov1,
      unitedNationsAttackPhaseActions,
      unitedNationsAttackPhaseEnd,
      pacificNavalPhaseBegin,
      pacificNavalPhaseJapaneseNavalMissionRoll,
      pacificNavalPhaseJapaneseNavyMissionMidway,
      pacificNavalPhaseJapaneseNavyMissionPhilippine,
      pacificNavalPhaseJapaneseNavyMissionCoral,
      pacificNavalPhaseJapaneseEventYamamoto,
      pacificNavalPhaseJapaneseEventAleutians,
      pacificNavalPhaseUSCarriers,
      pacificNavalPhaseAmericanNavalCombat,
      pacificNavalPhaseEnd,
      turnEndPhaseMilitaryEvent,
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

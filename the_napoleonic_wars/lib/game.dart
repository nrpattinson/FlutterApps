import 'dart:convert';
import 'dart:math';
import 'package:the_napoleonic_wars/db.dart';
import 'package:the_napoleonic_wars/random.dart';

enum Location {
  nationFrance,
  nationGermany,
  nationAustria,
  nationItaly,
  nationSpain,
  greenFrance,
  greenGermany,
  greenAustria,
  greenItaly,
  greenSpain,
  minorBalkans,
  minorCape,
  minorCaucasus,
  minorCorfu,
  minorDenmark,
  minorEgypt,
  minorFinland,
  minorHaiti,
  minorIreland,
  minorMalta,
  minorMysore,
  minorRussia,
  minorSenegal,
  minorSerbia,
  minorSwitzerland,
  minorUsa,
  russianWarFinland,
  russianWarCaucasus,
  russianWarBalkans,
  russianWarCorfu,
  statusAustria,
  statusPrussia,
  statusRussia,
  statusSpain,
  statusSweden,
  lightInfantryBernadotte,
  lightInfantryFrenchDomination,
  lightInfantryFrenchAdvantage,
  lightInfantryNoAdvantage,
  boxLondon,
  boxHighSeas,
  boxFranceReligion,
  boxHotel,
  boxJews,
  boxNapoleonsBed,
  boxCasualties,
  boxPortugal,
  poolPlayerForces,
  poolNeutralForces,
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
  cupHighPolitics,
  cupFrenchCorps,
  trayImperialGuard,
  trayNapoleon,
  trayWives,
  trayIcons,
  trayPolitics,
  trayFrenchCorps,
  trayDuchy,
  trayRussianWar,
  trayAllies,
  trayBudget,
  trayEtats,
  trayAlignment,
  trayFrenchDiplomats,
  trayCoalitionDiplomats,
  trayReligion,
  trayEmigres,
  trayPrussians,
  trayRussians,
  trayAustrians,
  traySpanish,
  trayBritish,
  trayGold,
  trayFervor,
  trayMisc,
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
  nation,
  greenBox,
  minor,
  russianWar,
  turn,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.nation: [Location.nationFrance, Location.nationSpain],
    LocationType.greenBox: [Location.greenFrance, Location.greenSpain],
    LocationType.minor: [Location.minorBalkans, Location.minorUsa],
    LocationType.russianWar: [Location.russianWarFinland, Location.russianWarCorfu],
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
      Location.nationFrance: 'France',
      Location.nationGermany: 'Germany',
      Location.nationAustria: 'Austria',
      Location.nationItaly: 'Italy',
      Location.nationSpain: 'Spain',
      Location.minorBalkans: 'Balkans',
      Location.minorCape: 'Cape of Good Hope',
      Location.minorCaucasus: 'Caucasus',
      Location.minorCorfu: 'Corfu',
      Location.minorDenmark: 'Denmark',
      Location.minorEgypt: 'Egypt',
      Location.minorFinland: 'Finland',
      Location.minorHaiti: 'Haïti',
      Location.minorIreland: 'Ireland',
      Location.minorMalta: 'Malta',
      Location.minorMysore: 'Mysore',
      Location.minorRussia: 'Russia',
      Location.minorSenegal: 'Senegal',
      Location.minorSerbia: 'Serbia',
      Location.minorSwitzerland: 'Switzerland',
      Location.minorUsa: 'U.S.A.',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Piece {
  corpsFranceImperialGuard,
  corpsFranceBerthier,
  corpsFranceBessieres,
  corpsFranceDavoust,
  corpsFranceDupont,
  corpsFranceEugene,
  corpsFranceGrouchy,
  corpsFranceJunot,
  corpsFranceKellermann,
  corpsFranceKleber,
  corpsFranceLannes,
  corpsFranceMacDonald,
  corpsFranceMarmont,
  corpsFranceMassena,
  corpsFranceMoreau,
  corpsFranceMortier,
  corpsFranceNey,
  corpsFranceOudinot,
  corpsFranceSaintCyr,
  corpsFranceSoult,
  corpsFranceSuchet,
  corpsFranceVictor,
  corpsFranceBernadotte,
  corpsFranceMurat,
  corpsWarsaw,
  corpsNaples,
  corpsBavariaFrench,
  corpsAustriaBellegarde,
  corpsAustriaKarl,
  corpsAustriaRadetzky,
  corpsAustriaSchwarzenberg,
  corpsBavariaAustrian,
  corpsBritainBeresford,
  corpsBritainUxbridge,
  corpsBritainWellington,
  corpsPrussiaBlucher,
  corpsPrussiaBraunschweig,
  corpsPrussiaKleist,
  corpsPrussiaYorck,
  corpsRussiaBagration,
  corpsRussiaBarclay,
  corpsRussiaBennigsen,
  corpsRussiaKutuzov,
  corpsRussiaPlatov,
  corpsSpainBlake,
  corpsSpainPalafox,
  corpsSweden,
  corpsDuchyFusiliers0,
  corpsDuchyFusiliers1,
  corpsDuchyGrenadiers,
  corpsDuchyGrenzer,
  corpsDuchyGuards0,
  corpsDuchyGuards1,
  corpsDuchyJager0,
  corpsDuchyJager1,
  corpsDuchyLandwehr,
  corpsDuchyMarines0,
  corpsDuchyMarines1,
  corpsDuchyMusketeers,
  corpsDuchyReserve,
  corpsEmigreBourbon,
  corpsEmigreConde,
  corpsRoyalist,
  napoleonB,
  napoleonN,
  napoleonV,
  wifeJosephine,
  wifeMarriage,
  iconBeethoven,
  iconGoethe,
  iconGoya,
  iconVolta,
  warLostBalkans,
  warLostCape,
  warLostCaucasus,
  warLostCorfu,
  warLostDenmark,
  warLostEgypt,
  warLostFinland,
  warLostHaiti,
  warLostIreland,
  warLostMalta,
  warLostMysore,
  warLostSenegal,
  warLostSerbia,
  warLostSwitzerland,
  warLostUsa,
  warBalkans,
  warCape,
  warCaucasus,
  warCorfu,
  warDenmark,
  warEgypt,
  warFinland,
  warHaiti,
  warIreland,
  warMalta,
  warMysore,
  warSenegal,
  warSerbia,
  warSwitzerland,
  warUsa,
  noWarRed0,
  noWarRed1,
  noWarRed2,
  noWarRed3,
  noWarRed4,
  noWarRed5,
  noWarGreen0,
  noWarGreen1,
  trafalgar,
  coronation,
  treatySanIldefonso,
  spanishUlcer,
  russianWarFinland,
  russianWarCaucasus,
  russianWarBalkans,
  russianWarCorfu,
  russianWarLostFinland,
  russianWarLostCaucasus,
  russianWarLostBalkans,
  russianWarLostCorfu,
  fundAdmiralty,
  fundMinorWar,
  fundTreasury,
  etat0,
  etat1,
  etat2,
  etat3,
  etat4,
  etat5,
  etat6,
  etat7,
  etat8,
  etatWarsaw,
  austriaCoalition,
  austriaNeutral,
  austriaSurrender,
  prussiaCoalition,
  prussiaNeutral,
  prussiaSurrender,
  russiaCoalition,
  russiaNeutral,
  russiaSurrender,
  spainCoalition,
  spainFrench,
  swedenCoalition,
  swedenNeutral,
  scrollBasel,
  scrollRussianNobility,
  scrollTilsitPrussia,
  scrollTilsitRussia,
  diplomatFrench0,
  diplomatFrench1,
  diplomatFrench2,
  diplomatFrench3,
  diplomatFrench4,
  diplomatFrench5,
  diplomatFrench6,
  diplomatFrench7,
  diplomatFrenchReinhard,
  diplomatFrenchTalleyrand,
  diplomatCoalitionCastlereagh,
  diplomatCoalitionHardenberg,
  diplomatCoalitionMetternich,
  diplomatCoalitionRazumovsky,
  religionDeist,
  religionAtheist,
  religionUsurper,
  religionCatholic,
  religionSecular,
  pounds4,
  tradeIreland,
  tradeHaiti,
  tradeCape,
  tradeEgypt,
  tradeMysore,
  fervorFrance,
  fervorGermany,
  fervorAustria,
  fervorItaly,
  fervorSpain,
  jewsEmancipation,
  jewsGhetto,
  fleetCoalition,
  fleetFrench,
  butNation,
  continentalSystem,
  fraDiavolo,
  nelson,
  ottomanArmy,
  paris,
  terror,
  pope,
  napoleonAbdicates,
  lightInfantry,
  gameTurn,
  iconUnknownBeethoven,
  iconUnknownGoethe,
  iconUnknownGoya,
  iconUnknownVolta,
  etatUnknown0,
  etatUnknown1,
  etatUnknown2,
  etatUnknown3,
  etatUnknown4,
  etatUnknown5,
  etatUnknown6,
  etatUnknown7,
  etatUnknown8,
  diplomatCoalitionBusyCastlereagh,
  diplomatCoalitionBusyHardenberg,
  diplomatCoalitionBusyMetternich,
  diplomatCoalitionBusyRazumovsky,
  fleetBusyCoalition,
  fleetBusyFrench,
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
  frenchAndAlliedCorps,
  frenchCorps,
  mortalFrenchCorps,
  frenchAlliedCorps,
  austrianCorps,
  austrianAndAlliedCorps,
  britishCorps,
  prussianCorps,
  russianCorps,
  spanishCorps,
  swedishCorps,
  duchyCorps,
  coalitionCorps,
  napoleon,
  wife,
  icon,
  unknownIcon,
  war,
  warLost,
  warWon,
  noWar,
  russianWar,
  russianWarWon,
  russianWarLost,
  randomEtat,
  fund,
  etat,
  unknownEtat,
  alignment,
  diplomat,
  frenchDiplomat,
  coalitionDiplomat,
  religion,
  trade,
  fervor,
  fleet,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.corpsFranceImperialGuard, Piece.fleetBusyFrench],
    PieceType.frenchAndAlliedCorps: [Piece.corpsFranceImperialGuard, Piece.corpsBavariaFrench],
    PieceType.frenchCorps: [Piece.corpsFranceImperialGuard, Piece.corpsFranceMurat],
    PieceType.mortalFrenchCorps: [Piece.corpsFranceBerthier, Piece.corpsFranceVictor],
    PieceType.frenchAlliedCorps: [Piece.corpsWarsaw, Piece.corpsBavariaFrench],
    PieceType.austrianCorps: [Piece.corpsAustriaBellegarde, Piece.corpsAustriaSchwarzenberg],
    PieceType.austrianAndAlliedCorps: [Piece.corpsAustriaBellegarde, Piece.corpsBavariaAustrian],
    PieceType.britishCorps: [Piece.corpsBritainBeresford, Piece.corpsBritainWellington],
    PieceType.prussianCorps: [Piece.corpsPrussiaBlucher, Piece.corpsPrussiaYorck],
    PieceType.russianCorps: [Piece.corpsRussiaBagration, Piece.corpsRussiaPlatov],
    PieceType.spanishCorps: [Piece.corpsSpainBlake, Piece.corpsSpainPalafox],
    PieceType.swedishCorps: [Piece.corpsSweden, Piece.corpsSweden],
    PieceType.duchyCorps: [Piece.corpsDuchyFusiliers0, Piece.corpsDuchyReserve],
    PieceType.coalitionCorps: [Piece.corpsAustriaBellegarde, Piece.corpsRoyalist],
    PieceType.napoleon: [Piece.napoleonB, Piece.napoleonV],
    PieceType.wife: [Piece.wifeJosephine, Piece.wifeMarriage],
    PieceType.icon: [Piece.iconBeethoven, Piece.iconVolta],
    PieceType.unknownIcon: [Piece.iconUnknownBeethoven, Piece.iconUnknownVolta],
    PieceType.war: [Piece.warLostBalkans, Piece.warUsa],
    PieceType.warLost: [Piece.warLostBalkans, Piece.warLostUsa],
    PieceType.warWon: [Piece.warBalkans, Piece.warUsa],
    PieceType.noWar: [Piece.noWarRed0, Piece.noWarGreen1],
    PieceType.russianWar: [Piece.russianWarFinland, Piece.russianWarLostCorfu],
    PieceType.russianWarWon: [Piece.russianWarFinland, Piece.russianWarCorfu],
    PieceType.russianWarLost: [Piece.russianWarLostFinland, Piece.russianWarLostCorfu],
    PieceType.fund: [Piece.fundAdmiralty, Piece.fundTreasury],
    PieceType.randomEtat: [Piece.etat0, Piece.etat8],
    PieceType.unknownEtat: [Piece.etatUnknown0, Piece.etatUnknown8],
    PieceType.etat: [Piece.etat0, Piece.etatWarsaw],
    PieceType.alignment: [Piece.austriaCoalition, Piece.scrollTilsitRussia],
    PieceType.diplomat: [Piece.diplomatFrench0, Piece.diplomatCoalitionRazumovsky],
    PieceType.frenchDiplomat: [Piece.diplomatFrench0, Piece.diplomatFrenchTalleyrand],
    PieceType.coalitionDiplomat: [Piece.diplomatCoalitionCastlereagh, Piece.diplomatCoalitionRazumovsky],
    PieceType.religion: [Piece.religionDeist, Piece.religionSecular],
    PieceType.trade: [Piece.tradeIreland, Piece.tradeMysore],
    PieceType.fervor: [Piece.fervorFrance, Piece.fervorSpain],
    PieceType.fleet: [Piece.fleetCoalition, Piece.fleetFrench],
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
    const pieceNames = {
      Piece.corpsFranceImperialGuard: 'Imperial Guard',
      Piece.corpsFranceBerthier: 'Berthier Corps',
      Piece.corpsFranceBessieres: 'Bessières Corps',
      Piece.corpsFranceDavoust: 'Davoust Corps',
      Piece.corpsFranceDupont: 'Dupont Corps',
      Piece.corpsFranceEugene: 'Eugène Corps',
      Piece.corpsFranceGrouchy: 'Grouchy Corps',
      Piece.corpsFranceJunot: 'Junot Corps',
      Piece.corpsFranceKellermann: 'Kellerman Corps',
      Piece.corpsFranceKleber: 'Kléber Corps',
      Piece.corpsFranceLannes: 'Lannes Corps',
      Piece.corpsFranceMacDonald: 'MacDonald Corps',
      Piece.corpsFranceMarmont: 'Marmont Corps',
      Piece.corpsFranceMassena: 'Masséna Corps',
      Piece.corpsFranceMoreau: 'Moreau Corps',
      Piece.corpsFranceMortier: 'Mortier Corps',
      Piece.corpsFranceNey: 'Ney Corps',
      Piece.corpsFranceOudinot: 'Oudinot Corps',
      Piece.corpsFranceSaintCyr: 'Saint-Cyr Corps',
      Piece.corpsFranceSoult: 'Soult Corps',
      Piece.corpsFranceSuchet: 'Suchet Corps',
      Piece.corpsFranceVictor: 'Victor Corps',
      Piece.corpsFranceBernadotte: 'Bernadotte Corps',
      Piece.corpsFranceMurat: 'Murat Corps',
      Piece.corpsWarsaw: 'Warsaw Corps',
      Piece.corpsNaples: 'Naples Corps',
      Piece.corpsBavariaFrench: 'Bavaria Corps',
      Piece.corpsAustriaBellegarde: 'Bellegarde Corps',
      Piece.corpsAustriaKarl: 'Karl Corps',
      Piece.corpsAustriaRadetzky: 'Radetzky Corps',
      Piece.corpsAustriaSchwarzenberg: 'Schwarzenberg Corps',
      Piece.corpsBavariaAustrian: 'Bavaria Corps',
      Piece.corpsBritainBeresford: 'Beresford Corps',
      Piece.corpsBritainUxbridge: 'Uxbridge Corps',
      Piece.corpsBritainWellington: 'Wellington Corps',
      Piece.corpsPrussiaBlucher: 'Blücher Corps',
      Piece.corpsPrussiaBraunschweig: 'Braunschweig Corps',
      Piece.corpsPrussiaKleist: 'Kleist Corps',
      Piece.corpsPrussiaYorck: 'Yorck Corps',
      Piece.corpsRussiaBagration: 'Bagration Corps',
      Piece.corpsRussiaBarclay: 'Barclay Corps',
      Piece.corpsRussiaBennigsen: 'Bennigsen Corps',
      Piece.corpsRussiaKutuzov: 'Kutuzov Corps',
      Piece.corpsRussiaPlatov: 'Platov Corps',
      Piece.corpsSpainBlake: 'Blake Corps',
      Piece.corpsSpainPalafox: 'Palafox Corps',
      Piece.corpsSweden: 'Sweden Corps',
      Piece.corpsDuchyFusiliers0: 'Fusiliers Corps',
      Piece.corpsDuchyFusiliers1: 'Fusiliers Corps',
      Piece.corpsDuchyGrenadiers: 'Grenadiers Corps',
      Piece.corpsDuchyGrenzer: 'Grenzer Corps',
      Piece.corpsDuchyGuards0: 'Guards Corps',
      Piece.corpsDuchyGuards1: 'Guards Corps',
      Piece.corpsDuchyJager0: 'Jäger Corps',
      Piece.corpsDuchyJager1: 'Jäger Corps',
      Piece.corpsDuchyLandwehr: 'Landwehr Corps',
      Piece.corpsDuchyMarines0: 'Marines Corps',
      Piece.corpsDuchyMarines1: 'Marines Corps',
      Piece.corpsDuchyMusketeers: 'Musketeers Corps',
      Piece.corpsDuchyReserve: 'Reserve Corps',
      Piece.corpsEmigreBourbon: 'Bourbon Corps',
      Piece.corpsEmigreConde: 'Condé Corps',
      Piece.corpsRoyalist: 'Royalist Corps',
      Piece.iconBeethoven: 'Beethoven',
      Piece.iconGoethe: 'Goethe',
      Piece.iconGoya: 'Goya',
      Piece.iconVolta: 'Volta',
    };
    return pieceNames[this]!;
  }

  bool isType(PieceType pieceType) {
    return index >= pieceType.firstIndex && index < pieceType.lastIndex;
  }
}

enum Country {
  austria,
  prussia,
  russia,
  spain,
  sweden,
}

extension CountryExtension on Country {
  String get name {
    const countryNames = {
      Country.austria: 'Austria',
      Country.prussia: 'Prussia',
      Country.russia: 'Russia',
      Country.spain: 'Spain',
      Country.sweden: 'Sweden',
    };
    return countryNames[this]!;
  }
}

enum Scenario {
  year1792,
  year1805,
  year1813,
}

extension ScenarioExtension on Scenario {
  String get desc {
    const scenarioDescs = {
      Scenario.year1792: 'Bonaparte 1792',
      Scenario.year1805: 'Napoleon 1805',
      Scenario.year1813: 'The End 1813',
    };
    return scenarioDescs[this]!;
  }

  String get longDesc {
    const scenarioDescs = {
      Scenario.year1792: 'Bonaparte 1792 (16 Turns)',
      Scenario.year1805: 'Napoleon 1805 (11 Turns)',
      Scenario.year1813: 'The End 1813 (5 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
    : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']));

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.iconBeethoven: Piece.iconUnknownBeethoven,
      Piece.iconGoethe: Piece.iconUnknownGoethe,
      Piece.iconGoya: Piece.iconUnknownGoya,
      Piece.iconVolta: Piece.iconUnknownVolta,
      Piece.iconUnknownBeethoven: Piece.iconBeethoven,
      Piece.iconUnknownGoethe: Piece.iconGoethe,
      Piece.iconUnknownGoya: Piece.iconGoya,
      Piece.iconUnknownVolta: Piece.iconVolta,
      Piece.warBalkans: Piece.warLostBalkans,
      Piece.warCape: Piece.warLostCape,
      Piece.warCaucasus: Piece.warLostCaucasus,
      Piece.warCorfu: Piece.warLostCorfu,
      Piece.warDenmark: Piece.warLostDenmark,
      Piece.warEgypt: Piece.warLostEgypt,
      Piece.warFinland: Piece.warLostFinland,
      Piece.warHaiti: Piece.warLostHaiti,
      Piece.warIreland: Piece.warLostIreland,
      Piece.warMalta: Piece.warLostMalta,
      Piece.warMysore: Piece.warLostMysore,
      Piece.warSenegal: Piece.warLostSenegal,
      Piece.warSerbia: Piece.warLostSerbia,
      Piece.warSwitzerland: Piece.warLostSwitzerland,
      Piece.warUsa: Piece.warLostUsa,
      Piece.warLostBalkans: Piece.warBalkans,
      Piece.warLostCape: Piece.warCape,
      Piece.warLostCaucasus: Piece.warCaucasus,
      Piece.warLostCorfu: Piece.warCorfu,
      Piece.warLostDenmark: Piece.warDenmark,
      Piece.warLostEgypt: Piece.warEgypt,
      Piece.warLostFinland: Piece.warFinland,
      Piece.warLostHaiti: Piece.warHaiti,
      Piece.warLostIreland: Piece.warIreland,
      Piece.warLostMalta: Piece.warMalta,
      Piece.warLostMysore: Piece.warMysore,
      Piece.warLostSenegal: Piece.warSenegal,
      Piece.warLostSerbia: Piece.warSerbia,
      Piece.warLostSwitzerland: Piece.warSwitzerland,
      Piece.warLostUsa: Piece.warUsa,
      Piece.russianWarLostFinland: Piece.russianWarFinland,
      Piece.russianWarLostCaucasus: Piece.russianWarCaucasus,
      Piece.russianWarLostBalkans: Piece.russianWarBalkans,
      Piece.russianWarLostCorfu: Piece.russianWarCorfu,
      Piece.etat0: Piece.etatUnknown0,
      Piece.etat1: Piece.etatUnknown1,
      Piece.etat2: Piece.etatUnknown2,
      Piece.etat3: Piece.etatUnknown3,
      Piece.etat4: Piece.etatUnknown4,
      Piece.etat5: Piece.etatUnknown5,
      Piece.etat6: Piece.etatUnknown6,
      Piece.etat7: Piece.etatUnknown7,
      Piece.etat8: Piece.etatUnknown8,
      Piece.etatUnknown0: Piece.etat0,
      Piece.etatUnknown1: Piece.etat1,
      Piece.etatUnknown2: Piece.etat2,
      Piece.etatUnknown3: Piece.etat3,
      Piece.etatUnknown4: Piece.etat4,
      Piece.etatUnknown5: Piece.etat5,
      Piece.etatUnknown6: Piece.etat6,
      Piece.etatUnknown7: Piece.etat7,
      Piece.etatUnknown8: Piece.etat8,
      Piece.diplomatCoalitionCastlereagh: Piece.diplomatCoalitionBusyCastlereagh,
      Piece.diplomatCoalitionHardenberg: Piece.diplomatCoalitionBusyHardenberg,
      Piece.diplomatCoalitionMetternich: Piece.diplomatCoalitionBusyMetternich,
      Piece.diplomatCoalitionRazumovsky: Piece.diplomatCoalitionBusyRazumovsky,
      Piece.diplomatCoalitionBusyCastlereagh: Piece.diplomatCoalitionCastlereagh,
      Piece.diplomatCoalitionBusyHardenberg: Piece.diplomatCoalitionHardenberg,
      Piece.diplomatCoalitionBusyMetternich: Piece.diplomatCoalitionMetternich,
      Piece.diplomatCoalitionBusyRazumovsky: Piece.diplomatCoalitionRazumovsky,
      Piece.fleetCoalition: Piece.fleetBusyCoalition,
      Piece.fleetFrench: Piece.fleetBusyFrench,
      Piece.fleetBusyCoalition: Piece.fleetCoalition,
      Piece.fleetBusyFrench: Piece.fleetFrench,
    };
    return pieceFlipSides[piece];
  }

  void flipPiece(Piece piece) {
    final flippedPiece = pieceFlipSide(piece)!;
    final location = pieceLocation(piece);
    setPieceLocation(flippedPiece, location);
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

  // Nations

  Piece nationFervorPiece(Location nation) {
    return Piece.values[PieceType.fervor.firstIndex + nation.index - LocationType.nation.firstIndex];
  }

  int nationFervor(Location nation) {
    final piece = nationFervorPiece(nation);
    final box = pieceLocation(piece);
    return box.index - LocationType.turn.firstIndex;
  }

  void adjustNationFervor(Location nation, int amount) {
    int fervor = nationFervor(nation);
    fervor += amount;
    if (fervor >= 16) {
      fervor = 16;
    }
    if (fervor < 0) {
      fervor = 0;
    }
    setPieceLocation(nationFervorPiece(nation), Location.values[LocationType.turn.firstIndex + fervor]);
  }

  Location nationGreenBox(Location nation) {
    return Location.values[LocationType.greenBox.firstIndex + nation.index - LocationType.nation.firstIndex];
  }

  Location greenBoxNation(Location greenBox) {
    return Location.values[LocationType.nation.firstIndex + greenBox.index - LocationType.greenBox.firstIndex];
  }

  // Wars

  int warLocationValue(Location location) {
    const locationValues = {
      Location.minorBalkans: 11,
      Location.minorCape: 11,
      Location.minorCaucasus: 11,
      Location.minorCorfu: 11,
      Location.minorDenmark: 11,
      Location.minorEgypt: 11,
      Location.minorFinland: 10,
      Location.minorHaiti: 9,
      Location.minorIreland: 11,
      Location.minorMalta: 11,
      Location.minorMysore: 10,
      Location.minorRussia: 12,
      Location.minorSenegal: 10,
      Location.minorSerbia: 12,
      Location.minorSwitzerland: 12,
      Location.minorUsa: 13,
    };
    return locationValues[location]!;
  }

  bool warLocationNaval(Location location) {
    const navalLocations = [
      Location.minorCape,
      Location.minorCorfu,
      Location.minorDenmark,
      Location.minorEgypt,
      Location.minorHaiti,
      Location.minorIreland,
      Location.minorMalta,
      Location.minorMysore,
      Location.minorSenegal,
      Location.minorUsa,
    ];
    return navalLocations.contains(location);
  }

  bool warLocationRussian(Location location) {
    const russianLocations = [
      Location.minorBalkans,
      Location.minorCaucasus,
      Location.minorCorfu,
      Location.minorFinland,
    ];
    return russianLocations.contains(location);
  }

  bool warLocationCommercial(Location location) {
    const commercialLocations = [
      Location.minorCape,
      Location.minorEgypt,
      Location.minorHaiti,
      Location.minorIreland,
      Location.minorMysore,
    ];
    return commercialLocations.contains(location);
  }

  bool warLocationStrategic(Location location) {
    const strategicLocations = [
      Location.minorDenmark,
      Location.minorMalta,
      Location.minorRussia,
      Location.minorSenegal,
      Location.minorSerbia,
      Location.minorSwitzerland,
      Location.minorUsa,
    ];
    return strategicLocations.contains(location);
  }

  int get russianWarCount {
    int count = 0;
    for (final box in LocationType.russianWar.locations) {
      if (pieceInLocation(PieceType.russianWar, box) != null) {
        count += 1;
      }
    }
    return count;
  }

  List<Piece> get lostWars {
    final wars = <Piece>[];
    for (final war in PieceType.warLost.pieces) {
      if (pieceLocation(war).isType(LocationType.minor)) {
        wars.add(war);
      }
    }
    return wars;
  }

  // Etats

  void formEtatInNation(Piece etat, Location nation) {
    final oldEtat = pieceInLocation(PieceType.etat, nation);
    if (oldEtat != null) {
      setPieceLocation(oldEtat, Location.discarded);
    }
    setPieceLocation(etat, nation);
  }

  // Countries

  Location? countryGreenBox(Country country) {
    const countryGreenBoxes = {
      Country.austria: Location.greenAustria,
      Country.prussia: Location.greenGermany,
      Country.spain: Location.greenSpain,
    };
    return countryGreenBoxes[country];
  }

  bool countryInCoalition(Country country) {
    switch (country) {
    case Country.austria:
      return pieceLocation(Piece.austriaCoalition) == Location.statusAustria;
    case Country.prussia:
      return pieceLocation(Piece.prussiaCoalition) == Location.statusPrussia;
    case Country.russia:
      return pieceLocation(Piece.russiaCoalition) == Location.statusRussia;
    case Country.spain:
      return pieceLocation(Piece.spainCoalition) == Location.statusSpain;
    case Country.sweden:
      return pieceLocation(Piece.swedenCoalition) == Location.statusSweden;
    }
  }

  bool countryNeutral(Country country) {
    switch (country) {
    case Country.austria:
      return pieceLocation(Piece.austriaNeutral) == Location.statusAustria;
    case Country.prussia:
      return pieceLocation(Piece.prussiaNeutral) == Location.statusPrussia;
    case Country.russia:
      return pieceLocation(Piece.russiaNeutral) == Location.statusRussia;
    case Country.spain:
      return false;
    case Country.sweden:
      return pieceLocation(Piece.swedenNeutral) == Location.statusSweden;
    }
  }

  bool countrySurrendered(Country country) {
    switch (country) {
    case Country.austria:
      return pieceLocation(Piece.austriaSurrender) == Location.statusAustria;
    case Country.prussia:
      return pieceLocation(Piece.prussiaSurrender) == Location.statusPrussia;
    case Country.russia:
      return pieceLocation(Piece.russiaSurrender) == Location.statusRussia;
    case Country.spain:
    case Country.sweden:
      return false;
    }
  }

  bool countryProFrench(Country country) {
    switch (country) {
    case Country.spain:
      return pieceLocation(Piece.spainFrench) == Location.statusSpain;
    case Country.austria:
    case Country.prussia:
    case Country.russia:
    case Country.sweden:
    return false;
    }
  }

  PieceType countryCorpsPieceType(Country country) {
    switch (country) {
    case Country.austria:
      return PieceType.austrianAndAlliedCorps;
    case Country.prussia:
      return PieceType.prussianCorps;
    case Country.russia:
      return PieceType.russianCorps;
    case Country.spain:
      return PieceType.spanishCorps;
    case Country.sweden:
      return PieceType.swedishCorps;
    }
  }

  Location countryForcePool(Country country) {
    return countryInCoalition(country) ? Location.poolPlayerForces : Location.poolNeutralForces;
  }

  void austriaJoinsCoalition() {
    setPieceLocation(Piece.austriaNeutral, Location.trayAlignment);
    setPieceLocation(Piece.austriaSurrender, Location.trayAlignment);
    setPieceLocation(Piece.austriaCoalition, Location.statusAustria);
    for (final corps in piecesInLocation(PieceType.austrianAndAlliedCorps, Location.poolNeutralForces)) {
      setPieceLocation(corps, Location.poolPlayerForces);
    }
  }

  void prussiaJoinsCoalition() {
    setPieceLocation(Piece.prussiaNeutral, Location.trayAlignment);
    setPieceLocation(Piece.prussiaSurrender, Location.trayAlignment);
    setPieceLocation(Piece.prussiaCoalition, Location.statusPrussia);
    for (final corps in piecesInLocation(PieceType.prussianCorps, Location.poolNeutralForces)) {
      setPieceLocation(corps, Location.poolPlayerForces);
    }
  }

  void russiaJoinsCoalition() {
    setPieceLocation(Piece.russiaNeutral, Location.trayAlignment);
    setPieceLocation(Piece.russiaSurrender, Location.trayAlignment);
    setPieceLocation(Piece.russiaCoalition, Location.statusRussia);
    for (final corps in piecesInLocation(PieceType.russianCorps, Location.poolNeutralForces)) {
      setPieceLocation(corps, Location.poolPlayerForces);
    }
  }

  void spainJoinsCoalition() {
    setPieceLocation(Piece.spainFrench, Location.trayAlignment);
    setPieceLocation(Piece.spainCoalition, Location.statusSpain);
    for (final corps in piecesInLocation(PieceType.spanishCorps, Location.poolNeutralForces)) {
      setPieceLocation(corps, Location.poolPlayerForces);
    }
  }

  void swedenJoinsCoalition() {
    setPieceLocation(Piece.swedenNeutral, Location.trayAlignment);
    setPieceLocation(Piece.swedenCoalition, Location.statusSweden);
    for (final corps in piecesInLocation(PieceType.swedishCorps, Location.poolNeutralForces)) {
      setPieceLocation(corps, Location.poolPlayerForces);
    }
  }

  void austriaLeavesCoalition() {
    setPieceLocation(Piece.austriaCoalition, Location.trayAlignment);
    setPieceLocation(Piece.austriaSurrender, Location.trayAlignment);
    setPieceLocation(Piece.austriaNeutral, Location.statusAustria);
    for (final corps in piecesInLocation(PieceType.austrianAndAlliedCorps, Location.poolPlayerForces)) {
      setPieceLocation(corps, Location.poolNeutralForces);
    }
    for (final corps in piecesInLocation(PieceType.austrianAndAlliedCorps, Location.boxCasualties)) {
      setPieceLocation(corps, Location.poolNeutralForces);
    }
  }

  void prussiaLeavesCoalition() {
    setPieceLocation(Piece.prussiaCoalition, Location.trayAlignment);
    setPieceLocation(Piece.prussiaSurrender, Location.trayAlignment);
    setPieceLocation(Piece.prussiaNeutral, Location.statusAustria);
    for (final corps in piecesInLocation(PieceType.prussianCorps, Location.poolPlayerForces)) {
      setPieceLocation(corps, Location.poolNeutralForces);
    }
    for (final corps in piecesInLocation(PieceType.prussianCorps, Location.boxCasualties)) {
      setPieceLocation(corps, Location.poolNeutralForces);
    }
  }

  void russiaLeavesCoalition() {
    setPieceLocation(Piece.russiaCoalition, Location.trayAlignment);
    setPieceLocation(Piece.russiaSurrender, Location.trayAlignment);
    setPieceLocation(Piece.russiaNeutral, Location.statusAustria);
    for (final corps in piecesInLocation(PieceType.russianCorps, Location.poolPlayerForces)) {
      setPieceLocation(corps, Location.poolNeutralForces);
    }
    for (final corps in piecesInLocation(PieceType.russianCorps, Location.boxCasualties)) {
      setPieceLocation(corps, Location.poolNeutralForces);
    }
  }

  void austriaSurrenders() {
    setPieceLocation(Piece.austriaCoalition, Location.trayAlignment);
    setPieceLocation(Piece.austriaNeutral, Location.trayAlignment);
    setPieceLocation(Piece.austriaSurrender, Location.statusAustria);
    for (final corps in piecesInLocation(PieceType.austrianAndAlliedCorps, Location.poolPlayerForces)) {
      setPieceLocation(corps, Location.poolNeutralForces);
    }
    for (final corps in piecesInLocation(PieceType.austrianAndAlliedCorps, Location.boxCasualties)) {
      setPieceLocation(corps, Location.poolNeutralForces);
    }
  }

  void prussiaSurrenders() {
    setPieceLocation(Piece.prussiaCoalition, Location.trayAlignment);
    setPieceLocation(Piece.prussiaNeutral, Location.trayAlignment);
    setPieceLocation(Piece.prussiaSurrender, Location.statusPrussia);
    for (final corps in piecesInLocation(PieceType.prussianCorps, Location.poolPlayerForces)) {
      setPieceLocation(corps, Location.poolNeutralForces);
    }
    for (final corps in piecesInLocation(PieceType.prussianCorps, Location.boxCasualties)) {
      setPieceLocation(corps, Location.poolNeutralForces);
    }
  }

  void russiaSurrenders() {
    setPieceLocation(Piece.russiaCoalition, Location.trayAlignment);
    setPieceLocation(Piece.russiaNeutral, Location.trayAlignment);
    setPieceLocation(Piece.russiaSurrender, Location.statusRussia);
    for (final corps in piecesInLocation(PieceType.russianCorps, Location.poolPlayerForces)) {
      setPieceLocation(corps, Location.poolNeutralForces);
    }
    for (final corps in piecesInLocation(PieceType.russianCorps, Location.boxCasualties)) {
      setPieceLocation(corps, Location.poolNeutralForces);
    }
  }

  void spainJoinsFrench() {
    setPieceLocation(Piece.spainCoalition, Location.trayAlignment);
    setPieceLocation(Piece.spainFrench, Location.statusSpain);
  }

  // Fleets

  Piece? get rulingFleet {
    return pieceInLocation(PieceType.fleet, Location.boxHighSeas);
  }

  // Diplomats

  int diplomatValue(Piece diplomat) {
    const diplomatModifiers = {
      Piece.diplomatCoalitionBusyCastlereagh: 4,
      Piece.diplomatCoalitionBusyMetternich: 4,
      Piece.diplomatCoalitionBusyHardenberg: 3,
      Piece.diplomatCoalitionBusyRazumovsky: 3,
      Piece.diplomatFrenchTalleyrand: 2,
      Piece.diplomatFrenchReinhard: 1,
    };
    return diplomatModifiers[diplomat] ?? 0;
  }

  // Napoleon

  Piece get napoleon {
    for (final piece in PieceType.napoleon.pieces) {
      final location = pieceLocation(piece);
      if (location != Location.trayNapoleon && location != Location.discarded) {
        return piece;
      }
    }
    return Piece.napoleonV;
  }

  int get napoleonAbdicates {
    return pieceLocation(Piece.napoleonAbdicates).index - Location.turn0.index;
  }

  void adjustNapoleonAbdicates(int amount) {
    int newTotal = napoleonAbdicates + amount;
    if (newTotal > 16) {
      newTotal = 16;
    }
    if (newTotal < 0) {
      newTotal = 0;
    }
    setPieceLocation(Piece.napoleonAbdicates, Location.values[Location.turn0.index + newTotal]);
  }

  // Religion

  String religionName(Piece religion) {
    const religionNames = {
      Piece.religionAtheist: 'Atheist',
      Piece.religionCatholic: 'Catholic',
      Piece.religionDeist: 'Deist',
      Piece.religionSecular: 'Secular',
      Piece.religionUsurper: 'Usurper',
    };
    return religionNames[religion]!;
  }

  Piece get frenchReligion {
    return pieceInLocation(PieceType.religion, Location.boxFranceReligion)!;
  }

  set frenchReligion(Piece religion) {
    final oldReligion = frenchReligion;
    if (religion != oldReligion) {
      setPieceLocation(oldReligion, Location.trayReligion);
      setPieceLocation(religion, Location.boxFranceReligion);
    }
  }

  // Money

  int get treasuryFund {
    return pieceLocation(Piece.fundTreasury).index - Location.turn0.index;
  }

  void adjustTreasuryFund(int amount) {
    int newTotal = treasuryFund + amount;
    if (newTotal > 16) {
      newTotal = 16;
    }
    if (newTotal < 0) {
      newTotal = 0;
    }
    setPieceLocation(Piece.fundTreasury, Location.values[Location.turn0.index + newTotal]);
  }

  int get minorWarFund {
    return pieceLocation(Piece.fundMinorWar).index - Location.turn0.index;
  }

  void adjustMinorWarFund(int amount) {
    int newTotal = minorWarFund + amount;
    if (newTotal > 16) {
      newTotal = 16;
    }
    if (newTotal < 0) {
      newTotal = 0;
    }
    setPieceLocation(Piece.fundMinorWar, Location.values[Location.turn0.index + newTotal]);
  }

  int get admiraltyFund {
    return pieceLocation(Piece.fundAdmiralty).index - Location.turn0.index;
  }

  void adjustAdmiraltyFund(int amount) {
    int newTotal = admiraltyFund + amount;
    if (newTotal > 16) {
      newTotal = 16;
    }
    if (newTotal < 0) {
      newTotal = 0;
    }
    setPieceLocation(Piece.fundAdmiralty, Location.values[Location.turn0.index + newTotal]);
  }

  int get londonMoney {
    return pieceLocation(Piece.pounds4) == Location.boxLondon ? 4 : 3;
  }

  bool get continentalSystemActive {
    return pieceLocation(Piece.continentalSystem) == Location.boxHighSeas;
  }

  // Turn

  int get currentTurn {
    return pieceLocation(Piece.gameTurn).index - Location.turn0.index;
  }

  Location get currentTurnLocation {
    return pieceLocation(Piece.gameTurn);
  }

  Location turnLocation(int turn) {
    return Location.values[LocationType.turn.firstIndex + turn];
  }

  Location get turnButNation {
    const turnButNations = [
      Location.nationFrance,
      Location.nationGermany,
      Location.nationItaly,
      Location.nationItaly,
      Location.nationAustria,
      Location.nationAustria,
      Location.nationGermany,
      Location.nationSpain,
      Location.nationAustria,
      Location.nationAustria,
      Location.nationGermany,
      Location.nationGermany,
      Location.nationGermany,
      Location.nationFrance,
      Location.nationFrance,
      Location.nationFrance,
    ];
    return turnButNations[currentTurn - 1];
  }

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

  factory GameState.setupCounterTray() {
    var state = GameState();

    state.setupPieceTypes([
      (PieceType.napoleon, Location.trayNapoleon),
      (PieceType.wife, Location.trayWives),
      (PieceType.unknownIcon, Location.trayIcons),
      (PieceType.warWon, Location.trayPolitics),
      (PieceType.noWar, Location.trayPolitics),
      (PieceType.frenchCorps, Location.trayFrenchCorps),
      (PieceType.duchyCorps, Location.trayDuchy),
      (PieceType.russianWarWon, Location.trayRussianWar),
      (PieceType.frenchAlliedCorps, Location.trayAllies),
      (PieceType.fund, Location.trayBudget),
      (PieceType.unknownEtat, Location.trayEtats),
      (PieceType.alignment, Location.trayAlignment),
      (PieceType.frenchDiplomat, Location.trayFrenchDiplomats),
      (PieceType.coalitionDiplomat, Location.trayCoalitionDiplomats),
      (PieceType.religion, Location.trayReligion),
      (PieceType.prussianCorps, Location.trayPrussians),
      (PieceType.russianCorps, Location.trayRussians),
      (PieceType.austrianCorps, Location.trayAustrians),
      (PieceType.spanishCorps, Location.traySpanish),
      (PieceType.britishCorps, Location.trayBritish),
      (PieceType.trade, Location.trayGold),
      (PieceType.fervor, Location.trayFervor),
    ]);

    state.setupPieces([
      (Piece.corpsFranceImperialGuard, Location.trayImperialGuard),
      (Piece.trafalgar, Location.trayPolitics),
      (Piece.coronation, Location.trayPolitics),
      (Piece.treatySanIldefonso, Location.trayPolitics),
      (Piece.spanishUlcer, Location.trayPolitics),
      (Piece.etatWarsaw, Location.trayAllies),
      (Piece.corpsRoyalist, Location.trayEmigres),
      (Piece.corpsEmigreBourbon, Location.trayEmigres),
      (Piece.corpsEmigreConde, Location.trayEmigres),
      (Piece.pounds4, Location.trayGold),
      (Piece.butNation, Location.trayMisc),
      (Piece.continentalSystem, Location.trayMisc),
      (Piece.jewsEmancipation, Location.trayMisc),
      (Piece.jewsGhetto, Location.trayMisc),
      (Piece.fraDiavolo, Location.trayMisc),
      (Piece.fleetFrench, Location.trayMisc),
      (Piece.fleetCoalition, Location.trayMisc),
      (Piece.gameTurn, Location.trayMisc),
      (Piece.lightInfantry, Location.trayMisc),
      (Piece.napoleonAbdicates, Location.trayMisc),
      (Piece.nelson, Location.trayMisc),
      (Piece.ottomanArmy, Location.trayMisc),
      (Piece.paris, Location.trayMisc),
      (Piece.corpsSweden, Location.trayMisc),
      (Piece.terror, Location.trayMisc),
      (Piece.pope, Location.trayMisc),
    ]);

    return state;
  }

  factory GameState.setup1792() {

    var state = GameState.setupCounterTray();

    state.setupPieces([
      (Piece.noWarGreen0, Location.cupHighPolitics),
      (Piece.noWarGreen1, Location.cupHighPolitics),
      (Piece.treatySanIldefonso, Location.cupHighPolitics),
      (Piece.corpsFranceBernadotte, Location.cupFrenchCorps),
      (Piece.corpsFranceBerthier, Location.cupFrenchCorps),
      (Piece.corpsFranceBessieres, Location.cupFrenchCorps),
      (Piece.corpsFranceDavoust, Location.cupFrenchCorps),
      (Piece.corpsFranceDupont, Location.cupFrenchCorps),
      (Piece.corpsFranceEugene, Location.cupFrenchCorps),
      (Piece.corpsFranceGrouchy, Location.cupFrenchCorps),
      (Piece.corpsFranceJunot, Location.cupFrenchCorps),
      (Piece.corpsFranceKellermann, Location.cupFrenchCorps),
      (Piece.corpsFranceKleber, Location.cupFrenchCorps),
      (Piece.corpsFranceLannes, Location.cupFrenchCorps),
      (Piece.corpsFranceMacDonald, Location.cupFrenchCorps),
      (Piece.corpsFranceMarmont, Location.cupFrenchCorps),
      (Piece.corpsFranceMassena, Location.cupFrenchCorps),
      (Piece.corpsFranceMoreau, Location.cupFrenchCorps),
      (Piece.corpsFranceMortier, Location.cupFrenchCorps),
      (Piece.corpsFranceMurat, Location.cupFrenchCorps),
      (Piece.corpsFranceNey, Location.cupFrenchCorps),
      (Piece.corpsFranceOudinot, Location.cupFrenchCorps),
      (Piece.corpsFranceSaintCyr, Location.cupFrenchCorps),
      (Piece.corpsFranceSoult, Location.cupFrenchCorps),
      (Piece.corpsFranceSuchet, Location.cupFrenchCorps),
      (Piece.corpsFranceVictor, Location.cupFrenchCorps),
      (Piece.corpsDuchyFusiliers0, Location.poolPlayerForces),
      (Piece.corpsDuchyFusiliers1, Location.poolPlayerForces),
      (Piece.corpsDuchyGrenadiers, Location.poolPlayerForces),
      (Piece.corpsDuchyGrenzer, Location.poolPlayerForces),
      (Piece.corpsDuchyGuards0, Location.poolPlayerForces),
      (Piece.corpsDuchyGuards1, Location.poolPlayerForces),
      (Piece.corpsDuchyJager0, Location.poolPlayerForces),
      (Piece.corpsDuchyJager1, Location.poolPlayerForces),
      (Piece.corpsDuchyLandwehr, Location.poolPlayerForces),
      (Piece.corpsDuchyMarines0, Location.poolPlayerForces),
      (Piece.corpsDuchyMarines1, Location.poolPlayerForces),
      (Piece.corpsDuchyMusketeers, Location.poolPlayerForces),
      (Piece.corpsDuchyReserve, Location.poolPlayerForces),
      (Piece.russianWarFinland, Location.minorFinland),
      (Piece.russianWarCaucasus, Location.minorCaucasus),
      (Piece.russianWarBalkans, Location.minorBalkans),
      (Piece.russianWarCorfu, Location.minorCorfu),
      (Piece.fundTreasury, Location.turn0),
      (Piece.fundAdmiralty, Location.turn0),
      (Piece.fundMinorWar, Location.turn0),
      (Piece.spainCoalition, Location.statusSpain),
      (Piece.prussiaCoalition, Location.statusPrussia),
      (Piece.austriaCoalition, Location.statusAustria),
      (Piece.swedenNeutral, Location.statusSweden),
      (Piece.russiaNeutral, Location.statusRussia),
      (Piece.diplomatCoalitionCastlereagh, Location.boxLondon),
      (Piece.diplomatCoalitionMetternich, Location.boxLondon),
      (Piece.diplomatCoalitionRazumovsky, Location.boxLondon),
      (Piece.diplomatCoalitionHardenberg, Location.boxLondon),
      (Piece.diplomatFrenchTalleyrand, Location.greenGermany),
      (Piece.diplomatFrenchReinhard, Location.greenGermany),
      (Piece.diplomatFrench0, Location.boxHotel),
      (Piece.diplomatFrench1, Location.boxHotel),
      (Piece.diplomatFrench2, Location.boxHotel),
      (Piece.diplomatFrench3, Location.boxHotel),
      (Piece.diplomatFrench4, Location.boxHotel),
      (Piece.diplomatFrench5, Location.boxHotel),
      (Piece.diplomatFrench6, Location.boxHotel),
      (Piece.diplomatFrench7, Location.boxHotel),
      (Piece.religionAtheist, Location.boxFranceReligion),
      (Piece.corpsRoyalist, Location.nationFrance),
      (Piece.corpsEmigreBourbon, Location.nationGermany),
      (Piece.corpsEmigreConde, Location.nationGermany),
      (Piece.corpsPrussiaBlucher, Location.poolPlayerForces),
      (Piece.corpsPrussiaBraunschweig, Location.poolPlayerForces),
      (Piece.corpsPrussiaKleist, Location.poolPlayerForces),
      (Piece.corpsPrussiaYorck, Location.poolPlayerForces),
      (Piece.corpsRussiaBagration, Location.poolNeutralForces),
      (Piece.corpsRussiaBarclay, Location.poolNeutralForces),
      (Piece.corpsRussiaBennigsen, Location.poolNeutralForces),
      (Piece.corpsRussiaKutuzov, Location.poolNeutralForces),
      (Piece.corpsRussiaPlatov, Location.poolNeutralForces),
      (Piece.corpsAustriaBellegarde, Location.poolPlayerForces),
      (Piece.corpsAustriaKarl, Location.poolPlayerForces),
      (Piece.corpsAustriaRadetzky, Location.poolPlayerForces),
      (Piece.corpsAustriaSchwarzenberg, Location.poolPlayerForces),
      (Piece.corpsSpainBlake, Location.poolPlayerForces),
      (Piece.corpsSpainPalafox, Location.poolPlayerForces),
      (Piece.corpsBritainBeresford, Location.poolPlayerForces),
      (Piece.corpsBritainUxbridge, Location.poolPlayerForces),
      (Piece.corpsBritainWellington, Location.poolPlayerForces),
      (Piece.pounds4, Location.boxLondon),
      (Piece.tradeIreland, Location.minorIreland),
      (Piece.tradeHaiti, Location.minorHaiti),
      (Piece.tradeCape, Location.minorCape),
      (Piece.tradeEgypt, Location.minorEgypt),
      (Piece.tradeMysore, Location.minorMysore),
      (Piece.fervorFrance, Location.turn16),
      (Piece.fervorGermany, Location.turn14),
      (Piece.fervorAustria, Location.turn12),
      (Piece.fervorItaly, Location.turn14),
      (Piece.fervorSpain, Location.turn12),
      (Piece.butNation, Location.greenFrance),
      (Piece.gameTurn, Location.turn1),
      (Piece.jewsGhetto, Location.boxJews),
      (Piece.napoleonAbdicates, Location.turn0),
      (Piece.nelson, Location.boxHighSeas),
      (Piece.fleetCoalition, Location.boxHighSeas),
      (Piece.terror, Location.nationFrance),
      (Piece.pope, Location.nationItaly),
      (Piece.lightInfantry, Location.lightInfantryBernadotte),
    ]);

    return state;
  }

  factory GameState.setup1805(Random random) {

    var state = GameState.setupCounterTray();

    final etats = PieceType.randomEtat.pieces;
    etats.shuffle(random);

    final ottomanArmyLocations = [Location.minorBalkans, Location.minorBalkans, Location.minorSerbia, Location.minorCorfu, Location.minorEgypt, Location.minorCaucasus];
    final ottomanArmyLocation = ottomanArmyLocations[random.nextInt(ottomanArmyLocations.length)];

    state.setupPieces([
        (Piece.napoleonB, Location.discarded),
        (Piece.napoleonN, Location.boxNapoleonsBed),
        (Piece.wifeJosephine, Location.boxNapoleonsBed),
        (Piece.iconBeethoven, Location.boxLondon),
        (Piece.iconGoya, Location.nationSpain),
        (Piece.warHaiti, Location.minorHaiti),
        (Piece.warMalta, Location.minorMalta),
        (Piece.warIreland, Location.minorIreland),
        (Piece.warCape, Location.minorCape),
        (Piece.warEgypt, Location.minorEgypt),
        (Piece.coronation, Location.discarded),
        (Piece.noWarGreen0, Location.discarded),
        (Piece.noWarGreen1, Location.discarded),
        (Piece.warDenmark, Location.cupHighPolitics),
        (Piece.warSenegal, Location.cupHighPolitics),
        (Piece.warUsa, Location.cupHighPolitics),
        (Piece.spanishUlcer, Location.cupHighPolitics),
        (Piece.warMysore, Location.cupHighPolitics),
        (Piece.warCorfu, Location.cupHighPolitics),
        (Piece.trafalgar, Location.cupHighPolitics),
        (Piece.warSwitzerland, Location.discarded),
        (Piece.warLostSwitzerland, Location.minorSwitzerland),
        (Piece.treatySanIldefonso, Location.nationSpain),
        (Piece.corpsFranceMoreau, Location.discarded),
        (Piece.corpsFranceBernadotte, Location.cupFrenchCorps),
        (Piece.corpsFranceBerthier, Location.cupFrenchCorps),
        (Piece.corpsFranceBessieres, Location.cupFrenchCorps),
        (Piece.corpsFranceDavoust, Location.cupFrenchCorps),
        (Piece.corpsFranceDupont, Location.cupFrenchCorps),
        (Piece.corpsFranceEugene, Location.cupFrenchCorps),
        (Piece.corpsFranceGrouchy, Location.cupFrenchCorps),
        (Piece.corpsFranceJunot, Location.cupFrenchCorps),
        (Piece.corpsFranceKellermann, Location.cupFrenchCorps),
        (Piece.corpsFranceKleber, Location.cupFrenchCorps),
        (Piece.corpsFranceLannes, Location.cupFrenchCorps),
        (Piece.corpsFranceMacDonald, Location.cupFrenchCorps),
        (Piece.corpsFranceMarmont, Location.cupFrenchCorps),
        (Piece.corpsFranceMassena, Location.cupFrenchCorps),
        (Piece.corpsFranceMortier, Location.cupFrenchCorps),
        (Piece.corpsFranceMurat, Location.cupFrenchCorps),
        (Piece.corpsFranceNey, Location.cupFrenchCorps),
        (Piece.corpsFranceOudinot, Location.cupFrenchCorps),
        (Piece.corpsFranceSaintCyr, Location.cupFrenchCorps),
        (Piece.corpsFranceSoult, Location.cupFrenchCorps),
        (Piece.corpsFranceSuchet, Location.cupFrenchCorps),
        (Piece.corpsFranceVictor, Location.cupFrenchCorps),
        (Piece.corpsDuchyFusiliers0, Location.poolPlayerForces),
        (Piece.corpsDuchyFusiliers1, Location.poolPlayerForces),
        (Piece.corpsDuchyGrenadiers, Location.poolPlayerForces),
        (Piece.corpsDuchyGrenzer, Location.poolPlayerForces),
        (Piece.corpsDuchyGuards0, Location.poolPlayerForces),
        (Piece.corpsDuchyGuards1, Location.poolPlayerForces),
        (Piece.corpsDuchyJager0, Location.poolPlayerForces),
        (Piece.corpsDuchyJager1, Location.poolPlayerForces),
        (Piece.corpsDuchyLandwehr, Location.poolPlayerForces),
        (Piece.corpsDuchyMarines0, Location.poolPlayerForces),
        (Piece.corpsDuchyMarines1, Location.poolPlayerForces),
        (Piece.corpsDuchyMusketeers, Location.poolPlayerForces),
        (Piece.corpsDuchyReserve, Location.poolPlayerForces),
        (Piece.russianWarFinland, Location.minorFinland),
        (Piece.russianWarCaucasus, Location.minorCaucasus),
        (Piece.russianWarBalkans, Location.minorBalkans),
        (Piece.russianWarCorfu, Location.russianWarCorfu),
        (Piece.corpsBavariaFrench, Location.cupFrenchCorps),
        (Piece.fundTreasury, Location.turn4),
        (Piece.fundAdmiralty, Location.turn4),
        (Piece.fundMinorWar, Location.turn4),
        (etats[0], Location.discarded),
        (etats[1], Location.discarded),
        (etats[2], Location.discarded),
        (etats[3], Location.cupHighPolitics),
        (etats[4], Location.cupHighPolitics),
        (etats[5], Location.nationGermany),
        (etats[6], Location.nationItaly),
        (Piece.austriaCoalition, Location.statusAustria),
        (Piece.russiaCoalition, Location.statusRussia),
        (Piece.prussiaNeutral, Location.statusPrussia),
        (Piece.swedenNeutral, Location.statusSweden),
        (Piece.spainFrench, Location.statusSpain),
        (Piece.scrollBasel, Location.discarded),
        (Piece.diplomatCoalitionCastlereagh, Location.boxLondon),
        (Piece.diplomatCoalitionMetternich, Location.boxLondon),
        (Piece.diplomatCoalitionRazumovsky, Location.boxLondon),
        (Piece.diplomatCoalitionHardenberg, Location.boxLondon),
        (Piece.diplomatFrenchTalleyrand, Location.greenGermany),
        (Piece.diplomatFrenchReinhard, Location.greenGermany),
        (Piece.diplomatFrench0, Location.boxHotel),
        (Piece.diplomatFrench1, Location.boxHotel),
        (Piece.diplomatFrench2, Location.boxHotel),
        (Piece.diplomatFrench3, Location.boxHotel),
        (Piece.diplomatFrench4, Location.boxHotel),
        (Piece.diplomatFrench5, Location.boxHotel),
        (Piece.diplomatFrench6, Location.boxHotel),
        (Piece.diplomatFrench7, Location.boxHotel),
        (Piece.religionCatholic, Location.boxFranceReligion),
        (Piece.corpsPrussiaBlucher, Location.poolNeutralForces),
        (Piece.corpsPrussiaBraunschweig, Location.poolNeutralForces),
        (Piece.corpsPrussiaKleist, Location.poolNeutralForces),
        (Piece.corpsPrussiaYorck, Location.poolNeutralForces),
        (Piece.corpsRussiaBagration, Location.poolPlayerForces),
        (Piece.corpsRussiaBarclay, Location.poolPlayerForces),
        (Piece.corpsRussiaBennigsen, Location.poolPlayerForces),
        (Piece.corpsRussiaKutuzov, Location.poolPlayerForces),
        (Piece.corpsRussiaPlatov, Location.poolPlayerForces),
        (Piece.corpsAustriaBellegarde, Location.poolPlayerForces),
        (Piece.corpsAustriaKarl, Location.poolPlayerForces),
        (Piece.corpsAustriaRadetzky, Location.poolPlayerForces),
        (Piece.corpsAustriaSchwarzenberg, Location.poolPlayerForces),
        (Piece.corpsSpainBlake, Location.cupFrenchCorps),
        (Piece.corpsSpainPalafox, Location.cupFrenchCorps),
        (Piece.corpsBritainBeresford, Location.poolPlayerForces),
        (Piece.corpsBritainUxbridge, Location.poolPlayerForces),
        (Piece.corpsBritainWellington, Location.poolPlayerForces),
        (Piece.pounds4, Location.boxLondon),
        (Piece.tradeIreland, Location.minorIreland),
        (Piece.tradeHaiti, Location.minorHaiti),
        (Piece.tradeCape, Location.minorCape),
        (Piece.tradeEgypt, Location.minorEgypt),
        (Piece.tradeMysore, Location.minorMysore),
        (Piece.fervorFrance, Location.turn14),
        (Piece.fervorGermany, Location.turn10),
        (Piece.fervorItaly, Location.turn8),
        (Piece.fervorAustria, Location.turn6),
        (Piece.fervorSpain, Location.turn10),
        (Piece.butNation, Location.greenAustria),
        (Piece.gameTurn, Location.turn6),
        (Piece.jewsGhetto, Location.boxJews),
        (Piece.napoleonAbdicates, Location.turn4),
        (Piece.nelson, Location.boxHighSeas),
        (Piece.fleetCoalition, Location.boxHighSeas),
        (Piece.ottomanArmy, ottomanArmyLocation),
        (Piece.terror, Location.discarded),
        (Piece.pope, Location.discarded),
        (Piece.lightInfantry, Location.lightInfantryBernadotte),
    ]);
    return state;
  }

  factory GameState.setup1813(Random random) {

    var state = GameState.setupCounterTray();

    final etats = PieceType.randomEtat.pieces;
    etats.shuffle(random);

    state.setupPieces([
        (Piece.napoleonB, Location.discarded),
        (Piece.napoleonN, Location.boxNapoleonsBed),
        (Piece.wifeJosephine, Location.discarded),
        (Piece.wifeMarriage, Location.nationAustria),
        (Piece.iconBeethoven, Location.boxLondon),
        (Piece.iconGoya, Location.boxLondon),
        (Piece.spanishUlcer, Location.nationSpain),
        (Piece.warBalkans, Location.discarded),
        (Piece.warCape, Location.discarded),
        (Piece.warCaucasus, Location.discarded),
        (Piece.warCorfu, Location.discarded),
        (Piece.warDenmark, Location.discarded),
        (Piece.warEgypt, Location.discarded),
        (Piece.warFinland, Location.discarded),
        (Piece.warHaiti, Location.discarded),
        (Piece.warIreland, Location.discarded),
        (Piece.warMalta, Location.discarded),
        (Piece.warMysore, Location.discarded),
        (Piece.warSenegal, Location.discarded),
        (Piece.warSerbia, Location.discarded),
        (Piece.warSwitzerland, Location.discarded),
        (Piece.warUsa, Location.discarded),
        (Piece.noWarRed0, Location.discarded),
        (Piece.noWarRed1, Location.discarded),
        (Piece.noWarRed2, Location.discarded),
        (Piece.noWarRed3, Location.discarded),
        (Piece.noWarRed4, Location.discarded),
        (Piece.noWarRed5, Location.discarded),
        (Piece.noWarGreen0, Location.discarded),
        (Piece.noWarGreen1, Location.discarded),
        (Piece.trafalgar, Location.discarded),
        (Piece.coronation, Location.discarded),
        (Piece.treatySanIldefonso, Location.discarded),
        (Piece.corpsFranceMoreau, Location.discarded),
        (Piece.corpsFranceDupont, Location.discarded),
        (Piece.corpsFranceLannes, Location.discarded),
        (Piece.corpsFranceMurat, Location.discarded),
        (Piece.corpsFranceBernadotte, Location.discarded),
        (Piece.corpsFranceBerthier, Location.cupFrenchCorps),
        (Piece.corpsFranceBessieres, Location.cupFrenchCorps),
        (Piece.corpsFranceDavoust, Location.cupFrenchCorps),
        (Piece.corpsFranceEugene, Location.cupFrenchCorps),
        (Piece.corpsFranceGrouchy, Location.cupFrenchCorps),
        (Piece.corpsFranceJunot, Location.cupFrenchCorps),
        (Piece.corpsFranceKellermann, Location.cupFrenchCorps),
        (Piece.corpsFranceKleber, Location.cupFrenchCorps),
        (Piece.corpsFranceMacDonald, Location.cupFrenchCorps),
        (Piece.corpsFranceMarmont, Location.cupFrenchCorps),
        (Piece.corpsFranceMassena, Location.cupFrenchCorps),
        (Piece.corpsFranceMortier, Location.cupFrenchCorps),
        (Piece.corpsFranceNey, Location.cupFrenchCorps),
        (Piece.corpsFranceOudinot, Location.cupFrenchCorps),
        (Piece.corpsFranceSaintCyr, Location.cupFrenchCorps),
        (Piece.corpsFranceSoult, Location.cupFrenchCorps),
        (Piece.corpsFranceSuchet, Location.cupFrenchCorps),
        (Piece.corpsFranceVictor, Location.cupFrenchCorps),
        (Piece.corpsDuchyFusiliers0, Location.poolPlayerForces),
        (Piece.corpsDuchyFusiliers1, Location.poolPlayerForces),
        (Piece.corpsDuchyGrenadiers, Location.poolPlayerForces),
        (Piece.corpsDuchyGrenzer, Location.poolPlayerForces),
        (Piece.corpsDuchyGuards0, Location.poolPlayerForces),
        (Piece.corpsDuchyGuards1, Location.poolPlayerForces),
        (Piece.corpsDuchyJager0, Location.poolPlayerForces),
        (Piece.corpsDuchyJager1, Location.poolPlayerForces),
        (Piece.corpsDuchyLandwehr, Location.poolPlayerForces),
        (Piece.corpsDuchyMarines0, Location.poolPlayerForces),
        (Piece.corpsDuchyMarines1, Location.poolPlayerForces),
        (Piece.corpsDuchyMusketeers, Location.poolPlayerForces),
        (Piece.corpsDuchyReserve, Location.poolPlayerForces),
        (Piece.russianWarFinland, Location.russianWarFinland),
        (Piece.russianWarCaucasus, Location.russianWarCaucasus),
        (Piece.russianWarBalkans, Location.russianWarBalkans),
        (Piece.russianWarCorfu, Location.russianWarCorfu),
        (Piece.etatWarsaw, Location.nationGermany),
        (Piece.corpsWarsaw, Location.cupFrenchCorps),
        (Piece.corpsNaples, Location.cupFrenchCorps),
        (Piece.corpsBavariaFrench, Location.cupFrenchCorps),
        (Piece.fundTreasury, Location.turn5),
        (Piece.fundAdmiralty, Location.turn5),
        (Piece.fundMinorWar, Location.turn5),
        (etats[0], Location.nationItaly),
        (etats[1], Location.discarded),
        (etats[2], Location.discarded),
        (etats[3], Location.discarded),
        (etats[4], Location.discarded),
        (etats[5], Location.discarded),
        (etats[6], Location.discarded),
        (Piece.scrollTilsitPrussia, Location.discarded),
        (Piece.scrollTilsitRussia, Location.discarded),
        (Piece.scrollBasel, Location.discarded),
        (Piece.austriaNeutral, Location.statusAustria),
        (Piece.prussiaNeutral, Location.statusPrussia),
        (Piece.russiaCoalition, Location.statusRussia),
        (Piece.swedenCoalition, Location.statusSweden),
        (Piece.spainCoalition, Location.statusSpain),
        (Piece.diplomatCoalitionCastlereagh, Location.boxLondon),
        (Piece.diplomatCoalitionMetternich, Location.boxLondon),
        (Piece.diplomatCoalitionRazumovsky, Location.boxLondon),
        (Piece.diplomatCoalitionHardenberg, Location.boxLondon),
        (Piece.diplomatFrenchTalleyrand, Location.greenGermany),
        (Piece.diplomatFrenchReinhard, Location.greenGermany),
        (Piece.diplomatFrench0, Location.boxHotel),
        (Piece.diplomatFrench1, Location.boxHotel),
        (Piece.diplomatFrench2, Location.boxHotel),
        (Piece.diplomatFrench3, Location.boxHotel),
        (Piece.diplomatFrench4, Location.boxHotel),
        (Piece.diplomatFrench5, Location.boxHotel),
        (Piece.diplomatFrench6, Location.boxHotel),
        (Piece.diplomatFrench7, Location.boxHotel),
        (Piece.religionUsurper, Location.boxFranceReligion),
        (Piece.corpsPrussiaBlucher, Location.poolNeutralForces),
        (Piece.corpsPrussiaBraunschweig, Location.poolNeutralForces),
        (Piece.corpsPrussiaKleist, Location.poolNeutralForces),
        (Piece.corpsPrussiaYorck, Location.poolNeutralForces),
        (Piece.corpsRussiaBagration, Location.poolPlayerForces),
        (Piece.corpsRussiaBarclay, Location.poolPlayerForces),
        (Piece.corpsRussiaBennigsen, Location.poolPlayerForces),
        (Piece.corpsRussiaKutuzov, Location.poolPlayerForces),
        (Piece.corpsRussiaPlatov, Location.poolPlayerForces),
        (Piece.corpsAustriaBellegarde, Location.poolNeutralForces),
        (Piece.corpsAustriaKarl, Location.poolNeutralForces),
        (Piece.corpsAustriaRadetzky, Location.poolNeutralForces),
        (Piece.corpsAustriaSchwarzenberg, Location.poolNeutralForces),
        (Piece.corpsSpainBlake, Location.poolPlayerForces),
        (Piece.corpsSpainPalafox, Location.poolPlayerForces),
        (Piece.corpsBritainBeresford, Location.poolPlayerForces),
        (Piece.corpsBritainUxbridge, Location.poolPlayerForces),
        (Piece.corpsBritainWellington, Location.poolPlayerForces),
        (Piece.pounds4, Location.discarded),
        (Piece.tradeIreland, Location.minorIreland),
        (Piece.tradeHaiti, Location.minorHaiti),
        (Piece.tradeCape, Location.minorCape),
        (Piece.tradeEgypt, Location.minorEgypt),
        (Piece.tradeMysore, Location.minorMysore),
        (Piece.fervorFrance, Location.turn11),
        (Piece.fervorGermany, Location.turn8),
        (Piece.fervorAustria, Location.turn2),
        (Piece.fervorItaly, Location.turn5),
        (Piece.fervorSpain, Location.turn3),
        (Piece.butNation, Location.greenGermany),
        (Piece.gameTurn, Location.turn12),
        (Piece.jewsEmancipation, Location.boxJews),
        (Piece.fraDiavolo, Location.nationItaly),
        (Piece.napoleonAbdicates, Location.turn9),
        (Piece.fleetCoalition, Location.boxHighSeas),
        (Piece.ottomanArmy, Location.minorBalkans),
        (Piece.corpsSweden, Location.poolPlayerForces),
        (Piece.fleetFrench, Location.discarded),
        (Piece.continentalSystem, Location.discarded),
        (Piece.jewsGhetto, Location.discarded),
        (Piece.nelson, Location.discarded),
        (Piece.terror, Location.discarded),
        (Piece.pope, Location.discarded),
        (Piece.lightInfantry, Location.lightInfantryBernadotte),
    ]);
    return state;
  }

  factory GameState.fromScenario(Scenario scenario, Random random) {
    GameState? gameState;
    switch (scenario) {
    case Scenario.year1792:
      gameState = GameState.setup1792();
    case Scenario.year1805:
      gameState = GameState.setup1805(random);
    case Scenario.year1813:
      gameState = GameState.setup1813(random);
    }
    return gameState;
  }
}

enum Choice {
  transferToMinorWarFund,
  transferToAdmiralty,
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
  cosmicDefeat,
  defeat,
  draw,
  victory,
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
  highPolitics,
  counterDiplomacy,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateHighPolitics extends PhaseState {
  bool purchasedHighPolitics = false;

  PhaseStateHighPolitics();

  PhaseStateHighPolitics.fromJson(Map<String, dynamic> json)
    : purchasedHighPolitics = json['purchasedHighPolitics'] as bool
    ;

  @override
  Map<String, dynamic> toJson() => {
    'purchasedHighPolitics': purchasedHighPolitics,
  };

  @override
  Phase get phase {
    return Phase.highPolitics;
  }
}

class PhaseStateCounterDiplomacy extends PhaseState {
  List<Piece> coalitionDebaters = <Piece>[];
  List<Piece> frenchDebaters = <Piece>[];
  Piece? charmer;

  PhaseStateCounterDiplomacy();

  PhaseStateCounterDiplomacy.fromJson(Map<String, dynamic> json)
    : coalitionDebaters = pieceListFromIndices(List<int>.from(json['coalitionDebaters']))
    , frenchDebaters = pieceListFromIndices(List<int>.from(json['frenchDebaters']))
    , charmer = pieceFromIndex(json['charmer'] as int?)
    ;
  
  @override
  Map<String, dynamic> toJson() => {
    'coalitionDebaters': pieceListToIndices(coalitionDebaters),
    'frenchDebaters': pieceListToIndices(frenchDebaters),
    'charmer': pieceToIndex(charmer)
  };

  @override
  Phase get phase {
    return Phase.counterDiplomacy;
  }
}

class FightMinorWarState {
  Piece? russianCorps;
  int subStep = 0;
  int pounds = 0;
  int diplomatInAustriaCount = 0;
  int diplomatInPrussiaCount = 0;
  bool russiaInvaded = false;

  FightMinorWarState();

  FightMinorWarState.fromJson(Map<String, dynamic> json) :
    russianCorps = pieceFromIndex(json['russianCorps'] as int?),
    subStep = json['subStep'] as int,
    pounds = json['pounds'] as int,
    diplomatInAustriaCount = json['austrianDiplomats'] as int,
    diplomatInPrussiaCount = json['prussianDiplomats'] as int,
    russiaInvaded = json['russiaInvaded'] as bool;

  Map<String, dynamic> toJson() => {
    'russianCorps': pieceToIndex(russianCorps),
    'subStep': subStep,
    'pounds': pounds,
    'austrianDiplomats': diplomatInAustriaCount,
    'prussianDiplomats': diplomatInPrussiaCount,
    'russiaInvaded': russiaInvaded,
  };
}

class FightNavalBattleState {
  int pounds = 0;

  FightNavalBattleState();

  FightNavalBattleState.fromJson(Map<String, dynamic> json) :
    pounds = json['pounds'] as int;

  Map<String, dynamic> toJson() => {
    'pounds': pounds,
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
  FightMinorWarState? _fightMinorWarState;
  FightNavalBattleState? _fightNavalBattleState;
  final Random _random;
  final int _gameId;

  Game(this._gameId, this._scenario, this._options, this._state, this._random);

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
      case Phase.highPolitics:
        _phaseState = PhaseStateHighPolitics.fromJson(phaseStateJson);
      case Phase.counterDiplomacy:
        _phaseState = PhaseStateCounterDiplomacy.fromJson(phaseStateJson);
      }
    }

    final fightMinorWarStateJson = json['fightMinorWar'];
    if (fightMinorWarStateJson != null) {
      _fightMinorWarState = FightMinorWarState.fromJson(fightMinorWarStateJson);
    }
    final fightNavalBattleStateJson = json['fightNavalBattle'];
    if (fightNavalBattleStateJson != null) {
      _fightNavalBattleState = FightNavalBattleState.fromJson(fightNavalBattleStateJson);
    }

    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
    if (_phaseState != null) {
      map['phase'] = _phaseState!.phase.index;
      map['phaseState'] = _phaseState!.toJson();
    }
    if (_fightMinorWarState != null) {
      map['fightMinorWar'] = _fightMinorWarState!.toJson();
    }
    if (_fightNavalBattleState != null) {
      map['fightNavalBattle'] = _fightNavalBattleState!.toJson();
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
      turnName(_state.currentTurn),
      _log);
  }

  Future<void> saveCurrentState() async {
    await GameDatabase.instance.setGameState(
      _gameId,
      jsonEncode(_state.toJson()),
      jsonEncode(randomToJson(_random)),
      _step, _subStep,
      _state.currentTurn,
      turnName(_state.currentTurn),
      jsonEncode(gameStateToJson()),
      _log);
  }

  Future<void> saveCompletedGame(GameOutcome outcome) async {
    await GameDatabase.instance.completeGame(_gameId, jsonEncode(outcome.toJson()));
  }
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

  Location randNation() {
    int die = rollD6();
    switch (die) {
    case 1:
      return Location.nationFrance;
    case 2:
      return Location.nationGermany;
    case 3:
      return Location.nationAustria;
    case 4:
      return Location.nationItaly;
    case 5:
      return Location.nationSpain;
    case 6:
      return _state.greenBoxNation(_state.pieceLocation(Piece.butNation));
    }
    return Location.nationFrance;
  }

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

  // Logging functions

  void adjustTreasuryFund(int amount) {
    _state.adjustTreasuryFund(amount);
    if (amount > 0) {
      logLine('> Treasury: +$amount => ${_state.treasuryFund}');
    } else {
      logLine('> Treasury: $amount => ${_state.treasuryFund}');
    }
  }

  void adjustMinorWarFund(int amount) {
    _state.adjustMinorWarFund(amount);
    if (amount > 0) {
      logLine('> Minor War Fund: +$amount => ${_state.minorWarFund}');
    } else {
      logLine('> Minor War Fund: $amount => ${_state.minorWarFund}');
    }
  }

  void adjustAdmiraltyFund(int amount) {
    _state.adjustTreasuryFund(amount);
    if (amount > 0) {
      logLine('> Admiralty Budget: +$amount => ${_state.admiraltyFund}');
    } else {
      logLine('> Admiralty Budget: $amount => ${_state.admiraltyFund}');
    }
  }

  void adjustNapoleonAbdicates(int amount) {
    _state.adjustNapoleonAbdicates(amount);
    if (amount > 0) {
      logLine('> Napoleon Abdicates: +$amount => ${_state.napoleonAbdicates}');
    } else {
      logLine('> Napoleon Abdicates: $amount => ${_state.napoleonAbdicates}');
    }
  }

  void adjustNationFervor(Location nation, int amount) {
    _state.adjustNationFervor(nation, amount);
    if (amount > 0) {
      logLine('> ${nation.desc} Fervor: +$amount => ${_state.nationFervor(nation)}');
    } else {
      logLine('> ${nation.desc} Fervor: $amount => ${_state.nationFervor(nation)}');
    }
  }

  void reduceFervorAfterCountryLeavesCoalition(Country country) {
    switch (country) {
    case Country.austria:
      adjustNationFervor(Location.nationAustria, -rollD6());
    case Country.prussia:
      adjustNationFervor(Location.nationGermany, -rollD6());
    case Country.russia:
      adjustNationFervor(Location.nationAustria, -rollD6());
      adjustNationFervor(Location.nationGermany, -rollD6());
    case Country.spain:
      adjustNationFervor(Location.nationSpain, -rollD6());
    case Country.sweden:
    }
  }

  void austriaJoinsCoalition() {
    if (_state.countryInCoalition(Country.austria)) {
      return;
    }
    logLine('> Austria joins the Coalition.');
    _state.austriaJoinsCoalition();
  }

  void prussiaJoinsCoalition() {
    if (_state.countryInCoalition(Country.prussia)) {
      return;
    }
    logLine('> Prussia joins the Coalition.');
    _state.prussiaJoinsCoalition();
  }

  void russiaJoinsCoalition() {
    logLine('> Russia joins the Coalition.');
    _state.russiaJoinsCoalition();
  }

  void spainJoinsCoalition() {
    logLine('> Spain joins the Coalition.');
    _state.spainJoinsCoalition();
  }

  void swedenJoinsCoalition() {
    logLine('> Sweden joins the Coalition.');
    _state.swedenJoinsCoalition();
  }

  void austriaLeavesCoalition() {
    if (!_state.countryInCoalition(Country.austria)) {
      return;
    }
    logLine('> Austria leaves the Coalition.');
    _state.austriaLeavesCoalition();
    adjustNationFervor(Location.nationAustria, -rollD6());
  }

  void prussiaLeavesCoalition() {
    if (!_state.countryInCoalition(Country.prussia)) {
      return;
    }
    logLine('> Prussia leaves the Coalition.');
    _state.prussiaLeavesCoalition();
    adjustNationFervor(Location.nationGermany, -rollD6());
  }

  void russiaLeavesCoalition() {
    if (!_state.countryInCoalition(Country.russia)) {
      return;
    }
    logLine('> Russia leaves the Coalition.');
    _state.russiaLeavesCoalition();
    int loss = -rollD6();
    adjustNationFervor(Location.nationAustria, loss);
    adjustNationFervor(Location.nationAustria, loss);
  }

  void austriaSurrenders() {
    if (!_state.countryInCoalition(Country.austria)) {
      return;
    }
    logLine('> Austria surrenders.');
    _state.austriaSurrenders();
    adjustNationFervor(Location.nationAustria, -rollD6());
  }

  void prussiaSurrenders() {
    if (!_state.countryInCoalition(Country.prussia)) {
      return;
    }
    logLine('> Prussia surrenders.');
    _state.prussiaSurrenders();
    adjustNationFervor(Location.nationGermany, -rollD6());
  }

  void russiaSurrenders() {
    if (!_state.countryInCoalition(Country.russia)) {
      return;
    }
    logLine('> Russia surrenders.');
    _state.russiaSurrenders();
    int loss = -rollD6();
    adjustNationFervor(Location.nationAustria, loss);
    adjustNationFervor(Location.nationAustria, loss);
  }

  void spainJoinsFrench() {
    if (_state.countryProFrench(Country.spain)) {
      return;
    }
    logLine('> Spain allies with France');
    _state.spainJoinsFrench();
  }

  set frenchReligion(Piece religion) {
    if (_state.frenchReligion != religion) {
      logLine('> French religious policy changes to ${_state.religionName(religion)}');
      _state.frenchReligion = religion;
    }
  }

  // High-Level Functions

  void randomEtatToHighPolitics() {
    final etatUnknown = randPiece(_state.piecesInLocation(PieceType.unknownEtat, Location.trayEtats));
    if (etatUnknown != null) {
      final etat = _state.pieceFlipSide(etatUnknown)!;
      _state.setPieceLocation(etat, Location.cupHighPolitics);
    }
  }

  bool resolveNavalBattle(int pounds) {
    if (pounds != 0) {
      adjustAdmiraltyFund(-pounds);
    }
    int dice = 0;
    int nelson = 0;
    if (_state.pieceLocation(Piece.nelson) == Location.boxHighSeas) {
      final rolls = roll3D6();
      dice = rolls.$1 + rolls.$2;
      nelson = rolls.$3;
    } else {
      final rolls = roll2D6();
      dice = rolls.$3;
    }
    int modifiers = 0;
    int modifier = pounds;
    if (modifier != 0) {
      logLine('> Funding: +$modifier');
      modifiers += modifier;
    }
    if (nelson != 0) {
      logLine('> Nelson: +$nelson');
      modifiers += nelson;
    }
    int total = dice + modifiers;
    logLine('> Total: $total');

    if (total >= 10) {
      logLine('> Coalition Victory');
      _state.setPieceLocation(Piece.fleetCoalition, Location.boxHighSeas);
      _state.setPieceLocation(Piece.fleetFrench, Location.trayMisc);
      adjustNapoleonAbdicates(1);
      return true;
    } else {
      logLine('> French Victory');
      _state.setPieceLocation(Piece.fleetFrench, Location.boxHighSeas);
      _state.setPieceLocation(Piece.fleetCoalition, Location.trayMisc);
      adjustNapoleonAbdicates(-1);
      return false;
    }
  }

  void discardRandomFrenchCorps(int corpsCount) {
    final candidates = <Piece>[];
    for (final corps in _state.piecesInLocation(PieceType.frenchAndAlliedCorps, Location.cupFrenchCorps)) {
      if (corps.isType(PieceType.mortalFrenchCorps) || corps == Piece.corpsWarsaw) {
        candidates.add(corps);
      }
    }
    for (int i = 0; candidates.isNotEmpty && i < corpsCount; ++i) {
      final corps = randPiece(candidates)!;
      logLine('> ${corps.desc} is destroyed.');
      _state.setPieceLocation(corps, Location.discarded);
      candidates.remove(corps);
    }
  }

  bool resolveMinorWar(Location minor, Piece? war, Location? russianWarBox, Piece? russianWar, bool lose, int pounds, Piece? russianCorps) {
    bool victory = false;
    if (pounds != 0) {
      adjustMinorWarFund(-pounds);
    }
    if (russianCorps != null) {
      _state.setPieceLocation(russianCorps, _state.currentTurnLocation);
    }
    if (lose) {
      logLine('> War not contested');
    } else {
      final rolls = roll2D6();
      int dice = rolls.$3;
      int modifiers = 0;
      int modifier = pounds;
      if (modifier != 0) {
        logLine('> Funding: +$modifier');
        modifiers += modifier;
      }
      if (_state.warLocationNaval(minor)) {
        final fleet = _state.rulingFleet;
        if (fleet == Piece.fleetCoalition) {
          logLine('> Royal Navy: +2');
          modifiers += 2;
        } else if (fleet == Piece.fleetFrench) {
          logLine('> French Fleet: -2');
          modifiers -= 2;
        }
      }
      if (minor == Location.minorRussia) {
        for (final box in LocationType.russianWar.locations) {
          if (_state.pieceInLocation(PieceType.russianWar, box)!.isType(PieceType.russianWarWon)) {
            logLine('> ${box.desc}: +1');
            modifiers += 1;
          } else {
            logLine('> ${box.desc}: -1');
            modifiers -= 1;
          }
        }
      }
      if (russianCorps != null) {
        logLine('> ${russianCorps.desc}: +1');
        modifiers += 1;
      }
      int total = dice + modifiers;
      logLine('> Total: $total');
      int warValue = _state.warLocationValue(minor);
      victory = total >= warValue;
      if (victory) {
        logLine('> Victory');
      } else {
        logLine('> Defeat');
      }
    }
    if (victory) {
      if (war != null) {
        _state.setPieceLocation(war, minor);
      }
      if (_state.warLocationStrategic(minor)) {
        adjustNapoleonAbdicates(1);
      }
      if (russianWarBox != null) {
        _state.setPieceLocation(russianWar!, russianWarBox);
      }
      if (minor == Location.minorRussia) {
        final napoleonLocation = _state.pieceLocation(Piece.napoleonN);
        _state.setPieceLocation(Piece.napoleonV, napoleonLocation);
        _state.setPieceLocation(Piece.napoleonN, Location.discarded);
        if ([Location.statusAustria, Location.statusPrussia, Location.statusRussia].contains(_state.pieceLocation(Piece.wifeMarriage))) {
          _state.setPieceLocation(Piece.wifeMarriage, Location.discarded);
        }
        if (_state.pieceLocation(Piece.prussiaCoalition) != Location.statusPrussia) {
          prussiaJoinsCoalition();
        }
        if (_state.pieceLocation(Piece.austriaCoalition) != Location.statusAustria) {
          austriaJoinsCoalition();
        }
        logLine('> Bavaria joins the Coalition');
        _state.setPieceLocation(Piece.corpsBavariaFrench, Location.discarded);
        _state.setPieceLocation(Piece.corpsBavariaAustrian, Location.poolPlayerForces);
        adjustNapoleonAbdicates(1);
        adjustNationFervor(Location.nationFrance, -rollD6());
        adjustNationFervor(Location.nationGermany, -rollD6());
        adjustNationFervor(Location.nationAustria, -rollD6());
        int dice = roll2D6().$3;
        discardRandomFrenchCorps(dice);
      }
    } else {
      if (war != null) {
        _state.setPieceLocation(_state.pieceFlipSide(war)!, minor);
      }
      if (_state.warLocationCommercial(minor)) {
        final trade = _state.pieceInLocation(PieceType.trade, minor);
        if (trade != null) {
          _state.setPieceLocation(trade, Location.trayGold);
        }
      }
      if (_state.warLocationStrategic(minor)) {
        adjustNapoleonAbdicates(-1);
      }
      if (russianWarBox != null) {
        _state.setPieceLocation(_state.pieceFlipSide(russianWar!)!, russianWarBox);
      }
      if (minor == Location.minorRussia) {
        _state.setPieceLocation(Piece.napoleonV, Location.cupHighPolitics);
        russiaSurrenders();
        adjustNapoleonAbdicates(-1);  // Correct? Done once already for being a strategic war
        adjustNationFervor(Location.nationFrance, 5);
        adjustNationFervor(Location.nationGermany, 5);
        adjustNationFervor(Location.nationAustria, 5);
        int die = rollD6();
        discardRandomFrenchCorps(die);
      }
    }
    return victory;
  }

  List<Country> get candidateAlignCountries {
    bool austriaNoDiplomats = _state.piecesInLocationCount(PieceType.frenchDiplomat, Location.greenAustria) == 0;
    bool prussiaNoDiplomats = _state.piecesInLocationCount(PieceType.frenchDiplomat, Location.greenAustria) == 0;
    final candidates = <Country>[];
    for (final country in [Country.prussia, Country.austria, Country.russia]) {
      if (_state.countryNeutral(country) || _state.countrySurrendered(country)) {
        switch (country) {
        case Country.austria:
          if (austriaNoDiplomats) {
            candidates.add(Country.austria);
          }
        case Country.prussia:
          if (prussiaNoDiplomats) {
            candidates.add(Country.prussia);
          }
        case Country.russia:
          if (austriaNoDiplomats && prussiaNoDiplomats) {
            candidates.add(Country.russia);
          }
        case Country.spain:
        case Country.sweden:
        }
      }
    }
    return candidates;
  }

  List<Piece> get candidateAlignCountryDiplomats {
    final countries = candidateAlignCountries;
    final greenBoxes = <Location>[];
    for (final country in countries) {
      Location? greenBox;
      if ([Country.austria, Country.russia].contains(country) {
        greenBox = Location.greenAustria;
      } else {
        greenBox = Location.greenGermany;
      }
      if (!greenBoxes.contains(greenBox)) {
        greenBoxes.add(greenBox);
      }
    }
    final candidates = <Piece>[];
    for (final diplomat in PieceType.diplomat.pieces) {
      final location = _state.pieceLocation(diplomat);
      if (location == Location.boxLondon || greenBoxes.contains(location)) {
        candidates.add(diplomat);
      }
    }
    return candidates;
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;

    logLine('# Game Over');

    switch (outcome.result) {
    case GameResult.cosmicDefeat:
      logLine('### Cosmic Defeat');
    case GameResult.defeat:
      logLine('### Defeat');
    case GameResult.draw:
      logLine('### Draw');
    case GameResult.victory:
      logLine('### Victory');
    }
  }

  // Sequence Helpers

  (bool, int) fightNavalBattle() {
    _fightNavalBattleState ??= FightNavalBattleState();
    final localState = _fightNavalBattleState!;
    if (choicesEmpty()) {
      setPrompt('Select Pounds to spend from Admiralty Fund on Turn Track');
      for (int i = 0; i <= 2; ++i) {
        if (_state.admiraltyFund >= i) {
          locationChoosable(_state.turnLocation(i));
        }
      }
      throw PlayerChoiceException();
    }
    localState.pounds = selectedLocation()!.index - LocationType.turn.firstIndex;
    clearChoices();
    bool battleResult = false;
    battleResult = resolveNavalBattle(localState.pounds);
    int pounds = localState.pounds;
    _fightNavalBattleState = null;
    return (battleResult, pounds);
  }

  void fightMinorWar(Location minor, Piece? war, Location? russianWarBox, Piece? russianWar) {
    _fightMinorWarState ??= FightMinorWarState();
    final localState = _fightMinorWarState!;

    if (localState.russiaInvaded) {
      minor = Location.minorRussia;
      war = null;
      russianWarBox = null;
      russianWar = null;
    }

    while (localState.subStep >= 0 && localState.subStep <= 7) {
      if (localState.subStep == 0) { // Decide how much to spend
        if (choicesEmpty()) {
          setPrompt('Select Pounds to spend from Minor War Fund on Turn Track');
          for (int i = 0; i <= _state.minorWarFund; ++i) {
            locationChoosable(_state.turnLocation(i));
          }
          throw PlayerChoiceException();
        }
        localState.pounds = selectedLocation()!.index - LocationType.turn.firstIndex;
        clearChoices();
        localState.subStep = 1;
      }

      if (localState.subStep == 1) {  // Decide whether to challenge the French Fleet
        if (_state.warLocationNaval(minor) && _state.rulingFleet == Piece.fleetFrench) {
          if (choicesEmpty()) {
            setPrompt('Challenge the French Fleet?');
            choiceChoosable(Choice.yes, true);
            choiceChoosable(Choice.no, true);
            throw PlayerChoiceException();
          }
          if (checkChoice(Choice.yes)) {
            logLine('> Britain challenges French control of the High Seas.');
            localState.subStep = 2;
          } else {
            localState.subStep = 3;
          }
          clearChoices();
        } else {
          localState.subStep = 3;
        }
      }

      if (localState.subStep == 2) { // Fight Naval Battle
        fightNavalBattle();
        localState.subStep = 3;
      }

      if (localState.subStep == 3) { // Decide whether to send Russian troops
        if (_state.warLocationRussian(minor) || minor == Location.minorRussia) {
          if (choicesEmpty()) {
            setPrompt('Select Russian Corps to Fight Minor War');
            for (final corps in _state.piecesInLocation(PieceType.russianCorps, Location.poolPlayerForces)) {
              pieceChoosable(corps);
            }
            choiceChoosable(Choice.next, true);
            throw PlayerChoiceException();
          }
          localState.russianCorps = selectedPiece();
          clearChoices();
        }
        localState.subStep = 4;
      }

      bool lose = false;

      if (localState.subStep == 4) { // Choose to Lose
        if (choicesEmpty()) {
          setPrompt('Lose War automatically?');
          choiceChoosable(Choice.yes, true);
          choiceChoosable(Choice.no, true);
          throw PlayerChoiceException();
        }
        if (checkChoice(Choice.yes)) {
          lose = true;
        }
        clearChoices();
        localState.subStep = 5;
      }

      if (localState.subStep == 5) { // Resolve War
        int oldRussianWarCount = _state.russianWarCount;
        resolveMinorWar(minor, war, russianWarBox, russianWar, lose, localState.pounds, localState.russianCorps);
        int newRussianWarCount = _state.russianWarCount;
        if (oldRussianWarCount < 4 && newRussianWarCount == 4) {
          logLine('### Napoleon Invades Russia!');
          _state.setPieceLocation(Piece.continentalSystem, Location.discarded);
          _state.setPieceLocation(Piece.scrollTilsitPrussia, Location.discarded);
          _state.setPieceLocation(Piece.scrollTilsitRussia, Location.discarded);
          _state.setPieceLocation(Piece.ottomanArmy, Location.discarded);
          _state.setPieceLocation(Piece.paris, Location.nationFrance);
          if (_state.pieceLocation(Piece.russiaCoalition) != Location.statusRussia) {
            logLine('> Russia joins the Coalition.');
            if (_state.pieceLocation(Piece.wifeMarriage) == Location.statusRussia) {
              _state.setPieceLocation(Piece.wifeMarriage, Location.discarded);
            }
            russiaJoinsCoalition();
          }
          localState.diplomatInAustriaCount = _state.piecesInLocationCount(PieceType.frenchDiplomat, Location.greenAustria);
          localState.diplomatInPrussiaCount = _state.piecesInLocationCount(PieceType.frenchDiplomat, Location.greenGermany);
          if (_state.piecesInLocationCount(PieceType.austrianAndAlliedCorps, Location.poolNeutralForces) == 0) {
            localState.diplomatInAustriaCount = 0;
          }
          if (_state.piecesInLocationCount(PieceType.prussianCorps, Location.poolNeutralForces) == 0) {
            localState.diplomatInPrussiaCount = 0;
          }
          localState.subStep = 6;
        } else {
          localState.subStep = 8;
        }
      }

      if (localState.subStep == 6) { // Napoleon invades Russia - Delay Corps
        while (localState.diplomatInAustriaCount + localState.diplomatInPrussiaCount > 0) {
          PieceType corpsType = localState.diplomatInAustriaCount > 0 ? PieceType.austrianAndAlliedCorps : PieceType.prussianCorps;
          if (choicesEmpty()) {
            if (localState.diplomatInAustriaCount > 0) {
              setPrompt('Select Austrian Corps that has joined the invasion.');
            } else {
              setPrompt('Select Prussian Corps that has joined the invasion.');
            }
            for (final corps in _state.piecesInLocation(corpsType, Location.poolNeutralForces)) {
              pieceChoosable(corps);
            }
            throw PlayerChoiceException();
          }
          final corps = selectedPiece()!;
          logLine('> ${corps.desc} is dragooned into the Russian campaign.');
          if (localState.diplomatInAustriaCount > 0) {
            localState.diplomatInAustriaCount -= 1;
            if (_state.piecesInLocationCount(corpsType, Location.poolNeutralForces) == 0) {
              localState.diplomatInAustriaCount = 0;
            }
          } else {
            localState.diplomatInPrussiaCount -= 1;
            if (_state.piecesInLocationCount(corpsType, Location.poolNeutralForces) == 0) {
              localState.diplomatInPrussiaCount = 0;
            }
          }
          clearChoices();
        }
        localState.subStep = 7;
      }

      if (localState.subStep == 7) { // Napoleon invades Russia
        localState.russiaInvaded = true;
        localState.subStep = 0;
        localState.pounds = 0;
        localState.russianCorps = null;
      }
    }

    _fightMinorWarState = null;
  }

  // Printed Events

  void valmy() {
    logLine('> Revolutionary France triumphs at Valmy');
    _state.setPieceLocation(Piece.warSwitzerland, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.warCape, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.scrollRussianNobility, Location.statusRussia);
    randomEtatToHighPolitics();
  }

  void whiffOfGrapeshot() {
    logLine('> Republicans led by Napoléon Bonaparte defeat monarchist mobs');
    _state.setPieceLocation(Piece.napoleonB, Location.boxNapoleonsBed);
    _state.setPieceLocation(Piece.wifeJosephine, Location.boxNapoleonsBed);
    _state.setPieceLocation(Piece.warHaiti, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.warEgypt, Location.cupHighPolitics);
    randomEtatToHighPolitics();
  }

  void spitheadAndTheNore() {
    logLine('> Royal Navy sailors mutiny over pay');
    _state.setPieceLocation(Piece.warSenegal, Location.cupHighPolitics);
    randomEtatToHighPolitics();
  }

  void peaceOfAmiens() {
    logLine('> Addington takes Britain out of the war against Napoleon');
    _state.setupPieceType(PieceType.britishCorps, _state.currentTurnLocation);
    randomEtatToHighPolitics();
    _state.setPieceLocation(Piece.corpsBavariaFrench, Location.cupHighPolitics);
  }

  void sultanSelim3() {
    logLine('> Sultan Selim Ⅲ attacks Russia');
    _state.setPieceLocation(Piece.warCaucasus, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.warSerbia, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.warBalkans, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.ottomanArmy, Location.minorBalkans);
  }

  void continentalSystem() {
    logLine('> Napoleon embargoes British goods');
    _state.setPieceLocation(Piece.continentalSystem, Location.boxHighSeas);
    _state.setPieceLocation(Piece.noWarRed0, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.etatWarsaw, Location.cupHighPolitics);
    adjustNationFervor(Location.nationFrance, 5);
    adjustNationFervor(Location.nationGermany, 5);
    adjustNationFervor(Location.nationItaly, 5);
  }

  void kingdomOfNaples() {
    logLine('> Napoleon name Murat as King of Naples');
    _state.setPieceLocation(Piece.corpsFranceMurat, Location.discarded);
    _state.setPieceLocation(Piece.corpsNaples, Location.cupFrenchCorps);
  }

  void notTonightJosephine() {
    logLine('> Napoleon separates from Josephine');
    _state.setPieceLocation(Piece.wifeJosephine, Location.discarded);
    _state.setPieceLocation(Piece.noWarRed1, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.noWarRed2, Location.cupHighPolitics);
  }

  void frankfurtProposals() {
    if (choicesEmpty()) {
      logLine('> The Coalition offers Napoleon peace');
      setPrompt('Offer Napoleon a compromise peace?');
      choiceChoosable(Choice.yes, true);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    if (checkChoiceAndClear(Choice.yes)) {
      int die = rollD6();
      int modifiers = 0;
      for (final warLost in PieceType.warLost.pieces) {
        final location = _state.pieceLocation(warLost);
        if (location.isType(LocationType.minor)) {
          logLine('> ${location.desc}: +1');
          modifiers += 1;
        }
      }
      int total = die + modifiers;
      logLine('> Total: $total');
      if (total >= 6) {
        logLine('> Napoleon accepts the peace offered by the Coalition');
        throw GameOverException(GameResult.draw);
      } else {
        logLine('> Napoleon rejects Coalition offer of peace');
      }
    }
    if (checkChoiceAndClear(Choice.no)) {
      logLine('> Britain refuses to offer Napoleon peace');
      russiaLeavesCoalition();
      prussiaLeavesCoalition();
      austriaLeavesCoalition();
    }
    var pieces = _state.piecesInLocation(PieceType.all, Location.trayPolitics);
    for (final piece in pieces) {
      _state.setPieceLocation(piece, Location.cupHighPolitics);
    }
    pieces = _state.piecesInLocation(PieceType.unknownEtat, Location.trayEtats);
    for (final piece in pieces) {
      _state.setPieceLocation(piece, Location.cupHighPolitics);
    }
  }

  void secondCoalition() {
    logLine('> Russia abandons its historic neutrality');
    _state.setPieceLocation(Piece.scrollRussianNobility, Location.discarded);
  }

  void louisianaPurchase() {
    logLine('> Napoleon sells North American territory to the United States');
    _state.setPieceLocation(Piece.trafalgar, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.warUsa, Location.cupHighPolitics);
    randomEtatToHighPolitics();
  }

  // High Politics Chits

  void warBalkans(Piece war) {
    logLine('### Russia battles Ottoman Turkey in the Balkans');
    fightMinorWar(Location.minorBalkans, war, Location.russianWarBalkans, Piece.russianWarBalkans);
  }

  void warCape(Piece war) {
    logLine('### Britain attempts to seize Dutch Cape trading post');
    fightMinorWar(Location.minorCape, war, null, null);
  }

  void warCaucasus(Piece war) {
    logLine('### Russia battles Persian Empire in the Caucasus');
    fightMinorWar(Location.minorCaucasus, war, Location.russianWarCaucasus, Piece.russianWarCaucasus);
  }

  void warCorfu(Piece war) {
    logLine('### War breaks out over Corfu');
    fightMinorWar(Location.minorCorfu, war, Location.russianWarCorfu, Piece.russianWarCorfu);
  }

  void warDenmark(Piece war) {
    logLine('### Britain attempts to neutralize the Danish fleet');
    fightMinorWar(Location.minorDenmark, war, null, null);
    if (_state.pieceLocation(Piece.warFinland) == Location.trayPolitics) {
      _state.setPieceLocation(Piece.warFinland, Location.cupHighPolitics);
    }
    if (_state.pieceLocation(Piece.warLostDenmark) == Location.minorDenmark && _state.pieceLocation(Piece.fleetFrench) != Location.discarded) {
      _state.setPieceLocation(Piece.fleetFrench, Location.boxHighSeas);
      _state.setPieceLocation(Piece.fleetCoalition, Location.trayMisc);
    }
  }

  void warEgypt(Piece war) {
    logLine('### France launches expedition to Egypt');
    fightMinorWar(Location.minorEgypt, war, null, null);
    _state.setPieceLocation(Piece.coronation, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.warMalta, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.warCorfu, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.warMysore, Location.cupHighPolitics);
    _state.setPieceLocation(_state.napoleon, Location.minorEgypt);
    _state.setPieceLocation(Piece.scrollRussianNobility, Location.discarded);
  }

  void warFinland(Piece war) {
    logLine('### Russia invades Finland');
    fightMinorWar(Location.minorFinland, war, Location.russianWarFinland, Piece.russianWarFinland);
    logLine('> Bernadotte appointed King of Sweden');
    _state.setPieceLocation(Piece.corpsFranceBernadotte, Location.discarded);
    _state.setPieceLocation(Piece.corpsSweden, Location.poolPlayerForces);
    swedenJoinsCoalition();
    _state.setPieceLocation(Piece.noWarRed3, Location.cupHighPolitics);
  }

  void warHaiti(Piece war) {
    logLine('### Slaves revolt in Haïti');
    fightMinorWar(Location.minorHaiti, war, null, null);
  }

  void warIreland(Piece war) {
    logLine('### France invades Ireland');
    fightMinorWar(Location.minorIreland, war, null, null);
  }

  void warMalta(Piece war) {
    logLine('### France seizes Malta');
    fightMinorWar(Location.minorMalta, war, null, null);
  }

  void warMysore(Piece war) {
    logLine('### Tippoo of Mysore and British East India Company at war');
    fightMinorWar(Location.minorMysore, war, null, null);
    randomEtatToHighPolitics();
  }

  void warSerbia(Piece war) {
    logLine('### Serbia revolts against the Ottoman Sultans');
    fightMinorWar(Location.minorSerbia, war, null, null);
  }

  void warSenegal(Piece war) {
    logLine('### British forces invade Senegal');
    fightMinorWar(Location.minorSenegal, war, null, null);
  }

  void warSwitzerland(Piece war) {
    logLine('### France invades Switzerland');
    fightMinorWar(Location.minorSwitzerland, war, null, null);
    _state.setPieceLocation(Piece.warIreland, Location.cupHighPolitics);
  }

  void warUsa(Piece war) {
    logLine('### Britain goes to war with the U.S.A.');
    adjustTreasuryFund(3);
    fightMinorWar(Location.minorUsa, war, null, null);
  }

  void noWar(Piece piece) {
    _state.setPieceLocation(piece, Location.discarded);
  }

  void formEtat(Piece etat) {
    logLine('### État client');
    while (true) {
      final nation = randNation();
      if (nation != Location.nationFrance && (nation != Location.nationSpain || _state.countryProFrench(Country.spain))) {
        _state.formEtatInNation(etat, nation);
        logLine('> État client created in ${nation.desc}');
      }
    }
  }

  void coronation(Piece piece) {
    logLine('### Napoleon crowns himself Emperor of the French');
    final napoleonLocation = _state.pieceLocation(Piece.napoleonB);
    _state.setPieceLocation(Piece.napoleonB, Location.discarded);
    _state.setPieceLocation(Piece.napoleonN, napoleonLocation);
    int die = rollD6();
    adjustNationFervor(Location.nationFrance, die);
    die = rollD6();
    adjustNationFervor(Location.nationGermany, -die);
    die = rollD6();
    adjustNationFervor(Location.nationAustria, -die);
    die = rollD6();
    adjustNationFervor(Location.nationItaly, -die);
    die = rollD6();
    adjustNationFervor(Location.nationSpain, -die);
    frenchReligion = Piece.religionCatholic;
    _state.setPieceLocation(Piece.terror, Location.discarded);
    austriaJoinsCoalition();
    russiaJoinsCoalition();
    prussiaJoinsCoalition();
    randomEtatToHighPolitics();
    randomEtatToHighPolitics();
    _state.setPieceLocation(Piece.warDenmark, Location.cupHighPolitics);
    _state.setPieceLocation(Piece.spanishUlcer, Location.cupHighPolitics);
    _state.setPieceLocation(piece, Location.discarded);
  }

  void duchyWarsaw(Piece piece) {
    logLine('### France resurrects the Polish State');
    _state.formEtatInNation(piece, Location.nationGermany);
    _state.setPieceLocation(Piece.corpsWarsaw, Location.cupFrenchCorps);
  }

  void spanishUlcer(Piece piece) {
    logLine('### Napoleon forces Spain to accept Joseph Bonaparte as king');
    _state.setPieceLocation(piece, Location.nationSpain);
    _state.setPieceLocation(Piece.spainFrench, Location.discarded);
    spainJoinsCoalition();
    if (_state.pieceLocation(Piece.wifeMarriage) == Location.nationSpain) {
      _state.setPieceLocation(Piece.wifeMarriage, Location.discarded);
    }
    _state.setPieceLocation(Piece.treatySanIldefonso, Location.discarded);
    adjustNationFervor(Location.nationSpain, -10);
    _state.setupPieceType(PieceType.spanishCorps, Location.poolPlayerForces);
  }

  void trafalgar(Piece piece) {
    logLine('### Battle of Trafalgar');
    final results = fightNavalBattle();
    bool battleVictory = results.$1;
    int pounds = results.$2;
    logLine('> Nelson is shot by a French sniper');
    _state.setPieceLocation(Piece.nelson, Location.discarded);
    if (battleVictory) {
      _state.setPieceLocation(Piece.fleetFrench, Location.discarded);
      _state.setPieceLocation(piece, Location.boxHighSeas);
    } else {
      _state.setPieceLocation(piece, Location.discarded);
      logLine('> Napoleon invades England');
      int die = rollD6();
      int total = die;
      if (pounds != 0) {
        logLine('> Trafalgar: ${-pounds}');
        total -= pounds;
      }
      logLine('> Total: $total');
      if (total <= 3) {
        logLine('> Invasion is defeated');
        final corps = _state.piecesInLocation(PieceType.mortalFrenchCorps, Location.cupFrenchCorps);
        corps.shuffle(_random);
        for (int i = 0; i < 3 && i < corps.length; ++i) {
          logLine('> ${corps[i].desc} is destroyed');
          _state.setPieceLocation(corps[i], Location.discarded);
        }
        _state.setPieceLocation(Piece.fleetFrench, Location.boxHighSeas);
      } else {
        logLine('> France conquers England');
        throw GameOverException(GameResult.cosmicDefeat);
      }
    }
  }

  void treatyOfSanIldefonso(Piece piece) {
    logLine('> Treaty of San Ildefonso is signed');
    _state.setPieceLocation(piece, Location.nationSpain);
    _state.setupPieceType(PieceType.spanishCorps, Location.cupFrenchCorps);
    for (final corps in _state.piecesInLocation(PieceType.duchyCorps, Location.nationSpain)) {
      _state.setPieceLocation(corps, Location.poolPlayerForces);
    }
    final etat = _state.pieceInLocation(PieceType.etat, Location.nationSpain);
    if (etat != null) {
      _state.setPieceLocation(etat, Location.discarded);
    }
  }

  void drawHighPoliticsChit() {
    final eventHandlers = {
      Piece.warBalkans: warBalkans,
      Piece.warCape: warCape,
      Piece.warCaucasus: warCaucasus,
      Piece.warCorfu: warCorfu,
      Piece.warDenmark: warDenmark,
      Piece.warEgypt: warEgypt,
      Piece.warFinland: warFinland,
      Piece.warHaiti: warHaiti,
      Piece.warIreland: warIreland,
      Piece.warMalta: warMalta,
      Piece.warMysore: warMysore,
      Piece.warSerbia: warSerbia,
      Piece.warSenegal: warSenegal,
      Piece.warSwitzerland: warSwitzerland,
      Piece.warUsa: warUsa,
      Piece.noWarGreen0: noWar,
      Piece.noWarGreen1: noWar,
      Piece.noWarRed0: noWar,
      Piece.noWarRed1: noWar,
      Piece.noWarRed2: noWar,
      Piece.noWarRed3: noWar,
      Piece.noWarRed4: noWar,
      Piece.noWarRed5: noWar,
      Piece.etat0: formEtat,
      Piece.etat1: formEtat,
      Piece.etat2: formEtat,
      Piece.etat3: formEtat,
      Piece.etat4: formEtat,
      Piece.etat5: formEtat,
      Piece.etat6: formEtat,
      Piece.etat7: formEtat,
      Piece.etat8: formEtat,
      Piece.coronation: coronation,
      Piece.etatWarsaw: duchyWarsaw,
      Piece.spanishUlcer: spanishUlcer,
      Piece.trafalgar: trafalgar,
      Piece.treatySanIldefonso: treatyOfSanIldefonso,
    };
    final pieces = _state.piecesInLocation(PieceType.all, Location.cupHighPolitics);
    if (pieces.isEmpty) {
      return;
    }
    final piece = randPiece(pieces)!;
    final eventHandler = eventHandlers[piece]!;
    eventHandler(piece);
  }

  // Sequence Steps

  String turnName(int turn) {
    const turnNames = [
      '',
      '1792-1794',
      '1795-1796',
      '1797-1798',
      '1799',
      '1800-1804',
      '1805',
      '1806-1807',
      '1808',
      'Early 1809',
      'Late 1809',
      '1810-1812',
      'Early 1813',
      'Late 1813',
      '1814',
      '1815-1817',
      '1818-1821',
    ];
    return turnNames[turn];
  }

  void turnBegin() {
    logLine('# Turn ${turnName(_state.currentTurn)}');
  }

  void highPoliticsPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to High Politics Phase.');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## High Politics Phase');
    _phaseState = PhaseStateHighPolitics();
  }

  void highPoliticsPhaseGetMoney() {
    int total = 0;
    logLine('### Get Money');
    int amount = _state.londonMoney;
    logLine('> London: $amount');
    total += amount;
    if (_state.countryInCoalition(Country.austria)) {
      logLine('> Austria: 2');
      total += 2;
    }
    if (_state.countryInCoalition(Country.prussia)) {
      logLine('> Prussia: 2');
      total += 2;
    }
    for (final icon in _state.piecesInLocation(PieceType.icon, Location.boxLondon)) {
      logLine('> ${icon.desc}: 1');
      total += 1;
    }
    for (final trade in PieceType.trade.pieces) {
      final location = _state.pieceLocation(trade);
      if (location.isType(LocationType.minor)) {
        logLine('> ${location.desc}: 1');
        total += 1;
      }
    }
    adjustTreasuryFund(total);
    if (_state.continentalSystemActive) {
      logLine('> Continental System');
      int die = rollD6();
      adjustTreasuryFund(-die);
    }
  }

  void highPoliticsPhaseAdjustBudgets() {
    if (_subStep == 0) {
      logLine('### Transfer Pounds');
      _subStep = 1;
    }
    while (true) {
      if (choicesEmpty()) {
        setPrompt('Transfer Pounds');
        choiceChoosable(Choice.transferToMinorWarFund, _state.treasuryFund > 0 && _state.minorWarFund < 16);
        choiceChoosable(Choice.transferToAdmiralty, _state.treasuryFund > 0 && _state.admiraltyFund < 16);
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      if (checkChoiceAndClear(Choice.transferToMinorWarFund)) {
        adjustTreasuryFund(-1);
        adjustMinorWarFund(1);
      }
      if (checkChoiceAndClear(Choice.transferToAdmiralty)) {
        adjustTreasuryFund(-1);
        adjustAdmiraltyFund(-1);
      }
    }
  }

  void highPoliticsPhaseButNation() {
    final nation = _state.turnButNation;
    _state.setPieceLocation(Piece.butNation, nation);
    logLine('### But Nation');
    logLine('> ${nation.desc}');
  }

  void highPoliticsPhaseTurnEvent0() {
    final turnEvents = {
      1: valmy,
      2: whiffOfGrapeshot,
      3: spitheadAndTheNore,
      5: peaceOfAmiens,
      6: sultanSelim3,
      7: continentalSystem,
      8: kingdomOfNaples,
      9: notTonightJosephine,
      13: frankfurtProposals, 
    };
    final eventHandler = turnEvents[_state.currentTurn - 1];
    if (eventHandler == null) {
      return;
    }
    eventHandler();
  }

  void highPoliticsPhaseTurnEvent1() {
    final turnEvents = {
      3: secondCoalition,
      5: louisianaPurchase,
    };
    final eventHandler = turnEvents[_state.currentTurn - 1];
    if (eventHandler == null) {
      return;
    }
    eventHandler();
  }

  void highPoliticsPhaseDrawChit0() {
    if (_state.currentTurn < 16) {
      drawHighPoliticsChit();
    }
  }

  void highPoliticsPhaseDrawChit1() {
    if (_state.currentTurn < 14) {
      drawHighPoliticsChit();
    }
  }

  void highPoliticsPhaseDrawChit2() {
    if (_state.currentTurn >= 6 && _state.currentTurn < 9) {
      drawHighPoliticsChit();
    }
  }

  void highPoliticsPhasePurchaseChit() {
    final localState = _phaseState as PhaseStateHighPolitics;
    if (choicesEmpty()) {
      setPrompt('Invest in High Politics?');
      choiceChoosable(Choice.yes, _state.treasuryFund >= 3);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    if (checkChoiceAndClear(Choice.no)) {
      return;
    }
    logLine('> Britain invests in High Politics.');
    adjustTreasuryFund(-3);
    localState.purchasedHighPolitics = true;
  }

  void highPoliticsPhaseDrawPurchasedChit() {
    final localState = _phaseState as PhaseStateHighPolitics;
    if (!localState.purchasedHighPolitics) {
      return;
    }
    drawHighPoliticsChit();
  }

  void highPoliticsPhaseEnd() {
    _phaseState = null;
  }

  void diplomacyPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Diplomacy Phase.');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Diplomacy Phase');
  }

  void diplomacyPhaseDiplomats() {
    if (_state.piecesInLocationCount(PieceType.frenchDiplomat, Location.boxHotel) == 0) {
      return;
    }
    logLine('### French Diplomats');
    final overstackedDiplomats = <Piece>[];
    for (int i = 0; i < 2; ++i) {
      if (_state.piecesInLocationCount(PieceType.frenchDiplomat, Location.boxHotel) == 0) {
        break;
      }
      Piece? diplomat;
      if (_state.pieceLocation(Piece.diplomatFrenchTalleyrand) == Location.boxHotel) {
        diplomat = Piece.diplomatFrenchTalleyrand;
      } else if (_state.pieceLocation(Piece.diplomatFrenchReinhard) == Location.boxHotel) {
        diplomat = Piece.diplomatFrenchReinhard;
      } else {
        diplomat = _state.piecesInLocation(PieceType.frenchDiplomat, Location.boxHotel)[0];
      }
      final nation = randNation();
      final greenBox = _state.nationGreenBox(nation);
      logLine('> ${diplomat.desc} is sent to ${nation.desc}.');
      _state.setPieceLocation(diplomat, greenBox);
      if (_state.piecesInLocationCount(PieceType.frenchDiplomat, greenBox) > 2) {
        overstackedDiplomats.add(diplomat);
      }
    }
    for (final diplomat in overstackedDiplomats) {
      logLine('> ${diplomat.desc} returns to the Hôtel.');
      _state.setPieceLocation(diplomat, Location.boxHotel);
    }
  }

  void counterDiplomacyPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Counter‐Diplomacy Phase.');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Counter‐Diplomacy Phase');
    _phaseState = PhaseStateCounterDiplomacy();
  }

  void counterDiplomacyPhaseDebate() {
    final phaseState = _phaseState as PhaseStateCounterDiplomacy;
    if (_subStep == 0) { // Select debaters
      while (true) {
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          phaseState.coalitionDebaters.clear();
          phaseState.frenchDebaters.clear();
          continue;
        }
        if (choicesEmpty()) {
          setPrompt('Select Coalition Diplomat for Debate');
          if (_state.treasuryFund > phaseState.coalitionDebaters.length) {
            for (final diplomat in _state.piecesInLocation(PieceType.coalitionDiplomat, Location.boxLondon)) {
              if (!phaseState.coalitionDebaters.contains(diplomat)) {
                pieceChoosable(diplomat);
              }
            }
          }
          choiceChoosable(Choice.next, true);
          if (phaseState.frenchDebaters.isNotEmpty) {
            choiceChoosable(Choice.cancel, true);
          }
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.next)) {
          if (phaseState.coalitionDebaters.isEmpty) {
            return;
          }
          _subStep = 1;
          break;
        }
        final diplomats = selectedPieces();
        final coalitionDiplomat = diplomats[0];
        if (diplomats.length == 1) {
          setPrompt('Select French Diplomat to Debate');
          for (final frenchDiplomat in PieceType.frenchDiplomat.pieces) {
            final location = _state.pieceLocation(frenchDiplomat);
            if (location.isType(LocationType.greenBox)) {
              pieceChoosable(frenchDiplomat);
            }
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        final frenchDiplomat = diplomats[1];
        phaseState.coalitionDebaters.add(coalitionDiplomat);
        phaseState.frenchDebaters.add(frenchDiplomat);
        clearChoices();
      }
    }
    if (_subStep == 1) { // Debates
      logLine('### Debate');
      for (int i = 0; i < phaseState.coalitionDebaters.length; ++i) {
        final coalitionDiplomat = phaseState.coalitionDebaters[i];
        final frenchDiplomat = phaseState.frenchDebaters[i];
        logLine('> ${coalitionDiplomat.desc} debates ${frenchDiplomat.desc}.');
        adjustTreasuryFund(-1);
        if (_state.pieceLocation(frenchDiplomat) == Location.boxHotel) {
          logLine('> ${frenchDiplomat.desc} has already lost.');
        } else {
          int die = rollD6();
          int modifiers = 0;
          int frenchDiplomatModifier = _state.diplomatValue(frenchDiplomat);
          if (frenchDiplomatModifier > 0) {
            logLine('> ${frenchDiplomat.desc}: +$frenchDiplomatModifier');
            modifiers += frenchDiplomatModifier;
          }
          int total = die + modifiers;
          int coalitionDiplomatStrength = _state.diplomatValue(coalitionDiplomat);
          if (total <= coalitionDiplomatStrength) {
            logLine('> ${coalitionDiplomat.desc} wins the debate against ${frenchDiplomat.desc}.');
            _state.setPieceLocation(frenchDiplomat, Location.boxHotel);
          } else {
            logLine('> ${coalitionDiplomat.desc} loses the debate against ${frenchDiplomat.desc}.');
          }
        }
      }
    }
  }

  void counterDiplomacyPhaseCharmOffensive() {
    if (_state.lostWars.isEmpty) {
      return;
    }
    if (_state.piecesInLocationCount(PieceType.coalitionDiplomat, Location.boxLondon) == 0) {
      return;
    }
    final phaseState = _phaseState as PhaseStateCounterDiplomacy;
    while (true) {
      if (_subStep == 0) {
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          continue;
        }
        if (choicesEmpty()) {
          setPrompt('Select Coalition Diplomat for Charm Offensive');
          if (_state.treasuryFund >= 1) {
            for (final diplomat in _state.piecesInLocation(PieceType.coalitionDiplomat, Location.boxLondon)) {
              pieceChoosable(diplomat);
            }
          }
          choiceChoosable(Choice.next, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.next)) {
          return;
        }
        final diplomat = selectedPiece()!;
        final minorWarBox = selectedLocation();
        if (minorWarBox == null) {
          setPrompt('Select Minor War');
          for (final war in _state.lostWars) {
            final minor = _state.pieceLocation(war);
            locationChoosable(minor);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        logLine('### Charm Offensive');
        logLine('> ${diplomat.desc} conducts diplomacy in ${minorWarBox.desc}.');
        _state.setPieceLocation(diplomat, minorWarBox);
        phaseState.charmer = diplomat;
        clearChoices();
        _subStep = 1;
      }
      while (_subStep >= 1 && _subStep <= 2) {
        if (_subStep == 1) { // Charm
          final diplomat = phaseState.charmer!;
          final minorWarBox = _state.pieceLocation(diplomat);
          adjustTreasuryFund(-1);
          int die = rollD6();
          if (die > _state.lostWars.length) {
            logLine('> Charm Offensive is successful.');
            final lostWar = _state.pieceInLocation(PieceType.warLost, minorWarBox)!;
            _state.flipPiece(lostWar);
            phaseState.charmer = null;
            _subStep = 0;
          } else {
            logLine('> Charm Offensive has no effect.');
          _subStep = 2;
          }
        }
        if (_subStep == 2) { // Retry
          if (choicesEmpty()) {
            setPrompt('Continue Charm Offensive?');
            choiceChoosable(Choice.yes, _state.treasuryFund >= 1);
            choiceChoosable(Choice.no, true);
            throw PlayerChoiceException();
          }
          if (checkChoiceAndClear(Choice.no)) {
            phaseState.charmer = null;
            _subStep = 0;
          } else {
            final diplomat = phaseState.charmer!;
            logLine('> ${diplomat.desc} continues his Charm Offensive.');
            _subStep = 1;
          }
        }
      }
    }
  }

  void counterDiplomacyPhaseAlignCountries() {
    final phaseState = _phaseState as PhaseStateCounterDiplomacy;
    if (candidateAlignCountries.isEmpty) {
      return;
    }
    while (true) {
      if (_subStep == 0) {
        if (choicesEmpty()) {
          setPrompt('Select Diplomat to use to Align Power');
          for (final diplomat in candidateAlignCountryDiplomats) {
            pieceChoosable(diplomat);
          }
          choiceChoosable(Choice.next, true);
          throw PlayerChoiceException();
        }
      }
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      highPoliticsPhaseBegin,
      highPoliticsPhaseGetMoney,
      highPoliticsPhaseAdjustBudgets,
      highPoliticsPhaseButNation,
      highPoliticsPhaseTurnEvent0,
      highPoliticsPhaseTurnEvent1,
      highPoliticsPhaseDrawChit0,
      highPoliticsPhaseDrawChit1,
      highPoliticsPhaseDrawChit2,
      highPoliticsPhasePurchaseChit,
      highPoliticsPhaseDrawPurchasedChit,
      highPoliticsPhaseEnd,
      diplomacyPhaseBegin,
      diplomacyPhaseDiplomats,
      counterDiplomacyPhaseBegin,
      counterDiplomacyPhaseDebate,
      counterDiplomacyPhaseCharmOffensive,
      counterDiplomacyPhaseAlignCountries,
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

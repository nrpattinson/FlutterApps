import 'dart:convert';
import 'dart:math';
import 'package:sword_of_orthodoxy/db.dart';
import 'package:sword_of_orthodoxy/random.dart';

enum Location {
  constantinople,
  zoneSouth,
  zoneWest,
  zoneNorth,
  themeNicaea,
  themePaphlagonia,
  themeLesserArmenia,
  themeGreaterArmenia,
  homelandIberia,
  themeAmorion,
  themeCappadocia,
  themeMelitene,
  themeNisibis,
  homelandPersia,
  themeEphesus,
  themeCilicia,
  themeJerusalem,
  themeDamascus,
  homelandSyria,
  southTribeBox,
  westTribeBox,
  northTribeBox,
  outpostEgyptBox,
  outpostSpainBox,
  outpostSicilyBox,
  outpostRomeBox,
  outpostLazicaBox,
  outpostLazicaGreekFireBox,
  outpostHolyLandBox,
  hippodromeBox,
  kyivBox,
  dynastyBox,
  dynastyBoxCivilWar0,
  dynastyBoxCivilWar1,
  basileusBox,
  basileusHusbandBox,
  basileusAlternateBox,
  patriarchBox,
  arabiaBox,
  stolosLurkingBox,
  egyptianReligionBox,
  popeBox,
  bulgarianChurchBox,
  crusadesABox,
  crusadesBBox,
  crusadesCBox,
  crusadesDBox,
  reformsBox,
  availableOutpostsBox,
  strategikonDonatists,
  strategikonExcubitors,
  strategikonWarInTheEast,
  strategikonIconoclasm,
  strategikonTagmataTroops,
  strategikonBagratids,
  strategikonCataphracts,
  strategikonVarangianGuards,
  strategikonDisloyalMercenaries,
  strategikonMightyEgypt,
  strategikonLatinikon,
  strategikonTheBlackDeath,
  strategikonJihad,
  strategikonCannons,
  militaryEventBox,
  chronographia1,
  chronographia2,
  chronographia3,
  chronographia4,
  chronographia5,
  chronographia6,
  chronographia7,
  chronographia8,
  chronographia9,
  chronographia10,
  chronographia11,
  chronographia12,
  chronographia13,
  chronographia14,
  chronographia15,
  chronographia16,
  chronographia17,
  chronographia18,
  chronographia19,
  chronographia20,
  chronographia21,
  chronographia22,
  chronographia23,
  chronographia24,
  chronographia25,
  chronographia26,
  chronographia27,
  chronographiaOverflow,
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
  reservesSouth,
  reservesWest,
  reservesNorth,
  cupTurnChit,
  cupDynasty,
  cupBasileus,
  cupPatriarch,
  trayTurnChits,
  trayPatriarchs,
  trayFactions,
  trayPathSouth,
  trayPathWest,
  trayPathNorth,
  trayPathIberia,
  trayPathPersia,
  trayPathSyria,
  trayBasileus,
  trayPolitical,
  trayMilitary,
  trayDynasties,
  trayMarkers,
  trayGeography,
  trayUnits,
  trayOutposts,
  traySieges,
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
  land,
  zone,
  eastern,
  pathSouth,
  pathWest,
  pathNorth,
  pathIberia,
  pathPersia,
  pathSyria,
  tribeBox,
  outpostBox,
  crusadesBox,
  strategikon,
  chronographiaWithOverflow,
  chronographia,
  omnibus,
  reserves,
  tray,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.land: [Location.constantinople, Location.homelandSyria],
    LocationType.zone: [Location.zoneSouth, Location.zoneNorth],
    LocationType.eastern: [Location.themeNicaea, Location.homelandSyria],
    LocationType.pathSouth: [Location.zoneSouth, Location.zoneSouth],
    LocationType.pathWest: [Location.zoneWest, Location.zoneWest],
    LocationType.pathNorth: [Location.zoneNorth, Location.zoneNorth],
    LocationType.pathIberia: [Location.themeNicaea, Location.homelandIberia],
    LocationType.pathPersia: [Location.themeAmorion, Location.homelandPersia],
    LocationType.pathSyria: [Location.themeEphesus, Location.homelandSyria],
    LocationType.tribeBox: [Location.southTribeBox, Location.northTribeBox],
    LocationType.outpostBox: [Location.outpostEgyptBox, Location.outpostHolyLandBox],
    LocationType.crusadesBox: [Location.crusadesABox, Location.crusadesDBox],
    LocationType.strategikon: [Location.strategikonDonatists, Location.strategikonCannons],
    LocationType.chronographiaWithOverflow: [Location.chronographia1, Location.chronographiaOverflow],
    LocationType.chronographia: [Location.chronographia1, Location.chronographia27],
    LocationType.omnibus: [Location.omnibus0, Location.omnibus13],
    LocationType.reserves: [Location.reservesSouth, Location.reservesNorth],
    LocationType.tray: [Location.trayTurnChits, Location.traySieges],
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
    const locationNames = {
      Location.constantinople: 'Constantinople',
      Location.themeNicaea: 'Nicaea',
      Location.themePaphlagonia: 'Paphlagonia',
      Location.themeLesserArmenia: 'Lesser Armenia',
      Location.themeGreaterArmenia: 'Greater Armenia',
      Location.homelandIberia: 'Iberia',
      Location.themeAmorion: 'Amorion',
      Location.themeCappadocia: 'Cappadocia',
      Location.themeMelitene: 'Melitene',
      Location.themeNisibis: 'Nisibis',
      Location.homelandPersia: 'Persia',
      Location.themeEphesus: 'Ephesus',
      Location.themeCilicia: 'Cilicia',
      Location.themeJerusalem: 'Jerusalem',
      Location.themeDamascus: 'Damascus',
      Location.homelandSyria: 'Syria',
      Location.crusadesABox: 'First Crusade',
      Location.crusadesBBox: 'Second Crusade',
      Location.crusadesCBox: 'Third, Fourth, and Fifth Crusades',
      Location.crusadesDBox: 'Sixth and Seventh Crusades',
      Location.strategikonDonatists: 'Donatists',
      Location.strategikonExcubitors: 'Excubitors',
      Location.strategikonWarInTheEast: 'War in the East',
      Location.strategikonIconoclasm: 'Iconoclasm',
      Location.strategikonTagmataTroops: 'Tagmata Troops',
      Location.strategikonBagratids: 'Bagratids',
      Location.strategikonCataphracts: 'Cataphracts',
      Location.strategikonVarangianGuards: 'Varangian Guards',
      Location.strategikonDisloyalMercenaries: 'Disloyal Mercenaries',
      Location.strategikonMightyEgypt: 'Mighty Egypt',
      Location.strategikonLatinikon: 'Latinikon',
      Location.strategikonTheBlackDeath: 'The Black Death',
      Location.strategikonJihad: 'Jihad!',
      Location.strategikonCannons: 'Cannons',
    };
    return locationNames[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Path {
  south,
  west,
  north,
  iberia,
  persia,
  syria,
}

Path? pathFromIndex(int? index) {
  if (index != null) {
    return Path.values[index];
  } else {
    return null;
  }
}

int? pathToIndex(Path? location) {
  return location?.index;
}

List<Path> pathListFromIndices(List<int> indices) {
  final paths = <Path>[];
  for (final index in indices) {
    paths.add(Path.values[index]);
  }
  return paths;
}

List<int> pathListToIndices(List<Path> paths) {
  final indices = <int>[];
  for (final path in paths) {
    indices.add(path.index);
  }
  return indices;
}

extension PathExtension on Path {
  String get desc {
    const pathNames = {
      Path.south: 'Southern Path',
      Path.west: 'Western Path',
      Path.north: 'Northern Path',
      Path.iberia: 'Iberian Path',
      Path.persia: 'Persian Path',
      Path.syria: 'Syrian Path',
    };
    return pathNames[this]!;
  }
}

enum Piece {
  armySouthWeak0,
  armySouthWeak1,
  armySouthWeak2,
  armySouthWeak3,
  armySouthWeak4,
  armySouthStrong0,
  armySouthStrong1,
  armySouthStrong2,
  armySouthStrong3,
  armySouthStrong4,
  armyWestWeak0,
  armyWestWeak1,
  armyWestWeak2,
  armyWestWeak3,
  armyWestWeak4,
  armyWestStrong0,
  armyWestStrong1,
  armyWestStrong2,
  armyWestStrong3,
  armyWestStrong4,
  armyNorthWeak0,
  armyNorthWeak1,
  armyNorthWeak2,
  armyNorthWeak3,
  armyNorthWeak4,
  armyNorthStrong0,
  armyNorthStrong1,
  armyNorthStrong2,
  armyNorthStrong3,
  armyNorthStrong4,
  armyIberiaArmenia,
  armyIberiaOttoman,
  armyIberiaPersia,
  armyIberiaSaracen,
  armyIberiaSeljuk,
  armyPersiaBuyid,
  armyPersiaIlKhanid,
  armyPersiaOttoman,
  armyPersiaPersia,
  armyPersiaSaracen,
  armyPersiaSeljuk,
  armyPersiaMongol,
  armySyriaEgypt,
  armySyriaIlKhanid,
  armySyriaNomads,
  armySyriaOttoman,
  armySyriaPersia,
  armySyriaSaracen,
  armySyriaSeljuk,
  armySyriaMongol,
  armyMagyar,
  armySkanderbeg,
  siegeSouth,
  siegeWest,
  siegeNorth,
  siegeIberia,
  siegePersia,
  siegeSyria,
  riots0,
  riots1,
  riots2,
  riots3,
  riots4,
  riots5,
  latins0,
  latins1,
  latins2,
  latins3,
  latins4,
  latins5,
  socialChristians0,
  socialChristians1,
  socialChristians2,
  socialChristians3,
  socialChristians4,
  socialChristians5,
  socialDynatoi0,
  socialDynatoi1,
  socialDynatoi2,
  socialDynatoi3,
  socialDynatoi4,
  socialDynatoi5,
  colonistsPersia,
  colonistsSyria,
  paganPersia,
  paganSyria,
  infrastructureHospital0,
  infrastructureHospital1,
  infrastructureHospitalUsed0,
  infrastructureHospitalUsed1,
  infrastructureAkritai0,
  infrastructureAkritai1,
  infrastructureAkritaiUsed0,
  infrastructureAkritaiUsed1,
  infrastructureMonastery0,
  infrastructureMonastery1,
  infrastructureMonasteryIsolated0,
  infrastructureMonasteryIsolated1,
  university,
  bulgarianTheme,
  factionBlueTeam,
  factionGreenTeam,
  factionRomanSenate,
  factionEunuchs,
  factionPatricians,
  factionArmenian,
  factionSalonika,
  factionPostalService,
  factionSomateiaGuilds,
  factionTheodosianWalls,
  factionHagiaSophia,
  kastron,
  tribeSouthEgypt,
  tribeSouthMoors,
  tribeSouthSaracen,
  tribeSouthVandal,
  tribeSouthVenice,
  tribeWestGoth,
  tribeWestLombards,
  tribeWestNorman,
  tribeWestOttoman,
  tribeWestSerbs,
  tribeNorthBulgar,
  tribeNorthBulgarians,
  tribeNorthHun,
  tribeNorthOstrogoths,
  tribeNorthOttoman,
  tribeNorthSlav,
  outpostEgypt,
  outpostHolyLand,
  outpostLazica,
  outpostRome,
  outpostSicily,
  outpostSpain,
  geographyAfrica,
  geographyCrete,
  geographyItaly,
  geographyBalkans,
  ravenna,
  holyRomanEmpire,
  rulerKhan,
  rulerRex,
  caliph,
  fitna,
  stolos,
  tribute,
  basileusJustinian,
  basileusTheodosius,
  basileusJohn,
  basileusBasil,
  basileusAlexios,
  basileusZoe,
  basileusConstantine0,
  basileusNikephoros,
  basileusAndronikos,
  basileusConstantine1,
  basileusLeo,
  basileusTheodora,
  basileusRomanos,
  basileusMichael,
  basileusAlternateJohn,
  basileusAlternateBasil,
  basileusAlternateAlexios,
  basileusAlternateZoe,
  basileusAlternateConstantine0,
  basileusAlternateNikephoros,
  basileusAlternateAndronikos,
  basileusAlternateConstantine1,
  basileusAlternateLeo,
  basileusAlternateTheodora,
  basileusAlternateRomanos,
  basileusAlternateMichael,
  dynastyPurpleTheodosian,
  dynastyPurpleLeonid,
  dynastyPurpleJustinian,
  dynastyPurpleHeraclian,
  dynastyPurpleIsaurian,
  dynastyPurpleAnarchy0,
  dynastyPurpleAngelid,
  dynastyPurpleAmorian,
  dynastyPurpleMacedonian,
  dynastyPurpleKomnenid,
  dynastyPurpleLaskarid,
  dynastyPurplePalaiologian,
  dynastyPurpleAnarchy1,
  dynastyPurpleDoukid,
  dynastyBlackDyonisid,
  dynastyBlackSkylosophid,
  dynastyBlackLazarid,
  dynastyBlackStemniote,
  dynastyBlackSphikid,
  dynastyBlackAnarchy0,
  dynastyBlackDimidid,
  dynastyBlackSouliote,
  dynastyBlackLantzid,
  dynastyBlackManiote,
  dynastyBlackKladiote,
  dynastyBlackYpsilantid,
  dynastyBlackAnarchy1,
  dynastyBlackVlachid,
  patriarchNestorius,
  patriarchSergius,
  patriarchAnthimus,
  patriarchPeter,
  patriarchJohn,
  patriarchAntony,
  patriarchPaul,
  patriarchConstantine,
  patriarchNicholas,
  patriarchMichael,
  popeNice,
  popeMean,
  magisterMilitum,
  bulgarianChurchOrthodox,
  bulgarianChurchCatholic,
  kievPagan,
  kievOrthodox,
  egyptFallen,
  egyptMuslim,
  empiresInRubble,
  basileus,
  plague,
  crusade,
  militaryEvent,
  nike,
  reforms,
  schism,
  solidus,
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
  zoneArmy,
  armySouth,
  armySouthWeak,
  armySouthStrong,
  armyWest,
  armyWestWeak,
  armyWestStrong,
  armyNorth,
  armyNorthWeak,
  armyNorthStrong,
  armyEastern,
  armyIberia,
  armyPersia,
  armySyria,
  siege,
  tribe,
  tribeSouth,
  tribeWest,
  tribeNorth,
  outpost,
  geography,
  faction,
  factionRegular,
  colonists,
  pagan,
  ruler,
  infrastructure,
  hospital,
  unusedHospital,
  usedHospital,
  akritai,
  unusedAkritai,
  usedAkritai,
  monastery,
  connectedMonastery,
  isolatedMonastery,
  riots,
  latins,
  social,
  christians,
  dynatoi,
  basileus,
  basileusFront,
  basileusFrontRandom,
  basileusBackRandom,
  basileusAlternate,
  dynasty,
  dynastyPurple,
  dynastyBlack,
  patriarch,
  patriarchSchism,
  patriarchNonSchism,
  pope,
  bulgarianChurch,
  kiev,
  turnChit,
  turnChitFirstMillenium,
  turnChitSecondMillenium,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.armySouthWeak0, Piece.turnChit28],
    PieceType.zoneArmy: [Piece.armySouthWeak0, Piece.armyNorthStrong4],
    PieceType.armySouth: [Piece.armySouthWeak0, Piece.armySouthStrong4],
    PieceType.armySouthWeak: [Piece.armySouthWeak0, Piece.armySouthWeak4],
    PieceType.armySouthStrong: [Piece.armySouthStrong0, Piece.armySouthStrong4],
    PieceType.armyWest: [Piece.armyWestWeak0, Piece.armyWestStrong4],
    PieceType.armyWestWeak: [Piece.armyWestWeak0, Piece.armyWestWeak4],
    PieceType.armyWestStrong: [Piece.armyWestStrong0, Piece.armyWestStrong4],
    PieceType.armyNorth: [Piece.armyNorthWeak0, Piece.armyNorthStrong4],
    PieceType.armyNorthWeak: [Piece.armyNorthWeak0, Piece.armyNorthWeak4],
    PieceType.armyNorthStrong: [Piece.armyNorthStrong0, Piece.armyNorthStrong4],
    PieceType.armyEastern: [Piece.armyIberiaArmenia, Piece.armySyriaMongol],
    PieceType.armyIberia: [Piece.armyIberiaArmenia, Piece.armyIberiaSeljuk],
    PieceType.armyPersia: [Piece.armyPersiaBuyid, Piece.armyPersiaMongol],
    PieceType.armySyria: [Piece.armySyriaEgypt, Piece.armySyriaMongol],
    PieceType.siege: [Piece.siegeSouth, Piece.siegeSyria],
    PieceType.tribe: [Piece.tribeSouthEgypt, Piece.tribeNorthSlav],
    PieceType.tribeSouth: [Piece.tribeSouthEgypt, Piece.tribeSouthVenice],
    PieceType.tribeWest: [Piece.tribeWestGoth, Piece.tribeWestSerbs],
    PieceType.tribeNorth: [Piece.tribeNorthBulgar, Piece.tribeNorthSlav],
    PieceType.outpost: [Piece.outpostEgypt, Piece.outpostSpain],
    PieceType.geography: [Piece.geographyAfrica, Piece.geographyBalkans],
    PieceType.faction: [Piece.factionBlueTeam, Piece.factionHagiaSophia],
    PieceType.factionRegular: [Piece.factionBlueTeam, Piece.factionSomateiaGuilds],
    PieceType.colonists: [Piece.colonistsPersia, Piece.colonistsSyria],
    PieceType.pagan: [Piece.paganPersia, Piece.paganSyria],
    PieceType.ruler: [Piece.rulerKhan, Piece.rulerRex],
    PieceType.hospital: [Piece.infrastructureHospital0, Piece.infrastructureHospitalUsed1],
    PieceType.unusedHospital: [Piece.infrastructureHospital0, Piece.infrastructureHospital1],
    PieceType.usedHospital: [Piece.infrastructureHospitalUsed0, Piece.infrastructureHospitalUsed1],
    PieceType.akritai: [Piece.infrastructureAkritai0, Piece.infrastructureAkritaiUsed1],
    PieceType.unusedAkritai: [Piece.infrastructureAkritai0, Piece.infrastructureAkritai1],
    PieceType.usedAkritai: [Piece.infrastructureAkritaiUsed0, Piece.infrastructureAkritaiUsed1],
    PieceType.monastery: [Piece.infrastructureMonastery0, Piece.infrastructureMonasteryIsolated1],
    PieceType.connectedMonastery: [Piece.infrastructureMonastery0, Piece.infrastructureMonastery1],
    PieceType.isolatedMonastery: [Piece.infrastructureMonasteryIsolated0, Piece.infrastructureMonasteryIsolated1],
    PieceType.riots: [Piece.riots0, Piece.riots5],
    PieceType.latins: [Piece.latins0, Piece.latins5],
    PieceType.social: [Piece.socialChristians0, Piece.socialDynatoi5],
    PieceType.christians: [Piece.socialChristians0, Piece.socialChristians5],
    PieceType.dynatoi: [Piece.socialDynatoi0, Piece.socialDynatoi5],
    PieceType.basileus: [Piece.basileusJustinian, Piece.basileusMichael],
    PieceType.basileusFront: [Piece.basileusTheodosius, Piece.basileusNikephoros],
    PieceType.basileusFrontRandom: [Piece.basileusJohn, Piece.basileusNikephoros],
    PieceType.basileusBackRandom: [Piece.basileusAndronikos, Piece.basileusMichael],
    PieceType.basileusAlternate: [Piece.basileusAlternateJohn, Piece.basileusAlternateMichael],
    PieceType.dynasty: [Piece.dynastyPurpleTheodosian, Piece.dynastyBlackVlachid],
    PieceType.dynastyPurple: [Piece.dynastyPurpleTheodosian, Piece.dynastyPurpleDoukid],
    PieceType.dynastyBlack: [Piece.dynastyBlackDyonisid, Piece.dynastyBlackVlachid],
    PieceType.patriarch: [Piece.patriarchNestorius, Piece.patriarchMichael],
    PieceType.patriarchSchism: [Piece.patriarchNestorius, Piece.patriarchPeter],
    PieceType.patriarchNonSchism: [Piece.patriarchJohn, Piece.patriarchMichael],
    PieceType.pope: [Piece.popeNice, Piece.popeMean],
    PieceType.bulgarianChurch: [Piece.bulgarianChurchOrthodox, Piece.bulgarianChurchCatholic],
    PieceType.kiev: [Piece.kievPagan, Piece.kievOrthodox],
    PieceType.turnChit: [Piece.turnChit1, Piece.turnChit28],
    PieceType.turnChitFirstMillenium: [Piece.turnChit1, Piece.turnChit14],
    PieceType.turnChitSecondMillenium: [Piece.turnChit15, Piece.turnChit28],
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
      Piece.armyIberiaArmenia: 'Armenian Army',
      Piece.armyIberiaOttoman: 'Ottoman Turkish Army',
      Piece.armyIberiaPersia: 'Sassanid Persian Army',
      Piece.armyIberiaSaracen: 'Saracen Army',
      Piece.armyIberiaSeljuk: 'Seljuk Turkish Army',
      Piece.armyPersiaBuyid: 'Buyid Persian Army',
      Piece.armyPersiaIlKhanid: 'Ilkhanid Army',
      Piece.armyPersiaOttoman: 'Ottoman Turkish Army',
      Piece.armyPersiaPersia: 'Sassanid Persian Army',
      Piece.armyPersiaSaracen: 'Saracen Army',
      Piece.armyPersiaSeljuk: 'Seljuk Turkish Army',
      Piece.armyPersiaMongol: 'Mongol Army',
      Piece.armySyriaEgypt: 'Egyptian Army',
      Piece.armySyriaIlKhanid: 'Ilkhanid Army',
      Piece.armySyriaNomads: 'Nomad Army',
      Piece.armySyriaOttoman: 'Ottoman Turkish Army',
      Piece.armySyriaPersia: 'Sassanid Persian Army',
      Piece.armySyriaSaracen: 'Saracen Army',
      Piece.armySyriaSeljuk: 'Seljuk Turkish Army',
      Piece.armySyriaMongol: 'Mongol Army',
      Piece.armyMagyar: 'Magyar Army',
      Piece.armySkanderbeg: 'Albanian Army',
      Piece.socialChristians0: 'Christians',
      Piece.socialChristians1: 'Christians',
      Piece.socialChristians2: 'Christians',
      Piece.socialChristians3: 'Christians',
      Piece.socialChristians4: 'Christians',
      Piece.socialChristians5: 'Christians',
      Piece.socialDynatoi0: 'Dynatoi',
      Piece.socialDynatoi1: 'Dynatoi',
      Piece.socialDynatoi2: 'Dynatoi',
      Piece.socialDynatoi3: 'Dynatoi',
      Piece.socialDynatoi4: 'Dynatoi',
      Piece.socialDynatoi5: 'Dynatoi',
      Piece.university: 'Pandidakterion',
      Piece.factionBlueTeam: 'Blue Team',
      Piece.factionGreenTeam: 'Green Team',
      Piece.factionRomanSenate: 'Roman Senate',
      Piece.factionEunuchs: 'Eunuchs',
      Piece.factionPatricians: 'Patricians',
      Piece.factionArmenian: 'Armenians',
      Piece.factionSalonika: 'Salonika',
      Piece.factionPostalService: 'Postal Service',
      Piece.factionSomateiaGuilds: 'Guilds',
      Piece.factionTheodosianWalls: 'Theodosian Walls',
      Piece.factionHagiaSophia: 'Hagia Sophia',
      Piece.tribeSouthEgypt: 'Egyptians',
      Piece.tribeSouthMoors: 'Moors',
      Piece.tribeSouthSaracen: 'Saracens',
      Piece.tribeSouthVandal: 'Vandals',
      Piece.tribeSouthVenice: 'Venetians',
      Piece.tribeWestGoth: 'Goths',
      Piece.tribeWestLombards: 'Lombards',
      Piece.tribeWestNorman: 'Normans',
      Piece.tribeWestOttoman: 'Ottoman Turks',
      Piece.tribeWestSerbs: 'Serbs',
      Piece.tribeNorthBulgar: 'Bulgars',
      Piece.tribeNorthBulgarians: 'Bulgarians',
      Piece.tribeNorthHun: 'Huns',
      Piece.tribeNorthOstrogoths: 'Ostrogoths',
      Piece.tribeNorthOttoman: 'Ottoman Turks',
      Piece.tribeNorthSlav: 'Slavs',
      Piece.outpostEgypt: 'Egypt',
      Piece.outpostHolyLand: 'The Holy Land',
      Piece.outpostLazica: 'Lazica',
      Piece.outpostRome: 'Rome',
      Piece.outpostSicily: 'Sicily',
      Piece.outpostSpain: 'Spain',
      Piece.rulerKhan: 'Khan',
      Piece.rulerRex: 'Rex',
      Piece.caliph: 'Caliph',
      Piece.fitna: 'Fitna',
      Piece.basileusJustinian: 'Justinian',
      Piece.basileusTheodosius: 'Theodosius',
      Piece.basileusJohn: 'John',
      Piece.basileusBasil: 'Basil',
      Piece.basileusAlexios: 'Alexios',
      Piece.basileusZoe: 'Zoë',
      Piece.basileusConstantine0: 'Constantine',
      Piece.basileusNikephoros: 'Nikephoros',
      Piece.basileusAndronikos: 'Andronikos',
      Piece.basileusConstantine1: 'Constantine',
      Piece.basileusLeo: 'Leo',
      Piece.basileusTheodora: 'Theodora',
      Piece.basileusRomanos: 'Romanos',
      Piece.basileusMichael: 'Michael',
      Piece.basileusAlternateJohn: 'John',
      Piece.basileusAlternateBasil: 'Basil',
      Piece.basileusAlternateAlexios: 'Alexios',
      Piece.basileusAlternateZoe: 'Zoë',
      Piece.basileusAlternateConstantine0: 'Constantine',
      Piece.basileusAlternateNikephoros: 'Nikephoros',
      Piece.basileusAlternateAndronikos: 'Andronikos',
      Piece.basileusAlternateConstantine1: 'Constantine',
      Piece.basileusAlternateLeo: 'Leo',
      Piece.basileusAlternateTheodora: 'Theodora',
      Piece.basileusAlternateRomanos: 'Romanos',
      Piece.basileusAlternateMichael: 'Michael',
      Piece.dynastyPurpleTheodosian: 'Theodosian Dynasty',
      Piece.dynastyPurpleLeonid: 'Leonid Dynasty',
      Piece.dynastyPurpleJustinian: 'Justinian Dynasty',
      Piece.dynastyPurpleHeraclian: 'Heraclian Dynasty',
      Piece.dynastyPurpleIsaurian: 'Isaurian Dynasty',
      Piece.dynastyPurpleAnarchy0: 'Anarchy',
      Piece.dynastyPurpleAngelid: 'Angelid Dynasty',
      Piece.dynastyPurpleAmorian: 'Amorian Dynasty',
      Piece.dynastyPurpleMacedonian: 'Macedonian Dynasty',
      Piece.dynastyPurpleKomnenid: 'Komnenid Dynasty',
      Piece.dynastyPurpleLaskarid: 'Laskarid Dynasty',
      Piece.dynastyPurplePalaiologian: 'Palaiologian Dynasty',
      Piece.dynastyPurpleAnarchy1: 'Anarchy',
      Piece.dynastyPurpleDoukid: 'Doukid Dynasty',
      Piece.dynastyBlackDyonisid: 'Dyonisid Dynasty',
      Piece.dynastyBlackSkylosophid: 'Skylosophid Dynasty',
      Piece.dynastyBlackLazarid: 'Lazarid Dynasty',
      Piece.dynastyBlackStemniote: 'Stemniote Dynasty',
      Piece.dynastyBlackSphikid: 'Sphikid Dynasty',
      Piece.dynastyBlackAnarchy0: 'Anarchy',
      Piece.dynastyBlackDimidid: 'Dimidid Dynasty',
      Piece.dynastyBlackSouliote: 'Souliote Dynasty',
      Piece.dynastyBlackLantzid: 'Lantzid Dynasty',
      Piece.dynastyBlackManiote: 'Maniote Dynasty',
      Piece.dynastyBlackKladiote: 'Kladiote Dynasty',
      Piece.dynastyBlackYpsilantid: 'Ypsilantid Dynasty',
      Piece.dynastyBlackAnarchy1: 'Anarchy',
      Piece.dynastyBlackVlachid: 'Vlachid Dynasty',
      Piece.patriarchNestorius: 'Nestorius',
      Piece.patriarchSergius: 'Sergius',
      Piece.patriarchAnthimus: 'Anthimus',
      Piece.patriarchPeter: 'Peter',
      Piece.patriarchJohn: 'John',
      Piece.patriarchAntony: 'Antony',
      Piece.patriarchPaul: 'Paul',
      Piece.patriarchConstantine: 'Constantine',
      Piece.patriarchNicholas: 'Nicholas',
      Piece.patriarchMichael: 'Michael',
    };
    return pieceNames[this]!;
  }

  bool isType(PieceType pieceType) {
    return index >= pieceType.firstIndex && index < pieceType.lastIndex;
  }
}

enum CurrentEvent {
  comet,
  porphyriosTheWhale,
  warOfTheSicilianVespers,
}

enum LimitedEvent {
  constantinopleBetrayed,
  david,
  eastWestSchism,
  fallOfRome,
  justaGrataHonoria,
  kleidion,
  ottomans,
  ravenna,
  rotrude,
  silkwormHeist,
  skanderbeg,
  tricameron,
  warInTheEast,
}

enum Scenario {
  campaign,
  millennium,
}

extension ScenarioExtension on Scenario {
  String get desc {
    const scenarioDescs = {
      Scenario.campaign: 'Campaign',
      Scenario.millennium: 'Millennium',
    };
    return scenarioDescs[this]!;
  }

  String get longDesc {
    const scenarioDescs = {
      Scenario.campaign: 'Campaign 421 AD to 1500 AD (27 Turns)',
      Scenario.millennium: 'Millennium 1000 AD to 1500 AD (13 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<bool> _currentEventCurrents = List<bool>.filled(CurrentEvent.values.length, false);
  List<int> _limitedEventCounts = List<int>.filled(LimitedEvent.values.length, 0);
  Piece? _stolosArmy;
  int _turn = 0;
  int _firstTurn = 0;

  GameState();

  GameState.fromJson(Map<String, dynamic> json) {
    _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']));
    _currentEventCurrents = List<bool>.from(json['currentEventCurrents']);
    _limitedEventCounts = List<int>.from(json['limitedEventCounts']);
    final stolosArmyIndex = json['stolosArmy'] as int?;
    if (stolosArmyIndex != null) {
      _stolosArmy = Piece.values[stolosArmyIndex];
    } else {
      _stolosArmy = null;
    }
    _turn = json['turn'] as int;
    _firstTurn = json['firstTurn'] as int;
  }

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'currentEventCurrents': _currentEventCurrents,
    'limitedEventCounts': _limitedEventCounts,
    'stolosArmy': _stolosArmy?.index,
    'turn': _turn,
    'firstTurn': _firstTurn,
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.geographyAfrica: Piece.geographyCrete,
      Piece.geographyCrete: Piece.geographyAfrica,
      Piece.geographyItaly: Piece.geographyBalkans,
      Piece.geographyBalkans: Piece.geographyItaly,
      Piece.popeNice: Piece.popeMean,
      Piece.popeMean: Piece.popeNice,
      Piece.infrastructureHospital0: Piece.infrastructureHospitalUsed0,
      Piece.infrastructureHospital1: Piece.infrastructureHospitalUsed1,
      Piece.infrastructureAkritai0: Piece.infrastructureAkritaiUsed0,
      Piece.infrastructureAkritai1: Piece.infrastructureAkritaiUsed1,
      Piece.infrastructureMonastery0: Piece.infrastructureMonasteryIsolated0,
      Piece.infrastructureMonastery1: Piece.infrastructureMonasteryIsolated1,
      Piece.infrastructureHospitalUsed0: Piece.infrastructureHospital0,
      Piece.infrastructureHospitalUsed1: Piece.infrastructureHospital1,
      Piece.infrastructureAkritaiUsed0: Piece.infrastructureAkritai0,
      Piece.infrastructureAkritaiUsed1: Piece.infrastructureAkritai1,
      Piece.infrastructureMonasteryIsolated0: Piece.infrastructureMonastery0,
      Piece.infrastructureMonasteryIsolated1: Piece.infrastructureMonastery1,
      Piece.caliph: Piece.fitna,
      Piece.fitna: Piece.caliph,
      Piece.colonistsPersia: Piece.paganPersia,
      Piece.colonistsSyria: Piece.paganSyria,
      Piece.paganPersia: Piece.colonistsPersia,
      Piece.paganSyria: Piece.colonistsSyria,
      Piece.patriarchNestorius: Piece.university,
      Piece.university: Piece.patriarchNestorius,
      Piece.outpostEgypt: Piece.egyptFallen,
      Piece.egyptFallen: Piece.outpostEgypt,
      Piece.armySouthWeak0: Piece.armySouthStrong0,
      Piece.armySouthWeak1: Piece.armySouthStrong1,
      Piece.armySouthWeak2: Piece.armySouthStrong2,
      Piece.armySouthWeak3: Piece.armySouthStrong3,
      Piece.armySouthWeak4: Piece.armySouthStrong4,
      Piece.armyWestWeak0: Piece.armyWestStrong0,
      Piece.armyWestWeak1: Piece.armyWestStrong1,
      Piece.armyWestWeak2: Piece.armyWestStrong2,
      Piece.armyWestWeak3: Piece.armyWestStrong3,
      Piece.armyWestWeak4: Piece.armyWestStrong4,
      Piece.armyNorthWeak0: Piece.armyNorthStrong0,
      Piece.armyNorthWeak1: Piece.armyNorthStrong1,
      Piece.armyNorthWeak2: Piece.armyNorthStrong2,
      Piece.armyNorthWeak3: Piece.armyNorthStrong3,
      Piece.armyNorthWeak4: Piece.armyNorthStrong4,
      Piece.armySouthStrong0: Piece.armySouthWeak0,
      Piece.armySouthStrong1: Piece.armySouthWeak1,
      Piece.armySouthStrong2: Piece.armySouthWeak2,
      Piece.armySouthStrong3: Piece.armySouthWeak3,
      Piece.armySouthStrong4: Piece.armySouthWeak4,
      Piece.armyWestStrong0: Piece.armyWestWeak0,
      Piece.armyWestStrong1: Piece.armyWestWeak1,
      Piece.armyWestStrong2: Piece.armyWestWeak2,
      Piece.armyWestStrong3: Piece.armyWestWeak3,
      Piece.armyWestStrong4: Piece.armyWestWeak4,
      Piece.armyNorthStrong0: Piece.armyNorthWeak0,
      Piece.armyNorthStrong1: Piece.armyNorthWeak1,
      Piece.armyNorthStrong2: Piece.armyNorthWeak2,
      Piece.armyNorthStrong3: Piece.armyNorthWeak3,
      Piece.armyNorthStrong4: Piece.armyNorthWeak4,
      Piece.armySyriaEgypt: Piece.egyptMuslim,
      Piece.egyptMuslim: Piece.armySyriaEgypt,
      Piece.latins0: Piece.riots0,
      Piece.latins1: Piece.riots1,
      Piece.latins2: Piece.riots2,
      Piece.latins3: Piece.riots3,
      Piece.latins4: Piece.riots4,
      Piece.latins5: Piece.riots5,
      Piece.riots0: Piece.latins0,
      Piece.riots1: Piece.latins1,
      Piece.riots2: Piece.latins2,
      Piece.riots3: Piece.latins3,
      Piece.riots4: Piece.latins4,
      Piece.riots5: Piece.latins5,
      Piece.dynastyPurpleTheodosian: Piece.dynastyBlackDyonisid,
      Piece.dynastyPurpleLeonid: Piece.dynastyBlackSkylosophid,
      Piece.dynastyPurpleJustinian: Piece.dynastyBlackLazarid,
      Piece.dynastyPurpleHeraclian: Piece.dynastyBlackStemniote,
      Piece.dynastyPurpleIsaurian: Piece.dynastyBlackSphikid,
      Piece.dynastyPurpleAnarchy0: Piece.dynastyBlackAnarchy0,
      Piece.dynastyPurpleAngelid: Piece.dynastyBlackDimidid,
      Piece.dynastyPurpleAmorian: Piece.dynastyBlackSouliote,
      Piece.dynastyPurpleMacedonian: Piece.dynastyBlackLantzid,
      Piece.dynastyPurpleKomnenid: Piece.dynastyBlackManiote,
      Piece.dynastyPurpleLaskarid: Piece.dynastyBlackKladiote,
      Piece.dynastyPurplePalaiologian: Piece.dynastyBlackYpsilantid,
      Piece.dynastyPurpleAnarchy1: Piece.dynastyBlackAnarchy1,
      Piece.dynastyPurpleDoukid: Piece.dynastyBlackVlachid,
      Piece.dynastyBlackDyonisid: Piece.dynastyPurpleTheodosian,
      Piece.dynastyBlackSkylosophid: Piece.dynastyPurpleLeonid,
      Piece.dynastyBlackLazarid: Piece.dynastyPurpleJustinian,
      Piece.dynastyBlackStemniote: Piece.dynastyPurpleHeraclian,
      Piece.dynastyBlackSphikid: Piece.dynastyPurpleIsaurian,
      Piece.dynastyBlackAnarchy0: Piece.dynastyPurpleAnarchy0,
      Piece.dynastyBlackDimidid: Piece.dynastyPurpleAngelid,
      Piece.dynastyBlackSouliote: Piece.dynastyPurpleAmorian,
      Piece.dynastyBlackLantzid: Piece.dynastyPurpleMacedonian,
      Piece.dynastyBlackManiote: Piece.dynastyPurpleKomnenid,
      Piece.dynastyBlackKladiote: Piece.dynastyPurpleLaskarid,
      Piece.dynastyBlackYpsilantid: Piece.dynastyPurplePalaiologian,
      Piece.dynastyBlackAnarchy1: Piece.dynastyPurpleAnarchy1,
      Piece.dynastyBlackVlachid: Piece.dynastyPurpleDoukid,
      Piece.basileusTheodosius: Piece.basileusJustinian,
      Piece.basileusJohn: Piece.basileusAndronikos,
      Piece.basileusBasil: Piece.basileusConstantine1,
      Piece.basileusAlexios: Piece.basileusLeo,
      Piece.basileusZoe: Piece.basileusTheodora,
      Piece.basileusConstantine0: Piece.basileusRomanos,
      Piece.basileusNikephoros: Piece.basileusMichael,
      Piece.basileusJustinian: Piece.basileusTheodosius,
      Piece.basileusAndronikos: Piece.basileusJohn,
      Piece.basileusConstantine1: Piece.basileusBasil,
      Piece.basileusLeo: Piece.basileusAlexios,
      Piece.basileusTheodora: Piece.basileusZoe,
      Piece.basileusRomanos: Piece.basileusConstantine0,
      Piece.basileusMichael: Piece.basileusNikephoros,
      Piece.kievOrthodox: Piece.kievPagan,
      Piece.kievPagan: Piece.kievOrthodox,
      Piece.ravenna: Piece.holyRomanEmpire,
      Piece.holyRomanEmpire: Piece.ravenna,
      Piece.rulerKhan: Piece.rulerRex,
      Piece.rulerRex: Piece.rulerKhan,
      Piece.basileus: Piece.plague,
      Piece.plague: Piece.basileus,
      Piece.socialChristians0: Piece.socialDynatoi0,
      Piece.socialChristians1: Piece.socialDynatoi1,
      Piece.socialChristians2: Piece.socialDynatoi2,
      Piece.socialChristians3: Piece.socialDynatoi3,
      Piece.socialChristians4: Piece.socialDynatoi4,
      Piece.socialChristians5: Piece.socialDynatoi5,
      Piece.socialDynatoi0: Piece.socialChristians0,
      Piece.socialDynatoi1: Piece.socialChristians1,
      Piece.socialDynatoi2: Piece.socialChristians2,
      Piece.socialDynatoi3: Piece.socialChristians3,
      Piece.socialDynatoi4: Piece.socialChristians4,
      Piece.socialDynatoi5: Piece.socialChristians5,
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
    if (piece == _stolosArmy) {
      if (!location.isType(LocationType.land)) {
        setPieceLocation(Piece.stolos, Location.stolosLurkingBox);
        _stolosArmy = null;
      } else {
        setPieceLocation(Piece.stolos, location);
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

  Piece? strongestArmyInLocation(PieceType armyType, Location location) {
    Piece? strongest;
    final armies = piecesInLocation(armyType, location);
    for (final army in armies) {
      if (strongest == null || armyValue(army) > armyValue(strongest)) {
        strongest = army;
      }
    }
    return strongest;
  }

  Piece? weakestArmyInLocation(PieceType armyType, Location location) {
    Piece? weakest;
    final armies = piecesInLocation(armyType, location);
    for (final army in armies) {
      if (weakest == null || armyValue(army) < armyValue(weakest)) {
        weakest = army;
      }
    }
    return weakest;
  }

  bool currentEventCurrent(CurrentEvent event) {
    return _currentEventCurrents[event.index];
  }

  void setCurrentEventOccurred(CurrentEvent event, bool occurred) {
    _currentEventCurrents[event.index] = occurred;
  }

  void clearCurrentEvents() {
    _currentEventCurrents.fillRange(0, _currentEventCurrents.length, false);
  }

  int limitedEventCount(LimitedEvent event) {
    return _limitedEventCounts[event.index];
  }

  void limitedEventPossible(LimitedEvent event) {
    _limitedEventCounts[event.index] = -1;
  }

  void limitedEventOccurred(LimitedEvent event) {
    if (_limitedEventCounts[event.index] < 0) {
      _limitedEventCounts[event.index] = 0;
    }
    _limitedEventCounts[event.index] += 1;
  }

  void clearPossibleLimitedEvents() {
    for (final event in LimitedEvent.values) {
      if (_limitedEventCounts[event.index] < 0) {
        _limitedEventCounts[event.index] = 0;
      }
    }
  }

  String landName(Location land) {
    if (land.isType(LocationType.zone)) {
      final path = landPath(land)!;
      return pathGeographicName(path);
    }
    return land.desc;
  }

  Path? landPath(Location land) {
    for (final path in Path.values) {
      final locationType = pathLocationType(path);
      if (land.isType(locationType)) {
        return path;
      }
    }
    return null;
  }

  List<Location> get mountainLands {
    return [Location.themeGreaterArmenia, Location.themeMelitene, Location.themeCilicia];
  }

  bool landIsMountain(Location land) {
    return mountainLands.contains(land);
  }

  List<Location> get greekLands {
    return [Location.themeNicaea, Location.themeCappadocia, Location.themeEphesus];
  }

  bool landIsPlayerControlled(Location land) {
    if (land == Location.constantinople) {
      return true;
    }
    final path = landPath(land)!;
    final locationType = pathLocationType(path);
    final controlledCount = pathPlayerControlledLandCount(path);
    return land.index - locationType.firstIndex < controlledCount;
  }

  bool landIsMuslim(Location land) {
    final path = landPath(land);
    if (path == null) {
      return false;
    }
    final colonist = pathColonists(path);
    if (colonist == null) {
      return false;
    }
    final colonistLocation = pieceLocation(colonist);
    if (!colonistLocation.isType(LocationType.land)) {
      return false;
    }
    return land.index >= colonistLocation.index;
  }

  // Paths

  List<Path> get westernPaths {
    return [Path.south, Path.west, Path.north];
  }

  List<Path> get easternPaths {
    return [Path.iberia, Path.persia, Path.syria];
  }

  String pathGeographicName(Path path) {
    switch (path) {
    case Path.south:
      return pieceLocation(Piece.geographyAfrica) == Location.zoneSouth ? 'Africa' : 'Crete';
    case Path.west:
      return pieceLocation(Piece.geographyItaly) == Location.zoneWest ? 'Italy' : 'The Balkans';
    case Path.north:
      return 'The North';
    case Path.iberia:
      return 'Iberia';
    case Path.persia:
      return 'Persia';
    case Path.syria:
      return 'Syria';
    }
  }

  LocationType pathLocationType(Path path) {
    const pathLocationTypes = {
      Path.south: LocationType.pathSouth,
      Path.west: LocationType.pathWest,
      Path.north: LocationType.pathNorth,
      Path.iberia: LocationType.pathIberia,
      Path.persia: LocationType.pathPersia,
      Path.syria: LocationType.pathSyria,
    };
    return pathLocationTypes[path]!;
  }

  PieceType pathArmyType(Path path) {
    const pathArmyTypes = {
      Path.south: PieceType.armySouth,
      Path.west: PieceType.armyWest,
      Path.north: PieceType.armyNorth,
      Path.iberia: PieceType.armyIberia,
      Path.persia: PieceType.armyPersia,
      Path.syria: PieceType.armySyria,
    };
    return pathArmyTypes[path]!;
  }

  Location pathSequenceLocation(Path path, int sequence) {
    final locationType = pathLocationType(path);
    return Location.values[locationType.firstIndex + sequence];
  }

  Location pathPrevLocation(Path path, Location location) {
    final locationType = pathLocationType(path);
    if (location.index == locationType.firstIndex) {
      return Location.constantinople;
    }
    return Location.values[location.index - 1];
  }

  Location? pathNextLocation(Path path, Location location) {
    final locationType = pathLocationType(path);
    if (location.index + 1 == locationType.lastIndex) {
      return null;
    }
    return Location.values[location.index + 1];
  }

  Location pathFirstLand(Path path) {
    final locationType = pathLocationType(path);
    return Location.values[locationType.firstIndex];
  }

  Location pathFinalLand(Path path) {
    final locationType = pathLocationType(path);
    return Location.values[locationType.lastIndex - 1];
  }

  bool pathIncludesLocation(Path path, Location location) {
    final locationType = pathLocationType(path);
    return path.index >= locationType.firstIndex && path.index < locationType.lastIndex;
  }

  bool pathIsZone(Path path) {
    return [Path.south, Path.west, Path.north].contains(path);
  }

  Location pathZone(Path path) {
    return Location.values[Location.zoneSouth.index + path.index];
  }

  Location pathReserves(Path path) {
    return Location.values[Location.reservesSouth.index + path.index];
  }

  Location pathTribeBox(Path path) {
    return Location.values[LocationType.tribeBox.firstIndex + path.index];
  }

  Location pathHomeland(Path path) {
    return pathFinalLand(path);
  }

  Piece pathSiege(Path path) {
    return Piece.values[PieceType.siege.firstIndex + path.index];
  }

  Piece pathBarbarianPiece(Path path) {
    if (pathIsZone(path)) {
      final tribeBox = pathTribeBox(path);
      return pieceInLocation(PieceType.tribe, tribeBox)!;
    }
    final locationType = pathLocationType(path);
    final armyType = pathArmyType(path);
    for (final land in locationType.locations) {
      final army = pieceInLocation(armyType, land);
      if (army != null) {
        return army;
      }
    }
    return Piece.solidus; // Should never happen
  }

  bool pathBarbarianIsMuslim(Path path) {
    final piece = pathBarbarianPiece(path);
    return barbarianIsMuslim(piece);
  }

  Piece? pathColonists(Path path) {
    const colonists = {
      Path.persia: Piece.colonistsPersia,
      Path.syria: Piece.colonistsSyria,
    };
    return colonists[path];
  }

  int armyAttackCost(Piece army) {
    int cost = 1;
    final land = pieceLocation(army);
    if (land == Location.constantinople) {
      return 1;
    }
    final path = landPath(land)!;
    final armyType = pathArmyType(path);
    if (pathIsZone(path)) {
      final armyCount = piecesInLocationCount(armyType, land);
      if (armyCount == 1) {
        cost -= 1;
        if (limitedEventCount(LimitedEvent.tricameron) < 0 && pathBarbarianPiece(path) == Piece.tribeSouthVandal) {
          cost += 1;
        }
        if (limitedEventCount(LimitedEvent.kleidion) < 0 && pathBarbarianPiece(path) == Piece.tribeNorthBulgar) {
          cost += 1;
        }
      }
    } else {
      if (land == pathFinalLand(path) || landIsMuslim(land)) {
        cost -= 1;
      }
    }
    if (_stolosArmy == army) {
      cost += 1;
    }
    return cost;
  }

  List<Piece> pathAttackCandidates(Path path, int budget) {
    final armyType = pathArmyType(path);
    final candidates = <Piece>[];
    for (final army in armyType.pieces) {
      if (pieceLocation(army).isType(LocationType.land)) {
        int attackCost = armyAttackCost(army);
        if (attackCost > 0 && attackCost <= budget) {
          candidates.add(army);
        }
      }
    }
    return candidates;
  }

  int pathBarbarianControlledLandCount(Path path) {
    if (pathIsZone(path)) {
      final armyType = pathArmyType(path);
      final zone = pathZone(path);
      if (piecesInLocationCount(armyType, zone) >= 5) {
        return 1;
      }
      return 0;
    }
    final locationType = pathLocationType(path);
    final armyType = pathArmyType(path);
    for (final land in locationType.locations) {
      final army = pieceInLocation(armyType, land);
      if (army != null) {
        return locationType.lastIndex - land.index;
      }
    }
    return 0;
  }

  int pathPlayerControlledLandCount(Path path) {
    if (pathIsZone(path)) {
      final armyType = pathArmyType(path);
      final zone = pathZone(path);
      if (piecesInLocationCount(armyType, zone) >= 5) {
        return 0;
      }
      return 1;
    }
    final locationType = pathLocationType(path);
    final armyType = pathArmyType(path);
    for (final land in locationType.locations) {
      final army = pieceInLocation(armyType, land);
      if (army != null) {
        return land.index - locationType.firstIndex;
      }
    }
    return 0;
  }

  bool pathHasUnusedAkritai(Path path) {
    int controlledCount = pathPlayerControlledLandCount(path);
    for (int sequence = 0; sequence < controlledCount; ++sequence) {
      final land = pathSequenceLocation(path, sequence);
      if (piecesInLocationCount(PieceType.unusedAkritai, land) > 0) {
        return true;
      }
    }
    return false;
  }

  void pathUseAkritai(Path path) {
    final locationType = pathLocationType(path);
    for (final land in locationType.locations) {
      final akritai = pieceInLocation(PieceType.unusedAkritai, land);
      if (akritai != null) {
        setPieceLocation(pieceFlipSide(akritai)!, land);
        return;
      }
    }
  }

  int pathWinningMargin(Path path) {
    if (pathIsZone(path)) {
      final zone = pathZone(path);
      final armyType = pathArmyType(path);
      return 3 - piecesInLocationCount(armyType, zone);
    }
    return 3 - pathBarbarianControlledLandCount(path);
  }

  void pathSetTribe(Path path, Piece tribe) {
    final box = pathTribeBox(path);
    final oldTribe = pieceInLocation(PieceType.tribe, box)!;
    final oldIsStrong = tribeIsStrong(oldTribe);
    final newIsStrong = tribeIsStrong(tribe);
    setPieceLocation(oldTribe, Location.discarded);
    setPieceLocation(tribe, box);
    final armyType = pathArmyType(path);
    for (final army in armyType.pieces) {
      if (army == _stolosArmy) {
        setPieceLocation(Piece.stolos, Location.stolosLurkingBox);
        _stolosArmy = null;
      }
    }
    if (newIsStrong != oldIsStrong) {
      for (final army in piecesInLocation(armyType, Location.flipped)) {
        setPieceLocation(army, pieceLocation(pieceFlipSide(army)!));
      }
    }
  }

  void pathSetArmy(Path path, Piece army) {
    final oldArmy = pathBarbarianPiece(path);
    final land = pieceLocation(oldArmy);
    setPieceLocation(oldArmy, Location.discarded);
    setPieceLocation(army, land);
  }

  // Barbarians

  bool barbarianIsMuslim(Piece barbarian) {
    const muslimPieces = [
      Piece.armyIberiaOttoman,
      Piece.armyIberiaSaracen,
      Piece.armyIberiaSeljuk,
      Piece.armyPersiaBuyid,
      Piece.armyPersiaIlKhanid,
      Piece.armyPersiaOttoman,
      Piece.armyPersiaSaracen,
      Piece.armyPersiaSeljuk,
      Piece.armySyriaIlKhanid,
      Piece.armySyriaOttoman,
      Piece.armySyriaSaracen,
      Piece.armySyriaSeljuk,
      Piece.tribeSouthSaracen,
      Piece.tribeWestOttoman,
      Piece.tribeNorthOttoman,
    ];
    return muslimPieces.contains(barbarian);
  }

  bool barbarianUsesRex(Piece barbarian) {
    const rexBarbarians = [
      Piece.armyIberiaArmenia,
      Piece.armyIberiaPersia,
      Piece.armyPersiaPersia,
      Piece.armySyriaEgypt,
      Piece.armySyriaNomads,
      Piece.armySyriaPersia,
      Piece.tribeSouthEgypt,
      Piece.tribeSouthMoors,
      Piece.tribeSouthVandal,
      Piece.tribeSouthVenice,
      Piece.tribeWestGoth,
      Piece.tribeWestLombards,
      Piece.tribeWestNorman,
      Piece.tribeWestSerbs,
      Piece.tribeNorthBulgarians,
      Piece.tribeNorthOstrogoths,
      Piece.tribeNorthSlav,
    ];
    return rexBarbarians.contains(barbarian);
  }

  // Armies

  int armyValue(Piece army) {
    const armyValues = {
      Piece.armySouthWeak0: 3,
      Piece.armySouthWeak1: 2,
      Piece.armySouthWeak2: 2,
      Piece.armySouthWeak3: 1,
      Piece.armySouthWeak4: 1,
      Piece.armySouthStrong0: 4,
      Piece.armySouthStrong1: 3,
      Piece.armySouthStrong2: 3,
      Piece.armySouthStrong3: 2,
      Piece.armySouthStrong4: 1,
      Piece.armyWestWeak0: 3,
      Piece.armyWestWeak1: 2,
      Piece.armyWestWeak2: 2,
      Piece.armyWestWeak3: 1,
      Piece.armyWestWeak4: 1,
      Piece.armyWestStrong0: 4,
      Piece.armyWestStrong1: 3,
      Piece.armyWestStrong2: 3,
      Piece.armyWestStrong3: 2,
      Piece.armyWestStrong4: 1,
      Piece.armyNorthWeak0: 3,
      Piece.armyNorthWeak1: 2,
      Piece.armyNorthWeak2: 2,
      Piece.armyNorthWeak3: 1,
      Piece.armyNorthWeak4: 1,
      Piece.armyNorthStrong0: 4,
      Piece.armyNorthStrong1: 3,
      Piece.armyNorthStrong2: 3,
      Piece.armyNorthStrong3: 2,
      Piece.armyNorthStrong4: 1,
      Piece.armyIberiaArmenia: 2,
      Piece.armyIberiaOttoman: 4,
      Piece.armyIberiaPersia: 4,
      Piece.armyIberiaSaracen: 3,
      Piece.armyIberiaSeljuk: 4,
      Piece.armyPersiaBuyid: 2,
      Piece.armyPersiaIlKhanid: 3,
      Piece.armyPersiaOttoman: 3,
      Piece.armyPersiaPersia: 4,
      Piece.armyPersiaSaracen: 3,
      Piece.armyPersiaSeljuk: 4,
      Piece.armyPersiaMongol: 4,
      Piece.armySyriaEgypt: 2,
      Piece.armySyriaIlKhanid: 2,
      Piece.armySyriaNomads: 1,
      Piece.armySyriaOttoman: 4,
      Piece.armySyriaPersia: 4,
      Piece.armySyriaSaracen: 3,
      Piece.armySyriaSeljuk: 4,
      Piece.armySyriaMongol: 4,
      Piece.armyMagyar: 2,
      Piece.armySkanderbeg: 3,
    };
    return armyValues[army]!;
  }

  String armyName(Piece army) {
    const tribeArmyNames = {
      Piece.tribeSouthEgypt: 'Egyptian Army',
      Piece.tribeSouthMoors: 'Moorish Army',
      Piece.tribeSouthSaracen: 'Saracen Army',
      Piece.tribeSouthVandal: 'Vandal Army',
      Piece.tribeSouthVenice: 'Venetian Army',
      Piece.tribeWestGoth: 'Gothic Army',
      Piece.tribeWestLombards: 'Lombard Army',
      Piece.tribeWestNorman: 'Norman Army',
      Piece.tribeWestOttoman: 'Ottoman Turkish Army',
      Piece.tribeWestSerbs: 'Serbian Army',
      Piece.tribeNorthBulgar: 'Bulgar Army',
      Piece.tribeNorthBulgarians: 'Bulgarian Army',
      Piece.tribeNorthHun: 'Hun Army',
      Piece.tribeNorthOstrogoths: 'Ostrogothic Army',
      Piece.tribeNorthOttoman: 'Ottoman Turkish Army',
      Piece.tribeNorthSlav: 'Slav Army',
    };
    if (army.isType(PieceType.latins)) {
      return 'Latins';
    }
    if (army.isType(PieceType.riots)) {
      return 'Riots';
    }
    if (army.isType(PieceType.zoneArmy)) {
      for (final path in westernPaths) {
        final armyType = pathArmyType(path);
        if (army.isType(armyType)) {
          final tribe = pathBarbarianPiece(path);
          return '${tribeArmyNames[tribe]!} (${armyValue(army)})';
        }
      }
    }
    return army.desc;
  }

  // Stolos

  Piece? get stolosArmy {
    return _stolosArmy;
  }

  set stolosArmy(Piece? army) {
    if (_stolosArmy != null) {
      setPieceLocation(Piece.stolos, Location.stolosLurkingBox);
      _stolosArmy = null;
    }
    if (army != null) {
      setPieceLocation(Piece.stolos, pieceLocation(army));
      _stolosArmy = army;
    }
  }

  // Tribes

  bool tribeIsStrong(Piece tribe) {
    const strongTribes = [
      Piece.tribeSouthVandal,
      Piece.tribeSouthVenice,
      Piece.tribeWestLombards,
      Piece.tribeWestOttoman,
      Piece.tribeWestSerbs,
      Piece.tribeNorthBulgar,
      Piece.tribeNorthOttoman,
      Piece.tribeNorthSlav,
    ];
    return strongTribes.contains(tribe);
  }

  // Factions

  String factionName(Piece faction) {
    return faction.desc;
  }

  // Outposts

  int outpostAbandonIncome(Piece outpost) {
    const outpostIncomes = {
      Piece.outpostEgypt: 5,
      Piece.outpostHolyLand: 4,
      Piece.outpostLazica: 3,
      Piece.outpostRome: 3,
      Piece.outpostSicily: 4,
      Piece.outpostSpain: 3,
    };
    return outpostIncomes[outpost]!;
  }

  int outpostAbandonSchism(Piece outpost) {
    const outpostSchisms = {
      Piece.outpostEgypt: 2,
      Piece.outpostHolyLand: 1,
      Piece.outpostLazica: 1,
      Piece.outpostRome: 2,
      Piece.outpostSicily: 1,
      Piece.outpostSpain: 1,
    };
    return outpostSchisms[outpost]!;
  }

  Path? outpostAbandonAdvancePath(Piece outpost) {
    const outpostAdvancePaths = {
      Piece.outpostEgypt: Path.south,
      Piece.outpostHolyLand: Path.syria,
      Piece.outpostLazica: Path.iberia,
      Piece.outpostRome: null,
      Piece.outpostSicily: Path.west,
      Piece.outpostSpain: Path.north,
    };
    return outpostAdvancePaths[outpost];
  }

  // Rulers

  Piece ? get ruler {
    var piece = Piece.rulerKhan;
    var location = pieceLocation(piece);
    if (location == Location.flipped) {
      piece = Piece.rulerRex;
      location = pieceLocation(piece);
    }
    if (!location.isType(LocationType.land)) {
      return null;
    }
    return piece;
  }

  Location get rulerLocation {
    var location = pieceLocation(Piece.rulerKhan);
    if (location == Location.flipped) {
      location = pieceLocation(Piece.rulerRex);
    }
    return location;
  }

  // Dynasties

  bool dynastyIsAnarchy(Piece dynasty) {
    const anarchicDynasties = [
      Piece.dynastyPurpleAnarchy0,
      Piece.dynastyPurpleAnarchy1,
      Piece.dynastyBlackAnarchy0,
      Piece.dynastyBlackAnarchy1,
    ];
    return anarchicDynasties.contains(dynasty);
  }

  int dynastyDie(Piece dynasty) {
    const dynastyDice = {
      Piece.dynastyPurpleTheodosian: 5,
      Piece.dynastyPurpleLeonid: 5,
      Piece.dynastyPurpleJustinian: 5,
      Piece.dynastyPurpleHeraclian: 4,
      Piece.dynastyPurpleIsaurian: 4,
      Piece.dynastyPurpleAngelid: 6,
      Piece.dynastyPurpleAmorian: 5,
      Piece.dynastyPurpleMacedonian: 2,
      Piece.dynastyPurpleKomnenid: 4,
      Piece.dynastyPurpleLaskarid: 5,
      Piece.dynastyPurplePalaiologian: 2,
      Piece.dynastyPurpleDoukid: 6,
      Piece.dynastyBlackDyonisid: 5,
      Piece.dynastyBlackSkylosophid: 5,
      Piece.dynastyBlackLazarid: 5,
      Piece.dynastyBlackStemniote: 4,
      Piece.dynastyBlackSphikid: 4,
      Piece.dynastyBlackDimidid: 6,
      Piece.dynastyBlackSouliote: 5,
      Piece.dynastyBlackLantzid: 2,
      Piece.dynastyBlackManiote: 4,
      Piece.dynastyBlackKladiote: 5,
      Piece.dynastyBlackYpsilantid: 2,
      Piece.dynastyBlackVlachid: 6,
    };
    return dynastyDice[dynasty]!;
  }

  int dynastySolidus(Piece dynasty) {
    const dynastySolidi = {
      Piece.dynastyPurpleTheodosian: 2,
      Piece.dynastyPurpleLeonid: 2,
      Piece.dynastyPurpleJustinian: 3,
      Piece.dynastyPurpleHeraclian: 2,
      Piece.dynastyPurpleIsaurian: 2,
      Piece.dynastyPurpleAngelid: 1,
      Piece.dynastyPurpleAmorian: 3,
      Piece.dynastyPurpleMacedonian: 4,
      Piece.dynastyPurpleKomnenid: 3,
      Piece.dynastyPurpleLaskarid: 1,
      Piece.dynastyPurplePalaiologian: 4,
      Piece.dynastyPurpleDoukid: 1,
      Piece.dynastyBlackDyonisid: 2,
      Piece.dynastyBlackSkylosophid: 2,
      Piece.dynastyBlackLazarid: 3,
      Piece.dynastyBlackStemniote: 2,
      Piece.dynastyBlackSphikid: 2,
      Piece.dynastyBlackDimidid: 1,
      Piece.dynastyBlackSouliote: 3,
      Piece.dynastyBlackLantzid: 4,
      Piece.dynastyBlackManiote: 3,
      Piece.dynastyBlackKladiote: 1,
      Piece.dynastyBlackYpsilantid: 4,
      Piece.dynastyBlackVlachid: 1,
    };
    return dynastySolidi[dynasty] ?? 0;
  }

  bool dynastyHasSocialEvent(Piece dynasty) {
    const dynastySocials = [
      Piece.dynastyPurpleAnarchy0,
      Piece.dynastyPurpleKomnenid,
      Piece.dynastyPurplePalaiologian,
      Piece.dynastyPurpleAnarchy1,
      Piece.dynastyPurpleDoukid,
      Piece.dynastyBlackAnarchy0,
      Piece.dynastyBlackManiote,
      Piece.dynastyBlackYpsilantid,
      Piece.dynastyBlackAnarchy1,
      Piece.dynastyBlackVlachid,
    ];
    return dynastySocials.contains(dynasty);
  }

  // Basileus

  String basileusName(Piece basileus) {
    if (basileusIsFemale(basileus)) {
      return 'Empress ${basileus.desc}';
    }
    return 'Basileus ${basileus.desc}';
  }

  int basileusSolidus(Piece basileus) {
    const basileusSolidi = {
      Piece.basileusTheodosius: 3,
      Piece.basileusJustinian: 2,
      Piece.basileusBasil: 1,
      Piece.basileusZoe: 1,
      Piece.basileusConstantine0: 2,
      Piece.basileusRomanos: 1,
      Piece.basileusMichael: 1,
    };
    return basileusSolidi[basileus] ?? 0;
  }

  bool basileusIsFemale(Piece basileus) {
    const basileusFemales = [
      Piece.basileusZoe,
      Piece.basileusTheodora,
    ];
    return basileusFemales.contains(basileus);
  }

  bool basileusIsSaint(Piece basileus) {
    const basileusSaints = [
      Piece.basileusBasil,
      Piece.basileusAlexios,
      Piece.basileusConstantine0,
      Piece.basileusTheodora,
      Piece.basileusLeo,
    ];
    return basileusSaints.contains(basileus);
  }

  bool basileusIsCunning(Piece basileus) {
    const basileusPoliticians = [
      Piece.basileusAlexios,
      Piece.basileusAndronikos,
    ];
    return basileusPoliticians.contains(basileus);
  }

  bool basileusIsImpulsive(Piece basileus) {
    const basileusImpulsives = [
      Piece.basileusJohn,
      Piece.basileusLeo,
    ];
    return basileusImpulsives.contains(basileus);
  }

  bool basileusIsSoldier(Piece basileus) {
    const basileusSoldiers = [
      Piece.basileusJustinian,
      Piece.basileusBasil,
      Piece.basileusAlexios,
      Piece.basileusNikephoros,
      Piece.basileusRomanos,
    ];
    return basileusSoldiers.contains(basileus);
  }

  bool basileusHasSocialEvent(Piece basileus) {
    return basileus == Piece.basileusConstantine1;
  }

  Piece basileusAlternate(Piece piece) {
    const alternates = {
      Piece.basileusJohn: Piece.basileusAlternateAndronikos,
      Piece.basileusBasil: Piece.basileusAlternateConstantine1,
      Piece.basileusAlexios: Piece.basileusAlternateLeo,
      Piece.basileusZoe: Piece.basileusAlternateTheodora,
      Piece.basileusConstantine0: Piece.basileusAlternateRomanos,
      Piece.basileusNikephoros: Piece.basileusAlternateMichael,
      Piece.basileusAndronikos: Piece.basileusAlternateJohn,
      Piece.basileusConstantine1: Piece.basileusAlternateBasil,
      Piece.basileusLeo: Piece.basileusAlternateAlexios,
      Piece.basileusTheodora: Piece.basileusAlternateZoe,
      Piece.basileusRomanos: Piece.basileusAlternateConstantine0,
      Piece.basileusMichael: Piece.basileusAlternateNikephoros,
    };
    return alternates[piece]!;
  }

  Piece basileusPrimary(Piece piece) {
    const primaryHusbands = {
      Piece.basileusAlternateJohn: Piece.basileusJohn,
      Piece.basileusAlternateBasil: Piece.basileusBasil,
      Piece.basileusAlternateAlexios: Piece.basileusAlexios,
      Piece.basileusAlternateZoe: Piece.basileusZoe,
      Piece.basileusAlternateConstantine0: Piece.basileusConstantine0,
      Piece.basileusAlternateNikephoros: Piece.basileusNikephoros,
      Piece.basileusAlternateAndronikos: Piece.basileusAndronikos,
      Piece.basileusAlternateConstantine1: Piece.basileusConstantine1,
      Piece.basileusAlternateLeo: Piece.basileusLeo,
      Piece.basileusTheodora: Piece.basileusTheodora,
      Piece.basileusAlternateRomanos: Piece.basileusRomanos,
      Piece.basileusAlternateMichael: Piece.basileusMichael,
    };
    return primaryHusbands[piece]!;
  }

  List<Piece> get currentBasileis {
    final basileis = piecesInLocation(PieceType.basileus, Location.basileusBox);
    final husband = pieceInLocation(PieceType.basileus, Location.basileusHusbandBox);
    if (husband != null) {
      basileis.add(husband);
    }
    return basileis;
  }

  Piece get currentBasileus {
    final husband = pieceInLocation(PieceType.basileus, Location.basileusHusbandBox);
    if (husband != null) {
      return husband;
    }
    return pieceInLocation(PieceType.basileus, Location.basileusBox)!;
  }

  bool get basileisAreSaint {
    for (final basileus in currentBasileis) {
      if (basileusIsSaint(basileus)) {
        return true;
      }
    }
    return false;
  }

  String get basileisSaintName {
    for (final basileus in currentBasileis) {
      if (basileusIsSaint(basileus)) {
        return basileusName(basileus);
      }
    }
    return 'Basileus';
  }

  bool get basileisAreSoldier {
    for (final basileus in currentBasileis) {
      if (basileusIsSoldier(basileus)) {
        return true;
      }
    }
    return false;
  }

  String get basileisSoldierName {
    for (final basileus in currentBasileis) {
      if (basileusIsSoldier(basileus)) {
        return basileusName(basileus);
      }
    }
    return 'Basileus';
  }

  bool get basileisAreCunning {
    for (final basileus in currentBasileis) {
      if (basileusIsCunning(basileus)) {
        return true;
      }
    }
    return false;
  }

  bool get basileisAreImpulsive {
    for (final basileus in currentBasileis) {
      if (basileusIsImpulsive(basileus)) {
        return true;
      }
    }
    return false;
  }

  // Pope

  bool get popeNice {
    return pieceLocation(Piece.popeNice) == Location.popeBox;
  }

  bool get popeMean {
    return pieceLocation(Piece.popeMean) == Location.popeBox;
  }

  // Turns

  int get currentTurn {
    return _turn;
  }

  int get firstTurn {
    return _firstTurn;
  }

  void advanceTurn() {
    _turn += 1;
  }

  Location turnChronographiaBox(int turn) {
    return Location.values[LocationType.chronographia.firstIndex + turn];
  }

  Location get currentTurnChronographiaBox {
    return turnChronographiaBox(currentTurn);
  }

  Location futureChronographiaBox(int turns, bool useOverflow) {
    final futureTurn = currentTurn + turns;
    if (futureTurn >= 27) {
      return useOverflow ? Location.chronographiaOverflow : Location.discarded; 
    }
    return turnChronographiaBox(futureTurn);
  }

  Piece? get currentTurnChit {
    return pieceInLocation(PieceType.turnChit, currentTurnChronographiaBox);
  }

  bool turnChitHasEcumenicalCouncil(Piece turnChit) {
    const ecumenicalCouncilTurnChits = [
      Piece.turnChit4,
      Piece.turnChit7,
      Piece.turnChit10,
      Piece.turnChit11,
      Piece.turnChit15,
      Piece.turnChit22,
      Piece.turnChit26,
    ];
    return ecumenicalCouncilTurnChits.contains(turnChit);
  }

  String turnName(int turn) {
    int firstYear = 421 + turn * 40;
    int lastYear = firstYear + 39;
    return '$firstYear–$lastYear';
  }

  String? turnMagisterMilitumName(int turn) {
    const magisterMilitumNames = {
      2: 'Belisarius',
      3: 'Narses',
      4: 'Heraclius',
      8: 'Constantine',
      12: 'John Kourkouas',
      13: 'Nikephoros',
      14: 'John Tzimiskes',
      15: 'George Maniakes',
      16: 'Alexios Komnenos',
      17: 'John Komnenos',
      19: 'Alexios Vranas',
      21: 'Alexios Strategos',
      22: 'The Catalan Company',
    };
    return magisterMilitumNames[turn];
  }

  String get magisterMilitumName {
    return turnMagisterMilitumName(currentTurn)!;
  }

  // Omnibus

  Location omnibusBox(int value) {
    return Location.values[Location.omnibus0.index + value];

  }

  // Solidus / Nike

  int get solidus {
    return pieceLocation(Piece.solidus).index - Location.omnibus0.index;
  }

  void adjustSolidus(int delta) {
    int newValue = solidus + delta;
    if (newValue < 0) {
      newValue = 0;
    }
    if (newValue > 12) {
      newValue = 12;
    }
    setPieceLocation(Piece.solidus, omnibusBox(newValue));
  }

  int get nike {
    return pieceLocation(Piece.nike).index - Location.omnibus0.index;
  }

  void adjustNike(int delta) {
    int newValue = nike + delta;
    if (newValue < 0) {
      newValue = 0;
    }
    if (newValue > 12) {
      newValue = 12;
    }
    setPieceLocation(Piece.nike, omnibusBox(newValue));
  }

  void resetNike() {
    setPieceLocation(Piece.nike, Location.omnibus0);
  }

  int get solidusAndNike {
    int total = solidus;
    if (nike > 3) {
      total += nike - 3;
    }
    return min(total, 12);
  }

  // Schism

  int get schism {
    final location = pieceLocation(Piece.schism);
    if (!location.isType(LocationType.omnibus)) {
      return 0;
    }
    return location.index - Location.omnibus0.index;
  }

  void adjustSchism(int delta) {
    final location = pieceLocation(Piece.schism);
    if (!location.isType(LocationType.omnibus)) {
      return;
    }
    int oldValue = location.index - Location.omnibus0.index;
    int newValue = oldValue + delta;
    if (newValue < 0) {
      newValue = 0;
    }
    if (newValue > 13) {
      newValue = 13;
    }
    setPieceLocation(Piece.schism, omnibusBox(newValue));
  }

  // Reforms

  int get reforms {
    final location = pieceLocation(Piece.reforms);
    if (location.isType(LocationType.omnibus)) {
      return location.index - Location.omnibus0.index;
    }
    return 13;
  }

  void adjustReforms(int delta) {
    int newValue = reforms + delta;
    if (newValue < 0) {
      newValue = 0;
    }
    if (newValue > 13) {
      newValue = 13;
    }
    if (newValue == 13) {
      setPieceLocation(Piece.reforms, Location.reformsBox);
    } else {
      setPieceLocation(Piece.reforms, omnibusBox(newValue));
    }
  }

  bool get reformed {
    return pieceLocation(Piece.reforms) == Location.reformsBox;
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

  factory GameState.setupCounterTray() {
    var state = GameState();

    state.setupPieceTypes([
      (PieceType.turnChit, Location.trayTurnChits),
      (PieceType.patriarch, Location.trayPatriarchs),
      (PieceType.faction, Location.trayFactions),
      (PieceType.armySouthWeak, Location.trayPathSouth),
      (PieceType.tribeSouth, Location.trayPathSouth),
      (PieceType.armyWestWeak, Location.trayPathWest),
      (PieceType.tribeWest, Location.trayPathWest),
      (PieceType.armyNorthWeak, Location.trayPathNorth),
      (PieceType.tribeNorth, Location.trayPathNorth),
      (PieceType.basileusFront, Location.trayBasileus),
      (PieceType.armyIberia, Location.trayPathIberia),
      (PieceType.armyPersia, Location.trayPathPersia),
      (PieceType.armySyria, Location.trayPathSyria),
      (PieceType.colonists, Location.trayPolitical),
      (PieceType.dynastyPurple, Location.trayDynasties),
      (PieceType.latins, Location.trayUnits),
      (PieceType.christians, Location.trayUnits),
      (PieceType.outpost, Location.trayOutposts),
      (PieceType.unusedHospital, Location.trayGeography),
      (PieceType.unusedAkritai, Location.trayGeography),
      (PieceType.connectedMonastery, Location.trayGeography),
      (PieceType.siege, Location.traySieges),
      (PieceType.basileusAlternate, Location.discarded),
    ]);

    state.setupPieces([
        (Piece.ravenna, Location.trayPathWest),
        (Piece.bulgarianChurchOrthodox, Location.trayPathNorth),
        (Piece.bulgarianTheme, Location.trayPathNorth),
        (Piece.basileus, Location.trayBasileus),
        (Piece.reforms, Location.trayPolitical),
        (Piece.crusade, Location.trayPolitical),
        (Piece.popeNice, Location.trayPolitical),
        (Piece.caliph, Location.trayPolitical),
        (Piece.rulerKhan, Location.trayPolitical),
        (Piece.armyPersiaMongol, Location.trayMilitary),
        (Piece.armySyriaMongol, Location.trayMilitary),
        (Piece.stolos, Location.trayMilitary),
        (Piece.tribute, Location.trayMilitary),
        (Piece.kastron, Location.trayMilitary),
        (Piece.solidus, Location.trayMarkers),
        (Piece.nike, Location.trayMarkers),
        (Piece.schism, Location.trayMarkers),
        (Piece.militaryEvent, Location.trayMarkers),
        (Piece.empiresInRubble, Location.trayUnits),
        (Piece.armyMagyar, Location.trayUnits),
        (Piece.armySkanderbeg, Location.trayUnits),
        (Piece.geographyAfrica, Location.trayGeography),
        (Piece.geographyItaly, Location.trayGeography),
        (Piece.kievOrthodox, Location.traySieges),
        (Piece.magisterMilitum, Location.traySieges),
    ]);

    return state;
  }

  factory GameState.setupCampaign() {

    var state = GameState.setupCounterTray();

    state.setupPieceTypes([
      (PieceType.turnChit, Location.cupTurnChit),
      (PieceType.dynastyPurple, Location.cupDynasty),
      (PieceType.basileusFrontRandom, Location.cupBasileus),
      (PieceType.patriarch, Location.cupPatriarch),
      (PieceType.factionRegular, Location.constantinople),
      (PieceType.armySouthStrong, Location.reservesSouth),
      (PieceType.armyWestWeak, Location.reservesWest),
      (PieceType.armyNorthWeak, Location.reservesNorth),
      (PieceType.pagan, Location.arabiaBox),
    ]);

    state.setupPieces([
      (Piece.siegeSouth, Location.reservesSouth),
      (Piece.siegeWest, Location.reservesWest),
      (Piece.siegeNorth, Location.reservesNorth),
      (Piece.factionTheodosianWalls, Location.omnibus5),
      (Piece.factionHagiaSophia, Location.omnibus5),
      (Piece.tribeSouthVandal, Location.southTribeBox),
      (Piece.armySouthStrong0, Location.zoneSouth),
      (Piece.tribeWestGoth, Location.westTribeBox),
      (Piece.armyWestWeak0, Location.zoneWest),
      (Piece.tribeNorthHun, Location.northTribeBox),
      (Piece.armyNorthWeak0, Location.zoneNorth),
      (Piece.armyIberiaPersia, Location.homelandIberia),
      (Piece.armyPersiaPersia, Location.homelandPersia),
      (Piece.armySyriaNomads, Location.homelandSyria),
      (Piece.outpostEgypt, Location.outpostEgyptBox),
      (Piece.outpostLazica, Location.availableOutpostsBox),
      (Piece.armySyriaEgypt, Location.egyptianReligionBox),
      (Piece.popeNice, Location.popeBox),
      (Piece.rulerKhan, Location.chronographia5),
      (Piece.dynastyPurpleTheodosian, Location.dynastyBox),
      (Piece.dynastyPurpleJustinian, Location.chronographia3),
      (Piece.basileusTheodosius, Location.basileusBox),
      (Piece.basileus, Location.constantinople),
      (Piece.stolos, Location.stolosLurkingBox),
      (Piece.kievPagan, Location.kyivBox),
      (Piece.patriarchNestorius, Location.patriarchBox),
      (Piece.schism, Location.omnibus0),
      (Piece.reforms, Location.omnibus0),
      (Piece.nike, Location.omnibus0),
      (Piece.solidus, Location.omnibus1),
      (Piece.geographyAfrica, Location.zoneSouth),
      (Piece.geographyItaly, Location.zoneWest),
      (Piece.militaryEvent, Location.militaryEventBox),
    ]);

    return state;
  }

  factory GameState.setupMillennium(Random random) {

    var state = GameState.setupCounterTray();

    state._turn = 14;
    state._firstTurn = 14;

    state.setupPieceTypes([
      (PieceType.turnChitFirstMillenium, Location.discarded),
      (PieceType.turnChitSecondMillenium, Location.cupTurnChit),
      (PieceType.basileusFrontRandom, Location.cupBasileus),
      (PieceType.patriarchSchism, Location.discarded),
      (PieceType.patriarchNonSchism, Location.cupPatriarch),
      (PieceType.faction, Location.constantinople),
      (PieceType.armySouthWeak, Location.reservesSouth),
      (PieceType.armyWestWeak, Location.reservesWest),
      (PieceType.armyNorthWeak, Location.reservesNorth),
    ]);

    final patriarchs = PieceType.patriarchNonSchism.pieces;
    patriarchs.shuffle(random);

    state.setupPieces([
      (Piece.siegeSouth, Location.reservesSouth),
      (Piece.siegeWest, Location.reservesWest),
      (Piece.siegeNorth, Location.reservesNorth),
      (Piece.tribeSouthSaracen, Location.southTribeBox),
      (Piece.armySouthWeak0, Location.zoneSouth),
      (Piece.armySouthWeak1, Location.zoneSouth),
      (Piece.tribeWestNorman, Location.westTribeBox),
      (Piece.armyWestWeak0, Location.zoneWest),
      (Piece.armyWestWeak1, Location.zoneWest),
      (Piece.armyWestWeak2, Location.zoneWest),
      (Piece.tribeNorthBulgarians, Location.northTribeBox),
      (Piece.armyNorthWeak0, Location.zoneNorth),
      (Piece.armyNorthWeak1, Location.zoneNorth),
      (Piece.infrastructureMonastery0, Location.zoneNorth),
      (Piece.armyIberiaArmenia, Location.themeLesserArmenia),
      (Piece.armyPersiaBuyid, Location.themeMelitene),
      (Piece.infrastructureAkritai0, Location.themeCappadocia),
      (Piece.armySyriaSaracen, Location.themeCilicia),
      (Piece.infrastructureAkritai1, Location.themeEphesus),
      (Piece.outpostSicily, Location.outpostSicilyBox),
      (Piece.outpostLazica, Location.outpostLazicaGreekFireBox),
      (Piece.egyptMuslim, Location.egyptianReligionBox),
      (Piece.popeMean, Location.popeBox),
      (Piece.rulerKhan, Location.homelandSyria),
      (Piece.caliph, Location.homelandPersia),
      (Piece.dynastyPurpleMacedonian, Location.dynastyBox),
      (Piece.dynastyPurpleKomnenid, Location.cupDynasty),
      (Piece.dynastyPurpleLaskarid, Location.cupDynasty),
      (Piece.dynastyPurplePalaiologian, Location.cupDynasty),
      (Piece.basileusBasil, Location.basileusBox),
      (Piece.basileus, Location.constantinople),
      (Piece.stolos, Location.stolosLurkingBox),
      (Piece.kievPagan, Location.kyivBox),
      (patriarchs[0], Location.patriarchBox),
      (Piece.schism, Location.omnibus5),
      (Piece.nike, Location.omnibus3),
      (Piece.solidus, Location.omnibus3),
      (Piece.geographyCrete, Location.zoneSouth),
      (Piece.geographyBalkans, Location.zoneWest),
      (Piece.bulgarianChurchOrthodox, Location.bulgarianChurchBox),
      (Piece.colonistsPersia, Location.themeNisibis),
      (Piece.colonistsSyria, Location.themeDamascus),
      (Piece.militaryEvent, Location.militaryEventBox),
      (Piece.reforms, Location.reformsBox),
    ]);

    state.limitedEventOccurred(LimitedEvent.fallOfRome);
    state.limitedEventOccurred(LimitedEvent.ravenna);
    state.limitedEventOccurred(LimitedEvent.warInTheEast); // Triggered beginning and end, so twice per war
    state.limitedEventOccurred(LimitedEvent.warInTheEast);
    state.limitedEventOccurred(LimitedEvent.warInTheEast);
    state.limitedEventOccurred(LimitedEvent.warInTheEast);
    return state;
  }
}

enum Choice {
  blockMagyarSacrifice,
  blockMagyarProp,
  blockSkanderbegSacrifice,
  blockSkanderbegProp,
  shiftForces,
  attackWithSolidus,
  attackWithMagisterMilitum,
  attackWithSoldierEmperor,
  attackWithBasileusIntoBattle,
  seizeOutpost,
  abandonOutpost,
  buildMonastery,
  buildMonasterySlavery,
  combatPlague,
  reopenMonasteries,
  buildHospital,
  buildHospitalSlavery,
  abandonHospital,
  buildAkritai,
  abandonAkritai,
  exploitSocialDifferences,
  calmRiot,
  enforceOrthodoxy,
  buildFaction,
  cleanRubble,
  activateGreekFire,
  faceRuler,
  faceCaliph,
  legendaryOrator,
  navalReforms,
  ruinousTaxation,
  churchPolitics,
  legislate,
  visionaryReformer,
  expelColonists,
  pandidakterion,
  enforceOrthodoxyIgnoreDrms,
  enforceOrthodoxyFree,
  increaseSchism,
  incurRiot,
  reduceSchism,
  earnSolidus,
  adjustDieUp,
  adjustDieDown,
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
  defeatConstantinople,
  defeatSchism,
  victory,
}

class GameOutcome {
  GameResult result;
  int victoryPoints;

  GameOutcome(this.result, this.victoryPoints);

  GameOutcome.fromJson(Map<String, dynamic> json) :
    result = GameResult.values[json['result'] as int],
    victoryPoints = json['victoryPoints'] as int;

  Map<String, dynamic> toJson() => {
    'result': result.index,
    'victoryPoints': victoryPoints,
  };
}

class GameOverException implements Exception {
  GameOutcome outcome;

  GameOverException(GameResult result, int victoryPoints) :
    outcome = GameOutcome(result, victoryPoints);
}

enum Phase {
  turnStart,
  leadership,
  synopsisOfHistories,
  barbarians,
  byzantineAction,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateTurnStart extends PhaseState {
  Path? randomBarbarianPath;

  PhaseStateTurnStart();

  PhaseStateTurnStart.fromJson(Map<String, dynamic> json) :
    randomBarbarianPath = pathFromIndex(json['randomBarbarianPath'] as int?);

  @override
  Map<String, dynamic> toJson() => {
    'randomBarbarianPath': pathToIndex(randomBarbarianPath),
  };

  @override
  Phase get phase {
    return Phase.turnStart;
  }
}

class PhaseStateLeadership extends PhaseState {
  Path? socialEventPath;

  PhaseStateLeadership();

  PhaseStateLeadership.fromJson(Map<String, dynamic> json) :
    socialEventPath = pathFromIndex(json['socialEventPath'] as int?);

  @override
  Map<String, dynamic> toJson() => {
    'socialEventPath': pathToIndex(socialEventPath),
  };

  @override
  Phase get phase {
    return Phase.leadership;
  }
}

class PhaseStateSynopsisOfHistories extends PhaseState {
  int militaryTotal;
  int politicalTotal;
  int? warInTheEast1Die0;
  int? warInTheEast1Die1;
  int? warInTheEast1PersianAdvanceCount;
  int? warInTheEast1PersianRetreatCount;
  int? rotrudeDieRoll;
  bool seljuksTriggerCrusades = false;

  PhaseStateSynopsisOfHistories(this.militaryTotal, this.politicalTotal);

  PhaseStateSynopsisOfHistories.fromJson(Map<String, dynamic> json) :
    militaryTotal = json['militaryTotal'] as int,
    politicalTotal = json['politicalTotal'] as int,
    warInTheEast1Die0 = json['warInTheEast1Die0'] as int?,
    warInTheEast1Die1 = json['warInTheEast1Die1'] as int?,
    warInTheEast1PersianAdvanceCount = json['warInTheEast1PersianAdvanceCount'] as int?,
    warInTheEast1PersianRetreatCount = json['warInTheEast1PersianRetreatCount'] as int?,
    rotrudeDieRoll = json['rotrudeDieRoll'] as int?,
    seljuksTriggerCrusades = json['seljuksTriggerCrusades'] as bool;

  @override
  Map<String, dynamic> toJson() => {
    'militaryTotal': militaryTotal,
    'politicalTotal': politicalTotal,
    'warInTheEast1Die0': warInTheEast1Die0,
    'warInTheEast1Die1': warInTheEast1Die1,
    'warInTheEast1PersianAdvanceCount': warInTheEast1PersianAdvanceCount,
    'warInTheEast1PersianRetreatCount': warInTheEast1PersianRetreatCount,
    'rotrudeDieRoll': rotrudeDieRoll,
    'seljuksTriggerCrusades': seljuksTriggerCrusades,
  };

  @override
  Phase get phase {
    return Phase.synopsisOfHistories;
  }
}

class PhaseStateBarbarians extends PhaseState {
  List<int> pathAdvanceCounts = List<int>.filled(Path.values.length, 0);

  PhaseStateBarbarians();

  PhaseStateBarbarians.fromJson(Map<String, dynamic> json) :
    pathAdvanceCounts = json['pathAdvanceCounts'] as List<int>;

  @override
  Map<String, dynamic> toJson() => {
    'pathAdvanceCounts': pathAdvanceCounts,
  };

  @override
  Phase get phase {
    return Phase.barbarians;
  }
}

class PhaseStateByzantineAction extends PhaseState {
  int shiftForcesRetreatCount = 0;
  int soldierEmperorFreeAttackCount = 0;
  bool magisterMilitumFreeAttack = false;
  bool basileusIntoBattle = false;
  Piece? attackTarget;
  Piece? expelColonists;
  Path? advancePath;
  int? postAdvanceSchismAdjustment;
  int? magisterMilitumDefeatStrength;
  bool enforceOrthodoxyIgnoreDrms = false;
  bool enforceOthodoxyFree = false;
  bool useBasileus = false;

  PhaseStateByzantineAction();

  PhaseStateByzantineAction.fromJson(Map<String, dynamic> json) :
    shiftForcesRetreatCount = json['shiftForcesRetreatCount'] as int,
    soldierEmperorFreeAttackCount = json['soldierEmperorFreeAttackCount'] as int,
    magisterMilitumFreeAttack = json['magisterMilitumFreeAttack'] as bool,
    basileusIntoBattle = json['basileusIntoBattle'] as bool,
    attackTarget = pieceFromIndex(json['attackTarget'] as int?),
    expelColonists = pieceFromIndex(json['expelColonists'] as int?),
    advancePath = pathFromIndex(json['advancePath'] as int?),
    postAdvanceSchismAdjustment = json['postAdvanceSchismAdjustment'] as int?,
    magisterMilitumDefeatStrength = json['magisterMilitumDefeatStrength'] as int?,
    enforceOrthodoxyIgnoreDrms = json['enforceOrthodoxyIgnoreDrms'] as bool,
    enforceOthodoxyFree = json['enforceOrthodoxyFree'] as bool,
    useBasileus = json['useBasileus'] as bool;

  @override
  Map<String, dynamic> toJson() => {
    'shiftForcesRetreatCount': shiftForcesRetreatCount,
    'soldierEmperorFreeAttackCount': soldierEmperorFreeAttackCount,
    'magisterMilitumFreeAttack': magisterMilitumFreeAttack,
    'basileusIntoBattle': basileusIntoBattle,
    'attackTarget': pieceToIndex(attackTarget),
    'expelColonists': pieceToIndex(expelColonists),
    'advancePath': pathToIndex(advancePath),
    'postAdvanceSchismAdjustment': postAdvanceSchismAdjustment,
    'magisterMilitumDefeatStrength': magisterMilitumDefeatStrength,
    'enforceOrthodoxyIgnoreDrms': enforceOrthodoxyIgnoreDrms,
    'enforceOrthodoxyFree': enforceOthodoxyFree,
    'useBasileus': useBasileus,
  };

  @override
  Phase get phase {
    return Phase.byzantineAction;
  }
}

class RollD6ForEasternPathState {
  int? d60;
  int? d61;

  RollD6ForEasternPathState();

  RollD6ForEasternPathState.fromJson(Map<String, dynamic> json) :
    d60 = json['d60'] as int?,
    d61 = json['d61'] as int?;
  
  Map<String, dynamic> toJson() => {
    'd60': d60,
    'd61': d61,
  };
}

class BarbariansAdvanceState {
  int subStep = 0;
  bool kastronUsed = false;
  int fizzleFactionCount = 0;

  BarbariansAdvanceState();

  BarbariansAdvanceState.fromJson(Map<String, dynamic> json) :
    subStep = json['subStep'] as int,
    kastronUsed = json['kastronUsed'] as bool,
    fizzleFactionCount = json['fizzleFactionCount'] as int;

  Map<String, dynamic> toJson() => {
    'subStep': subStep,
    'kastronUsed': kastronUsed,
    'fizzleFactionCount': fizzleFactionCount,
  };
}

class FreeAttackState {
  int subStep = 0;
  Piece? target;

  FreeAttackState();

  FreeAttackState.fromJson(Map<String, dynamic> json) :
    subStep = json['subStep'] as int,
    target = pieceFromIndex(json['target'] as int?);
  
  Map<String, dynamic> toJson() => {
    'subStep': subStep,
    'target': pieceToIndex(target),
  };
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

class GameOptions {
  bool redRandomBarbarians = false;
  bool islamEvent = false;
  bool circledEvents = false;
  bool separateMilitaryPoliticalEvents = false;
  bool controlEcumenicalCouncils = false;
  bool justinianCivilWar = false;
  bool italyImportant = false;
  bool historicalPatriarchs = false;
  bool anatolianPlateau = false;
  bool armeniansAndOttomans = false;

  GameOptions();

  GameOptions.fromJson(Map<String, dynamic> json) :
    redRandomBarbarians = json['redRandomBarbarians'] as bool,
    islamEvent = json['islamEvent'] as bool,
    circledEvents = json['circledEvents'],
    separateMilitaryPoliticalEvents = json['separateMilitaryPoliticalEvents'],
    controlEcumenicalCouncils = json['controlEcumenicalCouncils'],
    justinianCivilWar = json['justinianCivilWar'],
    italyImportant = json['italyImportant'],
    historicalPatriarchs = json['historicalPatriarchs'],
    anatolianPlateau = json['anatolianPlateau'],
    armeniansAndOttomans = json['armeniansAndOttomans'];

  Map<String, dynamic> toJson() => {
    'redRandomBarbarians': redRandomBarbarians,
    'islamEvent': islamEvent,
    'circledEvents': circledEvents,
    'separateMilitaryPoliticalEvents': separateMilitaryPoliticalEvents,
    'controlEcumenicalCouncils': controlEcumenicalCouncils,
    'justinianCivilWar': justinianCivilWar,
    'italyImportant': italyImportant,
    'historicalPatriarchs': historicalPatriarchs,
    'anatolianPlateau': anatolianPlateau,
    'armeniansAndOttomans': armeniansAndOttomans,
  };

  String get desc {
    String optionsList = '';
    if (redRandomBarbarians) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Red Die Advances';
    }
    if (islamEvent) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Islam Event';
    }
    if (circledEvents) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Circled Events';
    }
    if (separateMilitaryPoliticalEvents) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Separate Events Rolls';
    }
    if (controlEcumenicalCouncils) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Control Ecumenical Councils';
    }
    if (justinianCivilWar) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Justinian and Civil War';
    }
    if (italyImportant) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Italy Is Important';
    }
    if (historicalPatriarchs) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Historical Patriarchs';
    }
    if (anatolianPlateau) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Anatolian Plateau';
    }
    if (armeniansAndOttomans) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Armenians and Ottomans';
    }
    return optionsList;
  }
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
  RollD6ForEasternPathState? _rollD6ForEasternPathState;
  BarbariansAdvanceState? _barbariansAdvanceState;
  FreeAttackState? _freeAttackState;
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
      case Phase.turnStart:
        _phaseState = PhaseStateTurnStart.fromJson(phaseStateJson);
      case Phase.leadership:
        _phaseState = PhaseStateLeadership.fromJson(phaseStateJson);
      case Phase.synopsisOfHistories:
        _phaseState = PhaseStateSynopsisOfHistories.fromJson(phaseStateJson);
      case Phase.barbarians:
        _phaseState = PhaseStateBarbarians.fromJson(phaseStateJson);
      case Phase.byzantineAction:
        _phaseState = PhaseStateByzantineAction.fromJson(phaseStateJson);
      }
    }

    final rollD6ForEasternPathStateJson = json['rollD6ForEasternPath'];
    if (rollD6ForEasternPathStateJson != null) {
      _rollD6ForEasternPathState = RollD6ForEasternPathState.fromJson(rollD6ForEasternPathStateJson);
    }
    final barbariansAdvanceStateJson = json['barbariansAdvance'];
    if (barbariansAdvanceStateJson != null) {
      _barbariansAdvanceState = BarbariansAdvanceState.fromJson(barbariansAdvanceStateJson);
    }
    final freeAttackStateJson = json['freeAttack'];
    if (freeAttackStateJson != null) {
      _freeAttackState = FreeAttackState.fromJson(freeAttackStateJson);
    }

    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
    if (_phaseState != null) {
      map['phase'] = _phaseState!.phase.index;
      map['phaseState'] = _phaseState!.toJson();
    }
    if (_rollD6ForEasternPathState!= null) {
      map['rollD6ForEasternPath'] = _rollD6ForEasternPathState!.toJson();
    }
    if (_barbariansAdvanceState != null) {
      map['barbariansAdvance'] = _barbariansAdvanceState!.toJson();
    }
    if (_freeAttackState != null) {
      map['freeAttack'] = _freeAttackState!.toJson();
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

int dieWithDrm(int die, int drm) {
    if (die == 1 || die == 6) {
      return die;
    }
    return die + drm;
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

  // Patriarchs

  String get currentPatriarchName {
    if (!_options.historicalPatriarchs) {
      final patriarch = _state.pieceInLocation(PieceType.patriarch, Location.patriarchBox)!;
      return patriarch.desc;
    }
    const patriarchNames = [
      'Nestorius',
      'Acacius',
      'Anthimus',
      'John IV Nesteutes',
      'Sergius I',
      'Paul II',
      'George I',
      'Germanus I',
      'Tarasius',
      'Methodius I',
      'Photius I',
      'Ignatius',
      'Nicholas I Mystikos',
      'Polyeuctus',
      'Sergius II',
      'Michael I Cerularius',
      'John VIII Xiphilinos',
      'John IX Agapetos',
      'Michael III of Anchialus',
      'John XI Bekkos',
      'Manuel I Charitopoulos',
      'Joseph I Galesiotes',
      'John XIII Glykys',
      'John XIV Kalekas',
      'Matthew I',
      'Gennadius Scholarius',
      'Dionysius I',
    ];
    return patriarchNames[_state.currentTurn];
  }

  Piece get historicPatriarchPiece {
    const patriarchPieces = [
      Piece.patriarchNestorius,
      Piece.patriarchPeter,
      Piece.patriarchAnthimus,
      Piece.patriarchConstantine,
      Piece.patriarchSergius,
      Piece.patriarchPaul,
      Piece.patriarchNicholas,
      Piece.patriarchConstantine,
      Piece.patriarchNicholas,
      Piece.patriarchPeter,
      Piece.patriarchAnthimus,
      Piece.patriarchSergius,
      Piece.patriarchPaul,
      Piece.patriarchNicholas,
      Piece.patriarchConstantine,
      Piece.patriarchPeter,
      Piece.patriarchPaul,
      Piece.patriarchConstantine,
      Piece.patriarchPaul,
      Piece.patriarchPeter,
      Piece.patriarchMichael,
      Piece.patriarchAnthimus,
      Piece.patriarchMichael,
      Piece.patriarchSergius,
      Piece.patriarchConstantine,
      Piece.patriarchJohn,
      Piece.patriarchPaul,
    ];
    return patriarchPieces[_state.currentTurn];
  }

  int get currentPatriarchSolidus {
    if (!_options.historicalPatriarchs) {
      const patriarchSolidi = {
        Piece.patriarchJohn: 3,
        Piece.patriarchAntony: 1,
        Piece.patriarchPaul: 1,
        Piece.patriarchConstantine: 1,
        Piece.patriarchNicholas: 2,
      };
      final patriarch = _state.pieceInLocation(PieceType.patriarch, Location.patriarchBox)!;
      return patriarchSolidi[patriarch] ?? 0;
    } else {
      const patriarchSolidi = {
        3: 1,
        5: 1,
        6: 2,
        7: 1,
        8: 2,
        12: 1,
        13: 2,
        14: 1,
        16: 1,
        17: 1,
        18: 1,
        24: 1,
        25: 3,
        26: 1,
      };
      return patriarchSolidi[_state.currentTurn] ?? 0;
    }
  }

  bool get currentPatriarchIncreasesSchism {
    if (!_options.historicalPatriarchs) {
      final patriarch = _state.pieceInLocation(PieceType.patriarch, Location.patriarchBox)!;
      return patriarch.isType(PieceType.patriarchSchism);
    } else {
      const schismaticPatriarchs = [ 1, 2, 4, 9, 10, 11, 15, 19, 21, 23,];
      return schismaticPatriarchs.contains(_state.currentTurn);
    }
  }

  bool get currentPatriarchIsSaint {
    if (!_options.historicalPatriarchs) {
      const patriarchSaints = [
        Piece.patriarchAntony,
        Piece.patriarchMichael,
      ];
      final patriarch = _state.pieceInLocation(PieceType.patriarch, Location.patriarchBox)!;
      return patriarchSaints.contains(patriarch);
    } else {
      return false;
    }
  }

  bool get haveSaint {
    if (_state.basileisAreSaint) {
      return true;
    }
    if (currentPatriarchIsSaint) {
      return true;
    }
    return false;
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
    logLine('>${_state.factionName(faction)} is eliminated from ${_state.landName(Location.constantinople)}.');
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
      logLine('>\$olidus: +$delta → ${_state.solidus}');
    } else if (delta < 0) {
      logLine('>\$olidus: $delta → ${_state.solidus}');
    }
  }

  void adjustNike(int delta) {
    _state.adjustNike(delta);
    if (delta > 0) {
      logLine('>Nike: +$delta → ${_state.nike}');
    } else if (delta < 0) {
      logLine('>Nike: $delta → ${_state.nike}');
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
      logLine('>Schism: +$delta → ${_state.schism}');
      if (_state.schism > 12) {
        logLine('# Defeat: Schism exceeds 12');
        throw GameOverException(GameResult.defeatSchism, 0);
      }
    } else if (delta < 0) {
      logLine('>Schism: $delta → ${_state.schism}');
    }
  }

  void adjustReforms(int delta) {
    _state.adjustReforms(delta);
    if (delta > 0) {
      logLine('>Reforms: +$delta → ${_state.reforms}');
      if (_state.reformed) {
        logLine('>Reforms achieved.');
      }
    }
  }

  // High-Level Functions

  void armyEntersZone(Piece army, Location zone) {
    final path = _state.landPath(zone)!;
    logLine('>${_state.armyName(army)} deploys to ${_state.pathGeographicName(path)}.');
    _state.setPieceLocation(army, zone);
    final armyType = _state.pathArmyType(path);
    int armyCount = _state.piecesInLocationCount(armyType, zone);
    if (armyCount >= 4) {
      if (_state.pieceLocation(Piece.ravenna) == zone) {
        logLine('>Ravenna falls under the control of the Holy Roman Empire.');
        _state.setPieceLocation(Piece.holyRomanEmpire, zone);
      }
    }
    if (armyCount >= 5) {
      final monastery = _state.pieceInLocation(PieceType.connectedMonastery, zone);
      if (monastery != null) {
        logLine('>Monastery in ${_state.pathGeographicName(path)} is isolated.');
        _state.setPieceLocation(_state.pieceFlipSide(monastery)!, zone);
      }
    }
  }

  void armyLeavesZone(Piece army, Location zone) {
    logLine('>${_state.armyName(army)} returns to the Reserves.');
    final path = _state.landPath(zone)!;
    final reserves = _state.pathReserves(path);
    _state.setPieceLocation(army, reserves);
  }

  void italyFalls() {
    _state.setPieceLocation(Piece.geographyBalkans, Location.zoneWest);
    if (_state.pieceLocation(Piece.ravenna) == Location.zoneWest) {
      logLine('>Ravenna is taken.');
      _state.setPieceLocation(Piece.ravenna, Location.discarded);
    }
    if (_state.pieceLocation(Piece.holyRomanEmpire) == Location.zoneWest) {
      _state.setPieceLocation(Piece.holyRomanEmpire, Location.discarded);
    }
    if (_options.italyImportant && _state.limitedEventCount(LimitedEvent.eastWestSchism) > 0) {
      logLine('>Popes focus on Western Europe.');
      _state.setPieceLocation(Piece.popeNice, Location.discarded);
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

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
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
      setPrompt('Use Akritai to modify die roll of $die?');
      choiceChoosable(Choice.adjustDieUp, die < 6);
      choiceChoosable(Choice.adjustDieDown, die > 1);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    int die = _rollD6ForEasternPathState!.d60!;
    _rollD6ForEasternPathState = null;
    if (checkChoice(Choice.adjustDieUp)) {
      logLine('>Akritai is used to increase die roll.');
      _state.pathUseAkritai(path);
      die += 1;
    }
    if (checkChoice(Choice.adjustDieDown)) {
      logLine('>Akritai is used to reduce die roll.');
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
      int die0 = max(results.$1, results.$2);
      int die1 = min(results.$1, results.$2);
      _rollD6ForEasternPathState!.d60 = die0;
      _rollD6ForEasternPathState!.d61 = die1;
      setPrompt('Use Akritai to reroll die roll of $die0 $die1?');
      choiceChoosable(Choice.yes, true);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    int die0 = _rollD6ForEasternPathState!.d60!;
    int die1 = _rollD6ForEasternPathState!.d61!;
    _rollD6ForEasternPathState = null;
    if (checkChoice(Choice.yes)) {
      logLine('>Akritai is used to reroll die.');
      _state.pathUseAkritai(path);
      die0 = rollD6();
      logD6(die0);
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

    logTableHeader();
    logD6InTable(die);
    bool victory = false;
    if (attackType != AttackType.intoBattleNoSword) {
      int drm = 0;
      final strategikon = _state.pieceLocation(Piece.militaryEvent);
      switch (strategikon) {
      case Location.strategikonExcubitors:
        if (path == Path.south) {
          logLine('>|Excubitors|+1|');
          drm += 1;
        }
      case Location.strategikonDonatists:
        if (path == Path.south) {
          logLine('>|Donatists|-1|');
          drm -= 1;
        }
      case Location.strategikonCannons:
        if (path == Path.west) {
          logLine('>|Cannons|+1|');
          drm += 1;
        }
      case Location.strategikonTheBlackDeath:
        if (path == Path.west) {
          logLine('>|The Black Death|-1|');
          drm -= 1;
        }
      case Location.strategikonLatinikon:
        if (path == Path.north) {
          logLine('>|Latinikon|+1|');
          drm += 1;
        }
      case Location.strategikonIconoclasm:
        if (path == Path.north) {
          logLine('>|Iconoclasm|-1|');
          drm -= 1;
        }
      case Location.strategikonCataphracts:
        if (path == Path.iberia) {
          logLine('>|Cataphracts|+1|');
          drm += 1;
        }
      case Location.strategikonBagratids:
        if (path == Path.iberia) {
          logLine('>|Bagratids|-1|');
          drm -= 1;
        }
      case Location.strategikonVarangianGuards:
        if (path == Path.persia) {
          logLine('>|Varangian Guards|+1|');
          drm += 1;
        }
      case Location.strategikonDisloyalMercenaries:
        if (path == Path.persia) {
          logLine('>|Disloyal Mercenaries|-1|');
          drm -= 1;
        }
      case Location.strategikonTagmataTroops:
        if (path == Path.syria) {
          logLine('>|Tagmata Troops|+1|');
          drm += 1;
        }
      case Location.strategikonMightyEgypt:
        if (path == Path.syria) {
          logLine('>|Mighty Egypt|-1|');
          drm -= 1;
        }
      default:
      }
      if (_state.piecesInLocationCount(PieceType.christians, finalLand) > 0) {
        logLine('>|Christians|+1|');
        drm += 1;
      }
      if (_state.piecesInLocationCount(PieceType.dynatoi, finalLand) > 0) {
        logLine('>|Dynatoi|-1|');
        drm -= 1;
      }
      if (army == _state.stolosArmy && _state.pieceLocation(Piece.outpostLazica) == Location.outpostLazicaGreekFireBox) {
        logLine('>|Greek Fire|+2|');
        drm += 2;
      }
      if (_state.pieceLocation(Piece.bulgarianTheme) == land) {
        logLine('>|Bulgarian Theme|+1|');
        drm += 1;
      }
      if (_state.pieceLocation(Piece.ravenna) == land) {
        logLine('>|Ravenna|+1|');
        drm += 1;
      }
      if (_state.pieceLocation(Piece.holyRomanEmpire) == land) {
        logLine('>|Holy Roman Empire|-1|');
        drm -= 1;
      }
      if (land == Location.zoneNorth) {
        if (_state.pieceLocation(Piece.bulgarianChurchOrthodox) == Location.bulgarianChurchBox) {
          logLine('>|Bulgarian Eastern Orthodox Church|+1|');
          drm += 1;
        }
        if (_state.pieceLocation(Piece.bulgarianChurchCatholic) == Location.bulgarianChurchBox) {
          logLine('>|Bulgarian Roman Catholic Church|-1|');
          drm -= 1;
        }
      }
      if (_state.reformed && land == _state.pathFirstLand(path)) {
        if (_state.easternPaths.contains(path) || _state.piecesInLocationCount(armyType, land) >= 5) {
          logLine('>|Greek Patriôtes|+1|');
          drm += 1;
        }
      }
      if (_state.piecesInLocationCount(PieceType.latins, Location.constantinople) > 0) {
        logLine('>|Latins|-1|');
        drm -= 1;
      } else if (_state.piecesInLocationCount(PieceType.riots, Location.constantinople) > 0) {
        logLine('>|Riots|-1|');
        drm -= 1;
      }
      if (attackType == AttackType.magisterMilitum) {
        logLine('>|Magister Militum|+1|');
        drm += 1;
      }
      if (_state.currentEventCurrent(CurrentEvent.comet)) {
        logLine('>|Comet|-1|');
        drm -= 1;
        _state.setCurrentEventOccurred(CurrentEvent.comet, false);
      }
      int modifiedDie = dieWithDrm(die, drm);
      logLine('>|Modified|$modifiedDie|');
      logLine('>|${_state.armyName(army)}|$strength|');
      logTableFooter();

      victory = modifiedDie > strength;
    } else {
      victory = die >= 2 && die <= 5;
    }
    if (victory) {
      logLine('>${_state.armyName(army)} is defeated.');
      if (_state.stolosArmy == army) {
        logLine('>Stolos is destroyed.');
        _state.setPieceLocation(Piece.stolos, Location.stolosLurkingBox);
        _state.stolosArmy = null;
      }
      if (_state.westernPaths.contains(path)) {
        int armyCount = _state.piecesInLocationCount(armyType, land);
        if (armyCount == 1) {
          if (_state.limitedEventCount(LimitedEvent.tricameron) < 0 && _state.pathBarbarianPiece(path) == Piece.tribeSouthVandal) {
            logLine('>Vandals are defeated at the Battle of Tricameron.');
            logLine('>Moors resist further Byzantine expansion in Africa.');
            _state.pathSetTribe(path, Piece.tribeSouthMoors);
            _state.limitedEventOccurred(LimitedEvent.tricameron);
          }
          if (_state.limitedEventCount(LimitedEvent.kleidion) < 0 && _state.pathBarbarianPiece(path) == Piece.tribeNorthBulgar) {
            logLine('>Bulgars are defeated at the Battle of Kleidίon and reduced to vassalship.');
            _state.setPieceLocation(Piece.bulgarianTheme, Location.zoneNorth);
            _state.limitedEventOccurred(LimitedEvent.kleidion);
          }
        }
        if (armyCount >= 2) {
          armyLeavesZone(army, land);
        }
      } else {
        if (land != finalLand && !_state.landIsMuslim(land)) {
          final nextLand = _state.pathNextLocation(path, land)!;
          logLine('>${_state.armyName(army)} retreats to ${_state.landName(nextLand)}.');
          _state.setPieceLocation(army, nextLand);
        }
      }
      if (attackType != AttackType.free && attackType != AttackType.shiftForces) {
        adjustNike(1);
      }
    } else {
      logLine('>Attack on ${_state.armyName(army)} is repulsed.');
    }
    if (basileusDelay > 0) {
      _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(basileusDelay, true));
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

      logTableHeader();
      logD6InTable(die);
      if (attackType == AttackType.magisterMilitum) {
        logLine('>|Magister Militum|+1|');
        drm += 1;
      }
      if (army.isType(PieceType.latins) && _state.currentEventCurrent(CurrentEvent.warOfTheSicilianVespers)) {
        logLine('>|War of the Sicilian Vespers|+1|');
        drm += 1;
      }
      if (_state.currentEventCurrent(CurrentEvent.comet)) {
        logLine('>|Comet|-1|');
        drm -= 1;
        _state.setCurrentEventOccurred(CurrentEvent.comet, false);
      }
      int modifiedDie = dieWithDrm(die, drm);
      logLine('>|Modified|$modifiedDie|');
      logLine('>|${_state.armyName(army)}|$strength|');
      logTableFooter();

      victory = modifiedDie > strength;
    } else {
      logD6(die);
      victory = die >= 2 && die <= 5;
    }
    if (victory) {
      logLine('>${_state.armyName(army)} are defeated.');
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
      logLine('>Attack on ${_state.armyName(army)} is repulsed.');
    }
    if (basileusDelay > 0) {
      _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(basileusDelay, true));
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
      logLine('>Attack ${_state.armyName(army)} in ${_state.landName(land)}');
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
      logLine('### ${tribe.desc} advance in ${_state.pathGeographicName(path)}');
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
        setPrompt('Choose how to defend');
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.blockMagyarSacrifice) || checkChoice(Choice.blockSkanderbegSacrifice)) {
        final propUnit = checkChoice(Choice.blockMagyarSacrifice) ? Piece.armyMagyar : Piece.armySkanderbeg;
        logLine('>${propUnit.desc} is Sacrificed.');
        logLine('>Advance of $armyName is halted.');
        _state.setPieceLocation(propUnit, Location.trayUnits);
        clearChoices();
        _barbariansAdvanceState = null;
        return;
      }
      final propUnit = checkChoice(Choice.blockMagyarProp) ? Piece.armyMagyar : Piece.armySkanderbeg;
      logLine('>The Empire supports ${propUnit.desc}.');
      spendSolidus(1);
      int die = rollD6();

      logTableHeader();
      logD6InTable(die);
      final armyValue = _state.armyValue(propUnit);
      logLine('>|$armyName|$armyValue|');
      logTableFooter();

      if (die <= armyValue) {
        logLine('>${propUnit.desc} repulses the Ottoman advance.');
        _barbariansAdvanceState = null;
        return;
      }
      logLine('>Ottomans defeat ${propUnit.desc}.');
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
        logLine('>Tribute');
        int die = rollD6();
        logD6(die);
        if (die < 6) {
          logLine('>Advance of $armyName is halted.');
          _barbariansAdvanceState = null;
          return;
        }
        logLine('>Tribute is ineffective.');
        logLine('>$armyName continues its Advance');
        _state.setPieceLocation(Piece.tribute, Location.trayMilitary);
      } else if (piece == Piece.kastron) {
        logLine('>Kastron');
        localState.kastronUsed = true;
        int die = rollD6();
        logD6(die);
        if (die <= 4) {
          logLine('>Advance of $armyName is halted.');
          _barbariansAdvanceState = null;
          return;
        }
        if (die == 5) {
          logLine('>Kastron is destroyed.');
          _state.setPieceLocation(Piece.kastron, Location.trayMilitary);
        }
        logLine('>$armyName continues its Advance.');
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
        logLine('>Byzantines are forced to abandon Africa.');
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
        logLine('>Normans wrest control of Italy from the Byzantines.');
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

      logLine('>${tribe.desc} lays Siege to Constantinople.');
      final rolls = roll2D6();
      int modifiers = 0;

      logTableHeader();
      log2D6InTable(rolls);
      if (_state.pieceLocation(Piece.factionTheodosianWalls) != Location.constantinople) {
        logLine('>|Unfortified|+3|');
        modifiers += 3;
      }
      final total = rolls.$3 + modifiers;
      logLine('>|Total|$total|');
      final factionCount = _state.piecesInLocationCount(PieceType.faction, Location.constantinople);
      logLine('>|Factions|$factionCount|');
      logTableFooter();

      if (total > factionCount) {
        logLine('# Constantinople falls!');
        throw GameOverException(GameResult.defeatConstantinople, 0);
      }
      logLine('>Defeat fizzles.');
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
          logLine('>Mountains');
          localState.subStep = 2;
        }
        if (localState.subStep == 2) {
          int die = rollD6ForEasternPath(path);

          logTableHeader();
          logD6InTable(die);
          logLine('>|$armyName|$armyStrength|');
          logTableFooter();

          if (die > armyStrength) {
            logLine('>Advance of $armyName is halted by Mountains.');
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

          logTableHeader();
          logD6InTable(die);
          logLine('>|$armyName|$armyStrength|');
          logTableFooter();

          _state.setPieceLocation(_state.pieceFlipSide(hospital)!, toLand);
          if (die > armyStrength) {
            logLine('>Advance of $armyName is halted by Hospital.');
            _barbariansAdvanceState = null;
            return;
          }
          logLine('>$armyName continues its Advance.');
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
          logLine('>Tribute');
          localState.subStep = 6;
        } else if (piece == Piece.kastron) {
          logLine('>Kastron');
          localState.subStep = 7;
        } else {
          localState.subStep = 8;
        }
      }

      if (localState.subStep == 6) { // Tribute roll
        int die = rollD6ForEasternPath(path);
        logD6(die);
        logLine('>|$armyName|$armyStrength|');
        if (die < 6) {
          logLine('>Advance of $armyName is halted.');
          _barbariansAdvanceState = null;
          return;
        }
        logLine('>Tribute is ineffective.');
        logLine('>$armyName continues its Advance');
        _state.setPieceLocation(Piece.tribute, Location.trayMilitary);
        localState.subStep = 5;
      }

      if (localState.subStep == 7) { // Kastron roll
        localState.kastronUsed = true;
        int die = rollD6ForEasternPath(path);
        logD6(die);
        if (die <= 4) {
          logLine('>Advance of $armyName is halted.');
          _barbariansAdvanceState = null;
          return;
        }
        if (die == 5) {
          logLine('>Kastron is destroyed.');
          _state.setPieceLocation(Piece.kastron, Location.trayMilitary);
        }
        logLine('>$armyName continues its Advance.');
        localState.subStep = 5;
      }
    }

    if (localState.subStep == 8) { // Advance
      if (toLand != Location.constantinople) {
        logLine('>$armyName captures ${_state.landName(toLand)}.');
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
      logLine('>$armyName lays Siege to Constantinople.');
      final rolls = roll2D6();
      int modifiers = 0;

      logTableHeader();
      log2D6InTable(rolls);
      if (_state.pieceLocation(Piece.factionTheodosianWalls) != Location.constantinople) {
        logLine('>|Unfortified|+3|');
        modifiers += 3;
      }
      final total = rolls.$3 + modifiers;
      logLine('>|Total|$total|');
      final factionCount = _state.piecesInLocationCount(PieceType.faction, Location.constantinople);
      logLine('>|Factions|$factionCount');
      logTableFooter();

      if (total > factionCount) {
        logLine('# Constantinople falls!.');
        throw GameOverException(GameResult.defeatConstantinople, 0);
      }
      logLine('>Defeat fizzles.');
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
    logLine('>${_state.armyName(army)} Retreats to ${_state.landName(toLand)}.');
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
    logLine('>The first Caliphate is established.');
    _state.setPieceLocation(Piece.caliph, Location.arabiaBox);
    if (_state.pieceLocation(Piece.colonistsPersia) != Location.flipped) {
      logLine('>${_state.armyName(Piece.armyIberiaSaracen)} seizes control of ${_state.landName(Location.homelandIberia)}.');
      _state.pathSetArmy(Path.iberia, Piece.armyIberiaSaracen);
      logLine('>${_state.armyName(Piece.armyPersiaSaracen)} seizes control of ${_state.landName(Location.homelandPersia)}.');
      _state.pathSetArmy(Path.persia, Piece.armyPersiaSaracen);
    }
    if (_state.pieceLocation(Piece.colonistsSyria) != Location.flipped) {
      logLine('>${_state.armyName(Piece.armySyriaSaracen)} seizes control of ${_state.landName(Location.homelandSyria)}.');
      _state.pathSetArmy(Path.syria, Piece.armySyriaSaracen);
    } else if (_state.pathBarbarianPiece(Path.syria) == Piece.armySyriaPersia) {
      logLine('>${_state.armyName(Piece.armySyriaNomads)} seizes control of ${_state.landName(Location.homelandSyria)}.');
      _state.pathSetArmy(Path.syria, Piece.armySyriaNomads);
    }
  }

  void crusadesBegin() {
    logLine('### Crusades Begin');
    logLine('>First Crusade takes control of the Holy Land.');
    _state.setPieceLocation(Piece.outpostHolyLand, Location.outpostHolyLandBox);
  }

  // Migration Events

  void migrationEventIslam() {
    if (!_options.islamEvent) {
      return;
    }
    if (_state.limitedEventCount(LimitedEvent.warInTheEast) == 2) {
      riseOfIslam();
      _state.limitedEventOccurred(LimitedEvent.warInTheEast);
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
    logLine('>Battle for Carthage');
    int die = rollD6();
    int drm = 0;

    logTableHeader();
    logD6InTable(die);
    int modifier = _state.pathBarbarianControlledLandCount(Path.syria);
    logLine('>|Muslim lands on Syrian Path|+$modifier|');
    drm += modifier;
    if (_state.pieceLocation(Piece.egyptMuslim) == Location.egyptianReligionBox) {
      logLine('>|Egypt Muslim|+2|');
      drm += 2;
    }
    int modifiedDie = dieWithDrm(die, drm);
    logLine('>|Modified|$modifiedDie|');
    logTableFooter();

    if (modifiedDie >= 6) {
      logLine('>Saracens conquer North Africa.');
      _state.pathSetTribe(Path.south, Piece.tribeSouthSaracen);
      if (_state.pieceLocation(Piece.outpostSpain) == Location.outpostSpainBox) {
        logLine('>Outpost in Spain is conquered.');
        _state.setPieceLocation(Piece.outpostSpain, Location.discarded);
      }
    } else {
      logLine('>North Africa holds out.');
    }
  }

  void migrationEventEgypt() {
    if (_state.piecesInLocationCount(PieceType.pagan, Location.homelandSyria) == 0) {
      return;
    }
    logLine('### Migration');
    logLine('>Christian empire is established in Egypt.');
    _state.pathSetTribe(Path.south, Piece.tribeSouthEgypt);
    _state.pathSetArmy(Path.syria, Piece.armySyriaEgypt);
    if (_state.pieceLocation(Piece.outpostEgypt) == Location.outpostEgyptBox) {
      logLine('>Outpost in Egypt is conquered.');
      _state.setPieceLocation(Piece.outpostEgypt, Location.discarded);
    }
  }

  void migrationEventBuyids() {
    if (_state.pathBarbarianPiece(Path.persia) == Piece.armyPersiaSaracen) {
      logLine('### Migration');
      logLine('>Buyid Dynasty succeeds the Saracens on the Persian Path.');
      _state.pathSetArmy(Path.persia, Piece.armyPersiaBuyid);
    }
  }

  void migrationEventNormans() {
    if (_state.pieceLocation(Piece.geographyItaly) != Location.zoneWest) {
      return;
    }
    logLine('### Migration');
    logLine('>Normans expand into Italy.');
    int die = rollD6();

    logTableHeader();
    logD6InTable(die);
    int armyCount = _state.piecesInLocationCount(PieceType.armyWest, Location.zoneWest);
    logLine('>|Western Armies|$armyCount|');
    logTableFooter();

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
      logLine('>The Empire resists their advances.');
    }
  }

  void migrationEventMongols() {
    logLine('### Migration');
    logLine('>Mongol Horders invade the Middle East and Europe.');
    _state.pathSetArmy(Path.persia, Piece.armyPersiaMongol);
    _state.pathSetArmy(Path.syria, Piece.armySyriaMongol);
    final kiev = _state.pieceInLocation(PieceType.kiev, Location.kyivBox);
    if (kiev != null) {
      logLine('>Kiev is conquered.');
      _state.setPieceLocation(kiev, Location.discarded);
    }
  }

  // Optional Events

  void optionalEventA() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.pieceLocation(Piece.factionTheodosianWalls) != Location.constantinople) {
      return;
    }
    logLine('### Earthquakes strike Constantinople');
    logLine('>Theodosian Walls require repairs.');
    int die = rollD6();
    logD6(die);
    _state.setPieceLocation(Piece.factionTheodosianWalls, _state.omnibusBox(die));
  }
  
  void optionalEventB() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.limitedEventCount(LimitedEvent.justaGrataHonoria) > 0) {
      return;
    }
    if (_state.pathBarbarianPiece(Path.north) != Piece.tribeNorthHun) {
      return;
    }
    logLine('### Justa Grata Honoria');
    logLine('>Basileus’ cousin proposes marriage to Attila the Hun');
    int die = rollD6();
    logD6(die);
    int armyCount = _state.piecesInLocationCount(PieceType.armyNorthWeak, Location.zoneNorth);
    int removeCount = min(die, armyCount - 1);
    for (int i = 0; i < removeCount; ++i) {
      final army = _state.weakestArmyInLocation(PieceType.armyNorthWeak, Location.zoneNorth)!;
      armyLeavesZone(army, Location.zoneNorth);
    }
  }

  void optionalEventC() {
    if (!_options.circledEvents) {
      return;
    }
    logLine('### Fiscal Reforms');
    int die = rollD6();
    logD6(die);
    adjustSolidus(die);
  }

  void optionalEventD() {
    if (!_options.circledEvents) {
      return;
    }
    logLine('### Porphyrios the Whale');
    logLine('>Reports of sea monsters terrorize fleets.');
    _state.stolosArmy = null;
    _state.setCurrentEventOccurred(CurrentEvent.porphyriosTheWhale, true);
  }

  void optionalEventE() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.pieceLocation(Piece.outpostHolyLand) != Location.outpostHolyLandBox) {
      return;
    }
    logLine('### Pirates from Pisa');
    logLine('>Pisan pirates loot the Holy Land');
    adjustSolidus(-2);
  }

  void optionalEventF() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.currentTurn + 1 < 5 || _state.currentTurn + 1 > 14) {
      return;
    }
    logLine('### Khazar Allies');
  }

  void optionalEventFIberia() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.currentTurn + 1 < 5 || _state.currentTurn + 1 > 14) {
      return;
    }
    freeAttackOnPath(Path.iberia);
  }

  void optionalEventFPersia() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.currentTurn + 1 < 5 || _state.currentTurn + 1 > 14) {
      return;
    }
    freeAttackOnPath(Path.persia);
  }

  void optionalEventFSyria() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.currentTurn + 1 < 5 || _state.currentTurn + 1 > 14) {
      return;
    }
    freeAttackOnPath(Path.syria);
  }

  void optionalEventG() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.currentTurn + 1 < 10 || _state.currentTurn + 1 > 13) {
      return;
    }
    if (_state.pieceLocation(Piece.university) != Location.constantinople) {
      return;
    }
    logLine('### Dark Ages');
    logLine('>Formal learning collapses.');
    _state.setPieceLocation(Piece.university, Location.trayPatriarchs);
  }

  void optionalEventH() {
    if (!_options.circledEvents) {
      return;
    }
    final location = _state.pieceLocation(Piece.university);
    if (location == Location.flipped) {
      return;
    }
    if (location != Location.constantinople && _state.solidus < 3) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Christian Refugees');
      logLine('>Christian refugees from the East help revive Byzantine scholarship.');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (location == Location.constantinople) {
        int die = rollD6();
        logD6(die);
        adjustSolidus(die);
        return;
      }
      if (choicesEmpty()) {
        setPrompt('Build Pandidakterion?');
        choiceChoosable(Choice.yes, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        logLine('>University is established.');
        spendSolidus(3);
        _state.setPieceLocation(Piece.university, Location.constantinople);
      }
      clearChoices();
    }
  }

  void optionalEventI() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.pieceLocation(Piece.kievPagan) != Location.kyivBox) {
      return;
    }
    logLine('### Cyril & Methodius');
    int die = rollD6();
    logD6(die);
    if (die == 6) {
      logLine('>Kyiv converts to Orthodoxy.');
      _state.setPieceLocation(Piece.kievOrthodox, Location.kyivBox);
    } else {
      logLine('>Kyiv remains pagan.');
    }
  }

  void optionalEventJ() {
    if (!_options.circledEvents) {
      return;
    }
  }

  void optionalEventK() {
    if (!_options.circledEvents) {
      return;
    }
    if (!_state.popeMean) {
      return;
    }
    logLine('### Dynasty Overthrown!');
    logLine('>The Pope backs a usurper.');
    Piece? oldDynasty = _state.pieceInLocation(PieceType.dynasty, Location.dynastyBox)!;
    if (!_state.dynastyIsAnarchy(oldDynasty)) {
      logLine('> ${oldDynasty.desc} is overthrown.');
    }
    _state.setPieceLocation(oldDynasty, Location.discarded);
    final newDynasty = drawDynasty();
    if (_state.dynastyIsAnarchy(newDynasty)) {
      logLine('>Byzantine Empire descends into Anarchy.');
    } else {
      logLine('>${newDynasty.desc} seizes power.');
    }
    _state.setPieceLocation(newDynasty, Location.dynastyBox);
  }

  void optionalEventL() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.currentTurn + 1 < 15 || _state.currentTurn + 1 > 19) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Trading Rights');
      logLine('>Venice wins concessions.');
      adjustSolidus(-3);
      _subStep = 1;
    }
    if (_state.piecesInLocationCount(PieceType.unusedHospital, Location.trayGeography) == 0 || buildHospitalCandidateLocations.isEmpty) {
      return;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select Zone or Theme to Build Hospital in');
        for (final candidate in buildHospitalCandidateLocations) {
          locationChoosable(candidate);
        }
        throw PlayerChoiceException();
      }
      final land = selectedLocation()!;
      logLine('>Hospital is built in ${_state.landName(land)}.');
      final hospitals = _state.piecesInLocation(PieceType.unusedHospital, Location.trayGeography);
      _state.setPieceLocation(hospitals[0], land);
      clearChoices();
    }
  }

  void optionalEventM() {
    if (!_options.circledEvents) {
      return;
    }
    bool iberia = _state.pathBarbarianPiece(Path.iberia) == Piece.armyIberiaSeljuk;
    bool persia = _state.pathBarbarianPiece(Path.persia) == Piece.armyPersiaSeljuk;
    bool syria = _state.pathBarbarianPiece(Path.syria) == Piece.armySyriaSeljuk;
    if (iberia && _state.pieceLocation(Piece.armyIberiaSeljuk).index >= Location.themeGreaterArmenia.index) {
      iberia = false;
    }
    if (persia && _state.pieceLocation(Piece.armyPersiaSeljuk).index >= Location.themeMelitene.index) {
      final colonistsLocation = _state.pieceLocation(_state.pathColonists(Path.persia)!);
      if (!colonistsLocation.isType(LocationType.pathPersia) || colonistsLocation.index >= Location.themeMelitene.index) {
        persia = false;
      }
    }
    if (syria && _state.pieceLocation(Piece.armySyriaSeljuk).index >= Location.themeCilicia.index) {
      final colonistsLocation = _state.pieceLocation(_state.pathColonists(Path.syria)!);
      if (!colonistsLocation.isType(LocationType.pathSyria) || colonistsLocation.index >= Location.themeCilicia.index) {
        syria = false;
      }
    }
    if (!iberia && !persia && !syria) {
      return;
    }
    if (_state.solidus == 0) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Malik Shah');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Choose \$olidi to spend supporting Malik Shah against Seljuk rebels');
        for (int amount = 0; amount <= min(_state.solidus, 6); ++amount) {
          locationChoosable(_state.omnibusBox(amount));
        }
        throw PlayerChoiceException();
      }
      final box = selectedLocation()!;
      int amount = box.index - Location.omnibus0.index;
      if (amount == 0) {
        logLine('>Byzantium offers no support to Malik Shah.');
        return;
      }
      logLine('>Byzantium offers to support Malik Shah against Seljuk rebels.');
      spendSolidus(amount);
      int die = rollD6();
      logD6(die);
      if (die < amount) {
        logLine('>Seljuk rebels are driven back.');
        if (iberia) {
          logLine('>${Piece.armyIberiaSeljuk.desc} Retreats to ${Location.themeGreaterArmenia.desc}.');
          _state.setPieceLocation(Piece.armyIberiaSeljuk, Location.themeGreaterArmenia);
        }
        if (persia) {
          if (_state.pieceLocation(Piece.armyPersiaSeljuk).index < Location.themeMelitene.index) {
            logLine('>${Piece.armyPersiaSeljuk.desc} Retreats to ${Location.themeMelitene.desc}.');
            _state.setPieceLocation(Piece.armyPersiaSeljuk, Location.themeMelitene);
          }
          final colonists = _state.pathColonists(Path.persia)!;
          final colonistsLocation = _state.pieceLocation(colonists);
          if (colonistsLocation.isType(LocationType.pathPersia) && colonistsLocation.index < Location.themeMelitene.index) {
            logLine('>${colonists.desc} are pushed back to ${Location.themeMelitene.desc}.');
            _state.setPieceLocation(colonists, Location.themeMelitene);
          }
        }
        if (syria) {
          if (_state.pieceLocation(Piece.armySyriaSeljuk).index < Location.themeCilicia.index) {
            logLine('>${Piece.armySyriaSeljuk.desc} Retreats to ${Location.themeCilicia.desc}.');
            _state.setPieceLocation(Piece.armySyriaSeljuk, Location.themeCilicia);
          }
          final colonists = _state.pathColonists(Path.syria)!;
          final colonistsLocation = _state.pieceLocation(colonists);
          if (colonistsLocation.isType(LocationType.pathSyria) && colonistsLocation.index < Location.themeCilicia.index) {
            logLine('>${colonists.desc} are pushed back to ${Location.themeCilicia.desc}.');
            _state.setPieceLocation(colonists, Location.themeCilicia);
          }
        }
      } else {
        logLine('>Support is ineffective.');
      }
    }
  }

  void optionalEventN() {
    if (!_options.circledEvents) {
      return;
    }
    final latins = _state.piecesInLocation(PieceType.latins, Location.trayUnits);
    if (latins.isEmpty) {
      return;
    }
    logLine('### Catholic vs. Orthodox Riots');
    logLine('>Religious Riots break out in Constantinople.');
    _state.setPieceLocation(_state.pieceFlipSide(latins[0])!, Location.constantinople);
  }

  void optionalEventO() {
    if (!_options.circledEvents) {
      return;
    }
    bool persia = _state.pathBarbarianPiece(Path.persia) == Piece.armyPersiaMongol;
    bool syria = _state.pathBarbarianPiece(Path.syria) == Piece.armySyriaMongol;
    if (persia) {
      final colonistsLocation = _state.pieceLocation(_state.pathColonists(Path.persia)!);
      if (!colonistsLocation.isType(LocationType.pathPersia)) {
        persia = false;
      }
    }
    if (syria) {
      final colonistsLocation = _state.pieceLocation(_state.pathColonists(Path.syria)!);
      if (!colonistsLocation.isType(LocationType.pathSyria)) {
        syria = false;
      }
    }
    if (!persia && !syria) {
      return;
    }
    logLine('### Mongol–Crusader Alliance');
    if (persia) {
      final colonists = _state.pathColonists(Path.persia)!;
      logLine('>${colonists.desc} are eliminated from ${Path.persia.desc}.');
      _state.setPieceLocation(colonists, Location.discarded);
    }
    if (syria) {
      final colonists = _state.pathColonists(Path.syria)!;
      logLine('>${colonists.desc} are eliminated from ${Path.syria.desc}.');
      _state.setPieceLocation(colonists, Location.discarded);
    }
  }

  void optionalEventP() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.piecesInLocationCount(PieceType.latins, Location.constantinople) == 0) {
      return;
    }
    logLine('### War of the Sicilian Vespers');
    logLine('>Infighting among the Latin powers spills over into Constantinople.');
    _state.setCurrentEventOccurred(CurrentEvent.warOfTheSicilianVespers, true);
  }

  void optionalEventQ() {
    if (!_options.circledEvents) {
      return;
    }
  }

  void optionalEventR() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.currentTurn + 1 < 24 || _state.currentTurn + 1 > 27) {
      return;
    }
    for (final land in _state.mountainLands) {
      if (_state.landIsPlayerControlled(land)) {
        return;
      }
    }
    logLine('### Council of Florence');
    logLine('>Basileus recognizes the supremacy of the Pope.');
    int die = rollD6();
    logD6(die);
    adjustSolidus(die);
    for (final monastery in PieceType.monastery.pieces) {
      final location = _state.pieceLocation(monastery);
      if (location.isType(LocationType.land)) {
        logLine('>Monastery in ${location.desc} is dissolved.');
      }
    }
    for (final monastery in PieceType.connectedMonastery.pieces) {
      _state.setPieceLocation(monastery, Location.discarded);
    }
  }

  void optionalEventS() {
    if (!_options.circledEvents) {
      return;
    }
  }

  void optionalEventT() {
    if (!_options.circledEvents) {
      return;
    }
  }

  void optionalEventU() {
    if (!_options.circledEvents) {
      return;
    }
  }

  void optionalEvent1() {
    if (!_options.circledEvents) {
      return;
    }
  }

  void optionalEvent2() {
    if (!_options.circledEvents) {
      return;
    }
  }

  void optionalEvent3() {
    if (!_options.circledEvents) {
      return;
    }
  }

  void optionalEvent4() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.schism == 0) {
      return;
    }
    logLine('### Blachernae Church Miracles');
    logLine('>Frequent miracles inspire Orthodox devotion.');
    int die = rollD6();
    logD6(die);
    adjustSchism(-die);
  }

  void optionalEvent5() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.pieceLocation(Piece.university) != Location.constantinople) {
      return;
    }
    logLine('### Heresy Trials');
    logLine('>Politically motivated charges drive scholars into hiding.');
    int die = rollD6();
    logD6(die);
    _state.setPieceLocation(Piece.university, _state.futureChronographiaBox(die, false));
  }

  void optionalEvent6() {
    if (!_options.circledEvents) {
      return;
    }
    logLine('### Comet: Portent of Doom');
    logLine('>Reduces likelihood of success in next Attack.');
    _state.setCurrentEventOccurred(CurrentEvent.comet, true);
  }

  void optionalEvent7() {
    if (!_options.circledEvents) {
      return;
    }
    logLine('### Galata Tower');
    logLine('>Genoese rebuild Galata Tower.');
    adjustSolidus(1);
  }

  void optionalEvent8() {
    if (!_options.circledEvents) {
      return;
    }
    bool iberia = _state.pathBarbarianPiece(Path.iberia) == Piece.armyIberiaOttoman;
    bool persia = _state.pathBarbarianPiece(Path.persia) == Piece.armyPersiaOttoman;
    bool syria = _state.pathBarbarianPiece(Path.syria) == Piece.armySyriaOttoman;
    if (!iberia && !persia && !syria) {
      return;
    }
    logLine('### Tamerlane');
    int die = rollD6();
    int drm = 0;

    logTableHeader();
    logD6InTable(die);
    for (final land in _state.mountainLands) {
      if (_state.landIsPlayerControlled(land)) {
        logLine('>${land.desc}|+1|');
        drm += 1;
      }
    }
    int total = die + drm;
    logLine('>|Total|$total|');
    logTableFooter();

    if (die + drm >= 7) {
      logLine('>Tamerlane devastates the Ottomans.');
      if (iberia) {
        logLine('>Armenians reassert their independence.');
        _state.pathSetArmy(Path.iberia, Piece.armyIberiaArmenia);
      }
      if (persia) {
        logLine('>Iranian dynasty takes control of Persia.');
        _state.pathSetArmy(Path.persia, Piece.armyPersiaBuyid);
      }
      if (syria) {
        logLine('>Nomads seize control of Syria.');
        _state.pathSetArmy(Path.syria, Piece.armySyriaNomads);
      }
    } else {
      logLine('>Ottomans repulse Tamerlane.');
    }
  }

  void optionalEvent9() {
    if (!_options.circledEvents) {
      return;
    }
    if (_state.solidus < 2) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Better Cannons');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Invest in better cannons?');
        choiceChoosable(Choice.yes, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        logLine('>Byzantium invests in better cannons.');
        spendSolidus(2);
        int die = rollD6();
        logD6(die);
        if (die == 6) {
          logLine('>Byzantium develops better cannons.');

        } else {
          logLine('>Attempts to improve cannons are fruitless.');
        }
      } else {
        logLine('>Byzantium does not pursue cannon development.');
      }
    }

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
    if (_options.armeniansAndOttomans) {
      for (final path in _state.easternPaths) {
        if (_state.pathBarbarianIsMuslim(path)) {
          final locationType = _state.pathLocationType(path);
          for (int sequence = locationType.count - 2; sequence >= 0; --sequence) {
            final land = _state.pathSequenceLocation(path, sequence);
            if (!_state.landIsPlayerControlled(land)) {
              logLine('>${_state.landName(land)}');
              int die = rollD6();
              logD6(die);
              if (die == 6) {
                logLine('>Armenian Revolt is quashed.');
                return;
              }
            }
          }
        }
      }
      logLine('>Armenian Revolt is successful.');
    }
    logLine('>${_state.armyName(Piece.armyIberiaArmenia)} takes control of ${_state.landName(Location.homelandIberia)}.');
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

      logTableHeader();
      logD6InTable(die);
      if (_state.basileisAreSaint) {
        logLine('>|${_state.basileisSaintName}|-1|');
        drm = -1;
      }
      int modifiedDie = dieWithDrm(die, drm);
      logLine('>|Modified|$modifiedDie|');
      logTableFooter();

      spendSolidus(amount);
      if (modifiedDie < amount) {
        logLine('>Kyiv converts to Orthodoxy.');
        _state.setPieceLocation(Piece.kievOrthodox, Location.kyivBox);
      } else {
        logLine('>Conversion efforts fail.');
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
      logLine('>${Piece.tribeNorthBulgar.desc} takes control of ${_state.pathGeographicName(Path.north)}.');
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
      logD6(die);
      spendSolidus(amount);
      if (die <= amount) {
        logLine('>Bulgars convert to Orthodoxy.');
        _state.setPieceLocation(Piece.bulgarianChurchOrthodox, Location.bulgarianChurchBox);
      } else {
        logLine('>Bulgars convert to Catholicism.');
        _state.setPieceLocation(Piece.bulgarianChurchCatholic, Location.bulgarianChurchBox);
      }
    }
  }

  void politicalEventCarthage() {
    migrationEventCarthage();
  }

  void politicalEventCatholicCharity() {
    if (_state.limitedEventCount(LimitedEvent.eastWestSchism) > 0 && _state.schism > 0) {
      return;
    }
    if (!_state.popeNice) {
      return;
    }
    logLine('### Catholic Charity');
    int die = rollD6();
    logD6(die);
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
      logD6(die);
      spendSolidus(amount);
      if (die <= amount) {
        logLine('>Coptic Revolt succeeds.');
        _state.setPieceLocation(Piece.outpostEgypt, Location.outpostEgyptBox);
      } else {
        logLine('>Coptic Revolt fails.');
      }
    }
  }

  void politicalEventDavid() {
    if (_state.limitedEventCount(LimitedEvent.david) > 0) {
      return;
    }
    logLine('### David');
    logLine('>David the Builder unites the Georgian tribes and grabs Lazica.');
    _state.setPieceLocation(Piece.outpostLazica, Location.discarded);
    _state.limitedEventOccurred(LimitedEvent.david);
  }

  void politicalEventFallOfRome() {
    if (_state.limitedEventCount(LimitedEvent.fallOfRome) > 0) {
      return;
    }
    logLine('### Fall of Rome');
    logLine('>Rome, Spain, and Sicily are susceptible to Byzantine conquest.');
    _state.setPieceLocation(Piece.outpostRome, Location.availableOutpostsBox);
    _state.setPieceLocation(Piece.outpostSpain, Location.availableOutpostsBox);
    _state.setPieceLocation(Piece.outpostSicily, Location.availableOutpostsBox);
    _state.limitedEventOccurred(LimitedEvent.fallOfRome);
  }

  void politicalEventGokturks() {
    logLine('### Göktürks');
    logLine('>Turkish marauders strike from the northeast.');
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
        logLine('> - ${_state.landName(land)}');
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
    log2D6(rolls);
    if (rolls.$3 == 12) {
      logLine('>Feuding Church factions are reconciled.');
      _state.setPieceLocation(Piece.schism, Location.cupTurnChit);
    } else {
      logLine('>Church factions continue feuding.');
    }
  }

  void politicalEventKleidion() {
    if (_state.limitedEventCount(LimitedEvent.kleidion) > 0) {
      return;
    }
    logLine('### Kleidíon');
    logLine('>Possibility of establishing Bulgarian Theme.');
    _state.limitedEventPossible(LimitedEvent.kleidion);
  }

  void politicalEventKyiv() {
    final piece = _state.pieceInLocation(PieceType.kiev, Location.kyivBox);
    if (piece == null) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Kyiv');
      if (piece != Piece.kievPagan) {
        logLine('>Trade with the Kyivan Rus’ empire');
        adjustSolidus(1);
        return;
      }
      logLine('>Slavic pirates raid Byzantine territory.');
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
    logLine('>Lombards conquer the Goths');
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
    logLine('>Hungarian Crusaders wage war on the Ottomans.');
    _state.setPieceLocation(Piece.armyMagyar, Location.zoneWest);
  }

  void politicalEventOstrogoths() {
    if (_state.pathBarbarianPiece(Path.north) != Piece.tribeNorthHun) {
      return;
    }
    logLine('### Ostrogoths');
    logLine('>Ostrogoths take control of ${_state.pathGeographicName(Path.north)}.');
    _state.pathSetTribe(Path.north, Piece.tribeNorthOstrogoths);
  }

  void politicalEventOttomans() {
    if (_state.limitedEventCount(LimitedEvent.ottomans) > 0) {
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

    logTableHeader();
    logD6InTable(die);
    for (final land in _state.mountainLands) {
      if (_state.landIsPlayerControlled(land)) {
        logLine('>|${_state.landName(land)}|-1|');
        drm -= 1;
      }
    }
    for (final land in _state.greekLands) {
      final path = _state.landPath(land)!;
      final locationType = _state.pathLocationType(path)      ;
      final playerControlCount = _state.pathPlayerControlledLandCount(path);
      if (land.index - locationType.firstIndex >= playerControlCount) {
        logLine('>|${_state.landName(land)}|+1|');
        drm += 1;
      }
    }
    for (final path in _state.westernPaths) {
      final zone = _state.pathZone(path);
      final armyType = _state.pathArmyType(path);
      final count = _state.piecesInLocationCount(armyType, zone);
      if (count <= 1) {
        logLine('>|${_state.pathGeographicName(path)}|-1|');
        drm -= 1;
      } else if (count >= 3) {
        logLine('>|${_state.pathGeographicName(path)}|+1|');
        drm += 1;
      }
    }
    final modifiedDie = dieWithDrm(die, drm);
    logLine('>|Modified|$modifiedDie|');
    logTableFooter();

    if (modifiedDie <= 0) {
      logLine('>Ottoman attempt at Empire fails.');
    } else {
      logLine('>Ottoman Empire is established.');
    }
    if (modifiedDie >= 1) {
      logLine('>Ottoman Empire seizes control of ${Path.iberia}.');
      _state.pathSetArmy(Path.iberia, Piece.armyIberiaOttoman);
    }
    if (modifiedDie >= 2) {
      logLine('>Ottoman Empire seizes control of ${Path.persia}.');
      _state.pathSetArmy(Path.persia, Piece.armyPersiaOttoman);
    }
    if (modifiedDie == 3 || modifiedDie >= 5) {
      if (_state.pieceLocation(Piece.geographyBalkans) == Location.zoneWest) {
        logLine('>Ottoman Empire seizes control the Balkans.');
        _state.pathSetTribe(Path.west, Piece.tribeWestOttoman);
      }
    }
    if (modifiedDie >= 4) {
      logLine('>Ottoman Empire seizes control of ${Path.north}.');
      _state.pathSetTribe(Path.north, Piece.tribeNorthOttoman);
      logLine('>Ottoman Empire seizes control of ${Path.syria}.');
      _state.pathSetArmy(Path.syria, Piece.armySyriaOttoman);
    }
    _state.limitedEventOccurred(LimitedEvent.ottomans);
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
    logLine('>Pagan Turks invade from the North.');
    final church = _state.pieceInLocation(PieceType.bulgarianChurch, Location.bulgarianChurchBox);
    if (church != null) {
      logLine('>Bulgarian Church is suppressed.');
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
    logLine('>Basileus deals with the effects of the Plague.');
    _state.setPieceLocation(Piece.plague, Location.constantinople);
  }

  void politicalEventPornocracy() {
    if (!_state.popeNice) {
      return;
    }
    logLine('### Pornocracy');
    logLine('>Pope is Mean.');
    _state.setPieceLocation(Piece.popeMean, Location.popeBox);
  }

  void politicalEventRavenna() {
    if (_state.limitedEventCount(LimitedEvent.ravenna) > 0) {
      return;
    }
    logLine('### Ravenna');
    logLine('>Ravenna is made the capital of Byzantine Italy.');
    _state.setPieceLocation(Piece.ravenna, Location.zoneWest);
    _state.limitedEventOccurred(LimitedEvent.ravenna);
  }
  
  void politicalEventRiots() {
    final latins = _state.piecesInLocation(PieceType.latins, Location.trayUnits);
    if (latins.isEmpty) {
      return;
    }
    logLine('### Riots');
    logLine('>Riots break out in Constantinople.');
    _state.setPieceLocation(_state.pieceFlipSide(latins[0])!, Location.constantinople);
  }

  void politicalEventRotrude() {
    if (_state.limitedEventCount(LimitedEvent.rotrude) > 0) {
      return;
    }
    if (_state.limitedEventCount(LimitedEvent.eastWestSchism) > 0) {
      return;
    }
    final phaseState = _phaseState as PhaseStateSynopsisOfHistories;
    if (_subStep == 0) {
      logLine('### Rotrude');
      int die = rollD6();
      logD6(die);
      if (die != 6) {
        logLine('>Marriage negotiations unsuccessful.');
        _state.limitedEventOccurred(LimitedEvent.rotrude);
        return;
      }
      logLine('>Basileus marries a Catholic Frankish princess.');
      die = rollD6();
      logD6(die);
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
      logLine('> - ${outpost.desc}');
    }
    adjustSolidus(outposts.length);
  }

  void politicalEventSeljuks() {
    if (_state.pathBarbarianPiece(Path.persia) != Piece.armyPersiaBuyid) {
      return;
    }
    logLine('### Seljuks');
    if (_state.barbarianIsMuslim(_state.pathBarbarianPiece(Path.iberia))) {
      logLine('>Seljuks seize control of ${Path.iberia.desc}.');
      _state.pathSetArmy(Path.iberia, Piece.armyIberiaSeljuk);
    }
    logLine('>Seljuks seize control of ${Path.persia.desc}.');
    _state.pathSetArmy(Path.persia, Piece.armyPersiaSeljuk);
    if (_state.barbarianIsMuslim(_state.pathBarbarianPiece(Path.syria))) {
      logLine('>Seljuks seize control of ${Path.syria.desc}.');
      _state.pathSetArmy(Path.syria, Piece.armySyriaSeljuk);
      final syrianColonistsLocation = _state.pieceLocation(Piece.colonistsSyria);
      if (syrianColonistsLocation.isType(LocationType.land)) {
        final armyLand = _state.pieceLocation(Piece.armySyriaSeljuk);
        if (syrianColonistsLocation.index > armyLand.index) {
          logLine('>Muslim Turks settle in ${_state.landName(armyLand)}.');
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
          logLine('>Muslim Turks settle in ${_state.landName(armyLand)}.');
          _state.setPieceLocation(Piece.colonistsPersia, armyLand);
        }
      }
    }
    if (_state.pathBarbarianPiece(Path.syria) == Piece.armySyriaSeljuk) {
      final syrianColonistsLocation = _state.pieceLocation(Piece.colonistsSyria);
      if (syrianColonistsLocation.isType(LocationType.land)) {
        final armyLand = _state.pieceLocation(Piece.armySyriaSeljuk);
        if (syrianColonistsLocation.index > armyLand.index) {
          logLine('>Muslim Turks settle in ${_state.landName(armyLand)}.');
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
    logLine('>Serbs invade the Balkans.');
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
    logLine('>Sicily falls to the Barbarians.');
    _state.setPieceLocation(Piece.outpostSicily, Location.discarded);
  }

  void politicalEventSilkwormHeist() {
    if (_state.limitedEventCount(LimitedEvent.silkwormHeist) != 0) {
      return;
    }
    logLine('### Silkworm Heist');
    int die = rollD6();
    logD6(die);
    adjustSolidus(die);
    _state.limitedEventOccurred(LimitedEvent.silkwormHeist);
  }

  void politicalEventSkanderbeg() {
    if (_state.limitedEventCount(LimitedEvent.skanderbeg) != 0) {
      return;
    }
    if (_state.pathBarbarianPiece(Path.west) != Piece.tribeWestOttoman) {
      return;
    }
    logLine('### Skanderbeg');
    logLine('>Albanians revolt and ambush the Ottomans.');
    _state.setPieceLocation(Piece.armySkanderbeg, Location.zoneWest);
    _state.limitedEventOccurred(LimitedEvent.skanderbeg);
  }

  void politicalEventSlavs() {
    final piece = _state.pathBarbarianPiece(Path.north);
    if (![Piece.tribeNorthHun, Piece.tribeNorthOstrogoths].contains(piece)) {
      return;
    }
    logLine('### Slavs');
    logLine('>Slavic tribes begin to settle in the Balkans.');
    _state.pathSetTribe(Path.north, Piece.tribeNorthSlav);
  }

  void politicalEventStolos() {
    if (_subStep == 0) {
      if (_state.pieceLocation(Piece.stolos) != Location.stolosLurkingBox) {
        return;
      }
      if (_state.currentEventCurrent(CurrentEvent.porphyriosTheWhale)) {
        return;
      }
      logLine('### Stolos');
      final path = randPath(Path.values)!;
      logLine('>Stolos appears in ${_state.pathGeographicName(path)}.');
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
    logLine('>Possibility of defeating the Vandals.');
    _state.limitedEventPossible(LimitedEvent.tricameron);
  }

  void politicalEventUprisingOfAsenAndPeter() {
    if (_state.pathBarbarianPiece(Path.north) == Piece.tribeNorthBulgarians) {
      return;
    }
    logLine('### Uprising of Asen & Peter');
    logLine('>Christian Empire of Bulgaria reasserts its independence.');
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
        logLine('>Venice takes control of Crete.');
        _state.pathSetTribe(Path.south, Piece.tribeSouthVenice);
        return;
      }
      int die = rollD6();

      logTableHeader();
      logD6InTable(die);
      int armyCount = _state.piecesInLocationCount(PieceType.armySouth, Location.zoneSouth);
      logLine('>|Southern armies|$armyCount|');
      logTableFooter();

      if (die > armyCount) {
        logLine('>Venice takes control of Africa.');
        _state.pathSetTribe(Path.south, Piece.tribeSouthVenice);
      } else {
        logLine('>Venetian attempt to control of Africa is repulsed.');
      }
    }
  }

  void politicalEventWhiteHuns() {
    logLine('### White Huns');
    logLine('>White Huns invade your enemies from the northeast.');
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
      setPrompt('Proceed to Chit Draw Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Chit Draw Phase');
  }

  void chitDrawPhaseChitDraw() {
    if (_subStep == 0) {
      logLine('### Chit Draw');
      _subStep = 1;
    }
    if (_subStep == 1) {
      bool call = false;
      bool delay = false;
      if (_options.controlEcumenicalCouncils) {
        if (choicesEmpty()) {
          setPrompt('Call Ecumenical Council?');
          bool callable = false;
          for (final turnChit in _state.piecesInLocation(PieceType.turnChit, Location.cupTurnChit)) {
            if (_state.turnChitHasEcumenicalCouncil(turnChit)) {
              callable = true;
              break;
            }
          }
          choiceChoosable(Choice.yes, callable);
          choiceChoosable(Choice.no, true);
          throw PlayerChoiceException();
        }
        if (checkChoice(Choice.yes)) {
          call = true;
        } else {
          delay = true;
        }
        clearChoices();
      }
      Piece? turnChit;
      final drawnChits = <Piece>[];
      while (turnChit == null) {
        final drawnChit = randPiece(_state.piecesInLocation(PieceType.all, Location.cupTurnChit))!;
        if (drawnChit == Piece.schism) {
          logLine('>Religious factions reappear.');
          _state.setPieceLocation(Piece.schism, Location.omnibus0);
        } else {
          if (call) {
            if (_state.turnChitHasEcumenicalCouncil(drawnChit)) {
              turnChit = drawnChit;
            } else {
              _state.setPieceLocation(drawnChit, _state.currentTurnChronographiaBox);   // Temporarily
              drawnChits.add(drawnChit);
            }
          } else if (delay) {
            if (_state.turnChitHasEcumenicalCouncil(drawnChit)) {
              delay = false;
            } else {
              turnChit = drawnChit;
            }
          } else {
            turnChit = drawnChit;
          }
        }
      }
      for (final chit in drawnChits) {
        _state.setPieceLocation(chit, Location.cupTurnChit);
      }
      logLine('>Turn Chit ${turnChit.index - PieceType.turnChit.firstIndex + 1}');
      _state.setPieceLocation(turnChit, _state.currentTurnChronographiaBox);
    }
  }

  void turnStartPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Turn Start Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
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
        logLine('>${piece.desc} succeeds as Basileus.');
        removeOldBasileus();
        _state.setPieceLocation(Piece.basileusJustinian, Location.basileusBox);
      }
      if (piece == Piece.dynastyPurpleJustinian) {
        logLine('>${piece.desc} is founded.');
        final oldDynasty = _state.pieceInLocation(PieceType.dynastyPurple, Location.dynastyBox)!;
        _state.setPieceLocation(_state.pieceFlipSide(oldDynasty)!, Location.trayDynasties);
        _state.setPieceLocation(piece, Location.dynastyBox);
      }
      if (piece == Piece.basileus) {
        logLine('>Basileus is available for missions.');
        _state.setPieceLocation(piece, Location.constantinople);
      }
      if (piece == Piece.stolos) {
        _state.setPieceLocation(piece, Location.stolosLurkingBox);
      }
      if (piece == Piece.university) {
        logLine('>University reopens.');
        _state.setPieceLocation(piece, Location.constantinople);
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
    logD6(die);
    adjustSchism(die);
    die = rollD6();
    logD6(die);
    adjustSchism(-die);
  }

  void turnStartPhaseMagisterMilitum() {
    final magisterMilitumName = _state.turnMagisterMilitumName(_state.currentTurn);
    if (magisterMilitumName == null) {
      return;
    }
    logLine('### Magister Militum');
    logLine('>$magisterMilitumName takes command of the armed forces.');
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
    if (_state.limitedEventCount(LimitedEvent.warInTheEast) != 3) {
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
    if (_state.limitedEventCount(LimitedEvent.warInTheEast) != 3) {
      return;
    }
    _state.limitedEventOccurred(LimitedEvent.warInTheEast);
  }

  void turnStartPhaseEcumenicalCouncilEvent() {
    if (!_state.turnChitHasEcumenicalCouncil(_state.currentTurnChit!)) {
      return;
    }
    logLine('### Ecumenical Council');
    int die = rollD6();
    int drm = 0;

    logTableHeader();
    logD6InTable(die);
    if (_state.popeMean) {
      logLine('>|Mean Pope|+1|');
      drm += 1;
    }
    int modifiedDie = dieWithDrm(die, drm);
    logLine('>|Modified|$modifiedDie|');
    logTableFooter();

    adjustSchism(modifiedDie);
  }

  void turnStartPhaseEastWestSchismEvent() {
    if (_state.currentTurnChit != Piece.turnChit16) {
      return;
    }
    logLine('### East‐West Schism');
    logLine('>Catholic and Orthodox Churches split permanently.');
    _state.limitedEventOccurred(LimitedEvent.eastWestSchism);
    if (!_options.italyImportant || _state.pieceLocation(Piece.geographyBalkans) == Location.zoneWest) {
      logLine('>Popes focus on Western Europe.');
      _state.setPieceLocation(Piece.popeNice, Location.discarded);
    }
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
        logLine('>Reforms enacted.');
        spendSolidus(1);
        int die = rollD6();
        logD6(die);
        adjustReforms(die);
      } else {
        logLine('>Reforms not enacted.');
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
    if (!_options.redRandomBarbarians) {
      return;
    }
    turnStartBarbariansAdvanceOnRandomPath();
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

  void turnStartPhaseOptionalEvent(int index) {
    final optionalEventHandlers = {
      Piece.turnChit1: [optionalEventA],
      Piece.turnChit3: [optionalEventC],
      Piece.turnChit6: [optionalEventD],
      Piece.turnChit7: [optionalEventE],
      Piece.turnChit8: [optionalEventF, optionalEventFIberia, optionalEventFPersia, optionalEventFSyria],
      Piece.turnChit9: [optionalEventG],
      Piece.turnChit10: [optionalEventH],
      Piece.turnChit11: [optionalEventI],
      Piece.turnChit13: [optionalEventK],
      Piece.turnChit14: [optionalEventL],
      Piece.turnChit18: [optionalEventM],
      Piece.turnChit20: [optionalEventN],
      Piece.turnChit22: [optionalEventP],
      Piece.turnChit26: [optionalEventQ],
    };
    final handlers = optionalEventHandlers[_state.currentTurnChit];
    if (handlers == null) {
      return;
    }
    if (index >= handlers.length) {
      return;
    }
    handlers[index]();
  }

  void turnStartPhaseOptionalEvent0() {
    turnStartPhaseOptionalEvent(0);
  }

  void turnStartPhaseOptionalEvent1() {
    turnStartPhaseOptionalEvent(1);
  }

  void turnStartPhaseOptionalEvent2() {
    turnStartPhaseOptionalEvent(2);
  }

  void turnStartPhaseOptionalEvent3() {
    turnStartPhaseOptionalEvent(3);
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
    logLine('### ${newLocation.desc}');
    int die = rollD6();
    logD6(die);
    if (die >= 5 && _state.pieceLocation(Piece.outpostEgypt) != Location.outpostEgyptBox) {
      logLine('>Landing in Egypt!');
      logLine('>Crusade takes control of Egypt.');
      _state.setPieceLocation(Piece.outpostEgypt, Location.outpostEgyptBox);
      return;
    }
    if (die >= 3 && die < 6 && _state.limitedEventCount(LimitedEvent.constantinopleBetrayed) == 0) {
      logLine('>Constantinople Betrayed!');
      if (_state.schism > 0 || _state.piecesInLocationCount(PieceType.riots, Location.constantinople) > 0) {
        int latinsCount = min(_state.schism, 6);
        if (latinsCount > 0) {
          logLine('>$latinsCount Latins occupy ${_state.landName(Location.constantinople)}.');
          final availableLatins = _state.piecesInLocation(PieceType.latins, Location.trayUnits);
          for (int i = 0; i < latinsCount && i < availableLatins.length; ++i) {
            _state.setPieceLocation(availableLatins[i], Location.constantinople);
          }
        }
        final riots = _state.piecesInLocation(PieceType.riots, Location.constantinople);
        if (riots.isNotEmpty) {
          logLine('>${riots.length - latinsCount} Riots transform into Latins.');
        }
        for (final riot in riots) {
          _state.setPieceLocation(_state.pieceFlipSide(riot)!, Location.constantinople);
        }
        if (_state.pieceLocation(Piece.university) == Location.constantinople) {
          logLine('>${Piece.university.desc} closes.');
          _state.setPieceLocation(Piece.university, Location.trayPatriarchs);
        }
      } else {
        logLine('>Constantinople holds out against the treacherous Crusaders.');
      }
      _state.limitedEventOccurred(LimitedEvent.constantinopleBetrayed);
      return;
    }
    logLine('>Desultory warfare.');
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
      setPrompt('Proceed to Leadership Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Leadership Phase');
    _phaseState = PhaseStateLeadership();
  }

  void leadershipPhaseNewDynasty() {
    if (_state.currentTurn == _state.firstTurn) {
      return;
    }
    const civilWarTurnChits = [
      Piece.turnChit5,
      Piece.turnChit23,
      Piece.turnChit24,
    ];
    bool civilWar = civilWarTurnChits.contains(_state.currentTurnChit);
    if (_state.currentTurn == 2) {
      if (!civilWar || !_options.justinianCivilWar) {
        return;
      }
    }

    if (_subStep == 0) {
      logLine('### Dynasty');

      Piece? oldDynasty = _state.pieceInLocation(PieceType.dynasty, Location.dynastyBox)!;
      if (_state.currentTurn != 2) {
        if (_state.dynastyIsAnarchy(oldDynasty) || _state.piecesInLocationCount(PieceType.riots, Location.constantinople) > 0) {
          if (!_state.dynastyIsAnarchy(oldDynasty)) {
            logLine('>${oldDynasty.desc} is overthrown.');
          }
          _state.setPieceLocation(oldDynasty, Location.discarded);
          oldDynasty = null;
        }
      }

      if (!civilWar) {
        if (oldDynasty == null) {
          final newDynasty = drawDynasty();
          if (_state.dynastyIsAnarchy(newDynasty)) {
            logLine('>Byzantine Empire descends into Anarchy.');
          } else {
            logLine('>${newDynasty.desc} seizes power.');
          }
          _state.setPieceLocation(newDynasty, Location.dynastyBox);
        } else {
          int die = rollD6();
          int drm = 0;

          logTableHeader();
          logD6InTable(die);
          if (_state.nike >= 3) {
            logLine('>|Nike|+1|');
            drm += 1;
          }
          int modifiedDie = dieWithDrm(die, drm);
          logLine('>|Modified|$modifiedDie|');
          logTableFooter();

          if (modifiedDie >= _state.dynastyDie(oldDynasty)) {
            logLine('>${oldDynasty.desc} remains in power.');
          } else {
            logLine('>${oldDynasty.desc} is overthrown.');
            _state.setPieceLocation(oldDynasty, Location.discarded);
            final newDynasty = drawDynasty();
            if (_state.dynastyIsAnarchy(newDynasty)) {
              logLine('>Byzantine Empire descends into Anarchy.');
            } else {
              logLine('>${newDynasty.desc} seizes power.');
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
        logLine('>Civil War breaks out.');
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
          logLine('>Back ${supportedCandidate!.desc}');
          spendSolidus(solidi);
        }

        int die1 = rollD6();
        int drm1 = 0;

        logLine('>${candidate1.desc}');
        logTableHeader();
        logD6InTable(die1);
        if (_state.pieceLocation(candidate1) == Location.dynastyBox && _state.nike >= 3) {
          logLine('>|Nike|+1|');
          drm1 += 1;
        }
        if (supportedCandidate == candidate1) {
          logLine('>|Support|+$solidi|');
          drm1 += solidi;
        }
        int modifiedDie1 = dieWithDrm(die1, drm1);
        logLine('>|Modified|$modifiedDie1|');
        logTableFooter();

        int die0 = rollD6();
        int drm0 = 0;

        logLine('> ${candidate0.desc}');
        logTableHeader();
        logD6InTable(die0);
        if (supportedCandidate == candidate0) {
          logLine('>|Support|+$solidi|');
          drm0 += solidi;
        }
        int modifiedDie0 = dieWithDrm(die0, drm0);
        logLine('>|Modified|$modifiedDie0|');
        logTableFooter();
 
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
          logLine('>${candidate1.desc} ${tieBreakString}wins the Civil War.');
          _state.setPieceLocation(candidate0, Location.cupDynasty);
          if (!incumbent) {
            _state.setPieceLocation(candidate1, Location.dynastyBox);
          }
        } else {
          logLine('>${candidate0.desc} ${tieBreakString}wins the Civil War.');
          if (incumbent) {
            _state.setPieceLocation(candidate1, Location.discarded);
            if (_state.currentTurn == 2) {
              _state.setPieceLocation(Piece.basileusJustinian, Location.discarded);
            }
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
        logLine('>Riots are quelled.');
        for (final riot in riots) {
          _state.setPieceLocation(_state.pieceFlipSide(riot)!, Location.trayUnits);
        }
        removeRandomFaction(4);
      }
    }
  }

  void leadershipPhaseNewBasileus() {
    if (_state.currentTurn == _state.firstTurn) {
      return;
    }
    if (_state.currentTurn == 2 && _state.pieceLocation(Piece.basileusJustinian) == Location.basileusBox) {
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
        logLine('>${newBasileus.desc} becomes Basileus.');
        return;
      }
      logLine('>${newBasileus.desc} becomes Empress.');
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
        setPrompt('Spend 1 \$olidus for ${wife.desc} to marry ${alternateHusband.desc} rather than ${husband.desc}?');
        choiceChoosable(Choice.yes, _state.solidusAndNike >= 1);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        spendSolidus(1);
        logLine('>${wife.desc} schemes to block marriage to ${husband.desc}.');
        husband = _state.basileusPrimary(alternateHusband);
        _state.setPieceLocation(husband, Location.basileusHusbandBox);
      }
      logLine('>${husband.desc} marries ${wife.desc} and becomes Basileus.');
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
        setPrompt('Mutilate ${basileus.desc}?');
        choiceChoosable(Choice.yes, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.no)) {
        clearChoices();
        return;
      }
      logLine('>${basileus.desc} is mutilated.');
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
        setPrompt('Choose ${alternate.desc} as Basileus instead of ${basileus.desc}?');
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
      logLine('>${basileus.desc} becomes Basileus');

      if (!_state.basileusIsFemale(basileus)) {
        final location = _state.pieceLocation(Piece.basileus);
        if (location.isType(LocationType.chronographiaWithOverflow)) {
          logLine('>Basileus returns to Constantinople.');
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
    if (!_options.historicalPatriarchs) {
      final newPatriarch = randPiece(_state.piecesInLocation(PieceType.patriarch, Location.cupPatriarch))!;
      _state.setPieceLocation(newPatriarch, Location.patriarchBox);
    } else {
      final newPatriarch = historicPatriarchPiece;
      _state.setPieceLocation(newPatriarch, Location.patriarchBox);
    }
    logLine('>$currentPatriarchName becomes Patriarch.');
    if (currentPatriarchIncreasesSchism) {
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
    logD6(die);
    Piece? pope;
    if (die <= 4) {
      logLine('>New Pope is Nice.');
      pope = Piece.popeNice;
    } else {
      logLine('>New Pope is Mean.');
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
    logLine('>Tribute is paid to ${barbarian.desc}.');
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
      setPrompt('Select Zone or Theme to build Kastron in');
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
    logLine('>Kastron is built in ${_state.landName(land)}.');
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
      logLine('>Social Event affects ${_state.pathGeographicName(path)}.');
      _subStep = 1;
    }
    final path = phaseState.socialEventPath!;
    final land = _state.pathFinalLand(path);
    if (_subStep == 1) {
      int winningMargin = _state.pathWinningMargin(path);
      int winningAdjustment = 0;
      if (winningMargin == 0) {
        int die = rollD6ForPath(path);
        logD6(die);
        winningAdjustment = die <= 3 ? -1 : 1;
      }
      final trayChristians = _state.piecesInLocation(PieceType.christians, Location.trayUnits);
      var social = trayChristians[0];
      var otherSocial = _state.pieceInLocation(PieceType.social, land);
      if (winningMargin + winningAdjustment > 0) {
        social = _state.pieceFlipSide(social)!;
      }
      if (otherSocial == null) {
        logLine('>${social.desc} is placed in ${_state.pathGeographicName(path)}.');
        _state.setPieceLocation(social, land);
        phaseState.socialEventPath = null;
        return;
      }
      if (social.isType(PieceType.christians) != otherSocial.isType(PieceType.christians)) {
        logLine('>${otherSocial.desc} is removed from ${_state.pathGeographicName(path)}');
        if (otherSocial.isType(PieceType.dynatoi)) {
          otherSocial = _state.pieceFlipSide(otherSocial)!;
        }
        _state.setPieceLocation(otherSocial, Location.trayUnits);
        phaseState.socialEventPath = null;
        return;
      }
      final barbarianPiece = _state.pathBarbarianPiece(path);
      if (social.isType(PieceType.christians)) {
        logLine('>${barbarianPiece.desc} Retreats.');
        _subStep = 2;
      } else {
        logLine('>${barbarianPiece.desc} Advances.');
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
      setPrompt('Proceed to Taxation Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Taxation Phase');
  }

  void taxationPhaseIncome() {
    logLine('### Taxation');

    logTableHeader();
    final dynasty = _state.pieceInLocation(PieceType.dynasty, Location.dynastyBox)!;
    int dynastyIncome = _state.dynastySolidus(dynasty);
    if (dynastyIncome > 0) {
      logLine('>|${dynasty.desc}|$dynastyIncome|');
    }
    int basileisIncome = 0;
    final basileis = _state.currentBasileis;
    for (final basileus in basileis) {
      final basileusIncome = _state.basileusSolidus(basileus);
      if (basileusIncome > 0) {
        logLine('>|${_state.basileusName(basileus)}|$basileusIncome|');
        basileisIncome += basileusIncome;
      }
    }
    int patriarchIncome = currentPatriarchSolidus;
    if (patriarchIncome > 0) {
      logLine('>|Patriarch $currentPatriarchName|$patriarchIncome|');
    }
    int totalIncome = dynastyIncome + basileisIncome + patriarchIncome;
    logLine('>|Total|$totalIncome|');
    logTableFooter();

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
    logLine('>${ruler.desc} is placed in ${_state.pathGeographicName(path)}.');
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
      logLine('>${Piece.caliph.desc} is placed in ${_state.pathGeographicName(path)}.');
      _state.setPieceLocation(Piece.caliph, land);
    } else {
      logLine('>Fitna disrupts Islam.');
      _state.setPieceLocation(Piece.fitna, Location.arabiaBox);
      logLine('>Struggling Caliph pays Tribute.');
      adjustSolidus(1);
    }
  }

  void synopsisOfHistoriesPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Synopsis of Histories Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Synopsis of Histories Phase');
  }

  void synopsisOfHistoriesPhaseRoll() {
    if (_options.separateMilitaryPoliticalEvents) {
      logLine('### Random Events Rolls');
      int die = rollD6();

      logTableHeader();
      logD6InTable(die);
      logLine('>|Turn|${_state.currentTurn + 1}|');
      int militaryTotal = die + _state.currentTurn + 1;
      logLine('>|Military|$militaryTotal|');
      logTableFooter();

      die = rollD6();

      logTableHeader();
      logD6InTable(die);
      logLine('>|Turn|${_state.currentTurn + 1}|');
      int politicalTotal = die + _state.currentTurn + 1;
      logLine('>|Political|$politicalTotal');
      logTableFooter();

      _phaseState = PhaseStateSynopsisOfHistories(militaryTotal, politicalTotal);
    } else {
      logLine('### Random Events Roll');
      int die = rollD6();

      logTableHeader();
      logD6InTable(die);
      logLine('>|Turn|${_state.currentTurn + 1}|');
      int total = die + _state.currentTurn + 1;
      logLine('>|Total|$total|');
      logTableFooter();

      _phaseState = PhaseStateSynopsisOfHistories(total, total);
    }
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
    logLine('>${location.desc}');
    _state.setPieceLocation(Piece.militaryEvent, location);
  }

  void synopsisOfHistoriesPhaseWarInTheEast2() {
    if (_state.pieceLocation(Piece.militaryEvent) != Location.strategikonWarInTheEast) {
      return;
    }
    if (_state.limitedEventCount(LimitedEvent.warInTheEast) != 2) {
      return;
    }
    riseOfIslam();
    _state.limitedEventOccurred(LimitedEvent.warInTheEast);
  }

  void synopsisOfHistoriesRiseOfIslamAdvanceArmy(Piece army, Path path) {
    if (_state.pieceLocation(Piece.militaryEvent) != Location.strategikonWarInTheEast) {
      return;
    }
    if (_state.limitedEventCount(LimitedEvent.warInTheEast) != 3) {
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
    if (_state.limitedEventCount(LimitedEvent.warInTheEast) != 3) {
      return;
    }
    _state.limitedEventOccurred(LimitedEvent.warInTheEast);
  }

  void synopsisOfHistoriesPhaseWarInTheEast1() {
    final phaseState = _phaseState as PhaseStateSynopsisOfHistories;
    if (_state.pieceLocation(Piece.militaryEvent) != Location.strategikonWarInTheEast) {
      return;
    }
    if (_state.limitedEventCount(LimitedEvent.warInTheEast) != 0) {
      return;
    }

    if (_subStep == 0) {
      logLine('### Persia attacks Byzantium');
      logLine('>Persia takes control of the Syrian Front');
      final oldArmy = _state.pathBarbarianPiece(Path.syria);
      if (oldArmy == Piece.armySyriaNomads) {
        _state.pathSetArmy(Path.syria, Piece.armySyriaPersia);
      }
      _subStep = 1;
    }

    if (_subStep == 1) {
      if (choicesEmpty()) {
        final rolls = roll2D6();
        log2D6(rolls);
        phaseState.warInTheEast1Die0 = rolls.$1;
        phaseState.warInTheEast1Die1 = rolls.$2;
        setPrompt('Spend 4 \$olidus to Counterattack?');
        choiceChoosable(Choice.yes, _state.solidusAndNike >= 4);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        logLine('>Byzantium counterattacks the Persians.');
        spendSolidus(4);
        final rolls = roll2D6();
        log2D6(rolls);
        phaseState.warInTheEast1Die0 = rolls.$1;
        phaseState.warInTheEast1Die1 = rolls.$2;
      }
      clearChoices();
      _subStep = 2;
    }

    if (_subStep == 2) {
      final rolls = (phaseState.warInTheEast1Die0!, phaseState.warInTheEast1Die1!, phaseState.warInTheEast1Die0! + phaseState.warInTheEast1Die1!);
      int modifiers = 0;

      logTableHeader();
      log2D6InTable(rolls);
      for (final land in _state.mountainLands) {
        final path = _state.landPath(land)!;
        final controlledCount = _state.pathPlayerControlledLandCount(path);
        final locationType = _state.pathLocationType(path);
        if (controlledCount > land.index - locationType.firstIndex) {
          logLine('>|${_state.landName(land)}|+1|');
          modifiers += 1;
        }
      }
      final total = rolls.$3 + modifiers;
      logLine('>|Total|$total|');
      logTableFooter();

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
        logLine('>Persian Victory');
      } else if (persianRetreat == 3) {
        logLine('>Byzantine Victory');
      } else {
        logLine('>No Victory');
      }
      logLine('>Rubble Level: $rubble');
      _state.setPieceLocation(Piece.empiresInRubble, _state.omnibusBox(rubble));
      _state.limitedEventOccurred(LimitedEvent.warInTheEast);
    }
  }

  void synopsisOfHistoriesPhaseWarInTheEast1Path(Path path, int i) {
    if (_state.limitedEventCount(LimitedEvent.warInTheEast) != 1) {
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
      logLine('>Muslims colonize ${_state.landName(Location.homelandPersia)}.');
      _state.setPieceLocation(Piece.colonistsPersia, Location.homelandPersia);
    }
    if (phaseState.warInTheEast1PersianRetreatCount == 3) {
      _state.setPieceLocation(Piece.paganSyria, Location.homelandSyria);
    } else {
      _state.setPieceLocation(Piece.colonistsSyria, Location.homelandSyria);
      logLine('>Muslims colonize ${_state.landName(Location.homelandSyria)}.');
    }
    _state.limitedEventOccurred(LimitedEvent.warInTheEast);
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
      setPrompt('Proceed to Barbarians Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
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
      setPrompt('Proceed to Byzantine Action Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
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
              choiceChoosable(Choice.enforceOrthodoxy, _state.solidusAndNike >= 1 || (haveSaint && !phaseState.enforceOrthodoxyIgnoreDrms && !phaseState.enforceOthodoxyFree));
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
              final stolosLocation = _state.pieceLocation(Piece.stolos);
              if (stolosLocation != Location.discarded && !stolosLocation.isType(LocationType.chronographia)) {
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
          _subStep = 16;
        } else if (checkChoiceAndClear(Choice.cleanRubble)) {
          logLine('### Clean Rubble');
          spendSolidus(2);
          final box = _state.pieceLocation(Piece.empiresInRubble);
          if (box == Location.omnibus1) {
            logLine('>Byzantine Empire recovers fully from the war with Sassanid Persia.');
            _state.setPieceLocation(Piece.empiresInRubble, Location.discarded);
          } else {
            logLine('>Byzantine Empire rebuilds after the war with Sassanid Persia.');
            _state.setPieceLocation(Piece.empiresInRubble, Location.values[box.index - 1]);
          }
        } else if (checkChoiceAndClear(Choice.calmRiot)) {
          logLine('### Calm Riot');
          int die = rollD6();
          logD6(die);
          if (die > 2) {
            logLine('>Riot is quelled.');
            final riots = _state.piecesInLocation(PieceType.riots, Location.constantinople);
            _state.setPieceLocation(_state.pieceFlipSide(riots[0])!, Location.trayUnits);
          } else {
            logLine('>Riot continues.');
          }
          _state.setPieceLocation(Piece.basileus, Location.hippodromeBox);
        } else if (checkChoiceAndClear(Choice.activateGreekFire)) {
          logLine('### Greek Fire');
          logLine('>Greek Fire is perfected.');
          _state.setPieceLocation(Piece.outpostLazica, Location.outpostLazicaGreekFireBox);
          for (final outpost in _state.piecesInLocation(PieceType.outpost, Location.availableOutpostsBox)) {
            _state.setPieceLocation(outpost, Location.discarded);
          }
        } else if (checkChoiceAndClear(Choice.faceRuler)) {
          final ruler = _state.ruler!;
          logLine('### Face the $ruler.name');
          int die = rollD6();
          logD6(die);
          if (die >= 2 && die <= 5) {
            logLine('>!${ruler.desc} is defeated.');
            _state.setPieceLocation(Piece.rulerKhan, _state.futureChronographiaBox(die, false));
          } else {
            logLine('>!${ruler.desc} remains in power.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die, true));
        } else if (checkChoiceAndClear(Choice.faceCaliph)) {
          logLine('### Face the Caliph');
          int die = rollD6();
          logD6(die);
          if (die >= 2 && die <= 5) {
            logLine('>Caliph is defeated.');
            _state.setPieceLocation(Piece.caliph, _state.futureChronographiaBox(die, false));
          } else {
            logLine('>Caliph remains in power.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die, true));
        } else if (checkChoiceAndClear(Choice.navalReforms)) {
          logLine('### Naval Reforms');
          int die = rollD6();
          logD6(die);
          if (die >= 2 && die <= 5) {
            logLine('>Naval Reforms deter Stolos.');
            _state.setPieceLocation(Piece.stolos, _state.futureChronographiaBox(die, false));
          } else {
            logLine('>Naval Reforms are unsuccessful.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die, true));
        } else if (checkChoiceAndClear(Choice.ruinousTaxation)) {
          logLine('### Ruinous Taxation');
          int die = rollD6();
          logD6(die);
          if (die >= 2 && die <= 5) {
            logLine('>Taxation fills coffers.');
            adjustSolidus(die);
          } else {
            logLine('>Tax increases fail to increase revenue.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die, true));
        } else if (checkChoiceAndClear(Choice.churchPolitics)) {
          logLine('### Church Politics');
          int die = rollD6();
          logD6(die);
          if (die >= 2 && die <= 5) {
            logLine('>Religious differences are eased.');
            adjustSchism(-die);
          } else {
            logLine('>Religious differences continue unabated.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die, true));
        } else if (checkChoiceAndClear(Choice.visionaryReformer)) {
          logLine('### Visionary Reformer');
          int die = rollD6();
          logD6(die);
          if (die >= 2 && die <= 5) {
            adjustReforms(die);
          } else {
            logLine('>Reforms are unsuccessful.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die, true));
        } else if (checkChoiceAndClear(Choice.pandidakterion)) {
          logLine('### Pandidakterion');
          int die = rollD6();
          logD6(die);
          if (die >= 2 && die <= 5) {
            logLine('>University is established.');
            _state.setPieceLocation(Piece.university, Location.constantinople);
          } else {
            logLine('>Attempt to establish University fails.');
          }
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die, true));
        } else if (checkChoiceAndClear(Choice.exploitSocialDifferences)) {
          logLine('### Exploit Social Differences');
          spendSolidus(2);
          for (final path in Path.values) {
            final land = _state.pathFinalLand(path);
            var social = _state.pieceInLocation(PieceType.social, land);
            if (social != null) {
              logLine('>${social.desc} is removed from ${_state.landName(land)}.');
              if (social.isType(PieceType.dynatoi)) {
                social = _state.pieceFlipSide(social)!;
              }
              _state.setPieceLocation(social, Location.trayUnits);
            }
          }
        } else if (checkChoiceAndClear(Choice.combatPlague)) {
          logLine('### Combat Plague');
          for (final hospital in PieceType.unusedHospital.pieces) {
            final location = _state.pieceLocation(hospital);
            _state.setPieceLocation(_state.pieceFlipSide(hospital)!, location);
          }
          int die = rollD6();
          logD6(die);
          if (die >= 4) {
            logLine('>Plague is contained.');
            _state.setPieceLocation(Piece.basileus, Location.constantinople);
          } else {
            logLine('>Plague still rages.');
          }
        } else if (checkChoiceAndClear(Choice.reopenMonasteries)) {
          logLine('### Reopen Monasteries');
          for (final monastery in reopenMonasteryCandidates) {
            final zone = _state.pieceLocation(monastery);
            logLine('>Reopen Monastery in ${_state.landName(zone)}.');
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
          logLine('>Magister Militum ${_state.magisterMilitumName} suffers defeat.');
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
          logLine('>Riots in Constantinople.');
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
        logLine('### Seize ${outpost.desc}');
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
        logLine('### Abandon ${outpost.desc}');
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
          setPrompt('Select Zone to Build Monastery in');
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
          logD6(die);
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die, true));
        } else {
          logLine('### Build Monastery');
          spendSolidus(buildMonasteryCost);
        }
        if (die >= 2 && die <= 5) {
          logLine('>Monastery is built in ${_state.pathGeographicName(path)}.');
          final monasteries = _state.piecesInLocation(PieceType.connectedMonastery, Location.trayGeography);
          _state.setPieceLocation(monasteries[0], zone);
        } else {
          logLine('>Monastery is never completed.');
        }
        clearChoices();
        phaseState.useBasileus = false;
        _subStep = 0;
      }

      if (_subStep == 7) { // Build Hospital
        if (choicesEmpty()) {
          setPrompt('Select Zone or Theme to Build Hospital in');
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
          logD6(die);
          _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die, true));
        } else {
          logLine('### Build Hospital');
          spendSolidus(2);
        }
        if (die >= 2 && die <= 5) {
          logLine('>Hospital is built in ${_state.landName(land)}.');
          final hospitals = _state.piecesInLocation(PieceType.unusedHospital, Location.trayGeography);
          _state.setPieceLocation(hospitals[0], land);
        } else {
          logLine('>Hospital is never completed.');
        }
        clearChoices();
        phaseState.useBasileus = false;
        _subStep = 0;
      }

      if (_subStep == 8) { // Abandon Hospital
        if (choicesEmpty()) {
          setPrompt('Select Hospital to remove from map');
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
        logLine('>Hospital in ${_state.landName(land)} is abandoned.');
        if (!hospital.isType(PieceType.unusedHospital)) {
          hospital = _state.pieceFlipSide(hospital)!;
        }
        _state.setPieceLocation(hospital, Location.trayGeography);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 9) { // Build Akritai
        if (choicesEmpty()) {
          setPrompt('Select Theme to Build Akritai in');
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
        logLine('>Akritai is built in ${_state.landName(land)}.');
        spendSolidus(2);
        final akritais = _state.piecesInLocation(PieceType.unusedAkritai, Location.trayGeography);
        _state.setPieceLocation(akritais[0], land);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 10) { // Abandon Akritai
        if (choicesEmpty()) {
          setPrompt('Select Akritai to remove from map');
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
        logLine('>Akritai in ${_state.landName(land)} is abandoned.');
        if (!akritai.isType(PieceType.unusedAkritai)) {
          akritai = _state.pieceFlipSide(akritai)!;
        }
        _state.setPieceLocation(akritai, Location.trayGeography);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 11) { // Build Faction
        if (choicesEmpty()) {
          setPrompt('Select Faction to build');
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
          logD6(die);
          if (die >= 2 && die <= 5) {
            value -= die;
            moved = true;
          } else {
            logLine('>Crowd is unmoved.');
          }
        } else {
          logLine('### Rebuild Faction');
          spendSolidus(1);
          value -= 1;
          moved = true;
        }
        if (moved) {
          if (value <= 0) {
            logLine('>${faction.desc} is placed in Constantinople.');
            _state.setPieceLocation(faction, Location.constantinople);
          } else {
            logLine('>${faction.desc} something.');
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
        if (haveSaint && !phaseState.enforceOrthodoxyIgnoreDrms && !phaseState.enforceOthodoxyFree) {
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
        if (_state.turnChitHasEcumenicalCouncil(_state.currentTurnChit!)) {
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

          logTableHeader();
          logD6InTable(die);
          if (!ignoreDrms) {
            if (_state.popeMean) {
              logLine('>|Mean Pope|-1|');
              drm -= 1;
            }
            for (final land in [Location.themeCilicia, Location.themeNisibis]) {
              if (_state.landIsPlayerControlled(land)) {
                logLine('>|${_state.landName(land)}|-1|');
                drm -= 1;
              }
            }
          }
          int modifiedDie = dieWithDrm(die, drm);
          logLine('>|Modified|$modifiedDie|');
          logTableFooter();

          if (modifiedDie > 1) {
            logLine('>Schism is reduced.');
            adjustSchism(-1);
          } else {
            logLine('>Schism is unchanged.');
          }
        }
        _subStep = 0;
      }

      if (_subStep == 13) {
        if (choicesEmpty()) {
          setPrompt('Select Dynatoi to legislate against');
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
        logD6(die);
        if (die >= 2 && die <= 5) {
          logLine('>Legislation brings Dynatoi to heel.');
          _state.setPieceLocation(dynatoi, _state.futureChronographiaBox(die, false));
        } else {
          logLine('>Legislation fails to control Dynatoi.');
        }
        _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die, true));
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
        phaseState.expelColonists = selectedPiece();
        clearChoices();
        _subStep = 15;
      }

      if (_subStep == 15) { // Expel Colonists roll
        final colonists = phaseState.expelColonists!;
        final land = _state.pieceLocation(colonists);
        final path = _state.landPath(land)!;
        int die = rollD6();
        logD6(die);
        if (die >= 2 && die <= 5) {
          logLine('>Muslim Colonists are expelled from ${_state.landName(land)}.');
          _state.setPieceLocation(colonists, _state.pathNextLocation(path, land)!);
        } else {
          logLine('>Efforts to expel Muslim Colonists from ${_state.landName(land)} fail.');
        }
        _state.setPieceLocation(Piece.basileus, _state.futureChronographiaBox(die, true));
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 16) { // Shift Forces
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
      setPrompt('Proceed to Turn End Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
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
      logLine('>Muslim Colonization in ${_state.pathGeographicName(path)}.');
      _subStep = 1;
    }
    if (_subStep == 1) {
      bool automatic = false;
      if (army == seljukArmy) {
        if (_options.anatolianPlateau) {
          if (path == Path.persia) {
            automatic = true;
          }
        } else {
          automatic = true;
        }
      }
      if (!automatic) {
        int die = rollD6ForEasternPath(path);
        logD6(die);
        if (die < 6) {
          logLine('>Islam does not advance in ${_state.pathGeographicName(path)}.');
          return;
        }
      }
      final prevLand = _state.pathPrevLocation(path, colonistsLocation);
      logLine('>Muslims colonize ${_state.landName(prevLand)}.');
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
    logD6(die);
    if (die < 6) {
      logLine('>Egypt remains Christian.');
      return;
    }
    logLine('>Egypt adopts Islam.');
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
      logD6(die);
      if (die < 6) {
        logLine('>Egypt holds out.');
        return;
      }
      logLine('>Egypt falls.');
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
        logLine('>No attempt is made to reconquer Egypt.');
        return;
      }
      clearChoices();
      logLine('>Byzantine Empire attempts to reconquer Egypt.');
      spendSolidus(1);
      int die = rollD6();
      logD6(die);
      if (die < 6) {
        logLine('>Attempt to reconquer Egypt fails.');
        return;
      }
      logLine('>Egypt is reconquered.');
      _state.setPieceLocation(Piece.outpostEgypt, Location.outpostEgyptBox);
    }
  }

  void turnEndPhaseUndefeatedStolos() {
    if (!_state.pieceLocation(Piece.stolos).isType(LocationType.land)) {
      return;
    }
    logLine('### Undefeated Stolos');
    logLine('>Undefeated Stolos lowers morale in Constantinople.');
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
        logLine('>Persian rule revives in ${_state.pathGeographicName(Path.persia)}.');
        _state.setPieceLocation(Piece.armyPersiaPersia, persianLocation);
      } else {
        logLine('>Ilkhanid rule is established in ${_state.pathGeographicName(Path.persia)}.');
        _state.setPieceLocation(Piece.armyPersiaIlKhanid, persianLocation);
      }
    }
    if (syrianLocation.isType(LocationType.land)) {
      _state.setPieceLocation(Piece.armySyriaMongol, Location.discarded);
      final colonistLocation = _state.pieceLocation(Piece.colonistsSyria);
      if (!colonistLocation.isType(LocationType.land) || colonistLocation == Location.homelandSyria) {
        logLine('>Persian rule revives in ${_state.pathGeographicName(Path.syria)}.');
        _state.setPieceLocation(Piece.armySyriaPersia, syrianLocation);
      } else {
        logLine('>Ilkhanid rule is established in ${_state.pathGeographicName(Path.syria)}.');
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
          logLine('>Basileus chooses to leave Social Tiles in place.');
          return;
        }
        clearChoices();
      }
      for (var social in socialTiles) {
        final location = _state.pieceLocation(social);
        final path = _state.landPath(location)!;
        logLine('>${social.desc} is removed from ${_state.pathGeographicName(path)}.');
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
    _state.clearPossibleLimitedEvents();
  }

  void turnEndPhaseVictory() {
    if (_state.currentTurn < 26) {
      return;
    }
    logLine('# Deus ex Machina');

    logTableHeader();
    int total = 30;
    logLine('>|Baseline|30|');
    for (final path in _state.westernPaths) {
      final armyType = _state.pathArmyType(path);
      final zone = _state.pathZone(path);
      final armyCount = _state.piecesInLocationCount(armyType, zone);
      total -= armyCount;
      logLine('>|${path.desc} Armies|-$armyCount|');
    }
    for (final path in _state.easternPaths) {
      int controlledLandCount = _state.pathBarbarianControlledLandCount(path);
      total -= controlledLandCount;
      logLine('>|${path.desc} Foreign Lands:$controlledLandCount|');
    }
    for (final outpost in PieceType.outpost.pieces) {
      if (_state.pieceLocation(outpost).isType(LocationType.outpostBox)) {
        logLine('>|${outpost.desc}|+2|');
        total += 2;
      }
    }
    int factionCount = _state.piecesInLocationCount(PieceType.faction, Location.constantinople);
    if (factionCount > 0) {
      logLine('>|Factions|+$factionCount|');
      total += factionCount;
    }
    if (_state.solidus > 0) {
      logLine('>\$olidus|+${_state.solidus}|');
      total += _state.solidus;
    }
    for (final monastery in PieceType.monastery.pieces) {
      final location = _state.pieceLocation(monastery);
      if (location.isType(LocationType.land)) {
        logLine('>|Monastery in ${_state.landName(location)}|+3|');
        total += 3;
      }
    }
    if (_state.pieceLocation(Piece.university) == Location.constantinople) {
      logLine('>|University|+3|');
      total += 3;
    }
    for (final hospital in PieceType.unusedHospital.pieces) {
      final location = _state.pieceLocation(hospital);
      if (location.isType(LocationType.land)) {
        logLine('>|Hospital in ${_state.landName(location)}|+3|');
        total += 3;
      }
    }
    if (_state.pieceLocation(Piece.geographyItaly) == Location.zoneWest) {
      logLine('>|Italy|+5|');
      total += 5;
    }
    if (_state.pieceLocation(Piece.geographyAfrica) == Location.zoneSouth) {
      logLine('>|Africa|+5|');
      total += 5;
    }
    if (_state.pieceLocation(Piece.empiresInRubble).isType(LocationType.omnibus)) {
      logLine('>|Empire in Rubble|-10|');
      total -= 10;
    }
    logLine('>|Victory Points|$total|');
    logTableFooter();

    throw GameOverException(GameResult.victory, total);
  }

  void turnEndPhaseEndTurn() {
    _state.clearCurrentEvents();
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
      turnStartPhaseOptionalEvent0,
      turnStartPhaseOptionalEvent1,
      turnStartPhaseOptionalEvent2,
      turnStartPhaseOptionalEvent3,
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

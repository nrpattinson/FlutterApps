import 'dart:convert';
import 'dart:math';
import 'package:gift_of_the_nile/db.dart';

enum Location {
  landMenNefer,
  landKhem,
  landZau,
  landPerWadjet,
  landUsermaatreSetepenre,
  landSekhetAm,
  countryTjehenu,
  landPerBastet,
  landHutwaret,
  landDjanet,
  landWaysOfHorus,
  landSharuhen,
  countryRetjenu,
  landIunu,
  landPerAtum,
  landBekhnu,
  landBiau,
  landKhetyuMefkat,
  countryTaNetjer,
  landAbdju,
  landShabt,
  landWast,
  landWetjesetHor,
  landSwenet,
  landIrtjet,
  landWawat,
  countryTaSeti,
  landPayomLakes,
  landDjesdjes,
  landAnaAkhet,
  landMut,
  landKenemet,
  countryLibu,
  boxPromisedLand,
  boxWilderness,
  boxAlexandria,
  boxRiseDeclineNone,
  boxRiseDeclineTjehenu,
  boxRiseDeclineRetjenu,
  boxRiseDeclineTaNetjer,
  boxRiseDeclineTaSeti,
  boxRiseDeclineLibu,
  boxRiseDeclineAllPaths,
  boxChariotsTjehenu,
  boxChariotsRetjenu,
  boxChariotsTaNetjer,
  boxChariotsTaSeti,
  boxChariotsLibu,
  boxGreatPyramids,
  boxTempleOfIpetIsut,
  boxValleyOfTheKings,
  boxPharaohUnavailable,
  boxHeroes,
  boxHouseOfLife,
  boxEra,
  boxGod,
  boxRevival,
  boxWastSepat0,
  boxWastSepat1,
  boxWastSepat2,
  granary0,
  granary1,
  granary2,
  granary3,
  granary4,
  granary5,
  granary6,
  granary7,
  granary8,
  granary9,
  dynasty3,
  dynasty4,
  dynasty5,
  dynasty6,
  dynasty7,
  dynasty8,
  dynasty9,
  dynasty10,
  dynasty11,
  dynasty12,
  dynasty13,
  dynasty14,
  dynasty15,
  dynasty16,
  dynasty17,
  dynasty18,
  dynasty19,
  dynasty20,
  dynasty21,
  dynasty22,
  dynasty23,
  dynasty24,
  dynasty25,
  dynasty26,
  dynasty27,
  dynasty28,
  dynasty29,
  dynasty30,
  dynasty31,
  dynasty32,
  dynasty33,
  dynasty34,
  dynasty35,
  dynasty36,
  dynasty37,
  dynasty38,
  literacyHieroglyphic,
  literacyHieratic,
  literacyDemotic,
  literacyCoptic,
  cupDynasty,
  cupSepat,
  cupGod,
  traySepat,
  trayMilitary,
  trayDynasty,
  trayRetjenu,
  trayRevival,
  trayLibu,
  trayPolitical,
  trayEconomic,
  trayPeople,
  trayKerma,
  trayGods,
  trayEra,
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
  pathLand,
  pathTjehenu,
  pathRetjenu,
  pathTaNetjer,
  pathTaSeti,
  pathLibu,
  pathRiseDeclineBox,
  pathChariotsBox,
  megaprojectBox,
  granary,
  literacy,
  dynasty,
  tray,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.land: [Location.landMenNefer, Location.countryLibu],
    LocationType.pathLand: [Location.landKhem, Location.countryLibu],
    LocationType.pathTjehenu: [Location.landKhem, Location.countryTjehenu],
    LocationType.pathRetjenu: [Location.landPerBastet, Location.countryRetjenu],
    LocationType.pathTaNetjer: [Location.landIunu, Location.countryTaNetjer],
    LocationType.pathTaSeti: [Location.landAbdju, Location.countryTaSeti],
    LocationType.pathLibu: [Location.landPayomLakes, Location.countryLibu],
    LocationType.pathRiseDeclineBox: [Location.boxRiseDeclineTjehenu, Location.boxRiseDeclineLibu],
    LocationType.pathChariotsBox: [Location.boxChariotsTjehenu, Location.boxChariotsLibu],
    LocationType.megaprojectBox: [Location.boxGreatPyramids, Location.boxValleyOfTheKings],
    LocationType.granary: [Location.granary0, Location.granary9],
    LocationType.literacy: [Location.literacyHieroglyphic, Location.literacyCoptic],
    LocationType.dynasty: [Location.dynasty3, Location.dynasty38],
    LocationType.tray: [Location.traySepat, Location.trayEra],
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
      Location.landMenNefer: 'Men-Nefer',
      Location.landKhem: 'Khem',
      Location.landZau: 'Zau',
      Location.landPerWadjet: 'Per-Wadjet',
      Location.landUsermaatreSetepenre: 'Usermaatre-Setepenre',
      Location.landSekhetAm: 'Sekhet-Am',
      Location.countryTjehenu: 'Tjehenu Country',
      Location.landPerBastet: 'Per-Bastet',
      Location.landHutwaret: 'Hutwaret',
      Location.landDjanet: 'Djanet',
      Location.landWaysOfHorus: 'Ways of Horus',
      Location.landSharuhen: 'Sharuhen',
      Location.countryRetjenu: 'Retjenu Country',
      Location.landIunu: 'Iunu',
      Location.landPerAtum: 'Per-Atum',
      Location.landBekhnu: 'Behknu',
      Location.landBiau: 'Biau',
      Location.landKhetyuMefkat: 'Khetyu Mefkat',
      Location.countryTaNetjer: 'Ta Netjer Country',
      Location.landAbdju: 'Abdju',
      Location.landShabt: 'Shabt',
      Location.landWast: 'Wast',
      Location.landWetjesetHor: 'Wetjeset-Hor',
      Location.landSwenet: 'Swenet',
      Location.landIrtjet: 'Irtjet',
      Location.landWawat: 'Wawat',
      Location.countryTaSeti: 'Ta Seti Country',
      Location.landPayomLakes: 'Payom Lakes',
      Location.landDjesdjes: 'Djesdjes',
      Location.landAnaAkhet: 'Ana Akhet',
      Location.landMut: 'Mut',
      Location.landKenemet: 'Kenemet',
      Location.countryLibu: 'Libu Country',
      Location.boxHouseOfLife: 'The House of Life',
      Location.literacyHieroglyphic: 'Hieroglyphic',
      Location.literacyHieratic: 'Hieratic',
      Location.literacyDemotic: 'Demotic',
      Location.literacyCoptic: 'Coptic',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Path {
  tjehenu,
  retjenu,
  taNetjer,
  taSeti,
  libu,
}

extension PathExtension on Path {
  String get desc {
    const pathDescs = {
      Path.tjehenu: 'Tjehenu',
      Path.retjenu: 'Retjenu',
      Path.taNetjer: 'Ta Netjer',
      Path.taSeti: 'Ta Seti',
      Path.libu: 'Libu',
    };
    return pathDescs[this]!;
  }
}

Path? pathFromIndex(int? index) {
  if (index != null) {
    return Path.values[index];
  } else {
    return null;
  }
}

int? pathToIndex(Path? path) {
  return path?.index;
}

enum Piece {
  sepatUntempled0,
  sepatUntempled1,
  sepatUntempled2,
  sepatUntempled3,
  sepatUntempled4,
  sepatUntempled5,
  sepatUntempled6,
  sepatUntempled7,
  sepatUntempled8,
  sepatUntempled9,
  sepatUntempled10,
  sepatUntempled11,
  sepatUntempled12,
  sepatUntempled13,
  sepatUntempled14,
  sepatUntempled15,
  sepatUntempled16,
  sepatUntempled17,
  sepatUntempled18,
  sepatUntempled19,
  sepatUntempled20,
  sepatUntempled21,
  sepatUntempled22,
  sepatUntempled23,
  sepatUntempled24,
  sepatTempled0,
  sepatTempled1,
  sepatTempled2,
  sepatTempled3,
  sepatTempled4,
  sepatTempled5,
  sepatTempled6,
  sepatTempled7,
  sepatTempled8,
  sepatTempled9,
  sepatTempled10,
  sepatTempled11,
  sepatTempled12,
  sepatTempled13,
  sepatTempled14,
  sepatTempled15,
  sepatTempled16,
  sepatTempled17,
  sepatTempled18,
  sepatTempled19,
  sepatTempled20,
  sepatTempled21,
  sepatTempled22,
  sepatTempled23,
  sepatTempled24,
  khastiMeshwesh,
  khastiCyrene,
  khastiCanaan,
  khastiHyksos,
  khastiMitanni,
  khastiHittites,
  khastiSeaPeoples,
  khastiAssyria,
  khastiBabylon,
  khastiPersia,
  khastiSeleucids,
  khastiRomans,
  khastiShasu,
  khastiNabatu,
  khastiKerma,
  khastiKush,
  khastiMeroe,
  khastiLibu,
  medjaiTroopsTjehenu,
  medjaiTroopsRetjenu,
  medjaiTroopsTaNetjer,
  medjaiTroopsTaSeti,
  medjaiTroopsLibu,
  rivalDynasty0,
  rivalDynasty1,
  rivalDynasty2,
  rivalDynasty3,
  rivalDynasty4,
  heroesChariotsP1,
  heroesChariotsP2,
  heroesNubianArchers,
  heroesNubianArchersBack,
  heroesMeraFleet,
  heroesMeraFleetBack,
  medjaiPolice,
  highPriests,
  wallsOfTheRuler0,
  wallsOfTheRuler1,
  megaprojectGreatPyramids,
  megaprojectTempleOfIpetIsut,
  megaprojectValleyOfTheKings,
  megaprojectGreatPyramidsLooted,
  megaprojectTempleOfIpetIsutLooted,
  megaprojectValleyOfTheKingsLooted,
  pharaoh,
  greeks,
  greeksDepleted,
  jews,
  jewsDepleted,
  hebrewPeople,
  israel0,
  israeln1,
  libyanMigrants,
  egyptianRule0,
  egyptianRule1,
  okToLoot0,
  okToLoot1,
  marriage,
  alexandria,
  rise,
  decline,
  godThoth,
  godRa,
  godHorus,
  godOsiris,
  godAnubis,
  godBastet,
  godPtah,
  godIsis,
  eraOldKingdom,
  eraMiddleKingdom,
  eraNewKingdom,
  eraLatePeriod,
  maat0,
  maat1,
  maat0Used,
  maat1Used,
  senet,
  revival0,
  revival1,
  revival2,
  revival3,
  revival4,
  revival5,
  romanDebt,
  dynastyA,
  dynastyB,
  dynastyC,
  dynastyD,
  dynastyE,
  dynastyF,
  dynastyG,
  dynastyH,
  dynastyABack,
  dynastyBBack,
  dynastyCBack,
  dynastyDBack,
  dynastyEBack,
  dynastyFBack,
  dynastyGBack,
  actionPoints,
  gold,
  inbreeding,
  actionPointsLimit,
  literacy,
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
  sepat,
  sepatUntempled,
  sepatUntempledRandom,
  sepatTempled,
  khasti,
  khastiTjehenu,
  khastiRetjenu,
  khastiTaNetjer,
  khastiTaSeti,
  khastiLibu,
  medjaiTroops,
  rivalDynasty,
  chariots,
  wallsOfTheRuler,
  megaproject,
  megaprojectUnlooted,
  megaprojectLooted,
  greeks,
  israel,
  egyptianRule,
  okToLoot,
  god,
  godFront,
  era,
  maat,
  maatUnused,
  revival,
  dynasty,
  regularDynasty,
  egyptianDynastyFront,
  weakEgyptianDynastyFront,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.sepatUntempled0, Piece.literacy],
    PieceType.sepat: [Piece.sepatUntempled0, Piece.sepatTempled24],
    PieceType.sepatUntempled: [Piece.sepatUntempled0, Piece.sepatUntempled24],
    PieceType.sepatUntempledRandom: [Piece.sepatUntempled0, Piece.sepatUntempled23],
    PieceType.sepatTempled: [Piece.sepatTempled0, Piece.sepatTempled24],
    PieceType.khasti: [Piece.khastiMeshwesh, Piece.khastiLibu],
    PieceType.khastiTjehenu: [Piece.khastiMeshwesh, Piece.khastiCyrene],
    PieceType.khastiRetjenu: [Piece.khastiCanaan, Piece.khastiRomans],
    PieceType.khastiTaNetjer: [Piece.khastiShasu, Piece.khastiNabatu],
    PieceType.khastiTaSeti: [Piece.khastiKerma, Piece.khastiMeroe],
    PieceType.khastiLibu: [Piece.khastiLibu, Piece.khastiLibu],
    PieceType.medjaiTroops: [Piece.medjaiTroopsTjehenu, Piece.medjaiTroopsLibu],
    PieceType.rivalDynasty: [Piece.rivalDynasty0, Piece.rivalDynasty4],
    PieceType.chariots: [Piece.heroesChariotsP1, Piece.heroesChariotsP2],
    PieceType.wallsOfTheRuler: [Piece.wallsOfTheRuler0, Piece.wallsOfTheRuler1],
    PieceType.megaproject: [Piece.megaprojectGreatPyramids, Piece.megaprojectValleyOfTheKingsLooted],
    PieceType.megaprojectUnlooted: [Piece.megaprojectGreatPyramids, Piece.megaprojectValleyOfTheKings],
    PieceType.megaprojectLooted: [Piece.megaprojectGreatPyramidsLooted, Piece.megaprojectValleyOfTheKingsLooted],
    PieceType.greeks: [Piece.greeks, Piece.greeksDepleted],
    PieceType.israel: [Piece.israel0, Piece.israeln1],
    PieceType.egyptianRule: [Piece.egyptianRule0, Piece.egyptianRule1],
    PieceType.okToLoot: [Piece.okToLoot0, Piece.okToLoot1],
    PieceType.god: [Piece.godThoth, Piece.godIsis],
    PieceType.godFront: [Piece.godThoth, Piece.godOsiris],
    PieceType.era: [Piece.eraOldKingdom, Piece.eraLatePeriod],
    PieceType.maat: [Piece.maat0, Piece.maat1Used],
    PieceType.maatUnused: [Piece.maat0, Piece.maat1],
    PieceType.revival: [Piece.revival0, Piece.revival5],
    PieceType.dynasty: [Piece.dynastyA, Piece.dynastyGBack],
    PieceType.egyptianDynastyFront: [Piece.dynastyA, Piece.dynastyG],
    PieceType.weakEgyptianDynastyFront: [Piece.dynastyE, Piece.dynastyG],
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
      Piece.khastiMeshwesh: 'Meshwesh',
      Piece.khastiCyrene: 'Cyrene',
      Piece.khastiCanaan: 'Canaan',
      Piece.khastiHyksos: 'Hyksos',
      Piece.khastiMitanni: 'Mitanni',
      Piece.khastiHittites: 'Hittites',
      Piece.khastiSeaPeoples: 'Sea Peoples',
      Piece.khastiAssyria: 'Assyria',
      Piece.khastiBabylon: 'Babylon',
      Piece.khastiPersia: 'Persia',
      Piece.khastiSeleucids: 'Seleucids',
      Piece.khastiRomans: 'Romans',
      Piece.khastiShasu: 'Shasu',
      Piece.khastiNabatu: 'Nabatu',
      Piece.khastiKerma: 'Kerma',
      Piece.khastiKush: 'Kush',
      Piece.khastiMeroe: 'Meroë',
      Piece.khastiLibu: 'Libu',
      Piece.rivalDynasty0: 'Rival Dynasty (2)',
      Piece.rivalDynasty1: 'Rival Dynasty (3)',
      Piece.rivalDynasty2: 'Rival Dynasty (3)',
      Piece.rivalDynasty3: 'Rival Dynasty (4)',
      Piece.rivalDynasty4: 'Rival Dynasty (4)',
      Piece.heroesChariotsP1: 'Chariots',
      Piece.heroesChariotsP2: 'Chariots',
      Piece.heroesNubianArchers: 'Nubian Archers',
      Piece.heroesNubianArchersBack: 'Nubian Archers',
      Piece.heroesMeraFleet: 'Mera Fleet',
      Piece.heroesMeraFleetBack: 'Mera Fleet',
      Piece.megaprojectGreatPyramids: 'Great Pyramids',
      Piece.megaprojectTempleOfIpetIsut: 'Temple of Ipet-Isut',
      Piece.megaprojectValleyOfTheKings: 'Valley of the Kings',
      Piece.megaprojectGreatPyramidsLooted: 'Great Pyramids',
      Piece.megaprojectTempleOfIpetIsutLooted: 'Temple of Ipet-Isut',
      Piece.megaprojectValleyOfTheKingsLooted: 'Valley of the Kings',
      Piece.greeks: 'Greeks',
      Piece.greeksDepleted: 'Greeks',
      Piece.jews: 'Jews',
      Piece.jewsDepleted: 'Jews',
      Piece.godThoth: 'Thoth',
      Piece.godRa: 'Ra',
      Piece.godHorus: 'Horus',
      Piece.godOsiris: 'Osiris',
      Piece.godAnubis: 'Anubis',
      Piece.godBastet: 'Bastet',
      Piece.godPtah: 'Ptah',
      Piece.godIsis: 'Isis',
      Piece.eraOldKingdom: 'Old Kingdom',
      Piece.eraMiddleKingdom: 'Middle Kingdom',
      Piece.eraNewKingdom: 'New Kingdom',
      Piece.eraLatePeriod: 'Late Period',
      Piece.dynastyA: 'Dynasty A',
      Piece.dynastyB: 'Dynasty B',
      Piece.dynastyC: 'Dynasty C',
      Piece.dynastyD: 'Dynasty D',
      Piece.dynastyE: 'Dynasty E',
      Piece.dynastyF: 'Dynasty F',
      Piece.dynastyG: 'Dynasty G',
      Piece.dynastyH: 'Dynasty H',
      Piece.dynastyABack: 'Dynasty A',
      Piece.dynastyBBack: 'Dynasty B',
      Piece.dynastyCBack: 'Dynasty C',
      Piece.dynastyDBack: 'Dynasty D',
      Piece.dynastyEBack: 'Dynasty E',
      Piece.dynastyFBack: 'Dynasty F',
      Piece.dynastyGBack: 'Dynasty G',
    };
    return pieceDescs[this]!;
  }

  bool isType(PieceType pieceType) {
    return index >= pieceType.firstIndex && index < pieceType.lastIndex;
  }
}

enum CurrentEvent {
  alexander,
  goldenAge,
  monotheism,
}

enum LimitedEvent {
  maccabees,
  rome,
}

enum Era {
  oldKingdom,
  middleKingdom,
  newKingdom,
  latePeriod,
}

extension EraExtension on Era {
  String get desc {
    const eraDescs = {
      Era.oldKingdom: 'Old Kingdom',
      Era.middleKingdom: 'Middle Kingdom',
      Era.newKingdom: 'New Kingdom',
      Era.latePeriod: 'Late Period',
    };
    return eraDescs[this]!;
  }
}

enum Goods {
  beer,
  copper,
  grain,
  granite,
  limestone,
  linen,
  natron,
  papyrus,
  turquoise,
  iron,
}

extension GoodsExtension on Goods {
  String get desc {
    const goodsDescs = {
      Goods.beer: 'Beer',
      Goods.copper: 'Copper',
      Goods.grain: 'Grain',
      Goods.granite: 'Granite',
      Goods.limestone: 'Limestone',
      Goods.linen: 'Linen',
      Goods.natron: 'Natron',
      Goods.papyrus: 'Papyrus',
      Goods.turquoise: 'Turquoise',
      Goods.iron: 'Iron',
    };
    return goodsDescs[this]!;
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
      Scenario.standard: 'Standard 3rd Dynasty to 38th Dynasty (36 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameOptions {
  bool latePeriodIron = false;

  GameOptions();

  GameOptions.fromJson(Map<String, dynamic> json)
    : latePeriodIron = json['latePeriodIron'] as bool
    ;

  Map<String, dynamic> toJson() => {
    'latePeriodIron': latePeriodIron,
  };

  String get desc {
    String optionsList = '';
    if (latePeriodIron) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Late Period Iron';
    }
    return optionsList;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<bool> _currentEvents = List<bool>.filled(CurrentEvent.values.length, false);
  List<int> _limitedEvents = List<int>.filled(LimitedEvent.values.length, 0);
  int _turn = 0;
  int isisRerollCount = 0;
  int? manethoTotal;

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
    : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
    , _currentEvents = List<bool>.from(json['currentEvents'])
    , _limitedEvents = List<int>.from(json['limitedEvents'])
    , _turn = json['turn'] as int
    , isisRerollCount = json['isisRerollCount'] as int
    , manethoTotal = json['manethoTotal'] as int?
    ;

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'currentEvents': _currentEvents,
    'limitedEvents': _limitedEvents,
    'turn': _turn,
    'isisRerollCount': isisRerollCount,
    'manethoTotal': manethoTotal,
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.sepatUntempled0: Piece.sepatTempled0,
      Piece.sepatUntempled1: Piece.sepatTempled1,
      Piece.sepatUntempled2: Piece.sepatTempled2,
      Piece.sepatUntempled3: Piece.sepatTempled3,
      Piece.sepatUntempled4: Piece.sepatTempled4,
      Piece.sepatUntempled5: Piece.sepatTempled5,
      Piece.sepatUntempled6: Piece.sepatTempled6,
      Piece.sepatUntempled7: Piece.sepatTempled7,
      Piece.sepatUntempled8: Piece.sepatTempled8,
      Piece.sepatUntempled9: Piece.sepatTempled9,
      Piece.sepatUntempled10: Piece.sepatTempled10,
      Piece.sepatUntempled11: Piece.sepatTempled11,
      Piece.sepatUntempled12: Piece.sepatTempled12,
      Piece.sepatUntempled13: Piece.sepatTempled13,
      Piece.sepatUntempled14: Piece.sepatTempled14,
      Piece.sepatUntempled15: Piece.sepatTempled15,
      Piece.sepatUntempled16: Piece.sepatTempled16,
      Piece.sepatUntempled17: Piece.sepatTempled17,
      Piece.sepatUntempled18: Piece.sepatTempled18,
      Piece.sepatUntempled19: Piece.sepatTempled19,
      Piece.sepatUntempled20: Piece.sepatTempled20,
      Piece.sepatUntempled21: Piece.sepatTempled21,
      Piece.sepatUntempled22: Piece.sepatTempled22,
      Piece.sepatUntempled23: Piece.sepatTempled23,
      Piece.sepatUntempled24: Piece.sepatTempled24,
      Piece.sepatTempled0: Piece.sepatUntempled0,
      Piece.sepatTempled1: Piece.sepatUntempled1,
      Piece.sepatTempled2: Piece.sepatUntempled2,
      Piece.sepatTempled3: Piece.sepatUntempled3,
      Piece.sepatTempled4: Piece.sepatUntempled4,
      Piece.sepatTempled5: Piece.sepatUntempled5,
      Piece.sepatTempled6: Piece.sepatUntempled6,
      Piece.sepatTempled7: Piece.sepatUntempled7,
      Piece.sepatTempled8: Piece.sepatUntempled8,
      Piece.sepatTempled9: Piece.sepatUntempled9,
      Piece.sepatTempled10: Piece.sepatUntempled10,
      Piece.sepatTempled11: Piece.sepatUntempled11,
      Piece.sepatTempled12: Piece.sepatUntempled12,
      Piece.sepatTempled13: Piece.sepatUntempled13,
      Piece.sepatTempled14: Piece.sepatUntempled14,
      Piece.sepatTempled15: Piece.sepatUntempled15,
      Piece.sepatTempled16: Piece.sepatUntempled16,
      Piece.sepatTempled17: Piece.sepatUntempled17,
      Piece.sepatTempled18: Piece.sepatUntempled18,
      Piece.sepatTempled19: Piece.sepatUntempled19,
      Piece.sepatTempled20: Piece.sepatUntempled20,
      Piece.sepatTempled21: Piece.sepatUntempled21,
      Piece.sepatTempled22: Piece.sepatUntempled22,
      Piece.sepatTempled23: Piece.sepatUntempled23,
      Piece.sepatTempled24: Piece.sepatUntempled24,
      Piece.khastiMeshwesh: Piece.khastiCyrene,
      Piece.khastiCyrene: Piece.khastiMeshwesh,
      Piece.khastiCanaan: Piece.khastiHyksos,
      Piece.khastiHyksos: Piece.khastiCanaan,
      Piece.khastiHittites: Piece.khastiMitanni,
      Piece.khastiMitanni: Piece.khastiHittites,
      Piece.khastiAssyria: Piece.khastiSeaPeoples,
      Piece.khastiSeaPeoples: Piece.khastiAssyria,
      Piece.khastiPersia: Piece.khastiBabylon,
      Piece.khastiBabylon: Piece.khastiPersia,
      Piece.khastiRomans: Piece.khastiSeleucids,
      Piece.khastiSeleucids: Piece.khastiRomans,
      Piece.khastiShasu: Piece.khastiNabatu,
      Piece.khastiNabatu: Piece.khastiShasu,
      Piece.khastiKush: Piece.khastiMeroe,
      Piece.khastiMeroe: Piece.khastiKush,
      Piece.medjaiTroopsTjehenu: Piece.rivalDynasty0,
      Piece.medjaiTroopsRetjenu: Piece.rivalDynasty1,
      Piece.medjaiTroopsTaNetjer: Piece.rivalDynasty2,
      Piece.medjaiTroopsTaSeti: Piece.rivalDynasty3,
      Piece.medjaiTroopsLibu: Piece.rivalDynasty4,
      Piece.rivalDynasty0: Piece.medjaiTroopsTjehenu,
      Piece.rivalDynasty1: Piece.medjaiTroopsRetjenu,
      Piece.rivalDynasty2: Piece.medjaiTroopsTaNetjer,
      Piece.rivalDynasty3: Piece.medjaiTroopsTaSeti,
      Piece.rivalDynasty4: Piece.medjaiTroopsLibu,
      Piece.heroesChariotsP1: Piece.heroesChariotsP2,
      Piece.heroesChariotsP2: Piece.heroesChariotsP1,
      Piece.heroesNubianArchers: Piece.heroesNubianArchersBack,
      Piece.heroesNubianArchersBack: Piece.heroesNubianArchers,
      Piece.heroesMeraFleet: Piece.heroesMeraFleetBack,
      Piece.heroesMeraFleetBack: Piece.heroesMeraFleet,
      Piece.megaprojectGreatPyramids: Piece.megaprojectGreatPyramidsLooted,
      Piece.megaprojectTempleOfIpetIsut: Piece.megaprojectTempleOfIpetIsutLooted,
      Piece.megaprojectValleyOfTheKings: Piece.megaprojectValleyOfTheKingsLooted,
      Piece.megaprojectGreatPyramidsLooted: Piece.megaprojectGreatPyramids,
      Piece.megaprojectTempleOfIpetIsutLooted: Piece.megaprojectTempleOfIpetIsut,
      Piece.megaprojectValleyOfTheKingsLooted: Piece.megaprojectValleyOfTheKings,
      Piece.greeks: Piece.greeksDepleted,
      Piece.greeksDepleted: Piece.greeks,
      Piece.jews: Piece.jewsDepleted,
      Piece.jewsDepleted: Piece.jews,
      Piece.israel0: Piece.israeln1,
      Piece.israeln1: Piece.israel0,
      Piece.libyanMigrants: Piece.dynastyH,
      Piece.dynastyH: Piece.libyanMigrants,
      Piece.egyptianRule0: Piece.okToLoot0,
      Piece.egyptianRule1: Piece.okToLoot1,
      Piece.okToLoot0: Piece.egyptianRule0,
      Piece.okToLoot1: Piece.egyptianRule1,
      Piece.rise: Piece.decline,
      Piece.decline: Piece.rise,
      Piece.godThoth: Piece.godAnubis,
      Piece.godAnubis: Piece.godThoth,
      Piece.godRa: Piece.godBastet,
      Piece.godBastet: Piece.godRa,
      Piece.godHorus: Piece.godPtah,
      Piece.godPtah: Piece.godHorus,
      Piece.godOsiris: Piece.godIsis,
      Piece.godIsis: Piece.godOsiris,
      Piece.eraOldKingdom: Piece.senet,
      Piece.senet: Piece.eraOldKingdom,
      Piece.eraMiddleKingdom: Piece.romanDebt,
      Piece.romanDebt: Piece.eraMiddleKingdom,
      Piece.maat0: Piece.maat0Used,
      Piece.maat1: Piece.maat1Used,
      Piece.maat0Used: Piece.maat0,
      Piece.maat1Used: Piece.maat1,
      Piece.dynastyA: Piece.dynastyABack,
      Piece.dynastyB: Piece.dynastyBBack,
      Piece.dynastyC: Piece.dynastyCBack,
      Piece.dynastyD: Piece.dynastyDBack,
      Piece.dynastyE: Piece.dynastyEBack,
      Piece.dynastyF: Piece.dynastyFBack,
      Piece.dynastyG: Piece.dynastyGBack,
      Piece.dynastyABack: Piece.dynastyA,
      Piece.dynastyBBack: Piece.dynastyB,
      Piece.dynastyCBack: Piece.dynastyC,
      Piece.dynastyDBack: Piece.dynastyD,
      Piece.dynastyEBack: Piece.dynastyE,
      Piece.dynastyFBack: Piece.dynastyF,
      Piece.dynastyGBack: Piece.dynastyG,
      Piece.inbreeding: Piece.actionPointsLimit,
      Piece.actionPointsLimit: Piece.inbreeding,
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

  bool landIsNile(Location land) {
    const nileLands = [
      Location.landMenNefer,
      Location.landKhem,
      Location.landZau,
      Location.landPerWadjet,
      Location.landPerBastet,
      Location.landHutwaret,
      Location.landDjanet,
      Location.landIunu,
      Location.landAbdju,
      Location.landShabt,
      Location.landWast,
      Location.landWetjesetHor,
      Location.landSwenet,
      Location.landIrtjet,
      Location.landWawat,
    ];
    return nileLands.contains(land);
  }

  bool landIsDesert(Location land) {
    const deserts = [
      Location.landUsermaatreSetepenre,
      Location.landWaysOfHorus,
      Location.landBekhnu,
      Location.landShabt,
      Location.landDjesdjes,
    ];
    return deserts.contains(land);
  }

  bool landIsCountry(Location land) {
    const countries = [
      Location.countryTjehenu,
      Location.countryRetjenu,
      Location.countryTaNetjer,
      Location.countryTaSeti,
      Location.countryLibu,
    ];
    return countries.contains(land);
  }

  bool landSupportsSepat(Location land, bool allowDesert) {
    if ([Location.landMenNefer, Location.landIrtjet, Location.landWawat].contains(land)) {
        return false;
    }
    if (landIsCountry(land)) {
        return false;
    }
    if (!allowDesert && landIsDesert(land)) {
        return false;
    }
    return true;
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

  bool landIsControlled(Location land) {
    if (land == Location.landMenNefer) {
      return piecesInLocationCount(PieceType.khasti, land) == 0;
    }
    final path = landPath(land)!;
    final locationType = pathLocationType(path);
    if (era == Era.oldKingdom) {
      final troops = pathTroops(path);
      final location = pieceLocation(troops);
      if (!location.isType(locationType)) {
        return false;
      }
      return land.index <= location.index;
    } else {
      final khastiType = pathKhastiType(path);
      final landSequence = land.index - locationType.firstIndex;
      for (int sequence = 0; sequence <= landSequence; ++sequence) {
        final checkLand = Location.values[locationType.firstIndex + sequence];
        if (piecesInLocationCount(khastiType, checkLand) > 0) {
          return false;
        }
        if (piecesInLocationCount(PieceType.rivalDynasty, checkLand) > 0) {
          return false;
        }
      }
      return true;
    }
  }

  // Rise / Decline

  Path? riseDeclineBoxPath(Location location) {
    if (!location.isType(LocationType.pathRiseDeclineBox)) {
      return null;
    }
    return Path.values[location.index - LocationType.pathRiseDeclineBox.firstIndex];
  }

  bool get riseAllPaths {
    return pieceLocation(Piece.rise) == Location.boxRiseDeclineAllPaths;
  }

  bool get declineAllPaths {
    return pieceLocation(Piece.decline) == Location.boxRiseDeclineAllPaths;
  }

  Path? get risePath {
    return riseDeclineBoxPath(pieceLocation(Piece.rise));
  }

  Path? get declinePath {
    return riseDeclineBoxPath(pieceLocation(Piece.decline));
  }

  Path? chariotsBoxPath(Location location) {
    if (!location.isType(LocationType.pathChariotsBox)) {
      return null;
    }
    return Path.values[location.index - LocationType.pathChariotsBox.firstIndex];
  }

  Path? get chariotsPath {
    final chariots = pieceLocation(Piece.heroesChariotsP1) != Location.flipped ? Piece.heroesChariotsP1 : Piece.heroesChariotsP2;
    return chariotsBoxPath(pieceLocation(chariots));
  }

  // Paths

  LocationType pathLocationType(Path path) {
    const pathLocationTypes = {
      Path.tjehenu: LocationType.pathTjehenu,
      Path.retjenu: LocationType.pathRetjenu,
      Path.taNetjer: LocationType.pathTaNetjer,
      Path.taSeti: LocationType.pathTaSeti,
      Path.libu: LocationType.pathLibu,
    };
    return pathLocationTypes[path]!;
  }

  PieceType pathKhastiType(Path path) {
    const pathKhastiTypes = {
      Path.tjehenu: PieceType.khastiTjehenu,
      Path.retjenu: PieceType.khastiRetjenu,
      Path.taNetjer: PieceType.khastiTaNetjer,
      Path.taSeti: PieceType.khastiTaSeti,
      Path.libu: PieceType.khastiLibu,
    };
    return pathKhastiTypes[path]!;
  }

  Location pathSequenceLand(Path path, int sequence) {
    final locationType = pathLocationType(path);
    return Location.values[locationType.firstIndex + sequence];
  }

  Location pathDieLand(Path path, int die) {
    if (die < 6) {
      return pathSequenceLand(path, die - 1);
    }
    return pathHomeCountry(path);
  }

  Location pathHomeCountry(Path path) {
    final locationType = pathLocationType(path);
    return Location.values[locationType.lastIndex - 1];
  }

  Location pathPrevLand(Path path, Location land) {
    final locationType = pathLocationType(path);
    if (land.index == locationType.firstIndex) {
      return Location.landMenNefer;
    }
    return Location.values[land.index - 1];
  }

  Location? pathNextLand(Path path, Location land) {
    final locationType = pathLocationType(path);
    if (land.index + 1 == locationType.lastIndex) {
      return null;
    }
    return Location.values[land.index + 1];
  }

  Location pathRiseDeclineBox(Path path) {
    return Location.values[LocationType.pathRiseDeclineBox.firstIndex + path.index];
  }

  bool pathRise(Path path) {
    if (riseAllPaths) {
      return true;
    }
    if (risePath == path) {
      return true;
    }
    return false;
  }

  bool pathDecline(Path path) {
    if (declineAllPaths) {
      return true;
    }
    if (declinePath == path) {
      return true;
    }
    return false;
  }

  int pathModifier(Path path) {
    if (pathRise(path)) {
      return 1;
    }
    if (pathDecline(path)) {
      return -1;
    }
    return 0;
  }

  bool pathIncludesLocation(Path path, Location location) {
    final locationType = pathLocationType(path);
    return location.index >= locationType.firstIndex && location.index < locationType.lastIndex;
  }

  Piece pathTroops(Path path) {
    return Piece.values[PieceType.medjaiTroops.firstIndex + path.index];
  }

  List<Piece> pathKhastiSequence(Path path) {
    final khastiType = pathKhastiType(path);
    return khastiType.pieces;
  }

  List<Piece> pathKhastiEvolutionSequence(Path path) {
    final wholeSequence = pathKhastiSequence(path);
    final evolutionSequence = <Piece>[];
    for (final khasti in wholeSequence) {
      evolutionSequence.add(khasti);
      if (khasti == Piece.khastiPersia) {
        break;
      }
    }
    return evolutionSequence;
  }

  Piece? pathCurrentKhasti(Path path) {
    final khastiType = pathKhastiType(path);
    for (final khasti in khastiType.pieces) {
      final location = pieceLocation(khasti);
      if (location.isType(LocationType.land)) {
        return khasti;
      }
    }
    return null;
  }

  Piece? pathRivalDynasty(Path path) {
    final locationType = pathLocationType(path);
    for (final rival in PieceType.rivalDynasty.pieces) {
      final location = pieceLocation(rival);
      if (location.isType(locationType)) {
        return rival;
      }
    }
    return null;
  }

  int pathControlledLandCount(Path path) {
    final locationType = pathLocationType(path);
    if (era == Era.oldKingdom) {
      final troops = pathTroops(path);
      final location = pieceLocation(troops);
      if (location.isType(locationType)) {
        return location.index - locationType.firstIndex + 1;
      }
      return 0;
    } else {
      final khastiType = pathKhastiType(path);
      if (piecesInLocationCount(khastiType, Location.landMenNefer) > 0) {
        return 0;
      }
      for (int sequence = 0; sequence < locationType.count; ++sequence) {
        final land = Location.values[locationType.firstIndex + sequence];
        if (piecesInLocationCount(khastiType, land) > 0) {
          return sequence;
        }
        if (piecesInLocationCount(PieceType.rivalDynasty, land) > 0) {
          return sequence;
        }
      }
      return locationType.count;
    }
  }

  bool pathHasTempleToGod(Path path, Piece god) {
    final locationType = pathLocationType(path);
    for (final sepat in PieceType.sepatTempled.pieces) {
      if (templedSepatGod(sepat) == god) {
        final location = pieceLocation(sepat);
        if (location.isType(locationType)) {
          return true;
        }
      }
    }
    if (path == Path.taSeti && god == Piece.godRa && megaprojectBuilt(Piece.megaprojectTempleOfIpetIsut)) {
      return true;
    }
    return false;
  }

  bool pathHasMarriage(Path path) {
    final locationType = pathLocationType(path);
    final location = pieceLocation(Piece.marriage);
    return location.isType(locationType);
  }

  List<Location> get controlledLands {
    final lands = <Location>[];
    if (piecesInLocationCount(PieceType.khasti, Location.landMenNefer) == 0) {
      lands.add(Location.landMenNefer);
    }
    for (final path in Path.values) {
      final locationType = pathLocationType(path);
      if (era == Era.oldKingdom) {
        final troops = pathTroops(path);
        final troopsLocation = pieceLocation(troops);
        if (troopsLocation.isType(locationType)) {
          for (final land in locationType.locations) {
            lands.add(land);
            if (land == troopsLocation) {
              break;
            }
          }
        }
      } else {
        final khastiType = pathKhastiType(path);
        for (final land in locationType.locations) {
          if (piecesInLocationCount(khastiType, land) > 0) {
            break;
          }
          if (piecesInLocationCount(PieceType.rivalDynasty, land) > 0) {
            break;
          }
          lands.add(land);
        }
      }
    }
    return lands;
  }

  // Sepats

  int sepatValue(Piece sepat) {
    const sepatValues = {
      Piece.sepatUntempled0: 3,
      Piece.sepatUntempled1: 4,
      Piece.sepatUntempled2: 4,
      Piece.sepatUntempled3: 3,
      Piece.sepatUntempled4: 3,
      Piece.sepatUntempled5: 2,
      Piece.sepatUntempled6: 3,
      Piece.sepatUntempled7: 4,
      Piece.sepatUntempled8: 4,
      Piece.sepatUntempled9: 2,
      Piece.sepatUntempled10: 4,
      Piece.sepatUntempled11: 2,
      Piece.sepatUntempled12: 3,
      Piece.sepatUntempled13: 3,
      Piece.sepatUntempled14: 3,
      Piece.sepatUntempled15: 4,
      Piece.sepatUntempled16: 2,
      Piece.sepatUntempled17: 2,
      Piece.sepatUntempled18: 2,
      Piece.sepatUntempled19: 2,
      Piece.sepatUntempled20: 3,
      Piece.sepatUntempled21: 4,
      Piece.sepatUntempled22: 4,
      Piece.sepatUntempled23: 3,
      Piece.sepatUntempled24: 4,
    };
    return sepatValues[sepat]!;
  }

  bool sepatAnkh(Piece sepat) {
    const sepatAnkhs = [
      Piece.sepatUntempled9,
      Piece.sepatUntempled12,
      Piece.sepatUntempled18,
      Piece.sepatUntempled19,
      Piece.sepatTempled0,
      Piece.sepatTempled1,
      Piece.sepatTempled2,
      Piece.sepatTempled5,
      Piece.sepatTempled6,
      Piece.sepatTempled8,
      Piece.sepatTempled9,
      Piece.sepatTempled10,
      Piece.sepatTempled11,
      Piece.sepatTempled12,
      Piece.sepatTempled13,
      Piece.sepatTempled14,
      Piece.sepatTempled15,
      Piece.sepatTempled16,
      Piece.sepatTempled17,
      Piece.sepatTempled18,
      Piece.sepatTempled19,
      Piece.sepatTempled20,
      Piece.sepatTempled22,
      Piece.sepatTempled23,
    ];
    return sepatAnkhs.contains(sepat);
  }

  Goods sepatGoods(Piece sepat) {
    const sepatGood = {
      Piece.sepatUntempled0: Goods.grain,
      Piece.sepatUntempled1: Goods.grain,
      Piece.sepatUntempled2: Goods.natron,
      Piece.sepatUntempled3: Goods.granite,
      Piece.sepatUntempled4: Goods.grain,
      Piece.sepatUntempled5: Goods.papyrus,
      Piece.sepatUntempled6: Goods.papyrus,
      Piece.sepatUntempled7: Goods.papyrus,
      Piece.sepatUntempled8: Goods.copper,
      Piece.sepatUntempled9: Goods.limestone,
      Piece.sepatUntempled10: Goods.limestone,
      Piece.sepatUntempled11: Goods.grain,
      Piece.sepatUntempled12: Goods.turquoise,
      Piece.sepatUntempled13: Goods.linen,
      Piece.sepatUntempled14: Goods.beer,
      Piece.sepatUntempled15: Goods.beer,
      Piece.sepatUntempled16: Goods.linen,
      Piece.sepatUntempled17: Goods.turquoise,
      Piece.sepatUntempled18: Goods.beer,
      Piece.sepatUntempled19: Goods.grain,
      Piece.sepatUntempled20: Goods.natron,
      Piece.sepatUntempled21: Goods.linen,
      Piece.sepatUntempled22: Goods.papyrus,
      Piece.sepatUntempled23: Goods.limestone,
      Piece.sepatUntempled24: Goods.iron,
    };
    final untempledSepat = sepat.isType(PieceType.sepatTempled) ? pieceFlipSide(sepat)! : sepat;
    return sepatGood[untempledSepat]!;
  }

  Piece templedSepatGod(Piece sepat) {
    const sepatGods = {
      Piece.sepatTempled0: Piece.godPtah,
      Piece.sepatTempled1: Piece.godIsis,
      Piece.sepatTempled2: Piece.godOsiris,
      Piece.sepatTempled3: Piece.godHorus,
      Piece.sepatTempled4: Piece.godAnubis,
      Piece.sepatTempled5: Piece.godBastet,
      Piece.sepatTempled6: Piece.godRa,
      Piece.sepatTempled7: Piece.godThoth,
      Piece.sepatTempled8: Piece.godThoth,
      Piece.sepatTempled9: Piece.godRa,
      Piece.sepatTempled10: Piece.godBastet,
      Piece.sepatTempled11: Piece.godAnubis,
      Piece.sepatTempled12: Piece.godHorus,
      Piece.sepatTempled13: Piece.godOsiris,
      Piece.sepatTempled14: Piece.godIsis,
      Piece.sepatTempled15: Piece.godPtah,
      Piece.sepatTempled16: Piece.godThoth,
      Piece.sepatTempled17: Piece.godRa,
      Piece.sepatTempled18: Piece.godBastet,
      Piece.sepatTempled19: Piece.godAnubis,
      Piece.sepatTempled20: Piece.godPtah,
      Piece.sepatTempled21: Piece.godIsis,
      Piece.sepatTempled22: Piece.godOsiris,
      Piece.sepatTempled23: Piece.godHorus,
      Piece.sepatTempled24: Piece.godPtah,
    };
    return sepatGods[sepat]!;
  }

  bool templedSepatElite(Piece sepat) {
    const eliteSepats = [
      Piece.sepatTempled1,
      Piece.sepatTempled2,
      Piece.sepatTempled8,
      Piece.sepatTempled10,
      Piece.sepatTempled12,
      Piece.sepatTempled15,
      Piece.sepatTempled18,
      Piece.sepatTempled22,
    ];
    return eliteSepats.contains(sepat);
  }

  void templeSepat(Piece sepat) {
    flipPiece(sepat);
  }

  int controlledTempleToGodCount(Piece god) {
    int count = 0;
    for (final land in controlledLands) {
      final sepat = pieceInLocation(PieceType.sepatTempled, land);
      if (sepat != null) {
        if (templedSepatGod(sepat) == god) {
          count += 1;
        }
      }
    }
    return count;
  }

  bool get haveIronWeapons {
    if (currentTurnDynastyBox.index < Location.dynasty20.index) {
      return false;
    }
    final location = pieceLocation(Piece.sepatTempled24);
    if (!location.isType(LocationType.land)) {
      return false;
    }
    if (!landIsControlled(location)) {
      return false;
    }
    return true;
  }

  // Khastis

  int khastiValue(Piece khasti) {
    const khastiValues = {
      Piece.khastiMeshwesh: 3,
      Piece.khastiCyrene: 2,
      Piece.khastiCanaan: 2,
      Piece.khastiHyksos: 4,
      Piece.khastiMitanni: 2,
      Piece.khastiHittites: 3,
      Piece.khastiSeaPeoples: 4,
      Piece.khastiAssyria: 4,
      Piece.khastiBabylon: 3,
      Piece.khastiPersia: 4,
      Piece.khastiSeleucids: 3,
      Piece.khastiRomans: 4,
      Piece.khastiShasu: 2,
      Piece.khastiNabatu: 3,
      Piece.khastiKerma: 3,
      Piece.khastiKush: 4,
      Piece.khastiMeroe: 3,
      Piece.khastiLibu: 2,
    };
    return khastiValues[khasti]!;
  }

  bool khastiIsBarbarian(Piece khasti) {
    const barbarians = [
      Piece.khastiCanaan,
      Piece.khastiSeaPeoples,
      Piece.khastiAssyria,
      Piece.khastiBabylon,
      Piece.khastiShasu,
      Piece.khastiNabatu,
      Piece.khastiKerma,
      Piece.khastiLibu,
    ];
    return barbarians.contains(khasti);
  }

  Path khastiPath(Piece khasti) {
    for (final path in Path.values) {
      final khastiType = pathKhastiType(path);
      if (khasti.isType(khastiType)) {
        return path;
      }
    }
    return Path.libu;
  }

  // Rival Dynasties

  int rivalDynastyStrength(Piece rivalDynasty) {
    const rivalDynastyStrengths = {
      Piece.rivalDynasty0: 2,
      Piece.rivalDynasty1: 3,
      Piece.rivalDynasty2: 3,
      Piece.rivalDynasty3: 4,
      Piece.rivalDynasty4: 4,
    };
    return rivalDynastyStrengths[rivalDynasty]!;
  }

  // Gods

  Piece? get presidingGod {
    return pieceInLocation(PieceType.god, Location.boxGod);
  }

  bool godHasRise(Piece god) {
    return [Piece.godAnubis, Piece.godRa].contains(god);
  }

  bool godHasDecline(Piece god) {
    return [Piece.godBastet, Piece.godHorus, Piece.godThoth].contains(god);
  }

  bool godHasRevolt(Piece god) {
    return [Piece.godBastet, Piece.godOsiris, Piece.godThoth].contains(god);
  }

  void setPresidingGod(Piece god) {
    final oldGod = presidingGod;
    if (oldGod != null) {
      final oldGodFront = oldGod.isType(PieceType.godFront) ? oldGod : pieceFlipSide(oldGod)!;
      setPieceLocation(oldGodFront, Location.cupGod);
    }
    setPieceLocation(god, Location.boxGod);
  }

  // Megaprojects

  Location megaprojectBox(Piece megaproject) {
    const megaprojectBoxes = {
      Piece.megaprojectGreatPyramids: Location.boxGreatPyramids,
      Piece.megaprojectTempleOfIpetIsut: Location.boxTempleOfIpetIsut,
      Piece.megaprojectValleyOfTheKings: Location.boxValleyOfTheKings,
    };
    return megaprojectBoxes[megaproject]!;
  }

  bool megaprojectBuilt(Piece project) {
    final box = megaprojectBox(project);
    return piecesInLocationCount(PieceType.megaproject, box) > 0;
  }

  // Turns

  int get currentTurn {
    return _turn;
  }

  void advanceTurn() {
    _turn += 1;
  }

  Location turnDynastyTrackBox(int turn) {
    return Location.values[LocationType.dynasty.firstIndex + turn];
  }

  Location get currentTurnDynastyBox {
    return turnDynastyTrackBox(currentTurn);
  }

  Location? get previousTurnDynastyBox {
    if (currentTurn == 0) {
      return null;
    }
    return turnDynastyTrackBox(currentTurn - 1);
  }

  // Dynasty Tiles

  Piece? get currentDynastyTile {
    return pieceInLocation(PieceType.dynasty, currentTurnDynastyBox);
  }

  Piece? get previousDynastyTile {
    final box = previousTurnDynastyBox;
    if (box != null) {
      return pieceInLocation(PieceType.dynasty, box);
    }
    return null;
  }

  void setDynastyTile(Piece dynastyTile) {
    setPieceLocation(dynastyTile, currentTurnDynastyBox);
    var previousTile = previousDynastyTile;
    if (previousTile != null) {
      if (previousTile == Piece.dynastyH) {
        setPieceLocation(previousTile, Location.discarded);
      } else {
        if (!previousTile.isType(PieceType.egyptianDynastyFront)) {
          previousTile = pieceFlipSide(previousTile)!;
        }
        setPieceLocation(previousTile, Location.cupDynasty);
      }
    }
  }

  bool dynastyHasMilitarySkill(Piece? dynastyTile) {
    const militarySkillTiles = [
      Piece.dynastyA,
      Piece.dynastyB,
      Piece.dynastyC,
      Piece.dynastyE,
    ];
    if (dynastyTile == null) {
      return false;
    }
    return militarySkillTiles.contains(dynastyTile);
  }

  bool dynastyHasReligiousSkill(Piece? dynastyTile) {
    const religiousSkillTiles = [
      Piece.dynastyA,
      Piece.dynastyB,
      Piece.dynastyD,
      Piece.dynastyF,
      Piece.dynastyH,
    ];
    if (dynastyTile == null) {
      return false;
    }
    return religiousSkillTiles.contains(dynastyTile);
  }

  bool dynastyHasSocialSkill(Piece? dynastyTile) {
    const socialSkillTiles = [
      Piece.dynastyA,
      Piece.dynastyC,
      Piece.dynastyD,
      Piece.dynastyG,
    ];
    if (dynastyTile == null) {
      return false;
    }
    return socialSkillTiles.contains(dynastyTile);
  }

  bool get haveMilitarySkill {
    return dynastyHasMilitarySkill(currentDynastyTile);
  }

  bool get haveReligiousSkill {
    return dynastyHasReligiousSkill(currentDynastyTile);
  }

  bool get haveSocialSkill {
    return dynastyHasSocialSkill(currentDynastyTile);
  }

  String turnDynastyName(int turn) {
    const dynastyNumbers = [
        '3rd',
        '4th',
        '5th',
        '6th',
        '7th',
        '8th',
        '9th',
        '10th',
        '11th',
        '12th',
        '13th',
        '14th',
        '15th',
        '16th',
        '17th',
        '18th',
        '19th',
        '20th',
        '21st',
        '22nd',
        '23rd',
        '24th',
        '25th',
        '26th',
        '27th',
        '28th',
        '29th',
        '30th',
        '31st',
        '32nd',
        '33rd',
        '34th',
        '35th',
        '36th',
        '37th',
        '38th',
    ];
    return '${dynastyNumbers[turn]} Dynasty';
  }

  List<Path> turnKhastiEvolutionPaths(int turn) {
    const turnPaths = {
      11: [Path.retjenu],
      12: [Path.retjenu],
      13: [Path.retjenu],
      14: [Path.retjenu],
      15: [Path.retjenu],
      16: [Path.retjenu, Path.taNetjer],
      17: [Path.retjenu, Path.taNetjer, Path.taSeti],
      18: [Path.retjenu, Path.taNetjer, Path.taSeti],
      19: [Path.retjenu, Path.taSeti],
      20: [Path.taNetjer],
      22: [Path.tjehenu, Path.retjenu, Path.taSeti],
      23: [Path.tjehenu, Path.retjenu, Path.taSeti],
      24: [Path.tjehenu, Path.retjenu, Path.taSeti],
      25: [Path.retjenu],
      26: [Path.tjehenu],
      27: [Path.retjenu, Path.taSeti],
      28: [Path.retjenu],
      30: [Path.retjenu],
    };
    var paths = turnPaths[turn];
    return paths ?? <Path>[];
  }

  List<Path> manethoKhastiAdvancePaths(int manethoTotal) {
    const advancePaths = {
      15: [Path.retjenu],
      16: [Path.retjenu, Path.tjehenu, Path.taSeti],
      17: [Path.taSeti],
      18: [Path.libu, Path.libu],
      19: [Path.taNetjer, Path.taSeti],
      20: [Path.tjehenu, Path.taSeti],
      21: [Path.taNetjer],
      22: [Path.retjenu, Path.libu, Path.taNetjer, Path.taSeti],
      23: [Path.retjenu, Path.tjehenu, Path.taSeti],
      24: [Path.retjenu, Path.taNetjer, Path.tjehenu],
      25: [Path.libu],
      26: [Path.libu, Path.libu, Path.tjehenu],
      27: [Path.retjenu, Path.retjenu, Path.tjehenu],
      28: [Path.taSeti, Path.taSeti],
      29: [Path.retjenu, Path.retjenu, Path.taSeti],
      30: [Path.retjenu, Path.taSeti],
      31: [Path.retjenu, Path.libu, Path.libu, Path.taNetjer],
      32: [Path.libu, Path.tjehenu],
      33: [Path.retjenu],
      34: [Path.taNetjer, Path.taSeti],
      35: [Path.retjenu, Path.taNetjer, Path.taNetjer],
      36: [Path.retjenu, Path.retjenu, Path.taNetjer, Path.taSeti, Path.taSeti],
      37: [Path.retjenu, Path.retjenu, Path.taSeti],
      38: [Path.taNetjer, Path.retjenu, Path.retjenu, Path.tjehenu, Path.tjehenu],
      39: [Path.retjenu, Path.libu, Path.taNetjer, Path.taSeti],
    };
    var paths = advancePaths[manethoTotal];
    return paths ?? <Path>[];
  }

  Era get era {
    if (currentTurn < 8) {
      return Era.oldKingdom;
    } else if (currentTurn < 15) {
      return Era.middleKingdom;
    } else if (currentTurn < 23) {
      return Era.newKingdom;
    } else {
      return Era.latePeriod;
    }
  }

  Piece eraPiece(Era era) {
    return Piece.values[PieceType.era.firstIndex + era.index];
  }

  // Goods

  List<Goods> tradeGoods(int dice) {
    const tradeGoodsTable = [
      [Goods.beer, Goods.papyrus, Goods.grain],
      [Goods.copper, Goods.natron, Goods.papyrus],
      [Goods.linen, Goods.limestone, Goods.grain],
      [Goods.granite, Goods.turquoise, Goods.beer],
      [Goods.copper, Goods.natron, Goods.beer, Goods.grain],
      [Goods.granite, Goods.copper, Goods.turquoise, Goods.linen],
      [Goods.natron, Goods.turquoise, Goods.limestone, Goods.papyrus],
      [Goods.granite, Goods.copper, Goods.linen, Goods.limestone],
      [Goods.granite, Goods.natron, Goods.linen, Goods.beer, Goods.papyrus],
      [Goods.granite, Goods.copper, Goods.turquoise, Goods.natron, Goods.limestone],
      [Goods.turquoise, Goods.limestone, Goods.beer, Goods.papyrus, Goods.grain],
    ];
    return tradeGoodsTable[dice - 2];
  }

  bool goodsAccessible(Goods goods) {
    int untempledCount = 0;
    for (final path in Path.values) {
      int landCount = pathControlledLandCount(path);
      for (int sequence = 0; sequence < landCount; ++sequence) {
        final land = pathSequenceLand(path, sequence);
        final sepat = pieceInLocation(PieceType.sepat, land);
        if (sepat != null) {
          if (sepatGoods(sepat) == goods) {
            if (sepat.isType(PieceType.sepatTempled)) {
              return true;
            } else {
              untempledCount += 1;
              if (untempledCount >= 2) {
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }

  // Pharaoh

  bool get pharaohAvailable {
    return pieceLocation(Piece.pharaoh) == Location.landMenNefer;
  }

  set pharaohAvailable(bool available) {
    setPieceLocation(Piece.pharaoh, available ? Location.landMenNefer : Location.boxPharaohUnavailable);
  }

  // Greek Mercenaries

  bool get greekMercenariesAvailable {
    return piecesInLocationCount(PieceType.greeks, Location.landMenNefer) > 0;
  }

  // Action Points / Gold

  Location granaryBox(int value) {
    return Location.values[Location.granary0.index + value];
  }

  int get actionPoints {
    return pieceLocation(Piece.actionPoints).index - Location.granary0.index;
  }

  int get actionPointLimit {
    final location = pieceLocation(Piece.inbreeding);
    if (location.isType(LocationType.granary)) {
      return location.index - Location.granary0.index;
    }
    return 9;
  }

  void adjustActionPoints(int delta) {
    int newValue = actionPoints + delta;
    if (newValue < 0) {
        newValue = 0;
    }
    int limit = actionPointLimit;
    if (newValue > limit) {
      newValue = limit;
    }
    setPieceLocation(Piece.actionPoints, granaryBox(newValue));
  }

  int get gold {
    return pieceLocation(Piece.gold).index - Location.granary0.index;
  }

  void adjustGold(int delta) {
    int newValue = gold + delta;
    if (newValue < 0) {
      newValue = 0;
    }
    if (newValue > 9) {
      newValue = 9;
    }
    setPieceLocation(Piece.gold, granaryBox(newValue));
  }

  int get actionPointsAndGold {
    return actionPoints + gold;
  }

  // Roman Debt

  int get romanDebt {
    final location = pieceLocation(Piece.romanDebt);
    if (location.isType(LocationType.dynasty)) {
      return location.index - Location.dynasty3.index + 3;
    }
    return 0;
  }

  void adjustRomanDebt(int delta) {
    int newValue = romanDebt + delta;
    if (newValue < 3) {
      newValue = 0;
    }
    if (newValue > 38) {
      newValue = 38;
    }
    if (newValue == 0) {
      setPieceLocation(pieceFlipSide(Piece.romanDebt)!, Location.trayEra);
    } else {
      setPieceLocation(Piece.romanDebt, Location.values[Location.dynasty3.index + newValue - 3]);
    }
  }

  // Literacy

  Location get literacy {
    return pieceLocation(Piece.literacy);
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

  factory GameState.setupCounterTray() {
    var state = GameState();

    state.setupPieceTypes([
      (PieceType.sepatUntempled, Location.traySepat),
      (PieceType.wallsOfTheRuler, Location.trayMilitary),
      (PieceType.medjaiTroops, Location.trayMilitary),
      (PieceType.egyptianDynastyFront, Location.trayDynasty),
      (PieceType.revival, Location.trayRevival),
      (PieceType.egyptianRule, Location.trayPolitical),
      (PieceType.maatUnused, Location.trayPolitical),
      (PieceType.megaprojectUnlooted, Location.trayPolitical),
      (PieceType.godFront, Location.trayGods),
      (PieceType.era, Location.trayEra),
    ]);

    state.setupPieces([
        (Piece.medjaiPolice, Location.trayMilitary),
        (Piece.heroesChariotsP1, Location.trayMilitary),
        (Piece.heroesNubianArchers, Location.trayMilitary),
        (Piece.heroesMeraFleet, Location.trayMilitary),
        (Piece.israel0, Location.trayMilitary),
        (Piece.khastiCanaan, Location.trayRetjenu),
        (Piece.khastiHittites, Location.trayRetjenu),
        (Piece.khastiAssyria, Location.trayRetjenu),
        (Piece.khastiPersia, Location.trayRetjenu),
        (Piece.khastiRomans, Location.trayRetjenu),
        (Piece.khastiLibu, Location.trayLibu),
        (Piece.khastiShasu, Location.trayLibu),
        (Piece.khastiMeshwesh, Location.trayLibu),
        (Piece.pharaoh, Location.trayPolitical),
        (Piece.marriage, Location.trayPolitical),
        (Piece.actionPoints, Location.trayEconomic),
        (Piece.literacy, Location.trayEconomic),
        (Piece.gold, Location.trayEconomic),
        (Piece.alexandria, Location.trayEconomic),
        (Piece.highPriests, Location.trayEconomic),
        (Piece.inbreeding, Location.trayEconomic),
        (Piece.rise, Location.trayEconomic),
        (Piece.jews, Location.trayPeople),
        (Piece.greeks, Location.trayPeople),
        (Piece.hebrewPeople, Location.trayPeople),
        (Piece.libyanMigrants, Location.trayPeople),
        (Piece.khastiKerma, Location.trayKerma),
        (Piece.khastiKush, Location.trayKerma),
    ]);

    return state;
  }

  factory GameState.setupStandard(GameOptions options, Random random) {

    var state = GameState.setupCounterTray();

    final sepatPieceType = options.latePeriodIron ? PieceType.sepatUntempled : PieceType.sepatUntempledRandom;
    state.setupPieceType(sepatPieceType, Location.cupSepat);
    final sepats = sepatPieceType.pieces;
    sepats.shuffle(random);

    state.setupPieceTypes([
      (PieceType.egyptianDynastyFront, Location.cupDynasty),
      (PieceType.godFront, Location.cupGod),
    ]);

    state.setupPieces([
      (Piece.eraOldKingdom, Location.boxEra),
      (Piece.eraMiddleKingdom, Location.dynasty11),
      (Piece.eraNewKingdom, Location.dynasty18),
      (Piece.eraLatePeriod, Location.dynasty26),
      (Piece.literacy, Location.literacyHieroglyphic),
      (Piece.dynastyA, Location.dynasty3),
      (Piece.actionPoints, Location.granary1),
      (Piece.gold, Location.granary1),
      (Piece.pharaoh, Location.landMenNefer),
      (sepats[0], Location.landKhem),
      (sepats[1], Location.landPerBastet),
      (sepats[2], Location.landIunu),
      (sepats[3], Location.landAbdju),
      (sepats[4], Location.landPayomLakes),
      (Piece.rise, Location.boxRiseDeclineNone),
    ]);

    return state;
  }
}

enum Choice {
  dynastyE,
  dynastyF,
  dynastyG,
  blockAdvanceRevival,
  blockAdvanceMarriage,
  blockAdvanceGreekMercenaries,
  blockAdvanceEgyptianRule,
  blockAdvancePharaoh,
  blockAdvanceWalls,
  blockAdvanceNubianArchers,
  blockAdvanceMeraFleet,
  blockAdvanceRivalCapital,
  blockAdvanceRivalMilitia,
  blockAdvanceMilitia,
  blockAdvanceCede,
  buildTroops,
  templeSepat,
  templeSepatReligiousSkill,
  templeSepatPtah,
  templeSepatPharaoh,
  templeSepatMaat,
  colonize,
  buildMegaproject,
  hireMedjaiPolice,
  buildWallsOfTheRuler,
  buildNubianArchers,
  buildMeraFleet,
  moveNubianArchers,
  moveMeraFleet,
  buyMaat,
  undermineRivalDynasty,
  boostMorale,
  marriage,
  reorientIsrael,
  suppressHighPriests,
  advanceLiteracy,
  withdrawFromCountry,
  hebrewIncome,
  alexandriaIncome,
  socialSkillIncome,
  lootMegaproject,
  plunderGreeks,
  plunderJews,
  borrowFromRome,
  attack,
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
  defeatMenNefer,
  romeMenNefer,
  survival,
}

class GameOutcome {
  GameResult result;
  int survivalPoints;

  GameOutcome(this.result, this.survivalPoints);

  GameOutcome.fromJson(Map<String, dynamic> json) :
    result = GameResult.values[json['result'] as int],
    survivalPoints = json['survivalPoints'] as int;
  
  Map<String, dynamic> toJson() => {
    'result': result.index,
    'survivalPoints': survivalPoints,
  };
}

class GameOverException implements Exception {
  GameOutcome outcome;

  GameOverException(GameResult result, int survivalPoints) : outcome = GameOutcome(result, survivalPoints);
}

enum Phase {
  nile,
  god,
  khastiEvolution,
  cleopatra,
  action,
  endOfTurn,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateNile extends PhaseState {
  int actionPoints = 0;
  int? high;
  int? mid;
  int? low;

  PhaseStateNile();

  PhaseStateNile.fromJson(Map<String, dynamic> json) {
    actionPoints = json['actionPoints'] as int;
    high = json['high'] as int?;
    mid = json['mid'] as int?;
    low = json['low'] as int?;
  }

  @override
  Map<String, dynamic> toJson() => {
    'actionPoints': actionPoints,
    'high': high,
    'mid': mid,
    'low': low,
  };

  @override
  Phase get phase {
    return Phase.nile;
  }
}

class PhaseStateGod extends PhaseState {
  Path? revoltPath;
  Location? revoltLand;
  Choice? attackChoice;

  PhaseStateGod();

  PhaseStateGod.fromJson(Map<String, dynamic> json) {
    revoltPath = pathFromIndex(json['revoltPath'] as int?);
    revoltLand = locationFromIndex(json['revoltLand'] as int?);
    attackChoice = choiceFromIndex(json['attackChoice'] as int?);
  }

  @override
  Map<String, dynamic> toJson() => {
    'revoltPath': pathToIndex(revoltPath),
    'revoltLand': locationToIndex(revoltLand),
    'attackChoice': choiceToIndex(attackChoice),
  };

  @override
  Phase get phase {
    return Phase.god;
  }
}

class PhaseStateKhastiEvolution extends PhaseState {
  List<bool> evolved = [false, false, false];

  PhaseStateKhastiEvolution();

  PhaseStateKhastiEvolution.fromJson(Map<String, dynamic> json) {
    evolved = List<bool>.from(json['evolved']);
  }

  @override
  Map<String, dynamic> toJson() => {
    'evolved': evolved,
  };

  @override
  Phase get phase {
    return Phase.khastiEvolution;
  }
}

class PhaseStateCleopatra extends PhaseState {
  int romanAttacksRemainingCount;

  PhaseStateCleopatra(this.romanAttacksRemainingCount);

  PhaseStateCleopatra.fromJson(Map<String, dynamic> json) :
    romanAttacksRemainingCount = json['romanAttacksRemaningCount'] as int;
  
  @override
  Map<String, dynamic> toJson() => {
    'romanAttacksRemainingCount': romanAttacksRemainingCount,
  };

  @override
  Phase get phase {
    return Phase.cleopatra;
  }
}

class PhaseStateAction extends PhaseState {
  Location? selectedLand;
  Piece? selectedPiece;
  Piece? drawnSepat;
  bool templeSepatUseReligiousSkill = false;
  bool templeSepatUsePtah = false;
  bool templeSepatUsePharaoh = false;
  bool templeSepatUseMaat = false;
  bool militarySkill = false;
  bool religiousSkill = false;
  bool socialSkill = false;
  bool ptahBonus = false;
  bool nubianArchersMoved = false;
  bool meraFleetMoved = false;
  bool hebrewIncome = false;
  bool alexandriaIncome = false;
  bool megaprojectLooted = false;
  List<Piece> attackPieces = <Piece>[];

  PhaseStateAction();

  PhaseStateAction.fromJson(Map<String, dynamic> json) {
    selectedLand = locationFromIndex(json['selectedLand'] as int?);
    selectedPiece = pieceFromIndex(json['selectedPiece'] as int?);
    drawnSepat = pieceFromIndex(json['drawnSepat'] as int?);
    templeSepatUseReligiousSkill = json['templeSepatUseReligiousSkill'] as bool;
    templeSepatUsePtah = json['templeSepatUsePtah'] as bool;
    templeSepatUsePharaoh = json['templeSepatUsePharaoh'] as bool;
    templeSepatUseMaat = json['templeSepatUseMaat'] as bool;
    militarySkill = json['militarySkill'] as bool;
    religiousSkill = json['religiousSkill'] as bool;
    socialSkill = json['socialSkill'] as bool;
    ptahBonus = json['ptahBonus'] as bool;
    nubianArchersMoved = json['nubianArchersMoved'] as bool;
    meraFleetMoved = json['meraFleetMoved'] as bool;
    hebrewIncome = json['hebrewIncome'] as bool;
    alexandriaIncome = json['alexandriaIncome'] as bool;
    megaprojectLooted = json['megaprojectLooted'] as bool;
    attackPieces = pieceListFromIndices(List<int>.from(json['attackPieces']));
  }

  @override
  Map<String, dynamic> toJson() => {
    'selectedLand': locationToIndex(selectedLand),
    'selectedPiece': pieceToIndex(selectedPiece),
    'drawnSepat': pieceToIndex(drawnSepat),
    'templeSepatUseReligiousSkill': templeSepatUseReligiousSkill,
    'templeSepatUsePtah': templeSepatUsePtah,
    'templeSepatUsePharaoh': templeSepatUsePharaoh,
    'templeSepatUseMaat': templeSepatUseMaat,
    'militarySkill': militarySkill,
    'religiousSkill': religiousSkill,
    'socialSkill': socialSkill,
    'ptahBonus': ptahBonus,
    'nubianArchersMoved': nubianArchersMoved,
    'meraFleetMoved': meraFleetMoved,
    'hebrewIncome': hebrewIncome,
    'alexandriaIncome': alexandriaIncome,
    'megaprojectLooted': megaprojectLooted,
    'attackPieces': pieceListToIndices(attackPieces),
  };

  @override
  Phase get phase {
    return Phase.action;
  }
}

class PhaseStateEndOfTurn extends PhaseState {
  List<Piece> degradeSepats = <Piece>[];

  PhaseStateEndOfTurn();

  PhaseStateEndOfTurn.fromJson(Map<String, dynamic> json) {
    degradeSepats = pieceListFromIndices(List<int>.from(json['degradeSepats']));
  }

  @override
  Map<String, dynamic> toJson() => {
    'degradeSepats': pieceListToIndices(degradeSepats),
  };

  @override
  Phase get phase {
    return Phase.endOfTurn;
  }
}

class IsisRerollState {
  int? d6;

  IsisRerollState();

  IsisRerollState.fromJson(Map<String, dynamic> json) {
    d6 = json['d6'] as int?;
  }

  Map<String, dynamic> toJson() => {
    'd6': d6
  };
}

class KhastiAdvanceState {
  int subStep = 0;
  int marriageAPAmount = 0;
  bool militiaUsed = false;
  Choice? attackChoice;

  KhastiAdvanceState();

  KhastiAdvanceState.fromJson(Map<String, dynamic> json) {
    subStep = json['subStep'] as int;
    marriageAPAmount = json['marriageAPAmount'] as int;
    militiaUsed = json['militiaUsed'] as bool;
    attackChoice = choiceFromIndex(json['attackChoice'] as int?);
  }

  Map<String, dynamic> toJson() => {
    'subStep': subStep,
    'marriageAPAmount': marriageAPAmount,
    'militiaUsed': militiaUsed,
    'attackChoice': choiceToIndex(attackChoice),
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
  PhaseState? _phaseState;
  IsisRerollState? _isisRerollState;
  KhastiAdvanceState? _khastiAdvanceState;
  final Random _random;
  final int _gameId;

  Game(this._gameId, this._scenario, this._options, this._state, this._random);

  Game.saved(this._gameId, this._scenario, this._options, this._state, this._step, this._subStep, this._log, Map<String, dynamic> gameStateJson)
  : _random = Random()
  {
    _gameStateFromJson(gameStateJson);
  }

  Game.completed(this._gameId, this._scenario, this._options, this._state, this._step, this._subStep, this._log, Map<String, dynamic> gameOutcomeJson)
  : _random = Random()
  , _outcome = GameOutcome.fromJson(gameOutcomeJson);

  void _gameStateFromJson(Map<String, dynamic> json) {
    _phaseState = null;
    final phaseIndex = json['phase'] as int?;
    if (phaseIndex != null) {
      final phaseStateJson = json['phaseState'];
      switch (Phase.values[phaseIndex]) {
      case Phase.nile:
        _phaseState = PhaseStateNile.fromJson(phaseStateJson);
      case Phase.god:
        _phaseState = PhaseStateGod.fromJson(phaseStateJson);
      case Phase.khastiEvolution:
        _phaseState = PhaseStateKhastiEvolution.fromJson(phaseStateJson);
      case Phase.cleopatra:
        _phaseState = PhaseStateCleopatra.fromJson(phaseStateJson);
      case Phase.action:
        _phaseState = PhaseStateAction.fromJson(phaseStateJson);
      case Phase.endOfTurn:
        _phaseState = PhaseStateEndOfTurn.fromJson(phaseStateJson);
      }
    }

    final isisRerollStateJson = json['isisReroll'];
    if (isisRerollStateJson != null) {
      _isisRerollState = IsisRerollState.fromJson(isisRerollStateJson);
    }
    final khastiAdvanceStateJson = json['khastiAdvance'];
    if (khastiAdvanceStateJson != null) {
      _khastiAdvanceState = KhastiAdvanceState.fromJson(khastiAdvanceStateJson);
    }

    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
    if (_phaseState != null) {
      map['phase'] = _phaseState!.phase.index;
      map['phaseState'] = _phaseState!.toJson();
    }
    if (_isisRerollState != null) {
      map['isisReroll'] = _isisRerollState!.toJson();
    }
    if (_khastiAdvanceState != null) {
      map['khastiAdvance'] = _khastiAdvanceState!.toJson();
    }
    map['choiceInfo'] = _choiceInfo.toJson();
    return map;
  }

  Future<void> saveSnapshot() async {
    await GameDatabase.instance.appendGameSnapshot(
      _gameId,
      jsonEncode(_state.toJson()),
      _step, _subStep,
      _state.turnDynastyName(_state.currentTurn),
      _log);
  }

  Future<void> saveCurrentState() async {
    await GameDatabase.instance.setGameState(
      _gameId,
      jsonEncode(_state.toJson()),
      _step, _subStep,
      _state.turnDynastyName(_state.currentTurn),
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

  Piece drawSepat() {
    final sepats = _state.piecesInLocation(PieceType.sepatUntempled, Location.cupSepat);
    return randPiece(sepats)!;
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

  void discoverSepat(Location land, Piece sepat) {
    final goods = _state.sepatGoods(sepat);
    logLine('> ${goods.desc} is discovered in ${land.desc}.');
    _state.setPieceLocation(sepat, land);
  }

  void templeSepat(Location land, Piece sepat) {
    _state.templeSepat(sepat);
    final templedSepat = _state.pieceInLocation(PieceType.sepatTempled, land)!;
    logLine('> A Temple dedicated to ${_state.templedSepatGod(templedSepat).desc} is built at ${land.desc}.');
  }

  void adjustActionPoints(int delta) {
    _state.adjustActionPoints(delta);
    if (delta > 0) {
      logLine('> AP: +$delta => ${_state.actionPoints}');
    } else if (delta < 0) {
      logLine('> AP: $delta => ${_state.actionPoints}');
    }
  }

  void adjustGold(int delta) {
    _state.adjustGold(delta);
    if (delta > 0) {
      logLine('> Gold: +$delta => ${_state.gold}');
    } else if (delta < 0) {
      logLine('> Gold: $delta => ${_state.gold}');
    }
  }

  void spendActionPoints(int amount) {
    int ap = -min(amount, _state.actionPoints);
    adjustActionPoints(ap);
    int gold = -(amount + ap);
    if (gold < 0) {
      adjustGold(gold);
    }
  }

  void spendGold(int amount) {
    adjustGold(-amount);
  }

  void adjustRomanDebt(int delta) {
    _state.adjustRomanDebt(delta);
    if (delta > 0) {
      logLine('> Roman Debt: +$delta => ${_state.romanDebt}');
    } else if (delta < 0) {
      logLine('> Roman Debt: $delta => ${_state.romanDebt}');
    }
  }

  // High Level Functions

  List<Piece> templeSepatCandidates(int budget) {
    final candidates = <Piece>[];
    for (final path in Path.values) {
      final modifier = _state.pathModifier(path);
      int landCount = _state.pathControlledLandCount(path);
      for (int sequence = 0; sequence < landCount; ++sequence) {
        final land = _state.pathSequenceLand(path, sequence);
        final sepat = _state.pieceInLocation(PieceType.sepatUntempled, land);
        if (sepat != null) {
          int cost = _state.sepatValue(sepat);
          cost += modifier;
          if (cost <= budget) {
            candidates.add(sepat);
          }
        }
      }
    }
    return candidates;
  }

  List<Piece> templeSepatPtahCandidates(int budget) {
    List<Path> paths = <Path>[];
    int ptahTempleCountMax = 0;
    for (final path in Path.values) {
      final locationType = _state.pathLocationType(path);
      int ptahTempleCount = 0;
      for (final land in locationType.locations) {
        final sepat = _state.pieceInLocation(PieceType.sepatTempled, land);
        if (sepat != null && _state.templedSepatGod(sepat) == Piece.godPtah) {
          ptahTempleCount += 1;
        }
      }
      if (ptahTempleCount > ptahTempleCountMax) {
        ptahTempleCountMax = ptahTempleCount;
        paths = [path];
      } else if (ptahTempleCount > 0 && ptahTempleCount == ptahTempleCountMax) {
        paths.add(path);
      }
    }
    final candidates = <Piece>[];
    for (final path in paths) {
      int landCount = _state.pathControlledLandCount(path);
      for (int sequence = 0; sequence < landCount; ++sequence) {
        final land = _state.pathSequenceLand(path, sequence);
        final sepat = _state.pieceInLocation(PieceType.sepatUntempled, land);
        if (sepat != null) {
          int cost = 1;
          final templedSepat = _state.pieceFlipSide(sepat)!;
          if (_state.templedSepatGod(templedSepat) == Piece.godPtah) {
            cost = 0;
          }
          if (cost <= budget) {
            candidates.add(sepat);
          }
        }
      }
    }
    return candidates;
  }

  List<Location> get colonizeCandidates {
    final candidates = <Location>[];
    for (final path in Path.values) {
      int landCount = _state.pathControlledLandCount(path);
      for (int sequence = 0; sequence < landCount; ++sequence) {
        final land = _state.pathSequenceLand(path, sequence);
        if (![Location.landIrtjet, Location.landWawat].contains(land)) {
          if (_state.piecesInLocationCount(PieceType.sepat, land) == 0) {
            candidates.add(land);
          }
        }
      }
    }
    return candidates;
  }

  List<Location> get wallsOfTheRulerCandidates {
    final candidates = <Location>[];
    for (final path in Path.values) {
      int landCount = _state.pathControlledLandCount(path);
      for (int sequence = 0; sequence < landCount; ++sequence) {
        final land = _state.pathSequenceLand(path, sequence);
        if (_state.piecesInLocationCount(PieceType.wallsOfTheRuler, land) == 0) {
          candidates.add(land);
        }
      }
    }
    return candidates;
  }

  List<Location> moveNubianArchersCandidates(int budget) {
    final currentLocation = _state.pieceLocation(Piece.heroesNubianArchers);
    final candidates = <Location>[];
    if (budget >= 3) {
      if (currentLocation != Location.landMenNefer) {
        candidates.add(Location.landMenNefer);
      }
    }
    if (budget >= 1) {
      for (final path in Path.values) {
        int landCount = _state.pathControlledLandCount(path);
        for (int sequence = 0; sequence < landCount; ++sequence) {
          final land = _state.pathSequenceLand(path, sequence);
          if (currentLocation != land) {
            candidates.add(land);
          }
        }
      }
    }
    return candidates;
  }

  List<Location> moveMeraFleetCandidates(int budget) {
    final currentLocation = _state.pieceLocation(Piece.heroesNubianArchers);
    int baseCost = currentLocation == Location.boxHeroes && !_state.landIsControlled(Location.landSharuhen) ? 2 : 1;
    final candidates = <Location>[];
    if (budget >= baseCost + 2) {
      if (currentLocation != Location.landMenNefer) {
        candidates.add(Location.landMenNefer);
      }
    }
    if (budget >= baseCost) {
      for (final path in Path.values) {
        int landCount = _state.pathControlledLandCount(path);
        for (int sequence = 0; sequence < landCount; ++sequence) {
          final land = _state.pathSequenceLand(path, sequence);
          if (_state.landIsNile(land) && currentLocation != land) {
            candidates.add(land);
          }
        }
      }
    }
    return candidates;
  }

  List<Location> get withdrawFromCountryCandidates {
    final candidates = <Location>[];
    for (final egyptianRule in PieceType.egyptianRule.pieces) {
      final location = _state.pieceLocation(egyptianRule);
      if (location.isType(LocationType.land)) {
        candidates.add(location);
      }
    }
    return candidates;
  }

  List<Piece> get undermineRivalDynastyCandidates {
    final candidates = <Piece>[];
    for (final rivalDynasty in PieceType.rivalDynasty.pieces) {
      final location = _state.pieceLocation(rivalDynasty);
      if (location.isType(LocationType.land) && _state.landIsNile(location)) {
        candidates.add(rivalDynasty);
      }
    }
    return candidates;
  }

  List<Piece> get boostMoraleCandidates {
    final candidates = <Piece>[];
    for (final sepat in PieceType.sepat.pieces) {
      final location = _state.pieceLocation(sepat);
      if (location.isType(LocationType.land) && _state.landIsNile(location)) {
        candidates.add(sepat);
      }
    }
    return candidates;
  }

  List<Piece> get lootMegaprojectCandidates {
    final candidates = <Piece>[];
    for (final megaproject in PieceType.megaprojectUnlooted.pieces) {
      if (_state.pieceLocation(megaproject).isType(LocationType.megaprojectBox)) {
        if (megaproject == Piece.megaprojectGreatPyramids || _state.landIsControlled(Location.landWast)) {
          candidates.add(megaproject);
        }
      }
    }
    return candidates;
  }

  List<Location> heroRelocationCandidates(Piece hero) {
    final candidates = <Location>[];
    for (final path in Path.values) {
      int controlledLandCount = _state.pathControlledLandCount(path);
      for (int sequence = 0; sequence < controlledLandCount; ++sequence) {
        final land = _state.pathSequenceLand(path, sequence);
        if (hero != Piece.heroesMeraFleet || _state.landIsNile(land)) {
          candidates.add(land);
        }
      }
    }
    return candidates;
  }

  int calculateSurvivalPoints() {
    logLine('### Survival Points');
    int total = 0;
    int templedSepatCount = 0;
    for (final path in Path.values) {
      int landCount = _state.pathControlledLandCount(path);
      logLine('> ${path.desc}: $landCount');
      total += landCount;
      for (int sequence = 0; sequence < landCount; ++sequence) {
        final land = _state.pathSequenceLand(path, sequence);
        if (_state.piecesInLocationCount(PieceType.sepatTempled, land) > 0) {
          templedSepatCount += 1;
        }
      }
    }
    for (final path in Path.values) {
      final country = _state.pathHomeCountry(path);
      if (_state.piecesInLocationCount(PieceType.egyptianRule, country) > 0) {
        logLine('> Egyptian Rule in ${country.desc}: 5');
        total += 5;
      }
    }
    if (templedSepatCount > 0) {
      logLine('> Templed Sepats: $templedSepatCount');
      total += templedSepatCount;
    }
    for (final box in LocationType.megaprojectBox.locations) {
      final megaproject = _state.pieceInLocation(PieceType.megaproject, box);
      if (megaproject != null) {
        int megaprojectValue = megaproject.isType(PieceType.megaprojectUnlooted) ? 5 : 2;
        logLine('> ${megaproject.desc}: $megaprojectValue');
        total += megaprojectValue;
      }
    }
    for (final piece in [Piece.greeks, Piece.jews]) {
      if (_state.pieceLocation(piece) == Location.landMenNefer) {
        logLine('> ${piece.desc}: 3');
        total += 3;
      }
    }
    if (_state.pieceLocation(Piece.literacy) == Location.literacyCoptic) {
      logLine('> Coptic Literacy: 5');
      total += 5;
    }
    if (_state.actionPoints > 0) {
      int actionPointsValue = 2 * _state.actionPoints;
      logLine('> Action Points: $actionPointsValue');
      total += actionPointsValue;
    }
    if (_state.gold > 0) {
      int goldValue = 2 * _state.gold;
      logLine('> Gold: $goldValue');
      total += goldValue;
    }
    final inbreeding = _state.pieceLocation(Piece.inbreeding);
    if (inbreeding.isType(LocationType.granary)) {
      int inbreedingValue = inbreeding.index - Location.granary0.index;
      logLine('> Inbreeding: $inbreedingValue');
      total += inbreedingValue;
    }
    int maatCount = 2 - _state.piecesInLocationCount(PieceType.maatUnused, Location.trayPolitical);
    if (maatCount > 0) {
      int maatValue = 2 * maatCount;
      logLine('> Maʼat Tiles: $maatValue');
      total += maatValue;
    }
    int revivalCount = _state.piecesInLocationCount(PieceType.revival, Location.boxRevival);
    if (revivalCount > 0) {
      int revivalValue = 7 * revivalCount;
      logLine('> Revival Chits: $revivalValue');
      total += revivalValue;
    }
    return total;
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
  }

  // Sequence Helpers

  Piece drawSepatForLand(Location land) {
    Piece? sepat;
    if (land == Location.landWast) {
      if (choicesEmpty()) {
        setPrompt('Choose Sepat for Wast');
        for (int i = 0; i < 3; ++i) {
          final sepat = randPiece(_state.piecesInLocation(PieceType.sepatUntempled, Location.cupSepat))!;
          _state.setPieceLocation(sepat, Location.values[Location.boxWastSepat0.index + i]);
          pieceChoosable(sepat);
        }
        throw PlayerChoiceException();
      }
      sepat = selectedPiece()!;
      for (int i = 0; i < 3; ++i) {
        final wastSepat = _state.pieceInLocation(PieceType.sepatUntempled, Location.values[Location.boxWastSepat0.index + i])!;
        _state.setPieceLocation(wastSepat, Location.cupSepat);
      }
      clearChoices();
    } else {
      sepat = drawSepat();
    }
    return sepat;
  }

  int isisRollD6() {
    if (_isisRerollState == null) {
      _isisRerollState = IsisRerollState();
      _isisRerollState!.d6 = rollD6();
    }
    final localState = _isisRerollState!;
    while (true) {
      if (choicesEmpty()) {
        final die = localState.d6!;
        if (_state.presidingGod != Piece.godIsis || _state.isisRerollCount >= _state.controlledTempleToGodCount(Piece.godIsis)) {
          _isisRerollState = null;
          return die;
        }
        if (_state.actionPointsAndGold < 2) {
          _isisRerollState = null;
          return die;
        }
        setPrompt('Reroll die?');
        choiceChoosable(Choice.yes, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.no)) {
        final die = localState.d6!;
        _isisRerollState = null;
        return die;
      }
      clearChoices();
      _state.isisRerollCount += 1;
      logLine('> Isis intervenes.');
      spendActionPoints(2);
      localState.d6 = rollD6();
    }
  }

  int isisRoll2D6() {
    if (_isisRerollState == null) {
      final results = roll2D6();
      _isisRerollState = IsisRerollState();
      _isisRerollState!.d6 = max(results.$1, results.$2);
    }
    final localState = _isisRerollState!;
    while (true) {
      if (choicesEmpty()) {
        final die = localState.d6!;
        if (_state.presidingGod != Piece.godIsis || _state.isisRerollCount >= _state.controlledTempleToGodCount(Piece.godIsis)) {
          _isisRerollState = null;
          return die;
        }
        if (_state.actionPointsAndGold < 2) {
          _isisRerollState = null;
          return die;
        }
        setPrompt('Reroll die?');
        choiceChoosable(Choice.yes, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.no)) {
        final die = localState.d6!;
        _isisRerollState = null;
        return die;
      }
      clearChoices();
      _state.isisRerollCount += 1;
      logLine('> Isis intervenes.');
      spendActionPoints(2);
      localState.d6 = rollD6();
    }
  }

  void khastiAdvanceOnPath(Path path) {
    final khasti = _state.pathCurrentKhasti(path);
    if (khasti == null) {
        return;
    }

    _khastiAdvanceState ??= KhastiAdvanceState();
    final localState = _khastiAdvanceState!;
  
    while (true) {
      final fromLand = _state.pieceLocation(khasti);
      final toLand = _state.pathPrevLand(path, fromLand);

      if (localState.subStep == 0) {
        logLine('### ${khasti.desc} Advances on ${toLand.desc}.');
        localState.subStep = 1;
      }

      while (localState.subStep >= 1) {
        if (localState.subStep == 1) {
          if (choicesEmpty()) {
            setPrompt('Respond to Khasti Advance');
            bool stopped = false;
            if (khasti == Piece.khastiRomans && _state.piecesInLocationCount(PieceType.revival, Location.boxRevival) > 0) {
              choiceChoosable(Choice.blockAdvanceRevival, true);
            }
            if (_state.pathHasMarriage(path)) {
              choiceChoosable(Choice.blockAdvanceMarriage, localState.marriageAPAmount == 0 && _state.actionPointsAndGold >= 1);
            }
            if (_state.greekMercenariesAvailable && _state.romanDebt > 0 && _state.literacy == Location.literacyCoptic) {
              choiceChoosable(Choice.blockAdvanceGreekMercenaries, true);
            }
            if (_state.piecesInLocationCount(PieceType.egyptianRule, fromLand) > 0) {
              choiceChoosable(Choice.blockAdvanceEgyptianRule, true);
              stopped = true;
            }
            if (!stopped && _state.pharaohAvailable && _state.landIsControlled(toLand)) {
              choiceChoosable(Choice.blockAdvancePharaoh, true);
            }
            if (!stopped && _state.piecesInLocationCount(PieceType.wallsOfTheRuler, toLand) > 0) {
              choiceChoosable(Choice.blockAdvanceWalls, true);
              stopped = true;
            }
            if (!stopped) {
              final nubianArchersLocation = _state.pieceLocation(Piece.heroesNubianArchers);
              if (nubianArchersLocation == toLand) {
                choiceChoosable(Choice.blockAdvanceNubianArchers, true);
                stopped = true;
              } else if (nubianArchersLocation.isType(LocationType.land)) {
                choiceChoosable(Choice.blockAdvanceNubianArchers, _state.gold >= (toLand == Location.landMenNefer ? 4 : 2));
              }
              final meraFleetLocation = _state.pieceLocation(Piece.heroesMeraFleet);
              if (meraFleetLocation == toLand) {
                choiceChoosable(Choice.blockAdvanceMeraFleet, true);
                stopped = true;
              } else if (meraFleetLocation.isType(LocationType.land) && _state.landIsNile(toLand)) {
                choiceChoosable(Choice.blockAdvanceMeraFleet, _state.gold >= (toLand == Location.landMenNefer ? 4 : 2));
              }
            }
            if (!stopped && _state.pieceInLocation(PieceType.rivalDynasty, toLand) != null) {
              choiceChoosable(Choice.blockAdvanceRivalCapital, true);
              stopped = true;
            }
            if (!stopped && !_state.landIsControlled(toLand) && !localState.militiaUsed && _state.pieceInLocation(PieceType.sepatTempled, toLand) != null) {
              choiceChoosable(Choice.blockAdvanceRivalMilitia, _state.actionPointsAndGold >= 1);
              stopped = true;
            }
            if (!stopped && _state.landIsControlled(toLand) && !localState.militiaUsed && _state.pieceInLocation(PieceType.sepatTempled, toLand) != null) {
              choiceChoosable(Choice.blockAdvanceMilitia, true);
              stopped = true;
            }
            if (!stopped) {
              choiceChoosable(Choice.blockAdvanceCede, true);
            }
            throw PlayerChoiceException();
          }
          if (checkChoiceAndClear(Choice.blockAdvanceRevival)) {
            logLine('> Revival Chit is sacrificed.');
            final revivalChits = _state.piecesInLocation(PieceType.revival, Location.boxRevival);
            _state.setPieceLocation(revivalChits[0], Location.discarded);
            logLine('> ${khasti.desc} ceases its Advance.');
            _khastiAdvanceState = null;
            return;
          } else if (checkChoiceAndClear(Choice.blockAdvanceMarriage)) {
            localState.subStep = 2;
          } else if (checkChoiceAndClear(Choice.blockAdvanceGreekMercenaries)) {
            logLine('> Greek Mercenary Self-Defense');
            adjustRomanDebt(1);
            localState.attackChoice = Choice.blockAdvanceGreekMercenaries;
            localState.subStep = 4;
          } else if (checkChoiceAndClear(Choice.blockAdvanceEgyptianRule)) {
            logLine('> Egyptian Rule');
            logLine('> ${khasti.desc} eliminates Egyptian Rule in ${fromLand.desc}.');
            final egyptianRule = _state.pieceInLocation(PieceType.egyptianRule, fromLand)!;
            _state.setPieceLocation(egyptianRule, Location.trayPolitical);
            logLine('> ${khasti.desc} ceases its Advance.');
            _khastiAdvanceState = null;
            return;
          } else if (checkChoiceAndClear(Choice.blockAdvancePharaoh)) {
            logLine('> Pharaohʼs Reaction');
            localState.attackChoice = Choice.blockAdvancePharaoh;
            localState.subStep = 4;
          } else if (checkChoiceAndClear(Choice.blockAdvanceWalls)) {
            logLine('> Walls of the Ruler');
            logLine('> ${khasti.desc} destroys Walls of the Ruler in ${toLand.desc}.');
            final walls = _state.pieceInLocation(PieceType.wallsOfTheRuler, toLand)!;
            _state.setPieceLocation(walls, Location.trayMilitary);
            logLine('> ${khasti.desc} ceases its Advance.');
            _khastiAdvanceState = null;
            return;
          } else if (checkChoiceAndClear(Choice.blockAdvanceNubianArchers)) {
            logLine('> Nubian Archers');
            localState.attackChoice = Choice.blockAdvanceNubianArchers;
            final nubianArchesLocation = _state.pieceLocation(Piece.heroesNubianArchers);
            if (nubianArchesLocation != toLand) {
              logLine('> Nubian Archers react to ${khasti.desc} Advance');
              spendGold(toLand == Location.landMenNefer ? 4 : 2);
              _state.setPieceLocation(Piece.heroesNubianArchers, toLand);
            }
            localState.subStep = 4;
          } else if (checkChoiceAndClear(Choice.blockAdvanceMeraFleet)) {
            logLine('> Mera Fleet');
            localState.attackChoice = Choice.blockAdvanceMeraFleet;
            final meraFleetLocation = _state.pieceLocation(Piece.heroesMeraFleet);
            if (meraFleetLocation != toLand) {
              logLine('> Mera Fleet reacts to ${khasti.desc} Advance');
              spendGold(toLand == Location.landMenNefer ? 4 : 2);
              _state.setPieceLocation(Piece.heroesMeraFleet, toLand);
            }
            localState.subStep = 4;
          } else if (checkChoiceAndClear(Choice.blockAdvanceRivalCapital)) {
            logLine('> Rival Dynasty Capital');
            localState.attackChoice = Choice.blockAdvanceRivalCapital;
            localState.subStep = 4;
          } else if (checkChoiceAndClear(Choice.blockAdvanceRivalMilitia)) {
            logLine('> Rival Dynasty Militia Defense');
            spendActionPoints(1);
            localState.attackChoice = Choice.blockAdvanceRivalMilitia;
            localState.subStep = 4;
          } else if (checkChoiceAndClear(Choice.blockAdvanceMilitia)) {
            logLine('> Militia Defense');
            localState.attackChoice = Choice.blockAdvanceMilitia;
            localState.subStep = 4;
          } else if (checkChoiceAndClear(Choice.blockAdvanceCede)) {
            logLine('> ${khasti.desc} captures ${toLand.desc}.');
            _state.setPieceLocation(khasti, toLand);
            localState.marriageAPAmount = 0;
            localState.militiaUsed = false;
            if (toLand == Location.landMenNefer) {
              _khastiAdvanceState = null;
              if (_state.piecesInLocationCount(PieceType.khasti, Location.landMenNefer) == 1) {
                if (_state.piecesInLocationCount(PieceType.revival, Location.boxRevival) == 0) {
                  if (_state.limitedEventCount(LimitedEvent.rome) > 0) {
                    logLine(' # Romans annex Egypt');
                    int survivalPoints = calculateSurvivalPoints();
                    throw GameOverException(GameResult.romeMenNefer, survivalPoints);
                  } else {
                    logLine('# Egypt is conquered');
                    throw GameOverException(GameResult.defeatMenNefer, 0);
                  }
                }
                logLine('### Egypt is conquered.');
              }
              return;
            }
            localState.subStep = 0;
          }
        }

        if (localState.subStep == 2) { // Marriage
          if (choicesEmpty()) {
            setPrompt('Choose amount of AP/Gold to Spend');
            for (int i = 1; i < 6 && _state.actionPointsAndGold <= i; ++i) {
              locationChoosable(_state.granaryBox(i));
            }
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
          if (checkChoiceAndClear(Choice.cancel)) {
            localState.subStep = 1;
            continue;
          }
          final granaryBox = selectedLocation()!;
          final amount = granaryBox.index - Location.granary0.index;
          logLine('> Marriage Blocks Advance.');
          spendActionPoints(amount);
          clearChoices();
          localState.marriageAPAmount = amount;
          localState.subStep = 3;
        }

        if (localState.subStep == 3) { // Marriage Roll
          int die = isisRollD6();
          if (localState.marriageAPAmount >= die) {
            logLine('> ${khasti.desc} Advance is blocked.');
            _khastiAdvanceState = null;
            return;
          }
          logLine('> ${khasti.desc} continues to Advance.');
          localState.subStep = 1;
        }

        if (localState.subStep >= 4 && localState.subStep <= 5) { // Attack
          final attackChoice = localState.attackChoice!;
          int value = _state.khastiValue(khasti);
          if (localState.subStep == 4) {
            logLine('> ${khasti.desc} Value: $value');
          }
          int valueModifiers = 0;
          if (_state.pathRise(path)) {
            if (localState.subStep == 4) {
              logLine('> Rise: +1');
            }
            valueModifiers += 1;
          }
          if (_state.pathDecline(path)) {
            if (localState.subStep == 4) {
              logLine('> Decline: -1');
            }
            valueModifiers -= 1;
          }
          int valueTotal = value + valueModifiers;
          localState.subStep = 5;
          int die = isisRollD6();
          int dieModifiers = 0;
          if ([Choice.blockAdvanceRivalMilitia, Choice.blockAdvanceMilitia].contains(attackChoice)) {
            final sepat = _state.pieceInLocation(PieceType.sepatTempled, toLand);
            if (sepat != null && _state.templedSepatElite(sepat)) {
              logLine('> Élite: +1');
              dieModifiers += 1;
            }
          }
          if (_state.haveIronWeapons) {
            logLine('> Iron: +1');
            dieModifiers += 1;
          }
          int dieTotal = die + dieModifiers;
          switch (attackChoice) {
          case Choice.blockAdvancePharaoh:
            _state.pharaohAvailable = false;
          case Choice.blockAdvanceNubianArchers:
            _state.setPieceLocation(Piece.heroesNubianArchersBack, Location.boxHeroes);
          case Choice.blockAdvanceMeraFleet:
            _state.setPieceLocation(Piece.heroesMeraFleetBack, Location.boxHeroes);
          case Choice.blockAdvanceRivalMilitia:
          case Choice.blockAdvanceMilitia:
            localState.militiaUsed = true;
          case Choice.blockAdvanceRivalCapital:
          case Choice.blockAdvanceGreekMercenaries:
          default:
          }
          if (dieTotal > valueTotal) {
            logLine('> Counterattack is successful, ${khasti.desc} Advance is halted.');
            _khastiAdvanceState = null;
            return;
          }
          switch (attackChoice) {
          case Choice.blockAdvanceRivalCapital:
            {
              final rival = _state.pieceInLocation(PieceType.rivalDynasty, toLand)!;
              logLine('> Counterattack fails, Rival Dynasty is conquered');
              logLine('> ${khasti.desc} continues to Advance.');
              _state.setPieceLocation(rival, Location.trayMilitary);
            }
          case Choice.blockAdvancePharaoh:
          case Choice.blockAdvanceGreekMercenaries:
          case Choice.blockAdvanceNubianArchers:
          case Choice.blockAdvanceMeraFleet:
          case Choice.blockAdvanceRivalMilitia:
          case Choice.blockAdvanceMilitia:
          default:
            logLine('> Counterattack fails, ${khasti.desc} continues to Advance.');
          }
          localState.subStep = 1;
        }
      }
    }
  }

  // Events

  void eventAlexander() {
    if (_state.pieceLocation(Piece.alexandria) == Location.boxAlexandria) {
      return;
    }
    logLine('### Alexander');
    logLine('> Alexander the Great conquers Egypt.');
    logLine('> Alexandria is founded.');
    _state.setPieceLocation(Piece.alexandria, Location.boxAlexandria);
    logLine('> Ptolemaic Dynasty is established.');
    var oldDynastyTile = _state.pieceInLocation(PieceType.dynasty, _state.currentTurnDynastyBox)!;
    if (oldDynastyTile != Piece.dynastyH) {
      if (!oldDynastyTile.isType(PieceType.egyptianDynastyFront)) {
        oldDynastyTile = _state.pieceFlipSide(oldDynastyTile)!;
      }
      _state.setPieceLocation(oldDynastyTile, Location.cupDynasty);
    }
    _state.setPieceLocation(Piece.dynastyH, Location.discarded);
    _state.setPieceLocation(Piece.libyanMigrants, Location.discarded);
    _state.setPieceLocation(Piece.dynastyA, _state.turnDynastyTrackBox(_state.currentTurn + 1));
    int lowestLandCount = 10;
    for (final path in Path.values) {
      int pathCount = _state.pathControlledLandCount(path);
      if (pathCount < lowestLandCount) {
        lowestLandCount = pathCount;
      }
      final khasti = _state.pathCurrentKhasti(path)!;
      final land = _state.pieceLocation(khasti);
      final countryLand = _state.pathHomeCountry(path);
      if (land != countryLand) {
        final retreatLand = Location.values[min(land.index + 3, countryLand.index)];
        logLine('> ${khasti.desc} retreats to ${retreatLand.desc}.');
        _state.setPieceLocation(khasti, retreatLand);
      }
    }
    final oldKhasti = _state.pathCurrentKhasti(Path.retjenu)!;
    final land = _state.pieceLocation(oldKhasti);
    logLine('> ${Piece.khastiSeleucids.desc} replaces ${oldKhasti.desc} in ${land.desc}.');
    _state.setPieceLocation(oldKhasti, Location.trayRetjenu);
    _state.setPieceLocation(Piece.khastiSeleucids, land);
    _state.setPieceLocation(Piece.inbreeding, _state.granaryBox(lowestLandCount));
    _state.currentEventOccurred(CurrentEvent.alexander);
  }

  void eventGoldenAge() {
    logLine('### Golden Age');
    _state.currentEventOccurred(CurrentEvent.goldenAge);
    logLine('> All Paths Decline');
    _state.setPieceLocation(Piece.decline, Location.boxRiseDeclineAllPaths);
  }

  void eventHebrews() {
    final hebrewLocation = _state.pieceLocation(Piece.hebrewPeople);
    switch (hebrewLocation) {
    case Location.trayPeople:
      logLine('### Hebrews');
      logLine('> Hebrews arrive in Egypt.');
      _state.setPieceLocation(Piece.hebrewPeople, Location.landMenNefer);
      return;
    case Location.landMenNefer:
      logLine('### Hebrews');
      logLine('> Moses moves the Hebrews to the Wilderness.');
      _state.setPieceLocation(Piece.hebrewPeople, Location.boxWilderness);
      spendActionPoints(2);
      if (_state.pharaohAvailable) {
        logLine('> Pharaoh vacations at the Red Sea.');
        _state.pharaohAvailable = false;
      }
      return;
    case Location.boxWilderness:
      logLine('### Hebrews');
      logLine('> Hebrews enter the Promised Land');
      _state.setPieceLocation(Piece.hebrewPeople, Location.boxPromisedLand);
      return;
    case Location.boxPromisedLand:
      logLine('### Hebrews');
      logLine('> Kingdom of Israel is established.');
      _state.setPieceLocation(Piece.hebrewPeople, Location.discarded);
      _state.setPieceLocation(Piece.israel0, Location.countryRetjenu);
      return;
    default:
    }
    if (_state.pieceLocation(Piece.israel0) == Location.countryRetjenu) {
      logLine('### Hebrews');
      logLine('> Kingdom of Israel turns against Egypt.');
      _state.setPieceLocation(Piece.israeln1, Location.countryRetjenu);
      return;
    }
  }

  void eventHighPriests() {
    if (_state.pieceLocation(Piece.highPriests) == Location.landWast) {
      return;
    }
    logLine('### High Priests of Amun');
    logLine('> High Priests put a drain on the treasury.');
    _state.setPieceLocation(Piece.highPriests, Location.landWast);
    spendActionPoints(1);
  }

  void eventHumanSacrifice() {
    if (_state.actionPoints < 1) {
      return;
    }
    logLine('### Human Sacrifice');
    spendActionPoints(1);
  }

  void eventIntermediatePeriod() {
    final dynasty = _state.currentDynastyTile!;

    if (_subStep == 0) {
      logLine('### Intermediate Period');
      _subStep = 1;
    }

    if (_subStep == 1) {
      if (_state.pharaohAvailable) {
        if (choicesEmpty()) {
          setPrompt('Use Pharaoh to try to negate Intermediate Period?');
          choiceChoosable(Choice.yes, true);
          choiceChoosable(Choice.no, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.yes)) {
          logLine('> Pharaoh tries to negate Intermediate Period.');
          _subStep = 2;
        } else {
          _subStep = 3;
        }
        clearChoices();
      } else {
        _subStep = 3;
      }
    }

    if (_subStep == 2) {
      int die = isisRollD6();
      _state.pharaohAvailable = false;
      if (die >= 4) {
        logLine('> Intermediate Period is negated.');
        return;
      } else {
        logLine('> Intermediate Period could not be prevented.');
      }
      _subStep = 3;
    }

    if (_subStep == 3) {
      if (dynasty.isType(PieceType.egyptianDynastyFront)) {
        logLine('> Dynastic Skills are lost.');
        _state.flipPiece(dynasty);
      }
      logLine('> All Paths Rise.');
      _state.setPieceLocation(Piece.rise, Location.boxRiseDeclineAllPaths);
    }
  }

  void eventLibyanMigrations() {
    final location = _state.pieceLocation(Piece.libyanMigrants);
    if (location == Location.trayPeople) {
      logLine('### Libyan Migrations');
      logLine('> Libyans migrate into Tjehenu Country.');
      _state.setPieceLocation(Piece.libyanMigrants, Location.countryTjehenu);
      return;
    }
    if (!location.isType(LocationType.land)) {
      return;
    }
    final toLand = _state.pathPrevLand(Path.tjehenu, location);
    if (toLand == Location.landMenNefer) {
      const eraSwitches = [
        Location.dynasty3,
        Location.dynasty10,
        Location.dynasty11,
        Location.dynasty17,
        Location.dynasty18,
        Location.dynasty25,
        Location.dynasty26,
        Location.dynasty38,
      ];
      if (eraSwitches.contains(_state.currentTurnDynastyBox)) {
        return;
      }
    }

    if (_subStep == 0) {
      logLine('### Libyan Migrations');
      _subStep = 1;
    }

    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Bribe Libyan Migrants?');
        choiceChoosable(Choice.yes, _state.gold >= 1);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        logLine('> Bribe Libyan Migrants.');
        spendGold(1);
        _subStep = 2;
      } else {
        _subStep = 3;
      }
      clearChoices();
    }

    if (_subStep == 2) {
      int die = isisRollD6();
      if (die >= 4) {
        logLine('> Libyan Migrants remain in ${location.desc}.');
        return;
      }
      _subStep = 3;
    }

    if (_subStep == 3) {
      if (toLand == Location.landMenNefer) {
        logLine('> Migrants establish new Libyan Dynasty.');
        _state.setPieceLocation(Piece.dynastyH, Location.values[_state.currentTurnDynastyBox.index + 1]);
        var oldDynastyTile = _state.pieceInLocation(PieceType.dynasty, _state.currentTurnDynastyBox)!;
        if (!oldDynastyTile.isType(PieceType.egyptianDynastyFront)) {
          oldDynastyTile = _state.pieceFlipSide(oldDynastyTile)!;
        }
        _state.setPieceLocation(oldDynastyTile, Location.cupDynasty);
        _state.setPieceLocation(Piece.dynastyA, Location.trayDynasty);
        _phaseState = null;
        _state.clearCurrentEvents();
        _state.manethoTotal = null;
        _state.advanceTurn();
        _step = 0;
      } else {
        logLine('> Libyan Migrants move to ${toLand.desc}.');
        _state.setPieceLocation(Piece.libyanMigrants, toLand);
      }
    }
  }

  void eventMaccabees() {
    if (_state.limitedEventCount(LimitedEvent.maccabees) >= 1) {
      return;
    }
    logLine('### The Maccabees');
    logLine('> Jewish rebels restore Israel’s independence.');
    _state.setPieceLocation(Piece.israel0, Location.countryRetjenu);
    _state.limitedEventOccurred(LimitedEvent.maccabees);
  }

  void eventMonotheism() {
    logLine('### Monotheism');
    logLine('> Traditional Egyptian Gods are abandoned.');
    _state.currentEventOccurred(CurrentEvent.monotheism);
  }

  void eventResource(Goods goods) {
    int total = 0;
    for (final path in Path.values) {
      int landCount = _state.pathControlledLandCount(path);
      for (int sequence = 0; sequence < landCount; ++sequence) {
        final land = _state.pathSequenceLand(path, sequence);
        final sepat = _state.pieceInLocation(PieceType.sepat, land);
        if (sepat != null && _state.sepatGoods(sepat) == goods) {
          if (total == 0) {
            logLine('### ${goods.desc} Bonus');
          }
          logLine('> ${land.desc}');
          total += 1;
        }
      }
    }
    if (total > 0) {
      adjustActionPoints(total);
    }
  }

  void eventResourceBeer() {
    eventResource(Goods.beer);
  }

  void eventResourceCopper() {
    eventResource(Goods.copper);
  }

  void eventResourceGrain() {
    eventResource(Goods.grain);
  }

  void eventResourceGranite() {
    eventResource(Goods.granite);
  }

  void eventResourceIron() {
    eventResource(Goods.iron);
  }

  void eventResourceLimestone() {
    eventResource(Goods.limestone);
  }

  void eventResourceLinen() {
    eventResource(Goods.linen);
  }

  void eventResourceNatron() {
    eventResource(Goods.natron);
  }

  void eventResourcePapyrus() {
    eventResource(Goods.papyrus);
  }

  void eventResourceTurquoise() {
    eventResource(Goods.turquoise);
  }

  void eventRome() {
    logLine('### Rome');
    logLine('> Rome takes control of Israel.');
    _state.setPieceLocation(Piece.israel0, Location.discarded);
    _state.limitedEventOccurred(LimitedEvent.rome);
  }

  void eventTombRobbers() {
    final revivals = _state.piecesInLocation(PieceType.revival, Location.boxRevival);
    if (revivals.isEmpty) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Tomb Robbers');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (_state.pieceLocation(Piece.medjaiPolice) == Location.boxRevival) {
        int die = isisRollD6();
        if (die < 6) {
          logLine('> Medjai Police thwart Tomb Robbers.');
          return;
        }
        logLine('> Medjai Police prove incapable of stopping Tomb Robbers.');
        _state.setPieceLocation(Piece.medjaiPolice, Location.trayMilitary);
      }
      _subStep = 2;
    }

    if (_subStep == 2) {
      logLine('> Tomb Robbers defile Egyptian monuments.');
      _state.setPieceLocation(revivals[0], Location.discarded);
    }
  }

  // Sequence of Play

  void turnBegin() {
	  logLine('# ${_state.turnDynastyName(_state.currentTurn)}');
    _state.isisRerollCount = 0;
  }

  void dynastyPhaseBegin() {
    if (_state.currentTurn == 0) {
      return;
    }
    if (_state.currentDynastyTile == Piece.dynastyH) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Dynasty Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Dynasty Phase');
  }

  void dynastyPhaseDrawDynastyTile() {
    if (_state.currentTurn == 0) {
      return;
    }
    if (_state.currentDynastyTile == Piece.dynastyH) {
      return;
    }
    if (_subStep == 0) {
      logLine('### New Dynasty');
      bool conquered = _state.piecesInLocationCount(PieceType.khasti, Location.landMenNefer) > 0;
      final newEra = [8,15,23].contains(_state.currentTurn);
      if (newEra || conquered) {
        if (conquered) {
          logLine('> Egypt Revived.');
          final revivalChits = _state.piecesInLocation(PieceType.revival, Location.boxRevival);
          _state.setPieceLocation(revivalChits[0], Location.discarded);
        }
        if (newEra) {
          final era = _state.eraPiece(_state.era);
          logLine('> ${era.desc} is established.');
          _state.setPieceLocation(era, Location.boxEra);
        }
        final marriageLocation = _state.pieceLocation(Piece.marriage);
        if (marriageLocation != Location.trayPolitical) {
          logLine('> Marriage ties with ${marriageLocation.desc} are broken.');
          _state.setPieceLocation(Piece.marriage, Location.trayPolitical);
        }
        logLine('> Dynasty Tile: ${Piece.dynastyA.desc}');
        _state.setDynastyTile(Piece.dynastyA);
        if (_state.era == Era.middleKingdom) {
          for (final path in Path.values) {
            Location? khastiLand;
            final Piece troops = _state.pathTroops(path);
            final troopsLand = _state.pieceLocation(troops);
            if (_state.pathIncludesLocation(path, troopsLand)) {
              khastiLand = Location.values[troopsLand.index + 1];
            } else {
              khastiLand = _state.pathDieLand(path, 1);
            }
            final khasti = _state.pathKhastiSequence(path)[0];
            logLine('> ${khasti.desc} occupy ${khastiLand.desc}.');
            _state.setPieceLocation(khasti, khastiLand);
            _state.setPieceLocation(_state.pieceFlipSide(troops)!, Location.trayMilitary);
          }
        } else {
          for (final path in Path.values) {
            final khasti = _state.pathCurrentKhasti(path)!;
            final khastiLand = _state.pieceLocation(khasti);
            if (khastiLand == Location.landMenNefer) {
              final country = _state.pathHomeCountry(path);
              logLine('> ${khasti.desc} retreat to ${country.desc}.');
              _state.setPieceLocation(khasti, country);
            } else {
              final targetLand = _state.pathDieLand(path, 4);
              if (khastiLand.index < targetLand.index) {
                logLine('> ${khasti.desc} retreat to ${targetLand.desc}.');
                _state.setPieceLocation(khasti, targetLand);
              }
            }
          }
        }
        _subStep = 2;
      } else if (_state.pieceLocation(Piece.marriage).isType(LocationType.land)) {  // Marriage
        _subStep = 1;
      } else {
        final cupTiles = _state.piecesInLocation(PieceType.egyptianDynastyFront, Location.cupDynasty);
        final dynastyTile = randPiece(cupTiles)!;
        logLine('> Dynasty Tile: ${dynastyTile.desc}');
        _state.setDynastyTile(dynastyTile);
        _subStep = 3;
      }
    }

    if (_subStep == 1) { // Select dynasty
      if (choicesEmpty()) {
        setPrompt('Select Dynasty');
        choiceChoosable(Choice.dynastyE, _state.pieceLocation(Piece.dynastyE) == Location.cupDynasty);
        choiceChoosable(Choice.dynastyF, _state.pieceLocation(Piece.dynastyF) == Location.cupDynasty);
        choiceChoosable(Choice.dynastyG, _state.pieceLocation(Piece.dynastyG) == Location.cupDynasty);
        throw PlayerChoiceException();
      }
      Piece? dynastyTile;
      if (checkChoice(Choice.dynastyE)) {
        dynastyTile = Piece.dynastyE;
      } else if (checkChoice(Choice.dynastyF)) {
        dynastyTile = Piece.dynastyF;
      } else if (checkChoice(Choice.dynastyG)) {
        dynastyTile = Piece.dynastyG;
      }
      logLine('> Dynasty Tile: ${dynastyTile!.desc}');
      _state.setDynastyTile(dynastyTile);
      clearChoices();
      _subStep = 3;
    }

    if (_subStep == 2) { // Temple sepats
      while (true) {
        if (choicesEmpty()) {
          for (final path in Path.values) {
            bool controlTemple = false;
            final untempledSepats = <Piece>[];
            for (int sequence = 0; true; ++sequence) {
              final land = _state.pathSequenceLand(path, sequence);
              if (_state.landIsCountry(land)) {
                break;
              }
              final khasti = _state.pieceInLocation(PieceType.khasti, land);
              if (khasti != null) {
                break;
              }
              final rivalDynasty = _state.pieceInLocation(PieceType.rivalDynasty, land);
              if (rivalDynasty != null) {
                break;
              }
              final sepat = _state.pieceInLocation(PieceType.sepat, land);
              if (sepat != null) {
                if (sepat.isType(PieceType.sepatTempled)) {
                  controlTemple = true;
                  break;
                }
                untempledSepats.add(sepat);
              }
            }
            if (!controlTemple) {
              for (final sepat in untempledSepats) {
                pieceChoosable(sepat);
              }
            }
          }
          if (choosablePieceCount == 0) {
            _subStep = 3;
            break;
          }
          setPrompt('Select Sepat to Temple');
          throw PlayerChoiceException();
        } else {
          final sepat = selectedPiece()!;
          final land = _state.pieceLocation(sepat);
          final templedSepat = _state.pieceFlipSide(sepat)!;
          final god = _state.templedSepatGod(templedSepat);
          logLine('> Temple dedicated to ${god.desc} is built in ${land.desc}.');
          _state.templeSepat(sepat);
          clearChoices();
        }
      }
    }

    if (_subStep == 3) { // Remove old dynasty tile
      final box = _state.turnDynastyTrackBox(_state.currentTurn - 1);
      var dynastyTile = _state.pieceInLocation(PieceType.dynasty, box);
      if (dynastyTile != null) {
        if (dynastyTile == Piece.dynastyH) {
          _state.setPieceLocation(dynastyTile, Location.discarded);
        } else {
          if (!dynastyTile.isType(PieceType.egyptianDynastyFront)) {
            dynastyTile = _state.pieceFlipSide(dynastyTile)!;
          }
          _state.setPieceLocation(dynastyTile, Location.cupDynasty);
        }
      }
    }
  }

  void dynastyPhaseOkToLoot() {
    if (_state.pieceLocation(Piece.dynastyH) != Location.discarded) {
      return;
    }
    if (_state.piecesInLocationCount(PieceType.okToLoot, Location.boxHeroes) > 0) {
      return;
    }
    final egyptianRules = _state.piecesInLocation(PieceType.egyptianRule, Location.trayPolitical);
    if (egyptianRules.isNotEmpty) {
      final okToLoot = _state.pieceFlipSide(egyptianRules[0])!;
      _state.setPieceLocation(okToLoot, Location.boxHeroes);
    } else {
      if (choicesEmpty()) {
        setPrompt('Select Egyptian Rule to remove');
        for (final egyptianRule in PieceType.egyptianRule.pieces) {
          pieceChoosable(egyptianRule);
        }
        throw PlayerChoiceException();
      }
      final egyptianRule = selectedPiece()!;
      final okToLoot = _state.pieceFlipSide(egyptianRule)!;
      _state.setPieceLocation(okToLoot, Location.boxHeroes);
    }
    logLine('> Megaprojects may be looted.');
  }

  void nilePhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Nile Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Nile Phase');
    _phaseState = PhaseStateNile();
  }

  void nilePhaseRoll() {
    final phaseState = _phaseState as PhaseStateNile;
    if (_subStep == 0) {
      logLine('### Nile Roll');
      if (_state.era == Era.oldKingdom) {
        final rolls = roll3D6();
        final dice = [rolls.$1, rolls.$2, rolls.$3];
        int? high;
        int? mid;
        int? low;
        for (int i = 0; i < 3; ++i) {
          final die = dice[i];
          if (high == null || die >= high) {
            low = mid;
            mid = high;
            high = die;
          } else if (mid == null || die >= mid) {
            low = mid;
            mid = die;
          } else {
            low = die;
          }
        }
        phaseState.high = high;
        phaseState.mid = mid;
        phaseState.low = low;
        _subStep = 1;
      } else {
        final rolls = roll2D6();
        final dice = [rolls.$1, rolls.$2];
        phaseState.high = max(dice[0], dice[1]);
        phaseState.low = min(dice[0], dice[1]);
        _subStep = 2;
      }
    }

    if (_subStep == 1) { // Pharaoh
      if (choicesEmpty()) {
        setPrompt('Nile Roll: ${phaseState.high}-${phaseState.mid} - Use Pharaoh to change to ${phaseState.high}-${phaseState.low}?');
        choiceChoosable(Choice.yes, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        phaseState.mid = null;
        logLine('> Pharaoh modifies the Nile Roll.');
        _state.pharaohAvailable = false;
      }
      if (checkChoice(Choice.no)) {
        phaseState.low = phaseState.mid;
        phaseState.mid = null;
      }
      clearChoices();
      _subStep = 2;
    }

    if (_subStep == 2) {
      logLine('> Nile Roll: **${dieFaceCharacter(phaseState.high!)}** **${dieFaceCharacter(phaseState.low!)}**');
      int level = phaseState.high! - phaseState.low!;
      logLine('> Nile Level: +$level AP');
      phaseState.actionPoints += level;
      final goods = _state.tradeGoods(phaseState.high! + phaseState.low!);
      String goodsDesc = '';
      int accessibleGoodsCount = 0;
      for (final good in goods) {
        if (goodsDesc.isNotEmpty) {
          goodsDesc += ', ';
        }
        goodsDesc += good.desc;
        if (_state.goodsAccessible(good)) {
          accessibleGoodsCount += 1;
        }
      }
      logLine('> Trade Goods: $goodsDesc: +$accessibleGoodsCount AP');
      phaseState.actionPoints += accessibleGoodsCount;
      adjustActionPoints(phaseState.actionPoints);
    }
  }

  void nilePhaseGold() {
    int landCount = _state.pathControlledLandCount(Path.taSeti);
    if (landCount >= 6) {
      logLine('> Irtjet: +1 Gold');
      adjustGold(1);
    }
    if (landCount >= 7) {
      logLine('> Wawat: +1 Gold');
      adjustGold(1);
    }
  }

  void nilePhaseEmergency() {
    if (_state.actionPoints == 0) {
      logLine('> Emergency: +1 AP');
      adjustActionPoints(1);
    }
  }

  void nilePhaseHighPriests() {
    if (_state.pieceLocation(Piece.highPriests) == Location.landWast) {
      int landCount = _state.pathControlledLandCount(Path.taSeti);
      if (landCount >= 3) {
        if (_state.gold > 0) {
          logLine('> High Priests: -1 Gold');
          spendGold(1);
        } else {
          logLine('> High Priests: -1 AP.');
          spendActionPoints(1);
        }
      }
    }
  }

  void nilePhaseEnd() {
    _phaseState = null;
  }

  void godPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to God Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## God Phase');
    _phaseState = PhaseStateGod();
  }

  void godPhaseSelect() {
    logLine('### God');
    final godFronts = _state.piecesInLocation(PieceType.godFront, Location.cupGod);
    final godFront = randPiece(godFronts)!;
    int side = randInt(2);
    final god = side == 0 ? godFront : _state.pieceFlipSide(godFront)!;
    logLine('> Presiding God: ${god.desc}');
    _state.setPresidingGod(god);
  }

  void godPhaseRiseDecline() {
    final god = _state.presidingGod!;
    if (_subStep == 0) {
      if (_state.godHasRise(god)) {
        final paths = <Path>[];
        for (final path in Path.values) {
          if (!_state.pathHasTempleToGod(path, god)) {
            paths.add(path);
          }
        }
        if (paths.isEmpty) {
          logLine('> ${god.desc} is appeased, no Path Rises.');
        } else {
          final path = randPath(paths)!;
          logLine('> ${god.desc} is angry, ${path.desc} Rises.');
          final box = _state.pathRiseDeclineBox(path);
          _state.setPieceLocation(Piece.rise, box);
        }
      } else if (_state.godHasDecline(god)) {
        _subStep = 1;
      }
    }

    if (_subStep == 1) {
      if (choicesEmpty()) {
        for (final path in Path.values) {
          if (_state.pathHasTempleToGod(path, god)) {
            locationChoosable(_state.pathHomeCountry(path));
          }
        }
        if (choosableLocationCount == 0) {
          logLine('> ${god.desc} is angry, no Path Declines.');
          return;
        }
        setPrompt('Select Path to Decline');
        throw PlayerChoiceException();
      }
      final land = selectedLocation()!;
      final path = _state.landPath(land)!;
      logLine('> ${path.desc} Declines.');
      final box = _state.pathRiseDeclineBox(path);
      _state.setPieceLocation(Piece.decline, box);
      clearChoices();
    }
  }

  void godPhaseRevolt() {
    final phaseState = _phaseState as PhaseStateGod;
    final god = _state.presidingGod!;
    if (!_state.godHasRevolt(god)) {
        return;
    }
    if (_subStep == 0) {
      final paths = <Path>[];
      for (final path in Path.values) {
        if (!_state.pathHasTempleToGod(path, god)) {
          if (_state.pathRivalDynasty(path) == null) {
            paths.add(path);
          }
        }
      }
      if (paths.isEmpty) {
        logLine('> ${god.desc} is appeased, no Land Revolts.');
        return;
      }
      final path = randPath(paths)!;
      int die = rollD6();
      final land = _state.pathDieLand(path, die);
      if (_state.piecesInLocationCount(PieceType.maatUnused, land) > 0) {
        logLine('> Maʼat prevents Revolt in ${land.desc}.');
        return;
      }
      phaseState.revoltPath = path;
      phaseState.revoltLand = land;
      _subStep = _state.era == Era.oldKingdom && _state.pharaohAvailable ? 1 : 2;
    }

    final path = phaseState.revoltPath!;
    final land = phaseState.revoltLand!;

    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Use Pharaoh to prevent Revolt in ${land.desc}?');
        choiceChoosable(Choice.yes, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        logLine('> Pharaoh prevents Revolt in ${land.desc}.');
        _state.pharaohAvailable = false;
        clearChoices();
        return;
      }
      clearChoices();
      _subStep = 2;
    }

    if (_subStep == 2) {
      logLine('> ${land.desc} Revolts.');
      if (_state.era == Era.oldKingdom) {
        if (_state.landIsControlled(land)) {
          final troops = _state.pathTroops(path);
          final troopsLand = _state.pieceLocation(troops);
          final retreatLand = _state.pathPrevLand(path, troopsLand);
          logLine('> Medjai Troops retreat to ${retreatLand.desc}.');
          _state.setPieceLocation(troops, retreatLand);
          return;
        }
        if (_state.piecesInLocationCount(PieceType.sepat, land) > 0 || !_state.landSupportsSepat(land, false)) {
          logLine('> Revolt has no impact.');
          return;
        }
        final sepat = drawSepat();
        discoverSepat(land, sepat);
      } else {
        if (_state.landIsCountry(land)) {
          final khasti = _state.pathCurrentKhasti(path)!;
          final khastiLand = _state.pieceLocation(khasti);
          if (khastiLand != land) {
            logLine('> ${khasti.desc} retreats to ${land.desc}.');
            _state.setPieceLocation(khasti, land);
          }
        } else {
          var sepat = _state.pieceInLocation(PieceType.sepat, land);
          final ankh = sepat == null || _state.sepatAnkh(sepat);
          Piece? rivalDynasty;
          for (final rival in _state.piecesInLocation(PieceType.rivalDynasty, Location.trayMilitary)) {
            if (rivalDynasty == null) {
              rivalDynasty = rival;
            } else if (ankh) {
              if (_state.rivalDynastyStrength(rival) < _state.rivalDynastyStrength(rivalDynasty)) {
                rivalDynasty = rival;
              }
            } else {
              if (_state.rivalDynastyStrength(rival) > _state.rivalDynastyStrength(rivalDynasty)) {
                rivalDynasty = rival;
              }
            }
          }
          logLine('> A Rival Dynasty of strength ${_state.rivalDynastyStrength(rivalDynasty!)} rises in ${land.desc}.');
          _state.setPieceLocation(rivalDynasty, land);
          if (sepat == null) {
            sepat = drawSepat();
            discoverSepat(land, sepat);
          }
          if (sepat.isType(PieceType.sepatUntempled)) {
            templeSepat(land, sepat);
          }
          final nextLand = _state.pathNextLand(path, land)!;
          final khasti = _state.pathCurrentKhasti(path)!;
          final khastiLand = _state.pieceLocation(khasti);
          if (khastiLand.index < nextLand.index) {
            logLine('> ${khasti.desc} retreats to ${nextLand.desc}.');
            _state.setPieceLocation(khasti, nextLand);
          }
          _subStep = 3;
        }
      }
    }

    while (_subStep >= 3) { // Attack rival dynasty
      final revoltLand = phaseState.revoltLand!;
      final revoltPath = phaseState.revoltPath!;
      final rivalDynasty = _state.pieceInLocation(PieceType.rivalDynasty, revoltLand)!;
      if (_subStep == 3) {
        if (choicesEmpty()) {
          setPrompt('Respond to Rival Dynasty');
          bool mandatory = false;
          final nubianArchersLocation = _state.pieceLocation(Piece.heroesNubianArchers);
          if (nubianArchersLocation.isType(LocationType.land)) {
            if (_state.landPath(nubianArchersLocation) == revoltPath) {
              choiceChoosable(Choice.blockAdvanceNubianArchers, true);
              mandatory = true;
            } else {
              choiceChoosable(Choice.blockAdvanceNubianArchers, _state.gold >= 2);
            }
          }
          if (_state.landIsNile(revoltLand)) {
            final meraFleetLocation = _state.pieceLocation(Piece.heroesMeraFleet);
            if (meraFleetLocation.isType(LocationType.land)) {
              if (_state.landPath(meraFleetLocation) == revoltPath) {
                choiceChoosable(Choice.blockAdvanceMeraFleet, true);
                mandatory = true;
              } else {
                choiceChoosable(Choice.blockAdvanceMeraFleet, _state.gold >= 2);
              }
            }
          }
          if (!mandatory) {
            choiceChoosable(Choice.blockAdvanceCede, true);
          }
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.blockAdvanceNubianArchers)) {
          logLine('> Nubian Archers');
          phaseState.attackChoice = Choice.blockAdvanceNubianArchers;
          final nubianArchesLocation = _state.pieceLocation(Piece.heroesNubianArchers);
          if (nubianArchesLocation != revoltLand) {
            logLine('> Nubian Archers react to Rival Dynasty');
            if (_state.landPath(nubianArchesLocation) != revoltPath) {
              spendGold(2);
            }
            _state.setPieceLocation(Piece.heroesNubianArchers, revoltLand);
          }
          _subStep = 4;
        } else if (checkChoiceAndClear(Choice.blockAdvanceMeraFleet)) {
          logLine('> Mera Fleet');
          phaseState.attackChoice = Choice.blockAdvanceMeraFleet;
          final meraFleetLocation = _state.pieceLocation(Piece.heroesMeraFleet);
          if (meraFleetLocation != revoltLand) {
            logLine('> Mera Fleet reacts to Rival Dynasty');
            if (_state.landPath(meraFleetLocation) != revoltPath) {
              spendGold(2);
              _state.setPieceLocation(Piece.heroesMeraFleet, revoltLand);
            }
          }
          _subStep = 4;
        } else if (checkChoiceAndClear(Choice.blockAdvanceCede)) {
          logLine('> Rival Dynasty in ${land.desc} is firmly established.');
          return;
        }
      }

      if (_subStep >= 4 && _subStep <= 5) { // Attack
        final attackChoice = phaseState.attackChoice!;
        int value = _state.rivalDynastyStrength(rivalDynasty);
        if (_subStep == 4) {
          logLine('> Rival Dynasty Value: $value');
        }
        int valueModifiers = 0;
        if (_state.pathRise(path)) {
          if (_subStep == 4) {
            logLine('> Rise: +1');
          }
          valueModifiers += 1;
        }
        if (_state.pathDecline(path)) {
          if (_subStep == 4) {
            logLine('> Decline: -1');
          }
          valueModifiers -= 1;
        }
        int valueTotal = value + valueModifiers;
        _subStep = 5;
        int die = isisRollD6();
        int dieModifiers = 0;
        if (_state.haveIronWeapons) {
          logLine('> Iron: +1');
          dieModifiers += 1;
        }
        int dieTotal = die + dieModifiers;
        switch (attackChoice) {
        case Choice.blockAdvanceNubianArchers:
          _state.setPieceLocation(Piece.heroesNubianArchersBack, Location.boxHeroes);
        case Choice.blockAdvanceMeraFleet:
          _state.setPieceLocation(Piece.heroesMeraFleetBack, Location.boxHeroes);
        default:
        }
        if (dieTotal > valueTotal) {
          logLine('> Counterattack is successful, Rival Dynasty is crushed.');
          _state.setPieceLocation(rivalDynasty, Location.trayMilitary);
          return;
        }
        logLine('> Counterattack fails, Rival Dynasty endures.');
        _subStep = 3;
      }
    }
  }

  void godPhaseEnd() {
    _phaseState = null;
  }

  void khastiEvolutionPhaseBegin() {
    if (_state.era == Era.oldKingdom) {
      return;
    }
    _phaseState = PhaseStateKhastiEvolution();
    if (_state.turnKhastiEvolutionPaths(_state.currentTurn).isEmpty) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Khasti Evolution Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Khasti Evolution Phase');
  }

  void khastiEvolutionPhaseEvolution(int pathIndex) {
    if (_state.era == Era.oldKingdom) {
      return;
    }
    final phaseState = _phaseState as PhaseStateKhastiEvolution;
    final paths = _state.turnKhastiEvolutionPaths(_state.currentTurn);
    if (paths.length <= pathIndex) {
      return;
    }
    final path = paths[pathIndex];
    final country = _state.pathHomeCountry(path);
    final khastis = _state.pathKhastiEvolutionSequence(path);
    final oldKhasti = _state.pathCurrentKhasti(path)!;
    Piece? newKhasti;
    for (int i = 0; i < khastis.length; ++i) {
      if (khastis[i] == oldKhasti) {
        if (i + 1 == khastis.length) {
          return;
        }
        newKhasti = khastis[i + 1];
        break;
      }
    }
    if (_subStep == 0) {
      logLine('### Khasti Evolution on ${path.desc} Path');
      _subStep = 1;
    }
    if (_subStep == 1) {
      final die = isisRollD6();
      if (die < 4) {
        logLine('> ${oldKhasti.desc} remain in control of ${country.desc}.');
        return;
      }
      phaseState.evolved[pathIndex] = true;
      _subStep = 2;
    }

    if (_subStep == 2) {
      final land = _state.pieceLocation(oldKhasti);
      logLine('> ${newKhasti!.desc} replaces ${oldKhasti.desc} in ${country.desc}.');
      Location? tray;
      if (path == Path.retjenu) {
        tray = Location.trayRetjenu;
      } else if (path == Path.taSeti) {
        tray = Location.trayKerma;
      } else {
        tray = Location.trayLibu;
      }
      _state.setPieceLocation(oldKhasti, tray);
      _state.setPieceLocation(newKhasti, land);
      if (newKhasti == Piece.khastiHyksos) {
        logLine('> Knowledge of Chariots reaches Egypt.');
        _state.setPieceLocation(Piece.heroesChariotsP2, Location.boxHeroes);
      } else if (newKhasti == Piece.khastiAssyria) {
        _subStep = 3;
      } else if (newKhasti == Piece.khastiBabylon) {
        _subStep = 3;
      } else {
      _subStep = 4;
      }
    }

    if (_subStep == 3) {  // Greek Mercenaries / Jewish Refugees
      if (choicesEmpty()) {
        setPrompt(newKhasti == Piece.khastiAssyria ? 'Hire Greek Mercenaries?' : 'Support Jewish Refugees?');
        choiceChoosable(Choice.yes, _state.gold >= 1);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        if (newKhasti == Piece.khastiAssyria) {
          logLine('> Greek Mercenaries hired.');
          spendGold(1);
          _state.setPieceLocation(Piece.greeks, Location.landMenNefer);
         } else {
          logLine('> Jewish Refugees arrive in Egypt.');
          spendGold(1);
          _state.setPieceLocation(Piece.jews, Location.landMenNefer);
        }
      }
      clearChoices();
      _subStep = 4;
    }

    if (_subStep == 4) {  // Israel
      if ([Piece.khastiBabylon, Piece.khastiPersia].contains(newKhasti)) {
        if (_state.piecesInLocationCount(PieceType.israel, Location.countryRetjenu) > 0) {
          logLine('> ${newKhasti!.desc} conquers Israel.');
          _state.setPieceLocation(Piece.israel0, Location.trayMilitary);
        }
      }
    }
  } 

  void khastiEvolutionPhaseEvolution0() {
    khastiEvolutionPhaseEvolution(0);
  }

  void khastiEvolutionPhaseEvolution1() {
    khastiEvolutionPhaseEvolution(1);
  }

  void khastiEvolutionPhaseEvolution2() {
    khastiEvolutionPhaseEvolution(2);
  }

  void khastiEvolutionPhaseAdvance(int pathIndex) {
    if (_state.era == Era.oldKingdom) {
      return;
    }
    final phaseState = _phaseState as PhaseStateKhastiEvolution;
    if (!phaseState.evolved[pathIndex]) {
      return;
    }
    final paths = _state.turnKhastiEvolutionPaths(_state.currentTurn);
    if (paths.length <= pathIndex) {
      return;
    }
    final path = paths[pathIndex];
    khastiAdvanceOnPath(path);
  }

  void khastiEvolutionPhaseAdvance0() {
    khastiEvolutionPhaseAdvance(0);
  }

  void khastiEvolutionPhaseAdvance1() {
    khastiEvolutionPhaseAdvance(1);
  }

  void khastiEvolutionPhaseAdvance2() {
    khastiEvolutionPhaseAdvance(2);
  }

  void khastiEvolutionPhaseEnd() {
    _phaseState = null;
  }

  void chroniclesOfManethoPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Chronicles of Manetho Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Chronicles of Manetho Phase');
  }

  void chroniclesOfManethoPhaseRoll() {
    logLine('### Random Events Roll');
    int die = rollD6();
    int total = die + _state.currentTurn + 3;
    logLine('> Result: $total');
    _state.manethoTotal = total;
  }

  void chroniclesOfManethoPhaseEvent(int index) {
    if (_state.currentEventIsCurrent(CurrentEvent.alexander)) {
      return;
    }
    final eventHandlers = [
      [eventHumanSacrifice],
      [eventResourceLinen],
      [eventIntermediatePeriod, eventResourceGrain],
      [eventGoldenAge, eventResourceLimestone],
      [eventGoldenAge, eventResourceGranite],
      [eventResourcePapyrus],
      [eventIntermediatePeriod, eventResourceNatron],
      [eventIntermediatePeriod, eventResourceTurquoise],
      [eventResourceCopper],
      [eventResourceBeer],
      [eventTombRobbers, eventIntermediatePeriod],
      [eventGoldenAge],
      [],
      [eventTombRobbers],
      [eventTombRobbers],
      [],
      [],
      [eventIntermediatePeriod, eventLibyanMigrations],
      [eventGoldenAge, eventMonotheism, eventHebrews],
      [eventGoldenAge, eventLibyanMigrations, eventHebrews],
      [eventHighPriests],
      [eventTombRobbers, eventIntermediatePeriod, eventHebrews],
      [eventLibyanMigrations, eventHebrews],
      [eventTombRobbers, eventLibyanMigrations],
      [eventLibyanMigrations, eventHebrews],
      [],
      [eventLibyanMigrations, eventHebrews],
      [eventTombRobbers],
      [eventLibyanMigrations, eventHebrews],
      [eventResourceIron],
      [eventLibyanMigrations, eventHebrews],
      [eventTombRobbers],
      [eventAlexander, eventHebrews],
      [eventAlexander, eventHebrews],
      [eventAlexander, eventMaccabees, eventIntermediatePeriod],
      [eventMaccabees, eventTombRobbers],
      [eventRome],
      [eventRome],
      [eventRome],
      [eventRome],
      [eventRome],
      [eventRome],
    ];
    final row = (_state.manethoTotal! - 4);
    final handlers = eventHandlers[row];
    if (index < handlers.length) {
      handlers[index]();
    }
  }

  void chroniclesOfManethoPhaseEvent0() {
    chroniclesOfManethoPhaseEvent(0);
  }

  void chroniclesOfManethoPhaseEvent1() {
    chroniclesOfManethoPhaseEvent(1);
  }

  void chroniclesOfManethoPhaseEvent2() {
    chroniclesOfManethoPhaseEvent(2);
  }

  void chroniclesOfManethoPhaseEnd() {
    _phaseState = null;
  }

  void cleopatraPhaseBegin() {
    if (_state.limitedEventCount(LimitedEvent.rome) == 0) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Cleopatra Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Cleopatra Phase');
  }

  void cleopatraPhaseKhastiEvolution() {
    if (_state.limitedEventCount(LimitedEvent.rome) == 0) {
      return;
    }
    final oldKhasti = _state.pathCurrentKhasti(Path.retjenu)!;
    final land = _state.pieceLocation(oldKhasti);
    logLine('> ${Piece.khastiRomans.desc} replace ${oldKhasti.desc} in ${land.desc}.');
    _state.setPieceLocation(oldKhasti, Location.trayRetjenu);
    _state.setPieceLocation(Piece.khastiRomans, land);
    
  }

  void cleopatraPhaseBattleOfActium() {
    if (_state.limitedEventCount(LimitedEvent.rome) == 0) {
      return;
    }
    if (_state.romanDebt > 0) {
      if (_subStep == 0) {
        logLine('### Battle of Actium');
        _subStep = 1;
      }
      if (_subStep == 1) {
        int die = isisRollD6();
        adjustRomanDebt(-die);
        if (_state.romanDebt == 0) {
          logLine('> Egypt fends off Rome.');
        }
      }
    }
    _phaseState = PhaseStateCleopatra(_state.romanDebt);
  }

  void cleopatraPhaseRomanAdvances() {
    if (_state.limitedEventCount(LimitedEvent.rome) == 0) {
      return;
    }
    final phaseState = _phaseState as PhaseStateCleopatra;
    while (phaseState.romanAttacksRemainingCount > 0) {
      khastiAdvanceOnPath(Path.retjenu);
      phaseState.romanAttacksRemainingCount -= 1;
    }
  }

  void cleopatraPhaseEnd() {
    if (_state.limitedEventCount(LimitedEvent.rome) == 0) {
      return;
    }
    logLine('# Egypt remains independent from Rome');
    int survivalPoints = calculateSurvivalPoints();
    _phaseState = null;
    throw GameOverException(GameResult.survival, survivalPoints);
  }

  void khastiAdvancesPhaseBegin() {
    if (_state.era == Era.oldKingdom) {
      return;
    }
    if (_state.manethoKhastiAdvancePaths(_state.manethoTotal!).isEmpty) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Khasti Advances Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Khasti Advances Phase');
  }

  void khastiAdvancesPhaseAdvance(int index) {
    if (_state.era == Era.oldKingdom) {
      return;
    }
    final paths = _state.manethoKhastiAdvancePaths(_state.manethoTotal!);
    if (index < paths.length) {
      khastiAdvanceOnPath(paths[index]);
    }
  }

  void khastiAdvancesPhaseAdvance0() {
    khastiAdvancesPhaseAdvance(0);
  }

  void khastiAdvancesPhaseAdvance1() {
    khastiAdvancesPhaseAdvance(1);
  }

  void khastiAdvancesPhaseAdvance2() {
    khastiAdvancesPhaseAdvance(2);
  }

  void khastiAdvancesPhaseAdvance3() {
    khastiAdvancesPhaseAdvance(3);
  }

  void khastiAdvancesPhaseAdvance4() {
    khastiAdvancesPhaseAdvance(4);
  }

  void actionPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Action Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Action Phase');
    final phaseState = PhaseStateAction();
    phaseState.militarySkill = _state.haveMilitarySkill;
    phaseState.religiousSkill = _state.haveReligiousSkill;
    phaseState.socialSkill = _state.haveSocialSkill;
    phaseState.ptahBonus = _state.presidingGod == Piece.godPtah;
    _phaseState = phaseState;
  }

  void actionPhaseActions() {
    final phaseState = _phaseState as PhaseStateAction;

    while (true) {
      if (_subStep == 0) {
        if (choicesEmpty()) {
          if (_state.era == Era.oldKingdom) {
            setPrompt('Select Land to Advance into or Action to perform');
          } else {
            setPrompt('Select Army to Attack or Action to perform');
          }
          if (_state.era == Era.oldKingdom) {
            if (_state.actionPointsAndGold >= 1 || phaseState.militarySkill) {
              if (_state.piecesInLocationCount(PieceType.medjaiTroops, Location.landMenNefer) > 0) {
                for (final path in Path.values) {
                  final locationType = _state.pathLocationType(path);
                  final pathTroops = _state.pathTroops(path);
                  final pathTroopsLocation = _state.pieceLocation(pathTroops);
                  if (!pathTroopsLocation.isType(locationType)) {
                    final land = _state.pathSequenceLand(path, 0);
                    locationChoosable(land);
                  }
                }
              }
              for (final path in Path.values) {
                final troops = _state.pathTroops(path);
                final location = _state.pieceLocation(troops);
                if (location != Location.landMenNefer && location.isType(LocationType.land)) {
                  final nextLand = _state.pathNextLand(path, location)!;
                  if (!_state.landIsCountry(nextLand)) {
                    locationChoosable(nextLand);
                  }
                }
              }
            }
            if (_state.piecesInLocationCount(PieceType.medjaiTroops, Location.trayMilitary) > 0) {
              choiceChoosable(Choice.buildTroops, _state.actionPointsAndGold >= 1);
            }
          } else {
            if (_state.actionPointsAndGold >= 1 || phaseState.militarySkill) {
              for (final path in Path.values) {
                final rivalDynasty = _state.pathRivalDynasty(path);
                if (rivalDynasty != null) {
                  locationChoosable(_state.pieceLocation(rivalDynasty));
                } else {
                  final khasti = _state.pathCurrentKhasti(path);
                  final land = _state.pieceLocation(khasti!);
                  if (land != Location.landMenNefer && !_state.landIsCountry(land)) {
                    locationChoosable(land);
                  } else {
                    if ([Location.literacyDemotic, Location.literacyCoptic].contains(_state.literacy) &&
                        _state.pieceInLocation(PieceType.egyptianRule, land) == null &&
                        _state.piecesInLocationCount(PieceType.egyptianRule, Location.trayPolitical) > 0 &&
                        _state.actionPointsAndGold >= (land == Location.countryTaSeti ? 4 : 3)) {
                      locationChoosable(land);
                    }
                  }
                }
              }
            }
          }
          if (!_state.currentEventIsCurrent(CurrentEvent.monotheism) && templeSepatCandidates(5).isNotEmpty) {
            choiceChoosable(Choice.templeSepat, templeSepatCandidates(_state.actionPointsAndGold).isNotEmpty);
            if (phaseState.religiousSkill) {
              choiceChoosable(Choice.templeSepatReligiousSkill, _state.actionPointsAndGold >= 1);
            }
            if (phaseState.ptahBonus && templeSepatCandidates(1).isNotEmpty) {
              choiceChoosable(Choice.templeSepatPtah, templeSepatCandidates(_state.actionPointsAndGold).isNotEmpty);
            }
            if (_state.era == Era.oldKingdom && _state.pharaohAvailable) {
              choiceChoosable(Choice.templeSepatPharaoh, _state.actionPointsAndGold >= 1);
            }
            if (_state.piecesInLocationCount(PieceType.maatUnused, Location.boxHouseOfLife) > 0) {
              for (final sepat in templeSepatCandidates(5)) {
                final land = _state.pieceLocation(sepat);
                if (_state.landIsNile(land)) {
                  choiceChoosable(Choice.templeSepatMaat, true);
                  break;
                }
              }
            }
          }
          if (colonizeCandidates.isNotEmpty) {
            choiceChoosable(Choice.colonize, _state.actionPointsAndGold >= 1);
          }
          if (_state.piecesInLocationCount(PieceType.megaprojectUnlooted, Location.trayPolitical) > 0) {
            if (_state.pharaohAvailable) {
              if (_state.piecesInLocationCount(PieceType.megaproject, Location.boxGreatPyramids) == 0 || _state.landIsControlled(Location.landWast)) {
                choiceChoosable(Choice.buildMegaproject, _state.actionPointsAndGold >= 3);
              }
            }
          }
          if (_state.pieceLocation(Piece.medjaiPolice) == Location.trayMilitary) {
            choiceChoosable(Choice.hireMedjaiPolice, _state.actionPointsAndGold >= 2);
          }
          if (_state.pieceLocation(Piece.heroesNubianArchers) == Location.trayMilitary) {
            choiceChoosable(Choice.buildNubianArchers, _state.gold >= 2);
          } else if (_state.pieceLocation(Piece.heroesNubianArchers) != Location.flipped && !phaseState.nubianArchersMoved) {
            if (moveNubianArchersCandidates(3).isNotEmpty) {
              choiceChoosable(Choice.moveNubianArchers, moveNubianArchersCandidates(_state.actionPointsAndGold).isNotEmpty);
            }
          }
          if (_state.era == Era.middleKingdom) {
            if (wallsOfTheRulerCandidates.isNotEmpty && _state.piecesInLocationCount(PieceType.wallsOfTheRuler, Location.trayMilitary) > 0) {
              final candidates = wallsOfTheRulerCandidates;
              int minimumCost = 6;
              for (final land in [Location.landSwenet, Location.landWaysOfHorus]) {
                if (candidates.contains(land)) {
                  minimumCost = 5;
                  break;
                }
              }
              choiceChoosable(Choice.buildWallsOfTheRuler, _state.actionPointsAndGold >= minimumCost);
            }
          }
          if (_state.literacy == Location.literacyHieratic) {
            if (_state.piecesInLocationCount(PieceType.maatUnused, Location.trayPolitical) > 0) {
              int maatCost = _state.haveReligiousSkill ? 4 : 5;
              choiceChoosable(Choice.buyMaat, _state.actionPointsAndGold >= maatCost);
            }
          }
          if (_state.piecesInLocationCount(PieceType.maatUnused, Location.boxHouseOfLife) > 0) {
            if (undermineRivalDynastyCandidates.isNotEmpty) {
              choiceChoosable(Choice.undermineRivalDynasty, true);
            }
            if (boostMoraleCandidates.isNotEmpty) {
              choiceChoosable(Choice.boostMorale, true);
            }
          }
          if (_state.era == Era.newKingdom) {
            choiceChoosable(Choice.marriage, _state.actionPointsAndGold >= 2);
          }
          if (_state.pieceLocation(Piece.israeln1) == Location.countryRetjenu) {
            choiceChoosable(Choice.reorientIsrael, _state.actionPointsAndGold >= 1);
          }
          if ([Era.newKingdom, Era.latePeriod].contains(_state.era)) {
            if (_state.pieceLocation(Piece.heroesMeraFleet) == Location.trayMilitary) {
              int fleetCost = _state.landIsControlled(Location.landSharuhen) ? 2 : 4;
              choiceChoosable(Choice.buildMeraFleet, _state.gold >= fleetCost);
            } else if (_state.pieceLocation(Piece.heroesMeraFleet) != Location.flipped && !phaseState.meraFleetMoved) {
              if (moveMeraFleetCandidates(4).isNotEmpty) {
                choiceChoosable(Choice.moveMeraFleet, moveMeraFleetCandidates(_state.actionPointsAndGold).isNotEmpty);
              }
            }
          }
          if (_state.romanDebt == 0) {
            int literacyCost = _state.presidingGod == Piece.godThoth ? 4 : 5;
            switch (_state.literacy) {
            case Location.literacyHieroglyphic:
              if (_state.era != Era.oldKingdom) {
                choiceChoosable(Choice.advanceLiteracy, _state.actionPointsAndGold >= literacyCost);
              }
            case Location.literacyHieratic:
              if (_state.era != Era.middleKingdom) {
                choiceChoosable(Choice.advanceLiteracy, _state.actionPointsAndGold >= literacyCost);
              }
            case Location.literacyDemotic:
              if (_state.pieceLocation(Piece.alexandria) == Location.boxAlexandria) {
                choiceChoosable(Choice.advanceLiteracy, _state.actionPointsAndGold >= literacyCost);
              }
            case Location.literacyCoptic:
            default:
            }
          }

          if (_state.pieceLocation(Piece.highPriests) == Location.landWast) {
            choiceChoosable(Choice.suppressHighPriests, _state.actionPointsAndGold >= 1);
          }

          if (withdrawFromCountryCandidates.isNotEmpty) {
            choiceChoosable(Choice.withdrawFromCountry, true);
          }

          if (_state.pieceLocation(Piece.hebrewPeople) == Location.landMenNefer && !phaseState.hebrewIncome) {
            choiceChoosable(Choice.hebrewIncome, _state.actionPoints < _state.actionPointLimit);
          }
          if (_state.pieceLocation(Piece.alexandria) == Location.boxAlexandria) {
            if (!phaseState.alexandriaIncome) {
              choiceChoosable(Choice.alexandriaIncome, _state.actionPoints < _state.actionPointLimit);
            }
            choiceChoosable(Choice.borrowFromRome, _state.actionPoints < _state.actionPointLimit);
          }
          if (phaseState.socialSkill) {
            choiceChoosable(Choice.socialSkillIncome, _state.actionPoints < _state.actionPointLimit);
          }
          if (_state.pieceInLocation(PieceType.okToLoot, Location.boxHeroes) != null) {
            if (!phaseState.megaprojectLooted && lootMegaprojectCandidates.isNotEmpty) {
              choiceChoosable(Choice.lootMegaproject, _state.actionPoints < _state.actionPointLimit);
            }
            if (_state.pieceLocation(Piece.greeks) == Location.landMenNefer) {
              choiceChoosable(Choice.plunderGreeks, _state.actionPointsAndGold >= 1 && _state.actionPoints < _state.actionPointLimit);
            }
            if (_state.pieceLocation(Piece.jews) == Location.landMenNefer) {
              choiceChoosable(Choice.plunderJews, _state.actionPointsAndGold >= 1 && _state.actionPoints < _state.actionPointLimit);
            }
          }

          choiceChoosable(Choice.next, true);
          throw PlayerChoiceException();
        }

        if (checkChoiceAndClear(Choice.next)) {
          return;
        }
        
        if (checkChoiceAndClear(Choice.buildTroops)) {
          logLine('### Recruit Medjai Troops');
          spendActionPoints(1);
          final troops = _state.piecesInLocation(PieceType.medjaiTroops, Location.trayMilitary);
          logLine('> Medjai Troops are built in Men-Nefer.');
          _state.setPieceLocation(troops[0], Location.landMenNefer);
        } else if (checkChoice(Choice.templeSepat) || checkChoice(Choice.templeSepatReligiousSkill) || checkChoice(Choice.templeSepatPtah) || checkChoice(Choice.templeSepatPharaoh) || checkChoice(Choice.templeSepatMaat)) {
          phaseState.templeSepatUseReligiousSkill = checkChoice(Choice.templeSepatReligiousSkill);
          phaseState.templeSepatUsePtah = checkChoice(Choice.templeSepatPtah);
          phaseState.templeSepatUsePharaoh = checkChoice(Choice.templeSepatPharaoh);
          phaseState.templeSepatUseMaat = checkChoice(Choice.templeSepatMaat);
          clearChoices();
          _subStep = 1;
        } else if (checkChoiceAndClear(Choice.colonize)) {
          _subStep = 3;
        } else if (checkChoiceAndClear(Choice.buildMegaproject)) {
          _subStep = 5;
        } else if (checkChoiceAndClear(Choice.hireMedjaiPolice)) {
          logLine('### Hire Medjai Police');
          spendActionPoints(2);
          _state.setPieceLocation(Piece.medjaiPolice, Location.boxRevival);
        } else if (checkChoiceAndClear(Choice.buildNubianArchers)) {
          logLine('### Recruit Nubian Archers');
          spendGold(2);
          _state.setPieceLocation(Piece.heroesNubianArchers, Location.boxHeroes);
        } else if (checkChoiceAndClear(Choice.buildMeraFleet)) {
          logLine('### Build Mera Fleet');
          int fleetCost = _state.landIsControlled(Location.landSharuhen) ? 2 : 4;
          spendGold(fleetCost);
          _state.setPieceLocation(Piece.heroesMeraFleet, Location.boxHeroes);
        } else if (checkChoiceAndClear(Choice.buildWallsOfTheRuler)) {
          _subStep = 6;
        } else if (checkChoiceAndClear(Choice.moveNubianArchers)) {
          _subStep = 15;
        } else if (checkChoiceAndClear(Choice.moveMeraFleet)) {
          _subStep = 16;
        } else if (checkChoiceAndClear(Choice.advanceLiteracy)) {
          int cost = _state.presidingGod == Piece.godThoth ? 4 : 5;
          logLine('### Advance Literacy');
          final newLiteracy = Location.values[_state.pieceLocation(Piece.literacy).index + 1];
          logLine('> ${newLiteracy.desc} script is introduced.');
          spendActionPoints(cost);
          _state.setPieceLocation(Piece.literacy, newLiteracy);
        } else if (checkChoiceAndClear(Choice.withdrawFromCountry)) {
          _subStep = 7;
        } else if (checkChoiceAndClear(Choice.buyMaat)) {
          logLine('### Buy Maʽat Tile');
          int cost = _state.haveReligiousSkill ? 4 : 5;
          spendActionPoints(cost);
          final maats = _state.piecesInLocation(PieceType.maatUnused, Location.trayPolitical);
          _state.setPieceLocation(maats[0], Location.boxHouseOfLife);
        } else if (checkChoiceAndClear(Choice.marriage)) {
          _subStep = 8;
        } else if (checkChoiceAndClear(Choice.reorientIsrael)) {
          logLine('### Reorient Israel');
          logLine('> Kingdom of Israel realigns with Egypt');
          spendActionPoints(1);
          _state.flipPiece(Piece.israeln1);
        } else if (checkChoiceAndClear(Choice.suppressHighPriests)) {
          logLine('### Suppress High Priests');
          logLine('> High Priests of Amun corruption is suppressed.');
          spendActionPoints(1);
          _state.setPieceLocation(Piece.highPriests, Location.trayEconomic);
        } else if (checkChoiceAndClear(Choice.undermineRivalDynasty)) {
          _subStep = 9;
        } else if (checkChoiceAndClear(Choice.boostMorale)) {
          _subStep = 11;
        } else if (checkChoiceAndClear(Choice.hebrewIncome)) {
          logLine('### Hebrew Supplemental Income');
          adjustActionPoints(1);
          phaseState.hebrewIncome = true;
        } else if (checkChoiceAndClear(Choice.alexandriaIncome)) {
          logLine('### Alexandria Supplemental Income');
          adjustActionPoints(1);
          phaseState.alexandriaIncome = true;
        } else if (checkChoiceAndClear(Choice.socialSkillIncome)) {
          logLine('### Social Skill Supplemental Income');
          adjustActionPoints(1);
          phaseState.socialSkill = false;
        } else if (checkChoiceAndClear(Choice.lootMegaproject)) {
          _subStep = 12;
        } else if (checkChoice(Choice.plunderGreeks) || checkChoice(Choice.plunderJews)) {
          final piece = checkChoice(Choice.plunderGreeks) ? Piece.greeks : Piece.jews;
          clearChoices();
          logLine('### Plunder ${piece.desc}');
          spendActionPoints(1);
          _state.flipPiece(piece);
          _subStep = 14;
        } else if (checkChoiceAndClear(Choice.borrowFromRome)) {
          logLine('### Borrow from Rome');
          int amount = _state.romanDebt == 0 ? 3 : 1;
          adjustRomanDebt(amount);
          adjustActionPoints(amount);
        } else {
          phaseState.selectedLand = selectedLocation()!;
          clearChoices();
          if (_state.era == Era.oldKingdom) {
            _subStep = 20;
          } else {
            _subStep = 30;
          }
        }
      }

      if (_subStep == 1) { // Temple Sepat
        if (choicesEmpty()) {
          setPrompt('Select Sepat to Temple');
          if (phaseState.templeSepatUsePtah) {
            for (final sepat in templeSepatPtahCandidates(_state.actionPointsAndGold)) {
              pieceChoosable(sepat);
            }
          } else {
            int budget = _state.actionPointsAndGold;
            if (phaseState.templeSepatUseReligiousSkill || phaseState.templeSepatUsePharaoh || phaseState.templeSepatUseMaat) {
              budget = 5;
            }
            for (final sepat in templeSepatCandidates(budget)) {
              if (!phaseState.templeSepatUseMaat || _state.landIsNile(_state.pieceLocation(sepat))) {
                pieceChoosable(sepat);
              }
            }
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          phaseState.templeSepatUseReligiousSkill = false;
          phaseState.templeSepatUsePtah = false;
          phaseState.templeSepatUsePharaoh = false;
          phaseState.templeSepatUseMaat = false;
          continue;
        }
        phaseState.selectedPiece = selectedPiece()!;
        clearChoices();
        logLine('### Temple Sepat');
        _subStep = 2;
      }
      if (_subStep == 2) { // Temple Sepat continued
        final sepat = phaseState.selectedPiece!;
        final value = _state.sepatValue(sepat);
        final land = _state.pieceLocation(sepat);
        final path = _state.landPath(land)!;
        if (phaseState.templeSepatUseMaat) {
          int die = isisRollD6();
          final maat = _state.piecesInLocation(PieceType.maatUnused, Location.boxHouseOfLife)[0];
          _state.flipPiece(maat);
          logLine('> Sepat Value: $value');
          int valueModifiers = 0;
          if (_state.pathRise(path)) {
            logLine('> Rise: +1');
            valueModifiers += 1;
          }
          if (_state.pathDecline(path)) {
            logLine('> Decline: -1');
            valueModifiers -= 1;
          }
          final total = value + valueModifiers;
          logLine('> Total: $total');
          if (die <= total) {
            logLine('> Temple is not built.');
            clearChoices();
            _subStep = 0;
            continue;
          }
        }
        final templedSepat = _state.pieceFlipSide(sepat)!;
        final god = _state.templedSepatGod(templedSepat);
        if (phaseState.templeSepatUseMaat) {
          logLine('> Temple dedicated to ${god.desc} is built in ${land.desc} using Maʽat.');
          phaseState.templeSepatUseMaat = false;
        } else if (phaseState.templeSepatUseReligiousSkill) {
          logLine('> Temple dedicated to ${god.desc} is built in ${land.desc} using Religious Skill.');
          spendActionPoints(1);
          phaseState.templeSepatUseReligiousSkill = false;
          phaseState.religiousSkill = false;
        } else if (phaseState.templeSepatUsePtah) {
          logLine('> Temple dedicated to ${god.desc} is built in ${land.desc} using Ptah Bonus.');
          if (god != Piece.godPtah) {
            spendActionPoints(1);
          }
          phaseState.templeSepatUsePtah = false;
          phaseState.ptahBonus = false;
        } else if (phaseState.templeSepatUsePharaoh) {
          logLine('> Pharaoh builds Temple dedicated to ${god.desc} in ${land.desc}.');
          spendActionPoints(1);
          phaseState.templeSepatUsePharaoh = false;
          _state.pharaohAvailable = false;
        } else {
          final path = _state.landPath(land)!;
          final modifier = _state.pathModifier(path);
          final cost = value + modifier;
          logLine('> Temple dedicated to ${god.desc} is built in ${land.desc}.');
          spendActionPoints(cost);
        }
        _state.setPieceLocation(templedSepat, land);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 3) { // Colonize - Select Land
        if (choicesEmpty()) {
          setPrompt('Select Land to Colonize');
          for (final land in colonizeCandidates) {
            locationChoosable(land);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        _subStep = 4;
      }

      if (_subStep == 4) { // Colonize - Choose Amount to Spend
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          _subStep = 0;
          continue;
        }
        if (selectedLocations().length < 2) {
          setPrompt('Select amount of Action Points to Spend');
          for (int i = 1; i <= _state.actionPointsAndGold; ++i) {
            locationChoosable(_state.granaryBox(i));
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        Location? land;
        int? amount;
        for (final location in selectedLocations()) {
          if (location.isType(LocationType.land)) {
            land = location;
          } else if (location.isType(LocationType.granary)) {
            amount = location.index - Location.granary0.index;
          }
        }
        clearChoices();
        logLine('### Colonize ${land!.desc}');
        spendActionPoints(amount!);
        final path = _state.landPath(land)!;
        final sepat = drawSepat();
        final value = _state.sepatValue(sepat);
        logLine('> Sepat Value: $value');
        int valueModifiers = 0;
        if (_state.pathRise(path)) {
          logLine('> Rise: +1');
          valueModifiers += 1;
        }
        if (_state.pathDecline(path)) {
          logLine('> Decline: -1');
          valueModifiers -= 1;
        }
        final total = value + valueModifiers;
        logLine('> Total: $total');
        if (amount > total) {
          logLine('> ${land.desc} is successfully colonized.');
          discoverSepat(land, sepat);
        } else {
          logLine('> Colonization attempt fails.');
        }
        _subStep = 0;
      }

      if (_subStep == 5) { // Build Megaproject
        if (choicesEmpty()) {
          setPrompt('Choose how many Revival Chits to purchase');
          for (int i = 0; i <= 2 && i <= _state.actionPointsAndGold - 3; ++i) {
            locationChoosable(_state.granaryBox(i));
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final amount = selectedLocation()!.index - Location.granary0.index;
        clearChoices();
        Piece? megaproject;
        for (final project in PieceType.megaprojectUnlooted.pieces) {
          if (_state.pieceLocation(project) == Location.trayPolitical) {
            megaproject = project;
            break;
          }
        }
        logLine('### Build ${megaproject!.desc}');
        spendActionPoints(3);
        _state.pharaohAvailable = false;
        _state.setPieceLocation(megaproject, _state.megaprojectBox(megaproject));
        if (amount > 0) {
          if (amount == 2) {
            logLine('> $amount Revival Chits are purchased.');
          } else {
            logLine('> A Revival Chit is purchased.');
          }
          spendActionPoints(amount);
          final revivalChits = _state.piecesInLocation(PieceType.revival, Location.trayRevival);
          for (int i = 0; i < amount; ++i) {
            _state.setPieceLocation(revivalChits[i], Location.boxRevival);
          }
        }
        _subStep = 0;
      }

      if (_subStep == 6) { // Build Walls of the Ruler
        const cheaperLands = [Location.landSwenet, Location.landWaysOfHorus];
        if (choicesEmpty()) {
          setPrompt('Select Walls of the Ruler Land');
          for (final land in wallsOfTheRulerCandidates) {
            int cost = cheaperLands.contains(land) ? 5 : 6;
            if (_state.actionPointsAndGold >= cost) {
              locationChoosable(land);
            }
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final land = selectedLocation()!;
        logLine('### Build Walls of the Ruler');
        logLine('> Walls of the Ruler are built in ${land.desc}.');
        int cost = cheaperLands.contains(land) ? 5 : 6;
        spendActionPoints(cost);
        final walls = _state.piecesInLocation(PieceType.wallsOfTheRuler, Location.trayMilitary);
        _state.setPieceLocation(walls[0], land);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 7) { // Withdraw from Country
        if (choicesEmpty()) {
          setPrompt('Select Country to withdraw from');
          for (final land in withdrawFromCountryCandidates) {
            locationChoosable(land);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final country = selectedLocation()!;
        logLine('### Withdraw from Country');
        logLine('> Egypt withdraws from ${country.desc}.');
        final egyptianRule = _state.pieceInLocation(PieceType.egyptianRule, country)!;
        _state.setPieceLocation(egyptianRule, Location.trayPolitical);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 8) { // Marriage
        if (choicesEmpty()) {
          setPrompt('Select Country make Marriage alliance with');
          for (final path in Path.values) {
            final country = _state.pathHomeCountry(path);
            locationChoosable(country);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final country = selectedLocation()!;
        logLine('### Dynastic Marriage');
        logLine('> Egypt makes dynastic Marriage with ${country.desc}.');
        spendActionPoints(2);
        _state.setPieceLocation(Piece.marriage, country);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 9) { // Undermine Rival Dynasty
        if (choicesEmpty()) {
          setPrompt('Select Rival Dynasty to undermine');
          for (final rivalDynasty in undermineRivalDynastyCandidates) {
            pieceChoosable(rivalDynasty);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        phaseState.selectedPiece = selectedPiece()!;
        final land = _state.pieceLocation(phaseState.selectedPiece!);
        logLine('#### Undermine Rival Dynasty in ${land.desc}');
        clearChoices();
        _subStep = 10;
      }
      if (_subStep == 10) { // Undermine Rival Dynasty continued
        final rivalDynasty = phaseState.selectedPiece!;
        phaseState.selectedPiece = null;
        final land = _state.pieceLocation(rivalDynasty);
        final path = _state.landPath(land)!;
        final value = _state.rivalDynastyStrength(rivalDynasty);
        int die = isisRollD6();
        final maat = _state.piecesInLocation(PieceType.maatUnused, Location.boxHouseOfLife)[0];
        _state.flipPiece(maat);
        logLine('> Rival Dynasty Strength: $value');
        int valueModifiers = 0;
        if (_state.pathRise(path)) {
          logLine('> Rise: +1');
          valueModifiers += 1;
        }
        if (_state.pathDecline(path)) {
          logLine('> Decline: -1');
          valueModifiers -= 1;
        }
        final total = value + valueModifiers;
        logLine('> Total: $total');
        if (die > total) {
          logLine('> Rival Dynasty in ${land.desc} collapses.');
          _state.setPieceLocation(rivalDynasty, Location.trayMilitary);
        } else {
          logLine('> Rival Dynasty remains in power.');
        }
        _subStep = 0;
      }

      if (_subStep == 11) { // Boost Morale
        if (choicesEmpty()) {
          setPrompt('Select Sepat for Morale Boost');
          for (final sepat in boostMoraleCandidates) {
            pieceChoosable(sepat);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final sepat = selectedPiece()!;
        final land = _state.pieceLocation(sepat);
        logLine('#### Boost Morale');
        logLine('> Morale is Boosted by Maʽat in ${land.desc}.');
        _state.setPieceLocation(_state.piecesInLocation(PieceType.maatUnused, Location.boxHouseOfLife)[0], land);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 12) { // Loot Megaproject
        if (choicesEmpty()) {
          setPrompt('Select Megaproject to Loot');
          for (final megaproject in lootMegaprojectCandidates) {
            pieceChoosable(megaproject);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final megaproject = selectedPiece()!;
        phaseState.megaprojectLooted = true;
        clearChoices();
        logLine('### Loot ${megaproject.desc}');
        _state.flipPiece(megaproject);
        _subStep = 13;
      }
      if (_subStep == 13) { // Loot Megaproject roll
        int die = isisRollD6();
        adjustActionPoints(die);
        _subStep = 0;
      }

      if (_subStep == 14) { // Plunder Greeks/Jews
        int die = isisRollD6();
        if (die >= 3) {
          logLine('> Plundering is successful.');
          _state.adjustActionPoints(die);
        } else {
          logLine('> Plundering is unsuccessful.');
        }
        _subStep = 0;
      }

      if (_subStep == 15) { // Move Nubian Archers
        if (choicesEmpty()) {
          setPrompt('Select Land to move Nubian Archers to');
          for (final land in moveNubianArchersCandidates(_state.actionPointsAndGold)) {
            locationChoosable(land);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final land = selectedLocation()!;
        logLine('### Move Nubian Archers');
        logLine('> Nubian Archers move to ${land.desc}.');
        int cost = land == Location.landMenNefer ? 3 : 1;
        spendActionPoints(cost);
        _state.setPieceLocation(Piece.heroesNubianArchers, land);
        phaseState.nubianArchersMoved = true;
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 16) { // Move Mera Fleet
        if (choicesEmpty()) {
          setPrompt('Select Land to move Mera Fleet to');
          for (final land in moveMeraFleetCandidates(_state.actionPointsAndGold)) {
            locationChoosable(land);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final land = selectedLocation()!;
        logLine('### Move Mera Fleet');
        logLine('> Mera Fleet moves to ${land.desc}.');
        int baseCost = _state.pieceLocation(Piece.heroesMeraFleet) == Location.boxHeroes && !_state.landIsControlled(Location.landSharuhen) ? 2 : 1;
        int cost = baseCost + (land == Location.landMenNefer ? 2 : 0);
        spendActionPoints(cost);
        _state.setPieceLocation(Piece.heroesMeraFleet, land);
        phaseState.meraFleetMoved = true;
        clearChoices();
        _subStep = 0;
      }

      if (_subStep >= 20 && _subStep <= 22) { // Medjai Troops Advance
        final land = phaseState.selectedLand!;
        final path = _state.landPath(land)!;
        if (_subStep == 20) {
          logLine('### Medjai Troops Advance');
          if (phaseState.militarySkill) {
            phaseState.militarySkill = false;
            logLine('> Military Skill Free Attack');
          } else {
            spendActionPoints(1);
          }
          logLine('> Medjai Troops Advance into ${land.desc}');
        }
        final sepat = _state.pieceInLocation(PieceType.sepat, land);
        if (sepat != null && sepat.isType(PieceType.sepatUntempled)) {
          int value = _state.sepatValue(sepat);
          if (_subStep == 20) {
            logLine('> Sepat Value: $value');
          }
          int valueModifiers = 0;
          if (_state.pathRise(path)) {
            if (_subStep == 20) {
              logLine('> Rise: +1');
            }
            valueModifiers += 1;
          }
          if (_state.pathDecline(path)) {
            if (_subStep == 20) {
              logLine('> Decline: -1');
            }
            valueModifiers -= 1;
          }
          int valueTotal = value + valueModifiers;
          _subStep = 21;
          int die = isisRoll2D6();
          if (die <= valueTotal) {
            logLine('> Sepat repels Medjai Troops Advance.');
            phaseState.selectedLand = null;
            _subStep = 0;
            continue;
          }
        } else {
          _subStep = 21;
        }
        if (_subStep == 21) {
          final troops = _state.pathTroops(path);
          if (_state.pieceLocation(troops) == Location.trayMilitary) {
            final menNeferTroops = _state.piecesInLocation(PieceType.medjaiTroops, Location.landMenNefer);
            _state.setPieceLocation(menNeferTroops[0], Location.trayMilitary);
          }
          _state.setPieceLocation(troops, land);
          _subStep = 22;
        }
        if (_subStep == 22) {
          final nextLand = _state.pathNextLand(path, land)!;
          if (_state.landSupportsSepat(nextLand, false)) {
            if (_state.piecesInLocationCount(PieceType.sepat, nextLand) == 0) {
              final nextSepat = drawSepatForLand(nextLand);
              final goods = _state.sepatGoods(nextSepat);
              logLine('> ${goods.desc} is discovered in ${nextLand.desc}.');
              _state.setPieceLocation(nextSepat, nextLand);
            }
          }
        }
        phaseState.selectedLand = null;
        _subStep = 0;
      }

      if (_subStep == 30) { // Attack Khasti or Rival Dynasty - select attack pieces
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          _subStep = 0;
          continue;
        }
        final land = phaseState.selectedLand!;
        int cost = 1;
        if (_state.landIsCountry(land)) {
          cost = land == Location.countryTaSeti ? 4 : 3;
        }
        if (!checkChoice(Choice.attack)) {
          setPrompt('Involve Pharaoh, Hero or Chariots, then Attack');
          if (_state.pharaohAvailable && !selectedPieces().contains(Piece.pharaoh)) {
            pieceChoosable(Piece.pharaoh);
          }
          if (!phaseState.nubianArchersMoved && !selectedPieces().contains(Piece.heroesNubianArchers) && !selectedPieces().contains(Piece.heroesMeraFleet)) {
            final nubianArchersLocation = _state.pieceLocation(Piece.heroesNubianArchers);
            if (nubianArchersLocation.isType(LocationType.land) || nubianArchersLocation == Location.boxHeroes) {
              pieceChoosable(Piece.heroesNubianArchers);
            }
          }

          if (_state.landIsNile(land) && !phaseState.meraFleetMoved && !selectedPieces().contains(Piece.heroesMeraFleet) && !selectedPieces().contains(Piece.heroesNubianArchers)) {
            final meraFleetLocation = _state.pieceLocation(Piece.heroesMeraFleet);
            if (meraFleetLocation.isType(LocationType.land) || meraFleetLocation == Location.boxHeroes) {
              int additionalCost = meraFleetLocation == Location.boxHeroes && !_state.landIsControlled(Location.landSharuhen) ? 1 : 0;
              if (_state.actionPointsAndGold >= cost + additionalCost) {
                pieceChoosable(Piece.heroesMeraFleet);
              }
            }
          }
          final chariots = _state.pieceInLocation(PieceType.chariots, Location.landMenNefer);
          if (chariots != null && !selectedPieces().contains(chariots)) {
            pieceChoosable(chariots);
          }
          choiceChoosable(Choice.attack, true);
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        phaseState.attackPieces = List<Piece>.from(selectedPieces());
        clearChoices();
        _subStep = 31;
      }
      if (_subStep >= 31 && _subStep <= 32) { // Attack
        final land = phaseState.selectedLand!;
        final path = _state.landPath(land);
        final army = _state.pieceInLocation(PieceType.rivalDynasty, land) ?? _state.pieceInLocation(PieceType.khasti, land)!;
        bool pharaoh = phaseState.attackPieces.contains(Piece.pharaoh);
        bool nubianArchers = phaseState.attackPieces.contains(Piece.heroesNubianArchers);
        bool meraFleet = phaseState.attackPieces.contains(Piece.heroesMeraFleet);
        bool chariotsP1 = phaseState.attackPieces.contains(Piece.heroesChariotsP1);
        bool chariotsP2 = phaseState.attackPieces.contains(Piece.heroesChariotsP2);
        if (_subStep == 31) {
          if (pharaoh) {
            logLine('### Pharaoh leads Campaign against ${army.desc} in ${land.desc}');
          } else if (nubianArchers) {
            logLine('### Nubian Archers Attack ${army.desc} in ${land.desc}');
          } else if (meraFleet) {
            logLine('### Mera Fleet Attacks ${army.desc} in ${land.desc}');
          } else if (chariotsP1 || chariotsP2) {
            logLine('### Chariots spearhead the Attack on ${army.desc} in ${land.desc}');
          } else {
            logLine('### Attack ${army.desc} in ${land.desc}');
          }
          int cost = 1;
          if (_state.landIsCountry(land)) {
            cost = land == Location.countryTaSeti ? 4 : 3;
          }
          if (meraFleet) {
            final meraFleetLocation = _state.pieceLocation(Piece.heroesMeraFleet);
            if (meraFleetLocation == Location.boxHeroes && !_state.landIsControlled(Location.landSharuhen)) {
              cost += 1;
            }
          }
          if (cost == 1 && phaseState.militarySkill) {
            logLine('> Military Skill Free Attack.');
            phaseState.militarySkill = false;
          } else {
            spendActionPoints(cost);
          }
        }

        Piece? chariots = _state.pieceLocation(Piece.heroesChariotsP1) != Location.flipped ? Piece.heroesChariotsP1 : Piece.heroesChariotsP2;
        if (!chariotsP1 && !chariotsP2) {
          if (_state.chariotsPath != path) {
            chariots = null;
          }
        }

        int value = army.isType(PieceType.khasti) ? _state.khastiValue(army) : _state.rivalDynastyStrength(army);
        if (_subStep == 31) {
          logLine('> ${army.desc} Value: $value');
        }
        int valueModifiers = 0;
        if (path != null && _state.pathRise(path)) {
          if (_subStep == 31) {
            logLine('> Rise: +1');
          }
          valueModifiers += 1;
        }
        if (path != null && _state.pathDecline(path)) {
          if (_subStep == 31) {
            logLine('> Decline: -1');
          }
          valueModifiers -= 1;
        }
        int valueTotal = value + valueModifiers;
        _subStep = 32;
        int die = pharaoh ? isisRoll2D6() : isisRollD6();
        int dieModifiers = 0;
        if (nubianArchers) {
          logLine('> Nubian Archers: +1');
          dieModifiers += 1;
        }
        if (meraFleet) {
          logLine('> Mera Fleet: +1');
          dieModifiers += 1;
        }
        if (chariots == Piece.heroesChariotsP1) {
          logLine('> Chariots: +1');
          dieModifiers += 1;
        } else if (chariots == Piece.heroesChariotsP2) {
          logLine('> Chariots: +2');
          dieModifiers += 2;
        }
        if (_state.haveIronWeapons) {
          logLine('> Iron: +1');
          dieModifiers += 1;
        }
        if (path == Path.retjenu && _state.pieceLocation(Piece.israeln1) == Location.countryRetjenu) {
          logLine('> Israel: -1');
          dieModifiers -= 1;
        }
        int dieTotal = die + dieModifiers;
        if (dieTotal > valueTotal) {
          if (army.isType(PieceType.rivalDynasty)) {
            logLine('> Rival Dynasty is defeated.');
            _state.setPieceLocation(army, Location.trayMilitary);
          } else {
            if (_state.landIsCountry(land)) {
              logLine('> Invasion of ${land.desc} is successful.');
              logLine('> Egyptian Rule is established in ${land.desc}.');
              final egyptianRules = _state.piecesInLocation(PieceType.egyptianRule, Location.trayPolitical);
              _state.setPieceLocation(egyptianRules[0], land);
            } else {
              logLine('> Attack on ${army.desc} is successful.');
              final retreatLand = _state.pathNextLand(path!, land)!;
              logLine('> ${army.desc} retreats to ${retreatLand.desc}.');
              _state.setPieceLocation(army, retreatLand);
            }
          }
        } else {
          logLine('> Attack is repulsed.');
        }
        if (pharaoh) {
          _state.pharaohAvailable = false;
        }
        if (nubianArchers) {
          phaseState.nubianArchersMoved = true;
          _state.setPieceLocation(Piece.heroesNubianArchersBack, Location.boxHeroes);
        }
        if (meraFleet) {
          phaseState.meraFleetMoved = true;
          _state.setPieceLocation(Piece.heroesMeraFleetBack, Location.boxHeroes);
        }
        if (chariotsP1 || chariotsP2) {
          _state.setPieceLocation(chariots!, Location.boxHeroes);
        } else if (chariots != null && die == 1) {
          logLine('> Chariots suffer losses.');
          _state.setPieceLocation(Piece.heroesChariotsP1, Location.boxHeroes);
        }
        phaseState.selectedLand = null;
        phaseState.attackPieces = <Piece>[];
        _subStep = 0;
      }
    }
  }

  void actionPhaseEnd() {
    _phaseState = null;
  }

  void endOfTurnPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to End of Turn Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## End of Turn Phase');
    _phaseState = PhaseStateEndOfTurn();
  }

  void endOfTurnPhaseDegradation() {
    final phaseState = _phaseState as PhaseStateEndOfTurn;
    if (_state.era == Era.oldKingdom) {
      return;
    }
    if (_state.piecesInLocationCount(PieceType.khasti, Location.landMenNefer) > 0) {
      return;
    }
    if (_subStep == 0) {
      for (final path in Path.values) {
        final locationType = _state.pathLocationType(path);
        final khastiType = _state.pathKhastiType(path);
        int controlledLandCount = _state.pathControlledLandCount(path);
        Piece? army;
        for (int sequence = controlledLandCount; sequence < locationType.count - 1; ++sequence) {
          final land = _state.pathSequenceLand(path, sequence);
          Piece? landArmy = _state.pieceInLocation(PieceType.rivalDynasty, land) ?? _state.pieceInLocation(khastiType, land);
          if (landArmy != null) {
            army = landArmy;
          }
          if (landArmy == null || landArmy.isType(PieceType.khasti)) {
            if (_state.pieceInLocation(PieceType.maat, land) == null) {
              final sepat = _state.pieceInLocation(PieceType.sepat, land);
              if (sepat != null) {
                if (sepat.isType(PieceType.sepatTempled) || (army!.isType(PieceType.khasti) && _state.khastiIsBarbarian(army))) {
                  phaseState.degradeSepats.add(sepat);
                }
              }
            }
          }
        }
      }
      if (phaseState.degradeSepats.isEmpty) {
        return;
      }
      logLine('### Degrade Sepats');
      _subStep = 1;
    }
    if (_subStep == 1) {
      while (phaseState.degradeSepats.isNotEmpty && _state.actionPointsAndGold >= 1) {
        if (choicesEmpty()) {
          setPrompt('Select Sepat to protect from Degradation');
          for (final sepat in phaseState.degradeSepats) {
            pieceChoosable(sepat);
          }
          choiceChoosable(Choice.next, true);
          throw PlayerChoiceException();
        }
        if (selectedPiece() != null) {
          final sepat = selectedPiece()!;
          final land = _state.pieceLocation(sepat);
          logLine('> Protect ${land.desc} from Degradation');
          spendActionPoints(1);
          phaseState.degradeSepats.remove(sepat);
          clearChoices();
        }
        if (checkChoiceAndClear(Choice.next)) {
          break;
        }
      }
      _subStep = 2;
    }

    if (_subStep == 2) {
      for (final sepat in phaseState.degradeSepats) {
        final land = _state.pieceLocation(sepat);
        if (sepat.isType(PieceType.sepatTempled)) {
          final god = _state.templedSepatGod(sepat);
          logLine('> Temple dedicated to ${god.desc} in ${land.desc} falls into disuse.');
          _state.flipPiece(sepat);
        } else {
          final path = _state.landPath(land)!;
          final khasti = _state.pathCurrentKhasti(path)!;
          logLine('> Sepat in ${land.desc} is devasted by ${khasti.desc}.');
          _state.setPieceLocation(sepat, Location.cupSepat);
        }
      }
      phaseState.degradeSepats.clear();
    }
  }

  void endOfTurnPhaseReturnInTriumph() {
    _state.pharaohAvailable = true;
    final relocateHeroes = <Piece>[];
    for (final hero in [Piece.heroesNubianArchersBack, Piece.heroesMeraFleetBack]) {
      final location = _state.pieceLocation(hero);
      if (location != Location.flipped) {
        _state.flipPiece(hero);
      }
    }
    for (final hero in [Piece.heroesNubianArchers, Piece.heroesMeraFleet]) {
      if (_state.pieceLocation(hero) == Location.landMenNefer) {
        relocateHeroes.add(hero);
      }
    }
    Piece? chariots = _state.pieceLocation(Piece.heroesChariotsP1) != Location.flipped ? Piece.heroesChariotsP1 : Piece.heroesChariotsP2;
    final chariotsLocation = _state.pieceLocation(chariots);
    if ([Location.landMenNefer, Location.trayMilitary].contains(chariotsLocation)) {
      chariots = null;
    }
    if (_subStep == 0) {
      if (relocateHeroes.isEmpty && chariots == null) {
        return;
      }
      logLine('### Return in Triumph');
      _subStep = 1;
    }
    if (_subStep == 1) {
      for (final hero in relocateHeroes) {
        final relocationCandidates = heroRelocationCandidates(hero);
        if (relocationCandidates.isEmpty) {
          logLine('> ${hero.desc} returns to the Heroes Box');
          _state.setPieceLocation(hero, Location.boxHeroes);
        } else {
          if (choicesEmpty()) {
            setPrompt('Select Land for ${hero.desc}');
            for (final land in relocationCandidates) {
              locationChoosable(land);
            }
            throw PlayerChoiceException();
          }
          final land = selectedLocation()!;
          logLine('> ${hero.desc} moves to ${land.desc}.');
          _state.setPieceLocation(hero, land);
          clearChoices();
        }
      }
      _subStep = 2;
    }
    if (_subStep == 2) {
      if (chariots != null) {
        if (chariotsLocation != Location.boxHeroes) {
          logLine('> ${chariots.desc} moves to ${Location.landMenNefer.desc}.');
          _state.setPieceLocation(chariots, Location.landMenNefer);
        } else {
          if (choicesEmpty()) {
            setPrompt('Build ${chariots.desc}?');
            choiceChoosable(Choice.yes, _state.actionPointsAndGold >= 1);
            choiceChoosable(Choice.no, true);
            throw PlayerChoiceException();
          }
          if (checkChoice(Choice.yes)) {
            logLine('> ${chariots.desc} are built.');
            spendActionPoints(1);
            _state.setPieceLocation(chariots, Location.landMenNefer);
          }
          clearChoices();
        }
      }
      _subStep = 3;
    }
    if (_subStep == 3) {
      if (_state.pieceLocation(Piece.heroesChariotsP1) == Location.landMenNefer) {
        if (choicesEmpty()) {
          setPrompt('Strengthen Chariot force?');
          choiceChoosable(Choice.yes, _state.actionPointsAndGold >= 2);
          choiceChoosable(Choice.no, true);
          throw PlayerChoiceException();
        }
        if (checkChoice(Choice.yes)) {
          logLine('> Chariot force is strengthened.');
          spendActionPoints(2);
          _state.flipPiece(Piece.heroesChariotsP1);
        }
        clearChoices();
      }
    }
  }

  void endOfTurnPhaseRemoveModifiers() {
    if (_subStep == 0) {
      _state.setPieceLocation(Piece.rise, Location.boxRiseDeclineNone);
      _subStep = 1;
    }
    while (_subStep >= 1) {
      if (choicesEmpty()) {
        for (final maat in PieceType.maat.pieces) {
          final location = _state.pieceLocation(maat);
          if (location == Location.boxHouseOfLife || location.isType(LocationType.land)) {
            pieceChoosable(maat);
          }
        }
        if (choosablePieceCount == 0) {
          return;
        }
        if (_subStep == 1) {
          logLine('### Move Maʽat Tiles');
          _subStep = 2;
        }
        setPrompt('Select Maʽat Tile to Move');
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      if (checkChoice(Choice.next)) {
        clearChoices();
        return;
      }
      final maat = selectedPiece()!;
      final oldLocation = _state.pieceLocation(maat);
      final location = selectedLocation();
      if (location == null) {
        setPrompt('Select Maʽat Tile destination');
        if (oldLocation != Location.boxHouseOfLife) {
          locationChoosable(Location.boxHouseOfLife);
        }
        for (final path in Path.values) {
          int controlledLandCount = _state.pathControlledLandCount(path);
          for (int sequence = 0; sequence < controlledLandCount; ++sequence) {
            final land = _state.pathSequenceLand(path, sequence);
            if (land != oldLocation) {
              locationChoosable(land);
            }
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      logLine('> Maʽat Tile Moves from ${oldLocation.desc} to ${location.desc}.');
      _state.setPieceLocation(maat, location);
      clearChoices();
    }
  }

  void endOfTurnPhaseSaveGold() {
    if (_state.actionPoints == 0) {
      return;
    }
    logLine('### Save Gold');
    int amount = _state.currentEventIsCurrent(CurrentEvent.goldenAge) ? _state.actionPoints : _state.actionPoints ~/ 2;
    adjustGold(amount);
    adjustActionPoints(-_state.actionPoints);
  }

  void endOfTurnPhaseEnd() {
    _phaseState = null;
  }

  void turnEnd() {
    _state.clearCurrentEvents();
    _state.manethoTotal = null;
    _state.advanceTurn();
  }

  void playInSequence() {

    final stepHandlers = [
      turnBegin,
      dynastyPhaseBegin,
      dynastyPhaseDrawDynastyTile,
      dynastyPhaseOkToLoot,
      nilePhaseBegin,
      nilePhaseRoll,
      nilePhaseGold,
      nilePhaseEmergency,
      nilePhaseHighPriests,
      nilePhaseEnd,
      godPhaseBegin,
      godPhaseSelect,
      godPhaseRiseDecline,
      godPhaseRevolt,
      godPhaseEnd,
      khastiEvolutionPhaseBegin,
      khastiEvolutionPhaseEvolution0,
      khastiEvolutionPhaseAdvance0,
      khastiEvolutionPhaseEvolution1,
      khastiEvolutionPhaseAdvance1,
      khastiEvolutionPhaseEvolution2,
      khastiEvolutionPhaseAdvance2,
      khastiEvolutionPhaseEnd,
      chroniclesOfManethoPhaseBegin,
      chroniclesOfManethoPhaseRoll,
      chroniclesOfManethoPhaseEvent0,
      chroniclesOfManethoPhaseEvent1,
      chroniclesOfManethoPhaseEvent2,
      chroniclesOfManethoPhaseEnd,
      cleopatraPhaseBegin,
      cleopatraPhaseKhastiEvolution,
      cleopatraPhaseBattleOfActium,
      cleopatraPhaseRomanAdvances,
      cleopatraPhaseEnd,
      khastiAdvancesPhaseBegin,
      khastiAdvancesPhaseAdvance0,
      khastiAdvancesPhaseAdvance1,
      khastiAdvancesPhaseAdvance2,
      khastiAdvancesPhaseAdvance3,
      khastiAdvancesPhaseAdvance4,
      actionPhaseBegin,
      actionPhaseActions,
      actionPhaseEnd,
      endOfTurnPhaseBegin,
      endOfTurnPhaseDegradation,
      endOfTurnPhaseReturnInTriumph,
      endOfTurnPhaseRemoveModifiers,
      endOfTurnPhaseSaveGold,
      endOfTurnPhaseEnd,
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

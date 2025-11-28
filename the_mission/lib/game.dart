import 'dart:convert';
import 'dart:math';
import 'package:the_mission/db.dart';
import 'package:the_mission/random.dart';

enum Location {
  landJerusalem,
  landRome,
  landMilan,
  landSpain,
  landGaul,
  landBelgium,
  landBritain,
  landIreland,
  homelandSaxons,
  landCilicia,
  landAnatolia,
  landGreece,
  landConstantinople,
  landDanube,
  landKiev,
  homelandBulgars,
  landAntioch,
  landArmenia,
  landAlbania,
  landSarir,
  landGeorgia,
  landAlania,
  homelandKhazars,
  landCtesiphon,
  landPersia,
  landMerv,
  landIndia,
  landKashgar,
  landMongolia,
  homelandTurks,
  landAlexandria,
  landThebes,
  landNobadia,
  landMakouria,
  landAlodia,
  landEthiopia,
  homelandHimyar,
  landCyrene,
  landTripoli,
  landSufetula,
  landCarthage,
  landNumidia,
  landTingitana,
  homelandVandals,
  boxFaithWestEurope,
  boxFaithEastEurope,
  boxFaithCaucasus,
  boxFaithCentralAsia,
  boxFaithEastAfrica,
  boxFaithNorthAfrica,
  boxRomanPolicy,
  boxPersianReligion,
  boxWafer,
  boxDamagedArmies,
  boxBibleTranslations,
  boxArabAttackRolls1,
  boxArabAttackRolls2,
  boxArabAttackRolls3,
  boxBigCityField0,
  boxBigCityField1,
  boxBigCityField2,
  boxTrack0,
  boxTrack1,
  boxTrack2,
  boxTrack3,
  boxTrack4,
  boxTrack5,
  boxTrack6,
  boxTrack7,
  boxTrack8,
  boxTrack9,
  boxTrack10,
  boxActs1,
  boxActs2,
  boxActs3,
  boxActs4,
  boxActs5,
  boxActs6,
  boxActs7,
  boxActs8,
  boxActs9,
  boxActs10,
  boxActs11,
  boxActs12,
  boxActs13,
  boxActs14,
  boxActs15,
  boxActs16,
  boxActs17,
  boxActs18,
  boxActs19,
  boxActs20,
  boxActs21,
  boxActs22,
  boxActs23,
  boxActs24,
  boxActs25,
  boxActs26,
  boxActs27,
  boxActs28,
  cupWafer,
  cupField,
  cupFaith,
  cupHeresy,
  trayField,
  trayWafer,
  trayHeresy,
  trayPope,
  trayFaith,
  trayJihad,
  trayMisc,
  trayRoman,
  trayHorde,
  trayBible,
  trayKnight,
  trayInfrastructure,
  greatTheologianIgnatius,
  greatTheologianTertullian,
  greatTheologianOrigen,
  greatTheologianCyprian,
  greatTheologianAthanasius,
  greatTheologianJohnChrysostom,
  greatTheologianAugustine,
  greatTheologianLeo,
  greatTheologianGregory,
  greatTheologianIsaacOfNineveh,
  greatTheologianJohnOfDamascus,
  greatTheologianCyrilAndMethodius,
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
  pathWestEurope,
  pathEastEurope,
  pathCaucasus,
  pathCentralAsia,
  pathEastAfrica,
  pathNorthAfrica,
  boxFaith,
  boxArabAttackRolls,
  boxTrack,
  boxActs,
  tray,
  greatTheologian,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.land: [Location.landJerusalem, Location.homelandVandals],
    LocationType.pathLand: [Location.landRome, Location.homelandVandals],
    LocationType.pathWestEurope: [Location.landRome, Location.homelandSaxons],
    LocationType.pathEastEurope: [Location.landCilicia, Location.homelandBulgars],
    LocationType.pathCaucasus: [Location.landAntioch, Location.homelandKhazars],
    LocationType.pathCentralAsia: [Location.landCtesiphon, Location.homelandTurks],
    LocationType.pathEastAfrica: [Location.landAlexandria, Location.homelandHimyar],
    LocationType.pathNorthAfrica: [Location.landCyrene, Location.homelandVandals],
    LocationType.boxFaith: [Location.boxFaithWestEurope, Location.boxFaithNorthAfrica],
    LocationType.boxArabAttackRolls: [Location.boxArabAttackRolls1, Location.boxArabAttackRolls3],
    LocationType.boxTrack: [Location.boxTrack0, Location.boxTrack10],
    LocationType.boxActs: [Location.boxActs1, Location.boxActs28],
    LocationType.tray: [Location.trayField, Location.trayInfrastructure],
    LocationType.greatTheologian: [Location.greatTheologianIgnatius, Location.greatTheologianCyrilAndMethodius],
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
      Location.landJerusalem: 'Jerusalem',
      Location.landRome: 'Rome',
      Location.landMilan: 'Milan',
      Location.landSpain: 'Spain',
      Location.landGaul: 'Gaul',
      Location.landBelgium: 'Belgium',
      Location.landBritain: 'Britain',
      Location.landIreland: 'Ireland',
      Location.homelandSaxons: 'Saxon Homeland',
      Location.landCilicia: 'Cilicia',
      Location.landAnatolia: 'Anatolia',
      Location.landGreece: 'Greece',
      Location.landConstantinople: 'Constantinople',
      Location.landDanube: 'Danube Valley',
      Location.landKiev: 'Kiev',
      Location.homelandBulgars: 'Bulgar Homeland',
      Location.landAntioch: 'Antioch',
      Location.landArmenia: 'Armenia',
      Location.landAlbania: 'Albania',
      Location.landSarir: 'Sarir',
      Location.landGeorgia: 'Georgia',
      Location.landAlania: 'Alania',
      Location.homelandKhazars: 'Khazar Homeland',
      Location.landCtesiphon: 'Ctesiphon',
      Location.landPersia: 'Persia',
      Location.landMerv: 'Merv',
      Location.landIndia: 'India',
      Location.landKashgar: 'Kashgar',
      Location.landMongolia: 'Mongolia',
      Location.homelandTurks: 'Turkish Homeland',
      Location.landAlexandria: 'Alexandria',
      Location.landThebes: 'Thebes',
      Location.landNobadia: 'Nobadia',
      Location.landMakouria: 'Makouria',
      Location.landAlodia: 'Alodia',
      Location.landEthiopia: 'Ethiopia',
      Location.homelandHimyar: 'Himyar Homeland',
      Location.landCyrene: 'Cyrene',
      Location.landTripoli: 'Tripoli',
      Location.landSufetula: 'Sufetula',
      Location.landCarthage: 'Carthage',
      Location.landNumidia: 'Numidia',
      Location.landTingitana: 'Tingitana',
      Location.homelandVandals: 'Vandal Homeland',
      Location.greatTheologianIgnatius: 'Ignatius',
      Location.greatTheologianTertullian: 'Tertullian',
      Location.greatTheologianOrigen: 'Origen',
      Location.greatTheologianCyprian: 'Cyprian',
      Location.greatTheologianAthanasius: 'Athanasius',
      Location.greatTheologianJohnChrysostom: 'John Chrysostom',
      Location.greatTheologianAugustine: 'Augustine',
      Location.greatTheologianLeo: 'Leo',
      Location.greatTheologianGregory: 'Gregory',
      Location.greatTheologianIsaacOfNineveh: 'Isaac of Nineveh',
      Location.greatTheologianJohnOfDamascus: 'John of Damascus',
      Location.greatTheologianCyrilAndMethodius: 'Cyril and Methodius',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Piece {
  fieldPagan0Ascetics2,
  fieldPagan1Ascetics3,
  fieldPagan2Ascetics3,
  fieldPagan3Ascetics3,
  fieldPagan4Ascetics4,
  fieldPagan5Jews3,
  fieldPagan6Jews3,
  fieldPagan7Jews3,
  fieldPagan8Jews4,
  fieldPagan9Jews4,
  fieldPagan10Martyrs3,
  fieldPagan11Martyrs3,
  fieldPagan12Martyrs4,
  fieldPagan13Martyrs4,
  fieldPagan14Physicians2,
  fieldPagan15Poor1,
  fieldPagan16Poor1,
  fieldPagan17Poor1,
  fieldPagan18Poor1,
  fieldPagan19Poor2,
  fieldPagan20Poor2,
  fieldPagan21Scholars3,
  fieldPagan22Scholars4,
  fieldPagan23Scholars4,
  fieldPagan24Slaves1,
  fieldPagan25Slaves2,
  fieldPagan26Slaves2,
  fieldPagan27Slaves3,
  fieldPagan28Slaves3,
  fieldPagan29Slaves4,
  fieldPagan30Wealthy4,
  fieldPagan31Women1,
  fieldPagan32Women1,
  fieldPagan33Women2,
  fieldPagan34Women2,
  fieldPagan35Women2,
  fieldPagan36Women3,
  fieldPagan37Women3,
  fieldChristian0Ascetics1,
  fieldChristian1Ascetics2,
  fieldChristian2Ascetics2,
  fieldChristian3Ascetics2,
  fieldChristian4Ascetics3,
  fieldChristian5Jews2,
  fieldChristian6Jews2,
  fieldChristian7Jews2,
  fieldChristian8Jews3,
  fieldChristian9Jews3,
  fieldChristian10Martyrs3,
  fieldChristian11Martyrs3,
  fieldChristian12Martyrs4,
  fieldChristian13Martyrs4,
  fieldChristian14Physicians2,
  fieldChristian15Poor1,
  fieldChristian16Poor1,
  fieldChristian17Poor1,
  fieldChristian18Poor1,
  fieldChristian19Poor2,
  fieldChristian20Poor2,
  fieldChristian21Scholars2,
  fieldChristian22Scholars3,
  fieldChristian23Scholars3,
  fieldChristian24Slaves1,
  fieldChristian25Slaves2,
  fieldChristian26Slaves2,
  fieldChristian27Slaves3,
  fieldChristian28Slaves3,
  fieldChristian29Slaves4,
  fieldChristian30Wealthy3,
  fieldChristian31Women1,
  fieldChristian32Women1,
  fieldChristian33Women2,
  fieldChristian34Women2,
  fieldChristian35Women2,
  fieldChristian36Women3,
  fieldChristian37Women3,
  romanControlPaganWestEurope,
  romanControlPaganEastEurope,
  romanControlPaganCaucasus,
  romanControlPaganEastAfrica,
  romanControlPaganNorthAfrica,
  romanControlChristianWestEurope,
  romanControlChristianEastEurope,
  romanControlChristianCaucasus,
  romanControlChristianEastAfrica,
  romanControlChristianNorthAfrica,
  holyRomanEmpire,
  nubia,
  jihadWestEurope,
  jihadEastEurope,
  jihadCaucasus,
  jihadCentralAsia,
  jihadEastAfrica,
  jihadNorthAfrica,
  abbasidWestEurope,
  abbasidEastEurope,
  abbasidCaucasus,
  abbasidCentralAsia,
  abbasidEastAfrica,
  abbasidNorthAfrica,
  hordeSeljuksMuslim,
  hordeSaxonsArian,
  hordeSaxonsChristian,
  hordeBulgarsPagan,
  hordeBulgarsChristian,
  hordeKhazarsPagan,
  hordeKhazarsJewish,
  hordeTurksPagan,
  hordeTurksManichee,
  hordeTurksChristian,
  hordeTurksMuslim,
  hordeHimyarClans,
  hordeShewaMuslim,
  hordeVandalsArian,
  hordeBerbersMuslim,
  unholyArianEmpire,
  kingWestEurope,
  kingEastEurope,
  kingCaucasus,
  kingCentralAsia,
  kingEastAfrica,
  kingNorthAfrica,
  tyrantWestEurope,
  tyrantEastEurope,
  tyrantCaucasus,
  tyrantCentralAsia,
  tyrantEastAfrica,
  tyrantNorthAfrica,
  persianEmpire0,
  persianEmpireN1,
  persianEmpireP1,
  occupiedJerusalem,
  occupiedSpain,
  romanArmy,
  romanCapitalPagan,
  romanCapitalChristian,
  papalStates,
  knight0,
  knight1,
  knight2,
  prayForPeace0,
  prayForPeace1,
  prayForPeace2,
  cultIsis0,
  cultIsis1,
  baqt,
  heresyMithra0,
  heresyMithra1,
  heresyEbionite0,
  heresyEbionite1,
  heresyEbionite2,
  heresyGnostics0,
  heresyGnostics1,
  heresyGnostics2,
  heresyMarcionite,
  heresyMontanist,
  heresySabellian,
  heresyAdoptionist,
  heresyManichees0,
  heresyManichees1,
  heresyManichees2,
  heresyPelagian,
  heresyMonothelete,
  heresyPaulician,
  heresyIconoclast,
  heresyBogomil,
  heresyCathar,
  melkite0,
  melkite1,
  melkite2,
  melkite3,
  melkite4,
  melkite5,
  melkite6,
  melkite7,
  melkite8,
  melkite9,
  melkite10,
  melkite11,
  melkite12,
  melkite13,
  melkite14,
  melkite15,
  melkite16,
  melkite17,
  apostleWestEurope,
  apostleEastEurope,
  apostleCaucasus,
  apostleCentralAsia,
  apostleEastAfrica,
  apostleNorthAfrica,
  apostleJerusalem,
  relicsWestEurope,
  relicsEastEurope,
  relicsCaucasus,
  relicsCentralAsia,
  relicsEastAfrica,
  relicsNorthAfrica,
  relicsJerusalem,
  bishopWestEurope,
  bishopEastEurope,
  bishopCaucasus,
  bishopCentralAsia,
  bishopEastAfrica,
  bishopNorthAfrica,
  archbishopWestEurope,
  archbishopEastEurope,
  archbishopCaucasus,
  archbishopCentralAsia,
  archbishopEastAfrica,
  archbishopNorthAfrica,
  popeWestEurope,
  popeEastEurope,
  popeCaucasus,
  popeCentralAsia,
  popeEastAfrica,
  popeNorthAfrica,
  schismEastEurope,
  schismCaucasus,
  schismCentralAsia,
  schismEastAfrica,
  schismNorthAfrica,
  infrastructureMonastery0,
  infrastructureMonastery1,
  infrastructureHospital0,
  infrastructureHospital1,
  infrastructureUniversity0,
  infrastructureUniversity1,
  faithCatholic,
  faithOrthodoxEagle,
  faithOrthodox,
  faithNestorian,
  faithOneNature0,
  faithOneNature1,
  faithDonatist,
  faithApollinarian,
  faithArian,
  faithSubmit0,
  faithSubmit1,
  faithSubmit2,
  faithSubmit3,
  faithSubmit4,
  faithSubmit5,
  faithSubmit6,
  reconquista,
  romanaPax,
  romanaLex,
  emperorChristian,
  emperorHeretical,
  persiaZoroastrian,
  persiaMuslim,
  bibleLatin,
  bibleGreek,
  bibleArmenian,
  bibleSyriac,
  bibleCoptic,
  bibleUsedLatin,
  bibleUsedGreek,
  bibleUsedArmenian,
  bibleUsedSyriac,
  bibleUsedCoptic,
  greatTheologian,
  solidus,
  darkAges,
  gameTurn,
  waferCoin1,
  waferCoin2,
  waferCoin3,
  waferCoin4,
  waferCoin5,
  waferCoin6,
  waferCoin7,
  waferCoin8,
  waferCoin9,
  waferCoin10,
  waferCoin11,
  waferCoin12,
  waferCoin13,
  waferCoin14,
  waferCoin15,
  waferCoin16,
  waferCoin17,
  waferCoin18,
  waferCoin19,
  waferCoin20,
  waferCoin21,
  waferCoin22,
  waferCoin23,
  waferCoin24,
  waferCoin25,
  waferCoin26,
  waferCoin27,
  waferCoin28,
  waferCoin29,
  waferCoin30,
  waferCoin31,
  waferCoin32,
  waferAction1,
  waferAction2,
  waferAction3,
  waferAction4,
  waferAction5,
  waferAction6,
  waferAction7,
  waferAction8,
  waferAction9,
  waferAction10,
  waferAction11,
  waferAction12,
  waferAction13,
  waferAction14,
  waferAction15,
  waferAction16,
  waferAction17,
  waferAction18,
  waferAction19,
  waferAction20,
  waferAction21,
  waferAction22,
  waferAction23,
  waferAction24,
  waferAction25,
  waferAction26,
  waferAction27,
  waferAction28,
  waferAction29,
  waferAction30,
  waferAction31,
  waferAction32,
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
  field,
  fieldPagan,
  fieldPaganJews,
  fieldPaganMartyrs,
  fieldPaganWomen,
  fieldChristian,
  fieldChristianAscetics,
  fieldChristianJews,
  fieldChristianMartyrs,
  fieldChristianPhysicians,
  fieldChristianScholars,
  control,
  innerControl,
  outerControl,
  singleControl,
  romanControl,
  romanControlPagan,
  romanControlChristian,
  romanCapital,
  horde,
  hordeWestEurope,
  hordeEastEurope,
  hordeCaucasus,
  hordeCentralAsia,
  hordeEastAfrica,
  hordeNorthAfrica,
  ruler,
  persianEmpire,
  jihad,
  abbasid,
  knightOrPrayForPeace,
  knight,
  prayForPeace,
  heresy,
  ebioniteHeresy,
  apostle,
  pathApostle,
  relics,
  bishop,
  archbishop,
  pope,
  popeNonSchism,
  popeSchism,
  king,
  tyrant,
  infrastructure,
  monastery,
  hospital,
  university,
  faith,
  faithNoSubmit,
  faithRandom,
  faithSubmit,
  romanPolicy,
  bible,
  bibleUnused,
  bibleUsed,
  cultIsis,
  melkite,
  wafer,
  waferCoin,
  waferCoinSilver,
  waferCoinGold,
  waferAction,
  waferActionSilver,
  waferActionGold,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.fieldPagan0Ascetics2, Piece.waferAction32],
    PieceType.field: [Piece.fieldPagan0Ascetics2, Piece.fieldChristian37Women3],
    PieceType.fieldPagan: [Piece.fieldPagan0Ascetics2, Piece.fieldPagan37Women3],
    PieceType.fieldPaganJews: [Piece.fieldPagan5Jews3, Piece.fieldPagan9Jews4],
    PieceType.fieldPaganMartyrs: [Piece.fieldPagan10Martyrs3, Piece.fieldPagan13Martyrs4],
    PieceType.fieldPaganWomen: [Piece.fieldPagan31Women1, Piece.fieldPagan37Women3],
    PieceType.fieldChristian: [Piece.fieldChristian0Ascetics1, Piece.fieldChristian37Women3],
    PieceType.fieldChristianAscetics: [Piece.fieldChristian0Ascetics1, Piece.fieldChristian4Ascetics3],
    PieceType.fieldChristianJews: [Piece.fieldChristian5Jews2, Piece.fieldChristian9Jews3],
    PieceType.fieldChristianMartyrs: [Piece.fieldChristian10Martyrs3, Piece.fieldChristian13Martyrs4],
    PieceType.fieldChristianPhysicians: [Piece.fieldChristian14Physicians2, Piece.fieldChristian14Physicians2],
    PieceType.fieldChristianScholars: [Piece.fieldChristian21Scholars2, Piece.fieldChristian23Scholars3],
    PieceType.control: [Piece.romanControlPaganWestEurope, Piece.occupiedSpain],
    PieceType.innerControl: [Piece.romanControlPaganWestEurope, Piece.hordeSeljuksMuslim],
    PieceType.outerControl: [Piece.hordeSaxonsArian, Piece.unholyArianEmpire],
    PieceType.singleControl: [Piece.kingWestEurope, Piece.occupiedSpain],
    PieceType.romanControl: [Piece.romanControlPaganWestEurope, Piece.holyRomanEmpire],
    PieceType.romanControlPagan: [Piece.romanControlPaganWestEurope, Piece.romanControlPaganNorthAfrica],
    PieceType.romanControlChristian: [Piece.romanControlChristianWestEurope, Piece.holyRomanEmpire],
    PieceType.romanCapital: [Piece.romanCapitalPagan, Piece.romanCapitalChristian],
    PieceType.horde: [Piece.hordeSeljuksMuslim, Piece.hordeVandalsArian],
    PieceType.hordeWestEurope: [Piece.hordeSaxonsArian, Piece.hordeSaxonsChristian],
    PieceType.hordeEastEurope: [Piece.hordeBulgarsPagan, Piece.hordeBulgarsChristian],
    PieceType.hordeCaucasus: [Piece.hordeKhazarsPagan, Piece.hordeKhazarsJewish],
    PieceType.hordeCentralAsia: [Piece.hordeTurksPagan, Piece.hordeTurksMuslim],
    PieceType.hordeEastAfrica: [Piece.hordeHimyarClans, Piece.hordeShewaMuslim],
    PieceType.hordeNorthAfrica: [Piece.hordeVandalsArian, Piece.hordeBerbersMuslim],
    PieceType.ruler: [Piece.kingWestEurope, Piece.tyrantNorthAfrica],
    PieceType.persianEmpire: [Piece.persianEmpire0, Piece.persianEmpireP1],
    PieceType.jihad: [Piece.jihadWestEurope, Piece.jihadNorthAfrica],
    PieceType.abbasid: [Piece.abbasidWestEurope, Piece.abbasidNorthAfrica],
    PieceType.knightOrPrayForPeace: [Piece.knight0, Piece.prayForPeace2],
    PieceType.knight: [Piece.knight0, Piece.knight2],
    PieceType.prayForPeace: [Piece.prayForPeace0, Piece.prayForPeace2],
    PieceType.heresy: [Piece.heresyMithra0, Piece.heresyCathar],
    PieceType.ebioniteHeresy: [Piece.heresyEbionite0, Piece.heresyEbionite2],
    PieceType.apostle: [Piece.apostleWestEurope, Piece.apostleJerusalem],
    PieceType.pathApostle: [Piece.apostleWestEurope, Piece.apostleNorthAfrica],
    PieceType.relics: [Piece.relicsWestEurope, Piece.relicsJerusalem],
    PieceType.bishop: [Piece.bishopWestEurope, Piece.bishopNorthAfrica],
    PieceType.archbishop: [Piece.archbishopWestEurope, Piece.archbishopNorthAfrica],
    PieceType.pope: [Piece.popeWestEurope, Piece.schismNorthAfrica],
    PieceType.popeNonSchism: [Piece.popeWestEurope, Piece.popeNorthAfrica],
    PieceType.popeSchism: [Piece.schismEastEurope, Piece.schismNorthAfrica],
    PieceType.king: [Piece.kingWestEurope, Piece.kingNorthAfrica],
    PieceType.tyrant: [Piece.tyrantWestEurope, Piece.tyrantNorthAfrica],
    PieceType.infrastructure: [Piece.infrastructureMonastery0, Piece.infrastructureUniversity1],
    PieceType.monastery: [Piece.infrastructureMonastery0, Piece.infrastructureMonastery1],
    PieceType.hospital: [Piece.infrastructureHospital0, Piece.infrastructureHospital1],
    PieceType.university: [Piece.infrastructureUniversity0, Piece.infrastructureUniversity1],
    PieceType.faith: [Piece.faithCatholic, Piece.faithSubmit6],
    PieceType.faithNoSubmit: [Piece.faithCatholic, Piece.faithArian],
    PieceType.faithRandom: [Piece.faithOrthodox, Piece.faithArian],
    PieceType.faithSubmit: [Piece.faithSubmit0, Piece.faithSubmit6],
    PieceType.romanPolicy: [Piece.romanaPax, Piece.emperorHeretical],
    PieceType.bible: [Piece.bibleLatin, Piece.bibleUsedCoptic],
    PieceType.bibleUnused: [Piece.bibleLatin, Piece.bibleCoptic],
    PieceType.bibleUsed: [Piece.bibleUsedLatin, Piece.bibleUsedCoptic],
    PieceType.cultIsis: [Piece.cultIsis0, Piece.cultIsis1],
    PieceType.melkite: [Piece.melkite0, Piece.melkite17],
    PieceType.wafer: [Piece.waferCoin1, Piece.waferAction32],
    PieceType.waferCoin: [Piece.waferCoin1, Piece.waferCoin32],
    PieceType.waferCoinSilver: [Piece.waferCoin1, Piece.waferCoin16],
    PieceType.waferCoinGold: [Piece.waferCoin17, Piece.waferCoin32],
    PieceType.waferAction: [Piece.waferAction1, Piece.waferAction32],
    PieceType.waferActionSilver: [Piece.waferAction1, Piece.waferAction16],
    PieceType.waferActionGold: [Piece.waferAction17, Piece.waferAction32],
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
      Piece.fieldPagan0Ascetics2: 'Ascetics',
      Piece.fieldPagan1Ascetics3: 'Ascetics',
      Piece.fieldPagan2Ascetics3: 'Ascetics',
      Piece.fieldPagan3Ascetics3: 'Ascetics',
      Piece.fieldPagan4Ascetics4: 'Ascetics',
      Piece.fieldPagan5Jews3: 'Jews',
      Piece.fieldPagan6Jews3: 'Jews',
      Piece.fieldPagan7Jews3: 'Jews',
      Piece.fieldPagan8Jews4: 'Jews',
      Piece.fieldPagan9Jews4: 'Jews',
      Piece.fieldPagan10Martyrs3: 'Martyrs',
      Piece.fieldPagan11Martyrs3: 'Martyrs',
      Piece.fieldPagan12Martyrs4: 'Martyrs',
      Piece.fieldPagan13Martyrs4: 'Martyrs',
      Piece.fieldPagan14Physicians2: 'Physicians',
      Piece.fieldPagan15Poor1: 'Poor',
      Piece.fieldPagan16Poor1: 'Poor',
      Piece.fieldPagan17Poor1: 'Poor',
      Piece.fieldPagan18Poor1: 'Poor',
      Piece.fieldPagan19Poor2: 'Poor',
      Piece.fieldPagan20Poor2: 'Poor',
      Piece.fieldPagan21Scholars3: 'Scholars',
      Piece.fieldPagan22Scholars4: 'Scholars',
      Piece.fieldPagan23Scholars4: 'Scholars',
      Piece.fieldPagan24Slaves1: 'Slaves',
      Piece.fieldPagan25Slaves2: 'Slaves',
      Piece.fieldPagan26Slaves2: 'Slaves',
      Piece.fieldPagan27Slaves3: 'Slaves',
      Piece.fieldPagan28Slaves3: 'Slaves',
      Piece.fieldPagan29Slaves4: 'Slaves',
      Piece.fieldPagan30Wealthy4: 'Wealthy',
      Piece.fieldPagan31Women1: 'Women',
      Piece.fieldPagan32Women1: 'Women',
      Piece.fieldPagan33Women2: 'Women',
      Piece.fieldPagan34Women2: 'Women',
      Piece.fieldPagan35Women2: 'Women',
      Piece.fieldPagan36Women3: 'Women',
      Piece.fieldPagan37Women3: 'Women',
      Piece.fieldChristian0Ascetics1: 'Ascetics',
      Piece.fieldChristian1Ascetics2: 'Ascetics',
      Piece.fieldChristian2Ascetics2: 'Ascetics',
      Piece.fieldChristian3Ascetics2: 'Ascetics',
      Piece.fieldChristian4Ascetics3: 'Ascetics',
      Piece.fieldChristian5Jews2: 'Jews',
      Piece.fieldChristian6Jews2: 'Jews',
      Piece.fieldChristian7Jews2: 'Jews',
      Piece.fieldChristian8Jews3: 'Jews',
      Piece.fieldChristian9Jews3: 'Jews',
      Piece.fieldChristian10Martyrs3: 'Martyrs',
      Piece.fieldChristian11Martyrs3: 'Martyrs',
      Piece.fieldChristian12Martyrs4: 'Martyrs',
      Piece.fieldChristian13Martyrs4: 'Martyrs',
      Piece.fieldChristian14Physicians2: 'Physicians',
      Piece.fieldChristian15Poor1: 'Poor',
      Piece.fieldChristian16Poor1: 'Poor',
      Piece.fieldChristian17Poor1: 'Poor',
      Piece.fieldChristian18Poor1: 'Poor',
      Piece.fieldChristian19Poor2: 'Poor',
      Piece.fieldChristian20Poor2: 'Poor',
      Piece.fieldChristian21Scholars2: 'Scholars',
      Piece.fieldChristian22Scholars3: 'Scholars',
      Piece.fieldChristian23Scholars3: 'Scholars',
      Piece.fieldChristian24Slaves1: 'Slaves',
      Piece.fieldChristian25Slaves2: 'Slaves',
      Piece.fieldChristian26Slaves2: 'Slaves',
      Piece.fieldChristian27Slaves3: 'Slaves',
      Piece.fieldChristian28Slaves3: 'Slaves',
      Piece.fieldChristian29Slaves4: 'Slaves',
      Piece.fieldChristian30Wealthy3: 'Wealthy',
      Piece.fieldChristian31Women1: 'Women',
      Piece.fieldChristian32Women1: 'Women',
      Piece.fieldChristian33Women2: 'Women',
      Piece.fieldChristian34Women2: 'Women',
      Piece.fieldChristian35Women2: 'Women',
      Piece.fieldChristian36Women3: 'Women',
      Piece.fieldChristian37Women3: 'Women',
      Piece.romanControlPaganWestEurope: 'Rome',
      Piece.romanControlPaganEastEurope: 'Rome',
      Piece.romanControlPaganCaucasus: 'Rome',
      Piece.romanControlPaganEastAfrica: 'Rome',
      Piece.romanControlPaganNorthAfrica: 'Rome',
      Piece.romanControlChristianWestEurope: 'Rome',
      Piece.romanControlChristianEastEurope: 'Rome',
      Piece.romanControlChristianCaucasus: 'Rome',
      Piece.romanControlChristianEastAfrica: 'Rome',
      Piece.romanControlChristianNorthAfrica: 'Rome',
      Piece.holyRomanEmpire: 'Holy Roman Empire',
      Piece.nubia: 'Nubia',
      Piece.jihadWestEurope: 'Jihad',
      Piece.jihadEastEurope: 'Jihad',
      Piece.jihadCaucasus: 'Jihad',
      Piece.jihadCentralAsia: 'Jihad',
      Piece.jihadEastAfrica: 'Jihad',
      Piece.jihadNorthAfrica: 'Jihad',
      Piece.abbasidWestEurope: 'Abbasid Caliphate',
      Piece.abbasidEastEurope: 'Abbasid Caliphate',
      Piece.abbasidCaucasus: 'Abbasid Caliphate',
      Piece.abbasidCentralAsia: 'Abbasid Caliphate',
      Piece.abbasidEastAfrica: 'Abbasid Caliphate',
      Piece.abbasidNorthAfrica: 'Abbasid Caliphate',
      Piece.hordeSeljuksMuslim: 'Muslim Seljuks',
      Piece.hordeSaxonsArian: 'Arian Saxons',
      Piece.hordeSaxonsChristian: 'Christian Saxons',
      Piece.hordeBulgarsPagan: 'Pagan Bulgars',
      Piece.hordeBulgarsChristian: 'Christian Bulgars',
      Piece.hordeKhazarsPagan: 'Pagan Khazars',
      Piece.hordeKhazarsJewish: 'Jewish Khazars',
      Piece.hordeTurksPagan: 'Pagan Turks',
      Piece.hordeTurksManichee: 'Manichee Turks',
      Piece.hordeTurksChristian: 'Christian Turks',
      Piece.hordeTurksMuslim: 'Muslim Turks',
      Piece.hordeHimyarClans: 'Himyar Clans',
      Piece.hordeShewaMuslim: 'Muslim Shewa',
      Piece.hordeVandalsArian: 'Arian Vandals',
      Piece.hordeBerbersMuslim: 'Muslim Berbers',
      Piece.unholyArianEmpire: 'Unholy Arian Empire',
      Piece.kingWestEurope: 'King',
      Piece.kingEastEurope: 'King',
      Piece.kingCaucasus: 'King',
      Piece.kingCentralAsia: 'King',
      Piece.kingEastAfrica: 'King',
      Piece.kingNorthAfrica: 'King',
      Piece.tyrantWestEurope: 'Tyrant',
      Piece.tyrantEastEurope: 'Tyrant',
      Piece.tyrantCaucasus: 'Tyrant',
      Piece.tyrantCentralAsia: 'Tyrant',
      Piece.tyrantEastAfrica: 'Tyrant',
      Piece.tyrantNorthAfrica: 'Tyrant',
      Piece.persianEmpire0: 'Persian Empire',
      Piece.persianEmpireN1: 'Persian Empire',
      Piece.persianEmpireP1: 'Persian Empire',
      Piece.romanArmy: 'Roman Army',
      Piece.romanCapitalPagan: 'Roman Capital',
      Piece.romanCapitalChristian: 'Roman Capital',
      Piece.papalStates: 'Papal States',
      Piece.knight0: 'Knights',
      Piece.knight1: 'Knights',
      Piece.knight2: 'Knights',
      Piece.prayForPeace0: 'Pray for Peace',
      Piece.prayForPeace1: 'Pray for Peace',
      Piece.prayForPeace2: 'Pray for Peace',
      Piece.heresyMithra0: 'Mithra',
      Piece.heresyMithra1: 'Mithra',
      Piece.heresyEbionite0: 'Ebionites',
      Piece.heresyEbionite1: 'Ebionites',
      Piece.heresyEbionite2: 'Ebionites',
      Piece.heresyGnostics0: 'Gnostics',
      Piece.heresyGnostics1: 'Gnostics',
      Piece.heresyGnostics2: 'Gnostics',
      Piece.heresyMarcionite: 'Marcionite Heresy',
      Piece.heresyMontanist: 'Monatist Heresy',
      Piece.heresySabellian: 'Sabellian Heresy',
      Piece.heresyAdoptionist: 'Adoptionist Heresy',
      Piece.heresyManichees0: 'Manichees',
      Piece.heresyManichees1: 'Manichees',
      Piece.heresyManichees2: 'Manichees',
      Piece.heresyPelagian: 'Pelagian Heresy',
      Piece.heresyMonothelete: 'Monothelete Heresy',
      Piece.heresyPaulician: 'Paulician Heresy',
      Piece.heresyIconoclast: 'Iconoclast Heresy',
      Piece.heresyBogomil: 'Bogomil Heresy',
      Piece.heresyCathar: 'Cathar Heresy',
      Piece.apostleWestEurope: 'Peter',
      Piece.apostleEastEurope: 'Paul',
      Piece.apostleCaucasus: 'Barnabas',
      Piece.apostleCentralAsia: 'Thomas',
      Piece.apostleEastAfrica: 'Mark',
      Piece.apostleNorthAfrica: 'Jude',
      Piece.apostleJerusalem: 'James the Just',
      Piece.bishopWestEurope: 'Bishop of Rome',
      Piece.bishopEastEurope: 'Bishop of Constantinople',
      Piece.bishopCaucasus: 'Bishop of Armenia',
      Piece.bishopCentralAsia: 'Bishop of Assyria',
      Piece.bishopEastAfrica: 'Biship of Alexandria',
      Piece.bishopNorthAfrica: 'Biship of Carthage',
      Piece.archbishopWestEurope: 'Archbishop of Rome',
      Piece.archbishopEastEurope: 'Archbishop of Constantinople',
      Piece.archbishopCaucasus: 'Archbishop of Armenia',
      Piece.archbishopCentralAsia: 'Archbishop of Assyria',
      Piece.archbishopEastAfrica: 'Archbishop of Alexandria',
      Piece.archbishopNorthAfrica: 'Archbishop of Carthage',
      Piece.popeWestEurope: 'Pope of Rome',
      Piece.popeEastEurope: 'Patriarch of Constantinople',
      Piece.popeCaucasus: 'Armenian Catholicos',
      Piece.popeCentralAsia: 'Catholicos of Assyria',
      Piece.popeEastAfrica: 'Pope of Alexandria',
      Piece.popeNorthAfrica: 'Servant in Charge of Carthage',
      Piece.schismEastEurope: 'Schismatic Patriarch of Constantinople',
      Piece.schismCaucasus: 'Schismatic Armenian Catholicos',
      Piece.schismCentralAsia: 'Schismatic Catholicos of Assyria',
      Piece.schismEastAfrica: 'Schismatic Pope of Alexandria',
      Piece.schismNorthAfrica: 'Schismatic Servant in Charge of Carthage',
      Piece.infrastructureMonastery0: 'Monastery',
      Piece.infrastructureMonastery1: 'Monastery',
      Piece.infrastructureHospital0: 'Hospital',
      Piece.infrastructureHospital1: 'Hospital',
      Piece.infrastructureUniversity0: 'University',
      Piece.infrastructureUniversity1: 'University',
      Piece.faithCatholic: 'Catholic',
      Piece.faithOrthodoxEagle: 'Orthodox',
      Piece.faithOrthodox: 'Orthodox',
      Piece.faithNestorian: 'Nestorian',
      Piece.faithOneNature0: 'One Nature',
      Piece.faithOneNature1: 'One Nature',
      Piece.faithDonatist: 'Donatist',
      Piece.faithApollinarian: 'Apollinarian',
      Piece.faithArian: 'Arian',
      Piece.faithSubmit0: 'Submit',
      Piece.faithSubmit1: 'Submit',
      Piece.faithSubmit2: 'Submit',
      Piece.faithSubmit3: 'Submit',
      Piece.faithSubmit4: 'Submit',
      Piece.faithSubmit5: 'Submit',
      Piece.faithSubmit6: 'Submit',
      Piece.bibleLatin: 'Latin Bible',
      Piece.bibleGreek: 'Greek Bible',
      Piece.bibleArmenian: 'Armenian Bible',
      Piece.bibleSyriac: 'Syriac Bible',
      Piece.bibleCoptic: 'Coptic Bible',
      Piece.bibleUsedLatin: 'Latin Bible',
      Piece.bibleUsedGreek: 'Greek Bible',
      Piece.bibleUsedArmenian: 'Armenian Bible',
      Piece.bibleUsedSyriac: 'Syriac Bible',
      Piece.bibleUsedCoptic: 'Coptic Bible',
    };
    return pieceDescs[this]!;
  }

  bool isType(PieceType pieceType) {
    return index >= pieceType.firstIndex && index < pieceType.lastIndex;
  }
}

enum Path {
  westEurope,
  eastEurope,
  caucasus,
  centralAsia,
  eastAfrica,
  northAfrica,
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

extension PathExtension on Path {
  String get desc {
    const descs = {
      Path.westEurope: 'Western Europe',
      Path.eastEurope: 'Eastern Europe and Asia Minor',
      Path.caucasus: 'Armenia and the Caucasus',
      Path.centralAsia: 'Persia and Central Asia',
      Path.eastAfrica: 'Egypt and East Africa',
      Path.northAfrica: 'North Africa',
    };
    return descs[this]!;
  }
}

enum ArmyType {
  advanceForce,
  selfDefenseForce,
  vulnerableForce,
}

const armyData = {
  Piece.fieldPagan10Martyrs3: (ArmyType.selfDefenseForce, 0),
  Piece.fieldPagan11Martyrs3: (ArmyType.selfDefenseForce, 0),
  Piece.fieldPagan12Martyrs4: (ArmyType.selfDefenseForce, 0),
  Piece.fieldPagan13Martyrs4: (ArmyType.selfDefenseForce, 0),
  Piece.fieldChristian10Martyrs3: (ArmyType.selfDefenseForce, 0),
  Piece.fieldChristian11Martyrs3: (ArmyType.selfDefenseForce, 0),
  Piece.fieldChristian12Martyrs4: (ArmyType.selfDefenseForce, 0),
  Piece.fieldChristian13Martyrs4: (ArmyType.selfDefenseForce, 0),
  Piece.romanControlPaganWestEurope: (ArmyType.advanceForce, 3),
  Piece.romanControlPaganEastEurope: (ArmyType.advanceForce, 3),
  Piece.romanControlPaganCaucasus: (ArmyType.advanceForce, 3),
  Piece.romanControlPaganEastAfrica: (ArmyType.advanceForce, 3),
  Piece.romanControlPaganNorthAfrica: (ArmyType.advanceForce, 3),
  Piece.romanControlChristianWestEurope: (ArmyType.advanceForce, 3),
  Piece.romanControlChristianEastEurope: (ArmyType.advanceForce, 3),
  Piece.romanControlChristianCaucasus: (ArmyType.advanceForce, 3),
  Piece.romanControlChristianEastAfrica: (ArmyType.advanceForce, 3),
  Piece.romanControlChristianNorthAfrica: (ArmyType.advanceForce, 3),
  Piece.holyRomanEmpire: (ArmyType.advanceForce, 4),
  Piece.nubia: (ArmyType.advanceForce, 3),
  Piece.jihadWestEurope: (ArmyType.advanceForce, 3),
  Piece.jihadEastEurope: (ArmyType.advanceForce, 3),
  Piece.jihadCaucasus: (ArmyType.advanceForce, 4),
  Piece.jihadCentralAsia: (ArmyType.advanceForce, 4),
  Piece.jihadEastAfrica: (ArmyType.advanceForce, 4),
  Piece.jihadNorthAfrica: (ArmyType.advanceForce, 5),
  Piece.abbasidWestEurope: (ArmyType.advanceForce, 2),
  Piece.abbasidEastEurope: (ArmyType.advanceForce, 3),
  Piece.abbasidCaucasus: (ArmyType.advanceForce, 2),
  Piece.abbasidCentralAsia: (ArmyType.advanceForce, 2),
  Piece.abbasidEastAfrica: (ArmyType.advanceForce, 4),
  Piece.abbasidNorthAfrica: (ArmyType.advanceForce, 2),
  Piece.hordeSeljuksMuslim: (ArmyType.advanceForce, 4),
  Piece.hordeSaxonsArian: (ArmyType.advanceForce, 4),
  Piece.hordeSaxonsChristian: (ArmyType.advanceForce, 3),
  Piece.hordeTurksPagan: (ArmyType.advanceForce, 3),
  Piece.hordeTurksManichee: (ArmyType.advanceForce, 2),
  Piece.hordeTurksChristian: (ArmyType.advanceForce, 3),
  Piece.hordeTurksMuslim: (ArmyType.advanceForce, 4),
  Piece.hordeBulgarsPagan: (ArmyType.advanceForce, 3),
  Piece.hordeBulgarsChristian: (ArmyType.advanceForce, 4),
  Piece.hordeKhazarsPagan: (ArmyType.advanceForce, 4),
  Piece.hordeKhazarsJewish: (ArmyType.advanceForce, 2),
  Piece.hordeVandalsArian: (ArmyType.advanceForce, 4),
  Piece.hordeBerbersMuslim: (ArmyType.advanceForce, 4),
  Piece.hordeHimyarClans: (ArmyType.advanceForce, 2),
  Piece.hordeShewaMuslim: (ArmyType.advanceForce, 3),
  Piece.unholyArianEmpire: (ArmyType.advanceForce, 4),
  Piece.kingWestEurope: (ArmyType.vulnerableForce, 0),
  Piece.kingEastEurope: (ArmyType.vulnerableForce, 0),
  Piece.kingCaucasus: (ArmyType.vulnerableForce, 0),
  Piece.kingCentralAsia: (ArmyType.vulnerableForce, 0),
  Piece.kingEastAfrica: (ArmyType.vulnerableForce, 0),
  Piece.kingNorthAfrica: (ArmyType.vulnerableForce, 0),
  Piece.tyrantWestEurope: (ArmyType.vulnerableForce, 0),
  Piece.tyrantEastEurope: (ArmyType.vulnerableForce, 0),
  Piece.tyrantCaucasus: (ArmyType.vulnerableForce, 0),
  Piece.tyrantCentralAsia: (ArmyType.vulnerableForce, 0),
  Piece.tyrantEastAfrica: (ArmyType.vulnerableForce, 0),
  Piece.tyrantNorthAfrica: (ArmyType.vulnerableForce, 0),
  Piece.persianEmpire0: (ArmyType.vulnerableForce, 0),
  Piece.persianEmpireN1: (ArmyType.vulnerableForce, 0),
  Piece.persianEmpireP1: (ArmyType.vulnerableForce, 0),
  Piece.romanArmy: (ArmyType.advanceForce, 4),
  Piece.romanCapitalPagan: (ArmyType.selfDefenseForce, 0),
  Piece.romanCapitalChristian: (ArmyType.selfDefenseForce, 0),
  Piece.papalStates: (ArmyType.selfDefenseForce, 0),
  Piece.knight0: (ArmyType.vulnerableForce, 0),
  Piece.knight1: (ArmyType.vulnerableForce, 0),
  Piece.knight2: (ArmyType.vulnerableForce, 0),
  Piece.prayForPeace0: (ArmyType.vulnerableForce, 0),
  Piece.prayForPeace1: (ArmyType.vulnerableForce, 0),
  Piece.prayForPeace2: (ArmyType.vulnerableForce, 0),
  Piece.infrastructureHospital0: (ArmyType.selfDefenseForce, 0),
  Piece.infrastructureHospital1: (ArmyType.selfDefenseForce, 0),
};

const waferCoinData = {
  Piece.waferCoin1: (4, false),
  Piece.waferCoin2: (4, false),
  Piece.waferCoin3: (4, true),
  Piece.waferCoin4: (2, false),
  Piece.waferCoin5: (2, true),
  Piece.waferCoin6: (2, false),
  Piece.waferCoin7: (5, true),
  Piece.waferCoin8: (1, false),
  Piece.waferCoin9: (3, true),
  Piece.waferCoin10: (3, false),
  Piece.waferCoin11: (3, false),
  Piece.waferCoin12: (3, true),
  Piece.waferCoin13: (3, false),
  Piece.waferCoin14: (3, true),
  Piece.waferCoin15: (3, false),
  Piece.waferCoin16: (3, false),
  Piece.waferCoin17: (6, false),
  Piece.waferCoin18: (6, true),
  Piece.waferCoin19: (6, false),
  Piece.waferCoin20: (3, false),
  Piece.waferCoin21: (3, true),
  Piece.waferCoin22: (2, false),
  Piece.waferCoin23: (2, false),
  Piece.waferCoin24: (4, true),
  Piece.waferCoin25: (5, false),
  Piece.waferCoin26: (5, false),
  Piece.waferCoin27: (5, true),
  Piece.waferCoin28: (5, false),
  Piece.waferCoin29: (5, false),
  Piece.waferCoin30: (5, true),
  Piece.waferCoin31: (4, false),
  Piece.waferCoin32: (4, false),
};

enum LimitedEvent {
  reconquistaAttempted,
}

enum Scenario {
  campaign,
  riseOfIslam,
}

extension ScenarioExtension on Scenario {
  String get desc {
    const scenarioDescs = {
      Scenario.campaign: 'Campaign',
      Scenario.riseOfIslam: 'Rise of Islam',
    };
    return scenarioDescs[this]!;
  }

  String get longDesc {
    const scenarioDescs = {
      Scenario.campaign: 'Campaign 30 AD to 1291 AD (27 Turns)',
      Scenario.riseOfIslam: 'Rise of Islam 631 AD to 1291 AD (7 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<int> _limitedEventCounts = List<int>.filled(LimitedEvent.values.length, 0);

  GameState();

  GameState.fromJson(Map<String, dynamic> json) :
   _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations'])),
   _limitedEventCounts = List<int>.from(json['limitedEventCounts']);

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'limitedEventCounts': _limitedEventCounts,
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
        Piece.fieldPagan0Ascetics2: Piece.fieldChristian0Ascetics1,
        Piece.fieldPagan1Ascetics3: Piece.fieldChristian1Ascetics2,
        Piece.fieldPagan2Ascetics3: Piece.fieldChristian2Ascetics2,
        Piece.fieldPagan3Ascetics3: Piece.fieldChristian3Ascetics2,
        Piece.fieldPagan4Ascetics4: Piece.fieldChristian4Ascetics3,
        Piece.fieldPagan5Jews3: Piece.fieldChristian5Jews2,
        Piece.fieldPagan6Jews3: Piece.fieldChristian6Jews2,
        Piece.fieldPagan7Jews3: Piece.fieldChristian7Jews2,
        Piece.fieldPagan8Jews4: Piece.fieldChristian8Jews3,
        Piece.fieldPagan9Jews4: Piece.fieldChristian9Jews3,
        Piece.fieldPagan10Martyrs3: Piece.fieldChristian10Martyrs3,
        Piece.fieldPagan11Martyrs3: Piece.fieldChristian11Martyrs3,
        Piece.fieldPagan12Martyrs4: Piece.fieldChristian12Martyrs4,
        Piece.fieldPagan13Martyrs4: Piece.fieldChristian13Martyrs4,
        Piece.fieldPagan14Physicians2: Piece.fieldChristian14Physicians2,
        Piece.fieldPagan15Poor1: Piece.fieldChristian15Poor1,
        Piece.fieldPagan16Poor1: Piece.fieldChristian16Poor1,
        Piece.fieldPagan17Poor1: Piece.fieldChristian17Poor1,
        Piece.fieldPagan18Poor1: Piece.fieldChristian18Poor1,
        Piece.fieldPagan19Poor2: Piece.fieldChristian19Poor2,
        Piece.fieldPagan20Poor2: Piece.fieldChristian20Poor2,
        Piece.fieldPagan21Scholars3: Piece.fieldChristian21Scholars2,
        Piece.fieldPagan22Scholars4: Piece.fieldChristian22Scholars3,
        Piece.fieldPagan23Scholars4: Piece.fieldChristian23Scholars3,
        Piece.fieldPagan24Slaves1: Piece.fieldChristian24Slaves1,
        Piece.fieldPagan25Slaves2: Piece.fieldChristian25Slaves2,
        Piece.fieldPagan26Slaves2: Piece.fieldChristian26Slaves2,
        Piece.fieldPagan27Slaves3: Piece.fieldChristian27Slaves3,
        Piece.fieldPagan28Slaves3: Piece.fieldChristian28Slaves3,
        Piece.fieldPagan29Slaves4: Piece.fieldChristian29Slaves4,
        Piece.fieldPagan30Wealthy4: Piece.fieldChristian30Wealthy3,
        Piece.fieldPagan31Women1: Piece.fieldChristian31Women1,
        Piece.fieldPagan32Women1: Piece.fieldChristian32Women1,
        Piece.fieldPagan33Women2: Piece.fieldChristian33Women2,
        Piece.fieldPagan34Women2: Piece.fieldChristian34Women2,
        Piece.fieldPagan35Women2: Piece.fieldChristian35Women2,
        Piece.fieldPagan36Women3: Piece.fieldChristian36Women3,
        Piece.fieldPagan37Women3: Piece.fieldChristian37Women3,
        Piece.fieldChristian0Ascetics1: Piece.fieldPagan0Ascetics2,
        Piece.fieldChristian1Ascetics2: Piece.fieldPagan1Ascetics3,
        Piece.fieldChristian2Ascetics2: Piece.fieldPagan2Ascetics3,
        Piece.fieldChristian3Ascetics2: Piece.fieldPagan3Ascetics3,
        Piece.fieldChristian4Ascetics3: Piece.fieldPagan4Ascetics4,
        Piece.fieldChristian5Jews2: Piece.fieldPagan5Jews3,
        Piece.fieldChristian6Jews2: Piece.fieldPagan6Jews3,
        Piece.fieldChristian7Jews2: Piece.fieldPagan7Jews3,
        Piece.fieldChristian8Jews3: Piece.fieldPagan8Jews4,
        Piece.fieldChristian9Jews3: Piece.fieldPagan9Jews4,
        Piece.fieldChristian10Martyrs3: Piece.fieldPagan10Martyrs3,
        Piece.fieldChristian11Martyrs3: Piece.fieldPagan11Martyrs3,
        Piece.fieldChristian12Martyrs4: Piece.fieldPagan12Martyrs4,
        Piece.fieldChristian13Martyrs4: Piece.fieldPagan13Martyrs4,
        Piece.fieldChristian14Physicians2: Piece.fieldPagan14Physicians2,
        Piece.fieldChristian15Poor1: Piece.fieldPagan15Poor1,
        Piece.fieldChristian16Poor1: Piece.fieldPagan16Poor1,
        Piece.fieldChristian17Poor1: Piece.fieldPagan17Poor1,
        Piece.fieldChristian18Poor1: Piece.fieldPagan18Poor1,
        Piece.fieldChristian19Poor2: Piece.fieldPagan19Poor2,
        Piece.fieldChristian20Poor2: Piece.fieldPagan20Poor2,
        Piece.fieldChristian21Scholars2: Piece.fieldPagan21Scholars3,
        Piece.fieldChristian22Scholars3: Piece.fieldPagan22Scholars4,
        Piece.fieldChristian23Scholars3: Piece.fieldPagan23Scholars4,
        Piece.fieldChristian24Slaves1: Piece.fieldPagan24Slaves1,
        Piece.fieldChristian25Slaves2: Piece.fieldPagan25Slaves2,
        Piece.fieldChristian26Slaves2: Piece.fieldPagan26Slaves2,
        Piece.fieldChristian27Slaves3: Piece.fieldPagan27Slaves3,
        Piece.fieldChristian28Slaves3: Piece.fieldPagan28Slaves3,
        Piece.fieldChristian29Slaves4: Piece.fieldPagan29Slaves4,
        Piece.fieldChristian30Wealthy3: Piece.fieldPagan30Wealthy4,
        Piece.fieldChristian31Women1: Piece.fieldPagan31Women1,
        Piece.fieldChristian32Women1: Piece.fieldPagan32Women1,
        Piece.fieldChristian33Women2: Piece.fieldPagan33Women2,
        Piece.fieldChristian34Women2: Piece.fieldPagan34Women2,
        Piece.fieldChristian35Women2: Piece.fieldPagan35Women2,
        Piece.fieldChristian36Women3: Piece.fieldPagan36Women3,
        Piece.fieldChristian37Women3: Piece.fieldPagan37Women3,
        Piece.romanControlPaganWestEurope: Piece.romanControlChristianWestEurope,
        Piece.romanControlPaganEastEurope: Piece.romanControlChristianEastEurope,
        Piece.romanControlPaganCaucasus: Piece.romanControlChristianCaucasus,
        Piece.romanControlPaganEastAfrica: Piece.romanControlChristianEastAfrica,
        Piece.romanControlPaganNorthAfrica: Piece.romanControlChristianNorthAfrica,
        Piece.romanControlChristianWestEurope: Piece.romanControlPaganWestEurope,
        Piece.romanControlChristianEastEurope: Piece.romanControlPaganEastEurope,
        Piece.romanControlChristianCaucasus: Piece.romanControlPaganCaucasus,
        Piece.romanControlChristianEastAfrica: Piece.romanControlPaganEastAfrica,
        Piece.romanControlChristianNorthAfrica: Piece.romanControlPaganNorthAfrica,
        Piece.romanCapitalPagan: Piece.romanCapitalChristian,
        Piece.romanCapitalChristian: Piece.romanCapitalPagan,
        Piece.hordeSaxonsArian: Piece.hordeSaxonsChristian,
        Piece.hordeSaxonsChristian: Piece.hordeSaxonsArian,
        Piece.hordeTurksPagan: Piece.hordeTurksManichee,
        Piece.hordeTurksManichee: Piece.hordeTurksPagan,
        Piece.hordeTurksChristian: Piece.hordeTurksMuslim,
        Piece.hordeTurksMuslim: Piece.hordeTurksChristian,
        Piece.hordeBulgarsPagan: Piece.hordeBulgarsChristian,
        Piece.hordeBulgarsChristian: Piece.hordeBulgarsPagan,
        Piece.hordeKhazarsPagan: Piece.hordeKhazarsJewish,
        Piece.hordeKhazarsJewish: Piece.hordeKhazarsPagan,
        Piece.hordeVandalsArian: Piece.hordeBerbersMuslim,
        Piece.hordeBerbersMuslim: Piece.hordeVandalsArian,
        Piece.hordeHimyarClans: Piece.hordeShewaMuslim,
        Piece.hordeShewaMuslim: Piece.hordeHimyarClans,
        Piece.jihadWestEurope: Piece.abbasidWestEurope,
        Piece.jihadEastEurope: Piece.abbasidEastEurope,
        Piece.jihadCaucasus: Piece.abbasidCaucasus,
        Piece.jihadCentralAsia: Piece.abbasidCentralAsia,
        Piece.jihadEastAfrica: Piece.abbasidEastAfrica,
        Piece.jihadNorthAfrica: Piece.abbasidNorthAfrica,
        Piece.abbasidWestEurope: Piece.jihadWestEurope,
        Piece.abbasidEastEurope: Piece.jihadEastEurope,
        Piece.abbasidCaucasus: Piece.jihadCaucasus,
        Piece.abbasidCentralAsia: Piece.jihadCentralAsia,
        Piece.abbasidEastAfrica: Piece.jihadEastAfrica,
        Piece.abbasidNorthAfrica: Piece.jihadNorthAfrica,
        Piece.holyRomanEmpire: Piece.unholyArianEmpire,
        Piece.unholyArianEmpire: Piece.holyRomanEmpire,
        Piece.knight0: Piece.prayForPeace0,
        Piece.knight1: Piece.prayForPeace1,
        Piece.knight2: Piece.prayForPeace2,
        Piece.prayForPeace0: Piece.knight0,
        Piece.prayForPeace1: Piece.knight1,
        Piece.prayForPeace2: Piece.knight2,
        Piece.cultIsis0: Piece.nubia,
        Piece.cultIsis1: Piece.baqt,
        Piece.nubia: Piece.cultIsis0,
        Piece.baqt: Piece.cultIsis1,
        Piece.heresyMithra0: Piece.melkite0,
        Piece.heresyMithra1: Piece.melkite1,
        Piece.heresyGnostics0: Piece.melkite2,
        Piece.heresyGnostics1: Piece.melkite3,
        Piece.heresyGnostics2: Piece.melkite4,
        Piece.heresyMarcionite: Piece.melkite5,
        Piece.heresyMontanist: Piece.melkite6,
        Piece.heresySabellian: Piece.melkite7,
        Piece.heresyAdoptionist: Piece.melkite8,
        Piece.heresyManichees0: Piece.melkite9,
        Piece.heresyManichees1: Piece.melkite10,
        Piece.heresyManichees2: Piece.melkite11,
        Piece.heresyPelagian: Piece.melkite12,
        Piece.heresyMonothelete: Piece.melkite13,
        Piece.heresyPaulician: Piece.melkite14,
        Piece.heresyIconoclast: Piece.melkite15,
        Piece.heresyBogomil: Piece.melkite16,
        Piece.heresyCathar: Piece.melkite17,
        Piece.melkite0: Piece.heresyMithra0,
        Piece.melkite1: Piece.heresyMithra1,
        Piece.melkite2: Piece.heresyGnostics0,
        Piece.melkite3: Piece.heresyGnostics1,
        Piece.melkite4: Piece.heresyGnostics2,
        Piece.melkite5: Piece.heresyMarcionite,
        Piece.melkite6: Piece.heresyMontanist,
        Piece.melkite7: Piece.heresySabellian,
        Piece.melkite8: Piece.heresyAdoptionist,
        Piece.melkite9: Piece.heresyManichees0,
        Piece.melkite10: Piece.heresyManichees1,
        Piece.melkite11: Piece.heresyManichees2,
        Piece.melkite12: Piece.heresyPelagian,
        Piece.melkite13: Piece.heresyMonothelete,
        Piece.melkite14: Piece.heresyPaulician,
        Piece.melkite15: Piece.heresyIconoclast,
        Piece.melkite16: Piece.heresyBogomil,
        Piece.melkite17: Piece.heresyCathar,
        Piece.apostleWestEurope: Piece.relicsWestEurope,
        Piece.apostleEastEurope: Piece.relicsEastEurope,
        Piece.apostleCaucasus: Piece.relicsCaucasus,
        Piece.apostleCentralAsia: Piece.relicsCentralAsia,
        Piece.apostleEastAfrica: Piece.relicsEastAfrica,
        Piece.apostleNorthAfrica: Piece.relicsNorthAfrica,
        Piece.apostleJerusalem: Piece.relicsJerusalem,
        Piece.relicsWestEurope: Piece.apostleWestEurope,
        Piece.relicsEastEurope: Piece.apostleEastEurope,
        Piece.relicsCaucasus: Piece.apostleCaucasus,
        Piece.relicsCentralAsia: Piece.apostleCentralAsia,
        Piece.relicsEastAfrica: Piece.apostleEastAfrica,
        Piece.relicsNorthAfrica: Piece.apostleNorthAfrica,
        Piece.relicsJerusalem: Piece.apostleJerusalem,
        Piece.bishopWestEurope: Piece.archbishopWestEurope,
        Piece.bishopEastEurope: Piece.archbishopEastEurope,
        Piece.bishopCaucasus: Piece.archbishopCaucasus,
        Piece.bishopCentralAsia: Piece.archbishopCentralAsia,
        Piece.bishopEastAfrica: Piece.archbishopEastAfrica,
        Piece.bishopNorthAfrica: Piece.archbishopNorthAfrica,
        Piece.archbishopWestEurope: Piece.bishopWestEurope,
        Piece.archbishopEastEurope: Piece.bishopEastEurope,
        Piece.archbishopCaucasus: Piece.bishopCaucasus,
        Piece.archbishopCentralAsia: Piece.bishopCentralAsia,
        Piece.archbishopEastAfrica: Piece.bishopEastAfrica,
        Piece.archbishopNorthAfrica: Piece.bishopNorthAfrica,
        Piece.popeEastEurope: Piece.schismEastEurope,
        Piece.popeCaucasus: Piece.schismCaucasus,
        Piece.popeCentralAsia: Piece.schismCentralAsia,
        Piece.popeEastAfrica: Piece.schismEastAfrica,
        Piece.popeNorthAfrica: Piece.schismNorthAfrica,
        Piece.schismEastEurope: Piece.popeEastEurope,
        Piece.schismCaucasus: Piece.popeCaucasus,
        Piece.schismCentralAsia: Piece.popeCentralAsia,
        Piece.schismEastAfrica: Piece.popeEastAfrica,
        Piece.schismNorthAfrica: Piece.popeNorthAfrica,
        Piece.kingWestEurope: Piece.tyrantWestEurope,
        Piece.kingEastEurope: Piece.tyrantEastEurope,
        Piece.kingCaucasus: Piece.tyrantCaucasus,
        Piece.kingCentralAsia: Piece.tyrantCentralAsia,
        Piece.kingEastAfrica: Piece.tyrantEastAfrica,
        Piece.kingNorthAfrica: Piece.tyrantNorthAfrica,
        Piece.tyrantWestEurope: Piece.kingWestEurope,
        Piece.tyrantEastEurope: Piece.kingEastEurope,
        Piece.tyrantCaucasus: Piece.kingCaucasus,
        Piece.tyrantCentralAsia: Piece.kingCentralAsia,
        Piece.tyrantEastAfrica: Piece.kingEastAfrica,
        Piece.tyrantNorthAfrica: Piece.kingNorthAfrica,
        Piece.faithOrthodox: Piece.faithSubmit0,
        Piece.faithNestorian: Piece.faithSubmit1,
        Piece.faithOneNature0: Piece.faithSubmit2,
        Piece.faithOneNature1: Piece.faithSubmit3,
        Piece.faithDonatist: Piece.faithSubmit4,
        Piece.faithApollinarian: Piece.faithSubmit5,
        Piece.faithArian: Piece.faithSubmit6,
        Piece.faithSubmit0: Piece.faithOrthodox,
        Piece.faithSubmit1: Piece.faithNestorian,
        Piece.faithSubmit2: Piece.faithOneNature0,
        Piece.faithSubmit3: Piece.faithOneNature1,
        Piece.faithSubmit4: Piece.faithDonatist,
        Piece.faithSubmit5: Piece.faithApollinarian,
        Piece.faithSubmit6: Piece.faithArian,
        Piece.occupiedSpain: Piece.reconquista,
        Piece.reconquista: Piece.occupiedSpain,
        Piece.emperorChristian: Piece.emperorHeretical,
        Piece.emperorHeretical: Piece.emperorChristian,
        Piece.romanaPax: Piece.romanaLex,
        Piece.romanaLex: Piece.romanaPax,
        Piece.persiaZoroastrian: Piece.persiaMuslim,
        Piece.persiaMuslim: Piece.persiaZoroastrian,
        Piece.bibleLatin: Piece.bibleUsedLatin,
        Piece.bibleGreek: Piece.bibleUsedGreek,
        Piece.bibleArmenian: Piece.bibleUsedArmenian,
        Piece.bibleSyriac: Piece.bibleUsedSyriac,
        Piece.bibleCoptic: Piece.bibleUsedCoptic,
        Piece.bibleUsedLatin: Piece.bibleLatin,
        Piece.bibleUsedGreek: Piece.bibleGreek,
        Piece.bibleUsedArmenian: Piece.bibleArmenian,
        Piece.bibleUsedSyriac: Piece.bibleSyriac,
        Piece.bibleUsedCoptic: Piece.bibleCoptic,
        Piece.waferCoin1: Piece.waferAction1,
        Piece.waferCoin2: Piece.waferAction2,
        Piece.waferCoin3: Piece.waferAction3,
        Piece.waferCoin4: Piece.waferAction4,
        Piece.waferCoin5: Piece.waferAction5,
        Piece.waferCoin6: Piece.waferAction6,
        Piece.waferCoin7: Piece.waferAction7,
        Piece.waferCoin8: Piece.waferAction8,
        Piece.waferCoin9: Piece.waferAction9,
        Piece.waferCoin10: Piece.waferAction10,
        Piece.waferCoin11: Piece.waferAction11,
        Piece.waferCoin12: Piece.waferAction12,
        Piece.waferCoin13: Piece.waferAction13,
        Piece.waferCoin14: Piece.waferAction14,
        Piece.waferCoin15: Piece.waferAction15,
        Piece.waferCoin16: Piece.waferAction16,
        Piece.waferCoin17: Piece.waferAction17,
        Piece.waferCoin18: Piece.waferAction18,
        Piece.waferCoin19: Piece.waferAction19,
        Piece.waferCoin20: Piece.waferAction20,
        Piece.waferCoin21: Piece.waferAction21,
        Piece.waferCoin22: Piece.waferAction22,
        Piece.waferCoin23: Piece.waferAction23,
        Piece.waferCoin24: Piece.waferAction24,
        Piece.waferCoin25: Piece.waferAction25,
        Piece.waferCoin26: Piece.waferAction26,
        Piece.waferCoin27: Piece.waferAction27,
        Piece.waferCoin28: Piece.waferAction28,
        Piece.waferCoin29: Piece.waferAction29,
        Piece.waferCoin30: Piece.waferAction30,
        Piece.waferCoin31: Piece.waferAction31,
        Piece.waferCoin32: Piece.waferAction32,
        Piece.waferAction1: Piece.waferCoin1,
        Piece.waferAction2: Piece.waferCoin2,
        Piece.waferAction3: Piece.waferCoin3,
        Piece.waferAction4: Piece.waferCoin4,
        Piece.waferAction5: Piece.waferCoin5,
        Piece.waferAction6: Piece.waferCoin6,
        Piece.waferAction7: Piece.waferCoin7,
        Piece.waferAction8: Piece.waferCoin8,
        Piece.waferAction9: Piece.waferCoin9,
        Piece.waferAction10: Piece.waferCoin10,
        Piece.waferAction11: Piece.waferCoin11,
        Piece.waferAction12: Piece.waferCoin12,
        Piece.waferAction13: Piece.waferCoin13,
        Piece.waferAction14: Piece.waferCoin14,
        Piece.waferAction15: Piece.waferCoin15,
        Piece.waferAction16: Piece.waferCoin16,
        Piece.waferAction17: Piece.waferCoin17,
        Piece.waferAction18: Piece.waferCoin18,
        Piece.waferAction19: Piece.waferCoin19,
        Piece.waferAction20: Piece.waferCoin20,
        Piece.waferAction21: Piece.waferCoin21,
        Piece.waferAction22: Piece.waferCoin22,
        Piece.waferAction23: Piece.waferCoin23,
        Piece.waferAction24: Piece.waferCoin24,
        Piece.waferAction25: Piece.waferCoin25,
        Piece.waferAction26: Piece.waferCoin26,
        Piece.waferAction27: Piece.waferCoin27,
        Piece.waferAction28: Piece.waferCoin28,
        Piece.waferAction29: Piece.waferCoin29,
        Piece.waferAction30: Piece.waferCoin30,
        Piece.waferAction31: Piece.waferCoin31,
        Piece.waferAction32: Piece.waferCoin32,
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
    setPieceLocation(pieceFlipSide(piece)!, pieceLocation(piece));
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

  bool pieceGrantsReligiousFreedom(Piece piece) {
    const religiousFreedomPieces = [
      Piece.occupiedSpain,
      Piece.popeWestEurope,
      Piece.popeEastEurope,
      Piece.popeCaucasus,
      Piece.popeCentralAsia,
      Piece.popeEastAfrica,
      Piece.popeNorthAfrica,
      Piece.schismEastEurope,
      Piece.schismCaucasus,
      Piece.schismCentralAsia,
      Piece.schismEastAfrica,
      Piece.schismNorthAfrica,
      Piece.kingWestEurope,
      Piece.kingEastEurope,
      Piece.kingCaucasus,
      Piece.kingCentralAsia,
      Piece.kingEastAfrica,
      Piece.kingNorthAfrica,
      Piece.holyRomanEmpire,
      Piece.hordeTurksChristian,
      Piece.hordeVandalsArian,
      Piece.hordeHimyarClans,
      Piece.hordeSaxonsChristian,
      Piece.hordeTurksManichee,
      Piece.hordeBulgarsChristian,
      Piece.hordeKhazarsJewish,
      Piece.infrastructureUniversity0,
      Piece.infrastructureUniversity1,
      Piece.bibleGreek,
      Piece.bibleLatin,
      Piece.bibleArmenian,
      Piece.bibleSyriac,
      Piece.bibleCoptic,
      Piece.greatTheologian,
    ];
    if (religiousFreedomPieces.contains(piece)) {
      return true;
    }
    if (piece.isType(PieceType.persianEmpire) && pieceLocation(Piece.persiaZoroastrian) == Location.boxPersianReligion) {
      return true;
    }
    return false;
  }

  int limitedEventCount(LimitedEvent event) {
    return _limitedEventCounts[event.index];
  }

  void limitedEventOccurred(LimitedEvent event) {
    _limitedEventCounts[event.index] += 1;
  }

  // Lands

  Path? landPath(Location land) {
    for (final path in Path.values) {
      final locationType = pathLocationType(path);
      if (land.isType(locationType)) {
        return path;
      }
    }
    return null;
  }

  bool landIsHomeland(Location land) {
    const homelands = [
      Location.homelandSaxons,
      Location.homelandBulgars,
      Location.homelandKhazars,
      Location.homelandTurks,
      Location.homelandHimyar,
      Location.homelandVandals
    ];
    return homelands.contains(land);
  }

  List<Location> get bigCities {
    return [
      Location.landRome,
      Location.landConstantinople,
      Location.landArmenia,
      Location.landCtesiphon,
      Location.landAlexandria,
      Location.landCarthage,
    ];
  }
  bool landIsBigCity(Location land) {
    return bigCities.contains(land);
  }

  Piece? landControl(Location land) {
    if (land == Location.landJerusalem) {
      return null;  // Roman prior to turn 21, arab thereafter
    }
    var control = pieceInLocation(PieceType.control, land);
    if (control != null) {
      return control;
    }
    final path = landPath(land)!;
    bool inner = true;
    for (Location? otherLand = pathLand(path, 0); otherLand != null; otherLand = pathSucceedingLand(path, otherLand)) {
      if (otherLand == land) {
        if (control != null) {
          return control;
        }
        inner = false;
      } else if (inner) {
        final otherControl = pieceInLocation(PieceType.outerControl, otherLand);
        if (otherControl != null) {
          control = otherControl;
        }
      } else {
        control = pieceInLocation(PieceType.innerControl, otherLand);
        if (control != null) {
          return control;
        }
      }
    }
    return null;    
  }

  bool landControlHostile(Location land) {
    if (land == Location.landJerusalem) {
      return pieceLocation(Piece.occupiedJerusalem) == land;
    }
    final control = landControl(land);
    if (control == null) {
      return false;
    }
    return pieceHostile(control);
  }

  bool landControlRoman(Location land) {
    if (land == Location.landJerusalem) {
      return pieceLocation(Piece.occupiedJerusalem) != land;
    }
    final control = landControl(land);
    if (control == null) {
      return false;
    }
    return control.isType(PieceType.romanControl);
  }

  bool landControlArab(Location land) {
    if (land == Location.landJerusalem) {
      return pieceLocation(Piece.occupiedJerusalem) == land;
    }
    if (pieceLocation(Piece.occupiedSpain) == land) {
      return true;
    }
    final control = landControl(land);
    if (control == null) {
      return false;
    }
    return pieceArab(control);
  }

  bool landControlChristian(Location land) {
    if (land == Location.landJerusalem) {
      return pieceLocation(Piece.occupiedJerusalem) != land;
    }
    final control = landControl(land);
    if (control == null) {
      return pieceLocation(Piece.papalStates) == land;  // Diverges from 7.13
    }
    if (control.isType(PieceType.romanControl)) {
      return true;
    }
    if (control == Piece.nubia) {
      return true;
    }
    if (control.isType(PieceType.horde)) {
      return hordeChristian(control);
    }
    if (control.isType(PieceType.king)) {
      return true;
    }
    return false;
  }

  bool landControlPlayer(Location land) {
    if (land == Location.landJerusalem) {
      return pieceLocation(Piece.occupiedJerusalem) != land;
    }
    final control = landControl(land);
    if (control == null) {
      return pieceLocation(Piece.papalStates) == land;
    }
    return control.isType(PieceType.romanControl);
  }

  bool landChristian(Location land) {
    final field = pieceInLocation(PieceType.fieldChristian, land);
    if (field == null) {
      return false;
    }
    return piecesInLocationCount(PieceType.heresy, land) == 0;
  }

  List<Piece> landArmies(Location land) {
    final armies = <Piece>[];
    for (final piece in piecesInLocation(PieceType.all, land)) {
      if (pieceIsArmy(piece)) {
        armies.add(piece);
      }
    }
    return armies;
  }

  // Paths

  LocationType pathLocationType(Path path) {
    const pathLocationTypes = [
      LocationType.pathWestEurope,
      LocationType.pathEastEurope,
      LocationType.pathCaucasus,
      LocationType.pathCentralAsia,
      LocationType.pathEastAfrica,
      LocationType.pathNorthAfrica,
    ];
    return pathLocationTypes[path.index];
  }

  PieceType pathHordeType(Path path) {
    const pathHordeTypes = [
      PieceType.hordeWestEurope,
      PieceType.hordeEastEurope,
      PieceType.hordeCaucasus,
      PieceType.hordeCentralAsia,
      PieceType.hordeEastAfrica,
      PieceType.hordeNorthAfrica,
    ];
    return pathHordeTypes[path.index];
  }

  Location pathFirstLand(Path path) {
    final locationType = pathLocationType(path);
    return Location.values[locationType.firstIndex];
  }

  Location pathHomeland(Path path) {
    final locationType = pathLocationType(path);
    return Location.values[locationType.lastIndex - 1];
  }

  int pathLandCount(Path path) {
    final locationType = pathLocationType(path);
    return locationType.lastIndex - locationType.firstIndex + 1;
  }

  Location pathLand(Path path, int sequence) {
    final locationType = pathLocationType(path);
    return Location.values[locationType.firstIndex + sequence];
  }

  Location? pathPrecedingLand(Path path, Location land) {
    if (land == Location.landJerusalem) {
      return null;
    }
    final locationType = pathLocationType(path);
    int sequence = land.index - locationType.firstIndex;
    if (sequence == 0) {
      return Location.landJerusalem;
    }
    sequence -= 1;
    final precedingLand = pathLand(path, sequence);
    if (pieceLocation(Piece.occupiedSpain) == precedingLand) {
      return Location.landMilan;
    }
    return precedingLand;
  }

  Location? pathSucceedingLand(Path path, Location land) {
    if (landIsHomeland(land)) {
      return null;
    }
    final locationType = pathLocationType(path);
    int sequence = land == Location.landJerusalem ? -1 : land.index - locationType.firstIndex;
    sequence += 1;
    final succeedingLand = pathLand(path, sequence);
    if (pieceLocation(Piece.occupiedSpain) == succeedingLand) {
      return pathLand(path, sequence + 1);
    }
    return succeedingLand;
  }

  Location pathBigCity(Path path) {
    const pathBigCities = [
      Location.landRome,
      Location.landConstantinople,
      Location.landArmenia,
      Location.landCtesiphon,
      Location.landAlexandria,
      Location.landCarthage,
    ];
    return pathBigCities[path.index];
  }

  Location pathFaithBox(Path path) {
    return Location.values[LocationType.boxFaith.firstIndex + path.index];
  }

  Piece? pathFaith(Path path) {
    final box = pathFaithBox(path);
    return pieceInLocation(PieceType.faith, box);
  }

  Piece? pathActiveRomanControl(Path path) {
    Piece? pagan;
    switch (path) {
    case Path.westEurope:
      pagan = Piece.romanControlPaganWestEurope;
    case Path.eastEurope:
      pagan = Piece.romanControlPaganEastEurope;
    case Path.caucasus:
      pagan = Piece.romanControlPaganCaucasus;
    case Path.eastAfrica:
      pagan = Piece.romanControlPaganEastAfrica;
    case Path.northAfrica:
      pagan = Piece.romanControlPaganNorthAfrica;
    case Path.centralAsia:
      return null;
    }
    var location = pieceLocation(pagan);
    if (location.isType(LocationType.land)) {
      return pagan;
    }
    Piece christian = pieceFlipSide(pagan)!;
    location = pieceLocation(christian);
    if (location.isType(LocationType.land)) {
      return christian;
    }
    return null;
  }

  Piece pathJihad(Path path) {
    return Piece.values[PieceType.jihad.firstIndex + path.index];
  }

  Piece pathAbbasid(Path path) {
    return Piece.values[PieceType.abbasid.firstIndex + path.index];
  }

  Piece? pathActiveJihad(Path path) {
    final jihad = pathJihad(path);
    if (pieceLocation(jihad).isType(LocationType.land)) {
      return jihad;
    }
    final abbasid = pathAbbasid(path);
    if (pieceLocation(abbasid).isType(LocationType.land)) {
      final land = pieceLocation(abbasid);
      if (pieceLocation(Piece.baqt) != land) {
        return abbasid;
      }
    }
    if (path == Path.eastEurope) {
      const seljuks = Piece.hordeSeljuksMuslim;
      if (pieceLocation(seljuks).isType(LocationType.land)) {
        return seljuks;
      }
    }
    return null;
  }

  Piece pathActiveHorde(Path path) {
    final hordeType = pathHordeType(path);
    for (final horde in hordeType.pieces) {
      if (pieceLocation(horde).isType(LocationType.land)) {
        return horde;
      }
    }
    return Piece.baqt;
  }

  Piece pathKing(Path path) {
    return Piece.values[PieceType.king.firstIndex + path.index];
  }

  Piece pathTyrant(Path path) {
    return Piece.values[PieceType.tyrant.firstIndex + path.index];
  }

  Piece? pathActiveRuler(Path path) {
    final king = pathKing(path);
    if (pieceLocation(king).isType(LocationType.land)) {
      return king;
    }
    final tyrant = pathTyrant(path);
    if (pieceLocation(tyrant).isType(LocationType.land)) {
      return tyrant;
    }
    return null;
  }

  Piece pathApostle(Path path) {
    return Piece.values[PieceType.apostle.firstIndex + path.index];
  }

  Piece pathBishop(Path path) {
    return Piece.values[PieceType.bishop.firstIndex + path.index];
  }

  Piece pathArchbishop(Path path) {
    return Piece.values[PieceType.archbishop.firstIndex + path.index];
  }

  Piece pathActiveMissionary(Path path) {
    final apostle = pathApostle(path);
    if (pieceLocation(apostle).isType(LocationType.land)) {
      return apostle;
    }
    final bishop = pathBishop(path);
    if (pieceLocation(bishop).isType(LocationType.land)) {
      return bishop;
    }
    return pathArchbishop(path);
  }

  Piece pathPope(Path path) {
    return Piece.values[PieceType.pope.firstIndex + path.index];
  }

  Piece? pathSchism(Path path) {
    if (path == Path.westEurope) {
      return null;
    }
    return Piece.values[PieceType.popeSchism.firstIndex + path.index - 1];
  }

  bool pathInCommunion(Path path) {
    final location = pieceLocation(pathPope(path));
    if (!location.isType(LocationType.land)) {
      return false;
    }
    if (piecesInLocationCount(PieceType.heresy, location) != 0) {
      return false;
    }
    return true;
  }

  bool pathInSchism(Path path) {
    if (path == Path.westEurope) {
      return false;
    }
    return pieceLocation(pathSchism(path)!) != Location.flipped;
  }

  Piece pathUnusedBible(Path path) {
    const pathUnusedBibles = [
      Piece.bibleLatin,
      Piece.bibleGreek,
      Piece.bibleArmenian,
      Piece.bibleSyriac,
      Piece.bibleCoptic,
      Piece.bibleLatin,
    ];
    return pathUnusedBibles[path.index];
  }

  int pathInfrastructureCount(Path path) {
    final locationType = pathLocationType(path);
    int count = 0;
    for (final piece in PieceType.infrastructure.pieces) {
      if (pieceLocation(piece).isType(locationType)) {
        count += 1;
      }
    }
    return count;
  }

  // Fields

  int fieldValue(Piece field) {
    const fieldValues = {
      Piece.fieldPagan0Ascetics2: 2,
      Piece.fieldPagan1Ascetics3: 3,
      Piece.fieldPagan2Ascetics3: 3,
      Piece.fieldPagan3Ascetics3: 3,
      Piece.fieldPagan4Ascetics4: 4,
      Piece.fieldPagan5Jews3: 3,
      Piece.fieldPagan6Jews3: 3,
      Piece.fieldPagan7Jews3: 3,
      Piece.fieldPagan8Jews4: 4,
      Piece.fieldPagan9Jews4: 4,
      Piece.fieldPagan10Martyrs3: 3,
      Piece.fieldPagan11Martyrs3: 3,
      Piece.fieldPagan12Martyrs4: 4,
      Piece.fieldPagan13Martyrs4: 4,
      Piece.fieldPagan14Physicians2: 2,
      Piece.fieldPagan15Poor1: 1,
      Piece.fieldPagan16Poor1: 1,
      Piece.fieldPagan17Poor1: 1,
      Piece.fieldPagan18Poor1: 1,
      Piece.fieldPagan19Poor2: 2,
      Piece.fieldPagan20Poor2: 2,
      Piece.fieldPagan21Scholars3: 3,
      Piece.fieldPagan22Scholars4: 4,
      Piece.fieldPagan23Scholars4: 4,
      Piece.fieldPagan24Slaves1: 1,
      Piece.fieldPagan25Slaves2: 2,
      Piece.fieldPagan26Slaves2: 2,
      Piece.fieldPagan27Slaves3: 3,
      Piece.fieldPagan28Slaves3: 3,
      Piece.fieldPagan29Slaves4: 4,
      Piece.fieldPagan30Wealthy4: 4,
      Piece.fieldPagan31Women1: 1,
      Piece.fieldPagan32Women1: 1,
      Piece.fieldPagan33Women2: 2,
      Piece.fieldPagan34Women2: 2,
      Piece.fieldPagan35Women2: 2,
      Piece.fieldPagan36Women3: 3,
      Piece.fieldPagan37Women3: 3,
      Piece.fieldChristian0Ascetics1: 1,
      Piece.fieldChristian1Ascetics2: 2,
      Piece.fieldChristian2Ascetics2: 2,
      Piece.fieldChristian3Ascetics2: 2,
      Piece.fieldChristian4Ascetics3: 3,
      Piece.fieldChristian5Jews2: 2,
      Piece.fieldChristian6Jews2: 2,
      Piece.fieldChristian7Jews2: 2,
      Piece.fieldChristian8Jews3: 3,
      Piece.fieldChristian9Jews3: 3,
      Piece.fieldChristian10Martyrs3: 3,
      Piece.fieldChristian11Martyrs3: 3,
      Piece.fieldChristian12Martyrs4: 4,
      Piece.fieldChristian13Martyrs4: 4,
      Piece.fieldChristian14Physicians2: 2,
      Piece.fieldChristian15Poor1: 1,
      Piece.fieldChristian16Poor1: 1,
      Piece.fieldChristian17Poor1: 1,
      Piece.fieldChristian18Poor1: 1,
      Piece.fieldChristian19Poor2: 2,
      Piece.fieldChristian20Poor2: 2,
      Piece.fieldChristian21Scholars2: 2,
      Piece.fieldChristian22Scholars3: 3,
      Piece.fieldChristian23Scholars3: 3,
      Piece.fieldChristian24Slaves1: 1,
      Piece.fieldChristian25Slaves2: 2,
      Piece.fieldChristian26Slaves2: 2,
      Piece.fieldChristian27Slaves3: 3,
      Piece.fieldChristian28Slaves3: 3,
      Piece.fieldChristian29Slaves4: 4,
      Piece.fieldChristian30Wealthy3: 3,
      Piece.fieldChristian31Women1: 1,
      Piece.fieldChristian32Women1: 1,
      Piece.fieldChristian33Women2: 2,
      Piece.fieldChristian34Women2: 2,
      Piece.fieldChristian35Women2: 2,
      Piece.fieldChristian36Women3: 3,
      Piece.fieldChristian37Women3: 3,
    };
    return fieldValues[field]!;
  }

  bool fieldIsMartyrs(Piece field) {
    return field.isType(PieceType.fieldPaganMartyrs) || field.isType(PieceType.fieldChristianMartyrs);
  }

  // Hordes

  bool hordeAllied(Piece horde) {
    const alliedHordes = [
      Piece.hordeSaxonsChristian,
      Piece.hordeTurksChristian,
      Piece.hordeBulgarsChristian,
      Piece.hordeKhazarsJewish,
    ];
    return alliedHordes.contains(horde);
  }

  bool hordeChristian(Piece horde) {
    const christianHordes = [
      Piece.hordeSaxonsChristian,
      Piece.hordeTurksChristian,
      Piece.hordeBulgarsChristian,
    ];
    return christianHordes.contains(horde);
  }

  // Control Pieces

  bool pieceArab(Piece piece) {
    if (piece.isType(PieceType.jihad)) {
      return true;
    }
    if (piece.isType(PieceType.abbasid)) {
      return true;
    }
    if (piece == Piece.hordeSeljuksMuslim) {
      return true;
    }
    return false;
  }

  bool pieceHostile(Piece piece) {
    if (pieceArab(piece)) {
      return true;
    }
    if (piece.isType(PieceType.tyrant)) {
      return true;
    }
    if (piece.isType(PieceType.horde)) {
      return !hordeAllied(piece);
    }
    return false;
  }

  // Armies

  bool pieceIsArmy(Piece piece) {
    return armyData[piece] != null;
  }

  ArmyType armyType(Piece army) {
    return armyData[army]!.$1;
  }

  int advanceForceStrength(Piece army) {
    return armyData[army]!.$2;
  }

  // Heresies

  int heresyValue(Piece heresy) {
    const heresyValues = {
      Piece.heresyMithra0: 4,
      Piece.heresyMithra1: 4,
      Piece.heresyEbionite0: 4,
      Piece.heresyEbionite1: 4,
      Piece.heresyEbionite2: 4,
      Piece.heresyGnostics0: 5,
      Piece.heresyGnostics1: 5,
      Piece.heresyGnostics2: 5,
      Piece.heresyMarcionite: 3,
      Piece.heresyMontanist: 5,
      Piece.heresySabellian: 4,
      Piece.heresyAdoptionist: 4,
      Piece.heresyManichees0: 5,
      Piece.heresyManichees1: 5,
      Piece.heresyManichees2: 5,
      Piece.heresyPelagian: 3,
      Piece.heresyMonothelete: 3,
      Piece.heresyPaulician: 5,
      Piece.heresyIconoclast: 5,
      Piece.heresyBogomil: 4,
      Piece.heresyCathar: 5,
    };
    return heresyValues[heresy]!;
  }

  // Missionaries

  PieceType missionaryPieceType(Piece missionary) {
    for (final pieceType in [PieceType.apostle, PieceType.bishop, PieceType.archbishop, PieceType.popeNonSchism, PieceType.popeSchism]) {
      if (missionary.isType(pieceType)) {
        return pieceType;
      }
    }
    return PieceType.all;
  }

  bool missionaryCanBeUsed(Piece missionary) {
    if (missionary.isType(PieceType.apostle)) {
      return true;
    }
    if (pieceLocation(Piece.emperorHeretical) != Location.boxRomanPolicy) {
      return true;
    }
    final land = pieceLocation(missionary);
    if (landControlRoman(land)) {
      return false;
    }
    return true;
  }

  Path? missionaryPath(Piece missionary) {
    if (missionary == Piece.apostleJerusalem) {
      return null;
    }
    final pieceType = missionaryPieceType(missionary);
    if (pieceType == PieceType.popeSchism) {
      return Path.values[missionary.index - pieceType.firstIndex + Path.eastEurope.index];
    }
    return Path.values[missionary.index - pieceType.firstIndex];
  }

  // Bibles

  String bibleLanguageName(Piece bible) {
    const languageNames = {
      Piece.bibleLatin: 'Latin',
      Piece.bibleGreek: 'Greek',
      Piece.bibleArmenian: 'Armenian',
      Piece.bibleSyriac: 'Syriac',
      Piece.bibleCoptic: 'Coptic',
    };
    return languageNames[bible]!;
  }

  // Faiths

  int faithValue(Piece faith) {
    const faithValues = {
      Piece.faithOrthodox: 5,
      Piece.faithNestorian: 2,
      Piece.faithOneNature0: 2,
      Piece.faithOneNature1: 2,
      Piece.faithDonatist: 2,
      Piece.faithApollinarian: 3,
      Piece.faithArian: 1,
    };
    return faithValues[faith]!;
  }

  // Wafers

  int waferCoinValue(Piece wafer) {
    return waferCoinData[wafer]!.$1;
  }

  bool waferCoinChangeRomanPolicy(Piece wafer) {
    return waferCoinData[wafer]!.$2;
  }

  // Track

  Location trackBox(int value) {
    return Location.values[LocationType.boxTrack.firstIndex + value];
  }

  // Solidi

  int get solidi {
    final location = pieceLocation(Piece.solidus);
    return location.index - LocationType.boxTrack.firstIndex;
  }

  void adjustSolidi(int delta) {
    int total = solidi + delta;
    if (total > 10) {
      total = 10;
    } else if (total < 0) {
      total = 0;
    }
    setPieceLocation(Piece.solidus, trackBox(total));
  }

  // Dark Ages

  int get darkAges {
    final location = pieceLocation(Piece.darkAges);
    return location.index - LocationType.boxTrack.firstIndex;
  }

  void adjustDarkAges(int delta) {
    int total = darkAges + delta;
    if (total > 10) {
      total = 10;
    } else if (total < 0) {
      total = 0;
    }
    setPieceLocation(Piece.darkAges, trackBox(total));
  }

  // Turns

  Location actsBox(int turn) {
    return Location.values[LocationType.boxActs.firstIndex + turn - 1];
  }

  int get currentTurn {
    final location = pieceLocation(Piece.gameTurn);
    return location.index - LocationType.boxActs.firstIndex + 1;
  }

  void advanceTurn() {
    setPieceLocation(Piece.gameTurn, actsBox(currentTurn + 1));
  }

  String turnName(int turn) {
    const turnNames = [
      '30-60 AD',
      '61-90 AD',
      '91-120 AD',
      '121-150 AD',
      '151-180 AD',
      '181-210 AD',
      '211-240 AD',
      '241-270 AD',
      '271-300 AD',
      '301-330 AD',
      '331-360 AD',
      '361-390 AD',
      '391-420 AD',
      '421-450 AD',
      '451-480 AD',
      '481-510 AD',
      '511-554 AD',
      '555-570 AD',
      '571-600 AD',
      '601-630 AD',
      '631-660 AD',
      '661-690 AD',
      '691-720 AD',
      '721-750 AD',
      '751-850 AD',
      '851-999 AD',
      '1000-1094 AD',
      '1095-1291 AD',
    ];
    return turnNames[turn - 1];
  }

  Location? turnGreatTheologian(int turn) {
    const turnGreatTheologians = {
      3: Location.greatTheologianIgnatius,
      6: Location.greatTheologianTertullian,
      7: Location.greatTheologianOrigen,
      8: Location.greatTheologianCyprian,
      11: Location.greatTheologianAthanasius,
      12: Location.greatTheologianJohnChrysostom,
      13: Location.greatTheologianAugustine,
      14: Location.greatTheologianLeo,
      19: Location.greatTheologianGregory,
      23: Location.greatTheologianIsaacOfNineveh,
      24: Location.greatTheologianJohnOfDamascus,
      26: Location.greatTheologianCyrilAndMethodius,
    };
    return turnGreatTheologians[turn];
  }

  String? turnEcumenicalCouncilName(int turn) {
    const turnCouncilNames = {
      10: 'Council of Arles',
      12: 'First Council of Constantinople',
      14: 'Council of Ephesus',
      15: 'Council of Chalcedon',
      18: 'Second Council of Constantinople',
      22: 'Third Council of Constantinople',
      25: 'Second Council of Nicaea',
    };
    return turnCouncilNames[turn];
  }

  // Great Theologians

  List<Path> greatTheologianPaths(Location greatTheologian) {
    const paths = {
      Location.greatTheologianIgnatius: [Path.caucasus, Path.centralAsia],
      Location.greatTheologianTertullian: [Path.eastAfrica, Path.northAfrica],
      Location.greatTheologianOrigen: [Path.centralAsia, Path.eastAfrica],
      Location.greatTheologianCyprian: [Path.eastEurope, Path.northAfrica],
      Location.greatTheologianAthanasius: [Path.caucasus, Path.eastAfrica],
      Location.greatTheologianJohnChrysostom: [Path.eastEurope, Path.centralAsia],
      Location.greatTheologianAugustine: [Path.westEurope, Path.northAfrica],
      Location.greatTheologianLeo: [Path.westEurope, Path.eastAfrica],
      Location.greatTheologianGregory: [Path.westEurope, Path.northAfrica],
      Location.greatTheologianIsaacOfNineveh: [Path.caucasus, Path.centralAsia],
      Location.greatTheologianJohnOfDamascus: [Path.eastEurope, Path.caucasus],
      Location.greatTheologianCyrilAndMethodius: [Path.westEurope, Path.eastEurope],
    };
    return paths[greatTheologian]!;
  }

  // Misc

  Piece get romanPolicy {
    return pieceInLocation(PieceType.romanPolicy, Location.boxRomanPolicy)!;
  }

  bool get emperorChristian {
    return pieceLocation(Piece.emperorChristian) == Location.boxRomanPolicy;
  }

  // Setup

  Location randomLand(Random random) {
    int roll = random.nextInt(36);
    int sequence = roll % 6;
    int pathIndex = roll ~/ 6;
    return pathLand(Path.values[pathIndex], sequence);
  }

  void setupPieces(List<(Piece, Location)> pieces) {
    for (final record in pieces) {
      final piece = record.$1;
      final location = record.$2;
      setPieceLocation(piece, location);
    }
  }

  void randomSetupPieces(Random random, List<Piece> pieces) {
    for (final piece in pieces) {
        final land = randomLand(random);
        setPieceLocation(piece, land);
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
      (PieceType.fieldPagan, Location.trayField),
      (PieceType.waferCoin, Location.trayWafer),
      (PieceType.heresy, Location.trayHeresy),
      (PieceType.popeNonSchism, Location.trayPope),
      (PieceType.bishop, Location.trayPope),
      (PieceType.king, Location.trayPope),
      (PieceType.faithNoSubmit, Location.trayFaith),
      (PieceType.jihad, Location.trayJihad),
      (PieceType.romanControl, Location.trayRoman),
      (PieceType.persianEmpire, Location.trayHorde),
      (PieceType.bibleUnused, Location.trayBible),
      (PieceType.apostle, Location.trayBible),
      (PieceType.knight, Location.trayKnight),
      (PieceType.infrastructure, Location.trayInfrastructure),
    ]);

    state.setupPieces([
        (Piece.gameTurn, Location.trayMisc),
        (Piece.darkAges, Location.trayMisc),
        (Piece.solidus, Location.trayMisc),
        (Piece.papalStates, Location.trayMisc),
        (Piece.greatTheologian, Location.trayMisc),
        (Piece.holyRomanEmpire, Location.trayMisc),
        (Piece.cultIsis0, Location.trayMisc),
        (Piece.cultIsis1, Location.trayMisc),
        (Piece.occupiedJerusalem, Location.trayJihad),
        (Piece.occupiedSpain, Location.trayJihad),
        (Piece.romanArmy, Location.trayRoman),
        (Piece.emperorChristian, Location.trayRoman),
        (Piece.romanCapitalPagan, Location.trayRoman),
        (Piece.romanaPax, Location.trayRoman),
        (Piece.hordeSeljuksMuslim, Location.trayHorde),
        (Piece.hordeSaxonsArian, Location.trayHorde),
        (Piece.hordeTurksPagan, Location.trayHorde),
        (Piece.hordeTurksChristian, Location.trayHorde),
        (Piece.hordeBulgarsPagan, Location.trayHorde),
        (Piece.hordeKhazarsPagan, Location.trayHorde),
        (Piece.hordeVandalsArian, Location.trayHorde),
        (Piece.hordeHimyarClans, Location.trayHorde),
        (Piece.persiaZoroastrian, Location.trayHorde),
    ]);

    return state;
  }

  factory GameState.setupCampaign(Random random) {

    var state = GameState.setupCounterTray();

    final jews = PieceType.fieldPaganJews.pieces;
    jews.shuffle(random);

    for (final field in PieceType.fieldPagan.pieces) {
      if (!field.isType(PieceType.fieldPaganJews)) {
        state.setPieceLocation(field, Location.cupField);
      }
    }

    final persians = PieceType.persianEmpire.pieces;
    persians.shuffle(random);

    state.setupPieceTypes([
      (PieceType.apostle, Location.landJerusalem),
      (PieceType.faithRandom, Location.cupFaith),
      (PieceType.waferCoinSilver, Location.cupWafer),
    ]);

    state.setupPieces([
      (Piece.heresyEbionite0, Location.cupHeresy),
      (Piece.heresyEbionite1, Location.cupHeresy),
      (Piece.heresyEbionite2, Location.cupHeresy),
      (Piece.heresyGnostics0, Location.boxActs2),
      (Piece.heresyGnostics1, Location.boxActs2),
      (Piece.heresyGnostics2, Location.boxActs2),
      (Piece.heresyMarcionite, Location.boxActs4),
      (Piece.heresyMontanist, Location.boxActs5),
      (Piece.heresySabellian, Location.boxActs7),
      (Piece.heresyAdoptionist, Location.boxActs8),
      (Piece.heresyManichees0, Location.boxActs9),
      (Piece.heresyManichees1, Location.boxActs9),
      (Piece.heresyManichees2, Location.boxActs9),
      (Piece.heresyPelagian, Location.boxActs13),
      (Piece.heresyMonothelete, Location.boxActs20),
      (Piece.heresyPaulician, Location.boxActs21),
      (Piece.heresyIconoclast, Location.boxActs24),
      (Piece.heresyBogomil, Location.boxActs26),
      (Piece.heresyCathar, Location.boxActs27),
      (Piece.romanaPax, Location.boxRomanPolicy),
      (Piece.solidus, Location.boxTrack0),
      (Piece.darkAges, Location.boxTrack0),
      (Piece.gameTurn, Location.boxActs1),
      (Piece.romanControlPaganWestEurope, Location.landBritain),
      (Piece.romanControlPaganEastEurope, Location.landDanube),
      (Piece.romanControlPaganCaucasus, Location.landArmenia),
      (Piece.romanControlPaganEastAfrica, Location.landThebes),
      (Piece.romanControlPaganNorthAfrica, Location.landTingitana),
      (Piece.romanArmy, Location.landBelgium),
      (Piece.romanCapitalPagan, Location.landRome),
      (jews[0], Location.landRome),
      (jews[1], Location.landAntioch),
      (jews[2], Location.landCtesiphon),
      (jews[3], Location.landAlexandria),
      (jews[4], Location.landCyrene),
      (persians[0], Location.landCtesiphon),
      (persians[1], Location.landPersia),
      (persians[2], Location.landMerv),
      (Piece.persiaZoroastrian, Location.boxPersianReligion),
    ]);

    state.randomSetupPieces(random, [
      Piece.heresyMithra0,
      Piece.heresyMithra1,
      Piece.cultIsis0,
      Piece.cultIsis1,
    ]);

    return state;
  }

  factory GameState.setupRiseOfIslam(Random random) {

    var state = GameState.setupCounterTray();

    final jews = PieceType.fieldChristianJews.pieces;
    jews.shuffle(random);

    final jewishLands = [Location.landRome, Location.landAntioch, Location.landCtesiphon, Location.landAlexandria, Location.landCyrene];

    final fields = <Piece>[];
    for (final field in PieceType.fieldChristian.pieces) {
      if (!jews.contains(field)) {
        fields.add(field);
      }
    }
    fields.shuffle(random);

    const paganLands = [Location.landBelgium, Location.landGaul, Location.landSpain];

    int fieldIndex = 0;
    for (final land in LocationType.land.locations) {
      if (land != Location.landJerusalem && !state.landIsHomeland(land) && !jewishLands.contains(land)) {
        var field = fields[fieldIndex];
        if (paganLands.contains(land)) {
          field = state.pieceFlipSide(field)!;
        }
        state.setPieceLocation(field, land);
        fieldIndex += 1;
      }
    }

    final persians = PieceType.persianEmpire.pieces;
    persians.shuffle(random);

    for (final bible in PieceType.bibleUnused.pieces) {
      state.setPieceLocation(bible, Location.boxBibleTranslations);
    }

    for (final wafer in PieceType.waferCoinGold.pieces) {
      state.setPieceLocation(wafer, Location.cupWafer);
    }

    for (final melkite in PieceType.melkite.pieces) {
      state.setPieceLocation(melkite, Location.trayHeresy);
    }

    state.setupPieces([
      (fields[fieldIndex], Location.cupField),
      (Piece.emperorChristian, Location.boxRomanPolicy),
      (Piece.persiaZoroastrian, Location.boxPersianReligion),
      (Piece.relicsWestEurope, Location.landRome),
      (Piece.relicsEastEurope, Location.landConstantinople),
      (Piece.relicsCaucasus, Location.landArmenia),
      (Piece.relicsCentralAsia, Location.landCtesiphon),
      (Piece.relicsEastAfrica, Location.landAlexandria),
      (Piece.relicsNorthAfrica, Location.landGreece),
      (Piece.solidus, Location.boxTrack0),
      (Piece.darkAges, Location.boxTrack3),
      (Piece.gameTurn, Location.boxActs21),
      (Piece.romanControlChristianWestEurope, Location.landMilan),
      (Piece.romanControlChristianEastEurope, Location.landConstantinople),
      (Piece.romanControlChristianCaucasus, Location.landAntioch),
      (Piece.romanControlChristianEastAfrica, Location.landThebes),
      (Piece.romanControlChristianNorthAfrica, Location.landNumidia),
      (Piece.papalStates, Location.landRome),
      (Piece.romanCapitalChristian, Location.landConstantinople),
      (persians[0], Location.landMerv),
      (persians[1], Location.landCtesiphon),
      (persians[2], Location.landPersia),
      (Piece.nubia, Location.landAlodia),
      (jews[0], jewishLands[0]),
      (jews[1], jewishLands[1]),
      (jews[2], jewishLands[2]),
      (jews[3], jewishLands[3]),
      (jews[4], jewishLands[4]),
      (Piece.faithCatholic, Location.boxFaithWestEurope),
      (Piece.faithOrthodoxEagle, Location.boxFaithEastEurope),
      (Piece.faithOneNature0, Location.boxFaithCaucasus),
      (Piece.faithNestorian, Location.boxFaithCentralAsia),
      (Piece.faithOneNature1, Location.boxFaithEastAfrica),
      (state.pieceFlipSide(Piece.faithDonatist)!, Location.boxFaithNorthAfrica),
      (Piece.popeWestEurope, Location.landRome),
      (Piece.archbishopWestEurope, Location.landRome),
      (Piece.popeEastEurope, Location.landConstantinople),
      (Piece.archbishopEastEurope, Location.landConstantinople),
      (Piece.schismCaucasus, Location.landArmenia),
      (Piece.archbishopCaucasus, Location.landArmenia),
      (Piece.schismCentralAsia, Location.landCtesiphon),
      (Piece.archbishopCentralAsia, Location.landCtesiphon),
      (Piece.schismEastAfrica, Location.landAlexandria),
      (Piece.archbishopEastAfrica, Location.landAlexandria),
      (Piece.popeNorthAfrica, Location.landCarthage),
      (Piece.archbishopNorthAfrica, Location.landCarthage),
      (Piece.tyrantEastEurope, Location.landDanube),
      (Piece.kingCaucasus, Location.landGeorgia),
      (Piece.kingEastAfrica, Location.landEthiopia),
      (Piece.hordeSaxonsArian, Location.landSpain),
      (Piece.hordeBulgarsPagan, Location.landKiev),
      (Piece.hordeKhazarsPagan, Location.landAlania),
      (Piece.hordeTurksPagan, Location.landKashgar),
      (Piece.hordeHimyarClans, Location.homelandHimyar),
      (Piece.hordeVandalsArian, Location.homelandVandals),
      (Piece.heresyPaulician, Location.boxActs21),
      (Piece.heresyIconoclast, Location.boxActs24),
      (Piece.heresyBogomil, Location.boxActs26),
      (Piece.heresyCathar, Location.boxActs27),
    ]);
    return state;
  }
}

enum Choice {
  moveMissionary,
  moveApostleFree,
  buildHospital,
  buildMonastery,
  buildUniversity,
  buildMelkite,
  moveCapital,
  moveKnightPrayForPeace,
  translateBible,
  endHeresy,
  convertHorde,
  convertTyrant,
  evangelism,
  evangelismComplete,
  revivalism,
  reconciliation,
  persecute,
  offensive,
  sellRelics,
  reconquista,
  paySolidi,
  payBible,
  payIsis,
  payJames,
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
  defeatDarkAges,
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
  secular,
  religious,
  endOfTurn,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateSecular extends PhaseState {
  Path? jihadPath;
  int? jihadMoveCount;

  PhaseStateSecular();

  PhaseStateSecular.fromJson(Map<String, dynamic> json) {
    jihadPath = pathFromIndex(json['jihadPath'] as int?);
    jihadMoveCount = json['jihadMoveCount'] as int?;
  }

  @override
  Map<String, dynamic> toJson() => {
    'jihadPath': pathToIndex(jihadPath),
    'jihadMoveCount': jihadMoveCount,
  };

  @override
  Phase get phase {
    return Phase.secular;
  }
}

class PhaseStateReligious extends PhaseState {
  bool moveApostleFree = false;
  Piece? moveMissionary;
  Location? moveMissionaryDestination;
  Piece? field;
  Piece? heresy;
  Path? evangelismPath;

  PhaseStateReligious();

  PhaseStateReligious.fromJson(Map<String, dynamic> json) {
    moveApostleFree = json['moveApostleFree'] as bool;
    moveMissionary = pieceFromIndex(json['moveMissionary'] as int?);
    moveMissionaryDestination = locationFromIndex(json['moveMissionaryDestination'] as int?);
    field = pieceFromIndex(json['field'] as int?);
    heresy = pieceFromIndex(json['heresy'] as int?);
    evangelismPath = pathFromIndex(json['evangelismPath'] as int?);
  }

  @override
  Map<String, dynamic> toJson() => {
    'moveApostleFree': moveApostleFree,
    'moveMissionary': pieceToIndex(moveMissionary),
    'moveMissionaryDestination': locationToIndex(moveMissionaryDestination),
    'field': pieceToIndex(field),
    'heresy': pieceToIndex(heresy),
    'evangelismPath': pathToIndex(evangelismPath),
  };

  @override
  Phase get phase {
    return Phase.religious;
  }
}

class PhaseStateEndOfTurn extends PhaseState {
  List<Location> preventApostasyLands = <Location>[];

  PhaseStateEndOfTurn();

  PhaseStateEndOfTurn.fromJson(Map<String, dynamic> json) {
    preventApostasyLands = locationListFromIndices(List<int>.from(json['preventApostasyLands']));
  }

  @override
  Map<String, dynamic> toJson() => {
    'preventApostasyLands': locationListToIndices(preventApostasyLands),
  };

  @override
  Phase get phase {
    return Phase.endOfTurn;
  }
}

class InvadeState {
  int subStep = 0;

  InvadeState();

  InvadeState.fromJson(Map<String, dynamic> json) {
    subStep = json['subStep'] as int;
  }

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
  PhaseState? _phaseState;
  InvadeState? _invadeState;
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
      case Phase.secular:
        _phaseState = PhaseStateSecular.fromJson(phaseStateJson);
      case Phase.religious:
        _phaseState = PhaseStateReligious.fromJson(phaseStateJson);
      case Phase.endOfTurn:
        _phaseState = PhaseStateEndOfTurn.fromJson(phaseStateJson);
      }
    }

    final invadeStateJson = json['invade'];
    if (invadeStateJson != null) {
      _invadeState = InvadeState.fromJson(invadeStateJson);
    }

    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
    if (_phaseState != null) {
      map['phase'] = _phaseState!.phase.index;
      map['phaseState'] = _phaseState!.toJson();
    }
    if (_invadeState != null) {
      map['invade'] = _invadeState!.toJson();
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

  Piece randFaith() {
    final faiths = _state.piecesInLocation(PieceType.faithRandom, Location.cupFaith);
    return randPiece(faiths)!;
  }

  Piece? randHeresy() {
    final heresies = _state.piecesInLocation(PieceType.heresy, Location.cupHeresy);
    return randPiece(heresies);
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

  Location randLand() {
    return _state.randomLand(_random);
  }

  Piece drawField() {
    return randPiece(_state.piecesInLocation(PieceType.fieldPagan, Location.cupField))!;
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

  void adjustSolidi(int delta) {
    _state.adjustSolidi(delta);
    if (delta > 0) {
      logLine('>Solidi: +$delta => ${_state.solidi}');
    } else if (delta < 0) {
      logLine('>Solidi: $delta => ${_state.solidi}');
    }
  }

  void adjustDarkAges(int delta) {
    _state.adjustDarkAges(delta);
    if (delta > 0) {
      logLine('>Dark Ages: +$delta => ${_state.darkAges}');
    } else if (delta < 0) {
      logLine('>Dark Ages: $delta => ${_state.darkAges}');
    }
  }

  // High-Level Functions

  List<Location> get candidateInfrastructureSites {
    final candidates = <Location>[];
    for (final path in Path.values) {
      final locationType = _state.pathLocationType(path);
      bool hasInfrastructure = false;
      for (final land in locationType.locations) {
        if (_state.pieceInLocation(PieceType.infrastructure, land) != null) {
          hasInfrastructure = true;
          break;
        }
      }
      if (!hasInfrastructure) {
        for (final land in locationType.locations) {
          if (!_state.landIsHomeland(land) && _state.landControlChristian(land)) {
            candidates.add(land);
          }
        }
      }
    }
    return candidates;
  }

  List<Location> candidateHospitalSites(int budget) {
    if (budget < 3) {
      return <Location>[];
    }
    final candidates = candidateInfrastructureSites;
    if (budget >= 6) {
      return candidates;
    }
    final affordableCandidates = <Location>[];
    for (final candidate in candidates) {
      if (_state.pieceInLocation(PieceType.fieldChristianPhysicians, candidate) == null) {
        affordableCandidates.add(candidate);
      }
    }
    return affordableCandidates;
  }

  List<Location> candidateMonasterySites(int budget) {
    if (budget < 3) {
      return <Location>[];
    }
    final candidates = candidateInfrastructureSites;
    if (budget >= 6) {
      return candidates;
    }
    final affordableCandidates = <Location>[];
    for (final candidate in candidates) {
      if (_state.pieceInLocation(PieceType.fieldChristianAscetics, candidate) == null) {
        affordableCandidates.add(candidate);
      }
    }
    return affordableCandidates;
  }

  List<Location> candidateUniversitySites(int budget) {
    if (budget < 3) {
      return <Location>[];
    }
    final candidates = candidateInfrastructureSites;
    if (budget >= 6) {
      return candidates;
    }
    final affordableCandidates = <Location>[];
    for (final candidate in candidates) {
      if (_state.pieceInLocation(PieceType.fieldChristianScholars, candidate) == null) {
        affordableCandidates.add(candidate);
      }
    }
    return affordableCandidates;
  }

  List<Location> get candidateMelkiteSites {
    final candidates = <Location>[];
    for (final path in Path.values) {
      if (_state.pathInSchism(path)) {
        final locationType = _state.pathLocationType(path);
        for (final land in locationType.locations) {
          if (_state.landChristian(land)) {
            candidates.add(land);
          }
        }
      }
    }
    return candidates;
  }

  List<Location> get candidateRomanCapitalSites {
    final candidates = <Location>[];
    final currentLocation = _state.pieceLocation(Piece.romanCapitalChristian);
    for (final bigCity in _state.bigCities) {
      if (bigCity != currentLocation && _state.landControlRoman(bigCity)) {
        candidates.add(bigCity);
      }
    }
    return candidates;
  }

  List<Piece> get candidateMoveKnightPrayForPeacePieces {
    final candidates = <Piece>[];
    for (final knight in PieceType.knightOrPrayForPeace.pieces) {
      final location = _state.pieceLocation(knight);
      if (location.isType(LocationType.land) || location == Location.boxDamagedArmies) {
        candidates.add(knight);
      }
    }
    return candidates;
  }

  List<Location> candidateMoveKnightPrayForPeaceDestinations(int budget) {
    final candidates = <Location>[];
    for (final land in LocationType.pathLand.locations) {
      if (!_state.landIsHomeland(land)) {
        if (_state.landControlChristian(land)) {
          final path = _state.landPath(land)!;
          int cost = _state.pathInSchism(path) ? 2 : 1;
          if (budget >= cost) {
            candidates.add(land);
          }
        } else if (_state.landChristian(land)) {
          if (budget >= 1) {
            candidates.add(land);
          }
        }
      }
    }
    return candidates;
  }

  List<Piece> candidateBibleTranslations(int budget) {
    final candidates = _state.pieceLocation(Piece.bibleGreek) == Location.trayBible ? [Piece.bibleGreek] : _state.piecesInLocation(PieceType.bibleUnused, Location.trayBible);
    final pathFieldCounts = List<int>.filled(Path.values.length, 0);
    for (final field in PieceType.fieldChristian.pieces) {
      final location = _state.pieceLocation(field);
      if (location.isType(LocationType.land)) {
        final path = _state.landPath(location)!;
        pathFieldCounts[path.index] += 1;
      }
    }
    final affordableCandidates = <Piece>[];
    for (final bible in candidates) {
      int fieldCount = 0;
      for (final path in Path.values) {
        if (_state.pathUnusedBible(path) == bible) {
          fieldCount += pathFieldCounts[path.index];
        }
      }
      if (budget + fieldCount ~/ 2 >= 6) {
        affordableCandidates.add(bible);
      }
    }
    return affordableCandidates;
  }

  List<Location> get apostasyLands {
    final lands = <Location>[];
    for (final field in PieceType.fieldChristian.pieces) {
      final location = _state.pieceLocation(field);
      if (location.isType(LocationType.land)) {
        bool heresy = _state.piecesInLocationCount(PieceType.heresy, location) > 0;
        bool apostasy = heresy;
        if (!heresy) {
          final control = _state.landControl(location);
          if (control != null) {
            if (control.isType(PieceType.horde)) {
              if (!_state.hordeChristian(control) && !_state.pieceGrantsReligiousFreedom(control)) {
                apostasy = true;
              }
            } else if (control.isType(PieceType.abbasid)) {
              apostasy = true;
            } else if (control.isType(PieceType.tyrant)) {
              apostasy = true;
            }
          }
        }
        if (apostasy) {
          if (!heresy) {
            for (final piece in _state.piecesInLocation(PieceType.all, location)) {
              if (_state.pieceGrantsReligiousFreedom(piece)) {
                apostasy = false;
                break;
              }
            }
          }
        }
        if (apostasy) {
          lands.add(location);
        }
      }
    }
    return lands;
  }

  int preventApostasyCostForLand(Location land) {
    int cost = 1;
    final path = _state.landPath(land)!;
    if (_state.pathInSchism(path)) {
      cost = 2;
    }
    final faith = _state.pathFaith(path);
    if (faith != null && faith.isType(PieceType.faithSubmit)) {
      cost = 3;
    }
    return cost;
  }

  int bibleTranslationDiscount(Piece bible) {
    int fieldCount = 0;
    for (final field in PieceType.fieldChristian.pieces) {
      final location = _state.pieceLocation(field);
      if (location.isType(LocationType.land)) {
        final path = _state.landPath(location)!;
        if (_state.pathUnusedBible(path) == bible) {
          fieldCount += 1;
        }
      }
    }
    return fieldCount ~/ 2;
  }

  List<Piece> candidateHeresies(int budget, Path? evangelismPath) {
    final candidates = <Piece>[];
    for (final heresy in PieceType.heresy.pieces) {
      final location = _state.pieceLocation(heresy);
      if (location.isType(LocationType.land)) {
        final path = _state.landPath(location)!;
        if (evangelismPath == null || path == evangelismPath) {
          if (budget >= 1 || evangelismPath != null) {
            candidates.add(heresy);
          } else {
            final bible = _state.pathUnusedBible(path);
            if (_state.pieceLocation(bible) == Location.boxBibleTranslations) {
              candidates.add(heresy);
            }
          }
        }
      }
    }
    return candidates;
  }

  List<Piece> candidateHordeConversions(int budget) {
    final candidates = <Piece>[];
    for (final horde in [Piece.hordeSaxonsArian, Piece.hordeBulgarsPagan, Piece.hordeKhazarsPagan]) {
      final location = _state.pieceLocation(horde);
      if (location.isType(LocationType.land)) {
        final path = _state.landPath(location)!;
        final locationType = _state.pathLocationType(path);
        int controlCount = 0;
        for (final otherLand in locationType.locations) {
          if (_state.landControl(otherLand) == horde) {
            controlCount += 1;
          }
        }
        if (budget >= controlCount) {
          candidates.add(horde);
        }
      }
    }
    return candidates;
  }

  List<Piece> get candidateTyrantConversions {
    final candidates = <Piece>[];
    for (final tyrant in PieceType.tyrant.pieces) {
      final location = _state.pieceLocation(tyrant);
      if (location.isType(LocationType.land)) {
        final path = _state.landPath(location)!;
        final precedingLand = _state.pathPrecedingLand(path, location)!;
        final succeedingLand = _state.pathSucceedingLand(path, location)!;
        if (_state.landChristian(location) || _state.landChristian(precedingLand) || _state.landChristian(succeedingLand)) {
          candidates.add(tyrant);
        }
      }
    }
    return candidates;
  }

  List<Piece> get candidatePersecutions {
    final candidates = <Piece>[];
    for (final schism in PieceType.popeSchism.pieces) {
      final location = _state.pieceLocation(schism);
      if (location.isType(LocationType.land)) {
        if (_state.landControlChristian(location)) {
          if (!_state.landControlRoman(location) || _state.pieceLocation(Piece.emperorHeretical) != Location.boxRomanPolicy) {
            candidates.add(schism);
          }
        }
      }
    }
    return candidates;
  }

  List<Location> get candidateOffensives {
    var attackers = PieceType.romanControl.pieces;
    attackers += [Piece.nubia, Piece.holyRomanEmpire];
    var romanArmyLocation = _state.pieceLocation(Piece.romanArmy);
    if (romanArmyLocation.isType(LocationType.land)) {
      final romanArmyPath = _state.landPath(romanArmyLocation)!;
      var romanControl = _state.pathActiveRomanControl(romanArmyPath);
      if (romanControl != null) {
        attackers.add(Piece.romanArmy);
      }
    }
    final candidates = <Location>[];
    for (final attacker in attackers) {
      final location = _state.pieceLocation(attacker);
      if (location.isType(LocationType.land)) {
        final path = _state.landPath(location)!;
        final succeedingLand = _state.pathSucceedingLand(path, location)!;
        if (!candidates.contains(succeedingLand)) {
          if (!_state.landIsHomeland(succeedingLand)) {
            bool ok = true;
            if (attacker.isType(PieceType.romanControl) || attacker == Piece.romanArmy) {
              final defender = _state.landControl(succeedingLand);
              if (defender == null) {
                ok = false;
              }
            }
            if (ok) {
              candidates.add(succeedingLand);
            }
          }
        }
        var precedingLand = _state.pathPrecedingLand(path, location)!;
        while (precedingLand != Location.landJerusalem) {
          final controller = _state.landControl(precedingLand);
          if (controller != null && _state.pieceLocation(controller) == precedingLand) {
            if (_state.pieceArab(controller)) {
              if (!candidates.contains(precedingLand)) {
                candidates.add(precedingLand);
              }
            }
            break;
          }
          precedingLand = _state.pathPrecedingLand(path, precedingLand)!;
        }
      }
    }
    return candidates;
  }

  List<Piece> candidateAttackers(Location land) {
    final attackers = <Piece>[];
    final path = _state.landPath(land)!;
    final romanControl = _state.pathActiveRomanControl(path);
    if (romanControl != null) {
      attackers.add(romanControl);
    }
    if (path == Path.westEurope) {
      attackers.add(Piece.holyRomanEmpire);
    }
    if (path == Path.eastAfrica) {
      attackers.add(Piece.nubia);
    }
    var romanArmyLocation = _state.pieceLocation(Piece.romanArmy);
    if (romanArmyLocation.isType(LocationType.land)) {
      if (_state.landPath(romanArmyLocation) == path) {
        attackers.add(Piece.romanArmy);
      }
    }
    final candidates = <Piece>[];
    for (final attacker in attackers) {
      final location = _state.pieceLocation(attacker);
      if (location.isType(LocationType.land)) {
        final succeedingLand = _state.pathSucceedingLand(path, location)!;
        if (succeedingLand == land) {
          if (_state.landIsHomeland(succeedingLand)) {
            bool ok = true;
            if (attacker.isType(PieceType.romanControl) || attacker == Piece.romanArmy) {
              final defender = _state.landControl(succeedingLand);
              if (defender == null) {
                ok = false;
              }
            }
            if (ok) {
              candidates.add(attacker);
            }
          }
        }
        var precedingLand = _state.pathPrecedingLand(path, location)!;
        while (precedingLand != Location.landJerusalem) {
          if (precedingLand == land) {
            candidates.add(attacker);
            break;
          }
          final controller = _state.landControl(precedingLand);
          if (controller != null && _state.pieceLocation(controller) == precedingLand) {
            break;
          }
          precedingLand = _state.pathPrecedingLand(path, precedingLand)!;
        }
      }
    }
    return candidates;
  }

  List<Piece> get candidateRelics {
    final candidates = <Piece>[];
    for (final relics in PieceType.relics.pieces) {
      final location = _state.pieceLocation(relics);
      if (location.isType(LocationType.land)) {
        if (location == Location.landJerusalem || _state.landChristian(location)) {
          candidates.add(relics);
        }
      }
    }
    return candidates;
  }

  int get reconquistaCost {
    int cost = 0;
    for (final land in LocationType.pathWestEurope.locations) {
      final control = _state.landControl(land);
      if (control != null) {
        if (control.isType(PieceType.abbasid) || control.isType(PieceType.tyrant)) {
          cost += 1;
        } else if (control == Piece.hordeSaxonsArian || control == Piece.unholyArianEmpire) {
          cost += 1;
        }
      }
    }
    return cost;
  }

  bool conversionAttempt(Piece field) {
    final land = _state.pieceLocation(field);
    logLine('>Conversion attempt on ${field.desc} in ${land.desc}.');
    int die = rollD6();
    int modifiers = 0;

    logTableHeader();
    logD6InTable(die);
    for (final pieceType in [PieceType.apostle, PieceType.bishop, PieceType.archbishop, PieceType.pope]) {
      final piece = _state.pieceInLocation(pieceType, land);
      if (piece != null) {
        logLine('>|${piece.desc}|+1|');
        modifiers += 1;
      }
    }
    final persia = _state.pieceInLocation(PieceType.persianEmpire, land);
    if (persia != null) {
      if (persia == Piece.persianEmpireP1) {
        logLine('>|Tolerant Persian Satrap|+1|');
        modifiers += 1;
      } else if (persia == Piece.persianEmpireN1) {
        logLine('>|Fundamentalist Persian Satrap|-1|');
        modifiers -= 1;
      }
    }
    int total = die;
    if (die > 1) {
      total += modifiers;
    }
    logLine('>|Total|$total|');
    int value = _state.fieldValue(field);
    logLine('>|${field.desc}|$value|');
    logTableFooter();

    if (total <= value) {
      logLine('>Conversion attempt is unsuccessful.');
      return false;
    }
    logLine('>${field.desc} in ${land.desc} are Converted to Christianity.');
    _state.flipPiece(field);
    return true;
  }

  bool rulerIsTyrant(Location land) {
    final path = _state.landPath(land)!;
    final precedingLand = _state.pathPrecedingLand(path, land)!;
    final succeedingLand = _state.pathSucceedingLand(path, land)!;
    int die = rollD6();
    logD6(die);
    bool seatChristian = _state.landChristian(land);
    bool christianBorder = false;
    bool paganBorder = false;
    if (precedingLand == Location.landJerusalem || _state.landChristian(precedingLand)) { // Jerusalem situation is unclear
      christianBorder = true;
    } else {
      paganBorder = true;
    }
    if (!_state.landIsHomeland(succeedingLand)) {
      if (_state.landChristian(succeedingLand)) {
        christianBorder = true;
      } else {
        paganBorder = true;
      }
    }
    int christianThreshold;
    if (seatChristian) {
      if (!paganBorder) {
        christianThreshold = 5;
      } else if (!christianBorder) {
        christianThreshold = 3;
      } else {
        christianThreshold = 4;
      }
    } else {
      if (!paganBorder) {
        christianThreshold = 2;
      } else if (!christianBorder) {
        christianThreshold = 0;
      } else {
        christianThreshold = 1;
      }
    }
    return die > christianThreshold;
  }

  List<Piece> defendingArmies(Location land) {
    bool playerControlled = _state.landControlPlayer(land);
    final armies = _state.landArmies(land);
    final defenders = <Piece>[];
    for (final army in armies) {
      switch (_state.armyType(army)) {
      case ArmyType.advanceForce:
        defenders.add(army);
      case ArmyType.selfDefenseForce:
        if (playerControlled) {
          if (_state.fieldIsMartyrs(army)) {
            if (choicesEmpty()) {
              setPrompt('Defend with Martyrs?');
              choiceChoosable(Choice.yes, true);
              choiceChoosable(Choice.no, true);
              throw PlayerChoiceException();
            }
            if (checkChoice(Choice.yes)) {
              defenders.add(army);
            }
            clearChoices();
          } else {
            defenders.add(army);
          }
        }
      case ArmyType.vulnerableForce:
        defenders.add(army);
      }
    }
    final controlPiece = _state.landControl(land);
    if (controlPiece != null && controlPiece.isType(PieceType.innerControl)) {
      if (_state.pieceLocation(controlPiece) != land) {
        defenders.add(controlPiece);
      }
    }
    return defenders;
  }

  void invade(List<Piece> invaders, Location fromLand, Location toLand) {
    _invadeState ??= InvadeState();
    final localState = _invadeState!;
    Piece? primaryInvader;
    primaryInvader = invaders[0];
    Path? path;
    if (toLand.index > fromLand.index) {
      path = _state.landPath(toLand)!;
    } else {
      path = _state.landPath(fromLand)!;
    }
    if (localState.subStep == 0) {
      logLine('>${primaryInvader.desc} invade ${toLand.desc}.');
      localState.subStep = 1;
    }
    if (localState.subStep == 1) {
      if (_state.currentTurn == 17) { // Justinian
        if (primaryInvader.isType(PieceType.horde)) {
          if (_state.pieceInLocation(PieceType.romanControl, toLand) != null) {
            logLine('>Justinian’s forces repel ${primaryInvader.desc} at the border.');
            _invadeState = null;
            return;
          }
        }
      } 
      final armies = defendingArmies(toLand);
      bool attackUsingIntrinsicStrength = primaryInvader.isType(PieceType.innerControl) && toLand.index < fromLand.index;
      if (!attackUsingIntrinsicStrength) {
        int attackerStrength = _state.advanceForceStrength(primaryInvader);
        for (final army in armies) {
          logLine('> ${army.desc} defends.');
          int die = rollD6();

          logTableHeader();
          logD6InTable(die);
          logLine('>|${primaryInvader.desc}|$attackerStrength|');
          logTableFooter();

          if (die > attackerStrength) {
            logLine('>${primaryInvader.desc} are repelled.');
            _invadeState = null;
            return;
          }
          logLine('>${army.desc} is defeated.');
        }
      } else {
        for (final army in armies) {
          logLine('>${army.desc} defends.');
          int die = rollD6();

          logTableHeader();
          logD6InTable(die);
          int defenderStrength = _state.advanceForceStrength(army);
          logLine('>${army.desc}|$defenderStrength|');
          logTableFooter();

          if (die <= defenderStrength) {
            logLine('>${primaryInvader.desc} are repelled.');
            _invadeState = null;
            return;
          }
          logLine('>${army.desc} is defeated.');
        }
      }
      for (final army in armies) {
        if (_state.pieceLocation(army) == toLand) {
          switch (_state.armyType(army)) {
          case ArmyType.advanceForce:
            Location? nextLand;
            if (toLand.index > fromLand.index) {
              nextLand = _state.pathSucceedingLand(path, toLand);
            } else {
              nextLand = _state.pathPrecedingLand(path, toLand);
            }
            bool retreated = false;
            if (nextLand != null) {
              final nextControlPiece = _state.landControl(nextLand);
              if (nextControlPiece == null || _state.pieceLocation(nextControlPiece) != nextLand ||
                  (army == Piece.romanArmy && (nextControlPiece.isType(PieceType.romanControl) || nextControlPiece == Piece.holyRomanEmpire))) {
                if (nextLand != Location.landJerusalem || _state.pieceArab(army)) {
                  if (!army.isType(PieceType.romanControl) || toLand.index < fromLand.index) {
                    retreated = true;
                    logLine('>${army.desc} retreats to ${nextLand.desc}.');
                    _state.setPieceLocation(army, nextLand);
                  }
                }
              }
            }
            if (!retreated) {
              if (_state.pieceLocation(army) == toLand) {
                logLine('>${army.desc} is eliminated.');
                if (army == Piece.romanArmy) {
                  _state.setPieceLocation(Piece.romanArmy, Location.boxDamagedArmies);
                } else {
                  _state.setPieceLocation(army, Location.discarded);
                }
              }
            }
          case ArmyType.vulnerableForce:
            logLine('>${army.desc} is eliminated.');
            if (army.isType(PieceType.persianEmpire)) {
              _state.setPieceLocation(army, Location.discarded);
            } else if (army.isType(PieceType.king)) {
              _state.setPieceLocation(army, Location.trayPope);
            } else if (army.isType(PieceType.tyrant)) {
              _state.setPieceLocation(_state.pieceFlipSide(army)!, Location.trayPope);
            } else if (army.isType(PieceType.knight) || army.isType(PieceType.prayForPeace)) {
              _state.setPieceLocation(army, Location.boxDamagedArmies);
            }
          case ArmyType.selfDefenseForce:
          }
        }
      }
      if (!attackUsingIntrinsicStrength) {
        logLine('>${primaryInvader.desc} seize control of ${toLand.desc}.');
        for (final invader in invaders) {
          _state.setPieceLocation(invader, toLand);
        }
      }
      localState.subStep = 3;
      if (primaryInvader == _state.pathActiveJihad(path)) {
        switch (toLand) {
        case Location.landAntioch:
          logLine('>Roman Control is eliminated from ${path.desc}.');
          _state.setPieceLocation(Piece.romanControlPaganCaucasus, Location.discarded);
        case Location.landAlexandria:
          logLine('>Roman Control is eliminated from ${path.desc}.');
          _state.setPieceLocation(Piece.romanControlPaganEastAfrica, Location.discarded);
        case Location.landSufetula:
          logLine('>${Piece.hordeVandalsArian.desc} are replaced by ${Piece.hordeBerbersMuslim.desc}.');
          _state.setPieceLocation(Piece.hordeBerbersMuslim, _state.pieceLocation(Piece.hordeVandalsArian));
        case Location.landTingitana:
          {
            logLine('>Arabs conquer Spain.');
            _state.setPieceLocation(Piece.occupiedSpain, Location.landSpain);
            final horde = _state.pathActiveHorde(path);
            final hordeLocation = _state.pieceLocation(horde);
            if (hordeLocation.index <= Location.landSpain.index) {
              logLine('>${horde.desc} retreats to ${Location.landGaul.desc}.');
              _state.setPieceLocation(horde, Location.landGaul);
            }
            var ruler = _state.pathActiveRuler(path);
            if (ruler != null && _state.pieceLocation(ruler) == Location.landSpain) {
              logLine('>${ruler.desc} is eliminated.');
              if (ruler.isType(PieceType.tyrant)) {
                ruler = _state.pieceFlipSide(ruler)!;
              }
              _state.setPieceLocation(ruler, Location.trayPope);
            }
            final romanControl = _state.pathActiveRomanControl(path);
            if (romanControl != null) {
              if (romanControl.index >= Location.landSpain.index) {
                logLine('>${romanControl.desc} retreats to ${Location.landMilan.desc}.');
                _state.setPieceLocation(romanControl, Location.landMilan);
              }
            }
          }
        case Location.landThebes:
          localState.subStep = 2;
        default:
        }
      }
    }

    if (localState.subStep == 2) { // Thebes
      if (choicesEmpty()) {
        setPrompt('Select Baqt Bribe Amount');
        for (int i = 0; i < 5 && i < _state.solidi; ++i) {
          locationChoosable(_state.trackBox(i));
        }
        throw PlayerChoiceException();
      }
      final box = selectedLocation()!;
      clearChoices();
      int amount = box.index - Location.boxTrack0.index;
      if (amount > 0) {
        logLine('### Baqt');
        adjustSolidi(-amount);
        int die = rollD6();

        logTableHeader();
        logD6InTable(die);
        logLine('>|Bribe|$amount|');
        logTableFooter();

        if (die <= amount) {
          logLine('>Bribe is successful, Baqt is established.');
          _state.setPieceLocation(Piece.abbasidEastAfrica, Location.landThebes);
          _state.setPieceLocation(Piece.baqt, Location.landThebes);
        } else {
          logLine('>Bribe is unsuccessful, no Baqt is agreed.');
        }
      }
      localState.subStep = 3;
    }

    if (localState.subStep == 3) {
      _invadeState = null;
    }
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
  }

  // Sequence Helpers

  Piece drawFieldForLand(Location land) {
    Piece? field;
    if (_state.landIsBigCity(land)) {
      if (choicesEmpty()) {
        setPrompt('Choose Field for Big City');
        for (int i = 0; i < 3; ++i) {
          final field = drawField();
          _state.setPieceLocation(field, Location.values[Location.boxBigCityField0.index + i]);
          pieceChoosable(field);
        }
        throw PlayerChoiceException();
      }
      field = selectedPiece()!;
      for (int i = 0; i < 3; ++i) {
        final bigCityField = _state.pieceInLocation(PieceType.fieldPagan, Location.values[Location.boxBigCityField0.index + i])!;
        _state.setPieceLocation(bigCityField, Location.cupField);
      }
      clearChoices();
    } else {
      field = drawField();
    }
    return field;
  }

  // New Eras

  void newEraApostolicAge() {
    logLine('# The Apostolic Age');
  }

  void newEraPaxRomana() {
    logLine('# The Pax Romana');
    for (final apostle in PieceType.apostle.pieces) {
      var location = _state.pieceLocation(apostle);
      if (location != Location.flipped) {
        logLine('>${apostle.desc} dies in ${location.desc}.');
        logLine('>Relics are created in ${location.desc}.');
        _state.flipPiece(apostle);
        final path = _state.missionaryPath(apostle);
        if (path != null) {
          final bishop = _state.pathBishop(path);
          logLine('>${bishop.desc} is appointed in ${location.desc}.');
          _state.setPieceLocation(bishop, location);
        }
      }
    }
    for (final path in Path.values) {
      final pope = _state.pathPope(path);
      final city = _state.pathBigCity(path);
      logLine('>${pope.desc} is appointed in ${city.desc}.');
      _state.setPieceLocation(pope, city);
      if (_state.pieceInLocation(PieceType.field, city) == null) {
        final heresy = randHeresy();
        if (heresy != null) {
          logLine('>${heresy.desc} takes hold in ${city.desc}.');
          _state.setPieceLocation(heresy, city);
        }
      }
    }
  }

  void newEraAgeOfConstantine() {
    logLine('# The Age of Constantine');
    logLine('>Roman Empire adopts Christianity');
    _state.setPieceLocation(Piece.romanCapitalChristian, _state.pieceLocation(Piece.romanCapitalPagan));
    for (final romanControl in PieceType.romanControlPagan.pieces) {
      _state.flipPiece(romanControl);
    }
    _state.setPieceLocation(Piece.romanaPax, Location.discarded);
    _state.setPieceLocation(Piece.emperorChristian, Location.boxRomanPolicy);
    _state.setPieceLocation(Piece.faithCatholic, Location.boxFaithWestEurope);
    _state.setPieceLocation(Piece.faithOrthodoxEagle, Location.boxFaithEastEurope);
    logLine('### Council of Nicaea');
    logLine('>${Path.westEurope.desc} adopts the ${Piece.faithCatholic.desc} Faith.');
    logLine('>${Path.eastEurope.desc} adopts the ${Piece.faithOrthodoxEagle.desc} Faith.');
  }

  void newEraFallOfRome() {
    if (_subStep == 0) {
      logLine('# Fall of Rome');
      logLine('>Western Empire falls.');
      _state.setPieceLocation(Piece.romanControlChristianWestEurope, Location.trayRoman);
      _state.setPieceLocation(Piece.papalStates, Location.landRome);
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select new location of Roman Capital');
        for (final path in Path.values) {
          final city = _state.pathBigCity(path);
          final controlPiece = _state.landControl(city);
          if (controlPiece != null && controlPiece.isType(PieceType.romanControl)) {
            locationChoosable(city);
          }
        }
        throw PlayerChoiceException();
      }
      final capitalLand = selectedLocation()!;
      logLine('>Roman Capital relocates to ${capitalLand.desc}.');
      _state.setPieceLocation(Piece.romanCapitalChristian, capitalLand);
      for (final goldCoin in PieceType.waferCoinGold.pieces) {
        _state.setPieceLocation(goldCoin, Location.cupWafer);
      }
      _state.setPieceLocation(Piece.hordeSaxonsArian, Location.homelandSaxons);
      _state.setPieceLocation(Piece.hordeBulgarsPagan, Location.homelandBulgars);
      _state.setPieceLocation(Piece.hordeKhazarsPagan, Location.homelandKhazars);
      _state.setPieceLocation(Piece.hordeTurksPagan, Location.homelandTurks);
      _state.setPieceLocation(Piece.hordeHimyarClans, Location.homelandHimyar);
      _state.setPieceLocation(Piece.hordeVandalsArian, Location.homelandVandals);
      logLine('>Nubia');
      int nubianCount = 0;
      for (final land in [Location.landNobadia, Location.landMakouria, Location.landAlodia]) {
        if (_state.landChristian(land)) {
          nubianCount += 1;
        }
      }
      int die = rollD6();
      logD6(die);
      if (die <= 2 * nubianCount) {
        logLine('>Christian Nubia is established.');
        _state.setPieceLocation(Piece.nubia, Location.landAlodia);
      } else {
        logLine('>Christian Nubia is not established.');
      }
      for (final knight in PieceType.knight.pieces) {
        _state.setPieceLocation(knight, Location.boxDamagedArmies);
      }
    }
  }

  void newEraRiseOfIslam() {
    logLine('# Rise of Islam');
    logLine('>Umayyad Caliphate occupies Jerusalem.');
    _state.setPieceLocation(Piece.occupiedJerusalem, Location.landJerusalem);
    for (final jihad in PieceType.jihad.pieces) {
      _state.setPieceLocation(jihad, Location.landJerusalem);
    }
    for (final cult in PieceType.cultIsis.pieces) {
      _state.setPieceLocation(cult, Location.trayMisc);
    }
  }

  bool newEraEarlyMiddleAges() {
    logLine('# Early Middle Ages');
    logLine('>Abbasid Caliphate overthrows the Umayyads.');
    for (final jihad in PieceType.jihad.pieces) {
      _state.flipPiece(jihad);
    }
    final sufetulaControl = _state.landControl(Location.landSufetula);
    if (sufetulaControl != null && sufetulaControl.isType(PieceType.romanControl)) {
      logLine('>Vandal Kingdom collapses.');
      _state.setPieceLocation(Piece.hordeVandalsArian, Location.trayHorde);
    }
    return true;
  }

  // Roman Policies

  void romanPolicyPaxRomana() {
    if (choicesEmpty()) {
      setPrompt('Pax Romana: Select Field Tile to replace (1\$)');
      for (final land in LocationType.land.locations) {
        final field = _state.pieceInLocation(PieceType.fieldPagan, land);
        if (field != null && _state.landControlRoman(land)) {
          pieceChoosable(field);
        }
      }
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    if (checkChoiceAndClear(Choice.next)) {
      return;
    }
    final oldField = selectedPiece()!;
    final land = _state.pieceLocation(oldField);
    adjustSolidi(-1);
    _state.setPieceLocation(oldField, Location.cupField);
    final newField = randPiece(_state.piecesInLocation(PieceType.fieldPagan, Location.cupField))!;
    logLine('>${newField.desc} is placed in ${land.desc}.');
    _state.setPieceLocation(newField, land);
    clearChoices();
  }

  void romanPolicyLexRomana() {
    if (choicesEmpty()) {
      setPrompt('Lex Romana: Select Land to Convert');
      for (final path in Path.values) {
        final locationType = _state.pathLocationType(path);
        for (final land in locationType.locations) {
          final field = _state.pieceInLocation(PieceType.fieldPagan, land);
          if (field != null) {
            final adjacentLands = [_state.pathPrecedingLand(path, land), _state.pathSucceedingLand(path, land)];
            for (final adjacentLand in adjacentLands) {
              if (adjacentLand != null) {
                if (adjacentLand == Location.landJerusalem || (_state.landChristian(adjacentLand) && _state.landControlRoman(land))) {
                  pieceChoosable(field);
                  break;
                }
              }
            }
          }
        }
      }
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    if (checkChoiceAndClear(Choice.next)) {
      return;
    }
    final field = selectedPiece()!;
    conversionAttempt(field);
  }

  void romanPolicyEmperorChristian() {
    while (true) {
      if (choicesEmpty()) {
        setPrompt('Christian Emperor: Select Heresy to eradicate (1DA)');
        for (final heresy in PieceType.heresy.pieces) {
          final location = _state.pieceLocation(heresy);
          if (location.isType(LocationType.land) && _state.landControlRoman(location)) {
            pieceChoosable(heresy);
          }
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      final heresy = selectedPiece()!;
      final land = _state.pieceLocation(heresy);
      logLine('>${heresy.desc} is eradicated from ${land.desc}.');
      _state.setPieceLocation(heresy, Location.discarded);
      adjustDarkAges(1);
      clearChoices();
    }
  }

  // Sequence of Play

  void turnBegin() {
    logLine('# ${_state.turnName(_state.currentTurn)}');
  }

  void historyPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to History Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## History Phase');
  }

  void historyPhaseNewEra() {
    final newEraHandlers = {
      1: newEraApostolicAge,
      3: newEraPaxRomana,
      10: newEraAgeOfConstantine,
      15: newEraFallOfRome,
      21: newEraRiseOfIslam,
      25: newEraEarlyMiddleAges,
    };
    final handler = newEraHandlers[_state.currentTurn];
    if (handler == null) {
      return;
    }
    handler();
  }

  void historyPhaseHideHeresy() {
    final actsBox = _state.actsBox(_state.currentTurn);
    final heresies = _state.piecesInLocation(PieceType.heresy, actsBox);
    if (heresies.isNotEmpty) {
      logLine('### Heresies');
      logLine('>${heresies[0].desc} enters the Heresy Cup.');
      for (final heresy in heresies) {
        _state.setPieceLocation(heresy, Location.cupHeresy);
      }
    }
  }

  void historyPhaseGreatTheologian() {
    final greatTheologian = _state.turnGreatTheologian(_state.currentTurn);
    if (greatTheologian != null) {
      logLine('### Great Theologian');
      logLine('>Theologian ${greatTheologian.desc} is active.');
      _state.setPieceLocation(Piece.greatTheologian, greatTheologian);
    }
  }

  void historyPhaseEcumenicalCouncil() {
    final councilName = _state.turnEcumenicalCouncilName(_state.currentTurn);
    if (councilName == null) {
      return;
    }
    if (_subStep == 0) {
      logLine('### $councilName');
      final faithlessPaths = <Path>[];
      for (final path in Path.values) {
        final faithBox = _state.pathFaithBox(path);
        if (_state.pieceInLocation(PieceType.faith, faithBox) == null) {
          faithlessPaths.add(path);
        }
      }
      if (faithlessPaths.isNotEmpty) {
        final path = randPath(faithlessPaths)!;
        final faith = randFaith();
        logLine('>${path.desc} adopts the ${faith.desc} Faith.');
        _state.setPieceLocation(faith, _state.pathFaithBox(path));
        int die = rollD6();
        logD6(die);
        if (die > _state.faithValue(faith)) {
          logLine('>The Church votes to excommunicate followers of the ${faith.desc} Faith.');
          final pope = _state.pathPope(path);
          logLine('>${path.desc} is in Schism.');
          _state.flipPiece(pope);
        } else {
          logLine('>It remains in communion with the Church.');
        }
        return;
      }
      if (!_state.emperorChristian) {
        return;
      }
      _subStep == 1;
    }

    if (_subStep == 1) {
      final schisms = <Piece>[];
      for (final path in Path.values) {
        if (_state.pathInSchism(path)) {
          int hostileLandCount = 0;
          for (final land in _state.pathLocationType(path).locations) {
            if (_state.landControlHostile(land)) {
              hostileLandCount += 1;
            }
          }
          if (_state.solidi >= hostileLandCount) {
            schisms.add(_state.pathSchism(path)!);
          }
        }
      }
      if (schisms.isEmpty) {
        return;
      }
      if (choicesEmpty()) {
        setPrompt('Select Schism to reconcile');
        for (final schism in schisms) {
          pieceChoosable(schism);
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.next)) {
        clearChoices();
        return;
      }
      final schism = selectedPiece()!;
      final land = _state.pieceLocation(schism);
      final path = _state.landPath(land)!;
      logLine('>Emperor attempts to reconcile Schism on ${path.desc}.');
      int hostileLandCount = 0;
      int melkiteCount = 0;
      for (final otherLand in _state.pathLocationType(path).locations) {
        if (_state.landControlHostile(otherLand)) {
          hostileLandCount += 1;
        }
        if (_state.landChristian(otherLand)) {
          melkiteCount += _state.piecesInLocationCount(PieceType.melkite, otherLand);
        }
      }
      adjustSolidi(-hostileLandCount);
      int die = rollD6();

      logTableHeader();
      logD6InTable(die);
      logLine('>|Melkites|$melkiteCount|');
      logTableFooter();

      if (die > 1 && die <= melkiteCount) {
        logLine('>${path.desc} is reconciled with the Emperor.');
        _state.flipPiece(schism);
      } else {
        logLine('>Reconciliation attempt fails.');
        logLine('>The Emperor is excommunicated.');
        _state.setPieceLocation(Piece.emperorHeretical, Location.boxRomanPolicy);
        for (final otherLand in _state.pathLocationType(path).locations) {
          for (final melkite in _state.piecesInLocation(PieceType.melkite, otherLand)) {
            _state.setPieceLocation(melkite, Location.trayHeresy);
          }
        }
      }
    }
  }

  void historyPhaseJustinian() {
    if (_state.currentTurn == 17) {
      logLine('### Justinian');
      logLine('>Eastern Empire recaptures Rome.');
      final piece = _state.pieceInLocation(PieceType.control, Location.landRome);
      if (piece != null) {
        if (piece.isType(PieceType.horde)) {
          const retreatLand = Location.landMilan;
          logLine('>${piece.desc} retreats to ${retreatLand.desc}.');
          _state.setPieceLocation(piece, retreatLand);
        } else {
          logLine('>${piece.desc} is eliminated.');
          _state.setPieceLocation(piece, Location.trayPope);
        }
      }
      _state.setPieceLocation(Piece.romanControlChristianWestEurope, Location.landRome);
    }
  }

  void historyPhaseCharlemagne() {
    if (_state.currentTurn == 25) {
      logLine('### Charlemagne');
      var location = _state.pieceLocation(Piece.hordeSaxonsChristian);
      if (location != Location.flipped) {
        logLine('>Charlemagne establishes the Holy Roman Empire.');
        if (location == Location.homelandSaxons) {
          location = Location.landIreland;
        }
        _state.setPieceLocation(Piece.holyRomanEmpire, location);
        _state.setPieceLocation(Piece.hordeSaxonsArian, _state.pathSucceedingLand(Path.westEurope, location)!);
        for (Location? otherLand = _state.pathPrecedingLand(Path.westEurope, location); otherLand != null; otherLand = _state.pathPrecedingLand(Path.westEurope, otherLand)) {
          final ruler = _state.pieceInLocation(PieceType.ruler, otherLand);
          if (ruler != null) {
            logLine('>${ruler.desc} in ${otherLand.desc} is absorbed into the Holy Roman Empire.');
            _state.setPieceLocation(ruler, Location.trayPope);
          }
        }
      } else {
        location = _state.pieceLocation(Piece.hordeSaxonsArian);
        logLine('>Charlemagne establishes an Arian Empire.');
        _state.setPieceLocation(Piece.unholyArianEmpire, location);
      }
    }
  }

  void historyPhaseShewaSultanate() {
    if (_state.currentTurn == 26) {
      logLine('>Shewa Sultanate is established.');
      _state.flipPiece(Piece.hordeHimyarClans);
    }
  }

  void historyPhaseTurkishConversion() {
    if (_state.currentTurn == 26) {
      logLine('### Turkish Conversion');
      final rolls = roll2D6();
      log2D6(rolls);
      int die = min(rolls.$1, rolls.$2);
      final land = _state.pathLand(Path.centralAsia, die - 1);
      final control = _state.landControl(land);
      Piece? turksAfterConversion;
      if (control != null &&
          (control.isType(PieceType.jihad) || control.isType(PieceType.abbasid))) {
        logLine('>Turks convert to Islam.');
        turksAfterConversion = Piece.hordeTurksMuslim;
        logLine('>Seljuk Turks seize power from the Abbasid Caliphate in Asia Minor.');
        _state.setPieceLocation(Piece.hordeSeljuksMuslim, _state.pieceLocation(Piece.abbasidEastEurope));
      } else if (_state.landChristian(land)) {
        logLine('>Turks convert to Christianity.');
        turksAfterConversion = Piece.hordeTurksChristian;
      } else {
        logLine('>Turks convert to Manichaeism.');
        turksAfterConversion = Piece.hordeTurksManichee;
      }
      _state.setPieceLocation(turksAfterConversion, _state.pieceLocation(Piece.hordeTurksPagan));
    }
  }

  void historyPhaseMoveRomanArmy() {
    if (_state.currentTurn < 15) {
      return;
    }
    if (choicesEmpty()) {
      setPrompt('Select Land to move Roman Army to');
      for (final land in LocationType.land.locations) {
        final controllingPiece = _state.landControl(land);
        if (controllingPiece != null && controllingPiece.isType(PieceType.romanControl)) {
          locationChoosable(land);
        } else if (land == _state.pieceLocation(Piece.papalStates) && controllingPiece == null) { // Differs from unclear rules
          locationChoosable(land);
        }
      }
      throw PlayerChoiceException();
    }
    final land = selectedLocation()!;
    if (land != _state.pieceLocation(Piece.romanArmy)) {
      logLine('>Roman Army moves to ${land.desc}.');
      _state.setPieceLocation(Piece.romanArmy, land);
    }
    clearChoices();
  }

  void secularPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Secular Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Secular Phase');
    _phaseState = PhaseStateSecular();
  }

  void secularPhaseDrawWafer() {
    final wafer = randPiece(_state.piecesInLocation(PieceType.waferCoin, Location.cupWafer))!;
    _state.setPieceLocation(wafer, Location.boxWafer);
  }

  void secularPhaseEarnSolidi() {
    logLine('### Earn Solidi');
    int total = 0;

    logTableHeader();
    final wafer = _state.pieceInLocation(PieceType.waferCoin, Location.boxWafer)!;
    int amount = _state.waferCoinValue(wafer);
    logLine('>|Wafer|$amount|');
    total += amount;
    for (final path in Path.values) {
      if (_state.pathInCommunion(path)) {
        int christianLandCount = 0;
        final locationType = _state.pathLocationType(path);
        for (final land in locationType.locations) {
          if (_state.landChristian(land)) {
            christianLandCount += 1;
          }
        }
        if (christianLandCount >= 3) {
          logLine('>|${path.desc}|+1|');
          total += 1;
        }
      }
    }
    logLine('>|Total|$total|');
    logTableFooter();

    adjustSolidi(total);
  }

  void secularPhaseUpdateRomanPolicy() {
   var romanPolicy = _state.romanPolicy;
    logLine('### Roman Policy');
    final wafer = _state.pieceInLocation(PieceType.waferCoin, Location.boxWafer)!;
    if (_state.waferCoinChangeRomanPolicy(wafer)) {
      if (romanPolicy == Piece.romanaPax) {
        logLine('>Roman Policy changes to Romana Lex.');
        romanPolicy = Piece.romanaLex;
      } else if (romanPolicy == Piece.emperorChristian) {
        logLine('>New Emperor is Heretical.');
        romanPolicy = Piece.emperorHeretical;
      }
      _state.setPieceLocation(romanPolicy, Location.boxRomanPolicy);
    }
  }

  void secularPhaseEnactRomanPolicy() {
    final romanPolicy = _state.pieceInLocation(PieceType.romanPolicy, Location.boxRomanPolicy)!;
    switch (romanPolicy) {
    case Piece.romanaPax:
      return romanPolicyPaxRomana();
    case Piece.romanaLex:
      return romanPolicyLexRomana();
    case Piece.emperorChristian:
      return romanPolicyEmperorChristian();
    case Piece.emperorHeretical:
    default:
    }
  }

  void secularPhaseFlipWafer() {
    final wafer = _state.pieceInLocation(PieceType.waferCoin, Location.boxWafer)!;
    _state.flipPiece(wafer);
  }

  void secularPhaseRuler() {
    const waferRulers = [
      Piece.waferAction18,
      Piece.waferAction20,
      Piece.waferAction22,
      Piece.waferAction23,
      Piece.waferAction25,
      Piece.waferAction27,
      Piece.waferAction29,
      Piece.waferAction31,
    ];
    final wafer = _state.pieceInLocation(PieceType.waferAction, Location.boxWafer)!;
    if (!waferRulers.contains(wafer)) {
      return;
    }
    logLine('### Ruler');
    
    do {
      var land = randLand();
      bool king = false;
      bool tyrant = false;
      if (_state.pieceLocation(Piece.baqt) == land) {
        land = Location.landEthiopia;
      }
      final controlPiece = _state.landControl(land);
      if (controlPiece != null)
      {
        if (controlPiece.isType(PieceType.romanControl)) {
          continue;
        }
        if (controlPiece == Piece.nubia)
        {
          continue;
        }
        if (controlPiece.isType(PieceType.persianEmpire)) {
          continue;
        }
        if (controlPiece.isType(PieceType.jihad)) {
          continue;
        }
        if (controlPiece == Piece.hordeSeljuksMuslim) {
          continue;
        }
        if (controlPiece.isType(PieceType.abbasid)) {
          tyrant = true;
        }
      } else {
        if (_state.pieceLocation(Piece.papalStates) == land) {
          king = true;
        }
      }
      logLine('>Ruler is established in ${land.desc}.');
      final path = _state.landPath(land)!;
      final precedingLand = _state.pathPrecedingLand(path, land)!;
      final succeedingLand = _state.pathSucceedingLand(path, land)!;
      var oldRuler = _state.pathKing(path);
      var oldRulerLocation = _state.pieceLocation(oldRuler);
      if (oldRulerLocation == Location.flipped) {
        oldRuler = _state.pathTyrant(path);
        oldRulerLocation = _state.pieceLocation(oldRuler);
      }
      if (oldRulerLocation.isType(LocationType.land)) {
        logLine('>${oldRuler.desc} in ${oldRulerLocation.desc} is eliminated.');
      }
      if (controlPiece != null) {
        if (controlPiece.isType(PieceType.horde)) {
          logLine('>${controlPiece.desc} retreats to ${succeedingLand.desc}.');
          _state.setPieceLocation(controlPiece, succeedingLand);
        } else if (controlPiece.isType(PieceType.abbasid)) {
          logLine('>${controlPiece.desc} retreats to ${precedingLand.desc}.');
          _state.setPieceLocation(controlPiece, precedingLand);
        }
      }
      if (!king && !tyrant) {
        tyrant = rulerIsTyrant(land);
        king = !tyrant;
      }
      if (king) {
        logLine('>Ruler is a Christian King.');
        _state.setPieceLocation(_state.pathKing(path), land);
      } else {
        logLine('>Ruler is a pagan Tyrant.');
        _state.setPieceLocation(_state.pathTyrant(path), land);
      }
      return;
    } while (true);
  }

  void secularPhaseHeresy() {
    const waferHeresies = [
      Piece.waferAction1,
      Piece.waferAction2,
      Piece.waferAction3,
      Piece.waferAction4,
      Piece.waferAction6,
      Piece.waferAction7,
      Piece.waferAction9,
      Piece.waferAction10,
      Piece.waferAction11,
      Piece.waferAction13,
      Piece.waferAction14,
      Piece.waferAction16,
      Piece.waferAction21,
      Piece.waferAction24,
      Piece.waferAction30,
    ];
    if (_subStep == 0) {
      final wafer = _state.pieceInLocation(PieceType.waferAction, Location.boxWafer)!;
      if (!waferHeresies.contains(wafer)) {
        return;
      }
      final heresy = randHeresy();
      if (heresy == null) {
        return;
      }
      logLine('### Heresy');
      if (!heresy.isType(PieceType.ebioniteHeresy)) {
        final land = randLand();
        if (_state.landControlArab(land)) {
          logLine('>${heresy.desc} in ${land.desc} is eradicated.');
          _state.setPieceLocation(heresy, Location.discarded);
          return;
        }
        logLine('>${heresy.desc} takes hold in ${land.desc}.');
        _state.setPieceLocation(heresy, land);
        return;
      }
     _subStep = 1;
    }
    if (choicesEmpty()) {
      setPrompt('Select Field Tile for Ebionite Heresy');
      for (final field in PieceType.fieldChristianJews.pieces) {
        if (_state.pieceLocation(field).isType(LocationType.land)) {
          pieceChoosable(field);
        }
      }
      if (choosablePieceCount == 0) {
        for (final field in PieceType.fieldPaganJews.pieces) {
          if (_state.pieceLocation(field).isType(LocationType.land)) {
            pieceChoosable(field);
          }
        }
      }
      throw PlayerChoiceException();
    }
    final heresy = randPiece(_state.piecesInLocation(PieceType.ebioniteHeresy, Location.cupHeresy))!;
    final field = selectedPiece()!;
    final land = _state.pieceLocation(field);
    logLine('>${heresy.desc} takes hold in ${land.desc}.');
    _state.setPieceLocation(heresy, land);
    clearChoices();
  }

  void secularPhaseEpidemic() {
    const waferEpidemics = [
      Piece.waferAction5,
      Piece.waferAction8,
    ];
    if (_subStep == 0) {
      final wafer = _state.pieceInLocation(PieceType.waferAction, Location.boxWafer)!;
      if (!waferEpidemics.contains(wafer)) {
        return;
      }
      logLine('### Epidemic');
      _subStep = 1;
    }
    if (choicesEmpty()) {
      bool hospitalAvailable = _state.piecesInLocationCount(PieceType.hospital, Location.trayInfrastructure) > 0;
      setPrompt('Select Christian Hospital site, or Field Tile to convert');
      for (final field in PieceType.field.pieces) {
        final location = _state.pieceLocation(field);
        if (location.isType(LocationType.land)) {
          if (field.isType(PieceType.fieldPagan)) {
            pieceChoosable(field);
          } else if (hospitalAvailable) {
            final path = _state.landPath(location)!;
            if (_state.pathInfrastructureCount(path) == 0) {
              locationChoosable(location);
            }
          }
        }
      }
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    if (checkChoiceAndClear(Choice.next)) {
      return;
    }
    final field = selectedPiece();
    if (field != null) {
      conversionAttempt(field);
    } else {
      final land = selectedLocation()!;
      final hospitals = _state.piecesInLocation(PieceType.hospital, Location.trayInfrastructure);
      logLine('>Hospital is built in ${land.desc}.');
      _state.setPieceLocation(hospitals[0], land);
    }
    clearChoices();
  }

  void secularPhaseSuddenJihadOnPath(Path path) {
    const waferJihads = [
      Piece.waferAction17,
      Piece.waferAction19,
      Piece.waferAction26,
      Piece.waferAction28,
      Piece.waferAction32,
    ];
    final wafer = _state.pieceInLocation(PieceType.waferAction, Location.boxWafer)!;
    if (!waferJihads.contains(wafer)) {
      return;
    }
    final jihad = _state.pathActiveJihad(path);
    if (jihad == null) {
      return;
    }
    final land = _state.pieceLocation(jihad);
    final succeedingLand = _state.pathSucceedingLand(path, land);
    if (succeedingLand == null || _state.landIsHomeland(succeedingLand)) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Sudden Jihad in ${path.desc}');
      _subStep = 1;
    }
    if (_subStep == 1) {
      invade([jihad], land, succeedingLand);
      _subStep = 2;
    }
    if (_subStep == 2) {
      setPrompt('Invasion Complete');
      choiceChoosable(Choice.next, true);
      _subStep = 3;
      throw PlayerChoiceException();
    }
  }

  void secularPhaseSuddenJihadsWestEurope() {
    secularPhaseSuddenJihadOnPath(Path.westEurope);
  }

  void secularPhaseSuddenJihadsEastEurope() {
    secularPhaseSuddenJihadOnPath(Path.eastEurope);
  }

  void secularPhaseSuddenJihadsCaucasus() {
    secularPhaseSuddenJihadOnPath(Path.caucasus);
  }

  void secularPhaseSuddenJihadsCentralAsia() {
    secularPhaseSuddenJihadOnPath(Path.centralAsia);
  }

  void secularPhaseSuddenJihadsEastAfrica() {
    secularPhaseSuddenJihadOnPath(Path.eastAfrica);
  }

  void secularPhaseSuddenJihadsNorthAfrica() {
    secularPhaseSuddenJihadOnPath(Path.northAfrica);
  }

  void secularPhaseMoveHorde(int index) {
    const waferMoves = [
      [Path.westEurope, Path.westEurope, Path.centralAsia, Path.centralAsia, Path.northAfrica, Path.northAfrica],
      [Path.eastEurope, Path.eastEurope, Path.eastAfrica, Path.eastAfrica, Path.northAfrica, Path.northAfrica],
      [Path.eastEurope, Path.centralAsia, Path.centralAsia, Path.northAfrica],
      [Path.westEurope, Path.westEurope, Path.centralAsia, Path.centralAsia, Path.eastAfrica, Path.eastAfrica],
      [Path.eastEurope, Path.eastEurope, Path.centralAsia, Path.eastAfrica],
      [Path.westEurope, Path.caucasus, Path.caucasus, Path.centralAsia, Path.centralAsia],
      [Path.caucasus, Path.centralAsia, Path.centralAsia, Path.northAfrica, Path.northAfrica],
      [Path.westEurope, Path.eastEurope, Path.northAfrica, Path.northAfrica],
      [Path.caucasus, Path.centralAsia, Path.centralAsia, Path.eastAfrica, Path.eastAfrica],
      [Path.westEurope, Path.caucasus, Path.centralAsia, Path.centralAsia, Path.centralAsia],
      [Path.eastEurope, Path.eastEurope, Path.eastAfrica, Path.northAfrica, Path.northAfrica, Path.northAfrica],
      [Path.westEurope, Path.westEurope, Path.centralAsia, Path.northAfrica, Path.northAfrica],
      [Path.westEurope, Path.westEurope, Path.eastEurope, Path.eastAfrica],
      [Path.eastEurope, Path.eastEurope, Path.centralAsia, Path.northAfrica],
      [Path.westEurope, Path.westEurope, Path.caucasus, Path.caucasus, Path.northAfrica, Path.northAfrica],
      [Path.eastEurope, Path.eastEurope, Path.caucasus, Path.caucasus, Path.northAfrica],
    ];
    final wafer = _state.pieceInLocation(PieceType.waferActionGold, Location.boxWafer);
    if (wafer == null) {
      return;
    }
    final moves = waferMoves[wafer.index - PieceType.waferActionGold.firstIndex];
    if (index >= moves.length) {
      return;
    }
    final path = moves[index];
    final horde = _state.pathActiveHorde(path);
    final land = _state.pieceLocation(horde);
    final precedingLand = _state.pathPrecedingLand(path, land)!;
    if (precedingLand == Location.landJerusalem) {
      return;
    }

    if (_subStep == 0) {
      logLine('### ${horde.desc} Invasion');
      _subStep = 1;
    }

    if (_subStep == 1) {
      if (_state.hordeAllied(horde)) {
        if (choicesEmpty()) {
          setPrompt('Move Allied ${horde.desc}?');
          choiceChoosable(Choice.yes, true);
          choiceChoosable(Choice.no, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.no)) {
          logLine('>Allied ${horde.desc} does not Invade.');
          return;
        }
        clearChoices();
      }
      _subStep = 2;
    }

    if (_subStep == 2) {
      invade([horde], land, precedingLand);
      _subStep = 3;
    }
    if (_subStep == 3) {
      setPrompt('Invasion Complete');
      choiceChoosable(Choice.next, true);
      _subStep = 4;
      throw PlayerChoiceException();
    }
  }

  void secularPhaseMoveHorde0() {
    secularPhaseMoveHorde(0);
  }

  void secularPhaseMoveHorde1() {
    secularPhaseMoveHorde(1);
  }

  void secularPhaseMoveHorde2() {
    secularPhaseMoveHorde(2);
  }

  void secularPhaseMoveHorde3() {
    secularPhaseMoveHorde(3);
  }

  void secularPhaseMoveHorde4() {
    secularPhaseMoveHorde(4);
  }

  void secularPhaseMoveHorde5() {
    secularPhaseMoveHorde(5);
  }

  void secularPhaseJihadStep() {
    final phaseState = _phaseState as PhaseStateSecular;
    if (_state.currentTurn < 21 || _state.currentTurn > 24) {
      phaseState.jihadMoveCount = 0;
      return;
    }
    final path = randPath(Path.values)!;
    phaseState.jihadPath = path;
    logLine('### Jihads in ${path.desc}');
    final jihad = _state.pathActiveJihad(path);
    if (jihad == null) {
      logLine('>No Jihad occurs.');
      phaseState.jihadMoveCount = 0;
      return;
    }
    int die = rollD6();
    logD6(die);
    phaseState.jihadMoveCount = die;
  }

  void secularPhaseJihadMove(int move) {
    final phaseState = _phaseState as PhaseStateSecular;
    if (move >= phaseState.jihadMoveCount!) {
      return;
    }
    final path = phaseState.jihadPath!;
    final jihad = _state.pathActiveJihad(path);
    if (jihad == null) {
      return;
    }
    final land = _state.pieceLocation(jihad);
    final succeedingLand = _state.pathSucceedingLand(path, land)!;
    if (_state.landIsHomeland(succeedingLand)) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Jihad in ${path.desc}');
      _subStep = 1;
    }
    if (_subStep == 1) {
      invade([jihad], land, succeedingLand);
      _subStep = 2;
    }
    if (_subStep == 2) {
      setPrompt('Invasion Complete');
      choiceChoosable(Choice.next, true);
      _subStep = 3;
      throw PlayerChoiceException();
    }
  }

  void secularPhaseJihadMove0() {
    secularPhaseJihadMove(0);
  }

  void secularPhaseJihadMove1() {
    secularPhaseJihadMove(1);
  }

  void secularPhaseJihadMove2() {
    secularPhaseJihadMove(2);
  }

  void secularPhaseJihadMove3() {
    secularPhaseJihadMove(3);
  }

  void secularPhaseJihadMove4() {
    secularPhaseJihadMove(4);
  }

  void secularPhaseJihadMove5() {
    secularPhaseJihadMove(5);
  }

  void secularPhaseSeljuksStep() {
    final phaseState = _phaseState as PhaseStateSecular;
    phaseState.jihadPath = Path.eastEurope;
    if (!_state.pieceLocation(Piece.hordeSeljuksMuslim).isType(LocationType.land)) {
      phaseState.jihadMoveCount = 0;
      return;
    }
    logLine('### Seljuks');
    int die = rollD6();
    logD6(die);
    phaseState.jihadMoveCount = die;
  }

  void secularPhaseRemoveWafer() {
    final wafer = _state.pieceInLocation(PieceType.waferAction, Location.boxWafer)!;
    _state.setPieceLocation(wafer, Location.discarded);
  }

  void secularPhaseEnd() {
    _phaseState = null;
  }

  void religiousPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Religious Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Religious Phase');
    _phaseState = PhaseStateReligious();
  }

  void religiousPhaseActions() {
    final phaseState = _phaseState as PhaseStateReligious;
    while (true) {
      if (_subStep == 0) {
        if (choicesEmpty()) {
          setPrompt('Select Field to Convert or Action to perform');
          for (final field in PieceType.fieldPagan.pieces) {
            final location = _state.pieceLocation(field);
            if (location.isType(LocationType.land)) {
              final path = _state.landPath(location)!;
              bool ok = phaseState.evangelismPath != null || _state.solidi >= 1;
              if (!ok) {
                final bible = _state.pathUnusedBible(path);
                if (_state.pieceLocation(bible) == Location.boxBibleTranslations) {
                  ok = true;
                }
                if (_state.piecesInLocationCount(PieceType.cultIsis, location) > 0) {
                  ok = true;
                }
                if (field.isType(PieceType.fieldPaganJews) && _state.pieceLocation(Piece.apostleJerusalem) == _state.pathPrecedingLand( path, location)) {
                  ok = true;
                }
              }
              if (_state.piecesInLocationCount(PieceType.heresy, location) > 0) {
                ok = false;
              }
              if (ok && phaseState.evangelismPath != null && path != phaseState.evangelismPath) {
                ok = false;
              }
              if (ok) {
                pieceChoosable(field);
              }
            }
          }
          if (phaseState.evangelismPath == null) {
            choiceChoosable(Choice.moveMissionary, _state.solidi >= 1);
            for (final apostle in PieceType.pathApostle.pieces) {
              if (_state.pieceLocation(apostle).isType(LocationType.land)) {
                choiceChoosable(Choice.moveApostleFree, true);
                break;
              }
            }
            if (_state.piecesInLocationCount(PieceType.hospital, Location.trayInfrastructure) > 0 && candidateHospitalSites(6).isNotEmpty) {
              choiceChoosable(Choice.buildHospital, candidateHospitalSites(_state.solidi).isNotEmpty);
            }
            if (_state.piecesInLocationCount(PieceType.monastery, Location.trayInfrastructure) > 0 && candidateMonasterySites(6).isNotEmpty) {
              choiceChoosable(Choice.buildMonastery, candidateMonasterySites(_state.solidi).isNotEmpty);
            }
            if (_state.piecesInLocationCount(PieceType.university, Location.trayInfrastructure) > 0 && candidateUniversitySites(6).isNotEmpty) {
              choiceChoosable(Choice.buildUniversity, candidateUniversitySites(_state.solidi).isNotEmpty);
            }
            if (_state.piecesInLocationCount(PieceType.melkite, Location.trayHeresy) > 0 && candidateMelkiteSites.isNotEmpty) {
              choiceChoosable(Choice.buildMelkite, _state.solidi >= 1);
            }
            if (_state.pieceLocation(Piece.emperorChristian) == Location.boxRomanPolicy && candidateRomanCapitalSites.isNotEmpty) {
              final land = _state.pieceLocation(Piece.romanCapitalChristian);
              int cost = _state.landControlHostile(land) ? 2 : 1;
              choiceChoosable(Choice.moveCapital, _state.solidi >= cost);
            }
            if (candidateMoveKnightPrayForPeacePieces.isNotEmpty && candidateMoveKnightPrayForPeaceDestinations(2).isNotEmpty) {
              choiceChoosable(Choice.moveKnightPrayForPeace, candidateMoveKnightPrayForPeaceDestinations(_state.solidi).isNotEmpty);
            }
            if (_state.piecesInLocationCount(PieceType.bibleUnused, Location.trayBible) > 0) {
              choiceChoosable(Choice.translateBible, candidateBibleTranslations(_state.solidi).isNotEmpty);
            }
            if (candidateHordeConversions(8).isNotEmpty) {
              choiceChoosable(Choice.convertHorde, candidateHordeConversions(_state.solidi).isNotEmpty);
            }
            if (candidateTyrantConversions.isNotEmpty) {
              choiceChoosable(Choice.convertTyrant, _state.solidi >= 3);
            }
            if (_state.pieceLocation(Piece.greatTheologian).isType(LocationType.greatTheologian)) {
              choiceChoosable(Choice.evangelism, _state.darkAges < 7);
              choiceChoosable(Choice.revivalism, _state.darkAges < 7);
              choiceChoosable(Choice.reconciliation, _state.darkAges > 0);
            }
            if (candidatePersecutions.isNotEmpty) {
              choiceChoosable(Choice.persecute, _state.solidi >= 1);
            }
            if (candidateOffensives.isNotEmpty) {
              choiceChoosable(Choice.offensive, _state.solidi >= 1);
            }

            if (candidateRelics.isNotEmpty) {
              choiceChoosable(Choice.sellRelics, true);
            }

            if (_state.currentTurn >= 25 && _state.currentTurn <= 27 && _state.limitedEventCount(LimitedEvent.reconquistaAttempted) == 0) {
              if (_state.pieceLocation(Piece.occupiedSpain) == Location.landSpain && _state.landChristian(Location.landSpain)) {
                choiceChoosable(Choice.reconquista, _state.solidi >= reconquistaCost);
              }
            }
          }

          if (candidateHeresies(1, phaseState.evangelismPath).isNotEmpty) {
            choiceChoosable(Choice.endHeresy, candidateHeresies(_state.solidi, phaseState.evangelismPath).isNotEmpty);
          }
          if (phaseState.evangelismPath == null) {
            choiceChoosable(Choice.next, true);
          } else {
            choiceChoosable(Choice.evangelismComplete, true);
          }
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.next)) {
          return;
        }
        if (checkChoice(Choice.moveMissionary) || checkChoice(Choice.moveApostleFree)) {
          phaseState.moveApostleFree = checkChoice(Choice.moveApostleFree);
          clearChoices();
          _subStep = 1;
        } else if (checkChoiceAndClear(Choice.buildHospital)) {
          _subStep = 5;
        } else if (checkChoiceAndClear(Choice.buildMonastery)) {
          _subStep = 6;
        } else if (checkChoiceAndClear(Choice.buildUniversity)) {
          _subStep = 7;
        } else if (checkChoiceAndClear(Choice.translateBible)) {
          _subStep = 8;
        } else if (checkChoiceAndClear(Choice.endHeresy)) {
          _subStep = 9;
        } else if (checkChoiceAndClear(Choice.convertHorde)) {
          _subStep = 11;
        } else if (checkChoiceAndClear(Choice.convertTyrant)) {
          _subStep = 12;
        } else if (checkChoiceAndClear(Choice.evangelism)) {
          _subStep = 13;
        } else if (checkChoiceAndClear(Choice.evangelismComplete)) {
          final greatTheologian = _state.pieceLocation(Piece.greatTheologian);
          logLine('>Evangelism of ${greatTheologian.desc} comes to an end.');
          phaseState.evangelismPath = null;
          _state.setPieceLocation(Piece.greatTheologian, Location.trayMisc);
        } else if (checkChoiceAndClear(Choice.revivalism)) {
          _subStep = 14;
        } else if (checkChoiceAndClear(Choice.reconciliation)) {
          final greatTheologian = _state.pieceLocation(Piece.greatTheologian);
          logLine('### ${greatTheologian.desc} advocates Reconciliation');
          adjustDarkAges(-1);
          _state.setPieceLocation(Piece.greatTheologian, Location.trayMisc);
        } else if (checkChoiceAndClear(Choice.persecute)) {
          _subStep = 15;
        } else if (checkChoiceAndClear(Choice.offensive)) {
          _subStep = 16;
        } else if (checkChoiceAndClear(Choice.sellRelics)) {
          _subStep = 18;
        } else if (checkChoiceAndClear(Choice.moveCapital)) {
          _subStep = 19;
        } else if (checkChoiceAndClear(Choice.moveKnightPrayForPeace)) {
          _subStep = 20;
        } else if (checkChoiceAndClear(Choice.reconquista)) {
          logLine('### Attempt Spanish Reconquista');
          adjustSolidi(-reconquistaCost);
          _state.limitedEventOccurred(LimitedEvent.reconquistaAttempted);
          logLine('>Christian Lands');
          int christianLandCount = 0;
          for (final land in LocationType.pathWestEurope.locations) {
            if (_state.landChristian(land)) {
              logLine('> - ${land.desc}');
              christianLandCount += 1;
            }
          }
          logLine('');

          final rolls = roll2D6();
          final total = rolls.$3;

          logTableHeader();
          log2D6InTable(rolls);
          logLine('>|Christian Lands|$christianLandCount|');
          logTableFooter();

          if (total <= christianLandCount) {
            logLine('>Spanish Reconquista is successful.');
            _state.setPieceLocation(Piece.reconquista, Location.landSpain);
          } else {
            logLine('>Spanish Reconquista fails.');
          }
        } else if (checkChoiceAndClear(Choice.buildMelkite)) {
          _subStep = 22;
        } else {
          _subStep = 30;
        }
      }

      if (_subStep == 1) { // Select Missionary to Move
        if (choicesEmpty()) {
          setPrompt('Select Missionary to Move');
          for (final path in Path.values) {
            final missionary = _state.pathActiveMissionary(path);
            if (!phaseState.moveApostleFree || missionary.isType(PieceType.pathApostle)) {
              if (_state.missionaryCanBeUsed(missionary)) {
                  pieceChoosable(missionary);
              }
            }
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          phaseState.moveApostleFree = false;
          _subStep = 0;
          continue;
        }
        final missionary = selectedPiece()!;
        phaseState.moveMissionary = missionary;
        if (!missionary.isType(PieceType.archbishop)) {
          final fromLand = _state.pieceLocation(missionary);
          final path = _state.missionaryPath(missionary)!;
          final toLand = _state.pathSucceedingLand(path, fromLand)!;
          phaseState.moveMissionaryDestination = toLand;
          clearChoices();
          _subStep = 3;
        } else {
          phaseState.field = selectedPiece()!;
          clearChoices();
          _subStep = 2;
        }
      }

      if (_subStep == 2) { // Select Missionary Destination
        if (phaseState.moveMissionaryDestination == null) {
          if (choicesEmpty()) {
            setPrompt('Select Land to Move Archbishop to');
            final land = _state.pieceLocation(phaseState.moveMissionary!);
            final path = _state.missionaryPath(phaseState.moveMissionary!)!;
            Location? toLand = _state.pathFirstLand(path);
            while (toLand != null) {
              if (toLand != land) {
                locationChoosable(toLand);
              }
              toLand = _state.pathSucceedingLand(path, toLand);
            }
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
          if (checkChoice(Choice.cancel)) {
            clearChoices();
            phaseState.moveApostleFree = false;
            phaseState.moveMissionary = null;
            _subStep = 0;
            continue;
          }
          phaseState.moveMissionaryDestination = selectedLocation();
          clearChoices();
        }
        _subStep = 3;
      }

      if (_subStep == 3) { // Move Missionary
        logLine('### Move Missionary');
        if (!phaseState.moveApostleFree) {
          adjustSolidi(-1);
        }
        final missionary = phaseState.moveMissionary!;
        final land = phaseState.moveMissionaryDestination!;
        logLine('>${missionary.desc} moves to ${land.desc}.');
        _state.setPieceLocation(missionary, land);
        if (_state.landIsHomeland(land)) {
          if (!missionary.isType(PieceType.archbishop)) {
            final path = _state.landPath(land)!;
            final archbishop = _state.pathArchbishop(path);
            logLine('>${missionary.desc} is promoted to Archbishop.');
            _state.setPieceLocation(missionary, Location.discarded);
            _state.setPieceLocation(archbishop, land);
          }
        }
        _subStep = 4;
      }

      if (_subStep == 4) { // Discovery etc.
        final missionary = phaseState.moveMissionary!;
        final land = phaseState.moveMissionaryDestination!;
        final path = _state.landPath(land)!;
        if (!_state.landIsHomeland(land)) {
          if (_state.pieceInLocation(PieceType.field, land) == null) {
            final field = drawFieldForLand(land);
            logLine('>${field.desc} are Discovered in ${land.desc}.');
            _state.setPieceLocation(field, land);
            if (!_state.landIsBigCity(land) && missionary.isType(PieceType.bishop) && field.isType(PieceType.fieldPaganWomen)) {
              logLine('>Bishop becomes flustered.');
              final precedingLand = _state.pathPrecedingLand(path, land)!;
              logLine('>Bishop retreats to ${precedingLand.desc}.');
              _state.setPieceLocation(missionary, precedingLand);
            }
          }
          if (phaseState.moveApostleFree) {
            logLine('>Martyrdom');
            int die = rollD6();
            logD6(die);
            final locationType = _state.pathLocationType(path);
            final sequence = land.index - locationType.firstIndex + 1;
            if (die <= sequence) {
              logLine('>${missionary.desc} is Martyred.');
              final relics = _state.pieceFlipSide(missionary)!;
              logLine('>Relics and Bishop are created in ${land.desc}.');
              _state.setPieceLocation(relics, land);
              final bishop = _state.pathBishop(path);
              _state.setPieceLocation(bishop, land);
            } else {
              logLine('>${missionary.desc} is welcomed in ${land.desc}.');
            }
          }
        }
        phaseState.moveApostleFree = false;
        phaseState.moveMissionary = null;
        phaseState.moveMissionaryDestination = null;
        _subStep = 0;
      }

      if (_subStep == 5) { // Build Hospital
        if (choicesEmpty()) {
          setPrompt('Select Land to Build Hospital in');
          for (final land in candidateHospitalSites(_state.solidi)) {
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
        logLine('### Build Hospital in ${land.desc}');
        int cost = _state.pieceInLocation(PieceType.fieldChristianPhysicians, land) != null ? 3 : 6;
        adjustSolidi(-cost);
        final hospitals = _state.piecesInLocation(PieceType.hospital, Location.trayInfrastructure);
        _state.setPieceLocation(hospitals[0], land);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 6) { // Build Monastery
        if (choicesEmpty()) {
          setPrompt('Select Land to Build Monastery in');
          for (final land in candidateMonasterySites(_state.solidi)) {
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
        logLine('### Build Monastery in ${land.desc}');
        int cost = _state.pieceInLocation(PieceType.fieldChristianAscetics, land) != null ? 3 : 6;
        adjustSolidi(-cost);
        final monasteries = _state.piecesInLocation(PieceType.monastery, Location.trayInfrastructure);
        _state.setPieceLocation(monasteries[0], land);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 7) { // Build University
        if (choicesEmpty()) {
          setPrompt('Select Land to Build University in');
          for (final land in candidateUniversitySites(_state.solidi)) {
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
        logLine('### Build University in ${land.desc}');
        int cost = _state.pieceInLocation(PieceType.fieldChristianScholars, land) != null ? 3 : 6;
        adjustSolidi(-cost);
        final universities = _state.piecesInLocation(PieceType.university, Location.trayInfrastructure);
        _state.setPieceLocation(universities[0], land);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 8) { // Translate Bible
        if (choicesEmpty()) {
          setPrompt('Select Bible to Translate');
          if (_state.pieceLocation(Piece.bibleGreek) == Location.trayBible) {
            pieceChoosable(Piece.bibleGreek);
          } else {
            for (final bible in _state.piecesInLocation(PieceType.bibleUnused, Location.trayBible)) {
              int discount = bibleTranslationDiscount(bible);
              if (_state.solidi + discount >= 6) {
                pieceChoosable(bible);
              }
            }
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          clearChoices();
          _subStep = 0;
          continue;
        }
        final bible = selectedPiece()!;
        clearChoices();
        logLine('### Translate Bible into ${_state.bibleLanguageName(bible)}');
        int discount = bibleTranslationDiscount(bible);
        adjustSolidi(discount - 6);
        _state.setPieceLocation(bible, Location.boxBibleTranslations);
        _subStep = 0;
      }

      if (_subStep == 9) { // End Heresy - Selection
        if (choicesEmpty()) {
          setPrompt('Select Heresy to End');
          for (final heresy in candidateHeresies(_state.solidi, phaseState.evangelismPath)) {
            pieceChoosable(heresy);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          clearChoices();
          _subStep = 0;
          continue;
        }
        phaseState.heresy = selectedPiece()!;
        _subStep = 10;
      }
      if (_subStep == 10) { // End Heresy - Payment and Resolution
        final heresy = phaseState.heresy!;
        final land = _state.pieceLocation(heresy);
        final path = _state.landPath(land)!;
        bool solidi = _state.solidi >= 1;
        bool bible = _state.pieceLocation(_state.pathUnusedBible(path)) == Location.boxBibleTranslations;
        bool evangelism = false;
        if (phaseState.evangelismPath != null) {
          evangelism = true;
          solidi = false;
          bible = false;
        }
        if (choicesEmpty()) {
          choiceChoosable(Choice.paySolidi, solidi);
          if (bible) {
            choiceChoosable(Choice.payBible, true);
          }
          if (enabledChoiceCount > 1) {
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
        }
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          phaseState.heresy = null;
          _subStep = 0;
          continue;
        }
        if (checkChoice(Choice.paySolidi)) {
          bible = false;
        } else if (checkChoice(Choice.payBible)) {
          solidi = false;
        }
        clearChoices();
        logLine('### End ${heresy.desc} Heresy');
        if (solidi) {
          adjustSolidi(-1);
        } else if (bible) {
          final unusedBible = _state.pathUnusedBible(path);
          logLine('>${unusedBible.desc} is used.');
          _state.flipPiece(unusedBible);
        }
        int die = rollD6();
        int modifiers = 0;

        logTableHeader();
        logD6InTable(die);
        for (final pieceType in [PieceType.apostle, PieceType.bishop, PieceType.archbishop, PieceType.pope]) {
          final piece = _state.pieceInLocation(pieceType, land);
          if (piece != null) {
            logLine('>|${piece.desc}|+1|');
            modifiers += 1;
          }
        }
        if (_state.landControlChristian(land)) {
          logLine('>|Christian Control|+1|');
          modifiers += 1;
        }
        int total = die;
        if (die > 1) {
          total += modifiers;
        }
        logLine('>|Total|$total|');
        logTableFooter();

        if (total > _state.heresyValue(heresy)) {
          logLine('>${heresy.desc} Heresy in ${land.desc} is suppressed.');
          if (heresy.isType(PieceType.ebioniteHeresy)) {
            _state.setPieceLocation(heresy, Location.trayHeresy);
          } else {
            _state.setPieceLocation(_state.pieceFlipSide(heresy)!, Location.trayHeresy);
          }
        } else {
          logLine('>Attempt to end ${heresy.desc} Heresy fails.');
          if (evangelism) {
            final greatTheologian = _state.pieceLocation(Piece.greatTheologian);
            logLine('>Evangelism of ${greatTheologian.desc} comes to an ignominious end.');
            adjustDarkAges(1);
            _state.setPieceLocation(Piece.greatTheologian, Location.trayMisc);
            phaseState.evangelismPath = null;
          }
        }
        phaseState.heresy = null;
        _subStep = 0;
      }

      if (_subStep == 11) { // Convert Horde
        if (choicesEmpty()) {
          setPrompt('Select Horde to Convert');
          for (final horde in candidateHordeConversions(_state.solidi)) {
            pieceChoosable(horde);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final horde = selectedPiece()!;
        clearChoices();
        logLine('### Convert ${horde.desc}');
        final hordeLand = _state.pieceLocation(horde);
        final path = _state.landPath(hordeLand)!;
        final locationType = _state.pathLocationType(path);
        int controlCount = 0;
        for (final land in locationType.locations) {
          if (_state.landControl(land) == horde) {
            controlCount += 1;
          }
        }
        adjustSolidi(-controlCount);
        int christianCount = 0;
        for (final land in locationType.locations) {
          if (_state.landControl(land) == horde) {
            if (_state.pieceInLocation(PieceType.fieldChristian, land) != null) {
              if (_state.piecesInLocationCount(PieceType.heresy, land) == 0) {
                logLine('>${land.desc} is Christian');
                christianCount += 1;
              }
            }
          }
        }
        int die = rollD6();

        logTableHeader();
        logD6InTable(die);
        logLine('>|Christian Lands|$christianCount|');
        logTableFooter();

        if (die <= christianCount) {
          String religion = horde == Piece.hordeKhazarsPagan ? 'Judaism' : 'Christianity';
          logLine('>${horde.desc} convert to $religion.');
          _state.flipPiece(horde);
        } else {
          logLine('>Attempt to Convert ${horde.desc} fails.');
        }
        _subStep = 0;
      }

      if (_subStep == 12) { // Convert Tyrant
        if (choicesEmpty()) {
          setPrompt('Select Tyrant to Convert');
          for (final tyrant in candidateTyrantConversions) {
            pieceChoosable(tyrant);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final tyrant = selectedPiece()!;
        final land = _state.pieceLocation(tyrant);
        clearChoices();
        logLine('### Convert ${tyrant.desc}');
        adjustSolidi(-3);
        if (!rulerIsTyrant(land)) {
          logLine('>${tyrant.desc} converts to Christianity.');
          _state.flipPiece(tyrant);
        } else {
          logLine('>Attempt to Convert ${tyrant.desc} fails.');
        }
        _subStep = 0;
      }

      if (_subStep == 13) { // Evangelism
        final greatTheologian = _state.pieceLocation(Piece.greatTheologian);
        if (choicesEmpty()) {
          setPrompt('Select Path to Evangelize on');
          for (final path in _state.greatTheologianPaths(greatTheologian)) {
            locationChoosable(_state.pathHomeland(path));
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final homeland = selectedLocation()!;
        final path = _state.landPath(homeland)!;
        logLine('### ${greatTheologian.desc} Evangelizes in ${path.desc}');
        phaseState.evangelismPath = path;
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 14) { // Revivalism
        final greatTheologian = _state.pieceLocation(Piece.greatTheologian);
        if (choicesEmpty()) {
          setPrompt('Select Land to protect from Apostasy');
          for (final path in _state.greatTheologianPaths(greatTheologian)) {
            final locationType = _state.pathLocationType(path);
            for (final land in locationType.locations) {
              if (_state.pieceInLocation(PieceType.fieldChristian, land) != null) {
                locationChoosable(land);
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
        final land = selectedLocation()!;
        logLine('### ${greatTheologian.desc} revives Christianity in ${land.desc}');
        _state.setPieceLocation(Piece.greatTheologian, land);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 15) { // Persecute
        if (choicesEmpty()) {
          setPrompt('Select Schism to Persecute');
          for (final schism in candidatePersecutions) {
            pieceChoosable(schism);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final schism = selectedPiece()!;
        final land = _state.pieceLocation(schism);
        final path = _state.landPath(land)!;
        logLine('### Persecute Schism on ${path.desc}');
        adjustSolidi(-1);
        final box = _state.pathFaithBox(path);
        final faith = _state.pieceInLocation(PieceType.faith, box)!;
        logLine('>${faith.desc} on ${path.desc} Submit.');
        _state.flipPiece(schism);
        _state.flipPiece(faith);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 16) { // Offensive
        if (choicesEmpty()) {
          setPrompt('Select Land to Attack');
          for (final land in candidateOffensives) {
            locationChoosable(land);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        _subStep = 17;
      }
      if (_subStep == 17) { // Offensive
        final defenderLand = selectedLocation()!;
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          _subStep = 0;
          continue;
        }
        if (selectedPieces().isEmpty) {
          setPrompt('Select Advance Force to Attack with');
          for (final piece in candidateAttackers(defenderLand)) {
            pieceChoosable(piece);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        final attackers = [selectedPiece()!];
        for (final otherAttacker in candidateAttackers(defenderLand)) {
          if (otherAttacker != attackers[0]) {
            attackers.add(otherAttacker);
          }
        }
        final attackerLand = _state.pieceLocation(attackers[0]);
        final path = _state.landPath(attackerLand)!;
        final fromLand = defenderLand.index > attackerLand.index ? _state.pathPrecedingLand(path, defenderLand)! : _state.pathSucceedingLand(path, defenderLand)!;
        invade(attackers, fromLand, defenderLand);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 18) { // Sell Relics
        if (choicesEmpty()) {
          setPrompt('Select Relics to Sell');
          for (final relics in candidateRelics) {
            pieceChoosable(relics);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final relics = selectedPiece()!;
        logLine('### Sell Relics');
        final apostle = _state.pieceFlipSide(relics)!;
        logLine('>Relics of ${apostle.desc} are sold to raise cash.');
        _state.setPieceLocation(relics, Location.discarded);
        adjustSolidi(_state.currentTurn >= 25 ? 2 : 1);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 19) { // Move Capital
        if (choicesEmpty()) {
          setPrompt('Select new location of Roman Capital');
          for (final land in candidateRomanCapitalSites) {
            locationChoosable(land);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        final newLand = selectedLocation()!;
        final oldLand = _state.pieceLocation(Piece.romanCapitalChristian);
        int cost = _state.landControlHostile(oldLand) ? 2 : 1;
        logLine('### Move Roman Capital');
        logLine('>Roman Capital is relocated from ${oldLand.desc} to ${newLand.desc}.');
        adjustSolidi(-cost);
        _state.setPieceLocation(Piece.romanCapitalChristian, newLand);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 20) { // Move Knight or Pray for Peace
        if (choicesEmpty()) {
          setPrompt('Select Knight or Pray for Peace Tile to Move');
          for (final piece in candidateMoveKnightPrayForPeacePieces) {
            pieceChoosable(piece);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          _subStep = 0;
          continue;
        }
        _subStep = 21;
      }
      if (_subStep == 21) { // Move Knight or Pray for Peace
        var piece = selectedPiece()!;
        if (_choiceInfo.selectedLocations.isEmpty) {
          setPrompt('Select Land to Move Knight or Pray for Peace to');
          for (final land in candidateMoveKnightPrayForPeaceDestinations(_state.solidi)) {
            locationChoosable(land);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          _subStep = 0;
          continue;
        }
        final oldLocation = _state.pieceLocation(piece);
        final newLand = selectedLocation()!;
        int cost = 1;
        bool knight = true;
        if (_state.landControlChristian(newLand)) {
          final path = _state.landPath(newLand)!;
          if (_state.pathInSchism(path)) {
            cost = 2;
          }
        } else {
          knight = false;
        }
        if (knight != piece.isType(PieceType.knight)) {
          piece = _state.pieceFlipSide(piece)!;
        }
        if (knight) {
          logLine('### Knights Move');
        } else {
          logLine('### Peace Move');
        }
        if (oldLocation == Location.boxDamagedArmies) {
          logLine('>Build ${piece.desc} in ${newLand.desc}.');
        } else {
          logLine('>Move ${piece.desc} from ${oldLocation.desc} to ${newLand.desc}.');
        }
        adjustSolidi(-cost);
        _state.setPieceLocation(piece, newLand);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 22) { // Build Melkite
        if (choicesEmpty()) {
          setPrompt('Select Land for Melkite');
          for (final land in candidateMelkiteSites) {
            locationChoosable(land);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        final land = selectedLocation()!;
        logLine('### Build Melkite in ${land.desc}');
        adjustSolidi(-1);
        final melkites = _state.piecesInLocation(PieceType.melkite, Location.trayHeresy);
        _state.setPieceLocation(melkites[0], land);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 30) { // Conversion
        final field = selectedPiece()!;
        phaseState.field = field;
        final land = _state.pieceLocation(field);
        final path = _state.landPath(land)!;
        bool solidi = _state.solidi >= 1;
        bool bible = _state.pieceLocation(_state.pathUnusedBible(path)) == Location.boxBibleTranslations;
        bool isis = _state.piecesInLocationCount(PieceType.cultIsis, land) > 0;
        bool james = field.isType(PieceType.fieldPaganJews) && _state.pieceLocation(Piece.apostleJerusalem) == _state.pathPrecedingLand(path, land);
        bool evangelism = false;
        if (phaseState.evangelismPath != null) {
          evangelism = true;
          solidi = false;
          bible = false;
          isis = false;
          james = false;
        }
        if (_choiceInfo.selectedChoices.isEmpty) {
          choiceChoosable(Choice.paySolidi, solidi);
          if (bible) {
            choiceChoosable(Choice.payBible, true);
          }
          if (isis) {
            choiceChoosable(Choice.payIsis, true);
          }
          if (james) {
            choiceChoosable(Choice.payJames, true);
          }
          if (enabledChoiceCount > 1) {
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
        }
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          _subStep = 0;
          continue;
        }
        if (checkChoice(Choice.paySolidi)) {
          bible = false;
          isis = false;
          james = false;
        } else if (checkChoice(Choice.payBible)) {
          solidi = false;
          isis = false;
          james = false;
        } else if (checkChoice(Choice.payIsis)) {
          solidi = false;
          bible = false;
          james = false;
        } else if (checkChoice(Choice.payJames)) {
          solidi = false;
          bible = false;
          isis = false;
        }
        clearChoices();
        logLine('### Convert ${land.desc}');
        if (solidi) {
          adjustSolidi(-1);
        } else if (bible) {
          final unusedBible = _state.pathUnusedBible(path);
          logLine('>${unusedBible.desc} is used.');
          _state.flipPiece(unusedBible);
        } else if (isis) {
          final cult = _state.pieceInLocation(PieceType.cultIsis, land)!;
          logLine('>Cult of Isis is used.');
          _state.setPieceLocation(cult, Location.discarded);
        } else if (james) {
          logLine('>James the Just preaches to the Jews.');
        }
        if (!conversionAttempt(field)) {
          if (james) {
            logLine('>${Piece.apostleJerusalem.desc} is Martyred.');
            _state.flipPiece(Piece.apostleJerusalem);
          } else if (evangelism) {
            final greatTheologian = _state.pieceLocation(Piece.greatTheologian);
            logLine('>Evangelism of ${greatTheologian.desc} comes to an ignominious end.');
            adjustDarkAges(1);
            _state.setPieceLocation(Piece.greatTheologian, Location.trayMisc);
            phaseState.evangelismPath = null;
          }
        }
        phaseState.field = null;
        _subStep = 0;
      }
    }
  }

  void endOfTurnPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to End of Turn Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## End of Turn Phase');
    _phaseState = PhaseStateEndOfTurn();
  }

  void endOfTurnPhaseDarkAgesCollapse() {
    if (_state.darkAges < 7) {
      return;
    }
    logLine('# The Christian world collapses into the Dark Ages.');
    throw GameOverException(GameResult.defeatDarkAges, 0);
  }

  void endOfTurnPhasePersianReligion() {
    if (_state.pieceLocation(Piece.persiaZoroastrian) != Location.boxPersianReligion) {
      return;
    }
    for (final land in [Location.landCtesiphon, Location.landPersia, Location.landMerv]) {
      if (_state.landControl(land) != Piece.abbasidCentralAsia) {
        return;
      }
    }
    if (_subStep == 0) {
      logLine('### Persian Religion');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Prevent Persian conversion to Islam?');
        choiceChoosable(Choice.yes, _state.solidi >= 5);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        logLine('>The Christian Church supports the Zoroastrian faith in Persia.');
        adjustSolidi(-5);
      } else {
        logLine('>Persia converts to Islam.');
        _state.flipPiece(Piece.persiaZoroastrian);
      }
      clearChoices();
    }
  }

  void endOfTurnPhaseChristianApostasy() {
    final phaseState = _phaseState as PhaseStateEndOfTurn;
    final lands = apostasyLands;
    if (lands.isEmpty) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Christian Apostasy');
      _subStep = 1;
    }
    while (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select lands to Prevent Apostasy in');
        for (final land in apostasyLands) {
          if (!phaseState.preventApostasyLands.contains(land)) {
            if (_state.solidi >= preventApostasyCostForLand(land)) {
              locationChoosable(land);
            }
          }
        }
        choiceChoosable(Choice.next, true);
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.cancel)) {
        continue;
      }
      if (checkChoiceAndClear(Choice.next)) {
        _subStep = 2;
        break;
      }
      final land = selectedLocation()!;
      logLine('>Apostasy is Prevented in ${land.desc}.');
      int cost = preventApostasyCostForLand(land);
      adjustSolidi(-cost);
      phaseState.preventApostasyLands.add(land);
      clearChoices();
    }
    if (_subStep == 2) {
      for (final land in apostasyLands) {
        if (!phaseState.preventApostasyLands.contains(land)) {
          logLine('>${land.desc} goes into Apostasy.');
          final field = _state.pieceInLocation(PieceType.fieldChristian, land)!;
          _state.flipPiece(field);
        }
      }
    }
  }

  void endOfTurnPhaseTheCrusades() {
    if (_state.currentTurn != 27) {
      return;
    }
    logLine('# The Crusades');
    _state.setPieceLocation(Piece.gameTurn, _state.actsBox(28));
    int score = 0;

    logTableHeader();
    int christianLandValues = 0;
    int untouchedLandCount = 0;
    for (final land in LocationType.pathLand.locations) {
      if (!_state.landIsHomeland(land)) {
        final field = _state.pieceInLocation(PieceType.field, land);
        if (field != null) {
          if (field.isType(PieceType.fieldChristian)) {
            christianLandValues += _state.fieldValue(field);
          } 
        } else {
          untouchedLandCount += 1;
        }
      }
    }
    logLine('>|Christian Land Values|+$christianLandValues|');
    score += christianLandValues;
    for (final path in Path.values) {
      final locationType = _state.pathLocationType(path);
      bool pathChristian = true;
      for (final land in locationType.locations) {
        if (!_state.landIsHomeland(land)) {
          if (_state.pieceInLocation(PieceType.fieldChristian, land) == null) {
            pathChristian = false;
            break;
          }
        }
      }
      if (pathChristian) {
        logLine('>|${path.desc} fully Christian|+5|');
        score += 5;
      }
    }
    if (_state.pieceLocation(Piece.reconquista) == Location.landSpain) {
      logLine('>|Spanish Reconquista|+5|');
      score += 5;
    }
    for (final land in [Location.landCtesiphon, Location.landPersia, Location.landMerv]) {
      if (_state.pieceInLocation(PieceType.persianEmpire, land) != null) {
        logLine('>|Persian Empire controls ${land.desc}|+5|');
        score += 5;
      }
    }
    for (final pope in PieceType.popeNonSchism.pieces) {
      final location = _state.pieceLocation(pope);
      if (location.isType(LocationType.land)) {
        if (_state.piecesInLocationCount(PieceType.heresy, location) == 0) {
          logLine('>|${pope.desc}|+3|');
          score += 3;
        }
      }
    }
    if (_state.solidi > 0) {
      logLine('>|Solidi|+${_state.solidi}|');
      score += _state.solidi;
    }
    for (final relics in PieceType.relics.pieces) {
      final location = _state.pieceLocation(relics);
      if (location.isType(LocationType.land)) {
        logLine('>|Relics in ${location.desc}|+3|');
        score += 3;
      }
    }
    for (final infrastructure in PieceType.infrastructure.pieces) {
      final location = _state.pieceLocation(infrastructure);
      if (location.isType(LocationType.land)) {
        int value = _state.landControlChristian(location) ? 4 : 3;
        logLine('>|${infrastructure.desc} in ${location.desc}|+$value|');
        score += value;
      }
    }
    if (untouchedLandCount > 0) {
      logLine('>|Lands untouched by Christianity|-$untouchedLandCount|');
      score -= untouchedLandCount;
    }
    for (final heresy in PieceType.heresy.pieces) {
      final location = _state.pieceLocation(heresy);
      if (location.isType(LocationType.land)) {
        logLine('>|${heresy.desc} in ${location.desc}|-5|');
        score -= 5;
      }
    }
    for (final path in Path.values) {
      final faith = _state.pathFaith(path);
      if (faith != null && faith.isType(PieceType.faithSubmit)) {
        logLine('>|${path.desc} Submit|-5|');
        score -= 5;
      }
    }
    final land = _state.pieceLocation(Piece.romanCapitalChristian);
    if (!_state.landControlChristian(land)) {
      logLine('>|Roman Capital in ${land.desc} not under Christian Control|-10|');
      score -= 10;
    }
    if (_state.darkAges > 0) {
      logLine('>|Dark Ages|-${_state.darkAges}|');
      score -= _state.darkAges;
    }
    for (final bible in _state.piecesInLocation(PieceType.bible, Location.trayBible)) {
      logLine('>|${bible.desc} not Translated|-5|');
      score -= 5;
    }
    logLine('>|Score|$score|');
    logTableFooter();

    throw GameOverException(GameResult.victory, score);
  }

  void endOfTurnPhaseResets() {
    if (_state.pieceLocation(Piece.romanaLex) != Location.flipped) {
      _state.flipPiece(Piece.romanaLex);
    }
    if (_state.pieceLocation(Piece.emperorHeretical) != Location.flipped) {
      _state.flipPiece(Piece.emperorHeretical);
    }
    _state.setPieceLocation(Piece.greatTheologian, Location.trayMisc);
    for (final bible in PieceType.bibleUnused.pieces) {
      if (_state.pieceLocation(bible) != Location.trayBible) {
        _state.setPieceLocation(bible, Location.boxBibleTranslations);
      }
    }
  }

  void endOfTurnPhaseLoseOrBankMoney() {
    if (_state.solidi == 0) {
      return;
    }
    int monasteryCount = 0;
    for (final monastery in PieceType.monastery.pieces) {
      if (_state.pieceLocation(monastery).isType(LocationType.land)) {
        monasteryCount += 1;
      }
    }
    int newSolidi = min(_state.solidi, monasteryCount);
    if (newSolidi > 0) {
      logLine('### Bank Money');
    } else {
      logLine('### Lose Money');
    }
    adjustSolidi(newSolidi - _state.solidi);
    if (newSolidi > 0) {
      logLine('>|Bank $newSolidi Solidi');
    }
  }

  void endOfTurnPhaseAdvanceTurn() {
    _state.advanceTurn();
  }

  void endOfTurnPhaseEnd() {
    _phaseState = null;
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      historyPhaseBegin,
      historyPhaseNewEra,
      historyPhaseHideHeresy,
      historyPhaseGreatTheologian,
      historyPhaseEcumenicalCouncil,
      historyPhaseJustinian,
      historyPhaseCharlemagne,
      historyPhaseShewaSultanate,
      historyPhaseTurkishConversion,
      historyPhaseMoveRomanArmy,
      secularPhaseBegin,
      secularPhaseDrawWafer,
      secularPhaseEarnSolidi,
      secularPhaseUpdateRomanPolicy,
      secularPhaseEnactRomanPolicy,
      secularPhaseFlipWafer,
      secularPhaseRuler,
      secularPhaseHeresy,
      secularPhaseEpidemic,
      secularPhaseSuddenJihadsWestEurope,
      secularPhaseSuddenJihadsEastEurope,
      secularPhaseSuddenJihadsCaucasus,
      secularPhaseSuddenJihadsCentralAsia,
      secularPhaseSuddenJihadsEastAfrica,
      secularPhaseSuddenJihadsNorthAfrica,
      secularPhaseMoveHorde0,
      secularPhaseMoveHorde1,
      secularPhaseMoveHorde2,
      secularPhaseMoveHorde3,
      secularPhaseMoveHorde4,
      secularPhaseMoveHorde5,
      secularPhaseJihadStep,
      secularPhaseJihadMove0,
      secularPhaseJihadMove1,
      secularPhaseJihadMove2,
      secularPhaseJihadMove3,
      secularPhaseJihadMove4,
      secularPhaseJihadMove5,
      secularPhaseJihadStep,
      secularPhaseJihadMove0,
      secularPhaseJihadMove1,
      secularPhaseJihadMove2,
      secularPhaseJihadMove3,
      secularPhaseJihadMove4,
      secularPhaseJihadMove5,
      secularPhaseJihadStep,
      secularPhaseJihadMove0,
      secularPhaseJihadMove1,
      secularPhaseJihadMove2,
      secularPhaseJihadMove3,
      secularPhaseJihadMove4,
      secularPhaseJihadMove5,
      secularPhaseSeljuksStep,
      secularPhaseJihadMove0,
      secularPhaseJihadMove1,
      secularPhaseJihadMove2,
      secularPhaseJihadMove3,
      secularPhaseJihadMove4,
      secularPhaseJihadMove5,
      secularPhaseRemoveWafer,
      secularPhaseEnd,
      religiousPhaseBegin,
      religiousPhaseActions,
      endOfTurnPhaseBegin,
      endOfTurnPhaseDarkAgesCollapse,
      endOfTurnPhasePersianReligion,
      endOfTurnPhaseChristianApostasy,
      endOfTurnPhaseTheCrusades,
      endOfTurnPhaseResets,
      endOfTurnPhaseLoseOrBankMoney,
      endOfTurnPhaseAdvanceTurn,
      endOfTurnPhaseEnd,
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

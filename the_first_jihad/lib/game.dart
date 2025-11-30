import 'dart:convert';
import 'dart:math';
import 'package:the_first_jihad/db.dart';
import 'package:the_first_jihad/random.dart';

enum Location {
  landMecca,
  landDamascus,
  landJerusalem,
  landCilicia,
  landAnatolia,
  landConstantinople,
  landGreece,
  landRome,
  landAlexandria,
  landLibya,
  landSufetula,
  landCarthage,
  landTingitana,
  landHispania,
  landAquitaine,
  landParis,
  landUpperEgypt,
  landNobatia,
  landMakouria,
  landAlodia,
  landAdulis,
  landAxum,
  landKhuzestan,
  landYezd,
  landSeistan,
  landSindh,
  landMulasthana,
  landRajasthan,
  landKannauj,
  landCtesiphon,
  landNehavend,
  landEsfahan,
  landKhorasan,
  landTransoxiana,
  landFerganaValley,
  landKushinne,
  landNsibis,
  landVaspurakan,
  landArmenia,
  landAghvank,
  landBalanjar,
  landKhazaria,
  boxGreekPath,
  boxMediterraneanPath,
  boxAfricanPath,
  boxIndianPath,
  boxParthianPath,
  boxCaucasianPath,
  boxBerberRevolt,
  boxMuslimNavy,
  boxCasbah,
  boxOutOfPlay,
  boxBlessingsAvailable,
  boxBlessingsUsed,
  boxJihad,
  boxBulgarsN1,
  boxBulgarsZ,
  boxBulgarsP1,
  boxCyprusN1,
  boxCyprusZ,
  boxCyprusP1,
  boxSocotraN1,
  boxSocotraZ,
  boxSocotraP1,
  boxTibetN1,
  boxTibetZ,
  boxTibetP1,
  boxZabulistan,
  boxTradeRouteNile,
  boxTradeRouteSocotra,
  boxTradeRouteSilk,
  boxShariaLaw,
  boxByzantineReligionCatholic,
  boxByzantineReligionOrthodox,
  boxByzantineReligionMonophysite,
  boxWest0,
  boxWest1,
  boxWest2,
  boxWest3,
  boxWest4,
  boxWest5,
  boxWest6,
  boxWest7,
  boxEast0,
  boxEast1,
  boxEast2,
  boxEast3,
  boxEast4,
  boxEast5,
  boxEast6,
  boxEast7,
  boxShared0,
  boxShared1,
  boxShared2,
  boxShared3,
  boxShared4,
  boxShared5,
  boxShared6,
  boxShared7,
  boxByzantineLastStand,
  boxPersianLastStand,
  boxExcubitors,
  flipped,
  offmap,
}

enum LocationType {
  land,
  pathLand,
  pathGreek,
  pathMediterranean,
  pathAfrican,
  pathIndian,
  pathParthian,
  pathCaucasian,
  pathBox,
  westSkillBox,
  eastSkillBox,
  sharedSkillBox,
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

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.land: [Location.landMecca, Location.landKhazaria],
    LocationType.pathLand: [Location.landDamascus, Location.landKhazaria],
    LocationType.pathGreek: [Location.landDamascus, Location.landRome],
    LocationType.pathMediterranean: [Location.landAlexandria, Location.landParis],
    LocationType.pathAfrican: [Location.landUpperEgypt, Location.landAxum],
    LocationType.pathIndian: [Location.landKhuzestan, Location.landKannauj],
    LocationType.pathParthian: [Location.landCtesiphon, Location.landKushinne],
    LocationType.pathCaucasian: [Location.landNsibis, Location.landKhazaria],
    LocationType.pathBox: [Location.boxGreekPath, Location.boxCaucasianPath],
    LocationType.westSkillBox: [Location.boxWest0, Location.boxWest7],
    LocationType.eastSkillBox: [Location.boxEast0, Location.boxEast7],
    LocationType.sharedSkillBox: [Location.boxShared0, Location.boxShared7],
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
  armyByzantineGreek,
  armyByzantineMediterranean,
  armyExarchate,
  armyBerber,
  armyVisigoth,
  armyFrankish,
  armyByzantineAfrican,
  armyNubian,
  armyAxum,
  armyPersianIndian,
  armyPratihara,
  armyPersianParthian,
  armySogdian,
  armyTurgesh,
  armyChinese,
  armyByzantineCaucasian,
  armyArmenian,
  armyKhazar,
  castleByzantineMajor0,
  castleByzantineMajor1,
  castleByzantineMinor0,
  castleByzantineMinor1,
  castleByzantineMinor2,
  castleByzantineMinor3,
  castlePersianMinor0,
  castlePersianMinor1,
  capitalByzantineStrong,
  capitalByzantineWeak,
  capitalPersianStrong,
  capitalPersianWeak,
  blessingFleetP1,
  blessingFleetP3,
  blessingImmortalsP1,
  blessingImmortalsP2,
  blessingIcons,
  blessingThemes,
  islamGreek,
  islamMediterranean,
  islamAfrican,
  islamIndian,
  islamParthian,
  islamCaucasian,
  islamGreekDisrupted,
  islamMediterraneanDisrupted,
  islamAfricanDisrupted,
  islamIndianDisrupted,
  islamParthianDisrupted,
  islamCaucasianDisrupted,
  mujahideenSyrians,
  mujahideenTribal,
  meccaStrong,
  meccaWeak,
  baqtAfricanFull,
  baqtCaucasianFull,
  baqtAfricanPartial,
  baqtCaucasianPartial,
  jewsP1,
  jewsN1,
  refugeesManichees,
  refugeesParsees,
  refugeesMardaites,
  christianDamascus,
  capitalIslamic,
  kaaba3,
  kaaba4,
  kaaba5,
  kaaba6,
  kaaba7,
  kaaba8,
  arabStop,
  excubitors1,
  excubitors2,
  musmlimNavyActive,
  muslimNavyNone,
  bulgarsDocile,
  bulgarsWild,
  cyprusGreek,
  cyprusMediterranean,
  socotraAfrican,
  socotraIndian,
  tibetBuddhist,
  tibetBadass,
  zabulistanDefiant,
  zabulistanSubdued,
  tradeRouteClosedNile,
  tradeRouteClosedSocotra,
  tradeRouteClosedSilk,
  noShariaLaw,
  byzantineReligion,
  byzantineReligionSchism,
  rulerByzantine,
  rulerByzantineTruce,
  rulerPersian,
  rulerPersianTruce,
  westAP,
  westAPDivided,
  eastAP,
  eastAPDivided,
  africaAP,
  caucasusAP,
  westAPToken,
  eastAPToken,
  sharedAPToken,
  byzantineLastStandSkill,
  byzantineLastStandAP,
  persianLastStandSkill,
  persianLastStandAP,
  greatKingAfrican,
  greatKingCaucasian,
  jihadAlternating,
  jihadOnePath,
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
  mapPiece,
  army,
  armyGreekPath,
  armyMediterraneanPath,
  armyAfricanPath,
  armyIndianPath,
  armyParthianPath,
  armyCaucasianPath,
  castle,
  castleByzantineMajor,
  castleByzantineMinor,
  capital,
  blessing,
  islam,
  islamUndisrupted,
  islamDisrupted,
  mujahideen,
  mecca,
  baqt,
  baqtFull,
  baqtPartial,
  jews,
  refugees,
  kaaba,
  muslimNavy,
  bulgars,
  cyprus,
  socotra,
  tibet,
  zabulistan,
  byzantineReligion,
  rulerByzantine,
  rulerPersian,
  westAP,
  eastAP,
  byzantineLastStand,
  persianLastStand,
  greatKing,
  jihad,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.armyByzantineGreek, Piece.jihadOnePath],
    PieceType.mapPiece: [Piece.armyByzantineGreek, Piece.arabStop],
    PieceType.army: [Piece.armyByzantineGreek, Piece.armyKhazar],
    PieceType.armyGreekPath: [Piece.armyByzantineGreek, Piece.armyByzantineGreek],
    PieceType.armyMediterraneanPath: [Piece.armyByzantineMediterranean, Piece.armyFrankish],
    PieceType.armyAfricanPath: [Piece.armyByzantineAfrican, Piece.armyAxum],
    PieceType.armyIndianPath: [Piece.armyPersianIndian, Piece.armyPratihara],
    PieceType.armyParthianPath: [Piece.armyPersianParthian, Piece.armyChinese],
    PieceType.armyCaucasianPath: [Piece.armyByzantineCaucasian, Piece.armyKhazar],
    PieceType.castle: [Piece.castleByzantineMajor0, Piece.castlePersianMinor1],
    PieceType.castleByzantineMajor: [Piece.castleByzantineMajor0, Piece.castleByzantineMajor1],
    PieceType.castleByzantineMinor: [Piece.castleByzantineMinor0, Piece.castleByzantineMinor3],
    PieceType.capital: [Piece.capitalByzantineStrong, Piece.capitalPersianWeak],
    PieceType.blessing: [Piece.blessingFleetP1, Piece.blessingThemes],
    PieceType.islam: [Piece.islamGreek, Piece.islamCaucasianDisrupted],
    PieceType.islamUndisrupted: [Piece.islamGreek, Piece.islamCaucasian],
    PieceType.islamDisrupted: [Piece.islamGreekDisrupted, Piece.islamCaucasianDisrupted],
    PieceType.mujahideen: [Piece.mujahideenSyrians, Piece.mujahideenTribal],
    PieceType.mecca: [Piece.meccaStrong, Piece.meccaWeak],
    PieceType.baqt: [Piece.baqtAfricanFull, Piece.baqtCaucasianPartial],
    PieceType.baqtFull: [Piece.baqtAfricanFull, Piece.baqtCaucasianFull],
    PieceType.baqtPartial: [Piece.baqtAfricanPartial, Piece.baqtCaucasianPartial],
    PieceType.jews: [Piece.jewsP1, Piece.jewsN1],
    PieceType.refugees: [Piece.refugeesManichees, Piece.refugeesParsees],
    PieceType.muslimNavy: [Piece.musmlimNavyActive, Piece.muslimNavyNone],
    PieceType.bulgars: [Piece.bulgarsDocile, Piece.bulgarsWild],
    PieceType.cyprus: [Piece.cyprusGreek, Piece.cyprusMediterranean],
    PieceType.socotra: [Piece.socotraAfrican, Piece.socotraIndian],
    PieceType.tibet: [Piece.tibetBuddhist, Piece.tibetBadass],
    PieceType.zabulistan: [Piece.zabulistanDefiant, Piece.zabulistanSubdued],
    PieceType.byzantineReligion: [Piece.byzantineReligion, Piece.byzantineReligionSchism],
    PieceType.rulerByzantine: [Piece.rulerByzantine, Piece.rulerByzantineTruce],
    PieceType.rulerPersian: [Piece.rulerPersian, Piece.rulerPersianTruce],
    PieceType.westAP: [Piece.westAP, Piece.westAPDivided],
    PieceType.eastAP: [Piece.eastAP, Piece.eastAPDivided],
    PieceType.byzantineLastStand: [Piece.byzantineLastStandSkill, Piece.byzantineLastStandAP],
    PieceType.persianLastStand: [Piece.persianLastStandSkill, Piece.persianLastStandAP],
    PieceType.greatKing: [Piece.greatKingAfrican, Piece.greatKingCaucasian],
    PieceType.jihad: [Piece.jihadAlternating, Piece.jihadOnePath],
    PieceType.kaaba: [Piece.kaaba3, Piece.kaaba8],
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

enum Path {
  greek,
  mediterranean,
  african,
  indian,
  parthian,
  caucasian,
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
    const pathDescs = {
      Path.greek: 'Greek',
      Path.mediterranean: 'Mediterranean',
      Path.african: 'African',
      Path.indian: 'Indian',
      Path.parthian: 'Parthian',
      Path.caucasian: 'Caucasian',
    };
    return pathDescs[this]!;
  }
}

enum Theater {
  western,
  african,
  eastern,
  caucasian,
}

enum Control {
  player,
  neutral,
  arab,
}

enum Country {
  byzantine,
  persian,
  exarchate,
  berber,
  visigoth,
  frankish,
  pratihara,
  sogdian,
  turgesh,
  chinese,
  nubian,
  axum,
  armenian,
  khazar,
}

enum Religion {
  christianArian,
  christianCatholic,
  christianMonophysite,
  christianNestorian,
  christianOrthodox,
  buddhist,
  chinese,
  hindu,
  zoroastrian,
  khazarPaganJewish,
  tengristPagan,
  islamic,
}

extension ReligionExtension on Religion {
  String get adjective {
    const adjectives = {
      Religion.christianArian: 'Arian',
      Religion.christianCatholic: 'Catholic',
      Religion.christianMonophysite: 'Monophysite',
      Religion.christianNestorian: 'Nestorian',
      Religion.christianOrthodox: 'Orthodox',
      Religion.buddhist: 'Buddhist',
      Religion.chinese: 'Chinese',
      Religion.hindu: 'Hindu',
      Religion.zoroastrian: 'Zoroastrian',
      Religion.khazarPaganJewish: 'Pagan/Jewish',
      Religion.tengristPagan: 'Pagan',
      Religion.islamic: 'Islamic',
    };
    return adjectives[this]!;
  }
  String get noun {
    const nouns = {
      Religion.christianCatholic: 'Catholicism',
      Religion.christianMonophysite: 'Monophysitism',
      Religion.christianOrthodox: 'Orthodoxy',
    };
    return nouns[this]!;
  }
}

enum Crossing {
  ordinary,
  straits,
  river,
  mountain,
}

enum TradeRoute {
  nile,
  socotra,
  silk,
  pontic,
}

enum ArmyStatus {
  strong,
  weak,
  shattered,
}

extension ArmyStatusExtension on ArmyStatus {
  String get desc {
    const armyStatusDescs = {
      ArmyStatus.strong: 'Strong',
      ArmyStatus.weak: 'Weak',
      ArmyStatus.shattered: 'Shattered',
    };
    return armyStatusDescs[this]!;
  }
}

List<ArmyStatus> armyStatusListFromIndices(List<int> indices) {
  final armyStatuses = <ArmyStatus>[];
  for (final index in indices) {
    armyStatuses.add(ArmyStatus.values[index]);
  }
  return armyStatuses;
}

List<int> armyStatusListToIndices(List<ArmyStatus> armyStatuses) {
  final indices = <int>[];
  for (final armyStatus in armyStatuses) {
    indices.add(armyStatus.index);
  }
  return indices;
}

enum Card {
  chainedAndNailedByFear1,
  farewellSyria2,
  aMountainOfFire3,
  noCountrySoDefenseless4,
  aJewishNationalHome5,
  isItGodWhoCommandsYouToMurder6,
  anAllianceWithHell7,
  allahDothBlotOut8,
  revoltOfTheExarchGregory9,
  arabsInvadeCyprus10,
  kalidurutSignsTheBaqt11,
  theBattleOfTheCamel12,
  theUmayyadCaliphate13,
  milkThePersians14,
  itIsTheEndOfTheWorld15,
  theTheodosianWalls16,
  greekFire17,
  theFourGarrisonsOfTheOccupiedWest18,
  thePeaksOfLebanon19,
  councilOfConstantinople20,
  asparukhKhanOfTheBulgars21,
  alpTarkhanKhazarRuler22,
  theBattleOfKarbala23,
  theDomeOfTheRock24,
  revoltOfTheZanjiSlaves25,
  aWarOverCoins26,
  blacksAsInnumerableAsAnts27,
  kahinaQueenOfTheMoors28,
  mercuriosKingOfNubia29,
  armeniaBetrayed30,
  piroozRevolts31,
  theArmyOfPeacocks32,
  treacherousCountJulian33,
  iSeeHeadsReadyToBeCutOff34,
  suluKhanOfTheTurgesh35,
  egyptianSailorsMutiny36,
  shameAndDegradation37,
  theMiseryOfDhimmitude38,
  payTheJizya39,
  iconoclasm40,
  khazarPrinceBarjik41,
  munnuzaHeartLampegia42,
  charlesMartel43,
  revoltOfTheMurjiah44,
  fromoKesaro45,
  theGreatBerberRevolt46,
  theReligionOfTheIsraelitesIsBetter47,
  cyriacusKingOfNubia48,
  theBattleOfTheZab49,
  iAmTheDestroyingAvenger50,
}

Card? cardFromIndex(int? index) {
  if (index != null) {
    return Card.values[index];
  } else {
    return null;
  }
}

int? cardToIndex(Card? card) {
  return card?.index;
}

List<Card> cardListFromIndices(List<int> indices) {
  final cards = <Card>[];
  for (final index in indices) {
    cards.add(Card.values[index]);
  }
  return cards;
}

List<int> cardListToIndices(List<Card> cards) {
  final indices = <int>[];
  for (final card in cards) {
    indices.add(card.index);
  }
  return indices;
}

enum CardType {
  eraGreen,
  eraYellow,
  eraRed,
  eraBlack,
}

extension CardTypeExtension on CardType {
  static const _bounds = {
    CardType.eraGreen: [Card.chainedAndNailedByFear1, Card.theBattleOfTheCamel12],
    CardType.eraYellow: [Card.theUmayyadCaliphate13, Card.theDomeOfTheRock24],
    CardType.eraRed: [Card.revoltOfTheZanjiSlaves25, Card.egyptianSailorsMutiny36],
    CardType.eraBlack: [Card.shameAndDegradation37, Card.iAmTheDestroyingAvenger50],
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

enum Event {
  baqtAfrican,
  baqtCaucasian,
  caliphUmarI,
  carolingians,
  empressWu,
  greatKingAfrican,
  greatKingCaucasian,
  imperialVisit,
  karabisianTheme,
  munnuzaDefects,
  piroozRevolts,
  queenKahina,
  ridda,
  sclaviniae,
  shariaLaw,
  truceGreek,
  trucePersian,
}

enum Scenario {
  standard,
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<ArmyStatus> _armyStatuses = List<ArmyStatus>.filled(PieceType.army.count, ArmyStatus.weak);
  List<bool> _armyCurseds = List<bool>.filled(PieceType.army.count, false);
  List<bool> _castleBesiegeds = List<bool>.filled(PieceType.castle.count, false);
  List<bool> _eventActives = List<bool>.filled(Event.values.length, false);
  List<Card> _deck = <Card>[];
  int _byzantineNewRulerCount = 0;
  int _persianNewRulerCount = 0;
  bool _berbersCatholic = false;

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
    : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
    , _armyStatuses = armyStatusListFromIndices(List<int>.from(json['armyStatuses']))
    , _armyCurseds = List<bool>.from(json['armyCurseds'])
    , _castleBesiegeds = List<bool>.from(json['castleBesiegeds'])
    , _eventActives = List<bool>.from(json['eventActives'])
    , _deck = cardListFromIndices(List<int>.from(json['deck']))
    , _byzantineNewRulerCount = json['byzantineNewRulerCount'] as int
    , _persianNewRulerCount = json['persianNewRulerCount'] as int
    , _berbersCatholic = json['berbersCatholic'] as bool
    ;

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'armyStatuses': armyStatusListToIndices(_armyStatuses),
    'armyCurseds': _armyCurseds,
    'castleBesiegeds': _castleBesiegeds,
    'eventActives': _eventActives,
    'deck': cardListToIndices(_deck),
    'byzantineNewRulerCount': _byzantineNewRulerCount,
    'persianNewRulerCount': _persianNewRulerCount,
    'berbersCatholic': _berbersCatholic,
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.castleByzantineMajor0: Piece.castleByzantineMinor0,
      Piece.castleByzantineMajor1: Piece.castleByzantineMinor1,
      Piece.castleByzantineMinor0: Piece.castleByzantineMajor0,
      Piece.castleByzantineMinor1: Piece.castleByzantineMajor1,
      Piece.castleByzantineMinor2: Piece.castlePersianMinor0,
      Piece.castleByzantineMinor3: Piece.castlePersianMinor1,
      Piece.castlePersianMinor0: Piece.castleByzantineMinor2,
      Piece.castlePersianMinor1: Piece.castleByzantineMinor3,
      Piece.capitalByzantineStrong: Piece.capitalByzantineWeak,
      Piece.capitalByzantineWeak: Piece.capitalByzantineStrong,
      Piece.capitalPersianStrong: Piece.capitalPersianWeak,
      Piece.capitalPersianWeak: Piece.capitalPersianStrong,
      Piece.blessingFleetP1: Piece.blessingFleetP3,
      Piece.blessingFleetP3: Piece.blessingFleetP1,
      Piece.blessingImmortalsP1: Piece.blessingImmortalsP2,
      Piece.blessingImmortalsP2: Piece.blessingImmortalsP1,
      Piece.blessingIcons: Piece.blessingThemes,
      Piece.blessingThemes: Piece.blessingIcons,
      Piece.islamGreek: Piece.islamGreekDisrupted,
      Piece.islamMediterranean: Piece.islamMediterraneanDisrupted,
      Piece.islamAfrican: Piece.islamAfricanDisrupted,
      Piece.islamIndian: Piece.islamIndianDisrupted,
      Piece.islamParthian: Piece.islamParthianDisrupted,
      Piece.islamCaucasian: Piece.islamCaucasianDisrupted,
      Piece.islamGreekDisrupted: Piece.islamGreek,
      Piece.islamMediterraneanDisrupted: Piece.islamMediterranean,
      Piece.islamAfricanDisrupted: Piece.islamAfrican,
      Piece.islamIndianDisrupted: Piece.islamIndian,
      Piece.islamParthianDisrupted: Piece.islamParthian,
      Piece.islamCaucasianDisrupted: Piece.islamCaucasian,
      Piece.mujahideenSyrians: Piece.mujahideenTribal,
      Piece.mujahideenTribal: Piece.mujahideenSyrians,
      Piece.meccaStrong: Piece.meccaWeak,
      Piece.meccaWeak: Piece.meccaStrong,
      Piece.baqtAfricanFull: Piece.baqtAfricanPartial,
      Piece.baqtCaucasianFull: Piece.baqtCaucasianPartial,
      Piece.baqtAfricanPartial: Piece.baqtAfricanFull,
      Piece.baqtCaucasianPartial: Piece.baqtCaucasianFull,
      Piece.jewsP1: Piece.jewsN1,
      Piece.jewsN1: Piece.jewsP1,
      Piece.excubitors1: Piece.excubitors2,
      Piece.excubitors2: Piece.excubitors1,
      Piece.christianDamascus: Piece.capitalIslamic,
      Piece.capitalIslamic: Piece.christianDamascus,
      Piece.musmlimNavyActive: Piece.muslimNavyNone,
      Piece.muslimNavyNone: Piece.musmlimNavyActive,
      Piece.bulgarsDocile: Piece.bulgarsWild,
      Piece.bulgarsWild: Piece.bulgarsDocile,
      Piece.cyprusGreek: Piece.cyprusMediterranean,
      Piece.cyprusMediterranean: Piece.cyprusGreek,
      Piece.socotraAfrican: Piece.socotraIndian,
      Piece.socotraIndian: Piece.socotraAfrican,
      Piece.tibetBuddhist: Piece.tibetBadass,
      Piece.tibetBadass: Piece.tibetBuddhist,
      Piece.zabulistanDefiant: Piece.zabulistanSubdued,
      Piece.zabulistanSubdued: Piece.zabulistanDefiant,
      Piece.byzantineReligion: Piece.byzantineReligionSchism,
      Piece.byzantineReligionSchism: Piece.byzantineReligion,
      Piece.rulerByzantine: Piece.rulerByzantineTruce,
      Piece.rulerByzantineTruce: Piece.rulerByzantine,
      Piece.rulerPersian: Piece.rulerPersianTruce,
      Piece.rulerPersianTruce: Piece.rulerPersian,
      Piece.westAP: Piece.westAPDivided,
      Piece.westAPDivided: Piece.westAP,
      Piece.eastAP: Piece.eastAPDivided,
      Piece.eastAPDivided: Piece.eastAP,
      Piece.greatKingAfrican: Piece.greatKingCaucasian,
      Piece.greatKingCaucasian: Piece.greatKingAfrican,
      Piece.jihadAlternating: Piece.jihadOnePath,
      Piece.jihadOnePath: Piece.jihadAlternating,
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

  bool pieceInPlay(Piece piece) {
    final location = pieceLocation(piece);
    return ![Location.boxOutOfPlay, Location.flipped, Location.offmap].contains(location);
  }

  bool pieceInPlayOrFlipped(Piece piece) {
    final location = pieceLocation(piece);
    return ![Location.boxOutOfPlay, Location.offmap].contains(location);
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

  bool landIsEndsOfTheEarth(Location land) {
    const endsOfTheEarth = [
      Location.landParis,
      Location.landAxum,
      Location.landKannauj,
      Location.landKushinne,
      Location.landKhazaria,
    ];
    return endsOfTheEarth.contains(land);
  }

  Crossing landCrossing(Location land) {
    const landCrossings = {
      Location.landMecca: Crossing.ordinary,
      Location.landDamascus: Crossing.ordinary,
      Location.landJerusalem: Crossing.ordinary,
      Location.landCilicia: Crossing.ordinary,
      Location.landAnatolia: Crossing.mountain,
      Location.landConstantinople: Crossing.straits,
      Location.landGreece: Crossing.straits,
      Location.landRome: Crossing.straits,
      Location.landAlexandria: Crossing.ordinary,
      Location.landLibya: Crossing.ordinary,
      Location.landSufetula: Crossing.ordinary,
      Location.landCarthage: Crossing.ordinary,
      Location.landTingitana: Crossing.mountain,
      Location.landHispania: Crossing.straits,
      Location.landAquitaine: Crossing.mountain,
      Location.landParis: Crossing.ordinary,
      Location.landUpperEgypt: Crossing.ordinary,
      Location.landNobatia: Crossing.ordinary,
      Location.landMakouria: Crossing.mountain,
      Location.landAlodia: Crossing.ordinary,
      Location.landAdulis: Crossing.ordinary,
      Location.landAxum: Crossing.mountain,
      Location.landKhuzestan: Crossing.ordinary,
      Location.landYezd: Crossing.mountain,
      Location.landSeistan: Crossing.ordinary,
      Location.landSindh: Crossing.mountain,
      Location.landMulasthana: Crossing.river,
      Location.landRajasthan: Crossing.ordinary,
      Location.landKannauj: Crossing.ordinary,
      Location.landCtesiphon: Crossing.ordinary,
      Location.landNehavend: Crossing.mountain,
      Location.landEsfahan: Crossing.ordinary,
      Location.landKhorasan: Crossing.ordinary,
      Location.landTransoxiana: Crossing.river,
      Location.landFerganaValley: Crossing.mountain,
      Location.landKushinne: Crossing.ordinary,
      Location.landNsibis: Crossing.ordinary,
      Location.landVaspurakan: Crossing.ordinary,
      Location.landArmenia: Crossing.ordinary,
      Location.landAghvank: Crossing.ordinary,
      Location.landBalanjar: Crossing.mountain,
      Location.landKhazaria: Crossing.ordinary,
    };
    return landCrossings[land]!;
  }

  bool landIslamicCapital(Location land) {
    if (land == Location.landMecca) {
        return true;
    }
    if (land == pieceLocation(Piece.capitalIslamic)) {
        return true;
    }
    return false;
  }

  Control landControl(Location land) {
    if (landIslamicCapital(land)) {
      return Control.arab;
    }
    final path = landPath(land)!;
    final locationType = pathLocationType(path);
    var control = Control.arab;
    for (final otherLand in locationType.locations) {
      int armyCount = piecesInLocationCount(PieceType.army, otherLand);
      for (int i = 0; i < armyCount; ++i) {
        if (control == Control.arab) {
            control = Control.player;
        } else {
            return Control.neutral;
        }
      }
    }
    return control;
  }

  bool landIslamic(Location land, bool islamicIfDisrupted) {
    if (landIslamicCapital(land)) {
      return true;
    }
    final path = landPath(land)!;
    final lastMuslimLand = pathIslamExtent(path);
    if (land != lastMuslimLand) {
        return land.index < lastMuslimLand.index;
    }
    if (islamicIfDisrupted) {
        return true;
    }
    return !pathIslamDisrupted(path);
  }

  Religion landBaseReligion(Location land) {
    const religions = {
      Location.landMecca: Religion.islamic,
      Location.landDamascus: Religion.christianMonophysite,
      Location.landJerusalem: Religion.christianOrthodox,
      Location.landCilicia: Religion.christianMonophysite,
      Location.landAnatolia: Religion.christianOrthodox,
      Location.landConstantinople: Religion.christianOrthodox,
      Location.landGreece: Religion.christianOrthodox,
      Location.landRome: Religion.christianCatholic,
      Location.landAlexandria: Religion.christianMonophysite,
      Location.landLibya: Religion.christianMonophysite,
      Location.landSufetula: Religion.christianCatholic,
      Location.landCarthage: Religion.christianCatholic,
      Location.landTingitana: Religion.christianCatholic,
      Location.landHispania: Religion.christianCatholic,
      Location.landAquitaine: Religion.christianCatholic,
      Location.landParis: Religion.christianCatholic,
      Location.landUpperEgypt: Religion.christianMonophysite,
      Location.landNobatia: Religion.christianMonophysite,
      Location.landMakouria: Religion.christianOrthodox,
      Location.landAlodia: Religion.christianMonophysite,
      Location.landAdulis: Religion.christianMonophysite,
      Location.landAxum: Religion.christianMonophysite,
      Location.landKhuzestan: Religion.christianNestorian,
      Location.landYezd: Religion.zoroastrian,
      Location.landSeistan: Religion.zoroastrian,
      Location.landSindh: Religion.buddhist,
      Location.landMulasthana: Religion.hindu,
      Location.landRajasthan: Religion.hindu,
      Location.landKannauj: Religion.hindu,
      Location.landCtesiphon: Religion.christianNestorian,
      Location.landNehavend: Religion.zoroastrian,
      Location.landEsfahan: Religion.zoroastrian,
      Location.landKhorasan: Religion.zoroastrian,
      Location.landTransoxiana: Religion.zoroastrian,
      Location.landFerganaValley: Religion.christianNestorian,
      Location.landKushinne: Religion.buddhist,
      Location.landNsibis: Religion.christianNestorian,
      Location.landVaspurakan: Religion.christianMonophysite,
      Location.landArmenia: Religion.christianMonophysite,
      Location.landAghvank: Religion.christianMonophysite,
      Location.landBalanjar: Religion.christianOrthodox,
      Location.landKhazaria: Religion.khazarPaganJewish,
    };
    return religions[land]!;
  }

  Religion landReligion(Location land, bool islamicIfDisrupted) {
    if (landIslamic(land, islamicIfDisrupted)) {
      return Religion.islamic;
    }
    return landBaseReligion(land);
  }

  int landApostasyNumber(Location land) {
    const apostasyNumbers = {
      Location.landMecca: 6,
      Location.landDamascus: 3,
      Location.landJerusalem: 2,
      Location.landCilicia: 2,
      Location.landAnatolia: 1,
      Location.landConstantinople: 1,
      Location.landGreece: 1,
      Location.landRome: 0,
      Location.landAlexandria: 2,
      Location.landLibya: 2,
      Location.landSufetula: 3,
      Location.landCarthage: 3,
      Location.landTingitana: 4,
      Location.landHispania: 2,
      Location.landAquitaine: 1,
      Location.landParis: 0,
      Location.landUpperEgypt: 2,
      Location.landNobatia: 1,
      Location.landMakouria: 2,
      Location.landAlodia: 4,
      Location.landAdulis: 1,
      Location.landAxum: 0,
      Location.landKhuzestan: 2,
      Location.landYezd: 1,
      Location.landSeistan: 3,
      Location.landSindh: 3,
      Location.landMulasthana: 1,
      Location.landRajasthan: 1,
      Location.landKannauj: 0,
      Location.landCtesiphon: 3,
      Location.landNehavend: 2,
      Location.landEsfahan: 3,
      Location.landKhorasan: 3,
      Location.landTransoxiana: 1,
      Location.landFerganaValley: 1,
      Location.landKushinne: 0,
      Location.landNsibis: 3,
      Location.landVaspurakan: 1,
      Location.landArmenia: 1,
      Location.landAghvank: 2,
      Location.landBalanjar: 1,
      Location.landKhazaria: 0,
    };
    return apostasyNumbers[land]!;
  }

  bool landBesieged(Location land) {
    final castle = pieceInLocation(PieceType.castle, land);
    if (castle == null) {
      return false;
    }
    return castleBesieged(castle);
  }

  // Mecca

  bool get meccaStrong {
    return pieceLocation(Piece.meccaStrong) != Location.flipped;
  }

  // Skill Boxes

  Location westSkillBox(int value) {
    return Location.values[LocationType.westSkillBox.firstIndex + value];
  }

  Location eastSkillBox(int value) {
    return Location.values[LocationType.eastSkillBox.firstIndex + value];
  }

  Location sharedSkillBox(int value) {
    return Location.values[LocationType.sharedSkillBox.firstIndex + value];
  }

  int skillBoxValue(Location box) {
    if (box.isType(LocationType.westSkillBox)) {
      return box.index - LocationType.westSkillBox.firstIndex;
    }
    if (box.isType(LocationType.eastSkillBox)) {
      return box.index - LocationType.eastSkillBox.firstIndex;
    }
    if (box.isType(LocationType.sharedSkillBox)) {
      return box.index - LocationType.sharedSkillBox.firstIndex;
    }
    return 0;
  }

  // Paths

  Theater pathTheater(Path path) {
    switch (path) {
    case Path.greek:
    case Path.mediterranean:
        return Theater.western;
    case Path.african:
        return Theater.african;
    case Path.indian:
    case Path.parthian:
        return Theater.eastern;
    case Path.caucasian:
        return Theater.caucasian;
    }
  }

  LocationType pathLocationType(Path path) {
    const pathLocationTypes = [
      LocationType.pathGreek,
      LocationType.pathMediterranean,
      LocationType.pathAfrican,
      LocationType.pathIndian,
      LocationType.pathParthian,
      LocationType.pathCaucasian,
    ];
    return pathLocationTypes[path.index];
  }

  PieceType pathArmyType(Path path) {
    const pathLocationTypes = [
      PieceType.armyGreekPath,
      PieceType.armyMediterraneanPath,
      PieceType.armyAfricanPath,
      PieceType.armyIndianPath,
      PieceType.armyParthianPath,
      PieceType.armyCaucasianPath,
    ];
    return pathLocationTypes[path.index];
  }

  Location pathBox(Path path) {
    return Location.values[LocationType.pathBox.firstIndex + path.index];
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
    if (land == Location.landMecca) {
      return null;
    }
    final locationType = pathLocationType(path);
    int sequence = land.index - locationType.firstIndex;
    if (sequence == 0) {
      return Location.landMecca;
    }
    sequence -= 1;
    final precedingLand = pathLand(path, sequence);
    return precedingLand;
  }

  Location? pathSucceedingLand(Path path, Location land) {
    if (landIsEndsOfTheEarth(land)) {
      return null;
    }
    if (land == Location.landRome) {
      return null;
    }
    final locationType = pathLocationType(path);
    int sequence = land.index - locationType.firstIndex;
    sequence += 1;
    final succeedingLand = pathLand(path, sequence);
    return succeedingLand;
  }

  Piece pathFullBaqt(Path path) {
    return path == Path.african ? Piece.baqtAfricanFull : Piece.baqtCaucasianFull;
  }

  Piece pathPartialBaqt(Path path) {
    return path == Path.african ? Piece.baqtAfricanPartial : Piece.baqtCaucasianPartial;
  }

  Piece? pathBaqt(Path path) {
    var baqt = pathFullBaqt(path);
    if (pieceLocation(baqt) == Location.flipped) {
      baqt = pathPartialBaqt(path);
    }
    if (pieceLocation(baqt) != Location.offmap) {
      return baqt;
    }
    return null;
  }

  Location pathBaqtLand(Path path, int flagCount) {
    final oneFlagLand = path == Path.african ? Location.landNobatia : Location.landVaspurakan;
    return Location.values[oneFlagLand.index + flagCount - 1];
  }

  Piece pathIslamUndisruptedPiece(Path path) {
    return Piece.values[PieceType.islamUndisrupted.firstIndex + path.index];
  }

  Piece pathIslamDisruptedPiece(Path path) {
    return Piece.values[PieceType.islamDisrupted.firstIndex + path.index];
  }

  Piece pathIslamPiece(Path path) {
    final undisruptedPiece = pathIslamUndisruptedPiece(path);
    if (pieceLocation(undisruptedPiece) != Location.flipped) {
      return undisruptedPiece;
    }
    return pathIslamDisruptedPiece(path);
  }

  Location pathIslamExtent(Path path) {
    final piece = pathIslamPiece(path);
    return pieceLocation(piece);
  }

  bool pathIslamDisrupted(Path path) {
    final piece = pathIslamDisruptedPiece(path);
    return pieceLocation(piece) != Location.flipped;
  }

  Piece? pathActiveArmy(Path path) {
    final locationType = pathLocationType(path);
    final armyType = pathArmyType(path);
    Location? activeLand;
    Piece? activeArmy;
    for (final army in armyType.pieces) {
      final location = pieceLocation(army);
      if (location.isType(locationType)) {
        if (activeLand == null || location.index < activeLand.index) {
          activeLand = location;
          activeArmy = army;
        } else if (location.index == activeLand.index) {
          if (army.index < activeArmy!.index) {
            activeArmy = army;
          }
        }
      }
    }
    return activeArmy;
  }

  bool pathHasByzantineArmy(Path path) {
    Piece? army;
    switch (path) {
    case Path.greek:
      army = Piece.armyByzantineGreek;
    case Path.mediterranean:
      army = Piece.armyByzantineMediterranean;
    case Path.african:
      army = Piece.armyByzantineAfrican;
    case Path.caucasian:
      army = Piece.armyByzantineCaucasian;
    default:
    }
    if (army == null) {
      return false;
    }
    return pieceLocation(army).isType(LocationType.land);
}

  bool pathHasPersianArmy(Path path) {
    Piece? army;
    switch (path) {
    case Path.indian:
      army = Piece.armyPersianIndian;
    case Path.parthian:
      army = Piece.armyPersianParthian;
    default:
    }
    if (army == null) {
      return false;
    }
    return pieceLocation(army).isType(LocationType.land);
  }

  (Piece,Location,Location,bool)? pathInvasionInfo(Path path) {
    final defendingArmy = pathActiveArmy(path);
    if (defendingArmy == null) {
        return null;
    }
    final invadedLand = pieceLocation(defendingArmy);
    final invadingLand = pathPrecedingLand(path, invadedLand)!;
    final invadingLandMuslim = landIslamic(invadingLand, true);
    return (defendingArmy, invadedLand, invadingLand, invadingLandMuslim);
  }

  (Piece, Location, Location, bool) pathAttackInfo(Path path) {
    final invasionInfo = pathInvasionInfo(path);
    if (invasionInfo == null) {
      return null;
    }
    final army = invasionInfo.$1;
    if (armyStatus(army) == ArmyStatus.shattered || armyCursed(army)) {
      return null;
    }
    final attackingLand = invasionInfo.$2;
    var attackedLand = invasionInfo.$3;
    if (landBesieged(attackingLand)) {
      attackedLand = attackingLand;
    }
    if (landIslamicCapital(attackedLand)) {
      return null;
    }
    bool attackedLandDifferentReligion = armyReligious(army) && armyReligion(army) != landReligion(attackedLand, true);
    if (army == Piece.armyBerber) {
      attackedLandDifferentReligion = true;
      if (landIslamic(attackedLand, false) && landBaseReligion(attackedLand) == Religion.christianCatholic) {
        attackedLandDifferentReligion = false;
      }
    }
    return (army, attackingLand, attackedLand, attackedLandDifferentReligion);
}

  int? pathAttackCost(Path path) {
    final attackInfo = pathAttackInfo(path);
    if (attackInfo == null) {
      return null;
    }
    final army = attackInfo.$1;
    if (advancedGame) {
      final militaryHeartland = armyMilitaryHeartland(army);
      if (militaryHeartland != null) {
        if (landIslamic(militaryHeartland, false)) {
          return 2;
        }
      }
    }
    final attackingLand = attackInfo.$2;
    final attackedLand = attackInfo.$3;
    if (attackedLand == attackingLand) {
      return 1;
    }
    switch (landCrossing(attackingLand)) {
    case Crossing.ordinary:
    case Crossing.mountain:
      return 1;
    case Crossing.river:
      return 2;
    case Crossing.straits:
      return 2 + cyprusHits;
    }
  }

  // Theaters

  int theaterAP(Theater theater) {
    switch (theater) {
    case Theater.western:
      return westAP;
    case Theater.african:
      return africaAP;
    case Theater.eastern:
      return eastAP;
    case Theater.caucasian:
      return caucasusAP;
    }
  }

  bool theaterTruce(Theater theater) {
    switch (theater) {
    case Theater.western:
      return byzantiumTruce;
    case Theater.eastern:
      return persiaTruce;
    case Theater.african:
    case Theater.caucasian:
      return false;
    }
  }

  // Armies

  Country armyCountry(Piece army) {
    const armyCountries = {
      Piece.armyByzantineGreek: Country.byzantine,
      Piece.armyByzantineMediterranean: Country.byzantine,
      Piece.armyExarchate: Country.exarchate,
      Piece.armyBerber: Country.berber,
      Piece.armyVisigoth: Country.visigoth,
      Piece.armyFrankish: Country.frankish,
      Piece.armyByzantineAfrican: Country.byzantine,
      Piece.armyNubian: Country.nubian,
      Piece.armyAxum: Country.axum,
      Piece.armyPersianIndian: Country.persian,
      Piece.armyPratihara: Country.pratihara,
      Piece.armyPersianParthian: Country.persian,
      Piece.armySogdian: Country.sogdian,
      Piece.armyTurgesh: Country.turgesh,
      Piece.armyChinese: Country.chinese,
      Piece.armyByzantineCaucasian: Country.byzantine,
      Piece.armyArmenian: Country.armenian,
      Piece.armyKhazar: Country.khazar,
    };
    return armyCountries[army]!;
  }

  ArmyStatus armyStatus(Piece army) {
    return _armyStatuses[army.index - PieceType.army.firstIndex];
  }

  void setArmyStatus(Piece army, ArmyStatus status) {
    _armyStatuses[army.index - PieceType.army.firstIndex] = status;
  }

  bool armyCursed(Piece army) {
    return _armyCurseds[army.index - PieceType.army.firstIndex];
  }

  void setArmyCursed(Piece army, bool cursed) {
    _armyCurseds[army.index - PieceType.army.firstIndex] = cursed;
  }

  void berbersConvertToCatholicism() {
    _berbersCatholic = true;
  }

  Religion armyReligion(Piece army) {
    if (armyCountry(army) == Country.byzantine) {
        return byzantineReligion;
    }
    if (army == Piece.armyBerber) {
      return _berbersCatholic ? Religion.christianCatholic : Religion.islamic;
    }
    const armyReligions = {
      Piece.armyExarchate: Religion.christianCatholic,
      Piece.armyVisigoth: Religion.christianArian,
      Piece.armyFrankish: Religion.christianCatholic,
      Piece.armyNubian: Religion.christianMonophysite,
      Piece.armyAxum: Religion.christianMonophysite,
      Piece.armyPersianIndian: Religion.zoroastrian,
      Piece.armyPratihara: Religion.hindu,
      Piece.armyPersianParthian: Religion.zoroastrian,
      Piece.armySogdian: Religion.zoroastrian,
      Piece.armyTurgesh: Religion.tengristPagan,
      Piece.armyChinese: Religion.chinese,
      Piece.armyArmenian: Religion.christianMonophysite,
      Piece.armyKhazar: Religion.khazarPaganJewish,
    };
    return armyReligions[army]!;
  }

  bool armyReligious(Piece army) {
    const nonReligiousArmies = [
      Piece.armyChinese,
      Piece.armyKhazar,
      Piece.armyTurgesh,
      Piece.armyVisigoth,
    ];
    return !nonReligiousArmies.contains(army);
  }

  Location? armyMilitaryHeartland(Piece army) {
    final country = armyCountry(army);
    if (country == Country.byzantine) {
      return Location.landAnatolia;
    }
    if (country == Country.persian) {
      return Location.landEsfahan;
    }
    return null;
  }

  Location? armyReligiousHeartland(army) {
    final country = armyCountry(army);
    if (country == Country.byzantine) {
      return Location.landConstantinople;
    }
    if (country == Country.persian) {
      return Location.landYezd;
    }
    return null;
  }

  // Castles

  bool castleBesieged(Piece castle) {
    return _castleBesiegeds[castle.index - PieceType.castle.firstIndex];
  }

  void setCastleBesieged(Piece castle, bool besieged) {
    _castleBesiegeds[castle.index - PieceType.castle.firstIndex] = besieged;
  }

  int castleStrength(Piece castle) {
    return castle.isType(PieceType.castleByzantineMajor) ? 4 : 3;
  }

  void castleDestroy(Piece castle) {
    setCastleBesieged(castle, false);
    final replacementCastle = castle.isType(PieceType.castleByzantineMinor) ? castle : pieceFlipSide(castle)!;
    setPieceLocation(replacementCastle, Location.boxOutOfPlay);
  }

  // Capitals

  Piece get byzantineCapitalPiece {
    return (pieceLocation(Piece.capitalByzantineStrong) == Location.flipped) ? Piece.capitalByzantineWeak : Piece.capitalByzantineStrong;
  }

  Piece get persianCapitalPiece {
    return (pieceLocation(Piece.capitalPersianStrong) == Location.flipped) ? Piece.capitalPersianWeak : Piece.capitalPersianStrong;
  }

  void capitalDestroy(Piece capital) {
    final replacementCapital = [Piece.capitalByzantineWeak, Piece.capitalPersianWeak].contains(capital) ? capital : pieceFlipSide(capital)!;
    setPieceLocation(replacementCapital, Location.boxOutOfPlay);
  }

  // Syrians

  int get syrianStrength {
    final kaaba = pieceInLocation(PieceType.kaaba, Location.landMecca);
    if (kaaba == null) {
      return 2;
    }
    return 3 + kaaba.index - PieceType.kaaba.firstIndex;
  }

  void adjustSyrianStrength(int delta) {
    int strength = min(max(syrianStrength + delta, 2), 8);
    final kaaba = pieceInLocation(PieceType.kaaba, Location.landMecca);
    if (kaaba != null) {
      setPieceLocation(kaaba, Location.offmap);
    }
    if (strength >= 3) {
      final newKaaba = Piece.values[PieceType.kaaba.firstIndex + strength - 3];
      setPieceLocation(newKaaba, Location.landMecca);
      if (pieceLocation(Piece.mujahideenSyrians) == Location.flipped) {
        setPieceLocation(Piece.mujahideenSyrians, pieceLocation(Piece.mujahideenTribal));
      }
    } else {
      if (pieceLocation(Piece.mujahideenTribal) == Location.flipped) {
        setPieceLocation(Piece.mujahideenTribal, pieceLocation(Piece.mujahideenSyrians));
      }
    }
  }

  Piece get mujahideenPiece {
    return syrianStrength >= 3 ? Piece.mujahideenSyrians : Piece.mujahideenTribal;
  }

  Path? get syrianPath {
    final location = pieceLocation(mujahideenPiece);
    if (location.isType(LocationType.pathBox)) {
      return Path.values[location.index - LocationType.pathBox.firstIndex];
    }
    return null;
  }

  // Religions

  Religion byzantineReligionBoxReligion(Location box) {
    const religions = {
      Location.boxByzantineReligionCatholic: Religion.christianCatholic,
      Location.boxByzantineReligionOrthodox: Religion.christianOrthodox,
      Location.boxByzantineReligionMonophysite: Religion.christianMonophysite,
    };
    return religions[box]!;
  }

  Religion get byzantineReligion {
    var marker = Piece.byzantineReligion;
    var box = pieceLocation(marker);
    if (box == Location.flipped) {
      marker = Piece.byzantineReligionSchism;
      box = pieceLocation(marker);
    }
    return byzantineReligionBoxReligion(box);
  }

  bool get byzantineSchism {
    return pieceLocation(Piece.byzantineReligionSchism) != Location.flipped;
  }

  set byzantineSchism(bool schism) {
    if (schism) {
      setPieceLocation(Piece.byzantineReligionSchism, pieceLocation(Piece.byzantineReligion));
    } else {
      setPieceLocation(Piece.byzantineReligion, pieceLocation(Piece.byzantineReligionSchism));
    }
  }

  int newRulerSkill(int roll) {
    const table = [ 3, 4, 5, 4, 5, 6, 5, 6, 7, 6, 7];
    int index = min(max(roll, 3), 13) - 3;
    return table[index];
  }

  // Tracks

  bool get bulgarsWild {
    return pieceLocation(Piece.bulgarsWild) != Location.flipped;
  }

  set bulgarsWild(bool wild) {
    setPieceLocation(wild ? Piece.bulgarsWild : Piece.bulgarsDocile, bulgarsBox);
  }

  Location get bulgarsBox {
    final bulgars = bulgarsWild ? Piece.bulgarsWild : Piece.bulgarsDocile;
    return pieceLocation(bulgars);
  }

  set bulgarsBox(Location box) {
    final bulgars = bulgarsWild ? Piece.bulgarsWild : Piece.bulgarsDocile;
    setPieceLocation(bulgars, box);
  }

  int get bulgarsHits {
    switch (bulgarsBox) {
    case Location.boxBulgarsN1:
      return -1;
    case Location.boxBulgarsZ:
      return 0;
    case Location.boxBulgarsP1:
      return 1;
    default:
      return 0;
    }
  }

  bool get tibetBadass {
    return pieceLocation(Piece.tibetBadass) != Location.flipped;
  }

  set tibetBadass(bool badass) {
    setPieceLocation(badass ? Piece.tibetBadass : Piece.tibetBuddhist, tibetBox);
  }

  Location get tibetBox {
    final tibet = tibetBadass ? Piece.tibetBadass : Piece.tibetBuddhist;
    return pieceLocation(tibet);
  }

  set tibetBox(Location box) {
    final tibet = tibetBadass ? Piece.tibetBadass : Piece.tibetBuddhist;
    setPieceLocation(tibet, box);

  }

  int get tibetHits {
    switch (tibetBox) {
    case Location.boxTibetN1:
      return -1;
    case Location.boxTibetZ:
      return 0;
    case Location.boxTibetP1:
      return 1;
    default:
      return 0;
    }
  }

  Path get cyprusPath {
    return pieceLocation(Piece.cyprusGreek) == Location.flipped ? Path.mediterranean : Path.greek;
  }

  set cyprusPath(Path path) {
    setPieceLocation(path == Path.greek ? Piece.cyprusGreek : Piece.cyprusMediterranean, cyprusBox);
  }

  Location get cyprusBox {
    final cyprus = cyprusPath == Path.greek ? Piece.cyprusGreek : Piece.cyprusMediterranean;
    return pieceLocation(cyprus);
  }

  set cyprusBox(Location box) {
    final cyprus = cyprusPath == Path.greek ? Piece.cyprusGreek : Piece.cyprusMediterranean;
    setPieceLocation(cyprus, box);

  }

  int get cyprusHits {
    switch (cyprusBox) {
    case Location.boxCyprusN1:
      return -1;
    case Location.boxCyprusZ:
      return 0;
    case Location.boxCyprusP1:
      return 1;
    default:
      return 0;
    }
  }

  bool get muslimNavyActive {
    return pieceLocation(Piece.musmlimNavyActive) == Location.boxMuslimNavy;
  }

  Path get socotraPath {
    return pieceLocation(Piece.socotraAfrican) == Location.flipped ? Path.indian : Path.african;
  }

  set socotraPath(Path path) {
    setPieceLocation(path == Path.african ? Piece.socotraAfrican : Piece.socotraIndian, socotraBox);
  }

  Location get socotraBox {
    final socotra = socotraPath == Path.african ? Piece.socotraAfrican : Piece.socotraIndian;
    return pieceLocation(socotra);
  }

  set socotraBox(Location box) {
    final socotra = socotraPath == Path.african ? Piece.socotraAfrican : Piece.socotraIndian;
    setPieceLocation(socotra, box);

  }

  int get socotraHits {
    switch (socotraBox) {
    case Location.boxSocotraN1:
      return -1;
    case Location.boxSocotraZ:
      return 0;
    case Location.boxSocotraP1:
      return 1;
    default:
      return 0;
    }
  }

  // Empires

  bool get byzantiumSurvives {
    const armies = [
      Piece.armyByzantineGreek,
      Piece.armyByzantineMediterranean,
      Piece.armyByzantineAfrican,
      Piece.armyByzantineCaucasian,
    ];
    for (final army in armies) {
      if (pieceLocation(army) != Location.offmap) {
        return true;
      }
    }
    return false;
  }

  bool get persiaSurvives {
    const armies = [
      Piece.armyPersianIndian,
      Piece.armyPersianParthian,
    ];
    for (final army in armies) {
      if (pieceLocation(army) != Location.offmap) {
        return true;
      }
    }
    return false;
  }

  // Rulers

  bool get byzantiumHasRuler {
    return pieceInPlayOrFlipped(Piece.rulerByzantine);
  }

  bool get persiaHasRuler {
    return pieceInPlayOrFlipped(Piece.rulerPersian);
  }

  bool get byzantiumTruce {
    return pieceLocation(Piece.rulerByzantineTruce) != Location.flipped;
  }

  void enterByzantiumTruce() {
    flipPiece(Piece.rulerByzantine);
  }

  void exitByzantiumTruce() {
    flipPiece(Piece.rulerByzantineTruce);
  }

  bool get persiaTruce {
    return pieceLocation(Piece.rulerPersianTruce) != Location.flipped;
  }

  void enterPersiaTruce() {
    flipPiece(Piece.rulerPersian);
  }

  void exitPersiaTruce() {
    flipPiece(Piece.rulerPersianTruce);
  }

  int get byzantineRulerSkill {
    final ruler = byzantiumTruce ? Piece.rulerByzantineTruce : Piece.rulerByzantine;
    final box = pieceLocation(ruler);
    return skillBoxValue(box);
  }

  int get persianRulerSkill {
    final ruler = persiaTruce ? Piece.rulerPersianTruce : Piece.rulerPersian;
    final box = pieceLocation(ruler);
    return skillBoxValue(box);
  }

  set byzantineRulerSkill(int value) {
    final ruler = byzantiumTruce ? Piece.rulerByzantineTruce : Piece.rulerByzantine;
    setPieceLocation(ruler, westSkillBox(value));
  }

  set persianRulerSkill(int value) {
    final ruler = persiaTruce ? Piece.rulerPersianTruce : Piece.rulerPersian;
    setPieceLocation(ruler, eastSkillBox(value));
  }

  void newByzantineRuler(int skill) {
    byzantineRulerSkill = skill;
    _byzantineNewRulerCount += 1;
  }

  void newPersianShah(int skill) {
    persianRulerSkill = skill;
    _persianNewRulerCount += 1;
  }

  String get byzantineEmperorName {
    const names = [
      'Heraclius',
      'Constantine Ⅲ',
      'Heraclonas',
      'Tiberius Ⅱ',
      'Constans Ⅱ',
      'Constantine Ⅳ',
      'Justinian Ⅱ',
      'Leontius',
      'Tiberius Ⅲ',
      'Justinian Ⅱ',
      'Philippicus',
      'Anastasius Ⅱ',
      'Theodosius Ⅲ',
      'Leo Ⅲ',
      'Constantine Ⅴ',
    ];
    return names[_byzantineNewRulerCount];
  }

  String get persianShahName {
    if (_persianNewRulerCount == 0) {
      return 'Yazdegird Ⅲ';
    }
    return 'Persian Shah';
  }

  // Jihads

  void jihadInitiate(List<Path> paths) {
    final jihadPiece = paths.length == 2 ? Piece.jihadAlternating : Piece.jihadOnePath;
    setPieceLocation(jihadPiece, Location.boxJihad);
    setPieceLocation(mujahideenPiece, pathLand(paths[0], 0));
  }

  void jihadEnd() {
    setPieceLocation(Piece.jihadOnePath, Location.boxOutOfPlay);
    setPieceLocation(mujahideenPiece, Location.boxCasbah);
  }

  bool get jihadActive {
    return piecesInLocationCount(PieceType.jihad, Location.boxJihad) > 0;
  }

  bool get jihadAlternating {
    return pieceLocation(Piece.jihadAlternating) == Location.boxJihad;
  }

  List<Path> get jihadPaths {
    final location = pieceLocation(mujahideenPiece);
    if (!location.isType(LocationType.land)) {
        return [];
    }
    final path = landPath(location)!;
    final theater = pathTheater(path);
    if (jihadAlternating) {
        if (theater == Theater.western) {
            return [Path.greek, Path.mediterranean];
        } else {
            return [Path.indian, Path.parthian];
        }
    }
    return [path];
}

  bool jihadPathDead(Path path) {
    if ([Path.greek, Path.mediterranean].contains(path)) {
        return !pathHasByzantineArmy(path);
    }
    if ([Path.indian, Path.parthian].contains(path)) {
        return !pathHasPersianArmy(path);
    }
    return true;
  }

  // Great Kings

  bool get africaHasGreatKing {
    if (!advancedGame) {
      return false;
    }
    final location = pieceLocation(Piece.greatKingAfrican);
    return location.isType(LocationType.westSkillBox);
  }
  
  bool get caucasusHasGreatKing {
    if (!advancedGame) {
      return false;
    }
    final location = pieceLocation(Piece.greatKingCaucasian);
    return location.isType(LocationType.westSkillBox);
  }
  
  // Action Points

  bool get westDivided {
    return pieceLocation(Piece.westAP) == Location.flipped;
  }

  int get westAP {
    final box = pieceLocation(westDivided ? Piece.westAP : Piece.westAPDivided);
    return skillBoxValue(box);
  }

  void adjustWestAP(int delta) {
    int total = westAP;
    total += delta;
    if (total > byzantineRulerSkill - 1) {
      total = byzantineRulerSkill - 1;
    }
    if (total < 0) {
      total = 0;
    }
    setPieceLocation(westDivided ? Piece.westAP : Piece.westAPDivided, westSkillBox(total));
  }

  bool get eastDivided {
    return pieceLocation(Piece.eastAP) == Location.flipped;
  }

  int get eastAP {
    final box = pieceLocation(eastDivided ? Piece.eastAP : Piece.eastAPDivided);
    return skillBoxValue(box);
  }

  void adjustEastAP(int delta) {
    int total = eastAP;
    total += delta;
    if (total > persianRulerSkill - 1) {
      total = persianRulerSkill - 1;
    }
    if (total < 0) {
      total = 0;
    }
    setPieceLocation(eastDivided ? Piece.eastAP : Piece.eastAPDivided, eastSkillBox(total));
  }

  int get westAPTokens {
    final box = pieceLocation(Piece.westAPToken);
    return skillBoxValue(box);
  }

  void adjustWestAPTokens(int delta) {
    int total = westAPTokens;
    total += delta;
    if (total > 7) {
      total = 7;
    }
    if (total < 0) {
      total = 0;
    }
    setPieceLocation(Piece.westAPToken, westSkillBox(total));
  }

  int get eastAPTokens {
    final box = pieceLocation(Piece.eastAPToken);
    return skillBoxValue(box);
  }

  void adjustEastAPTokens(int delta) {
    int total = eastAPTokens;
    total += delta;
    if (total > 7) {
      total = 7;
    }
    if (total < 0) {
      total = 0;
    }
    setPieceLocation(Piece.eastAPToken, eastSkillBox(total));
  }

  int get sharedAPTokens {
    final box = pieceLocation(Piece.sharedAPToken);
    return skillBoxValue(box);
  }

  void adjustSharedAPTokens(int delta) {
    int total = sharedAPTokens;
    total += delta;
    if (total > 7) {
      total = 7;
    }
    if (total < 0) {
      total = 0;
    }
    setPieceLocation(Piece.sharedAPToken, sharedSkillBox(total));
  }

  int get africaAP {
    if (!advancedGame) {
      return 0;
    }
    final kingLocation = pieceLocation(Piece.greatKingAfrican);
    if (kingLocation.isType(LocationType.westSkillBox)) {
      return skillBoxValue(kingLocation);
    }
    final apLocation = pieceLocation(Piece.africaAP);
    if (apLocation.isType(LocationType.westSkillBox)) {
      return skillBoxValue(apLocation);
    }
    return 0;
  }

  void adjustAfricaAP(int delta) {
    if (!advancedGame) {
      return;
    }
    int total = africaAP + delta;
    final kingLocation = pieceLocation(Piece.greatKingAfrican);
    bool haveKing = kingLocation.isType(LocationType.westSkillBox);
    int maxTotal = haveKing ? 6 : 1;
    if (total > maxTotal) {
      total = maxTotal;
    }
    if (total < 0) {
      total = 0;
    }
    if (haveKing) {
      setPieceLocation(Piece.greatKingAfrican, westSkillBox(total));
    } else if (total > 0) {
      setPieceLocation(Piece.africaAP, westSkillBox(total));
    } else {
      setPieceLocation(Piece.africaAP, Location.offmap);
    }
  }

  int get caucasusAP {
    if (!advancedGame) {
      return 0;
    }
    final kingLocation = pieceLocation(Piece.greatKingCaucasian);
    if (kingLocation.isType(LocationType.westSkillBox)) {
      return skillBoxValue(kingLocation);
    }
    final apLocation = pieceLocation(Piece.caucasusAP);
    if (apLocation.isType(LocationType.westSkillBox)) {
      return skillBoxValue(apLocation);
    }
    return 0;
  }

  void adjustCaucasusAP(int delta) {
    if (!advancedGame) {
      return;
    }
    int total = africaAP + delta;
    final kingLocation = pieceLocation(Piece.greatKingCaucasian);
    bool haveKing = kingLocation.isType(LocationType.westSkillBox);
    int maxTotal = haveKing ? 6 : 1;
    if (total > maxTotal) {
      total = maxTotal;
    }
    if (total < 0) {
      total = 0;
    }
    if (haveKing) {
      setPieceLocation(Piece.greatKingCaucasian, westSkillBox(total));
    } else if (total > 0) {
      setPieceLocation(Piece.caucasusAP, westSkillBox(total));
    } else {
      setPieceLocation(Piece.caucasusAP, Location.offmap);
    }
  }

  // Events

  bool eventActive(Event event) {
    return _eventActives[event.index];
  }

  void setEventActive(Event event) {
    _eventActives[event.index] = true;
  }

  void clearEvents() {
    _eventActives.fillRange(0, _eventActives.length, false);
  }

  // Turn

  int get currentTurn {
    return 51 - _deck.length;
  }

  // Cards

  Card get currentCard {
    return _deck[0];
  }

  void advanceDeck() {
    _deck.removeAt(0);
  }

  String cardTitle(Card card) {
    const cardTitles = {
      Card.chainedAndNailedByFear1: '“Chained and Nailed by Fear”',
      Card.farewellSyria2: '“Farewell, Syria!”',
      Card.aMountainOfFire3: '“A Mountain of Fire”',
      Card.noCountrySoDefenseless4: '“No Country so Defenseless”',
      Card.aJewishNationalHome5: '“A Jewish National Home”',
      Card.isItGodWhoCommandsYouToMurder6: '“Is it God Who Commands You to Murder, Pillage, and Destroy?”',
      Card.anAllianceWithHell7: '“An Alliance with Hell”',
      Card.allahDothBlotOut8: '“Allah Doth Blot Out or Confirm What He Pleaseth”',
      Card.revoltOfTheExarchGregory9: 'Revolt of the Exarch Gregory',
      Card.arabsInvadeCyprus10: 'Arabs Invade Cyprus!',
      Card.kalidurutSignsTheBaqt11: 'Kalidurut Signs the Baqt',
      Card.theBattleOfTheCamel12: 'The Battle of the Camel',
      Card.theUmayyadCaliphate13: 'The Umayyad Caliphate',
      Card.milkThePersians14: '“Milk the Persian! And When the Milk Dries, Suck Their Blood!”',
      Card.itIsTheEndOfTheWorld15: '“It Is the End of the World”',
      Card.theTheodosianWalls16: 'The Theodosian Walls',
      Card.greekFire17: 'Greek Fire!',
      Card.theFourGarrisonsOfTheOccupiedWest18: 'The Four Garrisons of the Occupied West',
      Card.thePeaksOfLebanon19: 'The Peaks of Lebanon',
      Card.councilOfConstantinople20: 'Council of Constantinople',
      Card.asparukhKhanOfTheBulgars21: 'Asparukh, Khan of the Bulgars',
      Card.alpTarkhanKhazarRuler22: 'Alp Tarkhan, Khazar Ruler',
      Card.theBattleOfKarbala23: 'The Battle of Karbala',
      Card.theDomeOfTheRock24: 'The Dome of the Rock',
      Card.revoltOfTheZanjiSlaves25: 'Revolt of the Zanji Slaves',
      Card.aWarOverCoins26: 'A War Over Coins',
      Card.blacksAsInnumerableAsAnts27: '“Blacks as Innumerable as Ants!”',
      Card.kahinaQueenOfTheMoors28: 'Kahina: Queen of the Moors',
      Card.mercuriosKingOfNubia29: 'Mercurios, King of Nubia',    
      Card.armeniaBetrayed30: 'Armenia Betrayed',
      Card.piroozRevolts31: 'Pirooz Revolts',
      Card.theArmyOfPeacocks32: 'The Army of Peacocks',
      Card.treacherousCountJulian33: 'Treacherous Count Julian',
      Card.iSeeHeadsReadyToBeCutOff34: '“I See Heads Ready to be Cut Off, and I am the Man to Do It!”',
      Card.suluKhanOfTheTurgesh35: 'Sülü, Khan of the Türgesh',
      Card.egyptianSailorsMutiny36: 'Egyptian Sailors Mutiny!',
      Card.shameAndDegradation37: '“Shame and Degradation”',
      Card.theMiseryOfDhimmitude38: 'The Misery of Dhimmitude',
      Card.payTheJizya39: '“Pay the Jizya!”',
      Card.iconoclasm40: 'Iconoclasm',
      Card.khazarPrinceBarjik41: 'Khazar Prince Barjik',
      Card.munnuzaHeartLampegia42: 'Munnuza ♥ Lampegia',
      Card.charlesMartel43: 'Charles Martel',
      Card.revoltOfTheMurjiah44: 'Revolt of the Murjiʼah',
      Card.fromoKesaro45: 'Fromo Kesaro',
      Card.theGreatBerberRevolt46: 'The Great Berber Revolt',
      Card.theReligionOfTheIsraelitesIsBetter47: '“The Religion of the Israelites is Better”',
      Card.cyriacusKingOfNubia48: 'Cyriacus, King of Nubia',
      Card.theBattleOfTheZab49: 'The Battle of the Zab',
      Card.iAmTheDestroyingAvenger50: '“I am the Destroying Avenger and the Pitiless Blood-Shedder!”'
    };
    return cardTitles[card]!;
  }

  List<int> cardActionPoints(Card card) {
    const actionPoints = {
      Card.chainedAndNailedByFear1: [3,2],
      Card.farewellSyria2: [4,3],
      Card.aMountainOfFire3: [2,3],
      Card.noCountrySoDefenseless4: [3,4],
      Card.aJewishNationalHome5: [2,4],
      Card.isItGodWhoCommandsYouToMurder6: [3,3],
      Card.anAllianceWithHell7: [4,2],
      Card.allahDothBlotOut8: [3,4],
      Card.revoltOfTheExarchGregory9: [2,3],
      Card.arabsInvadeCyprus10: [4,2],
      Card.kalidurutSignsTheBaqt11: [4,4],
      Card.theBattleOfTheCamel12: [3,3],
      Card.theUmayyadCaliphate13: [3,4],
      Card.milkThePersians14: [3,3],
      Card.itIsTheEndOfTheWorld15: [2,2],
      Card.theTheodosianWalls16: [3,4],
      Card.greekFire17: [4,3],
      Card.theFourGarrisonsOfTheOccupiedWest18: [4,3],
      Card.thePeaksOfLebanon19: [4,3],
      Card.councilOfConstantinople20: [4,3],
      Card.asparukhKhanOfTheBulgars21: [3,2],
      Card.alpTarkhanKhazarRuler22: [4,3],
      Card.theBattleOfKarbala23: [3,3],
      Card.theDomeOfTheRock24: [2,4],
      Card.revoltOfTheZanjiSlaves25: [3,3],
      Card.aWarOverCoins26: [2,2],
      Card.blacksAsInnumerableAsAnts27: [3,3],
      Card.kahinaQueenOfTheMoors28: [4,3],
      Card.mercuriosKingOfNubia29: [3,4],
      Card.armeniaBetrayed30: [4,3],
      Card.piroozRevolts31: [4,4],
      Card.theArmyOfPeacocks32: [2,2],
      Card.treacherousCountJulian33: [3,3],
      Card.iSeeHeadsReadyToBeCutOff34: [3,3],
      Card.suluKhanOfTheTurgesh35: [4,3],
      Card.egyptianSailorsMutiny36: [4,4],
      Card.shameAndDegradation37: [3,3],
      Card.theMiseryOfDhimmitude38: [3,3],
      Card.payTheJizya39: [3,3],
      Card.iconoclasm40: [4,3],
      Card.khazarPrinceBarjik41: [4,4],
      //Card.munnuzaLovesLampegia42
      Card.charlesMartel43: [4,2],
      Card.revoltOfTheMurjiah44: [3,4],
      Card.fromoKesaro45: [3,4],
      Card.theGreatBerberRevolt46: [4,3],
      Card.theReligionOfTheIsraelitesIsBetter47: [4,3],
      Card.cyriacusKingOfNubia48: [2,2],
      Card.theBattleOfTheZab49: [2,2],
      //Card.iAmTheDestroyingAvenger50
    };
    return actionPoints[card]!;
  }

  int cardPathEncodedHits(Card card, Path path) {
    const encodedHits = {
      Card.chainedAndNailedByFear1: [3, 0, 0, 1, 1, 0],
      Card.farewellSyria2: [16, 0, 0, 1, 3, 0],
      Card.aMountainOfFire3: [2, -1, -1, -1, -1, -1],
      Card.noCountrySoDefenseless4: [1, 4, 2, 1, 13, 2],
      Card.aJewishNationalHome5: [3, 0, 1, 1, 2, 0],
      Card.isItGodWhoCommandsYouToMurder6: [2, 3, 2, 13, 2, 2],
      Card.anAllianceWithHell7: [1, 2, -1, 1, 0, 3],
      Card.allahDothBlotOut8: [3, 1, 1, 2, 13, 1],
      Card.revoltOfTheExarchGregory9: [2, 2, 1, 13, 1, 2],
      Card.arabsInvadeCyprus10: [4, 0, 3, 1, -1, 1],
      Card.kalidurutSignsTheBaqt11: [2, 1, 2, 0, 1, -1],
      Card.theBattleOfTheCamel12: [1, 1, 0, -1, -1, 3],
      Card.theUmayyadCaliphate13: [-1, -1, -1, -1, -1, 3],
      Card.milkThePersians14: [3, 1, 2, 3, -3, 0],
      Card.itIsTheEndOfTheWorld15: [2, 3, 1, 12, -1, 1],
      Card.theTheodosianWalls16: [13, 2, 1, 2, 2, 1],
      Card.greekFire17: [14, 1, 0, 1, 3, 0],
      Card.theFourGarrisonsOfTheOccupiedWest18: [13, 0, 0, 1, 1, 0],
      Card.thePeaksOfLebanon19: [-1, 1, 1, 1, 2, 1],
      Card.councilOfConstantinople20: [1, 1, 0, 1, 1, 1],
      Card.asparukhKhanOfTheBulgars21: [1, 1, 2, 2, 1, 1],
      Card.alpTarkhanKhazarRuler22: [1, 1, 1, -1, 1, 1],
      Card.theBattleOfKarbala23: [1, 2, -1, -1, 1, -1],
      Card.theDomeOfTheRock24: [2, 1, 0, 1, 1, 0],
      Card.revoltOfTheZanjiSlaves25: [1, -1, -1, -1, -1, -1],
      Card.aWarOverCoins26: [2, 3, -1, -1, 1, 2],
      Card.blacksAsInnumerableAsAnts27: [1, -1, -1, 0, 1, 0],
      Card.kahinaQueenOfTheMoors28: [2, 4, 3, 1, 1, 0],
      Card.mercuriosKingOfNubia29: [2, 2, -1, 1, 2, 1],
      Card.armeniaBetrayed30: [2, 2, 1, 1, 2, -1],
      Card.piroozRevolts31: [2, 2, -1, 2, -1, -1],
      Card.theArmyOfPeacocks32: [2, 1, 1, -3, 3, 1],
      Card.treacherousCountJulian33: [2, 2, -1, 2, 13, 3],
      Card.iSeeHeadsReadyToBeCutOff34: [13, 4, 1, 4, 3, 2],
      Card.suluKhanOfTheTurgesh35: [13, 3, 1, 3, 3, 1],
      Card.egyptianSailorsMutiny36: [14, 1, 2, 0, 1, -1],
      Card.shameAndDegradation37: [0, 0, 0, 0, 0, 0],
      Card.theMiseryOfDhimmitude38: [2, 2, 2, 2, 2, 2],
      Card.payTheJizya39: [3, 3, -1, 4, 1, 0],
      Card.iconoclasm40: [3, -1, 3, 0, 2, 2],
      Card.khazarPrinceBarjik41: [0, 1, 0, 1, 2, 0],
      //Card.munnuzaLovesLampegia42
      Card.charlesMartel43: [3, 3, 1, 1, 1, 1],
      Card.revoltOfTheMurjiah44: [2,  1, 0, 3, -1, 1],
      Card.fromoKesaro45: [3, 3, 0, 2, 3, 3],
      Card.theGreatBerberRevolt46: [2, -1, 2, 1, 2, 0],
      Card.theReligionOfTheIsraelitesIsBetter47: [3, 0, 0, 0, 1, 1],
      Card.cyriacusKingOfNubia48: [1, 0, -1, -1, -1, -1],
      Card.theBattleOfTheZab49: [1, 2, -1, -1, -1, 0],
      //Card.iAmTheDestroyingAvenger50
    };
    return encodedHits[card]![path.index];
  }

  // Basic/Advanced

  bool get advancedGame {
    return pieceLocation(Piece.socotraAfrican) != Location.offmap;
  }

  // Setup

  void setupPieces(List<(Piece, Location)> pieces) {
    for (final record in pieces) {
      final piece = record.$1;
      final location = record.$2;
      setPieceLocation(piece, location);
    }
  }

  void setupArmies(List<(Piece, Location, ArmyStatus)> armies) {
    for (final record in armies) {
      final army = record.$1;
      final location = record.$2;
      final armyStatus = record.$3;
      setPieceLocation(army, location);
      setArmyStatus(army, armyStatus);
    }
  }

  void setupDeck(Random random, List<List<Card>> eraCards) {
      var deck = <Card>[];
      for (int era = 0; era < 4; ++era) {
          deck.add(eraCards[era][0]);
          Card? finalCard;
          List<Card>? pile;
          if (era == 3) {
              finalCard = eraCards[era][eraCards[era].length - 1];
              pile = eraCards[era].sublist(1, eraCards[era].length - 1);
          } else {
              pile = eraCards[era].sublist(1);
          }
          pile.shuffle(random);
          if (era != 0 || eraCards.length <= 4) {
              deck.addAll(pile);
          } else {
              for (int i = 0; i < pile!.length; ++i) {
                  deck.add(pile[i]);
                  if (pile[i] == eraCards[4][0]) {
                      pile = pile.sublist(i + 1);
                      pile.addAll(eraCards[5]);
                      pile.shuffle(random);
                      deck.addAll(pile);
                      break;
                  }
              }
          }
          if (finalCard != null) {
              deck.add(finalCard);
          }
      }
      _deck = deck;
  }

  factory GameState.setupBasic(Random random) {

    var state = GameState();

    state.setupArmies([
      (Piece.armyByzantineGreek, Location.landDamascus, ArmyStatus.strong),
      (Piece.armyByzantineMediterranean, Location.landAlexandria, ArmyStatus.strong),
      (Piece.armyExarchate, Location.landTingitana, ArmyStatus.strong),
      (Piece.armyVisigoth, Location.landHispania, ArmyStatus.strong),
      (Piece.armyFrankish, Location.landAquitaine, ArmyStatus.strong),
      (Piece.armyPersianIndian, Location.landKhuzestan, ArmyStatus.strong),
      (Piece.armyPratihara, Location.landSindh, ArmyStatus.strong),
      (Piece.armyPersianParthian, Location.landCtesiphon, ArmyStatus.strong),
      (Piece.armySogdian, Location.landTransoxiana, ArmyStatus.strong),
      (Piece.armyChinese, Location.landKushinne, ArmyStatus.strong),
      (Piece.armyBerber, Location.boxBerberRevolt, ArmyStatus.strong),
      (Piece.armyTurgesh, Location.offmap, ArmyStatus.strong),
    ]);

    state.setupPieces([
      (Piece.castleByzantineMajor0, Location.landConstantinople),
      (Piece.castleByzantineMajor1, Location.landCarthage),
      (Piece.castleByzantineMinor2, Location.landJerusalem),
      (Piece.castleByzantineMinor3, Location.landAlexandria),
      (Piece.capitalByzantineStrong, Location.landConstantinople),
      (Piece.capitalPersianStrong, Location.landCtesiphon),
      (Piece.blessingIcons, Location.boxBlessingsAvailable),
      (Piece.blessingFleetP1, Location.boxBlessingsAvailable),
      (Piece.blessingImmortalsP2, Location.boxBlessingsAvailable),
      (Piece.meccaWeak, Location.landMecca),
      (Piece.islamGreek, Location.landMecca),
      (Piece.islamMediterranean, Location.landMecca),
      (Piece.islamIndian, Location.landMecca),
      (Piece.islamParthian, Location.landMecca),
      (Piece.musmlimNavyActive, Location.boxMuslimNavy),
      (Piece.bulgarsDocile, Location.boxBulgarsZ),
      (Piece.cyprusGreek, Location.boxCyprusN1),
      (Piece.tibetBadass, Location.boxTibetZ),
      (Piece.byzantineReligion, Location.boxByzantineReligionOrthodox),
      (Piece.rulerByzantine, Location.boxWest6),
      (Piece.rulerPersian, Location.boxEast4),
      (Piece.westAP, Location.boxWest0),
      (Piece.eastAP, Location.boxEast0),
      (Piece.westAPToken, Location.boxWest0),
      (Piece.eastAPToken, Location.boxEast0),
      (Piece.sharedAPToken, Location.boxShared0),
      (Piece.byzantineLastStandAP, Location.boxByzantineLastStand),
      (Piece.persianLastStandAP, Location.boxPersianLastStand),
      (Piece.excubitors2, Location.offmap),
      (Piece.tradeRouteClosedNile, Location.offmap),
      (Piece.tradeRouteClosedSocotra, Location.offmap),
      (Piece.tradeRouteClosedSilk, Location.offmap),
    ]);

    state.setupPieces([
      (Piece.armyByzantineAfrican, Location.offmap),
      (Piece.armyNubian, Location.offmap),
      (Piece.armyAxum, Location.offmap),
      (Piece.armyByzantineCaucasian, Location.offmap),
      (Piece.armyArmenian, Location.offmap),
      (Piece.armyKhazar, Location.offmap),
      (Piece.islamAfrican, Location.offmap),
      (Piece.islamCaucasian, Location.offmap),
      (Piece.mujahideenTribal, Location.offmap),
      (Piece.jewsP1, Location.offmap),
      (Piece.christianDamascus, Location.offmap),
      (Piece.arabStop, Location.offmap),
      (Piece.refugeesManichees, Location.offmap),
      (Piece.refugeesParsees, Location.offmap),
      (Piece.refugeesMardaites, Location.offmap),
      (Piece.socotraAfrican, Location.offmap),
      (Piece.zabulistanDefiant, Location.offmap),
      (Piece.greatKingAfrican, Location.offmap),
      (Piece.jihadAlternating, Location.offmap),
      (Piece.kaaba3, Location.offmap),
      (Piece.kaaba4, Location.offmap),
      (Piece.kaaba5, Location.offmap),
      (Piece.kaaba6, Location.offmap),
      (Piece.kaaba7, Location.offmap),
      (Piece.kaaba8, Location.offmap),
      (Piece.noShariaLaw, Location.offmap),
    ]);

    state.setupDeck(random,[
        [Card.chainedAndNailedByFear1,Card.farewellSyria2,Card.aMountainOfFire3,Card.noCountrySoDefenseless4,Card.isItGodWhoCommandsYouToMurder6,
         Card.allahDothBlotOut8,Card.revoltOfTheExarchGregory9,Card.arabsInvadeCyprus10,Card.theBattleOfTheCamel12],
        [Card.theUmayyadCaliphate13,Card.milkThePersians14,Card.itIsTheEndOfTheWorld15,Card.theTheodosianWalls16,Card.greekFire17,Card.theFourGarrisonsOfTheOccupiedWest18,
         Card.thePeaksOfLebanon19,Card.asparukhKhanOfTheBulgars21,Card.theBattleOfKarbala23],
        [Card.revoltOfTheZanjiSlaves25,Card.aWarOverCoins26,Card.kahinaQueenOfTheMoors28,
         Card.piroozRevolts31,Card.theArmyOfPeacocks32,Card.treacherousCountJulian33,Card.iSeeHeadsReadyToBeCutOff34,Card.suluKhanOfTheTurgesh35,Card.egyptianSailorsMutiny36],
        [Card.shameAndDegradation37,Card.theMiseryOfDhimmitude38,Card.payTheJizya39,Card.iconoclasm40,Card.munnuzaHeartLampegia42,Card.charlesMartel43,
         Card.revoltOfTheMurjiah44,Card.fromoKesaro45,Card.theGreatBerberRevolt46,Card.theBattleOfTheZab49,Card.iAmTheDestroyingAvenger50],
    ]);

    return state;
  }

  factory GameState.setupAdvanced(Random random) {

    final state = GameState.setupBasic(random);

    state.setupArmies([
      (Piece.armyByzantineAfrican, Location.landUpperEgypt, ArmyStatus.weak),
      (Piece.armyNubian, Location.landNobatia, ArmyStatus.strong),
      (Piece.armyAxum, Location.landAdulis, ArmyStatus.strong),
      (Piece.armyByzantineCaucasian, Location.landNsibis, ArmyStatus.weak),
      (Piece.armyArmenian, Location.landVaspurakan, ArmyStatus.strong),
      (Piece.armyKhazar, Location.landBalanjar, ArmyStatus.strong),
    ]);

    state.setupPieces([
      (Piece.islamAfrican, Location.landMecca),
      (Piece.islamCaucasian, Location.landMecca),
      (Piece.mujahideenTribal, Location.landDamascus),
      (Piece.refugeesMardaites, Location.landJerusalem),
      (Piece.refugeesParsees, Location.landYezd),
      (Piece.refugeesManichees, Location.landCtesiphon),
      (Piece.christianDamascus, Location.landDamascus),
      (Piece.socotraAfrican, Location.boxSocotraZ),
      (Piece.muslimNavyNone, Location.boxMuslimNavy),
      (Piece.noShariaLaw, Location.boxShariaLaw),
    ]);

    state.setupDeck(random,[
        [Card.chainedAndNailedByFear1,Card.farewellSyria2,Card.aMountainOfFire3,Card.noCountrySoDefenseless4,Card.aJewishNationalHome5,Card.isItGodWhoCommandsYouToMurder6],
        [Card.theUmayyadCaliphate13,Card.milkThePersians14,Card.itIsTheEndOfTheWorld15,Card.theTheodosianWalls16,Card.greekFire17,Card.theFourGarrisonsOfTheOccupiedWest18,
         Card.thePeaksOfLebanon19,Card.councilOfConstantinople20,Card.asparukhKhanOfTheBulgars21,Card.alpTarkhanKhazarRuler22,Card.theBattleOfKarbala23,Card.theDomeOfTheRock24],
        [Card.revoltOfTheZanjiSlaves25,Card.aWarOverCoins26,Card.blacksAsInnumerableAsAnts27,Card.kahinaQueenOfTheMoors28,Card.mercuriosKingOfNubia29,Card.armeniaBetrayed30,
         Card.piroozRevolts31,Card.theArmyOfPeacocks32,Card.treacherousCountJulian33,Card.iSeeHeadsReadyToBeCutOff34,Card.suluKhanOfTheTurgesh35,Card.egyptianSailorsMutiny36],
        [Card.shameAndDegradation37,Card.theMiseryOfDhimmitude38,Card.payTheJizya39,Card.iconoclasm40,Card.khazarPrinceBarjik41,Card.munnuzaHeartLampegia42,Card.charlesMartel43,
         Card.revoltOfTheMurjiah44,Card.fromoKesaro45,Card.theGreatBerberRevolt46,Card.theReligionOfTheIsraelitesIsBetter47,Card.cyriacusKingOfNubia48,Card.theBattleOfTheZab49,Card.iAmTheDestroyingAvenger50],
        [Card.farewellSyria2],
        [Card.anAllianceWithHell7,Card.allahDothBlotOut8,Card.revoltOfTheExarchGregory9,Card.arabsInvadeCyprus10,Card.kalidurutSignsTheBaqt11,Card.theBattleOfTheCamel12],
    ]);

    return state;
  }
}

enum Choice {
  reduceEmperorSkill,
  shiftBulgarsLeft,
  lastStandActionPoints,
  lastStandSkill,
  lossDamageArmy,
  lossDamageCastle,
  lossDamageCapital,
  lossDestroyCapital,
  lossRetreat,
  lossSiege,
  lossCursed,
  actionAttack,
  actionRally,
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

class GameOutcome {

  GameOutcome();

  GameOutcome.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() => {

  };
}

class GameOverException implements Exception {
  GameOutcome outcome;

  GameOverException() :
    outcome = GameOutcome();
}

class GameOptions {
  bool advanced = false;

  GameOptions();

  GameOptions.fromJson(Map<String, dynamic> json)
    : advanced = json['advanced'] as bool
    ;

  Map<String, dynamic> toJson() => {
    'advanced': advanced,
  };

  String get desc {
    String optionsList = '';
    if (advanced) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Advanced';
    }
    return optionsList;
  }
}

enum Phase {
  darAlIslam,
  arab,
  actions,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateDarAlIslam extends PhaseState {
  int? total;

  PhaseStateDarAlIslam();

  PhaseStateDarAlIslam.fromJson(Map<String, dynamic> json)
    : total = json['total'] as int?
    ;
  
  @override
  Map<String, dynamic> toJson() => {
    'total': total,
  };

  @override
  Phase get phase {
    return Phase.darAlIslam;
  }
}

class PhaseStateArab extends PhaseState {
  int hitsRemaining = 0;
  Piece? defendingArmy;
  Location? invadedLand;

  PhaseStateArab();

  PhaseStateArab.fromJson(Map<String, dynamic> json)
    : hitsRemaining = json['hitsRemaining'] as int
    , defendingArmy = pieceFromIndex(json['defendingArmy'] as int?)
    , invadedLand = locationFromIndex(json['invadedLand'] as int?)
    ;
  
  @override
  Map<String, dynamic> toJson() => {
    'hitsRemaining': hitsRemaining,
    'defendingArmy': pieceToIndex(defendingArmy),
    'invadedLand': locationToIndex(invadedLand),
  };

  @override
  Phase get phase {
    return Phase.arab;
  }
}

class PhaseStateActions extends PhaseState {
  bool christianDamascusClaimed = false;
  int apAvailable = 0;
  int apSpent = 0;

  PhaseStateActions();

  PhaseStateActions.fromJson(Map<String, dynamic> json)
  : christianDamascusClaimed = json['christianDamascusClaimed'] as bool
  , apAvailable = json['apAvailable'] as int
  , apSpent = json['apSpent'] as int
  ;

  @override
  Map<String, dynamic> toJson() => {
    'christianDamascusClaimed': christianDamascusClaimed,
    'apAvailable': apAvailable,
    'apSpend': apSpent
  };

  @override
  Phase get phase {
    return Phase.actions;
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
      case Phase.darAlIslam:
        _phaseState = PhaseStateDarAlIslam.fromJson(phaseStateJson);
      case Phase.arab:
        _phaseState = PhaseStateArab.fromJson(phaseStateJson);
      case Phase.actions:
        _phaseState = PhaseStateActions.fromJson(phaseStateJson);
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
      _state.cardTitle(_state.currentCard),
      _log);
  }

  Future<void> saveCurrentState() async {
    await GameDatabase.instance.setGameState(
      _gameId,
      jsonEncode(_state.toJson()),
      jsonEncode(randomToJson(_random)),
      _step, _subStep,
      _state.currentTurn,
      _state.cardTitle(_state.currentCard),
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

  void setArmyStatus(Piece army, ArmyStatus status) {
    logLine('>${army.desc} becomes ${status.desc}.');
    _state.setArmyStatus(army, status);
  }

  void adjustWestAP(int delta) {
    _state.adjustWestAP(delta);
    if (delta > 0) {
      logLine('>West AP: +$delta → ${_state.westAP}');
    } else if (delta < 0) {
      logLine('>West AP: $delta → ${_state.westAP}');
    }
  }

  void adjustEastAP(int delta) {
    _state.adjustEastAP(delta);
    if (delta > 0) {
      logLine('>East AP: +$delta → ${_state.eastAP}');
    } else if (delta < 0) {
      logLine('>East AP: $delta → ${_state.eastAP}');
    }
  }

  void adjustAfricaAP(int delta) {
    _state.adjustAfricaAP(delta);
    if (delta > 0) {
      logLine('>Africa AP: +$delta → ${_state.africaAP}');
    } else if (delta < 0) {
      logLine('>Africa AP: $delta → ${_state.africaAP}');
    }
  }

  void adjustCaucasusAP(int delta) {
    _state.adjustCaucasusAP(delta);
    if (delta > 0) {
      logLine('>Caucasus AP: +$delta → ${_state.caucasusAP}');
    } else if (delta < 0) {
      logLine('>Caucasus AP: $delta → ${_state.caucasusAP}');
    }
  }

  void adjustWestAPTokens(int delta) {
    _state.adjustWestAPTokens(delta);
    if (delta > 0) {
      logLine('>West AP Tokens: +$delta → ${_state.westAPTokens}');
    } else if (delta < 0) {
      logLine('>West AP Tokens: $delta → ${_state.westAPTokens}');
    }
  }

  void adjustEastAPTokens(int delta) {
    _state.adjustEastAPTokens(delta);
    if (delta > 0) {
      logLine('>East AP Tokens: +$delta → ${_state.eastAPTokens}');
    } else if (delta < 0) {
      logLine('>East AP Tokens: $delta → ${_state.eastAPTokens}');
    }
  }

  void adjustSharedAPTokens(int delta) {
    _state.adjustSharedAPTokens(delta);
    if (delta > 0) {
      logLine('>Shared AP Tokens: +$delta → ${_state.sharedAPTokens}');
    } else if (delta < 0) {
      logLine('>Shared AP Tokens: $delta → ${_state.sharedAPTokens}');
    }
  }

  void adjustSyrianStrength(int delta) {
    _state.adjustSyrianStrength(delta);
    if (delta > 0) {
      logLine('>Syrian Strength: +$delta → ${_state.syrianStrength}');
    } else if (delta < 0) {
      logLine('>Syrian Strength: $delta → ${_state.syrianStrength}');
    }
  }

  // High-Level Functions

  void createGreatKing(Path path, int actionPoints) {
    final greatKing = path == Path.african ? Piece.greatKingAfrican : Piece.greatKingCaucasian;
    _state.setPieceLocation(greatKing, _state.westSkillBox(actionPoints));
    final event = path == Path.african ? Event.greatKingAfrican : Event.greatKingCaucasian;
    _state.setEventActive(event);
  }

  void removeGreatKing() {
    _state.setPieceLocation(Piece.greatKingAfrican, Location.offmap);
  }

  void activateSyrians() {
    logLine('>Caliph Umar Ⅰ strengthens the Syrians.');
    final kaaba = _state.byzantineReligion == Religion.christianMonophysite ? Piece.kaaba5 : Piece.kaaba6;
    _state.setPieceLocation(kaaba, Location.landMecca);
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
  }

  bool pathConversionPossible(Path path) {
    final islam = _state.pathIslamUndisruptedPiece(path);
    final location = _state.pieceLocation(islam);
    if (location == Location.flipped) {
      return false;
    }
    final nextLand = _state.pathSucceedingLand(path, location);
    if (nextLand == null) {
      return false;
    }
    int apostasyNumber = _state.landApostasyNumber(nextLand);
    if (apostasyNumber == 0) {
      return false;
    }
    if (_state.landControl(nextLand) != Control.arab) {
      return false;
    }
    return true;
  }

  List<Path> get candidateConversionPaths {
    final paths = <Path>[];
    for (final path in Path.values) {
      if (pathConversionPossible(path)) {
        paths.add(path);
      }
    }
    return paths;
  }

  bool pathConversionCheck(Path path, bool disrupt) {
    final islam = _state.pathIslamPiece(path);
    final land = _state.pieceLocation(islam);
    final nextLand = _state.pathSucceedingLand(path, land)!;
    logLine('>Conversion Check for ${nextLand.desc}.');
    int die = rollD6();

    logTableHeader();
    logD6InTable(die);
    int apostasyNumber = _state.landApostasyNumber(nextLand);
    logLine('>|Apostasy Number|$apostasyNumber|');
    logTableFooter();

    if (die <= apostasyNumber) {
      if (_state.pieceLocation(Piece.blessingThemes) == nextLand) {
        logLine('>Themes in ${nextLand.desc} prevent conversion to Islam.');
        _state.setPieceLocation(Piece.blessingThemes, Location.offmap);
      } else {
        logLine('>${nextLand.desc} Converts to Islam.');
        final piece = disrupt ? _state.pathIslamDisruptedPiece(path) : _state.pathIslamUndisruptedPiece(path);
        _state.setPieceLocation(piece, nextLand);
        if (_state.pieceLocation(Piece.blessingIcons) == nextLand) {
          logLine('>Icons are captured.');
          _state.setPieceLocation(Piece.blessingIcons, Location.offmap);
        }
        return true;
      }
    } else {
      final religion = _state.landBaseReligion(nextLand);
      logLine('>${nextLand.desc} holds to its ${religion.adjective} faith.');
    }
    return false;
  }

  List<Piece> pathRallyArmyCandidates(Path path) {
    final candidates = <Piece>[];
    final pieceType = _state.pathArmyType(path);
    for (final army in pieceType.pieces) {
      if (!_state.armyCursed(army)) {
        final location = _state.pieceLocation(army);
        if (location.isType(LocationType.pathLand)) {
          final status = _state.armyStatus(army);
          if (status == ArmyStatus.shattered || (status == ArmyStatus.weak && ![Piece.armyByzantineAfrican, Piece.armyByzantineCaucasian].contains(army))) {
            candidates.add(army);
          }
        }
      }
    }
    return candidates;
  }

  // Sequence Helpers

  void greatKingOrRevolt(Path path, int actionPoints, bool revolt, Piece? associatedArmy, Piece baqtArmy, Piece nextArmy, String? kingDesc, String? revoltDesc) {
    Piece? baqt = _state.pathBaqt(path);
    if (revolt && baqt == null && _state.pathActiveArmy(path) != baqtArmy) {
      return;
    }
    if (_subStep == 0) {
      if (revolt) {
        if (path == Path.african) {
          logLine('### Revolt: Africa');
        } else {
          logLine('### Revolt: Caucasus');
        }
      } else {
        if (path == Path.african) {
          logLine('### Great King: Africa');
        } else {
          logLine('### Great King: Caucasus');
        }
      }
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (baqt == null) {
        revolt = false;
      }
      if (baqt != null && baqt.isType(PieceType.baqtFull)) {
        if (choicesEmpty()) {
          setPrompt('Break ${path.desc} Baqt?');
          choiceChoosable(Choice.yes, true);
          choiceChoosable(Choice.no, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.no)) {
          logLine('>Baqt remains in place.');
          removeGreatKing();
          return;
        }
        clearChoices();
        revolt = true;
      }
      if (revolt) {
        if (revoltDesc != null) {
          logLine('>$revoltDesc');
        } else {
          logLine('>${baqtArmy.desc} Revolts.');
        }
        _state.setPieceLocation(baqt!, Location.offmap);
        if (baqt.isType(PieceType.baqtPartial)) {
          _state.setPieceLocation(baqtArmy, _state.pathBaqtLand(path, 1));
        } else {
          final activeLand = _state.pieceLocation(nextArmy);
          final revoltLand = _state.pathBaqtLand(path, 2);
          if (activeLand.index <= revoltLand.index) {
            final retreatLand = _state.pathBaqtLand(path, 3);
            logLine('>${nextArmy.desc} Retreats to ${retreatLand.desc}.');
            _state.setPieceLocation(nextArmy, retreatLand);
          }
          _state.setPieceLocation(baqtArmy, revoltLand);
        }
        _state.setArmyStatus(baqtArmy, ArmyStatus.strong);
      }
      if (kingDesc != null && _state.pathActiveArmy(path) == associatedArmy) {
        logLine('>$kingDesc');
      }
      createGreatKing(path, actionPoints);
    }
  }

  // Events

  void baqtAfrican() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Baqt: Africa');
    logLine('>The Caliphate opens negotiations with Nubia.');
    _state.setEventActive(Event.baqtAfrican);
  }

  void baqtCaucasian() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Baqt: Caucasus');
    logLine('>The Caliphate opens negotiations with Armenia.');
    _state.setEventActive(Event.baqtCaucasian);
  }

  void berberRevolt() {
    if (!_state.landIslamic(Location.landTingitana, true)) {
      return;
    }
    if (_state.landControl(Location.landTingitana) != Control.arab) {
      return;
    }
    if (_state.pieceLocation(Piece.armyBerber) != Location.boxBerberRevolt) {
      return;
    }
    logLine('### Berber Revolt');
    if (_state.eventActive(Event.munnuzaDefects)) {
      logLine('>Munnuza leads the Berber revolt against the Arab Caliphate.');
      logLine('>Berbers convert to Catholicism.');
      _state.berbersConvertToCatholicism();
    } else {
      logLine('>Berbers in ${Location.landTingitana.desc} revolt against the Arab Caliphate.');
    }
    _state.setPieceLocation(Piece.armyBerber, Location.landTingitana);
  }

  void bulgarsDocile() {
    if (!_state.bulgarsWild) {
      return;
    }
    logLine('### Bulgars Docile');
    logLine('>Bulgar Khanate bides its time.');
    _state.tibetBadass = false;
  }

  void bulgarsLeft() {
    bool right = false;
    if (_state.landControl(Location.landConstantinople) == Control.arab) {
      right = true;
    } else {
      final castle = _state.pieceInLocation(PieceType.capital, Location.landConstantinople);
      if (castle != null && _state.castleBesieged(castle)) {
        right = true;
      }
    }
    var box = _state.bulgarsBox;
    if (right) {
      if (box == Location.boxBulgarsN1) {
        return;
      }
      logLine('### Bulgars');
      if (box == Location.boxBulgarsZ) {
        logLine('>Bulgar Hits: -1');
        box = Location.boxBulgarsN1;
      } else {
        logLine('>Bulgar Hits: 0');
        box = Location.boxBulgarsZ;
      }
    } else {
      if (box == Location.boxBulgarsP1) {
        return;
      }
      logLine('### Bulgars');
      if (box == Location.boxBulgarsZ) {
        logLine('>Bulgar Hits: +1');
        box = Location.boxBulgarsP1;
      } else {
        logLine('>Bulgar Hits: 0');
        box = Location.boxBulgarsZ;
      }
    }
    _state.bulgarsBox = box;
  }

  void bulgarsWild() {
    if (_state.bulgarsWild) {
      return;
    }
    logLine('### Bulgars Wild');
    logLine('>Bulgar Khanate looks to expand.');
    _state.bulgarsWild = true;
  }

  void caliphUmarI() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Caliph Umar Ⅰ');
    _state.setEventActive(Event.caliphUmarI);
    if (_state.landReligion(Location.landDamascus, true) == Religion.islamic) {
      activateSyrians();
    }
  }

  void capitalMove() {
    final candidates = <Location>[];
    for (final land in [Location.landRome, Location.landConstantinople, Location.landCarthage]) {
      if (_state.landControl(land) == Control.player) {
        final path = _state.landPath(land)!;
        if (_state.pathHasByzantineArmy(path)) {
          candidates.add(land);
        }
      }
    }
    if (candidates.isEmpty) {
      return;
    }
    if (candidates.length == 1 && _state.pieceLocation(_state.byzantineCapitalPiece) == candidates[0]) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Capital Move');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select Land to Move Byzantine Capital to');
        for (final land in candidates) {
          locationChoosable(land);
        }
        throw PlayerChoiceException();
      }
      final land = selectedLocation()!;
      clearChoices();
      if (land == _state.pieceLocation(_state.byzantineCapitalPiece)) {
        logLine('>Byzantine Capital remains in ${land.desc}.');
        return;
      }
      logLine('>Byzantine Capital relocates to ${land.desc}.');
      _state.setPieceLocation(_state.byzantineCapitalPiece, land);
    }
  }
 
  void carolingians() {
    logLine('### Carolingians');
    logLine('>Carolingian Kingdom strengthens.');
    _state.setEventActive(Event.carolingians);
  }

  void countJulian() {
    const army = Piece.armyVisigoth;
    final armyLocation = _state.pieceLocation(army);
    if (armyLocation == Location.offmap && _state.landIslamic(Location.landAquitaine, false)) {
      return;
    }
    logLine('### Count Julian');
    logLine('>Renegade governor allies with the Muslims.');
    final status = _state.armyStatus(army);
    switch (status) {
    case ArmyStatus.strong:
      setArmyStatus(army, ArmyStatus.weak);
    case ArmyStatus.weak:
      setArmyStatus(army, ArmyStatus.shattered);
    case ArmyStatus.shattered:
      final retreatLand = _state.pathSucceedingLand(Path.mediterranean, armyLocation)!;
      logLine('>${army.desc} retreats to ${retreatLand.desc}.');
      _state.setPieceLocation(army, retreatLand);
    }
    final islam = _state.pathIslamPiece(Path.mediterranean);
    final islamLand = _state.pieceLocation(islam);
    if (_state.landControl(islamLand) == Control.arab) {
      final activeArmy = _state.pathActiveArmy(Path.mediterranean)!;
      final activeLand = _state.pieceLocation(activeArmy);
      final newIslamLand = activeLand == Location.landParis ? Location.landAquitaine : activeLand;
      logLine('>Islam advances to ${newIslamLand.desc}.');
      _state.setPieceLocation(_state.pathIslamUndisruptedPiece(Path.mediterranean), newIslamLand);
    } 
  }

  void cyprusLeft() {
    if (!_state.muslimNavyActive) {
      return;
    }
    var box = _state.cyprusBox;
    if (box == Location.boxCyprusP1) {
      return;
    }
    logLine('### Cyprus');
    if (box == Location.boxCyprusZ) {
      logLine('>Cyptus Hits: +1');
      box = Location.boxCyprusP1;
    } else {
      logLine('>Cyprus Hits: 0');
      box = Location.boxCyprusZ;
    }
    _state.cyprusBox = box;
  }

  void cyprusLeftAlexandria() {
    if (_state.landControl(Location.landAlexandria) == Control.arab) {
      cyprusLeft();
    }
  }

  void cyprusLeftAnatolia() {
    if (_state.landControl(Location.landAnatolia) == Control.arab) {
      cyprusLeft();
    }
  }

  void cyprusLeftCarthage() {
    if (_state.landControl(Location.landCarthage) == Control.arab) {
      cyprusLeft();
    }
  }

  void cyprusLeftJerusalem() {
    if (_state.landControl(Location.landJerusalem) == Control.arab) {
      cyprusLeft();
    }
  }

  void dahlakIslandsFall() {
    if (!_state.advancedGame) {
      return;
    }
    const army = Piece.armyAxum;
    final land = _state.pieceLocation(army);
    if (land == Location.landAxum) {
      return;
    }
    logLine('### Dahlak Islands Fall');
    final retreatLand = _state.pathSucceedingLand(Path.african, land)!;
    logLine('>${army.desc} retreats to ${retreatLand.desc}.');
    _state.setPieceLocation(army, retreatLand);
  }

  void dayOfThirst() {
    if (_state.landControl(Location.landTransoxiana) != Control.arab) {
      return;
    }
    logLine('### Day of Thirst');
    logLine('>Arab defeats frighten their Tibetan allies.');
    var box = _state.tibetBox;
    if (box != Location.boxTibetN1) {
      if (box == Location.boxTibetZ) {
        logLine('>Tibetan Hits: -1');
        box = Location.boxTibetN1;
      } else {
        logLine('>Tibetan Hits: 0');
        box = Location.boxTibetZ;
      }
      _state.tibetBox = box;
      return;
    }
    adjustEastAPTokens(1);
  }

  void holdEcumenicalCouncil() {
    if (choicesEmpty()) {
      setPrompt('Select Byzantine Religion');
      locationChoosable(Location.boxByzantineReligionCatholic);
      locationChoosable(Location.boxByzantineReligionOrthodox);
      locationChoosable(Location.boxByzantineReligionMonophysite);
      throw PlayerChoiceException();
    }
    final religionBox = selectedLocation()!;
    var religionMarker = Piece.byzantineReligion;
    var prevReligionBox = _state.pieceLocation(religionMarker);
    if (prevReligionBox == Location.flipped) {
      religionMarker = Piece.byzantineReligionSchism;
      prevReligionBox = _state.pieceLocation(religionMarker);
    }
    final religion = _state.byzantineReligionBoxReligion(religionBox);
    if (religionBox == prevReligionBox) {
      logLine('>Byzantine Religion remains ${religion.adjective}.');
      if (religionMarker == Piece.byzantineReligionSchism) {
        logLine('>Schism is resolved.');
        _state.setPieceLocation(Piece.byzantineReligion, religionBox);
      }
    } else {
      logLine('>Byzantium adopts ${religion.noun}, causing a Schism');
      _state.setPieceLocation(Piece.byzantineReligionSchism, religionBox);
      if (religion == Religion.christianMonophysite && _state.currentCard == Card.chainedAndNailedByFear1) {
        logLine('>King Varaztiroits II succeeds in Armenia.');
        _state.setPieceLocation(Piece.armyByzantineCaucasian, Location.offmap);
        _state.setPieceLocation(Piece.armyArmenian, Location.landNsibis);
        createGreatKing(Path.caucasian, 2);
      }
    }
    clearChoices();
  }

  void ecumenicalCouncil() {
    if (!_state.advancedGame) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Ecumenical Council');
      _subStep = 1;
    }
    if (_subStep == 1) {
      holdEcumenicalCouncil();
    }
  }

  void empressWu() {
    logLine('### Empress Wu');
    logLine('>Empress Wu strengthens Tang China.');
    _state.setEventActive(Event.empressWu);
  }

  void endOfAnEra() {
    if (_subStep == 0) {
      logLine('### End of an Era');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Choose Byzantine Empire Last Stand');
        choiceChoosable(Choice.lastStandActionPoints, true);
        choiceChoosable(Choice.lastStandSkill, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.lastStandActionPoints)) {
        logLine('>Byzantine Empire Last Stand: 2AP');
        _state.setPieceLocation(Piece.byzantineLastStandAP, Location.boxByzantineLastStand);
      } else {
        logLine('>Byzantine Empire Last Stand: +1 Skill');
        _state.setPieceLocation(Piece.byzantineLastStandSkill, Location.boxByzantineLastStand);
      }
      clearChoices();
      _subStep == 2;
    }
    if (_subStep == 2) {
      if (_state.persiaSurvives) {
        if (choicesEmpty()) {
          setPrompt('Choose Persian Empire Last Stand');
          choiceChoosable(Choice.lastStandActionPoints, true);
          choiceChoosable(Choice.lastStandSkill, true);
          throw PlayerChoiceException();
        }
        if (checkChoice(Choice.lastStandActionPoints)) {
          logLine('>Persian Empire Last Stand: 2AP');
          _state.setPieceLocation(Piece.persianLastStandAP, Location.boxPersianLastStand);
        } else {
          logLine('>Persian Empire Last Stand: +1 Skill');
          _state.setPieceLocation(Piece.persianLastStandSkill, Location.boxPersianLastStand);
        }
        clearChoices();
      }
      _subStep == 3;
    }
    if (_subStep == 3) {
      if (_state.advancedGame) {
        if (_state.jihadActive) {
          logLine('>Jihad ends.');
          _state.jihadEnd();
        }
        if (_state.byzantineSchism) {
          logLine('>Schism ends.');
           _state.byzantineSchism = false;
        }
        if (_state.byzantiumTruce) {
          logLine('>Greek Truce ends.');
          _state.exitByzantiumTruce();
        }
        if (_state.persiaTruce) {
          logLine('>Persia Truce ends.');
          _state.exitPersiaTruce();
        }
      }
    }
  }

  void excubitors() {
    logLine('### Excubitors');
    logLine('>Élite Byzantine forces arrive.');
    _state.setPieceLocation(Piece.excubitors2, Location.boxExcubitors);
  }

  void feignedConversion() {
    if (!_state.advancedGame) {
      return;
    }
    final army = _state.pathActiveArmy(Path.caucasian)!;
    final land = _state.pieceLocation(army);
    if (land == Location.landNsibis) {
      return;
    }
    logLine('### Feigned Conversion');
    logLine('>Caucasian ruler pretends to convert to Islam.');
    final toLand = _state.pathPrecedingLand(Path.caucasian, land)!;
    logLine('>${army.desc} advances to ${toLand.desc}.');
    _state.setPieceLocation(army, toLand);
  }

  void greatKingAfrican3AP() {
    if (!_state.advancedGame) {
      return;
    }
    greatKingOrRevolt(Path.african, 3, false, Piece.armyNubian, Piece.armyNubian, Piece.armyAxum, 'Cyriacus, King of Nubia', null);
  }

  void greatKingCaucasian3AP() {
    if (!_state.advancedGame) {
      return;
    }
    greatKingOrRevolt(Path.caucasian, 3, false, Piece.armyKhazar, Piece.armyArmenian, Piece.armyKhazar, 'Alp Tarkhan, Khazar Ruler', null);
  }

  void greatKingCaucasian4AP() {
    if (!_state.advancedGame) {
      return;
    }
    greatKingOrRevolt(Path.caucasian, 4, false, Piece.armyKhazar, Piece.armyArmenian, Piece.armyKhazar, 'Khazar Prince Barjik', null);
  }

  void greekFire() {
    if (_state.pieceLocation(Piece.blessingFleetP1) == Location.flipped) {
      return;
    }
    logLine('### Greek Fire');
    logLine('>Greek scientists create a type of flamethrower devastating to enemy ships.');
    _state.flipPiece(Piece.blessingFleetP1);
  }

  void gregoryRevolts() {
    if (_state.byzantineRulerSkill > 4) {
      return;
    }
    final armyLocation = _state.pieceLocation(Piece.armyByzantineMediterranean);
    if (![Location.landSufetula, Location.landCarthage].contains(armyLocation)) {
      return;
    }
    logLine('### Gregory Revolts');
    logLine('>Gregory the Patrician, Exarch of Africa, declares himself Emperor.');
    final castle = _state.pieceInLocation(PieceType.castle, Location.landCarthage);
    if (castle != null) {
      _state.setPieceLocation(castle, Location.boxOutOfPlay);
    }
    final iconsLocation = _state.pieceLocation(Piece.blessingIcons);
    if (iconsLocation.isType(LocationType.pathMediterranean)) {
      _state.setPieceLocation(Piece.blessingIcons, Location.boxBlessingsUsed);
    }
    _state.setPieceLocation(Piece.armyByzantineMediterranean, Location.offmap);
    _state.setPieceLocation(Piece.armyExarchate, armyLocation);
  }

  void iconoclasm() {
    if (_state.pieceLocation(Piece.blessingThemes) != Location.flipped) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Iconoclasm');
      logLine('>Veneration of religious images is forbidden.');
      if (_state.landIslamic(Location.landGreece, true)) {
        _state.setPieceLocation(Piece.blessingThemes, Location.offmap);
        return;
      }
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select Land to establish Themes in');
        for (final land in [Location.landAnatolia, Location.landGreece]) {
          if (!_state.landIslamic(land, true)) {
            locationChoosable(land);
          }
        }
        throw PlayerChoiceException();
      }
      final land = selectedLocation()!;
      logLine('>Themes are established in ${land.desc}.');
      _state.setPieceLocation(Piece.blessingThemes, land);
      clearChoices();
      _subStep = 2;
    }
    if (_subStep == 2) {
      if (_state.advancedGame) {
        holdEcumenicalCouncil();
      }
    }
  }

  void imperialVisit() {
    logLine('### Imperial Visit');
    logLine('>The Byzantine Emperor visits Rome.');
    _state.setEventActive(Event.imperialVisit);
  }

  void intolerance() {
    final paths = candidateConversionPaths;
    if (paths.isEmpty) {
      return;
    }
    logLine('### Intolerance');
    logLine('>Caliph persecutes and taxes non-Muslims.');
    for (final path in paths) {
      pathConversionCheck(path, true);
    }
  }

  void jewsInBalanjar() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Jews in Balanjar');
    logLine('>Jews in Balanjar are treated with tolerance.');
    _state.setPieceLocation(Piece.jewsN1, Location.landBalanjar);
  }

  void jewsInHispania() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Jews in Hispania');
    logLine('>Jews in Hispania experience persecution.');
    _state.setPieceLocation(Piece.jewsP1, Location.landHispania);
  }

  void jewsInJerusalem() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Jews in Jerusalem');
    logLine('>Jews in Jerusalem experience persecution.');
    _state.setPieceLocation(Piece.jewsP1, Location.landJerusalem);
  }

  void jihadGreece() {
    if (!_state.advancedGame) {
      return;
    }
    bool dead = _state.jihadPathDead(Path.greek);
    if (dead && !_state.jihadActive) {
      return;
    }
    logLine('### Jihad vs. Greece');
    if (dead) {
      logLine('>Jihad ends.');
      _state.jihadEnd();
      return;
    }
    logLine('>Jihad declared against the Byzantine Empire.');
    _state.jihadInitiate([Path.greek]);
  }

  void jihadPersia() {
    if (!_state.advancedGame) {
      return;
    }
    final paths = <Path>[];
    for (final path in [Path.parthian, Path.indian]) {
        if (!_state.jihadPathDead(path)) {
            paths.add(path);
        }
    }
    if (paths.isEmpty && !_state.jihadActive) {
      return;
    }
    logLine('### Jihad vs. Persia');
    if (paths.isEmpty) {
      logLine('>Jihad ends.');
      _state.jihadEnd();
      return;
    }
    logLine('>Jihad declared against the Persian Empire.');
    _state.jihadInitiate(paths);
  }

  void karabisianTheme() {
    logLine('### Karabisian Theme');
    logLine('>Greek Fleet is very active.');
    _state.setEventActive(Event.karabisianTheme);
  }

  void khriMangSlonRtsan() {
    const army = Piece.armyChinese;
    final land = _state.pieceLocation(army);
    final status = _state.armyStatus(army);
    var box = _state.tibetBox;
    if (land == Location.landKushinne && status == ArmyStatus.shattered && box == Location.boxTibetP1) {
      return;
    }
    logLine('### Khri-Mang-Slon-Rtsan');
    logLine('>Tibet attacks Tang China.');
    switch (status) {
    case ArmyStatus.strong:
      setArmyStatus(army, ArmyStatus.weak);
    case ArmyStatus.weak:
      setArmyStatus(army, ArmyStatus.shattered);
    case ArmyStatus.shattered:
      final retreatLand = _state.pathSucceedingLand(Path.parthian, land)!;
      logLine('>${army.desc} retreats to ${retreatLand.desc}.');
      _state.setPieceLocation(army, retreatLand);
    }
    if (box == Location.boxTibetP1) {
      return;
    }
    if (box == Location.boxTibetZ) {
      logLine('>Tibetan Hits: +1');
      box = Location.boxTibetP1;
    } else {
      logLine('>Tibetan Hits: 0');
      box = Location.boxTibetZ;
    }
    _state.tibetBox = box;
  }

  void leaderCaliph(String title, String name, int strength) {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### $title');
    logLine('>$name succeeds as Caliph.');
    adjustSyrianStrength(strength);
  }

  void leaderGeneral(String title, String name, int strength) {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### $title');
    logLine('>$name leads Arab forces.');
    adjustSyrianStrength(strength);
  }

  void leaderAli() {
    leaderCaliph('Ali', 'Ali ibn Abi Talib', 1);
  }

  void leaderAlWalid() {
    leaderCaliph('al‑Walid', 'al‑Walid Ⅰ', 1);
  }

  void leaderGeneralHassanIbnAli() {
    leaderGeneral('General Hassan ibn Ali', 'Hassan ibn Ali', 2);
  }

  void leaderGeneralYazid() {
    leaderGeneral('General Yazid', 'Yazid ibn Muʼawiya ibn Abi Sufyan', 2);
  }

  void leaderGovernorHajjaj() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Governor Hajjaj');
    logLine('>al‑Hajjaj ibn Yusuf appointed Governor of occupied Persia.');
    adjustSyrianStrength(2);
  }

  void leaderHisham() {
    leaderCaliph('Hisham', 'Hisham', 2);
  }

  void leaderMarwanI() {
    leaderCaliph('Marwan Ⅰ', 'Marwan Ⅰ', 1);
  }

  void leaderMuawiya() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Muʼawiya');
    logLine('>Muʼawiya Ⅰ founds the Umayyad Caliphate.');
    adjustSyrianStrength(1);
  }

  void leaderPrinceMaslama() {
    leaderGeneral('Prince Maslama', 'Maslama ibn Abd al‑Malik', 2);
  }

  void leaderSulayman() {
    leaderCaliph('Sulayman', 'Sulayman', 1);
  }

  void leaderUmarII() {
    leaderCaliph('Umar Ⅱ', 'Umar Ⅱ', 2);
  }

  void leaderUmarIbnSaad() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Umar ibn Saʼad');
    logLine('>Umar ibn Saʼad leads Umayyad forces at the Battle of Karbala.');
    adjustSyrianStrength(1);
  }

  void leaderUthman() {
    leaderCaliph('Uthman', 'Uthman ibn Affan', 2);
  }

  void leaderYazid() {
    leaderCaliph('Yazid', 'Yazid Ⅰ', 2);
  }

  void lombards() {
    if (!_state.advancedGame) {
      return;
    }
    if (_state.bulgarsBox == Location.boxBulgarsP1) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Lombards');
      logLine('>Germanic tribes threaten Rome.');
      _subStep = 1;
    }
    if (choicesEmpty()) {
      setPrompt('Reduce Emperor’s Skill or shift Bulgars Left.');
      choiceChoosable(Choice.reduceEmperorSkill, _state.byzantineRulerSkill > 3);
      choiceChoosable(Choice.shiftBulgarsLeft, true);
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.reduceEmperorSkill)) {
      _state.byzantineRulerSkill = _state.byzantineRulerSkill - 1;
      logLine('>Byzantine Emperor’s Skill reduced to ${_state.byzantineRulerSkill}.');
    } else {
      var box = _state.bulgarsBox;
      if (box == Location.boxBulgarsZ) {
        logLine('>Bulgar Hits: +1');
        box = Location.boxBulgarsP1;
      } else {
        logLine('>Bulgar Hits: 0.');
        box = Location.boxBulgarsZ;
      }
      _state.bulgarsBox = box;
    }
    clearChoices();
  }

  void malabars() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Malabars');
    logLine('>Nestorian bishops in South India realign to the Monophysite Patriarch of Alexandria.');
    var box = _state.socotraBox;
    if (box != Location.boxSocotraN1) {
      if (box == Location.boxSocotraZ) {
        logLine('>Socotra Hits: -1');
        box = Location.boxSocotraN1;
      } else {
        logLine('>Socotra Hits: 0');
        box = Location.boxSocotraZ;
      }
      _state.bulgarsBox = box;
      return;
    }
    adjustEastAP(1);
  }

  void merovingians() {
    const army = Piece.armyFrankish;
    final land = _state.pieceLocation(army);
    final status = _state.armyStatus(army);
    if (land == Location.landParis && status == ArmyStatus.shattered) {
      return;
    }
    logLine('### Merovingians');
    logLine('>Merovingian Kingdom weakens.');
    switch (status) {
    case ArmyStatus.strong:
      setArmyStatus(army, ArmyStatus.weak);
    case ArmyStatus.weak:
      setArmyStatus(army, ArmyStatus.shattered);
    case ArmyStatus.shattered:
      final retreatLand = _state.pathSucceedingLand(Path.mediterranean, land)!;
      logLine('>${army.desc} retreats to ${retreatLand.desc}.');
      _state.setPieceLocation(army, retreatLand);
    }
  }

  void munnuzaDefects() {
    logLine('### Munnuza Defects');
    logLine('>Munnuza revolts against the Caliph.');
    _state.setEventActive(Event.munnuzaDefects);
    _state.advanceDeck();
    eventsPhaseEvent0();
  }

  void ohShiite() {
    logLine('### Oh Shi’ite!');
    logLine('>Sectarian violence breaks out across the Islamic world.');
    for (final islam in PieceType.islamUndisrupted.pieces) {
      final location = _state.pieceLocation(islam);
      if (location != Location.landMecca) {
        _state.flipPiece(islam);
      }
    }
  }

  void papalBull() {
    if (!_state.advancedGame) {
      return;
    }
    if (_state.byzantineSchism) {
      return;
    }
    logLine('### Papal Bull');
    logLine('>The Pope scuppers the Emperor’s plans for Christian unity.');
    _state.byzantineSchism = true;
  }

  void piroozRevolts() {
    logLine('### Pirooz Revolts');
    logLine('>Persian heir to the throne leads Zoroastrian revival vs. the Arabs.');
    _state.setEventActive(Event.piroozRevolts);
  }

  void queenKahina() {
    logLine('### Queen Kahina');
    logLine('>Berber ruler aids Byzantine fleet.');
    _state.setEventActive(Event.queenKahina);
  }

  void retrenchment() {
    bool logged = false;
    for (final path in Path.values) {
      final islam = _state.pathIslamDisruptedPiece(path);
      final location = _state.pieceLocation(islam);
      if (location != Location.flipped) {
        if (_state.landControl(location) != Control.player) {
          if (!logged) {
            logLine('### Retrenchment');
            logged = true;
          }
          logLine('>Islam strengthens in ${location.desc}.');
          _state.flipPiece(islam);
        }
      }
    }
    final paths = candidateConversionPaths;
    if (paths.isEmpty) {
      return;
    }
    if (!logged) {
      logLine('### Retrenchment');
      logged = true;
    }
    for (final path in paths) {
      if (!pathConversionCheck(path, true)) {
        final army = _state.pathActiveArmy(path);
        if (army != null) {
          final land = _state.pieceLocation(army);
          final prevLand = _state.pathPrecedingLand(path, land);
          if (prevLand != null && prevLand != Location.landMecca) {
            logLine('>${army.desc} advances into ${prevLand.desc}.');
            _state.setPieceLocation(army, prevLand);
          }
        }
      }
    }
  }

  void revoltAfrican() {
    if (!_state.advancedGame) {
      return;
    }
    greatKingOrRevolt(Path.african, 3, true, Piece.armyNubian, Piece.armyNubian, Piece.armyAxum, 'Mercurios', 'Mercurios unites the two northern Nubian kingdoms.');
  }

  void revoltCaucasian() {
    if (!_state.advancedGame) {
      return;
    }
    greatKingOrRevolt(Path.caucasian, 3, true, null, Piece.armyArmenian, Piece.armyKhazar, null, null);
  }

  void ridda() {
    logLine('### Ridda');
    logLine('>Mass apostasy from Islam occurs on the border.');
    _state.setEventActive(Event.ridda);
  }

  void rightlyGuidedArmy() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Rightly Guided Army');
    logLine('>Caliph Umar Ⅰ organizes the greatest army since Alexander the Great.');
  }

  void rulerByzantium(int eventModifier) {
    if (!_state.byzantiumSurvives) {
      return;
    }
    logLine('### New Emperor succeeds in Byzantium');
    int die = rollD6();
    int modifiers = 0;

    logTableHeader();
    logD6InTable(die);
    int skill = _state.byzantineRulerSkill;
    logLine('>|Predecessor Skill|$skill|');
    modifiers += skill;
    if (!_state.pieceInPlay(_state.byzantineCapitalPiece)) {
      logLine('>|No Capital|-1|');
      modifiers -= 1;
    }
    if (_state.advancedGame) {
      switch (_state.byzantineReligion) {
      case Religion.christianCatholic:
        logLine('>|Byzantium Catholic|+2|');
        modifiers += 2;
      case Religion.christianMonophysite:
        logLine('>|Byzantium Monophysite|-2|');
        modifiers -= 2;
      default:
      }
      if (_state.byzantineSchism) {
        logLine('>|Schism|-1|');
        modifiers -= 1;
      }
    }
    if (eventModifier > 0) {
      logLine('>|Event|+$eventModifier|');
    } else if (eventModifier < 0) {
      logLine('>|Event|$eventModifier|');
    }
    modifiers += eventModifier;
    final total = die + modifiers;
    logLine('>|Total|$total|');
    logTableFooter();

    int newSkill = _state.newRulerSkill(total);
    _state.newByzantineRuler(newSkill);
    logLine('>Emperor ${_state.byzantineEmperorName} has Skill $newSkill.');
  }

  void rulerByzantiumN1() {
    rulerByzantium(-1);
  }

  void rulerByzantiumP1() {
    rulerByzantium(1);
  }

  void rulerByzantiumZ() {
    rulerByzantium(0);
  }

  void rulerPersia(int eventModifier) {
    if (!_state.persiaSurvives) {
      return;
    }
    logLine('### New Shah succeeds in Persia');
    int die = rollD6();
    int modifiers = 0;

    logTableHeader();
    logD6InTable(die);
    int skill = _state.persianRulerSkill;
    logLine('>|Predecessor Skill|$skill|');
    modifiers += skill;
    if (!_state.pieceInPlay(_state.persianCapitalPiece)) {
      logLine('>|No Capital|-1|');
      modifiers -= 1;
    }
    if (eventModifier > 0) {
      logLine('>|Event|+$eventModifier|');
    } else if (eventModifier < 0) {
      logLine('>|Event|$eventModifier|');
    }
    modifiers += eventModifier;
    final total = die + modifiers;
    logLine('>|Total|$total|');
    logTableFooter();

    int newSkill = _state.newRulerSkill(total);
    _state.newPersianShah(newSkill);
    logLine('>New Shah has Skill: $newSkill');
  }

  void rulerPersiaN1() {
    rulerPersia(-1);
  }

  void rulerPersiaP1() {
    rulerPersia(1);
  }

  void rulerPersiaZ() {
    rulerPersia(0);
  }

  void saintDemetrius() {
    logLine('### St. Demetrius');
    logLine('>Bishop of Thessalonica inspires victory over invading Slavs.');
    var box = _state.bulgarsBox;
    if (box != Location.boxBulgarsN1) {
      if (box == Location.boxBulgarsZ) {
        logLine('>Bulgar Hits: -1');
        box = Location.boxBulgarsN1;
      } else {
        logLine('>Bulgar Hits: 0');
        box = Location.boxBulgarsZ;
      }
      _state.bulgarsBox = box;
      return;
    }
    if (_state.byzantineRulerSkill < 7) {
      _state.byzantineRulerSkill = _state.byzantineRulerSkill + 1;
      logLine('>Byzantine Emperor’s Skill increased to ${_state.byzantineRulerSkill}.');
      return;
    }
    adjustWestAPTokens(1);
  }

  void sardinianRaids() {
    logLine('### Sardinian Raids');
    logLine('>Focus of naval struggle shifts to the Western Mediterranean.');
    _state.flipPiece(Piece.cyprusGreek);
  }

  void sclaviniae() {
    logLine('### Sclaviniae');
    logLine('>Slavic Volunteers.');
    _state.setEventActive(Event.sclaviniae);
  }

  void shariaLaw() {
    if (!_state.advancedGame) {
      return;
    }
    if (_state.pieceLocation(Piece.noShariaLaw) != Location.boxShariaLaw) {
      return;
    }
    logLine('### Sharia Law');
    logLine('>Caliph Umar Ⅰ codifies Islamic Law.');
    _state.setEventActive(Event.shariaLaw);
  }

  void socotraLeft() {
    if (!_state.advancedGame) {
      return;
    }
    var box = _state.socotraBox;
    if (box == Location.boxSocotraP1) {
      return;
    }
    logLine('### Socotra');
    if (box == Location.boxSocotraZ) {
      logLine('>Muslim Navy gains control of the Indian Ocean.');
      box = Location.boxSocotraP1;
    } else {
      logLine('>Muslim Navy challenges for control of the Indian Ocean.');
      box = Location.boxSocotraZ;
    }
    _state.socotraBox = box;
  }

  void socotraLeftSindh() {
    if (_state.landControl(Location.landSindh) == Control.arab) {
      socotraLeft();
    }
  }

  void socotraLeftYezd() {
    if (_state.landControl(Location.landYezd) == Control.arab) {
      socotraLeft();
    }
  }

  void suluAssassinated() {
    final location = _state.pieceLocation(Piece.armyTurgesh);
    if (!location.isType(LocationType.land)) {
      return;
    }
    logLine('### Sülü Assassinated');
    logLine('>${Piece.armySogdian.desc} replaces ${Piece.armyTurgesh} on ${Path.parthian.desc}.');
    _state.setPieceLocation(Piece.armyTurgesh, Location.offmap);
    _state.setArmyStatus(Piece.armyTurgesh, ArmyStatus.strong);
    _state.setPieceLocation(Piece.armySogdian, location);
    _state.setArmyStatus(Piece.armySogdian, ArmyStatus.strong);
    final land = _state.pieceLocation(Piece.armyChinese);
    final advanceLand = _state.pathPrecedingLand(Path.parthian, land)!;
    logLine('>${Piece.armyChinese.desc} advances to ${advanceLand.desc}.');
    _state.setPieceLocation(Piece.armyChinese, advanceLand);
  }

  void suluTurgeshKhan() {
    final location = _state.pieceLocation(Piece.armySogdian);
    if (!location.isType(LocationType.land)) {
      return;
    }
    logLine('### Sülü, Türgesh Khan');
    logLine('>${Piece.armyTurgesh.desc} replaces ${Piece.armySogdian} on ${Path.parthian.desc}.');
    _state.setPieceLocation(Piece.armySogdian, Location.offmap);
    _state.setArmyStatus(Piece.armySogdian, ArmyStatus.strong);
    _state.setPieceLocation(Piece.armyTurgesh, location);
    _state.setArmyStatus(Piece.armyTurgesh, ArmyStatus.strong);
  }

  void tibetBadass() {
    if (_state.tibetBadass) {
      return;
    }
    logLine('### Tibet Badass');
    logLine('>Tibet’s rulers indulge their lust for empire.');
    _state.tibetBadass = true;
  }

  void tibetBuddhist() {
    if (!_state.tibetBadass) {
      return;
    }
    logLine('### Tibet Buddhist');
    logLine('>Tibet’s rulers turn to meditation and incense.');
    _state.tibetBadass = false;
  }

  void tibetLeft() {
    var box = _state.tibetBox;
    if (box == Location.boxTibetP1) {
      return;
    }
    if (box == Location.boxTibetZ) {
      logLine('### Tibet');
      logLine('>Tibetan Hits: +1');
      box = Location.boxTibetP1;
    } else {
      logLine('### Tibet');
      logLine('>Tibetan Hits: 0');
      box = Location.boxTibetZ;
    }
    _state.tibetBox = box;
  }

  void truceGreek() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Greek Truce');
    logLine('>The Caliphate opens negotiations with Byzantium.');
    _state.setEventActive(Event.truceGreek);
  }

  void trucePersian() {
    if (!_state.advancedGame) {
      return;
    }
    logLine('### Persian Truce');
    logLine('>The Caliphate opens negotiations with Persia.');
    _state.setEventActive(Event.trucePersian);
  }

  // Sequence of Play

  void turnBegin() {
    _state.clearEvents();
	  logLine('# ${_state.cardTitle(_state.currentCard)}');
  }

  void eventsPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Events Phase.');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Events Phase');
  }

  void eventsPhaseEvent(int sequence) {
    final eventHandlers = {
      Card.chainedAndNailedByFear1: [ecumenicalCouncil, karabisianTheme],
      Card.farewellSyria2: [caliphUmarI, trucePersian, rightlyGuidedArmy, shariaLaw, bulgarsLeft],
      Card.aMountainOfFire3: [tibetLeft],
      Card.noCountrySoDefenseless4: [rulerByzantiumZ, tibetBuddhist],
      Card.aJewishNationalHome5: [jewsInJerusalem, lombards, cyprusLeftAlexandria],
      Card.isItGodWhoCommandsYouToMurder6: [bulgarsLeft, rulerPersiaZ],
      Card.anAllianceWithHell7: [baqtCaucasian, rulerPersiaZ, socotraLeft],
      Card.allahDothBlotOut8: [leaderUthman, merovingians],
      Card.revoltOfTheExarchGregory9: [rulerByzantiumN1, papalBull, gregoryRevolts],
      Card.arabsInvadeCyprus10: [rulerPersiaN1, cyprusLeft, tibetLeft],
      Card.kalidurutSignsTheBaqt11: [baqtAfrican, rulerByzantiumZ, tibetLeft, socotraLeftYezd],
      Card.theBattleOfTheCamel12: [leaderAli, cyprusLeft, bulgarsLeft],
      Card.theUmayyadCaliphate13: [leaderMuawiya, endOfAnEra, bulgarsLeft, tibetBadass, karabisianTheme],
      Card.milkThePersians14: [jihadPersia, leaderGeneralHassanIbnAli, truceGreek, papalBull, khriMangSlonRtsan],
      Card.itIsTheEndOfTheWorld15: [rulerByzantiumZ, cyprusLeft, bulgarsLeft, capitalMove, imperialVisit],
      Card.theTheodosianWalls16: [leaderGeneralYazid, jihadGreece, cyprusLeft, saintDemetrius],
      Card.greekFire17: [greekFire, karabisianTheme],
      Card.theFourGarrisonsOfTheOccupiedWest18: [rulerPersiaZ, tibetLeft],
      Card.thePeaksOfLebanon19: [rulerByzantiumN1, bulgarsLeft, karabisianTheme],
      Card.councilOfConstantinople20: [ecumenicalCouncil, rulerPersiaN1, cyprusLeftJerusalem, socotraLeft],
      Card.asparukhKhanOfTheBulgars21: [leaderYazid, rulerPersiaZ, bulgarsLeft, bulgarsWild],
      Card.alpTarkhanKhazarRuler22: [leaderMarwanI, ohShiite, socotraLeft, lombards, greatKingCaucasian3AP],
      Card.theBattleOfKarbala23: [leaderUmarIbnSaad, malabars, sclaviniae],
      Card.theDomeOfTheRock24: [jewsInHispania, rulerByzantiumN1, socotraLeftSindh, tibetLeft],
      Card.revoltOfTheZanjiSlaves25: [endOfAnEra, greekFire, intolerance, tibetBuddhist, ridda],
      Card.aWarOverCoins26: [rulerByzantium, ecumenicalCouncil, papalBull, empressWu],
      Card.blacksAsInnumerableAsAnts27: [dahlakIslandsFall, rulerPersiaN1, socotraLeft],
      Card.kahinaQueenOfTheMoors28: [rulerByzantiumZ, tibetLeft, carolingians, queenKahina],
      Card.mercuriosKingOfNubia29: [revoltAfrican, rulerByzantiumN1, socotraLeftSindh, tibetLeft],
      Card.armeniaBetrayed30: [leaderAlWalid, intolerance, lombards, revoltCaucasian, cyprusLeftAnatolia, ridda],
      Card.piroozRevolts31: [rulerPersiaP1, cyprusLeft, piroozRevolts],
      Card.theArmyOfPeacocks32: [leaderPrinceMaslama, jihadPersia, bulgarsLeft],
      Card.treacherousCountJulian33: [rulerByzantiumN1, cyprusLeft, bulgarsLeft, countJulian],
      Card.iSeeHeadsReadyToBeCutOff34: [leaderGovernorHajjaj, jihadGreece, cyprusLeft, bulgarsDocile],
      Card.suluKhanOfTheTurgesh35: [leaderSulayman, intolerance, suluTurgeshKhan, cyprusLeft, bulgarsLeft, ridda],
      Card.egyptianSailorsMutiny36: [rulerByzantiumP1, tibetLeft, tibetBadass, karabisianTheme],
      Card.shameAndDegradation37: [leaderUmarII, endOfAnEra, intolerance, retrenchment, sardinianRaids, greekFire],
      Card.theMiseryOfDhimmitude38: [intolerance, dayOfThirst, ridda],
      Card.payTheJizya39: [leaderHisham, ohShiite, cyprusLeft, ridda],
      Card.iconoclasm40: [rulerByzantiumN1, iconoclasm, papalBull, bulgarsWild, cyprusLeft],
      Card.khazarPrinceBarjik41: [lombards, greatKingCaucasian4AP, cyprusLeftCarthage],
      Card.munnuzaHeartLampegia42: [munnuzaDefects],
      Card.charlesMartel43: [cyprusLeft, karabisianTheme],
      Card.revoltOfTheMurjiah44: [rulerPersia, cyprusLeft, tibetLeft],
      Card.fromoKesaro45: [suluAssassinated, tibetLeft, karabisianTheme],
      Card.theGreatBerberRevolt46: [berberRevolt, rulerByzantiumZ, bulgarsLeft],
      Card.theReligionOfTheIsraelitesIsBetter47: [jewsInBalanjar, rulerByzantiumN1, lombards, socotraLeftSindh],
      Card.cyriacusKingOfNubia48: [feignedConversion, greatKingAfrican3AP, intolerance, socotraLeft],
      Card.theBattleOfTheZab49: [ohShiite, excubitors, karabisianTheme],
      // Card.Card.iAmTheDestroyingAvenger50,
    };

    final handlers = eventHandlers[_state.currentCard]!;
    if (sequence >= handlers.length) {
      return;
    }
    handlers[sequence]();
  }

  void eventsPhaseEvent0() {
    eventsPhaseEvent(0);
  }

  void eventsPhaseEvent1() {
    eventsPhaseEvent(1);
  }

  void eventsPhaseEvent2() {
    eventsPhaseEvent(2);
  }

  void eventsPhaseEvent3() {
    eventsPhaseEvent(3);
  }

  void eventsPhaseEvent4() {
    eventsPhaseEvent(4);
  }

  void eventsPhaseEvent5() {
    eventsPhaseEvent(5);
  }

  void eventsPhaseTallyActionPoints() {
    final actionPoints = _state.cardActionPoints(_state.currentCard);
    int westAPIncrement = actionPoints[0];
    int eastAPIncrement = actionPoints[1];
    if (_state.byzantiumTruce) {
        westAPIncrement = 1;
    }
    if (_state.persiaTruce) {
        eastAPIncrement = 1;
    }
    adjustWestAP(westAPIncrement);
    adjustEastAP(eastAPIncrement);
    if (_state.advancedGame) {
      if (!_state.eventActive(Event.greatKingAfrican) && _state.pathBaqt(Path.african) != Piece.baqtAfricanFull) {
        adjustAfricaAP(1);
      }
      if (!_state.eventActive(Event.greatKingCaucasian) && _state.pathBaqt(Path.caucasian) != Piece.baqtCaucasianFull) {
        adjustCaucasusAP(1);
      }
    }
  }

  void eventsPhaseBreakTruce() {
    if (!_state.byzantiumTruce && !_state.persiaTruce) {
      return;
    }
    if (choicesEmpty()) {
      if (_state.byzantiumTruce) {
        setPrompt('Violate Greek Truce?');
      } else {
        setPrompt('Violate Persian Truce?');
      }
      choiceChoosable(Choice.yes, true);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    if (checkChoiceAndClear(Choice.no)) {
      return;
    }
    final actionPoints = _state.cardActionPoints(_state.currentCard);
    int westAPIncrement = actionPoints[0];
    int eastAPIncrement = actionPoints[1];
    if (_state.byzantiumTruce) {
      logLine('### Byzantine Empire violates Truce');
      _state.exitByzantiumTruce();
      adjustWestAP(westAPIncrement);
    } else {
      logLine('### Persian Empire violates Truce');
      _state.exitPersiaTruce();
      adjustEastAP(eastAPIncrement);
    }
    adjustSyrianStrength(1);
    clearChoices();
  }

  void darAlIslamPhaseBegin() {
    if (!_state.advancedGame) {
      return;
    }
    if (_state.pieceLocation(Piece.noShariaLaw) == Location.boxShariaLaw) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Dar al‐Islam Phase.');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Dar al‐Islam Phase');
    _phaseState = PhaseStateDarAlIslam();
  }

  void darAlIslamPhaseRoll() {
    if (!_state.advancedGame) {
      return;
    }
    if (_state.pieceLocation(Piece.noShariaLaw) == Location.boxShariaLaw) {
      return;
    }
    final phaseState = _phaseState as PhaseStateDarAlIslam;
    logLine('### Dar al‐Islam');
    final rolls = roll2D6();
    int modifiers = 0;

    logTableHeader();
    log2D6InTable(rolls);
    logLine('>|Syrian Strength|+${_state.syrianStrength}|');
    modifiers += _state.syrianStrength;
    int total = rolls.$3 + modifiers;
    logLine('>|Total|$total|');
    logTableFooter();

    phaseState.total = total;
  }

  void darAlIslamEventRefugeesMove(Piece refugees) {
    final refugeesLocation = _state.pieceLocation(refugees);
    if (_state.landControl(refugeesLocation) != Control.arab) {
      return;
    }
    logLine('### ${refugees.desc} Move');
    final newLocation = Location.values[refugeesLocation.index + 1];
    logLine('>${refugees.desc} move to ${newLocation.desc}.');
    _state.setPieceLocation(refugees, newLocation);
  }

  void darAlIslamEventIconsBaqt() {
    final iconsLocation = _state.pieceLocation(Piece.blessingIcons);
    if (iconsLocation.isType(LocationType.land)) {
      if (_state.landControl(iconsLocation) == Control.arab) {
        logLine('### Icons');
        logLine('>Icons are captured.');
        _state.setPieceLocation(Piece.blessingIcons, Location.offmap);
      }
    }
    final africanBaqt = _state.pathBaqt(Path.african);
    final caucasianBaqt = _state.pathBaqt(Path.caucasian);
    int fullBaqtCount = 0;
    if (africanBaqt == Piece.baqtAfricanFull) {
      fullBaqtCount += 1;
    }
    if (caucasianBaqt == Piece.baqtCaucasianFull) {
      fullBaqtCount += 1;
    }
    if (fullBaqtCount > 0) {
      logLine('### Baqt');
      adjustSharedAPTokens(fullBaqtCount);
    }
  }

  void darAlIsalmEventKharijites(Path path) {
    if (_state.jihadActive) {
      darAlIslamEventMardaiteRaid();
    } else {
      logLine('### Kharijites');
      if (_state.pathIslamDisrupted(path)) {
        logLine('>Kharijite uprising occurs on the ${path.desc} Path.');
        _state.setPieceLocation(Piece.arabStop, _state.pathBox(path));
      } else {
        final islamPiece = _state.pathIslamUndisruptedPiece(path);
        final islamLocation = _state.pieceLocation(islamPiece);
        logLine('>Kharijite uprising weakens Islam in ${islamLocation.desc}.');
        _state.flipPiece(islamPiece);
      }
    }
  }

  void darAlIslamEventKharijitesIndian() {
    darAlIsalmEventKharijites(Path.indian);
  }

  void darAlIslamEventKharijitesParthian() {
    darAlIsalmEventKharijites(Path.parthian);
  }

  void darAlIslamEventManicheesMove() {
    darAlIslamEventRefugeesMove(Piece.refugeesManichees);
  }

  void darAlIslamEventMardaitesMove() {
    darAlIslamEventRefugeesMove(Piece.refugeesMardaites);

  }

  void darAlIslamEventMardaiteRaid() {
    final land = _state.pieceLocation(Piece.refugeesMardaites);
    if (_state.landControl(land) != Control.arab) {
      return;
    }
    if (_state.pathIslamDisrupted(Path.greek)) {
      return;
    }
    logLine('### Mardaite Raid');
    final islamUndisrupted = _state.pathIslamUndisruptedPiece(Path.greek);
    final islamLocation = _state.pieceLocation(islamUndisrupted);
    logLine('>Mardaite Raid weakens Islam in $islamLocation.desc');
    _state.flipPiece(islamUndisrupted);
  }

  void darAlIslamEventParseesMove() {
    darAlIslamEventRefugeesMove(Piece.refugeesParsees);
  }

  void darAlIslamEventZabulistan() {
    if (_state.pathHasPersianArmy(Path.indian) || _state.pathHasPersianArmy(Path.parthian) || _state.jihadActive) {
      logLine('### Zabulistan');
      adjustEastAPTokens(1);
    } else {
      final zabulistan = _state.pieceInLocation(PieceType.zabulistan, Location.boxZabulistan);
      if (zabulistan != null) {
        logLine('### Zabulistan');
        if (zabulistan == Piece.zabulistanDefiant) {
          adjustSyrianStrength(-1);
        }
        final indianPathArmy = _state.pathActiveArmy(Path.indian)!;
        final parthianPathArmy = _state.pathActiveArmy(Path.parthian)!;
        final indianPathLocation = _state.pieceLocation(indianPathArmy);
        final parthianPathLocation = _state.pieceLocation(parthianPathArmy);
        final indianPathEndsOfTheEarth = _state.landIsEndsOfTheEarth(indianPathLocation);
        final parthianPathEndsOfTheEarth = _state.landIsEndsOfTheEarth(parthianPathLocation);
        if (!indianPathEndsOfTheEarth && !parthianPathEndsOfTheEarth) {
          if (zabulistan != Piece.zabulistanDefiant) {
            logLine('>Zabulistan defies the Arab advance.');
            _state.flipPiece(zabulistan);
          }
        } else if (indianPathEndsOfTheEarth && parthianPathEndsOfTheEarth) {
          logLine('>Zabulistan has been conquered by the Arabs.');
          _state.setPieceLocation(Piece.zabulistanDefiant, Location.offmap);
        } else {
          if (zabulistan != Piece.zabulistanSubdued) {
            logLine('>Zabulistan is subdued by the Arabs.');
            _state.flipPiece(zabulistan);
          }
        }
      }
    }
  }

  void darAlIslamPhaseEvent() {
    if (!_state.advancedGame) {
      return;
    }
    if (_state.pieceLocation(Piece.noShariaLaw) == Location.boxShariaLaw) {
      return;
    }
    final phaseState = _phaseState as PhaseStateDarAlIslam;
    final darAlIslamEventTable = [
      darAlIslamEventParseesMove,
      darAlIslamEventMardaiteRaid,
      darAlIslamEventIconsBaqt,
      darAlIslamEventManicheesMove,
      darAlIslamEventKharijitesIndian,
      darAlIslamEventKharijitesParthian,
      darAlIslamEventMardaiteRaid,
      darAlIslamEventParseesMove,
      darAlIslamEventManicheesMove,
      darAlIslamEventMardaitesMove,
      darAlIslamEventIconsBaqt,
      darAlIslamEventZabulistan,
      darAlIslamEventZabulistan,
      darAlIslamEventManicheesMove,
      darAlIslamEventParseesMove,
      darAlIslamEventMardaitesMove,
      darAlIslamEventIconsBaqt,
    ];
    darAlIslamEventTable[phaseState.total! - 4]();
  }

  void darAlIslamPhaseIntroduceShariaLaw() {
    if (!_state.advancedGame) {
      return;
    }
    if (_state.eventActive(Event.shariaLaw)) {
      _state.setPieceLocation(Piece.noShariaLaw, Location.offmap);
    }
  }

  void darAlIslamPhaseEnd() {
    if (!_state.advancedGame) {
      return;
    }
    _phaseState = null;
  }

  void arabPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Arab Phase.');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Arab Phase');
    _phaseState = PhaseStateArab();
  }

  void arabPhasePath(Path path) {
    final phaseState = _phaseState as PhaseStateArab;
    if (_subStep == 0) {
      final theater = _state.pathTheater(path);
      if (_state.theaterTruce(theater)) {
        logLine('>${path.desc}: Truce');
        return;
      }
      final baqt = _state.pathBaqt(path);
      if (baqt != null && baqt.isType(PieceType.baqtFull)) {
        logLine('>${path.desc}: Baqt');
        return;
      }
      int encodedHits = _state.cardPathEncodedHits(_state.currentCard, path);
      int hits = 0;
      bool fitna = false;
      if (encodedHits == -1) {
        fitna = true;
      } else if (encodedHits < -1) {
        if (_state.pathHasPersianArmy(path)) {
          hits = -encodedHits;
        } else {
          fitna = true;
        }
      } else if (encodedHits >= 10) {
        hits = encodedHits - 10;
        if (!_state.advancedGame) {
          hits += rollD6();
        }
      } else {
        hits = encodedHits;
      }
      if (fitna) {
        logLine('>${path.desc}: Fitna');
        final islam = _state.pathIslamPiece(path);
        final location = _state.pieceLocation(islam);
        if (location.isType(LocationType.pathLand)) {
          _state.flipPiece(islam);
        }
        return;
      }

      final invasionInfo = _state.pathInvasionInfo(path)!;
      final defendingArmy = invasionInfo.$1;
      final invadedLand = invasionInfo.$2;
      final invadingLand = invasionInfo.$3;
      var invadingLandIslamic = invasionInfo.$4;

      logLine('>${path.desc}: Arabs Invade ${invadedLand.desc} from ${invadingLand.desc}.');

      logTableHeader();
      logLine('>|Rose|$hits|');

      var crossing = _state.landCrossing(invadedLand);
      if (crossing != Crossing.ordinary && invadingLandIslamic) {
        crossing = Crossing.ordinary;
        invadingLandIslamic = false;
      }

      bool mujahideenUsed = false;

      if (path == Path.greek && _state.bulgarsHits == 1) {
        logLine('>|Bulgar Khanate|+1|');
        hits += 1;
      }
      if (path == _state.cyprusPath && _state.cyprusHits == 1) {
        logLine('>|Cyprus|+1|');
        hits += 1;
      }
      if (_state.advancedGame && _state.socotraPath == path && _state.socotraHits == 1) {
        logLine('>|Socotra|+1|');
        hits += 1;
      }
      if (path == Path.parthian && _state.tibetHits == 1) {
        logLine('>|Tibetan Empire|+1|');
        hits += 1;
      }
      if (invadingLandIslamic) {
        logLine('>|Invading Land Muslim|+1|');
        hits += 1;
      }
      if (_state.meccaStrong && _state.landIslamicCapital(invadingLand)) {
        logLine('>|Mecca Strong|+1|');
        hits += 1;
      }
      if (_state.advancedGame && _state.pieceLocation(Piece.jewsP1) == invadedLand) {
        logLine('>|Jews|+1|');
        hits += 1;
      }
      if (_state.advancedGame && _state.syrianPath == path) {
        int strength = _state.syrianStrength;
        logLine('>|Mujahideen|+$strength|');
        hits += strength;
        mujahideenUsed = true;
      }

      if (path == Path.greek && _state.bulgarsHits == -1) {
        logLine('>|Bulgar Khanate|-1|');
        hits -= 1;
      }
      if (path == _state.cyprusPath && _state.cyprusHits == -1) {
        logLine('>|Cyprus|-1|');
        hits -= 1;
      }
      if (_state.advancedGame && _state.socotraPath == path && _state.socotraHits == -1) {
        logLine('>|Socotra|-1|');
        hits -= 1;
      }
      if (path == Path.parthian && _state.tibetHits == -1) {
        logLine('>|Tibetan Empire|-1|');
        hits -= 1;
      }
      switch (crossing) {
      case Crossing.mountain:
        logLine('>|Crossing Mountains|-1|');
        hits -= 1;
      case Crossing.river:
        logLine('>|Crossing River|-2|');
        hits -= 2;
      case Crossing.straits:
        logLine('>|Crossing Straits|-2|');
        hits -= 2;
      case Crossing.ordinary:
      }
      if (_state.advancedGame && _state.pieceLocation(Piece.jewsN1) == invadedLand) {
        logLine('>|Jews|-1|');
        hits -= 1;
      }
      if (_state.pieceLocation(Piece.blessingThemes) == invadedLand) {
        logLine('>|Themes|-1|');
        hits -= 1;
      }
      logLine('>|Total|$hits|');
      logTableFooter();

      if (hits < 0) {
        hits = 0;
      }
      logLine('>Arabs inflict $hits Hits.');

      if (mujahideenUsed) {
        adjustSyrianStrength(-1);
        if (!_state.jihadActive) {
          _state.setPieceLocation(_state.mujahideenPiece, Location.boxCasbah);
        }
      }

      phaseState.hitsRemaining = hits;
      phaseState.defendingArmy = defendingArmy;
      phaseState.invadedLand = invadedLand;
      _subStep = 1;
    }
    while (_subStep == 1) {
      if (phaseState.hitsRemaining <= 0) {
        _subStep = 2;
        break;
      }
      final army = phaseState.defendingArmy!;
      if (choicesEmpty()) {
        setPrompt('Select how to take next Hit');
        final land = _state.pieceLocation(army);
        final castle = _state.pieceInLocation(PieceType.castle, land);
        final capital = _state.pieceInLocation(PieceType.capital, land);
        if (_state.armyStatus(army) != ArmyStatus.shattered) {
          choiceChoosable(Choice.lossDamageArmy, true);
        }
        bool retreatPossible = true;
        if (castle != null) {
          if (!_state.castleBesieged(castle)) {
            choiceChoosable(Choice.lossSiege, true);
            retreatPossible = false;
          } else if (castle.isType(PieceType.castleByzantineMajor)) {
            choiceChoosable(Choice.lossDamageCastle, true);
            retreatPossible = false;
          }
        }
        if (capital != null) {
          if ([Piece.capitalByzantineStrong, Piece.capitalPersianStrong].contains(capital)) {
            choiceChoosable(Choice.lossDamageCapital, true);
          } else {
            choiceChoosable(Choice.lossDestroyCapital, true);
          }
          retreatPossible = false;
        }
        if (retreatPossible && _state.pathSucceedingLand(path, land) != null) {
          if (_state.piecesInLocationCount(PieceType.army, land) == 1) {
            choiceChoosable(Choice.lossRetreat, true);
          }
        }
        if (choosableChoiceCount == 0) {
          choiceChoosable(Choice.lossCursed, true);
        }
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.lossDamageArmy)) {
        final oldStatus = _state.armyStatus(army);
        final newStatus = ArmyStatus.values[oldStatus.index + 1];
        logLine('>${army.desc} becomes ${newStatus.desc}.');
        _state.setArmyStatus(army, newStatus);
        phaseState.hitsRemaining -= 1;
      } else if (checkChoiceAndClear(Choice.lossDamageCastle)) {
        final land = _state.pieceLocation(army);
        final castle = _state.pieceInLocation(PieceType.castle, land)!;
        logLine('>${castle.desc} becomes Weak.');
        _state.flipPiece(castle);
        phaseState.hitsRemaining -= _state.castleStrength(castle);
      } else if (checkChoiceAndClear(Choice.lossDamageCapital)) {
        final land = _state.pieceLocation(army);
        final capital = _state.pieceInLocation(PieceType.capital, land)!;
        logLine('>${capital.desc} becomes Weak.');
        _state.flipPiece(capital);
        phaseState.hitsRemaining -= 1;
      } else if (checkChoiceAndClear(Choice.lossDestroyCapital)) {
        final land = _state.pieceLocation(army);
        final capital = _state.pieceInLocation(PieceType.capital, land)!;
        logLine('>${capital.desc} is Destroyed.');
        _state.capitalDestroy(capital);
        phaseState.hitsRemaining -= 1;
      } else if (checkChoiceAndClear(Choice.lossRetreat)) {
        final land = _state.pieceLocation(army);
        final castle = _state.pieceInLocation(PieceType.castle, land);
        final nextLand = _state.pathSucceedingLand(path, land)!;
        logLine('>${army.desc} Retreats to ${nextLand.desc}.');
        _state.setPieceLocation(army, nextLand);
        if (castle != null) {
          logLine('>${castle.desc} is Destroyed.');
          _state.castleDestroy(castle);
          if (!_state.armyCursed(army)) {
            logLine('>${army.desc} becomes Cursed.');
            _state.setArmyCursed(army, true);
          }
          phaseState.hitsRemaining -= 3;
        } else {
          phaseState.hitsRemaining -= 2;
        }
      } else if (checkChoiceAndClear(Choice.lossSiege)) {
        final land = _state.pieceLocation(army);
        final castle = _state.pieceInLocation(PieceType.castle, land)!;
        logLine('>${army.desc} Retreats inside ${castle.desc}.');
        _state.setCastleBesieged(castle, true);
        phaseState.hitsRemaining -= _state.castleStrength(castle);
      } else if (checkChoiceAndClear(Choice.lossCursed)) {
        logLine('>${army.desc} becomes Cursed.');
        _state.setArmyCursed(army, true);
        phaseState.hitsRemaining = 0;
      }
    }
    if (_subStep == 2) {
      phaseState.hitsRemaining = 0;
      phaseState.defendingArmy = null;
      phaseState.invadedLand = null;
    }
  }

  void arabPhaseGreekPath() {
    arabPhasePath(Path.greek);
  }

  void arabPhaseMediterraneanPath() {
    arabPhasePath(Path.mediterranean);
  }

  void arabPhaseAfricanPath() {
    if (!_state.advancedGame) {
      return;
    }
    arabPhasePath(Path.african);
  }

  void arabPhaseIndianPath() {
    arabPhasePath(Path.indian);
  }

  void arabPhaseParthianPath() {
    arabPhasePath(Path.parthian);
  }

  void arabPhaseCaucasianPath() {
    if (!_state.advancedGame) {
      return;
    }
    arabPhasePath(Path.caucasian);
  }

  void arabPhaseEnd() {
    _phaseState = null;
  }

  void actionsPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Actions Phase.');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Actions Phase');
    _phaseState = PhaseStateActions();
  }

  void actionsPhaseInit() {
    final phaseState = _phaseState as PhaseStateActions;
    if (_state.advancedGame && _state.pieceLocation(Piece.christianDamascus) == Location.landDamascus && _state.landControl(Location.landDamascus) == Control.player) {
      logLine('### Control Christian Damascus');
      adjustSharedAPTokens(2);
      phaseState.christianDamascusClaimed = true;
    }
  }

  void actionsPhasePaths(Theater theater, List<Path> paths, bool barbarian, bool reserveForBarbarian) {
    final phaseState = _phaseState as PhaseStateActions;
    if (_subStep == 0) {
      var heading = '### Actions for ${paths[0].desc}';
      if (paths.length > 1) {
        heading += ' and ${paths[1].desc}';
      }
      logLine(heading);
      phaseState.apAvailable = _state.theaterAP(theater);
      if (reserveForBarbarian) {
        phaseState.apAvailable -= 1;
      }
      phaseState.apSpent = 0;
      _subStep = 1;
    }
    if (_subStep == 1) {
      setPrompt('Select Action');
      int apAvailable = phaseState.apAvailable;
      bool truce = _state.theaterTruce(theater);
      if (!truce) {
        bool canAttack = false;
        bool canAffordAttack = false;
        for (final path in paths) {
          final cost = _state.pathAttackCost(path);
          if (cost != null) {
            canAttack = true;
            if (cost <= apAvailable) {
              canAffordAttack = true;
            }
          }
        }
        if (canAttack) {
          choiceChoosable(Choice.actionAttack, canAffordAttack);
        }
        bool canRally = false;
        bool canAffordRally = false;
        for (final path in paths) {
          final armies = pathRallyArmyCandidates(path);
          for (final army in armies) {
            canRally = true;
            if (armyRallyCost(army) <= apAvailable) {
              canAffordRally = true;
            }
          }
        }
        if (canRally) {
          choiceChoosable(Choice.actionRally, canAffordRally);
        }
    
        let queen_kahina = game.events_active[EVENT_QUEEN_KAHINA]
        let fleet_path = game.cyprus_path
        if (queen_kahina) {
            fleet_path = PATH_MED
        }

        if (ap_available >= 1 && paths.includes(fleet_path) && game.cyprus_hit != -1) {
            view.actions.battle_cyprus = 1
        }
    
        if (!truce && theater == THEATER_WEST && game.cyprus_hit == -1 && piece_location(BLESSING_FLEET) == BOX_BLESSING_AVAILABLE && !game.actions.amphibious_landing) {
            view.actions.landing = 1
        }
    
        if (ap_available >= 1 && theater == THEATER_WEST && (queen_kahina || game.cyprus_hit <= 0) && piece_location(BLESSING_FLEET) == BOX_BLESSING_AVAILABLE) {
            for (let path of paths) {
                if (!queen_kahina || path == PATH_MED) {
                    if (!path_islam_disrupted(path)) {
                        let land = path_islam_extent(path)
                        if (!land_islamic_capital(land)) {
                            view.actions.coastal_raid = 1
                            break
                        }
                    }
                }
            }
        }

        if (!truce && theater == THEATER_EAST && piece_location(BLESSING_IMMORTALS) == BOX_BLESSING_AVAILABLE) {
            if (game.immortals_modifier == 2) {
                view.actions.immortals_elephants = 1
            }
            view.actions.immortals_cavalry = 1
        }

        if (ap_available >= 1 && theater == THEATER_EAST && piece_location(BLESSING_IMMORTALS) == BOX_BLESSING_AVAILABLE) {
            for (let path of paths) {
                if (!path_islam_disrupted(path)) {
                    let land = path_islam_extent(path)
                    if (!land_islamic_capital(land)) {
                        view.actions.cavalry_raid = 1
                        break
                    }
                }
            }
        }
    
        if (ap_available >= 4 && [THEATER_WEST, THEATER_EAST].includes(theater)) {
            for (let castle = first_castle; castle < last_castle; ++castle) {
                if (piece_location(castle) == BOX_OUT_OF_PLAY) {
                    for (let path of paths) {
                        let castle_available = false
                        let country = path_active_country(path)
                        if (country === null) {
                        } else if (country == COUNTRY_BYZANTINE) {
                            castle_available = true
                        } else if (country == COUNTRY_PERSIAN) {
                            if ([CASTLE_BYZANTINE_MINOR_1, CASTLE_BYZANTINE_MINOR_2].includes(castle)) {
                                castle_available = true
                            }
                        }
                        if (castle_available) {
                            let candidates = path_build_castle_candidates(path)
                            if (candidates.length > 0) {
                                view.actions.build_castle = 1
                                break
                            }
                        }
                    }
                }
            }
        }
    
        if (ap_available >= 4 && theater == THEATER_WEST) {
            for (let path of paths) {
                let candidates = path_fix_castle_candidates(path)
                if (candidates.length > 0) {
                    view.actions.fix_castle = 1
                    break
                }
            }
        }
    
        if (ap_available >= 2 && [THEATER_WEST, THEATER_EAST].includes(theater)) {
            let capital = theater == THEATER_WEST ? CAPITAL_BYZANTINE : CAPITAL_PERSIAN
            if (piece_location(capital) == BOX_OUT_OF_PLAY) {
                for (let path of paths) {
                    let candidates = path_build_capital_candidates(path)
                    if (candidates.length > 0) {
                        view.actions.build_capital = 1
                        break
                    }
                }
            }
        }
    
        if (ap_available >= 2 && [THEATER_WEST, THEATER_EAST].includes(theater)) {
            for (let path of paths) {
                let candidate = path_fix_capital_candidate(path)
                if (candidate !== null) {
                    view.actions.fix_capital = 1
                    break
                }
            }
        }
    
        if (ap_available >= appease_bulgars_cost() && paths.includes(PATH_GREEK) && game.bulgars_hit != -1) {
            view.actions.appease_bulgars = 1
        }
    
        if (ap_available >= appease_tibet_cost() && paths.includes(PATH_PARTHIAN) && game.tibet_hit != -1) {
            view.actions.appease_tibet = 1
        }
    
        if (game.advanced) {
            if (ap_available >= 1 && paths.includes(game.socotra_path) && game.socotra_hit != -1) {
                view.actions.battle_socotra = 1
            }
        }
    
        if (ap_available >= 1 && paths.includes(PATH_INDIAN) && path_active_country(PATH_INDIAN) == COUNTRY_PERSIAN && game.immortals_modifier < 2) {
            view.actions.buy_elephants = 1
        }
    
        if (paths.includes(PATH_MED) && game.events_active[EVENT_CAROLINGIANS]) {
            view.actions.carolingians = 1
        }
    
        if (paths.includes(PATH_PARTHIAN) && game.events_active[EVENT_EMPRESS_WU]) {
            view.actions.empress_wu = 1
        }
    
        if (paths.includes(PATH_GREEK) && game.events_active[EVENT_IMPERIAL_VISIT]) {
            if (game.ruler_skill_byzantine >= 4) {
                view.actions.imperial_visit_ap = 1
            }
            if (game.ruler_skill_byzantine < 7) {
                view.actions.imperial_visit_skill = 1
            }
        }
    
        if (paths.includes(PATH_PARTHIAN) && game.events_active[EVENT_PIROOZ_REVOLTS]) {
            view.actions.pirooz_revolts = 1
        }
    
        if (theater != THEATER_EAST && game.events_active[EVENT_SCLAVINIAE]) {
            if (theater == THEATER_WEST) {
                view.actions.sclaviniae = 1
            } else {
                for (let path of paths) {
                    if (path_active_country(path) == COUNTRY_BYZANTINE) {
                        view.actions.sclaviniae = 1
                        break
                    }
                }
            }
        }
    
        if (theater == THEATER_WEST && game.last_stand_byzantine == LAST_STAND_AP) {
            if (theater_ap_available(theater, 0) + 1 < theater_ap_limit(theater)) {
                view.actions.last_stand = 1
            }
        }
        if (theater == THEATER_WEST && game.last_stand_byzantine == LAST_STAND_SKILL) {
            if (game.ruler_skill_byzantine < 7) {
                view.actions.last_stand = 1
            }
        }
        if (theater == THEATER_EAST && game.last_stand_persian == LAST_STAND_AP) {
            if (theater_ap_available(theater, 0) + 1 < theater_ap_limit(theater)) {
                view.actions.last_stand = 1
            }
        }
        if (theater == THEATER_EAST && game.last_stand_persian == LAST_STAND_SKILL) {
            if (game.ruler_skill_persian < 7) {
                view.actions.last_stand = 1
            }
        }
    
        if (theater == THEATER_WEST && game.blue_tokens > 0) {
            if (theater_ap_available(theater, 0) + 1 < theater_ap_limit(theater)) {
                view.actions.cash_blue = 1
            }
            if (view.actions.rally == 1) {
                view.actions.rally_blue = 1
            }
        }

        if (theater == THEATER_EAST && game.red_tokens > 0) {
            if (theater_ap_available(theater, 0) + 1 < theater_ap_limit(theater)) {
                view.actions.cash_red = 1
            }
            if (view.actions.rally == 1) {
                view.actions.rally_red = 1
            }
        }

        if (game.purple_tokens > 0) {
            if (theater_ap_available(theater, 6) + 1 < theater_ap_limit(theater)) {
                view.actions.cash_purple = 1
            }
            if (view.actions.rally == 1) {
                view.actions.rally_purple = 1
            }
        }

        if (game.advanced && !barbarian && ap_available >= 1) {
            let other_theaters = trade_theaters(theater, 1)
            for (let other_theater of other_theaters) {
                if (theater_ap_available(other_theater, 6) + 1 < theater_ap_limit(theater)) {
                    view.actions.trade = 1
                }
                let other_paths = theater_paths(other_theater)
                for (let other_path of other_paths) {
                    let armies = path_rally_army_candidates(other_path)
                    for (let army of armies) {
                        let cost = army_rally_cost(army)
                        if (ap_available >= cost && theater_trade_available(theater, other_theater, cost)) {
                            view.actions.rally_trade = 1
                            break
                        }
                    }
                }
            }
        }
   
        view.actions.next = 1
    },
    attack() {
        game.state = "action_attack_select_army"
    },
    rally() {
        game.state = "action_rally_select_army"
    },
    rally_trade() {
        game.state = "action_rally_trade_select_army"
    },
    landing() {
        log("Greek Fleet assists Attack with Amphibious Landing.")
        game.actions.amphibious_landing = true
        if (!game.events_active[EVENT_KARABISIAN_THEME] && !game.events_active[EVENT_QUEEN_KAHINA]) {
            set_piece_location(BLESSING_FLEET, BOX_BLESSING_USED)
        }
        play_in_sequence()
    },
    immortals_elephants() {
        log("Immortals elephants assist Attack.")
        game.actions.commit_immortals = 2
        set_piece_location(BLESSING_IMMORTALS, BOX_BLESSING_USED)
        play_in_sequence()
    },
    immortals_cavalry() {
        log("Immortals cavalry assist Attack.")
        game.actions.commit_immortals = 1
        set_piece_location(BLESSING_IMMORTALS, BOX_BLESSING_USED)
        play_in_sequence()
    },
    coastal_raid() {
        game.state = "action_coastal_raid_select_path"
    },
    cavalry_raid() {
        game.state = "action_cavalry_raid_select_path"
    },
    build_capital() {
        game.state = "action_build_capital_select_land"
    },
    fix_capital() {
        game.state = "action_fix_capital_select_capital"
    },
    appease_bulgars() {
        log("Appease the Bulgar Khanate.")
        action_spend_ap(appease_bulgars_cost())
        game.bulgars_hit -= 1
        play_in_sequence()
    },
    appease_tibet() {
        log("Appease the Tibetan Empire.")
        action_spend_ap(appease_tibet_cost())
        game.tibet_hit -= 1
        play_in_sequence()
    },
    battle_cyprus() {
        game.state = "action_naval_battle_for_cyprus"
    },
    battle_socotra() {
        log("Battle Socotra.")
        action_spend_ap(1)
        let die = roll_d6()
        log("Roll: " + die)
        let location = piece_location(REFUGEES_PARSEES)
        if (location_is_land(location) && land_control(location) == CONTROL_PLAYER) {
            log("Parsees: +1")
            die += 1
        }
        location = piece_location(ARMY_AXUM)
        if (location_is_land(location) && location <= LAND_ADULIS) {
            log("Axum controls " + land_name(LAND_ADULIS) + ": +1")
            die += 1
        }
        if (die >= 6) {
            log("Battle for Socotra succeeds.")
            game.socotra_hit -= 1
        } else {
            log("Battle for Socotra fails.")
        }
        log_br()
        play_in_sequence()
    },
    buy_elephants() {
        log("Buy Elephants from India.")
        action_spend_ap(1)
        game.immortals_modifier = 2
        play_in_sequence()
    },
    last_stand() {
        if (game.path_actions.theater == THEATER_WEST) {
            log("Byzantine Empire makes a Last Stand.")
            if (game.last_stand_byzantine == LAST_STAND_AP) {
                west_ap_adjust(2)
                game.path_actions.ap_available += 2
            } else {
                game.ruler_skill_byzantine += 1
                log("Ruler Skill: " + game.ruler_skill_byzantine)
            }
            game.last_stand_byzantine = null
        } else {
            log("Persian Empire make a Last Stand.")
            if (game.last_stand_persian == LAST_STAND_AP) {
                east_ap_adjust(2)
                game.path_actions.ap_available += 2
            } else {
                game.ruler_skill_persian += 1
                log("Ruler Skill: " + game.ruler_skill_persian)
            }
            game.last_stand_persian = null
        }
        play_in_sequence()
    },
    cash_blue() {
        log("Exchange Blue Bonus Token for Action Points.")
        blue_ap_tokens_adjust(-1)
        west_ap_adjust(1)
        game.path_actions.ap_available += 1
        play_in_sequence()
    },
    cash_red() {
        log("Exchange Red Bonus Token for Action Points.")
        red_ap_tokens_adjust(-1)
        east_ap_adjust(1)
        game.path_actions.ap_available += 1
        play_in_sequence()
    },
    cash_purple() {
        log("Exchange Purple Bonus Token for Action Points.")
        purple_ap_tokens_adjust(-1)
        switch (game.path_actions.paths[0]) {
        case PATH_GREEK:
        case PATH_MED:
            west_ap_adjust(1)
            break
        case PATH_AFRICAN:
            africa_ap_adjust(1)
            break
        case PATH_INDIAN:
        case PATH_PARTHIAN:
            east_ap_adjust(1)
            break
        case PATH_CAUCASUS:
            caucasus_ap_adjust(1)
            break
        }
        game.path_actions.ap_available += 1
        play_in_sequence()
    },
    trade() {
        game.state = "action_trade_select_destination"
    },
    next: advance_to_next_step

    }
  }

  void actionsPhaseGreekMedPaths() {
    if (!_state.westDivided) {
      actionsPhasePaths(Theater.western, [Path.greek, Path.mediterranean], false, false);
    }
  }

  void actionsPhaseGreekPath() {
    if (_state.westDivided) {
      actionsPhasePaths(Theater.western, [Path.greek], !_state.pathHasByzantineArmy(Path.greek), !_state.pathHasByzantineArmy(Path.mediterranean));
    }
  }

  void actionsPhaseMedPath() {
    if (_state.westDivided) {
      actionsPhasePaths(Theater.western, [Path.mediterranean], !_state.pathHasByzantineArmy(Path.mediterranean), false);
    }
  }
  
  void actionsPhaseAfricanPath() {
    if (_state.advancedGame && _state.pathBaqt(Path.african) != Piece.baqtAfricanFull) {
      actionsPhasePaths(Theater.african, [Path.african], !_state.pathHasByzantineArmy(Path.african) && !_state.africaHasGreatKing, false);
    }
  }

  void actionsPhaseIndianParthianPaths() {
    if (!_state.eastDivided) {
      actionsPhasePaths(Theater.eastern, [Path.indian, Path.parthian], false, false);
    }
  }

  void actionsPhaseIndianPath() {
    if (_state.eastDivided) {
      actionsPhasePaths(Theater.eastern, [Path.indian], !_state.pathHasPersianArmy(Path.indian), !_state.pathHasPersianArmy(Path.parthian));
    }
  }
  
  void actionsPhaseParthianPath() {
    if (_state.eastDivided) {
      actionsPhasePaths(Theater.eastern, [Path.parthian], !_state.pathHasPersianArmy(Path.parthian), false);
    }
  }

  void actionsPhaseCaucasianPath() {
    if (_state.advancedGame && _state.pathBaqt(Path.caucasian) != Piece.baqtCaucasianFull) {
      actionsPhasePaths(Theater.caucasian, [Path.caucasian], !_state.pathHasByzantineArmy(Path.caucasian) && !_state.caucasusHasGreatKing, false);
    }
  }

  void actionsPhaseEnd() {
    _phaseState = null;
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      eventsPhaseBegin,
      eventsPhaseEvent0,
      eventsPhaseEvent1,
      eventsPhaseEvent2,
      eventsPhaseEvent3,
      eventsPhaseEvent4,
      eventsPhaseEvent5,
      eventsPhaseTallyActionPoints,
      eventsPhaseBreakTruce,
      darAlIslamPhaseBegin,
      darAlIslamPhaseRoll,
      darAlIslamPhaseEvent,
      darAlIslamPhaseIntroduceShariaLaw,
      darAlIslamPhaseEnd,
      arabPhaseBegin,
      arabPhaseGreekPath,
      arabPhaseMediterraneanPath,
      arabPhaseAfricanPath,
      arabPhaseIndianPath,
      arabPhaseParthianPath,
      arabPhaseCaucasianPath,
      arabPhaseEnd,
      actionsPhaseBegin,
      actionsPhaseInit,
      actionsPhaseGreekMedPaths,
      actionsPhaseGreekPath,
      actionsPhaseMedPath,
      actionsPhaseAfricanPath,
      actionsPhaseIndianParthianPaths,
      actionsPhaseIndianPath,
      actionsPhaseParthianPath,
      actionsPhaseCaucasianPath,
      actionsPhaeEnd,
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

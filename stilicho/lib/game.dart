import 'dart:convert';
import 'dart:math';
import 'package:stilicho/db.dart';
import 'package:stilicho/random.dart';

enum Location {
  homeConstantine,
  homeVandals,
  homeGoths,
  regionBononia,
  regionDurocortorum,
  regionMediolanum,
  regionVerona,
  regionLocoritum,
  regionMogontiacum,
  regionAquitania,
  regionPyrenaeiMontes,
  regionGallaecia,
  regionDalmatia,
  regionTarsatica,
  regionAquileia,
  regionPollentia,
  regionFiesole,
  siegeArelate,
  siegeRavenna,
  siegeRoma,
  cityArelate,
  cityRavenna,
  cityRoma,
  leaderConstantine,
  leaderVandals,
  leaderGoths,
  armyConstantine,
  armyVandals,
  armyGoths,
  unactivated,
  surrendered,
  recovery,
  olympius0,
  olympius1,
  olympius2,
  olympius3,
  olympius4,
  olympius5,
  olympius6,
  olympius7,
  olympiusAdvocate,
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
  round1,
  round2,
  round3,
  roundHousekeeping,
  deckEnemy,
  deckRoman,
  discardsEnemy,
  discardsRoman,
  history,
  flipped,
  offmap,
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
  home,
  region,
  siege,
  city,
  leader,
  army,
  olympius,
  turn,
  round,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.space: [Location.homeConstantine, Location.cityRoma],
    LocationType.home: [Location.homeConstantine, Location.homeVandals],
    LocationType.region: [Location.regionBononia, Location.regionFiesole],
    LocationType.siege: [Location.siegeArelate, Location.siegeRoma],
    LocationType.city: [Location.cityArelate, Location.cityRoma],
    LocationType.leader: [Location.leaderConstantine, Location.leaderGoths],
    LocationType.army: [Location.armyConstantine, Location.armyGoths],
    LocationType.olympius: [Location.olympius0, Location.olympius7],
    LocationType.turn: [Location.turn1, Location.turn10],
    LocationType.round: [Location.round1, Location.roundHousekeeping],
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
      Location.homeConstantine: 'Constantine III Home Space',
      Location.homeGoths: 'Goths Home Space',
      Location.homeVandals: 'Vandals Home Space',
      Location.regionBononia: 'Bononia',
      Location.regionDurocortorum: 'Durocortorum',
      Location.regionMediolanum: 'Mediolanum',
      Location.regionVerona: 'Verona',
      Location.regionLocoritum: 'Locoritum',
      Location.regionMogontiacum: 'Mogontiacum',
      Location.regionAquitania: 'Aquitania',
      Location.regionPyrenaeiMontes: 'Pyrenaei Montes',
      Location.regionGallaecia: 'Gallaecia',
      Location.regionDalmatia: 'Dalmatia',
      Location.regionTarsatica: 'Tarsatica',
      Location.regionAquileia: 'Aquileia',
      Location.regionPollentia: 'Pollentia',
      Location.regionFiesole: 'Fiesole',
      Location.siegeArelate: 'Arelate Siege Space',
      Location.siegeRavenna: 'Ravenna Siege Space',
      Location.siegeRoma: 'Roma Siege Space',
      Location.cityArelate: 'Arelate',
      Location.cityRavenna: 'Ravenna',
      Location.cityRoma: 'Roma',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Diocese {
  hispania,
  septemProvinciae,
  gallia,
  britannia,
  italiaAnnonaria,
  italiaSuburbucaria,
  illyricum,
  germaniaMagna,
}

enum Path {
  constantine,
  vandals,
  goths,
}

extension PathExtension on Path {
  PieceType get enemyPieceType {
    const pathEnemyPieceTypes = {
      Path.constantine: PieceType.enemyConstantine,
      Path.goths: PieceType.enemyGoths,
      Path.vandals: PieceType.enemyVandals,
    };
    return pathEnemyPieceTypes[this]!;
  }
}

enum Piece {
  enemyConstantineBold,
  enemyConstantineDemoralized,
  enemyVandals0Bold,
  enemyVandals1Bold,
  enemyVandals0Demoralized,
  enemyVandals1Demoralized,
  enemyGoths0Bold,
  enemyGoths1Bold,
  enemyGoths0Demoralized,
  enemyGoths1Demoralized,
  leaderStilicho,
  leaderSymmachus,
  leaderSarus,
  leaderConstantius,
  comitatenses0,
  comitatenses1,
  comitatenses2,
  comitatenses3,
  comitatenses4,
  comitatenses5,
  comitatenses6,
  comitatenses7,
  comitatenses8,
  comitatenses9,
  comitatenses10,
  comitatenses11,
  comitatenses12,
  comitatenses13,
  garrison0,
  garrison1,
  garrison2,
  garrison3,
  garrison4,
  garrison5,
  garrison6,
  garrison7,
  garrison8,
  garrison9,
  garrison10,
  garrison11,
  garrison12,
  garrison13,
  olympius1,
  olympius2,
  unrest0,
  unrest1,
  unrest2,
  unrest3,
  unrest4,
  revolt0,
  revolt1,
  revolt2,
  revolt3,
  revolt4,
  truceBeginsConstantine,
  truceBeginsVandals,
  truceBeginsGoths,
  truceEndsConstantine,
  truceEndsVandals,
  truceEndsGoths,
  mutinyConstantine,
  mutinyVandals,
  mutinyGoths,
  constantineAttacksVandalsBegins,
  constantineAttacksVandalsEnds,
  deathOfAlaric,
  cannotAttack,
  purpleCloak,
  imperialWedding,
  markerTurn,
  markerRound,
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
  enemy,
  enemyConstantine,
  enemyConstantineDemoralized,
  enemyGoths,
  enemyGothsDemoralized,
  enemyVandals,
  enemyVandalsDemoralized,
  leader,
  comitatensesOrGarrison,
  comitatenses,
  garrison,
  unrest,
  revolt,
  truceBegins,
  mutiny,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.enemyConstantineBold, Piece.markerRound],
    PieceType.enemy: [Piece.enemyConstantineBold, Piece.enemyGoths1Demoralized],
    PieceType.enemyConstantine: [Piece.enemyConstantineBold, Piece.enemyConstantineDemoralized],
    PieceType.enemyConstantineDemoralized: [Piece.enemyConstantineDemoralized, Piece.enemyConstantineDemoralized],
    PieceType.enemyGoths: [Piece.enemyGoths0Bold, Piece.enemyGoths1Demoralized],
    PieceType.enemyGothsDemoralized: [Piece.enemyGoths0Demoralized, Piece.enemyGoths1Demoralized],
    PieceType.enemyVandals: [Piece.enemyVandals0Bold, Piece.enemyVandals1Demoralized],
    PieceType.enemyVandalsDemoralized: [Piece.enemyVandals0Demoralized, Piece.enemyVandals1Demoralized],
    PieceType.leader: [Piece.leaderStilicho, Piece.leaderConstantius],
    PieceType.comitatensesOrGarrison: [Piece.comitatenses0, Piece.garrison13],
    PieceType.comitatenses: [Piece.comitatenses0, Piece.comitatenses13],
    PieceType.garrison: [Piece.garrison0, Piece.garrison13],
    PieceType.unrest: [Piece.unrest0, Piece.unrest4],
    PieceType.revolt: [Piece.revolt0, Piece.revolt4],
    PieceType.truceBegins: [Piece.truceBeginsConstantine, Piece.truceBeginsGoths],
    PieceType.mutiny: [Piece.mutinyConstantine, Piece.mutinyGoths],
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

enum Card {
  enemyConstantineActivate1,
  enemyConstantineActivate2,
  enemyConstantineActivate3,
  enemyConstantineActivate4,
  enemyConstantineActivate5,
  enemyConstantineActivate6,
  enemyConstantineActivate7,
  enemyConstantineActivate8,
  enemyGothsActivate9,
  enemyGothsActivate10,
  enemyGothsActivate11,
  enemyGothsActivate12,
  enemyGothsActivate13,
  enemyGothsActivate14,
  enemyGothsActivate15,
  enemyGothsActivate16,
  enemyVandalsActivate17,
  enemyVandalsActivate18,
  enemyVandalsActivate19,
  enemyVandalsActivate20,
  enemyVandalsActivate21,
  enemyVandalsActivate22,
  enemyVandalsActivate23,
  enemyUnrestInHispania24,
  enemyUnrestInSeptumProvinciae25,
  enemyUnrestInGallia26,
  enemyUnrestInItaliaAnnonaria27,
  enemyRebellionInAfrica28,
  enemyCourtIntrigues29,
  enemyEasternAmbitions30,
  enemyInternalStrife31,
  enemyMutiny32,
  enemyGarrisonDefectsToConstantine33,
  enemyGarrisonOverrun34,
  enemyRetreat35,
  enemyQuietInTheWest36,
  enemyArrelateDeclaresForConstantine37,
  enemyGothsMarchOnRome38,
  enemyNonEstIstaPaxSedPactioServitutis39,
  enemyTroopsDefectToConstantine40,
  enemyOathBreakers41,
  enemyConstantineOnTheMove42,
  enemyUsurper43,
  enemyUnrestInItaliaSuburbicaria44,
  enemyRevolts45,
  enemyDeathOfSymmachus46,
  enemyOlympiusMovesAgainstStilicho47,
  enemyGothicRefugees48,
  enemyDeathOfAlaric49,
  enemyRexWandalorumEtAlanorum50,
  romanAction1,
  romanAction2,
  romanAction3,
  romanAction4,
  romanAction5,
  romanAction6,
  romanAction7,
  romanAction8,
  romanDefectors9,
  romanEnvoys10,
  romanDeception11,
  romanPanegyric12,
  romanConsulship13,
  romanScholaePalatinae14,
  romanFrankishMercenaries15,
  romanVexillatioPalatinae16,
  romanMajorCampaignAgainstTheGoths17,
  romanSupplyLines18,
  romanRout19,
  romanTacticalAdvantage20,
  romanFranksAttackTheVandals21,
  romanConstantineAttacksTheVandals22,
  romanReplenishTheRanks23,
  romanDivineIntervention24,
  romanAncientTerrorOfTheRomanName25,
  romanDaringManoeuvre26,
  romanCrushingDefeat27,
  romanMilitia28,
  romanConcessions29,
  romanEndMutiny30,
  romanTemporaryTruce31,
  romanAgentesInRebus32,
  romanOutwitYourFoes33,
  romanFortuna34,
  romanOrderlyRetreat35,
  romanRedeployment36,
  romanSiegeEngines37,
  romanAlliesInTheSenate38,
  romanBattleOfFaesulae39,
  romanBattleOfVerona40,
  romanHunMercenaries41,
  romanExperiencedCommander42,
  romanSpies43,
  romanDeathOfConstans44,
  romanPurpleCloak45,
  romanConstantius46,
  romanImperialWedding47,
  romanNotitiaDignitatum48,
  romanGerontius49,
  romanSerena50,
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
  enemy,
  roman,
}

extension CardTypeExtension on CardType {
  static const _bounds = {
    CardType.enemy: [Card.enemyConstantineActivate1, Card.enemyRexWandalorumEtAlanorum50],
    CardType.roman: [Card.romanAction1, Card.romanSerena50],
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

  List<Card> get cards {
    final cs = <Card>[];
    for (int index = firstIndex; index < lastIndex; ++index) {
      cs.add(Card.values[index]);
    }
    return cs;
  }
}

extension CardExtension on Card {
  String get desc {
    const cardDescs = {
    };
    return cardDescs[this]!;
  }

  bool isType(CardType cardType) {
    return index >= cardType.firstIndex && index < cardType.lastIndex;
  }

  bool get isLateWar {
    const lateWarCards = [
      Card.enemyOathBreakers41,
      Card.enemyConstantineOnTheMove42,
      Card.enemyUsurper43,
      Card.enemyUnrestInItaliaSuburbicaria44,
      Card.enemyRevolts45,
      Card.enemyDeathOfSymmachus46,
      Card.enemyOlympiusMovesAgainstStilicho47,
      Card.enemyGothicRefugees48,
      Card.enemyDeathOfAlaric49,
      Card.enemyRexWandalorumEtAlanorum50,
      Card.romanHunMercenaries41,
      Card.romanExperiencedCommander42,
      Card.romanSpies43,
      Card.romanDeathOfConstans44,
      Card.romanPurpleCloak45,
      Card.romanConstantius46,
      Card.romanImperialWedding47,
      Card.romanNotitiaDignitatum48,
      Card.romanGerontius49,
      Card.romanSerena50,
    ];
    return lateWarCards.contains(this);
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
      Scenario.standard: 'Standard (10 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<Location> _cardLocations = List<Location>.filled(Card.values.length, Location.offmap);
  List<Card> _enemyDeck = <Card>[];
  List<Card> _romanDeck = <Card>[];

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
   : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
   , _cardLocations = locationListFromIndices(List<int>.from(json['cardLocations']))
   , _enemyDeck = cardListFromIndices(List<int>.from(json['enemyDeck']))
   , _romanDeck = cardListFromIndices(List<int>.from(json['romanDeck']))
   ;

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'cardLocations': locationListToIndices(_cardLocations),
    'enemyDeck': cardListToIndices(_enemyDeck),
    'romanDeck': cardListToIndices(_romanDeck),
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.enemyConstantineBold: Piece.enemyConstantineDemoralized,
      Piece.enemyConstantineDemoralized: Piece.enemyConstantineBold,
      Piece.enemyVandals0Bold: Piece.enemyVandals0Demoralized,
      Piece.enemyVandals1Bold: Piece.enemyVandals1Demoralized,
      Piece.enemyVandals0Demoralized: Piece.enemyVandals0Bold,
      Piece.enemyVandals1Demoralized: Piece.enemyVandals1Bold,
      Piece.enemyGoths0Bold: Piece.enemyGoths0Demoralized,
      Piece.enemyGoths1Bold: Piece.enemyGoths1Demoralized,
      Piece.enemyGoths0Demoralized: Piece.enemyGoths0Bold,
      Piece.enemyGoths1Demoralized: Piece.enemyGoths1Bold,
      Piece.comitatenses0: Piece.garrison0,
      Piece.comitatenses1: Piece.garrison1,
      Piece.comitatenses2: Piece.garrison2,
      Piece.comitatenses3: Piece.garrison3,
      Piece.comitatenses4: Piece.garrison4,
      Piece.comitatenses5: Piece.garrison5,
      Piece.comitatenses6: Piece.garrison6,
      Piece.comitatenses7: Piece.garrison7,
      Piece.comitatenses8: Piece.garrison8,
      Piece.comitatenses9: Piece.garrison9,
      Piece.comitatenses10: Piece.garrison10,
      Piece.comitatenses11: Piece.garrison11,
      Piece.comitatenses12: Piece.garrison12,
      Piece.comitatenses13: Piece.garrison13,
      Piece.garrison0: Piece.comitatenses0,
      Piece.garrison1: Piece.comitatenses1,
      Piece.garrison2: Piece.comitatenses2,
      Piece.garrison3: Piece.comitatenses3,
      Piece.garrison4: Piece.comitatenses4,
      Piece.garrison5: Piece.comitatenses5,
      Piece.garrison6: Piece.comitatenses6,
      Piece.garrison7: Piece.comitatenses7,
      Piece.garrison8: Piece.comitatenses8,
      Piece.garrison9: Piece.comitatenses9,
      Piece.garrison10: Piece.comitatenses10,
      Piece.garrison11: Piece.comitatenses11,
      Piece.garrison12: Piece.comitatenses12,
      Piece.garrison13: Piece.comitatenses13,
      Piece.olympius1: Piece.olympius2,
      Piece.olympius2: Piece.olympius1,
      Piece.unrest0: Piece.revolt0,
      Piece.unrest1: Piece.revolt1,
      Piece.unrest2: Piece.revolt2,
      Piece.unrest3: Piece.revolt3,
      Piece.unrest4: Piece.revolt4,
      Piece.revolt0: Piece.unrest0,
      Piece.revolt1: Piece.unrest1,
      Piece.revolt2: Piece.unrest2,
      Piece.revolt3: Piece.unrest3,
      Piece.revolt4: Piece.unrest4,
      Piece.truceBeginsConstantine: Piece.truceEndsConstantine,
      Piece.truceBeginsVandals: Piece.truceEndsVandals,
      Piece.truceBeginsGoths: Piece.truceEndsGoths,
      Piece.truceEndsConstantine: Piece.truceBeginsConstantine,
      Piece.truceEndsVandals: Piece.truceBeginsVandals,
      Piece.truceEndsGoths: Piece.truceBeginsGoths,
      Piece.constantineAttacksVandalsBegins: Piece.constantineAttacksVandalsEnds,
      Piece.constantineAttacksVandalsEnds: Piece.constantineAttacksVandalsBegins,
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
    final location = pieceLocation(piece);
    final obverse = pieceFlipSide(piece)!;
    setPieceLocation(obverse, location);
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

  Location cardLocation(Card card) {
    return _cardLocations[card.index];
  }

  void setCardLocation(Card card, Location location) {
    _cardLocations[card.index] = location;
  }

  List<Card> cardsInLocation(CardType cardType, Location location) {
    final cards = <Card>[];
    for (final card in cardType.cards) {
      if (cardLocation(card) == location) {
        cards.add(card);
      }
    }
    return cards;
  }

  Card? cardInLocation(CardType cardType, Location location) {
    for (final card in cardType.cards) {
      if (cardLocation(card) == location) {
        return card;
      }
    }
    return null;
  }

  int cardsInLocationCount(CardType cardType, Location location) {
    int count = 0;
    for (final card in cardType.cards) {
      if (cardLocation(card) == location) {
        count += 1;
      }
    }
    return count;
  }

  // Spaces

  Diocese spaceDiocese(Location space) {
    const spaceDioceses = {
      Location.homeConstantine: Diocese.britannia,
      Location.homeVandals: Diocese.germaniaMagna,
      Location.homeGoths: Diocese.illyricum,
      Location.regionBononia: Diocese.gallia,
      Location.regionDurocortorum: Diocese.gallia,
      Location.regionMediolanum: Diocese.italiaAnnonaria,
      Location.regionVerona: Diocese.italiaAnnonaria,
      Location.regionLocoritum: Diocese.germaniaMagna,
      Location.regionMogontiacum: Diocese.gallia,
      Location.regionAquitania: Diocese.septemProvinciae,
      Location.regionPyrenaeiMontes: Diocese.hispania,
      Location.regionGallaecia: Diocese.hispania,
      Location.regionDalmatia: Diocese.illyricum,
      Location.regionTarsatica: Diocese.illyricum,
      Location.regionAquileia: Diocese.italiaAnnonaria,
      Location.regionPollentia: Diocese.italiaAnnonaria,
      Location.regionFiesole: Diocese.italiaSuburbucaria,
      Location.siegeArelate: Diocese.septemProvinciae,
      Location.siegeRavenna: Diocese.italiaAnnonaria,
      Location.siegeRoma: Diocese.italiaSuburbucaria,
      Location.cityArelate: Diocese.septemProvinciae,
      Location.cityRavenna: Diocese.italiaAnnonaria,
      Location.cityRoma: Diocese.italiaSuburbucaria,
    };
    return spaceDioceses[space]!;
  }

  bool spaceMayHoldGarrison(Location space) {
    if (space.isType(LocationType.siege)) {
      return false;
    }
    final diocese = spaceDiocese(space);
    if ([Diocese.britannia, Diocese.germaniaMagna, Diocese.illyricum].contains(diocese)) {
      return false;
    }
    if (space == Location.regionBononia) {
      return false;
    }
    return true;
  }

  bool spacePlayerControlled(Location space) {
    for (final path in Path.values) {
      int sequence = pathSpaceSequence(path, space);
      if (sequence >= 0) {
        final enemy = pathEnemyPiece(path);
        if (enemy == null) {
          break;
        }
        final enemySpace = pieceLocation(enemy);
        int enemySequence = pathSpaceSequence(path, enemySpace);
        if (enemySequence >= sequence) {
          return false;
        }
      }
    }
    return true;
  }

  Location citySiegeSpace(Location city) {
    const citySiegeSpaces = {
      Location.cityArelate: Location.siegeArelate,
      Location.cityRavenna: Location.siegeRavenna,
      Location.cityRoma: Location.siegeRoma,
    };
    return citySiegeSpaces[city]!;
  }

  Location siegeCitySpace(Location siege) {
    const siegeCitySpaces = {
      Location.siegeArelate: Location.cityArelate,
      Location.siegeRavenna: Location.cityRavenna,
      Location.siegeRoma: Location.cityRoma,
    };
    return siegeCitySpaces[siege]!;
  }

  bool spacePotentialCollision(Location space) {
    return [Location.regionDurocortorum, Location.regionVerona].contains(space);
  }

  // Dioceses

  int dioceseGarrisonCount(Diocese diocese) {
    int count = 0;
    for (final space in LocationType.space.locations) {
      if (spaceDiocese(space) == diocese) {
        if (pieceInLocation(PieceType.garrison, space) != null) {
          count += 1;
        }
      }
    }
    return count;
  }

  // Paths

  List<Location> pathSpaces(Path path) {
    const pathSpaces = {
      Path.constantine: [
        Location.homeConstantine,
        Location.regionBononia,
        Location.regionDurocortorum,
        Location.siegeArelate,
        Location.cityArelate,
        Location.regionMediolanum,
        Location.regionVerona,
        Location.siegeRavenna,
        Location.cityRavenna],
      Path.vandals: [
        Location.homeVandals,
        Location.regionLocoritum,
        Location.regionMogontiacum,
        Location.regionDurocortorum,
        Location.regionAquitania,
        Location.regionPyrenaeiMontes,
        Location.regionGallaecia,
      ],
      Path.goths: [
        Location.homeGoths,
        Location.regionDalmatia,
        Location.regionTarsatica,
        Location.regionAquileia,
        Location.regionVerona,
        Location.regionPollentia,
        Location.regionFiesole,
        Location.siegeRoma,
        Location.cityRoma,
      ],
    };
    return pathSpaces[path]!;
  }

  int pathSpaceSequence(Path path, Location space) {
    final spaces = pathSpaces(path);
    for (int i = 0; i < spaces.length; ++i) {
      if (spaces[i] == space) {
        return i;
      }
    }
    return -1;
  }

  Location? pathSequenceSpace(Path path, int sequence) {
    final spaces = pathSpaces(path);
    if (sequence >= spaces.length) {
      return null;
    }
    return spaces[sequence];
  }

  Location? pathNextSpace(Path path, Location space) {
    final spaces = pathSpaces(path);
    for (int i = 0; i < spaces.length; ++i) {
      if (spaces[i] == space) {
        if (i + 1 < spaces.length) {
          return spaces[i + 1];
        }
        return null;
      }
    }
    return null;
  }

  Location? pathPrevSpace(Path path, Location space) {
    final spaces = pathSpaces(path);
    for (int i = 0; i < spaces.length; ++i) {
      if (spaces[i] == space) {
        if (i > 0) {
          return spaces[i - 1];
        }
        return null;
      }
    }
    return null;
  }

  Piece? pathEnemyPiece(Path path) {
    for (final piece in path.enemyPieceType.pieces) {
      final location = pieceLocation(piece);
      if (location.isType(LocationType.space)) {
        return piece;
      }
    }
    return null;
  }

  Location pathEnemySpace(Path path) {
    return pieceLocation(pathEnemyPiece(path)!);
  }

  Location pathLeaderBox(Path path) {
    return Location.values[LocationType.leader.firstIndex + path.index];
  }

  Location pathArmyBox(Path path) {
    return Location.values[LocationType.army.firstIndex + path.index];
  }

  // Enemies

  Path enemyPath(Piece enemy) {
    if (enemy.isType(PieceType.enemyConstantine)) {
      return Path.constantine;
    }
    if (enemy.isType(PieceType.enemyGoths)) {
      return Path.goths;
    }
    if (enemy.isType(PieceType.enemyVandals)) {
      return Path.vandals;
    }
    return Path.vandals;
  }

  bool enemyIsDemoralized(Piece enemy) {
    final demoralizedEnemies = [
      Piece.enemyConstantineDemoralized,
      Piece.enemyGoths0Demoralized,
      Piece.enemyGoths1Demoralized,
      Piece.enemyVandals0Demoralized,
      Piece.enemyVandals1Demoralized,
    ];
    return demoralizedEnemies.contains(enemy);
  }

  int enemyAttackValue(Piece enemy) {
    const enemyAttackValues = {
      Piece.enemyConstantineBold: 6,
      Piece.enemyConstantineDemoralized: 5,
      Piece.enemyGoths0Bold: 5,
      Piece.enemyGoths1Bold: 6,
      Piece.enemyGoths0Demoralized: 4,
      Piece.enemyGoths1Demoralized: 5,
      Piece.enemyVandals0Bold: 4,
      Piece.enemyVandals1Bold: 5,
      Piece.enemyVandals0Demoralized: 3,
      Piece.enemyVandals1Demoralized: 4,
    };
    return enemyAttackValues[enemy]!;
  }

  // Leader / Army Boxes

  Path leaderBoxPath(Location leaderBox) {
    return Path.values[leaderBox.index - LocationType.leader.firstIndex];
  }

  Path armyBoxPath(Location armyBox) {
    return Path.values[armyBox.index - LocationType.leader.firstIndex];
  }

  Location leaderArmyBox(Location leaderBox) {
    return Location.values[LocationType.army.firstIndex + leaderBox.index - LocationType.leader.firstIndex];
  }

  Location armyLeaderBox(Location armyBox) {
    return Location.values[LocationType.leader.firstIndex + armyBox.index - LocationType.army.firstIndex];
  }

  // Comitatenses

  bool comitatensesMayBeAssignedToArmy(Location armyBox) {
    return piecesInLocationCount(PieceType.comitatenses, armyBox) < 6;
  }

  // Garrisons

  bool garrisonMayBePlacedInSpace(Location space) {
    if (!spaceMayHoldGarrison(space)) {
      return false;
    }
    final diocese = spaceDiocese(space);
    if (dioceseGarrisonCount(diocese) >= 1) {
      return false;
    }
    if (!spacePlayerControlled(space)) {
      return false;
    }
    return true;
  }

  // Leaders
  
  bool leaderMayBeAssignedToArmy(Piece leader, Location leaderBox) {
    if (leader == Piece.leaderSymmachus) {
      return false;
    }
    if (pieceInLocation(PieceType.leader, leaderBox) != null) {
      return false;
    }
    final armyBox = leaderArmyBox(leaderBox);
    if (piecesInLocationCount(PieceType.comitatenses, armyBox) == 0) {
      return false;
    }
    return true;
  }

  bool leaderMayBeAssignedAsAdvocate(Piece leader) {
    if (pieceInLocation(PieceType.leader, Location.olympiusAdvocate) != null) {
      return false;
    }
    return true;
  }

  // Turns

  int get currentTurn {
    return pieceLocation(Piece.markerTurn).index - LocationType.turn.firstIndex + 1;
  }

  String turnName(int turn) {
    return '$turn - ${405 + turn}';
  }

  // Cards

  Card get currentEnemyCard {
    return _enemyDeck[0];
  }

  Card get currentRomanCard {
    return _romanDeck[0];
  }

  void newEnemyDeckFromDiscards(Random random) {
    for (final card in cardsInLocation(CardType.enemy, Location.discardsEnemy)) {
      setCardLocation(card, Location.deckEnemy);
      _enemyDeck.add(card);
    }
    _enemyDeck.shuffle(random);
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

  void setupDecks(Random random) {
    for (final enemyCard in CardType.enemy.cards) {
      if (!enemyCard.isLateWar) {
        setCardLocation(enemyCard, Location.deckEnemy);
        _enemyDeck.add(enemyCard);
      }
    }
    _enemyDeck.shuffle(random);

    for (final romanCard in CardType.roman.cards) {
      if (!romanCard.isLateWar) {
        setCardLocation(romanCard, Location.deckRoman);
        _romanDeck.add(romanCard);
      }
    }
    _romanDeck.shuffle(random);
  }

  factory GameState.setupStandard(Random random) {

    var state = GameState();

    state.setupPieceTypes([
      (PieceType.comitatenses, Location.recovery),
      (PieceType.unrest, Location.offmap),
      (PieceType.truceBegins, Location.offmap),
      (PieceType.mutiny, Location.offmap),
    ]);

    state.setupPieces([
      (Piece.markerTurn, Location.turn1),
      (Piece.markerRound, Location.round1),
      (Piece.leaderSymmachus, Location.olympiusAdvocate),
      (Piece.comitatenses12, Location.unactivated),
      (Piece.comitatenses13, Location.unactivated),
      (Piece.leaderConstantius, Location.unactivated),
      (Piece.enemyConstantineBold, Location.regionBononia),
      (Piece.cannotAttack, Location.regionBononia),
      (Piece.enemyVandals0Bold, Location.regionDurocortorum),
      (Piece.enemyVandals1Bold, Location.offmap),
      (Piece.enemyGoths0Bold, Location.regionPollentia),
      (Piece.enemyGoths1Bold, Location.offmap),
      (Piece.olympius1, Location.olympius0),
      (Piece.constantineAttacksVandalsBegins, Location.offmap),
      (Piece.deathOfAlaric, Location.offmap),
      (Piece.purpleCloak, Location.offmap),
      (Piece.imperialWedding, Location.offmap),
      (Piece.leaderStilicho, Location.recovery),
      (Piece.leaderSarus, Location.recovery),
    ]);

    state.setupDecks(random);

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

class Game {
  final Scenario _scenario;
  final GameState _state;
  int _step = 0;
  int _subStep = 0;
  GameOutcome? _outcome;
  final GameOptions _options;
  String _log = '';
  PlayerChoiceInfo _choiceInfo = PlayerChoiceInfo();
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
    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
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

  int rollD6() {
    int die = _random.nextInt(6) + 1;
    logLine('> Roll: $die');
    return die;
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

  // High-Level Functions

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
  }

  // Sequence Helpers

  // Sequence of Play

  void setUpComitatensesAndGarrisons() {
    if (_state.currentTurn != 1) {
      return;
    }
    while (true) {
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      Piece? comitatenses = selectedPiece();
      if (comitatenses == null) {
        setPrompt('Select Comitatenses to deploy');
        for (final comitatenses in PieceType.comitatensesOrGarrison.pieces) {
          if (_state.pieceLocation(comitatenses) != Location.unactivated) {
            pieceChoosable(comitatenses);
          }
        }
        if (_state.piecesInLocationCount(PieceType.comitatenses, Location.recovery) == 0) {
          choiceChoosable(Choice.next, true);
        }
        throw PlayerChoiceException();
      }
      final location = selectedLocation();
      if (location == null) {
        setPrompt('Select Army Box or Garrison Space for Comitatenses');
        final comitatensesLocation = _state.pieceLocation(comitatenses);
        for (final armyBox in LocationType.army.locations) {
          if (armyBox != comitatensesLocation && _state.comitatensesMayBeAssignedToArmy(armyBox)) {
            locationChoosable(armyBox);
          }
        }
        for (final space in LocationType.space.locations) {
          if (space != comitatensesLocation && _state.garrisonMayBePlacedInSpace(space)) {
            locationChoosable(space);
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      Piece? garrison;
      if (comitatenses.isType(PieceType.comitatenses)) {
        garrison = _state.pieceFlipSide(comitatenses);
      } else {
        garrison = comitatenses;
        comitatenses = _state.pieceFlipSide(garrison);
      }
      if (location.isType(LocationType.army)) {
        _state.setPieceLocation(comitatenses!, location);
      } else {
        _state.setPieceLocation(garrison!, location);
      }
      clearChoices();
    }
  }

  void setUpLeaders() {
    if (_state.currentTurn != 1) {
      return;
    }
    while (true) {
      if (choicesEmpty()) {
        setPrompt('Select Leader to Assign');
        pieceChoosable(Piece.leaderStilicho);
        pieceChoosable(Piece.leaderSarus);
        choiceChoosable(Choice.next, _state.piecesInLocationCount(PieceType.leader, Location.recovery) == 0);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      final leader = selectedPiece()!;
      final location = selectedLocation();
      if (location != null) {
        _state.setPieceLocation(leader, location);
        clearChoices();
      } else {
        setPrompt('Select Army to assign Leader to');
        for (final leaderBox in LocationType.leader.locations) {
          if (_state.leaderMayBeAssignedToArmy(leader, leaderBox)) {
            locationChoosable(leaderBox);
          }
        }
        if (_state.pieceLocation(leader) != Location.recovery) {
          locationChoosable(Location.recovery);
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
    }
  }

  void turnBegin() {
    logLine('# Turn ${_state.turnName(_state.currentTurn)}');
  }

  void deploymentPhaseBegin() {
    if (_state.currentTurn == 1) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Deployment Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Deployment Phase');
  }

  void deploymentPhaseDeploy() {
    if (_state.currentTurn == 1) {
      return;
    }
    while (true) {
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      Piece? piece = selectedPiece();
      if (piece == null) {
        setPrompt('Select Comitatenses, Garrison or Leader to deploy');
        for (final comitatenses in PieceType.comitatensesOrGarrison.pieces) {
          if (_state.pieceLocation(comitatenses) != Location.unactivated) {
            pieceChoosable(comitatenses);
          }
        }
        for (final leader in PieceType.leader.pieces) {
          if (_state.pieceLocation(leader) != Location.unactivated) {
            pieceChoosable(leader);
          }

        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        return;
      }
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      final location = selectedLocation();
      if (location == null) {
        if (piece.isType(PieceType.comitatensesOrGarrison)) {
          setPrompt('Select Army Box or Garrison Space for Comitatenses');
          final comitatensesLocation = _state.pieceLocation(piece);
          for (final armyBox in LocationType.army.locations) {
            if (armyBox != comitatensesLocation && _state.comitatensesMayBeAssignedToArmy(armyBox)) {
              locationChoosable(armyBox);
            }
          }
          for (final space in LocationType.space.locations) {
            if (space != comitatensesLocation && _state.garrisonMayBePlacedInSpace(space)) {
              locationChoosable(space);
            }
          }
        } else {
          setPrompt('Select Army Box for Leader');
          for (final leaderBox in LocationType.leader.locations) {
            if (_state.leaderMayBeAssignedToArmy(piece, leaderBox)) {
              locationChoosable(leaderBox);
            }
          }
          if (_state.leaderMayBeAssignedAsAdvocate(piece)) {
            locationChoosable(Location.olympiusAdvocate);
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      final oldLocation = _state.pieceLocation(piece);
      if (piece.isType(PieceType.comitatensesOrGarrison)) {
        Piece? comitatenses;
        Piece? garrison;
        if (piece.isType(PieceType.comitatenses)) {
          comitatenses = piece;
          garrison = _state.pieceFlipSide(piece);
        } else {
          garrison = piece;
          comitatenses = _state.pieceFlipSide(garrison);
        }
        if (piece.isType(PieceType.garrison)) {
          if (location.isType(LocationType.army)) {
            logLine('> Garrison withdraws from ${oldLocation.desc} and joins {$location.desc}.');
          } else {
            logLine('> Garrison transfers from ${oldLocation.desc} to ${location.desc}.');
          }
        } else {
          if (location.isType(LocationType.army)) {
            if (oldLocation == Location.recovery) {
              logLine('> Comitatenses is deployed to ${location.desc}.');
            } else {
              logLine('> Comitatenses transfers from ${oldLocation.desc} to ${location.desc}.');
            }
          } else {
            if (oldLocation == Location.recovery) {
              logLine('> Garrison is established in ${location.desc}.');
            } else {
              logLine('> ${location.desc} is Garrisoned with Comitatenses from ${oldLocation.desc}.');
            }
          }
        }
        if (location.isType(LocationType.army)) {
          _state.setPieceLocation(comitatenses!, location);
        } else {
          _state.setPieceLocation(garrison!, location);
        }
        if (oldLocation.isType(LocationType.city)) {
          final enemy = _state.pieceInLocation(PieceType.enemy, _state.citySiegeSpace(oldLocation));
          if (enemy != null) {
            logLine('> ${enemy.desc} occupies ${oldLocation.desc}.');
            _state.setPieceLocation(enemy, oldLocation);
          }
        }
      } else {
        if (location == Location.olympiusAdvocate) {
          if (oldLocation == Location.recovery) {
            logLine('> ${piece.desc} is made Advocate.');
          } else {
            logLine('> ${piece.desc} is removed from ${oldLocation.desc} and made Advocate.');
          }

        } else {
          if (oldLocation == Location.recovery) {
            logLine('> ${piece.desc} is deployed to ${location.desc}.');
          } else if (oldLocation == Location.olympiusAdvocate) {
            logLine('> ${piece.desc} ceases being Adovate and is deployed to ${location.desc}.');
          } else {
            logLine('> ${piece.desc} transfers from ${oldLocation.desc} to ${location.desc}.');
          }
        }
        _state.setPieceLocation(piece, location);
      }
      clearChoices();
    }
  }

  void enemyPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Enemy Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Enemy Phase');
  }

  void attackGarrison(Piece besieger) {

  }

  void collisionAttack(Piece originalAttacker, Piece originalDefender) {
    var attacker = originalAttacker;
    var defender = originalDefender;
    final attackerSpace = _state.pieceLocation(attacker);
    final battleSpace = _state.pieceLocation(defender);
    logLine('> ${attacker.desc} Attacks ${defender.desc}.');
    while (true) {
      int attackerValue = _state.enemyAttackValue(attacker);
      int defenderValue = _state.enemyAttackValue(defender);
      logLine('> ${attacker.desc}: $attackerValue');
      int attackerDie = rollD6();
      int attackerTotal = attackerValue + attackerDie;
      logLine('> ${attacker.desc} total: $attackerTotal');
      if (attackerDie == 1) {
        if (!_state.enemyIsDemoralized(attacker)) {
          logLine('> ${attacker.desc} is Demoralized.');
          attacker = _state.pieceFlipSide(attacker)!;
        }
      } else if (attackerDie == 6) {
        if (_state.enemyIsDemoralized(attacker)) {
          logLine('> ${attacker.desc} is Emboldended.');
          attacker = _state.pieceFlipSide(attacker)!;
        }
      }
      logLine('> ${defender.desc}: $defenderValue');
      int defenderDie = rollD6();
      int defenderTotal = defenderValue + defenderDie;
      logLine('> ${defender.desc} total: $defenderTotal');
      if (defenderDie == 1) {
        if (!_state.enemyIsDemoralized(defender)) {
          logLine('> ${defender.desc} is Demoralized.');
          defender = _state.pieceFlipSide(defender)!;
        }
      } else if (defenderDie == 6) {
        if (_state.enemyIsDemoralized(defender)) {
          logLine('> ${defender.desc} is Emboldended.');
          defender = _state.pieceFlipSide(defender)!;
        }
      }
      if (attackerTotal > defenderTotal) {
        final defenderPath = _state.enemyPath(defender);
        final retreatSpace = _state.pathPrevSpace(defenderPath, battleSpace)!;
        logLine('> ${defender.desc} retreats to ${retreatSpace.desc}.');
        logLine('> ${attacker.desc} advances to ${battleSpace.desc}.');
        _state.setPieceLocation(defender, retreatSpace);
        _state.setPieceLocation(attacker, battleSpace);
        return;
      }
      if (attackerTotal < defenderTotal) {
        logLine('> ${defender.desc} holds off ${attacker.desc}.');
        _state.setPieceLocation(defender, battleSpace);
        _state.setPieceLocation(attacker, attackerSpace);
        return;
      }
    }
  }

  bool advanceConstantine() {
    final constantine = _state.pathEnemyPiece(Path.constantine)!;
    final space = _state.pieceLocation(constantine);
    if (space.isType(LocationType.siege)) {
      attackGarrison(constantine);
    }
    var nextSpace = _state.pathNextSpace(Path.constantine, space)!;
    if (_state.spacePotentialCollision(nextSpace)) {
      final enemy = _state.pieceInLocation(PieceType.enemy, nextSpace);
      if (enemy != null) {
        collisionAttack(constantine, enemy);
        return true;
      }
    }
    if (nextSpace.isType(LocationType.siege)) {
      final citySpace = _state.siegeCitySpace(nextSpace);
      if (_state.piecesInLocationCount(PieceType.garrison, citySpace) > 0) {
        logLine('> ${constantine.desc} lays siege to ${citySpace.desc}.');
        _state.setPieceLocation(constantine, nextSpace);
        return false;
      }
      nextSpace = citySpace;
    }
  }

  bool activateConstantine() {
    final constantine = _state.pathEnemyPiece(Path.constantine);
    if (constantine == null) {
      return false;
    }
    if (constantine.isType(PieceType.enemyConstantineDemoralized)) {
      logLine('> Constantine III is Emboldened.');
      _state.flipPiece(constantine);
      return true;
    }
    return advanceConstantine();
  }

  bool activateGoths() {

  }

  bool activateVandals() {

  }

  bool emboldenConstantine() {
    final constantine = _state.pathEnemyPiece(Path.constantine);
    if (constantine == null) {
      return false;
    }
    if (constantine.isType(PieceType.enemyConstantineDemoralized)) {
      logLine('> Constantine III is Emboldened.');
      _state.flipPiece(constantine);
    }
    return advanceConstantine();
  }

  bool emboldenGoths() {

  }

  bool emboldenVandals() {

  }

  void constantineActivate1() {
    logLine('### Constantine III');
    if (activateConstantine()) {
      activateConstantine();
    }
  }

  void constantineActivate2() {
    logLine('### Constantine III');
    if (activateConstantine()) {
      activateConstantine();
    }
  }

  void constantineActivate3() {
    logLine('### Constantine III');
    emboldenConstantine();
  }

  void constantineActivate4() {
    logLine('### Constantine III');
    activateConstantine();
  }

  void constantineActivate5() {
    logLine('### Constantine III');
    activateConstantine();
  }

  void constantineActivate6() {
    logLine('### Constantine III');
    activateConstantine();
  }

  void constantineActivate7() {
    logLine('### Constantine III');
    activateConstantine();
  }

  void constantineActivate8() {
    logLine('### Constantine III');
    activateConstantine();
  }

  void gothsActivate9() {
    if (emboldenGoths()) {
      activateGoths();
    }
  }

  void gothsActivate10() {
    emboldenGoths();
  }

  void gothsActivate11() {
    activateGoths();
  }

  void gothsActivate12() {
    activateGoths();
  }

  void gothsActivate13() {
    activateGoths();
  }

  void gothsActivate14() {
    activateGoths();
  }

  void gothsActivate15() {
    activateGoths();
  }

  void gothsActivate16() {
    activateGoths();
  }

  void vandalsActivate17() {
    activateVandals();
  }

  void vandalsActivate18() {
    activateVandals();
  }

  void vandalsActivate19() {
    activateVandals();
  }

  void vandalsActivate20() {
    activateVandals();
  }

  void vandalsActivate21() {
    activateVandals();
  }

  void vandalsActivate22() {
    activateVandals();
  }

  void vandalsActivate23() {
    activateVandals();
  }

  void unrestInHispania() {

  }

  void unrestInSeptumProvinciae() {

  }

  void unrestInGallia() {

  }

  void unrestInItaliaAnnonaria() {

  }

  void unrestInItaliaSuburbicaria() {

  }

  void rebellionInAfrica() {

  }

  void courtIntrigue() {

  }

  void easternAmbitions() {

  }

  void internalStrife() {

  }

  void mutiny() {

  }

  void garrisonDefectsToConstantine() {

  }

  void garrisonOverrun() {

  }

  void retreat() {

  }

  void quietInTheWest() {

  }

  void arrelatesDeclaresForConstantine() {

  }

  void gothsMarchOnRome() {

  }

  void nonEstIstaPaxSedPactioServitutis() {

  }

  void troopsDefectToConstantine() {

  }

  void oathBreakers() {

  }

  void constantineOnTheMove() {

  }

  void usurper() {

  }

  void revolt() {

  }

  void deathOfSymmachus() {

  }

  void olympiusMovesAgainstStilicho() {

  }

  void gothicRefugees() {

  }

  void deathOfAlaric() {

  }

  void rexWandalorumEtAlanorum() {

  }

  void enemyPhaseCard() {
    if (_state.cardsInLocationCount(CardType.enemy, Location.deckEnemy) == 0) {
      _state.newEnemyDeckFromDiscards(_random);
    }
    final enemyCardHandlers = {
      Card.enemyConstantineActivate1: constantineActivate1,
      Card.enemyConstantineActivate2: constantineActivate2,
      Card.enemyConstantineActivate3: constantineActivate3,
      Card.enemyConstantineActivate4: constantineActivate4,
      Card.enemyConstantineActivate5: constantineActivate5,
      Card.enemyConstantineActivate6: constantineActivate6,
      Card.enemyConstantineActivate7: constantineActivate7,
      Card.enemyConstantineActivate8: constantineActivate8,
      Card.enemyGothsActivate9: gothsActivate9,
      Card.enemyGothsActivate10: gothsActivate10,
      Card.enemyGothsActivate11: gothsActivate11,
      Card.enemyGothsActivate12: gothsActivate12,
      Card.enemyGothsActivate13: gothsActivate13,
      Card.enemyGothsActivate14: gothsActivate14,
      Card.enemyGothsActivate15: gothsActivate15,
      Card.enemyGothsActivate16: gothsActivate16,
      Card.enemyVandalsActivate17: vandalsActivate17,
      Card.enemyVandalsActivate18: vandalsActivate18,
      Card.enemyVandalsActivate19: vandalsActivate19,
      Card.enemyVandalsActivate20: vandalsActivate20,
      Card.enemyVandalsActivate21: vandalsActivate21,
      Card.enemyVandalsActivate22: vandalsActivate22,
      Card.enemyVandalsActivate23: vandalsActivate23,
      Card.enemyUnrestInHispania24: unrestInHispania,
      Card.enemyUnrestInSeptumProvinciae25: unrestInSeptumProvinciae,
      Card.enemyUnrestInGallia26: unrestInGallia,
      Card.enemyUnrestInItaliaAnnonaria27: unrestInItaliaAnnonaria,
      Card.enemyRebellionInAfrica28: rebellionInAfrica,
      Card.enemyCourtIntrigues29: courtIntrigue,
      Card.enemyEasternAmbitions30: easternAmbitions,
      Card.enemyInternalStrife31: internalStrife,
      Card.enemyMutiny32: mutiny,
      Card.enemyGarrisonDefectsToConstantine33: garrisonDefectsToConstantine,
      Card.enemyGarrisonOverrun34: garrisonOverrun,
      Card.enemyRetreat35: retreat,
      Card.enemyQuietInTheWest36: quietInTheWest,
      Card.enemyArrelateDeclaresForConstantine37: arrelatesDeclaresForConstantine,
      Card.enemyGothsMarchOnRome38: gothsMarchOnRome,
      Card.enemyNonEstIstaPaxSedPactioServitutis39: nonEstIstaPaxSedPactioServitutis,
      Card.enemyTroopsDefectToConstantine40: troopsDefectToConstantine,
      Card.enemyOathBreakers41: oathBreakers,
      Card.enemyConstantineOnTheMove42: constantineOnTheMove,
      Card.enemyUsurper43: usurper,
      Card.enemyUnrestInItaliaSuburbicaria44: unrestInItaliaSuburbicaria,
      Card.enemyRevolts45: revolt,
      Card.enemyDeathOfSymmachus46: deathOfSymmachus,
      Card.enemyOlympiusMovesAgainstStilicho47: olympiusMovesAgainstStilicho,
      Card.enemyGothicRefugees48: gothicRefugees,
      Card.enemyDeathOfAlaric49: deathOfAlaric,
      Card.enemyRexWandalorumEtAlanorum50: rexWandalorumEtAlanorum,
    };
    final card = _state.currentEnemyCard;
    enemyCardHandlers[card]!();
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      setUpComitatensesAndGarrisons,
      setUpLeaders,
      turnBegin,
      deploymentPhaseBegin,
      deploymentPhaseDeploy,
      enemyPhaseBegin,
      enemyPhaseCard,
      enemyPhaseCard,
      enemyPhaseCard,
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

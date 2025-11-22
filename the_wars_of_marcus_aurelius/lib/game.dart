import 'dart:convert';
import 'dart:math';
import 'package:the_wars_of_marcus_aurelius/db.dart';
import 'package:the_wars_of_marcus_aurelius/random.dart';

enum Location {
  homeMarcomanni,
  spaceMarcomanni1,
  spaceMarcomanni2,
  spaceMarcomanni3,
  spacePannoniaSuperior0,
  spacePannoniaSuperior1,
  homeQuadi,
  spaceQuadi1,
  spaceQuadi2,
  spaceQuadi3,
  spacePannoniaInferior,
  homeIazyges,
  spaceIazyges1,
  spaceIazyges2,
  spaceIazyges3,
  spaceIazyges4,
  leaderMarcomanni,
  leaderQuadi,
  leaderIazyges,
  armyMarcomanni,
  armyQuadi,
  armyIazyges,
  upperDanube,
  lowerDanube,
  offMapConflictWestern,
  offMapConflictEastern,
  surrenderedTribes,
  recovery,
  unactivated,
  eleusinianMysteries,
  imperiumUsurped,
  imperium1,
  imperium2,
  imperium3,
  imperium4,
  imperium5,
  imperium6,
  imperium7,
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
  turnEnd,
  round1,
  round2,
  round3,
  roundHousekeeping,
  deckBarbarian,
  deckRoman,
  discardsBarbarian,
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
  offMapConflict,
  leader,
  army,
  imperium,
  turn,
  round,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.space: [Location.homeMarcomanni, Location.spaceIazyges4],
    LocationType.offMapConflict: [Location.offMapConflictWestern, Location.offMapConflictEastern],
    LocationType.leader: [Location.leaderMarcomanni, Location.leaderIazyges],
    LocationType.army: [Location.armyMarcomanni, Location.armyIazyges],
    LocationType.imperium: [Location.imperiumUsurped, Location.imperium7],
    LocationType.turn: [Location.turn0, Location.turnEnd],
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
      Location.homeMarcomanni: 'Marcomanni Home (+8)',
      Location.spaceMarcomanni1: 'Marcomanni (+6)',
      Location.spaceMarcomanni2: 'Marcomanni (+4)',
      Location.spaceMarcomanni3: 'Marcomanni (+2)',
      Location.spacePannoniaSuperior0: 'Pannonia Superior North',
      Location.spacePannoniaSuperior1: 'Pannonia Superior South',
      Location.homeQuadi: 'Quadi Home (+8)',
      Location.spaceQuadi1: 'Quadi (+7)',
      Location.spaceQuadi2: 'Quadi (+4)',
      Location.spaceQuadi3: 'Quadi (+2)',
      Location.spacePannoniaInferior: 'Pannonia Inferior',
      Location.homeIazyges: 'Iazyges Home (+8)',
      Location.spaceIazyges1: 'Iazyges (+6)',
      Location.spaceIazyges2: 'Iazyges (+4)',
      Location.spaceIazyges3: 'Iazyges (+3)',
      Location.spaceIazyges4: 'Iazyges (+2)',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Path {
  marcomanni,
  quadi,
  iazyges,
}

extension PathExtension on Path {
  PieceType get barbarianPieceType {
    const pathBarbarianPieceTypes = {
      Path.marcomanni: PieceType.barbarianMarcomanni,
      Path.quadi: PieceType.barbarianQuadi,
      Path.iazyges: PieceType.barbarianIazyges,
    };
    return pathBarbarianPieceTypes[this]!;
  }
}

enum Piece {
  barbarianMarcomanniBold,
  barbarianMarcomanniDemoralized,
  barbarianQuadiBold,
  barbarianQuadiDemoralized,
  barbarianIazygesBold,
  barbarianIazygesDemoralized,
  legionAdiutrix1,
  legionAdiutrix2,
  legionItalica1,
  legionItalica2,
  legionItalica3,
  legionFlaviaFelix4,
  legionMacedonia5,
  legionClaudia7,
  legionClaudia11,
  legionGemina10,
  legionGemina13,
  legionGemina14,
  legionPrimigenia22,
  legionSlaves,
  leaderMarcusAureliusBold,
  leaderMarcusAureliusDemoralized,
  leaderPompeianus,
  leaderPertinax,
  leaderMaximianus,
  fort0Level1,
  fort1Level1,
  fort2Level1,
  fort3Level1,
  fort4Level1,
  fort5Level1,
  fort6Level1,
  fort7Level1,
  fort8Level1,
  fort9Level1,
  fort10Level1,
  fort11Level1,
  fort12Level1,
  fort0Level2,
  fort1Level2,
  fort2Level2,
  fort3Level2,
  fort4Level2,
  fort5Level2,
  fort6Level2,
  fort7Level2,
  fort8Level2,
  fort9Level2,
  fort10Level2,
  fort11Level2,
  fort12Level2,
  truceMarcomanni,
  truceQuadi,
  truceIazyges,
  mutiny0,
  mutiny1,
  mutiny2,
  auxiliaP1,
  auxiliaP2,
  fleet0,
  fleet1,
  cannotAttackQuadi,
  eleusinianMysteries,
  markerYear,
  markerRound,
  markerImperium,
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
  barbarian,
  barbarianMarcomanni,
  barbarianQuadi,
  barbarianIazyges,
  legion,
  leader,
  fortLevel1,
  truce,
  mutiny,
  fleet,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.barbarianMarcomanniBold, Piece.markerImperium],
    PieceType.barbarian: [Piece.barbarianMarcomanniBold, Piece.barbarianIazygesDemoralized],
    PieceType.barbarianMarcomanni: [Piece.barbarianMarcomanniBold, Piece.barbarianMarcomanniDemoralized],
    PieceType.barbarianQuadi: [Piece.barbarianQuadiBold, Piece.barbarianQuadiDemoralized],
    PieceType.barbarianIazyges: [Piece.barbarianIazygesBold, Piece.barbarianIazygesDemoralized],
    PieceType.legion: [Piece.legionAdiutrix1, Piece.legionSlaves],
    PieceType.leader: [Piece.leaderMarcusAureliusBold, Piece.leaderMaximianus],
    PieceType.fortLevel1: [Piece.fort0Level1, Piece.fort12Level1],
    PieceType.truce: [Piece.truceMarcomanni, Piece.truceIazyges],
    PieceType.mutiny: [Piece.mutiny0, Piece.mutiny2],
    PieceType.fleet: [Piece.fleet0, Piece.fleet1],
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
  barbarianChatti1,
  barbarianCostoboci2,
  barbarianBallomar3,
  barbarianActivateMarcomanni4,
  barbarianActivateMarcomanni5,
  barbarianActivateMarcomanni6,
  barbarianActivateMarcomanni7,
  barbarianActivateMarcomanni8,
  barbarianActivateMarcomanni9,
  barbarianActivateMarcomanni10,
  barbarianActivateMarcomanni11,
  barbarianActivateQuadi12,
  barbarianActivateQuadi13,
  barbarianActivateQuadi14,
  barbarianActivateQuadi15,
  barbarianActivateQuadi16,
  barbarianActivateQuadi17,
  barbarianActivateQuadi18,
  barbarianActivateIazygesCavalry19,
  barbarianActivateIazygesCavalry20,
  barbarianActivateIazyges21,
  barbarianActivateIazyges22,
  barbarianActivateIazyges23,
  barbarianActivateIazyges24,
  barbarianActivateIazyges25,
  barbarianActivateIazyges26,
  barbarianPlague27,
  barbarianPlague28,
  barbarianUnrestInRome29,
  barbarianScandalFaustina30,
  barbarianDeathInTheFamily31,
  barbarianMoraleCollapses32,
  barbarianBadOmens33,
  barbarianGoodOmens34,
  barbarianAlexanderOfAbonoteichus35,
  barbarianLegionsDemandDonative36,
  barbarianBarbariansSiegeForts37,
  barbarianBarbariansSiegeForts38,
  barbarianGoddessFortuna39,
  barbarianQuietOnTheDanube40,
  barbarianQuietOnTheDanube41,
  barbarianQuietOnTheDanube42,
  barbarianBritishUprising43,
  barbarianAvidiusCassius44,
  barbarianRebellion45,
  barbarianCoordinatedAttack46,
  barbarianPlagueWorsens47,
  barbarianPlagueWorsens48,
  barbarianActivateQuadi49,
  barbarianActivateQuadi50,
  romanAuctionInTheForum1,
  romanSingleCombat2,
  romanCommodus3,
  romanBattleOnTheIce4,
  romanRainMiracle5,
  romanMarcusValeriusMaximianus6,
  romanPubliusHelviusPertinax7,
  romanLegio22Primigenia8,
  romanPhilisophicalInquiry9,
  romanForeignTreaty10,
  romanLectisternium11,
  romanTacticalAdvantage12,
  romanAmbush13,
  romanRout14,
  romanOrderedRetreat15,
  romanTemporaryTruce16,
  romanWinterQuarters17,
  romanVexillationes18,
  romanWarAtrocities19,
  romanReputationOfRome20,
  romanDivideAndConquer21,
  romanBarbarianInformants22,
  romanSeizeTheInitiative23,
  romanForcedMarch24,
  romanGoddessFortuna25,
  romanReturnOfCaptives26,
  romanHarshWinter27,
  romanLocalGuides28,
  romanGalen29,
  romanGalen30,
  romanMarcomannia31,
  romanSarmatia32,
  romanConcessions33,
  romanMaximusDecimusMeridius34,
  romanLightningMiracle35,
  romanDecapitation36,
  romanEleusinianMysteries37,
  romanColumnOfMarcusAurelius38,
  romanSlavesGladiatorsAndBandits39,
  romanBarbarianAuxilia40,
  romanActionCard41,
  romanActionCard42,
  romanActionCard43,
  romanActionCard44,
  romanActionCard45,
  romanActionCard46,
  romanActionCard47,
  romanActionCard48,
  romanActionCard49,
  romanActionCard50,
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
  barbarian,
  roman,
}

extension CardTypeExtension on CardType {
  static const _bounds = {
    CardType.barbarian: [Card.barbarianChatti1, Card.barbarianActivateQuadi50],
    CardType.roman: [Card.romanAuctionInTheForum1, Card.romanActionCard50],
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
      Card.barbarianBritishUprising43,
      Card.barbarianAvidiusCassius44,
      Card.barbarianRebellion45,
      Card.barbarianCoordinatedAttack46,
      Card.barbarianPlagueWorsens47,
      Card.barbarianPlagueWorsens48,
      Card.barbarianActivateQuadi49,
      Card.barbarianActivateQuadi50,
      Card.romanMaximusDecimusMeridius34,
      Card.romanLightningMiracle35,
      Card.romanDecapitation36,
      Card.romanEleusinianMysteries37,
      Card.romanColumnOfMarcusAurelius38,
      Card.romanSlavesGladiatorsAndBandits39,
      Card.romanBarbarianAuxilia40,
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
      Scenario.standard: 'Standard (9 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.flipped);
  List<Location> _cardLocations = List<Location>.filled(Card.values.length, Location.offmap);
  List<Card> _barbarianDeck = <Card>[];
  List<Card> _romanDeck = <Card>[];

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
   : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
   , _cardLocations = locationListFromIndices(List<int>.from(json['cardLocations']))
   , _barbarianDeck = cardListFromIndices(List<int>.from(json['barbarianDeck']))
   , _romanDeck = cardListFromIndices(List<int>.from(json['romanDeck']))
   ;

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'cardLocations': locationListToIndices(_cardLocations),
    'barbarianDeck': cardListToIndices(_barbarianDeck),
    'romanDeck': cardListToIndices(_romanDeck),
  };

  Piece? pieceFlipSide(Piece piece) {
    const pieceFlipSides = {
      Piece.barbarianMarcomanniBold: Piece.barbarianMarcomanniDemoralized,
      Piece.barbarianMarcomanniDemoralized: Piece.barbarianMarcomanniBold,
      Piece.barbarianQuadiBold: Piece.barbarianQuadiDemoralized,
      Piece.barbarianQuadiDemoralized: Piece.barbarianQuadiBold,
      Piece.barbarianIazygesBold: Piece.barbarianIazygesDemoralized,
      Piece.barbarianIazygesDemoralized: Piece.barbarianIazygesBold,
      Piece.leaderMarcusAureliusBold: Piece.leaderMarcusAureliusDemoralized,
      Piece.leaderMarcusAureliusDemoralized: Piece.leaderMarcusAureliusBold,
      Piece.fort0Level1: Piece.fort0Level2,
      Piece.fort1Level1: Piece.fort1Level2,
      Piece.fort2Level1: Piece.fort2Level2,
      Piece.fort3Level1: Piece.fort3Level2,
      Piece.fort4Level1: Piece.fort4Level2,
      Piece.fort5Level1: Piece.fort5Level2,
      Piece.fort6Level1: Piece.fort6Level2,
      Piece.fort7Level1: Piece.fort7Level2,
      Piece.fort8Level1: Piece.fort8Level2,
      Piece.fort9Level1: Piece.fort9Level2,
      Piece.fort10Level1: Piece.fort10Level2,
      Piece.fort11Level1: Piece.fort11Level2,
      Piece.fort12Level1: Piece.fort12Level2,
      Piece.fort0Level2: Piece.fort0Level1,
      Piece.fort1Level2: Piece.fort1Level1,
      Piece.fort2Level2: Piece.fort2Level1,
      Piece.fort3Level2: Piece.fort3Level1,
      Piece.fort4Level2: Piece.fort4Level1,
      Piece.fort5Level2: Piece.fort5Level1,
      Piece.fort6Level2: Piece.fort6Level1,
      Piece.fort7Level2: Piece.fort7Level1,
      Piece.fort8Level2: Piece.fort8Level1,
      Piece.fort9Level2: Piece.fort9Level1,
      Piece.fort10Level2: Piece.fort10Level1,
      Piece.fort11Level2: Piece.fort11Level1,
      Piece.fort12Level2: Piece.fort12Level1,
      Piece.auxiliaP1: Piece.auxiliaP2,
      Piece.auxiliaP2: Piece.auxiliaP1,
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

  bool spacePlayerControlled(Location space) {
    for (final path in Path.values) {
      int sequence = pathSpaceSequence(path, space);
      if (sequence >= 0) {
        final barbarian = pathBarbarianPiece(path);
        if (barbarian == null) {
          break;
        }
        final barbarianSpace = pieceLocation(barbarian);
        int barbarianSequence = pathSpaceSequence(path, barbarianSpace);
        if (barbarianSequence >= sequence) {
          return false;
        }
      }
    }
    return true;
  }

  // Paths

  List<Location> pathSpaces(Path path) {
    const pathSpaces = {
      Path.marcomanni: [
        Location.homeMarcomanni,
        Location.spaceMarcomanni1,
        Location.spaceMarcomanni2,
        Location.spaceMarcomanni3,
        Location.spacePannoniaSuperior0,
        Location.spacePannoniaSuperior1,
      ],
      Path.quadi: [
        Location.homeQuadi,
        Location.spaceQuadi1,
        Location.spaceQuadi2,
        Location.spaceQuadi3,
        Location.spacePannoniaInferior,
      ],
      Path.iazyges: [
        Location.homeIazyges,
        Location.spaceIazyges1,
        Location.spaceIazyges2,
        Location.spaceIazyges3,
        Location.spaceIazyges4,
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

  Piece? pathBarbarianPiece(Path path) {
    Piece? piece;
    switch (path) {
    case Path.marcomanni:
      piece = Piece.barbarianMarcomanniBold;
    case Path.quadi:
      piece = Piece.barbarianQuadiBold;
    case Path.iazyges:
      piece = Piece.barbarianIazygesBold;
    }
    var location = pieceLocation(piece);
    if (location == Location.flipped) {
      piece = pieceFlipSide(piece)!;
      location = pieceLocation(piece);
    }
    if (location.isType(LocationType.space)) {
      return piece;
    }
    return null;
  }

  Location? pathBarbarianSpace(Path path) {
    final piece = pathBarbarianPiece(path);
    if (piece == null) {
      return null;
    }
    return pieceLocation(piece);
  }

  Location pathLeaderBox(Path path) {
    return Location.values[LocationType.leader.firstIndex + path.index];
  }

  Location pathArmyBox(Path path) {
    return Location.values[LocationType.army.firstIndex + path.index];
  }

  // Barbarians

  Path barbarianPath(Piece barbarian) {
    if (barbarian.isType(PieceType.barbarianMarcomanni)) {
      return Path.marcomanni;
    }
    if (barbarian.isType(PieceType.barbarianQuadi)) {
      return Path.quadi;
    }
    if (barbarian.isType(PieceType.barbarianIazyges)) {
      return Path.iazyges;
    }
    return Path.iazyges;
  }

  bool barbarianIsDemoralized(Piece barbarian) {
    final demoralizedBarbarians = [
      Piece.barbarianMarcomanniDemoralized,
      Piece.barbarianQuadiDemoralized,
      Piece.barbarianIazygesDemoralized,
    ];
    return demoralizedBarbarians.contains(barbarian);
  }

  int barbarianAttackValue(Piece barbarian) {
    const barbarianAttackValues = {
      Piece.barbarianMarcomanniBold: 4,
      Piece.barbarianMarcomanniDemoralized: 2,
      Piece.barbarianQuadiBold: 5,
      Piece.barbarianQuadiDemoralized: 3,
      Piece.barbarianIazygesBold: 4,
      Piece.barbarianIazygesDemoralized: 2,
    };
    return barbarianAttackValues[barbarian]!;
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

  // Legions

  bool legionMayBeAssignedToArmy(Location armyBox) {
    return piecesInLocationCount(PieceType.legion, armyBox) < 6;
  }

  bool leaderMayBeAssignedToArmy(Piece leader, Location leaderBox) {
    if (pieceInLocation(PieceType.leader, leaderBox) != null) {
      return false;
    }
    final armyBox = leaderArmyBox(leaderBox);
    if (piecesInLocationCount(PieceType.legion, armyBox) == 0) {
      return false;
    }
    return true;
  }

  // Turns

  int get currentTurn {
    return pieceLocation(Piece.markerYear).index - LocationType.turn.firstIndex;
  }

  String turnName(int turn) {
    if (turn == LocationType.turn.count - 1) {
      return 'End';
    }
    return '17$turn CE';
  }

  // Cards

  Card get currentBarbarianCard {
    return _barbarianDeck[0];
  }

  Card get currentRomanCard {
    return _romanDeck[0];
  }

  void newBarbarianDeckFromDiscards(Random random) {
    for (final card in cardsInLocation(CardType.barbarian, Location.discardsBarbarian)) {
      setCardLocation(card, Location.deckBarbarian);
      _barbarianDeck.add(card);
    }
    _barbarianDeck.shuffle(random);
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
    for (final barbarianCard in CardType.barbarian.cards) {
      if (!barbarianCard.isLateWar) {
        setCardLocation(barbarianCard, Location.deckBarbarian);
        _barbarianDeck.add(barbarianCard);
      }
    }
    _barbarianDeck.shuffle(random);

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
      (PieceType.fortLevel1, Location.offmap),
      (PieceType.mutiny, Location.offmap),
      (PieceType.truce, Location.offmap),
      (PieceType.fleet, Location.offmap),
      (PieceType.legion, Location.recovery),
    ]);

    state.setupPieces([
      (Piece.markerYear, Location.turn0),
      (Piece.markerRound, Location.round1),
      (Piece.barbarianMarcomanniBold, Location.spaceMarcomanni3),
      (Piece.barbarianQuadiBold, Location.homeQuadi),
      (Piece.barbarianIazygesBold, Location.spaceIazyges2),
      (Piece.cannotAttackQuadi, Location.homeQuadi),
      (Piece.markerImperium, Location.imperium4),
      (Piece.legionPrimigenia22, Location.unactivated),
      (Piece.legionSlaves, Location.unactivated),
      (Piece.leaderPertinax, Location.unactivated),
      (Piece.leaderPertinax, Location.unactivated),
      (Piece.eleusinianMysteries, Location.offmap),
      (Piece.auxiliaP1, Location.offmap),
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

  int rollD8() {
    int die = _random.nextInt(8) + 1;
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

  void setUpLegions() {
    if (_state.currentTurn != 0) {
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
      final legion = selectedPiece();
      if (legion == null) {
        setPrompt('Select Legion to deploy');
        for (final legion in PieceType.legion.pieces) {
          if (_state.pieceLocation(legion) != Location.unactivated) {
            pieceChoosable(legion);
          }
        }
        if (_state.piecesInLocationCount(PieceType.legion, Location.recovery) == 0) {
          choiceChoosable(Choice.next, true);
        }
        throw PlayerChoiceException();
      }
      final armyBox = selectedLocation();
      if (armyBox == null) {
        setPrompt('Select Army to deploy Legion to');
        final legionLocation = _state.pieceLocation(legion);
        for (final armyBox in LocationType.army.locations) {
          if (armyBox != legionLocation && _state.legionMayBeAssignedToArmy(armyBox)) {
            locationChoosable(armyBox);
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      _state.setPieceLocation(legion, armyBox);
      clearChoices();
    }
  }

  void setUpLeaders() {
    if (_state.currentTurn != 0) {
      return;
    }
    while (true) {
      if (choicesEmpty()) {
        setPrompt('Select Leader to Assign');
        pieceChoosable(Piece.leaderMarcusAureliusBold);
        pieceChoosable(Piece.leaderPompeianus);
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

  void redeploymentPhaseBegin() {
    if (_state.currentTurn == 0) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Redeployment Step');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Redeployment Step');
  }

  void redeploymentPhaseRedeploy() {
    if (_state.currentTurn == 0) {
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
        setPrompt('Select Leader to assign or Legion to deploy');
        for (final legio in PieceType.legion.pieces) {
          if (_state.pieceLocation(legio) != Location.unactivated) {
            pieceChoosable(legio);
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
        if (piece.isType(PieceType.legion)) {
          setPrompt('Select Army Box or Off‐Map Conflict for Legion');
          final legionLocation = _state.pieceLocation(piece);
          for (final armyBox in LocationType.army.locations) {
            if (armyBox != legionLocation && _state.legionMayBeAssignedToArmy(armyBox)) {
              locationChoosable(armyBox);
            }
          }
          for (final offMapConflictBox in LocationType.offMapConflict.locations) {
            if (offMapConflictBox != legionLocation) {
              locationChoosable(offMapConflictBox);
            }
          }
        } else {
          setPrompt('Select Army Box for Leader');
          for (final leaderBox in LocationType.leader.locations) {
            if (_state.leaderMayBeAssignedToArmy(piece, leaderBox)) {
              locationChoosable(leaderBox);
            }
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      final oldLocation = _state.pieceLocation(piece);
      if (piece.isType(PieceType.legion)) {
        if (oldLocation == Location.recovery) {
          logLine('> ${piece.desc} is deployed to ${location.desc}.');
        } else {
          logLine('> ${piece.desc} transfers from ${oldLocation.desc} to ${location.desc}.');
        }
      } else {
        if (oldLocation == Location.recovery) {
          logLine('> ${piece.desc} is assigned to ${location.desc}.');
        } else {
          logLine('> ${piece.desc} is reassigned from ${oldLocation.desc} to ${location.desc}.');
        }
        _state.setPieceLocation(piece, location);
      }
      clearChoices();
    }
  }

  void redeploymentPhaseAddLateWarCards() {
    if (_state.currentTurn != 5) {
      return;
    }
  }

  void springRoundBarbarianPhaseBegin() {
    if (_state.currentTurn == 0) {
      return;
    }
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Spring Round Barbarian Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Spring Round Barbarian Phase');
  }

  void advanceMarcomanni() {
    final marcomanni = _state.pathBarbarianPiece(Path.marcomanni)!;
    final space = _state.pieceLocation(marcomanni);
    var nextSpace = _state.pathNextSpace(Path.marcomanni, space)!;
  }

  void activateMarcomanni() {
    logLine('### Marcomanni');
    final marcomanni = _state.pathBarbarianPiece(Path.marcomanni);
    if (marcomanni == null) {
      return;
    }
    if (marcomanni == Piece.barbarianMarcomanniDemoralized) {
      logLine('> Marcomanni are Emboldened.');
      _state.flipPiece(marcomanni);
      return;
    }
    advanceMarcomanni();
  }

  void activateQuadi() {
    logLine('### Quadi');

  }

  void activateIazyges() {
    logLine('### Iazyges');

  }

  void activateIazygesCavalry() {
    logLine('### Iazyges Cavalry');

  }

  void alexanderOfAbonoteichus() {

  }

  void avidiusCassius() {

  }

  void badOmens() {

  }

  void ballomar() {

  }

  void barbariansSiegeForts() {

  }

  void britishUprising() {

  }

  void chatti() {

  }

  void coordinatedAttack() {

  }

  void costoboci() {

  }

  void deathInTheFamily() {

  }

  void goddessFortuna() {

  }

  void goodOmens() {

  }

  void legionsDemandDonative() {

  }

  void moraleCollapses() {

  }

  void plague() {

  }

  void plagueWorsens() {

  }

  void quietOnTheDanube() {

  }

  void rebellion() {

  }

  void scandalFaustina() {

  }

  void unrestInRome() {

  }

  void barbarianPhaseCard() {
    if (_state.cardsInLocationCount(CardType.barbarian, Location.deckBarbarian) == 0) {
      _state.newBarbarianDeckFromDiscards(_random);
    }
    final barbarianCardHandlers = {
      Card.barbarianChatti1: chatti,
      Card.barbarianCostoboci2: costoboci,
      Card.barbarianBallomar3: ballomar,
      Card.barbarianActivateMarcomanni4: activateMarcomanni,
      Card.barbarianActivateMarcomanni5: activateMarcomanni,
      Card.barbarianActivateMarcomanni6: activateMarcomanni,
      Card.barbarianActivateMarcomanni7: activateMarcomanni,
      Card.barbarianActivateMarcomanni8: activateMarcomanni,
      Card.barbarianActivateMarcomanni9: activateMarcomanni,
      Card.barbarianActivateMarcomanni10: activateMarcomanni,
      Card.barbarianActivateMarcomanni11: activateMarcomanni,
      Card.barbarianActivateQuadi12: activateQuadi,
      Card.barbarianActivateQuadi13: activateQuadi,
      Card.barbarianActivateQuadi14: activateQuadi,
      Card.barbarianActivateQuadi15: activateQuadi,
      Card.barbarianActivateQuadi16: activateQuadi,
      Card.barbarianActivateQuadi17: activateQuadi,
      Card.barbarianActivateQuadi18: activateQuadi,
      Card.barbarianActivateIazygesCavalry19: activateIazygesCavalry,
      Card.barbarianActivateIazygesCavalry20: activateIazygesCavalry,
      Card.barbarianActivateIazyges21: activateIazyges,
      Card.barbarianActivateIazyges22: activateIazyges,
      Card.barbarianActivateIazyges23: activateIazyges,
      Card.barbarianActivateIazyges24: activateIazyges,
      Card.barbarianActivateIazyges25: activateIazyges,
      Card.barbarianActivateIazyges26: activateIazyges,
      Card.barbarianPlague27: plague,
      Card.barbarianPlague28: plague,
      Card.barbarianUnrestInRome29: unrestInRome,
      Card.barbarianScandalFaustina30: scandalFaustina,
      Card.barbarianDeathInTheFamily31: deathInTheFamily,
      Card.barbarianMoraleCollapses32: moraleCollapses,
      Card.barbarianBadOmens33: badOmens,
      Card.barbarianGoodOmens34: goodOmens,
      Card.barbarianAlexanderOfAbonoteichus35: alexanderOfAbonoteichus,
      Card.barbarianLegionsDemandDonative36: legionsDemandDonative,
      Card.barbarianBarbariansSiegeForts37: barbariansSiegeForts,
      Card.barbarianBarbariansSiegeForts38: barbariansSiegeForts,
      Card.barbarianGoddessFortuna39: goddessFortuna,
      Card.barbarianQuietOnTheDanube40: quietOnTheDanube,
      Card.barbarianQuietOnTheDanube41: quietOnTheDanube,
      Card.barbarianQuietOnTheDanube42: quietOnTheDanube,
      Card.barbarianBritishUprising43: britishUprising,
      Card.barbarianAvidiusCassius44: avidiusCassius,
      Card.barbarianRebellion45: rebellion,
      Card.barbarianCoordinatedAttack46: coordinatedAttack,
      Card.barbarianPlagueWorsens47: plagueWorsens,
      Card.barbarianPlagueWorsens48: plagueWorsens,
      Card.barbarianActivateQuadi49: activateQuadi,
      Card.barbarianActivateQuadi50: activateQuadi,
    };
    final card = _state.currentBarbarianCard;
    barbarianCardHandlers[card]!();
  }

  void springRoundBarbarianPhaseCard() {
    if (_state.currentTurn == 0) {
      return;
    }
    barbarianPhaseCard();
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      setUpLegions,
      setUpLeaders,
      turnBegin,
      redeploymentPhaseBegin,
      redeploymentPhaseRedeploy,
      redeploymentPhaseAddLateWarCards,
      springRoundBarbarianPhaseBegin,
      springRoundBarbarianPhaseCard,
      springRoundBarbarianPhaseCard,
      springRoundBarbarianPhaseCard,
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

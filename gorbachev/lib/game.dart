import 'dart:convert';
import 'dart:math';
import 'package:gorbachev/db.dart';

enum Location {
  moscow,
  russiaSedition,
  russiaViolence,
  russiaGlasnost,
  russiaPerestroika,
  russiaWorkersParadise,
  balticsSedition,
  balticsViolence,
  balticsGlasnost,
  balticsPerestroika,
  balticsWorkersParadise,
  caucasusSedition,
  caucasusViolence,
  caucasusGlasnost,
  caucasusPerestroika,
  caucasusWorkersParadise,
  centralAsiaSedition,
  centralAsiaViolence,
  centralAsiaGlasnost,
  centralAsiaPerestroika,
  centralAsiaWorkersParadise,
  communistParty4,
  communistParty6,
  communistParty8,
  communistParty10,
  communistParty12,
  ddr,
  easternEurope,
  afghanistanMustStay,
  afghanistanMayLeave,
  boxPathCentralAsia,
  boxWarsawPact,
  boxKgb,
  boxGorbymania,
  boxPolitburoSupport,
  boxPolitburoOpposition,
  boxDoctrine,
  boxUsPresident,
  fiveYearPlan0,
  fiveYearPlan1,
  fiveYearPlan2,
  fiveYearPlan3,
  fiveYearPlan4,
  fiveYearPlan5,
  fiveYearPlan6,
  mediaCulture0,
  mediaCulture1,
  mediaCulture2,
  mediaCulture3,
  mediaCulture4,
  mediaCulture5,
  mediaCulture6,
  militaryMight0,
  militaryMight1,
  militaryMight2,
  militaryMight3,
  militaryMight4,
  militaryMight5,
  militaryMight6,
  year1985,
  year1986,
  year1987,
  year1988,
  year1989,
  year1990,
  year1991,
  seasonWinter,
  seasonSpring,
  seasonSummer,
  seasonAutumn,
  cupDisaster,
  cupMassacre,
  trayYearSeason,
  trayPeople,
  trayVremya,
  trayUsPresidents,
  trayMassacre,
  trayDisaster,
  trayWarsawPact,
  trayPolitburo,
  trayPravda,
  trayDemonstration,
  trayKgb,
  trayBerlinWall,
  trayNukes,
  trayForces,
  trayMvd,
  trayDoctrine,
  trayAsset,
  trayPopularVote,
  trayLoyalCommunists,
  trayUzbekMafia,
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
  pathRussia,
  pathBaltics,
  pathCaucasus,
  pathCentralAsia,
  pathCommunistParty,
  fiveYearPlan,
  mediaCulture,
  militaryMight,
  year,
  season,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.land: [Location.moscow, Location.communistParty12],
    LocationType.pathRussia: [Location.russiaSedition, Location.russiaWorkersParadise],
    LocationType.pathBaltics: [Location.balticsSedition, Location.balticsWorkersParadise],
    LocationType.pathCaucasus: [Location.caucasusSedition, Location.caucasusWorkersParadise],
    LocationType.pathCentralAsia: [Location.centralAsiaSedition, Location.centralAsiaWorkersParadise],
    LocationType.pathCommunistParty: [Location.communistParty4, Location.communistParty12],
    LocationType.fiveYearPlan: [Location.fiveYearPlan0, Location.fiveYearPlan6],
    LocationType.mediaCulture: [Location.mediaCulture0, Location.mediaCulture6],
    LocationType.militaryMight: [Location.militaryMight0, Location.militaryMight6],
    LocationType.year: [Location.year1985, Location.year1991],
    LocationType.season: [Location.seasonWinter, Location.seasonAutumn],
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
      Location.year1985: '1985',
      Location.year1986: '1986',
      Location.year1987: '1987',
      Location.year1988: '1988',
      Location.year1989: '1989',
      Location.year1990: '1990',
      Location.year1991: '1991',
      Location.seasonWinter: 'Winter',
      Location.seasonSpring: 'Spring',
      Location.seasonSummer: 'Summer',
      Location.seasonAutumn: 'Autumn',
    };
    return locationDescs[this]!;
  }

  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Path {
  russia,
  baltics,
  caucasus,
  centralAsia,
  communistParty,
}

enum Piece {
  peopleRussiaWeak,
  peopleRussiaStrong,
  peopleBalticsWeak,
  peopleBalticsStrong,
  peopleCaucasusWeak,
  peopleCaucasusStrong,
  peopleCentralAsia,
  peopleCommunistPartyWeak,
  peopleCommunistPartyStrong,
  forces40Army,
  forces1GtkArmy,
  forces2GtkArmy,
  forces28Corps,
  vremya0,
  vremya1,
  vremya2,
  vremya3,
  usPresidentReagan,
  usPresidentBush,
  usPresidentDukakis,
  massacreVilnius,
  massacreBaku,
  massacreSukhumi,
  massacreSumgait,
  massacreTbilisi,
  massacreAlmaAta,
  massacreFergana,
  disasterAdmiralNakhimov,
  disasterArmenianEarthquake,
  disasterChernobyl,
  disasterMathiasRust,
  disasterMinersStrike0,
  disasterMinersStrike1,
  disasterBigotsInPower,
  disasterRandomRevolution0,
  disasterRandomRevolution1,
  disasterRandomRevolution2,
  disasterFallOfBerlinWall,
  warsawPactDdr,
  warsawPactCzechoslovakia,
  warsawPactPoland,
  warsawPactHungary,
  warsawPactRomania,
  warsawPactBulgaria,
  politburoGorbachev,
  politburoLigachev,
  politburoYeltsin,
  politburoAliyev,
  politburoPopova,
  politburoPugo,
  politburoRyzhkov,
  politburoShcherbytsky,
  politburoSchevardnadze,
  politburoVorotnikov,
  politburoYakovlev,
  politburoYaneyev,
  pravda0,
  pravda1,
  pravda2,
  pravda3,
  demonstrationN0,
  demonstrationN1,
  demonstrationN2,
  demonstrationN3,
  demonstrationP0,
  demonstrationP1,
  demonstrationP2,
  demonstrationP3,
  kgbD,
  kgbI,
  kgb5,
  berlinWall,
  nukeInf,
  nukeIcbm,
  mvd0,
  mvd1,
  mvd2,
  mvd3,
  uzbekMafia,
  doctrineBrezhnev,
  doctrineSinatra,
  assetFiveYearPlan,
  assetMediaCulture,
  assetMilitaryMight,
  markerYear,
  markerSeason,
  markerPopularVote,
  markerLoyalCommunists,
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
  people,
  peopleRussia,
  peopleBaltics,
  peopleCaucasus,
  peopleCentralAsia,
  peopleCommunistParty,
  vremya,
  usPresident,
  massacre,
  disaster,
  disasterEarlier,
  disasterLater,
  warsawPact,
  politburo,
  pravda,
  demonstration,
  kgb,
  nuke,
  forces,
  mvd,
  doctrine,
  asset,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.peopleRussiaWeak, Piece.markerLoyalCommunists],
    PieceType.people: [Piece.peopleRussiaWeak, Piece.peopleCommunistPartyStrong],
    PieceType.peopleRussia: [Piece.peopleRussiaWeak, Piece.peopleRussiaStrong],
    PieceType.peopleBaltics: [Piece.peopleBalticsWeak, Piece.peopleBalticsStrong],
    PieceType.peopleCaucasus: [Piece.peopleCaucasusWeak, Piece.peopleCaucasusStrong],
    PieceType.peopleCentralAsia: [Piece.peopleCentralAsia, Piece.peopleCentralAsia],
    PieceType.peopleCommunistParty: [Piece.peopleCommunistPartyWeak, Piece.peopleCommunistPartyStrong],
    PieceType.vremya: [Piece.vremya0, Piece.vremya3],
    PieceType.usPresident: [Piece.usPresidentReagan, Piece.usPresidentDukakis],
    PieceType.massacre: [Piece.massacreVilnius, Piece.massacreFergana],
    PieceType.disaster: [Piece.disasterAdmiralNakhimov, Piece.disasterFallOfBerlinWall],
    PieceType.disasterEarlier: [Piece.disasterAdmiralNakhimov, Piece.disasterMinersStrike1],
    PieceType.disasterLater: [Piece.disasterBigotsInPower, Piece.disasterFallOfBerlinWall],
    PieceType.warsawPact: [Piece.warsawPactDdr, Piece.warsawPactBulgaria],
    PieceType.politburo: [Piece.politburoGorbachev, Piece.politburoYaneyev],
    PieceType.pravda: [Piece.pravda0, Piece.pravda3],
    PieceType.demonstration: [Piece.demonstrationN0, Piece.demonstrationP3],
    PieceType.kgb: [Piece.kgbD, Piece.kgb5],
    PieceType.nuke: [Piece.nukeInf, Piece.nukeIcbm],
    PieceType.forces: [Piece.forces40Army, Piece.forces28Corps],
    PieceType.mvd: [Piece.mvd0, Piece.mvd3],
    PieceType.doctrine: [Piece.doctrineBrezhnev, Piece.doctrineSinatra],
    PieceType.asset: [Piece.assetFiveYearPlan, Piece.assetMilitaryMight],
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
      Scenario.standard: 'Standard (27 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.discarded);
  List<int> _deck = <int>[];
  int? _currentCardNumber;

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
   : _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
   , _deck = List<int>.from(json['deck'])
   , _currentCardNumber = json['deck'] as int?
   ;

  Map<String, dynamic> toJson() => {
    'pieceLocations': locationListToIndices(_pieceLocations),
    'deck': _deck,
    'currentCardNumber': _currentCardNumber,
  };

  Location pieceLocation(Piece piece) {
    return _pieceLocations[piece.index];
  }

  void setPieceLocation(Piece piece, Location location) {
    _pieceLocations[piece.index] = location;
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

  // Paths

  LocationType pathLocationType(Path path) {
    final pathLocationTypes = {
      Path.russia: LocationType.pathRussia,
      Path.baltics: LocationType.pathBaltics,
      Path.caucasus: LocationType.pathCaucasus,
      Path.centralAsia: LocationType.pathCentralAsia,
      Path.communistParty: LocationType.pathCommunistParty,
    };
    return pathLocationTypes[path]!;
  }

  PieceType pathPeoplePieceType(Path path) {
    final pathPeoplePieceTypes = {
      Path.russia: PieceType.peopleRussia,
      Path.baltics: PieceType.peopleBaltics,
      Path.caucasus: PieceType.peopleCaucasus,
      Path.centralAsia: PieceType.peopleCentralAsia,
      Path.communistParty: PieceType.peopleCommunistParty,
    };
    return pathPeoplePieceTypes[path]!;
  }

  Piece pathPeople(Path path) {
    final pieceType = pathPeoplePieceType(path);
    for (final piece in pieceType.pieces) {
      if (pieceLocation(piece).isType(LocationType.land)) {
        return piece;
      }
    }
    return Piece.berlinWall;
  }

  // Turns

  Location yearBox(int year) {
    return Location.values[LocationType.year.firstIndex + year - 1985];
  }

  Location seasonBox(int season) {
    return Location.values[LocationType.season.firstIndex + season];
  }

  int get currentYear {
    return pieceLocation(Piece.markerYear).index - LocationType.year.firstIndex + 1985;
  }

  int get currentSeason {
    return pieceLocation(Piece.markerSeason).index - Location.seasonWinter.index;
  }

  String yearName(int year) {
    return yearBox(year).desc;
  }

  String seasonName(int season) {
    return seasonBox(season).desc;

  }
  String turnName(int year, int season) {
    return '${seasonName(season)} ${yearName(year)}';
  }

  void advanceSeason() {
    int season = currentSeason + 1;
    if (season == LocationType.season.count) {
      int year = currentYear + 1;
      setPieceLocation(Piece.markerYear, yearBox(year));
      season = 0;
    }
    setPieceLocation(Piece.markerSeason, seasonBox(season));
  }

  // Cards

  int? get currentCardNumber {
    if (_currentCardNumber == null) {
      return null;
    }
    return _currentCardNumber! + 1;
  }

  void advanceDeck() {
    _currentCardNumber = _deck.removeAt(0);
  }

  String cardTitle(int cardNumber) {
    const cardTitles = [
      'Comrade Orange Juice',
      'Alexander Yakovlev',
      'The Rise of Boris Yeltsin',
      '27th Congress of the CPSU',
      'Felipe González',
      'The Daniloff Crisis',
      'Sakharov Released!',
      'Yegor Ligachëv',
      'The Anti-Stalin Campaign',
      'Law on State Enterprises',
      'Yeltsin Quits!',
      'Crisis in Karabagh',
      '“I Cannot Betray My Principles”',
      'The Hitler‐Stalin Pact',
      'Lithuania’s Flag',
      'Raisa Gorbacehva',
      'Congress of People’s Deputies',
      'The Sinatra Doctrine',
      'Central Asian Strongmen',
      '“Death to Armenians!”',
      'Russia Declares Sovereignty',
      '28th Congress of the CPSU',
      '“Dictatorship is Coming!”',
      '“A Renewed Federation”',
      'Russian Popular Vote',
      'The ‘Chicken Kiev’ Speech',
      '“War on the Empire”',
    ];
    return cardTitles[cardNumber - 1];
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

  void setupDeck(Random random) {
    final red = <int>[];
    final gold = <int>[];
    final green = <int>[];
    final gray = <int>[];
    for (int i = 0; i < 27; ++i) {
      if (i < 7) {
        red.add(i);
      } else if (i < 15) {
        gold.add(i);
      } else if (i < 19) {
        green.add(i);
      } else {
        gray.add(i);
      }
    }
    red.shuffle(random);
    gold.shuffle(random);
    green.shuffle(random);
    gray.shuffle(random);
    _deck = red + gold + green + gray;
  }

  factory GameState.setupTray() {
    var state = GameState();

    state.setupPieceTypes([
      (PieceType.people, Location.trayPeople),
      (PieceType.vremya, Location.trayVremya),
      (PieceType.usPresident, Location.trayUsPresidents),
      (PieceType.massacre, Location.trayMassacre),
      (PieceType.disaster, Location.trayDisaster),
      (PieceType.warsawPact, Location.trayWarsawPact),
      (PieceType.politburo, Location.trayPolitburo),
      (PieceType.pravda, Location.trayPravda),
      (PieceType.demonstration, Location.trayDemonstration),
      (PieceType.kgb, Location.trayKgb),
      (PieceType.nuke, Location.trayNukes),
      (PieceType.forces, Location.trayForces),
      (PieceType.mvd, Location.trayMvd),
      (PieceType.doctrine, Location.trayDoctrine),
      (PieceType.asset, Location.trayAsset),
    ]);

    state.setupPieces([
      (Piece.markerYear, Location.trayYearSeason),
      (Piece.markerSeason, Location.trayYearSeason),
      (Piece.berlinWall, Location.trayBerlinWall),
      (Piece.markerPopularVote, Location.trayPopularVote),
      (Piece.markerLoyalCommunists, Location.trayLoyalCommunists),
      (Piece.uzbekMafia, Location.trayUzbekMafia),
    ]);

    return state;
  }

  factory GameState.setupStandard(Random random) {

    var state = GameState.setupTray();

    state.setupPieceTypes([
      (PieceType.disasterEarlier, Location.cupDisaster),
      (PieceType.massacre, Location.cupMassacre),
      (PieceType.warsawPact, Location.boxWarsawPact),
      (PieceType.kgb, Location.boxKgb),
      (PieceType.politburo, Location.boxPolitburoSupport),
    ]);

    state.setupPieces([
      (Piece.peopleRussiaWeak, Location.russiaWorkersParadise),
      (Piece.peopleBalticsWeak, Location.balticsWorkersParadise),
      (Piece.peopleCaucasusWeak, Location.caucasusWorkersParadise),
      (Piece.peopleCentralAsia, Location.centralAsiaWorkersParadise),
      (Piece.peopleCommunistPartyWeak, Location.communistParty12),
      (Piece.assetFiveYearPlan, Location.fiveYearPlan5),
      (Piece.assetMediaCulture, Location.mediaCulture5),
      (Piece.assetMilitaryMight, Location.militaryMight5),
      (Piece.forces40Army, Location.afghanistanMustStay),
      (Piece.forces28Corps, Location.easternEurope),
      (Piece.forces1GtkArmy, Location.ddr),
      (Piece.forces2GtkArmy, Location.ddr),
      (Piece.nukeInf, Location.ddr),
      (Piece.nukeIcbm, Location.easternEurope),
      (Piece.berlinWall, Location.ddr),
      (Piece.usPresidentReagan, Location.boxUsPresident),
      (Piece.doctrineBrezhnev, Location.boxDoctrine),
      (Piece.markerYear, Location.year1985),
      (Piece.markerSeason, Location.seasonWinter),
    ]);

    state.setupDeck(random);

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

/*

enum Phase {
  barbarian,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateBarbarian extends PhaseState {
  List<Location> groupInitialProvinces = [];
  List<int> groupInitialCounts = [];
  List<bool> groupCivilizeds = [];
  int? currentGroupIndex;
  Location? currentGroupProvince;
  List<Location> currentGroupTrail = [];

  PhaseStateBarbarian();

  PhaseStateBarbarian.fromJson(Map<String, dynamic> json) :
    groupInitialProvinces = locationListFromIndices(json['groupInitialProvinces']),
    groupInitialCounts = List<int>.from(json['groupInitialCounts']),
    groupCivilizeds = List<bool>.from(json['groupCivilizeds']),
    currentGroupIndex = json['currentGroupIndex'] as int?,
    currentGroupProvince = locationFromIndex(json['currentGroupProvince']),
    currentGroupTrail = locationListFromIndices(json['currentGroupTrail']);

  @override
  Map<String, dynamic> toJson() => {
    'groupInitialProvinces': locationListToIndices(groupInitialProvinces),
    'groupInitialCounts': groupInitialCounts,
    'groupCivilizeds': groupCivilizeds,
    'currentGroupIndex': currentGroupIndex,
    'currentGroupProvince': locationToIndex(currentGroupProvince),
    'currentGroupTrail': locationListToIndices(currentGroupTrail),
  };

  @override
  Phase get phase {
    return Phase.barbarian;
  }
}
*/

class Game {
  final Scenario _scenario;
  final GameState _state;
  int _step = 0;
  int _subStep = 0;
  GameOutcome? _outcome;
  final GameOptions _options;
  String _log = '';
  PlayerChoiceInfo _choiceInfo = PlayerChoiceInfo();
  //PhaseState? _phaseState;
  Random _random = Random();
  final int _gameId;

  Game(this._gameId, this._scenario, this._options, this._state, this._random)
    : _choiceInfo = PlayerChoiceInfo();

  Game.saved(this._gameId, this._scenario, this._options, this._state, this._step, this._subStep, this._log, Map<String, dynamic> gameStateJson) {
    _gameStateFromJson(gameStateJson);
  }

  void _gameStateFromJson(Map<String, dynamic> json) {
    /*
    _phaseState = null;
    final phaseIndex = json['phase'] as int?;
    if (phaseIndex != null) {
      final phaseStateJson = json['phaseState'];
      switch (Phase.values[phaseIndex]) {
      case Phase.barbarian:
        _phaseState = PhaseStateBarbarian.fromJson(phaseStateJson);
      }
    }
    */

    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
    /*
    if (_phaseState != null) {
      map['phase'] = _phaseState!.phase.index;
      map['phaseState'] = _phaseState!.toJson();
    }
    */
    map['choiceInfo'] = _choiceInfo.toJson();
    return map;
  }

  Future<void> saveSnapshot() async {
    await GameDatabase.instance.appendGameSnapshot(
      _gameId,
      jsonEncode(_state.toJson()),
      _step, _subStep,
      _state.turnName(_state.currentYear, _state.currentSeason),
      _log);
  }

  Future<void> saveCurrentState() async {
    await GameDatabase.instance.setGameState(
      _gameId,
      jsonEncode(_state.toJson()),
      _step, _subStep,
      _state.turnName(_state.currentYear, _state.currentSeason),
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

  // High-Level Functions

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
  }

  // Sequence Helpers

  // Sequence of Play

  void turnBegin() {
  }

  void timeForwardPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Time Forward Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
  }

  void timeForwardPhaseDrawCard() {
    _state.advanceSeason();
    logLine('# ${_state.turnName(_state.currentYear, _state.currentSeason)}');
    logLine('## Time Forward Phase');
    _state.advanceDeck();
    logLine('### ${_state.cardTitle(_state.currentCardNumber!)}');
  }

  void timeForwardPhaseAutumnOfNations() {
    if (_state.currentYear != 1989 || _state.currentSeason != 0) {
      return;
    }
    for (final disaster in _state.piecesInLocation(PieceType.disaster, Location.trayDisaster)) {
      _state.setPieceLocation(disaster, Location.cupDisaster);
    }
  }

  void gorbymaniaPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Gorbymania Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Gorbymania Phase');
  }

  void gorbymaniaPhaseCheckGorbymania() {
    logLine('### Gorbymania');
    if (_state.pieceLocation(Piece.politburoGorbachev) == Location.boxGorbymania) {
      logLine('> Gorbachev returns to Politburo duties.');
      _state.setPieceLocation(Piece.politburoGorbachev, Location.boxPolitburoSupport);
    } else {
      int die = rollD6();
      if (die >= 5) {
        logLine('> Gorbachev goes on extended leave from the Politburo.');
        _state.setPieceLocation(Piece.politburoGorbachev, Location.boxGorbymania);
      } else {
        logLine('> Gorbachev remains in the Politburo.');
      }
    }
  }

  void gorbymaniaPhaseBreakUpDemonstrations() {
    if (_state.pieceLocation(Piece.politburoGorbachev) != Location.boxGorbymania) {
      return;
    }
    if (_state.piecesInLocationCount(PieceType.demonstration, Location.trayDemonstration) == PieceType.demonstration.count) {
      return;
    }
    if (choicesEmpty()) {
      setPrompt('Remove all Demonstration markers?');
      choiceChoosable(Choice.yes, true);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.yes)) {
      logLine('> Gorbachev defuses all Demonstrations.');
      for (final demonstration in PieceType.demonstration.pieces) {
        if (_state.pieceLocation(demonstration) != Location.trayDemonstration) {
          _state.setPieceLocation(demonstration, Location.trayDemonstration);
        }
      }
    }
    clearChoices();
  }

  void eventsPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Events Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Events Phase');
  }

  void demonstration() {
    

  }

  void disaster() {

  }

  void downAssetFiveYearPlan() {

  }

  void downAssetMediaAndCulture() {

  }

  void downAssetMilitaryMight() {

  }

  void downPathBaltics() {

  }

  void downPathCaucasus() {

  }

  void downPathCentralAsia() {

  }

  void downPathCPSU() {

  }

  void downPathRussia() {

  }

  void massacre() {

  }

  void specialEventLigachevsChallenge() {
    logLine('### Ligachev’s Challenge');
    logLine('> Ligachev tries to win back his post as Party deputy leader.');
    int die = rollD6();
    if (die <= 2) {
      logLine('> Ligachev is reinstated as deputy leader.');
      final people = _state.pathPeople(Path.communistParty);
      final location = _state.pieceLocation(people);
      _state.setPieceLocation(Piece.politburoLigachev, location);
    } else {
      logLine('> Ligachev fails and retires.');
      _state.setPieceLocation(Piece.politburoLigachev, Location.discarded);
    }
  }

  void specialEventLoyalCommunists() {
    if (_state.pieceLocation(Piece.peopleCentralAsia) != Location.centralAsiaWorkersParadise) {
      return;
    }
    final uzbekLocation = _state.pieceLocation(Piece.uzbekMafia);
    if (uzbekLocation.isType(LocationType.land)) {
      return;
    }
    logLine('### Loyal Communists');
    logLine('> Communists of Central Asia are reliably loyal.');
    _state.setPieceLocation(Piece.markerLoyalCommunists, Location.boxPathCentralAsia);
  }

  void specialEventNinaAndreyevaAffair() {
    logLine('### The Nina Andreyeva Affair');
    // TODO
  }

  void specialEventPlaceLigachev() {
    logLine('### Yegor Ligachev');
    final people = _state.pathPeople(Path.communistParty);
    final location = _state.pieceLocation(people);
    logLine('> Ligachev is placed in ${location.desc}.');
    _state.setPieceLocation(Piece.politburoLigachev, location);
  }

  void specialEventPlaceYeltsin() {
    logLine('### Boris Yeltsin');
    final people = _state.pathPeople(Path.russia);
    final location = _state.pieceLocation(people);
    logLine('> Yeltsin is placed in ${location.desc}.');
    _state.setPieceLocation(Piece.politburoYeltsin, location);
  }

  void specialEventPolitburoOpposition() {
    if (_state.piecesInLocationCount(PieceType.politburo, Location.boxPolitburoSupport) == 0) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Politburo Opposition');
      _subStep = 1;
    }
    if (_subStep == 1) {
      if (choicesEmpty()) {
        setPrompt('Select Politburo member');
        if (_state.pieceLocation(Piece.politburoSchevardnadze) == Location.boxPolitburoSupport) {
          pieceChoosable(Piece.politburoSchevardnadze);
        } else {
          for (final politician in PieceType.politburo.pieces) {
            pieceChoosable(politician);
          }
        }
        throw PlayerChoiceException();
      }
      final politician = selectedPiece()!;
      logLine('> ${politician.desc} opposes Gorbachev.');
      _state.setPieceLocation(politician, Location.boxPolitburoOpposition);
    }
  }

  void specialEventPresidentialPowers() {
    if (_subStep == 0) {
      logLine('### Presidential Powers');
      int die = rollD6();
      switch (die) {
      case 1:
        logLine('> The Baltics and Caucasus disapprove of the use of Presidential Powers.');
        downPathBaltics();
        _subStep = 1;
      case 2:
        logLine('> The Baltics disapprove of the use of Presidential Powers.');
        downPathBaltics();
      case 3:
        logLine('> The Caucasus disapproves of the use of Presidential Powers.');
        downPathCaucasus();
      case 4:
        logLine('> Nobody notices the use of Presidential Powers.');
      case 5:
        logLine('> Russians approve of the use of Presidential Powers.');
        upPathRussia();
      case 6:
        logLine('> Presidential Powers are used to increase Military Might.');
        upAssetMilitaryMight();
      }
    }
    if (_subStep == 1) {
      downPathCaucasus();
    }
  }

  void specialEventReplaceBaltics() {
    logLine('### Replace Baltics');
    logLine('> Opposition strengthens in the Baltics.');
    final land = _state.pieceLocation(Piece.peopleBalticsWeak);
    _state.setPieceLocation(Piece.peopleBalticsStrong, land);
    _state.setPieceLocation(Piece.peopleBalticsWeak, Location.discarded);
  }

  void specialEventReplaceCaucasus() {
    logLine('### Replace Caucasus');
    logLine('> Opposition strengthens in the Caucasus.');
    final land = _state.pieceLocation(Piece.peopleCaucasusWeak);
    _state.setPieceLocation(Piece.peopleCaucasusStrong, land);
    _state.setPieceLocation(Piece.peopleCaucasusWeak, Location.discarded);
  }

  void specialEventReplaceCPSU() {
    logLine('### Replace CPSU');
    logLine('> Opposition strengthens within the party.');
    final land = _state.pieceLocation(Piece.peopleCommunistPartyWeak);
    _state.setPieceLocation(Piece.peopleCommunistPartyStrong, land);
    _state.setPieceLocation(Piece.peopleCommunistPartyWeak, Location.discarded);
  }

  void specialEventReplaceRussia() {
    logLine('### Replace Russia');
    logLine('> Opposition strengthens in Russia.');
    final land = _state.pieceLocation(Piece.peopleRussiaWeak);
    _state.setPieceLocation(Piece.peopleRussiaStrong, land);
    _state.setPieceLocation(Piece.peopleRussiaWeak, Location.discarded);
  }

  void specialEventSinatraDoctrine() {
    logLine('### Sinatra Doctrine');
    logLine('> More autonomy given to Warsaw Pact member states.');
    _state.setPieceLocation(Piece.doctrineBrezhnev, Location.discarded);
    _state.setPieceLocation(Piece.doctrineSinatra, Location.boxDoctrine);
  }

  void specialEventStingerMissiles() {
    logLine('### Stinger Missiles');
    logLine('> US anti-aircraft missiles turn the tide in Afghanistan.');
    _state.setPieceLocation(Piece.forces40Army, Location.afghanistanMayLeave);
  }

  void specialEventWarsawPactDissolved() {
    logLine('### Warsaw Pact Dissolved?');
    int die = rollD6();
    final warsawPactAllies = _state.piecesInLocation(PieceType.warsawPact, Location.boxWarsawPact);
    if (die > warsawPactAllies.length) {
      logLine('> The Warsaw Pact is dissolved.');
      for (final ally in warsawPactAllies) {
        _state.setPieceLocation(ally, Location.discarded);
      }
    } else {
      logLine('> The Warsaw Pact remains intact.');
    }
  }

  void specialEventYeltsinDefeated() {
    final popularVoteLocation = _state.pieceLocation(Piece.markerPopularVote);
    if (!popularVoteLocation.isType(LocationType.pathRussia)) {
      return;
    }
    logLine('### Yeltsin Defeated?');
    logLine('> Yeltsin seeks election as Chairman of the Russian Supreme Soviet.');
    int die = rollD6();
    if (die <= 4) {
      logLine('> Yeltsin wins the election.');
    } else {
      logLine('> Yeltsin loses the election and withdraws from politics.');
      _state.setPieceLocation(Piece.politburoYeltsin, Location.discarded);
    }
  }

  void specialEventYeltsinElected() {
    if (_state.pieceLocation(Piece.politburoYeltsin) == Location.discarded) {
      return;
    }
    logLine('### Yeltsin Elected');
    logLine('> Boris Yeltsin is elected President of Russia.');
    final people = _state.pathPeople(Path.russia);
    final location = _state.pieceLocation(people);
    logLine('> Yeltsin is placed in ${location.desc}.');
    _state.setPieceLocation(Piece.politburoYeltsin, location);
    _state.setPieceLocation(Piece.markerPopularVote, location);
  }

  void upAssetFiveYearPlan() {

  }

  void upAssetMediaAndCulture() {

  }

  void upAssetMilitaryMight() {

  }

  void upPathCentralAsia() {

  }

  void upPathCPSU() {

  }

  void upPathRussia() {

  }

  void eventsPhaseEvent(int index) {
    final cardEventHandlers = {
      1: [demonstration, downPathRussia, downAssetFiveYearPlan],
      2: [downPathBaltics, downAssetFiveYearPlan],
      3: [specialEventStingerMissiles, downPathCentralAsia, upPathRussia],
      4: [downPathCaucasus, downPathCPSU],
      5: [disaster, downPathCPSU, downAssetMediaAndCulture],
      6: [disaster, downAssetMediaAndCulture, downAssetMilitaryMight],
      7: [massacre, downPathRussia, downPathCentralAsia, downAssetMediaAndCulture],
      8: [specialEventPlaceLigachev, demonstration, downPathBaltics, downPathCPSU, downAssetMediaAndCulture],
      9: [demonstration, disaster, downPathRussia, downPathBaltics, downPathCaucasus, downPathCPSU, downAssetMediaAndCulture],
      10: [demonstration, downPathCentralAsia, downAssetFiveYearPlan, downAssetMediaAndCulture],
      11: [specialEventPlaceYeltsin, demonstration, downPathRussia, downPathCaucasus, downAssetMediaAndCulture],
      12: [specialEventReplaceCaucasus, demonstration, massacre, downPathRussia, downPathCaucasus, downPathCentralAsia, downAssetFiveYearPlan, downAssetMilitaryMight],
      13: [specialEventNinaAndreyevaAffair],
      14: [demonstration, disaster, downPathBaltics, downPathCPSU, downAssetFiveYearPlan],
      15: [specialEventReplaceBaltics, demonstration, disaster, downPathRussia, downPathBaltics, downAssetMilitaryMight],
      16: [massacre, downPathRussia, downPathCaucasus, downAssetMilitaryMight],
      17: [specialEventReplaceRussia, demonstration, massacre, downPathCentralAsia, downAssetFiveYearPlan],
      18: [specialEventSinatraDoctrine, demonstration, massacre, disaster, downPathBaltics, downPathCaucasus, downAssetMilitaryMight],
      19: [specialEventLoyalCommunists, disaster, disaster, downPathBaltics, downPathCaucasus, upAssetFiveYearPlan, upAssetMediaAndCulture],
      20: [specialEventPresidentialPowers, demonstration, massacre, downPathBaltics, downPathCaucasus, downPathCentralAsia, downPathCPSU, downAssetMediaAndCulture],
      21: [demonstration, downPathRussia, downPathBaltics, downPathCPSU, downPathCentralAsia, downAssetFiveYearPlan],
      22: [specialEventReplaceCPSU, specialEventLigachevsChallenge, specialEventYeltsinDefeated, demonstration, disaster, downPathCaucasus, upPathCPSU, downAssetMilitaryMight],
      23: [specialEventPolitburoOpposition, downPathRussia, downPathCaucasus],
      24: [specialEventWarsawPactDissolved, demonstration, massacre, disaster, upPathRussia, upPathCentralAsia, upPathCPSU, downAssetFiveYearPlan],
      25: [specialEventYeltsinElected, demonstration, massacre, downPathRussia, downPathBaltics, downPathCPSU, downAssetFiveYearPlan, downAssetMediaAndCulture],
      26: [downPathBaltics, upAssetMilitaryMight],
      27: [demonstration, disaster, downPathCaucasus, downPathCentralAsia, downAssetMediaAndCulture, downAssetMilitaryMight],
    };
    final eventHandlers = cardEventHandlers[_state.currentCardNumber!];
    if (eventHandlers == null) {
      return;
    }
    if (index >= eventHandlers.length) {
      return;
    }
    eventHandlers[index]();
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

  void eventsPhaseEvent6() {
    eventsPhaseEvent(6);
  }

  void eventsPhaseEvent7() {
    eventsPhaseEvent(7);
  }

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      timeForwardPhaseBegin,
      timeForwardPhaseDrawCard,
      timeForwardPhaseAutumnOfNations,
      gorbymaniaPhaseBegin,
      gorbymaniaPhaseCheckGorbymania,
      gorbymaniaPhaseBreakUpDemonstrations,
      eventsPhaseBegin,
      eventsPhaseEvent0,
      eventsPhaseEvent1,
      eventsPhaseEvent2,
      eventsPhaseEvent3,
      eventsPhaseEvent4,
      eventsPhaseEvent5,
      eventsPhaseEvent6,
      eventsPhaseEvent7,
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

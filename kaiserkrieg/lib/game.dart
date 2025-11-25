import 'dart:convert';
import 'dart:math';
import 'package:kaiserkrieg/db.dart';
import 'package:kaiserkrieg/random.dart';

enum Location {
  belgium,
  france,
  italy,
  serbia,
  ukraine,
  lithuania,
  belgiumReserves,
  franceReserves,
  italyReserves,
  serbiaReserves,
  ukraineReserves,
  lithuaniaReserves,
  armenia,
  mespotamia,
  palestine,
  yerevan,
  india,
  egypt,
  germany,
  austriaHungary,
  turkey,
  eastAfrica,
  gallipoli,
  ireland,
  roumania,
  bulgaria,
  senussiRevolt,
  sea1a,
  sea1b,
  sea2a,
  sea2b,
  sea2c,
  sea3,
  sea4,
  britishCruisers,
  blockadeRunners,
  neutralPorts,
  airSuperiority_0,
  airSuperiority_1,
  airSuperiority_2,
  airSuperiority_3,
  airSuperiority_4,
  ruhe,
  unruhe,
  omnibus_0,
  omnibus_1,
  omnibus_2,
  omnibus_3,
  omnibus_4,
  omnibus_5,
  omnibus_6,
  omnibus_7,
  omnibus_8,
  omnibus_9,
  omnibus_10,
  omnibus_11,
  omnibus_12,
  omnibus_13,
  calendar_1,
  calendar_2,
  calendar_3,
  calendar_4,
  calendar_5,
  calendar_6,
  calendar_7,
  calendar_8,
  calendar_9,
  calendar_10,
  calendar_11,
  calendar_12,
  calendar_13,
  calendar_14,
  calendar_15,
  calendar_16,
  calendar_17,
  calendar_18,
  calendar_19,
  calendar_20,
  calendar_21,
  calendar_22,
  calendar_23,
  calendar_24,
  calendar_25,
  calendar_26,
  calendar_27,
  calendarHundredDays,
  eventPutnik,
  eventBritishShellShortage,
  eventPoisonGas,
  eventMackensen,
  eventPlaceOfExecution,
  eventBrusilov,
  eventStosstruppen,
  eventHoffmann,
  eventAlpenkorps,
  eventFoch,
  eventSpanishFlu,
  eventUSAssistance,
  eventDiaz,
  eventBlackDayOfTheArmy,
  drawCup,
  liraCup,
  trayTurn,
  trayEconomic,
  trayCentralPowersSociety,
  trayFrench,
  trayItalian,
  traySerbian,
  trayArmenian,
  trayRoumanian,
  trayAao,
  trayAmerican,
  trayCentralPowersSpecialty,
  trayRussian,
  trayBritish,
  trayNaval,
  trayEntenteSpecialty,
  trayPink,
  trayMarkers,
  trayOttoman,
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
  reserves,
  nearEastTheater,
  nearEastReserves,
  sea,
  northSea,
  airSuperiority,
  omnibus,
  calendar,
  calendarWithHundredDays,
  event,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.front: [Location.belgium, Location.lithuania],
    LocationType.reserves: [Location.belgiumReserves, Location.lithuaniaReserves],
    LocationType.nearEastTheater: [Location.armenia, Location.palestine],
    LocationType.nearEastReserves: [Location.yerevan, Location.egypt],
    LocationType.sea: [Location.sea1a, Location.sea4],
    LocationType.northSea: [Location.sea2b, Location.sea4],
    LocationType.airSuperiority: [Location.airSuperiority_0, Location.airSuperiority_4],
    LocationType.omnibus: [Location.omnibus_0, Location.omnibus_13],
    LocationType.calendar: [Location.calendar_1, Location.calendar_27],
    LocationType.calendarWithHundredDays: [Location.calendar_1, Location.calendarHundredDays],
    LocationType.event: [Location.eventPutnik, Location.eventBlackDayOfTheArmy],
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
  bool isType(LocationType locationType) {
    return index >= locationType.firstIndex && index < locationType.lastIndex;
  }
}

enum Piece {
  armyAao1,
  armyAao2,
  armyAaoNdac,
  armyAaoOrient,
  armyAaoSalonika,
  armyArab,
  armyArmenia1,
  armyArmenia2,
  armyAssyria,
  armyBelgium,
  armyBritain1,
  armyBritain2,
  armyBritain3,
  armyBritain4,
  armyBritainBef,
  armyBritainDunster,
  armyBritainLawrence,
  armyBritainMef,
  armyBritain20,
  armySouthAfrica,
  armyFrance1,
  armyFrance2,
  armyFrance3,
  armyFrance4,
  armyFrance5,
  armyIndiaA,
  armyIndiaB,
  armyIndiaC,
  armyIndiaD,
  armyItaly1,
  armyItaly2,
  armyItaly3,
  armyItaly4,
  armyItalyCarnia,
  armyRoumania1,
  armyRoumania2,
  armyRoumaniaNorth,
  armyRussia1,
  armyRussia2,
  armyRussia3,
  armyRussia4,
  armyRussia5,
  armyRussia6,
  armyRussia7,
  armyRussia8,
  armyRussia9,
  armyRussia10,
  armyRussiaCaucasus,
  armyRussiaCossack,
  armyRussiaKars,
  armyRussiaTurkestan,
  armySerbia1,
  armySerbia2,
  armySerbia3,
  armySerbiaMontenegro,
  armySerbiaUzice,
  armyUsa1,
  armyUsa4,
  armyUsa5,
  armyUsa6,
  tank,
  forts_0,
  forts_1,
  siegfriedLine,
  trenches_0,
  trenches_1,
  overTheTopAao,
  overTheTopBritain,
  overTheTopFrance,
  overTheTopItaly,
  overTheTopRussia_0,
  overTheTopRussia_1,
  overTheTopSerbia,
  pinkFrance,
  pinkItaly,
  pinkRussia_0,
  pinkRussia_1,
  pinkSerbia,
  armenians,
  askari_0,
  askari_1,
  siegeKut,
  cruiser_0,
  cruiser_1,
  cruiser_2,
  cruiser_3,
  blockadeRunnerDenmark,
  blockadeRunnerNetherlands,
  blockadeRunnerNorway,
  blockadeRunnerSweden,
  uboats_0,
  uboats_1,
  highSeasFleet,
  cityBerlin,
  cityBreslau,
  cityCologne,
  cityDresden,
  cityFrankfurt,
  cityHamburg,
  cityLeipzig,
  cityMunich,
  cityPrague,
  cityVienna,
  cityBudapest,
  airSuperiority,
  bombersBritish,
  bombersGerman,
  zeppelin,
  redBaron,
  hindenLuden,
  civilConstitution,
  civilFreePress,
  civilRuleOfLaw,
  krupp,
  kaisertreu,
  railway,
  kemal,
  neutralBulgaria,
  neutralItaly,
  neutralOttoman,
  neutralRoumania,
  surrenderFrance,
  surrenderItaly,
  surrenderOttoman,
  surrenderRoumania,
  frenchMutiny,
  roumaniaHypothesis,
  specialEvent,
  reichsmark,
  lira,
  lira0_0,
  lira0_1,
  lira0_2,
  lira1_0,
  lira1_1,
  lira1_2,
  lira2_0,
  lira2_1,
  lira2_2,
  lira2_3,
  lira2_4,
  lira3_0,
  lira3_1,
  lira3_2,
  lira4_0,
  lira4_1,
  lira5_0,
  lira5_1,
  turn01,
  turn02,
  turn03,
  turn04,
  turn05,
  turn06,
  turn07,
  turn08,
  turn09,
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
  armyArabInactive,
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
  army,
  aaoArmy,
  britishArmy,
  indianArmy,
  italianArmy,
  roumanianArmy,
  russianArmy,
  serbianArmy,
  americanArmy,
  forts,
  trenches,
  overTheTop,
  pink,
  askari,
  cruiser,
  blockadeRunner,
  uboats,
  city,
  civilSociety,
  lira,
  turn,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.armyAao1, Piece.armyArabInactive],
    PieceType.army: [Piece.armyAao1, Piece.armyUsa6],
    PieceType.aaoArmy: [Piece.armyAao1, Piece.armyAaoSalonika],
    PieceType.britishArmy: [Piece.armyBritain1, Piece.armySouthAfrica],
    PieceType.indianArmy: [Piece.armyIndiaA, Piece.armyIndiaD],
    PieceType.italianArmy: [Piece.armyItaly1, Piece.armyItalyCarnia],
    PieceType.roumanianArmy: [Piece.armyRoumania1, Piece.armyRoumaniaNorth],
    PieceType.russianArmy: [Piece.armyRussia1, Piece.armyRussiaTurkestan],
    PieceType.serbianArmy: [Piece.armySerbia1, Piece.armySerbiaUzice],
    PieceType.americanArmy: [Piece.armyUsa1, Piece.armyUsa6],
    PieceType.forts: [Piece.forts_0, Piece.forts_1],
    PieceType.trenches: [Piece.trenches_0, Piece.trenches_1],
    PieceType.overTheTop: [Piece.overTheTopAao, Piece.overTheTopSerbia],
    PieceType.pink: [Piece.pinkFrance, Piece.pinkSerbia],
    PieceType.askari: [Piece.askari_0, Piece.askari_1],
    PieceType.cruiser: [Piece.cruiser_0, Piece.cruiser_3],
    PieceType.blockadeRunner: [Piece.blockadeRunnerDenmark, Piece.blockadeRunnerSweden],
    PieceType.uboats: [Piece.uboats_0, Piece.uboats_1],
    PieceType.city: [Piece.cityBerlin, Piece.cityBudapest],
    PieceType.civilSociety: [Piece.civilConstitution, Piece.civilRuleOfLaw],
    PieceType.lira: [Piece.lira0_0, Piece.lira5_1],
    PieceType.turn: [Piece.turn01, Piece.turn28],
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
  bool isType(PieceType pieceType) {
    return index >= pieceType.firstIndex && index < pieceType.lastIndex;
  }
}

enum Scenario {
  campaign,
}

extension ScenarioExtension on Scenario {
  String get desc {
    const scenarioDescs = {
      Scenario.campaign: 'Campaign',
    };
    return scenarioDescs[this]!;
  }

  String get longDesc {
    const scenarioDescs = {
      Scenario.campaign: 'Campaign (27 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

class GameOptions {
  bool historicalCruisers = false;
  bool theHundredDays = false;
  bool indiansTwoRolls = false;

  GameOptions();

  GameOptions.fromJson(Map<String, dynamic> json)
    : historicalCruisers = json['historicalCruisers'] as bool
    , theHundredDays = json['theHundredDays'] as bool
    , indiansTwoRolls = json['indiansTwoRolls'] as bool
    ;

  Map<String, dynamic> toJson() => {
    'historicalCruisers': historicalCruisers,
    'theHundredDays': theHundredDays,
    'indiansTwoRolls': indiansTwoRolls,
  };

  String get desc {
    String optionsList = '';
    if (historicalCruisers) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Historical British Cruisers';
    }
    if (theHundredDays) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'The Hundred Days';
    }
    if (indiansTwoRolls) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Indians attack Askari twice';
    }
    return optionsList;
  }
}

class GameState {
  int turn = 0;
  List<Location> pieceLocations = List<Location>.filled(Piece.values.length, Location.discarded);
  Piece? redBaronTarget;
  bool placeOfExecutionHappened = false;

  GameState();

  GameState.fromJson(Map<String, dynamic> json) :
    turn =  json['turn'] as int,
    pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations'])),
    redBaronTarget = pieceFromIndex(json['redBaronTarget'] as int?),
    placeOfExecutionHappened = json['placeOfExecutionHappened'] as bool;

  Map<String, dynamic> toJson() => {
    'turn': turn,
    'pieceLocations': locationListToIndices(pieceLocations),
    'redBaronTarget': pieceToIndex(redBaronTarget),
    'placeOfExecutionHappened': placeOfExecutionHappened,
  };

  Location pieceLocation(Piece piece) {
    return pieceLocations[piece.index];
  }

  void setPieceLocation(Piece piece, Location location) {
    pieceLocations[piece.index] = location;
  }

  void setPieceLocations(Map<Piece,Location> pieceLocations) {
    for (final pieceLocation in pieceLocations.entries) {
      setPieceLocation(pieceLocation.key, pieceLocation.value);
    }
  }

  factory GameState.counterTray() {

    var state = GameState();

    for (final turnChit in PieceType.turn.pieces) {
      state.setPieceLocation(turnChit, Location.trayTurn);
    }
    for (final lira in PieceType.lira.pieces) {
      state.setPieceLocation(lira, Location.trayEconomic);
    }
    for (final Piece city in PieceType.city.pieces) {
      state.setPieceLocation(city, Location.trayCentralPowersSociety);
    }

    state.setPieceLocations({
        Piece.reichsmark: Location.trayEconomic,
        Piece.railway: Location.trayEconomic,
        Piece.civilFreePress: Location.trayCentralPowersSociety,
        Piece.civilConstitution: Location.trayCentralPowersSociety,
        Piece.civilRuleOfLaw: Location.trayCentralPowersSociety,
        Piece.armyFrance1: Location.trayFrench,
        Piece.armyFrance2: Location.trayFrench,
        Piece.armyFrance3: Location.trayFrench,
        Piece.armyFrance4: Location.trayFrench,
        Piece.armyFrance5: Location.trayFrench,
        Piece.overTheTopFrance: Location.trayFrench,
        Piece.tank: Location.trayFrench,
        Piece.surrenderFrance: Location.trayFrench,
        Piece.armyItaly1: Location.trayItalian,
        Piece.armyItaly2: Location.trayItalian,
        Piece.armyItaly3: Location.trayItalian,
        Piece.armyItaly4: Location.trayItalian,
        Piece.armyItalyCarnia: Location.trayItalian,
        Piece.overTheTopItaly: Location.trayItalian,
        Piece.neutralItaly: Location.trayItalian,
        Piece.surrenderItaly: Location.trayItalian,
        Piece.armySerbia1: Location.traySerbian,
        Piece.armySerbia2: Location.traySerbian,
        Piece.armySerbia3: Location.traySerbian,
        Piece.armySerbiaMontenegro: Location.traySerbian,
        Piece.armySerbiaUzice: Location.traySerbian,
        Piece.overTheTopSerbia: Location.traySerbian,
        Piece.armyArmenia1: Location.trayArmenian,
        Piece.armyArmenia2: Location.trayArmenian,
        Piece.armyAssyria: Location.trayArmenian,
        Piece.armyBritainDunster: Location.trayArmenian,
        Piece.armenians: Location.trayArmenian,
        Piece.armyRoumania1: Location.trayRoumanian,
        Piece.armyRoumania2: Location.trayRoumanian,
        Piece.armyRoumaniaNorth: Location.trayRoumanian,
        Piece.neutralRoumania: Location.trayRoumanian,
        Piece.surrenderRoumania: Location.trayRoumanian,
        Piece.roumaniaHypothesis: Location.trayRoumanian,
        Piece.armyAao1: Location.trayAao,
        Piece.armyAao2: Location.trayAao,
        Piece.armyAaoNdac: Location.trayAao,
        Piece.armyAaoOrient: Location.trayAao,
        Piece.armyAaoSalonika: Location.trayAao,
        Piece.overTheTopAao: Location.trayAao,
        Piece.armyUsa1: Location.trayAmerican,
        Piece.armyUsa4: Location.trayAmerican,
        Piece.armyUsa5: Location.trayAmerican,
        Piece.armyUsa6: Location.trayAmerican,
        Piece.krupp: Location.trayCentralPowersSpecialty,
        Piece.askari_0: Location.trayCentralPowersSpecialty,
        Piece.askari_1: Location.trayCentralPowersSpecialty,
        Piece.hindenLuden: Location.trayCentralPowersSpecialty,
        Piece.zeppelin: Location.trayCentralPowersSpecialty,
        Piece.redBaron: Location.trayCentralPowersSpecialty,
        Piece.bombersGerman: Location.trayCentralPowersSpecialty,
        Piece.siegfriedLine: Location.trayCentralPowersSpecialty,
        Piece.kaisertreu: Location.trayCentralPowersSpecialty,
        Piece.armyRussia1: Location.trayRussian,
        Piece.armyRussia2: Location.trayRussian,
        Piece.armyRussia3: Location.trayRussian,
        Piece.armyRussia4: Location.trayRussian,
        Piece.armyRussia5: Location.trayRussian,
        Piece.armyRussia6: Location.trayRussian,
        Piece.armyRussia7: Location.trayRussian,
        Piece.armyRussia8: Location.trayRussian,
        Piece.armyRussia9: Location.trayRussian,
        Piece.armyRussia10: Location.trayRussian,
        Piece.armyRussiaCossack: Location.trayRussian,
        Piece.armyRussiaKars: Location.trayRussian,
        Piece.armyRussiaCaucasus: Location.trayRussian,
        Piece.armyRussiaTurkestan: Location.trayRussian,
        Piece.overTheTopRussia_0: Location.trayRussian,
        Piece.overTheTopRussia_1: Location.trayRussian,
        Piece.armyBritain1: Location.trayBritish,
        Piece.armyBritain2: Location.trayBritish,
        Piece.armyBritain3: Location.trayBritish,
        Piece.armyBritain4: Location.trayBritish,
        Piece.armyBritain20: Location.trayBritish,
        Piece.armyBritainLawrence: Location.trayBritish,
        Piece.overTheTopBritain: Location.trayBritish,
        Piece.armyBritainMef: Location.trayBritish,
        Piece.armyBritainBef: Location.trayBritish,
        Piece.bombersBritish: Location.trayBritish,
        Piece.blockadeRunnerDenmark: Location.trayNaval,
        Piece.blockadeRunnerNetherlands: Location.trayNaval,
        Piece.blockadeRunnerNorway: Location.trayNaval,
        Piece.blockadeRunnerSweden: Location.trayNaval,
        Piece.cruiser_0: Location.trayNaval,
        Piece.cruiser_1: Location.trayNaval,
        Piece.cruiser_2: Location.trayNaval,
        Piece.cruiser_3: Location.trayNaval,
        Piece.highSeasFleet: Location.trayNaval,
        Piece.uboats_0: Location.trayNaval,
        Piece.uboats_1: Location.trayNaval,
        Piece.forts_0: Location.trayEntenteSpecialty,
        Piece.forts_1: Location.trayEntenteSpecialty,
        Piece.trenches_0: Location.trayEntenteSpecialty,
        Piece.trenches_1: Location.trayEntenteSpecialty,
        Piece.frenchMutiny: Location.trayEntenteSpecialty,
        Piece.armyBelgium: Location.trayEntenteSpecialty,
        Piece.armyIndiaA: Location.trayEntenteSpecialty,
        Piece.armyIndiaB: Location.trayEntenteSpecialty,
        Piece.armyIndiaC: Location.trayEntenteSpecialty,
        Piece.armyIndiaD: Location.trayEntenteSpecialty,
        Piece.airSuperiority: Location.trayEntenteSpecialty,
        Piece.armyArab: Location.trayEntenteSpecialty,
        Piece.armySouthAfrica: Location.trayEntenteSpecialty,
        Piece.pinkRussia_0: Location.trayPink,
        Piece.pinkRussia_1: Location.trayPink,
        Piece.pinkFrance: Location.trayPink,
        Piece.pinkItaly: Location.trayPink,
        Piece.pinkSerbia: Location.trayPink,
        Piece.neutralBulgaria: Location.trayMarkers,
        Piece.specialEvent: Location.trayMarkers,
        Piece.kemal: Location.trayOttoman,
        Piece.surrenderOttoman: Location.trayOttoman,
        Piece.neutralOttoman: Location.trayOttoman,
        Piece.siegeKut: Location.trayOttoman,
      }
    );

    return state;
  }

  factory GameState.campaign(GameOptions options, Random random) {

    var state = GameState.counterTray();

    for (final turnChit in PieceType.turn.pieces) {
      if (turnChit != Piece.turn01) {
        state.setPieceLocation(turnChit, Location.drawCup);
      }
    }
    for (final lira in PieceType.lira.pieces) {
      state.setPieceLocation(lira, Location.liraCup);
    }
    for (final city in PieceType.city.pieces) {
      state.setPieceLocation(city, Location.ruhe);
    }

    final indianArmies = PieceType.indianArmy.pieces;
    indianArmies.shuffle(random);

    final blockadeRunners = PieceType.blockadeRunner.pieces;
    blockadeRunners.shuffle(random);

    state.setPieceLocations({
        Piece.turn01: Location.calendar_1,
        Piece.armyFrance2: Location.france,
        Piece.armyFrance3: Location.france,
        Piece.armyFrance1: Location.franceReserves,
        Piece.armyFrance4: Location.franceReserves,
        Piece.armyFrance5: Location.franceReserves,
        Piece.overTheTopFrance: Location.franceReserves,
        Piece.armyRussia1: Location.lithuania,
        Piece.armyRussia2: Location.lithuania,
        Piece.armyRussia4: Location.lithuania,
        Piece.armyRussia6: Location.lithuaniaReserves,
        Piece.armyRussia10: Location.lithuaniaReserves,
        Piece.overTheTopRussia_0: Location.lithuaniaReserves,
        Piece.armyRussia3: Location.ukraine,
        Piece.armyRussia5: Location.ukraine,
        Piece.armyRussia7: Location.ukraine,
        Piece.armyRussia8: Location.ukraineReserves,
        Piece.armyRussia9: Location.ukraineReserves,
        Piece.overTheTopRussia_1: Location.ukraineReserves,
        Piece.armyRussiaCaucasus: Location.yerevan,
        Piece.armyRussiaCossack: Location.yerevan,
        Piece.armyRussiaKars: Location.yerevan,
        Piece.armyRussiaTurkestan: Location.yerevan,
        Piece.armyItaly1: Location.italy,
        Piece.armyItaly2: Location.italy,
        Piece.armyItaly3: Location.italy,
        Piece.armyItaly4: Location.italyReserves,
        Piece.armyItalyCarnia: Location.italyReserves,
        Piece.overTheTopItaly: Location.italyReserves,
        Piece.armySerbia1: Location.serbia,
        Piece.armySerbia2: Location.serbia,
        Piece.armySerbia3: Location.serbia,
        Piece.armySerbiaUzice: Location.serbiaReserves,
        Piece.armySerbiaMontenegro: Location.serbiaReserves,
        Piece.overTheTopSerbia: Location.serbiaReserves,
        indianArmies[0]: Location.india,
        indianArmies[1]: Location.india,
        indianArmies[2]: Location.india,
        indianArmies[3]: Location.eastAfrica,
        Piece.armyBelgium: Location.belgium,
        Piece.armyBritainBef: Location.belgium,
        Piece.armyBritain1: Location.belgium,
        Piece.armyBritain3: Location.belgiumReserves,
        Piece.armyBritain4: Location.belgiumReserves,
        Piece.overTheTopBritain: Location.belgiumReserves,
        Piece.armyBritainLawrence: Location.egypt,
        Piece.armyBritain20: Location.egypt,
        Piece.armySouthAfrica: Location.egypt,
        Piece.armyArabInactive: Location.palestine,
        Piece.armyArab: Location.discarded,
        Piece.forts_0: Location.belgium,
        Piece.forts_1: Location.france,
        Piece.reichsmark: Location.omnibus_0,
        Piece.lira: Location.omnibus_0,
        Piece.krupp: Location.omnibus_5,
        Piece.kaisertreu: Location.omnibus_3,
        Piece.pinkRussia_0: Location.omnibus_0,
        Piece.highSeasFleet: Location.germany,
        blockadeRunners[0]: Location.neutralPorts,
        blockadeRunners[1]: Location.neutralPorts,
        blockadeRunners[2]: Location.neutralPorts,
        blockadeRunners[3]: Location.blockadeRunners,
        Piece.cruiser_0: Location.britishCruisers,
        Piece.neutralBulgaria: Location.bulgaria,
        Piece.neutralItaly: Location.italy,
        Piece.neutralRoumania: Location.roumania,
        Piece.neutralOttoman: Location.turkey,
        Piece.civilConstitution: Location.germany,
        Piece.civilFreePress: Location.germany,
        Piece.civilRuleOfLaw: Location.germany,
        Piece.askari_0: Location.eastAfrica,
        Piece.armenians: Location.armenia,
        Piece.pinkFrance: Location.france,
        Piece.airSuperiority: Location.airSuperiority_0,
      }
    );

    if (options.historicalCruisers) {
      state.setPieceLocations({
        Piece.cruiser_1: Location.calendar_4,
        Piece.cruiser_2: Location.calendar_16,
        Piece.cruiser_3: Location.calendar_22,
      });
    } else {
      state.setPieceLocations({
        Piece.cruiser_1: Location.drawCup,
        Piece.cruiser_2: Location.drawCup,
        Piece.cruiser_3: Location.drawCup,
      });
    }
    return state;
  }
}

enum Choice {
  reichsmarks4,
  reichsmarks3krupp1,
  reichsmarks3kaisertreu1,
  reichsmarks2krupp2,
  reichsmarks2kaisertreu2,
  reichsmarks1krupp3,
  reichsmarks1kaisertreu3,
  krupp4,
  reichsmarks3,
  reichsmarks2krupp1,
  reichsmarks2kaisertreu1,
  reichsmarks1krupp2,
  reichsmarks1kaisertreu2,
  krupp3,
  kaisertreu3,
  reichsmarks2,
  reichsmarks1krupp1,
  reichsmarks1kaisertreu1,
  krupp2,
  kaisertreu2,
  reichsmarks1,
  krupp1,
  kaisertreu1,
  minusOne,
  zero,
  plusOne,
  buildUboats,
  buildBlockadeRunners,
  buildSiegfriedLine,
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
  defeat,
  belowTwenty,
  twenty,
  thirty,
  forty,
  fifty,
  sixty,
  sixtyFive,
}

class GameOutcome {
  GameResult  result;
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
  centralPowersAttack,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateTurnStart extends PhaseState {
  Location? randomFront;

  PhaseStateTurnStart();

  PhaseStateTurnStart.fromJson(Map<String, dynamic> json) :
    randomFront = locationFromIndex(json['randomFront'] as int?);

  @override
  Map<String, dynamic> toJson() => {
    'randomFront': locationToIndex(randomFront),
  };

  @override
  Phase get phase {
    return Phase.turnStart;
  }
}

class PhaseStateCentralPowersAttack extends PhaseState {

  int attackCount = 0;
  int cannibalizeCount = 0;

  PhaseStateCentralPowersAttack();

  PhaseStateCentralPowersAttack.fromJson(Map<String, dynamic> json) :
    attackCount = json['attackCount'] as int,
    cannibalizeCount = json['cannibalizeCount'] as int;
  
  @override
  Map<String, dynamic> toJson() => {
    'attackCount': attackCount,
    'cannibalizeCount': cannibalizeCount,
  };

  @override
  Phase get phase {
    return Phase.centralPowersAttack;
  }
}

class EntentePowersAttackFrontState {

  int subStep = 0;
  int cpAttackCount = 0;

  EntentePowersAttackFrontState();

  EntentePowersAttackFrontState.fromJson(Map<String, dynamic> json)
   : subStep = json['suubStep'] as int
   , cpAttackCount = json['cpAttackCount'] as int
   ;
  
  Map<String, dynamic> toJson() => {
    'subStep': subStep,
    'cpAttackCount': cpAttackCount,
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
  EntentePowersAttackFrontState? _ententePowersAttackFrontState;
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
      case Phase.centralPowersAttack:
        _phaseState = PhaseStateCentralPowersAttack.fromJson(phaseStateJson);
      }
    }

    final ententePowersAttackFrontStateJson = json['ententePowersAttackFront'];
    if (ententePowersAttackFrontStateJson != null) {
      _ententePowersAttackFrontState = EntentePowersAttackFrontState.fromJson(ententePowersAttackFrontStateJson);
    }

    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
    if (_phaseState != null) {
      map['phase'] = _phaseState!.phase.index;
      map['phaseState'] = _phaseState!.toJson();
    }
    if (_ententePowersAttackFrontState!= null) {
      map['ententePowersFrontAttack'] = _ententePowersAttackFrontState!.toJson();
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
      turn,
      turnName,
      _log);
  }

  Future<void> saveCurrentState() async {
    await GameDatabase.instance.setGameState(
      _gameId,
      jsonEncode(_state.toJson()),
      jsonEncode(randomToJson(_random)),
      _step, _subStep,
      turn,
      turnName,
      jsonEncode(gameStateToJson()), log);
  }

  Future<void> saveCompletedGame(GameOutcome outcome) async {
    await GameDatabase.instance.completeGame(_gameId, jsonEncode(outcome.toJson()));
  }

  String get log {
    return _log;
  }

  void logLine(String line) {
    _log += '$line\n';
  }

  String logLocation(Location location) {
    return locationName(location);
  }

  String logPiece(Piece piece) {
    return pieceName(piece);
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

  void log2D6InTable((int,int,int,int) rolls) {
    int d0 = rolls.$1;
    int d1 = rolls.$2;
    logLine('>|${dieFace(d0)} ${dieFace(d1)}|${d0 + d1}|');
  }

  (int,int) rollD6x2() {
    int value = _random.nextInt(36);
    int d0 = value % 6 + 1;
    int d1 = value ~/ 6 + 1;
    return (d0, d1);
  }

  void logD6x2((int,int) results) {
    int d0 = results.$1;
    int d1 = results.$2;
    logLine('>');
    logLine('>${dieFace(d0)} ${dieFace(d1)}');
    logLine('>');
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

  String locationName(Location location) {
    const locationNames = [
      'Belgium', 'France', 'Italy', 'Serbia', 'Ukraine', 'Lithuania',
      'Belgium Reserves', 'France Reserves', 'Italy Reserves', 'Serbia Reserves', 'Ukraine Reserves', 'Lithuania Reserves',
      'Armenia', 'Mespotamia', 'Palestine',
      'Yerevan', 'India', 'Egypt',
      'Germany', 'Aaustria-Hungary', 'Ottoman Turkey',
      'German East Africa', 'Gallipoli Peninsula', 'Ireland', 'Roumania', 'Bulgaria', 'Senussi Revolt',
      'Sea 1a', 'Sea 1b', 'Sea 2a', 'Sea 2b', 'Sea 2c', 'Sea 3', 'Sea 4',
      'British Cruisers', 'Blockade Runners', 'Neutral Ports',
      'Aéronautique militaire', 'Fokker Scourge', 'Nieuport & Spad', 'D-Type Fighters', 'Mass Production',
      'Ruhe', 'Unruhe',
      '0', '1', '2', '3', '4', '5', '6',
      '7', '8', '9', '10', '11', '12', 'Explosion',
      '1. Aug 1914', '2. SO 1914', '3. ND 1914', '4. JF 1915', '5. MA 1915', '6. MJ 1915',
      '7. JA 1915', '8. SO 1915', '9. ND 1915', '10. JF 1916', '11. MA 1916', '12. MJ 1916',
      '13. JA 1916', '14. SO 1916', '15. ND 1916', '16. JF 1917', '17. MA 1917', '18. MJ 1917',
      '19. JA 1917', '20. SO 1917', '21. ND 1917', '22. JF 1918', '23. MA 1918', '24. MJ 1918',
      '25. JA 1918', '26. SO 1918', '27. ND 1918',
      'Putnik', 'British Shell Shortage', 'Poison Gas', 'Mackensen',
      'Place of Execution', 'Brusilov', 'Stosstruppen', 'Hoffmann',
      'Alpenkorps', 'Foch', 'Spanish Flu', 'U.S. Assistance',
      'Diaz', 'Black Day of the Army',
      'Draw Cup', 'Lira Cup',
      'Turn Chits',
      'Economic Tiles', 'Central Powers Society Markers',
      'French Forces', 'Italian Forces', 'Serbian Forces', 'Armenian Theater',
      'Roumanian Forces', 'A.A.O. Forces', 'American Forces', 'Central Powers Specialty Units',
      'Russian Forces', 'British Forces',
      'Naval Units', 'Entente Specialty Units', '"Pink" Crises',
      'Assorted Markers', 'Ottoman Units',
      'Discarded',
    ];
    return locationNames[location.index];
  }

  String pieceName(Piece piece) {
    const pieceNames = [
      'AAO 1st Army', 'AAO 2nd Army', 'AAO NDAC Army', 'AAO Orient Army', 'AAO Salonika Army',
      'Arab Northern Army',
      'Armenian 1 Rifles', 'Armenian 2 Rifles', 'Assyrians',
      'Belgian Army',
      'British 1st Army', 'British 2nd Army', 'British 3rd Army', 'British 4th Army', 'British Expeditionary Force',
      'Dunsterforce', 'Lawrence of Arabia', 'Mediterranean Expeditionary Force', 'British XX Corps',
      'South African Overseas Expeditionary Force',
      'French 1st Army', 'French 2nd Army', 'French 3rd Army', 'French 4th Army', 'French 5th Army',
      'Indian Expeditionary Force A', 'Indian Expeditionary Force B', 'Indian Expeditionary Force C', 'Indian Expeditionary Force D',
      'Italian 1st Army', 'Italian 2nd Army', 'Italian 3rd Army', 'Italian 4th Army', 'Italian Carnia Army',
      'Roumanian 1st Army', 'Roumanian 2nd Army', 'Roumanian North Army',
      'Russian 1st Army', 'Russian 2nd Army', 'Russian 3rd Army', 'Russian 4th Army', 'Russian 5th Army',
      'Russian 6th Army', 'Russian 7th Army', 'Russian 8th Army', 'Russian 9th Army', 'Russian 10th Army',
      'Russian Caucasus Army', 'Russian Cossacks', 'Russia Kars Army', 'Russian Turkestan Army',
      'Serbian 1st Army', 'Serbian 2nd Army', 'Serbian 3rd Army', 'Serbian Montenegro Army', 'Serbian Užice Army',
      'USA I Corps', 'USA IV Corps', 'USA V Corps', 'USA VI Corps',
      'French Tank Army', 'Border Forts', 'Border Forts', 'Siegfried Line', 'Trenches', 'Trenches',
      'Over the Top', 'Over the Top', 'Over the Top', 'Over the Top', 'Over the Top', 'Over the Top', 'Over the Top',
      'France in Danger', 'Italy in Danger', 'Socialist Revolution', 'Socialist Revolution', 'Serbia Outflanked',
      'Armenians', 'Askari', 'Askari', 'Siege of Kut',
      'Cruiser', 'Cruiser', 'Cruiser', 'Cruiser',
      'Danish Blockade Runner', 'Dutch Blockade Runner', 'Norwegian Blockade Runner', 'Swedish Blockade Runner',
      'U-Boats', 'U-Boats', 'High Seas Fleet',
      'Berlin', 'Breslau', 'Cologne', 'Dresden', 'Frankfurt',
      'Hamburg', 'Leipzig', 'Munich', 'Prague', 'Vienna', 'Budapest',
      'Air Superiority', 'British Bombers', 'German Bombers', 'Zeppelin', 'Red Baron',
      'Hinden-Luden', 'Constitution', 'Free Press', 'Rule of Law', 'Krupp', 'Kaisertreu',
      'Berlin-Baghdad Railway', 'Kemal',
      'Bulgaria Neutral', 'Italy Neutral', 'Ottoman Turkey Neutral', 'Roumania Neutral',
      'France Surrender', 'Italy Surrender', 'Ottoman Turkey Surrender', 'Roumania Surrender',
      'French Mutiny', 'Roumania Hypothesis Z!',
      'Special Event',
      'RM', 'Lira',
      '0 Lira', '0 Lira', '0 Lira',
      '1 Lira', '1 Lira', '1 Lira',
      '2 Lira', '2 Lira', '2 Lira', '2 Lira', '2 Lira',
      '3 Lira', '3 Lira', '3 Lira',
      '4 Lira', '4 Lira',
      '5 Lira', '5 Lira',
      'Turn Chit 1', 'Turn Chit 2', 'Turn Chit 3', 'Turn Chit 4', 'Turn Chit 5', 'Turn Chit 6',
      'Turn Chit 7', 'Turn Chit 8', 'Turn Chit 9', 'Turn Chit 10', 'Turn Chit 11', 'Turn Chit 12',
      'Turn Chit 13', 'Turn Chit 14', 'Turn Chit 15', 'Turn Chit 16', 'Turn Chit 17', 'Turn Chit 18',
      'Turn Chit 19', 'Turn Chit 20', 'Turn Chit 21', 'Turn Chit 22', 'Turn Chit 23', 'Turn Chit 24',
      'Turn Chit 25', 'Turn Chit 26', 'Turn Chit 27', 'Turn Chit 28',
      'Arab Northern Army (inactive)',
    ];
    return pieceNames[piece.index];
  }

  Location pieceLocation(Piece piece) {
    return _state.pieceLocation((piece));
  }

  void setPieceLocation(Piece piece, Location location) {
    _state.setPieceLocation(piece, location);
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
    Piece? resultPiece;
    for (final piece in pieceType.pieces) {
      if (pieceLocation(piece) == location) {
        resultPiece = piece;
      }
    }
    return resultPiece;
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

  List<Piece> strongestArmiesInLocation(PieceType pieceType, Location location) {
    var armies = <Piece>[];
    for (final army in piecesInLocation(pieceType, location)) {
      if (armies.isEmpty || armyValue(army) > armyValue(armies[0])) {
        armies = [army];
      } else if (armyValue(army) == armyValue(armies[0])) {
        armies.add(army);
      }
    }
    return armies;
  }

  List<Piece> weakestArmiesInLocation(PieceType pieceType, Location location) {
    var armies = <Piece>[];
    for (final army in piecesInLocation(pieceType, location)) {
      if (armies.isEmpty || armyValue(army) < armyValue(armies[0])) {
        armies = [army];
      } else if (armyValue(army) == armyValue(armies[0])) {
        armies.add(army);
      }
    }
    return armies;
  }

  bool get franceMutinous {
    return pieceLocation(Piece.frenchMutiny) == Location.france;
  }

  bool get siegfriedLineExists {
    return pieceLocation(Piece.siegfriedLine) == Location.belgium;
  }

  bool get americaNeutral {
    return pieceLocation(Piece.armyUsa1) == Location.trayAmerican;
  }

  bool get bulgariaNeutral {
    return pieceLocation(Piece.neutralBulgaria) == Location.bulgaria;
  }

  bool get roumaniaNeutral {
    return pieceLocation(Piece.neutralRoumania) == Location.roumania;
  }

  bool get roumaniaSurrendered {
    return pieceLocation(Piece.surrenderRoumania) == Location.roumania;
  }

  bool get turkeyNeutral {
    return pieceLocation(Piece.neutralOttoman) == Location.turkey;
  }

  bool get turkeySurrendered {
    return pieceLocation(Piece.surrenderOttoman) == Location.turkey;
  }

  bool get turkeyActive {
    return !turkeyNeutral && !turkeySurrendered;
  }

  void turkeySurrenders() {
    setPieceLocation(Piece.surrenderOttoman, Location.turkey);
  }

  int seaValue(Location sea) {
    const seaValues = [1, 1, 2, 2, 2, 3, 4];
    int seaIndex = sea.index - LocationType.sea.firstIndex;
    return seaValues[seaIndex];
  }

  int armyValue(Piece army) {
    const armyValues = {
      Piece.armyAao1: [2,4],
      Piece.armyAao2: [2,4],
      Piece.armyAaoNdac: [2,4],
      Piece.armyAaoOrient: [2,4],
      Piece.armyAaoSalonika: [2,4],
      Piece.armyArab: [4,4],
      Piece.armyArmenia1: [3,3],
      Piece.armyArmenia2: [3,3],
      Piece.armyAssyria: [2, 2],
      Piece.armyBelgium: [3,3],
      Piece.armyBritain1: [4,4],
      Piece.armyBritain2: [4,4],
      Piece.armyBritain3: [3,3],
      Piece.armyBritain4: [3,3],
      Piece.armyBritainBef: [5,5],
      Piece.armyBritainDunster: [2,2],
      Piece.armyBritainLawrence: [4,4],
      Piece.armyBritainMef: [3,3],
      Piece.armyBritain20: [4,4],
      Piece.armySouthAfrica: [4,4],
      Piece.armyFrance1: [3,3],
      Piece.armyFrance2: [4,4],
      Piece.armyFrance3: [3,3],
      Piece.armyFrance4: [3,3],
      Piece.armyFrance5: [2,2],
      Piece.armyIndiaA: [3,3],
      Piece.armyIndiaB: [3,3],
      Piece.armyIndiaC: [3,3],
      Piece.armyIndiaD: [3,3],
      Piece.armyItaly1: [2,2],
      Piece.armyItaly2: [2,2],
      Piece.armyItaly3: [3,3],
      Piece.armyItaly4: [2,2],
      Piece.armyItalyCarnia: [2,2],
      Piece.armyRoumania1: [2,2],
      Piece.armyRoumania2: [2,2],
      Piece.armyRoumaniaNorth: [2,2],
      Piece.armyRussia1: [2,2],
      Piece.armyRussia2: [2,2],
      Piece.armyRussia3: [3,3],
      Piece.armyRussia4: [2,2],
      Piece.armyRussia5: [3,3],
      Piece.armyRussia6: [2,2],
      Piece.armyRussia7: [3,3],
      Piece.armyRussia8: [3,3],
      Piece.armyRussia9: [3,3],
      Piece.armyRussia10: [2,2],
      Piece.armyRussiaCaucasus: [2,2],
      Piece.armyRussiaCossack: [2,2],
      Piece.armyRussiaKars: [2,2],
      Piece.armyRussiaTurkestan: [2,2],
      Piece.armySerbia1: [3,4],
      Piece.armySerbia2: [3,4],
      Piece.armySerbia3: [3,4],
      Piece.armySerbiaMontenegro: [3,4],
      Piece.armySerbiaUzice: [3,4],
      Piece.armyUsa1: [4,4],
      Piece.armyUsa4: [4,4],
      Piece.armyUsa5: [4,4],
      Piece.armyUsa6: [4,4],
    };

    int turkeyIndex = turkeySurrendered ? 1 : 0;
    return armyValues[army]![turkeyIndex];
  }

  bool frontNeutral(Location front) {
    if (front != Location.italy) {
      return false;
    }
    return pieceLocation(Piece.neutralItaly) == front;
  }

  bool frontSurrendered(Location front) {
    switch (front) {
    case Location.belgium:
      return false;
    case Location.france:
      return pieceLocation(Piece.surrenderFrance) == front;
    case Location.italy:
      return pieceLocation(Piece.surrenderItaly) == front;
    case Location.serbia:
      return false;
    case Location.ukraine:
    case Location.lithuania:
      return piecesInLocationCount(PieceType.army, front) == 0;
    default:
    }
    return false;
  }

  bool frontActive(Location front) {
    return !frontNeutral(front) && !frontSurrendered(front);
  }

  Location frontReservesLocation(Location front) {
    return Location.values[front.index + LocationType.front.count];
  }

  bool frontAustrian(Location front) {
    const austrianFronts = [Location.italy, Location.serbia, Location.ukraine];
    return austrianFronts.contains(front);
  }

  Location nearEastTheaterReservesLocation(Location nearEast) {
    return Location.values[nearEast.index + LocationType.nearEastTheater.count];
  }

  bool get airSuperiorityCentralPowers {
    final box = pieceLocation(Piece.airSuperiority);
    return box == Location.airSuperiority_1 || box == Location.airSuperiority_3;
  }

  int get airSuperiorityAdvanceRoll {
    return 1 + (turn + 3) % 6;
  }

  int omnibusValue(Location omnibus) {
    return omnibus.index - LocationType.omnibus.firstIndex;
  }

  Location omnibusBox(int value) {
    return Location.values[LocationType.omnibus.firstIndex + value];
  }

  int get reichsmarks {
    return omnibusValue(pieceLocation(Piece.reichsmark));
  }

  void adjustReichsmarks(int amount) {
    int newAmount = (reichsmarks + amount).clamp(0, 12);
    if (amount > 0) {
      logLine('>RM: $reichsmarks + $amount => $newAmount');
    } else {
      logLine('>RM: $reichsmarks - ${-amount} => $newAmount');
    }
    setPieceLocation(Piece.reichsmark, omnibusBox(newAmount));
  }

  void spendReichsmarks(int amount) {
    int newAmount = (reichsmarks - amount).clamp(0, 12);
    logLine('>$amount Reichsmarks spent.');
    logLine('>RM: $reichsmarks - $amount => $newAmount');
    setPieceLocation(Piece.reichsmark, omnibusBox(newAmount));
  }

  int get krupp {
    final location = pieceLocation(Piece.krupp);
    if (location == Location.discarded) {
      return 0;
    }
    return omnibusValue(location);
  }

  void spendKrupp(int amount) {
    int newAmount = krupp - amount;
    logLine('>$amount Krupp expended.');
    logLine('>Krupp: $krupp - $amount => $newAmount');
    setPieceLocation(Piece.krupp, newAmount == 0 ? Location.discarded : omnibusBox(newAmount));
  }

  int get kaisertreu {
    final location = pieceLocation(Piece.kaisertreu);
    if (location == Location.discarded) {
      return 0;
    }
    return omnibusValue(location);
  }

  void spendKaisertreu(int amount) {
    int newAmount = kaisertreu - amount;
    logLine('>$amount Kaisertreu expended.');
    logLine('>Kaisertreu: $kaisertreu - $amount => $newAmount');
    setPieceLocation(Piece.kaisertreu, newAmount == 0 ? Location.discarded : omnibusBox(kaisertreu - amount));
  }

  int get lira {
    return omnibusValue(pieceLocation(Piece.lira));
  }

  void adjustLira(int amount) {
    int newAmount = min(lira + amount, 12);
    if (newAmount != lira) {
      if (amount > 0) {
        logLine('>Lira: $lira +$amount => $newAmount');
      } else {
        logLine('>Lira: $lira - ${-amount} => $newAmount');
      }
      setPieceLocation(Piece.lira, omnibusBox(newAmount));
    }
  }

  void spendLira(int amount) {
    int newAmount = lira - amount;
    logLine('>$amount Lira spent.');
    logLine('>Lira: $lira - $amount => $newAmount');
    setPieceLocation(Piece.lira, omnibusBox(newAmount));
  }

  int liraValue(Piece lira) {
    const values = [
      0, 0, 0,
      1, 1, 1,
      2, 2, 2, 2, 2,
      3, 3, 3,
      4, 4,
      5, 5,
    ];
    return values[lira.index - PieceType.lira.firstIndex];
  }

  int get turn {
    return _state.turn;
  }

  int get year {
    return 1914 + (turn + 3) ~/ 6;
  }

  String get turnName {
    const turnNames = [
      'August 1914',
      'September/October 1914',
      'November/December 1914',
      'January/February 1915',
      'March/April 1915',
      'May/June 1915',
      'July/August 1915',
      'September/October 1915',
      'November/December 1915',
      'January/February 1916',
      'March/April 1916',
      'May/June 1916',
      'July/August 1916',
      'September/October 1916',
      'November/December 1916',
      'January/February 1917',
      'March/April 1917',
      'May/June 1917',
      'July/August 1917',
      'September/October 1917',
      'November/December 1917',
      'January/February 1918',
      'March/April 1918',
      'May/June 1918',
      'July/August 1918',
      'September/October 1918',
      'November/December 1918',
    ];
    return turnNames[turn];
  }

  Location get currentTurnBox {
    return Location.values[Location.calendar_1.index + turn];
  }

  Location futureTurnBox(int turns) {
    if (turn + turns >= 27) {
      return Location.discarded;
    }
    return Location.values[Location.calendar_1.index + turn + turns];
  }

  bool get alpineWinter {
    final alpineWinterTurns = [3,9,14,15,21];
    return alpineWinterTurns.contains(turn);
  }

  bool get summer {
    int months = turn % 6;
    return months == 0 || months == 5;
  }

  Piece? get currentTurnChit {
    return pieceInLocation(PieceType.turn, currentTurnBox);
  }

  int get currentTurnChitIndex {
    Piece? turn = pieceInLocation(PieceType.turn, currentTurnBox);
    if (turn == null) {
      return 0;
    }
    return turn.index - PieceType.turn.firstIndex;
  }

  int calculateVictoryPoints() {
    int armyCount = 0;
    for (final front in LocationType.front.locations) {
      armyCount += piecesInLocationCount(PieceType.army, front);
    }
    armyCount += piecesInLocationCount(PieceType.roumanianArmy, Location.roumania);
    int vps = 30 - armyCount;
    if (!turkeySurrendered) {
      vps += 10;
    }
    if (piecesInLocationCount(PieceType.askari, Location.eastAfrica) > 0) {
      vps += 5;
    }
    vps += piecesInLocationCount(PieceType.city, Location.ruhe);
    vps += 5 * piecesInLocationCount(PieceType.civilSociety, Location.germany);
    return vps;
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

  Choice? selectedPayment() {
    const paymentChoices = [
      Choice.reichsmarks4,
      Choice.reichsmarks3krupp1,
      Choice.reichsmarks3kaisertreu1,
      Choice.reichsmarks2krupp2,
      Choice.reichsmarks2kaisertreu2,
      Choice.reichsmarks1krupp3,
      Choice.reichsmarks1kaisertreu3,
      Choice.krupp4,
      Choice.reichsmarks3,
      Choice.reichsmarks2krupp1,
      Choice.reichsmarks2kaisertreu1,
      Choice.reichsmarks1krupp2,
      Choice.reichsmarks1kaisertreu2,
      Choice.krupp3,
      Choice.kaisertreu3,
      Choice.reichsmarks2,
      Choice.reichsmarks1krupp1,
      Choice.reichsmarks1kaisertreu1,
      Choice.krupp2,
      Choice.kaisertreu2,
      Choice.reichsmarks1,
      Choice.krupp1,
      Choice.kaisertreu1,
    ];
    for (final choice in paymentChoices) {
      if (_choiceInfo.selectedChoices.contains(choice)) {
        return choice;
      }
    }
    return null;
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

  void enableAttackPaymentChoices(int cost, bool austria) {
    switch (cost) {
    case 4:
      if (reichsmarks >= 4) {
        choiceChoosable(Choice.reichsmarks4, true);
      }
      if (austria) {
        if (reichsmarks >= 3 && kaisertreu >= 1) {
          choiceChoosable(Choice.reichsmarks3kaisertreu1, true);
        }
        if (reichsmarks >= 2 && kaisertreu >= 2) {
          choiceChoosable(Choice.reichsmarks2kaisertreu2, true);
        }
        if (reichsmarks >= 1 && kaisertreu >= 3) {
          choiceChoosable(Choice.reichsmarks1kaisertreu3, true);
        }
      } else {
        if (reichsmarks >= 3 && krupp >= 1) {
          choiceChoosable(Choice.reichsmarks3krupp1, true);
        }
        if (reichsmarks >= 2 && krupp >= 2) {
          choiceChoosable(Choice.reichsmarks2krupp2, true);
        }
        if (reichsmarks >= 1 && krupp >= 3) {
          choiceChoosable(Choice.reichsmarks1krupp3, true);
        }
        if (krupp >= 4) {
          choiceChoosable(Choice.krupp4, true);
        }
      }
    case 3:
      if (reichsmarks >= 3) {
        choiceChoosable(Choice.reichsmarks3, true);
      }
      if (austria) {
        if (reichsmarks >= 2 && kaisertreu >= 1) {
          choiceChoosable(Choice.reichsmarks2kaisertreu1, true);
        }
        if (reichsmarks >= 1 && kaisertreu >= 2) {
          choiceChoosable(Choice.reichsmarks1kaisertreu2, true);
        }
        if (kaisertreu >= 3) {
          choiceChoosable(Choice.kaisertreu3, true);
        }
      } else {
        if (reichsmarks >= 2 && krupp >= 1) {
          choiceChoosable(Choice.reichsmarks2krupp1, true);
        }
        if (reichsmarks >= 1 && krupp >= 2) {
          choiceChoosable(Choice.reichsmarks1krupp2, true);
        }
        if (krupp >= 3) {
          choiceChoosable(Choice.krupp3, true);
        }
      }
    case 2:
      if (reichsmarks >= 2) {
        choiceChoosable(Choice.reichsmarks2, true);
      }
      if (austria) {
        if (reichsmarks >= 1 && kaisertreu >= 1) {
          choiceChoosable(Choice.reichsmarks1kaisertreu1, true);
        }
        if (kaisertreu >= 2) {
          choiceChoosable(Choice.kaisertreu2, true);
        }
      } else {
        if (reichsmarks >= 1 && krupp >= 1) {
          choiceChoosable(Choice.reichsmarks1krupp1, true);
        }
        if (krupp >= 2) {
          choiceChoosable(Choice.krupp2, true);
        }
      }
    case 1:
      if (reichsmarks >= 1) {
        choiceChoosable(Choice.reichsmarks1, true);
      }
      if (austria) {
        if (kaisertreu >= 1) {
          choiceChoosable(Choice.kaisertreu1, true);
        }
      } else {
        if (krupp >= 1) {
          choiceChoosable(Choice.krupp1, true);
        }
      }
    }
  }

  void makeAttackPayment(Choice choice) {
    switch (choice) {
    case Choice.reichsmarks4:
      spendReichsmarks(4);
    case Choice.reichsmarks3krupp1:
      spendReichsmarks(3);
      spendKrupp(1);
    case Choice.reichsmarks3kaisertreu1:
      spendReichsmarks(3);
      spendKaisertreu(1);
    case Choice.reichsmarks2krupp2:
      spendReichsmarks(2);
      spendKrupp(2);
    case Choice.reichsmarks2kaisertreu2:
      spendReichsmarks(2);
      spendKaisertreu(2);
    case Choice.reichsmarks1krupp3:
      spendReichsmarks(1);
      spendKrupp(3);
    case Choice.reichsmarks1kaisertreu3:
      spendReichsmarks(1);
      spendKaisertreu(3);
    case Choice.krupp4:
      spendKrupp(4);
    case Choice.reichsmarks3:
      spendReichsmarks(3);
    case Choice.reichsmarks2krupp1:
      spendReichsmarks(2);
      spendKrupp(1);
    case Choice.reichsmarks2kaisertreu1:
      spendReichsmarks(2);
      spendKaisertreu(1);
    case Choice.reichsmarks1krupp2:
      spendReichsmarks(1);
      spendKrupp(2);
    case Choice.reichsmarks1kaisertreu2:
      spendReichsmarks(1);
      spendKaisertreu(2);
    case Choice.krupp3:
      spendKrupp(3);
    case Choice.kaisertreu3:
      spendKaisertreu(3);
    case Choice.reichsmarks2:
      spendReichsmarks(2);
    case Choice.reichsmarks1krupp1:
      spendReichsmarks(1);
      spendKrupp(1);
    case Choice.reichsmarks1kaisertreu1:
      spendReichsmarks(1);
      spendKaisertreu(1);
    case Choice.krupp2:
      spendKrupp(2);
    case Choice.kaisertreu2:
      spendKaisertreu(2);
    case Choice.reichsmarks1:
      spendReichsmarks(1);
    case Choice.krupp1:
      spendKrupp(1);
    case Choice.kaisertreu1:
      spendKaisertreu(1);
    default:
    }
  }

  int eventDrm(Location location, int sequence) {
    switch (pieceLocation(Piece.specialEvent)) {
    case Location.eventPutnik:
      if (location == Location.serbia) {
        logLine('>|Putnik|-1|');
        return -1;
      }
    case Location.eventBritishShellShortage:
      if (location == Location.belgium) {
        logLine('>|British Shell Shortage|+1|');
        return 1;
      }
    case Location.eventPoisonGas:
      if ([Location.belgium, Location.france, Location.italy].contains(location)) {
        int modifier = max(2 - sequence, 0);
        if (modifier != 0) {
          logLine('>|Poison Gas|+$modifier|');
        }
        return modifier;
      }
    case Location.eventMackensen:
      if ([Location.serbia, Location.ukraine].contains(location)) {
        logLine('|Mackensen|+1|');
        return 1;
      }
    case Location.eventPlaceOfExecution:
      if (location == Location.france) {
        logLine('>|Place of Execution|+1|');
        return 1;
      }
    case Location.eventBrusilov:
      if ([Location.ukraine, Location.lithuania].contains(location)) {
        logLine('>|Brusilov|-1|');
        return -1;
      }
    case Location.eventStosstruppen:
      logLine('>|Stosstruppen|+1|');
      return 1;
    case Location.eventHoffmann:
      if ([Location.ukraine, Location.lithuania].contains(location)) {
        logLine('>|Hoffmann|+1|');
        return 1;
      }
    case Location.eventAlpenkorps:
      if (location == Location.italy) {
        logLine('>|Alpenkorps|+1|');
        return 1;
      }
    case Location.eventFoch:
      if (location == Location.france) {
        logLine('>|Foch|-1|');
        return -1;
      }
    case Location.eventDiaz:
      if (location == Location.italy) {
        logLine('>|Diaz|-1|');
        return -1;
      }
    case Location.eventBlackDayOfTheArmy:
    logLine('>|Black Day of the Army|-1|');
      return -1;
    default:
    }
    return 0;
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;
  }

  void turnBegin() {
    logLine('# $turnName');
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

  void turnStartPhaseChitDraw() {
    logLine('### Chit Draw');
    if (_state.turn > 0) {
      while (true) {
        final pieces = piecesInLocation(PieceType.all, Location.drawCup);
        final piece = randPiece(pieces)!;
        if (piece.isType(PieceType.cruiser)) {
          logLine('>Drew a ${logPiece(piece)}.');
          setPieceLocation(piece, Location.britishCruisers);
        } else {
          logLine('>${pieceName(piece)}');
          setPieceLocation(piece, currentTurnBox);
          return;
        }
      }
    }
    logLine('>${pieceName(pieceInLocation(PieceType.turn, currentTurnBox)!)}');
  }

  void turnStartPhaseDeployUnits() {
    const germanyPieces = [Piece.redBaron, Piece.zeppelin, Piece.highSeasFleet];
    for (final piece in germanyPieces) {
      if (pieceLocation(piece) == currentTurnBox) {
        logLine('>${logPiece(piece)} deployed to ${logLocation(Location.germany)}.');
        setPieceLocation(piece, Location.germany);
      }
    }
    for (final cruiser in PieceType.cruiser.pieces) {
      if (pieceLocation(cruiser) == currentTurnBox) {
        logLine('>${logPiece(cruiser)} deployed to ${logLocation(Location.britishCruisers)}.');
        setPieceLocation(cruiser, Location.britishCruisers);
      }
    }
    const armies = [Piece.armyUsa1, Piece.armyUsa4, Piece.armyUsa5, Piece.armyUsa6];
    for (final army in armies) {
      if (pieceLocation(army) == currentTurnBox) {
        bool franceSurrendered = frontSurrendered(Location.france);
        bool italySurrendered = frontSurrendered(Location.italy);
        Piece? replacedPiece;
        Piece? secondReplacedPiece;
        switch (army) {
        case Piece.armyUsa1:
          if (!franceSurrendered) {
            replacedPiece = Piece.armyFrance4;
            if (!italySurrendered) {
              secondReplacedPiece = Piece.armyItaly4;
            }
          } else if (!italySurrendered) {
            replacedPiece = Piece.armyItaly4;
          }
        case Piece.armyUsa4:
          if (!franceSurrendered) {
            replacedPiece = Piece.armyFrance5;
          }
        case Piece.armyUsa5:
          replacedPiece = Piece.armyBritain3;
          if (!italySurrendered) {
            secondReplacedPiece = Piece.armyItalyCarnia;
          }
        case Piece.armyUsa6:
          replacedPiece = Piece.armyBritain4;
        default:
        }
        if (replacedPiece != null) {
          Location location = pieceLocation(replacedPiece);
          logLine('>${logPiece(army)} deployed to ${logLocation(location)}.');
          setPieceLocation(army, location);
          if (secondReplacedPiece != null) {
            Location secondLocation = pieceLocation(secondReplacedPiece);
            logLine('>${logPiece(replacedPiece)} transferred to ${logLocation(secondLocation)}.');
            setPieceLocation(replacedPiece, secondLocation);
            logLine('>${logPiece(secondReplacedPiece)} disbanded.');
            setPieceLocation(secondReplacedPiece, Location.discarded);
          } else {
            logLine('>${logPiece(replacedPiece)} disbanded.');
            setPieceLocation(replacedPiece, Location.discarded);
          }
        } else {
          logLine('>${logPiece(army)} not deployed.');
          setPieceLocation(army, Location.discarded);
        }
        if (pieceLocation(Piece.frenchMutiny) != Location.discarded && (pieceLocation(army) == Location.france || pieceLocation(army) == Location.belgium)) {
          logLine('>${logPiece(Piece.frenchMutiny)} ends.');
          setPieceLocation(Piece.frenchMutiny, Location.discarded);
        }
      }
    }
  }

  void buildZeppelins() {
    logLine('### Zeppelin');
    logLine('>${logPiece(Piece.zeppelin)} built and available for use.');
    setPieceLocation(Piece.zeppelin, Location.germany);
  }

  void gallipoli() {
    if (turkeyNeutral) {
      return;
    }
    const mef = Piece.armyBritainMef;
    Location location = pieceLocation(mef);
    if (location == Location.discarded) {
      return;
    }
    logLine('### Gallipoli');
    if (location == Location.gallipoli) {
      logLine('>${logLocation(Location.gallipoli)} evacuated.');
      logLine('>${logPiece(Piece.armyBritainMef)} disbanded.');
      setPieceLocation(mef, Location.discarded);
      return;
    }
    if (location != Location.gallipoli) {
      location = Location.omnibus_4;
      logLine('>${logPiece(mef)} placed in the ${logLocation(location)} box.');
      setPieceLocation(mef, Location.omnibus_4);
      for (int i = 0; i < 3; ++i) {
        location = Location.values[location.index - 1];
        logLine('>${logPiece(mef)} moved to the ${logLocation(location)} box.');
        setPieceLocation(mef, location);
        logLine('> Ottoman Turkey Attacks ${logPiece(mef)}.');
        int die = rollD6();
        logD6(die);
        if (die > 3) {
          logLine('>Advance of ${logPiece(mef)} halted in the ${logLocation(Location.gallipoli)}.');
          setPieceLocation(mef, Location.gallipoli);
          return;
        }
      }
      logLine('>Advance of ${logPiece(mef)} reaches Constantinople.');
      logLine('>Ottoman Turkey Surrenders!*.');
      setPieceLocation(mef, Location.omnibus_0);
      turkeySurrenders();
    }
  }

  void discardUboats() {
    final uboats = piecesInLocation(PieceType.uboats, Location.trayNaval);
    if (uboats.isNotEmpty) {
      Piece uboat = uboats[uboats.length - 1];
      logLine('>${logPiece(uboat)} discarded.');
      setPieceLocation(uboats[uboats.length - 1], Location.discarded);
      return;
    }
    for (final front in [Location.france, Location.belgium]) {
      var uboat = pieceInLocation(PieceType.uboats, front);
      if (uboat != null) {
        logLine('>${logPiece(uboat)} in ${logLocation(front)} discarded.');
        setPieceLocation(uboat, Location.discarded);
        return;
      }
    }
  }

  void convoySuccess() {
    logLine('>*Convoy Success*');
    discardUboats();
  }

  void turnStartPhaseCalendarEvents() {
    final turnEvents = [
      null, null, null, buildZeppelins, gallipoli, null,
      null, null, null, gallipoli, null, null,
      null, null, gallipoli, null, null, null,
      null, gallipoli, null, null, convoySuccess, null,
      gallipoli, null, null,
    ];

    final eventHandler = turnEvents[turn];
    if (eventHandler == null) {
      return;
    }
    eventHandler();
  }

  void revolutionExplodes() {
    logLine('>*Revolution explodes all over Europe.*');
    setPieceLocation(Piece.pinkRussia_0, Location.ukraine);
    setPieceLocation(Piece.pinkRussia_1, Location.lithuania);
    for (final front in [Location.ukraine, Location.lithuania]) {
      if (piecesInLocationCount(PieceType.russianArmy, front) > 1) {
        final armies = weakestArmiesInLocation(PieceType.russianArmy, front);
        final army = randPiece(armies)!;
        final reserves = frontReservesLocation(front);
        logLine('>${logPiece(army)} removed to ${logLocation(reserves)}.');
        setPieceLocation(army, reserves);
      }
    }
    setPieceLocation(Piece.pinkItaly, Location.italy);
    if (piecesInLocationCount(PieceType.army, Location.france) > 1) {
      final armies = weakestArmiesInLocation(PieceType.army, Location.france);
      final army = randPiece(armies)!;
      logLine('>${logPiece(army)} removed to ${logLocation(Location.franceReserves)}.');
      setPieceLocation(army, Location.franceReserves);
    }
    if (piecesInLocationCount(PieceType.americanArmy, Location.belgium) > 0 || piecesInLocationCount(PieceType.americanArmy, Location.france) > 0) {
      setPieceLocation(Piece.frenchMutiny, Location.discarded);
    }
    if (pieceLocation(Piece.frenchMutiny) != Location.discarded) {
      logLine('>French Mutiny triggered.');
      setPieceLocation(Piece.frenchMutiny, Location.france);
    }
    setPieceLocation(Piece.pinkFrance, Location.france);
    if (pieceLocation(Piece.highSeasFleet) != Location.discarded) {
      logLine('>German Navy crippled.');
      setPieceLocation(Piece.highSeasFleet, Location.discarded);
    }
  }

  bool advanceSocialistRevolution(int amount) {
    final location = pieceLocation(Piece.pinkRussia_0);
    if (location.isType(LocationType.omnibus)) {
      int newAmount = location.index - LocationType.omnibus.firstIndex + amount;
      if (newAmount >= 13) {
        return true;
      }
      final newLocation = Location.values[LocationType.omnibus.firstIndex + newAmount];
      logLine('>${logPiece(Piece.pinkRussia_0)} advances to ${logLocation(newLocation)}.');
      setPieceLocation(Piece.pinkRussia_0, newLocation);
    }
    return false;
  }

  void socialistRevolution() {
    if (pieceLocation(Piece.pinkRussia_0) == Location.ukraine) {
      return;
    }
    if (choicesEmpty()) {
      if (reichsmarks == 0) {
        logLine('>Germany fails to support Socialist agitation.');
        return;
      }
      setPrompt('Support Socialist Revolution');
      choiceChoosable(Choice.yes, true);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.no)) {
      logLine('>Germany fails to support Socialist agitation.');
      clearChoices();
      return;
    }
    if (checkChoice(Choice.yes)) {
      clearChoices();
      logLine('### Germany supports Socialist agitation.');
      spendReichsmarks(1);
      int die = rollD6();
      logD6(die);
      if (advanceSocialistRevolution(die)) {
        revolutionExplodes();
      }
    }
  }

  void serbTyphus() {
    logLine('### Serb Typhus');
    final armies = piecesInLocation(PieceType.army, Location.serbia);
    armies.shuffle();
    int count = armies[0].isType(PieceType.serbianArmy) ? 2 : 1;
    if (count == 2 && armies.length >= 3) {
      final army = armies[2];
      logLine('>${logPiece(army)} returns to ${logLocation(Location.serbiaReserves)}.');
      setPieceLocation(army, Location.serbiaReserves);
    }
    if (armies.length >= 2) {
      final army = armies[1];
      logLine('>${logPiece(army)} returns to ${logLocation(Location.serbiaReserves)}.');
      setPieceLocation(army, Location.serbiaReserves);
    }
  }

  void senussiRevolt() {
    if (choicesEmpty()) {
      if (reichsmarks == 0) {
        logLine('>Germany fails to support the Senussi Revolt.');
        return;
      }
      setPrompt('Support the Senussi Revolt');
      choiceChoosable(Choice.yes, true);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.no)) {
      logLine('>Germany fails to support the Senussi Revolt.');
      clearChoices();
      return;
    }
    if (checkChoice(Choice.yes)) {
      clearChoices();
      logLine('### Senussi Revolt');
      spendReichsmarks(1);
      if (!frontSurrendered(Location.italy)) {
        var italianArmies = weakestArmiesInLocation(PieceType.italianArmy, Location.italyReserves);
        if (italianArmies.isEmpty) {
          italianArmies = weakestArmiesInLocation(PieceType.italianArmy, Location.italy);
        }
        final army = randPiece(italianArmies)!;
        logLine('>${logPiece(army)} transferred to suppress the ${logLocation(Location.senussiRevolt)}.');
        setPieceLocation(army, Location.senussiRevolt);
      }
      var britishArmies = piecesInLocation(PieceType.britishArmy, Location.egypt);
      if (britishArmies.isEmpty) {
        britishArmies = piecesInLocation(PieceType.army, Location.palestine);
      }
      final army = randPiece(britishArmies)!;
      logLine('>${logPiece(army)} transferred to suppress the ${logLocation(Location.senussiRevolt)}.');
      setPieceLocation(army, Location.senussiRevolt);
    }
  }

  void irishRising() {
    if (choicesEmpty()) {
      if (reichsmarks == 0) {
        logLine('>Germany fails to support the Irish Rising.');
        return;
      }
      setPrompt('Support Irish Rising');
      choiceChoosable(Choice.yes, true);
      choiceChoosable(Choice.no, true);
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.no)) {
      logLine('>Germany fails to support the Irish Rising.');
      clearChoices();
      return;
    }
    if (checkChoice(Choice.yes)) {
      clearChoices();
      logLine('### Irish Rising');
      spendReichsmarks(1);
      final armies = [Piece.armyBritain1, Piece.armyBritain2];
      armies.shuffle(_random);
      Piece? irelandArmy;
      for (final location in [Location.belgiumReserves, Location.belgium]) {
        if (irelandArmy == null) {
          for (final army in armies) {
            if (_state.pieceLocation(army) == location) {
              irelandArmy = army;
              break;
            }
          }
        }
      }
      logLine('>${logPiece(irelandArmy!)} transferred to ${logLocation(Location.ireland)}.');
      setPieceLocation(irelandArmy, Location.ireland);
    }
  }

  void franzJosephDeath() {
    if (pieceLocation(Piece.kaisertreu) != Location.discarded) {
      logLine('>*Austro-Hungarian Emperor Franz Joseph I dies of old age.*');
      setPieceLocation(Piece.kaisertreu, Location.discarded);
    }
  }

  void ententePowersAttackFront(Location front) {
    _ententePowersAttackFrontState ??= EntentePowersAttackFrontState();
    final localState = _ententePowersAttackFrontState!;
    if (localState.subStep == 0) {
      if (frontNeutral(front)) {
        _ententePowersAttackFrontState = null;
        return;
      }
      if (frontSurrendered(front)) {
        _ententePowersAttackFrontState = null;
        return;
      }
      Location reserves = frontReservesLocation(front);
      int frontArmyCount = piecesInLocationCount(PieceType.army, front);
      final reserveArmies = piecesInLocation(PieceType.army, reserves);
      if (frontArmyCount < 5 && reserveArmies.isEmpty) {
        _ententePowersAttackFrontState = null;
        return;
      }
      logLine('### Entente Powers Attack in ${logLocation(front)}.');
      bool deploymentPossible = true;
      if (frontArmyCount < 5) {
        final uboats = piecesInLocation(PieceType.uboats, front);
        if (uboats.isNotEmpty) {
          deploymentPossible = false;
          logLine('>${logPiece(uboats[0])} prevent deployment.');
          setPieceLocation(uboats[0], Location.trayNaval);
        }
        if (deploymentPossible) {
          final armies = strongestArmiesInLocation(PieceType.army, reserves);
          final army = randPiece(armies)!;
          logLine('>${logPiece(army)} deployed to ${logLocation(front)}.');
          setPieceLocation(army, front);
        }
      } else {
        bool overTheTopPossible = true;
        if (front == Location.france && franceMutinous) {
          logLine('>The ${logPiece(Piece.frenchMutiny)} is in effect.');
          int die = rollD6();
          logD6(die);
          if (die >= 3) {
            overTheTopPossible = false;
            logLine('>The ${logPiece(Piece.frenchMutiny)} causes the Entente advance to fail.');
          } else {
            logLine('>Entente advance continues despite the ${logPiece(Piece.frenchMutiny)}.');
          }
        } else if (front == Location.belgium && siegfriedLineExists) {
          logLine('>The ${logPiece(Piece.siegfriedLine)} is in place.');
          int die = rollD6();
          logD6(die);
          if (die >= 3) {
            overTheTopPossible = false;
            logLine('>The ${logPiece(Piece.siegfriedLine)} halts Entente advance.');
          } else {
            logLine('>Entente advance pierces the ${logPiece(Piece.siegfriedLine)}.');
            setPieceLocation(Piece.siegfriedLine, Location.discarded);
          }
        } else if (front == Location.italy && alpineWinter) {
          overTheTopPossible = false;
          logLine('>Alpine Winter prevents a breakthrough.');
        }
        if (overTheTopPossible) {
          final uboats = piecesInLocation(PieceType.uboats, front);
          if (uboats.isNotEmpty) {
            overTheTopPossible = false;
            logLine('>${logPiece(uboats[0])} prevent Entente troops going Over the Top.');
            setPieceLocation(uboats[0], Location.trayNaval);
          }
        }
        if (overTheTopPossible) {
          logLine('>*Central Powers lines in ${logLocation(front)} have collapsed.*');
          final overTheTop = pieceInLocation(PieceType.overTheTop, reserves)!;
          setPieceLocation(overTheTop, front);
          final dice = roll2D6();
          log2D6(dice);
          if (dice.$3 <= piecesInLocationCount(PieceType.city, Location.unruhe)) {
            logLine('>*Germany is defeated.*');
            _ententePowersAttackFrontState = null;
            throw GameOverException(GameResult.defeat, 0);
          }
          logLine('>Germany stands firm.');
          setPieceLocation(overTheTop, reserves);
          final trenches = piecesInLocation(PieceType.trenches, front);
          if (trenches.isNotEmpty) {
            setPieceLocation(trenches[0], Location.trayEntenteSpecialty);
          }
          if (piecesInLocationCount(PieceType.city, Location.ruhe) > 0) {
            localState.cpAttackCount = 0;
            localState.subStep = 1;
          }
        }
      }
    }
    if (localState.subStep >= 1) {
      while (true) {
        if (choicesEmpty()) {
          setPrompt('Select Army to Attack');
          if (piecesInLocationCount(PieceType.city, Location.ruhe) > 0) {
            for (final front in LocationType.front.locations) {
              if (frontActive(front) && (front != Location.italy || !alpineWinter)) {
                if (pieceLocation(Piece.tank) == front) {
                  pieceChoosable(Piece.tank);
                } else if (piecesInLocationCount(PieceType.trenches, front) > 0) {
                  final trenches = pieceInLocation(PieceType.trenches, front)!;
                  pieceChoosable(trenches);
                } else {
                  final armies = piecesInLocation(PieceType.army, front);
                  if (armies.length > 1) {
                    if (pieceLocation(Piece.armyBritainBef) == front) {
                      pieceChoosable(Piece.armyBritainBef);
                    } else {
                      for (final army in armies) {
                        pieceChoosable(army);
                      }
                    }
                  }
                }
              }
            }
            final roumanianArmies = piecesInLocation(PieceType.army, Location.roumania);
            for (final army in roumanianArmies) {
              pieceChoosable(army);
            }
          }
          choiceChoosable(Choice.next, localState.cpAttackCount > 0);
          throw PlayerChoiceException();
        }
        if (checkChoice(Choice.next)) {
          clearChoices();
          _ententePowersAttackFrontState = null;
          return;
        }

        final piece = selectedPiece()!;
        Location location = pieceLocation(piece);
        logLine('### Central Powers Attack ${logPiece(piece)} in ${logLocation(location)}.');

        final cities = piecesInLocation(PieceType.city, Location.ruhe);
        final city = randPiece(cities)!;
        logLine('>${logPiece(city)} moves to ${logLocation(Location.unruhe)}.');
        setPieceLocation(city, Location.unruhe);

        if (piece == Piece.tank) {
          logLine('>${logPiece(piece)} eliminated.');
          setPieceLocation(piece, Location.trayFrench);
        } else {
          logLine('>|Effect|Value|');
          logLine('>|:---|:---:|');
          int die = rollD6();
          logD6InTable(die);
          int value = 0;
          if (piece.isType(PieceType.army)) {
            value = armyValue(piece);
          } else if (piece.isType(PieceType.trenches)) {
            value = 4;
          }
          int eventModifier = eventDrm(location, 0);
          int modifiers = eventModifier;
          if ([Location.italy, Location.serbia, Location.ukraine, Location.roumania].contains(location) && piecesInLocationCount(PieceType.roumanianArmy, Location.roumania) > 0) {
            logLine('>|Hypothesis Z|-1|');
            modifiers -= 1;
          }
          final total = die + modifiers;
          logLine('>|Total|$total|');
          logLine('>|${logPiece(piece)}|$value|');
          if (die == 6 || (die != 1 && total > value)) {
            logLine('>Attack succeeded.');
            if (piece.isType(PieceType.roumanianArmy)) {
              logLine('>${logPiece(piece)} eliminated.');
              setPieceLocation(piece, Location.discarded);
              if (piecesInLocationCount(PieceType.roumanianArmy, Location.roumania) == 0) {
                logLine('>*Roumania surrenders.*');
                setPieceLocation(Piece.roumaniaHypothesis, Location.discarded);
                setPieceLocation(Piece.surrenderRoumania, Location.roumania);
              }
            } else if (piece == Piece.armyBritainBef) {
              final reserves = frontReservesLocation(location);
              logLine('>${logPiece(Piece.armyBritainBef)} reformed as ${logPiece(Piece.armyBritain2)}  in ${logLocation(reserves)}.');
              setPieceLocation(piece, Location.discarded);
              setPieceLocation(Piece.armyBritain2, reserves);
            } else if (piece.isType(PieceType.trenches)) {
              logLine('>${logPiece(piece)} breached.');
              setPieceLocation(piece, Location.trayEntenteSpecialty);
            } else {
              final reserves = frontReservesLocation(location);
              logLine('>${logPiece(piece)} withdrawn to ${logLocation(reserves)}.');
              setPieceLocation(piece, frontReservesLocation(location));
            }
          } else {
            logLine('>Attack failed.');
          }
          localState.cpAttackCount += 1;
          clearChoices();
        }
      }
    }
    _ententePowersAttackFrontState = null;
  }

  void randomEntenteOffensive() {
    final phaseState = _phaseState as PhaseStateTurnStart;
    if (phaseState.randomFront == null) {
      logLine('### Entente Offensive on random Front.');
      int die = rollD6();
      logD6(die);
      phaseState.randomFront = Location.values[LocationType.front.firstIndex + die - 1];
    }
    ententePowersAttackFront(phaseState.randomFront!);
    phaseState.randomFront = null;
  }

  void chitEvent(Piece turnChit) {
    final chitEvents = [
      null, socialistRevolution, null, socialistRevolution, serbTyphus, null,
      null, senussiRevolt, irishRising, socialistRevolution, null, null,
      null, null, null, null, franzJosephDeath, null,
      socialistRevolution, null, socialistRevolution, null, randomEntenteOffensive, null,
      randomEntenteOffensive, null, randomEntenteOffensive, randomEntenteOffensive,
    ];

    final eventHandler = chitEvents[turnChit.index - PieceType.turn.firstIndex];
    if (eventHandler == null) {
      return;
    }
    eventHandler();
  }

  void turnStartPhaseChitEvent() {
    chitEvent(currentTurnChit!);
  }

  void turnStartPhaseChitEventTripleOffensive() {
    if (currentTurnChit == Piece.turn28) {
      randomEntenteOffensive();
    }
  }

  void turnStartPhaseHundredDaysChitDraw() {
    if (_state.turn != 26 || !_options.theHundredDays) {
      return;
    }
    logLine('### The Hundred Days Chit Draw');
    while (true) {
      final pieces = piecesInLocation(PieceType.all, Location.drawCup);
      final piece = randPiece(pieces)!;
      if (piece.isType(PieceType.cruiser)) {
        logLine('>Drew a ${logPiece(piece)}.');
        setPieceLocation(piece, Location.britishCruisers);
      } else {
        logLine('>${pieceName(piece)}');
        setPieceLocation(piece, Location.calendarHundredDays);
        return;
      }
    }
  }

  void turnStartPhaseHundredDaysChitEvent() {
    if (_state.turn != 26 || !_options.theHundredDays) {
      return;
    }
    chitEvent(pieceInLocation(PieceType.turn, Location.calendarHundredDays)!);
  }

  void turnStartPhaseHundredDaysChitEventTripleOffensive() {
    if (_state.turn != 26 || !_options.theHundredDays) {
      return;
    }
    if (_state.pieceLocation(Piece.turn28) == Location.calendarHundredDays) {
      randomEntenteOffensive();
    }
  }

  void turnStartPhaseEnd() {
    _phaseState = null;
  }

  void ententePowersAttackPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Entente Powers Attack Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Entente Powers Attack Phase');
  }

  void ententePowersMightAttackFrontChit(Location front, Piece turnChit) {
    final chitFronts = [
      [false, true, false, true, true, true],
      [true, true, false, false, true, true],
      [false, true, true, true, true, false],
      [true, true, true, true, false, false],
      [true, false, false, false, true, true],
      [false, true, false, true, false, true],
      [false, true, true, true, true, false],
      [true, true, true, true, false, false],
      [false, true, false, false, true, true],
      [true, false, false, false, false, true],
      [false, true, true, true, false, true],
      [true, false, true, false, true, true],
      [true, false, true, false, true, true],
      [true, true, true, false, true, true],
      [true, true, true, false, true, false],
      [false, true, true, false, true, false],
      [true, true, false, false, false, true],
      [true, true, true, false, true, true],
      [true, true, true, true, false, false],
      [true, false, true, true, false, true],
      [true, true, false, false, true, true],
      [true, false, true, false, true, false],
      [false, false, false, true, true, true],
      [true, false, true, true, true, false],
      [true, false, false, true, false, false],
      [true, true, true, true, true, true],
      [false, true, true, true, false, false],
      [false, false, false, false, false, false],
    ];

    final frontIndex = front.index - LocationType.front.firstIndex;
    if (chitFronts[turnChit.index - PieceType.turn.firstIndex][frontIndex]) {
      ententePowersAttackFront(front);
    }
  }

  void ententePowersMightAttackFront(Location front) {
    ententePowersMightAttackFrontChit(front, currentTurnChit!);
  }

  void ententePowersMightAttackFrontHundredDays(Location front) {
    if (_state.turn != 26 || !_options.theHundredDays) {
      return;
    }
    ententePowersMightAttackFrontChit(front, pieceInLocation(PieceType.turn, Location.calendarHundredDays)!);
  }

  void ententePowersAttackPhaseBelgium() {
    ententePowersMightAttackFront(Location.belgium);
  }

  void ententePowersAttackPhaseFrance() {
    ententePowersMightAttackFront(Location.france);
  }

  void ententePowersAttackPhaseLithuania() {
    ententePowersMightAttackFront(Location.lithuania);
  }

  void ententePowersAttackPhaseUkraine() {
    ententePowersMightAttackFront(Location.ukraine);
  }

  void ententePowersAttackPhaseItaly() {
    ententePowersMightAttackFront(Location.italy);
  }

  void ententePowersAttackPhaseSerbia() {
    ententePowersMightAttackFront(Location.serbia);
  }

  void ententePowersAttackPhaseHundredDaysBelgium() {
    ententePowersMightAttackFrontHundredDays(Location.belgium);
  }

  void ententePowersAttackPhaseHundredDaysFrance() {
    ententePowersMightAttackFrontHundredDays(Location.france);
  }

  void ententePowersAttackPhaseHundredDaysLithuania() {
    ententePowersMightAttackFrontHundredDays(Location.lithuania);
  }

  void ententePowersAttackPhaseHundredDaysUkraine() {
    ententePowersMightAttackFrontHundredDays(Location.ukraine);
  }

  void ententePowersAttackPhaseHundredDaysItaly() {
    ententePowersMightAttackFrontHundredDays(Location.italy);
  }

  void ententePowersAttackPhaseHundredDaysSerbia() {
    ententePowersMightAttackFrontHundredDays(Location.serbia);
  }

  void ententePowersAttackPhaseIrish() {
    final army = pieceInLocation(PieceType.army, Location.ireland);
    if (army != null) {
      logLine('### Irish Rising.');
      int die = rollD6();
      logD6(die);
      if (die == 6) {
        logLine('>*Irish Rising suppressed.*');
        logLine('>${logPiece(army)} transferred to ${logLocation(Location.belgiumReserves)}.');
        setPieceLocation(army, Location.belgiumReserves);
      } else {
        logLine('>Irish Rising continues.');
      }
    }
  }

  void ententePowersAttackPhaseSenussi() {
    final armies = piecesInLocation(PieceType.army, Location.senussiRevolt);
    if (armies.isNotEmpty) {
      logLine('### Senussi War in Libya.');
      int die = rollD6();
      logD6(die);
      if (die == 6) {
        logLine('>*Senussi Revolt suppressed.*');
        for (final army in armies) {
          if (army.isType(PieceType.italianArmy)) {
            logLine('>${logPiece(army)} transferred to ${logLocation(Location.italyReserves)}.');
            setPieceLocation(army, Location.italyReserves);
          } else {
            logLine('>${logPiece(army)} transferred to ${logLocation(Location.egypt)}.');
            setPieceLocation(army, Location.egypt);
          }
        }
      } else {
        logLine('>Senussi Revolt continues.');
      }
    }
  }

  void ententePowersAttackPhaseDigTrenches() {
    if (turn >= 2) {
      logLine('### Dig Trenches');
      if (pieceLocation(Piece.trenches_0) != Location.belgium) {
        logLine('>Trenches dug in ${logLocation(Location.belgium)}.');
        setPieceLocation(Piece.trenches_0, Location.belgium);
      }
      if (frontActive(Location.france) && pieceLocation(Piece.trenches_1) != Location.france) {
        logLine('>Trenches dug in ${logLocation(Location.france)}.');
        setPieceLocation(Piece.trenches_1, Location.france);
      }
    }
  }

  void ententePowersAttackPhaseEnd() {
    _phaseState = null;
  }

  void berlinerTageblattPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Berliner Tageblatt Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Berliner Tageblatt Phase');
  }

  void putnik() {
    logLine('>*Radomir Putnik commands the Serbian Army.*');
    setPieceLocation(Piece.specialEvent, Location.eventPutnik);
  }

  void britishShellShortage() {
    logLine('>*British Shell Shortage affects the Belgian Front.*');
    setPieceLocation(Piece.specialEvent, Location.eventBritishShellShortage);
  }

  void poisonGas() {
    logLine('>*Poison Gas deployed in the west.*');
    setPieceLocation(Piece.specialEvent, Location.eventPoisonGas);
  }

  void mackensen() {
    logLine('>*August von Mackensen takes command of the Austo-Hungarian Eastern Fronts.*');
    setPieceLocation(Piece.specialEvent, Location.eventMackensen);
  }

  void placeOfExecution() {
    logLine('>*Germany launches Operation Gericht (Place of Execution) against France.*');
    setPieceLocation(Piece.specialEvent, Location.eventPlaceOfExecution);
    if (!_state.placeOfExecutionHappened) {
      _state.placeOfExecutionHappened = true;
      if (!frontSurrendered(Location.france)) {
        if (pieceLocation(Piece.pinkFrance) != Location.france && piecesInLocationCount(PieceType.americanArmy, Location.belgium) == 0 && piecesInLocationCount(PieceType.americanArmy, Location.france) == 0) {
          logLine('>France in Danger.');
          setPieceLocation(Piece.pinkFrance, Location.france);
        }
        if (pieceLocation(Piece.forts_1) != Location.france) {
          logLine('>${logPiece(Piece.forts_1)} built in ${logLocation(Location.france)}.');
          setPieceLocation(Piece.forts_1, Location.france);
        }
      }
    }
  }

  void brusilov() {
    logLine('>*Russia launches the Brusilov offensive.*');
    setPieceLocation(Piece.specialEvent, Location.eventBrusilov);
  }

  void stosstruppen() {
    logLine('>*Stosstruppen introduced.*');
    setPieceLocation(Piece.specialEvent, Location.eventStosstruppen);
  }

  void hoffmann() {
    logLine('>*Max Hoffman commands the Eastern Front.*');
    setPieceLocation(Piece.specialEvent, Location.eventHoffmann);
  }

  void alpenkorps() {
    logLine('>*Alpenkorps formed on the Italian Front.*');
    setPieceLocation(Piece.specialEvent, Location.eventAlpenkorps);
  }

  void foch() {
    logLine('>*Ferdinand Foch Supreme Commander of the Allied Armies in France.*');
    setPieceLocation(Piece.specialEvent, Location.eventFoch);
  }

  void spanishFlu() {
    logLine('>*Spanish Flu weakens the Entente Armies.*');
    setPieceLocation(Piece.specialEvent, Location.eventSpanishFlu);
    int maxArmyCount = 0;
    for (final front in LocationType.front.locations) {
      if (!frontSurrendered(front)) {
        int frontArmyCount = piecesInLocationCount(PieceType.army, front);
        if (frontArmyCount > maxArmyCount) {
          maxArmyCount = frontArmyCount;
        }
      }
    }
    if (maxArmyCount > 1) {
      for (final front in LocationType.front.locations) {
        Location reserves = frontReservesLocation(front);
        final armyCount = piecesInLocationCount(PieceType.army, front);
        if (armyCount == maxArmyCount) {
          final armies = weakestArmiesInLocation(PieceType.army, front);
          final army = randPiece(armies)!;
          logLine('>${logPiece(army)} withdrawn to ${logLocation(reserves)}.');
          setPieceLocation(army, reserves);
        }
      }
    }
  }

  void usAssistance() {
    logLine('>*US Assistance.*');
    setPieceLocation(Piece.specialEvent, Location.eventUSAssistance);
    int minArmyCount = 6;
    for (final front in LocationType.front.locations) {
      if (!frontSurrendered(front)) {
        int frontArmyCount = piecesInLocationCount(PieceType.army, front);
        if (frontArmyCount < minArmyCount) {
          minArmyCount = frontArmyCount;
        }
      }
    }
    for (final front in LocationType.front.locations) {
      Location reserves = frontReservesLocation(front);
      int armyCount = piecesInLocationCount(PieceType.army, front);
      if (armyCount == minArmyCount) {
        final armies = strongestArmiesInLocation(PieceType.army, reserves);
        if (armies.isNotEmpty) {
          final army = randPiece(armies)!;
          logLine('>${logPiece(army)} deployed to ${logLocation(front)}.');
          setPieceLocation(army, front);
        }
      }
    }
  }

  void diaz() {
    if (!frontSurrendered(Location.italy)) {
      logLine('>*Armando Diaz commands the Italian Army.*');
      setPieceLocation(Piece.specialEvent, Location.eventDiaz);
      if (pieceLocation(Piece.pinkItaly) == Location.italy) {
        logLine('>Italy is no longer In Danger.');
      }
      setPieceLocation(Piece.pinkItaly, Location.discarded);
    }
  }

  void blackDayOfTheArmy() {
    logLine('>*Black Day of the German Army.*');
    setPieceLocation(Piece.specialEvent, Location.eventBlackDayOfTheArmy);
  }

  void turkishEntry() {
    if (pieceLocation(Piece.neutralOttoman) != Location.turkey) {
      return;
    }
    logLine('### Ottoman Turkey enters the war.');
    setPieceLocation(Piece.neutralOttoman, Location.discarded);
  }

  void italianEntry() {
    if (pieceLocation(Piece.neutralItaly) != Location.italy) {
      return;
    }
    logLine('### Italy enters the war.');
    setPieceLocation(Piece.neutralItaly, Location.discarded);
  }

  void bulgarianEntry() {
    if (pieceLocation(Piece.neutralBulgaria) != Location.bulgaria) {
      return;
    }
    logLine('### Bulgaria enters the war.');
    logLine('>Serbia Outflanked.');
    setPieceLocation(Piece.neutralBulgaria, Location.discarded);
    setPieceLocation(Piece.pinkSerbia, Location.serbia);
  }

  void hindenLuden() {
    if (pieceLocation(Piece.hindenLuden) != Location.trayCentralPowersSpecialty) {
      return;
    }
    logLine('>*Hindenburg-Ludendorff dictatorship set up in Germany.*');
    setPieceLocation(Piece.hindenLuden, Location.germany);
 }

 void roumanianEntry() {
    if (pieceLocation(Piece.roumaniaHypothesis) != Location.trayRoumanian) {
      return;
    }
    logLine('### Roumania enters the war.');
    setPieceLocation(Piece.neutralRoumania, Location.discarded);
    setPieceLocation(Piece.roumaniaHypothesis, Location.austriaHungary);
    setPieceLocation(Piece.armyRoumania1, Location.roumania);
    setPieceLocation(Piece.armyRoumania2, Location.roumania);
    setPieceLocation(Piece.armyRoumaniaNorth, Location.roumania);
 }

 void siegfriedLine() {
    if (pieceLocation(Piece.siegfriedLine) != Location.trayCentralPowersSpecialty) {
      return;
    }
    logLine('>*Siegfried Line planned.*');
    setPieceLocation(Piece.siegfriedLine, Location.germany);
  }

  void germanBombers() {
    if (pieceLocation(Piece.bombersGerman) != Location.trayCentralPowersSpecialty) {
      return;
    }
    logLine('>*German Bombers operational.*');
    setPieceLocation(Piece.bombersGerman, Location.germany);
  }

  void arabRevolt() {
    if (pieceLocation(Piece.armyArabInactive) != Location.palestine) {
      return;
    }
    logLine('### Arab Revolt.');
    logLine('>Palestine Theater opens.');
    setPieceLocation(Piece.armyArabInactive, Location.discarded);
    setPieceLocation(Piece.armyArab, Location.palestine);
  }

  void doUsEntry() {
    final armyTurns = [
      (Piece.armyUsa1, 1),
      (Piece.armyUsa5, 4),
      (Piece.armyUsa4, 5),
      (Piece.armyUsa6, 6),
    ];
    for (final armyTurn in armyTurns) {
      final army = armyTurn.$1;
      final turns = armyTurn.$2;
      setPieceLocation(army, futureTurnBox(turns));
    }
    discardUboats();
  }

  void usEntry() {
    if (!americaNeutral) {
      return;
    }
    logLine('### The U.S.A. enters the war.');
    doUsEntry();
  }

  void britishBombers() {
    if (pieceLocation(Piece.bombersBritish) != Location.trayBritish) {
      return;
    }
    logLine('>*British Bombers operational.*');
    setPieceLocation(Piece.bombersBritish, Location.germany);
  }

  void frenchTankArmy() {
    if (frontSurrendered(Location.france) || pieceLocation(Piece.tank) != Location.trayFrench) {
      return;
    }
    logLine('>*French Tank Army formed.*');
    setPieceLocation(Piece.tank, Location.france);
  }

  void nervenkrieg() {
    if (frontSurrendered(Location.france) || frontSurrendered(Location.italy) || pieceLocation(Piece.hindenLuden) != Location.germany) {
      return;
    }
    logLine('>*General Ludendorff suffers a nervous breakdown and urges the Kaiser to surrender.*');
    setPieceLocation(Piece.hindenLuden, Location.discarded);
  }

  void berlinerTageblattPhaseEvents() {
    final specialEvents = {
      3: putnik,
      4: putnik,
      5: putnik,
      6: putnik,
      7: britishShellShortage,
      8: britishShellShortage,
      9: poisonGas,
      10: poisonGas,
      11: mackensen,
      12: mackensen,
      13: placeOfExecution,
      14: placeOfExecution,
      15: brusilov,
      16: brusilov,
      17: poisonGas,
      18: poisonGas,
      19: stosstruppen,
      20: stosstruppen,
      21: hoffmann,
      22: hoffmann,
      23: alpenkorps,
      24: alpenkorps,
      25: foch,
      26: foch,
      27: spanishFlu,
      28: spanishFlu,
      29: usAssistance,
      30: usAssistance,
      31: diaz,
      32: diaz,
      33: blackDayOfTheArmy
    };

    final generalEvents = {
      7: [turkishEntry],
      8: [turkishEntry],
      9: [turkishEntry, italianEntry],
      10: [turkishEntry, italianEntry],
      11: [turkishEntry, italianEntry, bulgarianEntry],
      12: [turkishEntry, italianEntry, bulgarianEntry],
      13: [italianEntry, bulgarianEntry, hindenLuden],
      14: [italianEntry, bulgarianEntry, hindenLuden],
      15: [bulgarianEntry, hindenLuden],
      16: [bulgarianEntry, hindenLuden],
      17: [roumanianEntry, hindenLuden],
      18: [roumanianEntry, hindenLuden],
      19: [roumanianEntry, siegfriedLine],
      20: [roumanianEntry, siegfriedLine],
      21: [roumanianEntry, siegfriedLine, germanBombers, arabRevolt],
      22: [roumanianEntry, siegfriedLine, germanBombers, arabRevolt],
      23: [siegfriedLine, usEntry, germanBombers, arabRevolt],
      24: [siegfriedLine, usEntry, germanBombers, arabRevolt],
      25: [usEntry, germanBombers, arabRevolt],
      26: [usEntry, germanBombers, arabRevolt],
      27: [usEntry, britishBombers],
      28: [usEntry, britishBombers],
      29: [britishBombers, frenchTankArmy, nervenkrieg],
      30: [britishBombers, frenchTankArmy, nervenkrieg],
      31: [britishBombers, frenchTankArmy],
      32: [britishBombers, frenchTankArmy],
      33: [frenchTankArmy],
    };

    logLine('>|Effect|Value|');
    logLine('>|:---|:---:|');
    int die = rollD6();
    logD6InTable(die);
    logLine('>|Turn|${turn + 1}');
    int result = turn + die + 1;
    logLine('>|Total|$result|');
    final specialEventHandler = specialEvents[result];
    if (specialEventHandler != null) {
      specialEventHandler();
    }
    final generalEventHandlers = generalEvents[result];
    if (generalEventHandlers != null) {
      for (final generalEventHandler in generalEventHandlers) {
        generalEventHandler();
      }
    }
  }

  void navalAirWarfarePhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Naval/Air Warfare Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Naval/Air Warfare Phase');
  }

  void navalAirWarfarePhaseDeployBlockadeRunners() {
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
        setPrompt('Select Blockade Runner or High Seas Fleet to place');
        int inPortCount = 0;
        int northSeaCount = 0;
        for (final blockadeRunner in PieceType.blockadeRunner.pieces) {
          if (pieceLocation(blockadeRunner) == Location.blockadeRunners) {
            pieceChoosable(blockadeRunner);
            inPortCount += 1;
          } else if (pieceLocation(blockadeRunner).isType(LocationType.sea)) {
            pieceChoosable(blockadeRunner);
            if (pieceLocation(blockadeRunner).isType(LocationType.northSea)) {
              northSeaCount += 1;
            }
          }
        }
        Location highSeasFleetLocation = pieceLocation(Piece.highSeasFleet);
        if (highSeasFleetLocation.isType(LocationType.sea) || (highSeasFleetLocation == Location.germany && northSeaCount > 0)) {
          pieceChoosable(Piece.highSeasFleet);
        }
        choiceChoosable(Choice.next, inPortCount == 0);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.next)) {
        clearChoices();
        return;
      }
      final piece = selectedPiece()!;
      final destination = selectedLocation();
      if (destination == null) {
        setPrompt('Select destination');
        final location = pieceLocation(piece);
        if (piece == Piece.highSeasFleet) {
          if (location != Location.germany) {
            locationChoosable(Location.germany);
          }
          for (final sea in LocationType.sea.locations) {
            if (piecesInLocationCount(PieceType.blockadeRunner, sea) == 1) {
              locationChoosable(sea);
            }
          }
        } else {
          if (location != Location.blockadeRunners) {
            locationChoosable(Location.blockadeRunners);
          }
          for (final sea in LocationType.sea.locations) {
            if (piecesInLocationCount(PieceType.blockadeRunner, sea) == 0) {
              locationChoosable(sea);
            }
          }
        }
        choiceChoosable(Choice.cancel, true);
        throw PlayerChoiceException();
      }
      logLine('>${logPiece(piece)} moves to ${logLocation(destination)}.');
      setPieceLocation(piece, destination);
      clearChoices();
    }
  }

  void navalAirWarfarePhaseDeployCruisers() {
    final cruisers = piecesInLocation(PieceType.cruiser, Location.britishCruisers);
    if (cruisers.isNotEmpty) {
      final cruiserTable = [
        [[Location.sea2a], [Location.sea2b, Location.sea2b], [Location.sea2c, Location.sea2c, Location.sea2b], [Location.sea1a, Location.sea1a, Location.sea2a, Location.sea4]],
        [[Location.sea2b], [Location.sea2a, Location.sea2a], [Location.sea2b, Location.sea2b, Location.sea2c], [Location.sea2c, Location.sea2c, Location.sea1a, Location.sea1b]],
        [[Location.sea3], [Location.sea3, Location.sea3], [Location.sea2a, Location.sea2a, Location.sea2c], [Location.sea2b, Location.sea2b, Location.sea2a, Location.sea2c]],
        [[Location.sea3], [Location.sea4, Location.sea4], [Location.sea3, Location.sea3, Location.sea2b], [Location.sea2a, Location.sea2a, Location.sea1b, Location.sea2c]],
        [[Location.sea3], [Location.sea2a, Location.sea3], [Location.sea4, Location.sea4, Location.sea2a], [Location.sea4, Location.sea4, Location.sea2b, Location.sea3]],
        [[Location.sea4], [Location.sea2b, Location.sea4], [Location.sea2c, Location.sea3, Location.sea4], [Location.sea3, Location.sea3, Location.sea2c, Location.sea4]],
        [[Location.sea4], [Location.sea2c, Location.sea4], [Location.sea2b, Location.sea3, Location.sea4], [Location.sea2b, Location.sea2c, Location.sea3, Location.sea4]],
        [[Location.sea4], [Location.sea2c, Location.sea3], [Location.sea2a, Location.sea3, Location.sea4], [Location.sea2a, Location.sea2b, Location.sea3, Location.sea4]],
        [[Location.sea4], [Location.sea3, Location.sea4], [Location.sea2b, Location.sea2c, Location.sea4], [Location.sea4, Location.sea4, Location.sea1a, Location.sea2a]],
        [[Location.sea2c], [Location.sea3, Location.sea4], [Location.sea2a, Location.sea2c, Location.sea3], [Location.sea1b, Location.sea2a, Location.sea2b, Location.sea3]],
        [[Location.sea2a], [Location.sea2b, Location.sea4], [Location.sea2a, Location.sea2b, Location.sea4], [Location.sea1a, Location.sea2a, Location.sea3, Location.sea4]],
      ];
      logLine('### British Cruiser deployment.');
      final rolls = roll2D6();
      log2D6(rolls);
      final locations = cruiserTable[rolls.$3 - 2][cruisers.length - 1];
      for (int i = 0; i < cruisers.length; ++i) {
        logLine('>${logPiece(cruisers[i])} patrols ${logLocation(locations[i])}.');
        setPieceLocation(cruisers[i], locations[i]);
      }
    }
  }

  void navalAirWarfarePhaseEconomicHaul() {
    int haul = 0;
    bool turkishSmugglers = false;
    for (final sea in LocationType.sea.locations) {
      int blockadeRunnerCount = piecesInLocationCount(PieceType.blockadeRunner, sea);
      bool highSeasFleet = pieceLocation(Piece.highSeasFleet) == sea;
      int cruiserCount = piecesInLocationCount(PieceType.cruiser, sea);
      if (highSeasFleet || (blockadeRunnerCount > 0 && cruiserCount == 0)) {
        haul += seaValue(sea);
        if (sea == Location.sea1b && !turkeyNeutral && !turkeySurrendered) {
          turkishSmugglers = true;
        }
      }
    }
    logLine('### Economic Haul: $haul Reichsmarks.');
    if (turkishSmugglers) {
      if (choicesEmpty()) {
        setPrompt('Use Turkish Smugglers?');
        choiceChoosable(Choice.yes, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        logLine('>Turkish Smugglers smuggle 1 Lira to Ottoman Turkey.');
        adjustLira(1);
        haul -= 1;
      }
      clearChoices();
    }
    adjustReichsmarks(haul);
  }

  void navalAirWarfarePhaseSinkBlockadeRunners() {
    for (final sea in LocationType.sea.locations) {
      final blockadeRunner = pieceInLocation(PieceType.blockadeRunner, sea);
      if (blockadeRunner != null) {
        int cruiserCount = piecesInLocationCount(PieceType.cruiser, sea);
        if (cruiserCount == 2) {
          logLine('>${logPiece(blockadeRunner)} in ${logLocation(sea)} sunk.');
          setPieceLocation(blockadeRunner, Location.neutralPorts);
        }
      }
    }
  }

  void navalAirWarfarePhaseMajorNavalBattle() {
    final location = pieceLocation(Piece.highSeasFleet);
    if (!location.isType(LocationType.sea)) {
      return;
    }
    final cruisers = piecesInLocation(PieceType.cruiser, location);
    if (cruisers.isEmpty) {
      return;
    }
    logLine('### Major Naval Battle in ${logLocation(location)}.');
    int die = rollD6();
    logD6(die);
    switch (die) {
    case 1:
      logLine('>British Victory.');
      logLine('>${logPiece(Piece.highSeasFleet)} sunk.');
      setPieceLocation(Piece.highSeasFleet, Location.discarded);
    case 2:
      logLine('>British Advantage.');
      logLine('>${logPiece(Piece.highSeasFleet)} requires substantial repairs.');
      final hsfLocation = futureTurnBox(3);
      if (hsfLocation != Location.discarded) {
        logLine('>${logPiece(Piece.highSeasFleet)} out of action until ${logLocation(hsfLocation)}.');
      } else {
        logLine('>${logPiece(Piece.highSeasFleet)} permanently out of action.');
      }
      setPieceLocation(Piece.highSeasFleet, hsfLocation);
    case 3:
      logLine('>British Advantage.');
      logLine('>${logPiece(Piece.highSeasFleet)} requires repairs.');
      final hsfLocation = futureTurnBox(2);
      if (hsfLocation != Location.discarded) {
        logLine('>${logPiece(Piece.highSeasFleet)} out of action until ${logLocation(hsfLocation)}.');
      } else {
        logLine('>${logPiece(Piece.highSeasFleet)} permanently out of action.');
      }
      setPieceLocation(Piece.highSeasFleet, hsfLocation);
    case 4:
      logLine('>Skirmish.');
    case 5:
      logLine('>German Advantage.');
      if (cruisers.length > 1) {
        cruisers.shuffle();
      }
      logLine('>${logPiece(cruisers[0])} requires repairs.');
      setPieceLocation(cruisers[0], Location.drawCup);
    case 6:
      logLine('>German Victory.');
      if (cruisers.length > 1) {
        cruisers.shuffle();
      }
      logLine('>${logPiece(cruisers[0])} sunk.');
      setPieceLocation(cruisers[0], Location.discarded);
    }
  }

  void navalAirWarfarePhaseHindenLuden() {
    if (pieceLocation(Piece.hindenLuden) == Location.germany) {
      logLine('### Hinden-Luden Bonus.');
      adjustReichsmarks(2);
    }
  }

  void navalAirWarfarePhaseControlOfTheSkies() {
    if (airSuperiorityCentralPowers == (year == 1915 || year == 1917)) {
      return;
    }
    if (choicesEmpty()) {
      setPrompt('Adjust Control of the Skies die roll');
      choiceChoosable(Choice.minusOne, reichsmarks >= 1);
      choiceChoosable(Choice.zero, true);
      choiceChoosable(Choice.plusOne, reichsmarks >= 1);
      throw PlayerChoiceException();
    }
    logLine('### Control of the Skies.');
    logLine('>|Effect|Value|');
    logLine('>|:---|:---:|');
    int die = rollD6();
    int modifier = 0;
    if (checkChoice(Choice.minusOne)) {
      spendReichsmarks(1);
      modifier = -1;
    } else if (checkChoice(Choice.plusOne)) {
      spendReichsmarks(1);
      modifier = 1;
    }
    logD6InTable(die);
    if (modifier == -1) {
      logLine('>|Aircraft development research|-1|');
    } else if (modifier == 1) {
      logLine('>|Aircraft development research|+1|');
    }
    int total = die + modifier;
    logLine('>|Total|$total|');
    logLine('>|Advance|$airSuperiorityAdvanceRoll|');
    if (die > 1 && die < 6) {
      die += modifier;
    }
    if (die <= airSuperiorityAdvanceRoll) {
      final location = Location.values[pieceLocation(Piece.airSuperiority).index + 1];
      logLine('>*${logPiece(Piece.airSuperiority)} advances to ${logLocation(location)}.*');
      setPieceLocation(Piece.airSuperiority, location);
      if (location == Location.airSuperiority_1) {
        setPieceLocation(Piece.redBaron, Location.germany);
      }
    } else {
      logLine('>${logPiece(Piece.airSuperiority)} remains with ${logLocation(pieceLocation(Piece.airSuperiority))}.');
    }
    clearChoices();
  }

  void navalAirWarfarePhaseGermanBombers() {
    if (pieceLocation(Piece.bombersGerman) == Location.germany) {
      if (choicesEmpty()) {
        for (var front in [Location.belgium, Location.france]) {
          if (frontActive(front) && pieceLocation(Piece.armyBritainBef) != front) {
            if (piecesInLocationCount(PieceType.army, front) > 1) {
              var armies = weakestArmiesInLocation(PieceType.army, front);
              for (final army in armies) {
                pieceChoosable(army);
              }
            }
          }
        }
        if (choosablePieceCount == 0) {
          return;
        }
        setPrompt('Choose Army to Bomb');
        throw PlayerChoiceException();
      }
      final army = selectedPiece()!;
      final front = pieceLocation(army);
      final reserves = frontReservesLocation(front);
      logLine('### ${logPiece(Piece.bombersGerman)} target ${logPiece(army)} in ${logLocation(front)}.');
      int die = rollD6();
      logD6(die);
      int threshold = airSuperiorityCentralPowers ? 5 : 6;
      if (die >= threshold) {
        logLine('>${logPiece(army)} withdrawn to ${logLocation(reserves)}.');
        setPieceLocation(army, reserves);
      } else {
        logLine('>Bombing ineffective.');
      }
      clearChoices();
    }
  }

  void navalAirWarfarePhaseBritishBombers() {
    if (pieceLocation(Piece.bombersBritish) == Location.germany) {
      logLine('### British Bombers.');
      int die = 0;
      if (airSuperiorityCentralPowers) {
        die = rollD6();
        logD6(die);
      } else {
        final rolls = rollD6x2();
        logD6x2(rolls);
        die = min(rolls.$1, rolls.$2);
      }
      switch (die) {
      case 1:
      case 2:
        adjustReichsmarks(-2);
      case 3:
      case 4:
      case 5:
        adjustReichsmarks(-1);
      case 6:
        logLine('>No effect');
      }
    }
  }

  void navalAirWarfarePhaseZeppelinRaids() {
    if (pieceLocation(Piece.zeppelin) == Location.germany) {
      if (choicesEmpty()) {
        setPrompt('Choose Zeppelin target');
        for (var front in [Location.belgium, Location.france]) {
          if (frontActive(front)) {
            if (pieceLocation(Piece.armyBritainBef) == front) {
              pieceChoosable(Piece.armyBritainBef);
            } else {
              if (piecesInLocationCount(PieceType.army, front) > 1) {
                var armies = piecesInLocation(PieceType.army, front);
                for (final army in armies) {
                  pieceChoosable(army);
                }
              }
            }
            final trenches = pieceInLocation(PieceType.trenches, front);
            if (trenches != null) {
              pieceChoosable(trenches);
            }
          }
        }
        final askaris = piecesInLocation(PieceType.askari, Location.eastAfrica);
        if (askaris.length == 1) {
          pieceChoosable(askaris[0]);
        }
        if (reichsmarks >= 2) {
          for (final sea in LocationType.northSea.locations) {
            final cruisers = piecesInLocation(PieceType.cruiser, sea);
            for (final cruiser in cruisers) {
              pieceChoosable(cruiser);
            }
          }
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      final target = selectedPiece();
      if (target != null) {
        if (target.isType(PieceType.army)) {
          final front = pieceLocation(target);
          final reserves = frontReservesLocation(front);
          logLine('### Zeppelin Economic Bombing targets ${logLocation(front)}.');
          int die = rollD6();
          logD6(die);
          int threshold = airSuperiorityCentralPowers ? 5 : 6;
          if (die >= threshold) {
            if (target == Piece.armyBritainBef) {
              logLine('>${logPiece(Piece.armyBritainBef)} reformed as ${logPiece(Piece.armyBritain2)}  in ${logLocation(reserves)}.');
              setPieceLocation(Piece.armyBritain2, frontReservesLocation(pieceLocation(target)));
              setPieceLocation(Piece.armyBritainBef, Location.discarded);
            } else {
               logLine('>${logPiece(target)} withdrawn to ${logLocation(reserves)}.');
              setPieceLocation(target, frontReservesLocation(pieceLocation(target)));
            }
          } else {
            logLine('>Bombing ineffective.');
          }
        } else if (target.isType(PieceType.trenches)) {
          final front = pieceLocation(target);
          logLine('### Zeppelin Recon neutralized ${logPiece(target)} in ${logLocation(front)}.');
          setPieceLocation(target, Location.trayEntenteSpecialty);
        } else if (target.isType(PieceType.askari)) {
          logLine('### Zeppelin atempts to supply ${logLocation(Location.eastAfrica)}.');
          int die = rollD6();
          logD6(die);
          if (die >= 5) {
            final askari = pieceInLocation(PieceType.askari, Location.trayCentralPowersSpecialty)!;
            logLine('>More ${logPiece(askari)} deployed in ${logLocation(Location.eastAfrica)}.');
            setPieceLocation(askari, Location.eastAfrica);
            var armies = piecesInLocation(PieceType.indianArmy, Location.india);
            if (armies.isEmpty) {
              armies = piecesInLocation(PieceType.indianArmy, Location.mespotamia);
            }
            final army = randPiece(armies)!;
            logLine('>${logPiece(army)} transferred to ${logLocation(Location.eastAfrica)}.');
            setPieceLocation(army, Location.eastAfrica);
          }
        } else if (target.isType(PieceType.cruiser)) {
          logLine('### Zeppelin Naval Bombing');
          spendReichsmarks(2);
          int die = rollD6();
          logD6(die);
          int threshold = airSuperiorityCentralPowers ? 5 : 6;
          if (die >= threshold) {
            logLine('>${logPiece(target)} requires repairs.');
            setPieceLocation(target, Location.drawCup);
          } else {
            logLine('>Bombing unsuccessful.');
          }
        }
        logLine('>Zeppelin Saving Throw');
        int die = rollD6();
        logD6(die);
        final zeppelinLocation = futureTurnBox(die);
        if (zeppelinLocation != Location.discarded) {
          logLine('>${logPiece(Piece.zeppelin)} out of action until ${logLocation(zeppelinLocation)}.');
        } else {
          logLine('>${logPiece(Piece.zeppelin)} permanently out of action.');
        }
        setPieceLocation(Piece.zeppelin, zeppelinLocation);
      }
      clearChoices();
    }
  }

  void navalAirWarfarePhaseAirCombat() {
    if (pieceLocation(Piece.redBaron) == Location.germany) {
      if (choicesEmpty()) {
        for (var front in [Location.belgium, Location.france]) {
          if (frontActive(front) && piecesInLocationCount(PieceType.army, front) > 1) {
            var armies = piecesInLocation(PieceType.army, front);
            for (final army in armies) {
              pieceChoosable(army);
            }
          }
        }
        setPrompt('Select Army to attack with Red Baron');
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      final target = selectedPiece();
      if (target != null) {
        final location = pieceLocation(target);
        logLine('>${logPiece(Piece.redBaron)} targets ${logPiece(target)} in ${logLocation(location)}.');
        setPieceLocation(Piece.redBaron, location);
        _state.redBaronTarget = target;
      }
      clearChoices();
    }
  }

  void centralPowersAttackPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Central Powers Attack Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Central Powers Attack Phase');
    _phaseState = PhaseStateCentralPowersAttack();
  }

  void centralPowersAttackPhaseAttacks() {
    final phaseState = _phaseState as PhaseStateCentralPowersAttack;
    while (true) {
      if (checkChoice(Choice.cancel)) {
        clearChoices();
      }
      if (choicesEmpty()) {
        setPrompt('Select Army to Attack');
        int maxArmyCount = 0;
        for (final front in LocationType.front.locations) {
          if (!frontSurrendered(front)) {
            int armyCount = piecesInLocationCount(PieceType.army, front);
            if (armyCount > maxArmyCount) {
              maxArmyCount = armyCount;
            }
          }
        }
        int germanMarks = reichsmarks + krupp;
        int austrianMarks = reichsmarks + kaisertreu;
        for (final front in LocationType.front.locations) {
          if (frontActive(front) && (front != Location.italy || !alpineWinter)) {
            bool austrian = frontAustrian(front);
            int marks = austrian ? austrianMarks : germanMarks;
            if (marks >= 1) {
              if (pieceLocation(Piece.tank) == front) {
                pieceChoosable(Piece.tank);
              } else if (piecesInLocationCount(PieceType.trenches, front) > 0) {
                final trenches = pieceInLocation(PieceType.trenches, front)!;
                pieceChoosable(trenches);
              } else if (piecesInLocationCount(PieceType.forts, front) > 0) {
                final forts = pieceInLocation(PieceType.forts, front)!;
                pieceChoosable(forts);
              } else {
                final armies = piecesInLocation(PieceType.army, front);
                if (armies.length > 1) {
                  if (pieceLocation(Piece.armyBritainBef) == front) {
                    pieceChoosable(Piece.armyBritainBef);
                  } else {
                    for (final army in armies) {
                      if (army != _state.redBaronTarget || airSuperiorityCentralPowers || marks >= 2) {
                        pieceChoosable(army);
                      }
                    }
                  }
                } else if (maxArmyCount <= 3 && piecesInLocationCount(PieceType.pink, front) > 0) {
                  int cost = [Location.ukraine, Location.lithuania].contains(front) ? 4 : 3;
                  if (marks >= cost && front != Location.belgium && !armies[0].isType(PieceType.aaoArmy)) {
                    pieceChoosable(armies[0]);
                  }
                }
              }
            }
          }
        }
        if (austrianMarks >= 1) {
          final roumanianArmies = piecesInLocation(PieceType.army, Location.roumania);
          for (final army in roumanianArmies) {
            pieceChoosable(army);
          }
        }
        if (pieceLocation(Piece.hindenLuden) == Location.germany && phaseState.cannibalizeCount == 0) {
          final civilSocieties = piecesInLocation(PieceType.civilSociety, Location.germany);
          for (final civilSociety in civilSocieties) {
            pieceChoosable(civilSociety);
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
      if (piece.isType(PieceType.civilSociety)) {
        logLine('>${logPiece(piece)} threatened.');
        int die = rollD6();
        logD6(die);
        switch (die) {
        case 1:
          logLine('>Riots break out.');
          final cities = piecesInLocation(PieceType.civilSociety, Location.ruhe);
          if (cities.isNotEmpty) {
            final city = randPiece(cities)!;
            logLine('>${logPiece(city)} moves to ${logLocation(Location.unruhe)}.');
            setPieceLocation(city, Location.unruhe);
          }
        case 2:
          logLine('>Destruction of ${logPiece(piece)} leads to Resistance.');
          setPieceLocation(piece, Location.discarded);
          if (advanceSocialistRevolution(1)) {
            revolutionExplodes();
          }
        case 3:
        case 4:
        case 5:
        case 6:
          logLine('>Destruction of ${logPiece(piece)} has its Reward.');
          adjustReichsmarks(die);
          setPieceLocation(piece, Location.discarded);
        }
        phaseState.cannibalizeCount += 1;
        clearChoices();
      } else {
        setPrompt('Select payment method for Attack');
        Location location = pieceLocation(piece);
        bool isArmy = piece.isType(PieceType.army);
        bool kaiserschlacht = isArmy && location.isType(LocationType.front) && piecesInLocationCount(PieceType.army, location) == 1;
        final paymentChoice = selectedPayment();
        if (paymentChoice == null) {
          int cost = 1;
          if (piece == _state.redBaronTarget && !airSuperiorityCentralPowers) {
            cost = 2;
          } else if (kaiserschlacht) {
            if (location == Location.ukraine || location == Location.lithuania) {
              cost = max(piecesInLocationCount(PieceType.russianArmy, Location.ukraine), piecesInLocationCount(PieceType.russianArmy, Location.lithuania));
            } else {
              cost = 3;
            }
          }
          bool austria = location == Location.roumania || frontAustrian(location);
          enableAttackPaymentChoices(cost, austria);
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        logLine('### Central Powers Attack ${logPiece(piece)} in ${logLocation(location)}.');
        makeAttackPayment(paymentChoice);
        if (piece == Piece.tank) {
          logLine('>${logPiece(piece)} eliminated.');
          setPieceLocation(piece, Location.trayFrench);
        } else {
          int die = 0;
          if (piece == _state.redBaronTarget) {
            final dice = rollD6x2();
            logD6x2(dice);
            final d1 = dice.$1;
            final d2 = dice.$2;
            if (d1 == d2) {
              final redBaronLocation = futureTurnBox(d1);
              logLine('>${logPiece(Piece.redBaron)} out of action until ${logLocation(redBaronLocation)}.');
              setPieceLocation(Piece.redBaron, redBaronLocation);
              die = 1;
            } else {
              die = max(d1, d2);
            }
          } else {
            die = rollD6();
          }
          logLine('>|Effect|Value|');
          logLine('>|:---|:---:|');
          logD6InTable(die);
          int value = 0;
          if (piece.isType(PieceType.army)) {
            value = armyValue(piece);
          } else if (piece.isType(PieceType.forts)) {
            value = 3;
          } else if (piece.isType(PieceType.trenches)) {
            value = 4;
          }
          int eventModifier = eventDrm(location, phaseState.attackCount);
          int modifiers = eventModifier;
          if ([Location.italy, Location.serbia, Location.ukraine, Location.roumania].contains(location) && piecesInLocationCount(PieceType.roumanianArmy, Location.roumania) > 0) {
            logLine('>|Hypothesis Z|-1|');
            modifiers -= 1;
          }
          if (kaiserschlacht) {
            logLine('>|Kaisersclacht|-1|');
            modifiers -= 1;
          }
          logLine('>|${logPiece(piece)}|$value|');
          if (die == 6 || (die != 1 && die + modifiers > value)) {
            if (kaiserschlacht) {
              logLine('>Kaiserschlacht succeeded.');
              logLine('>${logPiece(piece)} eliminated.');
              setPieceLocation(piece, frontReservesLocation(location));
              if (location == Location.france) {
                logLine('>*France surrenders.*');
                setPieceLocation(Piece.surrenderFrance, Location.france);
                setPieceLocation(Piece.pinkFrance, Location.discarded);
                setPieceLocation(Piece.frenchMutiny, Location.discarded);
              } else if (location == Location.italy) {
                logLine('>*Italy surrenders.*');
                setPieceLocation(Piece.surrenderItaly, Location.italy);
                setPieceLocation(Piece.pinkItaly, Location.discarded);
              } else if (location == Location.serbia) {
                logLine('>*Serbian army defeated.*');
                for (final serbianArmy in PieceType.serbianArmy.pieces) {
                  setPieceLocation(serbianArmy, Location.discarded);
                }
                for (final aaoArmy in PieceType.aaoArmy.pieces) {
                  setPieceLocation(aaoArmy, Location.serbiaReserves);
                }
                final aaoArmies = PieceType.aaoArmy.pieces;
                final army = randPiece(aaoArmies)!;
                logLine('>${logPiece(army)} deployed to ${logLocation(Location.serbia)}');
                setPieceLocation(army, Location.serbia);
                logLine('>${logPiece(Piece.railway)} operational.');
                setPieceLocation(Piece.railway, Location.bulgaria);
                setPieceLocation(Piece.pinkSerbia, Location.discarded);
              } else {
                logLine('>*Russia surrenders.*');
                for (final russianArmy in PieceType.russianArmy.pieces) {
                  setPieceLocation(russianArmy, Location.discarded);
                }
                if (!turkeySurrendered) {
                  setPieceLocation(Piece.armyArmenia1, Location.yerevan);
                  setPieceLocation(Piece.armyArmenia2, Location.yerevan);
                  setPieceLocation(Piece.armyAssyria, Location.yerevan);
                  setPieceLocation(Piece.armyBritainDunster, Location.yerevan);
                  final armenianArmies = [Piece.armyArmenia1, Piece.armyArmenia2];
                  final army = randPiece(armenianArmies)!;
                  logLine('>${logPiece(army)} deployed to ${logLocation(Location.armenia)}');
                  setPieceLocation(army, Location.armenia);
                }
                logLine('>${logPiece(Piece.kemal)} reassigned.');
                setPieceLocation(Piece.kemal, Location.discarded);
              }
            } else {
              logLine('>Attack succeeded.');
              if (piece.isType(PieceType.roumanianArmy)) {
                logLine('>${logPiece(piece)} eliminated.');
                setPieceLocation(piece, Location.discarded);
                if (piecesInLocationCount(PieceType.roumanianArmy, Location.roumania) == 0) {
                  logLine('>*Roumania surrenders.*');
                  setPieceLocation(Piece.roumaniaHypothesis, Location.discarded);
                  setPieceLocation(Piece.surrenderRoumania, Location.roumania);
                }
              } else if (piece == Piece.armyBritainBef) {
                final reserves = frontReservesLocation(location);
                logLine('>${logPiece(Piece.armyBritainBef)} reformed as ${logPiece(Piece.armyBritain2)}  in ${logLocation(reserves)}.');
                setPieceLocation(piece, Location.discarded);
                setPieceLocation(Piece.armyBritain2, reserves);
              } else if (piece.isType(PieceType.trenches)) {
                logLine('>${logPiece(piece)} breached.');
                setPieceLocation(piece, Location.trayEntenteSpecialty);
              } else if (piece.isType(PieceType.forts)) {
                logLine('>${logPiece(piece)} destroyed.');
                setPieceLocation(piece, Location.trayEntenteSpecialty);
              } else {
                final reserves = frontReservesLocation(location);
                logLine('>${logPiece(piece)} withdrawn to ${logLocation(reserves)}.');
                setPieceLocation(piece, reserves);
              }
            }
          } else {
            if (kaiserschlacht) {
              logLine('>Kaiserschlacht failed.');
              final reserveArmies = strongestArmiesInLocation(PieceType.army, frontReservesLocation(location));
              final army = randPiece(reserveArmies)!;
              logLine('>${logPiece(piece)} deployed to ${logLocation(location)}.');
              setPieceLocation(army, location);
            } else {
              logLine('>Attack failed.');
            }
          }
          if (piece == _state.redBaronTarget) {
            if ([Location.belgium, Location.france].contains(pieceLocation(Piece.redBaron))) {
              setPieceLocation(Piece.redBaron, Location.germany);
            }
          }
        }
        phaseState.attackCount += 1;
        clearChoices();
      }
    }
  }

  void centralPowersAttackPhaseEnd() {
    _state.redBaronTarget = null;
    if ([Location.belgium, Location.france].contains(pieceLocation(Piece.redBaron))) {
      setPieceLocation(Piece.redBaron, Location.germany);
    }
    _phaseState = null;
  }

  void nearEastPhaseBegin() {
    if (!turkeyNeutral && !summer) {
      if (!checkChoiceAndClear(Choice.next)) {
        setPrompt('Proceed to Near East Phase');
        choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
      }
      logLine('## Near East Phase');
    }
  }

void nearEastPhaseBuildAskari() {
  if (turkeyNeutral || summer) {
    return;
  }
  if (choicesEmpty()) {
    if (piecesInLocationCount(PieceType.askari, Location.eastAfrica) != 1 || reichsmarks < 1) {
      return;
    }
    setPrompt('Attempt to build Askari?');
    choiceChoosable(Choice.yes, true);
    choiceChoosable(Choice.no, true);
    throw PlayerChoiceException();
  }
  if (checkChoice(Choice.yes)) {
    logLine('### Build Askari');
    spendReichsmarks(1);
    int die = rollD6();
    logD6(die);
    if (die >= 3) {
      final askari = pieceInLocation(PieceType.askari, Location.trayCentralPowersSpecialty)!;
      logLine('>${logPiece(askari)} built in ${logLocation(Location.eastAfrica)}.');
      setPieceLocation(askari, Location.eastAfrica);
      var armies = piecesInLocation(PieceType.indianArmy, Location.india);
      if (armies.isEmpty) {
        armies = piecesInLocation(PieceType.indianArmy, Location.mespotamia);
      }
      final army = randPiece(armies)!;
      logLine('>${logPiece(army)} transferred to ${logLocation(Location.eastAfrica)}.');
      setPieceLocation(army, Location.eastAfrica);
    }
  }
  clearChoices();
}

void nearEastPhaseIndiansAttackAskari() {
  if (turkeyNeutral || summer) {
    return;
  }
  final armies = piecesInLocation(PieceType.indianArmy, Location.eastAfrica);
  final askaris = piecesInLocation(PieceType.askari, Location.eastAfrica);
  int askariCount = askaris.length;
  for (int i = 0; i < armies.length; ++i) {
    final army = armies[i];
    final askari = askaris[i];
    logLine('### ${logPiece(army)} Attacks ${logPiece(askari)} in ${logLocation(Location.eastAfrica)}.');
    var dice = roll2D6();
    log2D6(dice);
    if (dice.$3 != 12 && _options.indiansTwoRolls) {
      dice = roll2D6();
      log2D6(dice);
    }
    if (dice.$3 == 12) {
      logLine('>Attack succeeded.');
      logLine('>${logPiece(army)} eliminated.');
      if (askariCount == 2) {
        setPieceLocation(askaris[i], Location.trayCentralPowersSpecialty);
      } else {
        logLine('>*${logLocation(Location.eastAfrica)} conquered.*');
        setPieceLocation(Piece.askari_0, Location.discarded);
        setPieceLocation(Piece.askari_1, Location.discarded);
      }
      logLine('>${logPiece(army)} transferred to ${logLocation(Location.india)}.');
      setPieceLocation(army, Location.india);
      askariCount -=1;
    } else {
      logLine('>Attack failed.');
    }
  }
}

void nearEastPhaseEntenteDeployment() {
  if (!turkeyActive || summer) {
    return;
  }
  logLine('### Near East Entente Deployment');
  int die = rollD6();
  logD6(die);
  if (die != 3) {
    if (piecesInLocationCount(PieceType.army, Location.armenia) == 4) {
      logLine('>*Turkish forces in Armenian Theater collapse.*');
      turkeySurrenders();
    } else {
      final armies = strongestArmiesInLocation(PieceType.army, Location.yerevan);
      if (armies.isNotEmpty) {
        final army = randPiece(armies)!;
        logLine('>${logPiece(army)} deployed to ${logLocation(Location.armenia)}.');
        setPieceLocation(army, Location.armenia);
      }
    }
  }
  if (turkeyActive && die >= 3) {
    if (piecesInLocationCount(PieceType.indianArmy, Location.mespotamia) == 4) {
      logLine('>*Turkish forces in Mesopotamian Theater collapse.*');
      turkeySurrenders();
    } else {
      final armies = piecesInLocation(PieceType.indianArmy, Location.india);
      if (armies.isNotEmpty) {
        if (pieceLocation(Piece.siegeKut) == Location.mespotamia) {
          logLine('>Kut fell to advancing Indian forces.');
          setPieceLocation(Piece.siegeKut, Location.discarded);
        } else {
          final army = randPiece(armies)!;
          logLine('>${logPiece(army)} deployed to ${logLocation(Location.mespotamia)}.');
          setPieceLocation(army, Location.mespotamia);
        }
      }
    }
  }
  if (turkeyActive && die != 1 && die != 4 && pieceLocation(Piece.armyArabInactive) != Location.palestine) {
    if (piecesInLocationCount(PieceType.army, Location.palestine) == 4) {
      logLine('>*Turkish forces in Palestine Theater collapse.*');
      turkeySurrenders();
    } else {
      final armies = strongestArmiesInLocation(PieceType.army, Location.egypt);
      if (armies.isNotEmpty) {
        final army = randPiece(armies)!;
        logLine('>${logPiece(army)} deployed to ${logLocation(Location.palestine)}.');
        setPieceLocation(army, Location.palestine);
      }
    }
  }
}

void nearEastPhaseOttomanIncome() {
  if (!turkeyActive || summer) {
    return;
  }
  if (choicesEmpty()) {
    setPrompt('Earn Turkish Lira?');
    choiceChoosable(Choice.yes, true);
    choiceChoosable(Choice.no, true);
    throw PlayerChoiceException();
  }
  if (checkChoice(Choice.yes)) {
    final coins = piecesInLocation(PieceType.lira, Location.liraCup);
    final coin = randPiece(coins)!;
    logLine('### Turkish Income');
    adjustLira(liraValue(coin));
    setPieceLocation(coin, Location.discarded);
  }
  clearChoices();
}

void nearEastPhaseOttomanGroundCombat() {
  if (!turkeyActive || summer) {
    return;
  }
  while (true) {
    if (choicesEmpty()) {
      setPrompt('Select Army to Attack');
      if (lira >= 1) {
        var armies = piecesInLocation(PieceType.army, Location.armenia);
        if (armies.length > 1) {
          for (final army in armies) {
            pieceChoosable(army);
          }
        }
        armies = piecesInLocation(PieceType.army, Location.mespotamia);
        if (armies.length > 1) {
          for (final army in armies) {
            pieceChoosable(army);
          }
        }
        armies = piecesInLocation(PieceType.army, Location.palestine);
        if (armies.length > 1) {
          for (final army in armies) {
            pieceChoosable(army);
          }
        }
      }
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.next)) {
      clearChoices();
      return;
    }
    if (checkChoice(Choice.yes) || checkChoice(Choice.no)) {
      if (checkChoice(Choice.yes)) {
        logLine('>${logPiece(Piece.siegeKut)} begun.)');
        setPieceLocation(Piece.siegeKut, Location.mespotamia);
      }
      clearChoices();
    } else {
      final army = selectedPiece()!;
      clearChoices();
      final location = pieceLocation(army);
      logLine('### Ottoman Forces Attack ${logPiece(army)} in ${logLocation(location)}.');
      spendLira(1);
      logLine('>|Effect|Value|');
      logLine('>|:---|:---:|');
      int die = rollD6();
      logD6InTable(die);
      int modifiers = 0;
      if (pieceLocation(Piece.armyBritainMef) == Location.gallipoli) {
        logLine('>|MEF in Gallipoli|-1|');
        modifiers -= 1;
      }
      if (pieceLocation(Piece.armenians) == location) {
        logLine('>|Armenians|-1|');
        modifiers -= 1;
      }
      int total = die + modifiers;
      logLine('>|Total|$total|');
      int value = armyValue(army);
      logLine('>|${logPiece(army)}|$value|');
      if (total <= value && pieceLocation(Piece.kemal) == location) {
        logLine('>Kemal');
        die = rollD6();
        logD6InTable(die);
        if (pieceLocation(Piece.armyBritainMef) == Location.gallipoli) {
          logLine('>|MEF in Gallipoli|-1|');
        }
        if (pieceLocation(Piece.armenians) == location) {
          logLine('>|Armenians|-1|');
        }
        total = die + modifiers;
        logLine('>|Total|$total|');
        logLine('>|${logPiece(army)}|$value|');
      }
      if (total > armyValue(army)) {
        logLine('>Attack succeeded.');
        final reserves = nearEastTheaterReservesLocation(location);
        logLine('>${logPiece(army)} withdrawn to ${logLocation(reserves)}.');
        setPieceLocation(army, reserves);
        if (location == Location.mespotamia && die == 6 && pieceLocation(Piece.siegeKut) == Location.trayCentralPowersSpecialty) {
          setPrompt('Declare Siege of Kut?');
          choiceChoosable(Choice.yes, true);
          choiceChoosable(Choice.no, true);
          throw PlayerChoiceException();
        }
        if (location == Location.armenia && die == 6 && pieceLocation(Piece.armenians) == Location.armenia) {
          logLine('>*Armenian Genocide completed.*');
          setPieceLocation(Piece.armenians, Location.discarded);
          if (americaNeutral) {
            logLine('>American reaction.');
            final dice = roll2D6();
            log2D6(dice);
            if (dice.$3 <= 3) {
              logLine('>*The U.S.A. enters the war.*');
              doUsEntry();
            } else {
              logLine('>America remains neutral.');
            }
          }
        }
      } else {
        logLine('>Attack failed.');
      }
    }
  }
}

void industrialPhaseBegin() {
  if (!checkChoiceAndClear(Choice.next)) {
    setPrompt('Proceed to Industrial Phase');
    choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
  }
  logLine('## Industrial Phase');
}

void industrialPhaseActions() {
  while (true) {
    if (choicesEmpty()) {
      setPrompt('Select industrial action');
      if (piecesInLocationCount(PieceType.uboats, Location.trayNaval) > 0) {
        choiceChoosable(Choice.buildUboats, reichsmarks >= 2);
      }
      if (piecesInLocationCount(PieceType.blockadeRunner, Location.neutralPorts) > 0) {
        choiceChoosable(Choice.buildBlockadeRunners, reichsmarks >= 2);
      }
      if (pieceLocation(Piece.siegfriedLine) == Location.germany) {
        choiceChoosable(Choice.buildSiegfriedLine, reichsmarks >= 2);
      }
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    if (checkChoice(Choice.next)) {
      clearChoices();
      return;
    }
    if (checkChoiceAndClear(Choice.buildUboats)) {
      final location = piecesInLocationCount(PieceType.uboats, Location.belgium) == 0 ? Location.belgium : Location.france;
      final otherLocation = location == Location.belgium ? Location.france : Location.belgium;
      final uboats = piecesInLocation(PieceType.uboats, Location.trayNaval);
      final uboat = uboats[0];
      logLine('### Build ${logPiece(uboat)}');
      spendReichsmarks(2);
      logLine('>${logPiece(uboat)} patrol the coast of ${logLocation(location)}.');
      setPieceLocation(uboats[0], location);
      if (americaNeutral && piecesInLocationCount(PieceType.uboats, otherLocation) == 1) {
        logLine('>American reaction to Unrestricted Submarine Warfare.');
        int die = rollD6();
        logD6(die);
        if (die >= 4) {
          logLine('>*The U.S.A. enters the war.*');
          doUsEntry();
        } else {
          logLine('>America remains neutral.');
        }
      }
    }
    if (checkChoiceAndClear(Choice.buildBlockadeRunners)) {
      final blockadeRunners = piecesInLocation(PieceType.blockadeRunner, Location.neutralPorts);
      final blockadeRunner = randPiece(blockadeRunners)!;
      logLine('### ${logPiece(blockadeRunner)} built.');
      spendReichsmarks(2);
      setPieceLocation(blockadeRunner, Location.blockadeRunners);
    }
    if (checkChoiceAndClear(Choice.buildSiegfriedLine)) {
      logLine('### ${logPiece(Piece.siegfriedLine)} build in ${logLocation(Location.belgium)}.');
      spendReichsmarks(2);
      setPieceLocation(Piece.siegfriedLine, Location.belgium);
    }
  }
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

void turnEndPhaseGermanBanking() {
  adjustLira(-lira);
  if (pieceLocation(Piece.railway) == Location.bulgaria && !turkeySurrendered && reichsmarks >= 1) {
      if (choicesEmpty()) {
        setPrompt('Send 1 RM to Turkey?');
        choiceChoosable(Choice.yes, true);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.yes)) {
        logLine("### Reichsmarks used to boost Turkey's economy.");
        spendReichsmarks(1);
        adjustLira(1);
      }
      clearChoices();
  }
  if (reichsmarks > 1) {
    adjustReichsmarks(1 - reichsmarks);
  }
}

void turnEndPhaseCancelSpecial() {
  setPieceLocation(Piece.specialEvent, Location.trayMarkers);
}

void turnEndPhaseMiracleOfTheMarne() {
  if (turn == 1 && !frontSurrendered(Location.france)) {
    logLine('>*Miracle of the Marne, France no longer in Danger.*');
    setPieceLocation(Piece.pinkFrance, Location.trayPink);
  }
}

void turnEndPhaseNavalReset() {
  for (final blockadeRunner in PieceType.blockadeRunner.pieces) {
    if (pieceLocation(blockadeRunner).isType(LocationType.sea)) {
      setPieceLocation(blockadeRunner, Location.blockadeRunners);
    }
  }
  for (final cruiser in PieceType.cruiser.pieces) {
    if (pieceLocation(cruiser).isType(LocationType.sea)) {
      setPieceLocation(cruiser, Location.britishCruisers);
    }
  }
  if (pieceLocation(Piece.highSeasFleet).isType(LocationType.sea)) {
    setPieceLocation(Piece.highSeasFleet, Location.germany);
  }
}

void turnEndPhaseArmisticeDay() {
  if (turn < 26) {
    return;
  }
  int vps = calculateVictoryPoints();
  logLine('### Armistice Day*');
  logLine('>VPs: $vps');
  GameResult result;
  if (vps >= 65) {
    result = GameResult.sixtyFive;
  } else if (vps >= 60) {
    result = GameResult.sixty;
  } else if (vps >= 50) {
    result = GameResult.fifty;
  } else if (vps >= 40) {
    result = GameResult.forty;
  } else if (vps >= 30) {
    result = GameResult.thirty;
  } else if (vps >= 20) {
    result = GameResult.twenty;
  } else {
    result = GameResult.belowTwenty;
  }
  throw GameOverException(result, vps);
}

void turnEndPhaseAdvanceTurn() {
  _state.turn += 1;
}

PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      turnStartPhaseBegin,
      turnStartPhaseChitDraw,
      turnStartPhaseDeployUnits,
      turnStartPhaseCalendarEvents,
      turnStartPhaseChitEvent,
      turnStartPhaseChitEventTripleOffensive,
      turnStartPhaseChitEventTripleOffensive,
      turnStartPhaseHundredDaysChitDraw,
      turnStartPhaseHundredDaysChitEvent,
      turnStartPhaseHundredDaysChitEventTripleOffensive,
      turnStartPhaseHundredDaysChitEventTripleOffensive,
      turnStartPhaseEnd,
      ententePowersAttackPhaseBegin,
      ententePowersAttackPhaseBelgium,
      ententePowersAttackPhaseFrance,
      ententePowersAttackPhaseLithuania,
      ententePowersAttackPhaseUkraine,
      ententePowersAttackPhaseItaly,
      ententePowersAttackPhaseSerbia,
      ententePowersAttackPhaseHundredDaysBelgium,
      ententePowersAttackPhaseHundredDaysFrance,
      ententePowersAttackPhaseHundredDaysLithuania,
      ententePowersAttackPhaseHundredDaysUkraine,
      ententePowersAttackPhaseHundredDaysItaly,
      ententePowersAttackPhaseHundredDaysSerbia,
      ententePowersAttackPhaseIrish,
      ententePowersAttackPhaseSenussi,
      ententePowersAttackPhaseDigTrenches,
      ententePowersAttackPhaseEnd,
      berlinerTageblattPhaseBegin,
      berlinerTageblattPhaseEvents,
      navalAirWarfarePhaseBegin,
      navalAirWarfarePhaseDeployBlockadeRunners,
      navalAirWarfarePhaseDeployCruisers,
      navalAirWarfarePhaseEconomicHaul,
      navalAirWarfarePhaseSinkBlockadeRunners,
      navalAirWarfarePhaseMajorNavalBattle,
      navalAirWarfarePhaseHindenLuden,
      navalAirWarfarePhaseControlOfTheSkies,
      navalAirWarfarePhaseGermanBombers,
      navalAirWarfarePhaseBritishBombers,
      navalAirWarfarePhaseZeppelinRaids,
      navalAirWarfarePhaseAirCombat,
      centralPowersAttackPhaseBegin,
      centralPowersAttackPhaseAttacks,
      centralPowersAttackPhaseEnd,
      nearEastPhaseBegin,
      nearEastPhaseBuildAskari,
      nearEastPhaseIndiansAttackAskari,
      nearEastPhaseEntenteDeployment,
      nearEastPhaseOttomanIncome,
      nearEastPhaseOttomanGroundCombat,
      industrialPhaseBegin,
      industrialPhaseActions,
      turnEndPhaseBegin,
      turnEndPhaseGermanBanking,
      turnEndPhaseCancelSpecial,
      turnEndPhaseMiracleOfTheMarne,
      turnEndPhaseNavalReset,
      turnEndPhaseArmisticeDay,
      turnEndPhaseAdvanceTurn,
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

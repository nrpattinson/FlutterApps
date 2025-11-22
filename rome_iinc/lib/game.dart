import 'dart:convert';
import 'dart:math';

import 'package:rome_iinc/db.dart';
import 'package:rome_iinc/random.dart';

enum Location {
  provinceCorsicaSardinia,
  provinceMediolanum,
  provinceNeapolis,
  provincePisae,
  provinceRavenna,
  provinceRhaetia,
  provinceRome,
  provinceSicilia,
  provinceSpoletium,
  provinceBritanniaI,
  provinceBritanniaII,
  provinceCaledonia,
  provinceHibernia,
  provinceValentia,
  provinceAlpes,
  provinceAquitaniaI,
  provinceAquitaniaII,
  provinceBelgica,
  provinceFrisia,
  provinceGermaniaI,
  provinceGermaniaII,
  provinceGermaniaIII,
  provinceLugdunensisI,
  provinceLugdunensisII,
  provinceNarbonensis,
  provinceSuevia,
  provinceBoiohaemia,
  provinceDalmatia,
  provinceNoricum,
  provincePannoniaI,
  provincePannoniaII,
  provinceQuadia,
  provinceSarmatia,
  provinceAchaea,
  provinceCreta,
  provinceDaciaI,
  provinceDaciaII,
  provinceDardania,
  provinceEpirus,
  provinceMacedonia,
  provinceMoesiaI,
  provinceBaetica,
  provinceBaleares,
  provinceCarthaginensis,
  provinceCeltiberia,
  provinceGallaecia,
  provinceLusitania,
  provinceMauretaniaII,
  provinceTarraconensis,
  provinceAfrica,
  provinceMauretaniaI,
  provinceNumidia,
  provinceTripolitania,
  provinceAsia,
  provinceBosporus,
  provinceCaria,
  provinceConstantinople,
  provinceGothiaI,
  provinceGothiaII,
  provinceLyciaPamphylia,
  provinceMoesiaII,
  provincePhrygia,
  provinceRhodope,
  provinceScythia,
  provinceAethiopia,
  provinceAlexandria,
  provinceArabiaI,
  provinceArabiaII,
  provinceArcadia,
  provinceAssyria,
  provinceBabylonia,
  provinceCyprus,
  provinceEuphratensis,
  provinceIsauria,
  provinceLibya,
  provinceMesopotamia,
  provincePalaestina,
  provincePhoenicia,
  provinceSyria,
  provinceThebais,
  provinceAlbania,
  provinceArmeniaI,
  provinceArmeniaII,
  provinceArmeniaIII,
  provinceArmeniaIV,
  provinceBithynia,
  provinceCappadocia,
  provinceCaucasia,
  provinceColchis,
  provinceIberia,
  provincePontus,
  homelandAlan,
  homelandArabian,
  homelandAvar,
  homelandBulgar,
  homelandBurgundian,
  homelandFrankish,
  homelandHunnic0,
  homelandHunnic1,
  homelandHunnic2,
  homelandMoorish,
  homelandNubian,
  homelandOstrogothic,
  homelandPersian,
  homelandPictish,
  homelandSarmatian,
  homelandSaxon,
  homelandScottish,
  homelandSlav,
  homelandSuevian,
  homelandVandal,
  homelandVisigothic,
  commandWesternEmperor,
  commandEasternEmperor,
  commandItalia,
  commandBritannia,
  commandGallia,
  commandPannonia,
  commandMoesia,
  commandHispania,
  commandAfrica,
  commandThracia,
  commandOriens,
  commandPontica,
  boxStatesmen,
  boxDynasties,
  boxBarracks,
  poolStatesmen,
  poolWars,
  trackWest0,
  trackWest1,
  trackWest2,
  trackWest3,
  trackWest4,
  trackWest5,
  trackWest6,
  trackWest7,
  trackWest8,
  trackWest9,
  trackWest10,
  trackWest11,
  trackWest12,
  trackWest13,
  trackWest14,
  trackWest15,
  trackWest16,
  trackWest17,
  trackWest18,
  trackWest19,
  trackWest20,
  trackWest21,
  trackWest22,
  trackWest23,
  trackWest24,
  trackWest25,
  trackEast0,
  trackEast1,
  trackEast2,
  trackEast3,
  trackEast4,
  trackEast5,
  trackEast6,
  trackEast7,
  trackEast8,
  trackEast9,
  trackEast10,
  trackEast11,
  trackEast12,
  trackEast13,
  trackEast14,
  trackEast15,
  trackEast16,
  trackEast17,
  trackEast18,
  trackEast19,
  trackEast20,
  trackEast21,
  trackEast22,
  trackEast23,
  trackEast24,
  trackEast25,
  flipped,
  offmap,
}

enum LocationType {
  land,
  province,
  provinceItalia,
  provinceBritannia,
  provinceGallia,
  provincePannonia,
  provinceMoesia,
  provinceAfrica,
  provinceHispania,
  provinceThracia,
  provinceOriens,
  provincePontica,
  homeland,
  space,
  command,
  empire,
  emperor,
  governorship,
  westernGovernorship,
  easternGovernorship,
  trackWest,
  trackEast,
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
    LocationType.land: [Location.provinceCorsicaSardinia, Location.homelandVisigothic],
    LocationType.province: [Location.provinceCorsicaSardinia, Location.provincePontus],
    LocationType.provinceItalia: [Location.provinceCorsicaSardinia, Location.provinceSpoletium],
    LocationType.provinceBritannia: [Location.provinceBritanniaI, Location.provinceValentia],
    LocationType.provinceGallia: [Location.provinceAlpes, Location.provinceSuevia],
    LocationType.provincePannonia: [Location.provinceBoiohaemia, Location.provinceSarmatia],
    LocationType.provinceMoesia: [Location.provinceAchaea, Location.provinceMoesiaI],
    LocationType.provinceHispania: [Location.provinceBaetica, Location.provinceTarraconensis],
    LocationType.provinceAfrica: [Location.provinceAfrica, Location.provinceTripolitania],
    LocationType.provinceThracia: [Location.provinceAsia, Location.provinceScythia],
    LocationType.provinceOriens: [Location.provinceAethiopia, Location.provinceThebais],
    LocationType.provincePontica: [Location.provinceAlbania, Location.provincePontus],
    LocationType.homeland: [Location.homelandAlan, Location.homelandVisigothic],
    LocationType.space: [Location.provinceCorsicaSardinia, Location.homelandVisigothic],
    LocationType.command: [Location.commandWesternEmperor, Location.commandPontica],
    LocationType.empire: [Location.commandWesternEmperor, Location.commandEasternEmperor],
    LocationType.emperor: [Location.commandWesternEmperor, Location.commandEasternEmperor],
    LocationType.governorship: [Location.commandItalia, Location.commandPontica],
    LocationType.westernGovernorship: [Location.commandItalia, Location.commandAfrica],
    LocationType.easternGovernorship: [Location.commandThracia, Location.commandPontica],
    LocationType.trackWest: [Location.trackWest0, Location.trackWest25],
    LocationType.trackEast: [Location.trackEast0, Location.trackEast25],
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

  String get desc {
    const locationNames = [
  'Corsica & Sardinia',
  'Mediolanum',
  'Neapolis',
  'Pisae',
  'Ravenna',
  'Rhaetia',
  'Rome',
  'Sicilia',
  'Spoletium',
  'Britannia Ⅰ',
  'Britannia Ⅱ',
  'Caledonia',
  'Hibernia',
  'Valentia',
  'Alpes',
  'Aquitania Ⅰ',
  'Aquitania Ⅱ',
  'Belgica',
  'Frisia',
  'Germania Ⅰ',
  'Germania Ⅱ',
  'Germania Ⅲ',
  'Lugdunensis Ⅰ',
  'Lugdunensis Ⅱ',
  'Narbonensis',
  'Suevia',
  'Boiohaemia',
  'Dalmatia',
  'Noricum',
  'Pannonia Ⅰ',
  'Pannonia Ⅱ',
  'Quadia',
  'Sarmatia',
  'Achaea',
  'Creta',
  'Dacia Ⅰ',
  'Dacia Ⅱ',
  'Dardania',
  'Epirus',
  'Macedonia',
  'MoesiaI',
  'Baetica',
  'Baleares',
  'Carthaginensis',
  'Celtiberia',
  'Gallaecia',
  'Lusitania',
  'Mauretania Ⅱ',
  'Tarraconensis',
  'Africa',
  'Mauretania Ⅰ',
  'Numidia',
  'Tripolitania',
  'Asia',
  'Bosporus',
  'Caria',
  'Constantinople',
  'Gothia Ⅰ',
  'Gothia Ⅱ',
  'Lycia & Pamphylia',
  'Moesia Ⅱ',
  'Phrygia',
  'Rhodope',
  'Scythia',
  'Aethiopia',
  'Alexandria',
  'Arabia Ⅰ',
  'Arabia Ⅱ',
  'Arcadia',
  'Assyria',
  'Babylonia',
  'Cyprus',
  'Euphratensis',
  'Isauria',
  'Libya',
  'Mesopotamia',
  'Palaestina',
  'Phoenicia',
  'Syria',
  'Thebais',
  'Albania',
  'Armenia Ⅰ',
  'Armenia Ⅱ',
  'Armenia Ⅲ',
  'Armenia Ⅳ',
  'Bithynia',
  'Cappadocia',
  'Caucasia',
  'Colchis',
  'Iberia',
  'Pontus',
  'Alan Homeland',
  'Arabian Homeland',
  'Avar Homeland',
  'Bulgar Homeland',
  'Burgundian Homeland',
  'Frankish Homeland',
  'Hun Western Homeland',
  'Hun Central Homeland',
  'Hun Eastern Homeland',
  'Moorish Homeland',
  'Nubian Homeland',
  'Ostrogothic Homeland',
  'Persian Homeland',
  'Pictish Homeland',
  'Sarmatian Homeland',
  'Saxon Homeland',
  'Scottish Homeland',
  'Slav Homeland',
  'Suevian Homeland',
  'Vandal Homeland',
  'Visigothic Homeland',
  'Western Emperor',
  'Eastern Emperor',
  'Italia',
  'Britannia',
  'Gallia',
  'Pannonia',
  'Moesia',
  'Hispania',
  'Africa',
  'Thracia',
  'Oriens',
  'Pontica',
  'Statesmen',
  'Dynasties',
  'Barracks',
  'Statesmen',
  'Wars',
  'Flipped',
  'Offmap',
    ];
    return locationNames[index];
  }
}

enum Piece {
  fort0,
  fort1,
  fort2,
  fort3,
  fort4,
  fort5,
  fort6,
  fort7,
  fort8,
  fort9,
  fort10,
  fort11,
  fort12,
  fort13,
  fort14,
  fort15,
  fort16,
  fort17,
  fort18,
  fort19,
  pseudoLegion0,
  pseudoLegion1,
  pseudoLegion2,
  pseudoLegion3,
  pseudoLegion4,
  pseudoLegion5,
  pseudoLegion6,
  pseudoLegion7,
  pseudoLegion8,
  pseudoLegion9,
  pseudoLegion10,
  pseudoLegion11,
  pseudoLegion12,
  pseudoLegion13,
  pseudoLegion14,
  pseudoLegion15,
  pseudoLegion16,
  pseudoLegion17,
  pseudoLegion18,
  pseudoLegion19,
  legion0,
  legion1,
  legion2,
  legion3,
  legion4,
  legion5,
  legion6,
  legion7,
  legion8,
  legion9,
  legion10,
  legion11,
  legion12,
  legion13,
  legion14,
  legion15,
  legion16,
  legion17,
  legion18,
  legion19,
  legionVeteran0,
  legionVeteran1,
  legionVeteran2,
  legionVeteran3,
  legionVeteran4,
  legionVeteran5,
  legionVeteran6,
  legionVeteran7,
  legionVeteran8,
  legionVeteran9,
  legionVeteran10,
  legionVeteran11,
  legionVeteran12,
  legionVeteran13,
  legionVeteran14,
  legionVeteran15,
  legionVeteran16,
  legionVeteran17,
  legionVeteran18,
  legionVeteran19,
  auxilia0,
  auxilia1,
  auxilia2,
  auxilia3,
  auxilia4,
  auxilia5,
  auxilia6,
  auxilia7,
  auxilia8,
  auxilia9,
  auxilia10,
  auxilia11,
  auxilia12,
  auxilia13,
  auxilia14,
  auxilia15,
  auxilia16,
  auxilia17,
  auxilia18,
  auxilia19,
  auxiliaVeteran0,
  auxiliaVeteran1,
  auxiliaVeteran2,
  auxiliaVeteran3,
  auxiliaVeteran4,
  auxiliaVeteran5,
  auxiliaVeteran6,
  auxiliaVeteran7,
  auxiliaVeteran8,
  auxiliaVeteran9,
  auxiliaVeteran10,
  auxiliaVeteran11,
  auxiliaVeteran12,
  auxiliaVeteran13,
  auxiliaVeteran14,
  auxiliaVeteran15,
  auxiliaVeteran16,
  auxiliaVeteran17,
  auxiliaVeteran18,
  auxiliaVeteran19,
  guard0,
  guard1,
  guard2,
  guard3,
  guard4,
  guard5,
  guardVeteran0,
  guardVeteran1,
  guardVeteran2,
  guardVeteran3,
  guardVeteran4,
  guardVeteran5,
  cavalry0,
  cavalry1,
  cavalry2,
  cavalry3,
  cavalry4,
  cavalry5,
  cavalryVeteran0,
  cavalryVeteran1,
  cavalryVeteran2,
  cavalryVeteran3,
  cavalryVeteran4,
  cavalryVeteran5,
  fleet0,
  fleet1,
  fleet2,
  fleet3,
  fleet4,
  fleet5,
  fleet6,
  fleet7,
  fleet8,
  fleet9,
  fleet10,
  fleet11,
  fleetVeteran0,
  fleetVeteran1,
  fleetVeteran2,
  fleetVeteran3,
  fleetVeteran4,
  fleetVeteran5,
  fleetVeteran6,
  fleetVeteran7,
  fleetVeteran8,
  fleetVeteran9,
  fleetVeteran10,
  fleetVeteran11,
  leaderAttila,
  leaderBayan,
  leaderChosroes,
  leaderClovis,
  leaderFritigern,
  leaderGaiseric,
  leaderShapur,
  leaderTotila,
  leaderStatesmanAlaric,
  leaderStatesmanGainas,
  leaderStatesmanTheodoric,
  leaderStatesmanZeno,
  warAlan9,
  warArabian5,
  warAvar15,
  warAvar13,
  warAvar11,
  warBulgar14,
  warBulgar12,
  warBurgundian11,
  warFrankish13,
  warFrankish11,
  warHunnic15,
  warHunnic14,
  warHunnic13,
  warIsaurian7,
  warMoorish7,
  warMoorish5,
  warNubian4,
  warOstrogothic13,
  warOstrogothic11,
  warPersian15,
  warPersian13,
  warPersian11,
  warPictish6,
  warPictish4,
  warSarmatian10,
  warSarmatian8,
  warSaxon6,
  warSaxon4,
  warScottish5,
  warSlav8,
  warSlav6,
  warSuevian13,
  warSuevian11,
  warSuevian9,
  warVandal91,
  warVandal93,
  warVandal8,
  warVandal7,
  warVisigothic14,
  warVisigothic12,
  warVisigothic10,
  statesmanAegidius,
  statesmanAetius,
  statesmanAlaric,
  statesmanAmbrose,
  statesmanAnastasius,
  statesmanAnthemius,
  statesmanArbogast,
  statesmanArcadius,
  statesmanArius,
  statesmanAspar,
  statesmanAuxerre,
  statesmanBasiliscus,
  statesmanBelisarius,
  statesmanBonus,
  statesmanCarausius,
  statesmanComentiolus,
  statesmanConstans,
  statesmanConstantineI,
  statesmanConstantineII,
  statesmanConstantiusI,
  statesmanConstantiusII,
  statesmanConstantiusIII,
  statesmanCrispus,
  statesmanDiocletian,
  statesmanEutropius,
  statesmanGainas,
  statesmanGalerius,
  statesmanGermanus,
  statesmanGratian,
  statesmanGregory,
  statesmanHeraclius,
  statesmanHonorius,
  statesmanJulian,
  statesmanJustinI,
  statesmanJustinII,
  statesmanJustinianI,
  statesmanLeoI,
  statesmanLiberius,
  statesmanLicinius,
  statesmanMagnentius,
  statesmanMajorian,
  statesmanMarcian,
  statesmanMaurice,
  statesmanMaxentius,
  statesmanMaximian,
  statesmanMaximinusII,
  statesmanMystacon,
  statesmanNarses,
  statesmanOdoacer,
  statesmanPetronius,
  statesmanPhocas,
  statesmanPriscus,
  statesmanRicimer,
  statesmanPopeLeo,
  statesmanSergius,
  statesmanStilicho,
  statesmanTheodora,
  statesmanTheodoric,
  statesmanTheodosius,
  statesmanTheodosiusI,
  statesmanTheodosiusII,
  statesmanTiberiusII,
  statesmanTroglita,
  statesmanValens,
  statesmanValentinianI,
  statesmanValentinianIII,
  statesmanZeno,
  dynastyConstantinian,
  dynastyTheodosian,
  dynastyValentinian,
  dynastyLeonid,
  dynastyJustinian,
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
  unit,
  landUnit,
  mobileUnit,
  mobileLandUnit,
  fort,
  legionaries,
  pseudoLegion,
  legion,
  legionOrdinary,
  legionVeteran,
  auxilia,
  auxiliaOrdinary,
  auxiliaVeteran,
  guard,
  guardOrdinary,
  guardVeteran,
  cavalry,
  cavalryOrdinary,
  cavalryVeteran,
  fleet,
  fleetOrdinary,
  fleetVeteran,
  leader,
  leaderLeader,
  leaderStatesman,
  war,
  barbarian,
  statesman,
  dynasty,
  statesmenPool,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.fort0, Piece.dynastyJustinian],
    PieceType.unit: [Piece.fort0, Piece.fleetVeteran11],
    PieceType.landUnit: [Piece.fort0, Piece.cavalryVeteran5],
    PieceType.mobileUnit: [Piece.pseudoLegion0, Piece.fleetVeteran11],
    PieceType.mobileLandUnit: [Piece.pseudoLegion0, Piece.cavalryVeteran5],
    PieceType.fort: [Piece.fort0, Piece.fort19],
    PieceType.legionaries: [Piece.pseudoLegion0, Piece.legionVeteran19],
    PieceType.pseudoLegion: [Piece.pseudoLegion0, Piece.pseudoLegion19],
    PieceType.legion: [Piece.legion0, Piece.legionVeteran19],
    PieceType.legionOrdinary: [Piece.legion0, Piece.legion19],
    PieceType.legionVeteran: [Piece.legionVeteran0, Piece.legionVeteran19],
    PieceType.auxilia: [Piece.auxilia0, Piece.auxiliaVeteran19],
    PieceType.auxiliaOrdinary: [Piece.auxilia0, Piece.auxilia19],
    PieceType.auxiliaVeteran: [Piece.auxiliaVeteran0, Piece.auxiliaVeteran19],
    PieceType.guard: [Piece.guard0, Piece.guardVeteran5],
    PieceType.guardOrdinary: [Piece.guard0, Piece.guard5],
    PieceType.guardVeteran: [Piece.guardVeteran0, Piece.guardVeteran5],
    PieceType.cavalry: [Piece.cavalry0, Piece.cavalryVeteran5],
    PieceType.cavalryOrdinary: [Piece.cavalry0, Piece.cavalry5],
    PieceType.cavalryVeteran: [Piece.cavalryVeteran0, Piece.cavalryVeteran5],
    PieceType.fleet: [Piece.fleet0, Piece.fleetVeteran11],
    PieceType.fleetOrdinary: [Piece.fleet0, Piece.fleet11],
    PieceType.fleetVeteran: [Piece.fleetVeteran0, Piece.fleetVeteran11],
    PieceType.leader: [Piece.leaderAttila, Piece.leaderStatesmanZeno],
    PieceType.leaderLeader: [Piece.leaderAttila, Piece.leaderTotila],
    PieceType.leaderStatesman: [Piece.leaderStatesmanAlaric, Piece.leaderStatesmanZeno],
    PieceType.war: [Piece.warAlan9, Piece.warVisigothic10],
    PieceType.barbarian: [Piece.leaderAttila, Piece.warVisigothic10],
    PieceType.statesman: [Piece.statesmanAegidius, Piece.statesmanZeno],
    PieceType.dynasty: [Piece.dynastyConstantinian, Piece.dynastyJustinian],
    PieceType.statesmenPool: [Piece.statesmanAegidius, Piece.dynastyJustinian],
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

  String get desc {
    const pieceNames = [
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Fort',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Pseudo Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Veteran Legion',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Veteran Auxilia',
      'Guard',
      'Guard',
      'Guard',
      'Guard',
      'Guard',
      'Guard',
      'Veteran Guard',
      'Veteran Guard',
      'Veteran Guard',
      'Veteran Guard',
      'Veteran Guard',
      'Veteran Guard',
      'Cavalry',
      'Cavalry',
      'Cavalry',
      'Cavalry',
      'Cavalry',
      'Cavalry',
      'Veteran Cavalry',
      'Veteran Cavalry',
      'Veteran Cavalry',
      'Veteran Cavalry',
      'Veteran Cavalry',
      'Veteran Cavalry',
      'Fleet',
      'Fleet',
      'Fleet',
      'Fleet',
      'Fleet',
      'Fleet',
      'Fleet',
      'Fleet',
      'Fleet',
      'Fleet',
      'Fleet',
      'Fleet',
      'Veteran Fleet',
      'Veteran Fleet',
      'Veteran Fleet',
      'Veteran Fleet',
      'Veteran Fleet',
      'Veteran Fleet',
      'Veteran Fleet',
      'Veteran Fleet',
      'Veteran Fleet',
      'Veteran Fleet',
      'Veteran Fleet',
      'Veteran Fleet',
      'Attila',
      'Bayan',
      'Chosroes',
      'Clovis',
      'Fritigern',
      'Gaiseric',
      'Shapur',
      'Totila',
      'Alaric',
      'Gainas',
      'Theodoric',
      'Zeno',
      '9/2 Alan War',
      '5/1 Arabian War',
      '15/4 Avar War',
      '13/4 Avar War',
      '11/4 Avar War',
      '14/4 Bulgar War',
      '12/4 Bulgar War',
      '11/1 Burgundian War',
      '13/2 Frankish War',
      '11/2 Frankish War',
      '15/5 Hunnic War',
      '14/5 Hunnic War',
      '13/5 Hunnic War',
      '7/2 Isaurian War',
      '7/1 Moorish War',
      '5/1 Moorish War',
      '4/1 Nubian War',
      '13/2 Ostrogothic War',
      '11/2 Ostrogothic War',
      '15/3 Persian War',
      '13/3 Persian War',
      '11/3 Persian War',
      '6/2 Pictish War',
      '4/2 Pictish War',
      '10/2 Sarmatian War',
      '8/2 Sarmatian War',
      '6/3 Saxon War',
      '4/3 Saxon War',
      '5/2 Scottish War',
      '8/1 Slav War',
      '6/1 Slav War',
      '13/1 Suevian War',
      '11/1 Suevian War',
      '9/1 Suevian War',
      '9/1 Vandal War',
      '9/3 Vandal War',
      '8/4 Vandal War',
      '7/5 Vandal War',
      '14/2 Visigothic War',
      '12/2 Visigothic War',
      '10/2 Visigothic War',
      'Aegidius',
      'Aetius',
      'Alaric',
      'Ambrose',
      'Anastasius',
      'Anthemius',
      'Arbogast',
      'Arcadius',
      'Arius',
      'Aspar',
      'Auxerre',
      'Basiliscus',
      'Belisarius',
      'Bonus',
      'Carausius',
      'Comentiolus',
      'Constans',
      'Constantine Ⅰ',
      'Constantine Ⅱ',
      'Constantius Ⅰ',
      'Constantius Ⅱ',
      'Constantius Ⅲ',
      'Crispus',
      'Diocletian',
      'Eutropius',
      'Gainas',
      'Galerius',
      'Germanus',
      'Gratian',
      'Gregory',
      'Heraclius',
      'Honorius',
      'Julian',
      'Justin Ⅰ',
      'Justin Ⅱ',
      'Justinian Ⅰ',
      'Leo I',
      'Liberius',
      'Licinius',
      'Magnentius',
      'Majorian',
      'Marcian',
      'Maurice',
      'Maxentius',
      'Maximian',
      'Maximinus Ⅱ',
      'Mystacon',
      'Narses',
      'Odoacer',
      'Petronius',
      'Phocas',
      'Priscus',
      'Ricimer',
      'PopeLeo',
      'Sergius',
      'Stilicho',
      'Theodora',
      'Theodoric',
      'Theodosius',
      'Theodosius Ⅰ',
      'Theodosius Ⅱ',
      'Tiberius Ⅱ',
      'Troglita',
      'Valens',
      'Valentinian Ⅰ',
      'Valentinian Ⅲ',
      'Zeno',
      'Constantinian Dynasty',
      'Theodosian Dynasty',
      'Valentinian Dynasty',
      'Leonid Dynasty',
      'Justinian Dynasty',
    ];
    return pieceNames[index];
  }
}

enum Enemy {
  alans,
  arabs,
  avars,
  bulgars,
  burgundians,
  franks,
  huns,
  isaurians,
  moors,
  nubians,
  ostrogoths,
  persians,
  picts,
  sarmatians,
  saxons,
  scots,
  slavs,
  suevi,
  vandals,
  visigoths,
}

extension EnemyExtension on Enemy {
  String get name {
    const enemyNames = {
      Enemy.alans: 'Alans',
      Enemy.arabs: 'Arabs',
      Enemy.avars: 'Avars',
      Enemy.bulgars: 'Bulgars',
      Enemy.burgundians: 'Burgundians',
      Enemy.franks: 'Franks',
      Enemy.huns: 'Huns',
      Enemy.isaurians: 'Isaurians',
      Enemy.moors: 'Moors',
      Enemy.nubians: 'Nubians',
      Enemy.ostrogoths: 'Ostrogoths',
      Enemy.persians: 'Persians',
      Enemy.picts: 'Picts',
      Enemy.sarmatians: 'Sarmatians',
      Enemy.saxons: 'Saxons',
      Enemy.scots: 'Scots',
      Enemy.slavs: 'Slavs',
      Enemy.suevi: 'Suevi',
      Enemy.vandals: 'Vandals',
      Enemy.visigoths: 'Visigoths',
    };
    return enemyNames[this]!;
  }

  List<Location> get homelands {
    const enemyHomelands = {
      Enemy.alans: [Location.homelandAlan],
      Enemy.arabs: [Location.homelandArabian],
      Enemy.avars: [Location.homelandAvar],
      Enemy.bulgars: [Location.homelandBulgar],
      Enemy.burgundians: [Location.homelandBurgundian],
      Enemy.franks: [Location.homelandFrankish],
      Enemy.huns: [Location.homelandHunnic0, Location.homelandHunnic1, Location.homelandHunnic2],
      Enemy.isaurians: [Location.provinceIsauria],
      Enemy.moors: [Location.homelandMoorish],
      Enemy.nubians: [Location.homelandNubian],
      Enemy.ostrogoths: [Location.homelandOstrogothic],
      Enemy.persians: [Location.homelandPersian],
      Enemy.picts: [Location.homelandPictish],
      Enemy.sarmatians: [Location.homelandSarmatian],
      Enemy.saxons: [Location.homelandSaxon],
      Enemy.scots: [Location.homelandScottish],
      Enemy.slavs: [Location.homelandSlav],
      Enemy.suevi: [Location.homelandSuevian],
      Enemy.vandals: [Location.homelandVandal],
      Enemy.visigoths: [Location.homelandVisigothic],
    };
    return enemyHomelands[this]!;
  }

  bool get isFoederati {
    const foederatiEnemies = [
      Enemy.franks,
      Enemy.ostrogoths,
      Enemy.suevi,
      Enemy.vandals,
      Enemy.visigoths,
    ];
    return foederatiEnemies.contains(this);
  }

  ProvinceStatus? get foederatiStatus {
    const enemyStatuses = {
      Enemy.franks: ProvinceStatus.foederatiFrankish,
      Enemy.ostrogoths: ProvinceStatus.foederatiOstrogothic,
      Enemy.suevi: ProvinceStatus.foederatiSuevian,
      Enemy.vandals: ProvinceStatus.foederatiVandal,
      Enemy.visigoths: ProvinceStatus.foederatiVisigothic,
    };
    return enemyStatuses[this];
  }

  static List<Enemy> get allFoederati {
    return [
      Enemy.franks,
      Enemy.ostrogoths,
      Enemy.suevi,
      Enemy.vandals,
      Enemy.visigoths,
    ];
  }
}


enum ProvinceStatus {
  barbarian,
  foederatiFrankish,
  foederatiOstrogothic,
  foederatiSuevian,
  foederatiVandal,
  foederatiVisigothic,
  allied,
  insurgent,
  roman,
}

extension ProvinceStatusExtension on ProvinceStatus {
  Enemy? get foederati {
    const enemies = {
      ProvinceStatus.foederatiFrankish: Enemy.franks,
      ProvinceStatus.foederatiOstrogothic: Enemy.ostrogoths,
      ProvinceStatus.foederatiSuevian: Enemy.suevi,
      ProvinceStatus.foederatiVandal: Enemy.vandals,
      ProvinceStatus.foederatiVisigothic: Enemy.visigoths,
    };
    return enemies[this];
  }
}

List<ProvinceStatus> provinceStatusListFromIndices(List<int> indices) {
  final statuses = <ProvinceStatus>[];
  for (final index in indices) {
    statuses.add(ProvinceStatus.values[index]);
  }
  return statuses;
}

List<int> provinceStatusListToIndices(List<ProvinceStatus> statuses) {
  final indices = <int>[];
  for (final status in statuses) {
    indices.add(status.index);
  }
  return indices;
}

enum EventType {
  assassin,
  bagaudae,
  bodyguard,
  conspiracy,
  convert,
  diplomat,
  foederati,
  heresy,
  hippodrome,
  inflation,
  migration,
  mutiny,
  omens,
  orthodoxy,
  papacy,
  persecution,
  plague,
  usurper,
}

enum Ability {
  assassin,
  conquest,
  convert,
  diplomat,
  event,
  leaderIsaurian,
  leaderOstrogothic,
  leaderVisigothic,
  persecution,
  prestige,
  stalemate,
  veteran,
  warAvar,
  warFrankish,
  warHunnic,
  warMoorish,
  warOstrogothic,
  warPersian,
  warPictish,
  warSarmatian,
  warSaxon,
  warSlav,
  warSuevian,
  warVisigothic,
}

extension AbilityExtension on Ability {
  Enemy? get warEnemy {
    const enemies = {
      Ability.warAvar: Enemy.avars,
      Ability.warFrankish: Enemy.franks,
      Ability.warHunnic: Enemy.huns,
      Ability.warMoorish: Enemy.moors,
      Ability.warOstrogothic: Enemy.ostrogoths,
      Ability.warPersian: Enemy.persians,
      Ability.warPictish: Enemy.picts,
      Ability.warSarmatian: Enemy.sarmatians,
      Ability.warSaxon: Enemy.saxons,
      Ability.warSlav: Enemy.slavs,
      Ability.warSuevian: Enemy.suevi,
      Ability.warVisigothic: Enemy.visigoths,
    };
    return enemies[this];
  }
}

enum ConnectionType {
  road,
  desert,
  mountain,
  river,
  sea,
}

enum Scenario {
  from286CeTo363Ce,
  from363CeTo425Ce,
  from425CeTo497Ce,
  from497CeTo565Ce,
  from565CeTo629Ce,
  from286CeTo425Ce,
  from363CeTo497Ce,
  from425CeTo565Ce,
  from497CeTo629Ce,
  from286CeTo497Ce,
  from363CeTo565Ce,
  from425CeTo629Ce,
  from286CeTo565Ce,
  from363CeTo629Ce,
  from286CeTo629Ce,
}

extension ScenarioExtension on Scenario {
  String get desc {
    const scenarioDescs = {
      Scenario.from286CeTo363Ce: '286 CE – 363 CE',
      Scenario.from363CeTo425Ce: '363 CE – 425 CE',
      Scenario.from425CeTo497Ce: '425 CE – 497 CE',
      Scenario.from497CeTo565Ce: '497 CE – 565 CE',
      Scenario.from565CeTo629Ce: '565 CE – 629 CE',
      Scenario.from286CeTo425Ce: '286 CE – 425 CE',
      Scenario.from363CeTo497Ce: '363 CE – 497 CE',
      Scenario.from425CeTo565Ce: '425 CE – 565 CE',
      Scenario.from497CeTo629Ce: '497 CE – 629 CE',
      Scenario.from286CeTo497Ce: '286 CE – 497 CE',
      Scenario.from363CeTo565Ce: '363 CE – 565 CE',
      Scenario.from425CeTo629Ce: '425 CE – 629 CE',
      Scenario.from286CeTo565Ce: '286 CE – 565 CE',
      Scenario.from363CeTo629Ce: '363 CE – 629 CE',
      Scenario.from286CeTo629Ce: '286 CE – 629 CE',
    };
    return scenarioDescs[this]!;
  }

  String get longDesc {
    const scenarioDescs = {
      Scenario.from286CeTo363Ce: '286 CE to 363 CE (10 Turns)',
      Scenario.from363CeTo425Ce: '363 CE to 425 CE (10 Turns)',
      Scenario.from425CeTo497Ce: '425 CE to 497 CE (10 Turns)',
      Scenario.from497CeTo565Ce: '497 CE to 565 CE (10 Turns)',
      Scenario.from565CeTo629Ce: '565 CE to 629 CE (10 Turns)',
      Scenario.from286CeTo425Ce: '286 CE to 425 CE (20 Turns)',
      Scenario.from363CeTo497Ce: '363 CE to 497 CE (20 Turns)',
      Scenario.from425CeTo565Ce: '425 CE to 565 CE (20 Turns)',
      Scenario.from497CeTo629Ce: '497 CE to 629 CE (20 Turns)',
      Scenario.from286CeTo497Ce: '286 CE to 497 CE (30 Turns)',
      Scenario.from363CeTo565Ce: '363 CE to 565 CE (30 Turns)',
      Scenario.from425CeTo629Ce: '425 CE to 629 CE (30 Turns)',
      Scenario.from286CeTo565Ce: '286 CE to 565 CE (40 Turns)',
      Scenario.from363CeTo629Ce: '363 CE to 629 CE (40 Turns)',
      Scenario.from286CeTo629Ce: '286 CE to 629 CE (50 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

const warData = {
  Piece.warAlan9: (Enemy.alans, 9, 0, 2),
  Piece.warArabian5: (Enemy.arabs, 5, 1, 0),
  Piece.warAvar15: (Enemy.avars, 15, 0, 4),
  Piece.warAvar13: (Enemy.avars, 13, 0, 4),
  Piece.warAvar11: (Enemy.avars, 11, 0, 4),
  Piece.warBulgar14: (Enemy.bulgars, 14, 0, 4),
  Piece.warBulgar12: (Enemy.bulgars, 12, 0, 4),
  Piece.warBurgundian11: (Enemy.burgundians, 11, 1, 0),
  Piece.warFrankish13: (Enemy.franks, 13, 2, 0),
  Piece.warFrankish11: (Enemy.franks, 11, 2, 0),
  Piece.warHunnic15: (Enemy.huns, 15, 0, 5),
  Piece.warHunnic14: (Enemy.huns, 14, 0, 5),
  Piece.warHunnic13: (Enemy.huns, 13, 0, 5),
  Piece.warIsaurian7: (Enemy.isaurians, 7, 2, 0),
  Piece.warMoorish7: (Enemy.moors, 7, 1, 0),
  Piece.warMoorish5: (Enemy.moors, 5, 1, 0),
  Piece.warNubian4: (Enemy.nubians, 4, 1, 0),
  Piece.warOstrogothic13: (Enemy.ostrogoths, 13, 2, 0),
  Piece.warOstrogothic11: (Enemy.ostrogoths, 11, 2, 0),
  Piece.warPersian15: (Enemy.persians, 15, 0, 3),
  Piece.warPersian13: (Enemy.persians, 13, 0, 3),
  Piece.warPersian11: (Enemy.persians, 11, 0, 3),
  Piece.warPictish6: (Enemy.picts, 6, 2, 0),
  Piece.warPictish4: (Enemy.picts, 4, 2, 0),
  Piece.warSarmatian10: (Enemy.sarmatians, 10, 0, 2),
  Piece.warSarmatian8: (Enemy.sarmatians, 8, 0, 2),
  Piece.warSaxon6: (Enemy.saxons, 6, 3, 0),
  Piece.warSaxon4: (Enemy.saxons, 4, 3, 0),
  Piece.warScottish5: (Enemy.scots, 5, 2, 0),
  Piece.warSlav8: (Enemy.slavs, 8, 1, 0),
  Piece.warSlav6: (Enemy.slavs, 6, 1, 0),
  Piece.warSuevian13: (Enemy.suevi, 13, 1, 0),
  Piece.warSuevian11: (Enemy.suevi, 11, 1, 0),
  Piece.warSuevian9: (Enemy.suevi, 9, 1, 0),
  Piece.warVandal91: (Enemy.vandals, 9, 1, 0),
  Piece.warVandal93: (Enemy.vandals, 9, 3, 0),
  Piece.warVandal8: (Enemy.vandals, 8, 4, 0),
  Piece.warVandal7: (Enemy.vandals, 7, 5, 0),
  Piece.warVisigothic14: (Enemy.visigoths, 14, 2, 0),
  Piece.warVisigothic12: (Enemy.visigoths, 12, 2, 0),
  Piece.warVisigothic10: (Enemy.visigoths, 10, 2, 0),
};

const leaderData = {
  Piece.leaderAttila: (Enemy.huns, 5, 4),
  Piece.leaderBayan: (Enemy.avars, 4, 4),
  Piece.leaderChosroes: (Enemy.persians, 5, 3),
  Piece.leaderClovis: (Enemy.franks, 4, 3),
  Piece.leaderFritigern: (Enemy.visigoths, 5, 2),
  Piece.leaderGaiseric: (Enemy.vandals, 5, 5),
  Piece.leaderShapur: (Enemy.persians, 4, 2),
  Piece.leaderTotila: (Enemy.ostrogoths, 3, 4),
  Piece.leaderStatesmanAlaric: (Enemy.visigoths, 3, 5),
  Piece.leaderStatesmanGainas: (Enemy.ostrogoths, 3, 4),
  Piece.leaderStatesmanTheodoric: (Enemy.ostrogoths, 4, 4),
  Piece.leaderStatesmanZeno: (Enemy.isaurians, 2, 3),
};

const statesmanData = {
  Piece.statesmanAegidius: (Ability.warVisigothic, 4, 2, 4, 3, false, false),
  Piece.statesmanAetius: (Ability.warHunnic, 5, 4, 3, 3, false, false),
  Piece.statesmanAlaric: (Ability.leaderVisigothic, 3, 1, 2, 5, false, true),
  Piece.statesmanAmbrose: (Ability.convert, 1, 4, 5, 2, false, true),
  Piece.statesmanAnastasius: (Ability.prestige, 1, 5, 2, 2, true, false),
  Piece.statesmanAnthemius: (Ability.diplomat, 2, 4, 3, 2, false, false),
  Piece.statesmanArbogast: (Ability.warFrankish, 3, 2, 1, 4, false, true),
  Piece.statesmanArcadius: (Ability.prestige, 1, 2, 4, 2, true, false),
  Piece.statesmanArius: (Ability.convert, 1, 3, 2, 1, false, true),
  Piece.statesmanAspar: (Ability.diplomat, 3, 4, 2, 3, false, true),
  Piece.statesmanAuxerre: (Ability.warPictish, 2, 3, 5, 2, false, true),
  Piece.statesmanBasiliscus: (Ability.event, 2, 2, 3, 3, true, false),
  Piece.statesmanBelisarius: (Ability.conquest, 5, 4, 3, 2, false, false),
  Piece.statesmanBonus: (Ability.stalemate, 3, 3, 3, 2, false, false),
  Piece.statesmanCarausius: (Ability.warSaxon, 4, 2, 1, 3, false, false),
  Piece.statesmanComentiolus: (Ability.warSlav, 3, 3, 3, 3, false, false),
  Piece.statesmanConstans: (Ability.warSarmatian, 3, 3, 4, 4, true, false),
  Piece.statesmanConstantineI: (Ability.veteran, 5, 5, 3, 3, true, false),
  Piece.statesmanConstantineII: (Ability.event, 3, 2, 4, 4, true, false),
  Piece.statesmanConstantiusI: (Ability.warFrankish, 4, 4, 2, 2, true, false),
  Piece.statesmanConstantiusII: (Ability.stalemate, 3, 4, 3, 4, true, false),
  Piece.statesmanConstantiusIII: (Ability.warVisigothic, 4, 3, 4, 4, false, false),
  Piece.statesmanCrispus: (Ability.warFrankish, 3, 3, 2, 2, true, false),
  Piece.statesmanDiocletian: (Ability.persecution, 2, 5, 1, 3, false, false),
  Piece.statesmanEutropius: (Ability.warHunnic, 3, 2, 3, 3, false, true),
  Piece.statesmanGainas: (Ability.leaderOstrogothic, 3, 1, 2, 4, false, true),
  Piece.statesmanGalerius: (Ability.warPersian, 4, 3, 1, 4, false, false),
  Piece.statesmanGermanus: (Ability.veteran, 3, 3, 3, 1, true, false),
  Piece.statesmanGratian: (Ability.warSarmatian, 3, 3, 4, 2, true, false),
  Piece.statesmanGregory: (Ability.convert, 1, 4, 5, 1, false, true),
  Piece.statesmanHeraclius: (Ability.event, 3, 4, 3, 3, false, false),
  Piece.statesmanHonorius: (Ability.assassin, 1, 1, 4, 4, true, false),
  Piece.statesmanJulian: (Ability.warSuevian, 3, 5, 1, 2, true, false),
  Piece.statesmanJustinI: (Ability.convert, 2, 2, 4, 3, true, false),
  Piece.statesmanJustinII: (Ability.event, 1, 3, 3, 4, true, false),
  Piece.statesmanJustinianI: (Ability.conquest, 1, 5, 3, 3, true, false),
  Piece.statesmanLeoI: (Ability.diplomat, 2, 4, 4, 4, true, false),
  Piece.statesmanLiberius: (Ability.warVisigothic, 3, 3, 4, 3, false, false),
  Piece.statesmanLicinius: (Ability.event, 3, 3, 1, 3, false, false),
  Piece.statesmanMagnentius: (Ability.assassin, 2, 3, 2, 4, false, false),
  Piece.statesmanMajorian: (Ability.conquest, 4, 4, 3, 2, false, false),
  Piece.statesmanMarcian: (Ability.prestige, 2, 4, 4, 2, true, false),
  Piece.statesmanMaurice: (Ability.veteran, 4, 3, 3, 3, true, false),
  Piece.statesmanMaxentius: (Ability.prestige, 3, 3, 1, 2, false, false),
  Piece.statesmanMaximian: (Ability.warMoorish, 3, 3, 1, 4, false, false),
  Piece.statesmanMaximinusII: (Ability.persecution, 2, 3, 1, 4, false, false),
  Piece.statesmanMystacon: (Ability.warPersian, 3, 2, 3, 2, false, false),
  Piece.statesmanNarses: (Ability.warOstrogothic, 4, 4, 4, 3, false, true),
  Piece.statesmanOdoacer: (Ability.event, 3, 2, 2, 3, false, true),
  Piece.statesmanPetronius: (Ability.assassin, 1, 4, 4, 4, false, false),
  Piece.statesmanPhocas: (Ability.persecution, 2, 2, 4, 5, false, false),
  Piece.statesmanPopeLeo: (Ability.convert, 1, 3, 5, 2, false, true),
  Piece.statesmanPriscus: (Ability.warAvar, 4, 2, 3, 3, false, false),
  Piece.statesmanRicimer: (Ability.assassin, 4, 2, 2, 5, false, true),
  Piece.statesmanSergius: (Ability.diplomat, 1, 4, 4, 2, false, true),
  Piece.statesmanStilicho: (Ability.stalemate, 4, 3, 4, 3, false, true),
  Piece.statesmanTheodora: (Ability.diplomat, 1, 4, 2, 4, true, false),
  Piece.statesmanTheodoric: (Ability.leaderOstrogothic, 4, 1, 2, 4, false, true),
  Piece.statesmanTheodosius: (Ability.veteran, 4, 3, 4, 2, true, false),
  Piece.statesmanTheodosiusI: (Ability.persecution, 4, 4, 4, 4, true, false),
  Piece.statesmanTheodosiusII: (Ability.prestige, 1, 2, 3, 2, true, false),
  Piece.statesmanTiberiusII: (Ability.prestige, 2, 4, 3, 2, true, false),
  Piece.statesmanTroglita: (Ability.warMoorish, 3, 4, 3, 2, false, false),
  Piece.statesmanValens: (Ability.persecution, 2, 4, 3, 4, true, false),
  Piece.statesmanValentinianI: (Ability.warSuevian, 4, 4, 3, 4, true, false),
  Piece.statesmanValentinianIII: (Ability.event, 1, 2, 3, 3, true, false),
  Piece.statesmanZeno: (Ability.leaderIsaurian, 2, 4, 3, 3, true, false),
};

const commandData = {
  Location.commandWesternEmperor: (2, 2, 2, 2),
  Location.commandEasternEmperor: (2, 2, 2, 2),
  Location.commandItalia: (1, 2, 3, 2),
  Location.commandBritannia: (2, 2, 1, 3),
  Location.commandGallia: (3, 2, 1, 2),
  Location.commandPannonia: (3, 1, 1, 3),
  Location.commandMoesia: (2, 1, 3, 2),
  Location.commandHispania: (1, 2, 2, 3),
  Location.commandAfrica: (2, 1, 2, 3),
  Location.commandThracia: (2, 2, 3, 1),
  Location.commandOriens: (1, 3, 2, 2),
  Location.commandPontica: (2, 3, 2, 1),
};

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.offmap);
  List<bool> _empireViceroys = List<bool>.filled(LocationType.emperor.count, false);
  List<bool> _empireFallens = List<bool>.filled(LocationType.emperor.count, false);
	List<Location> _governorshipAllegiances = List<Location>.filled(LocationType.governorship.count, Location.commandEasternEmperor);
	List<bool> _commandLoyals = List<bool>.filled(LocationType.command.count, true);
	List<ProvinceStatus> _provinceStatuses = List<ProvinceStatus>.filled(LocationType.province.count, ProvinceStatus.roman);
  List<int> _eventTypeCounts = List<int>.filled(EventType.values.length, 0);
	List<int?> _leaderAges = List<int?>.filled(PieceType.leader.count, null);
	List<int?> _statesmanAges = List<int?>.filled(PieceType.statesman.count, null);
	List<int?> _commanderAges = List<int?>.filled(LocationType.command.count, null);
  List<Piece> _resurrectedBarbarians = <Piece>[];
  int _turn = 0;
  List<int> _gold = List<int>.filled(2, 0);
  List<int>  _prestige = List<int>.filled(2, 0);
  List<int> _unrest = List<int>.filled(2, 0);

  GameState() {
    for (final governorship in LocationType.governorship.locations) {
      _governorshipAllegiances[governorship.index - LocationType.governorship.firstIndex] = governorship;
    }
  }

  GameState.fromJson(Map<String, dynamic> json)
    : _turn = json['turn'] as int,
      _gold = List<int>.from(json['gold']),
      _prestige = List<int>.from(json['prestige']),
      _unrest = List<int>.from(json['unrest']),
      _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations'])),
      _empireViceroys = List<bool>.from(json['empireViceroys']),
      _empireFallens = List<bool>.from(json['empireFallens']),
      _governorshipAllegiances = locationListFromIndices(List<int>.from(json['governorshipAllegiances'])),
      _commandLoyals = List<bool>.from(json['commandLoyals']),
      _provinceStatuses = provinceStatusListFromIndices(List<int>.from(json['provinceStatuses'])),
      _eventTypeCounts = List<int>.from(json['eventTypeCounts']),
      _leaderAges = List<int?>.from(json['leaderAges']),
      _statesmanAges = List<int?>.from(json['statesmanAges']),
      _commanderAges = List<int?>.from(json['commanderAges']),
      _resurrectedBarbarians = pieceListFromIndices(List<int>.from(json['resurrectedBarbarians']));

  Map<String, dynamic> toJson() => {
    'turn': _turn,
    'gold': _gold,
    'prestige': _prestige,
    'unrest': _unrest,
    'pieceLocations': locationListToIndices(_pieceLocations),
    'empireViceroys': _empireViceroys,
    'empireFallens': _empireFallens,
    'governorshipAllegiances': locationListToIndices(_governorshipAllegiances),
    'commandLoyals': _commandLoyals,
    'provinceStatuses': provinceStatusListToIndices(_provinceStatuses),
    'eventTypeCounts': _eventTypeCounts,
    'leaderAges': _leaderAges,
    'statesmanAges': _statesmanAges,
    'commanderAges': _commanderAges,
    'resurrectedBarbarians': pieceListToIndices(_resurrectedBarbarians),
  };

  static String provinceStatusName(ProvinceStatus status) {
    const statusNames = {
      ProvinceStatus.barbarian: 'Barbarian',
      ProvinceStatus.foederatiFrankish: 'Frankish Foederati',
      ProvinceStatus.foederatiOstrogothic: 'Ostrogothic Foederati',
      ProvinceStatus.foederatiSuevian: 'Suevian Foederati',
      ProvinceStatus.foederatiVandal: 'Vandal Foederati',
      ProvinceStatus.foederatiVisigothic: 'Visigothic Foederati',
      ProvinceStatus.allied: 'Allied',
      ProvinceStatus.insurgent: 'Insurgent',
      ProvinceStatus.roman: 'Roman',
    };
    return statusNames[status]!;
  }

  ProvinceStatus provinceStatus(Location province) {
    return _provinceStatuses[province.index - LocationType.province.firstIndex];
  }

  void setProvinceStatus(Location province, ProvinceStatus status) {
    _provinceStatuses[province.index - LocationType.province.firstIndex] = status;
  }

  bool spaceFoederati(Location space) {
    if (!space.isType(LocationType.province)) {
      return false;
    }
    switch (provinceStatus(space)) {
    case ProvinceStatus.barbarian:
      return false;
    case  ProvinceStatus.foederatiFrankish:
    case  ProvinceStatus.foederatiOstrogothic:
    case  ProvinceStatus.foederatiSuevian:
    case  ProvinceStatus.foederatiVandal:
    case  ProvinceStatus.foederatiVisigothic:
      return true;
    case ProvinceStatus.allied:
    case ProvinceStatus.insurgent:
    case ProvinceStatus.roman:
      return false;
    }
  }

  bool spaceFoederatiOrBetter(Location space) {
    if (!space.isType(LocationType.province)) {
      return false;
    }
    switch (provinceStatus(space)) {
    case ProvinceStatus.barbarian:
      return false;
    case  ProvinceStatus.foederatiFrankish:
    case  ProvinceStatus.foederatiOstrogothic:
    case  ProvinceStatus.foederatiSuevian:
    case  ProvinceStatus.foederatiVandal:
    case  ProvinceStatus.foederatiVisigothic:
    case ProvinceStatus.allied:
    case ProvinceStatus.insurgent:
    case ProvinceStatus.roman:
      return true;
    }
  }

  bool spaceNonMatchingFoederatiOrBetter(Location space, Piece war) {
    if (!space.isType(LocationType.province)) {
      return false;
    }
    final enemy = warEnemy(war);
    switch (provinceStatus(space)) {
    case ProvinceStatus.barbarian:
      return false;
    case  ProvinceStatus.foederatiFrankish:
      return enemy != Enemy.franks;
    case  ProvinceStatus.foederatiOstrogothic:
      return enemy != Enemy.ostrogoths;
    case  ProvinceStatus.foederatiSuevian:
      return enemy != Enemy.suevi;
    case  ProvinceStatus.foederatiVandal:
      return enemy != Enemy.vandals;
    case  ProvinceStatus.foederatiVisigothic:
      return enemy != Enemy.visigoths;
    case ProvinceStatus.allied:
    case ProvinceStatus.insurgent:
    case ProvinceStatus.roman:
      return true;
    }
  }

  bool spaceAlliedOrBetter(Location space) {
    if (!space.isType(LocationType.province)) {
      return false;
    }
    switch (provinceStatus(space)) {
    case ProvinceStatus.barbarian:
    case  ProvinceStatus.foederatiFrankish:
    case  ProvinceStatus.foederatiOstrogothic:
    case  ProvinceStatus.foederatiSuevian:
    case  ProvinceStatus.foederatiVandal:
    case  ProvinceStatus.foederatiVisigothic:
      return false;
    case ProvinceStatus.allied:
    case ProvinceStatus.insurgent:
    case ProvinceStatus.roman:
      return true;
    }
  }

  bool spaceInsurgentOrBetter(Location space) {
    if (!space.isType(LocationType.province)) {
      return false;
    }
    switch (provinceStatus(space)) {
    case ProvinceStatus.barbarian:
    case  ProvinceStatus.foederatiFrankish:
    case  ProvinceStatus.foederatiOstrogothic:
    case  ProvinceStatus.foederatiSuevian:
    case  ProvinceStatus.foederatiVandal:
    case  ProvinceStatus.foederatiVisigothic:
    case ProvinceStatus.allied:
      return false;
    case ProvinceStatus.insurgent:
    case ProvinceStatus.roman:
      return true;
    }
  }

  bool spaceCanBeAnnexed(Location space, List<Enemy> foederati) {
    if (!space.isType(LocationType.province)) {
      return false;
    }
    final status = provinceStatus(space);
    if (status == ProvinceStatus.insurgent || status == ProvinceStatus.roman) {
      return false;
    }
    if (piecesInLocationCount(PieceType.war, space) > 0) {
      return false;
    }
    if (spaceHasConnectionToAlliedOrBetterProvince(space)) {
      return true;
    }
    if (status == ProvinceStatus.barbarian && spaceHasConnectionToFoederatiProvince(space, foederati)) {
      return true;
    }
    return false;
  }

  int provinceRevenue(Location province) {
    const provinceRevenues = {
      Location.provinceCorsicaSardinia: 3,
      Location.provinceMediolanum: 5,
      Location.provinceNeapolis: 4,
      Location.provincePisae: 4,
      Location.provinceRavenna: 5,
      Location.provinceRhaetia: 2,
      Location.provinceRome: 5,
      Location.provinceSicilia: 4,
      Location.provinceSpoletium: 3,
      Location.provinceBritanniaI: 4,
      Location.provinceBritanniaII: 2,
      Location.provinceCaledonia: 1,
      Location.provinceHibernia: 1,
      Location.provinceValentia: 2,
      Location.provinceAlpes: 2,
      Location.provinceAquitaniaI: 2,
      Location.provinceAquitaniaII: 2,
      Location.provinceBelgica: 3,
      Location.provinceFrisia: 1,
      Location.provinceGermaniaI: 3,
      Location.provinceGermaniaII: 2,
      Location.provinceGermaniaIII: 1,
      Location.provinceLugdunensisI: 2,
      Location.provinceLugdunensisII: 2,
      Location.provinceNarbonensis: 4,
      Location.provinceSuevia: 1,
      Location.provinceBoiohaemia: 1,
      Location.provinceDalmatia: 4,
      Location.provinceNoricum: 3,
      Location.provincePannoniaI: 2,
      Location.provincePannoniaII: 3,
      Location.provinceQuadia: 1,
      Location.provinceSarmatia: 1,
      Location.provinceAchaea: 5,
      Location.provinceCreta: 2,
      Location.provinceDaciaI: 1,
      Location.provinceDaciaII: 1,
      Location.provinceDardania: 2,
      Location.provinceEpirus: 3,
      Location.provinceMacedonia: 4,
      Location.provinceMoesiaI: 2,
      Location.provinceBaetica: 5,
      Location.provinceBaleares: 2,
      Location.provinceCarthaginensis: 4,
      Location.provinceCeltiberia: 3,
      Location.provinceGallaecia: 3,
      Location.provinceLusitania: 3,
      Location.provinceMauretaniaII: 2,
      Location.provinceTarraconensis: 3,
      Location.provinceAfrica: 5,
      Location.provinceMauretaniaI: 3,
      Location.provinceNumidia: 4,
      Location.provinceTripolitania: 3,
      Location.provinceAsia: 5,
      Location.provinceBosporus: 3,
      Location.provinceCaria: 3,
      Location.provinceConstantinople: 5,
      Location.provinceGothiaI: 1,
      Location.provinceGothiaII: 1,
      Location.provinceLyciaPamphylia: 3,
      Location.provinceMoesiaII: 2,
      Location.provincePhrygia: 2,
      Location.provinceRhodope: 3,
      Location.provinceScythia: 2,
      Location.provinceAethiopia: 2,
      Location.provinceAlexandria: 5,
      Location.provinceArabiaI: 2,
      Location.provinceArabiaII: 2,
      Location.provinceArcadia: 4,
      Location.provinceAssyria: 3,
      Location.provinceBabylonia: 3,
      Location.provinceCyprus: 3,
      Location.provinceEuphratensis: 3,
      Location.provinceIsauria: 3,
      Location.provinceLibya: 3,
      Location.provinceMesopotamia: 3,
      Location.provincePalaestina: 3,
      Location.provincePhoenicia: 3,
      Location.provinceSyria: 4,
      Location.provinceThebais: 4,
      Location.provinceAlbania: 2,
      Location.provinceArmeniaI: 4,
      Location.provinceArmeniaII: 3,
      Location.provinceArmeniaIII: 3,
      Location.provinceArmeniaIV: 3,
      Location.provinceBithynia: 4,
      Location.provinceCappadocia: 3,
      Location.provinceCaucasia: 1,
      Location.provinceColchis: 2,
      Location.provinceIberia: 2,
      Location.provincePontus: 3,
    };
    return provinceRevenues[province]!;
  }

  int provinceLegionaryIcons(province) {
    switch (province) {
    case Location.provinceRhaetia:
    case Location.provinceBritanniaII:
    case Location.provinceCaledonia:
    case Location.provinceHibernia:
    case Location.provinceValentia:
    case Location.provinceFrisia:
    case Location.provinceGermaniaI:
    case Location.provinceGermaniaII:
    case Location.provinceGermaniaIII:
    case Location.provinceSuevia:
    case Location.provinceBoiohaemia:
    case Location.provinceNoricum:
    case Location.provincePannoniaI:
    case Location.provincePannoniaII:
    case Location.provinceQuadia:
    case Location.provinceSarmatia:
    case Location.provinceDaciaI:
    case Location.provinceDaciaII:
    case Location.provinceDardania:
    case Location.provinceMoesiaI:
    case Location.provinceGallaecia:
    case Location.provinceMauretaniaI:
    case Location.provinceBosporus:
    case Location.provinceGothiaI:
    case Location.provinceGothiaII:
    case Location.provinceMoesiaII:
    case Location.provinceScythia:
    case Location.provinceAethiopia:
    case Location.provinceAlexandria:
    case Location.provinceArabiaI:
    case Location.provinceArabiaII:
    case Location.provinceAssyria:
    case Location.provinceBabylonia:
    case Location.provinceEuphratensis:
    case Location.provinceMesopotamia:
    case Location.provincePalaestina:
    case Location.provincePhoenicia:
    case Location.provinceThebais:
    case Location.provinceAlbania:
    case Location.provinceArmeniaI:
    case Location.provinceArmeniaII:
    case Location.provinceArmeniaIV:
    case Location.provinceCaucasia:
    case Location.provinceColchis:
    case Location.provinceIberia:
      return 1;
    default:
      return 0;
    }
  }

  int provinceFleetIcons(Location province) {
    switch (province) {
    case Location.provinceRavenna:
    case Location.provinceBritanniaI:
    case Location.provinceGermaniaII:
    case Location.provincePannoniaII:
    case Location.provinceAfrica:
    case Location.provinceBosporus:
    case Location.provinceConstantinople:
    case Location.provinceScythia:
    case Location.provinceAlexandria:
    case Location.provinceBabylonia:
    case Location.provinceSyria:
    case Location.provinceArmeniaII:
      return 1;
    default:
      return 0;
    }
  }

  bool provinceHasGrainIcon(Location province) {
    const grainProvinces = [
      Location.provinceSicilia,
      Location.provinceBaetica,
      Location.provinceAfrica,
      Location.provinceAlexandria,
      Location.provinceArcadia,
      Location.provinceThebais,
    ];
    return grainProvinces.contains(province);
  }

  bool provinceMountain(Location province) {
    const mountainProvinces = [
      Location.provincePhrygia,
      Location.provinceArabiaI,
      Location.provinceAlbania,
      Location.provinceCappadocia,
    ];
    return mountainProvinces.contains(province);

  }

  bool provinceOnEuphrates(Location province) {
    const euphratesProvinces = [
      Location.provinceAssyria,
      Location.provinceBabylonia,
      Location.provinceEuphratensis,
      Location.provinceMesopotamia,
      Location.provinceArmeniaI,
      Location.provinceArmeniaIII,
      Location.provinceArmeniaIV,
      Location.provinceIberia,
    ];
    return euphratesProvinces.contains(province);
  }

  List<(Location, ConnectionType)> spaceConnections(Location space) {
    const connections = {
      Location.provinceCorsicaSardinia: [
        (Location.provinceMediolanum,ConnectionType.sea),
        (Location.provincePisae,ConnectionType.sea),
        (Location.provinceRome,ConnectionType.sea),
        (Location.provinceNarbonensis,ConnectionType.sea),
        (Location.provinceBaleares,ConnectionType.sea),
        (Location.provinceAfrica,ConnectionType.sea)],
      Location.provinceMediolanum: [
        (Location.provinceCorsicaSardinia,ConnectionType.sea),
        (Location.provincePisae,ConnectionType.road),
        (Location.provinceRhaetia,ConnectionType.road),
        (Location.provinceAlpes,ConnectionType.road)],
      Location.provinceNeapolis: [
        (Location.provinceRome,ConnectionType.road),
        (Location.provinceSicilia,ConnectionType.river),
        (Location.provinceSpoletium,ConnectionType.road),
        (Location.provinceEpirus,ConnectionType.river)],
      Location.provincePisae: [
        (Location.provinceCorsicaSardinia,ConnectionType.sea),
        (Location.provinceMediolanum,ConnectionType.road),
        (Location.provinceRavenna,ConnectionType.road),
        (Location.provinceRome,ConnectionType.road)],
      Location.provinceRavenna: [
        (Location.provincePisae,ConnectionType.road),
        (Location.provinceRhaetia,ConnectionType.road),
        (Location.provinceRome,ConnectionType.road),
        (Location.provinceSpoletium,ConnectionType.road),
        (Location.provinceDalmatia,ConnectionType.river),
        (Location.provinceNoricum,ConnectionType.road)],
      Location.provinceRhaetia: [
        (Location.provinceMediolanum,ConnectionType.road),
        (Location.provinceRavenna,ConnectionType.road),
        (Location.provinceGermaniaI,ConnectionType.road),
        (Location.provinceSuevia,ConnectionType.river),
        (Location.provinceBoiohaemia,ConnectionType.river),
        (Location.provinceNoricum,ConnectionType.road)],
      Location.provinceRome: [
        (Location.provinceCorsicaSardinia,ConnectionType.sea),
        (Location.provinceNeapolis,ConnectionType.road),
        (Location.provincePisae,ConnectionType.road),
        (Location.provinceRavenna,ConnectionType.road),
        (Location.provinceSpoletium,ConnectionType.road)],
      Location.provinceSicilia: [
        (Location.provinceNeapolis,ConnectionType.river),
        (Location.provinceAchaea,ConnectionType.sea),
        (Location.provinceAfrica,ConnectionType.sea)],
      Location.provinceSpoletium: [
        (Location.provinceNeapolis,ConnectionType.road),
        (Location.provinceRavenna,ConnectionType.road),
        (Location.provinceRome,ConnectionType.road),
        (Location.provinceDalmatia,ConnectionType.sea)],
      Location.provinceBritanniaI: [
        (Location.provinceBritanniaII,ConnectionType.road),
        (Location.provinceValentia,ConnectionType.river),
        (Location.provinceBelgica,ConnectionType.river),
        (Location.provinceFrisia,ConnectionType.sea),
        (Location.provinceGermaniaII,ConnectionType.river),
        (Location.provinceLugdunensisII,ConnectionType.sea)],
      Location.provinceBritanniaII: [
        (Location.provinceBritanniaI,ConnectionType.road),
        (Location.provinceCaledonia,ConnectionType.road),
        (Location.provinceHibernia,ConnectionType.sea),
        (Location.provinceValentia,ConnectionType.road),
        (Location.provinceFrisia,ConnectionType.sea),
        (Location.homelandSaxon,ConnectionType.sea)],
      Location.provinceCaledonia: [
        (Location.provinceBritanniaII,ConnectionType.road),
        (Location.provinceHibernia,ConnectionType.river),
        (Location.homelandPictish,ConnectionType.mountain),
        (Location.homelandScottish,ConnectionType.river)],
      Location.provinceHibernia: [
        (Location.provinceBritanniaII,ConnectionType.sea),
        (Location.provinceCaledonia,ConnectionType.river),
        (Location.provinceValentia,ConnectionType.river),
        (Location.homelandScottish,ConnectionType.road)],
      Location.provinceValentia: [
        (Location.provinceBritanniaI,ConnectionType.river),
        (Location.provinceBritanniaII,ConnectionType.road),
        (Location.provinceHibernia,ConnectionType.river)],
      Location.provinceAlpes: [
        (Location.provinceMediolanum,ConnectionType.road),
        (Location.provinceGermaniaI,ConnectionType.road),
        (Location.provinceLugdunensisI,ConnectionType.road),
        (Location.provinceNarbonensis,ConnectionType.road)],
      Location.provinceAquitaniaI: [
        (Location.provinceAquitaniaII,ConnectionType.road),
        (Location.provinceLugdunensisI,ConnectionType.road),
        (Location.provinceLugdunensisII,ConnectionType.road),
        (Location.provinceNarbonensis,ConnectionType.road)],
      Location.provinceAquitaniaII: [
        (Location.provinceAquitaniaI,ConnectionType.road),
        (Location.provinceNarbonensis,ConnectionType.road),
        (Location.provinceCeltiberia,ConnectionType.road),
        (Location.provinceGallaecia,ConnectionType.road),
        (Location.provinceTarraconensis,ConnectionType.road)],
      Location.provinceBelgica: [
        (Location.provinceBritanniaI,ConnectionType.river),
        (Location.provinceGermaniaI,ConnectionType.road),
        (Location.provinceGermaniaII,ConnectionType.road),
        (Location.provinceLugdunensisI,ConnectionType.road),
        (Location.provinceLugdunensisII,ConnectionType.road)],
      Location.provinceFrisia: [
        (Location.provinceBritanniaI,ConnectionType.sea),
        (Location.provinceBritanniaII,ConnectionType.sea),
        (Location.provinceGermaniaII,ConnectionType.river),
        (Location.homelandFrankish,ConnectionType.river)],
      Location.provinceGermaniaI: [
        (Location.provinceRhaetia,ConnectionType.road),
        (Location.provinceAlpes,ConnectionType.road),
        (Location.provinceBelgica,ConnectionType.road),
        (Location.provinceGermaniaII,ConnectionType.road),
        (Location.provinceGermaniaIII,ConnectionType.river),
        (Location.provinceLugdunensisI,ConnectionType.road),
        (Location.provinceSuevia,ConnectionType.river)],
      Location.provinceGermaniaII: [
        (Location.provinceBritanniaI,ConnectionType.river),
        (Location.provinceBelgica,ConnectionType.road),
        (Location.provinceFrisia,ConnectionType.river),
        (Location.provinceGermaniaI,ConnectionType.road),
        (Location.provinceGermaniaIII,ConnectionType.river)],
      Location.provinceGermaniaIII: [
        (Location.provinceGermaniaI,ConnectionType.river),
        (Location.provinceGermaniaII,ConnectionType.river),
        (Location.provinceSuevia,ConnectionType.mountain),
        (Location.homelandBurgundian,ConnectionType.river),
        (Location.homelandFrankish,ConnectionType.mountain)],
      Location.provinceLugdunensisI: [
        (Location.provinceAlpes,ConnectionType.road),
        (Location.provinceAquitaniaI,ConnectionType.road),
        (Location.provinceBelgica,ConnectionType.road),
        (Location.provinceGermaniaI,ConnectionType.road),
        (Location.provinceLugdunensisII,ConnectionType.road)],
      Location.provinceLugdunensisII: [
        (Location.provinceBritanniaI,ConnectionType.sea),
        (Location.provinceAquitaniaI,ConnectionType.road),
        (Location.provinceBelgica,ConnectionType.road),
        (Location.provinceLugdunensisI,ConnectionType.road)],
      Location.provinceNarbonensis: [
        (Location.provinceCorsicaSardinia,ConnectionType.sea),
        (Location.provinceAlpes,ConnectionType.road),
        (Location.provinceAquitaniaI,ConnectionType.road),
        (Location.provinceAquitaniaII,ConnectionType.road),
        (Location.provinceBaleares,ConnectionType.sea),
        (Location.provinceTarraconensis,ConnectionType.road)],
      Location.provinceSuevia: [
        (Location.provinceRhaetia,ConnectionType.river),
        (Location.provinceGermaniaI,ConnectionType.river),
        (Location.provinceGermaniaIII,ConnectionType.mountain),
        (Location.provinceBoiohaemia,ConnectionType.mountain),
        (Location.homelandSuevian,ConnectionType.mountain)],
      Location.provinceBoiohaemia: [
        (Location.provinceRhaetia,ConnectionType.river),
        (Location.provinceSuevia,ConnectionType.mountain),
        (Location.provinceNoricum,ConnectionType.river),
        (Location.provincePannoniaI,ConnectionType.river),
        (Location.provinceQuadia,ConnectionType.mountain),
        (Location.homelandAlan,ConnectionType.mountain),
        (Location.homelandSuevian,ConnectionType.mountain)],
      Location.provinceDalmatia: [
        (Location.provinceRavenna,ConnectionType.river),
        (Location.provinceSpoletium,ConnectionType.sea),
        (Location.provincePannoniaI,ConnectionType.road),
        (Location.provincePannoniaII,ConnectionType.road),
        (Location.provinceMoesiaI,ConnectionType.road)],
      Location.provinceNoricum: [
        (Location.provinceRavenna,ConnectionType.road),
        (Location.provinceRhaetia,ConnectionType.road),
        (Location.provinceBoiohaemia,ConnectionType.river),
        (Location.provincePannoniaI,ConnectionType.road)],
      Location.provincePannoniaI: [
        (Location.provinceBoiohaemia,ConnectionType.river),
        (Location.provinceDalmatia,ConnectionType.road),
        (Location.provinceNoricum,ConnectionType.road),
        (Location.provincePannoniaII,ConnectionType.road),
        (Location.provinceQuadia,ConnectionType.river)],
      Location.provincePannoniaII: [
        (Location.provinceDalmatia,ConnectionType.road),
        (Location.provincePannoniaI,ConnectionType.road),
        (Location.provinceQuadia,ConnectionType.river),
        (Location.provinceSarmatia,ConnectionType.river),
        (Location.provinceMoesiaI,ConnectionType.road)],
      Location.provinceQuadia: [
        (Location.provinceBoiohaemia,ConnectionType.mountain),
        (Location.provincePannoniaI,ConnectionType.river),
        (Location.provincePannoniaII,ConnectionType.river),
        (Location.provinceSarmatia,ConnectionType.mountain),
        (Location.homelandAlan,ConnectionType.mountain),
        (Location.homelandSarmatian,ConnectionType.mountain)],
      Location.provinceSarmatia: [
        (Location.provincePannoniaII,ConnectionType.river),
        (Location.provinceQuadia,ConnectionType.mountain),
        (Location.provinceDaciaI,ConnectionType.mountain),
        (Location.provinceDaciaII,ConnectionType.river),
        (Location.homelandAvar,ConnectionType.mountain),
        (Location.homelandSarmatian,ConnectionType.mountain)],
      Location.provinceAchaea: [
        (Location.provinceSicilia,ConnectionType.sea),
        (Location.provinceCreta,ConnectionType.sea),
        (Location.provinceEpirus,ConnectionType.river),
        (Location.provinceMacedonia,ConnectionType.road),
        (Location.provinceAsia,ConnectionType.sea),
        (Location.provinceCaria,ConnectionType.sea)],
      Location.provinceCreta: [
        (Location.provinceAchaea,ConnectionType.sea),
        (Location.provinceCaria,ConnectionType.sea),
        (Location.provinceLibya,ConnectionType.sea)],
      Location.provinceDaciaI: [
        (Location.provinceSarmatia,ConnectionType.mountain),
        (Location.provinceDaciaII,ConnectionType.mountain),
        (Location.provinceGothiaI,ConnectionType.mountain),
        (Location.homelandAvar,ConnectionType.mountain),
        (Location.homelandVisigothic,ConnectionType.mountain)],
      Location.provinceDaciaII: [
        (Location.provinceSarmatia,ConnectionType.river),
        (Location.provinceDaciaI,ConnectionType.mountain),
        (Location.provinceDardania,ConnectionType.river),
        (Location.provinceMoesiaI,ConnectionType.river),
        (Location.provinceGothiaI,ConnectionType.mountain)],
      Location.provinceDardania: [
        (Location.provinceDaciaII,ConnectionType.river),
        (Location.provinceMacedonia,ConnectionType.road),
        (Location.provinceMoesiaI,ConnectionType.road),
        (Location.provinceGothiaI,ConnectionType.river),
        (Location.provinceMoesiaII,ConnectionType.road),
        (Location.provinceRhodope,ConnectionType.road)],
      Location.provinceEpirus: [
        (Location.provinceNeapolis,ConnectionType.river),
        (Location.provinceAchaea,ConnectionType.river),
        (Location.provinceMacedonia,ConnectionType.road),
        (Location.provinceMoesiaI,ConnectionType.road)],
      Location.provinceMacedonia: [
        (Location.provinceAchaea,ConnectionType.road),
        (Location.provinceDardania,ConnectionType.road),
        (Location.provinceEpirus,ConnectionType.road),
        (Location.provinceMoesiaI,ConnectionType.road),
        (Location.provinceRhodope,ConnectionType.road)],
      Location.provinceMoesiaI: [
        (Location.provinceDalmatia,ConnectionType.road),
        (Location.provincePannoniaII,ConnectionType.road),
        (Location.provinceDaciaII,ConnectionType.river),
        (Location.provinceDardania,ConnectionType.road),
        (Location.provinceEpirus,ConnectionType.road),
        (Location.provinceMacedonia,ConnectionType.road)],
      Location.provinceBaetica: [
        (Location.provinceCarthaginensis,ConnectionType.road),
        (Location.provinceCeltiberia,ConnectionType.road),
        (Location.provinceLusitania,ConnectionType.road),
        (Location.provinceMauretaniaII,ConnectionType.river)],
      Location.provinceBaleares: [
        (Location.provinceCorsicaSardinia,ConnectionType.sea),
        (Location.provinceNarbonensis,ConnectionType.sea),
        (Location.provinceCarthaginensis,ConnectionType.sea),
        (Location.provinceTarraconensis,ConnectionType.sea),
        (Location.provinceNumidia,ConnectionType.sea)],
      Location.provinceCarthaginensis: [
        (Location.provinceBaetica,ConnectionType.road),
        (Location.provinceBaleares,ConnectionType.sea),
        (Location.provinceCeltiberia,ConnectionType.road),
        (Location.provinceTarraconensis,ConnectionType.road),
        (Location.provinceMauretaniaI,ConnectionType.sea)],
      Location.provinceCeltiberia: [
        (Location.provinceAquitaniaII,ConnectionType.road),
        (Location.provinceBaetica,ConnectionType.road),
        (Location.provinceCarthaginensis,ConnectionType.road),
        (Location.provinceGallaecia,ConnectionType.road),
        (Location.provinceLusitania,ConnectionType.road),
        (Location.provinceTarraconensis,ConnectionType.road)],
      Location.provinceGallaecia: [
        (Location.provinceAquitaniaII,ConnectionType.road),
        (Location.provinceCeltiberia,ConnectionType.road),
        (Location.provinceLusitania,ConnectionType.road)],
      Location.provinceLusitania: [
        (Location.provinceBaetica,ConnectionType.road),
        (Location.provinceCeltiberia,ConnectionType.road),
        (Location.provinceGallaecia,ConnectionType.road)],
      Location.provinceMauretaniaII: [
        (Location.provinceBaetica,ConnectionType.river),
        (Location.provinceMauretaniaI,ConnectionType.road)],
      Location.provinceTarraconensis: [
        (Location.provinceAquitaniaII,ConnectionType.road),
        (Location.provinceNarbonensis,ConnectionType.road),
        (Location.provinceBaleares,ConnectionType.sea),
        (Location.provinceCarthaginensis,ConnectionType.road),
        (Location.provinceCeltiberia,ConnectionType.road)],
      Location.provinceAfrica: [
        (Location.provinceCorsicaSardinia,ConnectionType.sea),
        (Location.provinceSicilia,ConnectionType.sea),
        (Location.provinceNumidia,ConnectionType.road),
        (Location.provinceTripolitania,ConnectionType.road)],
      Location.provinceMauretaniaI: [
        (Location.provinceCarthaginensis,ConnectionType.sea),
        (Location.provinceMauretaniaII,ConnectionType.road),
        (Location.provinceNumidia,ConnectionType.road),
        (Location.homelandMoorish,ConnectionType.road)],
      Location.provinceNumidia: [
        (Location.provinceBaleares,ConnectionType.sea),
        (Location.provinceAfrica,ConnectionType.road),
        (Location.provinceMauretaniaI,ConnectionType.road)],
      Location.provinceTripolitania: [
        (Location.provinceAfrica,ConnectionType.road),
        (Location.provinceLibya,ConnectionType.river)],
      Location.provinceAsia: [
        (Location.provinceAchaea,ConnectionType.sea),
        (Location.provinceCaria,ConnectionType.road),
        (Location.provinceConstantinople,ConnectionType.river),
        (Location.provinceLyciaPamphylia,ConnectionType.road),
        (Location.provincePhrygia,ConnectionType.road),
        (Location.provinceBithynia,ConnectionType.road)],
      Location.provinceBosporus: [
        (Location.provinceGothiaII,ConnectionType.river),
        (Location.provinceScythia,ConnectionType.sea),
        (Location.provinceArmeniaII,ConnectionType.sea),
        (Location.provinceBithynia,ConnectionType.sea),
        (Location.provinceCaucasia,ConnectionType.river),
        (Location.provincePontus,ConnectionType.sea),
        (Location.homelandBulgar,ConnectionType.river)],
      Location.provinceCaria: [
        (Location.provinceAchaea,ConnectionType.sea),
        (Location.provinceCreta,ConnectionType.sea),
        (Location.provinceAsia,ConnectionType.road),
        (Location.provinceLyciaPamphylia,ConnectionType.road)],
      Location.provinceConstantinople: [
        (Location.provinceAsia,ConnectionType.river),
        (Location.provinceMoesiaII,ConnectionType.road),
        (Location.provinceRhodope,ConnectionType.road),
        (Location.provinceBithynia,ConnectionType.river)],
      Location.provinceGothiaI: [
        (Location.provinceDaciaI,ConnectionType.mountain),
        (Location.provinceDaciaII,ConnectionType.mountain),
        (Location.provinceDardania,ConnectionType.river),
        (Location.provinceGothiaII,ConnectionType.road),
        (Location.provinceMoesiaII,ConnectionType.river),
        (Location.provinceScythia,ConnectionType.river)],
      Location.provinceGothiaII: [
        (Location.provinceBosporus,ConnectionType.river),
        (Location.provinceGothiaI,ConnectionType.road),
        (Location.provinceScythia,ConnectionType.river),
        (Location.homelandOstrogothic,ConnectionType.river),
        (Location.homelandVisigothic,ConnectionType.mountain)],
      Location.provinceLyciaPamphylia: [
        (Location.provinceAsia,ConnectionType.road),
        (Location.provinceCaria,ConnectionType.road),
        (Location.provincePhrygia,ConnectionType.road),
        (Location.provinceCyprus,ConnectionType.sea),
        (Location.provinceIsauria,ConnectionType.road)],
      Location.provinceMoesiaII: [
        (Location.provinceDardania,ConnectionType.road),
        (Location.provinceConstantinople,ConnectionType.road),
        (Location.provinceGothiaI,ConnectionType.river),
        (Location.provinceRhodope,ConnectionType.road),
        (Location.provinceScythia,ConnectionType.road)],
      Location.provincePhrygia: [
        (Location.provinceAsia,ConnectionType.road),
        (Location.provinceLyciaPamphylia,ConnectionType.road),
        (Location.provinceBithynia,ConnectionType.road),
        (Location.provinceCappadocia,ConnectionType.road),
        (Location.provincePontus,ConnectionType.road)],
      Location.provinceRhodope: [
        (Location.provinceDardania,ConnectionType.road),
        (Location.provinceMacedonia,ConnectionType.road),
        (Location.provinceConstantinople,ConnectionType.road),
        (Location.provinceMoesiaII,ConnectionType.road)],
      Location.provinceScythia: [
        (Location.provinceBosporus,ConnectionType.sea),
        (Location.provinceGothiaI,ConnectionType.river),
        (Location.provinceGothiaII,ConnectionType.river),
        (Location.provinceMoesiaII,ConnectionType.road)],
      Location.provinceAethiopia: [
        (Location.provinceThebais,ConnectionType.river),
        (Location.homelandNubian,ConnectionType.river)],
      Location.provinceAlexandria: [
        (Location.provinceArabiaII,ConnectionType.road),
        (Location.provinceArcadia,ConnectionType.river),
        (Location.provinceCyprus,ConnectionType.sea),
        (Location.provinceLibya,ConnectionType.river),
        (Location.provincePalaestina,ConnectionType.road)],
      Location.provinceArabiaI: [
        (Location.provinceArabiaII,ConnectionType.road),
        (Location.provincePalaestina,ConnectionType.road),
        (Location.provincePhoenicia,ConnectionType.road),
        (Location.homelandArabian,ConnectionType.desert)],
      Location.provinceArabiaII: [
        (Location.provinceAlexandria,ConnectionType.road),
        (Location.provinceArabiaI,ConnectionType.road),
        (Location.provincePalaestina,ConnectionType.road),
        (Location.homelandArabian,ConnectionType.desert)],
      Location.provinceArcadia: [
        (Location.provinceAlexandria,ConnectionType.river),
        (Location.provinceThebais,ConnectionType.river)],
      Location.provinceAssyria: [
        (Location.provinceBabylonia,ConnectionType.river),
        (Location.provinceMesopotamia,ConnectionType.river),
        (Location.provinceArmeniaIV,ConnectionType.mountain),
        (Location.homelandPersian,ConnectionType.road)],
      Location.provinceBabylonia: [
        (Location.provinceAssyria,ConnectionType.river),
        (Location.provinceMesopotamia,ConnectionType.road),
        (Location.homelandPersian,ConnectionType.road)],
      Location.provinceCyprus: [
        (Location.provinceLyciaPamphylia,ConnectionType.sea),
        (Location.provinceAlexandria,ConnectionType.sea),
        (Location.provinceIsauria,ConnectionType.sea),
        (Location.provincePalaestina,ConnectionType.sea),
        (Location.provincePhoenicia,ConnectionType.sea),
        (Location.provinceSyria,ConnectionType.sea)],
      Location.provinceEuphratensis: [
        (Location.provinceMesopotamia,ConnectionType.river),
        (Location.provincePhoenicia,ConnectionType.road),
        (Location.provinceSyria,ConnectionType.road),
        (Location.provinceArmeniaIII,ConnectionType.road),
        (Location.provinceArmeniaIV,ConnectionType.river)],
      Location.provinceIsauria: [
        (Location.provinceLyciaPamphylia,ConnectionType.road),
        (Location.provinceCyprus,ConnectionType.sea),
        (Location.provinceSyria,ConnectionType.road),
        (Location.provinceCappadocia,ConnectionType.road)],
      Location.provinceLibya: [
        (Location.provinceCreta,ConnectionType.sea),
        (Location.provinceTripolitania,ConnectionType.river),
        (Location.provinceAlexandria,ConnectionType.river)],
      Location.provinceMesopotamia: [
        (Location.provinceAssyria,ConnectionType.river),
        (Location.provinceBabylonia,ConnectionType.road),
        (Location.provinceEuphratensis,ConnectionType.river),
        (Location.provinceArmeniaIV,ConnectionType.road)],
      Location.provincePalaestina: [
        (Location.provinceAlexandria,ConnectionType.road),
        (Location.provinceArabiaI,ConnectionType.road),
        (Location.provinceArabiaII,ConnectionType.road),
        (Location.provinceCyprus,ConnectionType.sea),
        (Location.provincePhoenicia,ConnectionType.road)],
      Location.provincePhoenicia: [
        (Location.provinceArabiaI,ConnectionType.road),
        (Location.provinceCyprus,ConnectionType.sea),
        (Location.provinceEuphratensis,ConnectionType.road),
        (Location.provincePalaestina,ConnectionType.road),
        (Location.provinceSyria,ConnectionType.road)],
      Location.provinceSyria: [
        (Location.provinceCyprus,ConnectionType.sea),
        (Location.provinceEuphratensis,ConnectionType.road),
        (Location.provinceIsauria,ConnectionType.road),
        (Location.provincePhoenicia,ConnectionType.road)],
      Location.provinceThebais: [
        (Location.provinceAethiopia,ConnectionType.river),
        (Location.provinceArcadia,ConnectionType.river)],
      Location.provinceAlbania: [
        (Location.provinceIberia,ConnectionType.mountain),
        (Location.homelandHunnic2,ConnectionType.mountain),
        (Location.homelandPersian,ConnectionType.mountain)],
      Location.provinceArmeniaI: [
        (Location.provinceArmeniaII,ConnectionType.road),
        (Location.provinceArmeniaIV,ConnectionType.river),
        (Location.provinceIberia,ConnectionType.mountain),
        (Location.homelandPersian,ConnectionType.mountain)],
      Location.provinceArmeniaII: [
        (Location.provinceBosporus,ConnectionType.sea),
        (Location.provinceArmeniaI,ConnectionType.road),
        (Location.provinceArmeniaIII,ConnectionType.road),
        (Location.provinceCappadocia,ConnectionType.road),
        (Location.provinceColchis,ConnectionType.mountain),
        (Location.provincePontus,ConnectionType.road)],
      Location.provinceArmeniaIII: [
        (Location.provinceEuphratensis,ConnectionType.road),
        (Location.provinceArmeniaII,ConnectionType.road),
        (Location.provinceArmeniaIV,ConnectionType.river),
        (Location.provinceCappadocia,ConnectionType.road)],
      Location.provinceArmeniaIV: [
        (Location.provinceAssyria,ConnectionType.mountain),
        (Location.provinceEuphratensis,ConnectionType.river),
        (Location.provinceMesopotamia,ConnectionType.road),
        (Location.provinceArmeniaI,ConnectionType.river),
        (Location.provinceArmeniaIII,ConnectionType.river)],
      Location.provinceBithynia: [
        (Location.provinceAsia,ConnectionType.road),
        (Location.provinceBosporus,ConnectionType.sea),
        (Location.provinceConstantinople,ConnectionType.river),
        (Location.provincePhrygia,ConnectionType.road),
        (Location.provincePontus,ConnectionType.road)],
      Location.provinceCappadocia: [
        (Location.provincePhrygia,ConnectionType.road),
        (Location.provinceIsauria,ConnectionType.road),
        (Location.provinceArmeniaII,ConnectionType.road),
        (Location.provinceArmeniaIII,ConnectionType.road),
        (Location.provincePontus,ConnectionType.road)],
      Location.provinceCaucasia: [
        (Location.provinceBosporus,ConnectionType.river),
        (Location.provinceColchis,ConnectionType.mountain),
        (Location.homelandHunnic2,ConnectionType.mountain)],
      Location.provinceColchis: [
        (Location.provinceArmeniaII,ConnectionType.mountain),
        (Location.provinceCaucasia,ConnectionType.mountain),
        (Location.provinceIberia,ConnectionType.mountain),
        (Location.homelandHunnic2,ConnectionType.mountain)],
      Location.provinceIberia: [
        (Location.provinceAlbania,ConnectionType.mountain),
        (Location.provinceArmeniaI,ConnectionType.mountain),
        (Location.provinceColchis,ConnectionType.mountain),
        (Location.homelandHunnic2,ConnectionType.mountain)],
      Location.provincePontus: [
        (Location.provinceBosporus,ConnectionType.sea),
        (Location.provincePhrygia,ConnectionType.road),
        (Location.provinceArmeniaII,ConnectionType.road),
        (Location.provinceBithynia,ConnectionType.road),
        (Location.provinceCappadocia,ConnectionType.road)],
      Location.homelandAlan: [
        (Location.provinceBoiohaemia,ConnectionType.mountain),
        (Location.provinceQuadia,ConnectionType.mountain),
        (Location.homelandVandal,ConnectionType.river)],
      Location.homelandArabian: [
        (Location.provinceArabiaI,ConnectionType.desert),
        (Location.provinceArabiaII,ConnectionType.desert)],
      Location.homelandAvar: [
        (Location.provinceSarmatia,ConnectionType.mountain),
        (Location.provinceDaciaI,ConnectionType.mountain),
        (Location.homelandSlav,ConnectionType.mountain)],
      Location.homelandBulgar: [
        (Location.provinceBosporus,ConnectionType.river)],
      Location.homelandBurgundian: [
        (Location.provinceGermaniaIII,ConnectionType.river),
        (Location.homelandFrankish,ConnectionType.river),
        (Location.homelandVandal,ConnectionType.river)],
      Location.homelandFrankish: [
        (Location.provinceFrisia,ConnectionType.river),
        (Location.provinceGermaniaIII,ConnectionType.mountain),
        (Location.homelandBurgundian,ConnectionType.river),
        (Location.homelandSaxon,ConnectionType.river)],
      Location.homelandHunnic0: [
        (Location.homelandVandal,ConnectionType.river)],
      Location.homelandHunnic1: [
        (Location.homelandOstrogothic,ConnectionType.river),
        (Location.homelandVisigothic,ConnectionType.river)],
      Location.homelandHunnic2: [
        (Location.provinceAlbania,ConnectionType.mountain),
        (Location.provinceCaucasia,ConnectionType.mountain),
        (Location.provinceColchis,ConnectionType.mountain),
        (Location.provinceIberia,ConnectionType.mountain)],
      Location.homelandMoorish: [
        (Location.provinceMauretaniaI,ConnectionType.road)],
      Location.homelandNubian: [
        (Location.provinceAethiopia,ConnectionType.river)],
      Location.homelandOstrogothic: [
        (Location.provinceGothiaII,ConnectionType.river),
        (Location.homelandHunnic1,ConnectionType.river)],
      Location.homelandPersian: [
        (Location.provinceAssyria,ConnectionType.road),
        (Location.provinceBabylonia,ConnectionType.road),
        (Location.provinceAlbania,ConnectionType.mountain),
        (Location.provinceArmeniaI,ConnectionType.mountain)],
      Location.homelandPictish: [
        (Location.provinceCaledonia,ConnectionType.mountain)],
      Location.homelandSarmatian: [
        (Location.provinceQuadia,ConnectionType.mountain),
        (Location.provinceSarmatia,ConnectionType.mountain)],
      Location.homelandSaxon: [
        (Location.provinceBritanniaII,ConnectionType.sea),
        (Location.homelandFrankish,ConnectionType.river)],
      Location.homelandScottish: [
        (Location.provinceCaledonia,ConnectionType.river),
        (Location.provinceHibernia,ConnectionType.road)],
      Location.homelandSlav: [
        (Location.homelandAvar,ConnectionType.mountain)],
      Location.homelandSuevian: [
        (Location.provinceSuevia,ConnectionType.mountain),
        (Location.provinceBoiohaemia,ConnectionType.mountain),
        (Location.homelandVandal,ConnectionType.river)],
      Location.homelandVandal: [
        (Location.homelandAlan,ConnectionType.river),
        (Location.homelandBurgundian,ConnectionType.river),
        (Location.homelandHunnic0,ConnectionType.river),
        (Location.homelandSuevian,ConnectionType.river)],
      Location.homelandVisigothic: [
        (Location.provinceDaciaI,ConnectionType.mountain),
        (Location.provinceGothiaII,ConnectionType.mountain),
        (Location.homelandHunnic1,ConnectionType.river)],
    };
    return connections[space]!;
  }

  ConnectionType? spacesConnectionType(Location space1, Location space2) {
    final connections = spaceConnections(space1);
    for (final connection in connections) {
      if (connection.$1 == space2) {
        return connection.$2;
      }
    }
    return null;
  }

  List<Location> spaceConnectedSpaces(Location space) {
    final connectedSpaces = <Location>[];
    for (final connection in spaceConnections(space)) {
      connectedSpaces.add(connection.$1);
    }
    return connectedSpaces;
  }

  /*
  void checkSpaceConnections() {
    for (int i = LocationType.space.firstIndex; i < LocationType.space.lastIndex; ++i) {
      Location space1 = Location.values[i];
      for (int j = LocationType.space.firstIndex; j < LocationType.space.lastIndex; ++j) {
        Location space2 = Location.values[j];

        final connectionType12 = spacesConnectionType(space1, space2);
        final connectionType21 = spacesConnectionType(space2, space1);

        if (connectionType12 != connectionType21) {
          assert(connectionType12 == connectionType21);
        }
        if (i == j) {
          if (connectionType12 != null) {
            assert(connectionType12 == null);
          }
        }
      }
    }
  }
  */

  bool spaceHasConnectionToAlliedOrBetterProvince(Location space) {
    for (final province in LocationType.province.locations) {
      if (spacesConnectionType(space, province) != null && spaceAlliedOrBetter(province)) {
        return true;
      }
    }
    return false;
  }

  bool spaceHasConnectionToFoederatiProvince(Location space, List<Enemy> foederati) {
    for (final province in LocationType.province.locations) {
      if (spacesConnectionType(space, province) != null) {
        final status = provinceStatus(province);
        if (status.foederati != null && foederati.contains(status.foederati)) {
          return true;
        }
      }
    }
    return false;
  }

  ConnectionType connectionTypeForWar(ConnectionType rawConnectionType, Piece war) {
    int navalStrength = warNavalStrength(war);
    switch (rawConnectionType) {
    case ConnectionType.road:
    case ConnectionType.desert:
    case ConnectionType.mountain:
      return rawConnectionType;
    case ConnectionType.river:
      if (navalStrength >= 2) {
        return ConnectionType.road;
      }
      return rawConnectionType;
    case ConnectionType.sea:
      if (navalStrength >= 3) {
        return ConnectionType.road;
      }
      if (navalStrength >= 2) {
        return ConnectionType.river;
      }
      return rawConnectionType;
    }
  }

  int spaceNonMatchingFoederatiOrBetterDistance(Location space, Piece war) {
    if (spaceNonMatchingFoederatiOrBetter(space, war)) {
      return 0;
    }
    bool includeSeaConnections = warNavalStrength(war) >= 2;
    int distance = 1;
    var oldSpaces = <Location>[];
    var currentSpaces = <Location>[space];
    var newSpaces = <Location>[];
    while (true) {
      for (final fromSpace in currentSpaces) {
        for (final connection in spaceConnections(fromSpace)) {
          if (connection.$2 != ConnectionType.sea || includeSeaConnections) {
            final toSpace = connection.$1;
            if (!oldSpaces.contains(toSpace) && !currentSpaces.contains(toSpace) && !newSpaces.contains(toSpace)) {
              if (spaceNonMatchingFoederatiOrBetter(toSpace, war)) {
                return distance;
              }
              newSpaces.add(toSpace);
            }
          }
        }
      }
      distance += 1;
      if (newSpaces.isEmpty) {
        return distance;
      }
      oldSpaces = oldSpaces + currentSpaces;
      currentSpaces = newSpaces;
      newSpaces = <Location>[];
    }
  }

  Location provinceCommand(Location province) {
    for (final command in LocationType.governorship.locations) {
      final locationType = commandLocationType(command)!;
      if (province.isType(locationType)) {
        return command;
      }
    }
    return Location.offmap;
  }

  Location pieceLocation(Piece piece) {
    return _pieceLocations[piece.index];
  }

  void setPieceLocation(Piece piece, Location location) {
    _pieceLocations[piece.index] = location;
    if (piece.isType(PieceType.unit)) {
      var flipPiece = unitFlipUnit(piece);
      _pieceLocations[flipPiece.index] = Location.flipped;
      if (location == Location.boxBarracks) {
        const flipPieceTypes = [
          PieceType.fort,
          PieceType.legionVeteran,
          PieceType.auxiliaVeteran,
          PieceType.guardVeteran,
          PieceType.cavalryVeteran,
          PieceType.fleetVeteran,
        ];
        for (final pieceType in flipPieceTypes) {
          if (piece.isType(pieceType)) {
            piece = flipPiece;
            flipPiece = unitFlipUnit(piece);
            _pieceLocations[piece.index] = location;
            _pieceLocations[flipPiece.index] = Location.flipped;
          }
        }
        if (flipPiece.isType(PieceType.fort)) {
          _pieceLocations[flipPiece.index] = location;
        } else if (flipPiece.isType(PieceType.auxiliaVeteran)) {
          if (!dynastyActive(Piece.dynastyValentinian)) {
            _pieceLocations[flipPiece.index] = location;
          }
        }
      }
    }
  }

  void flipUnit(Piece unit) {
    final location = pieceLocation(unit);
    setPieceLocation(unitFlipUnit(unit), location);
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

  int provinceLegionaryIconPieceCount(Location province) {
    int count = piecesInLocationCount(PieceType.legionaries, province);
    if (dynastyActive(Piece.dynastyValentinian)) {
      count += piecesInLocationCount(PieceType.guard, province);
      count += piecesInLocationCount(PieceType.fort, province);
    }
    return count;
  }

  List<Piece> provinceOverstackedUnits(Location province) {
    int legionLimit = 2;
    int auxiliaLimit = 2;
    int fortLimit = 1;
    int guardLimit = 1;
    int cavalryLimit = 1;
    int fleetLimit = 1;

    if (provinceMountain(province)) {
      fleetLimit = 0;
    }

    if (!spaceInsurgentOrBetter(province)) {
      legionLimit = 0;
      auxiliaLimit = 0;
      fortLimit = 0;
      guardLimit = 0;
      cavalryLimit = 0;
      fleetLimit = 0;
    }

    var units = <Piece>[];

    final legions = piecesInLocation(PieceType.legion, province);
    final pseudoLegions = piecesInLocation(PieceType.pseudoLegion, province);
    if (legions.length + pseudoLegions.length > legionLimit) {
      units += legions;
      units += pseudoLegions;
    }
    final auxilia = piecesInLocation(PieceType.auxilia, province);
    if (auxilia.length > auxiliaLimit) {
      units += auxilia;
    }
    final guards = piecesInLocation(PieceType.guard, province);
    if (guards.length > guardLimit) {
      units += guards;
    }
    final cavalry = piecesInLocation(PieceType.cavalry, province);
    if (cavalry.length > cavalryLimit) {
      units += cavalry;
    }
    final forts = piecesInLocation(PieceType.fort, province);
    if (forts.length > fortLimit) {
      units += forts;
    }
    final fleets = piecesInLocation(PieceType.fleet, province);
    if (fleets.length > fleetLimit) {
      units += fleets;
    }

    return units;
  }

  List<Location> overstackedProvinces() {
    final provinces = <Location>[];
    for (final province in LocationType.province.locations) {
      if (provinceOverstackedUnits(province).isNotEmpty) {
        provinces.add(province);
      }
    }
    return provinces;
  }

  Piece unitFlipUnit(Piece unit) {
    const flipTypes = [
      [PieceType.pseudoLegion, PieceType.fort],
      [PieceType.legionOrdinary, PieceType.legionVeteran],
      [PieceType.auxiliaOrdinary, PieceType.auxiliaVeteran],
      [PieceType.guardOrdinary, PieceType.guardVeteran],
      [PieceType.cavalryOrdinary, PieceType.cavalryVeteran],
      [PieceType.fleetOrdinary, PieceType.fleetVeteran],
    ];
    for (final flipType in flipTypes) {
      if (unit.isType(flipType[0])) {
        return Piece.values[flipType[1].firstIndex - flipType[0].firstIndex + unit.index];
      }
      if (unit.isType(flipType[1])) {
        return Piece.values[flipType[0].firstIndex - flipType[1].firstIndex + unit.index];
      }
    }
    return unit;
  }

  bool unitVeteran(Piece unit) {
    const veteranUnitTypes = [
      PieceType.legionVeteran,
      PieceType.auxiliaVeteran,
      PieceType.guardVeteran,
      PieceType.cavalryVeteran,
      PieceType.fleetVeteran,
    ];
    for (final pieceType in veteranUnitTypes) {
      if (unit.isType(pieceType)) {
        return true;
      }
    }
    return false;
  }

  bool unitDemotable(Piece unit) {
    const demotableUnitTypes = [
      PieceType.pseudoLegion,
      PieceType.legionVeteran,
      PieceType.auxiliaVeteran,
      PieceType.guardVeteran,
      PieceType.cavalryVeteran,
      PieceType.fleetVeteran,
    ];
    for (final pieceType in demotableUnitTypes) {
      if (unit.isType(pieceType)) {
        if (pieceType == PieceType.pseudoLegion) {
          final province = pieceLocation(unit);
          if (piecesInLocationCount(PieceType.fort, province) >= 1) {
            return false;
          }
        }
        return true;
      }
    }
    return false;
  }

  bool unitPromotable(Piece unit) {
    const promotableUnitTypes = [
      PieceType.fort,
      PieceType.legionOrdinary,
      PieceType.auxiliaOrdinary,
      PieceType.guardOrdinary,
      PieceType.cavalryOrdinary,
      PieceType.fleetOrdinary,
    ];
    for (final pieceType in promotableUnitTypes) {
      if (unit.isType(pieceType)) {
        if (pieceType == PieceType.fort) {
          final province = pieceLocation(unit);
          if (piecesInLocationCount(PieceType.legionaries, province) >= 2) {
            return false;
          }
        }
        if (pieceType == PieceType.legionOrdinary || pieceType == PieceType.auxiliaOrdinary) {
          if (dynastyActive(Piece.dynastyValentinian)) {
            return false;
          }
        }
        return true;
      }
    }
    return false;
  }

  bool unitInPlay(Piece unit) {
    return pieceLocation(unit).isType(LocationType.province);
  }

  int assassinationGuardsInCapitalCount(Location target) {
    if (!target.isType(LocationType.emperor)) {
      return 0;
    }
    final capital = empireCapital(target);
    final capitalCommand = provinceCommand(capital);
    if (!commandLoyalVsEmperor(capitalCommand)) {
      return 0;
    }
    return piecesInLocationCount(PieceType.guard, capital);
  }

  int assassinationVeteranGuardsOutsideCapitalCount(Location target) {
    if (!target.isType(LocationType.emperor)) {
      return 0;
    }
    final capital = empireCapital(target);
    int count = 0;
    for (final guard in PieceType.guardVeteran.pieces) {
      final location = pieceLocation(guard);
      if (location != capital && location.isType(LocationType.province)) {
        final command = provinceCommand(location);
        if (commandEmpire(command) == target) {
          if (commandLoyalVsEmperor(command)) {
            count += 1;
          }
        }
      }
    }
    return count;
  }

  int assassinationVeteranCavalryCount(Location target) {
    if (!dynastyActive(Piece.dynastyTheodosian)) {
      return 0;
    }
    if (!target.isType(LocationType.governorship) && !commandIsRebelEmperor(target)) {
      return 0;
    }
    int count = 0;
    for (final cavalry in PieceType.cavalryVeteran.pieces) {
      final location = pieceLocation(cavalry);
      if (location.isType(LocationType.province)) {
        final command = provinceCommand(location);
        if (commandAllegiance(command) == target) {
          count += 1;
        }
      }
    }
    return count;
  }

  int pillageDeterrentLandUnitsInSpaceCount(Location space) {
    int count = 0;
    for (final unit in piecesInLocation(PieceType.landUnit, space)) {
      if (unit.isType(PieceType.fort)) {
        count += 2;
      } else if (unit.isType(PieceType.auxiliaVeteran)) {
        count += 2;
      } else {
        count += 1;
      }
    }
    return count;
  }

  int rebellionVeteransControlledByCommandCount(Location command) {
    const unitTypes = [
      PieceType.legionVeteran,
      PieceType.guardVeteran,
      PieceType.cavalryVeteran,
      PieceType.fleetVeteran,
    ];
    int count = 0;
    for (final pieceType in unitTypes) {
      for (final unit in pieceType.pieces) {
        final location = pieceLocation(unit);
        if (location.isType(LocationType.province)) {
          final unitCommand = provinceCommand(location);
          if (commandAllegiance(unitCommand) == command) {
            count += 1;
          }
        }
      }
    }
    return count;
  }

  List<Piece> provinceViableWarUnits(Location province) {
    return piecesInLocation(PieceType.unit, province);
  }

  int unitBuildCost(Piece unit) {
    if (unit.isType(PieceType.cavalryOrdinary)) {
      return 30;
    }
    if (unit.isType(PieceType.guardOrdinary)) {
      return 25;
    }
    if (unit.isType(PieceType.legionOrdinary)) {
      return 15;
    }
    if (unit.isType(PieceType.pseudoLegion)) {
      return 15;
    }
    if (unit.isType(PieceType.fort)) {
      return 10;
    }
    if (unit.isType(PieceType.auxiliaOrdinary)) {
      return 5;
    }
    if (unit.isType(PieceType.auxiliaVeteran)) {
      return 10;
    }
    if (unit.isType(PieceType.fleetOrdinary)) {
      return 20;
    }
    return 0;
  }

  int unitPromoteCost(Piece unit) {
    if (unit.isType(PieceType.fort)) {
      return 10;
    }
    if (unit.isType(PieceType.auxiliaOrdinary)) {
      return 5;
    }
    return 0;
  }

  int unitPayCost(Piece unit) {
    if (unit.isType(PieceType.cavalry)) {
      return 6;
    }
    if (unit.isType(PieceType.guard)) {
      return 5;
    }
    if (unit.isType(PieceType.legion)) {
      return 3;
    }
    if (unit.isType(PieceType.pseudoLegion)) {
      return 3;
    }
    if (unit.isType(PieceType.fort)) {
      return 2;
    }
    if (unit.isType(PieceType.auxiliaOrdinary)) {
      return 1;
    }
    if (unit.isType(PieceType.auxiliaVeteran)) {
      return 2;
    }
    if (unit.isType(PieceType.fleet)) {
      return 4;
    }
    return 0;
  }

  int empirePay(Location empire) {
    int total = 0;
    for (final unit in PieceType.unit.pieces) {
      if (unitInPlay(unit)) {
        final province = pieceLocation(unit);
        final command = provinceCommand(province);
        if (commandEmpire(command) == empire) {
          if (!commandRebel(command)) {
            total += unitPayCost(unit);
          }
        }
      }
    }
    return total;
  }

  bool unitCanBuild(Piece unit) {
    if (pieceLocation(unit) != Location.boxBarracks) {
      return false;
    }
    for (final empire in LocationType.empire.locations) {
      if (empireGold(empire) >= unitBuildCost(unit)) {
        return true;
      }
    }
    return false;
  }

  bool unitCanPromote(Piece unit) {
    int cost = unitPromoteCost(unit);
    if (cost == 0) {
      return false;
    }
    if (unit.isType(PieceType.auxiliaOrdinary) && dynastyActive(Piece.dynastyValentinian)) {
      return false;
    }
    final location = pieceLocation(unit);
    if (!location.isType(LocationType.province)) {
      return false;
    }
    final command = provinceCommand(location);
    final empire = commandEmpire(command);
    return empireGold(empire) >= cost;
  }

  bool unitCanTransfer(Piece unit) {
    return unit.isType(PieceType.mobileUnit);
  }

  bool unitCanStackInProvince(Piece unit, Location province) {
    if (unit.isType(PieceType.cavalry)) {
      return piecesInLocationCount(PieceType.cavalry, province) < 1;
    }
    if (unit.isType(PieceType.guard)) {
      return piecesInLocationCount(PieceType.guard, province) < 1;
    }
    if (unit.isType(PieceType.legionaries)) {
      return piecesInLocationCount(PieceType.legionaries, province) < 2;
    }
    if (unit.isType(PieceType.auxilia)) {
      return piecesInLocationCount(PieceType.auxilia, province) < 2;
    }
    if (unit.isType(PieceType.fort)) {
      return piecesInLocationCount(PieceType.fort, province) < 1;
    }
    if (unit.isType(PieceType.fleet)) {
      if (provinceMountain(province)) {
        return false;
      }
      return piecesInLocationCount(PieceType.fleet, province) < 1;
    }
    return false;
  }

  bool unitCanBuildInProvince(Piece unit, Location province) {
    if (!spaceInsurgentOrBetter(province)) {
      return false;
    }
    final command = provinceCommand(province);
    if (commandRebel(command)) {
      return false;
    }
    if (unit.isType(PieceType.fleet) && provinceMountain(province)) {
      return false;
    }
    if (!unitCanStackInProvince(unit, province)) {
      return false;
    }
    final empire = commandEmpire(command);
    if (empireGold(empire) < unitBuildCost(unit)) {
      return false;
    }
    return true;
  }

  int unitTransferCostToProvince(Piece unit, Location toProvince) {
    final fromProvince = pieceLocation(unit);
    final fromCommand = provinceCommand(fromProvince);
    final toCommand = provinceCommand(toProvince);
    final fromEmpire = commandEmpire(fromCommand);
    final toEmpire = commandEmpire(toCommand);
    if (toCommand == fromCommand) {
      return 0;
    }
    if (toEmpire == fromEmpire) {
      if (unit.isType(PieceType.cavalry) || unit.isType(PieceType.guard)) {
        return 0;
      }
    }
    return unitPayCost(unit);
  }

  bool unitCanTransferToProvince(Piece unit, Location toProvince, bool checkEmpire, bool checkCost, bool checkLoyalty) {
    final fromProvince = pieceLocation(unit);
    if (toProvince == fromProvince) {
      return false;
    }
    if (!spaceInsurgentOrBetter(toProvince)) {
      return false;
    }
    if (!unitCanStackInProvince(unit, toProvince)) {
      return false;
    }
    final fromCommand = provinceCommand(fromProvince);
    final toCommand = provinceCommand(toProvince);
    final fromEmpire = commandEmpire(fromCommand);
    final toEmpire = commandEmpire(toCommand);
    final fromOverallCommand = commandOverallCommand(fromCommand);
    final toOverallCommand = commandOverallCommand(toCommand);
    if (checkEmpire && toEmpire != fromEmpire) {
      return false;
    }
    if (checkLoyalty) {
      if (toOverallCommand != fromOverallCommand) {
        if (commandRebel(fromOverallCommand) || commandRebel(toOverallCommand)) {
          return false;
        }
      }
    }
    if (unit.isType(PieceType.fleet)) {
      if (provinceMountain(toProvince)) {
        return false;
      }
      final fromEuphrates = provinceOnEuphrates(fromProvince);
      final toEuphrates = provinceOnEuphrates(toProvince);
      if (fromEuphrates != toEuphrates) {
        return false;
      }
    }
    if (checkCost) {
      final gold = commandRebel(fromOverallCommand) ? 0 : empireGold(toEmpire);
      if (gold < unitTransferCostToProvince(unit, toProvince)) {
        return false;
      }
    }
    return true;
  }

  Enemy warEnemy(Piece war) {
    return warData[war]!.$1;
  }

  int warStrength(Piece war) {
    return warData[war]!.$2;
  }

  int warNavalStrength(Piece war) {
    return warData[war]!.$3;
  }

  int warCavalryStrength(Piece war) {
    return warData[war]!.$4;
  }

  List<Location> warHomelands(Piece war) {
    final enemy = warEnemy(war);
    final foederatiStatus = enemy.foederatiStatus;
    if (foederatiStatus != null) {
      final provinces = <Location>[];
      for (final province in LocationType.province.locations) {
        if (provinceStatus(province) == foederatiStatus) {
          provinces.add(province);
        }
      }
      if (provinces.isNotEmpty) {
        return provinces;
      }
    }
    return enemy.homelands;
  }

  List<Piece> enemyWarsWithoutLeaders(Enemy enemy) {
    final wars = <Piece>[];
    for (final war in PieceType.war.pieces) {
      if (warEnemy(war) == enemy) {
        final location = pieceLocation(war);
        if (location.isType(LocationType.land)) {
          if (piecesInLocationCount(PieceType.leader, location) == 0) {
            wars.add(war);
          }
        }
      }
    }
    return wars;
  }

  Enemy leaderEnemy(Piece leader) {
    return leaderData[leader]!.$1;
  }

  int leaderStrength(Piece leader) {
    return leaderData[leader]!.$2;
  }

  int leaderPillage(Piece leader) {
    return leaderData[leader]!.$3;
  }

  Piece leaderStatesman(Piece leader) {
    const leaderStatesmen = {
      Piece.leaderStatesmanAlaric: Piece.statesmanAlaric,
      Piece.leaderStatesmanGainas: Piece.statesmanGainas,
      Piece.leaderStatesmanTheodoric: Piece.statesmanTheodoric,
      Piece.leaderStatesmanZeno: Piece.statesmanZeno,
    };
    return leaderStatesmen[leader]!;
  }

  String statesmanName(Piece statesman) {
    const statesmanNames = {
      Piece.statesmanAegidius: ('Aegidius', 'Aegidius'),
      Piece.statesmanAetius: ('Aetius', 'Flavius Aetius'),
      Piece.statesmanAlaric: ('Alaric Ⅰ', 'Alaric Ⅰ'),
      Piece.statesmanAmbrose: ('Ambrose of Milan', 'Auerlius Ambrosius'),
      Piece.statesmanAnastasius: ('Anastasius Ⅰ', 'Anastasius Ⅰ Dicorus'),
      Piece.statesmanAnthemius: ('Anthemius', 'Procpius Anthemius'),
      Piece.statesmanArbogast: ('Arbogast', 'Arbogast'),
      Piece.statesmanArcadius: ('Arcadius', 'Arcadius'),
      Piece.statesmanArius: ('Arius', 'Arius'),
      Piece.statesmanAspar: ('Aspar', 'Flavius Ardabur Aspar'),
      Piece.statesmanAuxerre: ('Germanus of Auxerre', 'Germanus Antissiodorensis'),
      Piece.statesmanBasiliscus: ('Basiliscus', 'Basiliscus'),
      Piece.statesmanBelisarius: ('Belisarius', 'Belisarius'),
      Piece.statesmanBonus: ('Bonus', 'Bonus'),
      Piece.statesmanCarausius: ('Carausius', 'Marcus Aurelius Mausaeus Carausius'),
      Piece.statesmanComentiolus: ('Comentiolus', 'Comentiolus'),
      Piece.statesmanConstans: ('Constans Ⅰ', 'Flavius Julius Constans'),
      Piece.statesmanConstantineI: ('Constantine Ⅰ', 'Flavius Valerius Constantinus'),
      Piece.statesmanConstantineII: ('Constantine Ⅱ', 'Flavius Claudius Contantinus'),
      Piece.statesmanConstantiusI: ('Constantius Ⅰ', 'Flavius Valerius Constantius'),
      Piece.statesmanConstantiusII: ('Constantius Ⅱ', 'Flavius Julius Constantius'),
      Piece.statesmanConstantiusIII: ('Constantius Ⅲ', 'Constantius Ⅲ'),
      Piece.statesmanCrispus: ('Crispus', 'Flavius Julius Crispus'),
      Piece.statesmanDiocletian: ('Diocletian', 'Gaius Aurelius Valerius Diocletianus'),
      Piece.statesmanEutropius: ('Eutropius', 'Eutropius'),
      Piece.statesmanGainas: ('Gainas', 'Gainas'),
      Piece.statesmanGalerius: ('Galerius', 'Galerius Valerius Maximianus'),
      Piece.statesmanGermanus: ('Germanus', 'Germanus'),
      Piece.statesmanGratian: ('Gratian', 'Gratianus'),
      Piece.statesmanGregory: ('Pope Gregory Ⅰ', 'Pope Gregory Ⅰ'),
      Piece.statesmanHeraclius: ('Heraclius', 'Heraclius'),
      Piece.statesmanHonorius: ('Honorius', 'Honorius'),
      Piece.statesmanJulian: ('Julian', 'Flavius Claudius Julianus'),
      Piece.statesmanJustinI: ('Justin Ⅰ', 'Justin Ⅰ'),
      Piece.statesmanJustinII: ('Justin Ⅱ', 'Justin Ⅱ'),
      Piece.statesmanJustinianI: ('Justinian Ⅰ', 'Justinian Ⅰ'),
      Piece.statesmanLeoI: ('Leo Ⅰ', 'Leo Ⅰ'),
      Piece.statesmanLiberius: ('Liberius', 'Petrus Marcellinus Felix Liberius'),
      Piece.statesmanLicinius: ('Licinius', 'Valerius Licinianus Lininius'),
      Piece.statesmanMagnentius: ('Magnentius', 'Magnus Magnentius'),
      Piece.statesmanMajorian: ('Majorian', 'Julius Valerius Majorianus'),
      Piece.statesmanMarcian: ('Marcian', 'Marcian'),
      Piece.statesmanMaurice: ('Maurice', 'Maurice'),
      Piece.statesmanMaxentius: ('Maxentius', 'Marcus Aurelius Valerius Maxentius'),
      Piece.statesmanMaximian: ('Maximian', 'Marcus Aurelius Valerius Maximianus'),
      Piece.statesmanMaximinusII: ('Maximinus Ⅱ', 'Galerius Valerius Maximinimus Daza'),
      Piece.statesmanMystacon: ('John Mystacon', 'John Mystacon'),
      Piece.statesmanNarses: ('Narses', 'Narses'),
      Piece.statesmanOdoacer: ('Odoacer', 'Odoacer'),
      Piece.statesmanPetronius: ('Petronius Maximus', 'Petronius Maximus'),
      Piece.statesmanPhocas: ('Phocas', 'Phocas'),
      Piece.statesmanPriscus: ('Priscus', 'Priscus'),
      Piece.statesmanRicimer: ('Ricimer', 'Ricimer'),
      Piece.statesmanPopeLeo: ('Pope Leo Ⅰ', 'Pope Leo Ⅰ'),
      Piece.statesmanSergius: ('Patriarch Sergius Ⅰ', 'Patriarch Sergius Ⅰ of Constantinople'),
      Piece.statesmanStilicho: ('Stilicho', 'Stilicho'),
      Piece.statesmanTheodora: ('Theodora', 'Theodora'),
      Piece.statesmanTheodoric: ('Theodoric the Great', 'Theodoric the Great'),
      Piece.statesmanTheodosius: ('Count Theodosius', 'Flavius Theodosius'),
      Piece.statesmanTheodosiusI: ('Theodosius Ⅰ', 'Theodosius Ⅰ'),
      Piece.statesmanTheodosiusII: ('Theodosius Ⅱ', 'Theodosius Ⅱ'),
      Piece.statesmanTiberiusII: ('Tiberius Ⅱ Constantine', 'Tiberius Ⅱ Constantinus'),
      Piece.statesmanTroglita: ('John Troglita', 'John Troglita'),
      Piece.statesmanValens: ('Valens', 'Valens'),
      Piece.statesmanValentinianI: ('Valentinian Ⅰ', 'Valentinianus Ⅰ'),
      Piece.statesmanValentinianIII: ('Valentinian Ⅲ', 'Valentinianus Ⅲ'),
      Piece.statesmanZeno: ('Zeno', 'Zeno'),
    };

    String name = statesmanNames[statesman]!.$1;
    final location = pieceLocation(statesman);
    if (location.isType(LocationType.command) && commandRebel(location)) {
      name = 'Rebel $name';
    }
    return name;
  }

  bool statesmanInPlay(Piece statesman) {
    Location location = pieceLocation(statesman);
    return location.isType(LocationType.command) || location == Location.boxStatesmen;
  }

  Ability statesmanAbility(Piece statesman) {
    return statesmanData[statesman]!.$1;
  }

  int statesmanMilitary(Piece statesman) {
    return statesmanData[statesman]!.$2;
  }

  int statesmanAdministration(Piece statesman) {
    return statesmanData[statesman]!.$3;
  }

  int statesmanPopularity(Piece statesman) {
    return statesmanData[statesman]!.$4;
  }

  int statesmanIntrigue(Piece statesman) {
    return statesmanData[statesman]!.$5;
  }

  bool statesmanImperial(Piece statesman) {
    return statesmanData[statesman]!.$6;
  }

  bool statesmanIneligible(Piece statesman) {
    return statesmanData[statesman]!.$7;
  }

  bool statesmanActiveImperial(Piece statesman) {
    for (final dynasty in piecesInLocation(PieceType.dynasty, Location.boxDynasties)) {
      if (dynastyImperialStatesmen(dynasty).contains(statesman)) {
        return true;
      }
  	}
  	return false;
  }

  Piece? statesmanImperialDynasty(Piece statesman) {
    for (final dynasty in PieceType.dynasty.pieces) {
      if (dynastyImperialStatesmen(dynasty).contains(statesman)) {
        return dynasty;
      }
    }
    return null;
  }

  bool statesmanMayBecomeEmperor(Piece statesman) {
    return !statesmanIneligible(statesman);
  }

  Piece? statesmanLeader(Piece statesman) {
    const statesmanLeaders = {
      Piece.statesmanAlaric: Piece.leaderStatesmanAlaric,
      Piece.statesmanGainas: Piece.leaderStatesmanGainas,
      Piece.statesmanTheodoric:  Piece.leaderStatesmanTheodoric,
      Piece.statesmanZeno: Piece.leaderStatesmanZeno,
    };
    return statesmanLeaders[statesman];
  }

  String empireDesc(Location empire) {
    return empire == Location.commandWesternEmperor ? 'Western' : 'Eastern';
  }

  Location otherEmpire(Location empire) {
    return empire == Location.commandWesternEmperor ? Location.commandEasternEmperor : Location.commandWesternEmperor;
  }

  bool empireHasViceroy(Location empire) {
    return _empireViceroys[empire.index - LocationType.empire.firstIndex];
  }

  void setEmpireHasViceroy(Location empire, bool hasViceroy) {
    _empireViceroys[empire.index - LocationType.empire.firstIndex] = hasViceroy;
  }

  bool empireHasFallen(Location empire) {
    return _empireFallens[empire.index - LocationType.empire.firstIndex];
  }

  void setEmpireHasFallen(Location empire) {
    _empireFallens[empire.index - LocationType.empire.firstIndex] = true;
  }

  bool get soleEmperor {
    int count = 0;
    for (final empire in LocationType.empire.locations) {
      if (empireHasViceroy(empire) || empireHasFallen(empire)) {
        count += 1;
      }
    }
    return count == 1;
  }

  Location empireEmperor(Location empire) {
    if (empireHasViceroy(empire) || empireHasFallen(empire)) {
      return otherEmpire(empire);
    }
    return empire;
  }

  String commandName(Location command) {
    const commandNames = {
      Location.commandWesternEmperor: 'Western Emperor',
      Location.commandEasternEmperor: 'Eastern Emperor',
      Location.commandItalia: 'Italia',
      Location.commandBritannia: 'Britannia',
      Location.commandGallia: 'Gallia',
      Location.commandPannonia: 'Pannonia',
      Location.commandMoesia: 'Moesia',
      Location.commandHispania: 'Hispania',
      Location.commandAfrica: 'Africa',
      Location.commandThracia: 'Thracia',
      Location.commandOriens: 'Oriens',
      Location.commandPontica: 'Pontica',
    };
    return commandNames[command]!;
  }

  LocationType? commandLocationType(Location command) {
    const commandLocationTypes = {
      Location.commandWesternEmperor: null,
      Location.commandEasternEmperor: null,
      Location.commandItalia: LocationType.provinceItalia,
      Location.commandBritannia: LocationType.provinceBritannia,
      Location.commandGallia: LocationType.provinceGallia,
      Location.commandPannonia: LocationType.provincePannonia,
      Location.commandMoesia: LocationType.provinceMoesia,
      Location.commandHispania: LocationType.provinceHispania,
      Location.commandAfrica: LocationType.provinceAfrica,
      Location.commandThracia: LocationType.provinceThracia,
      Location.commandOriens: LocationType.provinceOriens,
      Location.commandPontica: LocationType.provincePontica,
    };
    return commandLocationTypes[command];
  }

  bool commandsConnect(Location command0, Location command1) {
    const commandConnections = {
      Location.commandItalia: [Location.commandGallia, Location.commandPannonia, Location.commandMoesia, Location.commandHispania, Location.commandAfrica],
      Location.commandBritannia: [Location.commandGallia],
      Location.commandGallia: [Location.commandItalia, Location.commandBritannia, Location.commandPannonia, Location.commandHispania],
      Location.commandPannonia: [Location.commandItalia, Location.commandGallia, Location.commandMoesia],
      Location.commandMoesia: [Location.commandItalia, Location.commandPannonia, Location.commandThracia, Location.commandOriens],
      Location.commandHispania: [Location.commandItalia, Location.commandGallia, Location.commandAfrica],
      Location.commandAfrica: [Location.commandItalia, Location.commandHispania, Location.commandOriens],
      Location.commandThracia: [Location.commandMoesia, Location.commandAfrica, Location.commandOriens, Location.commandPontica],
      Location.commandOriens: [Location.commandMoesia, Location.commandAfrica, Location.commandThracia, Location.commandPontica],
      Location.commandPontica: [Location.commandThracia, Location.commandOriens],
    };
    return commandConnections[command0]!.contains(command1);
  }

  String commanderPositionName(Location command) {
    const commanderPositionNames = {
	    Location.commandWesternEmperor: 'Western Emperor',
	    Location.commandEasternEmperor: 'Eastern Emperor',
	    Location.commandItalia: 'Governor of Italia',
	    Location.commandBritannia: 'Governor of Britannia',
	    Location.commandGallia: 'Governor of Gallia',
	    Location.commandPannonia:  'Governor of Pannonia',
	    Location.commandMoesia: 'Governor of Moesia',
	    Location.commandHispania: 'Governor of Hispania',
	    Location.commandAfrica: 'Governor of Africa',
	    Location.commandThracia: 'Governor of Thracia',
	    Location.commandOriens: 'Governor of Oriens',
	    Location.commandPontica: 'Governor of Pontica',
    };
    return commanderPositionNames[command]!;
  }

  Location commandEmpire(Location command) {
    switch (command) {
    case Location.commandWesternEmperor:
    case Location.commandItalia:
    case Location.commandBritannia:
    case Location.commandGallia:
    case Location.commandHispania:
    case Location.commandAfrica:
      return Location.commandWesternEmperor;
    case Location.commandEasternEmperor:
    case Location.commandThracia:
    case Location.commandOriens:
    case Location.commandPontica:
      return Location.commandEasternEmperor;
    case Location.commandPannonia:
      return dynastyActive(Piece.dynastyConstantinian) ? Location.commandWesternEmperor : Location.commandEasternEmperor;
    case Location.commandMoesia:
      return dynastyActive(Piece.dynastyConstantinian) && !dynastyActive(Piece.dynastyTheodosian) ? Location.commandWesternEmperor : Location.commandEasternEmperor;
    default:
    }
    return Location.offmap;
  }

  Location commandAllegiance(Location command) {
    if (command.isType(LocationType.emperor)) {
      return command;
    }
    return _governorshipAllegiances[command.index - LocationType.governorship.firstIndex];
  }

  void setCommandAllegiance(Location command, Location allegiance) {
    if (command.isType(LocationType.governorship)) {
      _governorshipAllegiances[command.index - LocationType.governorship.firstIndex] = allegiance;
    }
  }

  bool commandLoyal(Location command) {
    return _commandLoyals[command.index - LocationType.command.firstIndex];
  }

  bool commandRebel(Location command) {
    return !_commandLoyals[command.index - LocationType.command.firstIndex];
  }

  bool commandLoyalVsEmperor(Location command) {
    if (_commandLoyals[command.index - LocationType.command.firstIndex]) {
      return true;
    }
    return commandAllegiance(command).isType(LocationType.emperor);
  }

  bool commandRebelVsEmperor(Location command) {
    if (_commandLoyals[command.index - LocationType.command.firstIndex]) {
      return false;
    }
    return commandAllegiance(command).isType(LocationType.governorship);
  }

  void setCommandLoyalty(Location command, bool loyal) {
    _commandLoyals[command.index - LocationType.command.firstIndex] = loyal;
  }

  bool commandIsRebelEmperor(Location command) {
    return command.isType(LocationType.emperor) && commandRebel(command);
  }

  Location commandOverallCommand(Location command) {
    final allegiance = commandAllegiance(command);
    if (commandRebel(allegiance)) {
      return allegiance;
    }
    var empire = commandEmpire(allegiance);
    if (empireHasViceroy(empire) || empireHasFallen(empire)) {
      empire = otherEmpire(empire);
    }
    return empire;
  }

  bool commandActive(Location command) {
    if (!command.isType(LocationType.governorship)) {
      return true;
    }
    final locationType = commandLocationType(command)!;
    for (final province in locationType.locations) {
      if (provinceStatus(province) != ProvinceStatus.barbarian) {
        return true;
      }
    }
    return false;
  }

  int governorshipAllegianceCount(Location governorship) {
    int count = 0;
    for (final otherGovernorship in LocationType.governorship.locations) {
      if (commandAllegiance(otherGovernorship) == governorship) {
        count += 1;
      }
    }
    return count;
  }

  bool commandConnectsToGovernorship(Location command, Location governorship) {
    for (final otherCommand in LocationType.governorship.locations) {
      if (commandAllegiance(otherCommand) == governorship) {
        if (command == otherCommand) {
          return true;
        }
        if (commandsConnect(command, otherCommand)) {
          return true;
        }
      }
    }
    return false;
  }

  List<Location> loyalGovernorshipAllegianceCandidates(Location governorship) {
    final candidates = [governorship];
    if (pieceInLocation(PieceType.statesman, governorship) == null) {
      final empire = commandEmpire(governorship);
      final allegiance = commandAllegiance(governorship);
      for (final otherGovernorship in LocationType.governorship.locations) {
        if (otherGovernorship != governorship) {
          if (commandEmpire(otherGovernorship) == empire && commandLoyal(otherGovernorship)) {
            if (pieceInLocation(PieceType.statesman, otherGovernorship) != null && commandConnectsToGovernorship(governorship, otherGovernorship)) {
              if (otherGovernorship == allegiance || governorshipAllegianceCount(otherGovernorship) < 3) {
                candidates.add(otherGovernorship);
              }
            }
          }
        }
      }
    }
    return candidates;
  }

  void fixGovernorship(Location governorship) {
    for (final command in LocationType.governorship.locations) {
      if (command != governorship) {
        if (!commandConnectsToGovernorship(command, governorship)) {
          setCommandAllegiance(command, command);
        }
      }
    }
  }

  int unfilledCommandCount() {
    int count = 0;
    for (final governorship in LocationType.governorship.locations) {
      if (commandLoyal(governorship) && commandActive(governorship) && commandCommander(governorship) == null) {
        count += 1;
      }
    }
    return count;
  }

  Piece? commandCommander(Location command) {
    final allegiance = commandAllegiance(command);
    for (final statesman in PieceType.statesman.pieces) {
      if (pieceLocation(statesman) == allegiance) {
        return statesman;
      }
    }
    return null;
  }

  String commanderName(Location command) {
    final allegiance = commandAllegiance(command);
    final commander = commandCommander(allegiance);
    if (commander != null) {
      return statesmanName(commander);
    } else {
      return commanderPositionName(command);
    }
  }

  String fullCommanderName(Location command) {
    final allegiance = commandAllegiance(command);
    final commander = commandCommander(allegiance);
    final positionName = commanderPositionName(command);
    if (commander != null) {
      return '$positionName ${statesmanName(commander)}';
    } else {
      return positionName;
    }
  }

  int commandMilitary(Location command) {
    final allegiance = commandAllegiance(command);
    final commander = commandCommander(allegiance);
    if (commander != null) {
      return statesmanMilitary(commander);
    }
    return commandData[command]!.$1;
  }

  int commandAdministration(Location command) {
    final allegiance = commandAllegiance(command);
    final commander = commandCommander(allegiance);
    if (commander != null) {
      return statesmanAdministration(commander);
    }
    return commandData[command]!.$2;
  }

  int commandPopularity(Location command) {
    final allegiance = commandAllegiance(command);
    final commander = commandCommander(allegiance);
    if (commander != null) {
      return statesmanPopularity(commander);
    }
    return commandData[command]!.$3;
  }

  int commandIntrigue(Location command) {
    final allegiance = commandAllegiance(command);
    final commander = commandCommander(allegiance);
    if (commander != null) {
      return statesmanIntrigue(commander);
    }
    return commandData[command]!.$4;
  }

  bool statesmanValidAppointee(Piece statesman) {
    if (!statesmanInPlay(statesman)) {
      return false;
    }
    final location = pieceLocation(statesman);
    if (location == Location.boxStatesmen) {
      return true;
    }
    if (location.isType(LocationType.emperor)) {
      return false;
    }
    if (commandRebel(location)) {
      return false;
    }
    return true;
  }

  bool commandValidAppointment(Location command) {
    if (command.isType(LocationType.emperor)) {
      return false;
    }
    if (!commandActive(command)) {
      return false;
    }
    if (commandRebel(command)) {
      return false;
    }
    return true;
  }

  bool commandAppointmentsAcceptable() {
    if (piecesInLocationCount(PieceType.statesman, Location.boxStatesmen) > 0 && unfilledCommandCount() > 0) {
      return false;
    }
    for (final command in LocationType.command.locations) {
      if (commandLoyal(command) && !commandActive(command)) {
        final governor = commandCommander(command);
        if (governor != null) {
          return false;
        }
      }
    }
    return true;
  }

  List<Location> get activeEmperors {
    final emperors = <Location>[];
    for (final emperor in LocationType.emperor.locations) {
      if (!empireHasFallen(emperor) && !empireHasViceroy(emperor)) {
        emperors.add(emperor);
      }
    }
    return emperors;
  }

  List<Location> get activeGovernorships {
    final governorships = <Location>[];
    for (final governorship in LocationType.governorship.locations) {
      if (commandActive(governorship)) {
        governorships.add(governorship);
      }
    }
    return governorships;
  }

  void governorRebels(Location command) {
    for (final otherCommand in LocationType.governorship.locations) {
      if (commandAllegiance(otherCommand) == command) {
        setCommandLoyalty(otherCommand, false);
      }
    }
  }

  void emperorRebels(Location emperor) {
    setCommandLoyalty(emperor, false);
    for (final otherCommand in LocationType.governorship.locations) {
      if (commandEmpire(otherCommand) == emperor && commandLoyal(otherCommand)) {
        final commander = commandCommander(otherCommand);
        if (commander != null) {
          setPieceLocation(commander, Location.boxStatesmen);
        }
        setCommandAllegiance(otherCommand, emperor);
        setCommandLoyalty(otherCommand, false);
      }
    }
  }

  Location empireCapital(Location empire) {
    const empireCapitals = {
      Location.commandWesternEmperor: Location.provinceRome,
      Location.commandEasternEmperor: Location.provinceConstantinople,
    };
    return empireCapitals[empire]!;
  }

  bool dynastyActive(Piece dynasty) {
    return pieceLocation(dynasty) == Location.boxDynasties;
  }

  int get dynastiesCount {
    return piecesInLocationCount(PieceType.dynasty, Location.boxDynasties);
  }

  List<Piece> dynastyImperialStatesmen(Piece dynasty) {
    const imperialStatesmen = {
      Piece.dynastyConstantinian: [
        Piece.statesmanConstantiusI,
        Piece.statesmanConstantineI,
        Piece.statesmanCrispus,
        Piece.statesmanConstantineII,
        Piece.statesmanConstantiusII,
        Piece.statesmanConstans,
        Piece.statesmanJulian],
      Piece.dynastyValentinian: [
        Piece.statesmanValentinianI,
        Piece.statesmanValens,
        Piece.statesmanGratian],
      Piece.dynastyTheodosian: [
        Piece.statesmanTheodosius,
        Piece.statesmanTheodosiusI,
        Piece.statesmanArcadius,
        Piece.statesmanHonorius,
        Piece.statesmanTheodosiusII,
        Piece.statesmanValentinianIII,
        Piece.statesmanMarcian],
      Piece.dynastyLeonid: [
        Piece.statesmanLeoI,
        Piece.statesmanZeno,
        Piece.statesmanBasiliscus,
        Piece.statesmanAnastasius],
      Piece.dynastyJustinian: [
        Piece.statesmanJustinI,
        Piece.statesmanJustinianI,
        Piece.statesmanGermanus,
        Piece.statesmanTheodora,
        Piece.statesmanJustinII,
        Piece.statesmanTiberiusII,
        Piece.statesmanMaurice],
    };
    return imperialStatesmen[dynasty]!;
  }

  bool warInPlay(Piece war) {
    Location location = pieceLocation(war);
    return location.isType(LocationType.space);
  }

  bool leaderInPlay(Piece leader) {
    Location location = pieceLocation(leader);
    return location.isType(LocationType.space);
  }

  void setBarbarianOffmap(Piece barbarian) {
    if (_resurrectedBarbarians.contains(barbarian)) {
      setPieceLocation(barbarian, Location.poolWars);
      _resurrectedBarbarians.remove(barbarian);
    } else {
      setPieceLocation(barbarian, Location.offmap);
    }
  }

  void resurrectBarbarian(Piece barbarian) {
    if (!_resurrectedBarbarians.contains(barbarian)) {
      _resurrectedBarbarians.add(barbarian);
    }
  }

  String eventTypeName(EventType eventType) {
    const eventTypeNames = {
      EventType.assassin: 'Assassin',
      EventType.bagaudae: 'Bagaudae',
      EventType.bodyguard: 'Bodyguard',
      EventType.conspiracy: 'Conspiracy',
      EventType.convert: 'Convert',
      EventType.diplomat: 'Diplomat',
      EventType.foederati: 'Foederati',
      EventType.heresy: 'Heresy',
      EventType.hippodrome: 'Hippodrome',
      EventType.inflation: 'Inflation',
      EventType.migration: 'Migration',
      EventType.mutiny: 'Mutiny',
      EventType.omens: 'Omens',
      EventType.orthodoxy: 'Orthodoxy',
      EventType.papacy: 'Papacy',
      EventType.persecution: 'Persecution',
      EventType.plague: 'Plague',
      EventType.usurper: 'Usurper',
    };
    return eventTypeNames[eventType]!;
  }

  int eventTypeCount(EventType eventType) {
    return _eventTypeCounts[eventType.index];
  }

  void incrementEventTypeCount(EventType eventType) {
    _eventTypeCounts[eventType.index] += 1;
  }

  int eventTypeDiscreteCount() {
    return _eventTypeCounts.where((count) => count > 0).length;
  }

  int eventTypeMatchingCountCount(int matchCount) {
    return _eventTypeCounts.where((count) => count == matchCount).length;
  }

  void clearEventTypeCounts() {
    _eventTypeCounts.fillRange(0, _eventTypeCounts.length, 0);
  }

  int empireGold(Location empire) {
    return _gold[empire.index - LocationType.empire.firstIndex];
  }

  void setEmpireGold(Location empire, int amount) {
    _gold[empire.index - LocationType.empire.firstIndex] = amount;
  }

  void adjustEmpireGold(Location empire, int amount) {
    int index = empire.index - LocationType.empire.firstIndex;
    _gold[index] += amount;
    if (_gold[index] > 500) {
      _gold[index] = 500;
    }
  }

  int empirePrestige(Location empire) {
    return _prestige[empire.index - LocationType.empire.firstIndex];
  }

  void setEmpirePrestige(Location empire, int amount) {
    _prestige[empire.index - LocationType.empire.firstIndex] = amount;
  }

  void adjustEmpirePrestige(Location empire, int amount) {
    int index = empire.index - LocationType.empire.firstIndex;
    _prestige[index] += amount;
  }

  int empireUnrest(Location empire) {
    return _unrest[empire.index - LocationType.empire.firstIndex];
  }

  void setEmpireUnrest(Location empire, int amount) {
    _unrest[empire.index - LocationType.empire.firstIndex] = amount;
  }

  void adjustEmpireUnrest(Location empire, int amount) {
    int index = empire.index - LocationType.empire.firstIndex;
    _unrest[index] += amount;
    if (_unrest[index] < 0) {
      _unrest[index] = 0;
    }
  }

  int? leaderAge(Piece leader) {
    return _leaderAges[leader.index - PieceType.leader.firstIndex];
  }

  void setLeaderAge(Piece leader, int? age) {
    _leaderAges[leader.index - PieceType.leader.firstIndex] = age;
  }

  int? statesmanAge(Piece statesman) {
    return _statesmanAges[statesman.index - PieceType.statesman.firstIndex];
  }

  void setStatesmanAge(Piece statesman, int? age) {
    _statesmanAges[statesman.index - PieceType.statesman.firstIndex] = age;
  }

  int? commanderAge(Location command) {
    return _commanderAges[command.index - LocationType.command.firstIndex];
  }
  
  void setCommanderAge(Location command, int? age) {
    _commanderAges[command.index - LocationType.command.firstIndex] = age;
  }

  int get turn {
    return _turn;
  }

  void advanceTurn() {
    _turn += 1;
  }

  void setupLeaders(List<(Piece, Location, int)> leaders) {
    for (final record in leaders) {
      final leader = record.$1;
      final location = record.$2;
      final age = record.$3;
		  int ageClassification = (age - 18) ~/ 8;
      setPieceLocation(leader, location);
      setLeaderAge(leader, ageClassification);
    }
  }

  void setupStatesmen(List<(Piece, Location, int)> statesmen) {
    for (final record in statesmen) {
      final statesman = record.$1;
      final location = record.$2;
      final age = record.$3;
		  int ageClassification = (age - 2) ~/ 8 - 2; // Valentinian III is 6, will start at -2
      setPieceLocation(statesman, location);
      setStatesmanAge(statesman, ageClassification);
    }
  }

  void setupDynasties(List<Piece> dynasties) {
    for (final dynasty in dynasties) {
      setPieceLocation(dynasty, Location.boxDynasties);
    }
  }

  void setupStatesmenPool(List<Piece> pieces) {
    for (final piece in pieces) {
      setPieceLocation(piece, Location.poolStatesmen);
    }
  }

  void setupWarsPool(List<Piece> pieces) {
    for (final piece in pieces) {
      setPieceLocation(piece, Location.poolWars);
    }
  }

  void setupProvinceStatuses(List<(Location, ProvinceStatus)> provinces) {
    for (final record in provinces) {
      final province = record.$1;
      final status = record.$2;
      setProvinceStatus(province, status);
    }
  }

  void setupPieces(List<(Location, Piece)> pieces) {
    for (final record in pieces) {
      final location = record.$1;
      final piece = record.$2;
      setPieceLocation(piece, location);
    }
  }

  factory GameState.setup286CE() {

    var state = GameState();

    state._turn = 0;
    state.setEmpireGold(Location.commandEasternEmperor, 50);
    state.setEmpirePrestige(Location.commandEasternEmperor, 0);
    state.setEmpireUnrest(Location.commandEasternEmperor, 2);
    state.setEmpireGold(Location.commandWesternEmperor, 50);
    state.setEmpirePrestige(Location.commandWesternEmperor, 0);
    state.setEmpireUnrest(Location.commandWesternEmperor, 4);

	  state.setupStatesmen([
      (Piece.statesmanDiocletian, Location.commandEasternEmperor, 43),
      (Piece.statesmanMaximian, Location.commandWesternEmperor, 36),
      (Piece.statesmanCarausius, Location.commandBritannia, 26),
	  ]);

    state.setupLeaders([
    ]);

    state.setCommandLoyalty(Location.commandBritannia, false);

    state.setupDynasties([
    ]);

	  state.setupStatesmenPool([
      Piece.dynastyConstantinian,
      Piece.statesmanConstantiusI,
      Piece.statesmanGalerius,
      Piece.statesmanMaximinusII,
      Piece.statesmanConstantineI,
      Piece.statesmanMaxentius,
      Piece.statesmanLicinius,
      Piece.statesmanArius,
      Piece.statesmanCrispus,
      Piece.statesmanConstantineII,
      Piece.statesmanConstantiusII,
      Piece.statesmanConstans,
      Piece.statesmanMagnentius,
      Piece.statesmanJulian,
    ]);

    state.setupWarsPool([
      Piece.leaderShapur,
      Piece.warAlan9,
      Piece.warArabian5,
      Piece.warFrankish13,
      Piece.warFrankish11,
      Piece.warMoorish7,
      Piece.warMoorish5,
      Piece.warNubian4,
      Piece.warPersian15,
      Piece.warPersian13,
      Piece.warPersian11,
      Piece.warPictish4,
      Piece.warSarmatian10,
      Piece.warSarmatian8,
      Piece.warSaxon4,
      Piece.warScottish5,
      Piece.warSuevian13,
      Piece.warSuevian11,
      Piece.warSuevian9,
      Piece.warVandal91,
      Piece.warVisigothic12,
      Piece.warVisigothic10,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceDaciaI, ProvinceStatus.barbarian),
      (Location.provinceDaciaII, ProvinceStatus.barbarian),
      (Location.provinceAethiopia, ProvinceStatus.barbarian),
      (Location.provinceAssyria, ProvinceStatus.barbarian),
      (Location.provinceBabylonia, ProvinceStatus.barbarian),
      (Location.provinceBoiohaemia, ProvinceStatus.barbarian),
      (Location.provinceQuadia, ProvinceStatus.barbarian),
      (Location.provinceSarmatia, ProvinceStatus.barbarian),
      (Location.provinceColchis, ProvinceStatus.allied),
      (Location.provinceAlbania, ProvinceStatus.barbarian),
      (Location.provinceArmeniaI, ProvinceStatus.barbarian),
      (Location.provinceArmeniaIV, ProvinceStatus.barbarian),
      (Location.provinceCaucasia, ProvinceStatus.barbarian),
      (Location.provinceIberia, ProvinceStatus.barbarian),
      (Location.provinceBosporus, ProvinceStatus.allied),
      (Location.provinceGothiaI, ProvinceStatus.barbarian),
      (Location.provinceGothiaII, ProvinceStatus.barbarian),
      (Location.provinceCaledonia, ProvinceStatus.barbarian),
      (Location.provinceHibernia, ProvinceStatus.barbarian),
      (Location.provinceBelgica, ProvinceStatus.insurgent),
      (Location.provinceLugdunensisII, ProvinceStatus.insurgent),
      (Location.provinceFrisia, ProvinceStatus.barbarian),
      (Location.provinceGermaniaIII, ProvinceStatus.barbarian),
      (Location.provinceSuevia, ProvinceStatus.barbarian),
  	]);

    state.setupPieces([
      (Location.provinceDardania, Piece.legionVeteran0),
      (Location.provinceDardania, Piece.pseudoLegion0),
      (Location.provinceDardania, Piece.auxilia0),
      (Location.provinceDardania, Piece.auxilia1),
      (Location.provinceMoesiaI, Piece.legion1),
      (Location.provinceMoesiaI, Piece.auxilia2),
      (Location.provinceAlexandria, Piece.pseudoLegion1),
      (Location.provinceAlexandria, Piece.fleet0),
      (Location.provinceArabiaI, Piece.legion2),
      (Location.provinceArabiaI, Piece.auxilia3),
      (Location.provinceArabiaII, Piece.legion3),
      (Location.provinceArabiaII, Piece.auxilia4),
      (Location.provinceEuphratensis, Piece.legionVeteran4),
      (Location.provinceEuphratensis, Piece.auxilia5),
      (Location.provinceMesopotamia, Piece.legionVeteran5),
      (Location.provinceMesopotamia, Piece.pseudoLegion2),
      (Location.provinceMesopotamia, Piece.auxilia6),
      (Location.provinceMesopotamia, Piece.fort3),
      (Location.provincePalaestina, Piece.pseudoLegion4),
      (Location.provincePhoenicia, Piece.pseudoLegion5),
      (Location.provinceSyria, Piece.cavalryVeteran0),
      (Location.provinceSyria, Piece.guard0),
      (Location.provinceSyria, Piece.fleet1),
      (Location.provinceThebais, Piece.pseudoLegion6),
      (Location.provinceThebais, Piece.auxilia7),
      (Location.provinceNoricum, Piece.legion6),
      (Location.provinceNoricum, Piece.pseudoLegion7),
      (Location.provincePannoniaI, Piece.legionVeteran7),
      (Location.provincePannoniaI, Piece.pseudoLegion8),
      (Location.provincePannoniaI, Piece.auxilia8),
      (Location.provincePannoniaI, Piece.auxilia9),
      (Location.provincePannoniaII, Piece.legionVeteran8),
      (Location.provincePannoniaII, Piece.pseudoLegion9),
      (Location.provincePannoniaII, Piece.fleet2),
      (Location.provinceArmeniaII, Piece.legionVeteran9),
      (Location.provinceArmeniaII, Piece.auxilia10),
      (Location.provinceArmeniaII, Piece.fleet3),
      (Location.provinceArmeniaIII, Piece.legion10),
      (Location.provinceArmeniaIII, Piece.auxilia11),
      (Location.provinceConstantinople, Piece.cavalry1),
      (Location.provinceConstantinople, Piece.guardVeteran1),
      (Location.provinceMoesiaII, Piece.legion11),
      (Location.provinceMoesiaII, Piece.auxilia12),
      (Location.provinceScythia, Piece.legionVeteran12),
      (Location.provinceScythia, Piece.auxilia13),
      (Location.provinceScythia, Piece.fleet4),
      (Location.provinceAfrica, Piece.fleet5),
      (Location.provinceMauretaniaI, Piece.legion13),
      (Location.provinceMauretaniaI, Piece.fort10),
      (Location.provinceBritanniaI, Piece.legionVeteran14),
      (Location.provinceBritanniaI, Piece.pseudoLegion11),
      (Location.provinceBritanniaI, Piece.fleetVeteran6),
      (Location.provinceBritanniaII, Piece.legionVeteran15),
      (Location.provinceBritanniaII, Piece.fort12),
      (Location.provinceValentia, Piece.legion16),
      (Location.provinceValentia, Piece.auxilia14),
      (Location.provinceBelgica, Piece.cavalry2),
      (Location.provinceBelgica, Piece.guard2),
      (Location.provinceGermaniaI, Piece.legion17),
      (Location.provinceGermaniaI, Piece.pseudoLegion13),
      (Location.provinceGermaniaI, Piece.auxilia15),
      (Location.provinceGermaniaI, Piece.auxilia16),
      (Location.provinceGermaniaII, Piece.legion18),
      (Location.provinceGermaniaII, Piece.auxilia17),
      (Location.provinceGallaecia, Piece.pseudoLegion14),
      (Location.provinceMediolanum, Piece.cavalry3),
      (Location.provinceNeapolis, Piece.fleet7),
      (Location.provinceRavenna, Piece.fleet8),
      (Location.provinceRome, Piece.guard3),
      (Location.provinceRhaetia, Piece.legionVeteran19),
      (Location.provinceRhaetia, Piece.pseudoLegion15),
      (Location.provinceRhaetia, Piece.auxilia18),
      (Location.provinceRhaetia, Piece.auxilia19),
      (Location.boxBarracks, Piece.cavalry4),
      (Location.boxBarracks, Piece.cavalry5),
      (Location.boxBarracks, Piece.guard4),
      (Location.boxBarracks, Piece.guard5),
      (Location.boxBarracks, Piece.pseudoLegion16),
      (Location.boxBarracks, Piece.pseudoLegion17),
      (Location.boxBarracks, Piece.pseudoLegion18),
      (Location.boxBarracks, Piece.pseudoLegion19),
      (Location.boxBarracks, Piece.fleet9),
      (Location.boxBarracks, Piece.fleet10),
      (Location.boxBarracks, Piece.fleet11),
    ]);

    return state;
  }

  factory GameState.setup363CE() {

    var state = GameState();

    state._turn = 10;
    state.setEmpireGold(Location.commandEasternEmperor, 50);
    state.setEmpirePrestige(Location.commandEasternEmperor, 0);
    state.setEmpireUnrest(Location.commandEasternEmperor, 3);
    state.setEmpireGold(Location.commandWesternEmperor, 50);
    state.setEmpirePrestige(Location.commandWesternEmperor, 25);
    state.setEmpireUnrest(Location.commandWesternEmperor, 2);

	  state.setupStatesmen([
	  ]);

    state.setupLeaders([
      (Piece.leaderShapur, Location.homelandPersian, 54),
    ]);

    state.setCommanderAge(Location.commandEasternEmperor, 1); // Jovian, 33

    state.setEmpireHasViceroy(Location.commandWesternEmperor, true);

    state.setupDynasties([
      Piece.dynastyConstantinian,
    ]);

	  state.setupStatesmenPool([
      Piece.dynastyValentinian,
      Piece.dynastyTheodosian,
      Piece.statesmanValentinianI,
      Piece.statesmanValens,
      Piece.statesmanTheodosius,
      Piece.statesmanAmbrose,
      Piece.statesmanGratian,
      Piece.statesmanTheodosiusI,
      Piece.statesmanArbogast,
      Piece.statesmanArcadius,
      Piece.statesmanHonorius,
      Piece.statesmanStilicho,
      Piece.statesmanGainas,
      Piece.statesmanEutropius,
      Piece.statesmanAlaric,
      Piece.statesmanAnthemius,
      Piece.statesmanTheodosiusII,
      Piece.statesmanConstantiusIII,
      Piece.statesmanValentinianIII,
    ]);

    state.setupWarsPool([
      Piece.leaderFritigern,
      Piece.warAlan9,
      Piece.warArabian5,
      Piece.warBurgundian11,
      Piece.warFrankish13,
      Piece.warFrankish11,
      Piece.warHunnic14,
      Piece.warHunnic13,
      Piece.warIsaurian7,
      Piece.warMoorish7,
      Piece.warMoorish5,
      Piece.warOstrogothic13,
      Piece.warOstrogothic11,
      Piece.warPersian13,
      Piece.warPersian11,
      Piece.warPictish6,
      Piece.warPictish4,
      Piece.warSarmatian8,
      Piece.warSaxon6,
      Piece.warSaxon4,
      Piece.warScottish5,
      Piece.warSuevian13,
      Piece.warSuevian11,
      Piece.warSuevian9,
      Piece.warVandal93,
      Piece.warVandal8,
      Piece.warVandal7,
      Piece.warVisigothic14,
      Piece.warVisigothic12,
      Piece.warVisigothic10,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceMesopotamia, ProvinceStatus.insurgent),
      (Location.provinceSyria, ProvinceStatus.insurgent),
      (Location.provinceAethiopia, ProvinceStatus.barbarian),
      (Location.provinceAssyria, ProvinceStatus.barbarian),
      (Location.provinceBabylonia, ProvinceStatus.barbarian),
      (Location.provinceArmeniaIV, ProvinceStatus.insurgent),
      (Location.provinceArmeniaI, ProvinceStatus.allied),
      (Location.provinceColchis, ProvinceStatus.allied),
      (Location.provinceAlbania, ProvinceStatus.barbarian),
      (Location.provinceCaucasia, ProvinceStatus.barbarian),
      (Location.provinceIberia, ProvinceStatus.barbarian),
      (Location.provinceBosporus, ProvinceStatus.allied),
      (Location.provinceGothiaI, ProvinceStatus.foederatiVisigothic),
      (Location.provinceGothiaII, ProvinceStatus.foederatiVisigothic),
      (Location.provinceCaledonia, ProvinceStatus.barbarian),
      (Location.provinceHibernia, ProvinceStatus.barbarian),
      (Location.provinceFrisia, ProvinceStatus.foederatiFrankish),
      (Location.provinceSuevia, ProvinceStatus.foederatiSuevian),
      (Location.provinceGermaniaIII, ProvinceStatus.barbarian),
      (Location.provinceDaciaI, ProvinceStatus.barbarian),
      (Location.provinceDaciaII, ProvinceStatus.barbarian),
      (Location.provinceBoiohaemia, ProvinceStatus.barbarian),
      (Location.provinceQuadia, ProvinceStatus.barbarian),
      (Location.provinceSarmatia, ProvinceStatus.barbarian),
  	]);

    state.setupPieces([
      (Location.provinceAlexandria, Piece.pseudoLegion0),
      (Location.provinceAlexandria, Piece.fleet0),
      (Location.provinceArabiaI, Piece.pseudoLegion1),
      (Location.provinceArabiaI, Piece.auxilia0),
      (Location.provinceArabiaII, Piece.pseudoLegion2),
      (Location.provinceArabiaII, Piece.auxilia1),
      (Location.provinceEuphratensis, Piece.legionVeteran0),
      (Location.provinceMesopotamia, Piece.legionVeteran1),
      (Location.provinceMesopotamia, Piece.auxilia2),
      (Location.provinceMesopotamia, Piece.auxilia3),
      (Location.provinceMesopotamia, Piece.fort3),
      (Location.provincePalaestina, Piece.pseudoLegion4),
      (Location.provincePhoenicia, Piece.legion2),
      (Location.provinceSyria, Piece.cavalryVeteran0),
      (Location.provinceSyria, Piece.guardVeteran0),
      (Location.provinceSyria, Piece.auxiliaVeteran4),
      (Location.provinceSyria, Piece.fleet1),
      (Location.provinceThebais, Piece.pseudoLegion5),
      (Location.provinceThebais, Piece.auxilia5),
      (Location.provinceArmeniaII, Piece.legion3),
      (Location.provinceArmeniaII, Piece.fleet2),
      (Location.provinceArmeniaIV, Piece.legion4),
      (Location.provinceArmeniaIV, Piece.auxilia6),
      (Location.provinceConstantinople, Piece.cavalry1),
      (Location.provinceConstantinople, Piece.guard1),
      (Location.provinceConstantinople, Piece.auxiliaVeteran7),
      (Location.provinceConstantinople, Piece.fleetVeteran3),
      (Location.provinceMoesiaII, Piece.legionVeteran5),
      (Location.provinceScythia, Piece.pseudoLegion6),
      (Location.provinceScythia, Piece.fleet4),
      (Location.provinceAfrica, Piece.fleet5),
      (Location.provinceMauretaniaI, Piece.pseudoLegion7),
      (Location.provinceMauretaniaI, Piece.auxiliaVeteran8),
      (Location.provinceBritanniaI, Piece.fleet6),
      (Location.provinceBritanniaII, Piece.legion6),
      (Location.provinceBritanniaII, Piece.fort8),
      (Location.provinceValentia, Piece.pseudoLegion9),
      (Location.provinceValentia, Piece.auxilia9),
      (Location.provinceGermaniaI, Piece.legion7),
      (Location.provinceGermaniaI, Piece.auxilia10),
      (Location.provinceGermaniaII, Piece.pseudoLegion10),
      (Location.provinceGermaniaII, Piece.fleet7),
      (Location.provinceGallaecia, Piece.pseudoLegion11),
      (Location.provinceMediolanum, Piece.cavalry2),
      (Location.provinceMediolanum, Piece.guard2),
      (Location.provinceRavenna, Piece.fleet8),
      (Location.provinceRhaetia, Piece.legion8),
      (Location.provinceRhaetia, Piece.auxilia11),
      (Location.provinceDardania, Piece.legion9),
      (Location.provinceDardania, Piece.auxilia12),
      (Location.provinceMoesiaI, Piece.pseudoLegion12),
      (Location.provinceMoesiaI, Piece.auxilia13),
      (Location.provinceNoricum, Piece.legion10),
      (Location.provinceNoricum, Piece.auxilia14),
      (Location.provincePannoniaI, Piece.pseudoLegion13),
      (Location.provincePannoniaI, Piece.auxilia15),
      (Location.provincePannoniaI, Piece.fleet9),
      (Location.provincePannoniaII, Piece.legion11),
      (Location.provincePannoniaII, Piece.auxilia16),
      (Location.provincePannoniaII, Piece.fleet10),
      (Location.boxBarracks, Piece.cavalry3),
      (Location.boxBarracks, Piece.cavalry4),
      (Location.boxBarracks, Piece.cavalry5),
      (Location.boxBarracks, Piece.guard3),
      (Location.boxBarracks, Piece.guard4),
      (Location.boxBarracks, Piece.guard5),
      (Location.boxBarracks, Piece.pseudoLegion14),
      (Location.boxBarracks, Piece.pseudoLegion15),
      (Location.boxBarracks, Piece.pseudoLegion16),
      (Location.boxBarracks, Piece.pseudoLegion17),
      (Location.boxBarracks, Piece.pseudoLegion18),
      (Location.boxBarracks, Piece.pseudoLegion19),
      (Location.boxBarracks, Piece.auxilia17),
      (Location.boxBarracks, Piece.auxilia18),
      (Location.boxBarracks, Piece.auxilia19),
      (Location.boxBarracks, Piece.fleet11),
    ]);

    return state;
  }

  factory GameState.setup425CE() {

    var state = GameState();

    state._turn = 20;
    state.setEmpireGold(Location.commandEasternEmperor, 50);
    state.setEmpirePrestige(Location.commandEasternEmperor, 25);
    state.setEmpireUnrest(Location.commandEasternEmperor, 4);
    state.setEmpireGold(Location.commandWesternEmperor, 50);
    state.setEmpirePrestige(Location.commandWesternEmperor, 50);
    state.setEmpireUnrest(Location.commandWesternEmperor, 5);

	  state.setupStatesmen([
      (Piece.statesmanTheodosiusII, Location.commandEasternEmperor, 24),
      (Piece.statesmanValentinianIII, Location.commandWesternEmperor, 6),
	  ]);

    state.setupLeaders([
    ]);

    state.setupDynasties([
      Piece.dynastyConstantinian,
      Piece.dynastyValentinian,
      Piece.dynastyTheodosian,
    ]);

	  state.setupStatesmenPool([
      Piece.dynastyLeonid,
      Piece.statesmanAspar,
      Piece.statesmanAetius,
      Piece.statesmanAuxerre,
      Piece.statesmanPopeLeo,
      Piece.statesmanMarcian,
      Piece.statesmanPetronius,
      Piece.statesmanRicimer,
      Piece.statesmanMajorian,
      Piece.statesmanAegidius,
      Piece.statesmanLeoI,
      Piece.statesmanZeno,
      Piece.statesmanBasiliscus,
      Piece.statesmanOdoacer,
      Piece.statesmanTheodoric,
      Piece.statesmanAnastasius,
    ]);

    state.setupWarsPool([
      Piece.leaderAttila,
      Piece.leaderClovis,
      Piece.leaderGaiseric,
      Piece.warBurgundian11,
      Piece.warFrankish13,
      Piece.warFrankish11,
      Piece.warHunnic15,
      Piece.warHunnic14,
      Piece.warHunnic13,
      Piece.warIsaurian7,
      Piece.warMoorish5,
      Piece.warNubian4,
      Piece.warOstrogothic13,
      Piece.warOstrogothic11,
      Piece.warPersian13,
      Piece.warPersian11,
      Piece.warPictish6,
      Piece.warPictish4,
      Piece.warSaxon6,
      Piece.warSaxon4,
      Piece.warScottish5,
      Piece.warSuevian13,
      Piece.warSuevian11,
      Piece.warSuevian9,
      Piece.warVandal93,
      Piece.warVandal8,
      Piece.warVandal7,
      Piece.warVisigothic14,
      Piece.warVisigothic12,
      Piece.warVisigothic10,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceEpirus, ProvinceStatus.insurgent),
      (Location.provinceMoesiaI, ProvinceStatus.foederatiOstrogothic),
      (Location.provinceDaciaI, ProvinceStatus.barbarian),
      (Location.provinceDaciaII, ProvinceStatus.barbarian),
      (Location.provinceIsauria, ProvinceStatus.insurgent),
      (Location.provinceAethiopia, ProvinceStatus.barbarian),
      (Location.provinceAssyria, ProvinceStatus.barbarian),
      (Location.provinceBabylonia, ProvinceStatus.barbarian),
      (Location.provinceArmeniaI, ProvinceStatus.allied),
      (Location.provinceColchis, ProvinceStatus.allied),
      (Location.provinceAlbania, ProvinceStatus.barbarian),
      (Location.provinceCaucasia, ProvinceStatus.barbarian),
      (Location.provinceIberia, ProvinceStatus.barbarian),
      (Location.provinceBosporus, ProvinceStatus.barbarian),
      (Location.provinceGothiaI, ProvinceStatus.barbarian),
      (Location.provinceGothiaII, ProvinceStatus.barbarian),
      (Location.provinceBritanniaI, ProvinceStatus.allied),
      (Location.provinceBritanniaII, ProvinceStatus.allied),
      (Location.provinceValentia, ProvinceStatus.allied),
      (Location.provinceCaledonia, ProvinceStatus.barbarian),
      (Location.provinceHibernia, ProvinceStatus.barbarian),
      (Location.provinceBelgica, ProvinceStatus.insurgent),
      (Location.provinceLugdunensisII, ProvinceStatus.insurgent),
      (Location.provinceGermaniaI, ProvinceStatus.allied),
      (Location.provinceFrisia, ProvinceStatus.foederatiFrankish),
      (Location.provinceGermaniaII, ProvinceStatus.foederatiFrankish),
      (Location.provinceSuevia, ProvinceStatus.foederatiSuevian),
      (Location.provinceAquitaniaI, ProvinceStatus.foederatiVisigothic),
      (Location.provinceAquitaniaII, ProvinceStatus.foederatiVisigothic),
      (Location.provinceGermaniaIII, ProvinceStatus.barbarian),
      (Location.provinceCarthaginensis, ProvinceStatus.insurgent),
      (Location.provinceCeltiberia, ProvinceStatus.insurgent),
      (Location.provinceGallaecia, ProvinceStatus.foederatiSuevian),
      (Location.provinceBaetica, ProvinceStatus.foederatiVandal),
      (Location.provinceLusitania, ProvinceStatus.foederatiVandal),
      (Location.provinceDalmatia, ProvinceStatus.insurgent),
      (Location.provincePannoniaII, ProvinceStatus.foederatiOstrogothic),
      (Location.provinceBoiohaemia, ProvinceStatus.foederatiSuevian),
      (Location.provinceQuadia, ProvinceStatus.barbarian),
      (Location.provinceSarmatia, ProvinceStatus.barbarian),
  	]);

    state.setupPieces([
      (Location.provinceDardania, Piece.fort0),
      (Location.provinceDardania, Piece.fleet0),
      (Location.provinceAlexandria, Piece.pseudoLegion1),
      (Location.provinceAlexandria, Piece.auxilia0),
      (Location.provinceAlexandria, Piece.fleet1),
      (Location.provinceIsauria, Piece.pseudoLegion2),
      (Location.provinceMesopotamia, Piece.auxiliaVeteran1),
      (Location.provinceMesopotamia, Piece.auxilia2),
      (Location.provinceMesopotamia, Piece.fort3),
      (Location.provinceSyria, Piece.cavalryVeteran0),
      (Location.provinceSyria, Piece.guardVeteran0),
      (Location.provinceSyria, Piece.fleet2),
      (Location.provinceThebais, Piece.pseudoLegion4),
      (Location.provinceThebais, Piece.auxilia3),
      (Location.provinceArabiaI, Piece.fort5),
      (Location.provinceArabiaII, Piece.fort6),
      (Location.provinceEuphratensis, Piece.fort7),
      (Location.provincePalaestina, Piece.fort8),
      (Location.provincePhoenicia, Piece.fort9),
      (Location.provinceArmeniaII, Piece.fort10),
      (Location.provinceArmeniaII, Piece.fleet3),
      (Location.provinceArmeniaIV, Piece.fort11),
      (Location.provinceConstantinople, Piece.cavalryVeteran1),
      (Location.provinceConstantinople, Piece.guardVeteran1),
      (Location.provinceConstantinople, Piece.legionVeteran0),
      (Location.provinceConstantinople, Piece.auxilia4),
      (Location.provinceConstantinople, Piece.auxilia5),
      (Location.provinceConstantinople, Piece.fleetVeteran4),
      (Location.provinceMoesiaII, Piece.cavalry2),
      (Location.provinceMoesiaII, Piece.guard2),
      (Location.provinceMoesiaII, Piece.pseudoLegion12),
      (Location.provinceMoesiaII, Piece.auxilia6),
      (Location.provinceMoesiaII, Piece.auxilia7),
      (Location.provinceScythia, Piece.legionVeteran1),
      (Location.provinceScythia, Piece.auxilia8),
      (Location.provinceScythia, Piece.auxilia9),
      (Location.provinceScythia, Piece.fleet5),
      (Location.provinceAfrica, Piece.fleet6),
      (Location.provinceMauretaniaI, Piece.auxilia10),
      (Location.provinceMauretaniaI, Piece.fort13),
      (Location.provinceLugdunensisI, Piece.cavalryVeteran3),
      (Location.provinceLugdunensisI, Piece.guardVeteran3),
      (Location.provinceLugdunensisI, Piece.legion2),
      (Location.provinceLugdunensisI, Piece.auxilia11),
      (Location.provinceLugdunensisI, Piece.auxilia12),
      (Location.provinceTarraconensis, Piece.pseudoLegion14),
      (Location.provinceTarraconensis, Piece.auxilia13),
      (Location.provinceMediolanum, Piece.cavalryVeteran4),
      (Location.provinceMediolanum, Piece.guardVeteran4),
      (Location.provinceMediolanum, Piece.legion3),
      (Location.provinceMediolanum, Piece.auxilia14),
      (Location.provinceRavenna, Piece.guard5),
      (Location.provinceRavenna, Piece.fleet7),
      (Location.provinceRhaetia, Piece.fort15),
      (Location.provinceRhaetia, Piece.fleet8),
      (Location.provinceNoricum, Piece.fort16),
      (Location.provincePannoniaI, Piece.cavalry5),
      (Location.provincePannoniaI, Piece.pseudoLegion17),
      (Location.provincePannoniaI, Piece.auxilia15),
      (Location.boxBarracks, Piece.pseudoLegion18),
      (Location.boxBarracks, Piece.pseudoLegion19),
      (Location.boxBarracks, Piece.auxilia16),
      (Location.boxBarracks, Piece.auxilia17),
      (Location.boxBarracks, Piece.auxilia18),
      (Location.boxBarracks, Piece.auxilia19),
      (Location.boxBarracks, Piece.fleet9),
      (Location.boxBarracks, Piece.fleet10),
      (Location.boxBarracks, Piece.fleet11),
    ]);

    return state;
  }

  factory GameState.setup497CE() {

    var state = GameState();

    state._turn = 30;
    state.setEmpireGold(Location.commandEasternEmperor, 50);
    state.setEmpirePrestige(Location.commandEasternEmperor, 15);
    state.setEmpireUnrest(Location.commandEasternEmperor, 3);
    state.setEmpireGold(Location.commandWesternEmperor, 50);
    state.setEmpirePrestige(Location.commandWesternEmperor, 15);
    state.setEmpireUnrest(Location.commandWesternEmperor, 5);

	  state.setupStatesmen([
      (Piece.statesmanAnastasius, Location.commandEasternEmperor, 66),
      (Piece.statesmanTheodoric, Location.commandItalia, 43),
	  ]);

    state.setEmpireHasFallen(Location.commandWesternEmperor);

    state.setupLeaders([
      (Piece.leaderClovis, Location.homelandFrankish, 31),
    ]);

    state.setupDynasties([
      Piece.dynastyConstantinian,
      Piece.dynastyValentinian,
      Piece.dynastyTheodosian,
      Piece.dynastyLeonid,
    ]);

	  state.setupStatesmenPool([
      Piece.dynastyJustinian,
      Piece.statesmanJustinI,
      Piece.statesmanJustinianI,
      Piece.statesmanGermanus,
      Piece.statesmanTheodora,
      Piece.statesmanNarses,
      Piece.statesmanBelisarius,
      Piece.statesmanLiberius,
      Piece.statesmanTroglita,
      Piece.statesmanJustinII,
    ]);

    state.setupWarsPool([
      Piece.leaderChosroes,
      Piece.leaderTotila,
      Piece.warArabian5,
      Piece.warBulgar14,
      Piece.warBulgar12,
      Piece.warBurgundian11,
      Piece.warFrankish13,
      Piece.warFrankish11,
      Piece.warHunnic13,
      Piece.warMoorish7,
      Piece.warMoorish5,
      Piece.warOstrogothic13,
      Piece.warOstrogothic11,
      Piece.warPersian13,
      Piece.warPersian11,
      Piece.warSaxon6,
      Piece.warSaxon4,
      Piece.warSlav8,
      Piece.warVandal93,
      Piece.warVisigothic10,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceDaciaI, ProvinceStatus.barbarian),
      (Location.provinceDaciaII, ProvinceStatus.barbarian),
      (Location.provinceIsauria, ProvinceStatus.insurgent),
      (Location.provinceArabiaI, ProvinceStatus.allied),
      (Location.provinceAethiopia, ProvinceStatus.barbarian),
      (Location.provinceAssyria, ProvinceStatus.barbarian),
      (Location.provinceBabylonia, ProvinceStatus.barbarian),
      (Location.provinceArmeniaIV, ProvinceStatus.insurgent),
      (Location.provinceColchis, ProvinceStatus.allied),
      (Location.provinceIberia, ProvinceStatus.allied),
      (Location.provinceAlbania, ProvinceStatus.barbarian),
      (Location.provinceArmeniaI, ProvinceStatus.barbarian),
      (Location.provinceCaucasia, ProvinceStatus.barbarian),
      (Location.provinceBosporus, ProvinceStatus.barbarian),
      (Location.provinceGothiaI, ProvinceStatus.barbarian),
      (Location.provinceGothiaII, ProvinceStatus.barbarian),
      (Location.provinceAfrica, ProvinceStatus.foederatiVandal),
      (Location.provinceMauretaniaI, ProvinceStatus.foederatiVandal),
      (Location.provinceNumidia, ProvinceStatus.foederatiVandal),
      (Location.provinceTripolitania, ProvinceStatus.foederatiVandal),
      (Location.provinceBritanniaI, ProvinceStatus.allied),
      (Location.provinceValentia, ProvinceStatus.allied),
      (Location.provinceBritanniaII, ProvinceStatus.barbarian),
      (Location.provinceCaledonia, ProvinceStatus.barbarian),
      (Location.provinceHibernia, ProvinceStatus.barbarian),
      (Location.provinceAlpes, ProvinceStatus.allied),
      (Location.provinceAquitaniaII, ProvinceStatus.allied),
      (Location.provinceLugdunensisII, ProvinceStatus.allied),
      (Location.provinceBelgica, ProvinceStatus.foederatiFrankish),
      (Location.provinceGermaniaI, ProvinceStatus.foederatiFrankish),
      (Location.provinceGermaniaII, ProvinceStatus.foederatiFrankish),
      (Location.provinceGermaniaIII, ProvinceStatus.foederatiFrankish),
      (Location.provinceLugdunensisI, ProvinceStatus.foederatiFrankish),
      (Location.provinceSuevia, ProvinceStatus.foederatiFrankish),
      (Location.provinceAquitaniaI, ProvinceStatus.foederatiVisigothic),
      (Location.provinceNarbonensis, ProvinceStatus.foederatiVisigothic),
      (Location.provinceFrisia, ProvinceStatus.barbarian),
      (Location.provinceGallaecia, ProvinceStatus.foederatiSuevian),
      (Location.provinceLusitania, ProvinceStatus.foederatiSuevian),
      (Location.provinceBaleares, ProvinceStatus.foederatiVandal),
      (Location.provinceBaetica, ProvinceStatus.foederatiVisigothic),
      (Location.provinceCarthaginensis, ProvinceStatus.foederatiVisigothic),
      (Location.provinceCeltiberia, ProvinceStatus.foederatiVisigothic),
      (Location.provinceTarraconensis, ProvinceStatus.foederatiVisigothic),
      (Location.provinceMauretaniaII, ProvinceStatus.barbarian),
      (Location.provinceCorsicaSardinia, ProvinceStatus.foederatiVandal),
      (Location.provinceRhaetia, ProvinceStatus.foederatiSuevian),
      (Location.provinceMediolanum, ProvinceStatus.foederatiOstrogothic),
      (Location.provinceNeapolis, ProvinceStatus.foederatiOstrogothic),
      (Location.provincePisae, ProvinceStatus.foederatiOstrogothic),
      (Location.provinceRavenna, ProvinceStatus.foederatiOstrogothic),
      (Location.provinceRome, ProvinceStatus.foederatiOstrogothic),
      (Location.provinceSicilia, ProvinceStatus.foederatiOstrogothic),
      (Location.provinceSpoletium, ProvinceStatus.foederatiOstrogothic),
      (Location.provinceDalmatia, ProvinceStatus.foederatiOstrogothic),
      (Location.provinceNoricum, ProvinceStatus.foederatiOstrogothic),
      (Location.provincePannoniaI, ProvinceStatus.foederatiOstrogothic),
      (Location.provincePannoniaII, ProvinceStatus.foederatiOstrogothic),
      (Location.provinceBoiohaemia, ProvinceStatus.foederatiSuevian),
      (Location.provinceQuadia, ProvinceStatus.barbarian),
      (Location.provinceSarmatia, ProvinceStatus.barbarian),
  	]);

    state.setupPieces([
      (Location.provinceDardania, Piece.fort0),
      (Location.provinceDardania, Piece.fleet0),
      (Location.provinceMoesiaI, Piece.fort1),
      (Location.provinceAlexandria, Piece.fort2),
      (Location.provinceAlexandria, Piece.fleet1),
      (Location.provinceIsauria, Piece.auxilia0),
      (Location.provinceIsauria, Piece.auxilia1),
      (Location.provinceMesopotamia, Piece.auxilia2),
      (Location.provinceMesopotamia, Piece.auxilia3),
      (Location.provinceMesopotamia, Piece.fort3),
      (Location.provinceMesopotamia, Piece.fleet2),
      (Location.provinceSyria, Piece.cavalryVeteran0),
      (Location.provinceSyria, Piece.guardVeteran0),
      (Location.provinceSyria, Piece.auxilia4),
      (Location.provinceSyria, Piece.auxilia5),
      (Location.provinceSyria, Piece.fleet3),
      (Location.provinceArabiaII, Piece.fort4),
      (Location.provinceEuphratensis, Piece.fort5),
      (Location.provincePalaestina, Piece.fort6),
      (Location.provincePhoenicia, Piece.fort7),
      (Location.provinceThebais, Piece.fort8),
      (Location.provinceArmeniaII, Piece.fort9),
      (Location.provinceArmeniaII, Piece.fleet4),
      (Location.provinceArmeniaIV, Piece.auxilia6),
      (Location.provinceArmeniaIV, Piece.auxilia7),
      (Location.provinceArmeniaIV, Piece.fort10),
      (Location.provinceConstantinople, Piece.cavalryVeteran1),
      (Location.provinceConstantinople, Piece.guardVeteran1),
      (Location.provinceConstantinople, Piece.auxilia8),
      (Location.provinceConstantinople, Piece.auxilia9),
      (Location.provinceConstantinople, Piece.fleetVeteran5),
      (Location.provinceMoesiaII, Piece.fort11),
      (Location.provinceScythia, Piece.fort12),
      (Location.provinceScythia, Piece.fleet6),
      (Location.boxBarracks, Piece.cavalry2),
      (Location.boxBarracks, Piece.cavalry3),
      (Location.boxBarracks, Piece.cavalry4),
      (Location.boxBarracks, Piece.cavalry5),
      (Location.boxBarracks, Piece.guard2),
      (Location.boxBarracks, Piece.guard3),
      (Location.boxBarracks, Piece.guard4),
      (Location.boxBarracks, Piece.guard5),
      (Location.boxBarracks, Piece.pseudoLegion13),
      (Location.boxBarracks, Piece.pseudoLegion14),
      (Location.boxBarracks, Piece.pseudoLegion15),
      (Location.boxBarracks, Piece.auxilia10),
      (Location.boxBarracks, Piece.auxilia11),
      (Location.boxBarracks, Piece.auxilia12),
      (Location.boxBarracks, Piece.auxilia13),
      (Location.boxBarracks, Piece.auxilia14),
      (Location.boxBarracks, Piece.auxilia15),
      (Location.boxBarracks, Piece.auxilia16),
      (Location.boxBarracks, Piece.auxilia17),
      (Location.boxBarracks, Piece.auxilia18),
      (Location.boxBarracks, Piece.auxilia19),
      (Location.boxBarracks, Piece.fleet7),
      (Location.boxBarracks, Piece.fleet8),
      (Location.boxBarracks, Piece.fleet9),
      (Location.boxBarracks, Piece.fleet10),
      (Location.boxBarracks, Piece.fleet11),
    ]);

    state.setCommandAllegiance(Location.commandPannonia, Location.commandItalia);
    state.setCommandLoyalty(Location.commandItalia, false);
    state.setCommandLoyalty(Location.commandPannonia, false);

    return state;
  }

  factory GameState.setup565CE() {

    var state = GameState();

    state._turn = 40;
    state.setEmpireGold(Location.commandEasternEmperor, 50);
    state.setEmpirePrestige(Location.commandEasternEmperor, 25);
    state.setEmpireUnrest(Location.commandEasternEmperor, 1);
    state.setEmpireGold(Location.commandWesternEmperor, 50);
    state.setEmpirePrestige(Location.commandWesternEmperor, 25);
    state.setEmpireUnrest(Location.commandWesternEmperor, 2);

	  state.setupStatesmen([
      (Piece.statesmanJustinII, Location.commandEasternEmperor, 45),
	  ]);

    state.setEmpireHasFallen(Location.commandWesternEmperor);

    state.setupDynasties([
      Piece.dynastyConstantinian,
      Piece.dynastyValentinian,
      Piece.dynastyTheodosian,
      Piece.dynastyLeonid,
      Piece.dynastyJustinian,
    ]);

	  state.setupStatesmenPool([
      Piece.statesmanTiberiusII,
      Piece.statesmanMaurice,
      Piece.statesmanMystacon,
      Piece.statesmanComentiolus,
      Piece.statesmanPriscus,
      Piece.statesmanGregory,
      Piece.statesmanPhocas,
      Piece.statesmanBonus,
      Piece.statesmanSergius,
      Piece.statesmanHeraclius,
    ]);

    state.setupWarsPool([
      Piece.leaderBayan,
      Piece.leaderChosroes,
      Piece.warArabian5,
      Piece.warAvar15,
      Piece.warAvar13,
      Piece.warAvar11,
      Piece.warBulgar14,
      Piece.warBulgar12,
      Piece.warFrankish13,
      Piece.warFrankish11,
      Piece.warHunnic13,
      Piece.warMoorish7,
      Piece.warMoorish5,
      Piece.warNubian4,
      Piece.warPersian15,
      Piece.warPersian13,
      Piece.warPersian11,
      Piece.warSaxon6,
      Piece.warSlav8,
      Piece.warSlav6,
      Piece.warSuevian13,
      Piece.warSuevian11,
      Piece.warSuevian9,
      Piece.warVisigothic12,
      Piece.warVisigothic10,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceDaciaI, ProvinceStatus.barbarian),
      (Location.provinceDaciaII, ProvinceStatus.barbarian),
      (Location.provinceArabiaI, ProvinceStatus.allied),
      (Location.provinceAethiopia, ProvinceStatus.barbarian),
      (Location.provinceAssyria, ProvinceStatus.barbarian),
      (Location.provinceBabylonia, ProvinceStatus.barbarian),
      (Location.provinceColchis, ProvinceStatus.allied),
      (Location.provinceAlbania, ProvinceStatus.barbarian),
      (Location.provinceArmeniaI, ProvinceStatus.barbarian),
      (Location.provinceCaucasia, ProvinceStatus.barbarian),
      (Location.provinceIberia, ProvinceStatus.barbarian),
      (Location.provinceBosporus, ProvinceStatus.allied),
      (Location.provinceGothiaI, ProvinceStatus.barbarian),
      (Location.provinceGothiaII, ProvinceStatus.barbarian),
      (Location.provinceMauretaniaI, ProvinceStatus.insurgent),
      (Location.provinceBritanniaI, ProvinceStatus.barbarian),
      (Location.provinceBritanniaII, ProvinceStatus.barbarian),
      (Location.provinceCaledonia, ProvinceStatus.barbarian),
      (Location.provinceHibernia, ProvinceStatus.barbarian),
      (Location.provinceValentia, ProvinceStatus.barbarian),
      (Location.provinceAquitaniaII, ProvinceStatus.allied),
      (Location.provinceLugdunensisII, ProvinceStatus.allied),
      (Location.provinceNarbonensis, ProvinceStatus.foederatiVisigothic),
      (Location.provinceFrisia, ProvinceStatus.barbarian),
      (Location.provinceAlpes, ProvinceStatus.foederatiFrankish),
      (Location.provinceAquitaniaI, ProvinceStatus.foederatiFrankish),
      (Location.provinceBelgica, ProvinceStatus.foederatiFrankish),
      (Location.provinceGermaniaI, ProvinceStatus.foederatiFrankish),
      (Location.provinceGermaniaII, ProvinceStatus.foederatiFrankish),
      (Location.provinceGermaniaIII, ProvinceStatus.foederatiFrankish),
      (Location.provinceLugdunensisI, ProvinceStatus.foederatiFrankish),
      (Location.provinceSuevia, ProvinceStatus.foederatiFrankish),
      (Location.provinceMauretaniaII, ProvinceStatus.allied),
      (Location.provinceGallaecia, ProvinceStatus.foederatiSuevian),
      (Location.provinceCeltiberia, ProvinceStatus.foederatiVisigothic),
      (Location.provinceLusitania, ProvinceStatus.foederatiVisigothic),
      (Location.provinceTarraconensis, ProvinceStatus.foederatiVisigothic),
      (Location.provinceMediolanum, ProvinceStatus.insurgent),
      (Location.provinceRhaetia, ProvinceStatus.foederatiFrankish),
      (Location.provincePannoniaII, ProvinceStatus.allied),
      (Location.provinceNoricum, ProvinceStatus.foederatiSuevian),
      (Location.provincePannoniaI, ProvinceStatus.foederatiSuevian),
      (Location.provinceBoiohaemia, ProvinceStatus.barbarian),
      (Location.provinceQuadia, ProvinceStatus.barbarian),
      (Location.provinceSarmatia, ProvinceStatus.barbarian),
  	]);

    state.setupPieces([
      (Location.provinceDardania, Piece.auxilia0),
      (Location.provinceDardania, Piece.auxilia1),
      (Location.provinceDardania, Piece.fort0),
      (Location.provinceMoesiaI, Piece.fort1),
      (Location.provinceAlexandria, Piece.fort2),
      (Location.provinceAlexandria, Piece.fleet0),
      (Location.provinceMesopotamia, Piece.auxilia2),
      (Location.provinceMesopotamia, Piece.auxilia3),
      (Location.provinceMesopotamia, Piece.fort3),
      (Location.provinceMesopotamia, Piece.fleet1),
      (Location.provinceSyria, Piece.cavalryVeteran0),
      (Location.provinceSyria, Piece.guardVeteran0),
      (Location.provinceSyria, Piece.fleet2),
      (Location.provinceArabiaII, Piece.fort4),
      (Location.provinceEuphratensis, Piece.fort5),
      (Location.provincePalaestina, Piece.fort6),
      (Location.provincePhoenicia, Piece.fort7),
      (Location.provinceThebais, Piece.fort8),
      (Location.provinceArmeniaII, Piece.cavalry1),
      (Location.provinceArmeniaII, Piece.guard1),
      (Location.provinceArmeniaII, Piece.fort9),
      (Location.provinceArmeniaII, Piece.fleet3),
      (Location.provinceArmeniaIV, Piece.auxilia4),
      (Location.provinceArmeniaIV, Piece.auxilia5),
      (Location.provinceArmeniaIV, Piece.fort10),
      (Location.provinceConstantinople, Piece.cavalryVeteran2),
      (Location.provinceConstantinople, Piece.guardVeteran2),
      (Location.provinceConstantinople, Piece.auxilia6),
      (Location.provinceConstantinople, Piece.auxilia7),
      (Location.provinceConstantinople, Piece.fleetVeteran4),
      (Location.provinceMoesiaII, Piece.cavalry3),
      (Location.provinceMoesiaII, Piece.guard3),
      (Location.provinceMoesiaII, Piece.fort11),
      (Location.provinceScythia, Piece.fort12),
      (Location.provinceScythia, Piece.fleet5),
      (Location.provinceAfrica, Piece.fleet6),
      (Location.provinceMauretaniaI, Piece.auxilia8),
      (Location.provinceMauretaniaI, Piece.fort13),
      (Location.provinceRavenna, Piece.cavalry4),
      (Location.provinceRavenna, Piece.guard4),
      (Location.provinceRavenna, Piece.fleet7),
      (Location.boxBarracks, Piece.cavalry5),
      (Location.boxBarracks, Piece.guard5),
      (Location.boxBarracks, Piece.pseudoLegion14),
      (Location.boxBarracks, Piece.pseudoLegion15),
      (Location.boxBarracks, Piece.auxilia9),
      (Location.boxBarracks, Piece.auxilia10),
      (Location.boxBarracks, Piece.auxilia11),
      (Location.boxBarracks, Piece.auxilia12),
      (Location.boxBarracks, Piece.auxilia13),
      (Location.boxBarracks, Piece.auxilia14),
      (Location.boxBarracks, Piece.auxilia15),
      (Location.boxBarracks, Piece.auxilia16),
      (Location.boxBarracks, Piece.auxilia17),
      (Location.boxBarracks, Piece.auxilia18),
      (Location.boxBarracks, Piece.auxilia19),
      (Location.boxBarracks, Piece.fleet8),
      (Location.boxBarracks, Piece.fleet9),
      (Location.boxBarracks, Piece.fleet10),
      (Location.boxBarracks, Piece.fleet11),
    ]);

    return state;
  }

  factory GameState.fromScenario(Scenario scenario) {
    GameState? gameState;
    switch (scenario) {
    case Scenario.from286CeTo363Ce:
  	case Scenario.from286CeTo425Ce:
	  case Scenario.from286CeTo497Ce:
	  case Scenario.from286CeTo565Ce:
    case Scenario.from286CeTo629Ce:
      gameState = GameState.setup286CE();
	  case Scenario.from363CeTo425Ce:
	  case Scenario.from363CeTo497Ce:
  	case Scenario.from363CeTo565Ce:
    case Scenario.from363CeTo629Ce:
		  gameState = GameState.setup363CE();
	  case Scenario.from425CeTo497Ce:
  	case Scenario.from425CeTo565Ce:
    case Scenario.from425CeTo629Ce:
		  gameState = GameState.setup425CE();
	  case Scenario.from497CeTo565Ce:
    case Scenario.from497CeTo629Ce:
		  gameState = GameState.setup497CE();
    case Scenario.from565CeTo629Ce:
      gameState = GameState.setup565CE();
    }
    return gameState;
  }
}

enum Choice {
  transferGoldEastToWest,
  transferGoldWestToEast,
  extraTaxesWest,
  extraTaxesEast,
  breadAndCircusesPrestigeWest,
  breadAndCircusesPrestigeEast,
  breadAndCircusesUnrestWest,
  breadAndCircusesUnrestEast,
  fightWar,
  fightWarsForego,
  fightRebelsForego,
  lossDestroy,
  lossDismiss,
  lossDemote,
  lossUnrest,
  lossPrestige,
  lossTribute,
  lossRevolt,
  decreaseUnrest,
  increasePrestige,
  addGold,
  promote,
  annex,
  roman,
  frankish,
  ostrogothic,
  suevian,
  vandal,
  visigothic,
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
  majorDefeat,
  minorDefeat,
  draw,
  minorVictory,
  majorVictory,
}

enum GameResultCause {
  endured,
  fallen,
  bankrupt,
  revolution,
  lostCapital,
}

class GameOutcome {
  GameResult westernResult;
  GameResultCause westernCause;
  int westernPrestige;
  GameResult easternResult;
  GameResultCause easternCause;
  int easternPrestige;

  GameOutcome(
    this.westernResult, this.westernCause, this.westernPrestige,
    this.easternResult, this.easternCause, this.easternPrestige);

  GameOutcome.fromJson(Map<String, dynamic> json) :
    westernResult = GameResult.values[json['westernResult'] as int],
    westernCause = GameResultCause.values[json['westernCause'] as int],
    westernPrestige = json['westernPrestige'] as int,
    easternResult = GameResult.values[json['easternResult'] as int],
    easternCause = GameResultCause.values[json['easternCause'] as int],
    easternPrestige = json['easternPrestige'] as int;

  Map<String, dynamic> toJson() => {
    'westernResult': westernResult.index,
    'westernCause': westernCause.index,
    'westernPrestige': westernPrestige,
    'easternResult': easternResult.index,
    'easternCause': easternCause.index,
    'easternPrestige': easternPrestige,
  };
}

class GameOverException implements Exception {
  GameOutcome outcome;

  GameOverException(
    GameResult westernResult, GameResultCause westernCause, int westernPrestige,
    GameResult easternResult, GameResultCause easternCause, int easternPrestige)
    : outcome = GameOutcome(
      westernResult, westernCause, westernPrestige,
      easternResult, easternCause, easternPrestige);
}

class GameOptions {
	int eventCountModifier = 0;
  int taxRollModifier = 0;
	int warRollModifier = 0;
	int dismissAuxiliaCount = 2;
	int tributeAmount = 10;
	bool finiteLifetimes = false;

  GameOptions();

  GameOptions.fromJson(Map<String, dynamic> json) {
    eventCountModifier = json['eventCountModifier'] as int;
    taxRollModifier = json['taxRollModifier'] as int;
    warRollModifier = json['warRollModifier'] as int;
    dismissAuxiliaCount = json['dismissAuxiliaCount'] as int;
    tributeAmount = json['tributeAmount'] as int;
    finiteLifetimes = json['finiteLifetimes'] as bool;
  }

  Map<String, dynamic> toJson() => {
    'eventCountModifier': eventCountModifier,
    'taxRollModifier': taxRollModifier,
    'warRollModifier': warRollModifier,
    'dismissAuxiliaCount': dismissAuxiliaCount,
    'tributeAmount': tributeAmount,
    'finiteLifetimes': finiteLifetimes,
  };

  String get desc {
    String optionsList = '';
    if (eventCountModifier != 0) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      if (eventCountModifier > 0) {
        optionsList += 'Events: +$eventCountModifier';
      } else {
        optionsList += 'Events: $eventCountModifier';
      }
    }
    if (taxRollModifier != 0) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      if (taxRollModifier > 0) {
        optionsList += 'Tax Rolls: +$taxRollModifier';
      } else {
        optionsList += 'Tax Rolls: $taxRollModifier';
      }
    }
    if (warRollModifier != 0) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      if (warRollModifier > 0) {
        optionsList += 'War Rolls: +$warRollModifier';
      } else {
        optionsList += 'War Rolls: $warRollModifier';
      }
    }
    if (dismissAuxiliaCount != 2) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Dismiss Auxilia: $dismissAuxiliaCount';
    }
    if (tributeAmount != 10) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Tribute: $tributeAmount';
    }
    if (finiteLifetimes) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Finite Lifetimes';
    }
    return optionsList;
  }
}

enum EmperorDeathCause {
  mortality,
  rebelEmperorDefeat,
  rebelEmperorVictory,
  rebelGovernorVictory,
  noLoyalProvinces,
  assassination,
  disaster,
  leader,
  empireFell,
}

enum Phase {
  event,
  treasury,
  unrest,
  war,
}

abstract class PhaseState {
  Phase get phase;
  Map<String, dynamic> toJson();
}

class PhaseStateEvent extends PhaseState {
  int eventsRemainingCount = 0;
  EventType? eventType;
  List<Location> emperorMortalities = [];
  List<Piece> assassins = [];
  Location? assassinTargetCommand;
  Piece? assassinTargetStatesman;
  List<Piece> remainingFoederatiWars = [];

  PhaseStateEvent();

  PhaseStateEvent.fromJson(Map<String, dynamic> json) {
    eventsRemainingCount = json['eventsRemainingCount'] as int;
    final eventTypeIndex = json['eventType'] as int?;
    if (eventTypeIndex != null) {
      eventType = EventType.values[eventTypeIndex];
    } else {
      eventType = null;
    }
    emperorMortalities = locationListFromIndices(List<int>.from(json['emperorMortalities']));
    assassins = pieceListFromIndices(List<int>.from(json['assassins']));
    assassinTargetCommand = locationFromIndex(json['assassinTargetCommand']);
    assassinTargetStatesman = pieceFromIndex(json['assassinTargetStatesman']);
  }

  @override
  Map<String, dynamic> toJson() => {
    'eventsRemainingCount': eventsRemainingCount,
    'eventType': eventType?.index,
    'emperorMortalities': locationListToIndices(emperorMortalities),
    'assassins': pieceListToIndices(assassins),
    'assassinTargetCommand': locationToIndex(assassinTargetCommand),
    'assassinTargetStatesman': pieceToIndex(assassinTargetStatesman),
  };

  @override
  Phase get phase {
    return Phase.event;
  }
}

class PhaseStateTreasury extends PhaseState {
  List<List<Location>> warTrails = List<List<Location>>.generate(PieceType.war.count, (_) => []);
  List<bool> warUnmoveds = List<bool>.filled(PieceType.war.count, false);
  int warsRemainingCount = 0;
  Location? taxEmpire;
  Location? zenoEmpire;

  PhaseStateTreasury();

  PhaseStateTreasury.fromJson(Map<String, dynamic> json) {
    final warTrailsJson = json['warTrails'];
    warTrails = <List<Location>>[];
    for (int i = 0; i < warTrailsJson.length; ++i) {
      final warTrailIndices = List<int>.from(warTrailsJson[i]);
      warTrails.add(locationListFromIndices(warTrailIndices));
    }
    warUnmoveds = List<bool>.from(json['warUnmoveds']);
    warsRemainingCount = json['warsRemainingCount'] as int;
    taxEmpire = locationFromIndex(json['taxEmpire'] as int?);
    zenoEmpire = locationFromIndex(json['zenoEmpire'] as int?);
  }

  @override
  Map<String, dynamic> toJson() {
    final warTrailIndices = <List<int>>[];
    for (int i = 0; i < warTrails.length; ++i) {
      warTrailIndices.add(locationListToIndices(warTrails[i]));
    }

    return <String, dynamic>{
      'warTrails': warTrailIndices,
      'warUnmoveds': warUnmoveds,
      'warsRemainingCount': warsRemainingCount,
      'taxEmpire': locationToIndex(taxEmpire),
      'zenoEmpire': locationToIndex(zenoEmpire),
    };
  }

  @override
  Phase get phase {
    return Phase.treasury;
  }

  List<Location> warTrail(Piece war) {
    return warTrails[war.index - PieceType.war.firstIndex];
  }

  bool warUnmoved(Piece war) {
    return warUnmoveds[war.index - PieceType.war.firstIndex];
  }

  void setWarUnmoved(Piece war, bool unmoved) {
    warUnmoveds[war.index - PieceType.war.firstIndex] = unmoved;
  }

  int get unmovedWarCount {
    return warUnmoveds.where((unmoved) => unmoved).length;
  }

  Piece get drawnWar {
    for (int i = 0; i < warUnmoveds.length; ++i) {
      if (warUnmoveds[i]) {
        return Piece.values[PieceType.war.firstIndex + i];
      }
    }
    return Piece.dynastyConstantinian;
  }
}

class PhaseStateUnrest extends PhaseState {
  List<int> empireAnnexRemainingCounts = [0, 0];
  List<int> breadAndCircusesPrestigeCounts = [0, 0];
  Location? transferEmpire;
  Location? transferGovernorship;

  PhaseStateUnrest();

  PhaseStateUnrest.fromJson(Map<String, dynamic> json) {
    empireAnnexRemainingCounts = List<int>.from(json['empireAnnexRemainingCounts']); 
    breadAndCircusesPrestigeCounts = List<int>.from(json['breadAndCircusesPrestigeCounts']);
    transferEmpire = locationFromIndex(json['transferEmpire'] as int?);
    transferGovernorship = locationFromIndex(json['transferGovernorship'] as int?);
  }

  @override
  Map<String, dynamic> toJson() => {
    'empireAnnexRemainingCounts': empireAnnexRemainingCounts,
    'breadAndCircusesPrestigeCounts': breadAndCircusesPrestigeCounts,
    'transferEmpire': locationToIndex(transferEmpire),
    'transferGovernorship': locationToIndex(transferGovernorship),
  };

  @override
  Phase get phase {
    return Phase.unrest;
  }
}

class PhaseStateWar extends PhaseState {
  List<Location> revoltProvinces = <Location>[];
  List<ProvinceStatus> revoltProvinceStatuses = <ProvinceStatus>[];

  List<Piece> warsFought = <Piece>[];
  List<Location> rebelsFought = <Location>[];
  List<Location> commandsFought = <Location>[];
  List<Location> provincesFought = <Location>[];
  List<Piece> unitsFought = <Piece>[];

  Piece? war;
  Location? province;
  Location? command;
  Location? empire;
  Location? deadEmperor;
  List<Location> provinces = <Location>[];
  List<Piece> units = <Piece>[];
  List<Piece> rebelUnits = <Piece>[];

  bool triumph = false;
  int lossCount = 0;
  int destroyLegionsCount = 0;
  int promoteCount = 0;
  int anyPromoteCount = 0;
  int rebelPromoteCount = 0;
  int annexCount = 0;
  int prestige = 0;
  int unrest = 0;
  int gold = 0;
  int rebelGold = 0;

  int demoteCount = 0;
  int destroyCount = 0;
  int disgraceCount = 0;
  int dishonorCount = 0;
  int dismissCount = 0;
  int revoltCount = 0;
  int tributeCount = 0;

  PhaseStateWar();

  PhaseStateWar.fromJson(Map<String, dynamic> json) {
    revoltProvinces = locationListFromIndices(List<int>.from(json['revoltProvinces']));
    revoltProvinceStatuses = provinceStatusListFromIndices(List<int>.from(json['revoltProvinceStatuses']));

    warsFought = pieceListFromIndices(List<int>.from(json['warsFought']));
    rebelsFought = locationListFromIndices(List<int>.from(json['rebelsFought']));
    commandsFought = locationListFromIndices(List<int>.from(json['commandsFought']));
    provincesFought = locationListFromIndices(List<int>.from(json['provincesFought']));
    unitsFought = pieceListFromIndices(List<int>.from(json['unitsFought']));
    war = pieceFromIndex(json['war'] as int?);
    province = locationFromIndex(json['province'] as int?);
    command = locationFromIndex(json['command'] as int?);
    empire = locationFromIndex(json['empire'] as int?);
    deadEmperor = locationFromIndex(json['deadEmperor'] as int?);
    provinces = locationListFromIndices(List<int>.from(json['provinces']));
    units = pieceListFromIndices(List<int>.from(json['units']));
    rebelUnits = pieceListFromIndices(List<int>.from(json['rebelUnits']));

    triumph = json['triumph'] as bool;
    lossCount = json['lossCount'] as int;
    destroyLegionsCount = json['destroyLegionsCount'] as int;
    promoteCount = json['promoteCount'] as int;
    anyPromoteCount = json['anyPromoteCount'] as int;
    rebelPromoteCount = json['rebelPromoteCount'] as int;
    annexCount = json['annexCount'] as int;
    prestige = json['prestige'] as int;
    unrest = json['unrest'] as int;
    gold = json['gold'] as int;
    rebelGold = json['rebelGold'] as int;

    demoteCount = json['demoteCount'] as int;
    destroyCount = json['destroyCount'] as int;
    disgraceCount = json['disgraceCount'] as int;
    dishonorCount = json['dishonorCount'] as int;
    dismissCount = json['dismissCount'] as int;
    revoltCount = json['revoltCount'] as int;
    tributeCount = json['tributeCount'] as int;
  }

  @override
  Map<String, dynamic> toJson() => {
    'revoltProvinces': locationListToIndices(revoltProvinces),
    'revoltProvinceStatuses': provinceStatusListToIndices(revoltProvinceStatuses),
    'warsFought': pieceListToIndices(warsFought),
    'rebelsFought': locationListToIndices(rebelsFought),
    'commandsFought': locationListToIndices(commandsFought),
    'provincesFought': locationListToIndices(provincesFought),
    'unitsFought': pieceListToIndices(unitsFought),
    'war': pieceToIndex(war),
    'province': locationToIndex(province),
    'command': locationToIndex(command),
    'empire': locationToIndex(empire),
    'deadEmperor': locationToIndex(deadEmperor),
    'provinces': locationListToIndices(provinces),
    'units': pieceListToIndices(units),
    'rebelUnits': pieceListToIndices(rebelUnits),
    'triumph': triumph,
    'lossCount': lossCount,
    'destroyLegionsCount': destroyLegionsCount,
    'promoteCount': promoteCount,
    'anyPromoteCount': anyPromoteCount,
    'rebelPromoteCount': rebelPromoteCount,
    'annexCount': annexCount,
    'prestige': prestige,
    'unrest': unrest,
    'gold': gold,
    'rebelGold': rebelGold,
    'demoteCount': demoteCount,
    'destroyCount': destroyCount,
    'disgraceCount': disgraceCount,
    'dishonorCount': dishonorCount,
    'dismissCount': dismissCount,
    'revoltCount': revoltCount,
    'tributeCount': tributeCount,
  };

  @override
  Phase get phase {
    return Phase.war;
  }

  void cancelWar() {
    war = null;
    province = null;
    command = null;
    empire = null;
    provinces.clear();
    units.clear();
  }

  void warComplete(bool commandComplete) {
    if (war != null) {
      warsFought.add(war!);
    }
    if (commandComplete) {
      commandsFought.add(command!);
    }
    provincesFought += provinces;
    unitsFought += units;

    war = null;
    province = null;
    command = null;
    empire = null;
    deadEmperor = null;
    provinces.clear();
    units.clear();

    triumph = false;
    lossCount = 0;
    destroyLegionsCount = 0;
    promoteCount = 0;
    annexCount = 0;
    prestige = 0;
    unrest = 0;
    gold = 0;
    rebelGold = 0;

    demoteCount = 0;
    destroyCount = 0;
    disgraceCount = 0;
    dishonorCount = 0;
    dismissCount = 0;
    revoltCount = 0;
    tributeCount = 0;
  }

  void clearWars() {
    warsFought.clear();
    commandsFought.clear();
    provincesFought.clear();
    unitsFought.clear();
  }

  void civilWarComplete() {
    rebelsFought.add(command!);

    command = null;
    empire = null;
    deadEmperor = null;
    units.clear();
    rebelUnits.clear();

    lossCount = 0;
    promoteCount = 0;
    anyPromoteCount = 0;
    rebelPromoteCount = 0;

    demoteCount = 0;
    destroyCount = 0;
    disgraceCount = 0;
    dishonorCount = 0;
    dismissCount = 0;
    tributeCount = 0;
  }

  void clearRebels() {
    commandsFought.clear();
  }

  List<Piece> candidateDestroyLegions(GameState state) {
    final candidates = <Piece>[];
    for (final unit in units) {
      if (unit.isType(PieceType.legion) && state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    if (candidates.isEmpty) {
      for (final unit in units) {
        if (unit.isType(PieceType.pseudoLegion) && state.unitInPlay(unit)) {
          candidates.add(unit);
        }
      }
    }
    return candidates;
  }

  List<Piece> candidateDestroyCivilWarLegions(GameState state) {
    final candidates = <Piece>[];
    for (final unit in units) {
      if (unit.isType(PieceType.legion) && state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    for (final unit in rebelUnits) {
      if (unit.isType(PieceType.legion) && state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    if (candidates.isEmpty) {
      for (final unit in units) {
        if (unit.isType(PieceType.pseudoLegion) && state.unitInPlay(unit)) {
          candidates.add(unit);
        }
      }
      for (final unit in rebelUnits) {
        if (unit.isType(PieceType.pseudoLegion) && state.unitInPlay(unit)) {
          candidates.add(unit);
        }
      }
    }
    return candidates;
  }

  List<Piece> candidateDismissUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in units) {
      if (!unit.isType(PieceType.legionaries) && state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidateDismissCivilWarUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in units) {
      if (!unit.isType(PieceType.legionaries) && state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    for (final unit in rebelUnits) {
      if (!unit.isType(PieceType.legionaries) && state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidateDemoteUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in units) {
      if (state.unitInPlay(unit) && state.unitDemotable(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidateDemoteCivilWarUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in units) {
      if (state.unitInPlay(unit) && state.unitDemotable(unit)) {
        candidates.add(unit);
      }
    }
    for (final unit in rebelUnits) {
      if (state.unitInPlay(unit) && state.unitDemotable(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidatePromoteUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in units) {
      if (state.unitInPlay(unit) && state.unitPromotable(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidatePromoteAnyUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in units) {
      if (state.unitInPlay(unit) && state.unitPromotable(unit)) {
        candidates.add(unit);
      }
    }
    for (final unit in rebelUnits) {
      if (state.unitInPlay(unit) && state.unitPromotable(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidatePromoteRebelUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in rebelUnits) {
      if (state.unitInPlay(unit) && state.unitPromotable(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Location> candidateRevoltProvinces(GameState state) {
    final candidates = <Location>[];
    final spaces = state.spaceConnectedSpaces(province!);
		spaces.add(province!);
		for (final space in spaces) {
			if (space.isType(LocationType.province) && state.provinceStatus(space) != ProvinceStatus.barbarian) {
				candidates.add(space);
			}
		}
    return candidates;
  }

  List<Location> candidateAnnexProvinces(GameState state) {
    final candidates = <Location>[];
    final spaces = state.spaceConnectedSpaces(province!);
		spaces.add(province!);
		for (final space in spaces) {
      if (state.spaceCanBeAnnexed(space, <Enemy>[])) {
				candidates.add(space);
			}
		}
    return candidates;
  }
}

class AssassinationAttemptState {
  int subStep = 0;

  AssassinationAttemptState();

  AssassinationAttemptState.fromJson(Map<String, dynamic> json) {
    subStep = json['subStep'] as int;
  }

  Map<String, dynamic> toJson() => {
    'subStep': subStep,
  };
}

class EventAssassinState {
  Location? assassinCommand;
  Location? targetCommand;
  Piece? targetStatesman;

  EventAssassinState();

  EventAssassinState.fromJson(Map<String, dynamic> json) {
    assassinCommand = locationFromIndex(json['assassinCommand'] as int?);
    targetCommand = locationFromIndex(json['targetCommand'] as int?);
    targetStatesman = pieceFromIndex(json['targetStatesman'] as int?);
  }

  Map<String, dynamic> toJson() => {
    'assassinCommand': locationToIndex(assassinCommand),
    'targetCommand': locationToIndex(targetCommand),
    'targetStatesman': pieceToIndex(targetStatesman),
  };
}

class NewEmperorState {
  int subStep = 0;
  List<Location> emperorVacancies = [];
  int vacancyIndex = 0;

  NewEmperorState();

  NewEmperorState.fromJson(Map<String, dynamic> json) {
    subStep = json['subStep'] as int;
    emperorVacancies = locationListFromIndices(List<int>.from(json['emperorVacancies']));
    vacancyIndex = json['vacancyIndex'] as int;
  }

  Map<String, dynamic> toJson() => {
    'subStep': subStep,
    'emperorVacancies': locationListToIndices(emperorVacancies),
    'vacancyIndex': vacancyIndex,
  };
}

class Game {
  final Scenario _scenario;
  int _firstTurn = 0;
  int _turnCount = 0;
  int _startYear = 0;
  int _endYear = 0;
  final GameState _state;
  int _step = 0;
  int _subStep = 0;
  GameOutcome? _outcome;
  final GameOptions _options;
  String _log = '';
  PlayerChoiceInfo _choiceInfo = PlayerChoiceInfo();
  PhaseState? _phaseState;
  AssassinationAttemptState? _assassinationAttemptState;
  EventAssassinState? _eventAssassinState;
  NewEmperorState? _newEmperorState;
  final Random _random;
  final int _gameId;

  Game(this._gameId, this._scenario, this._options, this._state, this._random)
  : _choiceInfo = PlayerChoiceInfo() {
    _setScenarioInfo();
  }

  Game.inProgress(this._gameId, this._scenario, this._options, this._state, this._random, this._step, this._subStep, this._log, Map<String, dynamic> gameStateJson) {
    _setScenarioInfo();
    _gameStateFromJson(gameStateJson);
  }

  Game.completed(this._gameId, this._scenario, this._options, this._state, this._random, this._step, this._subStep, this._log, Map<String, dynamic> gameOutcomeJson) {
    _setScenarioInfo();
    _outcome = GameOutcome.fromJson(gameOutcomeJson);
  }

  Game.snapshot(this._gameId, this._scenario, this._options, this._state, this._random, this._step, this._subStep, this._log) {
    _setScenarioInfo();
  }

  void _setScenarioInfo() {
    switch (_scenario) {
    case Scenario.from286CeTo363Ce:
      _firstTurn = 0;
		  _turnCount = 10;
		  _startYear = 286;
		  _endYear = 363;
	  case Scenario.from363CeTo425Ce:
      _firstTurn = 10;
		  _turnCount = 10;
		  _startYear = 363;
		  _endYear = 425;
	  case Scenario.from425CeTo497Ce:
		  _firstTurn = 20;
		  _turnCount = 10;
		  _startYear = 425;
		  _endYear = 497;
	  case Scenario.from497CeTo565Ce:
		  _firstTurn = 30;
		  _turnCount = 10;
		  _startYear = 497;
		  _endYear = 565;
    case Scenario.from565CeTo629Ce:
      _firstTurn = 40;
      _turnCount = 10;
      _startYear = 565;
      _endYear = 629;
  	case Scenario.from286CeTo425Ce:
		  _firstTurn = 0;
		  _turnCount = 20;
		  _startYear = 286;
		  _endYear = 425;
	  case Scenario.from363CeTo497Ce:
		  _firstTurn = 10;
		  _turnCount = 20;
		  _startYear = 363;
		  _endYear = 497;
  	case Scenario.from425CeTo565Ce:
		  _firstTurn = 20;
  		_turnCount = 20;
	  	_startYear = 425;
		  _endYear = 565;
    case Scenario.from497CeTo629Ce:
      _firstTurn = 30;
      _turnCount = 20;
      _startYear = 497;
      _endYear = 629;
	  case Scenario.from286CeTo497Ce:
      _firstTurn = 0;
      _turnCount = 30;
      _startYear = 286;
      _endYear = 497;
  	case Scenario.from363CeTo565Ce:
		  _firstTurn = 10;
      _turnCount = 30;
      _startYear = 363;
      _endYear = 565;
    case Scenario.from425CeTo629Ce:
      _firstTurn = 20;
      _turnCount = 30;
      _startYear = 425;
      _endYear = 629;
	  case Scenario.from286CeTo565Ce:
		  _firstTurn = 0;
      _turnCount = 40;
      _startYear = 286;
      _endYear = 565;
    case Scenario.from363CeTo629Ce:
      _firstTurn = 10;
      _turnCount = 40;
      _startYear = 363;
      _endYear = 629;
    case Scenario.from286CeTo629Ce:
      _firstTurn = 0;
      _turnCount = 50;
      _startYear = 286;
      _endYear = 629;
    }
  }

  void _gameStateFromJson(Map<String, dynamic> json) {
    _phaseState = null;
    final phaseIndex = json['phase'] as int?;
    if (phaseIndex != null) {
      final phaseStateJson = json['phaseState'];
      switch (Phase.values[phaseIndex]) {
      case Phase.event:
        _phaseState = PhaseStateEvent.fromJson(phaseStateJson);
      case Phase.treasury:
        _phaseState = PhaseStateTreasury.fromJson(phaseStateJson);
      case Phase.unrest:
        _phaseState = PhaseStateUnrest.fromJson(phaseStateJson);
      case Phase.war:
        _phaseState = PhaseStateWar.fromJson(phaseStateJson);
      }
    }

    final assassinationAttemptStateJson = json['assassinationAttempt'];
    if (assassinationAttemptStateJson != null) {
      _assassinationAttemptState = AssassinationAttemptState.fromJson(assassinationAttemptStateJson);
    }
    final eventAssassinStateJson = json['eventAssassin'];
    if (eventAssassinStateJson != null) {
      _eventAssassinState = EventAssassinState.fromJson(eventAssassinStateJson);
    }
    final newEmperorStateJson = json['newEmperor'];
    if (newEmperorStateJson != null) {
      _newEmperorState = NewEmperorState.fromJson(newEmperorStateJson);
    }

    _choiceInfo = PlayerChoiceInfo.fromJson(json['choiceInfo']);
  }

  Map<String, dynamic> gameStateToJson() {
    final map = <String, dynamic>{};
    if (_phaseState != null) {
      map['phase'] = _phaseState!.phase.index;
      map['phaseState'] = _phaseState!.toJson();
    }
    if (_assassinationAttemptState != null) {
      map['assassinationAttempt'] = _assassinationAttemptState!.toJson();
    }
    if (_eventAssassinState != null) {
      map['eventAssassin'] = _eventAssassinState!.toJson();
    }
    if (_newEmperorState != null) {
      map['newEmperor'] = _newEmperorState!.toJson();
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
      _state.turn,
      yearDesc(_state.turn),
      _log);
  }

  Future<void> saveCurrentState() async {
    await GameDatabase.instance.setGameState(
      _gameId,
      jsonEncode(_state.toJson()),
      jsonEncode(randomToJson(_random)),
      _step, _subStep,
      _state.turn,
      yearDesc(_state.turn),
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

  (int,int,int,int) roll2D6() {
    int value = _random.nextInt(36);
    int d0 = value ~/ 6;
    value -= d0 * 6;
    int d1 = value;
    d0 += 1;
    d1 += 1;
    int omensCount = _state.eventTypeCount(EventType.omens);
    int omensModifier = 0;
    if (omensCount == 1) {
      omensModifier = 1;
    } else if (omensCount == 2) {
      omensModifier = -1;
    }
    logLine('> Roll: **${dieFaceCharacter(d0)}${dieFaceCharacter(d1)}**');
    if (omensModifier == 1) {
      logLine('> Omens Event: +1');
    } else if (omensModifier == -1) {
      logLine('> Omens Event (doubled): -1');
    }
    return (d0, d1, omensModifier, d0 + d1 + omensModifier);
  }

  (int,int,int,int,int) roll3D6() {
    int value = _random.nextInt(216);
    int d0 = value ~/ 36;
    value -= d0 * 36;
    int d1 = value ~/ 6;
    value -= d1 * 6;
    int d2 = value;
    d0 += 1;
    d1 += 1;
    d2 += 1;
    int omensCount = _state.eventTypeCount(EventType.omens);
    int omensModifier = 0;
    if (omensCount == 1) {
      omensModifier = 1;
    } else if (omensCount == 2) {
      omensModifier = -1;
    }
    logLine('> Roll: **${dieFaceCharacter(d0)}${dieFaceCharacter(d1)}${dieFaceCharacter(d2)}**');
    if (omensModifier == 1) {
      logLine('> Omens Event: +1');
    } else if (omensModifier == -1) {
      logLine('> Omens Event (doubled): -1');
    }
    return (d0, d1, d2, omensModifier, d0 + d1 + d2 + omensModifier);
  }

  (int,int) rollD6D3() {
    int value = _random.nextInt(18);
    int d0 = value ~/ 3 + 1;
    int d1 = value % 3 + 1;
    logLine('> Roll: **${dieFaceCharacter(d0)}${dieFaceCharacter(d1)}**');
    return (d0, d1);
  }

  (int,int) rollD6D2(bool d2Required) {
    int value = _random.nextInt(12);
    int d0 = value ~/ 2 + 1;
    int d1 = value % 2 + 1;
    if (d2Required) {
      logLine('> Roll: **${dieFaceCharacter(d0)}${dieFaceCharacter(d1)}**');
    } else {
      logLine('> Roll: **${dieFaceCharacter(d0)}**');
    }
    return (d0, d1);
  }

  int rollD3() {
    int die = _random.nextInt(3) + 1;
    logLine('> Roll: **${dieFaceCharacter(die)}**');
    return die;
  }

  int rollD2() {
    int die = _random.nextInt(2) + 1;
    logLine('> Roll: **${dieFaceCharacter(die)}**');
    return die;
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

  Location randEmperor() {
    final emperors = _state.activeEmperors;
    return randLocation(emperors)!;
  }

  Location randGovernorship() {
    final governorships = _state.activeGovernorships;
    return randLocation(governorships)!;
  }

  Location randEmpireGovernor(Location empire) {
    final governors = <Location>[];
    for (final governorship in _state.activeGovernorships) {
      if (_state.commandEmpire(governorship) == empire && _state.commandAllegiance(governorship) == governorship) {
        governors.add(governorship);
      }
    }
    return randLocation(governors)!;
  }

  void setProvinceStatus(Location province, ProvinceStatus status) {
    _state.setProvinceStatus(province, status);
    logLine('> ${province.desc} to ${GameState.provinceStatusName(status)}.');
  }

  void provinceIncreaseStatus(Location province) {
    switch (_state.provinceStatus(province)) {
    case ProvinceStatus.barbarian:
    case ProvinceStatus.foederatiFrankish:
    case ProvinceStatus.foederatiOstrogothic:
    case ProvinceStatus.foederatiSuevian:
    case ProvinceStatus.foederatiVandal:
    case ProvinceStatus.foederatiVisigothic:
      setProvinceStatus(province, ProvinceStatus.allied);
    case ProvinceStatus.allied:
      setProvinceStatus(province, ProvinceStatus.insurgent);
    case ProvinceStatus.insurgent:
      setProvinceStatus(province, ProvinceStatus.roman);
    case ProvinceStatus.roman:
    }
  }

  void provinceDecreaseStatus(Location province) {
    switch (_state.provinceStatus(province)) {
    case ProvinceStatus.roman:
      setProvinceStatus(province, ProvinceStatus.insurgent);
    case ProvinceStatus.insurgent:
      setProvinceStatus(province, ProvinceStatus.allied);
    case ProvinceStatus.allied:
    case ProvinceStatus.foederatiFrankish:
    case ProvinceStatus.foederatiOstrogothic:
    case ProvinceStatus.foederatiSuevian:
    case ProvinceStatus.foederatiVandal:
    case ProvinceStatus.foederatiVisigothic:
      setProvinceStatus(province, ProvinceStatus.barbarian);
    case ProvinceStatus.barbarian:
    }
  }

  void adjustEmpireGold(Location empire, int amount) {
    _state.adjustEmpireGold(empire, amount);
    if (amount > 0) {
      logLine('> ${_state.empireDesc(empire)} Gold: +$amount => ${_state.empireGold(empire)}');
    } else {
      logLine('> ${_state.empireDesc(empire)} Gold: $amount => ${_state.empireGold(empire)}');
    }
  }

  void adjustEmpirePrestige(Location empire, int amount) {
    _state.adjustEmpirePrestige(empire, amount);
    if (amount > 0) {
      logLine('> ${_state.empireDesc(empire)} Prestige: +$amount => ${_state.empirePrestige(empire)}');
    } else {
      logLine('> ${_state.empireDesc(empire)} Prestige: $amount => ${_state.empirePrestige(empire)}');
    }
  }

  void adjustEmpireUnrest(Location empire, int amount) {
    _state.adjustEmpireUnrest(empire, amount);
    if (amount > 0) {
      logLine('> ${_state.empireDesc(empire)} Unrest: +$amount => ${_state.empireUnrest(empire)}');
    } else {
      logLine('> ${_state.empireDesc(empire)} Unrest: $amount => ${_state.empireUnrest(empire)}');
    }
  }

  String yearDesc(int turn) {
    double t = (turn - _firstTurn) / _turnCount;
    double yearDouble = (1 - t) * _startYear + t * _endYear;
	  int year = yearDouble.round();
    return '$year CE';
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

  // High-Level Methods

  void redistributeEnemyLeaders(Enemy enemy) {
    final warsWithoutLeaders = _state.enemyWarsWithoutLeaders(enemy);
    final leadersWithoutWars = <Piece>[];
    final statesmen = <Piece>[];
    for (final leader in PieceType.leader.pieces) {
      if (_state.leaderEnemy(leader) == enemy) {
        final location = _state.pieceLocation(leader);
        if (location.isType(LocationType.land)) {
          if (_state.piecesInLocationCount(PieceType.war, location) == 0) {
            leadersWithoutWars.add(leader);
          }
        }
      }
    }
    for (final leader in PieceType.leaderStatesman.pieces) {
      if (_state.leaderEnemy(leader) == enemy) {
        final statesman = _state.leaderStatesman(leader);
        if (_state.statesmanInPlay(statesman)) {
          statesmen.add(leader);
        }
      }
    }
    warsWithoutLeaders.shuffle(_random);
    leadersWithoutWars.shuffle(_random);
    statesmen.shuffle(_random);
    for (final war in warsWithoutLeaders) {
      if (leadersWithoutWars.isEmpty && statesmen.isEmpty) {
        break;
      }
      final leader = leadersWithoutWars.isNotEmpty ? leadersWithoutWars[0] : statesmen[0];
      Piece? statesman;
      if (leader.isType(PieceType.leaderStatesman)) {
        statesman = _state.leaderStatesman(leader);
      }
      final land = _state.pieceLocation(war);
      logLine('> ${leader.desc} leads ${war.desc} in ${land.desc}.');
      _state.setPieceLocation(leader, land);
      if (statesman != null) {
        final location = _state.pieceLocation(statesman);
        if (location.isType(LocationType.governorship)) {
          governorshipBecomesLoyalToEmperor(location);
        }
        // Emperor not handled here to avoid this needing to be a sequence helper
      }
      if (leader.isType(PieceType.statesman)) {
        statesmen.remove(leader);
      } else {
        leadersWithoutWars.remove(leader);
      }
    }
    for (final leader in leadersWithoutWars) {
      if (leader.isType(PieceType.leaderLeader)) {
        final location = _state.pieceLocation(leader);
        if (!location.isType(LocationType.homeland)) {
          final homeland = randLocation(enemy.homelands)!;
          logLine('> ${leader.desc} returns to Homeland.');
          _state.setPieceLocation(leader, homeland);
        }
      } else {
        logLine('> ${leader.desc} returns to the Statesmen Pool.');
        _state.setPieceLocation(leader, Location.poolStatesmen);
      }
    }
  }

  void setWarOffmap(Piece war) {
    final enemy = _state.warEnemy(war);
    _state.setBarbarianOffmap(war);
    redistributeEnemyLeaders(enemy);
  }

  void empireFalls(Location empire) {
    _state.setEmpireHasFallen(empire);
    emperorDies(empire);
    newEmperor(empire, null, EmperorDeathCause.empireFell, _state.otherEmpire(empire));
    if (_state.empireGold(empire) < 0) {
      _state.setEmpireGold(empire, 0);
    }
    _state.setEmpirePrestige(empire, 0);
    _state.setEmpireUnrest(empire, 0);
    if (_state.commandRebel(empire)) {
      rebelEmperorBecomesLoyal(empire);
    }
    for (final governorship in LocationType.governorship.locations) {
      if (_state.commandEmpire(governorship) == empire) {
        _state.setCommandLoyalty(governorship, false);
      }
    }
  }

  void checkDefeat() {
    for (final empire in LocationType.empire.locations) {
      if (!_state.empireHasFallen(empire)) {
        if (_state.empireGold(empire) < 0) {
          logLine('### ${_state.commandName(empire)} Falls');
          logLine('> ${_state.commandName(empire)} is Bankrupt.');
          empireFalls(empire);
          if (_state.activeEmperors.isEmpty) {
            if (empire == Location.commandWesternEmperor) {
              throw GameOverException(
                GameResult.majorDefeat, GameResultCause.bankrupt, _state.empirePrestige(Location.commandWesternEmperor),
                GameResult.majorDefeat, GameResultCause.fallen, _state.empirePrestige(Location.commandEasternEmperor));
            } else {
              throw GameOverException(
                GameResult.majorDefeat, GameResultCause.fallen, _state.empirePrestige(Location.commandWesternEmperor),
                GameResult.majorDefeat, GameResultCause.bankrupt, _state.empirePrestige(Location.commandEasternEmperor));
            }
          }
        } else if (_state.empireUnrest(empire) > 25) {
          logLine('### ${_state.commandName(empire)} Falls');
          logLine('> ${_state.commandName(empire)} disintegrates due to high Unrest.');
          empireFalls(empire);
          if (_state.activeEmperors.isEmpty) {
            if (empire == Location.commandWesternEmperor) {
              throw GameOverException(
                GameResult.majorDefeat, GameResultCause.revolution, _state.empirePrestige(Location.commandWesternEmperor),
                GameResult.majorDefeat, GameResultCause.fallen, _state.empirePrestige(Location.commandEasternEmperor));
            } else {
              throw GameOverException(
                GameResult.majorDefeat, GameResultCause.fallen, _state.empirePrestige(Location.commandWesternEmperor),
                GameResult.majorDefeat, GameResultCause.revolution, _state.empirePrestige(Location.commandEasternEmperor));
            }
          }
        } else {
          final capital = _state.empireCapital(empire);
          if (!_state.spaceInsurgentOrBetter(capital)) {
            logLine('### ${_state.commandName(empire)} Falls');
            logLine('> ${capital.name} is lost.');
            empireFalls(empire);
            if (_state.activeEmperors.isEmpty) {
              if (empire == Location.commandWesternEmperor) {
                throw GameOverException(
                  GameResult.majorDefeat, GameResultCause.lostCapital, _state.empirePrestige(Location.commandWesternEmperor),
                  GameResult.majorDefeat, GameResultCause.fallen, _state.empirePrestige(Location.commandEasternEmperor));
              } else {
                throw GameOverException(
                  GameResult.majorDefeat, GameResultCause.fallen, _state.empirePrestige(Location.commandWesternEmperor),
                  GameResult.majorDefeat, GameResultCause.lostCapital, _state.empirePrestige(Location.commandEasternEmperor));
              }
            }
          }
        }
      } else {
        if (_state.empireGold(empire) < 0) {
          if (empire == Location.commandWesternEmperor) {
            throw GameOverException(
              GameResult.majorDefeat, GameResultCause.bankrupt, _state.empirePrestige(Location.commandWesternEmperor),
              GameResult.majorDefeat, GameResultCause.endured, _state.empirePrestige(Location.commandEasternEmperor));
          } else {
            throw GameOverException(
              GameResult.majorDefeat, GameResultCause.endured, _state.empirePrestige(Location.commandWesternEmperor),
              GameResult.majorDefeat, GameResultCause.bankrupt, _state.empirePrestige(Location.commandEasternEmperor));
          }
        }
        if (_state.empireUnrest(empire) > 25) {
          if (empire == Location.commandWesternEmperor) {
            throw GameOverException(
              GameResult.majorDefeat, GameResultCause.revolution, _state.empirePrestige(Location.commandWesternEmperor),
              GameResult.majorDefeat, GameResultCause.endured, _state.empirePrestige(Location.commandEasternEmperor));
          } else {
            throw GameOverException(
              GameResult.majorDefeat, GameResultCause.endured, _state.empirePrestige(Location.commandWesternEmperor),
              GameResult.majorDefeat, GameResultCause.revolution, _state.empirePrestige(Location.commandEasternEmperor));
          }
        }
      }
    }
  }

  void checkVictory() {
    int westernPrestige = _state.empirePrestige(Location.commandWesternEmperor);
    int easternPrestige = _state.empirePrestige(Location.commandEasternEmperor);
    GameResult westernResult = westernPrestige >= 75 ? GameResult.majorVictory : westernPrestige >= 50 ? GameResult.draw : GameResult.minorDefeat;
    GameResult easternResult = easternPrestige >= 75 ? GameResult.majorVictory : easternPrestige >= 50 ? GameResult.draw : GameResult.minorDefeat;
    var westernCause = GameResultCause.endured;
    var easternCause = GameResultCause.endured;
    if (_state.empireHasFallen(Location.commandWesternEmperor)) {
      westernResult = GameResult.majorDefeat;
      westernCause = GameResultCause.fallen;
      if (easternResult == GameResult.majorVictory) {
        easternResult = GameResult.minorVictory;
      }
    }
    if (_state.empireHasFallen(Location.commandEasternEmperor)) {
      easternResult = GameResult.majorDefeat;
      easternCause = GameResultCause.fallen;
      if (westernResult == GameResult.majorVictory) {
        westernResult = GameResult.minorVictory;
      }
    }
    throw GameOverException(
      westernResult, westernCause, _state.empirePrestige(Location.commandWesternEmperor),
      easternResult, easternCause, _state.empirePrestige(Location.commandEasternEmperor));
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;

    logLine('# Game Over');

    for (final empire in LocationType.empire.locations) {
      GameResult result = empire == Location.commandWesternEmperor ? outcome.westernResult : outcome.easternResult;
      GameResultCause cause = empire == Location.commandWesternEmperor ? outcome.westernCause : outcome.easternCause;
      int prestige = empire == Location.commandWesternEmperor ? outcome.westernPrestige : outcome.easternPrestige;

      switch (result) {
      case GameResult.majorDefeat:
        logLine('### ${_state.empireDesc(empire)} Empire Defeat');
        switch (cause) {
        case GameResultCause.fallen:
          logLine('> The ${_state.empireDesc(empire)} Empire has Fallen.');
        case GameResultCause.bankrupt:
          logLine('> The ${_state.empireDesc(empire)} Empire is bankrupt.');
        case GameResultCause.revolution:
          logLine('> Revolution breaks out across the ${_state.empireDesc} Empire');
        case GameResultCause.lostCapital:
          logLine('> ${_state.empireCapital(empire).desc} falls.');
        case GameResultCause.endured:
        }
      case GameResult.minorDefeat:
        logLine('### Minor Defeat');
        logLine('> The ${_state.empireDesc(empire)} Empire endures, with $prestige Prestige.');
      case GameResult.draw:
        logLine('### Draw');
        logLine('> The ${_state.empireDesc(empire)} Empire is stable, with $prestige Prestige.');
      case GameResult.minorVictory:
        logLine('### Minor Victory');
        logLine('> The ${_state.empireDesc(empire)} Empire prospers, with $prestige Prestige.');
      case GameResult.majorVictory:
        logLine('### Major Victory');
        logLine('> The ${_state.empireDesc(empire)} Empire dominates its enemies, with $prestige Prestige.');
      }
    }
  }

  void makeRebellionCheckForCommand(Location command) {
    logLine('### ${_state.commanderName(command)} considers Rebellion');

    final empire = _state.commandEmpire(command);
    final emperor = command.isType(LocationType.emperor) ? _state.otherEmpire(empire) : empire;

    final rolls = roll3D6();
    int omens = rolls.$4;
    int total = rolls.$5;

    int modifiers = 0;
    int modifier = 0;
    int commanderPopularity = _state.commandPopularity(command);
    int emperorPopularity = _state.commandPopularity(emperor);
    int popularityModifier = 0;
    if (commanderPopularity >= emperorPopularity) {
      modifier = commanderPopularity;
      logLine('> ${_state.commanderName(command)}: +$modifier');
      modifiers += modifier;
      modifier = -emperorPopularity;
      logLine('> ${_state.commanderName(emperor)}: $modifier');
      modifiers += modifier;
      popularityModifier = commanderPopularity - emperorPopularity;
    } else {
      modifier = emperorPopularity;
      logLine('> ${_state.commanderName(emperor)}: +$modifier');
      modifiers += modifier;
      modifier = -commanderPopularity;
      logLine('> ${_state.commanderName(command)}: $modifier');
      modifiers += modifier;
      popularityModifier = emperorPopularity - commanderPopularity;
    }
    modifier = _state.empireUnrest(empire);
    if (modifier != 0) {
      logLine('> Unrest: +$modifier');
      modifiers += modifier;
    }
    int veteransModifier = _state.rebellionVeteransControlledByCommandCount(command);
    modifier = veteransModifier;
    if (modifier != 0) {
      logLine('> Veteran Units: +$modifier');
      modifiers += modifier;
    }

    int result = total + modifiers;
    logLine('> Result: $result');

    if (result >= 25) {
      if (result - omens < 25) {
        logLine('> ${_state.commanderName(command)} Rebels, in accordance with the Omens.');
      } else if (result - popularityModifier < 25 && popularityModifier >= 2) {
        if (commanderPopularity > emperorPopularity) {
          if (emperorPopularity == 1) {
            logLine('> ${_state.commanderName(command)} Rebels against pagan ${_state.commanderName(emperor)}.');
          } else if (emperorPopularity == 2) {
            logLine('> ${_state.commanderName(command)} Rebels against heretical ${_state.commanderName(emperor)}.');
          } else {
            logLine('> Devout ${_state.commanderName(command)} Rebels.');
          }
        } else {
          if (commanderPopularity == 1) {
            logLine('> Pagan ${_state.commanderName(command)} Rebels.');
          } else if (commanderPopularity == 1) {
            logLine('> Heretical ${_state.commanderName(command)} Rebels.');
          } else {
            logLine('> ${_state.commanderName(command)} Rebels against zealot ${_state.commanderName(emperor)}.');
          }
        }
      } else if (result - veteransModifier < 25) {
        logLine('> Veterans support ${_state.commanderName(command)} in Rebellion.');
      } else {
        logLine('> ${_state.commanderName(command)} Rebels.');
      }
      if (command.isType(LocationType.governorship)) {
        _state.governorRebels(command);
        if (_state.pieceInLocation(PieceType.statesman, command) == null) {
          if (_state.commanderAge(command) == null) {
            _state.setCommanderAge(command, 3);
          }
        }
      } else {
        _state.emperorRebels(command);
      }
    } else {
      if (result - omens >= 25) {
        logLine('> ${_state.commanderName(command)} remains Loyal, in accordance with the Omens.');
      } else {
        logLine('> ${_state.commanderName(command)} remains Loyal.');
      }
    }
  }

  void loyalEmperorBecomesRebel(Location emperor) {
    _state.setCommandLoyalty(emperor, false);
    for (final governorship in LocationType.governorship.locations) {
      if (_state.commandEmpire(governorship) == emperor) {
        if (_state.commandLoyal(governorship)) {
          final statesman = _state.pieceInLocation(PieceType.statesman, governorship);
          if (statesman != null) {
            _state.setPieceLocation(statesman, Location.boxStatesmen);
          }
          _state.setCommandAllegiance(governorship, emperor);
          _state.setCommandLoyalty(governorship, false);
        }
      }
    }
  }

  void rebelEmperorBecomesLoyal(Location emperor) {
    _state.setCommandLoyalty(emperor, true);
    for (final governorship in LocationType.governorship.locations) {
      if (_state.commandAllegiance(governorship) == emperor) {
        _state.setCommandAllegiance(governorship, governorship);
        _state.setCommandLoyalty(governorship, true);
      }
    }
  }

  void governorshipBecomesLoyalToEmperor(Location governorship) {
    final emperor = _state.commandEmpire(governorship);
    bool emperorLoyal = _state.commandLoyal(emperor);
    for (final otherGovernorship in LocationType.governorship.locations) {
      if (_state.commandAllegiance(otherGovernorship) == governorship) {
        if (emperorLoyal) {
          _state.setCommandAllegiance(otherGovernorship, otherGovernorship);
        } else {
          _state.setCommandAllegiance(otherGovernorship, emperor);
        }
        _state.setCommandLoyalty(otherGovernorship, emperorLoyal);
      }
    }
  }

  void governorDies(Location governorship) {
    for (final war in PieceType.war.pieces) {
      if (_state.pieceLocation(war) == governorship) {
        _state.setBarbarianOffmap(war);
      }
    }
    final statesman = _state.pieceInLocation(PieceType.statesman, governorship);
    if (statesman != null) {
      _state.setPieceLocation(statesman, Location.offmap);
    }
    _state.setCommanderAge(governorship, null);
    governorshipBecomesLoyalToEmperor(governorship);
  }

  void emperorDies(Location emperor) {
    final statesman = _state.commandCommander(emperor);
    if (statesman != null) {
      _state.setPieceLocation(statesman, Location.offmap);
    }
    _state.setCommanderAge(emperor, null);
  }

  void governorBecomesLoyalEmperor(Location governorship, Location emperor) {
    for (final war in PieceType.war.pieces) {
      if (_state.pieceLocation(war) == governorship) {
        _state.setBarbarianOffmap(war);
      }
    }
    final statesman = _state.pieceInLocation(PieceType.statesman, governorship);
    int? governorAge = _state.commanderAge(governorship);
    if (_state.commandRebel(emperor)) {
      rebelEmperorBecomesLoyal(emperor);
    }
    governorshipBecomesLoyalToEmperor(governorship);
    _state.setCommanderAge(governorship, null);
    if (statesman != null) {
      _state.setPieceLocation(statesman, emperor);
      _state.setCommanderAge(emperor, null);
    } else {
      if (governorAge != null) {
        _state.setCommanderAge(emperor, governorAge);
      } else {
        _state.setCommanderAge(emperor, 3);
      }
    }
  }

  void governorBecomesRebelEmperor(Location governorship, Location emperor) {
    for (final war in PieceType.war.pieces) {
      if (_state.pieceLocation(war) == governorship) {
        _state.setBarbarianOffmap(war);
      }
    }
    final statesman = _state.pieceInLocation(PieceType.statesman, governorship);
    int? governorAge = _state.commanderAge(governorship);
    if (_state.commandLoyal(emperor)) {
      loyalEmperorBecomesRebel(emperor);
    }
    governorshipBecomesLoyalToEmperor(governorship);
    _state.setCommanderAge(governorship, null);
    if (statesman != null) {
      _state.setPieceLocation(statesman, emperor);
      _state.setCommanderAge(emperor, null);
    } else {
      if (governorAge != null) {
        _state.setCommanderAge(emperor, governorAge);
      } else {
        _state.setCommanderAge(emperor, 3);
      }
    }
  }

  void statesmanBecomesLoyalEmperor(Piece statesman, Location emperor) {
    if (_state.commandRebel(emperor)) {
      rebelEmperorBecomesLoyal(emperor);
    }
    _state.setPieceLocation(statesman, emperor);
    _state.setCommanderAge(emperor, null);
  }

  void genericBecomesLoyalEmperor(Location emperor) {
    _state.setCommanderAge(emperor, 3);
  }

  void legionDestroy(Piece legion) {
    final province = _state.pieceLocation(legion);
    logLine('> ${legion.desc} in ${province.desc} is Destroyed.');
    _state.setPieceLocation(legion, Location.offmap);
  }

  void unitDismiss(Piece unit) {
    final province = _state.pieceLocation(unit);
    logLine('> ${unit.desc} in ${province.desc} is Dismissed.');
    _state.setPieceLocation(unit, Location.boxBarracks);
  }

  void unitDemote(Piece unit) {
    final province = _state.pieceLocation(unit);
    if (unit.isType(PieceType.pseudoLegion)) {
      logLine('> ${unit.desc} in ${province.desc} is Demoted to Fort.');
    } else {
      logLine('> ${unit.desc} in ${province.desc} is Demoted.');
    }
    _state.flipUnit(unit);
  }

  void unitPromote(Piece unit) {
    final province = _state.pieceLocation(unit);
    if (unit.isType(PieceType.fort)) {
      logLine('> ${unit.desc} in ${province.desc} is Promoted to Pseudo Legion.');
    } else {
      logLine('> ${unit.desc} in ${province.desc} is Promoted to Veteran.');
    }
    _state.flipUnit(unit);
  }

  void annexProvince(Location province) {
    logLine('> ${province.desc} is Annexed.');
    provinceIncreaseStatus(province);
    final command = _state.provinceCommand(province);
    final empire = _state.commandEmpire(command);
    adjustEmpirePrestige(empire, 1);
  }

  void annexProvinceToFoederati(Location province, Enemy foederati) {
    final oldStatus = _state.provinceStatus(province);
    logLine('> ${province.desc} is Annexed by the ${foederati.name}.');
    _state.setProvinceStatus(province, foederati.foederatiStatus!);
    final command = _state.provinceCommand(province);
    final empire = _state.commandEmpire(command);
    if (oldStatus == ProvinceStatus.barbarian) {
      adjustEmpirePrestige(empire, 1);
    }
  }

  EventType randomEventType() {
		EventType? eventType;
		int discreteEventCount = _state.eventTypeDiscreteCount();
		if (discreteEventCount < 6) {
			while (eventType == null) {
        final rolls = rollD6D3();
				int eventIndex = (rolls.$1 - 1) * 3 + (rolls.$2 - 1);
        eventType = EventType.values[eventIndex];
				if (_state.eventTypeCount(eventType) == 2) {
					logLine('> ${_state.eventTypeName(eventType)} already doubled');
					eventType = null;
				}
			}
		} else {
			int singleEventCount = _state.eventTypeMatchingCountCount(1);
      int die = randInt(singleEventCount);
			for (final checkEventType in EventType.values) {
				if (_state.eventTypeCount(checkEventType) == 1) {
					if (die == 0) {
						eventType = checkEventType;
						break;
					}
					die -= 1;
				}
			}
		}
    return eventType!;
  }

  bool failMortalityRoll(String name, int? age) {
    logLine('### Mortality Check for $name');
    bool hasSavingRoll = _options.finiteLifetimes && age != null && age <= 2;
    final rolls = rollD6D2(hasSavingRoll);
    int die = rolls.$1;
    int savingRoll = rolls.$2;
    int modifiers = 0;
    int plagueModifier = 0;
    if (_state.eventTypeCount(EventType.plague) == 2) {
      plagueModifier = 1;
      modifiers += plagueModifier;
      logLine('> Plague Event (doubled): +1');
    }
    if (_options.finiteLifetimes && age != null) {
      if (age > 3) {
        int modifier = age - 3;
        logLine('> Age: +$modifier');
        modifiers += modifier;
      }
    }
    int result = die + modifiers;
    bool fail = result >= 6 && (result != 6 || !hasSavingRoll || savingRoll != 1);
    if (fail) {
      if (result - plagueModifier < 6) {
        logLine('> $name succumbs to the Plague.');
      } else {
        logLine('> $name Dies.');
      }
    } else if (result >= 6) {
      logLine('> $name falls ill but recovers.');
    } else {
      logLine('> $name remains in good health.');
    }
    return fail;
  }

  int taxCommand(Location command) {
    if (_state.commandRebel(command)) {
      return 0;
    }
    int total = 0;
    for (final province in _state.commandLocationType(command)!.locations) {
      if (_state.provinceStatus(province) == ProvinceStatus.roman) {
        total += _state.provinceRevenue(province);
      }
    }
    if (total == 0) {
      return 0;
    }

    final name = _state.commandName(command);
    logLine('> ');
    logLine('> $name');

    final rolls = roll2D6();
    int rollTotal = rolls.$4;
    int modifiers = 0;
    int modifier = 0;
    final emperor = _state.commandEmpire(command);
    modifier = -_state.commandAdministration(emperor);
    logLine('> ${_state.commanderName(emperor)}: $modifier');
    modifiers += modifier;
    modifier = -_state.commandAdministration(command);
    logLine('> ${_state.commanderName(command)}: $modifier');
    modifiers += modifier;
    if (_state.eventTypeCount(EventType.inflation) > 0) {
      modifier = _state.eventTypeCount(EventType.inflation);
      if (modifier == 1) {
        logLine('> Inflation Event: +1');
      } else {
        logLine('> Inflation Event (doubled): +2');
      }
      modifiers += modifier;
    }
    modifier = _options.taxRollModifier;
    if (modifier != 0) {
      if (modifier == 1) {
        logLine('> Lower Tax option: +1');
      } else if (modifier == -1) {
        logLine('> Higher Tax option: -1');
      }
      modifiers += modifier;
    }
    int result = rollTotal + modifiers;
    logLine('> Result: $result');

    int finalTotal = total;
    String doubledDesc = '';
    if (result <= 0) {
      finalTotal *= 2;
      doubledDesc = ' doubled to $finalTotal';
    }
    logLine('> Tax: $total$doubledDesc');

    return finalTotal;
  }

  void taxEmpire(Location empire) {
    int amount = 0;
    for (final command in LocationType.governorship.locations) {
      if (_state.commandEmpire(command) == empire) {
        amount += taxCommand(command);
      }
    }
    logLine('> ');
    adjustEmpireGold(empire, amount);
  }

  void payEmpire(Location empire) {
    adjustEmpireGold(empire,-_state.empirePay(empire));
  }

  void extraTaxes(Location empire) {
	  final rolls = roll2D6();
    int total = rolls.$4;
    adjustEmpireGold(empire, total);
    adjustEmpireUnrest(empire, 1);
    adjustEmpirePrestige(empire, -1);
    logLine('> ');
  }

  int moveWarPriority(Piece war, Location? displaceSpace, Location connectedSpace, ConnectionType connectionType) {
    bool spaceNonMatchingFoederatiOrBetter = _state.spaceNonMatchingFoederatiOrBetter(connectedSpace, war);
    bool roadLike = connectionType == ConnectionType.road;
    bool seaLike = connectionType == ConnectionType.sea;
    int navalStrength = _state.warNavalStrength(war);
    if (seaLike) {
      if (navalStrength >= 2) {
        seaLike = false;
      }
      if (navalStrength >= 4) {
        roadLike = true;
      }
    }
    if (connectionType == ConnectionType.river && navalStrength >= 2) {
      roadLike = true;
    }
    if (seaLike) {
      return 0;
    }
    final phaseState = _phaseState as PhaseStateTreasury;
    final warTrail = phaseState.warTrail(war);
    int priority = 1;
    priority *= 8;
    int revisitCount = max(7 - warTrail.where((space) => space == connectedSpace).length - 1, 0);
    priority += revisitCount;
    priority *= 2;
    if (displaceSpace != null) {
      if (displaceSpace != connectedSpace) {
        priority += 1;
      }
    }
    priority *= 2;
    if (!warTrail.contains(connectedSpace)) {
      priority += 1;
    }
    priority *= 2;
    if (spaceNonMatchingFoederatiOrBetter) {
      priority += 1;
    }
    priority *= 16;
    if (!spaceNonMatchingFoederatiOrBetter) {
      priority += max(15 - _state.spaceNonMatchingFoederatiOrBetterDistance(connectedSpace, war), 0);
    }
    priority *= 2;
    if (roadLike) {
      priority += 1;
    }

    // Bits
    // 0x001 road
    // 0x01E allied or better distance
    // 0x020 allied or better
    // 0x040 not visited
    // 0x080 not displaced
    // 0x700 revisit count

    return priority;
  }

  Location? determineWarDestination(Piece war, Location? displaceSpace, Location? prohibitSpace) {
    final space = _state.pieceLocation(war);
    final connections = _state.spaceConnections(space);
    int bestPriority = 0;
    var bestConnectedSpaces = <Location>[];
    for (final connection in  connections) {
      final connectedSpace = connection.$1;
      final connectionType = connection.$2;
      if (connectedSpace != prohibitSpace) {
        int priority = moveWarPriority(war, displaceSpace, connectedSpace, connectionType);
        if (priority > bestPriority) {
          bestPriority = priority;
          bestConnectedSpaces = [connectedSpace];
        } else if (priority == bestPriority) {
          bestConnectedSpaces.add(connectedSpace);
        }
      }
    }
    return randLocation(bestConnectedSpaces);
  }

  bool determinePillage(Piece war) {
    Location province = _state.pieceLocation(war);
    Piece? leader = _state.pieceInLocation(PieceType.leader, province);

    logLine('> ');
    logLine('> ${war.desc} Pillage');
    final roll = rollD6();
    int modifiers = 0;
    int modifier = 0;
    if (leader != null) {
      modifier = _state.leaderPillage(leader);
      logLine('> ${leader.desc}: +$modifier');
      modifiers += modifier;
    }
    int cavalryStrength = _state.warCavalryStrength(war);
    modifier = 0;
    if (cavalryStrength >= 4) {
      modifier = 2;
    } else if (cavalryStrength >= 2) {
      modifier = 1;
    }
    if (modifier > 0) {
      logLine('> Cavalry: +$modifier');
      modifiers += modifier;
    }
    modifier = _state.eventTypeCount(EventType.migration);
    if (modifier == 1) {
      logLine('> Migration Event: +1');
    } else if (modifier == 2) {
      logLine('> Migration Event (doubled): +2');
    }
    modifiers += modifier;

    modifier = 0;
    switch (_state.provinceStatus(province)) {
    case ProvinceStatus.insurgent:
      modifier = 1;
      logLine('> Insurgent: +1');
    case ProvinceStatus.allied:
      modifier = -1;
      logLine('> Allied: -1');
    case ProvinceStatus.foederatiFrankish:
    case ProvinceStatus.foederatiOstrogothic:
    case ProvinceStatus.foederatiSuevian:
    case ProvinceStatus.foederatiVandal:
    case ProvinceStatus.foederatiVisigothic:
      modifier = -2;
      logLine('> Foederati: -2');
    default:
    }
    modifiers += modifier;

    modifier = -_state.pillageDeterrentLandUnitsInSpaceCount(province);
    if (modifier != 0) {
      logLine('> Units: $modifier');
      modifiers += modifier;
    }
 
    int result = roll + modifiers;
    logLine('> Result: $result');
    logLine('> ');

    return result >= 4;
  }

  void logWarMove(Enemy enemy, String piecesDesc, String verb, List<Location> path, List<Location> annexations) {
    if (path.isEmpty) {
      return;
    }
    String pathDesc = '';
    if (path.length > 1) {
      pathDesc = 'through ';
      for (int i = 0; i + 1 < path.length; ++i) {
        if (i > 0) {
          if (i + 2 == path.length) {
            pathDesc += ' and ';
          } else {
            pathDesc += ',';
          }
        }
        pathDesc += path[i].desc;
      }
      pathDesc += ' ';
    }
    logLine('> $piecesDesc $verb ${pathDesc}to ${path[path.length - 1].desc}.');
    for (final province in annexations) {
      annexProvinceToFoederati(province, enemy);
    }
  }

  Piece? randomLeaderInSpace(Location space) {
    final leaders = _state.piecesInLocation(PieceType.leader, space);
    if (leaders.isEmpty) {
      return null;
    }
    return randPiece(leaders);
  }

  void moveWar(Piece war, Location? displaceSpace, Piece? ignoreWar) {
    final enemy = _state.warEnemy(war);
    final foederatiStatus = enemy.foederatiStatus;
    final phaseState = _phaseState as PhaseStateTreasury;
    if (displaceSpace == null) {
      phaseState.setWarUnmoved(war, false);
    }
    int pillageRollCount = displaceSpace != null ? 1 : 0;
    final originSpace = _state.pieceLocation(war);
    final warTrail = phaseState.warTrail(war);
    warTrail.add(originSpace);
    if (displaceSpace == null && _state.spaceNonMatchingFoederatiOrBetter(originSpace, war)) {
      pillageRollCount += 1;
      final pillage = determinePillage(war);
      if (!pillage) {
        logLine('> ${war.desc} remains in ${originSpace.desc}.');
        return;
      }
    }
    final leader = randomLeaderInSpace(originSpace);
    Location? prohibitSpace;
    if (displaceSpace != null) {
      prohibitSpace = originSpace;
    }

    String pieceNames = war.desc;
    String verb = 'Moves';
    if (leader != null) {
      pieceNames += ' and ${leader.desc}';
      verb = 'Move';
    }

    var logPath = <Location>[];
    var logAnnexations = <Location>[];
    bool terminate = false;

    while (!terminate) {
      final nextSpace = determineWarDestination(war, displaceSpace, prohibitSpace);
      if (nextSpace == null) {
        // Not possible first time around loop, as prohibit space is current location
        terminate = true;
      } else {
        logPath.add(nextSpace);
        warTrail.add(nextSpace);
        final otherWar = _state.pieceInLocation(PieceType.war, nextSpace);
        if (otherWar != null && otherWar != ignoreWar) {
          logWarMove(enemy, pieceNames, verb, logPath, logAnnexations);
          logPath.clear();
          logAnnexations.clear();
          verb = 'continues';
          if (leader != null) {
            verb = 'continue';
          }
          moveWar(otherWar, originSpace, war);
        }
        _state.setPieceLocation(war, nextSpace);
        if (leader != null) {
          _state.setPieceLocation(leader, nextSpace);
        }
        if (nextSpace.isType(LocationType.province) && foederatiStatus != null && _state.provinceStatus(nextSpace) == ProvinceStatus.barbarian) {
          _state.setProvinceStatus(nextSpace, foederatiStatus);
          logAnnexations.add(nextSpace);
        }
        if (_state.spaceNonMatchingFoederatiOrBetter(nextSpace, war)) {
          terminate = pillageRollCount > 0;
          if (pillageRollCount == 0) {
            logWarMove(enemy, pieceNames, verb, logPath, logAnnexations);
            logPath.clear();
            logAnnexations.clear();
            verb = 'continues';
            if (leader != null) {
              verb = 'continue';
            }
            pillageRollCount += 1;
            bool pillage = determinePillage(war);
            if (!pillage) {
              logLine('> ${war.desc} halts in ${nextSpace.desc}.');
              terminate = true;
            }
          }
        }
      }
    }
    logWarMove(enemy, pieceNames, verb, logPath, logAnnexations);
  }

  void dynastyAdded(Piece dynasty) {
    switch (dynasty) {
    case Piece.dynastyConstantinian:
      logLine('> Moesia and Pannonia transfer to the Western Empire.');
      logLine('> Tetrarchy abandoned, Emperors no longer abdicate.');
    case Piece.dynastyValentinian:
      logLine('> Legions and Auxilia may not be Promoted to Veteran.');
      logLine('> Guards and Forts prevent Unrest as if Legions.');
    case Piece.dynastyTheodosian:
      logLine('> Moesia transfers to the Eastern Empire.');
      logLine('> Veteran Cavalry protect against Assassination.');
      logLine('> Imperial Emperors may not fight Foreign Wars.');
    case Piece.dynastyLeonid:
      logLine('> Veteran Legions and Auxilia are Demoted.');
      for (final legion in PieceType.legionVeteran.pieces) {
        if (_state.pieceLocation(legion) != Location.flipped) {
          _state.flipUnit(legion);
        }
      }
      for (final auxilia in PieceType.auxiliaVeteran.pieces) {
        if (_state.pieceLocation(auxilia) != Location.flipped) {
          _state.flipUnit(auxilia);
        }
      }
    case Piece.dynastyJustinian:
      logLine('> Annex one Province in each Unrest Phase.');
    default:
    }
  }

  void drawStatesmen() {
    logLine('### New Statesmen');
    final poolPieces = _state.piecesInLocation(PieceType.statesmenPool, Location.poolStatesmen);

    int drawCount = 0;
    if (_subStep == 0) {
      if (_state.turn % 10 == 9) {
        drawCount = poolPieces.length;
      } else {
        int roll = rollD3();
        int modifiers = 0;
        int timePeriod = _state.turn ~/ 10;
        if (timePeriod == 3 || timePeriod == 4) {
          String scenarioDesc = timePeriod == 3 ? '497 CE' : '565 CE';
          logLine('> $scenarioDesc Scenario: -1');
          modifiers -= 1;
        }
        int result = roll + modifiers;
        logLine('> Result: $result');
        drawCount = result;
        if (drawCount > poolPieces.length) {
          drawCount = poolPieces.length;
        }
      }
      if (poolPieces.isEmpty) {
        logLine('> No Statesmen/Emperors left to Draw.');
        return;
      }

      for (int i = 0; i < drawCount; ++i) {
        final piece = randPiece(poolPieces)!;
        poolPieces.remove(piece);
        if (piece.isType(PieceType.statesman)) {
          if (_state.statesmanActiveImperial(piece)) {
            logLine('> ${_state.statesmanName(piece)} comes of age.');
          } else {
            logLine('> ${_state.statesmanName(piece)} rises to prominence.');
          }
          _state.setPieceLocation(piece, Location.boxStatesmen);
          _state.setStatesmanAge(piece, _state.statesmanImperial(piece) ? 0 : 1);
          final leader = _state.statesmanLeader(piece);
          if (leader != null) {
            final enemy = _state.leaderEnemy(leader);
            redistributeEnemyLeaders(enemy);
          }
        } else {
          logLine('> Line of ${piece.desc} is established.');
          _state.setPieceLocation(piece, Location.boxDynasties);
          dynastyAdded(piece);
          if ([Piece.dynastyConstantinian, Piece.dynastyTheodosian].contains(piece)) {
            _subStep = 1;
          }
        }
      }
    }

    if (_subStep == 1) {
      final splitAllegiances = <Location>[];
      for (final governorship in LocationType.governorship.locations) {
        final empire = _state.commandEmpire(governorship);
        final otherEmpire = _state.otherEmpire(empire);
        final allegiance = _state.commandAllegiance(governorship);
        if (allegiance == governorship) {
          if (_state.commandRebel(empire)) {
            _state.setCommandAllegiance(governorship, empire);
            //final statesman = _state.pieceInLocation(PieceType.statesman, governorship);
            //if (statesman != null) {
            //  _state.setPieceLocation(statesman, Location.boxStatesmen);
            //}
          }
        } else if (allegiance == otherEmpire) {
          if (_state.commandRebel(empire)) {
            _state.setCommandAllegiance(governorship, empire);
          } else {
            _state.setCommandAllegiance(governorship, governorship);
          }
        } else if (allegiance == empire) {
        } else {
          final allegianceEmpire = _state.commandEmpire(allegiance);
          if (allegianceEmpire != empire) {
            if (!splitAllegiances.contains(allegiance)) {
              splitAllegiances.add(allegiance);
            }
          }
        }
      }
      while (splitAllegiances.isNotEmpty) {
        final statesman = _state.pieceInLocation(PieceType.statesman, splitAllegiances[0])!;
        if (choicesEmpty()) {
          setPrompt('Select Governorship for ${_state.statesmanName(statesman)}');
          for (final governorship in LocationType.governorship.locations) {
            if (_state.commandAllegiance(governorship) == splitAllegiances[0]) {
              locationChoosable(governorship);
            }
          }
          throw PlayerChoiceException();
        }
        final governorship = selectedLocation()!;
        if (governorship == splitAllegiances[0]) {
          logLine('> ${_state.statesmanName(statesman)} remains ${_state.commanderPositionName(governorship)}.');
        } else {
          logLine('> ${_state.statesmanName(statesman)} becomes ${_state.commanderPositionName(governorship)}.');
          _state.setPieceLocation(statesman, governorship);
          for (final otherGovernorship in LocationType.governorship.locations) {
            if (_state.commandAllegiance(otherGovernorship) == splitAllegiances[0]) {
              _state.setCommandAllegiance(otherGovernorship, governorship);
            }
          }
        }
        splitAllegiances.remove(splitAllegiances[0]);
        clearChoices();
      }
    }
    for (final governorship in LocationType.governorship.locations) {
      final statesman = _state.pieceInLocation(PieceType.statesman, governorship);
      if (statesman != null) {
        if (_state.commandAllegiance(governorship) != governorship) {
          _state.setPieceLocation(statesman, Location.boxStatesmen);
        }
      }
    }
  }

  void appointStatesmanToCommand(Piece statesman, Location command) {
    logLine('> ${_state.statesmanName(statesman)} is Appointed as ${_state.commanderPositionName(command)}.');
    final previousCommander = _state.commandCommander(command);
    if (previousCommander != null) {
      _state.setPieceLocation(previousCommander, Location.boxStatesmen);
    }
    _state.setPieceLocation(statesman, command);
  }

  int calculateProvinceRevoltModifier(Location province, bool ignoreMobileUnits, bool log) {
    final leader = _state.pieceInLocation(PieceType.leader, province);
    final war = _state.pieceInLocation(PieceType.war, province);
    final hasFleet = _state.piecesInLocationCount(PieceType.fleet, province) > 0;
    final status = _state.provinceStatus(province);
    final command = _state.provinceCommand(province);

    int modifiers = 0;
    int modifier = 0;
    if ((command == Location.commandGallia && _state.eventTypeCount(EventType.bagaudae) >= 1) ||
        (command == Location.commandHispania && _state.eventTypeCount(EventType.bagaudae) >= 2)) {
      modifier = 1;
      if (log) {
        logLine('> Bagaudae: +1');
      }
      modifiers += modifier;
    }
    if ((command == Location.commandOriens && _state.eventTypeCount(EventType.heresy) >= 1) ||
        (command == Location.commandAfrica && _state.eventTypeCount(EventType.heresy) >= 2)) {
      modifier = 1;
      if (log) {
        logLine('> Heresy: +1');
      }
      modifiers += modifier;
    }
    if (leader != null) {
      modifier = _state.leaderPillage(leader);
      if (log) {
        logLine('> ${leader.desc}: +$modifier');
      }
      modifiers += modifier;
    }
    if (war != null) {
      modifier = 3;
      if (log) {
        logLine('> ${war.desc}: +$modifier');
      }
      modifiers += modifier;
    }

    for (final connection in _state.spaceConnections(province)) {
      final connectedSpace = connection.$1;
      final connectionType = connection.$2;
      bool mitigated = false;
      switch (status) {
      case ProvinceStatus.foederatiFrankish:
      case ProvinceStatus.foederatiOstrogothic:
      case ProvinceStatus.foederatiSuevian:
      case ProvinceStatus.foederatiVandal:
      case ProvinceStatus.foederatiVisigothic:
      case ProvinceStatus.allied:
        mitigated = true;
      default:
      }
      bool negated = false;
      switch (connectionType) {
      case ConnectionType.sea:
        negated = true;
      case ConnectionType.river:
        if (!ignoreMobileUnits && hasFleet) {
          mitigated = true;
        }
      case ConnectionType.road:
      case ConnectionType.desert:
      case ConnectionType.mountain:
      }
      if (!negated) {
        if (!_state.spaceFoederatiOrBetter(connectedSpace)) {
        modifier = 0;
          if (connectionType == ConnectionType.road) {
            modifier = 3;
            if (mitigated) {
              modifier -= 1;
            }
          } else if (connectionType != ConnectionType.sea) {
            modifier = 2;
            if (mitigated) {
              modifier -= 1;
            }
          }
          if (modifier != 0) {
            if (log) {
              logLine('> ${connectedSpace.desc}: +$modifier.');
            }
            modifiers += modifier;
          }
        }
        final connectedWar = _state.pieceInLocation(PieceType.war, connectedSpace);
        if (connectedWar != null) {
          int modifier = 0;
          if (connectionType == ConnectionType.road) {
            modifier = 2;
          } else if (connectionType != ConnectionType.sea) {
            modifier = 1;
          }
          if (modifier != 0) {
            if (log) {
              logLine('> ${connectedWar.desc}: +$modifier');
            }
            modifiers += modifier;
          }
        }
      }
      if (connectedSpace.isType(LocationType.homeland)) {
        for (final connectedLeader in _state.piecesInLocation(PieceType.leader, connectedSpace)) {
          modifier = 1;
          if (log) {
            logLine('> ${connectedLeader.desc}: +$modifier');
          }
          modifiers += modifier;
        }
      }
    }

    if (status == ProvinceStatus.insurgent) {
      modifier = 1;
      if (log) {
        logLine('> Insurgent: +1');
      }
      modifiers += modifier;
    }

    if (!ignoreMobileUnits) {
      modifier = 0;
      modifier -= _state.piecesInLocationCount(PieceType.guard, province);
      modifier -= _state.piecesInLocationCount(PieceType.legionaries, province);
      modifier -= _state.piecesInLocationCount(PieceType.auxiliaOrdinary, province);
      modifier -= 2 * _state.piecesInLocationCount(PieceType.auxiliaVeteran, province);
      modifier -= 2 * _state.piecesInLocationCount(PieceType.fort, province);
      if (modifier != 0) {
        if (log) {
          logLine('> Units: $modifier');
        }
        modifiers += modifier;
      }
    }

    switch (status) {
    case ProvinceStatus.allied:
      modifier = -1;
      if (log) {
        logLine('> Allied: -1');
      }
      modifiers += modifier;
    case ProvinceStatus.foederatiFrankish:
    case ProvinceStatus.foederatiOstrogothic:
    case ProvinceStatus.foederatiSuevian:
    case ProvinceStatus.foederatiVandal:
    case ProvinceStatus.foederatiVisigothic:
      modifier = -2;
      if (log) {
        logLine('> Foederati: -2');
      }
      modifiers += modifier;
    default:
    }

    return modifiers;
  }

  int provinceRevoltCheck(Location province) {
    final status = _state.provinceStatus(province);
    final war = _state.pieceInLocation(PieceType.war, province);
    if (war != null && status.foederati == _state.warEnemy(war)) {
      return 0;
    }
    int modifiers = calculateProvinceRevoltModifier(province, false, false);
    if ((status != ProvinceStatus.insurgent || war != null) && modifiers <= 0) {
      return 0;
    }
    logLine('### ${province.desc}');
    int roll = rollD6();
    modifiers = calculateProvinceRevoltModifier(province, false, true);
    int result = roll + modifiers;
    logLine('> Result: $result');
   
    if (result > 6) {
      return 1;
    }

    if (status == ProvinceStatus.insurgent && war == null) {
      final command = _state.provinceCommand(province);
      if (result <= _state.commandMilitary(command)) {
        return -1;
      }
    }
    return 0;
  }

  List<ProvinceStatus> provinceRevoltStatusCandidates(Location province) {
    final candidates = <ProvinceStatus>[];
    {
      final war = _state.pieceInLocation(PieceType.war, province);
      if (war != null) {
        final enemy = _state.warEnemy(war);
        if (enemy.foederatiStatus != null) {
          candidates.add(enemy.foederatiStatus!);
        }
      }
    }
    if (candidates.isEmpty) {
      for (final connection in _state.spaceConnections(province)) {
        if (connection.$2 != ConnectionType.sea) {
          final war = _state.pieceInLocation(PieceType.war, connection.$1);
          if (war != null) {
            final enemy = _state.warEnemy(war);
            if (enemy.foederatiStatus != null && !candidates.contains(enemy.foederatiStatus)) {
              candidates.add(enemy.foederatiStatus!);
            }
          }
        }
      }
    }
    if (candidates.isEmpty) {
      switch (_state.provinceStatus(province)) {
      case ProvinceStatus.foederatiFrankish:
      case ProvinceStatus.foederatiOstrogothic:
      case ProvinceStatus.foederatiSuevian:
      case ProvinceStatus.foederatiVandal:
      case ProvinceStatus.foederatiVisigothic:
      case ProvinceStatus.allied:
        candidates.add(ProvinceStatus.barbarian);
      case ProvinceStatus.insurgent:
        candidates.add(ProvinceStatus.allied);
      case ProvinceStatus.roman:
        candidates.add(ProvinceStatus.insurgent);
      case ProvinceStatus.barbarian:
      }
    }
    return candidates;
  }

  List<Piece> unfoughtWars() {
    final phaseState = _phaseState as PhaseStateWar;
    final wars = <Piece>[];
    for (final war in PieceType.war.pieces) {
      if (_state.warInPlay(war) && !phaseState.warsFought.contains(war)) {
        wars.add(war);
      }
    }
    return wars;
  }

  List<Location> unfoughtRebels() {
    final phaseState = _phaseState as PhaseStateWar;
    final rebels = <Location>[];
    for (final command in LocationType.command.locations) {
      if (_state.commandRebel(command) && _state.commandAllegiance(command) == command) {
        if (!phaseState.rebelsFought.contains(command)) {
          rebels.add(command);
        }
      }
    }
    return rebels;
  }

  void fightWar(Location warProvince, Location warCommand, Location warEmpire, List<Location> warProvinces) {
    final phaseState = _phaseState as PhaseStateWar;
    final war = _state.pieceInLocation(PieceType.war, warProvince)!;
    final enemy = _state.warEnemy(war);
    final leader = _state.pieceInLocation(PieceType.leader, warProvince);
    final warUnits = <Piece>[];
    final warFleets = <Piece>[];
    final general = _state.commandCommander(warCommand);
    for (final unit in PieceType.unit.pieces) {
      final location = _state.pieceLocation(unit);
      if (warProvinces.contains(location) && !phaseState.unitsFought.contains(unit)) {
        if (unit.isType(PieceType.fleet)) {
          warFleets.add(unit);
        } else {
          warUnits.add(unit);
        }
      }
    }

    logLine('### ${_state.commanderName(warCommand)} Fights ${war.desc} in ${warProvince.desc}');

    final rolls = roll3D6();
    int d1 = rolls.$1;
    int d2 = rolls.$2;
    int d3 = rolls.$3;
    int omens = rolls.$4;
    int total = rolls.$5;

    bool matchingWarAbility = false;
    bool stalemateAbility = false;
    bool conquestAbility = false;
    bool veteranAbility = false;
    if (general != null) {
      final ability = _state.statesmanAbility(general);
      switch (ability) {
      case Ability.conquest:
        conquestAbility = true;
      case Ability.stalemate:
        stalemateAbility = true;
      case Ability.veteran:
        veteranAbility = true;
      default:
        if (ability.warEnemy == enemy) {
          matchingWarAbility = true;
        }
      }
    }

    String warDesc = leader != null ? '${leader.desc} and the ${war.desc}' : 'the ${war.desc}';

    bool disaster = false;
    bool stalemate = false;
    if (d2 == d1) {
      if (d3 == d1 || _state.eventTypeCount(EventType.persecution) == 2) {
        disaster = true;
        if (matchingWarAbility) {
          disaster = false;
          logLine('> ${_state.statesmanName(general!)} averts Disaster.');
        } else if (stalemateAbility) {
          disaster = false;
          logLine('> ${_state.statesmanName(general!)} averts Disaster.');
          stalemate = true;
        }
      } else {
        if (matchingWarAbility) {
          logLine('> ${_state.statesmanName(general!)} breaks the Stalemate.');
        } else {
          stalemate = true;
        }
      }
      if (disaster) {
        if (d3 != d1) {
          logLine('> Low morale resulting from Persecution leads to Disaster.');
        }
      }
    }
  
    bool draw = false;
    bool triumph = false;

    if (disaster) {
      logLine('> Campaign against $warDesc ends in Disaster.');
    } else if (stalemate) {
      logLine('> Campaign against $warDesc results in a Stalemate.');
    } else {
      int nonMatchingFoederatiProvinceCount = 0;
      int modifiers = 0;
      int modifier = 0;
      modifier = _state.warStrength(war);
      logLine('> ${war.desc}: +$modifier');
      modifiers += modifier;
      if (leader != null) {
        modifier = _state.leaderStrength(leader);
        logLine('> ${leader.desc}": +$modifier');
        modifiers += modifier;
      }
      final spaces = _state.spaceConnectedSpaces(warProvince);
      spaces.add(warProvince);
      for (final space in spaces) {
        if (space.isType(LocationType.homeland)) {
          if (enemy.homelands.contains(space)) {
            modifier = 2;
          } else {
            modifier = 1;
          }
          logLine('> ${space.desc}: +$modifier');
          modifiers += modifier;
        } else {
          if (enemy == Enemy.isaurians && space == Location.provinceIsauria) {
            modifier = space == warProvince ? 2 : 1;
            logLine('> ${space.desc}: +$modifier');
            modifiers += modifier;
          }
          modifier = 0;
          final status = _state.provinceStatus(space);
          switch (status) {
          case ProvinceStatus.barbarian:
            modifier = 1;
          case ProvinceStatus.foederatiFrankish:
          case ProvinceStatus.foederatiOstrogothic:
          case ProvinceStatus.foederatiSuevian:
          case ProvinceStatus.foederatiVandal:
          case ProvinceStatus.foederatiVisigothic:
            if (status.foederati != enemy) {
              nonMatchingFoederatiProvinceCount += 1;
              modifier = -2;
            }
          case ProvinceStatus.allied:
            if (warProvinces.contains(space)) {
              modifier = -1;
            }
          case ProvinceStatus.insurgent:
          case ProvinceStatus.roman:
          }
          if (modifier > 0) {
            logLine('> ${space.desc}: +$modifier');
          } else if (modifier < 0) {
            logLine('> ${space.desc}: $modifier');
          }
          modifiers += modifier;
        }
      }
      modifier = 0;
      for (final unit in warUnits) {
        if (_state.unitVeteran(unit)) {
          modifier -= 2;
        } else {
          modifier -= 1;
        }
      }
      if (modifier != 0) {
        logLine('> Units: $modifier');
        modifiers += modifier;
      }
      if (matchingWarAbility) {
        modifier = -1;
        logLine('> ${_state.statesmanName(general!)} Ability: -1');
        modifiers += modifier;
      }
      modifier = -_state.commandMilitary(warCommand);
      logLine('> ${_state.commanderName(warCommand)}: $modifier');
      modifiers += modifier;

      modifier = _options.warRollModifier;
      if (modifier != 0) {
        if (modifier == 1) {
          logLine('> Harder Wars option: +1');
        } else if (modifier == -1) {
          logLine('> Easier Wars option: -1');
        }
        modifiers += modifier;
      }

      int result = total + modifiers;
      logLine('> Result: $result');

      if (result >= 12) {
        if (matchingWarAbility) {
          draw = true;
          logLine('> ${_state.statesmanName(general!)} narrowly avoids Defeat.');
          logLine('> Campaign against $warDesc results in a Draw.');
        } else if (stalemateAbility) {
          stalemate = true;
          logLine('> ${_state.statesmanName(general!)} narrowly avoids Defeat.');
          logLine('> Campaign against $warDesc results in a Stalemate.');
        } else {
          if (result - omens < 12) {
            logLine('> Campaign against $warDesc ends in Defeat, in accordance with the Omens.');
          } else {
            logLine('> Campaign against $warDesc ends in Defeat.');
          }
        }
      } else if (result >= 10) {
        draw = true;
        logLine('> Campaign against $warDesc results in a Draw.');
      } else {
        if (_state.warNavalStrength(war) > 0) {
          int fleetStrength = 0;
          for (final fleet in warFleets) {
            if (fleet.isType(PieceType.fleetVeteran)) {
              fleetStrength += 2;
            } else {
              fleetStrength += 1;
            }
          }
          if (fleetStrength + nonMatchingFoederatiProvinceCount < _state.warNavalStrength(war)) {
            draw = true;
            logLine('> Campaign against $warDesc results in a Draw due to a shortage of Fleets.');
          }
        }
        if (_state.warCavalryStrength(war) > 0) {
          int cavalryStrength = 0;
          for (final unit in warUnits) {
            if (unit.isType(PieceType.cavalry)) {
              if (unit.isType(PieceType.cavalryVeteran)) {
                cavalryStrength += 2;
              } else {
                cavalryStrength += 1;
              }
            }
          }
          if (cavalryStrength + nonMatchingFoederatiProvinceCount < _state.warCavalryStrength(war)) {
            draw = true;
            logLine('> Campaign against $warDesc results in a Draw due to a shortage of Cavalry.');
          }
        }
        if (!draw) {
          triumph = true;
          if (result - omens >= 10) {
            logLine('> Campaign against $warDesc end in Triumph, in accordance with the Omens.');
          } else {
            logLine('> Campaign against $warDesc ends in Triumph.');
          }
        }
      }
    }

    int lossCount = d3;
    int destroyLegionsCount = 0;
    int promoteCount = 0;
    int annexCount = 0;
    int gold = 0;
    int prestigeUnrest = 0;
    int rebelGold = 0;

    if (disaster) {
      destroyLegionsCount = (lossCount + 1) ~/ 2;
    }
    if (stalemate || draw || triumph) {
      promoteCount = veteranAbility ? 2 : 1;
    }

    String lossesDesc = lossCount == 1 ? 'Loss' : 'Losses';
    logLine('> Campaign incurs $lossCount $lossesDesc.');

    if (disaster) {
      logLine('> ${_state.commanderName(warCommand)} is Killed.');
      if (warCommand.isType(LocationType.emperor)) {
        emperorDies(warCommand);
      } else {
        governorDies(warCommand);
      }
      adjustEmpireUnrest(warEmpire, lossCount);
      adjustEmpirePrestige(warEmpire, -lossCount);
    }

    if (triumph) {
      _state.setPieceLocation(war, warCommand);
      if (leader != null) {
        redistributeEnemyLeaders(enemy);
      }
      gold = _state.warStrength(war) * _state.commandAdministration(warCommand);
      prestigeUnrest = (_state.warStrength(war) + 1) ~/ 2;
      if (_state.commandRebel(warCommand) && warCommand.isType(LocationType.governorship)) {
        rebelGold = gold;
        gold = 0;
        prestigeUnrest = 0;
      }

      annexCount = 1;
      if (conquestAbility || matchingWarAbility) {
        annexCount += 1;
      }
      final emperor = _state.commandCommander(warEmpire);
      if (emperor != null && _state.statesmanAbility(emperor) == Ability.conquest) {
        annexCount += 1;
      }
    }

    if (disaster && warCommand.isType(LocationType.emperor)) {
      phaseState.deadEmperor = warCommand;
    }

    phaseState.triumph = triumph;
    phaseState.lossCount = lossCount;
    phaseState.destroyLegionsCount = destroyLegionsCount;
    phaseState.promoteCount = promoteCount;
    phaseState.annexCount = annexCount;
    phaseState.prestige = prestigeUnrest;
    phaseState.unrest = prestigeUnrest;
    phaseState.gold = gold;
    phaseState.rebelGold = rebelGold;
  }

  void fightRebel(Location emperorCommand, Location rebelCommand) {
    final phaseState = _phaseState as PhaseStateWar;
    int emperorStrength = 0;
    int rebelStrength = 0;
    bool emperorLoyal = _state.commandLoyal(emperorCommand);

    int rebelCommandCount = 0;
    for (final governorship in LocationType.governorship.locations) {
      if (_state.commandAllegiance(governorship) == rebelCommand) {
        rebelCommandCount += 1;
      }
    }

    const unitTypes = [
      PieceType.cavalryOrdinary,
      PieceType.guardOrdinary,
      PieceType.pseudoLegion,
      PieceType.legionOrdinary,
      PieceType.fleetOrdinary,
      PieceType.cavalryVeteran,
      PieceType.guardVeteran,
      PieceType.legionVeteran,
      PieceType.fleetVeteran];
    for (int i = 0; i < unitTypes.length; ++i) {
      final unitType = unitTypes[i];
      bool veteran = i >= 5;
      for (final unit in unitType.pieces) {
        final unitLocation = _state.pieceLocation(unit);
        if (unitLocation.isType(LocationType.province)) {
          int unitStrength = veteran ? 2 : 1;
          final unitCommand = _state.provinceCommand(unitLocation);
          final unitEmpire = _state.commandEmpire(unitCommand);
          final unitEmperor = _state.empireEmperor(unitEmpire);
          final unitAllegiance = _state.commandAllegiance(unitCommand);
          bool forEmperor = false;
          if (emperorLoyal) {
            forEmperor = unitEmperor == emperorCommand && _state.commandLoyal(unitCommand);
          } else {
            forEmperor = unitAllegiance == emperorCommand;
          }
          bool forRebel = unitAllegiance == rebelCommand;
          if (forEmperor) {
            phaseState.units.add(unit);
            emperorStrength += unitStrength;
          } else if (forRebel) {
            phaseState.rebelUnits.add(unit);
            rebelStrength += unitStrength;
          }
        }
      }
    }

    for (final province in LocationType.province.locations) {
      final status = _state.provinceStatus(province);
      if (status.foederati != null) {
        final provinceCommand = _state.provinceCommand(province);
        final provinceEmpire = _state.commandEmpire(provinceCommand);
        final provinceEmperor = _state.empireEmperor(provinceEmpire);
        final provinceAllegiance = _state.commandAllegiance(provinceCommand);
        bool forEmperor = false;
        if (emperorLoyal) {
          forEmperor = provinceEmperor == emperorCommand && _state.commandLoyal(provinceCommand);
        } else {
          forEmperor = provinceAllegiance == emperorCommand;
        }
        bool forRebel = provinceAllegiance == rebelCommand;
        if (forEmperor) {
          emperorStrength += 1;
        } else if (forRebel) {
          rebelStrength += 1;
        }
      }
    }

    bool rebelVictory = false;
    bool stalemate = false;
    bool rebelDefeat = false;

    logLine('### ${_state.commanderName(emperorCommand)} vs. ${_state.commanderName(rebelCommand)}');

    final rolls = roll3D6();
    final d3 = rolls.$3;
    final omens = rolls.$4;
    final total = rolls.$5;

    int modifiers = 0;
    int modifier = 0;
    modifier = _state.commandMilitary(rebelCommand);
    logLine('> ${_state.commanderName(rebelCommand)}: +$modifier');
    modifiers += modifier;
    modifier = rebelStrength;
    logLine('> Rebel Strength: +$modifier');
    modifiers += modifier;
    modifier = -emperorStrength;
    logLine('> Emperor Strength: $modifier');
    modifiers += modifier;
    modifier = -_state.commandMilitary(emperorCommand);
    logLine('> ${_state.commanderName(emperorCommand)}: $modifier');
    modifiers += modifier;

    int result = total + modifiers;
    logLine('> Result: $result');

    int lossCount = d3;
    int destroyLegionsCount = (lossCount + 1) ~/ 2;
    int promoteCount = 0;
    int emperorPromoteCount = 0;
    int rebelPromoteCount = 0;

    final emperorStatesman = _state.pieceInLocation(PieceType.statesman, emperorCommand);
    final rebelStatesman = _state.pieceInLocation(PieceType.statesman, rebelCommand);

    bool emperorVeteranAbility = emperorStatesman != null && _state.statesmanAbility(emperorStatesman) == Ability.veteran;
    bool rebelVeteranAbility = rebelStatesman != null && _state.statesmanAbility(rebelStatesman) == Ability.veteran;

    if (result >= 12) {
      rebelVictory = true;
      if (result - omens < 12) {
        logLine('> ${_state.commanderName(rebelCommand)} is victorious, in accordance with the Omens.');
      } else {
        logLine('> ${_state.commanderName(rebelCommand)} is victorious.');
      }
    } else if (result >= 10) {
      stalemate = true;
      logLine('> Civil War with ${_state.commanderName(rebelCommand)} is a Stalemate.');
    } else {
      rebelDefeat = true;
      if (result - omens >= 10) {
        logLine('> Civil War ends with ${_state.commanderName(rebelCommand)} being defeated, in accordance with the Omens.');
      } else {
        logLine('> Civil War ends with ${_state.commanderName(rebelCommand)} being defeated.');
      }
    }

    String lossesDesc = lossCount == 1 ? 'Loss' : 'Losses';
    logLine('> Civil War incurs $lossCount $lossesDesc.');

    if (rebelVictory) {
      logLine('> ${_state.commanderName(emperorCommand)} is overthrown.');
      int prestigeAmount = -_state.commandAdministration(emperorCommand);
      int unrestAmount = _state.commandPopularity(emperorCommand);
      adjustEmpireUnrest(emperorCommand, unrestAmount);
      adjustEmpirePrestige(emperorCommand, prestigeAmount);
      emperorDies(emperorCommand);
      rebelPromoteCount = rebelVeteranAbility ? 2 : 1;
    }
    if (stalemate) {
      promoteCount = 1;
      emperorPromoteCount = emperorVeteranAbility ? 0 : 1;
      rebelPromoteCount = rebelVeteranAbility ? 0 : 1;
    }
    if (rebelDefeat) {
      int amount = rebelCommandCount;
      logLine('> ${_state.commanderName(rebelCommand)} is Killed.');
      if (rebelCommand.isType(LocationType.emperor)) {
        emperorDies(rebelCommand);
      } else {
        governorDies(rebelCommand);
      }
      adjustEmpireUnrest(emperorCommand, -amount);
      adjustEmpirePrestige(emperorCommand, amount);
      emperorPromoteCount = emperorVeteranAbility ? 2 : 1;
    }

    if (rebelVictory) {
      phaseState.deadEmperor = emperorCommand;
    } else if (rebelDefeat && rebelCommand.isType(LocationType.emperor)) {
      phaseState.deadEmperor = rebelCommand;
    }

    phaseState.lossCount = lossCount;
    phaseState.destroyLegionsCount = destroyLegionsCount;
    phaseState.promoteCount = emperorPromoteCount;
    phaseState.anyPromoteCount = promoteCount;
    phaseState.rebelPromoteCount = rebelPromoteCount;
  }

  void advanceScenario() {
    const scenarioStatesmen = [
	    [
        Piece.dynastyConstantinian,
        Piece.statesmanConstantiusI,
        Piece.statesmanGalerius,
        Piece.statesmanMaximinusII,
        Piece.statesmanConstantineI,
        Piece.statesmanMaxentius,
        Piece.statesmanLicinius,
        Piece.statesmanArius,
        Piece.statesmanCrispus,
        Piece.statesmanConstantineII,
        Piece.statesmanConstantiusII,
        Piece.statesmanConstans,
        Piece.statesmanMagnentius,
        Piece.statesmanJulian,
      ],
    	[
        Piece.dynastyValentinian,
        Piece.dynastyTheodosian,
        Piece.statesmanValentinianI,
        Piece.statesmanValens,
        Piece.statesmanTheodosius,
        Piece.statesmanAmbrose,
        Piece.statesmanGratian,
        Piece.statesmanTheodosiusI,
        Piece.statesmanArbogast,
        Piece.statesmanArcadius,
        Piece.statesmanHonorius,
        Piece.statesmanStilicho,
        Piece.statesmanGainas,
        Piece.statesmanEutropius,
        Piece.statesmanAlaric,
        Piece.statesmanAnthemius,
        Piece.statesmanTheodosiusII,
        Piece.statesmanConstantiusII,
        Piece.statesmanValentinianIII,
      ],
      [
        Piece.dynastyLeonid,
        Piece.statesmanAspar,
        Piece.statesmanAetius,
        Piece.statesmanAuxerre,
        Piece.statesmanPopeLeo,
        Piece.statesmanMarcian,
        Piece.statesmanPetronius,
        Piece.statesmanRicimer,
        Piece.statesmanMajorian,
        Piece.statesmanAegidius,
        Piece.statesmanLeoI,
        Piece.statesmanZeno,
        Piece.statesmanBasiliscus,
        Piece.statesmanOdoacer,
        Piece.statesmanTheodoric,
        Piece.statesmanAnastasius,
      ],
      [
        Piece.dynastyJustinian,
        Piece.statesmanJustinI,
        Piece.statesmanJustinianI,
        Piece.statesmanGermanus,
        Piece.statesmanTheodora,
        Piece.statesmanNarses,
        Piece.statesmanBelisarius,
        Piece.statesmanLiberius,
        Piece.statesmanTroglita,
        Piece.statesmanJustinII,
      ],
      [
        Piece.statesmanTiberiusII,
        Piece.statesmanMaurice,
        Piece.statesmanMystacon,
        Piece.statesmanComentiolus,
        Piece.statesmanPriscus,
        Piece.statesmanGregory,
        Piece.statesmanPhocas,
        Piece.statesmanBonus,
        Piece.statesmanSergius,
        Piece.statesmanHeraclius,
      ],
    ];

    const scenarioBarbarians = [
      [
        Piece.leaderShapur,
        Piece.warAlan9,
        Piece.warArabian5,
        Piece.warFrankish13,
        Piece.warFrankish11,
        Piece.warMoorish7,
        Piece.warMoorish5,
        Piece.warNubian4,
        Piece.warPersian15,
        Piece.warPersian13,
        Piece.warPersian11,
        Piece.warPictish4,
        Piece.warSarmatian10,
        Piece.warSarmatian8,
        Piece.warSaxon4,
        Piece.warScottish5,
        Piece.warSuevian13,
        Piece.warSuevian11,
        Piece.warSuevian9,
        Piece.warVandal91,
        Piece.warVisigothic12,
        Piece.warVisigothic10,
      ],
      [
        Piece.leaderFritigern,
        Piece.warAlan9,
        Piece.warArabian5,
        Piece.warBurgundian11,
        Piece.warFrankish13,
        Piece.warFrankish11,
        Piece.warHunnic14,
        Piece.warHunnic13,
        Piece.warIsaurian7,
        Piece.warMoorish7,
        Piece.warMoorish5,
        Piece.warOstrogothic13,
        Piece.warOstrogothic11,
        Piece.warPersian13,
        Piece.warPersian11,
        Piece.warPictish6,
        Piece.warPictish4,
        Piece.warSarmatian8,
        Piece.warSaxon6,
        Piece.warSaxon4,
        Piece.warScottish5,
        Piece.warSuevian13,
        Piece.warSuevian11,
        Piece.warSuevian9,
        Piece.warVandal93,
        Piece.warVandal8,
        Piece.warVandal7,
        Piece.warVisigothic14,
        Piece.warVisigothic12,
        Piece.warVisigothic10,
      ],
      [
        Piece.leaderAttila,
        Piece.leaderClovis,
        Piece.leaderGaiseric,
        Piece.warBurgundian11,
        Piece.warFrankish13,
        Piece.warFrankish11,
        Piece.warHunnic15,
        Piece.warHunnic14,
        Piece.warHunnic13,
        Piece.warIsaurian7,
        Piece.warMoorish5,
        Piece.warNubian4,
        Piece.warOstrogothic13,
        Piece.warOstrogothic11,
        Piece.warPersian13,
        Piece.warPersian11,
        Piece.warPictish6,
        Piece.warPictish4,
        Piece.warSaxon6,
        Piece.warSaxon4,
        Piece.warScottish5,
        Piece.warSuevian13,
        Piece.warSuevian11,
        Piece.warSuevian9,
        Piece.warVandal93,
        Piece.warVandal8,
        Piece.warVandal7,
        Piece.warVisigothic14,
        Piece.warVisigothic12,
        Piece.warVisigothic10,
      ],
      [
        Piece.leaderChosroes,
        Piece.leaderTotila,
        Piece.warArabian5,
        Piece.warBulgar14,
        Piece.warBulgar12,
        Piece.warBurgundian11,
        Piece.warFrankish13,
        Piece.warFrankish11,
        Piece.warHunnic13,
        Piece.warMoorish7,
        Piece.warMoorish5,
        Piece.warOstrogothic13,
        Piece.warOstrogothic11,
        Piece.warPersian13,
        Piece.warPersian11,
        Piece.warSaxon6,
        Piece.warSaxon4,
        Piece.warSlav8,
        Piece.warVandal93,
        Piece.warVisigothic10,
      ],
      [
        Piece.leaderBayan,
        Piece.leaderChosroes,
        Piece.warArabian5,
        Piece.warAvar15,
        Piece.warAvar13,
        Piece.warAvar11,
        Piece.warBulgar14,
        Piece.warBulgar12,
        Piece.warFrankish13,
        Piece.warFrankish11,
        Piece.warHunnic13,
        Piece.warMoorish7,
        Piece.warMoorish5,
        Piece.warNubian4,
        Piece.warPersian15,
        Piece.warPersian13,
        Piece.warPersian11,
        Piece.warSaxon6,
        Piece.warSlav8,
        Piece.warSlav6,
        Piece.warSuevian13,
        Piece.warSuevian11,
        Piece.warSuevian9,
        Piece.warVisigothic12,
        Piece.warVisigothic10,
      ],
    ];

    const scenarioPrestigeBonuses = [
      [0, 0],
      [0, 25],
      [25, 50],
      [15, 15],
      [25, 25],
    ];

    int newScenario = (_state.turn + 1) ~/ 10;

    _state.adjustEmpirePrestige(Location.commandEasternEmperor, scenarioPrestigeBonuses[newScenario][0] - 75);
    _state.adjustEmpirePrestige(Location.commandWesternEmperor, scenarioPrestigeBonuses[newScenario][1] - 75);

    final statesmen = scenarioStatesmen[newScenario];
    for (final statesman in statesmen) {
      _state.setPieceLocation(statesman, Location.poolStatesmen);
    }
    final barbarians = scenarioBarbarians[newScenario];
    for (final barbarian in barbarians) {
      if (_state.pieceLocation(barbarian) == Location.offmap) {
        _state.setPieceLocation(barbarian, Location.poolWars);
      } else {
        _state.resurrectBarbarian(barbarian);
      }
    }
  }

  // Sequence Helpers

  void fixOverstacking() {
    while (_state.overstackedProvinces().isNotEmpty) {
      if (choicesEmpty()) {
        setPrompt('Relocate Units from non-Roman Provinces');
        for (final province in LocationType.province.locations) {
          final units = _state.provinceOverstackedUnits(province);
          for (final unit in units) {
            pieceChoosable(unit);
          }
        }
        throw PlayerChoiceException();
      }
      final unit = selectedPiece()!;
      final fromProvince = _state.pieceLocation(unit);
      final toProvince = selectedLocation();
      if (toProvince == null) {
        if (_state.unitCanTransfer(unit)) {
          setPrompt('Select Province to Transfer ${unit.desc} to');
          final command = _state.provinceCommand(_state.pieceLocation(unit));
          final commandLocationType = _state.commandLocationType(command)!;
          for (final province in commandLocationType.locations) {
            if (_state.unitCanTransferToProvince(unit, province, true, false, true)) {
              locationChoosable(province);
            }
          }
          if (choosableLocationCount == 0) {
            for (final province in LocationType.province.locations) {
              if (_state.unitCanTransferToProvince(unit, province, true, false, true)) {
                locationChoosable(province);
              }
            }
          }
          if (choosableLocationCount == 0) {
            for (final province in commandLocationType.locations) {
              if (_state.unitCanTransferToProvince(unit, province, true, false, false)) {
                locationChoosable(province);
              }
            }
          }
          if (choosableLocationCount == 0) {
            for (final province in LocationType.province.locations) {
              if (_state.unitCanTransferToProvince(unit, province, true, false, false)) {
                locationChoosable(province);
              }
            }
          }
          if (choosableLocationCount > 0) {
            throw PlayerChoiceException();
          }
        }
        logLine('> ${unit.desc} in ${fromProvince.desc} cannot be Transferred.');
        if (unit.isType(PieceType.legionaries)) {
          logLine('> ${unit.desc} Destroyed.');
          _state.setPieceLocation(unit, Location.offmap);
        } else {
          logLine('> ${unit.desc} Dismissed.');
          _state.setPieceLocation(unit, Location.boxBarracks);
        }
      }
      if (toProvince != null) {
        logLine('> Transferred ${unit.desc} from ${fromProvince.desc} to ${toProvince.desc}.');
        final fromCommand = _state.provinceCommand(fromProvince);
        final toCommand = _state.provinceCommand(toProvince);
        _state.setPieceLocation(unit, toProvince);
        if (toCommand != fromCommand) {
          adjustEmpireUnrest(_state.commandEmpire(fromCommand), 1);
        }
      }
      clearChoices();
		}
	}

  void newEmperor(Location emperor, Location? emperorOther, EmperorDeathCause cause, Location? causeCommand) {
    _newEmperorState ??= NewEmperorState();
    final localState = _newEmperorState!;
    if (localState.subStep == 0) {
      // a, b
      if (cause == EmperorDeathCause.rebelEmperorVictory || cause == EmperorDeathCause.rebelEmperorDefeat || cause == EmperorDeathCause.empireFell) {
        logLine('> ${_state.commanderName(causeCommand!)} becomes Sole Emperor.');
        if (_state.commandRebel(emperor)) {
          rebelEmperorBecomesLoyal(emperor);
        }
        if (_state.commandRebel(causeCommand)) {
          rebelEmperorBecomesLoyal(causeCommand);
        }
        if (cause != EmperorDeathCause.empireFell) {
          _state.setEmpireHasViceroy(emperor, true);
        }
        _newEmperorState = null;
        return;
      }

      if (cause == EmperorDeathCause.assassination || cause == EmperorDeathCause.rebelGovernorVictory || cause == EmperorDeathCause.noLoyalProvinces) {
        if (cause == EmperorDeathCause.noLoyalProvinces) {
          final rebelGovernors = <Location>[];
          final eligibleRebelGovernors = <Location>[];
          for (final governorship in LocationType.governorship.locations) {
            if (_state.commandEmpire(governorship) == emperor) {
              if (_state.commandRebel(governorship) && _state.commandAllegiance(governorship) == governorship) {
                rebelGovernors.add(governorship);
                final statesman = _state.commandCommander(governorship);
                if (statesman == null || !_state.statesmanIneligible(statesman)) {
                  eligibleRebelGovernors.add(governorship);
                }
              }
            }
          }
          if (eligibleRebelGovernors.isNotEmpty) {
            causeCommand = randLocation(eligibleRebelGovernors);
          } else {
            causeCommand = randLocation(rebelGovernors);
          }
        }
        final causeStatesman = _state.commandCommander(causeCommand!);
        bool causeEligible = causeStatesman == null || !_state.statesmanIneligible(causeStatesman);

        // c
        if (causeEligible && _state.soleEmperor) {
          logLine('> ${_state.commanderName(causeCommand)} becomes Sole Emperor.');
          governorBecomesLoyalEmperor(causeCommand, emperor);
          _newEmperorState = null;
          return;
        }

        // d
        if (causeEligible) {
          logLine('> ${_state.commanderName(causeCommand)} becomes Rebel ${_state.commanderPositionName(emperor)}.');
          governorBecomesRebelEmperor(causeCommand, emperor);
          _newEmperorState = null;
          return;
        }

        logLine('> ${_state.commanderName(causeCommand)} supports a new puppet Emperor.');
        if (_state.commandRebel(causeCommand)) {
          governorshipBecomesLoyalToEmperor(causeCommand);
        }
      }

      localState.emperorVacancies.add(emperor);
      if (emperorOther != null) {
        localState.emperorVacancies.add(emperorOther);
      } else if (_state.empireHasViceroy(_state.otherEmpire(emperor))) {
        _state.setEmpireHasViceroy(_state.otherEmpire(emperor), false);
        localState.emperorVacancies.add(_state.otherEmpire(emperor));
      }

      if (localState.emperorVacancies.length > 1) {
        localState.emperorVacancies.shuffle(_random);
      }

      localState.subStep = 1;
    }

    for (int i = localState.vacancyIndex; i < localState.emperorVacancies.length; ++i) {
      localState.vacancyIndex = i;

      final vacancy = localState.emperorVacancies[i];

      // e
      bool vacancyFilled = false;
      for (final dynasty in PieceType.dynasty.pieces) {
        if (_state.dynastyActive(dynasty)) {
          for (final statesman in _state.dynastyImperialStatesmen(dynasty)) {
            if (_state.statesmanInPlay(statesman)) {
              final location = _state.pieceLocation(statesman);
              if (!location.isType(LocationType.emperor)) {
                logLine('> ${_state.statesmanName(statesman)} becomes ${_state.commanderPositionName(vacancy)}');
                if (location.isType(LocationType.governorship)) {
                  governorBecomesLoyalEmperor(location, vacancy);
                } else {
                  statesmanBecomesLoyalEmperor(statesman, vacancy);
                }
                vacancyFilled = true;
                break;
              }
            }
          }
          if (vacancyFilled) {
            break;
          }
        }
      }
      if (vacancyFilled) {
        continue;
      }

      // f
      final candidateStatesmen = <Piece>[];
      for (final statesman in PieceType.statesman.pieces) {
        if (_state.statesmanInPlay(statesman) && !_state.statesmanIneligible(statesman)) {
          final location = _state.pieceLocation(statesman);
          if (!location.isType(LocationType.command) || !location.isType(LocationType.emperor)) {
            candidateStatesmen.add(statesman);
          }
        }
      }
      Piece? statesman;
      if (candidateStatesmen.length == 1) {
        statesman = candidateStatesmen[0];
      }
      if (candidateStatesmen.length > 1) {
        if (choicesEmpty()) {
          setPrompt('Select Statesman who will become ${_state.commanderPositionName(vacancy)}');
          for (final statesman in candidateStatesmen) {
            pieceChoosable(statesman);
          }
          throw PlayerChoiceException();
        }
        statesman = selectedPiece();
      }
      if (statesman != null) {
        logLine('> ${_state.statesmanName(statesman)} becomes ${_state.commanderPositionName(vacancy)}');
        final location = _state.pieceLocation(statesman);
        if (location.isType(LocationType.governorship)) {
          governorBecomesLoyalEmperor(location, vacancy);
        } else {
          statesmanBecomesLoyalEmperor(statesman, vacancy);
        }
        continue;
      }

      // g
      logLine('> A new ${_state.commanderPositionName(vacancy)} is appointed.');
      genericBecomesLoyalEmperor(vacancy);
    }

    _newEmperorState = null;
  }

  void assassinationAttempt(Location assassinCommand, Location? targetCommand, Piece? targetStatesman) {
    _assassinationAttemptState ??= AssassinationAttemptState();
    final localState = _assassinationAttemptState!;

    if (localState.subStep == 0) {
      if (targetCommand != null) {
        logLine('### ${_state.commanderName(assassinCommand)} attempts to Assassinate ${_state.fullCommanderName(targetCommand)}');
      } else {
        logLine('### ${_state.commanderName(assassinCommand)} attempts to Assassinate ${_state.statesmanName(targetStatesman!)}');
      }
      int modifiers = 0;
      int die = rollD6();
      int modifier = 0;
      int assassinPopularity = _state.commandPopularity(assassinCommand);
      int targetPopularity = targetCommand != null ? _state.commandPopularity(targetCommand) : _state.statesmanPopularity(targetStatesman!);
      int popularityModifier = 0;
      if (assassinPopularity >= targetPopularity) {
        modifier = assassinPopularity;
        logLine('> ${_state.commanderName(assassinCommand)} Popularity: +$modifier');
        modifiers += modifier;
        modifier = -targetPopularity;
        if (targetCommand != null) {
          logLine('> ${_state.commanderName(targetCommand)} Popularity: $modifier');
        } else {
          logLine('> ${_state.statesmanName(targetStatesman!)} Popularity: $modifier');
        }
        modifiers += modifier;
        popularityModifier = assassinPopularity - targetPopularity;
      } else {
        modifier = targetPopularity;
        if (targetCommand != null) {
          logLine('> ${_state.commanderName(targetCommand)} Popularity: +$modifier');
        } else {
          logLine('> ${_state.statesmanName(targetStatesman!)} Popularity: +$modifier');
        }
        modifiers += modifier;
        modifier = -assassinPopularity;
        logLine('> ${_state.commanderName(assassinCommand)} Popularity: $modifier');
        modifiers += modifier;
        popularityModifier = targetPopularity - assassinPopularity;
      }
      modifier = _state.commandIntrigue(assassinCommand);
      logLine('> ${_state.commanderName(assassinCommand)} Intrigue: +$modifier');
      modifiers += modifier;
      if (targetCommand != null) {
        modifier = _state.commandIntrigue(targetCommand);
        logLine('> ${_state.commanderName(targetCommand)} Intrigue: +$modifier');
      } else {
        modifier = _state.statesmanIntrigue(targetStatesman!);
        logLine('> ${_state.statesmanName(targetStatesman)} Intrigue: +$modifier');
      }
      modifiers += modifier;
      modifier = _state.dynastiesCount;
      if (modifier > 0) {
        logLine('> Dynasties: + $modifier');
        modifiers += modifier;
      }
      modifier = _state.eventTypeCount(EventType.conspiracy);
      if (modifier > 0) {
        if (modifier == 1) {
          logLine('> Conspiracy Event: +$modifier');
        } else {
          logLine('> Conspiracy Event (doubled): + $modifier');
        }
        modifiers += modifier;
      }
      int conspiracyModifier = modifier;
      modifier = -_state.eventTypeCount(EventType.bodyguard);
      if (modifier < 0) {
        if (modifier == -1) {
          logLine('> Bodyguards Event: $modifier');
        } else {
          logLine('> Bodyguards Event (doubled): $modifier');
        }
        modifiers += modifier;
      }
      int bodyguardsModifier = modifier;
      int guardsModifier = 0;
      int cavalryModifier = 0;
      if (targetCommand != null) {
        modifier = -_state.assassinationGuardsInCapitalCount(targetCommand);
        if (modifier < 0) {
          logLine('> Guards in Capital: $modifier');
          modifiers += modifier;
        }
        guardsModifier += modifier;
        modifier = -_state.assassinationVeteranGuardsOutsideCapitalCount(targetCommand);
        if (modifier < 0) {
          logLine('> Veteran Guards outside Capital: $modifier');
          modifiers += modifier;
        }
        guardsModifier += modifier;
        modifier = -_state.assassinationVeteranCavalryCount(targetCommand);
        if (modifier < 0) {
          logLine('> Veteran Cavalry: $modifier');
          modifiers += modifier;
        }
        cavalryModifier += modifier;
      }
      int result = die + modifiers;
      logLine('> Total: $result');

      String assassinName = _state.commanderName(assassinCommand);
      String targetName = targetCommand != null ? _state.commanderName(targetCommand) : _state.statesmanName(targetStatesman!);

      if (result < 12) {
        if (result - bodyguardsModifier >= 12) {
          logLine('> Attempt to Assassinate $targetName is thwarted by Bodyguards.');
        } else if (result - guardsModifier >= 12) {
          logLine('> Attempt to Assassinate $targetName is thwarted by the Guard.');
        }
        else if (result - cavalryModifier >= 12) {
          logLine('> Attempt to Assassinate $targetName is thwarted by the Cavalry.');
        } else {
          logLine('> A plot to Assassinate $targetName is uncovered.');
        }
        _assassinationAttemptState = null;
        return;
      }

      if (result - conspiracyModifier < 12) {
        if (assassinCommand.isType(LocationType.governorship)) {
          logLine('> A Conspiracy led by $assassinName Assassinates $targetName.');
        } else {
          logLine('> A Conspiracy initiated by $assassinName Assassinates $targetName.');
        }
      } else if (result - popularityModifier < 12 && popularityModifier >= 2) {
        if (assassinPopularity > targetPopularity) {
          if (targetPopularity == 1) {
            logLine('> $assassinName Assassinates pagan $targetName.');
          } else if (targetPopularity == 2) {
            logLine('> $assassinName Assassinates heretical $targetName.');
          } else {
            logLine('> Devout $assassinName Assassinates $targetName.');
          }
        } else {
          if (assassinPopularity == 1) {
            logLine('> Pagan $assassinName Assassinates $targetName.');
          } else if (assassinPopularity == 1) {
            logLine('> Heretical $assassinName Assassinates $targetName.');
          } else {
            logLine('> $assassinName Assassinates zealot $targetName.');
          }
        }
      } else {
        logLine('> $targetName is Assassinated by $assassinName.');
      }

      if (targetCommand != null) {
        final targetEmpire = _state.commandEmpire(targetCommand);
        adjustEmpirePrestige(targetEmpire, -_state.commandAdministration(targetCommand));
        adjustEmpireUnrest(targetEmpire, _state.commandPopularity(targetCommand));
        if (targetCommand.isType(LocationType.governorship)) {
          governorDies(targetCommand);
        }
      } else {
        _state.setPieceLocation(targetStatesman!, Location.offmap);
      }

      if (targetCommand == null || !targetCommand.isType(LocationType.emperor)) {
        _assassinationAttemptState = null;
        return;
      }

      localState.subStep = 1;
    }

    if (localState.subStep == 1) {
      emperorDies(targetCommand!);
      newEmperor(targetCommand, null, EmperorDeathCause.assassination, assassinCommand);
    }

    _assassinationAttemptState = null;
  }

  Location? annexAnyProvinceInEmpires(List<Location> empires) {
    while (true) {
      if (choicesEmpty()) {
        setPrompt('Select Province to Annex');
        for (final province in LocationType.province.locations) {
          if (_state.spaceCanBeAnnexed(province, EnemyExtension.allFoederati)) {
            final command = _state.provinceCommand(province);
            final empire = _state.commandEmpire(command);
            if (empires.contains(empire)) {
              locationChoosable(province);
            }
          }
        }
        if (choosableLocationCount == 0) {
          choiceChoosable(Choice.next, true);
        }
        throw PlayerChoiceException();
      } 
      if (checkChoiceAndClear(Choice.next)) {
        logLine('> No Provinces available for Annexation.');
        return null;
      }
      if (checkChoice(Choice.cancel)) {
        clearChoices();
        continue;
      }
      final province = selectedLocation()!;
      final oldStatus = _state.provinceStatus(province);
      final foederatiCandidates = <Enemy>[];
      if (oldStatus == ProvinceStatus.barbarian) {
        for (final foederati in EnemyExtension.allFoederati) {
          if (_state.spaceHasConnectionToFoederatiProvince(province, [foederati])) {
            foederatiCandidates.add(foederati);
          }
        }
      }
      if (foederatiCandidates.isEmpty || checkChoice(Choice.roman)) {
        annexProvince(province);
        clearChoices();
        return province;
      }
      Enemy? foederati;
      if (checkChoice(Choice.frankish)) {
        foederati = Enemy.franks;
      } else if (checkChoice(Choice.ostrogothic)) {
        foederati = Enemy.ostrogoths;
      } else if (checkChoice(Choice.suevian)) {
        foederati = Enemy.suevi;
      } else if (checkChoice(Choice.vandal)) {
        foederati = Enemy.vandals;
      } else if (checkChoice(Choice.visigothic)) {
        foederati = Enemy.visigoths;
      }
      if (foederati != null) {
        annexProvinceToFoederati(province, foederati);
        clearChoices();
        return province;
      }
      setPrompt('Select Allegiance for ${province.desc}');
      choiceChoosable(Choice.roman, _state.spaceHasConnectionToAlliedOrBetterProvince(province));
      if (foederatiCandidates.contains(Enemy.franks)) {
        choiceChoosable(Choice.frankish, true);
      }
      if (foederatiCandidates.contains(Enemy.ostrogoths)) {
        choiceChoosable(Choice.ostrogothic, true);
      }
      if (foederatiCandidates.contains(Enemy.suevi)) {
        choiceChoosable(Choice.suevian, true);
      }
      if (foederatiCandidates.contains(Enemy.vandals)) {
        choiceChoosable(Choice.vandal, true);
      }
      if (foederatiCandidates.contains(Enemy.visigoths)) {
        choiceChoosable(Choice.visigothic, true);
      }
      choiceChoosable(Choice.cancel, true);
      throw PlayerChoiceException();
    }
  }

  void eventAssassin() {
    _eventAssassinState ??= EventAssassinState();
    final localState = _eventAssassinState!;

    if (localState.assassinCommand == null) {
      final candidateEmperors = <Location>[];
      for (final emperor in _state.activeEmperors) {
        if (_state.commandLoyal(emperor)) {
          candidateEmperors.add(emperor);
        }
      }
      if (candidateEmperors.isEmpty) {
        logLine('> Assassination attempt does not materialize.');
        _eventAssassinState = null;
        return;
      }
      final emperor = randLocation(candidateEmperors)!;
      final assassin = randEmpireGovernor(emperor);
      localState.assassinCommand = assassin;
      localState.targetCommand = emperor;
    }
    assassinationAttempt(localState.assassinCommand!, localState.targetCommand, null);
    _eventAssassinState = null;
  }

  void eventAssassinDoubled() {
    _eventAssassinState ??= EventAssassinState();
    final localState = _eventAssassinState!;

    if (localState.assassinCommand == null) {
      final assassin = randEmperor();
      final targets = [];
      if (!_state.soleEmperor) {
        targets.add(_state.otherEmpire(assassin));
      }
      for (final governorship in LocationType.governorship.locations) {
        if (_state.commandAllegiance(governorship) == governorship) {
          targets.add(governorship);
        }
      }
      for (final statesman in _state.piecesInLocation(PieceType.statesman, Location.poolStatesmen)) {
        targets.add(statesman);
      }
      if (targets.isEmpty) {
        logLine('> Assassination attempt does not materialize.');
        _eventAssassinState = null;
        return;
      }
      int choice = targets.length == 1 ? 0 : randInt(targets.length);
      final target = targets[choice];
      localState.assassinCommand = assassin;
      if (target is Location) {
        localState.targetCommand = target;
      } else {
        localState.targetStatesman = target;
      }
    }
    assassinationAttempt(localState.assassinCommand!, localState.targetCommand, localState.targetStatesman);
    _eventAssassinState = null;
  }

  void eventBagaudae() {
    logLine('> Increased chance of Revolt in Gallia.');
  }

  void eventBagaudaeDoubled() {
    logLine('> Increased chance of Revolt in Gallia and Hispania.');
  }

  void eventBodyguard() {
		logLine('> Reduced chance of successful Assassination.');
  }

  void eventBodyguardDoubled() {
		logLine('> Greatly reduced chance of successful Assassination.');
  }

  void eventConspiracy() {
		logLine('> Increased chance of successful Assassination.');
  }

  void eventConspiracyDoubled() {
		logLine('> Greatly increased chance of successful Assassination.');
  }

  void eventConvert() {
    annexAnyProvinceInEmpires([Location.commandWesternEmperor]);
  }

  void eventConvertDoubled() {
    if (choicesEmpty()) {
      final wars = <Piece>[];
      for (final war in PieceType.war.pieces) {
        final location = _state.pieceLocation(war);
        if (location.isType(LocationType.province)) {
          final command = _state.provinceCommand(location);
          if (_state.commandEmpire(command) == Location.commandWesternEmperor) {
            wars.add(war);
          }
        }
      }
      if (wars.isEmpty) {
        logLine('> No Wars are available to Convert.');
        return;
      }
      setPrompt('Select War to Convert');
      for (final war in wars) {
        pieceChoosable(war);
      }
      throw PlayerChoiceException();
    }
    final war = selectedPiece()!;
    final province = _state.pieceLocation(war);
    logLine('> Conversion removes ${war.name} from ${province.name}.');
    setWarOffmap(war);
  }

  void eventDiplomat() {
    annexAnyProvinceInEmpires([Location.commandEasternEmperor]);
  }

  void eventDiplomatDoubled() {
    if (choicesEmpty()) {
      final wars = <Piece>[];
      for (final war in PieceType.war.pieces) {
        final location = _state.pieceLocation(war);
        if (location.isType(LocationType.province)) {
          final command = _state.provinceCommand(location);
          if (_state.commandEmpire(command) == Location.commandEasternEmperor) {
            wars.add(war);
          }
        }
      }
      if (wars.isEmpty) {
        logLine('> No Wars are available for Diplomacy.');
        return;
      }
      setPrompt('Select War for Diplomacy');
      for (final war in wars) {
        pieceChoosable(war);
      }
      throw PlayerChoiceException();
    }
    final war = selectedPiece()!;
    final province = _state.pieceLocation(war);
    logLine('> Diplomacy removes ${war.name} from ${province.name}.');
    setWarOffmap(war);
  }

  void eventFoederati() {
    final phaseState = _phaseState as PhaseStateEvent;

    if (_subStep == 0) {
      for (final war in PieceType.war.pieces) {
        final enemy = _state.warEnemy(war);
        if (enemy.isFoederati && _state.warInPlay(war)) {
          final province = _state.pieceLocation(war);
          if (_state.provinceStatus(province) != ProvinceStatus.barbarian) {
            phaseState.remainingFoederatiWars.add(war);
          }
        }
      }
      phaseState.remainingFoederatiWars.shuffle(_random);
      _subStep = 1;
    }

    if (_subStep >= 1 && _subStep <= 2) {
      while (phaseState.remainingFoederatiWars.isNotEmpty) {
        final war = phaseState.remainingFoederatiWars[0];
        if (_subStep == 1) {
          logLine('### Foederati ${war.desc}');
          final enemy = _state.warEnemy(war);
          final province = _state.pieceLocation(war);
          final status = _state.provinceStatus(province);
          if (status == enemy.foederatiStatus) {
            moveWar(war, null, null);
          } else {
            final command = _state.provinceCommand(province);
            final empire = _state.commandEmpire(command);
            int result = provinceRevoltCheck(province);
            if (result > 0) {
              if (status == ProvinceStatus.roman) {
                logLine('> ${province.name} Revolts.');
                provinceDecreaseStatus(province);
                adjustEmpireUnrest(empire, 1);
                adjustEmpirePrestige(empire, -1);
              } else {
                annexProvinceToFoederati(province, enemy);
              }
            } else if (result < 0) {
              if (status == ProvinceStatus.insurgent) {
                logLine('> ${province.name} undergoes Romanization.');
                provinceIncreaseStatus(province);
                adjustEmpirePrestige(empire, 1);
              }
            }
          }
          _subStep = 2;
        }

        if (_subStep == 2) {
          fixOverstacking();
          phaseState.remainingFoederatiWars.remove(war);
          _subStep = 1;
        }
      }
    }
  }

  void eventFoederatiDoubled() {
    eventFoederati();
  }

  void eventHeresy() {
    logLine('> Increased chance of Revolt in Oriens.');
  }

  void eventHeresyDoubled() {
    logLine('> Increased chance of Revolt in Oriens and Africa.');
  }

  void eventHippodrome() {
    adjustEmpireUnrest(Location.commandEasternEmperor, rollD6());
  }

  void eventHippodromeDoubled() {
    switch (_state.provinceStatus(Location.provinceConstantinople)) {
    case ProvinceStatus.barbarian:
    case ProvinceStatus.foederatiFrankish:
    case ProvinceStatus.foederatiOstrogothic:
    case ProvinceStatus.foederatiSuevian:
    case ProvinceStatus.foederatiVandal:
    case ProvinceStatus.foederatiVisigothic:
    case ProvinceStatus.allied:
      logLine('> Hippodrome factions in Constantinople rise up in support of the Empire.');
      setProvinceStatus(Location.provinceConstantinople, ProvinceStatus.insurgent);
    case ProvinceStatus.insurgent:
      logLine('> Hippodrome factions in Constantinople continue rioting.');
    case ProvinceStatus.roman:
      logLine('> Rioting breaks out in Constantinople between rival Hippodrome factions.');
      setProvinceStatus(Location.provinceConstantinople, ProvinceStatus.insurgent);
    }
  }

  void eventInflation() {
    for (final empire in LocationType.empire.locations) {
      adjustEmpireGold(empire, -(_state.empireGold(empire) ~/ 2));
    }
    logLine('> Reduced Taxation yield expected.');
  }

  void eventInflationDoubled() {
    for (final empire in LocationType.empire.locations) {
      adjustEmpireGold(empire, -_state.empireGold(empire));
    }
    logLine('> Greatly reduced Taxation yield expected.');
  }

  void eventMigration() {
    logLine('> Increased number of Wars and Pillage.');
  }

  void eventMigrationDoubled() {
    logLine('> Greatly increased number of Wars and Pillage.');
  }

  void eventMutiny() {
    for (final empire in LocationType.empire.locations) {
      adjustEmpireUnrest(empire, rollD6());
    }
  }

  void eventMutinyDoubled() {
    for (final empire in LocationType.empire.locations) {
      for (final command in LocationType.governorship.locations) {
        if (_state.commandEmpire(command) == empire && _state.commandActive(command) && _state.commandAllegiance(command) == command && _state.commandLoyal(command)) {
          makeRebellionCheckForCommand(command);
        }
      }
    }
  }

  void eventOmens() {
    logLine('> Increased chance of bad outcomes.');
  }

  void eventOmensDoubled() {
    logLine('> Reduced chance of bad outcomes.');
  }

  void eventOrthodoxy() {
    for (final empire in LocationType.empire.locations) {
      final emperorCommand = _state.empireEmperor(empire);
      adjustEmpirePrestige(empire, _state.commandPopularity(emperorCommand));
    }
  }

  void eventOrthodoxyDoubled() {
    for (final empire in LocationType.empire.locations) {
      final emperorCommand = _state.empireEmperor(empire);
      adjustEmpireUnrest(empire, _state.commandPopularity(emperorCommand));
    }
  }

  void eventPapacy() {
    adjustEmpireUnrest(Location.commandWesternEmperor, rollD6());
  }

  void eventPapacyDoubled() {
    switch (_state.provinceStatus(Location.provinceRome)) {
    case ProvinceStatus.barbarian:
    case ProvinceStatus.foederatiFrankish:
    case ProvinceStatus.foederatiOstrogothic:
    case ProvinceStatus.foederatiSuevian:
    case ProvinceStatus.foederatiVandal:
    case ProvinceStatus.foederatiVisigothic:
    case ProvinceStatus.allied:
      logLine('> Christians in Rome rise up in support of the Empire.');
      setProvinceStatus(Location.provinceRome, ProvinceStatus.insurgent);
    case ProvinceStatus.insurgent:
      logLine('> Religious unrest continues in Rome.');
    case ProvinceStatus.roman:
      logLine('> Religious unrest breaks out in Rome.');
      setProvinceStatus(Location.provinceRome, ProvinceStatus.insurgent);
    }
  }

  void eventPersecution() {
    for (final empire in LocationType.empire.locations) {
      final emperorCommand = _state.empireEmperor(empire);
  	  int amount = -((_state.commandIntrigue(emperorCommand) + 1) ~/ 2);
    	adjustEmpirePrestige(empire, amount);
    }
  }

  void eventPersecutionDoubled() {
    logLine('> Increased chance of military disaster.');
  }

  void eventPlague() {
    var command = Location.values[LocationType.governorship.firstIndex];
    while (true) {
      if (!choicesEmpty()) {
        final piece = selectedPiece()!;
        final province = _state.pieceLocation(piece);
        command = _state.provinceCommand(province);
        logLine('> ${_state.commandName(command)}');
        unitDemote(piece);
        clearChoices();
      } else {
        final locationType = _state.commandLocationType(command)!;
        for (final unit in PieceType.mobileUnit.pieces) {
          if (_state.unitDemotable(unit)) {
            final location = _state.pieceLocation(unit);
            if (location.isType(locationType)) {
              pieceChoosable(unit);
            }
          }
        }
        if (choosablePieceCount > 0) {
          setPrompt('Select Veteran Unit in ${_state.commandName(command)} to Demote');
          throw PlayerChoiceException();
        }
        logLine('> ${_state.commandName(command)}');
        final empire = _state.commandEmpire(command);
        adjustEmpireUnrest(empire, 1);
      }
      int commandIndex = command.index;
      commandIndex += 1;
      if (commandIndex == LocationType.command.lastIndex) {
        return;
      }
      command = Location.values[commandIndex];
    }
  }

  void eventPlagueDoubled() {
    logLine('> Increased chance of death.');
  }

  void eventUsurper() {
    for (final empire in LocationType.empire.locations) {
      adjustEmpireUnrest(empire, rollD6());
    }
  }

  void eventUsurperDoubled() {
    if (_state.soleEmperor) {
      logLine('> Sole Emperor forestalls Usurpation attempt.');
      return;
    }
    for (final emperor in LocationType.emperor.locations) {
      if (_state.commandRebel(emperor)) {
        logLine('> Rebel Emperor forestalls Usurpation attempt.');
        return;
      }
    }
    final emperor = randLocation(_state.activeEmperors)!;
    makeRebellionCheckForCommand(emperor);
  }

  void Function() eventTypeHandler(EventType eventType, bool doubled) {
    final eventTypeHandlers = {
      EventType.assassin: [eventAssassin, eventAssassinDoubled],
      EventType.bagaudae: [eventBagaudae, eventBagaudaeDoubled],
      EventType.bodyguard: [eventBodyguard, eventBodyguardDoubled],
      EventType.conspiracy: [eventConspiracy, eventConspiracyDoubled],
      EventType.convert: [eventConvert, eventConvertDoubled],
      EventType.diplomat: [eventDiplomat, eventDiplomatDoubled],
      EventType.foederati: [eventFoederati, eventFoederatiDoubled],
      EventType.heresy: [eventHeresy, eventHeresyDoubled],
      EventType.hippodrome: [eventHippodrome, eventHippodromeDoubled],
      EventType.inflation: [eventInflation, eventInflationDoubled],
      EventType.migration: [eventMigration, eventMigrationDoubled],
      EventType.mutiny: [eventMutiny, eventMutinyDoubled],
      EventType.omens: [eventOmens, eventOmensDoubled],
      EventType.orthodoxy: [eventOrthodoxy, eventOrthodoxyDoubled],
      EventType.papacy: [eventPapacy, eventPapacyDoubled],
      EventType.persecution: [eventPersecution, eventPersecutionDoubled],
      EventType.plague: [eventPlague, eventPlagueDoubled],
      EventType.usurper: [eventUsurper, eventUsurperDoubled],
    };
    int index = doubled ? 1 : 0;
    return eventTypeHandlers[eventType]![index];
  }

  // Sequence Steps

  void turnBegin() {
    logLine('# Turn ${_state.turn - _firstTurn + 1}: ${yearDesc(_state.turn)} - ${yearDesc(_state.turn + 1)}');
  }

  void eventPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Event Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Event Phase');
    _phaseState = PhaseStateEvent();
  }

  void eventPhaseRemoveEventCounters() {
    _state.clearEventTypeCounts();
  }

  void eventPhasePersecution() {
    for (final empire in LocationType.empire.locations) {
      final emperor = _state.commandCommander(empire);
      if (emperor != null && _state.statesmanAbility(emperor) == Ability.persecution) {
        _state.incrementEventTypeCount(EventType.persecution);
        if (_state.eventTypeCount(EventType.persecution) == 1) {
          logLine('### ${_state.statesmanName(emperor)}’s Event: Persecution');
          eventPersecution();
        } else {
          logLine('### ${_state.statesmanName(emperor)}’s Event: Persecution (Doubled)');
          eventPersecutionDoubled();
        }
      }
    }
  }

  void eventPhaseConvert() {
    for (final statesman in PieceType.statesman.pieces) {
      if (_state.statesmanInPlay(statesman) && _state.statesmanAbility(statesman) == Ability.convert) {
        if (_state.eventTypeCount(EventType.convert) == 0) {
          _state.incrementEventTypeCount(EventType.convert);
          logLine('### ${_state.statesmanName(statesman)}’s Event: Convert');
          eventConvert();
        } else if (_state.eventTypeCount(EventType.convert) == 1) {
          _state.incrementEventTypeCount(EventType.convert);
          logLine('### ${_state.statesmanName(statesman)}’s Event: Convert (Doubled)');
          eventConvertDoubled();
        }
      }
    }
  }

  void eventPhaseDiplomat() {
    for (final statesman in PieceType.statesman.pieces) {
      if (_state.statesmanInPlay(statesman) && _state.statesmanAbility(statesman) == Ability.diplomat) {
        if (_state.eventTypeCount(EventType.diplomat) == 0) {
          _state.incrementEventTypeCount(EventType.diplomat);
          logLine('### ${_state.statesmanName(statesman)}’s Event: Diplomat');
          eventDiplomat();
        } else if (_state.eventTypeCount(EventType.diplomat) == 1) {
          _state.incrementEventTypeCount(EventType.diplomat);
          logLine('### ${_state.statesmanName(statesman)}’s Event: Diplomat (Doubled)');
          eventDiplomatDoubled();
        }
      }
    }
  }

  void eventPhaseEventRoll() {
    final phaseState = _phaseState as PhaseStateEvent;
    logLine('### Events Roll');
    int die = rollD6();
		int eventCount = die;
    for (final statesman in PieceType.statesman.pieces) {
			if (_state.statesmanInPlay(statesman) && _state.statesmanAbility(statesman) == Ability.event) {
				logLine('> ${_state.statesmanName(statesman)}: +1');
				eventCount += 1;
			}
		}
		int modifier = _options.eventCountModifier;
		if (modifier != 0) {
			if (modifier == 1) {
				logLine('> More Events option: +1');
			} else if (modifier == -1) {
				logLine('> Less Events options: -1');
			}
			eventCount += modifier;
		}
		if (eventCount == 0) {
			logLine('> No Events');
		}
		else if (eventCount == 1) {
			logLine('> $eventCount Event');
		} else {
			logLine('> $eventCount Events');
		}
		phaseState.eventsRemainingCount = eventCount;
  }

  void eventPhaseRandomEvent() {
    final phaseState = _phaseState as PhaseStateEvent;
    if (phaseState.eventsRemainingCount == 0) {
      return;
    }
    var eventType = phaseState.eventType;
    if (_subStep == 0) {
      logLine('### Random Event');
      eventType = randomEventType();
      _state.incrementEventTypeCount(eventType);
      int eventTypeCount = _state.eventTypeCount(eventType);
      if (eventTypeCount == 1) {
        logLine('> ${_state.eventTypeName(eventType)}');
      } else {
        logLine('> ${_state.eventTypeName(eventType)} (Doubled)');
      }
      phaseState.eventType = eventType;
      _subStep = 1;
    }

    final handler = eventTypeHandler(eventType!, _state.eventTypeCount(eventType) == 2);
    handler();
    phaseState.eventsRemainingCount -= 1;
  }

  void eventPhaseEventsComplete() {
    if (_subStep == 0) {
      _subStep = 1;
      setPrompt('Event Step Complete');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    clearChoices();
  }

  void eventPhaseMortality() {
    final phaseState = _phaseState as PhaseStateEvent;

    if (_subStep == 0) {
      for (final leader in PieceType.leader.pieces) {
        if (_state.leaderInPlay(leader)) {
          if (failMortalityRoll(leader.desc, _state.leaderAge(leader))) {
            if (leader.isType(PieceType.leaderLeader)) {
              _state.setBarbarianOffmap(leader);
            } else {
              _state.setPieceLocation(leader, Location.offmap);
            }
          }
        }
      }

      for (final statesman in PieceType.statesman.pieces) {
        final location = _state.pieceLocation(statesman);
        if (_state.statesmanInPlay(statesman) && !location.isType(LocationType.emperor)) {
          final name = _state.statesmanName(statesman);
          if (failMortalityRoll(name, _state.statesmanAge(statesman))) {
            if (location.isType(LocationType.governorship)) {
              governorDies(location);
            } else {
              _state.setPieceLocation(statesman, Location.offmap);
            }
          }
        }
      }

      for (final governorship in LocationType.governorship.locations) {
        if (_state.commandRebel(governorship) && _state.commandAllegiance(governorship) == governorship) {
          final statesman = _state.commandCommander(governorship);
          if (statesman == null) {
            final name = _state.commanderName(governorship);
            if (failMortalityRoll(name, _state.commanderAge(governorship))) {
              governorDies(governorship);
            }
          }
        }
      }
      _subStep = 1;
    }

    if (_subStep == 1) {
      for (final emperor in LocationType.emperor.locations) {
        if (!_state.empireHasViceroy(emperor) && !_state.empireHasFallen(emperor)) {
          final name = _state.commanderName(emperor);
          if (!_state.dynastyActive(Piece.dynastyConstantinian) && [2,4,6,8].contains(_state.turn)) {
            logLine('> $name Abdicates.');
            phaseState.emperorMortalities.add(emperor);
          } else {
            final statesman = _state.commandCommander(emperor);
            int? age;
            if (statesman != null) {
              age = _state.statesmanAge(statesman);
            } else {
              age = _state.commanderAge(emperor);
            }

            if (failMortalityRoll(name, age)) {
              emperorDies(emperor);
              phaseState.emperorMortalities.add(emperor);
            }
          }
        }
      }
      _subStep = 2;
    }

    if (_subStep == 2) {
      if (phaseState.emperorMortalities.isNotEmpty) {
        newEmperor(phaseState.emperorMortalities[0], phaseState.emperorMortalities.length > 1 ? phaseState.emperorMortalities[1] : null, EmperorDeathCause.mortality, null);
      }
      _subStep = 3;
    }

    if (_subStep == 3) {
      for (final enemy in Enemy.values) {
        redistributeEnemyLeaders(enemy);
      }
      _subStep = 4;
    }

    if (_subStep == 4) {
      for (final leader in PieceType.leader.pieces) {
        if (_state.leaderInPlay(leader)) {
          _state.setLeaderAge(leader, _state.leaderAge(leader)! + 1);
        }
      }
      for (final statesman in PieceType.statesman.pieces) {
        if (_state.statesmanInPlay(statesman)) {
          _state.setStatesmanAge(statesman, _state.statesmanAge(statesman)! + 1);
        }
      }
      for (final command in LocationType.command.locations) {
        final age = _state.commanderAge(command);
        if (age != null) {
          _state.setCommanderAge(command, age + 1);
        }
      }

      setPrompt('Mortality Step Complete');
      choiceChoosable(Choice.next, true);
      _subStep = 5;
      throw PlayerChoiceException();
    }

    if (_subStep == 5) {
      clearChoices();
    }
  }

  void eventPhaseAssassination() {
    final phaseState = _phaseState as PhaseStateEvent;

    while (_subStep >= 0 && _subStep <= 1) {
      if (_subStep == 0) {
        final statesmen = <Piece>[];
        for (final statesman in PieceType.statesman.pieces) {
          if (_state.statesmanInPlay(statesman)) {
            statesmen.add(statesman);
          }
        }
        final assassins = <Piece>[];
        for (final statesman in PieceType.statesman.pieces) {
          if (_state.statesmanAbility(statesman) == Ability.assassin) {
            final location = _state.pieceLocation(statesman);
            if (location.isType(LocationType.command)) {
              if (location.isType(LocationType.governorship) || statesmen.length > 1) {
                if (!phaseState.assassins.contains(statesman)) {
                  assassins.add(statesman);
                }
              }
            }
          }
        }
        if (assassins.isEmpty) {
          if (phaseState.assassins.isEmpty) {
            return;
          }
          _subStep = 2;
        }

        final assassin = randPiece(assassins)!;
        phaseState.assassins.add(assassin);
        final command = _state.pieceLocation(assassin);
        if (command.isType(LocationType.governorship)) {
          phaseState.assassinTargetCommand = _state.commandEmpire(command);
        } else {
          final candidates = <Piece>[];
          for (final statesman in statesmen) {
            if (statesman != assassin) {
              candidates.add(statesman);
            }
          }
          phaseState.assassinTargetStatesman = randPiece(candidates);
        }
        logLine('### Assassination Attempt');
        _subStep = 1;
      }

      if (_subStep == 1) {
        final assassinCommand = _state.pieceLocation(phaseState.assassins[phaseState.assassins.length - 1]);
        assassinationAttempt(assassinCommand, phaseState.assassinTargetCommand, phaseState.assassinTargetStatesman);
        phaseState.assassinTargetCommand = null;
        phaseState.assassinTargetStatesman = null;
        _subStep = 0;
      }
    }

    if (_subStep == 2) {
      setPrompt('Assassination Step Complete');
      choiceChoosable(Choice.next, true);
      _subStep = 3;
      throw PlayerChoiceException();
    }

    if (_subStep == 3) {
      clearChoices();
    }
  }

  void eventPhaseCheckDefeat() {
    _phaseState = null;
    checkDefeat();
  }

  void treasuryPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Treasury Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Treasury Phase');
    _phaseState = PhaseStateTreasury();
  }

  void treasuryPhaseTaxWestern() {
    logLine('### Western Empire Tax');
    taxEmpire(Location.commandWesternEmperor);
  }

  void treasuryPhaseTaxEastern() {
    logLine('### Eastern Empire Tax');
    taxEmpire(Location.commandEasternEmperor);
  }

  void treasuryPhaseTaxComplete() {
    if (choicesEmpty()) {
      setPrompt('Tax Step Complete');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    clearChoices();
  }

  void treasuryPhasePayWestern() {
    logLine('### Western Empire Pay');
    payEmpire(Location.commandWesternEmperor);
  }

  void treasuryPhasePayEastern() {
    logLine('### Eastern Empire Pay');
    payEmpire(Location.commandEasternEmperor);
  }

  void treasuryPhasePayComplete() {
    if (choicesEmpty()) {
      setPrompt('Pay Step Complete');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    clearChoices();
  }

  void treasuryPhaseExtraTaxes() {
    final phaseState = _phaseState as PhaseStateTreasury;

    while (true) {
      if (_subStep == 0) {
        bool canTransferEastToWest = false;
        bool canTransferWestToEast = false;
        if (_state.commandLoyal(Location.commandWesternEmperor) && _state.commandLoyal(Location.commandEasternEmperor)) {
          canTransferEastToWest = _state.empireGold(Location.commandEasternEmperor) > 0;
          canTransferWestToEast = _state.empireGold(Location.commandWesternEmperor) > 0;
        }
        bool canLevyExtraTaxesWest = _state.empireGold(Location.commandWesternEmperor) < 0;
        bool canLevyExtraTaxesEast = _state.empireGold(Location.commandEasternEmperor) < 0;
        if (!canTransferEastToWest && !canTransferWestToEast && !canLevyExtraTaxesWest && !canLevyExtraTaxesEast) {
          return;
        }
        if (choicesEmpty()) {
          setPrompt('Exchange Gold or levy Extra Taxes');
          choiceChoosable(Choice.transferGoldEastToWest, canTransferEastToWest);
          choiceChoosable(Choice.transferGoldWestToEast, canTransferWestToEast);      
          choiceChoosable(Choice.extraTaxesWest, canLevyExtraTaxesWest);
          choiceChoosable(Choice.extraTaxesEast, canLevyExtraTaxesEast);
          choiceChoosable(Choice.next, true);
          throw PlayerChoiceException();
        }
        if (checkChoice(Choice.next)) {
          clearChoices();
          return;
        }
        if (checkChoiceAndClear(Choice.transferGoldEastToWest)) {
          phaseState.taxEmpire = Location.commandWesternEmperor;
          _subStep = 1;
        } else if (checkChoiceAndClear(Choice.transferGoldWestToEast)) {
          phaseState.taxEmpire = Location.commandEasternEmperor;
          _subStep = 1;
        } else if (checkChoiceAndClear(Choice.extraTaxesWest)) {
          phaseState.taxEmpire = Location.commandWesternEmperor;
          _subStep = 2;
        } else if (checkChoiceAndClear(Choice.extraTaxesEast)) {
          phaseState.taxEmpire = Location.commandEasternEmperor;
          _subStep = 2;
        }
      }

      if (_subStep == 1) { // Exchange Gold
        final empire = phaseState.taxEmpire!;
        final otherEmpire = _state.otherEmpire(empire);
        final locationType = otherEmpire == Location.commandWesternEmperor ? LocationType.trackWest : LocationType.trackEast;
        if (choicesEmpty()) {
          setPrompt('Select amount of Gold to transfer');
          for (int i = 1; i < _state.empireGold(otherEmpire) && i <= 25; ++i) {
            locationChoosable(Location.values[locationType.firstIndex + i]);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          phaseState.taxEmpire = null;
          _subStep = 0;
          continue;
        }
        phaseState.taxEmpire = null;
        logLine('### Transfer Gold to ${_state.empireDesc(empire)} Empire.');
        final location = selectedLocation()!;
        clearChoices();
        int amount = location.index - locationType.firstIndex;
        adjustEmpireGold(otherEmpire, -amount);
        adjustEmpireGold(empire, amount);
        _subStep = 0;
      }

      if (_subStep == 2) { // Extra Taxes
        final empire = phaseState.taxEmpire!;
        phaseState.taxEmpire = null;
        logLine('### Extra Taxes in ${_state.empireDesc(empire)} Empire');
        adjustEmpireUnrest(empire, 1);
        adjustEmpirePrestige(empire, -1);
        final rolls = roll2D6();
        int total = rolls.$4;
        adjustEmpireGold(empire, total);
        _subStep = 0;
      }
    }
	}

  void treasuryPhaseMoveWarsInit() {
    final phaseState = _phaseState as PhaseStateTreasury;
    for (final war in PieceType.war.pieces) {
      phaseState.setWarUnmoved(war, _state.warInPlay(war));
    }
  }

  void treasuryPhaseMoveCurrentWars() {
    final phaseState = _phaseState as PhaseStateTreasury;
    while (phaseState.unmovedWarCount > 0) {
      if (choicesEmpty()) {
        setPrompt('Select War to Move');
        for (final war in PieceType.war.pieces) {
          if (phaseState.warUnmoved(war)) {
            pieceChoosable(war);
          }
        }
        throw PlayerChoiceException();
      }
      final war = selectedPiece()!;
      logLine('### ${war.desc}');
      moveWar(war, null, null);
      clearChoices();
    }
  }

  void treasuryPhaseNewWarCount() {
    final phaseState = _phaseState as PhaseStateTreasury;
    int poolCount = _state.piecesInLocationCount(PieceType.barbarian, Location.poolWars);

    if (_state.turn % 10 == 9) {
      phaseState.warsRemainingCount = poolCount;
    } else {
      logLine('### Draw New Wars');
      int roll = rollD3();
      int modifiers = 0;
      int timePeriod = _state.turn ~/ 10;
      if (timePeriod == 1 || timePeriod == 2 || timePeriod == 4) {
        String scenarioDesc = timePeriod == 1 ? '363 CE' : (timePeriod == 2 ? '425 CE' : '565 CE');
        logLine('> $scenarioDesc Scenario: +1');
        modifiers += 1;
      }
      int modifier = _state.eventTypeCount(EventType.migration);
      if (modifier != 0) {
        if (modifier == 1) {
          logLine('> Migration Event: +1');
        } else {
          logLine('> Migration Event (doubled): +2');
        }
        modifiers += modifier;
      }
      int result = roll + modifiers;
      logLine('> Result: $result');
      if (result > poolCount) {
        result = poolCount;
      }
      phaseState.warsRemainingCount = result;
    }
  }

  void treasuryPhaseDrawAndMoveNewWars() {
    final phaseState = _phaseState as PhaseStateTreasury;
    while (phaseState.warsRemainingCount > 0) {

      if (_subStep == 0) { // Draw
        final piece = randPiece(_state.piecesInLocation(PieceType.barbarian, Location.poolWars))!;
        if (piece.isType(PieceType.leaderLeader)) {
          logLine('### ${piece.desc}');
          _state.setLeaderAge(piece, 0);
          final enemy = _state.leaderEnemy(piece);
          final wars = _state.enemyWarsWithoutLeaders(enemy);
          if (wars.isEmpty) {
            final homeland = randLocation(enemy.homelands)!;
            logLine('> ${piece.desc} appears in ${homeland.desc}.');
            _state.setPieceLocation(piece, homeland);
          } else {
            final war = randPiece(wars)!;
            final space = _state.pieceLocation(war);
            logLine('> ${piece.desc} appears in ${space.desc} with ${war.desc}.');
            _state.setPieceLocation(piece, space);
          }
          phaseState.warsRemainingCount -= 1;
        } else {
          logLine('### ${piece.desc}');
          final homeland = randLocation(_state.warHomelands(piece))!;
          logLine('> ${piece.desc} arises in ${homeland.desc}.');
          final otherWar = _state.pieceInLocation(PieceType.war, homeland);
          _state.setPieceLocation(piece, homeland);
          phaseState.setWarUnmoved(piece, true);
          if (otherWar != null) {
            moveWar(otherWar, homeland, piece);
          }
          _subStep = 1;
        }
      }

      if (_subStep == 1) { // Zeno
        final war = phaseState.drawnWar;
        _subStep = 3;
        if (war == Piece.warIsaurian7 && _state.statesmanInPlay(Piece.statesmanZeno)) {
          final zenoLocation = _state.pieceLocation(Piece.statesmanZeno);
          if (zenoLocation.isType(LocationType.emperor)) {
            phaseState.zenoEmpire = zenoLocation;
            logLine('> ${_state.commanderName(zenoLocation)} abandons the Empire to lead ${war.desc}.');
            _state.setPieceLocation(Piece.statesmanZeno, Location.provinceIsauria);
            _subStep = 2;
          }
        }
      }

      if (_subStep == 2) { // Emperor Zeno
        newEmperor(phaseState.zenoEmpire!, null, EmperorDeathCause.leader, null);
        phaseState.zenoEmpire = null;
        _subStep = 4;
      }

      if (_subStep == 3) { // Redistribute Leaders
        final war = phaseState.drawnWar;
        final enemy = _state.warEnemy(war);
        redistributeEnemyLeaders(enemy);
        _subStep = 4;
      }

      if (_subStep == 4) { // Move War
        final war = phaseState.drawnWar;
        if (choicesEmpty()) {
          setPrompt('Select War to Move');
          pieceChoosable(war);
          throw PlayerChoiceException();
        }
        moveWar(war, null, null);
        clearChoices();
        phaseState.warsRemainingCount -= 1;
        _subStep = 0;
      }
    }
  }

  void treasuryPhaseCheckDefeat() {
    _phaseState = null;
    checkDefeat();
  }
  
  void unrestPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Unrest Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## Unrest Phase');
    _phaseState = PhaseStateUnrest();
  }

  void unrestPhaseIncreaseEmpireUnrest(Location empire) {
    logLine('### ${_state.empireDesc(empire)} Empire Unrest');
    int amount = 0;

    final rebelCommands = <Location>[];
    for (final command in LocationType.governorship.locations) {
      if (_state.commandEmpire(command) == empire) {
        if (_state.commandRebel(command) && _state.commandAllegiance(command) == command) {
          rebelCommands.add(command);
        }
      }
    }
    if (rebelCommands.isNotEmpty) {
      logLine('> Rebels');
      for (final rebelCommand in rebelCommands) {
        logLine('> - ${_state.commanderName(rebelCommand)}');
      }
      logLine('');
      amount += rebelCommands.length;
    }

    final wars = <Piece>[];
    for (final war in PieceType.war.pieces) {
      if (_state.warInPlay(war)) {
        final province = _state.pieceLocation(war);
        final command = _state.provinceCommand(province);
        if (_state.commandEmpire(command) == empire) {
          wars.add(war);
        }
      }
    }
    if (wars.isNotEmpty) {
      logLine('> Wars:');
      for (final war in wars) {
        final location = _state.pieceLocation(war);
        logLine('> - ${war.desc} in ${location.desc}');
      }
      logLine('');
      amount += wars.length;
    }

    final leaders = <Piece>[];
    for (final leader in PieceType.leader.pieces) {
      final location = _state.pieceLocation(leader);
      if (location.isType(LocationType.homeland)) {
        for (final connectedLocation in _state.spaceConnectedSpaces(location)) {
          if (connectedLocation.isType(LocationType.province)) {
            final command = _state.provinceCommand(connectedLocation);
            if (_state.commandEmpire(command) == empire) {
              leaders.add(leader);
              break;
            }
          }
        }
      }
    }
    if (leaders.isNotEmpty) {
      logLine('> Leaders:');
      for (final leader in leaders) {
        logLine('> - ${leader.desc}');
      }
      logLine('');
      amount += leaders.length;
    }

    final legions = <(Location,int)>[];
    final fleets = <(Location,int)>[];
    final grains = <Location>[];
    for (final governorship in LocationType.governorship.locations) {
      if (_state.commandEmpire(governorship) == empire) {
        final locationType = _state.commandLocationType(governorship)!;
        for (final province in locationType.locations) {
          int shortfall = 0;
          if (_state.spaceInsurgentOrBetter(province)) {
            shortfall = _state.provinceLegionaryIcons(province) - _state.provinceLegionaryIconPieceCount(province);
            if (shortfall > 0) {
              legions.add((province, shortfall));
            }
            shortfall = _state.provinceFleetIcons(province) - _state.piecesInLocationCount(PieceType.fleet, province);
            if (shortfall > 0) {
              fleets.add((province, shortfall));
            }
          }
          if (!_state.empireHasFallen(empire)) {
            if (_state.provinceHasGrainIcon(province)) {
              final status = _state.provinceStatus(province);
              if (status == ProvinceStatus.barbarian || status == ProvinceStatus.insurgent || _state.commandRebelVsEmperor(_state.provinceCommand(province))) {
                grains.add(province);
              }
            }
          }
        }
      }
    }

    if (legions.isNotEmpty) {
      if (_state.dynastyActive(Piece.dynastyValentinian)) {
        logLine('> Troops Needed:');
      } else {
        logLine('> Legions Needed:');
      }
      for (final legion in legions) {
         logLine('> - ${legion.$1.desc}');
        amount += legion.$2;
      }
      logLine('');
    }

    if (fleets.isNotEmpty) {
      logLine('> Fleets Needed:');
      for (final fleet in fleets) {
         logLine('> - ${fleet.$1.desc}');
        amount += fleet.$2;
      }
      logLine('');
    }

    if (grains.isNotEmpty) {
      logLine('> Grain Supply Interrupted:');
      for (final grain in grains) {
         logLine('> - ${grain.desc}');
        amount += 1;
      }
      logLine('');
    }

    adjustEmpireUnrest(empire, amount);
  }
  
  void unrestPhaseIncreaseEasternUnrest() {
    unrestPhaseIncreaseEmpireUnrest(Location.commandEasternEmperor);
  }

  void unrestPhaseIncreaseWesternUnrest() {
    unrestPhaseIncreaseEmpireUnrest(Location.commandWesternEmperor);
  }

  void unrestPhaseDrawStatesmen() {
    if (_subStep == 0) {
      drawStatesmen();
      setPrompt('Draw Statesmen Step Complete');
      choiceChoosable(Choice.next, true);
      _subStep = 1;
      throw PlayerChoiceException();
    }
    clearChoices();
  }

  void unrestPhaseAnnex() {
    final phaseState = _phaseState as PhaseStateUnrest;
    if (_subStep == 0) {
      bool logged = false;
      if (_state.dynastyActive(Piece.dynastyJustinian)) {
        if (!logged) {
          logLine('### Annexation');
        }
        logLine('> Justinian Dynasty: Western Empire');
        logLine('> Justinian Dynasty: Eastern Empire');
        phaseState.empireAnnexRemainingCounts[0] += 1;
        phaseState.empireAnnexRemainingCounts[1] += 1;
      }
      for (final emperor in LocationType.emperor.locations) {
        final statesman = _state.pieceInLocation(PieceType.statesman, emperor);
        if (statesman != null && _state.statesmanAbility(statesman) == Ability.conquest) {
          if (!logged) {
            logLine('### Annexation');
          }
          if (_state.soleEmperor) {
            logLine('> ${_state.statesmanName(statesman)}: Western Empire');
            logLine('> ${_state.statesmanName(statesman)}: Eastern Empire');
            phaseState.empireAnnexRemainingCounts[0] += 1;
            phaseState.empireAnnexRemainingCounts[1] += 1;
          } else {
            logLine('> ${_state.statesmanName(statesman)}: ${_state.empireDesc(emperor)} Empire');
            phaseState.empireAnnexRemainingCounts[emperor.index - LocationType.emperor.firstIndex] += 1;
          }
        }
      }
      if (phaseState.empireAnnexRemainingCounts[0] + phaseState.empireAnnexRemainingCounts[1] == 0) {
        return;
      }
      _subStep = 1;
    }
    while (phaseState.empireAnnexRemainingCounts[0] + phaseState.empireAnnexRemainingCounts[1] > 0) {
      final empires = <Location>[];
      for (int index = 0; index < 2; ++index) {
        if (phaseState.empireAnnexRemainingCounts[index] > 0) {
          empires.add(Location.values[LocationType.emperor.firstIndex + index]);
        }
      }
      final province = annexAnyProvinceInEmpires(empires);
      if (province == null) {
        return;
      }
      final command = _state.provinceCommand(province);
      final empire = _state.commandEmpire(command);
      phaseState.empireAnnexRemainingCounts[empire.index - LocationType.empire.firstIndex] -= 1;
    }
  }

  void unrestPhaseAppointCommanders() {
    final phaseState = _phaseState as PhaseStateUnrest;

    while (true) {
      if (_subStep == 0) {
        if (choicesEmpty()) {
          setPrompt('Select Statesman to Appoint, Command to transfer, or Continue');
          for (final statesman in PieceType.statesman.pieces) {
            if (_state.statesmanValidAppointee(statesman)) {
              pieceChoosable(statesman);
            }
          }
          for (final governorship in LocationType.governorship.locations) {
            if (_state.commandLoyal(governorship)) {
              if (_state.loyalGovernorshipAllegianceCandidates(governorship).length > 1) {
                locationChoosable(governorship);
              }
            }
          }
          choiceChoosable(Choice.next, _state.commandAppointmentsAcceptable());
          throw PlayerChoiceException();
        }
        if (checkChoice(Choice.next)) {
          clearChoices();
          return;
        }
        if (selectedPiece() != null) {
          _subStep = 1;
        } else {
          _subStep = 2;
        }
      }

      if (_subStep == 1) { // Appoint Statesman
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          _subStep = 0;
          continue;
        }
        final appointStatesman = selectedPiece()!;
        final appointCommand = selectedLocation();
        if (appointCommand == null) {
          setPrompt('Select Command to Appoint ${_state.statesmanName(appointStatesman)} to');
          for (final command in LocationType.command.locations) {
            if (_state.commandValidAppointment(command)) {
              locationChoosable(command);
            }
          }
          choiceChoosable(Choice.cancel, true);
          choiceChoosable(Choice.next, false);
          throw PlayerChoiceException();
        }
        final oldLocation = _state.pieceLocation(appointStatesman);
        if (oldLocation.isType(LocationType.governorship)) {
          governorshipBecomesLoyalToEmperor(oldLocation);
        }
        appointStatesmanToCommand(appointStatesman, appointCommand);
        clearChoices();
        _subStep = 0;
      }

      if (_subStep == 2) { // Transfer Governorship
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          phaseState.transferGovernorship = null;
          _subStep = 0;
          continue;
        }
        if (phaseState.transferGovernorship == null) {
          final governorship = selectedLocation()!;
          phaseState.transferGovernorship = governorship;
          setPrompt('Select Command to transfer ${_state.commandName(governorship)} to');
          for (final command in _state.loyalGovernorshipAllegianceCandidates(governorship)) {
            if (command != _state.commandAllegiance(governorship)) {
              locationChoosable(command);
            }
          }
          choiceChoosable(Choice.next, false);
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        final governorship = phaseState.transferGovernorship!;
        phaseState.transferGovernorship = null;
        Location? toCommand;
        for (final command in selectedLocations()) {
          if (command != governorship) {
            toCommand = command;
          }
        }
        Location fromCommand = _state.commandAllegiance(governorship);
        _state.fixGovernorship(fromCommand);
        if (governorship == toCommand) {
          logLine('> Remove ${_state.commandName(governorship)} from ${_state.commanderName(fromCommand)}.');
        } else {
          logLine('> Transfer ${_state.commandName(governorship)} to ${_state.commanderName(toCommand!)}.');
        }
        _state.setCommandAllegiance(governorship, toCommand!);
        clearChoices();
        _subStep = 0;
      }
    }
  }

  void unrestPhaseAdjustEmpirePrestigeAndUnrest(Location empire) {
    logLine('### ${_state.empireDesc(empire)} Prestige and Unrest');
    int amount = 0;
    int total = 0;
    final emperor = _state.empireEmperor(empire);
    amount = _state.commandAdministration(emperor);
    logLine('> ${_state.commanderName(emperor)} Administration: +$amount');
    total += amount;
    for (final command in LocationType.command.locations) {
      if (_state.commandEmpire(command) == empire || _state.empireEmperor(empire) == command) {
        final statesman = _state.commandCommander(command);
        if (statesman != null && _state.statesmanAbility(statesman) == Ability.prestige) {
          if (command.isType(LocationType.emperor) || _state.commandLoyal(command)) {
            logLine('> ${_state.statesmanName(statesman)} Prestige: +1');
            total += 1;
          }
        }
      }
    }
    adjustEmpirePrestige(empire, total);

    total = 0;
    amount = -_state.commandPopularity(emperor);
    logLine('> ${_state.commanderName(emperor)} Popularity: $amount');
    total += amount;
    adjustEmpireUnrest(empire, total);
  }

  void unrestPhaseAdjustWesternPrestigeAndUnrest() {
    unrestPhaseAdjustEmpirePrestigeAndUnrest(Location.commandWesternEmperor);
  }

  void unrestPhaseAdjustEasternPrestigeAndUnrest() {
    unrestPhaseAdjustEmpirePrestigeAndUnrest(Location.commandEasternEmperor);
  }

  void unrestPhaseBreadAndCircuses() {
    final phaseState = _phaseState as PhaseStateUnrest;
    while (true) {
      if (_subStep == 0) {
        if (choicesEmpty()) {
          final empirePrestigeAvailable = [false, false];
          final empireUnrestAvailable = [false, false];
          final empireTransferAvailable = [false, false];
          for (final empire in LocationType.empire.locations) {
            int index = empire.index - LocationType.empire.firstIndex;
            if (_state.empireGold(empire) >= 10) {
              empirePrestigeAvailable[index] = phaseState.breadAndCircusesPrestigeCounts[index] < _state.commandAdministration(empire);
              empireUnrestAvailable[index] = _state.empireUnrest(empire) > 0;
            }
            if (_state.commandLoyal(Location.commandWesternEmperor) && _state.commandLoyal(Location.commandEasternEmperor)) {
              empireTransferAvailable[index] = _state.empireGold(empire) > 0;
            }
          }
          setPrompt('Appease the populace with Bread and Circuses, or Continue');
          choiceChoosable(Choice.breadAndCircusesPrestigeWest, empirePrestigeAvailable[0]);
          choiceChoosable(Choice.breadAndCircusesPrestigeEast, empirePrestigeAvailable[1]);
          choiceChoosable(Choice.breadAndCircusesUnrestWest, empireUnrestAvailable[0]);
          choiceChoosable(Choice.breadAndCircusesUnrestEast, empireUnrestAvailable[1]);
          choiceChoosable(Choice.transferGoldEastToWest, empireTransferAvailable[1]);
          choiceChoosable(Choice.transferGoldWestToEast, empireTransferAvailable[0]);
          choiceChoosable(Choice.next, true);
          throw PlayerChoiceException();
        }
        if (checkChoice(Choice.next)) {
          clearChoices();
          return;
        }
        if (checkChoice(Choice.breadAndCircusesPrestigeWest) || checkChoice(Choice.breadAndCircusesPrestigeEast)) {
          final empire = checkChoice(Choice.breadAndCircusesPrestigeWest) ? Location.commandWesternEmperor : Location.commandEasternEmperor;
          logLine('> Bread and Circuses Increase Prestige in ${_state.empireDesc(empire)} Empire.');
          adjustEmpireGold(empire, -10);
          adjustEmpirePrestige(empire, 1);
          phaseState.breadAndCircusesPrestigeCounts[empire.index - LocationType.empire.firstIndex] += 1;
          clearChoices();
        } else if (checkChoice(Choice.breadAndCircusesUnrestWest) || checkChoice(Choice.breadAndCircusesUnrestEast)) {
          final empire = checkChoice(Choice.breadAndCircusesUnrestWest) ? Location.commandWesternEmperor : Location.commandEasternEmperor;
          logLine('> Bread and Circuses Reduce Unrest in ${_state.empireDesc(empire)} Empire.');
          adjustEmpireGold(empire, -10);
          adjustEmpireUnrest(empire, -1);
          clearChoices();
        } else if (checkChoice(Choice.transferGoldEastToWest) || checkChoice(Choice.transferGoldWestToEast)) {
          phaseState.transferEmpire = checkChoice(Choice.transferGoldEastToWest) ? Location.commandWesternEmperor : Location.commandEasternEmperor;
          clearChoices();
          _subStep = 1;
        }
      }

      if (_subStep == 1) { // Exchange Gold
        final empire = phaseState.transferEmpire!;
        final otherEmpire = _state.otherEmpire(empire);
        final locationType = otherEmpire == Location.commandWesternEmperor ? LocationType.trackWest : LocationType.trackEast;
        if (choicesEmpty()) {
          setPrompt('Select amount of Gold to transfer');
          for (int i = 1; i < _state.empireGold(otherEmpire) && i <= 25; ++i) {
            locationChoosable(Location.values[locationType.firstIndex + i]);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.cancel)) {
          phaseState.transferEmpire = null;
          _subStep = 0;
          continue;
        }
        phaseState.transferEmpire = null;
        logLine('### Transfer Gold to ${_state.empireDesc(empire)} Empire.');
        final location = selectedLocation()!;
        clearChoices();
        int amount = location.index - locationType.firstIndex;
        adjustEmpireGold(otherEmpire, -amount);
        adjustEmpireGold(empire, amount);
        _subStep = 0;
      }
    }
  }

  void unrestPhaseBuildAndTransferUnits() {
    if (_subStep == 0) {
      logLine('### Build and Transfer Units');
      _subStep = 1;
    }
    while (true) {
      if (choicesEmpty()) {
        setPrompt('Select Unit to Build or Transfer, or Continue');
        for (final unit in PieceType.unit.pieces) {
          if (_state.unitCanBuild(unit) || (_state.unitInPlay(unit) && (_state.unitCanPromote(unit) || _state.unitCanTransfer(unit)))) {
            pieceChoosable(unit);
          }
        }
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.next)) {
        clearChoices();
        return;
      }
      if (checkChoice(Choice.cancel)) {
        clearChoices();
      } else {
        final unit = selectedPiece()!;
        final province = selectedLocation();
        if (province == null) {
          if (_state.unitCanBuild(unit)) {
            setPrompt('Select Province to Build ${unit.desc} in');
            for (final province in LocationType.province.locations) {
              if (_state.unitCanBuildInProvince(unit, province)) {
                locationChoosable(province);
              }
            }
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          } else {
            bool canPromoteToPseudoLegion = false;
            bool canPromoteToVeteranAuxilia = false;
            for (final province in LocationType.province.locations) {
              if (_state.unitCanTransferToProvince(unit, province, false, true, true)) {
                locationChoosable(province);
              }
            }
            if (_state.unitCanPromote(unit)) {
              if (unit.isType(PieceType.fort)) {
                canPromoteToPseudoLegion = true;
              } else {
                canPromoteToVeteranAuxilia = true;
              }
            }
            if (canPromoteToPseudoLegion) {
              setPrompt('Select Province to Transfer ${unit.desc} to, or its current Province to Promote to Pseudo Legion');
            } else if (canPromoteToVeteranAuxilia) {
              setPrompt('Select Province to Transfer ${unit.desc} to, or its current Province to Promote to Veteran Auxilia');
            } else {
              setPrompt('Select Province to Transfer ${unit.desc} to');
            }
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
        }
        final command = _state.provinceCommand(province);
        final empire = _state.commandEmpire(command);
        if (_state.unitCanBuild(unit)) {
          logLine('> Build ${unit.desc} in ${province.desc}.');
          _state.setPieceLocation(unit, province);
          int amount = -_state.unitBuildCost(unit);
          adjustEmpireGold(empire, amount);
        } else {
          final oldProvince = _state.pieceLocation(unit);
          if (province == oldProvince) {
            final newUnit = _state.unitFlipUnit(unit);
            logLine('> Promote ${unit.desc} in ${oldProvince.desc} to ${newUnit.desc}');
            int amount = -_state.unitPromoteCost(unit);
            adjustEmpireGold(empire, amount);
            _state.flipUnit(unit);
          } else {
            logLine('> Transfer ${unit.desc} from ${oldProvince.desc} to ${province.desc}.');
            int amount = -_state.unitTransferCostToProvince(unit, province);
            if (amount != 0) {
              adjustEmpireGold(empire, amount);
            }
            _state.setPieceLocation(unit, province);
          }
        }
        clearChoices();
      }
    }
  }

  void unrestPhaseCheckDefeat() {
    _phaseState = null;
    checkDefeat();
  }
  
  void warPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to War Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException.withSnapshot();
    }
    logLine('## War Phase');
    _phaseState = PhaseStateWar();
  }

  void warPhaseCheckRevolts() {
    final phaseState = _phaseState as PhaseStateWar;

    if (_subStep == 0) {
      final revoltProvinces = <Location>[];
      final romanizationProvinces = <Location>[];

      for (final empire in LocationType.empire.locations) {
        for (final province in LocationType.province.locations) {
          final command = _state.provinceCommand(province);
          if (_state.commandEmpire(command) == empire) {
            if (_state.provinceStatus(province) != ProvinceStatus.barbarian) {
              int result = provinceRevoltCheck(province);
              if (result > 0) {
                revoltProvinces.add(province);
              } else if (result < 0) {
                if (_state.provinceStatus(province) == ProvinceStatus.insurgent) {
                  romanizationProvinces.add(province);
                }
              }
            }
          }
        }
      }
      if (romanizationProvinces.isNotEmpty) {
        logLine('### Romanization');
        for (final empire in LocationType.empire.locations) {
          int prestigeAmount = 0;
          for (final province in romanizationProvinces) {
            final command = _state.provinceCommand(province);
            if (_state.commandEmpire(command) == empire) {
              provinceIncreaseStatus(province);
              prestigeAmount += 1;
            }
          }
          if (prestigeAmount != 0) {
            adjustEmpirePrestige(empire, prestigeAmount);
          }
        }
      }
      if (revoltProvinces.isNotEmpty) {
        logLine('### Revolts');
        phaseState.revoltProvinces = revoltProvinces;
        _subStep = 1;
      } else {
        _subStep = 4;
      }
    }

    if (_subStep == 1) {
      for (int i = phaseState.revoltProvinceStatuses.length; i < phaseState.revoltProvinces.length; ++i) {
        final province = phaseState.revoltProvinces[i];
        final statusCandidates = provinceRevoltStatusCandidates(province);
        if (statusCandidates.length == 1) {
          phaseState.revoltProvinceStatuses.add(statusCandidates[0]);
          continue;
        }
        if (choicesEmpty()) {
          setPrompt('Select Status for ${province.desc}');
          for (final candidate in statusCandidates) {
            switch (candidate) {
            case ProvinceStatus.foederatiFrankish:
              choiceChoosable(Choice.frankish, true);
            case ProvinceStatus.foederatiOstrogothic:
              choiceChoosable(Choice.ostrogothic, true);
            case ProvinceStatus.foederatiSuevian:
              choiceChoosable(Choice.suevian, true);
            case ProvinceStatus.foederatiVandal:
              choiceChoosable(Choice.vandal, true);
            case ProvinceStatus.foederatiVisigothic:
              choiceChoosable(Choice.visigothic, true);
            case ProvinceStatus.barbarian:
            case ProvinceStatus.allied:
            case ProvinceStatus.insurgent:
            case ProvinceStatus.roman:
            }
          }
          throw PlayerChoiceException();
        }
        ProvinceStatus? status;
        if (checkChoice(Choice.frankish)) {
          status = ProvinceStatus.foederatiFrankish;
        } else if (checkChoice(Choice.ostrogothic)) {
          status = ProvinceStatus.foederatiOstrogothic;
        } else if (checkChoice(Choice.suevian)) {
          status = ProvinceStatus.foederatiSuevian;
        } else if (checkChoice(Choice.vandal)) {
          status = ProvinceStatus.foederatiVandal;
        } else if (checkChoice(Choice.visigothic)) {
          status = ProvinceStatus.foederatiVisigothic;
        }
        clearChoices();
        phaseState.revoltProvinceStatuses.add(status!);
      }
      _subStep = 2;
    }

    if (_subStep == 2) {
      for (final empire in LocationType.empire.locations) {
        int prestigeAmount = 0;
        int unrestAmount = 0;
        for (int i = 0; i < phaseState.revoltProvinces.length; ++i) {
          final province = phaseState.revoltProvinces[i];
          final command = _state.provinceCommand(province);
          if (_state.commandEmpire(command) == empire) {
            if (_state.provinceStatus(province) == ProvinceStatus.roman) {
              unrestAmount += 1;
            }
            setProvinceStatus(province, phaseState.revoltProvinceStatuses[i]);
            prestigeAmount += 1;
          }
        }
        if (prestigeAmount != 0) {
          adjustEmpirePrestige(empire, -prestigeAmount);
        }
        if (unrestAmount != 0) {
          adjustEmpireUnrest(empire, unrestAmount);
        }
      }
		  _subStep = 3;
  	}

    if (_subStep == 3) {
      if (_state.overstackedProvinces().isNotEmpty) {
        logLine('### Transfer Units from Non-Roman Provinces');
        _subStep = 4;
      } else {
        _subStep = 5;
      }
    }

    if (_subStep == 4) {
      if (_state.overstackedProvinces().isNotEmpty) {
        fixOverstacking();
      }
      _subStep = 5;
    }

    if (_subStep == 5) {
      setPrompt('Revolt Step Complete');
      choiceChoosable(Choice.next, true);
      _subStep = 6;
      throw PlayerChoiceException();
    }
    clearChoices();
  }

  void warPhaseFightWars() {
    final phaseState = _phaseState as PhaseStateWar;
    while (_subStep >= 0 && _subStep <= 2) {
      while (_subStep >= 1 || unfoughtWars().isNotEmpty) {
        if (_subStep == 0) {
          if (choicesEmpty()) {
            setPrompt('Select War to Fight, or Continue');
            for (final war in unfoughtWars()) {
              pieceChoosable(war);
            }
            if (choosablePieceCount > 0) {
              choiceChoosable(Choice.fightWarsForego, true);
            } else {
              choiceChoosable(Choice.next, true);
            }
            throw PlayerChoiceException();
          }
          if (checkChoice(Choice.cancel)) {
            clearChoices();
            phaseState.cancelWar();
            continue;
          }
          if (checkChoice(Choice.fightWarsForego) || checkChoice(Choice.next)) {
            clearChoices();
            break;
          }
          if (phaseState.war == null) {
            phaseState.war = selectedPieceAndClear();
            phaseState.province = _state.pieceLocation(phaseState.war!);
          }
          final province = phaseState.province!;
          if (phaseState.command == null && selectedLocation() != null) {
            final command = selectedLocationAndClear()!;
            phaseState.empire = _state.commandEmpire(command);
            if (command.isType(LocationType.empire) && _state.soleEmperor) {
              phaseState.command = _state.empireEmperor(command);
            } else {
              phaseState.command = command;
            }
          }
          if (phaseState.command == null) {
            setPrompt('Select Command to Fight War with');
            final commands = <Location>[];
            for (final space in _state.spaceConnectedSpaces(province)) {
              if (space.isType(LocationType.province)) {
                var command = _state.provinceCommand(space);
                command = _state.commandAllegiance(command);
                if (!commands.contains(command) && !phaseState.commandsFought.contains(command)) {
                  commands.add(command);
                  locationChoosable(command);
                  if (_state.commandLoyal(command)) {
                    final empire = _state.commandEmpire(command);
                    final emperor = _state.empireEmperor(empire);
                    if (!commands.contains(empire) && !phaseState.commandsFought.contains(emperor)) {
                      final statesman = _state.pieceInLocation(PieceType.statesman, emperor);
                      if (!_state.dynastyActive(Piece.dynastyTheodosian) || statesman == null || !_state.statesmanImperial(statesman)) {
                        commands.add(empire);
                        locationChoosable(empire);
                      }
                    }
                  }
                }
              }
            }
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
          final command = phaseState.command!;
          if (!checkChoice(Choice.fightWar)) {
            if (selectedLocations().length == phaseState.provinces.length) {
              setPrompt('Select Province to Fight War from');
              final spaces = _state.spaceConnectedSpaces(province);
              spaces.add(province);
              final enemy = _state.warEnemy(phaseState.war!);
              for (final space in spaces) {
                if (space.isType(LocationType.province) && !phaseState.provincesFought.contains(space) && !phaseState.provinces.contains(space)) {
                  final provinceCommand = _state.provinceCommand(space);
                  bool commandOk = false;
                  if (command.isType(LocationType.governorship)) {
                    commandOk = _state.commandAllegiance(provinceCommand) == command;
                  } else if (_state.commandIsRebelEmperor(command)) {
                    commandOk = _state.commandAllegiance(provinceCommand) == command;
                  } else if (!_state.soleEmperor) {
                    commandOk = _state.commandEmpire(provinceCommand) == command && _state.commandLoyal(provinceCommand);
                  } else {
                    commandOk = _state.commandLoyal(provinceCommand);
                  }
                  if (commandOk) {
                    final status = _state.provinceStatus(space);
                    switch (status) {
                    case ProvinceStatus.foederatiFrankish:
                    case ProvinceStatus.foederatiOstrogothic:
                    case ProvinceStatus.foederatiSuevian:
                    case ProvinceStatus.foederatiVandal:
                    case ProvinceStatus.foederatiVisigothic:
                      if (status.foederati != enemy) {
                        locationChoosable(space);
                      }
                    case ProvinceStatus.allied:
                      locationChoosable(space);
                    case ProvinceStatus.insurgent:
                    case ProvinceStatus.roman:
                      if (_state.provinceViableWarUnits(space).isNotEmpty) {
                        locationChoosable(space);
                      }
                    case ProvinceStatus.barbarian:
                    }
                  }
                }
              }
              bool haveEmpireProvinces = false;
              for (final province in phaseState.provinces) {
                final provinceCommand = _state.provinceCommand(province);
                if (_state.commandEmpire(provinceCommand) == phaseState.empire) {
                  haveEmpireProvinces = true;
                  break;
                }
              }
              choiceChoosable(Choice.fightWar, haveEmpireProvinces);
              choiceChoosable(Choice.cancel, true);
              throw PlayerChoiceException();
            }
            for (final space in selectedLocations()) {
              if (!phaseState.provinces.contains(space)) {
                phaseState.provinces.add(space);
                for (final unit in _state.provinceViableWarUnits(space)) {
                  phaseState.units.add(unit);
                }
              }
            }
          } else {
            fightWar(phaseState.province!, phaseState.command!, phaseState.empire!, phaseState.provinces);
            clearChoices();
            _subStep = 1;
          }
        }
        if (_subStep == 1) {
          if (_state.overstackedProvinces().isNotEmpty) {
            fixOverstacking();
          }
          final command = phaseState.command!;
          if (choicesEmpty()) {
            if (phaseState.destroyLegionsCount > 0 && phaseState.candidateDestroyLegions(_state).isEmpty) {
              phaseState.destroyLegionsCount = 0;
            }
            bool actionsAvailable = false;
            bool actionsMandatory = false;
            bool destroy = false;
            bool dismiss = false;
            bool demote = false;
            bool increaseUnrest = false;
            bool decreasePrestige = false;
            bool tribute = false;
            bool revolt = false;
            bool decreaseUnrest = false;
            bool increasePrestige = false;
            bool addGold = false;
            bool promote = false;
            bool annex = false;
            if (phaseState.destroyLegionsCount > 0 || phaseState.lossCount > 0) {
              if (phaseState.candidateDestroyLegions(_state).isNotEmpty) {
                destroy = true;
                actionsAvailable = true;
              }
            }
            if (phaseState.lossCount > phaseState.destroyLegionsCount) {
              if (phaseState.dismissCount < 2 && phaseState.candidateDismissUnits(_state).isNotEmpty) {
                final units = phaseState.candidateDismissUnits(_state);
                if (units.length >= _options.dismissAuxiliaCount) {
                  dismiss = true;
                  actionsAvailable = true;
                } else {
                  for (final unit in units) {
                    if (!unit.isType(PieceType.auxiliaOrdinary)) {
                      dismiss = true;
                      actionsAvailable = true;
                      break;
                    }
                  }
                }
              }
              if (phaseState.demoteCount < 2 && phaseState.candidateDemoteUnits(_state).isNotEmpty) {
                final units = phaseState.candidateDemoteUnits(_state);
                if (units.length >= 2) {
                  demote = true;
                  actionsAvailable = true;
                } else {
                  for (final unit in units) {
                    if (!unit.isType(PieceType.auxiliaOrdinary)) {
                      demote = true;
                      actionsAvailable = true;
                      break;
                    }
                  }
                }
              }
              if (phaseState.disgraceCount < 2) {
                increaseUnrest = true;
                actionsAvailable = true;
              }
              if (phaseState.dishonorCount < 2) {
                decreasePrestige = true;
                actionsAvailable = true;
              }
              if (phaseState.tributeCount < 2) {
                if (_state.commandLoyal(command)) {
                  if (_state.empireGold(phaseState.empire!) >= _options.tributeAmount) {
                    tribute = true;
                    actionsAvailable = true;
                  }
                } else {
                  if (phaseState.rebelGold >= _options.tributeAmount) {
                    tribute = true;
                    actionsAvailable = true;
                  }
                }
              }
              if (phaseState.revoltCount < 2 && phaseState.candidateRevoltProvinces(_state).isNotEmpty) {
                revolt = true;
                actionsAvailable = true;
              }
            }
            actionsMandatory = actionsAvailable;
            if (phaseState.unrest > 0) {
              decreaseUnrest = true;
              actionsAvailable = true;
            }
            if (phaseState.prestige > 0) {
              increasePrestige = true;
              actionsAvailable = true;
            }
            if (phaseState.gold > 0) {
              addGold = true;
              actionsAvailable = true;
            }
            if (phaseState.promoteCount > 0) {
              if (phaseState.candidatePromoteUnits(_state).isNotEmpty) {
                promote = true;
                actionsAvailable = true;
              }
            }
            if (phaseState.annexCount > 0) {
              if (phaseState.candidateAnnexProvinces(_state).isNotEmpty) {
                annex = true;
                actionsAvailable = true;
              }
            }
            if (actionsAvailable) {
              choiceChoosable(Choice.lossDestroy, destroy);
              choiceChoosable(Choice.lossDismiss, dismiss);
              choiceChoosable(Choice.lossDemote, demote);
              choiceChoosable(Choice.lossUnrest, increaseUnrest);
              choiceChoosable(Choice.lossPrestige, decreasePrestige);
              choiceChoosable(Choice.lossTribute, tribute);
              choiceChoosable(Choice.lossRevolt, revolt);
              choiceChoosable(Choice.decreaseUnrest, decreaseUnrest);
              choiceChoosable(Choice.increasePrestige, increasePrestige);
              choiceChoosable(Choice.addGold, addGold);
              choiceChoosable(Choice.promote, promote);
              choiceChoosable(Choice.annex, annex);
              choiceChoosable(Choice.next, !actionsMandatory);
              throw PlayerChoiceException();
            }
            _subStep = 2;
          }
          if (checkChoiceAndClear(Choice.next)) {
            _subStep = 2;
          }
          if (_subStep == 1) {
            if (checkChoice(Choice.cancel)) {
              clearChoices();
            } else if (checkChoice(Choice.lossDestroy)) {
              final legion = selectedPiece();
              if (legion == null) {
                setPrompt('Select Legion to Destroy');
                for (final legion in phaseState.candidateDestroyLegions(_state)) {
                  pieceChoosable(legion);
                }
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              legionDestroy(legion);
              phaseState.lossCount -= 1;
              if (phaseState.destroyLegionsCount > 0) {
                phaseState.destroyLegionsCount -= 1;
              }
              phaseState.destroyCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossDismiss)) {
              final units = selectedPieces();
              if (units.isEmpty || (units[0].isType(PieceType.auxiliaOrdinary) && units.length < _options.dismissAuxiliaCount)) {
                setPrompt('Select Unit(s) to Dismiss');
                int auxiliaCount = 0;
                for (final unit in phaseState.candidateDismissUnits(_state)) {
                  if (unit.isType(PieceType.auxiliaOrdinary)) {
                    auxiliaCount += 1;
                  } else {
                    if (units.isEmpty) {
                      pieceChoosable(unit);
                    }
                  }
                }
                if (units.length + auxiliaCount >= _options.dismissAuxiliaCount) {
                  for (final unit in phaseState.candidateDismissUnits(_state)) {
                    if (unit.isType(PieceType.auxiliaOrdinary)) {
                      pieceChoosable(unit);
                    }
                  }
                }
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              for (final unit in units) {
                unitDismiss(unit);
              }
              phaseState.lossCount -= 1;
              phaseState.dismissCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossDemote)) {
              final units = selectedPieces();
              if (units.isEmpty || (units[0].isType(PieceType.auxiliaOrdinary) && units.length < 2)) {
                setPrompt('Select Unit(s) to Demote');
                int auxiliaCount = 0;
                for (final unit in phaseState.candidateDemoteUnits(_state)) {
                  if (unit.isType(PieceType.auxiliaOrdinary)) {
                    auxiliaCount += 1;
                  } else {
                    if (units.isEmpty) {
                      pieceChoosable(unit);
                    }
                  }
                }
                if (units.length + auxiliaCount >= 2) {
                  for (final unit in phaseState.candidateDemoteUnits(_state)) {
                    if (unit.isType(PieceType.auxiliaOrdinary)) {
                      pieceChoosable(unit);
                    }
                  }
                }
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              for (final unit in units) {
                unitDemote(unit);
              }
              phaseState.lossCount -= 1;
              phaseState.demoteCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossUnrest)) {
              if (phaseState.disgraceCount == 0) {
                logLine('> Rome is Disgraced.');
              }
              adjustEmpireUnrest(phaseState.empire!, 1);
              phaseState.lossCount -= 1;
              phaseState.disgraceCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossPrestige)) {
              if (phaseState.dishonorCount == 0) {
                logLine('> Rome is Dishonored.');
              }
              adjustEmpirePrestige(phaseState.empire!, -1);
              phaseState.lossCount -= 1;
              phaseState.dishonorCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossTribute)) {
              if (phaseState.tributeCount == 0) {
                logLine('> Rome offers Tribute.');
              }
              int amount = _options.tributeAmount;
              if (phaseState.rebelGold > 0) {
                phaseState.rebelGold -= amount;
              } else {
                adjustEmpireGold(phaseState.empire!, -amount);
              }
              phaseState.lossCount -= 1;
              phaseState.tributeCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossRevolt)) {
              final province = selectedLocation();
              if (province == null) {
                setPrompt('Select Province to Revolt');
                for (final province in phaseState.candidateRevoltProvinces(_state)) {
                  locationChoosable(province);
                }
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              logLine('> ${province.desc} Revolts.');
              provinceDecreaseStatus(province);
              phaseState.lossCount -= 1;
              phaseState.revoltCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.decreaseUnrest)) {
              adjustEmpireUnrest(phaseState.empire!, -phaseState.unrest);
              phaseState.unrest = 0;
              clearChoices();
            } else if (checkChoice(Choice.increasePrestige)) {
              adjustEmpirePrestige(phaseState.empire!, phaseState.prestige);
              phaseState.prestige = 0;
              clearChoices();
            } else if (checkChoice(Choice.addGold)) {
              adjustEmpireGold(phaseState.empire!, phaseState.gold);
              phaseState.gold = 0;
              clearChoices();
            } else if (checkChoice(Choice.promote)) {
              final unit = selectedPiece();
              if (unit == null) {
                setPrompt('Select Unit to Promote');
                for (final unit in phaseState.candidatePromoteUnits(_state)) {
                  pieceChoosable(unit);
                }
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              unitPromote(unit);
              phaseState.promoteCount -= 1;
              clearChoices();
            } else if (checkChoice(Choice.annex)) {
              final province = selectedLocation();
              if (province == null) {
                setPrompt('Select Province to Annex');
                for (final province in phaseState.candidateAnnexProvinces(_state)) {
                  locationChoosable(province);
                }
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              logLine('> Annex ${province.desc}');
              annexProvince(province);
              phaseState.annexCount -= 1;
              clearChoices();
            }
          }
        }
        if (_subStep == 2) {
          if (phaseState.deadEmperor != null) {
            newEmperor(phaseState.deadEmperor!, null, EmperorDeathCause.disaster, null);
          }
          phaseState.warComplete(true);
          _subStep = 0;
        }
      }
      _subStep = 3;
    }
    if (_subStep == 3) {
      phaseState.clearWars();
      _subStep = 4;
      setPrompt('Fight Wars Step Complete');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    clearChoices();
  }

  void warPhaseFightRebels() {
    final phaseState = _phaseState as PhaseStateWar;
    while (_subStep >= 0 && _subStep <= 2) {
      while (unfoughtRebels().isNotEmpty) {
        if (_subStep == 0) {
          if (choicesEmpty()) {
            bool optional = true;
            setPrompt('Select Rebel to Fight');
            for (final command in unfoughtRebels()) {
              locationChoosable(command);
              final empire = _state.commandEmpire(command);
              if (!_state.empireHasFallen(empire) && _state.commandLoyal(empire)) {
                optional = false;
              }
            }
            if (optional) {
              choiceChoosable(Choice.fightRebelsForego, true);
            }
            throw PlayerChoiceException();
          }
          if (checkChoice(Choice.fightRebelsForego)) {
            clearChoices();
            break;
          }
          final rebelCommand = selectedLocationAndClear()!;
          Location? emperorCommand;
          if (rebelCommand.isType(LocationType.emperor)) {
            emperorCommand = _state.otherEmpire(rebelCommand);
          } else {
            emperorCommand = _state.empireEmperor(_state.commandEmpire(rebelCommand)); 
          }
          phaseState.empire = emperorCommand;
          phaseState.command = rebelCommand;
          fightRebel(emperorCommand, rebelCommand);
          clearChoices();
          _subStep = 1;
        }
        if (_subStep == 1) {
          if (choicesEmpty()) {
            if (phaseState.destroyLegionsCount > 0 &&
                phaseState.candidateDestroyCivilWarLegions(_state).isEmpty) {
              phaseState.destroyLegionsCount = 0;
            }
            bool actionsAvailable = false;
            bool destroy = false;
            bool dismiss = false;
            bool demote = false;
            bool increaseUnrest = false;
            bool decreasePrestige = false;
            bool tribute = false;
            bool promote = false;
            if (phaseState.destroyLegionsCount > 0 || phaseState.lossCount > 0) {
              if (phaseState.candidateDestroyCivilWarLegions(_state).isNotEmpty) {
                destroy = true;
                actionsAvailable = true;
              }
            }
            if (phaseState.lossCount > phaseState.destroyLegionsCount) {
              if (phaseState.dismissCount < 2) {
                final units = phaseState.candidateDismissCivilWarUnits(_state);
                if (units.length >= _options.dismissAuxiliaCount) {
                  dismiss = true;
                  actionsAvailable = true;
                } else {
                  for (final unit in units) {
                    if (!unit.isType(PieceType.auxilia)) {
                      dismiss = true;
                      actionsAvailable = true;
                      break;
                    }
                  }
                }
              }
              if (phaseState.demoteCount < 2) {
                final units = phaseState.candidateDemoteCivilWarUnits(_state);
                if (units.length >= 2) {
                  demote = true;
                  actionsAvailable = true;
                } else {
                  for (final unit in units) {
                    if (!unit.isType(PieceType.auxiliaOrdinary)) {
                      demote = true;
                      actionsAvailable = true;
                      break;
                    }
                  }
                }
              }
              if (phaseState.disgraceCount < 2) {
                increaseUnrest = true;
                actionsAvailable = true;
              }
              if (phaseState.dishonorCount < 2) {
                decreasePrestige = true;
                actionsAvailable = true;
              }
              if (phaseState.tributeCount < 2 && _state.empireGold(phaseState.empire!) >= _options.tributeAmount) {
                tribute = true;
                actionsAvailable = true;
              }
            }
            bool actionsMandatory = actionsAvailable;
            if (phaseState.promoteCount > 0 || phaseState.anyPromoteCount > 0) {
              if (phaseState.candidatePromoteUnits(_state).isNotEmpty) {
                promote = true;
                actionsAvailable = true;
              }
            }
            if (phaseState.rebelPromoteCount > 0 || phaseState.anyPromoteCount > 0) {
              if (phaseState.candidatePromoteRebelUnits(_state).isNotEmpty) {
                promote = true;
                actionsAvailable = true;
              }
            }
            if (actionsAvailable) {
              choiceChoosable(Choice.lossDestroy, destroy);
              choiceChoosable(Choice.lossDismiss, dismiss);
              choiceChoosable(Choice.lossDemote, demote);
              choiceChoosable(Choice.lossUnrest, increaseUnrest);
              choiceChoosable(Choice.lossPrestige, decreasePrestige);
              choiceChoosable(Choice.lossTribute, tribute);
              choiceChoosable(Choice.promote, promote);
              choiceChoosable(Choice.next, !actionsMandatory);
              throw PlayerChoiceException();
            }
            _subStep = 2;
          }
          if (checkChoiceAndClear(Choice.next)) {
            _subStep = 2;
          }
          if (_subStep == 1) {
            if (checkChoice(Choice.cancel)) {
              clearChoices();
            } else if (checkChoice(Choice.lossDestroy)) {
              final legion = selectedPiece();
              if (legion == null) {
                setPrompt('Select Legion to Destroy');
                for (final legion in phaseState.candidateDestroyCivilWarLegions(_state)) {
                  pieceChoosable(legion);
                }
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              legionDestroy(legion);
              phaseState.lossCount -= 1;
              phaseState.destroyCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossDismiss)) {
              final units = selectedPieces();
              if (units.isEmpty || (units[0].isType(PieceType.auxilia) && units.length < _options.dismissAuxiliaCount)) {
                setPrompt('Select Unit(s) to Dismiss');
                int auxiliaCount = 0;
                for (final unit in phaseState.candidateDismissCivilWarUnits(_state)) {
                  if (unit.isType(PieceType.auxilia)) {
                    auxiliaCount += 1;
                  } else {
                    if (units.isEmpty) {
                      pieceChoosable(unit);
                    }
                  }
                }
                if (units.length + auxiliaCount >= _options.dismissAuxiliaCount) {
                  for (final unit in phaseState.candidateDismissCivilWarUnits(_state)) {
                    if (unit.isType(PieceType.auxilia)) {
                      pieceChoosable(unit);
                    }
                  }
                }
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              for (final unit in units) {
                unitDismiss(unit);
              }
              phaseState.lossCount -= 1;
              phaseState.dismissCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossDemote)) {
              final units = selectedPieces();
              if (units.isEmpty || (units[0].isType(PieceType.auxilia) && units.length < 2)) {
                setPrompt('Select Unit(s) to Demote');
                int auxiliaCount = 0;
                for (final unit in phaseState.candidateDemoteCivilWarUnits(_state)) {
                  if (unit.isType(PieceType.auxiliaVeteran)) {
                    auxiliaCount += 1;
                  } else {
                    if (units.isEmpty) {
                      pieceChoosable(unit);
                    }
                  }
                }
                if (units.length + auxiliaCount >= 2) {
                  for (final unit in phaseState.candidateDemoteCivilWarUnits(_state)) {
                    if (unit.isType(PieceType.auxiliaVeteran)) {
                      pieceChoosable(unit);
                    }
                  }
                }
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              for (final unit in units) {
                unitDemote(unit);
              }
              phaseState.lossCount -= 1;
              phaseState.demoteCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossUnrest)) {
              if (phaseState.disgraceCount == 0) {
                logLine('> Rome is Disgraced.');
              }
              adjustEmpireUnrest(phaseState.empire!, 1);
              phaseState.lossCount -= 1;
              phaseState.disgraceCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossPrestige)) {
              if (phaseState.dishonorCount == 0) {
                logLine('> Rome is Dishonored.');
              }
              adjustEmpirePrestige(phaseState.empire!, -1);
              phaseState.lossCount -= 1;
              phaseState.dishonorCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossTribute)) {
              if (phaseState.tributeCount == 0) {
                logLine('> Rome offers Tribute.');
              }
              adjustEmpireGold(phaseState.empire!, -_options.tributeAmount);
              phaseState.lossCount -= 1;
              phaseState.tributeCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.promote)) {
              final unit = selectedPiece();
              if (unit == null) {
                setPrompt('Select Unit to Promote');
                if (phaseState.rebelPromoteCount > 0 || phaseState.anyPromoteCount > 0) {
                  for (final unit in phaseState.candidatePromoteRebelUnits(_state)) {
                    pieceChoosable(unit);
                  }
                }
                if (phaseState.promoteCount > 0 || phaseState.anyPromoteCount > 0) {
                  for (final unit in phaseState.candidatePromoteUnits(_state)) {
                    pieceChoosable(unit);
                  }
                }
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              unitPromote(unit);
              if (phaseState.rebelPromoteCount >= 1 && phaseState.rebelUnits.contains(unit)) {
                phaseState.rebelPromoteCount -= 1;
              } else if (phaseState.promoteCount >= 1 && phaseState.units.contains(unit)) {
                phaseState.promoteCount -= 1;
              } else {
                phaseState.anyPromoteCount -= 1;
              }
              clearChoices();
            }
          }
        }
        if (_subStep == 2) {
          if (phaseState.deadEmperor != null) {
            final cause = phaseState.deadEmperor == phaseState.empire ? EmperorDeathCause.rebelEmperorVictory : EmperorDeathCause.rebelEmperorDefeat;
            final causeCommand = phaseState.deadEmperor == phaseState.empire ? phaseState.command! : phaseState.empire!;
            newEmperor(phaseState.deadEmperor!, null, cause, causeCommand);
          }
          phaseState.warComplete(true);
          _subStep = 0;
        }
      }
      _subStep = 3;
    }
    if (_subStep == 3) {
      phaseState.clearRebels();
      clearChoices();
    }
  }

  void warPhaseCheckRebellions() {
    if (_subStep == 0) {
      int count = 0;
      for (final command in LocationType.governorship.locations) {
        final wars = <Piece>[];
        for (final war in PieceType.war.pieces) {
          if (_state.pieceLocation(war) == command) {
            wars.add(war);
          }
        }
        if (wars.isNotEmpty) {
          makeRebellionCheckForCommand(command);
          count += 1;
          for (final war in wars) {
            _state.setBarbarianOffmap(war);
          }
        }
      }
      if (count > 0) {
        _subStep = 1;
        setPrompt('Check Rebellion Step Complete');
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
    }
  }

  void warPhaseCheckDefeat() {
    _phaseState = null;
    checkDefeat();
  }

  void victoryPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Victory Phase');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    logLine('## Victory Phase');
  }

  void victoryPhaseCheckVictory() {
    if (_state.turn + 1 == _firstTurn + _turnCount) {
      checkVictory();
    }
  }

  void victoryPhaseAdvanceScenario() {
    if (_state.turn % 10 == 9) {
      advanceScenario();
    }
  }

  void victoryPhaseAdvanceTurn() {
	  _state.advanceTurn();
  }

  void playInSequence() {

    final stepHandlers = [
      turnBegin,
      eventPhaseBegin,
      eventPhaseRemoveEventCounters,
      eventPhasePersecution,
      eventPhaseConvert,
      eventPhaseDiplomat,
      eventPhaseEventRoll,
      eventPhaseRandomEvent,
      eventPhaseRandomEvent,
      eventPhaseRandomEvent,
      eventPhaseRandomEvent,
      eventPhaseRandomEvent,
      eventPhaseRandomEvent,
      eventPhaseRandomEvent,
      eventPhaseRandomEvent,
      eventPhaseRandomEvent,
      eventPhaseRandomEvent,
      eventPhaseRandomEvent,
      eventPhaseRandomEvent,
      eventPhaseEventsComplete,
      eventPhaseMortality,
      eventPhaseAssassination,
      eventPhaseCheckDefeat,
      treasuryPhaseBegin,
      treasuryPhaseTaxWestern,
      treasuryPhaseTaxEastern,
      treasuryPhaseTaxComplete,
      treasuryPhasePayWestern,
      treasuryPhasePayEastern,
      treasuryPhasePayComplete,
      treasuryPhaseExtraTaxes,
      treasuryPhaseMoveWarsInit,
      treasuryPhaseMoveCurrentWars,
      treasuryPhaseNewWarCount,
      treasuryPhaseDrawAndMoveNewWars,
      treasuryPhaseCheckDefeat,
      unrestPhaseBegin,
      unrestPhaseIncreaseWesternUnrest,
      unrestPhaseIncreaseEasternUnrest,
      unrestPhaseDrawStatesmen,
      unrestPhaseAnnex,
      unrestPhaseAppointCommanders,
      unrestPhaseAdjustWesternPrestigeAndUnrest,
      unrestPhaseAdjustEasternPrestigeAndUnrest,
      unrestPhaseBreadAndCircuses,
      unrestPhaseBuildAndTransferUnits,
      unrestPhaseCheckDefeat,
      warPhaseBegin,
      warPhaseCheckRevolts,
      warPhaseFightWars,
      warPhaseFightRebels,
      warPhaseCheckRebellions,
      warPhaseCheckDefeat,
      victoryPhaseBegin,
      victoryPhaseCheckVictory,
      victoryPhaseAdvanceScenario,
      victoryPhaseAdvanceTurn,
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

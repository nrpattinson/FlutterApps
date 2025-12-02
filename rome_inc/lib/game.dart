import 'dart:convert';
import 'dart:math';

import 'package:rome_inc/db.dart';
import 'package:rome_inc/random.dart';

enum Location {
  provinceAlpes,
  provinceCorsicaSardinia,
  provinceMediolanum,
  provinceNeapolis,
  provincePisae,
  provinceRavenna,
  provinceRome,
  provinceSicilia,
  provinceBritanniaInferior,
  provinceBritanniaSuperior,
  provinceCaledonia,
  provinceHibernia,
  provinceAgriDecumates,
  provinceAquitania,
  provinceBelgica,
  provinceFrisia,
  provinceGermaniaInferior,
  provinceGermaniaMagna,
  provinceGermaniaSuperior,
  provinceLugdunensis,
  provinceNarbonensis,
  provinceRhaetia,
  provinceBoiohaemia,
  provinceIllyria,
  provinceNoricum,
  provincePannoniaInferior,
  provincePannoniaSuperior,
  provinceQuadia,
  provinceSarmatia,
  provinceAchaea,
  provinceBosporus,
  provinceDaciaInferior,
  provinceDaciaSuperior,
  provinceEpirus,
  provinceMacedonia,
  provinceMoesiaInferior,
  provinceMoesiaSuperior,
  provinceScythia,
  provinceThracia,
  provinceBaetica,
  provinceBaleares,
  provinceCarthaginensis,
  provinceGallaecia,
  provinceLusitania,
  provinceTarraconensis,
  provinceAfrica,
  provinceLibya,
  provinceMauretaniaCaesariensis,
  provinceMauretaniaTingitana,
  provinceNumidia,
  provinceAethiopia,
  provinceAlexandria,
  provinceArcadia,
  provinceCreta,
  provinceCyrenaica,
  provinceThebais,
  provinceArabia,
  provinceAssyria,
  provinceBabylonia,
  provinceCilicia,
  provinceCommagene,
  provinceCyprus,
  provinceJudea,
  provinceMesopotamia,
  provinceOsrhoene,
  provincePalmyra,
  provincePhoenicia,
  provinceSyria,
  provinceAlbania,
  provinceArmeniaMajor,
  provinceArmeniaMinor,
  provinceAsia,
  provinceBithynia,
  provinceCappadocia,
  provinceCaucasia,
  provinceColchis,
  provinceGalatia,
  provinceIberia,
  provinceLyciaPamphylia,
  provincePontus,
  provinceRhodus,
  homelandAlamannic,
  homelandAlan,
  homelandBritish,
  homelandBurgundian,
  homelandCaledonian,
  homelandCantabrian,
  homelandDacian,
  homelandFrankish,
  homelandGerman,
  homelandGothic,
  homelandIllyrian,
  homelandJudean,
  homelandMarcomannic,
  homelandMoorish,
  homelandNubian,
  homelandPalmyrene,
  homelandParthian,
  homelandPersian,
  homelandSarmatian,
  homelandSaxon,
  homelandVandal,
  commandCaesar,
  commandConsul,
  commandPrefect,
  commandBritannia,
  commandGallia,
  commandPannonia,
  commandMoesia,
  commandHispania,
  commandAfrica,
  commandAegyptus,
  commandSyria,
  commandPontica,
  boxStatesmen,
  boxEmperors,
  boxBarracks,
  boxDestroyedLegions,
  poolStatesmen,
  poolWars,
  flipped,
  offmap,
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
  province,
  provinceItalia,
  provinceBritannia,
  provinceGallia,
  provincePannonia,
  provinceMoesia,
  provinceHispania,
  provinceAfrica,
  provinceAegyptus,
  provinceSyria,
  provincePontica,
  homeland,
  space,
  command,
  governorship,
}

extension LocationTypeExtension on LocationType {
  static const _bounds = {
    LocationType.land: [Location.provinceAlpes, Location.homelandVandal],
    LocationType.province: [Location.provinceAlpes, Location.provinceRhodus],
    LocationType.provinceItalia: [Location.provinceAlpes, Location.provinceSicilia],
    LocationType.provinceBritannia: [Location.provinceBritanniaInferior, Location.provinceHibernia],
    LocationType.provinceGallia: [Location.provinceAgriDecumates, Location.provinceRhaetia],
    LocationType.provincePannonia: [Location.provinceBoiohaemia, Location.provinceSarmatia],
    LocationType.provinceMoesia: [Location.provinceAchaea, Location.provinceThracia],
    LocationType.provinceHispania: [Location.provinceBaetica, Location.provinceTarraconensis],
    LocationType.provinceAfrica: [Location.provinceAfrica, Location.provinceNumidia],
    LocationType.provinceAegyptus: [Location.provinceAethiopia, Location.provinceThebais],
    LocationType.provinceSyria: [Location.provinceArabia, Location.provinceSyria],
    LocationType.provincePontica: [Location.provinceAlbania, Location.provinceRhodus],
    LocationType.homeland: [Location.homelandAlamannic, Location.homelandVandal],
    LocationType.space: [Location.provinceAlpes, Location.homelandVandal],
    LocationType.command: [Location.commandCaesar, Location.commandPontica],
    LocationType.governorship: [Location.commandPrefect, Location.commandPontica]
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
      'Alpes',
      'Corsica & Sardinia',
      'Mediolanum',
      'Neapolis',
      'Pisae',
      'Ravenna',
      'Rome',
      'Sicilia',
      'Britannia Inferior',
      'Britannia Superior',
      'Caledonia',
      'Hibernia',
      'Agri Decumates',
      'Aquitania',
      'Belgica',
      'Frisia',
      'Germania Inferior',
      'Germania Magna',
      'Germania Superior',
      'Lugdunensis',
      'Narbonensis',
      'Rhaetia',
      'Boiohaemia',
      'Illyria',
      'Noricum',
      'Pannonia Inferior',
      'Pannonia Superior',
      'Quadia',
      'Sarmatia',
      'Achaea',
      'Bosporus',
      'Dacia Inferior',
      'Dacia Superior',
      'Epirus',
      'Macedonia',
      'Moesia Inferior',
      'Moesia Superior',
      'Scythia',
      'Thracia',
      'Baetica',
      'Baleares',
      'Carthaginensis',
      'Gallaecia',
      'Lusitania',
      'Tarraconensis',
      'Africa',
      'Libya',
      'Mauretania Caesariensis',
      'Mauretania Tingitana',
      'Numidia',
      'Aethiopia',
      'Alexandria',
      'Arcadia',
      'Creta',
      'Cyrenaica',
      'Thebais',
      'Arabia',
      'Assyria',
      'Babylonia',
      'Cilicia',
      'Commagene',
      'Cyprus',
      'Judea',
      'Mesopotamia',
      'Osrhoene',
      'Palmyra',
      'Phoenicia',
      'Syria',
      'Albania',
      'Armenia Major',
      'Armenia Minor',
      'Asia',
      'Bithynia',
      'Cappadocia',
      'Caucasia',
      'Colchis',
      'Galatia',
      'Iberia',
      'Lycia & Pamphylia',
      'Pontus',
      'Rhodus',
      'Alamannic Homeland',
      'Alan Homeland',
      'British Homeland',
      'Burgundian Homeland',
      'Caledonian Homeland',
      'Cantabrian Homeland',
      'Dacian Homeland',
      'Frankish Homeland',
      'German Homeland',
      'Gothic Homeland',
      'Illyrian Homeland',
      'Judean Homeland',
      'Marcomannic Homeland',
      'Moorish Homeland',
      'Nubian Homeland',
      'Palmyrene Homeland',
      'Parthian Homeland',
      'Persian Homeland',
      'Sarmatian Homeland',
      'Saxon Homeland',
      'Vandal Homeland'
      'Caesar',
      'Consul',
      'Prefect',
      'Britannia',
      'Gallia',
      'Pannonia',
      'Moesia',
      'Hispania',
      'Africa',
      'Aegyptus',
      'Syria',
      'Pontica',
      'Statesmen',
      'Emperors',
      'Barracks',
      'Destroyed Legions',
      'Statesmen',
      'Wars',
      'Off Map',
    ];
    return locationNames[index];
  }
}

enum Piece {
  legionAdiutrixI,
  legionAdiutrixII,
  legionAlaudaeV,
  legionApollinarisXV,
  legionAugustaII,
  legionAugustaIII,
  legionAugustaVIII,
  legionClaudiaVII,
  legionClaudiaXI,
  legionCyrenaicaIII,
  legionDeiotarianaXXII,
  legionFerrataVI,
  legionFlaviaIV,
  legionFlaviaXVI,
  legionFretensisX,
  legionFulminataXII,
  legionGallicaIII,
  legionGallicaXVI,
  legionGeminaVII,
  legionGeminaX,
  legionGeminaXIII,
  legionGeminaXIV,
  legionGermanicaI,
  legionHispanaIX,
  legionIllyricorumI,
  legionItalicaI,
  legionItalicaII,
  legionItalicaIII,
  legionItalicaIV,
  legionMacedonicaIV,
  legionMacedonicaV,
  legionMinerviaI,
  legionParthicaI,
  legionParthicaII,
  legionParthicaIII,
  legionPrimigeniaXV,
  legionPrimigeniaXXII,
  legionRapaxXXI,
  legionScythicaIV,
  legionTrajanaII,
  legionUlpiaXXX,
  legionValeriaXX,
  legionVarianaXVII,
  legionVarianaXVIII,
  legionVarianaXIX,
  legionVictrixVI,
  legionAdiutrixIVeteran,
  legionAdiutrixIIVeteran,
  legionAlaudaeVVeteran,
  legionApollinarisXVVeteran,
  legionAugustaIIVeteran,
  legionAugustaIIIVeteran,
  legionAugustaVIIIVeteran,
  legionClaudiaVIIVeteran,
  legionClaudiaXIVeteran,
  legionCyrenaicaIIIVeteran,
  legionDeiotarianaXXIIVeteran,
  legionFerrataVIVeteran,
  legionFlaviaIVVeteran,
  legionFlaviaXVIVeteran,
  legionFretensisXVeteran,
  legionFulminataXIIVeteran,
  legionGallicaIIIVeteran,
  legionGallicaXVIVeteran,
  legionGeminaVIIVeteran,
  legionGeminaXVeteran,
  legionGeminaXIIIVeteran,
  legionGeminaXIVVeteran,
  legionGermanicaIVeteran,
  legionHispanaIXVeteran,
  legionIllyricorumIVeteran,
  legionItalicaIVeteran,
  legionItalicaIIVeteran,
  legionItalicaIIIVeteran,
  legionItalicaIVVeteran,
  legionMacedonicaIVVeteran,
  legionMacedonicaVVeteran,
  legionMinerviaIVeteran,
  legionParthicaIVeteran,
  legionParthicaIIVeteran,
  legionParthicaIIIVeteran,
  legionPrimigeniaXVVeteran,
  legionPrimigeniaXXIIVeteran,
  legionRapaxXXIVeteran,
  legionScythicaIVVeteran,
  legionTrajanaIIVeteran,
  legionUlpiaXXXVeteran,
  legionValeriaXXVeteran,
  legionVarianaXVIIVeteran,
  legionVarianaXVIIIVeteran,
  legionVarianaXIXVeteran,
  legionVictrixVIVeteran,
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
  auxilia0Veteran,
  auxilia1Veteran,
  auxilia2Veteran,
  auxilia3Veteran,
  auxilia4Veteran,
  auxilia5Veteran,
  auxilia6Veteran,
  auxilia7Veteran,
  auxilia8Veteran,
  auxilia9Veteran,
  auxilia10Veteran,
  auxilia11Veteran,
  auxilia12Veteran,
  auxilia13Veteran,
  auxilia14Veteran,
  auxilia15Veteran,
  auxilia16Veteran,
  auxilia17Veteran,
  auxilia18Veteran,
  auxilia19Veteran,
  praetorianGuard0,
  praetorianGuard1,
  praetorianGuard2,
  praetorianGuard0Veteran,
  praetorianGuard1Veteran,
  praetorianGuard2Veteran,
  imperialCavalry0,
  imperialCavalry1,
  imperialCavalry2,
  imperialCavalry0Veteran,
  imperialCavalry1Veteran,
  imperialCavalry2Veteran,
  fleetPraetorian0,
  fleetPraetorian1,
  fleetAegyptian,
  fleetAfrican,
  fleetBabylonian,
  fleetBosporan,
  fleetBritish,
  fleetGerman,
  fleetMoesian,
  fleetPannonian,
  fleetPontic,
  fleetSyrian,
  fleetPraetorian0Veteran,
  fleetPraetorian1Veteran,
  fleetAegyptianVeteran,
  fleetAfricanVeteran,
  fleetBabylonianVeteran,
  fleetBosporanVeteran,
  fleetBritishVeteran,
  fleetGermanVeteran,
  fleetMoesianVeteran,
  fleetPannonianVeteran,
  fleetPonticVeteran,
  fleetSyrianVeteran,
  wall0,
  wall1,
  wall2,
  wall3,
  leaderChrocus,
  leaderBoudicca,
  leaderCaratacus,
  leaderCalgacus,
  leaderDecebalus,
  leaderArminius,
  leaderCivilis,
  leaderKniva,
  leaderBato,
  leaderSimeon,
  leaderBallomar,
  leaderTacfarinus,
  leaderZenobia,
  leaderVologases,
  leaderShapur,
  warAlamannic10,
  warAlamannic12,
  warAlan9,
  warBritish6,
  warBritish7,
  warBurgundian11,
  warCaledonian4,
  warCaledonian5,
  warCantabrian8,
  warDacian10,
  warDacian11,
  warDacian12,
  warFrankish9,
  warFrankish11,
  warGerman8,
  warGerman10,
  warGerman12,
  warGerman14,
  warGothic13,
  warGothic15,
  warIllyrian10,
  warIllyrian12,
  warJudean6,
  warJudean7,
  warJudean8,
  warMarcomannic9,
  warMarcomannic11,
  warMarcomannic13,
  warMoorish5,
  warMoorish7,
  warNubian4,
  warNubian6,
  warPalmyrene14,
  warParthian8,
  warParthian10,
  warParthian12,
  warParthian14,
  warPersian9,
  warPersian11,
  warPersian13,
  warPersian15,
  warSarmatian8,
  warSarmatian10,
  warSaxon6,
  warVandal9,
  statesmanAelianus,
  statesmanAemilian,
  statesmanAgricola,
  statesmanAgrippa,
  statesmanAlbinus,
  statesmanAlexander,
  statesmanAntoninus,
  statesmanArrian,
  statesmanAugustus,
  statesmanAurelian,
  statesmanAvidius,
  statesmanCaligula,
  statesmanCaracalla,
  statesmanCarausius,
  statesmanCarinus,
  statesmanCarus,
  statesmanCerialis,
  statesmanClaudius,
  statesmanCommodus,
  statesmanCorbulo,
  statesmanDecius,
  statesmanDiocletian,
  statesmanDomitian,
  statesmanDrusus,
  statesmanElagabalus,
  statesmanGalba,
  statesmanGallienus,
  statesmanGallus,
  statesmanGermanicus,
  statesmanGordian,
  statesmanGothicus,
  statesmanHadrian,
  statesmanJulianus,
  statesmanLaetus,
  statesmanLucius,
  statesmanMacrinus,
  statesmanMacro,
  statesmanMarcus,
  statesmanMaximian,
  statesmanMaximinus,
  statesmanNero,
  statesmanNerva,
  statesmanNiger,
  statesmanOdaenath,
  statesmanOtho,
  statesmanPaulinus,
  statesmanPertinax,
  statesmanPhilip,
  statesmanPlautianus,
  statesmanPlautius,
  statesmanPompeianus,
  statesmanPostumus,
  statesmanProbus,
  statesmanQuietus,
  statesmanSejanus,
  statesmanSeverus,
  statesmanSilvanus,
  statesmanTacitus,
  statesmanTiberius,
  statesmanTimesitheus,
  statesmanTitus,
  statesmanTrajan,
  statesmanTurbo,
  statesmanValerian,
  statesmanVespasian,
  statesmanVitellius,
  emperorsJulian,
  emperorsClaudian,
  emperorsFlavian,
  emperorsAdoptive,
  emperorsAntonine,
  emperorsSeveran,
  emperorsBarracks,
  emperorsIllyrian,
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
  mobileUnit,
  mobileLandUnit,
  legion,
  legionOrdinary,
  legionVeteran,
  auxilia,
  auxiliaOrdinary,
  auxiliaVeteran,
  praetorianGuard,
  praetorianGuardOrdinary,
  praetorianGuardVeteran,
  imperialCavalry,
  imperialCavalryOrdinary,
  imperialCavalryVeteran,
  fleet,
  fleetOrdinary,
  fleetVeteran,
  wall,
  leader,
  war,
  barbarian,
  statesman,
  emperors,
  statesmenPool,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.legionAdiutrixI, Piece.emperorsIllyrian],
    PieceType.unit: [Piece.legionAdiutrixI, Piece.wall3],
    PieceType.mobileUnit: [Piece.legionAdiutrixI, Piece.fleetSyrianVeteran],
    PieceType.mobileLandUnit: [Piece.legionAdiutrixI, Piece.imperialCavalry2Veteran],
    PieceType.legion: [Piece.legionAdiutrixI, Piece.legionVictrixVIVeteran],
    PieceType.legionOrdinary: [Piece.legionAdiutrixI, Piece.legionVictrixVI],
    PieceType.legionVeteran: [Piece.legionAdiutrixIVeteran, Piece.legionVictrixVIVeteran],
    PieceType.auxilia: [Piece.auxilia0, Piece.auxilia19Veteran],
    PieceType.auxiliaOrdinary: [Piece.auxilia0, Piece.auxilia19],
    PieceType.auxiliaVeteran: [Piece.auxilia0Veteran, Piece.auxilia19Veteran],
    PieceType.praetorianGuard: [Piece.praetorianGuard0, Piece.praetorianGuard2Veteran],
    PieceType.praetorianGuardOrdinary: [Piece.praetorianGuard0, Piece.praetorianGuard2],
    PieceType.praetorianGuardVeteran: [Piece.praetorianGuard0Veteran, Piece.praetorianGuard2Veteran],
    PieceType.imperialCavalry: [Piece.imperialCavalry0, Piece.imperialCavalry2Veteran],
    PieceType.imperialCavalryOrdinary: [Piece.imperialCavalry0, Piece.imperialCavalry2],
    PieceType.imperialCavalryVeteran: [Piece.imperialCavalry0Veteran, Piece.imperialCavalry2Veteran],
    PieceType.fleet: [Piece.fleetPraetorian0, Piece.fleetSyrianVeteran],
    PieceType.fleetOrdinary: [Piece.fleetPraetorian0, Piece.fleetSyrian],
    PieceType.fleetVeteran: [Piece.fleetPraetorian0Veteran, Piece.fleetSyrianVeteran],
    PieceType.wall: [Piece.wall0, Piece.wall1],
    PieceType.leader: [Piece.leaderChrocus, Piece.leaderShapur],
    PieceType.war: [Piece.warAlamannic10, Piece.warVandal9],
    PieceType.barbarian: [Piece.leaderChrocus, Piece.warVandal9],
    PieceType.statesman: [Piece.statesmanAelianus, Piece.statesmanVitellius],
    PieceType.emperors: [Piece.emperorsJulian, Piece.emperorsIllyrian],
    PieceType.statesmenPool: [Piece.statesmanAelianus, Piece.emperorsIllyrian],
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
      'Legion Adiutrix I',
      'Legion Adiutrix II',
      'Legion Alaudae V',
      'Legion Apollinaris XV',
      'Legion Augusta II',
      'Legion Augusta III',
      'Legion Augusta VIII',
      'Legion Claudia VII',
      'Legion Claudia XI',
      'Legion Cyrenaica III',
      'Legion Deiotariana XXII',
      'Legion Ferrata VI',
      'Legion Flavia IV',
      'Legion Flavia XVI',
      'Legion Fretensis X',
      'Legion Fulminata XII',
      'Legion Gallica III',
      'Legion Gallica XVI',
      'Legion Gemina VII',
      'Legion Gemina X',
      'Legion Gemina XIII',
      'Legion Gemina XIV',
      'Legion Germanica I',
      'Legion Hispana IX',
      'Legion Illyricorum I',
      'Legion Italica I',
      'Legion Italica II',
      'Legion Italica III',
      'Legion Italica IV',
      'Legion Macedonica IV',
      'Legion Macedonica V',
      'Legion Minervia I',
      'Legion Parthica I',
      'Legion Parthica II',
      'Legion Parthica III',
      'Legion Primigenia XV',
      'Legion Primigenia XXII',
      'Legion Rapax XXI',
      'Legion Scythica IV',
      'Legion Trajana II',
      'Legion Ulpia XXX',
      'Legion Valeria XX',
      'Legion Variana XVII',
      'Legion Variana XVIII',
      'Legion Variana XIX',
      'Legion Victrix VI',
      'Veteran Legion Adiutrix I',
      'Veteran Legion Adiutrix II',
      'Veteran Legion Alaudae V',
      'Veteran Legion Apollinaris XV',
      'Veteran Legion Augusta II',
      'Veteran Legion Augusta III',
      'Veteran Legion Augusta VIII',
      'Veteran Legion Claudia VII',
      'Veteran Legion Claudia XI',
      'Veteran Legion Cyrenaica III',
      'Veteran Legion Deiotariana XXII',
      'Veteran Legion Ferrata VI',
      'Veteran Legion Flavia IV',
      'Veteran Legion Flavia XVI',
      'Veteran Legion Fretensis X',
      'Veteran Legion Fulminata XII',
      'Veteran Legion Gallica III',
      'Veteran Legion Gallica XVI',
      'Veteran Legion Gemina VII',
      'Veteran Legion Gemina X',
      'Veteran Legion Gemina XIII',
      'Veteran Legion Gemina XIV',
      'Veteran Legion Germanica I',
      'Veteran Legion Hispana IX',
      'Veteran Legion Illyricorum I',
      'Veteran Legion Italica I',
      'Veteran Legion Italica II',
      'Veteran Legion Italica III',
      'Veteran Legion Italica IV',
      'Veteran Legion Macedonica IV',
      'Veteran Legion Macedonica V',
      'Veteran Legion Minervia I',
      'Veteran Legion Parthica I',
      'Veteran Legion Parthica II',
      'Veteran Legion Parthica III',
      'Veteran Legion Primigenia XV',
      'Veteran Legion Primigenia XXII',
      'Veteran Legion Rapax XXI',
      'Veteran Legion Scythica IV',
      'Veteran Legion Trajana II',
      'Veteran Legion Ulpia XXX',
      'Veteran Legion Valeria XX',
      'Veteran Legion Variana XVII',
      'Veteran Legion Variana XVIII',
      'Veteran Legion Variana XIX',
      'Veteran Legion Victrix VI',
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
      'Praetorian Guard',
      'Praetorian Guard',
      'Praetorian Guard',
      'Veteran Praetorian Guard',
      'Veteran Praetorian Guard',
      'Veteran Praetorian Guard',
      'Imperial Cavalry',
      'Imperial Cavalry',
      'Imperial Cavalry',
      'Veteran Imperial Cavalry',
      'Veteran Imperial Cavalry',
      'Veteran Imperial Cavalry',
      'Praetorian Fleet',
      'Praetorian Fleet',
      'Aegyptian Fleet',
      'African Fleet',
      'Babylonian Fleet',
      'Bosporan Fleet',
      'British Fleet',
      'German Fleet',
      'Moesian Fleet',
      'Pannonian Fleet',
      'Pontic Fleet',
      'Syrian Fleet',
      'Veteran Praetorian Fleet',
      'Veteran Praetorian Fleet',
      'Veteran Aegyptian Fleet',
      'Veteran African Fleet',
      'Veteran Babylonian Fleet',
      'Veteran Bosporan Fleet',
      'Veteran British Fleet',
      'Veteran German Fleet',
      'Veteran Moesian Fleet',
      'Veteran Pannonian Fleet',
      'Veteran Pontic Fleet',
      'Veteran Syrian Fleet',
      'Wall',
      'Wall',
      'Wall',
      'Wall',
      'Chrocus',
      'Boudicca',
      'Caratacus',
      'Calgacus',
      'Decebalus',
      'Arminius',
      'Civilis',
      'Kniva',
      'Bato',
      'Simeon',
      'Ballomar',
      'Tacfarinus',
      'Zenobia',
      'Vologases',
      'Shapur',
      '10/1 Alamannic War',
      '12/1 Alamannic War',
      '9/1 Alan War',
      '6/1 British War',
      '7/1 British War',
      '11/1 Burgundian War',
      '4/1 Caledonian War',
      '5/1 Caledonian War',
      '8/1 Cantabrian War',
      '10/1 Dacian War',
      '11/1 Dacian War',
      '11/2 Frankish War',
      '12/1 Dacian War',
      '9/2 Frankish War',
      '8/2 German War',
      '10/2 German War',
      '12/2 German War',
      '14/2 German War',
      '13/3 Gothic War',
      '15/3 Gothic War',
      '10/2 Illyrian War',
      '12/2 Illyrian War',
      '6/2 Judean War',
      '7/2 Judean War',
      '8/2 Judean War',
      '9/1 Marcomannic War',
      '11/1 Marcomannic War',
      '13/1 Marcomannic War',
      '5/1 Moorish War',
      '7/1 Moorish War',
      '4/1 Nubian War',
      '6/1 Nubian War',
      '14/1 Palmyrene War',
      '8/1 Parthian War',
      '10/1 Parthian War',
      '12/1 Parthian War',
      '14/1 Parthian War',
      '15/1 Persian War',
      '9/1 Persian War',
      '11/1 Persian War',
      '13/1 Persian War',
      '8/1 Sarmatian War',
      '10/1 Sarmatian War',
      '6/3 Saxon War',
      '9/1 Vandal War',
      'Aelianus',
      'Aemilian',
      'Agricola',
      'Agrippa',
      'Albinus',
      'Alexander',
      'Antoninus',
      'Arrian',
      'Augustus',
      'Aurelian',
      'Avidius',
      'Caligula',
      'Caracalla',
      'Carausius',
      'Carinus',
      'Carus',
      'Cerialis',
      'Claudius',
      'Commodus',
      'Corbulo',
      'Decius',
      'Diocletian',
      'Domitian',
      'Drusus',
      'Elagabalus',
      'Galba',
      'Gallienus',
      'Gallus',
      'Germanicus',
      'Gordian',
      'Gothicus',
      'Hadrian',
      'Julianus',
      'Laetus',
      'Lucius',
      'Macrinus',
      'Macro',
      'Marcus',
      'Maximian',
      'Maximinus',
      'Nero',
      'Nerva',
      'Niger',
      'Odaenath',
      'Otho',
      'Paulinus',
      'Pertinax',
      'Philip',
      'Plautianus',
      'Plautius',
      'Pompeianus',
      'Postumus',
      'Probus',
      'Quietus',
      'Sejanus',
      'Severus',
      'Silvanus',
      'Tacitus',
      'Tiberius',
      'Timesitheus',
      'Titus',
      'Trajan',
      'Turbo',
      'Valerian',
      'Vespasian',
      'Vitellius',
      'Julian Emperors',
      'Claudian Emperors',
      'Flavian Emperors',
      'Adoptive Emperors',
      'Antonine Emperors',
      'Severan Emperors',
      'Barracks Emperors',
      'Illyrian Emperors',
    ];
    return pieceNames[index];
  }
}

enum Enemy {
  alamanni,
  alans,
  british,
  burgundians,
  caledonians,
  cantabrians,
  dacians,
  franks,
  germans,
  goths,
  illyrians,
  judeans,
  marcomanni,
  moors,
  nubians,
  palmyrenes,
  parthians,
  persians,
  sarmatians,
  saxons,
  vandals,
}

extension EnemyExtension on Enemy {
  String get name {
    const enemyNames = {
      Enemy.alamanni: 'Alamanni',
      Enemy.alans: 'Alans',
      Enemy.british: 'British',
      Enemy.burgundians: 'Burgundians',
      Enemy.caledonians: 'Caledonians',
      Enemy.cantabrians: 'Cantabrians',
      Enemy.dacians: 'Dacians',
      Enemy.franks: 'Franks',
      Enemy.germans: 'Germans',
      Enemy.goths: 'Goths',
      Enemy.illyrians: 'Illyrians',
      Enemy.judeans: 'Judeans',
      Enemy.marcomanni: 'Marcomanni',
      Enemy.moors: 'Moors',
      Enemy.nubians: 'Nubians',
      Enemy.palmyrenes: 'Palmyrenes',
      Enemy.parthians: 'Parthians',
      Enemy.persians: 'Persians',
      Enemy.sarmatians: 'Sarmatians',
      Enemy.saxons: 'Saxons',
      Enemy.vandals: 'Vandals',
    };
    return enemyNames[this]!;
  }

  Location get homeland {
    const enemyHomelands = {
      Enemy.alamanni: Location.homelandAlamannic,
      Enemy.alans: Location.homelandAlan,
      Enemy.british: Location.homelandBritish,
      Enemy.burgundians: Location.homelandBurgundian,
      Enemy.caledonians: Location.homelandCaledonian,
      Enemy.cantabrians: Location.homelandCantabrian,
      Enemy.dacians: Location.homelandDacian,
      Enemy.franks: Location.homelandFrankish,
      Enemy.germans: Location.homelandGerman,
      Enemy.goths: Location.homelandGothic,
      Enemy.illyrians: Location.homelandIllyrian,
      Enemy.judeans: Location.homelandJudean,
      Enemy.marcomanni: Location.homelandMarcomannic,
      Enemy.moors: Location.homelandMoorish,
      Enemy.nubians: Location.homelandNubian,
      Enemy.palmyrenes: Location.homelandPalmyrene,
      Enemy.parthians: Location.homelandParthian,
      Enemy.persians: Location.homelandPersian,
      Enemy.sarmatians: Location.homelandSarmatian,
      Enemy.saxons: Location.homelandSaxon,
      Enemy.vandals: Location.homelandVandal,
    };
    return enemyHomelands[this]!;
  }
}

enum ProvinceStatus {
  barbarian,
  allied,
  veteranAllied,
  insurgent,
  roman,
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
  adoption,
  assassin,
  barbarian,
  bodyguard,
  colony,
  conquest,
  conspiracy,
  deification,
  inflation,
  migration,
  mutiny,
  omens,
  persecution,
  plague,
  praetorians,
  rebellion,
  terror,
  usurper,
}

enum Ability {
  conquest,
  event,
  persecution,
  prefect,
  prestige,
  stalemate,
  terror,
  usurper,
  warAlamannic,
  warAlan,
  warBritish,
  warBurgundian,
  warCaledonian,
  warCantabrian,
  warFrankish,
  warGerman,
  warGothic,
  warIllyrian,
  warJudean,
  warMarcomannic,
  warMoorish,
  warPalmyrene,
  warParthian,
  warPersian,
  warSarmatian,
  warSaxon,
}

extension AbilityExtension on Ability {
  Enemy? get warEnemy {
    const enemies = {
      Ability.warAlamannic: Enemy.alamanni,
      Ability.warAlan: Enemy.alans,
      Ability.warBritish: Enemy.british,
      Ability.warBurgundian: Enemy.burgundians,
      Ability.warCaledonian: Enemy.caledonians,
      Ability.warCantabrian: Enemy.cantabrians,
      Ability.warFrankish: Enemy.franks,
      Ability.warGerman: Enemy.germans,
      Ability.warGothic: Enemy.goths,
      Ability.warIllyrian: Enemy.illyrians,
      Ability.warJudean: Enemy.judeans,
      Ability.warMarcomannic: Enemy.marcomanni,
      Ability.warMoorish: Enemy.moors,
      Ability.warPalmyrene: Enemy.palmyrenes,
      Ability.warParthian: Enemy.parthians,
      Ability.warPersian: Enemy.persians,
      Ability.warSarmatian: Enemy.sarmatians,
      Ability.warSaxon: Enemy.saxons,
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
  from27BceTo70Ce,
  from70CeTo138Ce,
  from138CeTo222Ce,
  from222CeTo286Ce,
  from27BceTo138Ce,
  from70CeTo222Ce,
  from138CeTo286Ce,
  from27BceTo222Ce,
  from70CeTo286Ce,
  from27BceTo286Ce,
}

extension ScenarioExtension on Scenario {
  String get desc {
    const scenarioDescs = {
      Scenario.from27BceTo70Ce: '27 BCE – 70 CE',
      Scenario.from70CeTo138Ce: '70 CE – 138 CE',
      Scenario.from138CeTo222Ce: '138 CE – 222 CE',
      Scenario.from222CeTo286Ce: '222 CE – 286 CE',
      Scenario.from27BceTo138Ce: '27 BCE – 138 CE',
      Scenario.from70CeTo222Ce: '70 CE – 222 CE',
      Scenario.from138CeTo286Ce: '138 CE – 286 CE',
      Scenario.from27BceTo222Ce: '27 BCE – 222 CE',
      Scenario.from70CeTo286Ce: '70 CE – 286 CE',
      Scenario.from27BceTo286Ce: '27 BCE – 286 CE',
    };
    return scenarioDescs[this]!;
  }

  String get longDesc {
    const scenarioDescs = {
      Scenario.from27BceTo70Ce: '27 BCE to 70 CE (10 Turns)',
      Scenario.from70CeTo138Ce: '70 CE to 138 CE (10 Turns)',
      Scenario.from138CeTo222Ce: '138 CE to 222 CE (10 Turns)',
      Scenario.from222CeTo286Ce: '222 CE to 286 CE (10 Turns)',
      Scenario.from27BceTo138Ce: '27 BCE to 138 CE (20 Turns)',
      Scenario.from70CeTo222Ce: '70 CE to 222 CE (20 Turns)',
      Scenario.from138CeTo286Ce: '138 CE to 286 CE (20 Turns)',
      Scenario.from27BceTo222Ce: '27 BCE to 222 CE (30 Turns)',
      Scenario.from70CeTo286Ce: '70 CE to 286 CE (30 Turns)',
      Scenario.from27BceTo286Ce: '27 BCE to 286 CE (40 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

const warData = {
  Piece.warAlamannic10: (Enemy.alamanni, 10, 1),
  Piece.warAlamannic12: (Enemy.alamanni, 12, 1),
  Piece.warAlan9: (Enemy.alans, 9, 1),
  Piece.warBritish6: (Enemy.british, 6, 1),
  Piece.warBritish7: (Enemy.british, 7, 1),
  Piece.warBurgundian11: (Enemy.burgundians, 11, 1),
  Piece.warCaledonian4: (Enemy.caledonians, 4, 1),
  Piece.warCaledonian5: (Enemy.caledonians, 5, 1),
  Piece.warCantabrian8: (Enemy.cantabrians, 8, 1),
  Piece.warDacian10: (Enemy.dacians, 10, 1),
  Piece.warDacian11: (Enemy.dacians, 11, 1),
  Piece.warDacian12: (Enemy.dacians, 12, 1),
  Piece.warFrankish9: (Enemy.franks, 9, 2),
  Piece.warFrankish11: (Enemy.franks, 11, 2),
  Piece.warGerman8: (Enemy.germans, 8, 2),
  Piece.warGerman10: (Enemy.germans, 10, 2),
  Piece.warGerman12: (Enemy.germans, 12, 2),
  Piece.warGerman14: (Enemy.germans, 14, 2),
  Piece.warGothic13: (Enemy.goths, 13, 3),
  Piece.warGothic15: (Enemy.goths, 15, 3),
  Piece.warIllyrian10: (Enemy.illyrians, 10, 2),
  Piece.warIllyrian12: (Enemy.illyrians, 12, 2),
  Piece.warJudean6: (Enemy.judeans, 6, 2),
  Piece.warJudean7: (Enemy.judeans, 7, 2),
  Piece.warJudean8: (Enemy.judeans, 8, 2),
  Piece.warMarcomannic9: (Enemy.marcomanni, 9, 1),
  Piece.warMarcomannic11: (Enemy.marcomanni, 11, 1),
  Piece.warMarcomannic13: (Enemy.marcomanni, 13, 1),
  Piece.warMoorish5: (Enemy.moors, 5, 1),
  Piece.warMoorish7: (Enemy.moors, 7, 1),
  Piece.warNubian4: (Enemy.nubians, 4, 1),
  Piece.warNubian6: (Enemy.nubians, 6, 1),
  Piece.warPalmyrene14: (Enemy.palmyrenes, 14, 1),
  Piece.warParthian8: (Enemy.parthians, 8, 1),
  Piece.warParthian10: (Enemy.parthians, 10, 1),
  Piece.warParthian12: (Enemy.parthians, 12, 1),
  Piece.warParthian14: (Enemy.parthians, 14, 1),
  Piece.warPersian9: (Enemy.persians, 9, 1),
  Piece.warPersian11: (Enemy.persians, 11, 1),
  Piece.warPersian13: (Enemy.persians, 13, 1),
  Piece.warPersian15: (Enemy.persians, 15, 1),
  Piece.warSarmatian8: (Enemy.sarmatians, 8, 1),
  Piece.warSarmatian10: (Enemy.sarmatians, 10, 1),
  Piece.warSaxon6: (Enemy.saxons, 6, 3),
  Piece.warVandal9: (Enemy.vandals, 9, 1),
};

const leaderData = {
  Piece.leaderChrocus: (Enemy.alamanni, 3, 4),
  Piece.leaderBoudicca: (Enemy.british, 2, 2),
  Piece.leaderCaratacus: (Enemy.british, 3, 1),
  Piece.leaderCalgacus: (Enemy.caledonians, 3, 1),
  Piece.leaderDecebalus: (Enemy.dacians, 5, 2),
  Piece.leaderArminius: (Enemy.germans, 5, 2),
  Piece.leaderCivilis: (Enemy.germans, 4, 1),
  Piece.leaderKniva: (Enemy.goths, 5, 4),
  Piece.leaderBato: (Enemy.illyrians, 3, 3),
  Piece.leaderSimeon: (Enemy.judeans, 3, 2),
  Piece.leaderBallomar: (Enemy.marcomanni, 4, 3),
  Piece.leaderTacfarinus: (Enemy.moors, 3, 2),
  Piece.leaderZenobia: (Enemy.palmyrenes, 2, 5),
  Piece.leaderVologases: (Enemy.parthians, 4, 2),
  Piece.leaderShapur: (Enemy.persians, 5, 2),
};

const statesmanData = {
  Piece.statesmanAelianus: (Ability.prefect, 2, 2, 3, 4, false),
  Piece.statesmanAemilian: (Ability.event, 3, 2, 2, 3, false),
  Piece.statesmanAgricola: (Ability.warCaledonian, 4, 4, 4, 2, false),
  Piece.statesmanAgrippa: (Ability.warCantabrian, 4, 4, 4, 3, false),
  Piece.statesmanAlbinus: (Ability.event, 3, 3, 3, 2, false),
  Piece.statesmanAlexander: (Ability.prestige, 2, 3, 2, 1, true),
  Piece.statesmanAntoninus: (Ability.prestige, 1, 4, 3, 1, true),
  Piece.statesmanArrian: (Ability.warAlan, 3, 4, 3, 2, false),
  Piece.statesmanAugustus: (Ability.conquest, 2, 5, 4, 3, true),
  Piece.statesmanAurelian: (Ability.warPalmyrene, 5, 4, 2, 4, false),
  Piece.statesmanAvidius: (Ability.warParthian, 4, 3, 2, 3, false),
  Piece.statesmanCaligula: (Ability.terror, 1, 1, 4, 5, true),
  Piece.statesmanCaracalla: (Ability.terror, 3, 4, 4, 5, true),
  Piece.statesmanCarausius: (Ability.warFrankish, 4, 2, 3, 3, false),
  Piece.statesmanCarinus: (Ability.warSaxon, 3, 2, 3, 4, true),
  Piece.statesmanCarus: (Ability.warPersian, 3, 3, 3, 3, true),
  Piece.statesmanCerialis: (Ability.warGerman, 3, 3, 4, 2, false),
  Piece.statesmanClaudius: (Ability.conquest, 1, 3, 4, 4, true),
  Piece.statesmanCommodus: (Ability.terror, 2, 1, 4, 5, true),
  Piece.statesmanCorbulo: (Ability.warParthian, 4, 3, 1, 3, false),
  Piece.statesmanDecius: (Ability.persecution, 2, 4, 3, 3, false),
  Piece.statesmanDiocletian: (Ability.persecution, 2, 5, 4, 3, false),
  Piece.statesmanDomitian: (Ability.terror, 2, 4, 5, 5, true),
  Piece.statesmanDrusus: (Ability.warGerman, 4, 4, 4, 2, true),
  Piece.statesmanElagabalus: (Ability.event, 1, 1, 1, 4, true),
  Piece.statesmanGalba: (Ability.stalemate, 3, 3, 1, 4, false),
  Piece.statesmanGallienus: (Ability.usurper, 4, 2, 1, 4, true),
  Piece.statesmanGallus: (Ability.stalemate, 3, 3, 2, 3, false),
  Piece.statesmanGermanicus: (Ability.warGerman, 3, 4, 5, 2, true),
  Piece.statesmanGordian: (Ability.prestige, 1, 3, 2, 1, true),
  Piece.statesmanGothicus: (Ability.warGothic, 4, 3, 4, 3, false),
  Piece.statesmanHadrian: (Ability.stalemate, 3, 5, 4, 4, true),
  Piece.statesmanJulianus: (Ability.warGerman, 3, 3, 2, 2, false),
  Piece.statesmanLaetus: (Ability.prefect, 2, 3, 2, 4, false),
  Piece.statesmanLucius: (Ability.prestige, 2, 2, 3, 2, true),
  Piece.statesmanMacrinus: (Ability.prefect, 2, 4, 2, 4, false),
  Piece.statesmanMacro: (Ability.prefect, 2, 2, 2, 4, false),
  Piece.statesmanMarcus: (Ability.warSarmatian, 3, 5, 3, 1, true),
  Piece.statesmanMaximian: (Ability.warMoorish, 3, 3, 3, 4, false),
  Piece.statesmanMaximinus: (Ability.warAlamannic, 4, 1, 4, 4, false),
  Piece.statesmanNero: (Ability.usurper, 1, 2, 4, 5, true),
  Piece.statesmanNerva: (Ability.prestige, 1, 3, 2, 3, true),
  Piece.statesmanNiger: (Ability.event, 3, 3, 4, 3, false),
  Piece.statesmanOdaenath: (Ability.warPersian, 4, 2, 4, 3, false),
  Piece.statesmanOtho: (Ability.event, 1, 2, 3, 4, false),
  Piece.statesmanPaulinus: (Ability.warMoorish, 4, 2, 3, 3, false),
  Piece.statesmanPertinax: (Ability.stalemate, 3, 3, 1, 2, false),
  Piece.statesmanPhilip: (Ability.prefect, 3, 3, 2, 4, false),
  Piece.statesmanPlautianus: (Ability.prefect, 2, 3, 3, 3, false),
  Piece.statesmanPlautius: (Ability.warBritish, 4, 2, 2, 3, false),
  Piece.statesmanPompeianus: (Ability.warMarcomannic, 4, 3, 3, 2, false),
  Piece.statesmanPostumus: (Ability.warFrankish, 3, 2, 3, 3, false),
  Piece.statesmanProbus: (Ability.warBurgundian, 4, 3, 2, 2, false),
  Piece.statesmanQuietus: (Ability.warJudean, 3, 3, 3, 4, false),
  Piece.statesmanSejanus: (Ability.prefect, 2, 3, 3, 4, false),
  Piece.statesmanSeverus: (Ability.warParthian, 4, 4, 5, 4, true),
  Piece.statesmanSilvanus: (Ability.warSarmatian, 4, 3, 3, 3, false),
  Piece.statesmanTacitus: (Ability.prestige, 3, 3, 3, 1, false),
  Piece.statesmanTiberius: (Ability.warIllyrian, 4, 3, 2, 4, true),
  Piece.statesmanTimesitheus: (Ability.warPersian, 4, 4, 3, 2, false),
  Piece.statesmanTitus: (Ability.warJudean, 4, 4, 4, 4, true),
  Piece.statesmanTrajan: (Ability.conquest, 5, 5, 5, 2, true),
  Piece.statesmanTurbo: (Ability.warMoorish, 4, 4, 3, 3, false),
  Piece.statesmanValerian: (Ability.persecution, 2, 3, 2, 3, true),
  Piece.statesmanVespasian: (Ability.warJudean, 3, 4, 3, 3, true),
  Piece.statesmanVitellius: (Ability.prestige, 2, 3, 3, 4, false),
};

const commandData = {
  Location.commandCaesar: (2, 2, 2, 2),
  Location.commandConsul: (1, 1, 1, 1),
  Location.commandPrefect: (1, 2, 3, 2),
  Location.commandBritannia: (2, 1, 3, 2),
  Location.commandGallia: (3, 2, 2, 1),
  Location.commandPannonia: (3, 1, 2, 2),
  Location.commandMoesia: (2, 1, 2, 3),
  Location.commandHispania: (1, 2, 2, 3),
  Location.commandAfrica: (2, 2, 1, 3),
  Location.commandAegyptus: (1, 3, 2, 2),
  Location.commandSyria: (2, 2, 3, 1),
  Location.commandPontica: (2, 3, 1, 2),
};

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.offmap);
	List<Location> _governorshipLoyalties = List<Location>.filled(LocationType.governorship.count, Location.commandCaesar);
	List<bool> _governorshipLoyaltiesChecked = List<bool>.filled(LocationType.governorship.count, false);
	List<ProvinceStatus> _provinceStatuses = List<ProvinceStatus>.filled(LocationType.province.count, ProvinceStatus.roman);
  List<int> _eventTypeCounts = List<int>.filled(EventType.values.length, 0);
	List<int?> _leaderAges = List<int?>.filled(PieceType.leader.count, null);
	List<int?> _statesmanAges = List<int?>.filled(PieceType.statesman.count, null);
	List<int?> _commanderAges = List<int?>.filled(LocationType.command.count, null);
  List<Piece> _resurrectedBarbarians = <Piece>[];
  int _turn = 0;
  int _gold = 0;
  int _prestige = 0;
  int _unrest = 0;
  bool caesarDeified = false;

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
    : _turn = json['turn'] as int,
      _gold = json['gold'] as int,
      _prestige = json['prestige'] as int,
      _unrest = json['unrest'] as int,
      caesarDeified = json['caesarDeified'] as bool,
      _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations'])),
      _governorshipLoyalties = locationListFromIndices(List<int>.from(json['governorshipLoyalties'])),
      _governorshipLoyaltiesChecked = List<bool>.from(json['governorshipLoyaltiesChecked']),
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
    'caesarDeified': caesarDeified,
    'pieceLocations': locationListToIndices(_pieceLocations),
    'governorshipLoyalties': locationListToIndices(_governorshipLoyalties),
    'governorshipLoyaltiesChecked': _governorshipLoyaltiesChecked,
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
      ProvinceStatus.allied: 'Allied',
      ProvinceStatus.veteranAllied: 'Veteran Allied',
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

  bool spaceAlliedOrBetter(Location space) {
    if (!space.isType(LocationType.province)) {
      return false;
    }
    switch (provinceStatus(space)) {
    case ProvinceStatus.barbarian:
      return false;
    case ProvinceStatus.allied:
    case ProvinceStatus.veteranAllied:
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
    case ProvinceStatus.allied:
    case ProvinceStatus.veteranAllied:
      return false;
    case ProvinceStatus.insurgent:
    case ProvinceStatus.roman:
      return true;
    }
  }

  bool spaceCanBeAnnexed(Location space) {
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
    if (!spaceHasConnectionToNonBarbarianProvince(space)) {
      return false;
    }
    return true;
  }

  int provinceRevenue(Location province) {
    const provinceRevenues = {
      Location.provinceAlpes: 2,
      Location.provinceCorsicaSardinia: 3,
      Location.provinceMediolanum: 4,
      Location.provinceNeapolis: 4,
      Location.provincePisae: 4,
      Location.provinceRavenna: 4,
      Location.provinceRome: 5,
      Location.provinceSicilia: 4,
      Location.provinceBritanniaInferior: 3,
      Location.provinceBritanniaSuperior: 4,
      Location.provinceCaledonia: 1,
      Location.provinceHibernia: 1,
      Location.provinceAgriDecumates: 1,
      Location.provinceAquitania: 3,
      Location.provinceBelgica: 3,
      Location.provinceFrisia: 1,
      Location.provinceGermaniaInferior: 2,
      Location.provinceGermaniaMagna: 1,
      Location.provinceGermaniaSuperior: 2,
      Location.provinceLugdunensis: 3,
      Location.provinceNarbonensis: 4,
      Location.provinceRhaetia: 2,
      Location.provinceBoiohaemia: 1,
      Location.provinceIllyria: 4,
      Location.provinceNoricum: 3,
      Location.provincePannoniaInferior: 2,
      Location.provincePannoniaSuperior: 2,
      Location.provinceQuadia: 1,
      Location.provinceSarmatia: 1,
      Location.provinceAchaea: 5,
      Location.provinceBosporus: 3,
      Location.provinceDaciaInferior: 2,
      Location.provinceDaciaSuperior: 2,
      Location.provinceEpirus: 3,
      Location.provinceMacedonia: 4,
      Location.provinceMoesiaInferior: 2,
      Location.provinceMoesiaSuperior: 2,
      Location.provinceScythia: 1,
      Location.provinceThracia: 3,
      Location.provinceBaetica: 5,
      Location.provinceBaleares: 2,
      Location.provinceCarthaginensis: 4,
      Location.provinceGallaecia: 3,
      Location.provinceLusitania: 3,
      Location.provinceTarraconensis: 3,
      Location.provinceAfrica: 5,
      Location.provinceLibya: 3,
      Location.provinceMauretaniaCaesariensis: 3,
      Location.provinceMauretaniaTingitana: 2,
      Location.provinceNumidia: 4,
      Location.provinceAethiopia: 2,
      Location.provinceAlexandria: 5,
      Location.provinceArcadia: 4,
      Location.provinceCreta: 2,
      Location.provinceCyrenaica: 3,
      Location.provinceThebais: 4,
      Location.provinceArabia: 3,
      Location.provinceAssyria: 4,
      Location.provinceBabylonia: 4,
      Location.provinceCilicia: 3,
      Location.provinceCommagene: 2,
      Location.provinceCyprus: 3,
      Location.provinceJudea: 3,
      Location.provinceMesopotamia: 3,
      Location.provinceOsrhoene: 3,
      Location.provincePalmyra: 3,
      Location.provincePhoenicia: 3,
      Location.provinceSyria: 4,
      Location.provinceAlbania: 2,
      Location.provinceArmeniaMajor: 4,
      Location.provinceArmeniaMinor: 2,
      Location.provinceAsia: 5,
      Location.provinceBithynia: 4,
      Location.provinceCappadocia: 3,
      Location.provinceCaucasia: 1,
      Location.provinceColchis: 2,
      Location.provinceGalatia: 2,
      Location.provinceIberia: 2,
      Location.provinceLyciaPamphylia: 3,
      Location.provincePontus: 3,
      Location.provinceRhodus: 3,
    };
    return provinceRevenues[province]!;
  }

  int provincePraetorianIcons(province) {
    if (province != Location.provinceRome) {
      return 0;
    }
    int count = 0;
    for (final emperors in [Piece.emperorsJulian, Piece.emperorsClaudian]) {
      if (emperorsActive(emperors)) {
        count += 1;
      }
    }
    return count;
  }

  int provinceLegionaryIcons(province) {
    switch (province) {
    case Location.provinceBritanniaInferior:
    case Location.provinceBritanniaSuperior:
    case Location.provinceCaledonia:
    case Location.provinceHibernia:
    case Location.provinceAgriDecumates:
    case Location.provinceFrisia:
    case Location.provinceGermaniaInferior:
    case Location.provinceGermaniaMagna:
    case Location.provinceGermaniaSuperior:
    case Location.provinceBoiohaemia:
    case Location.provincePannoniaInferior:
    case Location.provincePannoniaSuperior:
    case Location.provinceQuadia:
    case Location.provinceSarmatia:
    case Location.provinceBosporus:
    case Location.provinceDaciaInferior:
    case Location.provinceDaciaSuperior:
    case Location.provinceMoesiaInferior:
    case Location.provinceMoesiaSuperior:
    case Location.provinceScythia:
    case Location.provinceGallaecia:
    case Location.provinceNumidia:
    case Location.provinceAethiopia:
    case Location.provinceAlexandria:
    case Location.provinceArabia:
    case Location.provinceAssyria:
    case Location.provinceBabylonia:
    case Location.provinceCommagene:
    case Location.provinceJudea:
    case Location.provinceMesopotamia:
    case Location.provinceOsrhoene:
    case Location.provincePalmyra:
    case Location.provincePhoenicia:
    case Location.provinceSyria:
    case Location.provinceAlbania:
    case Location.provinceArmeniaMajor:
    case Location.provinceArmeniaMinor:
    case Location.provinceCappadocia:
    case Location.provinceCaucasia:
    case Location.provinceColchis:
    case Location.provinceIberia:
      return 1;
    case Location.provinceRhaetia:
    case Location.provinceNoricum:
      return emperorsActive(Piece.emperorsAntonine) ? 1 : 0;
    default:
      return 0;
    }
  }

  int provinceFleetIcons(Location province) {
    switch (province) {
    case Location.provinceNeapolis:
    case Location.provinceRavenna:
    case Location.provinceBritanniaSuperior:
    case Location.provinceGermaniaInferior:
    case Location.provincePannoniaInferior:
    case Location.provinceBosporus:
    case Location.provinceMoesiaInferior:
    case Location.provinceAlexandria:
    case Location.provinceBabylonia:
    case Location.provinceArmeniaMinor:
      return 1;
    case Location.provinceAfrica:
      return emperorsActive(Piece.emperorsAntonine) ? 1 : 0;
    case Location.provinceSyria:
      return emperorsActive(Piece.emperorsFlavian) ? 1 : 0;
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

  bool provinceLandlocked(Location province) {
    const landlockedProvinces = [
      Location.provinceAlbania,
      Location.provinceArmeniaMajor,
      Location.provinceCappadocia,
      Location.provinceGalatia,
      Location.provinceIberia,
    ];
    return landlockedProvinces.contains(province);

  }

  bool provinceOnEuphrates(Location province) {
    const euphratesProvinces = [
      Location.provinceAssyria,
      Location.provinceBabylonia,
      Location.provinceCommagene,
      Location.provinceMesopotamia,
      Location.provinceOsrhoene,
      Location.provincePalmyra,
    ];
    return euphratesProvinces.contains(province);
  }

  List<(Location, ConnectionType)> spaceConnections(Location space) {
    const connections = {
      Location.provinceAlpes: [
        (Location.provinceMediolanum,ConnectionType.mountain),
        (Location.provinceGermaniaSuperior,ConnectionType.mountain),
        (Location.provinceNarbonensis,ConnectionType.mountain)],
      Location.provinceCorsicaSardinia: [
        (Location.provinceMediolanum,ConnectionType.sea),
        (Location.provincePisae,ConnectionType.sea),
        (Location.provinceRome,ConnectionType.sea),
        (Location.provinceNarbonensis,ConnectionType.sea),
        (Location.provinceBaleares,ConnectionType.sea),
        (Location.provinceAfrica,ConnectionType.sea)],
      Location.provinceMediolanum: [
        (Location.provinceAlpes,ConnectionType.mountain),
        (Location.provinceCorsicaSardinia,ConnectionType.sea),
        (Location.provincePisae,ConnectionType.road),
        (Location.provinceRhaetia,ConnectionType.mountain)],
      Location.provinceNeapolis: [
        (Location.provinceRome,ConnectionType.road),
        (Location.provinceSicilia,ConnectionType.river),
        (Location.provinceIllyria,ConnectionType.sea),
        (Location.provinceEpirus,ConnectionType.river)],
      Location.provincePisae: [
        (Location.provinceCorsicaSardinia,ConnectionType.sea),
        (Location.provinceMediolanum,ConnectionType.road),
        (Location.provinceRavenna,ConnectionType.road),
        (Location.provinceRome,ConnectionType.road)],
      Location.provinceRavenna: [
        (Location.provincePisae,ConnectionType.road),
        (Location.provinceRome,ConnectionType.road),
        (Location.provinceRhaetia,ConnectionType.mountain),
        (Location.provinceIllyria,ConnectionType.river),
        (Location.provinceNoricum,ConnectionType.road)],
      Location.provinceRome: [
        (Location.provinceCorsicaSardinia,ConnectionType.sea),
        (Location.provinceNeapolis,ConnectionType.road),
        (Location.provincePisae,ConnectionType.road),
        (Location.provinceRavenna,ConnectionType.road)],
      Location.provinceSicilia: [
        (Location.provinceNeapolis,ConnectionType.river),
        (Location.provinceAchaea,ConnectionType.sea),
        (Location.provinceAfrica,ConnectionType.sea)],
      Location.provinceBritanniaInferior: [
        (Location.provinceBritanniaSuperior,ConnectionType.road),
        (Location.provinceCaledonia,ConnectionType.road),
        (Location.provinceHibernia,ConnectionType.sea),
        (Location.homelandBritish,ConnectionType.mountain)],
      Location.provinceBritanniaSuperior: [
        (Location.provinceBritanniaInferior,ConnectionType.road),
        (Location.homelandBritish,ConnectionType.river),
        (Location.provinceBelgica,ConnectionType.river),
        (Location.provinceFrisia,ConnectionType.sea),
        (Location.provinceGermaniaInferior,ConnectionType.river),
        (Location.provinceLugdunensis,ConnectionType.sea)],
      Location.provinceCaledonia: [
        (Location.provinceBritanniaInferior,ConnectionType.road),
        (Location.provinceHibernia,ConnectionType.river),
        (Location.homelandCaledonian,ConnectionType.mountain)],
      Location.provinceHibernia: [
        (Location.provinceBritanniaInferior,ConnectionType.sea),
        (Location.provinceCaledonia,ConnectionType.river),
        (Location.homelandBritish,ConnectionType.river),
        (Location.homelandCaledonian,ConnectionType.sea)],
      Location.provinceAgriDecumates: [
        (Location.provinceGermaniaMagna,ConnectionType.mountain),
        (Location.provinceGermaniaSuperior,ConnectionType.river),
        (Location.provinceRhaetia,ConnectionType.river),
        (Location.provinceBoiohaemia,ConnectionType.mountain),
        (Location.homelandAlamannic,ConnectionType.mountain)],
      Location.provinceAquitania: [
        (Location.provinceLugdunensis,ConnectionType.road),
        (Location.provinceNarbonensis,ConnectionType.road),
        (Location.provinceGallaecia,ConnectionType.mountain)],
      Location.provinceBelgica: [
        (Location.provinceBritanniaSuperior,ConnectionType.river),
        (Location.provinceGermaniaInferior,ConnectionType.road),
        (Location.provinceGermaniaSuperior,ConnectionType.road),
        (Location.provinceLugdunensis,ConnectionType.road)],
      Location.provinceFrisia: [
        (Location.provinceBritanniaSuperior,ConnectionType.sea),
        (Location.provinceGermaniaInferior,ConnectionType.river),
        (Location.homelandGerman,ConnectionType.river)],
      Location.provinceGermaniaInferior: [
        (Location.provinceBritanniaSuperior,ConnectionType.river),
        (Location.provinceBelgica,ConnectionType.road),
        (Location.provinceFrisia,ConnectionType.river),
        (Location.provinceGermaniaMagna,ConnectionType.river),
        (Location.provinceGermaniaSuperior,ConnectionType.road)],
      Location.provinceGermaniaMagna: [
        (Location.provinceAgriDecumates,ConnectionType.mountain),
        (Location.provinceGermaniaInferior,ConnectionType.river),
        (Location.provinceGermaniaSuperior,ConnectionType.river),
        (Location.homelandFrankish,ConnectionType.river),
        (Location.homelandGerman,ConnectionType.road)],
      Location.provinceGermaniaSuperior: [
        (Location.provinceAlpes,ConnectionType.mountain),
        (Location.provinceAgriDecumates,ConnectionType.river),
        (Location.provinceBelgica,ConnectionType.road),
        (Location.provinceGermaniaInferior,ConnectionType.road),
        (Location.provinceGermaniaMagna,ConnectionType.river),
        (Location.provinceLugdunensis,ConnectionType.road),
        (Location.provinceRhaetia,ConnectionType.mountain)],
      Location.provinceLugdunensis: [
        (Location.provinceBritanniaSuperior,ConnectionType.sea),
        (Location.provinceAquitania,ConnectionType.road),
        (Location.provinceBelgica,ConnectionType.road),
        (Location.provinceGermaniaSuperior,ConnectionType.road),
        (Location.provinceNarbonensis,ConnectionType.road)],
      Location.provinceNarbonensis: [
        (Location.provinceAlpes,ConnectionType.mountain),
        (Location.provinceCorsicaSardinia,ConnectionType.sea),
        (Location.provinceAquitania,ConnectionType.road),
        (Location.provinceLugdunensis,ConnectionType.road),
        (Location.provinceBaleares,ConnectionType.sea),
        (Location.provinceTarraconensis,ConnectionType.mountain)],
      Location.provinceRhaetia: [
        (Location.provinceMediolanum,ConnectionType.mountain),
        (Location.provinceRavenna,ConnectionType.mountain),
        (Location.provinceAgriDecumates,ConnectionType.river),
        (Location.provinceGermaniaSuperior,ConnectionType.mountain),
        (Location.provinceBoiohaemia,ConnectionType.river),
        (Location.provinceNoricum,ConnectionType.mountain)],
      Location.provinceBoiohaemia: [
        (Location.provinceAgriDecumates,ConnectionType.mountain),
        (Location.provinceRhaetia,ConnectionType.river),
        (Location.provinceNoricum,ConnectionType.river),
        (Location.provincePannoniaSuperior,ConnectionType.river),
        (Location.provinceQuadia,ConnectionType.mountain),
        (Location.homelandAlamannic,ConnectionType.mountain),
        (Location.homelandMarcomannic,ConnectionType.mountain)],
      Location.provinceIllyria: [
        (Location.provinceNeapolis,ConnectionType.sea),
        (Location.provinceRavenna,ConnectionType.river),
        (Location.provincePannoniaInferior,ConnectionType.road),
        (Location.provincePannoniaSuperior,ConnectionType.road),
        (Location.provinceEpirus,ConnectionType.mountain),
        (Location.provinceMacedonia,ConnectionType.mountain),
        (Location.provinceMoesiaSuperior,ConnectionType.mountain)],
      Location.provinceNoricum: [
        (Location.provinceRavenna,ConnectionType.road),
        (Location.provinceRhaetia,ConnectionType.mountain),
        (Location.provinceBoiohaemia,ConnectionType.river),
        (Location.provincePannoniaSuperior,ConnectionType.road)],
      Location.provincePannoniaInferior: [
        (Location.provinceIllyria,ConnectionType.road),
        (Location.provincePannoniaSuperior,ConnectionType.road),
        (Location.provinceQuadia,ConnectionType.river),
        (Location.provinceSarmatia,ConnectionType.river),
        (Location.provinceMoesiaSuperior,ConnectionType.road)],
      Location.provincePannoniaSuperior: [
        (Location.provinceBoiohaemia,ConnectionType.river),
        (Location.provinceIllyria,ConnectionType.road),
        (Location.provinceNoricum,ConnectionType.road),
        (Location.provincePannoniaInferior,ConnectionType.road),
        (Location.provinceQuadia,ConnectionType.river)],
      Location.provinceQuadia: [
        (Location.provinceBoiohaemia,ConnectionType.mountain),
        (Location.provincePannoniaInferior,ConnectionType.river),
        (Location.provincePannoniaSuperior,ConnectionType.river),
        (Location.provinceSarmatia,ConnectionType.mountain),
        (Location.homelandIllyrian,ConnectionType.mountain),
        (Location.homelandMarcomannic,ConnectionType.mountain)],
      Location.provinceSarmatia: [
        (Location.provincePannoniaInferior,ConnectionType.river),
        (Location.provinceQuadia,ConnectionType.mountain),
        (Location.provinceDaciaSuperior,ConnectionType.mountain),
        (Location.provinceMoesiaSuperior,ConnectionType.river),
        (Location.homelandIllyrian,ConnectionType.mountain),
        (Location.homelandSarmatian,ConnectionType.mountain)],
      Location.provinceAchaea: [
        (Location.provinceSicilia,ConnectionType.sea),
        (Location.provinceEpirus,ConnectionType.river),
        (Location.provinceMacedonia,ConnectionType.mountain),
        (Location.provinceCreta,ConnectionType.sea),
        (Location.provinceAsia,ConnectionType.sea),
        (Location.provinceRhodus,ConnectionType.sea)],
      Location.provinceBosporus: [
        (Location.provinceMoesiaInferior,ConnectionType.sea),
        (Location.provinceScythia,ConnectionType.river),
        (Location.provinceArmeniaMinor,ConnectionType.sea),
        (Location.provinceBithynia,ConnectionType.sea),
        (Location.provinceCaucasia,ConnectionType.river),
        (Location.provincePontus,ConnectionType.sea),
        (Location.homelandGothic,ConnectionType.river)],
      Location.provinceDaciaInferior: [
        (Location.provinceDaciaSuperior,ConnectionType.mountain),
        (Location.provinceMoesiaInferior,ConnectionType.river),
        (Location.provinceMoesiaSuperior,ConnectionType.river),
        (Location.provinceScythia,ConnectionType.road)],
      Location.provinceDaciaSuperior: [
        (Location.provinceSarmatia,ConnectionType.mountain),
        (Location.provinceDaciaInferior,ConnectionType.mountain),
        (Location.provinceScythia,ConnectionType.mountain),
        (Location.homelandDacian,ConnectionType.mountain),
        (Location.homelandSarmatian,ConnectionType.mountain)],
      Location.provinceEpirus: [
        (Location.provinceNeapolis,ConnectionType.river),
        (Location.provinceIllyria,ConnectionType.mountain),
        (Location.provinceAchaea,ConnectionType.river),
        (Location.provinceMacedonia,ConnectionType.mountain)],
      Location.provinceMacedonia: [
        (Location.provinceIllyria,ConnectionType.mountain),
        (Location.provinceAchaea,ConnectionType.mountain),
        (Location.provinceEpirus,ConnectionType.mountain),
        (Location.provinceMoesiaSuperior,ConnectionType.mountain),
        (Location.provinceThracia,ConnectionType.road)],
      Location.provinceMoesiaInferior: [
        (Location.provinceBosporus,ConnectionType.sea),
        (Location.provinceDaciaInferior,ConnectionType.river),
        (Location.provinceMoesiaSuperior,ConnectionType.road),
        (Location.provinceScythia,ConnectionType.river),
        (Location.provinceThracia,ConnectionType.road)],
      Location.provinceMoesiaSuperior: [
        (Location.provinceIllyria,ConnectionType.mountain),
        (Location.provincePannoniaInferior,ConnectionType.road),
        (Location.provinceSarmatia,ConnectionType.river),
        (Location.provinceDaciaInferior,ConnectionType.river),
        (Location.provinceMacedonia,ConnectionType.mountain),
        (Location.provinceMoesiaInferior,ConnectionType.road)],
      Location.provinceScythia: [
        (Location.provinceBosporus,ConnectionType.river),
        (Location.provinceDaciaInferior,ConnectionType.road),
        (Location.provinceDaciaSuperior,ConnectionType.mountain),
        (Location.provinceMoesiaInferior,ConnectionType.river),
        (Location.homelandDacian,ConnectionType.mountain),
        (Location.homelandGothic,ConnectionType.river)],
      Location.provinceThracia: [
        (Location.provinceMacedonia,ConnectionType.road),
        (Location.provinceMoesiaInferior,ConnectionType.road),
        (Location.provinceAsia,ConnectionType.river),
        (Location.provinceBithynia,ConnectionType.river)],
      Location.provinceBaetica: [
        (Location.provinceCarthaginensis,ConnectionType.road),
        (Location.provinceLusitania,ConnectionType.road),
        (Location.provinceMauretaniaTingitana,ConnectionType.river)],
      Location.provinceBaleares: [
        (Location.provinceCorsicaSardinia,ConnectionType.sea),
        (Location.provinceNarbonensis,ConnectionType.sea),
        (Location.provinceCarthaginensis,ConnectionType.sea),
        (Location.provinceTarraconensis,ConnectionType.sea),
        (Location.provinceNumidia,ConnectionType.sea)],
      Location.provinceCarthaginensis: [
        (Location.provinceBaetica,ConnectionType.road),
        (Location.provinceBaleares,ConnectionType.sea),
        (Location.provinceTarraconensis,ConnectionType.road),
        (Location.provinceMauretaniaCaesariensis,ConnectionType.sea)],
      Location.provinceGallaecia: [
        (Location.provinceAquitania,ConnectionType.mountain),
        (Location.provinceLusitania,ConnectionType.road),
        (Location.provinceTarraconensis,ConnectionType.road),
        (Location.homelandCantabrian,ConnectionType.mountain)],
      Location.provinceLusitania: [
        (Location.provinceBaetica,ConnectionType.road),
        (Location.provinceGallaecia,ConnectionType.road)],
      Location.provinceTarraconensis: [
        (Location.provinceNarbonensis,ConnectionType.mountain),
        (Location.provinceBaleares,ConnectionType.sea),
        (Location.provinceCarthaginensis,ConnectionType.road),
        (Location.provinceGallaecia,ConnectionType.road)],
      Location.provinceAfrica: [
        (Location.provinceCorsicaSardinia,ConnectionType.sea),
        (Location.provinceSicilia,ConnectionType.sea),
        (Location.provinceLibya,ConnectionType.desert),
        (Location.provinceNumidia,ConnectionType.road)],
      Location.provinceLibya: [
        (Location.provinceAfrica,ConnectionType.desert),
        (Location.provinceCyrenaica,ConnectionType.river)],
      Location.provinceMauretaniaCaesariensis: [
        (Location.provinceCarthaginensis,ConnectionType.sea),
        (Location.provinceMauretaniaTingitana,ConnectionType.road),
        (Location.provinceNumidia,ConnectionType.road)],
      Location.provinceMauretaniaTingitana: [
        (Location.provinceBaetica,ConnectionType.river),
        (Location.provinceMauretaniaCaesariensis,ConnectionType.road)],
      Location.provinceNumidia: [
        (Location.provinceBaleares,ConnectionType.sea),
        (Location.provinceAfrica,ConnectionType.road),
        (Location.provinceMauretaniaCaesariensis,ConnectionType.road),
        (Location.homelandMoorish,ConnectionType.road)],
      Location.provinceAethiopia: [
        (Location.provinceThebais,ConnectionType.river),
        (Location.homelandNubian,ConnectionType.river)],
      Location.provinceAlexandria: [
        (Location.provinceArcadia,ConnectionType.river),
        (Location.provinceCyrenaica,ConnectionType.river),
        (Location.provinceArabia,ConnectionType.desert),
        (Location.provinceCyprus,ConnectionType.sea),
        (Location.provinceJudea,ConnectionType.desert)],
      Location.provinceArcadia: [
        (Location.provinceAlexandria,ConnectionType.river),
        (Location.provinceThebais,ConnectionType.river)],
      Location.provinceCreta: [
        (Location.provinceAchaea,ConnectionType.sea),
        (Location.provinceCyrenaica,ConnectionType.sea),
        (Location.provinceRhodus,ConnectionType.sea)],
      Location.provinceCyrenaica: [
        (Location.provinceLibya,ConnectionType.river),
        (Location.provinceAlexandria,ConnectionType.river),
        (Location.provinceCreta,ConnectionType.sea)],
      Location.provinceThebais: [
        (Location.provinceAethiopia,ConnectionType.river),
        (Location.provinceArcadia,ConnectionType.river)],
      Location.provinceArabia: [
        (Location.provinceAlexandria,ConnectionType.desert),
        (Location.provinceJudea,ConnectionType.desert),
        (Location.homelandJudean,ConnectionType.desert)],
      Location.provinceAssyria: [
        (Location.provinceBabylonia,ConnectionType.river),
        (Location.provinceMesopotamia,ConnectionType.river),
        (Location.provinceOsrhoene,ConnectionType.river),
        (Location.provinceArmeniaMajor,ConnectionType.mountain),
        (Location.homelandParthian,ConnectionType.road)],
      Location.provinceBabylonia: [
        (Location.provinceAssyria,ConnectionType.river),
        (Location.provinceMesopotamia,ConnectionType.road),
        (Location.homelandParthian,ConnectionType.river),
        (Location.homelandPersian,ConnectionType.river)],
      Location.provinceCilicia: [
        (Location.provinceCyprus,ConnectionType.sea),
        (Location.provinceSyria,ConnectionType.mountain),
        (Location.provinceCappadocia,ConnectionType.mountain),
        (Location.provinceLyciaPamphylia,ConnectionType.mountain)],
      Location.provinceCommagene: [
        (Location.provinceOsrhoene,ConnectionType.river),
        (Location.provinceSyria,ConnectionType.road),
        (Location.provinceCappadocia,ConnectionType.mountain)],
      Location.provinceCyprus: [
        (Location.provinceAlexandria,ConnectionType.sea),
        (Location.provinceCilicia,ConnectionType.sea),
        (Location.provinceJudea,ConnectionType.sea),
        (Location.provincePhoenicia,ConnectionType.sea),
        (Location.provinceSyria,ConnectionType.sea),
        (Location.provinceLyciaPamphylia,ConnectionType.sea)],
      Location.provinceJudea: [
        (Location.provinceAlexandria,ConnectionType.desert),
        (Location.provinceArabia,ConnectionType.desert),
        (Location.provinceCyprus,ConnectionType.sea),
        (Location.provincePhoenicia,ConnectionType.desert),
        (Location.homelandJudean,ConnectionType.desert)],
      Location.provinceMesopotamia: [
        (Location.provinceAssyria,ConnectionType.river),
        (Location.provinceBabylonia,ConnectionType.road),
        (Location.provinceOsrhoene,ConnectionType.road),
        (Location.provincePalmyra,ConnectionType.desert),
        (Location.provinceSyria,ConnectionType.desert)],
      Location.provinceOsrhoene: [
        (Location.provinceAssyria,ConnectionType.river),
        (Location.provinceCommagene,ConnectionType.river),
        (Location.provinceMesopotamia,ConnectionType.road),
        (Location.provinceSyria,ConnectionType.desert),
        (Location.provinceArmeniaMajor,ConnectionType.river)],
      Location.provincePalmyra: [
        (Location.provinceMesopotamia,ConnectionType.desert),
        (Location.provincePhoenicia,ConnectionType.desert),
        (Location.provinceSyria,ConnectionType.desert),
        (Location.homelandPalmyrene,ConnectionType.desert)],
      Location.provincePhoenicia: [
        (Location.provinceCyprus,ConnectionType.sea),
        (Location.provinceJudea,ConnectionType.desert),
        (Location.provincePalmyra,ConnectionType.desert),
        (Location.provinceSyria,ConnectionType.road)],
      Location.provinceSyria: [
        (Location.provinceCilicia,ConnectionType.mountain),
        (Location.provinceCyprus,ConnectionType.sea),
        (Location.provinceCommagene,ConnectionType.road),
        (Location.provinceMesopotamia,ConnectionType.desert),
        (Location.provinceOsrhoene,ConnectionType.desert),
        (Location.provincePalmyra,ConnectionType.desert),
        (Location.provincePhoenicia,ConnectionType.road)],
      Location.provinceAlbania: [
        (Location.provinceArmeniaMajor,ConnectionType.mountain),
        (Location.provinceIberia,ConnectionType.mountain),
        (Location.homelandAlan,ConnectionType.mountain)],
      Location.provinceArmeniaMajor: [
        (Location.provinceAssyria,ConnectionType.mountain),
        (Location.provinceOsrhoene,ConnectionType.river),
        (Location.provinceAlbania,ConnectionType.mountain),
        (Location.provinceArmeniaMinor,ConnectionType.mountain),
        (Location.provinceCappadocia,ConnectionType.mountain),
        (Location.provinceIberia,ConnectionType.mountain),
        (Location.homelandParthian,ConnectionType.mountain)],
      Location.provinceArmeniaMinor: [
        (Location.provinceBosporus,ConnectionType.sea),
        (Location.provinceArmeniaMajor,ConnectionType.mountain),
        (Location.provinceCappadocia,ConnectionType.mountain),
        (Location.provinceColchis,ConnectionType.mountain),
        (Location.provincePontus,ConnectionType.road)],
      Location.provinceAsia: [
        (Location.provinceAchaea,ConnectionType.sea),
        (Location.provinceThracia,ConnectionType.river),
        (Location.provinceBithynia,ConnectionType.road),
        (Location.provinceGalatia,ConnectionType.road),
        (Location.provinceLyciaPamphylia,ConnectionType.mountain),
        (Location.provinceRhodus,ConnectionType.river)],
      Location.provinceBithynia: [
        (Location.provinceBosporus,ConnectionType.sea),
        (Location.provinceThracia,ConnectionType.river),
        (Location.provinceAsia,ConnectionType.road),
        (Location.provinceGalatia,ConnectionType.mountain),
        (Location.provincePontus,ConnectionType.road)],
      Location.provinceCappadocia: [
        (Location.provinceCilicia,ConnectionType.mountain),
        (Location.provinceCommagene,ConnectionType.mountain),
        (Location.provinceArmeniaMajor,ConnectionType.mountain),
        (Location.provinceArmeniaMinor,ConnectionType.mountain),
        (Location.provinceGalatia,ConnectionType.road),
        (Location.provincePontus,ConnectionType.mountain)],
      Location.provinceCaucasia: [
        (Location.provinceBosporus,ConnectionType.river),
        (Location.provinceColchis,ConnectionType.mountain),
        (Location.homelandAlan,ConnectionType.mountain)],
      Location.provinceColchis: [
        (Location.provinceArmeniaMinor,ConnectionType.mountain),
        (Location.provinceCaucasia,ConnectionType.mountain),
        (Location.provinceIberia,ConnectionType.mountain),
        (Location.homelandAlan,ConnectionType.mountain)],
      Location.provinceGalatia: [
        (Location.provinceAsia,ConnectionType.road),
        (Location.provinceBithynia,ConnectionType.mountain),
        (Location.provinceCappadocia,ConnectionType.road),
        (Location.provinceLyciaPamphylia,ConnectionType.mountain),
        (Location.provincePontus,ConnectionType.mountain)],
      Location.provinceIberia: [
        (Location.provinceAlbania,ConnectionType.mountain),
        (Location.provinceArmeniaMajor,ConnectionType.mountain),
        (Location.provinceColchis,ConnectionType.mountain),
        (Location.homelandAlan,ConnectionType.mountain)],
      Location.provinceLyciaPamphylia: [
        (Location.provinceCilicia,ConnectionType.mountain),
        (Location.provinceCyprus,ConnectionType.sea),
        (Location.provinceAsia,ConnectionType.mountain),
        (Location.provinceGalatia,ConnectionType.mountain),
        (Location.provinceRhodus,ConnectionType.river)],
      Location.provincePontus: [
        (Location.provinceBosporus,ConnectionType.sea),
        (Location.provinceArmeniaMinor,ConnectionType.road),
        (Location.provinceBithynia,ConnectionType.road),
        (Location.provinceCappadocia,ConnectionType.mountain),
        (Location.provinceGalatia,ConnectionType.mountain)],
      Location.provinceRhodus: [
        (Location.provinceAchaea,ConnectionType.sea),
        (Location.provinceCreta,ConnectionType.sea),
        (Location.provinceAsia,ConnectionType.river),
        (Location.provinceLyciaPamphylia,ConnectionType.river)],
      Location.homelandAlamannic: [
        (Location.provinceAgriDecumates,ConnectionType.mountain),
        (Location.provinceBoiohaemia,ConnectionType.mountain),
        (Location.homelandBurgundian,ConnectionType.river)],
      Location.homelandAlan: [
        (Location.provinceAlbania,ConnectionType.mountain),
        (Location.provinceCaucasia,ConnectionType.mountain),
        (Location.provinceColchis,ConnectionType.mountain),
        (Location.provinceIberia,ConnectionType.mountain)],
      Location.homelandBritish: [
        (Location.provinceBritanniaInferior,ConnectionType.mountain),
        (Location.provinceBritanniaSuperior,ConnectionType.river),
        (Location.provinceHibernia,ConnectionType.river)],
      Location.homelandBurgundian: [
        (Location.homelandAlamannic,ConnectionType.river),
        (Location.homelandFrankish,ConnectionType.river)],
      Location.homelandCaledonian: [
        (Location.provinceCaledonia,ConnectionType.mountain),
        (Location.provinceHibernia,ConnectionType.sea)],
      Location.homelandCantabrian: [
        (Location.provinceGallaecia,ConnectionType.mountain)],
      Location.homelandDacian: [
        (Location.provinceDaciaSuperior,ConnectionType.mountain),
        (Location.provinceScythia,ConnectionType.mountain)],
      Location.homelandFrankish: [
        (Location.provinceGermaniaMagna,ConnectionType.river),
        (Location.homelandBurgundian,ConnectionType.river),
        (Location.homelandGerman,ConnectionType.river)],
      Location.homelandGerman: [
        (Location.provinceFrisia,ConnectionType.river),
        (Location.provinceGermaniaMagna,ConnectionType.road),
        (Location.homelandFrankish,ConnectionType.river),
        (Location.homelandSaxon,ConnectionType.river)],
      Location.homelandGothic: [
        (Location.provinceBosporus,ConnectionType.river),
        (Location.provinceScythia,ConnectionType.river)],
      Location.homelandJudean: [
        (Location.provinceArabia,ConnectionType.desert),
        (Location.provinceJudea,ConnectionType.desert)],
      Location.homelandMarcomannic: [
        (Location.provinceBoiohaemia,ConnectionType.mountain),
        (Location.provinceQuadia,ConnectionType.mountain)],
      Location.homelandMoorish: [
        (Location.provinceNumidia,ConnectionType.road)],
      Location.homelandNubian: [
        (Location.provinceAethiopia,ConnectionType.river)],
      Location.homelandPalmyrene: [
        (Location.provincePalmyra,ConnectionType.desert)],
      Location.homelandIllyrian: [
        (Location.provinceQuadia,ConnectionType.mountain),
        (Location.provinceSarmatia,ConnectionType.mountain)],
      Location.homelandParthian: [
        (Location.provinceAssyria,ConnectionType.road),
        (Location.provinceBabylonia,ConnectionType.river),
        (Location.provinceArmeniaMajor,ConnectionType.mountain)],
      Location.homelandPersian: [
        (Location.provinceBabylonia,ConnectionType.river)],
      Location.homelandSarmatian: [
        (Location.provinceSarmatia,ConnectionType.mountain),
        (Location.provinceDaciaSuperior,ConnectionType.mountain),
        (Location.homelandVandal,ConnectionType.mountain)],
      Location.homelandSaxon: [
        (Location.homelandGerman,ConnectionType.river)],
      Location.homelandVandal: [
        (Location.homelandSarmatian,ConnectionType.mountain)],
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

  bool spaceHasConnectionToNonBarbarianProvince(Location space) {
    for (final province in LocationType.province.locations) {
      if (provinceStatus(province) != ProvinceStatus.barbarian && spacesConnectionType(space, province) != null) {
        return true;
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

  int spaceAlliedOrBetterDistance(Location space, Piece war) {
    if (spaceAlliedOrBetter(space)) {
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
              if (spaceAlliedOrBetter(toSpace)) {
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

  List<Piece> provinceOverstackedUnits(Location province) {
    int legionLimit = 0;
    int auxiliaLimit = 0;
    int praetorianGuardLimit = 1;
    int imperialCavalryLimit = 0;
    int fleetLimit = 1;

    bool severan = emperorsActive(Piece.emperorsSeveran);
    if (!severan) {
      legionLimit = 4;
      auxiliaLimit = 2;
      imperialCavalryLimit = 0;
    } else {
      legionLimit = 2;
      auxiliaLimit = 4;
      imperialCavalryLimit = 1;
    }

    final command = provinceCommand(province);
    if (command == Location.commandPrefect) {
      if (!severan) {
        legionLimit = 0;
      }
      praetorianGuardLimit += 1;
      imperialCavalryLimit += 1;
    }

    if (!spaceInsurgentOrBetter(province)) {
      legionLimit = 0;
      auxiliaLimit = 0;
      praetorianGuardLimit = 0;
      imperialCavalryLimit = 0;
      fleetLimit = 0;
    }

    var units = <Piece>[];

    final legions = piecesInLocation(PieceType.legion, province);
    if (legions.length > legionLimit) {
      units += legions;
    }
    final auxilia = piecesInLocation(PieceType.auxilia, province);
    if (auxilia.length > auxiliaLimit) {
      units += auxilia;
    }
    final praetorianGuards = piecesInLocation(PieceType.praetorianGuard, province);
    if (praetorianGuards.length > praetorianGuardLimit) {
      units += praetorianGuards;
    }
    final imperialCavalry = piecesInLocation(PieceType.imperialCavalry, province);
    if (imperialCavalry.length > imperialCavalryLimit) {
      units += imperialCavalry;
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

  Location pieceLocation(Piece piece) {
    return _pieceLocations[piece.index];
  }

  void setPieceLocation(Piece piece, Location location) {
    _pieceLocations[piece.index] = location;
    if (piece.isType(PieceType.unit)) {
      var flipPiece = unitFlipUnit(piece);
      _pieceLocations[flipPiece.index] = Location.flipped;
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

  bool unitInPlay(Piece unit) {
    return pieceLocation(unit).isType(LocationType.province);
  }

  Piece unitFlipUnit(Piece unit) {
    const flipTypes = [
      [PieceType.legionOrdinary, PieceType.legionVeteran],
      [PieceType.auxiliaOrdinary, PieceType.auxiliaVeteran],
      [PieceType.praetorianGuardOrdinary, PieceType.praetorianGuardVeteran],
      [PieceType.imperialCavalryOrdinary, PieceType.imperialCavalryVeteran],
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
      PieceType.praetorianGuardVeteran,
      PieceType.imperialCavalryVeteran,
      PieceType.fleetVeteran,
    ];
    for (final pieceType in veteranUnitTypes) {
      if (unit.isType(pieceType)) {
        return true;
      }
    }
    return false;
  }

  int veteranUnitsInCommandCount(Location command) {
    int count = 0;
    final locationType = commandLocationType(command);
    if (locationType != null) {
      for (final unit in PieceType.mobileUnit.pieces) {
        if (unitVeteran(unit)) {
          final location = pieceLocation(unit);
          if (location.isType(locationType)) {
            count += 1;
          }
        }
      }
    }
    return count;
  }

  int veteranLegionsInCommandCount(Location command) {
    int count = 0;
    final locationType = commandLocationType(command);
    if (locationType != null) {
      for (final legion in PieceType.legionVeteran.pieces) {
        final location = pieceLocation(legion);
        if (location.isType(locationType)) {
          count += 1;
        }
      }
    }
    return count;
  }

  int praetorianGuardCount(bool countVeteranAsTwo) {
    int count = 0;
    for (final praetorianGuard in PieceType.praetorianGuard.pieces) {
      if (unitInPlay(praetorianGuard)) {
        if (countVeteranAsTwo && praetorianGuard.isType(PieceType.praetorianGuardVeteran)) {
          count += 2;
        } else {
          count += 1;
        }
      }
    }
    return count;
  }

  int imperialCavalryCount(bool countVeteranAsTwo) {
    int count = 0;
    for (final imperialCavalry in PieceType.imperialCavalry.pieces) {
      if (unitInPlay(imperialCavalry)) {
        if (countVeteranAsTwo && imperialCavalry.isType(PieceType.imperialCavalryVeteran)) {
          count += 2;
        } else {
          count += 1;
        }
      }
    }
    return count;
  }

  int mobileLandUnitsInSpaceCount(Location space, bool countVeteranAsTwo) {
    int count = 0;
    for (final unit in piecesInLocation(PieceType.mobileLandUnit, space)) {
      if (countVeteranAsTwo && unitVeteran(unit)) {
        count += 2;
      } else {
        count += 1;
      }
    }
    return count;
  }

  List<Piece> provinceViableWarUnits(Location province, Location command) {
    final units = <Piece>[];
    bool includeImperialUnits = commandMayUseImperialUnits(command);
    for (final unit in piecesInLocation(PieceType.mobileUnit, province)) {
      if (unit.isType(PieceType.praetorianGuard) || unit.isType(PieceType.imperialCavalry)) {
        if (includeImperialUnits) {
          units.add(unit);
        }
      } else {
        units.add(unit);
      }
    }
    return units;
  }

  int get additionalCost {
    int cost = 0;
    if (emperorsActive(Piece.emperorsFlavian)) {
      cost += 1;
    }
    if (emperorsActive(Piece.emperorsSeveran)) {
      cost += 1;
    }
    return cost;
  }

  int unitBuildCost(Piece unit) {
    int additional = additionalCost;
    if (unit.isType(PieceType.auxilia)) {
      return 5 + additional;
    }
    if (unit.isType(PieceType.legion)) {
      return 10 + additional;
    }
    if (unit.isType(PieceType.fleet)) {
      return 15 + additional;
    }
    if (unit.isType(PieceType.wall)) {
      return 20 + additional;
    }
    if (unit.isType(PieceType.praetorianGuard)) {
      return 25 + additional;
    }
    if (unit.isType(PieceType.imperialCavalry)) {
      return 30 + additional;
    }
    return 0;
  }

  int unitPayCost(Piece unit) {
    int additional = additionalCost;
    if (unit.isType(PieceType.auxilia)) {
      return 1 + additional;
    }
    if (unit.isType(PieceType.legion)) {
      return 2 + additional;
    }
    if (unit.isType(PieceType.fleet)) {
      return 3 + additional;
    }
    if (unit.isType(PieceType.wall)) {
      return 4 + additional;
    }
    if (unit.isType(PieceType.praetorianGuard)) {
      return 5 + additional;
    }
    if (unit.isType(PieceType.imperialCavalry)) {
      return 5 + additional;
    }
    return 0;
  }

  int get pay {
    int total = 0;
    for (final unit in PieceType.unit.pieces) {
      if (unitInPlay(unit)) {
        final province = pieceLocation(unit);
        final command = provinceCommand(province);
        if (!commandRebel(command)) {
          total += unitPayCost(unit);
        }
      }
    }
    return total;
  }

  int get taxBase {
    int total = 0;
    for (final command in LocationType.governorship.locations) {
      if (!commandRebel(command)) {
        final provinceLocationType = commandLocationType(command)!;
        for (final province in provinceLocationType.locations) {
          if (provinceStatus(province) == ProvinceStatus.roman) {
            total += provinceRevenue(province);
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
    if (_gold < unitBuildCost(unit)) {
      return false;
    }
    return true;
  }

  bool unitCanTransfer(Piece unit) {
    if (unit.isType(PieceType.wall)) {
      return false;
    }
    return true;
  }

  bool unitCanStackInProvince(Piece unit, Location province) {
    final command = provinceCommand(province);
    final severan = emperorsActive(Piece.emperorsSeveran);
    if (unit.isType(PieceType.legion)) {
      if (!severan && command == Location.commandPrefect) {
        return false;
      }
      return piecesInLocationCount(PieceType.legion, province) < (severan ? 2 : 4);
    }
    if (unit.isType(PieceType.auxilia)) {
      return piecesInLocationCount(PieceType.auxilia, province) < (severan ? 4 : 2);
    }
    if (unit.isType(PieceType.praetorianGuard)) {
      return piecesInLocationCount(PieceType.praetorianGuard, province) < (command == Location.commandPrefect ? 2 : 1);
    }
    if (unit.isType(PieceType.imperialCavalry)) {
      return piecesInLocationCount(PieceType.imperialCavalry, province) < (command == Location.commandPrefect ? 2 : 1);
    }
    if (unit.isType(PieceType.fleet)) {
      return piecesInLocationCount(PieceType.fleet, province) < 1;
    }
    if (unit.isType(PieceType.wall)) {
      return piecesInLocationCount(PieceType.wall, province) < 1;
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
    if (command == Location.commandPrefect) {
      if (unit.isType(PieceType.legion) && !emperorsActive(Piece.emperorsSeveran)) {
        return false;
      }
    } else {
      if (unit.isType(PieceType.praetorianGuard) || unit.isType(PieceType.imperialCavalry)) {
        return false;
      }
    }
    if (unit.isType(PieceType.fleet) && provinceLandlocked(province)) {
      return false;
    }
    if (!unitCanStackInProvince(unit, province)) {
      return false;
    }
    return true;
  }

  int unitTransferCostToProvince(Piece unit, Location toProvince) {
    if (unit.isType(PieceType.praetorianGuard) && emperorsActive(Piece.emperorsSeveran)) {
      return 0;
    }
    if (unit.isType(PieceType.imperialCavalry) && emperorsActive(Piece.emperorsBarracks)) {
      return 0;
    }
    final fromProvince = pieceLocation(unit);
    final fromCommand = provinceCommand(fromProvince);
    final toCommand = provinceCommand(toProvince);
    if (toCommand == fromCommand) {
      return 0;
    }
    return unitPayCost(unit);
  }

  bool unitCanTransferToProvince(Piece unit, Location toProvince, bool checkCost, bool checkLoyalty) {
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
    final fromLoyalty = commandLoyalty(fromCommand);
    final toCommand = provinceCommand(toProvince);
    final toLoyalty = commandLoyalty(toCommand);
    if (checkLoyalty) {
      if (toLoyalty != fromLoyalty) {
        return false;
      }
    }
    if (unit.isType(PieceType.fleet)) {
      if (provinceLandlocked(toProvince)) {
        return false;
      }
      final fromEuphrates = provinceOnEuphrates(fromProvince);
      final toEuphrates = provinceOnEuphrates(toProvince);
      if (fromEuphrates != toEuphrates) {
        return false;
      }
    }
    if (checkCost) {
      int gold = fromLoyalty == Location.commandCaesar ? _gold : 0;
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

  Location warHomeland(Piece war) {
    final enemy = warEnemy(war);
    return enemy.homeland;
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

  String statesmanName(Piece statesman) {
    const statesmanNames = {
      Piece.statesmanAelianus: ('Aelianus', 'Casperius Aelianus'),
      Piece.statesmanAemilian: ('Aemilian', 'Marcus Aemilius Aemilianus'),
      Piece.statesmanAgricola: ('Agricola', 'Gnaeus Julius Agricola'),
      Piece.statesmanAgrippa: ('Agrippa', 'Marcus Vipsanius Agrippa'),
      Piece.statesmanAlbinus: ('Clodius Albinus', 'Clodius Albinus'),
      Piece.statesmanAlexander: ('Alexander Severus', 'Marcus Aurelius Severus Alexander'),
      Piece.statesmanAntoninus: ('Antoninus Pius', 'Titus Aurelius Hadrianus Anontinus Pius'),
      Piece.statesmanArrian: ('Arrian', 'Lucius Flavius Arrianus'),
      Piece.statesmanAugustus: ('Augustus', 'Gaius Julius Caesar Augustus'),
      Piece.statesmanAurelian: ('Aurelian', 'Lucius Domitius Aurelianus'),
      Piece.statesmanAvidius: ('Avidius Cassius', 'Gaius Avidius Cassius'),
      Piece.statesmanCaligula: ('Caligula', 'Gaius Caesar Augustus Germanicus'),
      Piece.statesmanCaracalla: ('Caracalla', 'Marcus Aurelius Antoninus'),
      Piece.statesmanCarausius: ('Carausius', 'Marcus Aurelius Mausaeus Carausius'),
      Piece.statesmanCarinus: ('Carinus', 'Marcus Aurelius Carinus'),
      Piece.statesmanCarus: ('Carus','Marcus Aurelius Carus'),
      Piece.statesmanCerialis: ('Cerialis', 'Quintus Petillius Cerialis Caesius Rufus'),
      Piece.statesmanClaudius: ('Claudius', 'Tiberius Claudius Caesar Augustus Germanicus'),
      Piece.statesmanCommodus: ('Commodus', 'Lucius Aelius Aurelius Commodus'),
      Piece.statesmanCorbulo: ('Corbulo', 'Gnaeus Domitius Corbulo'),
      Piece.statesmanDecius: ('Decius', 'Gaius Messius Quintus Trajanus Decius'),
      Piece.statesmanDiocletian: ('Diocletian', 'Gaius Aurelius Valerius Diocletianus'),
      Piece.statesmanDomitian:('Domitian', 'Titus Flavius Domitianus'),
      Piece.statesmanDrusus: ('Drusus', 'Nero Claudius Drusus'),
      Piece.statesmanElagabalus: ('Elagabalus', 'Marcus Aurelius Antoninus'),
      Piece.statesmanGalba: ('Galba', 'Servius Sulpicius Galba'),
      Piece.statesmanGallienus: ('Gallienus', 'Publius Licinius Egnatius Gallienus'),
      Piece.statesmanGallus: ('Trebonianus Gallus', 'Gaius Vibius Trebonianus Gallus'),
      Piece.statesmanGermanicus: ('Germanicus', 'Germanicus Julius Caesar'),
      Piece.statesmanGordian: ('Gordian III', 'Marcus Antonius Gordianus'),
      Piece.statesmanGothicus: ('Claudius Gothicus', 'Marcus Aurelius Claudius “Gothicus”'),
      Piece.statesmanHadrian: ('Hadrian', 'Publius Aelius Hadrianus'),
      Piece.statesmanJulianus: ('Julianus', 'Lucius Julius Vehilius Gratus Julianus'),
      Piece.statesmanLaetus: ('Laetus', 'Quintus Aemilius Laetus'),
      Piece.statesmanLucius: ('Lucius Verus', 'Lucius Aurelius Verus'),
      Piece.statesmanMacrinus: ('Macrinus', 'Marcus Opellius Macrinus'),
      Piece.statesmanMacro: ('Macro', 'Naevius Sutorius Macro'),
      Piece.statesmanMarcus: ('Marcus Aurelius', 'Marcus Aurelius Antoninus'),
      Piece.statesmanMaximian: ('Maximian', 'Marcus Aurelius Valerius Maximianus'),
      Piece.statesmanMaximinus: ('Maximinus Thrax', 'Gaius Julius Verus Maximinus “Thrax”'),
      Piece.statesmanNero: ('Nero', 'Nero Claudius Caesar Augustus Germanicus'),
      Piece.statesmanNerva: ('Nerva', 'Marcus Cocceius Nerva'),
      Piece.statesmanNiger: ('Pescennius Niger', 'Gaius Pescennius Niger'),
      Piece.statesmanOdaenath: ('Odaenathus', 'Septimius Odaenathus'),
      Piece.statesmanOtho: ('Otho', 'Marcus Salvius Otho'),
      Piece.statesmanPaulinus: ('Suetonius Paulinus', 'Gaius Suetonius Paulinus'),
      Piece.statesmanPertinax: ('Pertinax', 'Publius Helvius Pertinax'),
      Piece.statesmanPhilip: ('Philip the Arab', 'Marcus Julius Philippus “Arabs”'),
      Piece.statesmanPlautianus: ('Plautianus', 'Gaius Fulvius Plautianus'),
      Piece.statesmanPlautius: ('Plautius', 'Aulus Plautius'),
      Piece.statesmanPompeianus: ('Pompeianus', 'Tiberius Claudius Pompeianus'),
      Piece.statesmanPostumus: ('Postumus', 'Marcus Cassianius Latinius Postumus'),
      Piece.statesmanProbus: ('Probus', 'Marcus Aurelius Probus'),
      Piece.statesmanQuietus: ('Quietus', 'Lusius Quietus'),
      Piece.statesmanSejanus: ('Sejanus', 'Lucius Aelius Sejanus'),
      Piece.statesmanSeverus: ('Septimius Severus', 'Lucius Septimius Severus'),
      Piece.statesmanSilvanus: ('Silvanus Aelianus', 'Tiberius Plautius Silvanus Aeliuanus'),
      Piece.statesmanTacitus: ('Tacitus', 'Marcus Claudius Tacitus'),
      Piece.statesmanTiberius: ('Tiberius', 'Tiberius Julus Caesar Augustus'),
      Piece.statesmanTimesitheus: ('Timesitheus', 'Gaius Furius Sabinius Aquila Timesitheus'),
      Piece.statesmanTitus: ('Titus', 'Titus Caesar Vespasianus'),
      Piece.statesmanTrajan: ('Trajan', 'Marcus Ulpius Traianus'),
      Piece.statesmanTurbo: ('Turbo', 'Quintus Marcius Turbo'),
      Piece.statesmanValerian: ('Valerian', 'Publius Licinius Valerianus'),
      Piece.statesmanVespasian: ('Vespasian', 'Titus Flavius Vespasianus'),
      Piece.statesmanVitellius: ('Vitellius', 'Aulus Vitellius'),
    };

    String name = statesmanNames[statesman]!.$1;
    final location = pieceLocation(statesman);
    if (caesarDeified && location == Location.commandCaesar) {
      name = 'The Divine $name';
    }
    if (location.isType(LocationType.governorship) && commandRebel(location)) {
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

  bool statesmanActiveImperial(Piece statesman) {
    for (final emperors in piecesInLocation(PieceType.emperors, Location.boxEmperors)) {
      if (emperorsImperialStatesmen(emperors).contains(statesman)) {
        return true;
      }
  	}
  	return false;
  }

  Piece? statesmanImperialDynasty(Piece statesman) {
    for (final emperors in PieceType.emperors.pieces) {
      if (emperorsImperialStatesmen(emperors).contains(statesman)) {
        return emperors;
      }
    }
    return null;
  }

  bool fromSameImperialDynastyAsCaesar(Piece? statesman) {
    if (statesman == null) {
      return false;
    }
    final caesar = commandCommander(Location.commandCaesar);
    if (caesar == null) {
      return false;
    }
    if (!statesmanImperial(statesman) || !statesmanImperial(caesar)) {
      return false;
    }
    return statesmanImperialDynasty(statesman) == statesmanImperialDynasty(caesar);
  }

  bool statesmanMayBecomeCaesar(Piece statesman) {
    if (!emperorsActive(Piece.emperorsClaudian) && !statesmanImperial(statesman)) {
      return false;
    }
    if (statesmanAbility(statesman) == Ability.prefect && !emperorsActive(Piece.emperorsSeveran)) {
      return false;
    }
    return true;
  }

  String commandName(Location command) {
    const commandNames = {
      Location.commandCaesar: 'Caesar',
      Location.commandConsul: 'Consul',
      Location.commandPrefect: 'Italia',
      Location.commandBritannia: 'Britannia',
      Location.commandGallia: 'Gallia',
      Location.commandPannonia: 'Pannonia',
      Location.commandMoesia: 'Moesia',
      Location.commandHispania: 'Hispania',
      Location.commandAfrica: 'Africa',
      Location.commandAegyptus: 'Aegyptus',
      Location.commandSyria: 'Syria',
      Location.commandPontica: 'Pontica',
    };
    return commandNames[command]!;
  }

  LocationType? commandLocationType(Location command) {
    const commandLocationTypes = {
      Location.commandCaesar: null,
      Location.commandConsul: null,
      Location.commandPrefect: LocationType.provinceItalia,
      Location.commandBritannia: LocationType.provinceBritannia,
      Location.commandGallia: LocationType.provinceGallia,
      Location.commandPannonia: LocationType.provincePannonia,
      Location.commandMoesia: LocationType.provinceMoesia,
      Location.commandHispania: LocationType.provinceHispania,
      Location.commandAfrica: LocationType.provinceAfrica,
      Location.commandAegyptus: LocationType.provinceAegyptus,
      Location.commandSyria: LocationType.provinceSyria,
      Location.commandPontica: LocationType.provincePontica,
    };
    return commandLocationTypes[command];
  }

  bool commandsConnect(Location command0, Location command1) {
    const commandConnections = {
      Location.commandPrefect: [Location.commandGallia, Location.commandPannonia, Location.commandMoesia, Location.commandHispania, Location.commandAfrica],
      Location.commandBritannia: [Location.commandGallia],
      Location.commandGallia: [Location.commandPrefect, Location.commandBritannia, Location.commandPannonia, Location.commandHispania],
      Location.commandPannonia: [Location.commandPrefect, Location.commandGallia, Location.commandMoesia],
      Location.commandMoesia: [Location.commandPrefect, Location.commandPannonia, Location.commandAegyptus, Location.commandPontica],
      Location.commandHispania: [Location.commandPrefect, Location.commandGallia, Location.commandAfrica],
      Location.commandAfrica: [Location.commandPrefect, Location.commandHispania, Location.commandAegyptus],
      Location.commandAegyptus: [Location.commandMoesia, Location.commandAfrica, Location.commandSyria, Location.commandPontica],
      Location.commandSyria: [Location.commandAegyptus, Location.commandPontica],
      Location.commandPontica: [Location.commandMoesia, Location.commandAegyptus, Location.commandSyria],
    };
    return commandConnections[command0]!.contains(command1);
  }

  String commanderPositionName(Location command) {
    const commanderPositionNames = {
	    Location.commandCaesar: 'Caesar',
	    Location.commandConsul: 'Consul',
	    Location.commandPrefect: 'Prefect',
	    Location.commandBritannia: 'Governor of Britannia',
	    Location.commandGallia: 'Governor of Gallia',
	    Location.commandPannonia:  'Governor of Pannonia',
	    Location.commandMoesia: 'Governor of Moesia',
	    Location.commandHispania: 'Governor of Hispania',
	    Location.commandAfrica: 'Governor of Africa',
	    Location.commandAegyptus: 'Governor of Aegyptus',
	    Location.commandSyria: 'Governor of Syria',
	    Location.commandPontica: 'Governor of Pontica',
    };
    return commanderPositionNames[command]!;
  }

  Location commandOverallCommand(Location command) {
    final loyalty = commandLoyalty(command);
    if (loyalty == Location.commandCaesar) {
      return command;
    }
    return loyalty;
  }

  Piece? commandCommander(Location command) {
    final overallCommand = commandOverallCommand(command);
    for (final statesman in PieceType.statesman.pieces) {
      if (pieceLocation(statesman) == overallCommand) {
        return statesman;
      }
    }
    return null;
  }

  String commanderName(Location command) {
    final overallCommand = commandOverallCommand(command);
    final commander = commandCommander(overallCommand);
    if (commander != null) {
      return statesmanName(commander);
    } else {
      return commanderPositionName(overallCommand);
    }
  }

  int commandMilitary(Location command) {
    final overallCommand = commandOverallCommand(command);
    final commander = commandCommander(overallCommand);
    if (commander != null) {
      return statesmanMilitary(commander);
    }
    return commandData[overallCommand]!.$1;
  }

  int commandAdministration(Location command) {
    final overallCommand = commandOverallCommand(command);
    final commander = commandCommander(overallCommand);
    if (commander != null) {
      return statesmanAdministration(commander);
    }
    return commandData[overallCommand]!.$2;
  }

  int commandPopularity(Location command) {
    final overallCommand = commandOverallCommand(command);
    final commander = commandCommander(overallCommand);
    if (commander != null) {
      return statesmanPopularity(commander);
    }
    return commandData[overallCommand]!.$3;
  }

  int commandIntrigue(Location command) {
    final overallCommand = commandOverallCommand(command);
    final commander = commandCommander(overallCommand);
    if (commander != null) {
      return statesmanIntrigue(commander);
    }
    return commandData[overallCommand]!.$4;
  }

  Location commandLoyalty(Location command) {
    switch (command) {
    case Location.commandCaesar:
    case Location.commandConsul:
      return Location.commandCaesar;
    default:
      return _governorshipLoyalties[command.index - LocationType.governorship.firstIndex];
    }
  }

  void setCommandLoyalty(Location command, Location loyaltyCommand) {
    switch (command) {
    case Location.commandCaesar:
    case Location.commandConsul:
      return;
    default:
      _governorshipLoyalties[command.index - LocationType.governorship.firstIndex] = loyaltyCommand;
    }
  }

  bool commandLoyaltyChecked(Location command) {
    switch (command) {
    case Location.commandCaesar:
    case Location.commandConsul:
      return true;
    default:
      return _governorshipLoyaltiesChecked[command.index - LocationType.governorship.firstIndex];
    }
  }

  void setCommandLoyaltyChecked(Location command, bool checked) {
    switch (command) {
    case Location.commandCaesar:
    case Location.commandConsul:
      return;
    default:
      _governorshipLoyaltiesChecked[command.index - LocationType.governorship.firstIndex] = checked;
    }
  }

  bool commandMayRebel(Location command) {
    switch (command) {
    case Location.commandCaesar:
    case Location.commandConsul:
      return false;
    case Location.commandPrefect:
  	  if (!emperorsActive(Piece.emperorsBarracks)) {
    		return false;
      }
    default:
	  }
    if (fromSameImperialDynastyAsCaesar(commandCommander(command))) {
      return false;
    }
    return true;
  }

  bool commandLoyal(Location command) {
  	return commandLoyalty(command) == Location.commandCaesar;
  }

  bool commandRebel(Location command) {
  	return commandLoyalty(command) != Location.commandCaesar;
  }

  bool commandIsRebelEmperor(Location command) {
    return command != Location.commandCaesar && commandLoyalty(command) == command;
  }

  int commandRebelEmperorLoyaltyCount(Location rebelCommand) {
    return _governorshipLoyalties.where((command) => command == rebelCommand).length;
  }

  bool commandMayUseImperialUnits(Location command) {
    if (command == Location.commandCaesar || command == Location.commandPrefect) {
      return true;
    }
    if (commandIsRebelEmperor(command)) {
      return true;
    }
    final commander = commandCommander(command);
    return commander != null && statesmanActiveImperial(commander);
  }

  bool commandActive(Location command) {
    if (!command.isType(LocationType.governorship)) {
      return true;
    }
    final locationType = commandLocationType(command)!;
    for (final province in locationType.locations) {
      if (spaceInsurgentOrBetter(province)) {
        return true;
      }
    }
    return false;
  }

  List<Location> connectedUncheckedLoyalCommands(Location rebelCommand) {
    final rebelCommands = <Location>[];
    final uncheckedLoyalCommands = <Location>[];
    for (final command in LocationType.governorship.locations) {
      final loyalty = commandLoyalty(command);
      if (loyalty == rebelCommand) {
        rebelCommands.add(command);
      } else if (loyalty == Location.commandCaesar && !commandLoyaltyChecked(command)) {
        if (command != Location.commandPrefect || emperorsActive(Piece.emperorsBarracks)) {
          uncheckedLoyalCommands.add(command);
        }
      }
    }
    if (uncheckedLoyalCommands.isEmpty) {
      return [];
    }
    final connectedUncheckedLoyals = <Location>[];
    for (final loyalCommand in uncheckedLoyalCommands) {
      for (final rebelCommand in rebelCommands) {
        if (commandsConnect(loyalCommand, rebelCommand)) {
          connectedUncheckedLoyals.add(loyalCommand);
          break;
        }
      }
    }
    return connectedUncheckedLoyals;
  }

  List<Location> uncheckedRebelCommands() {
    final rebelCommands = <Location>[];
    for (final command in LocationType.governorship.locations) {
      if (commandIsRebelEmperor(command) && !commandLoyaltyChecked(command)) {
        if (connectedUncheckedLoyalCommands(command).isNotEmpty) {
          rebelCommands.add(command);
        }
      }
    }
    return rebelCommands;
  }

  int unfilledCommandCount() {
    int count = 0;
    for (final command in LocationType.command.locations) {
      if (command != Location.commandCaesar && commandLoyal(command) && commandActive(command) && commandCommander(command) == null) {
        count += 1;
      }
    }
    return count;
  }

  bool statesmanValidAppointee(Piece statesman) {
    if (!statesmanInPlay(statesman)) {
      return false;
    }
    final location = pieceLocation(statesman);
    if (location == Location.boxStatesmen) {
      return true;
    }
    if (location == Location.commandCaesar) {
      return false;
    }
    if (location == Location.commandPrefect && statesmanAbility(statesman) == Ability.prefect) {
      return false;
    }
    if (commandRebel(location)) {
      return false;
    }
    return true;
  }

  bool commandValidAppointment(Location command) {
    if (command == Location.commandCaesar) {
      return false;
    }
    if (!commandActive(command)) {
      return false;
    }
    if (command == Location.commandPrefect) {
      final prefect = commandCommander(command);
      if (prefect != null && statesmanAbility(prefect) == Ability.prefect) {
        return false;
      }
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

  bool emperorsActive(Piece emperors) {
    return pieceLocation(emperors) == Location.boxEmperors;
  }

  int get emperorsCount {
    return piecesInLocationCount(PieceType.emperors, Location.boxEmperors);
  }

  List<Piece> emperorsImperialStatesmen(Piece emperors) {
    const imperialStatesmen = {
      Piece.emperorsJulian: [
        Piece.statesmanAugustus,
        Piece.statesmanTiberius,
        Piece.statesmanGermanicus,
        Piece.statesmanCaligula],
      Piece.emperorsClaudian: [
        Piece.statesmanDrusus,
        Piece.statesmanClaudius,
        Piece.statesmanNero],
      Piece.emperorsFlavian: [
        Piece.statesmanVespasian,
        Piece.statesmanTitus,
        Piece.statesmanDomitian],
      Piece.emperorsAdoptive: [
        Piece.statesmanNerva,
        Piece.statesmanTrajan,
        Piece.statesmanHadrian],
      Piece.emperorsAntonine: [
        Piece.statesmanAntoninus,
        Piece.statesmanMarcus,
        Piece.statesmanLucius,
        Piece.statesmanCommodus],
      Piece.emperorsSeveran: [
        Piece.statesmanSeverus,
        Piece.statesmanCaracalla,
        Piece.statesmanElagabalus,
        Piece.statesmanAlexander],
      Piece.emperorsBarracks: [
        Piece.statesmanGordian,
        Piece.statesmanValerian,
        Piece.statesmanGallienus],
      Piece.emperorsIllyrian: [
        Piece.statesmanCarus,
        Piece.statesmanCarinus]
    };
    return imperialStatesmen[emperors]!;
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
      EventType.adoption: 'Adoption',
      EventType.assassin: 'Assassin',
      EventType.barbarian: 'Barbarian',
      EventType.bodyguard: 'Bodyguard',
      EventType.colony: 'Colony',
      EventType.conquest: 'Conquest',
      EventType.conspiracy: 'Conspiracy',
      EventType.deification: 'Deification',
      EventType.inflation: 'Inflation',
      EventType.migration: 'Migration',
      EventType.mutiny: 'Mutiny',
      EventType.omens: 'Omens',
      EventType.persecution: 'Persecution',
      EventType.plague: 'Plague',
      EventType.praetorians: 'Praetorians',
      EventType.rebellion: 'Rebellion',
      EventType.terror: 'Terror',
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

  int get gold {
    return _gold;
  }

  void adjustGold(int amount) {
    _gold += amount;
    if (_gold > 500) {
      _gold = 500;
    }
  }

  int get prestige {
    return _prestige;
  }

  void adjustPrestige(int amount) {
    _prestige += amount;
  }

  int get unrest {
    return _unrest;
  }

  void adjustUnrest(int amount) {
    _unrest += amount;
    if (_unrest < 0) {
      _unrest = 0;
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
		  int ageClassification = (age - 10) ~/ 8 - 1;  // Alexander starts aged 14, so will be -1
      setPieceLocation(statesman, location);
      setStatesmanAge(statesman, ageClassification);
    }
  }

  void setupEmperors(List<Piece> emperors) {
    for (final emperors in emperors) {
      setPieceLocation(emperors, Location.boxEmperors);
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

  factory GameState.setup27BCE() {

    var state = GameState();

    state._turn = 0;
    state._gold = 100;
    state._prestige = 25;
    state._unrest = 4;

	  state.setupStatesmen([
		  (Piece.statesmanAugustus, Location.commandCaesar, 36),
		  (Piece.statesmanAgrippa, Location.commandConsul, 36),
	  ]);

	  state.setupStatesmenPool([
      Piece.statesmanTiberius,
      Piece.statesmanDrusus,
      Piece.statesmanGermanicus,
      Piece.statesmanSejanus,
      Piece.statesmanMacro,
      Piece.statesmanCaligula,
      Piece.statesmanPaulinus,
      Piece.statesmanClaudius,
      Piece.statesmanPlautius,
      Piece.statesmanNero,
      Piece.statesmanCorbulo,
      Piece.statesmanSilvanus,
      Piece.statesmanGalba,
      Piece.statesmanOtho,
      Piece.statesmanVitellius,
      Piece.statesmanVespasian,
      Piece.emperorsJulian,
      Piece.emperorsClaudian,
    ]);

    state.setupWarsPool([
      Piece.leaderArminius,
      Piece.leaderBato,
      Piece.leaderBoudicca,
      Piece.leaderCaratacus,
      Piece.leaderCivilis,
      Piece.leaderSimeon,
      Piece.leaderTacfarinus,
      Piece.leaderVologases,
      Piece.warBritish7,
      Piece.warBritish6,
      Piece.warGerman14,
      Piece.warGerman12,
      Piece.warGerman10,
      Piece.warGerman8,
      Piece.warIllyrian12,
      Piece.warIllyrian10,
      Piece.warJudean8,
      Piece.warMarcomannic11,
      Piece.warMarcomannic9,
      Piece.warMoorish7,
      Piece.warMoorish5,
      Piece.warNubian6,
      Piece.warParthian14,
      Piece.warParthian8,
      Piece.warSarmatian8,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceAlpes, ProvinceStatus.allied),
      (Location.provinceBritanniaInferior, ProvinceStatus.barbarian),
      (Location.provinceBritanniaSuperior, ProvinceStatus.allied),
      (Location.provinceCaledonia, ProvinceStatus.barbarian),
      (Location.provinceHibernia, ProvinceStatus.barbarian),
      (Location.provinceAgriDecumates, ProvinceStatus.allied),
      (Location.provinceFrisia, ProvinceStatus.barbarian),
      (Location.provinceAquitania, ProvinceStatus.insurgent),
      (Location.provinceGermaniaMagna, ProvinceStatus.barbarian),
      (Location.provinceRhaetia, ProvinceStatus.veteranAllied),
      (Location.provinceBoiohaemia, ProvinceStatus.barbarian),
      (Location.provinceIllyria, ProvinceStatus.insurgent),
      (Location.provinceNoricum, ProvinceStatus.veteranAllied),
      (Location.provincePannoniaInferior, ProvinceStatus.allied),
      (Location.provincePannoniaSuperior, ProvinceStatus.allied),
      (Location.provinceQuadia, ProvinceStatus.barbarian),
      (Location.provinceSarmatia, ProvinceStatus.barbarian),
      (Location.provinceBosporus, ProvinceStatus.veteranAllied),
      (Location.provinceDaciaInferior, ProvinceStatus.barbarian),
      (Location.provinceDaciaSuperior, ProvinceStatus.barbarian),
      (Location.provinceMoesiaInferior, ProvinceStatus.allied),
      (Location.provinceMoesiaSuperior, ProvinceStatus.insurgent),
      (Location.provinceScythia, ProvinceStatus.barbarian),
      (Location.provinceThracia, ProvinceStatus.allied),
      (Location.provinceAlbania, ProvinceStatus.veteranAllied),
      (Location.provinceArmeniaMajor, ProvinceStatus.barbarian),
      (Location.provinceArmeniaMinor, ProvinceStatus.veteranAllied),
      (Location.provinceCappadocia, ProvinceStatus.veteranAllied),
      (Location.provinceCaucasia, ProvinceStatus.barbarian),
      (Location.provinceColchis, ProvinceStatus.veteranAllied),
      (Location.provinceGalatia, ProvinceStatus.veteranAllied),
      (Location.provinceIberia, ProvinceStatus.veteranAllied),
      (Location.provinceLyciaPamphylia, ProvinceStatus.veteranAllied),
      (Location.provinceRhodus, ProvinceStatus.veteranAllied),
      (Location.provinceArabia, ProvinceStatus.barbarian),
      (Location.provinceAssyria, ProvinceStatus.barbarian),
      (Location.provinceBabylonia, ProvinceStatus.barbarian),
      (Location.provinceCommagene, ProvinceStatus.veteranAllied),
      (Location.provinceJudea, ProvinceStatus.veteranAllied),
      (Location.provinceMesopotamia, ProvinceStatus.barbarian),
      (Location.provinceOsrhoene, ProvinceStatus.barbarian),
      (Location.provincePalmyra, ProvinceStatus.allied),
      (Location.provinceAethiopia, ProvinceStatus.barbarian),
      (Location.provinceAlexandria, ProvinceStatus.insurgent),
      (Location.provinceArcadia, ProvinceStatus.insurgent),
      (Location.provinceThebais, ProvinceStatus.insurgent),
      (Location.provinceMauretaniaCaesariensis, ProvinceStatus.allied),
      (Location.provinceMauretaniaTingitana, ProvinceStatus.allied),
      (Location.provinceNumidia, ProvinceStatus.veteranAllied),
      (Location.provinceGallaecia, ProvinceStatus.barbarian),
      (Location.provinceLusitania, ProvinceStatus.insurgent),
      (Location.provinceTarraconensis, ProvinceStatus.insurgent),
  	]);

    state.setupPieces([
      (Location.provinceNeapolis, Piece.fleetPraetorian0Veteran),
      (Location.provinceRavenna, Piece.fleetPraetorian1Veteran),
      (Location.provinceRome, Piece.praetorianGuard0),
      (Location.provinceAquitania, Piece.legionVarianaXVII),
      (Location.provinceAquitania, Piece.legionVarianaXVIII),
      (Location.provinceAquitania, Piece.auxilia0),
      (Location.provinceAquitania, Piece.auxilia1),
      (Location.provinceGermaniaInferior, Piece.legionVarianaXIX),
      (Location.provinceGermaniaInferior, Piece.auxilia2),
      (Location.provinceGermaniaSuperior, Piece.legionGallicaXVI),
      (Location.provinceGermaniaSuperior, Piece.legionRapaxXXI),
      (Location.provinceIllyria, Piece.legionClaudiaXI),
      (Location.provinceIllyria, Piece.legionGeminaXIII),
      (Location.provinceIllyria, Piece.legionGeminaXIV),
      (Location.provinceIllyria, Piece.legionApollinarisXVVeteran),
      (Location.provinceMoesiaSuperior, Piece.legionScythicaIV),
      (Location.provinceMoesiaSuperior, Piece.legionMacedonicaVVeteran),
      (Location.provinceMoesiaSuperior, Piece.legionClaudiaVII),
      (Location.provinceMoesiaSuperior, Piece.legionAugustaVIIIVeteran),
      (Location.provincePhoenicia, Piece.legionGallicaIII),
      (Location.provinceSyria, Piece.legionFerrataVIVeteran),
      (Location.provinceSyria, Piece.legionFretensisX),
      (Location.provinceSyria, Piece.auxilia3),
      (Location.provinceSyria, Piece.auxilia4),
      (Location.provinceAlexandria, Piece.fleetAegyptian),
      (Location.provinceAlexandria, Piece.legionCyrenaicaIII),
      (Location.provinceAlexandria, Piece.legionFulminataXIIVeteran),
      (Location.provinceAlexandria, Piece.auxilia5),
      (Location.provinceArcadia, Piece.auxilia6),
      (Location.provinceThebais, Piece.auxilia7),
      (Location.provinceAfrica, Piece.legionAugustaIII),
      (Location.provinceGallaecia, Piece.warCantabrian8),
      (Location.provinceLusitania, Piece.legionGermanicaI),
      (Location.provinceLusitania, Piece.legionAugustaIIVeteran),
      (Location.provinceLusitania, Piece.legionHispanaIX),
      (Location.provinceLusitania, Piece.legionGeminaX),
      (Location.provinceLusitania, Piece.auxilia8),
      (Location.provinceLusitania, Piece.auxilia9),
      (Location.provinceTarraconensis, Piece.legionMacedonicaIVVeteran),
      (Location.provinceTarraconensis, Piece.legionAlaudaeVVeteran),
      (Location.provinceTarraconensis, Piece.legionVictrixVI),
      (Location.provinceTarraconensis, Piece.legionValeriaXX),
      (Location.provinceTarraconensis, Piece.auxilia10),
      (Location.provinceTarraconensis, Piece.auxilia11),
      (Location.boxBarracks, Piece.fleetGerman),
      (Location.boxBarracks, Piece.fleetMoesian),
      (Location.boxBarracks, Piece.legionDeiotarianaXXII),
      (Location.boxBarracks, Piece.auxilia12),
      (Location.boxBarracks, Piece.auxilia13),
      (Location.boxBarracks, Piece.auxilia14),
      (Location.boxBarracks, Piece.auxilia15),
      (Location.boxBarracks, Piece.auxilia16),
      (Location.boxBarracks, Piece.auxilia17),
      (Location.boxBarracks, Piece.auxilia18),
      (Location.boxBarracks, Piece.auxilia19),
    ]);

    return state;
  }

  factory GameState.setup70CE() {

    var state = GameState();

    state._turn = 10;
    state._gold = 50;
    state._prestige = 0;
    state._unrest = 5;

    state.setupLeaders([
      (Piece.leaderVologases, Location.homelandParthian, 37),
      (Piece.leaderCivilis, Location.provinceGermaniaInferior, 45),
      (Piece.leaderSimeon, Location.provinceJudea, 30),
    ]);

	  state.setupStatesmen([
		  (Piece.statesmanVespasian, Location.commandCaesar, 61),
		  (Piece.statesmanSilvanus, Location.commandHispania, 58),
	  ]);

    state.setupEmperors([Piece.emperorsJulian, Piece.emperorsClaudian]);

	  state.setupStatesmenPool([
      Piece.statesmanCerialis,
      Piece.statesmanTitus,
      Piece.statesmanDomitian,
      Piece.statesmanAgricola,
      Piece.statesmanAelianus,
      Piece.statesmanNerva,
      Piece.statesmanTrajan,
      Piece.statesmanQuietus,
      Piece.statesmanHadrian,
      Piece.statesmanTurbo,
      Piece.statesmanArrian,
      Piece.statesmanAntoninus,
      Piece.emperorsFlavian,
      Piece.emperorsAdoptive,
    ]);

    state.setupWarsPool([
      Piece.leaderCalgacus,
      Piece.leaderDecebalus,
      Piece.warAlan9,
      Piece.warBritish7,
      Piece.warBritish6,
      Piece.warCaledonian5,
      Piece.warCaledonian4,
      Piece.warDacian12,
      Piece.warDacian11,
      Piece.warDacian10,
      Piece.warGerman10,
      Piece.warGerman8,
      Piece.warJudean7,
      Piece.warJudean6,
      Piece.warMarcomannic11,
      Piece.warMoorish7,
      Piece.warMoorish5,
      Piece.warParthian12,
      Piece.warParthian10,
      Piece.warSarmatian10,
      Piece.warSarmatian8,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceBritanniaInferior, ProvinceStatus.allied),
      (Location.provinceBritanniaSuperior, ProvinceStatus.insurgent),
      (Location.provinceCaledonia, ProvinceStatus.barbarian),
      (Location.provinceHibernia, ProvinceStatus.barbarian),
      (Location.provinceAgriDecumates, ProvinceStatus.barbarian),
      (Location.provinceFrisia, ProvinceStatus.barbarian),
      (Location.provinceGermaniaInferior, ProvinceStatus.insurgent),
      (Location.provinceGermaniaMagna, ProvinceStatus.barbarian),
      (Location.provinceBoiohaemia, ProvinceStatus.allied),
      (Location.provinceQuadia, ProvinceStatus.barbarian),
      (Location.provinceSarmatia, ProvinceStatus.allied),
      (Location.provinceBosporus, ProvinceStatus.veteranAllied),
      (Location.provinceDaciaInferior, ProvinceStatus.barbarian),
      (Location.provinceDaciaSuperior, ProvinceStatus.barbarian),
      (Location.provinceScythia, ProvinceStatus.barbarian),
      (Location.provinceAlbania, ProvinceStatus.veteranAllied),
      (Location.provinceArmeniaMajor, ProvinceStatus.barbarian),
      (Location.provinceArmeniaMinor, ProvinceStatus.allied),
      (Location.provinceCappadocia, ProvinceStatus.veteranAllied),
      (Location.provinceCaucasia, ProvinceStatus.barbarian),
      (Location.provinceColchis, ProvinceStatus.allied),
      (Location.provinceIberia, ProvinceStatus.veteranAllied),
      (Location.provinceLyciaPamphylia, ProvinceStatus.veteranAllied),
      (Location.provinceRhodus, ProvinceStatus.veteranAllied),
      (Location.provinceArabia, ProvinceStatus.allied),
      (Location.provinceAssyria, ProvinceStatus.barbarian),
      (Location.provinceBabylonia, ProvinceStatus.barbarian),
      (Location.provinceCommagene, ProvinceStatus.veteranAllied),
      (Location.provinceJudea, ProvinceStatus.insurgent),
      (Location.provinceMesopotamia, ProvinceStatus.barbarian),
      (Location.provinceOsrhoene, ProvinceStatus.barbarian),
      (Location.provincePalmyra, ProvinceStatus.allied),
      (Location.provinceAethiopia, ProvinceStatus.allied),
  	]);

    state.setupPieces([
      (Location.provinceNeapolis, Piece.fleetPraetorian0),
      (Location.provinceRavenna, Piece.fleetPraetorian1),
      (Location.provinceRome, Piece.praetorianGuard0),
      (Location.provinceRome, Piece.praetorianGuard1),
      (Location.provinceBritanniaSuperior, Piece.fleetBritish),
      (Location.provinceBritanniaSuperior, Piece.legionAugustaII),
      (Location.provinceBritanniaSuperior, Piece.legionHispanaIX),
      (Location.provinceBritanniaSuperior, Piece.legionGeminaXIVVeteran),
      (Location.provinceBritanniaSuperior, Piece.legionValeriaXXVeteran),
      (Location.provinceBritanniaSuperior, Piece.auxilia0Veteran),
      (Location.provinceBritanniaSuperior, Piece.auxilia1),
      (Location.provinceGermaniaInferior, Piece.fleetGerman),
      (Location.provinceGermaniaInferior, Piece.legionAlaudaeVVeteran),
      (Location.provinceGermaniaInferior, Piece.warGerman12),
      (Location.provinceGermaniaSuperior, Piece.legionAdiutrixI),
      (Location.provinceGermaniaSuperior, Piece.legionPrimigeniaXXII),
      (Location.provinceRhaetia, Piece.legionRapaxXXIVeteran),
      (Location.provinceRhaetia, Piece.auxilia2),
      (Location.provinceIllyria, Piece.legionClaudiaXI),
      (Location.provincePannoniaInferior, Piece.fleetPannonian),
      (Location.provincePannoniaInferior, Piece.legionGeminaVII),
      (Location.provincePannoniaInferior, Piece.auxilia4),
      (Location.provincePannoniaSuperior, Piece.legionGeminaXIIIVeteran),
      (Location.provincePannoniaSuperior, Piece.auxilia5),
      (Location.provinceMoesiaInferior, Piece.fleetMoesian),
      (Location.provinceMoesiaInferior, Piece.legionItalicaI),
      (Location.provinceMoesiaInferior, Piece.legionAugustaVIIIVeteran),
      (Location.provinceMoesiaSuperior, Piece.legionClaudiaVII),
      (Location.provinceMoesiaSuperior, Piece.auxilia6),
      (Location.provinceJudea, Piece.fleetSyrianVeteran),
      (Location.provinceJudea, Piece.legionMacedonicaVVeteran),
      (Location.provinceJudea, Piece.legionFretensisXVeteran),
      (Location.provinceJudea, Piece.legionFulminataXII),
      (Location.provinceJudea, Piece.legionApollinarisXVVeteran),
      (Location.provinceJudea, Piece.auxilia6Veteran),
      (Location.provinceJudea, Piece.auxilia7),
      (Location.provinceJudea, Piece.leaderSimeon),
      (Location.provinceJudea, Piece.warJudean8),
      (Location.provincePhoenicia, Piece.legionGallicaIII),
      (Location.provinceSyria, Piece.legionScythicaIV),
      (Location.provinceSyria, Piece.legionFerrataVI),
      (Location.provinceSyria, Piece.auxilia8Veteran),
      (Location.provinceSyria, Piece.auxilia9),
      (Location.provinceAlexandria, Piece.fleetAegyptianVeteran),
      (Location.provinceAlexandria, Piece.legionCyrenaicaIII),
      (Location.provinceAlexandria, Piece.legionDeiotarianaXXII),
      (Location.provinceNumidia, Piece.legionAugustaIII),
      (Location.provinceNumidia, Piece.auxilia10),
      (Location.provinceGallaecia, Piece.legionVictrixVIVeteran),
      (Location.provinceGallaecia, Piece.legionGeminaXVeteran),
      (Location.boxBarracks, Piece.praetorianGuard2),
      (Location.boxBarracks, Piece.fleetPontic),
      (Location.boxBarracks, Piece.legionAdiutrixII),
      (Location.boxBarracks, Piece.auxilia11),
      (Location.boxBarracks, Piece.auxilia12),
      (Location.boxBarracks, Piece.auxilia13),
      (Location.boxBarracks, Piece.auxilia14),
      (Location.boxBarracks, Piece.auxilia15),
      (Location.boxBarracks, Piece.auxilia16),
      (Location.boxBarracks, Piece.auxilia17),
      (Location.boxBarracks, Piece.auxilia18),
      (Location.boxBarracks, Piece.auxilia19),
      (Location.boxDestroyedLegions, Piece.legionGermanicaI),
      (Location.boxDestroyedLegions, Piece.legionMacedonicaIV),
      (Location.boxDestroyedLegions, Piece.legionPrimigeniaXV),
      (Location.boxDestroyedLegions, Piece.legionGallicaXVI),
      (Location.boxDestroyedLegions, Piece.legionVarianaXVII),
      (Location.boxDestroyedLegions, Piece.legionVarianaXVIII),
      (Location.boxDestroyedLegions, Piece.legionVarianaXIX),
    ]);

    return state;
  }

  factory GameState.setup138CE() {

    var state = GameState();

    state._turn = 20;
    state._gold = 50;
    state._prestige = 25;
    state._unrest = 3;

	  state.setupStatesmen([
		  (Piece.statesmanAntoninus, Location.commandCaesar, 52),
		  (Piece.statesmanArrian, Location.commandPontica, 50),
	  ]);

    state.setupEmperors([Piece.emperorsJulian, Piece.emperorsClaudian, Piece.emperorsFlavian, Piece.emperorsAdoptive]);

	  state.setupStatesmenPool([
      Piece.statesmanMarcus,
      Piece.statesmanLucius,
      Piece.statesmanAvidius,
      Piece.statesmanPompeianus,
      Piece.statesmanCommodus,
      Piece.statesmanLaetus,
      Piece.statesmanPertinax,
      Piece.statesmanJulianus,
      Piece.statesmanSeverus,
      Piece.statesmanNiger,
      Piece.statesmanAlbinus,
      Piece.statesmanPlautianus,
      Piece.statesmanCaracalla,
      Piece.statesmanMacrinus,
      Piece.statesmanElagabalus,
      Piece.statesmanAlexander,
      Piece.emperorsAntonine,
      Piece.emperorsSeveran,
    ]);

    state.setupWarsPool([
      Piece.leaderBallomar,
      Piece.leaderVologases,
      Piece.warAlamannic10,
      Piece.warAlan9,
      Piece.warBritish7,
      Piece.warBritish6,
      Piece.warCaledonian5,
      Piece.warCaledonian4,
      Piece.warDacian10,
      Piece.warGerman10,
      Piece.warGerman8,
      Piece.warMarcomannic13,
      Piece.warMarcomannic11,
      Piece.warMarcomannic9,
      Piece.warMoorish7,
      Piece.warMoorish5,
      Piece.warParthian14,
      Piece.warParthian12,
      Piece.warParthian10,
      Piece.warParthian8,
      Piece.warSarmatian10,
      Piece.warSarmatian8,
      Piece.warVandal9,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceCaledonia, ProvinceStatus.barbarian),
      (Location.provinceHibernia, ProvinceStatus.barbarian),
      (Location.provinceFrisia, ProvinceStatus.barbarian),
      (Location.provinceGermaniaMagna, ProvinceStatus.barbarian),
      (Location.provinceBoiohaemia, ProvinceStatus.allied),
      (Location.provinceQuadia, ProvinceStatus.barbarian),
      (Location.provinceSarmatia, ProvinceStatus.barbarian),
      (Location.provinceBosporus, ProvinceStatus.veteranAllied),
      (Location.provinceScythia, ProvinceStatus.allied),
      (Location.provinceAlbania, ProvinceStatus.veteranAllied),
      (Location.provinceArmeniaMajor, ProvinceStatus.barbarian),
      (Location.provinceCaucasia, ProvinceStatus.allied),
      (Location.provinceColchis, ProvinceStatus.veteranAllied),
      (Location.provinceIberia, ProvinceStatus.veteranAllied),
      (Location.provinceAssyria, ProvinceStatus.barbarian),
      (Location.provinceBabylonia, ProvinceStatus.barbarian),
      (Location.provinceJudea, ProvinceStatus.insurgent),
      (Location.provinceMesopotamia, ProvinceStatus.barbarian),
      (Location.provinceOsrhoene, ProvinceStatus.veteranAllied),
      (Location.provincePalmyra, ProvinceStatus.veteranAllied),
      (Location.provinceAethiopia, ProvinceStatus.allied),
  	]);

    state.setupPieces([
      (Location.provinceNeapolis, Piece.fleetPraetorian0),
      (Location.provinceRavenna, Piece.fleetPraetorian1),
      (Location.provinceRome, Piece.praetorianGuard0Veteran),
      (Location.provinceRome, Piece.praetorianGuard1),
      (Location.provinceBritanniaInferior, Piece.wall0),
      (Location.provinceBritanniaInferior, Piece.legionVictrixVIVeteran),
      (Location.provinceBritanniaInferior, Piece.legionValeriaXX),
      (Location.provinceBritanniaInferior, Piece.auxilia0Veteran),
      (Location.provinceBritanniaInferior, Piece.auxilia1),
      (Location.provinceBritanniaSuperior, Piece.fleetBritish),
      (Location.provinceBritanniaSuperior, Piece.legionAugustaII),
      (Location.provinceAgriDecumates, Piece.wall1),
      (Location.provinceAgriDecumates,Piece.legionPrimigeniaXXIIVeteran),
      (Location.provinceAgriDecumates, Piece.auxilia2Veteran),
      (Location.provinceGermaniaInferior, Piece.fleetGermanVeteran),
      (Location.provinceGermaniaInferior, Piece.legionMinerviaI),
      (Location.provinceGermaniaInferior, Piece.legionUlpiaXXXVeteran),
      (Location.provinceGermaniaSuperior, Piece.legionAugustaVIII),
      (Location.provinceGermaniaSuperior, Piece.auxilia3),
      (Location.provinceIllyria, Piece.legionClaudiaXI),
      (Location.provincePannoniaInferior, Piece.fleetPannonian),
      (Location.provincePannoniaInferior, Piece.legionAdiutrixIIVeteran),
      (Location.provincePannoniaInferior, Piece.auxilia4),
      (Location.provincePannoniaSuperior, Piece.legionGeminaX),
      (Location.provincePannoniaSuperior, Piece.legionGeminaXIVVeteran),
      (Location.provinceDaciaInferior, Piece.legionGeminaXIII),
      (Location.provinceDaciaSuperior, Piece.wall2),
      (Location.provinceDaciaSuperior, Piece.legionAdiutrixIVeteran),
      (Location.provinceDaciaSuperior, Piece.auxilia5Veteran),
      (Location.provinceDaciaSuperior, Piece.auxilia6),
      (Location.provinceMoesiaInferior, Piece.fleetMoesian),
      (Location.provinceMoesiaInferior, Piece.legionItalicaI),
      (Location.provinceMoesiaInferior, Piece.legionMacedonicaV),
      (Location.provinceMoesiaInferior, Piece.legionClaudiaXIVeteran),
      (Location.provinceMoesiaSuperior, Piece.legionFlaviaIV),
      (Location.provinceMoesiaSuperior, Piece.legionClaudiaVIIVeteran),
      (Location.provinceArmeniaMinor, Piece.fleetPontic),
      (Location.provinceArmeniaMinor, Piece.legionApollinarisXVVeteran),
      (Location.provinceArmeniaMinor, Piece.auxilia7),
      (Location.provinceCappadocia, Piece.legionFulminataXII),
      (Location.provinceCappadocia, Piece.auxilia8),
      (Location.provinceArabia, Piece.legionCyrenaicaIII),
      (Location.provinceArabia, Piece.auxilia9),
      (Location.provinceCommagene, Piece.legionFlaviaXVIVeteran),
      (Location.provinceJudea, Piece.legionFerrataVIVeteran),
      (Location.provinceJudea, Piece.legionFretensisXVeteran),
      (Location.provinceJudea, Piece.auxilia10Veteran),
      (Location.provincePhoenicia, Piece.legionGallicaIII),
      (Location.provinceSyria, Piece.fleetSyrian),
      (Location.provinceSyria, Piece.legionScythicaIV),
      (Location.provinceSyria, Piece.auxilia11),
      (Location.provinceAlexandria, Piece.fleetAegyptianVeteran),
      (Location.provinceAlexandria, Piece.legionTrajanaII),
      (Location.provinceNumidia, Piece.legionAugustaIII),
      (Location.provinceNumidia, Piece.auxilia12),
      (Location.provinceGallaecia, Piece.legionGeminaVII),
      (Location.provinceGallaecia, Piece.auxilia13),
      (Location.boxBarracks, Piece.praetorianGuard2),
      (Location.boxBarracks, Piece.wall3),
      (Location.boxBarracks, Piece.fleetBabylonian),
      (Location.boxBarracks, Piece.fleetBosporan),
      (Location.boxBarracks, Piece.auxilia14),
      (Location.boxBarracks, Piece.auxilia15),
      (Location.boxBarracks, Piece.auxilia16),
      (Location.boxBarracks, Piece.auxilia17),
      (Location.boxBarracks, Piece.auxilia18),
      (Location.boxBarracks, Piece.auxilia19),
      (Location.boxDestroyedLegions, Piece.legionGermanicaI),
      (Location.boxDestroyedLegions, Piece.legionMacedonicaIV),
      (Location.boxDestroyedLegions, Piece.legionAlaudaeV),
      (Location.boxDestroyedLegions, Piece.legionHispanaIX),
      (Location.boxDestroyedLegions, Piece.legionPrimigeniaXV),
      (Location.boxDestroyedLegions, Piece.legionGallicaXVI),
      (Location.boxDestroyedLegions, Piece.legionVarianaXVII),
      (Location.boxDestroyedLegions, Piece.legionVarianaXVIII),
      (Location.boxDestroyedLegions, Piece.legionVarianaXIX),
      (Location.boxDestroyedLegions, Piece.legionRapaxXXI),
      (Location.boxDestroyedLegions, Piece.legionDeiotarianaXXII),
    ]);

    return state;
  }

  factory GameState.setup222CE() {

    var state = GameState();

    state._turn = 30;
    state._gold = 50;
    state._prestige = 50;
    state._unrest = 4;

	  state.setupStatesmen([
		  (Piece.statesmanAlexander, Location.commandCaesar, 14),
	  ]);

    state.setupEmperors([Piece.emperorsJulian, Piece.emperorsClaudian, Piece.emperorsFlavian, Piece.emperorsAdoptive, Piece.emperorsAntonine, Piece.emperorsSeveran]);

	  state.setupStatesmenPool([
      Piece.statesmanMaximinus,
      Piece.statesmanGordian,
      Piece.statesmanTimesitheus,
      Piece.statesmanPhilip,
      Piece.statesmanDecius,
      Piece.statesmanGallus,
      Piece.statesmanAemilian,
      Piece.statesmanValerian,
      Piece.statesmanGallienus,
      Piece.statesmanOdaenath,
      Piece.statesmanPostumus,
      Piece.statesmanGothicus,
      Piece.statesmanAurelian,
      Piece.statesmanTacitus,
      Piece.statesmanProbus,
      Piece.statesmanCarus,
      Piece.statesmanCarinus,
      Piece.statesmanDiocletian,
      Piece.statesmanMaximian,
      Piece.statesmanCarausius,
      Piece.emperorsBarracks,
      Piece.emperorsIllyrian,
    ]);

    state.setupWarsPool([
      Piece.leaderChrocus,
      Piece.leaderKniva,
      Piece.leaderShapur,
      Piece.leaderZenobia,
      Piece.warAlamannic12,
      Piece.warAlamannic10,
      Piece.warBurgundian11,
      Piece.warDacian10,
      Piece.warFrankish11,
      Piece.warFrankish9,
      Piece.warGothic15,
      Piece.warGothic13,
      Piece.warMarcomannic11,
      Piece.warMoorish7,
      Piece.warMoorish5,
      Piece.warNubian6,
      Piece.warNubian4,
      Piece.warPalmyrene14,
      Piece.warPersian15,
      Piece.warPersian13,
      Piece.warPersian11,
      Piece.warPersian9,
      Piece.warSaxon6,
      Piece.warVandal9,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceCaledonia, ProvinceStatus.allied),
      (Location.provinceHibernia, ProvinceStatus.barbarian),
      (Location.provinceFrisia, ProvinceStatus.barbarian),
      (Location.provinceGermaniaMagna, ProvinceStatus.barbarian),
      (Location.provinceBoiohaemia, ProvinceStatus.barbarian),
      (Location.provinceQuadia, ProvinceStatus.barbarian),
      (Location.provinceSarmatia, ProvinceStatus.barbarian),
      (Location.provinceBosporus, ProvinceStatus.allied),
      (Location.provinceScythia, ProvinceStatus.allied),
      (Location.provinceAlbania, ProvinceStatus.allied),
      (Location.provinceArmeniaMajor, ProvinceStatus.allied),
      (Location.provinceCaucasia, ProvinceStatus.barbarian),
      (Location.provinceColchis, ProvinceStatus.veteranAllied),
      (Location.provinceIberia, ProvinceStatus.veteranAllied),
      (Location.provinceAssyria, ProvinceStatus.barbarian),
      (Location.provinceBabylonia, ProvinceStatus.barbarian),
      (Location.provincePalmyra, ProvinceStatus.veteranAllied),
      (Location.provinceAethiopia, ProvinceStatus.allied),
  	]);

    state.setupPieces([
      (Location.provinceMediolanum, Piece.imperialCavalry0),
      (Location.provinceNeapolis, Piece.fleetPraetorian0),
      (Location.provinceRavenna, Piece.fleetPraetorian1),
      (Location.provinceRome, Piece.praetorianGuard0Veteran),
      (Location.provinceRome, Piece.praetorianGuard1),
      (Location.provinceBritanniaInferior, Piece.wall0),
      (Location.provinceBritanniaInferior, Piece.legionVictrixVIVeteran),
      (Location.provinceBritanniaInferior, Piece.legionValeriaXX),
      (Location.provinceBritanniaInferior, Piece.auxilia0),
      (Location.provinceBritanniaSuperior, Piece.fleetBritish),
      (Location.provinceBritanniaSuperior, Piece.legionAugustaII),
      (Location.provinceAgriDecumates, Piece.wall1),
      (Location.provinceAgriDecumates,Piece.legionPrimigeniaXXIIVeteran),
      (Location.provinceAgriDecumates, Piece.auxilia1Veteran),
      (Location.provinceAgriDecumates, Piece.auxilia2),
      (Location.provinceGermaniaInferior, Piece.fleetGermanVeteran),
      (Location.provinceGermaniaInferior, Piece.legionMinerviaI),
      (Location.provinceGermaniaInferior, Piece.legionUlpiaXXXVeteran),
      (Location.provinceGermaniaSuperior, Piece.legionAugustaVIII),
      (Location.provinceGermaniaSuperior, Piece.auxilia3),
      (Location.provinceRhaetia, Piece.legionItalicaIII),
      (Location.provinceRhaetia, Piece.auxilia4),
      (Location.provinceNoricum, Piece.legionItalicaII),
      (Location.provinceNoricum, Piece.auxilia5),
      (Location.provincePannoniaInferior, Piece.fleetPannonian),
      (Location.provincePannoniaInferior, Piece.legionAdiutrixI),
      (Location.provincePannoniaInferior, Piece.legionAdiutrixIIVeteran),
      (Location.provincePannoniaSuperior, Piece.legionGeminaXVeteran),
      (Location.provincePannoniaSuperior, Piece.legionGeminaXIV),
      (Location.provincePannoniaSuperior, Piece.auxilia6Veteran),
      (Location.provincePannoniaSuperior, Piece.auxilia7),
      (Location.provinceDaciaInferior, Piece.legionGeminaXIII),
      (Location.provinceDaciaSuperior, Piece.wall2),
      (Location.provinceDaciaSuperior, Piece.legionMacedonicaVVeteran),
      (Location.provinceDaciaSuperior, Piece.auxilia8Veteran),
      (Location.provinceDaciaSuperior, Piece.auxilia9),
      (Location.provinceMoesiaInferior, Piece.fleetMoesian),
      (Location.provinceMoesiaInferior, Piece.legionItalicaI),
      (Location.provinceMoesiaInferior, Piece.legionClaudiaXIVeteran),
      (Location.provinceMoesiaSuperior, Piece.legionFlaviaIVVeteran),
      (Location.provinceMoesiaSuperior, Piece.legionClaudiaVIIVeteran),
      (Location.provinceArmeniaMinor, Piece.fleetPontic),
      (Location.provinceArmeniaMinor, Piece.legionApollinarisXV),
      (Location.provinceCappadocia, Piece.legionFulminataXII),
      (Location.provinceArabia, Piece.legionCyrenaicaIII),
      (Location.provinceArabia, Piece.auxilia10),
      (Location.provinceCommagene, Piece.legionFlaviaXVI),
      (Location.provinceJudea, Piece.legionFerrataVIVeteran),
      (Location.provinceJudea, Piece.legionFretensisX),
      (Location.provinceMesopotamia, Piece.wall3),
      (Location.provinceMesopotamia, Piece.legionParthicaIVeteran),
      (Location.provinceMesopotamia, Piece.legionParthicaIII),
      (Location.provinceMesopotamia, Piece.auxilia11Veteran),
      (Location.provinceMesopotamia, Piece.auxilia12),
      (Location.provinceOsrhoene, Piece.legionScythicaIV),
      (Location.provinceOsrhoene, Piece.auxilia13),
      (Location.provincePhoenicia, Piece.legionGallicaIIIVeteran),
      (Location.provinceSyria, Piece.fleetSyrian),
      (Location.provinceSyria, Piece.legionParthicaIIVeteran),
      (Location.provinceAlexandria, Piece.fleetAegyptian),
      (Location.provinceAlexandria, Piece.legionTrajanaII),
      (Location.provinceAfrica, Piece.fleetAfrican),
      (Location.provinceNumidia, Piece.legionAugustaIII),
      (Location.provinceNumidia, Piece.auxilia14),
      (Location.provinceGallaecia, Piece.legionGeminaVII),
      (Location.provinceGallaecia, Piece.auxilia15),
      (Location.boxBarracks, Piece.praetorianGuard2),
      (Location.boxBarracks, Piece.fleetBabylonian),
      (Location.boxBarracks, Piece.fleetBosporan),
      (Location.boxBarracks, Piece.auxilia16),
      (Location.boxBarracks, Piece.auxilia17),
      (Location.boxBarracks, Piece.auxilia18),
      (Location.boxBarracks, Piece.auxilia19),
      (Location.boxDestroyedLegions, Piece.legionGermanicaI),
      (Location.boxDestroyedLegions, Piece.legionMacedonicaIV),
      (Location.boxDestroyedLegions, Piece.legionAlaudaeV),
      (Location.boxDestroyedLegions, Piece.legionHispanaIX),
      (Location.boxDestroyedLegions, Piece.legionPrimigeniaXV),
      (Location.boxDestroyedLegions, Piece.legionGallicaXVI),
      (Location.boxDestroyedLegions, Piece.legionVarianaXVII),
      (Location.boxDestroyedLegions, Piece.legionVarianaXVIII),
      (Location.boxDestroyedLegions, Piece.legionVarianaXIX),
      (Location.boxDestroyedLegions, Piece.legionRapaxXXI),
      (Location.boxDestroyedLegions, Piece.legionDeiotarianaXXII),
    ]);

    return state;
  }

  factory GameState.fromScenario(Scenario scenario) {
    GameState? gameState;
    switch (scenario) {
    case Scenario.from27BceTo70Ce:
  	case Scenario.from27BceTo138Ce:
	  case Scenario.from27BceTo222Ce:
	  case Scenario.from27BceTo286Ce:
      gameState = GameState.setup27BCE();
	  case Scenario.from70CeTo138Ce:
	  case Scenario.from70CeTo222Ce:
  	case Scenario.from70CeTo286Ce:
		  gameState = GameState.setup70CE();
	  case Scenario.from138CeTo222Ce:
  	case Scenario.from138CeTo286Ce:
		  gameState = GameState.setup138CE();
	  case Scenario.from222CeTo286Ce:
		  gameState = GameState.setup222CE();
    }
    return gameState;
  }
}

enum Choice {
  renderUntoCaesar,
  breadAndCircusesPrestige,
  breadAndCircusesUnrest,
  fightWar,
  fightWarsForego,
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
  bankrupt,
  revolution,
  lostRome,
}

class GameOutcome {
  GameResult result;
  GameResultCause cause;
  int prestige;

  GameOutcome(this.result, this.cause, this.prestige);

  GameOutcome.fromJson(Map<String, dynamic> json) :
    result = GameResult.values[json['result'] as int],
    cause = GameResultCause.values[json['cause'] as int],
    prestige = json['prestige'] as int;

  Map<String, dynamic> toJson() => {
    'result': result.index,
    'cause': cause.index,
    'prestige': prestige,
  };
}

class GameOverException implements Exception {
  GameOutcome outcome;

  GameOverException(GameResult result, GameResultCause cause, int prestige) : outcome = GameOutcome(result, cause, prestige);
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

enum CaesarDeathCause {
  mortality,
  marchOnRome,
  assassination,
  adoption,
  disaster,
  unrest,
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

  PhaseStateEvent();

  PhaseStateEvent.fromJson(Map<String, dynamic> json) {
    eventsRemainingCount = json['eventsRemainingCount'] as int;
    final eventTypeIndex = json['eventType'] as int?;
    if (eventTypeIndex != null) {
      eventType = EventType.values[eventTypeIndex];
    } else {
      eventType = null;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
    'eventsRemainingCount': eventsRemainingCount,
    'eventType': eventType?.index,
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
}

class PhaseStateUnrest extends PhaseState {
  int breadAndCircusesPrestigeCount = 0;

  PhaseStateUnrest();

  PhaseStateUnrest.fromJson(Map<String, dynamic> json) :
    breadAndCircusesPrestigeCount = json['breadAndCircusesPrestigeCount'] as int;

  @override
  Map<String, dynamic> toJson() => {
    'breadAndCircusesPrestigeCount': breadAndCircusesPrestigeCount,
  };

  @override
  Phase get phase {
    return Phase.unrest;
  }
}

class PhaseStateWar extends PhaseState {
  List<Piece> warsFought = <Piece>[];
  List<Location> rebelsFought = <Location>[];
  List<Location> commandsFought = <Location>[];
  List<Location> provincesFought = <Location>[];
  List<Piece> unitsFought = <Piece>[];

  Piece? war;
  Location? province;
  Location? command;
  List<Location> provinces = <Location>[];
  List<Piece> units = <Piece>[];
  List<Piece> rebelUnits = <Piece>[];

  bool triumph = false;
  int lossCount = 0;
  int rebelLossCount = 0;
  int destroyLegionsCount = 0;
  int promoteCount = 0;
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
    warsFought = pieceListFromIndices(List<int>.from(json['warsFought']));
    rebelsFought = locationListFromIndices(List<int>.from(json['rebelsFought']));
    commandsFought = locationListFromIndices(List<int>.from(json['commandsFought']));
    provincesFought = locationListFromIndices(List<int>.from(json['provincesFought']));
    unitsFought = pieceListFromIndices(List<int>.from(json['unitsFought']));

    final warIndex = json['war'] as int?;
    if (warIndex != null) {
      war = Piece.values[warIndex];
    } else {
      war = null;
    }

    final provinceIndex = json['province'] as int?;
    if (provinceIndex != null) {
      province = Location.values[provinceIndex];
    } else {
      province = null;
    }

    final commandIndex = json['command'] as int?;
    if (commandIndex != null) {
      command = Location.values[commandIndex];
    } else {
      command = null;
    }

    provinces = locationListFromIndices(List<int>.from(json['provinces']));
    units = pieceListFromIndices(List<int>.from(json['units']));
    rebelUnits = pieceListFromIndices(List<int>.from(json['rebelUnits']));

    triumph = json['triumph'] as bool;
    lossCount = json['lossCount'] as int;
    rebelLossCount = json['rebelLossCount'] as int;
    destroyLegionsCount = json['destroyLegionsCount'] as int;
    promoteCount = json['promoteCount'] as int;
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
    'warsFought': pieceListToIndices(warsFought),
    'rebelsFought': locationListToIndices(rebelsFought),
    'commandsFought': locationListToIndices(commandsFought),
    'provincesFought': locationListToIndices(provincesFought),
    'unitsFought': pieceListToIndices(unitsFought),
    'war': war?.index,
    'province': province?.index,
    'command': command?.index,
    'provinces': locationListToIndices(provinces),
    'units': pieceListToIndices(units),
    'rebelUnits': pieceListToIndices(rebelUnits),
    'triumph': triumph,
    'lossCount': lossCount,
    'rebelLossCount': rebelLossCount,
    'destroyLegionsCount': destroyLegionsCount,
    'promoteCount': promoteCount,
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
    units.clear();
    rebelUnits.clear();

    lossCount = 0;
    rebelLossCount = 0;
    promoteCount = 0;
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
    return candidates;
  }

  List<Piece> candidateDestroyRebelLegions(GameState state) {
    final candidates = <Piece>[];
    for (final unit in rebelUnits) {
      if (unit.isType(PieceType.legion) && state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidateDismissUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in units) {
      if (!unit.isType(PieceType.legion) && state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidateDismissRebelUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in rebelUnits) {
      if (!unit.isType(PieceType.legion) && state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidateDemoteUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in units) {
      if (state.unitInPlay(unit) && state.unitVeteran(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidateDemoteRebelUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in rebelUnits) {
      if (state.unitInPlay(unit) && state.unitVeteran(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidatePromoteUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in units) {
      if (state.unitInPlay(unit) && !state.unitVeteran(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidatePromoteRebelUnits(GameState state) {
    final candidates = <Piece>[];
    for (final unit in rebelUnits) {
      if (state.unitInPlay(unit) && !state.unitVeteran(unit)) {
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
      if (state.spaceCanBeAnnexed(space)) {
				candidates.add(space);
			}
		}
    return candidates;
  }
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
  PhaseState? _phaseState;
  PlayerChoiceInfo _choiceInfo = PlayerChoiceInfo();
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
    case Scenario.from27BceTo70Ce:
      _firstTurn = 0;
		  _turnCount = 10;
		  _startYear = -26;
		  _endYear = 70;
	  case Scenario.from70CeTo138Ce:
      _firstTurn = 10;
		  _turnCount = 10;
		  _startYear = 70;
		  _endYear = 138;
	  case Scenario.from138CeTo222Ce:
		  _firstTurn = 20;
		  _turnCount = 10;
		  _startYear = 138;
		  _endYear = 222;
	  case Scenario.from222CeTo286Ce:
		  _firstTurn = 30;
		  _turnCount = 10;
		  _startYear = 222;
		  _endYear = 286;
  	case Scenario.from27BceTo138Ce:
		  _firstTurn = 0;
		  _turnCount = 20;
		  _startYear = -26;
		  _endYear = 138;
	  case Scenario.from70CeTo222Ce:
		  _firstTurn = 10;
		  _turnCount = 20;
		  _startYear = 70;
		  _endYear = 222;
  	case Scenario.from138CeTo286Ce:
		  _firstTurn = 20;
  		_turnCount = 20;
	  	_startYear = 138;
		  _endYear = 286;
	  case Scenario.from27BceTo222Ce:
      _firstTurn = 0;
      _turnCount = 30;
      _startYear = -26;
      _endYear = 222;
  	case Scenario.from70CeTo286Ce:
		  _firstTurn = 10;
      _turnCount = 30;
      _startYear = 70;
      _endYear = 286;
	  case Scenario.from27BceTo286Ce:
		  _firstTurn = 0;
      _turnCount = 40;
      _startYear = -26;
      _endYear = 286;
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

  void logTableHeader() {
    logLine('>|Effect|Value|');
    logLine('>|:---|:---:|');
  }

  void logTableFooter() {
    logLine('>');
  }

  // Randomness

  String redDieFace(int die) {
    return '![](resource:assets/images/d6_red_$die.png)';
  }

  String whiteDieFace(int die) {
    return '![](resource:assets/images/d6_white_$die.png)';
  }

  int rollD6() {
    int die = _random.nextInt(6) + 1;
    return die;
  }

  void logD6(int die) {
    logLine('>');
    logLine('>${whiteDieFace(die)}');
    logLine('>');
  }

  void logD6InTable(int die) {
    logLine('>|${whiteDieFace(die)}|$die|');
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
    return (d0, d1, omensModifier, d0 + d1 + omensModifier);
  }

  void log2D6((int,int,int,int) rolls) {
    int d0 = rolls.$1;
    int d1 = rolls.$2;
    logLine('>');
    logLine('>${whiteDieFace(d0)} ${whiteDieFace(d1)}');
    logLine('>');
  }

  void log2D6InTable((int,int,int,int) rolls) {
    int d0 = rolls.$1;
    int d1 = rolls.$2;
    int omensModifier = rolls.$3;
    logLine('>|${whiteDieFace(d0)} ${whiteDieFace(d1)}|${d0 + d1}|');
    if (omensModifier == 1) {
      logLine('>|Bad Omens|+1|');
    } else if (omensModifier == -1) {
      logLine('>|Good Omens|-1|');
    }
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
    return (d0, d1, d2, omensModifier, d0 + d1 + d2 + omensModifier);
  }

  void log3D6WithRed((int,int,int,int,int) rolls) {
    int d0 = rolls.$1;
    int d1 = rolls.$2;
    int d2 = rolls.$3;
    logLine('>');
    logLine('>${whiteDieFace(d0)} ${whiteDieFace(d1)} ${redDieFace(d2)}');
    logLine('>');
  }

  void log3D6InTable((int,int,int,int,int) rolls) {
    int d0 = rolls.$1;
    int d1 = rolls.$2;
    int d2 = rolls.$3;
    int omensModifier = rolls.$4;
    logLine('>|${whiteDieFace(d0)} ${whiteDieFace(d1)} ${whiteDieFace(d2)}|${d0 + d1 + d2}|');
    if (omensModifier == 1) {
      logLine('>|Bad Omens|+1|');
    } else if (omensModifier == -1) {
      logLine('>|Good Omens|-1|');
    }
  }
 
  void log3D6WithRedInTable((int,int,int,int,int) rolls) {
    int d0 = rolls.$1;
    int d1 = rolls.$2;
    int d2 = rolls.$3;
    int omensModifier = rolls.$4;
    logLine('>|${whiteDieFace(d0)} ${whiteDieFace(d1)} ${redDieFace(d2)}|${d0 + d1 + d2}|');
    if (omensModifier == 1) {
      logLine('>|Bad Omens|+1|');
    } else if (omensModifier == -1) {
      logLine('>|Good Omens|-1|');
    }
  }
 
  (int,int) rollAndLogD6D3() {
    int value = _random.nextInt(18);
    int d0 = value ~/ 3 + 1;
    int d1 = value % 3 + 1;
    logLine('>');
    logLine('>${whiteDieFace(d0)} ${whiteDieFace(d1)}');
    logLine('>');
    return (d0, d1);
  }

  (int,int) rollD6D2(bool d2Required) {
    int value = _random.nextInt(12);
    int d0 = value ~/ 2 + 1;
    int d1 = value % 2 + 1;
    return (d0, d1);
  }

  int rollD3() {
    int die = _random.nextInt(3) + 1;
    return die;
  }

  void logD3InTable(int die) {
    logLine('>|${whiteDieFace(die)}|$die|');
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

  void setProvinceStatus(Location province, ProvinceStatus status) {
    _state.setProvinceStatus(province, status);
    logLine('>${province.desc} to ${GameState.provinceStatusName(status)}.');
  }

  void provinceIncreaseStatus(Location province) {
    switch (_state.provinceStatus(province)) {
    case ProvinceStatus.barbarian:
      setProvinceStatus(province, ProvinceStatus.allied);
    case ProvinceStatus.allied:
      if (_state.emperorsActive(Piece.emperorsAdoptive)) {
        setProvinceStatus(province, ProvinceStatus.insurgent);
      } else {
        setProvinceStatus(province, ProvinceStatus.veteranAllied);
      }
    case ProvinceStatus.veteranAllied:
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
      if (_state.emperorsActive(Piece.emperorsAdoptive)) {
        setProvinceStatus(province, ProvinceStatus.allied);
      } else {
        setProvinceStatus(province, ProvinceStatus.veteranAllied);
      }
    case ProvinceStatus.veteranAllied:
      setProvinceStatus(province, ProvinceStatus.allied);
    case ProvinceStatus.allied:
      setProvinceStatus(province, ProvinceStatus.barbarian);
    case ProvinceStatus.barbarian:
    }
  }

  void adjustGold(int amount) {
    _state.adjustGold(amount);
    if (amount > 0) {
      logLine('>Gold: +$amount → ${_state.gold}');
    } else {
      logLine('>Gold: $amount → ${_state.gold}');
    }
  }

  void adjustPrestige(int amount) {
    _state.adjustPrestige(amount);
    if (amount > 0) {
      logLine('>Prestige: +$amount → ${_state.prestige}');
    } else {
      logLine('>Prestige: $amount → ${_state.prestige}');
    }
  }

  void adjustUnrest(int amount) {
    _state.adjustUnrest(amount);
    if (amount > 0) {
      logLine('>Unrest: +$amount → ${_state.unrest}');
    } else {
      logLine('>Unrest: $amount → ${_state.unrest}');
    }
  }

  void adjustPay(amount) {
    if (amount > 0) {
      logLine('>Pay: +$amount → ${_state.pay}');
    } else {
      logLine('>Pay: $amount → ${_state.pay}');
    }
  }

  String yearDesc(int turn) {
    double t = (turn - _firstTurn) / _turnCount;
    double yearDouble = (1 - t) * _startYear + t * _endYear;
	  int year = yearDouble.round();
    if (year <= 0) {
      return '${-year + 1} BCE';
    } else {
      return '$year  CE';
    }
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
    warsWithoutLeaders.shuffle(_random);
    leadersWithoutWars.shuffle(_random);
    for (final war in warsWithoutLeaders) {
      if (leadersWithoutWars.isEmpty) {
        break;
      }
      final leader = leadersWithoutWars[0];
      final land = _state.pieceLocation(war);
      logLine('>${leader.desc} leads ${war.desc} in ${land.desc}.');
      _state.setPieceLocation(leader, land);
      leadersWithoutWars.remove(leader);
    }
    for (final leader in leadersWithoutWars) {
      final location = _state.pieceLocation(leader);
      if (!location.isType(LocationType.homeland)) {
        final homeland = enemy.homeland;
        logLine('>${leader.desc} returns to Homeland.');
        _state.setPieceLocation(leader, homeland);
      }
    }
  }

  void checkDefeat() {
    if (_state.gold < 0) {
      throw GameOverException(GameResult.majorDefeat, GameResultCause.bankrupt, _state.prestige);
    }
    if (_state.unrest > 25) {
      throw GameOverException(GameResult.majorDefeat, GameResultCause.revolution, _state.prestige);
    }
    if (!_state.spaceInsurgentOrBetter(Location.provinceRome)) {
      throw GameOverException(GameResult.majorDefeat, GameResultCause.lostRome, _state.prestige);
    }
  }

  void checkVictory() {
    if (_state.prestige >= 200) {
      throw GameOverException(GameResult.majorVictory, GameResultCause.endured, _state.prestige);
    }
    if (_state.prestige >= 150) {
      throw GameOverException(GameResult.minorVictory, GameResultCause.endured, _state.prestige);
    }
    if (_state.prestige >= 100) {
      throw GameOverException(GameResult.draw, GameResultCause.endured, _state.prestige);
    }
    throw GameOverException(GameResult.minorDefeat, GameResultCause.endured, _state.prestige);
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;

    logLine('# Game Over');

    switch (outcome.result) {
    case GameResult.majorDefeat:
      logLine('### Major Defeat');
      switch (outcome.cause) {
      case GameResultCause.bankrupt:
        logLine('>The Empire is bankrupt.');
      case GameResultCause.revolution:
        logLine('>The Empire disintegrates due to high Unrest.');
      case GameResultCause.lostRome:
        logLine('>Rome falls.');
      case GameResultCause.endured:
      }
    case GameResult.minorDefeat:
      logLine('### Minor Defeat');
      logLine('>The Empire endures, with ${outcome.prestige} Prestige.');
    case GameResult.draw:
      logLine('### Draw');
      logLine('>The Empire is stable, with ${outcome.prestige} Prestige.');
    case GameResult.minorVictory:
      logLine('### Minor Victory');
      logLine('>The Empire prospers, with ${outcome.prestige} Prestige.');
    case GameResult.majorVictory:
      logLine('### Major Victory');
      logLine('>The Empire dominates its enemies, with ${outcome.prestige} Prestige.');
    }
  }

  void makeRebellionCheckForCommand(Location command) {
    logLine('### ${_state.commanderName(command)} considers Rebellion');

    final rolls = roll3D6();
    int omens = rolls.$4;
    int total = rolls.$5;
    int modifiers = 0;
    int modifier = 0;

    logTableHeader();
    log3D6InTable(rolls);
    int commanderPopularity = _state.commandPopularity(command);
    modifier = commanderPopularity;
    logLine('>|${_state.commanderName(command)}|+$modifier|');
    modifiers += modifier;
    modifier = _state.unrest;
    if (modifier != 0) {
      logLine('>|Unrest|+$modifier|');
      modifiers += modifier;
    }
    modifier = _state.piecesInLocationCount(PieceType.emperors, Location.boxEmperors);
    if (modifier != 0) {
      logLine('>|Emperors|+$modifier|');
      modifiers += modifier;
    }
    modifier = _state.eventTypeCount(EventType.rebellion);
    if (modifier != 0) {
      logLine('>|Rebellion|+$modifier|');
      modifiers += modifier;
    }
    int veteransModifier = 0;
    if (_state.emperorsActive(Piece.emperorsBarracks)) {
      veteransModifier = (_state.veteranUnitsInCommandCount(command) + 1) ~/ 2;
      modifier = veteransModifier;
      if (modifier != 0) {
        logLine('>|Veteran Units|+$modifier|');
        modifiers += modifier;
      }
    } else if (_state.emperorsActive(Piece.emperorsAntonine)) {
      veteransModifier = (_state.veteranLegionsInCommandCount(command) + 1) ~/ 2;
      modifier = veteransModifier;
      if (modifier != 0) {
        logLine('>|Veteran Legions|+$modifier|');
        modifiers += modifier;
      }
    }
    int caesarPopularity = _state.commandPopularity(Location.commandCaesar);
    modifier = -caesarPopularity;
    logLine('>${_state.commanderName(Location.commandCaesar)}|$modifier|');
    modifiers += modifier;

    int result = total + modifiers;
    logLine('>|Total|$result|');
    logTableFooter();

    if (result >= 25) {
      if (result - omens < 25) {
        logLine('>${_state.commanderName(command)} Rebels, in accordance with the Omens.');
      } else if (result - commanderPopularity + caesarPopularity < 25) {
        if (commanderPopularity > 3) {
          logLine('>Popular ${_state.commanderName(command)} Rebels.');
        } else {
          logLine('>${_state.commanderName(command)} Rebels against unpopular ${_state.commanderName(Location.commandCaesar)}.');
        }
      } else if (result - veteransModifier < 25) {
        logLine('>Veterans support ${_state.commanderName(command)} in Rebellion.');
      } else {
        logLine('>${_state.commanderName(command)} Rebels.');
      }
      _state.setCommandLoyalty(command, command);
      if (_state.pieceInLocation(PieceType.statesman, command) == null) {
        if (_state.commanderAge(command) == null) {
          _state.setCommanderAge(command, 3);
        }
      }
    } else {
      if (result - omens >= 25) {
        logLine('>${_state.commanderName(command)} remains Loyal, in accordance with the Omens.');
      } else if (result - commanderPopularity + caesarPopularity >= 25) {
        if (commanderPopularity < 3) {
          logLine('>${_state.commanderName(command)}’s unpopularity prevents any support for Rebellion.');
        } else {
          logLine('>Fearing ${_state.commanderName(Location.commandCaesar)}’s popularity, ${_state.commandName(command)} remains Loyal.');
        }
      } else {
        logLine('>${_state.commanderName(command)} remains Loyal.');
      }
    }
  }

  void rebellionEnds(Location command) {
    _state.setCommanderAge(command, null);
    for (final war in PieceType.war.pieces) {
      if (_state.pieceLocation(war) == command) {
        _state.setBarbarianOffmap(war);
      }
    }
    for (final otherCommand in LocationType.governorship.locations) {
      if (_state.commandLoyalty(otherCommand) == command) {
        _state.setCommandLoyalty(otherCommand, Location.commandCaesar);
      }
    }
  }

  void caesarAppointed(Piece? statesman, CaesarDeathCause cause, bool viaInheritance) {
    if (statesman == null) {
      logLine('>A new Caesar is appointed from the senatorial ranks.');
      _state.setCommanderAge(Location.commandCaesar, 3);
    } else {
      switch (cause) {
      case CaesarDeathCause.assassination:
      case CaesarDeathCause.marchOnRome:
        logLine('>${_state.statesmanName(statesman)} seizes the imperial purple.');
      default:
        if (viaInheritance) {
          logLine('>${_state.statesmanName(statesman)} inherits the imperial purple.');
        } else {
          logLine('>${_state.statesmanName(statesman)} is appointed Caesar.');
        }
      }
      _state.setPieceLocation(statesman, Location.commandCaesar);
    }
  }

  void rebelAppointedCaesar(Location command, CaesarDeathCause cause, bool viaInheritance) {
    Piece? rebelStatesman = _state.commandCommander(command);
    int? age;
    if (rebelStatesman == null) {
      age = _state.commanderAge(command);
    }
    rebellionEnds(command);
    if (rebelStatesman != null) {
      caesarAppointed(rebelStatesman, cause, viaInheritance);
    } else {
      switch (cause) {
      case CaesarDeathCause.assassination:
      case CaesarDeathCause.marchOnRome:
        logLine('>${_state.commanderName(command)} seizes the imperial purple.');
      default:
      if (viaInheritance) {
        logLine('>${_state.commanderName(command)} inherits the imperial purple.');
      } else {}
        logLine('>${_state.commanderName(command)} is appointed Caesar.');
      }
      _state.setCommanderAge(Location.commandCaesar, age);
    }
  }

  void commanderAppointedCaesar(Location command, CaesarDeathCause cause, bool viaInheritance) {
    final commander = _state.commandCommander(command);
    if (commander != null) {
      caesarAppointed(commander, cause, viaInheritance);
    } else {
      switch (cause) {
      case CaesarDeathCause.assassination:
      case CaesarDeathCause.marchOnRome:
        logLine('>${_state.commanderName(command)} seizes the imperial purple.');
      default:
        logLine('>${_state.commanderName(command)} appointed Caesar.');
      }
      int age = _state.commanderAge(command) ?? 3;
      _state.setCommanderAge(Location.commandCaesar, age);
    }
  }

  void commanderDies(Location command) {
    final statesman = _state.commandCommander(command);
    if (statesman != null) {
      _state.setPieceLocation(statesman, Location.offmap);
    }
    if (_state.commandIsRebelEmperor(command)) {
      rebellionEnds(command);
    }
  }

  Location? caesarDies(CaesarDeathCause cause, Location? rebelCommand) {
    final deadCaesar = _state.commandCommander(Location.commandCaesar);
    if (deadCaesar != null) {
      _state.setPieceLocation(deadCaesar, Location.offmap);
    }
    _state.caesarDeified = false;
    _state.setCommanderAge(Location.commandCaesar, null);

    if (cause == CaesarDeathCause.marchOnRome) {
      final rebelStatesman = _state.commandCommander(rebelCommand!);
      if (rebelStatesman == null || _state.statesmanMayBecomeCaesar(rebelStatesman)) {
        rebelAppointedCaesar(rebelCommand, cause, false);
        return rebelCommand;
      }
    }

    for (final emperors in PieceType.emperors.pieces) {
      if (_state.emperorsActive(emperors)) {
        for (final statesman in _state.emperorsImperialStatesmen(emperors)) {
          if (_state.statesmanInPlay(statesman)) {
            final location = _state.pieceLocation(statesman);
            Location? replacedByCommand;
            if (location.isType(LocationType.command)) {
              replacedByCommand = location;
            }
            if (location.isType(LocationType.governorship) && _state.commandIsRebelEmperor(location)) {
              rebelAppointedCaesar(location, cause, true);
            } else {
              caesarAppointed(statesman, cause, true);
            }
            return replacedByCommand;
          }
        }
      }
    }

    if (cause == CaesarDeathCause.assassination && _state.emperorsActive(Piece.emperorsClaudian)) {
      final prefect = _state.commandCommander(Location.commandPrefect);
      if (prefect == null || _state.statesmanMayBecomeCaesar(prefect)) {
        if (_state.commandIsRebelEmperor(Location.commandPrefect)) {
          rebelAppointedCaesar(Location.commandPrefect, cause, false);
        } else {
          commanderAppointedCaesar(Location.commandPrefect, cause, false);
        }
        return Location.commandPrefect;
      }
    }

    final rebelCommands = <Location>[];
    for (final command in LocationType.governorship.locations) {
      if (_state.commandIsRebelEmperor(command)) {
        final rebelCommander = _state.commandCommander(command);
        if (rebelCommander == null || _state.statesmanMayBecomeCaesar(rebelCommander)) {
          rebelCommands.add(command);
        }
      }
    }
    if (rebelCommands.isNotEmpty) {
      final command = randLocation(rebelCommands);
      rebelAppointedCaesar(command!, cause, false);
      return command;
    }

    final consul = _state.commandCommander(Location.commandConsul);
    if (consul == null || _state.statesmanMayBecomeCaesar(consul)) {
      commanderAppointedCaesar(Location.commandConsul, cause, false);
      return Location.commandConsul;
    }

    caesarAppointed(null, cause, false);
    return null;
  }

  void legionDestroy(Piece legion) {
    final province = _state.pieceLocation(legion);
    logLine('>${legion.desc} in ${province.desc} is Destroyed.');
    _state.setPieceLocation(legion, Location.boxDestroyedLegions);
  }

  void unitDismiss(Piece unit) {
    final province = _state.pieceLocation(unit);
    logLine('>${unit.desc} in ${province.desc} is Dismissed.');
    _state.setPieceLocation(unit, Location.boxBarracks);
  }

  void unitDemote(Piece unit) {
    final province = _state.pieceLocation(unit);
    logLine('>${unit.desc} in ${province.desc} is Demoted.');
    _state.flipUnit(unit);
  }

  void unitPromote(Piece unit) {
    final province = _state.pieceLocation(unit);
    logLine('>${unit.desc} in ${province.desc} is Promoted to Veteran.');
    _state.flipUnit(unit);
  }

  void annexProvince(Location province) {
    logLine('>${province.desc} is Annexed.');
    provinceIncreaseStatus(province);
    adjustPrestige(1);
  }

  void assassinationAttempt() {
    int die = rollD6();
    int modifiers = 0;
    int modifier = 0;

    logTableHeader();
    logD6InTable(die);
    modifier = _state.commandIntrigue(Location.commandCaesar);
    logLine('>${_state.commanderName(Location.commandCaesar)} Intrigue|+$modifier|');
    modifiers += modifier;
    modifier = _state.commandIntrigue(Location.commandPrefect);
    logLine('> ${_state.commanderName(Location.commandPrefect)} Intrigue|+$modifier|');
    modifiers += modifier;
    modifier = _state.emperorsCount;
    if (modifier > 0) {
      logLine('>|Emperors|+$modifier|');
      modifiers += modifier;
    }
    modifier = _state.eventTypeCount(EventType.conspiracy);
    if (modifier > 0) {
      logLine('>Conspiracy|+$modifier|');
      modifiers += modifier;
    }
    int conspiracyModifier = modifier;
    modifier = -_state.eventTypeCount(EventType.bodyguard);
    if (modifier < 0) {
      logLine('>|Bodyguards|$modifier|');
      modifiers += modifier;
    }
    int bodyguardsModifier = modifier;
    modifier = -_state.praetorianGuardCount(true);
    if (modifier < 0) {
      logLine('>|Praetorian Guards|$modifier|');
      modifiers += modifier;
    }
    int praetorianGuardsModifier = modifier;
    modifier = -_state.imperialCavalryCount(true);
    if (modifier < 0) {
      logLine('>|Imperial Cavalry|$modifier|');
      modifiers += modifier;
    }
    int imperialCavalryModifier = modifier;
    int result = die + modifiers;
    logLine('>|Total|$result|');
    logTableFooter();

    if (result < 12) {
      if (result - bodyguardsModifier >= 12) {
        logLine('>Attempt to Assassinate ${_state.commanderName(Location.commandCaesar)} is thwarted by Bodyguards.');
      } else if (result - praetorianGuardsModifier >= 12) {
        logLine('>Attempt to Assassinate ${_state.commanderName(Location.commandCaesar)} is thwarted by the Praetorian Guard.');
      }
      else if (result - imperialCavalryModifier >= 12) {
        logLine('>Attempt to Assassinate ${_state.commanderName(Location.commandCaesar)} is thwarted by the Imperial Cavalry.');
      } else {
        logLine('>A plot to Assassinate ${_state.commanderName(Location.commandCaesar)} is uncovered.');
      }
    } else {
      if (result - conspiracyModifier < 12) {
        logLine('>A Conspiracy led by ${_state.commanderName(Location.commandPrefect)} Assassinates ${_state.commanderName(Location.commandCaesar)}.');
      } else {
        logLine('>${_state.commanderName(Location.commandCaesar)} is Assassinated on the orders of ${_state.commanderName(Location.commandPrefect)}.');
      }
      adjustPrestige(-_state.commandAdministration(Location.commandCaesar));
      adjustUnrest(_state.commandPopularity(Location.commandCaesar));
      final replacementCommand = caesarDies(CaesarDeathCause.assassination, Location.commandPrefect);
      if (replacementCommand != Location.commandPrefect) {
        logLine('>${_state.commanderName(Location.commandPrefect)} is Killed.');
        commanderDies(Location.commandPrefect);
      }
    }
  }

  EventType randomEventType() {
		EventType? eventType;
		int discreteEventCount = _state.eventTypeDiscreteCount();
		if (discreteEventCount < 6) {
			while (eventType == null) {
        final rolls = rollAndLogD6D3();
				int eventIndex = (rolls.$1 - 1) * 3 + (rolls.$2 - 1);
        eventType = EventType.values[eventIndex];
				if (_state.eventTypeCount(eventType) == 2) {
					logLine('>${_state.eventTypeName(eventType)} is already doubled.');
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

  void Function() eventTypeHandler(EventType eventType, bool doubled) {
    final eventTypeHandlers = {
      EventType.adoption: [eventAdoption, eventAdoptionDoubled],
      EventType.assassin: [eventAssassin, eventAssassinDoubled],
      EventType.barbarian: [eventBarbarian, eventBarbarianDoubled],
      EventType.bodyguard: [eventBodyguard, eventBodyguardDoubled],
      EventType.colony: [eventColony, eventColonyDoubled],
      EventType.conquest: [eventConquest, eventConquestDoubled],
      EventType.conspiracy: [eventConspiracy, eventConspiracyDoubled],
      EventType.deification: [eventDeification, eventDeificationDoubled],
      EventType.inflation: [eventInflation, eventInflationDoubled],
      EventType.migration: [eventMigration, eventMigrationDoubled],
      EventType.mutiny: [eventMutiny, eventMutinyDoubled],
      EventType.omens: [eventOmens, eventOmensDoubled],
      EventType.persecution: [eventPersecution, eventPersecutionDoubled],
      EventType.plague: [eventPlague, eventPlagueDoubled],
      EventType.praetorians: [eventPraetorians, eventPraetoriansDoubled],
      EventType.rebellion: [eventRebellion, eventRebellionDoubled],
      EventType.terror: [eventTerror, eventTerrorDoubled],
      EventType.usurper: [eventUsurper, eventUsurperDoubled],
    };
    int index = doubled ? 1 : 0;
    return eventTypeHandlers[eventType]![index];
  }

  bool makeSupportCheck(Location command, Location rebelCommand) {
    logLine('### Support check for ${_state.commandName(command)}.');
    final rolls = roll2D6();
    int omens = rolls.$3;
    int total = rolls.$4;
    int modifiers = 0;
    int modifier = 0;

    logTableHeader();
    log2D6InTable(rolls);
    modifier = _state.commandIntrigue(command);
    logLine('>|${_state.commanderName(command)}|+$modifier|');
    modifiers += modifier;
    modifier = _state.commandIntrigue(rebelCommand);
    logLine('>|${_state.commanderName(rebelCommand)}|+$modifier|');
    modifiers += modifier;
    modifier = _state.eventTypeCount(EventType.rebellion);
    if (modifier != 0) {
      logLine('>|Rebellion|$modifier|');
      modifiers += modifiers;
    }
    modifier = -_state.commandIntrigue(Location.commandCaesar);
    logLine('>|${_state.commanderName(Location.commandCaesar)}|$modifier|');
    modifiers += modifier;
    int result = total + modifiers;
    logLine('>|Total|$result|');
    logTableFooter();

    if (result >= 10) {
      if (result - omens < 10) {
        logLine('>${_state.commandName(command)} switches Support to ${_state.commanderName(rebelCommand)}, in accordance with the Omens.');
      } else {
        logLine('>${_state.commandName(command)} switches Support to ${_state.commanderName(rebelCommand)}.');
      }
    } else {
      if (result - omens >= 10) {
        logLine('>${_state.commandName(command)} remains Loyal and Supports ${_state.commanderName(Location.commandCaesar)}, in accordance with the Omens.');
      } else {
        logLine('>${_state.commandName(command)} remains Loyal and Supports ${_state.commanderName(Location.commandCaesar)}.');
      }
    }
    return result >= 10;
  }

  bool failMortalityRoll(String name, int? age) {
    logLine('### Mortality Check for $name');
    bool hasSavingRoll = _options.finiteLifetimes && age != null && age <= 2;
    final rolls = rollD6D2(hasSavingRoll);
    int die = rolls.$1;
    int savingRoll = rolls.$2;
    int modifiers = 0;

    logTableHeader();
    logD6InTable(die);
    int plagueModifier = 0;
    if (_state.eventTypeCount(EventType.plague) == 2) {
      plagueModifier = 1;
      modifiers += plagueModifier;
      logLine('>|Plague|+1|');
    }
    if (_options.finiteLifetimes && age != null) {
      if (age > 3) {
        int modifier = age - 3;
        logLine('>|Age|+$modifier|');
        modifiers += modifier;
      }
    }
    int result = die + modifiers;
    logLine('>|Total|$result|');
    if (result == 6 && hasSavingRoll) {
      logD6InTable(savingRoll);
    }
    logTableFooter();

    bool fail = result >= 6 && (result != 6 || !hasSavingRoll || savingRoll != 1);
    if (fail) {
      if (result - plagueModifier < 6) {
        logLine('>$name succumbs to the Plague.');
      } else {
        logLine('>$name Dies.');
      }
    } else if (result >= 6) {
      logLine('>$name falls ill but recovers.');
    } else {
      logLine('>$name remains in good health.');
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

    logTableHeader();
    log2D6InTable(rolls);
    modifier = -_state.commandAdministration(Location.commandCaesar);
    logLine('>${_state.commanderName(Location.commandCaesar)} Administration|$modifier|');
    modifiers += modifier;
    modifier = -_state.commandAdministration(command);
    logLine('>|${_state.commanderName(command)} Administration|$modifier|');
    modifiers += modifier;
    if (_state.eventTypeCount(EventType.inflation) > 0) {
      modifier = _state.eventTypeCount(EventType.inflation);
      logLine('>|Inflation|+$modifier|');
      modifiers += modifier;
    }
    if (_state.eventTypeCount(EventType.colony) > 0) {
      modifier = -1;
      logLine('>|Colony|-1|');
      modifiers += modifier;
    }
    modifier = _options.taxRollModifier;
    if (modifier != 0) {
      if (modifier == 1) {
        logLine('>|Lower Tax Option|+1');
      } else if (modifier == -1) {
        logLine('>|Higher Tax Option|-1|');
      }
      modifiers += modifier;
    }
    int result = rollTotal + modifiers;
    logLine('>|Total|$result|');
    logTableFooter();

    int finalTotal = total;
    String doubledDesc = '';
    if (result <= 0) {
      finalTotal *= 2;
      doubledDesc = ' doubled to $finalTotal';
    }
    logLine('>Tax: $total$doubledDesc');

    return finalTotal;
  }

  void tax() {
    logLine('### Tax');
    int amount = 0;
    for (final command in LocationType.governorship.locations) {
      amount += taxCommand(command);
    }
    logLine('>');
    adjustGold(amount);
  }

  void pay() {
    logLine('### Pay Units');
    adjustGold(-_state.pay);
  }

  void renderUntoCaesar() {
	  final rolls = roll2D6();
    log2D6(rolls);
    int total = rolls.$4;
    adjustGold(total);
    adjustUnrest(1);
    adjustPrestige(-1);
  }

  int moveWarPriority(Piece war, Location? displaceSpace, Location connectedSpace, ConnectionType connectionType) {
    bool spaceAlliedOrBetter = _state.spaceAlliedOrBetter(connectedSpace);
    bool roadLike = connectionType == ConnectionType.road;
    bool seaLike = connectionType == ConnectionType.sea;
    int navalStrength = _state.warNavalStrength(war);
    if (seaLike) {
      if (navalStrength >= 2) {
        seaLike = false;
      }
      if (navalStrength >= 3) {
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
    if (spaceAlliedOrBetter) {
      priority += 1;
    }
    // By analogy with Rome, IInc.
    priority *= 16;
    if (!spaceAlliedOrBetter) {
      priority += max(15 - _state.spaceAlliedOrBetterDistance(connectedSpace, war), 0);
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

    logLine('>');
    logLine('>${war.desc} Pillage');
    final roll = rollD6();
    int modifiers = 0;
    int modifier = 0;

    logTableHeader();
    if (leader != null) {
      modifier = _state.leaderPillage(leader);
      logLine('>|${leader.desc}|+$modifier|');
      modifiers += modifier;
    }
    modifier = _state.eventTypeCount(EventType.migration);
    if (modifier != 0) {
      logLine('>|Migration|+$modifier|');
      modifiers += modifier;
    }
    modifier = 0;
    switch (_state.provinceStatus(province)) {
    case ProvinceStatus.insurgent:
      modifier = 1;
      logLine('>|Insurgent|+1|');
    case ProvinceStatus.allied:
      modifier = -1;
      logLine('>|Allied|-1|');
    case ProvinceStatus.veteranAllied:
      modifier = -2;
      logLine('>|Veteran Allied|-2|');
    default:
    }
    modifiers += modifier;
    modifier = -_state.mobileLandUnitsInSpaceCount(province, false);
    if (modifier != 0) {
      logLine('>|Units|$modifier|');
      modifiers += modifier;
    }
    int result = roll + modifiers;
    logLine('>Total|$result|');
    logTableFooter();

    return result >= 4;
  }

  void logWarMove(String piecesDesc, String verb, List<Location> path) {
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
    logLine('>$piecesDesc $verb ${pathDesc}to ${path[path.length - 1].desc}.');
  }

  Piece? randomLeaderInSpace(Location space) {
    final leaders = _state.piecesInLocation(PieceType.leader, space);
    if (leaders.isEmpty) {
      return null;
    }
    return randPiece(leaders);
  }

  void moveWar(Piece war, Location? displaceSpace, Piece? ignoreWar) {
    final phaseState = _phaseState as PhaseStateTreasury;
    if (displaceSpace == null) {
      phaseState.setWarUnmoved(war, false);
    }
    int pillageRollCount = displaceSpace != null ? 1 : 0;
    final originSpace = _state.pieceLocation(war);
    final warTrail = phaseState.warTrail(war);
    warTrail.add(originSpace);
    if (displaceSpace == null && _state.spaceAlliedOrBetter(originSpace)) {
      pillageRollCount += 1;
      final pillage = determinePillage(war);
      if (!pillage) {
        logLine('>${war.desc} remains in ${originSpace.desc}.');
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
          logWarMove(pieceNames, verb, logPath);
          logPath.clear();
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
        if (_state.spaceAlliedOrBetter(nextSpace)) {
          terminate = pillageRollCount > 0;
          if (pillageRollCount == 0) {
            logWarMove(pieceNames, verb, logPath);
            logPath .clear();
            verb = 'continues';
            if (leader != null) {
              verb = 'continue';
            }
            pillageRollCount += 1;
            bool pillage = determinePillage(war);
            if (!pillage) {
              logLine('>${war.desc} halts in ${nextSpace.desc}.');
              terminate = true;
            }
          }
        }
      }
    }
    logWarMove(pieceNames, verb, logPath);
  }

  void emperorsAdded(Piece emperors) {
    var barracksPieces = <Piece>[];
    switch (emperors) {
    case Piece.emperorsJulian:
      logLine('>Praetorian Icon added to Rome');
      logLine('>Praetorian Guard,Pannonian and Pontic Fleets,XV Primigenia and XXII Primigenia Legions added to Barracks');
      logLine('>Prefect may attempt to Assassinate Caesar');
      barracksPieces = [
        Piece.praetorianGuard1,
        Piece.fleetPannonian,
        Piece.fleetPontic,
        Piece.legionPrimigeniaXV,
        Piece.legionPrimigeniaXXII,
      ];
    case Piece.emperorsClaudian:
      logLine('>Praetorian Icon added to Rome');
      logLine('>Praetorian Guard,British and Syrian Fleets,I Italica,I Adiutrix,II Adiutrix and VII Gemina Legions added to Barracks');
      logLine('>Non-Imperial Statesmen may become Caesar');
      logLine('>Prefect becomes Caesar following Assassination');
      barracksPieces = [
        Piece.praetorianGuard2,
        Piece.fleetBritish,
        Piece.fleetSyrian,
        Piece.legionItalicaI,
        Piece.legionAdiutrixI,
        Piece.legionAdiutrixII,
        Piece.legionGeminaVII,
      ];
    case Piece.emperorsFlavian:
      logLine('>Fleet Icon added to Syria');
      logLine('>2 Walls,Bosporan Fleet,I Minervia,IV Flavia and XVI Flavia Legions added to Barracks');
      logLine('>Pay Increased.');
      logLine('>Caesar may Fight Wars.');
      barracksPieces = [
        Piece.wall0,
        Piece.wall1,
        Piece.fleetBosporan,
        Piece.legionMinerviaI,
        Piece.legionFlaviaIV,
        Piece.legionFlaviaXVI,
      ];
    case Piece.emperorsAdoptive:
      logLine('>2 Walls,Babylonian Fleet,II Trajana and XXX Ulpia Legions added to Barracks');
      logLine('>Provinces no longer become Veteran Allied');
      barracksPieces = [
        Piece.wall2,
        Piece.wall3,
        Piece.fleetBabylonian,
        Piece.legionTrajanaII,
        Piece.legionUlpiaXXX,
      ];
    case Piece.emperorsAntonine:
      logLine('>Legion Icons added to Rhaetia and Noricum');
      logLine('>Fleet Icon added to Africa');
      logLine('>African Fleet,II Italica and III Italica Legions added to Barracks');
      logLine('>No per-turn Annexations');
      barracksPieces = [
        Piece.fleetAfrican,
        Piece.legionItalicaII,
        Piece.legionItalicaIII,
      ];
    case Piece.emperorsSeveran:
      logLine('>Imperial Cavalry,I Parthica,II Parthica and III Parthica Legions added to Barracks');
      logLine('>Pay Increased.');
      logLine('>Praetorian Guards Transfer for Free');
      logLine('>Statesmen with Prefect Ability may become Caesar');
      logLine('>Legions may be Built in and Transfer to Italian Provinces');
      logLine('>Stacking Restrictions changed');
      barracksPieces = [
        Piece.imperialCavalry0,
        Piece.legionParthicaI,
        Piece.legionParthicaII,
        Piece.legionParthicaIII,
      ];
    case Piece.emperorsBarracks:
      logLine('>Imperial Cavalry and IV Italica Legion added to Barracks');
      logLine('>Imperial Cavalry Transfer for Free');
      logLine('>Prefect may Rebel');
      logLine('>Veteran Legions increase risk of Rebellion');
      barracksPieces = [
        Piece.imperialCavalry1,
        Piece.legionItalicaIV,
      ];
    case Piece.emperorsIllyrian:
      logLine('>Imperial Cavalry and I Illyricorum Legion added to Barracks');
      logLine('>Caesar may Fight an additional War after each Triumph');
      barracksPieces = [
        Piece.imperialCavalry2,
        Piece.legionIllyricorumI,
      ];
    default:
    }
    for (final piece in barracksPieces) {
      _state.setPieceLocation(piece, Location.boxBarracks);
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
    final command = _state.provinceCommand(province);
    final leader = _state.pieceInLocation(PieceType.leader, province);
    final war = _state.pieceInLocation(PieceType.war, province);
    final hasWall = _state.piecesInLocationCount(PieceType.wall, province) > 0;
    final hasFleet = _state.piecesInLocationCount(PieceType.fleet, province) > 0;
    final status = _state.provinceStatus(province);

    int modifiers = 0;
    int modifier = 0;
    if (leader != null) {
      modifier = _state.leaderPillage(leader);
      if (log) {
        logLine('>|${leader.desc}|+$modifier|');
      }
      modifiers += modifier;
    }
    if (war != null) {
      modifier = 3;
      if (log) {
        logLine('>|${war.desc}|+$modifier|');
      }
      modifiers += modifier;
    }

    bool connectedToHomelandOrBarbarianProvince = false;
    for (final connection in _state.spaceConnections(province)) {
      final connectedSpace = connection.$1;
      final connectionType = connection.$2;
      bool negated = false;
      bool mitigated = status == ProvinceStatus.allied || status == ProvinceStatus.veteranAllied;
      switch (connectionType) {
      case ConnectionType.road:
      case ConnectionType.desert:
      case ConnectionType.mountain:
        if (hasWall) {
          mitigated = true;
        }
      case ConnectionType.river:
        if (!ignoreMobileUnits && hasFleet) {
          mitigated = true;
        }
      case ConnectionType.sea:
        negated = true;
      }
      if (!negated) {
        if (!_state.spaceAlliedOrBetter(connectedSpace)) {
          connectedToHomelandOrBarbarianProvince = true;
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
              logLine('>|${connectedSpace.desc}|+$modifier|');
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
              logLine('>|${connectedWar.desc}|+$modifier|');
            }
            modifiers += modifier;
          }
        }
      }
      if (connectedSpace.isType(LocationType.homeland)) {
        for (final connectedLeader in _state.piecesInLocation(PieceType.leader, connectedSpace)) {
          modifier = 1;
          if (log) {
            logLine('>|${connectedLeader.desc}|+$modifier|');
          }
          modifiers += modifier;
        }
      }
    }

    if (status == ProvinceStatus.insurgent) {
      modifier = 1;
      if (log) {
        logLine('>|Insurgent|+1|');
      }
      modifiers += modifier;
    }

    if (connectedToHomelandOrBarbarianProvince) {
      modifier = _state.eventTypeCount(EventType.barbarian);
      if (modifier != 0) {
        if (log) {
          logLine('>|Barbarian|+1|');
          modifiers += modifier;
        }
      }
    }
    if (_state.eventTypeCount(EventType.colony) == 2) {
      modifier = -1;
      if (log) {
        logLine('>|Colony|-1|');
      }
      modifiers += modifier;

    }
    if (!ignoreMobileUnits) {
      modifier = 0;
      modifier -= _state.piecesInLocationCount(PieceType.legion, province);
      modifier -= _state.piecesInLocationCount(PieceType.auxilia, province);
      if (command == Location.commandPrefect) {
        modifier -= _state.piecesInLocationCount(PieceType.praetorianGuard, province);
        modifier -= _state.piecesInLocationCount(PieceType.imperialCavalry, province);
      }
      if (modifier != 0) {
        if (log) {
          logLine('>|Units|$modifier|');
        }
        modifiers += modifier;
      }
    }

    if (status == ProvinceStatus.allied) {
      modifier = -1;
      if (log) {
        logLine('>|Allied|-1|');
      }
      modifiers += modifier;
    } else if (status == ProvinceStatus.veteranAllied) {
      modifier = -2;
      if (log) {
        logLine('>|Veteran Allied|-2|');
      }
      modifiers += modifier;
    }
    return modifiers;
  }

  int provinceRevoltCheck(Location province) {
    final status = _state.provinceStatus(province);
    final war = _state.pieceInLocation(PieceType.war, province);
    int modifiers = calculateProvinceRevoltModifier(province, false, false);
    if ((status != ProvinceStatus.insurgent || war != null) && modifiers <= 0) {
      return 0;
    }
    logLine('### ${province.desc}');
    int roll = rollD6();

    logTableHeader();
    logD6InTable(roll);
    modifiers = calculateProvinceRevoltModifier(province, false, true);
    int result = roll + modifiers;
    logLine('>|Total|$result|');
    logTableFooter();
   
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

  void makeRevoltChecks() {
		final revoltProvinces = <Location>[];
		final romanizationProvinces = <Location>[];

		for (final province in LocationType.province.locations) {
      if (_state.spaceAlliedOrBetter(province)) {
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
		if (revoltProvinces.isNotEmpty) {
      logLine('### Revolt');
			int unrestAmount = 0;
			for (final province in revoltProvinces) {
				if (_state.provinceStatus(province) == ProvinceStatus.roman) {
					unrestAmount += 1;
				}
				provinceDecreaseStatus(province);
			}
      adjustPrestige(-revoltProvinces.length);
      adjustUnrest(unrestAmount);
		}
		if (romanizationProvinces.isNotEmpty) {
      logLine('### Romanization');
			for (final province in romanizationProvinces) {
				provinceIncreaseStatus(province);
			}
      adjustPrestige(romanizationProvinces.length);
		}
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
    for (final command in LocationType.governorship.locations) {
      if (_state.commandIsRebelEmperor(command) && !phaseState.rebelsFought.contains(command)) {
        rebels.add(command);
      }
    }
    return rebels;
  }

  void fightWar(Location warProvince, Location warCommand, List<Location> warProvinces) {
    final phaseState = _phaseState as PhaseStateWar;
    final war = _state.pieceInLocation(PieceType.war, warProvince)!;
    final enemy = _state.warEnemy(war);
    final leader = _state.pieceInLocation(PieceType.leader, warProvince);
    final warUnits = <Piece>[];
    final warFleets = <Piece>[];
    final general = _state.commandCommander(warCommand);
    final useImperialUnits = _state.commandMayUseImperialUnits(warCommand);
    for (final unit in PieceType.mobileUnit.pieces) {
      final location = _state.pieceLocation(unit);
      if (warProvinces.contains(location) && !phaseState.unitsFought.contains(unit)) {
        if (unit.isType(PieceType.fleet)) {
          warFleets.add(unit);
        } else if (useImperialUnits || (!unit.isType(PieceType.praetorianGuard) && !unit.isType(PieceType.imperialCavalry))) {
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
    if (general != null) {
      final ability = _state.statesmanAbility(general);
      switch (ability) {
      case Ability.conquest:
        conquestAbility = true;
      case Ability.stalemate:
        stalemateAbility = true;
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
          logLine('>${_state.statesmanName(general!)} averts Disaster.');
        } else if (stalemateAbility) {
          disaster = false;
          logLine('>${_state.statesmanName(general!)} averts Disaster.');
          stalemate = true;
        }
      } else {
        if (matchingWarAbility) {
          logLine('>${_state.statesmanName(general!)} breaks the Stalemate.');
        } else {
          stalemate = true;
        }
      }
      if (disaster) {
        if (d3 != d1) {
          logLine('>Low morale resulting from Persecution leads to Disaster.');
        }
      }
    }
  
    bool draw = false;
    bool triumph = false;

    if (disaster) {
      logLine('>Campaign against $warDesc ends in Disaster.');
    } else if (stalemate) {
      logLine('>Campaign against $warDesc results in a Stalemate.');
    } else {
      int modifiers = 0;
      int modifier = 0;

      logTableHeader();
      log3D6WithRedInTable(rolls);
      modifier = _state.warStrength(war);
      logLine('>|${war.desc}|+$modifier|');
      modifiers += modifier;
      if (leader != null) {
        modifier = _state.leaderStrength(leader);
        logLine('>|${leader.desc}|+$modifier|');
        modifiers += modifier;
      }
      final spaces = _state.spaceConnectedSpaces(warProvince);
      spaces.add(warProvince);
      for (final space in spaces) {
        if (space.isType(LocationType.homeland)) {
          if (space == _state.warHomeland(war)) {
            modifier = 2;
          } else {
            modifier = 1;
          }
          logLine('>|${space.desc}|+$modifier|');
          modifiers += modifier;
        } else {
          modifier = 0;
          final status = _state.provinceStatus(space);
          switch (status) {
          case ProvinceStatus.barbarian:
            modifier = 1;
          case ProvinceStatus.allied:
            if (warProvinces.contains(space)) {
              modifier = -1;
            }
          case ProvinceStatus.veteranAllied:
            if (warProvinces.contains(space)) {
              modifier = -2;
            }
          case ProvinceStatus.insurgent:
          case ProvinceStatus.roman:
          }
          if (modifier > 0) {
            logLine('>|${space.desc}|+$modifier|');
          } else if (modifier < 0) {
            logLine('>|${space.desc}|$modifier|');
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
        logLine('>|Units|$modifier|');
        modifiers += modifier;
      }
      if (matchingWarAbility) {
        modifier = -1;
        logLine('>|${_state.statesmanName(general!)} Ability|-1|');
        modifiers += modifier;
      }
      modifier = -_state.commandMilitary(warCommand);
      logLine('>|${_state.commanderName(warCommand)}|$modifier|');
      modifiers += modifier;

      modifier = _options.warRollModifier;
      if (modifier != 0) {
        if (modifier == 1) {
          logLine('> Harder Wars Option|+1|');
        } else if (modifier == -1) {
          logLine('> Easier Wars Option|-1|');
        }
        modifiers += modifier;
      }
      int result = total + modifiers;
      logLine('>|Total|$result|');
      logTableFooter();

      if (result >= 12) {
        if (matchingWarAbility) {
          draw = true;
          logLine('>${_state.statesmanName(general!)} narrowly avoids Defeat.');
          logLine('>Campaign against $warDesc results in a Draw.');
        } else if (stalemateAbility) {
          stalemate = true;
          logLine('>${_state.statesmanName(general!)} narrowly avoids Defeat.');
          logLine('>Campaign against $warDesc results in a Stalemate.');
        } else {
          if (result - omens < 12) {
            logLine('>Campaign against $warDesc ends in Defeat, in accordance with the Omens.');
          } else {
            logLine('>Campaign against $warDesc ends in Defeat.');
          }
        }
      } else if (result >= 10) {
        draw = true;
        logLine('>Campaign against $warDesc results in a Draw.');
      } else {
        int fleetStrength = 0;
        for (final fleet in warFleets) {
          if (fleet.isType(PieceType.fleetVeteran)) {
            fleetStrength += 2;
          } else {
            fleetStrength += 1;
          }
        }
        if (fleetStrength >= _state.warNavalStrength(war)) {
          triumph = true;
          if (result - omens >= 10) {
            logLine('>Campaign against $warDesc end in Triumph, in accordance with the Omens.');
          } else {
            logLine('>Campaign against $warDesc ends in Triumph.');
          }
        } else {
          draw = true;
          logLine('>Campaign against $warDesc results in a Draw due to a shortage of Fleets.');
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
      promoteCount = 1;
    }

    String lossesDesc = lossCount == 1 ? 'Loss' : 'Losses';
    logLine('>Campaign incurs $lossCount $lossesDesc.');

    if (disaster) {
      logLine('>${_state.commanderName(warCommand)} is Killed.');
      if (warCommand == Location.commandCaesar) {
        caesarDies(CaesarDeathCause.disaster, null);
      } else {
        commanderDies(warCommand);
      }
      adjustUnrest(lossCount);
      adjustPrestige(-lossCount);
    }

    if (triumph) {
      _state.setPieceLocation(war, warCommand);
      if (leader != null) {
        redistributeEnemyLeaders(enemy);
      }
      gold = _state.warStrength(war) * _state.commandAdministration(warCommand);
      prestigeUnrest = (_state.warStrength(war) + 1) ~/ 2;
      if (!_state.commandLoyal(warCommand)) {
        rebelGold = gold;
        gold = 0;
        prestigeUnrest = 0;
      }

      annexCount = 1;
      if (conquestAbility || matchingWarAbility) {
        annexCount += 1;
      }
      final caesar = _state.commandCommander(Location.commandCaesar);
      if (caesar != null && _state.statesmanAbility(caesar) == Ability.conquest) {
        annexCount += 1;
      }
      if (_state.eventTypeCount(EventType.conquest) == 2) {
        annexCount += 1;
      }
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

  void fightRebel(Location rebelCommand) {
    final phaseState = _phaseState as PhaseStateWar;
    int loyalStrength = 0;
    int rebelStrength = 0;
    for (final unit in PieceType.mobileUnit.pieces) {
      if (unit.isType(PieceType.legion) || unit.isType(PieceType.praetorianGuard) || unit.isType(PieceType.imperialCavalry)) {
        final unitLocation = _state.pieceLocation(unit);
        if (unitLocation.isType(LocationType.province)) {
          final unitCommand = _state.provinceCommand(unitLocation);
          int unitStrength = _state.unitVeteran(unit) ? 2 : 1;
          final loyalty = _state.commandLoyalty(unitCommand);
          if (loyalty == Location.commandCaesar) {
            phaseState.units.add(unit);
            loyalStrength += unitStrength;
          } else if (loyalty == rebelCommand) {
            phaseState.rebelUnits.add(unit);
            rebelStrength += unitStrength;
          }
        }
      }
    }

    bool marchOnRome = false;
    bool stalemate = false;
    bool rebellionCrushed = false;

    logLine('### ${_state.commanderName(Location.commandCaesar)} vs. ${_state.commanderName(rebelCommand)}');

    final rolls = roll3D6();
    final d3 = rolls.$3;
    final omens = rolls.$4;
    final total = rolls.$5;

    int modifiers = 0;
    int modifier = 0;

    logTableHeader();
    modifier = _state.commandMilitary(rebelCommand);
    logLine('>|${_state.commanderName(rebelCommand)}|+$modifier|');
    modifiers += modifier;
    modifier = rebelStrength;
    logLine('>|Rebel Units|+$modifier|');
    modifiers += modifier;
    modifier = -loyalStrength;
    logLine('>|Loyal Units|$modifier|');
    modifiers += modifier;
    modifier = -_state.commandMilitary(Location.commandCaesar);
    logLine('>|${_state.commanderName(Location.commandCaesar)}|$modifier|');
    modifiers += modifier;
    int result = total + modifiers;
    logLine('>|Total|$result|');
    logTableFooter();

    int lossCount = d3;
    int rebelLossCount = 0;
    int loyalPromoteCount = 0;
    int rebelPromoteCount = 0;

    if (result >= 12) {
      marchOnRome = true;
      if (result - omens < 12) {
        logLine('>${_state.commanderName(rebelCommand)} Marches on Rome, in accordance with the Omens.');
      } else {
        logLine('>${_state.commanderName(rebelCommand)} Marches on Rome.');
      }
    } else if (result >= 10) {
      stalemate = true;
      logLine('>Civil War with ${_state.commanderName(rebelCommand)} is a Stalemate.');
    } else {
      rebellionCrushed = true;
      if (result - omens >= 10) {
        logLine('>Civil War ends with ${_state.commanderName(rebelCommand)} being Crushed, in accordance with the Omens.');
      } else {
        logLine('>Civil War ends with ${_state.commanderName(rebelCommand)} being Crushed.');
      }
    }

    String lossesDesc = lossCount == 1 ? 'Loss' : 'Losses';
    logLine('>Civil War incurs $lossCount $lossesDesc.');

    if (marchOnRome) {
      logLine('>${_state.commanderName(Location.commandCaesar)} is overthrown.');
      int prestigeAmount = -_state.commandAdministration(Location.commandCaesar);
      int unrestAmount = _state.commandPopularity(Location.commandCaesar);
      adjustUnrest(unrestAmount);
      adjustPrestige(prestigeAmount);
      caesarDies(CaesarDeathCause.marchOnRome, rebelCommand);
      rebelPromoteCount = 1;
    }
    if (stalemate) {
      rebelLossCount = (d3 + 1) ~/ 2;
      loyalPromoteCount = 1;
    }
    if (rebellionCrushed) {
      int amount = _state.commandRebelEmperorLoyaltyCount(rebelCommand);
      logLine('>${_state.commanderName(rebelCommand)} is Killed.');
      commanderDies(rebelCommand);
      rebellionEnds(rebelCommand);
      adjustUnrest(-amount);
      adjustPrestige(amount);
      loyalPromoteCount = 1;
    }

    phaseState.lossCount = lossCount;
    phaseState.rebelLossCount = rebelLossCount;
    phaseState.promoteCount = loyalPromoteCount;
    phaseState.rebelPromoteCount = rebelPromoteCount;
  }

  void advanceScenario() {

    const scenarioStatesmen = [
      [
        Piece.statesmanTiberius,
        Piece.statesmanDrusus,
        Piece.statesmanGermanicus,
        Piece.statesmanSejanus,
        Piece.statesmanMacro,
        Piece.statesmanCaligula,
        Piece.statesmanPaulinus,
        Piece.statesmanClaudius,
        Piece.statesmanPlautius,
        Piece.statesmanNero,
        Piece.statesmanCorbulo,
        Piece.statesmanSilvanus,
        Piece.statesmanGalba,
        Piece.statesmanOtho,
        Piece.statesmanVitellius,
        Piece.statesmanVespasian,
        Piece.emperorsJulian,
        Piece.emperorsClaudian,
      ],
	    [
        Piece.statesmanCerialis,
        Piece.statesmanTitus,
        Piece.statesmanDomitian,
        Piece.statesmanAgricola,
        Piece.statesmanAelianus,
        Piece.statesmanNerva,
        Piece.statesmanTrajan,
        Piece.statesmanQuietus,
        Piece.statesmanHadrian,
        Piece.statesmanTurbo,
        Piece.statesmanArrian,
        Piece.statesmanAntoninus,
        Piece.emperorsFlavian,
        Piece.emperorsAdoptive,
      ],
    	[
        Piece.statesmanMarcus,
        Piece.statesmanLucius,
        Piece.statesmanAvidius,
        Piece.statesmanPompeianus,
        Piece.statesmanCommodus,
        Piece.statesmanLaetus,
        Piece.statesmanPertinax,
        Piece.statesmanJulianus,
        Piece.statesmanSeverus,
        Piece.statesmanNiger,
        Piece.statesmanAlbinus,
        Piece.statesmanPlautianus,
        Piece.statesmanCaracalla,
        Piece.statesmanMacrinus,
        Piece.statesmanElagabalus,
        Piece.statesmanAlexander,
        Piece.emperorsAntonine,
        Piece.emperorsSeveran,
      ],
      [
        Piece.statesmanMaximinus,
        Piece.statesmanGordian,
        Piece.statesmanTimesitheus,
        Piece.statesmanPhilip,
        Piece.statesmanDecius,
        Piece.statesmanGallus,
        Piece.statesmanAemilian,
        Piece.statesmanValerian,
        Piece.statesmanGallienus,
        Piece.statesmanOdaenath,
        Piece.statesmanPostumus,
        Piece.statesmanGothicus,
        Piece.statesmanAurelian,
        Piece.statesmanTacitus,
        Piece.statesmanProbus,
        Piece.statesmanCarus,
        Piece.statesmanCarinus,
        Piece.statesmanDiocletian,
        Piece.statesmanMaximian,
        Piece.statesmanCarausius,
        Piece.emperorsBarracks,
        Piece.emperorsIllyrian,
      ]
    ];

    const scenarioBarbarians = [
      [
        Piece.leaderArminius,
        Piece.leaderBato,
        Piece.leaderBoudicca,
        Piece.leaderCaratacus,
        Piece.leaderCivilis,
        Piece.leaderSimeon,
        Piece.leaderTacfarinus,
        Piece.leaderVologases,
        Piece.warBritish7,
        Piece.warBritish6,
        Piece.warGerman14,
        Piece.warGerman12,
        Piece.warGerman10,
        Piece.warGerman8,
        Piece.warIllyrian12,
        Piece.warIllyrian10,
        Piece.warJudean8,
        Piece.warMarcomannic11,
        Piece.warMarcomannic9,
        Piece.warMoorish7,
        Piece.warMoorish5,
        Piece.warNubian6,
        Piece.warParthian14,
        Piece.warParthian8,
        Piece.warSarmatian8,
      ],
      [
        Piece.leaderCalgacus,
        Piece.leaderDecebalus,
        Piece.warAlan9,
        Piece.warBritish7,
        Piece.warBritish6,
        Piece.warCaledonian5,
        Piece.warCaledonian4,
        Piece.warDacian12,
        Piece.warDacian11,
        Piece.warDacian10,
        Piece.warGerman10,
        Piece.warGerman8,
        Piece.warJudean7,
        Piece.warJudean6,
        Piece.warMarcomannic11,
        Piece.warMoorish7,
        Piece.warMoorish5,
        Piece.warParthian12,
        Piece.warParthian10,
        Piece.warSarmatian10,
        Piece.warSarmatian8,
      ],
      [
        Piece.leaderBallomar,
        Piece.leaderVologases,
        Piece.warAlamannic10,
        Piece.warAlan9,
        Piece.warBritish7,
        Piece.warBritish6,
        Piece.warCaledonian5,
        Piece.warCaledonian4,
        Piece.warDacian10,
        Piece.warGerman10,
        Piece.warGerman8,
        Piece.warMarcomannic13,
        Piece.warMarcomannic11,
        Piece.warMarcomannic9,
        Piece.warMoorish7,
        Piece.warMoorish5,
        Piece.warParthian14,
        Piece.warParthian12,
        Piece.warParthian10,
        Piece.warParthian8,
        Piece.warSarmatian10,
        Piece.warSarmatian8,
        Piece.warVandal9,
      ],
      [
        Piece.leaderChrocus,
        Piece.leaderKniva,
        Piece.leaderShapur,
        Piece.leaderZenobia,
        Piece.warAlamannic12,
        Piece.warAlamannic10,
        Piece.warBurgundian11,
        Piece.warDacian10,
        Piece.warFrankish11,
        Piece.warFrankish9,
        Piece.warGothic15,
        Piece.warGothic13,
        Piece.warMarcomannic11,
        Piece.warMoorish7,
        Piece.warMoorish5,
        Piece.warNubian6,
        Piece.warNubian4,
        Piece.warPalmyrene14,
        Piece.warPersian15,
        Piece.warPersian13,
        Piece.warPersian11,
        Piece.warPersian9,
        Piece.warSaxon6,
        Piece.warVandal9,
      ]
    ];

    int newScenario = (_state.turn + 1) ~/ 10;

    // This is analogous with Rome, IInc.
    // Not mentioned in the Rome, Inc. rules.
    const scenarioPrestigeBonuses = [
      25,
      0,
      25,
      50,
    ];

    _state.adjustPrestige(scenarioPrestigeBonuses[newScenario] - 150);

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

  void annexAnyProvince() {
    if (choicesEmpty()) {
      setPrompt('Select Province to Annex');
      for (final province in LocationType.province.locations) {
        if (_state.spaceCanBeAnnexed(province)) {
          locationChoosable(province);
        }
      }
      if (choosableLocationCount == 0) {
        choiceChoosable(Choice.next, true);
      }
      throw PlayerChoiceException();
    } 
    if (checkChoiceAndClear(Choice.next)) {
      logLine('>No Provinces available for Annexation.');
      return;
    }
    final province = selectedLocation()!;
    annexProvince(province);
  }

  void eventAdoption() {
		logLine('>Increased number of new Statesmen.');
  }

  void eventAdoptionDoubled() {
		logLine('>${_state.commanderName(Location.commandCaesar)} retires.');
		caesarDies(CaesarDeathCause.adoption, null);
  }

  void eventAssassin() {
    assassinationAttempt();
  }

  void eventAssassinDoubled() {
    logLine('>${_state.commanderName(Location.commandPrefect)} is Killed.');
    adjustUnrest(_state.commandPopularity(Location.commandPrefect));
    adjustPrestige(-_state.commandAdministration(Location.commandPrefect));
    commanderDies(Location.commandPrefect);
  }

  void eventBarbarian() {
		logLine('>Increased chance of Revolt where connected to Homeland or Barbarian Provinces.');
  }

  void eventBarbarianDoubled() {
		logLine('>Greatly increased chance of Revolt where connected to Homeland or Barbarian Provinces.');
  }

  void eventBodyguard() {
		logLine('>Reduced chance of successful Assassination.');
  }

  void eventBodyguardDoubled() {
		logLine('>Greatly reduced chance of successful Assassination.');
  }

  void eventColony() {
		logLine('>Increased Taxation yield expected.');
  }

  void eventColonyDoubled() {
		logLine('>Decreased chance of Revolt.');
  }

  void eventConquest() {
    annexAnyProvince();
  }

  void eventConquestDoubled() {
		logLine('>Annex an extra Province after Triumphs.');
  }

  void eventConspiracy() {
		logLine('>Increased chance of successful Assassination.');
  }

  void eventConspiracyDoubled() {
		logLine('>Greatly increased chance of successful Assassination.');
  }

  void eventDeification() {
    logLine('>${_state.commanderName(Location.commandCaesar)} is Deified');
    adjustPrestige(_state.commandAdministration(Location.commandCaesar));
    _state.caesarDeified = true;
  }

  void eventDeificationDoubled() {
		logLine('>The Deification of ${_state.commanderName(Location.commandCaesar)} provokes an Assassination Attempt.');
    assassinationAttempt();
  }

  void eventInflation() {
    adjustGold(-(_state.gold ~/ 2));
    logLine('>Reduced Taxation yield expected.');
  }

  void eventInflationDoubled() {
    adjustGold(-_state.gold);
    logLine('>Greatly reduced Taxation yield expected.');
  }

  void eventMigration() {
    logLine('>Increased number of Wars and Pillage.');
  }

  void eventMigrationDoubled() {
    logLine('>Greatly increased number of Wars and Pillage.');
  }

  void eventMutiny() {
    adjustUnrest(rollD6());
  }

  void eventMutinyDoubled() {
    for (final command in LocationType.governorship.locations) {
      if (_state.commandLoyalty(command) == Location.commandCaesar && _state.commandPopularity(command) >= 3 && _state.commandMayRebel(command)) {	// NB check even if not active as per Philip
        makeRebellionCheckForCommand(command);
      }
    }
  }

  void eventOmens() {
    logLine('>Increased chance of bad outcomes.');
  }

  void eventOmensDoubled() {
    logLine('>Reduced chance of bad outcomes.');
  }

  void eventPersecution() {
	  int amount = -((_state.commandIntrigue(Location.commandCaesar) + 1) ~/ 2);
  	adjustPrestige(amount);
  }

  void eventPersecutionDoubled() {
    logLine('>Increased chance of military disaster.');
  }

  void eventPlague() {
    var command = Location.values[LocationType.governorship.firstIndex];
    while (true) {
      if (!choicesEmpty()) {
        final piece = selectedPiece()!;
        final province = _state.pieceLocation(piece);
        command = _state.provinceCommand(province);
        logLine('>${_state.commandName(command)}');
        unitDemote(piece);
        clearChoices();
      } else {
        final locationType = _state.commandLocationType(command)!;
        for (final unit in PieceType.mobileUnit.pieces) {
          if (_state.unitVeteran(unit)) {
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
        logLine('>${_state.commandName(command)}');
        adjustUnrest(1);
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
    logLine('>Increased chance of death.');
  }

  void eventPraetorians() {
    logLine('>Increased chance of Caesar being overthrown.');
  }

  void eventPraetoriansDoubled() {
    logLine('>Much increased chance of Caesar being overthrown.');
  }

  void eventRebellion() {
    logLine('>Increased chance of Rebellion.');
  }

  void eventRebellionDoubled() {
    logLine('>Much increased chance of Rebellion.');
  }

  void eventTerror() {
    int amount = -((_state.commandIntrigue(Location.commandCaesar) + 1) ~/ 2);
  	adjustPrestige(amount);
 }

  void eventTerrorDoubled() {
		logLine('>Terror provokes an Assassination Attempt.');
    assassinationAttempt();
  }

  void eventUsurper() {
    adjustUnrest(rollD6());
  }

  void eventUsurperDoubled() {
    for (final command in LocationType.governorship.locations) {
      if (_state.commandLoyalty(command) == Location.commandCaesar && _state.commandIntrigue(command) >= 3 && _state.commandMayRebel(command)) {	// NB check even if not active as per Philip
        makeRebellionCheckForCommand(command);
      }
    }
  }

  void fixOverstacking(bool severan) {
    while (_state.overstackedProvinces().isNotEmpty) {
      if (choicesEmpty()) {
        if (severan) {
          setPrompt('Relocate Over-Stacked Units');
        } else {
          setPrompt('Relocate Units from non-Roman Provinces');
        }
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
          setPrompt('Select Province to Transer ${unit.desc} to');
          final command = _state.provinceCommand(_state.pieceLocation(unit));
          final commandLocationType = _state.commandLocationType(command)!;
          for (final province in commandLocationType.locations) {
            if (_state.unitCanTransferToProvince(unit, province, false, true)) {
              locationChoosable(province);
            }
          }
          if (choosableLocationCount == 0) {
            for (final province in LocationType.province.locations) {
              if (_state.unitCanTransferToProvince(unit, province, false, true)) {
                locationChoosable(province);
              }
            }
          }
          if (choosableLocationCount == 0) {
            for (final province in commandLocationType.locations) {
              if (_state.unitCanTransferToProvince(unit, province, false, false)) {
                locationChoosable(province);
              }
            }
          }
          if (choosableLocationCount == 0) {
            for (final province in LocationType.province.locations) {
              if (_state.unitCanTransferToProvince(unit, province, false, false)) {
                locationChoosable(province);
              }
            }
          }
          if (choosableLocationCount > 0) {
            throw PlayerChoiceException();
          }
        }
        logLine('>${unit.desc} in ${fromProvince.desc} cannot be Transferred.');
        logLine('>${unit.desc} Dismissed.');
        _state.setPieceLocation(unit, Location.boxBarracks);
      }
      if (toProvince != null) {
        logLine('>Transferred ${unit.desc} from ${fromProvince.desc} to ${toProvince.desc}.');
        final fromCommand = _state.provinceCommand(fromProvince);
        final toCommand = _state.provinceCommand(toProvince);
        _state.setPieceLocation(unit, toProvince);
        if (toCommand != fromCommand) {
          adjustUnrest(1);
        }
      }
      clearChoices();
		}
	}

  // Sequence Steps

  void turnBegin() {
    logLine('# Turn ${_state.turn - _firstTurn + 1}: ${yearDesc(_state.turn)} - ${yearDesc(_state.turn + 1)}');
  }

  void eventPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Event Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Event Phase');
    _phaseState = PhaseStateEvent();
  }

  void eventPhaseRemoveEventCounters() {
    _state.clearEventTypeCounts();
  }

  void eventPhaseCaesarEvent() {
    final caesar = _state.commandCommander(Location.commandCaesar);
    if (caesar != null) {
      final ability = _state.statesmanAbility(caesar);
      switch (ability) {
      case Ability.conquest:
        if (_subStep == 0) {
          logLine('### ${_state.statesmanName(caesar)}’s Event: Conquest');
          _subStep = 1;
        }
        eventConquest();
      case Ability.persecution:
        logLine('### ${_state.statesmanName(caesar)}’s Event: Persecution');
        eventPersecution();
      case Ability.terror:
        logLine('### ${_state.statesmanName(caesar)}’s Event: Terror');
        eventTerror();
      case Ability.usurper:
        logLine('### ${_state.statesmanName(caesar)}’s Event: Usurper');
        eventUsurper();
      default:
      }
    }
  }

  void eventPhaseEventRoll() {
    final phaseState = _phaseState as PhaseStateEvent;
    logLine('### Events Roll');
    int die = rollD6();

    logTableHeader();
    logD6InTable(die);
		int eventCount = die;
    for (final statesman in PieceType.statesman.pieces) {
			if (_state.statesmanInPlay(statesman) && _state.statesmanAbility(statesman) == Ability.event) {
				logLine('>|${_state.statesmanName(statesman)}|+1|');
				eventCount += 1;
			}
		}
		int modifier = _options.eventCountModifier;
		if (modifier != 0) {
			if (modifier == 1) {
				logLine('>|More Events Option|+1|');
			} else if (modifier == -1) {
				logLine('>|Less Events Option|-1|');
			}
			eventCount += modifier;
		}
    logLine('>|Total|$eventCount|');
    logTableFooter();

		if (eventCount == 0) {
			logLine('>No Events');
		}
		else if (eventCount == 1) {
			logLine('>$eventCount Event');
		} else {
			logLine('>$eventCount Events');
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
        logLine('>${_state.eventTypeName(eventType)}');
      } else {
        logLine('>${_state.eventTypeName(eventType)} (x2)');
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
    if (_subStep == 0) {
      for (final leader in PieceType.leader.pieces) {
        if (_state.leaderInPlay(leader)) {
          if (failMortalityRoll(leader.desc, _state.leaderAge(leader))) {
            _state.setBarbarianOffmap(leader);
          }
        }
      }

      for (final statesman in PieceType.statesman.pieces) {
        final location = _state.pieceLocation(statesman);
        if (_state.statesmanInPlay(statesman) && location != Location.commandCaesar) {
          final name = _state.statesmanName(statesman);
          if (failMortalityRoll(name, _state.statesmanAge(statesman))) {
            if (location.isType(LocationType.command)) {
              commanderDies(location);
            } else {
              _state.setPieceLocation(statesman, Location.offmap);
            }
          }
        }
      }

      for (final command in LocationType.command.locations) {
        if (_state.commandIsRebelEmperor(command)) {
          final statesman = _state.commandCommander(command);
          if (statesman == null) {
            final name = _state.commanderName(command);
            if (failMortalityRoll(name, _state.commanderAge(command))) {
              rebellionEnds(command);
            }
          }
        }
      }

      final name = _state.commanderName(Location.commandCaesar);
      final statesman = _state.commandCommander(Location.commandCaesar);
      int? age;
      if (statesman != null) {
        age = _state.statesmanAge(statesman);
      } else {
        age = _state.commanderAge(Location.commandCaesar);
      }
      if (failMortalityRoll(name, age)) {
        caesarDies(CaesarDeathCause.mortality, null);
      }

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

      _subStep = 1;
      setPrompt('Mortality Step Complete');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    clearChoices();
  }

  void eventPhaseAssassination() {
    if (_subStep == 0) {
      if (_state.emperorsActive(Piece.emperorsJulian)) {
        logLine('### Assassination Attempt.');
        assassinationAttempt();
        _subStep = 1;
        setPrompt('Assassination Step Complete');
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
    }
    clearChoices();
  }

  void eventPhaseCheckSupport() {
    if (_subStep == 0) {
      for (final command in LocationType.governorship.locations) {
        _state.setCommandLoyaltyChecked(command, false);
      }
      _subStep = 1;
    }
    if (_subStep == 1) {
      while (true) {
        if (choicesEmpty()) {
          if (_state.uncheckedRebelCommands().isEmpty) {
            _subStep = 2;
            break;
          }
          setPrompt('Select Rebel Command for Support Check');
          for (final rebelCommand in LocationType.governorship.locations) {
            if (!_state.commandLoyaltyChecked(rebelCommand) && _state.commandIsRebelEmperor(rebelCommand)) {
              if (_state.connectedUncheckedLoyalCommands(rebelCommand).isNotEmpty) {
                locationChoosable(rebelCommand);
              }
            }
          }
          throw PlayerChoiceException();
        }
        final selectedCommands = selectedLocations();
        final rebelCommand = selectedCommands[0];
        if (selectedCommands.length == 1) {
          setPrompt('Select Loyal Command for Support Check');
          final loyalCommands = _state.connectedUncheckedLoyalCommands(rebelCommand);
          for (final loyalCommand in loyalCommands) {
            locationChoosable(loyalCommand);
          }
          throw PlayerChoiceException();
        }
        final loyalCommand = selectedCommands[1];
        _choiceInfo.selectedLocations.remove(loyalCommand);
        _state.setCommandLoyaltyChecked(loyalCommand, true);
        if (makeSupportCheck(loyalCommand, rebelCommand)) {
          final statesman = _state.commandCommander(loyalCommand);
          if (statesman != null) {
            _state.setPieceLocation(statesman, Location.boxStatesmen);
          }
          _state.setCommanderAge(loyalCommand, null);
          _state.setCommandLoyalty(loyalCommand, rebelCommand);
        }
        if (_state.connectedUncheckedLoyalCommands(rebelCommand).isEmpty) {
          clearChoices();
        }
      }
    }
    if (_subStep == 2) {
      bool haveRebels = false;
      for (final command in LocationType.governorship.locations) {
        if (_state.commandIsRebelEmperor(command)) {
          haveRebels = true;
          break;
        }
      }
      bool madeChecks = false;
      for (final command in LocationType.governorship.locations) {
        if (_state.commandLoyaltyChecked(command)) {
          madeChecks = true;
        }
        _state.setCommandLoyaltyChecked(command, haveRebels);
      }
      if (madeChecks) {
        _subStep = 3;
        setPrompt('Check Support Step Complete');
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
    }
    clearChoices();
  }

  void eventPhaseCheckDefeat() {
    _phaseState = null;
    checkDefeat();
  }

  void treasuryPhaseBegin() {
    if (!checkChoiceAndClear(Choice.next)) {
      setPrompt('Proceed to Treasury Phase');
      choiceChoosable(Choice.next, true);
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Treasury Phase');
    _phaseState = PhaseStateTreasury();
  }

  void treasuryPhaseTax() {
    if (_subStep == 0) {
      tax();
      _subStep = 1;
      setPrompt('Tax Step Complete');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    clearChoices();
  }

  void treasuryPhasePay() {
    if (_subStep == 0) {
      pay();
      _subStep = 1;
      setPrompt('Pay Step Complete');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    clearChoices();
  }

  void treasuryPhaseRenderUntoCaesar() {
    if (_subStep == 0) {
      if (_state.gold >= 0) {
        return;
      }
      logLine('### Render unto Caesar');
      _subStep = 1;
    }
    while (_state.gold < 0) {
      if (choicesEmpty()) {
        setPrompt('Render unto Caesar, or accept Bankruptcy');
        choiceChoosable(Choice.renderUntoCaesar, true);
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.next)) {
        break;
      }
      renderUntoCaesar();
    }
    clearChoices();
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

      logTableHeader();
      logD3InTable(roll);
      int timePeriod = _state.turn ~/ 10;
      if (timePeriod == 0 || timePeriod == 3) {
        String scenarioDesc = timePeriod == 0 ? '27 BCE' : '222 CE';
        logLine('>|$scenarioDesc Scenario|+1|');
        modifiers += 1;
      }
      int modifier = _state.eventTypeCount(EventType.migration);
      if (modifier != 0) {
        logLine('>|Migration|+$modifier|');
        modifiers += modifier;
      }
      int result = roll + modifiers;
      logLine('>|Total|$result|');
      logTableFooter();

      if (result > poolCount) {
        result = poolCount;
      }
      phaseState.warsRemainingCount = result;
    }
  }

  void treasuryPhaseDrawAndMoveNewWars() {
    final phaseState = _phaseState as PhaseStateTreasury;
    while (phaseState.warsRemainingCount > 0) {
      if (choicesEmpty()) {
        final piece = randPiece(_state.piecesInLocation(PieceType.barbarian, Location.poolWars))!;
        if (piece.isType(PieceType.leader)) {
          logLine('### ${piece.desc}');
          _state.setLeaderAge(piece, 0);
          final enemy = _state.leaderEnemy(piece);
          final wars = _state.enemyWarsWithoutLeaders(enemy);
          if (wars.isEmpty) {
            final homeland = enemy.homeland;
            logLine('>${piece.desc} appears in ${homeland.desc}.');
            _state.setPieceLocation(piece, homeland);
          } else {
            final war = randPiece(wars)!;
            final space = _state.pieceLocation(war);
            logLine('>${piece.desc} appears in ${space.desc} with ${war.desc}.');
            _state.setPieceLocation(piece, space);
          }
          phaseState.warsRemainingCount -= 1;
        } else {
          logLine('### ${piece.desc}');
          final homeland = _state.warHomeland(piece);
          logLine('>${piece.desc} arises in ${homeland.desc}.');
          _state.setPieceLocation(piece, homeland);
          phaseState.setWarUnmoved(piece, true);
          setPrompt('Select War to Move');
          pieceChoosable(piece);
          throw PlayerChoiceException();
        }
      } else {
        final war = selectedPiece()!;
        moveWar(war, null, null);
        clearChoices();
        phaseState.warsRemainingCount -= 1;
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
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## Unrest Phase');
    _phaseState = PhaseStateUnrest();
  }

  void unrestPhaseIncreaseUnrest() {
    logLine('### Unrest');
    int amount = 0;

    final rebelCommands = <Location>[];
    for (final command in LocationType.governorship.locations) {
      if (_state.commandIsRebelEmperor(command)) {
        rebelCommands.add(command);
      }
    }
    if (rebelCommands.isNotEmpty) {
      logLine('>Rebels');
      for (final rebelCommand in rebelCommands) {
        logLine('>- ${_state.commanderName(rebelCommand)}');
      }
      logLine('');
      amount += rebelCommands.length;
    }

    final wars = <Piece>[];
    for (final war in PieceType.war.pieces) {
      if (_state.warInPlay(war)) {
        wars.add(war);
      }
    }
    if (wars.isNotEmpty) {
      logLine('>Wars');
      for (final war in wars) {
        final location = _state.pieceLocation(war);
        logLine('>- ${war.desc} in ${location.desc}');
      }
      logLine('');
      amount += wars.length;
    }

    final leaders = <Piece>[];
    for (final leader in PieceType.leader.pieces) {
      final location = _state.pieceLocation(leader);
      if (location.isType(LocationType.homeland)) {
        leaders.add(leader);
      }
    }
    if (leaders.isNotEmpty) {
      logLine('>Leaders');
      for (final leader in leaders) {
        logLine('>- ${leader.desc}');
      }
      logLine('');
      amount += leaders.length;
    }

    final praetorians = <(Location,int)>[];
    final legions = <(Location,int)>[];
    final fleets = <(Location,int)>[];
    final grains = <Location>[];
    for (final province in LocationType.province.locations) {
      int shortfall = 0;
      shortfall = _state.provincePraetorianIcons(province) - _state.piecesInLocationCount(PieceType.praetorianGuard, province);
      if (shortfall > 0) {
        praetorians.add((province, shortfall));
      }
      if (_state.spaceInsurgentOrBetter(province)) {
        shortfall = _state.provinceLegionaryIcons(province) - _state.piecesInLocationCount(PieceType.legion, province);
        if (shortfall > 0) {
          legions.add((province, shortfall));
        }
        shortfall = _state.provinceFleetIcons(province) - _state.piecesInLocationCount(PieceType.fleet, province);
        if (shortfall > 0) {
          fleets.add((province, shortfall));
        }
      }
      if (_state.provinceHasGrainIcon(province)) {
        final status = _state.provinceStatus(province);
        if (status == ProvinceStatus.barbarian || status == ProvinceStatus.insurgent || _state.commandRebel(_state.provinceCommand(province))) {
          grains.add(province);
        }
      }
    }

    if (praetorians.isNotEmpty) {
      logLine('>Praetorian Guards Needed');
      for (final praetorian in praetorians) {
        if (praetorian.$2 > 1) {
          logLine('>- ${praetorian.$1.desc} (${praetorian.$2})');
        } else {
          logLine('>- ${praetorian.$1.desc}');
        }
        amount += praetorian.$2;
      }
      logLine('');
    }

    if (legions.isNotEmpty) {
      logLine('>Legions Needed');
      for (final legion in legions) {
         logLine('>- ${legion.$1.desc}');
        amount += legion.$2;
      }
      logLine('');
    }

    if (fleets.isNotEmpty) {
      logLine('>Fleets Needed');
      for (final fleet in fleets) {
         logLine('>- ${fleet.$1.desc}');
        amount += fleet.$2;
      }
      logLine('');
    }

    if (grains.isNotEmpty) {
      logLine('>Grain Supply Interrupted');
      for (final grain in grains) {
         logLine('>- ${grain.desc}');
        amount += 1;
      }
      logLine('');
    }

    adjustUnrest(amount);
  }
  
  void unrestPhaseDrawStatesmen() {
    if (_subStep == 0) {
      logLine('### New Statesmen');
      _subStep = 1;
    }
    if (_subStep == 1) {
      final poolPieces = _state.piecesInLocation(PieceType.statesmenPool, Location.poolStatesmen);
      int drawCount = 0;
      if (_state.turn % 10 == 9) {
        drawCount = poolPieces.length;
      } else {
        int roll = rollD3();
        int modifiers = 0;

        logTableHeader();
        logD3InTable(roll);
        if (_state.eventTypeCount(EventType.adoption) >= 1) {
          logLine('>|Adoption|+1|');
          modifiers += 1;
        }
        int result = roll + modifiers;
        logLine('>|Total|$result|');
        logTableFooter();

        drawCount = result;
        if (drawCount > poolPieces.length) {
          drawCount = poolPieces.length;
        }
      }
      if (poolPieces.isEmpty) {
        logLine('>|No Statesmen/Emperors left to Draw.');
        return;
      }
      for (int i = 0; i < drawCount; ++i) {
        final piece = randPiece(poolPieces)!;
        poolPieces.remove(piece);
        if (piece.isType(PieceType.statesman)) {
          if (_state.statesmanActiveImperial(piece)) {
            logLine('>${_state.statesmanName(piece)} comes of age.');
          } else {
            logLine('>${_state.statesmanName(piece)} rises to prominence.');
          }
          _state.setPieceLocation(piece, Location.boxStatesmen);
          _state.setStatesmanAge(piece, _state.statesmanImperial(piece) ? 0 : 1);
        } else {
          logLine('>Line of ${piece.desc} is established.');
          _state.setPieceLocation(piece, Location.boxEmperors);
          emperorsAdded(piece);
        }
      }
      _subStep = 2;
    }
    if (_subStep == 2) {
      // For Severan Emperors
      if (_state.overstackedProvinces().isNotEmpty) {
        logLine('### Transfer Units to conform to new Stacking Limits');
      }
      _subStep = 3;
    }
    if (_subStep == 3) {
      if (_state.overstackedProvinces().isNotEmpty) {
        fixOverstacking(true);
      }
      _subStep = 4;
    }
    if (_subStep == 4) {
      if (choicesEmpty()) {
        setPrompt('Draw Statesmen Step Complete');
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      clearChoices();
    }
  }

  void unrestPhaseAppointPrefect() {
    logLine('### Statesmen Appointments');
    if (!_state.commandActive(Location.commandPrefect)) {
      return;
    }
    final prefects = <Piece>[];
    for (final statesman in PieceType.statesman.pieces) {
      if (_state.statesmanAbility(statesman) == Ability.prefect && _state.statesmanInPlay(statesman)) {
        final location = _state.pieceLocation(statesman);
        if (!location.isType(LocationType.command) || (location != Location.commandCaesar && !_state.commandIsRebelEmperor(location))) {
          prefects.add(statesman);
        }
      }
    }
    final prefect = randPiece(prefects);
    if (prefect == null) {
      return;
    }
    final oldPrefect = _state.commandCommander(Location.commandPrefect);
    if (prefect == oldPrefect) {
      return;
    }
    appointStatesmanToCommand(prefect, Location.commandPrefect);
  }

  void unrestPhaseAppointCommanders() {
    while (true) {
      if (choicesEmpty()) {
        setPrompt('Select Statesman to Appoint, or Continue');
        for (final statesman in PieceType.statesman.pieces) {
          if (_state.statesmanValidAppointee(statesman)) {
            pieceChoosable(statesman);
          }
        }
        choiceChoosable(Choice.next, _state.commandAppointmentsAcceptable());
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.next)) {
        clearChoices();
        return;
      }
      if (checkChoice(Choice.cancel)) {
        clearChoices();
      } else {
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
        appointStatesmanToCommand(appointStatesman, appointCommand);
        clearChoices();
      }
    }
  }

  void unrestPhaseAnnex() {
    if (_state.emperorsActive(Piece.emperorsAntonine)) {
      return;
    }
    if (_subStep == 0) {
      logLine('### Annexation');
      _subStep = 1;
    }
    annexAnyProvince();
  }

  void unrestPhaseAdjustPrestigeAndUnrest() {
    logLine('### Prestige');
    for (final command in LocationType.governorship.locations) {
      if (command != Location.commandBritannia || _state.turn >= 10) {
        if (!_state.commandActive(command)) {
          logLine('### Rome ${_state.commandName(command)}');
          int die = rollD6();
          logD6(die);
          adjustPrestige(-die);
        }
      }
    }

    int amount = 0;
    int total = 0;

    logTableHeader();
    final caesar = _state.commandCommander(Location.commandCaesar);
    final consul = _state.commandCommander(Location.commandConsul);
    amount = _state.commandAdministration(Location.commandCaesar);
    logLine('>|${_state.commanderName(Location.commandCaesar)} Administration|$amount|');
    total += amount;
    amount = _state.commandAdministration(Location.commandConsul);
    logLine('>|${_state.commanderName(Location.commandConsul)} Administration|$amount|');
    total += amount;
    if (caesar != null && _state.statesmanAbility(caesar) == Ability.prestige) {
      logLine('>|${_state.statesmanName(caesar)} Prestige|+1|');
      total += 1;
    }
    if (consul != null && _state.statesmanAbility(consul) == Ability.prestige) {
      logLine('>|${_state.statesmanName(consul)} Prestige|+1|');
      total += 1;
    }
    logLine('>|Total|$total|');
    logTableFooter();

    adjustPrestige(total);

    logLine('### Unrest');

    total = 0;

    logTableHeader();
    amount = _state.commandPopularity(Location.commandCaesar);
    logLine('>|${_state.commanderName(Location.commandCaesar)} Popularity|$amount|');
    total += amount;
    amount = _state.commandPopularity(Location.commandConsul);
    logLine('>|${_state.commanderName(Location.commandConsul)} Popularity|$amount|');
    total += amount;
    logTableFooter();

    adjustUnrest(-total);
  }

  void unrestPhaseBreadAndCircuses() {
    final phaseState = _phaseState as PhaseStateUnrest;
    while (true) {
      if (choicesEmpty()) {
        setPrompt('Appease the populace with Bread and Circuses, or Continue');
        choiceChoosable(Choice.breadAndCircusesPrestige, _state.gold >= 10 && phaseState.breadAndCircusesPrestigeCount < _state.commandAdministration(Location.commandCaesar));
        choiceChoosable(Choice.breadAndCircusesUnrest, _state.gold >= 10 && _state.unrest > 0);
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.next)) {
        clearChoices();
        return;
      }
      if (checkChoice(Choice.breadAndCircusesPrestige)) {
        logLine('>Bread and Circuses Increase Prestige.');
        adjustGold(-10);
        adjustPrestige(1);
        phaseState.breadAndCircusesPrestigeCount += 1;
        clearChoices();
      } else if (checkChoice(Choice.breadAndCircusesUnrest)) {
        logLine('>Bread and Circuses Reduce Unrest.');
        adjustGold(-10);
        adjustUnrest(-1);
        clearChoices();
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
          if (_state.unitCanBuild(unit) || (_state.unitInPlay(unit) && _state.unitCanTransfer(unit))) {
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
            setPrompt('Select Province to Transfer ${unit.desc} to');
            for (final province in LocationType.province.locations) {
              if (_state.unitCanTransferToProvince(unit, province, true, true)) {
                locationChoosable(province);
              }
            }
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
        }
        if (_state.unitCanBuild(unit)) {
          logLine('>Build ${unit.desc} in ${province.desc}.');
          _state.setPieceLocation(unit, province);
          int amount = -_state.unitBuildCost(unit);
          adjustGold(amount);
        } else {
          logLine('>Transfer ${unit.desc} from ${_state.pieceLocation(unit).desc} to ${province.desc}.');
          int amount = -_state.unitTransferCostToProvince(unit, province);
          adjustGold(amount);
          _state.setPieceLocation(unit, province);
        }
        clearChoices();
      }
    }
  }

  void unrestPhaseCheckUnrest() {
    logLine('### Check Unrest');
    final rolls = roll3D6();
    int omens = rolls.$4;
    int total = rolls.$5;
    int modifiers = 0;
    int modifier = 0;

    logTableHeader();
    modifier = _state.unrest;
    if  (modifier != 0) {
      logLine('>|Unrest|+$modifier|');
      modifiers += modifier;
    }
    modifier = _state.praetorianGuardCount(true);
    if (modifier != 0) {
      logLine('>|Praetorian Guards|+$modifier|');
      int praetoriansEvent = _state.eventTypeCount(EventType.praetorians);
      if (praetoriansEvent == 1) {
        logLine('>|Praetorians|+$modifier|');
        modifier *= 2;
      } else if (praetoriansEvent == 2) {
        logLine('>|Praetorians|+${(2 * modifier)}|');
        modifier *= 3;
      }
      modifiers += modifier;
    }
    modifier = _state.imperialCavalryCount(true);
    if (modifier != 0) {
      logLine('>|Imperial Cavalry|$modifier|');
      modifiers += modifier;
    }
    int result = total + modifiers;
    logLine('>Total|$result|');
    logTableFooter();

    if (result >= 25) {
      if (result - omens < 25) {
        logLine('>${_state.commanderName(Location.commandCaesar)} is Overthrown, in accordance with the Omens.');
      } else {
        logLine('>${_state.commanderName(Location.commandCaesar)} is Overthrown.');
      }
      int amount = 0;
      amount = _state.commandAdministration(Location.commandCaesar);
      adjustPrestige(-amount);
      amount = _state.commandPopularity(Location.commandCaesar);
      adjustUnrest(amount);
      caesarDies(CaesarDeathCause.unrest, null);
    } else {
      if (result - omens >= 25) {
        logLine('>Rome remains calm, in accordance with the Omens.');
      } else {
        logLine('>Rome remains calm.');
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
      if (_subStep == 0) {
        _subStep = 1;
        throw PlayerChoiceException.withSnapshot();
      }
      throw PlayerChoiceException();
    }
    logLine('## War Phase');
    _phaseState = PhaseStateWar();
  }

  void warPhaseCheckRevolts() {
    if (_subStep == 0) {
  		makeRevoltChecks();
      if (_state.overstackedProvinces().isNotEmpty) {
        logLine('### Transfer Units from Non-Roman Provinces');
  		  _subStep = 1;
      } else {
        _subStep = 2;
      }
  	}
    if (_subStep == 1) {
      if (_state.overstackedProvinces().isNotEmpty) {
        fixOverstacking(false);
      }
      _subStep = 2;
    }
    if (_subStep == 2) {
      setPrompt('Revolt Step Complete');
      choiceChoosable(Choice.next, true);
      _subStep = 3;
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
          }
          else {
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
              phaseState.command = selectedLocationAndClear();
            }
            if (phaseState.command == null) {
              setPrompt('Select Command to Fight War with');
              final commands = <Location>[];
              bool haveLoyalCommands = false;
              for (final space in _state.spaceConnectedSpaces(province)) {
                if (space.isType(LocationType.province)) {
                  var command = _state.provinceCommand(space);
                  final loyaltyCommand = _state.commandLoyalty(command);
                  if (loyaltyCommand != Location.commandCaesar) {
                    command = loyaltyCommand;
                  }
                  if (!commands.contains(command) && !phaseState.commandsFought.contains(command)) {
                    commands.add(command);
                    locationChoosable(command);
                    if (loyaltyCommand == Location.commandCaesar) {
                      haveLoyalCommands = true;
                    }
                  }
                }
              }
              if (haveLoyalCommands && _state.emperorsActive(Piece.emperorsFlavian) && !phaseState.commandsFought.contains(Location.commandCaesar)) {
                locationChoosable(Location.commandCaesar);
              }
              choiceChoosable(Choice.cancel, true);
              throw PlayerChoiceException();
            }
            final command = phaseState.command;
            if (!checkChoice(Choice.fightWar)) {
              if (selectedLocations().length == phaseState.provinces.length) {
                setPrompt('Select Province to Fight War from');
                final spaces = _state.spaceConnectedSpaces(province);
                spaces.add(province);
                for (final space in spaces) {
                  if (space.isType(LocationType.province) && !phaseState.provincesFought.contains(space) && !phaseState.provinces.contains(space)) {
                    bool commandOk = false;
                    if (command! != Location.commandCaesar) {
                      commandOk = _state.commandOverallCommand(_state.provinceCommand(space)) == command;
                    } else {
                      commandOk = _state.commandLoyal(_state.provinceCommand(space));
                    }
                    if (commandOk) {
                      switch (_state.provinceStatus(space)) {
                      case ProvinceStatus.allied:
                      case ProvinceStatus.veteranAllied:
                        locationChoosable(space);
                      case ProvinceStatus.insurgent:
                      case ProvinceStatus.roman:
                        if (_state.provinceViableWarUnits(space, command).isNotEmpty) {
                          locationChoosable(space);
                        }
                      case ProvinceStatus.barbarian:
                      }
                    }
                  }
                }
                choiceChoosable(Choice.fightWar, true);
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              for (final space in selectedLocations()) {
                if (!phaseState.provinces.contains(space)) {
                  phaseState.provinces.add(space);
                  for (final unit in _state.provinceViableWarUnits(space, command!)) {
                    phaseState.units.add(unit);
                  }
                }
              }
            } else {
              fightWar(province, command!, phaseState.provinces);
              clearChoices();
              _subStep = 1;
            }
          }
        }
        if (_subStep == 1) {
          if (_state.overstackedProvinces().isNotEmpty) {
            fixOverstacking(false);
          }
          final command = phaseState.command!;
          if (choicesEmpty()) {
            if (phaseState.destroyLegionsCount > 0 && phaseState.candidateDestroyLegions(_state).isEmpty) {
              phaseState.destroyLegionsCount = 0;
            }
            bool actionsAvailable = false;
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
            if (phaseState.destroyLegionsCount > 0 || phaseState.lossCount > 0) { // Borrowing a rule from Rome, IInc where no limit on legions destroyed.
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
                    if (!unit.isType(PieceType.auxilia)) {
                      dismiss = true;
                      actionsAvailable = true;
                      break;
                    }
                  }
                }
              }
              if (phaseState.demoteCount < 2 && phaseState.candidateDemoteUnits(_state).isNotEmpty) {
                demote = true;
                actionsAvailable = true;
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
                  if (_state.gold >= _options.tributeAmount) {
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
            bool actionsMandatory = actionsAvailable;
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
              if (units.isEmpty || (units[0].isType(PieceType.auxilia) && units.length < _options.dismissAuxiliaCount)) {
                setPrompt('Select Unit(s) to Dismiss');
                int auxiliaCount = 0;
                for (final unit in phaseState.candidateDismissUnits(_state)) {
                  if (unit.isType(PieceType.auxilia)) {
                    auxiliaCount += 1;
                  } else {
                    if (units.isEmpty) {
                      pieceChoosable(unit);
                    }
                  }
                }
                if (units.length + auxiliaCount >= _options.dismissAuxiliaCount) {
                  for (final unit in phaseState.candidateDismissUnits(_state)) {
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
              final unit = selectedPiece();
              if (unit == null) {
                setPrompt('Select Unit to Demote');
                for (final unit in phaseState.candidateDemoteUnits(_state)) {
                  pieceChoosable(unit);
                }
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              unitDemote(unit);
              phaseState.lossCount -= 1;
              phaseState.demoteCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossUnrest)) {
              if (phaseState.disgraceCount == 0) {
                logLine('>Rome is Disgraced.');
              }
              adjustUnrest(1);
              phaseState.lossCount -= 1;
              phaseState.disgraceCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossPrestige)) {
              if (phaseState.dishonorCount == 0) {
                logLine('>Rome is Dishonored.');
              }
              adjustPrestige(-1);
              phaseState.lossCount -= 1;
              phaseState.dishonorCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossTribute)) {
              if (phaseState.tributeCount == 0) {
                logLine('>Rome offers Tribute.');
              }
              int amount = _options.tributeAmount;
              if (phaseState.rebelGold > 0) {
                phaseState.rebelGold -= amount;
              } else {
                adjustGold(-amount);
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
              logLine('>${province.desc} Revolts.');
              provinceDecreaseStatus(province);
              phaseState.lossCount -= 1;
              phaseState.revoltCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.decreaseUnrest)) {
              adjustUnrest(-phaseState.unrest);
              phaseState.unrest = 0;
              clearChoices();
            } else if (checkChoice(Choice.increasePrestige)) {
              adjustPrestige(phaseState.prestige);
              phaseState.prestige = 0;
              clearChoices();
            } else if (checkChoice(Choice.addGold)) {
              adjustGold(phaseState.gold);
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
              logLine('>Annex ${province.desc}');
              annexProvince(province);
              phaseState.annexCount -= 1;
              clearChoices();
            }
          }
        }
        if (_subStep == 2) {
          bool commandComplete = !phaseState.triumph || phaseState.command! != Location.commandCaesar || !_state.emperorsActive(Piece.emperorsIllyrian);
          phaseState.warComplete(commandComplete);
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
    while (_subStep >= 1 || unfoughtRebels().isNotEmpty) {
      if (_subStep == 0) {
        if (choicesEmpty()) {
          setPrompt('Select Rebel to Fight');
          for (final command in unfoughtRebels()) {
            locationChoosable(command);
          }
          throw PlayerChoiceException();
        }
        phaseState.command = selectedLocationAndClear();
        fightRebel(phaseState.command!);
        clearChoices();
        _subStep = 1;
      }
      if (_subStep == 1) {
        if (choicesEmpty()) {
          bool actionsAvailable = false;
          bool destroy = false;
          bool dismiss = false;
          bool demote = false;
          bool increaseUnrest = false;
          bool decreasePrestige = false;
          bool tribute = false;
          bool promote = false;
          if (phaseState.rebelLossCount > 0 && phaseState.candidateDestroyRebelLegions(_state).isEmpty && phaseState.candidateDismissRebelUnits(_state).isEmpty && phaseState.candidateDemoteRebelUnits(_state).isEmpty) {
            phaseState.rebelLossCount = 0;
          }
          if (phaseState.candidateDestroyRebelLegions(_state).isNotEmpty) {
            destroy = true;
            actionsAvailable = true;
          }
          if (phaseState.dismissCount < 2 && phaseState.candidateDismissRebelUnits(_state).isNotEmpty) {
            final units = phaseState.candidateDismissRebelUnits(_state);
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
          if (phaseState.demoteCount < 2 && phaseState.candidateDemoteRebelUnits(_state).isNotEmpty) {
            demote = true;
            actionsAvailable = true;
          }
          if (phaseState.rebelLossCount == 0) {
            if (!destroy && phaseState.candidateDestroyLegions(_state).isNotEmpty) {
              destroy = true;
              actionsAvailable = true;
            }
            if (!dismiss && phaseState.dismissCount < 2 && phaseState.candidateDismissUnits(_state).isNotEmpty) {
              final units = phaseState.candidateDismissUnits(_state);
              if (units.length + phaseState.candidateDismissRebelUnits(_state).length >= _options.dismissAuxiliaCount) {
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
            if (!demote && phaseState.demoteCount < 2 && phaseState.candidateDemoteUnits(_state).isNotEmpty) {
              demote = true;
              actionsAvailable = true;
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
          if (phaseState.tributeCount < 2 && _state.gold >= _options.tributeAmount) {
            tribute = true;
            actionsAvailable = true;
          }
          if (phaseState.promoteCount > 0) {
            if (phaseState.candidatePromoteUnits(_state).isNotEmpty) {
              promote = true;
              actionsAvailable = true;
            }
          }
          if (phaseState.rebelPromoteCount > 0) {
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
            throw PlayerChoiceException();
          }
          phaseState.civilWarComplete();
          _subStep = 0;
        }
        if (checkChoice(Choice.cancel)) {
          clearChoices();
        } else if (checkChoice(Choice.lossDestroy)) {
          final legion = selectedPiece();
          if (legion == null) {
            setPrompt('Select Legion to Destroy');
            for (final legion in phaseState.candidateDestroyRebelLegions(_state)) {
              pieceChoosable(legion);
            }
            if (phaseState.rebelLossCount == 0) {
              for (final legion in phaseState.candidateDestroyLegions(_state)) {
                pieceChoosable(legion);
              }
            }
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
      		legionDestroy(legion);
          phaseState.lossCount -= 1;
          if (phaseState.rebelLossCount > 0 && phaseState.rebelUnits.contains(legion)) {
            phaseState.rebelLossCount -= 1;
          }
          phaseState.destroyCount += 1;
          clearChoices();
        } else if (checkChoice(Choice.lossDismiss)) {
          final units = selectedPieces();
          if (units.isEmpty || (units[0].isType(PieceType.auxilia) && units.length < _options.dismissAuxiliaCount)) {
		        setPrompt('Select Unit(s) to Dismiss');
            int auxiliaCount = 0;
            for (final unit in phaseState.candidateDismissRebelUnits(_state)) {
              if (unit.isType(PieceType.auxilia)) {
                auxiliaCount += 1;
              } else {
                if (units.isEmpty) {
                  pieceChoosable(unit);
                }
              }
            }
            if (phaseState.rebelLossCount == 0) {
              for (final unit in phaseState.candidateDismissUnits(_state)) {
                if (unit.isType(PieceType.auxilia)) {
                  auxiliaCount += 1;
                } else {
                  if (units.isEmpty) {
                    pieceChoosable(unit);
                  }
                }
              }
            }
            if (units.length + auxiliaCount >= _options.dismissAuxiliaCount) {
              for (final unit in phaseState.candidateDismissRebelUnits(_state)) {
                if (unit.isType(PieceType.auxilia)) {
                  pieceChoosable(unit);
                }
              }
            }
            if (phaseState.rebelLossCount == 0 && units.length + auxiliaCount >= _options.dismissAuxiliaCount) {
              for (final unit in phaseState.candidateDismissUnits(_state)) {
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
          if (phaseState.rebelLossCount > 0 && phaseState.rebelUnits.contains(units[0])) {
            phaseState.rebelLossCount -= 1;
          }
          phaseState.dismissCount += 1;
          clearChoices();
        } else if (checkChoice(Choice.lossDemote)) {
          final unit = selectedPiece();
          if (unit == null) {
            setPrompt('Select Unit to Demote');
            for (final unit in phaseState.candidateDemoteRebelUnits(_state)) {
              pieceChoosable(unit);
            }
            if (phaseState.rebelLossCount == 0) {
              for (final unit in phaseState.candidateDemoteUnits(_state)) {
                pieceChoosable(unit);
              }
            }
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
      		unitDemote(unit);
          phaseState.lossCount -= 1;
          if (phaseState.rebelLossCount > 0 && phaseState.rebelUnits.contains(unit)) {
            phaseState.rebelLossCount -= 1;
          }
          phaseState.demoteCount += 1;
          clearChoices();
		    } else if (checkChoice(Choice.lossUnrest)) {
      	  if (phaseState.disgraceCount == 0) {
      			logLine('>Rome is Disgraced.');
          }
          adjustUnrest(1);
          phaseState.lossCount -= 1;
          phaseState.disgraceCount += 1;
          clearChoices();
		    } else if (checkChoice(Choice.lossPrestige)) {
      	  if (phaseState.dishonorCount == 0) {
      			logLine('>Rome is Dishonored.');
          }
          adjustPrestige(-1);
          phaseState.lossCount -= 1;
          phaseState.dishonorCount += 1;
          clearChoices();
		    } else if (checkChoice(Choice.lossTribute)) {
      	  if (phaseState.tributeCount == 0) {
      			logLine('>Rome offers Tribute.');
          }
          adjustGold(-_options.tributeAmount);
          phaseState.lossCount -= 1;
          phaseState.tributeCount += 1;
          clearChoices();
        } else if (checkChoice(Choice.promote)) {
          final unit = selectedPiece();
          if (unit == null) {
            setPrompt('Select Unit to Promote');
            if (phaseState.rebelPromoteCount > 0) {
              for (final unit in phaseState.candidatePromoteRebelUnits(_state)) {
                pieceChoosable(unit);
              }
            }
            if (phaseState.promoteCount > 0) {
              for (final unit in phaseState.candidatePromoteUnits(_state)) {
                pieceChoosable(unit);
              }
            }
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
      		unitPromote(unit);
          if (phaseState.rebelUnits.contains(unit)) {
            phaseState.rebelPromoteCount -= 1;
          } else {
            phaseState.promoteCount -= 1;
          }
          clearChoices();
        }
      }
    }
    phaseState.clearRebels();
    clearChoices();
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
          if (_state.commandMayRebel(command)) {
            makeRebellionCheckForCommand(command);
            count += 1;
          }
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

  PlayerChoiceInfo? playInSequence() {

    final stepHandlers = [
      turnBegin,
      eventPhaseBegin,
      eventPhaseRemoveEventCounters,
      eventPhaseCaesarEvent,
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
      eventPhaseCheckSupport,
      eventPhaseCheckDefeat,
      treasuryPhaseBegin,
      treasuryPhaseTax,
      treasuryPhasePay,
      treasuryPhaseRenderUntoCaesar,
      treasuryPhaseMoveWarsInit,
      treasuryPhaseMoveCurrentWars,
      treasuryPhaseNewWarCount,
      treasuryPhaseDrawAndMoveNewWars,
      treasuryPhaseCheckDefeat,
      unrestPhaseBegin,
      unrestPhaseIncreaseUnrest,
      unrestPhaseDrawStatesmen,
      unrestPhaseAppointPrefect,
      unrestPhaseAppointCommanders,
      unrestPhaseAnnex,
      unrestPhaseAdjustPrestigeAndUnrest,
      unrestPhaseBreadAndCircuses,
      unrestPhaseBuildAndTransferUnits,
      unrestPhaseCheckUnrest,
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

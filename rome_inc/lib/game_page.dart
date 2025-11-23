import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import 'package:rome_inc/game.dart';
import 'package:rome_inc/main.dart';

enum MarkerType {
  gold,
  pay,
  prestige,
  unrest,
  turn,
}

enum MarkerValueType {
  postive1,
  positive10,
  negative1,
  negative10,
  plus,
}

typedef StackKey = (Location, int);

class GamePage extends StatefulWidget {

  const GamePage({super.key});

  @override
  GamePageState createState() {
    return GamePageState();
  }
}

class GamePageState extends State<GamePage> {
  static const _mapWidth = 3264.0;
  static const _mapHeight = 2112.0;

  final _displayOptionsFormKey = GlobalKey<FormState>();

  bool _provinceRevoltModifiers = false;
  bool _provinceLoyalty = false;
  bool _emptyMap = false;

  final _pieceImages = <Piece,Image>{};
  final _loyalGovernorshipImages = <Location,Image>{};
  final _rebelGovernorshipImages = <Location,Image>{};
  final _provinceStatusImages = <ProvinceStatus,Image>{};
  final _markerImages = <(MarkerType,MarkerValueType),Image>{};
  final _dateMarkerImages = <Image>[];
  final _eventMarkerImages = <Image>[];
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _mapStackChildren = <Widget>[];

  final _pieceStackKeys = <Piece,StackKey>{};
  final _expandedStacks = <StackKey>[];

  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  GamePageState() {

    final Map<Piece,String> pieceCounterNames = {
      Piece.legionAdiutrixI: 'legion_adiutrix_I',
      Piece.legionAdiutrixII: 'legion_adiutrix_II',
      Piece.legionAlaudaeV: 'legion_alaudae_V',
      Piece.legionApollinarisXV: 'legion_apollinaris_XV',
      Piece.legionAugustaII: 'legion_augusta_II',
      Piece.legionAugustaIII: 'legion_augusta_III',
      Piece.legionAugustaVIII: 'legion_augusta_VIII',
      Piece.legionClaudiaVII: 'legion_claudia_VII',
      Piece.legionClaudiaXI: 'legion_claudia_XI',
      Piece.legionCyrenaicaIII: 'legion_cyrenaica_III',
      Piece.legionDeiotarianaXXII: 'legion_deiotariana_XXII',
      Piece.legionFerrataVI: 'legion_ferrata_VI',
      Piece.legionFlaviaIV: 'legion_flavia_IV',
      Piece.legionFlaviaXVI: 'legion_flavia_XVI',
      Piece.legionFretensisX: 'legion_fretensis_X',
      Piece.legionFulminataXII: 'legion_fulminata_XII',
      Piece.legionGallicaIII: 'legion_gallica_III',
      Piece.legionGallicaXVI: 'legion_gallica_XVI',
      Piece.legionGeminaVII: 'legion_gemina_VII',
      Piece.legionGeminaX: 'legion_gemina_X',
      Piece.legionGeminaXIII: 'legion_gemina_XIII',
      Piece.legionGeminaXIV: 'legion_gemina_XIV',
      Piece.legionGermanicaI: 'legion_germanica_I',
      Piece.legionHispanaIX: 'legion_hispana_IX',
      Piece.legionIllyricorumI: 'legion_illyricorum_I',
      Piece.legionItalicaI: 'legion_italica_I',
      Piece.legionItalicaII: 'legion_italica_II',
      Piece.legionItalicaIII: 'legion_italica_III',
      Piece.legionItalicaIV: 'legion_italica_IV',
      Piece.legionMacedonicaIV: 'legion_macedonica_IV',
      Piece.legionMacedonicaV: 'legion_macedonica_V',
      Piece.legionMinerviaI: 'legion_minervia_I',
      Piece.legionParthicaI: 'legion_parthica_I',
      Piece.legionParthicaII: 'legion_parthica_II',
      Piece.legionParthicaIII: 'legion_parthica_III',
      Piece.legionPrimigeniaXV: 'legion_primigenia_XV',
      Piece.legionPrimigeniaXXII: 'legion_primigenia_XXII',
      Piece.legionRapaxXXI: 'legion_rapax_XXI',
      Piece.legionScythicaIV: 'legion_scythica_IV',
      Piece.legionTrajanaII: 'legion_trajana_II',
      Piece.legionUlpiaXXX: 'legion_ulpia_XXX',
      Piece.legionValeriaXX: 'legion_valeria_XX',
      Piece.legionVarianaXVII: 'legion_variana_XVII',
      Piece.legionVarianaXVIII: 'legion_variana_XVIII',
      Piece.legionVarianaXIX: 'legion_variana_XIX',
      Piece.legionVictrixVI: 'legion_victrix_VI',
      Piece.legionAdiutrixIVeteran: 'legion_adiutrix_I_veteran',
      Piece.legionAdiutrixIIVeteran: 'legion_adiutrix_II_veteran',
      Piece.legionAlaudaeVVeteran: 'legion_alaudae_V_veteran',
      Piece.legionApollinarisXVVeteran: 'legion_apollinaris_XV_veteran',
      Piece.legionAugustaIIVeteran: 'legion_augusta_II_veteran',
      Piece.legionAugustaIIIVeteran: 'legion_augusta_III_veteran',
      Piece.legionAugustaVIIIVeteran: 'legion_augusta_VIII_veteran',
      Piece.legionClaudiaVIIVeteran: 'legion_claudia_VII_veteran',
      Piece.legionClaudiaXIVeteran: 'legion_claudia_XI_veteran',
      Piece.legionCyrenaicaIIIVeteran: 'legion_cyrenaica_III_veteran',
      Piece.legionDeiotarianaXXIIVeteran: 'legion_deiotariana_XXII_veteran',
      Piece.legionFerrataVIVeteran: 'legion_ferrata_VI_veteran',
      Piece.legionFlaviaIVVeteran: 'legion_flavia_IV_veteran',
      Piece.legionFlaviaXVIVeteran: 'legion_flavia_XVI_veteran',
      Piece.legionFretensisXVeteran: 'legion_fretensis_X_veteran',
      Piece.legionFulminataXIIVeteran: 'legion_fulminata_XII_veteran',
      Piece.legionGallicaIIIVeteran: 'legion_gallica_III_veteran',
      Piece.legionGallicaXVIVeteran: 'legion_gallica_XVI_veteran',
      Piece.legionGeminaVIIVeteran: 'legion_gemina_VI_veteran',
      Piece.legionGeminaXVeteran: 'legion_gemina_X_veteran',
      Piece.legionGeminaXIIIVeteran: 'legion_gemina_XIII_veteran',
      Piece.legionGeminaXIVVeteran: 'legion_gemina_XIV_veteran',
      Piece.legionGermanicaIVeteran: 'legion_germanica_I_veteran',
      Piece.legionHispanaIXVeteran: 'legion_hispana_IX_veteran',
      Piece.legionIllyricorumIVeteran: 'legion_illyricorum_I_veteran',
      Piece.legionItalicaIVeteran: 'legion_italia_I_veteran',
      Piece.legionItalicaIIVeteran: 'legion_italica_II_veteran',
      Piece.legionItalicaIIIVeteran: 'legion_italica_III_veteran',
      Piece.legionItalicaIVVeteran: 'legion_italica_IV_veteran',
      Piece.legionMacedonicaIVVeteran: 'legion_macedonica_IV_veteran',
      Piece.legionMacedonicaVVeteran: 'legion_macedonica_V_veteran',
      Piece.legionMinerviaIVeteran: 'legion_minervia_I_veteran',
      Piece.legionParthicaIVeteran: 'legion_parthica_I_veteran',
      Piece.legionParthicaIIVeteran: 'legion_parthica_II_veteran',
      Piece.legionParthicaIIIVeteran: 'legion_parthica_III_veteran',
      Piece.legionPrimigeniaXVVeteran: 'legion_primigenia_XV_veteran',
      Piece.legionPrimigeniaXXIIVeteran: 'legion_primigenia_XXII_veteran',
      Piece.legionRapaxXXIVeteran: 'legion_rapax_XXI_veteran',
      Piece.legionScythicaIVVeteran: 'legion_scythica_IV_veteran',
      Piece.legionTrajanaIIVeteran: 'legion_trajana_II_veteran',
      Piece.legionUlpiaXXXVeteran: 'legion_ulpia_XXX_veteran',
      Piece.legionValeriaXXVeteran: 'legion_valeria_XX_veteran',
      Piece.legionVarianaXVIIVeteran: 'legion_variana_XVII_veteran',
      Piece.legionVarianaXVIIIVeteran: 'legion_variana_XVIII_veteran',
      Piece.legionVarianaXIXVeteran: 'legion_variana_XIX_veteran',
      Piece.legionVictrixVIVeteran: 'legion_victrix_VI_veteran',
      Piece.auxilia0: 'auxilia',
      Piece.auxilia1: 'auxilia',
      Piece.auxilia2: 'auxilia',
      Piece.auxilia3: 'auxilia',
      Piece.auxilia4: 'auxilia',
      Piece.auxilia5: 'auxilia',
      Piece.auxilia6: 'auxilia',
      Piece.auxilia7: 'auxilia',
      Piece.auxilia8: 'auxilia',
      Piece.auxilia9: 'auxilia',
      Piece.auxilia10: 'auxilia',
      Piece.auxilia11: 'auxilia',
      Piece.auxilia12: 'auxilia',
      Piece.auxilia13: 'auxilia',
      Piece.auxilia14: 'auxilia',
      Piece.auxilia15: 'auxilia',
      Piece.auxilia16: 'auxilia',
      Piece.auxilia17: 'auxilia',
      Piece.auxilia18: 'auxilia',
      Piece.auxilia19: 'auxilia',
      Piece.auxilia0Veteran: 'auxilia_veteran',
      Piece.auxilia1Veteran: 'auxilia_veteran',
      Piece.auxilia2Veteran: 'auxilia_veteran',
      Piece.auxilia3Veteran: 'auxilia_veteran',
      Piece.auxilia4Veteran: 'auxilia_veteran',
      Piece.auxilia5Veteran: 'auxilia_veteran',
      Piece.auxilia6Veteran: 'auxilia_veteran',
      Piece.auxilia7Veteran: 'auxilia_veteran',
      Piece.auxilia8Veteran: 'auxilia_veteran',
      Piece.auxilia9Veteran: 'auxilia_veteran',
      Piece.auxilia10Veteran: 'auxilia_veteran',
      Piece.auxilia11Veteran: 'auxilia_veteran',
      Piece.auxilia12Veteran: 'auxilia_veteran',
      Piece.auxilia13Veteran: 'auxilia_veteran',
      Piece.auxilia14Veteran: 'auxilia_veteran',
      Piece.auxilia15Veteran: 'auxilia_veteran',
      Piece.auxilia16Veteran: 'auxilia_veteran',
      Piece.auxilia17Veteran: 'auxilia_veteran',
      Piece.auxilia18Veteran: 'auxilia_veteran',
      Piece.auxilia19Veteran: 'auxilia_veteran',
      Piece.praetorianGuard0: 'praetorian_guard',
      Piece.praetorianGuard1: 'praetorian_guard',
      Piece.praetorianGuard2: 'praetorian_guard',
      Piece.praetorianGuard0Veteran: 'praetorian_guard_veteran',
      Piece.praetorianGuard1Veteran: 'praetorian_guard_veteran',
      Piece.praetorianGuard2Veteran: 'praetorian_guard_veteran',
      Piece.imperialCavalry0: 'imperial_cavalry',
      Piece.imperialCavalry1: 'imperial_cavalry',
      Piece.imperialCavalry2: 'imperial_cavalry',
      Piece.imperialCavalry0Veteran: 'imperial_cavalry_veteran',
      Piece.imperialCavalry1Veteran: 'imperial_cavalry_veteran',
      Piece.imperialCavalry2Veteran: 'imperial_cavalry_veteran',
      Piece.fleetPraetorian0: 'fleet_praetorian',
      Piece.fleetPraetorian1: 'fleet_praetorian',
      Piece.fleetAegyptian: 'fleet_aegyptian',
      Piece.fleetAfrican: 'fleet_african',
      Piece.fleetBabylonian: 'fleet_babylonian',
      Piece.fleetBosporan: 'fleet_bosporan',
      Piece.fleetBritish: 'fleet_british',
      Piece.fleetGerman: 'fleet_german',
      Piece.fleetMoesian: 'fleet_moesian',
      Piece.fleetPannonian: 'fleet_pannonian',
      Piece.fleetPontic: 'fleet_pontic',
      Piece.fleetSyrian: 'fleet_syrian',
      Piece.fleetPraetorian0Veteran: 'fleet_praetorian_veteran',
      Piece.fleetPraetorian1Veteran: 'fleet_praetorian_veteran',
      Piece.fleetAegyptianVeteran: 'fleet_aegyptian_veteran',
      Piece.fleetAfricanVeteran: 'fleet_african_veteran',
      Piece.fleetBabylonianVeteran: 'fleet_babylonian_veteran',
      Piece.fleetBosporanVeteran: 'fleet_bosporan_veteran',
      Piece.fleetBritishVeteran: 'fleet_british_veteran',
      Piece.fleetGermanVeteran: 'fleet_german_veteran',
      Piece.fleetMoesianVeteran: 'fleet_moesian_veteran',
      Piece.fleetPannonianVeteran: 'fleet_pannonian_veteran',
      Piece.fleetPonticVeteran: 'fleet_pontic_veteran',
      Piece.fleetSyrianVeteran: 'fleet_syrian_veteran',
      Piece.wall0: 'wall',
      Piece.wall1: 'wall',
      Piece.wall2: 'wall',
      Piece.wall3: 'wall',
      Piece.leaderChrocus: 'leader_chrocus',
      Piece.leaderBoudicca: 'leader_boudicca',
      Piece.leaderCaratacus: 'leader_caratacus',
      Piece.leaderCalgacus: 'leader_calgacus',
      Piece.leaderDecebalus: 'leader_decebalus',
      Piece.leaderArminius: 'leader_arminius',
      Piece.leaderCivilis: 'leader_civilus',
      Piece.leaderKniva: 'leader_kniva',
      Piece.leaderSimeon: 'leader_simeon',
      Piece.leaderBallomar: 'leader_ballomar',
      Piece.leaderTacfarinus: 'leader_tacfarinus',
      Piece.leaderZenobia: 'leader_zenobia',
      Piece.leaderBato: 'leader_bato',
      Piece.leaderVologases: 'leader_vologases',
      Piece.leaderShapur: 'leader_shapur',
      Piece.warAlamannic10: 'war_alamannic_10',
      Piece.warAlamannic12: 'war_alamannic_12',
      Piece.warAlan9: 'war_alan_9',
      Piece.warBritish6: 'war_british_6',
      Piece.warBritish7: 'war_british_7',
      Piece.warBurgundian11: 'war_burgundian_11',
      Piece.warCaledonian4: 'war_caledonian_4',
      Piece.warCaledonian5: 'war_caledonian_5',
      Piece.warCantabrian8: 'war_cantabrian_8',
      Piece.warDacian10: 'war_dacian_10',
      Piece.warDacian11: 'war_dacian_11',
      Piece.warDacian12: 'war_dacian_12',
      Piece.warFrankish9: 'war_frankish_9',
      Piece.warFrankish11: 'war_frankish_11',
      Piece.warGerman8: 'war_german_8',
      Piece.warGerman10: 'war_german_10',
      Piece.warGerman12: 'war_german_12',
      Piece.warGerman14: 'war_german_14',
      Piece.warGothic13: 'war_gothic_13',
      Piece.warGothic15: 'war_gothic_15',
      Piece.warIllyrian10: 'war_illyrian_10',
      Piece.warIllyrian12: 'war_illyrian_12',
      Piece.warJudean6: 'war_judean_6',
      Piece.warJudean7: 'war_judean_7',
      Piece.warJudean8: 'war_judean_8',
      Piece.warMarcomannic9: 'war_marcomannic_9',
      Piece.warMarcomannic11: 'war_marcomannic_11',
      Piece.warMarcomannic13: 'war_marcomannic_13',
      Piece.warMoorish5: 'war_moorish_5',
      Piece.warMoorish7: 'war_moorish_7',
      Piece.warNubian4: 'war_nubian_4',
      Piece.warNubian6: 'war_nubian_6',
      Piece.warPalmyrene14: 'war_palmyrene_14',
      Piece.warParthian8: 'war_parthian_8',
      Piece.warParthian10: 'war_parthian_10',
      Piece.warParthian12: 'war_parthian_12',
      Piece.warParthian14: 'war_parthian_14',
      Piece.warPersian9: 'war_persian_9',
      Piece.warPersian11: 'war_persian_11',
      Piece.warPersian13: 'war_persian_13',
      Piece.warPersian15: 'war_persian_15',
      Piece.warSarmatian8: 'war_sarmatian_8',
      Piece.warSarmatian10: 'war_sarmatian_10',
      Piece.warSaxon6: 'war_saxon_6',
      Piece.warVandal9: 'war_vandal_9',
      Piece.statesmanAelianus: 'statesman_aelianus',
      Piece.statesmanAemilian: 'statesman_aemilian',
      Piece.statesmanAgricola: 'statesman_agricola',
      Piece.statesmanAgrippa: 'statesman_agrippa',
      Piece.statesmanAlbinus: 'statesman_albinus',
      Piece.statesmanAlexander: 'statesman_alexander',
      Piece.statesmanAntoninus: 'statesman_antoninus',
      Piece.statesmanArrian: 'statesman_arrian',
      Piece.statesmanAugustus: 'statesman_augustus',
      Piece.statesmanAurelian: 'statesman_aurelian',
      Piece.statesmanAvidius: 'statesman_avidius',
      Piece.statesmanCaligula: 'statesman_caligula',
      Piece.statesmanCaracalla: 'statesman_caracalla',
      Piece.statesmanCarausius: 'statesman_carausius',
      Piece.statesmanCarinus: 'statesman_carinus',
      Piece.statesmanCarus: 'statesman_carus',
      Piece.statesmanCerialis: 'statesman_cerialis',
      Piece.statesmanClaudius: 'statesman_claudius',
      Piece.statesmanCommodus: 'statesman_commodus',
      Piece.statesmanCorbulo: 'statesman_corbulo',
      Piece.statesmanDecius: 'statesman_decius',
      Piece.statesmanDiocletian: 'statesman_diocletian',
      Piece.statesmanDomitian: 'statesman_domitian',
      Piece.statesmanDrusus: 'statesman_drusus',
      Piece.statesmanElagabalus: 'statesman_elagabalus',
      Piece.statesmanGalba: 'statesman_galba',
      Piece.statesmanGallienus: 'statesman_gallienus',
      Piece.statesmanGallus: 'statesman_gallus',
      Piece.statesmanGermanicus: 'statesman_germanicus',
      Piece.statesmanGordian: 'statesman_gordian',
      Piece.statesmanGothicus: 'statesman_gothicus',
      Piece.statesmanHadrian: 'statesman_hadrian',
      Piece.statesmanJulianus: 'statesman_julianus',
      Piece.statesmanLaetus: 'statesman_laetus',
      Piece.statesmanLucius: 'statesman_lucius',
      Piece.statesmanMacrinus: 'statesman_macrinus',
      Piece.statesmanMacro: 'statesman_macro',
      Piece.statesmanMarcus: 'statesman_marcus',
      Piece.statesmanMaximian: 'statesman_maximian',
      Piece.statesmanMaximinus: 'statesman_maximinus',
      Piece.statesmanNero: 'statesman_nero',
      Piece.statesmanNerva: 'statesman_nerva',
      Piece.statesmanNiger: 'statesman_niger',
      Piece.statesmanOdaenath: 'statesman_odaenath',
      Piece.statesmanOtho: 'statesman_otho',
      Piece.statesmanPaulinus: 'statesman_paulinus',
      Piece.statesmanPertinax: 'statesman_pertinax',
      Piece.statesmanPhilip: 'statesman_philip',
      Piece.statesmanPlautianus: 'statesman_plautianus',
      Piece.statesmanPlautius: 'statesman_plautius',
      Piece.statesmanPompeianus: 'statesman_pompeianus',
      Piece.statesmanPostumus: 'statesman_postumus',
      Piece.statesmanProbus: 'statesman_probus',
      Piece.statesmanQuietus: 'statesman_quietus',
      Piece.statesmanSejanus: 'statesman_sejanus',
      Piece.statesmanSeverus: 'statesman_severus',
      Piece.statesmanSilvanus: 'statesman_silvanus',
      Piece.statesmanTacitus: 'statesman_tacitus',
      Piece.statesmanTiberius: 'statesman_tiberius',
      Piece.statesmanTimesitheus: 'statesman_timesitheus',
      Piece.statesmanTitus: 'statesman_titus',
      Piece.statesmanTrajan: 'statesman_trajan',
      Piece.statesmanTurbo: 'statesman_turbo',
      Piece.statesmanValerian: 'statesman_valerian',
      Piece.statesmanVespasian: 'statesman_vespasian',
      Piece.statesmanVitellius: 'statesman_vitellius',
      Piece.emperorsJulian: 'emperors_julian',
      Piece.emperorsClaudian: 'emperors_claudian',
      Piece.emperorsFlavian: 'emperors_flavian',
      Piece.emperorsAdoptive: 'emperors_adoptive',
      Piece.emperorsAntonine: 'emperors_antonine',
      Piece.emperorsSeveran: 'emperors_severan',
      Piece.emperorsBarracks: 'emperors_barracks',
      Piece.emperorsIllyrian: 'emperors_illyrian',
    };

    for (final piece in PieceType.all.pieces) {
      final counterName = pieceCounterNames[piece]!;
      var imagePath = 'assets/images/$counterName.png';
      _pieceImages[piece] = Image.asset(imagePath, key: UniqueKey(), width: 48.0, height: 48.0);
    }

    final Map<Location,String> governorshipCounterNames = {
      Location.commandPrefect: 'italia',
      Location.commandBritannia: 'britannia',
      Location.commandGallia: 'gallia',
      Location.commandPannonia: 'pannonia',
      Location.commandMoesia: 'moesia',
      Location.commandHispania: 'hispania',
      Location.commandAfrica: 'africa',
      Location.commandAegyptus: 'aegyptus',
      Location.commandSyria: 'syria',
      Location.commandPontica: 'pontica'
    };

    for (final command in LocationType.governorship.locations) {
      final counterName = governorshipCounterNames[command]!;
      final loyalImagePath = 'assets/images/loyal_$counterName.png';
      final rebelImagePath = 'assets/images/rebel_$counterName.png';
      _loyalGovernorshipImages[command] = Image.asset(loyalImagePath, key: UniqueKey(), width: 48.0, height: 48.0);
      _rebelGovernorshipImages[command] = Image.asset(rebelImagePath, key: UniqueKey(), width: 48.0, height: 48.0);
    }

    final Map<ProvinceStatus,String?> provinceStatusCounterNames = {
      ProvinceStatus.barbarian: 'barbarian',
      ProvinceStatus.allied: 'allied',
      ProvinceStatus.veteranAllied: 'allied_veteran',
      ProvinceStatus.insurgent: 'insurgent',
      ProvinceStatus.roman: null
    };

    for (final counterName in provinceStatusCounterNames.entries) {
      if (counterName.value != null) {
        final imagePath = 'assets/images/${counterName.value}.png';
        _provinceStatusImages[counterName.key] = Image.asset(imagePath, key: UniqueKey(), width: 48.0, height: 48.0);
      }
    }

    final markers = [
      (MarkerType.gold, MarkerValueType.postive1, 'gold1'),
      (MarkerType.gold, MarkerValueType.positive10, 'gold10'),
      (MarkerType.gold, MarkerValueType.negative1, 'goldn1'),
      (MarkerType.gold, MarkerValueType.negative10, 'goldn10'),
      (MarkerType.gold, MarkerValueType.plus, 'goldp250'),
      (MarkerType.pay, MarkerValueType.postive1, 'pay1'),
      (MarkerType.pay, MarkerValueType.positive10, 'pay10'),
      (MarkerType.pay, MarkerValueType.plus, 'payp250'),
      (MarkerType.prestige, MarkerValueType.postive1, 'prestige1'),
      (MarkerType.prestige, MarkerValueType.positive10, 'prestige10'),
      (MarkerType.prestige, MarkerValueType.negative1, 'prestigen1'),
      (MarkerType.prestige, MarkerValueType.negative10, 'prestigen10'),
      (MarkerType.unrest, MarkerValueType.postive1, 'unrest'),
      (MarkerType.unrest, MarkerValueType.plus, 'unrestp25'),
      (MarkerType.turn, MarkerValueType.postive1, 'turn'),
    ];

    for (final marker in markers) {
      _markerImages[(marker.$1, marker.$2)] = Image.asset('assets/images/${marker.$3}.png', key: UniqueKey(), width: 48.0, height: 48.0);
    }

    final dataMarkerYears = ['27bce', '70ce', '138ce', '222ce'];

    for (int era = 0; era < 4; ++era) {
      final year = dataMarkerYears[era];
      _dateMarkerImages.add(Image.asset('assets/images/date_$year.png', key: UniqueKey(), width: 48.0, height: 48.0));
    }

    final eventMarkers = ['event', 'event_doubled'];

    for (int i = 0; i < 2; ++i) {
      final eventMarker = eventMarkers[i];
      _eventMarkerImages.add(Image.asset('assets/images/$eventMarker.png', key: UniqueKey(), width: 48.0, height: 48.0));
    }
  }

  Image pieceImage(MyAppState appState, Piece piece) {
    return _pieceImages[piece]!;
  }

  Image governorshipMarkerImage(MyAppState appState, Location command, bool loyal) {
    return loyal ? _loyalGovernorshipImages[command]! : _rebelGovernorshipImages[command]!;
  }

  Image markerImage(MarkerType markerType, MarkerValueType markerValueType) {
    return _markerImages[(markerType, markerValueType)]!;
  }

  Image dateMarkerImage(int era) {
    return _dateMarkerImages[era];
  }

  Image eventMarkerImage(int count) {
    return _eventMarkerImages[count - 1];
  }

  (double, double) provinceCoordinates(Location province) {
    const coordinates = {
      Location.provinceAlpes: (1056.0,978.0),
      Location.provinceCorsicaSardinia: (1148.0,1186.0),
      Location.provinceMediolanum: (1201.0,916.0),
      Location.provinceNeapolis: (1454.0,1259.0),
      Location.provincePisae: (1246.0,1041.0),
      Location.provinceRavenna: (1347.0,982.0),
      Location.provinceRome: (1347.0,1155.0),
      Location.provinceSicilia: (1463.0,1431.0),
      Location.provinceBritanniaInferior: (886.5,351.5),
      Location.provinceBritanniaSuperior: (830.5,474.5),
      Location.provinceCaledonia: (856.0,154.0),
      Location.provinceHibernia: (686.0,201.0),
      Location.provinceAgriDecumates: (1252.5,685.0),
      Location.provinceAquitania: (798.0,894.5),
      Location.provinceBelgica: (926.0,617.0),
      Location.provinceFrisia: (1121.5,451.5),
      Location.provinceGermaniaInferior: (1050.0,576.0),
      Location.provinceGermaniaMagna: (1272.0,557.0),
      Location.provinceGermaniaSuperior: (1074.5,741.5),
      Location.provinceLugdunensis: (824.0,742.0),
      Location.provinceNarbonensis: (935.0,1043.0),
      Location.provinceRhaetia: (1276.5,812.0),
      Location.provinceBoiohaemia: (1459.0,693.5),
      Location.provinceIllyria: (1554.0,1098.0),
      Location.provinceNoricum: (1415.0,847.0),
      Location.provincePannoniaInferior: (1601.0,969.0),
      Location.provincePannoniaSuperior: (1545.0,846.0),
      Location.provinceQuadia: (1617.5,706.0),
      Location.provinceSarmatia: (1714.5,818.5),
      Location.provinceAchaea: (1864.0,1407.0),
      Location.provinceBosporus: (2362.5,836.0),
      Location.provinceDaciaInferior: (1912.5,949.5),
      Location.provinceDaciaSuperior: (1877.0,813.0),
      Location.provinceEpirus: (1717.0,1279.0),
      Location.provinceMacedonia: (1840.0,1188.0),
      Location.provinceMoesiaInferior: (2066.0,1016.4),
      Location.provinceMoesiaSuperior: (1773.0,1052.0),
      Location.provinceScythia: (2078.5,822.5),
      Location.provinceThracia: (2037.5,1149.5),
      Location.provinceBaetica: (449.0,1257.0),
      Location.provinceBaleares: (946.0,1257.0),
      Location.provinceCarthaginensis: (650.0,1303.0),
      Location.provinceGallaecia: (440.0,974.0),
      Location.provinceLusitania: (399.0,1128.0),
      Location.provinceTarraconensis: (698.0,1132.0),
      Location.provinceAfrica: (1180.0,1482.0),
      Location.provinceLibya: (1432.0,1727.0),
      Location.provinceMauretaniaCaesariensis: (706.0,1508.5),
      Location.provinceMauretaniaTingitana: (468.0,1478.0),
      Location.provinceNumidia: (990.0,1547.5),
      Location.provinceAethiopia: (2497.0,2045.5),
      Location.provinceAlexandria: (2316.0,1689.0),
      Location.provinceArcadia: (2334.0,1820.0),
      Location.provinceCreta: (1981.0,1567.0),
      Location.provinceCyrenaica: (1811.0,1720.0),
      Location.provinceThebais: (2381.0,1955.0),
      Location.provinceArabia: (2577.0,1834.0),
      Location.provinceAssyria: (2913.0,1257.0),
      Location.provinceBabylonia: (3005.0,1398.0),
      Location.provinceCilicia: (2433.0,1379.0),
      Location.provinceCommagene: (2624.0,1259.5),
      Location.provinceCyprus: (2383.0,1521.0),
      Location.provinceJudea: (2512.5,1698.5),
      Location.provinceMesopotamia: (2844.5,1371.5),
      Location.provinceOsrhoene: (2767.5,1246.0),
      Location.provincePalmyra: (2739.0,1489.5),
      Location.provincePhoenicia: (2583.0,1559.0),
      Location.provinceSyria: (2575.5,1432.0),
      Location.provinceAlbania: (2994.5,933.5),
      Location.provinceArmeniaMajor: (2769.5,1104.5),
      Location.provinceArmeniaMinor: (2600.0,1079.5),
      Location.provinceAsia: (2123.0,1259.0),
      Location.provinceBithynia: (2273.0,1106.0),
      Location.provinceCappadocia: (2452.0,1219.0),
      Location.provinceCaucasia: (2504.5,847.5),
      Location.provinceColchis: (2687.5,898.0),
      Location.provinceGalatia: (2306.0,1254.0),
      Location.provinceIberia: (2836.0,939.0),
      Location.provinceLyciaPamphylia: (2270.0,1378.0),
      Location.provincePontus: (2426.0,1044.0),
      Location.provinceRhodus: (2122.0,1432.0),
    };
    return coordinates[province]!;
  }

  (double, double) homelandCoordinates(Location homeland) {
    const coordinates = {
      Location.homelandAlamannic: (1397.0,567.0),
      Location.homelandAlan: (2712.0,753.0),
      Location.homelandBritish: (726.0,397.0),
      Location.homelandBurgundian: (1508.0,439.0),
      Location.homelandCaledonian: (784.0,50.0),
      Location.homelandCantabrian: (568.0,957.0),
      Location.homelandDacian: (1979.0,714.0),
      Location.homelandFrankish: (1370.0,452.0),
      Location.homelandGerman: (1244.0,438.0),
      Location.homelandGothic: (2202.0,683.0),
      Location.homelandIllyrian: (1692.0,553.0),
      Location.homelandJudean: (2657.0,1703.0),
      Location.homelandMarcomannic: (1555.0,561.0),
      Location.homelandMoorish: (962.0,1692.0),
      Location.homelandNubian: (2255.0,2043.0),
      Location.homelandPalmyrene: (2879.0,1546.0),
      Location.homelandParthian: (3030.0,1169.0),
      Location.homelandPersian: (3108.0,1504.0),
      Location.homelandSarmatian: (1839.0,663.0),
      Location.homelandSaxon: (1362.0,350.0),
      Location.homelandVandal: (1805.0,542.0),
    };
    return coordinates[homeland]!;
  }

  void addProvinceStatusToMap(MyAppState appState, ProvinceStatus status, double x, double y) {
    Widget widget = _provinceStatusImages[status]!;

    widget = Positioned(
      left: x,
      top: y,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addPieceToMap(MyAppState appState, Piece piece, double x, double y) {
    final playerChoices = appState.playerChoices;

    bool choosable = playerChoices != null && playerChoices.pieces.contains(piece);
    bool selected = playerChoices != null && playerChoices.selectedPieces.contains(piece);

    Widget widget = pieceImage(appState, piece);
    
    double borderWidth = 0.0;

    if (choosable) {
      widget = Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.yellow, width: 5.0),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: widget,
      );
      borderWidth += 5.0;
    } else if (selected) {
      widget = Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.red, width: 5.0),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: widget,
      );
      borderWidth += 5.0;
    } else {
      widget = Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.black,
            width: 1.0),
        ),
        child: widget,
      );
      borderWidth += 1.0;
    }

    GestureTapCallback? onTap;
    if (choosable) {
      onTap = () {
        appState.chosePiece(piece);
      };
    }

    void onSecondaryTap() {
      setState(() {
        final pieceStackKey = _pieceStackKeys[piece];
        if (pieceStackKey != null) {
          if (_expandedStacks.contains(pieceStackKey)) {
            _expandedStacks.remove(pieceStackKey);
          } else {
            _expandedStacks.add(pieceStackKey);
          }
        }
      });
    }

    widget = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        onSecondaryTap: onSecondaryTap,
        child: widget,
      ),
    );

    widget = Positioned(
      left: x - borderWidth,
      top: y - borderWidth,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addGovernorshipMarkerToMap(MyAppState appState, Location command, double x, double y, bool loyal) {
    Widget widget = governorshipMarkerImage(appState, command, loyal);
    
    widget = Positioned(
      left: x,
      top: y,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addMarkerToMap(MarkerType markerType, MarkerValueType markerValueType, double x, double y) {
    Widget widget = markerImage(markerType, markerValueType);
    
    widget = Positioned(
      left: x,
      top: y,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addDateMarkerToMap(int era, double x, double y) {
    Widget widget = dateMarkerImage(era);
    
    widget = Positioned(
      left: x,
      top: y,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addEventMarkerToMap(int count, double x, double y) {
    Widget widget = eventMarkerImage(count);
    
    widget = Positioned(
      left: x,
      top: y,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addProvinceToMap(MyAppState appState, Location province, double x, double y) {
    final gameState = appState.gameState!;
    final game = appState.game;

    final playerChoices = appState.playerChoices;

    bool choosable = playerChoices != null && playerChoices.locations.contains(province);
    bool selected = playerChoices != null && playerChoices.selectedLocations.contains(province);

    Color? innerColor;
    Color? revoltColor;
    int? revoltModifier;

    if (_provinceRevoltModifiers && game != null) {
      final status = gameState.provinceStatus(province);
      if (status != ProvinceStatus.barbarian) {
        int revoltModifierWithoutMobileUnits = game.calculateProvinceRevoltModifier(province, true, false);
        if (revoltModifierWithoutMobileUnits > 0) {
          revoltModifier = game.calculateProvinceRevoltModifier(province, false, false);
          if (revoltModifier == 0) {
            revoltColor = Colors.orange;
          } else if (revoltModifier > 0) {
            revoltColor = Colors.redAccent;
          }
        }
      }
    }

    if (_provinceLoyalty) {
      final status = gameState.provinceStatus(province);
      if (status != ProvinceStatus.barbarian) {
        final command = gameState.provinceCommand(province);
        if (gameState.commandLoyal(command)) {
          innerColor = const Color.fromRGBO(0x89, 0x33, 0x1C, 1.0);
        } else {
          final loyalty = gameState.commandLoyalty(command);
          switch (loyalty) {
          case Location.commandPrefect:
            innerColor = const Color.fromRGBO(0xD2, 0x53, 0x7C, 1.0);
          case Location.commandBritannia:
            innerColor = const Color.fromRGBO(0x85, 0x3C, 0x2D, 1.0);
          case Location.commandGallia:
            innerColor = const Color.fromRGBO(0x56, 0x8E, 0x47, 1.0);
          case Location.commandPannonia:
            innerColor = const Color.fromRGBO(0x21, 0x21, 0x21, 1.0);
          case Location.commandMoesia:
            innerColor = const Color.fromRGBO(0x45, 0xA8, 0xC7, 1.0);
          case Location.commandHispania:
            innerColor = const Color.fromRGBO(0xE7, 0xB0, 0x3D, 1.0);
          case Location.commandAfrica:
            innerColor = const Color.fromRGBO(0x84, 0x6F, 0x44, 1.0);
          case Location.commandAegyptus:
            innerColor = const Color.fromRGBO(0x80, 0xC3, 0x42, 1.0);
          case Location.commandSyria:
            innerColor = const Color.fromRGBO(0xE6, 0x35, 0x2B, 1.0);
          case Location.commandPontica:
            innerColor = const Color.fromRGBO(0x3F, 0x57, 0x95, 1.0);
          default:
          }
        }
      }
    }

    if (revoltColor != null) {
      final textTheme = Theme.of(context).textTheme;

      Widget revoltWidget = Text(
        '${7 - revoltModifier!}',
        style: textTheme.displayMedium,
      );
      revoltWidget = SizedBox(
        width: 50.0,
        height: 50.0,
        child: Center(
          child: revoltWidget,
        ),
      );
      revoltWidget = DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: revoltColor,
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: revoltWidget,
      );
      revoltWidget = Positioned(
        left: x - 25.0,
        top: y - 100.0,
        child: revoltWidget,
      );
      _mapStackChildren.add(revoltWidget);
    }

    Color? outerColor;

    if (choosable) {
      outerColor = Colors.yellow;
    } else if (selected) {
      outerColor = Colors.red;
    }

    if (innerColor != null || outerColor == null) {
      double halfSize = 50.0;
      if (province == Location.provinceRome) {
        halfSize = 74.0;
      }

      Widget widget = SizedBox(
        height: 2.0 * halfSize,
        width: 2.0 * halfSize,
      );

      widget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: innerColor ?? Colors.transparent, width: 5.0),
        ),
        child: widget,
      );
      halfSize += 5.0;

      if (outerColor != null) {
        widget = Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: outerColor, width: 5.0),
          ),
          child: widget,
        );
        halfSize += 5.0;
      }

      if (choosable) {
        widget = MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              appState.choseLocation(province);
            },
            child: widget,
          ),
        );
      }

      widget = Positioned(
        left: x - halfSize,
        top: y - halfSize,
        child: widget,
      );

      _mapStackChildren.add(widget);
    }
  }

  void addCommandToMap(MyAppState appState, Location command, double x, double y) {
    final playerChoices = appState.playerChoices;

    bool choosable = playerChoices != null && playerChoices.locations.contains(command);
    bool selected = playerChoices != null && playerChoices.selectedLocations.contains(command);

    Color? color;
    if (choosable) {
      color = Colors.yellow;
    } else if (selected) {
      color = Colors.red;
    }

    if (color == null) {
      return;
    }

    double halfSize = 48.0;

    Widget widget = SizedBox(
      height: 2.0 * halfSize,
      width: 2.0 * halfSize,
    );

    widget = Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: color, width: 5.0),
      ),
      child: widget,
    );
    halfSize += 5.0;

    if (choosable) {
      widget = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            appState.choseLocation(command);
          },
          child: widget,
        ),
      );
    }

    widget = Positioned(
      left: x - halfSize,
      top: y - halfSize,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addBoxToMap(MyAppState appState, Location sea, double x, double y) {
    var widget =
     Positioned(
      left: x - 10,
      top: y - 10,
      child: PhysicalModel(
        shape: BoxShape.circle,
        color: Colors.yellow,
        child: IconButton(
          onPressed: () {
            appState.choseLocation(sea);
          },
          icon: const Icon(null, size: 20.0),
        ),
      ),
    );

    _mapStackChildren.add(widget);
  }

  void layoutStack(MyAppState appState, StackKey stackKey, List<Piece> pieces, double x, double y, double dx, double dy) {
    if (_expandedStacks.contains(stackKey)) {
      dx = 0.0;
      dy = 50.0;
      double bottom = y + (pieces.length + 1) * dy + 10.0;
      if (bottom >= _mapHeight) {
        dy = -50.0;
      }
    }
    for (int i = 0; i < pieces.length; ++i) {
      addPieceToMap(appState, pieces[i], x + i * dx, y + i * dy);
      _pieceStackKeys[pieces[i]] = stackKey;
    }
  }

  void layoutProvince(MyAppState appState, Location province, int pass) {
    final state = appState.gameState!;

    final coordinates = provinceCoordinates(province);
    final spaceX = coordinates.$1;
    final spaceY = coordinates.$2;

    bool choosable = appState.playerChoices != null && appState.playerChoices!.locations.contains(province);

    if (pass == 0 && !choosable) {
      addProvinceToMap(appState, province, spaceX, spaceY);
    }

    if (!_emptyMap) {
      final stackLocations = [
        (spaceX - 24.0, spaceY - 52.0, 0.0, 0.0),	// Top middle, no stacking
        (spaceX - 52.0, spaceY - 52.0, 0.0, 0.0),	// Upper left, no stacking
        (spaceX + 1.0, spaceY - 52.0, 6.0, -6.0),	// Upper right
        (spaceX - 52.0, spaceY + 1.0, 0.0, 17.0),	// Lower left, stack down
        (spaceX - 24.0, spaceY + 1.0, 0.0, 17.0),	// Lower middle, stack down
        (spaceX - 24.0, spaceY + 1.0, 6.0, 6.0),	// Lower middle, stack down/right
        (spaceX + 1.0, spaceY + 1.0, 6.0, 6.0)	// Lower right
      ];

      final romans = state.piecesInLocation(PieceType.mobileLandUnit, province);
      final fleets = state.piecesInLocation(PieceType.fleet, province);
      final walls = state.piecesInLocation(PieceType.wall, province);
      final barbarians = state.piecesInLocation(PieceType.barbarian, province);

      final fleetsAndWalls = fleets + walls;

      var sk = (province, 0);
      (double, double, double, double)? sl;
      if (_expandedStacks.contains(sk) == (pass == 1)) {
        sl = stackLocations[2];
        layoutStack(appState, sk, fleetsAndWalls, sl.$1, sl.$2, sl.$3, sl.$4);
      }

      sk = (province, 1);
      if (_expandedStacks.contains(sk) == (pass == 1)) {
        if (barbarians.isNotEmpty) {
          sl = stackLocations[6];
        } else {
          sl = stackLocations[5];
        }
        layoutStack(appState, sk, romans, sl.$1, sl.$2, sl.$3, sl.$4);
      }

      sk = (province, 2);
      if (_expandedStacks.contains(sk) == (pass == 1)) {
        if (romans.isNotEmpty) {
          sl = stackLocations[3];
        } else {
          sl = stackLocations[4];
        }
        layoutStack(appState, sk, barbarians, sl.$1, sl.$2, sl.$3, sl.$4);
      }

      if (pass == 0) {
        final status = state.provinceStatus(province);
        if (status != ProvinceStatus.roman) {
          if (fleetsAndWalls.isEmpty) {
            sl = stackLocations[0];
          } else {
            sl = stackLocations[1];
          }
          addProvinceStatusToMap(appState, status, sl.$1, sl.$2);
        }
      }
    }

    if (pass == 1 && choosable) {
      addProvinceToMap(appState, province, spaceX, spaceY);
    }
  }

  void layoutProvinces(MyAppState appState, int pass) {
    for (final province in LocationType.province.locations) {
      layoutProvince(appState, province, pass);
    }
  }

  void layoutHomeland(MyAppState appState, Location homeland, int pass) {
    final state = appState.gameState!;

    final sk = (homeland, 0);
    if (_expandedStacks.contains(sk) == (pass == 1)) {
      final barbarians = state.piecesInLocation(PieceType.barbarian, homeland);

      if (barbarians.isNotEmpty) {
        final coordinates = homelandCoordinates(homeland);
        final spaceX = coordinates.$1;
        final spaceY = coordinates.$2;

        layoutStack(appState, sk, barbarians, spaceX - 30.0, spaceY - 30.0, -6.0, 6.0);
      }
    }
  }

  void layoutHomelands(MyAppState appState, int pass) {
    for (final homeland in LocationType.homeland.locations) {
      layoutHomeland(appState, homeland, pass);
    }
  }

  void layoutCommand(MyAppState appState, Location command) {
    final state = appState.gameState!;

    if (!state.commandActive(command)) {
      return;
    }

    int index = command.index - LocationType.command.firstIndex;
    int col = -1;
    int row = -1;
    switch (index) {
    case 0:
      col = 0;
      row = 0;
    case 1:
      col = 1;
      row = 0;
    default:
      col = 2 + (index - 2) % 5;
      row = (index - 2) ~/ 5;
    }

    double spaceX = 936.0 + 127.0 * col;
    double spaceY = 1898.0 + 125.0 * row;

    bool choosable = appState.playerChoices != null && appState.playerChoices!.locations.contains(command);

    if (!choosable) {
      addCommandToMap(appState, command, spaceX, spaceY);
    }

    Piece? commander = state.commandCommander(command);
    final wars = state.piecesInLocation(PieceType.war, command);
    final rebelCommands = <Location>[];
    if (command != Location.commandCaesar) {
      for (final otherCommand in LocationType.command.locations) {
        if (state.commandLoyalty(otherCommand) == command) {
          rebelCommands.add(otherCommand);
        }
      }
    }
    Location? loyalCommand;
    if (command.isType(LocationType.governorship) && state.commandLoyaltyChecked(command) && state.commandLoyalty(command) == Location.commandCaesar) {
      loyalCommand = command;
    }
    
    if (commander != null) {
      double x = spaceX - 24.0;
      double y = spaceY - 24.0;
      if (wars.isNotEmpty || rebelCommands.isNotEmpty || loyalCommand != null) {
        y -= 27.0;
      }
      addPieceToMap(appState, commander, x, y);
    }

    for (int i = wars.length - 1; i >= 0; --i) {
      double x = spaceX - 24.0;
      double y = spaceY + 2.0;
      if (rebelCommands.isNotEmpty || loyalCommand != null) {
        x += 26.0;
      }
      x -= i * 3.0;
      y += i * 3.0;
      addPieceToMap(appState, wars[i], x, y);
    }

    for (int i = rebelCommands.length - 1; i >= 0 || (i == -1 && loyalCommand != null); --i) {
      double x = spaceX - 24.0;
      double y = spaceY + 2.0;
      if (wars.isNotEmpty) {
        x += 26.0;
      }
      x += i * 3.0;
      y += i * 3.0;
      addGovernorshipMarkerToMap(appState, loyalCommand ?? rebelCommands[i], x, y, loyalCommand != null);
    }

    if (choosable) {
      addCommandToMap(appState, command, spaceX, spaceY);
    }
  }

  void layoutCommands(MyAppState appState) {
    for (final command in LocationType.command.locations) {
      layoutCommand(appState, command);
    }
  }

  void layoutTreasuryTopCell(List<(MarkerType, MarkerValueType)> markers, double x, double y, double dx, double dy) {
    for (final marker in markers) {
      addMarkerToMap(marker.$1, marker.$2, x, y);
      x += 50.0;
    }
  }

  void layoutTreasuryBottomCell(List<(MarkerType, MarkerValueType)> markers, double x, double y, double dx, double dy) {
    for (final marker in markers) {
      addMarkerToMap(marker.$1, marker.$2, x, y);
      x += dx;
      y += dy;
    }
  }

  void layoutTreasury(MyAppState appState) {
    final state = appState.gameState!;

    for (int i = 0; i <= 25; ++i) {

      final markers = <(MarkerType, MarkerValueType)>[];

      if (state.pay >= 250 && state.pay ~/ 10 == 25 + i) {
        markers.add((MarkerType.pay, MarkerValueType.plus));
      }
      if (state.pay < 250 && state.pay ~/ 10 == i) {
        markers.add((MarkerType.pay, MarkerValueType.positive10));
      }
      if (state.pay % 10 == i) {
        markers.add((MarkerType.pay, MarkerValueType.postive1));
      }

      if (state.gold >= 250 && state.gold ~/ 10 == 25 + i) {
        markers.add((MarkerType.gold, MarkerValueType.plus));
      }
      if (state.gold >= 0 && state.gold < 250 && state.gold ~/ 10 == i) {
        markers.add((MarkerType.gold, MarkerValueType.positive10));
      }
      if (state.gold >= 0 && state.gold % 10 == i) {
        markers.add((MarkerType.gold, MarkerValueType.postive1));
      }
      if (state.gold < 0 && -state.gold ~/ 10 == i) {
        markers.add((MarkerType.gold, MarkerValueType.negative10));
      }
      if (state.gold < 0 && -state.gold % 10 == i) {
        markers.add((MarkerType.gold, MarkerValueType.negative1));
      }

      if (state.prestige >= 0 && state.prestige ~/ 10 == i) {
        markers.add((MarkerType.prestige, MarkerValueType.positive10));
      }
      if (state.prestige >= 0 && state.prestige % 10 == i) {
        markers.add((MarkerType.prestige, MarkerValueType.postive1));
      }
      if (state.prestige < 0 && -state.prestige ~/ 10 == i) {
        markers.add((MarkerType.prestige, MarkerValueType.negative10));
      }
      if (state.prestige < 0 && -state.prestige % 10 == i) {
        markers.add((MarkerType.prestige, MarkerValueType.negative1));
      }

      if (state.unrest >= 25 && state.unrest ~/ 25 == i) {
        markers.add((MarkerType.unrest, MarkerValueType.plus));
      }
      if (state.unrest < 25 && state.unrest == i) {
        markers.add((MarkerType.unrest, MarkerValueType.postive1));
      }

      if (state.turn % 10 + 1 == i) {
        markers.add((MarkerType.turn, MarkerValueType.postive1));
      }

      double x = 0.0;
      double y = 0.0;

      if (i <= 10) {
        x = 34.0;
        y = 1003.0 + i * 57.41;
        layoutTreasuryTopCell(markers, x, y, 15.0, 15.0);
      } else {
        x = 34.0 + ((i - 11) % 3) * 57.41;
        y = 1003.0 + (11  + (i - 11) ~/ 3) * 57.41;
        layoutTreasuryBottomCell(markers, x, y, 15.0, 15.0);
      }
    }
  }

  void layoutStatesmenBox(MyAppState appState) {
    final state = appState.gameState!;

    int dateIndex = state.turn ~/ 10;

    int poolCount = state.piecesInLocationCount(PieceType.statesmenPool, Location.poolStatesmen);

    (double, double) statesmanBoxCoordinates(int sequence) {
      int col = sequence % 6;
      int row = sequence ~/ 6;
      double x = 966.0 + col * 69.0;
      double y = 47.0 + row * 62.0;
      return (x, y);
    }

    for (int i = 0; i < poolCount; ++i) {
      final coordinates = statesmanBoxCoordinates(i);
      addDateMarkerToMap(dateIndex, coordinates.$1, coordinates.$2);
    }

    int i = poolCount;

    for (final statesman in state.piecesInLocation(PieceType.statesman, Location.boxStatesmen)) {
      final coordinates = statesmanBoxCoordinates(i);
      addPieceToMap(appState, statesman, coordinates.$1, coordinates.$2);
      i += 1;
    }
  }

  void layoutWarsBox(MyAppState appState) {
    final state = appState.gameState!;

    int poolCount = state.piecesInLocationCount(PieceType.barbarian, Location.poolWars);

    (double, double) warsBoxCoordinates(int sequence) {
      int col = sequence % 7;
      int row = sequence ~/ 7;
      double x = 1409.0 + col * 62.0;
      double y = 47.0 + row * 62.0;
      return (x, y);
    }

    for (int i = 0; i < poolCount; ++i) {
      final coordinates = warsBoxCoordinates(i);
      addProvinceStatusToMap(appState, ProvinceStatus.barbarian, coordinates.$1, coordinates.$2);
    }
  }

  void layoutEvents(MyAppState appState) {
    final state = appState.gameState!;

    for (int i = 0; i < EventType.values.length; ++i) {
      final eventType = EventType.values[i];
      if (state.eventTypeCount(eventType) > 0) {
        int col = i ~/ 6;
        int row = i % 6;
        const lefts = [2294.0, 2723.0, 3187.0];
        const tops = [129.0, 199.0, 274.0, 380.0, 456.0, 520.0];
        addEventMarkerToMap(state.eventTypeCount(eventType), lefts[col], tops[row]);
      }
    }
  }

  void layoutEmperorsBox(MyAppState appState) {
    final state = appState.gameState!;
    int count = 0;
    for (final emperors in state.piecesInLocation(PieceType.emperors, Location.boxEmperors)) {
      int col = count % 4;
      int row = count ~/ 4;
      double x = 1796.0 + col * 69.0;
      if (col >= 2) {
        x += 65.0;
      }
      double y = 1899.0 + row * 84.0;
      addPieceToMap(appState, emperors, x, y);
      count += 1;
    }
  }

  void layoutBarracksBox(MyAppState appState) {
    final state = appState.gameState!;
    int count = 0;
    for (final unit in state.piecesInLocation(PieceType.unit, Location.boxBarracks)) {
      int col = count % 6;
      int row = count ~/ 6;
      double x = 2682.0 + col * 60.0;
      double y = 1881.0 + row * 60.0;
      addPieceToMap(appState, unit, x, y);
      count += 1;
    }
  }

  void layoutDestroyedLegionsBox(MyAppState appState) {
    final state = appState.gameState!;
    int count = 0;
    for (final legion in state.piecesInLocation(PieceType.legion, Location.boxDestroyedLegions)) {
      int col = count % 3;
      int row = count ~/ 3;
      double x = 3065.0 + col * 61.0;
      double y = 1828.0 + row * 61.0;
      addPieceToMap(appState, legion, x, y);
      count += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final gameState = appState.gameState;
    final playerChoices = appState.playerChoices;

    final choiceWidgets = <Widget>[];

    String log = '';

    if (appState.game != null) {
      log = appState.game!.log;
    }

    _mapStackChildren.clear();
    _mapStackChildren.add(_mapImage);

    _pieceStackKeys.clear();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String empireStatus = '';

    if (gameState != null) {
      String emperorDesc;
      final statesman = gameState.pieceInLocation(PieceType.statesman, Location.commandCaesar);
      if (statesman != null) {
        emperorDesc = '**${gameState.statesmanName(statesman)}**';
      } else {
        emperorDesc = 'Generic Caesar';
      }

      empireStatus = '''
# Roman Empire under $emperorDesc, ${appState.game!.yearDesc(gameState.turn)}
___
|Prestige|Unrest|Gold|Pay|Tax Base|
|:---:|:---:|:---:|:---:|:---:|
|${gameState.prestige}|${gameState.unrest}|${gameState.gold}|${gameState.pay}|${gameState.taxBase}|
''';

      if (!_emptyMap) {
        layoutCommands(appState);
        layoutTreasury(appState);
        layoutStatesmenBox(appState);
        layoutWarsBox(appState);
        layoutEvents(appState);
        layoutEmperorsBox(appState);
        layoutBarracksBox(appState);
        layoutDestroyedLegionsBox(appState);
        layoutHomelands(appState, 0);
        layoutProvinces(appState, 0);
        layoutHomelands(appState, 1);
        layoutProvinces(appState, 1);
      }

      const choiceTexts = {
        Choice.renderUntoCaesar: 'Render unto Caesar',
        Choice.breadAndCircusesPrestige: 'Increase Prestige',
        Choice.breadAndCircusesUnrest: 'Reduce Unrest',
        Choice.fightWar: 'Fight War',
        Choice.fightWarsForego: 'Forego Fighting remaining Wars',
        Choice.lossDestroy: 'Destroy Legion',
        Choice.lossDismiss: 'Dismiss Unit(s)',
        Choice.lossDemote: 'Demote Unit',
        Choice.lossUnrest: 'Increase Unrest',
        Choice.lossPrestige: 'Reduce Prestige',
        Choice.lossTribute: 'Tribute',
        Choice.lossRevolt: 'Revolt',
        Choice.decreaseUnrest: 'Reduce Unrest',
        Choice.increasePrestige: 'Increase Prestige',
        Choice.addGold: 'Increase Gold',
        Choice.promote: 'Promote Unit',
        Choice.annex: 'Annex',
        Choice.yes: 'Yes',
        Choice.no: 'No',
        Choice.cancel: 'Cancel',
        Choice.next: 'Next',
      };

      if (playerChoices != null) {
        choiceWidgets.add(
          Text(
            style: textTheme.titleMedium,
            playerChoices.prompt,
          )
        );

        choiceWidgets.add(
          Divider(
            color: colorScheme.outlineVariant,
          )
        );

        for (final choice in playerChoices.choices) {
          choiceWidgets.add(
            ElevatedButton(
              onPressed: playerChoices.disabledChoices.contains(choice) ? null : () {
                appState.madeChoice(choice);
              },
              child: Text(
                style: textTheme.labelLarge,
                choiceTexts[choice]!),
            )
          );
        }
      }
    }

    VoidCallback? onFirstSnapshot;
    VoidCallback? onPrevTurn;
    VoidCallback? onPrevSnapshot;
    VoidCallback? onNextSnapshot;
    VoidCallback? onNextTurn;
    VoidCallback? onLastSnapshot;

    if (appState.previousSnapshotAvailable) {
      onFirstSnapshot = () {
        appState.firstSnapshot();
      };
      onPrevTurn = () {
        appState.previousTurn();
      };
      onPrevSnapshot = () {
        appState.previousSnapshot();
      };
    }
    if (appState.nextSnapshotAvailable) {
      onNextSnapshot = () {
        appState.nextSnapshot();
      };
      onNextTurn = () {
        appState.nextTurn();
      };
      onLastSnapshot = () {
        appState.lastSnapshot();
      };
    }

    final rootWidget = MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10.0,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: choiceWidgets,
                ),
                Form(
                  key: _displayOptionsFormKey,
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(color: colorScheme.tertiaryContainer),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                title: Text(
                                  'Province Revolt Modifiers',
                                  style: textTheme.labelMedium
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: _provinceRevoltModifiers,
                                onChanged: (bool? provinceRevoltModifiers) {
                                  setState(() {
                                    if (provinceRevoltModifiers != null) {
                                      _provinceRevoltModifiers = provinceRevoltModifiers;
                                    }
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text(
                                  'Province Loyalty',
                                  style: textTheme.labelMedium
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: _provinceLoyalty,
                                onChanged: (bool? provinceLoyalty) {
                                  setState(() {
                                    if (provinceLoyalty != null) {
                                      _provinceLoyalty = provinceLoyalty;
                                    }
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: Text(
                                  'Empty Map',
                                  style: textTheme.labelMedium
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: _emptyMap,
                                onChanged: (bool? emptyMap) {
                                  setState(() {
                                    if (emptyMap != null) {
                                      _emptyMap = emptyMap;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(color: colorScheme.secondaryContainer),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  appState.duplicateCurrentGame();
                                },
                                icon: const Icon(Icons.copy),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              IconButton(
                                onPressed: onFirstSnapshot,
                                icon: const Icon(Icons.skip_previous),
                              ),
                              IconButton(
                                onPressed: onPrevTurn,
                                icon: const Icon(Icons.fast_rewind),
                              ),
                              IconButton(
                                onPressed: onPrevSnapshot,
                                icon: const Icon(Icons.arrow_left),
                              ),
                              IconButton(
                                onPressed: onNextSnapshot,
                                icon: const Icon(Icons.arrow_right),
                              ),
                              IconButton(
                                onPressed: onNextTurn,
                                icon: const Icon(Icons.fast_forward),
                              ),
                              IconButton(
                                onPressed: onLastSnapshot,
                                icon: const Icon(Icons.skip_next),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: InteractiveViewer(
              constrained: false,
              minScale: 0.1,
              maxScale: 1.5,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Stack(children: _mapStackChildren),
              ),
            ),
          ),
          SizedBox(
            width: 560.0,
            child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(color: colorScheme.primaryContainer),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: MarkdownBody(
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                        h1: textTheme.titleMedium,
                        tableBorder: TableBorder.all(style: BorderStyle.none),
                      ),
                    data: empireStatus,
                    ),
                  ),
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: colorScheme.surface),
                    child: Markdown(
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                        h1: textTheme.headlineMedium,
                        h1Align: WrapAlignment.center,
                        h1Padding: const EdgeInsets.all(5.0),
                        h2: textTheme.titleLarge,
                        h2Align: WrapAlignment.center,
                        h2Padding: const EdgeInsets.all(3.0),
                        h3: textTheme.bodyLarge,
                        blockquote: textTheme.bodyMedium,
                        blockquoteDecoration: BoxDecoration(
                          color: colorScheme.tertiaryContainer,
                        ),
                        strong: textTheme.headlineMedium,
                      ),
                      controller: _logScrollController,
                      data: log,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        if (!_hadPlayerChoices || playerChoices == null) {
          _logScrollController.jumpTo(_logScrollController.position.maxScrollExtent + 1000000.0);
        } else {
          final position = _logScrollController.position;
          final distance = position.maxScrollExtent - position.pixels;
          if (distance > 0.0) {
            final newPosition = position.maxScrollExtent + 10000.0;
            if (distance == 0) {
              position.jumpTo(newPosition);
            } else {
              final animateTimeMs = min(100.0 * sqrt(distance), 2.5);
              position.animateTo(
                newPosition,
                duration: Duration(milliseconds: animateTimeMs.toInt()),
                curve: Curves.ease);
            }
          }
        }
      }
      _hadPlayerChoices = playerChoices != null;
    });

    return rootWidget;
  }
}

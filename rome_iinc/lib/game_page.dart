import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import 'package:rome_iinc/game.dart';
import 'package:rome_iinc/main.dart';

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
typedef WarInfo = (Piece, double, double);

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

  bool _provinceLoyalty = false;
  bool _provinceRevoltModifiers = false;
  bool _fightWarModifiers = false;
  bool _emptyMap = false;

  final _pieceImages = <Piece,Image>{};
  final _loyalGovernorshipImages = <Location,Image>{};
  final _rebelGovernorshipImages = <Location,Image>{};
  final _provinceStatusImages = <ProvinceStatus,Image>{};
  final _markerImages = <(MarkerType,MarkerValueType),Image>{};
  final _dateMarkerImages = <Image>[];
  final _eventMarkerImages = <Image>[];
  final _empireMarkerImages = <Image>[];
  final _mapImage = Image.asset('assets/images/map.png', key: UniqueKey(), width: _mapWidth, height: _mapHeight);
  final _mapStackChildren = <Widget>[];

  final _pieceStackKeys = <Piece,StackKey>{};
  final _expandedStacks = <StackKey>[];

  final _logScrollController = ScrollController();
  bool _hadPlayerChoices = false;

  final _warInfos = <WarInfo>[];

  GamePageState() {

    const pieceCounterNames = {
      Piece.leaderAttila: 'leader_attila',
      Piece.leaderBayan: 'leader_bayan',
      Piece.leaderChosroes: 'leader_chosroes',
      Piece.leaderClovis: 'leader_clovis',
      Piece.leaderFritigern: 'leader_fritigern',
      Piece.leaderGaiseric: 'leader_gaiseric',
      Piece.leaderShapur: 'leader_shapur',
      Piece.leaderTotila: 'leader_totila',
      Piece.leaderStatesmanAlaric: 'statesman_alaric',
      Piece.leaderStatesmanGainas: 'statesman_gainas',
      Piece.leaderStatesmanTheodoric: 'statesman_theodoric',
      Piece.leaderStatesmanZeno: 'statesman_zeno',
      Piece.warAlan9: 'war_alan_9',
      Piece.warArabian5: 'war_arabian_5',
      Piece.warAvar11: 'war_avar_11',
      Piece.warAvar13: 'war_avar_13',
      Piece.warAvar15: 'war_avar_15',
      Piece.warBulgar12: 'war_bulgar_12',
      Piece.warBulgar14: 'war_bulgar_14',
      Piece.warBurgundian11: 'war_burgundian_11',
      Piece.warFrankish11: 'war_frankish_11',
      Piece.warFrankish13: 'war_frankish_13',
      Piece.warHunnic13: 'war_hun_13',
      Piece.warHunnic14: 'war_hun_14',
      Piece.warHunnic15: 'war_hun_15',
      Piece.warIsaurian7: 'war_isaurian_7',
      Piece.warMoorish5: 'war_moorish_5',
      Piece.warMoorish7: 'war_moorish_7',
      Piece.warNubian4: 'war_nubian_4',
      Piece.warOstrogothic11: 'war_ostrogothic_11',
      Piece.warOstrogothic13: 'war_ostrogothic_13',
      Piece.warPersian11: 'war_persian_11',
      Piece.warPersian13: 'war_persian_13',
      Piece.warPersian15: 'war_persian_15',
      Piece.warPictish4: 'war_pictish_4',
      Piece.warPictish6: 'war_pictish_6',
      Piece.warSarmatian8: 'war_sarmatian_8',
      Piece.warSarmatian10: 'war_sarmatian_10',
      Piece.warSaxon4: 'war_saxon_4',
      Piece.warSaxon6: 'war_saxon_6',
      Piece.warScottish5: 'war_scottish_5',
      Piece.warSlav6: 'war_slav_6',
      Piece.warSlav8: 'war_slav_8',
      Piece.warSuevian9: 'war_suevian_9',
      Piece.warSuevian11: 'war_suevian_11',
      Piece.warSuevian13: 'war_suevian_13',
      Piece.warVandal7: 'war_vandal_7',
      Piece.warVandal8: 'war_vandal_8',
      Piece.warVandal91: 'war_vandal_91',
      Piece.warVandal93: 'war_vandal_93',
      Piece.warVisigothic10: 'war_visigothic_10',
      Piece.warVisigothic12: 'war_visigothic_12',
      Piece.warVisigothic14: 'war_visigothic_14',
      Piece.statesmanAegidius: 'statesman_aegidius',
      Piece.statesmanAetius: 'statesman_aetius',
      Piece.statesmanAlaric: 'statesman_alaric',
      Piece.statesmanAmbrose: 'statesman_ambrose',
      Piece.statesmanAnastasius: 'statesman_anastasius',
      Piece.statesmanAnthemius: 'statesman_anthemius',
      Piece.statesmanArbogast: 'statesman_arbogast',
      Piece.statesmanArcadius: 'statesman_arcadius',
      Piece.statesmanArius: 'statesman_arius',
      Piece.statesmanAspar: 'statesman_aspar',
      Piece.statesmanAuxerre: 'statesman_auxerre',
      Piece.statesmanBasiliscus: 'statesman_basiliscus',
      Piece.statesmanBelisarius: 'statesman_belisarius',
      Piece.statesmanBonus: 'statesman_bonus',
      Piece.statesmanCarausius: 'statesman_carausius',
      Piece.statesmanComentiolus: 'statesman_comentiolus',
      Piece.statesmanConstans: 'statesman_constans',
      Piece.statesmanConstantineI: 'statesman_constantine_I',
      Piece.statesmanConstantineII: 'statesman_constantine_II',
      Piece.statesmanConstantiusI: 'statesman_constantius_I',
      Piece.statesmanConstantiusII: 'statesman_constantius_II',
      Piece.statesmanConstantiusIII: 'statesman_constantius_III',
      Piece.statesmanCrispus: 'statesman_crispus',
      Piece.statesmanDiocletian: 'statesman_diocletian',
      Piece.statesmanEutropius: 'statesman_eutropius',
      Piece.statesmanGainas: 'statesman_gainas',
      Piece.statesmanGalerius: 'statesman_galerius',
      Piece.statesmanGermanus: 'statesman_germanus',
      Piece.statesmanGratian: 'statesman_gratian',
      Piece.statesmanGregory: 'statesman_gregory',
      Piece.statesmanHeraclius: 'statesman_heraclius',
      Piece.statesmanHonorius: 'statesman_honorius',
      Piece.statesmanJulian: 'statesman_julian',
      Piece.statesmanJustinI: 'statesman_justin_I',
      Piece.statesmanJustinII: 'statesman_justin_II',
      Piece.statesmanJustinianI: 'statesman_justinian_I',
      Piece.statesmanLeoI: 'statesman_leo_I',
      Piece.statesmanLiberius: 'statesman_liberius',
      Piece.statesmanLicinius: 'statesman_licinius',
      Piece.statesmanMagnentius: 'statesman_magnentius',
      Piece.statesmanMajorian: 'statesman_majorian',
      Piece.statesmanMarcian: 'statesman_marcian',
      Piece.statesmanMaurice: 'statesman_maurice',
      Piece.statesmanMaxentius: 'statesman_maxentius',
      Piece.statesmanMaximian: 'statesman_maximian',
      Piece.statesmanMaximinusII: 'statesman_maximinus_II',
      Piece.statesmanMystacon: 'statesman_mystacon',
      Piece.statesmanNarses: 'statesman_narses',
      Piece.statesmanOdoacer: 'statesman_odoacer',
      Piece.statesmanPetronius: 'statesman_petronius',
      Piece.statesmanPhocas: 'statesman_phocas',
      Piece.statesmanPopeLeo: 'statesman_pope_leo',
      Piece.statesmanPriscus: 'statesman_priscus',
      Piece.statesmanRicimer: 'statesman_ricimer',
      Piece.statesmanSergius: 'statesman_sergius',
      Piece.statesmanStilicho: 'statesman_stilicho',
      Piece.statesmanTheodora: 'statesman_theodora',
      Piece.statesmanTheodoric: 'statesman_theodoric',
      Piece.statesmanTheodosius: 'statesman_theodosius',
      Piece.statesmanTheodosiusI: 'statesman_theodosius_I',
      Piece.statesmanTheodosiusII: 'statesman_theodosius_II',
      Piece.statesmanTiberiusII: 'statesman_tiberius_II',
      Piece.statesmanTroglita: 'statesman_troglita',
      Piece.statesmanValens: 'statesman_valens',
      Piece.statesmanValentinianI: 'statesman_valentinian_I',
      Piece.statesmanValentinianIII: 'statesman_valentinian_III',
      Piece.statesmanZeno: 'statesman_zeno',
      Piece.dynastyConstantinian: 'dynasty_constantinian',
      Piece.dynastyJustinian: 'dynasty_justinian',
      Piece.dynastyLeonid: 'dynasty_leonid',
      Piece.dynastyTheodosian: 'dynasty_theodosian',
      Piece.dynastyValentinian: 'dynasty_valentinian',
    };

    const unitTypeCounterNames = [
      (PieceType.fort, 'fort'),
      (PieceType.pseudoLegion, 'pseudolegion'),
      (PieceType.legionOrdinary, 'legion'),
      (PieceType.legionVeteran, 'legion_veteran'),
      (PieceType.auxiliaOrdinary, 'auxilia'),
      (PieceType.auxiliaVeteran, 'auxilia_veteran'),
      (PieceType.guardOrdinary, 'guard'),
      (PieceType.guardVeteran, 'guard_veteran'),
      (PieceType.cavalryOrdinary, 'cavalry'),
      (PieceType.cavalryVeteran, 'cavalry_veteran'),
      (PieceType.fleetOrdinary, 'fleet'),
      (PieceType.fleetVeteran, 'fleet_veteran'),
    ];

    for (final piece in PieceType.all.pieces) {
      String counterName = '';
      if (piece.isType(PieceType.unit)) {
        for (final record in unitTypeCounterNames) {
          if (piece.isType(record.$1)) {
            counterName = record.$2;
            break;
          }
        }
      } else {
        counterName = pieceCounterNames[piece]!;
      }
      var imagePath = 'assets/images/$counterName.png';
      _pieceImages[piece] = Image.asset(imagePath, key: UniqueKey(), width: 48.0, height: 48.0);
    }

    final Map<Location,String> governorshipCounterNames = {
      Location.commandItalia: 'italia',
      Location.commandBritannia: 'britannia',
      Location.commandGallia: 'gallia',
      Location.commandPannonia: 'pannonia',
      Location.commandMoesia: 'moesia',
      Location.commandHispania: 'hispania',
      Location.commandAfrica: 'africa',
      Location.commandThracia: 'thracia',
      Location.commandOriens: 'oriens',
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
      ProvinceStatus.foederatiFrankish: 'foederati_frankish',
      ProvinceStatus.foederatiOstrogothic: 'foederati_ostrogothic',
      ProvinceStatus.foederatiSuevian: 'foederati_suevian',
      ProvinceStatus.foederatiVandal: 'foederati_vandal',
      ProvinceStatus.foederatiVisigothic: 'foederati_visigothic',
      ProvinceStatus.allied: 'allied',
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

    final dateMarkerYears = ['286ce', '363ce', '425ce', '497ce', '565ce'];

    for (int era = 0; era < dateMarkerYears.length; ++era) {
      final year = dateMarkerYears[era];
      _dateMarkerImages.add(Image.asset('assets/images/date_$year.png', key: UniqueKey(), width: 48.0, height: 48.0));
    }

    final eventMarkers = ['event', 'event_doubled'];

    for (int i = 0; i < 2; ++i) {
      final eventMarker = eventMarkers[i];
      _eventMarkerImages.add(Image.asset('assets/images/$eventMarker.png', key: UniqueKey(), width: 48.0, height: 48.0));
    }

    final empireMarkers = ['viceroy', 'fall'];

    for (int i = 0; i < 2; ++i) {
      final empireMarker = empireMarkers[i];
      _empireMarkerImages.add(Image.asset('assets/images/$empireMarker.png', key: UniqueKey(), width: 48.0, height: 48.0));
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
      Location.provinceCorsicaSardinia: (1149.0, 1186.0),
      Location.provinceMediolanum: (1202.0, 916.0),
      Location.provinceNeapolis: (1458.0, 1260.0),
      Location.provincePisae: (1246.0, 1040.0),
      Location.provinceRavenna: (1346.0, 982.0),
      Location.provinceRhaetia: (1276.0, 813.0),
      Location.provinceRome: (1346.0, 1154.0),
      Location.provinceSicilia: (1464.0, 1431.0),
      Location.provinceSpoletium: (1489.0, 1141.0),
      Location.provinceBritanniaI: (830.0, 473.0),
      Location.provinceBritanniaII: (886.0, 350.0),
      Location.provinceCaledonia: (856.0, 154.0),
      Location.provinceHibernia: (686.0, 201.0),
      Location.provinceValentia: (717.0, 390.0),
      Location.provinceAlpes: (1056.0, 978.0),
      Location.provinceAquitaniaI: (798.0, 894.0),
      Location.provinceAquitaniaII: (698.0, 997.0),
      Location.provinceBelgica: (925.0, 616.0),
      Location.provinceFrisia: (1121.0, 451.0),
      Location.provinceGermaniaI: (1074.0, 741.0),
      Location.provinceGermaniaII: (1050.0, 576.0),
      Location.provinceGermaniaIII: (1272.0, 556.0),
      Location.provinceLugdunensisI: (824.0, 742.0),
      Location.provinceLugdunensisII: (699.0, 663.0),
      Location.provinceNarbonensis: (935.0, 1043.0),
      Location.provinceSuevia: (1252.0, 685.0),
      Location.provinceBoiohaemia: (1460.0, 694.0),
      Location.provinceDalmatia: (1471.0, 1008.0),
      Location.provinceNoricum: (1414.0, 847.0),
      Location.provincePannoniaI: (1545.0, 846.0),
      Location.provincePannoniaII: (1600.0, 970.0),
      Location.provinceQuadia: (1617.0, 706.0),
      Location.provinceSarmatia: (1714.0, 818.0),
      Location.provinceAchaea: (1863.0, 1407.0),
      Location.provinceCreta: (1982.0, 1568.0),
      Location.provinceDaciaI: (1865.0, 790.0),
      Location.provinceDaciaII: (1830.0, 915.0),
      Location.provinceDardania: (1827.0, 1066.0),
      Location.provinceEpirus: (1718.0, 1278.0),
      Location.provinceMacedonia: (1840.0, 1189.0),
      Location.provinceMoesiaI: (1705.0, 1030.0),
      Location.provinceBaetica: (450.0, 1258.0),
      Location.provinceBaleares: (946.0, 1258.0),
      Location.provinceCarthaginensis: (651.0, 1302.0),
      Location.provinceCeltiberia: (546.0, 1122.0),
      Location.provinceGallaecia: (440.0, 974.0),
      Location.provinceLusitania: (399.0, 1128.0),
      Location.provinceMauretaniaII: (468.0, 1479.0),
      Location.provinceTarraconensis: (698.0, 1132.0),
      Location.provinceAfrica: (1180.0, 1480.0),
      Location.provinceMauretaniaI: (706.0, 1508.0),
      Location.provinceNumidia: (990.0, 1547.0),
      Location.provinceTripolitania: (1433.0, 1727.0),
      Location.provinceAsia: (2123.0, 1259.0),
      Location.provinceBosporus: (2363.0, 835.0),
      Location.provinceCaria: (2122.0, 1432.0),
      Location.provinceConstantinople: (2180.0, 1116.0),
      Location.provinceGothiaI: (1967.0, 881.0),
      Location.provinceGothiaII: (2078.0, 822.0),
      Location.provinceLyciaPamphylia: (2270.0, 1378.0),
      Location.provinceMoesiaII: (1949.0, 1061.0),
      Location.provincePhrygia: (0.0, 0.0),
      Location.provinceRhodope: (2020.0, 1165.0),
      Location.provinceScythia: (2066.0, 1016.0),
      Location.provinceAethiopia: (2497.0, 2045.0),
      Location.provinceAlexandria: (2317.0, 1690.0),
      Location.provinceArabiaI: (2655.0, 1700.0),
      Location.provinceArabiaII: (2576.0, 1833.0),
      Location.provinceArcadia: (2334.0, 1820.0),
      Location.provinceAssyria: (2914.0, 1258.0),
      Location.provinceBabylonia: (2974.0, 1399.0),
      Location.provinceCyprus: (2383.0, 1521.0),
      Location.provinceEuphratensis: (2714.0, 1437.0),
      Location.provinceIsauria: (2433.0, 1379.0),
      Location.provinceLibya: (1810.0, 1719.0),
      Location.provinceMesopotamia: (2844.0, 1371.0),
      Location.provincePalaestina: (2512.0, 1698.0),
      Location.provincePhoenicia: (2584.0, 1559.0),
      Location.provinceSyria: (2574.0, 1399.0),
      Location.provinceThebais: (2381.0, 1955.0),
      Location.provinceAlbania: (2973.0, 935.0),
      Location.provinceArmeniaI: (2769.0, 1104.0),
      Location.provinceArmeniaII: (2600.0, 1080.0),
      Location.provinceArmeniaIII: (2625.0, 1260.0),
      Location.provinceArmeniaIV: (2768.0, 1246.0),
      Location.provinceBithynia: (2314.0, 1072.0),
      Location.provinceCappadocia: (2451.0, 1219.0),
      Location.provinceCaucasia: (2504.0, 847.0),
      Location.provinceColchis: (2687.0, 897.0),
      Location.provinceIberia: (2836.0, 938.0),
      Location.provincePontus: (2426.0, 1045.0),
    };
    return coordinates[province]!;
  }

  (double, double) homelandCoordinates(Location homeland) {
    const coordinates = {
      Location.homelandAlan: (1561.0, 567.0),
      Location.homelandArabian: (2669.0, 1974.0),
      Location.homelandAvar: (1845.0, 669.0),
      Location.homelandBulgar: (2547.0, 721.0),
      Location.homelandBurgundian: (1378.0, 458.0),
      Location.homelandFrankish: (1250.0, 444.0),
      Location.homelandHunnic0: (1678.0, 431.0),
      Location.homelandHunnic1: (2087.0, 671.0),
      Location.homelandHunnic2: (2718.0, 758.0),
      Location.homelandMoorish: (968.0, 1697.0),
      Location.homelandNubian: (2262.0, 2051.0),
      Location.homelandOstrogothic: (2209.0, 690.0),
      Location.homelandPersian: (2985.0, 1144.0),
      Location.homelandPictish: (791.0, 67.0),
      Location.homelandSarmatian: (1699.0, 559.0),
      Location.homelandSaxon: (1369.0, 356.0),
      Location.homelandScottish: (683.0, 58.0),
      Location.homelandSlav: (1811.0, 550.0),
      Location.homelandSuevian: (1403.0, 573.0),
      Location.homelandVandal: (1514.0, 446.0),
      Location.homelandVisigothic: (1985.0, 721.0),
    };
    return coordinates[homeland]!;
  }

  Color commandColor(Location command) {
    switch (command) {
    case Location.commandWesternEmperor:
      return const Color.fromRGBO(0xB0, 0x33, 0x1C, 1.0);
    case Location.commandEasternEmperor:
      return const Color.fromRGBO(0x62, 0x21, 0x57, 1.0);
    case Location.commandItalia:
      return const Color.fromRGBO(0xD3, 0x52, 0x7B, 1.0);
    case Location.commandBritannia:
      return const Color.fromRGBO(0x8A, 0x45, 0x36, 1.0);
    case Location.commandGallia:
      return const Color.fromRGBO(0x56, 0x8D, 0x49, 1.0);
    case Location.commandPannonia:
      return const Color.fromRGBO(0x2C, 0x2C, 0x2C, 1.0);
    case Location.commandMoesia:
      return const Color.fromRGBO(0x4E, 0xAD, 0xCB, 1.0);
    case Location.commandHispania:
      return const Color.fromRGBO(0xE8, 0xB3, 0x43, 1.0);
    case Location.commandAfrica:
      return const Color.fromRGBO(0x87, 0x74, 0x49, 1.0);
    case Location.commandThracia:
      return const Color.fromRGBO(0x74, 0xD9, 0x3B, 1.0);
    case Location.commandOriens:
      return const Color.fromRGBO(0xE4, 0x33, 0x29, 1.0);
    case Location.commandPontica:
      return const Color.fromRGBO(0x3E, 0x56, 0x92, 1.0);
    default:
      return const Color.fromRGBO(0xFF, 0xFF, 0xFF, 1.0);
    }
  }

  Color commandForegroundColor(Location command) {
    return const Color.fromRGBO(0xFF, 0xFF, 0xFF, 1.0);
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

    if (piece.isType(PieceType.war)) {
      _warInfos.add((piece, x, y));
    }
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

  void addEmpireMarkerToMap(int empireType, double x, double y) {
    Widget widget = _empireMarkerImages[empireType];

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
          final empire = gameState.commandEmpire(command);
          final emperor = gameState.empireEmperor(empire);
          innerColor = commandColor(emperor);
        } else {
          final loyalty = gameState.commandAllegiance(command);
          innerColor = commandColor(loyalty);
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

    if (innerColor != null || outerColor != null) {
      double halfSize = 50.0;
      if (province == Location.provinceRome || province == Location.provinceConstantinople) {
        halfSize = 74.0;
      }

      Widget widget = SizedBox(
        height: 2.0 * halfSize,
        width: 2.0 * halfSize);

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
      final forts = state.piecesInLocation(PieceType.fort, province);
      final barbarians = state.piecesInLocation(PieceType.barbarian, province);

      final fleetsAndForts = fleets + forts;

      var sk = (province, 0);
      (double, double, double, double)? sl;
      if (_expandedStacks.contains(sk) == (pass == 1)) {
        sl = stackLocations[2];
        layoutStack(appState, sk, fleetsAndForts, sl.$1, sl.$2, sl.$3, sl.$4);
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
          if (fleetsAndForts.isEmpty) {
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

  void layoutCommand(MyAppState appState, Location empire, Location command) {
    final state = appState.gameState!;

    if (!state.commandActive(command)) {
      return;
    }

    const commandPositions = [
      {
        Location.commandWesternEmperor: (0, 0),
        Location.commandItalia: (0, 1),
        Location.commandBritannia: (1, 0),
        Location.commandGallia: (1, 1),
        Location.commandPannonia: (2, 0),
        Location.commandMoesia: (2, 1),
        Location.commandHispania: (3, 0),
        Location.commandAfrica: (3, 1),
      },
      {
        Location.commandEasternEmperor: (0, 0),
        Location.commandThracia: (0, 1),
        Location.commandPannonia: (1, 0),
        Location.commandMoesia: (1, 1),
        Location.commandOriens: (2, 0),
        Location.commandPontica: (2, 1),
      },
    ];

    final position = commandPositions[empire.index - LocationType.empire.firstIndex][command]!;

    int row = position.$1;
    int col = position.$2;

    double left = empire == Location.commandWesternEmperor ? 324.0 : 2820.0;
    double top  = empire == Location.commandWesternEmperor ? 1642.5 : 1771.0;

    double spaceX = left + 127.0 * col;
    double spaceY = top + 127.0 * row;

    bool choosable = appState.playerChoices != null && appState.playerChoices!.locations.contains(command);

    if (!choosable) {
      addCommandToMap(appState, command, spaceX, spaceY);
    }

    Piece? commander = state.pieceInLocation(PieceType.statesman, command);
    final wars = state.piecesInLocation(PieceType.war, command);
    final commands = <Location>[];
    for (final governorship in LocationType.governorship.locations) {
      if (state.commandAllegiance(governorship) == command) {
        commands.add(governorship);
      }
    }
    
    int? empireType;
    if (command.isType(LocationType.empire)) {
      if (state.empireHasViceroy(empire)) {
        empireType = 0;
      } else if (state.empireHasFallen(empire)) {
        empireType = 1;
      }
    }

    if (commander != null) {
      double x = spaceX - 24.0;
      double y = spaceY - 24.0;
      if (wars.isNotEmpty) {
        y -= 27.0;
      }
      addPieceToMap(appState, commander, x, y);
    } else if (empireType != null) {
      double x = spaceX - 24.0;
      double y = spaceY - 24.0;
      if (wars.isNotEmpty || commands.isNotEmpty) {
        y -= 27.0;
      }
      addEmpireMarkerToMap(empireType, x, y);
    }

    for (int i = wars.length - 1; i >= 0; --i) {
      double x = spaceX - 24.0;
      double y = spaceY + 2.0;
      if (commands.isNotEmpty) {
        x += 26.0;
      }
      x -= i * 3.0;
      y += i * 3.0;
      addPieceToMap(appState, wars[i], x, y);
    }

    if (commands.length == 1 && commander == null) {
      double x = spaceX - 24.0;
      double y = spaceY - 24.0;
      if (wars.isNotEmpty) {
        y -= 27.0;
      }
      addGovernorshipMarkerToMap(appState, commands[0], x, y, state.commandLoyal(commands[0]));
    } else {
      for (int i = commands.length - 1; i >= 0; --i) {
        double x = col == 0 ? spaceX - 97.0 : spaceX + 50.0;
        double y = spaceY - 24.0;
        y -= (commands.length - 1) * 10.0;
        y += i * 24.0;
        addGovernorshipMarkerToMap(appState, commands[i], x, y, state.commandLoyal(commands[i]));
      }
    }

    if (choosable) {
      addCommandToMap(appState, command, spaceX, spaceY);
    }
  }

  void layoutCommands(MyAppState appState, Location empire) {
    final state = appState.gameState!;

    for (final command in LocationType.command.locations) {
      if (state.commandEmpire(command) == empire) {
        layoutCommand(appState, empire, command);
      }
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

  void layoutTreasury(MyAppState appState, Location empire) {
    final state = appState.gameState!;

    int pay = state.empirePay(empire);
    int gold = state.empireGold(empire);
    int prestige = state.empirePrestige(empire);
    int unrest = state.empireUnrest(empire);

    for (int i = 0; i <= 25; ++i) {

      final markers = <(MarkerType, MarkerValueType)>[];

      if (pay >= 250 && pay ~/ 10 == 25 + i) {
        markers.add((MarkerType.pay, MarkerValueType.plus));
      }
      if (pay < 250 && pay ~/ 10 == i) {
        markers.add((MarkerType.pay, MarkerValueType.positive10));
      }
      if (pay % 10 == i) {
        markers.add((MarkerType.pay, MarkerValueType.postive1));
      }

      if (gold >= 250 && gold ~/ 10 == 25 + i) {
        markers.add((MarkerType.gold, MarkerValueType.plus));
      }
      if (gold >= 0 && gold < 250 && gold ~/ 10 == i) {
        markers.add((MarkerType.gold, MarkerValueType.positive10));
      }
      if (gold >= 0 && gold % 10 == i) {
        markers.add((MarkerType.gold, MarkerValueType.postive1));
      }
      if (gold < 0 && -gold ~/ 10 == i) {
        markers.add((MarkerType.gold, MarkerValueType.negative10));
      }
      if (gold < 0 && -gold % 10 == i) {
        markers.add((MarkerType.gold, MarkerValueType.negative1));
      }

      if (prestige >= 0 && prestige ~/ 10 == i) {
        markers.add((MarkerType.prestige, MarkerValueType.positive10));
      }
      if (prestige >= 0 && prestige % 10 == i) {
        markers.add((MarkerType.prestige, MarkerValueType.postive1));
      }
      if (prestige < 0 && -prestige ~/ 10 == i) {
        markers.add((MarkerType.prestige, MarkerValueType.negative10));
      }
      if (prestige < 0 && -prestige % 10 == i) {
        markers.add((MarkerType.prestige, MarkerValueType.negative1));
      }

      if (unrest >= 25 && unrest ~/ 25 == i) {
        markers.add((MarkerType.unrest, MarkerValueType.plus));
      }
      if (unrest < 25 && unrest == i) {
        markers.add((MarkerType.unrest, MarkerValueType.postive1));
      }

      if (state.turn % 10 + 1 == i) {
        markers.add((MarkerType.turn, MarkerValueType.postive1));
      }

      double left = empire == Location.commandWesternEmperor ? 34.0 : 3067.0;
      double top = 1003.0;

      double x = 0.0;
      double y = 0.0;

      if (i <= 10) {
        x = left;
        y = top + i * 57.41;
        layoutTreasuryTopCell(markers, x, y, 15.0, 15.0);
      } else {
        x = left + ((i - 11) % 3) * 57.41;
        y = top + (11  + (i - 11) ~/ 3) * 57.41;
        layoutTreasuryBottomCell(markers, x, y, 15.0, 15.0);
      }
    }
  }

  void layoutStatesmenBox(MyAppState appState) {
    final state = appState.gameState!;

    int dateIndex = state.turn ~/ 10;

    int poolCount = state.piecesInLocationCount(PieceType.statesmenPool, Location.poolStatesmen);

    (double, double) statesmanBoxCoordinates(int sequence) {
      int col = sequence % 7;
      int row = sequence ~/ 7;
      double x = 962.0 + col * 59.0;
      double y = 48.0 + row * 62.0;
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
      int col = sequence % 8;
      int row = sequence ~/ 8;
      double x = 1410.0 + col * 53.0;
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
        const lefts = [2241.0, 2718.0, 3188.0];
        const tops = [134.0, 228.0, 273.0, 334.0, 396.0, 495.0];
        addEventMarkerToMap(state.eventTypeCount(eventType), lefts[col], tops[row]);
      }
    }
  }

  void layoutDynastiesBox(MyAppState appState) {
    final state = appState.gameState!;
    int count = 0;
    for (final emperors in state.piecesInLocation(PieceType.dynasty, Location.boxDynasties)) {
      int col = count % 2;
      int row = count ~/ 2;
      double x = 1984.0 + col * 132.0;
      double y = 1899.0 + row * 74.0;
      addPieceToMap(appState, emperors, x, y);
      count += 1;
    }
  }

  void layoutBarracksBox(MyAppState appState) {
    final state = appState.gameState!;
    int count = 0;
    for (final unit in state.piecesInLocation(PieceType.unit, Location.boxBarracks)) {
      int col = count % 9;
      int row = count ~/ 9;
      double x = 565.0 + col * 65.0;
      double y = 1881.0 + row * 65.0;
      addPieceToMap(appState, unit, x, y);
      count += 1;
    }
  }

  void displayWarModifiers(MyAppState appState) {
    final game = appState.game;
    final gameState = appState.gameState;
    if (!_fightWarModifiers || game == null || gameState == null) {
      return;
    }

    for (final warInfo in _warInfos) {
      final war = warInfo.$1;
      double x = warInfo.$2;
      double y = warInfo.$3;

      final location = gameState.pieceLocation(war);
      if (location.isType(LocationType.province)) {
        final commands = game.fightWarCommandCandidates(war);
        commands.sort((a, b) => a.index.compareTo(b.index));
        int commandIndex = 0;
        for (final command in commands) {
          final provinces = game.fightWarProvinceCandidates(war, command);
          final modifierResults = game.calculateFightWarModifier(war, command, provinces, false);

          int fightWarModifier = modifierResults.$1;
          bool fleetShortage = modifierResults.$2;
          bool cavalryShortage = modifierResults.$3;

          final fightWarColor = commandColor(command);
          final textColor = commandForegroundColor(command);

          final textTheme = Theme.of(context).textTheme;

          String code = '${9 + fightWarModifier}';
          if (fleetShortage) {
            code += 'F';
          } else if (cavalryShortage) {
            code += 'C';
          }

          final fightWarTextStyle = textTheme.displayMedium!.copyWith(color: textColor);

          Widget fightWarWidget = Text(
            code,
            style: fightWarTextStyle,
            selectionColor: textColor,
          );

          const fightWarHalfWidth = 45.0;

          fightWarWidget = SizedBox(
            width: 2.0 * fightWarHalfWidth,
            height: 50.0,
            child: Center(
              child: fightWarWidget,
            ),
          );

          fightWarWidget = DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: fightWarColor,
              border: Border.all(color: Colors.black, width: 2.0),
            ),
            child: fightWarWidget,
          );


          fightWarWidget = Positioned(
            left: x + 24.0 - fightWarHalfWidth * commands.length + commandIndex * 2.0 * fightWarHalfWidth,
            top: y + 50.0,
            child: fightWarWidget,
          );
          _mapStackChildren.add(fightWarWidget);

          commandIndex += 1;
        }
      }
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
    _warInfos.clear();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    List<String> empireStatuses = ['', ''];

    if (gameState != null) {

      for (final empire in LocationType.empire.locations) {
        String empireDesc;
        if (gameState.empireHasFallen(empire)) {
          empireDesc = 'Fallen ${gameState.empireDesc(empire)} Empire';
        } else {
          String emperorDesc;
          if (gameState.empireHasViceroy(empire)) {
            emperorDesc = 'under Viceroy';
          } else {
            final statesman = gameState.pieceInLocation(PieceType.statesman, empire);
            if (statesman != null) {
              emperorDesc = '**${gameState.statesmanName(statesman)}**';
            } else if (gameState.commandRebel(empire)) {
              emperorDesc = 'Rebel Emperor';
            } else {
              emperorDesc = 'Generic Emperor';
            }
          }
          empireDesc = '${gameState.empireDesc(empire)} Empire under $emperorDesc';
        }

        empireStatuses[empire.index - LocationType.empire.firstIndex] = '''
# $empireDesc, ${appState.game!.yearDesc(gameState.turn)}
___
|Prestige|Unrest|Gold|Pay|Tax Base|
|:---:|:---:|:---:|:---:|:---:|
|${gameState.empirePrestige(empire)}|${gameState.empireUnrest(empire)}|${gameState.empireGold(empire)}|${gameState.empirePay(empire)}|${gameState.empireTaxBase(empire)}|
''';
      }

      if (!_emptyMap) {
        layoutCommands(appState, Location.commandWesternEmperor);
        layoutCommands(appState, Location.commandEasternEmperor);
        layoutTreasury(appState, Location.commandWesternEmperor);
        layoutTreasury(appState, Location.commandEasternEmperor);
        layoutStatesmenBox(appState);
        layoutWarsBox(appState);
        layoutEvents(appState);
        layoutDynastiesBox(appState);
        layoutBarracksBox(appState);
        layoutHomelands(appState, 0);
        layoutProvinces(appState, 0);
        layoutHomelands(appState, 1);
        layoutProvinces(appState, 1);
        displayWarModifiers(appState);
      }

      const choiceTexts = {
        Choice.transferGoldEastToWest: 'Transfer Gold to Western Empire',
        Choice.transferGoldWestToEast: 'Transfer Gold to Eastern Empire',
        Choice.extraTaxesWest: 'Extra Taxes in Western Empire',
        Choice.extraTaxesEast: 'Extra Taxes in Eastern Empire',
        Choice.breadAndCircusesPrestigeWest: 'Increase Prestige of Western Empire',
        Choice.breadAndCircusesPrestigeEast: 'Increase Prestige of Eastern Empire',
        Choice.breadAndCircusesUnrestWest: 'Reduce Unrest in Western Empire',
        Choice.breadAndCircusesUnrestEast: 'Reduce Unrest in Eastern Empire',
        Choice.fightWar: 'Fight War',
        Choice.fightWarsForego: 'Forego Fighting remaining Wars',
        Choice.fightRebelsForego: 'Forego Fighting remaining Rebels',
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
        Choice.roman: 'Roman',
        Choice.frankish: 'Frankish',
        Choice.ostrogothic: 'Ostrogothic',
        Choice.suevian: 'Suevian',
        Choice.vandal: 'Vandal',
        Choice.visigothic: 'Visigothic',
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
                choiceTexts[choice]!
              ),
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
                                  'Fight War Modifiers',
                                  style: textTheme.labelMedium
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: _fightWarModifiers,
                                onChanged: (bool? fightWarModifiers) {
                                  setState(() {
                                    if (fightWarModifiers != null) {
                                      _fightWarModifiers = fightWarModifiers;
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
                      data: empireStatuses[0],
                    ),
                  ),
                ),
                Divider(
                  color: colorScheme.onPrimaryContainer,
                  thickness: 5.0),
                DecoratedBox(
                  decoration: BoxDecoration(color: colorScheme.primaryContainer),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                  child: MarkdownBody(
                        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                            h1: textTheme.titleMedium,
                            tableBorder: TableBorder.all(style: BorderStyle.none),
                        ),
                      data: empireStatuses[1],
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

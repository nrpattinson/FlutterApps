import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import 'package:china_inc/game.dart';
import 'package:china_inc/main.dart';

enum MarkerType {
  cash,
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
  static const _mapWidth = 3172.0;
  static const _mapHeight = 2272.0;

  final _displayOptionsFormKey = GlobalKey<FormState>();
 
  bool _provinceRevoltModifiers = false;
  bool _provinceLoyalty = false;
  bool _emptyMap = false;

  final _pieceImages = <Piece,Image>{};
  final _provinceStatusImages = <ProvinceStatus,Image>{};
  final _commandImages = <Image>[];
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

    const pieceCounterNames = {
      Piece.leaderGaldan: 'leader_galdan',
      Piece.leaderHsinbyushin: 'leader_hsinbyushin',
      Piece.leaderNguyen: 'leader_nguyen',
      Piece.leaderYaqub: 'leader_yaqub',
      Piece.leaderZhengYi: 'leader_zheng_yi',
      Piece.leaderStatesmanCaoFutian: 'statesman_cao_futian',
      Piece.leaderStatesmanKoxinga: 'statesman_koxinga',
      Piece.leaderStatesmanMao: 'statesman_mao',
      Piece.leaderStatesmanWangLun: 'statesman_wang_lun',
      Piece.leaderStatesmanXiuquan: 'statesman_xiuquan',
      Piece.warAmerican7: 'war_american_7_4',
      Piece.warBritish12: 'war_british_12_5',
      Piece.warBritish10: 'war_british_10_5',
      Piece.warBritish8: 'war_british_8_3',
      Piece.warDutch5: 'war_dutch_5_3',
      Piece.warFrench11: 'war_french_11_4',
      Piece.warFrench9: 'war_french_9_4',
      Piece.warGerman8: 'war_german_8_4',
      Piece.warJapanese15: 'war_japanese_15_5',
      Piece.warJapanese13: 'war_japanese_13_5',
      Piece.warJapanese11: 'war_japanese_11_5',
      Piece.warJapanese9: 'war_japanese_9_5',
      Piece.warPortuguese4: 'war_portuguese_4_3',
      Piece.warRussian14: 'war_russian_14_4',
      Piece.warRussian12: 'war_russian_12_4',
      Piece.warRussian10: 'war_russian_10_4',
      Piece.warSpanish6: 'war_spanish_6_3',
      Piece.warBoxer13: 'war_boxer_13_2',
      Piece.warCommunist15: 'war_communist_15_5',
      Piece.warGurkha7: 'war_gurkha_7_1',
      Piece.warGurkha5: 'war_gurkha_5_1',
      Piece.warPirate8: 'war_pirate_8_3',
      Piece.warPirate6: 'war_pirate_6_3',
      Piece.warRedTurban12: 'war_red_turban_12_1',
      Piece.warHui11: 'war_hui_11_1',
      Piece.warJinchuan5: 'war_jinchuan_5_1',
      Piece.warMian8: 'war_mian_8_2',
      Piece.warMiao9: 'war_miao_9_1',
      Piece.warMiao7: 'war_miao_7_1',
      Piece.warMongol14: 'war_mongol_14_4',
      Piece.warMongol12: 'war_mongol_12_4',
      Piece.warMongol10: 'war_mongol_10_4',
      Piece.warNian11: 'war_nian_11_2',
      Piece.warPanthay13: 'war_panthay_13_1',
      Piece.warSikh4: 'war_sikh_4_1',
      Piece.warTaiping14: 'war_taiping_14_3',
      Piece.warTaiwan4: 'war_taiwan_4_2',
      Piece.warThai6: 'war_thai_6_2',
      Piece.warTibetan8: 'war_tibetan_8_1',
      Piece.warTibetan6: 'war_tibetan_6_1',
      Piece.warTurkish12: 'war_turkish_12_3',
      Piece.warTurkish11: 'war_turkish_11_3',
      Piece.warTurkish10: 'war_turkish_10_3',
      Piece.warViet9: 'war_viet_9_2',
      Piece.warWhiteLotus9: 'war_white_lotus_9_1',
      Piece.warWokou7: 'war_wokou_7_3',
      Piece.warWokou5: 'war_wokou_5_3',
      Piece.statesmanDorgon: 'statesman_dorgon',
      Piece.statesmanWuSangui: 'statesman_wu_sangui',
      Piece.statesmanSharhuda: 'statesman_sharhuda',
      Piece.statesmanOboi: 'statesman_oboi',
      Piece.statesmanShiLang: 'statesman_shi_lang',
      Piece.statesmanKoxinga: 'statesman_koxinga',
      Piece.statesmanSonggotu: 'statesman_songgotu',
      Piece.statesmanShunzhi: 'statesman_shunzhi',
      Piece.statesmanKangxi: 'statesman_kangxi',
      Piece.statesmanYongzheng: 'statesman_yongzheng',
      Piece.statesmanGengyao: 'statesman_gengyao',
      Piece.statesmanYunsi: 'statesman_yunsi',
      Piece.statesmanOrtai: 'statesman_ortai',
      Piece.statesmanYinxiang: 'statesman_yinxiang',
      Piece.statesmanZhongqi: 'statesman_zhongqi',
      Piece.statesmanYunti: 'statesman_yunti',
      Piece.statesmanQianlong: 'statesman_qianlong',
      Piece.statesmanZhaohui: 'statesman_zhaohui',
      Piece.statesmanAgui: 'statesman_agui',
      Piece.statesmanFuheng: 'statesman_fuheng',
      Piece.statesmanSunShiyi: 'statesman_sun_shiyi',
      Piece.statesmanYongxuan: 'statesman_yongxuan',
      Piece.statesmanWangLun: 'statesman_wang_lun',
      Piece.statesmanYongqi: 'statesman_yongqi',
      Piece.statesmanHeshen: 'statesman_heshen',
      Piece.statesmanFuKangan: 'statesman_fu_kangan',
      Piece.statesmanYangFang: 'statesman_yang_fang',
      Piece.statesmanJiaqing: 'statesman_jiaqing',
      Piece.statesmanDaoguang: 'statesman_daoguang',
      Piece.statesmanLinZexu: 'statesman_lin_zexu',
      Piece.statesmanRinchen: 'statesman_rinchen',
      Piece.statesmanGuofan: 'statesman_guofan',
      Piece.statesmanZuo: 'statesman_zuo',
      Piece.statesmanXiuquan: 'statesman_xuiquan',
      Piece.statesmanMianyu: 'statesman_mianyu',
      Piece.statesmanHongzhang: 'statesman_hongzhang',
      Piece.statesmanXianfeng: 'statesman_xianfeng',
      Piece.statesmanYixin: 'statesman_yixin',
      Piece.statesmanCixi: 'statesman_cixi',
      Piece.statesmanLiuYongfu: 'statesman_liu_yongfu',
      Piece.statesmanTongzhi: 'statesman_tongzhi',
      Piece.statesmanCaoFutian: 'statesman_cao_futian',
      Piece.statesmanYinchang: 'statesman_yinchang',
      Piece.statesmanShikai: 'statesman_shikai',
      Piece.statesmanSunYixian: 'statesman_sun_yixian',
      Piece.statesmanGuangxu: 'statesman_guangxu',
      Piece.statesmanZuolin: 'statesman_zuolin',
      Piece.statesmanFeng: 'statesman_feng',
      Piece.statesmanZhuDe: 'statesman_zhu_de',
      Piece.statesmanJiang: 'statesman_jiang',
      Piece.statesmanLiZongren: 'statesman_li_zongren',
      Piece.statesmanMao: 'statesman_mao',
      Piece.statesmanShicai: 'statesman_shicai',
      Piece.statesmanPuyi: 'statesman_puyi',
      Piece.treatyNerchinsk: 'treaty_nerchinsk',
      Piece.treatyKyakhta: 'treaty_kyakhta',
      Piece.treatyNanjing: 'treaty_nanjing',
      Piece.treatyTianjin: 'treaty_beijing',
      Piece.treatyMaguan: 'treaty_maguan',
      Piece.treatyXinchou: 'treaty_xinchou',
    };

    const unitTypeCounterNames = [
      (PieceType.fort, 'fort'),
      (PieceType.militia, 'militia'),
      (PieceType.bannerOrdinary, 'infantry'),
      (PieceType.bannerVeteran, 'infantry_veteran'),
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

    final Map<ProvinceStatus,String?> provinceStatusCounterNames = {
      ProvinceStatus.barbarian: 'barbarian',
      ProvinceStatus.foreignAmerican: 'foreign_american',
      ProvinceStatus.foreignBritish: 'foreign_british',
      ProvinceStatus.foreignDutch: 'foreign_dutch',
      ProvinceStatus.foreignFrench: 'foreign_french',
      ProvinceStatus.foreignGerman: 'foreign_german',
      ProvinceStatus.foreignJapanese: 'foreign_japanese',
      ProvinceStatus.foreignPortuguese: 'foreign_portuguese',
      ProvinceStatus.foreignRussian: 'foreign_russian',
      ProvinceStatus.foreignSpanish: 'foreign_spanish',
      ProvinceStatus.vassal: 'vassal',
      ProvinceStatus.insurgent: 'insurgent',
      ProvinceStatus.chinese: null
    };

    for (final counterName in provinceStatusCounterNames.entries) {
      if (counterName.value != null) {
        final imagePath = 'assets/images/${counterName.value}.png';
        _provinceStatusImages[counterName.key] = Image.asset(imagePath, key: UniqueKey(), width: 48.0, height: 48.0);
      }
    }

    _commandImages.add(Image.asset('assets/images/rebel.png', key: UniqueKey(), width: 48.0, height: 48.0));

    final markers = [
      (MarkerType.cash, MarkerValueType.postive1, 'cashp1'),
      (MarkerType.cash, MarkerValueType.positive10, 'cashp10'),
      (MarkerType.cash, MarkerValueType.negative1, 'cashn1'),
      (MarkerType.cash, MarkerValueType.negative10, 'cashp10'),
      (MarkerType.cash, MarkerValueType.plus, 'cashp250'),
      (MarkerType.pay, MarkerValueType.postive1, 'pay1'),
      (MarkerType.pay, MarkerValueType.positive10, 'pay10'),
      (MarkerType.prestige, MarkerValueType.postive1, 'prestigep1'),
      (MarkerType.prestige, MarkerValueType.positive10, 'prestigep10'),
      (MarkerType.prestige, MarkerValueType.negative1, 'prestigen1'),
      (MarkerType.prestige, MarkerValueType.negative10, 'prestigen10'),
      (MarkerType.unrest, MarkerValueType.postive1, 'unrest'),
      (MarkerType.unrest, MarkerValueType.plus, 'unrestp25'),
      (MarkerType.turn, MarkerValueType.postive1, 'turn_qing'),
      (MarkerType.turn, MarkerValueType.negative1, 'turn_gmd'),
    ];

    for (final marker in markers) {
      _markerImages[(marker.$1, marker.$2)] = Image.asset('assets/images/${marker.$3}.png', key: UniqueKey(), width: 48.0, height: 48.0);
    }

    final dateMarkerYears = ['1644', '1735', '1820', '1889'];

    for (int era = 0; era < dateMarkerYears.length; ++era) {
      final year = dateMarkerYears[era];
      _dateMarkerImages.add(Image.asset('assets/images/scenario_$year.png', key: UniqueKey(), width: 48.0, height: 48.0));
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
      Location.provinceBeijing: (2465.0, 672.0),
      Location.provinceHenan: (2395.0, 998.0),
      Location.provincePortEdward: (2795.0, 868.0),
      Location.provinceQingdao: (2658.0, 889.0),
      Location.provinceShandong: (2545.0, 955.0),
      Location.provinceShanxi: (2346.0, 743.0),
      Location.provinceTianjin: (2490.0, 831.0),
      Location.provinceZhili: (2606.0, 637.0),
      Location.provinceFujian: (2602.0, 1402.0),
      Location.provinceGuangdong: (2418.0, 1451.0),
      Location.provinceGuangxi: (2242.0, 1500.0),
      Location.provinceGuangzhouwan: (2249.0, 1636.0),
      Location.provinceHainan: (2226.0, 1779.0),
      Location.provinceHongKong: (2506.0, 1584.0),
      Location.provinceMacau: (2378.0, 1620.0),
      Location.provinceYunnan: (1954.0, 1443.0),
      Location.provinceAnhui: (2514.0, 1101.0),
      Location.provinceJiangsu: (2666.0, 1031.0),
      Location.provinceJiangxi: (2502.0, 1288.0),
      Location.provinceNanjing: (2638.0, 1192.0),
      Location.provinceShanghai: (2785.0, 1136.0),
      Location.provinceZhejiang: (2746.0, 1287.0),
      Location.provinceChongqing: (2178.0, 1176.0),
      Location.provinceGansu: (1879.0, 696.0),
      Location.provinceGuizhou: (2177.0, 1344.0),
      Location.provinceHubei: (2353.0, 1152.0),
      Location.provinceHunan: (2338.0, 1325.0),
      Location.provinceLanzhou: (2049.0, 916.0),
      Location.provinceShaanxi: (2225.0, 940.0),
      Location.provinceSichuan: (2018.0, 1184.0),
      Location.provinceAihui: (2666.0, 195.0),
      Location.provinceAmuer: (2882.0, 136.0),
      Location.provinceHeilongjiang: (2778.0, 316.0),
      Location.provinceHinggan: (2603.0, 333.0),
      Location.provinceJilin: (2834.0, 468.0),
      Location.provinceKuyedao: (3097.0, 79.0),
      Location.provinceLiaoning: (2746.0, 604.0),
      Location.provincePortArthur: (2690.0, 743.0),
      Location.provinceRehe: (2610.0, 493.0),
      Location.provinceVladivostok: (3003.0, 502.0),
      Location.provinceWusuli: (3066.0, 280.0),
      Location.provinceChahar: (2395.0, 493.0),
      Location.provinceChechen: (2426.0, 336.0),
      Location.provinceDahuer: (2338.0, 160.0),
      Location.provinceKebuduo: (1743.0, 322.0),
      Location.provinceNingxia: (2032.0, 642.0),
      Location.provinceSaiyin: (2039.0, 401.0),
      Location.provinceSuiyuan: (2194.0, 636.0),
      Location.provinceTangnu: (1911.0, 202.0),
      Location.provinceTuchetu: (2202.0, 419.0),
      Location.provinceTuwalu: (1735.0, 98.0),
      Location.provinceWala: (1535.0, 194.0),
      Location.provinceZasaketu: (1879.0, 497.0),
      Location.provinceAlidi: (1410.0, 995.0),
      Location.provinceAsamu: (1586.0, 1396.0),
      Location.provinceBudan: (1602.0, 1252.0),
      Location.provinceDongzang: (1850.0, 1072.0),
      Location.provinceKeshimier: (1127.0, 682.0),
      Location.provinceLadake: (1194.0, 940.0),
      Location.provinceNiboer: (1290.0, 1120.0),
      Location.provinceQangtang: (1482.0, 856.0),
      Location.provinceXijin: (1441.0, 1216.0),
      Location.provinceXizang: (1612.0, 1079.0),
      Location.provinceZangnan: (1802.0, 1240.0),
      Location.provinceAfuhan: (763.0, 633.0),
      Location.provinceBadasha: (978.0, 616.0),
      Location.provinceBuhala: (913.0, 468.0),
      Location.provinceDihua: (1695.0, 545.0),
      Location.provinceHasake: (1239.0, 153.0),
      Location.provinceHuijiang: (1479.0, 689.0),
      Location.provinceHuokande: (1179.0, 512.0),
      Location.provinceMeierfu: (698.0, 443.0),
      Location.provinceQinghai: (1818.0, 868.0),
      Location.provinceTashigan: (986.0, 308.0),
      Location.provinceXiwa: (762.0, 239.0),
      Location.provinceYili: (1343.0, 358.0),
      Location.provinceZhunbu: (1543.0, 429.0),
      Location.provinceBusan: (2931.0, 851.0),
      Location.provinceChaoxian: (2882.0, 683.0),
      Location.provinceLuSong: (2730.0, 1780.0),
      Location.provinceManila: (2722.0, 1936.0),
      Location.provinceNagasaki: (2970.0, 1031.0),
      Location.provinceRiben: (3102.0, 971.0),
      Location.provinceRyukyu: (2994.0, 1308.0),
      Location.provinceSulu: (2602.0, 2080.0),
      Location.provinceTainan: (2698.0, 1595.0),
      Location.provinceTaiwan: (2738.0, 1444.0),
      Location.provinceAnnan: (2209.0, 2015.0),
      Location.provinceBangkok: (1801.0, 1979.0),
      Location.provinceDongJing: (2026.0, 1655.0),
      Location.provinceGaoMian: (1994.0, 1943.0),
      Location.provinceLaoWo: (1873.0, 1655.0),
      Location.provinceMalaya: (1769.0, 2143.0),
      Location.provinceMianDian: (1682.0, 1599.0),
      Location.provinceRangoon: (1667.0, 1775.0),
      Location.provinceSaigon: (2050.0, 2084.0),
      Location.provinceShanBang: (1762.0, 1443.0),
      Location.provinceXianLuo: (1866.0, 1835.0),
    };
    return coordinates[province]!;
  }

  (double, double) entryAreaCoordinates(Location entryArea) {
    const coordinates = {
      Location.entryAreaAmerican: (2896.0, 1715.0),
      Location.entryAreaBritishCavalry: (1143.0, 1207.0),
      Location.entryAreaBritishFleet0: (1552.0, 1608.0),
      Location.entryAreaBritishFleet1: (2561.0, 1823.0),
      Location.entryAreaDutch: (3108.0, 1184.0),
      Location.entryAreaFrench: (1911.0, 2099.0),
      Location.entryAreaGerman: (2808.0, 1015.0),
      Location.entryAreaJapanese: (3108.0, 840.0),
      Location.entryAreaPortuguese: (2384.0, 1832.0),
      Location.entryAreaRussianCavalry: (952.0, 116.0),
      Location.entryAreaRussianFleet: (2616.0, 81.0),
      Location.entryAreaSpanish: (2887.0, 2061.0),
    };
    return coordinates[entryArea]!;
  }

  void addProvinceStatusToMap(MyAppState appState, ProvinceStatus status, double x, double y) {
    Widget widget = _provinceStatusImages[status]!;

    double borderWidth = 0.0; 

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

    widget = Positioned(
      left: x - borderWidth,
      top: y - borderWidth,
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

  void addRebelMarkerToMap(MyAppState appState, double x, double y) {
    Widget widget = _commandImages[0];

    double borderWidth = 0.0; 

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

    widget = Positioned(
      left: x - borderWidth,
      top: y - borderWidth,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addMarkerToMap(MarkerType markerType, MarkerValueType markerValueType, double x, double y) {
    Widget widget = markerImage(markerType, markerValueType);
    
    double borderWidth = 0.0; 

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

    widget = Positioned(
      left: x - borderWidth,
      top: y - borderWidth,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addDateMarkerToMap(int era, double x, double y) {
    Widget widget = dateMarkerImage(era);
    
    double borderWidth = 0.0; 

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

    widget = Positioned(
      left: x - borderWidth,
      top: y - borderWidth,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addEventMarkerToMap(int count, double x, double y) {
    Widget widget = eventMarkerImage(count);
    
    double borderWidth = 0.0; 

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

    widget = Positioned(
      left: x - borderWidth,
      top: y - borderWidth,
      child: widget,
    );

    _mapStackChildren.add(widget);
  }

  void addProvinceToMap(BuildContext context, MyAppState appState, Location province, double x, double y) {
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
          innerColor = const Color.fromRGBO(0xFF, 0xFF, 0x00, 1.0);
        } else {
          final loyalty = gameState.commandAllegiance(command);
          switch (loyalty) {
          case Location.commandNorthChina:
            innerColor = const Color.fromRGBO(0xFF, 0xC0, 0x00, 1.0);
          case Location.commandSouthChina:
            innerColor = const Color.fromRGBO(0xFF, 0x00, 0x00, 1.0);
          case Location.commandEastChina:
            innerColor = const Color.fromRGBO(0x00, 0xB0, 0x50, 1.0);
          case Location.commandWestChina:
            innerColor = const Color.fromRGBO(0x00, 0xB0, 0xF0, 1.0);
          case Location.commandManchuria:
            innerColor = const Color.fromRGBO(0x92, 0xD0, 0x50, 1.0);
          case Location.commandMongolia:
            innerColor = const Color.fromRGBO(0x00, 0x00, 0x00, 1.0);
          case Location.commandTibet:
            innerColor = const Color.fromRGBO(0xFF, 0x66, 0x00, 1.0);
          case Location.commandXinjiang:
            innerColor = const Color.fromRGBO(0xD6, 0x00, 0x93, 1.0);
          case Location.commandEast:
            innerColor = const Color.fromRGBO(0x00, 0x70, 0xC0, 1.0);
          case Location.commandSouth:
            innerColor = const Color.fromRGBO(0xC0, 0x00, 0x00, 1.0);
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

    if (innerColor != null || outerColor != null) {
      double halfSize = 50.0;
      if (gameState.provinceIsPort(province)) {
        halfSize = 61.0;
      } else if (province == Location.provinceBeijing) {
        halfSize = 72.0;
      }

      Widget widget = SizedBox(
        height: 2.0 * halfSize,
        width: 2.0 * halfSize);

      Decoration? decoration;

      if (province == Location.provinceBeijing) {
        decoration = ShapeDecoration(
          shape: StarBorder(
            points: 4,
            innerRadiusRatio: 0.70,
            side: BorderSide(
              color: innerColor ?? Colors.transparent, width: 5.0),
          ),
          color: Colors.transparent,
        );
      } else if (!gameState.provinceIsPort(province)) {
        decoration = BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: innerColor ?? Colors.transparent, width: 5.0),
        );
      } else {
        decoration = ShapeDecoration(
          shape: StarBorder(
            points: 8,
            innerRadiusRatio: 0.75,
            side: BorderSide(
              color: innerColor ?? Colors.transparent, width: 5.0),
          ),
          color: Colors.transparent,
        );
      }

      widget = Container(
        decoration: decoration,
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

  void layoutProvince(BuildContext context, MyAppState appState, Location province, int pass) {
    final state = appState.gameState!;

    final coordinates = provinceCoordinates(province);
    final spaceX = coordinates.$1;
    final spaceY = coordinates.$2;

    bool choosable = appState.playerChoices != null && appState.playerChoices!.locations.contains(province);

    if (pass == 0 && !choosable) {
      addProvinceToMap(context, appState, province, spaceX, spaceY);
    }

    if (!_emptyMap) {
      final stackLocations = [
        (spaceX - 24.0, spaceY - 52.0, 0.0, 0.0),	// Top middle, no stacking
        (spaceX - 52.0, spaceY - 52.0, 0.0, 0.0),	// Upper left, no stacking
        (spaceX + 1.0, spaceY - 52.0, 6.0, -6.0),	// Upper right
        (spaceX - 52.0, spaceY + 1.0, 0.0, 14.0),	// Lower left, stack down
        (spaceX - 24.0, spaceY + 1.0, 0.0, 14.0),	// Lower middle, stack down
        (spaceX - 24.0, spaceY + 1.0, 6.0, 6.0),	// Lower middle, stack down/right
        (spaceX + 1.0, spaceY + 1.0, 6.0, 6.0)	// Lower right
      ];

      final chinese = state.piecesInLocation(PieceType.mobileLandUnit, province);
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
        layoutStack(appState, sk, chinese, sl.$1, sl.$2, sl.$3, sl.$4);
      }

      sk = (province, 2);
      if (_expandedStacks.contains(sk) == (pass == 1)) {
        if (chinese.isNotEmpty) {
          sl = stackLocations[3];
        } else {
          sl = stackLocations[4];
        }
        layoutStack(appState, sk, barbarians, sl.$1, sl.$2, sl.$3, sl.$4);
      }

      if (pass == 0) {
        final status = state.provinceStatus(province);
        if (status != ProvinceStatus.chinese) {
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
      addProvinceToMap(context, appState, province, spaceX, spaceY);
    }
  }

  void layoutProvinces(BuildContext context, MyAppState appState, int pass) {
    for (final province in LocationType.province.locations) {
      layoutProvince(context, appState, province, pass);
    }
  }

  void layoutEntryArea(MyAppState appState, Location entryArea, int pass) {
    final state = appState.gameState!;

    final sk = (entryArea, 0);
    if (_expandedStacks.contains(sk) == (pass == 1)) {
      final barbarians = state.piecesInLocation(PieceType.barbarian, entryArea);

      if (barbarians.isNotEmpty) {
        final coordinates = entryAreaCoordinates(entryArea);
        final spaceX = coordinates.$1;
        final spaceY = coordinates.$2;

        layoutStack(appState, sk, barbarians, spaceX - 30, spaceY - 30, -6, 6);
      }
    }
  }

  void layoutEntryAreas(MyAppState appState, int pass) {
    for (final entryArea in LocationType.entryArea.locations) {
      layoutEntryArea(appState, entryArea, pass);
    }
  }

  void layoutCommand(MyAppState appState, Location command) {
    final state = appState.gameState!;

    if (!state.commandActive(command)) {
      return;
    }

    int row = 0;
    int col = 0;

    double left = 0.0;
    double top = 0.0;
    if (command.isType(LocationType.ruler)) {
      left = 1632.0;
      top = 2102.0;
      row = command.index - LocationType.ruler.firstIndex;
      col = 0;
    } else {
      left = 1940.0;
      top = 2213.0;
      row = 0;
      col = command.index - LocationType.governorship.firstIndex;
    }

    double spaceX = left + 115.0 * col;
    double spaceY = top + 115.0 * row;

    bool choosable = appState.playerChoices != null && appState.playerChoices!.locations.contains(command);

    if (!choosable) {
      addCommandToMap(appState, command, spaceX, spaceY);
    }

    Piece? commander = state.pieceInLocation(PieceType.statesman, command);
    final wars = state.piecesInLocation(PieceType.war, command);
    bool rebel = state.commandRebel(command);
    
    if (commander != null) {
      double x = spaceX - 24.0;
      double y = spaceY - 24.0;
      if (wars.isNotEmpty || rebel) {
        y -= 27.0;
      }
      addPieceToMap(appState, commander, x, y);
    }

    for (int i = 0; i < wars.length; ++i) {
      double x = spaceX - 24.0;
      double y = spaceY + 2.0;
      if (rebel) {
        x += 26.0;
      }
      x -= i * 3.0;
      y += i * 3.0;
      addPieceToMap(appState, wars[i], x, y);
    }

    if (rebel) {
      if (commander == null) {
        double x = spaceX - 24.0;
        double y = spaceY - 24.0;
        if (wars.isNotEmpty) {
          y -= 27.0;
        }
        addRebelMarkerToMap(appState, x, y);
      } else {
        double x = spaceX - 24.0;
        double y = spaceY + 2.0;
        if (wars.isNotEmpty) {
          x -= 26.0;
        }
        addRebelMarkerToMap(appState, x, y);
      }
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

  void layoutExile(MyAppState appState) {
    final state = appState.gameState!;
    layoutStack(appState, (Location.boxExile, 0), state.piecesInLocation(PieceType.statesman, Location.boxExile), 3058.0, 2190.0, 6.0, 6.0);
  }

  void layoutTreasuryZeroCell(List<(MarkerType, MarkerValueType)> markers, double x, double y, double dx, double dy) {
    for (final marker in markers) {
      addMarkerToMap(marker.$1, marker.$2, x, y);
      y += 48.0;
    }
  }

  void layoutTreasuryLeftCell(List<(MarkerType, MarkerValueType)> markers, double x, double y, double dx, double dy) {
    for (final marker in markers) {
      addMarkerToMap(marker.$1, marker.$2, x, y);
      x += 48.0;
    }
  }

  void layoutTreasuryRightCell(List<(MarkerType, MarkerValueType)> markers, double x, double y, double dx, double dy) {
    for (final marker in markers) {
      addMarkerToMap(marker.$1, marker.$2, x, y);
      x += dx;
      y += dy;
    }
  }

  void layoutTreasury(MyAppState appState) {
    final state = appState.gameState!;

    int pay = state.pay;
    int cash = state.cash;
    int prestige = state.prestige;
    int unrest = state.unrest;

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

      if (cash >= 250 && cash ~/ 10 == 25 + i) {
        markers.add((MarkerType.cash, MarkerValueType.plus));
      }
      if (cash >= 0 && cash < 250 && cash ~/ 10 == i) {
        markers.add((MarkerType.cash, MarkerValueType.positive10));
      }
      if (cash >= 0 && cash % 10 == i) {
        markers.add((MarkerType.cash, MarkerValueType.postive1));
      }
      if (cash < 0 && -cash ~/ 10 == i) {
        markers.add((MarkerType.cash, MarkerValueType.negative10));
      }
      if (cash < 0 && -cash % 10 == i) {
        markers.add((MarkerType.cash, MarkerValueType.negative1));
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
        markers.add((MarkerType.turn, state.rulingCommand == Location.commandEmperor ? MarkerValueType.postive1 : MarkerValueType.negative1));
      }

      double left = 1066.0;
      double top = 2020.0;

      double x = 0.0;
      double y = 0.0;

      if (i == 0) {
        x = left;
        y = top;
        layoutTreasuryZeroCell(markers, x, y, 15.0, 15.0);
      } else if (i <= 10) {
        int row = (i - 1) % 5;
        int col = (i - 1) ~/ 5;
        x = left + 56.0 + col * 152.0;
        y = top + row * 48.0;
        layoutTreasuryLeftCell(markers, x, y, 15.0, 15.0);
      } else {
        int row = (i - 11) ~/ 3;
        int col = (i - 11) % 3;
        x = left + 360.0 + col * 48.0;
        y = top + row * 48.0;
        layoutTreasuryRightCell(markers, x, y, 15.0, 15.0);
      }
    }
  }

  void layoutStatesmenBox(MyAppState appState) {
    final state = appState.gameState!;

    int dateIndex = state.turn ~/ 10;

    int poolCount = state.piecesInLocationCount(PieceType.statesmenPool, Location.poolStatesmen);

    (double, double) statesmanBoxCoordinates(int sequence) {
      int col = sequence % 8;
      int row = sequence ~/ 8;
      double x = 51.0 + col * 56.0;
      double y = 458.0 + row * 56.0;
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
      double x = 51.0 + col * 56.0;
      double y = 88.0 + row * 56.0;
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
        int rowMinor = i % 9;
        int rowMajor = i ~/ 9;
        const lefts = [114.0, 116.0];
        const tops = [969.0, 1547.0];
        addEventMarkerToMap(state.eventTypeCount(eventType), lefts[rowMajor], tops[rowMajor] + rowMinor * 58.0);
      }
    }
  }

  void layoutTreatiesBox(MyAppState appState) {
    final state = appState.gameState!;
    for (final treaty in PieceType.treaty.pieces) {
      final location = state.pieceLocation(treaty);
      if (location.isType(LocationType.treaty)) {
        int row = treaty.index - PieceType.treaty.firstIndex;
        double x = 564.0;
        double y = 1592.0 + row * 81.4;
        addPieceToMap(appState, treaty, x, y);
      }
    }
  }

  void layoutBarracksBox(MyAppState appState) {
    final state = appState.gameState!;
    final pieceTypeUnits = [
      state.piecesInLocation(PieceType.guardOrdinary, Location.boxBarracks),
      state.piecesInLocation(PieceType.cavalryOrdinary, Location.boxBarracks),
      state.piecesInLocation(PieceType.fleetOrdinary, Location.boxBarracks),
      state.piecesInLocation(PieceType.bannerOrdinary, Location.boxBarracks),
      state.piecesInLocation(PieceType.fort, Location.boxBarracks),
      state.piecesInLocation(PieceType.militia, Location.boxBarracks),
    ];
    for (int pieceTypeIndex = 0; pieceTypeIndex < pieceTypeUnits.length; ++pieceTypeIndex) {
      for (int i = 0; i < pieceTypeUnits[pieceTypeIndex].length; ++i) {
        final unit = pieceTypeUnits[pieceTypeIndex][i];
        int col = pieceTypeIndex;
        int row = i % 3;
        int depth = i ~/ 3;
        double x = 1082.0 + col * 65.0 + depth * 4.0;
        double y = 1575.0 + row * 56.0 + depth * 4.0;
        addPieceToMap(appState, unit, x, y);
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

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String empireStatus = '';

    if (gameState != null) {

      String governmentDesc;
      String rulerDesc;
      if (gameState.rulingCommand == Location.commandEmperor) {
        governmentDesc = 'Empire';
        rulerDesc = 'Regent';
      } else {
        governmentDesc = 'Republic';
        rulerDesc = 'Provisional President';
      }
      final statesman = gameState.pieceInLocation(PieceType.statesman, gameState.rulingCommand);
      if (statesman != null) {
        rulerDesc = '**${gameState.adornedStatesmanName(statesman)}**';
      }

      empireStatus = '''
# $governmentDesc under $rulerDesc, ${appState.game!.yearDesc(gameState.turn)}
___
|Prestige|Unrest|Cash|Pay|Tax Base|
|:---:|:---:|:---:|:---:|:---:|
|${gameState.prestige}|${gameState.unrest}|${gameState.cash}|${gameState.pay}|${gameState.taxBase}|
''';

      if (!_emptyMap) {
        layoutCommands(appState);
        layoutExile(appState);
        layoutTreasury(appState);
        layoutStatesmenBox(appState);
        layoutWarsBox(appState);
        layoutEvents(appState);
        layoutTreatiesBox(appState);
        layoutBarracksBox(appState);
        layoutEntryAreas(appState, 0);
        layoutProvinces(context, appState, 0);
        layoutEntryAreas(appState, 1);
        layoutProvinces(context, appState, 1);
      }

      const choiceTexts = {
        Choice.extraTaxes: 'Extra Taxes',
        Choice.fightWar: 'Fight War',
        Choice.fightWarsForego: 'Forego Fighting remaining Wars',
        Choice.fightRebelsForego: 'Forego Fighting remaining Rebels',
        Choice.lossDismiss: 'Dismiss Unit(s)',
        Choice.lossDemote: 'Demote Unit',
        Choice.lossUnrest: 'Increase Unrest',
        Choice.lossPrestige: 'Reduce Prestige',
        Choice.lossTribute: 'Tribute',
        Choice.lossRevolt: 'Revolt',
        Choice.lossCede: 'Cede',
        Choice.decreaseUnrest: 'Reduce Unrest',
        Choice.increasePrestige: 'Increase Prestige',
        Choice.addGold: 'Increase Gold',
        Choice.promote: 'Promote Unit',
        Choice.annex: 'Annex',
        Choice.chinese: 'Chinese',
        Choice.american: 'American',
        Choice.british: 'British',
        Choice.dutch: 'Dutch',
        Choice.french: 'French',
        Choice.german: 'German',
        Choice.japanese: 'Japanese',
        Choice.portuguese: 'Portuguese',
        Choice.russian: 'Russian',
        Choice.spanish: 'Spanish',
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
            width: 450.0,
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

import 'dart:convert';
import 'dart:math';
import 'package:china_inc/db.dart';
import 'package:china_inc/random.dart';

enum Location {
  provinceBeijing,
  provinceHenan,
  provincePortEdward,
  provinceQingdao,
  provinceShandong,
  provinceShanxi,
  provinceTianjin,
  provinceZhili,
  provinceFujian,
  provinceGuangdong,
  provinceGuangxi,
  provinceGuangzhouwan,
  provinceHainan,
  provinceHongKong,
  provinceMacau,
  provinceYunnan,
  provinceAnhui,
  provinceJiangsu,
  provinceJiangxi,
  provinceNanjing,
  provinceShanghai,
  provinceZhejiang,
  provinceChongqing,
  provinceGansu,
  provinceGuizhou,
  provinceHubei,
  provinceHunan,
  provinceLanzhou,
  provinceShaanxi,
  provinceSichuan,
  provinceAihui,
  provinceAmuer,
  provinceHeilongjiang,
  provinceHinggan,
  provinceJilin,
  provinceKuyedao,
  provinceLiaoning,
  provincePortArthur,
  provinceRehe,
  provinceVladivostok,
  provinceWusuli,
  provinceChahar,
  provinceChechen,
  provinceDahuer,
  provinceKebuduo,
  provinceNingxia,
  provinceSaiyin,
  provinceSuiyuan,
  provinceTangnu,
  provinceTuchetu,
  provinceTuwalu,
  provinceWala,
  provinceZasaketu,
  provinceAlidi,
  provinceAsamu,
  provinceBudan,
  provinceDongzang,
  provinceKeshimier,
  provinceLadake,
  provinceNiboer,
  provinceQangtang,
  provinceXijin,
  provinceXizang,
  provinceZangnan,
  provinceAfuhan,
  provinceBadasha,
  provinceBuhala,
  provinceDihua,
  provinceHasake,
  provinceHuijiang,
  provinceHuokande,
  provinceMeierfu,
  provinceQinghai,
  provinceTashigan,
  provinceXiwa,
  provinceYili,
  provinceZhunbu,
  provinceBusan,
  provinceChaoxian,
  provinceLuSong,
  provinceManila,
  provinceNagasaki,
  provinceRiben,
  provinceRyukyu,
  provinceSulu,
  provinceTainan,
  provinceTaiwan,
  provinceAnnan,
  provinceBangkok,
  provinceDongJing,
  provinceGaoMian,
  provinceLaoWo,
  provinceMalaya,
  provinceMianDian,
  provinceRangoon,
  provinceSaigon,
  provinceShanBang,
  provinceXianLuo,
  entryAreaAmerican,
  entryAreaBritishCavalry,
  entryAreaBritishFleet0,
  entryAreaBritishFleet1,
  entryAreaDutch,
  entryAreaFrench,
  entryAreaGerman,
  entryAreaJapanese,
  entryAreaPortuguese,
  entryAreaRussianCavalry,
  entryAreaRussianFleet,
  entryAreaSpanish,
  commandEmperor,
  commandPresident,
  commandNorthChina,
  commandSouthChina,
  commandEastChina,
  commandWestChina,
  commandManchuria,
  commandMongolia,
  commandTibet,
  commandXinjiang,
  commandEast,
  commandSouth,
  boxExile,
  boxStatesmen,
  boxTreatyNerchinsk,
  boxTreatyKyakhta,
  boxTreatyNanjing,
  boxTreatyTianjin,
  boxTreatyMagnan,
  boxTreatyXinchou,
  boxBarracks,
  poolStatesmen,
  poolWars,
  track0,
  track1,
  track2,
  track3,
  track4,
  track5,
  track6,
  track7,
  track8,
  track9,
  track10,
  track11,
  track12,
  track13,
  track14,
  track15,
  track16,
  track17,
  track18,
  track19,
  track20,
  track21,
  track22,
  track23,
  track24,
  track25,
  flipped,
  offmap,
}

enum LocationType {
  space,
  province,
  provinceNorthChina,
  provinceSouthChina,
  provinceEastChina,
  provinceWestChina,
  provinceManchuria,
  provinceMongolia,
  provinceTibet,
  provinceXinjiang,
  provinceEast,
  provinceSouth,
  entryArea,
  command,
  ruler,
  governorship,
  treaty,
  track,
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
    LocationType.space: [Location.provinceBeijing, Location.entryAreaSpanish],
    LocationType.province: [Location.provinceBeijing, Location.provinceXianLuo],
    LocationType.provinceNorthChina: [Location.provinceBeijing, Location.provinceZhili],
    LocationType.provinceSouthChina: [Location.provinceFujian, Location.provinceYunnan],
    LocationType.provinceEastChina: [Location.provinceAnhui, Location.provinceZhejiang],
    LocationType.provinceWestChina: [Location.provinceChongqing, Location.provinceSichuan],
    LocationType.provinceManchuria: [Location.provinceAihui, Location.provinceWusuli],
    LocationType.provinceMongolia: [Location.provinceChahar, Location.provinceZasaketu],
    LocationType.provinceTibet: [Location.provinceAlidi, Location.provinceZangnan],
    LocationType.provinceXinjiang: [Location.provinceAfuhan, Location.provinceZhunbu],
    LocationType.provinceEast: [Location.provinceBusan, Location.provinceTaiwan],
    LocationType.provinceSouth: [Location.provinceAnnan, Location.provinceXianLuo],
    LocationType.entryArea: [Location.entryAreaAmerican, Location.entryAreaSpanish],
    LocationType.command: [Location.commandEmperor, Location.commandSouth],
    LocationType.ruler: [Location.commandEmperor, Location.commandPresident],
    LocationType.governorship: [Location.commandNorthChina, Location.commandSouth],
    LocationType.treaty: [Location.boxTreatyNerchinsk, Location.boxTreatyXinchou],
    LocationType.track: [Location.track0, Location.track25],
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
    const locationDescs = {
      Location.provinceBeijing: 'Beijing',
      Location.provinceHenan: 'Henan',
      Location.provincePortEdward: 'Port Edward',
      Location.provinceQingdao: 'Qingdao',
      Location.provinceShandong: 'Shandong',
      Location.provinceShanxi: 'Shanxi',
      Location.provinceTianjin: 'Tianjin',
      Location.provinceZhili: 'Zhili',
      Location.provinceFujian: 'Fujian',
      Location.provinceGuangdong: 'Guangdong',
      Location.provinceGuangxi: 'Guangxi',
      Location.provinceGuangzhouwan: 'Guangzhouwan',
      Location.provinceHainan: 'Hainan',
      Location.provinceHongKong: 'Hong Kong',
      Location.provinceMacau: 'Macau',
      Location.provinceYunnan: 'Yunnan',
      Location.provinceAnhui: 'Anhui',
      Location.provinceJiangsu: 'Jiangsu',
      Location.provinceJiangxi: 'Jiangxi',
      Location.provinceNanjing: 'Nanjing',
      Location.provinceShanghai: 'Shanghai',
      Location.provinceZhejiang: 'Zhejiang',
      Location.provinceChongqing: 'Chongqing',
      Location.provinceGansu: 'Gansu',
      Location.provinceGuizhou: 'Guizhou',
      Location.provinceHubei: 'Hubei',
      Location.provinceHunan: 'Hunan',
      Location.provinceLanzhou: 'Lanzhou',
      Location.provinceShaanxi: 'Shaanxi',
      Location.provinceSichuan: 'Sichuan',
      Location.provinceAihui: 'Aihui',
      Location.provinceAmuer: 'Amuer',
      Location.provinceHeilongjiang: 'Heilongjiang',
      Location.provinceHinggan: 'Hinggan',
      Location.provinceJilin: 'Jilin',
      Location.provinceKuyedao: 'Kuyedao',
      Location.provinceLiaoning: 'Liaoning',
      Location.provincePortArthur: 'Port Arthur',
      Location.provinceRehe: 'Rehe',
      Location.provinceVladivostok: 'Vladivostock',
      Location.provinceWusuli: 'Wusuli',
      Location.provinceChahar: 'Chahar',
      Location.provinceChechen: 'Chechen',
      Location.provinceDahuer: 'Dahuer',
      Location.provinceKebuduo: 'Kebuduo',
      Location.provinceNingxia: 'Ningxia',
      Location.provinceSaiyin: 'Saiyin',
      Location.provinceSuiyuan: 'Suiyuan',
      Location.provinceTangnu: 'Tangnu',
      Location.provinceTuchetu: 'Tuchetu',
      Location.provinceTuwalu: 'Tuwalu',
      Location.provinceWala: 'Wala',
      Location.provinceZasaketu: 'Zasaketu',
      Location.provinceAlidi: 'Alidi',
      Location.provinceAsamu: 'Asamu',
      Location.provinceBudan: 'Budan',
      Location.provinceDongzang: 'Dongzang',
      Location.provinceKeshimier: 'Keshimier',
      Location.provinceLadake: 'Ladake',
      Location.provinceNiboer: 'Niboer',
      Location.provinceQangtang: 'Qangtang',
      Location.provinceXijin: 'Xijin',
      Location.provinceXizang: 'Xizang',
      Location.provinceZangnan: 'Zangnan',
      Location.provinceAfuhan: 'Afuhan',
      Location.provinceBadasha: 'Badasha',
      Location.provinceBuhala: 'Buhala',
      Location.provinceDihua: 'Dihua',
      Location.provinceHasake: 'Hasake',
      Location.provinceHuijiang: 'Huijiang',
      Location.provinceHuokande: 'Huokande',
      Location.provinceMeierfu: 'Meierfu',
      Location.provinceQinghai: 'Qinghai',
      Location.provinceTashigan: 'Tashigan',
      Location.provinceXiwa: 'Xiwa',
      Location.provinceYili: 'Yili',
      Location.provinceZhunbu: 'Zhunbu',
      Location.provinceBusan: 'Busan',
      Location.provinceChaoxian: 'Chaoxian',
      Location.provinceLuSong: 'Lu Song',
      Location.provinceManila: 'Manila',
      Location.provinceNagasaki: 'Nagasaki',
      Location.provinceRiben: 'Riben',
      Location.provinceRyukyu: 'Ryukyu',
      Location.provinceSulu: 'Sulu',
      Location.provinceTainan: 'Tainan',
      Location.provinceTaiwan: 'Taiwan',
      Location.provinceAnnan: 'Annan',
      Location.provinceBangkok: 'Bangkok',
      Location.provinceDongJing: 'Dong Jing',
      Location.provinceGaoMian: 'Gao Mian',
      Location.provinceLaoWo: 'Lao Wo',
      Location.provinceMalaya: 'Malaya',
      Location.provinceMianDian: 'Mian Dian',
      Location.provinceRangoon: 'Rangoon',
      Location.provinceSaigon: 'Saigon',
      Location.provinceShanBang: 'Shan Bang',
      Location.provinceXianLuo: 'Xian Luo',
      Location.entryAreaAmerican: 'American Entry Area',
      Location.entryAreaBritishCavalry: 'British Army Entry Area',
      Location.entryAreaBritishFleet0: 'British Fleet West Entry Area',
      Location.entryAreaBritishFleet1: 'British Fleet East Entry Area',
      Location.entryAreaDutch: 'Duth Entry Area',
      Location.entryAreaFrench: 'French Entry Area',
      Location.entryAreaGerman: 'German Entry Area',
      Location.entryAreaJapanese: 'Japanese Entry Area',
      Location.entryAreaPortuguese: 'Portuguese Entry Area',
      Location.entryAreaRussianCavalry: 'Russian Army Entry Area',
      Location.entryAreaRussianFleet: 'Russian Fleet Entry Area',
      Location.entryAreaSpanish: 'Spanish Entry Area',
      Location.commandEmperor: 'Emperor',
      Location.commandPresident: 'President',
      Location.commandNorthChina: 'North China',
      Location.commandSouthChina: 'South China',
      Location.commandEastChina: 'East China',
      Location.commandWestChina: 'West China',
      Location.commandManchuria: 'Manchuria',
      Location.commandMongolia: 'Mongolia',
      Location.commandTibet: 'Tibet',
      Location.commandXinjiang: 'Xinjiang',
      Location.commandEast: 'The East',
      Location.commandSouth: 'The South',
    };
    return locationDescs[this]!;
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
  militia0,
  militia1,
  militia2,
  militia3,
  militia4,
  militia5,
  militia6,
  militia7,
  militia8,
  militia9,
  militia10,
  militia11,
  militia12,
  militia13,
  militia14,
  militia15,
  militia16,
  militia17,
  militia18,
  militia19,
  banner0,
  banner1,
  banner2,
  banner3,
  banner4,
  banner5,
  banner6,
  banner7,
  banner8,
  banner9,
  banner10,
  banner11,
  banner12,
  banner13,
  banner14,
  banner15,
  banner16,
  banner17,
  banner18,
  banner19,
  banner20,
  banner21,
  banner22,
  banner23,
  bannerVeteran0,
  bannerVeteran1,
  bannerVeteran2,
  bannerVeteran3,
  bannerVeteran4,
  bannerVeteran5,
  bannerVeteran6,
  bannerVeteran7,
  bannerVeteran8,
  bannerVeteran9,
  bannerVeteran10,
  bannerVeteran11,
  bannerVeteran12,
  bannerVeteran13,
  bannerVeteran14,
  bannerVeteran15,
  bannerVeteran16,
  bannerVeteran17,
  bannerVeteran18,
  bannerVeteran19,
  bannerVeteran20,
  bannerVeteran21,
  bannerVeteran22,
  bannerVeteran23,
  guard0,
  guard1,
  guardVeteran0,
  guardVeteran1,
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
  leaderGaldan,
  leaderHsinbyushin,
  leaderNguyen,
  leaderYaqub,
  leaderZhengYi,
  leaderStatesmanCaoFutian,
  leaderStatesmanKoxinga,
  leaderStatesmanMao,
  leaderStatesmanWangLun,
  leaderStatesmanXiuquan,
  warAmerican7,
  warBritish12,
  warBritish10,
  warBritish8,
  warDutch5,
  warFrench11,
  warFrench9,
  warGerman8,
  warJapanese15,
  warJapanese13,
  warJapanese11,
  warJapanese9,
  warPortuguese4,
  warRussian14,
  warRussian12,
  warRussian10,
  warSpanish6,
  warBoxer13,
  warCommunist15,
  warGurkha7,
  warGurkha5,
  warPirate8,
  warPirate6,
  warRedTurban12,
  warHui11,
  warJinchuan5,
  warMian8,
  warMiao9,
  warMiao7,
  warMongol14,
  warMongol12,
  warMongol10,
  warNian11,
  warPanthay13,
  warSikh4,
  warTaiping14,
  warTaiwan4,
  warThai6,
  warTibetan8,
  warTibetan6,
  warTurkish12,
  warTurkish11,
  warTurkish10,
  warViet9,
  warWhiteLotus9,
  warWokou7,
  warWokou5,
  statesmanDorgon,
  statesmanWuSangui,
  statesmanSharhuda,
  statesmanOboi,
  statesmanShiLang,
  statesmanKoxinga,
  statesmanSonggotu,
  statesmanShunzhi,
  statesmanKangxi,
  statesmanYongzheng,
  statesmanGengyao,
  statesmanYunsi,
  statesmanOrtai,
  statesmanYinxiang,
  statesmanZhongqi,
  statesmanYunti,
  statesmanQianlong,
  statesmanZhaohui,
  statesmanAgui,
  statesmanFuheng,
  statesmanSunShiyi,
  statesmanYongxuan,
  statesmanWangLun,
  statesmanYongqi,
  statesmanHeshen,
  statesmanFuKangan,
  statesmanYangFang,
  statesmanJiaqing,
  statesmanDaoguang,
  statesmanLinZexu,
  statesmanRinchen,
  statesmanGuofan,
  statesmanZuo,
  statesmanXiuquan,
  statesmanMianyu,
  statesmanHongzhang,
  statesmanXianfeng,
  statesmanYixin,
  statesmanCixi,
  statesmanLiuYongfu,
  statesmanTongzhi,
  statesmanCaoFutian,
  statesmanYinchang,
  statesmanShikai,
  statesmanSunYixian,
  statesmanGuangxu,
  statesmanZuolin,
  statesmanFeng,
  statesmanZhuDe,
  statesmanJiang,
  statesmanLiZongren,
  statesmanMao,
  statesmanShicai,
  statesmanPuyi,
  treatyNerchinsk,
  treatyKyakhta,
  treatyNanjing,
  treatyTianjin,
  treatyMaguan,
  treatyXinchou,
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
  fort,
  mobileUnit,
  mobileLandUnit,
  militia,
  banner,
  bannerOrdinary,
  bannerVeteran,
  guard,
  guardOrdinary,
  guardVeteran,
  cavalry,
  cavalryOrdinary,
  cavalryVeteran,
  fleet,
  fleetOrdinary,
  fleetVeteran,
  barbarian,
  leader,
  leaderLeader,
  leaderStatesman,
  war,
  foreignWar,
  nativeWar,
  statesman,
  treaty,
  statesmenPool,
}

extension PieceTypeExtension on PieceType {
  static const _bounds = {
    PieceType.all: [Piece.fort0, Piece.treatyXinchou],
    PieceType.unit: [Piece.fort0, Piece.fleetVeteran11],
    PieceType.landUnit: [Piece.fort0, Piece.cavalryVeteran5],
    PieceType.fort: [Piece.fort0, Piece.fort19],
    PieceType.mobileUnit: [Piece.militia0, Piece.fleetVeteran11],
    PieceType.mobileLandUnit: [Piece.militia0, Piece.cavalryVeteran5],
    PieceType.militia: [Piece.militia0, Piece.militia19],
    PieceType.banner: [Piece.banner0, Piece.bannerVeteran23],
    PieceType.bannerOrdinary: [Piece.banner0, Piece.banner23],
    PieceType.bannerVeteran: [Piece.bannerVeteran0, Piece.bannerVeteran23],
    PieceType.guard: [Piece.guard0, Piece.guardVeteran1],
    PieceType.guardOrdinary: [Piece.guard0, Piece.guard1],
    PieceType.guardVeteran: [Piece.guardVeteran0, Piece.guardVeteran1],
    PieceType.cavalry: [Piece.cavalry0, Piece.cavalryVeteran5],
    PieceType.cavalryOrdinary: [Piece.cavalry0, Piece.cavalry5],
    PieceType.cavalryVeteran: [Piece.cavalryVeteran0, Piece.cavalryVeteran5],
    PieceType.fleet: [Piece.fleet0, Piece.fleetVeteran11],
    PieceType.fleetOrdinary: [Piece.fleet0, Piece.fleet11],
    PieceType.fleetVeteran: [Piece.fleetVeteran0, Piece.fleetVeteran11],
    PieceType.barbarian: [Piece.leaderGaldan, Piece.warWokou5],
    PieceType.leader: [Piece.leaderGaldan, Piece.leaderStatesmanXiuquan],
    PieceType.leaderLeader: [Piece.leaderGaldan, Piece.leaderZhengYi],
    PieceType.leaderStatesman: [Piece.leaderStatesmanCaoFutian, Piece.leaderStatesmanXiuquan],
    PieceType.war: [Piece.warAmerican7, Piece.warWokou5],
    PieceType.foreignWar: [Piece.warAmerican7, Piece.warSpanish6],
    PieceType.nativeWar: [Piece.warBoxer13, Piece.warWokou5],
    PieceType.statesman: [Piece.statesmanDorgon, Piece.statesmanPuyi],
    PieceType.treaty: [Piece.treatyNerchinsk, Piece.treatyXinchou],
    PieceType.statesmenPool: [Piece.statesmanDorgon, Piece.treatyXinchou],
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
    const pieceDescs = {
      Piece.fort0: 'Fort',
      Piece.fort1: 'Fort',
      Piece.fort2: 'Fort',
      Piece.fort3: 'Fort',
      Piece.fort4: 'Fort',
      Piece.fort5: 'Fort',
      Piece.fort6: 'Fort',
      Piece.fort7: 'Fort',
      Piece.fort8: 'Fort',
      Piece.fort9: 'Fort',
      Piece.fort10: 'Fort',
      Piece.fort11: 'Fort',
      Piece.fort12: 'Fort',
      Piece.fort13: 'Fort',
      Piece.fort14: 'Fort',
      Piece.fort15: 'Fort',
      Piece.fort16: 'Fort',
      Piece.fort17: 'Fort',
      Piece.fort18: 'Fort',
      Piece.fort19: 'Fort',
      Piece.militia0: 'Militia',
      Piece.militia1: 'Militia',
      Piece.militia2: 'Militia',
      Piece.militia3: 'Militia',
      Piece.militia4: 'Militia',
      Piece.militia5: 'Militia',
      Piece.militia6: 'Militia',
      Piece.militia7: 'Militia',
      Piece.militia8: 'Militia',
      Piece.militia9: 'Militia',
      Piece.militia10: 'Militia',
      Piece.militia11: 'Militia',
      Piece.militia12: 'Militia',
      Piece.militia13: 'Militia',
      Piece.militia14: 'Militia',
      Piece.militia15: 'Militia',
      Piece.militia16: 'Militia',
      Piece.militia17: 'Militia',
      Piece.militia18: 'Militia',
      Piece.militia19: 'Militia',
      Piece.banner0: 'Infantry',
      Piece.banner1: 'Infantry',
      Piece.banner2: 'Infantry',
      Piece.banner3: 'Infantry',
      Piece.banner4: 'Infantry',
      Piece.banner5: 'Infantry',
      Piece.banner6: 'Infantry',
      Piece.banner7: 'Infantry',
      Piece.banner8: 'Infantry',
      Piece.banner9: 'Infantry',
      Piece.banner10: 'Infantry',
      Piece.banner11: 'Infantry',
      Piece.banner12: 'Infantry',
      Piece.banner13: 'Infantry',
      Piece.banner14: 'Infantry',
      Piece.banner15: 'Infantry',
      Piece.banner16: 'Infantry',
      Piece.banner17: 'Infantry',
      Piece.banner18: 'Infantry',
      Piece.banner19: 'Infantry',
      Piece.banner20: 'Infantry',
      Piece.banner21: 'Infantry',
      Piece.banner22: 'Infantry',
      Piece.banner23: 'Infantry',
      Piece.bannerVeteran0: 'Veteran Infantry',
      Piece.bannerVeteran1: 'Veteran Infantry',
      Piece.bannerVeteran2: 'Veteran Infantry',
      Piece.bannerVeteran3: 'Veteran Infantry',
      Piece.bannerVeteran4: 'Veteran Infantry',
      Piece.bannerVeteran5: 'Veteran Infantry',
      Piece.bannerVeteran6: 'Veteran Infantry',
      Piece.bannerVeteran7: 'Veteran Infantry',
      Piece.bannerVeteran8: 'Veteran Infantry',
      Piece.bannerVeteran9: 'Veteran Infantry',
      Piece.bannerVeteran10: 'Veteran Infantry',
      Piece.bannerVeteran11: 'Veteran Infantry',
      Piece.bannerVeteran12: 'Veteran Infantry',
      Piece.bannerVeteran13: 'Veteran Infantry',
      Piece.bannerVeteran14: 'Veteran Infantry',
      Piece.bannerVeteran15: 'Veteran Infantry',
      Piece.bannerVeteran16: 'Veteran Infantry',
      Piece.bannerVeteran17: 'Veteran Infantry',
      Piece.bannerVeteran18: 'Veteran Infantry',
      Piece.bannerVeteran19: 'Veteran Infantry',
      Piece.bannerVeteran20: 'Veteran Infantry',
      Piece.bannerVeteran21: 'Veteran Infantry',
      Piece.bannerVeteran22: 'Veteran Infantry',
      Piece.bannerVeteran23: 'Veteran Infantry',
      Piece.guard0: 'Guard',
      Piece.guard1: 'Guard',
      Piece.guardVeteran0: 'Veteran Guard',
      Piece.guardVeteran1: 'Veteran Guard',
      Piece.cavalry0: 'Cavalry',
      Piece.cavalry1: 'Cavalry',
      Piece.cavalry2: 'Cavalry',
      Piece.cavalry3: 'Cavalry',
      Piece.cavalry4: 'Cavalry',
      Piece.cavalry5: 'Cavalry',
      Piece.cavalryVeteran0: 'Veteran Cavalry',
      Piece.cavalryVeteran1: 'Veteran Cavalry',
      Piece.cavalryVeteran2: 'Veteran Cavalry',
      Piece.cavalryVeteran3: 'Veteran Cavalry',
      Piece.cavalryVeteran4: 'Veteran Cavalry',
      Piece.cavalryVeteran5: 'Veteran Cavalry',
      Piece.fleet0: 'Fleet',
      Piece.fleet1: 'Fleet',
      Piece.fleet2: 'Fleet',
      Piece.fleet3: 'Fleet',
      Piece.fleet4: 'Fleet',
      Piece.fleet5: 'Fleet',
      Piece.fleet6: 'Fleet',
      Piece.fleet7: 'Fleet',
      Piece.fleet8: 'Fleet',
      Piece.fleet9: 'Fleet',
      Piece.fleet10: 'Fleet',
      Piece.fleet11: 'Fleet',
      Piece.fleetVeteran0: 'Veteran Fleet',
      Piece.fleetVeteran1: 'Veteran Fleet',
      Piece.fleetVeteran2: 'Veteran Fleet',
      Piece.fleetVeteran3: 'Veteran Fleet',
      Piece.fleetVeteran4: 'Veteran Fleet',
      Piece.fleetVeteran5: 'Veteran Fleet',
      Piece.fleetVeteran6: 'Veteran Fleet',
      Piece.fleetVeteran7: 'Veteran Fleet',
      Piece.fleetVeteran8: 'Veteran Fleet',
      Piece.fleetVeteran9: 'Veteran Fleet',
      Piece.fleetVeteran10: 'Veteran Fleet',
      Piece.fleetVeteran11: 'Veteran Fleet',
      Piece.leaderGaldan: 'Galdan',
      Piece.leaderHsinbyushin: 'Hsinbyushin',
      Piece.leaderNguyen: 'Nguyen',
      Piece.leaderYaqub: 'Yaqub',
      Piece.leaderZhengYi: 'Zheng Yi',
      Piece.leaderStatesmanCaoFutian: 'Cao Futian',
      Piece.leaderStatesmanKoxinga: 'Koxinga',
      Piece.leaderStatesmanMao: 'Mao',
      Piece.leaderStatesmanWangLun: 'Wang Lun',
      Piece.leaderStatesmanXiuquan: 'Xiuquan',
      Piece.warAmerican7: '7/4 American War',
      Piece.warBritish12: '12/5 British War',
      Piece.warBritish10: '10/5 British War',
      Piece.warBritish8: '8/3 British War',
      Piece.warDutch5: '5/3 Dutch War',
      Piece.warFrench11: '11/4 French War',
      Piece.warFrench9: '9/4 French War',
      Piece.warGerman8: '8/4 German War',
      Piece.warJapanese15: '15/5 Japanese War',
      Piece.warJapanese13: '13/5 Japanese War',
      Piece.warJapanese11: '11/5 Japanese War',
      Piece.warJapanese9: '9/5 Japanese War',
      Piece.warPortuguese4: '4/3 Portuguese War',
      Piece.warRussian14: '14/4 Russian War',
      Piece.warRussian12: '12/4 Russian War',
      Piece.warRussian10: '10/4 Russian War',
      Piece.warSpanish6: '6/3 Spanish War',
      Piece.warBoxer13: '13/2 Boxer War',
      Piece.warCommunist15: '15/5 Communist War',
      Piece.warGurkha7: '7/1 Gurkha War',
      Piece.warGurkha5: '5/1 Gurkha War',
      Piece.warPirate8: '8/3 Pirate War',
      Piece.warPirate6: '6/3 Pirate War',
      Piece.warRedTurban12: '12/1 Red Turban War',
      Piece.warHui11: '11/1 Hui War',
      Piece.warJinchuan5: '5/1 Jinchuan War',
      Piece.warMian8: '8/2 Mian War',
      Piece.warMiao9: '9/1 Miao War',
      Piece.warMiao7: '7/1 Miao War',
      Piece.warMongol14: '14/4 Mongol War',
      Piece.warMongol12: '12/4 Mongol War',
      Piece.warMongol10: '10/4 Mongol War',
      Piece.warNian11: '11/2 Nian War',
      Piece.warPanthay13: '13/1 Panthay  War',
      Piece.warSikh4: '4/1 Sikh War',
      Piece.warTaiping14: '14/3 Taiping  War',
      Piece.warTaiwan4: '4/2 Taiwan War',
      Piece.warThai6: '6/2 Thai War',
      Piece.warTibetan8: '8/1 Tibetan War',
      Piece.warTibetan6: '6/1 Tibetan War',
      Piece.warTurkish12: '12/3 Turkish War',
      Piece.warTurkish11: '11/3 Turkish War',
      Piece.warTurkish10: '10/3 Turkish War',
      Piece.warViet9: '9/2 Viet War',
      Piece.warWhiteLotus9: '9/1 White Lotus War',
      Piece.warWokou7: '7/3 Wokou War',
      Piece.warWokou5: '5/3 Wokou War',
      Piece.statesmanDorgon: 'Dorgon',
      Piece.statesmanWuSangui: 'Wu Sangui',
      Piece.statesmanSharhuda: 'Sharhuda',
      Piece.statesmanOboi: 'Oboi',
      Piece.statesmanShiLang: 'Shi Lang',
      Piece.statesmanKoxinga: 'Koxinga',
      Piece.statesmanSonggotu: 'Songgotu',
      Piece.statesmanShunzhi: 'Shunzhi',
      Piece.statesmanKangxi: 'Kangxi',
      Piece.statesmanYongzheng: 'Yongzheng',
      Piece.statesmanGengyao: 'Gengyao',
      Piece.statesmanYunsi: 'Yunsi',
      Piece.statesmanOrtai: 'Ortai',
      Piece.statesmanYinxiang: 'Yinxiang',
      Piece.statesmanZhongqi: 'Zhongqi',
      Piece.statesmanYunti: 'Yunti',
      Piece.statesmanQianlong: 'Qianlong',
      Piece.statesmanZhaohui: 'Zhaohui',
      Piece.statesmanAgui: 'Agui',
      Piece.statesmanFuheng: 'Fuheng',
      Piece.statesmanSunShiyi: 'Sun Shiyi',
      Piece.statesmanYongxuan: 'Yongxuan',
      Piece.statesmanWangLun: 'Wang Lun',
      Piece.statesmanYongqi: 'Yongqi',
      Piece.statesmanHeshen: 'Heshen',
      Piece.statesmanFuKangan: 'Fu Kangan',
      Piece.statesmanYangFang: 'Yang Fang',
      Piece.statesmanJiaqing: 'Jiaqing',
      Piece.statesmanDaoguang: 'Daoguang',
      Piece.statesmanLinZexu: 'Lin Zexu',
      Piece.statesmanRinchen: 'Rinchen',
      Piece.statesmanGuofan: 'Guofan',
      Piece.statesmanZuo: 'Zuo',
      Piece.statesmanXiuquan: 'Xiuquan',
      Piece.statesmanMianyu: 'Mianyu',
      Piece.statesmanHongzhang: 'Hongzhang',
      Piece.statesmanXianfeng: 'Xianfeng',
      Piece.statesmanYixin: 'Yixin',
      Piece.statesmanCixi: 'Cixi',
      Piece.statesmanLiuYongfu: 'Liu Yongfu',
      Piece.statesmanTongzhi: 'Tongzhi',
      Piece.statesmanCaoFutian: 'Cao Futian',
      Piece.statesmanYinchang: 'Yin Chang',
      Piece.statesmanShikai: 'Shikai',
      Piece.statesmanSunYixian: 'Sun Yixian',
      Piece.statesmanGuangxu: 'Guangxu',
      Piece.statesmanZuolin: 'Zuolin',
      Piece.statesmanFeng: 'Feng',
      Piece.statesmanZhuDe: 'Zhu De',
      Piece.statesmanJiang: 'Jiang',
      Piece.statesmanLiZongren: 'Li Zongren',
      Piece.statesmanMao: 'Mao',
      Piece.statesmanShicai: 'Shicai',
      Piece.statesmanPuyi: 'Puyi',
      Piece.treatyNerchinsk: 'Nerchinsk Treaty',
      Piece.treatyKyakhta: 'Kyakhta Treaty',
      Piece.treatyNanjing: 'Nanjing Treaty',
      Piece.treatyTianjin: 'Tianjing Treaty',
      Piece.treatyMaguan: 'Maguan Treaty',
      Piece.treatyXinchou: 'Xinchou Treaty',
    };
    return pieceDescs[this]!;
  }
}

enum Enemy {
  american,
  british,
  dutch,
  french,
  german,
  japanese,
  portuguese,
  russian,
  spanish,
  boxer,
  communist,
  gurkha,
  pirate,
  redTurban,
  hui,
  jinchuan,
  mian,
  miao,
  mongol,
  nian,
  panthay,
  sikh,
  taiping,
  taiwan,
  thai,
  tibetan,
  turkish,
  viet,
  whiteLotus,
  wokou,
}

extension EnemyExtension on Enemy {
  String get desc {
    const enemyNames = {
      Enemy.american: 'Americans',
      Enemy.british: 'British',
      Enemy.dutch: 'Dutch',
      Enemy.french: 'French',
      Enemy.german: 'Germans',
      Enemy.japanese: 'Japanese',
      Enemy.portuguese: 'Portuguese',
      Enemy.russian: 'Russians',
      Enemy.spanish: 'Spanish',
      Enemy.boxer: 'Boxers',
      Enemy.communist: 'Communists',
      Enemy.gurkha: 'Gurkhas',
      Enemy.pirate: 'Pirates',
      Enemy.redTurban: 'Red Turbans',
      Enemy.hui: 'Hui',
      Enemy.jinchuan: 'Jinchuan',
      Enemy.mian: 'Mian',
      Enemy.miao: 'Miao',
      Enemy.mongol: 'Mongols',
      Enemy.nian: 'Nian',
      Enemy.panthay: 'Panthay',
      Enemy.sikh: 'Sikhs',
      Enemy.taiping: 'Taiping',
      Enemy.taiwan: 'Taiwanese',
      Enemy.thai: 'Thai',
      Enemy.tibetan: 'Tibetans',
      Enemy.turkish: 'Turks',
      Enemy.viet: 'Viet',
      Enemy.whiteLotus: 'White Lotus',
      Enemy.wokou: 'Wokou',
    };
    return enemyNames[this]!;
  }

  bool get isForeign {
    const foreignEnemies = [
      Enemy.american,
      Enemy.british,
      Enemy.dutch,
      Enemy.french,
      Enemy.german,
      Enemy.japanese,
      Enemy.portuguese,
      Enemy.russian,
      Enemy.spanish,
    ];
    return foreignEnemies.contains(this);
  }

  ProvinceStatus? get foreignStatus {
    const enemyStatuses = {
      Enemy.american: ProvinceStatus.foreignAmerican,
      Enemy.british: ProvinceStatus.foreignBritish,
      Enemy.dutch: ProvinceStatus.foreignDutch,
      Enemy.french: ProvinceStatus.foreignFrench,
      Enemy.german: ProvinceStatus.foreignGerman,
      Enemy.japanese: ProvinceStatus.foreignJapanese,
      Enemy.portuguese: ProvinceStatus.foreignPortuguese,
      Enemy.russian: ProvinceStatus.foreignRussian,
      Enemy.spanish: ProvinceStatus.foreignSpanish,
    };
    return enemyStatuses[this];
  }

  static List<Enemy> get allForeign {
    return [
      Enemy.american,
      Enemy.british,
      Enemy.dutch,
      Enemy.french,
      Enemy.german,
      Enemy.japanese,
      Enemy.portuguese,
      Enemy.russian,
      Enemy.spanish,
    ];
  }
}


enum ProvinceStatus {
  barbarian,
  foreignAmerican,
  foreignBritish,
  foreignDutch,
  foreignFrench,
  foreignGerman,
  foreignJapanese,
  foreignPortuguese,
  foreignRussian,
  foreignSpanish,
  vassal,
  insurgent,
  chinese,
}

extension ProvinceStatusExtension on ProvinceStatus {
  Enemy? get foreignEnemy {
    const enemies = {
      ProvinceStatus.foreignAmerican: Enemy.american,
      ProvinceStatus.foreignBritish: Enemy.british,
      ProvinceStatus.foreignDutch: Enemy.dutch,
      ProvinceStatus.foreignFrench: Enemy.french,
      ProvinceStatus.foreignGerman: Enemy.german,
      ProvinceStatus.foreignJapanese: Enemy.japanese,
      ProvinceStatus.foreignPortuguese: Enemy.portuguese,
      ProvinceStatus.foreignRussian: Enemy.russian,
      ProvinceStatus.foreignSpanish: Enemy.spanish,
    };
    return enemies[this];
  }

  String get desc {
    const statusNames = {
      ProvinceStatus.barbarian: 'Barbarian',
      ProvinceStatus.foreignAmerican: 'American',
      ProvinceStatus.foreignBritish: 'British',
      ProvinceStatus.foreignDutch: 'Dutch',
      ProvinceStatus.foreignFrench: 'French',
      ProvinceStatus.foreignGerman: 'German',
      ProvinceStatus.foreignJapanese: 'Japanese',
      ProvinceStatus.foreignPortuguese: 'Portuguese',
      ProvinceStatus.foreignRussian: 'Russian',
      ProvinceStatus.foreignSpanish: 'Spanish',
      ProvinceStatus.vassal: 'Vassal',
      ProvinceStatus.insurgent: 'Insurgent',
      ProvinceStatus.chinese: 'Chinese',
    };
    return statusNames[this]!;
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
  buddhists,
  christians,
  conquest,
  conspiracy,
  diplomat,
  dynasty,
  emigration,
  flood,
  inflation,
  isolation,
  muslims,
  omens,
  opium,
  persecution,
  pillage,
  plague,
  usurper,
}

enum Ability {
  assassin,
  conquest,
  diplomat,
  event,
  exile,
  leaderBoxer,
  leaderCommunist,
  leaderHui,
  leaderTaiping,
  leaderWhiteLotus,
  leaderWokou,
  prestige,
  rebel,
  stalemate,
  veteran,
  warFrench,
  warHui,
  warJapanese,
  warMiao,
  warMongol,
  warPirate,
  warRussian,
  warTaiping,
  warTaiwan,
  warTibetan,
  warTurkish,
  warWhiteLotus,
}

extension AbilityExtension on Ability {
  Enemy? get warEnemy {
    const enemies = {
      Ability.warFrench: Enemy.french,
      Ability.warHui: Enemy.hui,
      Ability.warJapanese: Enemy.japanese,
      Ability.warMiao: Enemy.miao,
      Ability.warMongol: Enemy.mongol,
      Ability.warPirate: Enemy.pirate,
      Ability.warRussian: Enemy.russian,
      Ability.warTaiping: Enemy.taiping,
      Ability.warTaiwan: Enemy.taiwan,
      Ability.warTibetan: Enemy.tibetan,
      Ability.warTurkish: Enemy.turkish,
      Ability.warWhiteLotus: Enemy.whiteLotus,
    };
    return enemies[this];
  }
}

enum ConnectionType {
  land,
  river,
  sea,
}

enum Scenario {
  from1644CeTo1735Ce,
  from1735CeTo1820Ce,
  from1820CeTo1889Ce,
  from1889CeTo1949Ce,
  from1644CeTo1820Ce,
  from1735CeTo1889Ce,
  from1820CeTo1949Ce,
  from1644CeTo1889Ce,
  from1735CeTo1949Ce,
  from1644CeTo1949Ce,
}

extension ScenarioExtension on Scenario {
  String get desc {
    const scenarioDescs = {
      Scenario.from1644CeTo1735Ce: '1644 – 1735',
      Scenario.from1735CeTo1820Ce: '1735 – 1820',
      Scenario.from1820CeTo1889Ce: '1820 – 1889',
      Scenario.from1889CeTo1949Ce: '1889 – 1949',
      Scenario.from1644CeTo1820Ce: '1644 – 1820',
      Scenario.from1735CeTo1889Ce: '1735 – 1889',
      Scenario.from1820CeTo1949Ce: '1820 – 1949',
      Scenario.from1644CeTo1889Ce: '1644 – 1889',
      Scenario.from1735CeTo1949Ce: '1735 – 1949',
      Scenario.from1644CeTo1949Ce: '1644 – 1949',
    };
    return scenarioDescs[this]!;
  }

  String get longDesc {
    const scenarioDescs = {
      Scenario.from1644CeTo1735Ce: '1644 to 1735 (10 Turns)',
      Scenario.from1735CeTo1820Ce: '1735 to 1820 (10 Turns)',
      Scenario.from1820CeTo1889Ce: '1820 to 1889 (10 Turns)',
      Scenario.from1889CeTo1949Ce: '1889 to 1949 (10 Turns)',
      Scenario.from1644CeTo1820Ce: '1644 to 1820 (20 Turns)',
      Scenario.from1735CeTo1889Ce: '1735 to 1889 (20 Turns)',
      Scenario.from1820CeTo1949Ce: '1820 to 1949 (20 Turns)',
      Scenario.from1644CeTo1889Ce: '1644 to 1889 (30 Turns)',
      Scenario.from1735CeTo1949Ce: '1735 to 1949 (30 Turns)',
      Scenario.from1644CeTo1949Ce: '1644 to 1949 (40 Turns)',
    };
    return scenarioDescs[this]!;
  }
}

const warData = {
  Piece.warAmerican7: (Enemy.american, 7, 4, 0),
  Piece.warBritish12: (Enemy.british, 12, 5, 0),
  Piece.warBritish10: (Enemy.british, 10, 5, 0),
  Piece.warBritish8: (Enemy.british, 8, 0, 3),
  Piece.warDutch5: (Enemy.dutch, 5, 3, 0),
  Piece.warFrench11: (Enemy.french, 11, 4, 0),
  Piece.warFrench9: (Enemy.french, 9, 4, 0),
  Piece.warGerman8: (Enemy.german, 8, 4, 0),
  Piece.warJapanese15: (Enemy.japanese, 15, 5, 0),
  Piece.warJapanese13: (Enemy.japanese, 13, 5, 0),
  Piece.warJapanese11: (Enemy.japanese, 11, 5, 0),
  Piece.warJapanese9: (Enemy.japanese, 9, 5, 0),
  Piece.warPortuguese4: (Enemy.portuguese, 4, 3, 0),
  Piece.warRussian14: (Enemy.russian, 14, 0, 4),
  Piece.warRussian12: (Enemy.russian, 12, 4, 0),
  Piece.warRussian10: (Enemy.russian, 10, 0, 4),
  Piece.warSpanish6: (Enemy.spanish, 6, 3, 0),
  Piece.warBoxer13: (Enemy.boxer, 13, 0, 2),
  Piece.warCommunist15: (Enemy.communist, 15, 0, 5),
  Piece.warGurkha7: (Enemy.gurkha, 7, 0, 1),
  Piece.warGurkha5: (Enemy.gurkha, 5, 0, 1),
  Piece.warPirate8: (Enemy.pirate, 8, 3, 0),
  Piece.warPirate6: (Enemy.pirate, 6, 3, 0),
  Piece.warRedTurban12: (Enemy.redTurban, 12, 0, 1),
  Piece.warHui11: (Enemy.hui, 11, 0, 1),
  Piece.warJinchuan5: (Enemy.jinchuan, 5, 0, 1),
  Piece.warMian8: (Enemy.mian, 8, 0, 2),
  Piece.warMiao9: (Enemy.miao, 9, 0, 1),
  Piece.warMiao7: (Enemy.miao, 7, 0, 1),
  Piece.warMongol14: (Enemy.mongol, 14, 0, 4),
  Piece.warMongol12: (Enemy.mongol, 12, 0, 4),
  Piece.warMongol10: (Enemy.mongol, 10, 0, 4),
  Piece.warNian11: (Enemy.nian, 11, 0, 2),
  Piece.warPanthay13: (Enemy.panthay, 13, 0, 1),
  Piece.warSikh4: (Enemy.sikh, 4, 0, 1),
  Piece.warTaiping14: (Enemy.taiping, 14, 0, 3),
  Piece.warTaiwan4: (Enemy.taiwan, 4, 2, 0),
  Piece.warThai6: (Enemy.thai, 6, 0, 2),
  Piece.warTibetan8: (Enemy.tibetan, 8, 0, 1),
  Piece.warTibetan6: (Enemy.tibetan, 6, 0, 1),
  Piece.warTurkish12: (Enemy.turkish, 12, 0, 3),
  Piece.warTurkish11: (Enemy.turkish, 11, 0, 3),
  Piece.warTurkish10: (Enemy.turkish, 10, 0, 3),
  Piece.warViet9: (Enemy.viet, 9, 2, 0),
  Piece.warWhiteLotus9: (Enemy.whiteLotus, 9, 0, 1),
  Piece.warWokou7: (Enemy.wokou, 7, 3, 0),
  Piece.warWokou5: (Enemy.wokou, 5, 3, 0),
};

const leaderData = {
  Piece.leaderGaldan: (Enemy.mongol, 4, 4),
  Piece.leaderHsinbyushin: (Enemy.mian, 4, 2),
  Piece.leaderNguyen: (Enemy.viet, 3, 3),
  Piece.leaderYaqub: (Enemy.turkish, 4, 3),
  Piece.leaderZhengYi: (Enemy.pirate, 3, 5),
  Piece.leaderStatesmanCaoFutian: (Enemy.boxer, 3, 5),
  Piece.leaderStatesmanKoxinga: (Enemy.wokou, 3, 5),
  Piece.leaderStatesmanMao: (Enemy.communist, 2, 5),
  Piece.leaderStatesmanWangLun: (Enemy.whiteLotus, 2, 4),
  Piece.leaderStatesmanXiuquan: (Enemy.taiping, 2, 4),
};

const statesmanData = {
  Piece.statesmanDorgon: (Ability.veteran, 4, 4, 1, 4, true, false),
  Piece.statesmanWuSangui: (Ability.rebel, 4, 2, 3, 4, false, false),
  Piece.statesmanSharhuda: (Ability.warRussian, 3, 3, 2, 3, false, false),
  Piece.statesmanOboi: (Ability.exile, 3, 4, 1, 3, false, false),
  Piece.statesmanShiLang: (Ability.warPirate, 3, 2, 3, 4, false, false),
  Piece.statesmanKoxinga: (Ability.leaderWokou, 3, 2, 1, 5, false, false),
  Piece.statesmanSonggotu: (Ability.diplomat, 1, 4, 2, 3, false, false),
  Piece.statesmanShunzhi: (Ability.event, 2, 3, 3, 2, true, false),
  Piece.statesmanKangxi: (Ability.conquest, 3, 5, 2, 2, true, false),
  Piece.statesmanYongzheng: (Ability.prestige, 4, 4, 2, 2, true, false),
  Piece.statesmanGengyao: (Ability.stalemate, 3, 2, 2, 3, false, false),
  Piece.statesmanYunsi: (Ability.exile, 2, 4, 2, 3, true, false),
  Piece.statesmanOrtai: (Ability.warMiao, 3, 4, 2, 3, false, false),
  Piece.statesmanYinxiang: (Ability.prestige, 2, 4, 3, 3, false, false),
  Piece.statesmanZhongqi: (Ability.warTibetan, 3, 3, 3, 2, false, false),
  Piece.statesmanYunti: (Ability.warMongol, 3, 3, 2, 2, true, false),
  Piece.statesmanQianlong: (Ability.conquest, 2, 5, 2, 3, true, false),
  Piece.statesmanZhaohui: (Ability.warMongol, 4, 3, 2, 4, false, false),
  Piece.statesmanAgui: (Ability.warHui, 4, 4, 2, 2, false, false),
  Piece.statesmanFuheng: (Ability.stalemate, 3, 3, 2, 4, false, false),
  Piece.statesmanSunShiyi: (Ability.warWhiteLotus, 3, 3, 3, 3, false, false),
  Piece.statesmanYongxuan: (Ability.event, 1, 2, 2, 2, true, false),
  Piece.statesmanWangLun: (Ability.leaderWhiteLotus, 2, 1, 4, 4, false, false),
  Piece.statesmanYongqi: (Ability.prestige, 2, 4, 2, 2, true, false),
  Piece.statesmanHeshen: (Ability.assassin, 2, 1, 1, 4, false, false),
  Piece.statesmanFuKangan: (Ability.warTaiwan, 3, 4, 2, 2, false, false),
  Piece.statesmanYangFang: (Ability.warTurkish, 3, 2, 2, 2, false, false),
  Piece.statesmanJiaqing: (Ability.diplomat, 2, 4, 2, 4, true, false),
  Piece.statesmanDaoguang: (Ability.event, 1, 3, 1, 2, true, false),
  Piece.statesmanLinZexu: (Ability.diplomat, 2, 4, 3, 2, false, false),
  Piece.statesmanRinchen: (Ability.veteran, 3, 2, 2, 3, false, false),
  Piece.statesmanGuofan: (Ability.warTaiping, 4, 4, 3, 4, false, false),
  Piece.statesmanZuo: (Ability.warTurkish, 4, 3, 3, 3, false, false),
  Piece.statesmanXiuquan: (Ability.leaderTaiping, 2, 2, 5, 4, false, false),
  Piece.statesmanMianyu: (Ability.stalemate, 3, 2, 2, 1, true, false),
  Piece.statesmanHongzhang: (Ability.diplomat, 2, 5, 3, 2, false, false),
  Piece.statesmanXianfeng: (Ability.event, 1, 2, 1, 2, true, false),
  Piece.statesmanYixin: (Ability.exile, 2, 3, 3, 3, true, false),
  Piece.statesmanCixi: (Ability.assassin, 1, 2, 2, 4, false, false),
  Piece.statesmanLiuYongfu: (Ability.warFrench, 3, 1, 4, 3, false, false),
  Piece.statesmanTongzhi: (Ability.event, 1, 1, 1, 3, true, false),
  Piece.statesmanCaoFutian: (Ability.leaderBoxer, 3, 1, 1, 5, false, false),
  Piece.statesmanYinchang: (Ability.diplomat, 3, 4, 3, 2, false, false),
  Piece.statesmanShikai: (Ability.veteran, 3, 4, 3, 3, false, false),
  Piece.statesmanSunYixian: (Ability.prestige, 2, 4, 4, 3, false, true),
  Piece.statesmanGuangxu: (Ability.event, 1, 3, 3, 2, true, false),
  Piece.statesmanZuolin: (Ability.rebel, 3, 2, 2, 4, false, false),
  Piece.statesmanFeng: (Ability.rebel, 3, 3, 5, 2, false, false),
  Piece.statesmanZhuDe: (Ability.rebel, 4, 3, 5, 3, false, false),
  Piece.statesmanJiang: (Ability.stalemate, 3, 3, 4, 4, false, true),
  Piece.statesmanLiZongren: (Ability.warJapanese, 4, 3, 4, 3, false, true),
  Piece.statesmanMao: (Ability.leaderCommunist, 2, 2, 5, 5, false, false),
  Piece.statesmanShicai: (Ability.rebel, 3, 4, 4, 4, false, true),
  Piece.statesmanPuyi: (Ability.exile, 1, 1, 2, 3, true, false),
};

const commandData = {
  Location.commandEmperor: (2, 2, 2, 2),
  Location.commandPresident: (2, 2, 2, 2),
  Location.commandNorthChina: (2, 2, 1, 3),
  Location.commandSouthChina: (1, 2, 2, 3),
  Location.commandEastChina: (2, 2, 3, 1),
  Location.commandWestChina: (3, 1, 1, 3),
  Location.commandManchuria: (2, 3, 2, 1),
  Location.commandMongolia: (3, 2, 1, 2),
  Location.commandTibet: (1, 2, 3, 2),
  Location.commandXinjiang: (2, 3, 1, 2),
  Location.commandEast: (1, 3, 1, 3),
  Location.commandSouth: (3, 2, 2, 1),
};

class GameState {
  List<Location> _pieceLocations = List<Location>.filled(Piece.values.length, Location.offmap);
	List<bool> _commandLoyals = List<bool>.filled(LocationType.command.count, true);
	List<ProvinceStatus> _provinceStatuses = List<ProvinceStatus>.filled(LocationType.province.count, ProvinceStatus.chinese);
  List<int> _eventTypeCounts = List<int>.filled(EventType.values.length, 0);
	List<int?> _leaderAges = List<int?>.filled(PieceType.leaderLeader.count, null);
	List<int?> _statesmanAges = List<int?>.filled(PieceType.statesman.count, null);
	List<int?> _commanderAges = List<int?>.filled(LocationType.command.count, null);
  List<Piece> _resurrectedBarbarians = <Piece>[];
  int _turn = 0;
  int _cash = 0;
  int  _prestige = 0;
  int _unrest = 0;
  bool _gmd = false;

  GameState();

  GameState.fromJson(Map<String, dynamic> json)
    : _turn = json['turn'] as int
    , _cash = json['cash'] as int
    , _prestige = json['prestige'] as int
    , _unrest = json['unrest'] as int
    , _gmd = json['gmd'] as bool
    , _pieceLocations = locationListFromIndices(List<int>.from(json['pieceLocations']))
    , _commandLoyals = List<bool>.from(json['commandLoyals'])
    , _provinceStatuses = provinceStatusListFromIndices(List<int>.from(json['provinceStatuses']))
    , _eventTypeCounts = List<int>.from(json['eventTypeCounts'])
    , _leaderAges = List<int?>.from(json['leaderAges'])
    , _statesmanAges = List<int?>.from(json['statesmanAges'])
    , _commanderAges = List<int?>.from(json['commanderAges'])
    , _resurrectedBarbarians = pieceListFromIndices(List<int>.from(json['resurrectedBarbarians']))
    ;

  Map<String, dynamic> toJson() => {
    'turn': _turn,
    'cash': _cash,
    'prestige': _prestige,
    'unrest': _unrest,
    'gmd': _gmd,
    'pieceLocations': locationListToIndices(_pieceLocations),
    'commandLoyals': _commandLoyals,
    'provinceStatuses': provinceStatusListToIndices(_provinceStatuses),
    'eventTypeCounts': _eventTypeCounts,
    'leaderAges': _leaderAges,
    'statesmanAges': _statesmanAges,
    'commanderAges': _commanderAges,
    'resurrectedBarbarians': pieceListToIndices(_resurrectedBarbarians),
  };

  ProvinceStatus provinceStatus(Location province) {
    return _provinceStatuses[province.index - LocationType.province.firstIndex];
  }

  void setProvinceStatus(Location province, ProvinceStatus status) {
    _provinceStatuses[province.index - LocationType.province.firstIndex] = status;
  }

  Enemy entryAreaEnemy(Location entryArea) {
    for (final enemy in Enemy.values) {
      final entryAreas = enemyEntryAreas(enemy);
      if (entryAreas.contains(entryArea)) {
        return enemy;
      }
    }
    return Enemy.german;
  }

  bool spaceForeign(Location space) {
    if (space.isType(LocationType.entryArea)) {
      return true;
    }
    switch (provinceStatus(space)) {
    case ProvinceStatus.barbarian:
      return false;
    case ProvinceStatus.foreignAmerican:
    case ProvinceStatus.foreignBritish:
    case ProvinceStatus.foreignDutch:
    case ProvinceStatus.foreignFrench:
    case ProvinceStatus.foreignGerman:
    case ProvinceStatus.foreignJapanese:
    case ProvinceStatus.foreignPortuguese:
    case ProvinceStatus.foreignRussian:
    case ProvinceStatus.foreignSpanish:
      return true;
    case ProvinceStatus.vassal:
    case ProvinceStatus.insurgent:
    case ProvinceStatus.chinese:
      return false;
    }
  }

  bool spaceForeignOrBetter(Location space) {
    if (!space.isType(LocationType.province)) {
      return false;
    }
    switch (provinceStatus(space)) {
    case ProvinceStatus.barbarian:
      return false;
    case ProvinceStatus.foreignAmerican:
    case ProvinceStatus.foreignBritish:
    case ProvinceStatus.foreignDutch:
    case ProvinceStatus.foreignFrench:
    case ProvinceStatus.foreignGerman:
    case ProvinceStatus.foreignJapanese:
    case ProvinceStatus.foreignPortuguese:
    case ProvinceStatus.foreignRussian:
    case ProvinceStatus.foreignSpanish:
    case ProvinceStatus.vassal:
    case ProvinceStatus.insurgent:
    case ProvinceStatus.chinese:
      return true;
    }
  }

  bool spaceBarbarianOrNonMatchingEntryArea(Location space, Enemy? foreignEnemy) {
    Enemy? spaceEnemy;
    if (space.isType(LocationType.entryArea)) {
      spaceEnemy = entryAreaEnemy(space);
      return foreignEnemy == null || spaceEnemy != foreignEnemy;
    }
    final status = provinceStatus(space);
    switch (status) {
    case ProvinceStatus.barbarian:
      return true;
    case ProvinceStatus.foreignAmerican:
    case ProvinceStatus.foreignBritish:
    case ProvinceStatus.foreignDutch:
    case ProvinceStatus.foreignFrench:
    case ProvinceStatus.foreignGerman:
    case ProvinceStatus.foreignJapanese:
    case ProvinceStatus.foreignPortuguese:
    case ProvinceStatus.foreignRussian:
    case ProvinceStatus.foreignSpanish:
    case ProvinceStatus.vassal:
    case ProvinceStatus.insurgent:
    case ProvinceStatus.chinese:
      return false;
    }
  }

  bool spaceNonMatchingForeignOrBetter(Location space, Piece war) {
    if (!space.isType(LocationType.province)) {
      return false;
    }
    final enemy = warEnemy(war);
    switch (provinceStatus(space)) {
    case ProvinceStatus.barbarian:
      return false;
    case ProvinceStatus.foreignAmerican:
      return enemy != Enemy.american;
    case ProvinceStatus.foreignBritish:
      return enemy != Enemy.british;
    case ProvinceStatus.foreignDutch:
      return enemy != Enemy.dutch;
    case ProvinceStatus.foreignFrench:
      return enemy != Enemy.french;
    case ProvinceStatus.foreignGerman:
      return enemy != Enemy.german;
    case ProvinceStatus.foreignJapanese:
      return enemy != Enemy.japanese;
    case ProvinceStatus.foreignPortuguese:
      return enemy != Enemy.portuguese;
    case ProvinceStatus.foreignRussian:
      return enemy != Enemy.russian;
    case ProvinceStatus.foreignSpanish:
      return enemy != Enemy.spanish;
    case ProvinceStatus.vassal:
    case ProvinceStatus.insurgent:
    case ProvinceStatus.chinese:
      return true;
    }
  }

  bool spaceVassalOrBetter(Location space) {
    if (!space.isType(LocationType.province)) {
      return false;
    }
    switch (provinceStatus(space)) {
    case ProvinceStatus.barbarian:
    case ProvinceStatus.foreignAmerican:
    case ProvinceStatus.foreignBritish:
    case ProvinceStatus.foreignDutch:
    case ProvinceStatus.foreignFrench:
    case ProvinceStatus.foreignGerman:
    case ProvinceStatus.foreignJapanese:
    case ProvinceStatus.foreignPortuguese:
    case ProvinceStatus.foreignRussian:
    case ProvinceStatus.foreignSpanish:
      return false;
    case ProvinceStatus.vassal:
    case ProvinceStatus.insurgent:
    case ProvinceStatus.chinese:
      return true;
    }
  }

  bool spaceInsurgentOrBetter(Location space) {
    if (!space.isType(LocationType.province)) {
      return false;
    }
    switch (provinceStatus(space)) {
    case ProvinceStatus.barbarian:
    case ProvinceStatus.foreignAmerican:
    case ProvinceStatus.foreignBritish:
    case ProvinceStatus.foreignDutch:
    case ProvinceStatus.foreignFrench:
    case ProvinceStatus.foreignGerman:
    case ProvinceStatus.foreignJapanese:
    case ProvinceStatus.foreignPortuguese:
    case ProvinceStatus.foreignRussian:
    case ProvinceStatus.foreignSpanish:
    case ProvinceStatus.vassal:
      return false;
    case ProvinceStatus.insurgent:
    case ProvinceStatus.chinese:
      return true;
    }
  }

  bool spaceCanBeAnnexed(Location space) {
    if (!space.isType(LocationType.province)) {
      return false;
    }
    final status = provinceStatus(space);
    if (status == ProvinceStatus.insurgent || status == ProvinceStatus.chinese) {
      return false;
    }
    if (piecesInLocationCount(PieceType.war, space) > 0) {
      return false;
    }
    if (spaceHasConnectionToVassalOrBetterProvince(space)) {
      return true;
    }
    return false;
  }

  int provinceRevenue(Location province) {
    const provinceRevenues = {
      Location.provinceBeijing: 5,
      Location.provinceHenan: 5,
      Location.provincePortEdward: 3,
      Location.provinceQingdao: 3,
      Location.provinceShandong: 5,
      Location.provinceShanxi: 4,
      Location.provinceTianjin: 5,
      Location.provinceZhili: 5,
      Location.provinceFujian: 5,
      Location.provinceGuangdong: 5,
      Location.provinceGuangxi: 5,
      Location.provinceGuangzhouwan: 3,
      Location.provinceHainan: 3,
      Location.provinceHongKong: 3,
      Location.provinceMacau: 3,
      Location.provinceYunnan: 3,
      Location.provinceAnhui: 5,
      Location.provinceJiangsu: 5,
      Location.provinceJiangxi: 5,
      Location.provinceNanjing: 5,
      Location.provinceShanghai: 5,
      Location.provinceZhejiang: 5,
      Location.provinceChongqing: 4,
      Location.provinceGansu: 2,
      Location.provinceGuizhou: 3,
      Location.provinceHubei: 4,
      Location.provinceHunan: 4,
      Location.provinceLanzhou: 2,
      Location.provinceShaanxi: 3,
      Location.provinceSichuan: 3,
      Location.provinceAihui: 2,
      Location.provinceAmuer: 1,
      Location.provinceHeilongjiang: 3,
      Location.provinceHinggan: 2,
      Location.provinceJilin: 3,
      Location.provinceKuyedao: 1,
      Location.provinceLiaoning: 4,
      Location.provincePortArthur: 3,
      Location.provinceRehe: 2,
      Location.provinceVladivostok: 3,
      Location.provinceWusuli: 1,
      Location.provinceChahar: 1,
      Location.provinceChechen: 1,
      Location.provinceDahuer: 1,
      Location.provinceKebuduo: 1,
      Location.provinceNingxia: 2,
      Location.provinceSaiyin: 1,
      Location.provinceSuiyuan: 1,
      Location.provinceTangnu: 1,
      Location.provinceTuchetu: 2,
      Location.provinceTuwalu: 1,
      Location.provinceWala: 1,
      Location.provinceZasaketu: 1,
      Location.provinceAlidi: 1,
      Location.provinceAsamu: 2,
      Location.provinceBudan: 1,
      Location.provinceDongzang: 2,
      Location.provinceKeshimier: 2,
      Location.provinceLadake: 1,
      Location.provinceNiboer: 1,
      Location.provinceQangtang: 1,
      Location.provinceXijin: 1,
      Location.provinceXizang: 2,
      Location.provinceZangnan: 1,
      Location.provinceAfuhan: 1,
      Location.provinceBadasha: 1,
      Location.provinceBuhala: 2,
      Location.provinceDihua: 2,
      Location.provinceHasake: 1,
      Location.provinceHuijiang: 1,
      Location.provinceHuokande: 2,
      Location.provinceMeierfu: 2,
      Location.provinceQinghai: 1,
      Location.provinceTashigan: 2,
      Location.provinceXiwa: 1,
      Location.provinceYili: 2,
      Location.provinceZhunbu: 2,
      Location.provinceBusan: 3,
      Location.provinceChaoxian: 2,
      Location.provinceLuSong: 2,
      Location.provinceManila: 3,
      Location.provinceNagasaki: 3,
      Location.provinceRiben: 3,
      Location.provinceRyukyu: 1,
      Location.provinceSulu: 1,
      Location.provinceTainan: 3,
      Location.provinceTaiwan: 4,
      Location.provinceAnnan: 2,
      Location.provinceBangkok: 3,
      Location.provinceDongJing: 3,
      Location.provinceGaoMian: 1,
      Location.provinceLaoWo: 1,
      Location.provinceMalaya: 1,
      Location.provinceMianDian: 3,
      Location.provinceRangoon: 3,
      Location.provinceSaigon: 3,
      Location.provinceShanBang: 1,
      Location.provinceXianLuo: 3,
    };
    return provinceRevenues[province]!;
  }

  bool provinceHasGreatWall(Location province) {
    const greatWallProvinces = [
      Location.provinceBeijing,
      Location.provinceShanxi,
      Location.provinceZhili,
      Location.provinceLanzhou,
      Location.provinceShaanxi,
    ];
    return greatWallProvinces.contains(province);
  }

  bool provinceIsPort(Location province) {
    const ports = [
      Location.provincePortEdward,
      Location.provinceQingdao,
      Location.provinceTianjin,
      Location.provinceGuangzhouwan,
      Location.provinceHongKong,
      Location.provinceMacau,
      Location.provinceNanjing,
      Location.provinceShanghai,
      Location.provincePortArthur,
      Location.provinceVladivostok,
      Location.provinceBusan,
      Location.provinceManila,
      Location.provinceNagasaki,
      Location.provinceTainan,
      Location.provinceBangkok,
      Location.provinceRangoon,
      Location.provinceSaigon,
    ];
    return ports.contains(province);
  }

  bool provinceMayFlood(Location province) {
    const floodProvinces = [
      Location.provinceHenan,
      Location.provinceShandong,
      Location.provinceAnhui,
      Location.provinceJiangsu,
      Location.provinceJiangxi,
      Location.provinceNanjing,
      Location.provinceShanghai,
      Location.provinceZhejiang,
      Location.provinceHubei,
      Location.provinceHunan,
    ];
    return floodProvinces.contains(province);
  }

  bool provinceMountain(Location province) {
    const mountainProvinces = [
      Location.provinceYunnan,
      Location.provinceGansu,
      Location.provinceGuizhou,
      Location.provinceSichuan,
      Location.provinceChahar,
      Location.provinceChechen,
      Location.provinceKebuduo,
      Location.provinceNingxia,
      Location.provinceSaiyin,
      Location.provinceSuiyuan,
      Location.provinceTangnu,
      Location.provinceTuchetu,
      Location.provinceTuwalu,
      Location.provinceWala,
      Location.provinceZasaketu,
      Location.provinceAlidi,
      Location.provinceBudan,
      Location.provinceDongzang,
      Location.provinceKeshimier,
      Location.provinceLadake,
      Location.provinceNiboer,
      Location.provinceQangtang,
      Location.provinceXijin,
      Location.provinceXizang,
      Location.provinceZangnan,
      Location.provinceAfuhan,
      Location.provinceBadasha,
      Location.provinceBuhala,
      Location.provinceDihua,
      Location.provinceHasake,
      Location.provinceHuijiang,
      Location.provinceHuokande,
      Location.provinceMeierfu,
      Location.provinceQinghai,
      Location.provinceTashigan,
      Location.provinceYili,
      Location.provinceZhunbu,
      Location.provinceLaoWo,
    ];
    return mountainProvinces.contains(province);
  }

  List<(Location, ConnectionType)> spaceConnections(Location space) {
    const connections = {
      Location.provinceBeijing: [
        (Location.provinceShanxi,ConnectionType.land),
        (Location.provinceTianjin,ConnectionType.land),
        (Location.provinceZhili,ConnectionType.land),
        (Location.provinceChahar,ConnectionType.land)],
      Location.provinceHenan: [
        (Location.provinceShandong,ConnectionType.river),
        (Location.provinceShanxi,ConnectionType.river),
        (Location.provinceTianjin,ConnectionType.river),
        (Location.provinceAnhui,ConnectionType.land),
        (Location.provinceHubei,ConnectionType.land),
        (Location.provinceShaanxi,ConnectionType.land)],
      Location.provincePortEdward: [
        (Location.provinceQingdao,ConnectionType.sea),
        (Location.provinceTianjin,ConnectionType.sea),
        (Location.provincePortArthur,ConnectionType.sea),
        (Location.provinceBusan,ConnectionType.sea)],
      Location.provinceQingdao: [
        (Location.provincePortEdward,ConnectionType.sea),
        (Location.provinceShandong,ConnectionType.land),
        (Location.entryAreaGerman,ConnectionType.sea)],
      Location.provinceShandong: [
        (Location.provinceHenan,ConnectionType.river),
        (Location.provinceQingdao,ConnectionType.land),
        (Location.provinceTianjin,ConnectionType.river),
        (Location.provinceAnhui,ConnectionType.river),
        (Location.provinceJiangsu,ConnectionType.river)],
      Location.provinceShanxi: [
        (Location.provinceBeijing,ConnectionType.land),
        (Location.provinceHenan,ConnectionType.river),
        (Location.provinceTianjin,ConnectionType.land),
        (Location.provinceShaanxi,ConnectionType.river),
        (Location.provinceChahar,ConnectionType.land),
        (Location.provinceSuiyuan,ConnectionType.land)],
      Location.provinceTianjin: [
        (Location.provinceBeijing,ConnectionType.land),
        (Location.provinceHenan,ConnectionType.river),
        (Location.provinceShandong,ConnectionType.river),
        (Location.provinceShanxi,ConnectionType.land),
        (Location.provincePortEdward,ConnectionType.sea)],
      Location.provinceZhili: [
        (Location.provinceBeijing,ConnectionType.land),
        (Location.provinceLiaoning,ConnectionType.land),
        (Location.provincePortArthur,ConnectionType.sea),
        (Location.provinceRehe,ConnectionType.land)],
      Location.provinceFujian: [
        (Location.provinceGuangdong,ConnectionType.land),
        (Location.provinceJiangxi,ConnectionType.land),
        (Location.provinceZhejiang,ConnectionType.land),
        (Location.provinceTainan,ConnectionType.sea),
        (Location.provinceTaiwan,ConnectionType.sea)],
      Location.provinceGuangdong: [
        (Location.provinceFujian,ConnectionType.land),
        (Location.provinceGuangxi,ConnectionType.river),
        (Location.provinceHongKong,ConnectionType.river),
        (Location.provinceMacau,ConnectionType.river),
        (Location.provinceJiangxi,ConnectionType.land),
        (Location.provinceHunan,ConnectionType.land)],
      Location.provinceGuangxi: [
        (Location.provinceGuangdong,ConnectionType.river),
        (Location.provinceGuangzhouwan,ConnectionType.land),
        (Location.provinceYunnan,ConnectionType.land),
        (Location.provinceGuizhou,ConnectionType.land),
        (Location.provinceHunan,ConnectionType.land),
        (Location.provinceDongJing,ConnectionType.land)],
      Location.provinceGuangzhouwan: [
        (Location.provinceGuangxi,ConnectionType.land),
        (Location.provinceHainan,ConnectionType.river),
        (Location.provinceMacau,ConnectionType.sea),
        (Location.provinceDongJing,ConnectionType.sea)],
      Location.provinceHainan: [
        (Location.provinceGuangzhouwan,ConnectionType.river),
        (Location.provinceAnnan,ConnectionType.sea),
        (Location.provinceDongJing,ConnectionType.sea)],
      Location.provinceHongKong: [
        (Location.provinceGuangdong,ConnectionType.river),
        (Location.provinceMacau,ConnectionType.sea),
        (Location.provinceTainan,ConnectionType.sea),
        (Location.entryAreaBritishFleet1,ConnectionType.sea)],
      Location.provinceMacau: [
        (Location.provinceGuangdong,ConnectionType.river),
        (Location.provinceGuangzhouwan,ConnectionType.sea),
        (Location.provinceHongKong,ConnectionType.sea),
        (Location.entryAreaPortuguese,ConnectionType.sea)],
      Location.provinceYunnan: [
        (Location.provinceGuangxi,ConnectionType.land),
        (Location.provinceGuizhou,ConnectionType.land),
        (Location.provinceSichuan,ConnectionType.land),
        (Location.provinceZangnan,ConnectionType.land),
        (Location.provinceDongJing,ConnectionType.land),
        (Location.provinceShanBang,ConnectionType.land)],
      Location.provinceAnhui: [
        (Location.provinceHenan,ConnectionType.land),
        (Location.provinceShandong,ConnectionType.river),
        (Location.provinceJiangsu,ConnectionType.land),
        (Location.provinceJiangxi,ConnectionType.river),
        (Location.provinceNanjing,ConnectionType.river),
        (Location.provinceHubei,ConnectionType.land)],
      Location.provinceJiangsu: [
        (Location.provinceShandong,ConnectionType.river),
        (Location.provinceAnhui,ConnectionType.land),
        (Location.provinceNanjing,ConnectionType.river),
        (Location.provinceShanghai,ConnectionType.river)],
      Location.provinceJiangxi: [
        (Location.provinceAnhui,ConnectionType.river),
        (Location.provinceNanjing,ConnectionType.land),
        (Location.provinceFujian,ConnectionType.land),
        (Location.provinceGuangdong,ConnectionType.land),
        (Location.provinceHubei,ConnectionType.river),
        (Location.provinceHunan,ConnectionType.land)],
      Location.provinceNanjing: [
        (Location.provinceAnhui,ConnectionType.river),
        (Location.provinceJiangsu,ConnectionType.river),
        (Location.provinceJiangxi,ConnectionType.land),
        (Location.provinceShanghai,ConnectionType.river),
        (Location.provinceZhejiang,ConnectionType.land)],
      Location.provinceShanghai: [
        (Location.provinceJiangsu,ConnectionType.river),
        (Location.provinceNanjing,ConnectionType.river),
        (Location.provinceZhejiang,ConnectionType.sea),
        (Location.provinceNagasaki,ConnectionType.sea),
        (Location.provinceRyukyu,ConnectionType.sea)],
      Location.provinceZhejiang: [
        (Location.provinceFujian,ConnectionType.land),
        (Location.provinceNanjing,ConnectionType.land),
        (Location.provinceShanghai,ConnectionType.sea),
        (Location.provinceTaiwan,ConnectionType.sea)],
      Location.provinceChongqing: [
        (Location.provinceGuizhou,ConnectionType.land),
        (Location.provinceHubei,ConnectionType.river),
        (Location.provinceHunan,ConnectionType.land),
        (Location.provinceShaanxi,ConnectionType.land),
        (Location.provinceSichuan,ConnectionType.land)],
      Location.provinceGansu: [
        (Location.provinceLanzhou,ConnectionType.land),
        (Location.provinceNingxia,ConnectionType.land),
        (Location.provinceZasaketu,ConnectionType.land),
        (Location.provinceDihua,ConnectionType.land),
        (Location.provinceQinghai,ConnectionType.land)],
      Location.provinceGuizhou: [
        (Location.provinceGuangxi,ConnectionType.land),
        (Location.provinceYunnan,ConnectionType.land),
        (Location.provinceChongqing,ConnectionType.land),
        (Location.provinceHunan,ConnectionType.land),
        (Location.provinceSichuan,ConnectionType.land)],
      Location.provinceHubei: [
        (Location.provinceHenan,ConnectionType.land),
        (Location.provinceAnhui,ConnectionType.land),
        (Location.provinceJiangxi,ConnectionType.river),
        (Location.provinceChongqing,ConnectionType.river),
        (Location.provinceHunan,ConnectionType.river),
        (Location.provinceShaanxi,ConnectionType.land)],
      Location.provinceHunan: [
        (Location.provinceGuangdong,ConnectionType.land),
        (Location.provinceGuangxi,ConnectionType.land),
        (Location.provinceJiangxi,ConnectionType.land),
        (Location.provinceChongqing,ConnectionType.land),
        (Location.provinceGuizhou,ConnectionType.land),
        (Location.provinceHubei,ConnectionType.river)],
      Location.provinceLanzhou: [
        (Location.provinceGansu,ConnectionType.land),
        (Location.provinceShaanxi,ConnectionType.land),
        (Location.provinceSichuan,ConnectionType.land),
        (Location.provinceNingxia,ConnectionType.land),
        (Location.provinceSuiyuan,ConnectionType.land),
        (Location.provinceDongzang,ConnectionType.land),
        (Location.provinceQinghai,ConnectionType.land)],
      Location.provinceShaanxi: [
        (Location.provinceHenan,ConnectionType.land),
        (Location.provinceShanxi,ConnectionType.river),
        (Location.provinceChongqing,ConnectionType.land),
        (Location.provinceHubei,ConnectionType.land),
        (Location.provinceLanzhou,ConnectionType.land),
        (Location.provinceSuiyuan,ConnectionType.land)],
      Location.provinceSichuan: [
        (Location.provinceYunnan,ConnectionType.land),
        (Location.provinceChongqing,ConnectionType.land),
        (Location.provinceGuizhou,ConnectionType.land),
        (Location.provinceLanzhou,ConnectionType.land),
        (Location.provinceDongzang,ConnectionType.land),
        (Location.provinceZangnan,ConnectionType.land)],
      Location.provinceAihui: [
        (Location.provinceAmuer,ConnectionType.river),
        (Location.provinceHeilongjiang,ConnectionType.land),
        (Location.provinceHinggan,ConnectionType.land),
        (Location.provinceDahuer,ConnectionType.river)],
      Location.provinceAmuer: [
        (Location.provinceAihui,ConnectionType.river),
        (Location.provinceHeilongjiang,ConnectionType.river),
        (Location.provinceKuyedao,ConnectionType.sea),
        (Location.provinceWusuli,ConnectionType.river),
        (Location.entryAreaRussianFleet,ConnectionType.land)],
      Location.provinceHeilongjiang: [
        (Location.provinceAihui,ConnectionType.land),
        (Location.provinceAmuer,ConnectionType.river),
        (Location.provinceHinggan,ConnectionType.land),
        (Location.provinceJilin,ConnectionType.river)],
      Location.provinceHinggan: [
        (Location.provinceAihui,ConnectionType.land),
        (Location.provinceHeilongjiang,ConnectionType.land),
        (Location.provinceJilin,ConnectionType.land),
        (Location.provinceRehe,ConnectionType.land),
        (Location.provinceChechen,ConnectionType.land),
        (Location.provinceDahuer,ConnectionType.river)],
      Location.provinceJilin: [
        (Location.provinceHeilongjiang,ConnectionType.river),
        (Location.provinceHinggan,ConnectionType.land),
        (Location.provinceLiaoning,ConnectionType.river),
        (Location.provinceRehe,ConnectionType.land),
        (Location.provinceVladivostok,ConnectionType.land),
        (Location.provinceChaoxian,ConnectionType.land)],
      Location.provinceKuyedao: [
        (Location.provinceAmuer,ConnectionType.sea),
        (Location.provinceWusuli,ConnectionType.sea)],
      Location.provinceLiaoning: [
        (Location.provinceZhili,ConnectionType.land),
        (Location.provinceJilin,ConnectionType.river),
        (Location.provincePortArthur,ConnectionType.river),
        (Location.provinceRehe,ConnectionType.river),
        (Location.provinceChaoxian,ConnectionType.land)],
      Location.provincePortArthur: [
        (Location.provincePortEdward,ConnectionType.sea),
        (Location.provinceZhili,ConnectionType.sea),
        (Location.provinceLiaoning,ConnectionType.river),
        (Location.provinceChaoxian,ConnectionType.sea)],
      Location.provinceRehe: [
        (Location.provinceZhili,ConnectionType.land),
        (Location.provinceHinggan,ConnectionType.land),
        (Location.provinceJilin,ConnectionType.land),
        (Location.provinceLiaoning,ConnectionType.river),
        (Location.provinceChahar,ConnectionType.land)],
      Location.provinceVladivostok: [
        (Location.provinceJilin,ConnectionType.land),
        (Location.provinceWusuli,ConnectionType.land),
        (Location.provinceChaoxian,ConnectionType.sea)],
      Location.provinceWusuli: [
        (Location.provinceAmuer,ConnectionType.river),
        (Location.provinceKuyedao,ConnectionType.sea),
        (Location.provinceVladivostok,ConnectionType.land)],
      Location.provinceChahar: [
        (Location.provinceBeijing,ConnectionType.land),
        (Location.provinceShanxi,ConnectionType.land),
        (Location.provinceRehe,ConnectionType.land),
        (Location.provinceChechen,ConnectionType.land),
        (Location.provinceSuiyuan,ConnectionType.land),
        (Location.provinceTuchetu,ConnectionType.land)],
      Location.provinceChechen: [
        (Location.provinceHinggan,ConnectionType.land),
        (Location.provinceChahar,ConnectionType.land),
        (Location.provinceDahuer,ConnectionType.land),
        (Location.provinceTuchetu,ConnectionType.land)],
      Location.provinceDahuer: [
        (Location.provinceAihui,ConnectionType.river),
        (Location.provinceHinggan,ConnectionType.river),
        (Location.provinceChechen,ConnectionType.land),
        (Location.provinceTuchetu,ConnectionType.land),
        (Location.provinceTuwalu,ConnectionType.land),
        (Location.entryAreaRussianFleet,ConnectionType.land)],
      Location.provinceKebuduo: [
        (Location.provinceSaiyin,ConnectionType.land),
        (Location.provinceTangnu,ConnectionType.land),
        (Location.provinceWala,ConnectionType.land),
        (Location.provinceZasaketu,ConnectionType.land),
        (Location.provinceZhunbu,ConnectionType.land)],
      Location.provinceNingxia: [
        (Location.provinceGansu,ConnectionType.land),
        (Location.provinceLanzhou,ConnectionType.land),
        (Location.provinceSaiyin,ConnectionType.land),
        (Location.provinceSuiyuan,ConnectionType.land),
        (Location.provinceZasaketu,ConnectionType.land)],
      Location.provinceSaiyin: [
        (Location.provinceKebuduo,ConnectionType.land),
        (Location.provinceNingxia,ConnectionType.land),
        (Location.provinceTangnu,ConnectionType.land),
        (Location.provinceTuchetu,ConnectionType.land),
        (Location.provinceZasaketu,ConnectionType.land)],
      Location.provinceSuiyuan: [
        (Location.provinceShanxi,ConnectionType.land),
        (Location.provinceLanzhou,ConnectionType.land),
        (Location.provinceShaanxi,ConnectionType.land),
        (Location.provinceChahar,ConnectionType.land),
        (Location.provinceNingxia,ConnectionType.land),
        (Location.provinceTuchetu,ConnectionType.land)],
      Location.provinceTangnu: [
        (Location.provinceKebuduo,ConnectionType.land),
        (Location.provinceSaiyin,ConnectionType.land),
        (Location.provinceTuchetu,ConnectionType.land),
        (Location.provinceTuwalu,ConnectionType.land)],
      Location.provinceTuchetu: [
        (Location.provinceChahar,ConnectionType.land),
        (Location.provinceChechen,ConnectionType.land),
        (Location.provinceDahuer,ConnectionType.land),
        (Location.provinceSaiyin,ConnectionType.land),
        (Location.provinceSuiyuan,ConnectionType.land),
        (Location.provinceTangnu,ConnectionType.land)],
      Location.provinceTuwalu: [
        (Location.provinceDahuer,ConnectionType.land),
        (Location.provinceTangnu,ConnectionType.land),
        (Location.provinceWala,ConnectionType.land)],
      Location.provinceWala: [
        (Location.provinceKebuduo,ConnectionType.land),
        (Location.provinceTuwalu,ConnectionType.land),
        (Location.provinceHasake,ConnectionType.land),
        (Location.provinceZhunbu,ConnectionType.land)],
      Location.provinceZasaketu: [
        (Location.provinceGansu,ConnectionType.land),
        (Location.provinceKebuduo,ConnectionType.land),
        (Location.provinceNingxia,ConnectionType.land),
        (Location.provinceSaiyin,ConnectionType.land),
        (Location.provinceDihua,ConnectionType.land)],
      Location.provinceAlidi: [
        (Location.provinceLadake,ConnectionType.land),
        (Location.provinceNiboer,ConnectionType.land),
        (Location.provinceQangtang,ConnectionType.land),
        (Location.provinceXizang,ConnectionType.land)],
      Location.provinceAsamu: [
        (Location.provinceXijin,ConnectionType.land),
        (Location.provinceZangnan,ConnectionType.land),
        (Location.provinceShanBang,ConnectionType.land),
        (Location.entryAreaBritishFleet0,ConnectionType.sea)],
      Location.provinceBudan: [
        (Location.provinceXijin,ConnectionType.land),
        (Location.provinceZangnan,ConnectionType.land)],
      Location.provinceDongzang: [
        (Location.provinceLanzhou,ConnectionType.land),
        (Location.provinceSichuan,ConnectionType.land),
        (Location.provinceXizang,ConnectionType.land),
        (Location.provinceZangnan,ConnectionType.land),
        (Location.provinceQinghai,ConnectionType.land)],
      Location.provinceKeshimier: [
        (Location.provinceLadake,ConnectionType.land),
        (Location.provinceBadasha,ConnectionType.land),
        (Location.provinceHuokande,ConnectionType.land)],
      Location.provinceLadake: [
        (Location.provinceAlidi,ConnectionType.land),
        (Location.provinceKeshimier,ConnectionType.land),
        (Location.provinceNiboer,ConnectionType.land),
        (Location.provinceQangtang,ConnectionType.land),
        (Location.entryAreaBritishCavalry,ConnectionType.land)],
      Location.provinceNiboer: [
        (Location.provinceAlidi,ConnectionType.land),
        (Location.provinceLadake,ConnectionType.land),
        (Location.provinceXijin,ConnectionType.land),
        (Location.entryAreaBritishCavalry,ConnectionType.land)],
      Location.provinceQangtang: [
        (Location.provinceAlidi,ConnectionType.land),
        (Location.provinceLadake,ConnectionType.land),
        (Location.provinceXizang,ConnectionType.land),
        (Location.provinceHuijiang,ConnectionType.land),
        (Location.provinceQinghai,ConnectionType.land)],
      Location.provinceXijin: [
        (Location.provinceAsamu,ConnectionType.land),
        (Location.provinceBudan,ConnectionType.land),
        (Location.provinceNiboer,ConnectionType.land),
        (Location.provinceXizang,ConnectionType.land),
        (Location.entryAreaBritishCavalry,ConnectionType.land)],
      Location.provinceXizang: [
        (Location.provinceAlidi,ConnectionType.land),
        (Location.provinceDongzang,ConnectionType.land),
        (Location.provinceQangtang,ConnectionType.land),
        (Location.provinceXijin,ConnectionType.land),
        (Location.provinceQinghai,ConnectionType.land)],
      Location.provinceZangnan: [
        (Location.provinceYunnan,ConnectionType.land),
        (Location.provinceSichuan,ConnectionType.land),
        (Location.provinceAsamu,ConnectionType.land),
        (Location.provinceBudan,ConnectionType.land),
        (Location.provinceDongzang,ConnectionType.land)],
      Location.provinceAfuhan: [
        (Location.provinceBadasha,ConnectionType.land),
        (Location.provinceMeierfu,ConnectionType.land)],
      Location.provinceBadasha: [
        (Location.provinceKeshimier,ConnectionType.land),
        (Location.provinceAfuhan,ConnectionType.land),
        (Location.provinceBuhala,ConnectionType.land)],
      Location.provinceBuhala: [
        (Location.provinceBadasha,ConnectionType.land),
        (Location.provinceHuokande,ConnectionType.land),
        (Location.provinceMeierfu,ConnectionType.land),
        (Location.provinceTashigan,ConnectionType.land)],
      Location.provinceDihua: [
        (Location.provinceGansu,ConnectionType.land),
        (Location.provinceZasaketu,ConnectionType.land),
        (Location.provinceHuijiang,ConnectionType.land),
        (Location.provinceZhunbu,ConnectionType.land)],
      Location.provinceHasake: [
        (Location.provinceWala,ConnectionType.land),
        (Location.provinceYili,ConnectionType.land),
        (Location.entryAreaRussianCavalry,ConnectionType.land)],
      Location.provinceHuijiang: [
        (Location.provinceQangtang,ConnectionType.land),
        (Location.provinceDihua,ConnectionType.land),
        (Location.provinceHuokande,ConnectionType.land),
        (Location.provinceQinghai,ConnectionType.land),
        (Location.provinceZhunbu,ConnectionType.land)],
      Location.provinceHuokande: [
        (Location.provinceKeshimier,ConnectionType.land),
        (Location.provinceBuhala,ConnectionType.land),
        (Location.provinceHuijiang,ConnectionType.land),
        (Location.provinceYili,ConnectionType.land),
        (Location.provinceZhunbu,ConnectionType.land)],
      Location.provinceMeierfu: [
        (Location.provinceAfuhan,ConnectionType.land),
        (Location.provinceBuhala,ConnectionType.land),
        (Location.provinceXiwa,ConnectionType.land)],
      Location.provinceQinghai: [
        (Location.provinceGansu,ConnectionType.land),
        (Location.provinceLanzhou,ConnectionType.land),
        (Location.provinceDongzang,ConnectionType.land),
        (Location.provinceQangtang,ConnectionType.land),
        (Location.provinceXizang,ConnectionType.land),
        (Location.provinceHuijiang,ConnectionType.land)],
      Location.provinceTashigan: [
        (Location.provinceBuhala,ConnectionType.land),
        (Location.provinceXiwa,ConnectionType.land),
        (Location.provinceYili,ConnectionType.land),
        (Location.entryAreaRussianCavalry,ConnectionType.land)],
      Location.provinceXiwa: [
        (Location.provinceMeierfu,ConnectionType.land),
        (Location.provinceTashigan,ConnectionType.land),
        (Location.entryAreaRussianCavalry,ConnectionType.land)],
      Location.provinceYili: [
        (Location.provinceHasake,ConnectionType.land),
        (Location.provinceHuokande,ConnectionType.land),
        (Location.provinceTashigan,ConnectionType.land),
        (Location.provinceZhunbu,ConnectionType.land)],
      Location.provinceZhunbu: [
        (Location.provinceKebuduo,ConnectionType.land),
        (Location.provinceWala,ConnectionType.land),
        (Location.provinceDihua,ConnectionType.land),
        (Location.provinceHuijiang,ConnectionType.land),
        (Location.provinceHuokande,ConnectionType.land),
        (Location.provinceYili,ConnectionType.land)],
      Location.provinceBusan: [
        (Location.provincePortEdward,ConnectionType.sea),
        (Location.provinceChaoxian,ConnectionType.land),
        (Location.provinceNagasaki,ConnectionType.sea)],
      Location.provinceChaoxian: [
        (Location.provinceJilin,ConnectionType.land),
        (Location.provinceLiaoning,ConnectionType.land),
        (Location.provincePortArthur,ConnectionType.sea),
        (Location.provinceVladivostok,ConnectionType.sea),
        (Location.provinceBusan,ConnectionType.land)],
      Location.provinceLuSong: [
        (Location.provinceManila,ConnectionType.land),
        (Location.provinceTainan,ConnectionType.sea)],
      Location.provinceManila: [
        (Location.provinceLuSong,ConnectionType.land),
        (Location.provinceSulu,ConnectionType.river),
        (Location.entryAreaAmerican,ConnectionType.sea),
        (Location.entryAreaSpanish,ConnectionType.river)],
      Location.provinceNagasaki: [
        (Location.provinceShanghai,ConnectionType.sea),
        (Location.provinceBusan,ConnectionType.sea),
        (Location.provinceRiben,ConnectionType.river),
        (Location.provinceRyukyu,ConnectionType.sea),
        (Location.entryAreaDutch,ConnectionType.sea)],
      Location.provinceRiben: [
        (Location.provinceNagasaki,ConnectionType.river),
        (Location.entryAreaJapanese,ConnectionType.river)],
      Location.provinceRyukyu: [
        (Location.provinceShanghai,ConnectionType.sea),
        (Location.provinceNagasaki,ConnectionType.sea),
        (Location.provinceTaiwan,ConnectionType.sea)],
      Location.provinceSulu: [
        (Location.provinceManila,ConnectionType.river),
        (Location.provinceAnnan,ConnectionType.sea)],
      Location.provinceTainan: [
        (Location.provinceFujian,ConnectionType.sea),
        (Location.provinceHongKong,ConnectionType.sea),
        (Location.provinceLuSong,ConnectionType.sea),
        (Location.provinceTaiwan,ConnectionType.land)],
      Location.provinceTaiwan: [
        (Location.provinceZhejiang,ConnectionType.sea),
        (Location.provinceFujian,ConnectionType.sea),
        (Location.provinceRyukyu,ConnectionType.sea),
        (Location.provinceTainan,ConnectionType.land)],
      Location.provinceAnnan: [
        (Location.provinceHainan,ConnectionType.sea),
        (Location.provinceSulu,ConnectionType.sea),
        (Location.provinceDongJing,ConnectionType.land),
        (Location.provinceGaoMian,ConnectionType.land),
        (Location.provinceSaigon,ConnectionType.land)],
      Location.provinceBangkok: [
        (Location.provinceGaoMian,ConnectionType.land),
        (Location.provinceMalaya,ConnectionType.land),
        (Location.provinceRangoon,ConnectionType.land),
        (Location.provinceXianLuo,ConnectionType.land)],
      Location.provinceDongJing: [
        (Location.provinceGuangxi,ConnectionType.land),
        (Location.provinceGuangzhouwan,ConnectionType.sea),
        (Location.provinceHainan,ConnectionType.sea),
        (Location.provinceYunnan,ConnectionType.land),
        (Location.provinceAnnan,ConnectionType.land),
        (Location.provinceLaoWo,ConnectionType.land)],
      Location.provinceGaoMian: [
        (Location.provinceAnnan,ConnectionType.land),
        (Location.provinceBangkok,ConnectionType.land),
        (Location.provinceLaoWo,ConnectionType.land),
        (Location.provinceSaigon,ConnectionType.land),
        (Location.provinceXianLuo,ConnectionType.land)],
      Location.provinceLaoWo: [
        (Location.provinceDongJing,ConnectionType.land),
        (Location.provinceGaoMian,ConnectionType.land),
        (Location.provinceMianDian,ConnectionType.land),
        (Location.provinceXianLuo,ConnectionType.land)],
      Location.provinceMalaya: [
        (Location.provinceBangkok,ConnectionType.land)],
      Location.provinceMianDian: [
        (Location.provinceLaoWo,ConnectionType.land),
        (Location.provinceRangoon,ConnectionType.river),
        (Location.provinceShanBang,ConnectionType.river),
        (Location.provinceXianLuo,ConnectionType.land)],
      Location.provinceRangoon: [
        (Location.provinceBangkok,ConnectionType.land),
        (Location.provinceMianDian,ConnectionType.river),
        (Location.entryAreaBritishFleet0,ConnectionType.sea)],
      Location.provinceSaigon: [
        (Location.provinceAnnan,ConnectionType.land),
        (Location.provinceGaoMian,ConnectionType.land),
        (Location.entryAreaFrench,ConnectionType.sea)],
      Location.provinceShanBang: [
        (Location.provinceYunnan,ConnectionType.land),
        (Location.provinceAsamu,ConnectionType.land),
        (Location.provinceMianDian,ConnectionType.river)],
      Location.provinceXianLuo: [
        (Location.provinceBangkok,ConnectionType.land),
        (Location.provinceGaoMian,ConnectionType.land),
        (Location.provinceLaoWo,ConnectionType.land),
        (Location.provinceMianDian,ConnectionType.land)],
      Location.entryAreaAmerican: [
        (Location.provinceManila,ConnectionType.sea)],
      Location.entryAreaBritishCavalry: [
        (Location.provinceLadake,ConnectionType.land),
        (Location.provinceNiboer,ConnectionType.land),
        (Location.provinceXijin,ConnectionType.land)],
      Location.entryAreaBritishFleet0: [
        (Location.provinceAsamu,ConnectionType.sea),
        (Location.provinceRangoon,ConnectionType.sea)],
      Location.entryAreaBritishFleet1: [
        (Location.provinceHongKong,ConnectionType.sea)],
      Location.entryAreaDutch: [
        (Location.provinceNagasaki,ConnectionType.sea)],
      Location.entryAreaFrench: [
        (Location.provinceSaigon,ConnectionType.sea)],
      Location.entryAreaGerman: [
        (Location.provinceQingdao,ConnectionType.sea)],
      Location.entryAreaJapanese: [
        (Location.provinceRiben,ConnectionType.river)],
      Location.entryAreaPortuguese: [
        (Location.provinceMacau,ConnectionType.sea)],
      Location.entryAreaRussianCavalry: [
        (Location.provinceHasake,ConnectionType.land),
        (Location.provinceTashigan,ConnectionType.land),
        (Location.provinceXiwa,ConnectionType.land)],
      Location.entryAreaRussianFleet: [
        (Location.provinceAmuer,ConnectionType.land),
        (Location.provinceDahuer,ConnectionType.land)],
      Location.entryAreaSpanish: [
        (Location.provinceManila,ConnectionType.river)],
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

  List<Location> spaceAndConnectedSpaces(Location space) {
    final spaces = spaceConnectedSpaces(space);
    spaces.add(space);
    return spaces;
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

  bool spaceHasConnectionToVassalOrBetterProvince(Location space) {
    for (final province in LocationType.province.locations) {
      if (spacesConnectionType(space, province) != null && spaceVassalOrBetter(province)) {
        return true;
      }
    }
    return false;
  }

  ConnectionType connectionTypeForWar(ConnectionType rawConnectionType, Piece war) {
    int navalStrength = warRawNavalStrength(war);
    switch (rawConnectionType) {
    case ConnectionType.land:
      return rawConnectionType;
    case ConnectionType.river:
      if (navalStrength >= 2) {
        return ConnectionType.land;
      }
      return rawConnectionType;
    case ConnectionType.sea:
      if (navalStrength >= 3) {
        return ConnectionType.land;
      }
      if (navalStrength >= 2) {
        return ConnectionType.river;
      }
      return rawConnectionType;
    }
  }

  int spaceNonMatchingForeignOrBetterDistance(Location space, Piece war) {
    if (spaceNonMatchingForeignOrBetter(space, war)) {
      return 0;
    }
    bool includeSeaConnections = warRawNavalStrength(war) >= 2;
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
              if (spaceNonMatchingForeignOrBetter(toSpace, war)) {
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
          PieceType.bannerVeteran,
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

  int provinceBannerPieceCount(Location province) {
    int count = piecesInLocationCount(PieceType.banner, province);
    return count;
  }

  List<Piece> provinceOverstackedUnits(Location province) {
    int guardLimit = 1;
    int cavalryLimit = 1;
    int bannerLimit = 2;
    int militiaLimit = 2;
    int fortLimit = 1;
    int fleetLimit = 1;

    if (province == Location.provinceBeijing) {
      guardLimit = 2;
    }

    if (provinceMountain(province)) {
      fleetLimit = 0;
    }

    if (!spaceInsurgentOrBetter(province)) {
      guardLimit = 0;
      cavalryLimit = 0;
      bannerLimit = 0;
      militiaLimit = 0;
      fortLimit = 0;
      fleetLimit = 0;
    }

    var units = <Piece>[];

    final guards = piecesInLocation(PieceType.guard, province);
    if (guards.length > guardLimit) {
      units += guards;
    }
    final cavalry = piecesInLocation(PieceType.cavalry, province);
    if (cavalry.length > cavalryLimit) {
      units += cavalry;
    }
    final banners = piecesInLocation(PieceType.banner, province);
    if (banners.length > bannerLimit) {
      units += banners;
    }
    final militias = piecesInLocation(PieceType.militia, province);
    if (militias.length > militiaLimit) {
      units += militias;
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
      [PieceType.fort, PieceType.militia],
      [PieceType.bannerOrdinary, PieceType.bannerVeteran],
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
      PieceType.bannerVeteran,
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
      PieceType.guardVeteran,
      PieceType.cavalryVeteran,
      PieceType.bannerVeteran,
      PieceType.fleetVeteran,
    ];
    for (final pieceType in demotableUnitTypes) {
      if (unit.isType(pieceType)) {
        return true;
      }
    }
    return false;
  }

  bool unitPromotable(Piece unit) {
    const promotableUnitTypes = [
      PieceType.bannerOrdinary,
      PieceType.guardOrdinary,
      PieceType.cavalryOrdinary,
      PieceType.fleetOrdinary,
    ];
    for (final pieceType in promotableUnitTypes) {
      if (unit.isType(pieceType)) {
        if (pieceType == PieceType.fort) {
          final province = pieceLocation(unit);
          if (piecesInLocationCount(PieceType.banner, province) >= 2) {
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
    return piecesInLocationCount(PieceType.guardOrdinary, Location.provinceBeijing) + 2 * piecesInLocationCount(PieceType.guardVeteran, Location.provinceBeijing);
  }

  int assassinationVeteranGuardsOutsideCapitalCount(Location target) {
    if (target.isType(LocationType.ruler)) {
      return 0;
    }
    final capital = Location.provinceBeijing;
    int count = 0;
    for (final guard in PieceType.guardVeteran.pieces) {
      final location = pieceLocation(guard);
      if (location != capital && location.isType(LocationType.province)) {
        if (target.isType(LocationType.ruler)) {
          count += 1;
        }
      }
    }
    return count;
  }

  int assassinationVeteranCavalryCount(Location target) {
    if (!target.isType(LocationType.governorship)) {
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
      } else {
        count += 1;
      }
    }
    return count;
  }

  int rebellionVeteransControlledByCommandCount(Location command) {
    const unitTypes = [
      PieceType.bannerVeteran,
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

  int rebellionUnitsControlledByCommandCount(Location command) {
    const unitTypes = [
      PieceType.banner,
      PieceType.cavalry,
      PieceType.bannerVeteran,
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
    if (unit.isType(PieceType.guardOrdinary)) {
      return 30;
    }
    if (unit.isType(PieceType.cavalryOrdinary)) {
      return 25;
    }
    if (unit.isType(PieceType.fleetOrdinary)) {
      return 20;
    }
    if (unit.isType(PieceType.bannerOrdinary)) {
      return 15;
    }
    if (unit.isType(PieceType.fort)) {
      return 10;
    }
    if (unit.isType(PieceType.militia)) {
      return 5;
    }
    return 0;
  }

  int unitPromoteCost(Piece unit) {
    if (unit.isType(PieceType.militia)) {
      return 5;
    }
    return 0;
  }

  int unitPayCost(Piece unit) {
    if (unit.isType(PieceType.guard)) {
      return 6;
    }
    if (unit.isType(PieceType.cavalry)) {
      return 5;
    }
    if (unit.isType(PieceType.fleet)) {
      return 4;
    }
    if (unit.isType(PieceType.banner)) {
      return 3;
    }
    if (unit.isType(PieceType.fort)) {
      return 2;
    }
    if (unit.isType(PieceType.militia)) {
      return 1;
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
          if (provinceStatus(province) == ProvinceStatus.chinese) {
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
    if (cash >= unitBuildCost(unit)) {
      return true;
    }
    return false;
  }

  bool unitCanPromote(Piece unit) {
    int cost = unitPromoteCost(unit);
    if (cost == 0) {
      return false;
    }
    final location = pieceLocation(unit);
    if (!location.isType(LocationType.province)) {
      return false;
    }
    return cash >= cost;
  }

  bool unitCanDemote(Piece unit) {
    if (!unit.isType(PieceType.fort)) {
      return false;
    }
    final location = pieceLocation(unit);
    if (!location.isType(LocationType.province)) {
      return false;
    }
    return true;
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
    if (unit.isType(PieceType.banner)) {
      return piecesInLocationCount(PieceType.banner, province) < 2;
    }
    if (unit.isType(PieceType.militia)) {
      return piecesInLocationCount(PieceType.militia, province) < 2;
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
    if (cash < unitBuildCost(unit)) {
      return false;
    }
    return true;
  }

  int unitTransferCostToProvince(Piece unit, Location toProvince) {
    final fromProvince = pieceLocation(unit);
    final fromCommand = provinceCommand(fromProvince);
    final toCommand = provinceCommand(toProvince);
    if (toCommand == fromCommand) {
      return 0;
    }
    if (unit.isType(PieceType.cavalry)) {
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
    final toCommand = provinceCommand(toProvince);
    final fromOverallCommand = commandOverallCommand(fromCommand);
    final toOverallCommand = commandOverallCommand(toCommand);
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
    }
    if (checkCost) {
      final gold = commandRebel(fromOverallCommand) ? 0 : cash;
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

  int warRawNavalStrength(Piece war) {
    return warData[war]!.$3;
  }

  int warCurrentNavalStrength(Piece war) {
    int strength = warRawNavalStrength(war);
    final location = pieceLocation(war);
    if (location.isType(LocationType.province) && provinceMountain(location)) {
      strength = 0;
    }
    return strength;
  }

  int warCavalryStrength(Piece war) {
    return warData[war]!.$4;
  }

  List<Location> enemyEntryAreas(Enemy enemy) {
    const entryAreas = {
      Enemy.american: [Location.entryAreaAmerican],
      Enemy.british: [Location.entryAreaBritishCavalry, Location.entryAreaBritishFleet0, Location.entryAreaBritishFleet1],
      Enemy.dutch: [Location.entryAreaDutch],
      Enemy.french: [Location.entryAreaFrench],
      Enemy.german: [Location.entryAreaGerman],
      Enemy.japanese: [Location.entryAreaJapanese],
      Enemy.portuguese: [Location.entryAreaPortuguese],
      Enemy.russian: [Location.entryAreaRussianCavalry, Location.entryAreaRussianFleet],
      Enemy.spanish: [Location.entryAreaSpanish],
      Enemy.boxer: [Location.provinceShandong],
      Enemy.communist: [Location.provinceFujian],
      Enemy.gurkha: [Location.provinceNiboer],
      Enemy.pirate: [Location.provinceHainan],
      Enemy.redTurban: [Location.provinceGuangdong],
      Enemy.hui: [Location.provinceLanzhou],
      Enemy.jinchuan: [Location.provinceSichuan],
      Enemy.mian: [Location.provinceMianDian],
      Enemy.miao: [Location.provinceGuizhou],
      Enemy.mongol: [Location.provinceKebuduo],
      Enemy.nian: [Location.provinceAnhui],
      Enemy.panthay: [Location.provinceYunnan],
      Enemy.sikh: [Location.provinceKeshimier],
      Enemy.taiping: [Location.provinceJiangxi],
      Enemy.taiwan: [Location.provinceTaiwan],
      Enemy.thai: [Location.provinceXianLuo],
      Enemy.tibetan: [Location.provinceXizang],
      Enemy.turkish: [Location.provinceHuokande],
      Enemy.viet: [Location.provinceDongJing],
      Enemy.whiteLotus: [Location.provinceHubei],
      Enemy.wokou: [Location.provinceRiben],
    };
    return entryAreas[enemy]!;
  }

  List<Location> warEntryAreas(Piece war) {
    final enemy = warEnemy(war);
    final entryAreas = enemyEntryAreas(enemy);
    if (entryAreas.length == 1) {
      return entryAreas;
    }
    if (warCavalryStrength(war) > 0) {
      return [entryAreas[0]];
    }
    return entryAreas.sublist(1);
  }

  List<Location> warInitialSpaces(Piece war) {
    final enemy = warEnemy(war);
    final foreignStatus = enemy.foreignStatus;
    if (foreignStatus != null) {
      final provinces = <Location>[];
      for (final province in LocationType.province.locations) {
        if (provinceStatus(province) == foreignStatus) {
          provinces.add(province);
        }
      }
      if (provinces.isNotEmpty) {
        return provinces;
      }
    }
    return warEntryAreas(war);
  }

  List<Piece> enemyWarsWithoutLeaders(Enemy enemy) {
    final wars = <Piece>[];
    for (final war in PieceType.war.pieces) {
      if (warEnemy(war) == enemy) {
        final location = pieceLocation(war);
        if (location.isType(LocationType.space)) {
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
      Piece.leaderStatesmanCaoFutian: Piece.statesmanCaoFutian,
      Piece.leaderStatesmanKoxinga: Piece.statesmanKoxinga,
      Piece.leaderStatesmanMao: Piece.statesmanMao,
      Piece.leaderStatesmanWangLun: Piece.statesmanWangLun,
      Piece.leaderStatesmanXiuquan: Piece.statesmanXiuquan,
    };
    return leaderStatesmen[leader]!;
  }

  String adornedStatesmanName(Piece statesman) {
    String name = statesman.desc;
    final location = pieceLocation(statesman);
    if (location == Location.commandEmperor) {
      if (statesman == Piece.statesmanCixi) {
        name = 'Dowager Empress $name';
      } else {
        name = 'Emperor $name';
      }
    } else if (location == Location.commandPresident) {
      name = 'President $name';
    } else if (location.isType(LocationType.governorship)) {
      name = 'Governor $name';
      if (commandRebel(location)) {
        name = 'Rebel $name';
      }
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

  int statesmanReform(Piece statesman) {
    return statesmanData[statesman]!.$4;
  }

  int statesmanIntrigue(Piece statesman) {
    return statesmanData[statesman]!.$5;
  }

  bool statesmanImperial(Piece statesman) {
    return statesmanData[statesman]!.$6;
  }

  bool statesmanPresidential(Piece statesman) {
    return statesmanData[statesman]!.$7;
  }

  bool statesmanActiveImperial(Piece statesman) {
    return statesmanImperial(statesman);
  }

  bool statesmanMayBecomeRuler(Piece statesman) {
    return true;
  }

  Piece? statesmanLeader(Piece statesman) {
    const statesmanLeaders = {
      Piece.statesmanCaoFutian: Piece.leaderStatesmanCaoFutian,
      Piece.statesmanKoxinga: Piece.leaderStatesmanKoxinga,
      Piece.statesmanMao:  Piece.leaderStatesmanMao,
      Piece.statesmanWangLun: Piece.leaderStatesmanWangLun,
      Piece.statesmanXiuquan: Piece.leaderStatesmanXiuquan,
    };
    return statesmanLeaders[statesman];
  }

  // Commands

  LocationType? commandLocationType(Location command) {
    const commandLocationTypes = {
      Location.commandEmperor: null,
      Location.commandPresident: null,
      Location.commandNorthChina: LocationType.provinceNorthChina,
      Location.commandSouthChina: LocationType.provinceSouthChina,
      Location.commandEastChina: LocationType.provinceEastChina,
      Location.commandWestChina: LocationType.provinceWestChina,
      Location.commandManchuria: LocationType.provinceManchuria,
      Location.commandMongolia: LocationType.provinceMongolia,
      Location.commandTibet: LocationType.provinceTibet,
      Location.commandXinjiang: LocationType.provinceXinjiang,
      Location.commandEast: LocationType.provinceEast,
      Location.commandSouth: LocationType.provinceSouth,
    };
    return commandLocationTypes[command];
  }

  String commandName(Location command) {
    const commandNames = {
      Location.commandEmperor: 'Emperor',
      Location.commandPresident: 'President',
      Location.commandNorthChina: 'North China',
      Location.commandSouthChina: 'South China',
      Location.commandEastChina: 'East China',
      Location.commandWestChina: 'West China',
      Location.commandManchuria: 'Manchuria',
      Location.commandMongolia: 'Mongolia',
      Location.commandTibet: 'Tibet',
      Location.commandXinjiang: 'Xinjiang',
      Location.commandEast: 'The East',
      Location.commandSouth: 'The South',
    };
    return commandNames[command]!;
  }

  bool commandsConnect(Location command0, Location command1) {
    const commandConnections = {
      Location.commandNorthChina: [Location.commandEastChina, Location.commandWestChina, Location.commandManchuria, Location.commandMongolia, Location.commandEast],
      Location.commandSouthChina: [Location.commandEastChina, Location.commandWestChina, Location.commandTibet, Location.commandEast, Location.commandSouth],
      Location.commandEastChina: [Location.commandNorthChina, Location.commandSouthChina, Location.commandWestChina, Location.commandEast],
      Location.commandWestChina: [Location.commandNorthChina, Location.commandSouthChina, Location.commandEastChina, Location.commandMongolia, Location.commandTibet, Location.commandXinjiang],
      Location.commandManchuria: [Location.commandNorthChina, Location.commandMongolia, Location.commandEast],
      Location.commandMongolia: [Location.commandNorthChina, Location.commandWestChina, Location.commandManchuria, Location.commandXinjiang],
      Location.commandTibet: [Location.commandSouthChina, Location.commandWestChina, Location.commandXinjiang, Location.commandSouth],
      Location.commandXinjiang: [Location.commandWestChina, Location.commandMongolia, Location.commandTibet],
      Location.commandEast: [Location.commandNorthChina, Location.commandSouthChina, Location.commandEastChina, Location.commandManchuria, Location.commandSouth],
      Location.commandSouth: [Location.commandSouthChina, Location.commandTibet, Location.commandEast],
    };
    return commandConnections[command0]!.contains(command1);
  }

  String commanderPositionName(Location command, bool generic) {
    if (command == Location.commandEmperor) {
      if (generic) {
        return 'Regent';
      } else {
        return 'Emperor';
      }
    } else if (command == Location.commandPresident) {
      if (generic) {
        return 'Provisional President';
      } else {
        return 'President';
      }
    } else {
      const governorPositionNames = {
        Location.commandNorthChina: 'Governor of North China',
        Location.commandSouthChina: 'Governor of South China',
        Location.commandEastChina: 'Governor of East China',
        Location.commandWestChina:  'Governor of West China',
        Location.commandManchuria: 'Governor of Manchuria',
        Location.commandMongolia: 'Governor of Mongolia',
        Location.commandTibet: 'Governor of Tibet',
        Location.commandXinjiang: 'Governor of Xinjiang',
        Location.commandEast: 'Governor of The East',
        Location.commandSouth: 'Governor of The South',
      };
      return governorPositionNames[command]!;
    }
  }

  Location commandAllegiance(Location command) {
    return command;
  }

  bool commandLoyal(Location command) {
    return _commandLoyals[command.index - LocationType.command.firstIndex];
  }

  bool commandRebel(Location command) {
    return !_commandLoyals[command.index - LocationType.command.firstIndex];
  }

  bool commandLoyalVsRuler(Location command) {
    return commandLoyal(command);
  }

  bool commandRebelVsRuler(Location command) {
    return commandRebel(command);
  }

  void setCommandLoyalty(Location command, bool loyal) {
    _commandLoyals[command.index - LocationType.command.firstIndex] = loyal;
  }

  Location commandOverallCommand(Location command) {
    return commandRebel(command) ? command : rulingCommand;
  }

  bool commandActive(Location command) {
    if (command.isType(LocationType.ruler)) {
      return command == rulingCommand;
    }
    final locationType = commandLocationType(command)!;
    for (final province in locationType.locations) {
      if (spaceInsurgentOrBetter(province)) {
        return true;
      }
    }
    return false;
  }

  int governorshipAllegianceCount(Location governorship) {
    return 1;
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

  Location get rulingCommand {
    return _gmd ? Location.commandPresident : Location.commandEmperor;
  }

  void qingDynastyFalls() {
    _gmd = true;
  }

  List<Location> loyalGovernorshipAllegianceCandidates(Location governorship) {
    final candidates = [governorship];
    if (pieceInLocation(PieceType.statesman, governorship) == null) {
      final allegiance = commandAllegiance(governorship);
      for (final otherGovernorship in LocationType.governorship.locations) {
        if (otherGovernorship != governorship) {
          if (commandLoyal(otherGovernorship)) {
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
    return pieceInLocation(PieceType.statesman, allegiance);
  }

  String commanderName(Location command) {
    final allegiance = commandAllegiance(command);
    final commander = commandCommander(allegiance);
    if (commander != null) {
      return adornedStatesmanName(commander);
    } else {
      return commanderPositionName(command, true);
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

  int commandReform(Location command) {
    final allegiance = commandAllegiance(command);
    final commander = commandCommander(allegiance);
    if (commander != null) {
      return statesmanReform(commander);
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
    if (location.isType(LocationType.ruler)) {
      return false;
    }
    if (commandRebel(location)) {
      return false;
    }
    return true;
  }

  bool commandValidAppointment(Location command) {
    if (command.isType(LocationType.ruler)) {
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

  bool treatyActive(Piece treaty) {
    return pieceLocation(treaty).isType(LocationType.treaty);
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
      EventType.buddhists: 'Buddhists',
      EventType.christians: 'Christians',
      EventType.conquest: 'Conquest',
      EventType.conspiracy: 'Conspiracy',
      EventType.diplomat: 'Diplomat',
      EventType.dynasty: 'Dynasty',
      EventType.emigration: 'Emigration',
      EventType.flood: 'Flood',
      EventType.inflation: 'Inflation',
      EventType.isolation: 'Isolation',
      EventType.muslims: 'Muslims',
      EventType.omens: 'Omens',
      EventType.opium: 'Opium',
      EventType.persecution: 'Persecution',
      EventType.pillage: 'Pillage',
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

  int get cash {
    return _cash;
  }

  void setCash(int amount) {
    _cash = amount;
  }

  void adjustCash(int amount) {
    _cash += amount;
    if (_cash > 500) {
      _cash = 500;
    }
  }

  int get prestige {
    return _prestige;
  }

  void setPrestige(int amount) {
    _prestige = amount;
  }

  void adjustPrestige(int amount) {
    _prestige += amount;
  }

  int get unrest {
    return _unrest;
  }

  void setUnrest(int amount) {
    _unrest = amount;
  }

  void adjustUnrest(int amount) {
    _unrest += amount;
    if (_unrest < 0) {
      _unrest = 0;
    }
  }

  int? leaderAge(Piece leader) {
    if (leader.isType(PieceType.leaderLeader)) {
      return _leaderAges[leader.index - PieceType.leader.firstIndex];
    } else {
      return statesmanAge(leaderStatesman(leader));
    }
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
		  int ageClassification = (age - 18 + 4) ~/ 8;
      setPieceLocation(leader, location);
      setLeaderAge(leader, ageClassification);
    }
  }

  void setupStatesmen(List<(Piece, Location, int)> statesmen) {
    for (final record in statesmen) {
      final statesman = record.$1;
      final location = record.$2;
      final age = record.$3;
		  int ageClassification = (age - 18 + 4) ~/ 8;
      setPieceLocation(statesman, location);
      setStatesmanAge(statesman, ageClassification);
    }
  }

  void setupTreaties(List<Piece> treaties) {
    for (final treaty in treaties) {
      final box = Location.values[LocationType.treaty.firstIndex + treaty.index - PieceType.treaty.firstIndex];
      setPieceLocation(treaty, box);
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

  factory GameState.setup1644CE() {

    var state = GameState();

    state._turn = 0;
    state.setCash(100);
    state.setPrestige(0);
    state.setUnrest(4);

	  state.setupStatesmen([
      (Piece.statesmanDorgon, Location.commandEmperor, 32),
      (Piece.statesmanWuSangui, Location.commandNorthChina, 32),
	  ]);

    state.setupLeaders([
    ]);

    state.setCommandLoyalty(Location.commandSouthChina, false);
    state.setCommandLoyalty(Location.commandEastChina, false);
    state.setCommandLoyalty(Location.commandWestChina, false);
    state.setCommanderAge(Location.commandSouthChina, 3);
    state.setCommanderAge(Location.commandEastChina, 3);
    state.setCommanderAge(Location.commandWestChina, 3);

    state.setupTreaties([
    ]);

	  state.setupStatesmenPool([
      Piece.treatyNerchinsk,
      Piece.statesmanSharhuda,
      Piece.statesmanOboi,
      Piece.statesmanShiLang,
      Piece.statesmanKoxinga,
      Piece.statesmanSonggotu,
      Piece.statesmanShunzhi,
      Piece.statesmanKangxi,
      Piece.statesmanYongzheng,
      Piece.statesmanGengyao,
      Piece.statesmanYunsi,
      Piece.statesmanOrtai,
      Piece.statesmanYinxiang,
      Piece.statesmanZhongqi,
      Piece.statesmanYunti,
      Piece.statesmanQianlong,
    ]);

    state.setupWarsPool([
      Piece.leaderGaldan,
      Piece.warDutch5,
      Piece.warMian8,
      Piece.warMiao7,
      Piece.warMongol14,
      Piece.warMongol12,
      Piece.warMongol10,
      Piece.warPirate8,
      Piece.warPirate6,
      Piece.warPortuguese4,
      Piece.warRussian12,
      Piece.warRussian10,
      Piece.warTaiwan4,
      Piece.warThai6,
      Piece.warTibetan8,
      Piece.warTibetan6,
      Piece.warTurkish12,
      Piece.warTurkish11,
      Piece.warTurkish10,
      Piece.warViet9,
      Piece.warWokou7,
      Piece.warWokou5,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceBeijing, ProvinceStatus.insurgent),
      (Location.provinceHenan, ProvinceStatus.insurgent),
      (Location.provinceShanxi, ProvinceStatus.insurgent),
      (Location.provinceTianjin, ProvinceStatus.insurgent),
      (Location.provinceShandong, ProvinceStatus.insurgent),
      (Location.provinceZhili, ProvinceStatus.insurgent),
      (Location.provinceQingdao, ProvinceStatus.vassal),
      (Location.provincePortEdward, ProvinceStatus.vassal),
      (Location.provinceFujian, ProvinceStatus.insurgent),
      (Location.provinceGuangdong, ProvinceStatus.insurgent),
      (Location.provinceGuangxi, ProvinceStatus.insurgent),
      (Location.provinceHainan, ProvinceStatus.insurgent),
      (Location.provinceYunnan, ProvinceStatus.insurgent),
      (Location.provinceMacau, ProvinceStatus.foreignPortuguese),
      (Location.provinceGuangzhouwan, ProvinceStatus.vassal),
      (Location.provinceHongKong, ProvinceStatus.vassal),
      (Location.provinceJiangsu, ProvinceStatus.insurgent),
      (Location.provinceShanghai, ProvinceStatus.vassal),
      (Location.provinceChongqing, ProvinceStatus.insurgent),
      (Location.provinceSichuan, ProvinceStatus.insurgent),
      (Location.provinceKuyedao, ProvinceStatus.vassal),
      (Location.provincePortArthur, ProvinceStatus.vassal),
      (Location.provinceVladivostok, ProvinceStatus.vassal),
      (Location.provinceChechen, ProvinceStatus.barbarian),
      (Location.provinceDahuer, ProvinceStatus.barbarian),
      (Location.provinceKebuduo, ProvinceStatus.barbarian),
      (Location.provinceSaiyin, ProvinceStatus.barbarian),
      (Location.provinceTangnu, ProvinceStatus.barbarian),
      (Location.provinceTuchetu, ProvinceStatus.barbarian),
      (Location.provinceTuwalu, ProvinceStatus.barbarian),
      (Location.provinceWala, ProvinceStatus.barbarian),
      (Location.provinceZasaketu, ProvinceStatus.barbarian),
      (Location.provinceAlidi, ProvinceStatus.vassal),
      (Location.provinceDongzang, ProvinceStatus.vassal),
      (Location.provinceXizang, ProvinceStatus.vassal),
      (Location.provinceZangnan, ProvinceStatus.vassal),
      (Location.provinceAsamu, ProvinceStatus.barbarian),
      (Location.provinceBudan, ProvinceStatus.barbarian),
      (Location.provinceKeshimier, ProvinceStatus.barbarian),
      (Location.provinceLadake, ProvinceStatus.barbarian),
      (Location.provinceNiboer, ProvinceStatus.barbarian),
      (Location.provinceQangtang, ProvinceStatus.barbarian),
      (Location.provinceXijin, ProvinceStatus.barbarian),
      (Location.provinceAfuhan, ProvinceStatus.barbarian),
      (Location.provinceBadasha, ProvinceStatus.barbarian),
      (Location.provinceBuhala, ProvinceStatus.barbarian),
      (Location.provinceDihua, ProvinceStatus.barbarian),
      (Location.provinceHasake, ProvinceStatus.barbarian),
      (Location.provinceHuijiang, ProvinceStatus.barbarian),
      (Location.provinceHuokande, ProvinceStatus.barbarian),
      (Location.provinceMeierfu, ProvinceStatus.barbarian),
      (Location.provinceQinghai, ProvinceStatus.barbarian),
      (Location.provinceTashigan, ProvinceStatus.barbarian),
      (Location.provinceXiwa, ProvinceStatus.barbarian),
      (Location.provinceYili, ProvinceStatus.barbarian),
      (Location.provinceZhunbu, ProvinceStatus.barbarian),
      (Location.provinceBusan, ProvinceStatus.vassal),
      (Location.provinceChaoxian, ProvinceStatus.vassal),
      (Location.provinceRyukyu, ProvinceStatus.vassal),
      (Location.provinceTainan, ProvinceStatus.vassal),
      (Location.provinceNagasaki, ProvinceStatus.foreignDutch),
      (Location.provinceTaiwan, ProvinceStatus.foreignDutch),
      (Location.provinceLuSong, ProvinceStatus.foreignSpanish),
      (Location.provinceManila, ProvinceStatus.foreignSpanish),
      (Location.provinceRiben, ProvinceStatus.barbarian),
      (Location.provinceSulu, ProvinceStatus.barbarian),
      (Location.provinceAnnan, ProvinceStatus.vassal),
      (Location.provinceBangkok, ProvinceStatus.vassal),
      (Location.provinceDongJing, ProvinceStatus.vassal),
      (Location.provinceGaoMian, ProvinceStatus.vassal),
      (Location.provinceSaigon, ProvinceStatus.vassal),
      (Location.provinceXianLuo, ProvinceStatus.vassal),
      (Location.provinceLaoWo, ProvinceStatus.barbarian),
      (Location.provinceMalaya, ProvinceStatus.barbarian),
      (Location.provinceMianDian, ProvinceStatus.barbarian),
      (Location.provinceRangoon, ProvinceStatus.barbarian),
      (Location.provinceShanBang, ProvinceStatus.barbarian),
  	]);

    state.setupPieces([
      (Location.provinceBeijing, Piece.guardVeteran0),
      (Location.provinceBeijing, Piece.cavalryVeteran0),
      (Location.provinceBeijing, Piece.bannerVeteran0),
      (Location.provinceHenan, Piece.bannerVeteran1),
      (Location.provinceHenan, Piece.banner2),
      (Location.provinceShanxi, Piece.bannerVeteran3),
      (Location.provinceShanxi, Piece.banner4),
      (Location.provinceTianjin, Piece.banner5),
      (Location.provinceTianjin, Piece.fleet0),
      (Location.provinceZhili, Piece.cavalryVeteran1),
      (Location.provinceZhili, Piece.bannerVeteran6),
      (Location.provinceFujian, Piece.banner7),
      (Location.provinceFujian, Piece.militia0),
      (Location.provinceFujian, Piece.fleet1),
      (Location.provinceGuangdong, Piece.banner8),
      (Location.provinceGuangdong, Piece.militia1),
      (Location.provinceGuangdong, Piece.fleet2),
      (Location.provinceGuangxi, Piece.banner9),
      (Location.provinceGuangxi, Piece.militia2),
      (Location.provinceHainan, Piece.militia3),
      (Location.provinceYunnan, Piece.banner10),
      (Location.provinceYunnan, Piece.militia4),
      (Location.provinceJiangsu, Piece.banner11),
      (Location.provinceJiangsu, Piece.fleet3),
      (Location.provinceJiangxi, Piece.banner12),
      (Location.provinceNanjing, Piece.banner13),
      (Location.provinceNanjing, Piece.fleet4),
      (Location.provinceZhejiang, Piece.banner14),
      (Location.provinceZhejiang, Piece.fleet5),
      (Location.provinceChongqing, Piece.militia5),
      (Location.provinceGansu, Piece.banner15),
      (Location.provinceGansu, Piece.militia6),
      (Location.provinceGuizhou, Piece.militia7),
      (Location.provinceHunan, Piece.militia8),
      (Location.provinceLanzhou, Piece.banner16),
      (Location.provinceLanzhou, Piece.militia9),
      (Location.provinceSichuan, Piece.militia10),
      (Location.provinceAihui, Piece.banner17),
      (Location.provinceAihui, Piece.militia11),
      (Location.provinceAmuer, Piece.banner18),
      (Location.provinceAmuer, Piece.militia12),
      (Location.provinceHinggan, Piece.banner19),
      (Location.provinceHinggan, Piece.militia13),
      (Location.provinceHinggan, Piece.militia14),
      (Location.provinceRehe, Piece.cavalry2),
      (Location.provinceRehe, Piece.banner20),
      (Location.provinceRehe, Piece.militia15),
      (Location.provinceChahar, Piece.cavalryVeteran3),
      (Location.provinceChahar, Piece.bannerVeteran21),
      (Location.provinceChahar, Piece.militia16),
      (Location.provinceNingxia, Piece.banner22),
      (Location.provinceNingxia, Piece.militia17),
      (Location.provinceSuiyuan, Piece.banner23),
      (Location.provinceSuiyuan, Piece.militia18),
      (Location.provinceSuiyuan, Piece.militia19),
      (Location.boxBarracks, Piece.guard1),
      (Location.boxBarracks, Piece.cavalry4),
      (Location.boxBarracks, Piece.cavalry5),
      (Location.boxBarracks, Piece.fleet6),
      (Location.boxBarracks, Piece.fleet7),
      (Location.boxBarracks, Piece.fleet8),
      (Location.boxBarracks, Piece.fleet9),
      (Location.boxBarracks, Piece.fleet10),
      (Location.boxBarracks, Piece.fleet11),
    ]);

    return state;
  }

  factory GameState.setup1735CE() {

    var state = GameState();

    state._turn = 10;
    state.setCash(100);
    state.setPrestige(0);
    state.setUnrest(2);

	  state.setupStatesmen([
      (Piece.statesmanQianlong, Location.commandEmperor, 24),
      (Piece.statesmanOrtai, Location.commandWestChina, 55),
      (Piece.statesmanZhongqi, Location.commandTibet, 49),
	  ]);

    state.setupLeaders([
      (Piece.leaderGaldan, Location.provinceKebuduo, 42),
    ]);

    state.setupTreaties([
      Piece.treatyNerchinsk,
    ]);

	  state.setupStatesmenPool([
      Piece.treatyKyakhta,
      Piece.statesmanZhaohui,
      Piece.statesmanAgui,
      Piece.statesmanFuheng,
      Piece.statesmanSunShiyi,
      Piece.statesmanYongxuan,
      Piece.statesmanWangLun,
      Piece.statesmanYongqi,
      Piece.statesmanHeshen,
      Piece.statesmanFuKangan,
      Piece.statesmanYangFang,
      Piece.statesmanJiaqing,
      Piece.statesmanDaoguang,
    ]);

    state.setupWarsPool([
      Piece.leaderHsinbyushin,
      Piece.leaderNguyen,
      Piece.leaderZhengYi,
      Piece.warDutch5,
      Piece.warGurkha7,
      Piece.warGurkha5,
      Piece.warJinchuan5,
      Piece.warMiao9,
      Piece.warMiao7,
      Piece.warMongol14,
      Piece.warMongol12,
      Piece.warMongol10,
      Piece.warPirate8,
      Piece.warPirate6,
      Piece.warRussian14,
      Piece.warRussian12,
      Piece.warTaiwan4,
      Piece.warThai6,
      Piece.warTurkish12,
      Piece.warTurkish11,
      Piece.warTurkish10,
      Piece.warViet9,
      Piece.warWhiteLotus9,
      Piece.warWokou7,
      Piece.warWokou5,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceQingdao, ProvinceStatus.vassal),
      (Location.provincePortEdward, ProvinceStatus.vassal),
      (Location.provinceMacau, ProvinceStatus.foreignPortuguese),
      (Location.provinceGuangzhouwan, ProvinceStatus.vassal),
      (Location.provinceHongKong, ProvinceStatus.vassal),
      (Location.provinceShanghai, ProvinceStatus.vassal),
      (Location.provinceChongqing, ProvinceStatus.insurgent),
      (Location.provinceGuizhou, ProvinceStatus.insurgent),
      (Location.provinceHubei, ProvinceStatus.insurgent),
      (Location.provinceKuyedao, ProvinceStatus.vassal),
      (Location.provincePortArthur, ProvinceStatus.vassal),
      (Location.provinceVladivostok, ProvinceStatus.vassal),
      (Location.provinceKebuduo, ProvinceStatus.barbarian),
      (Location.provinceSaiyin, ProvinceStatus.insurgent),
      (Location.provinceTangnu, ProvinceStatus.insurgent),
      (Location.provinceZasaketu, ProvinceStatus.insurgent),
      (Location.provinceDahuer, ProvinceStatus.foreignRussian),
      (Location.provinceTuwalu, ProvinceStatus.foreignRussian),
      (Location.provinceDongzang, ProvinceStatus.insurgent),
      (Location.provinceAlidi, ProvinceStatus.vassal),
      (Location.provinceQangtang, ProvinceStatus.vassal),
      (Location.provinceXizang, ProvinceStatus.vassal),
      (Location.provinceZangnan, ProvinceStatus.vassal),
      (Location.provinceAsamu, ProvinceStatus.barbarian),
      (Location.provinceBudan, ProvinceStatus.barbarian),
      (Location.provinceKeshimier, ProvinceStatus.barbarian),
      (Location.provinceLadake, ProvinceStatus.barbarian),
      (Location.provinceNiboer, ProvinceStatus.barbarian),
      (Location.provinceXijin, ProvinceStatus.barbarian),
      (Location.provinceQinghai, ProvinceStatus.insurgent),
      (Location.provinceAfuhan, ProvinceStatus.barbarian),
      (Location.provinceBadasha, ProvinceStatus.barbarian),
      (Location.provinceBuhala, ProvinceStatus.barbarian),
      (Location.provinceDihua, ProvinceStatus.barbarian),
      (Location.provinceHasake, ProvinceStatus.barbarian),
      (Location.provinceHuijiang, ProvinceStatus.barbarian),
      (Location.provinceHuokande, ProvinceStatus.barbarian),
      (Location.provinceMeierfu, ProvinceStatus.barbarian),
      (Location.provinceTashigan, ProvinceStatus.barbarian),
      (Location.provinceXiwa, ProvinceStatus.barbarian),
      (Location.provinceYili, ProvinceStatus.barbarian),
      (Location.provinceZhunbu, ProvinceStatus.barbarian),
      (Location.provinceBusan, ProvinceStatus.vassal),
      (Location.provinceChaoxian, ProvinceStatus.vassal),
      (Location.provinceRyukyu, ProvinceStatus.vassal),
      (Location.provinceSulu, ProvinceStatus.vassal),
      (Location.provinceTainan, ProvinceStatus.vassal),
      (Location.provinceNagasaki, ProvinceStatus.foreignDutch),
      (Location.provinceLuSong, ProvinceStatus.foreignSpanish),
      (Location.provinceManila, ProvinceStatus.foreignSpanish),
      (Location.provinceRiben, ProvinceStatus.barbarian),
      (Location.provinceAnnan, ProvinceStatus.vassal),
      (Location.provinceBangkok, ProvinceStatus.vassal),
      (Location.provinceDongJing, ProvinceStatus.vassal),
      (Location.provinceGaoMian, ProvinceStatus.vassal),
      (Location.provinceLaoWo, ProvinceStatus.vassal),
      (Location.provinceMalaya, ProvinceStatus.vassal),
      (Location.provinceMianDian, ProvinceStatus.vassal),
      (Location.provinceSaigon, ProvinceStatus.vassal),
      (Location.provinceRangoon, ProvinceStatus.barbarian),
      (Location.provinceShanBang, ProvinceStatus.barbarian),
      (Location.provinceXianLuo, ProvinceStatus.barbarian),
  	]);

    state.setupPieces([
      (Location.provinceBeijing, Piece.guardVeteran0),
      (Location.provinceBeijing, Piece.cavalryVeteran0),
      (Location.provinceBeijing, Piece.bannerVeteran0),
      (Location.provinceShanxi, Piece.banner1),
      (Location.provinceTianjin, Piece.fleet0),
      (Location.provinceZhili, Piece.bannerVeteran2),
      (Location.provinceGuangdong, Piece.banner3),
      (Location.provinceGuangdong, Piece.militia0),
      (Location.provinceGuangdong, Piece.fleet1),
      (Location.provinceYunnan, Piece.fort1),
      (Location.provinceNanjing, Piece.fleet2),
      (Location.provinceChongqing, Piece.bannerVeteran4),
      (Location.provinceChongqing, Piece.militia2),
      (Location.provinceGansu, Piece.banner5),
      (Location.provinceGansu, Piece.militia3),
      (Location.provinceGuizhou, Piece.fort4),
      (Location.provinceHubei, Piece.banner6),
      (Location.provinceHubei, Piece.militia5),
      (Location.provinceLanzhou, Piece.banner7),
      (Location.provinceShaanxi, Piece.banner8),
      (Location.provinceAihui, Piece.fort6),
      (Location.provinceAihui, Piece.militia7),
      (Location.provinceAmuer, Piece.bannerVeteran9),
      (Location.provinceAmuer, Piece.militia8),
      (Location.provinceHinggan, Piece.banner10),
      (Location.provinceHinggan, Piece.fort9),
      (Location.provinceChechen, Piece.banner11),
      (Location.provinceChechen, Piece.fort10),
      (Location.provinceSaiyin, Piece.banner12),
      (Location.provinceSaiyin, Piece.fort11),
      (Location.provinceTangnu, Piece.bannerVeteran13),
      (Location.provinceTangnu, Piece.fort12),
      (Location.provinceTangnu, Piece.militia13),
      (Location.provinceTuchetu, Piece.banner14),
      (Location.provinceTuchetu, Piece.fort14),
      (Location.provinceWala, Piece.banner15),
      (Location.provinceWala, Piece.fort15),
      (Location.provinceZasaketu, Piece.cavalryVeteran1),
      (Location.provinceZasaketu, Piece.bannerVeteran16),
      (Location.provinceZasaketu, Piece.fort16),
      (Location.provinceZasaketu, Piece.militia17),
      (Location.provinceDongzang, Piece.banner17),
      (Location.provinceDongzang, Piece.militia18),
      (Location.provinceQinghai, Piece.cavalry2),
      (Location.provinceQinghai, Piece.bannerVeteran18),
      (Location.provinceQinghai, Piece.fort19),
      (Location.boxBarracks, Piece.guard1),
      (Location.boxBarracks, Piece.cavalry3),
      (Location.boxBarracks, Piece.cavalry4),
      (Location.boxBarracks, Piece.cavalry5),
      (Location.boxBarracks, Piece.banner19),
      (Location.boxBarracks, Piece.banner20),
      (Location.boxBarracks, Piece.banner21),
      (Location.boxBarracks, Piece.banner22),
      (Location.boxBarracks, Piece.banner23),
      (Location.boxBarracks, Piece.fleet3),
      (Location.boxBarracks, Piece.fleet4),
      (Location.boxBarracks, Piece.fleet5),
      (Location.boxBarracks, Piece.fleet6),
      (Location.boxBarracks, Piece.fleet7),
      (Location.boxBarracks, Piece.fleet8),
      (Location.boxBarracks, Piece.fleet9),
      (Location.boxBarracks, Piece.fleet10),
      (Location.boxBarracks, Piece.fleet11),
    ]);

    return state;
  }

  factory GameState.setup1820CE() {

    var state = GameState();

    state._turn = 20;
    state.setCash(100);
    state.setPrestige(0);
    state.setUnrest(1);

	  state.setupStatesmen([
      (Piece.statesmanDaoguang, Location.commandEmperor, 38),
      (Piece.statesmanYongxuan, Location.commandNorthChina, 74),
      (Piece.statesmanYangFang, Location.commandXinjiang, 50),
	  ]);

    state.setupLeaders([
    ]);

    state.setupTreaties([
      Piece.treatyNerchinsk,
      Piece.treatyKyakhta,
    ]);

	  state.setupStatesmenPool([
      Piece.treatyNanjing,
      Piece.treatyTianjin,
      Piece.statesmanLinZexu,
      Piece.statesmanRinchen,
      Piece.statesmanGuofan,
      Piece.statesmanZuo,
      Piece.statesmanXiuquan,
      Piece.statesmanMianyu,
      Piece.statesmanHongzhang,
      Piece.statesmanXianfeng,
      Piece.statesmanYixin,
      Piece.statesmanCixi,
      Piece.statesmanLiuYongfu,
      Piece.statesmanTongzhi,
    ]);

    state.setupWarsPool([
      Piece.leaderYaqub,
      Piece.warAmerican7,
      Piece.warBritish12,
      Piece.warBritish10,
      Piece.warBritish8,
      Piece.warFrench11,
      Piece.warFrench9,
      Piece.warGurkha7,
      Piece.warHui11,
      Piece.warJapanese9,
      Piece.warMian8,
      Piece.warMiao9,
      Piece.warNian11,
      Piece.warPanthay13,
      Piece.warPirate6,
      Piece.warRedTurban12,
      Piece.warRussian14,
      Piece.warRussian12,
      Piece.warRussian10,
      Piece.warSpanish6,
      Piece.warSikh4,
      Piece.warTaiping14,
      Piece.warTurkish11,
      Piece.warTurkish10,
      Piece.warWokou5,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceHenan, ProvinceStatus.insurgent),
      (Location.provinceQingdao, ProvinceStatus.vassal),
      (Location.provincePortEdward, ProvinceStatus.vassal),
      (Location.provinceMacau, ProvinceStatus.foreignPortuguese),
      (Location.provinceGuangzhouwan, ProvinceStatus.vassal),
      (Location.provinceHongKong, ProvinceStatus.vassal),
      (Location.provinceShanghai, ProvinceStatus.vassal),
      (Location.provinceKuyedao, ProvinceStatus.vassal),
      (Location.provincePortArthur, ProvinceStatus.vassal),
      (Location.provinceVladivostok, ProvinceStatus.vassal),
      (Location.provinceDahuer, ProvinceStatus.foreignRussian),
      (Location.provinceTuwalu, ProvinceStatus.foreignRussian),
      (Location.provinceBudan, ProvinceStatus.vassal),
      (Location.provinceLadake, ProvinceStatus.vassal),
      (Location.provinceNiboer, ProvinceStatus.vassal),
      (Location.provinceXijin, ProvinceStatus.vassal),
      (Location.provinceAsamu, ProvinceStatus.barbarian),
      (Location.provinceKeshimier, ProvinceStatus.barbarian),
      (Location.provinceHuokande, ProvinceStatus.insurgent),
      (Location.provinceAfuhan, ProvinceStatus.vassal),
      (Location.provinceBadasha, ProvinceStatus.vassal),
      (Location.provinceBuhala, ProvinceStatus.vassal),
      (Location.provinceHasake, ProvinceStatus.vassal),
      (Location.provinceMeierfu, ProvinceStatus.barbarian),
      (Location.provinceTashigan, ProvinceStatus.barbarian),
      (Location.provinceXiwa, ProvinceStatus.barbarian),
      (Location.provinceBusan, ProvinceStatus.vassal),
      (Location.provinceChaoxian, ProvinceStatus.vassal),
      (Location.provinceRyukyu, ProvinceStatus.vassal),
      (Location.provinceSulu, ProvinceStatus.vassal),
      (Location.provinceTainan, ProvinceStatus.vassal),
      (Location.provinceNagasaki, ProvinceStatus.foreignDutch),
      (Location.provinceLuSong, ProvinceStatus.foreignSpanish),
      (Location.provinceManila, ProvinceStatus.foreignSpanish),
      (Location.provinceRiben, ProvinceStatus.barbarian),
      (Location.provinceAnnan, ProvinceStatus.vassal),
      (Location.provinceBangkok, ProvinceStatus.vassal),
      (Location.provinceDongJing, ProvinceStatus.vassal),
      (Location.provinceGaoMian, ProvinceStatus.vassal),
      (Location.provinceLaoWo, ProvinceStatus.vassal),
      (Location.provinceMalaya, ProvinceStatus.vassal),
      (Location.provinceMianDian, ProvinceStatus.vassal),
      (Location.provinceRangoon, ProvinceStatus.vassal),
      (Location.provinceSaigon, ProvinceStatus.vassal),
      (Location.provinceShanBang, ProvinceStatus.vassal),
      (Location.provinceXianLuo, ProvinceStatus.vassal),
  	]);

    state.setupPieces([
      (Location.provinceBeijing, Piece.guardVeteran0),
      (Location.provinceBeijing, Piece.cavalryVeteran0),
      (Location.provinceBeijing, Piece.banner0),
      (Location.provinceHenan, Piece.banner1),
      (Location.provinceShanxi, Piece.banner2),
      (Location.provinceTianjin, Piece.fleet0),
      (Location.provinceZhili, Piece.bannerVeteran3),
      (Location.provinceGuangdong, Piece.fort0),
      (Location.provinceGuangdong, Piece.fleet1),
      (Location.provinceYunnan, Piece.fort1),
      (Location.provinceNanjing, Piece.fleet2),
      (Location.provinceGansu, Piece.banner4),
      (Location.provinceLanzhou, Piece.banner5),
      (Location.provinceShaanxi, Piece.banner6),
      (Location.provinceAihui, Piece.cavalryVeteran1),
      (Location.provinceAihui, Piece.bannerVeteran7),
      (Location.provinceAihui, Piece.militia2),
      (Location.provinceAmuer, Piece.banner8),
      (Location.provinceAmuer, Piece.fort3),
      (Location.provinceHinggan, Piece.banner9),
      (Location.provinceHinggan, Piece.fort4),
      (Location.provinceChechen, Piece.banner10),
      (Location.provinceChechen, Piece.fort5),
      (Location.provinceTangnu, Piece.cavalryVeteran2),
      (Location.provinceTangnu, Piece.bannerVeteran11),
      (Location.provinceTangnu, Piece.fort6),
      (Location.provinceTuchetu, Piece.banner12),
      (Location.provinceTuchetu, Piece.fort7),
      (Location.provinceWala, Piece.banner13),
      (Location.provinceWala, Piece.fort8),
      (Location.provinceHuokande, Piece.cavalryVeteran3),
      (Location.provinceHuokande, Piece.fort9),
      (Location.boxBarracks, Piece.guard1),
      (Location.boxBarracks, Piece.cavalry4),
      (Location.boxBarracks, Piece.cavalry5),
      (Location.boxBarracks, Piece.banner14),
      (Location.boxBarracks, Piece.banner15),
      (Location.boxBarracks, Piece.banner16),
      (Location.boxBarracks, Piece.banner17),
      (Location.boxBarracks, Piece.banner18),
      (Location.boxBarracks, Piece.banner19),
      (Location.boxBarracks, Piece.banner20),
      (Location.boxBarracks, Piece.banner21),
      (Location.boxBarracks, Piece.banner22),
      (Location.boxBarracks, Piece.banner23),
      (Location.boxBarracks, Piece.militia10),
      (Location.boxBarracks, Piece.militia11),
      (Location.boxBarracks, Piece.militia12),
      (Location.boxBarracks, Piece.militia13),
      (Location.boxBarracks, Piece.militia14),
      (Location.boxBarracks, Piece.militia15),
      (Location.boxBarracks, Piece.militia16),
      (Location.boxBarracks, Piece.militia17),
      (Location.boxBarracks, Piece.militia18),
      (Location.boxBarracks, Piece.militia19),
      (Location.boxBarracks, Piece.fleet3),
      (Location.boxBarracks, Piece.fleet4),
      (Location.boxBarracks, Piece.fleet5),
      (Location.boxBarracks, Piece.fleet6),
      (Location.boxBarracks, Piece.fleet7),
      (Location.boxBarracks, Piece.fleet8),
      (Location.boxBarracks, Piece.fleet9),
      (Location.boxBarracks, Piece.fleet10),
      (Location.boxBarracks, Piece.fleet11),
    ]);

    return state;
  }

  factory GameState.setup1889CE() {

    var state = GameState();

    state._turn = 30;
    state.setCash(100);
    state.setPrestige(0);
    state.setUnrest(3);

	  state.setupStatesmen([
      (Piece.statesmanCixi, Location.commandEmperor, 54),
      (Piece.statesmanHongzhang, Location.commandNorthChina, 66),
      (Piece.statesmanLiuYongfu, Location.commandSouthChina, 52),
	  ]);

    state.setupLeaders([
    ]);

    state.setupTreaties([
      Piece.treatyNerchinsk,
      Piece.treatyKyakhta,
      Piece.treatyNanjing,
      Piece.treatyTianjin,
    ]);

	  state.setupStatesmenPool([
      Piece.treatyMaguan,
      Piece.treatyXinchou,
      Piece.statesmanCaoFutian,
      Piece.statesmanYinchang,
      Piece.statesmanShikai,
      Piece.statesmanSunYixian,
      Piece.statesmanGuangxu,
      Piece.statesmanZuolin,
      Piece.statesmanFeng,
      Piece.statesmanZhuDe,
      Piece.statesmanJiang,
      Piece.statesmanLiZongren,
      Piece.statesmanMao,
      Piece.statesmanShikai,
      Piece.statesmanPuyi,
    ]);

    state.setupWarsPool([
      Piece.warAmerican7,
      Piece.warBoxer13,
      Piece.warBritish10,
      Piece.warBritish8,
      Piece.warCommunist15,
      Piece.warFrench11,
      Piece.warFrench9,
      Piece.warGerman8,
      Piece.warHui11,
      Piece.warJapanese15,
      Piece.warJapanese13,
      Piece.warJapanese11,
      Piece.warJapanese9,
      Piece.warMian8,
      Piece.warPirate6,
      Piece.warRussian14,
      Piece.warRussian12,
      Piece.warRussian10,
      Piece.warTaiwan4,
      Piece.warTibetan8,
      Piece.warTibetan6,
      Piece.warTurkish12,
      Piece.warTurkish11,
      Piece.warTurkish10,
      Piece.warViet9,
    ]);

    state.setupProvinceStatuses([
      (Location.provinceHenan, ProvinceStatus.insurgent),
      (Location.provinceQingdao, ProvinceStatus.vassal),
      (Location.provinceGuangdong, ProvinceStatus.insurgent),
      (Location.provinceJiangxi, ProvinceStatus.insurgent),
      (Location.provinceYunnan, ProvinceStatus.insurgent),
      (Location.provinceGuangzhouwan, ProvinceStatus.vassal),
      (Location.provinceHongKong, ProvinceStatus.foreignBritish),
      (Location.provinceMacau, ProvinceStatus.foreignPortuguese),
      (Location.provinceAnhui, ProvinceStatus.insurgent),
      (Location.provinceGansu, ProvinceStatus.insurgent),
      (Location.provinceGuizhou, ProvinceStatus.insurgent),
      (Location.provinceLanzhou, ProvinceStatus.insurgent),
      (Location.provincePortArthur, ProvinceStatus.vassal),
      (Location.provinceAmuer, ProvinceStatus.foreignRussian),
      (Location.provinceKuyedao, ProvinceStatus.foreignRussian),
      (Location.provinceVladivostok, ProvinceStatus.foreignRussian),
      (Location.provinceWusuli, ProvinceStatus.foreignRussian),
      (Location.provinceDahuer, ProvinceStatus.foreignRussian),
      (Location.provinceTuwalu, ProvinceStatus.foreignRussian),
      (Location.provinceWala, ProvinceStatus.foreignRussian),
      (Location.provinceAlidi, ProvinceStatus.vassal),
      (Location.provinceDongzang, ProvinceStatus.vassal),
      (Location.provinceQangtang, ProvinceStatus.vassal),
      (Location.provinceXizang, ProvinceStatus.vassal),
      (Location.provinceZangnan, ProvinceStatus.vassal),
      (Location.provinceAsamu, ProvinceStatus.foreignBritish),
      (Location.provinceKeshimier, ProvinceStatus.foreignBritish),
      (Location.provinceLadake, ProvinceStatus.foreignBritish),
      (Location.provinceXijin, ProvinceStatus.foreignBritish),
      (Location.provinceBudan, ProvinceStatus.barbarian),
      (Location.provinceNiboer, ProvinceStatus.barbarian),
      (Location.provinceBadasha, ProvinceStatus.foreignRussian),
      (Location.provinceBuhala, ProvinceStatus.foreignRussian),
      (Location.provinceHasake, ProvinceStatus.foreignRussian),
      (Location.provinceMeierfu, ProvinceStatus.foreignRussian),
      (Location.provinceXiwa, ProvinceStatus.foreignRussian),
      (Location.provinceAfuhan, ProvinceStatus.barbarian),
      (Location.provinceTashigan, ProvinceStatus.barbarian),
      (Location.provinceTaiwan, ProvinceStatus.insurgent),
      (Location.provinceChaoxian, ProvinceStatus.vassal),
      (Location.provinceTainan, ProvinceStatus.vassal),
      (Location.provinceBusan, ProvinceStatus.foreignJapanese),
      (Location.provinceNagasaki, ProvinceStatus.foreignJapanese),
      (Location.provinceRiben, ProvinceStatus.foreignJapanese),
      (Location.provinceRyukyu, ProvinceStatus.foreignJapanese),
      (Location.provinceLuSong, ProvinceStatus.foreignSpanish),
      (Location.provinceManila, ProvinceStatus.foreignSpanish),
      (Location.provinceSulu, ProvinceStatus.foreignSpanish),
      (Location.provinceMalaya, ProvinceStatus.foreignBritish),
      (Location.provinceMianDian, ProvinceStatus.foreignBritish),
      (Location.provinceRangoon, ProvinceStatus.foreignBritish),
      (Location.provinceShanBang, ProvinceStatus.foreignBritish),
      (Location.provinceAnnan, ProvinceStatus.foreignFrench),
      (Location.provinceDongJing, ProvinceStatus.foreignFrench),
      (Location.provinceGaoMian, ProvinceStatus.foreignFrench),
      (Location.provinceSaigon, ProvinceStatus.foreignFrench),
      (Location.provinceBangkok, ProvinceStatus.barbarian),
      (Location.provinceLaoWo, ProvinceStatus.barbarian),
      (Location.provinceXianLuo, ProvinceStatus.barbarian),
  	]);

    state.setupPieces([
      (Location.provinceBeijing, Piece.guardVeteran0),
      (Location.provinceBeijing, Piece.cavalryVeteran0),
      (Location.provinceBeijing, Piece.banner0),
      (Location.provinceHenan, Piece.banner1),
      (Location.provincePortEdward, Piece.fleet0),
      (Location.provinceShanxi, Piece.banner2),
      (Location.provinceTianjin, Piece.fleet1),
      (Location.provinceZhili, Piece.banner3),
      (Location.provinceFujian, Piece.fleet2),
      (Location.provinceGuangdong, Piece.bannerVeteran4),
      (Location.provinceGuangdong, Piece.banner5),
      (Location.provinceGuangdong, Piece.fort0),
      (Location.provinceGuangdong, Piece.fleet3),
      (Location.provinceGuangxi, Piece.fort1),
      (Location.provinceHainan, Piece.fort2),
      (Location.provinceHainan, Piece.fleet4),
      (Location.provinceJiangxi, Piece.banner6),
      (Location.provinceYunnan, Piece.banner7),
      (Location.provinceYunnan, Piece.fort3),
      (Location.provinceYunnan, Piece.militia4),
      (Location.provinceAnhui, Piece.militia5),
      (Location.provinceShanghai, Piece.fort6),
      (Location.provinceShanghai, Piece.fleet5),
      (Location.provinceGansu, Piece.banner8),
      (Location.provinceGuizhou, Piece.banner9),
      (Location.provinceLanzhou, Piece.banner10),
      (Location.provinceShaanxi, Piece.banner11),
      (Location.provinceAihui, Piece.banner12),
      (Location.provinceAihui, Piece.fort7),
      (Location.provinceAihui, Piece.fleet6),
      (Location.provinceHeilongjiang, Piece.banner13),
      (Location.provinceHeilongjiang, Piece.fort8),
      (Location.provinceJilin, Piece.cavalry1),
      (Location.provinceJilin, Piece.banner14),
      (Location.provinceJilin, Piece.fort9),
      (Location.provinceChechen, Piece.banner15),
      (Location.provinceChechen, Piece.fort10),
      (Location.provinceKebuduo, Piece.banner16),
      (Location.provinceKebuduo, Piece.fort11),
      (Location.provinceTangnu, Piece.banner17),
      (Location.provinceTangnu, Piece.fort12),
      (Location.provinceTuchetu, Piece.banner18),
      (Location.provinceTuchetu, Piece.fort13),
      (Location.provinceHuokande, Piece.fort14),
      (Location.provinceHuokande, Piece.militia15),
      (Location.provinceYili, Piece.cavalry2),
      (Location.provinceYili, Piece.banner19),
      (Location.provinceYili, Piece.fort16),
      (Location.provinceZhunbu, Piece.banner20),
      (Location.provinceZhunbu, Piece.fort17),
      (Location.provinceTaiwan, Piece.militia18),
      (Location.boxBarracks, Piece.guard1),
      (Location.boxBarracks, Piece.cavalry3),
      (Location.boxBarracks, Piece.cavalry4),
      (Location.boxBarracks, Piece.cavalry5),
      (Location.boxBarracks, Piece.banner21),
      (Location.boxBarracks, Piece.banner22),
      (Location.boxBarracks, Piece.banner23),
      (Location.boxBarracks, Piece.militia19),
      (Location.boxBarracks, Piece.fleet7),
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
    case Scenario.from1644CeTo1735Ce:
  	case Scenario.from1644CeTo1820Ce:
	  case Scenario.from1644CeTo1889Ce:
	  case Scenario.from1644CeTo1949Ce:
      gameState = GameState.setup1644CE();
	  case Scenario.from1735CeTo1820Ce:
	  case Scenario.from1735CeTo1889Ce:
  	case Scenario.from1735CeTo1949Ce:
		  gameState = GameState.setup1735CE();
	  case Scenario.from1820CeTo1889Ce:
  	case Scenario.from1820CeTo1949Ce:
		  gameState = GameState.setup1820CE();
	  case Scenario.from1889CeTo1949Ce:
		  gameState = GameState.setup1889CE();
    }
    return gameState;
  }
}

enum Choice {
  extraTaxes,
  fightWar,
  fightWarsForego,
  fightRebelsForego,
  lossDismiss,
  lossDemote,
  lossUnrest,
  lossPrestige,
  lossTribute,
  lossRevolt,
  lossCede,
  decreaseUnrest,
  increasePrestige,
  addGold,
  promote,
  annex,
  chinese,
  american,
  british,
  dutch,
  french,
  german,
  japanese,
  portuguese,
  russian,
  spanish,
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
  unrest,
  lostCapital,
}

class GameOutcome {
  GameResult result;
  GameResultCause cause;
  int prestige;

  GameOutcome(this.result, this.cause, this.prestige);

  GameOutcome.fromJson(Map<String, dynamic> json)
    : result = GameResult.values[json['result'] as int]
    , cause = GameResultCause.values[json['cause'] as int]
    , prestige = json['prestige'] as int
    ;

  Map<String, dynamic> toJson() => {
    'result': result.index,
    'cause': cause.index,
    'prestige': prestige,
  };
}

class GameOverException implements Exception {
  GameOutcome outcome;

  GameOverException(GameResult result, GameResultCause cause, int prestige)
    : outcome = GameOutcome(result, cause, prestige);
}

class GameOptions {
	int eventCountModifier = 0;
  int taxRollModifier = 0;
	int warRollModifier = 0;
	int dismissMilitiaCount = 2;
	int tributeAmount = 10;
	bool finiteLifetimes = false;

  GameOptions();

  GameOptions.fromJson(Map<String, dynamic> json) {
    eventCountModifier = json['eventCountModifier'] as int;
    taxRollModifier = json['taxRollModifier'] as int;
    warRollModifier = json['warRollModifier'] as int;
    dismissMilitiaCount = json['dismissMilitiaCount'] as int;
    tributeAmount = json['tributeAmount'] as int;
    finiteLifetimes = json['finiteLifetimes'] as bool;
  }

  Map<String, dynamic> toJson() => {
    'eventCountModifier': eventCountModifier,
    'taxRollModifier': taxRollModifier,
    'warRollModifier': warRollModifier,
    'dismissMilitiaCount': dismissMilitiaCount,
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
    if (dismissMilitiaCount != 2) {
      if (optionsList != '') {
        optionsList += ', ';
      }
      optionsList += 'Dismiss Militia: $dismissMilitiaCount';
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

enum DeathCause {
  mortality,
  rebelGovernorVictory,
  noLoyalProvinces,
  assassination,
  dynasty,
  disaster,
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
  List<Location> rulerMortalities = [];
  List<Piece> assassins = [];
  Location? assassinTargetCommand;
  Piece? assassinTargetStatesman;
  List<Piece> remainingForeignWars = [];

  PhaseStateEvent();

  PhaseStateEvent.fromJson(Map<String, dynamic> json) {
    eventsRemainingCount = json['eventsRemainingCount'] as int;
    final eventTypeIndex = json['eventType'] as int?;
    if (eventTypeIndex != null) {
      eventType = EventType.values[eventTypeIndex];
    } else {
      eventType = null;
    }
    rulerMortalities = locationListFromIndices(List<int>.from(json['rulerMortalities']));
    assassins = pieceListFromIndices(List<int>.from(json['assassins']));
    assassinTargetCommand = locationFromIndex(json['assassinTargetCommand']);
    assassinTargetStatesman = pieceFromIndex(json['assassinTargetStatesman']);
  }

  @override
  Map<String, dynamic> toJson() => {
    'eventsRemainingCount': eventsRemainingCount,
    'eventType': eventType?.index,
    'rulerMortalities': locationListToIndices(rulerMortalities),
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

  Piece get drawnWar {
    for (int i = 0; i < warUnmoveds.length; ++i) {
      if (warUnmoveds[i]) {
        return Piece.values[PieceType.war.firstIndex + i];
      }
    }
    return Piece.treatyNerchinsk;
  }
}

class PhaseStateUnrest extends PhaseState {
  int statesmenRemainingCount = 0;
  int treatyLossCount = 0;
  int annexRemainingCount = 0;
  int mandateOfHeavenPrestigeCount = 0;
  Location? transferGovernorship;

  PhaseStateUnrest();

  PhaseStateUnrest.fromJson(Map<String, dynamic> json)
    : statesmenRemainingCount = json['statesmenRemainingCount'] as int
    , treatyLossCount = json['treatyLossCount'] as int
    , annexRemainingCount = json['annexRemainingCount'] as int
    , mandateOfHeavenPrestigeCount = json['mandateOfHeavenPrestigeCount'] as int
    , transferGovernorship = locationFromIndex(json['transferGovernorship'] as int?)
    ;

  @override
  Map<String, dynamic> toJson() => {
    'statesmenRemainingCount': statesmenRemainingCount,
    'treatyLossCount': treatyLossCount,
    'annexRemainingCount': annexRemainingCount,
    'mandateOfHeavenPrestigeCount': mandateOfHeavenPrestigeCount,
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
  Location? deadRuler;
  List<Location> provinces = <Location>[];
  List<Piece> units = <Piece>[];
  List<Piece> rebelUnits = <Piece>[];

  bool triumph = false;
  int lossCount = 0;
  int promoteCount = 0;
  int anyPromoteCount = 0;
  int rebelPromoteCount = 0;
  int annexCount = 0;
  int prestige = 0;
  int unrest = 0;
  int cash = 0;
  int rebelCash = 0;

  int cedeCount = 0;
  int demoteCount = 0;
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
    deadRuler = locationFromIndex(json['dead'] as int?);
    provinces = locationListFromIndices(List<int>.from(json['provinces']));
    units = pieceListFromIndices(List<int>.from(json['units']));
    rebelUnits = pieceListFromIndices(List<int>.from(json['rebelUnits']));

    triumph = json['triumph'] as bool;
    lossCount = json['lossCount'] as int;
    promoteCount = json['promoteCount'] as int;
    anyPromoteCount = json['anyPromoteCount'] as int;
    rebelPromoteCount = json['rebelPromoteCount'] as int;
    annexCount = json['annexCount'] as int;
    prestige = json['prestige'] as int;
    unrest = json['unrest'] as int;
    cash = json['cash'] as int;
    rebelCash = json['rebelCash'] as int;

    cedeCount = json['cedeCount'] as int;
    demoteCount = json['demoteCount'] as int;
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
    'deadRuler': locationToIndex(deadRuler),
    'provinces': locationListToIndices(provinces),
    'units': pieceListToIndices(units),
    'rebelUnits': pieceListToIndices(rebelUnits),
    'triumph': triumph,
    'lossCount': lossCount,
    'promoteCount': promoteCount,
    'anyPromoteCount': anyPromoteCount,
    'rebelPromoteCount': rebelPromoteCount,
    'annexCount': annexCount,
    'prestige': prestige,
    'unrest': unrest,
    'cash': cash,
    'rebelCash': rebelCash,
    'cedeCount': cedeCount,
    'demoteCount': demoteCount,
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

  void warComplete(GameState state, bool commandComplete) {
    if (war != null) {
      warsFought.add(war!);
    }
    if (commandComplete) {
      commandsFought.add(command!);
    }
    provincesFought += provinces;
    for (var unit in units) {
      if (state.pieceLocation(unit) == Location.flipped) {
        unit = state.unitFlipUnit(unit);
      }
      unitsFought.add(unit);
    }

    war = null;
    province = null;
    command = null;
    deadRuler = null;
    provinces.clear();
    units.clear();

    triumph = false;
    lossCount = 0;
    promoteCount = 0;
    annexCount = 0;
    prestige = 0;
    unrest = 0;
    cash = 0;
    rebelCash = 0;

    cedeCount = 0;
    demoteCount = 0;
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
    deadRuler = null;
    units.clear();
    rebelUnits.clear();

    lossCount = 0;
    promoteCount = 0;
    anyPromoteCount = 0;
    rebelPromoteCount = 0;

    cedeCount = 0;
    demoteCount = 0;
    disgraceCount = 0;
    dishonorCount = 0;
    dismissCount = 0;
    tributeCount = 0;
  }

  void clearRebels() {
    commandsFought.clear();
  }

  List<Piece> candidateDismissUnits(GameState state) {
    final candidates = <Piece>[];
    for (var unit in units) {
      if (state.pieceLocation(unit) == Location.flipped) {
        unit = state.unitFlipUnit(unit);
      }
      if (!unit.isType(PieceType.banner) && state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidateDismissCivilWarUnits(GameState state) {
    final candidates = <Piece>[];
    for (var unit in units) {
      if (state.pieceLocation(unit) == Location.flipped) {
        unit = state.unitFlipUnit(unit);
      }
      if (!unit.isType(PieceType.banner) && state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    for (var unit in rebelUnits) {
      if (state.pieceLocation(unit) == Location.flipped) {
        unit = state.unitFlipUnit(unit);
      }
      if (!unit.isType(PieceType.banner) && state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidateDemoteUnits(GameState state) {
    final candidates = <Piece>[];
    for (var unit in units) {
      if (state.pieceLocation(unit) == Location.flipped) {
        unit = state.unitFlipUnit(unit);
      }
      if (state.unitInPlay(unit) && state.unitDemotable(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidateDemoteCivilWarUnits(GameState state) {
    final candidates = <Piece>[];
    for (var unit in units) {
      if (state.pieceLocation(unit) == Location.flipped) {
        unit = state.unitFlipUnit(unit);
      }
      if (state.unitInPlay(unit) && state.unitDemotable(unit)) {
        candidates.add(unit);
      }
    }
    for (var unit in rebelUnits) {
      if (state.pieceLocation(unit) == Location.flipped) {
        unit = state.unitFlipUnit(unit);
      }
      if (state.unitInPlay(unit) && state.unitDemotable(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidatePromoteUnits(GameState state) {
    final candidates = <Piece>[];
    for (var unit in units) {
      if (state.pieceLocation(unit) == Location.flipped) {
        unit = state.unitFlipUnit(unit);
      }
      if (state.unitInPlay(unit) && state.unitPromotable(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidatePromoteAnyUnits(GameState state) {
    final candidates = <Piece>[];
    for (var unit in units) {
      if (state.pieceLocation(unit) == Location.flipped) {
        unit = state.unitFlipUnit(unit);
      }
      if (state.unitInPlay(unit) && state.unitPromotable(unit)) {
        candidates.add(unit);
      }
    }
    for (var unit in rebelUnits) {
      if (state.pieceLocation(unit) == Location.flipped) {
        unit = state.unitFlipUnit(unit);
      }
      if (state.unitInPlay(unit) && state.unitPromotable(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> candidatePromoteRebelUnits(GameState state) {
    final candidates = <Piece>[];
    for (var unit in rebelUnits) {
      if (state.pieceLocation(unit) == Location.flipped) {
        unit = state.unitFlipUnit(unit);
      }
      if (state.unitInPlay(unit) && state.unitPromotable(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Location> candidateRevoltProvinces(GameState state) {
    final candidates = <Location>[];
    if (war!.isType(PieceType.nativeWar)) {
      final spaces = state.spaceAndConnectedSpaces(province!);
      for (final space in spaces) {
        if (space.isType(LocationType.province) && state.spaceVassalOrBetter(space)) {
          if (space == province! || state.piecesInLocationCount(PieceType.war, space) == 0) {
            candidates.add(space);
          }
        }
      }
    }
    return candidates;
  }

  List<Location> candidateCedeProvinces(GameState state) {
    final candidates = <Location>[];
    if (war!.isType(PieceType.foreignWar)) {
      final spaces = state.spaceAndConnectedSpaces(province!);
      for (final space in spaces) {
        if (space.isType(LocationType.province) && state.spaceVassalOrBetter(space)) {
          if (space != province! || state.piecesInLocationCount(PieceType.war, space) == 0) {
            candidates.add(space);
          }
        }
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

class NewRulerState {
  int subStep = 0;
  List<Location> rulerVacancies = [];
  int vacancyIndex = 0;

  NewRulerState();

  NewRulerState.fromJson(Map<String, dynamic> json) {
    subStep = json['subStep'] as int;
    rulerVacancies = locationListFromIndices(List<int>.from(json['rulerVacancies']));
    vacancyIndex = json['vacancyIndex'] as int;
  }

  Map<String, dynamic> toJson() => {
    'subStep': subStep,
    'rulerVacancies': locationListToIndices(rulerVacancies),
    'vacancyIndex': vacancyIndex,
  };
}

class TakeLossesState {
  int remainingCount;
  int cedeCount = 0;
  int demoteCount = 0;
  int disgraceCount = 0;
  int dishonorCount = 0;
  int dismissCount = 0;
  int revoltCount = 0;
  int tributeCount = 0;

  TakeLossesState(this.remainingCount);

  TakeLossesState.fromJson(Map<String, dynamic> json)
    : remainingCount = json['remainingCount'] as int
    , cedeCount = json['cedeCount'] as int
    , demoteCount = json['demoteCount'] as int
    , disgraceCount = json['disgraceCount'] as int
    , dishonorCount = json['dishonorCount'] as int
    , dismissCount = json['dismissCount'] as int
    , revoltCount = json['revoltCount'] as int
    , tributeCount = json['tributeCount'] as int
    ;

  Map<String, dynamic> toJson() => {
    'remainingCount': remainingCount,
    'cedeCount': cedeCount,
    'demoteCount': demoteCount,
    'disgraceCount': disgraceCount,
    'dishonorCount': dishonorCount,
    'dismissCount': dismissCount,
    'revoltCount': revoltCount,
    'tributeCount': tributeCount,
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
  NewRulerState? _newRulerState;
  TakeLossesState? _takeLossesState;
  final Random _random;
  final int _gameId;

  Game(this._gameId, this._scenario, this._options, this._state, this._random)
  : _choiceInfo = PlayerChoiceInfo()
  {
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
    case Scenario.from1644CeTo1735Ce:
      _firstTurn = 0;
		  _turnCount = 10;
		  _startYear = 1644;
		  _endYear = 1735;
	  case Scenario.from1735CeTo1820Ce:
      _firstTurn = 10;
		  _turnCount = 10;
		  _startYear = 1735;
		  _endYear = 1820;
	  case Scenario.from1820CeTo1889Ce:
		  _firstTurn = 20;
		  _turnCount = 10;
		  _startYear = 1820;
		  _endYear = 1889;
	  case Scenario.from1889CeTo1949Ce:
		  _firstTurn = 30;
		  _turnCount = 10;
		  _startYear = 1889;
		  _endYear = 1949;
  	case Scenario.from1644CeTo1820Ce:
		  _firstTurn = 0;
		  _turnCount = 20;
		  _startYear = 1644;
		  _endYear = 1820;
	  case Scenario.from1735CeTo1889Ce:
		  _firstTurn = 10;
		  _turnCount = 20;
		  _startYear = 1735;
		  _endYear = 1889;
  	case Scenario.from1820CeTo1949Ce:
		  _firstTurn = 20;
  		_turnCount = 20;
	  	_startYear = 1820;
		  _endYear = 1949;
	  case Scenario.from1644CeTo1889Ce:
      _firstTurn = 0;
      _turnCount = 30;
      _startYear = 1644;
      _endYear = 1889;
  	case Scenario.from1735CeTo1949Ce:
		  _firstTurn = 10;
      _turnCount = 30;
      _startYear = 1735;
      _endYear = 1949;
	  case Scenario.from1644CeTo1949Ce:
		  _firstTurn = 0;
      _turnCount = 40;
      _startYear = 1644;
      _endYear = 1949;
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
    final newRulerStateJson = json['newRuler'];
    if (newRulerStateJson != null) {
      _newRulerState = NewRulerState.fromJson(newRulerStateJson);
    }
    final takeLossesJson = json['takeLosses'];
    if (takeLossesJson != null) {
      _takeLossesState = TakeLossesState.fromJson(takeLossesJson);
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
    if (_newRulerState != null) {
      map['newRuler'] = _newRulerState!.toJson();
    }
    if (_takeLossesState != null) {
      map['takeLossesState'] = _takeLossesState!.toJson();
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

  int rollD2() {
    int die = _random.nextInt(2) + 1;
    return die;
  }

  void logD2InTable(int die) {
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

  Location randGovernorship() {
    final governorships = _state.activeGovernorships;
    return randLocation(governorships)!;
  }

  void setProvinceStatus(Location province, ProvinceStatus status) {
    _state.setProvinceStatus(province, status);
    logLine('>${province.desc} to ${status.desc}.');
  }

  void provinceIncreaseStatus(Location province) {
    switch (_state.provinceStatus(province)) {
    case ProvinceStatus.barbarian:
    case ProvinceStatus.foreignAmerican:
    case ProvinceStatus.foreignBritish:
    case ProvinceStatus.foreignDutch:
    case ProvinceStatus.foreignFrench:
    case ProvinceStatus.foreignGerman:
    case ProvinceStatus.foreignJapanese:
    case ProvinceStatus.foreignPortuguese:
    case ProvinceStatus.foreignRussian:
    case ProvinceStatus.foreignSpanish:
      setProvinceStatus(province, ProvinceStatus.vassal);
    case ProvinceStatus.vassal:
      setProvinceStatus(province, ProvinceStatus.insurgent);
    case ProvinceStatus.insurgent:
      setProvinceStatus(province, ProvinceStatus.chinese);
    case ProvinceStatus.chinese:
    }
  }

  void provinceDecreaseStatus(Location province) {
    switch (_state.provinceStatus(province)) {
    case ProvinceStatus.chinese:
      setProvinceStatus(province, ProvinceStatus.insurgent);
    case ProvinceStatus.insurgent:
      setProvinceStatus(province, ProvinceStatus.vassal);
    case ProvinceStatus.vassal:
    case ProvinceStatus.foreignAmerican:
    case ProvinceStatus.foreignBritish:
    case ProvinceStatus.foreignDutch:
    case ProvinceStatus.foreignFrench:
    case ProvinceStatus.foreignGerman:
    case ProvinceStatus.foreignJapanese:
    case ProvinceStatus.foreignPortuguese:
    case ProvinceStatus.foreignRussian:
    case ProvinceStatus.foreignSpanish:
      setProvinceStatus(province, ProvinceStatus.barbarian);
    case ProvinceStatus.barbarian:
    }
  }

  void adjustCash(int amount) {
    _state.adjustCash(amount);
    if (amount > 0) {
      logLine('>Cash: +$amount → ${_state.cash}');
    } else if (amount < 0) {
      logLine('>Cash: $amount → ${_state.cash}');
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

  String yearDesc(int turn) {
    double t = (turn - _firstTurn) / _turnCount;
    double yearDouble = (1 - t) * _startYear + t * _endYear;
	  int year = yearDouble.round();
    return '$year';
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
        if (location.isType(LocationType.space)) {
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
      final space = _state.pieceLocation(war);
      logLine('>${leader.desc} leads ${war.desc} in ${space.desc}.');
      _state.setPieceLocation(leader, space);
      if (statesman != null) {
        final location = _state.pieceLocation(statesman);
        _state.setPieceLocation(statesman, Location.offmap);
        if (location.isType(LocationType.governorship)) {
          governorshipBecomesLoyalToRuler(location);
        }
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
        final entryArea = randLocation(_state.enemyEntryAreas(enemy))!;
        if (location != entryArea) {
          logLine('>${leader.desc} returns to ${entryArea.desc}.');
          _state.setPieceLocation(leader, entryArea);
        }
      } else {
        final statesman = _state.leaderStatesman(leader);
        logLine('>${statesman.desc} heads into Exile.');
        _state.setPieceLocation(statesman, Location.boxExile);
        _state.setPieceLocation(leader, Location.offmap);
      }
    }
  }

  void setWarOffmap(Piece war) {
    final enemy = _state.warEnemy(war);
    _state.setBarbarianOffmap(war);
    redistributeEnemyLeaders(enemy);
  }

  void checkDefeat() {
    GameResultCause? cause;
    if (_state.cash < 0) {
      cause = GameResultCause.bankrupt;
    } else if (_state.unrest > 25) {
      cause = GameResultCause.unrest;
    } else {
      if (_state.rulingCommand == Location.commandEmperor) {
        final capital = Location.provinceBeijing;
        if (!_state.spaceInsurgentOrBetter(capital)) {
          cause = GameResultCause.lostCapital;
        }
      }
    }
    if (cause == null) {
      return;
    }
    String desc = '';
    if (_state.rulingCommand == Location.commandEmperor) {
      logLine('### Qing Dynasty Falls');
      desc = 'Empire';
    } else {
      logLine('### Republic Falls');
      desc = 'Republic';
    }
    switch (cause) {
    case GameResultCause.bankrupt:
      logLine('>$desc is bankrupt.');
    case GameResultCause.unrest:
      logLine('>$desc succumbs to widespread unrest.');
    case GameResultCause.lostCapital:
      logLine('>Beijing is lost.');
    default:
    }
    if (_state.rulingCommand == Location.commandEmperor) {
      bool exile = false;
      final statesman = _state.pieceInLocation(PieceType.statesman, Location.commandEmperor);
      if (statesman != null && _state.statesmanAbility(statesman) == Ability.exile) {
        logLine('>Exile roll');
        exile = rollD6() >= 4;
      }
      if (exile) {
        logLine('${_state.commanderName(Location.commandEmperor)} is forced into Exile.');
        rulerIsExiled(Location.commandEmperor);
      } else {
        logLine('${_state.commandName(Location.commandEmperor)} abdicates.');
        rulerDies(Location.commandEmperor);
      }
      for (final command in LocationType.governorship.locations) {
        if (_state.commandLoyal(command)) {
          _state.governorRebels(command);
          if (_state.pieceInLocation(PieceType.statesman, command) == null) {
            _state.setCommanderAge(command, 3);
          }
        }
      }
      logLine('>Chinese Republic is formed.');
      if (_state.cash < 0) {
        _state.setCash(0);
      }
      _state.setPrestige(0);
      _state.setUnrest(0);
      _state.qingDynastyFalls();
    } else {
      throw GameOverException(GameResult.majorDefeat, cause, _state.prestige);
    }
  }

  void checkVictory() {
    int prestige = _state.prestige;
    GameResult? result;
    if (prestige >= 200) {
      result = GameResult.majorVictory;
    } else if (prestige >= 150) {
      result = GameResult.minorVictory;
    } else if (prestige >= 100) {
      result = GameResult.draw;
    } else {
      result = GameResult.minorDefeat;
    }
    throw GameOverException(result, GameResultCause.endured, prestige);
  }

  void gameOver(GameOutcome outcome) {
    _outcome = outcome;

    logLine('# Game Over');

    GameResult result = outcome.result;
    GameResultCause cause = outcome.cause;
    int prestige = outcome.prestige;

    switch (result) {
    case GameResult.majorDefeat:
      logLine('### Defeat');
      switch (cause) {
      case GameResultCause.bankrupt:
        logLine('>The Empire is bankrupt.');
      case GameResultCause.unrest:
        logLine('>Revolution breaks out across the Empire');
      case GameResultCause.lostCapital:
        logLine('>${Location.provinceBeijing.desc} falls.');
      case GameResultCause.endured:
      }
    case GameResult.minorDefeat:
      logLine('### Minor Defeat');
      logLine('>The Empire endures, with $prestige Prestige.');
    case GameResult.draw:
      logLine('### Draw');
      logLine('>The Empire is stable, with $prestige Prestige.');
    case GameResult.minorVictory:
      logLine('### Minor Victory');
      logLine('>The Empire prospers, with $prestige Prestige.');
    case GameResult.majorVictory:
      logLine('### Major Victory');
      logLine('>The Empire dominates its enemies, with $prestige Prestige.');
    }
  }

  void makeRebellionCheckForCommand(Location command) {
    logLine('### ${_state.commanderName(command)} considers Rebellion');

    final ruler = _state.rulingCommand;

    final rolls = roll3D6();
    int omens = rolls.$4;
    int total = rolls.$5;
    int modifiers = 0;
    int modifier = 0;

    logTableHeader();
    log3D6InTable(rolls);
    int commanderReform = _state.commandReform(command);
    int rulerReform = _state.commandReform(ruler);
    if (commanderReform >= rulerReform) {
      modifier = commanderReform;
      logLine('>|${_state.commanderName(command)} Reform|+$modifier|');
      modifiers += modifier;
      modifier = -rulerReform;
      logLine('>|${_state.commanderName(ruler)} Reform|$modifier|');
      modifiers += modifier;
    } else {
      modifier = rulerReform;
      logLine('>|${_state.commanderName(ruler)} Reform|+$modifier|');
      modifiers += modifier;
      modifier = -commanderReform;
      logLine('>|${_state.commanderName(command)} Reform|$modifier|');
      modifiers += modifier;
    }
    final governorStatesman = _state.pieceInLocation(PieceType.statesman, command);
    if (governorStatesman != null) {
      const intrigueAbilities = [
        Ability.leaderBoxer,
        Ability.leaderCommunist,
        Ability.leaderHui,
        Ability.leaderTaiping,
        Ability.leaderWhiteLotus,
        Ability.leaderWokou,
        Ability.rebel,
      ];
      if (intrigueAbilities.contains(_state.statesmanAbility(governorStatesman))) {
        modifier = _state.commandIntrigue(command);
        logLine('>|${_state.commanderName(command)} Intrigue|$modifier|');
        modifiers += modifier;
      }
    }
    modifier = _state.unrest;
    if (modifier != 0) {
      logLine('>|Unrest|+$modifier|');
      modifiers += modifier;
    }
    int unitsModifier = 0;
    int veteransModifier = 0;
    if (_state.treatyActive(Piece.treatyXinchou)) {
      unitsModifier = _state.rebellionUnitsControlledByCommandCount(command);
      modifier = unitsModifier;
      if (modifier != 0) {
        logLine('>|Units|+$modifier|');
        modifiers += modifier;
      }
    } else {
      veteransModifier = _state.rebellionVeteransControlledByCommandCount(command);
      modifier = veteransModifier;
      if (modifier != 0) {
        logLine('>|Veteran Units|+$modifier|');
        modifiers += modifier;
      }
    }
    int result = total + modifiers;
    logLine('>|Total|$result|');
    logTableFooter();

    if (result >= 25) {
      if (result - omens < 25) {
        logLine('>${_state.commanderName(command)} Rebels, in accordance with the Omens.');
      } else if (result - unitsModifier < 25) {
        logLine('>Army supports ${_state.commanderName(command)} in Rebellion.');
      } else if (result - veteransModifier < 25) {
        logLine('>Veterans support ${_state.commanderName(command)} in Rebellion.');
      } else {
        logLine('>${_state.commanderName(command)} Rebels.');
      }
      _state.governorRebels(command);
      if (_state.pieceInLocation(PieceType.statesman, command) == null) {
        if (_state.commanderAge(command) == null) {
          _state.setCommanderAge(command, 3);
        }
      }
    } else {
      if (result - omens >= 25) {
        logLine('>${_state.commanderName(command)} remains Loyal, in accordance with the Omens.');
      } else {
        logLine('>${_state.commanderName(command)} remains Loyal.');
      }
    }
  }

  void governorshipBecomesLoyalToRuler(Location governorship) {
    _state.setCommandLoyalty(governorship, true);
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
    governorshipBecomesLoyalToRuler(governorship);
  }

  void governorIsExiled(Location governorship) {
    for (final war in PieceType.war.pieces) {
      if (_state.pieceLocation(war) == governorship) {
        _state.setBarbarianOffmap(war);
      }
    }
    final statesman = _state.pieceInLocation(PieceType.statesman, governorship)!;
    _state.setPieceLocation(statesman, Location.boxExile);
    governorshipBecomesLoyalToRuler(governorship);
  }

  void rulerDies(Location ruler) {
    final statesman = _state.commandCommander(ruler);
    if (statesman != null) {
      _state.setPieceLocation(statesman, Location.offmap);
    }
    _state.setCommanderAge(ruler, null);
  }

  void rulerIsExiled(Location ruler) {
    final statesman = _state.commandCommander(ruler)!;
    _state.setPieceLocation(statesman, Location.boxExile);
  }

  void governorBecomesRuler(Location governorship, Location ruler) {
    for (final war in PieceType.war.pieces) {
      if (_state.pieceLocation(war) == governorship) {
        _state.setBarbarianOffmap(war);
      }
    }
    final statesman = _state.pieceInLocation(PieceType.statesman, governorship);
    int? governorAge = _state.commanderAge(governorship);
    governorshipBecomesLoyalToRuler(governorship);
    _state.setCommanderAge(governorship, null);
    if (statesman != null) {
      _state.setPieceLocation(statesman, ruler);
      _state.setCommanderAge(ruler, null);
    } else {
      if (governorAge != null) {
        _state.setCommanderAge(ruler, governorAge);
      } else {
        _state.setCommanderAge(ruler, 3);
      }
    }
  }

  void statesmanBecomesRuler(Piece statesman, Location ruler) {
    _state.setPieceLocation(statesman, ruler);
    _state.setCommanderAge(ruler, null);
  }

  void genericBecomesRuler(Location ruler) {
    _state.setCommanderAge(ruler, 3);
  }

  void unitDismiss(Piece unit) {
    final province = _state.pieceLocation(unit);
    logLine('>$unit.desc} in ${province.desc} is Dismissed.');
    _state.setPieceLocation(unit, Location.boxBarracks);
  }

  void unitDemote(Piece unit) {
    final province = _state.pieceLocation(unit);
    if (unit.isType(PieceType.fort)) {
      logLine('>${unit.desc} in ${province.desc} is Demoted to Militia.');
    } else {
      logLine('>${unit.desc} in ${province.desc} is Demoted.');
    }
    _state.flipUnit(unit);
  }

  void unitPromote(Piece unit) {
    final province = _state.pieceLocation(unit);
    if (unit.isType(PieceType.militia)) {
      logLine('>${unit.desc} in ${province.desc} is Promoted to Fort.');
    } else {
      logLine('>${unit.desc} in ${province.desc} is Promoted to Veteran.');
    }
    _state.flipUnit(unit);
  }

  void annexProvince(Location province) {
    logLine('>${province.desc} is Annexed.');
    provinceIncreaseStatus(province);
    adjustPrestige(1);
  }

  void annexProvinceToForeignEnemy(Location province, Enemy foreignEnemy) {
    logLine('>${province.desc} is Annexed by the ${foreignEnemy.desc}.');
    _state.setProvinceStatus(province, foreignEnemy.foreignStatus!);
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
					logLine('>${_state.eventTypeName(eventType)} already doubled');
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

    bool hasSavingRoll = _options.finiteLifetimes && age != null && age <= 3;
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
      if (age > 4) {
        int modifier = age - 4;
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
      if (_state.provinceStatus(province) == ProvinceStatus.chinese) {
        total += _state.provinceRevenue(province);
      }
    }
    if (total == 0) {
      return 0;
    }

    final name = _state.commandName(command);
    logLine('>');
    logLine('>$name');

    final rolls = roll2D6();
    int rollTotal = rolls.$4;
    int modifiers = 0;
    int modifier = 0;

    logTableHeader();
    log2D6InTable(rolls);
    final ruler = _state.rulingCommand;
    modifier = -_state.commandAdministration(ruler);
    logLine('>|${_state.commanderName(ruler)} Administration|$modifier|');
    modifiers += modifier;
    modifier = -_state.commandAdministration(command);
    logLine('>|${_state.commanderName(command)} Administration|$modifier|');
    modifiers += modifier;
    if (_state.treatyActive(Piece.treatyNanjing)) {
      logLine('>|${Piece.treatyNanjing.desc}|+1|');
      modifiers += 1;
    }
    if (_state.treatyActive(Piece.treatyMaguan)) {
      logLine('>|${Piece.treatyMaguan.desc}|+1|');
      modifiers += 1;
    }
    if (_state.eventTypeCount(EventType.inflation) > 0) {
      modifier = _state.eventTypeCount(EventType.inflation);
      logLine('>|Inflation|+$modifier|');
      modifiers += modifier;
    }
    modifier = _options.taxRollModifier;
    if (modifier != 0) {
      if (modifier == 1) {
        logLine('>|Lower Tax Option|+1|');
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
    int amount = 0;
    for (final command in LocationType.governorship.locations) {
      amount += taxCommand(command);
    }
    logLine('>');
    adjustCash(amount);
  }

  void pay() {
    adjustCash(-_state.pay);
  }

  int moveWarPriority(Piece war, Location? displaceSpace, Location connectedSpace, ConnectionType connectionType) {
    bool spaceNonMatchingForeignOrBetter = _state.spaceNonMatchingForeignOrBetter(connectedSpace, war);
    bool landLike = connectionType == ConnectionType.land;
    bool seaLike = connectionType == ConnectionType.sea;
    int navalStrength = _state.warRawNavalStrength(war);
    if (seaLike) {
      if (navalStrength > 0) {
        seaLike = false;
        landLike = true;
      }
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
    if (spaceNonMatchingForeignOrBetter) {
      priority += 1;
    }
    priority *= 16;
    if (!spaceNonMatchingForeignOrBetter) {
      priority += max(15 - _state.spaceNonMatchingForeignOrBetterDistance(connectedSpace, war), 0);
    }
    priority *= 4;
    if (landLike) {
      priority += 2;
    } else if (!seaLike) {
      priority += 1;
    }

    // Bits
    // 0x001 river/straits
    // 0x002 land for cavalry, or sea for naval
    // 0x03C non-matching foreign or better distance
    // 0x040 non-matching foreign or better
    // 0x080 not visited
    // 0x100 not displaced
    // 0xE00 revisit count

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
    final die = rollD6();
    int modifiers = 0;
    int modifier = 0;

    logTableHeader();
    logD6InTable(die);
    if (leader != null) {
      modifier = _state.leaderPillage(leader);
      logLine('>|${leader.desc}|+$modifier|');
      modifiers += modifier;
    }
    modifier = _state.warCurrentNavalStrength(war);
    if (modifier > 0) {
      logLine('>|Naval|+$modifier|');
      modifiers += modifier;
    }
    modifier = _state.warCavalryStrength(war);
    if (modifier > 0) {
      logLine('>|Cavalry|+$modifier|');
      modifiers += modifier;
    }
    modifier = _state.eventTypeCount(EventType.pillage);
    if (modifier > 0) {
      logLine('>|Pillage|+$modifier|');
      modifiers += modifier;
    }
    modifier = 0;
    switch (_state.provinceStatus(province)) {
    case ProvinceStatus.insurgent:
      modifier = 1;
      logLine('>|Insurgent|+1|');
    case ProvinceStatus.vassal:
      modifier = -1;
      logLine('>|Vassal|-1|');
    case ProvinceStatus.foreignAmerican:
    case ProvinceStatus.foreignBritish:
    case ProvinceStatus.foreignDutch:
    case ProvinceStatus.foreignFrench:
    case ProvinceStatus.foreignGerman:
    case ProvinceStatus.foreignJapanese:
    case ProvinceStatus.foreignPortuguese:
    case ProvinceStatus.foreignRussian:
    case ProvinceStatus.foreignSpanish:
      modifier = -2;
      logLine('>|Foreign|-2|');
    default:
    }
    modifiers += modifier;
    modifier = -_state.pillageDeterrentLandUnitsInSpaceCount(province);
    if (modifier != 0) {
      logLine('>|Units|$modifier|');
      modifiers += modifier;
    }
    int result = die + modifiers;
    logLine('>|Total|$result|');
    logTableFooter();

    return result >= 6;
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
    logLine('>$piecesDesc $verb ${pathDesc}to ${path[path.length - 1].desc}.');
    for (final province in annexations) {
      annexProvinceToForeignEnemy(province, enemy);
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
    final foreignStatus = enemy.foreignStatus;
    final phaseState = _phaseState as PhaseStateTreasury;
    if (displaceSpace == null) {
      phaseState.setWarUnmoved(war, false);
    }
    int pillageRollCount = displaceSpace != null ? 1 : 0;
    final originSpace = _state.pieceLocation(war);
    final warTrail = phaseState.warTrail(war);
    warTrail.add(originSpace);
    if (displaceSpace == null && _state.spaceNonMatchingForeignOrBetter(originSpace, war)) {
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
        if (nextSpace.isType(LocationType.province) && foreignStatus != null && _state.provinceStatus(nextSpace) == ProvinceStatus.barbarian) {
          _state.setProvinceStatus(nextSpace, foreignStatus);
          logAnnexations.add(nextSpace);
        }
        if (_state.spaceNonMatchingForeignOrBetter(nextSpace, war)) {
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
              logLine('>${war.desc} halts in ${nextSpace.desc}.');
              terminate = true;
            }
          }
        }
      }
    }
    logWarMove(enemy, pieceNames, verb, logPath, logAnnexations);
  }

  void treatyAdded(Piece treaty) {
    switch (treaty) {
    case Piece.treatyNerchinsk:
      logLine('>Emperors may not fight Wars.');
    case Piece.treatyKyakhta:
      logLine('>Annex one less Province.');
    case Piece.treatyNanjing:
      logLine('>+1 to each Tax roll.');
    case Piece.treatyTianjin:
      logLine('>Annex one less Province.');
    case Piece.treatyMaguan:
      logLine('>+1 to each Tax roll.');
    case Piece.treatyXinchou:
      logLine('>Increase Rebellion roll for Ordinary units.');
    default:
    }
  }

  void appointStatesmanToCommand(Piece statesman, Location command) {
    logLine('>${statesman.desc} is Appointed as ${_state.commanderPositionName(command, false)}.');
    final previousCommander = _state.commandCommander(command);
    if (previousCommander != null) {
      _state.setPieceLocation(previousCommander, Location.boxStatesmen);
    }
    _state.setPieceLocation(statesman, command);
  }

  int calculateProvinceRevoltModifier(Location province, bool ignoreMobileUnits, bool log) {
    final leader = _state.pieceInLocation(PieceType.leader, province);
    final war = _state.pieceInLocation(PieceType.war, province);
    final hasGreatWall = _state.provinceHasGreatWall(province);
    final hasBanner = _state.piecesInLocationCount(PieceType.banner, province) > 0;
    final hasFleet = _state.piecesInLocationCount(PieceType.fleet, province) > 0;
    final status = _state.provinceStatus(province);
    final command = _state.provinceCommand(province);
    final foreignEnemy = status.foreignEnemy;

    int modifiers = 0;
    int modifier = 0;

    if (_state.provinceMayFlood(province)) {
      modifier = _state.eventTypeCount(EventType.flood);
      if (modifier > 0) {
        if (log) {
          logLine('>|Flood|+$modifier|');
        }
        modifiers += modifier;
      }
    }
    if ([Location.commandWestChina, Location.commandXinjiang].contains(command)) {
      modifier = _state.eventTypeCount(EventType.muslims);
      if (modifier > 0) {
        if (log) {
          logLine('>|Muslims|+$modifier|');
        }
        modifiers += modifier;
      }
    }
    if ([Location.commandTibet, Location.commandSouth].contains(command)) {
      modifier = _state.eventTypeCount(EventType.buddhists);
      if (modifier > 0) {
        if (log) {
          logLine('>|Buddhists|+$modifier|');
        }
        modifiers += modifier;
      }
    }
 
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

    for (final connection in _state.spaceConnections(province)) {
      final connectedSpace = connection.$1;
      final connectionType = connection.$2;
      bool mitigated = false;
      switch (status) {
      case ProvinceStatus.foreignAmerican:
      case ProvinceStatus.foreignBritish:
      case ProvinceStatus.foreignDutch:
      case ProvinceStatus.foreignFrench:
      case ProvinceStatus.foreignGerman:
      case ProvinceStatus.foreignJapanese:
      case ProvinceStatus.foreignPortuguese:
      case ProvinceStatus.foreignRussian:
      case ProvinceStatus.foreignSpanish:
      case ProvinceStatus.vassal:
        mitigated = true;
      default:
      }
      bool negated = false;
      switch (connectionType) {
      case ConnectionType.land:
        if (connectedSpace.isType(LocationType.province) && !ignoreMobileUnits && hasGreatWall && hasBanner) {
          final connectedCommand = _state.provinceCommand(connectedSpace);
          if ([Location.commandManchuria, Location.commandMongolia].contains(connectedCommand)) {
            mitigated = true;
          }
        }
      case ConnectionType.river:
      case ConnectionType.sea:
        if (!ignoreMobileUnits && hasFleet) {
          mitigated = true;
        }
      }
      if (!negated) {
        if (_state.spaceBarbarianOrNonMatchingEntryArea(connectedSpace, foreignEnemy)) {
          modifier = 2;
          if (mitigated) {
            modifier -= 1;
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
          if (connectionType == ConnectionType.land) {
            modifier = _state.warCavalryStrength(connectedWar) > 0 ? 2 : 1;
          } else if (connectionType == ConnectionType.river) {
            modifier = _state.warCurrentNavalStrength(connectedWar) > 0 ? 2 : 1;
          }
          if (modifier != 0) {
            if (log) {
              logLine('>|${connectedWar.desc}|+$modifier|');
            }
            modifiers += modifier;
          }
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

    if (!ignoreMobileUnits) {
      modifier = 0;
      modifier -= _state.piecesInLocationCount(PieceType.guard, province);
      modifier -= _state.piecesInLocationCount(PieceType.banner, province);
      modifier -= _state.piecesInLocationCount(PieceType.militia, province);
      modifier -= 2 * _state.piecesInLocationCount(PieceType.fort, province);
      if (modifier != 0) {
        if (log) {
          logLine('>|Units|$modifier|');
        }
        modifiers += modifier;
      }
    }

    switch (status) {
    case ProvinceStatus.vassal:
      modifier = -1;
      if (log) {
        logLine('>|Vassal|-1|');
      }
      modifiers += modifier;
      case ProvinceStatus.foreignAmerican:
      case ProvinceStatus.foreignBritish:
      case ProvinceStatus.foreignDutch:
      case ProvinceStatus.foreignFrench:
      case ProvinceStatus.foreignGerman:
      case ProvinceStatus.foreignJapanese:
      case ProvinceStatus.foreignPortuguese:
      case ProvinceStatus.foreignRussian:
      case ProvinceStatus.foreignSpanish:
      modifier = -2;
      if (log) {
        logLine('>|Foreign|-2|');
      }
      modifiers += modifier;
    default:
    }

    return modifiers;
  }

  int provinceRevoltCheck(Location province) {
    final status = _state.provinceStatus(province);
    final war = _state.pieceInLocation(PieceType.war, province);
    if (war != null && status.foreignEnemy == _state.warEnemy(war)) {
      return 0;
    }
    int modifiers = calculateProvinceRevoltModifier(province, false, false);
    if ((status != ProvinceStatus.insurgent || war != null) && modifiers <= 0) {
      return 0;
    }
    logLine('### Revolt Check for ${province.desc}');
    int die = rollD6();

    logTableHeader();
    logD6InTable(die);
    modifiers = calculateProvinceRevoltModifier(province, false, true);
    int result = die + modifiers;
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

  List<ProvinceStatus> provinceRevoltStatusCandidates(Location province) {
    final candidates = <ProvinceStatus>[];
    {
      final war = _state.pieceInLocation(PieceType.war, province);
      if (war != null) {
        final enemy = _state.warEnemy(war);
        if (enemy.foreignStatus != null) {
          candidates.add(enemy.foreignStatus!);
        }
      }
    }
    if (candidates.isEmpty) {
      for (final connection in _state.spaceConnections(province)) {
        if (connection.$2 != ConnectionType.sea) {
          final war = _state.pieceInLocation(PieceType.war, connection.$1);
          if (war != null) {
            final enemy = _state.warEnemy(war);
            if (enemy.foreignStatus != null && !candidates.contains(enemy.foreignStatus)) {
              candidates.add(enemy.foreignStatus!);
            }
          }
        }
      }
    }
    if (candidates.isEmpty) {
      switch (_state.provinceStatus(province)) {
      case ProvinceStatus.foreignAmerican:
      case ProvinceStatus.foreignBritish:
      case ProvinceStatus.foreignDutch:
      case ProvinceStatus.foreignFrench:
      case ProvinceStatus.foreignGerman:
      case ProvinceStatus.foreignJapanese:
      case ProvinceStatus.foreignPortuguese:
      case ProvinceStatus.foreignRussian:
      case ProvinceStatus.foreignSpanish:
      case ProvinceStatus.vassal:
        candidates.add(ProvinceStatus.barbarian);
      case ProvinceStatus.insurgent:
        candidates.add(ProvinceStatus.vassal);
      case ProvinceStatus.chinese:
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

  bool canProvinceContributeToWar(Location province, Piece war) {
    final status = _state.provinceStatus(province);
    switch (status) {
    case ProvinceStatus.foreignAmerican:
    case ProvinceStatus.foreignBritish:
    case ProvinceStatus.foreignDutch:
    case ProvinceStatus.foreignFrench:
    case ProvinceStatus.foreignGerman:
    case ProvinceStatus.foreignJapanese:
    case ProvinceStatus.foreignPortuguese:
    case ProvinceStatus.foreignRussian:
    case ProvinceStatus.foreignSpanish:
      final enemy = _state.warEnemy(war);
      return status.foreignEnemy != enemy;
    case ProvinceStatus.vassal:
      return true;
    case ProvinceStatus.insurgent:
    case ProvinceStatus.chinese:
      return _state.provinceViableWarUnits(province).isNotEmpty;
    case ProvinceStatus.barbarian:
      return false;
    }
  }

  List<Location> fightWarCommandCandidates(Piece war) {
    PhaseStateWar? phaseState = _phaseState is PhaseStateWar ? _phaseState as PhaseStateWar : null;  // NB could be null if called from game page

    final warProvince = _state.pieceLocation(war);
    final commands = <Location>[];
    for (final space in _state.spaceConnectedSpaces(warProvince)) {
      if (space.isType(LocationType.province)) {
        if (canProvinceContributeToWar(warProvince, war)) {
          var command = _state.provinceCommand(space);
          command = _state.commandAllegiance(command);
          if (!commands.contains(command) &&_state.commandActive(command)) {
            if (phaseState == null || !phaseState.commandsFought.contains(command)) {
              commands.add(command);
              if (_state.commandLoyal(command)) {
                if (!commands.contains(_state.rulingCommand)) {
                  if (phaseState == null || !phaseState.commandsFought.contains(_state.rulingCommand)) {
                    if (_state.rulingCommand == Location.commandPresident || !_state.treatyActive(Piece.treatyNerchinsk)) {
                      commands.add(_state.rulingCommand);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return commands;
  }

  List<Location> fightWarProvinceCandidates(Piece war, Location command) {
    PhaseStateWar? phaseState = _phaseState is PhaseStateWar ? _phaseState as PhaseStateWar : null;  // NB could be null if called from game page

    final warProvince = _state.pieceLocation(war);
    final provinces = <Location>[];
    final spaces = _state.spaceConnectedSpaces(warProvince);
    spaces.add(warProvince);
    for (final space in spaces) {
      if (space.isType(LocationType.province)) {
        if (phaseState == null || !phaseState.provincesFought.contains(space)) {
          if (canProvinceContributeToWar(space, war)) {
            final provinceCommand = _state.provinceCommand(space);
            bool commandOk = false;
            if (command.isType(LocationType.governorship)) {
              commandOk = _state.commandAllegiance(provinceCommand) == command;
            } else {
              commandOk = _state.commandLoyal(provinceCommand);
            }
            if (commandOk) {
              provinces.add(space);
            }
          }
        }
      }
    }
    return provinces;
  }

  (int, bool, bool) calculateFightWarModifier(Piece war, Location warCommand, List<Location> warProvinces, bool log) {
    PhaseStateWar? phaseState = _phaseState is PhaseStateWar ? _phaseState as PhaseStateWar : null;  // NB could be null if called from game page

    final warProvince = _state.pieceLocation(war);
    final leader = _state.pieceInLocation(PieceType.leader, warProvince);
    final enemy = _state.warEnemy(war);
    final warUnits = <Piece>[];
    final warFleets = <Piece>[];
    final general = _state.commandCommander(warCommand);
    for (final unit in PieceType.unit.pieces) {
      final location = _state.pieceLocation(unit);
      if (warProvinces.contains(location) && (phaseState == null || !phaseState.unitsFought.contains(unit))) {
        if (unit.isType(PieceType.fleet)) {
          warFleets.add(unit);
        } else {
          warUnits.add(unit);
        }
      }
    }
    bool matchingWarAbility = general != null && _state.statesmanAbility(general).warEnemy == enemy;

    int modifiers = 0;
    int modifier = 0;
    int nonMatchingForeignProvinceCount = 0;

    modifier = _state.warStrength(war);
    if (log) {
      logLine('>|${war.desc}|+$modifier|');
    }
    modifiers += modifier;
    if (leader != null) {
      modifier = _state.leaderStrength(leader);
      if (log) {
        logLine('>|${leader.desc}|+$modifier|');
      }
      modifiers += modifier;
    }
    if (war.isType(PieceType.nativeWar)) {
      final nativeProvince = _state.enemyEntryAreas(enemy)[0];
      int modifier = 0;
      if (warProvince == nativeProvince) {
        modifier = 2;
      } else if (_state.spacesConnectionType(warProvince, nativeProvince) != null) {
        modifier = 1;
      }
      if (modifier > 0) {
        if (log) {
          logLine('>|Native ${nativeProvince.desc}|+$modifier|');
        }
        modifiers += modifier;
      }
    }
    final spaces = _state.spaceAndConnectedSpaces(warProvince);
    for (final space in spaces) {
      if (space.isType(LocationType.entryArea)) {
        if (_state.enemyEntryAreas(enemy).contains(space)) {
          modifier = 2;
        } else {
          modifier = 1;
        }
        if (log) {
          logLine('>|${space.desc}|+$modifier|');
        }
        modifiers += modifier;
      } else {
        modifier = 0;
        final status = _state.provinceStatus(space);
        switch (status) {
        case ProvinceStatus.barbarian:
          modifier = 1;
        case ProvinceStatus.foreignAmerican:
        case ProvinceStatus.foreignBritish:
        case ProvinceStatus.foreignDutch:
        case ProvinceStatus.foreignFrench:
        case ProvinceStatus.foreignGerman:
        case ProvinceStatus.foreignJapanese:
        case ProvinceStatus.foreignPortuguese:
        case ProvinceStatus.foreignRussian:
        case ProvinceStatus.foreignSpanish:
          if (status.foreignEnemy != enemy) {
            nonMatchingForeignProvinceCount += 1;
            modifier = -2;
          }
        case ProvinceStatus.vassal:
          if (warProvinces.contains(space)) {
            modifier = -1;
          }
        case ProvinceStatus.insurgent:
        case ProvinceStatus.chinese:
        }
        if (modifier > 0) {
          if (log) {
            logLine('>|${space.desc}|+$modifier|');
          }
        } else if (modifier < 0) {
          if (log) {
            logLine('>|${space.desc}|$modifier|');
          }
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
      if (log) {
        logLine('>|Units|$modifier|');
      }
      modifiers += modifier;
    }
    if (matchingWarAbility) {
      modifier = -1;
      logLine('>|${general.desc} Ability|-1|');
      modifiers += modifier;
    }
    modifier = -_state.commandMilitary(warCommand);
    if (log) {
      logLine('>|${_state.commanderName(warCommand)}|$modifier|');
    }
    modifiers += modifier;
    modifier = _options.warRollModifier;
    if (modifier != 0) {
      if (modifier == 1) {
        if (log) {
          logLine('>|Harder Wars Option|+1|');
        }
      } else if (modifier == -1) {
        if (log) {
          logLine('>|Easier Wars Option|-1|');
        }
      }
      modifiers += modifier;
    }

    bool fleetShortage = false;
    if (_state.warCurrentNavalStrength(war) > 0) {
      int fleetStrength = 0;
      for (final fleet in warFleets) {
        if (fleet.isType(PieceType.fleetVeteran)) {
          fleetStrength += 2;
        } else {
          fleetStrength += 1;
        }
      }
      if (fleetStrength + nonMatchingForeignProvinceCount < _state.warCurrentNavalStrength(war)) {
        fleetShortage = true;
      }
    }
    bool cavalryShortage = false;
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
      if (cavalryStrength + nonMatchingForeignProvinceCount < _state.warCavalryStrength(war)) {
        cavalryShortage = true;
      }
    }

    return (modifiers, fleetShortage, cavalryShortage);
  }

  void fightWar(Location warProvince, Location warCommand, List<Location> warProvinces) {
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
    log3D6WithRed(rolls);

    bool matchingWarAbility = false;
    bool stalemateAbility = false;
    bool conquestAbility = false;
    bool veteranAbility = false;
    bool exileAbility = false;
    if (general != null) {
      final ability = _state.statesmanAbility(general);
      switch (ability) {
      case Ability.conquest:
        conquestAbility = true;
      case Ability.exile:
        exileAbility = true;
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
          logLine('>${general!.desc} averts Disaster.');
        } else if (stalemateAbility) {
          disaster = false;
          logLine('>${general!.desc} averts Disaster.');
          stalemate = true;
        }
      } else {
        if (matchingWarAbility) {
          logLine('>${general!.desc} breaks the Stalemate.');
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

      logTableHeader();
      log3D6WithRedInTable(rolls);
      final modifierResults = calculateFightWarModifier(war, warCommand, warProvinces, true);
      int modifiers = modifierResults.$1;
      int result = total + modifiers;
      logLine('>|Total|$result|');
      logTableFooter();

      bool fleetShortage = modifierResults.$2;
      bool cavalryShortage = modifierResults.$3;

      if (result >= 12) {
        if (matchingWarAbility) {
          draw = true;
          logLine('>${general!.desc} narrowly avoids Defeat.');
          logLine('>Campaign against $warDesc results in a Draw.');
        } else if (stalemateAbility) {
          stalemate = true;
          logLine('>${general!.desc} narrowly avoids Defeat.');
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
        if (fleetShortage) {
          draw = true;
          logLine('>Campaign against $warDesc results in a Draw due to a shortage of Fleets.');
        } else if (cavalryShortage) {
          draw = true;
          logLine('>Campaign against $warDesc results in a Draw due to a shortage of Cavalry.');
        } else {
          triumph = true;
          if (result - omens >= 10) {
            logLine('>Campaign against $warDesc end in Triumph, in accordance with the Omens.');
          } else {
            logLine('>Campaign against $warDesc ends in Triumph.');
          }
        }
      }
    }

    int lossCount = d3;
    int promoteCount = 0;
    int annexCount = 0;
    int cash = 0;
    int prestigeUnrest = 0;
    int rebelCash = 0;

    if (stalemate || draw || triumph) {
      promoteCount = veteranAbility ? 2 : 1;
    }

    String lossesDesc = lossCount == 1 ? 'Loss' : 'Losses';
    logLine('>Campaign incurs $lossCount $lossesDesc.');

    if (disaster) {
      bool exile = false;
      if (exileAbility) {
        logLine('>Exile roll');
        int die = rollD6();
        logD6(die);
        exile = die >= 4;
      }
      if (exile) {
        logLine('>${_state.commanderName(warCommand)} is disgraced and goes into Exile.');
        if (warCommand.isType(LocationType.ruler)) {
          rulerIsExiled(warCommand);
        } else {
          governorIsExiled(warCommand);
        }
      } else {
        logLine('>${_state.commanderName(warCommand)} is Killed.');
        if (warCommand.isType(LocationType.ruler)) {
          rulerDies(warCommand);
        } else {
          governorDies(warCommand);
        }
      }
      adjustUnrest(lossCount);
      adjustPrestige(-lossCount);
    }

    if (triumph) {
      if (warCommand.isType(LocationType.governorship)) {
        _state.setPieceLocation(war, warCommand);
      } else {
        _state.setPieceLocation(war, Location.offmap);
      }
      if (leader != null) {
        redistributeEnemyLeaders(enemy);
      }
      cash = _state.warStrength(war) * _state.commandAdministration(warCommand);
      prestigeUnrest = (_state.warStrength(war) + 1) ~/ 2;
      if (_state.commandRebel(warCommand) && warCommand.isType(LocationType.governorship)) {
        rebelCash = cash;
        cash = 0;
        prestigeUnrest = 0;
      }

      annexCount = 1;
      if (conquestAbility || matchingWarAbility) {
        annexCount += 1;
      }
      final ruler = _state.commandCommander(_state.rulingCommand);
      if (ruler != null && _state.statesmanAbility(ruler) == Ability.conquest) {
        annexCount += 1;
      }
    }

    if (disaster && warCommand.isType(LocationType.ruler)) {
      phaseState.deadRuler = warCommand;
    }

    phaseState.triumph = triumph;
    phaseState.lossCount = lossCount;
    phaseState.promoteCount = promoteCount;
    phaseState.annexCount = annexCount;
    phaseState.prestige = prestigeUnrest;
    phaseState.unrest = prestigeUnrest;
    phaseState.cash = cash;
    phaseState.rebelCash = rebelCash;
  }

  void fightRebel(Location rebelCommand) {
    final phaseState = _phaseState as PhaseStateWar;

    final ruler = _state.rulingCommand;

    final rulerStatesman = _state.pieceInLocation(PieceType.statesman, ruler);
    final rebelStatesman = _state.pieceInLocation(PieceType.statesman, rebelCommand);

    bool rulerVeteranAbility = rulerStatesman != null && _state.statesmanAbility(rulerStatesman) == Ability.veteran;
    bool rebelVeteranAbility = rebelStatesman != null && _state.statesmanAbility(rebelStatesman) == Ability.veteran;
    bool rulerExileAbility = rulerStatesman != null && _state.statesmanAbility(rulerStatesman) == Ability.exile;
    bool rebelExileAbility = rebelStatesman != null && _state.statesmanAbility(rebelStatesman) == Ability.exile;
    bool rebelRebelAbility = rebelStatesman != null && _state.statesmanAbility(rebelStatesman) == Ability.rebel;

    int rulerStrength = 0;
    int rebelStrength = 0;

    const unitTypes = [
      PieceType.cavalryOrdinary,
      PieceType.bannerOrdinary,
      PieceType.militia,
      PieceType.fleetOrdinary,
      PieceType.cavalryVeteran,
      PieceType.bannerVeteran,
      PieceType.fleetVeteran
    ];
    for (int i = 0; i < unitTypes.length; ++i) {
      final unitType = unitTypes[i];
      bool veteran = i >= 4;
      for (final unit in unitType.pieces) {
        final unitLocation = _state.pieceLocation(unit);
        if (unitLocation.isType(LocationType.province)) {
          int unitStrength = veteran ? 2 : 1;
          final unitCommand = _state.provinceCommand(unitLocation);
          final unitAllegiance = _state.commandAllegiance(unitCommand);
          bool forRuler = _state.commandLoyal(unitCommand);
          bool forRebel = unitAllegiance == rebelCommand;
          if (forRuler) {
            phaseState.units.add(unit);
            rulerStrength += unitStrength;
          } else if (forRebel) {
            phaseState.rebelUnits.add(unit);
            rebelStrength += unitStrength;
          }
        }
      }
    }

    for (final province in LocationType.province.locations) {
      final status = _state.provinceStatus(province);
      if (status.foreignEnemy != null) {
        final provinceCommand = _state.provinceCommand(province);
        final provinceAllegiance = _state.commandAllegiance(provinceCommand);
        bool forRuler = _state.commandLoyal(provinceCommand);
        bool forRebel = provinceAllegiance == rebelCommand;
        if (forRuler) {
          rulerStrength += 1;
        } else if (forRebel) {
          rebelStrength += 1;
        }
      }
    }

    bool rebelVictory = false;
    bool stalemate = false;
    bool rebelDefeat = false;

    logLine('### ${_state.commanderName(ruler)} vs. ${_state.commanderName(rebelCommand)}');

    final rolls = roll3D6();
    final d3 = rolls.$3;
    final omens = rolls.$4;
    final total = rolls.$5;

    int modifiers = 0;
    int modifier = 0;

    logTableHeader();
    log3D6WithRedInTable(rolls);
    modifier = _state.commandMilitary(rebelCommand);
    logLine('>|${_state.commanderName(rebelCommand)}|+$modifier|');
    modifiers += modifier;
    if (rebelRebelAbility) {
      logLine('>|${_state.commanderName(rebelCommand)} Rebel|+1|');
      modifiers += 1;
    }
    modifier = rebelStrength;
    logLine('>|Rebel Strength|+$modifier|');
    modifiers += modifier;
    modifier = -rulerStrength;
    logLine('>|${ruler.desc} Strength|$modifier|');
    modifiers += modifier;
    modifier = -_state.commandMilitary(ruler);
    logLine('>|${_state.commanderName(ruler)}|$modifier|');
    modifiers += modifier;
    int result = total + modifiers;
    logLine('>|Total|$result|');
    logTableFooter();

    int lossCount = d3;
    int promoteCount = 0;
    int rulerPromoteCount = 0;
    int rebelPromoteCount = 0;

    if (result >= 12) {
      rebelVictory = true;
      if (result - omens < 12) {
        logLine('>${_state.commanderName(rebelCommand)} is victorious, in accordance with the Omens.');
      } else {
        logLine('>${_state.commanderName(rebelCommand)} is victorious.');
      }
    } else if (result >= 10) {
      stalemate = true;
      logLine('>Civil War with ${_state.commanderName(rebelCommand)} is a Stalemate.');
    } else {
      rebelDefeat = true;
      if (result - omens >= 10) {
        logLine('>Civil War ends with ${_state.commanderName(rebelCommand)} being defeated, in accordance with the Omens.');
      } else {
        logLine('>Civil War ends with ${_state.commanderName(rebelCommand)} being defeated.');
      }
    }

    String lossesDesc = lossCount == 1 ? 'Loss' : 'Losses';
    logLine('>Civil War incurs $lossCount $lossesDesc.');

    if (rebelVictory) {
      bool exile = false;
      if (rulerExileAbility) {
        logLine('>Exile roll');
        int die = rollD6();
        logD6(die);
        exile = die >= 4;
      }
      if (exile) {
        logLine('>${_state.commanderName(ruler)} is overthrown and goes into Exile.');
      } else {
        logLine('>${_state.commanderName(ruler)} is overthrown and executed.');
      }
      int prestigeAmount = -_state.commandAdministration(ruler);
      int unrestAmount = _state.commandReform(ruler);
      adjustUnrest(unrestAmount);
      adjustPrestige(prestigeAmount);
      if (exile) {
        rulerIsExiled(ruler);
      } else {
        rulerDies(ruler);
      }
      rebelPromoteCount = rebelVeteranAbility ? 2 : 1;
    }
    if (stalemate) {
      promoteCount = 1;
      rulerPromoteCount = rulerVeteranAbility ? 0 : 1;
      rebelPromoteCount = rebelVeteranAbility ? 0 : 1;
    }
    if (rebelDefeat) {
      int amount = _state.commandIntrigue(rebelCommand);
      bool exile = false;
      if (rebelExileAbility) {
        logLine('>Exile roll');
        int die = rollD6();
        logD6(die);
        exile = die >= 4;
      }
      if (exile) {
        logLine('>Rebellion is defeated and ${_state.commanderName}} goes into Exile.');
      } else {
        logLine('>${_state.commanderName(rebelCommand)} is Killed.');
      }
      if (exile) {
        governorIsExiled(rebelCommand);
      } else {
        governorDies(rebelCommand);
      }
      adjustUnrest(-amount);
      adjustPrestige(amount);
      rulerPromoteCount = rulerVeteranAbility ? 2 : 1;
    }

    if (rebelVictory) {
      phaseState.deadRuler = ruler;
    }

    phaseState.lossCount = lossCount;
    phaseState.promoteCount = rulerPromoteCount;
    phaseState.anyPromoteCount = promoteCount;
    phaseState.rebelPromoteCount = rebelPromoteCount;
  }

  List<Location> get candidateAnnexBarbarianOrVassalProvinces {
    final candidateProvinces = <Location>[];
    for (final province in LocationType.province.locations) {
      final status = _state.provinceStatus(province);
      if ([ProvinceStatus.barbarian, ProvinceStatus.vassal].contains(status)) {
        if (_state.spaceCanBeAnnexed(province)) {
          candidateProvinces.add(province);

        }
      }
    }
    return candidateProvinces;
  }

  List<Location> get candidateAnnexBarbarianOrVassalPortProvinces {
    final candidateProvinces = <Location>[];
    for (final province in candidateAnnexBarbarianOrVassalProvinces) {
      if (_state.provinceIsPort(province)) {
        candidateProvinces.add(province);
      }
    }
    return candidateProvinces;
  }
  
  List<Location> get candidateAnnexForeignProvinces {
    final candidateProvinces = <Location>[];
    for (final province in LocationType.province.locations) {
      if (_state.spaceForeign(province)) {
        if (_state.spaceCanBeAnnexed(province)) {
          candidateProvinces.add(province);
        }
      }
    }
    return candidateProvinces;
  }

  List<Piece> get candidateDismissUnits {
    final candidates = <Piece>[];
    for (final unit in PieceType.unit.pieces) {
      if (_state.unitInPlay(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Piece> get candidateDemoteUnits {
    final candidates = <Piece>[];
    for (final unit in PieceType.unit.pieces) {
      if (_state.unitInPlay(unit) && _state.unitDemotable(unit)) {
        candidates.add(unit);
      }
    }
    return candidates;
  }

  List<Location> get candidateRevoltProvinces {
    final candidates = <Location>[];
    for (final war in PieceType.nativeWar.pieces) {
      if (_state.warInPlay(war)) {
        final warSpace = _state.pieceLocation(war);
        for (final space in _state.spaceAndConnectedSpaces(warSpace)) {
          if (space.isType(LocationType.province)) {
            if (_state.spaceVassalOrBetter(space)) {
              int warCount = _state.piecesInLocationCount(PieceType.war, space);
              if (space == warSpace || warCount == 0) {
                if (!candidates.contains(space)) {
                  candidates.add(space);
                }
              }
            }
          }
        }
      }
    }
    return candidates;
  }

  List<Location> get candidateCedeProvinces {
    final candidates = <Location>[];
    for (final war in PieceType.foreignWar.pieces) {
      if (_state.warInPlay(war)) {
        final warSpace = _state.pieceLocation(war);
        for (final space in _state.spaceAndConnectedSpaces(warSpace)) {
          if (space.isType(LocationType.province)) {
            if (_state.spaceVassalOrBetter(space)) {
              int warCount = _state.piecesInLocationCount(PieceType.war, space);
              if (space == warSpace || warCount == 0) {
                if (!candidates.contains(space)) {
                  candidates.add(space);
                }
              }
            }
          }
        }
      }
    }
    return candidates;
  }

  void advanceScenario() {
    const scenarioStatesmen = [
	    [
        Piece.treatyNerchinsk,
        Piece.statesmanSharhuda,
        Piece.statesmanOboi,
        Piece.statesmanShiLang,
        Piece.statesmanKoxinga,
        Piece.statesmanSonggotu,
        Piece.statesmanShunzhi,
        Piece.statesmanKangxi,
        Piece.statesmanYongzheng,
        Piece.statesmanGengyao,
        Piece.statesmanYunsi,
        Piece.statesmanOrtai,
        Piece.statesmanYinxiang,
        Piece.statesmanZhongqi,
        Piece.statesmanYunti,
        Piece.statesmanQianlong,
      ],
    	[
        Piece.treatyKyakhta,
        Piece.statesmanZhaohui,
        Piece.statesmanAgui,
        Piece.statesmanFuheng,
        Piece.statesmanSunShiyi,
        Piece.statesmanYongxuan,
        Piece.statesmanWangLun,
        Piece.statesmanYongqi,
        Piece.statesmanHeshen,
        Piece.statesmanFuKangan,
        Piece.statesmanYangFang,
        Piece.statesmanJiaqing,
        Piece.statesmanDaoguang,
      ],
      [
        Piece.treatyNanjing,
        Piece.treatyTianjin,
        Piece.statesmanLinZexu,
        Piece.statesmanRinchen,
        Piece.statesmanGuofan,
        Piece.statesmanZuo,
        Piece.statesmanXiuquan,
        Piece.statesmanMianyu,
        Piece.statesmanHongzhang,
        Piece.statesmanXianfeng,
        Piece.statesmanYixin,
        Piece.statesmanCixi,
        Piece.statesmanLiuYongfu,
        Piece.statesmanTongzhi,
      ],
      [
        Piece.treatyMaguan,
        Piece.treatyXinchou,
        Piece.statesmanCaoFutian,
        Piece.statesmanYinchang,
        Piece.statesmanShikai,
        Piece.statesmanSunYixian,
        Piece.statesmanGuangxu,
        Piece.statesmanZuolin,
        Piece.statesmanFeng,
        Piece.statesmanZhuDe,
        Piece.statesmanJiang,
        Piece.statesmanLiZongren,
        Piece.statesmanMao,
        Piece.statesmanShicai,
        Piece.statesmanPuyi,
      ],
    ];

    const scenarioBarbarians = [
      [
        Piece.leaderGaldan,
        Piece.warDutch5,
        Piece.warMian8,
        Piece.warMiao7,
        Piece.warMongol14,
        Piece.warMongol12,
        Piece.warMongol10,
        Piece.warPirate8,
        Piece.warPirate6,
        Piece.warPortuguese4,
        Piece.warRussian12,
        Piece.warRussian10,
        Piece.warTaiwan4,
        Piece.warThai6,
        Piece.warTibetan8,
        Piece.warTibetan6,
        Piece.warTurkish12,
        Piece.warTurkish11,
        Piece.warTurkish10,
        Piece.warViet9,
        Piece.warWokou7,
        Piece.warWokou5,
      ],
      [
        Piece.leaderHsinbyushin,
        Piece.leaderNguyen,
        Piece.leaderZhengYi,
        Piece.warDutch5,
        Piece.warGurkha7,
        Piece.warGurkha5,
        Piece.warJinchuan5,
        Piece.warMiao9,
        Piece.warMiao7,
        Piece.warMongol14,
        Piece.warMongol12,
        Piece.warMongol10,
        Piece.warPirate8,
        Piece.warPirate6,
        Piece.warRussian14,
        Piece.warRussian12,
        Piece.warTaiwan4,
        Piece.warThai6,
        Piece.warTurkish12,
        Piece.warTurkish11,
        Piece.warTurkish10,
        Piece.warViet9,
        Piece.warWhiteLotus9,
        Piece.warWokou7,
        Piece.warWokou5,
      ],
      [
        Piece.leaderYaqub,
        Piece.warAmerican7,
        Piece.warBritish12,
        Piece.warBritish10,
        Piece.warBritish8,
        Piece.warFrench11,
        Piece.warFrench9,
        Piece.warGurkha7,
        Piece.warHui11,
        Piece.warJapanese9,
        Piece.warMian8,
        Piece.warMiao9,
        Piece.warNian11,
        Piece.warPanthay13,
        Piece.warPirate6,
        Piece.warRedTurban12,
        Piece.warRussian14,
        Piece.warRussian12,
        Piece.warRussian10,
        Piece.warSpanish6,
        Piece.warSikh4,
        Piece.warTaiping14,
        Piece.warTurkish11,
        Piece.warTurkish10,
        Piece.warWokou5,
      ],
      [
        Piece.warAmerican7,
        Piece.warBoxer13,
        Piece.warBritish10,
        Piece.warBritish8,
        Piece.warCommunist15,
        Piece.warFrench11,
        Piece.warFrench9,
        Piece.warGerman8,
        Piece.warHui11,
        Piece.warJapanese15,
        Piece.warJapanese13,
        Piece.warJapanese11,
        Piece.warJapanese9,
        Piece.warMian8,
        Piece.warPirate6,
        Piece.warRussian14,
        Piece.warRussian12,
        Piece.warRussian10,
        Piece.warTaiwan4,
        Piece.warTibetan8,
        Piece.warTibetan6,
        Piece.warTurkish12,
        Piece.warTurkish11,
        Piece.warTurkish10,
        Piece.warViet9,
      ],
    ];

    const scenarioPrestigeBonuses = [
      [0],
      [0],
      [0],
      [0],
    ];

    int newScenario = (_state.turn + 1) ~/ 10;

    _state.adjustPrestige(scenarioPrestigeBonuses[newScenario][0] - 150);

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

  void fixInactiveGovernors() {
    for (final command in LocationType.governorship.locations) {
      if (!_state.commandActive(command)) {
        final statesman = _state.pieceInLocation(PieceType.statesman, command);
        if (statesman != null) {
          logLine('>${_state.commanderName(command)} is Exiled.');
          governorIsExiled(command);
        }
      }
    }
  }

  void fixOverstacking() {
    while (_state.overstackedProvinces().isNotEmpty) {
      if (choicesEmpty()) {
        setPrompt('Relocate Units from non-Chinese Provinces');
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

  void newRuler(Location ruler, DeathCause cause, Location? causeCommand) {
    _newRulerState ??= NewRulerState();
    final localState = _newRulerState!;
    if (localState.subStep == 0) {
      // My injection NP_CHECK
      if (cause == DeathCause.noLoyalProvinces) {
        final candidateCommands = <Location>[];
        for (final command in LocationType.governorship.locations) {
          if (_state.commandRebel(command)) {
            candidateCommands.add(command);
          }
        }
        final rebelCommand = randLocation(candidateCommands)!;
        final rebelStatesman = _state.pieceInLocation(PieceType.statesman, rebelCommand);
        logLine('>${_state.commanderName(rebelCommand)} becomes ${_state.commanderPositionName(_state.rulingCommand, rebelStatesman == null)}.');
        governorBecomesRuler(rebelCommand, _state.rulingCommand);
        _newRulerState = null;
        return;
      }

      // a, b
      if (cause == DeathCause.rebelGovernorVictory || cause == DeathCause.assassination) {
        final causeStatesman = _state.pieceInLocation(PieceType.statesman, causeCommand!);
        logLine('>${_state.commanderName(causeCommand)} becomes ${_state.commanderPositionName(_state.rulingCommand, causeStatesman == null)}.');
        governorBecomesRuler(causeCommand, _state.rulingCommand);
        _newRulerState = null;
        return;
      }
      localState.subStep = 1;
    }

    // c
    if (localState.subStep == 1) {
      final candidateStatesmen = <Piece>[];
      for (final statesman in PieceType.statesman.pieces) {
        if (_state.statesmanInPlay(statesman)) {
          if ((_state.rulingCommand == Location.commandEmperor && _state.statesmanImperial(statesman)) ||
              (_state.rulingCommand == Location.commandPresident && _state.statesmanPresidential(statesman))) {
            candidateStatesmen.add(statesman);
          }
        }
      }
      if (candidateStatesmen.isEmpty && _state.rulingCommand == Location.commandPresident) {
        for (final statesman in PieceType.statesman.pieces) {
          if (_state.statesmanInPlay(statesman)) {
            candidateStatesmen.add(statesman);
          }
        }
      }
      if (candidateStatesmen.isNotEmpty) {
        Piece? statesman;
        if (candidateStatesmen.length == 1) {
          statesman = candidateStatesmen[0];
        } else if (cause == DeathCause.dynasty) {
          statesman = randPiece(candidateStatesmen);
        } else {
          if (choicesEmpty()) {
            setPrompt('Select Statesman who will become ${_state.commanderPositionName(_state.rulingCommand, false)}');
            for (final statesman in candidateStatesmen) {
              pieceChoosable(statesman);
            }
            throw PlayerChoiceException();
          }
          statesman = selectedPiece();
          clearChoices();
        }
        logLine('>${statesman!.desc} becomes ${_state.commanderPositionName(_state.rulingCommand, false)}');
        final location = _state.pieceLocation(statesman);
        if (location.isType(LocationType.governorship)) {
          governorBecomesRuler(location, _state.rulingCommand);
        } else {
          statesmanBecomesRuler(statesman, _state.rulingCommand);
        }
        _newRulerState = null;
        return;
      }
      localState.subStep = 2;
    }
    if (localState.subStep == 2) {
      // d
      String desc = _state.rulingCommand == Location.commandEmperor ? 'Regent' : 'Provisional President';
      logLine('>A $desc is appointed.');
      genericBecomesRuler(_state.rulingCommand);
    }
    _newRulerState = null;
  }

  void assassinationAttempt(Location assassinCommand, Location? targetCommand, Piece? targetStatesman) {
    _assassinationAttemptState ??= AssassinationAttemptState();
    final localState = _assassinationAttemptState!;

    if (localState.subStep == 0) {
      if (targetCommand != null) {
        logLine('### ${_state.commanderName(assassinCommand)} attempts to Assassinate ${_state.commanderName(targetCommand)}');
      } else {
        logLine('### ${_state.commanderName(assassinCommand)} attempts to Assassinate ${_state.adornedStatesmanName(targetStatesman!)}');
      }
      int modifiers = 0;
      int die = rollD6();
      int modifier = 0;
 
      logTableHeader();
      logD6InTable(die);
      int assassinReform = _state.commandReform(assassinCommand);
      int targetReform = targetCommand != null ? _state.commandReform(targetCommand) : _state.statesmanReform(targetStatesman!);
      if (assassinReform >= targetReform) {
        modifier = assassinReform;
        logLine('>|${_state.commanderName(assassinCommand)} Reform|+$modifier|');
        modifiers += modifier;
        modifier = -targetReform;
        if (targetCommand != null) {
          logLine('>|${_state.commanderName(targetCommand)} Reform|$modifier|');
        } else {
          logLine('>|${targetStatesman!.desc} Reform|$modifier|');
        }
        modifiers += modifier;
      } else {
        modifier = targetReform;
        if (targetCommand != null) {
          logLine('>|${_state.commanderName(targetCommand)}Reform|+$modifier|');
        } else {
          logLine('>|${targetStatesman!.desc}Reform|+$modifier|');
        }
        modifiers += modifier;
        modifier = -assassinReform;
        logLine('>|${_state.commanderName(assassinCommand)}Reform|$modifier|');
        modifiers += modifier;
      }
      modifier = _state.commandIntrigue(assassinCommand);
      logLine('>|${_state.commanderName(assassinCommand)}Intrigue|+$modifier|');
      modifiers += modifier;
      if (targetCommand != null) {
        modifier = _state.commandIntrigue(targetCommand);
        logLine('>|${_state.commanderName(targetCommand)} Intrigue|+$modifier|');
      } else {
        modifier = _state.statesmanIntrigue(targetStatesman!);
        logLine('>|${targetStatesman.desc} Intrigue|+$modifier|');
      }
      modifiers += modifier;
      modifier = _state.eventTypeCount(EventType.conspiracy);
      if (modifier > 0) {
        logLine('>|Conspiracy|+$modifier|');
        modifiers += modifier;
      }
      int conspiracyModifier = modifier;
      int guardsModifier = 0;
      if (targetCommand != null) {
        modifier = -_state.assassinationGuardsInCapitalCount(targetCommand);
        if (modifier < 0) {
          logLine('>|Guards in Capital|$modifier|');
          modifiers += modifier;
        }
        guardsModifier += modifier;
      }
      int result = die + modifiers;
      logLine('>|Total|$result|');
      logTableFooter();

      String assassinName = _state.commanderName(assassinCommand);
      String targetName = targetCommand != null ? _state.commanderName(targetCommand) : _state.adornedStatesmanName(targetStatesman!);

      if (result < 12) {
        if (result - guardsModifier >= 12) {
          logLine('>Attempt to Assassinate $targetName is thwarted by the Guard.');
        } else {
          logLine('>A plot to Assassinate $targetName is uncovered.');
        }
        _assassinationAttemptState = null;
        return;
      }

      bool exile = false;
      if (targetCommand != null) {
        final statesman = _state.pieceInLocation(PieceType.statesman, targetCommand);
        exile = statesman != null && _state.statesmanAbility(statesman) == Ability.exile;
      } else {
        exile = _state.statesmanAbility(targetStatesman!) == Ability.exile;
      }
      if (exile) {
        logLine('>Exile roll');
        int die = rollD6();
        logD6(die);
        if (die <= 3) {
          exile = false;
        }
      }

      if (result - conspiracyModifier < 12) {
        if (assassinCommand.isType(LocationType.governorship)) {
          if (exile) {
            logLine('>A Conspiracy led by $assassinName ousts $targetName who heads into Exile.');
          } else {
            logLine('>A Conspiracy led by $assassinName Assassinates $targetName.');
          }
        } else {
          if (exile) {
            logLine('>A Conspiracy initiated by $assassinName ousts $targetName who heads into Exile.');
          } else {
            logLine('>A Conspiracy initiated by $assassinName Assassinates $targetName.');
          }
        }
      } else {
        if (exile) {
          logLine('>$targetName is ousted by $assassinName and Exiled.');
        } else {
          logLine('>$targetName is Assassinated by $assassinName.');
        }
      }

      if (targetCommand != null) {
        adjustPrestige(-_state.commandAdministration(targetCommand));
        adjustUnrest(_state.commandReform(targetCommand));
        if (targetCommand.isType(LocationType.governorship)) {
          if (exile) {
            governorIsExiled(targetCommand);
          } else {
            governorDies(targetCommand);
          }
        }
      } else {
        if (exile) {
          _state.setPieceLocation(targetStatesman!, Location.boxExile);
        } else {
          _state.setPieceLocation(targetStatesman!, Location.offmap);
        }
      }

      if (targetCommand == null || !targetCommand.isType(LocationType.ruler)) {
        _assassinationAttemptState = null;
        return;
      }

      if (exile) {
        rulerIsExiled(targetCommand);
      } else {
        rulerDies(targetCommand);
      }
      newRuler(targetCommand, DeathCause.assassination, assassinCommand);
    }

    _assassinationAttemptState = null;
  }

  Location? annexSelectedProvince(List<Location> candidateProvinces) {
    if (choicesEmpty()) {
      setPrompt('Select Province to Annex');
      for (final province in candidateProvinces) {
        locationChoosable(province);
      }
      if (candidateProvinces.isEmpty) {
        choiceChoosable(Choice.next, true);
      }
      throw PlayerChoiceException();
    } 
    if (checkChoiceAndClear(Choice.next)) {
      logLine('>No Provinces available for Annexation.');
      return null;
    }
    final province = selectedLocation()!;
    annexProvince(province);
    clearChoices();
    return province;
  }

  void takeLosses(int count) {
    _takeLossesState ??= TakeLossesState(count);
    final localState = _takeLossesState!;
    while (localState.remainingCount > 0) {
      fixInactiveGovernors();
      if (_state.overstackedProvinces().isNotEmpty) {
        fixOverstacking();
      }
      if (choicesEmpty()) {
        bool actionsAvailable = false;
        bool dismiss = false;
        bool demote = false;
        bool increaseUnrest = false;
        bool decreasePrestige = false;
        bool tribute = false;
        bool revolt = false;
        bool cede = false;
        if (localState.dismissCount < 2 && candidateDismissUnits.isNotEmpty) {
          final units = candidateDismissUnits;
          if (units.length >= _options.dismissMilitiaCount) {
            dismiss = true;
            actionsAvailable = true;
          } else {
            for (final unit in units) {
              if (!unit.isType(PieceType.militia)) {
                dismiss = true;
                actionsAvailable = true;
                break;
              }
            }
          }
        }
        if (localState.demoteCount < 2 && candidateDemoteUnits.isNotEmpty) {
          demote = true;
          actionsAvailable = true;
        }
        if (localState.disgraceCount < 2) {
          increaseUnrest = true;
          actionsAvailable = true;
        }
        if (localState.dishonorCount < 2) {
          decreasePrestige = true;
          actionsAvailable = true;
        }
        if (localState.tributeCount < 2 && _state.cash >= _options.tributeAmount) {
          tribute = true;
          actionsAvailable = true;
        }
        if (localState.revoltCount < 2 && candidateRevoltProvinces.isNotEmpty) {
          revolt = true;
          actionsAvailable = true;
        }
        if (localState.cedeCount < 2 && candidateCedeProvinces.isNotEmpty) {
          cede = true;
          actionsAvailable = true;
        }
        if (actionsAvailable) {
          setPrompt('Select Loss');
          choiceChoosable(Choice.lossDismiss, dismiss);
          choiceChoosable(Choice.lossDemote, demote);
          choiceChoosable(Choice.lossUnrest, increaseUnrest);
          choiceChoosable(Choice.lossPrestige, decreasePrestige);
          choiceChoosable(Choice.lossTribute, tribute);
          choiceChoosable(Choice.lossRevolt, revolt);
          choiceChoosable(Choice.lossCede, cede);
        } else {
          setPrompt('No Loss possible');
        }
        choiceChoosable(Choice.next, !actionsAvailable);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.next)) {
        _takeLossesState = null;
        return;
      }
      if (checkChoice(Choice.lossDismiss)) {
        final units = selectedPieces();
        if (units.isEmpty || (units.length < _options.dismissMilitiaCount)) {
          setPrompt('Select Unit(s) to Dismiss');
          int militiaCount = 0;
          for (final unit in candidateDismissUnits) {
            if (unit.isType(PieceType.militia)) {
              militiaCount += 1;
            } else {
              if (units.isEmpty) {
                pieceChoosable(unit);
              }
            }
          }
          if (units.length + militiaCount >= _options.dismissMilitiaCount) {
            for (final unit in candidateDismissUnits) {
              if (unit.isType(PieceType.militia)) {
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
        localState.remainingCount -= 1;
        localState.dismissCount += 1;
        clearChoices();
      } else if (checkChoice(Choice.lossDemote)) {
        final units = selectedPieces();
        if (units.isEmpty) {
          setPrompt('Select Unit(s) to Demote');
          for (final unit in candidateDemoteUnits) {
            pieceChoosable(unit);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        for (final unit in units) {
          unitDemote(unit);
        }
        localState.remainingCount -= 1;
        localState.demoteCount += 1;
        clearChoices();
      } else if (checkChoice(Choice.lossUnrest)) {
        if (localState.disgraceCount == 0) {
          logLine('>China is Disgraced.');
        }
        adjustUnrest(1);
        localState.remainingCount -= 1;
        localState.disgraceCount += 1;
        clearChoices();
      } else if (checkChoice(Choice.lossPrestige)) {
        if (localState.dishonorCount == 0) {
          logLine('>China is Dishonored.');
        }
        adjustPrestige(-1);
        localState.remainingCount -= 1;
        localState.dishonorCount += 1;
        clearChoices();
      } else if (checkChoice(Choice.lossTribute)) {
        if (localState.tributeCount == 0) {
          logLine('>China offers Tribute.');
        }
        int amount = _options.tributeAmount;
        adjustCash(-amount);
        localState.remainingCount -= 1;
        localState.tributeCount += 1;
        clearChoices();
      } else if (checkChoice(Choice.lossRevolt)) {
        final province = selectedLocation();
        if (province == null) {
          setPrompt('Select Province to Revolt');
          for (final province in candidateRevoltProvinces) {
            locationChoosable(province);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
        logLine('>${province.desc} Revolts.');
        provinceDecreaseStatus(province);
        localState.remainingCount -= 1;
        localState.revoltCount += 1;
        clearChoices();
      } else if (checkChoice(Choice.lossCede)) {
        final province = selectedLocation();
        if (province == null) {
          setPrompt('Select Province to Cede');
          for (final province in candidateCedeProvinces) {
            locationChoosable(province);
          }
          choiceChoosable(Choice.cancel,true);
          throw PlayerChoiceException();
        }
        Enemy? foreignEnemy;
        if (checkChoice(Choice.american)) {
          foreignEnemy = Enemy.american;
        } else if (checkChoice(Choice.british)) {
          foreignEnemy = Enemy.british;
        } else if (checkChoice(Choice.dutch)) {
          foreignEnemy = Enemy.dutch;
        } else if (checkChoice(Choice.french)) {
          foreignEnemy = Enemy.french;
        } else if (checkChoice(Choice.german)) {
          foreignEnemy = Enemy.german;
        } else if (checkChoice(Choice.japanese)) {
          foreignEnemy = Enemy.japanese;
        } else if (checkChoice(Choice.portuguese)) {
          foreignEnemy = Enemy.portuguese;
        } else if (checkChoice(Choice.russian)) {
          foreignEnemy = Enemy.russian;
        } else if (checkChoice(Choice.spanish)) {
          foreignEnemy = Enemy.spanish;
        }
        if (foreignEnemy != null) {
          logLine('>${province.desc} is Ceded to the ${foreignEnemy.desc}.');
          _state.setProvinceStatus(province, foreignEnemy.foreignStatus!);
          localState.remainingCount -= 1;
          localState.cedeCount += 1;
          clearChoices();
        } else {
          setPrompt('Select Enemy to Cede ${province.desc} to');
          var foreignCandidates = <Enemy>[];
          for (final war in PieceType.foreignWar.pieces) {
            if (_state.warInPlay(war)) {
              final enemy = _state.warEnemy(war);
              if (!foreignCandidates.contains(enemy)) {
                final warSpace = _state.pieceLocation(war);
                if (warSpace == province) {
                  foreignCandidates = [_state.warEnemy(war)];
                  break;
                }
                if (_state.spacesConnectionType(warSpace, province) != null) {
                  foreignCandidates.add(enemy);
                }
              }
            }
          }
          if (foreignCandidates.contains(Enemy.american)) {
            choiceChoosable(Choice.american, true);
          }
          if (foreignCandidates.contains(Enemy.british)) {
            choiceChoosable(Choice.british, true);
          }
          if (foreignCandidates.contains(Enemy.dutch)) {
            choiceChoosable(Choice.dutch, true);
          }
          if (foreignCandidates.contains(Enemy.french)) {
            choiceChoosable(Choice.french, true);
          }
          if (foreignCandidates.contains(Enemy.german)) {
            choiceChoosable(Choice.german, true);
          }
          if (foreignCandidates.contains(Enemy.japanese)) {
            choiceChoosable(Choice.japanese, true);
          }
          if (foreignCandidates.contains(Enemy.portuguese)) {
            choiceChoosable(Choice.portuguese, true);
          }
          if (foreignCandidates.contains(Enemy.russian)) {
            choiceChoosable(Choice.russian, true);
          }
          if (foreignCandidates.contains(Enemy.spanish)) {
            choiceChoosable(Choice.spanish, true);
          }
          choiceChoosable(Choice.cancel, true);
          throw PlayerChoiceException();
        }
      }
    }
  }

  void eventAssassin() {
    _eventAssassinState ??= EventAssassinState();
    final localState = _eventAssassinState!;

    if (localState.assassinCommand == null) {
      final ruler = _state.rulingCommand;
      final assassin = randGovernorship();
      localState.assassinCommand = assassin;
      localState.targetCommand = ruler;
    }
    assassinationAttempt(localState.assassinCommand!, localState.targetCommand, null);
    _eventAssassinState = null;
  }

  void eventAssassinDoubled() {
    _eventAssassinState ??= EventAssassinState();
    final localState = _eventAssassinState!;

    if (localState.assassinCommand == null) {
      final assassin = _state.rulingCommand;
      final targets = <Piece>[];
      for (final governorship in LocationType.governorship.locations) {
        final statesman = _state.commandCommander(governorship);
        if (statesman != null) {
          targets.add(statesman);
        }
      }
      for (final statesman in _state.piecesInLocation(PieceType.statesman, Location.poolStatesmen)) {
        targets.add(statesman);
      }
      if (targets.isEmpty) {
        logLine('>Assassination attempt does not materialize.');
        _eventAssassinState = null;
        return;
      }
      final target = randPiece(targets)!;
      localState.assassinCommand = assassin;
      localState.targetStatesman = target;
    }
    assassinationAttempt(localState.assassinCommand!, localState.targetCommand, localState.targetStatesman);
    _eventAssassinState = null;
  }

  void eventBuddhists() {
    logLine('>Increased chance of Revolt in Tibet and the South.');
  }

  void eventBuddhistsDoubled() {
    logLine('>Greatly increased chance of Revolt in Tibet and the South.');
  }

  void eventChristians() {
    adjustUnrest(_state.commandIntrigue(_state.rulingCommand));
  }

  void eventChristiansDoubled() {
    eventChristians();
  }

  void eventConquest() {
    // Ugly, _subStep is 1 by the time we get here
    while (_subStep >= 1 && _subStep <= 2) {
      if (annexSelectedProvince(candidateAnnexBarbarianOrVassalProvinces) == null) {
        return;
      }
      _subStep += 1;
    }
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

  void eventDiplomat() {
    annexSelectedProvince(candidateAnnexBarbarianOrVassalProvinces);
  }

  void eventDiplomatDoubled() {
    if (choicesEmpty()) {
      final wars = <Piece>[];
      for (final war in PieceType.war.pieces) {
        final location = _state.pieceLocation(war);
        if (location.isType(LocationType.province)) {
          wars.add(war);
        }
      }
      if (wars.isEmpty) {
        logLine('>No Wars are available for Diplomacy.');
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
    logLine('>Diplomacy removes ${war.desc} from ${province.desc}.');
    setWarOffmap(war);
  }

  void eventDynasty() {
		logLine('>Increased number of new Statesmen.');
  }

  void eventDynastyDoubled() {
    // NP_CHECK should apply to President ?
    if (_state.rulingCommand == Location.commandEmperor) {
      logLine('>${_state.commanderName(_state.rulingCommand)} is overthrown.');
      rulerDies(_state.rulingCommand);
      newRuler(_state.rulingCommand, DeathCause.dynasty, null);
    } else {
      logLine('>???');
    }
  }

  void eventEmigration() {
    int count = 0;
    for (final province in LocationType.province.locations) {
      if (_state.provinceIsPort(province)) {
        if (_state.provinceStatus(province) == ProvinceStatus.chinese) {
          count += 1;
        }
      }
    }
    adjustPrestige(count);
    adjustUnrest(-count);
  }

  void eventEmigrationDoubled() {
    eventEmigration();
  }

  void eventFlood() {
    logLine('>Increased chance of Revolt in Flood Provinces.');
  }

  void eventFloodDoubled() {
    logLine('>Greatly increased chance of Revolt in Flood Provinces.');
  }

  void eventInflation() {
    adjustCash(-((_state.cash + 1) ~/ 2));
    logLine('>Reduced Taxation yield expected.');
  }

  void eventInflationDoubled() {
    adjustCash(-_state.cash);
    logLine('>Greatly reduced Taxation yield expected.');
  }

  void eventIsolation() {
    annexSelectedProvince(candidateAnnexBarbarianOrVassalPortProvinces);
  }

  void eventIsolationDoubled() {
    annexSelectedProvince(candidateAnnexForeignProvinces);
  }

  void eventMuslims() {
    logLine('>Increased chance of Revolt in West China and Xinjiang.');
  }

  void eventMuslimsDoubled() {
    logLine('>greatly increased chance of Revolt in West China and Xinjiang.');
  }

  void eventOmens() {
    logLine('>Increased chance of bad outcomes.');
  }

  void eventOmensDoubled() {
    logLine('>Reduced chance of bad outcomes.');
  }

  void eventOpium() {
    int die = rollD6();
    logD6(die);
    adjustUnrest(die);
  }

  void eventOpiumDoubled() {
    // Ugly, _subStep is 1 by the time we get here
    if (_subStep == 1) {
      int count = 0;
      for (final province in LocationType.province.locations) {
        if (_state.provinceIsPort(province)) {
          if (_state.spaceForeign(province)) {
            count += 1;
          }
        }
      }
      takeLosses(count);
      fixInactiveGovernors();
      _subStep = 2;
    }
    if (_subStep == 2) {
      if (_state.overstackedProvinces().isNotEmpty) {
        fixOverstacking();
      }
    }
  }

  void eventPersecution() {
    int amount = -((_state.commandIntrigue(_state.rulingCommand) + 1) ~/ 2);
    adjustPrestige(amount);
  }

  void eventPersecutionDoubled() {
    logLine('>Increased chance of military disaster.');
  }

  void eventPillage() {
    logLine('>Increased number of Wars and Pillage.');
  }

  void eventPillageDoubled() {
    logLine('>Greatly increased number of Wars and Pillage.');
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

  void eventUsurper() {
    int die = rollD6();
    logD6(die);
    adjustUnrest(die);
  }

  void eventUsurperDoubled() {
    for (final command in LocationType.governorship.locations) {
      if (_state.commandActive(command)) {
        makeRebellionCheckForCommand(command);
      }
    }
  }

  void Function() eventTypeHandler(EventType eventType, bool doubled) {
    final eventTypeHandlers = {
      EventType.assassin: [eventAssassin, eventAssassinDoubled],
      EventType.buddhists: [eventBuddhists, eventBuddhistsDoubled],
      EventType.christians: [eventChristians, eventChristiansDoubled],
      EventType.conquest: [eventConquest, eventConquestDoubled],
      EventType.conspiracy: [eventConspiracy, eventConspiracyDoubled],
      EventType.diplomat: [eventDiplomat, eventDiplomatDoubled],
      EventType.dynasty: [eventDynasty, eventDynastyDoubled],
      EventType.emigration: [eventEmigration, eventEmigrationDoubled],
      EventType.flood: [eventFlood, eventFloodDoubled],
      EventType.inflation: [eventInflation, eventInflationDoubled],
      EventType.isolation: [eventIsolation, eventIsolationDoubled],
      EventType.muslims: [eventMuslims, eventMuslimsDoubled],
      EventType.omens: [eventOmens, eventOmensDoubled],
      EventType.opium: [eventOpium, eventOpiumDoubled],
      EventType.persecution: [eventPersecution, eventPersecutionDoubled],
      EventType.pillage: [eventPillage, eventPillageDoubled],
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

  void eventPhaseDiplomat() {
    for (final statesman in PieceType.statesman.pieces) {
      if (_state.statesmanInPlay(statesman) && _state.statesmanAbility(statesman) == Ability.diplomat) {
        if (_subStep == 0) {
          logLine('### Diplomat ${statesman.desc}');
          _subStep = 1;
        }
        if (_subStep == 1) {
          if (_state.eventTypeCount(EventType.diplomat) == 0) {
            eventDiplomat();
          } else {
            eventDiplomatDoubled();
          }
          _state.incrementEventTypeCount(EventType.diplomat);
          _subStep = 0;
        }
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
				logLine('>|${statesman.desc}|+1|');
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
    final phaseState = _phaseState as PhaseStateEvent;

    if (_subStep == 0) {
      for (final leader in PieceType.leader.pieces) {
        if (_state.leaderInPlay(leader)) {
          final name = leader.desc;
          if (failMortalityRoll(name, _state.leaderAge(leader))) {
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
        if (_state.statesmanInPlay(statesman) && !location.isType(LocationType.ruler)) {
          if (failMortalityRoll(_state.adornedStatesmanName(statesman), _state.statesmanAge(statesman))) {
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
      final name = _state.commanderName(_state.rulingCommand);
      final statesman = _state.commandCommander(_state.rulingCommand);
      int? age;
      if (statesman != null) {
        age = _state.statesmanAge(statesman);
      } else {
        age = _state.commanderAge(_state.rulingCommand);
      }

      if (failMortalityRoll(name, age)) {
        rulerDies(_state.rulingCommand, );
        phaseState.rulerMortalities.add(_state.rulingCommand);
      }
      _subStep = 2;
    }

    if (_subStep == 2) {
      if (phaseState.rulerMortalities.isNotEmpty) {
        newRuler(phaseState.rulerMortalities[0], DeathCause.mortality, null);
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
          if (leader.isType(PieceType.leaderLeader)) {
            _state.setLeaderAge(leader, _state.leaderAge(leader)! + 1);
          } else {
            final statesman = _state.leaderStatesman(leader);
            _state.setStatesmanAge(statesman, _state.statesmanAge(statesman)! + 1);
          }
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
      var remainingAssassins = <Piece>[];
      for (final statesman in PieceType.statesman.pieces) {
        if (_state.statesmanAbility(statesman) == Ability.assassin) {
          final location = _state.pieceLocation(statesman);
          if (location.isType(LocationType.command)) {
            if (!phaseState.assassins.contains(statesman)) {
              remainingAssassins.add(statesman);
            }
          }
        }
      }
      if (_subStep == 0) {
        if (remainingAssassins.isEmpty) {
          if (phaseState.assassins.isEmpty) {
            return;
          }
          _subStep = 2;
          break;
        }
        final assassin = randPiece(remainingAssassins)!;
        phaseState.assassins.add(assassin);
        final command = _state.pieceLocation(assassin);
        if (command.isType(LocationType.ruler)) {
          final candidates = <Piece>[];
          for (final statesman in PieceType.statesman.pieces) {
            if (_state.statesmanInPlay(statesman)) {
              if (statesman != assassin) {
                candidates.add(statesman);
              }
            }
          }
          phaseState.assassinTargetStatesman = randPiece(candidates);
        } else {
          phaseState.assassinTargetCommand = _state.rulingCommand;
        }
        if (phaseState.assassinTargetStatesman != null || phaseState.assassinTargetCommand != null) {
          _subStep = 1;
        }
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
      if (choicesEmpty()) {
        setPrompt('Assassination Step Complete');
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
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
    logLine('### Tax');
    tax();
  }

  void treasuryPhaseTaxComplete() {
    if (choicesEmpty()) {
      setPrompt('Tax Step Complete');
      choiceChoosable(Choice.next, true);
      throw PlayerChoiceException();
    }
    clearChoices();
  }

  void treasuryPhasePay() {
    logLine('### Pay');
    pay();
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
    while (true) {
      if (_state.cash >= 0) {
        return;
      }
      if (choicesEmpty()) {
        setPrompt('Levy Extra Cash');
        choiceChoosable(Choice.extraTaxes, true);
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      if (checkChoice(Choice.next)) {
        clearChoices();
        return;
      }
      if (checkChoiceAndClear(Choice.extraTaxes)) {
        _subStep = 1;
      }

      if (_subStep == 1) { // Extra Taxes
        logLine('### Extra Cash');
        final rolls = roll2D6();
        int total = rolls.$4;

        logTableHeader();
        log2D6InTable(rolls);
        logLine('>|Total|$total|');
        logTableFooter();

        adjustCash(total);
        adjustUnrest(1);
        adjustPrestige(-1);
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
      int die = rollD6();

      logTableHeader();
      logD6InTable(die);
      logLine('>|Scenario|-1|');
      int modifiers = -1;
      if (_state.eventTypeCount(EventType.pillage) != 0) {
        int modifier = _state.eventTypeCount(EventType.pillage);
        logLine('>|Pillage|+$modifier|');
        modifiers += modifier;
      }
      int result = die + modifiers;
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
      if (_subStep == 0) {
        final piece = randPiece(_state.piecesInLocation(PieceType.barbarian, Location.poolWars))!;
        if (piece.isType(PieceType.leaderLeader)) {
          logLine('### ${piece.desc}');
          _state.setLeaderAge(piece, 0);
          final enemy = _state.leaderEnemy(piece);
          final wars = _state.enemyWarsWithoutLeaders(enemy);
          if (wars.isEmpty) {
            final entryArea = randLocation(_state.enemyEntryAreas(enemy))!;
            logLine('>${piece.desc} appears in ${entryArea.desc}.');
            _state.setPieceLocation(piece, entryArea);
          } else {
            final war = randPiece(wars)!;
            final space = _state.pieceLocation(war);
            logLine('>${piece.desc} appears in ${space.desc} with ${war.desc}.');
            _state.setPieceLocation(piece, space);
          }
          phaseState.warsRemainingCount -= 1;
        } else {
          logLine('### ${piece.desc}');
          final entryArea = randLocation(_state.warEntryAreas(piece))!;
          logLine('>${piece.desc} arises in ${entryArea.desc}.');
          final otherWar = _state.pieceInLocation(PieceType.war, entryArea);
          _state.setPieceLocation(piece, entryArea);
          phaseState.setWarUnmoved(piece, true);
          if (otherWar != null) {
            moveWar(otherWar, entryArea, piece);
          }
          _subStep = 1;
        }
      }
      
      if (_subStep == 1) { // Redistribute Leaders
        final war = phaseState.drawnWar;
        final enemy = _state.warEnemy(war);
        redistributeEnemyLeaders(enemy);
        _subStep = 2;
      }

      if (_subStep == 2) { // Move War
        final war = phaseState.drawnWar;
        if (choicesEmpty()) {
          setPrompt('Select War to Move');
          pieceChoosable(war);
          throw PlayerChoiceException();
        }
        moveWar(war, null, null);
        clearChoices();
        phaseState.warsRemainingCount -= 1;
      }
      _subStep = 0;
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
      if (_state.commandRebel(command) && _state.commandAllegiance(command) == command) {
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
      logLine('>Wars:');
      for (final war in wars) {
        final location = _state.pieceLocation(war);
        logLine('>- ${war.desc} in ${location.desc}');
      }
      logLine('');
      amount += wars.length;
    }

    final banners = <(Location,int)>[];
    final fleets = <(Location,int)>[];
    for (final governorship in LocationType.governorship.locations) {
      final locationType = _state.commandLocationType(governorship)!;
      for (final province in locationType.locations) {
        int shortfall = 0;
        if (_state.spaceInsurgentOrBetter(province)) {
          shortfall = (_state.provinceHasGreatWall(province) ? 1 : 0) - _state.provinceBannerPieceCount(province);
          if (shortfall > 0) {
            banners.add((province, shortfall));
          }
          shortfall = (_state.provinceIsPort(province) ? 1 : 0) - _state.piecesInLocationCount(PieceType.fleet, province);
          if (shortfall > 0) {
            fleets.add((province, shortfall));
          }
        }
      }
    }

    if (banners.isNotEmpty) {
      logLine('>Banners Needed');
      for (final banner in banners) {
         logLine('>- ${banner.$1.desc}');
        amount += banner.$2;
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

    adjustUnrest(amount);
  }
  
  void unrestPhaseDrawStatesmen() {
    final phaseState = _phaseState as PhaseStateUnrest;
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
        int die = rollD2();
        int modifiers = 0;

        logTableHeader();
        logD2InTable(die);
        if (_state.eventTypeCount(EventType.dynasty) >= 1) {
          logLine('>|Dynasty|+1|');
          modifiers += 1;
        }
        int result = die + modifiers;
        logLine('>|Total|$result|');
        logTableFooter();

        drawCount = result;
        if (drawCount > poolPieces.length) {
          drawCount = poolPieces.length;
        }
      }
      if (poolPieces.isEmpty) {
        logLine('>No Statesmen/Treaties left to Draw.');
        return;
      }
      phaseState.statesmenRemainingCount = drawCount;
      _subStep = 2;
    }
    while (_subStep >= 2 && _subStep <= 4) {
      if (phaseState.statesmenRemainingCount == 0) {
        _subStep = 5;
        break;
      }
      if (_subStep == 2) {
        final poolPieces = _state.piecesInLocation(PieceType.statesmenPool, Location.poolStatesmen);
        final piece = randPiece(poolPieces)!;
        poolPieces.remove(piece);
        if (piece.isType(PieceType.statesman)) {
          if (_state.statesmanActiveImperial(piece)) {
            logLine('>${piece.desc} comes of age.');
          } else {
            logLine('>${piece.desc} rises to prominence.');
          }
          _state.setPieceLocation(piece, Location.boxStatesmen);
          _state.setStatesmanAge(piece, _state.statesmanImperial(piece) ? 0 : 1);
          final leader = _state.statesmanLeader(piece);
          if (leader != null) {
            final enemy = _state.leaderEnemy(leader);
            redistributeEnemyLeaders(enemy);
          }
          phaseState.statesmenRemainingCount -= 1;
        } else {
          logLine('>${piece.desc} is established.');
          final box = Location.values[LocationType.treaty.firstIndex + piece.index - PieceType.treaty.firstIndex];
          _state.setPieceLocation(piece, box);
          treatyAdded(piece);
          logLine('>Losses');
          int die = rollD6();
          logD6(die);
          phaseState.treatyLossCount = die;
          _subStep = 3;
        }
      }
      if (_subStep == 3) {
        takeLosses(phaseState.treatyLossCount);
        phaseState.treatyLossCount = 0;
        _subStep = 4;
      }
      if (_subStep == 4) {
        fixInactiveGovernors();
        if (_state.overstackedProvinces().isNotEmpty) {
          fixOverstacking();
        }
        phaseState.statesmenRemainingCount -= 1;
        _subStep = 2;
      }
    }
    if (_subStep == 5) {
      if (choicesEmpty()) {
        setPrompt('Draw Statesmen Step Complete');
        choiceChoosable(Choice.next, true);
        throw PlayerChoiceException();
      }
      clearChoices();
    }
  }

  void unrestPhaseAnnex() {
    final phaseState = _phaseState as PhaseStateUnrest;
    if (_subStep == 0) {
      logLine('### Annexations');

      logTableHeader();
      logLine('>|Base|2|');
      int annexCount = 2;
      final statesman = _state.pieceInLocation(PieceType.statesman, _state.rulingCommand);
      if (statesman != null && _state.statesmanAbility(statesman) == Ability.conquest) {
        logLine('>|${_state.commanderName(_state.rulingCommand)}|+1|');
        annexCount += 1;
      }
      if (_state.treatyActive(Piece.treatyKyakhta)) {
        logLine('>|Kyakhta Treaty|-1|');
        annexCount -= 1;
      }
      if (_state.treatyActive(Piece.treatyTianjin)) {
        logLine('>|Tianjin Treaty|-1|');
        annexCount -= 1;
      }
      logLine('>|Total|$annexCount|');
      logTableFooter();

      if (annexCount <= 0) {
        return;
      }
      phaseState.annexRemainingCount = annexCount;
      _subStep = 1;
    }
    while (phaseState.annexRemainingCount > 0) {
      final province = annexSelectedProvince(candidateAnnexBarbarianOrVassalProvinces);
      if (province == null) {
        return;
      }
      phaseState.annexRemainingCount -= 1;
    }
  }

  void unrestPhaseAppointCommanders() {
    if (_subStep == 0) {
      logLine('### Appointments');
      _subStep = 1;
    }
    while (true) {
      if (_subStep == 1) {
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
        _subStep = 2;
      }

      if (_subStep == 2) { // Appoint Statesman
        if (checkChoice(Choice.cancel)) {
          clearChoices();
          _subStep = 1;
          continue;
        }
        final appointStatesman = selectedPiece()!;
        final appointCommand = selectedLocation();
        if (appointCommand == null) {
          setPrompt('Select Command to Appoint ${appointStatesman.desc} to');
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
          governorshipBecomesLoyalToRuler(oldLocation);
        }
        appointStatesmanToCommand(appointStatesman, appointCommand);
        clearChoices();
        _subStep = 1;
      }
    }
  }

  void unrestPhaseAdjustPrestige() {
    logLine('### Prestige');
    int total = 0;
    int amount = 0;

    logTableHeader();
    amount = _state.commandAdministration(_state.rulingCommand);
    logLine('>|${_state.commanderName(_state.rulingCommand)} Administration|+$amount|');
    total += amount;
    for (final command in LocationType.command.locations) {
      final statesman = _state.commandCommander(command);
      if (statesman != null && _state.statesmanAbility(statesman) == Ability.prestige) {
        if (command.isType(LocationType.ruler) || _state.commandLoyal(command)) {
          logLine('>|${statesman.desc} Prestige|+1|');
          total += 1;
        }
      }
    }
    for (final command in LocationType.governorship.locations) {
      if (_state.commandLoyal(command)) {
        final locationType = _state.commandLocationType(command)!;
        bool prestigious = true;
        for (final province in locationType.locations) {
          switch (_state.provinceStatus(province)) {
          case ProvinceStatus.barbarian:
          case ProvinceStatus.foreignAmerican:
          case ProvinceStatus.foreignBritish:
          case ProvinceStatus.foreignDutch:
          case ProvinceStatus.foreignFrench:
          case ProvinceStatus.foreignGerman:
          case ProvinceStatus.foreignJapanese:
          case ProvinceStatus.foreignPortuguese:
          case ProvinceStatus.foreignRussian:
          case ProvinceStatus.foreignSpanish:
          case ProvinceStatus.insurgent:
            prestigious = false;
          case ProvinceStatus.vassal:
          case ProvinceStatus.chinese:
          }
          if (!prestigious) {
            break;
          }
        }
        if (prestigious) {
          logLine('>|${_state.commandName(command)}|+1|');
          total += 1;
        }
      }
    }
    logLine('>|Total|$total|');
    logTableFooter();

    adjustPrestige(total);
  }

  void unrestPhaseAdjustPrestigeMandateOfHeaven() {
    final phaseState = _phaseState as PhaseStateUnrest;
    while (true) {
      if (choicesEmpty()) {
        bool prestigeAvailable = false;
        if (_state.cash >= 10) {
          prestigeAvailable = phaseState.mandateOfHeavenPrestigeCount < _state.commandAdministration(_state.rulingCommand);
        }
        setPrompt('Spend from Treasury to increase Prestige?');
        choiceChoosable(Choice.yes, prestigeAvailable);
        choiceChoosable(Choice.no, true);
        throw PlayerChoiceException();
      }
      if (checkChoiceAndClear(Choice.no)) {
        return;
      }
      logLine('>Mandate of Heaven Increases Prestige.');
        adjustCash(-10);
        adjustPrestige(1);
        phaseState.mandateOfHeavenPrestigeCount += 1;
        clearChoices();
    }
  }

  void unrestPhaseAdjustUnrest() {
    logLine('### Unrest');
    int total = 0;
    int amount = 0;

    logTableHeader();
    amount = _state.commandReform(_state.rulingCommand);
    logLine('>|${_state.commanderName(_state.rulingCommand)} Reform|-$amount|');
    total -= amount;
    for (final command in LocationType.governorship.locations) {
      if (_state.commandLoyal(command)) {
        final locationType = _state.commandLocationType(command)!;
        bool stable = true;
        for (final province in locationType.locations) {
          switch (_state.provinceStatus(province)) {
          case ProvinceStatus.barbarian:
          case ProvinceStatus.foreignAmerican:
          case ProvinceStatus.foreignBritish:
          case ProvinceStatus.foreignDutch:
          case ProvinceStatus.foreignFrench:
          case ProvinceStatus.foreignGerman:
          case ProvinceStatus.foreignJapanese:
          case ProvinceStatus.foreignPortuguese:
          case ProvinceStatus.foreignRussian:
          case ProvinceStatus.foreignSpanish:
          case ProvinceStatus.insurgent:
            stable = false;
          case ProvinceStatus.vassal:
          case ProvinceStatus.chinese:
          }
          if (!stable) {
            break;
          }
        }
        if (stable) {
          logLine('>|${_state.commandName(command)}|-1|');
          total -= 1;
        }
      }
    }
    logLine('>|Total|$total|');
    logTableFooter();

    adjustUnrest(total);
  }

  void unrestPhaseAdjustUnrestMandateOfHeaven() {
    if (_subStep == 0) {
      if (_state.unrest == 0) {
        return;
      }
      _subStep = 1;
    }
    if (_subStep == 1) {
      while (true) {
        if (choicesEmpty()) {
          bool unrestAvailable = _state.cash >= 10;
          setPrompt('Spend from Treasury to reduce Unrest?');
          choiceChoosable(Choice.yes, unrestAvailable);
          choiceChoosable(Choice.no, true);
          throw PlayerChoiceException();
        }
        if (checkChoiceAndClear(Choice.no)) {
          return;
        }
        logLine('>Mandate of Heaven Reduces Unrest.');
          adjustCash(-10);
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
          if (_state.unitCanBuild(unit) || (_state.unitInPlay(unit) && (_state.unitCanTransfer(unit) || _state.unitCanPromote(unit) || _state.unitCanDemote(unit)))) {
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
            if (_state.unitCanTransfer(unit)) {
              for (final province in LocationType.province.locations) {
                if (_state.unitCanTransferToProvince(unit, province, true, true)) {
                  locationChoosable(province);
                }
              }
            }
            if (_state.unitCanPromote(unit)) {
              setPrompt('Select Province to Transfer ${unit.desc} to, or its current Province to Promote to Fort');
              locationChoosable(_state.pieceLocation(unit));
            } else if (_state.unitCanDemote(unit)) {
              setPrompt('Select current Province to confirm Demote to Militia');
              locationChoosable(_state.pieceLocation(unit));
            } else {
              setPrompt('Select Province to Transfer ${unit.desc} to');
            }
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
        }
        if (_state.unitCanBuild(unit)) {
          logLine('>Build ${unit.desc} in ${province.desc}.');
          _state.setPieceLocation(unit, province);
          int amount = -_state.unitBuildCost(unit);
          adjustCash(amount);
        } else {
          final oldProvince = _state.pieceLocation(unit);
          if (province == oldProvince) {
            final newUnit = _state.unitFlipUnit(unit);
            if (unit.isType(PieceType.militia)) {
              logLine('>Promote ${unit.desc} in ${oldProvince.desc} to ${newUnit.desc}.');
              int amount = -_state.unitPromoteCost(unit);
              adjustCash(amount);
            } else {
              logLine('>Demote ${unit.desc} in ${oldProvince.desc} to ${newUnit.desc}.');
            }
            _state.flipUnit(unit);
          } else {
            logLine('>Transfer ${unit.desc} from ${oldProvince.desc} to ${province.desc}.');
            int amount = -_state.unitTransferCostToProvince(unit, province);
            if (amount != 0) {
              adjustCash(amount);
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
    final phaseState = _phaseState as PhaseStateWar;

    if (_subStep == 0) {
      final revoltProvinces = <Location>[];
      final sinicizationProvinces = <Location>[];

      for (final province in LocationType.province.locations) {
        if (_state.provinceStatus(province) != ProvinceStatus.barbarian) {
          int result = provinceRevoltCheck(province);
          if (result > 0) {
            revoltProvinces.add(province);
          } else if (result < 0) {
            if (_state.provinceStatus(province) == ProvinceStatus.insurgent) {
              sinicizationProvinces.add(province);
            }
          }
        }
      }
      if (sinicizationProvinces.isNotEmpty) {
        logLine('### Sinicization');
        int prestigeAmount = 0;
        for (final province in sinicizationProvinces) {
          provinceIncreaseStatus(province);
          prestigeAmount += 1;
        }
        if (prestigeAmount != 0) {
          adjustPrestige(prestigeAmount);
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
            case ProvinceStatus.foreignAmerican:
              choiceChoosable(Choice.american, true);
            case ProvinceStatus.foreignBritish:
              choiceChoosable(Choice.british, true);
            case ProvinceStatus.foreignDutch:
              choiceChoosable(Choice.dutch, true);
            case ProvinceStatus.foreignFrench:
              choiceChoosable(Choice.french, true);
            case ProvinceStatus.foreignGerman:
              choiceChoosable(Choice.german, true);
            case ProvinceStatus.foreignJapanese:
              choiceChoosable(Choice.japanese, true);
            case ProvinceStatus.foreignPortuguese:
              choiceChoosable(Choice.portuguese, true);
            case ProvinceStatus.foreignRussian:
              choiceChoosable(Choice.russian, true);
            case ProvinceStatus.foreignSpanish:
              choiceChoosable(Choice.spanish, true);
            case ProvinceStatus.barbarian:
            case ProvinceStatus.vassal:
            case ProvinceStatus.insurgent:
            case ProvinceStatus.chinese:
            }
          }
          throw PlayerChoiceException();
        }
        ProvinceStatus? status;
        if (checkChoice(Choice.american)) {
          status = ProvinceStatus.foreignAmerican;
        } else if (checkChoice(Choice.british)) {
          status = ProvinceStatus.foreignBritish;
        } else if (checkChoice(Choice.dutch)) {
          status = ProvinceStatus.foreignDutch;
        } else if (checkChoice(Choice.french)) {
          status = ProvinceStatus.foreignFrench;
        } else if (checkChoice(Choice.german)) {
          status = ProvinceStatus.foreignGerman;
        } else if (checkChoice(Choice.japanese)) {
          status = ProvinceStatus.foreignJapanese;
        } else if (checkChoice(Choice.portuguese)) {
          status = ProvinceStatus.foreignPortuguese;
        } else if (checkChoice(Choice.russian)) {
          status = ProvinceStatus.foreignRussian;
        } else if (checkChoice(Choice.spanish)) {
          status = ProvinceStatus.foreignSpanish;
        }
        clearChoices();
        phaseState.revoltProvinceStatuses.add(status!);
      }
      _subStep = 2;
    }

    if (_subStep == 2) {
      int prestigeAmount = 0;
      int unrestAmount = 0;
      for (int i = 0; i < phaseState.revoltProvinces.length; ++i) {
        final province = phaseState.revoltProvinces[i];
        if (_state.provinceStatus(province) == ProvinceStatus.chinese) {
          unrestAmount += 1;
        }
        setProvinceStatus(province, phaseState.revoltProvinceStatuses[i]);
        prestigeAmount += 1;
      }
      if (prestigeAmount != 0) {
        adjustPrestige(-prestigeAmount);
      }
      if (unrestAmount != 0) {
        adjustUnrest(unrestAmount);
      }
		  _subStep = 3;
    }

    if (_subStep == 3) {
      if (_state.overstackedProvinces().isNotEmpty) {
        logLine('### Transfer Units from Non-Chinese Provinces');
        _subStep = 4;
      } else {
        _subStep = 5;
      }
    }

    if (_subStep == 4) {
      fixInactiveGovernors();
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
          if (phaseState.command == null && selectedLocation() != null) {
            final command = selectedLocationAndClear()!;
            phaseState.command = command;
          }
          if (phaseState.command == null) {
            setPrompt('Select Command to Fight War with');
            for (final command in fightWarCommandCandidates(phaseState.war!)) {
              locationChoosable(command);
            }
            choiceChoosable(Choice.cancel, true);
            throw PlayerChoiceException();
          }
          final command = phaseState.command!;
          if (!checkChoice(Choice.fightWar)) {
            if (selectedLocations().length == phaseState.provinces.length) {
              setPrompt('Select Provinces to Fight War from');
              for (final province in fightWarProvinceCandidates(phaseState.war!, command)) {
                if (!phaseState.provinces.contains(province)) {
                  locationChoosable(province);
                }
              }
              bool haveProvinces = phaseState.provinces.isNotEmpty;
              choiceChoosable(Choice.fightWar, haveProvinces);
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
            fightWar(phaseState.province!, phaseState.command!, phaseState.provinces);
            clearChoices();
            _subStep = 1;
          }
        }
        if (_subStep == 1) {
          fixInactiveGovernors();
          if (_state.overstackedProvinces().isNotEmpty) {
            fixOverstacking();
          }
          final command = phaseState.command!;
          if (choicesEmpty()) {
            bool actionsAvailable = false;
            bool actionsMandatory = false;
            bool dismiss = false;
            bool demote = false;
            bool increaseUnrest = false;
            bool decreasePrestige = false;
            bool tribute = false;
            bool revolt = false;
            bool cede = false;
            bool decreaseUnrest = false;
            bool increasePrestige = false;
            bool addGold = false;
            bool promote = false;
            bool annex = false;
            if (phaseState.lossCount > 0) {
              if (phaseState.dismissCount < 2 && phaseState.candidateDismissUnits(_state).isNotEmpty) {
                final units = phaseState.candidateDismissUnits(_state);
                if (units.length >= _options.dismissMilitiaCount) {
                  dismiss = true;
                  actionsAvailable = true;
                } else {
                  for (final unit in units) {
                    if (!unit.isType(PieceType.militia)) {
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
                  if (_state.cash >= _options.tributeAmount) {
                    tribute = true;
                    actionsAvailable = true;
                  }
                } else {
                  if (phaseState.rebelCash >= _options.tributeAmount) {
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
            if (phaseState.cash > 0) {
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
              choiceChoosable(Choice.lossDismiss, dismiss);
              choiceChoosable(Choice.lossDemote, demote);
              choiceChoosable(Choice.lossUnrest, increaseUnrest);
              choiceChoosable(Choice.lossPrestige, decreasePrestige);
              choiceChoosable(Choice.lossTribute, tribute);
              choiceChoosable(Choice.lossRevolt, revolt);
              choiceChoosable(Choice.lossCede, cede);
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
            } else if (checkChoice(Choice.lossDismiss)) {
              final units = selectedPieces();
              if (units.isEmpty || (units[0].isType(PieceType.militia) && units.length < _options.dismissMilitiaCount)) {
                setPrompt('Select Unit(s) to Dismiss');
                int militiaCount = 0;
                for (final unit in phaseState.candidateDismissUnits(_state)) {
                  if (unit.isType(PieceType.militia)) {
                    militiaCount += 1;
                  } else {
                    if (units.isEmpty) {
                      pieceChoosable(unit);
                    }
                  }
                }
                if (units.length + militiaCount >= _options.dismissMilitiaCount) {
                  for (final unit in phaseState.candidateDismissUnits(_state)) {
                    if (unit.isType(PieceType.militia)) {
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
              if (units.isEmpty) {
                setPrompt('Select Unit(s) to Demote');
                for (final unit in phaseState.candidateDemoteUnits(_state)) {
                  pieceChoosable(unit);
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
                logLine('>China is Disgraced.');
              }
              adjustUnrest(1);
              phaseState.lossCount -= 1;
              phaseState.disgraceCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossPrestige)) {
              if (phaseState.dishonorCount == 0) {
                logLine('>China is Dishonored.');
              }
              adjustPrestige(-1);
              phaseState.lossCount -= 1;
              phaseState.dishonorCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossTribute)) {
              if (phaseState.tributeCount == 0) {
                logLine('>China offers Tribute.');
              }
              int amount = _options.tributeAmount;
              if (phaseState.rebelCash > 0) {
                phaseState.rebelCash -= amount;
              } else {
                adjustCash(-amount);
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
            } else if (checkChoice(Choice.lossCede)) {
              final province = selectedLocation();
              if (province == null) {
                setPrompt('Select Province to Cede');
                for (final province in phaseState.candidateCedeProvinces(_state)) {
                  locationChoosable(province);
                }
                choiceChoosable(Choice.cancel, true);
                throw PlayerChoiceException();
              }
              final foreignEnemy = _state.warEnemy(phaseState.war!);
              logLine('>${province.desc} is Ceded to the ${foreignEnemy.desc}.');
              _state.setProvinceStatus(province, foreignEnemy.foreignStatus!);
              phaseState.lossCount -= 1;
              phaseState.cedeCount += 1;
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
              adjustCash(phaseState.cash);
              phaseState.cash = 0;
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
          if (phaseState.deadRuler != null) {
            newRuler(phaseState.deadRuler!, DeathCause.disaster, null);
          }
          phaseState.warComplete(_state, true);
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
      while (_subStep >= 1 || unfoughtRebels().isNotEmpty) {
        if (_subStep == 0) {
          if (choicesEmpty()) {
            setPrompt('Select Rebel to Fight');
            for (final command in unfoughtRebels()) {
              locationChoosable(command);
            }
            throw PlayerChoiceException();
          }
          if (checkChoice(Choice.fightRebelsForego)) {
            clearChoices();
            break;
          }
          final rebelCommand = selectedLocationAndClear()!;
          phaseState.command = rebelCommand;
          fightRebel(rebelCommand);
          clearChoices();
          _subStep = 1;
        }
        if (_subStep == 1) {
          if (choicesEmpty()) {
            bool actionsAvailable = false;
            bool dismiss = false;
            bool demote = false;
            bool increaseUnrest = false;
            bool decreasePrestige = false;
            bool tribute = false;
            bool promote = false;
            if (phaseState.lossCount > 0) {
              if (phaseState.dismissCount < 2) {
                final units = phaseState.candidateDismissCivilWarUnits(_state);
                if (units.length >= _options.dismissMilitiaCount) {
                  dismiss = true;
                  actionsAvailable = true;
                } else {
                  for (final unit in units) {
                    if (!unit.isType(PieceType.militia)) {
                      dismiss = true;
                      actionsAvailable = true;
                      break;
                    }
                  }
                }
                if (phaseState.demoteCount < 2) {
                  final units = phaseState.candidateDemoteCivilWarUnits(_state);
                  if (units.isNotEmpty) {
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
                if (phaseState.tributeCount < 2 && _state.cash >= _options.tributeAmount) {
                  tribute = true;
                  actionsAvailable = true;
                }
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
            } else if (checkChoice(Choice.lossDismiss)) {
              final units = selectedPieces();
              if (units.isEmpty || (units[0].isType(PieceType.militia) && units.length < _options.dismissMilitiaCount)) {
                setPrompt('Select Unit(s) to Dismiss');
                int militiaCount = 0;
                for (final unit in phaseState.candidateDismissCivilWarUnits(_state)) {
                  if (unit.isType(PieceType.militia)) {
                    militiaCount += 1;
                  } else {
                    if (units.isEmpty) {
                      pieceChoosable(unit);
                    }
                  }
                }
                if (units.length + militiaCount >= _options.dismissMilitiaCount) {
                  for (final unit in phaseState.candidateDismissCivilWarUnits(_state)) {
                    if (unit.isType(PieceType.militia)) {
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
              if (units.isEmpty) {
                setPrompt('Select Unit(s) to Demote');
                for (final unit in phaseState.candidateDemoteCivilWarUnits(_state)) {
                  pieceChoosable(unit);
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
                logLine('>China is Disgraced.');
              }
              adjustUnrest(1);
              phaseState.lossCount -= 1;
              phaseState.disgraceCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossPrestige)) {
              if (phaseState.dishonorCount == 0) {
                logLine('>China is Dishonored.');
              }
              adjustPrestige(-1);
              phaseState.lossCount -= 1;
              phaseState.dishonorCount += 1;
              clearChoices();
            } else if (checkChoice(Choice.lossTribute)) {
              if (phaseState.tributeCount == 0) {
                logLine('>China offers Tribute.');
              }
              adjustCash(-_options.tributeAmount);
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
          if (phaseState.deadRuler != null) {
            newRuler(phaseState.deadRuler!, DeathCause.rebelGovernorVictory, phaseState.command!);
          }
          phaseState.warComplete(_state, true);
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
    for (final statesman in _state.piecesInLocation(PieceType.statesman, Location.boxExile)) {
      _state.setPieceLocation(statesman, Location.boxStatesmen);
    }
	  _state.advanceTurn();
  }

  void playInSequence() {

    final stepHandlers = [
      turnBegin,
      eventPhaseBegin,
      eventPhaseRemoveEventCounters,
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
      treasuryPhaseTax,
      treasuryPhaseTaxComplete,
      treasuryPhasePay,
      treasuryPhasePayComplete,
      treasuryPhaseExtraTaxes,
      treasuryPhaseMoveWarsInit,
      treasuryPhaseMoveCurrentWars,
      treasuryPhaseNewWarCount,
      treasuryPhaseDrawAndMoveNewWars,
      treasuryPhaseCheckDefeat,
      unrestPhaseBegin,
      unrestPhaseIncreaseUnrest,
      unrestPhaseDrawStatesmen,
      unrestPhaseAnnex,
      unrestPhaseAppointCommanders,
      unrestPhaseAdjustPrestige,
      unrestPhaseAdjustPrestigeMandateOfHeaven,
      unrestPhaseAdjustUnrest,
      unrestPhaseAdjustUnrestMandateOfHeaven,
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

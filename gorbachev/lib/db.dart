import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class GameDatabase {
  static final GameDatabase instance = GameDatabase._instance();

  Database? _database;

  GameDatabase._instance();

  Future<Database> _initializeDatabase() async {
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(appDocumentsDir.path, 'Gorbachev', 'gorbachev.db');
    if (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      final database = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _createDatabase,
        ),
      );
      return database;
    } else if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      final database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: _createDatabase,
      );
      return database;
    }
    throw Exception('Unsupported database platform');
  }

  static Future<void> _createDatabase(Database database, int version) async {
    await database.transaction((txn) async {   
      await txn.execute('''
        CREATE TABLE IF NOT EXISTS sequence(
          sequenceName STRING NOT NULL,
          maximumSequenceId INTEGER NOT NULL,
          PRIMARY KEY (sequenceName)
        ) WITHOUT ROWID
      ''');

      await txn.execute('''
        INSERT OR IGNORE INTO sequence(sequenceName, maximumSequenceId) VALUES('gameId', 0)
      ''');

      await txn.execute('''
        CREATE TABLE IF NOT EXISTS gameSnapshot(
          gameId INTEGER NOT NULL,
          sequence INTEGER NOT NULL,
          stateJson TEXT NOT NULL,
          step INTEGER NOT NULL,
          subStep INTEGER NOT NULL,
          stage TEXT NOT NULL,
          logLength INTEGER NOT NULL,
          PRIMARY KEY(gameId, sequence)
        ) WITHOUT ROWID
      ''');

      await txn.execute('''
        CREATE TABLE IF NOT EXISTS gameInProgress(
          gameId INTEGER NOT NULL,
          scenario INTEGER NOT NULL,
          optionsJson TEXT NOT NULL,
          startTime INTEGER NOT NULL,
          updateTime INTEGER NOT NULL,
          currentSequence INTEGER NOT NULL,
          gameJson TEXT NOT NULL,
          log TEXT NOT NULL,
          PRIMARY KEY(gameId)
        ) WITHOUT ROWID
      ''');

      await txn.execute('''
        CREATE TABLE IF NOT EXISTS gameCompleted(
          gameId INTEGER NOT NULL,
          scenario INTEGER NOT NULL,
          optionsJson TEXT NOT NULL,
          startTime INTEGER NOT NULL,
          finishTime INTEGER NOT NULL,
          maximumSequence INTEGER NOT NULL,
          outcomeJson TEXT NOT NULL,
          log TEXT NOT NULL,
          PRIMARY KEY(gameId)
        ) WITHOUT ROWID
      ''');
    });
  }

  Future<Database> get _db async {
    _database ??= await _initializeDatabase();
    return _database!;
  }

  void initialize() async {
    await _db;
  }

  Future<int> createGame(int scenario, String optionsJson, String stateJson) async {
    int startTime = DateTime.timestamp().millisecondsSinceEpoch;
    Database db = await _db;
    int gameId = 0;
    await db.transaction((txn) async {
      final records = await txn.rawQuery(
        'SELECT maximumSequenceId FROM sequence WHERE sequenceName = ?',
        ['gameId']);
      gameId = records.first['maximumSequenceId'] as int;
      gameId += 1;
      await txn.execute(
        'UPDATE sequence SET maximumSequenceId = ?',
        [gameId]);
      await txn.rawInsert(
        'INSERT INTO gameInProgress(gameId, scenario, optionsJson, startTime, updateTime, currentSequence, gameJson, log) VALUES(?, ?, ?, ?, ?, ?, ?, ?)',
        [gameId, scenario, optionsJson, startTime, startTime, 0, '', '']);
      await txn.rawInsert(
        'INSERT INTO gameSnapshot(gameId, sequence, stateJson, step, subStep, stage, logLength) VALUES(?, ?, ?, ?, ?, ?, ?)',
        [gameId, 0, stateJson, 0, 0, '', 0]);
    });
    return gameId;
  }

  Future<void> appendGameSnapshot(int gameId, String stateJson, int step, int subStep, String stage, String log) async {
    int updateTime = DateTime.timestamp().millisecondsSinceEpoch;
    Database db = await _db;
    await db.transaction((txn) async {
      final records = await txn.rawQuery(
        'SELECT currentSequence FROM gameInProgress WHERE gameId = ?',
        [gameId]);
      int sequence = records.first['currentSequence'] as int;
      sequence += 1;
      await txn.execute(
        'DELETE FROM gameSnapshot WHERE gameId = ? AND sequence = ?',
        [gameId, -1]);
      await txn.rawInsert(
        'INSERT INTO gameSnapshot(gameId, sequence, stateJson, step, subStep, stage, logLength) VALUES(?, ?, ?, ?, ?, ?, ?)',
        [gameId, sequence, stateJson, step, subStep, stage, log.length]);
      await txn.execute(
        'UPDATE gameInProgress SET updateTime = ?, currentSequence = ?, gameJson = ?, log = ? WHERE gameId = ?',
        [updateTime, sequence, '', log, gameId]);
    });
  }

  Future<void> setGameState(int gameId, String stateJson, int step, int subStep, String stage, String gameJson, String log) async {
    int updateTime = DateTime.timestamp().millisecondsSinceEpoch;
    Database db = await _db;
    await db.transaction((txn) async {
      await txn.rawInsert(
        'INSERT OR REPLACE INTO gameSnapshot(gameId, sequence, stateJson, step, subStep, stage, logLength) VALUES(?, ?, ?, ?, ?, ?, ?)',
         [gameId, -1, stateJson, step, subStep, stage, log.length]);
      await txn.execute(
        'UPDATE gameInProgress SET updateTime = ?, gameJson = ?, log = ? WHERE gameId = ?',
        [updateTime, gameJson, log, gameId]);
    });
  }

  Future<void> completeGame(int gameId, String outcomeJson) async {
    int finishTime = DateTime.timestamp().millisecondsSinceEpoch;
    Database db = await _db;
    await db.transaction((txn) async {
      await txn.execute(
        'DELETE FROM gameSnapshot WHERE gameId = ? and sequence = ?',
        [gameId, -1]);
      await txn.execute(
        'INSERT INTO gameCompleted (gameId, scenario, optionsJson, startTime, finishTime, maximumSequence, outcomeJson, log) SELECT gameId, scenario, optionsJson, startTime, ?, currentSequence, ?, log FROM gameInProgress WHERE gameId = ?',
        [finishTime, outcomeJson, gameId]);
      await txn.execute(
        'DELETE FROM gameInProgress WHERE gameId = ?',
        [gameId]);
    });
  }

  Future<int> duplicateGame(int gameId) async {
    int updateTime = DateTime.timestamp().millisecondsSinceEpoch;
    Database db = await _db;
    int newGameId = 0;
    await db.transaction((txn) async {
      final records = await txn.rawQuery(
        'SELECT maximumSequenceId FROM sequence WHERE sequenceName = ?',
        ['gameId']);
      newGameId = records.first['maximumSequenceId'] as int;
      newGameId += 1;
      await txn.execute(
        'UPDATE sequence SET maximumSequenceId = ?',
        [newGameId]);
      await txn.execute(
        'INSERT INTO gameSnapshot (gameId, sequence, stateJson, step, subStep, stage, logLength) SELECT ?, sequence, stateJson, step, subStep, stage, logLength FROM gameSnapshot WHERE gameId = ?',
        [newGameId, gameId]);
      await txn.execute(
        'INSERT INTO gameInProgress (gameId, scenario, optionsJson, startTime, updateTime, currentSequence, gameJson, log) SELECT ?, scenario, optionsJson, startTime, ?, currentSequence, gameJson, log FROM gameInProgress WHERE gameId = ?',
        [newGameId, updateTime, gameId]);
    });
    return newGameId;
  }

  Future<void> deleteGame(int gameId) async {
    Database db = await _db;
    await db.transaction((txn) async {
      await txn.execute(
        'DELETE FROM gameSnapshot WHERE gameId = ?',
        [gameId]);
      await txn.execute(
        'DELETE FROM gameInProgress WHERE gameId = ?',
        [gameId]);
      await txn.execute(
        'DELETE FROM gameCompleted WHERE gameId = ?',
        [gameId]);
    });
  }

  Future<List<Map<String, dynamic>>> fetchGameInProgressList() async {
    Database db = await _db;
    return await db.rawQuery('''
      SELECT g.gameId, g.scenario, g.optionsJson, g.startTime, g.updateTime, s.stage
      FROM gameInProgress g, gameSnapshot s
      WHERE s.gameId = g.gameId AND s.sequence = -1
      ORDER BY updateTime DESC
    ''');
  }

  Future<Map<String, dynamic>> fetchGameInProgress(int gameId) async {
    Database db = await _db;
    final records = await db.rawQuery('''
      SELECT g.scenario, g.optionsJson, g.gameJson, g.log, s.stateJson, s.step, s.subStep
      FROM gameInProgress g, gameSnapshot s
      WHERE g.gameId = ? AND s.gameId = g.gameId AND s.sequence = -1
    ''',
    [gameId]);
    return records.first;    
  }
}

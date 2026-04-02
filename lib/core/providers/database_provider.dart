import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'lastsub.db');

  return await openDatabase(
    path,
    version: 8,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE tasks (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          iconName TEXT,
          colorCode TEXT,
          isActive INTEGER NOT NULL DEFAULT 1,
          isPremiumLocked INTEGER NOT NULL DEFAULT 0,
          "order" INTEGER NOT NULL DEFAULT 0,
          lastRecordedAt TEXT,
          recommendedIntervalDays INTEGER,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE task_records (
          id TEXT PRIMARY KEY,
          taskId TEXT NOT NULL,
          recordedAt TEXT NOT NULL,
          startedAt TEXT,
          value REAL,
          unit TEXT,
          memo TEXT,
          isActive INTEGER NOT NULL DEFAULT 1,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE growth_records (
          id TEXT PRIMARY KEY,
          userId TEXT NOT NULL,
          recordedAt TEXT NOT NULL,
          height REAL,
          weight REAL,
          headCircumference REAL,
          vaccinationName TEXT,
          memo TEXT,
          isActive INTEGER NOT NULL DEFAULT 1,
          updatedAt TEXT NOT NULL
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        try { await db.execute('ALTER TABLE task_records ADD COLUMN isActive INTEGER NOT NULL DEFAULT 1'); } catch (_) {}
        try { await db.execute('ALTER TABLE task_records ADD COLUMN updatedAt TEXT NOT NULL DEFAULT ""'); } catch (_) {}
        try { await db.execute('ALTER TABLE tasks ADD COLUMN isActive INTEGER NOT NULL DEFAULT 1'); } catch (_) {}
        try { await db.execute('ALTER TABLE tasks ADD COLUMN updatedAt TEXT NOT NULL DEFAULT ""'); } catch (_) {}
        try { await db.execute('ALTER TABLE tasks ADD COLUMN lastRecordedAt TEXT'); } catch (_) {}
      }
      if (oldVersion < 3) {
        try { await db.execute('ALTER TABLE tasks ADD COLUMN isActive INTEGER NOT NULL DEFAULT 1'); } catch (_) {}
        try { await db.execute('ALTER TABLE tasks ADD COLUMN updatedAt TEXT NOT NULL DEFAULT ""'); } catch (_) {}
        try { await db.execute('ALTER TABLE tasks ADD COLUMN lastRecordedAt TEXT'); } catch (_) {}
        try {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS growth_records (
              id TEXT PRIMARY KEY,
              userId TEXT NOT NULL,
              recordedAt TEXT NOT NULL,
              height REAL,
              weight REAL,
              headCircumference REAL,
              vaccinationName TEXT,
              memo TEXT,
              isActive INTEGER NOT NULL DEFAULT 1,
              updatedAt TEXT NOT NULL
            )
          ''');
        } catch (_) {}
      }
      if (oldVersion < 4) {
        try { await db.execute('ALTER TABLE tasks ADD COLUMN isPremiumLocked INTEGER NOT NULL DEFAULT 0'); } catch (_) {}
      }
      if (oldVersion < 5) {
        try { await db.execute('ALTER TABLE tasks ADD COLUMN "order" INTEGER NOT NULL DEFAULT 0'); } catch (_) {}
      }
      if (oldVersion < 6) {
        try { await db.execute('ALTER TABLE tasks ADD COLUMN "order" INTEGER NOT NULL DEFAULT 0'); } catch (_) {}
      }
      if (oldVersion < 7) {
        try { await db.execute('ALTER TABLE task_records ADD COLUMN startedAt TEXT'); } catch (_) {}
      }
      if (oldVersion < 8) {
        // v8: 推奨間隔（日数）カラム追加
        try { await db.execute('ALTER TABLE tasks ADD COLUMN recommendedIntervalDays INTEGER'); } catch (_) {}
      }
    },
  );
});

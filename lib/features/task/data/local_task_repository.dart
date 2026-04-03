import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../domain/task_entity.dart';
import '../domain/task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final Database _db;

  final StreamController<List<TaskEntity>> _tasksController =
      StreamController<List<TaskEntity>>.broadcast();

  LocalTaskRepository._(this._db);

  static Future<LocalTaskRepository> create(Database db) async {
    final repo = LocalTaskRepository._(db);
    await repo._initialize();
    return repo;
  }

  Future<void> _initialize() async {
    await _ensureTableExists();
  }

  Future<void> _ensureTableExists() async {
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS tasks(
        id TEXT PRIMARY KEY,
        title TEXT,
        iconName TEXT,
        colorCode TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        lastRecordedAt TEXT,
        isActive INTEGER,
        isPremiumLocked INTEGER,
        "order" INTEGER NOT NULL DEFAULT 0,
        recommendedIntervalDays INTEGER
      )
    ''');
  }

  Future<List<TaskEntity>> _fetchTasks() async {
    final maps = await _db.query(
      'tasks',
      where: 'isActive = ?',
      whereArgs: [1],
      orderBy: '"order" ASC, createdAt ASC',
    );
    return maps.map(_mapRowToEntity).toList();
  }

  TaskEntity _mapRowToEntity(Map<String, dynamic> m) {
    final fixed = Map<String, dynamic>.from(m);
    fixed['isActive'] = (m['isActive'] == 1);
    fixed['isPremiumLocked'] = (m['isPremiumLocked'] == 1);
    fixed['order'] = (m['order'] as int?) ?? 0;
    // recommendedIntervalDays は INTEGER | NULL なのでそのまま渡す
    fixed['recommendedIntervalDays'] = m['recommendedIntervalDays'] as int?;
    return TaskEntity.fromJson(fixed);
  }

  Future<void> notifyWatchers() async {
    if (!_tasksController.isClosed) {
      _tasksController.add(await _fetchTasks());
    }
  }

  @override
  Stream<List<TaskEntity>> watchAllTasks() async* {
    yield await _fetchTasks();
    yield* _tasksController.stream;
  }

  @override
  Future<void> saveTask(TaskEntity task) async {
    final json = task.toJson();
    json['isActive'] = task.isActive ? 1 : 0;
    json['isPremiumLocked'] = task.isPremiumLocked ? 1 : 0;
    json['order'] = task.order;
    json['recommendedIntervalDays'] = task.recommendedIntervalDays;

    await _db.insert(
      'tasks',
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await notifyWatchers();
  }

  @override
  Future<void> deleteTask(String id) async {
    await _db.update(
      'tasks',
      {
        'isActive': 0,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    await notifyWatchers();
  }

  @override
  Future<void> updateLastRecordedAt(String id, DateTime recordedAt) async {
    await _db.update(
      'tasks',
      {
        'lastRecordedAt': recordedAt.toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    await notifyWatchers();
  }

  @override
  Future<void> resetLastRecordedAt(String id) async {
    await _db.update(
      'tasks',
      {
        'lastRecordedAt': null,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    await notifyWatchers();
  }

  /// 推奨間隔を更新する
  Future<void> updateRecommendedInterval(String id, int? days) async {
    await _db.update(
      'tasks',
      {
        'recommendedIntervalDays': days,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    await notifyWatchers();
  }

  Future<List<TaskEntity>> getTasksUpdatedAfter(DateTime timestamp) async {
    final maps = await _db.query(
      'tasks',
      where: 'updatedAt > ?',
      whereArgs: [timestamp.toIso8601String()],
    );
    return maps.map(_mapRowToEntity).toList();
  }

  Future<void> upsertTasks(List<TaskEntity> tasks) async {
    if (tasks.isEmpty) return;
    await _db.transaction((txn) async {
      final batch = txn.batch();
      for (final t in tasks) {
        final json = t.toJson();
        json['isActive'] = t.isActive ? 1 : 0;
        json['isPremiumLocked'] = t.isPremiumLocked ? 1 : 0;
        batch.insert('tasks', json, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
    await notifyWatchers();
  }

  Future<void> updateTaskOrder(List<TaskEntity> tasks) async {
    await _db.transaction((txn) async {
      for (var i = 0; i < tasks.length; i++) {
        await txn.update(
          'tasks',
          {'order': i, 'updatedAt': DateTime.now().toIso8601String()},
          where: 'id = ?',
          whereArgs: [tasks[i].id],
        );
      }
    });
    await notifyWatchers();
  }

  void dispose() {
    _tasksController.close();
  }
}

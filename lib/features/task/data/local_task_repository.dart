import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
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
    await _ensureInitialTasks();
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

  static const _defaultTasks = [
    ('task-default-milk',         'ミルク',                  0),
    ('task-default-breast-right', '母乳　右',                1),
    ('task-default-breast-left',  '母乳　左',                2),
    ('task-default-diaper-pee',   'オムツ替え（おしっこ）',  3),
    ('task-default-diaper-poo',   'オムツ替え（うんち）',    4),
    ('task-default-sleep',        '睡眠',                    5),
    ('task-default-sterilize',    '哺乳瓶消毒',              6),
    ('task-default-bath',         'お風呂',                  7),
  ];

  Future<void> _ensureInitialTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    final existing = await _db.query('tasks', columns: ['title']);
    final existingTitles = existing.map((r) => r['title'] as String).toSet();

    for (final (id, title, order) in _defaultTasks) {
      if (existingTitles.contains(title)) continue;

      final task = TaskEntity(
        id: id,
        title: title,
        order: order,
        createdAt: now,
        updatedAt: now,
        isActive: true,
      );
      final json = task.toJson();
      json['isActive'] = 1;
      json['isPremiumLocked'] = 0;
      json['order'] = order;
      json.remove('recommendedIntervalDays'); // null はそのまま省略

      await _db.insert('tasks', json, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    await prefs.setStringList(
      'initial_task_ids',
      _defaultTasks.map((t) => t.$1).toList(),
    );
    await prefs.setBool('tasks_initialized', true);
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

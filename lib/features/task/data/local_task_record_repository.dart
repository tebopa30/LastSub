import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../domain/task_record_entity.dart';
import '../domain/task_record_repository.dart';
import 'local_task_repository.dart';

class LocalTaskRecordRepository implements TaskRecordRepository {
  final Database _db;

  /// Taskの一覧も更新するため、同一プロセスのLocalTaskRepositoryの参照を持つか
  /// 状態更新を呼び出せるインターフェースを受け取ります。
  final LocalTaskRepository _taskRepo;

  final _recordsController =
      StreamController<List<TaskRecordEntity>>.broadcast();

  LocalTaskRecordRepository(this._db, this._taskRepo);

  /// 特定のtaskIdに紐づくレコード配列をストリームに流す（再取得）
  Future<void> _notifyWatchersForTask(String taskId) async {
    final maps = await _db.query(
      'task_records',
      where: 'taskId = ? AND isActive = 1',
      whereArgs: [taskId],
      orderBy: 'recordedAt DESC',
    );
    _recordsController.add(maps.map((m) {
      final fixed = Map<String, dynamic>.from(m);
      fixed['isActive'] = m['isActive'] == 1;
      return TaskRecordEntity.fromJson(fixed);
    }).toList());
  }

  @override
  Stream<List<TaskRecordEntity>> watchRecordsForTask(String taskId) async* {
    // 購読開始時に一度初期データを流す
    await _notifyWatchersForTask(taskId);

    // 特定のタスクのデータをフィルタリングしてyield
    yield* _recordsController.stream.map((records) {
      return records.where((r) => r.taskId == taskId).toList();
    });
  }

  @override
  Future<void> addRecord(TaskRecordEntity record) async {
    // 単一のトランザクションとしてINSERTとUPDATEを一体化する
    try {
      debugPrint(
          'LocalTaskRecordRepository: addRecord for taskId: ${record.taskId}');
      await _db.transaction((txn) async {
        // TaskRecordを新規挿入
        final json = record.toJson();
        json['isActive'] = record.isActive ? 1 : 0;
        await txn.insert(
          'task_records',
          json,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }); // ここでコミット。失敗時は自動ロールバックされる
    } catch (e, stack) {
      debugPrint('LocalTaskRecordRepository: addRecord FAILED: $e');
      debugPrint(stack.toString());
      rethrow;
    }

    // 成功後、それぞれのStreamへ通知を行う
    await _notifyWatchersForTask(record.taskId);
    await _taskRepo.notifyWatchers();
  }

  @override
  Future<void> deleteRecord(String recordId) async {
    // 削除対象のtaskIdを取得しておく
    final maps = await _db.query('task_records',
        columns: ['taskId'], where: 'id = ?', whereArgs: [recordId]);
    if (maps.isEmpty) return;
    final taskId = maps.first['taskId'] as String;

    await _db.update(
      'task_records',
      {
        'isActive': 0,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [recordId],
    );
    await _notifyWatchersForTask(taskId);
  }

  @override
  Future<void> updateRecord(TaskRecordEntity record) async {
    final json = record.toJson();
    json['isActive'] = record.isActive ? 1 : 0;
    await _db.update(
      'task_records',
      json,
      where: 'id = ?',
      whereArgs: [record.id],
    );
    await _notifyWatchersForTask(record.taskId);
    await _taskRepo.notifyWatchers();
  }

  @override
  Future<List<TaskRecordEntity>> fetchRecentRecords(
      {required DateTime since}) async {
    final maps = await _db.query(
      'task_records',
      where: 'recordedAt >= ? AND isActive = 1',
      whereArgs: [since.toIso8601String()],
      orderBy: 'recordedAt DESC',
    );
    return maps.map((m) {
      final fixed = Map<String, dynamic>.from(m);
      fixed['isActive'] = m['isActive'] == 1;
      return TaskRecordEntity.fromJson(fixed);
    }).toList();
  }

  /// 過去X日分のレコードを監視するStream
  Stream<List<TaskRecordEntity>> watchRecentRecords(
      {required DateTime since}) async* {
    // 最初の1発目
    yield await fetchRecentRecords(since: since);

    // 以降はローカルDBが更新されるたびに fetchRecentRecords を流す
    // _isFetching フラグで前回の取得が完了する前に次のイベントが来ても
    // DB クエリが二重並走しないよう制御（switchMap 相当）
    bool isFetching = false;
    await for (final _ in _recordsController.stream) {
      if (isFetching) continue;
      isFetching = true;
      try {
        yield await fetchRecentRecords(since: since);
      } finally {
        isFetching = false;
      }
    }
  }

  @override
  Future<List<TaskRecordEntity>> fetchRecordsByPeriod(
      String taskId, DateTime start, DateTime end) async {
    final maps = await _db.query(
      'task_records',
      where:
          'taskId = ? AND recordedAt >= ? AND recordedAt <= ? AND isActive = 1',
      whereArgs: [taskId, start.toIso8601String(), end.toIso8601String()],
      orderBy: 'recordedAt ASC',
    );
    return maps.map((m) {
      final fixed = Map<String, dynamic>.from(m);
      fixed['isActive'] = m['isActive'] == 1;
      return TaskRecordEntity.fromJson(fixed);
    }).toList();
  }

  /// 同期用: 特定日時以降に更新された全レコード（論理削除済みも含む）を取得
  Future<List<TaskRecordEntity>> getRecordsUpdatedAfter(
      DateTime timestamp) async {
    final maps = await _db.query(
      'task_records',
      where: 'updatedAt > ?',
      whereArgs: [timestamp.toIso8601String()],
    );
    return maps.map((m) {
      final fixed = Map<String, dynamic>.from(m);
      fixed['isActive'] = m['isActive'] == 1;
      return TaskRecordEntity.fromJson(fixed);
    }).toList();
  }

  void dispose() {
    _recordsController.close();
  }

  /// 同期用: FirestoreからPullしたレコード群をまとめて上書き保存（Upsert）
  Future<void> upsertRecords(List<TaskRecordEntity> records) async {
    if (records.isEmpty) return;

    await _db.transaction((txn) async {
      final batch = txn.batch();
      for (final r in records) {
        final json = r.toJson();
        json['isActive'] = r.isActive ? 1 : 0;
        batch.insert('task_records', json,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
    // 関連する taskId を抽出して通知を送る
    final taskIds = records.map((r) => r.taskId).toSet();
    for (final taskId in taskIds) {
      await _notifyWatchersForTask(taskId);
    }
  }
}

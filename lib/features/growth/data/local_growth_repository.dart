import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../domain/growth_record_entity.dart';

class LocalGrowthRepository {
  final Database _db;
  final _recordsController = StreamController<List<GrowthRecordEntity>>.broadcast();

  LocalGrowthRepository(this._db);

  /// SQLite は bool を扱えないため isActive を int(1/0) に変換して挿入する
  Map<String, dynamic> _toSqliteMap(GrowthRecordEntity record) {
    final map = record.toJson();
    map['isActive'] = record.isActive ? 1 : 0;
    return map;
  }

  /// SQLite から取得した map の isActive (int) を bool に変換してからデシリアライズする
  GrowthRecordEntity _fromSqliteMap(Map<String, dynamic> map) {
    final m = Map<String, dynamic>.from(map);
    final raw = m['isActive'];
    if (raw is int) m['isActive'] = raw != 0;
    return GrowthRecordEntity.fromJson(m);
  }

  /// データベース更新後にリスナーへ通知する
  Future<void> _notifyWatchers(String userId) async {
    final records = await fetchRecordsByUser(userId);
    _recordsController.add(records);
  }

  /// 指定UIDのレコードをすべて取得（移行・同期用）
  Future<List<GrowthRecordEntity>> fetchAllRecordsByUser(String userId) async {
    final maps = await _db.query(
      'growth_records',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map(_fromSqliteMap).toList();
  }

  /// 指定時刻以降に更新されたレコードを取得（増分同期用）
  Future<List<GrowthRecordEntity>> getRecordsUpdatedAfter(String userId, DateTime since) async {
    final maps = await _db.query(
      'growth_records',
      where: 'userId = ? AND updatedAt > ?',
      whereArgs: [userId, since.toIso8601String()],
    );
    return maps.map(_fromSqliteMap).toList();
  }

  /// 指定UIDの有効な(isActive=1)レコードを新しい順に取得
  Future<List<GrowthRecordEntity>> fetchRecordsByUser(String userId) async {
    final maps = await _db.query(
      'growth_records',
      where: 'userId = ? AND isActive = 1',
      whereArgs: [userId],
      orderBy: 'recordedAt DESC',
    );
    return maps.map(_fromSqliteMap).toList();
  }

  /// Riverpod ストリーム用: 該当UIDの成長記録をリアルタイム監視
  Stream<List<GrowthRecordEntity>> watchRecords(String userId) async* {
    yield await fetchRecordsByUser(userId);
    yield* _recordsController.stream;
  }

  /// 成長レコードの追加/保存
  Future<void> saveRecord(GrowthRecordEntity record) async {
    debugPrint('LocalGrowthRepository.saveRecord: id=${record.id} userId=${record.userId} recordedAt=${record.recordedAt}');
    final rowId = await _db.insert(
      'growth_records',
      _toSqliteMap(record),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('LocalGrowthRepository.saveRecord: inserted rowId=$rowId');
    await _notifyWatchers(record.userId);
  }

  /// 複数のレコードを一括保存（Firestore同期等で使用）
  Future<void> upsertRecords(List<GrowthRecordEntity> records) async {
    if (records.isEmpty) return;
    debugPrint('LocalGrowthRepository.upsertRecords: count=${records.length} userId=${records.first.userId}');
    final batch = _db.batch();
    for (var r in records) {
      batch.insert('growth_records', _toSqliteMap(r), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
    await _notifyWatchers(records.first.userId);
  }

  /// 論理削除する
  Future<void> deleteRecord(String id, String userId) async {
    debugPrint('LocalGrowthRepository.deleteRecord: id=$id userId=$userId');
    final now = DateTime.now().toIso8601String();
    await _db.update(
      'growth_records',
      {'isActive': 0, 'updatedAt': now},
      where: 'id = ?',
      whereArgs: [id],
    );
    await _notifyWatchers(userId);
  }

  /// 指定したユーザーIDの全レコードを新しいユーザーIDに書き換える（サインイン時の移行用）
  Future<void> updateUserId(String oldId, String newId) async {
    debugPrint('LocalGrowthRepository.updateUserId: $oldId -> $newId');
    await _db.update(
      'growth_records',
      {'userId': newId},
      where: 'userId = ?',
      whereArgs: [oldId],
    );
    await _notifyWatchers(newId);
  }
}

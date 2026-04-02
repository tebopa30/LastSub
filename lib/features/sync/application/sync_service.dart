import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/application/auth_provider.dart';
import '../../task/data/local_task_repository.dart';
import '../../task/data/local_task_record_repository.dart';
import '../../task/domain/task_entity.dart';
import '../../task/domain/task_record_entity.dart';
import '../../growth/data/local_growth_repository.dart';
import '../../growth/domain/growth_record_entity.dart';
import '../../../core/providers/repository_providers.dart';
import '../domain/sync_exception.dart';

part 'sync_service.g.dart';

@riverpod
class SyncService extends _$SyncService {
  late FirebaseFirestore _firestore;

  @override
  FutureOr<void> build() {
    _firestore = FirebaseFirestore.instance;
  }

  /// 現在ログインしているユーザーのタスクとレコードを双方向同期する
  Future<void> syncAll() async {
    state = const AsyncValue.loading();
    try {
      // 認証状態を確認：ローディング中かどうか区別する
      final authAsync = ref.read(authStateProvider);
      if (authAsync.isLoading) {
        throw SyncException('auth_pending');
      }
      final uid = ref.read(currentUidProvider);
      if (uid == kLocalUserId) {
        throw SyncException('unauthenticated');
      }

      final prefs = await SharedPreferences.getInstance();
      
      final localTaskRepoAsync = ref.read(taskRepositoryProvider);
      if (!localTaskRepoAsync.hasValue) return;
      final localTaskRepo = localTaskRepoAsync.requireValue;
      
      final localRecordRepo = ref.read(taskRecordRepositoryProvider);
      final localGrowthRepo = await ref.read(localGrowthRepositoryProvider.future);

      await _syncTasks(uid, prefs, localTaskRepo);
      await _syncTaskRecords(uid, prefs, localRecordRepo);
      await _syncGrowthRecords(uid, prefs, localGrowthRepo);
      
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      final syncError = SyncException.fromError(e);
      state = AsyncValue.error(syncError, stack);
      // UI で catch してメッセージを表示できるように再送出
      throw syncError;
    }
  }

  Future<void> _syncTasks(String uid, SharedPreferences prefs, LocalTaskRepository localRepo) async {
    final lastSyncKey = 'last_sync_time_tasks_$uid';
    final lastSyncIso = prefs.getString(lastSyncKey);
    final lastSyncTime = lastSyncIso != null ? DateTime.parse(lastSyncIso) : DateTime.fromMillisecondsSinceEpoch(0);

    final syncStartTime = DateTime.now();

    // 1. Fetch Local changes
    final List<TaskEntity> localChanges = await localRepo.getTasksUpdatedAfter(lastSyncTime);
    final localMap = {for (var t in localChanges) t.id: t};

    // 2. Fetch Remote changes
    final tasksRef = _firestore.collection('users').doc(uid).collection('tasks');
    final remoteSnapshot = await tasksRef
        .where('updatedAt', isGreaterThan: lastSyncTime.toIso8601String())
        .get();

    final List<TaskEntity> remoteChanges = remoteSnapshot.docs.map((doc) {
      final data = doc.data();
      if (data['isActive'] is int) {
         data['isActive'] = (data['isActive'] == 1);
      }
      return TaskEntity.fromJson(data);
    }).toList();

    final List<TaskEntity> tasksToPull = [];
    final List<TaskEntity> tasksToPush = [];

    // 3. Conflict Resolution
    for (final remote in remoteChanges) {
      if (localMap.containsKey(remote.id)) {
        final local = localMap[remote.id]!;
        if (remote.updatedAt.isAfter(local.updatedAt)) {
          tasksToPull.add(remote);
          localMap.remove(remote.id);
        } else {
          tasksToPush.add(local);
        }
      } else {
        tasksToPull.add(remote);
      }
    }

    tasksToPush.addAll(localMap.values);

    // 4. Apply Pull
    if (tasksToPull.isNotEmpty) {
      await localRepo.upsertTasks(tasksToPull);
    }

    // 5. Apply Push
    if (tasksToPush.isNotEmpty) {
      final batch = _firestore.batch();
      for (final local in tasksToPush) {
        batch.set(tasksRef.doc(local.id), local.toJson());
      }
      await batch.commit();
    }

    // 6. Update Last Sync Time
    await prefs.setString(lastSyncKey, syncStartTime.toIso8601String());
  }

  Future<void> _syncTaskRecords(String uid, SharedPreferences prefs, LocalTaskRecordRepository localRepo) async {
    final lastSyncKey = 'last_sync_time_records_$uid';
    final lastSyncIso = prefs.getString(lastSyncKey);
    final lastSyncTime = lastSyncIso != null ? DateTime.parse(lastSyncIso) : DateTime.fromMillisecondsSinceEpoch(0);

    final syncStartTime = DateTime.now();

    // 1. Fetch Local changes
    final List<TaskRecordEntity> localChanges = await localRepo.getRecordsUpdatedAfter(lastSyncTime);
    final localMap = {for (var r in localChanges) r.id: r};

    // 2. Fetch Remote changes
    final recordsRef = _firestore.collection('users').doc(uid).collection('task_records');
    final remoteSnapshot = await recordsRef
        .where('updatedAt', isGreaterThan: lastSyncTime.toIso8601String())
        .get();

    final List<TaskRecordEntity> remoteChanges = remoteSnapshot.docs.map((doc) {
      final data = doc.data();
      if (data['isActive'] is int) {
         data['isActive'] = (data['isActive'] == 1);
      }
      return TaskRecordEntity.fromJson(data);
    }).toList();

    final List<TaskRecordEntity> recordsToPull = [];
    final List<TaskRecordEntity> recordsToPush = [];

    // 3. Conflict Resolution
    for (final remote in remoteChanges) {
      if (localMap.containsKey(remote.id)) {
        final local = localMap[remote.id]!;
        if (remote.updatedAt.isAfter(local.updatedAt)) {
          recordsToPull.add(remote);
          localMap.remove(remote.id);
        } else {
          recordsToPush.add(local);
        }
      } else {
        recordsToPull.add(remote);
      }
    }

    recordsToPush.addAll(localMap.values);

    // 4. Apply Pull
    if (recordsToPull.isNotEmpty) {
      await localRepo.upsertRecords(recordsToPull);
    }

    // 5. Apply Push
    if (recordsToPush.isNotEmpty) {
      final batch = _firestore.batch();
      for (final local in recordsToPush) {
        batch.set(recordsRef.doc(local.id), local.toJson());
      }
      await batch.commit();
    }

    // 6. Update Last Sync Time
    await prefs.setString(lastSyncKey, syncStartTime.toIso8601String());
  }

  Future<void> _syncGrowthRecords(String uid, SharedPreferences prefs, LocalGrowthRepository localRepo) async {
    final lastSyncKey = 'last_sync_time_growth_$uid';
    final lastSyncIso = prefs.getString(lastSyncKey);
    final lastSyncTime = lastSyncIso != null ? DateTime.parse(lastSyncIso) : DateTime.fromMillisecondsSinceEpoch(0);

    final syncStartTime = DateTime.now();

    // 1. Fetch Local changes
    final List<GrowthRecordEntity> localChanges = await localRepo.getRecordsUpdatedAfter(uid, lastSyncTime);
    final localMap = {for (var r in localChanges) r.id: r};

    // 2. Fetch Remote changes
    final recordsRef = _firestore.collection('users').doc(uid).collection('growth_records');
    final remoteSnapshot = await recordsRef
        .where('updatedAt', isGreaterThan: lastSyncTime.toIso8601String())
        .get();

    final List<GrowthRecordEntity> remoteChanges = remoteSnapshot.docs.map((doc) {
      final data = doc.data();
      if (data['isActive'] is int) {
         data['isActive'] = (data['isActive'] == 1);
      }
      return GrowthRecordEntity.fromJson(data);
    }).toList();

    final List<GrowthRecordEntity> recordsToPull = [];
    final List<GrowthRecordEntity> recordsToPush = [];

    // 3. Conflict Resolution
    for (final remote in remoteChanges) {
      if (localMap.containsKey(remote.id)) {
        final local = localMap[remote.id]!;
        if (remote.updatedAt.isAfter(local.updatedAt)) {
          recordsToPull.add(remote);
          localMap.remove(remote.id);
        } else {
          recordsToPush.add(local);
        }
      } else {
        recordsToPull.add(remote);
      }
    }

    recordsToPush.addAll(localMap.values);

    // 4. Apply Pull
    if (recordsToPull.isNotEmpty) {
      await localRepo.upsertRecords(recordsToPull);
    }

    // 5. Apply Push
    if (recordsToPush.isNotEmpty) {
      final batch = _firestore.batch();
      for (final local in recordsToPush) {
        batch.set(recordsRef.doc(local.id), local.toJson());
      }
      await batch.commit();
    }

    // 6. Update Last Sync Time
    await prefs.setString(lastSyncKey, syncStartTime.toIso8601String());
  }
}

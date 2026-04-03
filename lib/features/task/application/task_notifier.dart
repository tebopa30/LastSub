import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/repository_providers.dart';
import '../domain/task_entity.dart';
import '../domain/task_record_entity.dart';
import 'daily_stats_provider.dart';

part 'task_notifier.g.dart';

@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  Stream<List<TaskEntity>> build() {
    final repoAsync = ref.watch(taskRepositoryProvider);

    return repoAsync.when(
      data: (repo) => repo.watchAllTasks(),
      loading: () => const Stream.empty(),
      error: (err, stack) {
        debugPrint('[TaskNotifier] taskRepositoryProvider error: $err');
        return const Stream.empty();
      },
    );
  }

  /// タスク新規作成
  Future<void> createTask(
    String title, {
    String? iconName,
    String? colorCode,
    int? recommendedIntervalDays,
  }) async {
    final currentCount = state.value?.length ?? 0;
    if (currentCount >= 5) {
      throw Exception('タスクは最大5件まで追加できます');
    }

    final repo = await ref.read(taskRepositoryProvider.future);
    final now = DateTime.now();
    final task = TaskEntity(
      id: const Uuid().v4(),
      title: title,
      iconName: iconName,
      colorCode: colorCode,
      recommendedIntervalDays: recommendedIntervalDays,
      createdAt: now,
      updatedAt: now,
    );

    await repo.saveTask(task);
  }

  /// タスク開始（タイマー開始）: lastRecordedAt を現在時刻に更新
  Future<void> startTask(String taskId) async {
    final now = DateTime.now();
    final taskRepoAsync = ref.read(taskRepositoryProvider);
    if (taskRepoAsync.hasValue) {
      await taskRepoAsync.requireValue.updateLastRecordedAt(taskId, now);
    }

    final current = state.value;
    if (current != null) {
      state = AsyncData(current.map((task) {
        if (task.id != taskId) return task;
        return task.copyWith(lastRecordedAt: now, updatedAt: now);
      }).toList());
    }
  }

  /// タスクの実行記録
  Future<void> recordTaskExecution(
    String taskId, {
    double? value,
    String? unit,
    String? memo,
    DateTime? startedAt,
    bool keepLastRecordedAt = false,
  }) async {
    debugPrint('TaskNotifier: recordTaskExecution(taskId: $taskId)');
    final repo = ref.read(taskRecordRepositoryProvider);
    final now = DateTime.now();

    final record = TaskRecordEntity(
      id: const Uuid().v4(),
      taskId: taskId,
      recordedAt: now,
      startedAt: startedAt,
      value: value,
      unit: unit,
      memo: memo,
      createdAt: now,
      updatedAt: now,
    );

    await repo.addRecord(record);
    ref.invalidate(dailyStatsProvider);

    final taskRepoAsync = ref.read(taskRepositoryProvider);
    if (taskRepoAsync.hasValue) {
      if (keepLastRecordedAt) {
        await taskRepoAsync.requireValue.updateLastRecordedAt(taskId, now);
      } else {
        await taskRepoAsync.requireValue.resetLastRecordedAt(taskId);
      }
    }

    final newLastRecordedAt = keepLastRecordedAt ? now : null;
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.map((task) {
        if (task.id == taskId) {
          return task.copyWith(
            lastRecordedAt: newLastRecordedAt,
            updatedAt: now,
          );
        }
        return task;
      }).toList());
    }
  }

  /// 推奨間隔を更新する
  Future<void> updateRecommendedInterval(String taskId, int? days) async {
    final taskRepoAsync = ref.read(taskRepositoryProvider);
    if (!taskRepoAsync.hasValue) return;

    await taskRepoAsync.requireValue.updateRecommendedInterval(taskId, days);

    final current = state.value;
    if (current != null) {
      state = AsyncData(current.map((task) {
        if (task.id == taskId) {
          return task.copyWith(recommendedIntervalDays: days);
        }
        return task;
      }).toList());
    }
  }

  /// タスクの表示順を並び替える
  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    final current = state.value;
    if (current == null) return;

    final adjustedNew = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final reordered = List<TaskEntity>.from(current);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(adjustedNew, moved);

    state = AsyncData(reordered);

    final repoAsync = ref.read(taskRepositoryProvider);
    if (repoAsync.hasValue) {
      await repoAsync.requireValue.updateTaskOrder(reordered);
    }
  }

  /// タスク削除（論理削除）
  Future<void> deleteTask(String id) async {
    final repoAsync = ref.read(taskRepositoryProvider);
    if (repoAsync.hasValue) {
      await repoAsync.requireValue.deleteTask(id);
      ref.invalidate(dailyStatsProvider);
    }
  }
}

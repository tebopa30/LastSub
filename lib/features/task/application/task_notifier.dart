import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/providers/premium_provider.dart';
import '../../../core/services/breast_notification_service.dart';
import '../domain/task_entity.dart';
import '../domain/task_record_entity.dart';
import 'daily_stats_provider.dart';
import 'active_sessions_provider.dart';

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
    final isPremium = ref.read(isPremiumProvider);
    final limit = isPremium ? 15 : 5;
    if (currentCount >= limit) {
      throw Exception('タスクは最大$limit件まで追加できます');
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

  /// タスク開始: セッション開始時刻を記録する（lastRecordedAt は変更しない）
  Future<void> startTask(String taskId) async {
    ref.read(activeSessionsProvider.notifier).startSession(taskId);
  }

  /// タスクの実行記録。セッション開始時刻は activeSessionsProvider から自動取得。
  Future<void> recordTaskExecution(
    String taskId, {
    double? value,
    String? unit,
    String? memo,
  }) async {
    debugPrint('TaskNotifier: recordTaskExecution(taskId: $taskId)');

    // セッションを終了し、開始時刻を取得
    final sessionStart =
        ref.read(activeSessionsProvider.notifier).endSession(taskId);

    final repo = ref.read(taskRecordRepositoryProvider);
    final now = DateTime.now();

    final record = TaskRecordEntity(
      id: const Uuid().v4(),
      taskId: taskId,
      recordedAt: now,
      startedAt: sessionStart,
      value: value,
      unit: unit,
      memo: memo,
      createdAt: now,
      updatedAt: now,
    );

    await repo.addRecord(record);
    ref.invalidate(dailyStatsProvider);

    // 記録完了時刻を lastRecordedAt として保存（次のサイクルの起点）
    final taskRepoAsync = ref.read(taskRepositoryProvider);
    if (taskRepoAsync.hasValue) {
      await taskRepoAsync.requireValue.updateLastRecordedAt(taskId, now);
    }

    final current = state.value;
    if (current != null) {
      state = AsyncData(current.map((task) {
        if (task.id == taskId) {
          return task.copyWith(lastRecordedAt: now, updatedAt: now);
        }
        return task;
      }).toList());
    }

    // 推奨間隔が設定されていれば次のサイクルの通知をスケジュール
    final task = state.value?.where((t) => t.id == taskId).firstOrNull;
    final interval = task?.recommendedIntervalDays;
    if (task != null && interval != null && interval > 0) {
      await BreastNotificationService.instance
          .scheduleIntervalAlert(taskId, task.title, interval);
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

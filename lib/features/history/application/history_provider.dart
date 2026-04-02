import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';

import '../../task/domain/task_entity.dart';
import '../../task/domain/task_record_entity.dart';
import '../../../core/providers/repository_providers.dart';

part 'history_provider.g.dart';

class HistoryItem {
  final TaskRecordEntity record;
  final TaskEntity task;

  /// 前回（この日の前の記録、または同時刻より前の最新記録）との時間差
  final Duration? interval;

  HistoryItem({
    required this.record,
    required this.task,
    this.interval,
  });
}

/// 同じ日付・同じタスクの記録をグループ化したもの
class GroupedTaskItem {
  final TaskEntity task;

  /// 古い順にソートされた記録リスト（1回目、2回目…の順）
  final List<HistoryItem> items;

  GroupedTaskItem({required this.task, required this.items});

  int get count => items.length;
}

@riverpod
class HistoryPeriod extends _$HistoryPeriod {
  @override
  int? build() => 7; // デフォルトは7日間

  void setPeriod(int? days) => state = days;
}

@Riverpod(name: 'historyNotifierProvider', keepAlive: true)
class HistoryNotifier extends _$HistoryNotifier {
  @override
  bool build() => true;

  /// 指定レコードを論理削除する
  Future<void> deleteRecord(String recordId) async {
    final repo = ref.read(taskRecordRepositoryProvider);
    await repo.deleteRecord(recordId);
  }

  /// 指定レコードの値（容量など）を更新する
  Future<void> updateRecordValue(TaskRecordEntity record, double newValue) async {
    final updated = record.copyWith(
      value: newValue,
      updatedAt: DateTime.now(),
    );
    final repo = ref.read(taskRecordRepositoryProvider);
    await repo.updateRecord(updated);
  }

  /// 指定レコードの実行時刻を更新する
  Future<void> updateRecordTimestamp(
    TaskRecordEntity record,
    DateTime newTimestamp,
  ) async {
    final updated = record.copyWith(
      recordedAt: newTimestamp,
      updatedAt: DateTime.now(),
    );
    final repo = ref.read(taskRecordRepositoryProvider);
    await repo.updateRecord(updated);
  }
}

@riverpod
Stream<List<TaskEntity>> allTasksStream(Ref ref) async* {
  final repoAsync = ref.watch(taskRepositoryProvider);
  if (repoAsync.hasValue) {
    yield* repoAsync.requireValue.watchAllTasks();
  } else {
    yield [];
  }
}

@riverpod
Stream<List<TaskRecordEntity>> recentRecordsStream(Ref ref) async* {
  final repo = ref.watch(taskRecordRepositoryProvider);
  final days = ref.watch(historyPeriodProvider);

  // days が null の場合は全期間（便宜上 2000/01/01 以降とする）
  final since = days != null
      ? DateTime.now().subtract(Duration(days: days))
      : DateTime(2000);

  yield* repo.watchRecentRecords(since: since);
}

@riverpod
Map<String, List<HistoryItem>> historyGrouped(Ref ref) {
  final tasks = ref.watch(allTasksStreamProvider).value ?? [];
  final records = ref.watch(recentRecordsStreamProvider).value ?? [];

  // マップ作成を高速化
  final taskMap = {for (var t in tasks) t.id: t};

  // タスクIDごとに前回実行時刻を保持し、同じタスクの間隔を計算する
  final sortedRecords = List<TaskRecordEntity>.from(records)
    ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

  final Map<String, Duration?> intervals = {};
  final Map<String, DateTime> lastTimesPerTask = {};
  for (final r in sortedRecords) {
    final prevTime = lastTimesPerTask[r.taskId];
    if (prevTime != null) {
      intervals[r.id] = r.recordedAt.difference(prevTime);
    }
    lastTimesPerTask[r.taskId] = r.recordedAt;
  }

  final Map<String, List<HistoryItem>> grouped = {};

  for (final record in records) {
    final task = taskMap[record.taskId];
    if (task == null) continue;

    final dateStr = DateFormat('yyyy/MM/dd').format(record.recordedAt);
    if (!grouped.containsKey(dateStr)) {
      grouped[dateStr] = [];
    }
    grouped[dateStr]!.add(HistoryItem(
      record: record,
      task: task,
      interval: intervals[record.id],
    ));
  }

  return grouped;
}

/// 日付ごとに、さらにタスクごとにグループ化した履歴
/// Map<dateStr, List<GroupedTaskItem>>
@riverpod
Map<String, List<GroupedTaskItem>> historyGroupedByTask(Ref ref) {
  final grouped = ref.watch(historyGroupedProvider);

  final Map<String, List<GroupedTaskItem>> result = {};

  for (final entry in grouped.entries) {
    final dateStr = entry.key;
    final items = entry.value;

    // taskId ごとにグループ化
    final Map<String, List<HistoryItem>> byTask = {};
    for (final item in items) {
      byTask.putIfAbsent(item.task.id, () => []).add(item);
    }

    // 各グループを古い順にソート（1回目、2回目の順）
    final List<GroupedTaskItem> groupedItems = byTask.entries.map((e) {
      final sorted = List<HistoryItem>.from(e.value)
        ..sort((a, b) => a.record.recordedAt.compareTo(b.record.recordedAt));
      return GroupedTaskItem(task: sorted.first.task, items: sorted);
    }).toList();

    // グループ内の最新レコード時刻で降順ソート（最近実行したタスクを上に）
    groupedItems.sort(
      (a, b) => b.items.last.record.recordedAt
          .compareTo(a.items.last.record.recordedAt),
    );

    result[dateStr] = groupedItems;
  }

  return result;
}

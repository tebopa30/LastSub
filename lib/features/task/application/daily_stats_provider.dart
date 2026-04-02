import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../domain/daily_stats_model.dart';
import '../domain/task_record_entity.dart';
import '../domain/weekly_stats_model.dart';
import 'task_notifier.dart';

/// 過去7日間の統計を取得する Provider
final dailyStatsProvider = FutureProvider<WeeklyStatsModel>((ref) async {
  final db = await ref.watch(databaseProvider.future);

  // タスクリストを watch することで、タスク削除時にグラフが自動再集計される
  ref.watch(taskProvider);

  final now = DateTime.now();
  final endTime = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  final startTime = endTime.subtract(const Duration(days: 7));

  final rows = await db.rawQuery(
    '''
    SELECT
      substr(r.recordedAt, 1, 10)      AS day_str,
      t.title                          AS title,
      COUNT(*)                         AS cnt,
      SUM(COALESCE(r.value, 0))        AS total_value
    FROM task_records r
    INNER JOIN tasks t ON r.taskId = t.id
    WHERE r.recordedAt >= ?
      AND r.recordedAt <  ?
      AND r.isActive = 1
      AND t.isActive = 1
    GROUP BY 1, 2
    ORDER BY 1 ASC
    ''',
    [startTime.toIso8601String(), endTime.toIso8601String()],
  );

  final Map<String, Map<String, double>> dailyMap = {};
  final Map<String, double> totals = {};

  for (final row in rows) {
    final dayStr = row['day_str'] as String;
    final title = row['title'] as String;
    final count = row['cnt'] as int;
    final value = (row['total_value'] as num?)?.toDouble() ?? 0.0;
    final val = title.contains('睡眠') ? value : count.toDouble();

    dailyMap.putIfAbsent(dayStr, () => {});
    dailyMap[dayStr]![title] = (dailyMap[dayStr]![title] ?? 0) + val;
    totals[title] = (totals[title] ?? 0) + val;
  }

  final List<DailyStatsModel> days = [];
  for (int i = 0; i < 7; i++) {
    final date = startTime.add(Duration(days: i));
    final dateStr = date.toIso8601String().substring(0, 10);
    days.add(DailyStatsModel(date: date, categoryValues: dailyMap[dateStr] ?? {}));
  }

  return WeeklyStatsModel(days: days, totalValues: totals);
});

final dailyStatsProviderAutoDispose =
    FutureProvider.autoDispose<WeeklyStatsModel>((ref) async {
  return ref.watch(dailyStatsProvider.future);
});

final todaySleepRecordsProvider =
    StreamProvider.autoDispose.family<List<TaskRecordEntity>, String>(
  (ref, taskId) {
    try {
      final repo = ref.watch(taskRecordRepositoryProvider);
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      return repo.watchRecordsForTask(taskId).map((records) {
        return records
            .where((r) =>
                r.startedAt != null && !r.recordedAt.isBefore(todayStart))
            .toList();
      });
    } catch (_) {
      return const Stream.empty();
    }
  },
);

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';
import 'history_provider.dart';

part 'graph_provider.g.dart';

class HistoryGraphState {
  final List<BarChartGroupData> barGroups;
  final double maxY;
  final List<DateTime> dates;
  final Map<String, Color> colorMap;
  final Map<String, String> taskNames;
  final int actualDays;
  final List<List<String>> stackTaskIds;

  HistoryGraphState({
    required this.barGroups,
    required this.maxY,
    required this.dates,
    required this.colorMap,
    required this.taskNames,
    required this.actualDays,
    required this.stackTaskIds,
  });
}

/// taskId → タスク表示名 のマッピング
@riverpod
Map<String, String> weeklyGraphTaskNames(Ref ref) {
  final tasks = ref.watch(allTasksStreamProvider).value ?? [];
  return {for (final t in tasks) t.id: t.title};
}

/// taskId → 指定期間の実行回数リスト（ローカルSQLiteから集計）
@riverpod
Map<String, List<int>> weeklyGraphData(Ref ref) {
  final periodDays = ref.watch(historyPeriodProvider);
  final int days = periodDays ?? 7;

  final now = DateTime.now();
  final dates = List.generate(days, (i) {
    final d = now.subtract(Duration(days: (days - 1) - i));
    return DateFormat('yyyy-MM-dd').format(d);
  });

  final Map<String, List<int>> result = {};
  final records = ref.watch(recentRecordsStreamProvider).value ?? [];
  for (final record in records) {
    final dateStr = DateFormat('yyyy-MM-dd').format(record.recordedAt);
    final dayIndex = dates.indexOf(dateStr);
    if (dayIndex == -1) continue;
    result.putIfAbsent(record.taskId, () => List.filled(days, 0));
    result[record.taskId]![dayIndex]++;
  }

  return result;
}

/// UI用のグラフ表示状態を生成するProvider
@riverpod
HistoryGraphState historyGraphState(Ref ref) {
  final data = ref.watch(weeklyGraphDataProvider);
  final taskNames = ref.watch(weeklyGraphTaskNamesProvider);
  final periodDays = ref.watch(historyPeriodProvider);

  if (data.isEmpty) {
    return HistoryGraphState(
      barGroups: [],
      maxY: 5.0,
      dates: [],
      colorMap: {},
      taskNames: {},
      actualDays: 7,
      stackTaskIds: [],
    );
  }

  final int actualDays = periodDays ?? data.values.first.length;
  final now = DateTime.now();
  final dates = List.generate(
      actualDays, (i) => now.subtract(Duration(days: (actualDays - 1) - i)));

  const palette = [
    Color(0xFF7EC8A4),
    Color(0xFFF6B8C6),
    Color(0xFF80B4E8),
    Color(0xFFFFD580),
    Color(0xFFBFA9E0),
    Color(0xFFFF9E7A),
    Color(0xFF90D4D4),
    Color(0xFFF4A6A6),
    Color(0xFFB5D99C),
    Color(0xFFD4B483),
  ];

  final taskIds = data.keys.where((id) => taskNames.containsKey(id)).toList();
  final colorMap = <String, Color>{};
  for (var i = 0; i < taskIds.length; i++) {
    colorMap[taskIds[i]] = palette[i % palette.length];
  }

  double maxY = 5.0;
  for (int i = 0; i < actualDays; i++) {
    double dayTotal = 0;
    for (final counts in data.values) {
      if (i < counts.length) dayTotal += counts[i];
    }
    if (dayTotal > maxY) maxY = dayTotal;
  }
  maxY += 2;

  final stackTaskIds = <List<String>>[];
  final barGroups = List.generate(actualDays, (i) {
    double cumulative = 0;
    final stackItems = <BarChartRodStackItem>[];
    final dayTaskIds = <String>[];
    for (final taskId in taskIds) {
      if (i >= data[taskId]!.length) continue;
      final val = data[taskId]![i].toDouble();
      if (val <= 0) continue;
      stackItems.add(BarChartRodStackItem(
        cumulative,
        cumulative + val,
        colorMap[taskId]!,
      ));
      dayTaskIds.add(taskId);
      cumulative += val;
    }
    stackTaskIds.add(dayTaskIds);
    return BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          toY: cumulative,
          width: actualDays > 10 ? (actualDays > 31 ? 4 : 8) : 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          rodStackItems: stackItems,
          color: null,
        ),
      ],
    );
  });

  final resolvedTaskNames = Map<String, String>.from(taskNames);
  for (final taskId in taskIds) {
    resolvedTaskNames.putIfAbsent(taskId, () => taskId.substring(0, 8));
  }

  return HistoryGraphState(
    barGroups: barGroups,
    maxY: maxY,
    dates: dates,
    colorMap: colorMap,
    taskNames: resolvedTaskNames,
    actualDays: actualDays,
    stackTaskIds: stackTaskIds,
  );
}

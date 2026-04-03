import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/task_entity.dart';
import '../domain/weekly_stats_model.dart';
import 'task_design_helper.dart';

/// 過去7日間の育児活動推移グラフ（タスク別スタック棒グラフ）
class DailyStatsBarChart extends StatefulWidget {
  const DailyStatsBarChart({
    super.key,
    required this.stats,
    this.tasks = const [],
  });

  final WeeklyStatsModel stats;

  /// タスク一覧（各タスクのテーマカラーをグラフに反映するために使用）
  final List<TaskEntity> tasks;

  @override
  State<DailyStatsBarChart> createState() => _DailyStatsBarChartState();
}

class _DailyStatsBarChartState extends State<DailyStatsBarChart> {
  /// 現在タップされている棒グループのインデックス（null = 非選択）
  int? _touchedGroupIndex;

  /// タスク名 → タスク設定カラー（getTaskDesignInfo の backgroundColor）のマッピング
  Map<String, Color> _buildColorMap(List<String> taskNames) {
    final taskByTitle = {for (final t in widget.tasks) t.title: t};
    final map = <String, Color>{};
    for (final name in taskNames) {
      final entity = taskByTitle[name];
      final design = getTaskDesignInfo(
        name,
        iconName: entity?.iconName,
        colorCode: entity?.colorCode,
        isDark: Theme.of(context).brightness == Brightness.dark,
      );
      map[name] = design.backgroundColor;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stats = widget.stats;

    // 全タスク名を収集（出現順で安定させる）
    final taskNames = <String>[];
    for (final day in stats.days) {
      for (final key in day.categoryValues.keys) {
        if (!taskNames.contains(key)) taskNames.add(key);
      }
    }

    final colorMap = _buildColorMap(taskNames);

    // Y軸最大値
    double maxVal = 5.0;
    for (final day in stats.days) {
      final dayTotal = day.categoryValues.values.fold(0.0, (a, b) => a + b);
      if (dayTotal > maxVal) maxVal = dayTotal;
    }
    final maxY = (maxVal * 1.2).ceilToDouble();

    // barGroups を先に構築して showingTooltipIndicators で参照できるようにする
    final barGroups = stats.days.asMap().entries.map((entry) {
      final index = entry.key;
      final day = entry.value;

      final stackItems = <BarChartRodStackItem>[];
      double cumulative = 0;
      for (final taskName in taskNames) {
        final value = day.categoryValues[taskName] ?? 0;
        if (value <= 0) continue;
        stackItems.add(BarChartRodStackItem(
          cumulative,
          cumulative + value,
          colorMap[taskName]!,
        ));
        cumulative += value;
      }

      return BarChartGroupData(
        x: index,
        showingTooltipIndicators: _touchedGroupIndex == index ? [0] : [],
        barRods: [
          BarChartRodData(
            toY: cumulative,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            rodStackItems: stackItems,
            color: stackItems.isEmpty ? cs.primaryContainer : null,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxY,
              color: cs.primaryContainer.withOpacity(0.1),
            ),
          ),
        ],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            '過去7日間の活動推移',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barTouchData: BarTouchData(
                handleBuiltInTouches: false,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final day = stats.days[groupIndex];
                    final dateStr = DateFormat('M/d').format(day.date);
                    final buf = StringBuffer(dateStr);
                    for (final name in taskNames) {
                      final val = day.categoryValues[name];
                      if (val != null && val > 0) {
                        buf.write('\n$name: ${val.toInt()}回');
                      }
                    }
                    return BarTooltipItem(
                      buf.toString(),
                      TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
                touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
                  if (event is! FlTapUpEvent) return;
                  final tappedIndex = response?.spot?.touchedBarGroupIndex;
                  setState(() {
                    if (tappedIndex == null || tappedIndex == _touchedGroupIndex) {
                      // 背景タップ or 同じ棒の再タップ → ツールチップを閉じる
                      _touchedGroupIndex = null;
                    } else {
                      _touchedGroupIndex = tappedIndex;
                    }
                  });
                },
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= stats.days.length) {
                        return const SizedBox.shrink();
                      }
                      final label = DateFormat('M/d').format(stats.days[index].date);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          label,
                          style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
                        ),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: (maxY / 4).ceilToDouble(),
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: (maxY / 4).ceilToDouble(),
                getDrawingHorizontalLine: (value) => FlLine(
                  color: cs.outlineVariant.withOpacity(0.3),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
            ),
          ),
        ),
        if (taskNames.isNotEmpty) ...[
          const SizedBox(height: 12),
          _Legend(taskNames: taskNames, colorMap: colorMap),
        ],
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.taskNames, required this.colorMap});

  final List<String> taskNames;
  final Map<String, Color> colorMap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: taskNames.map((name) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: colorMap[name],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              name,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

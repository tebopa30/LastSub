import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../application/graph_provider.dart';

/// ツールチップ1行分のUIモデル
class _TooltipLine {
  final String taskName;
  final int count;
  const _TooltipLine(this.taskName, this.count);
}

/// グループ（日付）ごとのツールチップUIモデル
class _DayTooltip {
  final String dateLabel;
  final List<_TooltipLine> lines;
  final int total;
  const _DayTooltip({
    required this.dateLabel,
    required this.lines,
    required this.total,
  });
}

class SimpleHistoryChart extends StatefulWidget {
  final HistoryGraphState state;

  const SimpleHistoryChart({
    super.key,
    required this.state,
  });

  @override
  State<SimpleHistoryChart> createState() => _SimpleHistoryChartState();
}

class _SimpleHistoryChartState extends State<SimpleHistoryChart> {
  /// 現在タップされている棒グループのインデックス（null = 非選択）
  int? _touchedGroupIndex;

  /// グラフの折りたたみ状態（true = 折りたたみ中）
  bool _isCollapsed = false;

  /// BarGroups のデータから全日分のツールチップUIモデルを事前構築する
  List<_DayTooltip> _buildTooltips(
    List<DateTime> dates,
    List<List<String>> stackTaskIds,
    Map<String, String> taskNames,
  ) {
    return List.generate(widget.state.barGroups.length, (groupIndex) {
      final dateLabel = DateFormat('M/d').format(dates[groupIndex]);
      final rod = widget.state.barGroups[groupIndex].barRods.firstOrNull;
      if (rod == null) {
        return _DayTooltip(dateLabel: dateLabel, lines: [], total: 0);
      }

      final dayTaskIds = groupIndex < stackTaskIds.length
          ? stackTaskIds[groupIndex]
          : <String>[];

      final lines = <_TooltipLine>[];
      for (var si = 0; si < rod.rodStackItems.length; si++) {
        final item = rod.rodStackItems[si];
        final taskId = si < dayTaskIds.length ? dayTaskIds[si] : '';
        final name = taskNames[taskId] ?? taskId;
        final count = (item.toY - item.fromY).toInt();
        lines.add(_TooltipLine(name, count));
      }

      return _DayTooltip(
        dateLabel: dateLabel,
        lines: lines,
        total: rod.toY.toInt(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    if (state.barGroups.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final dates = state.dates;
    final taskIds = state.colorMap.keys.toList();
    final colorMap = state.colorMap;
    final maxY = state.maxY;
    final actualDays = state.actualDays;
    final taskNames = state.taskNames;
    final stackTaskIds = state.stackTaskIds;

    // ツールチップデータを build 前に一括計算
    final tooltips = _buildTooltips(dates, stackTaskIds, taskNames);

    // タップ固定表示のために showingTooltipIndicators をグループごとに設定
    final barGroups = state.barGroups.asMap().entries.map((entry) {
      final index = entry.key;
      final group = entry.value;
      return group.copyWith(
        showingTooltipIndicators: _touchedGroupIndex == index ? [0] : [],
      );
    }).toList();

    // グラフ本体 + 凡例（折りたたみ対象）
    final chartBody = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        AspectRatio(
          aspectRatio: 1.8,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barTouchData: BarTouchData(
                handleBuiltInTouches: false,
                touchTooltipData: BarTouchTooltipData(
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  tooltipMargin: 8,
                  getTooltipColor: (_) =>
                      cs.surfaceContainerHighest.withValues(alpha: 0.95),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    if (groupIndex >= tooltips.length) return null;
                    final tip = tooltips[groupIndex];
                    final lines = tip.lines
                        .map((l) => '${l.taskName}: ${l.count}回')
                        .join('\n');
                    return BarTooltipItem(
                      '${tip.dateLabel}\n$lines\n合計: ${tip.total}回',
                      TextStyle(
                        color: cs.onSurfaceVariant,
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
                      _touchedGroupIndex = null;
                    } else {
                      _touchedGroupIndex = tappedIndex;
                    }
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: actualDays > 10
                        ? (actualDays > 31 ? 10 : 5)
                        : 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= dates.length) {
                        return const SizedBox.shrink();
                      }

                      if (actualDays > 10) {
                        final skip = actualDays > 31 ? 10 : 5;
                        if (index % skip != 0) {
                          return const SizedBox.shrink();
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat('M/d').format(dates[index]),
                          style: TextStyle(
                            color: cs.outline,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: (maxY / 4).ceilToDouble() == 0
                        ? 1
                        : (maxY / 4).ceilToDouble(),
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value == maxY) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(color: cs.outline, fontSize: 12),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: (maxY / 4).ceilToDouble() == 0
                    ? 1
                    : (maxY / 4).ceilToDouble(),
                getDrawingHorizontalLine: (_) => FlLine(
                  color: cs.surfaceContainerHighest,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              barGroups: barGroups,
            ),
          ),
        ),
        if (taskIds.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: taskIds.map((taskId) {
              final name = taskNames[taskId] ?? taskId;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colorMap[taskId],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    name,
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ],
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトル行（タップで折りたたみ切り替え）
            InkWell(
              onTap: () => setState(() => _isCollapsed = !_isCollapsed),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'タスク実行回数の履歴',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(
                      _isCollapsed ? Icons.expand_more : Icons.expand_less,
                      color: cs.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            // グラフ本体（アニメーション付き開閉）
            AnimatedCrossFade(
              firstChild: chartBody,
              secondChild: const SizedBox.shrink(),
              crossFadeState: _isCollapsed
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }

}

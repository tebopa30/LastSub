import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../domain/growth_record_entity.dart';

class GrowthChart extends StatelessWidget {
  final List<GrowthRecordEntity> records;
  final bool isPremium;

  const GrowthChart({
    super.key,
    required this.records,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    // グラフ描画用のデータ生成（身長と体重を別々に抽出、過去→現在に昇順ソート）
    final sorted = List.of(records)..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final heightSpots = <FlSpot>[];
    final weightSpots = <FlSpot>[];

    for (int i = 0; i < sorted.length; i++) {
      final r = sorted[i];
      if (r.height != null) heightSpots.add(FlSpot(i.toDouble(), r.height!));
      if (r.weight != null) weightSpots.add(FlSpot(i.toDouble(), r.weight!));
    }

    if (heightSpots.isEmpty && weightSpots.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: Text('グラフへの表示データがありません')),
        ),
      );
    }

    // 簡易表示: 体重をメインに表示、身長があれば表示
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '体重の推移 (kg)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.8,
              child: weightSpots.isEmpty
                  ? const Center(child: Text('体重データがありません'))
                  : LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(enabled: isPremium), // 無料ならタップ無効化
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                final idx = value.toInt();
                                if (idx < 0 || idx >= sorted.length) return const SizedBox.shrink();
                                final text = DateFormat('M/d').format(sorted[idx].recordedAt);
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(text, style: const TextStyle(fontSize: 10)),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: true, drawVerticalLine: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: weightSpots,
                            isCurved: true,
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

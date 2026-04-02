import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/daily_stats_provider.dart';
import '../application/task_notifier.dart';
import '../domain/task_entity.dart';
import '../domain/weekly_stats_model.dart';
import 'daily_stats_bar_chart.dart';
import 'task_design_helper.dart';

/// 育児統計画面
class DailyStatsPage extends ConsumerWidget {
  const DailyStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dailyStatsProviderAutoDispose);

    return Scaffold(
      appBar: AppBar(
        title: const Text('統計・レポート'),
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 12),
              Text('データ取得エラー', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('$err',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline)),
            ],
          ),
        ),
        data: (stats) {
          // データが空（または全日が空）の場合の判定
          final hasAnyData = stats.days.any((d) => d.categoryValues.isNotEmpty);
          if (!hasAnyData) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.query_stats, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('過去7日間のデータがまだありません',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }
          return _StatsBody(stats: stats);
        },
      ),
    );
  }
}

class _StatsBody extends ConsumerWidget {
  const _StatsBody({required this.stats});
  final WeeklyStatsModel stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider).value ?? <TaskEntity>[];
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        // ── グラフカード（データ制御済み）
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: DailyStatsBarChart(stats: stats, tasks: tasks),
          ),
        ),
        const SizedBox(height: 24),

        // 集計ヘッダ
        Row(
          children: [
            Text(
              '期間集計サマリ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Text(
              '過去7日間',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── カテゴリ別表示（Providerでフィルタ済みのものだけ表示）
        ...stats.totalValues.entries.map((e) {
          final title = e.key;
          final value = e.value;
          final isSleep = title.contains('睡眠');
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _StatCard(
              title: title,
              value: isSleep ? _formatSleep(value) : '${value.toInt()}',
              unit: isSleep ? '' : '回',
            ),
          );
        }),

        const SizedBox(height: 24),

        // 未来の拡張機能（常に表示して期待値を高める）
        const _PremiumLockedCard(
           icon: Icons.auto_graph,
           message: '月次・年次統計とAI分析',
        ),
      ],
    );
  }

  String _formatSleep(double mins) {
    final h = mins ~/ 60;
    final m = (mins % 60).toInt();
    if (h > 0) return '$h時間$m分';
    return '$m分';
  }
}
// ────────────────────────────────────────
// プレミアムロックカード（無料ユーザー向け）
// ────────────────────────────────────────
class _PremiumLockedCard extends StatelessWidget {
  const _PremiumLockedCard({
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Icon(icon, size: 32, color: cs.outline),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'プレミアムプランでご利用いただけます',
                    style: TextStyle(fontSize: 12, color: cs.outline),
                  ),
                ],
              ),
            ),
            Icon(Icons.lock, size: 20, color: cs.outline),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────
// 個別の統計カード
// ────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
  });

  final String title;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final design = getTaskDesignInfo(title);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            // アイコン
            CircleAvatar(
              radius: 28,
              backgroundColor: design.backgroundColor,
              child: Icon(
                design.iconData,
                color: design.iconColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),

            // タイトル + 数値
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (unit.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(
                          unit,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

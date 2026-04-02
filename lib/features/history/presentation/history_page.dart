import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../application/history_provider.dart';
import '../application/graph_provider.dart';
import '../../task/domain/task_entity.dart';
import '../../task/domain/task_record_entity.dart';
import '../../task/presentation/task_design_helper.dart';
import 'widgets/simple_history_chart.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedByTask = ref.watch(historyGroupedByTaskProvider);
    final currentPeriod = ref.watch(historyPeriodProvider);

    final sortedDates = groupedByTask.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text('記録履歴'),
      ),
      body: Column(
        children: [
          // ── 期間選択 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SegmentedButton<int?>(
              segments: const [
                ButtonSegment(value: 7, label: Text('7日間')),
                ButtonSegment(value: 30, label: Text('30日間')),
                ButtonSegment(value: null, label: Text('全期間')),
              ],
              selected: {currentPeriod},
              onSelectionChanged: (newSelection) {
                ref.read(historyPeriodProvider.notifier).setPeriod(newSelection.first);
              },
            ),
          ),

          // ── 簡易グラフ ──
          Consumer(
            builder: (context, ref, child) {
              final graphState = ref.watch(historyGraphStateProvider);
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: SimpleHistoryChart(state: graphState),
              );
            },
          ),

          // ── 履歴リスト ──
          Expanded(
            child: sortedDates.isEmpty
                ? Center(
                    child: Text(
                      '記録がありません',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 32),
                    itemCount: sortedDates.length,
                    itemBuilder: (context, index) {
                      final dateStr = sortedDates[index];
                      final items = groupedByTask[dateStr]!;
                      return _buildDateSection(
                          context, ref, dateStr, items, index == 0);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(
    BuildContext context,
    WidgetRef ref,
    String dateStr,
    List<GroupedTaskItem> groupedItems,
    bool isFirst,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          dateStr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: isFirst,
        children: groupedItems
            .map((group) => _buildGroupedTaskCard(context, ref, group))
            .toList(),
      ),
    );
  }

  Widget _buildGroupedTaskCard(
    BuildContext context,
    WidgetRef ref,
    GroupedTaskItem group,
  ) {
    final task = group.task;
    final design =
        getTaskDesignInfo(task.title, iconName: task.iconName, colorCode: task.colorCode);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── ヘッダー: アイコン + タスク名 + 回数 ──
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: design.backgroundColor,
                  child: Icon(design.iconData, color: design.iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                if (group.count > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${group.count}回',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
            // ── 睡眠・母乳: 合計時間バッジ ──
            if (task.title == '睡眠' ||
                task.title == '母乳　右' ||
                task.title == '母乳　左') ...[
              const SizedBox(height: 4),
              Builder(builder: (context) {
                final isBreast =
                    task.title == '母乳　右' || task.title == '母乳　左';
                final totalSeconds = group.items.fold<int>(0, (sum, item) {
                  final r = item.record;
                  if (r.startedAt == null) return sum;
                  return sum + r.recordedAt.difference(r.startedAt!).inSeconds;
                });
                if (totalSeconds <= 0) return const SizedBox.shrink();
                final totalMinutes = totalSeconds ~/ 60;
                String label;
                if (isBreast) {
                  final s = totalSeconds % 60;
                  label = s > 0 ? '合計 $totalMinutes分$s秒' : '合計 $totalMinutes分';
                } else {
                  final h = totalMinutes ~/ 60;
                  final m = totalMinutes % 60;
                  label = h > 0 ? '合計 $h時間$m分' : '合計 $m分';
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              }),
            ],
            const SizedBox(height: 8),
            // ── 各記録行 ──
            ...group.items.asMap().entries.map((entry) {
              final ordinal = entry.key + 1;
              final item = entry.value;
              final record = item.record;
              final timeStr = DateFormat('HH:mm').format(record.recordedAt);
              final ordinalLabel = group.count > 1 ? '$ordinal回目' : null;
              return _buildRecordRow(
                context,
                ref,
                record: record,
                task: task,
                timeStr: timeStr,
                ordinalLabel: ordinalLabel,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordRow(
    BuildContext context,
    WidgetRef ref, {
    required TaskRecordEntity record,
    required TaskEntity task,
    required String timeStr,
    String? ordinalLabel,
  }) {
    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.delete_outline,
            color: Theme.of(context).colorScheme.onErrorContainer, size: 20),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('記録を削除しますか？'),
            content: Text('「${task.title}」の $timeStr の記録を削除します。'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('キャンセル')),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('削除'),
              ),
            ],
          ),
        ) ??
            false;
      },
      onDismissed: (_) {
        ref.read(historyNotifierProvider.notifier).deleteRecord(record.id);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            if (ordinalLabel != null)
              SizedBox(
                width: 40,
                child: Text(ordinalLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.w500,
                    )),
              )
            else
              const SizedBox(width: 4),
            InkWell(
              onTap: () => _editRecordTime(context, ref, record),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(timeStr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    const SizedBox(width: 2),
                    Icon(Icons.edit, size: 11,
                        color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            ),
            if (record.startedAt != null) ...[
              const SizedBox(width: 6),
              Text(
                _formatDuration(record.recordedAt.difference(record.startedAt!)),
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (record.value != null) ...[
              const SizedBox(width: 6),
              InkWell(
                onTap: () => _editRecordValue(context, ref, record),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${record.value!.toInt()}${record.unit ?? ''}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                      const SizedBox(width: 2),
                      Icon(Icons.edit, size: 11,
                          color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                ),
              ),
            ],
            if (record.memo != null && record.memo!.isNotEmpty) ...[
              const SizedBox(width: 8),
              Expanded(
                child: Text(record.memo!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return '($h時間$m分)';
    return '($m分)';
  }

  Future<void> _editRecordValue(
    BuildContext context,
    WidgetRef ref,
    TaskRecordEntity record,
  ) async {
    double selected = record.value!;
    final saved = await showDialog<double>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('容量を変更'),
          content: DropdownButton<double>(
            value: selected,
            isExpanded: true,
            items: List.generate(51, (i) => i * 10.0)
                .map((ml) => DropdownMenuItem(
                      value: ml,
                      child: Text('${ml.toInt()}ml'),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) setDialogState(() => selected = val);
            },
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx), child: const Text('キャンセル')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, selected),
                child: const Text('保存')),
          ],
        ),
      ),
    );
    if (saved == null || !context.mounted) return;
    await ref
        .read(historyNotifierProvider.notifier)
        .updateRecordValue(record, saved);
  }

  Future<void> _editRecordTime(
    BuildContext context,
    WidgetRef ref,
    TaskRecordEntity record,
  ) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: record.recordedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedDate == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(record.recordedAt),
    );
    if (pickedTime == null || !context.mounted) return;

    final newDateTime = DateTime(
      pickedDate.year, pickedDate.month, pickedDate.day,
      pickedTime.hour, pickedTime.minute,
    );

    await ref
        .read(historyNotifierProvider.notifier)
        .updateRecordTimestamp(record, newDateTime);
  }
}

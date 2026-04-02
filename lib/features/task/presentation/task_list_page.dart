import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/breast_notification_service.dart';
import '../application/task_notifier.dart';
import '../domain/task_entity.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/repository_providers.dart';
import 'task_design_helper.dart';
import 'widgets/add_task_modal.dart';
import '../../history/presentation/history_page.dart';
import '../../settings/presentation/settings_page.dart';

// ──────────────────────────────────────────────
// 経過時間に応じたステータスカラー
// ──────────────────────────────────────────────
Color _statusColor(TaskEntity task, BuildContext context) {
  final last = task.lastRecordedAt;
  if (last == null) return Colors.grey.withOpacity(0.5);

  final elapsed = DateTime.now().difference(last);
  final hours = elapsed.inHours;

  final threshold = task.recommendedIntervalDays;
  if (threshold != null && threshold > 0) {
    final thresholdHours = threshold * 24;
    if (hours < thresholdHours) return const Color(0xFF4CAF50);            // 緑
    if (hours < thresholdHours * 1.5) return const Color(0xFFFFC107);      // 黄
    if (hours < thresholdHours * 3) return const Color(0xFFFF9800);        // 橙
    return const Color(0xFFF44336);                                         // 赤
  } else {
    // 推奨間隔未設定: デフォルト閾値
    if (hours < 24) return const Color(0xFF4CAF50);
    if (hours < 72) return const Color(0xFFFFC107);
    if (hours < 168) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}

// ──────────────────────────────────────────────
// 経過時間の文字列フォーマット
// ──────────────────────────────────────────────
String _formatElapsed(DateTime? last) {
  if (last == null) return '未記録';
  final elapsed = DateTime.now().difference(last);
  final days = elapsed.inDays;
  final hours = elapsed.inHours % 24;
  final minutes = elapsed.inMinutes % 60;

  if (days >= 7) return '$days日経過';
  if (days >= 1) return '$days日 $hours時間';
  if (hours >= 1) return '$hours時間 $minutes分';
  return '$minutes分';
}

// ──────────────────────────────────────────────
// Page
// ──────────────────────────────────────────────
class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});

  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  /// 1分ごとに setState して経過時間表示を更新
  Timer? _minuteTimer;

  /// 連打防止フラグ
  bool _isProcessing = false;

  /// ミルク量選択（taskId → ml）
  final Map<String, double> _selectedMilkAmounts = {};

  /// 母乳タイマーアラート時間（taskId → 分）
  final Map<String, int> _breastTimerMinutes = {};

  /// 母乳カウントダウン残り秒（taskId → 秒）
  final Map<String, int> _breastTimerRemaining = {};

  /// 母乳 Timer インスタンス
  final Map<String, Timer> _breastTimers = {};

  static const _breastTitles = {'母乳　右', '母乳　左'};

  @override
  void initState() {
    super.initState();
    _minuteTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _minuteTimer?.cancel();
    for (final t in _breastTimers.values) {
      t.cancel();
    }
    super.dispose();
  }

  // ── 母乳タイマー ──────────────────────────
  void _startBreastTimer(String taskId, int minutes) {
    _cancelBreastTimer(taskId);
    setState(() => _breastTimerRemaining[taskId] = minutes * 60);
    BreastNotificationService.instance.scheduleBreastAlert(taskId, minutes);
    _breastTimers[taskId] = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      final remaining = (_breastTimerRemaining[taskId] ?? 0) - 1;
      if (remaining <= 0) {
        t.cancel();
        _breastTimers.remove(taskId);
        setState(() => _breastTimerRemaining.remove(taskId));
        _showBreastTimerAlert(taskId);
      } else {
        setState(() => _breastTimerRemaining[taskId] = remaining);
      }
    });
  }

  void _cancelBreastTimer(String taskId) {
    _breastTimers[taskId]?.cancel();
    _breastTimers.remove(taskId);
    if (_breastTimerRemaining.containsKey(taskId)) {
      setState(() => _breastTimerRemaining.remove(taskId));
    }
    BreastNotificationService.instance.cancelBreastAlert(taskId);
  }

  void _showBreastTimerAlert(String taskId) {
    final tasks = ref.read(taskProvider).value ?? [];
    final task = tasks.where((t) => t.id == taskId).firstOrNull;
    final title = task?.title ?? '母乳';
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$title タイマー終了'),
        content: const Text('設定時間が経過しました。\n記録ボタンで完了してください。'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ── 推奨間隔設定ダイアログ ─────────────────
  Future<void> _showIntervalDialog(TaskEntity task) async {
    final controller = TextEditingController(
      text: task.recommendedIntervalDays?.toString() ?? '',
    );
    final result = await showDialog<int?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('推奨間隔を設定'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('「${task.title}」の目安にする間隔（日数）を入力してください。'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '日数（例: 1 / 3 / 7）',
                suffixText: '日',
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, -1), // -1 = クリア
            child: const Text('クリア'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              final val = int.tryParse(controller.text.trim());
              Navigator.pop(ctx, val);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (result == null) return; // キャンセル
    final days = result == -1 ? null : result; // -1 = クリア
    await ref.read(taskProvider.notifier).updateRecommendedInterval(task.id, days);
  }

  @override
  Widget build(BuildContext context) {
    final databaseAsync = ref.watch(databaseProvider);

    return databaseAsync.when(
      data: (_) => _buildScaffold(context),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('データベースエラー: $e')),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final taskListAsync = ref.watch(taskProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LAST SUB',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: '記録履歴',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '設定',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: taskListAsync.when(
        skipLoadingOnReload: true,
        skipError: true,
        data: (tasks) => _buildTaskList(context, tasks, isDark),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('エラー: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskModal(context),
        tooltip: 'タスクを追加',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<TaskEntity> tasks, bool isDark) {
    final initialTaskIds = ref
        .watch(initialTaskIdsProvider)
        .when(
          data: (ids) => ids,
          loading: () => tasks.map((t) => t.id).toSet(),
          error: (_, __) => <String>{},
        );

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text('タスクがありません',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('＋ボタンから追加してください',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline)),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      itemCount: tasks.length,
      onReorder: (oldIndex, newIndex) {
        ref.read(taskProvider.notifier).reorderTasks(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isInitial = initialTaskIds.contains(task.id);
        return _buildTaskCard(context, task, isInitial, isDark);
      },
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    TaskEntity task,
    bool isInitial,
    bool isDark,
  ) {
    const instantTitles = {
      'ミルク', 'オムツ替え', 'オムツ替え（うんち）', 'オムツ替え（おしっこ）',
      '哺乳瓶消毒', 'お風呂',
    };
    final isTimerTask = !instantTitles.contains(task.title);
    final isSleepTask = task.title == '睡眠';
    final isBreastTask = _breastTitles.contains(task.title);
    final isMilkTask = task.title == 'ミルク';
    final isUnrecorded = task.lastRecordedAt == null;

    final statusColor = _statusColor(task, context);
    final elapsedText = _formatElapsed(task.lastRecordedAt);
    final design = getTaskDesignInfo(task.title,
        iconName: task.iconName, colorCode: task.colorCode);

    final cardContent = Card(
      key: Key(task.id),
      child: Column(
        children: [
          // ── ステータスバー（上端）
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isDark ? 4 : 28),
                topRight: Radius.circular(isDark ? 4 : 28),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 上段: アイコン + タスク名 + 推奨間隔
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: design.backgroundColor,
                      child: Icon(design.iconData,
                          color: design.iconColor, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // 推奨間隔チップ
                    GestureDetector(
                      onTap: () => _showIntervalDialog(task),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A2A2A)
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(isDark ? 2 : 12),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF3A3A3A)
                                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.schedule,
                                size: 11,
                                color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 3),
                            Text(
                              task.recommendedIntervalDays != null
                                  ? '${task.recommendedIntervalDays}日'
                                  : '設定',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // ── メイン: 経過時間（大きく）
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Container(
                        width: 5,
                        height: 44,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(
                        elapsedText,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: isUnrecorded
                              ? Theme.of(context).colorScheme.outline
                              : statusColor,
                          letterSpacing: isDark ? 1 : 0,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── 睡眠/母乳のサブ情報 ──
                if ((isSleepTask || isBreastTask) && !isUnrecorded)
                  _SleepSubtitle(task: task, isRecording: !isUnrecorded),

                // ── 母乳タイマーアラート設定（計測前）──
                if (isBreastTask && isUnrecorded) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      DropdownButton<int>(
                        value: _breastTimerMinutes[task.id] ?? 5,
                        isDense: true,
                        underline: const SizedBox.shrink(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        items: List.generate(20, (i) => i + 1)
                            .map((m) => DropdownMenuItem(
                                  value: m,
                                  child: Text('$m分'),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _breastTimerMinutes[task.id] = val);
                        },
                      ),
                      Text(' でアラート',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ],

                // ── 母乳カウントダウン（計測中）──
                if (isBreastTask && _breastTimerRemaining.containsKey(task.id)) ...[
                  const SizedBox(height: 4),
                  Builder(builder: (context) {
                    final rem = _breastTimerRemaining[task.id]!;
                    final mm = (rem ~/ 60).toString().padLeft(2, '0');
                    final ss = (rem % 60).toString().padLeft(2, '0');
                    return Row(
                      children: [
                        Icon(Icons.timer, size: 13,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 4),
                        Text('$mm:$ss',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                      ],
                    );
                  }),
                ],

                // ── ボタン行 ──
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ミルク量選択
                    if (isMilkTask) ...[
                      DropdownButton<double>(
                        value: _selectedMilkAmounts[task.id] ?? 100.0,
                        isDense: true,
                        underline: const SizedBox.shrink(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        items: List.generate(51, (i) => i * 10.0)
                            .map((ml) => DropdownMenuItem(
                                  value: ml,
                                  child: Text('${ml.toInt()}ml'),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedMilkAmounts[task.id] = val);
                        },
                      ),
                      const SizedBox(width: 8),
                    ],

                    // 記録ボタン（タスク種別による切り替え）
                    if (isTimerTask) ...[
                      if (isUnrecorded)
                        FilledButton(
                          onPressed: _isProcessing ? null : () async {
                            setState(() => _isProcessing = true);
                            try {
                              await ref.read(taskProvider.notifier).startTask(task.id);
                              if (isBreastTask) {
                                _startBreastTimer(task.id, _breastTimerMinutes[task.id] ?? 5);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('開始できませんでした: $e')));
                              }
                            } finally {
                              if (mounted) setState(() => _isProcessing = false);
                            }
                          },
                          child: const Text('開始'),
                        )
                      else
                        FilledButton.tonal(
                          onPressed: _isProcessing ? null : () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('完了記録'),
                                content: const Text('完了タスクとして記録しますか？'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text('いいえ')),
                                  FilledButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('はい')),
                                ],
                              ),
                            );
                            if (confirmed != true) return;
                            setState(() => _isProcessing = true);
                            try {
                              final startedAt = isSleepTask ? task.lastRecordedAt : null;
                              if (isBreastTask) _cancelBreastTimer(task.id);
                              await ref.read(taskProvider.notifier).recordTaskExecution(
                                task.id,
                                startedAt: startedAt,
                                keepLastRecordedAt: false,
                              );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('記録できませんでした: $e')));
                              }
                            } finally {
                              if (mounted) setState(() => _isProcessing = false);
                            }
                          },
                          child: const Text('完了'),
                        ),
                    ] else ...[
                      // 即時記録型
                      FilledButton(
                        onPressed: _isProcessing ? null : () async {
                          setState(() => _isProcessing = true);
                          try {
                            await ref.read(taskProvider.notifier).recordTaskExecution(
                              task.id,
                              value: isMilkTask
                                  ? (_selectedMilkAmounts[task.id] ?? 100.0)
                                  : null,
                              keepLastRecordedAt: true,
                            );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('記録できませんでした: $e')));
                            }
                          } finally {
                            if (mounted) setState(() => _isProcessing = false);
                          }
                        },
                        child: const Text('記録'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // スワイプ削除（デフォルトタスク以外のみ）
    if (isInitial) return cardContent;

    return Dismissible(
      key: Key('dismiss_${task.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(isDark ? 4 : 20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('タスクを削除'),
            content: Text('「${task.title}」を削除しますか？'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('キャンセル')),
              FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('削除')),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref.read(taskProvider.notifier).deleteTask(task.id);
      },
      child: cardContent,
    );
  }

  void _showAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => AddTaskModal(
        onSave: (title, iconName, colorCode) async {
          Navigator.pop(ctx);
          try {
            await ref.read(taskProvider.notifier).createTask(
              title,
              iconName: iconName,
              colorCode: colorCode,
            );
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('追加できませんでした: $e')),
              );
            }
          }
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────
// 睡眠・母乳のサブタイトル
// ──────────────────────────────────────────────
class _SleepSubtitle extends StatelessWidget {
  final TaskEntity task;
  final bool isRecording;

  const _SleepSubtitle({required this.task, required this.isRecording});

  @override
  Widget build(BuildContext context) {
    if (!isRecording) return const SizedBox.shrink();

    final started = task.lastRecordedAt;
    if (started == null) return const SizedBox.shrink();

    final elapsed = DateTime.now().difference(started);
    final hh = elapsed.inHours.toString().padLeft(2, '0');
    final mm = (elapsed.inMinutes % 60).toString().padLeft(2, '0');

    return Text(
      '計測中: $hh:$mm',
      style: TextStyle(
        fontSize: 13,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/breast_notification_service.dart';
import '../application/task_notifier.dart';
import '../domain/task_entity.dart';
import '../../../core/providers/database_provider.dart';
import 'task_design_helper.dart';
import 'widgets/add_task_modal.dart';
import '../../history/presentation/history_page.dart';
import '../../settings/presentation/settings_page.dart';

// ──────────────────────────────────────────────
// 経過時間に応じたステータスカラー
// ──────────────────────────────────────────────
Color _statusColor(TaskEntity task, BuildContext context) {
  final last = task.lastRecordedAt;
  if (last == null) return Colors.grey.withValues(alpha: 0.5);

  final elapsed = DateTime.now().difference(last);

  // recommendedIntervalDays は秒単位で格納
  final thresholdSecs = task.recommendedIntervalDays;
  if (thresholdSecs != null && thresholdSecs > 0) {
    final s = elapsed.inSeconds;
    if (s < thresholdSecs) return const Color(0xFF4CAF50);            // 緑
    if (s < thresholdSecs * 1.5) return const Color(0xFFFFC107);      // 黄
    if (s < thresholdSecs * 3) return const Color(0xFFFF9800);        // 橙
    return const Color(0xFFF44336);                                    // 赤
  } else {
    // 推奨間隔未設定: デフォルト閾値（1日/3日/7日）
    final hours = elapsed.inHours;
    if (hours < 24) return const Color(0xFF4CAF50);
    if (hours < 72) return const Color(0xFFFFC107);
    if (hours < 168) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}

// ──────────────────────────────────────────────
// 推奨間隔（秒）を人間可読な文字列に変換
// ──────────────────────────────────────────────
String _formatIntervalSeconds(int seconds) {
  if (seconds >= 86400 && seconds % 86400 == 0) return '${seconds ~/ 86400}日';
  if (seconds >= 3600 && seconds % 3600 == 0) return '${seconds ~/ 3600}時間';
  if (seconds >= 60 && seconds % 60 == 0) return '${seconds ~/ 60}分';
  return '$seconds秒';
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
  if (days >= 1) return '$days日 $hours時間経過';
  if (hours >= 1) return '$hours時間 $minutes分経過';
  return '$minutes分経過';
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

  /// アラートタイマー設定時間（taskId → 分）
  final Map<String, int> _alertTimerMinutes = {};

  /// アラートカウントダウン残り秒（taskId → 秒）
  final Map<String, int> _alertTimerRemaining = {};

  /// アラート Timer インスタンス
  final Map<String, Timer> _alertTimers = {};

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
    for (final t in _alertTimers.values) {
      t.cancel();
    }
    super.dispose();
  }

  // ── 母乳タイマー ──────────────────────────
  void _startAlertTimer(String taskId, int minutes) {
    _cancelAlertTimer(taskId);
    setState(() => _alertTimerRemaining[taskId] = minutes * 60);
    BreastNotificationService.instance.scheduleBreastAlert(taskId, minutes);
    _alertTimers[taskId] = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      final remaining = (_alertTimerRemaining[taskId] ?? 0) - 1;
      if (remaining <= 0) {
        t.cancel();
        _alertTimers.remove(taskId);
        setState(() => _alertTimerRemaining.remove(taskId));
        _showAlertTimerAlert(taskId);
      } else {
        setState(() => _alertTimerRemaining[taskId] = remaining);
      }
    });
  }

  void _cancelAlertTimer(String taskId) {
    _alertTimers[taskId]?.cancel();
    _alertTimers.remove(taskId);
    if (_alertTimerRemaining.containsKey(taskId)) {
      setState(() => _alertTimerRemaining.remove(taskId));
    }
    BreastNotificationService.instance.cancelBreastAlert(taskId);
  }

  void _showAlertTimerAlert(String taskId) {
    final tasks = ref.read(taskProvider).value ?? [];
    final task = tasks.where((t) => t.id == taskId).firstOrNull;
    final title = task?.title ?? 'タスク';
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

  // ── 完了記録ダイアログ ─────────────────────
  static const _availableUnits = ['ml', 'g', 'kg', 'cm', '回', '分', '時間', 'oz'];

  Future<({double? value, String? unit})?> _showCompleteDialog(
      BuildContext context) async {
    double? inputValue;
    String selectedUnit = _availableUnits.first;
    bool useValue = false;
    final textController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('完了記録'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('完了タスクとして記録しますか？'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: useValue,
                    onChanged: (v) => setDialogState(() => useValue = v ?? false),
                  ),
                  const Text('数値を記録する'),
                ],
              ),
              if (useValue) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: '数値',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) {
                          inputValue = double.tryParse(v);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedUnit,
                      isDense: true,
                      items: _availableUnits
                          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setDialogState(() => selectedUnit = v);
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('記録'),
            ),
          ],
        ),
      ),
    );

    textController.dispose();
    if (confirmed != true) return null;
    return (
      value: useValue ? inputValue : null,
      unit: useValue ? selectedUnit : null,
    );
  }

  // ── 推奨間隔設定ダイアログ ─────────────────
  static const _intervalUnits = ['秒', '分', '時間', '日'];
  static const _unitToSeconds = {'秒': 1, '分': 60, '時間': 3600, '日': 86400};

  /// 既存の秒値を (数値, 単位) に分解する
  ({int value, String unit}) _secondsToUnitDisplay(int seconds) {
    if (seconds >= 86400 && seconds % 86400 == 0) return (value: seconds ~/ 86400, unit: '日');
    if (seconds >= 3600 && seconds % 3600 == 0) return (value: seconds ~/ 3600, unit: '時間');
    if (seconds >= 60 && seconds % 60 == 0) return (value: seconds ~/ 60, unit: '分');
    return (value: seconds, unit: '秒');
  }

  Future<void> _showIntervalDialog(TaskEntity task) async {
    // 既存値を単位に分解して初期値をセット
    final existing = task.recommendedIntervalDays;
    final initial = existing != null && existing > 0
        ? _secondsToUnitDisplay(existing)
        : (value: 1, unit: '日');

    String selectedUnit = initial.unit;
    final controller = TextEditingController(text: initial.value.toString());

    // result: null = キャンセル, -1 = クリア, >0 = 秒数
    final result = await showDialog<int?>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('推奨間隔を設定'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('「${task.title}」の目安にする間隔を設定してください。'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '数値',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      autofocus: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: selectedUnit,
                    isDense: true,
                    items: _intervalUnits
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => selectedUnit = v);
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, -1),
              child: const Text('クリア'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () {
                final n = int.tryParse(controller.text.trim());
                if (n == null || n <= 0) return; // 不正値は閉じない
                Navigator.pop(ctx, n * _unitToSeconds[selectedUnit]!);
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();

    if (result == null) return; // キャンセル
    final seconds = result == -1 ? null : result;
    await ref.read(taskProvider.notifier).updateRecommendedInterval(task.id, seconds);
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
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)),
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
        return _buildTaskCard(context, task, isDark);
      },
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    TaskEntity task,
    bool isDark,
  ) {
    final isUnrecorded = task.lastRecordedAt == null;

    final statusColor = _statusColor(task, context);
    final elapsedText = _formatElapsed(task.lastRecordedAt);
    final design = getTaskDesignInfo(task.title,
        iconName: task.iconName, colorCode: task.colorCode, isDark: isDark);

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
                      radius: 24,
                      backgroundColor: design.backgroundColor,
                      child: Icon(design.iconData,
                          color: design.iconColor, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A2A2A)
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(isDark ? 4 : 14),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF3A3A3A)
                                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.schedule,
                                size: 14,
                                color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              task.recommendedIntervalDays != null
                                  ? _formatIntervalSeconds(task.recommendedIntervalDays!)
                                  : '設定',
                              style: TextStyle(
                                fontSize: 13,
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

                // ── 計測中サブ情報 ──
                if (!isUnrecorded)
                  _SleepSubtitle(task: task, isRecording: true),

                // ── アラートタイマー設定（計測前）──
                if (isUnrecorded) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      DropdownButton<int>(
                        value: _alertTimerMinutes[task.id] ?? 5,
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
                          if (val != null) setState(() => _alertTimerMinutes[task.id] = val);
                        },
                      ),
                      Text(' でアラート',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ],

                // ── アラートカウントダウン（計測中）──
                if (_alertTimerRemaining.containsKey(task.id)) ...[
                  const SizedBox(height: 4),
                  Builder(builder: (context) {
                    final rem = _alertTimerRemaining[task.id]!;
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
                    // 開始 / 完了ボタン（全タスク共通タイマー形式）
                    if (isUnrecorded)
                      FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(96, 48),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        onPressed: _isProcessing ? null : () async {
                          setState(() => _isProcessing = true);
                          try {
                            await ref.read(taskProvider.notifier).startTask(task.id);
                            _startAlertTimer(task.id, _alertTimerMinutes[task.id] ?? 5);
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
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(96, 48),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        onPressed: _isProcessing ? null : () async {
                          final result = await _showCompleteDialog(context);
                          if (result == null) return;
                          setState(() => _isProcessing = true);
                          try {
                            _cancelAlertTimer(task.id);
                            await ref.read(taskProvider.notifier).recordTaskExecution(
                              task.id,
                              startedAt: task.lastRecordedAt,
                              value: result.value,
                              unit: result.unit,
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

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

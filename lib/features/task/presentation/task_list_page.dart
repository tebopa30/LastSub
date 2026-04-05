import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../core/services/breast_notification_service.dart';
import '../../../core/providers/premium_provider.dart';
import '../application/task_notifier.dart';
import '../application/active_sessions_provider.dart';
import '../domain/task_entity.dart';
import '../../../core/providers/database_provider.dart';
import 'task_design_helper.dart';
import 'widgets/add_task_modal.dart';
import '../../history/presentation/history_page.dart';
import '../../settings/presentation/settings_page.dart';
import '../../premium/presentation/premium_page.dart';

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

  if (days >= 7) return '前回から $days日経過';
  if (days >= 1) return '前回から $days日 $hours時間経過';
  if (hours >= 1) return '前回から $hours時間 $minutes分経過';
  return '前回から $minutes分経過';
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

  /// アラートタイマー設定値（taskId → 数値）
  final Map<String, int> _alertTimerValue = {};

  /// アラートタイマー単位（taskId → '秒'|'分'|'時間'|'日'）
  final Map<String, String> _alertTimerUnit = {};

  /// カウントアップ経過秒（taskId → 秒）
  final Map<String, int> _alertTimerElapsed = {};

  /// アラート Timer インスタンス
  final Map<String, Timer> _alertTimers = {};

  /// 手動記録用の日時（taskId → DateTime）。未設定なら現在時刻を使用。
  final Map<String, DateTime?> _customRecordedAt = {};

  /// マニュアル記録の経過分数（タイマー前回から何分の作業か）
  final Map<String, int> _manualDurationMinutes = {};

  // ── チュートリアル用 GlobalKey ──
  final GlobalKey _keyAddButton = GlobalKey();
  final GlobalKey _keyHistoryButton = GlobalKey();
  final GlobalKey _keySettingsButton = GlobalKey();

  @override
  void initState() {
    super.initState();
    _minuteTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
    // チュートリアルは build 後に実行
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowTutorial());
  }

  Future<void> _maybeShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('tutorial_shown') ?? false;
    if (shown || !mounted) return;
    await prefs.setBool('tutorial_shown', true);
    _showTutorial();
  }

  void _showTutorial() {
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'add_button',
        keyTarget: _keyAddButton,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (ctx, c) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('タスクを追加', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('「＋」ボタンで新しい記録タスクを作成できます。', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'history_button',
        keyTarget: _keyHistoryButton,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (ctx, c) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('記録履歴', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('過去の記録をカレンダーやグラフで確認できます。', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'settings_button',
        keyTarget: _keySettingsButton,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (ctx, c) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('設定', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('テーマ変更やプレミアムプランへのアップグレードができます。', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    ];

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.85,
      textSkip: 'スキップ',
      paddingFocus: 8,
      onFinish: () {},
      onSkip: () => true,
    ).show(context: context);
  }

  @override
  void dispose() {
    _minuteTimer?.cancel();
    for (final t in _alertTimers.values) {
      t.cancel();
    }
    super.dispose();
  }

  /// カウントアップタイマーを開始（計測開始ボタン用）
  void _startMeasurement(String taskId) {
    ref.read(taskProvider.notifier).startTask(taskId);
    _cancelAlertTimer(taskId);
    if (!mounted) return;
    setState(() => _alertTimerElapsed[taskId] = 0);
    _alertTimers[taskId] = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        _alertTimers.remove(taskId);
        return;
      }
      setState(() {
        _alertTimerElapsed[taskId] = (_alertTimerElapsed[taskId] ?? 0) + 1;
      });
      // 設定時間に達したらアラート
      final value = _alertTimerValue[taskId] ?? 0;
      final unit = _alertTimerUnit[taskId] ?? '分';
      if (value > 0) {
        final targetSecs = value * (_alertUnitToSeconds[unit] ?? 60);
        if ((_alertTimerElapsed[taskId] ?? 0) >= targetSecs) {
          t.cancel();
          _alertTimers.remove(taskId);
          if (mounted) _showAlertTimerAlert(taskId);
        }
      }
    });
  }

  /// カスタム日時を選択するピッカーを表示
  Future<void> _pickCustomDateTime(String taskId) async {
    final initial = _customRecordedAt[taskId] ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (pickedTime == null || !mounted) return;
    setState(() {
      _customRecordedAt[taskId] = DateTime(
        pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute,
      );
    });
  }

  // ── アラートタイマー ──────────────────────
  static const _alertUnits = ['秒', '分', '時間', '日'];
  static const _alertUnitToSeconds = {'秒': 1, '分': 60, '時間': 3600, '日': 86400};

  String _formatAlertSetting(String taskId) {
    final v = _alertTimerValue[taskId] ?? 5;
    final u = _alertTimerUnit[taskId] ?? '分';
    return '$v$u';
  }

  Future<void> _showAlertTimerDialog(String taskId) async {
    final currentValue = _alertTimerValue[taskId] ?? 5;
    final currentUnit = _alertTimerUnit[taskId] ?? '分';
    String selectedUnit = currentUnit;
    final controller = TextEditingController(text: currentValue.toString());

    final result = await showDialog<({int value, String unit})?>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('アラート時間を設定'),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: '数値',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: selectedUnit,
                isDense: true,
                items: _alertUnits
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setDialogState(() => selectedUnit = v);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () {
                final n = int.tryParse(controller.text.trim());
                if (n == null || n <= 0) return;
                Navigator.pop(ctx, (value: n, unit: selectedUnit));
              },
              child: const Text('設定'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (result == null || !mounted) return;
    setState(() {
      _alertTimerValue[taskId] = result.value;
      _alertTimerUnit[taskId] = result.unit;
    });
  }

  void _cancelAlertTimer(String taskId) {
    _alertTimers[taskId]?.cancel();
    _alertTimers.remove(taskId);
    if (mounted) {
      setState(() {
        _alertTimerElapsed.remove(taskId);
      });
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
        title: Text('$title タイマー終了',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        content: const Text('設定時間が経過しました。\n記録ボタンで完了してください。',
            style: TextStyle(fontSize: 16)),
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
  static const _availableUnits = ['ml', 'g', 'kg', 'cm', 'm', 'km', '歩', '回', '分', '時間', 'kcal'];

  Future<({double? value, String? unit})?> _showCompleteDialog(
      BuildContext context, String taskId, {bool isTimerMode = false}) async {
    double? inputValue;
    String selectedUnit = _availableUnits.first;
    bool useValue = false;
    final textController = TextEditingController();

    // マニュアルモード用: 作業時間（分）
    int manualMinutes = _manualDurationMinutes[taskId] ?? 0;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isTimerMode ? '計測終了・記録' : 'マニュアル記録'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isTimerMode) ...[
                // マニュアル: 作業時間（分）プルダウン
                Row(
                  children: [
                    const Text('作業時間:'),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: manualMinutes,
                      isDense: true,
                      items: [0, 1, 2, 3, 5, 10, 15, 20, 30, 45, 60]
                          .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(m == 0 ? '未設定' : '$m分')))
                          .toList(),
                      onChanged: (v) =>
                          setDialogState(() => manualMinutes = v ?? 0),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
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
    // マニュアルモード: manualMinutes を記憶
    if (!isTimerMode) {
      setState(() => _manualDurationMinutes[taskId] = manualMinutes);
    }
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
    if (!mounted) return;
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
    final isPremium = ref.watch(isPremiumProvider);
    final activeSessions = ref.watch(activeSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LAST SUB',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          if (!isPremium)
            IconButton(
              icon: const Icon(Icons.workspace_premium),
              tooltip: 'プレミアムプラン',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PremiumPage()),
              ),
            ),
          IconButton(
            key: _keyHistoryButton,
            icon: const Icon(Icons.history),
            tooltip: '記録履歴',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryPage()),
            ),
          ),
          IconButton(
            key: _keySettingsButton,
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
        data: (tasks) => _buildTaskList(context, tasks, isDark, activeSessions),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('エラー: $e')),
      ),
      bottomNavigationBar: isPremium ? null : const _BannerAdWidget(),
      floatingActionButton: FloatingActionButton(
        key: _keyAddButton,
        onPressed: () => _showAddTaskModal(context),
        tooltip: 'タスクを追加',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<TaskEntity> tasks, bool isDark, Map<String, DateTime> activeSessions) {
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
        return _buildTaskCard(context, task, isDark, activeSessions);
      },
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    TaskEntity task,
    bool isDark,
    Map<String, DateTime> activeSessions,
  ) {
    final isRecording = activeSessions.containsKey(task.id);
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
                                fontSize: 15,
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
                        height: 32,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(
                        elapsedText,
                        style: TextStyle(
                          fontSize: 22,
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

                // ── アラートタイマー設定（カウントアップ）──
                if (!isRecording) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _showAlertTimerDialog(task.id),
                        child: Text(
                          _formatAlertSetting(task.id),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(' でアラート',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ],

                // ── カウントアップタイマー表示（計測中）──
                if (_alertTimerElapsed.containsKey(task.id)) ...[
                  const SizedBox(height: 4),
                  Builder(builder: (context) {
                    final elapsed = _alertTimerElapsed[task.id]!;
                    final mm = (elapsed ~/ 60).toString().padLeft(2, '0');
                    final ss = (elapsed % 60).toString().padLeft(2, '0');
                    return Row(
                      children: [
                        Icon(Icons.timer, size: 13,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 4),
                        Text('$mm:$ss',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        const SizedBox(width: 4),
                        Text('計測中',
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            )),
                      ],
                    );
                  }),
                ],

                // ── 日時選択行（マニュアル記録用）──
                if (!_alertTimerElapsed.containsKey(task.id)) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _pickCustomDateTime(task.id),
                    child: Row(
                      children: [
                        Icon(Icons.edit_calendar_outlined,
                            size: 13,
                            color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          _customRecordedAt[task.id] != null
                              ? '${_customRecordedAt[task.id]!.year}/${_customRecordedAt[task.id]!.month.toString().padLeft(2, '0')}/${_customRecordedAt[task.id]!.day.toString().padLeft(2, '0')} ${_customRecordedAt[task.id]!.hour.toString().padLeft(2, '0')}:${_customRecordedAt[task.id]!.minute.toString().padLeft(2, '0')}'
                              : '未設定（現在時刻で記録）',
                          style: TextStyle(
                            fontSize: 12,
                            color: _customRecordedAt[task.id] != null
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        if (_customRecordedAt[task.id] != null) ...[
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => setState(() => _customRecordedAt[task.id] = null),
                            child: Icon(Icons.clear, size: 13,
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],

                // ── ボタン行 ──
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 計測開始ボタン（セッション開始してカウントアップ）
                    if (!isRecording) ...[
                      OutlinedButton.icon(
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: const Text('計測開始'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(96, 44),
                          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        onPressed: _isProcessing ? null : () {
                          _startMeasurement(task.id);
                        },
                      ),
                      const SizedBox(width: 8),
                      // 即時記録ボタン（マニュアル記録）
                      FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(80, 44),
                          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        onPressed: _isProcessing ? null : () async {
                          final result = await _showCompleteDialog(context, task.id, isTimerMode: false);
                          if (result == null || !mounted) return;
                          setState(() => _isProcessing = true);
                          try {
                            final recordedAt = _customRecordedAt[task.id];
                            final durationMins = _manualDurationMinutes[task.id] ?? 0;
                            final customStart = durationMins > 0 && recordedAt != null
                                ? recordedAt.subtract(Duration(minutes: durationMins))
                                : durationMins > 0
                                    ? DateTime.now().subtract(Duration(minutes: durationMins))
                                    : null;
                            await ref.read(taskProvider.notifier).recordTaskExecution(
                              task.id,
                              value: result.value,
                              unit: result.unit,
                              recordedAt: recordedAt,
                              customStartedAt: customStart,
                            );
                            setState(() => _customRecordedAt[task.id] = null);
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
                    ] else ...[
                      // 計測中: 終了して記録
                      FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(110, 48),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        onPressed: _isProcessing ? null : () async {
                          final result = await _showCompleteDialog(context, task.id, isTimerMode: true);
                          if (result == null || !mounted) return;
                          setState(() => _isProcessing = true);
                          try {
                            _cancelAlertTimer(task.id);
                            await ref.read(taskProvider.notifier).recordTaskExecution(
                              task.id,
                              value: result.value,
                              unit: result.unit,
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
                        child: const Text('計測終了・記録'),
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
// バナー広告ウィジェット（無料プランのみ表示）
// ──────────────────────────────────────────────
class _BannerAdWidget extends StatefulWidget {
  const _BannerAdWidget();

  @override
  State<_BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<_BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  /// テスト用広告ユニットID。
  /// リリース時は実際の広告ユニットIDに差し替えること。
  static const _adUnitId = String.fromEnvironment(
    'ADMOB_BANNER_ID',
    defaultValue: 'ca-app-pub-3940256099942544/6300978111', // Android テストID
  );

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) return const SizedBox.shrink();
    return SafeArea(
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// アクティブセッション（開始済みで未完了のタスク）を管理する Notifier。
/// キー: taskId, 値: 開始時刻。アプリ再起動で消える揮発性データ。
class ActiveSessionsNotifier extends Notifier<Map<String, DateTime>> {
  @override
  Map<String, DateTime> build() => {};

  void startSession(String taskId) {
    state = {...state, taskId: DateTime.now()};
  }

  /// セッションを終了し、開始時刻を返す。セッションがなければ null を返す。
  DateTime? endSession(String taskId) {
    final startTime = state[taskId];
    state = Map.from(state)..remove(taskId);
    return startTime;
  }
}

final activeSessionsProvider =
    NotifierProvider<ActiveSessionsNotifier, Map<String, DateTime>>(
  ActiveSessionsNotifier.new,
);

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// 母乳タイマーのローカル通知を管理するサービス。
/// バックグラウンド・スリープ中でも指定時間後に通知を発火させる。
class BreastNotificationService {
  static final BreastNotificationService _instance =
      BreastNotificationService._();
  static BreastNotificationService get instance => _instance;
  BreastNotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
    debugPrint('[BreastNotification] 初期化完了');
  }

  /// [taskId] に紐付いたアラートタイマーを [minutes] 分後にスケジュールする。
  /// [taskTitle] が通知のタイトルに使用される。
  /// 同じ [taskId] の既存予約は上書きされる。
  Future<void> scheduleBreastAlert(String taskId, int minutes,
      {String taskTitle = 'タスク'}) async {
    if (!_initialized) await initialize();

    final notifId = _notifId(taskId);
    final scheduledTime =
        tz.TZDateTime.now(tz.local).add(Duration(minutes: minutes));

    const androidDetails = AndroidNotificationDetails(
      'task_timer_channel',
      'タスクタイマー',
      channelDescription: 'アラートタイマーが設定時間に達したときの通知',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: false,
    );
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.zonedSchedule(
      notifId,
      '$taskTitle アラート',
      '設定した $minutes 分が経過しました',
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    debugPrint('[Notification] タイマースケジュール: taskId=$taskId, $minutes 分後');
  }

  /// 推奨間隔（秒）が経過したタイミングで通知をスケジュールする。
  /// 記録完了後に呼び出すことで、次のサイクルの通知を設定する。
  Future<void> scheduleIntervalAlert(
      String taskId, String taskTitle, int intervalSeconds) async {
    if (!_initialized) await initialize();

    await cancelIntervalAlert(taskId); // 既存予約をクリア

    final notifId = _intervalNotifId(taskId);
    final scheduledTime =
        tz.TZDateTime.now(tz.local).add(Duration(seconds: intervalSeconds));

    final intervalStr = _formatIntervalSeconds(intervalSeconds);

    const androidDetails = AndroidNotificationDetails(
      'interval_alert_channel',
      '推奨間隔通知',
      channelDescription: '推奨間隔に達したときの通知',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: false,
    );
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.zonedSchedule(
      notifId,
      '$taskTitle の時間です',
      '推奨間隔（$intervalStr）が経過しました',
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    debugPrint('[Notification] 推奨間隔スケジュール: taskId=$taskId, $intervalStr 後');
  }

  /// [taskId] に紐付いたアラートタイマー予約をキャンセルする。
  Future<void> cancelBreastAlert(String taskId) async {
    if (!_initialized) return;
    final notifId = _notifId(taskId);
    await _plugin.cancel(notifId);
    debugPrint('[Notification] タイマーキャンセル: taskId=$taskId');
  }

  /// [taskId] に紐付いた推奨間隔通知をキャンセルする。
  Future<void> cancelIntervalAlert(String taskId) async {
    if (!_initialized) return;
    await _plugin.cancel(_intervalNotifId(taskId));
  }

  /// taskId をアラートタイマー通知 ID に変換する（0〜99999）
  int _notifId(String taskId) => taskId.hashCode.abs() % 100000;

  /// taskId を推奨間隔通知 ID に変換する（100000〜199999、タイマーIDと競合しない）
  int _intervalNotifId(String taskId) =>
      taskId.hashCode.abs() % 100000 + 100000;

  static String _formatIntervalSeconds(int seconds) {
    if (seconds >= 86400 && seconds % 86400 == 0) return '${seconds ~/ 86400}日';
    if (seconds >= 3600 && seconds % 3600 == 0) return '${seconds ~/ 3600}時間';
    if (seconds >= 60 && seconds % 60 == 0) return '${seconds ~/ 60}分';
    return '$seconds秒';
  }
}

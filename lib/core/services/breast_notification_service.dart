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

  /// [taskId] に紐付いた母乳アラートを [minutes] 分後にスケジュールする。
  /// 同じ [taskId] の既存予約は上書きされる。
  Future<void> scheduleBreastAlert(String taskId, int minutes) async {
    if (!_initialized) await initialize();

    final notifId = _notifId(taskId);
    final scheduledTime =
        tz.TZDateTime.now(tz.local).add(Duration(minutes: minutes));

    const androidDetails = AndroidNotificationDetails(
      'breast_timer_channel',
      '母乳タイマー',
      channelDescription: '母乳タイマーが設定時間に達したときの通知',
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
      '母乳タイマー',
      '$minutes分が経過しました',
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    debugPrint('[BreastNotification] スケジュール: taskId=$taskId, ${minutes}分後, notifId=$notifId');
  }

  /// [taskId] に紐付いた母乳アラート予約をキャンセルする。
  Future<void> cancelBreastAlert(String taskId) async {
    if (!_initialized) return;
    final notifId = _notifId(taskId);
    await _plugin.cancel(notifId);
    debugPrint('[BreastNotification] キャンセル: taskId=$taskId, notifId=$notifId');
  }

  /// taskId を通知 ID（非負整数）に変換する
  int _notifId(String taskId) => taskId.hashCode.abs() % 100000;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return NotificationService(ref)..initialize();
}

class NotificationService {
  final Ref ref;

  NotificationService(this.ref);

  void initialize() {
    // ローカル通知のみ使用。Firebase Messaging は削除済み。
    // BreastNotificationService (flutter_local_notifications) は
    // main() で別途初期化済み。
  }
}

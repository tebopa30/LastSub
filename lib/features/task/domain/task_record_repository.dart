import 'task_record_entity.dart';

abstract class TaskRecordRepository {
  /// 特定のTaskに紐付く履歴を監視（日付降順など）する
  Stream<List<TaskRecordEntity>> watchRecordsForTask(String taskId);

  /// タスクの実行履歴を記録（追加）する。
  /// ※ SQLite等のData層はこのメソッド内でトランザクションを開始し、
  /// 単なるRecord保存だけでなく、親Taskの `lastRecordedAt` の更新も
  /// 一括して完了させる責務（保証）を持ちます。
  Future<void> addRecord(TaskRecordEntity record);

  /// 特定の履歴を削除する
  Future<void> deleteRecord(String recordId);

  /// 既存レコードを上書き更新する（時刻修正などに使用）
  Future<void> updateRecord(TaskRecordEntity record);

  // --- 以降、AI異常検知・統計分析用のクエリメソッド --- //

  /// 直近N日間の全タスク履歴を取得する（AIが傾向を学習・分析するための基礎データ）
  Future<List<TaskRecordEntity>> fetchRecentRecords({required DateTime since});

  /// 指定期間・指定タスクの集計データ（量など）を取得するなどに拡張可能
  Future<List<TaskRecordEntity>> fetchRecordsByPeriod(
      String taskId, DateTime start, DateTime end);
}

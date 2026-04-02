import 'task_entity.dart';

abstract class TaskRepository {
  /// タスク一覧を監視して取得（isActive = true なもの。並び順などを考慮）
  Stream<List<TaskEntity>> watchAllTasks();

  /// 新規作成・更新を兼ねる保存処理
  /// ※このタスクそのもののタイトル修正やアイコン変更などに利用
  Future<void> saveTask(TaskEntity task);

  /// 論理削除（isActive = false に更新する）
  Future<void> deleteTask(String id);
  
  /// TaskRecord追加時に、このTaskの lastRecordedAt を最新日時で更新する。
  /// ※ 履歴修正時などの単独更新用メソッドです。
  /// 新規の `addRecord` 時は、Data層内でトランザクション実行されるためこれは呼ばれません。
  Future<void> updateLastRecordedAt(String id, DateTime recordedAt);

  /// このTaskの lastRecordedAt を null にリセットする。
  Future<void> resetLastRecordedAt(String id);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_record_entity.freezed.dart';
part 'task_record_entity.g.dart';

@freezed
sealed class TaskRecordEntity with _$TaskRecordEntity {
  const factory TaskRecordEntity({
    required String id,          // UUID
    required String taskId,      // 紐づく TaskEntity の ID
    required DateTime recordedAt,// 実行日時（AI統計の要）
    DateTime? startedAt,         // 開始時刻（睡眠タスク専用: startTask で記録した lastRecordedAt）
    double? value,               // 量や時間（ミルク100mlなら100, 睡眠120分なら120など）
    String? unit,                // "ml", "mins", "times" など
    String? memo,                // ユーザーが入力したフリーテキストメモ
    @Default(true) bool isActive, // 論理削除フラグ
    required DateTime createdAt,
    required DateTime updatedAt, // 更新日時（同期競合解決用）
  }) = _TaskRecordEntity;

  factory TaskRecordEntity.fromJson(Map<String, dynamic> json) => _$TaskRecordEntityFromJson(json);
}

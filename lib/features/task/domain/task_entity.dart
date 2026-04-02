import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';
part 'task_entity.g.dart';

@freezed
sealed class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    required String id,
    required String title,
    String? iconName,
    String? colorCode,
    @Default(true) bool isActive,
    @Default(false) bool isPremiumLocked,
    @Default(0) int order,
    DateTime? lastRecordedAt,
    /// 推奨間隔（日数）。null = 未設定
    int? recommendedIntervalDays,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TaskEntity;

  factory TaskEntity.fromJson(Map<String, dynamic> json) => _$TaskEntityFromJson(json);
}

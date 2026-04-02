import 'package:freezed_annotation/freezed_annotation.dart';

part 'growth_record_entity.freezed.dart';
part 'growth_record_entity.g.dart';

@freezed
sealed class GrowthRecordEntity with _$GrowthRecordEntity {
  const factory GrowthRecordEntity({
    required String id,
    required String userId, // 匿名認証のUIDなど
    required DateTime recordedAt, // 測定日または接種日
    double? height,
    double? weight,
    double? headCircumference,
    String? vaccinationName,
    String? memo,
    required DateTime updatedAt, // 双方向同期用
    @Default(true) bool isActive, // 論理削除用
  }) = _GrowthRecordEntity;

  factory GrowthRecordEntity.fromJson(Map<String, dynamic> json) =>
      _$GrowthRecordEntityFromJson(json);
}

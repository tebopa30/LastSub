// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_record_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GrowthRecordEntity _$GrowthRecordEntityFromJson(Map<String, dynamic> json) =>
    _GrowthRecordEntity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      headCircumference: (json['headCircumference'] as num?)?.toDouble(),
      vaccinationName: json['vaccinationName'] as String?,
      memo: json['memo'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$GrowthRecordEntityToJson(_GrowthRecordEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'recordedAt': instance.recordedAt.toIso8601String(),
      'height': instance.height,
      'weight': instance.weight,
      'headCircumference': instance.headCircumference,
      'vaccinationName': instance.vaccinationName,
      'memo': instance.memo,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isActive': instance.isActive,
    };

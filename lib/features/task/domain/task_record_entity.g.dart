// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_record_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskRecordEntity _$TaskRecordEntityFromJson(Map<String, dynamic> json) =>
    _TaskRecordEntity(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      value: (json['value'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      memo: json['memo'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TaskRecordEntityToJson(_TaskRecordEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'recordedAt': instance.recordedAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'value': instance.value,
      'unit': instance.unit,
      'memo': instance.memo,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

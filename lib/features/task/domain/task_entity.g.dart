// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskEntity _$TaskEntityFromJson(Map<String, dynamic> json) => _TaskEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      iconName: json['iconName'] as String?,
      colorCode: json['colorCode'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isPremiumLocked: json['isPremiumLocked'] as bool? ?? false,
      order: (json['order'] as num?)?.toInt() ?? 0,
      lastRecordedAt: json['lastRecordedAt'] == null
          ? null
          : DateTime.parse(json['lastRecordedAt'] as String),
      recommendedIntervalDays:
          (json['recommendedIntervalDays'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TaskEntityToJson(_TaskEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'iconName': instance.iconName,
      'colorCode': instance.colorCode,
      'isActive': instance.isActive,
      'isPremiumLocked': instance.isPremiumLocked,
      'order': instance.order,
      'lastRecordedAt': instance.lastRecordedAt?.toIso8601String(),
      'recommendedIntervalDays': instance.recommendedIntervalDays,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

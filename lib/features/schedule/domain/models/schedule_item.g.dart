// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleItem _$ScheduleItemFromJson(Map<String, dynamic> json) =>
    _ScheduleItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      dayOfWeek: (json['day_of_week'] as num).toInt(),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String?,
      type: json['type'] as String? ?? 'campus',
      location: json['location'] as String?,
      lecturer: json['lecturer'] as String?,
      sks: (json['sks'] as num?)?.toInt(),
      classGroup: json['class_group'] as String?,
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ScheduleItemToJson(_ScheduleItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'day_of_week': instance.dayOfWeek,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'type': instance.type,
      'location': instance.location,
      'lecturer': instance.lecturer,
      'sks': instance.sks,
      'class_group': instance.classGroup,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
    };

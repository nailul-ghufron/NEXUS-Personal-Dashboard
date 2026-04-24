// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) =>
    _ChecklistItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      isCompleted: json['is_completed'] as bool? ?? false,
      category: json['category'] as String? ?? 'daily',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ChecklistItemToJson(_ChecklistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'is_completed': instance.isCompleted,
      'category': instance.category,
      'sort_order': instance.sortOrder,
      'due_date': instance.dueDate?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

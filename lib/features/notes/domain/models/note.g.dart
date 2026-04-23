// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Note _$NoteFromJson(Map<String, dynamic> json) => _Note(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  title: json['title'] as String,
  content: json['content'] as String?,
  tint: json['tint'] as String? ?? 'neutral',
  lastModified: json['last_modified'] == null
      ? null
      : DateTime.parse(json['last_modified'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$NoteToJson(_Note instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'title': instance.title,
  'content': instance.content,
  'tint': instance.tint,
  'last_modified': instance.lastModified?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
};

import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
abstract class Note with _$Note {
  const factory Note({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    String? content,
    @Default('neutral') String tint,
    @JsonKey(name: 'last_modified') DateTime? lastModified,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'checklist_item.freezed.dart';
part 'checklist_item.g.dart';

@freezed
abstract class ChecklistItem with _$ChecklistItem {
  const factory ChecklistItem({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @Default('daily') String category,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ChecklistItem;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => _$ChecklistItemFromJson(json);
}

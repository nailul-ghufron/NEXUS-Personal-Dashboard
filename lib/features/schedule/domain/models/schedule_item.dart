import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_item.freezed.dart';
part 'schedule_item.g.dart';

@freezed
abstract class ScheduleItem with _$ScheduleItem {
  const factory ScheduleItem({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    @JsonKey(name: 'day_of_week') required int dayOfWeek,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') String? endTime,
    @Default('campus') String type,
    String? location,
    String? lecturer,
    int? sks,
    @JsonKey(name: 'class_group') String? classGroup,
    String? description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ScheduleItem;

  factory ScheduleItem.fromJson(Map<String, dynamic> json) => _$ScheduleItemFromJson(json);
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleItem {

 String get id;@JsonKey(name: 'user_id') String get userId; String get title;@JsonKey(name: 'day_of_week') int get dayOfWeek;@JsonKey(name: 'start_time') String get startTime;@JsonKey(name: 'end_time') String? get endTime; String get type; String? get location; String? get lecturer; int? get sks;@JsonKey(name: 'class_group') String? get classGroup; String? get description;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of ScheduleItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleItemCopyWith<ScheduleItem> get copyWith => _$ScheduleItemCopyWithImpl<ScheduleItem>(this as ScheduleItem, _$identity);

  /// Serializes this ScheduleItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.type, type) || other.type == type)&&(identical(other.location, location) || other.location == location)&&(identical(other.lecturer, lecturer) || other.lecturer == lecturer)&&(identical(other.sks, sks) || other.sks == sks)&&(identical(other.classGroup, classGroup) || other.classGroup == classGroup)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,dayOfWeek,startTime,endTime,type,location,lecturer,sks,classGroup,description,createdAt);

@override
String toString() {
  return 'ScheduleItem(id: $id, userId: $userId, title: $title, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, type: $type, location: $location, lecturer: $lecturer, sks: $sks, classGroup: $classGroup, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ScheduleItemCopyWith<$Res>  {
  factory $ScheduleItemCopyWith(ScheduleItem value, $Res Function(ScheduleItem) _then) = _$ScheduleItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String title,@JsonKey(name: 'day_of_week') int dayOfWeek,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String? endTime, String type, String? location, String? lecturer, int? sks,@JsonKey(name: 'class_group') String? classGroup, String? description,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$ScheduleItemCopyWithImpl<$Res>
    implements $ScheduleItemCopyWith<$Res> {
  _$ScheduleItemCopyWithImpl(this._self, this._then);

  final ScheduleItem _self;
  final $Res Function(ScheduleItem) _then;

/// Create a copy of ScheduleItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? dayOfWeek = null,Object? startTime = null,Object? endTime = freezed,Object? type = null,Object? location = freezed,Object? lecturer = freezed,Object? sks = freezed,Object? classGroup = freezed,Object? description = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,lecturer: freezed == lecturer ? _self.lecturer : lecturer // ignore: cast_nullable_to_non_nullable
as String?,sks: freezed == sks ? _self.sks : sks // ignore: cast_nullable_to_non_nullable
as int?,classGroup: freezed == classGroup ? _self.classGroup : classGroup // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleItem].
extension ScheduleItemPatterns on ScheduleItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleItem value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleItem value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String title, @JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String? endTime,  String type,  String? location,  String? lecturer,  int? sks, @JsonKey(name: 'class_group')  String? classGroup,  String? description, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleItem() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.dayOfWeek,_that.startTime,_that.endTime,_that.type,_that.location,_that.lecturer,_that.sks,_that.classGroup,_that.description,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String title, @JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String? endTime,  String type,  String? location,  String? lecturer,  int? sks, @JsonKey(name: 'class_group')  String? classGroup,  String? description, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ScheduleItem():
return $default(_that.id,_that.userId,_that.title,_that.dayOfWeek,_that.startTime,_that.endTime,_that.type,_that.location,_that.lecturer,_that.sks,_that.classGroup,_that.description,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String title, @JsonKey(name: 'day_of_week')  int dayOfWeek, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String? endTime,  String type,  String? location,  String? lecturer,  int? sks, @JsonKey(name: 'class_group')  String? classGroup,  String? description, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleItem() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.dayOfWeek,_that.startTime,_that.endTime,_that.type,_that.location,_that.lecturer,_that.sks,_that.classGroup,_that.description,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleItem implements ScheduleItem {
  const _ScheduleItem({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.title, @JsonKey(name: 'day_of_week') required this.dayOfWeek, @JsonKey(name: 'start_time') required this.startTime, @JsonKey(name: 'end_time') this.endTime, this.type = 'campus', this.location, this.lecturer, this.sks, @JsonKey(name: 'class_group') this.classGroup, this.description, @JsonKey(name: 'created_at') this.createdAt});
  factory _ScheduleItem.fromJson(Map<String, dynamic> json) => _$ScheduleItemFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String title;
@override@JsonKey(name: 'day_of_week') final  int dayOfWeek;
@override@JsonKey(name: 'start_time') final  String startTime;
@override@JsonKey(name: 'end_time') final  String? endTime;
@override@JsonKey() final  String type;
@override final  String? location;
@override final  String? lecturer;
@override final  int? sks;
@override@JsonKey(name: 'class_group') final  String? classGroup;
@override final  String? description;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of ScheduleItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleItemCopyWith<_ScheduleItem> get copyWith => __$ScheduleItemCopyWithImpl<_ScheduleItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.type, type) || other.type == type)&&(identical(other.location, location) || other.location == location)&&(identical(other.lecturer, lecturer) || other.lecturer == lecturer)&&(identical(other.sks, sks) || other.sks == sks)&&(identical(other.classGroup, classGroup) || other.classGroup == classGroup)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,dayOfWeek,startTime,endTime,type,location,lecturer,sks,classGroup,description,createdAt);

@override
String toString() {
  return 'ScheduleItem(id: $id, userId: $userId, title: $title, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, type: $type, location: $location, lecturer: $lecturer, sks: $sks, classGroup: $classGroup, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ScheduleItemCopyWith<$Res> implements $ScheduleItemCopyWith<$Res> {
  factory _$ScheduleItemCopyWith(_ScheduleItem value, $Res Function(_ScheduleItem) _then) = __$ScheduleItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String title,@JsonKey(name: 'day_of_week') int dayOfWeek,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String? endTime, String type, String? location, String? lecturer, int? sks,@JsonKey(name: 'class_group') String? classGroup, String? description,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$ScheduleItemCopyWithImpl<$Res>
    implements _$ScheduleItemCopyWith<$Res> {
  __$ScheduleItemCopyWithImpl(this._self, this._then);

  final _ScheduleItem _self;
  final $Res Function(_ScheduleItem) _then;

/// Create a copy of ScheduleItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? dayOfWeek = null,Object? startTime = null,Object? endTime = freezed,Object? type = null,Object? location = freezed,Object? lecturer = freezed,Object? sks = freezed,Object? classGroup = freezed,Object? description = freezed,Object? createdAt = freezed,}) {
  return _then(_ScheduleItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,lecturer: freezed == lecturer ? _self.lecturer : lecturer // ignore: cast_nullable_to_non_nullable
as String?,sks: freezed == sks ? _self.sks : sks // ignore: cast_nullable_to_non_nullable
as int?,classGroup: freezed == classGroup ? _self.classGroup : classGroup // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

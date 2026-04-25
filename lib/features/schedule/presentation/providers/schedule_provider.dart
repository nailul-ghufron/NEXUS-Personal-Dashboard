import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../../domain/models/schedule_item.dart';

part 'schedule_provider.g.dart';

@riverpod
class Schedule extends _$Schedule {
  @override
  FutureOr<List<ScheduleItem>> build() async {
    ref.keepAlive();
    return ref.watch(scheduleRepositoryProvider).getSchedules();
  }

  Future<void> addSchedule(ScheduleItem item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(scheduleRepositoryProvider).createSchedule(item);
      return ref.read(scheduleRepositoryProvider).getSchedules();
    });
  }

  Future<void> updateSchedule(ScheduleItem item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(scheduleRepositoryProvider).updateSchedule(item);
      return ref.read(scheduleRepositoryProvider).getSchedules();
    });
  }

  Future<void> removeSchedule(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(scheduleRepositoryProvider).deleteSchedule(id);
      return ref.read(scheduleRepositoryProvider).getSchedules();
    });
  }
}

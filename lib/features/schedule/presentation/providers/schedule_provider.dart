import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../../domain/models/schedule_item.dart';

part 'schedule_provider.g.dart';

@riverpod
class Schedule extends _$Schedule {
  @override
  FutureOr<List<ScheduleItem>> build() async {
    ref.keepAlive();
    final repo = ref.watch(scheduleRepositoryProvider);

    Future.microtask(() async {
      final freshData = await repo.fetchSchedulesFromNetwork();
      if (state.value != freshData) {
        state = AsyncData(freshData);
      }
    });

    return repo.getSchedules();
  }

  Future<void> addSchedule(ScheduleItem item) async {
    final previousState = state;
    if (previousState.hasValue) {
      state = AsyncData([...previousState.value!, item]);
    }
    state = await AsyncValue.guard(() async {
      await ref.read(scheduleRepositoryProvider).createSchedule(item);
      return ref.read(scheduleRepositoryProvider).getSchedules();
    });
  }

  Future<void> updateSchedule(ScheduleItem item) async {
    final previousState = state;
    if (previousState.hasValue) {
      state = AsyncData(previousState.value!.map((i) => i.id == item.id ? item : i).toList());
    }
    state = await AsyncValue.guard(() async {
      await ref.read(scheduleRepositoryProvider).updateSchedule(item);
      return ref.read(scheduleRepositoryProvider).getSchedules();
    });
  }

  Future<void> removeSchedule(String id) async {
    final previousState = state;
    if (previousState.hasValue) {
      state = AsyncData(previousState.value!.where((i) => i.id != id).toList());
    }
    state = await AsyncValue.guard(() async {
      await ref.read(scheduleRepositoryProvider).deleteSchedule(id);
      return ref.read(scheduleRepositoryProvider).getSchedules();
    });
  }
}

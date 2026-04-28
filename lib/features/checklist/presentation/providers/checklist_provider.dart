import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../../domain/models/checklist_item.dart';

part 'checklist_provider.g.dart';

@riverpod
class Checklist extends _$Checklist {
  @override
  FutureOr<List<ChecklistItem>> build() async {
    ref.keepAlive();
    final repo = ref.watch(checklistRepositoryProvider);
    
    // Reset daily tasks on app launch if the day has changed
    Future.microtask(() async {
      try {
        final cacheBox = Hive.box('cache');
        final String? lastResetStr = cacheBox.get('last_checklist_reset');
        final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
        
        if (lastResetStr != todayStr) {
          await resetDailyTasks();
          await cacheBox.put('last_checklist_reset', todayStr);
        }
      } catch (e) {
        // Ignore issues if box isn't ready
      }
    });
    
    // Fire and forget background network refresh
    Future.microtask(() async {
      final freshData = await repo.fetchChecklistsFromNetwork();
      if (state.value != freshData) {
        state = AsyncData(freshData);
      }
    });

    // Return cache immediately if available, or wait for network
    return repo.getChecklists();
  }

  Future<void> toggleItem(ChecklistItem item) async {
    final updatedItem = item.copyWith(isCompleted: !item.isCompleted);
    final previousItems = state.value ?? [];

    state = AsyncData(
      previousItems.map((i) => i.id == item.id ? updatedItem : i).toList(),
    );

    try {
      await ref.read(checklistRepositoryProvider).updateChecklist(updatedItem);
    } catch (e) {
      state = AsyncData(previousItems);
    }
  }

  Future<void> addItem(ChecklistItem item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(checklistRepositoryProvider).createChecklist(item);
      return ref.read(checklistRepositoryProvider).getChecklists();
    });
  }

  Future<void> removeItem(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(checklistRepositoryProvider).deleteChecklist(id);
      return ref.read(checklistRepositoryProvider).getChecklists();
    });
  }

  Future<void> resetDailyTasks() async {
    final items = state.value ?? [];
    final dailyToReset = items.where((i) => i.category == 'daily' && i.isCompleted).toList();
    
    if (dailyToReset.isEmpty) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      for (final item in dailyToReset) {
        await ref.read(checklistRepositoryProvider).updateChecklist(
          item.copyWith(isCompleted: false),
        );
      }
      return ref.read(checklistRepositoryProvider).getChecklists();
    });
  }
}

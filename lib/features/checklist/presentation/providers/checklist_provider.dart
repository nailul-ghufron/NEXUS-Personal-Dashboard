import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../../domain/models/checklist_item.dart';

part 'checklist_provider.g.dart';

@riverpod
class Checklist extends _$Checklist {
  @override
  FutureOr<List<ChecklistItem>> build() async {
    return ref.watch(checklistRepositoryProvider).getChecklists();
  }

  Future<void> toggleItem(ChecklistItem item) async {
    final updatedItem = item.copyWith(isCompleted: !item.isCompleted);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(checklistRepositoryProvider).updateChecklist(updatedItem);
      return ref.read(checklistRepositoryProvider).getChecklists();
    });
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
}

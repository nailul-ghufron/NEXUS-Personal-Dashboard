import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../../domain/models/note.dart';

part 'notes_provider.g.dart';

@riverpod
class Notes extends _$Notes {
  @override
  FutureOr<List<Note>> build() async {
    ref.keepAlive();
    final repo = ref.watch(notesRepositoryProvider);

    Future.microtask(() async {
      final freshData = await repo.fetchNotesFromNetwork();
      if (state.value != freshData) {
        state = AsyncData(freshData);
      }
    });

    return repo.getNotes();
  }

  Future<void> addNote(Note note) async {
    final previousState = state;
    if (previousState.hasValue) {
      state = AsyncData([...previousState.value!, note]);
    }
    state = await AsyncValue.guard(() async {
      await ref.read(notesRepositoryProvider).createNote(note);
      return ref.read(notesRepositoryProvider).getNotes();
    });
  }

  Future<void> updateNote(Note note) async {
    final updatedNote = note.copyWith(lastModified: DateTime.now());
    final previousState = state;
    if (previousState.hasValue) {
      state = AsyncData(previousState.value!.map((n) => n.id == note.id ? updatedNote : n).toList());
    }
    state = await AsyncValue.guard(() async {
      await ref.read(notesRepositoryProvider).updateNote(updatedNote);
      return ref.read(notesRepositoryProvider).getNotes();
    });
  }

  Future<void> removeNote(String id) async {
    final previousState = state;
    if (previousState.hasValue) {
      state = AsyncData(previousState.value!.where((n) => n.id != id).toList());
    }
    state = await AsyncValue.guard(() async {
      await ref.read(notesRepositoryProvider).deleteNote(id);
      return ref.read(notesRepositoryProvider).getNotes();
    });
  }
}

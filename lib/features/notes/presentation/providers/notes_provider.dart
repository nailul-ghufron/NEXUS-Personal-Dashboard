import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../../domain/models/note.dart';

part 'notes_provider.g.dart';

@riverpod
class Notes extends _$Notes {
  @override
  FutureOr<List<Note>> build() async {
    ref.keepAlive();
    return ref.watch(notesRepositoryProvider).getNotes();
  }

  Future<void> addNote(Note note) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(notesRepositoryProvider).createNote(note);
      return ref.read(notesRepositoryProvider).getNotes();
    });
  }

  Future<void> updateNote(Note note) async {
    final updatedNote = note.copyWith(lastModified: DateTime.now());
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(notesRepositoryProvider).updateNote(updatedNote);
      return ref.read(notesRepositoryProvider).getNotes();
    });
  }

  Future<void> removeNote(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(notesRepositoryProvider).deleteNote(id);
      return ref.read(notesRepositoryProvider).getNotes();
    });
  }
}

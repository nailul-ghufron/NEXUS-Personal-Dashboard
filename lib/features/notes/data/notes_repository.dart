import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/database/local_db_service.dart';
import '../domain/models/note.dart';

class NotesRepository {
  final SupabaseClient _client;
  final LocalDbService _localDb = LocalDbService();

  NotesRepository(this._client);

  List<Note> getCachedNotes() {
    final cachedData = _localDb.loadData('notes', (json) => Note.fromJson(json));
    if (cachedData != null) {
      return cachedData.cast<Note>();
    }
    return [];
  }

  Future<List<Note>> fetchNotesFromNetwork() async {
    try {
      await _syncOfflineQueue();
      final response = await _client
          .from('notes')
          .select()
          .order('last_modified', ascending: false);
      
      final items = (response as List).map((json) => Note.fromJson(json)).toList();
      await _localDb.saveData('notes', items);
      return items;
    } catch (e) {
      return getCachedNotes();
    }
  }

  Future<List<Note>> getNotes() async {
    final cached = getCachedNotes();
    if (cached.isNotEmpty) {
      fetchNotesFromNetwork(); // Background refresh
      return cached;
    }
    return await fetchNotesFromNetwork();
  }

  Future<void> createNote(Note note) async {
    try {
      await _client.from('notes').insert(note.toJson());
      final items = await getNotes();
      await _localDb.saveData('notes', items);
    } catch (e) {
      await _localDb.addToSyncQueue('notes', 'insert', note.toJson());
      final cached = _localDb.loadData('notes', (json) => Note.fromJson(json))?.cast<Note>() ?? [];
      cached.insert(0, note);
      await _localDb.saveData('notes', cached);
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _client.from('notes').update(note.toJson()).eq('id', note.id);
      final items = await getNotes();
      await _localDb.saveData('notes', items);
    } catch (e) {
      await _localDb.addToSyncQueue('notes', 'update', note.toJson());
      final cached = _localDb.loadData('notes', (json) => Note.fromJson(json))?.cast<Note>() ?? [];
      final index = cached.indexWhere((i) => i.id == note.id);
      if (index != -1) {
        cached[index] = note;
        await _localDb.saveData('notes', cached);
      }
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _client.from('notes').delete().eq('id', id);
      final items = await getNotes();
      await _localDb.saveData('notes', items);
    } catch (e) {
      await _localDb.addToSyncQueue('notes', 'delete', {'id': id});
      final cached = _localDb.loadData('notes', (json) => Note.fromJson(json))?.cast<Note>() ?? [];
      cached.removeWhere((i) => i.id == id);
      await _localDb.saveData('notes', cached);
    }
  }

  Future<void> _syncOfflineQueue() async {
    final queue = _localDb.getSyncQueue();
    if (queue.isEmpty) return;

    final notesQueue = queue.where((q) => q['table'] == 'notes').toList();
    if (notesQueue.isEmpty) return;

    for (final action in notesQueue) {
      try {
        final type = action['action'];
        final data = action['data'];
        if (type == 'insert') {
          await _client.from('notes').insert(data);
        } else if (type == 'update') {
          await _client.from('notes').update(data).eq('id', data['id']);
        } else if (type == 'delete') {
          await _client.from('notes').delete().eq('id', data['id']);
        }
      } catch (e) {
        // Ignore errors
      }
    }

    final remainingQueue = queue.where((q) => q['table'] != 'notes').toList();
    await _localDb.setSyncQueue(remainingQueue);
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/note.dart';

class NotesRepository {
  final SupabaseClient _client;

  NotesRepository(this._client);

  Future<List<Note>> getNotes() async {
    final response = await _client
        .from('notes')
        .select()
        .order('last_modified', ascending: false);
    
    return (response as List).map((json) => Note.fromJson(json)).toList();
  }

  Future<void> createNote(Note note) async {
    await _client.from('notes').insert(note.toJson());
  }

  Future<void> updateNote(Note note) async {
    await _client.from('notes').update(note.toJson()).eq('id', note.id);
  }

  Future<void> deleteNote(String id) async {
    await _client.from('notes').delete().eq('id', id);
  }
}

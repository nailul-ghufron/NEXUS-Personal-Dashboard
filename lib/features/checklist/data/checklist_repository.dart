import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/checklist_item.dart';

class ChecklistRepository {
  final SupabaseClient _client;

  ChecklistRepository(this._client);

  Future<List<ChecklistItem>> getChecklists() async {
    final response = await _client
        .from('checklist_items')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List).map((json) => ChecklistItem.fromJson(json)).toList();
  }

  Future<void> createChecklist(ChecklistItem item) async {
    await _client.from('checklist_items').insert(item.toJson());
  }

  Future<void> updateChecklist(ChecklistItem item) async {
    await _client.from('checklist_items').update(item.toJson()).eq('id', item.id);
  }

  Future<void> deleteChecklist(String id) async {
    await _client.from('checklist_items').delete().eq('id', id);
  }
}

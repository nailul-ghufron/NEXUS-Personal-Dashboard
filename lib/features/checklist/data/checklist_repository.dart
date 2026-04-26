import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/database/local_db_service.dart';
import '../domain/models/checklist_item.dart';

class ChecklistRepository {
  final SupabaseClient _client;
  final LocalDbService _localDb = LocalDbService();

  ChecklistRepository(this._client);

  List<ChecklistItem> getCachedChecklists() {
    final cachedData = _localDb.loadData('checklist_items', (json) => ChecklistItem.fromJson(json));
    if (cachedData != null) {
      return cachedData.cast<ChecklistItem>();
    }
    return [];
  }

  Future<List<ChecklistItem>> fetchChecklistsFromNetwork() async {
    try {
      await _syncOfflineQueue();
      final response = await _client
          .from('checklist_items')
          .select()
          .order('created_at', ascending: false);
      
      final items = (response as List).map((json) => ChecklistItem.fromJson(json)).toList();
      await _localDb.saveData('checklist_items', items);
      return items;
    } catch (e) {
      return getCachedChecklists();
    }
  }

  Future<List<ChecklistItem>> getChecklists() async {
    final cached = getCachedChecklists();
    if (cached.isNotEmpty) {
      fetchChecklistsFromNetwork(); // Background refresh
      return cached;
    }
    return await fetchChecklistsFromNetwork();
  }

  Future<void> createChecklist(ChecklistItem item) async {
    try {
      await _client.from('checklist_items').insert(item.toJson());
      // Update cache
      final items = await getChecklists();
      await _localDb.saveData('checklist_items', items);
    } catch (e) {
      // Save to offline queue
      await _localDb.addToSyncQueue('checklist_items', 'insert', item.toJson());
      // Optimistically update cache
      final cached = _localDb.loadData('checklist_items', (json) => ChecklistItem.fromJson(json))?.cast<ChecklistItem>() ?? [];
      cached.insert(0, item);
      await _localDb.saveData('checklist_items', cached);
    }
  }

  Future<void> updateChecklist(ChecklistItem item) async {
    try {
      await _client.from('checklist_items').update(item.toJson()).eq('id', item.id);
      // Update cache
      final items = await getChecklists();
      await _localDb.saveData('checklist_items', items);
    } catch (e) {
      // Save to offline queue
      await _localDb.addToSyncQueue('checklist_items', 'update', item.toJson());
      // Optimistically update cache
      final cached = _localDb.loadData('checklist_items', (json) => ChecklistItem.fromJson(json))?.cast<ChecklistItem>() ?? [];
      final index = cached.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        cached[index] = item;
        await _localDb.saveData('checklist_items', cached);
      }
    }
  }

  Future<void> deleteChecklist(String id) async {
    try {
      await _client.from('checklist_items').delete().eq('id', id);
      // Update cache
      final items = await getChecklists();
      await _localDb.saveData('checklist_items', items);
    } catch (e) {
      // Save to offline queue
      await _localDb.addToSyncQueue('checklist_items', 'delete', {'id': id});
      // Optimistically update cache
      final cached = _localDb.loadData('checklist_items', (json) => ChecklistItem.fromJson(json))?.cast<ChecklistItem>() ?? [];
      cached.removeWhere((i) => i.id == id);
      await _localDb.saveData('checklist_items', cached);
    }
  }

  Future<void> _syncOfflineQueue() async {
    final queue = _localDb.getSyncQueue();
    if (queue.isEmpty) return;

    final checklistQueue = queue.where((q) => q['table'] == 'checklist_items').toList();
    if (checklistQueue.isEmpty) return;

    for (final action in checklistQueue) {
      try {
        final type = action['action'];
        final data = action['data'];
        if (type == 'insert') {
          await _client.from('checklist_items').insert(data);
        } else if (type == 'update') {
          await _client.from('checklist_items').update(data).eq('id', data['id']);
        } else if (type == 'delete') {
          await _client.from('checklist_items').delete().eq('id', data['id']);
        }
      } catch (e) {
        // Ignore errors during sync, might be conflict. "Server Wins" policy means we can just drop it if it fails.
      }
    }

    // Remove synced items from queue
    final remainingQueue = queue.where((q) => q['table'] != 'checklist_items').toList();
    await _localDb.setSyncQueue(remainingQueue);
  }
}

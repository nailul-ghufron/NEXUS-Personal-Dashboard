import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/database/local_db_service.dart';
import '../domain/models/schedule_item.dart';

class ScheduleRepository {
  final SupabaseClient _client;
  final LocalDbService _localDb = LocalDbService();

  ScheduleRepository(this._client);

  List<ScheduleItem> getCachedSchedules() {
    final cachedData = _localDb.loadData('schedules', (json) => ScheduleItem.fromJson(json));
    if (cachedData != null) {
      return cachedData.cast<ScheduleItem>();
    }
    return [];
  }

  Future<List<ScheduleItem>> fetchSchedulesFromNetwork() async {
    try {
      await _syncOfflineQueue();
      final response = await _client
          .from('schedules')
          .select()
          .order('start_time', ascending: true);
      
      final items = (response as List).map((json) => ScheduleItem.fromJson(json)).toList();
      await _localDb.saveData('schedules', items);
      return items;
    } catch (e) {
      return getCachedSchedules();
    }
  }

  Future<List<ScheduleItem>> getSchedules() async {
    final cached = getCachedSchedules();
    if (cached.isNotEmpty) {
      fetchSchedulesFromNetwork(); // Background refresh
      return cached;
    }
    return await fetchSchedulesFromNetwork();
  }

  Future<void> createSchedule(ScheduleItem item) async {
    try {
      await _client.from('schedules').insert(item.toJson());
      final items = await getSchedules();
      await _localDb.saveData('schedules', items);
    } catch (e) {
      await _localDb.addToSyncQueue('schedules', 'insert', item.toJson());
      final cached = _localDb.loadData('schedules', (json) => ScheduleItem.fromJson(json))?.cast<ScheduleItem>() ?? [];
      cached.add(item);
      await _localDb.saveData('schedules', cached);
    }
  }

  Future<void> updateSchedule(ScheduleItem item) async {
    try {
      await _client.from('schedules').update(item.toJson()).eq('id', item.id);
      final items = await getSchedules();
      await _localDb.saveData('schedules', items);
    } catch (e) {
      await _localDb.addToSyncQueue('schedules', 'update', item.toJson());
      final cached = _localDb.loadData('schedules', (json) => ScheduleItem.fromJson(json))?.cast<ScheduleItem>() ?? [];
      final index = cached.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        cached[index] = item;
        await _localDb.saveData('schedules', cached);
      }
    }
  }

  Future<void> deleteSchedule(String id) async {
    try {
      await _client.from('schedules').delete().eq('id', id);
      final items = await getSchedules();
      await _localDb.saveData('schedules', items);
    } catch (e) {
      await _localDb.addToSyncQueue('schedules', 'delete', {'id': id});
      final cached = _localDb.loadData('schedules', (json) => ScheduleItem.fromJson(json))?.cast<ScheduleItem>() ?? [];
      cached.removeWhere((i) => i.id == id);
      await _localDb.saveData('schedules', cached);
    }
  }

  Future<void> _syncOfflineQueue() async {
    final queue = _localDb.getSyncQueue();
    if (queue.isEmpty) return;

    final scheduleQueue = queue.where((q) => q['table'] == 'schedules').toList();
    if (scheduleQueue.isEmpty) return;

    for (final action in scheduleQueue) {
      try {
        final type = action['action'];
        final data = action['data'];
        if (type == 'insert') {
          await _client.from('schedules').insert(data);
        } else if (type == 'update') {
          await _client.from('schedules').update(data).eq('id', data['id']);
        } else if (type == 'delete') {
          await _client.from('schedules').delete().eq('id', data['id']);
        }
      } catch (e) {
        // Ignore errors
      }
    }

    final remainingQueue = queue.where((q) => q['table'] != 'schedules').toList();
    await _localDb.setSyncQueue(remainingQueue);
  }
}

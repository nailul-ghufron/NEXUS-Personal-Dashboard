import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/schedule_item.dart';

class ScheduleRepository {
  final SupabaseClient _client;

  ScheduleRepository(this._client);

  Future<List<ScheduleItem>> getSchedules() async {
    final response = await _client
        .from('schedules')
        .select()
        .order('start_time', ascending: true);
    
    return (response as List).map((json) => ScheduleItem.fromJson(json)).toList();
  }

  Future<void> createSchedule(ScheduleItem item) async {
    await _client.from('schedules').insert(item.toJson());
  }

  Future<void> updateSchedule(ScheduleItem item) async {
    await _client.from('schedules').update(item.toJson()).eq('id', item.id);
  }

  Future<void> deleteSchedule(String id) async {
    await _client.from('schedules').delete().eq('id', id);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_providers.dart';
import '../data/schedule_repository.dart';
import '../data/checklist_repository.dart';
import '../data/notes_repository.dart';

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ScheduleRepository(client);
});

final checklistRepositoryProvider = Provider<ChecklistRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ChecklistRepository(client);
});

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return NotesRepository(client);
});

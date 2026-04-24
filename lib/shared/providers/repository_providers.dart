import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_dashboard/features/auth/presentation/auth_providers.dart';
import 'package:nexus_dashboard/features/schedule/data/schedule_repository.dart';
import 'package:nexus_dashboard/features/checklist/data/checklist_repository.dart';
import 'package:nexus_dashboard/features/notes/data/notes_repository.dart';

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


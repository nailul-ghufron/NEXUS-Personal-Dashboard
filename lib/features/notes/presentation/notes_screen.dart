import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/glass_input.dart';
import 'package:go_router/go_router.dart';
import 'providers/notes_provider.dart';
import 'widgets/note_card.dart';
import '../../ai_insight/data/gemini_service.dart';
import '../../../core/widgets/glass_card.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      backgroundColor: NexusColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Atmospheric backgrounds
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NexusColors.accentLavender.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(color: NexusColors.accentLavender.withValues(alpha: 0.1), blurRadius: 150),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NexusColors.accentViolet.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(color: NexusColors.accentViolet.withValues(alpha: 0.1), blurRadius: 150),
                  ],
                ),
              ),
            ),
            // Content
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: notesAsync.when(
                    data: (notes) {
                      final filteredNotes = notes.where((n) {
                        final query = _searchQuery.toLowerCase();
                        return n.title.toLowerCase().contains(query) || 
                               (n.content?.toLowerCase().contains(query) ?? false);
                      }).toList();

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                        child: Column(
                          children: [
                            _buildSearchInput(),
                            const SizedBox(height: 24),
                            _buildMasonryGrid(filteredNotes),
                          ],
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: NexusColors.accentLavender)),
                    error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'NOTES',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.64,
              color: NexusColors.textPrimary,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: NexusColors.accentLavender),
            tooltip: 'AI Summary',
            onPressed: () => _showAISummary(context, ref),
          ),
        ],
      ),
    );
  }

  void _showAISummary(BuildContext context, WidgetRef ref) async {
    final notesAsync = ref.read(notesProvider);
    final notes = notesAsync.value ?? [];
    
    if (notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No notes to summarize')),
      );
      return;
    }

    final noteTexts = notes.map((n) => '${n.title}: ${n.content ?? ''}').toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: NexusColors.accentLavender),
                  const SizedBox(width: 12),
                  Text(
                    'AI Insights',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: NexusColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FutureBuilder<String>(
                future: ref.read(geminiServiceProvider).summarizeNotes(noteTexts),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: NexusColors.accentLavender),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red));
                  }
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: SingleChildScrollView(
                      child: Text(
                        snapshot.data ?? 'No summary available.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: NexusColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NexusColors.accentLavender,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return GlassInput(
      hintText: 'Search notes...',
      prefixIcon: const Icon(Icons.search, color: NexusColors.textSecondary),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildMasonryGrid(List notes) {
    if (notes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            'No notes found.',
            style: GoogleFonts.inter(color: NexusColors.textSecondary),
          ),
        ),
      );
    }

    final leftCol = <Widget>[];
    final rightCol = <Widget>[];

    for (var i = 0; i < notes.length; i++) {
      final note = notes[i];
      final card = NoteCard(
        note: note,
        onTap: () => _showEditNote(context, note),
        onDelete: () => _confirmDelete(context, note.id),
      );
      if (i % 2 == 0) {
        leftCol.add(card);
      } else {
        rightCol.add(card);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(children: leftCol),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(children: rightCol),
        ),
      ],
    );
  }

  void _showEditNote(BuildContext context, dynamic note) {
    context.push('/note-editor', extra: note);
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NexusColors.background,
        title: Text('Delete Note?', style: GoogleFonts.inter(color: Colors.white)),
        content: Text('This action cannot be undone.', style: GoogleFonts.inter(color: NexusColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(color: NexusColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(notesProvider.notifier).removeNote(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

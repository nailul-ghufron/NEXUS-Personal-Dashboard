import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/glass_input.dart';
import 'providers/notes_provider.dart';
import 'widgets/note_card.dart';
import 'widgets/add_note_dialog.dart';

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
                  color: NexusColors.accentCyan.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(color: NexusColors.accentCyan.withValues(alpha: 0.1), blurRadius: 150),
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
                  color: NexusColors.accentBlue.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(color: NexusColors.accentBlue.withValues(alpha: 0.1), blurRadius: 150),
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
                    loading: () => const Center(child: CircularProgressIndicator(color: NexusColors.accentCyan)),
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
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: NexusColors.accentGrad,
              boxShadow: [
                BoxShadow(color: NexusColors.accentCyan.withValues(alpha: 0.4), blurRadius: 12),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddNoteDialog(),
                );
              },
            ),
          ),
        ],
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
      final card = NoteCard(note: notes[i]);
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
}

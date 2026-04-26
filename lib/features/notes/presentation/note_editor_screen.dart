import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/colors.dart';
import '../../auth/presentation/auth_providers.dart';
import '../domain/models/note.dart';
import 'providers/notes_provider.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final Note? note;
  const NoteEditorScreen({super.key, this.note});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _tint = 'neutral';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content ?? '';
      _tint = widget.note!.tint;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Save note on exit if there is content or title
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    
    if (title.isEmpty && content.isEmpty && widget.note == null) {
      return; // Don't save empty new notes
    }

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    if (_isSaving) return;
    _isSaving = true;

    final effectiveTitle = title.isEmpty ? 'Untiled Note' : title;

    if (widget.note != null) {
      final updatedNote = widget.note!.copyWith(
        title: effectiveTitle,
        content: content,
        tint: _tint,
        lastModified: DateTime.now(),
      );
      await ref.read(notesProvider.notifier).updateNote(updatedNote);
    } else {
      final newNote = Note(
        id: const Uuid().v4(),
        userId: user.id,
        title: effectiveTitle,
        content: content,
        tint: _tint,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
      );
      await ref.read(notesProvider.notifier).addNote(newNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _submit();
        return true;
      },
      child: Scaffold(
        backgroundColor: NexusColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: NexusColors.textPrimary),
            onPressed: () async {
              await _submit();
              if (mounted) context.pop();
            },
          ),
          actions: [
            _buildTintSelector(),
            IconButton(
              icon: const Icon(Icons.check, color: NexusColors.accentLavender),
              onPressed: () async {
                await _submit();
                if (mounted) context.pop();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: NexusColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: NexusColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: NexusColors.textSecondary,
                      height: 1.6,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Start writing...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16,
                        color: NexusColors.textSecondary.withValues(alpha: 0.5),
                      ),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTintSelector() {
    return PopupMenuButton<String>(
      icon: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getTintColor(_tint).withValues(alpha: 0.8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        ),
      ),
      color: NexusColors.surfaceGlass,
      onSelected: (value) => setState(() => _tint = value),
      itemBuilder: (context) => ['neutral', 'ocean', 'aurora', 'dusk', 'forest'].map((t) {
        return PopupMenuItem<String>(
          value: t,
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getTintColor(t),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                t[0].toUpperCase() + t.substring(1),
                style: GoogleFonts.inter(color: NexusColors.textPrimary),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getTintColor(String t) {
    switch (t) {
      case 'ocean': return const Color(0xFF0053DB);
      case 'aurora': return const Color(0xFF22D3EE);
      case 'dusk': return const Color(0xFF93000A);
      case 'forest': return const Color(0xFF22C55E);
      default: return Colors.grey;
    }
  }
}

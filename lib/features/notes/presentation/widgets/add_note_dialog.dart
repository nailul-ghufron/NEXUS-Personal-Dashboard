import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/glass_input.dart';
import '../../../auth/presentation/auth_providers.dart';
import '../../domain/models/note.dart';
import '../providers/notes_provider.dart';

class AddNoteDialog extends ConsumerStatefulWidget {
  final Note? note;
  const AddNoteDialog({super.key, this.note});

  @override
  ConsumerState<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends ConsumerState<AddNoteDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _tint = 'neutral';

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

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    if (widget.note != null) {
      final updatedNote = widget.note!.copyWith(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        tint: _tint,
      );
      ref.read(notesProvider.notifier).updateNote(updatedNote);
    } else {
      final newNote = Note(
        id: const Uuid().v4(),
        userId: user.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        tint: _tint,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
      );
      ref.read(notesProvider.notifier).addNote(newNote);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: NexusColors.background,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: NexusColors.glassBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.note != null ? 'Edit Note' : 'New Note',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: NexusColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            GlassInput(
              controller: _titleController,
              hintText: 'Title',
              autoFocus: true,
            ),
            const SizedBox(height: 16),
            GlassInput(
              controller: _contentController,
              hintText: 'Content...',
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Text(
              'Color Tint',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: NexusColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: ['neutral', 'ocean', 'aurora', 'dusk', 'forest'].map((t) {
                final isSelected = _tint == t;
                return GestureDetector(
                  onTap: () => setState(() => _tint = t),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getTintColor(t).withValues(alpha: 0.3),
                      border: Border.all(
                        color: isSelected ? Colors.white : _getTintColor(t).withValues(alpha: 0.5),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(color: NexusColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NexusColors.accentLavender,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Save',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/models/note.dart';

enum NoteTint { neutral, ocean, aurora, dusk, forest }

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color? borderColor;

    final tint = NoteTint.values.firstWhere(
      (e) => e.name == note.tint,
      orElse: () => NoteTint.neutral,
    );

    switch (tint) {
      case NoteTint.ocean:
        bgColor = const Color(0xFF0053DB).withValues(alpha: 0.1);
        borderColor = const Color(0xFF0053DB).withValues(alpha: 0.2);
        break;
      case NoteTint.aurora:
        bgColor = const Color(0xFF22D3EE).withValues(alpha: 0.08);
        borderColor = const Color(0xFF22D3EE).withValues(alpha: 0.15);
        break;
      case NoteTint.dusk:
        bgColor = const Color(0xFF93000A).withValues(alpha: 0.1);
        borderColor = const Color(0xFF93000A).withValues(alpha: 0.2);
        break;
      case NoteTint.forest:
        bgColor = const Color(0xFF22C55E).withValues(alpha: 0.08);
        borderColor = const Color(0xFF22C55E).withValues(alpha: 0.15);
        break;
      case NoteTint.neutral:
      default:
        bgColor = NexusColors.surfaceGlass;
        borderColor = NexusColors.glassBorder;
        break;
    }

    final formattedDate = note.lastModified != null 
        ? DateFormat('MMM dd').format(note.lastModified!)
        : 'Unknown';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: NexusColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            if (note.content != null)
              Text(
                note.content!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: NexusColors.textSecondary,
                  height: 1.5,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              formattedDate,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: NexusColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

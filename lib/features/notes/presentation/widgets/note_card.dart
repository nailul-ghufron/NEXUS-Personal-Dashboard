import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/glass_card.dart';

enum NoteTint { neutral, ocean, aurora, dusk, forest }

class NoteCard extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final NoteTint tint;

  const NoteCard({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    this.tint = NoteTint.neutral,
  });

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color? borderColor;

    switch (tint) {
      case NoteTint.ocean:
        bgColor = const Color(0xFF0053DB).withOpacity(0.1);
        borderColor = const Color(0xFF0053DB).withOpacity(0.2);
        break;
      case NoteTint.aurora:
        bgColor = const Color(0xFF22D3EE).withOpacity(0.08);
        borderColor = const Color(0xFF22D3EE).withOpacity(0.15);
        break;
      case NoteTint.dusk:
        bgColor = const Color(0xFF93000A).withOpacity(0.1);
        borderColor = const Color(0xFF93000A).withOpacity(0.2);
        break;
      case NoteTint.forest:
        bgColor = const Color(0xFF22C55E).withOpacity(0.08);
        borderColor = const Color(0xFF22C55E).withOpacity(0.15);
        break;
      case NoteTint.neutral:
      default:
        bgColor = NexusColors.surfaceGlass;
        borderColor = NexusColors.glassBorder;
        break;
    }

    return Container(
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
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: NexusColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: NexusColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            date,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: NexusColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

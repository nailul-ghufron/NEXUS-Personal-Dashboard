import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/glass_card.dart';

class TodayHabitsCard extends StatelessWidget {
  const TodayHabitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'KEBIASAAN HARI INI',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.4,
              color: NexusColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ),
        GlassCard(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: 0.5,
                          strokeWidth: 4,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          color: NexusColors.accentCyan,
                        ),
                        Center(
                          child: Text(
                            '50%',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: NexusColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mendekati Target',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: NexusColors.textPrimary,
                        ),
                      ),
                      Text(
                        '2 dari 4 kebiasaan selesai',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: NexusColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildHabitItem('Meditasi Pagi 10 Menit', true),
              const SizedBox(height: 8),
              _buildHabitItem('Review Flashcard Bahasa Inggris', true),
              const SizedBox(height: 8),
              _buildHabitItem('Membaca Buku 20 Halaman', false),
              const SizedBox(height: 8),
              _buildHabitItem('Latihan Soal Matematika Dasar', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHabitItem(String label, bool isDone) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isDone ? NexusColors.accentCyan.withOpacity(0.2) : Colors.transparent,
              border: Border.all(
                color: isDone ? NexusColors.accentCyan : Colors.white.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: isDone
                ? const Icon(Icons.check, size: 18, color: NexusColors.accentCyan)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: isDone ? NexusColors.textSecondary : NexusColors.textPrimary,
              decoration: isDone ? TextDecoration.lineThrough : null,
              decorationColor: Colors.white.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
